#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Installateur Windows pour la M-VAVE BlackBox (firmware TBBR).

Trois actions, dans l'ordre :
  1. sauvegarde complète de la flash d'origine (1 Mio, lue deux fois) ;
  2. installation du firmware TBBR (app.bin embarqué, image construite avec la sauvegarde) ;
  3. restauration complète de la sauvegarde (SPL/bootloader jamais touché).

L'interface ne fait rien de dangereux sans confirmation. Le dossier de sauvegarde
est mémorisé dans %APPDATA%\\TBBR\\installer.json.
"""
import datetime
import hashlib
import json
import os
import queue
import shutil
import sys
import tempfile
import threading
import time
import traceback
from pathlib import Path

import tkinter as tk
from tkinter import filedialog, messagebox, ttk

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT / "scripts"))

import bb_tool
import mkfw

APP_TITLE = "BlackBox — Installateur TBBR"
APP_VERSION = "1.1"
LANG = "fr"
BACKUP_FILE = "flash_full_1MiB.bin"
FLASH_SIZE = 0x100000
APP_BASE = 0x4000


def resource(name):
    base = Path(getattr(sys, "_MEIPASS", HERE))
    return base / "resources" / name


# Les binaires du loader et du redémarrage sont embarqués dans l'exe.
bb_tool.LOADER = str(resource("wl82loader.bin"))
bb_tool.REBOOT = str(resource("reboot.bin"))
APP_BIN = resource("app.bin")

CONFIG_DIR = Path(os.environ.get("APPDATA", str(Path.home()))) / "TBBR"
CONFIG_FILE = CONFIG_DIR / "installer.json"
LOG_FILE = CONFIG_DIR / "installer.log"


def now_name():
    return datetime.datetime.now().strftime("%Y-%m-%d_%H%M%S")


def sha256_file(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for b in iter(lambda: f.read(1 << 20), b""):
            h.update(b)
    return h.hexdigest()


def backup_kind(path):
    """Devine le type de firmware contenu dans une sauvegarde (lecture seule)."""
    try:
        data = Path(path).read_bytes()
        if len(data) != FLASH_SIZE:
            return "taille inattendue"
        area = mkfw.sfc(data[APP_BASE:])
        if b"TBBR fw" in area:
            return "firmware TBBR"
        if b"BlackBox_0" in area:
            return "firmware M-VAVE d'origine"
        return "firmware inconnu"
    except Exception:
        return "illisible"


# ---------------------------------------------------------------- opérations communes (GUI + CLI)
# Depuis le firmware M-VAVE, l'accès à la flash ne marche qu'en V19 (en 022/023, la pédale part dans un mode de
# récupération sans accès à la flash) : il faut d'abord réinstaller la V19 officielle avec M-UPGRADE.
NEED_V19 = ("Ta pédale n'est pas en firmware M-VAVE V19. Installe d'abord la V19 officielle avec M-UPGRADE "
            "(voir la documentation : https://mystery2312.github.io/tbbr/doc.html#v19), puis relance.\n\n"
            "Your pedal is not on M-VAVE firmware V19. First install the official V19 with M-UPGRADE "
            "(see the documentation: https://mystery2312.github.io/tbbr/doc.html#v19), then try again.")


def mvave_version(name):
    import re as _re
    m = _re.search(r"_0*(\d+)", name or "")
    return int(m.group(1)) if m else None


def enter_uboot():
    if bb_tool.find_uboot(verbose=False):
        return
    ins, outs = bb_tool.midi_ports()
    if "BlackBox Custom" in outs:
        print("Pédale TBBR détectée : passage en mode mise à jour…")
        bb_tool.midi_exchange(bytes.fromhex("F07D42587E552AF7"), wait=1.0, port="BlackBox Custom")
    elif "USB-Midi" in outs:
        print("Pédale M-VAVE détectée : passage en mode UBOOT…")
        name = bb_tool.identify()
        print("identité :", name)
        if not name or not name.startswith("BlackBox"):
            raise RuntimeError("La pédale ne répond pas comme une BlackBox (" + repr(name) + ").")
        if mvave_version(name) != 19:
            raise RuntimeError(NEED_V19)
        bb_tool.midi_exchange(bb_tool.SOFT_KEY, wait=0.7, port="USB-Midi")
    else:
        raise RuntimeError("Aucune pédale détectée. Branche l'USB, allume la pédale, puis réessaie.")
    for _ in range(60):
        time.sleep(0.5)
        if bb_tool.find_uboot(verbose=False):
            time.sleep(0.5)
            print("Mode UBOOT détecté.")
            return
    raise RuntimeError("Le mode UBOOT n'est pas apparu. Débranche/rebranche l'USB, puis réessaie.")


def wait_custom(seconds=25):
    end = time.time() + seconds
    while time.time() < end:
        try:
            ins, outs = bb_tool.midi_ports()
            if "BlackBox Custom" in outs:
                got = bb_tool.midi_exchange(bytes.fromhex("F07D425801F7"), wait=1.2, port="BlackBox Custom")
                if got:
                    return True
        except Exception:
            pass
        time.sleep(0.7)
    return False


def wait_original(seconds=25):
    end = time.time() + seconds
    while time.time() < end:
        try:
            ins, outs = bb_tool.midi_ports()
            if "USB-Midi" in outs:
                name = bb_tool.identify()
                if name.startswith("BlackBox"):
                    return name
        except Exception:
            pass
        time.sleep(0.7)
    return None


def read_package(blob):
    """Paquet de mise à jour .tbbr (zip : manifest.json + app.bin) -> (version, app.bin) ; lève ValueError s'il est invalide."""
    import io
    import re as _re
    import zipfile
    try:
        with zipfile.ZipFile(io.BytesIO(blob)) as z:
            man = json.loads(z.read("manifest.json").decode("utf-8"))
            app = z.read("app.bin")
            cabs = z.read("cabs.bin") if "cabs.bin" in z.namelist() else None
    except Exception:
        raise ValueError("fichier .tbbr illisible")
    if man.get("format") != 1 or hashlib.sha256(app).hexdigest() != man.get("sha256") or len(app) != man.get("size"):
        raise ValueError("paquet corrompu (SHA-256 ou taille)")
    if cabs is not None and hashlib.sha256(cabs).hexdigest() != man.get("cabs_sha256"):
        raise ValueError("cabs d'usine corrompus (SHA-256)")
    m = _re.search(rb"TBBR fw\d+ \d+\.\d+", app)
    if not m or m.group().decode() != man.get("fw"):
        raise ValueError("ce n'est pas un firmware TBBR")
    if len(app) > 0x5BEE0:
        raise ValueError("firmware trop gros pour la zone application")
    return man["fw"], app, cabs


CABS_BIN = resource("cabs.bin")                                       # cabs d'usine (IR) inclus dans l'installateur


def build_image(backup_dir, app=None, cabs=None):
    backup = Path(backup_dir) / BACKUP_FILE
    data = backup.read_bytes()
    if len(data) != FLASH_SIZE:
        raise RuntimeError("Sauvegarde de taille incorrecte.")
    app = app or APP_BIN.read_bytes()
    if not app:
        raise RuntimeError("app.bin embarqué absent.")
    app += b"\0" * (-len(app) % 32)
    print("Construction de l'image à partir de la sauvegarde…")
    img, end = mkfw.build(data, app)
    cabs = cabs or (CABS_BIN.read_bytes() if CABS_BIN.exists() else None)
    if cabs:
        img = mkfw.place_cabs(img, cabs)
        print("Cabs d'usine (IR) inclus.")
    print(f"Application TBBR : {len(app)} o, zone utile jusqu'à {APP_BASE + end:#x}.")
    tmp = Path(tempfile.gettempdir()) / "tbbr_fw_flash_1MiB.bin"
    tmp.write_bytes(img)
    print("Image prête :", tmp)
    return tmp, data


class QueueWriter:
    def __init__(self, q):
        self.q = q

    def write(self, s):
        if s:
            self.q.put(("log", s))

    def flush(self):
        pass


