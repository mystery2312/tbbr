/* gfx.c : rendu lissé ligne par ligne, en calcul entier (aucun flottant par pixel).
 * Chaque élément calcule une couverture 0..16 par pixel (distance signée au bord, en 1/16 px), puis mélange en RGB888.
 * Les éléments sont composés dans l'ordre d'ajout (comme le SVG de ecran.js). */
#include "gfx.h"
typedef unsigned int u32;
typedef int s32;
typedef long long s64;
typedef short s16;
typedef unsigned short u16;
typedef unsigned char u8;

enum { OP_RRECT, OP_RSTROKE, OP_CIRC, OP_RING, OP_POLY, OP_TEXT };
struct op {
    u8 type, alpha;
    u16 n;                     /* POLY : nombre de points ; TEXT : longueur */
    u32 rgb;
    s16 by0, by1, bx0, bx1;    /* boîte englobante en pixels (bornes incluses) */
    s32 a, b, c, d, e, f;      /* paramètres (Q4) selon le type */
    u16 off;                   /* POLY : 1er point ; TEXT : 1er caractère */
    const struct gfont *font;
};
#define MAX_OPS 260
#define MAX_PTS 1400
#define MAX_TXT 1200
#define GFXBSS __attribute__((section(".gfxbss")))
static struct op ops[MAX_OPS] GFXBSS;
static s16 pts[MAX_PTS * 2] GFXBSS;
static char txt[MAX_TXT] GFXBSS;
static int nops, npts, ntxt;
static u32 bg;

int gfx_ops(void) { return nops; }
void gfx_begin(unsigned int bg_rgb) { nops = 0; npts = 0; ntxt = 0; bg = bg_rgb; }

