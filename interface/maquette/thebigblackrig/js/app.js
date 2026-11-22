/* The Big Black Rig — application (état, rendu, interactions). */
(() => {
'use strict';

/* =========================================================
 * Helpers DOM
 * ========================================================= */
const $ = (s, r = document) => r.querySelector(s);
const $$ = (s, r = document) => [...r.querySelectorAll(s)];
const SVGNS = 'http://www.w3.org/2000/svg';
const clamp = (v, a, b) => Math.min(b, Math.max(a, v));

function h(tag, attrs, ...kids) {
  const el = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs || {})) {
    if (v == null || v === false) continue;
    if (k === 'class') el.className = v;
    else if (k === 'style' && typeof v === 'object') Object.assign(el.style, v);
    else if (k.startsWith('--')) el.style.setProperty(k, v);
    else if (k.startsWith('on') && typeof v === 'function') el.addEventListener(k.slice(2), v);
    else if (k === 'value' && (tag === 'input' || tag === 'textarea')) el.value = v;
    else el.setAttribute(k, v === true ? '' : v);
  }
  for (const c of kids.flat(Infinity)) {
    if (c == null || c === false) continue;
    el.append(c.nodeType ? c : document.createTextNode(String(c)));
  }
  return el;
}
function svgEl(tag, attrs = {}) {
  const e = document.createElementNS(SVGNS, tag);
  for (const [k, v] of Object.entries(attrs)) e.setAttribute(k, v);
  return e;
}
const icon = n => { const s = svgEl('svg', { class: 'ic' }); s.append(svgEl('use', { href: '#i-' + n })); return s; };
/* glyph(idDeModèle) ou glyph(catégorie) */
const glyph = x => { const s = svgEl('svg', { viewBox: '0 0 24 24' }); s.innerHTML = MODEL_GLYPH[x] || CAT_GLYPH[x] || CAT_GLYPH[MODEL[x] && MODEL[x].cat] || ''; return s; };
const L = (lane, col) => LANE_LETTERS[lane] + (col + 1);

/* =========================================================
 * État persistant
 * ========================================================= */
const LS_KEY = 'tbbr.state.v1';
const GATT_DEFAULT = {
  namePrefix: 'BlackBox',
  service: '6e400001-b5a3-f393-e0a9-e50e24dcca9e',
  rx: '6e400002-b5a3-f393-e0a9-e50e24dcca9e',
  tx: '6e400003-b5a3-f393-e0a9-e50e24dcca9e',
};
const defaultGlobals = () => ({
  inGain: 0, inZ: 0, outLevel: 0, phones: 70, outMode: 0,
  geqLow: 0, geqMid: 0, geqHigh: 0, cabBypass: false,
  tempoMode: 0, bpm: 120,
  midiCh: 1, midiPC: true, midiClock: false, midiThru: false,
  btName: 'BlackBox-TBBR', btAudio: true,
  bright: 70, autoOff: 2, a4: 440,
  fsMode: 'scene', fsCombo: 'tuner', ui: 'auto', autoFs: true,
  gatt: { ...GATT_DEFAULT }, baud: 115200,
});

function loadState() {
  try {
    const j = JSON.parse(localStorage.getItem(LS_KEY));
    if (j && j.v === 1 && Array.isArray(j.presets) && j.presets.length === PRESETS) {
      j.globals = { ...defaultGlobals(), ...j.globals };
      j.globals.gatt = { ...GATT_DEFAULT, ...j.globals.gatt };
      if (!Array.isArray(j.irs) || j.irs.length !== IR_SLOTS) j.irs = factoryIRs();
      if (!Array.isArray(j.nams) || j.nams.length !== NAM_SLOTS) j.nams = Array(NAM_SLOTS).fill(null);
      return j;
    }
  } catch { /* état corrompu : on repart des presets d'usine */ }
  return null;
}
const freshState = () => ({ v: 1, presets: factoryPresets(), cur: 0, globals: defaultGlobals(), irs: factoryIRs(), irSel: 0, nams: Array(NAM_SLOTS).fill(null), namSel: 0, editAll: true });
let S = loadState() || freshState();

/* Liaison avec la page « Écran de la pédale » (ecran.php) ouverte dans un autre onglet */
const BC = 'BroadcastChannel' in window ? new BroadcastChannel('tbbr') : null;
let saveTimer;
function persist() {
  clearTimeout(saveTimer);
  saveTimer = setTimeout(() => {
    try { localStorage.setItem(LS_KEY, JSON.stringify(S)); if (BC) BC.postMessage({ type: 'state' }); }
    catch { toast('Stockage du navigateur plein : exporte une sauvegarde', 'err'); }
  }, 300);
}

/* État d'interface (non persistant) */
const U = {
  sel: { lane: 0, col: 2 }, view: 'grid', dirty: new Set(), clip: null, blockClip: null,
  search: '', tx: null, info: null, log: [], logPause: false, logStream: false,
  tuner: null, taps: [], lastTap: null, pickCat: 'amp', irCache: new Map(),
};

/* =========================================================
 * Accès au preset courant
 * ========================================================= */
const P = () => S.presets[S.cur];
const scene = () => P().scenes[P().scene];
const st = uid => scene().state[uid];
function blocks(p = P()) {
  const out = [];
  for (let l = 0; l < p.lanes.length; l++) for (let c = 0; c < COLS; c++) if (p.lanes[l][c]) out.push({ b: p.lanes[l][c], lane: l, col: c });
  return out;
}
const findBlock = (uid, p = P()) => blocks(p).find(x => x.b.uid === uid) || null;
/* Rangée A = chaîne principale ; rangée B = sections parallèles.
 * Chaque groupe de blocs contigus sur B est en parallèle des mêmes colonnes de A. */
const slotValid = () => true;
const laneOn = () => true;
const activeBlocks = (p = P()) => blocks(p);
function islands(p = P()) {
  const out = [];
  let s = -1;
  for (let c = 0; c <= COLS; c++) {
    const has = c < COLS && !!p.lanes[1][c];
    if (has && s < 0) s = c;
    if (!has && s >= 0) { out.push({ from: s, to: c, mix: p.par && p.par[s] != null ? p.par[s] : 50 }); s = -1; }
  }
  return out;
}
const islandAt = (c, p = P()) => islands(p).find(x => c >= x.from && c < x.to) || null;
const dspLoad = (p = P()) => activeBlocks(p).reduce((s, x) => s + MODEL[x.b.model].dsp, 0);
function selBlock() {
  if (!U.sel) return null;
  const lane = P().lanes[U.sel.lane], b = lane && lane[U.sel.col];
  return b && slotValid(U.sel.lane, U.sel.col) ? b : null;
}

/* =========================================================
 * Historique (annuler / rétablir)
 * ========================================================= */
const hist = [], fut = [];
let lastBurst = 0;
const snapshot = () => JSON.stringify({ i: S.cur, p: P() });
function pushHist() { hist.push(snapshot()); if (hist.length > 120) hist.shift(); fut.length = 0; updUndo(); }
function histBurst() { const n = performance.now(); if (n - lastBurst > 700) pushHist(); lastBurst = n; }
function restore(js) {
  const { i, p } = JSON.parse(js);
  S.presets[i] = p;
  S.cur = i;
  markDirty(i);
  syncPreset();
  renderAll();
}
function undo() { if (!hist.length) return; fut.push(snapshot()); restore(hist.pop()); updUndo(); }
function redo() { if (!fut.length) return; hist.push(snapshot()); restore(fut.pop()); updUndo(); }
function updUndo() { $('#btnUndo').disabled = !hist.length; $('#btnRedo').disabled = !fut.length; }

function markDirty(i = S.cur) {
  const was = U.dirty.has(i);
  U.dirty.add(i);
  persist();
  if (!was) { renderTop(); renderSidebar(); }
}

/* =========================================================
 * Communication avec la pédale
 * ========================================================= */
const connected = () => !!(U.tx && U.tx.connected);
function send(cmd, payload) { if (connected()) U.tx.send(cmd, payload); }

const throttles = new Map();
function throttled(key, fn, ms = 30) {
  let t = throttles.get(key);
  if (!t) { t = { last: 0, timer: 0, fn: null }; throttles.set(key, t); }
  t.fn = fn;
  const now = performance.now();
  if (now - t.last >= ms && !t.timer) { t.last = now; fn(); }
  else if (!t.timer) t.timer = setTimeout(() => { t.timer = 0; t.last = performance.now(); t.fn(); }, Math.max(0, ms - (now - t.last)));
}

function sendParam(uid, pid, v) {
  const loc = findBlock(uid);
  if (!loc) return;
  const pidx = MODEL[loc.b.model].params.findIndex(p => p.id === pid);
  throttled('p' + uid + pid, () => send(CMD.PARAM, paramPayload(loc.lane, loc.col, pidx, +v)));
}
function compactPreset(i = S.cur) {
  const p = S.presets[i];
  return {
    i, name: p.name, tempo: p.tempo, level: p.level, par: islands(p), scene: p.scene,
    lanes: p.lanes.map(l => l.map(b => b && b.model)),
    scenes: p.scenes.map(s => ({
      n: s.name,
      b: blocks(p).map(({ b, lane, col }) => [lane, col, +s.state[b.uid].on, ...MODEL[b.model].params.map(pd => +s.state[b.uid].p[pd.id])]),
    })),
  };
}
const syncPreset = () => send(CMD.PRESET_SET, compactPreset());

function makeTransport(kind) {
  const g = S.globals;
  if (kind === 'ble') return new BleTransport(g.gatt);
  if (kind === 'usb') return new SerialTransport({ baud: g.baud });
  return new DemoTransport();
}

async function connect(kind) {
  if (U.tx) await disconnect();
  const t = makeTransport(kind);
  U.tx = t;
  setConn('wait', 'Connexion…');
  t.on('tx', ({ cmd, raw }) => logFrame('tx', cmd, raw));
  t.on('frame', onFrame);
  t.on('open', () => {
    setConn(kind === 'demo' ? 'demo' : 'on', t.label);
    logSys('Connecté via ' + t.label);
    t.send(CMD.HELLO, { app: 'TBBR', ver: '0.1', proto: 1 });
  });
  t.on('close', () => {
    if (U.tx !== t) return;
    U.tx = null; U.info = null;
    setConn('off', 'Déconnecté');
    setMeters([0, 0]);
    logSys('Déconnecté');
    if (U.view === 'device') renderDevice();
  });
  t.on('error', e => logSys('Erreur : ' + (e && e.message || e)));
  try { await t.connect(); }
  catch (e) {
    if (U.tx === t) { U.tx = null; setConn('off', 'Déconnecté'); }
    if (e && e.name === 'NotFoundError') toast('Aucun appareil sélectionné');
    else toast('Connexion impossible : ' + (e && e.message || e), 'err');
    logSys('Échec de connexion : ' + (e && e.message || e));
  }
}
async function disconnect() { const t = U.tx; if (t) await t.disconnect(); }

function onFrame(fr) {
  if (fr.cmd === CMD.METER) setMeters(fr.payload);
  if (fr.cmd === CMD.TUNER_DATA) tunerData(fr.payload);
  logFrame('rx', fr.cmd, fr.raw, fr.payload);
  if (fr.cmd === CMD.INFO) {
    U.info = decodeJSON(fr.payload) || {};
    if (BC) BC.postMessage({ type: 'info', info: U.info });
    toast('Connecté à ' + (U.info.model || 'la pédale') + ' · ' + (U.info.fw || ''), 'ok');
    syncPreset();
    if (U.view === 'device') renderDevice();
  } else if (fr.cmd === CMD.NAK) {
    toast('Commande refusée par la pédale : ' + (CMD_NAME[fr.payload[0]] || fr.payload[0]), 'err');
  }
}

function setConn(state, label) {
  const b = $('#btnConnect');
  b.dataset.state = state;
  $('#connLabel').textContent = label;
  b.title = label;
}
function setMeters(pl) {
  $('#mIn').style.setProperty('--v', (pl[0] / 2.55).toFixed(1) + '%');
  $('#mOut').style.setProperty('--v', (pl[1] / 2.55).toFixed(1) + '%');
}

/* =========================================================
 * Console protocole
 * ========================================================= */
function logFrame(dir, cmd, raw, payload) {
  if (!U.logStream) {
    if (STREAM_CMDS.has(cmd)) return;
    if (cmd === CMD.ACK && payload && (STREAM_CMDS.has(payload[0]) || payload[0] === CMD.PARAM)) return;
    if (cmd === CMD.PARAM) return;
  }
  pushLog({ t: Date.now(), dir, cmd, raw });
}
const logSys = text => pushLog({ t: Date.now(), dir: 'sys', text });
function pushLog(e) {
  if (U.logPause) return;
  U.log.push(e);
  if (U.log.length > 600) U.log.shift();
  const c = $('#console');
  if (!c) return;
  const atBottom = c.scrollHeight - c.scrollTop - c.clientHeight < 30;
  c.append(logNode(e));
  while (c.childElementCount > 600) c.firstChild.remove();
  if (atBottom) c.scrollTop = c.scrollHeight;
}
function logNode(e) {
  const d = new Date(e.t);
  const ts = d.toTimeString().slice(0, 8) + '.' + String(d.getMilliseconds()).padStart(3, '0');
  const raw = e.raw ? (e.raw.length > 40 ? hex(e.raw.slice(0, 40)) + ` … (+${e.raw.length - 40})` : hex(e.raw)) : '';
  return h('div', { class: 'ln ' + e.dir },
    h('span', { class: 't' }, ts),
    h('span', { class: 'd' }, e.dir === 'sys' ? '··' : e.dir.toUpperCase()),
    e.dir === 'sys' ? h('span', { class: 'h' }, e.text)
      : [h('span', { class: 'c' }, CMD_NAME[e.cmd] || (e.cmd < 0 ? 'RAW' : '0x' + e.cmd.toString(16))), h('span', { class: 'h' }, raw)]);
}

/* =========================================================
 * Opérations sur les presets / blocs
 * ========================================================= */
function selectPreset(i) {
  S.cur = ((i % PRESETS) + PRESETS) % PRESETS;
  U.sel = null;
  persist();
  send(CMD.PRESET_SELECT, [S.cur]);
  renderAll();
  const row = $(`.prow[data-i="${S.cur}"]`);
  if (row) row.scrollIntoView({ block: 'nearest' });
}

function selectScene(i) {
  P().scene = i;
  persist();
  send(CMD.SCENE_SELECT, [i]);
  renderScenes();
  if (U.view === 'grid') { renderToolbar(); renderChain(); renderEditor(); }
  if (U.view === 'foot') renderFoot();
}

function savePreset() {
  if (!connected()) { toast('Pédale non connectée : modifications gardées dans le navigateur', 'err'); return; }
  send(CMD.PRESET_SAVE, [S.cur]);
  U.dirty.delete(S.cur);
  renderTop(); renderSidebar();
  toast('Preset ' + presetLabel(S.cur) + ' « ' + P().name + ' » sauvé sur la pédale', 'ok');
}

function selectSlot(l, c) {
  if (!U.sel || U.sel.lane !== l || U.sel.col !== c) U.edPage = 0;
  U.sel = { lane: l, col: c };
  renderChain(); renderEditor();
}

function addBlock(l, c, mid) {
  const p = P(), old = p.lanes[l][c];
  const extra = MODEL[mid].dsp - (old ? MODEL[old.model].dsp : 0);
  if (laneOn(l) && dspLoad() + extra > 100) { toast('DSP insuffisant pour ' + MODEL[mid].name, 'err'); return false; }
  pushHist();
  if (old) dropStates(old.uid);
  const b = { uid: uid(), model: mid }, def = defaultParams(mid);
  p.lanes[l][c] = b;
  p.scenes.forEach(s => { s.state[b.uid] = { on: true, p: { ...def } }; });
  U.sel = { lane: l, col: c };
  markDirty();
  send(CMD.BLOCK_SET, { lane: l, col: c, model: mid });
  renderGrid();
  return true;
}
function changeModel(id, mid) {
  const loc = findBlock(id);
  if (!loc || loc.b.model === mid) return;
  if (laneOn(loc.lane) && dspLoad() - MODEL[loc.b.model].dsp + MODEL[mid].dsp > 100) { toast('DSP insuffisant pour ' + MODEL[mid].name, 'err'); renderEditor(); return; }
  pushHist();
  loc.b.model = mid;
  const def = defaultParams(mid);
  P().scenes.forEach(s => { s.state[id].p = { ...def }; });
  markDirty();
  send(CMD.BLOCK_SET, { lane: loc.lane, col: loc.col, model: mid });
  renderGrid();
}
function dropStates(id) {
  const p = P();
  p.scenes.forEach(s => delete s.state[id]);
  if (p.exp.target.startsWith(id + ':')) p.exp.target = '';
}
function removeBlock(l, c) {
  const b = P().lanes[l][c];
  if (!b) return;
  pushHist();
  dropStates(b.uid);
  P().lanes[l][c] = null;
  markDirty();
  send(CMD.BLOCK_CLEAR, [l, c]);
  renderGrid();
}
function moveBlock(l1, c1, l2, c2) {
  const p = P();
  if (!slotValid(l2, c2)) return;
  pushHist();
  [p.lanes[l1][c1], p.lanes[l2][c2]] = [p.lanes[l2][c2], p.lanes[l1][c1]];
  U.sel = { lane: l2, col: c2 };
  markDirty();
  send(CMD.BLOCK_MOVE, [l1, c1, l2, c2]);
  renderGrid();
}
function toggleBypass(id) {
  const loc = findBlock(id);
  if (!loc) return;
  pushHist();
  const s = st(id);
  s.on = !s.on;
  markDirty();
  send(CMD.BYPASS, [loc.lane, loc.col, +s.on]);
  if (U.view === 'grid') { renderChain(); renderEditor(); }
  if (U.view === 'foot') renderFoot();
}
function setParam(id, pid, v) {
  const p = P();
  (S.editAll ? p.scenes : [scene()]).forEach(s => { if (s.state[id]) s.state[id].p[pid] = v; });
  markDirty();
  sendParam(id, pid, v);
}
function resetBlock(id) {
  const loc = findBlock(id);
  if (!loc) return;
  pushHist();
  const def = defaultParams(loc.b.model);
  (S.editAll ? P().scenes : [scene()]).forEach(s => { s.state[id].p = { ...def }; });
  markDirty();
  syncPreset();
  renderEditor();
}
function copyBlock(b = selBlock()) {
  if (!b) return;
  U.blockClip = { model: b.model, p: { ...st(b.uid).p } };
  toast(MODEL[b.model].name + ' copié · appui long sur une case vide pour le coller');
  renderEditor();
}
function pasteBlock(b = selBlock()) {
  if (!b || !U.blockClip || U.blockClip.model !== b.model) return;
  pushHist();
  (S.editAll ? P().scenes : [scene()]).forEach(s => { s.state[b.uid].p = { ...U.blockClip.p }; });
  markDirty();
  syncPreset();
  renderEditor();
}
/* Colle le bloc copié (modèle + réglages) dans une case */
function pasteBlockAt(l, c) {
  const clip = U.blockClip;
  if (!clip) return toast('Rien à coller : appui long sur un bloc → Copier le bloc');
  if (!addBlock(l, c, clip.model)) return;
  const b = P().lanes[l][c];
  P().scenes.forEach(s => { s.state[b.uid].p = { ...clip.p }; });
  syncPreset();
  if (isTab()) { U.sel = null; renderChain(); }
  renderEditor();
  toast(MODEL[clip.model].name + ' collé en ' + L(l, c), 'ok');
}
const buzz = (ms = 12) => { try { if (navigator.vibrate) navigator.vibrate(ms); } catch { /* */ } };
/* Appui long générique : retour visuel (.lp-hold), vibration, et le clic qui suit est absorbé. */
function longPress(el, onLong, onTap, ms = 550) {
  let t = 0, arm = 0, fired = false, x0 = 0, y0 = 0;
  const stop = () => { clearTimeout(t); clearTimeout(arm); el.classList.remove('lp-hold'); };
  el.addEventListener('pointerdown', e => {
    if (e.button !== 0) return;
    fired = false; x0 = e.clientX; y0 = e.clientY;
    arm = setTimeout(() => el.classList.add('lp-hold'), 130);
    t = setTimeout(() => { fired = true; stop(); buzz(); onLong(e); }, ms);
  });
  el.addEventListener('pointermove', e => { if (Math.hypot(e.clientX - x0, e.clientY - y0) > 10) stop(); });
  ['pointerup', 'pointerleave', 'pointercancel'].forEach(ev => el.addEventListener(ev, stop));
  el.addEventListener('click', e => {
    if (fired) { e.preventDefault(); e.stopImmediatePropagation(); fired = false; return; }
    if (onTap) onTap(e);
  });
  return el;
}

