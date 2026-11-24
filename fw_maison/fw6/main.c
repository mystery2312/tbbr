/* fw4 : fw3 + liaison USB MIDI (SysEx) pour l'éditeur et l'installateur.
 * Protocole (proto_sysex, plus bas) : F0 7D 42 58 <cmd> <données 7 bits> F7.
 *
 * fw3 : multi-effet BlackBox (AC791N) en FLASH à 0x2000120 — effets de meilleure qualité + mesure de charge processeur.
 *
 * Audio : ALINK0 16 bits I2S à 48 kHz, entrée canal 1 (PA08, guitare voie GAUCHE), sortie canal 0 (PA07), blocs de 128.
 * Calcul interne en virgule fixe Q23 (1,0 = 2^23 ; entrée 16 bits << 8), filtres biquad Q28 (coefs.h, gen_coefs.py),
 * multiplication-accumulation 64 bits matérielle.
 * Chaîne : coupe-bas 70 Hz -> FX (saturation suréchantillonnée x2) -> AMP (couleur d'ampli) -> CAB (baffle 4x12)
 *          -> MOD (chorus) -> DLY (écho filtré) -> REV (Freeverb) -> volume (potard, courbe progressive) -> limiteur doux.
 * Commandes : boutons d'effet = marche/arrêt ; HOME = LED effets/vumètre ; FS droit = bypass ; FS gauche = UBOOT ;
 *             HOME tenu à l'allumage = UBOOT.
 * Écran : 6 cases (FX, AMP / MOD, DLY / REV, CAB), barre de volume (blanc), barre de CHARGE PROCESSEUR (orange, pire cas ~1 s).
 * Diagnostic en RAM à 0x1C70000. Aucune écriture en flash.
 */
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
typedef unsigned short u16;
typedef short s16;
typedef unsigned char u8;
#include "coefs.h"

#define PORT(x)   ((volatile u32 *)(0x50000u + 0x40u * (x)))
#define PA 0
#define PB 1
#define PC 2
#define PH 7
#define R_OUT 0
#define R_IN  1
#define R_DIR 2
#define R_DIE 3
#define R_PU  4
#define R_PD  5

/* ---------------- carte mémoire ---------------- */
#define DLY_BUF   ((s16 *)0x1C00000u)           /* 65536 échantillons (Q15) = 1,36 s */
#define DLY_MASK  0xFFFFu
#define REV_BUF   ((s32 *)0x1C20000u)           /* réverbe Q23 : 8 peignes + 4 passe-tout (~14 k x 4 o = 56 Ko) ; en 16 bits elle ne s'éteignait pas */
#define CH_BUF    ((s32 *)0x1C30000u)           /* chorus : 2048 échantillons Q23 */
#define CH_MASK   2047u
#define PT_LEN    128u
#define PT_TX     ((volatile u32 *)0x1C50000u)
#define PT_RX     ((volatile u32 *)0x1C52000u)
#define RB        ((volatile u32 *)0x1C70000u)
enum { RB_MAGIC = 0, RB_BOOTS, RB_STAGE, RB_HALVES, RB_EXIT, RB_OVERRUNS, RB_TIMEOUTS, RB_PEAKIN, RB_PEAKOUT, RB_VOLADC,
       RB_LADDER, RB_FXMASK, RB_DRAW, RB_SPINBASE, RB_LOADNOW, RB_LOADMAX };
#define RB_OVERLOADS 20                         /* nombre de coupures pour surcharge (RB[17..19] déjà pris) */
#define FW_MAGIC 0x46573452u                    /* "R4WF" */
#define FW_VERSION "TBBR fw6 0.16"
#define FW_MHZ 396                                      /* horloge processeur (clock.c) */
#include "catalog.h"
#include "engine.h"
const char *const FW_VERSION_STR = FW_VERSION;
void proto_frames_sysex(const u8 *m, u32 n);
void proto_meter(u32 in16, u32 out16);
static u32 meter_in, meter_out, led_pk;                 /* led_pk : crête de sortie pour le vu-mètre des LED */
u32 storage_init(void);
int storage_erase(u32 a);
int storage_write(u32 a, const u8 *src, u32 len);
const u8 *storage_ptr(u32 flash_addr);
u32 storage_errors(void);
void storage_id(u32 *id, u32 *cap);
void usb_midi_init(void);
void usb_midi_poll(void);
int usb_midi_send_sysex(const u8 *m, u32 n);
u32 usb_read_sofframe(int id);
void usb_midi_stats(u32 *o);
extern volatile u32 jiffies;
extern u32 _data_lma[], _data_start[], _data_end[], _bss_start[], _bss_end[];

enum { E_FX = 0, E_AMP, E_MOD, E_DLY, E_REV, E_CAB, E_N };
#define NCOMB 8
#define NAP   4
struct st {
    u32 fx, bypass, ledmode;
    s32 vol, vol_target;                        /* gain de sortie Q12 (1,0 = 4096) : courant (rampe) et cible (potard) */
    s32 bq[BQ_COUNT][4];                        /* états des biquads : x1, x2, y1, y2 */
    u32 dly_wr, ch_wr, ch_lfo;
    s32 rev_filt[NCOMB];
    u32 rev_idx[NCOMB + NAP];
    u32 vu_pk, vu_n, clip;
    u32 bstate[10], bcnt[10];
    u32 ladder, tick, both_cnt, both, hold_l, hold_r, hold_p, enc_prev, master_init;
    s32 enc_acc, enc_pend;
    float master_db;
    /* charge processeur */
    u32 spin, spin_base, spin_min, drew, calib, load, load_win;
    /* batterie (PC09 = batterie / 2, cf. mesure sur la pédale) */
    u32 batt_pct, batt_mv, batt_raw;
    /* USB / Bluetooth */
    u32 usb, sof_last, sof_stable, bt_on, bt_paired, hold_home;
    u32 hold_cat; s32 hold_cat_key;              /* maintien d'une touche FX..CAB = gestion des blocs */
    /* écran */
    u32 dirty, drawing, pix, d_fx, d_bypass, d_bar, d_load;
};
#define S ((struct st *)0x1C71000u)

/* ---------------- watchdog / P33 / sortie vers UBOOT ---------------- */
#define P33_SPI_CON (*(volatile u32 *)0x13E08u)
#define P33_SPI_DAT (*(volatile u32 *)0x13E0Cu)
static u32 p33_xfer(u32 b)
{
    P33_SPI_DAT = b;
    P33_SPI_CON |= 0x10;
    while (P33_SPI_CON & 2) { }
    return P33_SPI_DAT;
}
static void p33_cmd(u32 op, u32 reg, u32 val)  /* op 0x00 = écrire, 0x20 = OU */
{
    P33_SPI_CON &= ~0x100u; P33_SPI_CON |= 0x1u;
    p33_xfer(op); p33_xfer(reg); p33_xfer(val);
    P33_SPI_CON &= ~0x101u;
}
void wdt_clear(void) { p33_cmd(0x20, 0x80, 0x40); }
static void delay(u32 n)
{
    volatile u32 i;
    while (n) {
        u32 k = n > 20000u ? 20000u : n;
        for (i = 0; i < k; i++) { }
        n -= k;
        wdt_clear();
    }
}

/* ---------------- broches, LED, ADC ---------------- */
static void pin_out(int port, int bit, int val)
{
    volatile u32 *p = PORT(port);
    if (val) p[R_OUT] |= (1u << bit); else p[R_OUT] &= ~(1u << bit);
    p[R_DIR] &= ~(1u << bit);
    p[R_DIE] |= (1u << bit);
}
static void pin_in_pullup(int port, int bit)
{
    volatile u32 *p = PORT(port);
    p[R_DIR] |= (1u << bit); p[R_PD] &= ~(1u << bit); p[R_PU] |= (1u << bit); p[R_DIE] |= (1u << bit);
}
static void pin_analog(int port, int bit)
{
    volatile u32 *p = PORT(port);
    p[R_DIR] |= (1u << bit); p[R_DIE] &= ~(1u << bit); p[R_PU] &= ~(1u << bit); p[R_PD] &= ~(1u << bit);
}
static void hc595_write(u32 v)
{
    volatile u32 *pc = PORT(PC);
    volatile u32 t;
    int i;
    pc[R_OUT] &= ~(1u << 6);
    for (i = 7; i >= 0; i--) {
        pc[R_OUT] &= ~(1u << 5);
        if (v & (1u << i)) pc[R_OUT] &= ~(1u << 8); else pc[R_OUT] |= (1u << 8);
        for (t = 0; t < 40; t++) { }
        pc[R_OUT] |= (1u << 5);
        for (t = 0; t < 40; t++) { }
    }
    pc[R_OUT] |= (1u << 6);
}
static void leds_init(void) { pin_out(PC, 5, 1); pin_out(PC, 6, 0); pin_out(PC, 8, 0); pin_out(PC, 7, 0); }

#define ADC_CON (*(volatile u32 *)0x13100u)
#define ADC_RES (*(volatile u32 *)0x13104u)
static u32 adc_read(u32 ch)
{
    u32 t, r;
    ADC_CON = 0x6u | (0xFu << 12) | (1u << 3) | (1u << 6) | ((ch & 0xF) << 8);
    ADC_CON |= (1u << 4);
    ADC_CON |= (1u << 6);
    for (t = 0; t < 20000; t++) if (ADC_CON & (1u << 7)) break;
    r = (t < 20000) ? (ADC_RES & 0xFFFF) : 0xFFFFu;
    ADC_CON = (1u << 6);
    ADC_CON = 0;
    return r;
}

