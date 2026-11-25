/* app.test.js : tests de bout en bout « utilisateur » : l'app réelle (Edge headless) <-> USB MIDI simulé <-> firmware émulé.
 * Lancer : node --test tests/e2e/app.test.js   (après tests/e2e/emu/build.ps1 et npm install dans tests/e2e) */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { Pedal, CMD } = require('./lib/pedal');
const { serve, launch, openApp, confirmModal } = require('./lib/browser');

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-app-e2e-'));
let srv, browser;
test.before(async () => { srv = await serve(); browser = await launch(); });
test.after(async () => { if (browser) await browser.close(); if (srv) await srv.close(); });

/* lit l'état de la pédale depuis sa flash (2e émulateur) : ce qui survivrait à un redémarrage */
async function pedalFlash(pedal, fn) {
  const f = path.join(tmp, 'flash_' + Date.now() + '_' + Math.random().toString(36).slice(2) + '.bin');
  await pedal.saveFlash(f);
  const q = new Pedal({ flash: f });
  try { await q.info(); return await fn(q); } finally { await q.close(); }
}
const list = p => p.json(CMD.PRESET_LIST, [], CMD.PRESET_LIST, 0);
const slotGet = (p, i) => p.json(CMD.PRESET_GET, [i], CMD.PRESET_GET, i);

async function connectUsb(app) {
  const { page } = app;
  await page.click('#btnConnect');
  const t0 = Date.now();
  await page.locator('.conn-card:has(use[href="#i-usb"])').click();
  await app.wait(() => U.info && U.synced && !U.tx.kind.includes('demo'), null, { timeout: 8000 });
  await app.wait(() => Array.isArray(U.pedalIr) && Array.isArray(U.pedalNam), null, { timeout: 20000 });
  await page.waitForTimeout(300);
  return Date.now() - t0;                                             /* durée de la synchro (clic -> liste lue) */
}
const noErrors = app => assert.deepEqual(app.errors, [], 'erreurs JavaScript dans l\'app');

test('connexion USB : INFO, liste et preset courant de la pédale affichés dans l\'app', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal);
  try {
    await app.page.waitForTimeout(1000);                              /* l'app démarre connectée à la pédale simulée */
    const ms = await connectUsb(app);
    assert.ok(ms < 3000, 'synchro USB lente après la démo : ' + ms + ' ms');
    const info = await pedal.info();
    const st = await app.run(() => ({ fw: U.info.fw, cur: S.cur, name: P().name, label: document.querySelector('#connLabel').textContent, presets: S.presets.map(p => p.name), empty: [...U.empty] }));
    assert.equal(st.fw, info.fw);
    assert.equal(st.cur, info.curIndex);
    assert.equal(st.name, info.curPreset.slice(0, 20));
    assert.match(st.label, /BlackBox Custom/);
    const l = await list(pedal);
    l.presets.forEach((n, i) => { if (n) assert.equal(st.presets[i], n.slice(0, 20), 'nom du preset ' + i); else assert.ok(st.empty.includes(i), 'emplacement vide ' + i); });
    assert.equal(await app.page.locator('#pcName').inputValue(), st.name, 'nom du preset dans la barre du haut');
    assert.deepEqual(await app.errToasts(), [], 'messages d\'erreur affichés');
    noErrors(app);
  } finally { await app.close(); await pedal.close(); }
});

test('changer de preset dans l\'app : la pédale charge le preset, l\'app affiche son état réel', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal);
  try {
    await connectUsb(app);
    const before = await app.run(() => S.cur);
    await app.page.click('#nextPreset');
    await app.wait(b => S.cur === b + 1 && U.dirty.size === 0, before, { timeout: 5000 });
    await app.page.waitForTimeout(300);
    const info = await pedal.info();
    assert.equal(info.curIndex, before + 1, 'la pédale n\'a pas changé de preset');
    const appName = await app.run(() => P().name);
    assert.equal(appName, info.curPreset.slice(0, 20));
    noErrors(app);
  } finally { await app.close(); await pedal.close(); }
});

