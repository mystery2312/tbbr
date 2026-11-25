/* engine.c : moteur de chaîne « The Big Black Rig » (grille 2 rangées x 8 colonnes, sections parallèles, 8 scènes).
 *
 * Modèle de la maquette (interface/app) :
 *  - rangée A = chaîne principale ; chaque groupe contigu de blocs sur la rangée B forme une section parallèle
 *    (split avant sa 1re colonne, merge après sa dernière), balance A/B 0..100 (par[] du preset, 50 par défaut) ;
 *  - paramètres en unités réelles, dans l'ordre du catalogue (catalog.h, généré depuis data.js) ;
 *  - chaque scène mémorise bypass + paramètres de chaque bloc.
 * Audio en virgule fixe Q23 (1,0 = 2^23) ; coefficients recalculés en flottant (libm / compiler-rt) à chaque changement. */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
typedef short s16;
typedef unsigned short u16;
typedef unsigned char u8;
#include "catalog.h"
#include "tables.h"
#include "engine.h"

float sinf(float); float cosf(float); float powf(float, float); float sqrtf(float); float log10f(float);
#define PI_F 3.14159265f
#define FS 48000.0f
#define ONE (1 << 23)

/* ---------------- réserve mémoire (délais, réverbes, modulations) ---------------- */
#define POOL1_LO 0x1C00000u
#define POOL1_HI 0x1C30000u            /* 192 Ko */
#define POOL2_LO 0x1C54000u
#define POOL2_HI 0x1C70000u            /* 112 Ko */
static u32 pool1, pool2;
static void pool_reset(void) { pool1 = POOL1_LO; pool2 = POOL2_LO; }
static void *pool_alloc(u32 n)
{
    u32 *p, i;
    n = (n + 7) & ~7u;
    if (pool1 + n <= POOL1_HI) { p = (u32 *)pool1; pool1 += n; }
    else if (pool2 + n <= POOL2_HI) { p = (u32 *)pool2; pool2 += n; }
    else return 0;
    for (i = 0; i < n / 4; i++) p[i] = 0;
    return p;
}
static u32 pool_largest(void) { u32 a = POOL1_HI - pool1, b = POOL2_HI - pool2; return a > b ? a : b; }
/* délais : pendant le chargement d'un preset, leur mémoire (qui prend « tout ce qui reste ») est allouée en dernier
   (engine_load_end), pour ne pas priver le NAM, l'IR ou une réverbe placés après eux */
static int dly_defer, dly_share;
u32 engine_mem_free(void) { return (POOL1_HI - pool1) + (POOL2_HI - pool2); }

/* ---------------- primitives ---------------- */
static inline s32 mulq15(s32 x, s32 g) { return (s32)(((s64)x * g) >> 15); }
static inline s32 mulq16(s32 x, s32 g) { return (s32)(((s64)x * g) >> 16); }
static s32 iabs(s32 v) { return v < 0 ? -v : v; }
static float clampf(float v, float a, float b) { return v < a ? a : (v > b ? b : v); }
static s32 db2q16(float db) { float g; db = clampf(db, -96.0f, 40.0f); g = powf(10.0f, db / 20.0f); return (s32)(g * 65536.0f); }
static s32 pct2q15(float p) { return (s32)(clampf(p, 0.0f, 100.0f) * 327.67f); }
static s32 sat_q23(s64 v) { return v > 0x7FFFFFFF ? 0x7FFFFFFF : (v < -0x7FFFFFFF ? -0x7FFFFFFF : (s32)v); }

struct bq { s32 c[5]; s32 z[4]; };
enum { BQ_LP, BQ_HP, BQ_PEAK, BQ_LSH, BQ_HSH, BQ_THRU };
static void bq_design(struct bq *b, int kind, float f0, float q, float gdb)
{
    float A, w, c, s, al, b0, b1, b2, a0, a1, a2, sa;
    if (kind == BQ_THRU) { b->c[0] = 1 << 28; b->c[1] = b->c[2] = b->c[3] = b->c[4] = 0; return; }
    A = powf(10.0f, gdb / 40.0f);
    f0 = clampf(f0, 10.0f, 22000.0f); q = clampf(q, 0.1f, 20.0f);
    w = 2.0f * PI_F * f0 / FS; c = cosf(w); s = sinf(w); al = s / (2.0f * q);
    if (kind == BQ_LP) { b0 = (1 - c) / 2; b1 = 1 - c; b2 = b0; a0 = 1 + al; a1 = -2 * c; a2 = 1 - al; }
    else if (kind == BQ_HP) { b0 = (1 + c) / 2; b1 = -(1 + c); b2 = b0; a0 = 1 + al; a1 = -2 * c; a2 = 1 - al; }
    else if (kind == BQ_PEAK) { b0 = 1 + al * A; b1 = -2 * c; b2 = 1 - al * A; a0 = 1 + al / A; a1 = -2 * c; a2 = 1 - al / A; }
    else if (kind == BQ_LSH) {
        sa = 2 * sqrtf(A) * al;
        b0 = A * ((A + 1) - (A - 1) * c + sa); b1 = 2 * A * ((A - 1) - (A + 1) * c); b2 = A * ((A + 1) - (A - 1) * c - sa);
        a0 = (A + 1) + (A - 1) * c + sa; a1 = -2 * ((A - 1) + (A + 1) * c); a2 = (A + 1) + (A - 1) * c - sa;
    } else {
        sa = 2 * sqrtf(A) * al;
        b0 = A * ((A + 1) + (A - 1) * c + sa); b1 = -2 * A * ((A - 1) + (A + 1) * c); b2 = A * ((A + 1) + (A - 1) * c - sa);
        a0 = (A + 1) - (A - 1) * c + sa; a1 = 2 * ((A - 1) - (A + 1) * c); a2 = (A + 1) - (A - 1) * c - sa;
    }
    b->c[0] = (s32)(b0 / a0 * 268435456.0f); b->c[1] = (s32)(b1 / a0 * 268435456.0f); b->c[2] = (s32)(b2 / a0 * 268435456.0f);
    b->c[3] = (s32)(a1 / a0 * 268435456.0f); b->c[4] = (s32)(a2 / a0 * 268435456.0f);
}
static inline s32 bq_run(struct bq *b, s32 x)
{
    s64 acc = (s64)b->c[0] * x + (s64)b->c[1] * b->z[0] + (s64)b->c[2] * b->z[1] - (s64)b->c[3] * b->z[2] - (s64)b->c[4] * b->z[3];
    s32 y = (s32)(acc >> 28);
    b->z[1] = b->z[0]; b->z[0] = x; b->z[3] = b->z[2]; b->z[2] = y;
    return y;
}
static s32 shaper(s32 x)                         /* tanh légèrement asymétrique, table sur [-4, 4] */
{
    s32 t = x + 4 * ONE, d; u32 i, f;
    if (t < 0) t = 0;
    if (t >= 8 * ONE) t = 8 * ONE - 1;
    i = (u32)t >> 17; f = (u32)t & 0x1FFFF;
    d = sat_tab[i + 1] - sat_tab[i];
    return sat_tab[i] + (s32)(((s64)d * f) >> 17);
}
static s32 lfo_sine(u32 ph)                      /* Q15, table 256 points interpolée */
{
    u32 i = ph >> 24, f = (ph >> 8) & 0xFFFF;
    s32 a = sine256[i], b = sine256[(i + 1) & 255];
    return a + (((b - a) * (s32)f) >> 16);
}
static u32 hz2inc(float hz) { return (u32)(clampf(hz, 0.0f, 20.0f) * (4294967296.0f / FS)); }

/* ---------------- états des blocs ---------------- */
struct st_drv { struct bq pre1, pre2, up1, up2, dn1, dn2, t1, t2, t3, t4; s32 gain, level, bias; };
struct st_eq  { struct bq b[9]; int n; s32 level, mix; };
struct st_dyn { s32 env, g, thr, att, rel, floor_g, mix, level; s32 lthr, kq; u32 cnt; };   /* thr : seuil linéaire Q23 ; lthr = log2(thr) Q16 ; kq = 1 - 1/ratio Q16 */
struct st_mod { s32 *buf; u32 wr, ph, inc, inc2, ph2; s32 base, depth, mix, fb, fbv, kind, shape, dry; s32 apz[12]; int nst; struct bq tone; };
struct st_dly { s16 *buf; u32 len, wr, d; s32 fb, mix, dry; struct bq lp, hp; u32 ph, inc, mod; s32 dsm; };
#define RV_N 12
#define RV_B 128                                                        /* réverbe calculée par blocs (voir run_rev) */
struct st_rev { s32 *line[RV_N]; u16 len[RV_N]; u16 idx[RV_N]; u8 nlines; s32 filt[8]; s32 fbk, damp, mix, dry; struct bq lc, tone; s16 *pre; u32 plen, pwr, pd;
                s32 *xb, *wb; u32 bp; };                                /* xb : entrées du bloc en cours ; wb : sortie humide du bloc précédent */
/* IR : convolution partitionnée uniforme (overlap-save), FFT 256, blocs de 128, jusqu'à 16 partitions (2048 points) */
#define IR_B 128
#define IR_N 256
#define IR_P 16
struct st_eq;
struct st_ir_core { s32 *H, *F, *xin, *outq; u32 pos, head; int slot, np, P; s32 level, mix; struct bq lc, hc; };   /* P = partitions allouées */
#define CAB_P 8                                                         /* cabs d'usine : 1 024 points = 8 partitions (moitié de la mémoire d'une IR) */
#define PIT_W 1200u                                                     /* fenêtre 25 ms */
#define PIT_LEN 2048u
struct st_pit { s16 *buf; u32 wr; s32 ph[3], step[3], g[3]; s32 dry; int nv; };
struct st_ir { struct st_ir_core c; struct st_eq fb; };              /* fb = baffle simulé si l'emplacement IR est vide */
struct st_nam { void *mem; u32 msize; int slot; int kind; struct st_eq eq; s32 *hist[23]; };   /* hist : historiques du NAM brut, par couche */             /* eq = gains + EQ 3 bandes (et seul traitement si vide) */
struct st_cm { void *mem; };                                       /* modèles d'après schémas (models.c), état dans la réserve */
union st_any { struct st_cm cm; struct st_drv d; struct st_eq e; struct st_dyn y; struct st_mod m; struct st_dly l; struct st_rev r; struct st_pit t; struct st_ir i; struct st_nam n; };
/* nam.c (instructions flottantes matérielles ; interface entière) */
unsigned int nam_mem_size(void);
unsigned int nam_hist_bytes(int li);
int nam_load(void *mem, const float *w, int nw, s32 *const *hist);
void nam_gains(void *mem, s32 in_q16, s32 out_q16);
void nam_prewarm(void *mem, int n);
void nam_block(void *mem, const s32 *in, s32 *out, int n);
const u8 *proto_nam_blob(int s, int *n);
u32 a2l_mem_size(const u8 *b, u32 n);
int a2l_load(void *mem, const u8 *b, u32 n);
void a2l_gains(void *mem, s32 in_q16, s32 out_q16);
void a2l_prewarm(void *mem, int n);
void a2l_block(void *mem, const s32 *in, s32 *out, int n);
void nam_run(void *mem, const s32 *in, s32 *out, int n);
void nam_back(void *mem, s32 *out, int ph);
int nam_is_raw(void *mem);
void wdt_clear(void);
u32 amx_mem_size(void);
int amx_load(void *mem, const u8 *b, int len);
void amx_gains(void *mem, s32 in_q16, s32 out_q16);
void amx_prewarm(void *mem, int n);
void amx_block(void *mem, const s32 *in, s32 *out, int n);
const float *proto_nam_weights(int s, int *n);
void engine_sync(void);                                              /* attend que le 2e cœur ait fini son bloc */
int engine_block_set_force(int lane, int col, int m);
void engine_clear(void);
s32 engine_process(s32 x);

struct block {
    u8 used, model, on;
    u8 cm, cat;                                                      /* type de moteur et categorie, mis en cache au design */
    float p[MAX_PARAMS];
    union st_any s;
};
static struct block grid[2][CAT_COLS];
static struct { u8 used, model; } scene_model[2][CAT_COLS];
struct scene_blk { u8 on; float p[MAX_PARAMS]; };
static struct scene_blk scenes[CAT_SCENES][2][CAT_COLS];
static struct { u8 from, to; s32 mix; } secs[CAT_COLS];
static int nsec, cur_scene;
static s32 level_q16 = 65536;
static u32 eng_ver;
static u32 eng_mods;                                                  /* modifications du preset (pas les changements de scène) */