function setPresetField(key, v) {
  P()[key] = v;
  markDirty();
  if (key === 'tempo') { const bpm = Math.round(v); send(CMD.TEMPO, [bpm & 255, bpm >> 8]); const el = $('#bpmVal'); if (el) el.textContent = bpm; }
  else throttled('pf' + key, syncPreset, 120);
}

function sanitizePreset(p) {
  if (!p || !Array.isArray(p.lanes) || !Array.isArray(p.scenes)) throw new Error('format');
  const base = initPreset();
  const out = { ...base, ...p, exp: { ...base.exp, ...p.exp } };
  delete out.split; delete out.paths;
  const src = p.lanes || [];
  const fix = b => b && MODEL[b.model] ? { uid: String(b.uid || uid()), model: b.model } : null;
  out.lanes = [0, 1].map(l => Array.from({ length: COLS }, (_, c) => fix(src[l] && src[l][c])));
  /* anciennes rangées C/D (maquette précédente) : repliées sur B quand la case est libre */
  for (let l = 2; l < src.length; l++) (src[l] || []).forEach((b, c) => { const f = fix(b); if (f && !out.lanes[1][c]) out.lanes[1][c] = f; });
  out.par = p.par && typeof p.par === 'object' ? { ...p.par } : {};
  out.scenes = Array.from({ length: SCENES }, (_, i) => {
    const s = p.scenes[i] || {}, state = {};
    for (const { b } of blocks(out)) {
      const src = (s.state && s.state[b.uid]) || {};
      state[b.uid] = { on: src.on !== false, p: { ...defaultParams(b.model), ...src.p } };
    }
    return { name: String(s.name || SCENE_NAMES[i]).slice(0, 16), state };
  });
  out.scene = clamp(out.scene | 0, 0, SCENES - 1);
  if (!Array.isArray(out.fs) || out.fs.length < 4) out.fs = defaultFs(out);
  out.name = String(out.name || 'Import').slice(0, 20);
  return out;
}
function replacePreset(p, msg) {
  pushHist();
  S.presets[S.cur] = p;
  U.sel = null;
  markDirty();
  syncPreset();
  renderAll();
  if (msg) toast(msg, 'ok');
}

async function presetAction(a) {
  const p = P();
  if (a === 'copy') { U.clip = JSON.stringify(p); toast('Preset « ' + p.name + ' » copié'); }
  else if (a === 'paste') {
    if (!U.clip) return toast('Rien à coller : copie d’abord un preset');
    replacePreset(sanitizePreset(JSON.parse(U.clip)), 'Collé sur ' + presetLabel(S.cur));
  } else if (a === 'init') {
    if (await confirmBox('Réinitialiser ' + presetLabel(S.cur) + ' ?', 'Le preset « ' + p.name + ' » sera remplacé par un preset vide (Gate → Ampli → IR). Annulable avec Ctrl+Z.', 'Réinitialiser'))
      replacePreset(initPreset(), 'Preset réinitialisé');
  } else if (a === 'export') {
    download(presetLabel(S.cur) + '-' + slug(p.name) + '.tbbr.json', JSON.stringify({ format: 'tbbr-preset', version: 1, preset: p }, null, 1));
  } else if (a === 'import') {
    const f = await pickFile('.json,application/json');
    if (!f) return;
    try {
      const j = JSON.parse(await f.text());
      replacePreset(sanitizePreset(j.preset || j), 'Importé dans ' + presetLabel(S.cur));
    } catch { toast('Fichier de preset invalide', 'err'); }
  }
}
const slug = s => s.toLowerCase().normalize('NFD').replace(/[̀-ͯ]/g, '').replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '') || 'preset';

/* =========================================================
 * Rendu : barre du haut & liste des presets
 * ========================================================= */
function renderTop() {
  $('#pcNum').textContent = presetLabel(S.cur);
  const n = $('#pcName');
  if (document.activeElement !== n) n.value = P().name;
  $('#dirtyDot').classList.toggle('on', U.dirty.has(S.cur));
  $('#fsModeChip').textContent = FS_MODES[S.globals.fsMode].toUpperCase();
  renderDsp();
  updUndo();
}
function renderDsp() {
  const d = dspLoad();
  const bar = $('#dspBar');
  bar.style.width = Math.min(100, d) + '%';
  bar.style.background = d > 90 ? 'var(--bad)' : d > 70 ? 'var(--warn)' : 'var(--ok)';
  $('#dspVal').textContent = d + '%';
  $$('#blockLib .lib-item').forEach(el => el.classList.toggle('nodsp', +el.dataset.dsp > 100 - d));
}

function renderSidebar() {
  const list = $('#presetList'), q = U.search.trim().toLowerCase(), frag = document.createDocumentFragment();
  let lastBank = -1;
  S.presets.forEach((p, i) => {
    if (q && !p.name.toLowerCase().includes(q) && !presetLabel(i).toLowerCase().includes(q)) return;
    const bank = Math.floor(i / PER_BANK);
    if (bank !== lastBank) { frag.append(h('div', { class: 'bank-h' }, 'BANQUE ' + String(bank + 1).padStart(2, '0'))); lastBank = bank; }
    frag.append(h('div', { class: 'prow' + (i === S.cur ? ' active' : '') + (p.name === 'Init' ? ' init' : ''), 'data-i': i },
      h('span', { class: 'pn' }, presetLabel(i)),
      h('i', { class: 'pc', style: { background: p.color } }),
      h('span', { class: 'pname' }, p.name),
      U.dirty.has(i) ? h('i', { class: 'pd', title: 'Non sauvé sur la pédale' }) : null,
      h('div', { class: 'mini' }, p.lanes[0].filter(Boolean).map(b => h('i', { style: { background: CATS[MODEL[b.model].cat].color } })))));
  });
  list.textContent = '';
  list.append(frag);
}

/* =========================================================
 * Rendu : grille
 * ========================================================= */
function renderGrid() { renderTop(); renderToolbar(); renderChain(); renderEditor(); }

function renderToolbar() {
  const p = P(), tb = $('#gridToolbar'), n = islands(p).length;
  tb.textContent = '';
  tb.append(
    h('span', { class: 'chip' + (n ? ' on' : ''), title: 'Chaque groupe de blocs sur la rangée B est en parallèle des mêmes colonnes de A' },
      icon('split'), n ? n + ' section' + (n > 1 ? 's' : '') + ' parallèle' + (n > 1 ? 's' : '') : 'Pas de parallèle'),
    h('span', { class: 'tb-hint' }, 'Rangée B = parallèle · glisse sur le bord d’un bloc pour insérer, au centre pour échanger'),
    h('div', { class: 'ed-spacer' }),
    h('div', { class: 'tb-group' }, h('label', {}, 'Édition'),
      h('div', { class: 'seg accent' },
        h('button', { class: S.editAll ? 'on' : '', title: 'Les réglages s’appliquent à toutes les scènes', onclick: () => { S.editAll = true; persist(); renderToolbar(); } }, 'Toutes scènes'),
        h('button', { class: S.editAll ? '' : 'on', title: 'Les réglages ne concernent que la scène active', onclick: () => { S.editAll = false; persist(); renderToolbar(); } }, 'Scène ' + SCENE_LETTERS[p.scene] + ' seule'))));
}

function renderChain() {
  const p = P(), el = $('#chain');
  el.textContent = '';
  el.removeAttribute('style');
  el.append(svgEl('svg', { class: 'wires' }), h('div', { class: 'jack in' }, 'IN'), h('div', { class: 'jack out' }, 'OUT'),
    h('div', { class: 'path-tag', style: { gridRow: 2, gridColumn: 1 }, title: 'Rangée parallèle : chaque groupe de blocs ici est en parallèle de la rangée A' }, 'B'));
  for (let l = 0; l < 2; l++) for (let c = 0; c < COLS; c++) {
    const b = p.lanes[l][c], isSel = U.sel && U.sel.lane === l && U.sel.col === c;
    const slot = h('div', { class: 'slot', 'data-lane': l, 'data-col': c, style: { gridRow: l + 1, gridColumn: c + 2 } });
    if (b) slot.append(blockEl(b, l, c, isSel));
    else {
      slot.classList.add('empty');
      if (isSel) slot.classList.add('sel');
      slot.append(h('div', { class: 'plus' }, icon('plus')));
      longPress(slot, () => pasteBlockAt(l, c), () => { selectSlot(l, c); openPicker(l, c); });
    }
    el.append(slot);
  }
  requestAnimationFrame(drawWires);
  renderDsp();
}

function blockEl(b, l, c, isSel) {
  const m = MODEL[b.model], cat = CATS[m.cat], s = P().scenes[P().scene].state[b.uid] || { on: true };
  const el = h('div', { class: 'block' + (isSel ? ' sel' : '') + (s.on ? '' : ' byp'), '--c': cat.color, title: m.name + ' — double-tap : bypass, glisser : déplacer' },
    h('div', { class: 'b-top' },
      h('span', { class: 'b-cat' }, cat.short),
      h('button', { class: 'b-led', title: s.on ? 'Bypass' : 'Activer', onclick: e => { e.stopPropagation(); toggleBypass(b.uid); } })),
    h('div', { class: 'b-icon' }, glyph(m.id)),
    h('div', { class: 'b-name' }, m.name));
  attachBlockPointer(el, b, l, c);
  return el;
}

function attachBlockPointer(el, b, l, c) {
  el.addEventListener('pointerdown', e => {
    if (e.button !== 0 || e.target.closest('.b-led')) return;
    const r = el.getBoundingClientRect();
    beginDrag(e, {
      src: { lane: l, col: c }, w: r.width, h: r.height, el,
      onLong: () => blockActions(b, l, c),
      makeGhost: () => { const g = el.cloneNode(true); g.classList.add('ghost'); g.classList.remove('sel'); Object.assign(g.style, { width: r.width + 'px', height: r.height + 'px' }); return g; },
      onStart: () => el.classList.add('dragging'),
      onEnd: () => el.classList.remove('dragging'),
      onTap: () => {
        const now = performance.now();
        if (U.lastTap && U.lastTap.uid === b.uid && now - U.lastTap.t < 330) { U.lastTap = null; toggleBypass(b.uid); return; }
        U.lastTap = { uid: b.uid, t: now };
        selectSlot(l, c);
      },
    });
  });
}

function drawWires() {
  const el = $('#chain'), svg = el && el.querySelector('.wires');
  if (!svg || !el.offsetParent) return;
  const R = el.getBoundingClientRect();
  svg.setAttribute('viewBox', `0 0 ${R.width} ${R.height}`);
  svg.textContent = '';
  const rel = n => { const r = n.getBoundingClientRect(); return { l: r.left - R.left, r: r.right - R.left, cy: (r.top + r.bottom) / 2 - R.top }; };
  const slotAt = (l, c) => rel(slotEl(l, c));
  const jin = rel(el.querySelector('.jack.in')), jout = rel(el.querySelector('.jack.out')), y = jin.cy, yB = slotAt(1, 0).cy;
  const add = (d, cls) => svg.append(svgEl('path', { d, class: cls }));
  const dA = `M${jin.r} ${y}H${jout.l}`;
  add(dA, ''); add(dA, 'flow');
  islands().forEach(x => {
    const xs = x.from === 0 ? jin.r + 8 : (slotAt(0, x.from - 1).r + slotAt(0, x.from).l) / 2;
    const xm = x.to >= COLS ? jout.l - 8 : (slotAt(0, x.to - 1).r + slotAt(0, x.to).l) / 2;
    const r = Math.min(18, (yB - y) / 2);
    const d = `M${xs} ${y}V${yB - r}Q${xs} ${yB} ${xs + r} ${yB}H${xm - r}Q${xm} ${yB} ${xm} ${yB - r}V${y}`;
    add(d, 'b'); add(d, 'flow');
    [xs, xm].forEach(cx => svg.append(svgEl('circle', { cx, cy: y, r: 4, fill: '#19d3ff' })));
  });
}

/* =========================================================
 * Sections parallèles : balance A/B
 * ========================================================= */
function setBalance(from, mix) {
  const p = P();
  if (!p.par) p.par = {};
  p.par[from] = mix;
  markDirty();
  const x = islandAt(from);
  if (x) throttled('par' + from, () => send(CMD.SPLIT, [x.from, x.to, mix]));
}

/* =========================================================
 * Glisser-déposer (blocs de la grille et de la bibliothèque)
 * Sur un bloc : bord gauche/droit = insérer (les blocs s'écartent),
 * centre = échanger (ou remplacer depuis la bibliothèque). Case vide = poser.
 * ========================================================= */
const Drag = { R: null, moved: [], marked: null, hole: null };
const slotEl = (l, c) => $(`#chain .slot[data-lane="${l}"][data-col="${c}"]`);
function slotRects() {
  const R = [[], []];
  $$('#chain .slot').forEach(s => { R[+s.dataset.lane][+s.dataset.col] = s.getBoundingClientRect(); });
  return R;
}
function hitTest(x, y, src) {
  const R = Drag.R, gx = R[0][1].left - R[0][0].right, gy = R[1][0].top - R[0][0].bottom;
  for (let l = 0; l < 2; l++) {
    if (y < R[l][0].top - gy / 2 || y > R[l][0].bottom + gy / 2) continue;
    for (let c = 0; c < COLS; c++) {
      const r = R[l][c];
      if (x < r.left - gx / 2 || x >= r.right + gx / 2) continue;
      const isSrc = src && src.lane === l && src.col === c;
      if (isSrc) return null;
      if (!P().lanes[l][c]) return { mode: 'place', lane: l, col: c };
      const f = (x - r.left) / r.width;
      if (f < 0.3) return { mode: 'insert', lane: l, at: c };
      if (f > 0.7) return { mode: 'insert', lane: l, at: c + 1 };
      return { mode: 'swap', lane: l, col: c };
    }
  }
  return null;
}
/* Ouvre une case à la position `at` en poussant les blocs vers la case libre la plus proche. */
function planInsert(lane, at, src) {
  const row = P().lanes[lane].slice();
  if (src && src.lane === lane) row[src.col] = null;
  let eR = -1, eL = -1;
  for (let c = at; c < COLS; c++) if (!row[c]) { eR = c; break; }
  for (let c = at - 1; c >= 0; c--) if (!row[c]) { eL = c; break; }
  if (eR < 0 && eL < 0) return null;
  if (eR >= 0 && (eL < 0 || eR - at <= at - 1 - eL)) { // pousser vers la droite
    for (let c = eR; c > at; c--) row[c] = row[c - 1];
    row[at] = null;
    return { row, slot: at };
  }
  for (let c = eL; c < at - 1; c++) row[c] = row[c + 1]; // pousser vers la gauche
  row[at - 1] = null;
  return { row, slot: at - 1 };
}
function clearPreview() {
  Drag.moved.forEach(s => { s.style.transform = ''; });
  Drag.moved = [];
  if (Drag.marked) Drag.marked.classList.remove('drop');
  Drag.marked = null;
  if (Drag.hole) Drag.hole.remove();
  Drag.hole = null;
}
function preview(hit, src) {
  clearPreview();
  if (!hit) return;
  if (hit.mode !== 'insert') { Drag.marked = slotEl(hit.lane, hit.col); Drag.marked.classList.add('drop'); return; }
  const plan = planInsert(hit.lane, hit.at, src);
  if (!plan) return;
  const R = Drag.R, pitch = R[0][1].left - R[0][0].left, old = P().lanes[hit.lane];
  plan.row.forEach((b, c) => {
    if (!b) return;
    const oc = old.indexOf(b);
    if (oc >= 0 && oc !== c) { const s = slotEl(hit.lane, oc); s.style.transform = `translateX(${(c - oc) * pitch}px)`; Drag.moved.push(s); }
  });
  const r = R[hit.lane][plan.slot];
  Drag.hole = h('div', { class: 'drop-hole', style: { left: r.left + 'px', top: r.top + 'px', width: r.width + 'px', height: r.height + 'px' } });
  document.body.append(Drag.hole);
}
function commitDrop(hit, src, mid) {
  const p = P();
  if (hit.mode !== 'insert') {
    if (src) moveBlock(src.lane, src.col, hit.lane, hit.col);
    else addBlock(hit.lane, hit.col, mid);
    return;
  }
  const plan = planInsert(hit.lane, hit.at, src);
  if (!plan) return toast('Rangée pleine : libère une case pour insérer', 'err');
  if (mid && dspLoad() + MODEL[mid].dsp > 100) return toast('DSP insuffisant pour ' + MODEL[mid].name, 'err');
  pushHist();
  let b;
  if (src) {
    b = p.lanes[src.lane][src.col];
    if (src.lane !== hit.lane) p.lanes[src.lane][src.col] = null;
  } else {
    b = { uid: uid(), model: mid };
    const def = defaultParams(mid);
    p.scenes.forEach(s => { s.state[b.uid] = { on: true, p: { ...def } }; });
  }
  plan.row[plan.slot] = b;
  p.lanes[hit.lane] = plan.row;
  U.sel = { lane: hit.lane, col: plan.slot };
  markDirty();
  syncPreset();
  renderGrid();
}
function beginDrag(e, o) {
  const sx = e.clientX, sy = e.clientY, touch = e.pointerType !== 'mouse', hadSel = !!U.sel;
  let ghost = null, cancelled = false, hit = null, key = 'null';
  const fb = o.el;
  const arm = o.onLong ? setTimeout(() => fb && fb.classList.add('lp-hold'), 130) : 0;
  const lp = o.onLong ? setTimeout(() => { if (ghost) return; cancelled = true; if (fb) fb.classList.remove('lp-hold'); buzz(); o.onLong(); }, 550) : 0;
  const unarm = () => { clearTimeout(arm); clearTimeout(lp); if (fb) fb.classList.remove('lp-hold'); };
  const move = ev => {
    if (cancelled) return;
    const dx = ev.clientX - sx, dy = ev.clientY - sy;
    if (!ghost) {
      if (Math.hypot(dx, dy) < 7) return;
      unarm();
      if (o.lib && touch && Math.abs(dy) > Math.abs(dx)) { cancelled = true; return; } // défilement de la liste
      if (U.view !== 'grid') setView('grid');
      closeDrawer();
      Drag.R = slotRects();
      ghost = o.makeGhost();
      document.body.append(ghost);
      document.body.classList.add('dragging-any');
      if (o.onStart) o.onStart();
    }
    ghost.style.transform = `translate(${ev.clientX - o.w / 2}px, ${ev.clientY - o.h / 2}px) rotate(-2deg)`;
    const nh = hitTest(ev.clientX, ev.clientY, o.src), k = JSON.stringify(nh);
    if (k !== key) { key = k; hit = nh; preview(hit, o.src); }
  };
  const end = ev => {
    window.removeEventListener('pointermove', move);
    window.removeEventListener('pointerup', end);
    window.removeEventListener('pointercancel', end);
    if (ghost) {
      ghost.remove();
      clearPreview();
      document.body.classList.remove('dragging-any');
      if (o.onEnd) o.onEnd();
      if (hit && ev.type === 'pointerup') {
        commitDrop(hit, o.src, o.mid);
        /* en tactile, déplacer un bloc n'ouvre pas ses réglages (sauf si le tiroir était déjà ouvert) */
        if (isTab() && !hadSel && U.sel) { U.sel = null; renderChain(); renderEditor(); }
      }
      return;
    }
    unarm();
    if (ev.type === 'pointerup' && !cancelled && o.onTap) o.onTap();
  };
  window.addEventListener('pointermove', move);
  window.addEventListener('pointerup', end);
  window.addEventListener('pointercancel', end);
}

