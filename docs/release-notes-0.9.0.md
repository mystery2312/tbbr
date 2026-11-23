# TBBR 0.9.0

Mise à jour de l’application de bureau, du site et de l’app Android.
Le firmware reste **fw6 0.8** (aucun changement audio depuis la 0.8).

## Nouveautés

- **Application Android** `TBBR_Android.apk` : le même éditeur, en standalone,
  avec un pont USB MIDI natif (USB OTG). Édition des presets, IR et captures NAM.
- **Site / documentation** : documentation complète FR/EN, avertissement
  « projet expérimental », procédure V19, installation, mises à jour et retour
  au firmware d’origine. L’éditeur en ligne est retiré : l’app de bureau ou
  l’app Android sont les seuls éditeurs.
- **Éditeur** : sélecteur **FR/EN** et pourcentage de batterie restaurés dans la
  barre du haut (ils avaient disparu de la 0.8), mode footswitch **Preset** par
  défaut.
- **Installateur** : contrôle de version M-VAVE. Si la pédale n’est pas en V19,
  un message clair renvoie vers la documentation et les boutons d’écriture sont
  désactivés.
- **APK dans les releases** : `build_all.ps1` construit maintenant l’APK et
  `release.ps1` l’envoie avec la release (`TBBR_Android.apk`).

## Firmware

- **fw6 0.8** : cabs d’usine en vraies IR, presets d’usine refaits.
- Aucune nouvelle écriture firmware n’est nécessaire pour cette release.

## Installation

- Windows : `BlackBox_TBBR_App.exe` (portable, rien à installer).
- Android : `TBBR_Android.apk` (USB OTG).
- Mise à jour firmware : installateur Windows, avec une sauvegarde V19 vérifiée.
