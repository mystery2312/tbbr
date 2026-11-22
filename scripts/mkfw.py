"""mkfw.py : fabrique la zone application (flash 0x4000..) d'une BlackBox à partir de la sauvegarde V19 et d'un app.bin.

    mkfw.py <sauvegarde flash_full_1MiB.bin> <app.bin> <sortie.bin>     -> image 1 MiB = sauvegarde avec la zone app remplacée
    mkfw.py --selftest <sauvegarde>                                       -> reconstruit la V19 d'origine : doit être identique

Règles du format de flash JieLi (JLFS), vérifiées sur le firmware V19 (reconstruction identique au bit près, --selftest) :
  - zone app chiffrée SFC : bloc de 32 o à l'offset p (relatif à 0x4000) xor flux CRC16 de clé 0x980F ^ (p >> 2)
  - répertoire JLFS : entrées de 32 o <H hcrc, H dcrc, I off, I size, B attr, B res, H idx, 16s nom>, hcrc = crc16(entrée[2:])
  - app_area_head : off = 0x2000120, size = fin du dernier fichier, dcrc = crc16(zone[0x20 : size])
  - fichiers attr 0x82 (app.bin à 0x120, cfg_tool.bin juste après) : dcrc = crc16(données)
  - VM / PRCT / BTIF / USR (attr 0x12/0x92) recopiés tels quels.
"""
import sys, struct, binascii, hashlib

APP_BASE, FLASH_SIZE, KEY = 0x4000, 0x100000, 0x980F
def crc16(b): return binascii.crc_hqx(bytes(b), 0)

def sfc(buf, key=KEY, p0=0):
    """Chiffrement SFC (involutif) ; p0 = position du début de buf relative à 0x4000 (multiple de 32)."""
    out = bytearray(buf)
    for p in range(0, len(out), 32):
        k = (key ^ ((p0 + p) >> 2)) & 0xFFFF
        for i in range(p, min(p + 32, len(out))):
            out[i] ^= k & 0xFF
            k = ((k << 1) ^ (0x1021 if k & 0x8000 else 0)) & 0xFFFF
    return bytes(out)

def parse_dir(area):
    ents = []
    for i in range(32):
        e = area[32 * i:32 * i + 32]
        hc, dc, off, size, attr, res, idx = struct.unpack_from("<HHIIBBH", e)
        if crc16(e[2:]) != hc: break
        ents.append(dict(dcrc=dc, off=off, size=size, attr=attr, res=res, idx=idx, name=e[16:].split(b"\0")[0].decode(),
                         rawname=bytes(e[16:32])))        # champ nom d'origine (bourrage FF / octets divers conservés)
        if idx != 0: break
    return ents

def pack_entry(e):
    body = struct.pack("<IIBBH", e["off"], e["size"], e["attr"], e["res"], e["idx"]) + e["rawname"]
    body = struct.pack("<H", e["dcrc"]) + body
    return struct.pack("<H", crc16(body)) + body

def check_area(area, vm_off):
    """Contrôles que fait le SPL au démarrage (format JLFS) ; lève ValueError sinon. area = zone en clair depuis 0x4000."""
    ents = parse_dir(area)
    if not ents or ents[0]["name"] != "app_area_head": raise ValueError("app_area_head absent")
    h = ents[0]
    if not (32 < h["size"] <= vm_off): raise ValueError(f"taille app_area_head hors bornes : {h['size']:#x}")
    if crc16(area[0x20:h["size"]]) != h["dcrc"]: raise ValueError("CRC d'app_area_head faux")
    for e in ents[1:]:
        if e["attr"] == 0x82:
            if e["off"] + e["size"] > vm_off: raise ValueError(f"{e['name']} dépasse la zone")
            if crc16(area[e["off"]:e["off"] + e["size"]]) != e["dcrc"]: raise ValueError(f"CRC de {e['name']} faux")
    return ents

