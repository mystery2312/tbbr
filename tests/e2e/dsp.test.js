/* dsp.test.js : traitement audio des blocs optimisés, sur le vrai engine.c (émulateur, commande 'D').
 *  - gate / compresseurs : calcul du gain en virgule fixe (log2 / exp2) comparé à l'ancien calcul flottant (log10f / powf),
 *    réimplémenté ici à l'identique ;
 *  - réverbes calculées par blocs de 128 : le pré-délai compense exactement le bloc (arrivée de l'humide inchangée). */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { Pedal } = require('./lib/pedal');

const CAT = fs.readFileSync(path.join(__dirname, '..', '..', 'fw_maison', 'fw6', 'catalog.h'), 'utf8');
const def = n => { const m = CAT.match(new RegExp('#define ' + n + ' (\\d+)\\b')); if (!m) throw new Error(n + ' absent de catalog.h'); return +m[1]; };
const N = 3 * 36000;                                                      /* 3 notes : forte, moyenne, faible (+ silences) */
const f32 = Math.fround;
const floorDiv = (a, d) => Math.floor(a / d);                             /* décalage arithmétique d'un produit 64 bits */
const mulq15 = (x, g) => floorDiv(x * g, 32768), mulq16 = (x, g) => floorDiv(x * g, 65536);
const clamp = (v, a, b) => v < a ? a : (v > b ? b : v);
const db2q16 = db => Math.trunc(f32(Math.pow(10, clamp(db, -96, 40) / 20)) * 65536);
const pct2q15 = p => Math.trunc(f32(clamp(p, 0, 100) * f32(327.67)));
const coef = ms => Math.trunc(f32(32768 * f32(1 - f32(Math.pow(2.718, f32(-1 / f32(f32(ms * f32(0.001)) * 48000)))))));

/* ancien run_dyn (engine.c fw6 0.16) : enveloppe entière, gain toutes les 32 échantillons en flottant */
function refDyn(x, { gate, thr, ratio, att, rel, floor_db = -96, mix = 100, lvl = 0 }) {
  const a1 = coef(clamp(att, 0.1, 1000)), r1 = coef(clamp(rel, 1, 5000)), fl = db2q16(floor_db), lv = db2q16(lvl), mx = gate ? 32767 : pct2q15(mix);
  const y = new Int32Array(x.length);
  let env = 0, g = 65536;
  for (let i = 0; i < x.length; i++) {
    const a = Math.abs(x[i]);
    env += mulq15(a - env, a > env ? a1 : r1);
    if (((i + 1) & 31) === 0) {
      const e = env / 8388608, edb = e > 1e-6 ? 20 * Math.log10(e) : -120;
      if (gate) g = edb < thr ? fl : 65536;
      else g = db2q16(edb > thr ? (thr - edb) * (1 - 1 / clamp(ratio, 1, 50)) : 0);
    }
    let o = mulq16(mulq16(x[i], g), lv);
    if (mx < 32767) o = mulq15(o, mx) + mulq15(x[i], 32767 - mx);
    y[i] = o;
  }
  return y;
}
function compare(got, ref) {
  let e = 0, d = 0, pk = 0, maxd = 0;
  for (let i = 0; i < got.length; i++) { e += ref[i] * ref[i]; d += (got[i] - ref[i]) ** 2; pk = Math.max(pk, Math.abs(ref[i])); maxd = Math.max(maxd, Math.abs(got[i] - ref[i])); }
  return { snr: d ? 10 * Math.log10(e / d) : Infinity, maxRel: maxd / pk };
}

let pedal;
test.before(() => { pedal = new Pedal(); });
test.after(() => pedal.close());

test('gate : seuil linéaire = même décision que l\'ancien calcul en dB (sortie identique)', async () => {
  for (const [thr, rel, depth] of [[-60, 80, -80], [-40, 20, -96], [-90, 500, -30], [-20, 5, 0]]) {
    const { x, y } = await pedal.block(def('M_GATE'), [[def('P_GATE_THR'), thr], [def('P_GATE_REL'), rel], [def('P_GATE_DEPTH'), depth]], N);
    const r = compare(y, refDyn(x, { gate: true, thr, ratio: 0, att: 1, rel, floor_db: depth }));
    assert.ok(r.snr > 90, `gate ${thr} dB : écart ${r.snr.toFixed(1)} dB sous le signal`);
  }
});

