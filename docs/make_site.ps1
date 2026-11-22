# make_site.ps1 : copie l'éditeur web (interface\app) dans docs\app pour GitHub Pages.
# À lancer avant chaque commit de release (build_all.ps1 le fait).
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Resolve-Path (Join-Path $here '..\interface\app')
$dst = Join-Path $here 'app'
python -I (Join-Path $src 'make_static.py'); if ($LASTEXITCODE) { throw "make_static" }   # ?v=<date> à jour (anti-cache)
if (Test-Path $dst) { Remove-Item $dst -Recurse -Force }
New-Item -ItemType Directory -Force (Join-Path $dst 'css'), (Join-Path $dst 'js') | Out-Null
foreach ($f in 'index.html', 'ecran.html', 'icon.svg', 'manifest.webmanifest') { Copy-Item (Join-Path $src $f) (Join-Path $dst $f) }
Copy-Item (Join-Path $src 'css\*.css') (Join-Path $dst 'css')
Copy-Item (Join-Path $src 'js\*.js') (Join-Path $dst 'js')
New-Item -ItemType File -Force (Join-Path $here '.nojekyll') | Out-Null       # servir les fichiers tels quels
"site : $dst"
