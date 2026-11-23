/* ui.c : écran et façade de la pédale, portage de interface/app/js/ecran.js (même mise en page, mêmes couleurs, mêmes polices).
 * Écrans : accueil (barre du haut + chaîne en serpentin, sections parallèles entre crochets), page de bloc, preset (0,9 s),
 * MASTER (1 s), message, accordeur. Commandes : HOME, FX..CAB, PARA (tourner / appuyer / maintenir), MASTER, footswitchs. */
#include "gfx.h"
#include "catalog.h"
#include "engine.h"
typedef unsigned int u32;
typedef int s32;

const char *proto_preset_name(void);
u32 proto_preset_rgb(void);
int proto_preset_index(void);
const char *proto_ir_name(int s);
const char *proto_nam_name(int s);
u32 proto_tempo(void);
void proto_notify_structure(void);

/* couleurs de ecran.js (C) */
#define C_BG   0x0b0d10
#define C_BAR  0x11141a
#define C_LINE 0x232830
#define C_TX   0xeceef1
#define C_TX2  0xa3abb5
#define C_TX3  0x646c77
#define C_ACC  0x19d3ff
#define C_WIRE 0x3c434d
#define C_OK   0x3ddc84
#define C_WARN 0xffb020
#define C_BAD  0xff4d4d
#define W 240
#define H 240

enum { V_HOME, V_BLOCK, V_TUNER, V_SAVE, V_ACTION, V_ADD, V_CONFIRM, V_MOVE };
int proto_dirty(void); int proto_save_slot(int i); int proto_slot_name(int i, char *o);
static struct {
    int view, cursor, lane, col, key, pidx, editing;
    int overlay, ov_until;                 /* 0 aucun, 1 preset, 2 master, 3 message */
    const char *msg;
    float master_db;
    int tuner_note, tuner_oct, tuner_level; float tuner_cents;
    int dirty, ms;
    int last_index;
    int save_slot, last_dirty;             /* écran SAUVEGARDER : emplacement visé ; dernier état « modifié » affiché */
    int menu_sel, add_key;                 /* gestion des blocs : ligne choisie, famille à ajouter */
    int prev_lane, prev_col, prev_key, prev_was_block;   /* bloc affiché avant l'appui (maintien = gérer ce bloc) */
} U = { V_HOME, -1, 0, 0, 0, 0, 0, 0, 0, 0, 0.0f, 0, 0, 0, 0.0f, 1, 0, -1, 0, 0 };

/* familles des touches (KEY_CATS) : FX AMP MOD DLY REV CAB */
static int key_has_cat(int key, int cat)
{
    switch (key) {
    case 1: return cat == CAT_DYN || cat == CAT_DRIVE || cat == CAT_PITCH || cat == CAT_EQ;   /* Utilitaire masqué */
    case 2: return cat == CAT_AMP;
    case 3: return cat == CAT_MOD;
    case 4: return cat == CAT_DELAY;
    case 5: return cat == CAT_REVERB;
    case 6: return cat == CAT_CAB;
    }
    return 0;
}
/* blocs dans l'ordre du signal : colonne par colonne, A puis B */
static int order(int *ol, int *oc)
{
    int c, n = 0, m, on;
    for (c = 0; c < CAT_COLS; c++) {
        if (engine_get(0, c, &m, &on)) { ol[n] = 0; oc[n] = c; n++; }
        if (engine_get(1, c, &m, &on)) { ol[n] = 1; oc[n] = c; n++; }
    }
    return n;
}
static float clampf(float v, float a, float b) { return v < a ? a : (v > b ? b : v); }
static int decs(float step) { return step >= 1 ? 0 : (step >= 0.1f ? 1 : 2); }
/* nombre -> texte (d décimales) */
static char *fmt_num(char *p, float v, int d, int plus)
{
    int i, neg = v < 0; u32 ip, fp, sc = 1;
    for (i = 0; i < d; i++) sc *= 10;
    if (neg) v = -v;
    ip = (u32)(v * sc + 0.5f); fp = ip % sc; ip /= sc;
    if (neg && (ip || fp)) *p++ = '-'; else if (plus && (ip || fp)) *p++ = '+';
    { char t[12]; int k = 0; do { t[k++] = (char)('0' + ip % 10); ip /= 10; } while (ip); while (k) *p++ = t[--k]; }
    if (d) { *p++ = '.'; for (i = d - 1; i >= 0; i--) { u32 dd = fp; int j; for (j = 0; j < i; j++) dd /= 10; *p++ = (char)('0' + dd % 10); } }
    *p = 0;
    return p;
}
static char *scpy(char *d, const char *s) { while (*s) *d++ = *s++; *d = 0; return d; }
/* fmtVal de ecran.js */
static void fmt_val(char *o, const struct param_def *pd, float v)
{
    if (pd->type == 1) { int k = (int)v; scpy(o, (k >= 0 && k < pd->nopt) ? pd->opt[k] : "\xE2\x80\x94"); return; }
    if (pd->type == 2) { scpy(o, v != 0 ? "ON" : "OFF"); return; }
    if (pd->type == 3) { const char *n = proto_ir_name((int)v); scpy(o, n ? n : "Empty"); return; }
    if (pd->type == 4) { const char *n = proto_nam_name((int)v); scpy(o, n ? n : "Empty"); return; }
    {
        const char *u = pd->unit;
        char *p = o;
        if (u[0] == 'm' && u[1] == 's' && !u[2] && v >= 1000) { p = fmt_num(p, v / 1000, 2, 0); scpy(p, " s"); return; }
        if (u[0] == 'H' && u[1] == 'z' && !u[2] && v >= 1000) { p = fmt_num(p, v / 1000, v >= 10000 ? 1 : 2, 0); scpy(p, "k"); return; }
        p = fmt_num(p, v, decs(pd->step), pd->min < 0 && v > 0);
        if (u[0] == ':' ) scpy(p, ":1");
        else if (u[0]) { *p++ = ' '; scpy(p, u); }
    }
}
static float frac(const struct param_def *pd, float v) { return pd->type ? -1 : (v - pd->min) / (pd->max - pd->min); }

static void preset_label(char *o, int i) { int b = i + 1; o[0] = (char)('0' + b / 10); o[1] = (char)('0' + b % 10); o[2] = 0; }   /* 01..80, sans banques */

