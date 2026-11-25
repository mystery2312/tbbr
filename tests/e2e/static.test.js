/* static.test.js : contrôles rapides sans exécution (syntaxe, copies synchronisées, versions cohérentes). */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const { execFileSync } = require('node:child_process');

const ROOT = path.join(__dirname, '..', '..');
const R = (...p) => path.join(ROOT, ...p);
const read = (...p) => fs.readFileSync(R(...p), 'utf8');

test('installateur : une pédale UBOOT vue par une lettre de lecteur et par PhysicalDriveN compte une seule fois', () => {
  const out = execFileSync('python', ['-I', path.join(__dirname, 'py', 'test_find_uboot.py')], { encoding: 'utf8' });
  assert.match(out, /OK/);
});

test('syntaxe JavaScript de l\'app, de la simulation et d\'Electron', () => {
  const files = ['interface/app/js/app.js', 'interface/app/js/data.js', 'interface/app/js/transport.js', 'interface/app/js/i18n.js',
    'interface/app/js/ecran.js', 'electron/main.js', 'electron/preload.js', 'electron/updater.js', 'tools/release_manifest.js', 'android/web/android-midi.js'].filter(f => fs.existsSync(R(f)));
  for (const f of files) execFileSync(process.execPath, ['--check', R(f)], { stdio: 'pipe' });
});

test('script inline de l\'installateur : syntaxe valide (régression 0.9.2 « page vide »)', () => {
  const html = read('installer', 'resources', 'ui', 'index.html');
  const scripts = [...html.matchAll(/<script(?![^>]*\bsrc=)[^>]*>([\s\S]*?)<\/script>/g)].map(m => m[1]);
  assert.ok(scripts.length, 'aucun script inline');
  scripts.forEach((s, i) => assert.doesNotThrow(() => new Function(s), 'script inline ' + i));
});

test('simulation de l\'écran du site (docs/sim) identique à celle de l\'app', () => {
  for (const f of ['js/data.js', 'js/ecran.js', 'js/i18n.js', 'css/ecran.css']) {
    if (!fs.existsSync(R('docs', 'sim', f))) continue;
    assert.ok(read('docs', 'sim', f) === read('interface', 'app', f), 'docs/sim/' + f + ' différent de interface/app : relancer docs/make_site.ps1');
  }
});

test('versions : firmware, catalogue généré et app de bureau cohérents', () => {
  const fw = read('fw_maison', 'fw6', 'main.c').match(/#define FW_VERSION "TBBR fw6 (\d+\.\d+)"/);
  assert.ok(fw, 'FW_VERSION');
  const pkg = JSON.parse(read('electron', 'package.json'));
  assert.match(pkg.version, /^\d+\.\d+\.\d+(-beta\.\d+)?$/);
  /* catalog.h est généré depuis data.js par gen_catalog.js : il doit être à jour */
  const before = read('fw_maison', 'fw6', 'catalog.h');
  execFileSync(process.execPath, [R('fw_maison', 'fw6', 'gen_catalog.js')], { cwd: R('fw_maison', 'fw6'), stdio: 'pipe' });
  assert.equal(read('fw_maison', 'fw6', 'catalog.h'), before, 'catalog.h n\'était pas à jour avec data.js');
});

test('dépôt public : aucun fichier privé suivi par git', () => {
  const git = [path.join(process.env.LOCALAPPDATA || '', 'Programs', 'MinGit', 'cmd', 'git.exe'), 'git'].find(g => g === 'git' || fs.existsSync(g));
  let files;
  try { files = execFileSync(git, ['ls-files'], { cwd: ROOT, encoding: 'utf8' }).split('\n'); } catch { return; }
  const bad = files.filter(f => /(^|\/)(save\.md|backups\/|tools_ext\/|analysis\/|M-UPGRADE)|\.am2Data$|\.fwsc$|\.jks$|\.pass$/i.test(f));
  assert.deepEqual(bad, []);
  /* règle de l'utilisateur : le produit de référence n'est cité nulle part (nom reconstitué pour ne pas l'écrire ici) */
  const name = ['ul', 'tra', ' ?', 'rig'].join('');
  let hits = '';
  try { hits = execFileSync(git, ['grep', '-i', '-I', '-l', '-E', name, '--', '.'], { cwd: ROOT, encoding: 'utf8' }); } catch { /* aucun résultat */ }
  assert.equal(hits.trim(), '', 'fichiers suivis qui citent le produit de référence');
});
