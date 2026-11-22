r"""nam2a2l1.py <A2.nam> [sortie.a2l1] : convertit un NAM A2 Lite en binaire A2L1 (poids int16, Q par étage).
Approche inspirée de l'A2L1 d'UltraRig (nam2chip.js), réimplémentée indépendamment :
  1. lit le sous-modèle Lite (3 canaux) et le réseau WaveNet ;
  2. passe une excitation de calibration en float et mesure le max |.| de chaque étage ;
  3. choisit les Q (étages), quantifie les poids en int16 et les biais en int64 ;
  4. packe l'en-tête 'A2L1' + les couches + CRC32 ;
  5. simule le moteur entier et compare à la référence float (preuve de précision).
Aucune dépendance. Usage : python -I nam2a2l1.py ..\..\tools_ext\nam_ref\A2.nam test.a2l1
"""
import json, math, struct, sys, zlib

KS = [6] * 14 + [15, 15] + [6] * 7
DL = [1, 3, 7, 17, 41, 101, 239, 1, 3, 7, 17, 41, 101, 239, 1, 13, 1, 3, 7, 17, 41, 101, 239]
NL, CH, HK = 23, 3, 16
AQ = 32                    # bits des activations (32 pour la précision ; 16 possible)
WQ = 16                    # bits des poids
MAGIC = b"A2L1"
VERSION = 1
LSHIFT = 24
MAX_SHIFT = 62

# ---------------------------------------------------------------- lecture du .nam
def load_lite(path):
    j = json.load(open(path, encoding="utf-8"))
    if j.get("architecture") == "SlimmableContainer":
        sub = sorted(j["config"]["submodels"], key=lambda s: s["max_value"])[0]["model"]
    else:
        sub = j
    cfg = sub["config"]
    L = cfg["layers"][0]
    assert sub["architecture"] == "WaveNet" and len(cfg["layers"]) == 1
    assert L["channels"] == CH and L.get("input_size", 1) == 1 and L.get("condition_size", 1) == 1
    assert not L.get("head1x1", {}).get("active") and L.get("layer1x1", {}).get("active")
    assert L.get("bottleneck", CH) == CH
    w = iter(sub["weights"])
    e = {"rech": [next(w) for _ in range(CH)], "layers": [], "hscale": cfg.get("head_scale", 1.0)}
    for li in range(NL):
        K, D = KS[li], DL[li]
        cw = [0.0] * (K * 9)
        for i in range(CH):
            for j in range(CH):
                for k in range(K):
                    cw[k * 9 + j * 3 + i] = next(w)
        b = [next(w) for _ in range(CH)]
        mix = [next(w) for _ in range(CH)]
        l1 = [0.0] * 9
        for i in range(CH):
            for j in range(CH):
                l1[j * 3 + i] = next(w)
        l1b = [next(w) for _ in range(CH)]
        e["layers"].append({"K": K, "D": D, "cw": cw, "b": b, "mix": mix, "l1": l1, "l1b": l1b})
    e["hw"] = [[0.0] * CH for _ in range(HK)]
    for j in range(CH):
        for k in range(HK):
            e["hw"][k][j] = next(w)
    e["hb"] = next(w)
    e["hscale"] = next(w)                                           # dernier poids du flux = head_scale
    if next(w, None) is not None:
        raise SystemExit("poids en trop")
    return e