/* ---------------- tuile (tile de ecran.js) ---------------- */
static void tile(int lane, int col, float cx, float cy, float t, int cursor)
{
    int m, on, cat; u32 col_c;
    float r, ic;
    if (!engine_get(lane, col, &m, &on)) return;
    cat = MODEL_DEFS[m].cat;
    col_c = on ? CAT_RGB[cat] : 0x4a515b;
    r = (float)(int)(t * 0.26f + 0.5f); ic = (float)(int)(t * 0.58f + 0.5f);
    if (cursor) gfx_rrect_stroke(Q4(cx - t / 2 - 4), Q4(cy - t / 2 - 4), Q4(t + 8), Q4(t + 8), Q4(r + 4), Q4(2), 0xffffff, 255);
    gfx_rrect(Q4(cx - t / 2), Q4(cy - t / 2), Q4(t), Q4(t), Q4(r), C_BG, 255);
    gfx_rrect(Q4(cx - t / 2), Q4(cy - t / 2), Q4(t), Q4(t), Q4(r), col_c, on ? 51 : 15);           /* fill-opacity .2 / .06 */
    gfx_rrect_stroke(Q4(cx - t / 2), Q4(cy - t / 2), Q4(t), Q4(t), Q4(r), Q4(2), col_c, 255);
    gfx_icon(MODEL_ICON[m], Q4(cx), Q4(cy), Q4(ic), 40, on ? CAT_RGB[cat] : 0x59616c);              /* stroke-width 2.5 */
}

/* ---------------- barre du haut ---------------- */
#define BAR 34
static int batt = -1;                                    /* niveau batterie 0..100, -1 = pas encore lu */
static int usb_on = 0, bt_state = 0;                     /* USB présent ; Bluetooth 0 arrêt, 1 actif, 2 appairé */
static void top_bar(void)
{
    char lab[4], pc[5];
    int bx = W - 38;
    gfx_rrect(0, 0, Q4(W), Q4(BAR), 0, C_BAR, 255);
    gfx_rrect(0, Q4(BAR - 1), Q4(W), Q4(1), 0, C_LINE, 255);
    gfx_rrect(0, 0, Q4(4), Q4(BAR), 0, proto_preset_rgb(), 255);
    preset_label(lab, proto_preset_index());
    gfx_text(&F_mono14, Q4(11), Q4(22.5f), C_ACC, 255, lab, 0);
    if (proto_dirty()) gfx_text(&F_mono14, Q4(32), Q4(22.5f), C_WARN, 255, "*", 0);   /* modifié, pas sauvé */
    gfx_text_fit(&F_bold15, Q4(50), Q4(23), C_TX, proto_preset_name(), Q4(bx - 116), 0);
    /* Bluetooth (rune) : gris = arrêté, bleu = actif, vert + point = appairé */
    {
        int cx = bx - 58, cy = 17;
        u32 bc = bt_state == 2 ? C_OK : bt_state ? 0x3aa0ff : C_TX3;
        gfx_poly_begin(Q4(1.7f), bc, 255);
        gfx_poly_pt(Q4(cx - 3.2f), Q4(cy + 3.2f));
        gfx_poly_pt(Q4(cx + 3.2f), Q4(cy - 3.2f));
        gfx_poly_pt(Q4(cx), Q4(cy - 6.2f));
        gfx_poly_pt(Q4(cx), Q4(cy + 6.2f));
        gfx_poly_pt(Q4(cx + 3.2f), Q4(cy + 3.2f));
        gfx_poly_pt(Q4(cx - 3.2f), Q4(cy - 3.2f));
        gfx_poly_end();
        if (bt_state == 2) gfx_rrect(Q4(cx + 4.5f), Q4(cy + 4.5f), Q4(2.6f), Q4(2.6f), Q4(1.3f), C_OK, 255);
    }
    /* USB présent / charge : éclair */
    if (usb_on) {
        int cx = bx - 40, cy = 17;
        gfx_poly_begin(Q4(1.8f), C_WARN, 255);
        gfx_poly_pt(Q4(cx + 1.5f), Q4(cy - 6));
        gfx_poly_pt(Q4(cx - 3.5f), Q4(cy + 1));
        gfx_poly_pt(Q4(cx - 0.5f), Q4(cy + 1));
        gfx_poly_pt(Q4(cx - 1.5f), Q4(cy + 6));
        gfx_poly_pt(Q4(cx + 3.5f), Q4(cy - 1));
        gfx_poly_pt(Q4(cx + 0.5f), Q4(cy - 1));
        gfx_poly_pt(Q4(cx + 1.5f), Q4(cy - 6));
        gfx_poly_end();
    }
    /* batterie : même dessin que ecran.js (contour + remplissage vert/orange/rouge) */
    gfx_rrect_stroke(Q4(bx), Q4(10.5f), Q4(25), Q4(13), Q4(3), Q4(1.6f), C_TX2, 255);
    gfx_rrect(Q4(bx + 25.8f), Q4(14), Q4(2.6f), Q4(6), Q4(1), C_TX2, 255);
    if (batt >= 0 && batt <= 100) {
        u32 bc = batt <= 15 ? C_BAD : batt <= 30 ? C_WARN : C_OK;
        if (batt > 0) gfx_rrect(Q4(bx + 2.4f), Q4(12.9f), Q4(20.2f * batt / 100.0f), Q4(8.2f), Q4(1.4f), bc, 255);
    }
    {   /* pourcentage lisible à gauche du pictogramme */
        int p = batt;
        u32 tc = p < 0 ? C_TX3 : p <= 15 ? C_BAD : p <= 30 ? C_WARN : C_TX2;
        if (p < 0 || p > 100) { pc[0] = '-'; pc[1] = '-'; pc[2] = '%'; pc[3] = 0; }
        else if (p >= 100) { pc[0] = '1'; pc[1] = '0'; pc[2] = '0'; pc[3] = '%'; pc[4] = 0; }
        else { pc[0] = (char)('0' + p / 10); pc[1] = (char)('0' + p % 10); pc[2] = '%'; pc[3] = 0; }
        gfx_text(&F_mono12, Q4(bx - 18), Q4(23), tc, 255, pc, 1);
    }
}