static s32 isqrt(u32 v)                          /* racine entière */
{
    u32 r = 0, b = 1u << 30;
    while (b > v) b >>= 2;
    while (b) { if (v >= r + b) { v -= r + b; r = (r >> 1) + b; } else r >>= 1; b >>= 2; }
    return (s32)r;
}
static s32 iabs(s32 v) { return v < 0 ? -v : v; }
static s32 clampi(s32 v, s32 a, s32 b) { return v < a ? a : (v > b ? b : v); }
static struct op *newop(int type, u32 rgb, int alpha, s32 x0, s32 y0, s32 x1, s32 y1)   /* boîte en Q4 */
{
    struct op *o;
    if (nops >= MAX_OPS) return 0;
    o = &ops[nops++];
    o->type = (u8)type; o->rgb = rgb; o->alpha = (u8)clampi(alpha, 0, 255); o->n = 0; o->off = 0; o->font = 0;
    o->bx0 = (s16)clampi((x0 >> 4) - 1, 0, GW - 1); o->bx1 = (s16)clampi((x1 >> 4) + 1, 0, GW - 1);
    o->by0 = (s16)clampi((y0 >> 4) - 1, 0, GH - 1); o->by1 = (s16)clampi((y1 >> 4) + 1, 0, GH - 1);
    return o;
}
void gfx_rrect(int x, int y, int w, int h, int r, unsigned int rgb, int alpha)
{
    struct op *o = newop(OP_RRECT, rgb, alpha, x, y, x + w, y + h);
    if (!o) return;
    o->a = x + w / 2; o->b = y + h / 2; o->c = w / 2; o->d = h / 2; o->e = r < (w < h ? w : h) / 2 ? r : (w < h ? w : h) / 2;
}
void gfx_rrect_stroke(int x, int y, int w, int h, int r, int sw, unsigned int rgb, int alpha)
{
    struct op *o = newop(OP_RSTROKE, rgb, alpha, x - sw, y - sw, x + w + sw, y + h + sw);
    if (!o) return;
    o->a = x + w / 2; o->b = y + h / 2; o->c = w / 2; o->d = h / 2; o->e = r < (w < h ? w : h) / 2 ? r : (w < h ? w : h) / 2; o->f = sw;
}
void gfx_circle(int cx, int cy, int r, unsigned int rgb, int alpha)
{
    struct op *o = newop(OP_CIRC, rgb, alpha, cx - r, cy - r, cx + r, cy + r);
    if (o) { o->a = cx; o->b = cy; o->c = r; }
}
void gfx_ring(int cx, int cy, int r, int sw, unsigned int rgb, int alpha)
{
    struct op *o = newop(OP_RING, rgb, alpha, cx - r - sw, cy - r - sw, cx + r + sw, cy + r + sw);
    if (o) { o->a = cx; o->b = cy; o->c = r; o->f = sw; }
}
static struct op *cur_poly;
int gfx_poly_begin(int sw, unsigned int rgb, int alpha)
{
    cur_poly = newop(OP_POLY, rgb, alpha, 0, 0, 0, 0);
    if (!cur_poly) return -1;
    cur_poly->off = (u16)npts; cur_poly->f = sw;
    cur_poly->a = 0x7FFFFFFF; cur_poly->b = 0x7FFFFFFF; cur_poly->c = -0x7FFFFFFF; cur_poly->d = -0x7FFFFFFF;  /* bornes Q4 */
    return 0;
}
void gfx_poly_pt(int x, int y)
{
    if (!cur_poly || npts >= MAX_PTS) return;
    pts[2 * npts] = (s16)x; pts[2 * npts + 1] = (s16)y; npts++; cur_poly->n++;
    if (x < cur_poly->a) cur_poly->a = x;
    if (y < cur_poly->b) cur_poly->b = y;
    if (x > cur_poly->c) cur_poly->c = x;
    if (y > cur_poly->d) cur_poly->d = y;
}
void gfx_poly_quad(int x0, int y0, int cx, int cy, int x1, int y1)
{
    int i;
    for (i = 1; i <= 6; i++) {                                    /* Bézier quadratique, 6 segments */
        s32 t = i * 16 / 6 * 16 / 16, u;                          /* t sur 16 */
        t = i * 256 / 6; u = 256 - t;
        gfx_poly_pt((int)(((s64)u * u * x0 + 2 * (s64)u * t * cx + (s64)t * t * x1) >> 16),
                    (int)(((s64)u * u * y0 + 2 * (s64)u * t * cy + (s64)t * t * y1) >> 16));
    }
}
void gfx_poly_end(void)
{
    struct op *o = cur_poly;
    s32 sw;
    if (!o) return;
    sw = o->f;
    o->bx0 = (s16)clampi(((o->a - sw) >> 4) - 1, 0, GW - 1); o->bx1 = (s16)clampi(((o->c + sw) >> 4) + 1, 0, GW - 1);
    o->by0 = (s16)clampi(((o->b - sw) >> 4) - 1, 0, GH - 1); o->by1 = (s16)clampi(((o->d + sw) >> 4) + 1, 0, GH - 1);
    if (o->n < 2) o->alpha = 0;
    cur_poly = 0;
}
/* icône : éléments en 1/8 d'unité (0..24) -> Q4 à la taille voulue ; trait sw_units16 = largeur en 1/16 d'unité (2.5 -> 40) */
void gfx_icon(int icon, int cx, int cy, int size, int sw_units16, unsigned int rgb)
{
    const struct gicon *ic = &ICONS[icon];
    int i, k, x0 = cx - size / 2, y0 = cy - size / 2;
    int sw = sw_units16 * size / (24 * 16);                       /* largeur du trait en Q4 */
    for (i = 0; i < ic->count; i++) {
        const struct gielem *e = &ICON_EL[ic->first + i];
        const u8 *p = &ICON_PTS[e->off];
        if (e->type == 1) {
            int r = p[2] * size / 192;
            gfx_ring(x0 + p[0] * size / 192, y0 + p[1] * size / 192, r, sw, rgb, e->alpha);
        } else {
            if (gfx_poly_begin(sw, rgb, e->alpha)) return;
            for (k = 0; k < e->npts; k++) gfx_poly_pt(x0 + p[2 * k] * size / 192, y0 + p[2 * k + 1] * size / 192);
            gfx_poly_end();
        }
    }
}

