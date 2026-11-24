/* updater.js : mise à jour automatique de l'app de bureau portable (BlackBox_TBBR_App.exe).
 *
 * 1. check()    : lit TBBR_update.json dans les releases GitHub (stable ; plus le dépôt beta pour une build beta) et
 *                 garde la version la plus récente (0.9.6 > 0.9.6-beta.3 : une beta passe à la stable).
 * 2. download() : télécharge l'exe dans <userData>/updates, vérifie taille + SHA-256 du manifeste (sinon : refus).
 * 3. stage()    : mémorise la mise à jour prête (pending.json).
 * 4. apply()    : remplace l'exe portable en place (Windows autorise à RENOMMER un exe en cours d'exécution : l'ancien
 *                 devient « .old », le nouveau prend son nom), puis relance si demandé. Fait aussi à la fermeture de l'app.
 * 5. cleanup()  : au démarrage suivant, supprime l'ancien exe et les téléchargements périmés.
 * Aucune dépendance à Electron : fetch, spawn et les chemins sont injectés (tests : tests/e2e/updater.test.js). */
'use strict';
const fs = require('fs');
const path = require('path');
const crypto = require('crypto');

function parseVersion(s) {
  const m = String(s || '').trim().replace(/^v/i, '').match(/^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z.-]+))?$/);
  return m ? { n: [+m[1], +m[2], +m[3]], pre: m[4] ? m[4].split('.') : [] } : null;
}
/* comparaison semver : >0 si a est plus récente ; une version sans suffixe passe avant ses pré-versions */
function compareVersions(a, b) {
  const x = parseVersion(a), y = parseVersion(b);
  if (!x || !y) return x ? 1 : y ? -1 : 0;
  for (let i = 0; i < 3; i++) if (x.n[i] !== y.n[i]) return x.n[i] - y.n[i];
  if (!x.pre.length || !y.pre.length) return (x.pre.length ? -1 : 0) - (y.pre.length ? -1 : 0);
  for (let i = 0; i < Math.max(x.pre.length, y.pre.length); i++) {
    const p = x.pre[i], q = y.pre[i];
    if (p === undefined) return -1;
    if (q === undefined) return 1;
    const pn = /^\d+$/.test(p), qn = /^\d+$/.test(q);
    if (pn && qn && +p !== +q) return +p - +q;
    if (pn !== qn) return pn ? -1 : 1;
    if (p !== q) return p < q ? -1 : 1;
  }
  return 0;
}
const HEX64 = /^[0-9a-f]{64}$/;
function validManifest(m) {
  return !!(m && m.format === 'tbbr-update' && parseVersion(m.version) && m.app && typeof m.app.file === 'string' &&
    /^[\w.-]+\.exe$/i.test(m.app.file) && Number.isInteger(m.app.size) && m.app.size > 0 && HEX64.test(String(m.app.sha256 || '')));
}

class Updater {
  /* opts : version (actuelle), sources [{repo, list}] (list = lire /releases au lieu de /releases/latest), fetch,
            dir (dossier des téléchargements), exePath (exe portable à remplacer ; null = pas de remplacement possible),
            apiBase, spawn, log */
  constructor(opts) {
    this.version = opts.version;
    this.sources = opts.sources;
    this.fetch = opts.fetch;
    this.dir = opts.dir;
    this.exePath = opts.exePath || null;
    this.api = (opts.apiBase || 'https://api.github.com').replace(/\/$/, '');
    this.spawn = opts.spawn;
    this.log = opts.log || (() => {});
    this.headers = { 'User-Agent': 'TBBR-desktop', 'Accept': 'application/vnd.github+json' };
  }
  get pendingFile() { return path.join(this.dir, 'pending.json'); }
  canReplace() { return !!this.exePath && fs.existsSync(this.exePath); }

