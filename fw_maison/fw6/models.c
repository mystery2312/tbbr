/* models.c : pédales et amplis modélisés d'après leurs schémas (écrit pour ce projet, flottant matériel fprev1).
 *
 * Principe commun : les parties linéaires sont tirées des valeurs de composants des schémas publiés (fréquences de coupure
 * = 1 / (2 pi R C), tone stacks d'amplis résolus exactement par circuit.c) ; les parties non linéaires (diodes, lampes,
 * étage de puissance) sont des fonctions statiques choisies selon le type d'écrêtage (diodes dans la contre-réaction =
 * doux, diodes à la masse = dur, germanium = seuil bas, nombre de diodes différent = asymétrique, triode = asymétrique),
 * calculées à 96 kHz (suréchantillonnage x2) pour limiter le repliement.
 * Échelle : 1,0 = pleine échelle de l'entrée 16 bits (ordre de grandeur : 1 V crête).
 *
 * Pédales : green = TS9, gold = Klon, grit = RAT, od1 = OD-1, sd1 = SD-1, bd2 = Blues Driver, muff = Big Muff.
 * Amplis : brit = JCM800, usclean = Twin Reverb, chime = AC30 Top Boost, rect = Dual Rectifier, lead51 = 5150, plexi. */
#include "catalog.h"
#include "circuit.h"

typedef int s32;
typedef long long s64;
float sinf(float), cosf(float), powf(float, float), expf(float);
float sqrtf_(float v);

/* calibrage des amplis (voir cm_design) : atténuation d'entrée et compensation de sortie, en dB */
#ifndef PAD_USCLEAN
#define PAD_USCLEAN 6
#define PAD_CHIME 22
#define PAD_PLEXI 14
#define PAD_BRIT 22
#define PAD_RECT 58
#define PAD_LEAD51 58
#endif
#ifndef MK_USCLEAN
#define MK_USCLEAN 5
#define MK_CHIME 6
#define MK_PLEXI 2
#define MK_BRIT 4
#define MK_RECT 0
#define MK_LEAD51 0
#endif
#define FS1 48000.0f
#define FS2 96000.0f
#define PI_F 3.14159265f

/* ---------------- briques ---------------- */
struct bqf { float b0, b1, b2, a1, a2, z1, z2; };
enum { F_LP, F_HP, F_PEAK, F_LSH, F_HSH, F_LP1, F_HP1, F_THRU };
static void bqf_set(struct bqf *f, int type, float fc, float q, float db, float fs)
{
    float w = 2 * PI_F * fc / fs, cw = cosf(w), sw = sinf(w), al = sw / (2 * q), A = powf(10.0f, db / 40.0f), b0, b1, b2, a0, a1, a2;
    f->z1 = f->z2 = 0;
    switch (type) {
    case F_LP: b0 = (1 - cw) / 2; b1 = 1 - cw; b2 = b0; a0 = 1 + al; a1 = -2 * cw; a2 = 1 - al; break;
    case F_HP: b0 = (1 + cw) / 2; b1 = -(1 + cw); b2 = b0; a0 = 1 + al; a1 = -2 * cw; a2 = 1 - al; break;
    case F_PEAK: b0 = 1 + al * A; b1 = -2 * cw; b2 = 1 - al * A; a0 = 1 + al / A; a1 = -2 * cw; a2 = 1 - al / A; break;
    case F_LSH: { float s = 2 * sqrtf_(A) * al; b0 = A * ((A + 1) - (A - 1) * cw + s); b1 = 2 * A * ((A - 1) - (A + 1) * cw); b2 = A * ((A + 1) - (A - 1) * cw - s);
                  a0 = (A + 1) + (A - 1) * cw + s; a1 = -2 * ((A - 1) + (A + 1) * cw); a2 = (A + 1) + (A - 1) * cw - s; break; }
    case F_HSH: { float s = 2 * sqrtf_(A) * al; b0 = A * ((A + 1) + (A - 1) * cw + s); b1 = -2 * A * ((A - 1) + (A + 1) * cw); b2 = A * ((A + 1) + (A - 1) * cw - s);
                  a0 = (A + 1) - (A - 1) * cw + s; a1 = 2 * ((A - 1) - (A + 1) * cw); a2 = (A + 1) - (A - 1) * cw - s; break; }
    case F_LP1: { float k = sw / (1 + cw); b0 = k; b1 = k; b2 = 0; a0 = 1 + k; a1 = k - 1; a2 = 0; break; }      /* 1er ordre, bilinéaire */
    case F_HP1: { float k = sw / (1 + cw); b0 = 1; b1 = -1; b2 = 0; a0 = 1 + k; a1 = k - 1; a2 = 0; break; }
    default: b0 = 1; b1 = b2 = 0; a0 = 1; a1 = a2 = 0; break;
    }
    f->b0 = b0 / a0; f->b1 = b1 / a0; f->b2 = b2 / a0; f->a1 = a1 / a0; f->a2 = a2 / a0;
}
static inline float bqf(struct bqf *f, float x)
{
    float y = f->b0 * x + f->z1;
    f->z1 = f->b1 * x - f->a1 * y + f->z2;
    f->z2 = f->b2 * x - f->a2 * y;
    return y;
}
/* 1er ordre (F_LP1 / F_HP1) : 3 multiplications au lieu de 5 */
static inline float op1(struct bqf *f, float x) { float y = f->b0 * x + f->z1; f->z1 = f->b1 * x - f->a1 * y; return y; }
/* saturation douce (tanh rationnel), dure (cubique), asymétrique */
/* saturation douce sans division : f(u) = (15u - 10u^3 + 3u^5) / 8 avec u = 8x/15 (pente 1 à l'origine, plafond 1 atteint
   à |x| = 1,875 avec dérivées 1re et 2e nulles : raccord lisse, comme une lampe ou des diodes en contre-réaction) */