class Installer:
    def __init__(self, root):
        self.root = root
        self.q = queue.Queue()
        self.busy = False
        self.backup_dir = None
        self.backup_parent = Path.home() / "Documents" / "BlackBox Backup"
        self.last_error = ""
        self.btn_backup = self.btn_install = self.btn_restore = self.btn_detect = None
        self.btn_lang_fr = self.btn_lang_en = None
        self.device_label = None
        self.backup_label = None
        self.progress = None
        self.txt = None
        self.parent_var = None
        self.outer = None
        self.device_text = None
        self.device_color = "#555"
        self.log_history = []
        self.lang = "fr"
        self.load_lang()

        root.title(self.tr("BlackBox — Installateur TBBR", "BlackBox — TBBR Installer") + " " + APP_VERSION)
        root.geometry("860x680")
        root.minsize(760, 600)
        root.protocol("WM_DELETE_WINDOW", self.on_close)
        self.build_ui()
        self.load_config()
        self.root.after(150, self.poll)
        self.root.after(350, self.detect)

    # ------------------------------------------------------------------ UI
    def tr(self, fr, en):
        return en if self.lang == "en" else fr

    def load_lang(self):
        try:
            cfg = json.loads(CONFIG_FILE.read_text(encoding="utf-8-sig"))
            if cfg.get("lang") in ("fr", "en"):
                self.lang = cfg["lang"]
        except Exception:
            pass

    def set_lang(self, lang):
        if self.busy or lang not in ("fr", "en") or lang == self.lang:
            return
        self.lang = lang
        self.save_config()
        self.build_ui()
        self.refresh_backup_info()
        self.refresh_buttons()

    def build_ui(self):
        if self.outer is not None:
            self.outer.destroy()
        style = ttk.Style()
        try:
            style.theme_use("clam")
        except tk.TclError:
            pass
        style.configure("Title.TLabel", font=("Segoe UI", 20, "bold"))
        style.configure("Sub.TLabel", font=("Segoe UI", 10))
        style.configure("Step.TLabelframe.Label", font=("Segoe UI", 11, "bold"))
        style.configure("Go.TButton", font=("Segoe UI", 10, "bold"))

        outer = ttk.Frame(self.root, padding=16)
        outer.pack(fill="both", expand=True)
        self.outer = outer

        head = ttk.Frame(outer)
        head.pack(fill="x")
        ttk.Label(head, text=self.tr("BlackBox — Installateur TBBR", "BlackBox — TBBR Installer"), style="Title.TLabel").pack(side="left", anchor="w")
        langbar = ttk.Frame(head)
        langbar.pack(side="right")
        ttk.Label(langbar, text=self.tr("Langue", "Language") + " :").pack(side="left", padx=(0, 6))
        self.btn_lang_fr = ttk.Button(langbar, text="FR", width=3, command=lambda: self.set_lang("fr"))
        self.btn_lang_fr.pack(side="left")
        self.btn_lang_en = ttk.Button(langbar, text="EN", width=3, command=lambda: self.set_lang("en"))
        self.btn_lang_en.pack(side="left", padx=(4, 0))

        ttk.Label(outer, text=self.tr(
            "Sauvegarde, installation et restauration du firmware de la pédale. Ne débranche jamais l'USB pendant une écriture.",
            "Back up, install and restore the pedal firmware. Never unplug USB while writing."),
                  style="Sub.TLabel", foreground="#555").pack(anchor="w", pady=(2, 10))

        status = ttk.Frame(outer)
        status.pack(fill="x", pady=(0, 10))
        self.device_label = ttk.Label(status, text=self.device_text or self.tr("Recherche de la pédale…", "Looking for the pedal…"),
                                      font=("Segoe UI", 10, "bold"), foreground=self.device_color)
        self.device_label.pack(side="left")
        self.btn_detect = ttk.Button(status, text=self.tr("Détecter", "Detect"), command=self.detect)
        self.btn_detect.pack(side="right")

        # 1. sauvegarde
        f1 = ttk.LabelFrame(outer, text=self.tr(" 1 · Sauvegarder le firmware d'origine ", " 1 · Back up the original firmware "),
                            style="Step.TLabelframe", padding=10)
        f1.pack(fill="x", pady=4)
        ttk.Label(f1, text=self.tr(
            "À faire en premier. La flash complète (1 Mio) est lue deux fois, comparée, puis enregistrée. C'est le filet de sécurité pour revenir au firmware M-VAVE.",
            "Do this first. The full flash (1 MiB) is read twice, compared and saved. This is your safety net to return to the M-VAVE firmware."),
                  wraplength=790).pack(anchor="w")
        row = ttk.Frame(f1)
        row.pack(fill="x", pady=(8, 0))
        self.parent_var = tk.StringVar(value=str(self.backup_parent))
        ttk.Label(row, text=self.tr("Dossier :", "Folder:")).pack(side="left")
        ttk.Entry(row, textvariable=self.parent_var, state="readonly").pack(side="left", fill="x", expand=True, padx=6)
        ttk.Button(row, text=self.tr("Choisir…", "Choose…"), command=self.choose_parent).pack(side="left")
        self.btn_backup = ttk.Button(row, text=self.tr("Sauvegarder maintenant", "Back up now"),
                                     style="Go.TButton", command=self.do_backup)
        self.btn_backup.pack(side="left", padx=(8, 0))

        # 2. installation
        f2 = ttk.LabelFrame(outer, text=self.tr(" 2 · Installer le firmware TBBR ", " 2 · Install the TBBR firmware "),
                            style="Step.TLabelframe", padding=10)
        f2.pack(fill="x", pady=4)
        ttk.Label(f2, text=self.tr(
            "Le firmware TBBR est inclus dans l'installateur : aucun fichier à chercher. L'image est construite à partir de TA sauvegarde, donc le bootloader et les données propres à la pédale restent intacts. La sauvegarde est obligatoire avant cette étape.",
            "The TBBR firmware is included in the installer: no file to look for. The image is built from YOUR backup, so the bootloader and this pedal's own data stay intact. A backup is required before this step."),
                  wraplength=790).pack(anchor="w")
        row2 = ttk.Frame(f2)
        row2.pack(fill="x", pady=(8, 0))
        self.backup_label = ttk.Label(row2, text=self.tr("Aucune sauvegarde sélectionnée", "No backup selected"),
                                      foreground="#a33", wraplength=780, justify="left")
        self.backup_label.pack(anchor="w", fill="x")
        actions2 = ttk.Frame(f2)
        actions2.pack(fill="x", pady=(8, 0))
        ttk.Button(actions2, text=self.tr("Choisir une autre sauvegarde…", "Choose another backup…"),
                   command=self.choose_backup).pack(side="left")
        self.btn_install = ttk.Button(actions2, text=self.tr("Installer le firmware TBBR", "Install TBBR firmware"),
                                      style="Go.TButton", command=self.do_install, state="disabled")
        self.btn_install.pack(side="right")

        # 3. restauration
        f3 = ttk.LabelFrame(outer, text=self.tr(" 3 · Restaurer le firmware d'origine ", " 3 · Restore the original firmware "),
                            style="Step.TLabelframe", padding=10)
        f3.pack(fill="x", pady=4)
        ttk.Label(f3, text=self.tr(
            "Réécrit la flash complète à partir de la sauvegarde (SPL/bootloader exclu). Les presets, IR et captures NAM du firmware TBBR sont remplacés par ceux de la sauvegarde.",
            "Rewrites the full flash from the backup (SPL/bootloader excluded). Presets, IRs and NAM captures from the TBBR firmware are replaced by the backup's."),
                  wraplength=790).pack(anchor="w")
        row3 = ttk.Frame(f3)
        row3.pack(fill="x", pady=(8, 0))
        ttk.Button(row3, text=self.tr("Ouvrir le dossier de sauvegarde", "Open backup folder"),
                   command=self.open_backup_folder).pack(side="left")
        self.btn_restore = ttk.Button(row3, text=self.tr("Restaurer la sauvegarde", "Restore backup"),
                                      command=self.do_restore, state="disabled")
        self.btn_restore.pack(side="right")

        # progression + journal
        self.progress = ttk.Progressbar(outer, mode="indeterminate")
        self.progress.pack(fill="x", pady=(10, 6))
        ttk.Label(outer, text=self.tr("Journal", "Log"), font=("Segoe UI", 9, "bold")).pack(anchor="w")
        logframe = ttk.Frame(outer)
        logframe.pack(fill="both", expand=True)
        self.txt = tk.Text(logframe, height=13, wrap="word", state="disabled",
                           font=("Consolas", 9), background="#101216", foreground="#d7dde5",
                           insertbackground="#d7dde5")
        sb = ttk.Scrollbar(logframe, command=self.txt.yview)
        self.txt.configure(yscrollcommand=sb.set)
        self.txt.pack(side="left", fill="both", expand=True)
        sb.pack(side="right", fill="y")
        if self.log_history:
            self.txt.configure(state="normal")
            self.txt.insert("end", "".join(self.log_history))
            self.txt.see("end")
            self.txt.configure(state="disabled")

        ttk.Label(outer, text=self.tr(
            "Le firmware TBBR n'est pas un firmware officiel M-VAVE. Garde la sauvegarde : elle permet de revenir à l'état d'origine.",
            "TBBR is not an official M-VAVE firmware. Keep the backup: it lets you return to the original state."),
                  foreground="#666").pack(anchor="w", pady=(8, 0))
        self.refresh_backup_info()
        self.refresh_buttons()

    def load_config(self):
        try:
            cfg = json.loads(CONFIG_FILE.read_text(encoding="utf-8-sig"))
            parent = cfg.get("backup_parent")
            if parent:
                self.backup_parent = Path(parent)
                self.parent_var.set(str(self.backup_parent))
            last = cfg.get("last_backup")
            if last and (Path(last) / BACKUP_FILE).exists():
                self.set_backup(Path(last))
            else:
                self.find_latest_backup()
        except Exception:
            self.find_latest_backup()

    def save_config(self):
        try:
            CONFIG_DIR.mkdir(parents=True, exist_ok=True)
            CONFIG_FILE.write_text(json.dumps({
                "backup_parent": str(self.backup_parent),
                "last_backup": str(self.backup_dir) if self.backup_dir else None,
                "lang": self.lang,
            }, indent=2), encoding="utf-8")
        except Exception:
            pass

    def log(self, s):
        if not s:
            return
        self.log_history.append(s)
        if len(self.log_history) > 4000:
            self.log_history = self.log_history[-3000:]
        try:
            self.txt.configure(state="normal")
            self.txt.insert("end", s)
            self.txt.see("end")
            self.txt.configure(state="disabled")
        except tk.TclError:
            return
        try:
            CONFIG_DIR.mkdir(parents=True, exist_ok=True)
            with open(LOG_FILE, "a", encoding="utf-8") as f:
                f.write(s)
        except Exception:
            pass

    def poll(self):
        try:
            while True:
                kind, data = self.q.get_nowait()
                if kind == "log":
                    self.log(data)
                elif kind == "device":
                    self.apply_device(*data)
                elif kind == "backup":
                    self.set_backup(Path(data))
                elif kind == "error":
                    self.last_error = data
                    self.log(self.tr("\nERREUR : ", "\nERROR: ") + data + "\n")
                    messagebox.showerror(self.tr("Erreur", "Error"), data[:1800])
                elif kind == "done":
                    self.finish_task()
        except queue.Empty:
            pass
        self.root.after(100, self.poll)

    def set_busy(self, busy):
        self.busy = busy
        state = "disabled" if busy else "normal"
        for b in (self.btn_backup, self.btn_install, self.btn_restore, self.btn_detect,
                  self.btn_lang_fr, self.btn_lang_en):
            if b:
                b.configure(state=state)
        if busy:
            self.progress.start(12)
        else:
            self.progress.stop()
            self.refresh_buttons()

    def finish_task(self):
        self.set_busy(False)

    def refresh_buttons(self):
        ok = bool(self.backup_dir and (self.backup_dir / BACKUP_FILE).exists())
        self.btn_install.configure(state="normal" if ok and not self.busy else "disabled")
        self.btn_restore.configure(state="normal" if ok and not self.busy else "disabled")

    def run_task(self, title, fn):
        if self.busy:
            return
        self.set_busy(True)
        self.log("\n=== " + title + " ===\n")

        def worker():
            old = sys.stdout
            sys.stdout = QueueWriter(self.q)
            try:
                fn()
            except SystemExit as e:
                self.q.put(("error", str(e)))
            except Exception:
                self.q.put(("error", traceback.format_exc()))
            finally:
                sys.stdout = old
                self.q.put(("done", None))

        threading.Thread(target=worker, daemon=True).start()

    # ------------------------------------------------------------------ détection
    def detect(self):
        if self.busy:
            return
        self.device_text = self.tr("Recherche de la pédale…", "Looking for the pedal…")
        self.device_color = "#555"
        self.device_label.configure(text=self.device_text, foreground=self.device_color)

        def worker():
            try:
                ub = bb_tool.find_uboot(verbose=False)
                ins, outs = bb_tool.midi_ports()
            except Exception:
                ub, ins, outs = [], [], []
            self.q.put(("device", (ub, ins, outs)))

        threading.Thread(target=worker, daemon=True).start()

    def apply_device(self, ub, ins, outs):
        if ub:
            self.device_text = self.tr("Pédale en mode UBOOT — prête pour sauvegarde / flash / restauration.",
                                       "Pedal in UBOOT mode — ready to back up / flash / restore.")
            self.device_color = "#1d7a3a"
        elif "BlackBox Custom" in outs:
            self.device_text = self.tr("Pédale TBBR allumée — le mode UBOOT sera activé automatiquement.",
                                       "TBBR pedal is on — UBOOT mode will be activated automatically.")
            self.device_color = "#1d5f9a"
        elif "USB-Midi" in outs:
            self.device_text = self.tr("Pédale M-VAVE d'origine allumée — le mode UBOOT sera activé automatiquement.",
                                       "Original M-VAVE pedal is on — UBOOT mode will be activated automatically.")
            self.device_color = "#1d5f9a"
        else:
            self.device_text = self.tr("Pédale non détectée. Branche l'USB, allume la pédale, puis clique sur Détecter.",
                                       "Pedal not detected. Connect USB, power the pedal on, then click Detect.")
            self.device_color = "#a33"
        self.device_label.configure(text=self.device_text, foreground=self.device_color)

    def choose_parent(self):
        p = filedialog.askdirectory(title=self.tr("Dossier où enregistrer les sauvegardes", "Folder where backups are saved"),
                                    initialdir=str(self.backup_parent))
        if p:
            self.backup_parent = Path(p)
            self.parent_var.set(str(self.backup_parent))
            self.save_config()

    def choose_backup(self):
        p = filedialog.askdirectory(title=self.tr("Choisir un dossier de sauvegarde (contient flash_full_1MiB.bin)",
                                                  "Choose a backup folder (contains flash_full_1MiB.bin)"),
                                    initialdir=str(self.backup_parent))
        if p:
            self.set_backup(Path(p))

    def find_latest_backup(self):
        try:
            if not self.backup_parent.exists():
                return
            dirs = [d for d in self.backup_parent.iterdir() if d.is_dir() and (d / BACKUP_FILE).exists()]
            if dirs:
                self.set_backup(sorted(dirs, key=lambda d: d.stat().st_mtime, reverse=True)[0])
        except Exception:
            pass

    def set_backup(self, path):
        self.backup_dir = Path(path)
        self.refresh_backup_info()
        self.refresh_buttons()
        self.save_config()

    def refresh_backup_info(self):
        if not self.backup_label:
            return
        if not self.backup_dir:
            self.backup_label.configure(text=self.tr("Aucune sauvegarde sélectionnée", "No backup selected"), foreground="#a33")
            return
        p = self.backup_dir / BACKUP_FILE
        if not p.exists():
            self.backup_label.configure(text=self.tr("Sauvegarde absente : ", "Backup missing: ") + str(p), foreground="#a33")
            return
        try:
            data = p.read_bytes()
            if len(data) != FLASH_SIZE:
                self.backup_label.configure(text=self.tr("Sauvegarde de taille incorrecte : ", "Backup has the wrong size: ") + str(p), foreground="#a33")
                return
            sha = hashlib.sha256(data).hexdigest()
            sums = self.backup_dir / "SHA256SUMS.txt"
            if sums.exists():
                txt = sums.read_text(encoding="utf-8", errors="replace")
                if sha not in txt:
                    self.backup_label.configure(text=self.tr("SHA-256 différent de SHA256SUMS.txt : ", "SHA-256 differs from SHA256SUMS.txt: ") + str(p), foreground="#a33")
                    return
            kind = backup_kind(p)
            if self.lang == "en":
                kind = {
                    "firmware TBBR": "TBBR firmware",
                    "firmware M-VAVE d'origine": "original M-VAVE firmware",
                    "firmware inconnu": "unknown firmware",
                    "taille inattendue": "unexpected size",
                    "illisible": "unreadable",
                }.get(kind, kind)
            self.backup_label.configure(text=f"{p}  ·  {kind}  ·  SHA {sha[:12]}…", foreground="#1d7a3a")
        except Exception as e:
            self.backup_label.configure(text=self.tr("Sauvegarde illisible : ", "Unreadable backup: ") + str(e), foreground="#a33")

    def open_backup_folder(self):
        if self.backup_dir and self.backup_dir.exists():
            try:
                os.startfile(str(self.backup_dir))
            except Exception as e:
                messagebox.showerror(self.tr("Erreur", "Error"), str(e))
        else:
            messagebox.showinfo(self.tr("Sauvegarde", "Backup"),
                                self.tr("Aucun dossier de sauvegarde sélectionné.", "No backup folder selected."))

    # ------------------------------------------------------------------ UBOOT
    def ensure_uboot(self):
        enter_uboot()

    def wait_for_custom(self, seconds=25):
        return wait_custom(seconds)

    def wait_for_original(self, seconds=25):
        return wait_original(seconds)

    # ------------------------------------------------------------------ actions
    def do_backup(self):
        if self.busy:
            return
        self.backup_parent.mkdir(parents=True, exist_ok=True)
        out = self.backup_parent / ("BlackBox_" + now_name())
        if not messagebox.askyesno(self.tr("Sauvegarder le firmware d'origine", "Back up the original firmware"),
                                   self.tr("La sauvegarde sera enregistrée dans :\n\n", "The backup will be saved in:\n\n") + str(out) +
                                   self.tr("\n\nLa pédale doit être branchée en USB. La lecture prend quelques minutes.",
                                           "\n\nThe pedal must be connected by USB. Reading takes a few minutes."),
                                   icon="question"):
            return

        def task():
            self.ensure_uboot()
            bb_tool.backup(str(out))
            p = out / BACKUP_FILE
            if not p.exists() or p.stat().st_size != FLASH_SIZE:
                raise RuntimeError(self.tr("La sauvegarde n'a pas été créée correctement.",
                                           "The backup was not created correctly."))
            print(self.tr("\nSauvegarde vérifiée :", "\nBackup verified:") + " " + str(p))
            print("SHA-256 : " + sha256_file(p))
            self.q.put(("backup", str(out)))

        self.run_task(self.tr("Sauvegarde du firmware d'origine", "Backup of the original firmware"), task)

    def make_image(self):
        return build_image(self.backup_dir)

    def do_install(self):
        if self.busy or not self.backup_dir:
            return
        if not (self.backup_dir / BACKUP_FILE).exists():
            messagebox.showerror(self.tr("Sauvegarde absente", "Backup missing"),
                                 self.tr("Fais d'abord la sauvegarde du firmware d'origine.",
                                         "Back up the original firmware first."))
            return
        if not messagebox.askyesno(self.tr("Installer le firmware TBBR", "Install the TBBR firmware"),
                                   self.tr("La pédale va être mise à jour avec le firmware TBBR.\n\n",
                                           "The pedal will be updated with the TBBR firmware.\n\n") +
                                   self.tr("Sauvegarde utilisée :\n", "Backup used:\n") + str(self.backup_dir / BACKUP_FILE) +
                                   self.tr("\n\nNe débranche pas l'USB pendant l'opération.",
                                           "\n\nDo not unplug USB during the operation."),
                                   icon="warning"):
            return

        def task():
            self.ensure_uboot()
            img, backup_data = self.make_image()
            self.ensure_uboot()
            bb_tool.flash_app(str(img), str(self.backup_dir / BACKUP_FILE), keep_storage=True)
            print(self.tr("\nRedémarrage de la pédale…", "\nRestarting the pedal…"))
            bb_tool.reboot()
            print(self.tr("Attente du firmware TBBR…", "Waiting for the TBBR firmware…"))
            if self.wait_for_custom():
                print(self.tr("Firmware TBBR détecté : installation terminée.",
                              "TBBR firmware detected: installation complete."))
            else:
                print(self.tr("Le firmware TBBR n'a pas encore répondu (débranche/rebranche l'USB après le redémarrage).",
                              "The TBBR firmware has not answered yet (unplug/replug USB after restart)."))
            print(self.tr("\nIMPORTANT : éteins puis rallume la pédale avec son interrupteur avant de jouer.",
                          "\nIMPORTANT: power the pedal off and on with its switch before playing."))

        self.run_task(self.tr("Installation du firmware TBBR", "TBBR firmware installation"), task)

    def do_restore(self):
        if self.busy or not self.backup_dir:
            return
        backup = self.backup_dir / BACKUP_FILE
        if not backup.exists():
            messagebox.showerror(self.tr("Sauvegarde absente", "Backup missing"),
                                 self.tr("Choisis un dossier contenant flash_full_1MiB.bin.",
                                         "Choose a folder containing flash_full_1MiB.bin."))
            return
        if not messagebox.askyesno(self.tr("Restaurer le firmware d'origine", "Restore the original firmware"),
                                   self.tr("La flash complète va être réécrite avec :\n\n",
                                           "The full flash will be rewritten with:\n\n") + str(backup) +
                                   self.tr("\n\nLes presets, IR et captures NAM du firmware TBBR seront remplacés. "
                                           "Le bootloader/SPL n'est pas touché.\n\nNe débranche pas l'USB.",
                                           "\n\nPresets, IRs and NAM captures from the TBBR firmware will be replaced. "
                                           "The bootloader/SPL is not touched.\n\nDo not unplug USB."),
                                   icon="warning"):
            return

        def task():
            self.ensure_uboot()
            bb_tool.flash_app(str(backup), str(backup), keep_storage=False, full=True)
            print(self.tr("\nRedémarrage de la pédale…", "\nRestarting the pedal…"))
            bb_tool.reboot()
            print(self.tr("Attente du firmware restauré…", "Waiting for the restored firmware…"))
            name = self.wait_for_original()
            if name:
                print(self.tr("Firmware d'origine détecté :", "Original firmware detected:") + " " + str(name))
            else:
                print(self.tr("La pédale n'a pas encore répondu. Débranche/rebranche l'USB après le redémarrage.",
                              "The pedal has not answered yet. Unplug/replug USB after restart."))
            print(self.tr("\nIMPORTANT : éteins puis rallume la pédale avec son interrupteur avant de jouer.",
                          "\nIMPORTANT: power the pedal off and on with its switch before playing."))

        self.run_task(self.tr("Restauration du firmware d'origine", "Original firmware restore"), task)

    def on_close(self):
        if self.busy:
            messagebox.showwarning(self.tr("Opération en cours", "Operation in progress"),
                                   self.tr("Ne ferme pas l'installateur pendant une écriture. Attends la fin.",
                                           "Do not close the installer while writing. Wait for it to finish."))
            return
        self.root.destroy()