# ---------------------------------------------------------------- moteur flottant + mesure
class Float:
    def __init__(self, e):
        self.e = e
        self.h = [[[0.0] * CH for _ in range((L["K"] - 1) * L["D"] + 1)] for L in e["layers"]]
        self.pos = [0] * NL
        self.hh = [[0.0] * CH for _ in range(HK)]
        self.hp = 0
        self.mx = {"rech": 0.0, "z": [0.0] * NL, "x3": [0.0] * NL, "head": 0.0, "out": 0.0}
    def run(self, x):
        e, mx = self.e, self.mx
        lin = [e["rech"][c] * x for c in range(CH)]
        mx["rech"] = max(mx["rech"], max(abs(v) for v in lin))
        s = [0.0, 0.0, 0.0]
        for li, L in enumerate(e["layers"]):
            K, D, hist = L["K"], L["D"], self.h[li]
            n = len(hist); p = self.pos[li]
            hist[p] = list(lin)
            a = list(L["b"])
            for k in range(K):
                src = hist[(p - (K - 1 - k) * D) % n]
                wk = L["cw"][k * 9:k * 9 + 9]
                for i in range(CH):
                    a[i] += wk[i] * src[0] + wk[3 + i] * src[1] + wk[6 + i] * src[2]
            a = [a[i] + L["mix"][i] * x for i in range(CH)]
            mx["z"][li] = max(mx["z"][li], max(abs(v) for v in a))
            a = [v if v >= 0 else v * 0.01 for v in a]
            for i in range(CH):
                s[i] += a[i]
            lin = [lin[c] + L["l1b"][c] + sum(L["l1"][b * 3 + c] * a[b] for b in range(CH)) for c in range(CH)]
            mx["x3"][li] = max(mx["x3"][li], max(abs(v) for v in lin))
            self.pos[li] = (p + 1) % n
        self.hh[self.hp] = list(s)
        mx["head"] = max(mx["head"], max(abs(v) for v in s))
        y = e["hb"]
        for k in range(HK):
            col = self.hh[(self.hp - (HK - 1 - k)) % HK]
            y += sum(e["hw"][k][c] * col[c] for c in range(CH))
        self.hp = (self.hp + 1) % HK
        y *= e["hscale"]
        mx["out"] = max(mx["out"], abs(y))
        return y

# ---------------------------------------------------------------- signal de calibration
def lcg(seed):
    s = seed & 0xFFFFFFFF
    def u():
        nonlocal s
        s = (1664525 * s + 1013904223) & 0xFFFFFFFF
        return s / 4294967296.0
    return u

def calibration():
    fs = 48000
    out = []
    # balayage log 20 Hz -> 20 kHz
    n = int(1.5 * fs); T = (n - 1) / fs; r = (fs / 2) / 20; lr = math.log(r)
    out += [math.sin(2 * math.pi * 20 * (r ** (i / fs) - 1) * T / lr) for i in range(n)]
    # bruit blanc
    u = lcg(12345)
    out += [(u() * 2 - 1) for _ in range(fs)]
    # cordes pincées (Karplus-Strong) + attaques
    for f in (82.41, 110.0, 146.83, 196.0, 246.94, 329.63):
        N = max(2, round(fs / f)); line = [u() * 2 - 1 for _ in range(N)]; p = 0
        for i in range(int(0.5 * fs)):
            v = line[p]; line[p] = 0.9985 * 0.5 * (v + line[(p + 1) % N]); p = (p + 1) % N
            out.append(v)
    return out

# ---------------------------------------------------------------- quantification
def fbits(maxabs, bits):
    if maxabs <= 0: return bits - 1
    ib = math.floor(math.log2(maxabs)) + 1
    return bits - 1 - ib

def qint(v, F, bits):
    s = 2.0 ** F
    lim = 2 ** (bits - 1)
    r = []
    for x in v:
        q = int(round(x * s))
        if q > lim - 1: q = lim - 1
        if q < -lim: q = -lim
        r.append(q)
    return r

def qweight(W, Fmax=None, bits=WQ):
    F = fbits(max(abs(x) for x in W), bits)
    if Fmax is not None and F > Fmax: F = Fmax
    return F, qint(W, F, bits)