/* pourcentage d'une Li-ion 3,7 V à partir de la tension (table interpolée) */
static int batt_pct(u32 mv)
{
    static const u16 t[10][2] = {
        { 4200, 100 }, { 4100, 90 }, { 4000, 80 }, { 3900, 65 }, { 3800, 50 },
        { 3700, 35 }, { 3600, 20 }, { 3500, 10 }, { 3400, 5 }, { 3300, 0 }
    };
    int i;
    if (mv >= 4200) return 100;
    for (i = 1; i < 10; i++) if (mv >= t[i][0]) {
        int a = (int)t[i - 1][0], b = (int)t[i][0];
        int pa = (int)t[i - 1][1], pb = (int)t[i][1];
        return pb + ((int)mv - b) * (pa - pb) / (a - b);
    }
    return 0;
}

static void go_uboot(u32 reason)
{
    volatile u32 *d = (volatile u32 *)0x1C7FD80u;
    RB[RB_EXIT] = reason;
    hc595_write(0);
    d[0] = 0x5F627375u; d[1] = 0x61647075u; d[2] = 0x6D5F6574u; d[3] = 0x0065646Fu;   /* "usb_update_mode\0" */
    __asm__ volatile ("cli");
    p33_cmd(0x20, 0xA0, 0x10);
    for (;;) { }
}

/* ---------------- écran ST7789 ---------------- */
#define LCD_CS  1
#define LCD_DC  5
#define LCD_SCK 6
#define LCD_SDA 7
#define LCD_OUT (PORT(PB)[R_OUT])
static void lcd_byte(u32 v)
{
    volatile u32 *out = &LCD_OUT;
    int i;
    for (i = 7; i >= 0; i--) {
        *out &= ~(1u << LCD_SCK);
        if (v & (1u << i)) *out |= (1u << LCD_SDA); else *out &= ~(1u << LCD_SDA);
        *out |= (1u << LCD_SCK);
    }
    *out |= (1u << LCD_SDA);
}
static void lcd_cmd(u32 c, const u8 *d, int n)
{
    int i;
    LCD_OUT &= ~(1u << LCD_CS);
    LCD_OUT &= ~(1u << LCD_DC); lcd_byte(c);
    LCD_OUT |= (1u << LCD_DC);
    for (i = 0; i < n; i++) lcd_byte(d[i]);
    LCD_OUT |= (1u << LCD_CS);
}
/* envoi rapide de pixels (données, CS déjà bas) : 2 écritures du port par bit, sans relecture (l'ancienne version faisait
   3 lectures-modifications-écritures par bit : ~230 ns par bit, 215 ms de processeur par image). Mode 3 : donnée posée
   avec l'horloge basse, lue au front montant. */
static void lcd_px_fast(const u16 *px, int n)
{
    volatile u32 *out = &LCD_OUT;
    const u32 lo = (*out | (1u << LCD_DC)) & ~((1u << LCD_CS) | (1u << LCD_SCK) | (1u << LCD_SDA)), hi = lo | (1u << LCD_SCK);
    int i;
    for (i = 0; i < n; i++) {
        const u32 v = px[i];
#define LB(b) { const u32 d = ((v >> (b)) & 1u) << LCD_SDA; *out = lo | d; *out = hi | d; }
        LB(15) LB(14) LB(13) LB(12) LB(11) LB(10) LB(9) LB(8) LB(7) LB(6) LB(5) LB(4) LB(3) LB(2) LB(1) LB(0)
#undef LB
    }
    *out = hi | (1u << LCD_SDA);
}
static void lcd_cmd1(u32 c, u32 v) { u8 b = (u8)v; lcd_cmd(c, &b, 1); }
static const u8 lcd_porch[5] = { 0x0C, 0x0C, 0x0C, 0x00, 0x33 };
static const u8 lcd_gam[14]  = { 0xD0, 0x0D, 0x14, 0x0B, 0x0B, 0x07, 0x3A, 0x44, 0x50, 0x08, 0x13, 0x13, 0x2D, 0x32 };
static const u8 lcd_pwr[2]   = { 0xA6, 0xA1 };
static const u8 lcd_full[4]  = { 0, 0, 0, 239 };
static void lcd_init(void)
{
    pin_out(PB, LCD_CS, 1); pin_out(PB, LCD_DC, 1); pin_out(PB, LCD_SCK, 1); pin_out(PB, LCD_SDA, 1);
    lcd_cmd(0x01, 0, 0); delay(3000000);
    lcd_cmd(0x11, 0, 0); delay(3000000);
    lcd_cmd(0xB2, lcd_porch, 5);
    lcd_cmd1(0xB7, 0x56); lcd_cmd1(0xBB, 0x18); lcd_cmd1(0xC0, 0x2C); lcd_cmd1(0xC2, 0x01);
    lcd_cmd1(0xC3, 0x1F); lcd_cmd1(0xC4, 0x20); lcd_cmd1(0xC6, 0x0F);
    lcd_cmd(0xD0, lcd_pwr, 2);
    lcd_cmd(0xE0, lcd_gam, 14);
    lcd_cmd(0xE1, lcd_gam, 14);
    lcd_cmd1(0x36, 0x00); lcd_cmd1(0x3A, 0x55); lcd_cmd1(0x51, 0xFF);
    lcd_cmd(0x21, 0, 0);
    /* 0x29 (affichage) : après le logo (lcd_splash), sinon la mémoire de l'écran (aléatoire) s'affiche ~0,5 s */
}
/* ---------------- écran : rendu de ui.c (portage de ecran.js), envoyé ligne par ligne dans le temps libre ---------------- */
#include "gfx.h"
void ui_build(void); int ui_dirty(void); void ui_touch(void); u32 ui_leds(void);
void ui_key(int k); void ui_key_hold(int k); void ui_para_turn(int d); void ui_para_press(void); void ui_para_hold(void);
int ui_tap_led(void);
void ui_master(float db); void ui_tuner(int on); int ui_tuner_on(void); void ui_tick(int ms);
void ui_battery(int pct);
void ui_usb(int on); void ui_bt_set(int on, int paired); int ui_bt_on(void); void ui_msg_bt(int on);
static u16 rowbuf[240];
static u32 d_engver;
/* rendu sur le 2e cœur (core1.c) s'il tourne : le 1er cœur ne fait qu'envoyer les morceaux modifiés */
int core1_alive(void); void core1_render_start(void); const u16 *core1_render_peek(u32 *hash); void core1_render_pop(void);
static u32 r_c1;                                                    /* image en cours rendue par le 2e cœur */
static void lcd_frame_start(void)
{
    d_engver = engine_version();
    ui_build();
    S->pix = 0; S->drawing = 1; S->dirty = 0;                       /* pix = ligne en cours */
    RB[21] = RB[RB_HALVES];                                         /* début de l'image (mesure de durée) */
    r_c1 = core1_alive();
    if (r_c1) core1_render_start();
}
/* un quart de ligne (60 pixels) par appel : rendu (gfx) puis envoi, CS relâché après chaque morceau (RAMWR 0x2C puis RAMWRC 0x3C).
   S->pix = numéro du morceau (4 par ligne). Morceaux courts : l'audio n'attend jamais l'écran. */
#define SPAN 60
/* empreinte de chaque morceau déjà affiché : un morceau identique à l'image précédente n'est pas renvoyé
   (tourner un potard ne change que quelques morceaux). span_ok = 0 : tout renvoyer (démarrage). */
static u32 span_sum[240 * 4] __attribute__((section(".gfxbss")));
static u32 span_ok;
static void lcd_step(void)
{
    u32 k, y = S->pix / 4, xa = (S->pix & 3) * SPAN, h = 0x811C9DC5u;
    const u16 *px;
    if (r_c1) {                                                     /* morceau rendu par le 2e cœur (sinon : revenir plus tard) */
        px = core1_render_peek(&h);
        if (!px) return;
    } else {
        gfx_render_span((int)y, (int)xa, (int)(xa + SPAN), rowbuf);
        for (k = xa; k < xa + SPAN; k++) h = (h ^ rowbuf[k]) * 16777619u;
        px = rowbuf + xa;
    }
    if (!span_ok || span_sum[S->pix] != h) {
        u8 ca[4], ra[4];
        span_sum[S->pix] = h;
        ca[0] = 0; ca[1] = (u8)xa; ca[2] = 0; ca[3] = (u8)(xa + SPAN - 1);
        ra[0] = 0; ra[1] = (u8)y; ra[2] = 0; ra[3] = (u8)y;
        lcd_cmd(0x2A, ca, 4); lcd_cmd(0x2B, ra, 4);
        LCD_OUT &= ~(1u << LCD_CS);
        LCD_OUT &= ~(1u << LCD_DC); lcd_byte(0x2C);
        lcd_px_fast(px, SPAN);
        LCD_OUT |= (1u << LCD_CS);
    }
    if (r_c1) core1_render_pop();
    if (S->pix == 240 * 4 - 1) span_ok = 1;
    if (++S->pix >= 240 * 4) { S->drawing = 0; RB[22] = RB[RB_HALVES] - RB[21]; RB[23] += 1; }   /* durée de l'image (blocs de 2,67 ms), nombre d'images */
}