# ====================================================================== interface web (design de l'app TBBR)
# Petit serveur local (127.0.0.1, jeton aléatoire) + fenêtre Edge en mode « app » (sans barre d'adresse),
# aucune dépendance en plus. L'ancienne interface Tk reste disponible : --classic.
import http.server
import re
import secrets
import subprocess
import urllib.parse

UI_DIR = resource("ui")


def embedded_fw():
    try:
        m = re.search(rb"TBBR fw\d+ \d+\.\d+", APP_BIN.read_bytes())
        return m.group().decode() if m else None
    except Exception:
        return None


def fw_tuple(s):
    m = re.search(r"fw(\d+) (\d+)\.(\d+)", s or "")
    return tuple(int(x) for x in m.groups()) if m else None


def _pack7(b):
    out = bytearray()
    for i in range(0, len(b), 7):
        g = b[i:i + 7]
        out.append(sum(((x >> 7) & 1) << k for k, x in enumerate(g)))
        out += bytes(x & 0x7F for x in g)
    return bytes(out)


def _unpack7(s):
    out, i = bytearray(), 0
    while i < len(s):
        hi = s[i]; i += 1
        for k in range(7):
            if i >= len(s):
                break
            out.append((s[i] & 0x7F) | (((hi >> k) & 1) << 7)); i += 1
    return bytes(out)


