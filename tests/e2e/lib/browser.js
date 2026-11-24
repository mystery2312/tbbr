/* browser.js : l'app réelle (interface/app) dans Edge headless, avec un WebMIDI simulé relié à l'émulateur de pédale.
 * Le port MIDI s'appelle « BlackBox Custom » comme sur la vraie pédale ; l'app passe donc par MidiTransport, sans modification. */
'use strict';
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright-core');
const { APP } = require('./appcode');

const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.svg': 'image/svg+xml', '.json': 'application/json', '.webmanifest': 'application/manifest+json', '.png': 'image/png', '.webp': 'image/webp' };

function serve(root = APP) {
  return new Promise(res => {
    const srv = http.createServer((req, rsp) => {
      const u = decodeURIComponent(new URL(req.url, 'http://x').pathname);
      const f = path.normalize(path.join(root, u === '/' ? 'index.html' : u));
      if (!f.startsWith(root) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { rsp.writeHead(404); rsp.end(); return; }
      rsp.writeHead(200, { 'Content-Type': TYPES[path.extname(f)] || 'application/octet-stream', 'Cache-Control': 'no-store' });
      if (/[\\/]js[\\/]app\.js$/.test(f)) {
        /* app.js est une IIFE : la copie servie aux tests expose un accès à sa portée (eval direct), le fichier n'est pas modifié */
        const src = fs.readFileSync(f, 'utf8'), k = src.lastIndexOf('})();');
        if (k < 0) throw new Error('fin de l\'IIFE d\'app.js introuvable');
        rsp.end(src.slice(0, k) + 'window.__t = src => eval(src);\n' + src.slice(k));
        return;
      }
      fs.createReadStream(f).pipe(rsp);
    });
    srv.listen(0, '127.0.0.1', () => res({ url: 'http://127.0.0.1:' + srv.address().port + '/', close: () => new Promise(r => srv.close(r)) }));
  });
}

async function launch() {
  const opts = { headless: process.env.E2E_HEADED ? false : true };
  try { return await chromium.launch({ ...opts, channel: 'msedge' }); }
  catch (e) { return chromium.launch({ ...opts, channel: 'chrome' }); }
}

/* WebMIDI simulé : injecté avant le chargement de l'app */
const FAKE_MIDI = () => {
  const mk = (type, extra) => Object.assign({ id: type, name: 'BlackBox Custom', manufacturer: 'e2e', type, state: 'connected', connection: 'closed',
    async open() { this.connection = 'open'; return this; }, async close() { this.connection = 'closed'; return this; } }, extra);
  const input = mk('input', { onmidimessage: null, _l: [], addEventListener(t, f) { if (t === 'midimessage') this._l.push(f); } });
  const output = mk('output', { send(d) { window.__e2eMidiOut(Array.from(d)); } });
  window.__e2eMidiIn = bytes => {
    const ev = { data: new Uint8Array(bytes), timeStamp: performance.now() };
    if (input.onmidimessage) input.onmidimessage(ev);
    input._l.forEach(f => f(ev));
  };
  const access = { inputs: new Map([['in', input]]), outputs: new Map([['out', output]]), sysexEnabled: true, onstatechange: null };
  Object.defineProperty(Navigator.prototype, 'requestMIDIAccess', { configurable: true, value: async () => access });
  /* journal des messages (toasts) affichés à l'utilisateur */
  window.__toasts = [];
  document.addEventListener('DOMContentLoaded', () => {
    const root = document.querySelector('#toasts');
    if (root) new MutationObserver(ms => ms.forEach(m => m.addedNodes.forEach(n => n.nodeType === 1 &&
      window.__toasts.push({ t: Math.round(performance.now()), err: n.classList.contains('err'), text: n.textContent })))).observe(root, { childList: true });
  });
};

/* ouvre l'app ; pedal = instance de Pedal (ou null : pas de pédale, mode démo seulement) */
async function openApp(browser, base, pedal, { lang = 'fr' } = {}) {
  const ctx = await browser.newContext({ acceptDownloads: true, viewport: { width: 1440, height: 900 }, locale: lang === 'fr' ? 'fr-FR' : 'en-US' });
  await ctx.route('**/*', r => (r.request().url().startsWith(base) ? r.continue() : r.abort()).catch(() => {}));   /* aucun accès réseau extérieur (polices, GitHub) */
  const page = await ctx.newPage();
  const errors = [], logs = [];
  page.on('pageerror', e => errors.push('pageerror: ' + e.message));
  page.on('console', m => { logs.push(m.type() + ': ' + m.text()); if (m.type() === 'error' && !/Failed to load resource|ERR_FAILED|net::/.test(m.text())) errors.push('console: ' + m.text()); });
  const tx = [];
  await page.exposeFunction('__e2eMidiOut', arr => { tx.push(arr); if (pedal) pedal.sysex(Buffer.from(arr)); });
  await page.addInitScript(FAKE_MIDI);
  let chain = Promise.resolve();
  const off = pedal ? pedal.onSysex(sx => { const b = [...sx]; chain = chain.then(() => page.evaluate(x => window.__e2eMidiIn(x), b).catch(() => {})); }) : () => {};
  await page.goto(base);
  await page.waitForFunction(() => typeof window.__t === 'function' && document.querySelector('#btnConnect'));
  /* run(fn, arg) : exécute fn dans la portée de l'app (S, U, P, connect…) ; wait(fn, arg) : attend que fn soit vraie */
  const run = (fn, arg) => page.evaluate(([src, a]) => window.__t('(' + src + ')')(a), [fn.toString(), arg]);
  const wait = (fn, arg, o = 8000) => page.waitForFunction(([src, a]) => window.__t('(' + src + ')')(a), [fn.toString(), arg],
    { timeout: typeof o === 'number' ? o : (o && o.timeout) || 8000 });
  return {
    page, ctx, errors, logs, tx, run, wait,
    toasts: () => page.evaluate(() => window.__toasts.slice()),
    errToasts: () => page.evaluate(() => window.__toasts.filter(t => t.err).map(t => t.text)),
    flush: () => chain,
    /* arrêter l'app (minuteries, MIDI) avant de fermer : sinon un appel de __e2eMidiOut en vol rejette après la fin du test */
    async close() { off(); await chain; await page.goto('about:blank').catch(() => {}); await ctx.close(); },
  };
}

/* cliquer le bouton d'action d'une fenêtre modale (dernière ouverte) ; kind = 'danger' | 'primary' */
async function confirmModal(page, kind) {
  const btn = page.locator(`#modalRoot .modal-bg:last-child .modal-f .btn${kind ? '.' + kind : ':not(.ghost)'}`).last();
  await btn.waitFor({ state: 'visible', timeout: 5000 });
  await btn.click();
}

module.exports = { serve, launch, openApp, confirmModal };