/* ---------------- conception des blocs (flottant) ---------------- */
static float knob01(float v) { return clampf(v / 10.0f, 0.0f, 1.0f); }           /* potards 0..10 */
static void os_filters(struct st_drv *d)
{
    bq_design(&d->up1, BQ_LP, 15000.0f * 0.5f, 0.541f, 0); bq_design(&d->up2, BQ_LP, 15000.0f * 0.5f, 1.307f, 0);
    /* filtres à 96 kHz : fréquence normalisée divisée par 2 => on conçoit à 7,5 kHz pour 48 kHz = 15 kHz à 96 kHz */
    d->dn1 = d->up1; d->dn2 = d->up2;
}
/* saturations (drives + amplis) : pré-filtres, gain, tonalité */
static void design_drive(struct block *b)
{
    struct st_drv *d = &b->s.d;
    float *p = b->p, g = 1, lvl = 0;
    os_filters(d);
    d->bias = 0;
    bq_design(&d->t3, BQ_THRU, 0, 0, 0); bq_design(&d->t4, BQ_THRU, 0, 0, 0);
    switch (b->model) {
    case M_GREEN:   /* type Tube Screamer : coupe-bas, bosse 720 Hz, tonalité passe-bas */
        bq_design(&d->pre1, BQ_HP, 720.0f, 0.5f, 0); bq_design(&d->pre2, BQ_PEAK, 720.0f, 0.8f, 6);
        g = 2 + 120 * knob01(p[P_GREEN_DRV]) * knob01(p[P_GREEN_DRV]);
        bq_design(&d->t1, BQ_LP, 700.0f + 5000.0f * knob01(p[P_GREEN_TONE]), 0.707f, 0); bq_design(&d->t2, BQ_HP, 40, 0.707f, 0);
        lvl = -24 + 30 * knob01(p[P_GREEN_LVL]); break;
    case M_GOLD:    /* type Klon : large bande, aigus réglables */
        bq_design(&d->pre1, BQ_HP, 200.0f, 0.707f, 0); bq_design(&d->pre2, BQ_PEAK, 1000.0f, 0.6f, 3);
        g = 1.5f + 60 * knob01(p[P_GOLD_GAIN]) * knob01(p[P_GOLD_GAIN]);
        bq_design(&d->t1, BQ_HSH, 2500.0f, 0.707f, -9 + 18 * knob01(p[P_GOLD_TREB])); bq_design(&d->t2, BQ_LP, 9000, 0.707f, 0);
        lvl = -24 + 30 * knob01(p[P_GOLD_OUT]); break;
    case M_GRIT:    /* type RAT : gain fort, filtre passe-bas inversé */
        bq_design(&d->pre1, BQ_HP, 60.0f, 0.707f, 0); bq_design(&d->pre2, BQ_PEAK, 1500.0f, 0.7f, 4);
        g = 4 + 400 * knob01(p[P_GRIT_DIST]) * knob01(p[P_GRIT_DIST]);
        bq_design(&d->t1, BQ_LP, 12000.0f - 11000.0f * knob01(p[P_GRIT_FILT]), 0.707f, 0); bq_design(&d->t2, BQ_HP, 30, 0.707f, 0);
        lvl = -30 + 34 * knob01(p[P_GRIT_VOL]); break;
    case M_FUZZ:    /* fuzz : très saturé, asymétrique (germanium = plus doux) */
        bq_design(&d->pre1, BQ_HP, 100.0f, 0.707f, 0); bq_design(&d->pre2, BQ_THRU, 0, 0, 0);
        g = 10 + 600 * knob01(p[P_FUZZ_FUZZ]);
        d->bias = p[P_FUZZ_GERM] > 0.5f ? ONE / 4 : ONE / 10;
        bq_design(&d->t1, BQ_LP, p[P_FUZZ_GERM] > 0.5f ? 3500.0f : 6000.0f, 0.707f, 0); bq_design(&d->t2, BQ_HP, 50, 0.707f, 0);
        lvl = -30 + 34 * knob01(p[P_FUZZ_VOL]); break;
    case M_METAL:   /* distorsion moderne + EQ 3 bandes à médium réglable */
        bq_design(&d->pre1, BQ_HP, 150.0f, 0.707f, 0); bq_design(&d->pre2, BQ_PEAK, 1200.0f, 0.7f, 3);
        g = 20 + 900 * knob01(p[P_METAL_DIST]) * knob01(p[P_METAL_DIST]);
        bq_design(&d->t1, BQ_LSH, 120.0f, 0.707f, -12 + 24 * knob01(p[P_METAL_LOW]));
        bq_design(&d->t2, BQ_PEAK, p[P_METAL_MFQ], 0.9f, -12 + 24 * knob01(p[P_METAL_MID]));
        bq_design(&d->t3, BQ_HSH, 3000.0f, 0.707f, -12 + 24 * knob01(p[P_METAL_HIGH]));
        bq_design(&d->t4, BQ_LP, 7500.0f, 0.707f, 0);
        lvl = -30 + 34 * knob01(p[P_METAL_LVL]); break;
    default: {      /* amplis : gain d'entrée + EQ d'ampli (graves / médiums / aigus / présence) + master */
        float gn = knob01(p[0]), base = 8, range = 120, midf = 650, bright = 0;
        if (b->model == M_USCLEAN) { base = 1.2f; range = 18; midf = 500; bright = p[P_USCLEAN_BRIGHT] > 0.5f ? 4 : 0; }
        else if (b->model == M_CHIME) { base = 2; range = 40; midf = 900; bright = p[P_CHIME_CH] > 0.5f ? 4 : 0; }
        else if (b->model == M_BRIT) { base = 4; range = 120; midf = 700; }
        else if (b->model == M_PLEXI) { base = 3; range = 90; midf = 750; bright = p[P_PLEXI_JUMP] >= 1 ? 3 : 0; }
        else if (b->model == M_RECT) { base = 10; range = 500; midf = 500; }
        else if (b->model == M_LEAD51) { base = 8; range = 350; midf = 600; }
        else if (b->model == M_BASSAMP) { base = 1.5f; range = 30; midf = 400; }
        g = base + range * gn * gn;
        bq_design(&d->pre1, BQ_HP, b->model == M_BASSAMP ? 30.0f : 90.0f, 0.707f, 0);
        bq_design(&d->pre2, BQ_HSH, 2500.0f, 0.707f, bright);
        if (b->model == M_BASSAMP) {
            bq_design(&d->t1, BQ_LSH, 80.0f, 0.707f, -12 + 24 * knob01(p[P_BASSAMP_BASS]));
            bq_design(&d->t2, BQ_PEAK, 300.0f, 0.8f, -12 + 24 * knob01(p[P_BASSAMP_LMID]));
            bq_design(&d->t3, BQ_PEAK, 1500.0f, 0.8f, -12 + 24 * knob01(p[P_BASSAMP_HMID]));
            bq_design(&d->t4, BQ_HSH, 4000.0f, 0.707f, -12 + 24 * knob01(p[P_BASSAMP_TREB]));
            lvl = -30 + 30 * knob01(p[P_BASSAMP_MAST]);
        } else {
            bq_design(&d->t1, BQ_LSH, 120.0f, 0.707f, -10 + 20 * knob01(p[1]));                 /* bass */
            bq_design(&d->t2, BQ_PEAK, midf, 0.8f, -10 + 20 * knob01(p[2]));                     /* mid */
            bq_design(&d->t3, BQ_HSH, 2500.0f, 0.707f, -10 + 20 * knob01(p[3]));                 /* treble */
            bq_design(&d->t4, BQ_HSH, 5000.0f, 0.707f, -8 + 16 * knob01(p[4]));                  /* presence */
            lvl = -30 + 30 * knob01(p[5]);                                                        /* master */
        }
        lvl -= 6; }
    }
    d->gain = (s32)(g * 256.0f);                  /* Q8 */
    d->level = db2q16(lvl);
}
static s32 run_drive(struct st_drv *d, s32 x)
{
    s64 v;
    s32 u0, u1, y;
    x = bq_run(&d->pre1, x); x = bq_run(&d->pre2, x);
    v = ((s64)x * d->gain) >> 8;                   /* gain jusqu'à ~1000 : saturation de l'entrée du shaper à +-4 */
    x = sat_q23(v + d->bias);
    if (x > 4 * ONE) x = 4 * ONE; if (x < -4 * ONE) x = -4 * ONE;
    u0 = bq_run(&d->up2, bq_run(&d->up1, x));      /* suréchantillonnage x2 */
    u1 = bq_run(&d->up2, bq_run(&d->up1, 0));
    u0 = shaper(u0 * 2); u1 = shaper(u1 * 2);
    bq_run(&d->dn2, bq_run(&d->dn1, u0));
    y = bq_run(&d->dn2, bq_run(&d->dn1, u1));
    y = bq_run(&d->t1, y); y = bq_run(&d->t2, y); y = bq_run(&d->t3, y); y = bq_run(&d->t4, y);
    return mulq16(y, d->level);
}

/* égaliseurs, baffles, IR (provisoire = baffle), NAM (provisoire = gains + EQ), volume, send/return, boost */
static void design_eq_into(struct block *b, struct st_eq *e);
static void design_eq(struct block *b) { design_eq_into(b, &b->s.e); }
static void design_eq_into(struct block *b, struct st_eq *e)
{
    float *p = b->p;
    int i;
    e->n = 0; e->level = 65536; e->mix = 32767;
    switch (b->model) {
    case M_PEQ:
        bq_design(&e->b[0], BQ_LSH, 100, 0.707f, p[P_PEQ_LF]);
        bq_design(&e->b[1], BQ_PEAK, p[P_PEQ_LMQ], 0.9f, p[P_PEQ_LMF]);
        bq_design(&e->b[2], BQ_PEAK, p[P_PEQ_HMQ], 0.9f, p[P_PEQ_HMF]);
        bq_design(&e->b[3], BQ_HSH, 6000, 0.707f, p[P_PEQ_HF]);
        e->n = 4; e->level = db2q16(p[P_PEQ_LVL]); break;
    case M_GEQ: {
        static const float fq[7] = { 100, 200, 400, 800, 1600, 3200, 6400 };
        for (i = 0; i < 7; i++) bq_design(&e->b[i], BQ_PEAK, fq[i], 1.4f, p[P_GEQ_B1 + i]);
        e->n = 7; e->level = db2q16(p[P_GEQ_LVL]); break; }
    case M_CAB412: case M_CAB212: case M_IR: {
        int c412 = b->model != M_CAB212;
        float lc = b->model == M_IR ? p[P_IR_LC] : p[P_CAB412_LC], hc = b->model == M_IR ? p[P_IR_HC] : p[P_CAB412_HC];
        float mic = b->model == M_IR ? 0 : p[P_CAB412_MIC], pos = b->model == M_IR ? 3 : p[P_CAB412_POS];
        bq_design(&e->b[0], BQ_HP, c412 ? 75 : 90, 0.9f, 0);
        bq_design(&e->b[1], BQ_PEAK, c412 ? 110 : 130, 1.2f, c412 ? 4 : 3);
        bq_design(&e->b[2], BQ_PEAK, 420, 1.3f, -5);
        bq_design(&e->b[3], BQ_PEAK, 2400 + 300 * pos, 1.6f, 3.5f - pos * 0.4f + (mic == 2 ? 2 : 0));
        bq_design(&e->b[4], BQ_LP, (c412 ? 4800 : 5500) - (mic == 1 ? 1200 : 0), 0.541f, 0);
        bq_design(&e->b[5], BQ_LP, (c412 ? 4800 : 5500) - (mic == 1 ? 1200 : 0), 1.307f, 0);
        bq_design(&e->b[6], BQ_HP, lc, 0.707f, 0);
        bq_design(&e->b[7], BQ_LP, hc, 0.707f, 0);
        e->n = 8;
        if (b->model == M_IR) { e->level = db2q16(p[P_IR_LVL]); e->mix = pct2q15(p[P_IR_MIX]); }
        break; }
    case M_NAM:
        bq_design(&e->b[0], BQ_LSH, 150, 0.707f, p[P_NAM_BASS]);
        bq_design(&e->b[1], BQ_PEAK, 650, 0.8f, p[P_NAM_MID]);
        bq_design(&e->b[2], BQ_HSH, 2000, 0.707f, p[P_NAM_TREB]);
        e->n = 3; e->level = db2q16(p[P_NAM_IN] + p[P_NAM_OUT]); break;
    case M_BOOST:
        bq_design(&e->b[0], BQ_HSH, 1500, 0.707f, -6 + 12 * knob01(p[P_BOOST_TONE]));
        e->n = 1; e->level = db2q16(p[P_BOOST_GAIN]); break;
    case M_VOL: e->level = db2q16(p[P_VOL_LVL]); break;
    case M_FXL: e->level = db2q16(p[P_FXL_SEND] + p[P_FXL_RET]); e->mix = pct2q15(p[P_FXL_MIX]); break;
    default: break;                                                   /* pitch : non disponible (passe tel quel) */
    }
}
static s32 run_eq(struct st_eq *e, s32 x)
{
    s32 y = x;
    int i;
    for (i = 0; i < e->n; i++) y = bq_run(&e->b[i], y);
    y = mulq16(y, e->level);
    if (e->mix < 32767) y = mulq15(y, e->mix) + mulq15(x, 32767 - e->mix);
    return y;
}