/* ---------------- chaîne (units / flow / chain de ecran.js) ---------------- */
struct unit { int par, c0, n; };
static int units(struct unit *u)
{
    int used[CAT_COLS], nu = 0, n = 0, c, i, m, on;
    for (c = 0; c < CAT_COLS; c++) if (engine_get(0, c, &m, &on) || engine_get(1, c, &m, &on)) used[nu++] = c;
    for (i = 0; i < nu; i++) {
        c = used[i];
        if (!engine_get(1, c, &m, &on)) { u[n].par = 0; u[n].c0 = c; u[n].n = 1; n++; continue; }
        u[n].par = 1; u[n].c0 = c; u[n].n = 1;
        while (i + 1 < nu && used[i + 1] == u[n].c0 + u[n].n && engine_get(1, used[i + 1], &m, &on)) { u[n].n++; i++; }
        n++;
    }
    return n;
}
static int flow(const struct unit *u, int nu, int per, int *line_of)
{
    int L = 0, w = 0, k, cnt = 0;
    for (k = 0; k < nu; k++) {
        if (w + u[k].n > per && cnt) { L++; w = 0; cnt = 0; }
        line_of[k] = L; w += u[k].n; cnt++;
    }
    return nu ? L + 1 : 0;
}
static void wire_h(float x0, float x1, float y) { gfx_poly_begin(Q4(2), C_WIRE, 255); gfx_poly_pt(Q4(x0), Q4(y)); gfx_poly_pt(Q4(x1), Q4(y)); gfx_poly_end(); }
static void chain(void)
{
    struct unit u[CAT_COLS];
    int line_of[CAT_COLS], best_line[CAT_COLS], ol[16], oc[16];
    int nu = units(u), n = 0, maxW = 0, hasPar = 0, k, per, L = 0, have = 0, no = order(ol, oc), cl = -1, cc = -1;
    float top = BAR + 6, availH = H - top - 6, M = 12, GAP = 14, bs = -1, colW = 0, R = 0, s1 = 0, s2 = 0;
    if (U.cursor >= 0 && U.cursor < no) { cl = ol[U.cursor]; cc = oc[U.cursor]; }
    if (!nu) {
        float y = top + availH / 2;
        wire_h(4, W - 4, y);
        gfx_text(&F_sans14, Q4(W / 2), Q4(y - 14), C_TX3, 255, "Empty preset", 1);
        return;
    }
    for (k = 0; k < nu; k++) { n += u[k].n; if (u[k].n > maxW) maxW = u[k].n; if (u[k].par) hasPar = 1; }
    for (per = n < CAT_COLS ? n : CAT_COLS; per >= maxW; per--) {
        int Lc = flow(u, nu, per, line_of), i;
        float cw, Rc, a1, a2, s;
        if (Lc > 3) break;
        cw = (W - 2 * M) / per; Rc = (availH - (Lc - 1) * GAP) / Lc;
        a1 = Rc * 0.72f; if (cw - 8 < a1) a1 = cw - 8; if (a1 > 54) a1 = 54;
        a2 = (Rc - 8) / 2; if (cw - 8 < a2) a2 = cw - 8; if (a2 > 46) a2 = 46;
        s = hasPar ? (a1 < a2 * 1.25f ? a1 : a2 * 1.25f) : a1;
        if (!have || s > bs + 0.5f) { have = 1; bs = s; L = Lc; colW = cw; R = Rc; s1 = a1; s2 = a2; for (i = 0; i < nu; i++) best_line[i] = line_of[i]; }
        if (s >= 36) { L = Lc; colW = cw; R = Rc; s1 = a1; s2 = a2; for (i = 0; i < nu; i++) best_line[i] = line_of[i]; break; }
    }
    {
        float used = L * R + (L - 1) * GAP, y0 = top + (availH - used) / 2 + R / 2, rr = 6, lx = 5, rx = W - 5;
        int li, ki = 0;
        /* fils d'abord, puis points, puis tuiles (même ordre que le SVG) */
        int pass;
        for (pass = 0; pass < 3; pass++) {
            ki = 0;
            for (li = 0; li < L; li++) {
                float y = y0 + li * (R + GAP), x = li == 0 ? 2 : lx;
                int ci = 0, last = li == L - 1;
                for (; ki < nu && best_line[ki] == li; ki++) {
                    float xs = M + colW * ci, xe = M + colW * (ci + u[ki].n);
                    if (pass == 0) wire_h(x, xs + (u[ki].par ? 3 : 0), y);
                    if (!u[ki].par) {
                        if (pass == 0) wire_h(xs, xe, y);
                        if (pass == 2) tile(0, u[ki].c0, (xs + xe) / 2, y, s1, cl == 0 && cc == u[ki].c0);
                    } else {
                        float off = s2 / 2 + 4, yT = y - off, yB = y + off, a = xs + 3, b = xe - 3;
                        int j;
                        if (pass == 0) {
                            gfx_poly_begin(Q4(2), C_WIRE, 255); gfx_poly_pt(Q4(a), Q4(yT)); gfx_poly_pt(Q4(a), Q4(yB)); gfx_poly_end();
                            gfx_poly_begin(Q4(2), C_WIRE, 255); gfx_poly_pt(Q4(b), Q4(yT)); gfx_poly_pt(Q4(b), Q4(yB)); gfx_poly_end();
                            wire_h(a, b, yT); wire_h(a, b, yB);
                        }
                        if (pass == 1) { gfx_circle(Q4(a), Q4(y), Q4(3), C_ACC, 255); gfx_circle(Q4(b), Q4(y), Q4(3), C_ACC, 255); }
                        if (pass == 2) for (j = 0; j < u[ki].n; j++) {
                            float cx = xs + colW * (j + 0.5f);
                            tile(0, u[ki].c0 + j, cx, yT, s2, cl == 0 && cc == u[ki].c0 + j);
                            tile(1, u[ki].c0 + j, cx, yB, s2, cl == 1 && cc == u[ki].c0 + j);
                        }
                    }
                    x = xe - (u[ki].par ? 3 : 0);
                    ci += u[ki].n;
                }
                if (last) {
                    if (pass == 0) wire_h(x, W - 2, y);
                    if (pass == 1) { gfx_circle(Q4(2.5f), Q4(y0), Q4(2.5f), C_TX3, 255); gfx_circle(Q4(W - 2.5f), Q4(y), Q4(2.5f), C_TX3, 255); }
                } else if (pass == 0) {               /* retour à la ligne en serpentin */
                    float y1 = y0 + (li + 1) * (R + GAP), ym = y + R / 2 + GAP / 2;
                    gfx_poly_begin(Q4(2), C_WIRE, 255);
                    gfx_poly_pt(Q4(x), Q4(y)); gfx_poly_pt(Q4(rx - rr), Q4(y));
                    gfx_poly_quad(Q4(rx - rr), Q4(y), Q4(rx), Q4(y), Q4(rx), Q4(y + rr));
                    gfx_poly_pt(Q4(rx), Q4(ym - rr));
                    gfx_poly_quad(Q4(rx), Q4(ym - rr), Q4(rx), Q4(ym), Q4(rx - rr), Q4(ym));
                    gfx_poly_pt(Q4(lx + rr), Q4(ym));
                    gfx_poly_quad(Q4(lx + rr), Q4(ym), Q4(lx), Q4(ym), Q4(lx), Q4(ym + rr));
                    gfx_poly_pt(Q4(lx), Q4(y1 - rr));
                    gfx_poly_quad(Q4(lx), Q4(y1 - rr), Q4(lx), Q4(y1), Q4(lx + rr), Q4(y1));
                    gfx_poly_end();
                }
            }
        }
    }
}