static inline float sat(float x) { float u, u2; if (x >= 1.875f) return 1; if (x <= -1.875f) return -1; u = x * 0.53333333f; u2 = u * u; return u * (15 + u2 * (-10 + 3 * u2)) * 0.125f; }
static inline float hard(float x) { if (x > 1) return 1; if (x < -1) return -1; return 1.5f * x - 0.5f * x * x * x; }
static inline float clipv(float x, float vp, float vn, float ivp, float ivn) { return x >= 0 ? vp * sat(x * ivp) : vn * sat(x * ivn); }
float sqrtf_(float v) { float r = v > 1 ? v : 1; int i; if (v <= 0) return 0; for (i = 0; i < 20; i++) r = 0.5f * (r + v / r); return r; }

/* suréchantillonnage x2 : Butterworth 4e ordre à 20 kHz (à 96 kHz), avant et après la partie non linéaire */
struct os2 { struct bqf u1, u2, d1, d2; };
static void os2_set(struct os2 *o)
{
    bqf_set(&o->u1, F_LP, 20000, 0.5412f, 0, FS2); bqf_set(&o->u2, F_LP, 20000, 1.3066f, 0, FS2);
    bqf_set(&o->d1, F_LP, 20000, 0.5412f, 0, FS2); bqf_set(&o->d2, F_LP, 20000, 1.3066f, 0, FS2);
}

/* ---------------- état d'un modèle (alloué dans la réserve par engine.c) ---------------- */
#define NST 5
struct tstage { float g, bias, s0; int has_sh; struct bqf hp, lp, sh; };       /* étage triode : gain, polarisation, filtres */
struct cmst {
    int model, kind;                                                /* kind : 0 pédale, 1 ampli */
    struct os2 os;
    /* pédales */
    float g1, g2, vp, vn, ivp, ivn, mix, lvl, rd560, rd47, rail;
    struct bqf f[8];
    /* amplis */
    int nst, ts_after, gain_at;
    struct tstage st[NST];
    struct iir stack;
    float gain_in, pa_drive, pa_asym, sag, env, att, rel, out, bright_g;
    float trim;                                                     /* alignement du niveau (mesuré par tests\levels.py) */
    float pad;                                                      /* atténuation d'entrée : seuil de saturation réaliste (fw6 0.18) */
    struct bqf in_hp, pres, res, cut, post;
};
unsigned int cm_size(void) { return sizeof(struct cmst); }

int cm_is(int m)
{
    return m == M_GREEN || m == M_GOLD || m == M_GRIT || m == M_OD1 || m == M_SD1 || m == M_BD2 || m == M_MUFF ||
           m == M_BRIT || m == M_USCLEAN || m == M_CHIME || m == M_RECT || m == M_LEAD51 || m == M_PLEXI;
}
static float k01(float v) { return v < 0 ? 0 : (v > 10 ? 1 : v / 10); }   /* potard 0..10 */
static float db2g(float db) { return powf(10.0f, db / 20.0f); }
static void setclip(struct cmst *s, float vp, float vn) { s->vp = vp; s->vn = vn; s->ivp = 1 / vp; s->ivn = 1 / vn; }

