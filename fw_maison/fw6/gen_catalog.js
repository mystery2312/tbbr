// gen_catalog.js : génère catalog.h (firmware) à partir de interface/app/js/data.js (catalogue de l'app).
// Un seul catalogue : l'ordre des paramètres envoyé par l'app (PRESET_SET, PARAM) = l'ordre de MODELS[i].params.
// Usage : node gen_catalog.js
const fs = require('fs'), path = require('path'), vm = require('vm');
const dataPath = path.join(__dirname, '..', '..', 'interface', 'app', 'js', 'data.js');
const ctx = {}; vm.createContext(ctx);
vm.runInContext(fs.readFileSync(dataPath, 'utf8') + '\n;this.__out = { MODELS, CATS, COLS, SCENES, PRESETS, IR_SLOTS, NAM_SLOTS };', ctx);
const { MODELS, CATS, COLS, SCENES, PRESETS, IR_SLOTS, NAM_SLOTS } = ctx.__out;
const cid = s => s.replace(/[^A-Za-z0-9]/g, '_').toUpperCase();
const catIds = Object.keys(CATS);
let maxP = 0;
const L = [];
L.push('/* généré par gen_catalog.js depuis interface/app/js/data.js : NE PAS MODIFIER À LA MAIN */');
L.push('#pragma once');
L.push(`#define CAT_COLS ${COLS}`, `#define CAT_SCENES ${SCENES}`, `#define CAT_PRESETS ${PRESETS}`, `#define CAT_IR_SLOTS ${IR_SLOTS}`, `#define CAT_NAM_SLOTS ${NAM_SLOTS}`);
catIds.forEach((c, i) => L.push(`#define CAT_${cid(c)} ${i}`));
MODELS.forEach((m, i) => { L.push(`#define M_${cid(m.id)} ${i}`); maxP = Math.max(maxP, m.params.length); });
L.push(`#define M_COUNT ${MODELS.length}`, `#define MAX_PARAMS ${maxP}`);
MODELS.forEach(m => m.params.forEach((p, j) => L.push(`#define P_${cid(m.id)}_${cid(p.id)} ${j}`)));
L.push('struct model_def { const char *id; unsigned char cat; unsigned char nparams; unsigned char dsp; float def[MAX_PARAMS]; };');
L.push('static const struct model_def MODEL_DEFS[M_COUNT] = {');
MODELS.forEach(m => {
  const defs = m.params.map(p => p.type === 'bool' ? (p.def ? 1 : 0) : (typeof p.def === 'number' ? p.def : 0));
  while (defs.length < maxP) defs.push(0);
  L.push(`  { "${m.id}", CAT_${cid(m.cat)}, ${m.params.length}, ${m.dsp}, { ${defs.map(v => (Number.isInteger(v) ? v + '.0f' : v + 'f')).join(', ')} } },`);
});
L.push('};');
/* métadonnées pour l'écran (page de bloc, ecran.js) : noms, unités, bornes, pas, type, options */
const cstr = s => '"' + String(s).replace(/\\/g, '\\\\').replace(/"/g, '\\"') + '"';
const ptype = p => p.type === 'select' ? 1 : p.type === 'bool' ? 2 : p.type === 'ir' ? 3 : p.type === 'nam' ? 4 : 0;
L.push('struct param_def { const char *name, *unit; float min, max, step; unsigned char type, nopt; const char *const *opt; };');
const optArrays = [];
MODELS.forEach(m => m.params.forEach(p => { if (p.type === 'select') optArrays.push(`static const char *const OPT_${cid(m.id)}_${cid(p.id)}[] = { ${p.options.map(cstr).join(', ')} };`); }));
L.push(...optArrays);
L.push('static const struct param_def PARAM_DEFS[M_COUNT][MAX_PARAMS] = {');
MODELS.forEach(m => {
  const fl = v => (Number.isInteger(v) ? v + '.0' : String(v)) + 'f';
  const row = m.params.map(p => `{ ${cstr(p.name)}, ${cstr(p.unit || '')}, ${fl(p.min ?? 0)}, ${fl(p.max ?? (p.type === 'select' ? p.options.length - 1 : 1))}, ${fl(p.step ?? 1)}, ${ptype(p)}, ${p.type === 'select' ? p.options.length : 0}, ${p.type === 'select' ? `OPT_${cid(m.id)}_${cid(p.id)}` : '0'} }`);
  L.push(`  { ${row.join(', ') || '{0}'} },`);
});
L.push('};');
L.push('static const char *const MODEL_NAMES[M_COUNT] = { ' + MODELS.map(m => cstr(m.name)).join(', ') + ' };');
const hex565 = h => { const v = parseInt(h.slice(1), 16), r = v >> 16, g = (v >> 8) & 255, b = v & 255; return '0x' + (((r >> 3) << 11) | ((g >> 2) << 5) | (b >> 3)).toString(16); };
const hex888 = h => '0x' + h.slice(1);
L.push('static const unsigned int CAT_RGB[' + catIds.length + '] = { ' + catIds.map(c => hex888(CATS[c].color)).join(', ') + ' };');
L.push('static const char *const CAT_SHORT[' + catIds.length + '] = { ' + catIds.map(c => cstr(CATS[c].short)).join(', ') + ' };');
fs.writeFileSync(path.join(__dirname, 'catalog.h'), L.join('\n') + '\n');
console.log(`catalog.h : ${MODELS.length} modèles, ${catIds.length} catégories, ${maxP} paramètres max`);