/* dynamique : gate, compresseurs (calcul du gain toutes les 32 échantillons, en virgule fixe).
   engine.c n'utilise pas la FPU : log10f / powf y étaient en flottant logiciel (~20 000 cycles par calcul de gain, soit
   l'essentiel du coût d'un compresseur). Le gain est maintenant calculé en log2 / exp2 entiers (tables de 33 points
   interpolées, écart < 0,01 dB avec l'ancien calcul) ; le gate compare l'enveloppe à un seuil linéaire. */
static const s32 log2_t[33] = { 0, 2909, 5732, 8473, 11136, 13727, 16248, 18704, 21098, 23433, 25711, 27936, 30109, 32234, 34312,
    36346, 38336, 40286, 42196, 44068, 45904, 47705, 49472, 51207, 52911, 54584, 56229, 57845, 59434, 60997, 62534, 64047, 65536 };  /* log2(1 + i/32) Q16 */
static const s32 exp2n_t[33] = { 1073741824, 1050733751, 1028218693, 1006186087, 984625594, 963527098, 942880699, 922676710,
    902905651, 883558244, 864625413, 846098274, 827968132, 810226483, 792865000, 775875538, 759250125, 742980960, 727060411,
    711481005, 696235434, 681316545, 666717336, 652430958, 638450708, 624770026, 611382493, 598281827, 585461881, 572916640,
    560640218, 548626854, 536870912 };                                                                   /* 2^(-i/32) Q30 */
static s32 log2q16(u32 v)                                             /* log2(v) Q16, v > 0 */
{
    int n = 0;
    u32 m, f, i, r;
    if (v >> 16) { n += 16; m = v >> 16; } else m = v;
    if (m >> 8) { n += 8; m >>= 8; }
    if (m >> 4) { n += 4; m >>= 4; }
    if (m >> 2) { n += 2; m >>= 2; }
    if (m >> 1) n += 1;
    m = n >= 16 ? v >> (n - 16) : v << (16 - n);                      /* [1, 2) en Q16 */
    f = m - 65536; i = f >> 11; r = f & 2047;
    return (n << 16) + log2_t[i] + (s32)(((u32)(log2_t[i + 1] - log2_t[i]) * r) >> 11);
}
static s32 exp2neg_q16(s32 e)                                         /* 65536 x 2^(-e / 65536), 0 <= e < 16 x 65536 */
{
    u32 ip = (u32)e >> 16, f = (u32)e & 0xFFFF, i = f >> 11, r = f & 2047;
    s32 t = exp2n_t[i] - (s32)(((s64)(exp2n_t[i] - exp2n_t[i + 1]) * r) >> 11);
    return t >> (14 + ip);
}
#define DYN_EMAX 1044964                                              /* 96 dB en log2 Q16 (plancher de l'ancien db2q16) */
static void design_dyn(struct block *b)
{
    struct st_dyn *y = &b->s.y;
    float *p = b->p, att = 5, rel = 100, thr_db, ratio = 1, t;
    y->mix = 32767; y->level = 65536;
    if (b->model == M_GATE) { thr_db = p[P_GATE_THR]; rel = p[P_GATE_REL]; att = 1; y->floor_g = db2q16(p[P_GATE_DEPTH]); }
    else if (b->model == M_COMP) { thr_db = p[P_COMP_THR]; ratio = p[P_COMP_RATIO]; att = p[P_COMP_ATT]; rel = p[P_COMP_REL]; y->mix = pct2q15(p[P_COMP_MIX]); y->level = db2q16(p[P_COMP_LVL]); }
    else { thr_db = -10 - 4 * p[P_SQUASH_SUS]; ratio = 2 + p[P_SQUASH_SUS]; att = 1 + 3 * p[P_SQUASH_ATT]; rel = 150; y->mix = pct2q15(p[P_SQUASH_MIX]); y->level = db2q16(-12 + 2.4f * p[P_SQUASH_LVL] + 0.6f * p[P_SQUASH_SUS]); }
    t = (float)ONE * powf(10.0f, clampf(thr_db, -120.0f, 24.0f) / 20.0f);
    y->thr = t < 1.0f ? 1 : (s32)t;
    y->lthr = log2q16((u32)y->thr);
    y->kq = (s32)((1.0f - 1.0f / clampf(ratio, 1.0f, 50.0f)) * 65536.0f);
    y->att = (s32)(32768.0f * (1.0f - powf(2.718f, -1.0f / (clampf(att, 0.1f, 1000.0f) * 0.001f * FS))));
    y->rel = (s32)(32768.0f * (1.0f - powf(2.718f, -1.0f / (clampf(rel, 1.0f, 5000.0f) * 0.001f * FS))));
    if (!y->g) y->g = 65536;
}
static s32 run_dyn(struct block *b, s32 x)
{
    struct st_dyn *y = &b->s.y;
    s32 a = iabs(x), out;
    y->env += mulq15(a - y->env, a > y->env ? y->att : y->rel);
    if ((++y->cnt & 31) == 0) {                                       /* calculateur de gain, 1 500 fois / s */
        if (b->model == M_GATE) y->g = y->env < y->thr ? y->floor_g : 65536;
        else if (y->env > y->thr) {                                   /* gain (dB) = -(niveau - seuil) x (1 - 1/ratio) */
            s32 e = (s32)(((s64)(log2q16((u32)y->env) - y->lthr) * y->kq) >> 16);
            y->g = exp2neg_q16(e > DYN_EMAX ? DYN_EMAX : e);
        } else y->g = 65536;
    }
    out = mulq16(mulq16(x, y->g), y->level);
    if (y->mix < 32767) out = mulq15(out, y->mix) + mulq15(x, 32767 - y->mix);
    return out;
}

/* modulations : chorus / flanger / vibe / rotary (ligne modulée), phaser (passe-tout), trémolo */
#define MOD_LEN 2048u
static void design_mod(struct block *b)
{
    struct st_mod *m = &b->s.m;
    float *p = b->p;
    if (!m->buf && b->model != M_TREM && b->model != M_PHASER) m->buf = pool_alloc(MOD_LEN * 4);
    m->fb = 0; m->mix = 16384; m->dry = 32767; m->nst = 0; m->kind = 0;
    bq_design(&m->tone, BQ_THRU, 0, 0, 0);
    switch (b->model) {
    case M_CHORUS:  m->inc = hz2inc(p[P_CHORUS_RATE]); m->base = 240 << 16; m->depth = (s32)(p[P_CHORUS_DEPTH] * 1.92f) << 16; m->mix = pct2q15(p[P_CHORUS_MIX]);
        bq_design(&m->tone, BQ_LP, 2000 + 1200 * p[P_CHORUS_TONE], 0.707f, 0); break;
    case M_FLANGER: m->inc = hz2inc(p[P_FLANGER_RATE]); m->base = 24 << 16; m->depth = (s32)(p[P_FLANGER_DEPTH] * 1.9f) << 16; m->mix = pct2q15(p[P_FLANGER_MIX]);
        m->fb = (s32)(clampf(p[P_FLANGER_FB], -95, 95) * 327.67f); break;
    case M_VIBE:    m->inc = hz2inc(0.5f + 0.9f * p[P_VIBE_SPEED]); m->base = 96 << 16; m->depth = (s32)(16 * p[P_VIBE_INT]) << 16;
        m->mix = p[P_VIBE_MODE] >= 1 ? 32767 : 16384; m->dry = p[P_VIBE_MODE] >= 1 ? 0 : 32767; break;
    case M_ROTARY:  m->inc = hz2inc(p[P_ROTARY_SPEED] >= 1 ? 6.7f : 0.8f); m->base = 64 << 16; m->depth = 48 << 16; m->mix = pct2q15(p[P_ROTARY_MIX]);
        m->kind = 2; m->shape = (s32)(p[P_ROTARY_HORN] * 3000); break;
    case M_PHASER:  m->kind = 1; m->inc = hz2inc(p[P_PHASER_RATE]); m->depth = pct2q15(p[P_PHASER_DEPTH]); m->fb = (s32)(clampf(p[P_PHASER_FB], 0, 95) * 327.67f);
        m->nst = p[P_PHASER_ST] >= 2 ? 12 : (p[P_PHASER_ST] >= 1 ? 8 : 4); m->mix = 16384; break;
    case M_TREM:    m->kind = 3; m->inc = hz2inc(p[P_TREM_RATE]); m->depth = pct2q15(p[P_TREM_DEPTH]); m->shape = (s32)p[P_TREM_SHAPE]; break;
    }
    if (m->dry == 32767 && m->kind == 0) m->dry = 32767 - m->mix / 2;
}
static s32 run_mod(struct st_mod *m, s32 x)
{
    s32 lfo, y;
    m->ph += m->inc;
    lfo = lfo_sine(m->ph);                                             /* -32767..32767 */
    if (m->kind == 3) {                                                /* trémolo */
        s32 t = (s32)(m->ph >> 16), tri = t < 32768 ? 2 * t - 32767 : 2 * (65535 - t) - 32767;
        s32 l = m->shape == 2 ? (lfo >= 0 ? 32767 : -32767) : (m->shape == 1 ? tri : lfo);
        s32 g = 32767 - mulq15((l + 32767) >> 1, m->depth);
        return mulq15(x, g);
    }
    if (m->kind == 1) {                                                /* phaser : passe-tout du 1er ordre, coefficient modulé */
        s32 a = 4000 + mulq15((lfo + 32767) >> 1, 20000 + m->depth / 2), v = x + mulq15(m->fbv, m->fb);
        int i;
        for (i = 0; i < m->nst; i++) {                                 /* y = -a*v + z ; z = v + a*y  (a en Q15) */
            s32 yy = m->apz[i] - mulq15(v, a);
            m->apz[i] = v + mulq15(yy, a);
            v = yy;
        }
        m->fbv = v;
        return mulq15(x, 32767 - m->mix / 2) + mulq15(v, m->mix);
    }
    if (!m->buf) return x;
    {                                                                  /* ligne à retard modulée, interpolation linéaire */
        u32 dpos = (u32)(m->base + mulq15(m->depth, (lfo + 32767) >> 1)), rd = (m->wr << 16) - dpos;
        u32 i0 = (rd >> 16) & (MOD_LEN - 1), i1 = (i0 + 1) & (MOD_LEN - 1), fr = rd & 0xFFFF;
        s32 a = m->buf[i0], b = m->buf[i1], wet = a + (s32)(((s64)(b - a) * fr) >> 16);
        m->buf[m->wr] = x + mulq15(wet, m->fb);
        m->wr = (m->wr + 1) & (MOD_LEN - 1);
        wet = bq_run(&m->tone, wet);
        if (m->kind == 2) wet = mulq15(wet, 32767 - mulq15((lfo + 32767) >> 1, m->shape)); /* rotary : modulation d'amplitude en plus */
        y = mulq15(x, m->dry) + mulq15(wet, m->mix);
        return y;
    }
}

/* délais : ligne 16 bits dans la réserve, filtres dans la boucle, modulation (analog / tape) */
static void design_dly(struct block *b)
{
    struct st_dly *l = &b->s.l;
    float *p = b->p, tms = p[0], hc = 8000, lc = 60;
    u32 need;
    if (!l->buf && !dly_defer) {                                       /* taille max du modèle, dans la limite de la réserve */
        float maxms = b->model == M_ANALOG ? 600 : (b->model == M_TAPE ? 1200 : 2000);
        need = (u32)(maxms * 48.0f) + 64;
        if (dly_share > 1 && need * 2 > engine_mem_free() / dly_share) need = engine_mem_free() / dly_share / 2;   /* plusieurs délais : partage */
        if (need * 2 > pool_largest()) need = pool_largest() / 2;
        if (need > 256) { l->buf = pool_alloc(need * 2); l->len = l->buf ? need : 0; }
    }
    l->d = (u32)(clampf(tms, 1, 2000) * 48.0f);
    if (l->len && l->d >= l->len) l->d = l->len - 1;
    l->fb = pct2q15(p[1]); l->mix = pct2q15(p[2]); l->dry = 32767; l->mod = 0; l->inc = 0;
    if (b->model == M_DDL) hc = p[P_DDL_HC];
    else if (b->model == M_ANALOG) { hc = 2600; lc = 150; l->mod = (u32)(p[P_ANALOG_MOD] * 3); l->inc = hz2inc(0.6f); }
    else if (b->model == M_TAPE) { hc = 4500 - 250 * p[P_TAPE_AGE]; lc = 120; l->mod = (u32)(p[P_TAPE_WOW] * 6); l->inc = hz2inc(0.9f); }
    else if (b->model == M_PINGPONG) hc = 9000;
    else if (b->model == M_REVERSE) hc = 6000;
    if (l->fb > 32000) l->fb = 32000;
    bq_design(&l->lp, BQ_LP, hc, 0.707f, 0); bq_design(&l->hp, BQ_HP, lc, 0.707f, 0);
}
static s32 run_dly(struct st_dly *l, s32 x)
{
    s32 d, f;
    u32 rd, dd = l->d;
    if (!l->buf || !l->len) return x;
    if (l->mod) { l->ph += l->inc; dd += (u32)((lfo_sine(l->ph) + 32767) * (s32)l->mod >> 15); if (dd >= l->len) dd = l->len - 1; }
    rd = l->wr >= dd ? l->wr - dd : l->wr + l->len - dd;
    d = (s32)l->buf[rd] << 8;
    f = bq_run(&l->hp, bq_run(&l->lp, d));
    { s32 w = (x + mulq15(f, l->fb)) >> 8; l->buf[l->wr] = (s16)(w > 32767 ? 32767 : (w < -32768 ? -32768 : w)); }
    if (++l->wr >= l->len) l->wr = 0;
    return x + mulq15(f, l->mix);
}