/* ---------------- page de bloc ---------------- */
static void block_page(void)
{
    int m, on, cat, np, HEAD = 46, ROW = 38, FOOTH = 24, rowsY, vis, start, k;
    char b[48], lab[16];
    if (!engine_get(U.lane, U.col, &m, &on)) { U.view = V_HOME; chain(); top_bar(); return; }
    cat = MODEL_DEFS[m].cat; np = MODEL_DEFS[m].nparams;
    rowsY = HEAD + 4; vis = (H - rowsY - FOOTH) / ROW;
    start = U.pidx - vis / 2; if (start > np - vis) start = np - vis; if (start < 0) start = 0;
    gfx_rrect(0, 0, Q4(W), Q4(HEAD), 0, CAT_RGB[cat], 41);                                   /* fill-opacity .16 */
    gfx_rrect(0, Q4(HEAD - 1), Q4(W), Q4(1), 0, CAT_RGB[cat], 128);
    tile(U.lane, U.col, 25, HEAD / 2.0f, 34, 0);
    gfx_text_fit(&F_bold15, Q4(50), Q4(22), C_TX, MODEL_NAMES[m], Q4(140), 0);
    { char *p = scpy(lab, CAT_SHORT[cat]); p = scpy(p, " \xC2\xB7 "); *p++ = "AB"[U.lane]; *p++ = (char)('1' + U.col); *p = 0; }
    gfx_text(&F_mono11, Q4(50), Q4(38), CAT_RGB[cat], 255, lab, 0);
    gfx_rrect(Q4(W - 52), Q4(13), Q4(44), Q4(21), Q4(10.5f), on ? CAT_RGB[cat] : 0x2a2f37, 255);
    gfx_text(&F_mono12, Q4(W - 30), Q4(28), on ? 0x0b0d10 : C_TX2, 255, on ? "ON" : "OFF", 1);
    for (k = 0; k < vis && start + k < np; k++) {
        int i = start + k, sel = i == U.pidx, y = rowsY + k * ROW, edit = sel && U.editing;
        const struct param_def *pd = &PARAM_DEFS[m][i];
        float v = engine_params(U.lane, U.col)[i], f = frac(pd, v);
        if (sel) {
            gfx_rrect(Q4(4), Q4(y), Q4(W - 8), Q4(ROW - 4), Q4(8), edit ? CAT_RGB[cat] : 0x1a1f26, edit ? 71 : 255);
            gfx_rrect_stroke(Q4(4), Q4(y), Q4(W - 8), Q4(ROW - 4), Q4(8), edit ? Q4(2) : Q4(1.2f), CAT_RGB[cat], edit ? 255 : 140);
        }
        gfx_text_fit(&F_sans14, Q4(13), Q4(y + 21), sel ? C_TX : C_TX2, pd->name, Q4(96), 0);
        fmt_val(b, pd, v);
        gfx_text_fit(&F_mono14, Q4(W - 13), Q4(y + 21), sel ? C_TX : C_TX2, b, Q4(118), 2);
        if (f >= 0) {
            gfx_rrect(Q4(13), Q4(y + 27), Q4(W - 26), Q4(3), Q4(1.5f), 0x262c34, 255);
            gfx_rrect(Q4(13), Q4(y + 27), Q4((W - 26) * clampf(f, 0, 1)), Q4(3), Q4(1.5f), CAT_RGB[cat], 255);
        }
    }
    { char *p = b; p = fmt_num(p, (float)(U.pidx + 1), 0, 0); *p++ = '/'; fmt_num(p, (float)np, 0, 0); }
    gfx_text(&F_mono11, Q4(10), Q4(H - 8), C_TX3, 255, b, 0);
    gfx_text(&F_mono11, Q4(W - 10), Q4(H - 8), U.editing ? CAT_RGB[cat] : C_TX3, 255, U.editing ? "\xE2\x97\x86 EDIT" : "PARA \xE2\x9F\xB3", 2);
}

/* ---------------- gestion des blocs (ajouter / déplacer / supprimer) ---------------- */
static void go_home(void);
static int key_model_count(int k);
static int key_model_at(int k, int idx);
static const char *const KEY_NAMES[7] = { "HOME", "FX", "AMP", "MOD", "DLY", "REV", "CAB" };

/* liste plein écran : titre, sous-titre, lignes, valeur à droite (DSP), pied de page */
static void menu_screen(const char *title, const char *sub, const char *const *items, const int *vals, int n, int sel, u32 rgb, const char *hint)
{
    int HEAD = 44, ROW = 32, vis = (H - HEAD - 22) / ROW, start, k;
    if (sel < 0) sel = 0; if (sel >= n) sel = n ? n - 1 : 0;
    start = sel - vis / 2; if (start > n - vis) start = n - vis; if (start < 0) start = 0;
    gfx_rrect(0, 0, Q4(W), Q4(HEAD), 0, rgb, 41);
    gfx_rrect(0, Q4(HEAD - 1), Q4(W), Q4(1), 0, rgb, 128);
    gfx_text_fit(&F_bold15, Q4(12), Q4(21), C_TX, title, Q4(W - 24), 0);
    gfx_text_fit(&F_mono11, Q4(12), Q4(37), rgb, sub, Q4(W - 24), 0);
    for (k = 0; k < vis && start + k < n; k++) {
        int i = start + k, y = HEAD + 4 + k * ROW, on = i == sel;
        if (on) {
            gfx_rrect(Q4(4), Q4(y), Q4(W - 8), Q4(ROW - 4), Q4(8), rgb, 46);
            gfx_rrect_stroke(Q4(4), Q4(y), Q4(W - 8), Q4(ROW - 4), Q4(8), Q4(1.2f), rgb, 160);
        }
        gfx_text_fit(&F_sans14, Q4(13), Q4(y + 20), on ? C_TX : C_TX2, items[i], Q4(vals ? W - 76 : W - 26), 0);
        if (vals) {
            char b[8], *p = fmt_num(b, (float)vals[i], 0, 0); scpy(p, "%");
            gfx_text(&F_mono12, Q4(W - 13), Q4(y + 20), on ? C_TX : C_TX3, 255, b, 2);
        }
    }
    gfx_text_fit(&F_mono11, Q4(10), Q4(H - 7), C_TX3, hint, Q4(W - 20), 0);
}

