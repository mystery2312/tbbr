/* tuner.c : accordeur (détection de hauteur par la méthode YIN, de Cheveigné & Kawahara 2002).
 *
 * L'entrée guitare (après le passe-haut d'entrée, avant les effets) est sous-échantillonnée par 2 (24 kHz) dans un
 * tampon de N = W + TMAX échantillons ; une fois plein, la fonction de différence d(t) = somme (x[j] - x[j+t])^2 est
 * calculée par tranches de LAGS_PER_BLOCK décalages à chaque bloc audio (jamais plus de ~0,4 ms de calcul d'un coup),
 * puis : différence normalisée par la moyenne cumulée, premier minimum sous le seuil, interpolation parabolique.
 * Plage : 30 Hz (TMAX = 800) à 1 000 Hz (TMIN = 24) : basse 5 cordes, guitare 7 cordes, accordages bas. */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
float log2f(float);

#define FS2 24000
#define W 1024
#define TMIN 24
#define TMAX 800
#define N (W + TMAX + 2)
#define LAGS_PER_BLOCK 64
#define THRESH 0.15f

static short buf[N] __attribute__((section(".gfxbss")));
static float d[TMAX + 2] __attribute__((section(".gfxbss")));   /* d(t), puis d'(t) normalisée sur place */
static u32 fill, lag, peak, acc_n;
static s32 acc;
static int busy;                         /* 1 : tampon plein, calcul en cours (la capture attend) */
static float a4 = 440.0f;

void ui_tuner_data(int note, int oct, float cents, int level);
void proto_tuner_data(int note, int oct, float cents, int level);

void tuner_reset(void) { fill = 0; lag = 1; busy = 0; peak = 0; acc = 0; acc_n = 0; }
void tuner_set_a4(float hz) { if (hz > 400 && hz < 480) a4 = hz; }

/* blk : n échantillons Q23 (entrée 16 bits << 8) */
void tuner_feed(const s32 *blk, u32 n)
{
    u32 i;
    if (busy) return;
    for (i = 0; i < n; i++) {
        acc += blk[i] >> 8;                                          /* 16 bits */
        if (++acc_n < 2) continue;
        {
            s32 v = acc >> 1;                                        /* moyenne de 2 = filtre + décimation */
            u32 a = (u32)(v < 0 ? -v : v);
            acc = 0; acc_n = 0;
            if (a > peak) peak = a;
            buf[fill++] = (short)(v >> 3);                           /* 13 bits : (x - y)^2 * 1024 tient dans 64 bits largement */
            if (fill >= N) { busy = 1; lag = 1; d[0] = 0; return; }
        }
    }
}

/* à appeler une fois par bloc audio : avance le calcul */
void tuner_step(void)
{
    u32 end, t, j;
    if (!busy) return;
    end = lag + LAGS_PER_BLOCK;
    if (end > TMAX + 1) end = TMAX + 1;
    for (t = lag; t < end; t++) {
        s64 s = 0;
        const short *x = buf, *y = buf + t;
        for (j = 0; j < W; j++) { s32 e = x[j] - y[j]; s += (s64)(e * e); }
        d[t] = (float)s;
    }
    lag = end;
    if (lag <= TMAX) return;
    /* différence normalisée (moyenne cumulée), premier creux sous le seuil */
    {
        float run = 0, best = 1e9f, dn[3] = { 1, 1, 1 };
        int tau = -1, level;
        float sum = 0, f;
        float *dnv = d;
        dnv[0] = 1;
        for (t = 1; t <= TMAX; t++) {
            float v = d[t];
            run += v;
            dnv[t] = run > 0 ? v * (float)t / run : 1;
        }
        for (t = TMIN; t < TMAX; t++) {
            if (dnv[t] < THRESH) {
                while (t + 1 < TMAX && dnv[t + 1] < dnv[t]) t++;
                tau = (int)t;
                break;
            }
            if (dnv[t] < best) best = dnv[t];
        }
        (void)sum; (void)dn;
        level = (int)(peak >> 7);                                     /* 0..255 environ */
        if (peak < 120 || tau < 0) { ui_tuner_data(0, 0, 0, 0); proto_tuner_data(0, 0, 0, 0); }
        else {
            /* interpolation parabolique autour du creux */
            float a = dnv[tau - 1], b = dnv[tau], c = dnv[tau + 1], den = a - 2 * b + c, tf = (float)tau, midi, cents;
            int note;
            if (den > 1e-9f || den < -1e-9f) tf += 0.5f * (a - c) / den;
            f = (float)FS2 / tf;
            midi = 69.0f + 12.0f * log2f(f / a4);
            note = (int)(midi + (midi >= 0 ? 0.5f : -0.5f));
            cents = (midi - (float)note) * 100.0f;
            if (level > 255) level = 255;
            if (level < 1) level = 1;
            ui_tuner_data(((note % 12) + 12) % 12, note / 12 - 1, cents, level);
            proto_tuner_data(((note % 12) + 12) % 12, note / 12 - 1, cents, level);
        }
    }
    fill = 0; peak = 0; busy = 0;                                    /* nouvelle capture */
}
