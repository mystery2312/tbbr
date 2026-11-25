/* proto.c : protocole de l'app « The Big Black Rig » (interface/app/js/transport.js) côté pédale.
 * Trame : [A5] [CMD] [LEN lo] [LEN hi] [PAYLOAD] [XOR de CMD..fin du payload]
 * Transport USB MIDI : SysEx F0 7D 42 58 70 <trame codée 7 bits> F7 (MidiTransport de l'app). */
typedef unsigned int u32;
typedef int s32;
typedef unsigned short u16;
typedef unsigned char u8;
#include "catalog.h"
#include "engine.h"
#include "factory_presets.h"

int usb_midi_send_sysex(const u8 *m, u32 n);
void wdt_clear(void);
extern const char *const FW_VERSION_STR;
int engine_nam_c1_pct(void);                                         /* moitié avant du NAM : % du 2e cœur (engine.c) */
void engine_load_begin(void), engine_load_end(void);
void engine_level(float db);
void engine_nam_changed(int slot), engine_ir_changed(int slot);      /* capture / IR réécrite dans son emplacement */

enum {
    C_HELLO = 0x01, C_INFO = 0x02, C_ACK = 0x06, C_NAK = 0x15,
    C_PRESET_SELECT = 0x10, C_PRESET_SET = 0x11, C_PRESET_SAVE = 0x12, C_PRESET_GET = 0x13,
    C_SCENE_SELECT = 0x18, C_TEMPO = 0x19, C_LEVEL = 0x1A,
    C_BLOCK_SET = 0x20, C_BLOCK_CLEAR = 0x21, C_BLOCK_MOVE = 0x22, C_BYPASS = 0x23, C_PARAM = 0x24, C_SPLIT = 0x25,
    C_GLOBAL = 0x30, C_FS_CONFIG = 0x31, C_TUNER = 0x38, C_TUNER_DATA = 0x39,
    C_IR_BEGIN = 0x40, C_IR_CHUNK = 0x41, C_IR_END = 0x42,
    C_NAM_BEGIN = 0x44, C_NAM_CHUNK = 0x45, C_NAM_END = 0x46, C_NAM_DELETE = 0x47,
    C_FW_BEGIN = 0x50, C_FW_CHUNK = 0x51, C_FW_END = 0x52, C_METER = 0x60, C_FACTORY_RESET = 0x7E,
};

static u32 host_ok;                  /* l'app a dit HELLO : on lui envoie les vu-mètres */
static u32 host_seen;                /* dernier message de l'app (jiffies) : évite un host_ok fantôme */
extern volatile u32 jiffies;
static u32 tempo_bpm = 120;
static char preset_name[24] = "Init";
static int preset_index;
static u32 preset_rgb = 0x9aa3ad;                                   /* couleur du preset (#rrggbb de l'app) */
static float preset_level;                                           /* niveau du preset (dB) */
static const u8 *big_p;                                              /* grosse réponse en cours d'envoi (proto_poll) */
static u32 saved_mods;                                               /* engine_mods() au dernier chargement / sauvegarde */
static void notify_preset(int i, int need);
static void copy_name(char *dst, const char *s, int n, int max);
static void scene_name_fix(char *s);
static int strl(const char *s) { int n = 0; while (s[n]) n++; return n; }
static char scene_names[CAT_SCENES][17];                             /* noms des scènes du preset en cours */
/* footswitchs (définis plus bas, après le lecteur JSON) */
static void parse_fs_hook(void); static void fs_cfg_clear(void); void proto_set_fs_mode_raw(int m); static const char *fs_mode_name(int m); static int preset_saved(int i);
static int fs_mode_boot = -1, fs_mode_migrate;
static int in_gate_on(void); static int in_gate_db(void);
void proto_set_fs_mode(int m, int tell); int proto_fs_mode(void);

/* ---------------- émission ---------------- */
static u8 fbuf[1600] __attribute__((section(".gfxbss"))), sbuf[1900] __attribute__((section(".gfxbss")));
static int send_frame(u32 cmd, const u8 *pl, u32 n)
{
    u32 i, k = 0, x = 0, o = 0;
    if (n + 5 > sizeof(fbuf)) return 0;
    fbuf[k++] = 0xA5; fbuf[k++] = (u8)cmd; fbuf[k++] = (u8)n; fbuf[k++] = (u8)(n >> 8);
    for (i = 0; i < n; i++) fbuf[k++] = pl[i];
    for (i = 1; i < k; i++) x ^= fbuf[i];
    fbuf[k++] = (u8)x;
    sbuf[o++] = 0xF0; sbuf[o++] = 0x7D; sbuf[o++] = 0x42; sbuf[o++] = 0x58; sbuf[o++] = 0x70;
    for (i = 0; i < k; i += 7) {                                    /* 7 bits : en-tête puis 7 octets */
        u32 h = o++, j, hi = 0;
        for (j = 0; j < 7 && i + j < k; j++) { hi |= (u32)(fbuf[i + j] >> 7) << j; sbuf[o++] = fbuf[i + j] & 0x7F; }
        sbuf[h] = (u8)hi;
    }
    sbuf[o++] = 0xF7;
    return usb_midi_send_sysex(sbuf, o);
}
static void ack(u32 cmd) { u8 c = (u8)cmd; send_frame(C_ACK, &c, 1); }
static void nak(u32 cmd) { u8 c = (u8)cmd; send_frame(C_NAK, &c, 1); }

/* ---------------- petit générateur JSON ---------------- */
static char jb[1580] __attribute__((section(".gfxbss")));                   /* région GFX : la RAM principale est pleine */
static u32 jn;
static void js(const char *s) { while (*s && jn < sizeof(jb) - 1) jb[jn++] = *s++; }
static void jnum(s32 v)
{
    char t[12]; int i = 0;
    if (v < 0) { js("-"); v = -v; }
    do { t[i++] = (char)('0' + v % 10); v /= 10; } while (v && i < 11);
    while (i--) if (jn < sizeof(jb) - 1) jb[jn++] = t[i];
}
static void jkv_s(const char *k, const char *v, int comma) { js("\""); js(k); js("\":\""); js(v); js("\""); if (comma) js(","); }
static void jkv_n(const char *k, s32 v, int comma) { js("\""); js(k); js("\":"); jnum(v); if (comma) js(","); }

int engine_dsp_total(int skip_lane, int skip_col);
int proto_battery_pct(void);
int proto_battery_mv(void);
int proto_usb(void);
int proto_bt_state(void);
void proto_last_reset(u32 *r);
static void send_info(void)
{
    int m, first = 1;
    jn = 0;
    js("{");
    jkv_s("model", "M-VAVE Blackbox", 1);
    jkv_s("fw", FW_VERSION_STR, 1);
    jkv_s("boot", "JieLi SPL", 1);
    jkv_s("hw", "AC791N", 1);
    jkv_s("serial", "BBC0001", 1);
    jkv_s("cpu", "AC791N 2 coeurs 396 MHz", 1);
    jkv_n("presets", CAT_PRESETS, 1);
    jkv_n("irSlots", CAT_IR_SLOTS, 1);
    jkv_n("irLen", 2048, 1);
    jkv_n("namSlots", CAT_NAM_SLOTS, 1);
    jkv_s("nam", "A2 Lite", 1);
    jkv_n("namMaxKB", 8, 1);
    if (proto_battery_pct() < 0) js("\"battery\":null,"); else { jkv_n("battery", proto_battery_pct(), 1); jkv_n("batMv", proto_battery_mv(), 1); }
    jkv_n("usb", proto_usb(), 1);
    jkv_s("bt", proto_bt_state() == 2 ? "paired" : (proto_bt_state() ? "on" : "off"), 1);
    jkv_n("proto", 1, 1);
    {   /* démarrage précédent (diagnostic des redémarrages) */
        static const char *const why[] = { "power", "fs", "?", "home", "update", "audio" };
        u32 r[6];
        proto_last_reset(r);
        js("\"reset\":{"); jkv_n("boots", (s32)r[0], 1);
        jkv_s("why", r[1] == 0xFF ? "watchdog" : (r[1] < 6 ? why[r[1]] : "?"), 1);
        jkv_n("upS", (s32)r[2], 1); jkv_n("stage", (s32)r[3], 1); jkv_n("mark", (s32)r[4], 1); jkv_n("load", (s32)r[5], 0);
        js("},");
    }
    jkv_n("memFreeKB", (s32)(engine_mem_free() >> 10), 1);
    jkv_s("curPreset", preset_name, 1);
    jkv_n("curIndex", preset_index, 1);
    js("\"storage\":true,");                                        /* presets / IR / NAM sauvés par la pédale */
    js("\"models\":[");
    for (m = 0; m < M_COUNT; m++) if (engine_model_ready(m)) { if (!first) js(","); js("\""); js(MODEL_DEFS[m].id); js("\""); first = 0; }
    js("],");
    /* budget DSP mesuré sur la pédale, dans l'ordre de « models » (% du budget effets du 1er cœur ; NAM = % du 2e cœur) */
    js("\"dsp\":["); first = 1;
    for (m = 0; m < M_COUNT; m++) if (engine_model_ready(m)) { if (!first) js(","); jnum(MODEL_DEFS[m].dsp); first = 0; }
    js("],");
    jkv_n("dspUsed", engine_dsp_total(-1, -1), 1);
    jkv_n("namCpu", engine_nam_c1_pct(), 1);                        /* moitié avant du NAM : % du 2e cœur */
    jkv_s("fsMode", fs_mode_name(proto_fs_mode()), 1);
    { int proto_cab_count(void); jkv_n("cabs", proto_cab_count(), 1); }   /* cabs d'usine (IR) présents en flash */
    jkv_n("inGateOn", in_gate_on(), 1);                              /* gate d'entrée global (anti-souffle) */
    jkv_n("inGate", in_gate_db(), 1);
    js("\"saved\":\"");                                              /* presets présents dans la pédale : 1 caractère par preset */
    for (m = 0; m < CAT_PRESETS; m++) js(preset_saved(m) ? "1" : "0");
    js("\"");
    js("}");
    send_frame(C_INFO, (const u8 *)jb, jn);
}