test('modifier puis sauver depuis l\'app : la pédale garde le réglage après redémarrage', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal);
  try {
    await connectUsb(app);
    /* renommer et modifier le 1er paramètre du 1er bloc, comme le ferait l'utilisateur dans l'éditeur */
    const target = await app.run(() => {
      const { b, lane, col } = blocks()[0], pd = MODEL[b.model].params.find(x => x.type !== 'bool' && x.type !== 'select' && x.type !== 'nam' && x.type !== 'ir');
      const v = +(pd.min + (pd.max - pd.min) * 0.37).toFixed(2);
      setPresetField('name', 'E2E sauvegarde');
      setParam(b.uid, pd.id, v);
      return { lane, col, idx: MODEL[b.model].params.indexOf(pd), v, cur: S.cur };
    });
    await app.page.waitForTimeout(400);
    await app.page.click('#btnSave');
    await app.wait(() => U.dirty.size === 0, null, { timeout: 6000 });
    await pedalFlash(pedal, async q => {
      const l = await list(q);
      assert.equal(l.presets[target.cur], 'E2E sauvegarde');
      const s = await slotGet(q, target.cur);
      const row = s.scenes[s.scene].b.find(r => r[0] === target.lane && r[1] === target.col);
      assert.ok(Math.abs(row[3 + target.idx] - target.v) < 0.02, `paramètre sauvé ${row[3 + target.idx]} au lieu de ${target.v}`);
    });
    noErrors(app);
  } finally { await app.close(); await pedal.close(); }
});

/* format tbbr-preset v2 (0.9.6-beta.3) : le preset emporte ses captures NAM et ses IR */
test('grille : parallèle seulement en face d\'un bloc de A (pas de + ni de dépôt ailleurs), le bloc de B remonte si A est supprimé', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal);
  try {
    await connectUsb(app);
    const r = await app.run(() => {
      setView('grid');
      for (let l = 1; l >= 0; l--) for (let c = 0; c < COLS; c++) removeBlock(l, c);
      addBlock(0, 0, 'gate'); addBlock(0, 1, 'brit');
      const out = {};
      out.orphanAdd = addBlock(1, 2, 'chorus');                          /* rien en face : refusé */
      out.offSlot = document.querySelector('#chain .slot[data-lane="1"][data-col="2"]').className;
      out.offPlus = !!document.querySelector('#chain .slot[data-lane="1"][data-col="2"] .plus');
      out.okPlus = !!document.querySelector('#chain .slot[data-lane="1"][data-col="1"] .plus');
      out.parAdd = addBlock(1, 1, 'chorus');
      moveBlock(1, 1, 1, 3);                                              /* déplacer en face d'une case vide : refusé */
      out.afterMove = P().lanes.map(row => row.map(b => b && b.model));
      removeBlock(0, 1);                                                  /* le chorus n'a plus rien en face : il remonte */
      out.afterRemove = P().lanes.map(row => row.map(b => b && b.model));
      return out;
    });
    assert.equal(r.orphanAdd, false, 'bloc posé en B en face d\'une case vide');
    assert.match(r.offSlot, /\boff\b/); assert.equal(r.offPlus, false, '+ affiché en B sans bloc en face'); assert.equal(r.okPlus, true);
    assert.equal(r.parAdd, true);
    assert.equal(r.afterMove[1][1], 'chorus', 'déplacement en B en face d\'une case vide accepté');
    assert.equal(r.afterRemove[0][1], 'chorus'); assert.equal(r.afterRemove[1][1], null);
    await app.page.waitForTimeout(600);
    const s = await pedal.json(CMD.PRESET_GET, [0x7F], CMD.PRESET_GET, 0x7F);
    assert.deepEqual(s.lanes, r.afterRemove, 'la pédale ne joue pas la même grille que l\'app');
    noErrors(app);
  } finally { await app.close(); await pedal.close(); }
});

