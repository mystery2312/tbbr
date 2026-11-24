/* ensemble.test.js : firmware + app de bureau + APK + app web, ensemble, sur UNE pédale émulée (même flash).
 *   1. app de bureau (Electron réel) : preset avec capture NAM + IR, sauvé dans la pédale puis exporté ;
 *   2. téléphone (fichiers de l'APK, pont Android) : voit ce preset, importe le fichier exporté (NAM/IR envoyés), le sauve ;
 *   3. pédale redémarrée ; app web (navigateur) : retrouve tout, la pédale joue le preset du téléphone avec les bons slots. */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { execFileSync } = require('node:child_process');
const { Pedal, CMD } = require('./lib/pedal');
const { serve, launch, openApp, confirmModal } = require('./lib/browser');
const { launchDesktop } = require('./lib/desktop');

const ROOT = path.join(__dirname, '..', '..');
const APK = process.env.E2E_APK || path.join(ROOT, 'android', 'app', 'build', 'outputs', 'apk', 'debug', 'app-debug.apk');
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-ensemble-'));
const list = p => p.json(CMD.PRESET_LIST, [], CMD.PRESET_LIST, 0);

/* preset « Ensemble » : NAM (slot 2) + IR (slot 4), créés dans l'app ; renvoie son emplacement */
const BUILD = async () => {
  const w = Float32Array.from({ length: 1871 }, (_, i) => Math.sin(i * 0.21) * 0.1), id = uid();
  await idb.put(id, { cfg: new Uint8Array(0), weights: w });
  S.nams[2] = { name: 'Ensemble NAM', file: 'e.nam', arch: 'WaveNet', a2: true, sr: 48000, nWeights: 1871, bytes: 7484, meta: {}, added: Date.now(), onDevice: false, id };
  const ir = Float32Array.from({ length: 2048 }, (_, i) => Math.exp(-i / 150) * Math.cos(i * 0.4));
  S.irs[4] = { name: 'Ensemble IR', user: true, rate: 48000, len: 2048, srcLen: 2048, srcRate: 48000, data: f2b(ir) };
  U.irCache.delete(4);
  const p = initPreset(), bn = { uid: uid(), model: 'nam' }, bi = { uid: uid(), model: 'ir' };
  p.name = 'Ensemble'; p.lanes[0] = [bn, bi, null, null, null, null, null, null];
  p.scenes.forEach(s => { s.state = { [bn.uid]: { on: true, p: { ...defaultParams('nam'), slot: 2 } }, [bi.uid]: { on: true, p: { ...defaultParams('ir'), slot: 4 } } }; });
  replacePreset(p); persist();
  return S.cur;
};
const EXPORT = async () => {
  let got = null; const real = download;
  download = (name, data) => { got = { name, data }; };
  try { await presetAction('export'); } finally { download = real; }
  return got;
};

