# TBBR — The Big Black Rig

Firmware libre pour le multi-effet **M-VAVE BlackBox** (puce JieLi AC791N), avec son éditeur (web, tablette, PC) et son flasher.

- **NAM A2 Lite** natif en temps réel (2 cœurs, 396 MHz), réponses impulsionnelles (IR) de baffle
- Pédales et amplis modélisés, grille de 2 × 8 blocs avec sections parallèles, scènes
- 80 presets stockés dans la pédale, accordeur, vu-mètre LED, noise gate d'entrée
- Éditeur en français et en anglais, en USB MIDI (WebMIDI) depuis l'app de bureau ou le navigateur

> ⚠️ Projet indépendant, ni affilié à M-VAVE ni approuvé par M-VAVE. Installer un firmware non officiel se fait à tes risques. L'installateur commence toujours par une **sauvegarde complète** de la flash d'origine, qui permet de revenir au firmware M-VAVE.

## Installer

1. Télécharge **BlackBox_TBBR_Installer.exe** dans les [Releases](../../releases/latest) (Windows 10/11).
2. Branche la pédale en USB (directement, sans hub), allume-la, ferme M-UPGRADE.
3. Dans l'installateur : **Sauvegarder**, puis **Installer**.

Mises à jour : l'app propose la nouvelle version, ou glisse le fichier `TBBR_fw6_x.y.tbbr` d'une release dans l'installateur. Tes presets, IR et captures NAM sont conservés.

## Contenu du dépôt

| Dossier | Contenu |
|---|---|
| `fw_maison/fw6/` | Firmware (C, assembleur pi32v2) |
| `fw_maison/reboot/` | Petit programme en RAM qui redémarre la puce après une écriture |
| `interface/app/` | Éditeur web (HTML/JS, sans framework) ; `interface/tests/` : outils de test du protocole |
| `installer/` | Flasher Windows (Python ; interface HTML servie en local) et paquets de mise à jour `.tbbr` |
| `electron/` | App de bureau (Electron) qui embarque l'éditeur et le flasher |
| `scripts/` | `bb_tool.py` (accès UBOOT : sauvegarde, écriture, redémarrage), `mkfw.py` (format de flash JieLi) |

## Compiler

- **Firmware** : il faut la chaîne JieLi `pi32` (clang pi32v2), fournie avec le SDK AC79 de JieLi et non redistribuée ici. Indique son dossier dans `JL_PI32`, puis lance `powershell -File fw_maison\fw6\build.ps1` (Python 3 et Node.js requis).
- **Tout** (firmware → installateur → app de bureau) : `powershell -File build_all.ps1` (PyInstaller dans `..\venv`, `npm install` dans `electron/`).

## Licence

GPL-3.0 (voir `LICENSE`). Composants tiers et crédits : `THIRD_PARTY.md`.
