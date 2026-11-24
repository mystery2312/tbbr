/* desktop.js : lance la VRAIE app de bureau (electron/main.js + preload + updater, Electron du projet) pour les tests.
 * Profil isolé (TBBR_USER_DATA), port local dédié, faux GitHub (TBBR_UPDATE_API), exe portable factice
 * (PORTABLE_EXECUTABLE_FILE) : rien ne touche aux données ni à l'exe réels de l'utilisateur. */
'use strict';
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const net = require('node:net');
const { _electron } = require('playwright-core');
const { instrument } = require('./browser');

const ELECTRON_DIR = path.join(__dirname, '..', '..', '..', 'electron');

function electronExe() {
  const p = path.join(ELECTRON_DIR, 'node_modules', 'electron', 'path.txt');
  if (!fs.existsSync(p)) throw new Error('Electron absent : npm install dans electron\\');
  return path.join(ELECTRON_DIR, 'node_modules', 'electron', 'dist', fs.readFileSync(p, 'utf8').trim());
}
const freePort = () => new Promise(res => { const s = net.createServer(); s.listen(0, '127.0.0.1', () => { const p = s.address().port; s.close(() => res(p)); }); });

/* opts : pedal, api (faux GitHub), exePath (exe portable factice ; null = app non portable), userData, env */
async function launchDesktop({ pedal = null, api, exePath = null, userData, env = {} } = {}) {
  userData = userData || fs.mkdtempSync(path.join(os.tmpdir(), 'tbbr-desk-'));
  const port = await freePort();
  const e = { ...process.env, TBBR_USER_DATA: userData, TBBR_PORT: String(port), TBBR_UPDATE_DELAY_MS: '300', TBBR_E2E: '1',
    TBBR_UPDATE_API: api || 'http://127.0.0.1:9/', ...env };
  if (exePath) e.PORTABLE_EXECUTABLE_FILE = exePath; else delete e.PORTABLE_EXECUTABLE_FILE;
  const app = await _electron.launch({ executablePath: electronExe(), args: [ELECTRON_DIR], env: e, cwd: ELECTRON_DIR, timeout: 30000 });
  const page = await app.firstWindow();
  await page.waitForLoadState('load').catch(() => {});             /* recharger pendant le 1er chargement fige Electron */
  const ctx = app.context();
  /* app.js instrumentée par le serveur de main.js (TBBR_E2E=1, hors exe packagé) : l'interception de Playwright fige Electron */
  const a = await instrument(ctx, page, pedal, { bridge: 'webmidi', routes: false });
  await page.reload({ waitUntil: 'load' });                                               /* la 1re page s'est chargée avant l'instrumentation */
  await a.ready();
  let closed = false;
  app.on('close', () => { closed = true; });
  return {
    ...a, app, userData, port,
    isClosed: () => closed,
    async close() { await a.detach(); if (!closed) await app.close().catch(() => {}); },
  };
}

module.exports = { launchDesktop, electronExe };
