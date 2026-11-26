"""bb_tool.py - outil BlackBox (M-VAVE, JieLi AC791N) : MIDI M-VAVE + mode UBOOT, sauvegarde de flash en LECTURE SEULE.

Étapes (une commande à la fois) :
  identify            requête d'identité M-VAVE (cmd 0x11) -> "BlackBox_0xx"
  softkey             envoie SOFT_KEY F0 22 24 35 7D F7 (seulement si identify répond BlackBox_*)
  find                cherche le disque "WL82 UBOOT" (inquiry SCSI)
  backup <dossier>    charge wl82loader en RAM, vérifie chip key, lit la flash 1 Mio x2, compare, sauve
  reboot              relance la pédale depuis la RAM (reboot.bin : CORE_SYSTEM_RESET du SDK JieLi)
  runram <bin> [adr]  charge reboot.bin + un programme en RAM (défaut 0x1C40000) et saute dessus (aucune écriture flash)
  flashapp / restore  écriture de la zone application / restauration complète (SPL jamais écrit, --oui obligatoire)

Partie SCSI et protocole loader : d'après jl-uboot-tool (kagaimiq, MIT), commit adb3f18 ; wl82loader.bin vient de ce
projet (third_party/jl-uboot-tool). Les constantes du protocole MIDI M-VAVE sont des valeurs d'interopérabilité.
"""
import sys, os, time, ctypes, ctypes.wintypes as wt, hashlib, json, datetime

ROOT = os.path.dirname(os.path.abspath(__file__))
LOADER = os.path.join(ROOT, "..", "third_party", "jl-uboot-tool", "wl82loader.bin")
LOADER_SHA = "d41da6126760c9d66660bcc0cac8d27d221806c5e369a8036921efe68dca5376"
REBOOT = os.path.join(ROOT, "..", "fw_maison", "reboot", "reboot.bin")     # notre programme (10 o), voir reboot.c
REBOOT_SHA = "0f0113c68f495794f2170fac4aea090d1c8c7720b6675c3b871403ef2b0d2600"
LOADER_ADDR, LOADER_ARG = 0x1C02000, 1
PAYLOAD_LOAD = 0x1C20000
CHIP_KEY = 0x980F
FLASH_SIZE, BLOCK = 0x100000, 512
SOFT_KEY = bytes.fromhex("F022 2435 7DF7")
CMD_INFO = 0x11

# ------------------------------------------------------------------ CRC / chiffrements JieLi
def crc16(data, c=0):
    for x in data:
        c ^= x << 8
        for _ in range(8):
            c = ((c << 1) ^ 0x1021) & 0xFFFF if c & 0x8000 else (c << 1) & 0xFFFF
    return c

_MAGIC = "孟黎我爱你，玉林".encode("gb2312")
def crc_cipher(data, key=0xFFFFFFFF):
    buf = bytearray(data)
    c = crc16((key >> 16).to_bytes(2, "little"), key & 0xFFFF)
    for i in range(len(buf)):
        mi = i % len(_MAGIC)
        c = crc16(_MAGIC[mi:mi + 1], c)
        buf[i] ^= c & 0xFF
    return bytes(buf)

# ------------------------------------------------------------------ MIDI (winmm)
winmm = ctypes.WinDLL("winmm")
class MIDIINCAPSW(ctypes.Structure):
    _fields_ = [("wMid", wt.WORD), ("wPid", wt.WORD), ("v", wt.UINT), ("szPname", wt.WCHAR * 32), ("dwSupport", wt.DWORD)]
class MIDIOUTCAPSW(ctypes.Structure):
    _fields_ = [("wMid", wt.WORD), ("wPid", wt.WORD), ("v", wt.UINT), ("szPname", wt.WCHAR * 32), ("t", wt.WORD),
                ("a", wt.WORD), ("b", wt.WORD), ("c", wt.WORD), ("dwSupport", wt.DWORD)]
class MIDIHDR(ctypes.Structure): pass
MIDIHDR._fields_ = [("lpData", ctypes.c_void_p), ("dwBufferLength", wt.DWORD), ("dwBytesRecorded", wt.DWORD),
                    ("dwUser", ctypes.c_size_t), ("dwFlags", wt.DWORD), ("lpNext", ctypes.c_void_p),
                    ("reserved", ctypes.c_size_t), ("dwOffset", wt.DWORD), ("dwReserved", ctypes.c_size_t * 8)]

def midi_ports():
    ins, outs = [], []
    for i in range(winmm.midiInGetNumDevs()):
        c = MIDIINCAPSW(); winmm.midiInGetDevCapsW(i, ctypes.byref(c), ctypes.sizeof(c)); ins.append(c.szPname)
    for i in range(winmm.midiOutGetNumDevs()):
        c = MIDIOUTCAPSW(); winmm.midiOutGetDevCapsW(i, ctypes.byref(c), ctypes.sizeof(c)); outs.append(c.szPname)
    return ins, outs

def midi_exchange(msg, wait=1.5, port="USB-Midi"):
    ins, outs = midi_ports()
    ii = [i for i, n in enumerate(ins) if n == port]
    oi = [i for i, n in enumerate(outs) if n == port]
    if len(ii) != 1 or len(oi) != 1:
        raise SystemExit(f"port MIDI '{port}' introuvable ou ambigu : IN={ins} OUT={outs}")
    hin, hout = wt.HANDLE(), wt.HANDLE()
    if winmm.midiInOpen(ctypes.byref(hin), ii[0], 0, 0, 0):
        raise SystemExit("impossible d'ouvrir l'entrée MIDI (M-UPGRADE ou un autre programme l'utilise ?)")
    bufs = []
    for _ in range(4):
        b = ctypes.create_string_buffer(2048); h = MIDIHDR(); h.lpData = ctypes.cast(b, ctypes.c_void_p); h.dwBufferLength = 2048
        winmm.midiInPrepareHeader(hin, ctypes.byref(h), ctypes.sizeof(h)); winmm.midiInAddBuffer(hin, ctypes.byref(h), ctypes.sizeof(h))
        bufs.append((b, h))
    winmm.midiInStart(hin)
    if winmm.midiOutOpen(ctypes.byref(hout), oi[0], 0, 0, 0):
        raise SystemExit("impossible d'ouvrir la sortie MIDI")
    mb = ctypes.create_string_buffer(msg, len(msg)); mh = MIDIHDR(); mh.lpData = ctypes.cast(mb, ctypes.c_void_p); mh.dwBufferLength = len(msg)
    winmm.midiOutPrepareHeader(hout, ctypes.byref(mh), ctypes.sizeof(mh)); winmm.midiOutLongMsg(hout, ctypes.byref(mh), ctypes.sizeof(mh))
    time.sleep(wait)
    winmm.midiInStop(hin); winmm.midiInReset(hin)
    got = [b.raw[:h.dwBytesRecorded] for b, h in bufs if h.dwBytesRecorded]
    winmm.midiOutUnprepareHeader(hout, ctypes.byref(mh), ctypes.sizeof(mh)); winmm.midiOutClose(hout)
    for b, h in bufs: winmm.midiInUnprepareHeader(hin, ctypes.byref(h), ctypes.sizeof(h))
    winmm.midiInClose(hin)
    return got

# M-VAVE : F0 pack7(00 59 cmd len24le payload ~sum(payload)) F7
def packet(cmd, payload=b""):
    return b"\x00\x59" + bytes([cmd]) + len(payload).to_bytes(3, "little") + payload + bytes([~sum(payload) & 0xFF])

# pack7 des SysEx M-VAVE (format d'interopérabilité) : flux de bits LSB d'abord, groupes de 7 bits
def pack7(data):
    out, acc, nb = bytearray(), 0, 0
    for b in data:
        acc |= b << nb; nb += 8
        while nb >= 7:
            out.append(acc & 0x7F); acc >>= 7; nb -= 7
    if nb:
        out.append(acc & 0x7F)
    return bytes(out)