/* logo de démarrage (ui_splash) écrit dans la mémoire de l'écran, puis affichage allumé (0x29) : plus d'image aléatoire */
static void lcd_splash(void)
{
    void ui_splash(void), wdt_clear(void);
    ui_splash();
    r_c1 = 0; span_ok = 0; S->pix = 0; S->drawing = 1;
    while (S->drawing) { lcd_step(); if ((S->pix & 63) == 0) wdt_clear(); }
    lcd_cmd(0x29, 0, 0);
}

/* ---------------- audio : ALINK0 ---------------- */
#define ALNK(off)  (*(volatile u32 *)(0x12E00u + (off)))
#define IOMAP_CON5 (*(volatile u32 *)0x51030u)
#define PLL_CON1   (*(volatile u32 *)0x119A4u)
#define CLK_CON2   (*(volatile u32 *)0x10014u)
static void audio_start(void)
{
    u32 i;
    for (i = 0; i < 2 * PT_LEN; i++) { PT_TX[i] = 0; PT_RX[i] = 0; }
    pin_out(PA, 4, 1); pin_out(PA, 6, 1); pin_out(PA, 5, 1);
    pin_out(PA, 7, 0);
    PORT(PA)[R_DIR] |= (1u << 8); PORT(PA)[R_DIE] |= (1u << 8); PORT(PA)[R_PU] &= ~(1u << 8); PORT(PA)[R_PD] &= ~(1u << 8);
    pin_out(PA, 9, 0);
    IOMAP_CON5 &= ~(1u << 7);
    IOMAP_CON5 |= (1u << 6);
    ALNK(0x00) = 0; ALNK(0x04) = 0; ALNK(0x0C) = 0; ALNK(0x20) = 0;
    ALNK(0x10) = 0; ALNK(0x14) = 0; ALNK(0x18) = 0; ALNK(0x1C) = 0;
    ALNK(0x0C) |= 3;
    ALNK(0x00) |= 0x80 | 0x100;
    ALNK(0x00) &= ~0x40u;
    ALNK(0x04) &= ~(1u << 3);
    ALNK(0x04) |= (1u << 7);
    ALNK(0x10) = (u32)PT_TX;
    ALNK(0x14) = (u32)PT_RX;
    ALNK(0x20) = PT_LEN;
    ALNK(0x00) |= 0x800;
    PLL_CON1 |= (1u << 25);
    CLK_CON2 |= 0x100;
    ALNK(0x0C) = (ALNK(0x0C) & 0xE3u & 0x1Fu) | (4u << 5);
    ALNK(0x08) |= 3;
    ALNK(0x04) |= 1u | (1u << 4);
    delay(1500000);
    PORT(PA)[R_OUT] |= (1u << 9);
    delay(1500000);
}

/* ---------------- DSP (Q23) ---------------- */
#define ONE (1 << 23)
static s32 sat16(s32 v) { return v > 32767 ? 32767 : (v < -32768 ? -32768 : v); }
static s32 iabs(s32 v) { return v < 0 ? -v : v; }
static inline s32 mulq15(s32 x, s32 g) { return (s32)(((s64)x * g) >> 15); }

static s32 bq(u32 i, s32 x)
{
    const s32 *c = bq_coef[i];
    s32 *z = S->bq[i];
    s64 acc = (s64)c[0] * x + (s64)c[1] * z[0] + (s64)c[2] * z[1] - (s64)c[3] * z[2] - (s64)c[4] * z[3];
    s32 y = (s32)(acc >> 28);
    z[1] = z[0]; z[0] = x; z[3] = z[2]; z[2] = y;
    return y;
}
/* saturation : table sur [-4, 4], interpolation linéaire */
static s32 shaper(s32 x)
{
    s32 t = x + 4 * ONE, d;
    u32 i, f;
    if (t < 0) t = 0;
    if (t >= 8 * ONE) t = 8 * ONE - 1;
    i = (u32)t >> 17; f = (u32)t & 0x1FFFF;
    d = sat_tab[i + 1] - sat_tab[i];
    return sat_tab[i] + (s32)(((s64)d * f) >> 17);
}
static s32 drive(s32 x)
{
    s32 u0, u1, y;
    x = bq(BQ_DRV_PRE_HP, x);
    x = bq(BQ_DRV_PRE_MID, x);
    x *= 20;                                                        /* gain (marge : x * 2 * 20 < 2^31 après +7 dB) */
    u0 = bq(BQ_OS_UP2, bq(BQ_OS_UP1, x * 2));                       /* suréchantillonnage x2 : insertion de zéros + filtre */
    u1 = bq(BQ_OS_UP2, bq(BQ_OS_UP1, 0));
    u0 = shaper(u0); u1 = shaper(u1);
    bq(BQ_OS_DN2, bq(BQ_OS_DN1, u0));
    y = bq(BQ_OS_DN2, bq(BQ_OS_DN1, u1));                           /* décimation : un échantillon sur deux */
    y = bq(BQ_DRV_POST_LP, y);
    y = bq(BQ_DRV_POST_HP, y);
    return mulq15(y, 13107);                                        /* x 0,4 : niveau proche du son clair */
}
static s32 amp(s32 x) { return bq(BQ_AMP_TREB, bq(BQ_AMP_MID, bq(BQ_AMP_BASS, x))); }
static s32 cab(s32 x)
{
    x = bq(BQ_CAB_HP, x); x = bq(BQ_CAB_RES, x); x = bq(BQ_CAB_DIP, x); x = bq(BQ_CAB_PRES, x);
    return bq(BQ_CAB_LP2, bq(BQ_CAB_LP1, x));
}
static s32 chorus(s32 x)                                            /* 7 ms ± 2 ms, 0,8 Hz, interpolation linéaire */
{
    u32 ph, tri, dpos, rd, i0, i1, fr;
    s32 a, b, wet;
    CH_BUF[S->ch_wr] = x;
    ph = (S->ch_lfo += 71583u) >> 16;
    tri = ph < 32768 ? ph * 2 : (65535 - ph) * 2;                   /* 0..65534 */
    dpos = (240u << 16) + tri * 192u;                               /* 5..9 ms en Q16 */
    rd = (S->ch_wr << 16) - dpos;
    i0 = (rd >> 16) & CH_MASK; i1 = (i0 + 1) & CH_MASK; fr = rd & 0xFFFF;     /* entre floor(p) et l'échantillon suivant */
    a = CH_BUF[i0]; b = CH_BUF[i1];
    wet = a + (s32)(((s64)(b - a) * fr) >> 16);
    S->ch_wr = (S->ch_wr + 1) & CH_MASK;
    return mulq15(x, 23170) + mulq15(wet, 23170);                   /* 0,707 x (sec + modulé) */
}
static s32 echo(s32 x)                                              /* 400 ms, rétroaction 38 % filtrée */
{
    u32 w = S->dly_wr;
    s32 d = (s32)DLY_BUF[(w - 19200u) & DLY_MASK] << 8, f;
    f = bq(BQ_DLY_HP, bq(BQ_DLY_LP, d));
    DLY_BUF[w] = (s16)sat16((x + mulq15(f, 12452)) >> 8);
    S->dly_wr = (w + 1) & DLY_MASK;
    return x + mulq15(f, 14745);
}
static const u16 rev_len[NCOMB + NAP] = { 1215, 1293, 1390, 1476, 1548, 1623, 1695, 1760, 605, 480, 371, 245 };
static u32 rev_off(u32 k) { u32 o = 0, i; for (i = 0; i < k; i++) o += rev_len[i]; return o; }
static s32 reverb(s32 x)                                            /* Freeverb mono : pièce 0,84, amortissement 0,2 */
{
    s32 in = mulq15(bq(BQ_REV_HP, x), 1311), sum = 0, y;           /* Q23, gain 0,04 */
    u32 k, off = 0;
    for (k = 0; k < NCOMB; k++) {
        s32 *b = REV_BUF + off;
        u32 i = S->rev_idx[k];
        s32 o = b[i];
        S->rev_filt[k] = mulq15(o, 26214) + mulq15(S->rev_filt[k], 6554);
        b[i] = in + mulq15(S->rev_filt[k], 27525);
        if (++i >= rev_len[k]) i = 0;
        S->rev_idx[k] = i;
        sum += o;
        off += rev_len[k];
    }
    y = sum;
    for (k = NCOMB; k < NCOMB + NAP; k++) {
        s32 *b = REV_BUF + off;
        u32 i = S->rev_idx[k];
        s32 o = b[i];
        b[i] = y + (o >> 1);
        y = o - y;
        if (++i >= rev_len[k]) i = 0;
        S->rev_idx[k] = i;
        off += rev_len[k];
    }
    return x + mulq15(y, 19661);                                    /* mélange 0,6 */
}
/* limiteur doux : linéaire jusqu'à 0,75, puis 0,75 + 0,25 tanh((|x| - 0,75) / 0,25) */
#define KNEE (ONE * 3 / 4)
static s32 limiter(s32 x)
{
    s32 a = iabs(x), over, y;
    u32 i, f;
    if (a <= KNEE) return x;
    S->clip = 60;
    over = (a - KNEE) * 4;                                          /* Q23, table sur [0, 4] pas 1/64 */
    if (over >= 4 * ONE) over = 4 * ONE - 1;
    i = (u32)over >> 17; f = (u32)over & 0x1FFFF;
    y = lim_tab[i] + (s32)(((s64)(lim_tab[i + 1] - lim_tab[i]) * f) >> 17);
    y = KNEE + (y >> 2);
    return x < 0 ? -y : y;
}
static s32 process(s32 x)
{
    x = bq(BQ_IN_HP, x);
    if (!S->bypass) x = engine_process(x);                          /* grille de l'app (engine.c) */
    if (ui_tuner_on()) return 0;                                    /* accordeur : sortie coupée (défaut de la maquette) */
    x = (s32)(((s64)x * S->vol) >> 12);                              /* MASTER */
    return limiter(x);
}