test('firmware + app de bureau + APK + app web sur la même pédale', { skip: !fs.existsSync(APK) && 'APK absent (run.ps1 le construit)' }, async () => {
  const pedal = new Pedal();
  let file, deskSlot;
  try {
    /* ---- 1. app de bureau ---- */
    const d = await launchDesktop({ pedal });
    try {
      await d.page.click('#btnConnect');
      await d.page.locator('.conn-card:has(use[href="#i-usb"])').click();
      await d.wait(() => U.info && U.synced && U.tx.kind === 'usb' && Array.isArray(U.pedalIr), null, 10000);
      await d.run(() => selectPreset(12));
      await d.wait(() => S.cur === 12 && U.dirty.size === 0, null, 6000);
      deskSlot = await d.run(BUILD);
      await d.run(() => sendNam(2));                                   /* comme les boutons « Envoyer » des pages NAM / IR */
      await d.run(() => sendIR(4));
      await d.page.waitForTimeout(500);
      await d.page.click('#btnSave');
      await d.wait(() => U.dirty.size === 0, null, 6000);
      const out = await d.run(EXPORT);
      file = path.join(tmp, out.name); fs.writeFileSync(file, out.data);
      assert.deepEqual(d.errors, []);
    } finally { await d.close(); }
    let l = await list(pedal);
    assert.equal(l.presets[deskSlot], 'Ensemble'); assert.equal(l.nam[2], 'Ensemble NAM'); assert.equal(l.ir[4], 'Ensemble IR');

    /* ---- 2. téléphone : fichiers web de l'APK + pont Android ---- */
    const out = path.join(tmp, 'apk'); fs.mkdirSync(out, { recursive: true });
    execFileSync('tar', ['-xf', APK, '-C', out, 'assets']);
    const srv = await serve(path.join(out, 'assets', 'app')), browser = await launch();
    try {
      const phone = await openApp(browser, srv.url, pedal, { viewport: { width: 915, height: 412 }, mobile: true, bridge: 'android' });
      try {
        await phone.page.click('#btnConnect');
        await phone.page.locator('.conn-card:has(use[href="#i-usb"])').click();
        await phone.wait(() => U.info && U.synced && U.tx.kind === 'usb' && Array.isArray(U.pedalIr), null, 10000);
        assert.equal(await phone.run(i => S.presets[i].name, deskSlot), 'Ensemble', 'le téléphone ne voit pas le preset du PC');
        await phone.run(() => selectPreset(30));
        await phone.wait(() => S.cur === 30 && U.dirty.size === 0, null, 6000);
        /* import du fichier exporté sur le PC (slots 2 / 4 déjà occupés par les mêmes données : réutilisés) */
        const fc = phone.page.waitForEvent('filechooser');
        const done = phone.run(() => presetAction('import'));
        await (await fc).setFiles(file);
        await confirmModal(phone.page, 'primary');
        await done;
        await phone.wait(() => P().name === 'Ensemble', null, 15000);
        await phone.run(() => setPresetField('name', 'Ensemble tel'));
        await phone.page.waitForTimeout(300);
        await phone.run(() => savePreset());
        await phone.wait(() => U.dirty.size === 0, null, 6000);
        assert.deepEqual(await phone.errToasts(), []); assert.deepEqual(phone.errors, []);
      } finally { await phone.close(); }
    } finally { await browser.close(); await srv.close(); }

    /* ---- 3. pédale redémarrée, puis app web dans un navigateur de PC ---- */
    await pedal.reboot();
    l = await list(pedal);
    assert.equal(l.presets[deskSlot], 'Ensemble'); assert.equal(l.presets[30], 'Ensemble tel');
    const nams = l.nam.filter(n => n === 'Ensemble NAM').length, irs = l.ir.filter(n => n === 'Ensemble IR').length;
    assert.equal(nams, 1, 'capture NAM dupliquée ou perdue (' + nams + ')'); assert.equal(irs, 1, 'IR dupliquée ou perdue (' + irs + ')');
    const srv2 = await serve(), browser2 = await launch();
    try {
      const web = await openApp(browser2, srv2.url, pedal);
      try {
        await web.page.click('#btnConnect');
        await web.page.locator('.conn-card:has(use[href="#i-usb"])').click();
        await web.wait(() => U.info && U.synced && U.tx.kind === 'usb' && Array.isArray(U.pedalIr), null, 10000);
        await web.run(() => selectPreset(30));
        await web.wait(() => S.cur === 30 && P().name === 'Ensemble tel', null, 6000);
        const cur = await pedal.json(CMD.PRESET_GET, [0x7F], CMD.PRESET_GET, 0x7F);
        const row = m => cur.scenes[0].b.find(r => cur.lanes[r[0]][r[1]] === m);
        assert.equal(l.nam[row('nam')[3]], 'Ensemble NAM', 'la pédale joue une autre capture');
        assert.equal(l.ir[row('ir')[3]], 'Ensemble IR', 'la pédale joue une autre IR');
        assert.deepEqual(web.errors, []);
      } finally { await web.close(); }
    } finally { await browser2.close(); await srv2.close(); }
    assert.equal((await pedal.flashStats()).badWrites, 0, 'écriture flash sans effacement');
  } finally { await pedal.close(); }
});
