// amx_fir.S : FIR 256 taps des captures M-VAVE, en assembleur pi32v2.
// s32 amx_fir256_asm(const s32 *w, s32 *h, int *pos, s32 x)
// Historique miroir : h[p]=x et h[p+256]=x ; la fenêtre utile est h[p+1 .. p+256] (contiguë).
// Poids Q20, historique Q12 ; accumulateurs 64 bits, 4 paires, 8 prises par tour.
	.text
	.globl	amx_fir256_asm
amx_fir256_asm:
	[--sp] = {rets, r15-r4}
	r4 = [r2+0]                 // p
	[r1+r4<<2] = r3             // h[p] = x
	r5 = r4 + 256
	[r1+r5<<2] = r3             // h[p+256] = x
	r6 = r4 + 1
	r6 = r6 << 2
	r1 = r1 + r6                // hp = h + p + 1
	r7_r6 = 0
	r9_r8 = 0
	r11_r10 = 0
	r13_r12 = 0
	r14 = 32                    // 32 x 8 prises = 256
loop:
	r4 = [r0++=4]
	r5 = [r1++=4]
	r7_r6 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r9_r8 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r11_r10 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r13_r12 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r7_r6 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r9_r8 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r11_r10 += r4 * r5 (s)
	r4 = [r0++=4]
	r5 = [r1++=4]
	r13_r12 += r4 * r5 (s)
	r14 += -1
	if (r14 != 0) goto loop
	r6 += r8
	r7 = r7 + r9 + c
	r6 += r10
	r7 = r7 + r11 + c
	r6 += r12
	r7 = r7 + r13 + c
	r7_r6 >>= 20
	r0 = r6
	r4 = [r2+0]
	r4 += 1
	r4 = r4.b0 (u)              // (p+1) & 255
	[r2+0] = r4
	{pc, r15-r4} = [sp++]
