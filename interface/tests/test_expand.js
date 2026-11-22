// test_expand.js <preset.json> : expandPreset (app.js) puis compactPreset doit redonner le même preset (aller-retour pédale <-> app)
const fs = require('fs'), path = require('path'), vm = require('vm');
const ctx = { Date, Math, JSON, console, Object, Array, String, Number }; vm.createContext(ctx);
const app = fs.readFileSync(path.join(__dirname, '..', 'app', 'js', 'app.js'), 'utf8');
const grab = name => { const i = app.indexOf('function ' + name + '('); let d = 0, j = app.indexOf('{', i); for (; j < app.length; j++) { if (app[j] === '{') d++; else if (app[j] === '}' && --d === 0) break; } return app.slice(i, j + 1); };
const line = re => app.match(re)[0];
vm.runInContext(fs.readFileSync(path.join(__dirname, '..', 'app', 'js', 'data.js'), 'utf8') + '\n' +
  line(/const clamp = .*/) + '\n' + grab('blocks') + '\n' + grab('islands') + '\n' +
  grab('expandPreset') + '\n' + grab('compactPreset').replace('const p = S.presets[i];', 'const p = P0;') +
  '\nthis.__o = { expandPreset, compactPreset: (p) => { P0 = p; return compactPreset(0); } }; var P0;', ctx);
const src = JSON.parse(fs.readFileSync(process.argv[2], 'utf8').replace(/^\uFEFF/, ''));
const p = ctx.__o.expandPreset(src), back = ctx.__o.compactPreset(p);
const norm = o => JSON.stringify({ name: o.name, color: o.color, tempo: o.tempo, level: o.level, scene: o.scene, par: o.par, lanes: o.lanes, fs: o.fs, scenes: o.scenes });
back.par = back.par.map(x => ({ from: x.from, to: x.to, mix: x.mix }));
console.log(norm(src) === norm(back) ? 'ALLER-RETOUR IDENTIQUE' : 'DIFFÉRENT\n' + norm(src) + '\n' + norm(back));
