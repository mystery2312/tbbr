/* circuit.h : circuits R-C -> filtre numérique (circuit.c) */
#pragma once
#define CMAXN 6                       /* nœuds inconnus au plus */
#define IIR_MAX 6                     /* ordre du filtre au plus */
enum { RC_R, RC_C };
struct rc { unsigned char t, a, b; float v; };                     /* résistance (ohms) ou capacité (farads) entre a et b */
struct iir { int n; float b[IIR_MAX + 1], a[IIR_MAX + 1], z[IIR_MAX + 1]; };
int circuit_design(struct iir *f, const struct rc *e, int ne, int nn, int out, float fs);   /* fs : 48 000 ou 96 000 (suréchantillonné) */
void iir_reset(struct iir *f);
float pot_taper(float x, int taper);
/* forme transposée II */
static inline float iir_run(struct iir *f, float x)
{
    int k, n = f->n;
    float y = f->b[0] * x + f->z[0];
    if (n == 3) {                                                  /* tone stack TMB : ordre 3, déroulé */
        f->z[0] = f->b[1] * x - f->a[1] * y + f->z[1];
        f->z[1] = f->b[2] * x - f->a[2] * y + f->z[2];
        f->z[2] = f->b[3] * x - f->a[3] * y;
        return y;
    }
    for (k = 1; k < n; k++) f->z[k - 1] = f->b[k] * x - f->a[k] * y + f->z[k];
    if (n > 0) f->z[n - 1] = f->b[n] * x - f->a[n] * y;
    return y;
}
