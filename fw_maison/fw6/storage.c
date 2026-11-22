/* storage.c : écriture/lecture de la flash par le firmware lui-même (presets, IR, captures), sans passer par UBOOT.
 * Pilote bas niveau = vm_sfc du SDK JieLi (Apache-2.0) : routines en RAM (.spi_code) pendant que la flash est en mode SPI.
 *
 * Garde-fous : seule la zone [STORE_LO, STORE_HI) peut être effacée/écrite ; refus de tout le reste (SPL, application).
 * Les données sont chiffrées SFC à l'écriture (clé puce 0x980F, bloc de 32 o, clé ^ (offset depuis 0x4000) >> 2) pour que
 * la lecture directe par le processeur (XIP, 0x2000000 + flash - 0x4000) rende les octets en clair. */
typedef unsigned int u32;
typedef unsigned short u16;
typedef unsigned char u8;

#define STORE_LO   0x60000u
#define STORE_HI   0xA7000u
#define APP_FLASH  0x4000u
#define APP_CPU    0x2000000u
#define CHIP_KEY   0x980Fu

int norflash_init(void *node, void *arg);
int norflash_ioctl(void *dev, u32 cmd, u32 arg);
int norflash_erase(u32 cmd, u32 addr);
int norflash_write(void *dev, void *buf, u32 len, u32 offset);

static u32 st_ready, st_err;

#define MARK (*(volatile u32 *)0x1C70044u)              /* RB[17] : étape de l'initialisation (diagnostic) */
u32 storage_init(void)
{
    /* struct de l'ioctl 205 : 16 o (vm info), 8 o {base flash, base cpu} pour flash_addr2cpu_addr, 4 o */
    static u32 info[7];
    if (st_ready) return 0;
    info[0] = 0; info[1] = 0; info[2] = 0; info[3] = 0;
    info[4] = APP_FLASH; info[5] = APP_CPU;
    info[6] = 0;
    MARK = 0x5701;
    norflash_init(0, 0);
    MARK = 0x5702;
    /* PAS d'ioctl 205 : il reprogramme la fenêtre de déchiffrement du SFC et fait planter l'exécution en flash.
       La correspondance flash -> cpu est codée en dur dans flash_addr2cpu_addr (patch_markers.py). */
    (void)info;
    MARK = 0x5703;
    st_ready = 1;
    return 0;
}

/* zones autorisées : [0x60000, 0xC2000) et [0xC3000, 0x100000) (le secteur BTIF 0xC2000 est laissé au Bluetooth) */
static u32 in_store(u32 a, u32 n)
{
    if (n > 0x100000u || a + n < a) return 0;
    return (a >= STORE_LO && a + n <= 0xC2000u) || (a >= 0xC3000u && a + n <= 0x100000u);
}
const u8 *storage_ptr(u32 flash_addr) { return (const u8 *)(APP_CPU + flash_addr - APP_FLASH); }

/* chiffrement SFC sur place de buf, qui sera écrit à l'adresse flash a */
static void sfc_crypt(u8 *buf, u32 len, u32 a)
{
    u32 i = 0;
    while (i < len) {
        u32 p = a + i - APP_FLASH, blk = p & ~31u, k = (CHIP_KEY ^ (blk >> 2)) & 0xFFFF, j;
        for (j = blk; j < p; j++) k = ((k << 1) ^ ((k & 0x8000) ? 0x1021 : 0)) & 0xFFFF;   /* avancer jusqu'à p */
        for (; j < blk + 32 && i < len; j++, i++) {
            buf[i] ^= (u8)k;
            k = ((k << 1) ^ ((k & 0x8000) ? 0x1021 : 0)) & 0xFFFF;
        }
    }
}

/* efface le secteur de 4 Ko qui contient a ; 0 = OK */
/* sortie audio à zéro pendant les accès flash (le DMA continue de lire le tampon ; sinon il rejoue le dernier bloc en boucle) */
void core1_park(void), core1_unpark(void);                          /* le 2e cœur s'exécute en flash : garé en RAM pendant les accès */
void main_audio_grace(void);                                        /* main.c : les retards audio dus à l'accès flash ne comptent pas comme surcharge */
static void mute_out(void) { volatile u32 *tx = (volatile u32 *)0x1C50000u; u32 i; for (i = 0; i < 256; i++) tx[i] = 0; }
int storage_erase(u32 a)
{
    int r;
    if ((a & 0xFFF) || !in_store(a, 0x1000)) { st_err++; return -1; }
    main_audio_grace();
    mute_out();
    core1_park();
    storage_init();
    MARK = 0x5710;
    r = norflash_erase(200, a);
    MARK = 0x5711;
    core1_unpark();
    main_audio_grace();
    return r == 0 ? 0 : -2;
}
/* écrit len octets en clair (chiffrés ici) à l'adresse a ; la zone doit avoir été effacée ; 0 = OK */
static u8 wbuf[256];
int storage_write(u32 a, const u8 *src, u32 len)
{
    u32 done = 0;
    if (!in_store(a, len)) { st_err++; return -1; }
    main_audio_grace();
    mute_out();
    core1_park();
    storage_init();
    MARK = 0x5720;
    while (done < len) {
        u32 n = len - done, i;
        if (n > sizeof(wbuf)) n = sizeof(wbuf);
        if (((a + done) & 0xFF) + n > 0x100) n = 0x100 - ((a + done) & 0xFF);        /* ne pas franchir une page */
        for (i = 0; i < n; i++) wbuf[i] = src[done + i];
        sfc_crypt(wbuf, n, a + done);
        if (norflash_write(0, wbuf, n, a + done) != (int)n) { core1_unpark(); main_audio_grace(); return -2; }
        done += n;
    }
    core1_unpark();
    main_audio_grace();
    return 0;
}
u32 storage_errors(void) { return st_err; }
/* diagnostic sans écriture : identifiant JEDEC et capacité lus par le pilote (attendu 0xEB6014 / 1 Mio) */
void storage_id(u32 *id, u32 *cap)
{
    core1_park();
    storage_init();
    *id = 0; *cap = 0;
    norflash_ioctl(0, 100, (u32)id);
    norflash_ioctl(0, 103, (u32)cap);
    core1_unpark();
}
