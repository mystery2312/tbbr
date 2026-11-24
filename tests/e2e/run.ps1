# run.ps1 : prépare et lance tous les tests de bout en bout (firmware, app web, app de bureau, APK, ensemble).
# Usage : powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1 [-Only static|protocol|updater|app|desktop|apk|ensemble|packaged] [-NoAndroid] [-Packaged]
#   -Packaged : ajoute la mise à jour avec de vrais exe portables (2 builds electron-builder, ~6 min)
# Prérequis : Node 20+, Microsoft Edge, Visual Studio Build Tools (C++ x86), Electron installé (npm install dans electron\),
#             Android SDK + JDK 17 pour l'APK (sinon -NoAndroid : les tests APK et ensemble sont sautés).
param([ValidateSet('', 'static', 'protocol', 'updater', 'app', 'desktop', 'apk', 'ensemble', 'packaged')][string]$Only = '', [switch]$NoAndroid, [switch]$Packaged)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Resolve-Path (Join-Path $here '..\..')
Push-Location $here
try {
    if (-not (Test-Path (Join-Path $here 'node_modules\playwright-core'))) { npm install --no-audit --no-fund; if ($LASTEXITCODE) { throw 'npm install' } }
    # 1. émulateur de pédale : recompilé à chaque fois, il doit refléter le firmware actuel
    powershell -ExecutionPolicy Bypass -File (Join-Path $here 'emu\build.ps1'); if ($LASTEXITCODE) { throw 'émulateur' }
    # 2. APK de test (debug) avec les assets actuels + tests JVM de la mise à jour Android
    $needApk = -not $NoAndroid -and ($Only -in '', 'apk', 'ensemble')
    if ($needApk) {
        if (-not $env:JAVA_HOME) { $jbr = 'C:\Program Files\Android\Android Studio\jbr'; if (Test-Path $jbr) { $env:JAVA_HOME = $jbr } }
        if (-not $env:ANDROID_HOME) { $env:ANDROID_HOME = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
        $android = Join-Path $root 'android'
        powershell -ExecutionPolicy Bypass -File (Join-Path $android 'stage_assets.ps1'); if ($LASTEXITCODE) { throw 'assets Android' }
        Push-Location $android
        try {
            "sdk.dir=$($env:ANDROID_HOME -replace '\\', '/')" | Set-Content local.properties -Encoding ascii
            $ErrorActionPreference = 'Continue'
            & .\gradlew.bat --no-daemon -q testReleaseUnitTest assembleDebug
            if ($LASTEXITCODE) { throw 'APK de test / tests JVM' }
            $ErrorActionPreference = 'Stop'
        } finally { Pop-Location }
    }
    $all = 'static', 'protocol', 'updater', 'app', 'desktop', 'apk', 'ensemble'
    if ($Packaged -or $Only -eq 'packaged') { $env:E2E_PACKAGED = '1'; $all += 'packaged' }
    $sel = if ($Only) { @($Only) } elseif ($NoAndroid) { $all | Where-Object { $_ -notin 'apk', 'ensemble' } } else { $all }
    $files = @($sel | ForEach-Object { "$_.test.js" })
    node --test --test-reporter=spec --test-timeout=900000 --test-concurrency=1 @files
    if ($LASTEXITCODE) { throw "tests en échec" }
    'TOUS LES TESTS PASSENT'
} finally { Pop-Location }
