// make_compact.js <index> : sort le preset d'usine <index> au format compact envoyé par l'app (PRESET_SET), comme compactPreset() d'app.js.
const fs = require('fs'), path = require('path'), vm = require('vm');
const ctx = { Date, Math, JSON }; vm.createContext(ctx);
vm.runInContext(fs.readFileSync(path.join(__dirname, '..', 'app', 'js', 'data.js'), 'utf8') + '\n;this.__o={factoryPresets,MODEL,COLS};', ctx);
const { factoryPresets, MODEL, COLS } = ctx.__o;
const p = factoryPresets()[+(process.argv[2] || 0)];
/* option : remplacer un modèle par un autre (réglages par défaut), ex. « brit=nam » */
if (process.argv[3] && process.argv[3].includes('=')) {
  const [from, to] = process.argv[3].split('=');
  for (const lane of p.lanes) for (const b of lane) if (b && b.model === from) {
    b.model = to;
    for (const sc of p.scenes) { const st = sc.state[b.uid]; if (st) st.p = Object.fromEntries(MODEL[to].params.map(pd => [pd.id, pd.def])); }
  }
}
const blocks = [];
for (let l = 0; l < 2; l++) for (let c = 0; c < COLS; c++) if (p.lanes[l][c]) blocks.push({ b: p.lanes[l][c], lane: l, col: c });
const islands = [];
let s = -1;
for (let c = 0; c <= COLS; c++) { const has = c < COLS && !!p.lanes[1][c]; if (has && s < 0) s = c; if (!has && s >= 0) { islands.push({ from: s, to: c, mix: p.par && p.par[s] != null ? p.par[s] : 50 }); s = -1; } }
const out = {
  i: +(process.argv[2] || 0), name: p.name, color: p.color, tempo: p.tempo, level: p.level, par: islands, scene: p.scene,
  lanes: p.lanes.map(l => l.map(b => b && b.model)),
  scenes: p.scenes.map(sc => ({ n: sc.name, b: blocks.map(({ b, lane, col }) => [lane, col, +sc.state[b.uid].on, ...MODEL[b.model].params.map(pd => +sc.state[b.uid].p[pd.id])]) })),
};
process.stdout.write(JSON.stringify(out));
