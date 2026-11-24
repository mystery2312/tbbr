/* appcode.js : charge le code réel de l'app (data.js + fonctions d'app.js) dans Node, sans navigateur. */
'use strict';
const fs = require('node:fs');
const path = require('node:path');
const vm = require('node:vm');

const APP = path.join(__dirname, '..', '..', '..', 'interface', 'app');
const read = f => fs.readFileSync(path.join(APP, f), 'utf8');

function load() {
  const app = read('js/app.js');
  const grab = name => {
    const i = app.indexOf('function ' + name + '(');
    if (i < 0) throw new Error('fonction ' + name + ' introuvable dans app.js');
    let d = 0, j = app.indexOf('{', i);
    for (; j < app.length; j++) { if (app[j] === '{') d++; else if (app[j] === '}' && --d === 0) break; }
    return app.slice(i, j + 1);
  };
  const line = re => { const m = app.match(re); if (!m) throw new Error('ligne introuvable : ' + re); return m[0]; };
  const ctx = { Date, Math, JSON, console, Object, Array, String, Number, Set, Map };
  vm.createContext(ctx);
  vm.runInContext(read('js/data.js') + '\n' +
    line(/const clamp = .*/) + '\n' + grab('blocks') + '\n' + grab('islands') + '\n' +
    grab('expandPreset') + '\n' + grab('compactPreset').replace('const p = S.presets[i];', 'const p = P0;') +
    '\nvar P0; this.__o = { MODELS, MODEL, COLS, SCENES, PRESETS, IR_SLOTS, NAM_SLOTS, factoryPresets, expandPreset,' +
    ' compactPreset: (p, i = 0) => { P0 = p; return compactPreset(i); } };', ctx);
  /* objets du contexte vm -> objets ordinaires (sinon deepStrictEqual compare des prototypes différents) */
  const plain = f => (...a) => JSON.parse(JSON.stringify(f(...a)));
  const o = ctx.__o;
  return { ...o, MODELS: plain(() => o.MODELS)(), MODEL: plain(() => o.MODEL)(), factoryPresets: plain(o.factoryPresets),
    expandPreset: plain(o.expandPreset), compactPreset: plain(o.compactPreset) };
}
module.exports = { load, APP };
