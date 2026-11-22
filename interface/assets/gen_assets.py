"""gen_assets.py : exécute gen_assets.html dans Edge sans fenêtre (profil temporaire) et écrit assets.h pour le firmware :
polices 4 bits/pixel (mêmes familles / graisses / tailles que ecran.js) et icônes MODEL_GLYPH en polylignes + cercles.
Usage : python gen_assets.py <sortie assets.h>"""
import json, os, re, subprocess, sys, tempfile, html

here = os.path.dirname(os.path.abspath(__file__))
edge = os.path.join(os.environ.get("ProgramFiles(x86)", r"C:\Program Files (x86)"), r"Microsoft\Edge\Application\msedge.exe")
page = "file:///" + os.path.join(here, "gen_assets.html").replace("\\", "/")
with tempfile.TemporaryDirectory() as prof:
    dom = subprocess.run([edge, "--headless=new", "--disable-gpu", "--no-first-run", "--disable-sync", f"--user-data-dir={prof}",
                          "--allow-file-access-from-files", "--virtual-time-budget=20000", "--dump-dom", page],
                         capture_output=True, timeout=180).stdout.decode("utf-8", "replace")
m = re.search(r'<pre id="out">(.*?)</pre>', dom, re.S)
if not m or m.group(1).startswith("EN COURS"): raise SystemExit("le générateur n'a pas terminé")
D = json.loads(html.unescape(m.group(1)))
bad = [n for n, ok in D["loaded"] if not ok]
if bad: raise SystemExit(f"polices non chargées (police de secours utilisée) : {bad}")

out = ["/* généré par interface/assets/gen_assets.py depuis ecran.js / data.js (Inter, JetBrains Mono : OFL) : NE PAS MODIFIER */",
       "#pragma once",
       "struct gglyph { unsigned short ch; unsigned char w, h; signed char x, y; unsigned short adv16; unsigned int off; };",
       "struct gfont { const struct gglyph *g; unsigned short n; unsigned char px, asc, desc; const unsigned char *data; };"]
for f in D["fonts"]:
    data, glyphs = bytearray(), []
    for g in sorted(f["glyphs"], key=lambda g: g["ch"]):
        off = len(data)
        a = g["a"]
        for i in range(0, len(a), 2): data.append(a[i] | ((a[i + 1] if i + 1 < len(a) else 0) << 4))
        glyphs.append(f"{{{g['ch']},{g['w']},{g['h']},{g['x']},{g['y']},{round(g['adv'] * 16)},{off}}}")
    n = f["name"]
    out.append(f"static const unsigned char F_{n}_data[{max(1, len(data))}] = {{" + ",".join(map(str, data or b'\0')) + "};")
    out.append(f"static const struct gglyph F_{n}_g[{len(glyphs)}] = {{" + ",".join(glyphs) + "};")
    out.append(f"static const struct gfont F_{n} = {{ F_{n}_g, {len(glyphs)}, {f['px']}, {f['asc']}, {f['desc']}, F_{n}_data }};")

# icônes : éléments (type 0 = polyligne, 1 = cercle), points en 1/8 d'unité (0..24 -> 0..192), alpha 0..255
pts, elems, icons, names = [], [], [], list(D["icons"].keys())
for name in names:
    first = len(elems)
    for e in D["icons"][name]:
        al = max(0, min(255, round(e["alpha"] * 255)))
        if e["t"] == "c":
            elems.append(f"{{1,{al},0,{len(pts)}}}")
            pts.extend([round(e["cx"] * 8), round(e["cy"] * 8), round(e["r"] * 8)])
        else:
            q = [(max(0, min(255, round(x * 8))), max(0, min(255, round(y * 8)))) for x, y in e["pts"]]
            elems.append(f"{{0,{al},{len(q)},{len(pts)}}}")
            for x, y in q: pts.extend([x, y])
    icons.append(f"{{{first},{len(elems) - first}}}")
out.append("struct gielem { unsigned char type, alpha, npts; unsigned short off; };")
out.append("struct gicon { unsigned short first, count; };")
out.append(f"static const unsigned char ICON_PTS[{len(pts)}] = {{" + ",".join(map(str, pts)) + "};")
out.append(f"static const struct gielem ICON_EL[{len(elems)}] = {{" + ",".join(elems) + "};")
out.append(f"static const struct gicon ICONS[{len(icons)}] = {{" + ",".join(icons) + "};")
# icône de chaque modèle, dans l'ordre du catalogue (MODELS de data.js = ordre de catalog.h) ; repli = icône de la catégorie
idx = {n: i for i, n in enumerate(names)}
mi = [idx.get(mid, idx.get(D["catIcon"].get(cat, ""), 0)) for mid, cat in D["models"]]
out.append(f"static const unsigned char MODEL_ICON[{len(mi)}] = {{" + ",".join(map(str, mi)) + "};")
open(sys.argv[1], "w", encoding="utf-8").write("\n".join(out) + "\n")
tot = sum(len(f["glyphs"]) for f in D["fonts"])
print(f"assets.h : {len(D['fonts'])} polices ({tot} glyphes), {len(names)} icônes ({len(elems)} éléments, {len(pts)} octets de points)")