/* ---------------- petit lecteur JSON (preset compact de l'app) ---------------- */
static const char *jp, *je;
static void ws(void) { while (jp < je && (*jp == ' ' || *jp == '\n' || *jp == '\r' || *jp == '\t')) jp++; }
static int peek(void) { ws(); return jp < je ? *jp : 0; }
static int eat(int c) { if (peek() == c) { jp++; return 1; } return 0; }
static int str(const char **s, int *n)
{
    if (!eat('"')) return 0;
    *s = jp;
    while (jp < je && *jp != '"') { if (*jp == '\\') jp++; jp++; }
    *n = (int)(jp - *s);
    if (jp < je) jp++;
    return 1;
}
static float num(void)
{
    float v = 0, sgn = 1, frac = 0.1f;
    int e = 0, es = 1;
    ws();
    if (jp < je && *jp == '-') { sgn = -1; jp++; }
    while (jp < je && *jp >= '0' && *jp <= '9') v = v * 10 + (float)(*jp++ - '0');
    if (jp < je && *jp == '.') { jp++; while (jp < je && *jp >= '0' && *jp <= '9') { v += (float)(*jp++ - '0') * frac; frac *= 0.1f; } }
    if (jp < je && (*jp == 'e' || *jp == 'E')) {
        jp++;
        if (jp < je && (*jp == '-' || *jp == '+')) { if (*jp == '-') es = -1; jp++; }
        while (jp < je && *jp >= '0' && *jp <= '9') e = e * 10 + (*jp++ - '0');
        while (e-- > 0) v = es > 0 ? v * 10 : v / 10;
    }
    return v * sgn;
}
static void skip(void);
static void skip_cont(int open, int close)
{
    int c;
    jp++;
    if (eat(close)) return;
    for (;;) {
        if (open == '{') { const char *s; int n; str(&s, &n); eat(':'); }
        skip();
        c = peek();
        if (c == ',') { jp++; continue; }
        if (c == close) { jp++; return; }
        return;
    }
}
static void skip(void)
{
    int c = peek();
    const char *s; int n;
    if (c == '{') skip_cont('{', '}');
    else if (c == '[') skip_cont('[', ']');
    else if (c == '"') str(&s, &n);
    else if (c == 't') jp += 4;
    else if (c == 'f') jp += 5;
    else if (c == 'n') jp += 4;
    else num();
}
static int key_is(const char *s, int n, const char *k) { int i; for (i = 0; i < n && k[i] == s[i]; i++) { } return i == n && k[i] == 0; }

void ui_msg_dsp(void);
/* budget DSP d'un preset JSON, sans rien appliquer : somme des coûts sur le 1er cœur (NAM = sa moitié arrière).
   Renvoie 1000 si le preset est impossible (plus d'un NAM, ou NAM trop lourd pour le 2e cœur). */
/* Limite de CHARGEMENT d'un preset existant : 115 % (les coûts peuvent augmenter d'une version à l'autre, ex. cabs à IR en 0.8 ;
   mesuré sans décrochage jusqu'à 132 %, et le garde-fou de surcharge protège). La construction dans l'app reste limitée à 100 %. */
#define DSP_LOAD_MAX 115
int preset_dsp(const char *txt, u32 len)
{
    const char *s; int n, l, c, tot = 0, nams = 0;
    jp = txt; je = txt + len;
    if (!eat('{')) return 0;
    while (peek() == '"') {
        str(&s, &n); eat(':');
        if (key_is(s, n, "lanes")) {
            eat('[');
            for (l = 0; l < 2 && peek() == '['; l++) {
                eat('[');
                for (c = 0; c < CAT_COLS && peek() != ']'; c++) {
                    if (peek() == '"') {
                        int m;
                        str(&s, &n); m = engine_model_by_name(s, n);
                        if (m == M_NAM) nams++;
                        if (m >= 0) tot += MODEL_DEFS[m].dsp;            /* NAM : sa moitié arrière (1er cœur) */
                    } else skip();
                    eat(',');
                }
                eat(']'); eat(',');
            }
            return (nams > 1 || (nams && engine_nam_c1_pct() > 100)) ? 1000 : tot;
        }
        skip(); eat(',');
    }
    return tot;
}
static int apply_preset_json(const char *txt, u32 len)
{
    const char *s; int n, l, c, sc = 0, cur = 0, npar = 0, i;
    float level = 0;
    static float pv[MAX_PARAMS + 3];
    static u8 par_from[CAT_COLS], par_to[CAT_COLS], par_mix[CAT_COLS];   /* « par » arrive avant « lanes » : appliqué à la fin */
    jp = txt; je = txt + len;
    if (!eat('{')) return -1;
    engine_clear();
    engine_load_begin();                                             /* mémoire des délais allouée à la fin (engine.c) */
    preset_level = 0; preset_rgb = 0x9aa3ad; copy_name(preset_name, "Preset", 6, 24);
    for (i = 0; i < CAT_SCENES; i++) { static const char *const SN[CAT_SCENES] = { "Rhythm", "Lead", "Clean", "Solo", "Ambience", "Scene F", "Scene G", "Scene H" }; copy_name(scene_names[i], SN[i], strl(SN[i]), 17); }
    fs_cfg_clear();                                                  /* actions stomp : celles du nouveau preset */
    while (peek() == '"') {
        str(&s, &n); eat(':');
        if (key_is(s, n, "lanes")) {
            eat('[');
            for (l = 0; l < 2 && peek() == '['; l++) {
                eat('[');
                for (c = 0; c < CAT_COLS && peek() != ']'; c++) {
                    if (peek() == '"') { str(&s, &n); { int m = engine_model_by_name(s, n); if (m >= 0) engine_block_set(l, c, m); } }
                    else skip();
                    eat(',');
                }
                eat(']'); eat(',');
            }
            while (peek() != ']' && peek()) skip(), eat(',');
            eat(']');
        } else if (key_is(s, n, "scenes")) {
            eat('[');
            for (sc = 0; peek() == '{'; sc++) {
                eat('{');
                while (peek() == '"') {
                    str(&s, &n); eat(':');
                    if (key_is(s, n, "b")) {
                        eat('[');
                        while (peek() == '[') {                         /* [lane, col, on, p0, p1, ...] */
                            int k = 0;
                            eat('[');
                            while (peek() != ']' && peek() && k < MAX_PARAMS + 3) { pv[k++] = num(); eat(','); }
                            while (peek() != ']' && peek()) skip(), eat(',');
                            eat(']'); eat(',');
                            if (k >= 3 && sc < CAT_SCENES) engine_scene_store(sc, (int)pv[0], (int)pv[1], pv[2] != 0, pv + 3, k - 3);
                        }
                        eat(']');
                    } else if (key_is(s, n, "n") && sc < CAT_SCENES) {
                        if (str(&s, &n)) { copy_name(scene_names[sc], s, n, 17); scene_name_fix(scene_names[sc]); }
                    } else skip();
                    eat(',');
                }
                eat('}'); eat(',');
            }
            eat(']');
        } else if (key_is(s, n, "par")) {
            eat('[');
            while (peek() == '{') {
                int from = 0, to = 0, mix = 50;
                eat('{');
                while (peek() == '"') {
                    str(&s, &n); eat(':');
                    if (key_is(s, n, "from")) from = (int)num(); else if (key_is(s, n, "to")) to = (int)num(); else if (key_is(s, n, "mix")) mix = (int)num(); else skip();
                    eat(',');
                }
                eat('}'); eat(',');
                if (npar < CAT_COLS) { par_from[npar] = (u8)from; par_to[npar] = (u8)to; par_mix[npar] = (u8)mix; npar++; }
            }
            eat(']');
        } else if (key_is(s, n, "fs")) parse_fs_hook();
        else if (key_is(s, n, "scene")) cur = (int)num();
        else if (key_is(s, n, "level")) { level = num(); preset_level = level; }
        else if (key_is(s, n, "tempo")) tempo_bpm = (u32)num();
        else if (key_is(s, n, "i")) preset_index = (int)num();
        else if (key_is(s, n, "color")) {
            if (str(&s, &n) && n == 7 && s[0] == '#') {
                u32 v = 0; int k;
                for (k = 1; k < 7; k++) { char ch = s[k]; v = v * 16 + (u32)(ch <= '9' ? ch - '0' : (ch | 32) - 'a' + 10); }
                preset_rgb = v;
            }
        }
        else if (key_is(s, n, "name")) {
            if (str(&s, &n)) { for (i = 0; i < n && i < 23; i++) preset_name[i] = s[i]; preset_name[i] = 0; }
        } else skip();
        eat(',');
    }
    for (i = 0; i < npar; i++) engine_split(par_from[i], par_to[i], par_mix[i]);
    engine_scene_select(cur);
    engine_load_end();
    engine_level(level);
    return 0;
}
static int json_int(const char *txt, u32 len, const char *key, int def)
{
    const char *s; int n;
    jp = txt; je = txt + len;
    if (!eat('{')) return def;
    while (peek() == '"') { str(&s, &n); eat(':'); if (key_is(s, n, key)) return (int)num(); skip(); eat(','); }
    return def;
}
static int json_str(const char *txt, u32 len, const char *key, const char **out, int *on)
{
    const char *s; int n;
    jp = txt; je = txt + len;
    if (!eat('{')) return 0;
    while (peek() == '"') { str(&s, &n); eat(':'); if (key_is(s, n, key)) return str(out, on); skip(); eat(','); }
    return 0;
}

