/* installer.test.js : interface web de l'installateur (installer/resources/ui/index.html) dans Edge, avec un faux serveur
 * qui répond comme installer_gui.py. Avertissement obligatoire (alpha, USB stable, à ses risques et périls) avant toute
 * sauvegarde / installation / restauration. */
'use strict';
const test = require('node:test');
const assert = require('node:assert/strict');
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright-core');

const UI = path.join(__dirname, '..', '..', 'installer', 'resources', 'ui');

function fakeInstaller(lang) {
  const s = { consent: false, calls: [] };
  const state = () => ({ app: 'TBBR Installer', lang, busy: false, task: null, consent: s.consent, device: { kind: 'none' },
    embedded: { fw: 'TBBR fw6 0.13', builtin: 'TBBR fw6 0.13', pkg: null }, update: 'unknown',
    backup: { ok: true, dir: 'C:\\BlackBox Backup\\BlackBox_x', kind: 'mvave', sha: '4df47afe', date: '25/11/2026 14:54' },
    backupParent: 'C:\\BlackBox Backup', log: [], logN: 0 });
  s.srv = http.createServer((q, r) => {
    const u = new URL(q.url, 'http://x');
    if (u.pathname.startsWith('/api/')) {
      const p = u.pathname.slice(5).split('?')[0]; s.calls.push(p);
      if (p === 'accept_risks') s.consent = true;
      r.setHeader('Content-Type', 'application/json');
      return r.end(JSON.stringify(p === 'state' ? state() : { ok: true }));
    }
    const f = path.join(UI, u.pathname === '/' ? 'index.html' : u.pathname.slice(1));
    if (!f.startsWith(UI) || !fs.existsSync(f)) { r.statusCode = 404; return r.end(); }
    r.end(fs.readFileSync(f));
  });
  return new Promise(res => s.srv.listen(0, '127.0.0.1', () => res(s)));
}

for (const lang of ['fr', 'en']) {
  test(`installateur (${lang}) : avertissement obligatoire, bouton bloqué tant que la case n'est pas cochée`, async () => {
    const s = await fakeInstaller(lang), b = await chromium.launch({ channel: 'msedge' });
    try {
      const pg = await b.newPage({ viewport: { width: 1200, height: 900 } }), errs = [];
      pg.on('pageerror', e => errs.push(e.message));
      await pg.goto(`http://127.0.0.1:${s.srv.address().port}/?t=x`);
      await pg.waitForSelector('.modal.risk #riskGo');
      const txt = await pg.$eval('.modal.risk', e => e.textContent);
      for (const re of lang === 'fr' ? [/alpha/, /propres risques et périls/, /responsables/, /câble USB/, /N'éteins pas la pédale/, /Restaurer/]
        : [/alpha/, /own risk/, /liable/, /cable/, /Do not power the pedal off/, /Restore/]) assert.match(txt, re);
      assert.equal(await pg.$eval('#riskGo', e => e.disabled), true, 'bouton actif sans la case cochée');
      await pg.click('#riskGo', { force: true });
      assert.ok(!s.calls.includes('accept_risks'), 'accepté sans la case');
      await pg.click('#riskOk');
      await pg.click('#riskGo');
      await pg.waitForSelector('.modal.risk', { state: 'detached' });
      assert.ok(s.consent, 'accept_risks non envoyé');
      assert.deepEqual(errs, []);
    } finally { await b.close(); s.srv.close(); }
  });
}

test('installateur : le serveur refuse sauvegarde / installation / restauration sans avertissement accepté', () => {
  const src = fs.readFileSync(path.join(__dirname, '..', '..', 'installer', 'installer_gui.py'), 'utf8');
  assert.match(src, /if path in \("backup", "install", "restore"\) and not self\.consent:/);
  assert.match(src, /self\.auto_update and self\.consent and/, 'mise à jour automatique lancée sans avertissement');
  assert.match(src, /def accepted\(self\)/, 'interface classique sans avertissement');
});
