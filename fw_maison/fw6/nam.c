/* nam.c : moteur NAM « A2 Lite » (WaveNet 3 canaux, 23 couches), d'après NeuralAmpModelerCore (MIT),
 * NAM/wavenet/a2_fast.cpp (même ordre des poids, mêmes opérations).
 *
 * Par échantillon : lin = rechannel * x ; pour chaque couche : historique <- lin ; z = biais + sum_k W_k . hist[t - (K-1-k) D]
 *                   + mixin * x ; a = LeakyReLU(z, 0.01) ; head_sum += a ; lin += b1 + L1 . a
 *                   puis tête : y = (head_b + sum_k Hw_k . head_hist[t - (15-k)]) * head_scale.
 *
 * Calcul en virgule fixe : activations Q23 sur 32 bits, poids sur 32 bits avec un décalage choisi par tenseur au chargement,
 * sommes dans des accumulateurs 64 bits (instruction « r1_r0 += a * b » de l'AC791N, 1 instruction par produit ; le FPU
 * n'a pas de multiplication-addition fusionnée). Seuls le chargement et les gains utilisent le flottant (fprev1). */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
#define NL 23
#define CH 3
#define HK 16
#define AQ 23                                                      /* activations : Q23 (plage +-256) */
static const unsigned char KS[NL] = { 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 15, 15, 6, 6, 6, 6, 6, 6, 6 };
static const unsigned short DL[NL] = { 1, 3, 7, 17, 41, 101, 239, 1, 3, 7, 17, 41, 101, 239, 1, 13, 1, 3, 7, 17, 41, 101, 239 };

#define NB 128                                                     /* taille de bloc maximale */
typedef short s16;
/* couche : la première partie est lue par nam_asm.S (décalages fixes, vérifiés ci-dessous) */
struct nlayer {
    s64 b[CH];                                                     /*  0 : biais << (AQ + sw) */
    s32 *s, *x, *lin, *hs;                                         /* 24 : fenêtre trame 0, entrée, résiduel, somme tête */
    s16 *w;                                                        /* 40 : -> wq */
    s32 stride, sw, s1;                                            /* 44 : D*12 octets ; décalages convolution (+ mixin), 1x1 */
    s32 l1b[CH];                                                   /* 56 : Q23 */
    s32 n;                                                         /* 68 : trames du bloc */
    /* --- partie C --- */
    int K, D;
    s32 *hist;                                                     /* (K-1) D trames passées + 1 bloc, linéaire */
    s16 wq[15 * 9 + CH + 9 + 1];                                   /* prises [k][j][i], mix[i], L1[i][j] (int16) */
};
_Static_assert(__builtin_offsetof(struct nlayer, s) == 24 && __builtin_offsetof(struct nlayer, w) == 40 &&
               __builtin_offsetof(struct nlayer, stride) == 44 && __builtin_offsetof(struct nlayer, l1b) == 56 &&
               __builtin_offsetof(struct nlayer, n) == 68, "struct nlayer != nam_asm.S");
void nam_layer6(struct nlayer *p);
void nam_layer15(struct nlayer *p);
void nam_layer6_last(struct nlayer *p);
void nam_copy(s32 *d, const s32 *s, int n);                        /* copie vers l'avant, boucle matérielle */
struct hd { const s16 *w; const s32 *c; s32 *dst; int n; s32 hb_lo, hb_hi; int sh; };   /* lu par nam_head_asm */
void nam_head_asm(struct hd *p);
/* échange entre les deux moitiés du réseau (cœur 1 -> cœur 0), une par phase de bloc */
struct xfer { s32 x[NB], lin[NB * CH], hs[NB * CH]; int n; };
struct nam {
    struct nlayer L[NL];
    s32 rech[CH]; int sr;
    s16 hw[HK * CH]; s64 hb; int sh;                               /* hw[k*3 + j] (int16, nam_head_asm) */
    float hscale, in_gain, out_gain;
    int split;                                                     /* couches [0, split) = avant (cœur 1), le reste = arrière */
    struct xfer xf[2];
    s32 hcat[(HK - 1 + NB) * CH];
};
#define NAM_SPLIT_DEF 18
/* mémoire : l'état (nam_mem_size) et un historique par couche (nam_hist_bytes), alloués séparément par l'appelant
   pour pouvoir remplir les deux zones de la réserve (~18 Ko + 23 morceaux de 1,6 à 15 Ko, 111 Ko au total) */