/* ---------------- texte ---------------- */
static const struct gglyph *glyph(const struct gfont *f, u32 ch)
{
    int lo = 0, hi = f->n - 1;
    while (lo <= hi) { int m = (lo + hi) >> 1; if (f->g[m].ch == ch) return &f->g[m]; if (f->g[m].ch < ch) lo = m + 1; else hi = m - 1; }
    return 0;
}
static u32 utf8(const char **s)
{
    const u8 *p = (const u8 *)*s;
    u32 c = *p++;
    if (c >= 0xF0) { c = ((c & 7) << 18) | ((p[0] & 63) << 12) | ((p[1] & 63) << 6) | (p[2] & 63); p += 3; }
    else if (c >= 0xE0) { c = ((c & 15) << 12) | ((p[0] & 63) << 6) | (p[1] & 63); p += 2; }
    else if (c >= 0xC0) { c = ((c & 31) << 6) | (p[0] & 63); p += 1; }
    *s = (const char *)p;
    return c;
}
int gfx_text_width(const struct gfont *f, const char *s)
{
    int w = 0;
    while (*s) { const struct gglyph *g = glyph(f, utf8(&s)); if (g) w += g->adv16; }
    return w;                                                     /* adv16 = avance en 1/16 px = Q4 */
}
void gfx_text(const struct gfont *f, int x, int y, unsigned int rgb, int alpha, const char *s, int anchor)
{
    int len = 0, w;
    struct op *o;
    while (s[len]) len++;
    if (!len || ntxt + len + 1 > MAX_TXT) return;
    w = gfx_text_width(f, s);
    if (anchor == 1) x -= w / 2; else if (anchor == 2) x -= w;
    o = newop(OP_TEXT, rgb, alpha, x - 32, y - f->asc * 16 - 32, x + w + 32, y + f->desc * 16 + 32);
    if (!o) return;
    o->a = x; o->b = y; o->font = f; o->off = (u16)ntxt; o->n = (u16)len;
    { int i; for (i = 0; i < len; i++) txt[ntxt + i] = s[i]; txt[ntxt + len] = 0; ntxt += len + 1; }
}
void gfx_text_fit(const struct gfont *f, int x, int y, unsigned int rgb, const char *s, int maxw, int anchor)
{
    static char b[64];
    int n = 0, w;
    if (gfx_text_width(f, s) <= maxw) { gfx_text(f, x, y, rgb, 255, s, anchor); return; }
    while (s[n] && n < 60) { b[n] = s[n]; n++; }
    w = gfx_text_width(f, "\xE2\x80\xA6");
    for (;;) {
        b[n] = 0;
        while (n > 0 && ((u8)b[n - 1] & 0xC0) == 0x80) b[--n] = 0;          /* ne pas couper un caractère UTF-8 */
        if (n <= 1 || gfx_text_width(f, b) + w <= maxw) break;
        n--;
    }
    while (n > 0 && b[n - 1] == ' ') n--;
    b[n] = (char)0xE2; b[n + 1] = (char)0x80; b[n + 2] = (char)0xA6; b[n + 3] = 0;
    gfx_text(f, x, y, rgb, 255, b, anchor);
}

