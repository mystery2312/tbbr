/* bench_compare.js <ancien pedal_emu.exe> <nouveau pedal_emu.exe> <catalog.h> [sortie.json] : chronomètre chaque modèle (bloc seul,
 * réglages par défaut, commande 'T') dans deux émulateurs. Temps du processeur du PC : utile pour comparer deux versions du
 * moteur, PAS pour les % DSP de la pédale (le PC a une FPU ; sur la pédale, engine.c est en flottant logiciel). */
const { spawn } = require('child_process');
const fs = require('fs');
const [oldExe, newExe, cat, out] = process.argv.slice(2);
const txt = fs.readFileSync(cat, 'utf8');
const names = [...txt.matchAll(/\{ "([^"]+)", CAT_(\w+), \d+, (\d+), \{/g)].map((m, i) => ({ id: i, name: m[1], cat: m[2], dsp: +m[3] }));

function emu(exe) {
  const p = spawn(exe, [], { stdio: ['pipe', 'pipe', 'inherit'] });
  let buf = Buffer.alloc(0), waiter = null;
  p.stdout.on('data', d => {
    buf = Buffer.concat([buf, d]);
    while (buf.length >= 5) {
      const t = String.fromCharCode(buf[0]), len = buf.readUInt32LE(1);
      if (buf.length < 5 + len) break;
      const body = buf.subarray(5, 5 + len); buf = buf.subarray(5 + len);
      if (t === 'T' && waiter) { const w = waiter; waiter = null; w(body.readDoubleLE(0)); }
    }
  });
  return {
    time(model, n = 96000) {
      return new Promise(res => {
        waiter = res;
        const pl = Buffer.alloc(12); pl.writeUInt32LE(n, 0); pl.writeUInt32LE(model, 4); pl.writeUInt32LE(0, 8);
        const h = Buffer.alloc(5); h[0] = 0x54; h.writeUInt32LE(12, 1);
        p.stdin.write(Buffer.concat([h, pl]));
      });
    },
    close() { p.stdin.write(Buffer.from([0x51, 0, 0, 0, 0])); },
  };
}
(async () => {
  const A = emu(oldExe), B = emu(newExe);
  const best = async (e, m) => { let b = 1e9; for (let k = 0; k < 3; k++) b = Math.min(b, await e.time(m)); return b; };
  const baseA = await best(A, 0xFFFF), baseB = await best(B, 0xFFFF);
  const rows = [];
  for (const m of names) {
    if (m.name === 'nam' || m.name === 'ir') continue;
    const a = await best(A, m.id) - baseA, b = await best(B, m.id) - baseB;
    rows.push({ ...m, a, b });
  }
  A.close(); B.close();
  console.log(`grille vide : ancien ${baseA.toFixed(1)} ns/éch, nouveau ${baseB.toFixed(1)} ns/éch`);
  console.log('modèle      cat     dsp actuel   ancien ns   nouveau ns   gain');
  for (const r of rows) console.log(`${r.name.padEnd(11)} ${r.cat.padEnd(7)} ${String(r.dsp).padStart(6)} %   ${r.a.toFixed(1).padStart(8)}   ${r.b.toFixed(1).padStart(9)}   ${(100 * (1 - r.b / r.a)).toFixed(0).padStart(4)} %`);
  if (out) fs.writeFileSync(out, JSON.stringify(rows));
})();
