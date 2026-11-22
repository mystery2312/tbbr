"""sim_amx.py <fichier.am2Data|.am3Data> : simulation flottante du moteur M-VAVE AM2/AM3 (GRU 16 unités + 2 FIR 256).
Sert à vérifier le format, la stabilité et le niveau avant de porter le moteur dans le firmware.
Topologie (d'après blackboxctl) : fir_pre 256 -> GRU 3 portes/16 unités -> aux1/2/3 (64) -> fir_post 256.
Les FIR sont stockés « prise la plus récente en dernier » : y[n] = sum_k w[k] * x[n-(255-k)].
"""
import math, struct, sys

def parse(path):
    b = open(path, "rb").read()
    if len(b) not in (6204, 7868): raise SystemExit("taille inattendue %d" % len(b))
    magic = b[:4].decode("latin1").rstrip("\0")
    name = b[4:18].split(b"\0")[0].decode("latin1")
    mix, level, gmax, gmin = b[0x12], b[0x13], b[0x14], b[0x15]
    eq = struct.unpack("<9f", b[0x18:0x3C])
    n = (len(b) - 60) // 4
    w = struct.unpack("<%df" % n, b[60:])
    if magic in ("AM2", "AM3") and n == 1536:
        pre = w[0:256]; wi = [w[256:272], w[272:288], w[288:304]]
        wh = [w[304:560], w[560:816], w[816:1072]]
        vec = w[1072:1088]; post = w[1088:1344]
        aux = [w[1344:1408], w[1408:1472], w[1472:1536]]
    elif magic == "AM4" and n == 1952:
        pre = w[0:512]; wi = [w[512:528], w[528:544], w[544:560]]
        wh = [w[560:816], w[816:1072], w[1072:1328]]
        vec = w[1328:1344]; post = w[1440:1952]
        aux = [None, None, None]
        print("AM4 : topologie GRU partiellement inconnue (7 vecteurs supplémentaires), simulation approximative")
    else:
        raise SystemExit("format non reconnu : %s / %d floats" % (magic, n))
    return dict(magic=magic, name=name, mix=mix, level=level, gmax=gmax, gmin=gmin, eq=eq,
                pre=pre, wi=wi, wh=wh, vec=vec, post=post, aux=aux)

class Fir:
    def __init__(self, w, rev=True):
        self.w = w; self.n = len(w); self.hist = [0.0] * self.n; self.rev = rev
    def run(self, x):
        h = self.hist; h.pop(); h.insert(0, x)
        # h[0] = courant ; w[-1] = prise la plus récente
        if self.rev: return sum(self.w[k] * h[self.n - 1 - k] for k in range(self.n))
        return sum(self.w[k] * h[k] for k in range(self.n))

def sig(x): return 1.0 / (1.0 + math.exp(-max(-30.0, min(30.0, x))))
def grun(w, x, h):
    wi, wh, vec = w["wi"], w["wh"], w["vec"]
    # ordre PyTorch : reset, update, new
    a = [wi[0][i] * x + sum(wh[0][i * 16 + j] * h[j] for j in range(16)) for i in range(16)]
    b = [wi[1][i] * x + sum(wh[1][i * 16 + j] * h[j] for j in range(16)) for i in range(16)]
    c = [wi[2][i] * x for i in range(16)]
    r = [sig(v) for v in a]; z = [sig(v) for v in b]
    n = [math.tanh(c[i] + r[i] * sum(wh[2][i * 16 + j] * h[j] for j in range(16))) for i in range(16)]
    h2 = [(1 - z[i]) * n[i] + z[i] * h[i] for i in range(16)]
    y = sum(vec[i] * h2[i] for i in range(16))
    return y, h2

def run(path, secs=0.05, fs=44100.0, rev=True, use_aux=True):
    d = parse(path)
    print("%s %s : mix=%d level=%d gain=%d..%d" % (d["magic"], d["name"], d["mix"], d["level"], d["gmax"], d["gmin"]))
    pre, post = Fir(d["pre"], rev), Fir(d["post"], rev)
    aux = [Fir(a, rev) for a in d["aux"] if a]
    h = [0.0] * 16
    env_pre = env_gru = env_aux = env_out = 0.0
    peak_in = peak_out = 0.0; n = int(secs * fs)
    for t in range(n):
        x = 0.5 * math.sin(2 * math.pi * 220 * t / fs)
        peak_in = max(peak_in, abs(x))
        xp = pre.run(x)
        y, h = grun(d, xp, h)
        z = y
        if use_aux:
            for f in aux: z = f.run(z)
        yo = post.run(z)
        yo *= d["level"] / 100.0
        env_pre = max(env_pre, abs(xp)); env_gru = max(env_gru, abs(y)); env_aux = max(env_aux, abs(z))
        env_out = max(env_out, abs(yo)); peak_out = max(peak_out, abs(yo))
        if t % 4096 == 0 and t < 5 * 4096: print("  t=%6d  pre=%9.4f gru=%9.4f aux=%9.4f out=%9.4f" % (t, xp, y, z, yo))
    print("  max |pre|=%.4f |gru|=%.4f |aux|=%.4f |out|=%.4f (entrée 0.5)" % (env_pre, env_gru, env_aux, env_out))
    if not (env_out == env_out) or env_out > 1e6: print("  !! sortie instable")
    return d, env_out

if __name__ == "__main__":
    run(sys.argv[1], rev=(len(sys.argv) < 3 or sys.argv[2] != "norev"), use_aux=(len(sys.argv) < 4 or sys.argv[3] != "noaux"))
