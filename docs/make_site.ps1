# make_site.ps1 : prépare la simulation de façade du site GitHub Pages (docs\sim : ecran.html et ses scripts).
# L'éditeur n'est PAS publié sur le site : il s'utilise dans l'app de bureau (Electron) ou l'app Android.
# Lancé par build_all.ps1.
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$src = Resolve-Path (Join-Path $here '..\interface\app')
python -I (Join-Path $src 'make_static.py'); if ($LASTEXITCODE) { throw "make_static" }   # ?v=<date> à jour (anti-cache)
foreach ($old in 'app', 'sim') { $p = Join-Path $here $old; if (Test-Path $p) { Remove-Item $p -Recurse -Force } }
$dst = Join-Path $here 'sim'
New-Item -ItemType Directory -Force (Join-Path $dst 'css'), (Join-Path $dst 'js') | Out-Null
$html = [IO.File]::ReadAllText((Join-Path $src 'ecran.html'))
$html = [regex]::Replace($html, '\s*<a class="link" href="\./"[^>]*>[^<]*</a>', '')                   # pas de lien vers l'éditeur
[IO.File]::WriteAllText((Join-Path $dst 'ecran.html'), $html, (New-Object Text.UTF8Encoding($false)))
Copy-Item (Join-Path $src 'icon.svg') $dst
Copy-Item (Join-Path $src 'css\ecran.css') (Join-Path $dst 'css')
foreach ($f in 'data.js', 'i18n.js', 'ecran.js') { Copy-Item (Join-Path $src "js\$f") (Join-Path $dst 'js') }
New-Item -ItemType File -Force (Join-Path $here '.nojekyll') | Out-Null
"simulation : $dst"
