"""sim_ir.py : réplique bit à bit (entiers) de la convolution partitionnée de engine.c (design_ir / ir_block / run_ir),
comparée à une convolution directe exacte. Vérifie l'échelle, la symétrie et le retard de 128 échantillons."""
import math, random
N, B, P = 256, 128, 16
tw_c = [int(math.cos(2 * math.pi * k / N) * 1073741824.0) for k in range(N // 2)]
tw_s = [int(-math.sin(2 * math.pi * k / N) * 1073741824.0) for k in range(N // 2)]
def sh(v, n): return v >> n                                          # décalage arithmétique comme le C (s64 >> n)
def fft(re, im, inv, scale, N=N):
    j = 0
    for i in range(1, N):
        bit = N >> 1
        while j & bit: j ^= bit; bit >>= 1
        j ^= bit
        if i < j: re[i], re[j] = re[j], re[i]; im[i], im[j] = im[j], im[i]
    s = 1 if scale else 0
    for i in range(0, N, 4):                                          # étages 1 + 2 fusionnés (comme fft_core)
        r, m = re[i:i + 4], im[i:i + 4]
        a0r, a0i, a1r, a1i = r[0] + r[1], m[0] + m[1], r[0] - r[1], m[0] - m[1]
        b0r, b0i, b1r, b1i = r[2] + r[3], m[2] + m[3], r[2] - r[3], m[2] - m[3]
        tr, ti = (-b1i, b1r) if inv else (b1i, -b1r)
        if scale: a0r, a0i, a1r, a1i, b0r, b0i, tr, ti = (v >> 1 for v in (a0r, a0i, a1r, a1i, b0r, b0i, tr, ti))
        re[i], im[i], re[i + 2], im[i + 2] = (a0r + b0r) >> s, (a0i + b0i) >> s, (a0r - b0r) >> s, (a0i - b0i) >> s
        re[i + 1], im[i + 1], re[i + 3], im[i + 3] = (a1r + tr) >> s, (a1i + ti) >> s, (a1r - tr) >> s, (a1i - ti) >> s
    ln = 8
    while ln <= N:
        half, step = ln >> 1, 256 // ln
        for k in range(half):
            wr, wi = tw_c[k * step], (-tw_s[k * step] if inv else tw_s[k * step])
            for i in range(0, N, ln):
                a, b = i + k, i + k + half
                xr = to_s32(sh(re[b] * wr - im[b] * wi, 30)); xi = to_s32(sh(re[b] * wi + im[b] * wr, 30))
                ur, ui = re[a], im[a]
                re[a], im[a], re[b], im[b] = (ur + xr) >> s, (ui + xi) >> s, (ur - xr) >> s, (ui - xi) >> s
        ln <<= 1
def to_s32(v): v &= 0xFFFFFFFF; return v - (1 << 32) if v & 0x80000000 else v
random.seed(1)
h = [int(30000 * math.exp(-i / 60) * (random.random() * 2 - 1)) for i in range(2048)]   # IR de test (Q15)
H = []
for q in range(P):
    re = [h[q * B + k] if k < B else 0 for k in range(N)]; im = [0] * N
    fft(re, im, 0, 0)
    H.append([(re[k], im[k]) for k in range(N // 2 + 1)])
F = [[(0, 0)] * (N // 2 + 1) for _ in range(P)]
head, xin, outq, pos = 0, [0] * N, [0] * B, 0
x = [int((1 << 22) * math.sin(2 * math.pi * 220 * n / 48000) + (1 << 20) * (random.random() * 2 - 1)) for n in range(48000 // 4)]
y = []
for s in x:
    xin[B + pos] = s; y.append(outq[pos]); pos += 1
    if pos >= B:
        pos = 0
        H2 = N // 2
        re = [xin[2 * k] for k in range(H2)]; im = [xin[2 * k + 1] for k in range(H2)]
        fft(re, im, 0, 1, H2)
        head = (head + P - 1) % P
        X = []
        for k in range(H2 + 1):
            a, b = k & (H2 - 1), (H2 - k) & (H2 - 1)
            zr, zi, cr, ci = re[a], im[a], re[b], -im[b]
            ar_, ai_, dr, di = zr + cr, zi + ci, zr - cr, zi - ci
            wr, wi = (tw_c[k], tw_s[k]) if k < H2 else (-1073741824, 0)
            tr = to_s32(sh(di * wr + dr * wi, 30)); ti = to_s32(sh(di * wi - dr * wr, 30))
            X.append(((ar_ + tr) >> 2, (ai_ + ti) >> 2))
        F[head] = X
        gr, gi = [0] * (H2 + 1), [0] * (H2 + 1)
        for k in range(H2 + 1):
            ar = ai = 0
            for q in range(P):
                xr, xi = F[(head + q) % P][k]; hr, hi = H[q][k]
                ar += xr * hr - xi * hi; ai += xr * hi + xi * hr
            gr[k], gi[k] = to_s32(ar >> 15), to_s32(ai >> 15)
        re, im = [0] * H2, [0] * H2
        for k in range(H2):
            yr, yi, cr, ci = gr[k], gi[k], gr[H2 - k], -gi[H2 - k]
            dr, di, wr, wi = yr - cr, yi - ci, tw_c[k], -tw_s[k]
            er = to_s32(sh(dr * wr - di * wi, 30)); ei = to_s32(sh(dr * wi + di * wr, 30))
            re[k], im[k] = yr + cr - ei, yi + ci + er
        fft(re, im, 1, 0, H2)
        outq = [0] * B
        for k in range(B // 2): outq[2 * k], outq[2 * k + 1] = re[B // 2 + k], im[B // 2 + k]
        xin[:B] = xin[B:]
# référence : y_ref[n] = sum h[k] x[n-k] / 32768, retardée de 128
ref = []
for n in range(len(x)):
    acc = 0
    for k in range(0, min(2048, n + 1)): acc += h[k] * x[n - k]
    ref.append(acc / 32768.0)
err, peak = 0.0, 0.0
for n in range(4096, len(x)):
    a, b = y[n], ref[n - B]
    err = max(err, abs(a - b)); peak = max(peak, abs(b))
print(f"crête référence {peak:.0f} (Q23 : {peak / (1 << 23):.2f}) ; erreur max {err:.0f} = {20 * math.log10(err / peak + 1e-12):.1f} dB sous la crête")
