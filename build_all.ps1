# Reconstruit tout : firmware fw6 -> installateur -> application Electron portable -> APK Android -> site.
# Usage : powershell -ExecutionPolicy Bypass -File blackbox\build_all.ps1
# Prérequis Android : Android SDK + JDK 17 (voir android\build_apk.ps1).
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$fw = Join-Path $root 'blackbox\fw_maison\fw6'
$inst = Join-Path $root 'blackbox\installer'
$elec = Join-Path $root 'blackbox\electron'

Write-Host "=== 1/4 firmware fw6 ==="
Push-Location $fw
try { powershell -ExecutionPolicy Bypass -File .\build.ps1; if ($LASTEXITCODE) { throw "firmware" } } finally { Pop-Location }

Write-Host "=== 2/4 installateur firmware ==="
Push-Location $inst
try { powershell -ExecutionPolicy Bypass -File .\build_installer.ps1; if ($LASTEXITCODE) { throw "installateur" } } finally { Pop-Location }

Write-Host "=== 3/4 application Electron ==="
Push-Location $elec
try {
    $env:CSC_IDENTITY_AUTO_DISCOVERY = 'false'
    cmd /c "npm run dist"; if ($LASTEXITCODE) { throw "electron" }
} finally { Pop-Location }

Write-Host "=== 4/4 application Android (APK) ==="
Push-Location (Join-Path $root 'blackbox\android')
try { powershell -ExecutionPolicy Bypass -File .\build_apk.ps1; if ($LASTEXITCODE) { throw "android" } } finally { Pop-Location }

Write-Host "=== site GitHub Pages (docs\sim) ==="
powershell -ExecutionPolicy Bypass -File (Join-Path $root 'blackbox\docs\make_site.ps1')
$ver = (Get-Content (Join-Path $elec 'package.json') -Raw | ConvertFrom-Json).version
$appExe = Join-Path $elec ("dist\BlackBox_TBBR_App_$ver.exe")
Write-Host ""
Write-Host "Firmware   : $fw\fw_flash_1MiB.bin"
Write-Host "Installateur : $inst\dist\BlackBox_TBBR_Installer.exe"
Write-Host "App Electron : $appExe"
Write-Host "APK Android  : $(Join-Path $root 'blackbox\android\dist\TBBR_Android.apk')"
if (Test-Path $appExe) {
    "app sha256 : " + (Get-FileHash $appExe -Algorithm SHA256).Hash.ToLower()
    "app taille : " + (Get-Item $appExe).Length + " octets"
}
