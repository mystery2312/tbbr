"""capture.py <sortie.png> [échelle] : capture l'écran de la pédale (commande SysEx 0x17, ligne par ligne, RGB565) en PNG.
Sans dépendance (encodeur PNG minimal)."""
import sys, os, struct, zlib, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool

def unpack7(s):
    out = bytearray(); i = 0
    while i < len(s):
        hi = s[i]; i += 1
        for k in range(7):
            if i >= len(s): break
            out.append((s[i] & 0x7F) | (((hi >> k) & 1) << 7)); i += 1
    return bytes(out)

def write_png(path, w, h, rgb, scale=1):
    raw = bytearray()
    for y in range(h * scale):
        raw.append(0)
        row = rgb[(y // scale) * w * 3:((y // scale) + 1) * w * 3]
        for x in range(w * scale): raw += row[(x // scale) * 3:(x // scale) * 3 + 3]
    def chunk(t, d): return struct.pack(">I", len(d)) + t + d + struct.pack(">I", zlib.crc32(t + d) & 0xFFFFFFFF)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", struct.pack(">IIBBBBB", w * scale, h * scale, 8, 2, 0, 0, 0)) + chunk(b"IDAT", zlib.compress(bytes(raw), 9)) + chunk(b"IEND", b"")
    open(path, "wb").write(png)

if __name__ == "__main__":
    scale = int(sys.argv[2]) if len(sys.argv) > 2 else 2
    rgb = bytearray(240 * 240 * 3)
    rows, t0 = {}, time.time()
    for y0 in range(0, 240, 2):                                       # 2 lignes par échange (file USB de la pédale : 2 Ko)
        msgs = b"".join(b"\xF0\x7D\x42\x58\x17" + bytes([y & 0x7F, y >> 7]) + b"\xF7" for y in range(y0, y0 + 2))
        got = bb_tool.midi_exchange(msgs, wait=0.25, port="BlackBox Custom")
        for raw in got:
            for part in raw.split(b"\xF7"):
                k = part.find(b"\xF0\x7D\x42\x58\x17")
                if k < 0: continue
                p = part[k + 5:]
                y = p[0] | p[1] << 7
                d = unpack7(p[2:])
                if len(d) >= 480: rows[y] = d[:480]
    for y, d in rows.items():
        for x in range(240):
            c = d[2 * x] << 8 | d[2 * x + 1]
            r, g, b = (c >> 11) & 31, (c >> 5) & 63, c & 31
            rgb[(y * 240 + x) * 3:(y * 240 + x) * 3 + 3] = bytes([r << 3 | r >> 2, g << 2 | g >> 4, b << 3 | b >> 2])
    write_png(sys.argv[1], 240, 240, rgb, scale)
    print(f"{len(rows)}/240 lignes capturées en {time.time() - t0:.1f} s -> {sys.argv[1]}")