def pedal_info():
    """INFO du firmware TBBR (protocole de l'app : trame A5 dans un SysEx F0 7D 42 58 70 … F7) ; None si pas de réponse."""
    pl = b'{"app":"installer","proto":1}'
    f = bytes([0xA5, 0x01, len(pl) & 255, len(pl) >> 8]) + pl
    x = 0
    for c in f[1:]:
        x ^= c
    msg = b"\xF0\x7D\x42\x58\x70" + _pack7(f + bytes([x])) + b"\xF7"
    try:
        got = bb_tool.midi_exchange(msg, wait=1.0, port="BlackBox Custom")
    except Exception:
        return None
    for raw in got or []:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x70")
            if k < 0:
                continue
            fr = _unpack7(part[k + 5:])
            if len(fr) >= 5 and fr[0] == 0xA5 and fr[1] == 0x02:
                n = fr[2] | fr[3] << 8
                try:
                    return json.loads(fr[4:4 + n].decode("utf-8"))
                except Exception:
                    return None
    return None


def find_edge():
    for base in (os.environ.get("ProgramFiles(x86)"), os.environ.get("ProgramFiles"), os.environ.get("LOCALAPPDATA")):
        if base:
            p = Path(base) / "Microsoft" / "Edge" / "Application" / "msedge.exe"
            if p.exists():
                return str(p)
    return None