/* ---------------- composition d'une ligne ---------------- */
static u32 rowc[GW] GFXBSS;
static void blend(int x, u32 rgb, s32 a256)                     /* a256 : 0..256 */
{
    u32 d = rowc[x];
    if (a256 <= 0) return;
    if (a256 >= 256) { rowc[x] = rgb; return; }
    {
        u32 r = ((rgb >> 16) & 255) * a256 + ((d >> 16) & 255) * (256 - a256);
        u32 g = ((rgb >> 8) & 255) * a256 + ((d >> 8) & 255) * (256 - a256);
        u32 b = (rgb & 255) * a256 + (d & 255) * (256 - a256);
        rowc[x] = ((r >> 8) << 16) | ((g >> 8) << 8) | (b >> 8);
    }
}
/* distance signée (Q4) au bord d'un rectangle arrondi centré (cx, cy), demi-tailles hw, hh, rayon r */
static s32 sd_rrect(s32 px, s32 py, const struct op *o)
{
    s32 qx = iabs(px - o->a) - (o->c - o->e), qy = iabs(py - o->b) - (o->d - o->e), out, in;
    s32 mx = qx > 0 ? qx : 0, my = qy > 0 ? qy : 0;
    out = (mx && my) ? isqrt((u32)(mx * mx + my * my)) : (mx > my ? mx : my);
    in = qx > qy ? qx : qy; if (in > 0) in = 0;
    return out + in - o->e;
}
static s32 seg_d2(s32 px, s32 py, s32 ax, s32 ay, s32 bx, s32 by)   /* distance² (Q4²) au segment */
{
    s32 dx = bx - ax, dy = by - ay, wx = px - ax, wy = py - ay;
    s64 l2 = (s64)dx * dx + (s64)dy * dy, t = (s64)wx * dx + (s64)wy * dy;
    if (t <= 0 || l2 == 0) return wx * wx + wy * wy;
    if (t >= l2) { wx = px - bx; wy = py - by; return wx * wx + wy * wy; }
    {
        s32 qx = ax + (s32)((t * dx) / l2) - px, qy = ay + (s32)((t * dy) / l2) - py;
        return qx * qx + qy * qy;
    }
}
unsigned int gfx_skip_mask;                                   /* mesure : types d'opérations ignorés (bit = type) */
void gfx_render_row(int y, unsigned short *out) { gfx_render_span(y, 0, GW, out); }
/* compose les pixels [xa, xb) de la ligne y dans out[xa..xb) (morceaux courts : le rendu ne retarde pas l'audio) */
void gfx_render_span(int y, int xa, int xb, unsigned short *out)
{
    int i, x;
    s32 py = (y << 4) + 8;
    for (x = xa; x < xb; x++) rowc[x] = bg;
    for (i = 0; i < nops; i++) {
        const struct op *o = &ops[i];
        int x0, x1;
        if (y < o->by0 || y > o->by1 || !o->alpha || o->bx1 < xa || o->bx0 >= xb || (gfx_skip_mask >> o->type & 1)) continue;
        x0 = o->bx0 > xa ? o->bx0 : xa; x1 = o->bx1 < xb - 1 ? o->bx1 : xb - 1;
        switch (o->type) {
        case OP_RRECT: case OP_RSTROKE: {
            /* partie droite de la ligne (loin des coins verticalement) : intérieur plein rempli directement (rectangle)
               ou sauté (contour : couverture nulle) ; seuls les bords passent par la distance signée. */
            /* couverture pleine (rectangle) : d <= -8 ; nulle (contour) : d <= -(f/2 + 8). Hors des coins (qx, qy <= 0),
               d = max(qx, qy) - e : il suffit que qx et qy soient <= lim = min(0, e - marge). */
            s32 qy = iabs(py - o->b) - (o->d - o->e), ia = 1, ib = 0;            /* [ia, ib] = pixels « intérieurs » */
            s32 lim = o->type == OP_RRECT ? o->e - 8 : o->e - o->f / 2 - 9;
            if (lim > 0) lim = 0;
            if (qy <= lim) {
                s32 m = o->c - o->e + lim;                                        /* |px - a| <= m  <=>  qx <= lim */
                if (m > 0) { ia = (o->a - m - 8 + 15) >> 4; ib = (o->a + m - 8) >> 4; }   /* pixels dont le centre est à |dx| <= m */
            }
            for (x = x0; x <= x1; x++) {
                s32 d, cov;
                if (x >= ia && x <= ib) {
                    if (o->type == OP_RRECT) { if (o->alpha >= 255) { int xe = ib < x1 ? ib : x1; for (; x <= xe; x++) rowc[x] = o->rgb; x--; } else blend(x, o->rgb, o->alpha); }
                    else x = ib < x1 ? ib : x1;                                  /* contour : rien à l'intérieur */
                    continue;
                }
                d = sd_rrect((x << 4) + 8, py, o);
                cov = o->type == OP_RRECT ? 8 - d : o->f / 2 + 8 - iabs(d);
                cov = clampi(cov, 0, 16);
                if (cov) blend(x, o->rgb, (cov * o->alpha) >> 4);
            }
            break; }
        case OP_CIRC: case OP_RING: {
            /* intérieur : disque plein rempli directement, anneau sauté (corde à |dy| connu, marge d'un pixel) */
            s32 dy = py - o->b, ia = 1, ib = 0, rin = o->type == OP_CIRC ? o->c - 8 : o->c - o->f / 2 - 8;
            if (rin > 24 && iabs(dy) < rin - 16) {
                s32 hw = isqrt((u32)(rin * rin - dy * dy)) - 16;                  /* demi-corde intérieure (Q4), marge */
                if (hw > 0) { ia = (o->a - hw - 8 + 15) >> 4; ib = (o->a + hw - 8) >> 4; }
            }
            for (x = x0; x <= x1; x++) {
                s32 dx, d, cov;
                if (x >= ia && x <= ib) {
                    if (o->type == OP_CIRC) { if (o->alpha >= 255) rowc[x] = o->rgb; else blend(x, o->rgb, o->alpha); }
                    else x = ib < x1 ? ib : x1;
                    continue;
                }
                dx = (x << 4) + 8 - o->a; d = isqrt((u32)(dx * dx + dy * dy)) - o->c;
                cov = o->type == OP_CIRC ? 8 - d : o->f / 2 + 8 - iabs(d);
                cov = clampi(cov, 0, 16);
                if (cov) blend(x, o->rgb, (cov * o->alpha) >> 4);
            }
            break; }
        case OP_POLY: {
            const s16 *p = &pts[2 * o->off];
            s32 hw = o->f / 2, lim = (hw + 8) * (hw + 8);
            /* segments qui croisent cette ligne : choisis une fois pour la ligne (avant : tous les segments pour chaque pixel) */
            static u16 cand[MAX_PTS] GFXBSS;
            static s16 cx0[MAX_PTS] GFXBSS, cx1[MAX_PTS] GFXBSS;
            int nc = 0, k;
            for (k = 0; k + 1 < o->n; k++) {
                s32 ay = p[2 * k + 1], by = p[2 * k + 3];
                if ((ay < by ? ay : by) - hw - 16 > py || (ay > by ? ay : by) + hw + 16 < py) continue;
                {
                    s32 ax = p[2 * k], bx = p[2 * k + 2];
                    s32 lo = ((ax < bx ? ax : bx) - hw - 16 - 8) >> 4, hi = ((ax > bx ? ax : bx) + hw + 16 - 8 + 15) >> 4;
                    if (hi < x0 || lo > x1) continue;
                    cand[nc] = (u16)k; cx0[nc] = (s16)lo; cx1[nc] = (s16)hi; nc++;
                }
            }
            if (!nc) break;
            for (x = x0; x <= x1; x++) {
                s32 px = (x << 4) + 8, best = 0x7FFFFFFF, j, cov;
                for (j = 0; j < nc; j++) {
                    s32 d2;
                    if (x < cx0[j] || x > cx1[j]) continue;
                    k = cand[j];
                    d2 = seg_d2(px, py, p[2 * k], p[2 * k + 1], p[2 * k + 2], p[2 * k + 3]);
                    if (d2 < best) best = d2;
                }
                if (best >= lim) continue;
                cov = clampi(hw + 8 - isqrt((u32)best), 0, 16);
                if (cov) blend(x, o->rgb, (cov * o->alpha) >> 4);
            }
            break; }
        case OP_TEXT: {
            const struct gfont *f = o->font;
            const char *s = &txt[o->off];
            s32 pen = o->a;                                       /* Q4 */
            while (*s) {
                const struct gglyph *g = glyph(f, utf8(&s));
                if (!g) continue;
                {
                    int gx = (pen >> 4) + g->x, gy = (o->b >> 4) + g->y, gw = g->w;
                    if (y >= gy && y < gy + g->h && gw) {
                        int row = y - gy, k;
                        for (k = 0; k < gw; k++) {
                            u32 idx = (u32)row * gw + k, v = f->data[g->off + (idx >> 1)];
                            v = (idx & 1) ? v >> 4 : v & 15;
                            if (v && gx + k >= xa && gx + k < xb) blend(gx + k, o->rgb, (s32)(v * o->alpha * 17) >> 8);
                        }
                    }
                }
                pen += g->adv16;
            }
            break; }
        }
    }
    for (x = xa; x < xb; x++) {
        u32 c = rowc[x];
        out[x] = (u16)((((c >> 16) & 0xF8) << 8) | (((c >> 8) & 0xFC) << 3) | ((c & 0xFF) >> 3));
    }
}
