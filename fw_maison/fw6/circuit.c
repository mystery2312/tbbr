/* circuit.c : réponse exacte de petits circuits passifs R-C (tone stacks d'amplis, filtres de pédales).
 *
 * Écrit pour ce projet. Méthode : analyse nodale (MNA) avec des admittances polynomiales en p (Y = G + p.C), entrée =
 * source de tension idéale sur le nœud 1 ; H(p) = det(Y avec la colonne de sortie remplacée par le second membre) / det(Y)
 * (règle de Cramer, déterminants de polynômes par développement de Laplace : au plus CMAXN nœuds inconnus) ; puis
 * transformée bilinéaire -> filtre numérique d'ordre n, exécuté en forme transposée II (flottant matériel).
 *
 * Mise à l'échelle (pour rester loin des limites du flottant simple) : admittances multipliées par R0 = 100 kOhm et
 * p = s / W avec W = 10 000 rad/s ; une capacité C devient c' = R0.W.C (22 nF -> 22), une résistance R devient g' = R0 / R.
 * Les potentiomètres sont décrits par deux résistances (piste haute / piste basse) calculées depuis la position. */
#include "circuit.h"

#define R0 100000.0f
#define WS 10000.0f

typedef struct { float c[CMAXN + 2]; int n; } poly;               /* c[k] : coefficient de p^k ; n = degré */

static void p_zero(poly *a) { int k; for (k = 0; k < CMAXN + 2; k++) a->c[k] = 0; a->n = 0; }
static void p_add(poly *a, const poly *b, float sgn)
{
    int k;
    for (k = 0; k <= b->n; k++) a->c[k] += sgn * b->c[k];
    if (b->n > a->n) a->n = b->n;
}
static void p_mul(poly *r, const poly *a, const poly *b)
{
    int i, j;
    p_zero(r);
    for (i = 0; i <= a->n; i++) for (j = 0; j <= b->n && i + j <= CMAXN + 1; j++) r->c[i + j] += a->c[i] * b->c[j];
    r->n = a->n + b->n > CMAXN + 1 ? CMAXN + 1 : a->n + b->n;
}

/* déterminant d'une matrice m x m de polynômes (lignes rows[], colonnes cols[]) par développement de Laplace */
static void p_det(poly *out, poly M[CMAXN][CMAXN], const int *rows, const int *cols, int m)
{
    int j, k, sub[CMAXN];
    poly acc, t, d;
    if (m == 1) { *out = M[rows[0]][cols[0]]; return; }
    p_zero(&acc);
    for (j = 0; j < m; j++) {
        int z = 1;
        for (k = 0; k <= M[rows[0]][cols[j]].n; k++) if (M[rows[0]][cols[j]].c[k] != 0) { z = 0; break; }
        if (z) continue;                                              /* terme nul : beaucoup de zéros dans ces matrices */
        for (k = 0; k < m - 1; k++) sub[k] = cols[k < j ? k : k + 1];
        p_det(&d, M, rows + 1, sub, m - 1);
        p_mul(&t, &M[rows[0]][cols[j]], &d);
        p_add(&acc, &t, (j & 1) ? -1.0f : 1.0f);
    }
    *out = acc;
}