class OutCapture:
    """Remplace sys.stdout pendant une tâche : journal + progression (secteurs écrits, Ko lus)."""
    def __init__(self, app):
        self.app, self.buf = app, ""

    def write(self, s):
        if not s:
            return
        self.app.add_log(s)
        self.buf += s
        while "\n" in self.buf:
            line, self.buf = self.buf.split("\n", 1)
            self.app.parse_line(line)

    def flush(self):
        pass


class WebApp:
    PHASES = {"backup": ["uboot", "read", "reboot"], "install": ["uboot", "build", "write", "reboot", "check"],
              "update": ["uboot", "build", "write", "reboot", "check"], "restore": ["uboot", "write", "reboot", "check"]}

    def __init__(self):
        self.lock = threading.RLock()
        self.dev_lock = threading.Lock()                              # détection et tâches ne parlent jamais en même temps à la pédale
        self.token = secrets.token_urlsafe(24)
        self.lang = "fr"
        self.busy = False
        self.task = None
        self.logs = []
        self.device = {"kind": "search"}
        self.backup_dir = None
        self.backup_info = {}
        self.backup_parent = Path.home() / "Documents" / "BlackBox Backup"
        self.embedded = embedded_fw()
        self.pkg = None                                               # paquet .tbbr chargé : {"fw", "name", "app"}
        self.auto_update = "--update" in sys.argv
        self.last_seen = time.time()
        self.main_q = queue.Queue()
        self.quit_flag = False
        self.sectors_total = self.sectors_done = 0
        self.load_config()

    # ---------------------------------------------------------------- outils
    def tr(self, fr, en):
        return en if self.lang == "en" else fr

    def add_log(self, s):
        with self.lock:
            self.logs.append(s)
        try:
            CONFIG_DIR.mkdir(parents=True, exist_ok=True)
            with open(LOG_FILE, "a", encoding="utf-8") as f:
                f.write(s)
        except Exception:
            pass

    def parse_line(self, line):
        t = self.task
        if not t:
            return
        line = line.strip()
        if line:
            t["line"] = line
        if "secteurs à écrire" in line:
            self.sectors_total = line.count("'0x"); self.sectors_done = 0
            t["pct"] = 0 if self.sectors_total else 100
        elif "écrit et vérifié" in line and self.sectors_total:
            self.sectors_done += 1
            t["pct"] = min(100.0, 100.0 * self.sectors_done / self.sectors_total)
        else:
            m = re.search(r"passe (\d) : (\d+) Ko", line)
            if m:
                t["pct"] = min(100.0, ((int(m.group(1)) - 1) * 1024 + int(m.group(2))) / 20.48)
            m = re.search(r"passe (\d) terminée", line)
            if m:
                t["pct"] = min(100.0, 50.0 * int(m.group(1)))

    def phase(self, p, pct=None):
        if self.task:
            self.task["phase"] = p
            self.task["pct"] = pct

    def load_config(self):
        try:
            cfg = json.loads(CONFIG_FILE.read_text(encoding="utf-8-sig"))
        except Exception:
            cfg = {}
        if cfg.get("lang") in ("fr", "en"):
            self.lang = cfg["lang"]
        if cfg.get("backup_parent"):
            self.backup_parent = Path(cfg["backup_parent"])
        last = cfg.get("last_backup")
        if last and (Path(last) / BACKUP_FILE).exists():
            self.set_backup(Path(last), save=False)
        else:
            self.find_latest_backup()

    def save_config(self):
        try:
            CONFIG_DIR.mkdir(parents=True, exist_ok=True)
            CONFIG_FILE.write_text(json.dumps({"backup_parent": str(self.backup_parent),
                                               "last_backup": str(self.backup_dir) if self.backup_dir else None,
                                               "lang": self.lang}, indent=2), encoding="utf-8")
        except Exception:
            pass

    def find_latest_backup(self):
        """Dernière sauvegarde du firmware M-VAVE d'origine en priorité (c'est elle qui sert à « Restaurer l'origine »)."""
        try:
            dirs = sorted((d for d in self.backup_parent.iterdir() if d.is_dir() and (d / BACKUP_FILE).exists()),
                          key=lambda d: d.stat().st_mtime, reverse=True)
            orig = [d for d in dirs if backup_kind(d / BACKUP_FILE) == "firmware M-VAVE d'origine"]
            if orig or dirs:
                self.set_backup((orig or dirs)[0], save=False)
        except Exception:
            pass

    def set_backup(self, path, save=True):
        path = Path(path)
        info = {"dir": str(path), "ok": False}
        p = path / BACKUP_FILE
        try:
            if not p.exists():
                info["msg"] = self.tr("flash_full_1MiB.bin absent", "flash_full_1MiB.bin missing")
            else:
                data = p.read_bytes()
                if len(data) != FLASH_SIZE:
                    info["msg"] = self.tr("taille incorrecte", "wrong size")
                else:
                    sha = hashlib.sha256(data).hexdigest()
                    sums = path / "SHA256SUMS.txt"
                    if sums.exists() and sha not in sums.read_text(encoding="utf-8", errors="replace"):
                        info["msg"] = self.tr("SHA-256 différent de SHA256SUMS.txt", "SHA-256 differs from SHA256SUMS.txt")
                    else:
                        kind = backup_kind(p)
                        info.update(ok=True, sha=sha, kind={"firmware TBBR": "tbbr", "firmware M-VAVE d'origine": "mvave"}.get(kind, "unknown"),
                                    date=datetime.datetime.fromtimestamp(p.stat().st_mtime).strftime("%d/%m/%Y %H:%M"))
        except Exception as e:
            info["msg"] = str(e)
        self.backup_dir = path
        self.backup_info = info
        if save:
            self.save_config()

    # ---------------------------------------------------------------- pédale
    def detect(self, query_info=True):
        with self.dev_lock:
            if not self.busy:
                self._detect(query_info)

    def _detect(self, query_info):
        try:
            ub = bb_tool.find_uboot(verbose=False)
            ins, outs = bb_tool.midi_ports()
        except Exception:
            ub, ins, outs = [], [], []
        if ub:
            dev = {"kind": "uboot"}
        elif "BlackBox Custom" in outs:
            dev = {"kind": "tbbr"}
            old = self.device
            if query_info or old.get("kind") != "tbbr" or not old.get("fw"):
                info = pedal_info()
                if info:
                    dev.update(fw=info.get("fw"), battery=info.get("battery"))
            else:
                dev.update(fw=old.get("fw"), battery=old.get("battery"))
        elif "USB-Midi" in outs:
            old = self.device
            if old.get("kind") == "mvave" and old.get("fw") and not query_info:
                dev = dict(old)
            else:
                name = None
                try:
                    name = bb_tool.identify()
                except Exception:
                    pass
                v = mvave_version(name)
                dev = {"kind": "mvave", "fw": ("M-VAVE V%02d" % v) if v else "M-VAVE", "needV19": v is not None and v != 19}
        else:
            dev = {"kind": "none"}
        with self.lock:
            if not self.busy:
                self.device = dev

    def watch_device(self):
        while not self.quit_flag:
            if not self.busy:
                self.detect(query_info=False)
                # lancé par l'app (--update + paquet .tbbr) : mise à jour dès que la pédale TBBR est là, sans autre clic
                if (self.auto_update and self.task is None and self.pkg and self.backup_info.get("ok")
                        and self.device.get("kind") == "tbbr" and self.device.get("fw")):
                    self.auto_update = False
                    if self.update_state() == "available":
                        self.do_install()
            time.sleep(2.5)

    def target_fw(self):
        return self.pkg["fw"] if self.pkg else self.embedded

    def load_package(self, blob, name):
        if self.busy:
            return {"error": self.tr("Opération en cours.", "Operation in progress.")}
        try:
            fw, app, cabs = read_package(blob)
        except ValueError as e:
            return {"error": self.tr("Paquet refusé : ", "Package rejected: ") + str(e)}
        self.pkg = {"fw": fw, "name": Path(name or "firmware.tbbr").name, "app": app, "cabs": cabs}
        self.add_log(f"\nPaquet chargé : {self.pkg['name']} ({fw}, {len(app)} o, sha256 {hashlib.sha256(app).hexdigest()[:16]})\n")
        return {"ok": True, "fw": fw}

    def update_state(self):
        e, d = fw_tuple(self.target_fw()), fw_tuple(self.device.get("fw"))
        if self.device.get("kind") != "tbbr" or not e or not d:
            return "unknown"
        return "available" if e > d else ("current" if e == d else "newer")

    # ---------------------------------------------------------------- tâches
    def run_task(self, tid, fn):
        with self.lock:
            if self.busy:
                return {"error": self.tr("Une opération est déjà en cours.", "An operation is already running.")}
            self.busy = True
            self.task = {"id": tid, "phases": self.PHASES[tid], "phase": self.PHASES[tid][0], "pct": None, "line": "", "ok": None, "msg": ""}
        self.add_log("\n=== " + time.strftime("%H:%M:%S") + " " + tid + " ===\n")

        def worker():
            old = sys.stdout
            sys.stdout = OutCapture(self)
            try:
                with self.dev_lock:                                   # attend la fin d'une détection en cours
                    pass
                msg = fn()
                self.task.update(ok=True, msg=msg or "")
            except SystemExit as e:
                self.task.update(ok=False, msg=str(e))
            except Exception as e:
                self.add_log(traceback.format_exc())
                msg = str(e) or e.__class__.__name__
                if isinstance(e, OSError) and "IOCTL" in msg:              # liaison USB défaillante (ex. Errno 31)
                    msg += self.tr("\n\nLiaison USB instable entre le PC et la pédale. N'éteins PAS la pédale et ne refais pas de "
                                   "sauvegarde : clique d'abord à nouveau sur Installer (les erreurs passagères sont réessayées). "
                                   "Si l'erreur revient : branche un câble de données court directement sur un autre port du PC "
                                   "(sans hub ni rallonge), éteins la pédale, attends 10 s, rallume-la, puis Détecter et Installer.",
                                   "\n\nUnreliable USB connection between the PC and the pedal. Do NOT power the pedal off and do not "
                                   "make a new backup: first click Install again (temporary errors are retried). If the error comes "
                                   "back: plug a short data cable directly into another port on the PC (no hub or extension), switch "
                                   "the pedal off, wait 10 s, switch it on, then Detect and Install.")
                self.task.update(ok=False, msg=msg)
            finally:
                sys.stdout = old
                with self.lock:
                    self.busy = False
                self.add_log(("\nOK : " if self.task["ok"] else "\nERREUR : ") + self.task["msg"] + "\n")
                self.detect()
        threading.Thread(target=worker, daemon=True).start()
        return {"ok": True}

    def do_backup(self):
        if not self.backup_parent:
            return {"error": "?"}

        def task():
            self.backup_parent.mkdir(parents=True, exist_ok=True)
            out = self.backup_parent / ("BlackBox_" + now_name())
            self.phase("uboot"); enter_uboot()
            self.phase("read", 0); bb_tool.backup(str(out))
            p = out / BACKUP_FILE
            if not p.exists() or p.stat().st_size != FLASH_SIZE:
                raise RuntimeError(self.tr("La sauvegarde n'a pas été créée correctement.", "The backup was not created correctly."))
            self.phase("reboot"); bb_tool.reboot()
            msg = self.tr("Sauvegarde vérifiée (2 lectures identiques) : ", "Backup verified (2 identical reads): ") + str(out)
            keep = self.backup_info.get("ok") and self.backup_info.get("kind") == "mvave" and backup_kind(p) != "firmware M-VAVE d'origine"
            if keep:   # sauvegarde d'une pédale déjà en TBBR : la sauvegarde M-VAVE reste celle de « Restaurer l'origine »
                msg += self.tr("\nLa sauvegarde M-VAVE d'origine reste sélectionnée pour la restauration.",
                               "\nThe original M-VAVE backup stays selected for restoring.")
            else:
                self.set_backup(out)
            return msg
        return self.run_task("backup", task)

    def do_install(self):
        if not self.backup_info.get("ok"):
            return {"error": self.tr("Choisis ou fais d'abord une sauvegarde valide.", "Choose or make a valid backup first.")}
        upd = self.device.get("kind") == "tbbr"
        bk = Path(self.backup_dir)
        pkg = self.pkg

        def task():
            self.phase("uboot"); enter_uboot()
            self.phase("build"); img, _ = build_image(bk, pkg["app"] if pkg else None, pkg.get("cabs") if pkg else None)
            enter_uboot()
            self.phase("write", 0); bb_tool.flash_app(str(img), str(bk / BACKUP_FILE), keep_storage=True)
            self.phase("reboot"); bb_tool.reboot()
            self.phase("check")
            if not wait_custom(30):
                raise RuntimeError(self.tr("Firmware écrit et vérifié, mais la pédale n'a pas encore répondu : débranche/rebranche l'USB.",
                                           "Firmware written and verified, but the pedal has not answered yet: unplug/replug USB."))
            info = pedal_info() or {}
            if self.sectors_total == 0:
                return self.tr("Le firmware {} était déjà en place (aucun secteur différent) : rien à écrire.",
                               "Firmware {} was already in place (no sector differs): nothing to write.").format(info.get("fw") or self.embedded or "TBBR")
            return self.tr("Firmware {} installé et vérifié. Éteins puis rallume la pédale avant de jouer.",
                           "Firmware {} installed and verified. Power the pedal off and on before playing.").format(info.get("fw") or self.embedded or "TBBR")
        return self.run_task("update" if upd else "install", task)

    def do_restore(self):
        if not self.backup_info.get("ok"):
            return {"error": self.tr("Sauvegarde invalide.", "Invalid backup.")}
        bk = Path(self.backup_dir) / BACKUP_FILE

        def task():
            self.phase("uboot"); enter_uboot()
            self.phase("write", 0); bb_tool.flash_app(str(bk), str(bk), keep_storage=False, full=True)
            self.phase("reboot"); bb_tool.reboot()
            self.phase("check")
            name = wait_original(30) or (wait_custom(5) and "TBBR")
            if not name:
                raise RuntimeError(self.tr("Flash restaurée et vérifiée, mais la pédale n'a pas encore répondu : débranche/rebranche l'USB.",
                                           "Flash restored and verified, but the pedal has not answered yet: unplug/replug USB."))
            return self.tr("Sauvegarde restaurée ({}). Éteins puis rallume la pédale.", "Backup restored ({}). Power the pedal off and on.").format(name)
        return self.run_task("restore", task)

    # ---------------------------------------------------------------- dialogues (fil principal Tk)
    def on_main(self, fn):
        ev, box = threading.Event(), {}
        def run():
            try:
                box["r"] = fn()
            finally:
                ev.set()
        self.main_q.put(run)
        ev.wait()
        return box.get("r")

    def choose_backup(self):
        def dlg():
            r = tk._default_root
            r.attributes("-topmost", True)
            p = filedialog.askdirectory(parent=r, title=self.tr("Choisir un dossier de sauvegarde (contient flash_full_1MiB.bin)",
                                                                "Choose a backup folder (contains flash_full_1MiB.bin)"),
                                        initialdir=str(self.backup_dir.parent if self.backup_dir else self.backup_parent))
            r.attributes("-topmost", False)
            return p
        p = self.on_main(dlg)
        if p:
            p = Path(p)
            if not (p / BACKUP_FILE).exists() and (p.parent / BACKUP_FILE).exists():
                p = p.parent
            self.set_backup(p)
            if self.backup_info.get("ok"):
                self.backup_parent = p.parent
                self.save_config()
        return {"ok": True}

    # ---------------------------------------------------------------- état / HTTP
    def state(self, since):
        with self.lock:
            logs = self.logs[since:] if 0 <= since <= len(self.logs) else self.logs[-500:]
            return {"app": "TBBR Installer " + APP_VERSION, "lang": self.lang, "busy": self.busy, "task": self.task,
                    "device": self.device, "embedded": {"fw": self.target_fw(), "builtin": self.embedded,
                                                        "pkg": {"fw": self.pkg["fw"], "name": self.pkg["name"]} if self.pkg else None},
                    "update": self.update_state(),
                    "backup": self.backup_info, "backupParent": str(self.backup_parent), "log": logs, "logN": len(self.logs)}

    def handle(self, path, body):
        if path == "detect":
            threading.Thread(target=self.detect, daemon=True).start(); return {"ok": True}
        if path == "backup":
            return self.do_backup()
        if path == "install":
            return self.do_install()
        if path == "restore":
            return self.do_restore()
        if path == "choose_backup":
            return {"error": self.tr("Opération en cours.", "Operation in progress.")} if self.busy else self.choose_backup()
        if path == "open_folder":
            if self.backup_dir and Path(self.backup_dir).exists():
                os.startfile(str(self.backup_dir))
            return {"ok": True}
        if path == "clear_fw":
            if not self.busy:
                self.pkg = None
            return {"ok": True}
        if path == "dismiss":
            if not self.busy:
                self.task = None
            return {"ok": True}
        if path == "lang":
            if body.get("lang") in ("fr", "en") and not self.busy:
                self.lang = body["lang"]; self.save_config()
                if self.backup_dir:
                    self.set_backup(self.backup_dir, save=False)
            return {"ok": True}
        return None

    def make_handler(self):
        app = self

        class H(http.server.BaseHTTPRequestHandler):
            def log_message(self, *a):
                pass

            def _send(self, code, data, ctype="application/json; charset=utf-8"):
                if isinstance(data, (dict, list)):
                    data = json.dumps(data, ensure_ascii=False).encode("utf-8")
                self.send_response(code)
                self.send_header("Content-Type", ctype)
                self.send_header("Content-Length", str(len(data)))
                self.send_header("Cache-Control", "no-store")
                self.send_header("X-Content-Type-Options", "nosniff")
                self.end_headers()
                self.wfile.write(data)

            def _host_ok(self):
                return self.headers.get("Host", "") == f"127.0.0.1:{app.port}"

            def _auth(self):
                return self._host_ok() and secrets.compare_digest(self.headers.get("X-Token", ""), app.token)

            def do_GET(self):
                if not self._host_ok():
                    return self._send(403, b"forbidden", "text/plain")
                u = urllib.parse.urlparse(self.path)
                if u.path.startswith("/api/"):
                    if not self._auth():
                        return self._send(403, b"forbidden", "text/plain")
                    app.last_seen = time.time()
                    if u.path == "/api/state":
                        q = urllib.parse.parse_qs(u.query)
                        try:
                            since = int(q.get("since", ["0"])[0])
                        except ValueError:
                            since = 0
                        return self._send(200, app.state(since))
                    return self._send(404, b"not found", "text/plain")
                name = "index.html" if u.path in ("/", "/index.html") else u.path.lstrip("/")
                if name.startswith("ui/"):
                    name = name[3:]
                f = (UI_DIR / name).resolve()
                if UI_DIR.resolve() not in f.parents or not f.is_file():
                    return self._send(404, b"not found", "text/plain")
                ctype = {".html": "text/html; charset=utf-8", ".svg": "image/svg+xml", ".woff2": "font/woff2", ".ttf": "font/ttf"}.get(f.suffix, "application/octet-stream")
                return self._send(200, f.read_bytes(), ctype)

            def do_POST(self):
                if not self._auth():
                    return self._send(403, b"forbidden", "text/plain")
                n = int(self.headers.get("Content-Length") or 0)
                u = urllib.parse.urlparse(self.path)
                if u.path == "/api/upload_fw":                         # paquet .tbbr glissé / choisi dans la page
                    if n <= 0 or n > 4 << 20:
                        return self._send(200, {"error": "taille de fichier refusée"})
                    name = urllib.parse.parse_qs(u.query).get("name", [""])[0]
                    app.last_seen = time.time()
                    return self._send(200, app.load_package(self.rfile.read(n), name))
                try:
                    body = json.loads(self.rfile.read(n) or b"{}") if n else {}
                except Exception:
                    body = {}
                app.last_seen = time.time()
                try:
                    r = app.handle(urllib.parse.urlparse(self.path).path[5:], body if isinstance(body, dict) else {})
                except Exception as e:
                    r = {"error": str(e)}
                if r is None:
                    return self._send(404, b"not found", "text/plain")
                return self._send(200, r)
        return H

    def window_loop(self, url):
        edge = find_edge()
        # Profil Edge neuf à chaque lancement : sinon une ancienne fenêtre « app » du même
        # profil peut être réutilisée et garder une URL morte (page vide).
        profile = Path(tempfile.gettempdir()) / ("tbbr-installer-ui-" + str(os.getpid()))
        shutil.rmtree(profile, ignore_errors=True)
        if not edge:
            import webbrowser
            webbrowser.open(url)
            grace = time.time() + 30
            while not self.quit_flag:
                time.sleep(1)
                if not self.busy and time.time() > grace and time.time() - self.last_seen > 15:
                    break
            self.main_q.put(None)
            return
        args = [edge, "--app=" + url, "--user-data-dir=" + str(profile), "--window-size=1120,860",
                "--no-first-run", "--no-default-browser-check", "--disable-features=Translate,msEdgeSidebarV2", "--lang=" + self.lang]
        while not self.quit_flag:
            t0 = time.time()
            proc = subprocess.Popen(args)
            proc.wait()
            if time.time() - t0 < 3:                                  # Edge a passé la main à un processus existant
                while time.time() - self.last_seen < 6 or self.busy:
                    time.sleep(1)
            if not self.busy:
                break
            time.sleep(0.5)                                           # fenêtre fermée pendant une écriture : on la rouvre
        shutil.rmtree(profile, ignore_errors=True)
        self.main_q.put(None)

    def run(self):
        server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), self.make_handler())
        self.port = server.server_address[1]
        threading.Thread(target=server.serve_forever, daemon=True).start()
        threading.Thread(target=self.watch_device, daemon=True).start()
        url = f"http://127.0.0.1:{self.port}/?t={self.token}"
        root = tk.Tk()
        root.withdraw()
        if "--serve" in sys.argv:                                     # test : pas de fenêtre, adresse affichée
            print(url, flush=True)
        else:
            threading.Thread(target=self.window_loop, args=(url,), daemon=True).start()

        def pump():
            try:
                while True:
                    fn = self.main_q.get_nowait()
                    if fn is None:
                        self.quit_flag = True
                        root.quit()
                        return
                    fn()
            except queue.Empty:
                pass
            root.after(100, pump)
        root.after(100, pump)
        root.mainloop()
        server.shutdown()
        return 0


