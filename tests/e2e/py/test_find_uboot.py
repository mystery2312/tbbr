r"""find_uboot (bb_tool.py) : une pédale vue par une lettre de lecteur ET par PhysicalDriveN ne compte qu'une fois
(rapport utilisateur : « il faut exactement un disque UBOOT, trouvé : [\\.\D:, \\.\PhysicalDrive1] »)."""
import sys
import os
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "..", "scripts"))
import bb_tool

def run(devs):
    """devs : chemin -> (numéro de disque ou None)"""
    class Fake:
        def __init__(self, p):
            if p not in devs: raise OSError(2, "absent")
            self.p = p
        def inquiry(self): return ("WL82", "UBOOT1.00", "1.00")
        def device_number(self): return devs[self.p]
        def close(self): pass
    bb_tool.SCSIDev = Fake
    return [f[0] for f in bb_tool.find_uboot(verbose=False)]

D, P1, P2 = "\\\\.\\D:", "\\\\.\\PhysicalDrive1", "\\\\.\\PhysicalDrive2"
assert run({D: (7, 1), P1: (7, 1)}) == [P1], "cas du rapport : lettre + disque = une pédale"
assert run({D: None, P1: (7, 1)}) == [P1], "numéro refusé sur la lettre"
assert run({P1: (7, 1)}) == [P1]
assert run({D: (7, 1)}) == [D], "lettre seule"
assert run({D: (7, 1), P1: (7, 1), P2: (7, 2)}) == [P1, P2], "deux pédales restent deux"
# quiet_aliases : seules les lettres du MÊME disque physique sont mises au repos (jamais C: ni un autre disque)
closed = []
class FakeVol:
    def __init__(self, p):
        nums = {"\\\\.\\C:": (7, 0), "\\\\.\\D:": (7, 1), "\\\\.\\E:": (7, 2)}
        if p not in nums: raise OSError(2, "absent")
        self.p, self.n, self.h = p, nums[p], None
    def device_number(self): return self.n
    def close(self): closed.append(self.p)
bb_tool.SCSIDev = FakeVol
class Dev:
    def device_number(self): return (7, 1)
kept = bb_tool.quiet_aliases(Dev(), P1)
assert [a.p for a in kept] == [D], "seule la lettre de la pédale est mise au repos"
assert sorted(closed) == ["\\\\.\\C:", "\\\\.\\E:"], "les autres disques sont refermés sans y toucher"
print("OK")