async function makeAssetPreset(app) {
  return app.run(async () => {
    const w = Float32Array.from({ length: 1871 }, (_, i) => Math.sin(i * 0.37) * 0.1);
    const id = uid();
    await idb.put(id, { cfg: new Uint8Array(0), weights: w });
    S.nams[2] = { name: 'E2E Capture', file: 'e2e.nam', arch: 'WaveNet', a2: true, sr: 48000, nWeights: 1871, bytes: w.length * 4, meta: {}, added: Date.now(), onDevice: false, id };
    const ir = Float32Array.from({ length: 2048 }, (_, i) => Math.exp(-i / 180) * Math.cos(i * 0.31) * 0.9);
    S.irs[4] = { name: 'E2E IR', user: true, rate: 48000, len: 2048, srcLen: 2048, srcRate: 48000, data: f2b(ir) };
    U.irCache.delete(4);
    const p = initPreset();
    p.name = 'E2E Assets';
    p.lanes[0] = [null, null, null, null, null, null, null, null];
    const bn = { uid: uid(), model: 'nam' }, bi = { uid: uid(), model: 'ir' };
    p.lanes[0][1] = bn; p.lanes[0][2] = bi;
    p.scenes.forEach(s => { s.state = { [bn.uid]: { on: true, p: { ...defaultParams('nam'), slot: 2 } }, [bi.uid]: { on: true, p: { ...defaultParams('ir'), slot: 4 } } }; });
    replacePreset(p);
    persist();
    return S.cur;
  });
}

test('export d\'un preset avec NAM + IR, puis import sur une autre installation : slots remappés et envoyés à la pédale', async () => {
  /* 1) installation A : construit le preset, l'exporte */
  const pedalA = new Pedal(), appA = await openApp(browser, srv.url, pedalA);
  let file;
  try {
    await connectUsb(appA);
    await makeAssetPreset(appA);
    /* le fichier produit par l'app est intercepté à la sortie de download() (même contenu que le fichier téléchargé) */
    const out = await appA.run(async () => {
      let got = null;
      const real = download;
      download = (name, data) => { got = { name, data }; };
      try { await presetAction('export'); } finally { download = real; }
      return got;
    });
    assert.ok(out, 'aucun fichier exporté');
    assert.match(out.name, /\.tbbr\.json$/);
    file = path.join(tmp, 'export.tbbr.json');
    fs.writeFileSync(file, out.data);
    noErrors(appA);
  } finally { await appA.close(); await pedalA.close(); }
  const doc = JSON.parse(fs.readFileSync(file, 'utf8'));
  assert.equal(doc.format, 'tbbr-preset'); assert.equal(doc.version, 2);
  assert.ok(doc.assets.nam['2'] && doc.assets.nam['2'].weights, 'capture NAM absente du fichier');
  assert.ok(doc.assets.ir['4'] && doc.assets.ir['4'].data, 'IR absente du fichier');

  /* 2) installation B : pédale dont les slots NAM 2 et IR 4 sont déjà pris par autre chose */
  const pedalB = new Pedal();
  const occupy = async () => {
    await pedalB.info();
    assert.equal(await pedalB.cmd(CMD.IR_BEGIN, { slot: 4, name: 'Autre IR', len: 2048, rate: 48000 }), true);
    for (let k = 0; k < 9; k++) pedalB.send(CMD.IR_CHUNK, Buffer.concat([Buffer.from([4, k, 0]), Buffer.alloc(Math.min(480, 4096 - k * 480), 0x11)]));
    assert.equal(await pedalB.cmd(CMD.IR_END, [4]), true);
    const blob = Buffer.alloc(7484, 0x22), crc = require('node:zlib').crc32(blob) >>> 0;
    assert.equal(await pedalB.cmd(CMD.NAM_BEGIN, { slot: 2, name: 'Autre NAM', a2: true, sr: 48000, nWeights: 1871, size: 7484, crc }), true);
    for (let i = 0, k = 0; i < blob.length; i += 480, k++) pedalB.send(CMD.NAM_CHUNK, Buffer.concat([Buffer.from([2, k, 0]), blob.subarray(i, i + 480)]));
    const e = Buffer.alloc(5); e[0] = 2; e.writeUInt32LE(crc, 1);
    assert.equal(await pedalB.cmd(CMD.NAM_END, e), true);
    pedalB.clear();
  };
  await occupy();
  const appB = await openApp(browser, srv.url, pedalB);
  try {
    await connectUsb(appB);
    const fc = appB.page.waitForEvent('filechooser');
    const done = appB.run(() => presetAction('import'));
    await (await fc).setFiles(file);
    await confirmModal(appB.page, 'primary');                         /* « Importer « E2E Assets » ? » */
    await done;
    await appB.wait(() => P().name === 'E2E Assets', null, { timeout: 15000 });
    await appB.page.waitForTimeout(500);
    const st = await appB.run(() => {
      const b = blocks(), n = b.find(x => x.b.model === 'nam'), i = b.find(x => x.b.model === 'ir');
      return { nam: P().scenes.map(s => s.state[n.b.uid].p.slot), ir: P().scenes.map(s => s.state[i.b.uid].p.slot), pedalNam: U.pedalNam, pedalIr: U.pedalIr };
    });
    const ns = st.nam[0], is = st.ir[0];
    assert.ok(st.nam.every(v => v === ns) && st.ir.every(v => v === is), 'remappage différent selon les scènes');
    assert.notEqual(ns, 2, 'NAM importée par-dessus le slot occupé'); assert.notEqual(is, 4, 'IR importée par-dessus le slot occupé');
    const l = await list(pedalB);
    assert.equal(l.nam[2], 'Autre NAM', 'capture existante de la pédale écrasée');
    assert.equal(l.ir[4], 'Autre IR', 'IR existante de la pédale écrasée');
    assert.equal(l.nam[ns], 'E2E Capture', 'capture importée absente de la pédale');
    assert.equal(l.ir[is], 'E2E IR', 'IR importée absente de la pédale');
    const cur = await pedalB.json(CMD.PRESET_GET, [0x7F], CMD.PRESET_GET, 0x7F);
    assert.ok(cur.lanes[0].includes('nam') && cur.lanes[0].includes('ir'), 'la pédale ne joue pas le preset importé');
    const row = m => cur.scenes[0].b.find(r => cur.lanes[r[0]][r[1]] === m);
    assert.equal(row('nam')[3], ns, 'la pédale joue la NAM du mauvais slot');
    assert.equal(row('ir')[3], is, 'la pédale joue l\'IR du mauvais slot');
    noErrors(appB);
  } finally { await appB.close(); await pedalB.close(); }
});