def cli_log(s):
    s = str(s)
    print(s, flush=True)
    try:
        CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        with open(CONFIG_DIR / "installer_cli.log", "a", encoding="utf-8") as f:
            f.write(s + "\n")
    except Exception:
        pass


def cli_backup(outdir):
    out = Path(outdir)
    if (out / BACKUP_FILE).exists():
        cli_log("REFUS : une sauvegarde existe déjà dans " + str(out))
        return 2
    out.mkdir(parents=True, exist_ok=True)
    enter_uboot()
    bb_tool.backup(str(out))
    p = out / BACKUP_FILE
    if not p.exists() or p.stat().st_size != FLASH_SIZE:
        cli_log("ERREUR : sauvegarde absente ou incorrecte")
        return 1
    cli_log("SAUVEGARDE OK : " + str(p))
    cli_log("SHA-256 : " + sha256_file(p))
    return 0


def cli_install(backup_dir):
    backup = Path(backup_dir) / BACKUP_FILE
    if not backup.exists():
        cli_log("ERREUR : sauvegarde absente : " + str(backup))
        return 1
    enter_uboot()
    img, _ = build_image(backup_dir)
    enter_uboot()
    bb_tool.flash_app(str(img), str(backup), keep_storage=True)
    cli_log("Redémarrage…")
    bb_tool.reboot()
    ok = wait_custom()
    cli_log("FIRMWARE TBBR DÉTECTÉ" if ok else "PAS DE RÉPONSE TBBR APRÈS REDÉMARRAGE")
    cli_log("Éteins puis rallume la pédale.")
    return 0 if ok else 1


