/* The Big Black Rig — protocole et transports.
 *
 * Trame (identique en BLE et en USB) :
 *   [0xA5] [CMD] [LEN lo] [LEN hi] [PAYLOAD × LEN] [XOR de CMD..fin du payload]
 * Payload binaire pour le temps réel (PARAM, BYPASS, TUNER_DATA, METER, chunks),
 * JSON UTF-8 pour le structuré (INFO, PRESET_SET, IR_BEGIN, GLOBAL).
 *
 * BLE : service type Nordic UART (UUID configurables dans « Appareil »),
 *   l'app écrit sur RX (write without response, découpé en paquets MTU),
 *   la pédale notifie sur TX.
 * USB : CDC-ACM via Web Serial, 115200 bauds par défaut.
 */
'use strict';

const CMD = {
  HELLO: 0x01, INFO: 0x02, ACK: 0x06, NAK: 0x15,
  PRESET_SELECT: 0x10, PRESET_SET: 0x11, PRESET_SAVE: 0x12, PRESET_GET: 0x13,
  DATA: 0x14, PRESET_LIST: 0x16,          /* grosses réponses de la pédale : [type, index, morceau, nb morceaux, données] */
  SCENE_SELECT: 0x18, TEMPO: 0x19, LEVEL: 0x1A,
  BLOCK_SET: 0x20, BLOCK_CLEAR: 0x21, BLOCK_MOVE: 0x22, BYPASS: 0x23, PARAM: 0x24, SPLIT: 0x25,
  GLOBAL: 0x30, FS_CONFIG: 0x31,
  TUNER: 0x38, TUNER_DATA: 0x39,
  IR_BEGIN: 0x40, IR_CHUNK: 0x41, IR_END: 0x42,
  NAM_BEGIN: 0x44, NAM_CHUNK: 0x45, NAM_END: 0x46, NAM_DELETE: 0x47,
  FW_BEGIN: 0x50, FW_CHUNK: 0x51, FW_END: 0x52,
  METER: 0x60, FACTORY_RESET: 0x7E,
};
const CMD_NAME = Object.fromEntries(Object.entries(CMD).map(([k, v]) => [v, k]));
const STREAM_CMDS = new Set([CMD.METER, CMD.TUNER_DATA, CMD.IR_CHUNK, CMD.NAM_CHUNK, CMD.FW_CHUNK]);
const SOF = 0xA5;

const sleep = ms => new Promise(r => setTimeout(r, ms));
const hex = bytes => Array.from(bytes, b => b.toString(16).padStart(2, '0').toUpperCase()).join(' ');

function toBytes(p) {
  if (p == null) return new Uint8Array(0);
  if (p instanceof Uint8Array) return p;
  if (Array.isArray(p)) return Uint8Array.from(p);
  return new TextEncoder().encode(typeof p === 'string' ? p : JSON.stringify(p));
}

function encodeFrame(cmd, payload) {
  const pl = toBytes(payload), f = new Uint8Array(pl.length + 5);
  f[0] = SOF; f[1] = cmd; f[2] = pl.length & 255; f[3] = pl.length >> 8;
  f.set(pl, 4);
  let x = 0;
  for (let i = 1; i < f.length - 1; i++) x ^= f[i];
  f[f.length - 1] = x;
  return f;
}

/* [lane, col, index du paramètre, float32 LE] */
function paramPayload(lane, col, pidx, value) {
  const b = new Uint8Array(7);
  b[0] = lane; b[1] = col; b[2] = pidx;
  new DataView(b.buffer).setFloat32(3, value, true);
  return b;
}

/* [float32 LE] : niveau du preset (commande LEVEL) */
function levelPayload(value) {
  const b = new Uint8Array(4);
  new DataView(b.buffer).setFloat32(0, value, true);
  return b;
}

const decodeJSON = pl => { try { return JSON.parse(new TextDecoder().decode(pl)); } catch { return null; } };

