/* Pont entre l'éditeur (page web) et l'app de bureau : mises à jour via GitHub Releases et installateur firmware. */
'use strict';
const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('tbbrDesktop', {
  version: () => ipcRenderer.invoke('tbbr:version'),
  checkUpdates: () => ipcRenderer.invoke('tbbr:check'),          // { tag, fw, appNewer, appVersion, page } ou { error }
  updatePedal: () => ipcRenderer.invoke('tbbr:update-pedal'),     // télécharge le .tbbr puis lance l'installateur en mode mise à jour
  openInstaller: () => ipcRenderer.invoke('tbbr:installer'),
  openReleasePage: () => ipcRenderer.invoke('tbbr:release-page'),
  /* mise à jour automatique de l'app : état { state: idle|checking|none|available|downloading|ready|error, version, progress, error, canInstall } */
  appUpdateState: () => ipcRenderer.invoke('tbbr:app-update-state'),
  appUpdateCheck: () => ipcRenderer.invoke('tbbr:app-update-check'),
  appUpdateInstall: () => ipcRenderer.invoke('tbbr:app-update-install'),   // remplace l'exe et redémarre
  onAppUpdate: fn => { const h = (e, s) => fn(s); ipcRenderer.on('tbbr:app-update', h); return () => ipcRenderer.removeListener('tbbr:app-update', h); },
});
