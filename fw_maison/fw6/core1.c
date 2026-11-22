/* core1.c : 2e cœur de l'AC791N.
 *  - calcul NAM d'un bloc pendant que le 1er cœur traite le reste de la chaîne (boîte aux lettres MB) ;
 *  - rendu de l'écran : les morceaux de 60 pixels sont calculés ici dans un anneau (RJ), le 1er cœur ne fait que les
 *    envoyer (il est chargé par l'audio ; avant, une image prenait 0,6 à 1,2 s) ;
 *  - pause en RAM pendant les écritures en flash (le code du cœur 1 s'exécute depuis la flash).
 * Démarrage comme le firmware d'origine (0x2064BB4) : adresse d'entrée à 0x1C7FFF8, 0x10008 |= 8, 0x1EEE004 |= 8 puis &= ~2,
 * attente d'un drapeau levé par le cœur 1. */
typedef unsigned int u32;
typedef int s32;
typedef unsigned short u16;
void nam_run(void *mem, const s32 *in, s32 *out, int n);
void gfx_render_span(int y, int xa, int xb, unsigned short *out);
extern void cpu1_entry(void);

struct mbox { volatile u32 alive, req, done, busy; void *volatile mem; s32 *volatile in; s32 *volatile out; volatile u32 n, blocks, idle;
              volatile u32 park_req, parked; volatile u32 mode, ph; };   /* mode 1 : moitié avant du NAM (nam_front), phase ph */
void nam_front(void *mem, const s32 *in, int n, int ph);
#define MB ((struct mbox *)0x1C72000u)
#define csync() __asm__ volatile ("csync" ::: "memory")

/* anneau de rendu : 32 morceaux de 60 pixels (+ empreinte), 960 morceaux par image (240 lignes x 4) */
#define RJ_SLOTS 32
#define RJ_SPAN 60
#define RJ_TOTAL (240 * 4)
struct rjob { volatile u32 active, prod, cons; struct { u16 px[RJ_SPAN]; u32 hash; } s[RJ_SLOTS]; };
#define RJ ((struct rjob *)0x1C73000u)                                  /* 0x1C73000 .. 0x1C73FA0 (après C1_IN / C1_OUT, 0x1C72100 .. 0x1C72900) */

__attribute__((section(".sram"))) static void park_loop(void)          /* en RAM : la flash peut être occupée */
{
    MB->parked = 1;
    csync();
    while (MB->park_req) { }
    MB->parked = 0;
    csync();
}
static void render_one(void)
{
    u32 p = RJ->prod, k, h = 0x811C9DC5u;
    static u16 tmp[240];
    int y = (int)(p / 4), xa = (int)(p & 3) * RJ_SPAN;
    u16 *dst = RJ->s[p % RJ_SLOTS].px;
    gfx_render_span(y, xa, xa + RJ_SPAN, tmp);
    for (k = 0; k < RJ_SPAN; k++) { u16 v = tmp[xa + k]; dst[k] = v; h = (h ^ v) * 16777619u; }
    RJ->s[p % RJ_SLOTS].hash = h;
    csync();
    RJ->prod = p + 1;
    csync();
}
void cpu1_main(void)
{
    MB->alive = 1;
    csync();
    for (;;) {
        if (MB->park_req) { park_loop(); continue; }
        if (MB->req != MB->done) {
            u32 i, n = MB->n;
            void *mem = MB->mem;
            s32 *in = MB->in, *out = MB->out;
            MB->busy = 1;
            if (mem && MB->mode == 1) nam_front(mem, in, (int)n, (int)MB->ph);
            else if (mem) nam_run(mem, in, out, (int)n);
            else for (i = 0; i < n; i++) out[i] = in[i];
            MB->blocks++;
            MB->busy = 0;
            csync();
            MB->done = MB->req;
            csync();
        } else if (RJ->active && RJ->prod < RJ_TOTAL && RJ->prod - RJ->cons < RJ_SLOTS) render_one();
        else MB->idle++;                                         /* chronomètre : tours d'attente */
    }
}
/* démarre le cœur 1 ; renvoie 0 s'il a répondu */
int core1_start(void)
{
    volatile u32 *entry = (volatile u32 *)0x1C7FFF8u, *sysc = (volatile u32 *)0x10008u, *ctl = (volatile u32 *)0x1EEE004u;
    u32 save, t;
    MB->alive = 0; MB->req = 0; MB->done = 0; MB->busy = 0; MB->mem = 0; MB->blocks = 0; MB->park_req = 0; MB->parked = 0;
    MB->mode = 0; MB->ph = 0;
    RJ->active = 0; RJ->prod = 0; RJ->cons = 0;
    *entry = (u32)cpu1_entry;
    save = *sysc;
    *sysc |= 8;
    csync();
    *ctl |= 8;
    *ctl &= ~2u;
    for (t = 0; t < 20000000u && !MB->alive; t++) { }
    *sysc = save;
    return MB->alive ? 0 : -1;
}
int core1_alive(void) { return MB->alive != 0; }
/* pause du cœur 1 (boucle en RAM) pendant les accès flash ; renvoie quand il est garé (ou s'il ne tourne pas) */
void core1_park(void)
{
    u32 t;
    if (!MB->alive) return;
    MB->park_req = 1;
    csync();
    for (t = 0; t < 5000000u && !MB->parked; t++) { }
}
void core1_unpark(void) { MB->park_req = 0; csync(); }
/* soumet un bloc (non bloquant) ; le bloc précédent doit être terminé */
void core1_submit(void *mem, s32 *in, s32 *out, u32 n)
{
    MB->mem = mem; MB->in = in; MB->out = out; MB->n = n; MB->mode = 0;
    csync();
    MB->req = MB->req + 1;
    csync();
}
/* soumet la moitié avant d'un bloc NAM brut (non bloquant), résultat dans l'échange de phase ph */
void core1_submit_front(void *mem, s32 *in, u32 n, u32 ph)
{
    MB->mem = mem; MB->in = in; MB->out = 0; MB->n = n; MB->mode = 1; MB->ph = ph;
    csync();
    MB->req = MB->req + 1;
    csync();
}
/* attend la fin du bloc soumis ; renvoie 0 si terminé, -1 si délai dépassé */
int core1_wait(u32 spins)
{
    while (MB->done != MB->req) { if (!spins--) return -1; }
    csync();
    return 0;
}
u32 core1_blocks(void) { return MB->blocks; }
u32 core1_idle(void) { return MB->idle; }

/* ---- rendu : interface pour le 1er cœur ---- */
void core1_render_start(void) { RJ->prod = 0; RJ->cons = 0; csync(); RJ->active = 1; csync(); }
/* morceau suivant prêt ? -> pointeur sur ses 60 pixels et son empreinte ; 0 sinon */
const u16 *core1_render_peek(u32 *hash)
{
    u32 c = RJ->cons;
    if (c >= RJ->prod) return 0;
    csync();
    *hash = RJ->s[c % RJ_SLOTS].hash;
    return RJ->s[c % RJ_SLOTS].px;
}
void core1_render_pop(void) { csync(); RJ->cons = RJ->cons + 1; if (RJ->cons >= RJ_TOTAL) RJ->active = 0; csync(); }
