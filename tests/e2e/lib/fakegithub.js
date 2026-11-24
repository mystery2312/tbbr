/* fakegithub.js : faux GitHub (API releases + téléchargements) pour tester les mises à jour sans réseau.
 *   const gh = await fakeGitHub(); gh.release('mystery2312/tbbr', { tag, files: { 'TBBR_update.json': obj|Buffer, ... } });
 *   gh.api = base de l'API (TBBR_UPDATE_API) ; gh.hits = requêtes reçues ; gh.deny(repo) = dépôt privé (404). */
'use strict';
const http = require('node:http');
const crypto = require('node:crypto');

async function fakeGitHub() {
  const repos = new Map(), denied = new Set(), files = new Map(), hits = [];
  const srv = http.createServer((req, res) => {
    const u = new URL(req.url, 'http://x');
    hits.push(u.pathname);
    const send = (code, body, type = 'application/json') => { res.writeHead(code, { 'Content-Type': type }); res.end(body); };
    let m = u.pathname.match(/^\/repos\/([^/]+\/[^/]+)\/releases(\/latest)?$/);
    if (m) {
      if (denied.has(m[1]) || !repos.has(m[1])) return send(404, '{"message":"Not Found"}');
      const list = repos.get(m[1]);
      if (m[2]) { const r = list.find(x => !x.prerelease && !x.draft); return r ? send(200, JSON.stringify(r)) : send(404, '{}'); }
      return send(200, JSON.stringify(list));
    }
    m = u.pathname.match(/^\/dl\/(.+)$/);
    if (m && files.has(m[1])) return send(200, files.get(m[1]), 'application/octet-stream');
    send(404, 'not found', 'text/plain');
  });
  await new Promise(r => srv.listen(0, '127.0.0.1', r));
  const base = 'http://127.0.0.1:' + srv.address().port;
  return {
    api: base, hits,
    deny: repo => denied.add(repo),
    /* publie une release ; files : nom -> Buffer | objet (sérialisé en JSON) ; la plus récente en tête de liste */
    release(repo, { tag, prerelease = false, files: fs = {} }) {
      const assets = Object.entries(fs).map(([name, data]) => {
        const key = repo.replace('/', '_') + '/' + tag + '/' + name;
        files.set(key, Buffer.isBuffer(data) ? data : Buffer.from(JSON.stringify(data)));
        return { name, browser_download_url: base + '/dl/' + key, size: files.get(key).length };
      });
      const rel = { tag_name: tag, html_url: base + '/page/' + tag, prerelease, draft: false, assets };
      repos.set(repo, [rel, ...(repos.get(repo) || [])]);
      return rel;
    },
    close: () => new Promise(r => srv.close(r)),
  };
}

/* manifeste TBBR_update.json pour un exe et/ou un apk (mêmes champs que tools/release_manifest.js) */
function manifest(version, { exe, apk, apkCode = 1, channel = 'stable' } = {}) {
  const e = b => ({ size: b.length, sha256: crypto.createHash('sha256').update(b).digest('hex') });
  const m = { format: 'tbbr-update', schema: 1, version, channel, tag: 'v' + version, date: new Date().toISOString(), notes: 'Notes ' + version };
  if (exe) m.app = { file: 'BlackBox_TBBR_App.exe', version, platform: 'win32-x64', kind: 'portable', ...e(exe) };
  if (apk) m.apk = { file: 'TBBR_Android.apk', versionName: version, versionCode: apkCode, minSdk: 24, ...e(apk) };
  return m;
}

module.exports = { fakeGitHub, manifest };