/* ---------------- stockage en flash (storage.c : zones [0x60000, 0xC2000) et [0xC3000, 0x100000), chiffrées SFC) ----------------
 * 0x60000  NAM : 16 emplacements x 8 Ko (poids float32 du sous-modèle A2 Lite)
 * 0x80000  IR  : 32 emplacements x 4 Ko (2048 x int16)
 * 0xA0000  table : noms / validité des IR et NAM, dernier preset
 * 0xA2000  presets 0..31, puis 0xC3000 presets 32..79 : 1 secteur chacun = en-tête 16 o + JSON compact de l'app */
int storage_erase(u32 a);
int storage_write(u32 a, const u8 *src, u32 len);
const u8 *storage_ptr(u32 flash_addr);
#define NAM_BASE   0x60000u
#define NAM_SZ     0x2000u
#define IR_BASE    0x80000u
#define IR_SZ      0x1000u
#define META_ADDR  0xA0000u
#define TBP_MAGIC  0x31504254u                                         /* "TBP1" */
#define META_MAGIC 0x314D4254u                                         /* "TBM1" */
#define META_FS_DEFAULT 0x20000u                                       /* migration : mode preset par défaut */
struct meta_ir { u16 len; u8 valid, pad; char name[20]; };
struct meta_nam { u32 size, crc; u8 valid, pad[3]; char name[20]; };
struct meta { u32 magic, last_preset, ver, pad; struct meta_ir ir[CAT_IR_SLOTS]; struct meta_nam nam[CAT_NAM_SLOTS]; };
#define META ((struct meta *)0x1C30000u)                               /* copie RAM de la table (4 Ko libres, ancien tampon chorus fw3) */
#define CUR_JSON ((char *)0x1C31000u)                                  /* JSON du preset en cours (pour PRESET_SAVE) */
static u32 cur_json_len;
static u32 preset_addr(int i) { return i < 32 ? 0xA2000u + (u32)i * 0x1000u : 0xC3000u + (u32)(i - 32) * 0x1000u; }
static u16 crc16x(const u8 *p, u32 n) { u32 c = 0, i; while (n--) { c ^= (u32)*p++ << 8; for (i = 0; i < 8; i++) c = (c & 0x8000) ? ((c << 1) ^ 0x1021) & 0xFFFF : (c << 1) & 0xFFFF; } return (u16)c; }
static u32 crc32b(const u8 *p, u32 n) { u32 c = 0xFFFFFFFFu, k; while (n--) { c ^= *p++; for (k = 0; k < 8; k++) c = (c & 1) ? 0xEDB88320u ^ (c >> 1) : c >> 1; } return ~c; }
static void meta_load(void)
{
    const u32 *src = (const u32 *)storage_ptr(META_ADDR);
    u32 *d = (u32 *)META, i;
    for (i = 0; i < sizeof(struct meta) / 4; i++) d[i] = src[i];
    if (META->magic != META_MAGIC) { for (i = 0; i < sizeof(struct meta) / 4; i++) d[i] = 0; META->magic = META_MAGIC; META->last_preset = 0xFFFFFFFFu; }
    {   /* mode footswitch : nouveau défaut = Preset ; l'ancien réglage Scene est migré une fois */
        u32 m = META->pad & 0xFFu;
        if (!(META->pad & META_FS_DEFAULT)) {
            if (m == 2) { m = 1; META->pad = (META->pad & ~0xFFu) | 1; }
            META->pad |= META_FS_DEFAULT;
            fs_mode_migrate = 1;
        }
        if (m >= 1 && m <= 3) fs_mode_boot = (int)m - 1;
    }
}
static int meta_save(void);
int bt_load(void) { return (int)((META->pad >> 8) & 3u); }          /* 0 = off, 1 = on, 2 = appairé */
/* gate d'entrée global : octet haut de META->pad = 0 (défaut : actif, -68 dB) ou bit 7 = coupé, bits 0..6 = -seuil en dB */
#define IG_DEF_DB (-68)
void main_set_in_gate(int on, int db);
static int in_gate_on(void) { return !((META->pad >> 24) & 0x80u); }
static int in_gate_db(void) { u32 v = (META->pad >> 24) & 0x7Fu; return v >= 40 && v <= 90 ? -(int)v : IG_DEF_DB; }
static void in_gate_apply(void) { main_set_in_gate(in_gate_on(), in_gate_db()); }
void proto_bt_store(int on, int paired)
{
    /* bits 8/9 seulement : le reste de pad (mode footswitch, banque d'usine, gate d'entrée) doit survivre */
    META->pad = (META->pad & ~0x300u) | (on ? 0x100u : 0u) | (paired ? 0x200u : 0u);
    meta_save();
}
static int meta_save(void)
{
    META->ver++;
    if (storage_erase(META_ADDR)) return -1;
    return storage_write(META_ADDR, (const u8 *)META, sizeof(struct meta));
}
static void copy_name(char *dst, const char *s, int n, int max) { int i; for (i = 0; i < n && i < max - 1; i++) dst[i] = s[i]; dst[i] = 0; }
/* anciens presets : noms de scènes français -> anglais, pour que la pédale reste 100 % anglaise */
static int txt_eq(const char *a, const char *b) { while (*a && *a == *b) { a++; b++; } return *a == *b; }
static void scene_name_fix(char *s)
{
    if (txt_eq(s, "Rythme")) copy_name(s, "Rhythm", 6, 17);
    else if (txt_eq(s, "Ambiance")) copy_name(s, "Ambience", 8, 17);
    else if (txt_eq(s, "Scène F")) copy_name(s, "Scene F", 7, 17);
    else if (txt_eq(s, "Scène G")) copy_name(s, "Scene G", 7, 17);
    else if (txt_eq(s, "Scène H")) copy_name(s, "Scene H", 7, 17);
}

/* ---------------- export de l'état RÉEL du preset en cours (la pédale est la référence) ----------------
 * Même format compact que l'app (compactPreset d'app.js), relu par apply_preset_json : tout réglage fait en direct
 * (app, encodeur, footswitchs, scènes) est donc sauvegardé et renvoyé à l'app tel que la pédale le joue. */
