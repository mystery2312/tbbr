"""patch_markers.py <entrée.ll> <sortie.ll> : insère des marqueurs de diagnostic dans le pilote flash vm_sfc (IR LLVM).
Chaque marqueur écrit un code dans RB[18] (0x1C70048) ; après un blocage relancé par le chien de garde, la RAM est conservée
et le dernier code dit où la puce s'est arrêtée. Codes : 0xF0FF + étape (voir MARKS)."""
import re, sys
ADDR = 0x1C70048
MARKS = [  # (fonction, motif de la ligne APRÈS laquelle insérer ; "ENTRY" = début, "RET" = avant chaque ret), code
    ("enter_spi_code", "ENTRY", 0x101), ("enter_spi_code", r"call i32 @os_mutex_pend", 0x102),
    ("enter_spi_code", r"store volatile i8 1, i8\* @sfc_is_busy", 0x103), ("enter_spi_code", r"^; <label>:14:", 0x104),
    ("enter_spi_code", "RET", 0x105),
    ("cpu_enter_sfc_critical", "ENTRY", 0x201), ("cpu_enter_sfc_critical", "RET", 0x202),
    ("exit_continue_mode", "ENTRY", 0x301), ("exit_continue_mode", "RET", 0x302),
    ("read_flash_id", "ENTRY", 0x401), ("read_flash_id", "RET", 0x402),
    ("exit_spi_code", "ENTRY", 0x501), ("exit_spi_code", r"or i32 %9, 32", 0x502), ("exit_spi_code", r"^; <label>:14:", 0x503),
    ("exit_spi_code", "RET", 0x504),
    ("cpu_exit_sfc_critical", "ENTRY", 0x601), ("cpu_exit_sfc_critical", "RET", 0x602),
    ("norflash_wait_ok", "ENTRY", 0x701), ("norflash_wait_ok", "RET", 0x702),
    ("norflash_init", "ENTRY", 0x801), ("norflash_init", r"call void @flash_write_protect_init", 0x802), ("norflash_init", "RET", 0x803),
    ("flash_write_protect_init", "ENTRY", 0x901), ("flash_write_protect_init", "RET", 0x902),
]
raw = open(sys.argv[1], encoding="utf-8").read()
# flash_addr2cpu_addr : correspondance fixe de notre firmware (XIP : cpu = 0x2000000 + flash - 0x4000) au lieu de flash_info[7],
# que seul l'ioctl 205 remplit — et cet ioctl reprogramme aussi la fenêtre de déchiffrement du SFC (casse l'exécution en flash).
raw, k = re.subn(r"(define i32 @flash_addr2cpu_addr\(i32\)[^\n]*\{\n)(.*?)(\n\})",
                 lambda m: m.group(1) + "  %2 = add i32 %0, 33538048\n  ret i32 %2" + m.group(3), raw, count=1, flags=re.S)
if k != 1: raise SystemExit("flash_addr2cpu_addr introuvable")
src = raw.split("\n")
out, fn, n = [], None, 0
def mark(code): return f"  store volatile i32 {code}, i32* inttoptr (i32 {ADDR} to i32*), align 8"
for line in src:
    m = re.match(r"^define .*@([\w\.]+)\(", line)
    if m:
        fn = m.group(1); out.append(line)
        for f, pat, code in MARKS:
            if f == fn and pat == "ENTRY": pending_entry = code; break
        else: pending_entry = None
        continue
    if line == "}": fn = None
    if fn and pending_entry is not None and (re.match(r"^\s+%|^\s+(store|call|tail|br|ret|switch)", line)):
        out.append(mark(pending_entry)); n += 1; pending_entry = None
    if fn and re.match(r"^\s+ret\b", line):
        for f, pat, code in MARKS:
            if f == fn and pat == "RET": out.append(mark(code)); n += 1
    out.append(line)
    if fn:
        for f, pat, code in MARKS:
            if f == fn and pat not in ("ENTRY", "RET") and re.search(pat, line): out.append(mark(code)); n += 1
open(sys.argv[2], "w", encoding="utf-8").write("\n".join(out))
print(f"{n} marqueurs insérés")