test('réinitialisation usine depuis l\'app : pédale et app remises à zéro', async () => {
  const pedal = new Pedal(), app = await openApp(browser, srv.url, pedal);
  try {
    await connectUsb(app);
    await app.run(() => { setPresetField('name', 'A effacer'); });
    await app.page.waitForTimeout(300);
    await app.page.click('#btnSave');
    await app.wait(() => U.dirty.size === 0, null, { timeout: 6000 });
    const before = await list(pedal);
    const done = app.run(() => factoryReset());
    await confirmModal(app.page, 'danger');
    await done;
    await app.wait(() => U.info && P().name !== 'A effacer', null, { timeout: 15000 });
    await pedalFlash(pedal, async q => {
      const l = await list(q);
      assert.ok(!l.presets.includes('A effacer'), 'preset utilisateur encore dans la flash');
      assert.equal(l.presets.filter(Boolean).length, before.presets.filter(Boolean).length, 'banque d\'usine incomplète');
    });
    noErrors(app);
  } finally { await app.close(); await pedal.close(); }
});

test('mode démo (sans pédale) : connexion, changement de preset, accordeur, sans erreur', async () => {
  const app = await openApp(browser, srv.url, null);
  try {
    await app.page.click('#btnConnect');
    await app.page.locator('.conn-card:has(use[href="#i-demo"])').click();
    await app.wait(() => U.info && U.tx && U.tx.kind === 'demo', null, { timeout: 5000 });
    const c0 = await app.run(() => S.cur);
    await app.page.click('#nextPreset');
    await app.wait(c => S.cur === c + 1, c0);
    await app.page.click('#btnTuner');
    await app.page.waitForTimeout(800);
    assert.ok(await app.run(() => !!U.tuner), 'accordeur non ouvert');
    await app.page.keyboard.press('Escape');
    await app.page.waitForTimeout(17000);                             /* délais des requêtes vers la pédale (4 x 4 s) écoulés */
    assert.deepEqual(await app.errToasts(), [], 'messages d\'erreur en mode démo');
    noErrors(app);
  } finally { await app.close(); }
});
