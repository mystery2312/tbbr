# build.ps1 : compile le firmware TBBR (app.bin) et, si une sauvegarde de référence est indiquée, l'image flash 1 Mio de développement.
# Usage : powershell -File blackbox\fw_maison\fw6\build.ps1   (variables facultatives : JL_PI32, TBBR_BACKUP)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $here '..\..\..')
# chaîne de compilation JieLi (clang pi32v2) : variable JL_PI32, sinon l'emplacement local du projet
$jl = if ($env:JL_PI32) { $env:JL_PI32 } else { Join-Path $root 'blackbox\tools_ext\jl_toolchain\extracted\C$\JL\pi32' }
$b = Join-Path $jl 'bin'
# image flash complète (développement) : sauvegarde de référence TBBR_BACKUP, sinon la 1re sauvegarde V19 locale (non versionnée)
$ref = Join-Path $root 'blackbox\backups\reference.txt'                    # fichier local, non versionné : chemin de la sauvegarde
$bk = if ($env:TBBR_BACKUP) { $env:TBBR_BACKUP } elseif (Test-Path $ref) { Join-Path $root ((Get-Content $ref -TotalCount 1).Trim()) } else { $null }
Push-Location $here
try {
    Remove-Item *.o, *.elf, app.bin, data.bin -ErrorAction SilentlyContinue
    $cf = '--target=pi32v2', '-O2', '-ffreestanding', '-fno-builtin'
    node (Join-Path $here 'gen_catalog.js'); if ($LASTEXITCODE) { throw "gen_catalog" }
    node (Join-Path $here 'gen_factory_presets.js'); if ($LASTEXITCODE) { throw "gen_factory_presets" }
    python -I (Join-Path $here 'gen_tables.py'); if ($LASTEXITCODE) { throw "gen_tables" }
    python -I (Join-Path $root 'blackbox\interface\assets\gen_assets.py') (Join-Path $here 'assets.h'); if ($LASTEXITCODE) { throw "gen_assets" }
    python -I (Join-Path $here 'gen_cabs.py') (Join-Path $here 'cabs.bin'); if ($LASTEXITCODE) { throw "gen_cabs" }   # cabs d'usine (IR)
    $srcs = 'main', 'usb_midi', 'usb_glue', 'storage', 'engine', 'proto', 'gfx', 'ui', 'core1', 'a2l', 'amx', 'clock'
    python -I (Join-Path $here 'patch_markers.py') sdk\vm_sfc.ll sdk\vm_sfc_mark.ll; if ($LASTEXITCODE) { throw "patch_markers" }
    $sdk = 'usb', 'usb_setup', 'usb_phy', 'vm_sfc_mark'                  # pilote flash avec marqueurs de diagnostic (RB[18])
    foreach ($c in $srcs) { & "$b\clang.exe" @cf -c "$c.c" -o "$c.o"; if ($LASTEXITCODE) { throw "compilation $c.c" } }
    # NAM : instructions flottantes matérielles de l'AC791N (fprev1, utilisées aussi par le firmware d'origine)
    & "$b\clang.exe" @cf -Xclang -target-feature -Xclang +fprev1 -c nam.c -o nam.o; if ($LASTEXITCODE) { throw "compilation nam.c" }
    $srcs += 'nam'
    & "$b\clang.exe" @cf -Xclang -target-feature -Xclang +fprev1 -c tuner.c -o tuner.o; if ($LASTEXITCODE) { throw "compilation tuner.c" }
    $srcs += 'tuner'
    foreach ($c in 'circuit', 'models') {                            # pédales / amplis modélisés : flottant matériel
        & "$b\clang.exe" @cf -Xclang -target-feature -Xclang +fprev1 -c "$c.c" -o "$c.o"; if ($LASTEXITCODE) { throw "compilation $c.c" }
        $srcs += $c
    }
    # AMX (captures M-VAVE) : même FPU matérielle
    & "$b\clang.exe" @cf -Xclang -target-feature -Xclang +fprev1 -c amx.c -o amx.o; if ($LASTEXITCODE) { throw "compilation amx.c" }
    foreach ($m in $sdk) { & "$b\clang.exe" --target=pi32v2 -O2 -c "sdk\$m.ll" -o "sdk_$m.o"; if ($LASTEXITCODE) { throw "compilation $m.ll" } }
    & "$b\clang.exe" --target=pi32v2 -c start.S -o start.o
    & "$b\clang.exe" --target=pi32v2 -c cpu1.S -o cpu1.o; if ($LASTEXITCODE) { throw "compilation cpu1.S" }
    & "$b\clang.exe" --target=pi32v2 -c amx_fir.S -o amx_fir.o; if ($LASTEXITCODE) { throw "compilation amx_fir.S" }
    python -I (Join-Path $here 'gen_nam_asm.py'); if ($LASTEXITCODE) { throw "gen_nam_asm" }
    & "$b\clang.exe" --target=pi32v2 -c nam_asm.S -o nam_asm.o; if ($LASTEXITCODE) { throw "compilation nam_asm.S" }
    & "$b\clang.exe" --target=pi32v2 -c isa_probe.S -o isa_probe.o; if ($LASTEXITCODE) { throw "compilation isa_probe.S" }
    & "$b\clang.exe" --target=pi32v2 -c bench.S -o bench.o; if ($LASTEXITCODE) { throw "compilation bench.S" }
    $objs = @('start.o', 'cpu1.o', 'amx_fir.o', 'nam_asm.o', 'isa_probe.o', 'bench.o') + ($srcs | % { "$_.o" }) + ($sdk | % { "sdk_$_.o" })
    $lib = Join-Path $jl 'pi32v2-lib\r1'
    & "$b\pi32v2-ld.exe" -T link.ld --gc-sections @objs "$lib\libm.a" "$lib\libcompiler-rt.a" -o fw.elf
    if ($LASTEXITCODE) { throw "édition des liens" }
    $u = & "$b\llvm-nm.exe" -u fw.elf
    if ($u) { throw "symboles non résolus : $u" }
    & "$b\llvm-objcopy.exe" -O binary -j .text fw.elf app.bin
    & "$b\llvm-objcopy.exe" -O binary -j .data fw.elf data.bin
    if ((Test-Path data.bin) -and (Get-Item data.bin).Length -gt 0) {
        $a = [IO.File]::ReadAllBytes("$here\app.bin"); $d = [IO.File]::ReadAllBytes("$here\data.bin")
        [IO.File]::WriteAllBytes("$here\app.bin", [byte[]]($a + $d))     # .data chargée juste après .text (LMA = _data_lma)
    }
    "app.bin : $((Get-Item app.bin).Length) octets"
    if ($bk) { python -I (Join-Path $root 'blackbox\scripts\mkfw.py') $bk app.bin fw_flash_1MiB.bin cabs.bin }
    else { 'pas de sauvegarde de référence : image flash complète non construite (app.bin suffit pour l''installateur)' }
} finally { Pop-Location }
