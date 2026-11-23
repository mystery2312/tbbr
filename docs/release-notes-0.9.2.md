# TBBR 0.9.2

Correctifs pour l’installateur et la réinitialisation usine.
Le firmware passe en **fw6 0.10**.

## Correctifs

- **Installateur : fenêtre vide corrigée.** Une apostrophe non échappée dans le
  JavaScript de l’interface bloquait tout le script : les textes, boutons et
  états ne s’affichaient pas. C’est réparé, et le build vérifie désormais la
  syntaxe du script avant de produire l’exe.
- **Fenêtre Edge réutilisée :** l’installateur ouvre maintenant un profil Edge
  neuf à chaque lancement, pour ne plus rouvrir une ancienne fenêtre pointant
  vers un serveur arrêté (page vide).
- **Réinitialisation usine :** elle fonctionne réellement sur la pédale. Elle
  efface les 80 presets, les IR utilisateur et les captures NAM, remet les
  réglages globaux par défaut et réinstalle la banque d’usine. Le firmware TBBR
  et les baffles d’usine ne sont pas touchés. L’app attend la confirmation de la
  pédale avant d’afficher « Réinitialisation effectuée ».

## Déjà dans la 0.9.1

- **fw6 0.9** : ajouter, déplacer et supprimer des blocs directement sur la
  pédale (maintien d’une touche FX..CAB), LED HOME = tap tempo, catégorie
  Utilitaire masquée.
- **Anglais par défaut**, traduction du site et de l’app complétée.
- **App Android** : mise à jour automatique de l’APK (vérification au lancement
  puis toutes les 6 h, téléchargement et installation par-dessus l’ancienne
  version).
- **Site** : documentation enrichie, bouton APK direct.

## Installation

- Windows : `BlackBox_TBBR_App.exe` (portable, rien à installer).
- Android : `TBBR_Android.apk` (USB OTG).
- Mise à jour firmware : installateur Windows, avec une sauvegarde V19 vérifiée.
