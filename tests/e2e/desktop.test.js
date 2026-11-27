/* desktop.test.js : l'app de bureau RÉELLE (Electron du projet : main.js, preload.js, updater.js) de bout en bout.
 * - avec la pédale émulée (vrai firmware) via un port USB MIDI simulé ;
 * - mise à jour automatique contre un faux GitHub, avec un exe portable factice (copie d'un utilitaire Windows inoffensif). */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { Pedal, CMD } = require('./lib/pedal');
const { launchDesktop } = require('./lib/desktop');
const { fakeGitHub, manifest } = require('./lib/fakegithub');

const SYS = path.join(process.env.SystemRoot || 'C:\\Windows', 'System32');
const OLD_EXE = fs.readFileSync(path.join(SYS, 'whoami.exe'));       /* « ancienne version » : petit exe inoffensif */
const NEW_EXE = fs.readFileSync(path.join(SYS, 'hostname.exe'));     /* « nouvelle version » : relancé après la mise à jour */
const STABLE = 'mystery2312/tbbr';
const portableExe = () => { const d = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-portable-')), f = path.join(d, 'BlackBox_TBBR_App.exe'); fs.writeFileSync(f, OLD_EXE); return f; };
async function publish(gh, version, exe, served = exe) {
  gh.release(STABLE, { tag: 'v' + version, files: { 'TBBR_update.json': manifest(version, { exe }), 'BlackBox_TBBR_App.exe': served } });
}
const state = d => d.page.evaluate(() => window.tbbrDesktop.appUpdateState());
async function waitState(d, s, ms = 20000) {
  const end = Date.now() + ms;
  let last;
  while (Date.now() < end) {
    last = await state(d);
    if (last.state === s) return last;
    await new Promise(r => setTimeout(r, 150));
  }
  throw new Error('état de mise à jour attendu ' + s + ', obtenu ' + JSON.stringify(last));
}

test('app de bureau + pédale émulée : connexion USB, modification sauvée dans la pédale', async () => {
  const pedal = new Pedal(), d = await launchDesktop({ pedal });
  try {
    await d.page.click('#btnConnect');
    await d.page.locator('.conn-card:has(use[href="#i-usb"])').click();
    await d.wait(() => U.info && U.synced && U.tx.kind === 'usb' && Array.isArray(U.pedalIr), null, 10000);
    const info = await pedal.info();
    assert.equal(await d.run(() => U.info.fw), info.fw);
    await d.run(() => setPresetField('name', 'Bureau E2E'));
    await d.page.waitForTimeout(300);
    await d.page.click('#btnSave');
    await d.wait(() => U.dirty.size === 0, null, 6000);
    const l = await pedal.json(CMD.PRESET_LIST, [], CMD.PRESET_LIST, 0);
    assert.equal(l.presets[info.curIndex], 'Bureau E2E');
    assert.deepEqual(await d.errToasts(), []); assert.deepEqual(d.errors, []);
  } finally { await d.close(); await pedal.close(); }
});

test('mise à jour auto : détectée, téléchargée et vérifiée, « Redémarrer maintenant » remplace l\'exe et relance', async () => {
  const gh = await fakeGitHub(), exe = portableExe();
  await publish(gh, '99.0.0', NEW_EXE);
  const d = await launchDesktop({ api: gh.api, exePath: exe });
  try {
    await waitState(d, 'ready');
    const s = await state(d);
    assert.equal(s.version, '99.0.0'); assert.equal(s.canInstall, true);
    const banner = d.page.locator('#appUpdBanner[data-state="ready"]');
    await banner.waitFor({ timeout: 5000 });
    assert.match(await banner.innerText(), /99\.0\.0/);
    assert.deepEqual(fs.readFileSync(exe), OLD_EXE, 'exe remplacé avant le clic');
    const closed = new Promise(r => d.app.once('close', r));
    await banner.locator('.upd-go').click();
    await Promise.race([closed, new Promise((_, j) => setTimeout(() => j(new Error('l\'app ne s\'est pas fermée')), 15000))]);
    assert.deepEqual(fs.readFileSync(exe), NEW_EXE, 'exe non remplacé');
    assert.ok(fs.existsSync(exe + '.old'), 'ancien exe absent');
    assert.ok(gh.hits.some(h => h.endsWith('/BlackBox_TBBR_App.exe')));
  } finally { await d.close(); await gh.close(); }
});

test('mise à jour auto : prête mais pas installée -> installée à la fermeture de l\'app, puis plus proposée', async () => {
  const gh = await fakeGitHub(), exe = portableExe();
  await publish(gh, '99.0.0', NEW_EXE);
  const d = await launchDesktop({ api: gh.api, exePath: exe });
  try { await waitState(d, 'ready'); } finally { await d.close(); }
  assert.deepEqual(fs.readFileSync(exe), NEW_EXE, 'exe non remplacé à la fermeture');
  /* relance avec le même profil (sans réseau) : le paquet prêt a été consommé, pas de seconde installation */
  const d2 = await launchDesktop({ api: 'http://127.0.0.1:9/', exePath: exe, userData: d.userData });
  try {
    await d2.page.waitForTimeout(1000);
    assert.notEqual((await state(d2)).state, 'ready', 'mise à jour encore marquée prête après installation');
  } finally { await d2.close(); await gh.close(); }
});

test('mise à jour auto : fichier altéré sur le serveur -> refusé, rien d\'installé, pas de bannière', async () => {
  const gh = await fakeGitHub(), exe = portableExe();
  await publish(gh, '99.0.0', NEW_EXE, Buffer.concat([NEW_EXE.subarray(0, NEW_EXE.length - 1), Buffer.from([NEW_EXE.at(-1) ^ 1])]));
  const d = await launchDesktop({ api: gh.api, exePath: exe });
  try {
    await waitState(d, 'error');
    assert.match((await state(d)).error, /refusé/);
    assert.equal(await d.page.locator('#appUpdBanner').count(), 0);
  } finally { await d.close(); await gh.close(); }
  assert.deepEqual(fs.readFileSync(exe), OLD_EXE, 'exe modifié malgré un fichier refusé');
  assert.ok(!fs.existsSync(exe + '.old'));
});

test('app lancée hors exe portable : la nouvelle version est annoncée avec un lien, sans téléchargement', async () => {
  const gh = await fakeGitHub();
  await publish(gh, '99.0.0', NEW_EXE);
  const d = await launchDesktop({ api: gh.api, exePath: null });
  try {
    await waitState(d, 'available');
    await d.page.locator('#appUpdBanner[data-state="available"]').waitFor({ timeout: 5000 });
    assert.ok(!gh.hits.some(h => h.endsWith('/BlackBox_TBBR_App.exe')), 'téléchargement inutile');
  } finally { await d.close(); await gh.close(); }
});

test('page Appareil : bouton « Rechercher une mise à jour de l\'app » (déjà à jour)', async () => {
  const gh = await fakeGitHub();
  await publish(gh, '0.9.5', NEW_EXE);                                /* plus ancienne que l'app */
  const d = await launchDesktop({ api: gh.api, exePath: portableExe() });
  try {
    await waitState(d, 'none');
    await d.run(() => setView('device'));
    await d.page.locator('#appUpdCard button').click();
    await d.page.waitForFunction(() => window.__toasts.some(t => /à jour|up to date/.test(t.text)), null, { timeout: 5000 });
    assert.match(await d.page.locator('#appVer').innerText(), /\d+\.\d+\.\d+/);
  } finally { await d.close(); await gh.close(); }
});
