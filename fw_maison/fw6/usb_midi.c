/* usb_midi.c : périphérique USB MIDI 1.0 « compatible classe » (aucun pilote nécessaire) sur USB0 (full speed),
 * au-dessus du pilote bas niveau du SDK JieLi AC79 (usb.c / usb_setup.c / usb_phy.c, Apache-2.0).
 * Tout est scruté depuis la boucle principale (usb_midi_poll), sans interruption.
 *
 * Messages : SysEx uniquement, reçus dans un tampon, remis à proto_sysex() quand F7 arrive ; envoi par une file de paquets USB-MIDI.
 * Identifiants USB : 0x1209 / 0x0001 = « pid.codes test PID » (à remplacer par un PID attribué avant toute diffusion). */
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;
typedef u8 usb_dev;

/* ---- API du pilote SDK ---- */
struct usb_device_t;
struct usb_ctrlrequest;
void usb_var_init(usb_dev id, void *ep_addr);
void usb_setup_init(usb_dev id, void *setup, u8 *setup_buffer);
void usb_g_sie_init(usb_dev id);
void usb_write_power(usb_dev id, u32 v);
void usb_slave_init(usb_dev id);
void usb_set_dma_raddr(usb_dev id, u32 ep, void *p);
void usb_write_intr_usbe(usb_dev id, u32 v);
void usb_clr_intr_txe(usb_dev id, int ep);
void usb_clr_intr_rxe(usb_dev id, int ep);
void usb_set_intr_txe(usb_dev id, int ep);
void usb_set_intr_rxe(usb_dev id, int ep);
void usb_read_intr(usb_dev id, u32 *usb, u32 *tx, u32 *rx);
void usb_read_intre(usb_dev id, u32 *usb, u32 *tx, u32 *rx);
struct usb_device_t *usb_id2device(usb_dev id);
void usb_control_transfer(struct usb_device_t *d);
void usb_reset_interface(struct usb_device_t *d);
u32 usb_set_reset_hander(usb_dev id, u32 itf, void (*h)(struct usb_device_t *, u32));
u32 usb_g_ep_config(usb_dev id, u32 ep, u32 type, u32 ie, u8 *dma, u32 maxp);
void usb_enable_ep(usb_dev id, u32 ep);
u32 usb_g_bulk_read(usb_dev id, u32 ep, u8 *p, u32 len, u32 block);
u32 usb_g_bulk_write(usb_dev id, u32 ep, const u8 *p, u32 len);
u32 usb_read_txcsr(usb_dev id, u32 ep);
void usb_sie_close(usb_dev id);

extern volatile u32 jiffies;
void proto_sysex(const u8 *msg, u32 len);           /* proto.c : message complet F0 ... F7 */

#define EP_MIDI 1
#define MAXP    64

