"""flash_app (bb_tool.py) contre une fausse pédale qui rate au hasard 5 % des commandes USB (Errno 31, rapport utilisateur :
Windows lisait le disque UBOOT en parallèle) : l'écriture doit aboutir, image vérifiée, SPL intact.
Utilise la sauvegarde locale (privée, non versionnée) : sauté si elle est absente."""
import sys, os, random
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))
import bb_tool

root = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", ".."))
refl = os.path.join(root, "blackbox", "backups", "reference.txt")
img = os.path.join(root, "blackbox", "fw_maison", "fw6", "fw_flash_1MiB.bin")
if not os.path.exists(refl) or not os.path.exists(img):
    print("SKIP : sauvegarde locale ou image fw_flash_1MiB.bin absente"); sys.exit(0)
ref = os.path.join(root, open(refl).readline().strip())
flash = bytearray(open(ref, "rb").read())            # la pédale contient la sauvegarde (firmware d'origine)
rnd = random.Random(int(sys.argv[1]) if len(sys.argv) > 1 else 1)
stats = {"fail": 0, "cmds": 0}
erased = []                                          # ordre des secteurs effacés

class FakeDev:
    aliases = []
    def device_number(self): return (7, 1)
    def close(self): pass
    def execute(self, cdb, data_out=None, data_in_len=0, timeout=10):
        stats["cmds"] += 1
        if rnd.random() < 0.05:
            stats["fail"] += 1
            raise OSError(31, "IOCTL_SCSI_PASS_THROUGH_DIRECT")
        cmd = int.from_bytes(cdb[:2], "big"); a = int.from_bytes(cdb[2:6], "big")
        if cmd == 0xFD05:
            n = int.from_bytes(cdb[6:8], "big"); return bytes(flash[a:a + n])
        if cmd == 0xFB01:
            assert a % 0x1000 == 0 and a >= 0x4000
            if a not in erased: erased.append(a)
            flash[a:a + 0x1000] = b"\xFF" * 0x1000; return cdb[:2] + bytes(14)
        if cmd == 0xFB04:
            for i, b in enumerate(data_out): flash[a + i] &= b
            return b""
        raise AssertionError(hex(cmd))

bb_tool.open_session = lambda: (FakeDev(), "WL82", "UBOOT1.00")
bb_tool.start_loader = lambda dev, pr: bb_tool.Loader(dev)
bb_tool.Loader.chip_key = lambda self: bb_tool.CHIP_KEY
bb_tool.time.sleep = lambda s: None
bb_tool.flash_app(img, ref)
want = open(img, "rb").read()
assert flash[:0x4000] == want[:0x4000], "SPL modifié !"
assert flash[0x4000:0x60000] == want[0x4000:0x60000], "zone application différente"
boot = [s for s in erased if s < 0x7000]
assert boot and erased[:len(boot)] == boot, "installation TBBR : le début (secours HOME) doit être écrit en premier"
n1 = stats["cmds"]

# restauration (TBBR -> firmware d'origine) : le début de l'app TBBR (secours HOME) doit être réécrit EN DERNIER
erased.clear()
_info = os.path.join(os.path.dirname(ref), "flashdump_info.json")      # identifiant de la pédale de la sauvegarde
_id = int(__import__("json").load(open(_info, encoding="utf-8"))["online_device"]["id"], 16) if os.path.exists(_info) else 0
bb_tool.Loader.online_device = lambda self: (3, _id)
bb_tool.flash_app(ref, ref, keep_storage=False, full=True)
orig = open(ref, "rb").read()
assert flash == bytearray(orig), "restauration différente de la sauvegarde"
boot = [s for s in erased if s < 0x7000]
assert boot and erased[-len(boot):] == boot, "restauration : le début de l'app doit être écrit en dernier"
print(f"OK : {stats['fail']} erreurs USB sur {stats['cmds']} commandes (installation puis restauration), images écrites et vérifiées, ordre d'écriture sûr")
