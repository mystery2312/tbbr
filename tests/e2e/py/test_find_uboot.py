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
print("OK")
