/* updater.test.js : mise à jour automatique de l'app de bureau (electron/updater.js) contre un faux GitHub.
 * Vrais fichiers : téléchargement, vérification SHA-256, remplacement de l'exe portable, nettoyage. */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { Updater, compareVersions } = require('../../electron/updater');
const { fakeGitHub, manifest } = require('./lib/fakegithub');

const STABLE = 'mystery2312/tbbr', BETA = 'mystery2312/tbbr-beta';
const tmpdir = () => fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-upd-'));
function setup(gh, version, { beta = false, exe = true } = {}) {
  const d = tmpdir(), exePath = path.join(d, 'BlackBox_TBBR_App.exe');
  if (exe) fs.writeFileSync(exePath, 'ANCIEN EXE ' + version);
  const spawned = [];
  const u = new Updater({
    version, fetch: (url, o) => fetch(url, o), dir: path.join(d, 'updates'), exePath: exe ? exePath : null, apiBase: gh.api,
    sources: [{ repo: STABLE, list: false }, ...(beta ? [{ repo: BETA, list: true }] : [])],
    spawn: (f, a, o) => { spawned.push(f); return { unref() {} }; },
  });
  return { u, d, exePath, spawned };
}

test('comparaison de versions (stable > beta, beta.10 > beta.3)', () => {
  assert.ok(compareVersions('0.9.6', '0.9.6-beta.3') > 0);
  assert.ok(compareVersions('0.9.6-beta.10', '0.9.6-beta.3') > 0);
  assert.ok(compareVersions('v0.10.0', '0.9.9') > 0);
  assert.equal(compareVersions('0.9.6', 'v0.9.6'), 0);
  assert.ok(compareVersions('0.9.5', '0.9.6-beta.1') < 0);
});

test('mise à jour complète : détection, téléchargement vérifié, remplacement de l\'exe, relance, nettoyage', async () => {
  const gh = await fakeGitHub();
  try {
    const exe = Buffer.from('NOUVEL EXE 0.9.7 ' + 'x'.repeat(300000));
    gh.release(STABLE, { tag: 'v0.9.7', files: { 'TBBR_update.json': manifest('0.9.7', { exe }), 'BlackBox_TBBR_App.exe': exe } });
    const { u, exePath, spawned } = setup(gh, '0.9.6');
    const r = await u.check();
    assert.equal(r.available, true); assert.equal(r.version, '0.9.7');
    const prog = [];
    const f = await u.download(r, x => prog.push(x));
    assert.ok(prog.length > 1 && prog.at(-1) === 1, 'progression');
    u.stage(r, f);
    assert.equal(u.pending().version, '0.9.7');
    const a = u.apply({ relaunch: true });
    assert.equal(a.ok, true, a.reason);
    assert.deepEqual(fs.readFileSync(exePath), exe, 'exe non remplacé');
    assert.ok(fs.existsSync(exePath + '.old'), 'ancien exe gardé jusqu\'au prochain lancement');
    assert.deepEqual(spawned, [exePath], 'nouvelle version non relancée');
    /* « prochain lancement » : la version installée est 0.9.7 */
    const next = new Updater({ ...u, version: '0.9.7', sources: u.sources, fetch: u.fetch, dir: u.dir, exePath, apiBase: gh.api });
    next.cleanup();
    assert.ok(!fs.existsSync(exePath + '.old'), 'ancien exe non supprimé');
    assert.deepEqual(fs.readdirSync(u.dir), [], 'téléchargements non nettoyés');
    assert.equal((await next.check()).available, false, 'mise à jour reproposée après installation');
  } finally { await gh.close(); }
});

test('exe verrouillé (comme par le lanceur portable) : remplacement différé, fait dès que l\'exe se libère', async () => {
  const gh = await fakeGitHub();
  const { spawn } = require('node:child_process');
  try {
    const exe = Buffer.from('NOUVEL EXE VERROUILLE ' + 'z'.repeat(50000));
    gh.release(STABLE, { tag: 'v0.9.7', files: { 'TBBR_update.json': manifest('0.9.7', { exe }), 'BlackBox_TBBR_App.exe': exe } });
    const d = tmpdir(), exePath = path.join(d, 'BlackBox_TBBR_App.exe');
    fs.writeFileSync(exePath, 'ANCIEN');
    const u = new Updater({ version: '0.9.6', fetch: (url, o) => fetch(url, o), dir: path.join(d, 'updates'), exePath, apiBase: gh.api,
      sources: [{ repo: STABLE, list: false }], spawn, log: () => {} });
    const r = await u.check(); u.stage(r, await u.download(r));
    /* verrou sans partage « suppression » pendant 3 s, comme le lanceur portable d'electron-builder */
    const lock = spawn('powershell', ['-NoProfile', '-Command', `$f=[IO.File]::Open('${exePath}','Open','Read','Read'); Start-Sleep -Seconds 3; $f.Close()`], { stdio: 'ignore' });
    await new Promise(r => setTimeout(r, 1200));
    const a = u.apply();
    assert.equal(a.ok, true, a.reason); assert.equal(a.deferred, true, 'le remplacement aurait dû être différé');
    assert.equal(fs.readFileSync(exePath, 'utf8'), 'ANCIEN', 'exe remplacé malgré le verrou');
    const end = Date.now() + 20000;
    while (Date.now() < end && !fs.readFileSync(exePath).equals(exe)) await new Promise(r => setTimeout(r, 300));
    assert.deepEqual(fs.readFileSync(exePath), exe, 'exe non remplacé après la libération');
    assert.ok(fs.existsSync(exePath + '.old'));
    assert.equal(u.pending(), null, 'pending.json non effacé');
    assert.match(fs.readFileSync(path.join(u.dir, 'apply_update.log'), 'utf8'), /0\.9\.7 installée/);
    await new Promise(r => lock.exitCode !== null ? r() : lock.on('exit', r));
  } finally { await gh.close(); }
});

