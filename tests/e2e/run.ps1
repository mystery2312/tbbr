# run.ps1 : prépare et lance tous les tests de bout en bout.
# Usage : powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1 [-Only static|protocol|app]
# Prérequis : Node 20+, Microsoft Edge (ou Chrome), Visual Studio Build Tools (C++ x86) pour l'émulateur.
param([ValidateSet('', 'static', 'protocol', 'app')][string]$Only = '')
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
Push-Location $here
try {
    if (-not (Test-Path (Join-Path $here 'node_modules\playwright-core'))) { npm install --no-audit --no-fund; if ($LASTEXITCODE) { throw 'npm install' } }
    # l'émulateur est recompilé à chaque fois : il doit refléter le firmware actuel (proto.c, engine.c...)
    powershell -ExecutionPolicy Bypass -File (Join-Path $here 'emu\build.ps1'); if ($LASTEXITCODE) { throw 'émulateur' }
    $files = if ($Only) { @("$Only.test.js") } else { @('static.test.js', 'protocol.test.js', 'app.test.js') }
    node --test --test-reporter=spec --test-timeout=120000 @files
    if ($LASTEXITCODE) { throw "tests en échec" }
    'TOUS LES TESTS PASSENT'
} finally { Pop-Location }
