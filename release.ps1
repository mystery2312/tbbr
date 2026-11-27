# release.ps1 : publie une nouvelle version sur GitHub (code + release + site).
# Avant : changer FW_VERSION dans fw_maison\fw6\main.c ("TBBR fw6 x.y") et "version" dans electron\package.json ("x.y.0").
# Usage : powershell -ExecutionPolicy Bypass -File blackbox\release.ps1 [-NoBuild] [-Notes "texte"]
param([switch]$NoBuild, [string]$Notes = "")
$ErrorActionPreference = 'Continue'      # PowerShell 5.1 : les messages des outils sur stderr ne doivent pas être fatals ; codes de retour vérifiés
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$env:Path = "$env:LOCALAPPDATA\Programs\MinGit\cmd;$env:LOCALAPPDATA\Programs\gh\bin;$env:Path"
$repo = 'mystery2312/tbbr'
Push-Location $here
try {
    $ver = (Get-Content electron\package.json -Raw | ConvertFrom-Json).version
    if ($ver -match '-beta') { throw "version beta : utiliser beta.ps1, pas release.ps1" }
    $fw = ([regex]::Match((Get-Content fw_maison\fw6\main.c -Raw), '#define FW_VERSION "TBBR (fw\d+) (\d+\.\d+)"')).Groups
    if (-not $fw[0].Success) { throw "FW_VERSION introuvable dans main.c" }
    $tag = "v$ver"; $pkg = "TBBR_$($fw[1].Value)_$($fw[2].Value).tbbr"
    $tags = gh release list --repo $repo --limit 100 --json tagName --jq '.[].tagName'
    if ($LASTEXITCODE) { throw "gh release list a échoué (connexion GitHub ?)" }
    if ($tags -contains $tag) { throw "la release $tag existe déjà : changer la version dans electron\package.json" }
    if (-not $NoBuild) { powershell -ExecutionPolicy Bypass -File .\build_all.ps1; if ($LASTEXITCODE) { throw "build_all" } }
    # tests de bout en bout (firmware émulé, app web, app de bureau, APK, ensemble) : rien n'est publié s'ils échouent
    powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1; if ($LASTEXITCODE) { throw "tests de bout en bout en échec : publication annulée" }
    $app = "electron\dist\BlackBox_TBBR_App_$ver.exe"
    $apk = 'android\dist\TBBR_Android.apk'
    foreach ($f in $app, 'installer\dist\BlackBox_TBBR_Installer.exe', "installer\dist\$pkg", $apk) { if (-not (Test-Path $f)) { throw "fichier absent : $f" } }
    # contrôle : rien de privé ne doit être ajouté (liste blanche .gitignore)
    git add -A
    $bad = git diff --cached --name-only | Where-Object { $_ -match 'save\.md|backup|\.am[23]Data$|\.nam$' }
    if ($bad) { git reset -q; throw "fichiers suspects, publication annulée : $bad" }
    if (git diff --cached --name-only) { git commit -q -m "Version $ver ($($fw[1].Value) $($fw[2].Value))"; }
    git push -q origin main; if ($LASTEXITCODE) { throw "git push a échoué" }
    $tmp = Join-Path $env:TEMP "tbbr_release_$ver"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory $tmp | Out-Null
    Copy-Item $app (Join-Path $tmp 'BlackBox_TBBR_App.exe')                  # noms fixes : liens « latest/download » stables
    Copy-Item installer\dist\BlackBox_TBBR_Installer.exe, "installer\dist\$pkg", $apk $tmp
    $sums = Get-ChildItem $tmp | ForEach-Object { "{0}  {1}" -f (Get-FileHash $_.FullName).Hash.ToLower(), $_.Name }
    $body = "## TBBR $ver`n`n$Notes`n`n- **BlackBox_TBBR_App.exe** : app de bureau (éditeur + installateur). Les utilisateurs de l'app sont prévenus automatiquement.`n- **$pkg** : paquet de mise à jour du firmware ($($fw[1].Value) $($fw[2].Value)).`n- **BlackBox_TBBR_Installer.exe** : installateur seul.`n- **TBBR_Android.apk** : app Android (éditeur USB OTG).`n`n### SHA-256`n```````n$($sums -join "`n")`n``````"
    $nf = Join-Path $tmp 'notes.md'; [IO.File]::WriteAllText($nf, $body, (New-Object Text.UTF8Encoding($false)))
    node tools\release_manifest.js $tmp stable $nf; if ($LASTEXITCODE) { throw "manifeste de mise à jour" }   # TBBR_update.json : mises à jour auto (Windows, Android)
    gh release create $tag (Join-Path $tmp 'BlackBox_TBBR_App.exe') (Join-Path $tmp 'BlackBox_TBBR_Installer.exe') (Join-Path $tmp $pkg) (Join-Path $tmp 'TBBR_Android.apk') (Join-Path $tmp 'TBBR_update.json') --repo $repo --title "TBBR $ver" --notes-file $nf --target main --latest; if ($LASTEXITCODE) { throw "création de la release échouée" }
    "publié : https://github.com/$repo/releases/tag/$tag"
} finally { Pop-Location }
