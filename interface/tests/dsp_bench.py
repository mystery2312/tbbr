"""dsp_bench.py [--ecrire] : mesure sur la pédale le coût de chaque modèle (commande SysEx 0x1A), calcule son % DSP
et, avec --ecrire, met à jour les champs « dsp: » de interface/app/js/data.js (source unique : app + firmware via gen_catalog.js).

Budget : 100 % DSP = la part du 1er cœur laissée aux effets = (CIBLE - charge de base mesurée sur la pédale).
Chaque mesure : 19 200 échantillons (0,4 s d'audio) d'un bloc seul aux réglages par défaut, chronométrés à 1 ms près.
Le NAM est mesuré à part (commande 0x19) : il est réparti sur les 2 cœurs, son « dsp » = sa moitié arrière (1er cœur) ;
la moitié avant (2e cœur) est affichée pour NAM_C1_PCT (engine.c).
Après la mesure, la pédale a une grille vide : renvoyer un preset depuis l'app."""
import sys, os, re, math
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool

HERE = os.path.dirname(os.path.abspath(__file__))
CAT = os.path.join(HERE, "..", "..", "fw_maison", "fw6", "catalog.h")
DATA = os.path.join(HERE, "..", "app", "js", "data.js")
N, AUDIO_MS = 19200, 400.0
CIBLE = 85.0          # % du 1er cœur qu'on s'autorise au total (marge pour USB, écran, pics au changement de preset)
BASE_MESUREE = 0      # rempli plus bas

def u35(d, i):
    v = sum(d[i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF
    return v - (1 << 32) if v & 0x80000000 else v

def ask(cmd, arg, wait):
    got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, cmd, arg, 0xF7]), wait=wait, port="BlackBox Custom")
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(bytes([0xF0, 0x7D, 0x42, 0x58, cmd]))
            if k >= 0: return part[k + 5:]
    return None

ids = {}
for line in open(CAT, encoding="utf-8"):
    m = re.match(r"#define M_(\w+) (\d+)$", line.strip())
    if m and m.group(1) != "COUNT": ids[int(m.group(2))] = m.group(1).lower()
names = [re.match(r'\s*\{ "([^"]+)", CAT_', l).group(1) for l in open(CAT, encoding="utf-8") if re.match(r'\s*\{ "([^"]+)", CAT_\w+, \d+, \d+, \{', l)]

d = ask(0x1A, 127, 3.0)
base_ms = u35(d, 0)
print(f"grille vide (entrée, sortie, maître) : {base_ms} ms / {AUDIO_MS:.0f} ms = {base_ms / AUDIO_MS * 100:.1f} % d'un coeur")
res = {}
for i, mid in enumerate(names):
    if mid == "nam": continue
    d = ask(0x1A, i, 3.0)
    if d is None: print(f"{mid:10s} pas de réponse"); continue
    ms = u35(d, 0) - base_ms
    res[mid] = max(0.0, ms / AUDIO_MS * 100)
    print(f"{mid:10s} {res[mid]:5.1f} % d'un coeur")
# NAM brut réparti sur les 2 cœurs (commande 0x19, emplacement NAM_SLOT, coupure NAM_SPLIT) : moitié arrière = 1er cœur
NAM_SLOT, NAM_SPLIT = int(os.environ.get("BB_NAM_SLOT", "1")), int(os.environ.get("BB_NAM_SPLIT", "18"))
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x19, NAM_SLOT, NAM_SPLIT, 0xF7]), wait=6.0, port="BlackBox Custom")
d = None
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(bytes([0xF0, 0x7D, 0x42, 0x58, 0x19]))
        if k >= 0: d = part[k + 5:]
nam_core = nam_c1 = None
if d and len(d) >= 180 and u35(d, 160) == 0:
    nam_c1, nam_core = u35(d, 170) / 144.0 * 100, u35(d, 175) / 144.0 * 100
    res["nam"] = nam_core
    print(f"nam        {nam_core:5.1f} % d'un coeur (moitié arrière) ; moitié avant {nam_c1:.0f} % du 2e coeur -> NAM_C1_PCT")
else: print("nam : pas de réponse ou erreur")

# charge de base du système en marche (USB, écran, entrée/sortie) : mesurée par la pédale avec une grille vide = « charge » de bbc state
BASE_SYS = float(os.environ.get("BB_BASE", "20"))
budget = CIBLE - BASE_SYS
dsp = {k: max(1, math.ceil(v / budget * 100)) for k, v in res.items()}
print(f"\nbudget effets = {CIBLE:.0f} % - base {BASE_SYS:.0f} % = {budget:.0f} % d'un coeur ; % DSP par modèle :")
print("  " + ", ".join(f"{k} {v}" for k, v in dsp.items()))

if "--ecrire" in sys.argv:
    t = open(DATA, encoding="utf-8").read()
    for k, v in dsp.items():
        t, n = re.subn(r"(\{ id: '" + re.escape(k) + r"',[^\n]*?dsp: )\d+", lambda m: m.group(1) + str(v), t)
        if n != 1: print("  ! modèle introuvable dans data.js :", k)
    open(DATA, "w", encoding="utf-8").write(t)
    print("data.js mis à jour")