#define EXP_MAX (0x1000u - 16)
static u32 ex_n, ex_bad;
static void ex_c(char c) { if (ex_n < EXP_MAX) CUR_JSON[ex_n++] = c; else ex_bad = 1; }
static void ex_s(const char *s) { while (*s) ex_c(*s++); }
static void ex_q(const char *s) { ex_c('"'); for (; *s; s++) { if (*s == '"' || *s == '\\') ex_c('\\'); ex_c(*s); } ex_c('"'); }
static void ex_u(u32 u) { char t[12]; int i = 0; do { t[i++] = (char)('0' + u % 10); u /= 10; } while (u); while (i--) ex_c(t[i]); }
static void ex_i(s32 v) { char t[12]; int i = 0; u32 u = v < 0 ? (u32)-v : (u32)v; if (v < 0) ex_c('-'); do { t[i++] = (char)('0' + u % 10); u /= 10; } while (u); while (i--) ex_c(t[i]); }
static void ex_f(float v)                                            /* 3 décimales au plus, zéros inutiles retirés */
{
    s32 m;
    int d;
    if (v < 0) { ex_c('-'); v = -v; }
    m = (s32)(v * 1000.0f + 0.5f);
    ex_i(m / 1000);
    m %= 1000;
    if (!m) return;
    ex_c('.');
    for (d = 100; d && m; d /= 10) { ex_c((char)('0' + m / d)); m %= d; }
}
static void fs_export(void);
static u32 preset_export(void)
{
    static const char HEXD[] = "0123456789abcdef";
    u8 pf[CAT_COLS], pt[CAT_COLS], pm[CAT_COLS];
    float pv[MAX_PARAMS];
    int l, c, sc, k, ns, model, on, first;
    ex_n = 0; ex_bad = 0;
    ex_s("{\"i\":"); ex_i(preset_index);
    ex_s(",\"name\":"); ex_q(preset_name);
    ex_s(",\"color\":\"#"); for (k = 20; k >= 0; k -= 4) ex_c(HEXD[(preset_rgb >> k) & 15]); ex_c('"');
    ex_s(",\"tempo\":"); ex_i((s32)tempo_bpm);
    ex_s(",\"level\":"); ex_f(preset_level);
    ex_s(",\"scene\":"); ex_i(engine_scene());
    ex_s(",\"mod\":"); ex_i(engine_mods() != saved_mods);         /* modifié depuis le chargement / la sauvegarde */
    ex_s(",\"par\":["); ns = engine_sections(pf, pt, pm);
    for (k = 0; k < ns; k++) { if (k) ex_c(','); ex_s("{\"from\":"); ex_i(pf[k]); ex_s(",\"to\":"); ex_i(pt[k]); ex_s(",\"mix\":"); ex_i(pm[k]); ex_c('}'); }
    ex_s("],\"lanes\":[");
    for (l = 0; l < 2; l++) {
        ex_s(l ? ",[" : "[");
        for (c = 0; c < CAT_COLS; c++) { if (c) ex_c(','); if (engine_get(l, c, &model, &on)) ex_q(MODEL_DEFS[model].id); else ex_s("null"); }
        ex_c(']');
    }
    ex_s("],\"fs\":"); fs_export();
    ex_s(",\"scenes\":[");
    for (sc = 0; sc < CAT_SCENES; sc++) {
        if (sc) ex_c(',');
        ex_s("{\"n\":"); ex_q(scene_names[sc]); ex_s(",\"b\":[");
        first = 1;
        for (l = 0; l < 2; l++) for (c = 0; c < CAT_COLS; c++) {
            int np = engine_scene_get(sc, l, c, &on, pv);
            if (np < 0) continue;
            if (!first) ex_c(',');
            first = 0;
            ex_c('['); ex_i(l); ex_c(','); ex_i(c); ex_c(','); ex_i(on);
            for (k = 0; k < np; k++) { ex_c(','); ex_f(pv[k]); }
            ex_c(']');
        }
        ex_s("]}");
    }
    ex_s("]}");
    return ex_bad ? 0 : ex_n;
}
/* Banque d'usine : chaque preset d'usine écrit par le firmware porte une étiquette dans hdr[3]
   (« FB », version de la banque, numéro) ; une sauvegarde de l'utilisateur l'efface (hdr[3] = 0).
   Quand FACTORY_BANK augmente, les presets d'usine NON modifiés sont remplacés par leur nouvelle version au démarrage. */
#define FACTORY_BANK 3u                                                 /* 2 = cabs à IR (fw6 0.8) ; 3 = presets revus d'après les sons originaux (fw6 0.18) */
#define FB_TAG(k) (0x46420000u | (FACTORY_BANK << 8) | (u32)(k))
static u32 store_tag;                                                   /* étiquette du prochain preset_store */
/* écrit l'état réel dans l'emplacement i, sans toucher à la table meta (utilisé aussi au boot) */
static int preset_store(int i)
{
    u32 a, hdr[4], tag = store_tag;
    store_tag = 0;
    if (i < 0 || i >= CAT_PRESETS || big_p) return -1;              /* un envoi en cours lit CUR_JSON */
    preset_index = i;                                               /* le « i » exporté = l'emplacement */
    cur_json_len = preset_export();
    if (!cur_json_len) return -1;                                    /* trop long pour un secteur */
    a = preset_addr(i);
    hdr[0] = TBP_MAGIC; hdr[1] = cur_json_len; hdr[2] = crc16x((const u8 *)CUR_JSON, cur_json_len); hdr[3] = tag;
    if (storage_erase(a)) return -2;
    if (storage_write(a + 16, (const u8 *)CUR_JSON, cur_json_len)) return -3;
    if (storage_write(a, (const u8 *)hdr, 16)) return -4;              /* en-tête en dernier : un preset coupé reste invalide */
    saved_mods = engine_mods();
    return 0;
}
/* sauve l'état réel dans l'emplacement i (name : nouveau nom, ou 0) */
static int preset_save(int i)
{
    int r = preset_store(i);
    if (r) return r;
    META->last_preset = (u32)i;
    return meta_save();
}
static int apply_preset_json(const char *txt, u32 len);
/* charge le preset i depuis la flash ; 0 = OK */
static int preset_load(int i)
{
    const u32 *h;
    u32 k;
    if (i < 0 || i >= CAT_PRESETS) return -1;
    h = (const u32 *)storage_ptr(preset_addr(i));
    if (h[0] != TBP_MAGIC || h[1] == 0 || h[1] > 0x1000u - 16) return -2;
    if (crc16x((const u8 *)(h + 4), h[1]) != h[2]) return -3;
    if (preset_dsp((const char *)(h + 4), h[1]) > DSP_LOAD_MAX) return -4;   /* sauvé avec d'anciens coûts : ignoré au démarrage, sans message */
    (void)k;
    if (apply_preset_json((const char *)(h + 4), h[1]) != 0) return -5;   /* lu directement en flash (XIP) */
    saved_mods = engine_mods();                                      /* tel que sauvé : pas « modifié » */
    return 0;
}
/* emplacement vide : preset stock i s'il existe, sinon « Gate -> Brit Crunch 800 -> 4x12 », nommé d'après son numéro */
static int preset_init(int i)
{
    static char t[200];
    static const char A[] = "{\"name\":\"Preset ", B[] = "\",\"lanes\":[[\"gate\",\"brit\",\"cab412\",null,null,null,null,null],[null,null,null,null,null,null,null,null]]}";
    u32 n = 0, k;
    if (i >= 0 && i < FACTORY_PRESET_COUNT) {
        if (apply_preset_json(factory_preset_json[i], factory_preset_len[i]) == 0) {
            saved_mods = engine_mods();
            return 0;
        }
    }
    for (k = 0; A[k]; k++) t[n++] = A[k];
    t[n++] = (char)('0' + (i + 1) / 10); t[n++] = (char)('0' + (i + 1) % 10);
    for (k = 0; B[k]; k++) t[n++] = B[k];
    if (apply_preset_json(t, n) != 0) return -1;
    saved_mods = engine_mods();
    return 0;
}
/* ---- façade (ui.c) : preset modifié ?, sauvegarde dans un emplacement, nom d'un emplacement ---- */
int proto_dirty(void) { return engine_mods() != saved_mods; }
int proto_save_slot(int i)
{
    int r = preset_save(i);
    if (r == 0) notify_preset(i, 2);                                 /* l'app relit la liste et l'état */
    return r;
}
/* nom du preset sauvé dans l'emplacement i (copié dans o, 24 o) ; 0 si vide */
int proto_slot_name(int i, char *o)
{
    const char *s; int n;
    const u32 *h;
    o[0] = 0;
    if (i < 0 || i >= CAT_PRESETS || !preset_saved(i)) return 0;
    h = (const u32 *)storage_ptr(preset_addr(i));
    if (json_str((const char *)(h + 4), h[1], "name", &s, &n)) copy_name(o, s, n, 24); else copy_name(o, "Preset", 6, 24);
    return 1;
}
static u32 preset_tag(int i) { const u32 *h = (const u32 *)storage_ptr(preset_addr(i)); return h[0] == TBP_MAGIC ? h[3] : 0; }
static int factory_store(int k, int i) { if (preset_init(k) != 0) return -1; store_tag = FB_TAG(k); return preset_store(i); }
static int name_eq(const char *a, const char *b) { while (*a && *a == *b) { a++; b++; } return *a == *b; }
/* commande FACTORY_RESET [1] : recharge la banque d'usine ; remplace le preset qui porte le même nom, sinon 1er emplacement vide.
   Les autres presets ne sont jamais touchés. Renvoie le nombre de presets écrits. */
static int factory_reload(void)
{
    int k, i, n = 0;
    char nm[24], fn[24];
    for (k = 0; k < FACTORY_PRESET_COUNT; k++) {
        const char *s; int sn, slot = -1;
        if (!json_str(factory_preset_json[k], factory_preset_len[k], "name", &s, &sn)) continue;
        copy_name(fn, s, sn, 24);
        for (i = 0; i < CAT_PRESETS && slot < 0; i++) if (proto_slot_name(i, nm) && name_eq(nm, fn)) slot = i;
        for (i = 0; i < CAT_PRESETS && slot < 0; i++) if (!preset_saved(i)) slot = i;
        if (slot >= 0 && factory_store(k, slot) == 0) n++;
    }
    if (preset_load(preset_index) != 0) preset_init(0);
    return n;
}
/* commande FACTORY_RESET [0x5A] : remise à zéro complète des données TBBR.
   Efface les 80 presets, les IR utilisateur et les captures NAM, remet les réglages
   globaux par défaut et réinstalle la banque d'usine. Le firmware et les cabs
   d'usine (zone séparée) ne sont jamais touchés. */
