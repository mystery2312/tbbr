# TBBR 0.9.5

Optimisations DSP sans changement de son. Le firmware passe en **fw6 0.13**.

## Firmware

- **Classification des blocs mise en cache** : le type de moteur et la
  catégorie du modèle ne sont plus relus à chaque échantillon pour chaque bloc.
- **Division modulo supprimée** dans la lecture des délais, le pré-délai des
  réverbes et la tête de convolution IR.
- **Chemin rapide des réverbes** lorsque les 12 lignes sont allouées : les tests
  de nullité ne sont plus refaits à chaque échantillon.
- **Chemin rapide des chaînes série** : plus de vérification des sections
  parallèles quand il n'y en a pas.
- Aucun coefficient, filtre, saturation, calcul NAM ou convolution IR n'a été
  modifié : le son reste identique.
- Le gain dépend du preset (nombre de blocs, délais, réverbes) ; les chaînes
  lourdes disposent de plus de marge CPU.

## App

- App Windows et APK Android **0.9.5**.
- Firmware **fw6 0.13** dans l'installateur et le paquet `.tbbr`.
- Cette version a été validée sur le canal beta avant publication.

## Installation

- Windows : `BlackBox_TBBR_App.exe` (portable, rien à installer).
- Android : `TBBR_Android.apk` (USB OTG).
- Mise à jour firmware : installateur Windows, avec une sauvegarde V19 vérifiée.
