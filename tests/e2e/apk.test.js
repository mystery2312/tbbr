/* apk.test.js : l'app Android (APK) de bout en bout, sans téléphone.
 * 1. le paquet : nom, versions, permissions, assets = éditeur actuel + pont android-midi.js, tests JVM de la mise à jour ;
 * 2. les fichiers web EXTRAITS DE L'APK, dans un navigateur mobile, avec le pont natif simulé (mêmes méthodes que
 *    MidiBridge.java / AppBridge) relié à la pédale émulée (vrai firmware).
 * APK testé : E2E_APK, sinon android/app/build/outputs/apk/debug/app-debug.apk (construit par run.ps1). */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { Pedal, CMD } = require('./lib/pedal');
const { serve, launch, openApp } = require('./lib/browser');

const ROOT = path.join(__dirname, '..', '..');
const APK = process.env.E2E_APK || path.join(ROOT, 'android', 'app', 'build', 'outputs', 'apk', 'debug', 'app-debug.apk');
const SDK = process.env.ANDROID_HOME || path.join(process.env.LOCALAPPDATA || '', 'Android', 'Sdk');
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-apk-'));
const OUT = path.join(tmp, 'apk');
let srv, browser, assets;

function aapt2() {
  const bt = path.join(SDK, 'build-tools');
  const v = fs.existsSync(bt) ? fs.readdirSync(bt).sort().reverse().find(d => fs.existsSync(path.join(bt, d, 'aapt2.exe'))) : null;
  return v ? path.join(bt, v, 'aapt2.exe') : null;
}

test.before(async () => {
  assert.ok(fs.existsSync(APK), 'APK absent : ' + APK + ' (lancer tests\\e2e\\run.ps1, qui le construit)');
  fs.mkdirSync(OUT, { recursive: true });
  execFileSync('tar', ['-xf', APK, '-C', OUT, 'assets', 'AndroidManifest.xml']);   /* un APK est un zip (bsdtar de Windows) */
  assets = path.join(OUT, 'assets', 'app');
  srv = await serve(assets);
  browser = await launch();
});
test.after(async () => { if (browser) await browser.close(); if (srv) await srv.close(); });

/* ---------------- 1. le paquet ---------------- */
test('APK : paquet, versions, SDK minimum et permissions', { skip: !aapt2() && 'aapt2 introuvable (Android SDK)' }, () => {
  const b = execFileSync(aapt2(), ['dump', 'badging', APK], { encoding: 'utf8' });
  assert.match(b, /package: name='com\.tbbr\.blackbox'/);
  const code = +b.match(/versionCode='(\d+)'/)[1], name = b.match(/versionName='([^']+)'/)[1];
  assert.ok(code > 0, 'versionCode');
  assert.match(name, /^\d+\.\d+\.\d+(-beta\.\d+)?$/, 'versionName');
  assert.match(b, /minSdkVersion:'24'/);
  for (const p of ['android.permission.INTERNET', 'android.permission.REQUEST_INSTALL_PACKAGES']) assert.ok(b.includes(`uses-permission: name='${p}'`), p);
  assert.ok(!b.includes('WRITE_EXTERNAL_STORAGE'), 'permission de stockage inutile');
  assert.match(b, /uses-feature: name='android\.software\.midi'/);
});

test('APK : les fichiers web embarqués sont exactement l\'éditeur actuel + le pont Android', () => {
  const staged = path.join(tmp, 'staged');
  execFileSync('powershell', ['-NoProfile', '-ExecutionPolicy', 'Bypass', '-File', path.join(ROOT, 'android', 'stage_assets.ps1'), staged], { stdio: 'pipe' });
  const list = d => fs.readdirSync(d, { recursive: true }).filter(f => fs.statSync(path.join(d, f)).isFile()).map(f => f.replace(/\\/g, '/')).sort();
  const a = list(assets), s = list(staged);
  assert.deepEqual(a, s, 'liste des fichiers');
  const stale = s.filter(f => !/\.html$/.test(f) && !fs.readFileSync(path.join(staged, f)).equals(fs.readFileSync(path.join(assets, f))));
  assert.deepEqual(stale, [], 'APK périmé : fichiers différents de l\'éditeur actuel (reconstruire l\'APK)');
  for (const page of ['index.html', 'ecran.html']) {
    const h = fs.readFileSync(path.join(assets, page), 'utf8');
    const i = h.indexOf('js/android-midi.js'), j = h.search(/<script src="js\/(?!android-midi)/);
    assert.ok(i > 0 && i < j, page + ' : android-midi.js doit être chargé avant les scripts de l\'éditeur');
    assert.ok(!/fonts\.googleapis/.test(h.replace(/<link[^>]+fonts\.googleapis[^>]*>/g, '')) || /@font-face/.test(h), page + ' : polices embarquées');
    for (const m of h.matchAll(/url\((fonts\/[^)]+)\)/g)) assert.ok(fs.existsSync(path.join(assets, m[1])), 'police absente : ' + m[1]);
  }
});

