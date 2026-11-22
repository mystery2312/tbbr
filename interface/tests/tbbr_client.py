"""tbbr_client.py : client de test du protocole de l'app (trames A5 dans des SysEx F0 7D 42 58 70 ... F7, port « BlackBox Custom »).
Usage :
  python tbbr_client.py hello
  python tbbr_client.py preset <index d'usine>      (utilise make_compact.js)
  python tbbr_client.py bypass <lane> <col> <0|1>
  python tbbr_client.py param <lane> <col> <idx> <valeur>
  python tbbr_client.py scene <n>
  python tbbr_client.py meter                        (écoute les vu-mètres 2 s)
"""
import sys, os, json, struct, subprocess, time
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "..", "..", "scripts"))
import bb_tool

CMD = dict(HELLO=1, INFO=2, ACK=6, NAK=0x15, PRESET_SET=0x11, SCENE_SELECT=0x18, LEVEL=0x1A, BYPASS=0x23, PARAM=0x24, METER=0x60, BLOCK_SET=0x20)
NAME = {v: k for k, v in CMD.items()}

def frame(cmd, pl=b""):
    f = bytes([0xA5, cmd, len(pl) & 255, len(pl) >> 8]) + pl
    x = 0
    for b in f[1:]: x ^= b
    return f + bytes([x])
def pack7(b):
    out = bytearray()
    for i in range(0, len(b), 7):
        g = b[i:i + 7]; out.append(sum(((x >> 7) & 1) << k for k, x in enumerate(g))); out += bytes(x & 0x7F for x in g)
    return bytes(out)
def unpack7(s):
    out = bytearray(); i = 0
    while i < len(s):
        hi = s[i]; i += 1
        for k in range(7):
            if i >= len(s): break
            out.append((s[i] & 0x7F) | (((hi >> k) & 1) << 7)); i += 1
    return bytes(out)
def exchange(cmd, pl=b"", wait=0.8):
    msg = b"\xF0\x7D\x42\x58\x70" + pack7(frame(cmd, pl)) + b"\xF7"
    got = bb_tool.midi_exchange(msg, wait=wait, port="BlackBox Custom")
    frames = []
    for raw in got:
        for part in raw.split(b"\xF7"):
            k = part.find(b"\xF0\x7D\x42\x58\x70")
            if k < 0: continue
            f = unpack7(part[k + 5:])
            if len(f) >= 5 and f[0] == 0xA5:
                n = f[2] | f[3] << 8
                frames.append((f[1], f[4:4 + n]))
    return frames
def show(frames):
    for c, p in frames:
        if c == CMD["INFO"]: print("INFO", json.dumps(json.loads(p.decode()), ensure_ascii=False))
        elif c == CMD["METER"]: print(f"METER entrée={p[0]} sortie={p[1]}" + ("" if len(p) < 3 else f" batterie={p[2] if p[2] != 127 else '?'} %"))
        elif c in (CMD["ACK"], CMD["NAK"]): print(NAME[c], NAME.get(p[0], hex(p[0])))
        else: print(hex(c), p[:40])