/* ================= PÉDALES ================= */
static void design_pedal(struct cmst *s, int m, const float *p)
{
    int i;
    s->kind = 0;
    for (i = 0; i < 8; i++) bqf_set(&s->f[i], F_THRU, 0, 0, 0, FS1);
    os2_set(&s->os);
    if (m == M_GREEN) {         /* TS9 : branche de gain HP 720 Hz (4,7k / 47n), gain 1 + (51k + Drive 500k log) / 4,7k,
                                   diodes 1N914 tête-bêche dans la contre-réaction (doux, symétrique), 51 pF en // ;
                                   puis passe-bas 1k / 220n (723 Hz) et contrôle de tonalité actif, Level 100k log */
        float rd = 500e3f * pot_taper(k01(p[P_GREEN_DRV]), 1);
        s->g1 = 1 + (51e3f + rd) / 4.7e3f;
        bqf_set(&s->f[0], F_HP1, 720, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 1 / (2 * PI_F * (51e3f + rd) * 51e-12f), 0, 0, FS2);
        setclip(s, 0.45f, 0.45f);
        bqf_set(&s->f[2], F_LP1, 723, 0, 0, FS1);
        bqf_set(&s->f[3], F_HSH, 1000, 0.5f, -14 + 22 * k01(p[P_GREEN_TONE]), FS1);   /* Tone : de sombre à brillant */
        bqf_set(&s->f[4], F_HP1, 20, 0, 0, FS1);
        s->lvl = 1.6f * pot_taper(k01(p[P_GREEN_LVL]), 1) * 4;
    } else if (m == M_SD1) {    /* SD-1 : même structure, Drive 1M, diodes asymétriques (1 contre 2 : +0,45 / -0,9) */
        float rd = 1e6f * pot_taper(k01(p[P_SD1_DRV]), 1);
        s->g1 = 1 + (36e3f + rd) / 4.7e3f;
        bqf_set(&s->f[0], F_HP1, 720, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 1 / (2 * PI_F * (36e3f + rd) * 51e-12f), 0, 0, FS2);
        setclip(s, 0.45f, 0.9f);
        bqf_set(&s->f[2], F_LP1, 1000, 0, 0, FS1);
        bqf_set(&s->f[3], F_HSH, 1200, 0.5f, -14 + 24 * k01(p[P_SD1_TONE]), FS1);
        bqf_set(&s->f[4], F_HP1, 20, 0, 0, FS1);
        s->lvl = 1.4f * pot_taper(k01(p[P_SD1_LVL]), 1) * 4;
    } else if (m == M_OD1) {    /* OD-1 : sans tonalité ; gain élevé, diodes asymétriques, réponse fixe plus médium */
        float rd = 1e6f * pot_taper(k01(p[P_OD1_DRV]), 1);
        s->g1 = 1 + (10e3f + rd) / 10e3f;
        bqf_set(&s->f[0], F_HP1, 340, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 1 / (2 * PI_F * (10e3f + rd) * 100e-12f) + 2500, 0, 0, FS2);
        setclip(s, 0.4f, 0.75f);
        bqf_set(&s->f[2], F_LP1, 2800, 0, 0, FS1);
        bqf_set(&s->f[3], F_PEAK, 1000, 0.7f, 2, FS1);
        bqf_set(&s->f[4], F_HP1, 30, 0, 0, FS1);
        s->lvl = 1.3f * pot_taper(k01(p[P_OD1_LVL]), 1) * 4;
    } else if (m == M_GOLD) {   /* Klon : gain double (le gain retire du son clair), branche saturée filtrée médium,
                                   diodes germanium à la masse (seuil bas, dur), aigus actifs, sortie */
        float g = k01(p[P_GOLD_GAIN]);
        s->g1 = 1 + 70 * g * g;
        s->mix = 1 - 0.75f * g;                                       /* part de son clair */
        bqf_set(&s->f[0], F_HP1, 400, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 5000, 0, 0, FS2);
        setclip(s, 0.3f, 0.3f);
        bqf_set(&s->f[2], F_HSH, 1800, 0.6f, -10 + 20 * k01(p[P_GOLD_TREB]), FS1);
        bqf_set(&s->f[3], F_HP1, 25, 0, 0, FS1);
        s->lvl = 1.8f * pot_taper(k01(p[P_GOLD_OUT]), 1) * 4;
    } else if (m == M_GRIT) {   /* RAT : gain 1 + Rd (1/560 + 1/47) avec 560 / 4,7u (60 Hz) et 47 / 2,2u (1,5 kHz),
                                   Rd = Distortion 100k log, 100 pF en //, LM308 lent ; diodes 1N914 à la masse (dur) ;
                                   Filter : passe-bas 1,5k + 100k lin sur 3,3 nF (32 kHz -> 475 Hz) ; Volume 100k log */
        float rd = 100e3f * pot_taper(k01(p[P_GRIT_DIST]), 1);
        s->rd560 = rd / 560; s->rd47 = rd / 47;
        bqf_set(&s->f[0], F_HP1, 60, 0, 0, FS2);
        bqf_set(&s->f[1], F_HP1, 1540, 0, 0, FS2);
        {
            float fgbw = 1e6f / (1 + s->rd560 + s->rd47) + 1 / (2 * PI_F * (rd + 1) * 100e-12f);
            bqf_set(&s->f[2], F_LP1, fgbw > 30000 ? 30000 : (fgbw < 1500 ? 1500 : fgbw), 0, 0, FS2);
        }
        s->rail = 4.0f;
        setclip(s, 0.55f, 0.55f);
        bqf_set(&s->f[3], F_LP1, 1 / (2 * PI_F * (1.5e3f + 100e3f * k01(p[P_GRIT_FILT])) * 3.3e-9f), 0, 0, FS1);
        bqf_set(&s->f[4], F_HP1, 30, 0, 0, FS1);
        s->lvl = 1.2f * pot_taper(k01(p[P_GRIT_VOL]), 1) * 4;
    } else if (m == M_BD2) {    /* Blues Driver : deux étages discrets en cascade (Gain double), écrêtage doux puis
                                   diodes ; tonalité aigus / graves combinée ; Level */
        float g = k01(p[P_BD2_GAIN]);
        s->g1 = 1 + 18 * g; s->g2 = 1 + 40 * g * g;
        bqf_set(&s->f[0], F_HP1, 120, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 7000, 0, 0, FS2);
        bqf_set(&s->f[2], F_HP1, 60, 0, 0, FS2);
        setclip(s, 0.6f, 0.6f);
        bqf_set(&s->f[3], F_HSH, 1500, 0.5f, -12 + 24 * k01(p[P_BD2_TONE]), FS1);
        bqf_set(&s->f[4], F_LSH, 150, 0.6f, 4 - 6 * k01(p[P_BD2_TONE]), FS1);
        bqf_set(&s->f[5], F_LP1, 7500, 0, 0, FS1);
        s->lvl = 1.2f * pot_taper(k01(p[P_BD2_LVL]), 1) * 4;
    } else {                    /* Big Muff : 2 étages à transistor avec diodes en contre-réaction (doux), passe-bas entre
                                   les étages ; tone stack passif : passe-bas 400 Hz / passe-haut 1,2 kHz mélangés (creux
                                   des médiums vers 1 kHz) ; étage de récupération ; Sustain = attaque de l'étage 1 */
        float su = k01(p[P_MUFF_SUS]);
        s->g1 = 2 + 60 * su * su; s->g2 = 12;
        bqf_set(&s->f[0], F_HP1, 100, 0, 0, FS2);
        bqf_set(&s->f[1], F_LP1, 3200, 0, 0, FS2);
        bqf_set(&s->f[2], F_HP1, 80, 0, 0, FS2);
        bqf_set(&s->f[3], F_LP1, 3200, 0, 0, FS2);
        setclip(s, 0.5f, 0.5f);
        bqf_set(&s->f[4], F_LP1, 1 / (2 * PI_F * 22e3f * 18e-9f), 0, 0, FS1);         /* 400 Hz */
        bqf_set(&s->f[5], F_HP1, 1 / (2 * PI_F * 22e3f * 5.6e-9f), 0, 0, FS1);        /* 1,3 kHz */
        s->mix = k01(p[P_MUFF_TONE]);
        bqf_set(&s->f[6], F_HP1, 40, 0, 0, FS1);
        s->lvl = 2.2f * pot_taper(k01(p[P_MUFF_VOL]), 1) * 4;
    }
}
/* partie non linéaire d'une pédale, à 96 kHz */
static inline float pedal_nl(struct cmst *s, float x)
{
    switch (s->model) {
    case M_GREEN: case M_SD1: case M_OD1: {                           /* x + clip(gain x HP) : graves propres + médiums saturés */
        float v = op1(&s->f[1], s->g1 * op1(&s->f[0], x));
        return x + clipv(v, s->vp, s->vn, s->ivp, s->ivn);
    }
    case M_GOLD: {
        float v = op1(&s->f[1], s->g1 * op1(&s->f[0], x));
        return s->mix * x * 1.5f + s->vp * hard(v * s->ivp);
    }
    case M_GRIT: {
        float v = x + s->rd560 * op1(&s->f[0], x) + s->rd47 * op1(&s->f[1], x);
        v = op1(&s->f[2], v);
        v = s->rail * sat(v / s->rail);                                /* rails de l'ampli op */
        return s->vp * hard(v * s->ivp);                                /* diodes à la masse */
    }
    case M_BD2: {
        float v = sat(s->g1 * op1(&s->f[0], x) + 0.1f) - 0.0997f;      /* étage 1 : légère asymétrie */
        v = op1(&s->f[1], v);
        v = sat(s->g2 * op1(&s->f[2], v));
        return s->vp * hard(v * 1.2f * s->ivp);
    }
    default: {                                                         /* Big Muff */
        float v = sat(s->g1 * op1(&s->f[0], x));
        v = op1(&s->f[1], v);
        v = sat(s->g2 * op1(&s->f[2], v));
        return op1(&s->f[3], v);
    }
    }
}
static float run_pedal(struct cmst *s, float x)
{
    float u0, u1, y;
    u0 = pedal_nl(s, bqf(&s->os.u2, bqf(&s->os.u1, 2 * x)));
    u1 = pedal_nl(s, bqf(&s->os.u2, bqf(&s->os.u1, 0)));
    bqf(&s->os.d2, bqf(&s->os.d1, u0));
    y = bqf(&s->os.d2, bqf(&s->os.d1, u1));
    switch (s->model) {
    case M_GREEN: case M_SD1: y = op1(&s->f[4], bqf(&s->f[3], op1(&s->f[2], y))); break;
    case M_OD1: y = op1(&s->f[4], bqf(&s->f[3], op1(&s->f[2], y))); break;
    case M_GOLD: y = op1(&s->f[3], bqf(&s->f[2], y)); break;
    case M_GRIT: y = op1(&s->f[4], op1(&s->f[3], y)); break;
    case M_BD2: y = op1(&s->f[5], bqf(&s->f[4], bqf(&s->f[3], y))); break;
    default: { float lp = op1(&s->f[4], y), hp = op1(&s->f[5], y); y = op1(&s->f[6], ((1 - s->mix) * lp + s->mix * hp) * s->g2 * 0.25f); break; }
    }
    return y * s->lvl * 0.25f;
}