static void action_page(void)
{
    static const char *const items[4] = { "+ Add block", "Move", "Delete", "Cancel" };
    int m, on, cat; char sub[32], *p;
    if (!engine_get(U.lane, U.col, &m, &on)) { go_home(); return; }
    cat = MODEL_DEFS[m].cat;
    p = scpy(sub, "MANAGE \xC2\xB7 "); p = scpy(p, KEY_NAMES[U.key]); *p++ = ' '; *p++ = "AB"[U.lane]; *p++ = (char)('1' + U.col); *p = 0;
    menu_screen(MODEL_NAMES[m], sub, items, 0, 4, U.menu_sel, CAT_RGB[cat], "PARA: select \xC2\xB7 press: OK");
}

static void add_page(void)
{
    static const char *items[M_COUNT]; int vals[M_COUNT], n = key_model_count(U.add_key), i, m;
    char sub[40], *p;
    if (n <= 0) { go_home(); return; }
    for (i = 0; i < n && i < M_COUNT; i++) { m = key_model_at(U.add_key, i); items[i] = MODEL_NAMES[m]; vals[i] = MODEL_DEFS[m].dsp; }
    p = scpy(sub, KEY_NAMES[U.add_key]); p = scpy(p, " \xC2\xB7 choose a model"); *p = 0;
    menu_screen("ADD BLOCK", sub, items, vals, n, U.menu_sel, CAT_RGB[MODEL_DEFS[key_model_at(U.add_key, 0)].cat], "PARA: select \xC2\xB7 press: add");
}

static void confirm_page(void)
{
    static const char *const items[2] = { "Yes", "No" };
    int m, on; char sub[40], *p;
    if (!engine_get(U.lane, U.col, &m, &on)) { go_home(); return; }
    p = scpy(sub, "Delete "); p = scpy(p, MODEL_NAMES[m]); p = scpy(p, " ?"); *p = 0;
    menu_screen("DELETE BLOCK", sub, items, 0, 2, U.menu_sel, C_BAD, "PARA: select \xC2\xB7 press: OK");
}

static void move_page(void)
{
    int m, on;
    if (!engine_get(U.lane, U.col, &m, &on)) { go_home(); return; }
    chain(); top_bar();
    gfx_rrect(0, Q4(H - 46), Q4(W), Q4(46), 0, C_BAR, 246);
    gfx_rrect(0, Q4(H - 46), Q4(W), Q4(1), 0, C_LINE, 255);
    gfx_text_fit(&F_bold15, Q4(10), Q4(H - 27), C_TX, MODEL_NAMES[m], Q4(W - 20), 0);
    gfx_text_fit(&F_mono11, Q4(10), Q4(H - 10), CAT_RGB[MODEL_DEFS[m].cat], "PARA: move \xC2\xB7 press: finish", Q4(W - 20), 0);
}

/* ---------------- écrans superposés ---------------- */
static void preset_overlay(void)
{
    const char *name = proto_preset_name();
    char lines[3][32], lab[4];
    int nl = 1, i, li = 0, y0;
    lines[0][0] = 0;
    /* découpe en mots sur la largeur W - 24 (comme ecran.js) */
    {
        const char *s = name; char word[32];
        while (*s && nl <= 3) {
            int wn = 0; char t[64];
            while (*s == ' ') s++;
            while (*s && *s != ' ' && wn < 31) word[wn++] = *s++;
            word[wn] = 0;
            if (!wn) break;
            { char *p = scpy(t, lines[li]); if (lines[li][0]) *p++ = ' '; scpy(p, word); }
            if (gfx_text_width(&F_bold28, t) > Q4(W - 24) && lines[li][0]) { if (nl == 3) break; li++; nl++; scpy(lines[li], word); }
            else { int k; for (k = 0; t[k] && k < 31; k++) lines[li][k] = t[k]; lines[li][k] = 0; }
        }
    }
    y0 = H / 2 - (nl - 1) * 16 + 6;
    gfx_rrect(0, 0, Q4(W), Q4(H), 0, C_BG, 242);
    preset_label(lab, proto_preset_index());
    gfx_text(&F_mono22, Q4(W / 2), Q4(y0 - 38), proto_preset_rgb(), 255, lab, 1);
    for (i = 0; i < nl; i++) gfx_text_fit(&F_bold28, Q4(W / 2), Q4(y0 + i * 32), C_TX, lines[i], Q4(W - 14), 1);
}
static void master_overlay(void)
{
    char b[16], *p;
    float f = (U.master_db + 60) / 66;
    gfx_rrect(Q4(16), Q4(80), Q4(W - 32), Q4(92), Q4(14), 0x151a20, 255);
    gfx_rrect_stroke(Q4(16), Q4(80), Q4(W - 32), Q4(92), Q4(14), Q4(1), C_LINE, 255);
    gfx_text(&F_mono12, Q4(W / 2), Q4(106), C_TX3, 255, "MASTER", 1);
    p = fmt_num(b, U.master_db, 1, 1); scpy(p, " dB");
    gfx_text(&F_mono28, Q4(W / 2), Q4(140), C_TX, 255, b, 1);
    gfx_rrect(Q4(34), Q4(153), Q4(W - 68), Q4(6), Q4(3), 0x262c34, 255);
    gfx_rrect(Q4(34), Q4(153), Q4((W - 68) * clampf(f, 0, 1)), Q4(6), Q4(3), C_ACC, 255);
}
static void msg_overlay(void)
{
    gfx_rrect(Q4(16), Q4(96), Q4(W - 32), Q4(58), Q4(14), 0x151a20, 255);
    gfx_rrect_stroke(Q4(16), Q4(96), Q4(W - 32), Q4(58), Q4(14), Q4(1), C_LINE, 255);
    gfx_text(&F_sans16, Q4(W / 2), Q4(131), C_TX, 255, U.msg, 1);
}
static const char *const NOTE_N[12] = { "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B" };
static void tuner_screen(void)
{
    int ok = U.tuner_level && (U.tuner_cents < 3 && U.tuner_cents > -3), c;
    u32 col = ok ? C_OK : C_TX;
    float cx = W / 2.0f, barY = 176, span = 214;
    gfx_begin(ok ? 0x0b1a12 : C_BG);
    gfx_text(&F_mono12, Q4(cx), Q4(24), C_TX3, 255, "TUNER \xC2\xB7 440 Hz", 1);
    if (U.tuner_level) {
        char o[4];
        int wn = gfx_text_width(&F_bold100, NOTE_N[U.tuner_note]);
        o[0] = (char)('0' + U.tuner_oct); o[1] = 0;
        gfx_text(&F_bold100, Q4(cx), Q4(138), col, 255, NOTE_N[U.tuner_note], 1);
        gfx_text(&F_bold30, Q4(cx) + wn / 2, Q4(138 - 56), C_TX2, 255, o, 0);
    } else gfx_text(&F_sans18, Q4(cx), Q4(118), C_TX3, 255, "Play a string", 1);
    gfx_rrect(Q4(cx - span / 2), Q4(barY), Q4(span), Q4(5), Q4(2.5f), 0x1d2228, 255);
    for (c = -50; c <= 50; c += 10) {
        float tx = cx + c / 50.0f * span / 2;
        gfx_poly_begin(c == 0 ? Q4(2.5f) : Q4(1.5f), c == 0 ? C_OK : C_TX3, 255);
        gfx_poly_pt(Q4(tx), Q4(barY - ((c % 50 == 0 || c == 0) ? 11 : 6))); gfx_poly_pt(Q4(tx), Q4(barY));
        gfx_poly_end();
    }
    if (U.tuner_level) {
        float x = cx + clampf(U.tuner_cents, -50, 50) / 50 * span / 2;
        char b[12];
        gfx_poly_begin(Q4(4), col, 255); gfx_poly_pt(Q4(x), Q4(barY - 20)); gfx_poly_pt(Q4(x), Q4(barY + 14)); gfx_poly_end();
        fmt_num(b, U.tuner_cents, 1, 1);
        gfx_text(&F_mono18, Q4(cx), Q4(226), C_TX2, 255, b, 1);
    }
}

