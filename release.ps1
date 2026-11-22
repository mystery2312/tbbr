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
    $fw = ([regex]::Match((Get-Content fw_maison\fw6\main.c -Raw), '#define FW_VERSION "TBBR (fw\d+) (\d+\.\d+)"')).Groups
    if (-not $fw[0].Success) { throw "FW_VERSION introuvable dans main.c" }
    $tag = "v$ver"; $pkg = "TBBR_$($fw[1].Value)_$($fw[2].Value).tbbr"
    $tags = gh release list --repo $repo --limit 100 --json tagName --jq '.[].tagName'
    if ($LASTEXITCODE) { throw "gh release list a échoué (connexion GitHub ?)" }
    if ($tags -contains $tag) { throw "la release $tag existe déjà : changer la version dans electron\package.json" }
    if (-not $NoBuild) { powershell -ExecutionPolicy Bypass -File .\build_all.ps1; if ($LASTEXITCODE) { throw "build_all" } }
    $app = "electron\dist\BlackBox_TBBR_App_$ver.exe"
    foreach ($f in $app, 'installer\dist\BlackBox_TBBR_Installer.exe', "installer\dist\$pkg") { if (-not (Test-Path $f)) { throw "fichier absent : $f" } }
    # contrôle : rien de privé ne doit être ajouté (liste blanche .gitignore)
    git add -A
    $bad = git diff --cached --name-only | Where-Object { $_ -match 'save\.md|backup|\.am[23]Data$|\.nam$|UltraRig|hwtest' }
    if ($bad) { git reset -q; throw "fichiers suspects, publication annulée : $bad" }
    if (git diff --cached --name-only) { git commit -q -m "Version $ver ($($fw[1].Value) $($fw[2].Value))"; }
    git push -q origin main; if ($LASTEXITCODE) { throw "git push a échoué" }
    $tmp = Join-Path $env:TEMP "tbbr_release_$ver"
    if (Test-Path $tmp) { Remove-Item $tmp -Recurse -Force }
    New-Item -ItemType Directory $tmp | Out-Null
    Copy-Item $app (Join-Path $tmp 'BlackBox_TBBR_App.exe')                  # noms fixes : liens « latest/download » stables
    Copy-Item installer\dist\BlackBox_TBBR_Installer.exe, "installer\dist\$pkg" $tmp
    $sums = Get-ChildItem $tmp | ForEach-Object { "{0}  {1}" -f (Get-FileHash $_.FullName).Hash.ToLower(), $_.Name }
    $body = "## TBBR $ver`n`n$Notes`n`n- **BlackBox_TBBR_App.exe** : app de bureau (éditeur + installateur). Les utilisateurs de l'app sont prévenus automatiquement.`n- **$pkg** : paquet de mise à jour du firmware ($($fw[1].Value) $($fw[2].Value)).`n- **BlackBox_TBBR_Installer.exe** : installateur seul.`n`n### SHA-256`n``````n$($sums -join "`n")`n``````"
    $nf = Join-Path $tmp 'notes.md'; [IO.File]::WriteAllText($nf, $body, (New-Object Text.UTF8Encoding($false)))
    gh release create $tag (Join-Path $tmp 'BlackBox_TBBR_App.exe') (Join-Path $tmp 'BlackBox_TBBR_Installer.exe') (Join-Path $tmp $pkg) --repo $repo --title "TBBR $ver" --notes-file $nf --target main --latest; if ($LASTEXITCODE) { throw "création de la release échouée" }
    "publié : https://github.com/$repo/releases/tag/$tag"
} finally { Pop-Location }
