"""gen_cabs.py : fabrique cabs.bin = zone flash des cabs d'usine [0xF3000, 0xFF000) (en clair, 12 secteurs de 4 Ko).

Secteurs 0..10 : une IR chacun (int16 LE, CAB_LEN points puis zéros). Secteur 11 (0xFE000) : répertoire
  u32 'TBC1', u32 nombre, puis par IR : char nom[24], u16 points, u16 réservé, u32 réservé  (32 o).
Ordre = index utilisé par le firmware (engine.c cab_index) et par l'app (options des blocs 4x12 V30 / Combo).
Sources et licences : third_party/irs/README.md. Usage : python gen_cabs.py [sortie]
"""
import os, struct, sys, wave, math

HERE = os.path.dirname(os.path.abspath(__file__))
IRS = os.path.join(HERE, "..", "..", "third_party", "irs")
CAB_LEN = 1024                        # 21,3 ms à 48 kHz : 8 partitions de 128 dans la convolution du firmware
FADE = 128
CABS = [                              # (nom affiché, fichier)
    ("V30 SM57 A",     "jester-brutal/v30-sm57-a.wav"),
    ("V30 SM57 B",     "jester-brutal/v30-sm57-b.wav"),
    ("V30 Dyn 75",     "jester-brutal/v30-pdmic75.wav"),
    ("V30 + G12F",     "jester-brutal/g12f-v30-e606-sm57.wav"),
    ("4x12 fermé",     "darwinscat-orbit/4x12-closed.wav"),
    ("2x12 ouvert",    "darwinscat-orbit/2x12-open.wav"),
    ("2x12 fermé",     "darwinscat-orbit/2x12-closed.wav"),
    ("2x12 mi-ouvert", "darwinscat-orbit/2x12-half.wav"),
    ("1x12 ouvert",    "darwinscat-orbit/1x12-open.wav"),
    ("1x12 fermé",     "darwinscat-orbit/1x12-closed.wav"),
    ("4x10 ouvert",    "darwinscat-orbit/4x10-open.wav"),
]
SECT, NSECT = 0x1000, 12


def read_wav(path):
    w = wave.open(path)
    ch, sw, rate, n = w.getnchannels(), w.getsampwidth(), w.getframerate(), w.getnframes()
    raw = w.readframes(n)
    if rate != 48000:
        raise SystemExit(f"{path} : {rate} Hz (48 kHz attendu)")
    out = []
    step = sw * ch
    for i in range(0, len(raw) - step + 1, step):                    # canal 0
        b = raw[i:i + sw]
        if sw == 2: v = struct.unpack("<h", b)[0] / 32768
        elif sw == 3: v = int.from_bytes(b, "little", signed=True) / 8388608
        elif sw == 4: v = struct.unpack("<i", b)[0] / 2147483648
        else: raise SystemExit(f"{path} : {sw * 8} bits non géré")
        out.append(v)
    return out


def prepare(x):
    pk = max(abs(v) for v in x)
    start = next(i for i, v in enumerate(x) if abs(v) > 0.05 * pk)    # silence de départ retiré (garde 4 points)
    x = x[max(0, start - 4):][:CAB_LEN]
    x += [0.0] * (CAB_LEN - len(x))
    for i in range(FADE):
        x[CAB_LEN - 1 - i] *= 0.5 - 0.5 * math.cos(math.pi * i / FADE)
    return x


def main():
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(HERE, "cabs.bin")
    irs = [prepare(read_wav(os.path.join(IRS, f))) for _, f in CABS]
    # même énergie pour toutes (norme L2), crêtes <= 0,97
    l2 = [math.sqrt(sum(v * v for v in x)) for x in irs]
    pk = [max(abs(v) for v in x) for x in irs]
    ref = min(0.97 * l2[i] / pk[i] for i in range(len(irs)))
    img = bytearray(b"\xFF" * SECT * NSECT)
    for i, x in enumerate(irs):
        g = ref / l2[i]
        pcm = b"".join(struct.pack("<h", max(-32768, min(32767, round(v * g * 32767)))) for v in x)
        img[i * SECT:i * SECT + len(pcm)] = pcm
        img[i * SECT + len(pcm):(i + 1) * SECT] = b"\0" * (SECT - len(pcm))
    d = bytearray(struct.pack("<II", 0x31434254, len(CABS)))           # "TBC1"
    for name, _ in CABS:
        nb = name.encode("utf-8")[:23]
        d += nb + b"\0" * (24 - len(nb)) + struct.pack("<HHI", CAB_LEN, 0, 0)
    img[(NSECT - 1) * SECT:(NSECT - 1) * SECT + len(d)] = d
    open(out, "wb").write(img)
    print(f"cabs.bin : {len(CABS)} IR de {CAB_LEN} points, L2 commune {ref:.3f} -> {out}")
    for (name, f), a, p in zip(CABS, l2, pk):
        print(f"  {name:16s} gain {20 * math.log10(ref / a):+6.1f} dB  ({f})")


if __name__ == "__main__":
    main()