static void go_home(void); static void flash_msg(const char *t);
/* ---------------- écran SAUVEGARDER (HOME maintenu) ----------------
 * PARA tourner = emplacement 01..80, PARA appui = sauver, HOME (ou une autre touche) = annuler. */
static void save_screen(void)
{
    char lab[4], nm[24];
    const float cx = W / 2.0f;
    int cur = U.save_slot == proto_preset_index(), full = proto_slot_name(U.save_slot, nm);
    gfx_begin(C_BG);
    top_bar();
    gfx_text(&F_mono12, Q4(cx), Q4(60), C_TX3, 255, "SAVE TO", 1);
    preset_label(lab, U.save_slot);
    gfx_rrect(Q4(cx - 46), Q4(92), Q4(92), Q4(58), Q4(12), cur ? C_ACC : C_WARN, 40);
    gfx_rrect_stroke(Q4(cx - 46), Q4(92), Q4(92), Q4(58), Q4(12), Q4(2), cur ? C_ACC : C_WARN, 255);
    gfx_text(&F_bold30, Q4(cx), Q4(132), cur ? C_ACC : C_WARN, 255, lab, 1);   /* (F_bold100 n'a que les lettres des notes) */
    if (cur) gfx_text_fit(&F_sans14, Q4(cx), Q4(180), C_TX2, "current preset", Q4(220), 1);
    else if (full) {
        static char t[40];
        char *p = scpy(t, "overwrites \xC2\xAB "); p = scpy(p, nm); scpy(p, " \xC2\xBB");
        gfx_text_fit(&F_sans14, Q4(cx), Q4(180), C_WARN, t, Q4(220), 1);
    } else gfx_text_fit(&F_sans14, Q4(cx), Q4(180), C_TX2, "empty slot", Q4(220), 1);
    gfx_text_fit(&F_sans14, Q4(cx), Q4(214), C_TX3, "PARA: select \xC2\xB7 press: OK", Q4(230), 1);
    gfx_text_fit(&F_sans14, Q4(cx), Q4(232), C_TX3, "HOME: cancel", Q4(230), 1);
}
void ui_save_open(void) { U.view = V_SAVE; U.save_slot = proto_preset_index(); U.dirty = 1; }
void ui_save_close(void) { if (U.view == V_SAVE) go_home(); }
static void save_do(void)
{
    static char msg[24];
    int i = U.save_slot;
    go_home();
    if (proto_save_slot(i) == 0) { char lab[4], *p; preset_label(lab, i); p = scpy(msg, "Saved to "); scpy(p, lab); flash_msg(msg); }
    else flash_msg("Save failed");
    U.ov_until = U.ms + 1500;
}

/* ---------------- écran de démarrage : logo de l'app (icône .brand-mark + BIG BLACK RIG, BLACK en gras) ---------------- */
void ui_splash(void)
{
    const float s = 3.0f, ox = W / 2.0f - 16 * s, oy = 70 - 16 * s;  /* icône 32 x 32 de l'app, x3, centrée */
    int wa, wb, wc, x;
    gfx_begin(C_BG);
    gfx_rrect_stroke(Q4(ox + 2 * s), Q4(oy + 7 * s), Q4(28 * s), Q4(18 * s), Q4(4 * s), Q4(2 * s), C_ACC, 255);
    gfx_ring(Q4(ox + 10 * s), Q4(oy + 19 * s), Q4(3 * s), Q4(2 * s), C_ACC, 255);
    gfx_ring(Q4(ox + 22 * s), Q4(oy + 19 * s), Q4(3 * s), Q4(2 * s), C_ACC, 255);
    gfx_poly_begin(Q4(2 * s), C_ACC, 255); gfx_poly_pt(Q4(ox + 7 * s), Q4(oy + 12 * s)); gfx_poly_pt(Q4(ox + 25 * s), Q4(oy + 12 * s)); gfx_poly_end();
    /* police « logo » de gen_assets : A = BIG, B = BLACK (Inter 800), C = RIG (Inter 400) */
    wa = gfx_text_width(&F_logo, "A"); wb = gfx_text_width(&F_logo, "B"); wc = gfx_text_width(&F_logo, "C");
    x = Q4(W / 2.0f) - (wa + wb + wc) / 2;
    gfx_text(&F_logo, x, Q4(160), C_TX2, 255, "A", 0);
    gfx_text(&F_logo, x + wa, Q4(160), C_TX, 255, "B", 0);
    gfx_text(&F_logo, x + wa + wb, Q4(160), C_TX2, 255, "C", 0);
    gfx_text(&F_mono11, Q4(W / 2.0f), Q4(214), C_TX3, 255, "M-VAVE BLACKBOX", 1);
}

static int splash_test;
void ui_splash_test(void) { splash_test = 1; }                       /* (test : la prochaine image = le logo) */

/* ---------------- construction de l'écran ---------------- */
void ui_build(void)
{
    if (splash_test) { splash_test = 0; ui_splash(); return; }
    if (U.view == V_TUNER) { tuner_screen(); U.dirty = 0; return; }
    if (U.view == V_SAVE) { save_screen(); U.dirty = 0; return; }
    gfx_begin(C_BG);
    if (U.view == V_BLOCK) block_page();
    else if (U.view == V_ACTION) action_page();
    else if (U.view == V_ADD) add_page();
    else if (U.view == V_CONFIRM) confirm_page();
    else if (U.view == V_MOVE) move_page();
    else { chain(); top_bar(); }
    if (U.overlay && U.ms < U.ov_until) {
        if (U.overlay == 1) preset_overlay(); else if (U.overlay == 2) master_overlay(); else msg_overlay();
    } else U.overlay = 0;
    U.dirty = 0;
}
int ui_dirty(void) { return U.dirty; }
void ui_touch(void) { U.dirty = 1; }
/* LED des touches FX..CAB (bits 1..6) : la touche de la page affichée, comme ecran.js.
   La LED HOME (bit 0) est le tap tempo, gérée par ui_tap_led(). */
