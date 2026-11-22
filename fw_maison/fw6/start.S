// Point d'entrée de l'application (0x2000120, juste après le répertoire JLFS), appelé par le SPL.
// Comme l'original : piles sp/ssp en RAM, puis C. Pas de .data/.bss (le C n'utilise que des adresses fixes).
	.section .text.start,"ax",@progbits
	.globl	_start
_start:
	cli
	sp = 29622256          // 0x1C3FFF0
	ssp = 29618160         // 0x1C3EFF0
	call fw_main
1:
	goto 1b