/* éléments -> H(p) = num / den ; nœuds : 0 = masse, 1 = entrée, 2 .. nn-1 = inconnus ; renvoie l'ordre, -1 si erreur */
static int analog_tf(const struct rc *e, int ne, int nn, int out, poly *num, poly *den)
{
    poly Y[CMAXN][CMAXN], rhs[CMAXN];
    int i, j, nu = nn - 2, rows[CMAXN], cols[CMAXN], o = out - 2;
    if (nu < 1 || nu > CMAXN || o < 0 || o >= nu) return -1;
    for (i = 0; i < nu; i++) { p_zero(&rhs[i]); for (j = 0; j < nu; j++) p_zero(&Y[i][j]); }
    for (i = 0; i < ne; i++) {
        poly y;
        int a = e[i].a, b = e[i].b, ua = a >= 2 ? a - 2 : -1, ub = b >= 2 ? b - 2 : -1;
        p_zero(&y);
        if (e[i].t == RC_R) y.c[0] = R0 / (e[i].v < 1.0f ? 1.0f : e[i].v);
        else { y.c[1] = R0 * WS * e[i].v; y.n = 1; }
        if (ua >= 0) p_add(&Y[ua][ua], &y, 1);
        if (ub >= 0) p_add(&Y[ub][ub], &y, 1);
        if (ua >= 0 && ub >= 0) { p_add(&Y[ua][ub], &y, -1); p_add(&Y[ub][ua], &y, -1); }
        if (ua >= 0 && b == 1) p_add(&rhs[ua], &y, 1);                 /* courant injecté par l'entrée (Vin = 1) */
        if (ub >= 0 && a == 1) p_add(&rhs[ub], &y, 1);
    }
    for (i = 0; i < nu; i++) rows[i] = cols[i] = i;
    p_det(den, Y, rows, cols, nu);
    {
        poly Yo[CMAXN][CMAXN];
        for (i = 0; i < nu; i++) for (j = 0; j < nu; j++) Yo[i][j] = (j == o) ? rhs[i] : Y[i][j];
        p_det(num, Yo, rows, cols, nu);
    }
    {   /* termes de tête nuls (degré surestimé par les produits) : élagués */
        float mx = 0;
        for (i = 0; i <= den->n; i++) { float v = den->c[i] < 0 ? -den->c[i] : den->c[i]; if (v > mx) mx = v; }
        while (den->n > 0 && (den->c[den->n] < 0 ? -den->c[den->n] : den->c[den->n]) < 1e-7f * mx) den->n--;
        mx = 0;
        for (i = 0; i <= num->n; i++) { float v = num->c[i] < 0 ? -num->c[i] : num->c[i]; if (v > mx) mx = v; }
        while (num->n > 0 && (num->c[num->n] < 0 ? -num->c[num->n] : num->c[num->n]) < 1e-7f * mx) num->n--;
    }
    return den->n;
}

/* bilinéaire p = K (1 - z^-1) / (1 + z^-1), K = 2.fs / W ; coefficients normalisés (a[0] = 1) */
int circuit_design(struct iir *f, const struct rc *e, int ne, int nn, int out, float fs)
{
    poly num, den;
    float b[CMAXN + 2], a[CMAXN + 2], K = 2.0f * fs / WS, Kk;
    int n, k, i, j;
    if (analog_tf(e, ne, nn, out, &num, &den) < 0) return -1;
    n = den.n > num.n ? den.n : num.n;
    while (n > 0 && den.c[n] == 0 && num.c[n] == 0) n--;
    if (n > IIR_MAX) return -2;
    for (i = 0; i <= n; i++) { b[i] = 0; a[i] = 0; }
    Kk = 1;
    for (k = 0; k <= n; k++) {                                         /* c_k K^k (1 - z)^k (1 + z)^(n - k) */
        float t[CMAXN + 2], u[CMAXN + 2];
        int deg = 0;
        t[0] = 1;
        for (i = 0; i < k; i++) { u[0] = t[0]; for (j = 1; j <= deg; j++) u[j] = t[j] - t[j - 1]; u[deg + 1] = -t[deg]; deg++; for (j = 0; j <= deg; j++) t[j] = u[j]; }
        for (i = 0; i < n - k; i++) { u[0] = t[0]; for (j = 1; j <= deg; j++) u[j] = t[j] + t[j - 1]; u[deg + 1] = t[deg]; deg++; for (j = 0; j <= deg; j++) t[j] = u[j]; }
        for (j = 0; j <= n; j++) { b[j] += (k <= num.n ? num.c[k] : 0) * Kk * t[j]; a[j] += (k <= den.n ? den.c[k] : 0) * Kk * t[j]; }
        Kk *= K;
    }
    if (a[0] == 0) return -3;
    f->n = n;
    for (j = 0; j <= n; j++) { f->b[j] = b[j] / a[0]; f->a[j] = a[j] / a[0]; }
    return n;
}
/* gain du filtre analogique en continu ou à une fréquence donnée n'est pas nécessaire ici ; remise à zéro de l'état */
void iir_reset(struct iir *f) { int k; for (k = 0; k <= IIR_MAX; k++) f->z[k] = 0; }

/* potentiomètre : position 0..1, loi linéaire (taper 0) ou logarithmique « A » (taper 1, 10 % à mi-course) */
float pot_taper(float x, int taper)
{
    if (x < 0) x = 0; if (x > 1) x = 1;
    if (!taper) return x;
    {   /* (100^x - 1) / 99, calculé sans powf : 100^x = e^(4,605 x), série limitée suffisante ici */
        float y = 4.6051702f * x, e = 1, t = 1;
        int i;
        for (i = 1; i < 14; i++) { t *= y / (float)i; e += t; }
        return (e - 1) / 99.0f;
    }
}
