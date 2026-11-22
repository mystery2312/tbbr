/* fw5 : code et constantes en flash (XIP, 0x2000120) ; .data ET le code qui doit tourner en RAM pendant les accès SPI à la flash
   (.spi_code, .volatile_ram_code, .flushinv_icache du pilote vm_sfc) sont copiés en RAM au démarrage ; .bss mise à zéro.
   RAM réservée : 0x1C34000..0x1C3E000. */
ENTRY(_start)
MEMORY {
    FLASH (rx)  : ORIGIN = 0x2000120, LENGTH = 0x5BEE0      /* jusqu'à la flash 0x60000 : au-delà, zone de stockage */
    RAM   (rwx) : ORIGIN = 0x1C34000, LENGTH = 0xA000
    GFX   (rw)  : ORIGIN = 0x1C40000, LENGTH = 0x10000      /* tampons de l'écran (gfx.c), non initialisés */
}
SECTIONS {
    .text : { *(.text.start) *(.text*) *(.rodata*) *(.srodata*) . = ALIGN(4); } > FLASH
    .data : {
        _data_start = .;
        _SPI_CODE_START = .;
        *(.spi_code) *(.volatile_ram_code) *(.flushinv_icache)
        . = ALIGN(4);
        _SPI_CODE_END = .;
        *(.sram) *(.volatile_ram) *(.data*) *(.sdata*)
        . = ALIGN(4);
        _data_end = .;
    } > RAM AT > FLASH
    _data_lma = LOADADDR(.data);
    .bss (NOLOAD) : { _bss_start = .; *(.bss*) *(.sbss*) *(COMMON) . = ALIGN(4); _bss_end = .; } > RAM
    .gfxbss (NOLOAD) : { *(.gfxbss) } > GFX
    /DISCARD/ : { *(.comment) }
}