static s32 blk[PT_LEN];
static u32 ov_blocks, ov_win, overload, overload_ver, overload_shown;   /* garde-fou de surcharge (process_half) */

/* Gate d'entrée global (anti-souffle, 2026-11-22) : sans Gate dans le preset, un ampli à fort gain amplifie le souffle du
   convertisseur (≈ -79 dBFS en |x| moyen, crête -66 dBFS) jusqu'à -41 dBFS en sortie. Seuils sur la somme des |x| d'un bloc
   de 128 échantillons 16 bits (0 dBFS = 32768 x 128) ; hystérésis 4 dB, maintien ~120 ms, fermeture en ~50 ms, ouverture
   dans le bloc. Réglage global (app) mémorisé par proto.c ; défaut : actif, -68 dB. */
static volatile u32 ig_open = 1665, ig_close = 1050;                   /* 0 = désactivé */
static volatile u32 flash_grace;
void main_audio_grace(void) { flash_grace = 1; }                        /* storage.c : après chaque effacement / écriture flash */
static s32 ig_gain = 32768;
static u32 ig_hold, ig_isopen = 1;
void main_set_in_gate(int on, int db)
{
    u32 t = 32768u << 7;
    int d;
    if (!on) { ig_open = 0; ig_close = 0; return; }
    if (db > -40) db = -40;
    if (db < -90) db = -90;
    for (d = 0; d < -db; d++) t = (u32)(((s64)t * 29205) >> 15);     /* -1 dB par pas */
    ig_close = (u32)(((s64)t * 20675) >> 15);                       /* -4 dB */
    ig_open = t;
}
static u32 process_half(void)
{
    u32 half, i, pin = 0;
    s32 step;
    volatile u32 *src, *dst;
    ALNK(0x08) |= 2;
    if (ALNK(0x08) & (1u << 4)) ALNK(0x08) |= 1;
    half = (ALNK(0x00) & (1u << 13)) ? 0 : 1;
    src = PT_RX + half * PT_LEN; dst = PT_TX + half * PT_LEN;
    if (S->calib) {                                                 /* mesure de référence : aucun calcul */
        for (i = 0; i < PT_LEN; i++) dst[i] = 0;
        return 0;
    }
    step = (S->vol_target - S->vol) >> 7;                           /* rampe de volume sur les 128 échantillons du bloc */
    {   /* moteur par bloc (permet le NAM sur le 2e cœur) */
        void engine_process_block(s32 *buf, int n);
        /* voie guitare : selon l'instant du démarrage de l'ALINK, le convertisseur d'entrée arrive dans la moitié basse OU
           haute du mot stéréo (constaté sur la pédale B, au hasard des allumages). On lit la moitié qui porte le signal :
           bascule seulement si la moitié lue est « morte » (voie vide, |x| moyen < 8) et l'autre nettement plus forte. */
        static u32 in_hi, e_lo, e_hi, sel_n;
        u32 s_lo = 0, s_hi = 0;
        for (i = 0; i < PT_LEN; i++) { s_lo += (u32)iabs((s16)(src[i] & 0xFFFF)); s_hi += (u32)iabs((s16)(src[i] >> 16)); }
        e_lo += ((s32)s_lo - (s32)e_lo) >> 4; e_hi += ((s32)s_hi - (s32)e_hi) >> 4;     /* lissage ~40 ms */
        if (++sel_n >= 94) {                                         /* décision ~4 fois par seconde */
            u32 cur = in_hi ? e_hi : e_lo, oth = in_hi ? e_lo : e_hi;
            sel_n = 0;
            if (cur < 8u * PT_LEN && oth > 3u * cur + 4u * PT_LEN) { in_hi ^= 1; RB[24] = in_hi | ((RB[24] + 2) & ~1u); }   /* RB[24] : bit 0 = moitié haute, reste = bascules */
        }
        for (i = 0; i < PT_LEN; i++) { s32 l = in_hi ? (s16)(src[i] >> 16) : (s16)(src[i] & 0xFFFF); u32 a = (u32)iabs(l); if (a > pin) pin = a; blk[i] = bq(BQ_IN_HP, l << 8); }
        {   /* gate d'entrée global (voir main_set_in_gate) ; ouvert d'office pendant l'accordeur */
            u32 sg = in_hi ? s_hi : s_lo, op = ig_open, cl = ig_close;
            s32 g0 = ig_gain, g1;
            if (!op || ui_tuner_on()) { ig_isopen = 1; ig_hold = 0; }
            else if (sg >= op) { ig_isopen = 1; ig_hold = 45; }
            else if (ig_isopen && sg >= cl) ig_hold = 45;
            else if (ig_hold) ig_hold--;
            else ig_isopen = 0;
            g1 = ig_isopen ? 32768 : (g0 > 1725 ? g0 - 1725 : 0);
            if (g0 != 32768 || g1 != 32768)
                for (i = 0; i < PT_LEN; i++) blk[i] = (s32)(((s64)blk[i] * (g0 + (((g1 - g0) * (s32)i) >> 7))) >> 15);
            ig_gain = g1;
            RB[25] = ig_isopen | (sg << 1);                           /* RB[25] : bit 0 = gate ouvert, reste = somme |x| du bloc */
        }
        if (ui_tuner_on()) { void tuner_feed(const s32 *b, u32 n); tuner_feed(blk, PT_LEN); }   /* accordeur : sortie coupée, effets suspendus */
        else if (!S->bypass && !overload) engine_process_block(blk, PT_LEN);
        for (i = 0; i < PT_LEN; i++) {
            s32 x = blk[i];
            S->vol += step;
            if (ui_tuner_on()) x = 0;                                /* accordeur : sortie coupée (défaut de la maquette) */
            blk[i] = limiter((s32)(((s64)x * S->vol) >> 12)) >> 8;  /* MASTER + limiteur */
        }
    }
    for (i = 0; i < PT_LEN; i++) {
        s32 o = blk[i];
        o = sat16(o);
        if ((u32)iabs(o) > meter_out) meter_out = (u32)iabs(o);
        if ((u32)iabs(o) > led_pk) led_pk = (u32)iabs(o);
        dst[i] = ((u32)(u16)o << 16) | (u16)o;
    }
    S->vol = S->vol_target;
    if (pin > meter_in) meter_in = pin;
    if (pin > RB[RB_PEAKIN]) RB[RB_PEAKIN] = pin;
    if (ALNK(0x08) & (1u << 5)) { RB[RB_OVERRUNS] += 1; ov_win += 1; }
    { u32 engine_c1_timeouts(void); static u32 last_c1; u32 t = engine_c1_timeouts(); if (t != last_c1) { ov_win += t - last_c1; last_c1 = t; } }   /* 2e cœur en retard */
    /* garde-fou : plus de 3 retards sur 1 024 blocs (~2,7 s) = surcharge -> effets coupés (son direct) jusqu'au prochain
       changement du moteur. Les ~0,7 s qui suivent un changement (pic de calcul des coefficients, ~5 retards) sont ignorées. */
    {
        u32 engine_version(void), v = engine_version();
        static u32 last_ver, grace;
        if (v != last_ver) { last_ver = v; grace = 256; ov_win = 0; ov_blocks = 0; }
        if (flash_grace) { flash_grace = 0; if (grace < 128) grace = 128; ov_win = 0; }   /* accès flash (storage.c) : ~0,34 s ignorées */
        if (grace) { grace--; ov_win = 0; }
        if (++ov_blocks >= 1024) { ov_blocks = 0; ov_win = 0; }
        if (!overload && ov_win > 3) { overload = 1; overload_ver = v; ov_win = 0; RB[RB_OVERLOADS] += 1; }
    }
    return pin;
}

