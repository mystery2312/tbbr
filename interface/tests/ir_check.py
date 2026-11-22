import sys, random
sys.path.insert(0, r"blackbox\scripts")
import bb_tool
random.seed(1)
h = [int(20000 * (0.999 ** i) * random.uniform(-1, 1)) for i in range(2048)]   # IR envoyée par irfull.py
got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x1B, 0, 0xF7]), wait=2.0, port="BlackBox Custom")
for raw in got:
    for part in raw.split(b"\xF7"):
        k = part.find(b"\xF0\x7D\x42\x58\x1B")
        if k < 0: continue
        d = part[k + 5:]
        def u35(i): v = sum(d[i + j] << (7 * j) for j in range(5)) & 0xFFFFFFFF; return v - (1 << 32) if v & 0x80000000 else v
        out = [u35(5 * i) for i in range(32)]; ref = [h[64 * i] * 128 for i in range(32)]
        print("partitions :", u35(160))
        print("pédale   :", out[:6]); print("attendu  :", ref[:6])
        err = max(abs(a - b) for a, b in zip(out, ref)); pk = max(abs(v) for v in ref)
        import math; print(f"écart max {err} pour une crête {pk} ({20 * math.log10(err / pk + 1e-12):.1f} dB)")
        raise SystemExit
print("pas de réponse")