class FrameParser {
  constructor() { this.buf = []; }
  push(bytes) {
    for (const b of bytes) this.buf.push(b);
    const out = [];
    for (;;) {
      const i = this.buf.indexOf(SOF);
      if (i < 0) { this.buf.length = 0; break; }
      if (i > 0) this.buf.splice(0, i);
      if (this.buf.length < 5) break;
      const len = this.buf[2] | (this.buf[3] << 8);
      if (this.buf.length < len + 5) break;
      let x = 0;
      for (let j = 1; j < len + 4; j++) x ^= this.buf[j];
      if (x !== this.buf[len + 4]) { this.buf.splice(0, 1); continue; } // resync
      const f = this.buf.splice(0, len + 5);
      out.push({ cmd: f[1], payload: Uint8Array.from(f.slice(4, 4 + len)), raw: Uint8Array.from(f) });
    }
    return out;
  }
}

class Transport extends EventTarget {
  constructor(cfg = {}) { super(); this.cfg = cfg; this.parser = new FrameParser(); this.connected = false; }
  on(type, fn) { this.addEventListener(type, e => fn(e.detail)); return this; }
  emit(type, detail) { this.dispatchEvent(new CustomEvent(type, { detail })); }
  _rx(bytes) { for (const fr of this.parser.push(bytes)) this.emit('frame', fr); }
  async send(cmd, payload) {
    if (!this.connected) return;
    const f = encodeFrame(cmd, payload);
    this.emit('tx', { cmd, raw: f });
    await this._write(f);
  }
  async sendRaw(bytes) {
    if (!this.connected) return;
    this.emit('tx', { cmd: bytes[0] === SOF ? bytes[1] : -1, raw: bytes });
    await this._write(bytes);
  }
}

/* ---------- Pédale simulée ---------- */
class DemoTransport extends Transport {
  constructor(cfg) { super(cfg); this.kind = 'demo'; this.label = 'Démo'; this.timers = []; }
  static supported() { return true; }
  async connect() {
    await sleep(450);
    this.connected = true;
    this.emit('open');
    let t = 0;
    this.timers.push(setInterval(() => { // vu-mètres
      t += 0.09;
      const pick = Math.max(0, Math.sin(t * 2.3) * 0.5 + 0.35 + (Math.random() - 0.5) * 0.25);
      this._rx(encodeFrame(CMD.METER, [Math.min(255, pick * 230) | 0, Math.min(255, pick * 200) | 0, 86]));
    }, 90));
  }
  async disconnect() {
    this.timers.forEach(clearInterval); this.timers = [];
    clearInterval(this.tunerT);
    this.connected = false;
    this.emit('close');
  }
  async _write(f) {
    for (const fr of new FrameParser().push(f)) this._handle(fr);
    if (f[1] === CMD.IR_CHUNK || f[1] === CMD.NAM_CHUNK || f[1] === CMD.FW_CHUNK) await sleep(4); // débit simulé
  }
  _reply(cmd, payload, delay = 8 + Math.random() * 22) { setTimeout(() => this.connected && this._rx(encodeFrame(cmd, payload)), delay); }
  _handle({ cmd, payload }) {
    switch (cmd) {
      case CMD.HELLO:
        /* mêmes champs que l'INFO du vrai firmware (fw6+) ; battery null = inconnue (pas encore lue sur la BlackBox) */
        this._reply(CMD.INFO, { model: 'M-VAVE Blackbox (démo)', fw: 'TBBR démo', boot: 'JieLi SPL', hw: 'AC791N', serial: 'DEMO', cpu: 'AC791N bicœur 360 MHz', presets: PRESETS, irSlots: IR_SLOTS, irLen: 2048, namSlots: NAM_SLOTS, nam: 'A2 Lite', namMaxKB: 8, battery: 86, usb: 0, bt: 'off', proto: 1 }, 120);
        break;
      case CMD.TUNER:
        clearInterval(this.tunerT);
        this._reply(CMD.ACK, [cmd]);
        if (payload[0]) this._startTuner();
        break;
      default:
        this._reply(CMD.ACK, [cmd]);
    }
  }
  _startTuner() {
    const strings = [[4, 2], [9, 2], [2, 3], [7, 3], [11, 3], [4, 4]];
    let si = 0, cents = 30, since = 0;
    this.tunerT = setInterval(() => {
      since += 60;
      if (since > 3800) { since = 0; si = (si + 1) % strings.length; cents = (Math.random() * 80 - 40); }
      cents += (0 - cents) * 0.035 + (Math.random() - 0.5) * 1.6;
      const [note, oct] = strings[si], c = Math.round(cents * 10), b = new Uint8Array(5);
      b[0] = note; b[1] = oct; new DataView(b.buffer).setInt16(2, c, true); b[4] = since < 3200 ? 200 : 40;
      this._rx(encodeFrame(CMD.TUNER_DATA, b));
    }, 60);
  }
}

