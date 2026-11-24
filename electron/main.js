/* BlackBox TBBR — application Electron.
 * Sert l'app web embarquée sur 127.0.0.1:8791 (origine stable pour localStorage/IndexedDB),
 * ouvre une fenêtre native, autorise WebMIDI/Web Bluetooth et lance l'installateur firmware.
 */
'use strict';

const { app, BrowserWindow, Menu, dialog, session, shell, ipcMain, net } = require('electron');
const fs = require('fs');
const http = require('http');
const path = require('path');
const { spawn } = require('child_process');

/* tests de bout en bout : profil isolé (jamais les presets / réglages de l'utilisateur) */
if (process.env.TBBR_USER_DATA) app.setPath('userData', process.env.TBBR_USER_DATA);
const PORT = Number(process.env.TBBR_PORT || 8791);
const E2E = process.env.TBBR_E2E === '1' && !app.isPackaged;
const BETA_CHANNEL = app.getVersion().includes('-beta');             // build beta : mises à jour depuis le dépôt beta
const REPO = BETA_CHANNEL ? 'mystery2312/tbbr-beta' : 'mystery2312/tbbr';
const RELEASES = BETA_CHANNEL ? `https://github.com/${REPO}/releases` : `https://github.com/${REPO}/releases/latest`;
const APP_ROOT = app.isPackaged
  ? path.join(process.resourcesPath, 'app')
  : path.join(__dirname, '..', 'interface', 'app');
const INSTALLER = path.join(APP_ROOT, 'BlackBox_TBBR_Installer.exe');
const LOG = () => {
  try { return path.join(app.getPath('userData'), 'electron.log'); } catch (e) { return path.join(__dirname, 'electron.log'); }
};
let win = null;
let server = null;

function log(s) {
  try {
    fs.mkdirSync(path.dirname(LOG()), { recursive: true });
    fs.appendFileSync(LOG(), new Date().toISOString() + ' ' + s + '\n');
  } catch (e) { /* ignore */ }
}

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.webmanifest': 'application/manifest+json; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.ico': 'image/x-icon',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2',
  '.ttf': 'font/ttf',
  '.exe': 'application/octet-stream',
  '.bin': 'application/octet-stream',
  '.txt': 'text/plain; charset=utf-8'
};

function startServer(port) {
  return new Promise((resolve, reject) => {
    server = http.createServer((req, res) => {
      try {
        let pathname = decodeURIComponent(new URL(req.url, 'http://127.0.0.1').pathname);
        if (pathname === '/') pathname = '/index.html';
        if (pathname.endsWith('.php')) pathname = pathname.slice(0, -4) + '.html';
        const root = path.resolve(APP_ROOT);
        const file = path.resolve(root, '.' + pathname);
        if (!file.startsWith(root + path.sep) && file !== root) {
          res.writeHead(403); res.end('Forbidden'); return;
        }
        fs.stat(file, (err, st) => {
          if (err || !st.isFile()) { res.writeHead(404); res.end('Not found'); return; }
          const ext = path.extname(file).toLowerCase();
          if (E2E && pathname === '/js/app.js') {
            /* tests de bout en bout (jamais dans l'exe livré : !app.isPackaged) : accès à la portée de l'IIFE d'app.js */
            const src = fs.readFileSync(file, 'utf8'), k = src.lastIndexOf('})();');
            res.writeHead(200, { 'Content-Type': MIME['.js'], 'Cache-Control': 'no-store' });
            res.end(src.slice(0, k) + 'window.__t = src => eval(src);\n' + src.slice(k));
            return;
          }
          res.writeHead(200, {
            'Content-Type': MIME[ext] || 'application/octet-stream',
            'Cache-Control': 'no-store, max-age=0',
            'Content-Length': st.size
          });
          fs.createReadStream(file).pipe(res);
        });
      } catch (e) {
        res.writeHead(400); res.end('Bad request');
      }
    });
    server.once('error', reject);
    server.listen(port, '127.0.0.1', () => resolve(`http://127.0.0.1:${port}/index.html`));
  });
}