/* =========================================================
 * Bibliothèque de blocs (glisser-déposer)
 * ========================================================= */
function setSideTab(t) {
  S.sideTab = t;
  persist();
  $('#sidebar').dataset.tab = t;
  $$('#sideTabs button').forEach(b => b.classList.toggle('on', b.dataset.tab === t));
  const s = $('#presetSearch');
  s.value = t === 'blocks' ? U.libSearch || '' : U.search;
  s.placeholder = t === 'blocks' ? 'Rechercher un bloc' : 'Rechercher un preset';
  if (t === 'blocks') renderLibrary();
}

function renderLibrary() {
  const lib = $('#blockLib'), q = (U.libSearch || '').trim().toLowerCase(), free = 100 - dspLoad();
  lib.textContent = '';
  lib.append(h('div', { class: 'lib-hint' }, 'Glisse un bloc sur une case de la grille (une case occupée est remplacée). Un simple clic l’ajoute dans la case sélectionnée ou la première libre.'));
  for (const [cat, cd] of Object.entries(CATS)) {
    const models = MODELS.filter(m => m.cat === cat && (!q || m.name.toLowerCase().includes(q) || cd.name.toLowerCase().includes(q)));
    if (!models.length) continue;
    lib.append(h('div', { class: 'lib-cat', '--c': cd.color }, h('i'), cd.name),
      h('div', { class: 'lib-grid' }, models.map(m => {
        const el = h('div', { class: 'lib-item' + (m.dsp > free ? ' nodsp' : ''), '--c': cd.color, 'data-dsp': m.dsp, title: m.name + ' — DSP ' + m.dsp + '%' },
          h('b', {}, m.name), h('small', {}, glyph(m.id), 'DSP ' + m.dsp + '%'));
        attachLibDrag(el, m.id);
        return el;
      })));
  }
  if (!lib.querySelector('.lib-item')) lib.append(h('div', { class: 'lib-hint' }, 'Aucun bloc ne correspond.'));
}

function quickAdd(mid) {
  if (U.view !== 'grid') setView('grid');
  const p = P();
  let target = U.sel && slotValid(U.sel.lane, U.sel.col) && !(p.lanes[U.sel.lane] || [])[U.sel.col] ? U.sel : null;
  if (!target) { const c = p.lanes[0].indexOf(null); if (c >= 0) target = { lane: 0, col: c }; }
  if (!target) return toast('Plus de case libre sur le chemin A : glisse le bloc sur une case', 'err');
  if (addBlock(target.lane, target.col, mid)) { closeDrawer(); toast(MODEL[mid].name + ' ajouté en ' + L(target.lane, target.col)); }
}

function attachLibDrag(el, mid) {
  el.addEventListener('pointerdown', e => {
    if (e.button !== 0) return;
    const m = MODEL[mid], cat = CATS[m.cat];
    beginDrag(e, {
      mid, lib: true, w: 128, h: 92,
      makeGhost: () => h('div', { class: 'block ghost', '--c': cat.color, style: { width: '128px', height: '92px' } },
        h('div', { class: 'b-top' }, h('span', { class: 'b-cat' }, cat.short), h('span', { class: 'b-led' })),
        h('div', { class: 'b-icon' }, glyph(m.id)), h('div', { class: 'b-name' }, m.name)),
      onStart: () => el.classList.add('lifted'),
      onEnd: () => el.classList.remove('lifted'),
      onTap: () => quickAdd(mid),
    });
  });
}

/* =========================================================
 * Choix d'un bloc
 * ========================================================= */
function openPicker(l, c) {
  const cur = P().lanes[l][c];
  let cat = cur ? MODEL[cur.model].cat : U.pickCat;
  const cats = h('div', { class: 'pk-cats' }), models = h('div', { class: 'pk-models' });
  const draw = () => {
    cats.textContent = ''; models.textContent = '';
    for (const [id, cd] of Object.entries(CATS))
      cats.append(h('button', { class: 'pk-cat' + (id === cat ? ' on' : ''), '--c': cd.color, onclick: () => { cat = id; U.pickCat = id; draw(); } }, h('i'), cd.name));
    const free = 100 - dspLoad() + (cur ? MODEL[cur.model].dsp : 0);
    MODELS.filter(m => m.cat === cat).forEach(m => models.append(
      h('button', { class: 'pk-model', '--c': CATS[m.cat].color, disabled: m.dsp > free, title: m.dsp > free ? 'DSP insuffisant' : '',
        onclick: () => { if (addBlock(l, c, m.id)) md.close(); } },
        glyph(m.id), h('b', {}, m.name),
        h('small', {}, h('span', {}, m.params.length + ' param.'), h('span', {}, 'DSP ' + m.dsp + '%')))));
  };
  draw();
  const md = modal((cur ? 'Remplacer le bloc ' : 'Ajouter un bloc · ') + L(l, c), h('div', { class: 'picker' }, cats, models), { wide: true });
}

/* =========================================================
 * Potards & contrôles de paramètres
 * ========================================================= */
const decimals = step => step >= 1 ? 0 : step >= 0.1 ? 1 : 2;
const quant = (pd, v) => +(Math.round((v - pd.min) / pd.step) * pd.step + pd.min).toFixed(decimals(pd.step));
function fmt(pd, v) {
  const u = pd.unit;
  if (u === 'ms' && v >= 1000) return (v / 1000).toFixed(2) + ' s';
  if (u === 'Hz' && v >= 1000) return (v / 1000).toFixed(v >= 10000 ? 1 : 2) + ' k';
  let s = (+v).toFixed(decimals(pd.step));
  if (pd.min < 0 && v > 0) s = '+' + s;
  return s + (u === ':1' ? ':1' : u ? ' ' + u : '');
}
function polar(cx, cy, r, a) { const t = (a - 90) * Math.PI / 180; return [cx + r * Math.cos(t), cy + r * Math.sin(t)]; }
function arcPath(cx, cy, r, a0, a1) {
  const [x0, y0] = polar(cx, cy, r, a0), [x1, y1] = polar(cx, cy, r, a1);
  return `M${x0.toFixed(2)} ${y0.toFixed(2)}A${r} ${r} 0 ${a1 - a0 > 180 ? 1 : 0} 1 ${x1.toFixed(2)} ${y1.toFixed(2)}`;
}

function knob(pd, value, onChange, color) {
  const A0 = -135, A1 = 135;
  const el = h('div', { class: 'knob', tabindex: 0, '--c': color || 'var(--acc)', title: pd.name + ' — glisser, molette, double-clic = défaut' });
  const svg = svgEl('svg', { viewBox: '0 0 100 100' });
  const arc = svgEl('path', { class: 'k-arc' }), ptr = svgEl('line', { class: 'k-ptr', x1: 50, y1: 40, x2: 50, y2: 24 });
  svg.append(svgEl('path', { class: 'k-track', d: arcPath(50, 50, 44, A0, A1) }), arc, svgEl('circle', { class: 'k-body', cx: 50, cy: 50, r: 33 }), ptr);
  const val = h('div', { class: 'k-val' });
  el.append(val, svg, h('div', { class: 'k-label' }, pd.name));
  let v = value;
  const bip = pd.min < 0 && pd.max > 0;
  const upd = () => {
    const a = A0 + (v - pd.min) / (pd.max - pd.min) * (A1 - A0);
    const z = bip ? A0 + (-pd.min) / (pd.max - pd.min) * (A1 - A0) : A0;
    arc.setAttribute('d', Math.abs(a - z) < 0.5 ? '' : arcPath(50, 50, 44, Math.min(a, z), Math.max(a, z)));
    ptr.setAttribute('transform', `rotate(${a.toFixed(2)} 50 50)`);
    val.textContent = fmt(pd, v);
  };
  const set = nv => { nv = quant(pd, clamp(nv, pd.min, pd.max)); if (nv === v) return; v = nv; upd(); onChange(v); };
  upd();
  el.addEventListener('pointerdown', e => {
    if (e.button !== 0) return;
    e.preventDefault();
    el.focus({ preventScroll: true });
    el.setPointerCapture(e.pointerId);
    el.classList.add('active');
    const sy = e.clientY, sx = e.clientX, sv = v, range = pd.max - pd.min;
    let pushed = false;
    const lp = setTimeout(() => { if (pushed) return; histBurst(); set(pd.def); buzz(); el.classList.add('lp-done'); setTimeout(() => el.classList.remove('lp-done'), 350); }, 650);
    const mv = ev => {
      if (!pushed && Math.hypot(ev.clientX - sx, ev.clientY - sy) < 3) return;
      clearTimeout(lp);
      if (!pushed) { pushHist(); pushed = true; }
      set(sv + ((sy - ev.clientY) + (ev.clientX - sx) * 0.4) * (ev.shiftKey ? 0.0008 : 0.005) * range);
    };
    const up = () => { clearTimeout(lp); el.classList.remove('active'); el.removeEventListener('pointermove', mv); el.removeEventListener('pointerup', up); el.removeEventListener('pointercancel', up); };
    el.addEventListener('pointermove', mv); el.addEventListener('pointerup', up); el.addEventListener('pointercancel', up);
  });
  el.addEventListener('dblclick', () => { histBurst(); set(pd.def); });
  el.addEventListener('wheel', e => { e.preventDefault(); histBurst(); set(v + Math.sign(-e.deltaY) * pd.step * (e.shiftKey ? 1 : Math.max(1, Math.round((pd.max - pd.min) / pd.step / 100)))); }, { passive: false });
  el.addEventListener('keydown', e => {
    const s = pd.step * (e.shiftKey ? 10 : 1);
    if (e.key === 'ArrowUp' || e.key === 'ArrowRight') { e.preventDefault(); e.stopPropagation(); histBurst(); set(v + s); }
    else if (e.key === 'ArrowDown' || e.key === 'ArrowLeft') { e.preventDefault(); e.stopPropagation(); histBurst(); set(v - s); }
  });
  return el;
}

function chooser(title, opts, cur, color) {
  return new Promise(res => {
    let done = false;
    const md = modal(title, h('div', { class: 'choose-grid' }, opts.map(o => h('button', { class: 'choose-item' + (o.value === cur ? ' on' : ''), '--c': color || 'var(--acc)',
      onclick: () => { done = true; res(o.value); md.close(); } }, o.icon || null, h('b', {}, o.label), o.sub ? h('small', {}, o.sub) : null))),
      { onClose: () => { if (!done) res(null); } });
    md.el.classList.add('choose-modal');
  });
}
function pickButton(label, onPick, color, cls = 'pick-btn') {
  return h('button', { class: cls, '--c': color || 'var(--acc)', onclick: onPick }, h('span', {}, label), h('i', { class: 'caret' }));
}

function paramControl(pd, value, onChange, color) {
  if (isTab() && ((pd.type === 'select' && pd.options.length > 3) || pd.type === 'ir' || pd.type === 'nam')) {
    const lib = pd.type === 'ir' ? S.irs : pd.type === 'nam' ? S.nams : null;
    const opts = lib ? lib.map((x, i) => x ? { value: i, label: x.name, sub: String(i + 1).padStart(2, '0') + (pd.type === 'nam' ? (x.a2 ? ' · A2' : ' · A1') : '') } : null).filter(Boolean)
      : pd.options.map((o, i) => ({ value: i, label: o }));
    const cur = opts.find(o => o.value === value);
    return h('div', { class: 'pctl' },
      pickButton(cur ? cur.label : (lib ? 'Vide' : '—'), async () => {
        if (!opts.length) { S[pd.type === 'ir' ? 'irSel' : 'namSel'] = value; return setView(pd.type); }
        const v2 = await chooser(pd.name, opts, value, color);
        if (v2 != null && v2 !== value) { pushHist(); onChange(v2); renderEditor(); }
      }, color),
      h('div', { class: 'k-label' }, pd.type === 'nam' ? 'Capture NAM' : pd.type === 'ir' ? 'IR' : pd.name));
  }
  if (pd.type === 'select') {
    if (pd.options.length <= 3) {
      const box = h('div', { class: 'vseg', '--c': color });
      pd.options.forEach((o, i) => box.append(h('button', { class: i === value ? 'on' : '', onclick: () => {
        pushHist(); onChange(i); $$('button', box).forEach((b, j) => b.classList.toggle('on', j === i));
      } }, o)));
      return h('div', { class: 'pctl' }, box, h('div', { class: 'k-label' }, pd.name));
    }
    return h('div', { class: 'pctl' },
      h('select', { onchange: e => { pushHist(); onChange(+e.target.value); } }, pd.options.map((o, i) => h('option', { value: i, selected: i === value }, o))),
      h('div', { class: 'k-label' }, pd.name));
  }
  if (pd.type === 'bool') {
    const t = h('button', { class: 'toggle' + (value ? ' on' : ''), '--c': color, onclick: () => { pushHist(); value = !value; t.classList.toggle('on', value); onChange(value); } });
    return h('div', { class: 'pctl' }, h('div', { style: { height: '22px' } }), t, h('div', { class: 'k-label' }, pd.name));
  }
  if (pd.type === 'nam') {
    const cur = S.nams[value];
    return h('div', { class: 'pctl' },
      h('select', { onchange: e => { pushHist(); onChange(+e.target.value); } },
        cur ? null : h('option', { value, selected: true }, String(value + 1).padStart(2, '0') + ' · (vide)'),
        S.nams.map((n, i) => n ? h('option', { value: i, selected: i === value }, String(i + 1).padStart(2, '0') + ' · ' + n.name) : null)),
      h('button', { class: 'btn sm ghost', onclick: () => { S.namSel = value; setView('nam'); } }, icon('nam'), 'Captures'),
      h('div', { class: 'k-label' }, cur ? (cur.a2 ? 'A2 · ' : cur.arch + ' · ') + (cur.meta.gear_model || cur.meta.tone_type || 'capture') : 'Aucune capture'));
  }
  if (pd.type === 'ir') {
    return h('div', { class: 'pctl' },
      h('select', { onchange: e => { pushHist(); onChange(+e.target.value); } },
        S.irs.map((ir, i) => ir ? h('option', { value: i, selected: i === value }, String(i + 1).padStart(2, '0') + ' · ' + ir.name) : null)),
      h('button', { class: 'btn sm ghost', onclick: () => { S.irSel = value; setView('ir'); } }, icon('wave'), 'Bibliothèque'),
      h('div', { class: 'k-label' }, 'Réponse impulsionnelle'));
  }
  return knob(pd, value, onChange, color);
}

/* =========================================================
 * Éditeur de bloc / réglages du preset
 * ========================================================= */
