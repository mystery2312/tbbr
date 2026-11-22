"""sim_tuner.py : transcription de tuner.c (mêmes entiers, même YIN) sur des notes synthétiques riches en harmoniques."""
import math, random
FS, FS2, W, TMIN, TMAX = 48000, 24000, 1024, 24, 800
N = W + TMAX + 2
def tune(freq, amp=3000.0):
    ph = random.random()
    x = [int(sum(amp / k * math.sin(2 * math.pi * freq * k * n / FS + ph * k) for k in range(1, 7))
             * math.exp(-n / 40000) + random.gauss(0, 20)) for n in range(2 * N)]
    buf = [((x[2 * i] + x[2 * i + 1]) >> 1) >> 3 for i in range(N)]
    peak = max(abs((x[2 * i] + x[2 * i + 1]) >> 1) for i in range(N))
    d = [0.0] * (TMAX + 2)
    for t in range(1, TMAX + 1):
        d[t] = float(sum((buf[j] - buf[j + t]) ** 2 for j in range(W)))
    run, dn = 0.0, [1.0] * (TMAX + 2)
    for t in range(1, TMAX + 1):
        run += d[t]; dn[t] = d[t] * t / run if run > 0 else 1
    tau = -1; t = TMIN
    while t < TMAX:
        if dn[t] < 0.15:
            while t + 1 < TMAX and dn[t + 1] < dn[t]: t += 1
            tau = t; break
        t += 1
    if peak < 120 or tau < 0: return None
    a, b, c = dn[tau - 1], dn[tau], dn[tau + 1]; den = a - 2 * b + c; tf = tau + (0.5 * (a - c) / den if abs(den) > 1e-9 else 0)
    f = FS2 / tf; midi = 69 + 12 * math.log2(f / 440); note = round(midi)
    return "C C# D D# E F F# G G# A A# B".split()[note % 12] + str(note // 12 - 1), (midi - note) * 100
for name, f in [("E1 basse", 41.2), ("B1 7c", 61.74), ("E2", 82.41), ("A2", 110.0), ("D3", 146.83), ("G3", 196.0), ("B3", 246.94), ("E4", 329.63), ("E4 +12c", 329.63 * 2 ** (12 / 1200)), ("A4 -7c", 440 * 2 ** (-7 / 1200))]:
    r = tune(f)
    print(f"{name:10s} {f:8.2f} Hz -> {r[0]:4s} {r[1]:+6.1f} c" if r else f"{name:10s} -> rien")