/* réverbes : Freeverb mono (8 peignes + 4 passe-tout, Q23 32 bits), tailles par modèle, pré-délai, coupe-bas, tonalité */
static const u16 rv_base[RV_N] = { 1215, 1293, 1390, 1476, 1548, 1623, 1695, 1760, 605, 480, 371, 245 };
static void design_rev(struct block *b)
{
    struct st_rev *r = &b->s.r;
    float *p = b->p, scale = 1, decay = 2, tone = 5, lc = 100, pre = 20, mix = 30, fbk;
    int i;
    if (b->model == M_ROOM) scale = 0.55f; else if (b->model == M_PLATE) scale = 0.8f; else if (b->model == M_SPRING) scale = 0.4f;
    if (b->model == M_SPRING) { decay = 0.5f + 0.35f * p[P_SPRING_DWELL]; tone = p[P_SPRING_TONE]; mix = p[P_SPRING_MIX]; pre = 8; lc = 150; }
    else { decay = p[P_ROOM_DECAY]; pre = p[P_ROOM_PRE]; mix = p[P_ROOM_MIX]; tone = p[P_ROOM_TONE]; lc = p[P_ROOM_LC]; }
    if (!r->line[0]) {
        for (i = 0; i < RV_N; i++) {
            u32 n = (u32)(rv_base[i] * scale);
            r->line[i] = pool_alloc(n * 4);
            r->len[i] = r->line[i] ? (u16)n : 0;
        }
        r->plen = 12000;                                               /* pré-délai max 250 ms */
        r->pre = pool_alloc(r->plen * 2);
        if (!r->pre) r->plen = 0;
    }
    if (!r->xb) { r->xb = pool_alloc(2 * RV_B * 4); r->wb = r->xb ? r->xb + RV_B : 0; r->bp = 0; }
    r->nlines = 0;
    for (i = 0; i < RV_N; i++) if (r->line[i] && r->len[i]) r->nlines++;
    /* rétroaction des peignes d'après le temps de décroissance (RT60) : g = 10^(-3 * longueur / (RT60 * fs)) */
    fbk = powf(10.0f, -3.0f * (float)(rv_base[3] * scale) / (clampf(decay, 0.1f, 20.0f) * FS));
    r->fbk = (s32)(clampf(fbk, 0.2f, 0.985f) * 32767.0f);
    r->damp = (s32)((0.05f + 0.07f * (10 - clampf(tone, 0, 10))) * 32767.0f);
    r->mix = pct2q15(mix); r->dry = 32767;
    r->pd = (u32)(clampf(pre, 0, 250) * 48.0f); if (r->plen && r->pd >= r->plen) r->pd = r->plen - 1;
    r->pd = r->pd >= RV_B ? r->pd - RV_B : 0;                          /* le calcul par blocs ajoute RV_B échantillons */
    bq_design(&r->lc, BQ_HP, lc, 0.707f, 0);
    bq_design(&r->tone, BQ_LP, 3000 + 1100 * clampf(tone, 0, 10), 0.707f, 0);
}
/* Partie humide d'un bloc de RV_B échantillons : xb (entrées) -> wb (sortie humide). Chaque ligne est parcourue sur tout
   le bloc d'un coup (index, filtre et coefficients en registres, rebouclage traité par tranches contiguës, plus de test
   par échantillon). Mêmes opérations entières, dans le même ordre pour chaque ligne, que l'ancien calcul échantillon par
   échantillon : sortie identique au bit près, décalée de RV_B (retiré du pré-délai dans design_rev). */
static void rev_block(struct st_rev *r)
{
    s32 *in = r->xb, *out = r->wb;
    const s32 damp = r->damp, ndamp = 32767 - r->damp, fbk = r->fbk;
    int k, n;
    {   /* coupe-bas, pré-délai, 0,04 */
        struct bq lc = r->lc;
        u32 pwr = r->pwr, pd = r->pd, plen = r->plen;
        s16 *pre = r->pre;
        for (n = 0; n < RV_B; n++) {
            s32 v = bq_run(&lc, in[n]);
            if (plen) {
                u32 rd = pwr >= pd ? pwr - pd : pwr + plen - pd;
                s32 w = v >> 8;
                pre[pwr] = (s16)(w > 32767 ? 32767 : (w < -32768 ? -32768 : w));
                v = (s32)pre[rd] << 8;
                if (++pwr >= plen) pwr = 0;
            }
            in[n] = mulq15(v, 1311);
            out[n] = 0;
        }
        r->lc = lc; r->pwr = pwr;
    }
    for (k = 0; k < 8; k++) {                                          /* 8 peignes amortis, sommés dans out */
        s32 *b = r->line[k], f = r->filt[k];
        u32 i = r->idx[k], len = r->len[k];
        if (!b || !len) continue;
        for (n = 0; n < RV_B; ) {
            s32 *p = b + i, *pi = in + n, *po = out + n;
            int c = (int)(len - i), j;
            if (c > RV_B - n) c = RV_B - n;
            for (j = 0; j < c; j++) {
                s32 o = p[j];
                f = mulq15(o, ndamp) + mulq15(f, damp);
                p[j] = pi[j] + mulq15(f, fbk);
                po[j] += o;
            }
            n += c; i += (u32)c;
            if (i >= len) i = 0;
        }
        r->filt[k] = f; r->idx[k] = (u16)i;
    }
    for (k = 8; k < RV_N; k++) {                                       /* 4 passe-tout en série, en place dans out */
        s32 *b = r->line[k];
        u32 i = r->idx[k], len = r->len[k];
        if (!b || !len) continue;
        for (n = 0; n < RV_B; ) {
            s32 *p = b + i, *po = out + n;
            int c = (int)(len - i), j;
            if (c > RV_B - n) c = RV_B - n;
            for (j = 0; j < c; j++) {
                s32 o = p[j], y = po[j];
                p[j] = y + (o >> 1);
                po[j] = o - y;
            }
            n += c; i += (u32)c;
            if (i >= len) i = 0;
        }
        r->idx[k] = (u16)i;
    }
    {
        struct bq tone = r->tone;
        for (n = 0; n < RV_B; n++) out[n] = bq_run(&tone, out[n]);
        r->tone = tone;
    }
}
static s32 run_rev(struct st_rev *r, s32 x)
{
    s32 y;
    if (!r->xb) return x;
    y = r->wb[r->bp];                                                  /* humide du bloc précédent */
    r->xb[r->bp] = x;
    if (++r->bp >= RV_B) { r->bp = 0; rev_block(r); }
    return mulq15(x, r->dry) + mulq15(y, r->mix);
}

/* pitch générique : décaleur à ligne rotative (2 lectures croisées en triangle par voix), jusqu'à 3 voix */
static void pit_voice(struct st_pit *t, float semis, float gain)
{
    float ratio = powf(2.0f, semis / 12.0f);
    if (t->nv >= 3 || gain <= 0.001f) return;
    t->step[t->nv] = (s32)((1.0f - ratio) * 65536.0f);
    t->g[t->nv] = (s32)(clampf(gain, 0, 1) * 32767.0f);
    t->nv++;
}
static void design_pit(struct block *b)
{
    struct st_pit *t = &b->s.t;
    float *p = b->p;
    static const float iv[5] = { 4, 5, 7, 9, 12 };                     /* 3ce, 4te, 5te, 6te, octave (générique, sans gamme) */
    if (!t->buf) t->buf = pool_alloc(PIT_LEN * 2);
    t->nv = 0; t->dry = 32767;
    if (b->model == M_OCTAVE) {
        pit_voice(t, -12, p[P_OCTAVE_O1] / 100); pit_voice(t, -24, p[P_OCTAVE_O2] / 100); pit_voice(t, 12, p[P_OCTAVE_UP] / 100);
        t->dry = pct2q15(p[P_OCTAVE_DRY]);
    } else if (b->model == M_SHIFT) {
        float mx = p[P_SHIFT_MIX] / 100;
        pit_voice(t, p[P_SHIFT_SEMI] + p[P_SHIFT_CENT] / 100, mx); t->dry = (s32)((1 - mx) * 32767);
    } else {
        int k = (int)p[P_HARM_IV]; float mx = p[P_HARM_MIX] / 100;
        pit_voice(t, iv[k < 0 ? 0 : (k > 4 ? 4 : k)], mx); t->dry = (s32)((1 - mx * 0.5f) * 32767);
    }
}
static s32 run_pit(struct st_pit *t, s32 x)
{
    s32 out = mulq15(x, t->dry);
    int v;
    if (!t->buf) return x;
    { s32 w = x >> 8; t->buf[t->wr] = (s16)(w > 32767 ? 32767 : (w < -32768 ? -32768 : w)); }
    for (v = 0; v < t->nv; v++) {
        s32 ph = t->ph[v] + t->step[v], acc = 0;
        int k;
        const s32 W16 = (s32)(PIT_W << 16);
        if (ph < 0) ph += W16; else if (ph >= W16) ph -= W16;
        t->ph[v] = ph;
        for (k = 0; k < 2; k++) {                                        /* 2 lectures décalées d'une demi-fenêtre */
            s32 d = ph + k * (W16 / 2), tri, a, bb;
            u32 rd, i0, fr;
            if (d >= W16) d -= W16;
            {   /* fenêtre triangulaire 0..32767 sur PIT_W = 1200 échantillons : 32767 / 600 ~ 3495 / 64 */
                s32 di = d >> 16;
                tri = ((di < (s32)PIT_W / 2 ? di : (s32)PIT_W - di) * 3495) >> 6;
            }
            rd = (t->wr << 16) - (u32)d - (2u << 16);
            i0 = (rd >> 16) & (PIT_LEN - 1); fr = rd & 0xFFFF;
            a = t->buf[i0]; bb = t->buf[(i0 + 1) & (PIT_LEN - 1)];
            acc += mulq15((a + (s32)(((s64)(bb - a) * fr) >> 16)) << 8, tri);
        }
        out += mulq15(acc, t->g[v]);
    }
    t->wr = (t->wr + 1) & (PIT_LEN - 1);
    return out;
}

/* ---- FFT complexe radix 2 en virgule fixe (facteurs Q30) ---- */
#define GFXBSS2 __attribute__((section(".gfxbss")))                 /* tampons de travail : région GFX (0x1C40000) */
static s32 tw_c[IR_N / 2] GFXBSS2, tw_s[IR_N / 2] GFXBSS2;
static u8 brev[IR_N] GFXBSS2;
static int tw_ok;
static s32 fre[IR_N] GFXBSS2, fim[IR_N] GFXBSS2;
#define IR_S ((IR_N / 2 + 1) * 2)                                       /* mots par spectre (129 bins complexes) */
static void fft_init(void)
{
    int k, j, i;
    if (tw_ok) return;
    for (k = 0; k < IR_N / 2; k++) { tw_c[k] = (s32)(cosf(2 * PI_F * k / IR_N) * 1073741824.0f); tw_s[k] = (s32)(-sinf(2 * PI_F * k / IR_N) * 1073741824.0f); }
    for (i = 0; i < IR_N; i++) { for (j = 0, k = 0; k < 8; k++) j |= ((i >> k) & 1) << (7 - k); brev[i] = (u8)j; }
    tw_ok = 1;
}
/* inv = 0 : directe, divisée par 2 à chaque étage si scale ; inv = 1 : inverse sans mise à l'échelle */
/* inv et scale sont des constantes à chaque appel : le compilateur produit 2 versions sans test dans la boucle
   (un saut pris coûte ~7 cycles sur ce cœur). Étages 1 et 2 sans multiplication (facteurs 1 et -j). */
