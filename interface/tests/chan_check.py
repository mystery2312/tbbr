"""chan_check.py : de quel côté du mot stéréo arrive la guitare (PT_RX), quelle moitié lit le firmware (RB[24]), crête d'entrée lue."""
import sys, os, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool
def peek(a):
    got = bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x15]) + bytes(((a >> (7 * i)) & 0x7F) for i in range(5)) + b"\xF7", wait=0.6, port="BlackBox Custom")
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x15")
            if k < 0: continue
            s = part[k + 5:]; out = bytearray(); i = 0
            while i < len(s):
                hi = s[i]; i += 1
                for j in range(7):
                    if i >= len(s): break
                    out.append((s[i] & 0x7F) | (((hi >> j) & 1) << 7)); i += 1
            return [int.from_bytes(out[q:q + 4], "little") for q in range(0, len(out) - 3, 4)]
    return []
s16 = lambda v: v - 65536 if v & 0x8000 else v
lo = hi = 0
for _ in range(6):
    for a in (0x1C52000, 0x1C52040, 0x1C52080):
        for w in peek(a): lo += abs(s16(w & 0xFFFF)); hi += abs(s16(w >> 16))
rb = peek(0x1C70060)
sel = rb[0] if rb else None
print(f"énergie moitié basse {lo}, haute {hi} -> guitare côté {'HAUT' if hi > lo else 'BAS'} ; firmware lit {'HAUT' if sel and sel & 1 else 'BAS'} (bascules {sel >> 1 if sel is not None else '?'})")
