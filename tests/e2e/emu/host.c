/* host.c : émulateur de pédale TBBR pour les tests de bout en bout.
 *
 * Compile le VRAI code du firmware (proto.c, engine.c, models.c, circuit.c) pour PC (x86 32 bits, MSVC) et remplace le
 * matériel : flash NOR de 1 Mio en RAM (effacement à 0xFF, écriture = ET logique, mêmes zones autorisées que storage.c),
 * régions RAM fixes du firmware (0x1C00000..0x1C80000) réservées à la même adresse, USB MIDI = stdin/stdout.
 *
 * Protocole stdin/stdout (binaire) : [type u8][longueur u32 LE][données]
 *   entrée  'S' = SysEx reçu par la pédale (F0 .. F7)      sortie 'S' = SysEx envoyé par la pédale
 *           'B' = redémarrage (proto_boot, flash conservée)        'L' = ligne de journal (texte)
 *           'A' = audio : [n u32] échantillons de test            'A' = [pic entrée u32][pic sortie u32][NaN/sat u32]
 *           'F' = écrire la flash dans le fichier donné (texte)    'K' = accusé d'une commande hôte ('B', 'F', 'P')
 *           'P' = tic : proto_poll + jiffies                      'E' = erreur fatale (texte)
 *           'Q' = quitter
 * Options : host.exe [flash_initiale.bin] (sinon flash vierge à 0xFF + cabs.bin si trouvé à côté de l'exe).
 */
#define WIN32_LEAN_AND_MEAN
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <io.h>
#include <fcntl.h>

typedef unsigned int u32;
typedef int s32;
typedef unsigned short u16;
typedef unsigned char u8;

/* ---------------- sortie ---------------- */
static void out_msg(char t, const void *p, u32 n)
{
    fwrite(&t, 1, 1, stdout);
    fwrite(&n, 4, 1, stdout);
    if (n) fwrite(p, 1, n, stdout);
    fflush(stdout);
}
static void logf_(const char *fmt, ...)
{
    char b[512];
    va_list a;
    va_start(a, fmt); vsnprintf(b, sizeof b, fmt, a); va_end(a);
    out_msg('L', b, (u32)strlen(b));
}
static void fatal(const char *fmt, ...)
{
    char b[512];
    va_list a;
    va_start(a, fmt); vsnprintf(b, sizeof b, fmt, a); va_end(a);
    out_msg('E', b, (u32)strlen(b));
    exit(3);
}

