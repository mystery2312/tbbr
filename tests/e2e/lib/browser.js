/* browser.js : instrumentation commune des tests « utilisateur » (navigateur, app de bureau Electron, couche web de l'APK).
 * - app.js est une IIFE : la copie SERVIE aux tests reçoit une ligne en fin d'IIFE (window.__t = src => eval(src)) pour lire
 *   son état ; le fichier n'est pas modifié (interception réseau Playwright) ;
 * - USB MIDI : soit un WebMIDI simulé (port « BlackBox Custom »), soit le pont natif Android simulé (window.TBBRMidi),
 *   reliés à l'émulateur de pédale (vrai code du firmware) ;
 * - journal des messages affichés (toasts) et des erreurs JavaScript. */
'use strict';
const http = require('node:http');
const fs = require('node:fs');
const path = require('node:path');
const { chromium } = require('playwright-core');
const { APP } = require('./appcode');

const TYPES = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.css': 'text/css; charset=utf-8',
  '.svg': 'image/svg+xml', '.json': 'application/json', '.webmanifest': 'application/manifest+json', '.png': 'image/png', '.webp': 'image/webp',
  '.woff2': 'font/woff2', '.ttf': 'font/ttf' };

function serve(root = APP) {
  return new Promise(res => {
    const srv = http.createServer((req, rsp) => {
      const u = decodeURIComponent(new URL(req.url, 'http://x').pathname);
      const f = path.normalize(path.join(root, u === '/' ? 'index.html' : u));
      if (!f.startsWith(path.normalize(root)) || !fs.existsSync(f) || fs.statSync(f).isDirectory()) { rsp.writeHead(404); rsp.end(); return; }
      rsp.writeHead(200, { 'Content-Type': TYPES[path.extname(f)] || 'application/octet-stream', 'Cache-Control': 'no-store' });
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

/* ----- scripts injectés avant le chargement de l'app ----- */
const TOASTS = () => {
  window.__toasts = [];
  document.addEventListener('DOMContentLoaded', () => {
    const root = document.querySelector('#toasts');
    if (root) new MutationObserver(ms => ms.forEach(m => m.addedNodes.forEach(n => n.nodeType === 1 &&
      window.__toasts.push({ t: Math.round(performance.now()), err: n.classList.contains('err'), text: n.textContent })))).observe(root, { childList: true });
  });
};
/* WebMIDI simulé (navigateur, app de bureau) */
const FAKE_WEBMIDI = () => {
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
};
/* Pont natif Android simulé : mêmes méthodes et mêmes rappels que MidiBridge.java / MainActivity.AppBridge
   (list() JSON, open() asynchrone -> __tbbrMidi.opened, send(id, base64), messages entrants complets en base64). */
const FAKE_ANDROID = () => {
  const b64 = a => { let s = ''; for (let i = 0; i < a.length; i++) s += String.fromCharCode(a[i] & 255); return btoa(s); };
  const unb64 = s => { const t = atob(s), u = new Uint8Array(t.length); for (let i = 0; i < t.length; i++) u[i] = t.charCodeAt(i); return u; };
  const st = window.__android = { plugged: true, opened: new Set(), saved: [], external: [], updateChecks: 0, version: '9.9.9-test' };
  const later = f => setTimeout(f, 5);                                  /* MidiBridge répond par evaluateJavascript (asynchrone) */
  window.TBBRMidi = {
    list() {
      return JSON.stringify(st.plugged ? [{ id: 'in:7:0', name: 'BlackBox Custom', type: 'input', manufacturer: 'M-VAVE' },
                                         { id: 'out:7:0', name: 'BlackBox Custom', type: 'output', manufacturer: 'M-VAVE' }] : []);
    },
    open(id) { later(() => { const ok = st.plugged; if (ok) st.opened.add(id); window.__tbbrMidi.opened(id, ok); }); },
    close(id) { st.opened.delete(id); },
    send(id, data) { if (!st.plugged || !st.opened.has(id)) return false; window.__e2eMidiOut(Array.from(unb64(data))); return true; },
  };
  window.TBBRAndroid = {
    openExternal(u) { st.external.push(u); },
    version() { return st.version; },
    checkUpdate() { st.updateChecks++; },
    saveFile(name, data, mime) { st.saved.push({ name, data, mime }); return 'Téléchargements/TBBR/' + name; },
  };
  window.__e2eMidiIn = bytes => { if (st.plugged && st.opened.has('in:7:0')) later(() => window.__tbbrMidi.message('in:7:0', b64(bytes))); };
  window.__e2eUnplug = () => { st.plugged = false; st.opened.clear(); window.__tbbrMidi.changed(); };
  window.__e2ePlug = () => { st.plugged = true; window.__tbbrMidi.changed(); };
};

/* instrumente un contexte + sa page ; pedal = Pedal (ou null) ; bridge = 'webmidi' | 'android' | null (rien : vrai matériel) */
async function instrument(ctx, page, pedal, { bridge = 'webmidi', base, routes = true } = {}) {
  const errors = [], logs = [], tx = [];
  if (base && routes) await ctx.route('**/*', r => (r.request().url().startsWith(base) ? r.fallback() : r.abort()).catch(() => {}));   /* aucun accès extérieur */
  if (routes) await ctx.route(/\/js\/app\.js(\?.*)?$/, async r => {
    try {
      const resp = await r.fetch(), src = await resp.text(), k = src.lastIndexOf('})();');
      if (k < 0) throw new Error('fin de l\'IIFE d\'app.js introuvable');
      await r.fulfill({ response: resp, body: src.slice(0, k) + 'window.__t = src => eval(src);\n' + src.slice(k) });
    } catch (e) { await r.abort().catch(() => {}); }
  });
  page.on('pageerror', e => errors.push('pageerror: ' + e.message));
  page.on('console', m => { logs.push(m.type() + ': ' + m.text()); if (m.type() === 'error' && !/Failed to load resource|ERR_FAILED|net::/.test(m.text())) errors.push('console: ' + m.text()); });
  await ctx.exposeFunction('__e2eMidiOut', arr => { tx.push(arr); if (pedal) pedal.sysex(Buffer.from(arr)); });
  await ctx.addInitScript(TOASTS);
  if (bridge === 'webmidi') await ctx.addInitScript(FAKE_WEBMIDI);
  if (bridge === 'android') await ctx.addInitScript(FAKE_ANDROID);
  let chain = Promise.resolve(), closed = false;
  const off = pedal ? pedal.onSysex(sx => { const b = [...sx]; if (!closed) chain = chain.then(() => page.evaluate(x => window.__e2eMidiIn && window.__e2eMidiIn(x), b).catch(() => {})); }) : () => {};
  const run = (fn, arg) => page.evaluate(([src, a]) => window.__t('(' + src + ')')(a), [fn.toString(), arg]);
  const wait = (fn, arg, o = 8000) => page.waitForFunction(([src, a]) => window.__t && window.__t('(' + src + ')')(a), [fn.toString(), arg],
    { timeout: typeof o === 'number' ? o : (o && o.timeout) || 8000 });
  return {
    page, ctx, errors, logs, tx, run, wait,
    ready: () => page.waitForFunction(() => typeof window.__t === 'function' && document.querySelector('#btnConnect'), null, { timeout: 15000 }),
    toasts: () => page.evaluate(() => window.__toasts.slice()),
    errToasts: () => page.evaluate(() => window.__toasts.filter(t => t.err).map(t => t.text)),
    flush: () => chain,
    detach() { closed = true; off(); return chain; },
  };
}

/* l'app web dans Edge headless ; root = dossier servi (interface/app par défaut, ou les assets extraits de l'APK) */
async function openApp(browser, base, pedal, { lang = 'fr', bridge = 'webmidi', viewport = { width: 1440, height: 900 }, mobile = false } = {}) {
  const ctx = await browser.newContext({ acceptDownloads: true, viewport, isMobile: mobile, hasTouch: mobile, locale: lang === 'fr' ? 'fr-FR' : 'en-US' });
  const page = await ctx.newPage();
  const a = await instrument(ctx, page, pedal, { bridge, base });
  await page.goto(base);
  await a.ready();
  return { ...a, async close() { await a.detach(); await page.goto('about:blank').catch(() => {}); await ctx.close(); } };
}

/* cliquer le bouton d'action d'une fenêtre modale (dernière ouverte) ; kind = 'danger' | 'primary' */
async function confirmModal(page, kind) {
  const btn = page.locator(`#modalRoot .modal-bg:last-child .modal-f .btn${kind ? '.' + kind : ':not(.ghost)'}`).last();
  await btn.waitFor({ state: 'visible', timeout: 5000 });
  await btn.click();
}

module.exports = { serve, launch, openApp, instrument, confirmModal, FAKE_WEBMIDI, FAKE_ANDROID };
