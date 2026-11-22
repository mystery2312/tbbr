"""sim_nam.py <A2.nam> : référence Python (float64) de l'inférence A2 Lite, transcrite de NeuralAmpModelerCore
NAM/wavenet/a2_fast.cpp (A2FastModel<3>::process). Sort les valeurs attendues pour le test sur la pédale (commande 0x19) :
préchauffage de 6 400 échantillons de silence, puis sinus 220 Hz d'amplitude 0,5 sur 512 échantillons ; on garde 1 valeur sur 16."""
import json, math, sys
KS = [6] * 14 + [15, 15] + [6] * 7
DL = [1, 3, 7, 17, 41, 101, 239, 1, 3, 7, 17, 41, 101, 239, 1, 13, 1, 3, 7, 17, 41, 101, 239]
j = json.load(open(sys.argv[1]))
w = sorted(j["config"]["submodels"], key=lambda s: s["max_value"])[0]["model"]["weights"]
it = iter(w)
rech = [next(it) for _ in range(3)]
layers = []
for li in range(23):
    K, D = KS[li], DL[li]
    cw = [0.0] * (K * 9)
    for i in range(3):
        for jj in range(3):
            for k in range(K): cw[k * 9 + jj * 3 + i] = next(it)
    b = [next(it) for _ in range(3)]; mix = [next(it) for _ in range(3)]
    l1 = [0.0] * 9
    for i in range(3):
        for jj in range(3): l1[jj * 3 + i] = next(it)
    l1b = [next(it) for _ in range(3)]
    layers.append(dict(K=K, D=D, cw=cw, b=b, mix=mix, l1=l1, l1b=l1b, hist=[[0.0] * 3 for _ in range((K - 1) * D + 1)], pos=0))
hw = [[0.0] * 3 for _ in range(16)]
for jj in range(3):
    for k in range(16): hw[k][jj] = next(it)
hb = next(it); hscale = next(it)
assert next(it, None) is None
hh = [[0.0] * 3 for _ in range(16)]; hpos = 0
def run1(x):
    global hpos
    lin = [r * x for r in rech]; s = [0.0, 0.0, 0.0]
    for L in layers:
        K, D, hist = L["K"], L["D"], L["hist"]; n = len(hist); p = L["pos"]
        hist[p] = list(lin)
        a = list(L["b"])
        for k in range(K):
            src = hist[(p - (K - 1 - k) * D) % n]; wk = L["cw"][k * 9:k * 9 + 9]
            for i in range(3): a[i] += wk[i] * src[0] + wk[3 + i] * src[1] + wk[6 + i] * src[2]
        a = [a[i] + L["mix"][i] * x for i in range(3)]
        a = [v if v >= 0 else v * 0.01 for v in a]
        s = [s[i] + a[i] for i in range(3)]
        lin = [lin[c] + L["l1b"][c] + sum(L["l1"][bb * 3 + c] * a[bb] for bb in range(3)) for c in range(3)]
        L["pos"] = (p + 1) % n
    hh[hpos] = s
    y = hb
    for k in range(16):
        col = hh[(hpos - (15 - k)) % 16]
        y += sum(hw[k][c] * col[c] for c in range(3))
    hpos = (hpos + 1) % 16
    return y * hscale
for _ in range(6400): run1(0.0)
out = [run1(0.5 * math.sin(2 * math.pi * 220 * n / 48000)) for n in range(512)]
print(json.dumps([round(v, 6) for v in out[::16]]))