function renderEditor() {
  const ed = $('#editor');
  ed.textContent = '';
  const b = selBlock();
  ed.classList.toggle('open', !!b);
  if (isTab()) { if (b) renderSheet(ed, b); return; }
  if (!b) { ed.append(...presetPanel()); return; }
  const m = MODEL[b.model], cat = CATS[m.cat], s = st(b.uid), { lane, col } = U.sel;
  const head = h('div', { class: 'ed-head', '--c': cat.color },
    h('span', { class: 'ed-cat' }, glyph(m.id), cat.short),
    h('select', { class: 'ed-model', title: 'Changer de modèle', onchange: e => changeModel(b.uid, e.target.value) },
      MODELS.filter(x => x.cat === m.cat).map(x => h('option', { value: x.id, selected: x.id === m.id }, x.name))),
    h('span', { class: 'ed-pos' }, L(lane, col) + ' · DSP ' + m.dsp + '%'),
    h('button', { class: 'power' + (s.on ? ' on' : ''), title: 'Bypass (Espace)', onclick: () => toggleBypass(b.uid) }, icon('power'), s.on ? 'ON' : 'BYPASS'),
    balanceCtl(col),
    h('span', { class: 'ed-pos hide-sm' }, S.editAll ? 'toutes scènes' : 'scène ' + SCENE_LETTERS[P().scene]),
    h('div', { class: 'ed-spacer' }),
    h('button', { class: 'icon-btn', title: 'Remplacer le bloc', onclick: () => openPicker(lane, col) }, icon('grid')),
    h('button', { class: 'icon-btn', title: 'Copier les réglages', onclick: () => copyBlock() }, icon('copy')),
    h('button', { class: 'icon-btn', title: 'Coller les réglages', disabled: !(U.blockClip && U.blockClip.model === b.model), onclick: () => pasteBlock() }, icon('paste')),
    h('button', { class: 'icon-btn', title: 'Valeurs par défaut', onclick: () => resetBlock(b.uid) }, icon('reset')),
    h('button', { class: 'icon-btn', title: 'Supprimer (Suppr)', onclick: () => removeBlock(lane, col) }, icon('trash')));
  const body = h('div', { class: 'ed-body' });
  m.params.forEach(pd => body.append(paramControl(pd, s.p[pd.id], v => setParam(b.uid, pd.id, v), cat.color)));
  ed.append(head, body);
}

/* Tablette : le bloc touché ouvre un tiroir de réglages (6 contrôles par page). */
const PAGE = 6;
function renderSheet(ed, b) {
  const m = MODEL[b.model], cat = CATS[m.cat], s = st(b.uid), { lane, col } = U.sel;
  const pages = Math.ceil(m.params.length / PAGE);
  U.edPage = clamp(U.edPage || 0, 0, pages - 1);
  const close = () => { U.sel = null; renderChain(); renderEditor(); };
  const head = h('div', { class: 'sh-head', '--c': cat.color },
    h('span', { class: 'sh-dot' }, glyph(m.id)),
    pickButton(m.name, async () => {
      const v2 = await chooser(cat.name, MODELS.filter(x => x.cat === m.cat).map(x => ({ value: x.id, label: x.name, sub: 'DSP ' + x.dsp + ' %', icon: glyph(x.id) })), m.id, cat.color);
      if (v2) changeModel(b.uid, v2);
    }, cat.color, 'pick-btn ed-pick'),
    h('button', { class: 'power' + (s.on ? ' on' : ''), onclick: () => toggleBypass(b.uid) }, icon('power'), s.on ? 'ON' : 'OFF'),
    balanceCtl(col),
    h('div', { class: 'ed-spacer' }),
    h('div', { class: 'seg' },
      h('button', { class: S.editAll ? 'on' : '', onclick: () => { S.editAll = true; persist(); renderEditor(); } }, 'Toutes scènes'),
      h('button', { class: S.editAll ? '' : 'on', onclick: () => { S.editAll = false; persist(); renderEditor(); } }, 'Scène ' + SCENE_LETTERS[P().scene])),
    h('button', { class: 'icon-btn', title: 'Plus d’actions', onclick: () => blockActions(b, lane, col) }, h('b', { style: { fontSize: '22px', lineHeight: '1' } }, '⋯')),
    h('button', { class: 'icon-btn', title: 'Fermer', onclick: close }, icon('close')));
  const body = h('div', { class: 'sh-body' });
  m.params.slice(U.edPage * PAGE, U.edPage * PAGE + PAGE).forEach(pd => body.append(paramControl(pd, s.p[pd.id], v => setParam(b.uid, pd.id, v), cat.color)));
  ed.append(head, body);
  if (pages > 1) ed.append(h('div', { class: 'sh-pages' },
    h('button', { class: 'icon-btn', disabled: U.edPage === 0, onclick: () => { U.edPage--; renderEditor(); } }, icon('left')),
    Array.from({ length: pages }, (_, i) => h('button', { class: 'sh-dotpage' + (i === U.edPage ? ' on' : ''), onclick: () => { U.edPage = i; renderEditor(); } })),
    h('button', { class: 'icon-btn', disabled: U.edPage === pages - 1, onclick: () => { U.edPage++; renderEditor(); } }, icon('right'))));
}
function blockActions(b, lane, col) {
  const on = st(b.uid) && st(b.uid).on;
  const A = (ic, label, fn, cls = '') => h('button', { class: 'menu-tile ' + cls, onclick: () => { md.close(); fn(); } }, icon(ic), h('b', {}, label));
  const md = modal(MODEL[b.model].name + ' · ' + L(lane, col), h('div', { class: 'menu-grid' },
    A('power', on ? 'Bypass' : 'Activer', () => toggleBypass(b.uid)),
    A('sliders', 'Réglages', () => selectSlot(lane, col)),
    A('grid', 'Remplacer', () => openPicker(lane, col)),
    A('copy', 'Copier le bloc', () => copyBlock(b)),
    U.blockClip && U.blockClip.model === b.model ? A('paste', 'Coller les réglages', () => pasteBlock(b)) : null,
    A('reset', 'Valeurs par défaut', () => resetBlock(b.uid)),
    A('trash', 'Supprimer', () => removeBlock(lane, col), 'danger')));
  md.el.classList.add('menu-modal');
}

function balanceCtl(col) {
  const x = islandAt(col);
  if (!x) return null;
  const span = (x.from === x.to - 1 ? 'colonne ' + (x.from + 1) : 'colonnes ' + (x.from + 1) + '–' + x.to);
  const txt = h('span', { class: 'mono' }, (100 - x.mix) + '/' + x.mix);
  return h('label', { class: 'bal', title: 'Balance A/B de la section parallèle (' + span + ')' }, 'A',
    h('input', { type: 'range', min: 0, max: 100, value: x.mix, onpointerdown: pushHist,
      oninput: e => { setBalance(x.from, +e.target.value); txt.textContent = (100 - e.target.value) + '/' + e.target.value; } }), 'B', txt);
}

function presetPanel() {
  const p = P();
  const sw = h('div', { class: 'swatches' }, PRESET_COLORS.map(c => h('button', { class: 'swatch' + (c === p.color ? ' on' : ''), style: { background: c }, title: 'Couleur du preset',
    onclick: () => { pushHist(); setPresetField('color', c); renderSidebar(); renderEditor(); } })));
  const head = h('div', { class: 'ed-head' },
    h('span', { class: 'ed-cat' }, 'PRESET'),
    h('span', { class: 'ed-title' }, presetLabel(S.cur) + ' · ' + p.name),
    h('span', { class: 'ed-pos' }, activeBlocks().length + ' blocs · ' + islands().length + ' parallèle(s) · DSP ' + dspLoad() + '%'),
    h('div', { class: 'ed-spacer' }), sw);
  const body = h('div', { class: 'ed-body' },
    knob(k('tempo', 'Tempo', 120, 40, 250, 1, 'bpm'), p.tempo, v => setPresetField('tempo', v)),
    knob(db('level', 'Volume', 0, -20, 6), p.level, v => setPresetField('level', v)),
    h('div', { class: 'ed-empty' },
      h('div', {}, h('b', {}, 'Touche une case vide (+) pour ajouter un bloc.')),
      h('div', { class: 'dim' }, 'Toucher un bloc : l’éditer · double-tap : bypass · glisser : déplacer · 1–8 : scènes · ← → : presets')));
  return [head, body];
}

/* =========================================================
 * Scènes & tap tempo
 * ========================================================= */
function renderScenes() {
  const sb = $('#scenebar'), p = P();
  sb.textContent = '';
  const grid = h('div', { class: 'scenes' });
  p.scenes.forEach((s, i) => {
    const btn = longPress(h('button', { class: 'scene' + (i === p.scene ? ' active' : ''), title: 'Scène ' + SCENE_LETTERS[i] + ' (' + (i + 1) + ') — appui long ou double-clic : renommer / copier',
      ondblclick: () => editScene(i) },
      h('b', {}, SCENE_LETTERS[i]), h('span', {}, s.name)), () => editScene(i), () => selectScene(i));
    grid.append(btn);
  });
  sb.append(h('div', { class: 'sb-label' }, 'SCÈNES'), grid,
    h('div', { class: 'tap' },
      h('button', { class: 'bpm', title: 'Saisir le tempo', onclick: async () => {
        const v = await askText('Tempo du preset (BPM)', String(Math.round(p.tempo)));
        if (v && !isNaN(+v)) { pushHist(); setPresetField('tempo', clamp(Math.round(+v), 40, 250)); renderScenes(); }
      } }, h('b', { id: 'bpmVal' }, Math.round(p.tempo)), h('small', {}, 'BPM')),
      tapButton()));
  if (isTab()) sb.prepend(h('button', { class: 'live-handle', title: 'Vue Live (ou glisse vers le haut)', onclick: openLive }, h('i')));
}
/* TAP : appui = tempo, maintien = accordeur */
function tapButton(cls = 'tap-btn', after) {
  let t = 0, held = false;
  return h('button', { class: cls, id: cls === 'tap-btn' ? 'tapBtn' : null, title: 'Tap tempo · maintenir : accordeur',
    onpointerdown: () => { held = false; t = setTimeout(() => { held = true; openTuner(); }, 600); },
    onpointerup: () => { clearTimeout(t); if (!held) { tap(); if (after) after(); } },
    onpointerleave: () => clearTimeout(t) }, 'TAP');
}

function editScene(i) {
  const p = P(), s = p.scenes[i];
  const inp = h('input', { type: 'text', value: s.name, maxlength: 16 });
  const copy = h('div', { class: 'row' }, h('span', { class: 'muted', style: { marginRight: '6px' } }, 'Copier vers'),
    p.scenes.map((_, j) => j === i ? null : h('button', { class: 'btn sm', onclick: () => {
      pushHist();
      p.scenes[j].state = JSON.parse(JSON.stringify(s.state));
      markDirty(); syncPreset();
      toast('Scène ' + SCENE_LETTERS[i] + ' copiée vers ' + SCENE_LETTERS[j], 'ok');
    } }, SCENE_LETTERS[j])));
  const md = modal('Scène ' + SCENE_LETTERS[i], [h('label', { class: 'muted' }, 'Nom'), inp, copy], {
    actions: [{ label: 'Annuler', cls: 'ghost' }, { label: 'Enregistrer', cls: 'primary', fn: () => apply() }],
  });
  const apply = () => {
    const n = inp.value.trim().slice(0, 16);
    if (n && n !== s.name) { pushHist(); s.name = n; markDirty(); syncPreset(); renderScenes(); }
  };
  inp.addEventListener('keydown', e => { if (e.key === 'Enter') { apply(); md.close(); } });
  setTimeout(() => { inp.focus(); inp.select(); }, 60);
}

function tap() {
  const n = performance.now();
  U.taps = U.taps.filter(t => n - t < 2200);
  U.taps.push(n);
  if (U.taps.length > 6) U.taps.shift();
  const b = $('#tapBtn');
  if (b) { b.classList.add('flash'); setTimeout(() => b.classList.remove('flash'), 90); }
  if (U.taps.length >= 2) {
    const iv = (U.taps[U.taps.length - 1] - U.taps[0]) / (U.taps.length - 1);
    if (U.taps.length === 2) pushHist();
    setPresetField('tempo', clamp(Math.round(60000 / iv), 40, 250));
  }
}

/* =========================================================
 * Vue Contrôles : footswitchs + expression
 * ========================================================= */
function fsActions() {
  const p = P();
  return [
    ['none', '—'], ['presetDown', 'Preset −'], ['presetUp', 'Preset +'], ['bankDown', 'Banque −'], ['bankUp', 'Banque +'],
    ['sceneDown', 'Scène précédente'], ['sceneUp', 'Scène suivante'], ['modeNext', 'Changer de mode (Preset/Scène/Stomp)'],
    ['tap', 'Tap tempo'], ['tuner', 'Accordeur'],
    ...p.scenes.map((s, i) => ['scene:' + i, 'Scène ' + SCENE_LETTERS[i] + ' · ' + s.name]),
    ...blocks(p).map(({ b, lane, col }) => ['block:' + b.uid, 'Bloc ' + L(lane, col) + ' · ' + MODEL[b.model].name]),
  ];
}
function actionLabel(a) { const f = fsActions().find(x => x[0] === a); return f ? f[1] : '—'; }

/* La Blackbox a 2 footswitchs physiques : 0 = gauche, 1 = droite. */
const FS_NAMES = ['Gauche', 'Droite'];
const FS_MODES = { preset: 'Preset', scene: 'Scène', stomp: 'Stomp' };
function fsResolve(i) {
  const g = S.globals, p = P();
  if (g.fsMode === 'preset') {
    return i === 0 ? { press: 'presetDown', hold: 'tuner', color: '#19d3ff', on: false } : { press: 'presetUp', hold: 'tap', color: '#19d3ff', on: false };
  }
  if (g.fsMode === 'scene') {
    return i === 0 ? { press: 'sceneDown', hold: 'presetDown', color: '#19d3ff', on: false } : { press: 'sceneUp', hold: 'presetUp', color: '#19d3ff', on: false };
  }
  const f = p.fs[i] || { press: 'none', hold: 'none', color: '#19d3ff' };
  let on = false;
  if (f.press.startsWith('block:')) { const s = st(f.press.slice(6)); on = !!(s && s.on); }
  else if (f.press.startsWith('scene:')) on = p.scene === +f.press.slice(6);
  return { ...f, on };
}

function doAction(a) {
  if (!a || a === 'none') return;
  const [t, arg] = a.split(':');
  const bank = Math.floor(S.cur / PER_BANK);
  switch (t) {
    case 'presetUp': selectPreset(S.cur + 1); break;
    case 'presetDown': selectPreset(S.cur - 1); break;
    case 'bankUp': selectPreset(((bank + 1) % BANKS) * PER_BANK); break;
    case 'bankDown': selectPreset(((bank - 1 + BANKS) % BANKS) * PER_BANK); break;
    case 'preset': selectPreset(bank * PER_BANK + +arg); break;
    case 'scene': selectScene(+arg); break;
    case 'sceneUp': selectScene((P().scene + 1) % SCENES); break;
    case 'sceneDown': selectScene((P().scene + SCENES - 1) % SCENES); break;
    case 'modeNext': { const ms = Object.keys(FS_MODES); setGlobal('fsMode', ms[(ms.indexOf(S.globals.fsMode) + 1) % ms.length]); toast('Mode footswitch : ' + FS_MODES[S.globals.fsMode]); renderTop(); if (U.view === 'foot') renderFoot(); break; }
    case 'block': toggleBypass(arg); break;
    case 'tap': tap(); break;
    case 'tuner': openTuner(); break;
  }
}

function setGlobal(key, v, rerender) {
  S.globals[key] = v;
  persist();
  throttled('g' + key, () => send(CMD.GLOBAL, { [key]: v }), 60);
  if (rerender) rerender();
}

function seg(options, value, onPick, cls = 'seg accent') {
  return h('div', { class: cls }, options.map(([v, label]) => h('button', { class: v === value ? 'on' : '', onclick: () => onPick(v) }, label)));
}

