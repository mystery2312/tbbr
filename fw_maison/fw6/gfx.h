/* gfx.h : rendu lissé ligne par ligne (liste d'éléments -> lignes RGB565), pour l'écran 240 x 240.
 * Coordonnées en 1/16 de pixel (Q4) pour les formes ; texte et icônes générés par interface/assets/gen_assets.py. */
#pragma once
#include "assets.h"
#define GW 240
#define GH 240
#define Q4(v) ((int)((v) * 16))
void gfx_begin(unsigned int bg_rgb);
void gfx_rrect(int x, int y, int w, int h, int r, unsigned int rgb, int alpha);                 /* rempli, Q4 */
void gfx_rrect_stroke(int x, int y, int w, int h, int r, int sw, unsigned int rgb, int alpha);  /* contour centré, Q4 */
void gfx_circle(int cx, int cy, int r, unsigned int rgb, int alpha);                            /* disque, Q4 */
void gfx_ring(int cx, int cy, int r, int sw, unsigned int rgb, int alpha);                      /* cercle tracé, Q4 */
int  gfx_poly_begin(int sw, unsigned int rgb, int alpha);                                       /* polyligne à bouts ronds */
void gfx_poly_pt(int x, int y);
void gfx_poly_quad(int x0, int y0, int cx, int cy, int x1, int y1);                             /* courbe Q (aplatie) */
void gfx_poly_end(void);
void gfx_icon(int icon, int cx, int cy, int size, int sw_units16, unsigned int rgb);            /* icône MODEL_GLYPH, Q4 */
int  gfx_text_width(const struct gfont *f, const char *s);                                      /* en pixels Q4 */
void gfx_text(const struct gfont *f, int x, int y, unsigned int rgb, int alpha, const char *s, int anchor);   /* anchor 0 g, 1 centre, 2 d */
void gfx_text_fit(const struct gfont *f, int x, int y, unsigned int rgb, const char *s, int maxw, int anchor); /* tronque avec … */
void gfx_render_row(int y, unsigned short *row565);                                             /* compose la ligne y */
void gfx_render_span(int y, int xa, int xb, unsigned short *row565);                            /* pixels [xa, xb) */
int  gfx_ops(void);
