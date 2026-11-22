"""gen_nam_asm.py : génère nam_asm.S, le noyau assembleur d'une couche NAM A2 Lite (3 canaux) pour l'AC791N (pi32v2).

Écrit pour ce projet. Principe : les poids sont des int16 lus directement par l'instruction de multiplication-accumulation
    r1_r0 += h[r10 ++= 2]*r6 (s)
(lecture 16 bits + produit 16x32 + somme 64 bits en une instruction), les activations Q23 (32 bits) sont en registres,
3 accumulateurs 64 bits entrelacés (pas de MAC dépendant de la précédente), prises entièrement déroulées (pas de saut).

void nam_layer6(struct alay *p) / nam_layer15(struct alay *p) : traite p->n trames d'une couche (voir struct alay dans nam.c).
Par trame f :  z_i = (b_i + sum_k sum_j W[k][j][i] * s[k*D + j] + mix_i * x[f]) >> sw ;  z = LeakyReLU(z, 0,01)
               hs[f][i] += z_i ;  lin[f][i] += l1b_i + (sum_j L1[i][j] * z_j) >> s1
Ordre des poids int16 (p->w) : prises k, entrée j, sortie i ; puis mix[0..2] ; puis L1[i][j] (sortie i, entrée j).
"""
import os, sys

# décalages dans struct alay (vérifiés par _Static_assert dans nam.c)
OFF = dict(b0=0, b1=8, b2=16, s=24, x=28, lin=32, hs=36, w=40, stride=44, sw=48, s1=52, l1b=56, n=68)
ACC = ["r1_r0", "r3_r2", "r5_r4"]
LO = ["r0", "r2", "r4"]


def layer(K, last=False):
    """last : dernière couche, sans 1x1 ni résiduel (la tête n'utilise que la somme des z)."""
    o = []
    e = o.append
    name = f"nam_layer{K}" + ("_last" if last else "")
    tag = f"{K}{'L' if last else ''}"
    e(f"\t.section .sram,\"ax\",@progbits")
    e(f"\t.globl\t{name}")
    e(f"\t.p2align\t1")
    e(f"{name}:")
    e("\t[--sp] = {rets, r15-r4}")
    e("\tr14 = r0")
    e(f"\tr12 = [r14+{OFF['s']}]")
    e(f"\tr15 = [r14+{OFF['x']}]")
    e(f"\tr13 = [r14+{OFF['n']}]")
    e(f".L{tag}_f:")
    for i in range(3):                                   # biais 64 bits : mot bas à +0 (petit-boutiste)
        e(f"\tr{2 * i} = [r14+{8 * i}]")
        e(f"\tr{2 * i + 1} = [r14+{8 * i + 4}]")
    e(f"\tr10 = [r14+{OFF['w']}]")
    e(f"\tr11 = [r14+{OFF['stride']}]")
    e("\tr9 = r12")
    for k in range(K):
        e("\tr6 = [r9+0]")
        e("\tr7 = [r9+4]")
        e("\tr8 = [r9+8]")
        if k != K - 1:
            e("\tr9 += r11")
        for a in ("r6", "r7", "r8"):
            for acc in ACC:
                e(f"\t{acc} += h[r10 ++= 2]*{a} (s)")
    # mixin
    e("\tr6 = [r15++=4]")
    for acc in ACC:
        e(f"\t{acc} += h[r10 ++= 2]*r6 (s)")
    # décalage, LeakyReLU 0,01 (z * 42949673 >> 32 si z < 0)
    e(f"\tr6 = [r14+{OFF['sw']}]")
    for acc in ACC:
        e(f"\t{acc} >>>= r6")
    e("\tr9 = 42949673")
    for z in LO:
        e(f"\tr7_r6 = {z} * r9 (s)")
        e(f"\tifs ({z} < 0) {{")
        e(f"\t\t{z} = r7")
        e("\t}")
    # somme pour la tête
    e(f"\tr9 = [r14+{OFF['hs']}]")
    for i, z in enumerate(LO):
        e(f"\tr6 = [r9+{4 * i}]")
        e(f"\tr6 = r6 + {z}")
        e(f"\t[r9+{4 * i}] = r6")
    e("\tr9 += 12")
    e(f"\t[r14+{OFF['hs']}] = r9")
    if not last:
        # 1x1 + résiduel : z -> r6, r7, r8 ; 3 accumulateurs indépendants (poids L1 rangés [entrée j][sortie i])
        e("\tr6 = r0")
        e("\tr7 = r2")
        e("\tr8 = r4")
        for j, a in enumerate(("r6", "r7", "r8")):
            for acc in ACC:
                e(f"\t{acc} {'=' if j == 0 else '+='} h[r10 ++= 2]*{a} (s)")
        e(f"\tr11 = [r14+{OFF['s1']}]")
        e(f"\tr9 = [r14+{OFF['lin']}]")
        for acc in ACC:
            e(f"\t{acc} >>>= r11")
        for i, z in enumerate(LO):
            e(f"\tr8 = [r9+{4 * i}]")
            e(f"\tr8 = r8 + {z}")
            e(f"\tr6 = [r14+{OFF['l1b'] + 4 * i}]")
            e("\tr8 = r8 + r6")
            e(f"\t[r9+{4 * i}] = r8")
        e("\tr9 += 12")
        e(f"\t[r14+{OFF['lin']}] = r9")
    e("\tr12 += 12")
    e(f"\tif (--r13 != 0) goto .L{tag}_f")
    e("\t{pc, r15-r4} = [sp++]")
    return o


