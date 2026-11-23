/* reboot.c : programme en RAM qui redémarre l'AC791N.
 * Chargé par le loader UBOOT à 0x1C20000 puis exécuté (bb_tool.reboot) : la puce repart du SPL, qui lance l'application.
 * Recette : CORE_SYSTEM_RESET du SDK JieLi AC79 (cpu/wl82/p33.c, Apache-2.0) = bit 4 du registre 0x10000. */
void __attribute__((section(".text.start"), noreturn)) _start(void)
{
    *(volatile unsigned int *)0x10000u |= 0x10u;
    for (;;) { }
}
