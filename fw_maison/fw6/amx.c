/* amx.c : moteur des captures M-VAVE AM2/AM3 (.am2Data/.am3Data, 60 o d'en-tête + 1536 float32).
 * Topologie : FIR pré 256 -> GRU 3 portes / 16 unités -> aux1/2/3 (64) -> FIR post 256.
 * FIR stockés « prise la plus récente en dernier » : y[n] = sum_k w[k] * x[n-(255-k)].
 * Virgule fixe : poids Q20 (int32), activations/historiques Q12 (1,0 = 4096), MAC 64 bits,
 * table tanh Q12 (sigmoid = 0.5 + 0.5*tanh(x/2)). Normalisation par capture au chargement. */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
typedef unsigned short u16;
typedef short s16;
typedef unsigned char u8;
void wdt_clear(void);
float sinf(float);
float tanhf(float);

#define AMX2 0x00324D41u                                       /* "AM2\0" */
#define AMX3 0x00334D41u                                       /* "AM3\0" */
#define AMX_PRE 512
#define AMX_POST 512
#define AMX_AUX 3
#define AQ12 4096
#define AQ20 (1 << 20)

struct amx {
    u32 magic;
    int mix, level_q16, norm_q16, in_gain, out_gain;
    int npre, npost;
    s32 pre[AMX_PRE], post[AMX_POST], aux[AMX_AUX][64];
    s32 wi[3][16], wh[3][256], vec[16], h[16];
    s32 pre_h[AMX_PRE], post_h[AMX_POST], aux_h[AMX_AUX][128];
    int pre_p, post_p, aux_p[AMX_AUX];
};
u32 amx_mem_size(void) { return (u32)sizeof(struct amx) + 64; }