function openInstaller() {
  if (!fs.existsSync(INSTALLER)) {
    dialog.showErrorBox('Installateur absent', 'BlackBox_TBBR_Installer.exe est introuvable dans :\n' + INSTALLER);
    return;
  }
  shell.openPath(INSTALLER).then(err => {
    if (err) dialog.showErrorBox('Impossible de lancer l’installateur', err);
  });
}

/* ---------------- mises à jour (GitHub Releases) ---------------- */
const verTuple = s => (String(s || '').match(/\d+/g) || []).map(Number);
function verGt(a, b) {
  const x = verTuple(a), y = verTuple(b);
  for (let i = 0; i < Math.max(x.length, y.length); i++) { const d = (x[i] || 0) - (y[i] || 0); if (d) return d > 0; }
  return false;
}
let relCache = null;
async function latestRelease() {
  if (relCache && Date.now() - relCache.t < 10 * 60 * 1000) return relCache.r;
  const headers = { 'Accept': 'application/vnd.github+json', 'User-Agent': 'TBBR-desktop' };
  let j;
  if (BETA_CHANNEL) {
    /* le dépôt beta ne contient que des pré-releases : /releases/latest les ignore */
    const res = await net.fetch(`https://api.github.com/repos/${REPO}/releases?per_page=20`, { headers });
    if (!res.ok) throw new Error('GitHub ' + res.status);
    const list = await res.json();
    j = list.find(x => !x.draft && (x.assets || []).some(a => /\.tbbr$/i.test(a.name)));
    if (!j) throw new Error('aucune beta publiée');
  } else {
    const res = await net.fetch(`https://api.github.com/repos/${REPO}/releases/latest`, { headers });
    if (!res.ok) throw new Error('GitHub ' + res.status);
    j = await res.json();
  }
  const assets = j.assets || [];
  const tbbr = assets.find(a => /\.tbbr$/i.test(a.name));
  const m = tbbr && tbbr.name.match(/TBBR_(fw\d+)_(\d+\.\d+)\.tbbr/i);
  const r = {
    tag: j.tag_name, page: j.html_url || RELEASES, beta: BETA_CHANNEL,
    fw: m ? `TBBR ${m[1]} ${m[2]}` : null, tbbrUrl: tbbr && tbbr.browser_download_url, tbbrName: tbbr && tbbr.name,
    appVersion: app.getVersion(), appNewer: compareVersions(j.tag_name, app.getVersion()) > 0,
  };
  relCache = { t: Date.now(), r };
  return r;
}
async function updatePedal() {
  const r = await latestRelease();
  if (!r.tbbrUrl) throw new Error('pas de paquet .tbbr dans la dernière version');
  if (!fs.existsSync(INSTALLER)) throw new Error('installateur absent : ' + INSTALLER);
  const res = await net.fetch(r.tbbrUrl, { headers: { 'User-Agent': 'TBBR-desktop' } });
  if (!res.ok) throw new Error('téléchargement ' + res.status);
  const dir = path.join(app.getPath('userData'), 'updates');
  fs.mkdirSync(dir, { recursive: true });
  const file = path.join(dir, path.basename(r.tbbrName));
  fs.writeFileSync(file, Buffer.from(await res.arrayBuffer()));
  log('paquet téléchargé : ' + file);
  // l'installateur vérifie le paquet (SHA-256, version) et lance la mise à jour dès que la pédale est détectée
  const p = spawn(INSTALLER, [file, '--update'], { detached: true, stdio: 'ignore' });
  p.unref();
  return { ok: true, fw: r.fw };
}
/* ---------------- mise à jour automatique de l'app (updater.js) ----------------
   Vérification au démarrage puis toutes les 6 h ; téléchargement en arrière-plan, vérifié (SHA-256 du manifeste) ;
   installée en un clic (« Redémarrer ») ou automatiquement à la fermeture de l'app. */