def unpack7(data):
    out, acc, nb = bytearray(), 0, 0
    for v in data:
        acc |= (v & 0x7F) << nb; nb += 7
        while nb >= 8:
            out.append(acc & 0xFF); acc >>= 8; nb -= 8
    return bytes(out)

def parse_packet(p):
    if len(p) < 7 or p[:2] != b"\x00\x59":
        return None
    n = int.from_bytes(p[3:6], "little")
    pay = p[6:6 + n]
    if len(pay) != n or len(p) < 7 + n or p[6 + n] != (~sum(pay) & 0xFF):
        return None
    return p[2], pay

def identify():
    msg = b"\xF0" + pack7(packet(CMD_INFO)) + b"\xF7"
    got = midi_exchange(msg)
    print("envoyé", msg.hex(" "), "| reçu", [g.hex(" ") for g in got])
    for raw in got:
        for part in raw.split(b"\xF7"):
            if b"\xF0" not in part: continue
            r = parse_packet(unpack7(part[part.index(b"\xF0") + 1:]))
            if r and r[0] == CMD_INFO:
                return r[1].split(b"\0")[0].decode("ascii", "replace")
    return None

# ------------------------------------------------------------------ SCSI (d'après jl-uboot-tool, MIT)
class SPTD(ctypes.Structure):
    _fields_ = [("len", wt.WORD), ("status", wt.BYTE), ("path_id", wt.BYTE), ("target_id", wt.BYTE), ("lun", wt.BYTE),
                ("cdb_len", wt.BYTE), ("sense_len", wt.BYTE), ("dir", wt.BYTE), ("data_len", wt.DWORD), ("timeout", wt.DWORD),
                ("data_ptr", ctypes.POINTER(wt.BYTE)), ("sense_off", wt.DWORD), ("cdb", wt.BYTE * 16)]
k32 = ctypes.WinDLL("kernel32", use_last_error=True)
k32.CreateFileW.restype = wt.HANDLE
k32.CreateFileW.argtypes = [wt.LPCWSTR, wt.DWORD, wt.DWORD, wt.LPVOID, wt.DWORD, wt.DWORD, wt.HANDLE]
INVALID = wt.HANDLE(-1).value

class SCSIDev:
    def __init__(self, path):
        self.h = k32.CreateFileW(path, 3, 3, None, 3, 0, None)
        if self.h == INVALID:
            raise OSError(ctypes.get_last_error(), f"ouverture {path}")
    def close(self):
        for a in getattr(self, "aliases", []):                      # lecteurs mis au repos par quiet_aliases
            x = wt.DWORD(); k32.DeviceIoControl(a.h, 0x9001C, None, 0, None, 0, ctypes.byref(x), None)   # FSCTL_UNLOCK_VOLUME
            a.close()
        self.aliases = []
        if self.h: k32.CloseHandle(self.h); self.h = None
    def execute(self, cdb, data_out=None, data_in_len=0, timeout=10):
        s = SPTD(); s.len = ctypes.sizeof(s); s.target_id = 1; s.timeout = timeout; s.cdb_len = len(cdb)
        for i, b in enumerate(cdb): s.cdb[i] = b
        buf = None
        if data_out is not None:
            s.dir = 0; s.data_len = len(data_out); buf = ctypes.create_string_buffer(bytes(data_out), len(data_out))
        elif data_in_len:
            s.dir = 1; s.data_len = data_in_len; buf = ctypes.create_string_buffer(data_in_len)
        else:
            s.dir = 2
        if buf is not None: s.data_ptr = ctypes.cast(buf, ctypes.POINTER(wt.BYTE))
        x = wt.DWORD()
        if not k32.DeviceIoControl(self.h, 0x4D014, ctypes.byref(s), s.len, ctypes.byref(s), s.len, ctypes.byref(x), None):
            raise OSError(ctypes.get_last_error(), "IOCTL_SCSI_PASS_THROUGH_DIRECT")
        return buf.raw[:s.data_len] if (buf is not None and data_out is None) else b""
    def device_number(self):
        """(type, numéro) du disque physique derrière ce chemin (IOCTL_STORAGE_GET_DEVICE_NUMBER), None si inconnu :
        une lettre de lecteur (\\\\.\\D:) et \\\\.\\PhysicalDriveN peuvent désigner la même pédale."""
        out = (wt.DWORD * 3)(); x = wt.DWORD()
        if not k32.DeviceIoControl(self.h, 0x2D1080, None, 0, ctypes.byref(out), ctypes.sizeof(out), ctypes.byref(x), None):
            return None
        return (out[0], out[1])
    def inquiry(self):
        d = self.execute(b"\x12\x00\x00\x00\x24\x00", data_in_len=36)
        return d[8:16].decode("ascii", "replace").strip(), d[16:32].decode("ascii", "replace").strip(), d[32:36].decode("ascii", "replace").strip()

def cdb(cmd, args):
    c = cmd.to_bytes(2, "big") + args
    return c + b"\xFF" * (16 - len(c))

def _retry(what, fn, tries=6):
    """Erreurs USB passagères (Errno 31 ERROR_GEN_FAILURE, 1117, 121…) : vues chez un utilisateur dont Windows lisait le disque
    UBOOT en parallèle (lettre de lecteur). Lectures, effacements et écritures sont rejouables sans risque : chaque secteur
    écrit est de toute façon relu et comparé. Jamais utilisé pour les sauts (mem_jump), qui ne répondent pas normalement."""
    for essai in range(tries):
        try:
            return fn()
        except OSError as e:
            if essai == tries - 1: raise
            print(f"  erreur USB passagère ({what} : {e}), nouvel essai", flush=True)
            time.sleep(0.3 * (essai + 1))

class Loader:   # UBOOT1.00 + LoaderV2, sous-ensemble LECTURE (plus mem_write/jump en RAM)
    def __init__(self, dev): self.dev = dev; self.full = False
    def cmd(self, cmd, args):
        r = self.dev.execute(cdb(cmd, args), data_in_len=16)
        if int.from_bytes(r[:2], "big") != cmd:
            raise OSError(0, f"réponse inattendue à la commande {cmd:#06x}: {r.hex(' ')}")
        return r[2:]
    def mem_write(self, addr, data):
        _retry(f"RAM {addr:#x}", lambda: self.dev.execute(cdb(0xFB06, addr.to_bytes(4, "big") + len(data).to_bytes(2, "big") + b"\x00" + crc16(data).to_bytes(2, "little")), data_out=data))
    def mem_read(self, addr, n):
        return _retry(f"RAM {addr:#x}", lambda: self.dev.execute(cdb(0xFD07, addr.to_bytes(4, "big") + n.to_bytes(2, "big")), data_in_len=n))
    def mem_jump(self, addr, arg=0):
        return self.cmd(0xFB08, addr.to_bytes(4, "big") + arg.to_bytes(2, "big"))
    def chip_key(self):
        r = self.cmd(0xFC09, (0xAC6900).to_bytes(4, "big"))
        return int.from_bytes(crc_cipher(r[4:6][::-1]), "little")
    def online_device(self):
        r = self.cmd(0xFC0A, b"")
        return r[0], int.from_bytes(r[2:6], "little")
    def flash_read(self, addr, n):
        return _retry(f"lecture {addr:#07x}", lambda: self.dev.execute(cdb(0xFD05, addr.to_bytes(4, "big") + n.to_bytes(2, "big")), data_in_len=n))
    # ÉCRITURE FLASH (protocole LoaderV2 de jl-uboot-tool, docs/usb-loader-v2.md) : données envoyées telles quelles (déjà chiffrées SFC)
    def flash_erase_sector(self, addr):
        _flash_guard(addr, 0x1000, self.full)
        return _retry(f"effacement {addr:#07x}", lambda: self.cmd(0xFB01, addr.to_bytes(4, "big")))
    def flash_write(self, addr, data):
        _flash_guard(addr, len(data), self.full)
        _retry(f"écriture {addr:#07x}", lambda: self.dev.execute(cdb(0xFB04, addr.to_bytes(4, "big") + len(data).to_bytes(2, "big") + b"\x00" + crc16(data).to_bytes(2, "little")),
                                                                  data_out=data, timeout=20))