def build(e, mx, abits=AQ):
    m = {"abits": abits, "wbits": WQ, "fs": 48000, "C": CH, "hk": HK, "name": "A2L1",
         "Fin": fbits(2.0, abits), "Fx3_0": fbits(mx["rech"] * 2, abits),
         "Fh": fbits(mx["head"] * 2, abits), "Fout": fbits(mx["out"] * 2, abits), "layers": []}
    m["rech_F"], m["rech_W"] = qweight(e["rech"], m["Fx3_0"] - m["Fin"] + 31)
    Fx3_prev = m["Fx3_0"]
    for li, L in enumerate(e["layers"]):
        Fz = fbits(mx["z"][li] * 2, abits); Fx3 = fbits(mx["x3"][li] * 2, abits)
        K = L["K"]
        cw2 = [0.0] * (9 * K)                                         # ordre du binaire : (sortie, entrée, prise)
        for k in range(K):
            for ci in range(CH):
                for co in range(CH):
                    cw2[(co * CH + ci) * K + k] = L["cw"][k * 9 + ci * CH + co]
        cF, cW = qweight(cw2, Fz - Fx3_prev + 31)
        mF, mW = qweight(L["mix"], Fz - m["Fin"] + 31)
        lF, lW = qweight(L["l1"], Fx3 - Fz + 31)
        m["layers"].append({"K": K, "dil": L["D"], "Fz": Fz, "Fx3": Fx3,
                            "lmul": int(round(0.01 * (1 << LSHIFT))),
                            "cF": cF, "cW": cW, "cB": qint(L["b"], cF + Fx3_prev, 64),
                            "mF": mF, "mW": mW, "lF": lF, "lW": lW, "lB": qint(L["l1b"], lF + Fz, 64)})
        Fx3_prev = Fx3
    m["Fh"] = min(m["Fh"], min(l["Fz"] for l in m["layers"]) - 1)
    hW2 = [e["hw"][k][c] * e["hscale"] for c in range(CH) for k in range(HK)]   # ordre : canal, prise
    hF, m["hW"] = qweight(hW2, m["Fout"] - m["Fh"] + 31)
    m["hF"] = hF; m["hB"] = qint([e["hb"] * e["hscale"]], hF + m["Fh"], 64)[0]
    return m

def pack(m):
    C, hk, nL = CH, HK, NL
    out = bytearray()
    def b(v): out.append(v & 0xFF)
    def B(v): out.append(v & 0xFF)
    def H(v): out.extend(struct.pack("<H", v & 0xFFFF))
    def h(a):
        for v in a: out.extend(struct.pack("<h", v))
    def q(a):
        for v in a: out.extend(struct.pack("<q", v))
    out += MAGIC; H(VERSION); B(m["wbits"]); B(m["abits"]); out += struct.pack("<I", m["fs"]); H(nL); B(C); B(hk)
    b(m["Fin"]); b(m["Fx3_0"]); b(m["Fh"]); b(m["Fout"])
    nm = m["name"].encode()[:16]; out += nm + b"\0" * (16 - len(nm))
    b(m["rech_F"]); h(m["rech_W"])
    for L in m["layers"]:
        B(L["K"]); H(L["dil"]); b(L["Fz"]); b(L["Fx3"]); out += struct.pack("<i", L["lmul"])
        b(L["cF"]); h(L["cW"]); q(L["cB"])
        b(L["mF"]); h(L["mW"])
        b(L["lF"]); h(L["lW"]); q(L["lB"])
    b(m["hF"]); h(m["hW"]); q([m["hB"]])
    out += struct.pack("<I", zlib.crc32(out) & 0xFFFFFFFF)
    return bytes(out)

# ---------------------------------------------------------------- moteur entier (simulation du firmware)
def shl(v, s): return v << s if s >= 0 else v >> -s
def shr(v, s): return v >> s if s >= 0 else v << -s