const { Updater, compareVersions } = require('./updater');
let updater = null;
const upd = { state: 'idle', version: null, progress: 0, error: null, page: null, canInstall: false };
function updState(patch) {
  Object.assign(upd, patch);
  if (win && !win.isDestroyed()) win.webContents.send('tbbr:app-update', { ...upd });
}
function makeUpdater() {
  const sources = [{ repo: 'mystery2312/tbbr', list: false }];
  if (BETA_CHANNEL) sources.push({ repo: 'mystery2312/tbbr-beta', list: true });   /* dépôt privé : souvent inaccessible, sans gravité */
  updater = new Updater({
    version: app.getVersion(), sources, fetch: (u, o) => net.fetch(u, o),
    dir: path.join(app.getPath('userData'), 'updates'),
    exePath: process.env.PORTABLE_EXECUTABLE_FILE || null,            /* posé par le lanceur portable d'electron-builder */
    apiBase: process.env.TBBR_UPDATE_API || 'https://api.github.com', /* tests : faux GitHub local */
    spawn, log: s => log('updater: ' + s),
  });
  updater.cleanup();
  upd.canInstall = updater.canReplace();
  const p = updater.pending();
  if (p) Object.assign(upd, { state: 'ready', version: p.version, progress: 1 });
}
let updBusy = false;
async function appUpdateCheck() {
  if (!updater || updBusy || upd.state === 'ready') return { ...upd };
  updBusy = true;
  try {
    updState({ state: 'checking', error: null });
    const r = await updater.check();
    if (!r.available) { updState({ state: 'none', version: r.version || null }); return { ...upd }; }
    updState({ state: upd.canInstall ? 'downloading' : 'available', version: r.version, page: r.page, progress: 0 });
    if (!upd.canInstall) return { ...upd };
    let last = 0;
    const file = await updater.download(r, f => { if (f - last >= 0.02 || f === 1) { last = f; updState({ progress: f }); } });
    updater.stage(r, file);
    log('mise à jour ' + r.version + ' prête : ' + file);
    updState({ state: 'ready', progress: 1 });
  } catch (e) {
    log('updater: ' + (e && e.stack || e));
    updState({ state: 'error', error: String(e.message || e) });
  } finally { updBusy = false; }
  return { ...upd };
}
function appUpdateInstall() {
  const r = updater ? updater.apply({ relaunch: true }) : { ok: false, reason: 'indisponible' };
  if (r.ok) { appliedOnQuit = true; setImmediate(() => app.quit()); }
  return r;
}
let appliedOnQuit = false;

function setupIpc() {
  ipcMain.handle('tbbr:version', () => app.getVersion());
  ipcMain.handle('tbbr:app-update-state', () => ({ ...upd }));
  ipcMain.handle('tbbr:app-update-check', () => appUpdateCheck());
  ipcMain.handle('tbbr:app-update-install', () => appUpdateInstall());
  ipcMain.handle('tbbr:check', async () => {
    try {
      const r = await latestRelease();
      /* la mise à jour de l'app est gérée ici (updater) : la page ne propose plus de téléchargement manuel si elle est installable */
      if (upd.canInstall) r.appNewer = false;
      else if (upd.version) r.appNewer = compareVersions(upd.version, app.getVersion()) > 0;
      return r;
    } catch (e) { log('check: ' + e); return { error: String(e.message || e) }; }
  });
  ipcMain.handle('tbbr:update-pedal', async () => { try { return await updatePedal(); } catch (e) { log('update: ' + e); return { error: String(e.message || e) }; } });
  ipcMain.handle('tbbr:installer', () => { openInstaller(); return true; });
  ipcMain.handle('tbbr:release-page', () => { shell.openExternal(RELEASES); return true; });
}