# Zone normale : application + stockage maison [0x4000, 0xA7000) (V19 : VM à 0xA7000).
# Restauration complète : [0x4000, 0x100000), pour remettre aussi VM / BTIF / USR d'origine.
# Jamais le SPL [0, 0x4000).
FLASH_W_LO, FLASH_W_HI = 0x4000, 0xA7000
CAB_LO, CAB_HI = 0xF3000, 0xFF000          # cabs d'usine (IR) du firmware TBBR : seule zone autorisée au-delà de 0xA7000
def _flash_guard(addr, n, full=False):
    hi = FLASH_SIZE if full else FLASH_W_HI
    if CAB_LO <= addr and addr + n <= CAB_HI: pass
    elif addr < FLASH_W_LO or addr + n > hi:
        raise SystemExit(f"REFUS : écriture/effacement hors zone autorisée ({addr:#x}+{n:#x})")
    if n == 0x1000 and addr % 0x1000:
        raise SystemExit(f"REFUS : effacement non aligné sur 4 Ko ({addr:#x})")

def candidate_paths():
    paths = [f"\\\\.\\{chr(c)}:" for c in range(ord("D"), ord("Z") + 1) if os.path.exists(f"{chr(c)}:\\") or True]
    paths += [f"\\\\.\\PhysicalDrive{i}" for i in range(16)]
    return paths

def find_uboot(verbose=True):
    """Disques UBOOT présents, un seul chemin par disque physique. Selon le PC, Windows donne aussi une lettre de lecteur
    au disque UBOOT : la même pédale apparaît alors en \\\\.\\D: ET en \\\\.\\PhysicalDriveN (on garde PhysicalDriveN)."""
    found, seen = [], {}
    for p in candidate_paths():
        try:
            d = SCSIDev(p)
        except OSError:
            continue
        try:
            v, pr, rev = d.inquiry()
            if verbose and (pr.startswith(("UBOOT", "UDISK", "DEVICE")) or v.startswith("WL8")):
                print(f"  {p}: {v} {pr} {rev}")
            if pr.startswith("UBOOT") or v == "WL82":
                key = d.device_number() or p
                if key in seen:                                       # même disque déjà vu par un autre chemin
                    if "PhysicalDrive" in p: found[seen[key]] = (p, v, pr, rev)
                    continue
                seen[key] = len(found)
                found.append((p, v, pr, rev))
        except OSError:
            pass
        finally:
            d.close()
    if any("PhysicalDrive" in f[0] for f in found):                  # numéro de disque refusé sur une lettre : chaque
        found = [f for f in found if "PhysicalDrive" in f[0]]         # pédale a de toute façon son PhysicalDriveN
    return found

def sha(path): return hashlib.sha256(open(path, "rb").read()).hexdigest()

def open_session():
    f = find_uboot()
    if len(f) != 1:
        raise SystemExit(f"il faut exactement un disque UBOOT, trouvé : {f}")
    path, v, pr, rev = f[0]
    print(f"UBOOT : {path} -> {v} {pr} {rev}")
    dev = SCSIDev(path)
    dev.aliases = quiet_aliases(dev, path)
    return dev, v, pr

def quiet_aliases(dev, path):
    """Si Windows a donné une lettre de lecteur au disque UBOOT, il y lit en parallèle (Explorateur, antivirus, système de
    fichiers) et ces lectures font échouer les commandes du loader (Errno 31 chez un utilisateur). Le volume est verrouillé et
    démonté pendant la session (lettres qui désignent le MÊME disque physique seulement), puis libéré par dev.close()."""
    num, out = dev.device_number(), []
    if not num: return out
    for c in range(ord("C"), ord("Z") + 1):
        p = f"\\\\.\\{chr(c)}:"
        if p == path: continue
        try: a = SCSIDev(p)
        except OSError: continue
        if a.device_number() != num: a.close(); continue
        x = wt.DWORD()
        locked = k32.DeviceIoControl(a.h, 0x90018, None, 0, None, 0, ctypes.byref(x), None)        # FSCTL_LOCK_VOLUME
        dism = k32.DeviceIoControl(a.h, 0x90020, None, 0, None, 0, ctypes.byref(x), None)          # FSCTL_DISMOUNT_VOLUME
        print(f"lecteur {chr(c)}: (même pédale) mis au repos pendant l'opération" + ("" if locked and dism else f" (verrou {bool(locked)}, démontage {bool(dism)})"))
        out.append(a)
    return out

def start_loader(dev, pr):
    ldr = Loader(dev)
    active = False
    for essai in range(3):                                         # une erreur passagère ne doit pas faire renvoyer le loader
        try: active = ldr.chip_key() == CHIP_KEY; break           # par-dessus un loader déjà en marche
        except OSError: time.sleep(0.3)
    if os.environ.get("BB_LOADER_ACTIVE") or active:   # loader déjà lancé dans cette session UBOOT : ne pas le recharger
        if not active: raise SystemExit("BB_LOADER_ACTIVE : le loader ne répond pas comme attendu")
        print("loader déjà actif")
        return ldr
    if pr == "UBOOT1.00":
        if sha(LOADER) != LOADER_SHA: raise SystemExit("wl82loader.bin : empreinte incorrecte")
        blob = open(LOADER, "rb").read()
        for off in range(0, len(blob), BLOCK):   # wl82 : blob déjà au format attendu (quirk mengli), envoyé tel quel
            ldr.mem_write(LOADER_ADDR + off, blob[off:off + BLOCK])
        print(f"loader envoyé ({len(blob)} o) à {LOADER_ADDR:#x}, saut avec arg {LOADER_ARG}")
        ldr.mem_jump(LOADER_ADDR, LOADER_ARG)
        time.sleep(0.5)
    else:
        print(f"produit {pr!r} : loader supposé déjà actif")
    return ldr

def backup(outdir):
    dev, v, pr = open_session()
    try:
        ldr = start_loader(dev, pr)
        key = ldr.chip_key()
        typ, fid = ldr.online_device()
        print(f"chip key = {key:#06x} ; online device type {typ:#x} id {fid:#08x}")
        if key != CHIP_KEY:
            raise SystemExit(f"chip key inattendue ({key:#06x}) : arrêt, rien n'est lu")
        passes = []
        for n in (1, 2):
            t0 = time.time(); buf = bytearray()
            for a in range(0, FLASH_SIZE, BLOCK):
                for essai in range(5):
                    try:
                        buf += ldr.flash_read(a, BLOCK); break
                    except OSError as e:
                        print(f"  erreur lecture {a:#07x} ({e}), nouvel essai"); time.sleep(0.5 * (essai + 1))
                else:
                    raise SystemExit(f"lecture impossible à {a:#07x}")
                if a % 0x20000 == 0: print(f"  passe {n} : {a // 1024} Ko", flush=True)
            passes.append(bytes(buf)); print(f"passe {n} terminée en {time.time() - t0:.1f} s, sha256 {hashlib.sha256(buf).hexdigest()}")
        if passes[0] != passes[1]:
            print("les deux lectures diffèrent : troisième lecture")
            buf = b"".join(ldr.flash_read(a, BLOCK) for a in range(0, FLASH_SIZE, BLOCK))
            if buf == passes[0]: passes[1] = buf
            elif buf == passes[1]: passes[0] = buf
            else: raise SystemExit("trois lectures différentes : copie non fiable, rien n'est sauvé")
        img = passes[0]
        os.makedirs(outdir, exist_ok=True)
        fn = os.path.join(outdir, "flash_full_1MiB.bin")
        open(fn, "wb").write(img)
        if open(fn, "rb").read() != img: raise SystemExit("relecture du fichier sauvé incorrecte")
        h = hashlib.sha256(img).hexdigest()
        open(os.path.join(outdir, "SHA256SUMS.txt"), "w").write(f"{h}  flash_full_1MiB.bin\n")
        json.dump({"date": datetime.datetime.now().isoformat(timespec="seconds"), "inquiry": [v, pr], "chip_key": f"{key:#06x}",
                   "online_device": {"type": typ, "id": f"{fid:#08x}"}, "size": len(img), "sha256": h},
                  open(os.path.join(outdir, "flashdump_info.json"), "w"), indent=2)
        print(f"SAUVEGARDE OK : {fn}\nsha256 {h}")
    finally:
        dev.close()