u32 ui_leds(void) { return U.view == V_BLOCK ? (1u << U.key) : 0u; }
int ui_tap_led(void)
{
    u32 bpm = proto_tempo(), per, phase;
    if (bpm < 40) bpm = 40; if (bpm > 250) bpm = 250;
    per = 60000u / bpm;
    phase = (u32)(U.ms < 0 ? 0 : U.ms) % per;
    return phase < 80;                                                /* flash de 80 ms sur chaque temps */
}

/* ---------------- commandes ---------------- */
static void go_home(void) { U.view = V_HOME; U.editing = 0; U.cursor = -1; U.dirty = 1; }
static void flash_msg(const char *t) { U.msg = t; U.overlay = 3; U.ov_until = U.ms + 900; U.dirty = 1; }
/* budget DSP : preset ou bloc refusé, ou surcharge détectée (effets coupés) */
void ui_msg_dsp(void) { flash_msg("Insufficient DSP"); U.ov_until = U.ms + 2000; }
void ui_msg_overload(void) { flash_msg("DSP overload"); U.ov_until = U.ms + 3000; }
void ui_key(int k)                                  /* 0 HOME, 1 FX .. 6 CAB */
{
    int ol[16], oc[16], n = order(ol, oc), i, cur = -1, list[16], nl = 0, m, on;
    if (U.view == V_TUNER) { U.view = V_HOME; }
    if (U.view == V_SAVE) { go_home(); return; }                 /* toute touche annule la sauvegarde */
    if (U.view == V_MOVE) { proto_notify_structure(); U.view = V_BLOCK; }   /* termine le déplacement */
    else if (U.view == V_ACTION || U.view == V_ADD || U.view == V_CONFIRM) U.view = V_BLOCK;
    if (k == 0) { go_home(); return; }
    U.prev_was_block = U.view == V_BLOCK; U.prev_lane = U.lane; U.prev_col = U.col; U.prev_key = U.key;
    for (i = 0; i < n; i++) { engine_get(ol[i], oc[i], &m, &on); if (key_has_cat(k, MODEL_DEFS[m].cat)) list[nl++] = i; }
    if (!nl) {                                                  /* famille vide : on ouvre directement l'ajout */
        U.view = V_ADD; U.add_key = k; U.key = k; U.menu_sel = 0; U.dirty = 1; return;
    }
    if (U.view == V_BLOCK && U.key == k) for (i = 0; i < nl; i++) if (ol[list[i]] == U.lane && oc[list[i]] == U.col) cur = i;
    i = list[(cur + 1) % nl];
    U.view = V_BLOCK; U.lane = ol[i]; U.col = oc[i]; U.key = k; U.pidx = 0; U.editing = 0; U.dirty = 1;
}
/* maintien d'une touche FX..CAB : gérer le bloc affiché (ajouter / déplacer / supprimer) */
void ui_key_hold(int k)
{
    int m, on;
    if (k < 1 || k > 6 || U.view != V_BLOCK || U.key != k) return;
    /* si l'appui vient de faire défiler la famille, on revient au bloc qui était affiché avant */
    if (U.prev_was_block && U.prev_key == k && engine_get(U.prev_lane, U.prev_col, &m, &on) && key_has_cat(k, MODEL_DEFS[m].cat)) {
        U.lane = U.prev_lane; U.col = U.prev_col;
    }
    U.view = V_ACTION; U.menu_sel = 0; U.dirty = 1;
}
static int key_of_cat(int cat) { int k; for (k = 1; k <= 6; k++) if (key_has_cat(k, cat)) return k; return 1; }
/* modèles proposés par une touche (les blocs « utilitaire » restent lisibles mais ne sont plus proposés) */
static int key_model_count(int k)
{
    int m, n = 0;
    for (m = 0; m < M_COUNT; m++) if (MODEL_DEFS[m].cat != CAT_UTIL && key_has_cat(k, MODEL_DEFS[m].cat)) n++;
    return n;
}
static int key_model_at(int k, int idx)
{
    int m, n = 0;
    for (m = 0; m < M_COUNT; m++) if (MODEL_DEFS[m].cat != CAT_UTIL && key_has_cat(k, MODEL_DEFS[m].cat)) {
        if (n == idx) return m;
        n++;
    }
    return -1;
}
/* premier emplacement libre : on ajoute après le dernier bloc de la rangée A, sinon un trou de A, sinon B */
static int first_free_slot(int *lane, int *col)
{
    int c, m, on, last = -1;
    for (c = 0; c < CAT_COLS; c++) if (engine_get(0, c, &m, &on)) last = c;
    for (c = last + 1; c < CAT_COLS; c++) if (!engine_get(0, c, &m, &on)) { *lane = 0; *col = c; return 1; }
    for (c = 0; c < CAT_COLS; c++) if (!engine_get(0, c, &m, &on)) { *lane = 0; *col = c; return 1; }
    for (c = 0; c < CAT_COLS; c++) if (!engine_get(1, c, &m, &on)) { *lane = 1; *col = c; return 1; }
    return 0;
}
static float step_param(const struct param_def *pd, float v, int d)
{
    if (pd->type == 2) return v != 0 ? 0 : 1;
    if (pd->type == 1) { int n = pd->nopt, k = ((int)v + d + n) % n; return (float)k; }
    if (pd->type == 3 || pd->type == 4) {
        int n = pd->type == 3 ? CAT_IR_SLOTS : CAT_NAM_SLOTS, k = (int)v, t;
        for (t = 0; t < n; t++) { k = (k + d + n) % n; if ((pd->type == 3 ? proto_ir_name(k) : proto_nam_name(k))) return (float)k; }
        return v;
    }
    {
        float det = (pd->max - pd->min) / 40, q;
        if (det < pd->step) det = pd->step;
        q = (float)(int)(det / pd->step + 0.5f) * pd->step; if (q > det) det = q;
        v = clampf(v + d * det, pd->min, pd->max);
        return (float)(int)((v - pd->min) / pd->step + 0.5f) * pd->step + pd->min;
    }
}
void ui_para_turn(int d)
{
    int ol[16], oc[16], n = order(ol, oc), m, on;
    if (U.view == V_TUNER) return;
    if (U.view == V_SAVE) { U.save_slot = (U.save_slot + d + 80) % 80; U.dirty = 1; return; }
    if (U.view == V_ACTION) { U.menu_sel = (U.menu_sel + d + 4) % 4; U.dirty = 1; return; }
    if (U.view == V_ADD) {
        int nn = key_model_count(U.add_key);
        if (nn > 0) U.menu_sel = (U.menu_sel + d + nn) % nn;
        U.dirty = 1; return;
    }
    if (U.view == V_CONFIRM) { U.menu_sel = (U.menu_sel + d + 2) % 2; U.dirty = 1; return; }
    if (U.view == V_MOVE) {
        int nc = U.col + d;
        if (nc >= 0 && nc < CAT_COLS && engine_block_move(U.lane, U.col, U.lane, nc) == 0) U.col = nc;
        U.dirty = 1; return;
    }
    if (U.view == V_HOME) {
        if (!n) return;
        U.cursor = U.cursor < 0 ? (d > 0 ? 0 : n - 1) : (U.cursor + d + n) % n;
    } else {
        if (!engine_get(U.lane, U.col, &m, &on)) { go_home(); return; }
        if (U.editing) {
            const struct param_def *pd = &PARAM_DEFS[m][U.pidx];
            engine_param(U.lane, U.col, U.pidx, step_param(pd, engine_params(U.lane, U.col)[U.pidx], d));
        } else { U.pidx += d; if (U.pidx < 0) U.pidx = 0; if (U.pidx > MODEL_DEFS[m].nparams - 1) U.pidx = MODEL_DEFS[m].nparams - 1; }
    }
    U.dirty = 1;
}
void ui_para_press(void)
{
    int ol[16], oc[16], n = order(ol, oc), m, on;
    if (U.view == V_TUNER) { go_home(); return; }
    if (U.view == V_SAVE) { save_do(); return; }
    if (U.view == V_ACTION) {
        if (U.menu_sel == 0) { U.view = V_ADD; U.add_key = U.key; U.menu_sel = 0; }
        else if (U.menu_sel == 1) { U.view = V_MOVE; U.menu_sel = 0; }
        else if (U.menu_sel == 2) { U.view = V_CONFIRM; U.menu_sel = 1; }   /* « Non » par défaut */
        else U.view = V_BLOCK;
        U.dirty = 1; return;
    }
    if (U.view == V_ADD) {
        int mid = key_model_at(U.add_key, U.menu_sel), l = 0, c = 0, r;
        if (mid < 0) { go_home(); return; }
        if (!first_free_slot(&l, &c)) { flash_msg("Grid full"); U.ov_until = U.ms + 2000; return; }
        r = engine_block_set(l, c, mid);
        if (r == 0) {
            U.view = V_BLOCK; U.lane = l; U.col = c; U.key = U.add_key; U.pidx = 0; U.editing = 0;
            proto_notify_structure();
        } else if (r == -2) { flash_msg("Insufficient DSP"); U.ov_until = U.ms + 2000; }
        else flash_msg("Cannot add");
        U.dirty = 1; return;
    }
    if (U.view == V_CONFIRM) {
        if (U.menu_sel == 0) {
            engine_block_clear(U.lane, U.col);
            proto_notify_structure();
            go_home();
        } else U.view = V_ACTION;
        U.dirty = 1; return;
    }
    if (U.view == V_MOVE) { proto_notify_structure(); U.view = V_BLOCK; U.dirty = 1; return; }
    if (U.view == V_HOME) {
        if (U.cursor >= 0 && U.cursor < n) {
            engine_get(ol[U.cursor], oc[U.cursor], &m, &on);
            U.view = V_BLOCK; U.lane = ol[U.cursor]; U.col = oc[U.cursor]; U.key = key_of_cat(MODEL_DEFS[m].cat); U.pidx = 0; U.editing = 0;
        }
    } else U.editing = !U.editing;
    U.dirty = 1;
}
void ui_para_hold(void)
{
    int ol[16], oc[16], n = order(ol, oc), m, on;
    void proto_notify_bypass(int lane, int col, int on);              /* l'app suit le bypass fait sur la pédale */
    if (U.view == V_SAVE) return;
    if (U.view == V_BLOCK) { if (engine_get(U.lane, U.col, &m, &on)) { engine_bypass(U.lane, U.col, !on); proto_notify_bypass(U.lane, U.col, !on); } }
    else if (U.view == V_HOME && U.cursor >= 0 && U.cursor < n) { if (engine_get(ol[U.cursor], oc[U.cursor], &m, &on)) { engine_bypass(ol[U.cursor], oc[U.cursor], !on); proto_notify_bypass(ol[U.cursor], oc[U.cursor], !on); } }
    U.dirty = 1;
}
void ui_master(float db) { U.master_db = db; U.overlay = 2; U.ov_until = U.ms + 1000; U.dirty = 1; }
void ui_battery(int pct) { if (pct < 0) pct = 0; if (pct > 100) pct = 100; if (pct != batt) { batt = pct; U.dirty = 1; } }
void ui_usb(int on) { if (on != usb_on) { usb_on = on; U.dirty = 1; } }
void ui_bt_set(int on, int paired) { int s = on ? (paired ? 2 : 1) : 0; if (s != bt_state) { bt_state = s; U.dirty = 1; } }
int ui_bt_on(void) { return bt_state != 0; }
void ui_msg_bt(int on) { flash_msg(on ? "Bluetooth on" : "Bluetooth off"); }
void tuner_reset(void);
void ui_tuner(int on) { if (on && U.view != V_TUNER) { tuner_reset(); U.tuner_level = 0; } U.view = on ? V_TUNER : V_HOME; U.dirty = 1; }
int ui_tuner_on(void) { return U.view == V_TUNER; }
void ui_tuner_data(int note, int oct, float cents, int level) { U.tuner_note = note; U.tuner_oct = oct; U.tuner_cents = cents; U.tuner_level = level; U.dirty = 1; }
/* appelé ~375 fois/s : expiration des écrans superposés, détection d'un changement de preset */
void ui_tick(int ms)
{
    U.ms = ms;
    if (U.overlay && ms >= U.ov_until) { U.overlay = 0; U.dirty = 1; }
    if (proto_dirty() != U.last_dirty) { U.last_dirty = proto_dirty(); U.dirty = 1; }   /* « * » du preset modifié */
    if (proto_preset_index() != U.last_index) {
        if (U.last_index >= 0) { U.overlay = 1; U.ov_until = ms + 900; }
        U.last_index = proto_preset_index();
        if (U.view == V_BLOCK || U.view == V_ACTION || U.view == V_ADD || U.view == V_CONFIRM || U.view == V_MOVE) go_home();
        U.dirty = 1;
    }
}