/* ================= AMPLIS ================= */
/* tone stack TMB (Fender / Marshall / Mesa / 5150) : 1 entrée, 2 haut des aigus, 3 sortie (curseur), 4 haut des graves,
   5 après la résistance de pente, 6 haut des médiums ; source = résistance interne de l'étage qui l'attaque ; charge 1 M */
static void tmb(struct iir *f, float R1, float R2, float R3, float R4, float C1, float C2, float C3, float rsrc,
                float t, float m, float l, float fs)
{
    struct rc e[9];
    float tt = pot_taper(t, 1), mm = pot_taper(m, 0), ll = pot_taper(l, 1);
    e[0].t = RC_C; e[0].a = 1; e[0].b = 2; e[0].v = C1;
    e[1].t = RC_R; e[1].a = 2; e[1].b = 3; e[1].v = R1 * (1 - tt) + 1;
    e[2].t = RC_R; e[2].a = 3; e[2].b = 4; e[2].v = R1 * tt + 1;
    e[3].t = RC_R; e[3].a = 1; e[3].b = 5; e[3].v = R4 + rsrc;
    e[4].t = RC_C; e[4].a = 5; e[4].b = 4; e[4].v = C2;
    e[5].t = RC_C; e[5].a = 5; e[5].b = 6; e[5].v = C3;
    e[6].t = RC_R; e[6].a = 4; e[6].b = 6; e[6].v = R2 * ll + 1;
    e[7].t = RC_R; e[7].a = 6; e[7].b = 0; e[7].v = R3 * mm + 1;
    e[8].t = RC_R; e[8].a = 3; e[8].b = 0; e[8].v = 1e6f;
    if (circuit_design(f, e, 9, 7, 3, fs) < 0) { f->n = 0; f->b[0] = 1; }
}
static void stage(struct tstage *t, float g, float bias, float hp, float lp, float shf, float shdb)
{
    t->g = g; t->bias = bias; t->s0 = sat(bias);
    bqf_set(&t->hp, F_HP1, hp, 0, 0, FS2);
    bqf_set(&t->lp, F_LP1, lp, 0, 0, FS2);
    t->has_sh = shdb != 0;
    /* condensateur de découplage de cathode : plein gain AU-DESSUS de sa coupure, gain réduit en dessous -> shdb < 0
       (graves moins saturés : son plus serré). Le signe était inversé avant fw6 0.18 (graves gonflés avant la saturation). */
    bqf_set(&t->sh, t->has_sh ? F_LSH : F_THRU, shf, 0.6f, shdb, FS2);
}
static void design_amp(struct cmst *s, int m, const float *p)
{
    float gain = k01(p[0]), bass = k01(p[1]), mid = k01(p[2]), treb = k01(p[3]), pres = k01(p[4]), mast = k01(p[5]), gk = pot_taper(gain, 1);
    float res = 0.5f;
    int i;
    s->kind = 1;
    bqf_set(&s->os.u1, F_LP, 19000, 0.7071f, 0, FS2); bqf_set(&s->os.d1, F_LP, 19000, 0.7071f, 0, FS2);
    for (i = 0; i < NST; i++) stage(&s->st[i], 1, 0, 10, 20000, 0, 0);
    bqf_set(&s->in_hp, F_HP1, 30, 0, 0, FS2);
    s->pa_asym = 0.05f; s->sag = 0.3f; s->bright_g = 0;
    bqf_set(&s->cut, F_THRU, 0, 0, 0, FS1);
    bqf_set(&s->post, F_LP1, 12000, 0, 0, FS1);
    if (m == M_BRIT || m == M_PLEXI) {
        /* JCM800 2203 : V1a (ECC83, grand gain), Pre-amp (avant V1b), V1b « cold clipper » (cathode 10k non découplée :
           forte asymétrie), V2a suiveur de cathode -> tone stack Marshall (33k, 470p, 22n, 22n, 220k / 1M / 25k) ; EL34 */
        int jump = m == M_PLEXI ? (int)(p[6] + 0.5f) : 0;
        s->nst = m == M_PLEXI ? 2 : 3; s->gain_at = 1; s->ts_after = s->nst;
        if (m == M_PLEXI) stage(&s->st[0], 32, 0.15f, 30, 12000, 0, 0);   /* 1959 : 820 ohms / 250 uF, plat dans le registre guitare */
        else stage(&s->st[0], 32, 0.15f, 30, 12000, 90, -8);           /* 2203 V1a : 2,7k / 0,68 uF -> ~-8 dB sous ~90 Hz */
        stage(&s->st[1], m == M_PLEXI ? 28 : 40, m == M_PLEXI ? 0.2f : 0.55f, 80, 9000, 0, 0);
        stage(&s->st[2], 2.5f, 0.35f, 15, 15000, 0, 0);                /* suiveur de cathode : écrête le positif */
        s->gain_in = 0.02f + 2.2f * gk;
        s->bright_g = m == M_PLEXI ? (jump >= 1 ? 1.0f : 0.3f) : 0.7f * (1 - gain);   /* 470 pF sur le potard : brillant à bas gain */
        tmb(&s->stack, 220e3f, 1e6f, 25e3f, 33e3f, 470e-12f, 22e-9f, 22e-9f, 1e3f, treb, mid, bass, FS2);
        s->pa_drive = 0.3f + 3.0f * mast * mast; s->sag = 0.25f; s->pa_asym = 0.08f;
        if (m == M_PLEXI && jump == 2) s->gain_in *= 1.6f;
        s->out = 0.55f;
    } else if (m == M_USCLEAN) {
        /* Twin Reverb (blackface) : V1 -> tone stack Fender (100k, 250p, 100n, 47n, 250k / 250k / 10k) -> Volume -> V2 ;
           6L6 x4 : énorme réserve ; Bright = 120 pF sur le potard de volume */
        s->nst = 2; s->ts_after = 1; s->gain_at = 1;
        stage(&s->st[0], 20, 0.1f, 20, 15000, 0, 0);                   /* 1,5k / 25 uF : coupure ~4 Hz, plat */
        stage(&s->st[1], 16, 0.1f, 20, 14000, 0, 0);
        s->gain_in = 0.03f + 0.9f * gk;
        s->bright_g = (p[6] > 0.5f) ? 1.4f * (1 - gain) + 0.2f : 0;
        tmb(&s->stack, 250e3f, 250e3f, 10e3f, 100e3f, 250e-12f, 100e-9f, 47e-9f, 38e3f, treb, mid, bass, FS2);
        s->pa_drive = 0.15f + 1.2f * mast * mast; s->sag = 0.15f; s->pa_asym = 0.02f;
        s->out = 0.7f;
    } else if (m == M_CHIME) {
        /* AC30 Top Boost : V1 puis étage Top Boost (cascade), tone stack aigus / graves (approché par le TMB à médium fixe) ;
           EL84 classe A (asymétrique, compression) ; Cut = passe-bas variable à l'entrée de l'étage de puissance */
        int tb = (int)(p[6] + 0.5f);
        s->nst = tb ? 3 : 2; s->ts_after = s->nst; s->gain_at = 1;
        stage(&s->st[0], 28, 0.15f, 25, 14000, 0, 0);                  /* cathode bien découplée : plat */
        stage(&s->st[1], tb ? 30 : 18, 0.2f, 60, 12000, 0, 0);
        stage(&s->st[2], 2.5f, 0.3f, 20, 16000, 0, 0);
        s->gain_in = 0.02f + 1.6f * gk;
        tmb(&s->stack, 1e6f, 1e6f, 10e3f, 100e3f, 56e-12f, 22e-9f, 22e-9f, 1e3f, treb, tb ? 0.6f : 0.4f, bass, FS2);
        s->pa_drive = 0.4f + 3.2f * mast * mast; s->sag = 0.35f; s->pa_asym = 0.2f;
        bqf_set(&s->cut, F_LP1, 14000 - 12000 * pres, 0, 0, FS1);       /* Cut : plus on tourne, plus c'est sombre */
        pres = 0.3f;
        s->out = 0.55f;
    } else if (m == M_RECT) {
        /* Dual Rectifier : 4 étages (Modern), 3 (Vintage / Raw), tone stack en fin de préampli (Mesa : 47k, 470p, 22n,
           22n, 250k / 1M / 25k) ; 6L6 ; redresseur à lampe = plus de « sag » */
        int mode = (int)(p[6] + 0.5f), tube = p[7] < 0.5f;
        s->nst = mode == 2 ? 4 : 3; s->ts_after = s->nst; s->gain_at = 1;
        stage(&s->st[0], 35, 0.15f, mode == 2 ? 60 : 30, 12000, 100, -6);   /* découplage partiel : graves moins saturés */
        stage(&s->st[1], 40, 0.3f, mode == 2 ? 120 : 60, 9000, 0, 0);
        stage(&s->st[2], mode == 0 ? 18 : 35, 0.4f, 40, 8000, 0, 0);
        stage(&s->st[3], 30, 0.35f, 50, 7500, 0, 0);
        s->gain_in = 0.02f + (mode == 0 ? 1.2f : 2.4f) * gk;
        tmb(&s->stack, 250e3f, 1e6f, 25e3f, 47e3f, 470e-12f, 22e-9f, 22e-9f, 1e3f, treb, mode == 1 ? 0.4f + 0.6f * mid : mid * (mode == 2 ? 0.7f : 1), bass, FS2);
        s->pa_drive = 0.4f + 2.5f * mast * mast; s->sag = tube ? 0.55f : 0.2f; s->pa_asym = 0.04f;
        s->out = 0.5f;
    } else {
        /* 5150 (canal lead) : coupe-bas d'entrée serré, 4 étages, tone stack après (Fender-like : 47k, 250p, 47n, 22n,
           250k / 250k / 25k), 6L6, Resonance + Presence sur l'étage de puissance */
        s->nst = 4; s->ts_after = 4; s->gain_at = 1;
        stage(&s->st[0], 38, 0.15f, 140, 11000, 0, 0);
        stage(&s->st[1], 42, 0.35f, 100, 8500, 0, 0);
        stage(&s->st[2], 38, 0.4f, 60, 7500, 0, 0);
        stage(&s->st[3], 25, 0.35f, 40, 7000, 0, 0);
        s->gain_in = 0.02f + 2.6f * gk;
        tmb(&s->stack, 250e3f, 250e3f, 25e3f, 47e3f, 250e-12f, 47e-9f, 22e-9f, 1e3f, treb, mid, bass, FS2);
        s->pa_drive = 0.4f + 2.6f * mast * mast; s->sag = 0.25f; s->pa_asym = 0.04f;
        res = k01(p[6]);
        s->out = 0.5f;
    }
    iir_reset(&s->stack);
    bqf_set(&s->pres, F_HSH, 3500, 0.6f, 9 * pres - 2, FS1);
    bqf_set(&s->res, F_LSH, 95, 0.7f, 9 * res - 2, FS1);
    s->att = 1 - expf(-1 / (0.005f * FS1)); s->rel = 1 - expf(-1 / (0.12f * FS1));
}
static inline float amp_nl(struct cmst *s, float x)
{
    int i;
    float v = op1(&s->in_hp, x);
    for (i = 0; i < s->nst; i++) {
        struct tstage *t = &s->st[i];
        if (i == s->gain_at) {                                       /* potard de gain (volume de préampli) */
            float hi = s->bright_g != 0 ? v - op1(&s->st[NST - 1].lp, v) : 0;                /* (filtre libre de l'étage 5 réutilisé : brillant) */
            v = (v + s->bright_g * hi) * s->gain_in;
        }
        v = op1(&t->hp, v);
        if (t->has_sh) v = bqf(&t->sh, v);
        v = sat(v * t->g + t->bias) - t->s0;                         /* triode : asymétrique */
        v = op1(&t->lp, v);
        if (i + 1 == s->ts_after) v = iir_run(&s->stack, v);
    }
    if (s->ts_after == 0) v = iir_run(&s->stack, v);
    return v;
}
/* étage de puissance push-pull (48 kHz) : sag (enveloppe) puis saturation quasi symétrique */
static inline float amp_pa(struct cmst *s, float v)
{
    float a = v < 0 ? -v : v, d;
    s->env += (a > s->env ? s->att : s->rel) * (a - s->env);
    d = s->pa_drive / (1 + s->sag * s->env * 4);
    return sat(d * v + s->pa_asym) - sat(s->pa_asym);
}
static float run_amp(struct cmst *s, float x)
{
    float u0, u1, y;
    u0 = amp_nl(s, bqf(&s->os.u1, 2 * x));                          /* suréchantillonnage x2 du préampli (2e ordre) */
    u1 = amp_nl(s, bqf(&s->os.u1, 0));
    bqf(&s->os.d1, u0);
    y = amp_pa(s, bqf(&s->os.d1, u1));
    if (s->model == M_CHIME) y = op1(&s->cut, y);
    y = bqf(&s->res, bqf(&s->pres, y));
    return op1(&s->post, y) * s->out;
}