def reboot():
    dev, v, pr = open_session()
    try:
        ldr = Loader(dev)
        if sha(REBOOT) != REBOOT_SHA: raise SystemExit("reboot.bin : empreinte incorrecte")
        blob = open(REBOOT, "rb").read()
        # wl82 (jl-uboot-tool chips.yaml : memory-rw-mengli-crypt) : écriture ET lecture RAM passent par le chiffrement
        # CrcDecode ; on envoie donc reboot.bin chiffré, et une relecture == données chiffrées prouve que la RAM le contient en clair.
        # (Vérifié 2026-11-19 : la relecture rend bien les octets chiffrés.)
        enc = crc_cipher(blob)
        ldr.mem_write(PAYLOAD_LOAD, enc)
        back = ldr.mem_read(PAYLOAD_LOAD, len(blob))
        if back != enc:
            raise SystemExit(f"relecture RAM inattendue : pas de saut. Éteindre/rallumer la pédale.\n{back[:32].hex(' ')}")
        print("reboot.bin en RAM vérifié, saut...")
        try:
            ldr.mem_jump(PAYLOAD_LOAD, 0); print("le saut a répondu (la pédale n'a peut-être pas redémarré)")
        except OSError as e:
            print(f"pas de réponse au saut ({e}) : normal, la puce redémarre")
    finally:
        dev.close()

def ram_load(ldr, addr, blob, chunk=256):
    """Écrit blob en RAM par blocs (chiffrés CrcDecode bloc par bloc, comme le loader l'attend) et vérifie chaque bloc."""
    for off in range(0, len(blob), chunk):
        part = blob[off:off + chunk]
        enc = crc_cipher(part)
        ldr.mem_write(addr + off, enc)
        back = ldr.mem_read(addr + off, len(part))
        if back != enc:
            raise SystemExit(f"vérification RAM échouée à {addr + off:#x} : pas de saut. Éteindre/rallumer la pédale.")

def runram(path, addr):
    """Programme de test en RAM : charge reboot.bin (0x1C20000, pour le redémarrage final) + le programme, puis saute.
    AUCUNE écriture en flash. Si quelque chose tourne mal : éteindre/rallumer la pédale (le firmware en flash est intact)."""
    if not (0x1C30000 <= addr < 0x1C70000):
        raise SystemExit("adresse hors de la zone prévue 0x1C30000-0x1C70000")
    prog = open(path, "rb").read()
    if addr + len(prog) > 0x1C70000:
        raise SystemExit("programme trop gros")
    if sha(REBOOT) != REBOOT_SHA: raise SystemExit("reboot.bin : empreinte incorrecte")
    dev, v, pr = open_session()
    try:
        ldr = start_loader(dev, pr)
        key = ldr.chip_key()
        if key != CHIP_KEY:
            raise SystemExit(f"chip key inattendue ({key:#06x}) : arrêt")
        ram_load(ldr, PAYLOAD_LOAD, open(REBOOT, "rb").read())
        print(f"reboot.bin chargé et vérifié à {PAYLOAD_LOAD:#x}")
        ram_load(ldr, addr, prog)
        print(f"{os.path.basename(path)} ({len(prog)} o, sha256 {hashlib.sha256(prog).hexdigest()[:16]}) chargé et vérifié à {addr:#x}, saut...")
        try:
            ldr.mem_jump(addr, 0); print("le saut a répondu")
        except OSError as e:
            print(f"pas de réponse au saut ({e}) : normal, le programme tourne")
    finally:
        dev.close()

STORE_LO = 0x60000     # zone de stockage du firmware maison (presets, IR, captures) : [0x60000, 0xA7000)
def flash_app(img_path, ref_path, keep_storage=True, full=False):
    """Écrit la zone application [0x4000, 0xA7000) de img sur la pédale, secteur par secteur (seulement ceux qui diffèrent),
    avec relecture/vérification. Avec full=True, restaure [0x4000, 0x100000) (VM/BTIF/USR compris) sans jamais toucher le SPL.
    Refuse si : image invalide (contrôles du SPL), SPL de l'image != SPL de la référence ou de la pédale, autre pédale."""
    sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
    import mkfw
    img, ref = open(img_path, "rb").read(), open(ref_path, "rb").read()
    if len(img) != FLASH_SIZE or len(ref) != FLASH_SIZE: raise SystemExit("images de 1 MiB attendues")
    if img[:FLASH_W_LO] != ref[:FLASH_W_LO]: raise SystemExit("REFUS : le SPL de l'image diffère de la sauvegarde de référence")
    plain = mkfw.sfc(img[FLASH_W_LO:FLASH_W_HI])
    ents = mkfw.check_area(plain, FLASH_W_HI - FLASH_W_LO)         # lève une erreur si le SPL refuserait l'image
    print("image valide :", ", ".join(f"{e['name']}({e['size']:#x})" for e in ents[:3]))
    dev, v, pr = open_session()
    try:
        ldr = start_loader(dev, pr)
        ldr.full = full
        if ldr.chip_key() != CHIP_KEY: raise SystemExit("chip key inattendue : arrêt")
        if full:                                                   # la sauvegarde doit venir de CETTE pédale
            info = os.path.join(os.path.dirname(os.path.abspath(ref_path)), "flashdump_info.json")
            if os.path.exists(info):
                want = json.load(open(info, encoding="utf-8")).get("online_device", {}).get("id")
                typ, fid = ldr.online_device()
                if want and int(want, 16) != fid:
                    raise SystemExit(f"REFUS : sauvegarde d'une autre pédale (id {want}, pédale {fid:#08x})")
        def rd(a, n): return b"".join(ldr.flash_read(a + o, BLOCK) for o in range(0, n, BLOCK))
        if rd(0, FLASH_W_LO) != img[:FLASH_W_LO]: raise SystemExit("REFUS : le SPL de la pédale diffère de l'image (autre pédale ?)")
        t0 = time.time()
        hi = FLASH_SIZE if full else (STORE_LO if keep_storage else FLASH_W_HI)
        cur = rd(FLASH_W_LO, hi - FLASH_W_LO)
        todo = [s for s in range(FLASH_W_LO, hi, 0x1000)
                if cur[s - FLASH_W_LO:s - FLASH_W_LO + 0x1000] != img[s:s + 0x1000]]
        cabs = not full and mkfw.has_cabs(img)                    # l'image porte les cabs d'usine : zone [0xF3000, 0xFF000) aussi
        if cabs:
            curc = rd(CAB_LO, CAB_HI - CAB_LO)
            todo += [s for s in range(CAB_LO, CAB_HI, 0x1000) if curc[s - CAB_LO:s - CAB_LO + 0x1000] != img[s:s + 0x1000]]
        # Ordre d'écriture : le début de l'app TBBR (secteurs < BOOT_HI) contient l'entrée de secours « HOME tenu à l'allumage
        # -> UBOOT » (main.c, code autonome). Vers TBBR : ces secteurs d'abord (secours disponible au plus tôt) ; vers un autre
        # firmware (restauration) : en dernier (le secours de l'ancien TBBR reste en place si l'écriture est interrompue).
        BOOT_HI = 0x7000
        boot, rest = [s for s in todo if s < BOOT_HI], [s for s in todo if s >= BOOT_HI]
        todo = boot + rest if b"TBBR fw" in plain else rest + boot
        if keep_storage and not full: print(f"zone de stockage [{STORE_LO:#x}, {FLASH_W_HI:#x}) conservée (--tout pour l'écrire aussi)" + (" ; cabs d'usine mis à jour" if cabs else ""))
        if full: print(f"restauration complète [{FLASH_W_LO:#x}, {hi:#x}) ; SPL [0, {FLASH_W_LO:#x}) intact")
        print(f"zone lue en {time.time() - t0:.0f} s ; secteurs à écrire : {[hex(s) for s in todo]}")
        for s in todo:
            want = img[s:s + 0x1000]
            for essai in range(1, 6):
                try:
                    ldr.flash_erase_sector(s)
                    for o in range(0, 0x1000, BLOCK):
                        ldr.flash_write(s + o, want[o:o + BLOCK])
                    ok = rd(s, 0x1000) == want
                except OSError as e:                               # erreur USB persistante : on recommence le secteur
                    print(f"  secteur {s:#07x} : erreur USB ({e}), nouvel essai", flush=True)
                    time.sleep(1.0 * essai); continue
                if ok:
                    print(f"  secteur {s:#07x} écrit et vérifié" + (f" (essai {essai})" if essai > 1 else "")); break
                print(f"  secteur {s:#07x} : relecture différente, nouvel essai")
            else:
                raise SystemExit(f"ÉCHEC au secteur {s:#x} : NE PAS éteindre la pédale, relancer flashapp (avec la sauvegarde pour restaurer)")
        final = rd(FLASH_W_LO, hi - FLASH_W_LO)
        if final != img[FLASH_W_LO:hi]: raise SystemExit("vérification finale : DIFFÉRENCE (ne pas éteindre)")
        if cabs and rd(CAB_LO, CAB_HI - CAB_LO) != img[CAB_LO:CAB_HI]: raise SystemExit("vérification finale des cabs : DIFFÉRENCE (ne pas éteindre)")
        print(f"ÉCRITURE TERMINÉE ET VÉRIFIÉE (zone {'complète' if full else 'application'} = image, sha256 {hashlib.sha256(final).hexdigest()[:16]})")
    finally:
        dev.close()

