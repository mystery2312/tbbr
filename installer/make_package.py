"""make_package.py <app.bin> <dossier de sortie> : fabrique le paquet de mise à jour TBBR_<version>.tbbr

Un .tbbr est un zip : manifest.json ({"format": 1, "fw": "TBBR fw6 0.7", "sha256": ..., "size": ..., "date": ...}) + app.bin.
L'installateur le vérifie (SHA-256, version présente dans le binaire, taille, structure de l'image) avant d'écrire."""
import datetime
import hashlib
import json
import re
import sys
import zipfile
from pathlib import Path

APP_MAX = 0x5BEE0          # link.ld : la zone application s'arrête avant le stockage (0x60000)


def main():
    app = Path(sys.argv[1]).read_bytes()
    out = Path(sys.argv[2])
    m = re.search(rb"TBBR fw\d+ \d+\.\d+", app)
    if not m:
        raise SystemExit("version TBBR introuvable dans app.bin")
    if len(app) > APP_MAX:
        raise SystemExit("app.bin trop gros")
    fw = m.group().decode()
    man = {"format": 1, "fw": fw, "sha256": hashlib.sha256(app).hexdigest(), "size": len(app),
           "date": datetime.datetime.now().strftime("%Y-%m-%d %H:%M")}
    out.mkdir(parents=True, exist_ok=True)
    name = out / ("TBBR_" + fw.replace("TBBR ", "").replace(" ", "_") + ".tbbr")
    with zipfile.ZipFile(name, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("manifest.json", json.dumps(man, indent=2))
        z.writestr("app.bin", app)
    print(f"paquet : {name} ({name.stat().st_size} o) {fw}")


if __name__ == "__main__":
    main()
