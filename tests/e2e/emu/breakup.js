/* breakup.js : niveau d'entrée (dBFS) où chaque ampli / drive commence à saturer (distorsion > 3 %, 10 %, 30 %) à 220 Hz,
 * réglages par défaut ou gain choisi. Usage : node tests/e2e/emu/breakup.js [gain 0..10] [modèles...]
 * En dessous de -100 dBFS le sinus de test n'a plus que quelques pas de quantification : mesure non significative. */
'use strict';
const { Pedal, CMD } = require('../lib/pedal');
const A = require('../lib/appcode').load();
const SR = 48000, N = 9600, F = 220, FLOOR = -100;
const gainArg = process.argv[2] && !isNaN(+process.argv[2]) ? +process.argv[2] : null;
const ids = process.argv.slice(gainArg == null ? 2 : 3);
const models = ids.length ? ids : ['usclean', 'chime', 'plexi', 'brit', 'rect', 'lead51', 'bassamp'];

function thd(y) {
  let re = 0, im = 0, tot = 0, dc = 0;
  for (let i = N / 2; i < N; i++) dc += y[i] / (N / 2);                  /* décalage continu : pas de la distorsion */
  for (let i = N / 2; i < N; i++) { const v = y[i] - dc; re += v * Math.cos(2 * Math.PI * F * i / SR); im += v * Math.sin(2 * Math.PI * F * i / SR); tot += v * v; }
  const n = N / 2, f2 = (2 * Math.hypot(re, im) / n) ** 2 / 2, r2 = tot / n;
  return r2 > 0 ? Math.sqrt(Math.max(0, r2 - f2) / r2) : 0;
}
async function thresholds(p, base, id, pd) {
  const c = JSON.parse(JSON.stringify(base));
  c.lanes = [[id, null, null, null, null, null, null, null], Array(8).fill(null)];
  c.scenes = c.scenes.map(s => ({ n: s.n, b: [[0, 0, 1, ...pd]] }));
  if (!await p.cmd(CMD.PRESET_SET, c)) throw new Error('refusé ' + id);
  const seuil = [null, null, null];
  for (let db = FLOOR; db <= 0; db += 2) {
    const a = Math.pow(10, db / 20) * 8388607, x = new Int32Array(N);
    for (let i = 0; i < N; i++) x[i] = Math.round(a * Math.sin(2 * Math.PI * F * i / SR) * Math.min(1, i / 480));
    const t = thd(Array.from(await p.play(x), v => v / 8388607));
    [0.03, 0.10, 0.30].forEach((lim, k) => { if (seuil[k] == null && t > lim) seuil[k] = db; });
    if (seuil[2] != null) break;
  }
  return seuil;
}
module.exports = { thresholds };

if (require.main === module) (async () => {
  const p = new Pedal();
  try {
    await p.info();
    const base = A.compactPreset(A.factoryPresets()[0], 0);
    console.log('seuils de saturation à 220 Hz (dBFS d\'entrée)' + (gainArg != null ? ', gain ' + gainArg : ', réglages par défaut') + ' ; « ≤-100 » = dès le plancher de mesure');
    console.log('modèle      3 %    10 %    30 %');
    for (const id of models) {
      const pd = A.MODEL[id].params.map(q => +(q.def ?? 0));
      if (gainArg != null) pd[0] = gainArg;
      const s = await thresholds(p, base, id, pd);
      console.log(id.padEnd(9), s.map(v => (v == null ? '  > 0' : v <= FLOOR ? ' ≤-100' : String(v))).map(v => v.padStart(7)).join(' '));
    }
  } finally { await p.close(); }
})().catch(e => { console.error(e); process.exit(1); });