static inline __attribute__((always_inline)) void fft_core(const int inv, const int scale, const int n)
{
    int i, j, k, len;
    const int sh = scale ? 1 : 0;
    for (i = 1; i < n; i++) {                                            /* permutation bit-inverse (table 8 bits ; 7 bits = >> 1) */
        j = n == IR_N ? brev[i] : brev[i] >> 1;
        if (i < j) { s32 t = fre[i]; fre[i] = fre[j]; fre[j] = t; t = fim[i]; fim[i] = fim[j]; fim[j] = t; }
    }
    for (i = 0; i < n; i += 4) {                                         /* étages 1 + 2 fusionnés (radix 4) */
        s32 *r = fre + i, *m = fim + i;
        s32 a0r = r[0] + r[1], a0i = m[0] + m[1], a1r = r[0] - r[1], a1i = m[0] - m[1];
        s32 b0r = r[2] + r[3], b0i = m[2] + m[3], b1r = r[2] - r[3], b1i = m[2] - m[3];
        s32 tr = inv ? -b1i : b1i, ti = inv ? b1r : -b1r;                /* b1 x (-j) en directe, x (+j) en inverse */
        if (scale) { a0r >>= 1; a0i >>= 1; a1r >>= 1; a1i >>= 1; b0r >>= 1; b0i >>= 1; tr >>= 1; ti >>= 1; }
        r[0] = (a0r + b0r) >> sh; m[0] = (a0i + b0i) >> sh; r[2] = (a0r - b0r) >> sh; m[2] = (a0i - b0i) >> sh;
        r[1] = (a1r + tr) >> sh;  m[1] = (a1i + ti) >> sh;  r[3] = (a1r - tr) >> sh;  m[3] = (a1i - ti) >> sh;
    }
    for (len = 8; len <= n; len <<= 1) {
        const int half = len >> 1, step = IR_N / len;                    /* facteur e^(-2 pi i k / len) = table de 256 au pas 256 / len */
        for (k = 0; k < half; k++) {                                     /* facteur chargé une fois pour tous les groupes */
            const s32 wr = tw_c[k * step], wi = inv ? -tw_s[k * step] : tw_s[k * step];
            s32 *ra = fre + k, *ia = fim + k;
            for (i = 0; i < n; i += len, ra += len, ia += len) {
                const s32 br = ra[half], bi = ia[half], ur = ra[0], ui = ia[0];
                const s32 xr = (s32)(((s64)br * wr - (s64)bi * wi) >> 30), xi = (s32)(((s64)br * wi + (s64)bi * wr) >> 30);
                ra[0] = (ur + xr) >> sh; ia[0] = (ui + xi) >> sh; ra[half] = (ur - xr) >> sh; ia[half] = (ui - xi) >> sh;
            }
        }
    }
}
static void fft(int inv, int scale)                                  /* complexe 256 points (spectres de l'IR, au réglage) */
{
    if (inv) fft_core(1, 0, IR_N);
    else if (scale) fft_core(0, 1, IR_N);
    else fft_core(0, 0, IR_N);
}
#define IRAM __attribute__((section(".sram")))                     /* code exécuté en RAM (pas de défauts de cache flash) */
static IRAM void fft128_fwd_scaled(void) { fft_core(0, 1, IR_N / 2); }    /* complexe 128 points (signal réel de 256, en temps réel) */
static IRAM void fft128_inv(void) { fft_core(1, 0, IR_N / 2); }
static s32 gre[IR_N / 2 + 1] GFXBSS2, gim[IR_N / 2 + 1] GFXBSS2;
const short *proto_ir_data(int s);
/* Charge l'IR h (int16, P partitions de 128 au plus) dans le cœur de convolution. Les filtres f[0..nf-1] (Low/High Cut,
   couleurs) sont appliqués UNE fois à l'IR, au réglage, et donc intégrés à ses spectres : aucun filtre par échantillon
   (gain mesuré : ~3 % d'un cœur par bloc). id = identifiant du contenu + réglages (cache : recalcul seulement s'il change). */
static u32 bq_hash(const struct bq *b) { u32 h = 0; int i; for (i = 0; i < 5; i++) h = h * 2654435761u + (u32)b->c[i]; return h; }
static void ir_core_load(struct st_ir_core *r, const short *h, u32 id, int P, struct bq *const *f, int nf)
{
    int q, k, i;
    s32 *t;
    if (!r->H) {
        r->H = pool_alloc(P * (IR_N / 2 + 1) * 8); r->F = pool_alloc(2 * P * IR_S * 4);                                /* ligne à retard doublée */
        r->xin = pool_alloc(IR_N * 4); r->outq = pool_alloc(IR_B * 4);
        if (!r->H || !r->F || !r->xin || !r->outq) { r->np = 0; r->H = 0; return; }
        r->slot = -1; r->P = P;
    }
    for (i = 0; i < nf; i++) id = id * 31u + bq_hash(f[i]);
    if ((u32)r->slot == id && r->np) return;
    fft_init();
    t = r->F;                                                            /* IR filtrée (P x 128 s32), dans la ligne à retard libre */
    {
        struct bq w[4];
        for (i = 0; i < nf && i < 4; i++) { w[i] = *f[i]; w[i].z[0] = w[i].z[1] = w[i].z[2] = w[i].z[3] = 0; }
        for (k = 0; k < r->P * IR_B; k++) {
            s32 y = (s32)h[k] << 8;                                      /* Q23 */
            for (i = 0; i < nf && i < 4; i++) y = bq_run(&w[i], y);
            t[k] = (y + 128) >> 8;                                       /* unités int16 (peut dépasser après un plateau positif) */
        }
    }
    {   /* queue inaudible coupée : on garde les partitions jusqu'à la dernière dont l'énergie dépasse -60 dB du total */
        s64 tot = 0, part[IR_P];
        for (q = 0; q < r->P; q++) { part[q] = 0; for (i = 0; i < IR_B; i++) { s32 v = t[q * IR_B + i]; part[q] += (s64)v * v; } tot += part[q]; }
        r->np = 1;
        for (q = r->P - 1; q > 0; q--) if (part[q] * 1000000 > tot) { r->np = q + 1; break; }
    }
    for (q = 0; q < r->np; q++) {                                        /* spectres des partitions (non mis à l'échelle, unités Q15) */
        s32 *Hq = r->H + q * (IR_N / 2 + 1) * 2;
        for (k = 0; k < IR_N; k++) { fre[k] = k < IR_B ? t[q * IR_B + k] : 0; fim[k] = 0; }
        fft(0, 0);
        for (k = 0; k <= IR_N / 2; k++) { Hq[2 * k] = fre[k]; Hq[2 * k + 1] = fim[k]; }
    }
    for (k = 0; k < 2 * r->P * IR_S; k++) r->F[k] = 0;                  /* ligne à retard remise à zéro */
    for (k = 0; k < IR_N; k++) r->xin[k] = 0;
    for (k = 0; k < IR_B; k++) r->outq[k] = 0;
    r->slot = (int)id; r->pos = 0; r->head = 0;
}
static void design_ir(struct block *b)
{
    struct st_ir_core *r = &b->s.i.c;
    float *p = b->p;
    int slot = (int)p[P_IR_SLOT];
    const short *h = proto_ir_data(slot);
    struct bq *f[2];
    r->level = db2q16(p[P_IR_LVL]); r->mix = pct2q15(p[P_IR_MIX]);
    bq_design(&r->lc, BQ_HP, p[P_IR_LC], 0.707f, 0); bq_design(&r->hc, BQ_LP, p[P_IR_HC], 0.707f, 0);
    design_eq_into(b, &b->s.i.fb);
    if (!h) { r->np = 0; r->slot = -1; return; }                         /* emplacement vide : baffle simulé */
    f[0] = &r->lc; f[1] = &r->hc;
    ir_core_load(r, h, 0x49520000u + (u32)slot, IR_P, f, 2);
}
/* Cabs d'usine (blocs « 4x12 V30 » et « Combo ») : vraies IR de la zone flash 0xF3000 (gen_cabs.py, third_party/irs).
   Paramètres : Baffle (choix de l'IR), Position (brillance, plateau 2,5 kHz), Distance (effet de proximité, plateau 150 Hz),
   Low/High Cut ; tous intégrés à l'IR. Sans zone de cabs (pédale pas encore mise à jour) : ancien baffle simulé par filtres. */
const short *proto_cab_data(int k);
#define CAB_LVL_DB (-3.0f)                                               /* niveau moyen proche de l'ancien baffle simulé */
static int cab_index(struct block *b)
{
    int v = (int)(b->p[P_CAB412_MIC] + 0.5f);
    if (b->model == M_CAB412) return v < 0 ? 0 : v > 4 ? 4 : v;          /* 0..4 : V30 SM57 A/B, V30 Dyn 75, V30 + G12F, 4x12 fermé */
    return 5 + (v < 0 ? 0 : v > 5 ? 5 : v);                             /* Combo 5..10 : 2x12 ouvert/fermé/mi-ouvert, 1x12 ouvert/fermé, 4x10 */
}
static void design_cab(struct block *b)
{
    struct st_ir_core *r = &b->s.i.c;
    struct st_eq *e = &b->s.i.fb;
    float *p = b->p;
    int k = cab_index(b);
    const short *h = proto_cab_data(k);
    struct bq *f[4];
    if (!h) { design_eq_into(b, e); r->np = 0; r->slot = -1; return; }
    r->level = db2q16(CAB_LVL_DB); r->mix = 32767;
    bq_design(&r->lc, BQ_HP, p[P_CAB412_LC], 0.707f, 0); bq_design(&r->hc, BQ_LP, p[P_CAB412_HC], 0.707f, 0);
    bq_design(&e->b[0], BQ_HSH, 2500.0f, 0.707f, (4.0f - p[P_CAB412_POS]) * 1.2f);
    bq_design(&e->b[1], BQ_LSH, 150.0f, 0.707f, (2.0f - p[P_CAB412_DIST]) * 1.0f);
    f[0] = &r->lc; f[1] = &r->hc; f[2] = &e->b[0]; f[3] = &e->b[1];
    ir_core_load(r, h, 0x43410000u + (u32)k, CAB_P, f, 4);
}static IRAM void ir_block(struct st_ir_core *r)
{
    int q, k;
    s32 *X;
    /* FFT réelle de 256 points par une FFT complexe de 128 : z[n] = x[2n] + j x[2n+1] */
    for (k = 0; k < IR_N / 2; k++) { fre[k] = r->xin[2 * k]; fim[k] = r->xin[2 * k + 1]; }
    fft128_fwd_scaled();                                                 /* Z / 128 */
    r->head = r->head ? r->head - 1 : (u32)r->P - 1;                               /* ligne à retard fréquentielle */
    {   /* X[k] / 256 = ((Z[k] + Z*[128-k]) + W^k (Z[k] - Z*[128-k]) / j) / 4 ; écrit deux fois (head et head + P) :
           les partitions head..head+np-1 sont alors contiguës, sans rebouclage */
        s32 *X2;
        X = r->F + r->head * IR_S; X2 = X + r->P * IR_S;
        for (k = 0; k <= IR_N / 2; k++) {
            const int a = k & (IR_N / 2 - 1), b = (IR_N / 2 - k) & (IR_N / 2 - 1);
            const s32 zr = fre[a], zi = fim[a], cr = fre[b], ci = -fim[b];
            const s32 ar = zr + cr, ai = zi + ci, dr = zr - cr, di = zi - ci;     /* d / j = (di, -dr) */
            const s32 wr = k < IR_N / 2 ? tw_c[k] : -1073741824, wi = k < IR_N / 2 ? tw_s[k] : 0;
            const s32 tr = (s32)(((s64)di * wr + (s64)dr * wi) >> 30), ti = (s32)(((s64)di * wi - (s64)dr * wr) >> 30);
            X[2 * k] = X2[2 * k] = (ar + tr) >> 2; X[2 * k + 1] = X2[2 * k + 1] = (ai + ti) >> 2;
        }
    }
    {   /* fréquence à l'extérieur, partitions à l'intérieur : les 2 accumulateurs 64 bits restent en registres */
        const int np = r->np;
        const s32 *xb = r->F + r->head * IR_S, *hb = r->H;
        for (k = 0; k <= IR_N / 2; k++, xb += 2, hb += 2) {
            const s32 *x = xb, *hh = hb;
            s64 ar = 0, ai = 0;
            for (q = 0; q < np; q++, x += IR_S, hh += IR_S) {
                const s32 x0 = x[0], x1 = x[1], h0 = hh[0], h1 = hh[1];
                ar += (s64)x0 * h0; ai += (s64)x0 * h1;
                ar -= (s64)x1 * h1; ai += (s64)x1 * h0;
            }
            gre[k] = (s32)(ar >> 15); gim[k] = (s32)(ai >> 15);
        }
    }
    /* IFFT réelle par une IFFT complexe de 128 : Z[k] = (Y[k] + Y*[128-k]) + j W^-k (Y[k] - Y*[128-k]) ; z[n] = y[2n] + j y[2n+1] */
    for (k = 0; k < IR_N / 2; k++) {
        const s32 yr = gre[k], yi = gim[k], cr = gre[IR_N / 2 - k], ci = -gim[IR_N / 2 - k];
        const s32 dr = yr - cr, di = yi - ci, wr = tw_c[k], wi = -tw_s[k];        /* W^-k */
        const s32 er = (s32)(((s64)dr * wr - (s64)di * wi) >> 30), ei = (s32)(((s64)dr * wi + (s64)di * wr) >> 30);
        fre[k] = yr + cr - ei; fim[k] = yi + ci + er;                    /* + j e */
    }
    fft128_inv();                                                        /* y = IFFT non mis à l'échelle de X'H = sortie réelle */
    for (k = 0; k < IR_B / 2; k++) { r->outq[2 * k] = fre[IR_B / 2 + k]; r->outq[2 * k + 1] = fim[IR_B / 2 + k]; }
    for (k = 0; k < IR_B; k++) r->xin[k] = r->xin[IR_B + k];             /* moitié ancienne <- nouvelle */
}
static s32 run_ir(struct block *b, s32 x)
{
    struct st_ir_core *r = &b->s.i.c;
    s32 y, dry;
    if (!r->np) return run_eq(&b->s.i.fb, x);
    dry = r->xin[r->pos];                                                /* sec retardé de 128 comme la convolution */
    r->xin[IR_B + r->pos] = x;
    y = r->outq[r->pos];
    if (++r->pos >= IR_B) { r->pos = 0; ir_block(r); }
    y = mulq16(y, r->level);                                             /* filtres déjà intégrés à l'IR (ir_core_load) */
    if (r->mix < 32767) y = mulq15(y, r->mix) + mulq15(dry, 32767 - r->mix);
    return y;
}

