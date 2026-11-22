"""nam_check.py <ref.json> [emplacement] : exécute le test NAM sur la pédale (commande 0x19) et compare à sim_nam.py."""
import sys, os, json, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
raw_ref = open(sys.argv[1], "rb").read()
ref = json.loads(raw_ref.decode("utf-16") if raw_ref[:2] in (b"\xff\xfe", b"\xfe\xff") else raw_ref.decode("utf-8-sig"))
slot = int(sys.argv[2]) if len(sys.argv) > 2 else 0
split = int(sys.argv[3]) if len(sys.argv) > 3 else None          # couches [0, split) sur le 2e cœur
mhz = float(sys.argv[4]) if len(sys.argv) > 4 else 396.0
t0 = time.time()
msg = bytes([0xF0, 0x7D, 0x42, 0x58, 0x19, slot] + ([split] if split is not None else []) + [0xF7])
got = bb_tool.midi_exchange(msg, wait=5.0, port="BlackBox Custom")
print(f"hôte : {time.time() - t0:.2f} s")
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x19")
        if k < 0: continue
        d = part[k + 5:]
        def u35(i): v = sum(d[i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF; return v - (1 << 32) if v & 0x80000000 else v
        out = [u35(5 * i) / 8388608.0 for i in range(32)]
        r, blocs = u35(160), u35(165)
        if len(d) >= 180:
            fr, bk = u35(170), u35(175)
            if fr or bk:
                print(f"moitié avant (2e cœur) {fr} ms = {fr / 144 * 100:.0f} % ; moitié arrière (1er cœur) {bk} ms = {bk / 144 * 100:.0f} %"
                      f"  (cycles/échantillon à {mhz:.0f} MHz : {fr * 1e-3 * mhz * 1e6 / 6912:.0f} + {bk * 1e-3 * mhz * 1e6 / 6912:.0f})")
        elif len(d) >= 175:
            ta, tb = u35(170) & 0xFFFF, u35(170) >> 16
            print(f"étalon : 20 M tours de boucle en {ta} ms ; 2 M tours de (boucle + 40 additions) en {tb} ms")
            loop = ta / 10                                     # ms pour 2 M tours de boucle vide
            if tb > loop:
                per_add = (tb - loop) / 1000 / 80e6            # secondes par addition
                print(f"  -> 1 addition = {per_add * 1e9:.2f} ns -> horloge ~ {1 / per_add / 1e6:.0f} MHz si 1 instruction / cycle")
                if len(d) >= 190:
                    for nom, k in (("lecture pool 0x1C00000", 175), ("lecture GFX 0x1C46000", 180), ("lecture RAM 0x1C3E000", 185),
                                   ("MAC 64 bits", 190), ("mul 32 bits", 195), ("mul float", 200), ("add float", 205), ("lecture double", 210), ("MAC dépendants", 215), ("RAM: add 4 octets", 220), ("RAM: lecture 2 octets", 225), ("RAM: MAC (dépendants)", 230)):
                        if len(d) < k + 5: break
                        v = u35(k); nb, l0 = (80e6, loop) if k < 190 else (20e6, loop / 4)
                        print(f"  {nom} : {(v - l0) / 1000 / nb / per_add:.2f} cycles ({v} ms)")
        print(f"retour {r}, 6 912 échantillons en {blocs} ms (temps réel = 144 ms -> {blocs / 144 * 100:.0f} % d'un coeur)")
        err = max(abs(a - b) for a, b in zip(out, ref))
        print("pédale   :", [round(v, 4) for v in out[:8]])
        print("référence:", [round(v, 4) for v in ref[:8]])
        print(f"écart max {err:.2e} (crête {max(abs(v) for v in ref):.3f})")
        raise SystemExit(0)
print("pas de réponse")

