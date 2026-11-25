/* preset_tune.js : règle les presets d'usine dans l'émulateur et affiche les valeurs à reporter dans FP (data.js).
 *  1. gain de l'ampli : dichotomie pour que la chaîne qui fait le son (boost / drives / ampli / baffle, scène Rhythm)
 *     atteigne 10 % de distorsion au niveau d'entrée visé (TARGET, dBFS, note de 330 Hz) ;
 *  2. volume du preset (p.level, -20..+6 dB) : sortie RMS du preset complet (scène Rhythm) sur un power chord pincé
 *     à -20 dBFS crête = LEVEL dBFS.
 * Usage : node tests/e2e/emu/preset_tune.js */
'use strict';
const { Pedal, CMD } = require('../lib/pedal');
const A = require('../lib/appcode').load();
const SR = 48000;
/* cibles d'après les sons originaux : clair -14, bord de saturation -26, crunch -32..-36, gain élevé -40..-46, métal -56 */
const TARGET = [-40, null, null, -14, -32, -46, -58, -48, null, null, -48, -36, -14, null, -56, -36, -34, -36, -34, -44];   /* null : gain fixé à la main (Twin : le gain change peu la saturation) */
const STAIRWAY = { clean: -14, lead: -36 };
const LEVEL = -6;                                                       /* RMS visé (accord à -20 dBFS) */
const PEAKMAX = 11;                                                    /* crête max en jouant fort (-12 dBFS) ; le limiteur après MASTER (main.c) gère le reste ; test protocole : < +12 */
const FT = 330;                                                         /* note de test : milieu de la tessiture (un TS coupe sous 720 Hz) */
/* presets clairs dont la pédale fait la saturation du solo : volume de cette pédale réglé pour Lead = Rhythm + LEAD_UP dB */
const LEADKNOB = { 2: ['grit', 'vol', 0, 10], 3: ['muff', 'vol', 0, 10], 9: ['green', 'lvl', 0, 10], 13: ['green', 'lvl', 0, 10] };
const LEAD_UP = 2;
if (!process.argv.includes('--check')) A.FP.lead = {};
const AMPS = new Set(['brit', 'plexi', 'usclean', 'chime', 'rect', 'lead51', 'bassamp']);