/* ---------- Bluetooth LE (Web Bluetooth) ---------- */
class BleTransport extends Transport {
  constructor(cfg) { super(cfg); this.kind = 'ble'; this.label = 'Bluetooth'; this.q = Promise.resolve(); this.chunk = 180; }
  static supported() { return !!navigator.bluetooth; }
  async connect() {
    const { namePrefix, service, rx, tx } = this.cfg;
    this.device = await navigator.bluetooth.requestDevice({
      filters: [{ namePrefix }, { services: [service] }],
      optionalServices: [service],
    });
    this.device.addEventListener('gattserverdisconnected', () => { this.connected = false; this.emit('close'); });
    const server = await this.device.gatt.connect();
    const svc = await server.getPrimaryService(service);
    this.rxChar = await svc.getCharacteristic(rx);
    this.txChar = await svc.getCharacteristic(tx);
    this.txChar.addEventListener('characteristicvaluechanged', e => {
      const v = e.target.value;
      this._rx(new Uint8Array(v.buffer, v.byteOffset, v.byteLength));
    });
    await this.txChar.startNotifications();
    this.label = this.device.name || 'Bluetooth';
    this.connected = true;
    this.emit('open');
  }
  async disconnect() { try { if (this.device && this.device.gatt) this.device.gatt.disconnect(); } catch { /* déjà fermé */ } this.connected = false; this.emit('close'); }
  _write(f) {
    this.q = this.q.then(async () => {
      for (let i = 0; i < f.length; i += this.chunk) {
        const c = f.slice(i, i + this.chunk);
        if (this.rxChar.writeValueWithoutResponse) await this.rxChar.writeValueWithoutResponse(c);
        else await this.rxChar.writeValue(c);
      }
    }).catch(e => this.emit('error', e));
    return this.q;
  }
}

/* ---------- USB MIDI (WebMIDI) : transport du vrai firmware ----------
 * Port « BlackBox Custom » (MIDI USB compatible classe, sans pilote ; marche aussi dans Chrome Android).
 * Chaque trame A5 … est envoyée dans un SysEx : F0 7D 42 58 70 <trame codée 7 bits> F7.
 * Codage 7 bits : par groupe de 7 octets, un octet d'en-tête (bit k = bit 7 de l'octet k), puis les 7 octets sur 7 bits. */
