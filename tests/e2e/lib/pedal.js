/* pedal.js : pilote de l'émulateur de pédale (emu/out/pedal_emu.exe = vrai code proto.c + engine.c du firmware).
 * Même codage que l'app (transport.js) : trame A5 CMD LEN LEN PAYLOAD XOR, dans un SysEx F0 7D 42 58 70 <7 bits> F7. */
'use strict';
const { spawn } = require('node:child_process');
const path = require('node:path');
const fs = require('node:fs');

const EXE = path.join(__dirname, '..', 'emu', 'out', 'pedal_emu.exe');
const CMD = {
  HELLO: 0x01, INFO: 0x02, ACK: 0x06, NAK: 0x15,
  PRESET_SELECT: 0x10, PRESET_SET: 0x11, PRESET_SAVE: 0x12, PRESET_GET: 0x13,
  DATA: 0x14, PRESET_LIST: 0x16, SCENE_SELECT: 0x18, TEMPO: 0x19, LEVEL: 0x1A,
  BLOCK_SET: 0x20, BLOCK_CLEAR: 0x21, BLOCK_MOVE: 0x22, BYPASS: 0x23, PARAM: 0x24, SPLIT: 0x25,
  GLOBAL: 0x30, FS_CONFIG: 0x31, TUNER: 0x38, TUNER_DATA: 0x39,
  IR_BEGIN: 0x40, IR_CHUNK: 0x41, IR_END: 0x42,
  NAM_BEGIN: 0x44, NAM_CHUNK: 0x45, NAM_END: 0x46, NAM_DELETE: 0x47,
  METER: 0x60, FACTORY_RESET: 0x7E,
};
const HDR = [0xF0, 0x7D, 0x42, 0x58, 0x70];

function frame(cmd, payload) {
  const pl = payload == null ? Buffer.alloc(0)
    : Buffer.isBuffer(payload) || payload instanceof Uint8Array ? Buffer.from(payload)
    : Array.isArray(payload) ? Buffer.from(payload)
    : Buffer.from(typeof payload === 'string' ? payload : JSON.stringify(payload), 'utf8');
  const f = Buffer.alloc(pl.length + 5);
  f[0] = 0xA5; f[1] = cmd; f[2] = pl.length & 255; f[3] = pl.length >> 8; pl.copy(f, 4);
  let x = 0; for (let i = 1; i < f.length - 1; i++) x ^= f[i];
  f[f.length - 1] = x;
  return f;
}
function pack7(u8) {
  const out = [];
  for (let i = 0; i < u8.length; i += 7) {
    const g = u8.subarray(i, i + 7); let hi = 0;
    g.forEach((b, k) => { hi |= (b >> 7) << k; });
    out.push(hi, ...Array.from(g, b => b & 0x7F));
  }
  return out;
}
function unpack7(a) {
  const out = [];
  for (let i = 0; i < a.length;) { const hi = a[i++]; for (let k = 0; k < 7 && i < a.length; k++, i++) out.push((a[i] & 0x7F) | (((hi >> k) & 1) << 7)); }
  return Buffer.from(out);
}
const sysexOf = (cmd, payload) => Buffer.from([...HDR, ...pack7(frame(cmd, payload)), 0xF7]);
function framesOf(sysex) {
  if (sysex.length < 7 || sysex[0] !== 0xF0 || sysex[sysex.length - 1] !== 0xF7) return [];
  for (let i = 1; i < 5; i++) if (sysex[i] !== HDR[i]) return [];
  const f = unpack7(sysex.subarray(5, sysex.length - 1));
  if (f.length < 5 || f[0] !== 0xA5) return [];
  const n = f[2] | f[3] << 8;
  let x = 0; for (let i = 1; i < n + 4; i++) x ^= f[i];
  if (x !== f[n + 4]) throw new Error('XOR invalide dans une trame de la pédale');
  return [{ cmd: f[1], payload: f.subarray(4, 4 + n) }];
}