/* ---- descripteurs ---- */
static const u8 dev_desc[18] = {
    18, 1, 0x00, 0x02,      /* USB 2.0 (full speed) */
    0, 0, 0, 64,            /* classe définie par interface, EP0 64 o */
    0x09, 0x12, 0x01, 0x00, /* VID 0x1209, PID 0x0001 (pid.codes, test) */
    0x00, 0x01,             /* bcdDevice 1.00 */
    1, 2, 3, 1
};
#define CFG_LEN (9 + 9 + 9 + 9 + 7 + 6 + 6 + 9 + 9 + 9 + 5 + 9 + 5)
static const u8 cfg_desc[CFG_LEN] = {
    9, 2, CFG_LEN & 0xFF, CFG_LEN >> 8, 2, 1, 0, 0x80, 50,          /* configuration : 2 interfaces, alim. bus 100 mA */
    /* interface 0 : Audio Control */
    9, 4, 0, 0, 0, 1, 1, 0, 0,
    9, 0x24, 1, 0x00, 0x01, 9, 0, 1, 1,                               /* en-tête AC : 1 interface de flux = 1 */
    /* interface 1 : MIDIStreaming */
    9, 4, 1, 0, 2, 1, 3, 0, 0,
    7, 0x24, 1, 0x00, 0x01, 65, 0,                                    /* en-tête MS, longueur totale 65 */
    6, 0x24, 2, 1, 1, 0,                                              /* MIDI IN jack intégré, id 1 */
    6, 0x24, 2, 2, 2, 0,                                              /* MIDI IN jack externe, id 2 */
    9, 0x24, 3, 1, 3, 1, 2, 1, 0,                                     /* MIDI OUT jack intégré, id 3 <- 2 */
    9, 0x24, 3, 2, 4, 1, 1, 1, 0,                                     /* MIDI OUT jack externe, id 4 <- 1 */
    9, 5, EP_MIDI, 2, MAXP, 0, 0, 0, 0,                               /* EP1 OUT bulk */
    5, 0x25, 1, 1, 1,                                                 /*   -> jack 1 */
    9, 5, 0x80 | EP_MIDI, 2, MAXP, 0, 0, 0, 0,                        /* EP1 IN bulk */
    5, 0x25, 1, 1, 3,                                                 /*   <- jack 3 */
};
static void put_str(u8 *p, const char *s)
{
    u32 n = 0;
    while (s[n]) { p[2 + 2 * n] = (u8)s[n]; p[3 + 2 * n] = 0; n++; }
    p[0] = (u8)(2 + 2 * n); p[1] = 3;
}
void get_device_descriptor(u8 *p, usb_dev id) { u32 i; (void)id; for (i = 0; i < 18; i++) p[i] = dev_desc[i]; }
void get_language_str(u8 *p) { p[0] = 4; p[1] = 3; p[2] = 0x09; p[3] = 0x04; }
void get_manufacture_str(u8 *p) { put_str(p, "fw maison"); }
void get_product_str(u8 *p) { put_str(p, "BlackBox Custom"); }
void get_iserialnumber_str(u8 *p) { put_str(p, "BBC0001"); }
void get_string_ee(u8 *p) { p[0] = 2; p[1] = 3; }
u32 set_descriptor(usb_dev id, u32 cls, u8 *p, u32 max)
{
    u32 i;
    (void)id; (void)cls;
    for (i = 0; i < CFG_LEN && i < max; i++) p[i] = cfg_desc[i];
    return CFG_LEN;
}

/* ---- état ---- */
static u8 ep_addr_mem[128] __attribute__((aligned(4)));             /* struct usb_ep_addr_t (104 o) */
static u8 setup_mem[256] __attribute__((aligned(4)));               /* struct usb_setup_t */
static u8 setup_buf[768] __attribute__((aligned(4)));
static u8 ep0_dma[64 + 4] __attribute__((aligned(4)));
static u8 in_dma[MAXP * 2 + 8] __attribute__((aligned(4)));
static u8 out_dma[MAXP * 2 + 8] __attribute__((aligned(4)));
static u8 rx_pkt[MAXP] __attribute__((aligned(4)));
static u32 ep_ready;
static u32 stat_resets, stat_rxpk, stat_txpk, stat_ctrl;

#define SYX_MAX 4096
static u8 syx[SYX_MAX];
static u32 syx_len, syx_on;

#define TXQ 4096                                                    /* paquets USB-MIDI de 4 o, en octets (puissance de 2) */
static u8 txq[TXQ] __attribute__((section(".gfxbss")));             /* région GFX : la RAM principale est pleine */
static u32 txq_r, txq_w;

static void midi_ep_init(struct usb_device_t *d, u32 itf)
{
    (void)d; (void)itf;
    usb_g_ep_config(0, 0x80 | EP_MIDI, 2, 0, in_dma, MAXP);
    usb_g_ep_config(0, EP_MIDI, 2, 1, out_dma, MAXP);
    usb_enable_ep(0, EP_MIDI);
    ep_ready = 1;
    stat_resets++;
}

void usb_midi_init(void)
{
    usb_var_init(0, ep_addr_mem);
    usb_setup_init(0, setup_mem, setup_buf);
    usb_g_sie_init(0);
    usb_write_power(0, 0x40);                                      /* full speed, connexion logicielle */
    usb_slave_init(0);
    usb_set_dma_raddr(0, 0, ep0_dma); usb_set_dma_raddr(0, 1, ep0_dma); usb_set_dma_raddr(0, 2, ep0_dma);
    usb_set_dma_raddr(0, 3, ep0_dma); usb_set_dma_raddr(0, 4, ep0_dma);
    usb_write_intr_usbe(0, (1u << 2) | (1u << 0));                 /* RESET_BABBLE | SUSPEND */
    usb_clr_intr_txe(0, -1);
    usb_clr_intr_rxe(0, -1);
    usb_set_intr_txe(0, 0);
    usb_set_intr_rxe(0, 0);
    usb_set_reset_hander(0, 1, midi_ep_init);
}

