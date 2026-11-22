"""make_static.py : fabrique index.html et ecran.html à partir des .php (sans PHP : remplace <?= asset('x') ?> par x?v=<mtime>).
Le serveur PHP reste la référence en production (cache nginx) ; ceci sert à l'usage local (serve.py) et aux tests."""
import os, re
here = os.path.dirname(os.path.abspath(__file__))
for name in ("index", "ecran"):
    src = open(os.path.join(here, name + ".php"), encoding="utf-8").read()
    src = re.sub(r"^<\?php.*?\?>\s*", "", src, flags=re.S)                     # bloc PHP d'en-tête (fonction asset)
    src = re.sub(r"<\?=\s*asset\('([^']+)'\)\s*\?>",
                 lambda m: m.group(1) + "?v=" + str(int(os.path.getmtime(os.path.join(here, m.group(1))))), src)
    src = src.replace("ecran.php", "ecran.html").replace("index.php", "index.html")
    if "<?" in src: raise SystemExit(f"{name}.php : PHP restant non géré")
    open(os.path.join(here, name + ".html"), "w", encoding="utf-8").write(src)
    print(f"{name}.html OK")