class Pedal {
  /* opts.flash : image de flash initiale (sinon vierge + cabs d'usine) */
  constructor(opts = {}) {
    if (!fs.existsSync(EXE)) throw new Error('émulateur absent : lancer tests\\e2e\\emu\\build.ps1');
    this.proc = spawn(EXE, opts.flash ? [opts.flash] : [], { stdio: ['pipe', 'pipe', 'inherit'] });
    this.buf = Buffer.alloc(0);
    this.logs = []; this.errors = []; this.sysexOut = []; this.frames = [];
    this.listeners = new Set();
    this.waiters = [];
    this.exited = new Promise(res => this.proc.on('exit', code => { this.code = code; res(code); this._wake(); }));
    this.proc.stdout.on('data', d => { this.buf = Buffer.concat([this.buf, d]); this._parse(); });
  }
  _parse() {
    while (this.buf.length >= 5) {
      const t = String.fromCharCode(this.buf[0]), n = this.buf.readUInt32LE(1);
      if (this.buf.length < 5 + n) return;
      const d = this.buf.subarray(5, 5 + n); this.buf = this.buf.subarray(5 + n);
      if (t === 'S') {
        const sx = Buffer.from(d); this.sysexOut.push(sx);
        for (const fn of this.listeners) fn(sx);
        for (const fr of framesOf(sx)) this.frames.push(fr);
      } else if (t === 'L') this.logs.push(d.toString('utf8'));
      else if (t === 'E') this.errors.push(d.toString('utf8'));
      else this.frames.push({ host: t, payload: Buffer.from(d) });
      this._wake();
    }
  }
  _wake() { const w = this.waiters; this.waiters = []; w.forEach(f => f()); }
  _send(t, data) {
    const d = data ? Buffer.from(data) : Buffer.alloc(0), h = Buffer.alloc(5);
    h[0] = t.charCodeAt(0); h.writeUInt32LE(d.length, 1);
    this.proc.stdin.write(Buffer.concat([h, d]));
  }
  onSysex(fn) { this.listeners.add(fn); return () => this.listeners.delete(fn); }
  sysex(bytes) { this._send('S', bytes); }
  send(cmd, payload) { this.sysex(sysexOf(cmd, payload)); }
  /* attend une trame qui satisfait pred (cherche à partir de l'index from) */
  async waitFrame(pred, ms = 3000, from = 0) {
    const end = Date.now() + ms;
    for (;;) {
      for (let i = from; i < this.frames.length; i++) if (pred(this.frames[i])) { const f = this.frames[i]; this.frames.splice(i, 1); return f; }
      if (this.errors.length) throw new Error('émulateur : ' + this.errors.join(' | '));
      if (this.code != null) throw new Error('émulateur arrêté (code ' + this.code + ')');
      const left = end - Date.now();
      if (left <= 0) return null;
      await new Promise(res => { const tm = setTimeout(res, left); this.waiters.push(() => { clearTimeout(tm); res(); }); });
    }
  }
  clear() { this.frames.length = 0; }
  /* commande -> ACK (true) / NAK (false) / null (rien) ; les autres trames restent disponibles */
  async cmd(cmd, payload, ms = 3000) {
    const from = this.frames.length;                                   /* ignorer les réponses plus anciennes (ex. celles destinées à l'app) */
    this.send(cmd, payload);
    const f = await this.waitFrame(f => (f.cmd === CMD.ACK || f.cmd === CMD.NAK) && f.payload[0] === cmd, ms, from);
    return f ? f.cmd === CMD.ACK : null;
  }
  /* requête à grosse réponse (DATA réassemblées) : PRESET_GET [i] / PRESET_LIST */
  async ask(cmd, payload, type, idx, ms = 4000) {
    const from = this.frames.length;
    this.send(cmd, payload);
    const parts = []; let n = 1;
    const end = Date.now() + ms;
    while (Date.now() < end) {
      const f = await this.waitFrame(f => (f.cmd === CMD.DATA && f.payload[0] === type && f.payload[1] === idx) || (f.cmd === CMD.NAK && f.payload[0] === cmd), end - Date.now(), from);
      if (!f) break;
      if (f.cmd === CMD.NAK) return null;
      n = Math.max(1, f.payload[3]); parts[f.payload[2]] = f.payload.subarray(4);
      let done = true; for (let k = 0; k < n; k++) if (!parts[k]) done = false;
      if (done) return Buffer.concat(parts.slice(0, n));
      this._send('P');                                                  /* laisser proto_poll envoyer la suite */
    }
    return null;
  }
  async json(cmd, payload, type, idx) { const d = await this.ask(cmd, payload, type, idx); return d ? JSON.parse(d.toString('utf8')) : null; }
  async info() { const from = this.frames.length; this.send(CMD.HELLO, { app: 'e2e', proto: 1 }); const f = await this.waitFrame(f => f.cmd === CMD.INFO, 3000, from); return f && JSON.parse(f.payload.toString('utf8')); }
  async host(t, data) {                                                /* 'A' / 'C' : réponse du même type ; sinon accusé 'K' */
    this._send(t, data);
    const typed = t === 'A' || t === 'C' || t === 'D';
    const f = await this.waitFrame(f => typed ? f.host === t : f.host === 'K' && f.payload.toString() === t, 20000);
    if (!f) throw new Error('émulateur : pas de réponse à ' + t);
    return f.payload;
  }
  reboot() { return this.host('B'); }
  saveFlash(file) { return this.host('F', Buffer.from(file, 'utf8')); }
  async audio(n = 48000) { const b = Buffer.alloc(4); b.writeUInt32LE(n); const r = await this.host('A', b); return { inPeak: r.readUInt32LE(0), outPeak: r.readUInt32LE(4), bad: r.readUInt32LE(8) }; }
  /* un bloc seul (modèle m, réglages [[index, valeur]...]) sur n échantillons du signal de test de host.c : { x, y } (Int32Array, Q23) */
  async block(m, params = [], n = 48000) {
    const b = Buffer.alloc(12 + 8 * params.length);
    b.writeUInt32LE(n, 0); b.writeUInt32LE(m, 4); b.writeUInt32LE(params.length, 8);
    params.forEach(([i, v], k) => { b.writeUInt32LE(i, 12 + 8 * k); b.writeFloatLE(v, 16 + 8 * k); });
    const r = await this.host('D', b), all = new Int32Array(r.buffer.slice(r.byteOffset, r.byteOffset + r.length));
    return { x: all.subarray(0, n), y: all.subarray(n) };
  }
  async flashStats() { const r = await this.host('C', null); return { erases: r.readUInt32LE(0), writes: r.readUInt32LE(4), badWrites: r.readUInt32LE(8), refused: r.readUInt32LE(12) }; }
  async close() { try { this._send('Q'); this.proc.stdin.end(); } catch { /* déjà fermé */ } await Promise.race([this.exited, new Promise(r => setTimeout(r, 2000))]); if (this.code == null) this.proc.kill(); }
}

module.exports = { Pedal, CMD, frame, sysexOf, framesOf, pack7, unpack7 };
