# build.ps1 : compile l'émulateur de pédale (code réel du firmware fw6 + host.c) avec MSVC x86.
# Usage : powershell -ExecutionPolicy Bypass -File tests\e2e\emu\build.ps1
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$fw = Resolve-Path (Join-Path $here '..\..\..\fw_maison\fw6')
$out = Join-Path $here 'out'
New-Item -ItemType Directory -Force $out | Out-Null

$vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) { throw "Visual Studio Build Tools introuvables (vswhere)" }
$vs = & $vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath
if (-not $vs) { throw "outils C++ MSVC introuvables" }
$vcvars = Join-Path $vs 'VC\Auxiliary\Build\vcvarsall.bat'

# version du firmware lue dans main.c (même chaîne que l'INFO de la pédale)
$m = Select-String -Path (Join-Path $fw 'main.c') -Pattern '#define FW_VERSION "([^"]+)"'
if (-not $m) { throw "FW_VERSION introuvable dans main.c" }
$ver = $m.Matches[0].Groups[1].Value

# fichiers générés par build.ps1 du firmware (catalog.h, factory_presets.h, tables.h, cabs.bin) : régénérer s'ils manquent
foreach ($g in 'catalog.h', 'factory_presets.h', 'tables.h') { if (-not (Test-Path (Join-Path $fw $g))) { throw "$g manquant : lancer d'abord fw_maison\fw6\build.ps1" } }

$srcs = @('proto.c', 'engine.c', 'models.c', 'circuit.c') | ForEach-Object { Join-Path $fw $_ }
$srcs += (Join-Path $here 'host.c'), (Join-Path $here 'stubs.c')
$cl = "cl /nologo /O2 /W3 /MT /FI`"$here\host_compat.h`" /I`"$fw`" /DTBBR_FW_VERSION=`"\`"$ver\`"`" /Fo`"$out\\`" /Fe`"$out\pedal_emu.exe`" " +
      (($srcs | ForEach-Object { "`"$_`"" }) -join ' ') + " /link /DYNAMICBASE:NO /BASE:0x10000000 /FIXED:NO"
$cmd = "`"$vcvars`" x86 >nul && $cl"
cmd /c $cmd
if ($LASTEXITCODE) { throw "compilation de l'émulateur : échec" }
Copy-Item (Join-Path $fw 'cabs.bin') (Join-Path $out 'cabs.bin') -Force
"pedal_emu.exe OK ($ver)"
