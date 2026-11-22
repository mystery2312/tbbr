/* BlackBox TBBR — application Electron.
 * Sert l'app web embarquée sur 127.0.0.1:8791 (origine stable pour localStorage/IndexedDB),
 * ouvre une fenêtre native, autorise WebMIDI/Web Bluetooth et lance l'installateur firmware.
 */
'use strict';

const { app, BrowserWindow, Menu, dialog, session, shell } = require('electron');
const fs = require('fs');
const http = require('http');
const path = require('path');

const PORT = 8791;
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
      spellcheck: false
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
  Menu.setApplicationMenu(null);
  createWindow(url);

  app.on('window-all-closed', () => app.quit());
  app.on('before-quit', () => { if (server) server.close(); });
}

main().catch(e => {
  log('fatal: ' + (e && e.stack || e));
  dialog.showErrorBox('BlackBox TBBR', String(e && e.message || e));
  app.quit();
});