static int factory_wipe(void)
{
    int i, k, err = 0;
    for (i = 0; i < CAT_PRESETS; i++) { if (storage_erase(preset_addr(i))) err = 1; wdt_clear(); }
    for (i = 0; i < CAT_IR_SLOTS; i++) {
        META->ir[i].valid = 0; META->ir[i].len = 0; META->ir[i].name[0] = 0;
    }
    for (i = 0; i < CAT_NAM_SLOTS; i++) {
        META->nam[i].valid = 0; META->nam[i].size = 0; META->nam[i].crc = 0; META->nam[i].name[0] = 0;
    }
    META->last_preset = 0;
    META->pad = META_FS_DEFAULT | 1u | 0x10000u | (FACTORY_BANK << 18);
    proto_set_fs_mode_raw(0);
    fs_cfg_clear();
    tempo_bpm = 120;
    engine_clear();
    for (k = 0; k < FACTORY_PRESET_COUNT; k++) { if (factory_store(k, k) != 0) err = 1; wdt_clear(); }
    if (preset_load(0) != 0) { preset_init(0); err = 1; }
    preset_index = 0;
    saved_mods = engine_mods();
    in_gate_apply();
    if (meta_save()) err = 1;
    return err ? -1 : 0;
}
static void ir_crc_update(int s);
void proto_boot(void)
{
    meta_load();
    in_gate_apply();
    if (fs_mode_boot >= 0) proto_set_fs_mode_raw(fs_mode_boot);
    if (fs_mode_migrate) { meta_save(); fs_mode_migrate = 0; }
    /* première mise à jour vers ce firmware : remplit les emplacements VIDES avec la banque stock,
       sans jamais écraser un preset déjà sauvé par l'utilisateur (une seule fois, bit 16 de pad). */
    if (!(META->pad & 0x10000u)) {
        int n = 0, i, ok = 1;
        for (i = 0; i < CAT_PRESETS && n < FACTORY_PRESET_COUNT; i++) {
            if (preset_saved(i)) continue;
            if (factory_store(n, i) != 0) { ok = 0; break; }
            n++;
        }
        if (ok) META->pad |= 0x10000u | (FACTORY_BANK << 18);
        meta_save();
    }
    /* banque d'usine plus récente : met à jour les presets d'usine que l'utilisateur n'a pas modifiés (bits 18..21 de pad) */
    if (((META->pad >> 18) & 15u) < FACTORY_BANK) {
        int i;
        for (i = 0; i < CAT_PRESETS; i++) {
            u32 t = preset_tag(i), k = t & 0xFFu;
            if ((t & 0xFFFF0000u) == 0x46420000u && ((t >> 8) & 0xFFu) < FACTORY_BANK && k < FACTORY_PRESET_COUNT) factory_store((int)k, i);
        }
        META->pad = (META->pad & ~(15u << 18)) | (FACTORY_BANK << 18);
        meta_save();
    }
    { int s; for (s = 0; s < CAT_IR_SLOTS; s++) { ir_crc_update(s); wdt_clear(); } }
    if (META->last_preset < CAT_PRESETS && preset_load((int)META->last_preset) == 0) preset_index = (int)META->last_preset;   /* numéro = emplacement, pas le « i » du JSON */
    else { preset_index = 0; if (preset_load(0) != 0) preset_init(0); }
}
/* transferts IR / NAM : écriture au fil des morceaux, validation à la fin */
static int ir_slot = -1, nam_slot = -1;
/* CRC32 du contenu de chaque emplacement IR (secteur entier) : calculé au démarrage et à la fin d'un envoi, jamais pendant le jeu */
static u32 ir_crc[CAT_IR_SLOTS] __attribute__((section(".gfxbss")));
static void ir_crc_update(int s) { ir_crc[s] = META->ir[s].valid ? crc32b(storage_ptr(IR_BASE + (u32)s * IR_SZ), IR_SZ) : 0; }
static u32 nam_size, nam_crc;
static char xfer_name[20];
static int ir_begin(const char *js, u32 n);
static int nam_begin(const char *js, u32 n);

/* ---------------- grosses réponses : PRESET_GET, PRESET_LIST ----------------
 * Découpées en trames DATA [type, index, morceau, nombre de morceaux, données <= 960 o] et envoyées au rythme de la
 * file USB (proto_poll, boucle principale) : une trame qui ne tient pas dans la file n'est jamais jetée. */
#define C_DATA 0x14
#define C_PRESET_LIST 0x16
#define BIG_CHUNK 960
u32 usb_midi_tx_free(void);
const char *proto_ir_name(int s);
const char *proto_nam_name(int s);
static u32 big_n, big_part, big_parts;
static u8 big_type, big_idx;
static u8 big_t[BIG_CHUNK + 4] __attribute__((section(".gfxbss")));
static int preset_goto_t(int i, int tell);
void proto_poll(void)
{
    while (big_p && big_part < big_parts) {
        u32 off = big_part * BIG_CHUNK, len = big_n - off, k;
        if (len > BIG_CHUNK) len = BIG_CHUNK;
        if (usb_midi_tx_free() < 1600) return;                       /* ~1 500 o de file pour un morceau : on attend */
        big_t[0] = big_type; big_t[1] = big_idx; big_t[2] = (u8)big_part; big_t[3] = (u8)big_parts;
        for (k = 0; k < len; k++) big_t[4 + k] = big_p[off + k];
        if (!send_frame(C_DATA, big_t, len + 4)) return;
        big_part++;
    }
    big_p = 0;
}
static int big_start(u8 type, u8 idx, const u8 *p, u32 n)
{
    static const u8 none = 0;
    if (big_p) return -1;                                            /* un envoi est déjà en cours : l'app redemande */
    big_p = p ? p : &none; big_n = n; big_type = type; big_idx = idx; big_part = 0;
    big_parts = n ? (n + BIG_CHUNK - 1) / BIG_CHUNK : 1;
    proto_poll();
    return 0;
}
/* liste : {"cur":i,"presets":[80 noms, "" = vide],"ir":[32],"nam":[16]} (dans CUR_JSON) */
static u32 list_export(void)
{
    int i;
    ex_n = 0; ex_bad = 0;
    ex_s("{\"cur\":"); ex_i(preset_index); ex_s(",\"presets\":[");
    for (i = 0; i < CAT_PRESETS; i++) {
        const char *s; int n;
        if (i) ex_c(',');
        ex_c('"');
        if (preset_saved(i)) {
            const u32 *h = (const u32 *)storage_ptr(preset_addr(i));
            if (json_str((const char *)(h + 4), h[1], "name", &s, &n)) { int k; for (k = 0; k < n && k < 40; k++) ex_c(s[k]); }   /* déjà échappé */
            else ex_s("Preset");
        }
        ex_c('"');
    }
    ex_s("],\"ir\":[");
    for (i = 0; i < CAT_IR_SLOTS; i++) { if (i) ex_c(','); ex_q(proto_ir_name(i) ? proto_ir_name(i) : ""); }
    ex_s("],\"nam\":[");
    for (i = 0; i < CAT_NAM_SLOTS; i++) { if (i) ex_c(','); ex_q(proto_nam_name(i) ? proto_nam_name(i) : ""); }
    /* empreintes (CRC32) : l'app reconnaît une capture / IR déjà présente et ne la renvoie pas (import de preset) */
    ex_s("],\"namCrc\":[");
    for (i = 0; i < CAT_NAM_SLOTS; i++) { if (i) ex_c(','); ex_u(META->nam[i].valid ? META->nam[i].crc : 0); }
    ex_s("],\"irCrc\":[");
    for (i = 0; i < CAT_IR_SLOTS; i++) { if (i) ex_c(','); ex_u(META->ir[i].valid ? ir_crc[i] : 0); }
    ex_s("]}");
    return ex_bad ? 0 : ex_n;
}