static s32 amx_mulq16(s32 a, s32 b) { return (s32)(((s64)a * b) >> 16); }
static s16 tanh_tab[1025];
static int tanh_ok;
static void amx_tab_init(void)
{
    int i;
    if (tanh_ok) return;
    for (i = 0; i <= 1024; i++) {
        float x = -8.0f + (float)i / 64.0f;
        tanh_tab[i] = (s16)(tanhf(x) * 4096.0f);
    }
    tanh_ok = 1;
}
static s32 amx_tanh_q12(s32 x)
{
    u32 u;
    int i, f, a, b;
    if (x > 32767) x = 32767; else if (x < -32768) x = -32768;
    u = (u32)(x + 32768);
    i = (int)(u >> 6); f = (int)(u & 63);
    a = tanh_tab[i]; b = tanh_tab[i + 1];
    return a + (((b - a) * f) >> 6);
}
static s32 amx_sigm_q12(s32 x) { return 2048 + (amx_tanh_q12(x >> 1) >> 1); }
s32 amx_fir256_asm(const s32 *w, s32 *h, int *pos, s32 x);
static inline s32 amx_fir256(const s32 *w, s32 *h, int *pos, s32 x)
{
    return amx_fir256_asm(w, h, pos, x);
}
static inline s32 amx_fir64(const s32 *w, s32 *h, int *pos, s32 x)
{
    int p = *pos, i;
    s64 a0 = 0, a1 = 0, a2 = 0, a3 = 0;
    const s32 *hp;
    h[p] = x; h[p + 64] = x;
    hp = h + p + 1;
    for (i = 0; i < 64; i += 8) {
        a0 += (s64)w[i + 0] * hp[i + 0] + (s64)w[i + 4] * hp[i + 4];
        a1 += (s64)w[i + 1] * hp[i + 1] + (s64)w[i + 5] * hp[i + 5];
        a2 += (s64)w[i + 2] * hp[i + 2] + (s64)w[i + 6] * hp[i + 6];
        a3 += (s64)w[i + 3] * hp[i + 3] + (s64)w[i + 7] * hp[i + 7];
    }
    *pos = (p + 1) & 63;
    return (s32)((a0 + a1 + a2 + a3) >> 20);
}
static inline s32 amx_fir(const s32 *w, s32 *h, int *pos, int n, s32 x)
{
    return n == 256 ? amx_fir256(w, h, pos, x) : amx_fir64(w, h, pos, x);
}
static s32 amx_gru(struct amx *m, s32 x)
{
    s32 r[16], z[16], nn[16], h2[16];
    s64 y = 0;
    int i, j;
    for (i = 0; i < 16; i++) {
        s64 a = (s64)m->wi[0][i] * x, b = (s64)m->wi[1][i] * x, d = 0, c = (s64)m->wi[2][i] * x;
        const s32 *w0 = m->wh[0] + i * 16, *w1 = m->wh[1] + i * 16, *w2 = m->wh[2] + i * 16;
        for (j = 0; j < 16; j += 4) {
            a += (s64)w0[j + 0] * m->h[j + 0] + (s64)w0[j + 1] * m->h[j + 1] + (s64)w0[j + 2] * m->h[j + 2] + (s64)w0[j + 3] * m->h[j + 3];
            b += (s64)w1[j + 0] * m->h[j + 0] + (s64)w1[j + 1] * m->h[j + 1] + (s64)w1[j + 2] * m->h[j + 2] + (s64)w1[j + 3] * m->h[j + 3];
            d += (s64)w2[j + 0] * m->h[j + 0] + (s64)w2[j + 1] * m->h[j + 1] + (s64)w2[j + 2] * m->h[j + 2] + (s64)w2[j + 3] * m->h[j + 3];
        }
        r[i] = amx_sigm_q12((s32)(a >> 20)); z[i] = amx_sigm_q12((s32)(b >> 20));
        nn[i] = amx_tanh_q12((s32)(c >> 20) + ((r[i] * (s32)(d >> 20)) >> 12));
    }
    for (i = 0; i < 16; i++) {
        h2[i] = (((4096 - z[i]) * nn[i]) + (z[i] * m->h[i])) >> 12;
        y += (s64)m->vec[i] * h2[i];
    }
    for (i = 0; i < 16; i++) m->h[i] = h2[i];
    return (s32)(y >> 20);
}
static s32 amx_one(struct amx *m, s32 x)
{
    s32 y;
    int a;
    x = amx_mulq16(x, m->in_gain);
    y = amx_fir(m->pre, m->pre_h, &m->pre_p, m->npre, x);
    y = amx_gru(m, y);
    for (a = 0; a < 3; a++) y = amx_fir(m->aux[a], m->aux_h[a], &m->aux_p[a], 64, y);
    y = amx_fir(m->post, m->post_h, &m->post_p, m->npost, y);
    y = amx_mulq16(y, m->norm_q16);
    y = amx_mulq16(y, m->level_q16);
    if (y > AQ12) y = AQ12; else if (y < -AQ12) y = -AQ12;
    return y;
}
static void amx_reset(struct amx *m)
{
    int i;
    for (i = 0; i < AMX_PRE; i++) m->pre_h[i] = 0;
    for (i = 0; i < AMX_POST; i++) m->post_h[i] = 0;
    for (i = 0; i < 128; i++) { m->aux_h[0][i] = m->aux_h[1][i] = m->aux_h[2][i] = 0; }
    for (i = 0; i < 16; i++) m->h[i] = 0;
    m->pre_p = m->post_p = 0; m->aux_p[0] = m->aux_p[1] = m->aux_p[2] = 0;
    m->in_gain = 65536; m->out_gain = 65536;
}
static s32 amx_q(float v) { return (s32)(v * (float)AQ20 + (v < 0 ? -0.5f : 0.5f)); }
int amx_load(void *mem, const u8 *b, int len)
{
    struct amx *m = (struct amx *)mem;
    const float *f;
    int i, c;
    u32 mg = (u32)b[0] | ((u32)b[1] << 8) | ((u32)b[2] << 16) | ((u32)b[3] << 24);
    if (!m || len != 6204 || (mg != AMX2 && mg != AMX3)) return -1;
    m->magic = mg;
    amx_tab_init();
    amx_reset(m);
    f = (const float *)(b + 60);
    for (i = 0; i < 256; i++) { m->pre[i] = amx_q(f[i]); m->post[i] = amx_q(f[1088 + i]); }
    for (i = 0; i < 16; i++) m->vec[i] = amx_q(f[1072 + i]);
    for (c = 0; c < 3; c++) for (i = 0; i < 16; i++) m->wi[c][i] = amx_q(f[256 + c * 16 + i]);
    for (c = 0; c < 3; c++) for (i = 0; i < 256; i++) m->wh[c][i] = amx_q(f[304 + c * 256 + i]);
    for (c = 0; c < 3; c++) for (i = 0; i < 64; i++) m->aux[c][i] = amx_q(f[1344 + c * 64 + i]);
    m->npre = m->npost = 256;
    /* normalisation : sinus 1 kHz à 0,5 (Q12) sur 4096 échantillons, puis remise à zéro */
    {
        s32 peak = 0;
        int n;
        m->norm_q16 = 65536; m->level_q16 = 65536;
        for (n = 0; n < 4096; n++) {
            s32 x = (s32)(2048.0f * sinf(2.0f * 3.14159265f * 1000.0f * (float)n / 48000.0f));
            s32 y = amx_one(m, x);
            if (y < 0) y = -y;
            if (y > peak) peak = y;
            if ((n & 511) == 0) wdt_clear();
        }
        m->norm_q16 = peak > 0 ? (int)(((s64)1638 << 16) / peak) : 65536;
        if (m->norm_q16 > 20 * 65536) m->norm_q16 = 20 * 65536;
        else if (m->norm_q16 < 655) m->norm_q16 = 655;
        m->level_q16 = (int)((s64)b[0x13] * 65536 / 100);
        m->mix = b[0x12];
        amx_reset(m);
        for (n = 0; n < 6400; n++) { (void)amx_one(m, 0); if ((n & 511) == 0) wdt_clear(); }
    }
    return 0;
}
void amx_gains(void *mem, s32 in_q16, s32 out_q16) { struct amx *m = (struct amx *)mem; m->in_gain = in_q16; m->out_gain = out_q16; }
void amx_block(void *mem, const s32 *in, s32 *out, int n)
{
    struct amx *m = (struct amx *)mem;
    int f, mixq = m->mix * 65536 / 100;
    if (n > 128) n = 128;
    for (f = 0; f < n; f++) {
        s32 x = in[f] >> 11;                                    /* Q23 -> Q12 */
        s32 wet = amx_one(m, x);
        s32 y = amx_mulq16(wet, mixq) + amx_mulq16(x, 65536 - mixq);
        y = amx_mulq16(y, m->out_gain);
        if (y > AQ12) y = AQ12; else if (y < -AQ12) y = -AQ12;
        out[f] = y << 11;                                       /* Q12 -> Q23 */
    }
}
void amx_prewarm(void *mem, int n)
{
    struct amx *m = (struct amx *)mem;
    while (n-- > 0) { (void)amx_one(m, 0); if ((n & 511) == 0) wdt_clear(); }
}