DIAG_ADDR, MBOX, RESA, MAGIC =0x1C40000, 0x1C60000, 0x1C60100, 0xB1ACB0C5

def ram_read_plain(ldr, addr, n):
    """La lecture RAM passe par CrcDecode : données en clair = crc_cipher(lecture), clé repartant à chaque transfert."""
    return crc_cipher(ldr.mem_read(addr, n))

def diag(path, steps):
    """Programme de diagnostic qui REVIENT au loader : écrit une commande en RAM, saute, relit les résultats. Aucune écriture flash."""
    import struct
    prog = open(path, "rb").read()
    dev, v, pr = open_session()
    try:
        ldr = start_loader(dev, pr)
        if ldr.chip_key() != CHIP_KEY: raise SystemExit("chip key inattendue")
        ram_load(ldr, PAYLOAD_LOAD, open(REBOOT, "rb").read())
        ram_load(ldr, DIAG_ADDR, prog)
        print(f"diag ({len(prog)} o) chargé à {DIAG_ADDR:#x}")
        for st in steps:
            if st.startswith("pause"):
                s = float(st[5:] or 10); print(f"--- {time.strftime('%H:%M:%S')} pause {s:.0f} s"); time.sleep(s)
                ram_load(ldr, RESA, bytes(4))      # petit échange pour vérifier que le loader répond encore
                print(f"--- {time.strftime('%H:%M:%S')} fin de pause, loader toujours là"); continue
            if st in ("ubootexit", "resetplain"):
                # ubootexit : la pédale doit redémarrer et revenir en disque UBOOT ; resetplain : même reset sans le mot magique
                ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 12, 1 if st == "resetplain" else 0, 0))
                try:
                    ldr.mem_jump(DIAG_ADDR, 0); print("--- ubootexit : le saut a répondu (?)")
                except OSError as e:
                    print(f"--- ubootexit : pas de réponse ({e}) : la puce redémarre")
                dev.close()
                for i in range(20):
                    time.sleep(1)
                    f = find_uboot(verbose=False)
                    if f:
                        print(f"--- disque UBOOT revenu après {i + 1} s : {f[0][1]} {f[0][2]}  => PORTE DE SORTIE OK"); break
                else:
                    print("--- pas de disque UBOOT après 20 s (la pédale est sans doute repartie en mode normal)")
                return
            if st.startswith("standalone"):
                # standalone[:pile] : exécution sur une pile à nous avec watchdog réarmé, puis retour au loader
                sp = int(st.split(":")[1], 0) if ":" in st else 0
                ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 11, sp, 0))
                t0 = time.time()
                try:
                    ldr.mem_jump(DIAG_ADDR, 0); jr = "retour OK"
                except OSError as e:
                    jr = f"PAS DE RETOUR ({e})"
                dt = time.time() - t0
                try:
                    s0, s1, s2, s3 = struct.unpack("<4I", ram_read_plain(ldr, RESA + 8, 16))
                    print(f"--- autonome (pile {sp or 0x1C3FFF0:#x}) : {jr} en {dt:.1f} s ; état={s0:#010x} (FF = fini) &pile={s1:#010x} pas={s2}/24 contrôle pile={s3:#010x} (attendu 0x55555555)")
                except OSError as e:
                    print(f"--- autonome : {jr} ; loader injoignable ensuite ({e})")
                continue
            if st.startswith("ramdump"):
                # ramdump:<adresse>:<longueur>:<fichier> : copie d'une zone de RAM (lecture seule, par blocs de 512 o)
                _, a, n, out = st.split(":", 3); a, n = int(a, 0), int(n, 0)
                data = b"".join(ram_read_plain(ldr, a + o, min(512, n - o)) for o in range(0, n, 512))
                open(out, "wb").write(data)
                print(f"--- RAM [{a:#x}, {a + n:#x}) -> {out}")
                continue
            if st.startswith("p33dump"):
                # p33dump:<fichier> : relevé des 256 premiers registres P33 (lecture seule, commande 20 de diag.c)
                out = st.split(":", 1)[1] if ":" in st else "p33dump.txt"
                ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 20, 0, 0))
                ldr.mem_jump(DIAG_ADDR, 0)
                st0 = struct.unpack("<I", ram_read_plain(ldr, RESA, 4))[0]
                regs = struct.unpack("<256I", ram_read_plain(ldr, RESA + 8, 1024))
                with open(out, "w", encoding="utf-8") as f:
                    for k in range(256): f.write(f"{k:#04x} {regs[k] & 0xFF:#04x}\n")
                print(f"--- P33 relevé ({st0:#010x}) -> {out} ; WDT_CON={regs[0x80] & 0xFF:#04x} VLVD={regs[0x11] & 0xFF:#04x} ANA5={regs[5] & 0xFF:#04x} ANA6={regs[6] & 0xFF:#04x} ANA9={regs[9] & 0xFF:#04x}")
                continue
            if st.startswith("ladcscan"):
                # ladcscan<secondes> : ouvre l'ADC intégré (AUX1 = PH07, AUX3 = PH04, 4 voies) et journalise l'amplitude de chaque voie
                secs = float(st[8:] or 20)
                ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 10, 1 | (2 << 8), 0))
                ldr.mem_jump(DIAG_ADDR, 0)
                con = struct.unpack("<I", ram_read_plain(ldr, RESA + 8, 4))[0]
                print(f"--- {time.strftime('%H:%M:%S')} ADC intégré ouvert : ADC_CON={con:#010x} ; mesure pendant {secs:.0f} s")
                t_end = time.time() + secs
                while time.time() < t_end:
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 10, 2, 300))   # 300 blocs de 64 trames = 0,4 s
                    ldr.mem_jump(DIAG_ADDR, 0)
                    r = struct.unpack("<9i", ram_read_plain(ldr, RESA + 8, 36))
                    if r[8] == 0:
                        print("   aucun bloc reçu : l'ADC ne tourne pas"); break
                    pp = [r[2 * c + 1] - r[2 * c] for c in range(4)]
                    print(f"   {time.strftime('%H:%M:%S')}  crête-à-crête  voie0(AUX0)={pp[0]:6d}  voie1(AUX1/PH07)={pp[1]:6d}  voie2(AUX2)={pp[2]:6d}  voie3(AUX3/PH04)={pp[3]:6d}   blocs={r[8]}")
                ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 10, 3, 0)); ldr.mem_jump(DIAG_ADDR, 0)
                continue
            if st.startswith("aud"):
                # audstart[:décalage] | audmeasure[:moitiés] | audstop
                def aud(op, a2=0):
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, op, a2))
                    t0 = time.time(); ldr.mem_jump(DIAG_ADDR, 0); dt = time.time() - t0
                    return dt, struct.unpack("<8I", ram_read_plain(ldr, RESA + 8, 32))
                if st == "audprobe":
                    # une seule mesure (variante 0) : activité de PA08 et crête reçue
                    aud(4)
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 6, 100000)); ldr.mem_jump(DIAG_ADDR, 0)
                    a7, a8, a9, a10, lv = struct.unpack("<5I", ram_read_plain(ldr, RESA + 8, 20))
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 5, 100)); ldr.mem_jump(DIAG_ADDR, 0)
                    pl, pr_, nd = struct.unpack("<3I", ram_read_plain(ldr, RESA + 8, 12))
                    print(f"   audprobe : changements PA08={a8:6d}  PORTA IN={lv:#06x}  crête G={pl:5d} D={pr_:5d}  moitiés={nd}")
                    aud(3)
                    continue
                if st == "audvariants":
                    # 16 configurations ALINK : activité de PA08 + crête reçue (sans action de l'utilisateur)
                    for var in range(16):
                        aud(4 | (var << 8))
                        ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 6, 100000)); ldr.mem_jump(DIAG_ADDR, 0)
                        a7, a8, a9, a10, lv = struct.unpack("<5I", ram_read_plain(ldr, RESA + 8, 20))
                        ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 5, 100)); ldr.mem_jump(DIAG_ADDR, 0)
                        pl, pr_, nd = struct.unpack("<3I", ram_read_plain(ldr, RESA + 8, 12))
                        print(f"   variante {var:2d} [{'MCLK-off ' if var & 1 else 'MCLK-on  '}{'F32E ' if var & 2 else '     '}{'front ' if var & 4 else '      '}{'PA09=0' if var & 8 else 'PA09=1'}]"
                              f"  changements PA08={a8:6d} PA09={a9:5d} PA04..={lv:#06x}  crête G={pl:5d} D={pr_:5d}  moitiés={nd}")
                        aud(3)
                    continue
                if st.startswith("audthru"):
                    # audthru<secondes>[:gain]  passage direct ADC -> DAC par tranches de 2 s (750 moitiés de 128 trames)
                    spec = st[7:]; secs, _, g = spec.partition(":"); secs = float(secs or 20); g = int(g or 0)
                    aud(4)
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 6, 200000))
                    ldr.mem_jump(DIAG_ADDR, 0)
                    a7, a8, a9, a10, lv = struct.unpack("<5I", ram_read_plain(ldr, RESA + 8, 20))
                    print(f"--- activité des lignes (changements sur 200000 lectures) : PA07={a7} PA08={a8} PA09={a9} PA10={a10} ; PORTA IN={lv:#06x}")
                    print(f"--- {time.strftime('%H:%M:%S')} passage direct pendant {secs:.0f} s (gain x{1 << g})")
                    t_end = time.time() + secs
                    while time.time() < t_end:
                        ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 9, 5 | (g << 8), 750))
                        ldr.mem_jump(DIAG_ADDR, 0)
                        pl, pr, nd = struct.unpack("<3I", ram_read_plain(ldr, RESA + 8, 12))
                        print(f"   {time.strftime('%H:%M:%S')}  crête G={pl:5d}  D={pr:5d}  (sur 32767)  moitiés traitées={nd}")
                        if nd == 0: print("   aucune donnée reçue : arrêt"); break
                    aud(3)
                    continue
                if st.startswith("audstart"):
                    sh = int(st.split(":")[1]) if ":" in st else 0
                    dt, r = aud(1 | (sh << 8))
                    print(f"--- {time.strftime('%H:%M:%S')} audio démarré (1 kHz, amplitude 6000>>{sh}) : CON0={r[0]:#06x} CON1={r[1]:#06x} CON2={r[2]:#04x} CON3={r[3]:#04x} PLL_CON1={r[4]:#010x} CLK_CON2={r[5]:#010x} IOMAP5={r[6]:#010x}")
                elif st.startswith("audmeasure"):
                    nh = int(st.split(":")[1]) if ":" in st else 100
                    dt, r = aud(2, nh)
                    if r[0] == 0xFFFFFFFF:
                        print(f"--- mesure : AUCUNE moitié de tampon terminée -> l'horloge audio ne tourne pas (CON2={r[3]:#04x})")
                    else:
                        fs = nh * 480 / dt
                        print(f"--- mesure : {nh} moitiés de 480 trames en {dt:.3f} s -> fréquence d'échantillonnage ~ {fs:.0f} Hz (attendu 48000) ; tours d'attente {r[0]}")
                else:
                    dt, r = aud(3); print(f"--- {time.strftime('%H:%M:%S')} audio arrêté")
                continue
            if st.startswith("lcd"):
                # lcdinit | lcdfill:RRRR (couleur RGB565 hex) | lcdbars  — dessin par bandes de 24 lignes
                def lcd(op, a2):
                    ram_load(ldr, MBOX, struct.pack("<IIII", MAGIC, 8, op, a2))
                    t0 = time.time()
                    ldr.mem_jump(DIAG_ADDR, 0)
                    return time.time() - t0
                if st == "lcdinit":
                    print(f"--- écran : initialisation ({lcd(1, 0):.2f} s)")
                elif st == "lcdpins":
                    lcd(0, 0); print(f"--- {time.strftime('%H:%M:%S')} écran : broches PB en sortie (rien envoyé)")
                elif st.startswith("lcdpin:"):           # lcdpin:<bit>:<niveau>  une seule broche PB en sortie
                    _, bit, lvl = st.split(":")
                    lcd(5, int(bit) | (int(lvl) << 8)); print(f"--- {time.strftime('%H:%M:%S')} PB{int(bit):02d} seule en sortie = {lvl}")
                elif st == "lcdrel":
                    lcd(4, 0); print(f"--- {time.strftime('%H:%M:%S')} écran : broches PB remises en entrée")
                else:
                    op = 3 if st == "lcdbars" else 2
                    col = int(st.split(":")[1], 16) if ":" in st else 0
                    tt = 0.0
                    for y in range(0, 240, 24):
                        tt += lcd(op, y | ((y + 23) << 8) | (col << 16))
                    print(f"--- écran : {'barres' if op == 3 else f'couleur {col:#06x}'} ({tt:.2f} s)")
                continue
            if st.startswith("scan"):
                # balayage complet : entrées numériques PA..PH (cmd 6) + canaux ADC (cmd 7) ; journalise ce qui change
                dur = float(st[4:] or 60); t_end = time.time() + dur
                ADCN = ["PA07", "PA08", "PA10", "PB01", "PB06", "PB07", "PC00", "PC01", "PC09", "PC10", "PH00", "PH03"]
                def call(cmd, arg, nwords):
                    ram_load(ldr, MBOX, struct.pack("<III", MAGIC, cmd, arg))
                    ldr.mem_jump(DIAG_ADDR, 0)
                    return struct.unpack(f"<{nwords}I", ram_read_plain(ldr, RESA + 8, 4 * nwords))
                d0 = call(6, 1, 8); a0 = call(7, 0, 12)
                print(f"--- scan {dur:.0f} s ; état initial :")
                print("   IN " + " ".join(f"P{'ABCDEFGH'[k]}={d0[k]:#06x}" for k in range(8)))
                print("   ADC " + " ".join(f"{ADCN[c]}={a0[c]}" for c in range(12) if c not in (6, 7)))
                dprev, aprev = d0, list(a0)
                while time.time() < t_end:
                    d = call(6, 0, 8); a = call(7, 0, 12)
                    ch = []
                    for k in range(8):
                        diff = d[k] ^ dprev[k]
                        for b in range(16):
                            if diff >> b & 1: ch.append(f"P{'ABCDEFGH'[k]}{b:02d}={d[k] >> b & 1}")
                    for c in range(12):
                        if c in (6, 7): continue
                        if abs(a[c] - aprev[c]) > 24:
                            ch.append(f"ADC {ADCN[c]}={a[c]}"); aprev[c] = a[c]
                    if ch: print(f"   {time.strftime('%H:%M:%S')}  " + "  ".join(ch))
                    dprev = d
                continue
            if st.startswith("watch"):
                # boucle boutons -> LED ; journal des changements (PA0-3, PC0-1, PH6/8/9)
                dur = float(st[5:] or 30); t_end = time.time() + dur; last = None; enc_led = 0; last_pc = None
                print(f"--- watch {dur:.0f} s : appuyer sur les boutons, tourner l'encodeur")
                while time.time() < t_end:
                    ram_load(ldr, MBOX, struct.pack("<III", MAGIC, 5, enc_led))
                    try: ldr.mem_jump(DIAG_ADDR, 0)
                    except OSError as e: print("saut sans réponse", e); break
                    pa, pcv, ph, m, a9, a2, a8 = struct.unpack("<7I", ram_read_plain(ldr, RESA + 8, 28))
                    pcb = pcv & 3
                    if last_pc is not None and pcb != last_pc: enc_led ^= 1
                    last_pc = pcb
                    # les valeurs ADC sont arrondies à 16 près pour ne pas journaliser le bruit
                    state = (pa & 0xF, pcb, ph >> 6 & 1, ph >> 8 & 1, ph >> 9 & 1, a9 >> 4, a2 >> 5, a8 >> 5)
                    if state != last:
                        print(f"   {time.strftime('%H:%M:%S')}  PA3..0={pa & 15:04b}  PC1,0={pcb:02b}  PH6={ph >> 6 & 1} PH8={ph >> 8 & 1} PH9={ph >> 9 & 1}"
                              f"  | ADC PC10(ch9)={a9:4d} PA10(ch2)={a2:4d} PC09(ch8)={a8:4d}  -> LED {m:08b}")
                        last = state
                continue
            if st == "reboot":
                print("--- redémarrage (reboot.bin)")
                try: ldr.mem_jump(PAYLOAD_LOAD, 0)
                except OSError: pass
                return
            cmd, _, arg = st.partition(":")
            cmd, arg = int(cmd, 0), int(arg or "0", 0)
            ram_load(ldr, RESA, bytes(64))
            ram_load(ldr, MBOX, struct.pack("<III", MAGIC, cmd, arg))
            t0 = time.time()
            try:
                ldr.mem_jump(DIAG_ADDR, 0)
                jr = "le saut a répondu"
            except OSError as e:
                jr = f"pas de réponse au saut ({e})"
            res = struct.unpack("<64I", ram_read_plain(ldr, RESA, 256))
            print(f"--- commande {cmd} arg {arg:#x} : {jr} en {time.time() - t0:.2f} s ; état {res[0]:#010x} code {res[1]}")
            if cmd == 1:
                for x in range(8):
                    o, i, d, die, pu, pd = res[2 + 6 * x: 8 + 6 * x]
                    print(f"   P{'ABCDEFGH'[x]}: OUT={o:#06x} IN={i:#06x} DIR={d:#06x} DIE={die:#06x} PU={pu:#06x} PD={pd:#06x}")
            elif cmd == 2:
                n = ["OUT avant", "IN avant", "DIR avant", "DIE avant", "IN (PC05/06/08=0)", "IN (PC05/06/08=1)", "OUT après", "IN après", "DIR après", "DIE après"]
                for k, nm in enumerate(n):
                    w = res[2 + k]
                    print(f"   PORTC {nm:18s} = {w:#06x}  (PC05={w >> 5 & 1} PC06={w >> 6 & 1} PC07={w >> 7 & 1} PC08={w >> 8 & 1})")
            elif cmd == 4:
                for k, b in enumerate((5, 6, 7, 8)):
                    hi, lo = res[2 + 2 * k], res[3 + 2 * k]
                    print(f"   PC{b:02d} seule en sortie : =1 -> IN={hi:#06x} (PC{b:02d} lue {hi >> b & 1}) | =0 -> IN={lo:#06x} (lue {lo >> b & 1})")
                print(f"   HD0={res[10]:#06x} HD={res[11]:#06x}")
            elif cmd == 13:
                nm = ["ANA_CON4 nu", "+VBG_BUF", "+VBG_BUF+VBG_SEL"]
                for k, s in enumerate(nm):
                    print(f"   PMU {s:16s} = {res[2 + k]:5d} ({res[2 + k] * 3300 // 1023} mV pleine échelle)")
                print(f"   PC09 (SAR 8)         = {res[5]:5d} ({res[5] * 3300 // 1023} mV)")
            elif cmd == 14:
                nm = ["CHG_READ", "CHG_CON0", "CHG_WKUP", "LDO5V_CON", "PR_PWR", "WKUP_SRC", "USB_LAT"]
                for k, s in enumerate(nm):
                    v = res[2 + k]
                    print(f"   P3 {s:10s} = {v:#04x}" + ("  (bit0 full)" if k == 0 else "  (bit5 = 5 V détecté)" if k == 3 else ""))
            elif cmd == 15:
                nm = ["USB_CON0", "USB_CON1", "HUSB_COM0", "HUSB_PHY0", "HUSB_PHY1", "USB_IO0", "USB_IO1", "USB_IO2"]
                for k, s in enumerate(nm):
                    v = res[2 + k]
                    print(f"   {s:10s} = {v:#010x}" + ("   VBUS(bit5)=" + str((v >> 5) & 1) if k == 0 else "") + ("   VBUSVALID(bit25)=" + str((v >> 25) & 1) + " SESSEND(bit24)=" + str((v >> 24) & 1) if k == 3 else ""))
            elif cmd == 3:
                pa, pc, ph = res[2:5]
                print(f"   PA IN={pa:#06x} (PA0..3={pa & 15:04b})  PC IN={pc:#06x} (PC0,1={pc & 3:02b})  PH IN={ph:#06x} (PH6={ph >> 6 & 1} PH8={ph >> 8 & 1} PH9={ph >> 9 & 1})")
    finally:
        dev.close()

