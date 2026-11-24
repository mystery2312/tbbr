# beta.ps1 : construit et publie une version beta sur le depot prive tbbr-beta.
# Le depot public mystery2312/tbbr n'est jamais touche par ce script.
# Usage : powershell -ExecutionPolicy Bypass -File blackbox\beta.ps1 [-NoBuild] [-NoPush] [-Notes "texte"]
# Avant : mettre une version beta dans electron\package.json (ex. "0.9.5-beta.1")
#         et, si le firmware change, FW_VERSION dans fw_maison\fw6\main.c.
param(
    [switch]$NoBuild,
    [switch]$NoPush,
    [string]$Notes = ""
)
$ErrorActionPreference = 'Continue'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:Path = "$env:LOCALAPPDATA\Programs\MinGit\cmd;$env:LOCALAPPDATA\Programs\gh\bin;$env:Path"
$repo = 'mystery2312/tbbr-beta'
Push-Location $here
try {
    $ver = (Get-Content electron\package.json -Raw | ConvertFrom-Json).version
    if ($ver -notmatch '-beta') { throw "version beta attendue dans electron\package.json (ex. 0.9.5-beta.1), trouve : $ver" }
    $fw = ([regex]::Match((Get-Content fw_maison\fw6\main.c -Raw), '#define FW_VERSION "TBBR (fw\d+) (\d+\.\d+)"')).Groups
    if (-not $fw[0].Success) { throw "FW_VERSION introuvable dans main.c" }
    $tag = "v$ver"; $pkg = "TBBR_$($fw[1].Value)_$($fw[2].Value).tbbr"

    $tags = gh release list --repo $repo --limit 100 --json tagName --jq '.[].tagName'
    if ($LASTEXITCODE) { throw "gh release list a echoue (connexion GitHub ?)" }
    if ($tags -contains $tag) { throw "la beta $tag existe deja : changer la version dans electron\package.json" }

    if (-not $NoBuild) {
        powershell -ExecutionPolicy Bypass -File .\build_all.ps1
        if ($LASTEXITCODE) { throw "build_all" }
    }

    $app = "electron\dist\BlackBox_TBBR_App_$ver.exe"
    $apk = 'android\dist\TBBR_Android.apk'
    foreach ($f in $app, 'installer\dist\BlackBox_TBBR_Installer.exe', "installer\dist\$pkg", $apk) {
        if (-not (Test-Path $f)) { throw "fichier absent : $f" }
    }

    # sauvegarde du code dans le depot beta (jamais dans le public)
    git add -A
    $bad = git diff --cached --name-only | Where-Object { $_ -match 'save\.md|backup|\.am[23]Data$|\.nam$' }
    if ($bad) { git reset -q; throw "fichiers suspects, publication beta annulee : $bad" }
    if (git diff --cached --name-only) { git commit -q -m "Beta $ver" }
    if (-not $NoPush) {
        git push beta HEAD:main
        if ($LASTEXITCODE) { throw "git push beta a echoue" }
    }

    $tmp = Join-Path $env:TEMP "tbbr_beta_$ver"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory $tmp | Out-Null
    Copy-Item $app (Join-Path $tmp 'BlackBox_TBBR_App.exe')
    Copy-Item installer\dist\BlackBox_TBBR_Installer.exe, "installer\dist\$pkg", $apk $tmp
    $sums = Get-ChildItem $tmp | ForEach-Object { "{0}  {1}" -f (Get-FileHash $_.FullName).Hash.ToLower(), $_.Name }
    $body = @(
        "## TBBR $ver - beta",
        "",
        "Version de test. Ne pas redistribuer comme version stable.",
        "",
        $Notes,
        "",
        "- **BlackBox_TBBR_App.exe** : application de bureau beta (canal beta; telechargement manuel tant que le depot est prive).",
        "- **$pkg** : paquet firmware $($fw[1].Value) $($fw[2].Value) pour l'installateur.",
        "- **BlackBox_TBBR_Installer.exe** : installateur autonome.",
        "- **TBBR_Android.apk** : application Android beta.",
        "",
        "### A tester avant promotion",
        "",
        "- [ ] Sauvegarde complete de la pedale avant flash.",
        "- [ ] Chargement des presets d'usine et des captures NAM / IR.",
        "- [ ] Bypass, changement de scene, sauvegarde d'un preset.",
        "- [ ] Effets modifies et charge CPU (pas de coupure ni de clic).",
        "- [ ] Mise a jour firmware depuis l'app beta.",
        "- [ ] Retour a la version stable possible.",
        "",
        "### SHA-256",
        "",
        '```',
        ($sums -join "`n"),
        '```'
    ) -join "`n"
    $nf = Join-Path $tmp 'notes.md'
    [IO.File]::WriteAllText($nf, $body, (New-Object Text.UTF8Encoding($false)))
    gh release create $tag (Join-Path $tmp 'BlackBox_TBBR_App.exe') (Join-Path $tmp 'BlackBox_TBBR_Installer.exe') (Join-Path $tmp $pkg) (Join-Path $tmp 'TBBR_Android.apk') `
        --repo $repo --title "TBBR $ver (beta)" --notes-file $nf --target main --prerelease
    if ($LASTEXITCODE) { throw "creation de la release beta echouee" }
    "beta publiee : https://github.com/$repo/releases/tag/$tag"
} finally { Pop-Location }