/* ---------------- boutons / LED ---------------- */
enum { B_FX = 0, B_AMP, B_MOD, B_DLY, B_REV, B_CAB, B_HOME, B_FSL, B_FSR, B_PARA, B_NB };
static u32 raw_buttons(void)
{
    u32 pa = PORT(PA)[R_IN], ph = PORT(PH)[R_IN], m = 0, k = S->ladder;
    if (!(pa >> 0 & 1)) m |= 1u << B_FX;
    if (!(ph >> 9 & 1)) m |= 1u << B_AMP;
    if (!(ph >> 8 & 1)) m |= 1u << B_MOD;
    if (k > 679 && k <= 719) m |= 1u << B_DLY;
    if (k > 719 && k <= 819) m |= 1u << B_REV;
    if (k > 589 && k <= 679) m |= 1u << B_CAB;
    if (!(pa >> 1 & 1)) m |= 1u << B_HOME;
    if (!(pa >> 3 & 1)) m |= 1u << B_FSL;
    if (!(pa >> 2 & 1)) m |= 1u << B_FSR;
    if (!(ph >> 6 & 1)) m |= 1u << B_PARA;                          /* appui de l'encodeur PARA (PH06) */
    return m;
}
/* encodeur PARA : A/B = PC00/PC01 (quadrature), un cran = 4 transitions ; appelé souvent (boucle et blocs audio) */
static const signed char ENC_T[16] = { 0, -1, 1, 0, 1, 0, 0, -1, -1, 0, 0, 1, 0, 1, -1, 0 };
static void encoder_poll(void)
{
    u32 s = PORT(PC)[R_IN] & 3u;
    if (s == S->enc_prev) return;
    S->enc_acc += ENC_T[(S->enc_prev << 2) | s];
    S->enc_prev = s;
    if (s == 3) {                                                    /* position de repos : un cran complet */
        if (S->enc_acc >= 2) S->enc_pend++; else if (S->enc_acc <= -2) S->enc_pend--;
        S->enc_acc = 0;
    }
}
static u32 button_events(void)
{
    u32 raw = raw_buttons(), ev = 0, b;
    for (b = 0; b < B_NB; b++) {
        u32 now = raw >> b & 1;
        if (now == S->bstate[b]) { S->bcnt[b] = 0; continue; }
        if (++S->bcnt[b] >= 6) { S->bstate[b] = now; S->bcnt[b] = 0; if (now) ev |= 1u << b; }
    }
    return ev;
}
static const u8 led_of_fx[E_N] = { 1, 2, 3, 4, 5, 6 };
static u32 vu_mask(u32 pk)
{
    static const u16 th[8] = { 40, 100, 250, 600, 1500, 3500, 8000, 18000 };
    u32 m = 0, k;
    for (k = 0; k < 8; k++) if (pk >= th[k]) m |= 1u << k;
    return m;
}
/* MASTER : potard -> -60..+6 dB (ecran.js), gain Q12 (1,0 = 4096) */
float powf(float, float);
#define HOLD_FS   206u                                               /* 550 ms en blocs audio de 2,67 ms */
#define HOLD_PARA 225u                                               /* 600 ms */
static void fs_action(int right, int hold)                           /* modes Preset / Scène / Stomp de la maquette (proto.c) */
{
    int proto_fs(int i, int hold, u32 ms);
    if (ui_tuner_on()) { ui_tuner(0); return; }
    if (proto_fs(right, hold, S->tick * 8 / 3)) ui_tuner(1);
    ui_touch();
}
/* ---------------- USB / Bluetooth ---------------- */
void proto_bt_store(int on, int paired);
void proto_notify_bt(int state);
static void bt_hw_enable(int on) { (void)on; }                       /* pile Bluetooth : à brancher ici */
void proto_bt_set(int on, int paired)
{
    S->bt_on = on ? 1u : 0u;
    S->bt_paired = (on && paired) ? 1u : 0u;
    bt_hw_enable(on);
    ui_bt_set((int)S->bt_on, (int)S->bt_paired);
    proto_bt_store((int)S->bt_on, (int)S->bt_paired);
    proto_notify_bt((int)(S->bt_paired ? 2 : (S->bt_on ? 1 : 0)));
}
static void bt_toggle(void)
{
    int on = !S->bt_on;
    proto_bt_set(on, 0);
    ui_msg_bt(on);
}
static void housekeeping(u32 pk)
{
    u32 ev, e;
    (void)pk;
    S->tick++;
    encoder_poll();
    if ((S->tick & 3) == 0) S->ladder = adc_read(9);
    if ((S->tick & 255) == 200) {                                   /* USB actif = les trames SOF de l'hôte avancent */
        u32 sof = usb_read_sofframe(0);
        if (sof != S->sof_last) { S->sof_last = sof; S->sof_stable = 0; }
        else if (S->sof_stable < 8) S->sof_stable++;
        {
            u32 u = S->sof_stable < 3;                              /* ~2 s sans SOF : USB débranché */
            if (u != S->usb) { S->usb = u; ui_usb((int)u); }
        }
    }
    if ((S->tick & 255) == 100) {                                    /* batterie : PC09 = VBAT / 2, ~0,7 s */
        u32 raw = (adc_read(8) + adc_read(8) + adc_read(8) + adc_read(8)) >> 2;
        u32 mv = raw * 6600u / 1023u;
        int p;
        S->batt_raw = raw;
        S->batt_mv = S->batt_mv ? (S->batt_mv * 7 + mv) / 8 : mv;   /* lissage lent */
        p = batt_pct(S->batt_mv);
        if ((u32)p != S->batt_pct) { S->batt_pct = (u32)p; ui_battery(p); }
    }
    if ((S->tick & 7) == 2) {                                       /* MASTER toutes les ~21 ms */
        u32 v = adc_read(2);
        float t = v > 31 ? (float)(v - 31) / 962.0f : 0, db;
        RB[RB_VOLADC] = v;
        if (t > 1) t = 1;
        db = (float)(int)((-60.0f + 66.0f * t) * 2 + (t > 0 ? 0.5f : -0.5f)) / 2;   /* pas de 0,5 dB */
        S->vol_target = t <= 0.002f ? 0 : (s32)(4096.0f * powf(10.0f, db / 20.0f));
        if (db != S->master_db) { if (S->master_init) ui_master(db); S->master_db = db; S->master_init = 1; }
    }
    RB[RB_LADDER] = S->ladder;
    ev = button_events();
    /* encodeur PARA : crans, appui (relâché avant 600 ms), maintien (bypass) */
    while (S->enc_pend > 0) { ui_para_turn(-1); S->enc_pend--; }     /* sens inversé : horaire = suivant (retour utilisateur) */
    while (S->enc_pend < 0) { ui_para_turn(1); S->enc_pend++; }
    if (S->bstate[B_PARA]) { if (++S->hold_p == HOLD_PARA) ui_para_hold(); }
    else { if (S->hold_p && S->hold_p < HOLD_PARA) ui_para_press(); S->hold_p = 0; }
    /* footswitchs : appui / maintien ; G + D = accordeur ; G + D tenus 3 s = mode mise à jour (installateur) */
    if (S->bstate[B_FSL] && S->bstate[B_FSR]) {
        if (!S->both) { S->both = 1; ui_tuner(!ui_tuner_on()); }
        if (++S->both_cnt > 1125) go_uboot(1);
        S->hold_l = S->hold_r = 0x8000;                              /* pas d'action simple au relâchement */
    } else {
        S->both_cnt = 0; if (!S->bstate[B_FSL] && !S->bstate[B_FSR]) S->both = 0;
        if (S->bstate[B_FSL]) { if (++S->hold_l == HOLD_FS) fs_action(0, 1); } else { if (S->hold_l && S->hold_l < HOLD_FS) fs_action(0, 0); S->hold_l = 0; }
        if (S->bstate[B_FSR]) { if (++S->hold_r == HOLD_FS) fs_action(1, 1); } else { if (S->hold_r && S->hold_r < HOLD_FS) fs_action(1, 0); S->hold_r = 0; }
    }
    /* touches HOME FX AMP MOD DLY REV CAB : pages (ecran.js) */
    if (ev & (1u << B_HOME)) ui_key(0);
    for (e = 0; e < E_N; e++) if (ev & (1u << e)) ui_key((int)e + 1);
    {   /* maintien d'une touche FX..CAB (~0,6 s) : ajouter / déplacer / supprimer le bloc affiché */
        int hk = -1;
        for (e = 0; e < E_N; e++) if (S->bstate[e]) { hk = (int)e + 1; break; }
        if (hk > 0) {
            if (S->hold_cat_key != hk) { S->hold_cat_key = hk; S->hold_cat = 0; }
            if (++S->hold_cat == HOLD_PARA) ui_key_hold(hk);
        } else { S->hold_cat_key = -1; S->hold_cat = 0; }
    }
    if (S->bstate[B_HOME]) {                                         /* HOME tenu ~0,6 s = SAUVEGARDER ; tenu 3 s = Bluetooth on/off */
        void ui_save_open(void), ui_save_close(void);
        ++S->hold_home;
        if (S->hold_home == HOLD_PARA) ui_save_open();
        if (S->hold_home == 1125) { ui_save_close(); bt_toggle(); }
    } else S->hold_home = 0;
    if (engine_version() != d_engver) ui_touch();
    ui_tick((int)(S->tick * 8 / 3));                                 /* ms */
    if (ui_dirty() && !S->drawing) S->dirty = 1;
    if ((S->tick & 31) == 5) { proto_meter(meter_in, meter_out); meter_in = 0; meter_out = 0; }   /* vu-mètres de l'app */
    RB[RB_FXMASK] = (u32)engine_scene() | (S->bypass << 8);
    if (overload) {                                                  /* surcharge : message, puis réarmement au prochain changement du moteur */
        void ui_msg_overload(void);
        if (!overload_shown) { ui_msg_overload(); overload_shown = 1; }
        if (engine_version() != overload_ver) { overload = 0; overload_shown = 0; ov_win = 0; }
    }
    if ((S->tick & 15) == 0) {                                       /* LED : la touche de la page affichée + vu-mètre de sortie */
        /* barre sur FX..CAB (bits 1..6) : -36, -30, -24, -18, -12, -6 dBFS ; retombée d'une LED par pas de ~43 ms */
        static const u32 TH[6] = { 519, 1036, 2068, 4125, 8231, 16423 };
        static int shown;
        int lv = 0;
        while (lv < 6 && led_pk >= TH[lv]) lv++;
        led_pk = 0;
        if (lv < shown - 1) lv = shown - 1;
        shown = lv;
        {   /* LED HOME = tap tempo (battement à la noire) */
            u32 leds = ui_leds() | (((1u << lv) - 1u) << 1);
            if (ui_tap_led()) leds |= 1u;
            hc595_write(leds);
        }
    }
}
/* charge : spin = tours de boucle à vide pendant un bloc (blocs sans dessin d'écran seulement) ; référence mesurée au démarrage */
static void load_account(void)
{
    if (!S->drew) {
        if (S->calib) { if (S->spin > S->spin_base) S->spin_base = S->spin; }
        else if (S->spin < S->spin_min) S->spin_min = S->spin;
    }
    S->spin = 0; S->drew = 0;
    if (S->calib) {
        if (--S->calib == 0) { RB[RB_SPINBASE] = S->spin_base; S->spin_min = 0xFFFFFFFFu; S->load_win = 0; }
        return;
    }
    if (++S->load_win >= 375) {                                     /* ~1 s */
        u32 base = S->spin_base ? S->spin_base : 1, l;
        l = S->spin_min >= base ? 0 : 100u - (S->spin_min * 100u) / base;
        S->load = l;
        RB[RB_LOADNOW] = l;
        if (l > RB[RB_LOADMAX]) RB[RB_LOADMAX] = l;
        S->spin_min = 0xFFFFFFFFu; S->load_win = 0;
    }
}

