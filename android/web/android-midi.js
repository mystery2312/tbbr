/* android-midi.js : chargé AVANT les scripts de l'éditeur dans l'app Android (build_apk.ps1).
 * La WebView d'Android n'a pas WebMIDI : on recrée navigator.requestMIDIAccess au-dessus du pont natif
 * window.TBBRMidi (MidiBridge.java, API android.media.midi : la pédale branchée en USB OTG).
 * Aussi : liens externes vers le navigateur, enregistrement des fichiers exportés, bouton retour. */
(function () {
  'use strict';
  if (!window.TBBRMidi) return;
  const B = window.TBBRMidi, A = window.TBBRAndroid;
  window.tbbrAndroid = true;
  const b64 = a => { let s = ''; for (let i = 0; i < a.length; i++) s += String.fromCharCode(a[i] & 255); return btoa(s); };
  const unb64 = s => { const t = atob(s), u = new Uint8Array(t.length); for (let i = 0; i < t.length; i++) u[i] = t.charCodeAt(i); return u; };

  const ports = new Map(), waiting = new Map();
  let access = null;

  class MIDIPort extends EventTarget {
    constructor(d) {
      super();
      this.id = d.id; this.name = d.name; this.manufacturer = d.manufacturer || ''; this.type = d.type; this.version = '';
      this.state = 'connected'; this.connection = 'closed'; this.onstatechange = null; this._onmsg = null;
    }
    get onmidimessage() { return this._onmsg; }
    set onmidimessage(f) { this._onmsg = f; if (f && this.connection === 'closed') this.open(); }
    open() {
      if (this.connection === 'open') return Promise.resolve(this);
      if (this._opening) return this._opening;
      this.connection = 'pending';
      this._opening = new Promise((res, rej) => {
        waiting.set(this.id, ok => {
          this._opening = null;
          if (ok) { this.connection = 'open'; res(this); }
          else { this.connection = 'closed'; const e = new Error('port MIDI indisponible'); e.name = 'InvalidAccessError'; rej(e); }
        });
        B.open(this.id);
      });
      return this._opening;
    }
    close() { if (this.connection !== 'closed') B.close(this.id); this.connection = 'closed'; return Promise.resolve(this); }
    send(data) {
      if (this.type !== 'output') throw new TypeError('pas une sortie');
      if (!B.send(this.id, b64(data))) throw new Error('envoi MIDI impossible (pédale débranchée ?)');
    }
    clear() { }
  }

  function fireState(p) {
    const ev = new Event('statechange'); ev.port = p;
    if (p.onstatechange) p.onstatechange(ev);
    p.dispatchEvent(ev);
    if (access) { if (access.onstatechange) access.onstatechange(ev); access.dispatchEvent(ev); }
  }
  function refresh() {
    let list = [];
    try { list = JSON.parse(B.list()); } catch (e) { list = []; }
    const now = new Set(list.map(d => d.id));
    for (const d of list) {
      let p = ports.get(d.id);
      if (!p) { p = new MIDIPort(d); ports.set(d.id, p); if (access) fireState(p); }
      else if (p.state !== 'connected') { p.state = 'connected'; fireState(p); }
    }
    for (const [id, p] of ports) if (!now.has(id) && p.state !== 'disconnected') { p.state = 'disconnected'; p.connection = 'closed'; fireState(p); }
    if (access) {
      access.inputs.clear(); access.outputs.clear();
      for (const [id, p] of ports) if (p.state === 'connected') (p.type === 'input' ? access.inputs : access.outputs).set(id, p);
    }
  }

  window.__tbbrMidi = {
    opened(id, ok) { const f = waiting.get(id); waiting.delete(id); if (f) f(ok); },
    message(id, data) {
      const p = ports.get(id);
      if (!p) return;
      const ev = new Event('midimessage'); ev.data = unb64(data); ev.receivedTime = performance.now();
      if (p._onmsg) p._onmsg(ev);
      p.dispatchEvent(ev);
    },
    changed() { refresh(); },
  };

  navigator.requestMIDIAccess = function () {
    if (!access) {
      access = new EventTarget();
      access.inputs = new Map(); access.outputs = new Map(); access.sysexEnabled = true; access.onstatechange = null;
    }
    refresh();
    return Promise.resolve(access);
  };

  /* liens : externes vers le navigateur du téléphone, internes dans l'app */
  const internal = u => { try { return new URL(u, location.href).host === location.host; } catch (e) { return false; } };
  window.open = function (url) {
    if (!url) return null;
    if (internal(url)) location.href = new URL(url, location.href).href; else A.openExternal(new URL(url, location.href).href);
    return null;
  };
  document.addEventListener('click', e => {
    const a = e.target.closest && e.target.closest('a[href]');
    if (!a) return;
    const href = a.getAttribute('href');
    if (a.hasAttribute('download') && /^(blob:|data:)/.test(a.href)) { e.preventDefault(); save(a.href, a.getAttribute('download') || 'tbbr.json'); return; }
    if (a.target === '_blank' || !internal(href)) { e.preventDefault(); window.open(href); }
  }, true);

  /* fichiers exportés (sauvegarde complète, preset…) : <a download href="blob:…"> -> Téléchargements/TBBR */
  async function save(href, name) {
    try {
      const blob = await (await fetch(href)).blob();
      const r = new FileReader();
      r.onload = () => {
        const path = A.saveFile(name, String(r.result).split(',')[1] || '', blob.type || 'application/octet-stream');
        if (typeof toast === 'function') toast(path ? 'Enregistré : ' + path : 'Enregistrement impossible', path ? 'ok' : 'err');
      };
      r.readAsDataURL(blob);
    } catch (e) { if (typeof toast === 'function') toast('Enregistrement impossible', 'err'); }
  }
  const click = HTMLAnchorElement.prototype.click;
  HTMLAnchorElement.prototype.click = function () {
    if (this.hasAttribute('download') && /^(blob:|data:)/.test(this.href)) { save(this.href, this.getAttribute('download') || 'tbbr.json'); return; }
    return click.call(this);
  };

  /* bouton retour d'Android : ferme d'abord une fenêtre ouverte de l'éditeur */
  window.__tbbrBack = function () {
    const m = document.querySelector('.modal-bg, .ctx');
    if (!m) return false;
    document.dispatchEvent(new KeyboardEvent('keydown', { key: 'Escape', bubbles: true }));
    if (document.body.contains(m)) m.remove();
    return true;
  };
})();