function renderFoot() {
  const v = $('#viewFoot'), g = S.globals, p = P();
  v.textContent = '';
  const page = h('div', { class: 'page' });
  page.append(h('div', { class: 'page-h' },
    h('div', {}, h('h2', {}, 'Footswitchs & expression'), h('p', {}, '2 footswitchs (gauche / droite) : appui, maintien, et appui simultané G + D. Clique-les pour tester.')),
    h('div', { class: 'ed-spacer' }),
    h('div', { class: 'tb-group' }, h('label', {}, 'Mode'), seg(Object.entries(FS_MODES), g.fsMode, m => setGlobal('fsMode', m, renderFoot)))));

  /* Pédale : 2 footswitchs physiques */
  const row = h('div', { class: 'fsw-row', style: { gridTemplateColumns: '1fr 1fr' } });
  for (let i = 0; i < 2; i++) {
    const f = fsResolve(i);
    let timer = 0, held = false;
    const btn = h('button', { class: 'fsw-btn', title: 'Footswitch ' + FS_NAMES[i].toLowerCase(),
      onpointerdown: () => { held = false; timer = setTimeout(() => { held = true; doAction(f.hold); }, 550); },
      onpointerup: () => { clearTimeout(timer); if (!held) doAction(f.press); },
      onpointerleave: () => clearTimeout(timer) });
    row.append(h('div', { class: 'fsw' },
      h('i', { class: 'fsw-led' + (f.on ? ' on' : ''), '--c': f.color }), btn,
      h('div', { class: 'fsw-cap' }, FS_NAMES[i] + ' · ' + actionLabel(f.press), h('small', {}, 'maintien : ' + actionLabel(f.hold)))));
  }
  page.append(h('div', { class: 'pedal', style: { width: 'min(560px, 100%)' } },
    h('div', { class: 'pedal-top' },
      h('span', { class: 'pedal-logo' }, 'BLACKBOX'),
      h('div', { class: 'lcd' },
        h('span', { class: 'l-num' }, presetLabel(S.cur)),
        h('div', { style: { minWidth: 0 } }, h('div', { class: 'l-name' }, p.name), h('div', { class: 'l-sub' }, FS_MODES[g.fsMode].toUpperCase() + ' · SCN ' + SCENE_LETTERS[p.scene] + ' ' + p.scenes[p.scene].name + ' · ' + Math.round(p.tempo) + ' BPM')))),
    row,
    h('div', { class: 'row', style: { justifyContent: 'center' } },
      h('button', { class: 'btn sm', title: 'Simuler l’appui simultané des deux footswitchs', onclick: () => doAction(g.fsCombo) }, 'G + D : ' + actionLabel(g.fsCombo)))));

  /* Affectations */
  const opts = sel => fsActions().map(([v, l]) => h('option', { value: v, selected: v === sel }, l));
  const cards = h('div', { class: 'fs-assign' });
  for (let i = 0; i < 2; i++) {
    const card = h('div', { class: 'card' }, h('h3', {}, icon('foot'), 'Footswitch ' + FS_NAMES[i].toLowerCase()));
    if (g.fsMode === 'stomp') {
      const f = p.fs[i];
      const upd = (key, val) => { pushHist(); f[key] = val; markDirty(); send(CMD.FS_CONFIG, { i, ...f }); renderFoot(); };
      card.append(
        h('div', { class: 'field' }, h('span', {}, 'Appui'), h('select', { onchange: e => upd('press', e.target.value) }, opts(f.press))),
        h('div', { class: 'field' }, h('span', {}, 'Maintien'), h('select', { onchange: e => upd('hold', e.target.value) }, opts(f.hold))),
        h('div', { class: 'field' }, h('span', {}, 'LED'), h('div', { class: 'swatches' }, PRESET_COLORS.map(c => h('button', { class: 'swatch' + (c === f.color ? ' on' : ''), style: { background: c }, onclick: () => upd('color', c) })))));
    } else {
      const f = fsResolve(i);
      card.append(h('div', { class: 'field' }, h('span', {}, 'Appui'), h('b', {}, actionLabel(f.press))),
        h('div', { class: 'field' }, h('span', {}, 'Maintien'), h('b', {}, actionLabel(f.hold))),
        h('p', { class: 'dim', style: { fontSize: '11.5px' } }, 'Passe en mode Stomp pour affecter librement ce switch (par preset).'));
    }
    cards.append(card);
  }
  cards.append(h('div', { class: 'card' }, h('h3', {}, icon('foot'), 'Appui simultané G + D'),
    h('div', { class: 'field' }, h('span', {}, 'Action'), h('select', { onchange: e => setGlobal('fsCombo', e.target.value, renderFoot) },
      fsActions().filter(([v]) => !v.startsWith('block:') && !v.startsWith('scene:')).map(([v, l]) => h('option', { value: v, selected: v === g.fsCombo }, l)))),
    h('p', { class: 'dim', style: { fontSize: '11.5px' } }, 'Réglage global, valable dans tous les modes. Par exemple, changer de mode ou ouvrir l’accordeur.')));
  page.append(cards);

  /* Expression */
  const targets = [['', '— Aucune —']];
  blocks(p).forEach(({ b, lane, col }) => MODEL[b.model].params.forEach(pd => { if (!pd.type) targets.push([b.uid + ':' + pd.id, L(lane, col) + ' ' + MODEL[b.model].name + ' · ' + pd.name]); }));
  const e = p.exp;
  const expOut = h('span', { class: 'mono muted' }, '—');
  const sim = h('input', { type: 'range', min: 0, max: 100, value: 0, disabled: !e.target, oninput: ev => {
    const [id, pid] = e.target.split(':'), loc = findBlock(id);
    if (!loc) return;
    const pd = MODEL[loc.b.model].params.find(x => x.id === pid);
    let t = +ev.target.value / 100;
    t = e.curve === 1 ? Math.log10(1 + 9 * t) : e.curve === 2 ? t * t : t;
    const pos = (e.min + (e.max - e.min) * t) / 100;
    const val = quant(pd, pd.min + (pd.max - pd.min) * pos);
    expOut.textContent = fmt(pd, val);
    sendParam(id, pid, val); // modulation en direct, n'écrit pas le preset
  } });
  const updExp = (key, val, re = true) => { if (re) pushHist(); e[key] = val; markDirty(); send(CMD.FS_CONFIG, { exp: e }); if (re) renderFoot(); };
  page.append(h('div', { class: 'card' },
    h('h3', {}, icon('sliders'), 'Pédale d’expression (EXP 1)'),
    h('div', { class: 'field' }, h('span', {}, 'Cible'), h('select', { onchange: ev => updExp('target', ev.target.value) }, targets.map(([v, l]) => h('option', { value: v, selected: v === e.target }, l)))),
    h('div', { class: 'row', style: { gap: '18px' } },
      h('div', { class: 'knobs' },
        knob(pct('min', 'Talon'), e.min, v2 => updExp('min', v2, false)),
        knob(pct('max', 'Pointe', 100), e.max, v2 => updExp('max', v2, false))),
      h('div', { class: 'pctl' }, seg([[0, 'Linéaire'], [1, 'Log'], [2, 'Exp']], e.curve, c => updExp('curve', c)), h('div', { class: 'k-label' }, 'Courbe')),
      h('div', { style: { flex: '1', minWidth: '200px' } }, h('div', { class: 'field' }, h('span', {}, 'Tester la course'), expOut), sim))));
  v.append(page);
}

/* =========================================================
 * Vue IR
 * ========================================================= */
function f2b(f) { const u = new Uint8Array(f.buffer.slice(0)); let s = ''; for (let i = 0; i < u.length; i += 0x8000) s += String.fromCharCode.apply(null, u.subarray(i, i + 0x8000)); return btoa(s); }
function b2f(b) { const s = atob(b), u = new Uint8Array(s.length); for (let i = 0; i < s.length; i++) u[i] = s.charCodeAt(i); return new Float32Array(u.buffer); }
function irData(slot) {
  const ir = S.irs[slot];
  if (!ir) return null;
  if (!U.irCache.has(slot)) U.irCache.set(slot, ir.synth ? synthIR(ir.synth, ir.len, ir.rate) : b2f(ir.data));
  return U.irCache.get(slot);
}

function fft(re, im) {
  const n = re.length;
  for (let i = 1, j = 0; i < n; i++) {
    let bit = n >> 1;
    for (; j & bit; bit >>= 1) j ^= bit;
    j ^= bit;
    if (i < j) { [re[i], re[j]] = [re[j], re[i]]; [im[i], im[j]] = [im[j], im[i]]; }
  }
  for (let len = 2; len <= n; len <<= 1) {
    const ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
    for (let i = 0; i < n; i += len) {
      let cr = 1, ci = 0;
      for (let j = 0; j < len / 2; j++) {
        const a = i + j, b = a + len / 2;
        const tr = re[b] * cr - im[b] * ci, ti = re[b] * ci + im[b] * cr;
        re[b] = re[a] - tr; im[b] = im[a] - ti; re[a] += tr; im[a] += ti;
        const ncr = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = ncr;
      }
    }
  }
}

function prepCanvas(cv) {
  const r = cv.getBoundingClientRect(), dpr = window.devicePixelRatio || 1;
  cv.width = Math.max(1, r.width * dpr); cv.height = Math.max(1, r.height * dpr);
  const ctx = cv.getContext('2d');
  ctx.scale(dpr, dpr);
  return [ctx, r.width, r.height];
}
function drawWave(cv, x) {
  const [ctx, w, hgt] = prepCanvas(cv), mid = hgt / 2;
  ctx.strokeStyle = '#1d2228'; ctx.lineWidth = 1;
  ctx.beginPath(); ctx.moveTo(0, mid); ctx.lineTo(w, mid); ctx.stroke();
  ctx.fillStyle = '#5f6772'; ctx.font = '10px JetBrains Mono, monospace';
  const durMs = x.length / 48;
  for (let t = 0; t <= durMs; t += 10) { const px = t / durMs * w; ctx.fillRect(px, hgt - 4, 1, 4); if (t % 20 === 0 && t) ctx.fillText(t + ' ms', px + 3, hgt - 6); }
  ctx.strokeStyle = '#c98a55'; ctx.lineWidth = 1.2; ctx.beginPath();
  for (let px = 0; px < w; px++) {
    const a = Math.floor(px / w * x.length), b = Math.max(a + 1, Math.floor((px + 1) / w * x.length));
    let mn = 1, mx = -1;
    for (let i = a; i < b && i < x.length; i++) { mn = Math.min(mn, x[i]); mx = Math.max(mx, x[i]); }
    ctx.moveTo(px + .5, mid - mx * (mid - 8)); ctx.lineTo(px + .5, mid - mn * (mid - 8) + .5);
  }
  ctx.stroke();
}
function drawResponse(cv, x) {
  const [ctx, w, hgt] = prepCanvas(cv), N = 8192, rate = 48000;
  const re = new Float64Array(N), im = new Float64Array(N);
  for (let i = 0; i < Math.min(N, x.length); i++) re[i] = x[i];
  fft(re, im);
  const mag = new Float64Array(N / 2);
  for (let i = 0; i < N / 2; i++) mag[i] = Math.hypot(re[i], im[i]);
  const f0 = 20, f1 = 20000, top = 6, bot = -42;
  const fx = f => Math.log(f / f0) / Math.log(f1 / f0) * w, dy = d => (top - d) / (top - bot) * hgt;
  ctx.font = '10px JetBrains Mono, monospace';
  ctx.strokeStyle = '#1d2228'; ctx.fillStyle = '#5f6772'; ctx.lineWidth = 1;
  [50, 100, 200, 500, 1000, 2000, 5000, 10000].forEach(f => { const px = fx(f); ctx.beginPath(); ctx.moveTo(px, 0); ctx.lineTo(px, hgt); ctx.stroke(); ctx.fillText(f >= 1000 ? f / 1000 + 'k' : f, px + 3, hgt - 5); });
  [0, -12, -24, -36].forEach(d => { const py = dy(d); ctx.beginPath(); ctx.moveTo(0, py); ctx.lineTo(w, py); ctx.stroke(); ctx.fillText(d + ' dB', 4, py - 3); });
  const pts = [];
  let max = -Infinity;
  for (let px = 0; px <= w; px += 2) {
    const f = f0 * Math.pow(f1 / f0, px / w), bw = f * 0.06;
    const a = Math.max(1, Math.floor((f - bw) * N / rate)), b = Math.max(a + 1, Math.ceil((f + bw) * N / rate));
    let s = 0;
    for (let i = a; i < b && i < N / 2; i++) s += mag[i] * mag[i];
    const d = 10 * Math.log10(s / (b - a) + 1e-12);
    pts.push([px, d]); max = Math.max(max, d);
  }
  const grad = ctx.createLinearGradient(0, 0, 0, hgt);
  grad.addColorStop(0, 'rgba(201,138,85,.35)'); grad.addColorStop(1, 'rgba(201,138,85,0)');
  ctx.beginPath();
  pts.forEach(([px, d], i) => { const py = dy(clamp(d - max, bot, top)); i ? ctx.lineTo(px, py) : ctx.moveTo(px, py); });
  ctx.strokeStyle = '#e0a674'; ctx.lineWidth = 2; ctx.stroke();
  ctx.lineTo(w, hgt); ctx.lineTo(0, hgt); ctx.closePath(); ctx.fillStyle = grad; ctx.fill();
}

async function loadWav(file, slot) {
  try {
    const ab = await file.arrayBuffer();
    const buf = await new OfflineAudioContext(1, 48000, 48000).decodeAudioData(ab);
    const ch = buf.getChannelData(0), irLen = (U.info && U.info.irLen) || 2048;
    const len = Math.min(ch.length, irLen), x = new Float32Array(len);
    let max = 0;
    for (let i = 0; i < len; i++) { x[i] = ch[i]; max = Math.max(max, Math.abs(ch[i])); }
    if (ch.length > irLen) for (let i = 0; i < 64; i++) x[len - 1 - i] *= i / 64; // fondu de sortie
    for (let i = 0; i < len; i++) x[i] /= max || 1;
    S.irs[slot] = { name: file.name.replace(/\.wav$/i, '').slice(0, 28), user: true, rate: 48000, len, srcLen: ch.length, srcRate: buf.sampleRate, data: f2b(x) };
    U.irCache.delete(slot);
    S.irSel = slot;
    persist();
    renderIR();
    toast('IR chargée dans le slot ' + (slot + 1) + (ch.length > irLen ? ' (tronquée à ' + irLen + ' points)' : ''), 'ok');
  } catch { toast('Fichier audio illisible : ' + file.name, 'err'); }
}

async function sendIR(slot) {
  const ir = S.irs[slot], x = irData(slot);
  if (!ir) return;
  if (!connected()) return toast('Connecte la pédale pour envoyer l’IR', 'err');
  const prog = progressModal('Envoi de « ' + ir.name + ' » → slot ' + (slot + 1));
  await U.tx.send(CMD.IR_BEGIN, { slot, name: ir.name, len: x.length, rate: 48000, fmt: 's16le' });
  const CH = 240;
  for (let i = 0; i < x.length; i += CH) {
    if (prog.cancelled || !connected()) break;
    const n = Math.min(CH, x.length - i), b = new Uint8Array(3 + n * 2), dv = new DataView(b.buffer), idx = i / CH;
    b[0] = slot; b[1] = idx & 255; b[2] = idx >> 8;
    for (let j = 0; j < n; j++) dv.setInt16(3 + j * 2, clamp(Math.round(x[i + j] * 32767), -32768, 32767), true);
    await U.tx.send(CMD.IR_CHUNK, b);
    prog.set((i + n) / x.length);
  }
  const ok = !prog.cancelled && connected();
  if (ok) await U.tx.send(CMD.IR_END, [slot]);
  prog.close();
  toast(ok ? 'IR envoyée dans le slot ' + (slot + 1) : 'Envoi interrompu', ok ? 'ok' : 'err');
}

function useIRInPreset(slot) {
  const b = selBlock();
  const target = b && b.model === 'ir' ? findBlock(b.uid) : activeBlocks().find(x => x.b.model === 'ir');
  if (!target) return toast('Aucun bloc IR Loader dans ce preset', 'err');
  pushHist();
  setParam(target.b.uid, 'slot', slot);
  toast('IR ' + (slot + 1) + ' affectée au bloc ' + L(target.lane, target.col), 'ok');
}

function renderIR() {
  const v = $('#viewIr');
  v.textContent = '';
  const slot = S.irSel, ir = S.irs[slot];
  const page = h('div', { class: 'page' });
  page.append(h('div', { class: 'page-h' },
    h('div', {}, h('h2', {}, 'Réponses impulsionnelles'), h('p', {}, IR_SLOTS + ' slots · 48 kHz mono · ' + ((U.info && U.info.irLen) || 2048) + ' points max. Glisse un .wav sur la zone pour le charger.'))));
  const slots = h('div', { class: 'ir-slots' }, S.irs.map((x, i) => h('button', { class: 'ir-slot' + (i === slot ? ' active' : '') + (x ? '' : ' empty'), onclick: () => { S.irSel = i; persist(); renderIR(); } },
    h('b', {}, String(i + 1).padStart(2, '0')), h('span', {}, x ? x.name : 'Vide'), x && x.user ? h('em', { class: 'user' }, 'USER') : null)));
  const detail = h('div', { class: 'card' });
  if (ir) {
    const x = irData(slot);
    const name = h('input', { type: 'text', value: ir.name, maxlength: 28, onchange: e => { ir.name = e.target.value.trim().slice(0, 28) || ir.name; persist(); renderIR(); } });
    const wave = h('canvas', { class: 'ir-canvas', style: { height: '120px' } }), resp = h('canvas', { class: 'ir-canvas', style: { height: '170px' } });
    detail.append(
      h('h3', {}, icon('wave'), 'Slot ' + (slot + 1)),
      h('div', { class: 'field' }, h('span', {}, 'Nom'), name),
      h('div', { class: 'muted', style: { fontSize: '11px', fontWeight: 700, letterSpacing: '.1em' } }, 'RÉPONSE EN FRÉQUENCE'), resp,
      h('div', { class: 'muted', style: { fontSize: '11px', fontWeight: 700, letterSpacing: '.1em' } }, 'FORME D’ONDE'), wave,
      h('dl', { class: 'kv' },
        h('dt', {}, 'Longueur'), h('dd', {}, x.length + ' points · ' + (x.length / 48).toFixed(1) + ' ms'),
        h('dt', {}, 'Format'), h('dd', {}, '48 kHz · mono · s16'),
        h('dt', {}, 'Source'), h('dd', {}, ir.user ? 'Utilisateur' + (ir.srcLen > ir.len ? ' (tronquée, ' + ir.srcLen + ' pts à l’origine)' : '') : 'Usine (démo)')),
      h('div', { class: 'row' },
        h('button', { class: 'btn primary', onclick: () => sendIR(slot) }, icon('send'), 'Envoyer vers la pédale'),
        h('button', { class: 'btn', onclick: () => useIRInPreset(slot) }, icon('link'), 'Utiliser dans le preset'),
        h('button', { class: 'btn', onclick: async () => { const f = await pickFile('.wav,audio/wav,audio/x-wav'); if (f) loadWav(f, slot); } }, icon('up'), 'Remplacer'),
        h('button', { class: 'btn danger', onclick: async () => {
          if (await confirmBox('Vider le slot ' + (slot + 1) + ' ?', '« ' + ir.name + ' » sera retirée de la bibliothèque.', 'Vider')) { S.irs[slot] = null; U.irCache.delete(slot); persist(); renderIR(); }
        } }, icon('trash'))));
    requestAnimationFrame(() => { drawResponse(resp, x); drawWave(wave, x); });
  } else {
    detail.append(h('h3', {}, icon('wave'), 'Slot ' + (slot + 1) + ' — vide'));
  }
  const dz = h('div', { class: 'dropzone' }, h('b', {}, 'Dépose un fichier .wav ici'), h('div', { class: 'dim', style: { marginTop: '4px' } }, 'ou ', h('button', { class: 'btn sm', onclick: async () => { const f = await pickFile('.wav,audio/wav,audio/x-wav'); if (f) loadWav(f, slot); } }, 'choisis un fichier'), ' — il ira dans le slot ' + (slot + 1)));
  dz.addEventListener('dragover', e => { e.preventDefault(); dz.classList.add('over'); });
  dz.addEventListener('dragleave', () => dz.classList.remove('over'));
  dz.addEventListener('drop', e => { e.preventDefault(); dz.classList.remove('over'); const f = e.dataTransfer.files[0]; if (f) loadWav(f, slot); });
  detail.append(dz);
  page.append(h('div', { class: 'ir-layout' }, slots, detail));
  v.append(page);
}

/* =========================================================
 * Captures NAM (A2 Lite natif sur la pédale)
 * Métadonnées dans S.nams, poids (lourds) dans IndexedDB.
 * ========================================================= */
const idb = (() => {
  let dbp;
  const open = () => dbp || (dbp = new Promise((res, rej) => {
    const r = indexedDB.open('tbbr', 1);
    r.onupgradeneeded = () => r.result.createObjectStore('nam');
    r.onsuccess = () => res(r.result);
    r.onerror = () => rej(r.error);
  }));
  const run = async (mode, fn) => {
    const db = await open();
    return new Promise((res, rej) => {
      const t = db.transaction('nam', mode), req = fn(t.objectStore('nam'));
      t.oncomplete = () => res(req && req.result);
      t.onerror = () => rej(t.error);
    });
  };
  return { get: k => run('readonly', s => s.get(k)), put: (k, v) => run('readwrite', s => s.put(v, k)), del: k => run('readwrite', s => s.delete(k)), clear: () => run('readwrite', s => s.clear()) };
})();

