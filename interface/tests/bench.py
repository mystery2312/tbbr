"""bench.py : commande 0x1F, micro-mesures du cœur (bench.S). Affiche les cycles par instruction utile.
Horloge supposée : 360 MHz (argument 1 pour une autre valeur)."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
mhz = float(sys.argv[1]) if len(sys.argv) > 1 else 360.0
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1F, 0xF7]), wait=5.0, port="BlackBox Custom")
#          nom, tours, opérations utiles par tour
tests = [("boucle vide", 2000000, 1), ("36 MAC h[]*reg (3 acc)", 100000, 36), ("36 MAC h[]*reg (1 acc)", 100000, 36),
         ("36 lectures [r+k]", 100000, 36), ("4 prises noyau (36 MAC + 12 lect.)", 100000, 36),
         ("copie 32 mots", 100000, 32), ("copie 32 mots (rep)", 100000, 32), ("36 MAC reg*reg", 100000, 36),
         ("36 MAC h[]*[mem]", 100000, 36)]
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x1F")
        if k < 0: continue
        d = part[k + 5:]
        ms = [sum(d[5 * i + j] << (7 * j) for j in range(5)) for i in range(len(d) // 5)]
        loop = ms[0] / 2000000 * mhz * 1e3          # cycles par tour de boucle vide
        print(f"boucle vide : {loop:.1f} cycles par tour ({ms[0]} ms)")
        for (nm, n, ops), t in zip(tests[1:], ms[1:]):
            cyc = t * 1e-3 * mhz * 1e6 / n
            print(f"{nm:38s} {t:4d} ms  -> {(cyc - loop) / ops:.2f} cycles / opération")
        raise SystemExit(0)
print("pas de réponse")