u32 nam_mem_size(void) { return sizeof(struct nam) + 64; }
u32 nam_hist_bytes(int li) { return li >= 0 && li < NL ? (u32)((KS[li] - 1) * DL[li] + NB) * CH * 4 : 0; }
static float fabs_(float v) { return v < 0 ? -v : v; }
/* décalage s tel que max|w| * 2^s < 2^30 */
static int qshift(const float *w, int n)
{
    float mx = 1e-9f, lim = 1073741824.0f;
    int i, s = 30;
    for (i = 0; i < n; i++) if (fabs_(w[i]) > mx) mx = fabs_(w[i]);
    while (s > 2 && mx * (float)(1u << s) >= lim) s--;
    return s;
}
static s32 qv(float v, int s) { float r = v * (float)(1u << s); return (s32)(r < 0 ? r - 0.5f : r + 0.5f); }
/* décalage s tel que max|w| * 2^s <= 32767 (poids int16 du noyau assembleur) */
static int qshift16(const float *w, int n)
{
    float mx = 1e-9f;
    int i, s = 30;
    for (i = 0; i < n; i++) if (fabs_(w[i]) > mx) mx = fabs_(w[i]);
    while (s > 0 && mx * (float)(1u << s) > 32767.0f) s--;
    return s;
}
static s32 q23(float v) { float r = v * 8388608.0f; if (r > 2147483000.0f) r = 2147483000.0f; else if (r < -2147483000.0f) r = -2147483000.0f; return (s32)(r < 0 ? r - 0.5f : r + 0.5f); }
/* charge les 1 871 poids (float32, ordre du flux NAM) ; mem = nam_mem_size() octets, hist[li] = nam_hist_bytes(li) octets ;
   renvoie 0 si OK */
