/* amp_level.js : niveau de sortie RMS (dBFS) de chaque ampli seul, réglages par défaut, pour une note de guitare
 * synthétique (220 Hz + harmoniques) à -20 dBFS crête. Sert à garder le volume des presets après un recalibrage.
 * Usage : node tests/e2e/emu/amp_level.js [modèles...] */
'use strict';
const { Pedal, CMD } = require('../lib/pedal');
const A = require('../lib/appcode').load();
const SR = 48000, N = 48000;
const models = process.argv.slice(2).length ? process.argv.slice(2) : ['usclean', 'chime', 'plexi', 'brit', 'rect', 'lead51'];
(async () => {
  const p = new Pedal();
  try {
    await p.info();
    const base = A.compactPreset(A.factoryPresets()[0], 0), a = Math.pow(10, -20 / 20) * 8388607 / 1.6, x = new Int32Array(N);
    for (let i = 0; i < N; i++) { const ph = 2 * Math.PI * 220 * i / SR; x[i] = Math.round(a * (Math.sin(ph) + 0.4 * Math.sin(2 * ph) + 0.2 * Math.sin(3 * ph)) * Math.exp(-i / 24000)); }
    const out = {};
    for (const id of models) {
      const pd = A.MODEL[id].params.map(q => +(q.def ?? 0));
      const c = JSON.parse(JSON.stringify(base));
      c.lanes = [[id, null, null, null, null, null, null, null], Array(8).fill(null)];
      c.scenes = c.scenes.map(s => ({ n: s.n, b: [[0, 0, 1, ...pd]] }));
      if (!await p.cmd(CMD.PRESET_SET, c)) throw new Error('refusé ' + id);
      const y = await p.play(x);
      let s = 0; for (let i = 0; i < N; i++) s += (y[i] / 8388607) ** 2;
      out[id] = +(10 * Math.log10(s / N)).toFixed(1);
    }
    console.log(JSON.stringify(out));
  } finally { await p.close(); }
})().catch(e => { console.error(e); process.exit(1); });
