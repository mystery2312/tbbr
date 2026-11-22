/* usb_glue.c : fonctions « système » minimales attendues par le pilote USB du SDK JieLi AC79 (cpu.a : usb.c, usb_setup.c,
 * usb_phy.c, Apache-2.0, voir sdk/LICENSE-JieLi-SDK-Apache-2.0.txt). Pas d'OS, pas d'interruptions : tout est scruté.
 * Compiler avec -fno-builtin (memset/memcpy écrits à la main). */
typedef unsigned int u32;
typedef unsigned char u8;

/* ---- mémoire ---- */
void *memset(void *d, int c, u32 n) { volatile u8 *p = d; while (n--) *p++ = (u8)c; return d; }
void *memcpy(void *d, const void *s, u32 n) { volatile u8 *p = d; const u8 *q = s; while (n--) *p++ = *q++; return d; }

/* ---- temps : jiffies avancé par la boucle principale (un pas par bloc audio, ~2,7 ms) ---- */
volatile u32 jiffies;
void delay(u32 n) { volatile u32 i; for (i = 0; i < n; i++) { } }
void udelay(u32 us) { delay(us * 40u); }
void delay_us(u32 us) { udelay(us); }
void os_time_dly(u32 t) { delay(t * 400000u); }

/* ---- journal / assertions : muets ---- */
const u8 log_tag_const_i_USB = 0, log_tag_const_e_USB = 0, log_tag_const_d_USB = 0;
const int config_asser = 0;
int otg_prevent_detect = 0;
int printf(const char *f, ...) { (void)f; return 0; }
int putchar(int c) { return c; }
void log_print(int l, const char *t, const char *f, ...) { (void)l; (void)t; (void)f; }
void cpu_assert_debug(void) { }
const char *os_current_task_rom(void) { return "fw"; }
void P33_SYSTEM_RESET(void) { }
u32 CrcDecode(void *b, u32 n) { (void)b; (void)n; return 0; }
int usb_control_msg(void) { return -1; }                         /* mode hôte : inutilisé */

/* ---- interruptions : on n'en utilise pas (en RAM : peuvent être appelées pendant que la flash est en mode SPI) ---- */
#define RAMCODE __attribute__((section(".spi_code")))
RAMCODE void sys_local_irq_disable(void) { }
RAMCODE void sys_local_irq_enable(void) { }
RAMCODE void __local_irq_disable(void) { }
RAMCODE void __local_irq_enable(void) { }
RAMCODE void putbyte(char c) { (void)c; }

/* ---- pilote flash vm_sfc du SDK ---- */
/* 0 = section critique active : avec cpu1_run_flag = 0 elle attend que le cache d'instructions soit au repos (0x1EEE008 bit 14)
   avant de couper la flash, comme le firmware d'origine. À 1 (sans cette attente) la pédale se figeait dès l'entrée en mode SPI. */
const int norflash_write_cpu_unhold = 0;
const int norflash_write_readback_check_en = 0;
volatile u8 cpu1_run_flag = 0;
const u8 log_tag_const_i_VM = 0, log_tag_const_e_VM = 0;
int os_mutex_create(void *m) { (void)m; return 0; }
int os_mutex_pend(void *m, int t) { (void)m; (void)t; return 0; }
int os_mutex_post(void *m) { (void)m; return 0; }
static u8 heap[2048] __attribute__((aligned(8)));
static u32 heap_used;
void *malloc(u32 n) { void *p; n = (n + 7) & ~7u; if (heap_used + n > sizeof(heap)) return 0; p = heap + heap_used; heap_used += n; return p; }
void doe(u32 key, void *buf, u32 len, u32 addr) { (void)key; (void)buf; (void)len; (void)addr; }
u32 get_system_enc_key(void) { return 0x980F; }
int memcmp(const void *a, const void *b, u32 n) { const u8 *p = a, *q = b; while (n--) { if (*p != *q) return *p - *q; p++; q++; } return 0; }
void printf_buf(const void *b, u32 n) { (void)b; (void)n; }
int request_irq(u32 a, u32 b, void *c, u32 d) { (void)a; (void)b; (void)c; (void)d; return 0; }
void unrequest_irq(u32 a, u32 b) { (void)a; (void)b; }

/* ---- broches : seulement USB DP (148) / DM (149), registre JL_USB_IO->CON0 (0x51000), comme gpio.c du SDK ---- */
#define USB_IO_CON0 (*(volatile u32 *)0x51000u)
static int usbpin(u32 g) { return (g & ~1u) == 148u; }
static void usb_bit(u32 bit, u32 v) { if (v) USB_IO_CON0 |= 1u << bit; else USB_IO_CON0 &= ~(1u << bit); }
int gpio_set_die(u32 g, u32 v)           { if (usbpin(g)) usb_bit(g - 139u, v); return 0; }
int gpio_set_dieh(u32 g, u32 v)          { if (usbpin(g)) usb_bit(g - 135u, v); return 0; }
int gpio_set_pull_up(u32 g, u32 v)       { if (usbpin(g)) usb_bit(g - 142u, v); return 0; }
int gpio_set_pull_down(u32 g, u32 v)     { if (usbpin(g)) usb_bit(g - 144u, v); return 0; }
int gpio_set_direction(u32 g, u32 v)     { if (usbpin(g)) usb_bit(g - 146u, v); return 0; }
int gpio_direction_input(u32 g)          { return gpio_set_direction(g, 1); }
int gpio_direction_output(u32 g, u32 v)  { if (usbpin(g)) { usb_bit(g - 148u, v); usb_bit(g - 146u, 0); } return 0; }
void usb_iomode(u8 id, u32 en)           { if (id == 0) { if (en) USB_IO_CON0 |= 0x900u; else USB_IO_CON0 &= ~0x900u; } }