  async _json(url) {
    const r = await this.fetch(url, { headers: this.headers });
    if (!r.ok) throw new Error('HTTP ' + r.status + ' ' + url);
    return r.json();
  }
  async _manifestOf(rel) {
    const a = (rel.assets || []).find(x => x.name === 'TBBR_update.json');
    if (!a) return null;
    const m = await this._json(a.browser_download_url);
    if (!validManifest(m)) throw new Error('manifeste invalide dans ' + rel.tag_name);
    const exe = (rel.assets || []).find(x => x.name === m.app.file);
    if (!exe) throw new Error('fichier ' + m.app.file + ' absent de ' + rel.tag_name);
    return { manifest: m, url: exe.browser_download_url, page: rel.html_url || '', tag: rel.tag_name };
  }
  /* -> { available, version, url, page, manifest } (la version la plus récente trouvée) ou { available:false } */
  async check() {
    let best = null;
    const errors = [];
    for (const s of this.sources) {
      try {
        const rels = s.list
          ? (await this._json(`${this.api}/repos/${s.repo}/releases?per_page=15`)).filter(r => !r.draft)
          : [await this._json(`${this.api}/repos/${s.repo}/releases/latest`)];
        for (const rel of rels) {
          const c = await this._manifestOf(rel).catch(e => { errors.push(String(e.message || e)); return null; });
          if (c && (!best || compareVersions(c.manifest.version, best.manifest.version) > 0)) best = c;
          if (c && s.list) break;                                    /* la plus récente du dépôt suffit */
        }
      } catch (e) { errors.push(String(e.message || e)); }          /* dépôt beta privé, hors ligne… : on continue */
    }
    if (errors.length) this.log('check: ' + errors.join(' | '));
    if (!best) return { available: false, errors };
    return { available: compareVersions(best.manifest.version, this.version) > 0, version: best.manifest.version,
      url: best.url, page: best.page, manifest: best.manifest, errors };
  }
  _target(m) { return path.join(this.dir, 'BlackBox_TBBR_App_' + m.version.replace(/[^\w.-]/g, '_') + '.exe'); }
  static sha256File(f) { return crypto.createHash('sha256').update(fs.readFileSync(f)).digest('hex'); }
  /* télécharge et vérifie ; onProgress(fraction) ; renvoie le chemin du fichier vérifié */
  async download(info, onProgress = () => {}) {
    const m = info.manifest;
    fs.mkdirSync(this.dir, { recursive: true });
    const dest = this._target(m);
    if (fs.existsSync(dest) && fs.statSync(dest).size === m.app.size && Updater.sha256File(dest) === m.app.sha256) { onProgress(1); return dest; }
    const tmp = dest + '.part';
    const r = await this.fetch(info.url, { headers: { 'User-Agent': 'TBBR-desktop' } });
    if (!r.ok) throw new Error('téléchargement HTTP ' + r.status);
    const h = crypto.createHash('sha256'), out = fs.openSync(tmp, 'w');
    let got = 0;
    const drop = () => { try { fs.unlinkSync(tmp); } catch { /* */ } };
    try {
      const rd = r.body.getReader();
      for (;;) {
        const { done, value } = await rd.read();
        if (done) break;
        got += value.length;
        if (got > m.app.size) throw new Error('fichier refusé : plus gros que prévu');
        h.update(value); fs.writeSync(out, value);
        onProgress(got / m.app.size);
      }
    } catch (e) { fs.closeSync(out); drop(); throw e; }
    fs.closeSync(out);
    const sum = h.digest('hex');
    if (got !== m.app.size || sum !== m.app.sha256) {
      try { fs.unlinkSync(tmp); } catch { /* */ }
      throw new Error(`fichier refusé : taille ${got}/${m.app.size}, SHA-256 ${sum.slice(0, 12)}… attendu ${m.app.sha256.slice(0, 12)}…`);
    }
    try { fs.unlinkSync(dest); } catch { /* */ }
    fs.renameSync(tmp, dest);
    return dest;
  }
  stage(info, file) {
    fs.writeFileSync(this.pendingFile, JSON.stringify({ version: info.manifest.version, file, sha256: info.manifest.app.sha256, size: info.manifest.app.size }));
  }
  pending() {
    try {
      const p = JSON.parse(fs.readFileSync(this.pendingFile, 'utf8'));
      if (compareVersions(p.version, this.version) > 0 && fs.existsSync(p.file)) return p;
    } catch { /* aucune */ }
    return null;
  }
  /* remplace l'exe portable par la mise à jour prête ; relaunch : relance la nouvelle version (l'appelant quitte ensuite) */
  apply({ relaunch = false } = {}) {
    const p = this.pending();
    if (!p) return { ok: false, reason: 'aucune mise à jour prête' };
    if (!this.canReplace()) return { ok: false, reason: 'app non portable : remplacement impossible' };
    if (fs.statSync(p.file).size !== p.size || Updater.sha256File(p.file) !== p.sha256) {
      try { fs.unlinkSync(p.file); fs.unlinkSync(this.pendingFile); } catch { /* */ }
      return { ok: false, reason: 'fichier téléchargé altéré : supprimé' };
    }
    const exe = this.exePath, old = exe + '.old';
    try { if (fs.existsSync(old)) fs.unlinkSync(old); } catch { /* encore utilisé : on renomme à côté */ }
    const oldName = fs.existsSync(old) ? exe + '.' + Date.now() + '.old' : old;
    try { fs.renameSync(exe, oldName); }                            /* autorisé sur un exe lancé directement… */
    catch (e) {
      /* …mais le lanceur portable d'electron-builder garde son exe ouvert sans partage « suppression » (EBUSY) tant qu'il
         tourne, c.-à-d. jusqu'à la fin de l'app : un script détaché attend sa fermeture puis remplace l'exe. */
      if (!['EBUSY', 'EPERM', 'EACCES'].includes(e.code) || !this.spawn) throw e;
      return this._deferred(p, relaunch);
    }
    try { fs.copyFileSync(p.file, exe); }
    catch (e) { fs.renameSync(oldName, exe); throw e; }             /* retour à l'ancien exe si la copie échoue */
    try { fs.unlinkSync(this.pendingFile); } catch { /* */ }
    this.log('mise à jour ' + this.version + ' -> ' + p.version + ' installée dans ' + exe);
    if (relaunch && this.spawn) { const c = this.spawn(exe, [], { detached: true, stdio: 'ignore' }); if (c && c.unref) c.unref(); }
    return { ok: true, version: p.version, exe };
  }
  /* remplacement différé (exe verrouillé) : script PowerShell détaché ; il attend jusqu'à 2 min que l'exe se libère,
     revérifie le SHA-256, renomme l'ancien en .old, copie le nouveau, efface pending.json, journalise, relance si demandé */
  _deferred(p, relaunch) {
    const q = s => "'" + String(s).replace(/'/g, "''") + "'";
    const ps1 = path.join(this.dir, 'apply_update.ps1'), logf = path.join(this.dir, 'apply_update.log');
    const script = [
      '$ErrorActionPreference = "Stop"',
      `$exe = ${q(this.exePath)}; $new = ${q(p.file)}; $sha = ${q(p.sha256)}; $pend = ${q(this.pendingFile)}; $log = ${q(logf)}`,
      'function L($m) { Add-Content -LiteralPath $log -Value ((Get-Date).ToString("s") + " " + $m) -Encoding UTF8 }',
      'trap { L ("erreur : " + $_); exit 9 }',
      'L "démarrage (attente de la libération de l\'exe)"',
      'if ((Get-FileHash -LiteralPath $new -Algorithm SHA256).Hash.ToLower() -ne $sha) { L "fichier altéré : abandon"; Remove-Item -LiteralPath $new, $pend -Force -ErrorAction SilentlyContinue; exit 2 }',
      '$old = $exe + ".old"; if (Test-Path -LiteralPath $old) { try { Remove-Item -LiteralPath $old -Force } catch { $old = $exe + "." + [DateTime]::Now.Ticks + ".old" } }',
      '$end = (Get-Date).AddMinutes(2); $moved = $false',
      'while (-not $moved -and (Get-Date) -lt $end) { try { Move-Item -LiteralPath $exe -Destination $old -Force; $moved = $true } catch { Start-Sleep -Milliseconds 300 } }',
      'if (-not $moved) { L "exe toujours verrouillé : nouvel essai à la prochaine fermeture"; exit 3 }',
      'try { Copy-Item -LiteralPath $new -Destination $exe -Force } catch { Move-Item -LiteralPath $old -Destination $exe -Force; L ("copie impossible : " + $_); exit 4 }',
      'Remove-Item -LiteralPath $pend -Force -ErrorAction SilentlyContinue',
      `L "mise à jour ${p.version} installée"`,
      relaunch ? 'Start-Process -FilePath $exe' : '',
    ].join('\r\n');
    fs.writeFileSync(ps1, '﻿' + script, 'utf8');
    /* lancé par « cmd /c start » : processus indépendant qui survit à l'app ET qui a sa console (fenêtre réduite puis
       masquée). PowerShell lancé directement en mode détaché depuis un processus sans console (l'app de bureau) ne
       s'exécute pas : vérifié par tests/e2e/updater.test.js. */
    const c = this.spawn('cmd.exe', ['/d', '/c', 'start', '""', '/min', 'powershell.exe', '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
      '-WindowStyle', 'Hidden', '-File', ps1], { detached: true, stdio: 'ignore', windowsHide: true });
    if (c && c.unref) c.unref();
    this.log('remplacement différé (exe verrouillé par le lanceur portable) : ' + ps1);
    return { ok: true, deferred: true, version: p.version, exe: this.exePath };
  }
  /* démarrage : anciens exe et téléchargements dépassés */
  cleanup() {
    const rm = f => { try { fs.unlinkSync(f); } catch { /* encore utilisé : prochaine fois */ } };
    if (this.exePath) {
      const d = path.dirname(this.exePath), b = path.basename(this.exePath);
      try { for (const f of fs.readdirSync(d)) if (f.startsWith(b + '.') && f.endsWith('.old')) rm(path.join(d, f)); } catch { /* */ }
    }
    try {
      for (const f of fs.readdirSync(this.dir)) {
        const v = (f.match(/^BlackBox_TBBR_App_(.+)\.exe(\.part)?$/) || [])[1];
        if (v && compareVersions(v, this.version) <= 0) rm(path.join(this.dir, f));
      }
      const p = JSON.parse(fs.readFileSync(this.pendingFile, 'utf8'));
      if (compareVersions(p.version, this.version) <= 0) rm(this.pendingFile);
    } catch { /* */ }
  }
}

module.exports = { Updater, compareVersions, parseVersion, validManifest };
