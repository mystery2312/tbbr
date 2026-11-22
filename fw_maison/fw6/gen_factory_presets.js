// gen_factory_presets.js : génère factory_presets.h (banque stock du firmware)
// à partir de factoryPresets() de l'app (source unique). Sortie : JSON compact,
// exactement le format relu par apply_preset_json() dans proto.c.
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const here = __dirname;
const dataPath = path.join(here, '..', '..', 'interface', 'app', 'js', 'data.js');
const ctx = { Date, Math, JSON };
vm.createContext(ctx);
vm.runInContext(fs.readFileSync(dataPath, 'utf8') + '\n;this.__o={factoryPresets,MODEL,COLS,PRESETS};', ctx);
const { factoryPresets, MODEL, COLS } = ctx.__o;
const STOCK = 20;

function islands(p) {
  const out = [];
  let s = -1;
  for (let c = 0; c <= COLS; c++) {
    const has = c < COLS && !!p.lanes[1][c];
    if (has && s < 0) s = c;
    if (!has && s >= 0) {
      out.push({ from: s, to: c, mix: p.par && p.par[s] != null ? p.par[s] : 50 });
      s = -1;
    }
  }
  return out;
}

function compact(p, index) {
  const blocks = [];
  for (let l = 0; l < 2; l++) for (let c = 0; c < COLS; c++) if (p.lanes[l][c]) blocks.push({ b: p.lanes[l][c], lane: l, col: c });
  const fs = (p.fs || []).slice(0, 2).map(f => [f.press, f.hold].map(a => {
    if (!a || !a.startsWith('block:')) return a || 'none';
    const x = blocks.find(o => o.b.uid === a.slice(6));
    return x ? 'block:' + x.lane + ',' + x.col : 'none';
  }));
  return JSON.stringify({
    i: index, name: p.name, color: p.color, tempo: p.tempo, level: p.level, scene: p.scene,
    par: islands(p),
    lanes: p.lanes.map(l => l.map(b => b && b.model)),
    fs,
    scenes: p.scenes.map(sc => ({
      n: sc.name,
      b: blocks.map(({ b, lane, col }) => [lane, col, +sc.state[b.uid].on, ...MODEL[b.model].params.map(pd => +sc.state[b.uid].p[pd.id])]),
    })),
  });
}

const ps = factoryPresets();
const rows = [];
for (let i = 0; i < STOCK; i++) {
  const p = ps[i];
  if (!p || p.name === 'Init') throw new Error('preset stock manquant à ' + i);
  rows.push(compact(p, i));
}

function cstr(s) {
  return JSON.stringify(s).replace(/\u2019/g, "'");
}

let out = '/* généré par gen_factory_presets.js — ne pas éditer à la main */\n';
out += '#ifndef FACTORY_PRESETS_H\n#define FACTORY_PRESETS_H\n\n';
out += '#define FACTORY_PRESET_COUNT ' + rows.length + '\n\n';
out += 'static const char *const factory_preset_json[FACTORY_PRESET_COUNT] = {\n';
for (const r of rows) out += '  ' + cstr(r) + ',\n';
out += '};\n\nstatic const unsigned short factory_preset_len[FACTORY_PRESET_COUNT] = {\n';
for (const r of rows) out += '  ' + r.length + ',\n';
out += '};\n\n#endif\n';
fs.writeFileSync(path.join(here, 'factory_presets.h'), out, 'utf8');
console.log('factory_presets.h : ' + rows.length + ' presets, ' + rows.reduce((n, r) => n + r.length, 0) + ' octets de JSON');
for (let i = 0; i < rows.length; i++) console.log(String(i + 1).padStart(2, '0') + ' ' + ps[i].name + ' (' + rows[i].length + ' o)');
