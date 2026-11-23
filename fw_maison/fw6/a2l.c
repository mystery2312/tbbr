/* a2l.c : moteur NAM A2 Lite au format « A2L1 » (poids int16, Q par étage, activations 32 bits).
 * Format produit par nam2a2l1.py (réseau A2 Lite en int16) :
 *   en-tête A2L1 + couches (K, dilatation, Q z/x3, coefficients int16, biais int64) + tête + CRC32.
 * Le moteur reprend la structure de nam.c (historiques linéaires, bloc de 128) mais lit des poids int16
 * et applique un décalage par étage ; l'entrée/sortie reste en Q23 comme le reste du moteur.
 * Aucune allocation ici : le bloc mémoire vient de pool_alloc() dans engine.c. */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
typedef unsigned short u16;
typedef short s16;
typedef unsigned char u8;

#define ANB 128
#define ANLMAX 23
#define AHKMAX 64
#define A2L_MAGIC 0x314C3241u                                  /* "A2L1" en little-endian */
#define A2L_VER 1

struct a2l_layer {
    int K, D, span3, Fz, Fx3, lmul;
    int shc, shm, shl, shr, shf;                               /* décalages précalculés */
    s16 cw[15 * 9];                                            /* [k*9 + sortie*3 + entrée] */
    s64 cb[3];
    s16 mw[3];
    s16 lw[9];                                                 /* [sortie*3 + entrée] */
    s64 lb[3];
    s32 *hist;
};
struct a2l {
    u32 magic;
    int nL, C, hk, Fin, Fx3_0, Fh, Fout, rech_F;
    int sh_in, sh_out, sh_rech, sho;                           /* entrée Q23->Fin, sortie Fout->Q23, tête */
    s16 rech_w[3];
    float in_gain, out_gain;
    struct a2l_layer L[ANLMAX];
    s16 hw[AHKMAX * 3];                                        /* [k*3 + canal] */
    s64 hb;
    int hF;
    s32 x[ANB], lin[ANB * 3], hs[ANB * 3], hcat[(AHKMAX - 1 + ANB) * 3];
};

static u32 al_u32(const u8 *p) { return (u32)p[0] | ((u32)p[1] << 8) | ((u32)p[2] << 16) | ((u32)p[3] << 24); }
static u16 al_u16(const u8 *p) { return (u16)(p[0] | (p[1] << 8)); }
static s16 al_s16(const u8 *p) { return (s16)al_u16(p); }
static s64 al_s64(const u8 *p) { union { unsigned long long u; u8 b[8]; } v; int i; for (i = 0; i < 8; i++) v.b[i] = p[i]; return (s64)v.u; }
static int al_i8(const u8 *p) { return (int)(signed char)p[0]; }
static u32 al_crc32(const u8 *p, u32 n)
{
    u32 c = 0xFFFFFFFFu, i, k;
    for (i = 0; i < n; i++) { c ^= p[i]; for (k = 0; k < 8; k++) c = (c & 1) ? (0xEDB88320u ^ (c >> 1)) : (c >> 1); }
    return ~c;
}
static s64 asar64(s64 v, int s) { return s >= 0 ? (v >> s) : (v << -s); }
static s32 asar32(s32 v, int s) { return s >= 0 ? (v >> s) : (v << -s); }
static void acpy(s32 *d, const s32 *s, int n)
{
    while (n >= 8) { s32 a = s[0], b = s[1], c = s[2], e = s[3], f = s[4], g = s[5], h = s[6], i = s[7]; d[0] = a; d[1] = b; d[2] = c; d[3] = e; d[4] = f; d[5] = g; d[6] = h; d[7] = i; d += 8; s += 8; n -= 8; }
    while (n-- > 0) *d++ = *s++;
}
static u32 a2l_parse_size(const u8 *b, u32 n, u32 *layer_off)
{
    u32 o = 36, li, total;
    int nL;
    if (n < 44 || al_u32(b) != A2L_MAGIC || al_u16(b + 4) != A2L_VER) return 0;
    nL = al_u16(b + 12);
    if (nL <= 0 || nL > ANLMAX || b[14] != 3 || b[15] == 0 || b[15] > AHKMAX) return 0;
    total = (u32)sizeof(struct a2l);
    for (li = 0; li < (u32)nL; li++) {
        int K, D;
        if (o + 9 > n) return 0;
        K = b[o]; D = al_u16(b + o + 1);
        if (K < 1 || K > 15 || D < 1) return 0;
        o += 9 + 1 + 18 * K + 24 + 7 + 1 + 18 + 24;
        total += (u32)((K - 1) * D + ANB) * 3 * 4;
    }
    if (layer_off) *layer_off = 36;
    return total + 64;
}
u32 a2l_mem_size(const u8 *b, u32 n) { return a2l_parse_size(b, n, 0); }

