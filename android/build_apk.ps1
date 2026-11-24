# build_apk.ps1 : construit l'app Android signée (android\dist\TBBR_Android.apk) avec l'éditeur de interface\app.
# Prérequis : Android SDK (%LOCALAPPDATA%\Android\Sdk ou ANDROID_HOME), JDK 17+ (celui d'Android Studio par défaut).
# Clé de signature : HORS du dépôt (par défaut ..\..\keys\tbbr-release.jks + .pass), créée au premier lancement.
# À CONSERVER : sans elle, une nouvelle version ne pourra pas s'installer par-dessus l'ancienne.
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repo = Resolve-Path (Join-Path $here '..')
function Fail($m) { Write-Host "ERREUR : $m"; exit 1 }

if (-not $env:JAVA_HOME) { $jbr = 'C:\Program Files\Android\Android Studio\jbr'; if (Test-Path $jbr) { $env:JAVA_HOME = $jbr } }
if (-not $env:ANDROID_HOME) { $env:ANDROID_HOME = Join-Path $env:LOCALAPPDATA 'Android\Sdk' }
if (-not (Test-Path (Join-Path $env:JAVA_HOME 'bin\java.exe'))) { Fail "JDK introuvable (JAVA_HOME)" }
if (-not (Test-Path $env:ANDROID_HOME)) { Fail "Android SDK introuvable (ANDROID_HOME)" }
"sdk.dir=$($env:ANDROID_HOME -replace '\\', '/')" | Set-Content (Join-Path $here 'local.properties') -Encoding ascii

# 1. éditeur -> assets/app (+ pont WebMIDI android-midi.js, chargé avant les scripts de l'éditeur)
$src = Join-Path $repo 'interface\app'
python -I (Join-Path $src 'make_static.py'); if ($LASTEXITCODE) { Fail "make_static" }
$assets = Join-Path $here 'app\src\main\assets\app'
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

# 2. icône
$res = Join-Path $here 'app\src\main\res\mipmap-xxxhdpi'
New-Item -ItemType Directory -Force $res | Out-Null
Copy-Item (Join-Path $repo 'electron\build\icon.png') (Join-Path $res 'ic_launcher.png') -Force

# 3. version = celle de l'app de bureau ; clé de signature
$ver = (Get-Content (Join-Path $repo 'electron\package.json') -Raw | ConvertFrom-Json).version
$core = ($ver -split '-')[0]                                            # 0.9.5-beta.1 -> versionCode 905
$n = $core.Split('.') | ForEach-Object { [int]$_ }
$env:TBBR_VERSION_NAME = $ver
$env:TBBR_VERSION_CODE = [string]($n[0] * 10000 + $n[1] * 100 + $n[2])
$keys = if ($env:TBBR_KEYS) { $env:TBBR_KEYS } else { Join-Path $repo '..\keys' }
$ks = Join-Path $keys 'tbbr-release.jks'; $pf = Join-Path $keys 'tbbr-release.pass'
if (-not (Test-Path $ks)) {
    New-Item -ItemType Directory -Force $keys | Out-Null
    $pass = -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 28 | ForEach-Object { [char]$_ })
    [IO.File]::WriteAllText($pf, $pass, $u8)
    & (Join-Path $env:JAVA_HOME 'bin\keytool.exe') -genkeypair -v -keystore $ks -alias tbbr -keyalg RSA -keysize 3072 -validity 18250 -storepass $pass -keypass $pass -dname "CN=TBBR, O=TBBR"
    if ($LASTEXITCODE) { Fail "keytool" }
    "clé de signature créée : $ks (À SAUVEGARDER, ne jamais publier)"
}
$env:TBBR_KEYSTORE = (Resolve-Path $ks).Path
$env:TBBR_KEYSTORE_PASS = ([IO.File]::ReadAllText($pf)).Trim()

# 4. compilation
Push-Location $here
try {
    $gw = Join-Path $here 'gradlew.bat'
    if (Test-Path $gw) { & $gw --no-daemon assembleRelease }
    else {
        $g = Get-ChildItem (Join-Path $env:USERPROFILE '.gradle\wrapper\dists') -Recurse -Filter gradle.bat -ErrorAction SilentlyContinue | Select-Object -First 1
        if (-not $g) { Fail "Gradle introuvable (installe Android Studio ou ajoute gradlew)" }
        & $g.FullName --no-daemon assembleRelease
    }
    if ($LASTEXITCODE) { Fail "gradle assembleRelease" }
    $apk = Join-Path $here 'app\build\outputs\apk\release\app-release.apk'
    if (-not (Test-Path $apk)) { Fail "APK absent" }
    New-Item -ItemType Directory -Force (Join-Path $here 'dist') | Out-Null
    $out = Join-Path $here 'dist\TBBR_Android.apk'
    Copy-Item $apk $out -Force
    "APK : $out ($((Get-Item $out).Length) octets, version $ver / $env:TBBR_VERSION_CODE)"
    (Get-FileHash $out).Hash.ToLower()
} finally { Pop-Location }
