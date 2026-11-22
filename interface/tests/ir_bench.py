"""ir_bench.py : chronomètre les morceaux de la convolution des cabs sur la pédale (commande 0x1A, modèles 120..123).
Chaque mesure = 150 blocs de 128 échantillons (0,4 s d'audio) ; % d'un cœur = ms / 400."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
NAMES = {120: "ir_block complet (FFT + produits + IFFT)", 121: "2 FFT de 128 seules", 122: "run_ir x 128 (traitement par échantillon + 1 ir_block)", 123: "permutation bit-inverse seule"}
for m in (120, 121, 122, 123):
    got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1A, m, 0xF7]), wait=3.0, port="BlackBox Custom")
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x1A")
            if k >= 0:
                d = part[k + 5:]
                ms = sum(d[j] << (7 * j) for j in range(5)) & 0xFFFFFFFF
                print(f"{NAMES[m]:55s} {ms:5d} ms / 400 = {ms / 4:5.1f} % d'un cœur" if ms < 0xFFFFFFF0 else f"{NAMES[m]} : erreur {ms:#x}")
                break
