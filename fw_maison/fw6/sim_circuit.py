"""sim_circuit.py : transcription de circuit.c (MNA polynomiale + bilinéaire) pour vérifier les tone stacks.
Affiche la réponse du filtre numérique (coefficients arrondis en float32 comme sur la pédale) et de l'analogique exact."""
import cmath, math, struct, sys
R0, WS, FS = 1e5, 1e4, 48000.0
f32 = lambda v: struct.unpack('f', struct.pack('f', v))[0]

def padd(a, b, s=1.0):
    n = max(len(a), len(b)); r = [0.0] * n
    for i, v in enumerate(a): r[i] += v
    for i, v in enumerate(b): r[i] += s * v
    return r
def pmul(a, b):
    r = [0.0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b): r[i + j] += x * y
    return r
def pdet(M, rows, cols):
    if len(rows) == 1: return M[rows[0]][cols[0]]
    acc = [0.0]
    for j, c in enumerate(cols):
        e = M[rows[0]][c]
        if not any(e): continue
        acc = padd(acc, pmul(e, pdet(M, rows[1:], cols[:j] + cols[j + 1:])), -1.0 if j & 1 else 1.0)
    return acc
def analog(elems, nn, out):
    nu = nn - 2
    Y = [[[0.0] for _ in range(nu)] for _ in range(nu)]; rhs = [[0.0] for _ in range(nu)]
    for t, a, b, v in elems:
        y = [R0 / max(v, 1.0)] if t == 'R' else [0.0, R0 * WS * v]
        ua, ub = a - 2, b - 2
        if a >= 2: Y[ua][ua] = padd(Y[ua][ua], y)
        if b >= 2: Y[ub][ub] = padd(Y[ub][ub], y)
        if a >= 2 and b >= 2: Y[ua][ub] = padd(Y[ua][ub], y, -1); Y[ub][ua] = padd(Y[ub][ua], y, -1)
        if a >= 2 and b == 1: rhs[ua] = padd(rhs[ua], y)
        if b >= 2 and a == 1: rhs[ub] = padd(rhs[ub], y)
    idx = list(range(nu)); o = out - 2
    den = pdet(Y, idx, idx)
    num = pdet([[rhs[i] if j == o else Y[i][j] for j in range(nu)] for i in range(nu)], idx, idx)
    return num, den
def bilinear(num, den):
    n = max(len(num), len(den)) - 1; K = 2 * FS / WS
    b = [0.0] * (n + 1); a = [0.0] * (n + 1)
    for k in range(n + 1):
        t = [1.0]
        for _ in range(k): t = pmul(t, [1.0, -1.0])
        for _ in range(n - k): t = pmul(t, [1.0, 1.0])
        for j in range(n + 1):
            b[j] += (num[k] if k < len(num) else 0) * K ** k * t[j]
            a[j] += (den[k] if k < len(den) else 0) * K ** k * t[j]
    return [f32(x / a[0]) for x in b], [f32(x / a[0]) for x in a]
def dresp(b, a, f):
    z = cmath.exp(-1j * 2 * math.pi * f / FS)
    return abs(sum(c * z ** k for k, c in enumerate(b)) / sum(c * z ** k for k, c in enumerate(a)))
def aresp(num, den, f):
    p = 1j * 2 * math.pi * f / WS
    return abs(sum(c * p ** k for k, c in enumerate(num)) / sum(c * p ** k for k, c in enumerate(den)))
def show(title, elems, nn, out, freqs=(50, 100, 200, 400, 700, 1000, 2000, 4000, 8000)):
    num, den = analog(elems, nn, out); b, a = bilinear(num, den)
    print(f"{title} (ordre {len(a) - 1})")
    print("  " + "  ".join(f"{f:>5}" for f in freqs))
    print("  " + "  ".join(f"{20 * math.log10(max(dresp(b, a, f), 1e-9)):5.1f}" for f in freqs) + "  dB numérique")
    print("  " + "  ".join(f"{20 * math.log10(max(aresp(num, den, f), 1e-9)):5.1f}" for f in freqs) + "  dB analogique")
def pot(R, x): return max(R * (1 - x), 1.0), max(R * x, 1.0)
def tmb(R1, R2, R3, R4, C1, C2, C3, t, m, l, rsrc=0.0, load=1e6):
    """tone stack TMB : 1 = entrée, 2 = haut aigus, 3 = sortie (curseur aigus), 4 = haut graves, 5 = X (après la pente), 6 = haut médiums"""
    ta, tb = pot(R1, t)
    return [('C', 1, 2, C1), ('R', 2, 3, ta), ('R', 3, 4, tb), ('R', 1, 5, R4 + rsrc), ('C', 5, 4, C2), ('C', 5, 6, C3),
            ('R', 4, 6, max(R2 * l, 1.0)), ('R', 6, 0, max(R3 * m, 1.0)), ('R', 3, 0, load)], 7, 3
if __name__ == "__main__":
    show("passe-bas 1 kOhm / 0,22 uF (TS9, fc 723 Hz)", [('R', 1, 2, 1000), ('C', 2, 0, 0.22e-6)], 3, 2)
    e, nn, o = tmb(250e3, 250e3, 10e3, 100e3, 250e-12, 0.1e-6, 0.047e-6, 0.5, 0.5, 0.5)
    show("Fender blackface (Twin) T=M=B=5", e, nn, o)
    e, nn, o = tmb(220e3, 1e6, 22e3, 33e3, 470e-12, 22e-9, 22e-9, 0.5, 0.5, 0.5)
    show("Marshall JCM800 T=M=B=5", e, nn, o)
    e, nn, o = tmb(220e3, 1e6, 22e3, 33e3, 470e-12, 22e-9, 22e-9, 0.5, 1.0, 0.5)
    show("Marshall JCM800 médiums à 10", e, nn, o)
