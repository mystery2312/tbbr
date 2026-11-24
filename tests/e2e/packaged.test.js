/* packaged.test.js : mise à jour automatique avec les VRAIS exe portables construits par electron-builder (lent : ~5 min).
 * Lancé seulement avec E2E_PACKAGED=1 (release.ps1 / beta.ps1, ou run.ps1 -Packaged).
 *   A = app portable 0.9.90, B = 0.9.91 ; faux GitHub qui publie B avec son manifeste.
 *   1. A démarre, trouve B, le télécharge et le vérifie (pending.json) ;
 *   2. A est fermée normalement (WM_CLOSE) : l'exe A est remplacé par B à la fermeture ;
 *   3. l'exe relancé est B : il supprime l'ancien exe et ne repropose rien. */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const net = require('node:net');
const { spawn, execFileSync } = require('node:child_process');
const { fakeGitHub, manifest } = require('./lib/fakegithub');

const ELEC = path.join(__dirname, '..', '..', 'electron');
const SKIP = process.env.E2E_PACKAGED !== '1' && 'lent : E2E_PACKAGED=1 pour le lancer';
const sleep = ms => new Promise(r => setTimeout(r, ms));
const freePort = () => new Promise(res => { const s = net.createServer(); s.listen(0, '127.0.0.1', () => { const p = s.address().port; s.close(() => res(p)); }); });

function build(version) {
  const out = path.join(os.tmpdir(), 'tbbr-pkg-' + version.replace(/\./g, '_'));
  const exe = path.join(out, 'BlackBox_TBBR_App_' + version + '.exe');
  if (process.env.E2E_REUSE_BUILD === '1' && fs.existsSync(exe)) return exe;
  execFileSync('cmd', ['/c', `npx electron-builder --win portable --publish never -c.extraMetadata.version=${version} -c.directories.output="${out}"`],
    { cwd: ELEC, stdio: 'pipe', env: { ...process.env, CSC_IDENTITY_AUTO_DISCOVERY: 'false' }, timeout: 600000 });
  return exe;
}
/* processus fils (récursif) d'un pid : le lanceur portable extrait puis lance l'app Electron */
function children(pid) {
  const out = execFileSync('powershell', ['-NoProfile', '-Command', `Get-CimInstance Win32_Process | Select-Object ProcessId,ParentProcessId | ConvertTo-Json`], { encoding: 'utf8' });
  const all = JSON.parse(out), res = [];
  const walk = p => all.filter(x => x.ParentProcessId === p).forEach(x => { res.push(x.ProcessId); walk(x.ProcessId); });
  walk(pid);
  return res;
}
async function until(fn, ms, what) {
  const end = Date.now() + ms;
  while (Date.now() < end) { if (await fn()) return; await sleep(300); }
  throw new Error('délai dépassé : ' + what);
}

test('exe portable réel : 0.9.90 se met à jour en 0.9.91 (téléchargement vérifié, remplacement à la fermeture, nettoyage)', { skip: SKIP, timeout: 900000 }, async () => {
  const A = build('0.9.90'), B = build('0.9.91');
  const bBytes = fs.readFileSync(B);
  const gh = await fakeGitHub();
  gh.release('mystery2312/tbbr', { tag: 'v0.9.91', files: { 'TBBR_update.json': manifest('0.9.91', { exe: bBytes }), 'BlackBox_TBBR_App.exe': bBytes } });
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-install-')), exe = path.join(dir, 'BlackBox_TBBR_App.exe');
  fs.copyFileSync(A, exe);
  const userData = path.join(dir, 'profil');
  const env = { ...process.env, TBBR_USER_DATA: userData, TBBR_UPDATE_API: gh.api, TBBR_UPDATE_DELAY_MS: '300' };
  try {
    /* 1. A détecte et télécharge B */
    let p = spawn(exe, [], { env: { ...env, TBBR_PORT: String(await freePort()) }, stdio: 'ignore' });
    const pending = path.join(userData, 'updates', 'pending.json');
    await until(() => fs.existsSync(pending), 240000, 'mise à jour téléchargée (pending.json)');
    assert.equal(JSON.parse(fs.readFileSync(pending, 'utf8')).version, '0.9.91');
    assert.deepEqual(fs.readFileSync(exe), fs.readFileSync(A), 'exe remplacé avant la fermeture');
    /* 2. fermeture normale (comme la croix de la fenêtre) : installation à la fermeture */
    const kids = children(p.pid);
    assert.ok(kids.length, 'app Electron non trouvée sous le lanceur portable');
    for (const k of kids) { try { execFileSync('taskkill', ['/PID', String(k)], { stdio: 'pipe' }); } catch { /* déjà fermé */ } }
    await until(() => p.exitCode !== null, 60000, 'fermeture de l\'app');
    await until(() => fs.readFileSync(exe).equals(bBytes), 20000, 'exe remplacé par 0.9.91');
    assert.ok(fs.readdirSync(dir).some(f => f.endsWith('.old')), 'ancien exe gardé jusqu\'au prochain lancement');
    /* 3. relance : c'est B ; il nettoie l'ancien exe et ne repropose rien */
    p = spawn(exe, [], { env: { ...env, TBBR_PORT: String(await freePort()) }, stdio: 'ignore' });
    await until(() => !fs.readdirSync(dir).some(f => f.endsWith('.old')), 120000, 'ancien exe supprimé au lancement de 0.9.91');
    await sleep(3000);
    assert.ok(!fs.existsSync(pending), 'mise à jour reproposée après installation');
    assert.match(fs.readFileSync(path.join(userData, 'updates', 'apply_update.log'), 'utf8'), /mise à jour 0\.9\.91 installée/);
    for (const k of children(p.pid)) { try { execFileSync('taskkill', ['/PID', String(k)], { stdio: 'pipe' }); } catch { /* */ } }
    await until(() => p.exitCode !== null, 60000, 'fermeture de 0.9.91');
  } finally { await gh.close(); }
});