const MIDI_HDR = [0xF0, 0x7D, 0x42, 0x58, 0x70];
function pack7(u8) {
  const out = [];
  for (let i = 0; i < u8.length; i += 7) {
    const g = u8.subarray(i, i + 7);
    let hi = 0;
    g.forEach((b, k) => { hi |= (b >> 7) << k; });
    out.push(hi, ...Array.from(g, b => b & 0x7F));
  }
  return out;
}
function unpack7(a) {
  const out = [];
  for (let i = 0; i < a.length;) {
    const hi = a[i++];
    for (let k = 0; k < 7 && i < a.length; k++, i++) out.push((a[i] & 0x7F) | (((hi >> k) & 1) << 7));
  }
  return Uint8Array.from(out);
}
class MidiTransport extends Transport {
  constructor(cfg) { super(cfg); this.kind = 'usb'; this.label = 'USB MIDI'; this.portName = (cfg && cfg.midiName) || 'BlackBox Custom'; }
  static supported() { return !!navigator.requestMIDIAccess; }
  async connect() {
    const acc = await navigator.requestMIDIAccess({ sysex: true });
    const norm = s => String(s || '').toLowerCase().replace(/[^a-z0-9]/g, '');
    const wanted = norm(this.portName);
    /* Android expose parfois « BlackBox » au lieu de « BlackBox Custom » : garder une correspondance large. */
    const pick = m => {
      const ps = [...m.values()].filter(p => p.name);
      return ps.find(p => norm(p.name) === wanted)
          || ps.find(p => norm(p.name).includes(wanted))
          || ps.find(p => norm(p.name).includes('blackbox'))
          || ps.find(p => norm(p.name).includes('mvave'))
          || null;
    };
    this.input = pick(acc.inputs); this.output = pick(acc.outputs);
    if (!this.input || !this.output) {
      const names = m => [...m.values()].map(p => p.name).filter(Boolean).join(', ') || 'aucun';
      const e = new Error('pédale « ' + this.portName + ' » introuvable en MIDI (entrées : ' + names(acc.inputs) + ' ; sorties : ' + names(acc.outputs) + ')');
      e.name = 'NotFoundError'; throw e;
    }
    this.input.onmidimessage = ev => {
      const d = ev.data;
      if (d.length < 7 || d[0] !== 0xF0 || d[d.length - 1] !== 0xF7) return;
      for (let i = 1; i < 5; i++) if (d[i] !== MIDI_HDR[i]) return;
      this._rx(unpack7(d.subarray(5, d.length - 1)));
    };
    this.acc = acc;
    acc.onstatechange = ev => { if (ev.port === this.input && ev.port.state === 'disconnected' && this.connected) { this.connected = false; this.emit('close'); } };
    await this.output.open(); await this.input.open();
    this.label = 'USB · ' + this.output.name;
    this.connected = true;
    this.emit('open');
  }
  async disconnect() {
    const was = this.connected;
    this.connected = false;
    try { this.input.onmidimessage = null; await this.input.close(); await this.output.close(); } catch { /* déjà fermé */ }
    if (was) this.emit('close');
  }
  async _write(f) {
    /* une trame peut être longue (chunks IR/NAM) : SysEx d'au plus ~240 octets de trame chacun → découper en trames côté appelant */
    this.output.send([...MIDI_HDR, ...pack7(f), 0xF7]);
  }
}

/* ---------- USB (Web Serial, CDC-ACM) ---------- */
class SerialTransport extends Transport {
  constructor(cfg) { super(cfg); this.kind = 'usb'; this.label = 'USB'; }
  static supported() { return !!navigator.serial; }
  async connect() {
    this.port = await navigator.serial.requestPort();
    await this.port.open({ baudRate: this.cfg.baud || 115200 });
    this.writer = this.port.writable.getWriter();
    const info = this.port.getInfo ? this.port.getInfo() : {};
    this.label = info.usbVendorId ? 'USB ' + info.usbVendorId.toString(16).padStart(4, '0') + ':' + (info.usbProductId || 0).toString(16).padStart(4, '0') : 'USB';
    this.connected = true;
    this.emit('open');
    this._loop();
  }
  async _loop() {
    while (this.connected && this.port.readable) {
      this.reader = this.port.readable.getReader();
      let done = false;
      try {
        for (;;) {
          const r = await this.reader.read();
          if (r.done) { done = true; break; }
          if (r.value) this._rx(r.value);
        }
      } catch (e) { if (this.connected) this.emit('error', e); }
      finally { try { this.reader.releaseLock(); } catch { /* */ } }
      if (done) break;
    }
    if (this.connected) { this.connected = false; this.emit('close'); }
  }
  async disconnect() {
    const was = this.connected;
    this.connected = false;
    try { if (this.reader) await this.reader.cancel(); } catch { /* */ }
    try { if (this.writer) this.writer.releaseLock(); } catch { /* */ }
    try { if (this.port) await this.port.close(); } catch { /* */ }
    if (was) this.emit('close');
  }
  _write(f) { return this.writer.write(f).catch(e => this.emit('error', e)); }
}
