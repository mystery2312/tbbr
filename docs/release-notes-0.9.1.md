# TBBR 0.9.1

Mise à jour de l’application de bureau, du site, de l’app Android et du firmware.
Le firmware passe en **fw6 0.9**.

## Nouveautés

- **Gestion des blocs sur la pédale** : maintiens une touche **FX / AMP / MOD /
  DLY / REV / CAB** (~0,6 s) pour ouvrir le menu du bloc affiché :
  **+ Ajouter un bloc**, **Déplacer** (PARA tourne à gauche/droite), **Supprimer**
  (confirmation Oui/Non). Un appui sur une famille vide ouvre directement l’ajout.
  Les réglages et les 8 scènes suivent le bloc déplacé.
- **LED HOME = tap tempo** : la LED du bouton HOME bat à la noire sur le tempo du
  preset (40 à 250 BPM). Les LED FX..CAB restent l’indicateur de page et le
  vu-mètre.
- **Simulation de l’écran mise à jour** dans l’app et sur le site : gestion des
  blocs au maintien des touches, LED HOME qui bat, mêmes écrans et mêmes règles
  que le firmware fw6 0.9.
- **Anglais par défaut** : l’app de bureau, l’app Android et la page « écran »
  démarrent en anglais. Le sélecteur **FR/EN** reste dans la barre du haut et le
  choix est mémorisé.
- **Traduction anglaise complétée** : site et documentation (nouvelles sections
  « Under the hood », « Compatibility », FAQ et journal des versions), noms des
  blocs et des paramètres, textes de la page écran et de l’app.
- **Site** : contenu enrichi, métadonnées EN/FR, bouton **Download the Android
  APK** direct.
- **App Android** : vérifie les mises à jour au lancement (puis toutes les 6 h),
  télécharge l’APK depuis GitHub Releases et lance l’installation par-dessus
  l’ancienne version.
- **Effets** : la catégorie **Utilitaire** est retirée de la liste des blocs et
  du sélecteur. Les anciens presets qui en contiennent restent lisibles, mais on
  ne peut plus en ajouter.

## Déjà dans la 0.9.0

- **Application Android** `TBBR_Android.apk` : le même éditeur, en standalone,
  avec un pont USB MIDI natif (USB OTG).
- **Documentation complète FR/EN** : avertissement « projet expérimental »,
  procédure V19, installation, mises à jour et retour au firmware d’origine.
- **Éditeur** : sélecteur FR/EN et pourcentage de batterie restaurés dans la
  barre du haut, mode footswitch **Preset** par défaut.
- **Installateur** : contrôle de version M-VAVE. Si la pédale n’est pas en V19,
  un message clair renvoie vers la documentation et les boutons d’écriture sont
  désactivés.
- **APK dans les releases** : `build_all.ps1` construit l’APK et `release.ps1`
  l’envoie avec la release (`TBBR_Android.apk`).

## Firmware fw6 0.9

- Gestion des blocs sur la façade (ajout, déplacement, suppression).
- LED HOME tap tempo.
- Catégorie Utilitaire masquée (blocs conservés pour les anciens presets).
- Aucune modification du son ni du bootloader.

## Installation

- Windows : `BlackBox_TBBR_App.exe` (portable, rien à installer).
- Android : `TBBR_Android.apk` (USB OTG).
- Mise à jour firmware : installateur Windows, avec une sauvegarde V19 vérifiée.