test('fichier altéré (SHA-256 différent) : refusé, exe intact, rien de prêt', async () => {
  const gh = await fakeGitHub();
  try {
    const exe = Buffer.from('VRAI EXE'), evil = Buffer.from('EXE MODIFIE');
    gh.release(STABLE, { tag: 'v0.9.7', files: { 'TBBR_update.json': manifest('0.9.7', { exe }), 'BlackBox_TBBR_App.exe': evil } });
    const { u, exePath } = setup(gh, '0.9.6');
    const r = await u.check();
    await assert.rejects(u.download(r), /refusé/);
    assert.deepEqual(fs.readdirSync(u.dir), [], 'fichier partiel laissé sur le disque');
    assert.equal(fs.readFileSync(exePath, 'utf8'), 'ANCIEN EXE 0.9.6');
    assert.equal(u.pending(), null);
    assert.equal(u.apply().ok, false);
  } finally { await gh.close(); }
});

test('fichier altéré APRÈS téléchargement : apply() le refuse et le supprime', async () => {
  const gh = await fakeGitHub();
  try {
    const exe = Buffer.from('VRAI EXE 2');
    gh.release(STABLE, { tag: 'v0.9.7', files: { 'TBBR_update.json': manifest('0.9.7', { exe }), 'BlackBox_TBBR_App.exe': exe } });
    const { u, exePath } = setup(gh, '0.9.6');
    const r = await u.check(), f = await u.download(r);
    u.stage(r, f);
    fs.writeFileSync(f, 'ALTERE ' + 'y'.repeat(exe.length - 7));
    const a = u.apply();
    assert.equal(a.ok, false); assert.match(a.reason, /altéré/);
    assert.equal(fs.readFileSync(exePath, 'utf8'), 'ANCIEN EXE 0.9.6');
    assert.ok(!fs.existsSync(f));
  } finally { await gh.close(); }
});

test('canaux : une beta voit la stable plus récente ; dépôt beta privé (404) sans erreur bloquante', async () => {
  const gh = await fakeGitHub();
  try {
    const exe = Buffer.from('STABLE 0.9.6');
    gh.release(STABLE, { tag: 'v0.9.6', files: { 'TBBR_update.json': manifest('0.9.6', { exe }), 'BlackBox_TBBR_App.exe': exe } });
    gh.deny(BETA);
    const { u } = setup(gh, '0.9.6-beta.3', { beta: true });
    const r = await u.check();
    assert.equal(r.available, true, 'la stable 0.9.6 doit remplacer la 0.9.6-beta.3');
    assert.ok(r.errors.some(e => /404/.test(e)));
    /* dépôt beta accessible avec une beta plus récente : elle gagne */
    const gh2 = await fakeGitHub();
    try {
      const b = Buffer.from('BETA 0.9.7-beta.1');
      gh2.release(STABLE, { tag: 'v0.9.6', files: { 'TBBR_update.json': manifest('0.9.6', { exe }), 'BlackBox_TBBR_App.exe': exe } });
      gh2.release(BETA, { tag: 'v0.9.7-beta.1', prerelease: true, files: { 'TBBR_update.json': manifest('0.9.7-beta.1', { exe: b, channel: 'beta' }), 'BlackBox_TBBR_App.exe': b } });
      const { u: ub } = setup(gh2, '0.9.6-beta.3', { beta: true });
      assert.equal((await ub.check()).version, '0.9.7-beta.1');
      const { u: us } = setup(gh2, '0.9.6');                                  /* une stable ne regarde jamais le dépôt beta */
      assert.equal((await us.check()).available, false);
    } finally { await gh2.close(); }
  } finally { await gh.close(); }
});

test('ancienne release sans manifeste, ou manifeste invalide : rien n\'est installé', async () => {
  const gh = await fakeGitHub();
  try {
    gh.release(STABLE, { tag: 'v0.9.9', files: { 'BlackBox_TBBR_App.exe': Buffer.from('x') } });
    const { u } = setup(gh, '0.9.6');
    assert.equal((await u.check()).available, false);
    const bad = manifest('1.0.0', { exe: Buffer.from('y') }); bad.app.sha256 = 'pas-un-hash';
    gh.release(STABLE, { tag: 'v1.0.0', files: { 'TBBR_update.json': bad, 'BlackBox_TBBR_App.exe': Buffer.from('y') } });
    const r = await u.check();
    assert.equal(r.available, false); assert.ok(r.errors.some(e => /invalide/.test(e)));
  } finally { await gh.close(); }
});

test('app non portable (lancée depuis les sources) : détection seulement, pas de remplacement', async () => {
  const gh = await fakeGitHub();
  try {
    const exe = Buffer.from('NOUVEL EXE');
    gh.release(STABLE, { tag: 'v0.9.7', files: { 'TBBR_update.json': manifest('0.9.7', { exe }), 'BlackBox_TBBR_App.exe': exe } });
    const { u } = setup(gh, '0.9.6', { exe: false });
    assert.equal(u.canReplace(), false);
    const r = await u.check(); u.stage(r, await u.download(r));
    assert.match(u.apply().reason, /non portable/);
  } finally { await gh.close(); }
});