if __name__ == "__main__":
    a = sys.argv[1:]
    if a[0] == "hello": show(exchange(CMD["HELLO"], b'{"app":"test","proto":1}', 1.2))
    elif a[0] == "preset":
        js = subprocess.check_output(["node", os.path.join(os.path.dirname(__file__), "make_compact.js")] + a[1:3])   # [index, de=vers]
        print(f"preset {a[1]} : {len(js)} octets JSON")
        show(exchange(CMD["PRESET_SET"], js, 1.5))
    elif a[0] == "bypass": show(exchange(CMD["BYPASS"], bytes([int(a[1]), int(a[2]), int(a[3])])))
    elif a[0] == "param": show(exchange(CMD["PARAM"], bytes([int(a[1]), int(a[2]), int(a[3])]) + struct.pack("<f", float(a[4]))))
    elif a[0] == "scene": show(exchange(CMD["SCENE_SELECT"], bytes([int(a[1])])))
    elif a[0] == "meter": show(exchange(CMD["HELLO"], b"{}", 2.0))
    elif a[0] == "ui":       # ui key <k> | turn <d> | press | hold | tuner | master <dB>
        act = {"key": 1, "turn": 2, "press": 3, "hold": 4, "tuner": 5, "master": 6, "fs": 7, "save": 8, "splash": 9}[a[1]]   # fs <0 gauche|1 droite> [1 = maintien]
        v = int(a[2]) if len(a) > 2 else 0
        v = v + 64 if act == 2 else (v + 60 if act == 6 else v)
        if act == 7: v = int(a[2]) + 2 * (int(a[3]) if len(a) > 3 else 0)
        bb_tool.midi_exchange(bytes([0xF0, 0x7D, 0x42, 0x58, 0x18, act, v & 0x7F, 0xF7]), wait=0.3, port="BlackBox Custom")
    elif a[0] == "save": show(exchange(0x12, bytes([int(a[1])]) + (a[2].encode() if len(a) > 2 else b""), 2.0))   # save <i> [nom]
    elif a[0] == "select": show(exchange(0x10, bytes([int(a[1])]), 1.5))
    elif a[0] in ("get", "list"):                         # get <i | 127 = état réel> | list : réponse en trames DATA (0x14)
        frames = exchange(0x13 if a[0] == "get" else 0x16, bytes([int(a[1])]) if a[0] == "get" else b"", 2.0)
        parts = {}
        for c, p in frames:
            if c == 0x14: parts[p[2]] = (p[3], p[4:])
            elif c != 0x60: print(NAME.get(c, hex(c)), p[:8])
        if parts:
            n = next(iter(parts.values()))[0]
            data = b"".join(parts[k][1] for k in sorted(parts))
            print(f"{len(parts)}/{n} morceaux, {len(data)} octets")
            print(data.decode("utf-8", "replace"))
    elif a[0] == "ir":       # ir <slot> : envoie une IR de test (impulsion décroissante, 2048 points) comme l'app
        slot = int(a[1]); x = [int(30000 * (0.995 ** i) * (1 if i % 2 == 0 else -1)) for i in range(2048)]
        show(exchange(0x40, json.dumps({"slot": slot, "name": "Test IR", "len": 2048, "rate": 48000, "fmt": "s16le"}).encode(), 1.5))
        for idx, i in enumerate(range(0, 2048, 240)):
            n = min(240, 2048 - i)
            exchange(0x41, bytes([slot, idx & 255, idx >> 8]) + struct.pack(f"<{n}h", *x[i:i + n]), 0.15)
        show(exchange(0x42, bytes([slot]), 1.5))
    elif a[0] == "nam":      # nam <slot> <fichier.nam> : envoie les poids du Lite comme l'app
        import zlib
        j = json.load(open(a[2]))
        sub = sorted(j["config"]["submodels"], key=lambda s: s["max_value"])[0]["model"]
        blob = struct.pack(f"<{len(sub['weights'])}f", *sub["weights"]); crc = zlib.crc32(blob) & 0xFFFFFFFF; slot = int(a[1])
        show(exchange(0x44, json.dumps({"slot": slot, "name": "A2 test", "a2": True, "sr": 48000, "cfgLen": 0, "nWeights": len(sub["weights"]), "size": len(blob), "crc": crc}).encode(), 1.5))
        for idx, i in enumerate(range(0, len(blob), 480)):
            exchange(0x45, bytes([slot, idx & 255, idx >> 8]) + blob[i:i + 480], 0.15)
        show(exchange(0x46, bytes([slot]) + struct.pack("<I", crc), 1.5))
    elif a[0] == "a2l":      # a2l <slot> <fichier.a2l1> : envoie un binaire A2L1 déjà converti
        import zlib
        blob = open(a[2], "rb").read(); crc = zlib.crc32(blob) & 0xFFFFFFFF; slot = int(a[1])
        show(exchange(0x44, json.dumps({"slot": slot, "name": "A2L1 test", "a2": True, "a2l": True, "sr": 48000, "cfgLen": 0, "nWeights": 0, "size": len(blob), "crc": crc}).encode(), 1.5))
        for idx, i in enumerate(range(0, len(blob), 480)):
            exchange(0x45, bytes([slot, idx & 255, idx >> 8]) + blob[i:i + 480], 0.15)
        show(exchange(0x46, bytes([slot]) + struct.pack("<I", crc), 1.5))
