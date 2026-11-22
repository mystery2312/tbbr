// Point d'entrée du 2e cœur (comme cpu1_start du SDK et 0x20001B8 du firmware d'origine) :
// piles du cœur 1 en haut de la région GFX, puis saut vers cpu1_main par rti.
	.text
	.globl	cpu1_entry
cpu1_entry:
	usp = 0x1C4F7F0
	sp = 0x1C4FFF0
	reti = cpu1_main
	rti
