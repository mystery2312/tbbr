/* protocol.test.js : tests de bout en bout app <-> firmware, au niveau protocole, contre l'émulateur (vrai proto.c + engine.c).
 * Lancer : node --test tests/e2e/protocol.test.js   (après tests/e2e/emu/build.ps1) */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const zlib = require('node:zlib');
const { Pedal, CMD } = require('./lib/pedal');
const A = require('./lib/appcode').load();

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-e2e-'));
const FW_MAIN = fs.readFileSync(path.join(__dirname, '..', '..', 'fw_maison', 'fw6', 'main.c'), 'utf8');
const FW_VERSION = FW_MAIN.match(/#define FW_VERSION "([^"]+)"/)[1];

async function withPedal(fn, opts) {
  const p = new Pedal(opts);
  try { await p.info(); return await fn(p); }
  finally { await p.close(); }
}
const list = p => p.json(CMD.PRESET_LIST, [], CMD.PRESET_LIST, 0);
const cur = p => p.json(CMD.PRESET_GET, [0x7F], CMD.PRESET_GET, 0x7F);
const slot = (p, i) => p.json(CMD.PRESET_GET, [i], CMD.PRESET_GET, i);
const f32 = v => { const b = Buffer.alloc(4); b.writeFloatLE(v); return b; };
const param = (lane, col, idx, v) => Buffer.concat([Buffer.from([lane, col, idx]), f32(v)]);

/* --- catalogue : l'app et le firmware parlent des mêmes modèles, avec les mêmes coûts --- */
test('INFO : version, catalogue et coûts DSP identiques à data.js', () => withPedal(async p => {
  const info = await p.info();
  assert.equal(info.fw, FW_VERSION);
  assert.equal(info.presets, A.PRESETS); assert.equal(info.irSlots, A.IR_SLOTS); assert.equal(info.namSlots, A.NAM_SLOTS);
  assert.ok(Array.isArray(info.models) && Array.isArray(info.dsp), 'INFO.models / INFO.dsp');
  const appIds = A.MODELS.map(m => m.id);
  for (const id of info.models) assert.ok(A.MODEL[id], 'modèle firmware inconnu de l\'app : ' + id);
  for (const id of appIds) assert.ok(info.models.includes(id), 'modèle de l\'app absent du firmware : ' + id);
  const diff = info.models.map((id, i) => [id, info.dsp[i], A.MODEL[id].dsp]).filter(([, a, b]) => a !== b);
  assert.deepEqual(diff, [], 'coûts DSP firmware != data.js');
  if (typeof info.namCpu === 'number' && typeof A.MODEL.nam.cpu2 === 'number') assert.equal(info.namCpu, A.MODEL.nam.cpu2);
}));

/* --- premier démarrage : banque d'usine installée, lisible et identique aux presets d'usine de l'app --- */
test('flash vierge : la banque d\'usine est installée et relue comme dans l\'app', () => withPedal(async p => {
  const l = await list(p);
  const fac = A.factoryPresets().filter(x => x.name !== 'Init');
  const names = l.presets.filter(Boolean);
  assert.ok(names.length >= 10, 'au moins 10 presets d\'usine (' + names.length + ')');
  for (let i = 0; i < names.length; i++) {
    const c = await slot(p, i);
    assert.ok(c && Array.isArray(c.lanes), 'preset ' + i + ' illisible');
    for (const lane of c.lanes) for (const m of lane) if (m) assert.ok(A.MODEL[m], 'preset ' + i + ' : modèle inconnu ' + m);
    const e = A.expandPreset(c);                                       /* même chemin que l'app (pedalReadCurrent) */
    assert.equal(e.scenes.length, A.SCENES);
    const f = fac.find(x => x.name.slice(0, 20) === e.name.slice(0, 20));
    if (f) assert.deepEqual(e.lanes.map(r => r.map(b => b && b.model)), f.lanes.map(r => r.map(b => b && b.model)), 'blocs du preset ' + e.name);
  }
  const st = await p.flashStats();
  assert.equal(st.badWrites, 0, 'écriture flash sans effacement'); assert.equal(st.refused, 0, 'accès flash refusé');
}));

/* --- aller-retour complet : preset de l'app -> pédale (PRESET_SET) -> état réel (PRESET_GET 0x7F) -> app --- */
test('PRESET_SET puis PRESET_GET : chaque preset d\'usine de l\'app fait l\'aller-retour sans perte', () => withPedal(async p => {
  const fac = A.factoryPresets().filter(x => x.name !== 'Init');
  for (const src of fac) {
    const c = A.compactPreset(src, 3);
    assert.equal(await p.cmd(CMD.PRESET_SET, c), true, 'PRESET_SET refusé : ' + src.name);
    const back = await cur(p);
    assert.ok(back, 'pas d\'état relu pour ' + src.name);
    assert.deepEqual(back.lanes, c.lanes, 'blocs de ' + src.name);
    assert.equal(back.scenes.length, c.scenes.length);
    for (let s = 0; s < c.scenes.length; s++) {
      const a = c.scenes[s].b, b = back.scenes[s].b;
      assert.equal(b.length, a.length, src.name + ' scène ' + s);
      for (let k = 0; k < a.length; k++) {
        assert.deepEqual(b[k].slice(0, 3), a[k].slice(0, 3), src.name + ' scène ' + s + ' bloc ' + k);
        for (let j = 3; j < a[k].length; j++) assert.ok(Math.abs(b[k][j] - a[k][j]) <= Math.max(0.011, Math.abs(a[k][j]) * 1e-3), `${src.name} scène ${s} bloc ${k} param ${j - 3} : ${b[k][j]} != ${a[k][j]}`);
      }
    }
    const a = await p.audio(4800);
    assert.equal(a.bad, 0, 'échantillons invalides en sortie (' + src.name + ')');
  }
}));

test('noms de scènes français d\'anciens presets migrés en anglais', () => withPedal(async p => {
  const src = A.factoryPresets()[0], c = A.compactPreset(src, 0);
  c.scenes[0].n = 'Rythme'; c.scenes[4].n = 'Ambiance'; c.scenes[5].n = 'Scène F';
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  const back = await cur(p);
  assert.deepEqual(back.scenes.slice(0, 6).map(s => s.n), ['Rhythm', c.scenes[1].n, c.scenes[2].n, c.scenes[3].n, 'Ambience', 'Scene F']);
}));

/* --- sauvegarde, redémarrage, persistance --- */
test('PRESET_SAVE dans un emplacement puis redémarrage : le preset et son nom restent', () => withPedal(async p => {
  const src = A.factoryPresets()[2], c = A.compactPreset(src, 41);
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  assert.equal(await p.cmd(CMD.PARAM, param(0, 0, 0, 3.5)), true, 'PARAM sur le 1er bloc');
  assert.equal(await p.cmd(CMD.PRESET_SAVE, Buffer.concat([Buffer.from([41]), Buffer.from('E2E sauvé', 'utf8')])), true);
  await p.reboot();
  const l = await list(p);
  assert.equal(l.presets[41], 'E2E sauvé');
  const s = await slot(p, 41);
  assert.deepEqual(s.lanes, c.lanes);
  const blk = s.scenes[s.scene].b.find(r => r[0] === 0 && r[1] === 0);
  assert.ok(Math.abs(blk[3] - 3.5) < 0.01, 'paramètre modifié en direct puis sauvé : ' + blk[3]);
  assert.equal((await p.flashStats()).badWrites, 0);
}));

/* --- budget DSP : la pédale refuse ce que l'app refuse --- */
test('budget DSP : BLOCK_SET au-delà de 115 % refusé, preset trop lourd refusé sans casser le preset courant', () => withPedal(async p => {
  const c = A.compactPreset(A.factoryPresets()[0], 0);
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  const before = await cur(p);
  const heavy = JSON.parse(JSON.stringify(c));
  heavy.lanes = [['rect', 'rect', 'rect', 'rect', 'rect', null, null, null], [null, null, null, null, null, null, null, null]];
  heavy.scenes = heavy.scenes.map(s => ({ n: s.n, b: [0, 1, 2, 3, 4].map(col => [0, col, 1]) }));
  assert.equal(await p.cmd(CMD.PRESET_SET, heavy), false, 'preset 5 x Rectifier accepté');
  assert.deepEqual((await cur(p)).lanes, before.lanes, 'le preset courant a changé après un refus');
  /* remplir colonne par colonne jusqu'au refus : le total accepté ne dépasse jamais 115 % */
  const info = await p.info(), cost = id => info.dsp[info.models.indexOf(id)];
  let total = (before.lanes.flat().filter(Boolean)).reduce((s, m) => s + cost(m), 0), refused = false;
  for (let col = 0; col < A.COLS && !refused; col++) {
    if (before.lanes[1][col]) continue;
    const ok = await p.cmd(CMD.BLOCK_SET, { lane: 1, col, model: 'rect' });
    if (ok) { total += cost('rect'); assert.ok(total <= 115, 'total accepté ' + total + ' %'); } else refused = true;
  }
  assert.ok(refused, 'aucun refus alors que le budget est dépassé');
}));

/* --- IR : transfert comme l'app (240 échantillons par morceau), persistance, effacement de l'ancien contenu --- */
async function sendIr(p, s, name, seed) {
  const x = Int16Array.from({ length: 2048 }, (_, i) => Math.round(30000 * Math.exp(-i / (200 + seed)) * Math.cos(i * (0.3 + seed / 100))));
  assert.equal(await p.cmd(CMD.IR_BEGIN, { slot: s, name, len: 2048, rate: 48000, fmt: 's16le' }), true);
  for (let i = 0, k = 0; i < 2048; i += 240, k++) {
    const n = Math.min(240, 2048 - i), b = Buffer.alloc(3 + n * 2);
    b[0] = s; b[1] = k & 255; b[2] = k >> 8;
    for (let j = 0; j < n; j++) b.writeInt16LE(x[i + j], 3 + j * 2);
    p.send(CMD.IR_CHUNK, b);
  }
  return p.cmd(CMD.IR_END, [s]);
}
test('IR : envoi, réécriture du même slot, redémarrage', () => withPedal(async p => {
  assert.equal(await sendIr(p, 5, 'E2E IR A', 1), true);
  assert.equal(await sendIr(p, 5, 'E2E IR B', 7), true, 'réécriture du slot');
  assert.equal((await p.flashStats()).badWrites, 0, 'IR réécrite sans effacement complet');
  await p.reboot();
  assert.equal((await list(p)).ir[5], 'E2E IR B');
  assert.equal(await p.cmd(CMD.IR_BEGIN, { slot: 99, name: 'x', len: 2048, rate: 48000 }), false, 'slot hors limites accepté');
  assert.equal(await p.cmd(CMD.IR_BEGIN, { slot: 1, name: 'x', len: 2048, rate: 44100 }), false, '44,1 kHz accepté');
}));

/* --- NAM : poids float32 du A2 Lite, CRC vérifié sur la flash relue --- */
async function sendNam(p, s, name, crcOverride) {
  const w = Float32Array.from({ length: 1871 }, (_, i) => Math.sin(i * 0.37) * 0.1);
  const blob = Buffer.from(w.buffer), crc = zlib.crc32(blob) >>> 0;
  assert.equal(await p.cmd(CMD.NAM_BEGIN, { slot: s, name, a2: true, sr: 48000, cfgLen: 0, nWeights: 1871, size: blob.length, crc: crcOverride ?? crc }), true);
  for (let i = 0, k = 0; i < blob.length; i += 480, k++) p.send(CMD.NAM_CHUNK, Buffer.concat([Buffer.from([s, k & 255, k >> 8]), blob.subarray(i, i + 480)]));
  const e = Buffer.alloc(5); e[0] = s; e.writeUInt32LE(crcOverride ?? crc, 1);
  return p.cmd(CMD.NAM_END, e);
}
test('NAM : envoi, CRC faux refusé, suppression, redémarrage', () => withPedal(async p => {
  assert.equal(await sendNam(p, 3, 'E2E NAM'), true);
  assert.equal(await sendNam(p, 4, 'E2E NAM KO', 12345), false, 'CRC faux accepté');
  await p.reboot();
  let l = await list(p);
  assert.equal(l.nam[3], 'E2E NAM'); assert.equal(l.nam[4], '');
  assert.equal(await p.cmd(CMD.NAM_DELETE, [3]), true);
  l = await list(p);
  assert.equal(l.nam[3], '');
  assert.equal((await p.flashStats()).badWrites, 0);
}));

test('PRESET_LIST : empreintes CRC32 des slots NAM et IR (reconnaissance d\'une capture déjà présente), après redémarrage aussi', () => withPedal(async p => {
  let l = await list(p);
  assert.ok(Array.isArray(l.namCrc) && l.namCrc.length === A.NAM_SLOTS && l.namCrc.every(v => v === 0), 'namCrc vide attendu');
  assert.ok(Array.isArray(l.irCrc) && l.irCrc.length === A.IR_SLOTS && l.irCrc.every(v => v === 0), 'irCrc vide attendu');
  assert.equal(await sendNam(p, 6, 'CRC NAM'), true);
  assert.equal(await sendIr(p, 11, 'CRC IR', 5), true);
  const w = Float32Array.from({ length: 1871 }, (_, i) => Math.sin(i * 0.37) * 0.1);
  const namCrc = zlib.crc32(Buffer.from(w.buffer)) >>> 0;
  const sec = Buffer.alloc(4096, 0xFF);                                 /* secteur IR tel qu'écrit : int16 LE puis 0xFF */
  for (let i = 0; i < 2048; i++) sec.writeInt16LE(Math.round(30000 * Math.exp(-i / 205) * Math.cos(i * 0.35)), i * 2);
  const irCrc = zlib.crc32(sec) >>> 0;
  for (const when of ['après envoi', 'après redémarrage']) {
    l = await list(p);
    assert.equal(l.namCrc[6], namCrc, when + ' : CRC NAM'); assert.equal(l.irCrc[11], irCrc, when + ' : CRC IR');
    await p.reboot();
  }
  assert.equal(await p.cmd(CMD.NAM_DELETE, [6]), true);
  assert.equal((await list(p)).namCrc[6], 0);
}));

/* --- réglages globaux --- */
test('GLOBAL : gate d\'entrée et mode footswitch mémorisés après redémarrage', () => withPedal(async p => {
  assert.equal(await p.cmd(CMD.GLOBAL, { inGateOn: 0, inGate: -55 }), true);
  assert.equal(await p.cmd(CMD.GLOBAL, { fsMode: 'scene' }), true);
  await p.reboot();
  const info = await p.info();
  assert.equal(info.inGateOn, 0); assert.equal(info.inGate, -55); assert.equal(info.fsMode, 'scene');
}));

test('Bluetooth activé puis coupé : gate, mode footswitch et banque d\'usine conservés', () => withPedal(async p => {
  assert.equal(await p.cmd(CMD.GLOBAL, { inGateOn: 0, inGate: -52, fsMode: 'scene' }), true);
  const c = A.compactPreset(A.factoryPresets()[1], 70);
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  assert.equal(await p.cmd(CMD.PRESET_SAVE, Buffer.concat([Buffer.from([70]), Buffer.from('Mien')])), true);
  const before = await list(p);
  assert.equal(await p.cmd(CMD.GLOBAL, { bt: 'on' }), true);
  assert.equal(await p.cmd(CMD.GLOBAL, { bt: 'off' }), true);
  await p.reboot();
  const info = await p.info();
  assert.equal(info.inGateOn, 0, 'gate réactivé par le Bluetooth'); assert.equal(info.inGate, -52, 'seuil du gate perdu');
  assert.equal(info.fsMode, 'scene', 'mode footswitch perdu');
  assert.deepEqual((await list(p)).presets, before.presets, 'presets modifiés au redémarrage');
}));

/* --- remise à zéro usine --- */
test('FACTORY_RESET [0x5A] : presets, IR, NAM et réglages effacés, banque d\'usine réinstallée', () => withPedal(async p => {
  const c = A.compactPreset(A.factoryPresets()[1], 60);
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  assert.equal(await p.cmd(CMD.PRESET_SAVE, Buffer.concat([Buffer.from([60]), Buffer.from('A effacer')])), true);
  assert.equal(await sendIr(p, 9, 'IR à effacer', 3), true);
  assert.equal(await sendNam(p, 2, 'NAM à effacer'), true);
  assert.equal(await p.cmd(CMD.GLOBAL, { inGateOn: 0, inGate: -50, fsMode: 'stomp' }), true);
  const fresh = (await list(p)).presets.filter(Boolean).length;
  assert.equal(await p.cmd(CMD.FACTORY_RESET, [0x5A], 30000), true);
  const sel = await p.waitFrame(f => f.cmd === CMD.PRESET_SELECT, 2000);
  assert.ok(sel && sel.payload[1] === 2, 'l\'app doit être prévenue (PRESET_SELECT, besoin = 2)');
  for (const when of ['après reset', 'après redémarrage']) {
    const l = await list(p);
    assert.equal(l.presets[60], '', when + ' : preset utilisateur encore là');
    assert.equal(l.ir[9], '', when + ' : IR utilisateur encore là');
    assert.equal(l.nam[2], '', when + ' : NAM encore là');
    assert.equal(l.presets.filter(Boolean).length, fresh - 1, when + ' : banque d\'usine incomplète');
    const info = await p.info();
    assert.equal(info.inGateOn, 1, when + ' : gate'); assert.equal(info.inGate, -68, when + ' : seuil du gate');
    assert.equal(info.fsMode, 'preset', when + ' : mode footswitch');
    await p.reboot();
  }
  assert.equal((await p.flashStats()).badWrites, 0);
}));

test('FACTORY_RESET : commande inconnue refusée, rien d\'effacé', () => withPedal(async p => {
  const before = await list(p);
  assert.equal(await p.cmd(CMD.FACTORY_RESET, [0x33]), false);
  assert.deepEqual(await list(p), before);
}));

/* --- scènes, bypass, tempo --- */
test('scènes et bypass : l\'état de chaque scène est conservé', () => withPedal(async p => {
  const c = A.compactPreset(A.factoryPresets()[0], 0);
  assert.equal(await p.cmd(CMD.PRESET_SET, c), true);
  assert.equal(await p.cmd(CMD.SCENE_SELECT, [1]), true);
  assert.equal(await p.cmd(CMD.BYPASS, [0, 0, 0]), true);
  assert.equal(await p.cmd(CMD.SCENE_SELECT, [0]), true);
  const s = await cur(p);
  assert.equal(s.scene, 0);
  const on = sc => s.scenes[sc].b.find(r => r[0] === 0 && r[1] === 0)[2];
  assert.equal(on(1), 0, 'bypass de la scène 2 perdu');
  assert.equal(on(0), c.scenes[0].b.find(r => r[0] === 0 && r[1] === 0)[2], 'scène 1 modifiée par erreur');
  assert.equal(await p.cmd(CMD.SCENE_SELECT, [8]), false, 'scène 9 acceptée');
  assert.equal(await p.cmd(CMD.PARAM, param(0, 7, 0, 1)), false, 'PARAM sur une case vide accepté');
}));

test('robustesse : trames corrompues ou tronquées ignorées, la pédale répond toujours', () => withPedal(async p => {
  const { sysexOf } = require('./lib/pedal');
  const good = sysexOf(CMD.HELLO, { app: 'x' });
  const bad = Buffer.from(good); bad[8] ^= 0x01;                      /* XOR faux */
  p.sysex(bad); p.sysex(good.subarray(0, 9)); p.sysex(Buffer.from([0xF0, 0x7D, 0x42, 0x58, 0x70, 0xF7]));
  p.sysex(sysexOf(CMD.PRESET_SET, '{"lanes":[["brit"'));               /* JSON tronqué */
  p.sysex(sysexOf(0x77, [1, 2, 3]));                                   /* commande inconnue */
  assert.ok(await p.info(), 'plus de réponse après des trames invalides');
  assert.ok(await cur(p), 'état illisible après des trames invalides');
}));
