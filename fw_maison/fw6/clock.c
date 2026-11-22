/* clock.c : fréquence du processeur (PLL2).
 *
 * Mesuré sur la pédale : PLL2_CON1 (0x119AC) = 0x0750310C au démarrage (SPL d'usine) ; les 12 bits bas N = 268 donnent
 * F = (N + 2) * 4 / 3 MHz = 360 MHz (confirmé par les micro-mesures). Le firmware UltraRig de la BlackBox tourne à 396 MHz
 * (N = 295) avec le même SPL.
 *
 * Changement : tout le code ci-dessous est en RAM, car la flash (XIP par le SFC) est suspendue pendant la transition.
 *   1. le 2e cœur est garé dans une boucle en RAM ;
 *   2. attente du cache d'instructions au repos (0x1EEE008 bit 14), bits 8-9 de ce registre mis à 0 (accès flash du cache) ;
 *   3. attente du SFC au repos (0x40200 bit 31 = 0), puis SFC désactivé (bit 0) ;
 *   4. écriture de N dans PLL2_CON1, attente de la stabilisation ;
 *   5. SFC puis cache rétablis. */
typedef unsigned int u32;
#define PLL2_CON1 (*(volatile u32 *)0x119ACu)
#define CACHE_CON (*(volatile u32 *)0x1EEE008u)
#define SFC_CON   (*(volatile u32 *)0x40200u)
#define RAMCODE __attribute__((section(".sram"), noinline))
#define csync() __asm__ volatile ("csync" ::: "memory")
void core1_park(void), core1_unpark(void);

RAMCODE static void spin(u32 n) { volatile u32 c = n; while (c) c--; }
RAMCODE static int wait_idle(void)
{
    u32 t;
    for (t = 0; t < 2000000u; t++) if (CACHE_CON & 0x4000u) break;
    if (t >= 2000000u) return -1;
    return 0;
}
RAMCODE static int pll2_switch(u32 n)
{
    u32 cache, sfc, t;
    if (wait_idle()) return -1;
    cache = CACHE_CON;
    CACHE_CON = cache & ~0x300u;
    for (t = 0; t < 2000000u; t++) if (!(SFC_CON & 0x80000000u)) break;
    if (t >= 2000000u) { CACHE_CON = cache; return -2; }
    sfc = SFC_CON;
    SFC_CON = sfc & ~1u;
    csync();
    spin(20000);
    PLL2_CON1 = (PLL2_CON1 & ~0xFFFu) | (n & 0xFFFu);
    csync();
    spin(400000);
    wait_idle();
    for (t = 0; t < 2000000u; t++) if (!(SFC_CON & 0x80000000u)) break;
    SFC_CON = sfc;
    csync();
    spin(20000);
    CACHE_CON = (CACHE_CON & ~0x300u) | (cache & 0x300u);
    csync();
    return 0;
}
u32 clock_mhz(void) { return ((PLL2_CON1 & 0xFFFu) + 2u) * 4u / 3u; }
/* règle l'horloge (MHz, multiple de 4/3 arrondi) ; renvoie la nouvelle fréquence ou < 0 si refus/échec */
int clock_set_mhz(u32 mhz)
{
    u32 n;
    int r;
    if (mhz < 240 || mhz > 480) return -10;                /* garde-fou */
    n = mhz * 3u / 4u - 2u;
    core1_park();
    r = pll2_switch(n);
    core1_unpark();
    return r < 0 ? r : (int)clock_mhz();
}