def build(backup, app):
    """Renvoie l'image 1 MiB : sauvegarde + nouvelle zone app (même répertoire, app.bin remplacé, cfg_tool.bin recopié)."""
    old = sfc(backup[APP_BASE:])
    ents = parse_dir(old)
    names = [e["name"] for e in ents]
    if names[:3] != ["app_area_head", "app.bin", "cfg_tool.bin"]: raise ValueError(f"répertoire inattendu : {names}")
    vm = next(e for e in ents if e["name"] == "VM")
    cfg_e = ents[2]
    cfg = old[cfg_e["off"]:cfg_e["off"] + cfg_e["size"]]
    n = len(ents)
    area = bytearray(old[:vm["off"]])             # on part de l'ancienne zone (les octets au-delà de 'size' restent ce qu'ils étaient)
    app_off = 0x120
    cfg_off = app_off + len(app)
    end = cfg_off + len(cfg)
    if end > vm["off"]: raise ValueError("app trop grande")
    area[app_off:app_off + len(app)] = app
    area[cfg_off:end] = cfg
    ents[1].update(off=app_off, size=len(app), dcrc=crc16(app))
    ents[2].update(off=cfg_off, size=len(cfg), dcrc=crc16(cfg))
    for i in range(1, n): area[32 * i:32 * i + 32] = pack_entry(ents[i])
    ents[0].update(size=end)
    ents[0]["dcrc"] = crc16(area[0x20:end])        # entrées 1..n et données (l'entrée 0 n'est pas couverte)
    area[0:32] = pack_entry(ents[0])
    check_area(bytes(area), vm["off"])
    img = bytearray(backup)
    img[APP_BASE:APP_BASE + len(area)] = sfc(bytes(area))
    return bytes(img), end

CAB_LO, CAB_HI = 0xF3000, 0xFF000                 # cabs d'usine (gen_cabs.py) : 11 IR + répertoire « TBC1 »
def place_cabs(img, cabs):
    """Pose cabs.bin (en clair, 48 Ko) dans l'image à 0xF3000, chiffré comme le stockage du firmware (lecture XIP)."""
    if len(cabs) != CAB_HI - CAB_LO or cabs[-0x1000:-0x1000 + 4] != b"TBC1": raise ValueError("cabs.bin invalide")
    img = bytearray(img)
    img[CAB_LO:CAB_HI] = sfc(cabs, p0=CAB_LO - APP_BASE)
    return bytes(img)

def has_cabs(img):
    return sfc(img[CAB_HI - 0x1000:CAB_HI - 0x1000 + 32], p0=CAB_HI - 0x1000 - APP_BASE)[:4] == b"TBC1"

def changed_sectors(a, b, lo=APP_BASE, hi=None):
    hi = hi or len(a)
    return [s for s in range(lo, hi, 0x1000) if a[s:s + 0x1000] != b[s:s + 0x1000]]

if __name__ == "__main__":
    if sys.argv[1] == "--selftest":
        bk = open(sys.argv[2], "rb").read()
        old = sfc(bk[APP_BASE:])
        e = parse_dir(old)
        app = old[e[1]["off"]:e[1]["off"] + e[1]["size"]]
        img, end = build(bk, app)
        print(f"reconstruction V19 : {'IDENTIQUE' if img == bk else 'DIFFÉRENTE'} ; secteurs différents : {[hex(s) for s in changed_sectors(img, bk)]}")
        sys.exit(0 if img == bk else 1)
    bk = open(sys.argv[1], "rb").read()
    app = open(sys.argv[2], "rb").read()
    app += b"\0" * (-len(app) % 32)              # cfg_tool.bin aligné comme dans les images officielles
    img, end = build(bk, app)
    if len(sys.argv) > 4:                         # mkfw.py <sauvegarde> <app.bin> <sortie> [cabs.bin]
        img = place_cabs(img, open(sys.argv[4], "rb").read())
        print("cabs d'usine posés à 0xF3000")
    open(sys.argv[3], "wb").write(img)
    secs = changed_sectors(img, bk)
    print(f"image écrite : {sys.argv[3]} (sha256 {hashlib.sha256(img).hexdigest()[:16]})")
    print(f"app {len(app)} o, zone utile [0x4000, {APP_BASE + end:#x}) ; secteurs de 4 Ko à écrire : {len(secs)} -> {[hex(s) for s in secs]}")
    print("répertoire :")
    for e in check_area(sfc(img[APP_BASE:]), next(x for x in parse_dir(sfc(img[APP_BASE:])) if x["name"] == "VM")["off"]):
        print(f"   {e['name']:14s} off={e['off']:#09x} size={e['size']:#08x} attr={e['attr']:#04x} dcrc={e['dcrc']:04x}")