const CRC_T = (() => { const t = new Uint32Array(256); for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; t[n] = c >>> 0; } return t; })();
function crc32(u8) { let c = 0xFFFFFFFF; for (let i = 0; i < u8.length; i++) c = CRC_T[(c ^ u8[i]) & 255] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; }

const GEAR_TYPES = { amp: 'Ampli', pedal: 'Pédale', pedal_amp: 'Pédale + ampli', amp_cab: 'Ampli + cab', amp_pedal_cab: 'Pédale + ampli + cab', preamp: 'Préampli', studio: 'Studio' };
const TONE_TYPES = { clean: 'Clean', overdrive: 'Overdrive', crunch: 'Crunch', hi_gain: 'High gain', fuzz: 'Fuzz' };
const namMaxBytes = () => ((U.info && U.info.namMaxKB) || 1024) * 1024;

/* Lit un .nam (JSON : version, architecture, config, weights, sample_rate?, metadata?).
 * A2 = architecture « slimmable » : un même fichier tourne en Full ou en Lite,
 * c'est la pédale qui choisit Lite. */
function parseNam(text, fileName) {
  let j;
  try { j = JSON.parse(text); } catch { throw new Error('JSON illisible'); }
  if (!j || typeof j.architecture !== 'string' || !j.config || typeof j.config !== 'object' || !Array.isArray(j.weights) || !j.weights.length)
    throw new Error('pas un modèle NAM (architecture / config / weights manquants)');
  const w = Float32Array.from(j.weights);
  for (let i = 0; i < w.length; i++) if (!Number.isFinite(w[i])) throw new Error('poids invalides');
  const cfg = JSON.stringify({ architecture: j.architecture, config: j.config });
  const a2 = /slimmable/i.test(cfg);
  const m = j.metadata || {};
  const meta = {};
  ['modeled_by', 'gear_make', 'gear_model', 'gear_type', 'tone_type', 'loudness', 'gain', 'input_level_dbu', 'output_level_dbu', 'date'].forEach(k => { if (m[k] != null) meta[k] = m[k]; });
  const sr = j.sample_rate == null ? 48000 : +j.sample_rate;
  const bytes = new TextEncoder().encode(cfg).length + w.length * 4;
  return {
    info: { name: String(m.name || fileName.replace(/\.nam$/i, '')).slice(0, 32), file: fileName, arch: j.architecture, a2, version: String(j.version || '?'), sr, nWeights: w.length, bytes, meta, added: Date.now(), onDevice: false },
    data: { cfg, weights: w },
  };
}

function namIssues(n) {
  const out = [];
  if (!n.a2) out.push(['warn', 'Architecture « ' + n.arch + ' » (A1). La Blackbox ne fait tourner nativement que les modèles A2, en mode Lite. Réentraîne ou télécharge la version A2 de cette capture.']);
  if (Math.abs(n.sr - 48000) > 1) out.push(['warn', 'Capture entraînée à ' + n.sr + ' Hz : la pédale tourne à 48 kHz, le son sera faussé.']);
  if (n.bytes > namMaxBytes()) out.push(['bad', 'Trop lourde : ' + (n.bytes / 1024).toFixed(0) + ' Ko pour ' + (namMaxBytes() / 1024) + ' Ko max par slot.']);
  return out;
}

async function importNams(files) {
  files = files.filter(f => /\.nam$/i.test(f.name) || f.type === 'application/json');
  if (!files.length) return toast('Aucun fichier .nam', 'err');
  let slot = S.namSel, ok = 0;
  for (const f of files) {
    if (files.length > 1 || S.nams[slot]) {
      if (files.length === 1) {
        if (!await confirmBox('Remplacer le slot ' + (slot + 1) + ' ?', '« ' + S.nams[slot].name + ' » sera remplacée par ' + f.name + '.', 'Remplacer')) return;
      } else {
        while (slot < NAM_SLOTS && S.nams[slot]) slot++;
        if (slot >= NAM_SLOTS) { toast('Plus de slot NAM libre', 'err'); break; }
      }
    }
    try {
      const { info, data } = parseNam(await f.text(), f.name);
      const old = S.nams[slot];
      info.id = uid();
      await idb.put(info.id, data);
      if (old) idb.del(old.id).catch(() => {});
      S.nams[slot] = info;
      S.namSel = slot;
      ok++;
      slot++;
    } catch (e) { toast(f.name + ' : ' + e.message, 'err'); }
  }
  persist();
  renderNam();
  if (ok) toast(ok + ' capture' + (ok > 1 ? 's importées' : ' importée'), 'ok');
}

async function sendNam(slot) {
  const n = S.nams[slot];
  if (!n) return;
  if (!connected()) return toast('Connecte la pédale pour envoyer la capture', 'err');
  const issues = namIssues(n);
  if (issues.some(i => i[0] === 'bad')) return toast(issues.find(i => i[0] === 'bad')[1], 'err');
  if (issues.length && !await confirmBox('Envoyer quand même ?', issues.map(i => i[1]).join(' '), 'Envoyer', false)) return;
  const data = await idb.get(n.id);
  if (!data) return toast('Poids introuvables dans le navigateur : réimporte le fichier', 'err');
  const cfg = new TextEncoder().encode(data.cfg), w = new Uint8Array(data.weights.buffer, data.weights.byteOffset, data.weights.byteLength);
  const blob = new Uint8Array(cfg.length + w.length);
  blob.set(cfg, 0); blob.set(w, cfg.length); // poids float32 little-endian
  const crc = crc32(blob);
  const prog = progressModal('Envoi de « ' + n.name + ' » → slot NAM ' + (slot + 1) + ' (' + (blob.length / 1024).toFixed(0) + ' Ko)');
  const t0 = performance.now();
  await U.tx.send(CMD.NAM_BEGIN, { slot, name: n.name, arch: n.arch, a2: n.a2, sr: n.sr, cfgLen: cfg.length, nWeights: n.nWeights, size: blob.length, crc, meta: n.meta });
  const CH = 480;
  for (let i = 0, idx = 0; i < blob.length; i += CH, idx++) {
    if (prog.cancelled || !connected()) break;
    const part = blob.subarray(i, i + CH), b = new Uint8Array(3 + part.length);
    b[0] = slot; b[1] = idx & 255; b[2] = idx >> 8;
    b.set(part, 3);
    await U.tx.send(CMD.NAM_CHUNK, b);
    if (idx % 4 === 0) prog.set((i + part.length) / blob.length);
  }
  const ok = !prog.cancelled && connected();
  if (ok) {
    const e = new Uint8Array(5); e[0] = slot; new DataView(e.buffer).setUint32(1, crc, true);
    await U.tx.send(CMD.NAM_END, e);
    n.onDevice = true;
    persist();
  }
  prog.close();
  logSys('NAM slot ' + (slot + 1) + ' : ' + blob.length + ' octets en ' + ((performance.now() - t0) / 1000).toFixed(1) + ' s, CRC32 ' + crc.toString(16).padStart(8, '0'));
  toast(ok ? 'Capture envoyée dans le slot NAM ' + (slot + 1) : 'Envoi interrompu', ok ? 'ok' : 'err');
  renderNam();
}

async function deleteNam(slot) {
  const n = S.nams[slot];
  if (!n || !await confirmBox('Vider le slot NAM ' + (slot + 1) + ' ?', '« ' + n.name + ' » sera retirée de la bibliothèque' + (n.onDevice ? ' et de la pédale.' : '.'), 'Vider')) return;
  idb.del(n.id).catch(() => {});
  if (n.onDevice) send(CMD.NAM_DELETE, [slot]);
  S.nams[slot] = null;
  persist();
  renderNam();
}

async function useNamInPreset(slot) {
  const p = P();
  let target = activeBlocks().find(x => x.b.model === 'nam');
  if (!target) {
    const amp = activeBlocks().find(x => MODEL[x.b.model].cat === 'amp');
    if (amp) {
      if (!await confirmBox('Remplacer l’ampli ?', 'Ce preset n’a pas de bloc NAM Loader. Remplacer « ' + MODEL[amp.b.model].name + ' » (' + L(amp.lane, amp.col) + ') par un NAM Loader ?', 'Remplacer', false)) return;
      changeModel(amp.b.uid, 'nam');
      target = findBlock(amp.b.uid);
    } else {
      const c = p.lanes[0].indexOf(null);
      if (c < 0 || !addBlock(0, c, 'nam')) return toast('Pas de place pour un bloc NAM Loader', 'err');
      target = { b: p.lanes[0][c], lane: 0, col: c };
    }
    if (target.b.model !== 'nam') return;
  }
  pushHist();
  setParam(target.b.uid, 'slot', slot);
  U.sel = { lane: target.lane, col: target.col };
  toast('Capture ' + (slot + 1) + ' affectée au bloc ' + L(target.lane, target.col), 'ok');
  if (!S.nams[slot].onDevice) toast('Pense à envoyer la capture vers la pédale');
}

function renderNam() {
  const v = $('#viewNam');
  if (!v) return;
  v.textContent = '';
  const slot = S.namSel, n = S.nams[slot], used = S.nams.filter(Boolean).length;
  const page = h('div', { class: 'page' });
  page.append(h('div', { class: 'page-h' },
    h('div', {}, h('h2', {}, 'Captures NAM'), h('p', {}, used + ' / ' + NAM_SLOTS + ' slots · Neural Amp Modeler A2, exécuté en mode Lite par la pédale · 48 kHz')),
    h('div', { class: 'ed-spacer' }),
    h('button', { class: 'btn primary', onclick: async () => { const f = await pickFiles('.nam,application/json'); if (f.length) importNams(f); } }, icon('up'), 'Importer des .nam')));

  const slots = h('div', { class: 'ir-slots' }, S.nams.map((x, i) => h('button', { class: 'ir-slot' + (i === slot ? ' active' : '') + (x ? '' : ' empty'), onclick: () => { S.namSel = i; persist(); renderNam(); } },
    h('b', {}, String(i + 1).padStart(2, '0')), h('span', {}, x ? x.name : 'Vide'),
    x ? h('em', { class: 'nam-badge' + (namIssues(x).length ? ' warn' : '') }, x.a2 ? 'A2' : 'A1') : null,
    x && x.onDevice ? h('em', { class: 'nam-badge dev', title: 'Présente sur la pédale' }, '✓') : null)));

  const detail = h('div', { class: 'card' });
  if (n) {
    const m = n.meta, sizeKB = (n.bytes / 1024).toFixed(0), maxKB = namMaxBytes() / 1024;
    const name = h('input', { type: 'text', value: n.name, maxlength: 32, onchange: e => { n.name = e.target.value.trim().slice(0, 32) || n.name; persist(); renderNam(); } });
    const rate = connected() && U.tx.kind === 'ble' ? 6 : connected() && U.tx.kind === 'usb' ? 80 : 60; // Ko/s estimés
    detail.append(
      h('div', { class: 'nam-hero' }, h('div', { class: 'glyph' }, icon('nam')), name),
      h('div', { class: 'tags' },
        h('span', { class: 'tag' }, n.a2 ? 'A2 · Lite sur la pédale' : 'A1 · ' + n.arch),
        m.gear_type ? h('span', { class: 'tag' }, GEAR_TYPES[m.gear_type] || m.gear_type) : null,
        m.tone_type ? h('span', { class: 'tag' }, TONE_TYPES[m.tone_type] || m.tone_type) : null,
        n.onDevice ? h('span', { class: 'tag', style: { color: 'var(--acc)' } }, 'Sur la pédale') : h('span', { class: 'tag' }, 'Pas encore envoyée')),
      namIssues(n).map(([lvl, msg]) => h('div', { class: 'note ' + lvl }, msg)),
      h('dl', { class: 'kv' },
        [['Matériel', [m.gear_make, m.gear_model].filter(Boolean).join(' ') || '—'],
          ['Capturé par', m.modeled_by || '—'],
          ['Loudness', m.loudness != null ? (+m.loudness).toFixed(1) + ' dB → gain de normalisation ' + (-18 - m.loudness).toFixed(1) + ' dB' : '—'],
          ['Niveaux d’étalonnage', m.input_level_dbu != null || m.output_level_dbu != null ? 'entrée ' + (m.input_level_dbu ?? '—') + ' dBu · sortie ' + (m.output_level_dbu ?? '—') + ' dBu' : '—'],
          ['Gain (heuristique)', m.gain != null ? (+m.gain).toFixed(2) : '—'],
          ['Architecture', n.arch + ' · format v' + n.version],
          ['Échantillonnage', n.sr + ' Hz'],
          ['Poids', n.nWeights.toLocaleString('fr-FR') + ' · ' + sizeKB + ' Ko / ' + maxKB + ' Ko'],
          ['Transfert estimé', '≈ ' + Math.max(1, Math.round(n.bytes / 1024 / rate)) + ' s' + (rate === 6 ? ' en Bluetooth (USB conseillé)' : '')],
          ['Fichier', n.file]]
          .map(([a, b]) => [h('dt', {}, a), h('dd', { title: String(b) }, String(b))])),
      h('div', { class: 'progress', title: 'Place utilisée dans le slot' }, h('i', { style: { width: Math.min(100, n.bytes / namMaxBytes() * 100) + '%' } })),
      h('div', { class: 'row' },
        h('button', { class: 'btn primary', onclick: () => sendNam(slot) }, icon('send'), n.onDevice ? 'Renvoyer vers la pédale' : 'Envoyer vers la pédale'),
        h('button', { class: 'btn', onclick: () => useNamInPreset(slot) }, icon('link'), 'Utiliser dans le preset'),
        h('button', { class: 'btn danger', title: 'Vider le slot', onclick: () => deleteNam(slot) }, icon('trash'))));
  } else {
    detail.append(h('h3', {}, icon('nam'), 'Slot ' + (slot + 1) + ' — vide'),
      h('p', { class: 'muted', style: { lineHeight: '1.5' } }, 'Importe un fichier .nam (exporté par le trainer NAM ou téléchargé sur TONE3000). Prends la version A2 : la pédale l’exécute en mode Lite.'));
  }
  const dz = h('div', { class: 'dropzone' }, h('b', {}, 'Dépose un ou plusieurs fichiers .nam ici'),
    h('div', { class: 'dim', style: { marginTop: '4px' } }, 'Un fichier va dans le slot ' + (slot + 1) + ', plusieurs remplissent les slots libres suivants.'));
  dz.addEventListener('dragover', e => { e.preventDefault(); dz.classList.add('over'); });
  dz.addEventListener('dragleave', () => dz.classList.remove('over'));
  dz.addEventListener('drop', e => { e.preventDefault(); dz.classList.remove('over'); importNams([...e.dataTransfer.files]); });
  detail.append(dz);
  page.append(h('div', { class: 'ir-layout view-nam-layout' }, slots, detail));
  v.append(page);
}

/* =========================================================
 * Vue Global
 * ========================================================= */
function renderGlobal() {
  const v = $('#viewGlobal'), g = S.globals;
  v.textContent = '';
  const K = (pd, key) => knob(pd, g[key], val => setGlobal(key, val));
  const T = (key, label) => h('div', { class: 'field' }, h('span', {}, label), h('button', { class: 'toggle' + (g[key] ? ' on' : ''), onclick: e => { setGlobal(key, !g[key]); e.currentTarget.classList.toggle('on', g[key]); } }));
  const Sg = (key, label, opts) => h('div', { class: 'field' }, h('span', {}, label), seg(opts.map((o, i) => [i, o]), g[key], i => setGlobal(key, i, renderGlobal)));
  const page = h('div', { class: 'page' },
    h('div', { class: 'page-h' }, h('div', {}, h('h2', {}, 'Réglages globaux'), h('p', {}, 'Communs à tous les presets, envoyés immédiatement à la pédale.'))),
    h('div', { class: 'cards' },
      h('div', { class: 'card' }, h('h3', {}, icon('sliders'), 'Entrée / sortie'),
        h('div', { class: 'knobs' }, K(db('inGain', 'Gain entrée'), 'inGain'), K(db('outLevel', 'Master', 0, -60, 6), 'outLevel'), K(pct('phones', 'Casque', 70), 'phones')),
        Sg('inZ', 'Entrée', ['Instrument', 'Ligne']), Sg('outMode', 'Sortie', ['Stéréo', 'Mono', 'Dual mono'])),
      h('div', { class: 'card' }, h('h3', {}, icon('sliders'), 'EQ global de sortie'),
        h('div', { class: 'knobs' }, K(db('geqLow', 'Low'), 'geqLow'), K(db('geqMid', 'Mid'), 'geqMid'), K(db('geqHigh', 'High'), 'geqHigh')),
        T('cabBypass', 'Bypass global des cabs / IR (vers un ampli)')),
      h('div', { class: 'card' }, h('h3', {}, icon('tuner'), 'Tempo & accordeur'),
        Sg('tempoMode', 'Tempo', ['Par preset', 'Global']),
        h('div', { class: 'knobs' }, K(k('bpm', 'BPM global', 120, 40, 250, 1, ''), 'bpm'), K(k('a4', 'Diapason A4', 440, 425, 455, 1, 'Hz'), 'a4'))),
      h('div', { class: 'card' }, h('h3', {}, icon('link'), 'MIDI'),
        h('div', { class: 'field' }, h('span', {}, 'Canal'), h('select', { onchange: e => setGlobal('midiCh', +e.target.value) },
          h('option', { value: 0, selected: g.midiCh === 0 }, 'Omni'), Array.from({ length: 16 }, (_, i) => h('option', { value: i + 1, selected: g.midiCh === i + 1 }, 'Canal ' + (i + 1))))),
        T('midiPC', 'Recevoir les Program Change'), T('midiClock', 'Suivre l’horloge MIDI'), T('midiThru', 'MIDI Thru (USB → BLE)')),
      h('div', { class: 'card' }, h('h3', {}, icon('ble'), 'Bluetooth'),
        h('div', { class: 'field' }, h('span', {}, 'Nom de l’appareil'), h('input', { type: 'text', value: g.btName, maxlength: 20, onchange: e => setGlobal('btName', e.target.value.trim().slice(0, 20) || 'BlackBox') })),
        T('btAudio', 'Streaming audio Bluetooth')),
      h('div', { class: 'card' }, h('h3', {}, icon('gear'), 'Système'),
        h('div', { class: 'field' }, h('span', {}, 'Plein écran auto (tactile)'), h('button', { class: 'toggle' + (g.autoFs ? ' on' : ''), onclick: e => { g.autoFs = !g.autoFs; persist(); e.currentTarget.classList.toggle('on', g.autoFs); } })),
        h('div', { class: 'field' }, h('span', {}, 'Interface de l’app'), seg([['auto', 'Auto'], ['pc', 'PC'], ['tab', 'Tactile']], g.ui, u => { g.ui = u; persist(); applyUiMode(); renderGlobal(); })),
        h('div', { class: 'knobs' }, K(pct('bright', 'Luminosité', 70), 'bright')),
        h('div', { class: 'field' }, h('span', {}, 'Mise en veille'), h('select', { onchange: e => setGlobal('autoOff', +e.target.value) },
          ['Jamais', '10 min', '30 min', '1 h'].map((o, i) => h('option', { value: i, selected: g.autoOff === i }, o)))))));
  v.append(page);
}