/* ---------------- protocole SysEx : F0 7D 42 58 cmd ... F7 ----------------
 * 01 PING            -> 01 + texte de version
 * 02 GET_STATE       -> 02 fx_lo fx_hi bypass vol(0..127) load(0..100) ledmode
 * 03 SET_FX lo hi    -> masque des effets (bits E_*)
 * 04 SET_BYPASS b
 * 05 GET_STATS       -> 05 + compteurs USB / audio (chacun en 5 x 7 bits)
 * 7E 55 2A ENTER_UPDATE -> réponse 7E puis retour en mode UBOOT (pour l'installateur)
 * Réponses : F0 7D 42 58 (cmd | 0x40 si erreur) ... F7 */
static u8 reply_buf[256];
static void reply(u32 cmd, const u8 *d, u32 n)
{
    u32 i, k = 0;
    reply_buf[k++] = 0xF0; reply_buf[k++] = 0x7D; reply_buf[k++] = 0x42; reply_buf[k++] = 0x58; reply_buf[k++] = (u8)cmd;
    for (i = 0; i < n && k < sizeof(reply_buf) - 1; i++) reply_buf[k++] = d[i] & 0x7F;
    reply_buf[k++] = 0xF7;
    usb_midi_send_sysex(reply_buf, k);
}
static void put32(u8 *d, u32 v) { u32 i; for (i = 0; i < 5; i++) d[i] = (v >> (7 * i)) & 0x7F; }
static u32 get32(const u8 *d) { u32 v = 0, i; for (i = 0; i < 5; i++) v |= (u32)(d[i] & 0x7F) << (7 * i); return v; }
static u16 crc16x(const u8 *p, u32 n)                         /* CRC-16/XMODEM */
{
    u32 c = 0, i;
    while (n--) { c ^= (u32)*p++ << 8; for (i = 0; i < 8; i++) c = (c & 0x8000) ? ((c << 1) ^ 0x1021) & 0xFFFF : (c << 1) & 0xFFFF; }
    return (u16)c;
}
/* 7 bits : par groupe de 7 octets, un octet d'en-tête (bit i = bit 7 de l'octet i) puis les 7 octets sur 7 bits */
static u32 unpack7(const u8 *s, u32 n, u8 *d)
{
    u32 o = 0, i = 0;
    while (i < n) {
        u32 hi = s[i++], k;
        for (k = 0; k < 7 && i < n; k++, i++) d[o++] = (u8)((s[i] & 0x7F) | (((hi >> k) & 1) << 7));
    }
    return o;
}
static u32 pack7(const u8 *s, u32 n, u8 *d)
{
    u32 o = 0, i = 0;
    while (i < n) {
        u32 h = o++, k, hi = 0;
        for (k = 0; k < 7 && i < n; k++, i++) { hi |= (u32)(s[i] >> 7) << k; d[o++] = s[i] & 0x7F; }
        d[h] = (u8)hi;
    }
    return o;
}
static void audio_mute_for_flash(void)                        /* sortie à zéro : le DMA continue pendant que la flash est occupée */
{
    u32 i;
    for (i = 0; i < 2 * PT_LEN; i++) PT_TX[i] = 0;
    wdt_clear();
}
static u32 pending_update;
static u8 io_buf[512];
void proto_sysex(const u8 *m, u32 n)
{
    u8 d[64];
    u32 cmd;
    if (n < 6 || m[1] != 0x7D || m[2] != 0x42 || m[3] != 0x58) return;
    cmd = m[4];
    RB[16] += 1;
    if (cmd == 0x70) { proto_frames_sysex(m, n); return; }          /* trames de l'app (proto.c) */
    /* écriture flash par la pédale : désactivée tant que l'entrée en mode SPI fige la puce (voir save.md, fw5) */
    switch (cmd) {
    case 0x01: {
        const char *v = FW_VERSION; u32 k = 0;
        while (v[k] && k < 60) { d[k] = (u8)v[k]; k++; }
        reply(0x01, d, k);
        break; }
    case 0x02:
        d[0] = S->fx & 0x7F; d[1] = (S->fx >> 7) & 0x7F; d[2] = (u8)S->bypass;
        d[3] = (u8)((u32)S->vol_target * 127u >> 12); d[4] = (u8)S->load; d[5] = (u8)S->ledmode;
        reply(0x02, d, 6);
        break;
    case 0x03:
        if (n < 8) { reply(0x43, 0, 0); break; }
        S->fx = (m[5] | ((u32)m[6] << 7)) & ((1u << E_N) - 1); S->dirty = 1;
        reply(0x03, 0, 0);
        break;
    case 0x04:
        if (n < 7) { reply(0x44, 0, 0); break; }
        S->bypass = m[5] & 1; S->dirty = 1;
        reply(0x04, 0, 0);
        break;
    case 0x05: {
        u32 st[5];
        usb_midi_stats(st);
        put32(d, st[0]); put32(d + 5, st[1]); put32(d + 10, st[2]); put32(d + 15, st[3]);
        put32(d + 20, RB[RB_HALVES]); put32(d + 25, RB[RB_OVERRUNS]); put32(d + 30, RB[RB_LOADMAX]);
        reply(0x05, d, 35);
        break; }
    case 0x10:                                                  /* STORE_INFO */
        put32(d, 0x60000u); put32(d + 5, 0xA7000u); put32(d + 10, storage_errors());
        reply(0x10, d, 15);
        break;
    case 0x11: {                                                /* ERASE adresse(5) : secteur de 4 Ko */
        int r;
        if (n < 11) { reply(0x51, 0, 0); break; }
        audio_mute_for_flash();
        r = storage_erase(get32(m + 5));
        wdt_clear();
        d[0] = (u8)(r < 0 ? -r : 0);
        reply(0x11, d, 1);
        break; }
    case 0x12: {                                                /* WRITE adresse(5) crc(3) données 7 bits */
        u32 a, crc, len; int r;
        if (n < 15) { reply(0x52, 0, 0); break; }
        a = get32(m + 5); crc = m[10] | ((u32)m[11] << 7) | ((u32)(m[12] & 3) << 14);
        len = unpack7(m + 13, n - 14, io_buf);
        if (len == 0 || len > 256 || crc16x(io_buf, len) != crc) { d[0] = 9; reply(0x12, d, 1); break; }
        audio_mute_for_flash();
        r = storage_write(a, io_buf, len);
        wdt_clear();
        d[0] = (u8)(r < 0 ? -r : 0);
        reply(0x12, d, 1);
        break; }
    case 0x13: {                                                /* READ adresse(5) longueur(2) : données 7 bits (XIP, en clair) */
        u32 a, len, k;
        const u8 *p;
        if (n < 13) { reply(0x53, 0, 0); break; }
        a = get32(m + 5); len = m[10] | ((u32)m[11] << 7);
        if (len > 160 || a < 0x4000u || a + len > 0x100000u) { reply(0x53, 0, 0); break; }
        p = storage_ptr(a);
        for (k = 0; k < len; k++) io_buf[k] = p[k];
        {
            u32 q = 0, z;
            reply_buf[q++] = 0xF0; reply_buf[q++] = 0x7D; reply_buf[q++] = 0x42; reply_buf[q++] = 0x58; reply_buf[q++] = 0x13;
            z = pack7(io_buf, len, reply_buf + q); q += z;
            reply_buf[q++] = 0xF7;
            usb_midi_send_sysex(reply_buf, q);
        }
        break; }
    case 0x14: {                                                /* CRC adresse(5) longueur(5) -> crc16 (3) des données lues en XIP */
        u32 a, len, c;
        if (n < 16) { reply(0x54, 0, 0); break; }
        a = get32(m + 5); len = get32(m + 10);
        if (a < 0x4000u || len > 0x100000u || a + len > 0x100000u) { reply(0x54, 0, 0); break; }
        c = crc16x(storage_ptr(a), len);
        wdt_clear();
        d[0] = c & 0x7F; d[1] = (c >> 7) & 0x7F; d[2] = (c >> 14) & 3;
        reply(0x14, d, 3);
        break; }
    case 0x16: {                                                /* FLASH_ID (lecture seule) -> id(5) capacité(5) durée en blocs audio(5) */
        u32 id, cap, t0 = RB[RB_HALVES], t1;
        audio_mute_for_flash();
        storage_id(&id, &cap);
        t1 = RB[RB_HALVES];
        put32(d, id); put32(d + 5, cap); put32(d + 10, t1 - t0);
        reply(0x16, d, 15);
        break; }
    case 0x15: {                                                /* PEEK RAM adresse(5) : 16 mots (diagnostic) */
        u32 a = get32(m + 5), k;
        if (n < 11 || (a & 3) || !((a >= 0x1C00000u && a + 64 <= 0x1C80000u) || (a >= 0x10000u && a + 64 <= 0x60000u))) { reply(0x55, 0, 0); break; }   /* RAM ou registres */
        for (k = 0; k < 16; k++) { u32 v = ((volatile u32 *)a)[k]; io_buf[4 * k] = (u8)v; io_buf[4 * k + 1] = (u8)(v >> 8); io_buf[4 * k + 2] = (u8)(v >> 16); io_buf[4 * k + 3] = (u8)(v >> 24); }
        {
            u32 q = 0;
            reply_buf[q++] = 0xF0; reply_buf[q++] = 0x7D; reply_buf[q++] = 0x42; reply_buf[q++] = 0x58; reply_buf[q++] = 0x15;
            q += pack7(io_buf, 64, reply_buf + q);
            reply_buf[q++] = 0xF7;
            usb_midi_send_sysex(reply_buf, q);
        }
        break; }
    case 0x18:                                                  /* FAÇADE simulée (tests) : 1 touche k, 2 PARA tourner d (64 = 0), 3 PARA appui, 4 PARA maintien, 5 accordeur, 6 MASTER dB+60 */
        if (n >= 8) {
            int a = m[5], v = m[6];
            if (a == 1) ui_key(v); else if (a == 2) ui_para_turn(v - 64); else if (a == 3) ui_para_press(); else if (a == 4) ui_para_hold();
            else if (a == 5) ui_tuner(!ui_tuner_on()); else if (a == 6) ui_master((float)v - 60);
            else if (a == 7) fs_action(v & 1, (v >> 1) & 1);           /* footswitch : bit 0 = droite, bit 1 = maintien */
            else if (a == 8) { void ui_save_open(void); ui_save_open(); }   /* HOME maintenu : écran SAUVEGARDER */
            else if (a == 9) { void ui_splash_test(void); ui_splash_test(); }   /* test : prochaine image = logo de démarrage */
            reply(0x18, 0, 0);
        }
        break;
    case 0x1D: {                                                /* MESURE ÉCRAN : ms pour (a) calculer une image entière, (b) calculer + envoyer */
        u32 usb_read_sofframe(int id), t0, ta, tb, sp;
        audio_mute_for_flash();
        while (S->drawing) lcd_step();                          /* le 2e cœur ne doit plus rendre pendant la mesure */
        ui_build();
        {   /* coût par type : tout, puis sans RRECT+RSTROKE, sans CIRC+RING, sans POLY, sans TEXT, tout ignoré */
            extern unsigned int gfx_skip_mask;
            static const u8 masks[6] = { 0, 3, 12, 16, 32, 63 };
            int q;
            for (q = 0; q < 6; q++) {
                gfx_skip_mask = masks[q];
                t0 = usb_read_sofframe(0);
                for (sp = 0; sp < 240 * 4; sp++) gfx_render_span((int)(sp / 4), (int)((sp & 3) * SPAN), (int)((sp & 3) * SPAN + SPAN), rowbuf);
                put32(io_buf + 10 + 5 * q, (usb_read_sofframe(0) - t0) & 2047);
                wdt_clear();
            }
            gfx_skip_mask = 0;
            { extern int gfx_ops(void); put32(io_buf + 40, (u32)gfx_ops()); }
        }
        t0 = usb_read_sofframe(0);
        for (sp = 0; sp < 240 * 4; sp++) gfx_render_span((int)(sp / 4), (int)((sp & 3) * SPAN), (int)((sp & 3) * SPAN + SPAN), rowbuf);
        ta = (usb_read_sofframe(0) - t0) & 2047;
        wdt_clear();
        span_ok = 0;                                           /* mesure : image entière renvoyée */
        lcd_frame_start();
        t0 = usb_read_sofframe(0);
        while (S->drawing) lcd_step();
        tb = (usb_read_sofframe(0) - t0) & 2047;
        put32(io_buf, ta); put32(io_buf + 5, tb);
        reply(0x1D, io_buf, 45);
        break; }
    case 0x1C: {                                                /* DIAGNOSTIC : bloc forcé (lane, col, modèle) SANS contrôle DSP, pour tester le garde-fou */
        int engine_block_set_force(int lane, int col, int m);
        u8 r = 0;
        if (n >= 9) r = (u8)(engine_block_set_force(m[5], m[6], m[7]) == 0);
        reply(0x1C, &r, 1);
        break; }
    case 0x1B: {                                                /* TEST IR emplacement(1) : 32 sorties (impulsion), comparées à l'IR */
        int engine_ir_test(int slot, s32 *out);
        static s32 o32[32];
        u32 k; int r;
        audio_mute_for_flash();
        r = engine_ir_test(n >= 7 ? m[5] : 0, o32);
        for (k = 0; k < 32; k++) put32(io_buf + 5 * k, (u32)o32[k]);
        put32(io_buf + 160, (u32)r);
        reply(0x1B, io_buf, 165);
        break; }
    case 0x1A: {                                                /* COÛT modèle(1) (127 = grille vide) : ms pour 19 200 échantillons (0,4 s audio) */
        u32 engine_bench_model(int m, int n), ms;
        audio_mute_for_flash();
        if (n >= 7 && m[5] >= 120 && m[5] <= 123) { u32 engine_bench_ir(int what, int reps); ms = engine_bench_ir(m[5], 150); }   /* 150 blocs = 0,4 s */
        else ms = engine_bench_model(n >= 7 && m[5] != 127 ? m[5] : -1, 19200);
        { extern u32 bench_peak, bench_avg, bench_bad; put32(io_buf, ms); put32(io_buf + 5, bench_peak); put32(io_buf + 10, bench_avg); put32(io_buf + 15, bench_bad); }
        reply(0x1A, io_buf, 20);
        break; }
    case 0x1E: {                                                /* SONDE ISA : sémantique des MAC à opérande mémoire 16 bits (isa_probe.S) */
        void isa_probe(u32 *out, const short *h, const int *wv);
        static const short ph[5] = { 3, -2, 0x4000, 3, 3 };
        static const int pw[4] __attribute__((aligned(8))) = { 0x00010002, 0x00010002, 0x40000000, 0x00010003 };
        static u32 po[64];
        u32 k;
        isa_probe(po, ph, pw);
        for (k = 0; k < 20; k++) put32(io_buf + 5 * k, po[k]);
        reply(0x1E, io_buf, 100);
        break; }
    case 0x21: {                                                /* ÉTAT NAM (diagnostic) : 14 mots, voir engine_nam_diag */
        int engine_nam_diag(u32 *o);
        static u32 dg[16];
        u32 k;
        for (k = 0; k < 16; k++) dg[k] = 0;
        engine_nam_diag(dg);
        for (k = 0; k < 14; k++) put32(io_buf + 5 * k, dg[k]);
        reply(0x21, io_buf, 70);
        break; }
    case 0x20: {                                                /* HORLOGE mhz(2 x 7 bits) : 0 = lecture seule ; renvoie (résultat, MHz) */
        int clock_set_mhz(u32 mhz);
        u32 clock_mhz(void), mhz = n >= 8 ? (u32)m[5] | ((u32)m[6] << 7) : 0;
        int r = 0;
        if (mhz) { audio_mute_for_flash(); r = clock_set_mhz(mhz); }
        put32(io_buf, (u32)r); put32(io_buf + 5, clock_mhz());
        reply(0x20, io_buf, 10);
        break; }
    case 0x1F: {                                                /* MICRO-MESURES (bench.S) : ms pour n tours de chaque fonction */
        typedef void (*bfn)(u32 n, void *buf);
        extern void bench_empty(u32, void *), bench_hmac(u32, void *), bench_hmac1(u32, void *), bench_load(u32, void *),
                    bench_tap(u32, void *), bench_copy(u32, void *), bench_repcopy(u32, void *), bench_rmac(u32, void *),
                    bench_dmac(u32, void *);
        static const bfn fns[9] = { bench_empty, bench_hmac, bench_hmac1, bench_load, bench_tap, bench_copy, bench_repcopy,
                                    bench_rmac, bench_dmac };
        static u32 bbuf[64];
        u32 usb_read_sofframe(int id), k, t;
        audio_mute_for_flash();
        for (k = 0; k < 9; k++) {
            u32 nn = k == 0 ? 2000000u : 100000u;
            wdt_clear();
            t = usb_read_sofframe(0);
            fns[k](nn, bbuf);
            put32(io_buf + 5 * k, (usb_read_sofframe(0) - t) & 2047);
        }
        reply(0x1F, io_buf, 45);
        break; }
    case 0x19: {                                                /* TEST NAM emplacement(1) : 32 sorties Q23 (comparées à sim_nam.py) */
        int engine_nam_test(int slot, int split, s32 *out);
        static s32 o32[32];
        u32 k, t0 = RB[RB_HALVES];
        int r;
        audio_mute_for_flash();
        r = engine_nam_test(n >= 7 ? m[5] : 0, n >= 8 ? (int)m[6] : -1, o32);
        for (k = 0; k < 32; k++) put32(io_buf + 5 * k, (u32)o32[k]);
        { extern u32 nam_test_ms, nam_test_front_ms, nam_test_back_ms;
          (void)t0; put32(io_buf + 160, (u32)r); put32(io_buf + 165, nam_test_ms);
          put32(io_buf + 170, nam_test_front_ms); put32(io_buf + 175, nam_test_back_ms); }
        reply(0x19, io_buf, 180);
        break; }
    case 0x17: {                                                /* CAPTURE ligne(2) : la ligne y de l'écran, RGB565 (vérification du rendu) */
        u32 y = m[5] | ((u32)m[6] << 7), q = 0, k;
        while (S->drawing) lcd_step();                          /* rendu ici : le 2e cœur doit avoir fini son image */
        static u16 cap[240];
        if (n < 8 || y >= 240) { reply(0x57, 0, 0); break; }
        if (y == 0) ui_build();                                     /* image à jour au début d'une capture */
        gfx_render_row((int)y, cap);
        for (k = 0; k < 240; k++) { io_buf[2 * k] = (u8)(cap[k] >> 8); io_buf[2 * k + 1] = (u8)cap[k]; }
        {
            static u8 big[600];
            big[q++] = 0xF0; big[q++] = 0x7D; big[q++] = 0x42; big[q++] = 0x58; big[q++] = 0x17;
            big[q++] = (u8)(y & 0x7F); big[q++] = (u8)(y >> 7);
            q += pack7(io_buf, 480, big + q);
            big[q++] = 0xF7;
            usb_midi_send_sysex(big, q);
        }
        break; }
    case 0x7E:
        if (n >= 8 && m[5] == 0x55 && m[6] == 0x2A) { reply(0x7E, 0, 0); pending_update = 1; }
        else reply(0x7E | 0x40, 0, 0);
        break;
    default:
        reply(cmd | 0x40, 0, 0);
    }
}