/* ================= interface avec engine.c (Q23) ================= */
void cm_design(void *mem, int m, const float *p)
{
    struct cmst *s = (struct cmst *)mem;
    s->model = m;
    /* niveaux alignés : sortie moyenne ~ entrée (+0..+3 dB pour les drives) aux réglages par défaut (dB) */
    s->trim = db2g(m == M_GREEN ? 8.0f : m == M_OD1 ? 8.0f : m == M_SD1 ? 7.0f : m == M_BD2 ? 3.5f : m == M_GOLD ? 7.0f : m == M_GRIT ? 10.5f :
                   m == M_MUFF ? -7.0f : m == M_USCLEAN ? 8.0f : m == M_CHIME ? 1.0f : m == M_BRIT ? -3.0f : m == M_PLEXI ? -3.0f : m == M_RECT ? -2.0f : 0.0f);
    /* Seuil de saturation (distorsion > 3 % à 220 Hz, réglages par défaut) : avant fw6 0.18 les amplis saturaient dès
       -54 (Plexi) à moins de -100 dBFS (Rectifier, 5150), c.-à-d. sur le souffle du convertisseur (-79 dBFS) : son brouillon,
       graves baveux. pad (dB) ramène ce seuil vers : Twin -20, AC30 -36, Plexi -40, JCM800 -46, Rectifier -56, 5150 -58 ;
       makeup (dB, dans trim) garde le niveau de sortie d'avant pour une entrée de -20 dBFS (mesures : tests\e2e\emu\breakup.js). */
    {
        float pad = m == M_USCLEAN ? PAD_USCLEAN : m == M_CHIME ? PAD_CHIME : m == M_PLEXI ? PAD_PLEXI : m == M_BRIT ? PAD_BRIT :
                    m == M_RECT ? PAD_RECT : m == M_LEAD51 ? PAD_LEAD51 : 0;
        float mk = m == M_USCLEAN ? MK_USCLEAN : m == M_CHIME ? MK_CHIME : m == M_PLEXI ? MK_PLEXI : m == M_BRIT ? MK_BRIT :
                   m == M_RECT ? MK_RECT : m == M_LEAD51 ? MK_LEAD51 : 0;
        s->pad = db2g(-pad); s->trim *= db2g(mk);
    }
    if (m == M_GREEN || m == M_GOLD || m == M_GRIT || m == M_OD1 || m == M_SD1 || m == M_BD2 || m == M_MUFF) design_pedal(s, m, p);
    else {
        design_amp(s, m, p);
        bqf_set(&s->st[NST - 1].lp, F_LP1, 1500, 0, 0, FS2);         /* filtre du « brillant » (étage 5 jamais utilisé en ampli à 4 étages max) */
        if (s->nst > NST - 1) s->nst = NST - 1;
    }
}
s32 cm_run(void *mem, s32 xq)
{
    struct cmst *s = (struct cmst *)mem;
    float x = (float)xq * (1.0f / 8388608.0f) * s->pad, y = (s->kind ? run_amp(s, x) : run_pedal(s, x)) * s->trim;
    if (y > 15.9f) y = 15.9f; else if (y < -15.9f) y = -15.9f;
    return (s32)(y * 8388608.0f);
}