/* ---------------- réception ---------------- */
static float f32le(const u8 *b) { union { u32 u; float f; } v; v.u = b[0] | (u32)b[1] << 8 | (u32)b[2] << 16 | (u32)b[3] << 24; return v.f; }
static void dispatch(u32 cmd, const u8 *pl, u32 n)
{
    switch (cmd) {
    case C_HELLO: host_ok = 1; send_info(); break;
    case C_PRESET_SET:
        if (n >= 0x1000u - 16) { nak(cmd); break; }                    /* trop long pour un secteur de preset */
        if (preset_dsp((const char *)pl, n) > DSP_LOAD_MAX) { nak(cmd); ui_msg_dsp(); break; }   /* DSP insuffisant : l'ancien preset reste */
        if (apply_preset_json((const char *)pl, n) == 0) ack(cmd); else nak(cmd);   /* lu sur place (rbuf) */
        break;
    case C_PRESET_SELECT:                                             /* la pédale charge le preset ; l'app relit l'état (PRESET_GET 0x7F) */
        if (n >= 1 && preset_goto_t(pl[0], 0) == 0) ack(cmd); else nak(cmd);
        break;
    case C_PRESET_SAVE:                                               /* [emplacement, nom UTF-8 facultatif] : sauve l'état réel */
        if (n > 1) copy_name(preset_name, (const char *)pl + 1, (int)n - 1, 24);
        if (n >= 1 && preset_save(pl[0]) == 0) ack(cmd); else nak(cmd);
        break;
    case C_PRESET_GET: {                                              /* [emplacement | 0x7F = état réel en cours] -> trames DATA */
        u32 len;
        if (n < 1 || big_p) { nak(cmd); break; }                     /* (un envoi en cours utilise CUR_JSON) */
        if (pl[0] == 0x7F) { len = preset_export(); if (!len || big_start(C_PRESET_GET, 0x7F, (const u8 *)CUR_JSON, len)) nak(cmd); }
        else if (pl[0] < CAT_PRESETS) {
            const u32 *h = (const u32 *)storage_ptr(preset_addr(pl[0]));
            if (big_start(C_PRESET_GET, pl[0], preset_saved(pl[0]) ? (const u8 *)(h + 4) : 0, preset_saved(pl[0]) ? h[1] : 0)) nak(cmd);
        } else nak(cmd);
        break; }
    case C_PRESET_LIST: {
        u32 len;
        if (big_p) { nak(cmd); break; }
        len = list_export();
        if (!len || big_start(C_PRESET_LIST, 0, (const u8 *)CUR_JSON, len)) nak(cmd);
        break; }
    case C_SCENE_SELECT: if (n >= 1 && engine_scene_select(pl[0]) == 0) ack(cmd); else nak(cmd); break;
    case C_TEMPO: if (n >= 2) tempo_bpm = pl[0] | (u32)pl[1] << 8; ack(cmd); break;
    case C_LEVEL:                                                     /* [float32 LE] : niveau du preset en direct */
        if (n >= 4) { preset_level = f32le(pl); engine_level(preset_level); ack(cmd); } else nak(cmd);
        break;
    case C_BLOCK_SET: {
        const char *s; int sn, m = -1, lane = json_int((const char *)pl, n, "lane", -1), col = json_int((const char *)pl, n, "col", -1);
        if (json_str((const char *)pl, n, "model", &s, &sn)) m = engine_model_by_name(s, sn);
        { int r = m >= 0 ? engine_block_set(lane, col, m) : -1;
          if (r == 0) ack(cmd); else { nak(cmd); if (r == -2) ui_msg_dsp(); } }      /* -3 : B sans bloc en face */
        break; }
    case C_BLOCK_CLEAR: if (n >= 2) { engine_block_clear(pl[0], pl[1]); ack(cmd); } else nak(cmd); break;
    case C_BLOCK_MOVE: ack(cmd); break;                               /* l'app renvoie le preset complet ensuite (PRESET_SET) */
    case C_BYPASS: if (n >= 3 && engine_bypass(pl[0], pl[1], pl[2]) == 0) ack(cmd); else nak(cmd); break;
    case C_PARAM: if (n >= 7 && engine_param(pl[0], pl[1], pl[2], f32le(pl + 3)) == 0) ack(cmd); else nak(cmd); break;
    case C_SPLIT: if (n >= 3) { engine_split(pl[0], pl[1], pl[2]); ack(cmd); } else nak(cmd); break;
    case C_GLOBAL: {                                                  /* {"fsMode": "preset" | "scene" | "stomp"} ; {"bt":"off|on|paired"} */
        const char *s; int sn, m;
        void proto_bt_set(int on, int paired);
        if (json_str((const char *)pl, n, "fsMode", &s, &sn)) for (m = 0; m < 3; m++) if (key_is(s, sn, fs_mode_name(m))) proto_set_fs_mode(m, 0);
        if (json_str((const char *)pl, n, "bt", &s, &sn)) {
            if (key_is(s, sn, "off")) proto_bt_set(0, 0);
            else if (key_is(s, sn, "on")) proto_bt_set(1, 0);
            else if (key_is(s, sn, "paired")) proto_bt_set(1, 1);
        }
        {   /* {"inGateOn": 0|1} / {"inGate": -90..-40} : gate d'entrée global, mémorisé si changé */
            int on = json_int((const char *)pl, n, "inGateOn", -1), db = json_int((const char *)pl, n, "inGate", 1);
            u32 v = (META->pad >> 24) & 0xFFu, nv = v;
            if (!(v & 0x7Fu)) nv = (u32)(-IG_DEF_DB);
            if (on == 0) nv |= 0x80u; else if (on > 0) nv &= 0x7Fu;
            if (db <= 0) { if (db > -40) db = -40; if (db < -90) db = -90; nv = (nv & 0x80u) | (u32)(-db); }
            if (on >= 0 || db <= 0) {
                if (nv != v) { META->pad = (META->pad & 0x00FFFFFFu) | (nv << 24); meta_save(); }
                in_gate_apply();
            }
        }
        ack(cmd); break; }
    case C_FS_CONFIG: ack(cmd); break;                                /* les actions stomp arrivent avec le preset (« fs ») */
    case C_TUNER: { void ui_tuner(int on); if (n >= 1) { ui_tuner(pl[0] != 0); ack(cmd); } else nak(cmd); break; }   /* [on] : notes -> TUNER_DATA */
    case C_IR_BEGIN: if (ir_begin((const char *)pl, n) == 0) ack(cmd); else nak(cmd); break;
    case C_IR_CHUNK:                                                  /* [slot, idx lo, idx hi, int16 x 240] */
        if (n > 3 && pl[0] == ir_slot) { u32 off = (pl[1] | (u32)pl[2] << 8) * 480u; if (off + n - 3 <= IR_SZ) storage_write(IR_BASE + (u32)ir_slot * IR_SZ + off, pl + 3, n - 3); }
        break;
    case C_IR_END:
        if (n >= 1 && pl[0] == ir_slot) {
            int slot = ir_slot;
            struct meta_ir *m = &META->ir[slot];
            m->valid = 1; m->len = 2048; copy_name(m->name, xfer_name, 20, 20); ir_crc_update(slot);
            ir_slot = -1;
            if (meta_save() == 0) { engine_ir_changed(slot); ack(cmd); } else nak(cmd);
        } else nak(cmd);
        break;
    case C_NAM_BEGIN: if (nam_begin((const char *)pl, n) == 0) ack(cmd); else nak(cmd); break;
    case C_NAM_CHUNK:                                                 /* [slot, idx lo, idx hi, données x 480] */
        if (n > 3 && pl[0] == nam_slot) { u32 off = (pl[1] | (u32)pl[2] << 8) * 480u; if (off + n - 3 <= NAM_SZ) storage_write(NAM_BASE + (u32)nam_slot * NAM_SZ + off, pl + 3, n - 3); }
        break;
    case C_NAM_END:                                                   /* [slot, CRC32 LE] : vérifié sur la flash relue */
        if (n >= 5 && pl[0] == nam_slot) {
            int slot = nam_slot;
            u32 crc = pl[1] | (u32)pl[2] << 8 | (u32)pl[3] << 16 | (u32)pl[4] << 24;
            struct meta_nam *m = &META->nam[slot];
            int ok = crc == nam_crc && crc32b(storage_ptr(NAM_BASE + (u32)slot * NAM_SZ), nam_size) == crc;
            if (ok) { m->valid = 1; m->size = nam_size; m->crc = crc; copy_name(m->name, xfer_name, 20, 20); ok = meta_save() == 0; }
            nam_slot = -1;
            if (ok) { engine_nam_changed(slot); ack(cmd); } else nak(cmd);
        } else nak(cmd);
        break;
    case C_NAM_DELETE:
        if (n >= 1 && pl[0] < CAT_NAM_SLOTS) {
            int slot = pl[0];
            META->nam[slot].valid = 0;
            if (meta_save() == 0) { engine_nam_changed(slot); ack(cmd); } else nak(cmd);
        } else nak(cmd);
        break;
    case C_FACTORY_RESET:                                             /* [1] : recharger la banque d'usine ; [0x5A] : tout réinitialiser */
        if (n >= 1 && !big_p && pl[0] == 1) {
            int w = factory_reload(); ack(cmd); notify_preset(preset_index, 2); (void)w;
        } else if (n >= 1 && !big_p && pl[0] == 0x5A) {
            if (factory_wipe() == 0) { ack(cmd); notify_preset(preset_index, 2); } else nak(cmd);
        } else nak(cmd);
        break;
    case C_FW_BEGIN: nak(cmd); break;                                 /* mise à jour par l'app : l'installateur passe par UBOOT */
    case C_FW_CHUNK: case C_FW_END: break;
    default: nak(cmd);
    }
}
/* IR_BEGIN {"slot":n,"name":"…","len":2048,"rate":48000,"fmt":"s16le"} : efface l'emplacement */
static int ir_begin(const char *js, u32 n)
{
    const char *s; int sn, slot = json_int(js, n, "slot", -1), len = json_int(js, n, "len", 0);
    if (slot < 0 || slot >= CAT_IR_SLOTS || len <= 0 || len > 2048 || json_int(js, n, "rate", 48000) != 48000) return -1;
    xfer_name[0] = 0;
    if (json_str(js, n, "name", &s, &sn)) copy_name(xfer_name, s, sn, 20);
    META->ir[slot].valid = 0;
    if (storage_erase(IR_BASE + (u32)slot * IR_SZ)) return -2;
    ir_slot = slot;
    return 0;
}
/* NAM_BEGIN {"slot":n,"name":"…","a2":true,"sr":48000,"nWeights":1871,"size":7484,"crc":…} : efface les 2 secteurs */
static int nam_begin(const char *js, u32 n)
{
    const char *s; int sn, slot = json_int(js, n, "slot", -1), size = json_int(js, n, "size", 0), nw = json_int(js, n, "nWeights", 0);
    if (slot < 0 || slot >= CAT_NAM_SLOTS || size <= 0 || (u32)size > NAM_SZ || (nw != 0 && nw * 4 != size) || json_int(js, n, "sr", 48000) != 48000) return -1;
    { /* crc sur 32 bits : json_int lit un nombre flottant -> on relit les chiffres à la main */
        const char *p; u32 v = 0;
        jp = js; je = js + n;
        nam_crc = 0;
        for (p = js; p + 6 < js + n; p++) if (p[0] == '"' && p[1] == 'c' && p[2] == 'r' && p[3] == 'c' && p[4] == '"') {
            for (p += 5; p < js + n && (*p == ' ' || *p == ':'); p++) { }
            for (; p < js + n && *p >= '0' && *p <= '9'; p++) v = v * 10 + (u32)(*p - '0');
            nam_crc = v; break;
        }
    }
    xfer_name[0] = 0;
    if (json_str(js, n, "name", &s, &sn)) copy_name(xfer_name, s, sn, 20);
    META->nam[slot].valid = 0;
    if (storage_erase(NAM_BASE + (u32)slot * NAM_SZ) || storage_erase(NAM_BASE + (u32)slot * NAM_SZ + 0x1000u)) return -2;
    nam_slot = slot; nam_size = (u32)size;
    return 0;
}
static u8 rbuf[4096] __attribute__((section(".gfxbss")));
/* SysEx F0 7D 42 58 70 ... F7 (m pointe sur F0, n octets) */
void proto_frames_sysex(const u8 *m, u32 n)
{
    u32 i = 5, o = 0, len, x = 0, k;
    while (i < n - 1 && o < sizeof(rbuf)) {
        u32 hi = m[i++], j;
        for (j = 0; j < 7 && i < n - 1 && o < sizeof(rbuf); j++, i++) rbuf[o++] = (u8)((m[i] & 0x7F) | (((hi >> j) & 1) << 7));
    }
    if (o < 5 || rbuf[0] != 0xA5) return;
    len = rbuf[2] | (u32)rbuf[3] << 8;
    if (len + 5 > o) return;
    for (k = 1; k < len + 4; k++) x ^= rbuf[k];
    if ((x & 0xFF) != rbuf[len + 4]) return;
    host_ok = 1; host_seen = jiffies;
    dispatch(rbuf[1], rbuf + 4, len);
}
/* vu-mètres (~11 fois / s, si l'app est connectée) : niveau 0..255 sur une échelle de -60 à 0 dBFS */
static u8 lvl255(u32 pk16)
{
    u32 v = 0, t = 32768;
    int db = 0;
    if (!pk16) return 0;
    while (t > pk16 && db > -60) { t = (t * 29205) >> 15; db--; }   /* -1 dB par pas */
    v = (u32)((db + 60) * 255 / 60);
    return (u8)(v > 255 ? 255 : v);
}
void proto_meter(u32 in16, u32 out16)
{
    u8 b[3];
    int bat;
    if (!host_ok) return;
    if (jiffies - host_seen > 1125u) { host_ok = 0; return; }      /* app disparue : ~3 s sans message */
    if (big_p || usb_midi_tx_free() < 2048) return;                /* file chargée : les réponses passent avant les vu-mètres */
    b[0] = lvl255(in16); b[1] = lvl255(out16);
    bat = proto_battery_pct();
    b[2] = (u8)(bat < 0 ? 127 : bat);                              /* % batterie, 127 = pas encore lu */
    send_frame(C_METER, b, 3);
}
/* accordeur (tuner.c) -> app : [note 0..11, octave, centièmes x10 (int16 LE), niveau 0..255 (0 = pas de note)] */
void proto_tuner_data(int note, int oct, float cents, int level)
{
    u8 b[5];
    s32 c = (s32)(cents * 10.0f + (cents >= 0 ? 0.5f : -0.5f));
    if (!host_ok || usb_midi_tx_free() < 1024) return;
    b[0] = (u8)note; b[1] = (u8)oct; b[2] = (u8)c; b[3] = (u8)((u32)c >> 8); b[4] = (u8)level;
    send_frame(C_TUNER_DATA, b, 5);
}
const char *proto_preset_name(void) { return preset_name; }
u32 proto_host(void) { return host_ok; }
u32 proto_preset_rgb(void) { return preset_rgb; }
int proto_preset_index(void) { return preset_index; }
u32 proto_tempo(void) { return tempo_bpm; }
/* échantillons int16 d'une IR enregistrée (2048 points, lecture directe en flash) ; 0 si l'emplacement est vide */
/* cabs d'usine : zone [0xF3000, 0xFF000) écrite par l'installateur (gen_cabs.py) ; répertoire « TBC1 » au secteur 0xFE000 */
#define CAB_BASE 0xF3000u
#define CAB_DIR  0xFE000u
struct cab_dir { u32 magic, count; struct { char name[24]; u16 len, r0; u32 r1; } e[11]; };
static const struct cab_dir *cab_dir(void) { const struct cab_dir *d = (const struct cab_dir *)storage_ptr(CAB_DIR); return d->magic == 0x31434254u && d->count <= 11 ? d : 0; }
const short *proto_cab_data(int k) { const struct cab_dir *d = cab_dir(); return d && k >= 0 && k < (int)d->count && d->e[k].len ? (const short *)storage_ptr(CAB_BASE + (u32)k * 0x1000u) : 0; }
int proto_cab_count(void) { const struct cab_dir *d = cab_dir(); return d ? (int)d->count : 0; }
const short *proto_ir_data(int s) { return (s >= 0 && s < CAT_IR_SLOTS && META->ir[s].valid) ? (const short *)storage_ptr(IR_BASE + (u32)s * IR_SZ) : 0; }
const float *proto_nam_weights(int s, int *n) { if (s < 0 || s >= CAT_NAM_SLOTS || !META->nam[s].valid) return 0; *n = (int)(META->nam[s].size / 4); return (const float *)storage_ptr(NAM_BASE + (u32)s * NAM_SZ); }
const u8 *proto_nam_blob(int s, int *n) { if (s < 0 || s >= CAT_NAM_SLOTS || !META->nam[s].valid) return 0; *n = (int)META->nam[s].size; return (const u8 *)storage_ptr(NAM_BASE + (u32)s * NAM_SZ); }
const char *proto_ir_name(int s) { return (s >= 0 && s < CAT_IR_SLOTS && META->ir[s].valid) ? META->ir[s].name : 0; }
const char *proto_nam_name(int s) { return (s >= 0 && s < CAT_NAM_SLOTS && META->nam[s].valid) ? META->nam[s].name : 0; }
/* ---------------- notifications vers l'app (changements faits sur la pédale) ----------------
 * mêmes codes que les commandes de l'app : PRESET_SELECT [index, besoin] (besoin = 1 : preset absent de la flash, l'app
 * doit l'envoyer), SCENE_SELECT [scène], BYPASS [lane, col, on], TEMPO [lo, hi], GLOBAL {"fsMode": ...} */
