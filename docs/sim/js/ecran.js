/* The Big Black Rig — simulation de la façade et de l'écran 240×240 de la Blackbox.
 *
 * L'écran physique est minuscule (~1,3″) : peu d'éléments, gros, sans texte
 * superflu. Rendu en SVG (1 unité = 1 pixel de l'écran).
 *
 * Commandes simulées : MASTER (volume), PARA (encodeur : tourner / appuyer /
 * maintenir), HOME FX AMP MOD DLY REV CAB, 2 footswitchs, TUNER (G + D).
 * Synchro : l'état vient du localStorage de l'éditeur ; les actions faites ici
 * sont appliquées localement puis envoyées à l'éditeur (BroadcastChannel « tbbr »).
 */
(() => {
'use strict';
const LS_KEY = 'tbbr.state.v1', W = 240, H = 240; // résolution de l'écran (manuel : 1,54″, 240 × 240)
const C = { bg: '#0b0d10', bar: '#11141a', line: '#232830', tx: '#eceef1', tx2: '#a3abb5', tx3: '#646c77', acc: '#19d3ff', wire: '#3c434d', ok: '#3ddc84', warn: '#ffb020', bad: '#ff4d4d' };
const FONT = 'Inter, system-ui, sans-serif', MONO = "'JetBrains Mono', ui-monospace, monospace";
const $ = s => document.querySelector(s);
/* ?embed : façade seule, fond transparent, à l'échelle du cadre (bandeau du site GitHub Pages) */
const EMBED = new URLSearchParams(location.search).has('embed');
if (EMBED) { document.documentElement.classList.add('embed'); document.body.classList.add('embed'); }
const scr = $('#scr');
scr.setAttribute('viewBox', `0 0 ${W} ${H}`);
const BC = 'BroadcastChannel' in window ? new BroadcastChannel('tbbr') : null;
const KEY_CATS = { FX: ['dyn', 'drive', 'pitch', 'eq'], AMP: ['amp'], MOD: ['mod'], DLY: ['delay'], REV: ['reverb'], CAB: ['cab'] };

let S = null, info = { battery: 86 }, lastCur = null, overlay = null, tuner = null, linked = false;
const ui = { view: 'home', cursor: null, uid: null, key: null, pidx: 0, editing: false, menu: 0, addKey: null, prevUid: null, prevKey: null, prevWasBlock: false };

/* ---------- État ---------- */
function load() {
  try {
    const j = JSON.parse(localStorage.getItem(LS_KEY));
    if (j && Array.isArray(j.presets) && j.presets.length) { S = j; return; }
  } catch { /* état illisible */ }
  S = { presets: factoryPresets(), cur: 0, globals: { fsMode: 'scene', fsCombo: 'tuner', outLevel: 0 }, irs: factoryIRs(), nams: [], editAll: true };
}
const P = () => S.presets[S.cur];
const G = () => S.globals || (S.globals = {});
const sceneOf = p => p.scenes[p.scene || 0];
const st = (p, uid) => { const s = sceneOf(p); return s && s.state[uid]; };
const lanes = p => [p.lanes[0] || [], p.lanes[1] || []];
/* blocs dans l'ordre du signal : colonne par colonne, A puis B */
function order(p) {
  const [A, B] = lanes(p), out = [];
  for (let c = 0; c < COLS; c++) { if (A[c]) out.push({ b: A[c], lane: 0, col: c }); if (B[c]) out.push({ b: B[c], lane: 1, col: c }); }
  return out;
}
const esc = s => String(s).replace(/[&<>"]/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));
const clamp = (v, a, b) => Math.min(b, Math.max(a, v));

const mctx = document.createElement('canvas').getContext('2d');
function fit(text, px, weight, family, max) {
  mctx.font = `${weight} ${px}px ${family}`;
  if (mctx.measureText(text).width <= max) return text;
  let t = text;
  while (t.length > 1 && mctx.measureText(t + '…').width > max) t = t.slice(0, -1);
  return t.trimEnd() + '…';
}

/* ---------- Valeurs de paramètres ---------- */
const decs = step => step >= 1 ? 0 : step >= 0.1 ? 1 : 2;
const quant = (pd, v) => +(Math.round((v - pd.min) / pd.step) * pd.step + pd.min).toFixed(decs(pd.step));
function fmtVal(pd, v) {
  if (pd.type === 'select') return pd.options[v] != null ? pd.options[v] : '—';
  if (pd.type === 'bool') return v ? 'ON' : 'OFF';
  if (pd.type === 'ir') return (S.irs && S.irs[v] && S.irs[v].name) || 'Vide';
  if (pd.type === 'nam') return (S.nams && S.nams[v] && S.nams[v].name) || 'Vide';
  const u = pd.unit;
  if (u === 'ms' && v >= 1000) return (v / 1000).toFixed(2) + ' s';
  if (u === 'Hz' && v >= 1000) return (v / 1000).toFixed(v >= 10000 ? 1 : 2) + 'k';
  let s = (+v).toFixed(decs(pd.step));
  if (pd.min < 0 && v > 0) s = '+' + s;
  return s + (u === ':1' ? ':1' : u ? ' ' + u : '');
}
function stepParam(pd, v, d) {
  if (pd.type === 'bool') return !v;
  if (pd.type === 'select') return (v + d + pd.options.length) % pd.options.length;
  if (pd.type === 'ir' || pd.type === 'nam') {
    const lib = (pd.type === 'ir' ? S.irs : S.nams) || [], idx = lib.map((x, i) => x ? i : -1).filter(i => i >= 0);
    if (!idx.length) return v;
    const k = idx.indexOf(v);
    return idx[((k < 0 ? 0 : k + d) + idx.length) % idx.length];
  }
  const detent = Math.max(pd.step, quant({ ...pd, min: 0 }, (pd.max - pd.min) / 40));
  return quant(pd, clamp(v + d * detent, pd.min, pd.max));
}
const frac = (pd, v) => pd.type ? null : (v - pd.min) / (pd.max - pd.min);

/* ---------- Envoi vers l'éditeur ---------- */
const post = m => { if (BC) BC.postMessage(m); };
function setParamLocal(uid, pid, v) {
  const p = P();
  (S.editAll === false ? [sceneOf(p)] : p.scenes).forEach(s => { if (s.state[uid]) s.state[uid].p[pid] = v; });
  post({ type: 'param', uid, pid, v });
}
function bypassLocal(uid) {
  const s = st(P(), uid);
  if (s) s.on = !s.on;
  post({ type: 'bypass', uid });
}

/* ---------- Footswitchs (2 physiques) ---------- */
function resolve(i) {
  const mode = G().fsMode || 'scene', p = P();
  if (mode === 'preset') return i === 0 ? { press: 'presetDown', hold: 'tuner' } : { press: 'presetUp', hold: 'tap' };
  if (mode === 'scene') return i === 0 ? { press: 'sceneDown', hold: 'presetDown' } : { press: 'sceneUp', hold: 'presetUp' };
  return (p.fs && p.fs[i]) || { press: 'none', hold: 'none', color: C.acc };
}
const NAMES = { none: '—', presetUp: 'preset +', presetDown: 'preset −', bankUp: 'preset +10', bankDown: 'preset −10', sceneUp: 'scène suiv.', sceneDown: 'scène préc.', tap: 'tap', tuner: 'accordeur', modeNext: 'mode' };
function label(a) {
  if (!a) return '—';
  if (a.startsWith('scene:')) return 'scène ' + SCENE_LETTERS[+a.slice(6)];
  if (a.startsWith('block:')) { const x = order(P()).find(o => o.b.uid === a.slice(6)); return x ? MODEL[x.b.model].name : '—'; }
  return NAMES[a] || a;
}
function ledOf(i) {
  const f = resolve(i), p = P();
  if (f.press.startsWith('block:')) { const s = st(p, f.press.slice(6)); return { on: !!(s && s.on), c: f.color || C.acc }; }
  if (f.press.startsWith('scene:')) return { on: (p.scene || 0) === +f.press.slice(6), c: f.color || C.acc };
  return { on: false, c: C.acc };
}

const taps = [];
function act(a) {
  if (!a || a === 'none') return;
  if (tuner) { closeTuner(); return; }
  if (a === 'tuner') { openTuner(); return; }
  const [t, arg] = a.split(':'), p = P(), bank = Math.floor(S.cur / PER_BANK);
  switch (t) {
    case 'presetUp': S.cur = (S.cur + 1) % PRESETS; break;
    case 'presetDown': S.cur = (S.cur + PRESETS - 1) % PRESETS; break;
    case 'bankUp': S.cur = (S.cur + 10) % PRESETS; break;
    case 'bankDown': S.cur = (S.cur + PRESETS - 10) % PRESETS; break;
    case 'preset': S.cur = (+arg) % PRESETS; break;
    case 'scene': p.scene = +arg; break;
    case 'sceneUp': p.scene = ((p.scene || 0) + 1) % SCENES; break;
    case 'sceneDown': p.scene = ((p.scene || 0) + SCENES - 1) % SCENES; break;
    case 'block': { const s = st(p, arg); if (s) s.on = !s.on; break; }
    case 'modeNext': { const ms = ['preset', 'scene', 'stomp']; G().fsMode = ms[(ms.indexOf(G().fsMode || 'scene') + 1) % 3]; break; }
    case 'tap': {
      const n = performance.now();
      while (taps.length && n - taps[0] > 2200) taps.shift();
      taps.push(n);
      if (taps.length >= 2) p.tempo = clamp(Math.round(60000 / ((taps[taps.length - 1] - taps[0]) / (taps.length - 1))), 40, 250);
      break;
    }
  }
  if (t.startsWith('preset') || t.startsWith('bank')) goHome();
  post({ type: 'act', action: a });
  render();
}

/* ---------- Touches et encodeurs ---------- */
function goHome() { ui.view = 'home'; ui.editing = false; ui.key = null; ui.cursor = null; ui.menu = 0; }
function openBlock(uid, key) {
  ui.view = 'block'; ui.uid = uid; ui.key = key; ui.pidx = 0; ui.editing = false;
}
const keyOfCat = cat => Object.keys(KEY_CATS).find(k => KEY_CATS[k].includes(cat)) || 'FX';
const keyModels = k => MODELS.filter(m => m.cat !== 'util' && KEY_CATS[k] && KEY_CATS[k].includes(m.cat));

/* même règle que le firmware : après le dernier bloc de A, sinon un trou de A, sinon B */
function firstFree(p) {
  const A = p.lanes[0] || [], B = p.lanes[1] || [];
  let last = -1;
  for (let c = 0; c < COLS; c++) if (A[c]) last = c;
  for (let c = last + 1; c < COLS; c++) if (!A[c]) return { lane: 0, col: c };
  for (let c = 0; c < COLS; c++) if (!A[c]) return { lane: 0, col: c };
  for (let c = 0; c < COLS; c++) if (!B[c]) return { lane: 1, col: c };
  return null;
}
function addBlockLocal(mid) {
  const p = P(), slot = firstFree(p);
  if (!slot) { flash('Grille pleine'); return false; }
  if (mid === 'nam' && order(p).some(o => o.b.model === 'nam')) { flash('Un seul NAM par preset'); return false; }
  const total = order(p).reduce((n, o) => n + MODEL[o.b.model].dsp, 0);
  if (total + MODEL[mid].dsp > 100) { flash('DSP insuffisant'); return false; }
  p.lanes[slot.lane] = p.lanes[slot.lane] || [];
  const b = { uid: uid(), model: mid };
  p.lanes[slot.lane][slot.col] = b;
  p.scenes.forEach(s => { s.state[b.uid] = { on: true, p: { ...defaultParams(mid) } }; });
  openBlock(b.uid, keyOfCat(MODEL[mid].cat));
  post({ type: 'structure', op: 'add', lane: slot.lane, col: slot.col, model: mid });
  render();
  return true;
}
function removeBlockLocal(uidv) {
  const x = order(P()).find(o => o.b.uid === uidv);
  if (!x) return false;
  P().lanes[x.lane][x.col] = null;
  P().scenes.forEach(s => delete s.state[uidv]);
  post({ type: 'structure', op: 'remove', lane: x.lane, col: x.col });
  goHome(); render();
  return true;
}
function moveBlockLocal(uidv, d) {
  const x = order(P()).find(o => o.b.uid === uidv);
  if (!x) return false;
  const c2 = x.col + d;
  if (c2 < 0 || c2 >= COLS) return false;
  const L = P().lanes[x.lane];
  [L[x.col], L[c2]] = [L[c2], L[x.col]];
  post({ type: 'structure', op: 'move', lane: x.lane, from: x.col, to: c2 });
  render();
  return true;
}
function pressKey(k) {
  if (tuner) closeTuner();
  if (ui.view === 'move' || ui.view === 'action' || ui.view === 'add' || ui.view === 'confirm') ui.view = 'block';
  if (k === 'HOME') { goHome(); render(); return; }
  ui.prevWasBlock = ui.view === 'block'; ui.prevUid = ui.uid; ui.prevKey = ui.key;
  const list = order(P()).filter(o => KEY_CATS[k].includes(MODEL[o.b.model].cat));
  if (!list.length) { ui.view = 'add'; ui.addKey = k; ui.key = k; ui.menu = 0; render(); return; }
  /* même touche : bloc suivant de la même famille */
  const cur = ui.view === 'block' && ui.key === k ? list.findIndex(o => o.b.uid === ui.uid) : -1;
  openBlock(list[(cur + 1) % list.length].b.uid, k);
  render();
}
/* maintien d'une touche FX..CAB : gérer le bloc affiché (ajouter / déplacer / supprimer) */
function holdKey(k) {
  if (ui.view !== 'block' || ui.key !== k) return;
  if (ui.prevWasBlock && ui.prevKey === k && order(P()).some(o => o.b.uid === ui.prevUid)) ui.uid = ui.prevUid;
  ui.view = 'action'; ui.menu = 0; ui.editing = false; render();
}
function paraTurn(d) {
  if (tuner) return;
  const p = P();
  if (ui.view === 'action') { ui.menu = (ui.menu + d + 4) % 4; render(); return; }
  if (ui.view === 'add') {
    const ms = keyModels(ui.addKey), n = ms.length;
    if (n) ui.menu = (ui.menu + d + n) % n;
    render(); return;
  }
  if (ui.view === 'confirm') { ui.menu = (ui.menu + d + 2) % 2; render(); return; }
  if (ui.view === 'move') { moveBlockLocal(ui.uid, d); return; }
  if (ui.view === 'home') {
    const n = order(p).length;
    if (!n) return;
    ui.cursor = ui.cursor == null ? (d > 0 ? 0 : n - 1) : (ui.cursor + d + n) % n;
  } else {
    const x = order(p).find(o => o.b.uid === ui.uid);
    if (!x) { goHome(); render(); return; }
    const m = MODEL[x.b.model];
    if (ui.editing) {
      const pd = m.params[ui.pidx], s = st(p, ui.uid);
      setParamLocal(ui.uid, pd.id, stepParam(pd, s.p[pd.id], d));
    } else ui.pidx = clamp(ui.pidx + d, 0, m.params.length - 1);
  }
  render();
}
function paraPress() {
  if (tuner) { closeTuner(); return; }
  if (ui.view === 'action') {
    if (ui.menu === 0) { ui.view = 'add'; ui.addKey = ui.key; ui.menu = 0; }
    else if (ui.menu === 1) ui.view = 'move';
    else if (ui.menu === 2) { ui.view = 'confirm'; ui.menu = 1; }
    else ui.view = 'block';
    render(); return;
  }
  if (ui.view === 'add') {
    const ms = keyModels(ui.addKey), m = ms[ui.menu];
    if (m) addBlockLocal(m.id);
    return;
  }
  if (ui.view === 'confirm') {
    if (ui.menu === 0) removeBlockLocal(ui.uid);
    else { ui.view = 'action'; render(); }
    return;
  }
  if (ui.view === 'move') { ui.view = 'block'; render(); return; }
  if (ui.view === 'home') {
    const o = order(P());
    if (ui.cursor != null && o[ui.cursor]) {
      const cat = MODEL[o[ui.cursor].b.model].cat;
      openBlock(o[ui.cursor].b.uid, Object.keys(KEY_CATS).find(k => KEY_CATS[k].includes(cat)));
    }
  } else ui.editing = !ui.editing;
  render();
}
function paraHold() {
  if (ui.view === 'action' || ui.view === 'add' || ui.view === 'confirm' || ui.view === 'move') return;
  const o = order(P());
  const uidv = ui.view === 'block' ? ui.uid : ui.cursor != null && o[ui.cursor] ? o[ui.cursor].b.uid : null;
  if (uidv) { bypassLocal(uidv); render(); }
}
function masterTurn(d) {
  const v = clamp(Math.round(((G().outLevel != null ? G().outLevel : 0) + d) * 2) / 2, -60, 6);
  G().outLevel = v;
  post({ type: 'global', key: 'outLevel', v });
  overlay = { kind: 'master', until: performance.now() + 1000 };
  setTimeout(render, 1050);
  render();
}
function flash(text) { overlay = { kind: 'msg', text, until: performance.now() + 900 }; setTimeout(render, 950); render(); }

/* ---------- Rendu ---------- */
function tile(b, cx, cy, t, p, cursor) {
  const m = MODEL[b.model], cat = CATS[m.cat], s = st(p, b.uid), on = !s || s.on;
  const col = on ? cat.color : '#4a515b', r = Math.round(t * 0.26), ic = Math.round(t * 0.58);
  return `<g>
    ${cursor ? `<rect x="${cx - t / 2 - 4}" y="${cy - t / 2 - 4}" width="${t + 8}" height="${t + 8}" rx="${r + 4}" fill="none" stroke="#fff" stroke-width="2"/>` : ''}
    <rect x="${cx - t / 2}" y="${cy - t / 2}" width="${t}" height="${t}" rx="${r}" fill="${C.bg}"/>
    <rect x="${cx - t / 2}" y="${cy - t / 2}" width="${t}" height="${t}" rx="${r}" fill="${col}" fill-opacity="${on ? .2 : .06}" stroke="${col}" stroke-width="2"/>
    <svg x="${cx - ic / 2}" y="${cy - ic / 2}" width="${ic}" height="${ic}" viewBox="0 0 24 24" fill="none" stroke="${on ? cat.color : '#59616c'}" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">${MODEL_GLYPH[b.model] || CAT_GLYPH[m.cat]}</svg>
  </g>`;
}

const BAR = 34;
function topBar(p) {
  const bat = clamp(Math.round(info.battery != null ? info.battery : 86), 0, 100), bc = bat <= 15 ? C.bad : bat <= 30 ? C.warn : C.ok;
  const bx = W - 38;
  const bt = info.bt || 'off', btc = bt === 'paired' ? C.ok : bt === 'on' ? '#3aa0ff' : C.tx2;
  const btx = bx - 58, bty = 17, ux = bx - 40;
  return `<rect width="${W}" height="${BAR}" fill="${C.bar}"/><path d="M0 ${BAR - .5}H${W}" stroke="${C.line}"/>
    <rect x="0" y="0" width="4" height="${BAR}" fill="${p.color || C.acc}"/>
    <text x="11" y="22.5" fill="${C.acc}" font-family="${MONO}" font-size="14" font-weight="700">${presetLabel(S.cur)}</text>
    <text x="50" y="23" fill="${C.tx}" font-family="${FONT}" font-size="15" font-weight="800">${esc(fit(p.name, 15, 800, FONT, bx - 116))}</text>
    <path d="M${btx - 3.2} ${bty + 3.2}L${btx + 3.2} ${bty - 3.2}L${btx} ${bty - 6.2}L${btx} ${bty + 6.2}L${btx + 3.2} ${bty + 3.2}L${btx - 3.2} ${bty - 3.2}" fill="none" stroke="${btc}" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round"/>
    ${bt === 'paired' ? `<circle cx="${btx + 5.8}" cy="${bty + 5.8}" r="1.3" fill="${C.ok}"/>` : ''}
    ${info.usb ? `<path d="M${ux + 1.5} ${bty - 6}L${ux - 3.5} ${bty + 1}L${ux - 0.5} ${bty + 1}L${ux - 1.5} ${bty + 6}L${ux + 3.5} ${bty - 1}L${ux + 0.5} ${bty - 1}Z" fill="none" stroke="${C.warn}" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>` : ''}
    <rect x="${bx}" y="10.5" width="25" height="13" rx="3" fill="none" stroke="${C.tx2}" stroke-width="1.6"/>
    <rect x="${bx + 25.8}" y="14" width="2.6" height="6" rx="1" fill="${C.tx2}"/>
    <rect x="${bx + 2.4}" y="12.9" width="${(20.2 * bat / 100).toFixed(1)}" height="8.2" rx="1.4" fill="${bc}"/>
    <text x="${bx - 18}" y="23" fill="${bc}" font-family="${MONO}" font-size="12" font-weight="700" text-anchor="middle">${bat}%</text>`;
}

/* Chaîne en lignes, comme du texte : quand une ligne est pleine, le câble revient à gauche
 * sur la ligne suivante. Une section parallèle (blocs contigus sur la rangée B) est une seule
 * unité : ses deux chemins sont empilés dans la ligne, entre un crochet split / merge.
 * Le nombre de colonnes par ligne est choisi pour garder des tuiles lisibles (≥ 36 px). */
function units(p) {
  const [A, B] = lanes(p), used = [], out = [];
  for (let c = 0; c < COLS; c++) if (A[c] || B[c]) used.push(c);
  for (let i = 0; i < used.length; i++) {
    const c = used[i];
    if (!B[c]) { out.push({ par: false, cols: [c] }); continue; }
    const cols = [c];
    while (i + 1 < used.length && used[i + 1] === cols[cols.length - 1] + 1 && B[used[i + 1]]) cols.push(used[++i]);
    out.push({ par: true, cols });
  }
  return out;
}
function flow(us, per) {
  const lines = [];
  let cur = [], w = 0;
  us.forEach(u => { if (w + u.cols.length > per && cur.length) { lines.push(cur); cur = []; w = 0; } cur.push(u); w += u.cols.length; });
  if (cur.length) lines.push(cur);
  return lines;
}
function chain(p) {
  const [A, B] = lanes(p), o = order(p), us = units(p);
  const top = BAR + 6, availH = H - top - 6, M = 12, GAP = 14;
  if (!us.length) {
    const y = top + availH / 2;
    return `<path d="M4 ${y}H${W - 4}" stroke="${C.wire}" stroke-width="2"/>
      <text x="${W / 2}" y="${y - 14}" fill="${C.tx3}" font-family="${FONT}" font-size="14" font-weight="700" text-anchor="middle">Preset vide</text>`;
  }
  const n = us.reduce((s, u) => s + u.cols.length, 0), maxW = Math.max(...us.map(u => u.cols.length)), hasPar = us.some(u => u.par);
  let best = null, pick = null;
  for (let per = Math.min(COLS, n); per >= maxW; per--) {
    const lines = flow(us, per), L = lines.length;
    if (L > 3) break;
    const colW = (W - 2 * M) / per, R = (availH - (L - 1) * GAP) / L;
    const s1 = Math.min(R * 0.72, colW - 8, 54), s2 = Math.min((R - 8) / 2, colW - 8, 46);
    const s = hasPar ? Math.min(s1, s2 * 1.25) : s1, cand = { lines, colW, R, s1, s2, s };
    if (!best || s > best.s + 0.5) best = cand;
    if (s >= 36) { pick = cand; break; }
  }
  const { lines, colW, R, s1, s2 } = pick || best;
  const L = lines.length, used = L * R + (L - 1) * GAP, y0 = top + (availH - used) / 2 + R / 2;
  const yOf = k => y0 + k * (R + GAP), rr = 6, lx = 5, rx = W - 5;
  const wire = d => `<path d="${d}" fill="none" stroke="${C.wire}" stroke-width="2" stroke-linejoin="round"/>`;
  let wires = '', tiles = '', dots = '';
  const cursorB = ui.cursor != null && o[ui.cursor] ? o[ui.cursor].b : null;
  lines.forEach((ln, k) => {
    const y = yOf(k), last = k === L - 1;
    let ci = 0, x = k === 0 ? 2 : lx;
    ln.forEach(u => {
      const xs = M + colW * ci, xe = M + colW * (ci + u.cols.length);
      wires += wire(`M${x} ${y}H${xs + (u.par ? 3 : 0)}`);
      if (!u.par) {
        const c = u.cols[0];
        wires += wire(`M${xs} ${y}H${xe}`);
        tiles += tile(A[c], (xs + xe) / 2, y, s1, p, A[c] === cursorB);
      } else {
        const off = s2 / 2 + 4, yT = y - off, yB = y + off, a = xs + 3, b = xe - 3;
        wires += wire(`M${a} ${yT}V${yB}M${b} ${yT}V${yB}M${a} ${yT}H${b}M${a} ${yB}H${b}`);
        dots += `<circle cx="${a}" cy="${y}" r="3" fill="${C.acc}"/><circle cx="${b}" cy="${y}" r="3" fill="${C.acc}"/>`;
        u.cols.forEach((c, j) => {
          const cx = xs + colW * (j + 0.5);
          if (A[c]) tiles += tile(A[c], cx, yT, s2, p, A[c] === cursorB);
          if (B[c]) tiles += tile(B[c], cx, yB, s2, p, B[c] === cursorB);
        });
      }
      x = xe - (u.par ? 3 : 0);
      ci += u.cols.length;
    });
    if (last) { wires += wire(`M${x} ${y}H${W - 2}`); dots += `<circle cx="2.5" cy="${yOf(0)}" r="2.5" fill="${C.tx3}"/><circle cx="${W - 2.5}" cy="${y}" r="2.5" fill="${C.tx3}"/>`; }
    else {
      /* retour à la ligne : à droite, descend dans l'interligne, revient à gauche, redescend */
      const y1 = yOf(k + 1), ym = y + R / 2 + GAP / 2;
      wires += wire(`M${x} ${y}H${rx - rr}Q${rx} ${y} ${rx} ${y + rr}V${ym - rr}Q${rx} ${ym} ${rx - rr} ${ym}H${lx + rr}Q${lx} ${ym} ${lx} ${ym + rr}V${y1 - rr}Q${lx} ${y1} ${lx + rr} ${y1}`);
    }
  });
  return wires + dots + tiles;
}

function blockPage(p) {
  const x = order(p).find(o => o.b.uid === ui.uid);
  if (!x) { goHome(); return home(p); }
  const m = MODEL[x.b.model], cat = CATS[m.cat], s = st(p, ui.uid) || { on: true, p: {} }, on = s.on;
  const HEAD = 46, ROW = 38, FOOTH = 24, rowsY = HEAD + 4, vis = Math.floor((H - rowsY - FOOTH) / ROW);
  const start = clamp(ui.pidx - Math.floor(vis / 2), 0, Math.max(0, m.params.length - vis));
  let out = `<rect width="${W}" height="${HEAD}" fill="${cat.color}" fill-opacity=".16"/><path d="M0 ${HEAD - .5}H${W}" stroke="${cat.color}" stroke-opacity=".5"/>
    ${tile(x.b, 25, HEAD / 2, 34, p, false)}
    <text x="50" y="22" fill="${C.tx}" font-family="${FONT}" font-size="15" font-weight="800">${esc(fit(m.name, 15, 800, FONT, 140))}</text>
    <text x="50" y="38" fill="${cat.color}" font-family="${MONO}" font-size="11" font-weight="700">${cat.short} · ${'AB'[x.lane]}${x.col + 1}</text>
    <rect x="${W - 52}" y="13" width="44" height="21" rx="10.5" fill="${on ? cat.color : '#2a2f37'}"/>
    <text x="${W - 30}" y="28" fill="${on ? '#0b0d10' : C.tx2}" font-family="${MONO}" font-size="12" font-weight="700" text-anchor="middle">${on ? 'ON' : 'OFF'}</text>`;
  m.params.slice(start, start + vis).forEach((pd, k) => {
    const i = start + k, y = rowsY + k * ROW, sel = i === ui.pidx, v = s.p[pd.id], f = frac(pd, v);
    const edit = sel && ui.editing;
    if (sel) out += `<rect x="4" y="${y}" width="${W - 8}" height="${ROW - 4}" rx="8" fill="${edit ? cat.color : '#1a1f26'}" fill-opacity="${edit ? .28 : 1}" stroke="${cat.color}" stroke-opacity="${edit ? 1 : .55}" stroke-width="${edit ? 2 : 1.2}"/>`;
    out += `<text x="13" y="${y + 21}" fill="${sel ? C.tx : C.tx2}" font-family="${FONT}" font-size="14" font-weight="700">${esc(fit(pd.name, 14, 700, FONT, 96))}</text>
      <text x="${W - 13}" y="${y + 21}" fill="${sel ? C.tx : C.tx2}" font-family="${MONO}" font-size="14" font-weight="700" text-anchor="end">${esc(fit(fmtVal(pd, v), 14, 700, MONO, 118))}</text>`;
    if (f != null) out += `<rect x="13" y="${y + 27}" width="${W - 26}" height="3" rx="1.5" fill="#262c34"/><rect x="13" y="${y + 27}" width="${((W - 26) * f).toFixed(1)}" height="3" rx="1.5" fill="${cat.color}"/>`;
  });
  out += `<text x="10" y="${H - 8}" fill="${C.tx3}" font-family="${MONO}" font-size="11" font-weight="700">${ui.pidx + 1}/${m.params.length}</text>
    <text x="${W - 10}" y="${H - 8}" fill="${ui.editing ? cat.color : C.tx3}" font-family="${MONO}" font-size="11" font-weight="700" text-anchor="end">${ui.editing ? '◆ RÉGLAGE' : 'PARA ⟳'}</text>`;
  return out;
}

function menuPage(title, sub, items, vals, sel, color, hint) {
  const HEAD = 44, ROW = 32, vis = Math.floor((H - HEAD - 22) / ROW);
  if (!items.length) return '';
  sel = clamp(sel, 0, items.length - 1);
  const start = clamp(sel - Math.floor(vis / 2), 0, Math.max(0, items.length - vis));
  let out = `<rect width="${W}" height="${HEAD}" fill="${color}" fill-opacity=".16"/><path d="M0 ${HEAD - .5}H${W}" stroke="${color}" stroke-opacity=".5"/>
    <text x="12" y="21" fill="${C.tx}" font-family="${FONT}" font-size="15" font-weight="800">${esc(fit(title, 15, 800, FONT, W - 24))}</text>
    <text x="12" y="37" fill="${color}" font-family="${MONO}" font-size="11" font-weight="700">${esc(fit(sub, 11, 700, MONO, W - 24))}</text>`;
  for (let k = 0; k < vis && start + k < items.length; k++) {
    const i = start + k, y = HEAD + 4 + k * ROW, on = i === sel;
    if (on) out += `<rect x="4" y="${y}" width="${W - 8}" height="${ROW - 4}" rx="8" fill="${color}" fill-opacity=".18" stroke="${color}" stroke-opacity=".63" stroke-width="1.2"/>`;
    out += `<text x="13" y="${y + 20}" fill="${on ? C.tx : C.tx2}" font-family="${FONT}" font-size="14" font-weight="700">${esc(fit(items[i], 14, 700, FONT, vals ? W - 76 : W - 26))}</text>`;
    if (vals) out += `<text x="${W - 13}" y="${y + 20}" fill="${on ? C.tx : C.tx3}" font-family="${MONO}" font-size="12" font-weight="700" text-anchor="end">${vals[i]}%</text>`;
  }
  out += `<text x="10" y="${H - 7}" fill="${C.tx3}" font-family="${MONO}" font-size="11" font-weight="700">${esc(fit(hint, 11, 700, MONO, W - 20))}</text>`;
  return out;
}
function actionPage(p) {
  const x = order(p).find(o => o.b.uid === ui.uid);
  if (!x) { goHome(); return home(p); }
  const m = MODEL[x.b.model], color = CATS[m.cat].color;
  return menuPage(m.name, `GESTION · ${ui.key} ${'AB'[x.lane]}${x.col + 1}`, ['+ Ajouter un bloc', 'Déplacer', 'Supprimer', 'Annuler'], null, ui.menu, color, 'PARA : choisir · appui : OK');
}
function addPage() {
  const ms = keyModels(ui.addKey);
  if (!ms.length) { goHome(); return home(P()); }
  return menuPage('AJOUTER UN BLOC', `${ui.addKey} · choisir un modèle`, ms.map(m => m.name), ms.map(m => m.dsp), ui.menu, CATS[ms[0].cat].color, 'PARA : choisir · appui : ajouter');
}
function confirmPage(p) {
  const x = order(p).find(o => o.b.uid === ui.uid);
  if (!x) { goHome(); return home(p); }
  const m = MODEL[x.b.model];
  return menuPage('SUPPRIMER CE BLOC', `Supprimer ${m.name} ?`, ['Oui', 'Non'], null, ui.menu, C.bad, 'PARA : choisir · appui : OK');
}
function movePage(p) {
  const x = order(p).find(o => o.b.uid === ui.uid);
  if (!x) { goHome(); return home(p); }
  const m = MODEL[x.b.model];
  return home(p) + `<rect x="0" y="${H - 46}" width="${W}" height="46" fill="${C.bar}" fill-opacity=".96"/><path d="M0 ${H - 45.5}H${W}" stroke="${C.line}"/>
    <text x="10" y="${H - 27}" fill="${C.tx}" font-family="${FONT}" font-size="15" font-weight="800">${esc(fit(m.name, 15, 800, FONT, W - 20))}</text>
    <text x="10" y="${H - 10}" fill="${CATS[m.cat].color}" font-family="${MONO}" font-size="11" font-weight="700">PARA : déplacer · appui : terminer</text>`;
}
function home(p) { return chain(p) + topBar(p); /* écran principal : preset + batterie + chaîne, rien d'autre */ }

function presetOverlay(p) {
  const words = p.name.split(' '), lines = [''];
  mctx.font = `800 28px ${FONT}`;
  words.forEach(w => { const t = (lines[lines.length - 1] + ' ' + w).trim(); if (mctx.measureText(t).width > W - 24 && lines[lines.length - 1]) lines.push(w); else lines[lines.length - 1] = t; });
  const y0 = H / 2 - (lines.length - 1) * 16 + 6;
  return `<rect width="${W}" height="${H}" fill="${C.bg}" fill-opacity=".95"/>
    <text x="${W / 2}" y="${y0 - 38}" fill="${p.color || C.acc}" font-family="${MONO}" font-size="22" font-weight="700" text-anchor="middle">${presetLabel(S.cur)}</text>
    ${lines.slice(0, 3).map((l, i) => `<text x="${W / 2}" y="${y0 + i * 32}" fill="${C.tx}" font-family="${FONT}" font-size="28" font-weight="800" text-anchor="middle">${esc(fit(l, 28, 800, FONT, W - 14))}</text>`).join('')}`;
}
function masterOverlay() {
  const v = G().outLevel != null ? G().outLevel : 0, f = (v + 60) / 66;
  return `<rect x="16" y="80" width="${W - 32}" height="92" rx="14" fill="#151a20" stroke="${C.line}"/>
    <text x="${W / 2}" y="106" fill="${C.tx3}" font-family="${MONO}" font-size="12" font-weight="700" text-anchor="middle">MASTER</text>
    <text x="${W / 2}" y="140" fill="${C.tx}" font-family="${MONO}" font-size="28" font-weight="700" text-anchor="middle">${v > 0 ? '+' : ''}${v.toFixed(1)} dB</text>
    <rect x="34" y="153" width="${W - 68}" height="6" rx="3" fill="#262c34"/><rect x="34" y="153" width="${((W - 68) * f).toFixed(1)}" height="6" rx="3" fill="${C.acc}"/>`;
}
function msgOverlay(text) {
  return `<rect x="16" y="96" width="${W - 32}" height="58" rx="14" fill="#151a20" stroke="${C.line}"/>
    <text x="${W / 2}" y="131" fill="${C.tx}" font-family="${FONT}" font-size="16" font-weight="700" text-anchor="middle">${esc(text)}</text>`;
}
function tunerScreen() {
  const tn = tuner, ok = tn.level && Math.abs(tn.cents) < 3, col = ok ? C.ok : C.tx;
  const cx = W / 2, barY = 176, span = 214, x = cx + clamp(tn.cents, -50, 50) / 50 * span / 2;
  let ticks = '';
  for (let c = -50; c <= 50; c += 10) { const tx = cx + c / 50 * span / 2; ticks += `<path d="M${tx} ${barY - (c % 50 === 0 || c === 0 ? 11 : 6)}V${barY}" stroke="${c === 0 ? C.ok : C.tx3}" stroke-width="${c === 0 ? 2.5 : 1.5}"/>`; }
  return `<rect width="${W}" height="${H}" fill="${ok ? '#0b1a12' : C.bg}"/>
    <text x="${cx}" y="24" fill="${C.tx3}" font-family="${MONO}" font-size="12" font-weight="700" text-anchor="middle">TUNER · ${G().a4 || 440} Hz</text>
    ${tn.level ? `<text x="${cx}" y="138" fill="${col}" font-family="${FONT}" font-size="100" font-weight="800" text-anchor="middle">${NOTE_NAMES[tn.note]}<tspan font-size="30" fill="${C.tx2}" dy="-56">${tn.oct}</tspan></text>`
      : `<text x="${cx}" y="118" fill="${C.tx3}" font-family="${FONT}" font-size="18" font-weight="700" text-anchor="middle">Joue une corde</text>`}
    <rect x="${cx - span / 2}" y="${barY}" width="${span}" height="5" rx="2.5" fill="#1d2228"/>
    ${ticks}
    ${tn.level ? `<path d="M${x} ${barY - 20}V${barY + 14}" stroke="${col}" stroke-width="4" stroke-linecap="round"/>
    <text x="${cx}" y="226" fill="${C.tx2}" font-family="${MONO}" font-size="18" font-weight="700" text-anchor="middle">${tn.cents > 0 ? '+' : ''}${tn.cents.toFixed(1)}</text>` : ''}`;
}

function render() {
  const p = P();
  if (lastCur !== null && lastCur !== S.cur) { overlay = { kind: 'preset', until: performance.now() + 900 }; setTimeout(render, 950); }
  lastCur = S.cur;
  let svg = `<rect width="${W}" height="${H}" fill="${C.bg}"/>`;
  if (tuner) svg += tunerScreen();
  else {
    if (ui.view === 'block') svg += blockPage(p);
    else if (ui.view === 'action') svg += actionPage(p);
    else if (ui.view === 'add') svg += addPage();
    else if (ui.view === 'confirm') svg += confirmPage(p);
    else if (ui.view === 'move') svg += movePage(p);
    else svg += home(p);
    if (overlay && performance.now() < overlay.until) svg += overlay.kind === 'preset' ? presetOverlay(p) : overlay.kind === 'master' ? masterOverlay() : msgOverlay(overlay.text);
  }
  scr.innerHTML = svg;
  [0, 1].forEach(i => {
    const f = resolve(i), led = ledOf(i), el = $(i ? '#ledR' : '#ledL');
    el.classList.toggle('on', led.on); el.style.setProperty('--c', led.c);
    $(i ? '#capR' : '#capL').textContent = (i ? 'Droite : ' : 'Gauche : ') + label(f.press) + ' · maintien ' + label(f.hold);
  });
  const modal = ['block', 'action', 'add', 'confirm', 'move'].includes(ui.view);
  document.querySelectorAll('#keys button').forEach(b => b.classList.toggle('on', modal && b.dataset.k === ui.key));
}

/* ---------- Accordeur simulé ---------- */
function openTuner() {
  const strings = [[4, 2], [9, 2], [2, 3], [7, 3], [11, 3], [4, 4]];
  let si = 0, since = 0;
  tuner = { note: 4, oct: 2, cents: 25, level: 1 };
  tuner.timer = setInterval(() => {
    since += 60;
    if (since > 3600) { since = 0; si = (si + 1) % strings.length; tuner.cents = Math.random() * 80 - 40; }
    tuner.cents += (0 - tuner.cents) * 0.04 + (Math.random() - 0.5) * 1.4;
    [tuner.note, tuner.oct] = strings[si];
    tuner.level = since < 3100 ? 1 : 0;
    render();
  }, 60);
  render();
}
function closeTuner() { clearInterval(tuner.timer); tuner = null; render(); }

/* ---------- Commandes physiques ---------- */
function bindFs(btn, i) {
  let t = 0, held = false;
  btn.addEventListener('pointerdown', () => { held = false; t = setTimeout(() => { held = true; act(resolve(i).hold); }, 550); });
  btn.addEventListener('pointerup', () => { clearTimeout(t); if (!held) act(resolve(i).press); });
  btn.addEventListener('pointerleave', () => clearTimeout(t));
}
bindFs($('#fsL'), 0);
bindFs($('#fsR'), 1);
$('#fsLR').addEventListener('click', () => act(G().fsCombo || 'tuner'));
/* les commandes de la façade ne gardent pas le focus (comme de vrais boutons) */
document.querySelectorAll('.pedal button, .knob').forEach(el => el.addEventListener('mousedown', e => e.preventDefault()));
/* touches : appui court = page suivante ; maintien ~0,55 s = gestion du bloc */
let keyTimer = 0, keyBtn = null, keyHeld = false;
$('#keys').addEventListener('pointerdown', e => {
  const b = e.target.closest('button'); if (!b) return;
  e.preventDefault();
  keyBtn = b; keyHeld = false; clearTimeout(keyTimer);
  try { b.setPointerCapture(e.pointerId); } catch { /* */ }
  keyTimer = setTimeout(() => {
    if (!keyBtn) return;
    keyHeld = true;
    if (b.dataset.k === 'HOME') pressKey('HOME');
    else { pressKey(b.dataset.k); holdKey(b.dataset.k); }   /* comme le firmware : l'appui navigue, le maintien ouvre la gestion */
  }, 550);
});
const keyEnd = () => {
  if (!keyBtn) return;
  clearTimeout(keyTimer);
  const b = keyBtn; keyBtn = null;
  if (!keyHeld) pressKey(b.dataset.k);
  keyHeld = false;
};
$('#keys').addEventListener('pointerup', keyEnd);
$('#keys').addEventListener('pointercancel', () => { clearTimeout(keyTimer); keyBtn = null; keyHeld = false; });

/* Encodeur rotatif : molette ou glisser vertical (un cran tous les 14 px) ; clic = appui ; maintien = action longue */
function encoder(el, onTurn, onPress, onHold) {
  let angle = 0;
  const turn = d => { angle += d * 15; el.style.setProperty('--a', angle + 'deg'); onTurn(d); };
  el.addEventListener('wheel', e => { e.preventDefault(); turn(e.deltaY < 0 ? 1 : -1); }, { passive: false });
  el.addEventListener('pointerdown', e => {
    el.setPointerCapture(e.pointerId);
    let y = e.clientY, moved = false, held = false;
    const t = onHold ? setTimeout(() => { if (!moved) { held = true; el.classList.remove('pressed'); onHold(); } }, 600) : 0;
    el.classList.add('pressed');
    const mv = ev => { const dy = y - ev.clientY; if (Math.abs(dy) >= 14) { moved = true; clearTimeout(t); el.classList.remove('pressed'); turn(dy > 0 ? 1 : -1); y = ev.clientY; } };
    const up = () => {
      clearTimeout(t); el.classList.remove('pressed');
      el.removeEventListener('pointermove', mv); el.removeEventListener('pointerup', up); el.removeEventListener('pointercancel', up);
      if (!moved && !held && onPress) onPress();
    };
    el.addEventListener('pointermove', mv); el.addEventListener('pointerup', up); el.addEventListener('pointercancel', up);
  });
}
encoder($('#para'), paraTurn, paraPress, paraHold);
encoder($('#master'), masterTurn);

document.addEventListener('keydown', e => {
  if (e.target.closest('input')) return;
  const k = e.key;
  if (['ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown', 'Enter', 'Escape', 'h', 'H'].includes(k)) e.preventDefault(); // pas de « clic clavier » sur le bouton qui a le focus
  if (k === 'ArrowLeft') act(resolve(0).press);
  else if (k === 'ArrowRight') act(resolve(1).press);
  else if (k === 'ArrowUp') { e.preventDefault(); paraTurn(-1); }
  else if (k === 'ArrowDown') { e.preventDefault(); paraTurn(1); }
  else if (k === 'Enter') paraPress();
  else if (k === 'h' || k === 'H' || k === 'Escape') pressKey('HOME');
});

/* ---------- Échelle ----------
 * « Taille réelle » : la façade est en millimètres (113 × 109 mm, écran de diagonale réglable,
 * 1,54″ d'après le manuel). Les pixels CSS n'ont pas de taille physique fixe : on calibre
 * avec une carte bancaire (85,6 mm). On mémorise des pixels physiques par mm pour que le
 * calibrage survive au zoom du navigateur (devicePixelRatio).
 * « Écran 240 px » : l'écran est affiché à 240 × 240 pixels CSS (1 pixel CSS = 1 pixel de l'écran). */
const PREF = k => { try { return localStorage.getItem(k); } catch { return null; } };
const SAVE = (k, v) => { try { localStorage.setItem(k, v); } catch { /* */ } };
let scaleMode = PREF('tbbr.ecran.mode') || 'real';
if (!['real', 'px'].includes(scaleMode)) scaleMode = 'real';
let physPerMm = +PREF('tbbr.ecran.physmm') || 0;           // pixels physiques / mm (0 = non calibré)
const cssPerMm = () => physPerMm ? physPerMm / (window.devicePixelRatio || 1) : 96 / 25.4;
const sideMm = () => clamp(+$('#diag').value || 1.54, 0.8, 3) / Math.SQRT2 * 25.4;
$('#diag').value = PREF('tbbr.ecran.diag2') || '1.54';
function applyScale() {
  const side = sideMm();
  const mm = EMBED ? Math.min(innerWidth / 117, innerHeight / 116)        // façade 113 × 109 mm + ombre, ajustée au cadre
    : scaleMode === 'real' ? cssPerMm() : W / side;
  const root = document.documentElement.style;
  root.setProperty('--mm', mm.toFixed(4) + 'px');
  document.querySelector('.pedal').style.setProperty('--side', side.toFixed(2));
  document.body.classList.toggle('real', scaleMode === 'real');
  document.body.classList.toggle('uncal', !physPerMm);
  document.querySelectorAll('#scale button').forEach(b => b.classList.toggle('on', b.dataset.s === scaleMode));
  SAVE('tbbr.ecran.mode', scaleMode); SAVE('tbbr.ecran.diag2', $('#diag').value);
}
$('#scale').addEventListener('click', e => { const b = e.target.closest('button'); if (b) { scaleMode = b.dataset.s; applyScale(); } });
$('#diag').addEventListener('input', applyScale);
window.addEventListener('resize', applyScale); // le zoom navigateur change devicePixelRatio
applyScale();

/* Calibrage à la carte bancaire */
const calib = $('#calib'), range = $('#cRange'), card = $('#card');
const setCard = v => { range.value = v; card.style.setProperty('--cw', (85.6 * v).toFixed(1) + 'px'); };
$('#calibBtn').addEventListener('click', () => { setCard(cssPerMm().toFixed(3)); calib.hidden = false; });
range.addEventListener('input', () => setCard(range.value));
$('#cMinus').addEventListener('click', () => setCard((+range.value - 0.01).toFixed(3)));
$('#cPlus').addEventListener('click', () => setCard((+range.value + 0.01).toFixed(3)));
$('#cCancel').addEventListener('click', () => { calib.hidden = true; });
$('#cOk').addEventListener('click', () => {
  physPerMm = +range.value * (window.devicePixelRatio || 1);
  SAVE('tbbr.ecran.physmm', physPerMm.toFixed(4));
  calib.hidden = true; scaleMode = 'real'; applyScale();
});

/* ---------- Synchronisation avec l'éditeur ---------- */
window.addEventListener('storage', e => { if (e.key === LS_KEY) { load(); render(); } });
if (BC) {
  BC.onmessage = e => {
    const m = e.data || {};
    if (m.type === 'info' && m.info) { info = { ...info, ...m.info }; linked = true; }
    if (m.type === 'state') { load(); linked = true; }
    $('#sync').textContent = linked ? 'éditeur lié' : 'autonome';
    $('#sync').classList.toggle('on', linked);
    render();
  };
  post({ type: 'hello' });
}

load();
if (document.fonts && document.fonts.ready) document.fonts.ready.then(render);
render();
/* LED du HOME = tap tempo (comme le firmware) */
const homeBtn = document.querySelector('#keys button[data-k="HOME"]');
setInterval(() => {
  const bpm = clamp(P().tempo || 120, 40, 250);
  homeBtn.classList.toggle('tap', performance.now() % (60000 / bpm) < 80);
}, 30);
})();
