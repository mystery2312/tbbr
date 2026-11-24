#!/usr/bin/env node
/* release_manifest.js : écrit TBBR_update.json, le manifeste joint à chaque release GitHub.
 * Il décrit les fichiers de la release (version, taille, SHA-256) ; l'app Windows et l'app Android s'en servent pour se
 * mettre à jour : elles comparent les versions, téléchargent le bon fichier et refusent tout fichier dont l'empreinte diffère.
 *
 * Usage : node tools/release_manifest.js <dossier des fichiers de la release> <stable|beta> [notes.md]
 *   le dossier doit contenir BlackBox_TBBR_App.exe, TBBR_Android.apk, BlackBox_TBBR_Installer.exe et TBBR_fw6_x.y.tbbr */
'use strict';
const fs = require('node:fs');
const path = require('node:path');
const crypto = require('node:crypto');

const ROOT = path.join(__dirname, '..');
const [dir, channel = 'stable', notesFile] = process.argv.slice(2);
if (!dir || !['stable', 'beta'].includes(channel)) { console.error('usage : release_manifest.js <dossier> <stable|beta> [notes.md]'); process.exit(2); }

const version = JSON.parse(fs.readFileSync(path.join(ROOT, 'electron', 'package.json'), 'utf8')).version;
if ((channel === 'beta') !== version.includes('-beta')) { console.error('canal ' + channel + ' incohérent avec la version ' + version); process.exit(2); }
const fwm = fs.readFileSync(path.join(ROOT, 'fw_maison', 'fw6', 'main.c'), 'utf8').match(/#define FW_VERSION "(TBBR (fw\d+) (\d+\.\d+))"/);
if (!fwm) { console.error('FW_VERSION introuvable'); process.exit(2); }
const codeFile = path.join(ROOT, 'android', 'version-code.txt');
const versionCode = fs.existsSync(codeFile) ? parseInt(fs.readFileSync(codeFile, 'utf8').trim(), 10) : 0;

function entry(name, extra) {
  const f = path.join(dir, name);
  if (!fs.existsSync(f)) { console.error('fichier absent : ' + f); process.exit(1); }
  const b = fs.readFileSync(f);
  return { file: name, size: b.length, sha256: crypto.createHash('sha256').update(b).digest('hex'), ...extra };
}
const pkg = `TBBR_${fwm[2]}_${fwm[3]}.tbbr`;
const m = {
  format: 'tbbr-update', schema: 1, version, channel, tag: 'v' + version, date: new Date().toISOString(),
  notes: notesFile && fs.existsSync(notesFile) ? fs.readFileSync(notesFile, 'utf8').slice(0, 4000) : '',
  app: entry('BlackBox_TBBR_App.exe', { version, platform: 'win32-x64', kind: 'portable' }),
  apk: entry('TBBR_Android.apk', { versionName: version, versionCode, minSdk: 24 }),
  fw: entry(pkg, { version: fwm[1] }),
  installer: entry('BlackBox_TBBR_Installer.exe', {}),
};
if (!(m.apk.versionCode > 0)) { console.error('versionCode Android inconnu (android/version-code.txt)'); process.exit(1); }
fs.writeFileSync(path.join(dir, 'TBBR_update.json'), JSON.stringify(m, null, 1));
console.log('TBBR_update.json : app ' + version + ', apk ' + versionCode + ', ' + fwm[1]);
