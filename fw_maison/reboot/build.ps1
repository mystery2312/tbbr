# build.ps1 : compile reboot.bin (programme de redémarrage en RAM, chargé à 0x1C20000)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $here '..\..\..')
$b = Join-Path $root 'blackbox\tools_ext\jl_toolchain\extracted\C$\JL\pi32\bin'
Push-Location $here
try {
    'SECTIONS { . = 0x1C20000; .text : { *(.text.start) *(.text*) *(.rodata*) } /DISCARD/ : { *(.data*) *(.bss*) *(.comment) } }' | Set-Content link.ld -Encoding ascii
    & "$b\clang.exe" --target=pi32v2 -O2 -ffreestanding -fno-builtin -c reboot.c -o reboot.o; if ($LASTEXITCODE) { throw "clang" }
    & "$b\pi32v2-ld.exe" -T link.ld reboot.o -o reboot.elf; if ($LASTEXITCODE) { throw "ld" }
    & "$b\llvm-objcopy.exe" -O binary -j .text reboot.elf reboot.bin; if ($LASTEXITCODE) { throw "objcopy" }
    & "$b\llvm-objdump.exe" -d reboot.elf
    "reboot.bin : " + (Get-Item reboot.bin).Length + " o, sha256 " + (Get-FileHash reboot.bin).Hash.ToLower()
} finally { Pop-Location }
