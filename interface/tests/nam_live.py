"""nam_live.py [lane col [secondes]] : place un bloc NAM (commande 0x1C, sans contrôle DSP) puis relève les compteurs temps réel :
retards audio (RB[5]), surcharges (RB[20]), charge du 1er cœur (RB[14], RB[15]), blocs et tours d'attente du 2e cœur."""
import sys, os, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
lane = int(sys.argv[1]) if len(sys.argv) > 1 else 0
col = int(sys.argv[2]) if len(sys.argv) > 2 else 1
secs = float(sys.argv[3]) if len(sys.argv) > 3 else 10.0
M_NAM = int(sys.argv[4]) if len(sys.argv) > 4 else 15
def peek(a):
    got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x15]) + bytes(((a >> (7 * i)) & 0x7F) for i in range(5)) + b"\xF7",
                                wait=1.0, port="BlackBox Custom")
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x15")
            if k < 0: continue
            s = part[k + 5:]; out = bytearray(); i = 0
            while i < len(s):
                hi = s[i]; i += 1
                for j in range(7):
                    if i >= len(s): break
                    out.append((s[i] & 0x7F) | (((hi >> j) & 1) << 7)); i += 1
            return [int.from_bytes(out[q:q + 4], "little") for q in range(0, len(out) - 3, 4)]
    raise SystemExit("pas de réponse au PEEK")
def snap():
    rb = peek(0x1C70000) + peek(0x1C70040)
    mb = peek(0x1C72000)
    return dict(halves=rb[3], overruns=rb[5], load=rb[14], loadmax=rb[15], overloads=rb[20], c1blocks=mb[8], c1idle=mb[9])
if lane >= 0:
    r = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1C, lane, col, M_NAM, 0xF7]), wait=3.0, port="BlackBox Custom")
    print("bloc NAM forcé :", r)
    time.sleep(2.0)
a = snap(); t0 = time.time()
time.sleep(secs)
b = snap(); dt = time.time() - t0
d = {k: b[k] - a[k] for k in a}
print(f"sur {dt:.1f} s : demi-blocs {d['halves']} ({d['halves'] / dt:.0f}/s), retards audio {d['overruns']}, surcharges {d['overloads']},"
      f" blocs du 2e cœur {d['c1blocks']} ({d['c1blocks'] / dt:.0f}/s), tours d'attente du 2e cœur {d['c1idle']}")
print(f"charge 1er cœur : {b['load']} % (max {b['loadmax']} %)")
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x21, 0xF7]), wait=1.0, port="BlackBox Custom")
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x21")
        if k < 0: continue
        d = part[k + 5:]
        w = [sum(d[5 * i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF for i in range(len(d) // 5)]
        names = ["pos", "on", "slot", "kind", "mem", "msize", "hist0", "offload_col", "c1_alive", "pool1", "pool2",
                 "c1_timeouts", "nsec", "p_slot"]
        print("état NAM :", ", ".join(f"{n}={v:#x}" if n in ("mem", "hist0", "pool1", "pool2") else f"{n}={v if v < 0x80000000 else v - (1 << 32)}"
                                      for n, v in zip(names, w)))