/* =========================================================
 * Vue Appareil
 * ========================================================= */
function connCards(after) {
  const cur = connected() ? U.tx.kind : null;
  const mk = (kind, ic, title, sub, ok) => h('button', { class: 'conn-card' + (cur === kind ? ' cur' : ''), disabled: !ok,
    onclick: () => { if (after) after(); connect(kind); } },
    icon(ic), h('b', {}, title), h('small', {}, ok ? sub : 'Non disponible dans ce navigateur (Chrome / Edge requis' + (window.isSecureContext ? '' : ', en HTTPS') + ')'));
  return h('div', { class: 'conn-cards' },
    mk('ble', 'ble', 'Bluetooth LE', 'Sans fil : répète, scène, canapé.', BleTransport.supported()),
    mk('usb', 'usb', 'USB-C', 'Le plus rapide : IR, firmware, sauvegardes.', SerialTransport.supported()),
    mk('demo', 'demo', 'Pédale simulée', 'Pour tester l’interface sans matériel.', true));
}

function renderDevice() {
  const v = $('#viewDevice'), g = S.globals, info = U.info;
  v.textContent = '';
  const page = h('div', { class: 'page' });
  page.append(h('div', { class: 'page-h' },
    h('div', {}, h('h2', {}, 'Appareil'), h('p', {}, connected() ? 'Connecté via ' + U.tx.label : 'Aucune pédale connectée')),
    h('div', { class: 'ed-spacer' }),
    connected() ? h('button', { class: 'btn', onclick: () => disconnect() }, icon('close'), 'Déconnecter') : null));
  page.append(connCards());
  page.append(h('div', { class: 'row' }, h('button', { class: 'btn', onclick: () => openScreen() }, icon('chip'), 'Simuler l’écran de la pédale (240 × 240)')));

  const infoCard = h('div', { class: 'card' }, h('h3', {}, icon('chip'), 'Informations'));
  if (info) {
    infoCard.append(h('dl', { class: 'kv' },
      [['Modèle', info.model], ['Firmware', info.fw], ['Bootloader', info.boot], ['Matériel', info.hw], ['N° de série', info.serial], ['Processeur', info.cpu],
        ['Presets', info.presets], ['Slots IR', info.irSlots + ' × ' + info.irLen + ' pts'], ['NAM', info.nam ? info.nam + ' · ' + info.namSlots + ' slots × ' + info.namMaxKB + ' Ko' : '—'], ['Batterie', info.battery != null ? info.battery + ' %' : '—'], ['Protocole', 'v' + info.proto]]
        .map(([a, b]) => [h('dt', {}, a), h('dd', {}, b == null ? '—' : String(b))])));
  } else infoCard.append(h('p', { class: 'dim' }, 'Connecte la pédale pour lire ses informations.'));

  /* Firmware */
  const fwProg = h('div', { class: 'progress' }, h('i'));
  let fwFile = null;
  const fwName = h('span', { class: 'mono muted' }, 'aucun fichier');
  const fwBtn = h('button', { class: 'btn primary', disabled: true, onclick: () => flashFirmware(fwFile, fwProg, fwBtn) }, icon('bolt'), 'Flasher');
  const fwCard = h('div', { class: 'card' }, h('h3', {}, icon('bolt'), 'Mise à jour du firmware'),
    h('div', { class: 'note warn' }, 'Branche la pédale en USB et ne la débranche pas pendant le flash. Le bootloader d’origine reste intact : en cas de souci, la pédale redémarre en mode récupération.'),
    h('div', { class: 'row' }, h('button', { class: 'btn', onclick: async () => {
      const f = await pickFile('.bin,.hex,application/octet-stream');
      if (!f) return;
      fwFile = f; fwName.textContent = f.name + ' · ' + (f.size / 1024).toFixed(0) + ' Ko'; fwBtn.disabled = false;
    } }, icon('up'), 'Choisir un .bin'), fwName),
    fwProg, h('div', { class: 'row' }, fwBtn));

  /* Sauvegardes */
  const backupCard = h('div', { class: 'card' }, h('h3', {}, icon('save'), 'Sauvegarde & restauration'),
    h('p', { class: 'muted' }, 'Tous les presets, les réglages globaux, les IR utilisateur et les captures NAM dans un seul fichier.'),
    h('div', { class: 'row' },
      h('button', { class: 'btn', onclick: backupAll }, icon('down'), 'Sauvegarde complète'),
      h('button', { class: 'btn', onclick: restoreBackup }, icon('up'), 'Restaurer')),
    h('div', { class: 'row' }, h('button', { class: 'btn danger', onclick: factoryReset }, icon('reset'), 'Réinitialisation usine')));

  /* Profil de connexion */
  const F = (label, key, obj = g.gatt) => h('div', { class: 'field' }, h('span', {}, label),
    h('input', { type: 'text', class: 'mono', value: obj[key], spellcheck: 'false', onchange: e => { obj[key] = e.target.value.trim(); persist(); } }));
  const gattCard = h('div', { class: 'card' }, h('h3', {}, icon('gear'), 'Profil de connexion (CFW)'),
    F('Préfixe du nom BLE', 'namePrefix'), F('Service GATT', 'service'), F('Caract. RX (écriture)', 'rx'), F('Caract. TX (notif.)', 'tx'),
    h('div', { class: 'field' }, h('span', {}, 'Débit USB série'), h('select', { onchange: e => { g.baud = +e.target.value; persist(); } },
      [115200, 230400, 460800, 921600, 1000000].map(b => h('option', { value: b, selected: b === g.baud }, b + ' bauds')))),
    h('div', { class: 'row' }, h('button', { class: 'btn sm ghost', onclick: () => { g.gatt = { ...GATT_DEFAULT }; g.baud = 115200; persist(); renderDevice(); } }, icon('reset'), 'Valeurs par défaut')));

  page.append(h('div', { class: 'cards' }, infoCard, fwCard, backupCard, gattCard));

  /* Console */
  const con = h('div', { class: 'console', id: 'console' }, U.log.map(logNode));
  const raw = h('input', { type: 'text', class: 'mono', placeholder: 'A5 01 00 00 01   ou   PRESET_SELECT 03   ou   GLOBAL {"bright":40}', spellcheck: 'false', style: { flex: '1', height: '34px', padding: '0 10px', borderRadius: '8px', background: '#0a0b0e', border: '1px solid var(--line2)', minWidth: '0' } });
  const sendRawCmd = () => {
    const txt = raw.value.trim();
    if (!txt) return;
    if (!connected()) return toast('Pédale non connectée', 'err');
    const m = txt.match(/^([A-Z_]+)\s*(.*)$/);
    try {
      if (m && CMD[m[1]] != null) {
        const rest = m[2].trim();
        U.tx.send(CMD[m[1]], rest.startsWith('{') ? JSON.parse(rest) : rest ? rest.split(/[\s,]+/).map(x => parseInt(x, 16)) : null);
      } else {
        const bytes = txt.replace(/0x/gi, '').split(/[\s,]+/).map(x => parseInt(x, 16));
        if (bytes.some(b => isNaN(b) || b < 0 || b > 255)) throw new Error('hex');
        U.tx.sendRaw(Uint8Array.from(bytes));
      }
      raw.value = '';
    } catch { toast('Commande invalide', 'err'); }
  };
  raw.addEventListener('keydown', e => { if (e.key === 'Enter') sendRawCmd(); });
  page.append(h('div', { class: 'card' },
    h('div', { class: 'row' }, h('h3', { style: { flex: '1' } }, icon('chip'), 'Console protocole'),
      h('button', { class: 'chip' + (U.logStream ? ' on' : ''), title: 'Afficher aussi les flux temps réel (vu-mètres, accordeur, paramètres, chunks)', onclick: e => { U.logStream = !U.logStream; e.currentTarget.classList.toggle('on', U.logStream); } }, 'Temps réel'),
      h('button', { class: 'icon-btn' + (U.logPause ? ' on' : ''), title: 'Pause', onclick: e => { U.logPause = !U.logPause; e.currentTarget.classList.toggle('on', U.logPause); } }, icon('pause')),
      h('button', { class: 'icon-btn', title: 'Exporter le journal', onclick: () => download('tbbr-log.txt', U.log.map(e => new Date(e.t).toISOString() + ' ' + e.dir.toUpperCase() + ' ' + (e.text || (CMD_NAME[e.cmd] || e.cmd) + ' ' + hex(e.raw))).join('\n'), 'text/plain') }, icon('down')),
      h('button', { class: 'icon-btn', title: 'Effacer', onclick: () => { U.log = []; con.textContent = ''; } }, icon('trash'))),
    con,
    h('div', { class: 'row' }, raw, h('button', { class: 'btn', onclick: sendRawCmd }, icon('send'), 'Envoyer'))));
  v.append(page);
  con.scrollTop = con.scrollHeight;
}

async function flashFirmware(file, prog, btn) {
  if (!file) return;
  if (!connected()) return toast('Connecte la pédale (USB recommandé)', 'err');
  if (!await confirmBox('Flasher ' + file.name + ' ?', 'La pédale va redémarrer en mode mise à jour. Ne la débranche pas avant la fin.', 'Flasher', false)) return;
  btn.disabled = true;
  const data = new Uint8Array(await file.arrayBuffer()), CH = 512;
  let crc = 0;
  for (const b of data) crc = (crc + b) >>> 0;
  await U.tx.send(CMD.FW_BEGIN, { size: data.length, sum: crc, name: file.name });
  logSys('Flash : ' + data.length + ' octets');
  const bar = prog.firstChild;
  for (let i = 0; i < data.length; i += CH) {
    if (!connected()) break;
    const idx = i / CH, n = Math.min(CH, data.length - i), b = new Uint8Array(4 + n);
    new DataView(b.buffer).setUint32(0, idx, true);
    b.set(data.subarray(i, i + n), 4);
    await U.tx.send(CMD.FW_CHUNK, b);
    if (idx % 8 === 0) bar.style.width = ((i + n) / data.length * 100).toFixed(1) + '%';
  }
  if (connected()) {
    bar.style.width = '100%';
    await U.tx.send(CMD.FW_END, []);
    toast('Firmware envoyé, la pédale redémarre', 'ok');
    logSys('Flash terminé');
  } else toast('Connexion perdue pendant le flash', 'err');
  btn.disabled = false;
}

async function backupAll() {
  const namData = {};
  for (const n of S.nams) if (n) { const d = await idb.get(n.id); if (d) namData[n.id] = { cfg: d.cfg, w: f2b(d.weights) }; }
  download('blackbox-backup-' + new Date().toISOString().slice(0, 10) + '.tbbr.json',
    JSON.stringify({ format: 'tbbr-backup', version: 1, presets: S.presets, globals: S.globals, irs: S.irs, nams: S.nams, namData }));
}

async function restoreBackup() {
  const f = await pickFile('.json,application/json');
  if (!f) return;
  try {
    const j = JSON.parse(await f.text());
    if (j.format !== 'tbbr-backup' || !Array.isArray(j.presets)) throw new Error('format');
    if (!await confirmBox('Restaurer la sauvegarde ?', 'Les ' + PRESETS + ' presets, les réglages globaux, les IR et les captures NAM seront remplacés.', 'Restaurer')) return;
    S.presets = Array.from({ length: PRESETS }, (_, i) => j.presets[i] ? sanitizePreset(j.presets[i]) : initPreset());
    S.globals = { ...defaultGlobals(), ...j.globals, gatt: { ...GATT_DEFAULT, ...(j.globals || {}).gatt } };
    if (Array.isArray(j.irs) && j.irs.length === IR_SLOTS) S.irs = j.irs;
    if (Array.isArray(j.nams) && j.nams.length === NAM_SLOTS) {
      await idb.clear().catch(() => {});
      S.nams = j.nams.map(n => n && j.namData && j.namData[n.id] ? { ...n, onDevice: false } : null);
      for (const n of S.nams) if (n) await idb.put(n.id, { cfg: j.namData[n.id].cfg, weights: b2f(j.namData[n.id].w) });
    }
    U.irCache.clear(); hist.length = 0; fut.length = 0;
    S.presets.forEach((_, i) => U.dirty.add(i));
    persist();
    selectPreset(0);
    toast('Sauvegarde restaurée (pense à sauver sur la pédale)', 'ok');
  } catch { toast('Fichier de sauvegarde invalide', 'err'); }
}

async function factoryReset() {
  if (!await confirmBox('Réinitialisation usine ?', 'Tous les presets, réglages globaux, IR utilisateur et captures NAM seront effacés, dans l’app et sur la pédale si elle est connectée. Fais une sauvegarde avant.', 'Tout effacer')) return;
  send(CMD.FACTORY_RESET, [0x5A]);
  const gatt = S.globals.gatt, baud = S.globals.baud;
  S = freshState();
  idb.clear().catch(() => {});
  S.globals.gatt = gatt; S.globals.baud = baud;
  U.irCache.clear(); U.dirty.clear(); hist.length = 0; fut.length = 0;
  persist();
  selectPreset(0);
  toast('Réinitialisation effectuée', 'ok');
}

/* =========================================================
 * Accordeur
 * ========================================================= */
function openTuner() {
  if (U.tuner) return;
  const note = h('div', { class: 'tn-note' }, '—');
  const cents = h('div', { class: 'tn-cents' }, connected() ? 'Joue une corde…' : 'Pédale non connectée');
  const svg = svgEl('svg', { viewBox: '0 0 300 175' });
  const C = [150, 165], R = 140;
  svg.append(svgEl('path', { d: arcPath(C[0], C[1], R, -60, 60), fill: 'none', stroke: '#23282f', 'stroke-width': 10, 'stroke-linecap': 'round' }));
  svg.append(svgEl('path', { d: arcPath(C[0], C[1], R, -3.6, 3.6), fill: 'none', stroke: '#3ddc84', 'stroke-width': 10 }));
  for (let c = -50; c <= 50; c += 10) {
    const [x0, y0] = polar(C[0], C[1], R - 14, c * 1.2), [x1, y1] = polar(C[0], C[1], R - (c % 50 === 0 || c === 0 ? 30 : 22), c * 1.2);
    svg.append(svgEl('line', { x1: x0, y1: y0, x2: x1, y2: y1, stroke: c === 0 ? '#3ddc84' : '#4a525c', 'stroke-width': c === 0 ? 3 : 2 }));
  }
  const needle = svgEl('line', { x1: C[0], y1: C[1], x2: C[0], y2: C[1] - R + 4, stroke: '#f2f4f7', 'stroke-width': 3, 'stroke-linecap': 'round', style: 'transition: transform .08s linear' });
  svg.append(needle, svgEl('circle', { cx: C[0], cy: C[1], r: 7, fill: '#f2f4f7' }));
  const strings = h('div', { class: 'tn-strings' }, ['E', 'A', 'D', 'G', 'B', 'E'].map(s => h('span', {}, s)));
  U.tuner = { note, cents, needle, strings, C };
  modal('Accordeur · A4 = ' + S.globals.a4 + ' Hz', h('div', { class: 'tuner' }, note, h('div', { class: 'tn-gauge' }, svg), cents, strings,
    h('p', { class: 'dim', style: { fontSize: '11.5px' } }, 'La sortie de la pédale est coupée pendant l’accordage.')), {
    onClose: () => { U.tuner = null; send(CMD.TUNER, [0]); },
  });
  send(CMD.TUNER, [1]);
}
function tunerData(pl) {
  const t = U.tuner;
  if (!t || pl.length < 5) return;
  const n = pl[0] % 12, oct = pl[1], c = new DataView(pl.buffer, pl.byteOffset).getInt16(2, true) / 10, level = pl[4];
  if (level < 64) { t.note.textContent = '—'; t.note.classList.remove('ok'); t.cents.textContent = 'Joue une corde…'; t.needle.setAttribute('transform', `rotate(0 ${t.C[0]} ${t.C[1]})`); return; }
  const ok = Math.abs(c) < 3;
  t.note.textContent = NOTE_NAMES[n];
  t.note.append(h('sup', {}, oct));
  t.note.classList.toggle('ok', ok);
  t.cents.textContent = (c > 0 ? '+' : '') + c.toFixed(1) + ' cents';
  t.needle.setAttribute('transform', `rotate(${clamp(c, -50, 50) * 1.2} ${t.C[0]} ${t.C[1]})`);
  const map = { '4-2': 0, '9-2': 1, '2-3': 2, '7-3': 3, '11-3': 4, '4-4': 5 };
  $$('span', t.strings).forEach((s, i) => s.classList.toggle('on', map[n + '-' + oct] === i && ok));
}

/* =========================================================
 * Modales, toasts, fichiers
 * ========================================================= */