def copy():
    """void nam_copy(s32 *d, const s32 *s, int n) : copie vers l'avant (d <= s permis), boucle matérielle rep."""
    return ["\t.section .sram,\"ax\",@progbits", "\t.globl\tnam_copy", "\t.p2align\t1", "nam_copy:",
            "\tif (r2 == 0) goto .Lc_end",
            ".Lc_rep:",
            "\trep r2 {",
            "\t\tr3 = [r1++=4]",
            "\t\t[r0++=4] = r3",
            "\t}",
            "\tif (r2 != 0) goto .Lc_rep",        # au cas où rep s'arrête avant la fin (interruption, plafond)
            ".Lc_end:",
            "\trts"]


def head():
    """void nam_head_asm(struct hd *p) : p = {w (int16 [48]), c (s32, colonnes), dst, n, hb_lo, hb_hi, sh}.
    dst[f] = (hb + sum_{t<48} w[t] * c[3f + t]) >> sh."""
    o = []
    e = o.append
    e("\t.section .sram,\"ax\",@progbits")
    e("\t.globl\tnam_head_asm")
    e("\t.p2align\t1")
    e("nam_head_asm:")
    e("\t[--sp] = {rets, r15-r4}")
    e("\tr14 = r0")
    e("\tr12 = [r14+4]")          # c
    e("\tr13 = [r14+8]")          # dst
    e("\tr15 = [r14+12]")         # n
    e("\tr11 = [r14+24]")         # sh
    e(".Lh_f:")
    e("\tr0 = [r14+16]")
    e("\tr1 = [r14+20]")
    e("\tr3_r2 = 0")
    e("\tr5_r4 = 0")
    e("\tr10 = [r14+0]")
    e("\tr9 = r12")
    for t in range(16):
        for acc in ACC:
            e(f"\t{acc} += h[r10 ++= 2]*[r9 ++= 4] (s)")
    e("\tr0 += r2")
    e("\tr1 = r1 + r3 + c")
    e("\tr0 += r4")
    e("\tr1 = r1 + r5 + c")
    e("\tr1_r0 >>>= r11")
    e("\t[r13++=4] = r0")
    e("\tr12 += 12")
    e("\tif (--r15 != 0) goto .Lh_f")
    e("\t{pc, r15-r4} = [sp++]")
    return o


def main():
    out = os.path.join(os.path.dirname(os.path.abspath(__file__)), "nam_asm.S")
    lines = ["// nam_asm.S : GÉNÉRÉ par gen_nam_asm.py (ne pas modifier à la main)"]
    for K in (6, 15):
        lines += layer(K)
        lines.append("")
    lines += layer(6, last=True)
    lines.append("")
    lines += head()
    lines.append("")
    lines += copy()
    lines.append("")
    open(out, "w", encoding="ascii", errors="replace", newline="\n").write("\n".join(lines) + "\n")
    print(out, len(lines), "lignes")


if __name__ == "__main__":
    main()