int proto_battery_pct(void) { return S->batt_mv ? (int)S->batt_pct : -1; }
int proto_battery_mv(void) { return (int)S->batt_mv; }
int proto_usb(void) { return (int)S->usb; }
int proto_bt_state(void) { return S->bt_paired ? 2 : (S->bt_on ? 1 : 0); }

void fw_main(void)
{
    u32 i, idle = 0;
    wdt_clear();
    /* .data (flash -> RAM) et .bss (zéro) : nécessaires au pilote USB du SDK */
    { u32 *s = _data_lma, *d = _data_start; while (d < _data_end) *d++ = *s++; }
    { u32 *b = _bss_start; while (b < _bss_end) *b++ = 0; }
    p33_cmd(0x00, 0x94, 0);                                         /* P3_PINR_CON = 0 : pas de remise à zéro par broche */
    pin_in_pullup(PA, 1);
    delay(20000);
    if (!(PORT(PA)[R_IN] & (1u << 1))) go_uboot(3);

    /* chien de garde ~4 s (P3_WDT_CON = 0x1C : délai 0xC, activation bit 4 ; comme le loader UBOOT, qui relance en ~3,5 s).
       Après le test HOME : même mal compris, il ne peut pas empêcher la sortie de secours. */
    p33_cmd(0x00, 0x80, 0x1C);
    wdt_clear();
    if (RB[RB_MAGIC] != FW_MAGIC) { for (i = 0; i < 32; i++) RB[i] = 0; RB[RB_MAGIC] = FW_MAGIC; }
    RB[RB_BOOTS] += 1; RB[RB_EXIT] = 0; RB[RB_STAGE] = 1;
    RB[RB_HALVES] = 0; RB[RB_OVERRUNS] = 0; RB[RB_PEAKIN] = 0; RB[RB_LOADMAX] = 0;
    { u32 *s = (u32 *)S; for (i = 0; i < sizeof(struct st) / 4; i++) s[i] = 0; }
    S->vol = 2048; S->vol_target = 2048; S->ladder = 1023; S->dirty = 1; S->calib = 64; S->spin_min = 0xFFFFFFFFu;
    /* preset de démarrage = « Init » de l'app (Gate -> Brit Crunch 800 -> IR) ; l'app envoie le sien à la connexion */
    engine_clear();
    engine_block_set(0, 0, M_GATE); engine_block_set(0, 1, M_BRIT); engine_block_set(0, 2, M_IR);
    engine_scene_select(0);

    pin_in_pullup(PA, 0); pin_in_pullup(PA, 2); pin_in_pullup(PA, 3);
    pin_in_pullup(PH, 8); pin_in_pullup(PH, 9);
    pin_in_pullup(PC, 0); pin_in_pullup(PC, 1); pin_in_pullup(PH, 6);  /* encodeur PARA : A, B, appui */
    S->enc_prev = PORT(PC)[R_IN] & 3u;
    pin_analog(PC, 10); pin_analog(PA, 10); pin_analog(PC, 9);   /* PC09 = mesure batterie (÷2) */
    leds_init();
    hc595_write(0x7F);
    RB[RB_STAGE] = 2;
    lcd_init();
    lcd_splash();                                                    /* logo BIG BLACK RIG, puis affichage allumé */
    RB[RB_STAGE] = 3;
    audio_start();
    hc595_write(0);
    RB[RB_STAGE] = 4;
    usb_midi_init();
    RB[RB_STAGE] = 5;
    /* 360 MHz (SPL) -> 396 MHz (clock.c). APRÈS l'init audio/USB : passé avant audio_start(), l'entrée
       guitare arrivait sur l'autre canal du mot stéréo (temporisations par boucles plus courtes) -> plus de son. */
    *(volatile u32 *)0x1C72000u = 0;                                 /* MB->alive (core1.c) : le 2e cœur n'est pas encore lancé */
    { int clock_set_mhz(u32 mhz); clock_set_mhz(FW_MHZ); }
    { int core1_start(void); RB[19] = (u32)core1_start(); }           /* 2e cœur (NAM) ; RB[19] = 0 s'il a démarré */
    { void proto_boot(void); proto_boot(); }                         /* table + dernier preset sauvé (sinon « Init ») */
    { int bt_load(void); int b = bt_load(); S->bt_on = b > 0; S->bt_paired = b == 2; ui_bt_set((int)S->bt_on, (int)S->bt_paired); }
    RB[RB_STAGE] = 6;                                           /* stockage : initialisé à la première commande (storage.c) */

    for (;;) {
        if (ALNK(0x08) & (1u << 5)) {
            u32 pk = process_half();
            RB[RB_HALVES] += 1;
            RB[RB_DRAW] = S->pix | (S->drawing << 31);
            wdt_clear();
            if (!S->calib) housekeeping(pk);
            load_account();
            jiffies++;
            usb_midi_poll();
            { void proto_poll(void); proto_poll(); }                /* grosses réponses (PRESET_GET / LIST) au rythme de la file USB */
            if (ui_tuner_on()) { void tuner_step(void); tuner_step(); }   /* accordeur : une tranche de calcul par bloc */
            if (pending_update && pending_update++ > 40) go_uboot(4);  /* ~0,1 s pour que la réponse parte */
            idle = 0;
        } else if (S->drawing && !S->calib) {
            encoder_poll();
            lcd_step();
            encoder_poll();
            S->drew = 1;
            if ((++idle & 0x3FF) == 0) wdt_clear();
        } else if (S->dirty && !S->calib && RB[RB_HALVES] >= 700) {   /* logo de démarrage : >= 2 s (700 blocs = 1,87 s + l'init avant l'audio) */
            lcd_frame_start();
            S->drew = 1;
        } else {
            if ((S->spin & 15) == 0) usb_midi_poll();
            encoder_poll();
            S->spin++;
            if (++idle > 3000000u) {                                /* horloge audio arrêtée */
                RB[RB_TIMEOUTS] += 1;
                idle = 0;
                hc595_write((RB[RB_TIMEOUTS] & 1) ? 0x01 : 0x00);
                wdt_clear();
                if (!(PORT(PA)[R_IN] & (1u << 3))) go_uboot(1);
            }
        }
    }
}
