// isa_probe.S : mesure la sémantique de quelques instructions DSP du pi32v2 (commande 0x1E).
// void isa_probe(u32 *out, const short *h, const int *wv)
//   h  = {3, -2, 0x4000, 3, 3}, wv = {0x00010002, 0x00010002, 0x40000000, 0x00010002}
	.text
	.globl	isa_probe
	.p2align	1
isa_probe:
	[--sp] = {rets, r15-r4}
	r12 = r0
	r10 = r1
	r11 = r2
	// 1 : += h * reg
	r6 = [r11+0]
	r1_r0 = 0
	r1_r0 += h[r10 ++= 2]*r6 (s)
	[r12+0] = r0
	[r12+4] = r1
	// 2 : h = -2
	r6 = [r11+4]
	r1_r0 = 0
	r1_r0 += h[r10 ++= 2]*r6 (s)
	[r12+8] = r0
	[r12+12] = r1
	// 3 : 0x4000 * 0x40000000
	r6 = [r11+8]
	r1_r0 = 0
	r1_r0 += h[r10 ++= 2]*r6 (s)
	[r12+16] = r0
	[r12+20] = r1
	// 4 : forme « = »
	r6 = [r11+12]
	r1_r0 = h[r10 ++= 2]*r6 (s)
	[r12+24] = r0
	[r12+28] = r1
	// 5 : h * [mem32] (r10 -> h[4] = 3)
	r9 = r11
	r1_r0 = 0
	r1_r0 += h[r10 ++= 2]*[r9 ++= 4] (s)
	[r12+32] = r0
	[r12+36] = r1
	// 6 : décalage arithmétique 64 bits par registre
	r1_r0 = 0
	r0 = -1000
	r1 = -1
	r6 = 3
	r1_r0 >>>= r6
	[r12+40] = r0
	[r12+44] = r1
	// 7 : produit 32x32 signé
	r6 = -5
	r7 = 0x40000000
	r1_r0 = r6 * r7 (s)
	[r12+48] = r0
	[r12+52] = r1
	// 8 : lecture 64 bits d[] de wv[0..1] (r0 = mot à +0 ?)
	r1_r0 = d[r11+8]
	[r12+56] = r0
	[r12+60] = r1
	// 9 : rep r2 { lecture ; écriture } avec r2 = 3 : r2 final et octets parcourus
	r9 = r11
	r10 = r12
	r10 += 128
	r2 = 3
	rep r2 {
		r6 = [r9++=4]
		[r10++=4] = r6
	}
	[r12+64] = r2
	r9 = r9 - r11
	[r12+68] = r9
	// 10 : rep r2 { MAC } avec r2 = 4 : accumulateur et r2 final
	r10 = r1
	r1_r0 = 0
	r6 = 1
	r2 = 4
	r3 = r12
	r3 += 160
	[r3+0] = r6
	[r3+4] = r6
	[r3+8] = r6
	[r3+12] = r6
	r9 = r3
	r8 = r11
	r8 += 0
	r4 = 0
	rep r2 {
		r4 += 1
	}
	[r12+72] = r4
	[r12+76] = r2
	{pc, r15-r4} = [sp++]