def cli_restore(backup_dir):
    backup = Path(backup_dir) / BACKUP_FILE
    if not backup.exists():
        cli_log("ERREUR : sauvegarde absente : " + str(backup))
        return 1
    enter_uboot()
    bb_tool.flash_app(str(backup), str(backup), keep_storage=False, full=True)
    cli_log("Redémarrage…")
    bb_tool.reboot()
    name = wait_original()
    cli_log(("FIRMWARE D'ORIGINE DÉTECTÉ : " + name) if name else "PAS DE RÉPONSE DU FIRMWARE D'ORIGINE")
    cli_log("Éteins puis rallume la pédale.")
    return 0 if name else 1


def cli_self_test(backup_dir=None):
    """Vérifie que l'exe embarque tout et que l'image se construit, sans écrire sur la pédale."""
    out = []
    def p(s):
        out.append(str(s))
        print(s, flush=True)
    p("Installateur TBBR " + APP_VERSION)
    p("firmware inclus : " + str(embedded_fw()))
    for name, path in (("wl82loader.bin", Path(bb_tool.LOADER)), ("reboot.bin", Path(bb_tool.REBOOT)), ("app.bin", APP_BIN),
                       ("cabs.bin", CABS_BIN), ("ui/index.html", UI_DIR / "index.html"), ("ui/fonts/Inter-700.ttf", UI_DIR / "fonts" / "Inter-700.ttf")):
        p(f"{name}: {'OK' if path.exists() else 'ABSENT'} {path} {path.stat().st_size if path.exists() else 0} o")
        if not path.exists():
            return 1
    if backup_dir:
        bk = Path(backup_dir) / BACKUP_FILE
        if not bk.exists():
            p("sauvegarde absente : " + str(bk))
            return 1
        data = bk.read_bytes()
        app = APP_BIN.read_bytes()
        app += b"\0" * (-len(app) % 32)
        img, end = mkfw.build(data, app)
        p(f"image générée : {len(img)} o, zone utile {APP_BASE + end:#x}, sha256 {hashlib.sha256(img).hexdigest()[:16]}")
        p(f"SPL conservé : {img[:APP_BASE] == data[:APP_BASE]}")
        area = mkfw.sfc(img[APP_BASE:])
        p(f"app.bin dans l'image : {area[0x120:0x120 + len(app)] == app}")
    p("SELF-TEST OK")
    try:
        CONFIG_DIR.mkdir(parents=True, exist_ok=True)
        (CONFIG_DIR / "installer_self_test.txt").write_text("\n".join(out) + "\n", encoding="utf-8")
    except Exception:
        pass
    return 0