test('APK : logique de mise à jour (tests JVM UpdateLogicTest) passée', () => {
  const dir = path.join(ROOT, 'android', 'app', 'build', 'test-results', 'testReleaseUnitTest');
  assert.ok(fs.existsSync(dir), 'résultats JVM absents (run.ps1 lance gradlew testReleaseUnitTest)');
  const xml = fs.readdirSync(dir).filter(f => f.endsWith('.xml')).map(f => fs.readFileSync(path.join(dir, f), 'utf8')).join('');
  const n = [...xml.matchAll(/tests="(\d+)"/g)].reduce((s, m) => s + +m[1], 0);
  const bad = [...xml.matchAll(/(failures|errors)="(\d+)"/g)].reduce((s, m) => s + +m[2], 0);
  assert.ok(n >= 5, 'tests JVM : ' + n); assert.equal(bad, 0, 'tests JVM en échec');
  const apkTime = fs.statSync(APK).mtimeMs, src = path.join(ROOT, 'android', 'app', 'src', 'main', 'java', 'com', 'tbbr', 'blackbox', 'UpdateLogic.java');
  assert.ok(fs.statSync(dir).mtimeMs >= fs.statSync(src).mtimeMs, 'résultats JVM plus anciens que UpdateLogic.java');
  assert.ok(apkTime >= fs.statSync(src).mtimeMs, 'APK plus ancien que le code Java');
});

/* ---------------- 2. l'app Android (fichiers de l'APK) avec la pédale émulée ---------------- */
const PHONE = { viewport: { width: 915, height: 412 }, mobile: true, bridge: 'android' };   /* téléphone en paysage (l'app le demande) */
async function connectAndroid(app) {
  await app.page.click('#btnConnect');
  await app.page.locator('.conn-card:has(use[href="#i-usb"])').click();
  await app.wait(() => U.info && U.synced && U.tx.kind === 'usb' && Array.isArray(U.pedalIr), null, 10000);
}

test('Android : connexion USB OTG par le pont natif, synchro, sauvegarde dans la pédale', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal, PHONE);
  try {
    assert.equal(await app.page.evaluate(() => window.tbbrAndroid), true, 'android-midi.js inactif');
    await connectAndroid(app);
    assert.match(await app.run(() => U.tx.label), /BlackBox Custom/);
    const info = await pedal.info();
    assert.equal(await app.run(() => P().name), info.curPreset.slice(0, 20));
    await app.run(() => setPresetField('name', 'Android E2E'));
    await app.page.waitForTimeout(300);
    await app.run(() => savePreset());
    await app.wait(() => U.dirty.size === 0, null, 6000);
    assert.equal((await pedal.json(CMD.PRESET_LIST, [], CMD.PRESET_LIST, 0)).presets[info.curIndex], 'Android E2E');
    assert.deepEqual(await app.errToasts(), []); assert.deepEqual(app.errors, []);
  } finally { await app.close(); await pedal.close(); }
});

test('Android : export d\'un preset -> fichier enregistré par l\'app native (Téléchargements/TBBR)', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal, PHONE);
  try {
    await connectAndroid(app);
    await app.run(() => presetAction('export'));
    await app.page.waitForFunction(() => window.__android.saved.length > 0, null, { timeout: 5000 });
    const f = await app.page.evaluate(() => window.__android.saved[0]);
    assert.match(f.name, /\.tbbr\.json$/);
    const doc = JSON.parse(Buffer.from(f.data, 'base64').toString('utf8'));
    assert.equal(doc.format, 'tbbr-preset'); assert.equal(doc.version, 2);
    await app.page.waitForFunction(() => window.__toasts.some(t => /Enregistré : Téléchargements\/TBBR\//.test(t.text)), null, { timeout: 3000 });
  } finally { await app.close(); await pedal.close(); }
});

test('Android : pédale débranchée puis rebranchée -> l\'app le voit et se reconnecte', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal, PHONE);
  try {
    await connectAndroid(app);
    await app.page.evaluate(() => window.__e2eUnplug());
    await app.wait(() => !U.tx, null, 5000);
    await app.page.evaluate(() => window.__e2ePlug());
    await app.run(() => connect('usb'));
    await app.wait(() => U.info && U.tx && U.tx.kind === 'usb', null, 8000);
    assert.deepEqual(app.errors, []);
  } finally { await app.close(); await pedal.close(); }
});

test('Android : page Appareil -> version de l\'APK et recherche de mise à jour native', async () => {
  const app = await openApp(browser, srv.url, null, PHONE);
  try {
    await app.run(() => setView('device'));
    await app.page.locator('#appUpdCard button').click();
    assert.equal(await app.page.evaluate(() => window.__android.updateChecks), 1, 'TBBRAndroid.checkUpdate non appelé');
    assert.match(await app.page.locator('#appVer').innerText(), /9\.9\.9-test/);
  } finally { await app.close(); }
});