function modal(title, body, { wide = false, full = false, actions = [], onClose } = {}) {
  const bg = h('div', { class: 'modal-bg' });
  const esc = e => { if (e.key === 'Escape') { e.stopPropagation(); close(); } };
  const close = () => { if (!bg.isConnected) return; bg.remove(); document.removeEventListener('keydown', esc, true); if (onClose) onClose(); };
  const m = h('div', { class: 'modal' + (wide ? ' wide' : '') + (full ? ' full' : '') },
    h('div', { class: 'modal-h' }, h('h3', {}, title), h('button', { class: 'icon-btn', title: 'Fermer', onclick: close }, icon('close'))),
    h('div', { class: 'modal-b' }, body),
    actions.length ? h('div', { class: 'modal-f' }, actions.map(a => h('button', { class: 'btn ' + (a.cls || ''), onclick: () => { if (!a.fn || a.fn() !== false) close(); } }, a.label))) : null);
  bg.append(m);
  bg.addEventListener('pointerdown', e => { if (e.target === bg) close(); });
  $('#modalRoot').append(bg);
  document.addEventListener('keydown', esc, true);
  return { close, el: m };
}
function askText(title, value) {
  return new Promise(res => {
    let done = false;
    const inp = h('input', { type: 'text', value, maxlength: 24 });
    const ok = () => { done = true; res(inp.value.trim()); };
    const md = modal(title, inp, { actions: [{ label: 'Annuler', cls: 'ghost' }, { label: 'OK', cls: 'primary', fn: ok }], onClose: () => { if (!done) res(null); } });
    inp.addEventListener('keydown', e => { if (e.key === 'Enter') { ok(); md.close(); } });
    setTimeout(() => { inp.focus(); inp.select(); }, 60);
  });
}
function confirmBox(title, msg, okLabel = 'Confirmer', danger = true) {
  return new Promise(res => {
    let ok = false;
    modal(title, h('p', { class: 'muted', style: { lineHeight: '1.5' } }, msg), {
      actions: [{ label: 'Annuler', cls: 'ghost' }, { label: okLabel, cls: danger ? 'danger' : 'primary', fn: () => { ok = true; } }],
      onClose: () => res(ok),
    });
  });
}
function progressModal(title) {
  const bar = h('div', { class: 'progress' }, h('i')), pctEl = h('span', { class: 'mono muted' }, '0 %');
  const state = { cancelled: false };
  const md = modal(title, [bar, pctEl], { actions: [{ label: 'Annuler', cls: 'ghost', fn: () => { state.cancelled = true; } }], onClose: () => { state.cancelled = true; } });
  state.set = f => { bar.firstChild.style.width = (f * 100).toFixed(1) + '%'; pctEl.textContent = Math.round(f * 100) + ' %'; };
  state.close = () => { const c = state.cancelled; md.close(); state.cancelled = c; };
  return state;
}
function toast(msg, type = '') {
  const t = h('div', { class: 'toast ' + type }, msg);
  $('#toasts').append(t);
  setTimeout(() => { t.style.transition = 'opacity .3s'; t.style.opacity = '0'; setTimeout(() => t.remove(), 300); }, 2600);
}
function pickFile(accept) {
  return new Promise(res => {
    const f = $('#filePick');
    f.value = ''; f.accept = accept;
    f.onchange = () => res(f.files[0] || null);
    f.click();
  });
}
function pickFiles(accept) {
  return new Promise(res => {
    const f = $('#filePickMulti');
    f.value = ''; f.accept = accept;
    f.onchange = () => res([...f.files]);
    f.click();
  });
}
function download(name, data, type = 'application/json') {
  const a = h('a', { href: URL.createObjectURL(new Blob([data], { type })), download: name });
  document.body.append(a); a.click(); a.remove();
  setTimeout(() => URL.revokeObjectURL(a.href), 3000);
}

/* =========================================================
 * Mode tablette (tactile) : navigateur de presets, vue Live
 * ========================================================= */
const isTouch = () => matchMedia('(pointer: coarse)').matches;
const isTab = () => document.body.classList.contains('tab');
/* « Extension de la pédale » : plein écran et écran toujours allumé en mode tactile */
async function toggleFullscreen(force) {
  try {
    if (!document.fullscreenElement && force !== false) await document.documentElement.requestFullscreen({ navigationUI: 'hide' });
    else if (document.fullscreenElement && !force) await document.exitFullscreen();
  } catch { /* refusé par le navigateur */ }
}
let wakeLock = null;
async function keepAwake() {
  try { if ('wakeLock' in navigator && !wakeLock) { wakeLock = await navigator.wakeLock.request('screen'); wakeLock.addEventListener('release', () => { wakeLock = null; }); } } catch { /* */ }
}
function openMenu() {
  const T = (ic, label, sub, fn, on) => h('button', { class: 'menu-tile' + (on ? ' on' : ''), onclick: () => { md.close(); fn(); } }, icon(ic), h('b', {}, label), sub ? h('small', {}, sub) : null);
  const md = modal('Menu', [h('div', { class: 'menu-grid' },
    T('grid', 'Grille', 'Chaîne du preset', () => setView('grid'), U.view === 'grid'),
    T('save', 'Presets', presetLabel(S.cur) + ' · ' + P().name, openPresetBrowser),
    T('plus', document.body.classList.contains('dock') ? 'Masquer les blocs' : 'Bibliothèque de blocs', 'Panneau à glisser-déposer', () => { setView('grid'); document.body.classList.toggle('dock'); setSideTab('blocks'); requestAnimationFrame(drawWires); }),
    T('play', 'Live', 'Scènes en grand', openLive),
    T('foot', 'Contrôles', 'Footswitchs, expression', () => setView('foot'), U.view === 'foot'),
    T('nam', 'Captures NAM', S.nams.filter(Boolean).length + ' / ' + NAM_SLOTS, () => setView('nam'), U.view === 'nam'),
    T('wave', 'IR', 'Réponses impulsionnelles', () => setView('ir'), U.view === 'ir'),
    T('sliders', 'Global', 'Entrées, sorties, MIDI', () => setView('global'), U.view === 'global'),
    T('chip', 'Appareil', 'Connexion, firmware', () => setView('device'), U.view === 'device'),
    T('chip', 'Écran de la pédale', 'Simulation 240 × 240', () => openScreen()),
    T('rotate', document.fullscreenElement ? 'Quitter le plein écran' : 'Plein écran', 'Comme sur la pédale', () => toggleFullscreen()),
    T('undo', 'Annuler', hist.length ? hist.length + ' étape(s)' : 'rien à annuler', undo),
    T('redo', 'Rétablir', '', redo)),
    h('div', { class: 'menu-foot' }, 'DSP du preset : ' + dspLoad() + ' %  ·  ' + activeBlocks().length + ' blocs  ·  ' + islands().length + ' section(s) parallèle(s)')], { wide: true });
  md.el.classList.add('menu-modal');
}
function applyUiMode() {
  const ui = S.globals.ui;
  /* Interface épurée : tout écran tactile, ou fenêtre de moins de 1200 px. L'interface PC reste pour souris + grand écran. */
  const tab = ui === 'tab' || (ui === 'auto' && (isTouch() || innerWidth < 1200));
  document.body.classList.toggle('tab', tab);
  if (!tab) document.body.classList.remove('dock');
  $('#pcName').readOnly = tab || isTouch();
  if (U._uiTab !== tab) { U._uiTab = tab; if ($('#scenebar').childElementCount) { renderScenes(); renderView(); } }
  requestAnimationFrame(drawWires);
}

function presetQuick() {
  const A = (ic, label, fn, cls = '') => h('button', { class: 'menu-tile ' + cls, onclick: () => { md.close(); fn(); } }, icon(ic), h('b', {}, label));
  const md = modal(presetLabel(S.cur) + ' · ' + P().name, h('div', { class: 'menu-grid' },
    A('save', 'Sauver sur la pédale', savePreset),
    A('gear', 'Renommer', async () => { const v = await askText('Nom du preset ' + presetLabel(S.cur), P().name); if (v) { pushHist(); P().name = v.slice(0, 20); markDirty(); syncPreset(); renderAll(); } }),
    A('grid', 'Tous les presets', openPresetBrowser),
    A('copy', 'Copier', () => presetAction('copy')),
    A('paste', 'Coller ici', () => presetAction('paste')),
    A('reset', 'Réinitialiser', () => presetAction('init'), 'danger')));
  md.el.classList.add('menu-modal');
}

function openPresetBrowser() {
  let q = '';
  const grid = h('div', { class: 'pb-grid' });
  const search = h('input', { type: 'text', placeholder: 'Rechercher un preset', spellcheck: 'false', oninput: e => { q = e.target.value.toLowerCase(); draw(); } });
  const draw = () => {
    grid.textContent = '';
    for (let bank = 0; bank < BANKS; bank++) {
      const idx = Array.from({ length: PER_BANK }, (_, j) => bank * PER_BANK + j)
        .filter(i => !q || S.presets[i].name.toLowerCase().includes(q) || presetLabel(i).toLowerCase().includes(q));
      if (!idx.length) continue;
      grid.append(h('div', { class: 'pb-bank' + (Math.floor(S.cur / PER_BANK) === bank ? ' cur' : '') },
        h('div', { class: 'pb-bank-h' }, 'BANQUE ' + String(bank + 1).padStart(2, '0')),
        idx.map(i => { const p = S.presets[i]; return h('button', { class: 'pb-item' + (i === S.cur ? ' active' : '') + (p.name === 'Init' ? ' init' : ''), '--c': p.color, onclick: () => { selectPreset(i); md.close(); } },
          h('span', { class: 'pn' }, presetLabel(i)), h('span', { class: 'pname' }, p.name), U.dirty.has(i) ? h('i', { class: 'pd' }) : null); })));
    }
  };
  draw();
  const act = (ic, label, fn) => h('button', { class: 'btn', onclick: fn }, icon(ic), label);
  const md = modal('Presets', [h('div', { class: 'search pb-search' }, icon('search'), search), grid], { full: true,
    actions: [] });
  md.el.querySelector('.modal-b').after(h('div', { class: 'modal-f pb-actions' },
    act('gear', 'Renommer', async () => { const v = await askText('Nom du preset ' + presetLabel(S.cur), P().name); if (v) { pushHist(); P().name = v.slice(0, 20); markDirty(); syncPreset(); renderAll(); draw(); } }),
    act('copy', 'Copier', () => presetAction('copy')),
    act('paste', 'Coller', async () => { await presetAction('paste'); draw(); }),
    act('reset', 'Init', async () => { await presetAction('init'); draw(); }),
    act('up', 'Importer', async () => { await presetAction('import'); draw(); }),
    act('down', 'Exporter', () => presetAction('export'))));
  requestAnimationFrame(() => { const c = grid.querySelector('.pb-item.active'); if (c) c.scrollIntoView({ block: 'center' }); });
}

function openLive() {
  const body = h('div', { class: 'live' });
  const draw = () => {
    const p = P();
    body.textContent = '';
    body.append(
      h('div', { class: 'live-top' },
        h('button', { class: 'live-nav', onclick: () => { selectPreset(S.cur - 1); draw(); } }, icon('left')),
        h('div', { class: 'live-name', '--c': p.color }, h('span', {}, presetLabel(S.cur)), h('b', {}, p.name)),
        h('button', { class: 'live-nav', onclick: () => { selectPreset(S.cur + 1); draw(); } }, icon('right'))),
      h('div', { class: 'live-scenes' }, p.scenes.map((s, i) => h('button', { class: 'live-scene' + (i === p.scene ? ' active' : ''), onclick: () => { selectScene(i); draw(); } },
        h('b', {}, SCENE_LETTERS[i]), h('span', {}, s.name)))),
      h('div', { class: 'live-bottom' },
        h('div', { class: 'bpm' }, h('b', { id: 'liveBpm' }, Math.round(p.tempo)), h('small', {}, 'BPM')),
        tapButton('tap-btn live-tap', () => { const b = $('#liveBpm'); if (b) b.textContent = Math.round(P().tempo); }),
        h('button', { class: 'btn', onclick: openTuner }, icon('tuner'), 'Accordeur'),
        h('button', { class: 'btn', onclick: () => md.close() }, icon('close'), 'Quitter le mode Live')));
  };
  draw();
  const md = modal('Live', body, { full: true });
  md.el.classList.add('live-modal');
}

/* =========================================================
 * Navigation & initialisation
 * ========================================================= */
function setView(v) {
  document.body.classList.toggle('not-grid', v !== 'grid');
  U.view = v;
  $$('#viewTabs button').forEach(b => b.classList.toggle('active', b.dataset.view === v));
  $$('.view').forEach(s => s.classList.toggle('active', s.dataset.view === v));
  renderView();
}
function renderView() { ({ grid: renderGrid, foot: renderFoot, nam: renderNam, ir: renderIR, global: renderGlobal, device: renderDevice })[U.view](); }
function renderAll() { renderTop(); renderSidebar(); renderScenes(); renderView(); }
const closeDrawer = () => document.body.classList.remove('drawer');

$('#viewTabs').addEventListener('click', e => { const b = e.target.closest('button'); if (b) setView(b.dataset.view); });
$('#prevPreset').addEventListener('click', () => selectPreset(S.cur - 1));
$('#nextPreset').addEventListener('click', () => selectPreset(S.cur + 1));
$('#btnSave').addEventListener('click', savePreset);
$('#btnUndo').addEventListener('click', undo);
$('#btnRedo').addEventListener('click', redo);
$('#btnTuner').addEventListener('click', openTuner);
$('#btnConnect').addEventListener('click', () => {
  const md = modal('Connexion à la pédale', [
    connCards(() => md.close()),
    window.isSecureContext ? null : h('div', { class: 'note warn' }, 'Bluetooth et USB exigent une page en HTTPS.'),
    h('div', { class: 'note' }, 'Bluetooth et USB passent par Web Bluetooth / Web Serial (Chrome, Edge, Opera, Chrome Android). Sur iPad / iPhone, utilise le navigateur Bluefy en attendant l’app native.'),
    connected() ? h('div', { class: 'row' }, h('button', { class: 'btn', onclick: () => { md.close(); disconnect(); } }, icon('close'), 'Déconnecter ' + U.tx.label)) : null,
  ], { wide: true });
});
$('#btnDrawer').addEventListener('click', () => {
  if (isTab()) openMenu();
  else document.body.classList.toggle('drawer');
});
longPress($('.preset-current'), () => presetQuick(), e => { if (isTab() || isTouch()) { e.preventDefault(); openPresetBrowser(); } });
$('#btnLive').addEventListener('click', openLive);
$('#btnHome').addEventListener('click', () => setView('grid'));
longPress($('#fsModeChip'), () => setView('foot'), () => doAction('modeNext'));
document.addEventListener('contextmenu', e => { if (isTab() && !e.target.closest('input, textarea')) e.preventDefault(); });
document.addEventListener('gesturestart', e => e.preventDefault());
document.addEventListener('dragstart', e => e.preventDefault());
document.addEventListener('pointerdown', () => {
  if (!isTab()) return;
  keepAwake();
  if (S.globals.autoFs && isTouch() && !document.fullscreenElement) toggleFullscreen(true);
}, true);
document.addEventListener('visibilitychange', () => { if (document.visibilityState === 'visible' && isTab()) keepAwake(); });
/* Tablette : toucher le fond de la grille ferme le tiroir ; glisser vers le haut sur les scènes = Live */
$('.chain-wrap').addEventListener('click', e => { if (isTab() && (e.target.classList.contains('chain-wrap') || e.target.id === 'chain') && U.sel) { U.sel = null; renderChain(); renderEditor(); } });
(() => {
  let y0 = null;
  const sb = $('#scenebar');
  sb.addEventListener('pointerdown', e => { y0 = e.clientY; });
  sb.addEventListener('pointerup', e => { if (isTab() && y0 != null && y0 - e.clientY > 50) openLive(); y0 = null; });
})();
window.addEventListener('resize', applyUiMode);
$('#scrim').addEventListener('click', closeDrawer);
$('#presetList').addEventListener('click', e => { const r = e.target.closest('.prow'); if (r) { selectPreset(+r.dataset.i); closeDrawer(); } });
$('#presetSearch').addEventListener('input', e => {
  if (S.sideTab === 'blocks') { U.libSearch = e.target.value; renderLibrary(); }
  else { U.search = e.target.value; renderSidebar(); }
});
$('#sideTabs').addEventListener('click', e => { const b = e.target.closest('button'); if (b) setSideTab(b.dataset.tab); });
$$('.side-foot [data-pact]').forEach(b => b.addEventListener('click', () => presetAction(b.dataset.pact)));
const nameInput = $('#pcName');
nameInput.addEventListener('focus', () => pushHist());
nameInput.addEventListener('input', () => { P().name = nameInput.value.slice(0, 20) || 'Sans nom'; markDirty(); renderSidebar(); });
nameInput.addEventListener('change', () => { syncPreset(); renderView(); });
nameInput.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === 'Escape') nameInput.blur(); });

document.addEventListener('keydown', e => {
  if (e.target.closest('input, select, textarea')) return;
  if ($('#modalRoot').childElementCount) return;
  const mod = e.ctrlKey || e.metaKey, key = e.key.toLowerCase();
  if (mod && key === 'z') { e.preventDefault(); e.shiftKey ? redo() : undo(); return; }
  if (mod && key === 'y') { e.preventDefault(); redo(); return; }
  if (mod && key === 's') { e.preventDefault(); savePreset(); return; }
  if (mod || e.altKey || e.target.closest('.knob')) return;
  const b = selBlock();
  if (e.key === 'ArrowLeft') selectPreset(S.cur - 1);
  else if (e.key === 'ArrowRight') selectPreset(S.cur + 1);
  else if (key === 't') openTuner();
  else if (e.key === ' ' && b) { e.preventDefault(); toggleBypass(b.uid); }
  else if ((e.key === 'Delete' || e.key === 'Backspace') && b) { e.preventDefault(); removeBlock(U.sel.lane, U.sel.col); }
  else if (e.key === 'Escape') { U.sel = null; if (U.view === 'grid') { renderChain(); renderEditor(); } }
  else if (/^[1-8]$/.test(e.key)) selectScene(+e.key - 1);
});

new ResizeObserver(() => requestAnimationFrame(drawWires)).observe($('#chain'));
window.addEventListener('beforeunload', () => { clearTimeout(saveTimer); try { localStorage.setItem(LS_KEY, JSON.stringify(S)); } catch { /* */ } });

S.presets = S.presets.map(p => { if (p.par && p.lanes.length === 2 && !p.paths && !p.split) return p; try { return sanitizePreset(p); } catch { return initPreset(); } });
if (BC) BC.onmessage = e => {
  const m = e.data || {};
  if (m.type === 'hello') BC.postMessage({ type: 'info', info: U.info || { battery: 86 } });
  else if (m.type === 'act' && typeof m.action === 'string' && m.action !== 'tuner') doAction(m.action); // footswitch pressé sur l'écran simulé
  else if (m.type === 'param' && findBlock(m.uid) && MODEL[findBlock(m.uid).b.model].params.some(pd => pd.id === m.pid)) { // encodeur PARA
    setParam(m.uid, m.pid, m.v);
    if (U.view === 'grid') renderEditor();
  }
  else if (m.type === 'bypass' && findBlock(m.uid)) toggleBypass(m.uid);
  else if (m.type === 'global' && m.key === 'outLevel' && Number.isFinite(m.v)) { setGlobal('outLevel', clamp(m.v, -60, 6)); if (U.view === 'global') renderGlobal(); }
};
const openScreen = () => window.open('ecran.php', 'tbbr-ecran', 'width=640,height=820');

applyUiMode();
if (isTab()) U.sel = null; // accueil épuré : la grille seule
renderAll();
setSideTab(S.sideTab === 'blocks' ? 'blocks' : 'presets');
connect('demo');
})();
