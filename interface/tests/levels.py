"""levels.py [ids...] : pour chaque modèle (réglages par défaut), coût (% d'un cœur) et niveau de sortie d'une note type
(110 Hz à -14 dBFS + harmoniques) par rapport à l'entrée (commande 0x1A). Sans argument : les modèles d'après schémas."""
import sys, os, re, math
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
CAT = os.path.join(os.path.dirname(__file__), "..", "..", "fw_maison", "fw6", "catalog.h")
ids = {m.group(1).lower(): int(m.group(2)) for m in (re.match(r"#define M_(\w+) (\d+)$", l.strip()) for l in open(CAT, encoding="utf-8")) if m and m.group(1) != "COUNT"}
want = sys.argv[1:] or ["green", "od1", "sd1", "bd2", "gold", "grit", "muff", "usclean", "chime", "brit", "plexi", "rect", "lead51"]
def ask(m):
    got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1A, m, 0xF7]), wait=3.0, port="BlackBox Custom")
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x1A")
            if k >= 0:
                d = part[k + 5:]
                return [sum(d[5 * i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF for i in range(len(d) // 5)]
    return None
# niveau moyen (|x|) de l'entrée de test, Q23
xin = [0.2 * math.sin(2 * math.pi * 110 * i / 48000) + 0.06 * math.sin(4 * math.pi * 110 * i / 48000) + 0.04 * math.sin(6 * math.pi * 110 * i / 48000) for i in range(2400, 9600)]
avg_in = sum(abs(v) for v in xin) / len(xin) * 8388608
base = ask(127)[0]
print(f"grille vide : {base} ms pour 0,4 s")
for mid in want:
    r = ask(ids[mid])
    if not r: print(f"{mid:8s} pas de réponse"); continue
    ms, pk, avg, bad = r[:4]
    cost = max(0, ms - base) / 400 * 100
    print(f"{mid:8s} coût {cost:5.1f} % d'un cœur ; sortie crête {20 * math.log10(max(pk, 1) / 8388608):6.1f} dBFS, "
          f"moyenne {20 * math.log10(max(avg, 1) / avg_in):+6.1f} dB / entrée{'  !! INSTABLE' if bad else ''}")