if __name__ == "__main__":
    c = sys.argv[1] if len(sys.argv) > 1 else ""
    if c == "identify":
        print("réponse :", identify())
    elif c == "softkey":
        name = identify()
        if not name or not name.startswith("BlackBox_"):
            raise SystemExit(f"identité {name!r} : la soft key n'est PAS envoyée")
        if find_uboot(False): raise SystemExit("un disque UBOOT est déjà présent : soft key non envoyée")
        midi_exchange(b"\xF0\x22\x24\x35\x7D\xF7", wait=0.5)
        print("soft key envoyée :", SOFT_KEY.hex(" "))
    elif c == "otakey":   # F0 22 24 35 7F F7 (OTA_KEY du bootloader JieLi) ; mêmes garde-fous que softkey
        name = identify()
        if not name or not name.startswith("BlackBox_"):
            raise SystemExit(f"identité {name!r} : le message n'est PAS envoyé")
        if find_uboot(False): raise SystemExit("un disque UBOOT est déjà présent : message non envoyé")
        midi_exchange(b"\xF0\x22\x24\x35\x7F\xF7", wait=0.5)
        print("OTA_KEY envoyée : f0 22 24 35 7f f7")
    elif c == "find":
        print(find_uboot())
    elif c == "backup":
        backup(sys.argv[2])
    elif c == "reboot":
        reboot()
    elif c == "diag":     # diag <diag.bin> 1 2:0x0FF pause10 3 reboot
        diag(sys.argv[2], sys.argv[3:])
    elif c == "peekraw":  # peekraw <adr> <longueur> ... : octets BRUTS renvoyés par le loader (= contenu laissé par le firmware d'origine)
        dev, v, pr = open_session()
        try:
            ldr = start_loader(dev, pr)
            a = sys.argv[2:]
            for k in range(0, len(a), 2):
                adr, ln = int(a[k], 0), int(a[k + 1], 0)
                data = b"".join(ldr.mem_read(adr + o, min(256, ln - o)) for o in range(0, ln, 256))
                for o in range(0, ln, 16):
                    row = data[o:o + 16]
                    words = " ".join(f"{int.from_bytes(row[i:i + 4], 'little'):08x}" for i in range(0, len(row), 4))
                    print(f"{adr + o:08x}: {row.hex(' '):48s}  {words}")
        finally:
            dev.close()
    elif c == "peek":     # peek <adr> <longueur> [<adr> <longueur> ...] : lecture RAM en clair via le loader (lecture seule)
        dev, v, pr = open_session()
        try:
            ldr = start_loader(dev, pr)
            a = sys.argv[2:]
            for k in range(0, len(a), 2):
                adr, ln = int(a[k], 0), int(a[k + 1], 0)
                data = b"".join(ram_read_plain(ldr, adr + o, min(256, ln - o)) for o in range(0, ln, 256))
                for o in range(0, ln, 16):
                    row = data[o:o + 16]
                    print(f"{adr + o:08x}: {row.hex(' '):48s} |{''.join(chr(x) if 32 <= x < 127 else '.' for x in row)}|")
        finally:
            dev.close()
    elif c == "bbc":        # firmware maison (fw4+) : bbc ping | state | stats | fx <masque> | bypass <0|1> | update | ports
        sub = sys.argv[2] if len(sys.argv) > 2 else "ping"
        if sub == "ports":
            print(midi_ports()); raise SystemExit(0)
        hdr = b"\xF0\x7D\x42\x58"
        if sub == "ping": body = b"\x01"
        elif sub == "state": body = b"\x02"
        elif sub == "stats": body = b"\x05"
        elif sub == "fx": v = int(sys.argv[3], 0); body = bytes([3, v & 0x7F, (v >> 7) & 0x7F])
        elif sub == "bypass": body = bytes([4, int(sys.argv[3]) & 1])
        elif sub == "update": body = b"\x7E\x55\x2A"
        elif sub == "flashid": body = b"\x16"
        elif sub == "peek":   # bbc peek <adr RAM> : 16 mots
            a = int(sys.argv[3], 0); body = b"\x15" + bytes((a >> (7 * i)) & 0x7F for i in range(5))
            got = midi_exchange(hdr + body + b"\xF7", wait=0.8, port="BlackBox Custom")
            for raw in got:
                for part in raw.split(b"\xF7"):
                    if hdr not in part: continue
                    s = part[part.index(hdr) + 5:]; out = bytearray(); i = 0
                    while i < len(s):
                        hi = s[i]; i += 1
                        for k in range(7):
                            if i >= len(s): break
                            out.append((s[i] & 0x7F) | (((hi >> k) & 1) << 7)); i += 1
                    for k in range(0, len(out), 16):
                        print(f"{a + k:08x}: " + " ".join(f"{int.from_bytes(out[k + j:k + j + 4], 'little'):08x}" for j in range(0, 16, 4)))
            raise SystemExit(0)
        elif sub == "storetest":
            # efface 0x60000, écrit 300 octets de motif en 3 morceaux, relit (XIP) et compare, puis CRC
            def p7(v): return bytes((v >> (7 * i)) & 0x7F for i in range(5))
            def pack7(b):
                out = bytearray()
                for i in range(0, len(b), 7):
                    g = b[i:i + 7]; out.append(sum(((x >> 7) & 1) << k for k, x in enumerate(g))); out += bytes(x & 0x7F for x in g)
                return bytes(out)
            def unpack7(s):
                out = bytearray(); i = 0
                while i < len(s):
                    hi = s[i]; i += 1
                    for k in range(7):
                        if i >= len(s): break
                        out.append((s[i] & 0x7F) | (((hi >> k) & 1) << 7)); i += 1
                return bytes(out)
            def ask(b, wait=0.6):
                got = midi_exchange(hdr + b + b"\xF7", wait=wait, port="BlackBox Custom")
                for raw in got:
                    for part in raw.split(b"\xF7"):
                        if hdr in part: return part[part.index(hdr) + 4:]
                return None
            base = int(sys.argv[3], 0) if len(sys.argv) > 3 else 0x60000
            pat = bytes((i * 37 + 11 + base // 4096) & 0xFF for i in range(300))
            print("info  :", ask(b"\x10").hex(" "))
            r = ask(b"\x11" + p7(base), wait=1.5); print("erase :", r.hex(" ") if r else None)
            for off in range(0, 300, 100):
                chunk = pat[off:off + 100]; c = crc16(chunk)
                r = ask(b"\x12" + p7(base + off) + bytes([c & 0x7F, (c >> 7) & 0x7F, (c >> 14) & 3]) + pack7(chunk))
                print(f"write {off:3d}:", r.hex(" ") if r else None)
            back = b""
            for off in range(0, 300, 150):
                n = min(150, 300 - off)
                r = ask(b"\x13" + p7(base + off) + bytes([n & 0x7F, n >> 7]))
                back += unpack7(r[1:]) if r else b""
            print("relu  :", "IDENTIQUE" if back == pat else f"DIFFÉRENT ({len(back)} o) {back[:16].hex(' ')}")
            r = ask(b"\x14" + p7(base) + p7(300)); c = r[1] | r[2] << 7 | r[3] << 14
            print(f"crc pédale {c:#06x} / attendu {crc16(pat):#06x}")
            raise SystemExit(0)
        else: raise SystemExit("sous-commande inconnue")
        got = midi_exchange(hdr + body + b"\xF7", wait=1.0, port="BlackBox Custom")
        for raw in got:
            for part in raw.split(b"\xF7"):
                if hdr not in part: continue
                p = part[part.index(hdr) + 4:]
                cmd, data = p[0], p[1:]
                def u35(k): return sum(data[k + i] << (7 * i) for i in range(5))
                if cmd == 0x01: print("version :", data.decode("ascii", "replace"))
                elif cmd == 0x02: print(f"effets={data[0] | data[1] << 7:#x} bypass={data[2]} volume={data[3]}/127 charge={data[4]}% ledmode={data[5]}")
                elif cmd == 0x05: print("USB resets={} ctrl={} rx={} tx={} | blocs audio={} retards={} charge max={}%".format(*[u35(5 * k) for k in range(7)]))
                elif cmd == 0x16: print(f"flash : id={u35(0):#08x} (attendu 0xeb6014) capacité={u35(5):#x} durée={u35(10)} blocs (le compteur s'arrête pendant l'accès)")
                else: print(f"réponse cmd={cmd:#04x} données={data.hex(' ')}")
    elif c == "flashapp":   # flashapp <image 1 MiB> <sauvegarde de référence 1 MiB> --oui : écrit la zone application seulement
        if "--oui" not in sys.argv: raise SystemExit("écriture flash : ajouter --oui pour confirmer")
        flash_app(sys.argv[2], sys.argv[3], keep_storage="--tout" not in sys.argv)
    elif c == "restore":    # restore <sauvegarde 1 MiB> --oui : restaure [0x4000, 0x100000), SPL intact
        if "--oui" not in sys.argv: raise SystemExit("écriture flash : ajouter --oui pour confirmer")
        flash_app(sys.argv[2], sys.argv[2], keep_storage=False, full=True)
    elif c == "runram":
        runram(sys.argv[2], int(sys.argv[3], 0) if len(sys.argv) > 3 else 0x1C40000)
    else:
        print(__doc__)
