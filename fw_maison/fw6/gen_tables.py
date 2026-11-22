"""gen_tables.py : tables.h pour fw6 (saturation tanh Q23 sur [-4, 4] pas 1/64, sinus 256 points Q15)."""
import math, os
L = ["/* généré par gen_tables.py : ne pas modifier */", "#pragma once"]
def shape(x): return math.tanh(x + 0.15) - math.tanh(0.15)
v = [round(shape(-4 + k / 64) * (1 << 23)) for k in range(513)]
L.append("static const int sat_tab[513] = {")
for k in range(0, 513, 8): L.append("    " + ", ".join(map(str, v[k:k + 8])) + ",")
L.append("};")
s = [round(math.sin(2 * math.pi * k / 256) * 32767) for k in range(256)]
L.append("static const short sine256[256] = {")
for k in range(0, 256, 16): L.append("    " + ", ".join(map(str, s[k:k + 16])) + ",")
L.append("};")
open(os.path.join(os.path.dirname(os.path.abspath(__file__)), "tables.h"), "w", encoding="utf-8").write("\n".join(L) + "\n")
print("tables.h OK")
