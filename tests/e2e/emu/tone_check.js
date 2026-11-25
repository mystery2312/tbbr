/* tone_check.js : réponse en fréquence (sinus) des blocs et des presets d'usine dans l'émulateur (vrai engine.c).
 * Usage : node tests/e2e/emu/tone_check.js [blocs|presets] [niveau dBFS, défaut -30]
 * Affiche le niveau de sortie (dB, relatif à 1 kHz) pour chaque fréquence, et la part d'harmoniques (saturation). */
'use strict';
const { Pedal, CMD } = require('../lib/pedal');
const A = require('../lib/appcode').load();

const FR = [60, 82, 110, 165, 220, 330, 500, 1000, 2000, 3000, 4500, 6500, 9000];
const mode = process.argv[2] || 'blocs', lvl = +(process.argv[3] || -30);
const SR = 48000, N = 9600;                                          /* 0,2 s par fréquence */

function tone(f, db) {
  const a = Math.pow(10, db / 20) * 8388607, x = new Int32Array(N);
  for (let i = 0; i < N; i++) x[i] = Math.round(a * Math.sin(2 * Math.PI * f * i / SR) * Math.min(1, i / 480));
  return x;
}
/* amplitude de la fondamentale (DFT à f) et énergie totale, sur la 2e moitié (régime établi) */
function analyse(y, f) {
  let re = 0, im = 0, tot = 0;
  for (let i = N / 2; i < N; i++) { const v = y[i] / 8388607; re += v * Math.cos(2 * Math.PI * f * i / SR); im += v * Math.sin(2 * Math.PI * f * i / SR); tot += v * v; }
  const n = N / 2, fund = 2 * Math.hypot(re, im) / n, rms = Math.sqrt(tot / n);
  return { fund, rms };
}
const db = v => (20 * Math.log10(Math.max(v, 1e-9))).toFixed(1).padStart(6);

async function measure(p) {
  const out = [];
  for (const f of FR) { const y = await p.play(tone(f, lvl)); out.push(analyse(y, f)); }
  return out;
}
function show(name, r) {
  const ref = r[FR.indexOf(1000)].fund;
  const thd = k => (100 * Math.sqrt(Math.max(0, r[k].rms ** 2 - (r[k].fund / Math.SQRT2) ** 2)) / r[k].rms).toFixed(0).padStart(3) + '%';
  console.log(name.padEnd(28), r.map(x => db(x.fund / ref)).join(''), ' | 1k :', db(ref), 'dB  dist. 82 Hz', thd(1), ' 220 Hz', thd(4), ' 1 kHz', thd(7));
}

(async () => {
  const p = new Pedal();
  try {
    await p.info();
    console.log('niveau', lvl, 'dBFS ;', 'Hz :'.padEnd(21), FR.map(f => String(f).padStart(6)).join(''));
    const base = A.compactPreset(A.factoryPresets()[0], 0);
    const one = async (lanes, params) => {
      const c = JSON.parse(JSON.stringify(base));
      c.lanes = [lanes.concat(Array(8 - lanes.length).fill(null)), Array(8).fill(null)];
      c.scenes = c.scenes.map(s => ({ n: s.n, b: lanes.map((m, col) => [0, col, 1, ...(params[col] || [])]) }));
      if (!await p.cmd(CMD.PRESET_SET, c)) throw new Error('preset refusé : ' + lanes);
      return measure(p);
    };
    if (mode === 'blocs') {
      const ids = process.argv.slice(4).length ? process.argv.slice(4) : ['cab412', 'cab212', 'brit', 'plexi', 'rect', 'usclean', 'chime', 'green', 'muff', 'fuzz', 'boost'];
      for (const id of ids) {
        const pd = A.MODEL[id].params.map(q => +(q.def ?? 0));
        show(id + ' (défaut)', await one([id], [pd]));
      }
    } else {
      const F = A.factoryPresets();
      for (let i = 0; i < Math.min(F.length, +(process.argv[4] || 12)); i++) {
        const c = A.compactPreset(F[i], i);
        if (!await p.cmd(CMD.PRESET_SET, c)) { console.log(F[i].name, 'refusé'); continue; }
        show((i + 1) + ' ' + F[i].name.slice(0, 24), await measure(p));
      }
    }
  } finally { await p.close(); }
})().catch(e => { console.error(e); process.exit(1); });