static void notify(u32 cmd, const u8 *b, u32 n) { if (host_ok) send_frame(cmd, b, n); }
void proto_notify_bypass(int lane, int col, int on) { u8 b[3]; b[0] = (u8)lane; b[1] = (u8)col; b[2] = (u8)(on != 0); notify(C_BYPASS, b, 3); }
static void notify_scene(void) { u8 b = (u8)engine_scene(); notify(C_SCENE_SELECT, &b, 1); }
static void notify_preset(int i, int need) { u8 b[2]; b[0] = (u8)i; b[1] = (u8)need; notify(C_PRESET_SELECT, b, 2); }
/* structure du preset changée depuis la façade (ajout / suppression / déplacement de bloc) :
   l'app relit le preset courant, sans le renvoyer. */
void proto_notify_structure(void) { notify_preset(preset_index, 1); }
void proto_notify_bt(int state)                                      /* prévient l'app d'un changement fait sur la pédale */
{
    if (!host_ok) return;
    jn = 0; js("{\"bt\":\""); js(state == 2 ? "paired" : (state ? "on" : "off")); js("\"}");
    notify(C_GLOBAL, (const u8 *)jb, jn);
}

/* va au preset i (la pédale est la référence) : depuis la flash, ou preset de départ si l'emplacement est vide (ou
   trop lourd) ; l'app est prévenue et relit l'état (PRESET_GET). tell = prévenir l'app. 0 = OK */
static int preset_goto_t(int i, int tell)
{
    if (i < 0 || i >= CAT_PRESETS) return -1;
    if (preset_load(i) != 0 && preset_init(i) != 0) return -1;
    preset_index = i;
    META->last_preset = (u32)i;                                     /* mémorisé (RAM) ; écrit en flash au prochain meta_save */
    if (tell) notify_preset(i, 0);
    return 0;
}
static int preset_goto(int i) { return preset_goto_t(i, 1); }
/* preset suivant / précédent (footswitchs) : les 80 presets se suivent, comme le firmware d'origine */
int proto_preset_step(int d) { return preset_goto((preset_index + d + CAT_PRESETS) % CAT_PRESETS); }
/* Program Change reçu en USB MIDI (pédalier externe, ex. M-VAVE Chocolate : banques de 4, programme = banque x 4 + bouton) :
   programme p -> preset p + 1 (emplacement p), tous canaux. Le preset déjà actif n'est pas rechargé (réglages en cours gardés). */