function chainOf(p, sc, ampGain) {
  const s = p.scenes[sc], lanes = [], rows = [];
  for (const b of p.lanes[0]) {
    if (!b) continue;
    const m = A.MODEL[b.model];
    if (!(m.cat === 'drive' || m.cat === 'amp' || m.cat === 'cab' || b.model === 'boost')) continue;
    const st = s.state[b.uid], pr = { ...st.p };
    if (AMPS.has(b.model) && ampGain != null) pr.gain = ampGain;
    rows.push([0, lanes.length, st.on ? 1 : 0, ...m.params.map(q => +pr[q.id])]);
    lanes.push(b.model);
  }
  return { lanes, rows };
}
async function loadChain(pd, base, ch) {
  const c = JSON.parse(JSON.stringify(base));
  c.lanes = [ch.lanes.concat(Array(8 - ch.lanes.length).fill(null)), Array(8).fill(null)];
  c.par = []; c.level = 0;
  c.scenes = c.scenes.map(s => ({ n: s.n, b: ch.rows }));
  if (!await pd.cmd(CMD.PRESET_SET, c)) throw new Error('refusé : ' + ch.lanes);
}
function thd(y, N) {
  let dc = 0; for (let i = N / 2; i < N; i++) dc += y[i] / (N / 2);
  let re = 0, im = 0, t = 0;
  for (let i = N / 2; i < N; i++) { const v = y[i] - dc; re += v * Math.cos(2 * Math.PI * FT * i / SR); im += v * Math.sin(2 * Math.PI * FT * i / SR); t += v * v; }
  const n = N / 2, f2 = (2 * Math.hypot(re, im) / n) ** 2 / 2, r2 = t / n;
  return r2 > 0 ? Math.sqrt(Math.max(0, r2 - f2) / r2) : 0;
}
async function sat10(pd) {
  const N = 9600;
  for (let db = -90; db <= 0; db += 1) {
    const a = Math.pow(10, db / 20) * 8388607, x = new Int32Array(N);
    for (let i = 0; i < N; i++) x[i] = Math.round(a * Math.sin(2 * Math.PI * FT * i / SR) * Math.min(1, i / 480));
    if (thd(Array.from(await pd.play(x), v => v / 8388607), N) > 0.10) return db;
  }
  return 1;
}
function chord(dbfs) {
  const N = 48000 * 2, v = new Float64Array(N);
  let seed = 7; const rnd = () => ((seed = (seed * 1664525 + 1013904223) >>> 0) / 4294967296) * 2 - 1;
  for (const [f, d] of [[82.41, 0], [123.47, 60], [164.81, 120]]) {
    const L = Math.round(SR / f), buf = new Float64Array(L);
    let lp = 0; for (let k = 0; k < L; k++) { lp = 0.6 * lp + 0.4 * rnd(); buf[k] = lp; }
    let pos = 0;
    for (let i = d; i < N; i++) { const a = buf[pos], b = buf[(pos + 1) % L]; buf[pos] = 0.4985 * (a + b); v[i] += a; pos = (pos + 1) % L; }
  }
  let pk = 0; for (const s of v) pk = Math.max(pk, Math.abs(s));
  const x = new Int32Array(N), g = Math.pow(10, dbfs / 20) * 8388607 / pk;
  for (let i = 0; i < N; i++) x[i] = Math.round(v[i] * g);
  return x;
}
async function tuneGain(pd, base, i, sc, target) {
  let lo = 0, hi = 10, best = null;
  for (let k = 0; k < 7; k++) {                                         /* plus de gain = seuil plus bas */
    const g = +((lo + hi) / 2).toFixed(2);
    const ch = chainOf(A.factoryPresets()[i], sc, g);
    await loadChain(pd, base, ch);
    const s = await sat10(pd);
    best = { g, s };
    if (s > target) lo = g; else hi = g;
  }
  return { g: Math.round(best.g * 2) / 2, s: best.s };
}
(async () => {
  const pd = new Pedal();
  try {
    await pd.info();
    const base = A.compactPreset(A.factoryPresets()[0], 0);
    const CHECK = process.argv.includes('--check');                    /* --check : mesure les valeurs actuelles de data.js, sans régler */
    for (let i = 0; i < 20 && !CHECK; i++) {
      if (i === 1) {
        for (const [k, sc] of [['clean', 0], ['lead', 1]]) {
          A.FP['stairway' + (k === 'clean' ? 'Clean' : 'Lead')] = 5;
          const r = await tuneGain(pd, base, 1, sc, STAIRWAY[k]);
          A.FP['stairway' + (k === 'clean' ? 'Clean' : 'Lead')] = r.g;
        }
        continue;
      }
      if (TARGET[i] == null) continue;
      const r = await tuneGain(pd, base, i, 0, TARGET[i]);
      A.FP.gain[i] = r.g;
    }
    const X = chord(-20);
    const rms = async (i, sc) => {
      const c = A.compactPreset(A.factoryPresets()[i], i); c.level = 0;
      if (!await pd.cmd(CMD.PRESET_SET, c)) throw new Error('preset refusé ' + i);
      await pd.cmd(CMD.SCENE_SELECT, [sc]);
      const y = await pd.play(X);
      let r = 0; for (let k = 0; k < y.length; k++) r += (y[k] / 8388607) ** 2;
      return 10 * Math.log10(r / y.length);
    };
    /* volume de la pédale du solo : Lead = Rhythm + LEAD_UP */
    for (const [i, [mid, k, lo0, hi0]] of Object.entries(CHECK ? {} : LEADKNOB)) {
      let lo = lo0, hi = hi0, v = 0;
      const r0 = await rms(+i, 0);
      for (let n = 0; n < 8; n++) {
        v = +((lo + hi) / 2).toFixed(2);
        A.FP.lead[i] = [mid, k, v];
        if (await rms(+i, 1) - r0 > LEAD_UP) hi = v; else lo = v;
      }
      A.FP.lead[i] = [mid, k, Math.round(v * 2) / 2];
    }
    /* vérification + volumes */
    const XH = chord(-12), SH = new Int32Array(24000);
    for (let k = 0; k < SH.length; k++) SH[k] = Math.round(0.25 * 8388607 * Math.sin(2 * Math.PI * 220 * k / SR));
    console.log('preset                        Rhythm sat10 (visé)   Lead sat10  RMS(-20)  crête(-12)  level');
    const F = A.factoryPresets();
    for (let i = 0; i < 20; i++) {
      const s0 = (await loadChain(pd, base, chainOf(F[i], 0)), await sat10(pd));
      const s1 = (await loadChain(pd, base, chainOf(F[i], 1)), await sat10(pd));
      const c = A.compactPreset(F[i], i); c.level = 0;
      if (!await pd.cmd(CMD.PRESET_SET, c)) throw new Error('preset refusé ' + i);
      await pd.cmd(CMD.SCENE_SELECT, [0]);
      const y = await pd.play(X);
      let r = 0; for (let k = 0; k < y.length; k++) r += (y[k] / 8388607) ** 2;
      await pd.cmd(CMD.SCENE_SELECT, [1]);
      const y1 = await pd.play(X);
      let r1 = 0; for (let k = 0; k < y1.length; k++) r1 += (y1[k] / 8388607) ** 2;
      /* crête de sortie en jouant fort (accord et note à -12 dBFS), scènes Rhythm / Lead / Clean / Solo, volume du preset à 0 */
      let pk = 0;
      for (const sc of [0, 1, 2, 3]) {
        await pd.cmd(CMD.SCENE_SELECT, [sc]);
        for (const z of [XH, SH]) { const w = await pd.play(z); for (const v of w) pk = Math.max(pk, Math.abs(v) / 8388607); }
      }
      const pkdb = 20 * Math.log10(pk), out = 10 * Math.log10(r / y.length);
      const lv = Math.max(-20, Math.min(6, Math.floor(Math.min(LEVEL - out, PEAKMAX - pkdb) * 2) / 2));
      if (!CHECK) A.FP.level[i] = lv;
      const use = CHECK ? A.FP.level[i] : lv;
      console.log(((i + 1) + ' ' + F[i].name).slice(0, 29).padEnd(30), String(s0).padStart(6), ('(' + (i === 1 ? STAIRWAY.clean : TARGET[i]) + ')').padStart(7),
        String(s1).padStart(10), (out + use).toFixed(1).padStart(10), (pkdb + use).toFixed(1).padStart(7), String(use).padStart(7), '  Lead/Rhythm', (10 * Math.log10(r1 / y1.length) - out).toFixed(1).padStart(6), 'dB');
    }
    console.log('\nFP = ' + JSON.stringify(A.FP));
  } finally { await pd.close(); }
})().catch(e => { console.error(e); process.exit(1); });