class IntEngine:
    def __init__(self, m):
        self.m = m
        self.h = [[[0] * CH for _ in range((L["dil"] * (L["K"] - 1)) + 1)] for L in m["layers"]]
        self.pos = [0] * NL; self.hh = [[0] * CH for _ in range(HK)]; self.hp = 0
    def run(self, xq):
        m = self.m; C = CH
        Fx3_0, Fin = m["Fx3_0"], m["Fin"]
        lin = [shr(w * xq, m["rech_F"] + Fin - Fx3_0) for w in m["rech_W"]]
        s = [0, 0, 0]
        Fx3_prev = Fx3_0
        for li, L in enumerate(m["layers"]):
            K, D, hist = L["K"], L["dil"], self.h[li]
            n = len(hist); p = self.pos[li]
            hist[p] = list(lin)
            a = [0, 0, 0]
            cw = L["cW"]
            for co in range(CH):
                acc = L["cB"][co]
                for k in range(K):
                    src = hist[(p - (K - 1 - k) * D) % n]
                    w0 = cw[(co * 3) * K + k]; w1 = cw[(co * 3 + 1) * K + k]; w2 = cw[(co * 3 + 2) * K + k]
                    acc += w0 * src[0] + w1 * src[1] + w2 * src[2]
                z = shr(acc, L["cF"] + Fx3_prev - L["Fz"])
                z += shr(L["mW"][co] * xq, L["mF"] + Fin - L["Fz"])
                a[co] = shr(z * L["lmul"], LSHIFT) if z < 0 else z
            for c in range(CH): s[c] += shr(a[c], L["Fz"] - m["Fh"])
            nx = []
            for co in range(CH):
                acc = L["lB"][co]
                acc += L["lW"][0 * 3 + co] * a[0] + L["lW"][1 * 3 + co] * a[1] + L["lW"][2 * 3 + co] * a[2]
                nx.append(shr(lin[co], Fx3_prev - L["Fx3"]) + shr(acc, L["lF"] + L["Fz"] - L["Fx3"]))
            lin = nx
            Fx3_prev = L["Fx3"]
            self.pos[li] = (p + 1) % n
        self.hh[self.hp] = list(s)
        acc = m["hB"]
        for k in range(HK):
            col = self.hh[(self.hp - (HK - 1 - k)) % HK]
            acc += m["hW"][k] * col[0] + m["hW"][HK + k] * col[1] + m["hW"][2 * HK + k] * col[2]
        self.hp = (self.hp + 1) % HK
        return shr(acc, m["hF"] + m["Fh"] - m["Fout"])

# ---------------------------------------------------------------- test
if __name__ == "__main__":
    path = sys.argv[1]
    e = load_lite(path)
    fl = Float(e)
    cal = calibration()
    for v in cal: fl.run(v)
    mx = fl.mx
    print("ranges: rech=%.3f z=%s x3=%s head=%.3f out=%.3f" % (mx["rech"], [round(v, 2) for v in mx["z"]], [round(v, 2) for v in mx["x3"]], mx["head"], mx["out"]))
    m = build(e, mx, AQ)
    blob = pack(m)
    print("A2L1: %d octets, Fin=%d Fx3_0=%d Fh=%d Fout=%d" % (len(blob), m["Fin"], m["Fx3_0"], m["Fh"], m["Fout"]))
    if len(sys.argv) > 2:
        open(sys.argv[2], "wb").write(blob)
    # référence float et moteur entier sur le même sinus que sim_nam.py
    fl2 = Float(e); ie = IntEngine(m)
    for _ in range(6400):
        fl2.run(0.0); ie.run(0)
    ref, got = [], []
    for n in range(512):
        x = 0.5 * math.sin(2 * math.pi * 220 * n / 48000)
        ref.append(fl2.run(x))
        xq = int(round(x * (1 << m["Fin"])))
        got.append(ie.run(xq) / (1 << m["Fout"]))
    err = max(abs(a - b) for a, b in zip(ref, got))
    print("écart max %.3e (crête %.3f)" % (err, max(abs(v) for v in ref)))
    print("pédale   :", [round(v, 4) for v in got[:8]])
    print("référence:", [round(v, 4) for v in ref[:8]])
