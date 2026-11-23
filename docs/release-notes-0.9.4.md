# TBBR 0.9.4

Complète la traduction anglaise du firmware et corrige le comparatif du site.
Le firmware passe en **fw6 0.12**.

## Firmware

- **Noms de paramètres et d’options en anglais** : `Threshold`, `Depth`,
  `Attack`, `Input`, `Output`, `Channel`, `Rectifier`, `Stages`, `Semitones`,
  `Detune`, `Key`, `Scale`, `Interval`, `Wear`, `Springs`, `Mic`, `Normalize`,
  `Major`, `Minor`, `Dorian`, `Mixolydian`, `1x12 closed`…
- L’interface était déjà en anglais en 0.9.3 ; cette version supprime les
  derniers textes français affichés par la page de bloc.
- Migration automatique des anciens noms de scènes français.
- Aucun changement audio.

## Site

- Comparatif M-VAVE / TBBR corrigé :
  - M-VAVE : NAM converti (non natif), chaîne linéaire, 6 blocs max, pas de
    blocs de disto, firmware fermé, design simple, 44 kHz.
  - TBBR : NAM A2 Lite natif, chaîne parallèle possible, nombre de blocs selon
    le DSP, blocs disto/pitch/EQ, firmware open source, neural design, 48,1 kHz.
- Mentions 48 kHz alignées sur **48,1 kHz**.

## App

- App Windows et APK Android **0.9.4**.
- Firmware **fw6 0.12** dans l’installateur et le paquet `.tbbr`.

## Installation

- Windows : `BlackBox_TBBR_App.exe` (portable, rien à installer).
- Android : `TBBR_Android.apk` (USB OTG).
- Mise à jour firmware : installateur Windows, avec une sauvegarde V19 vérifiée.
