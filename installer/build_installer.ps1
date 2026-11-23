# Construit l'installateur Windows autonome BlackBox_TBBR_Installer.exe.
# Prérequis : PyInstaller dans le venv du projet (.\venv\Scripts\python.exe -m pip install pyinstaller).
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $here '..\..')
$res = Join-Path $here 'resources'
New-Item -ItemType Directory -Force $res | Out-Null

Copy-Item (Join-Path $root 'blackbox\third_party\jl-uboot-tool\wl82loader.bin') (Join-Path $res 'wl82loader.bin') -Force   # MIT, kagaimiq/jl-uboot-tool
Copy-Item (Join-Path $root 'blackbox\fw_maison\reboot\reboot.bin') (Join-Path $res 'reboot.bin') -Force           # notre programme de redémarrage
Copy-Item (Join-Path $root 'blackbox\fw_maison\fw6\app.bin') (Join-Path $res 'app.bin') -Force
Copy-Item (Join-Path $root 'blackbox\fw_maison\fw6\cabs.bin') (Join-Path $res 'cabs.bin') -Force        # cabs d'usine (IR, gen_cabs.py)

$appHash = (Get-FileHash (Join-Path $res 'app.bin') -Algorithm SHA256).Hash.ToLower()
"firmware TBBR fw6`napp.bin sha256 $appHash`nconstruit le $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" |
    Set-Content (Join-Path $res 'VERSION.txt') -Encoding utf8

$py = Join-Path $root 'venv\Scripts\python.exe'
if (-not (Test-Path $py)) { throw "venv introuvable : $py" }

# Garde-fou : le JavaScript inline de l'interface doit être syntaxiquement valide (sinon page vide).
$uiHtml = Get-Content (Join-Path $res 'ui\index.html') -Raw
$uiScript = [regex]::Match($uiHtml, '(?s)<script>(.*)</script>')
if (-not $uiScript.Success) { throw "ui/index.html : script inline introuvable" }
$uiCheck = Join-Path $env:TEMP 'tbbr_installer_ui_check.js'
[IO.File]::WriteAllText($uiCheck, $uiScript.Groups[1].Value, (New-Object Text.UTF8Encoding($false)))
& node --check $uiCheck
if ($LASTEXITCODE) { throw "ui/index.html : syntaxe JavaScript invalide" }

Push-Location $here
try {
    & $py -m PyInstaller --noconfirm --clean --onefile --windowed `
        --name BlackBox_TBBR_Installer `
        --add-data "resources;resources" `
        --paths (Join-Path $root 'blackbox\scripts') `
        --hidden-import mkfw --hidden-import bb_tool `
        installer_gui.py
    if ($LASTEXITCODE) { throw "PyInstaller a échoué" }
    $exe = Join-Path $here 'dist\BlackBox_TBBR_Installer.exe'
    Copy-Item (Join-Path $here 'LISEZ-MOI.txt') (Join-Path $here 'dist\LISEZ-MOI.txt') -Force
    # paquet de mise à jour (≈ 200 Ko) : à glisser dans l'installateur, pas besoin de refournir l'exe
    & $py -I (Join-Path $here 'make_package.py') (Join-Path $res 'app.bin') (Join-Path $here 'dist') (Join-Path $res 'cabs.bin')
    if ($LASTEXITCODE) { throw "make_package a échoué" }
    # l'app Electron embarque cet installateur : on met à jour la copie servie par l'app
    Copy-Item $exe (Join-Path $root 'blackbox\interface\app\BlackBox_TBBR_Installer.exe') -Force
    "EXE : $exe"
    "copie app : blackbox\interface\app\BlackBox_TBBR_Installer.exe"
    (Get-FileHash $exe -Algorithm SHA256).Hash.ToLower() + "  " + (Get-Item $exe).Length + " octets"
} finally {
    Pop-Location
}