/* test (commande 0x1B) : impulsion 2^22 dans la convolution seule (sans filtres ni mélange) de l'IR de l'emplacement slot ;
   out[i] = sortie à n = 128 + 64 i (attendu : h[64 i] * 128). Remet le moteur à zéro. */
static void design(struct block *b);
int engine_ir_test(int slot, s32 *out)
{
    struct block *b = &grid[0][0];
    struct st_ir_core *r;
    int n;
    engine_clear();
    if (engine_block_set_force(0, 0, M_IR) != 0) return -1;
    b->p[P_IR_SLOT] = (float)slot; design(b);
    r = &b->s.i.c;
    if (!r->np) return -2;
    for (n = 0; n < 128 + 64 * 32; n++) {
        s32 y;
        r->xin[IR_B + r->pos] = n == 0 ? (1 << 22) : 0;
        y = r->outq[r->pos];
        if (++r->pos >= IR_B) { r->pos = 0; ir_block(r); }
        if (n >= 128 && ((n - 128) & 63) == 0) out[(n - 128) >> 6] = y;
    }
    n = r->np;
    engine_clear();
    return n;
}

/* historiques du NAM brut : un morceau par couche, du plus grand au plus petit (remplit les deux zones de la réserve) ;
   0 si tout est alloué */
static int nam_hist_alloc(s32 **h)
{
    int done[23] = { 0 }, k, li;
    for (k = 0; k < 23; k++) {
        int best = -1;
        for (li = 0; li < 23; li++) if (!done[li] && (best < 0 || nam_hist_bytes(li) > nam_hist_bytes(best))) best = li;
        done[best] = 1;
        h[best] = (s32 *)pool_alloc(nam_hist_bytes(best));
        if (!h[best]) return -1;
    }
    return 0;
}
/* NAM A2 Lite : capture de l'emplacement choisi ; gains d'entrée / sortie et EQ 3 bandes autour */
static void design_nam(struct block *b)
{
    struct st_nam *s = &b->s.n;
    float *p = b->p;
    int slot = (int)p[P_NAM_SLOT], len = 0;
    const u8 *blob = proto_nam_blob(slot, &len);
    int is_a2l = blob && len >= 4 && blob[0] == 'A' && blob[1] == '2' && blob[2] == 'L' && blob[3] == '1';
    int is_amx = blob && len == 6204 && blob[0] == 'A' && blob[1] == 'M' && (blob[2] == '2' || blob[2] == '3');
    int kind = is_a2l ? 1 : (is_amx ? 2 : 0);
    struct st_eq *e = &s->eq;
    engine_sync();                                                       /* le 2e cœur ne doit pas lire l'état pendant qu'on le change */
    bq_design(&e->b[0], BQ_LSH, 150, 0.707f, p[P_NAM_BASS]);
    bq_design(&e->b[1], BQ_PEAK, 650, 0.8f, p[P_NAM_MID]);
    bq_design(&e->b[2], BQ_HSH, 2000, 0.707f, p[P_NAM_TREB]);
    e->n = 3; e->mix = 32767;
    if (!blob) { s->slot = -1; e->level = db2q16(p[P_NAM_IN] + p[P_NAM_OUT]); return; }   /* emplacement vide */
    e->level = 65536;
    {
        u32 need = nam_mem_size();
        if (is_a2l) { u32 an = a2l_mem_size(blob, (u32)len); if (an > need) need = an; }
        if (is_amx) { u32 an = amx_mem_size(); if (an > need) need = an; }
        if (!s->mem || s->msize < need) {                                /* (l'ancien morceau reste perdu jusqu'au prochain preset) */
            s->mem = pool_alloc(need); s->msize = need; s->slot = -1; s->kind = -1;
            if (!s->mem) { s->msize = 0; return; }
        }
    }
    if (s->slot != slot || s->kind != kind) {
        if (is_a2l) {
            if (a2l_load(s->mem, blob, (u32)len) != 0) { s->slot = -1; return; }
            a2l_prewarm(s->mem, 6400);                                   /* champ réceptif : ~6 300 échantillons */
        } else if (is_amx) {
            if (amx_load(s->mem, blob, len) != 0) { s->slot = -1; return; }
            amx_prewarm(s->mem, 6400);
        } else {
            if (!s->hist[0] && nam_hist_alloc(s->hist) != 0) { s->hist[0] = 0; s->slot = -1; return; }   /* réserve pleine */
            if (nam_load(s->mem, (const float *)blob, len / 4, s->hist) != 0) { s->slot = -1; return; }
            nam_prewarm(s->mem, 6400);
        }
        s->slot = slot; s->kind = kind;
    }
    if (is_a2l) a2l_gains(s->mem, db2q16(p[P_NAM_IN]), db2q16(p[P_NAM_OUT]));
    else if (is_amx) amx_gains(s->mem, db2q16(p[P_NAM_IN]), db2q16(p[P_NAM_OUT]));
    else nam_gains(s->mem, db2q16(p[P_NAM_IN]), db2q16(p[P_NAM_OUT]));
}
static s32 run_nam(struct block *b, s32 x)
{
    struct st_nam *s = &b->s.n;
    /* le réseau ne tourne que par blocs sur le 2e cœur (engine_process_block) ; ici (section parallèle) : EQ seule */
    return run_eq(&s->eq, x);
}
/* test (commande 0x19) : capture de l'emplacement slot, préchauffage, sinus 220 Hz d'amplitude 0,5 sur 512 échantillons ;
   out[32] = une sortie sur 16 (Q23). Renvoie 0 si OK. Remet le moteur à zéro (l'app renvoie son preset ensuite). */
u32 nam_test_ms, nam_test_front_ms, nam_test_back_ms;
int engine_nam_test(int slot, int split, s32 *out)
{
    int len = 0, n;
    const u8 *blob = proto_nam_blob(slot, &len);
    int is_a2l = blob && len >= 4 && blob[0] == 'A' && blob[1] == '2' && blob[2] == 'L' && blob[3] == '1';
    int is_amx = blob && len == 6204 && blob[0] == 'A' && blob[1] == 'M' && (blob[2] == '2' || blob[2] == '3');
    u32 need;
    void *mem;
    if (!blob) return -1;
    engine_clear();
    need = nam_mem_size();
    if (is_a2l) { u32 an = a2l_mem_size(blob, (u32)len); if (an > need) need = an; }
    if (is_amx) { u32 an = amx_mem_size(); if (an > need) need = an; }
    mem = pool_alloc(need);
    if (!mem) return -2;
    if (is_a2l) { if (a2l_load(mem, blob, (u32)len) != 0) return -2; a2l_prewarm(mem, 6400); }
    else if (is_amx) { if (amx_load(mem, blob, len) != 0) return -2; amx_prewarm(mem, 6400); }
    else {
        static s32 *th[23];
        if (nam_hist_alloc(th) != 0) return -2;
        if (nam_load(mem, (const float *)blob, len / 4, th) != 0) return -2;
        nam_prewarm(mem, 6400);
    }
    {   /* même chemin que l'audio : nam_run par blocs de 128, 6 912 échantillons (144 ms à 48 kHz) ;
           l'entrée est calculée avant le chronomètre (sinf est en flottant logiciel) */
        static s32 yo[128];
        s32 *xs = (s32 *)pool_alloc(6912 * 4);
        int b0, i;
        if (!xs) return -3;
        for (i = 0; i < 6912; i++) xs[i] = (s32)(0.5f * sinf(2 * PI_F * 220 * i / FS) * 8388608.0f);
        u32 usb_read_sofframe(int id);
        void nam_front(void *mem, const s32 *in, int n, int ph);
        void nam_set_split(void *mem, int s);
        if (split >= 0) nam_set_split(mem, split);
        nam_test_ms = usb_read_sofframe(0);
        if (!is_a2l && !is_amx) {
            /* NAM brut : même enchaînement que engine_process_block (avant phase p, arrière du bloc précédent phase p^1) */
            for (b0 = 0; b0 <= 6912; b0 += 128) {
                int ph = (b0 >> 7) & 1;
                if (b0 < 6912) nam_front(mem, xs + b0, 128, ph);
                if (b0 > 0) {
                    int bb = b0 - 128;
                    nam_back(mem, yo, ph ^ 1);
                    if (bb < 512) for (i = 0; i < 128; i += 16) out[(bb + i) >> 4] = yo[i];
                }
                wdt_clear();
            }
        } else {
            for (b0 = 0; b0 < 6912; b0 += 128) {
                nam_run(mem, xs + b0, yo, 128);
                wdt_clear();
                if (b0 < 512) for (i = 0; i < 128; i += 16) out[(b0 + i) >> 4] = yo[i];
            }
        }
        nam_test_ms = (usb_read_sofframe(0) - nam_test_ms) & 2047;      /* ms pour 6 912 échantillons (temps réel : 144 ms) */
        nam_test_front_ms = nam_test_back_ms = 0;
        if (!is_a2l && !is_amx) {                                        /* coût de chaque moitié (le résultat n'est plus utilisé) */
            u32 t = usb_read_sofframe(0);
            for (b0 = 0; b0 < 6912; b0 += 128) { nam_front(mem, xs + b0, 128, 0); wdt_clear(); }
            nam_test_front_ms = (usb_read_sofframe(0) - t) & 2047;
            t = usb_read_sofframe(0);
            for (b0 = 0; b0 < 6912; b0 += 128) { nam_back(mem, yo, 0); wdt_clear(); }
            nam_test_back_ms = (usb_read_sofframe(0) - t) & 2047;
        }
    }
    (void)n;

    return 0;
}

/* banc d'essai de la convolution (commande 0x1A, modèle 120..123) : ms pour reps répétitions de
   120 = ir_block complet, 121 = 2 FFT de 128 seules, 122 = 128 appels de run_ir (dont 1 ir_block), 123 = permutation seule */
u32 engine_bench_ir(int what, int reps)
{
    u32 usb_read_sofframe(int id), t0;
    struct block *b = &grid[0][0];
    int i, k;
    engine_clear();
    if (engine_block_set_force(0, 0, M_CAB412) != 0) return 0xFFFFFFFFu;
    if (!b->s.i.c.np) return 0xFFFFFFFEu;
    for (k = 0; k < IR_N; k++) { fre[k] = (s32)(k * 7919) & 0xFFFF; fim[k] = 0; }
    t0 = usb_read_sofframe(0);
    for (i = 0; i < reps; i++) {
        if (what == 120) ir_block(&b->s.i.c);
        else if (what == 121) { fft128_fwd_scaled(); fft128_inv(); }
        else if (what == 122) { for (k = 0; k < IR_B; k++) (void)run_ir(b, (s32)(k * 40503) >> 8); }
        else { for (k = 1; k < 128; k++) { int j = brev[k] >> 1; if (k < j) { s32 t = fre[k]; fre[k] = fre[j]; fre[j] = t; } } }
        if ((i & 63) == 0) wdt_clear();
    }
    t0 = (usb_read_sofframe(0) - t0) & 2047;
    engine_clear();
    return t0;
}
/* mesure du coût d'un modèle (commande 0x1A) : un seul bloc (réglages par défaut), n échantillons de bruit ;
   m < 0 = grille vide (coût de base). Renvoie les ms (trames USB SOF). Remet le moteur à zéro. */
