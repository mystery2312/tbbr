/* preset_check.js : analyse des presets d'usine (chaîne qui fait le son : boost / drives / ampli / baffle, effets
 * temporels retirés) dans l'émulateur. Pour les scènes Rhythm (0) et Lead (1) :
 *   - sat10 : niveau d'entrée (dBFS, note à 220 Hz) où la distorsion atteint 10 % (plus bas = plus de gain) ;
 *   - équilibre d'un power chord de mi (E2 + B2 + E3, attaque puis décroissance) à -20 dBFS crête :
 *     énergie < 150 Hz, 150-500, 500-2k, 2k-5k, > 5k Hz, en dB relatifs à la bande 500-2k ; sortie RMS (dBFS).
 * Usage : node tests/e2e/emu/preset_check.js [numéros de presets 1..20] */
'use strict';
const { Pedal, CMD } = require('../lib/pedal');
const A = require('../lib/appcode').load();
const SR = 48000;
const KEEP = new Set(['drive', 'amp', 'cab']);

function chain(p, sc) {
  const s = p.scenes[sc], lanes = [], rows = [];
  let col = 0;
  for (const b of p.lanes[0]) {
    if (!b) continue;
    const m = A.MODEL[b.model];
    if (!(KEEP.has(m.cat) || b.model === 'boost' || b.model === 'octave' || m.id === 'gate')) continue;
    const st = s.state[b.uid];
    lanes.push(b.model);
    rows.push([0, col, st.on ? 1 : 0, ...m.params.map(q => typeof st.p[q.id] === 'boolean' ? +st.p[q.id] : +st.p[q.id])]);
    col++;
  }
  return { lanes, rows };
}
async function load(pd, base, ch) {
  const c = JSON.parse(JSON.stringify(base));
  c.lanes = [ch.lanes.concat(Array(8 - ch.lanes.length).fill(null)), Array(8).fill(null)];
  c.par = [];
  c.scenes = c.scenes.map(s => ({ n: s.n, b: ch.rows }));
  if (!await pd.cmd(CMD.PRESET_SET, c)) throw new Error('refusé : ' + ch.lanes);
}
function thd(y, N, F) {
  let dc = 0; for (let i = N / 2; i < N; i++) dc += y[i] / (N / 2);
  let re = 0, im = 0, t = 0;
  for (let i = N / 2; i < N; i++) { const v = y[i] - dc; re += v * Math.cos(2 * Math.PI * F * i / SR); im += v * Math.sin(2 * Math.PI * F * i / SR); t += v * v; }
  const n = N / 2, f2 = (2 * Math.hypot(re, im) / n) ** 2 / 2, r2 = t / n;
  return r2 > 0 ? Math.sqrt(Math.max(0, r2 - f2) / r2) : 0;
}
async function sat10(pd) {
  const N = 9600;
  for (let db = -90; db <= 0; db += 2) {
    const a = Math.pow(10, db / 20) * 8388607, x = new Int32Array(N);
    for (let i = 0; i < N; i++) x[i] = Math.round(a * Math.sin(2 * Math.PI * 220 * i / SR) * Math.min(1, i / 480));
    if (thd(Array.from(await pd.play(x), v => v / 8388607), N, 220) > 0.10) return db;
  }
  return null;
}
/* bandes par DFT (fenêtre de Hann) sur 16 384 points */
function bands(y) {
  const N = 16384, off = 4800, E = [0, 0, 0, 0, 0], ed = [0, 150, 500, 2000, 5000, 24000];
  const re = new Float64Array(N), im = new Float64Array(N);
  for (let i = 0; i < N; i++) re[i] = (y[off + i] / 8388607) * (0.5 - 0.5 * Math.cos(2 * Math.PI * i / N));
  /* FFT radix-2 */
  for (let i = 1, j = 0; i < N; i++) { let bit = N >> 1; for (; j & bit; bit >>= 1) j ^= bit; j ^= bit; if (i < j) { [re[i], re[j]] = [re[j], re[i]]; [im[i], im[j]] = [im[j], im[i]]; } }
  for (let len = 2; len <= N; len <<= 1) {
    const ang = -2 * Math.PI / len, wr = Math.cos(ang), wi = Math.sin(ang);
    for (let i = 0; i < N; i += len) { let cr = 1, ci = 0;
      for (let k = 0; k < len / 2; k++) { const ar = re[i + k + len / 2] * cr - im[i + k + len / 2] * ci, ai = re[i + k + len / 2] * ci + im[i + k + len / 2] * cr;
        re[i + k + len / 2] = re[i + k] - ar; im[i + k + len / 2] = im[i + k] - ai; re[i + k] += ar; im[i + k] += ai;
        const t = cr * wr - ci * wi; ci = cr * wi + ci * wr; cr = t; } }
  }
  for (let k = 1; k < N / 2; k++) { const f = k * SR / N, e = re[k] ** 2 + im[k] ** 2; for (let b = 0; b < 5; b++) if (f >= ed[b] && f < ed[b + 1]) E[b] += e; }
  return E.map(e => 10 * Math.log10(e / E[2] + 1e-12));
}
/* power chord de mi pincé : 3 cordes en Karplus-Strong (excitation au médiator : bruit filtré, spectre riche comme une
   vraie corde, décroissance plus rapide des aigus), normalisé à dbfs crête */
function chord(dbfs) {
  const N = 4800 + 16384, v = new Float64Array(N);
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
(async () => {
  const F = A.factoryPresets(), want = process.argv.slice(2).map(Number);
  const pd = new Pedal();
  try {
    await pd.info();
    const base = A.compactPreset(F[0], 0), X = chord(-20);
    console.log('guitare seule (entrée)                        ', bands(X).map(v => v.toFixed(1).padStart(7)).join(''));
    console.log('preset                         scène   sat10   <150  150-500 [500-2k] 2k-5k  >5k   sortie   chaîne');
    for (let i = 0; i < 20; i++) {
      if (want.length && !want.includes(i + 1)) continue;
      for (const sc of [0, 1]) {
        const ch = chain(F[i], sc);
        await load(pd, base, ch);
        const s = await sat10(pd);
        const y = await pd.play(X);
        let r = 0; for (let k = 4800; k < y.length; k++) r += (y[k] / 8388607) ** 2;
        const bd = bands(y);
        const on = ch.rows.map((row, k) => (row[2] ? '' : '(') + ch.lanes[k] + (row[2] ? '' : ')')).join('>');
        console.log(((i + 1) + ' ' + F[i].name).slice(0, 30).padEnd(31), F[i].scenes[sc].name.slice(0, 6).padEnd(7),
          String(s).padStart(5), bd.map(v => v.toFixed(1).padStart(7)).join(''), (10 * Math.log10(r / (y.length - 4800))).toFixed(1).padStart(8), '  ', on);
      }
    }
  } finally { await pd.close(); }
})().catch(e => { console.error(e); process.exit(1); });