function createWindow(url) {
  win = new BrowserWindow({
    width: 1280,
    height: 880,
    minWidth: 980,
    minHeight: 640,
    title: 'BlackBox TBBR',
    icon: path.join(__dirname, 'build', 'icon.png'),
    backgroundColor: '#0a0b0d',
    autoHideMenuBar: true,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: false,
      spellcheck: false,
      preload: path.join(__dirname, 'preload.js')
    }
  });

  win.setMenuBarVisibility(false);
  win.loadURL(url);
  // Pas de menu natif : on garde juste les raccourcis utiles.
  win.webContents.on('before-input-event', (event, input) => {
    const k = String(input.key || '').toLowerCase();
    if (k === 'f12' || (input.control && input.shift && k === 'i')) {
      win.webContents.toggleDevTools();
      event.preventDefault();
    } else if (input.control && k === 'r') {
      win.webContents.reload();
      event.preventDefault();
    }
  });
  win.webContents.setWindowOpenHandler(({ url: u }) => {
    if (u.startsWith(`http://127.0.0.1:${PORT}/`)) {
      return {
        action: 'allow',
        overrideBrowserWindowOptions: {
          width: 640, height: 820, autoHideMenuBar: true,
          webPreferences: { contextIsolation: true, nodeIntegration: false, sandbox: false }
        }
      };
    }
    shell.openExternal(u);
    return { action: 'deny' };
  });
  win.webContents.on('will-navigate', (e, u) => {
    if (!u.startsWith(`http://127.0.0.1:${PORT}/`)) {
      e.preventDefault();
      shell.openExternal(u);
    }
  });

  // Web Bluetooth : l'app demande un appareil ; on choisit la BlackBox si elle est là.
  win.webContents.on('select-bluetooth-device', (event, devices, callback) => {
    event.preventDefault();
    const dev = devices.find(d => /blackbox/i.test(d.deviceName || '')) || devices[0];
    log('Bluetooth devices: ' + JSON.stringify(devices.map(d => d.deviceName)));
    callback(dev ? dev.deviceId : '');
  });

  win.webContents.on('did-finish-load', async () => {
    try {
      const info = await win.webContents.executeJavaScript(
        "({midi: typeof navigator.requestMIDIAccess, bluetooth: typeof navigator.bluetooth, ua: navigator.userAgent})");
      log('loaded ' + JSON.stringify(info));
      // Diagnostic : vérifie que WebMIDI voit bien les ports de la pédale.
      const ports = await win.webContents.executeJavaScript(`(async()=>{
        try {
          const a = await navigator.requestMIDIAccess({sysex:true});
          return {inputs:[...a.inputs.values()].map(p=>p.name), outputs:[...a.outputs.values()].map(p=>p.name)};
        } catch (e) { return {error:String(e)}; }
      })()`);
      log('midi ports ' + JSON.stringify(ports));
    } catch (e) { log('executeJavaScript: ' + e); }
  });
  win.webContents.on('did-fail-load', (e, code, desc, u) => {
    log('did-fail-load ' + code + ' ' + desc + ' ' + u);
    dialog.showErrorBox('Chargement impossible', 'Impossible de charger l’interface :\n' + u + '\n\n' + desc);
  });
  win.on('closed', () => { win = null; });
}