/* ---------------- mémoire fixe du firmware ---------------- */
#define RAM_LO 0x1C00000u
#define RAM_SZ 0x80000u
static void map_fixed(void)
{
    void *p = VirtualAlloc((void *)RAM_LO, RAM_SZ, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
    if (p != (void *)RAM_LO) fatal("VirtualAlloc 0x%08X impossible (erreur %lu)", RAM_LO, GetLastError());
}

/* ---------------- flash NOR 1 Mio ---------------- */
#define FLASH_SZ 0x100000u
static u8 *flash;
static u32 st_err, n_erase, n_write, bad_write;
static u32 in_store(u32 a, u32 n)
{
    if (n > 0x100000u || a + n < a) return 0;
    return (a >= 0x60000u && a + n <= 0xC2000u) || (a >= 0xC3000u && a + n <= 0x100000u);
}
const u8 *storage_ptr(u32 a) { return flash + a; }
int storage_erase(u32 a)
{
    if ((a & 0xFFF) || !in_store(a, 0x1000)) { st_err++; logf_("storage_erase refusé 0x%05X", a); return -1; }
    memset(flash + a, 0xFF, 0x1000); n_erase++;
    return 0;
}
int storage_write(u32 a, const u8 *src, u32 len)
{
    u32 i;
    if (!in_store(a, len)) { st_err++; logf_("storage_write refusé 0x%05X+%u", a, len); return -1; }
    for (i = 0; i < len; i++) {
        u8 o = flash[a + i], v = src[i];
        if ((o & v) != v) bad_write++;                               /* bit 0 -> 1 sans effacement : donnée corrompue sur la vraie flash */
        flash[a + i] = o & v;
    }
    n_write++;
    return 0;
}
u32 storage_errors(void) { return st_err; }
u32 storage_init(void) { return 0; }

/* ---------------- USB MIDI ---------------- */
int usb_midi_send_sysex(const u8 *m, u32 n) { out_msg('S', m, n); return 1; }
u32 usb_midi_tx_free(void) { return 8192; }

/* ---------------- divers du matériel / main.c ---------------- */
volatile u32 jiffies;
void wdt_clear(void) {}
void main_set_in_gate(int on, int db) { (void)on; (void)db; }
void main_audio_grace(void) {}
int proto_battery_pct(void) { return 77; }
int proto_battery_mv(void) { return 3950; }
int proto_usb(void) { return 1; }
int proto_bt_state(void) { return 0; }
void proto_last_reset(u32 *r) { r[0] = 1; r[1] = 0; r[2] = 0; r[3] = 0; r[4] = 0; r[5] = 0; }
void ui_msg_dsp(void) {}
const char *const FW_VERSION_STR = TBBR_FW_VERSION;

/* firmware : déclarations utilisées ici */
void proto_boot(void);
void proto_poll(void);
void proto_frames_sysex(const u8 *m, u32 n);
s32 engine_process(s32 x);

/* ---------------- boucle principale ---------------- */
static int rd(void *p, u32 n) { return fread(p, 1, n, stdin) == n; }
int main(int argc, char **argv)
{
    static u8 buf[1 << 20];
    _setmode(_fileno(stdin), _O_BINARY);
    _setmode(_fileno(stdout), _O_BINARY);
    map_fixed();
    flash = (u8 *)malloc(FLASH_SZ);
    memset(flash, 0xFF, FLASH_SZ);
    if (argc > 1) {
        FILE *f = fopen(argv[1], "rb");
        if (!f) fatal("flash initiale introuvable : %s", argv[1]);
        fread(flash, 1, FLASH_SZ, f); fclose(f);
    } else {                                                         /* cabs d'usine à leur adresse, comme l'installateur */
        char p[MAX_PATH], *s;
        GetModuleFileNameA(0, p, MAX_PATH); s = strrchr(p, '\\'); if (s) strcpy(s + 1, "cabs.bin");
        { FILE *f = fopen(p, "rb"); if (f) { fread(flash + 0xF3000, 1, 0xC000, f); fclose(f); } }
    }
    proto_boot();
    logf_("boot OK (%s)", FW_VERSION_STR);
    for (;;) {
        u8 t; u32 n;
        if (!rd(&t, 1) || !rd(&n, 4)) break;
        if (n > sizeof buf) fatal("message trop long (%u)", n);
        if (n && !rd(buf, n)) break;
        switch (t) {
        case 'S':
            jiffies += 3;
            if (n >= 7 && buf[0] == 0xF0 && buf[1] == 0x7D && buf[2] == 0x42 && buf[3] == 0x58 && buf[4] == 0x70) proto_frames_sysex(buf, n);
            else logf_("SysEx ignoré (%u octets, cmd %02X)", n, n > 4 ? buf[4] : 0);
            proto_poll();
            break;
        case 'P': jiffies += 40; proto_poll(); out_msg('K', "P", 1); break;
        case 'B': proto_boot(); out_msg('K', "B", 1); break;
        case 'F': {
            char p[1024]; FILE *f;
            if (n >= sizeof p) fatal("chemin trop long");
            memcpy(p, buf, n); p[n] = 0;
            f = fopen(p, "wb"); if (!f) fatal("écriture impossible : %s", p);
            fwrite(flash, 1, FLASH_SZ, f); fclose(f);
            out_msg('K', "F", 1);
            break;
        }
        case 'A': {                                                  /* bruit + sinus 220 Hz à -12 dBFS (Q23) dans le moteur */
            u32 cnt = n >= 4 ? *(u32 *)buf : 48000, i, pin = 0, pout = 0, bad = 0, r[3];
            for (i = 0; i < cnt; i++) {
                s32 x = (s32)(0.25 * 8388607.0 * sin(2 * 3.14159265358979 * 220.0 * i / 48000.0)), y;
                y = engine_process(x);
                if ((u32)abs(x) > pin) pin = (u32)abs(x);
                if (y == (s32)0x80000000 || abs(y) > 0x7FFFFF * 4) bad++;
                else if ((u32)abs(y) > pout) pout = (u32)abs(y);
            }
            r[0] = pin; r[1] = pout; r[2] = bad;
            out_msg('A', r, 12);
            break;
        }
        case 'D': {   /* un bloc seul : [u32 n, u32 modèle, u32 k, k x (u32 index, float valeur)] -> n entrées puis n sorties s32 (Q23).
                         Signal : notes de guitare (220 Hz + harmoniques, attaque puis décroissance) séparées de silences
                         et de souffle faible, pour faire travailler gates, compresseurs et queues de reverb. */
            u32 cnt = *(u32 *)buf, m = ((u32 *)buf)[1], k = ((u32 *)buf)[2], i;
            static s32 o[2 * 480000];
            s32 engine_block_set_force(int, int, int); int engine_param(int, int, int, float); void engine_clear(void);
            u32 seed = 1;
            if (cnt > 480000) cnt = 480000;
            engine_clear();
            if (engine_block_set_force(0, 0, (int)m) != 0) fatal("modèle %u refusé", m);
            for (i = 0; i < k; i++) engine_param(0, 0, (int)((u32 *)buf)[3 + 2 * i], ((float *)buf)[4 + 2 * i]);
            for (i = 0; i < cnt; i++) {
                u32 t = i % 36000;                                       /* 0,75 s : 0,5 s de note, 0,25 s de silence */
                double env = t < 24000 ? exp(-(double)t / 9000.0) * (t < 96 ? t / 96.0 : 1) : 0, ph = 2 * 3.14159265358979 * 220.0 * i / 48000.0;
                double a = (i / 36000) % 3 == 0 ? 0.6 : ((i / 36000) % 3 == 1 ? 0.15 : 0.03);
                seed = seed * 1664525u + 1013904223u;
                o[i] = (s32)((a * env * (sin(ph) + 0.4 * sin(2 * ph) + 0.2 * sin(3 * ph)) + ((s32)seed >> 20) / 2048.0 * 0.0003) * 8388607.0);
                o[cnt + i] = engine_process(o[i]);
            }
            out_msg('D', o, cnt * 8);
            break;
        }
        case 'Y': {   /* signal libre dans la grille chargée (PRESET_SET avant) : [n x s32 Q23] -> n sorties s32 (réponse en fréquence, accords) */
            u32 cnt = n / 4, i;                                          /* tampon d'entrée de 1 Mo : 262 144 échantillons au plus */
            static s32 yo[262144];
            for (i = 0; i < cnt; i++) yo[i] = engine_process(((s32 *)buf)[i]);
            out_msg('Y', yo, cnt * 4);
            break;
        }
        case 'T': {   /* chronométrage d'un bloc seul (même charge utile que 'D', modèle 0xFFFF = grille vide) :
                         meilleur de 7 passes de n échantillons -> double, nanosecondes par échantillon (processeur du PC) */
            u32 cnt = *(u32 *)buf, m = ((u32 *)buf)[1], k = ((u32 *)buf)[2], i, rep;
            static s32 xin[480000];
            s32 engine_block_set_force(int, int, int); int engine_param(int, int, int, float); void engine_clear(void);
            LARGE_INTEGER f, t0, t1;
            double best = 1e30;
            volatile s32 sink = 0;
            if (cnt > 480000) cnt = 480000;
            for (i = 0; i < cnt; i++) xin[i] = (s32)(0.3 * 8388607.0 * sin(2 * 3.14159265358979 * 220.0 * i / 48000.0) * exp(-(double)(i % 24000) / 9000.0));
            engine_clear();
            if (m != 0xFFFF && engine_block_set_force(0, 0, (int)m) != 0) fatal("modèle %u refusé", m);
            for (i = 0; i < k; i++) engine_param(0, 0, (int)((u32 *)buf)[3 + 2 * i], ((float *)buf)[4 + 2 * i]);
            QueryPerformanceFrequency(&f);
            for (rep = 0; rep < 7; rep++) {
                QueryPerformanceCounter(&t0);
                for (i = 0; i < cnt; i++) sink += engine_process(xin[i]);
                QueryPerformanceCounter(&t1);
                { double ns = (double)(t1.QuadPart - t0.QuadPart) * 1e9 / (double)f.QuadPart / cnt; if (ns < best) best = ns; }
            }
            out_msg('T', &best, 8);
            break;
        }
        case 'M': {   /* message MIDI court reçu en USB (pédalier externe) : même aiguillage que usb_midi.c rx_packets */
            void proto_midi_program(int ch, int prog);
            if (n >= 2 && (buf[0] & 0xF0) == 0xC0) proto_midi_program(buf[0] & 0x0F, buf[1] & 0x7F);
            proto_poll();
            out_msg('K', "M", 1);
            break;
        }
        case 'C': {                                                  /* compteurs flash */
            u32 r[4]; r[0] = n_erase; r[1] = n_write; r[2] = bad_write; r[3] = st_err;
            out_msg('C', r, 16);
            break;
        }
        case 'Q': return 0;
        default: fatal("type de message inconnu '%c'", t);
        }
    }
    return 0;
}