int a2l_load(void *mem, const u8 *b, u32 n)
{
    struct a2l *m = (struct a2l *)mem;
    s32 *hist = (s32 *)(m + 1);
    int li, c, k, co, ci, Fx3_prev;
    u32 o = 36;
    if (!m || n < 44 || al_u32(b) != A2L_MAGIC || al_u16(b + 4) != A2L_VER) return -1;
    if (al_u32(b + n - 4) != al_crc32(b, n - 4)) return -2;
    if (b[6] != 16 || (b[7] != 16 && b[7] != 32) || b[14] != 3 || b[15] == 0 || b[15] > AHKMAX) return -3;
    m->magic = A2L_MAGIC;
    m->nL = al_u16(b + 12); m->C = b[14]; m->hk = b[15];
    if (m->nL <= 0 || m->nL > ANLMAX) return -3;
    m->Fin = al_i8(b + 16); m->Fx3_0 = al_i8(b + 17); m->Fh = al_i8(b + 18); m->Fout = al_i8(b + 19);
    o = 20 + 16;
    m->rech_F = al_i8(b + o); o += 1;
    for (c = 0; c < 3; c++) { m->rech_w[c] = al_s16(b + o); o += 2; }
    m->sh_in = 23 - m->Fin; m->sh_out = m->Fout - 23;
    m->sh_rech = m->rech_F + m->Fin - m->Fx3_0;
    m->in_gain = 1.0f; m->out_gain = 1.0f;
    Fx3_prev = m->Fx3_0;
    for (li = 0; li < m->nL; li++) {
        struct a2l_layer *L = &m->L[li];
        L->K = b[o]; L->D = al_u16(b + o + 1); L->Fz = al_i8(b + o + 3); L->Fx3 = al_i8(b + o + 4);
        L->lmul = (int)al_u32(b + o + 5); o += 9;
        L->shc = al_i8(b + o) + Fx3_prev - L->Fz; o += 1;
        for (co = 0; co < 3; co++) for (ci = 0; ci < 3; ci++) for (k = 0; k < L->K; k++)
            L->cw[k * 9 + co * 3 + ci] = al_s16(b + o + ((co * 3 + ci) * L->K + k) * 2);
        o += 18 * L->K;
        for (c = 0; c < 3; c++) { L->cb[c] = al_s64(b + o); o += 8; }
        L->shm = al_i8(b + o) + m->Fin - L->Fz; o += 1;
        for (c = 0; c < 3; c++) { L->mw[c] = al_s16(b + o); o += 2; }
        L->shl = al_i8(b + o) + L->Fz - L->Fx3; o += 1;
        for (co = 0; co < 3; co++) for (ci = 0; ci < 3; ci++) L->lw[co * 3 + ci] = al_s16(b + o + (ci * 3 + co) * 2);
        o += 18;
        for (c = 0; c < 3; c++) { L->lb[c] = al_s64(b + o); o += 8; }
        L->shr = Fx3_prev - L->Fx3;
        L->shf = L->Fz - m->Fh;
        L->span3 = (L->K - 1) * L->D * 3;
        L->hist = hist;
        { int len = ((L->K - 1) * L->D + ANB) * 3; for (k = 0; k < len; k++) hist[k] = 0; hist += len; }
        Fx3_prev = L->Fx3;
    }
    m->hF = al_i8(b + o); o += 1;
    for (k = 0; k < m->hk; k++) for (c = 0; c < 3; c++) m->hw[k * 3 + c] = al_s16(b + o + (c * m->hk + k) * 2);
    o += 6 * m->hk;
    m->hb = al_s64(b + o); o += 8;
    m->sho = m->hF + m->Fh - m->Fout;
    if (o + 4 != n) return -4;
    return 0;
}
void a2l_gains(void *mem, s32 in_q16, s32 out_q16) { struct a2l *m = (struct a2l *)mem; m->in_gain = (float)in_q16 / 65536.0f; m->out_gain = (float)out_q16 / 65536.0f; }
void a2l_block(void *mem, const s32 *in, s32 *out, int n)
{
    struct a2l *m = (struct a2l *)mem;
    int f, li, k, c;
    if (n > ANB) n = ANB;
    for (f = 0; f < n; f++) {
        s32 v = (s32)((float)in[f] * m->in_gain);
        s32 xq = asar32(v, m->sh_in);
        m->x[f] = xq;
        for (c = 0; c < 3; c++) m->lin[f * 3 + c] = (s32)asar64((s64)m->rech_w[c] * xq, m->sh_rech);
        m->hs[f * 3] = 0; m->hs[f * 3 + 1] = 0; m->hs[f * 3 + 2] = 0;
    }
    for (li = 0; li < m->nL; li++) {
        struct a2l_layer *L = &m->L[li];
        s32 *h = L->hist;
        const int K = L->K, D3 = L->D * 3, span3 = L->span3;
        acpy(h + span3, m->lin, n * 3);
        for (f = 0; f < n; f++) {
            const s32 *s = h + f * 3;
            s64 a0 = L->cb[0], a1 = L->cb[1], a2 = L->cb[2];
            s32 z0, z1, z2, xf = m->x[f];
#define ATAP(k) { const s32 *sk = s + (k) * D3; const s16 *wk = L->cw + (k) * 9; \
                  const s32 s0 = sk[0], s1v = sk[1], s2 = sk[2]; \
                  a0 += (s64)wk[0] * s0 + (s64)wk[1] * s1v + (s64)wk[2] * s2; \
                  a1 += (s64)wk[3] * s0 + (s64)wk[4] * s1v + (s64)wk[5] * s2; \
                  a2 += (s64)wk[6] * s0 + (s64)wk[7] * s1v + (s64)wk[8] * s2; \
                  __asm__ volatile ("" ::: "memory"); }
            ATAP(0) ATAP(1) ATAP(2) ATAP(3) ATAP(4) ATAP(5)
            if (K == 15) { ATAP(6) ATAP(7) ATAP(8) ATAP(9) ATAP(10) ATAP(11) ATAP(12) ATAP(13) ATAP(14) }
#undef ATAP
            z0 = (s32)asar64(a0, L->shc) + (s32)asar64((s64)L->mw[0] * xf, L->shm);
            z1 = (s32)asar64(a1, L->shc) + (s32)asar64((s64)L->mw[1] * xf, L->shm);
            z2 = (s32)asar64(a2, L->shc) + (s32)asar64((s64)L->mw[2] * xf, L->shm);
            if (z0 < 0) z0 = (s32)asar64((s64)z0 * L->lmul, 24);
            if (z1 < 0) z1 = (s32)asar64((s64)z1 * L->lmul, 24);
            if (z2 < 0) z2 = (s32)asar64((s64)z2 * L->lmul, 24);
            m->hs[f * 3] += (s32)asar64(z0, L->shf);
            m->hs[f * 3 + 1] += (s32)asar64(z1, L->shf);
            m->hs[f * 3 + 2] += (s32)asar64(z2, L->shf);
            {
                s32 *lf = &m->lin[f * 3];
                s64 c0 = L->lb[0] + (s64)L->lw[0] * z0 + (s64)L->lw[1] * z1 + (s64)L->lw[2] * z2;
                s64 c1 = L->lb[1] + (s64)L->lw[3] * z0 + (s64)L->lw[4] * z1 + (s64)L->lw[5] * z2;
                s64 c2 = L->lb[2] + (s64)L->lw[6] * z0 + (s64)L->lw[7] * z1 + (s64)L->lw[8] * z2;
                lf[0] = (s32)asar64(lf[0], L->shr) + (s32)asar64(c0, L->shl);
                lf[1] = (s32)asar64(lf[1], L->shr) + (s32)asar64(c1, L->shl);
                lf[2] = (s32)asar64(lf[2], L->shr) + (s32)asar64(c2, L->shl);
            }
        }
        acpy(h, h + n * 3, span3);
    }
    {
        s32 *hc = m->hcat;
        acpy(hc + (m->hk - 1) * 3, m->hs, n * 3);
        for (f = 0; f < n; f++) {
            s64 acc = m->hb;
            const s32 *cc = &hc[f * 3];
            s32 y;
            for (k = 0; k < m->hk; k++) acc += (s64)m->hw[k * 3] * cc[k * 3] + (s64)m->hw[k * 3 + 1] * cc[k * 3 + 1] + (s64)m->hw[k * 3 + 2] * cc[k * 3 + 2];
            y = (s32)asar64(acc, m->sho);
            out[f] = (s32)((float)asar32(y, m->sh_out) * m->out_gain);
        }
        acpy(hc, hc + n * 3, (m->hk - 1) * 3);
    }
}
void a2l_prewarm(void *mem, int n)
{
    static const s32 zero[ANB];
    s32 tmp[ANB];
    while (n > 0) { int k = n > ANB ? ANB : n; a2l_block(mem, zero, tmp, k); n -= k; }
}