/* ---- réception : paquets USB-MIDI -> SysEx ---- */
static void syx_byte(u8 b)
{
    if (b == 0xF0) { syx_on = 1; syx_len = 0; }
    if (!syx_on) return;
    if (syx_len < SYX_MAX) syx[syx_len++] = b;
    if (b == 0xF7) { syx_on = 0; if (syx_len <= SYX_MAX) proto_sysex(syx, syx_len); syx_len = 0; }
}
static void rx_packets(const u8 *p, u32 n)
{
    u32 i;
    for (i = 0; i + 4 <= n; i += 4) {
        u32 cin = p[i] & 0x0F;
        if (cin == 0x4 || cin == 0x7) { syx_byte(p[i + 1]); syx_byte(p[i + 2]); syx_byte(p[i + 3]); }
        else if (cin == 0x5) syx_byte(p[i + 1]);
        else if (cin == 0x6) { syx_byte(p[i + 1]); syx_byte(p[i + 2]); }
    }
}

/* ---- émission ---- */
static u32 txq_free(void) { return TXQ - (txq_w - txq_r); }
u32 usb_midi_tx_free(void) { return ep_ready ? txq_free() : 0; }     /* octets libres de la file (4 o de paquet pour 3 o de SysEx) */
static void txq_put4(u8 a, u8 b, u8 c, u8 d)
{
    txq[txq_w % TXQ] = a; txq[(txq_w + 1) % TXQ] = b; txq[(txq_w + 2) % TXQ] = c; txq[(txq_w + 3) % TXQ] = d;
    txq_w += 4;
}
/* met en file un SysEx complet (F0 ... F7) ; renvoie 0 si la file est pleine (rien n'est mis) */
int usb_midi_send_sysex(const u8 *m, u32 n)
{
    u32 i = 0;
    if (!ep_ready || txq_free() < ((n + 2) / 3 + 1) * 4) return 0;
    while (n - i > 3) { txq_put4(0x04, m[i], m[i + 1], m[i + 2]); i += 3; }
    if (n - i == 3) txq_put4(0x07, m[i], m[i + 1], m[i + 2]);
    else if (n - i == 2) txq_put4(0x06, m[i], m[i + 1], 0);
    else txq_put4(0x05, m[i], 0, 0);
    return 1;
}
static void tx_pump(void)
{
    u8 pkt[MAXP];
    u32 n = 0;
    if (!ep_ready || txq_r == txq_w) return;
    if (usb_read_txcsr(0, EP_MIDI) & 1u) return;                    /* paquet précédent pas encore parti : ne jamais attendre */
    while (n < MAXP && txq_r != txq_w) { pkt[n++] = txq[txq_r % TXQ]; txq_r++; }
    usb_g_bulk_write(0, EP_MIDI, pkt, n);
    stat_txpk++;
}

/* ---- scrutation, à appeler souvent depuis la boucle principale ---- */
void usb_midi_poll(void)
{
    u32 iu, it, ir, eu, et, er;
    struct usb_device_t *d = usb_id2device(0);
    usb_read_intr(0, &iu, &it, &ir);
    usb_read_intre(0, &eu, &et, &er);
    iu &= eu; it &= et; ir &= er;
    if (iu & (1u << 2)) { ep_ready = 0; usb_reset_interface(d); }  /* remise à zéro du bus */
    if (it & 1u) { usb_control_transfer(d); stat_ctrl++; }
    if (ir & (1u << EP_MIDI)) {
        u32 n = usb_g_bulk_read(0, EP_MIDI, rx_pkt, MAXP, 0);
        if (n) { rx_packets(rx_pkt, n); stat_rxpk++; }
    }
    tx_pump();
}
void usb_midi_stats(u32 *o) { o[0] = stat_resets; o[1] = stat_ctrl; o[2] = stat_rxpk; o[3] = stat_txpk; o[4] = ep_ready; }