def main():
    args = sys.argv[1:]
    # langue pour les messages CLI / erreurs sans interface
    global LANG
    try:
        cfg = json.loads(CONFIG_FILE.read_text(encoding="utf-8-sig"))
        LANG = cfg.get("lang", "fr")
    except Exception:
        LANG = "fr"

    def arg_value(name):
        i = args.index(name)
        return args[i + 1] if i + 1 < len(args) else None

    if "--self-test" in args:
        return cli_self_test(arg_value("--self-test"))
    if "--version" in args:
        print(APP_VERSION)
        return 0
    for opt, fn in (("--backup-now", cli_backup), ("--install-now", cli_install), ("--restore-now", cli_restore)):
        if opt in args:
            if "--yes" not in args:
                cli_log("REFUS : ajouter --yes pour une opération qui écrit sur la pédale.")
                return 2
            target = arg_value(opt)
            if not target:
                cli_log("ERREUR : dossier manquant après " + opt)
                return 2
            try:
                return fn(target)
            except SystemExit as e:
                cli_log("ERREUR : " + str(e))
                return 1
            except Exception:
                cli_log(traceback.format_exc())
                return 1
    if not APP_BIN.exists():
        # message d'erreur lisible même sans interface
        root = tk.Tk()
        root.withdraw()
        messagebox.showerror("Installateur incomplet" if LANG != "en" else "Incomplete installer",
                             "Le fichier app.bin embarqué est absent." if LANG != "en" else "The embedded app.bin file is missing.")
        return 1
    if "--classic" not in args and (UI_DIR / "index.html").exists():
        w = WebApp()
        for a in args:                                                # double-clic sur un .tbbr / installateur.exe paquet.tbbr
            if a.lower().endswith(".tbbr") and Path(a).is_file():
                w.load_package(Path(a).read_bytes(), a)
        return w.run()
    root = tk.Tk()
    Installer(root)
    root.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
