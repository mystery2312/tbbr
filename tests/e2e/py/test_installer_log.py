"""Journal de diagnostic de l'installateur en anglais (log_to_en) et conseils de dépannage (log_hints), sur des journaux
réels d'utilisateurs ; la progression (secteurs écrits) reste analysée sur la ligne d'origine."""
import os
import re
import sys
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "..", "..", "scripts"))
sys.path.insert(0, os.path.join(HERE, "..", "..", "..", "installer"))
import installer_gui as g

FR = r"""=== 16:39:19 install ===
Construction de l'image à partir de la sauvegarde…
Cabs d'usine (IR) inclus.
Application TBBR : 352608 o, zone utile jusqu'à 0x5a3ff.
Image prête : C:\Users\X\AppData\Local\Temp\tbbr_fw_flash_1MiB.bin
image valide : app_area_head(0x563ff), app.bin(0x56160), cfg_tool.bin(0x17f)
  \\.\D:: WL82 UBOOT1.00 1.00
UBOOT : \\.\D: -> WL82 UBOOT1.00 1.00
lecteur D: (même pédale) mis au repos pendant l'opération (verrou False, démontage False)
loader envoyé (24064 o) à 0x1c02000, saut avec arg 1
loader déjà actif
chip key = 0x980f ; online device type 0x3 id 0xeb6014
zone de stockage [0x60000, 0xa7000) conservée (--tout pour l'écrire aussi) ; cabs d'usine mis à jour
zone lue en 1 s ; secteurs à écrire : ['0xe000', '0xf000']
  erreur USB passagère (lecture 0x0e600 : [Errno 31] IOCTL_SCSI_PASS_THROUGH_DIRECT), nouvel essai
  secteur 0x0e000 écrit et vérifié
  secteur 0x0f000 écrit et vérifié (essai 2)
  secteur 0x10000 : erreur USB ([Errno 31] IOCTL_SCSI_PASS_THROUGH_DIRECT), nouvel essai
  secteur 0x11000 : relecture différente, nouvel essai
ÉCRITURE TERMINÉE ET VÉRIFIÉE (zone application = image, sha256 11d4892b854afbf1)
reboot.bin en RAM vérifié, saut...
pas de réponse au saut ([Errno 121] IOCTL_SCSI_PASS_THROUGH_DIRECT) : normal, la puce redémarre
Pédale TBBR détectée : passage en mode mise à jour…
Pédale M-VAVE détectée : passage en mode UBOOT…
envoyé f0 00 32 45 00 00 00 40 7f f7 | reçu ['f0 00']
identité : BlackBox_019
Mode UBOOT détecté.
attente du mode mise à jour… (15 s)
  passe 1 : 128 Ko
  erreur lecture 0x3f600 ([Errno 31] IOCTL_SCSI_PASS_THROUGH_DIRECT), nouvel essai
passe 1 terminée en 3.4 s, sha256 4df47afe
SAUVEGARDE OK : C:\Users\X\Documents\BlackBox Backup\BlackBox_2026-11-25_145443
ERREUR : Le mode mise à jour (UBOOT) n'est pas apparu en 90 s.
--- Que faire ?"""

en = g.log_to_en(FR)
print(en)
# aucun mot français courant ne doit rester (hors chemins de fichiers et noms propres)
left = [l for l in en.split("\n") if re.search(r"(?i)\b(pédale|secteur|écrit|vérifié|zone|lecture|écriture|essai|passe |sauvegarde|détecté|envoyé|reçu|attente|redémarre|ERREUR|mis au repos|conservée|à écrire)\b", l)
        and "Backup" not in l]
assert not left, "lignes non traduites :\n" + "\n".join(left)
for want in ["sector 0x0e000 written and verified", "sector 0x0f000 written and verified (attempt 2)", "temporary USB error (read 0x0e600",
             "area read in 1 s; sectors to write: ['0xe000', '0xf000']", "WRITE FINISHED AND VERIFIED (application area = image",
             "Update (UBOOT) mode did not appear within 90 s.", "TBBR pedal detected: switching to update mode", "pass 1: 128 KB",
             "drive D: (same pedal) set aside during the operation (lock False, dismount False)", "ERROR: ", "BACKUP OK:"]:
    assert want in en, "absent : " + want

# conseils de dépannage selon l'erreur
for msg, key in [("Le mode mise à jour (UBOOT) n'est pas apparu en 90 s.", "HOME"), ("[Errno 31] IOCTL_SCSI_PASS_THROUGH_DIRECT", "cable"),
                 ("pas encore répondu", "switch it back on"), ("Aucune pédale détectée. Branche l'USB", "MIDI"),
                 ("ÉCHEC au secteur 0xd000 : NE PAS éteindre", "Do NOT switch"), ("autre chose", "issue")]:
    tips = g.log_hints(msg)
    assert any(key in en_ for _, en_ in tips), f"conseil manquant pour {msg!r}"
    assert all(fr and en_ for fr, en_ in tips)

# progression : la ligne d'origine (française) est analysée même quand le journal est traduit
class App:
    lang = "en"; logs = []; sectors_total = sectors_done = 0
    task = {"pct": None, "line": ""}
    add_log = lambda self, s: self.logs.append(g.log_to_en(s))
    parse_line = g.WebApp.parse_line
app = App()
cap = g.OutCapture(app)
print("zone lue en 1 s ; secteurs à écrire : ['0xe000', '0xf000']", file=cap)
print("  secteur 0x0e000 écrit et vérifié", file=cap)
cap.write("  secteur 0x0f000 écrit"); cap.write(" et vérifié\n")
assert app.task["pct"] == 100.0, app.task
assert app.logs[-1].strip() == "sector 0x0f000 written and verified", app.logs
assert app.task["line"] == "sector 0x0f000 written and verified"

# intégration : vraie tâche de l'installateur qui échoue (interface en anglais) -> journal anglais + « What to do? »
import tempfile, time
g.LOG_FILE = __import__("pathlib").Path(tempfile.mkdtemp()) / "installer.log"     # ne pas toucher au journal réel du PC
w = g.WebApp.__new__(g.WebApp)
g.WebApp.__init__(w)
w.lang, w.consent = "en", True
w.detect = lambda *a, **k: None                                       # pas d'accès USB pendant le test
w.PHASES = dict(w.PHASES, test=["uboot"])
def fail():
    print("Pédale TBBR détectée : passage en mode mise à jour…")
    raise RuntimeError("Le mode mise à jour (UBOOT) n'est pas apparu en 90 s.")
w.run_task("test", fail)
for _ in range(100):
    if not w.busy: break
    time.sleep(0.05)
log = "".join(w.logs)
assert "TBBR pedal detected: switching to update mode" in log and "ERROR: Update (UBOOT) mode did not appear within 90 s." in log, log
assert "--- What to do?" in log and "holding HOME" in log, log
assert w.task["msg"] == "Update (UBOOT) mode did not appear within 90 s.", w.task
assert "TBBR Installer" in log and "Windows" in log, "contexte de diagnostic absent"
print("OK")
