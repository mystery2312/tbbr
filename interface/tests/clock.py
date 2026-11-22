"""clock.py [MHz] : lit (sans argument) ou règle l'horloge du processeur (commande 0x20)."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
mhz = int(sys.argv[1]) if len(sys.argv) > 1 else 0
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x20, mhz & 0x7F, mhz >> 7, 0xF7]), wait=3.0, port="BlackBox Custom")
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x20")
        if k < 0: continue
        d = part[k + 5:]
        def u35(i):
            v = sum(d[i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF
            return v - (1 << 32) if v & 0x80000000 else v
        print(f"résultat {u35(0)}, horloge {u35(5)} MHz")
        raise SystemExit(0)
print("pas de réponse")