function buildMenu() {
  const fr = String(app.getLocale()).toLowerCase().startsWith('fr');
  const T = (a, b) => (fr ? a : b);
  const template = [
    {
      label: T('Fichier', 'File'),
      submenu: [
        { label: T('Lancer l’installateur firmware…', 'Run firmware installer…'), click: openInstaller },
        { type: 'separator' },
        { role: 'quit', label: T('Quitter', 'Quit') }
      ]
    },
    {
      label: T('Édition', 'Edit'),
      submenu: [
        { role: 'undo', label: T('Annuler', 'Undo') },
        { role: 'redo', label: T('Rétablir', 'Redo') },
        { type: 'separator' },
        { role: 'cut', label: T('Couper', 'Cut') },
        { role: 'copy', label: T('Copier', 'Copy') },
        { role: 'paste', label: T('Coller', 'Paste') },
        { role: 'selectAll', label: T('Tout sélectionner', 'Select all') }
      ]
    },
    {
      label: T('Affichage', 'View'),
      submenu: [
        { role: 'reload', label: T('Recharger', 'Reload') },
        { role: 'toggleDevTools', label: T('Outils de développement', 'Developer tools') },
        { type: 'separator' },
        { role: 'resetZoom', label: T('Taille normale', 'Actual size') },
        { role: 'zoomIn', label: T('Agrandir', 'Zoom in') },
        { role: 'zoomOut', label: T('Réduire', 'Zoom out') },
        { type: 'separator' },
        { role: 'togglefullscreen', label: T('Plein écran', 'Full screen') }
      ]
    },
    {
      label: T('Aide', 'Help'),
      submenu: [
        { label: T('Ouvrir le dossier de l’app', 'Open app folder'), click: () => shell.openPath(APP_ROOT) },
        { label: T('Journal Electron', 'Electron log'), click: () => shell.openPath(LOG()) },
        {
          label: T('À propos', 'About'),
          click: () => dialog.showMessageBox(win, {
            type: 'info', title: 'BlackBox TBBR',
            message: 'BlackBox TBBR — application de bureau',
            detail: 'Version ' + app.getVersion() + '\nInterface web embarquée, WebMIDI et installateur firmware.'
          })
        }
      ]
    }
  ];
  Menu.setApplicationMenu(Menu.buildFromTemplate(template));
}

async function main() {
  const lock = app.requestSingleInstanceLock();
  if (!lock) { app.quit(); return; }
  app.on('second-instance', () => {
    if (win) { if (win.isMinimized()) win.restore(); win.focus(); }
  });

  await app.whenReady();
  app.setAppUserModelId('com.tbbr.blackbox');

  // WebMIDI (le firmware maison utilise des SysEx) + Bluetooth + plein écran.
  const allowed = new Set(['midi', 'midiSysex', 'media', 'fullscreen', 'notifications',
    'clipboard-read', 'clipboard-write', 'bluetooth']);
  session.defaultSession.setPermissionRequestHandler((wc, permission, callback) => {
    log('permission request: ' + permission);
    callback(allowed.has(permission));
  });
  session.defaultSession.setPermissionCheckHandler((wc, permission) => {
    return allowed.has(permission);
  });

  // Téléchargement de l'installateur : on l'enregistre puis on le lance.
  session.defaultSession.on('will-download', (event, item) => {
    if (path.basename(item.getFilename()) === 'BlackBox_TBBR_Installer.exe') {
      const dest = path.join(app.getPath('downloads'), 'BlackBox_TBBR_Installer.exe');
      item.setSavePath(dest);
      item.once('done', (e, state) => {
        log('installer download: ' + state + ' -> ' + dest);
        if (state === 'completed') shell.openPath(dest);
      });
    }
  });

  let url;
  try {
    url = await startServer(PORT);
  } catch (e) {
    log('port ' + PORT + ' indisponible: ' + e);
    url = await startServer(0);
  }
  log('server: ' + url + ' root=' + APP_ROOT);
  try { makeUpdater(); } catch (e) { log('updater init: ' + e); }
  setupIpc();
  Menu.setApplicationMenu(null);
  createWindow(url);
  win.webContents.once('did-finish-load', () => {
    updState({});                                                    /* état initial (mise à jour déjà prête ?) */
    setTimeout(appUpdateCheck, Number(process.env.TBBR_UPDATE_DELAY_MS || 8000));
  });
  setInterval(appUpdateCheck, 6 * 60 * 60 * 1000);

  app.on('window-all-closed', () => app.quit());
  app.on('before-quit', () => { if (server) server.close(); });
  /* mise à jour prête mais pas installée : elle s'installe à la fermeture (prise en compte au prochain lancement) */
  app.on('will-quit', () => {
    if (appliedOnQuit || !updater || upd.state !== 'ready') return;
    try { const r = updater.apply({ relaunch: false }); log('installation à la fermeture : ' + JSON.stringify(r)); } catch (e) { log('installation à la fermeture : ' + e); }
  });
}

main().catch(e => {
  log('fatal: ' + (e && e.stack || e));
  dialog.showErrorBox('BlackBox TBBR', String(e && e.message || e));
  app.quit();
});