void proto_midi_program(int ch, int prog)
{
    (void)ch;
    if (prog < 0 || prog >= CAT_PRESETS || prog == preset_index) return;
    preset_goto(prog);
}

/* ---------------- footswitchs : les 3 modes de la maquette (ecran.js resolve / act) ----------------
 * Preset : G = preset -, maintien accordeur ; D = preset +, maintien tap.
 * Scène  : G = scène précédente, maintien preset - ; D = scène suivante, maintien preset +.
 * Stomp  : actions du preset (« fs » du JSON : [[appui, maintien], [appui, maintien]]). */
enum { FA_NONE, FA_PUP, FA_PDOWN, FA_BUP, FA_BDOWN, FA_PRESET, FA_SCENE, FA_SUP, FA_SDOWN, FA_BLOCK, FA_TAP, FA_TUNER, FA_MODE };
struct fsact { u8 t, a, b; };
static struct fsact fs_cfg[2][2];
static u8 fs_mode = 0;                                               /* 0 preset (défaut), 1 scène, 2 stomp */
static const char *const FS_MODE_NAME[3] = { "preset", "scene", "stomp" };
static int num_after(const char *s, int n, int k, int *v) { int r = 0, any = 0; while (k < n && s[k] >= '0' && s[k] <= '9') { r = r * 10 + s[k] - '0'; k++; any = 1; } *v = r; return any ? k : -1; }
static int starts(const char *s, int n, const char *p) { int i; for (i = 0; p[i]; i++) if (i >= n || s[i] != p[i]) return 0; return i; }
static struct fsact parse_action(const char *s, int n)
{
    struct fsact f = { FA_NONE, 0, 0 };
    int k, v, w;
    if (key_is(s, n, "presetUp")) f.t = FA_PUP; else if (key_is(s, n, "presetDown")) f.t = FA_PDOWN;
    else if (key_is(s, n, "bankUp")) f.t = FA_BUP; else if (key_is(s, n, "bankDown")) f.t = FA_BDOWN;
    else if (key_is(s, n, "sceneUp")) f.t = FA_SUP; else if (key_is(s, n, "sceneDown")) f.t = FA_SDOWN;
    else if (key_is(s, n, "tap")) f.t = FA_TAP; else if (key_is(s, n, "tuner")) f.t = FA_TUNER; else if (key_is(s, n, "modeNext")) f.t = FA_MODE;
    else if ((k = starts(s, n, "preset:")) && num_after(s, n, k, &v) > 0) { f.t = FA_PRESET; f.a = (u8)v; }
    else if ((k = starts(s, n, "scene:")) && num_after(s, n, k, &v) > 0) { f.t = FA_SCENE; f.a = (u8)v; }
    else if ((k = starts(s, n, "block:")) && (k = num_after(s, n, k, &v)) > 0 && k < n && s[k] == ',' && num_after(s, n, k + 1, &w) > 0) { f.t = FA_BLOCK; f.a = (u8)v; f.b = (u8)w; }
    return f;
}
static void parse_fs(void)                                           /* « fs » : [[appui, maintien], [appui, maintien]] */
{
    const char *s; int n, i, j;
    eat('[');
    for (i = 0; peek() == '['; i++) {
        eat('[');
        for (j = 0; peek() != ']' && peek(); j++) {
            if (peek() == '"' && str(&s, &n)) { if (i < 2 && j < 2) fs_cfg[i][j] = parse_action(s, n); } else skip();
            eat(',');
        }
        eat(']'); eat(',');
    }
    eat(']');
}
static u32 tap_last, tap_n, tap_sum;
/* footswitch i (0 = gauche, 1 = droite), appui ou maintien ; ms = horloge. Renvoie 1 si l'accordeur doit s'ouvrir. */
int proto_fs(int i, int hold, u32 ms)
{
    static const struct fsact PRESET_M[2][2] = { { { FA_PDOWN, 0, 0 }, { FA_TUNER, 0, 0 } }, { { FA_PUP, 0, 0 }, { FA_TAP, 0, 0 } } };
    static const struct fsact SCENE_M[2][2] = { { { FA_SDOWN, 0, 0 }, { FA_PDOWN, 0, 0 } }, { { FA_SUP, 0, 0 }, { FA_PUP, 0, 0 } } };
    struct fsact f = fs_mode == 0 ? PRESET_M[i][hold] : fs_mode == 1 ? SCENE_M[i][hold] : fs_cfg[i][hold];
    int m, on;
    switch (f.t) {                                                   /* pas de banques : les 80 presets se suivent */
    case FA_PUP: proto_preset_step(1); break;
    case FA_PDOWN: proto_preset_step(-1); break;
    case FA_BUP: proto_preset_step(10); break;                       /* anciennes actions « banque » : par 10 */
    case FA_BDOWN: proto_preset_step(-10); break;
    case FA_PRESET: preset_goto(f.a % CAT_PRESETS); break;           /* « preset:n » = numéro absolu (0 = preset 1) */
    case FA_SCENE: engine_scene_select(f.a % CAT_SCENES); notify_scene(); break;
    case FA_SUP: engine_scene_select((engine_scene() + 1) % CAT_SCENES); notify_scene(); break;
    case FA_SDOWN: engine_scene_select((engine_scene() + CAT_SCENES - 1) % CAT_SCENES); notify_scene(); break;
    case FA_BLOCK: if (engine_get(f.a, f.b, &m, &on)) { engine_bypass(f.a, f.b, !on); proto_notify_bypass(f.a, f.b, !on); } break;
    case FA_TAP: {                                                    /* moyenne des intervalles, remise à zéro après 2,2 s */
        u32 dt = ms - tap_last;
        if (tap_n && dt < 2200) { tap_sum += dt; tap_n++; if (tap_sum / (tap_n - 1)) { u32 b = 60000u / (tap_sum / (tap_n - 1)); u8 t[2]; if (b < 40) b = 40; if (b > 250) b = 250; tempo_bpm = b; t[0] = (u8)b; t[1] = (u8)(b >> 8); notify(C_TEMPO, t, 2); } }
        else { tap_n = 1; tap_sum = 0; }
        tap_last = ms;
        break; }
    case FA_TUNER: return 1;
    case FA_MODE: proto_set_fs_mode((fs_mode + 1) % 3, 1); break;
    default: break;
    }
    return 0;
}
/* change le mode (mémorisé dans la table en flash) ; tell = prévenir l'app */
void proto_set_fs_mode(int m, int tell)
{
    if (m < 0 || m > 2 || m == fs_mode) return;
    fs_mode = (u8)m;
    META->pad = (META->pad & ~0xFFu) | ((u32)m + 1);                 /* octet bas = mode ; bits 8/9 = Bluetooth */
    meta_save();
    if (tell) { jn = 0; js("{\"fsMode\":\""); js(FS_MODE_NAME[m]); js("\"}"); notify(C_GLOBAL, (const u8 *)jb, jn); }
}
int proto_fs_mode(void) { return fs_mode; }
static void parse_fs_hook(void) { parse_fs(); }
/* « fs » du preset en cours, pour l'export : [[appui, maintien], [appui, maintien]] */
static void fs_act_export(struct fsact f)
{
    static const char *const N[] = { "none", "presetUp", "presetDown", "bankUp", "bankDown", "", "", "sceneUp", "sceneDown", "", "tap", "tuner", "modeNext" };
    ex_c('"');
    if (f.t == FA_PRESET) { ex_s("preset:"); ex_i(f.a); }
    else if (f.t == FA_SCENE) { ex_s("scene:"); ex_i(f.a); }
    else if (f.t == FA_BLOCK) { ex_s("block:"); ex_i(f.a); ex_c(','); ex_i(f.b); }
    else ex_s(f.t < sizeof(N) / sizeof(N[0]) && N[f.t][0] ? N[f.t] : "none");
    ex_c('"');
}
static void fs_export(void)
{
    int i;
    ex_c('[');
    for (i = 0; i < 2; i++) { if (i) ex_c(','); ex_c('['); fs_act_export(fs_cfg[i][0]); ex_c(','); fs_act_export(fs_cfg[i][1]); ex_c(']'); }
    ex_c(']');
}
static void fs_cfg_clear(void) { u8 *z = (u8 *)fs_cfg; u32 q; for (q = 0; q < sizeof(fs_cfg); q++) z[q] = 0; }
static const char *fs_mode_name(int m) { return FS_MODE_NAME[m < 0 || m > 2 ? 0 : m]; }
void proto_set_fs_mode_raw(int m) { if (m >= 0 && m <= 2) fs_mode = (u8)m; }
static int preset_saved(int i) { const u32 *h = (const u32 *)storage_ptr(preset_addr(i)); return h[0] == TBP_MAGIC && h[1] && h[1] <= 0x1000u - 16; }
