// Teste parseNam / namIssues de app/js/app.js sur un vrai .nam (extrait les fonctions du fichier, sans le DOM).
// Usage : node test_nam_parse.js <fichier.nam> [app.js]
const fs = require('fs'), path = require('path'), vm = require('vm');
const appPath = process.argv[3] || path.join(__dirname, '..', 'app', 'js', 'app.js');
const src = fs.readFileSync(appPath, 'utf8');
const grab = (startRe) => {
  const i = src.search(startRe);
  if (i < 0) throw new Error('introuvable : ' + startRe);
  // fin = première ligne qui commence par "}" ou "};" après le début
  const rest = src.slice(i), m = rest.search(/\n\}[;]?\s*\n/);
  return rest.slice(0, m + 3);
};
const code = [
  'const U = { info: null };',
  grab(/const namMaxBytes =/).split('\n')[0],
  grab(/const A2LITE = \{/),
  grab(/function a2LiteMismatch\(/),
  grab(/function parseNam\(/),
  grab(/function namIssues\(/),
  'module.exports = { parseNam, namIssues };',
].join('\n');
const ctx = { module: {}, TextEncoder, Float32Array, JSON, Number, String, Date, Math, Array };
vm.createContext(ctx);
vm.runInContext(code, ctx);
const { parseNam, namIssues } = ctx.module.exports;
const file = process.argv[2];
const r = parseNam(fs.readFileSync(file, 'utf8'), path.basename(file));
console.log(JSON.stringify({ a2: r.info.a2, arch: r.info.arch, sr: r.info.sr, nWeights: r.info.nWeights, bytes: r.info.bytes, lite: r.info.meta.lite || null }));
console.log('problèmes :', JSON.stringify(namIssues(r.info)));
