# Composants tiers

Le code de TBBR est publié sous **GPL-3.0** (voir `LICENSE`). Il inclut ou utilise les composants suivants, sous leur propre licence :

| Composant | Emplacement | Licence | Source |
|---|---|---|---|
| Pilotes USB et flash du SDK JieLi AC79 (IR LLVM extraite de `cpu.a`) | `fw_maison/fw6/sdk/*.ll` | Apache-2.0 (`fw_maison/fw6/sdk/LICENSE-JieLi-SDK-Apache-2.0.txt`) | Gitee `Jieli-Tech/fw-AC79_AIoT_SDK` |
| Recette de redémarrage `CORE_SYSTEM_RESET` (une écriture de registre) | `fw_maison/reboot/reboot.c` | Apache-2.0 (SDK JieLi, `cpu/wl82/p33.c`) | idem |
| `wl82loader.bin` (loader USB de la mask ROM WL82) et protocole SCSI/loader de `bb_tool.py` | `third_party/jl-uboot-tool/`, `scripts/bb_tool.py` | MIT (`third_party/jl-uboot-tool/LICENSE`) | https://github.com/kagaimiq/jl-uboot-tool (commit adb3f18) |
| Police Inter | `interface/fonts/`, `installer/resources/ui/fonts/` | SIL OFL 1.1 (`OFL-Inter.txt`) | https://github.com/rsms/inter |
| Police JetBrains Mono | `interface/fonts/` | SIL OFL 1.1 (`OFL-JetBrainsMono.txt`) | https://github.com/JetBrains/JetBrainsMono |

**Non inclus et non redistribués** : les firmwares M-VAVE, le logiciel M-UPGRADE, UltraRig (licence PolyForm Strict : certaines idées ont été étudiées, aucun code ni fichier n'est repris), la chaîne de compilation JieLi (à se procurer séparément, voir README) et les sauvegardes de pédales.

M-VAVE et BlackBox sont des marques de leurs propriétaires. TBBR est un projet indépendant, ni affilié à M-VAVE ni approuvé par M-VAVE. Les noms d'amplis et de pédales cités servent uniquement à décrire le son visé.