test('compresseurs : gain en log2/exp2 entiers, à moins de -70 dB de l\'ancien calcul flottant', async () => {
  const comp = [[-20, 4, 10, 120, 100, 0], [-40, 20, 0.1, 50, 100, 6], [-10, 1.5, 30, 300, 50, -3], [-60, 8, 1, 1000, 100, 12]];
  for (const [thr, ratio, att, rel, mix, lvl] of comp) {
    const { x, y } = await pedal.block(def('M_COMP'), [[def('P_COMP_THR'), thr], [def('P_COMP_RATIO'), ratio], [def('P_COMP_ATT'), att], [def('P_COMP_REL'), rel], [def('P_COMP_MIX'), mix], [def('P_COMP_LVL'), lvl]], N);
    const r = compare(y, refDyn(x, { thr, ratio, att, rel, mix, lvl }));
    assert.ok(r.snr > 70 && r.maxRel < 3e-4, `comp ${thr} dB ${ratio}:1 : écart ${r.snr.toFixed(1)} dB, max ${(r.maxRel * 100).toFixed(4)} %`);
  }
  for (const [sus, att, mix, lvl] of [[6, 4, 70, 5], [0, 0, 100, 0], [10, 10, 30, 10]]) {
    const { x, y } = await pedal.block(def('M_SQUASH'), [[def('P_SQUASH_SUS'), sus], [def('P_SQUASH_ATT'), att], [def('P_SQUASH_MIX'), mix], [def('P_SQUASH_LVL'), lvl]], N);
    const r = compare(y, refDyn(x, { thr: f32(-10 - 4 * sus), ratio: 2 + sus, att: f32(1 + 3 * att), rel: 150, mix, lvl: f32(f32(-12 + f32(2.4 * lvl)) + f32(0.6 * sus)) }));
    assert.ok(r.snr > 70 && r.maxRel < 3e-4, `squash sustain ${sus} : écart ${r.snr.toFixed(1)} dB, max ${(r.maxRel * 100).toFixed(4)} %`);
  }
});

/* arrivée de l'humide : pré-délai + plus court peigne (len = 1215 x taille du modèle) */
async function wetOnset(model, params) {
  const { x, y } = await pedal.block(def(model), params, 12000);
  for (let i = 0; i < y.length; i++) if (y[i] !== Math.floor(x[i] * 32767 / 32768)) return i;   /* sec = mulq15(x, 32767) */
  return -1;
}
test('réverbes par blocs : arrivée de l\'humide inchangée (pré-délai compensé), sortie stable', async () => {
  assert.equal(await wetOnset('M_ROOM', [[def('P_ROOM_PRE'), 20]]), 960 + Math.trunc(f32(1215 * f32(0.55))));
  assert.equal(await wetOnset('M_HALL', [[def('P_HALL_PRE'), 100]]), 4800 + 1215);
  assert.equal(await wetOnset('M_SPRING', []), 384 + Math.trunc(f32(1215 * f32(0.4))));
  /* pré-délai < 2,7 ms : l'humide arrive 128 échantillons après l'entrée au plus tôt (seul cas où le son change) */
  assert.equal(await wetOnset('M_ROOM', [[def('P_ROOM_PRE'), 0]]), 128 + Math.trunc(f32(1215 * f32(0.55))));
  for (const m of ['M_ROOM', 'M_HALL', 'M_PLATE', 'M_SPRING', 'M_SHIMMER']) {
    const { y } = await pedal.block(def(m), [], N);
    let pk = 0; for (const v of y) pk = Math.max(pk, Math.abs(v));
    assert.ok(pk > 1e5 && pk < 4 * 8388608, `${m} : crête ${pk}`);
  }
});

/* --- amplis : seuil de saturation réaliste (fw6 0.18) : avant, Rectifier / 5150 saturaient dès -100 dBFS (sur le souffle du
   convertisseur, -79 dBFS) et le JCM800 dès -68 : son brouillon et baveux signalé par l'utilisateur --- */
test('amplis : début de saturation (3 % à 220 Hz, réglages par défaut) au niveau visé, volume de sortie conservé', async () => {
  const { thresholds } = require('./emu/breakup');
  const A = require('./lib/appcode').load();
  const want = { usclean: -20, chime: -36, plexi: -40, brit: -46, rect: -56, lead51: -58 };
  const p = new Pedal();
  try {
    await p.info();
    const base = A.compactPreset(A.factoryPresets()[0], 0);
    for (const [id, w] of Object.entries(want)) {
      const s = await thresholds(p, base, id, A.MODEL[id].params.map(q => +(q.def ?? 0)));
      assert.ok(s[0] != null && Math.abs(s[0] - w) <= 4, `${id} : saturation dès ${s[0]} dBFS (visé ${w})`);
    }
  } finally { await p.close(); }
});