int nam_load(void *mem, const float *w, int nw, s32 *const *hists)
{
    struct nam *m = (struct nam *)mem;
    s32 *hist;
    int i, j, k, li, n = 0;
    if (nw != 1871) return -1;
    for (li = 0; li < NL; li++) if (!hists[li]) return -3;
    m->sr = qshift(w, 3);
    for (i = 0; i < CH; i++) m->rech[i] = qv(w[n++], m->sr);
    for (li = 0; li < NL; li++) {
        struct nlayer *L = &m->L[li];
        int K = KS[li], len = (K - 1) * DL[li] + NB, ncw = 9 * K;
        float tmp[15 * 9 + 3];
        hist = hists[li];
        L->K = K; L->D = DL[li]; L->hist = hist; L->stride = DL[li] * 12; L->w = L->wq;
        for (k = 0; k < len * CH; k++) hist[k] = 0;
        /* convolution + mixin : même décalage ; flux NAM : sortie i, entrée j, prise k -> wq[k*9 + j*3 + i] */
        for (k = 0; k < ncw; k++) tmp[k] = w[n + k];
        for (k = 0; k < 3; k++) tmp[ncw + k] = w[n + ncw + 3 + k];
        L->sw = qshift16(tmp, ncw + 3);
        for (i = 0; i < CH; i++) for (j = 0; j < CH; j++) for (k = 0; k < K; k++) L->wq[k * 9 + j * 3 + i] = (s16)qv(w[n++], L->sw);
        for (i = 0; i < CH; i++) L->b[i] = (s64)q23(w[n++]) << L->sw;
        for (i = 0; i < CH; i++) L->wq[ncw + i] = (s16)qv(w[n++], L->sw);
        L->s1 = qshift16(&w[n], 9);
        for (i = 0; i < CH; i++) for (j = 0; j < CH; j++) L->wq[ncw + 3 + j * 3 + i] = (s16)qv(w[n++], L->s1);   /* [entrée][sortie] */
        for (i = 0; i < CH; i++) L->l1b[i] = q23(w[n++]);
    }
    m->sh = qshift16(&w[n], HK * CH);
    for (j = 0; j < CH; j++) for (k = 0; k < HK; k++) m->hw[k * 3 + j] = (s16)qv(w[n++], m->sh);
    m->hb = (s64)q23(w[n++]) << m->sh;
    m->hscale = w[n++];
    for (k = 0; k < (HK - 1 + NB) * CH; k++) m->hcat[k] = 0;
    m->in_gain = 1; m->out_gain = 1;
    m->split = NAM_SPLIT_DEF;
    return n == nw ? 0 : -2;
}
/* copie déroulée par 8 (un saut pris coûte ~7 cycles) */
static inline void cpy(s32 *d, const s32 *s, int n)
{
    while (n >= 8) { s32 a = s[0], b = s[1], c = s[2], e = s[3], f = s[4], g = s[5], h = s[6], i = s[7]; d[0] = a; d[1] = b; d[2] = c; d[3] = e; d[4] = f; d[5] = g; d[6] = h; d[7] = i; d += 8; s += 8; n -= 8; }
    while (n-- > 0) *d++ = *s++;
}
/* couches [a, b) sur l'échange e (historique propre à chaque couche : une couche n'est jamais calculée par deux cœurs) */
__attribute__((section(".sram"))) static void layers(struct nam *m, struct xfer *e, int a, int b)
{
    int li, n = e->n;
    for (li = a; li < b; li++) {
        struct nlayer *L = &m->L[li];
        s32 *h = L->hist;
        const int K = L->K, span3 = (K - 1) * L->D * 3;
        nam_copy(h + span3, e->lin, n * 3);                             /* bloc écrit à la suite des span dernières trames */
        L->s = h; L->x = e->x; L->lin = e->lin; L->hs = e->hs; L->n = n;
        if (n > 0) {                                                    /* nam_asm.S */
            if (K == 15) nam_layer15(L);
            else if (li == NL - 1) nam_layer6_last(L);                  /* sans 1x1 : la tête ne lit que la somme des z */
            else nam_layer6(L);
        }
        nam_copy(h, h + n * 3, span3);                                  /* garder les span dernières trames en tête */
    }
}
/* moitié avant (2e cœur) : gain, rechannel, couches [0, split) -> échange ph. in en Q23. */
__attribute__((section(".sram"))) void nam_front(void *mem, const s32 *in, int n, int ph)
{
    struct nam *m = (struct nam *)mem;
    struct xfer *e = &m->xf[ph & 1];
    s32 *x = e->x, *lin = e->lin, *hs = e->hs;
    int f;
    if (n > NB) n = NB;
    e->n = n;
    {
        float g = m->in_gain;
        const int sr = m->sr;
        const s32 r0 = m->rech[0], r1 = m->rech[1], r2 = m->rech[2];
        for (f = 0; f < n; f++) {
            float v = (float)in[f] * g;
            s32 xv;
            if (v > 2.0e9f) v = 2.0e9f; else if (v < -2.0e9f) v = -2.0e9f;
            xv = (s32)v;
            x[f] = xv;
            lin[f * 3] = (s32)(((s64)r0 * xv) >> sr);
            lin[f * 3 + 1] = (s32)(((s64)r1 * xv) >> sr);
            lin[f * 3 + 2] = (s32)(((s64)r2 * xv) >> sr);
            hs[f * 3] = 0; hs[f * 3 + 1] = 0; hs[f * 3 + 2] = 0;
        }
    }
    layers(m, e, 0, m->split);
}
/* moitié arrière (1er cœur) : couches [split, 23) + tête, depuis l'échange ph -> out (Q23) */
__attribute__((section(".sram"))) void nam_back(void *mem, s32 *out, int ph)
{
    struct nam *m = (struct nam *)mem;
    struct xfer *e = &m->xf[ph & 1];
    s32 *hs = e->hs;
    int f, n = e->n;
    layers(m, e, m->split, NL);
    /* tête : y[f] = hb + sum_k Hw_k . hs[f - (15 - k)], avec les 15 dernières colonnes du bloc précédent */
    {
        s32 *hc = m->hcat;
        const int sh = m->sh;
        float sc = m->hscale * m->out_gain;
        cpy(hc + (HK - 1) * 3, hs, n * 3);
        if (n > 0) {
            struct hd p;
            p.w = m->hw; p.c = hc; p.dst = out; p.n = n; p.hb_lo = (s32)m->hb; p.hb_hi = (s32)(m->hb >> 32); p.sh = sh;
            nam_head_asm(&p);                                           /* out[f] = (hb + Hw . colonnes) >> sh (nam_asm.S) */
        }
        for (f = 0; f < n; f++) {
            float y = (float)out[f] * sc;
            if (y > 134217727.0f) y = 134217727.0f; else if (y < -134217727.0f) y = -134217727.0f;
            out[f] = (s32)y;
        }
        cpy(hc, hc + n * 3, (HK - 1) * 3);                              /* garder les 15 dernières colonnes */
    }
}
/* bloc complet sur un seul cœur (n <= 128) */
void nam_block(void *mem, const s32 *in, s32 *out, int n)
{
    nam_front(mem, in, n, 0);
    nam_back(mem, out, 0);
}
/* répartition : couches [0, s) sur le 2e cœur ; s = 0..23 */
void nam_set_split(void *mem, int s) { struct nam *m = (struct nam *)mem; if (s >= 0 && s <= NL) m->split = s; }
int nam_get_split(void *mem) { return ((struct nam *)mem)->split; }
/* 1 si la capture chargée est un NAM brut (répartissable sur 2 cœurs) */
int nam_is_raw(void *mem)
{
    u32 mg = *(volatile u32 *)mem;
    return !(mg == 0x314C3241u || mg == 0x00324D41u || mg == 0x00334D41u);
}
/* gains en Q16 (1,0 = 65536) */
void nam_gains(void *mem, s32 in_q16, s32 out_q16) { struct nam *m = (struct nam *)mem; m->in_gain = (float)in_q16 / 65536.0f; m->out_gain = (float)out_q16 / 65536.0f; }
/* préchauffage : n échantillons de silence (état stable comme NeuralAmpModelerCore), par blocs */
void nam_prewarm(void *mem, int n)
{
    static const s32 zero[NB];
    s32 tmp[NB];
    while (n > 0) { int k = n > NB ? NB : n; nam_block(mem, zero, tmp, k); n -= k; }
}
/* aiguillage NAM brut / A2L1 / captures M-VAVE AM2-AM3 (le premier mot du bloc est le magique) */
void a2l_block(void *mem, const s32 *in, s32 *out, int n);
void amx_block(void *mem, const s32 *in, s32 *out, int n);
void nam_run(void *mem, const s32 *in, s32 *out, int n)
{
    u32 mg = *(volatile u32 *)mem;
    if (mg == 0x314C3241u) a2l_block(mem, in, out, n);
    else if (mg == 0x00324D41u || mg == 0x00334D41u) amx_block(mem, in, out, n);
    else nam_block(mem, in, out, n);
}