u32 bench_peak, bench_avg, bench_bad;                                 /* niveau de sortie mesuré par engine_bench_model */
u32 engine_bench_model(int m, int n)
{
    u32 usb_read_sofframe(int id), t0, seed = 12345;
    int i;
    engine_clear();
    if (m >= 0 && engine_block_set_force(0, 0, m) != 0) return 0xFFFFFFFFu;
    t0 = usb_read_sofframe(0);
    for (i = 0; i < n; i++) {
        seed = seed * 1664525u + 1013904223u;
        (void)engine_process((s32)seed >> 10);                           /* ~ -6 dBFS, Q23 */
    }
    t0 = (usb_read_sofframe(0) - t0) & 2047;
    {   /* niveau de sortie (réglages par défaut) pour une note de guitare type : 110 Hz à -14 dBFS + harmoniques */
        u32 pk = 0; s64 sum = 0; int bad = 0;
        for (i = 0; i < 9600; i++) {
            float ph = 2 * PI_F * 110.0f * (float)i / FS;
            s32 x = (s32)((0.2f * sinf(ph) + 0.06f * sinf(2 * ph) + 0.04f * sinf(3 * ph)) * 8388608.0f), y = engine_process(x), a = y < 0 ? -y : y;
            if (i >= 2400) { if ((u32)a > pk) pk = (u32)a; sum += a; }
            if (a > 0x7F000000) bad = 1;
            if ((i & 1023) == 0) wdt_clear();
        }
        bench_peak = pk; bench_avg = (u32)(sum / 7200); bench_bad = (u32)bad;
    }
    engine_clear();
    return t0;
}

/* ---------------- répartition par modèle ---------------- */
int cm_is(int m); unsigned int cm_size(void); void cm_design(void *mem, int m, const float *p); s32 cm_run(void *mem, s32 x);
static void design(struct block *b)
{
    b->cm = (u8)cm_is(b->model);
    b->cat = (u8)MODEL_DEFS[b->model].cat;
    if (b->cm) {                                             /* pédales / amplis modélisés */
        if (!b->s.cm.mem) b->s.cm.mem = pool_alloc(cm_size());
        if (b->s.cm.mem) cm_design(b->s.cm.mem, b->model, b->p);
        return;
    }
    switch (b->cat) {
    case CAT_DRIVE: case CAT_AMP: if (b->model == M_NAM) design_nam(b); else design_drive(b); break;
    case CAT_DYN: if (b->model == M_BOOST) design_eq(b); else design_dyn(b); break;
    case CAT_MOD: design_mod(b); break;
    case CAT_DELAY: design_dly(b); break;
    case CAT_REVERB: design_rev(b); break;
    case CAT_PITCH: design_pit(b); break;
    case CAT_CAB: if (b->model == M_IR) design_ir(b); else design_cab(b); break;
    default: design_eq(b); break;                                      /* eq, util */
    }
}
/* Une capture NAM (ou une IR) vient d'être réécrite dans son emplacement : le bloc qui l'utilise
   doit recharger même si le numéro de slot n'a pas changé (sinon il garde l'ancienne en mémoire). */
void engine_nam_changed(int slot)
{
    int l, c;
    engine_sync();
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || b->model != M_NAM || (int)b->p[P_NAM_SLOT] != slot) continue;
        b->s.n.slot = -1;
        design(b);
    }
}
void engine_ir_changed(int slot)
{
    int l, c;
    engine_sync();
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || b->model != M_IR || (int)b->p[P_IR_SLOT] != slot) continue;
        b->s.i.c.slot = -1;
        design(b);
    }
}
static s32 run(struct block *b, s32 x)
{
    if (!b->on) return x;
    if (b->cm) return b->s.cm.mem ? cm_run(b->s.cm.mem, x) : x;
    switch (b->cat) {
    case CAT_DRIVE: case CAT_AMP: return b->model == M_NAM ? run_nam(b, x) : run_drive(&b->s.d, x);
    case CAT_DYN: return b->model == M_BOOST ? run_eq(&b->s.e, x) : run_dyn(b, x);
    case CAT_MOD: return run_mod(&b->s.m, x);
    case CAT_DELAY: return run_dly(&b->s.l, x);
    case CAT_REVERB: return run_rev(&b->s.r, x);
    case CAT_PITCH: return run_pit(&b->s.t, x);
    case CAT_CAB: return run_ir(b, x);                                   /* IR Loader et cabs d'usine (repli : filtres si pas d'IR) */
    default: return run_eq(&b->s.e, x);
    }
}
/* modèles réellement implémentés (génériques par famille + IR par convolution + NAM A2 Lite) : annoncé dans INFO */
int engine_model_ready(int m)
{
    (void)m;
    return 1;
}

/* ---------------- grille ---------------- */
static void rebuild_sections(void)
{
    int c, s = -1;
    nsec = 0;
    for (c = 0; c <= CAT_COLS; c++) {
        int has = c < CAT_COLS && grid[1][c].used;
        if (has && s < 0) s = c;
        if (!has && s >= 0) { secs[nsec].from = (u8)s; secs[nsec].to = (u8)c; if (!secs[nsec].mix) secs[nsec].mix = 16384; nsec++; s = -1; }
    }
}
void engine_clear(void)
{
    int l, c;
    engine_sync();
    pool_reset();
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        u32 *z = (u32 *)&grid[l][c], i;
        for (i = 0; i < sizeof(struct block) / 4; i++) z[i] = 0;
    }
    nsec = 0; cur_scene = 0; level_q16 = 65536;
    eng_ver++;
}
/* chargement d'un preset complet : les délais reçoivent leur mémoire à la fin, en se partageant ce qui reste */
void engine_load_begin(void) { dly_defer = 1; }
void engine_load_end(void)
{
    int l, c, n = 0;
    dly_defer = 0;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++)
        if (grid[l][c].used && MODEL_DEFS[grid[l][c].model].cat == CAT_DELAY && !grid[l][c].s.l.buf) n++;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || MODEL_DEFS[b->model].cat != CAT_DELAY || b->s.l.buf) continue;
        dly_share = n--;
        design(b);
    }
    dly_share = 0;
    eng_ver++;
}
/* ---------------- budget DSP (comme la maquette) ----------------
 * MODEL_DEFS[m].dsp = coût mesuré sur la pédale (interface/tests/dsp_bench.py, écrit dans data.js), en % du budget effets du 1er cœur.
 * Le NAM est réparti sur les deux cœurs : son « dsp » est sa moitié arrière (1er cœur), comptée avec les autres effets ;
 * sa moitié avant occupe NAM_C1_PCT % du 2e cœur. Un seul NAM par preset.
 * Tout bloc présent compte, même éteint (une scène peut le rallumer). */
#define NAM_C1_PCT 92                                                  /* couches [0,19) : 91,7 % du 2e coeur, mesure sur la pedale */
int engine_dsp_total(int skip_lane, int skip_col)
{
    int l, c, t = 0;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || (l == skip_lane && c == skip_col)) continue;
        t += MODEL_DEFS[b->model].dsp;
    }
    return t;
}
/* charge du 2e cœur pour la moitié avant d'un NAM A2 Lite (couches [0, 19)), mesurée sur la pédale à 396 MHz */
int engine_nam_c1_pct(void) { return NAM_C1_PCT; }
static int nam_count(int skip_lane, int skip_col)
{
    int l, c, t = 0;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) if (grid[l][c].used && grid[l][c].model == M_NAM && !(l == skip_lane && c == skip_col)) t++;
    return t;
}
/* 0 si le modèle m peut aller en (lane, col) sans dépasser le budget ; -2 sinon */
int engine_dsp_check(int lane, int col, int m)
{
    if (m == M_NAM && (NAM_C1_PCT > 100 || nam_count(lane, col) != 0)) return -2;
    /* 115 % : plafond de chargement deja accepte par le firmware ; au-dela, refus. */
    return engine_dsp_total(lane, col) + MODEL_DEFS[m].dsp <= 115 ? 0 : -2;
}
/* place un bloc (modèle m) aux réglages par défaut ; refusé (-2) si le budget DSP serait dépassé */
int engine_block_set(int lane, int col, int m)
{
    if (lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS || m < 0 || m >= M_COUNT) return -1;
    if (engine_dsp_check(lane, col, m) != 0) return -2;
    return engine_block_set_force(lane, col, m);
}
int engine_block_set_force(int lane, int col, int m)
{
    struct block *b;
    int i;
    if (lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS || m < 0 || m >= M_COUNT) return -1;
    b = &grid[lane][col];
    { u32 *z = (u32 *)b, k; for (k = 0; k < sizeof(struct block) / 4; k++) z[k] = 0; }
    b->used = 1; b->model = (u8)m; b->on = 1;
    for (i = 0; i < MAX_PARAMS; i++) b->p[i] = MODEL_DEFS[m].def[i];
    { int sc; for (sc = 0; sc < CAT_SCENES; sc++) engine_scene_store(sc, lane, col, 1, b->p, MAX_PARAMS); }   /* toutes les scènes = défaut */
    design(b);
    rebuild_sections();
    eng_ver++; eng_mods++;
    return 0;
}
void engine_block_clear(int lane, int col)
{
    if (lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS) return;
    grid[lane][col].used = 0;
    /* les états de scènes du slot restent en place : un nouveau bloc les réinitialise (engine_block_set_force) */
    rebuild_sections();
    eng_ver++; eng_mods++;
}
/* échange deux slots (bloc + réglages + états des 8 scènes) : l'ordre du signal change sans perdre les réglages */
int engine_block_move(int lane1, int col1, int lane2, int col2)
{
    struct block tb;
    struct scene_blk ts;
    int sc;
    if (lane1 < 0 || lane1 > 1 || lane2 < 0 || lane2 > 1 || col1 < 0 || col1 >= CAT_COLS || col2 < 0 || col2 >= CAT_COLS) return -1;
    if (lane1 == lane2 && col1 == col2) return 0;
    tb = grid[lane1][col1]; grid[lane1][col1] = grid[lane2][col2]; grid[lane2][col2] = tb;
    for (sc = 0; sc < CAT_SCENES; sc++) {
        ts = scenes[sc][lane1][col1]; scenes[sc][lane1][col1] = scenes[sc][lane2][col2]; scenes[sc][lane2][col2] = ts;
    }
    rebuild_sections();
    eng_ver++; eng_mods++;
    return 0;
}
int engine_param(int lane, int col, int idx, float v)
{
    struct block *b;
    if (lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS || idx < 0 || idx >= MAX_PARAMS) return -1;
    b = &grid[lane][col];
    if (!b->used || idx >= MODEL_DEFS[b->model].nparams) return -1;
    b->p[idx] = v;
    scenes[cur_scene][lane][col].p[idx] = v;
    design(b);
    eng_ver++; eng_mods++;
    return 0;
}
int engine_bypass(int lane, int col, int on)
{
    if (lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS || !grid[lane][col].used) return -1;
    grid[lane][col].on = (u8)(on != 0);
    scenes[cur_scene][lane][col].on = (u8)(on != 0);
    eng_ver++; eng_mods++;
    return 0;
}
void engine_scene_store(int sc, int lane, int col, int on, const float *p, int n)
{
    int i;
    if (sc < 0 || sc >= CAT_SCENES || lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS) return;
    scenes[sc][lane][col].on = (u8)(on != 0);
    for (i = 0; i < n && i < MAX_PARAMS; i++) scenes[sc][lane][col].p[i] = p[i];
}
int engine_scene_select(int sc)
{
    int l, c, i;
    if (sc < 0 || sc >= CAT_SCENES) return -1;
    cur_scene = sc;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used) continue;
        b->on = scenes[sc][l][c].on;
        for (i = 0; i < MODEL_DEFS[b->model].nparams; i++) b->p[i] = scenes[sc][l][c].p[i];
        design(b);
    }
    eng_ver++;
    return 0;
}
void engine_split(int from, int to, int mix)
{
    int i;
    (void)to;
    for (i = 0; i < nsec; i++) if (secs[i].from == from) secs[i].mix = pct2q15((float)mix);
    eng_ver++; eng_mods++;
}
void engine_level(float db) { level_q16 = db2q16(db); eng_mods++; }
u32 engine_mods(void) { return eng_mods; }
int engine_scene(void) { return cur_scene; }
u32 engine_version(void) { return eng_ver; }
int engine_get(int lane, int col, int *model, int *on) { struct block *b = &grid[lane][col]; if (!b->used) return 0; *model = b->model; *on = b->on; return 1; }
/* export du preset (proto.c) : état d'un bloc dans une scène ; renvoie le nombre de paramètres, -1 si la case est vide */
int engine_scene_get(int sc, int lane, int col, int *on, float *p)
{
    int i, n;
    if (sc < 0 || sc >= CAT_SCENES || lane < 0 || lane > 1 || col < 0 || col >= CAT_COLS || !grid[lane][col].used) return -1;
    n = MODEL_DEFS[grid[lane][col].model].nparams;
    *on = scenes[sc][lane][col].on;
    for (i = 0; i < n; i++) p[i] = scenes[sc][lane][col].p[i];
    return n;
}
/* sections parallèles : début, fin, mélange en % ; renvoie leur nombre */
int engine_sections(u8 *from, u8 *to, u8 *mix)
{
    int i;
    for (i = 0; i < nsec; i++) { from[i] = secs[i].from; to[i] = secs[i].to; mix[i] = (u8)((secs[i].mix * 100 + 16383) / 32767); }
    return nsec;
}
const float *engine_params(int lane, int col) { return grid[lane][col].p; }
/* bascule le 1er bloc d'une famille (touches FX..CAB de la façade) ; renvoie 1 si un bloc a été trouvé */
int engine_toggle_family(int fam, int *lane_out, int *col_out)
{
    int c, l;
    for (c = 0; c < CAT_COLS; c++) for (l = 0; l < 2; l++) {
        struct block *b = &grid[l][c];
        int cat;
        if (!b->used) continue;
        cat = MODEL_DEFS[b->model].cat;
        if ((fam == 0 && (cat == CAT_DYN || cat == CAT_DRIVE || cat == CAT_PITCH || cat == CAT_EQ || cat == CAT_UTIL)) ||
            (fam == 1 && cat == CAT_AMP) || (fam == 2 && cat == CAT_MOD) || (fam == 3 && cat == CAT_DELAY) ||
            (fam == 4 && cat == CAT_REVERB) || (fam == 5 && cat == CAT_CAB)) {
            engine_bypass(l, c, !b->on);
            *lane_out = l; *col_out = c;
            return 1;
        }
    }
    return 0;
}
int engine_family_on(int fam)
{
    int c, l;
    for (c = 0; c < CAT_COLS; c++) for (l = 0; l < 2; l++) {
        struct block *b = &grid[l][c];
        int cat;
        if (!b->used || !b->on) continue;
        cat = MODEL_DEFS[b->model].cat;
        if ((fam == 0 && (cat == CAT_DYN || cat == CAT_DRIVE || cat == CAT_PITCH || cat == CAT_EQ || cat == CAT_UTIL)) ||
            (fam == 1 && cat == CAT_AMP) || (fam == 2 && cat == CAT_MOD) || (fam == 3 && cat == CAT_DELAY) ||
            (fam == 4 && cat == CAT_REVERB) || (fam == 5 && cat == CAT_CAB)) return 1;
    }
    return 0;
}

