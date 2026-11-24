# stage_assets.ps1 : copie l'éditeur (interface\app) dans les assets de l'APK, avec le pont WebMIDI Android et les polices.
# Utilisé par build_apk.ps1 et par les tests de bout en bout (tests\e2e\apk.test.js) : mêmes fichiers dans les deux cas.
# Usage : powershell -File android\stage_assets.ps1 [dossier de sortie]   (défaut : app\src\main\assets\app)
param([string]$Out = '')
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Resolve-Path (Join-Path $here '..')
function Fail($m) { Write-Host "ERREUR : $m"; exit 1 }
# 1. éditeur -> assets/app (+ pont WebMIDI android-midi.js, chargé avant les scripts de l'éditeur)
$src = Join-Path $repo 'interface\app'
python -I (Join-Path $src 'make_static.py'); if ($LASTEXITCODE) { Fail "make_static" }
$assets = if ($Out) { $Out } else { Join-Path $here 'app\src\main\assets\app' }
if (Test-Path $assets) { Remove-Item $assets -Recurse -Force }
New-Item -ItemType Directory -Force (Join-Path $assets 'css'), (Join-Path $assets 'js'), (Join-Path $assets 'fonts') | Out-Null
foreach ($f in 'index.html', 'ecran.html', 'icon.svg', 'manifest.webmanifest') { Copy-Item (Join-Path $src $f) $assets }
Copy-Item (Join-Path $src 'css\*.css') (Join-Path $assets 'css')
Copy-Item (Join-Path $src 'js\*.js') (Join-Path $assets 'js')
Copy-Item (Join-Path $here 'web\android-midi.js') (Join-Path $assets 'js')
Copy-Item (Join-Path $repo 'interface\fonts\*') (Join-Path $assets 'fonts')
$u8 = New-Object Text.UTF8Encoding($false)
foreach ($page in 'index.html', 'ecran.html') {
    $p = Join-Path $assets $page
    $h = [IO.File]::ReadAllText($p)
    $i = $h.IndexOf('<script src=')
    if ($i -lt 0) { Fail "$page : pas de <script>" }
    $h = $h.Insert($i, "<script src=`"js/android-midi.js`"></script>`n")
    # polices embarquées (l'app doit marcher sans réseau)
    $h = $h.Replace('</head>', "<style>@font-face{font-family:Inter;font-weight:400;src:url(fonts/Inter-400.woff2) format('woff2')}@font-face{font-family:Inter;font-weight:500 700;src:url(fonts/Inter-700.ttf)}@font-face{font-family:Inter;font-weight:800 900;src:url(fonts/Inter-800.ttf)}@font-face{font-family:'JetBrains Mono';src:url(fonts/JetBrainsMono-700.ttf)}</style>`n</head>")
    [IO.File]::WriteAllText($p, $h, $u8)
}

