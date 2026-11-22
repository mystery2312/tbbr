# Reconstruit tout : firmware fw6 -> installateur -> application Electron portable.
# Usage : powershell -ExecutionPolicy Bypass -File blackbox\build_all.ps1
$ErrorActionPreference = 'Stop'
$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$fw = Join-Path $root 'blackbox\fw_maison\fw6'
$inst = Join-Path $root 'blackbox\installer'
$elec = Join-Path $root 'blackbox\electron'

Write-Host "=== 1/3 firmware fw6 ==="
Push-Location $fw
try { powershell -ExecutionPolicy Bypass -File .\build.ps1; if ($LASTEXITCODE) { throw "firmware" } } finally { Pop-Location }

Write-Host "=== 2/3 installateur firmware ==="
Push-Location $inst
try { powershell -ExecutionPolicy Bypass -File .\build_installer.ps1; if ($LASTEXITCODE) { throw "installateur" } } finally { Pop-Location }

Write-Host "=== 3/3 application Electron ==="
Push-Location $elec
try {
    $env:CSC_IDENTITY_AUTO_DISCOVERY = 'false'
    cmd /c "npm run dist"; if ($LASTEXITCODE) { throw "electron" }
} finally { Pop-Location }

$appExe = Join-Path $elec 'dist\BlackBox_TBBR_App_1.0.0.exe'
Write-Host ""
Write-Host "Firmware   : $fw\fw_flash_1MiB.bin"
Write-Host "Installateur : $inst\dist\BlackBox_TBBR_Installer.exe"
Write-Host "App Electron : $appExe"
if (Test-Path $appExe) {
    "app sha256 : " + (Get-FileHash $appExe -Algorithm SHA256).Hash.ToLower()
    "app taille : " + (Get-Item $appExe).Length + " octets"
}