/* ---------------- traitement (Q23) ---------------- */
/* une seule rangée, sans sections : blocs utilisés de [c0, c1) */
static s32 run_lane(int l, s32 x, int c0, int c1)
{
    int c;
    for (c = c0; c < c1; c++) if (grid[l][c].used) x = run(&grid[l][c], x);
    return x;
}
/* premier NAM actif placé dans une section parallèle : renvoie sa rangée, sa colonne, les bornes de la section */
static int nam_section(int *lane, int *col, int *from, int *to, int *si)
{
    int l, c, i;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || b->model != M_NAM || !b->on || b->s.n.slot < 0 || !b->s.n.mem) continue;
        for (i = 0; i < nsec; i++) if (c >= secs[i].from && c < secs[i].to) {
            *lane = l; *col = c; *from = secs[i].from; *to = secs[i].to; *si = i;
            return 1;
        }
    }
    return 0;
}
/* colonnes [c0, c1) d'un échantillon ; les sections parallèles ne sont jamais coupées par c0 / c1 */
static s32 process_cols(s32 x, int c0, int c1)
{
    int c, si = 0;
    s32 xa = 0, xb = 0;
    if (!nsec) {                                                       /* chaine serie : pas de split a verifier */
        for (c = c0; c < c1; c++) if (grid[0][c].used) x = run(&grid[0][c], x);
        return x;
    }
    while (si < nsec && secs[si].to <= c0) si++;
    for (c = c0; c < c1; c++) {
        int in_sec = si < nsec && c >= secs[si].from && c < secs[si].to;
        if (in_sec) {
            if (c == secs[si].from) { xa = x; xb = x; }
            if (grid[0][c].used) xa = run(&grid[0][c], xa);
            if (grid[1][c].used) xb = run(&grid[1][c], xb);
            if (c == secs[si].to - 1) {                                /* merge : balance A/B */
                s32 m = secs[si].mix;
                x = mulq15(xa, 32767 - m) + mulq15(xb, m);
                si++;
            }
        } else if (grid[0][c].used) x = run(&grid[0][c], x);
    }
    return x;
}
s32 engine_process(s32 x) { return mulq16(process_cols(x, 0, CAT_COLS), level_q16); }

/* NAM sur le 2e cœur (core1.c) : bloc NAM actif de la rangée A, hors section parallèle -> calcul en parallèle, +1 bloc de latence */
int core1_alive(void);
void core1_submit(void *mem, s32 *in, s32 *out, u32 n);
void core1_submit_front(void *mem, s32 *in, u32 n, u32 ph);
int core1_wait(u32 spins);
#define C1_IN  ((s32 *)0x1C72100u)                                       /* 2 x 128 */
#define C1_OUT ((s32 *)0x1C72500u)                                       /* 2 x 128 */
static int c1_phase, c1_primed, c1_col = -1;
static u32 c1_timeouts;
static s32 par_b[128], par_c[128];                                  /* section avec NAM : branche retardée d'un bloc */
void engine_sync(void) { if (c1_primed) core1_wait(20000000u); c1_primed = 0; }   /* avant toute modification du moteur */
static int offload_col(void)
{
    int c, i;
    if (!core1_alive()) return -1;
    for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[0][c];
        if (!b->used || b->model != M_NAM || !b->on || b->s.n.slot < 0 || !b->s.n.mem) continue;
        for (i = 0; i < nsec; i++) if (c >= secs[i].from && c < secs[i].to) return -1;
        return c;
    }
    return -1;
}
void engine_process_block(s32 *buf, int n)
{
    int c = offload_col(), i, sl, sc, sf, st, ssi;
    /* NAM dans une section parallèle (ex. NAM en A, Bass SV en B) : le NAM reste sur le 2e cœur,
       la branche sans NAM est retardée d'un bloc pour être alignée sur la sortie NAM du bloc précédent. */
    if (c < 0 && core1_alive() && nam_section(&sl, &sc, &sf, &st, &ssi)) {
        int key = 128 + (((sl * CAT_COLS + sc) << 8) | (sf << 4) | st);
        int m = secs[ssi].mix;
        s32 *in = C1_IN + c1_phase * 128, *prev = C1_OUT + (c1_phase ^ 1) * 128;
        struct block *nb = &grid[sl][sc];
        if (key != c1_col) {
            engine_sync();
            c1_col = key;
            for (i = 0; i < 2 * 128; i++) C1_OUT[i] = 0;
            for (i = 0; i < 128; i++) par_b[i] = 0;
        }
        for (i = 0; i < n; i++) {
            s32 x = process_cols(buf[i], 0, sf);                          /* avant la section */
            in[i] = run_lane(sl, x, sf, sc);                              /* NAM : entrée du bloc n */
            par_c[i] = run_lane(1 - sl, x, sf, st);                       /* autre branche : bloc n */
        }
        if (c1_primed && core1_wait(100000u) != 0) {
            c1_timeouts++;
            for (i = 0; i < n; i++) buf[i] = 0;
            return;
        }
        if (nam_is_raw(nb->s.n.mem)) {
            int primed = c1_primed;
            core1_submit_front(nb->s.n.mem, in, (u32)n, (u32)c1_phase);
            c1_primed = 1;
            if (primed) nam_back(nb->s.n.mem, prev, c1_phase ^ 1);
            else for (i = 0; i < n; i++) prev[i] = 0;
        } else {
            core1_submit(nb->s.n.mem, in, C1_OUT + c1_phase * 128, (u32)n);
            c1_primed = 1;
        }
        for (i = 0; i < n; i++) {                                        /* sortie NAM du bloc n-1 + autre branche retardée */
            s32 a = run_lane(sl, run_eq(&nb->s.n.eq, prev[i]), sc + 1, st);
            s32 b = par_b[i];
            par_b[i] = par_c[i];
            buf[i] = mulq16(process_cols(mulq15(a, 32767 - m) + mulq15(b, m), st, CAT_COLS), level_q16);
        }
        c1_phase ^= 1;
        return;
    }
    if (c < 0) {                                                         /* tout sur le 1er cœur */
        if (c1_primed) engine_sync();
        c1_col = -1;
        for (i = 0; i < n; i++) buf[i] = engine_process(buf[i]);
        return;
    }
    if (c != c1_col) { engine_sync(); c1_col = c; for (i = 0; i < 2 * 128; i++) C1_OUT[i] = 0; }
    {
        s32 *in = C1_IN + c1_phase * 128, *prev = C1_OUT + (c1_phase ^ 1) * 128;
        struct block *nb = &grid[0][c];
        for (i = 0; i < n; i++) in[i] = process_cols(buf[i], 0, c);      /* avant le NAM (bloc n) */
        if (c1_primed && core1_wait(100000u) != 0) {                     /* NAM du bloc n-1 pas fini (~3 ms max) : */
            c1_timeouts++;                                               /* bloc muet, on ne relance pas le 2e cœur occupé */
            for (i = 0; i < n; i++) buf[i] = 0;                          /* (le garde-fou de surcharge de main.c prend le relais) */
            return;
        }
        if (nam_is_raw(nb->s.n.mem)) {
            /* NAM brut réparti : le 2e cœur calcule les couches [0, split) du bloc n pendant que ce cœur calcule les couches
               [split, 23) et la tête du bloc n-1 (même latence d'un bloc qu'avant) */
            int primed = c1_primed;
            core1_submit_front(nb->s.n.mem, in, (u32)n, (u32)c1_phase);
            c1_primed = 1;
            if (primed) nam_back(nb->s.n.mem, prev, c1_phase ^ 1);
            else for (i = 0; i < n; i++) prev[i] = 0;
        } else {
            core1_submit(nb->s.n.mem, in, C1_OUT + c1_phase * 128, (u32)n);
            c1_primed = 1;
        }
        for (i = 0; i < n; i++) {                                        /* après le NAM (bloc n-1) */
            s32 x = run_eq(&nb->s.n.eq, prev[i]);
            buf[i] = mulq16(process_cols(x, c + 1, CAT_COLS), level_q16);
        }
        c1_phase ^= 1;
    }
}
u32 engine_c1_timeouts(void) { return c1_timeouts; }
/* diagnostic (commande 0x21) : état du premier bloc NAM de la grille ; renvoie le nombre de mots écrits */
int engine_nam_diag(u32 *o)
{
    int l, c;
    for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
        struct block *b = &grid[l][c];
        if (!b->used || b->model != M_NAM) continue;
        o[0] = (u32)(l * 16 + c); o[1] = b->on; o[2] = (u32)b->s.n.slot; o[3] = (u32)b->s.n.kind; o[4] = (u32)b->s.n.mem;
        o[5] = b->s.n.msize; o[6] = (u32)b->s.n.hist[0]; o[7] = (u32)offload_col(); o[8] = (u32)core1_alive();
        o[9] = pool1; o[10] = pool2; o[11] = c1_timeouts; o[12] = (u32)nsec; o[13] = (u32)b->p[P_NAM_SLOT];
        return 14;
    }
    o[0] = 0xFFFFFFFFu; o[9] = pool1; o[10] = pool2;
    return 11;
}

/* ---------------- preset complet (JSON compact de l'app, voir json.c) ---------------- */
int engine_model_by_name(const char *s, int n)
{
    int m, i;
    for (m = 0; m < M_COUNT; m++) {
        const char *id = MODEL_DEFS[m].id;
        for (i = 0; i < n && id[i] && id[i] == s[i]; i++) { }
        if (i == n && id[i] == 0) return m;
    }
    return -1;
}
