"""isa_probe.py : commande 0x1E, sémantique des MAC à opérande mémoire 16 bits du pi32v2 (isa_probe.S)."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1E, 0xF7]), wait=3.0, port="BlackBox Custom")
names = ["1 += h(3)*0x00010002", "2 += h(-2)*0x00010002", "3 += h(0x4000)*0x40000000", "4 = h(3)*0x00010002",
         "5 += h(3)*[0x00010002]", "6 -1000 >>>= 3", "7 -5*0x40000000 (32x32)",
         "8 d[{0x40000000,0x00010003}] (lo=r0?)", "9 rep r2=3 {copie} : r2 | octets (bas 32 = r2, haut = octets)",
         "10 rep r2=4 {r4 += 1} : r4 | r2"]
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x1E")
        if k < 0: continue
        d = part[k + 5:]
        w = [sum(d[5 * i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF for i in range(len(d) // 5)]
        for i, nm in enumerate(names):
            v = w[2 * i] | (w[2 * i + 1] << 32)
            if v >> 63: v -= 1 << 64
            print(f"{nm:32s} = {v} (0x{v & 0xFFFFFFFFFFFFFFFF:016x})")
        raise SystemExit(0)
print("pas de réponse")
