# IR de baffle d'usine

Sources des 11 cabs intégrés à TBBR (blocs « 4x12 V30 » et « Combo »). `fw_maison/fw6/gen_cabs.py` les tronque, les normalise et les range dans la zone flash des cabs d'usine (0xF3000).

## Jester's Brutal Pack 1.0 — `jester-brutal/` — **CC0 1.0 (domaine public)**

Auteur : Bastian Karschewski, Jester Dyne Productions (https://jester-dyne-productions.com). Captures réelles d'un Behringer BG412S modifié (haut-parleurs du haut), fichiers 48 kHz. Licence indiquée dans le manuel du pack : « LICENSED 2022 UNDER: CC0 … distribute, remix, adapt … with no conditions ». Renommés ici (noms d'origine entre parenthèses) :

| Fichier | Haut-parleur | Micro | Nom d'origine |
|---|---|---|---|
| `v30-sm57-a.wav` | Celestion Vintage 30 | SM57 | 1 « Cookie Monster » |
| `v30-sm57-b.wav` | Celestion Vintage 30 | SM57 | 12 « World Collider » |
| `v30-pdmic75.wav` | Celestion Vintage 30 | Pyle PDMIC75 | 9 |
| `g12f-v30-e606-sm57.wav` | Rockdriver Jr. (G12F-60) + Vintage 30 | e606 + SM57 | 8 « Big Bubba » |

## Darwin's Cat, Orbit Guitar Cab Builder — `darwinscat-orbit/` — **CC BY 4.0**

IR: Darwin's Cat, darwinscat.com — https://darwinscat.com/felitronics/ir/guitar-cab-free-irs (pack 1.1, série « typical », 48 kHz). Baffles **synthétisés** (valeurs typiques d'une classe de baffle, pas la mesure d'un baffle précis), SM57 + ruban. Licence : `darwinscat-orbit/LICENSE.txt`, https://creativecommons.org/licenses/by/4.0/. **Modifications** : tronquées à 1 024 points avec fondu de sortie et normalisées en niveau par `gen_cabs.py`.

Fichiers : `4x12-closed.wav`, `2x12-open.wav`, `2x12-closed.wav`, `2x12-half.wav`, `1x12-open.wav`, `1x12-closed.wav`, `4x10-open.wav`.
