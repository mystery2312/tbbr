/* stubs.c : fonctions du firmware absentes de l'émulateur.
 * - 2e cœur : absent (core1_alive = 0) -> le moteur reste sur un seul cœur ;
 * - NAM / A2L / AMX : le calcul est en assembleur pi32v2 ; ici le chargement échoue proprement (le bloc NAM laisse passer
 *   le son), mais tout le protocole autour (transfert, CRC, slots, presets) est le vrai code ;
 * - écran / Bluetooth : sans effet. */
double log10(double);
typedef unsigned int u32;
typedef int s32;
typedef unsigned char u8;

float log10f(float x) { return (float)log10((double)x); }    /* absente de la CRT x86 de MSVC (inline dans math.h) */

unsigned int nam_mem_size(void) { return 64; }
unsigned int nam_hist_bytes(int li) { (void)li; return 16; }
int nam_load(void *mem, const float *w, int nw, s32 *const *hist) { (void)mem; (void)w; (void)nw; (void)hist; return -1; }
void nam_gains(void *mem, s32 a, s32 b) { (void)mem; (void)a; (void)b; }
void nam_prewarm(void *mem, int n) { (void)mem; (void)n; }
void nam_block(void *mem, const s32 *in, s32 *out, int n) { int i; (void)mem; for (i = 0; i < n; i++) out[i] = in[i]; }
void nam_run(void *mem, const s32 *in, s32 *out, int n) { nam_block(mem, in, out, n); }
void nam_back(void *mem, s32 *out, int ph) { (void)mem; (void)out; (void)ph; }
void nam_front(void *mem, const s32 *in, int n, int ph) { (void)mem; (void)in; (void)n; (void)ph; }
void nam_set_split(void *mem, int s) { (void)mem; (void)s; }
int nam_is_raw(void *mem) { (void)mem; return 1; }
u32 a2l_mem_size(const u8 *b, u32 n) { (void)b; (void)n; return 64; }
int a2l_load(void *mem, const u8 *b, u32 n) { (void)mem; (void)b; (void)n; return -1; }
void a2l_gains(void *mem, s32 a, s32 b) { (void)mem; (void)a; (void)b; }
void a2l_prewarm(void *mem, int n) { (void)mem; (void)n; }
void a2l_block(void *mem, const s32 *in, s32 *out, int n) { nam_block(mem, in, out, n); }
u32 amx_mem_size(void) { return 64; }
int amx_load(void *mem, const u8 *b, int len) { (void)mem; (void)b; (void)len; return -1; }
void amx_gains(void *mem, s32 a, s32 b) { (void)mem; (void)a; (void)b; }
void amx_prewarm(void *mem, int n) { (void)mem; (void)n; }
void amx_block(void *mem, const s32 *in, s32 *out, int n) { nam_block(mem, in, out, n); }

int core1_alive(void) { return 0; }
void core1_submit(void *mem, s32 *in, s32 *out, u32 n) { (void)mem; (void)in; (void)out; (void)n; }
void core1_submit_front(void *mem, s32 *in, u32 n, u32 ph) { (void)mem; (void)in; (void)n; (void)ph; }
int core1_wait(u32 spins) { (void)spins; return 0; }
u32 usb_read_sofframe(int id) { (void)id; return 0; }

/* même chemin que main.c (sans la pile Bluetooth) : l'état est mémorisé dans la table meta */
void proto_bt_store(int on, int paired);
void proto_bt_set(int on, int paired) { on = on != 0; proto_bt_store(on, on && paired); }
void ui_tuner(int on) { (void)on; }
