// bench.S : micro-mesures du cœur pi32v2 (commande 0x1F). Chaque fonction : (n itérations, tampon RAM de 256 o).
	.section .sram,"ax",@progbits
	.globl	bench_empty
	.p2align	1
bench_empty:                            // boucle vide : n tours
1:	if (--r0 != 0) goto 1b
	rts

	.globl	bench_hmac
	.p2align	1
bench_hmac:                             // 36 MAC h[]*reg, 3 accumulateurs
	[--sp] = {rets, r15-r4}
	r6 = 3
	r7 = 5
	r8 = 7
1:	r10 = r1
	.rept 4
	r3_r2 += h[r10 ++= 2]*r6 (s)
	r5_r4 += h[r10 ++= 2]*r6 (s)
	r13_r12 += h[r10 ++= 2]*r6 (s)
	r3_r2 += h[r10 ++= 2]*r7 (s)
	r5_r4 += h[r10 ++= 2]*r7 (s)
	r13_r12 += h[r10 ++= 2]*r7 (s)
	r3_r2 += h[r10 ++= 2]*r8 (s)
	r5_r4 += h[r10 ++= 2]*r8 (s)
	r13_r12 += h[r10 ++= 2]*r8 (s)
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_hmac1
	.p2align	1
bench_hmac1:                            // 36 MAC h[]*reg sur UN accumulateur (dépendants)
	[--sp] = {rets, r15-r4}
	r6 = 3
1:	r10 = r1
	.rept 36
	r3_r2 += h[r10 ++= 2]*r6 (s)
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_load
	.p2align	1
bench_load:                             // 36 lectures 32 bits [r9+k]
	[--sp] = {rets, r15-r4}
1:	r9 = r1
	.rept 12
	r6 = [r9+0]
	r7 = [r9+4]
	r8 = [r9+8]
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_tap
	.p2align	1
bench_tap:                              // 4 prises comme le noyau (3 lectures + 1 add + 9 MAC) = 36 MAC
	[--sp] = {rets, r15-r4}
	r11 = 12
1:	r10 = r1
	r9 = r1
	.rept 4
	r6 = [r9+0]
	r7 = [r9+4]
	r8 = [r9+8]
	r9 += r11
	r3_r2 += h[r10 ++= 2]*r6 (s)
	r5_r4 += h[r10 ++= 2]*r6 (s)
	r13_r12 += h[r10 ++= 2]*r6 (s)
	r3_r2 += h[r10 ++= 2]*r7 (s)
	r5_r4 += h[r10 ++= 2]*r7 (s)
	r13_r12 += h[r10 ++= 2]*r7 (s)
	r3_r2 += h[r10 ++= 2]*r8 (s)
	r5_r4 += h[r10 ++= 2]*r8 (s)
	r13_r12 += h[r10 ++= 2]*r8 (s)
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_copy
	.p2align	1
bench_copy:                             // copie de 32 mots (lecture/écriture post-incrémentées)
	[--sp] = {rets, r15-r4}
1:	r9 = r1
	r10 = r1
	r10 += 128
	.rept 16
	r6 = [r9++=4]
	r7 = [r9++=4]
	[r10++=4] = r6
	[r10++=4] = r7
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_repcopy
	.p2align	1
bench_repcopy:                          // copie de 32 mots avec rep (boucle matérielle)
	[--sp] = {rets, r15-r4}
1:	r9 = r1
	r10 = r1
	r10 += 128
	r2 = 32
	rep r2 {
		r6 = [r9++=4]
		[r10++=4] = r6
	}
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_rmac
	.p2align	1
bench_rmac:                             // 36 MAC reg*reg 32x32, 3 accumulateurs
	[--sp] = {rets, r15-r4}
	r6 = 3
	r7 = 5
	r8 = 7
1:	.rept 12
	r3_r2 += r6 * r7 (s)
	r5_r4 += r7 * r8 (s)
	r13_r12 += r8 * r6 (s)
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]

	.globl	bench_dmac
	.p2align	1
bench_dmac:                             // 36 MAC h[]*[mem32] (deux opérandes mémoire), 3 accumulateurs
	[--sp] = {rets, r15-r4}
1:	r10 = r1
	r9 = r1
	r9 += 128
	.rept 12
	r3_r2 += h[r10 ++= 2]*[r9 ++= 4] (s)
	r5_r4 += h[r10 ++= 2]*[r9 ++= 4] (s)
	r13_r12 += h[r10 ++= 2]*[r9 ++= 4] (s)
	.endr
	if (--r0 != 0) goto 1b
	{pc, r15-r4} = [sp++]
