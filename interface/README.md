# The Big Black Rig — maquette

Maquette fonctionnelle de l'éditeur pour le firmware custom (CFW) de la **M-VAVE ANNBLACKBOX**, plus une simulation de la façade et de son écran.

- Éditeur : <https://johandaems.duckdns.org/thebigblackrig/>
- Écran de la pédale : <https://johandaems.duckdns.org/thebigblackrig/ecran.php>
- Sources : <https://johandaems.duckdns.org/thebigblackrig/thebigblackrig-maquette.zip>

> **Important :** le protocole, les identifiants Bluetooth et les limites (80 presets, 8 scènes, 8 colonnes, 32 IR, 16 NAM…) sont **des hypothèses de la maquette**. Il faudra les aligner sur le vrai firmware.

---

## 1. Fichiers

| Fichier | Rôle |
|---|---|
| `index.php` | Page de l'éditeur. Lie chaque fichier CSS/JS avec `?v=<date de modification>`, parce que nginx les met en cache 10 ans (il faut toujours passer par `asset()`). Contient le sprite des icônes d'interface. |
| `ecran.php` | Page de simulation de la façade et de l'écran 240 × 240. |
| `js/data.js` | Catalogue des blocs (45 modèles, 10 catégories), icônes par type d'effet (`MODEL_GLYPH`), presets d'usine, IR de démonstration. Partagé par l'éditeur et l'écran. |
| `js/transport.js` | Protocole tramé et transports : pédale simulée, Bluetooth LE, USB série. |
| `js/app.js` | L'éditeur : état, grille, glisser-déposer, scènes, footswitchs, NAM, IR, réglages globaux, appareil, mode tactile. |
| `js/ecran.js` | Rendu SVG de l'écran et commandes de la façade simulée. |
| `css/app.css` | Styles de l'éditeur : PC, tactile (tablette et téléphone). |
| `css/ecran.css` | Styles de la façade simulée (en millimètres réels). |
| `manifest.webmanifest`, `icon.svg` | Installation en app plein écran sur tablette. |

Stack : PHP minimal (uniquement pour versionner les fichiers), HTML/CSS/JS vanilla, **sans build ni dépendance**. Scripts classiques (pas de modules ES), pour que chaque fichier puisse être versionné par `index.php`.

Pour l'utiliser hors du serveur : n'importe quel serveur PHP suffit. Sinon, renommer `index.php` en `index.html` et retirer les `<?= asset(...) ?>`. Le Bluetooth et l'USB exigent du **HTTPS** et **Chrome, Edge, Opera ou Chrome Android**. Safari (iPad/iPhone) ne gère pas Web Bluetooth : il faudra Bluefy, ou plus tard une app native.

---

## 2. Concepts

### Preset
- 80 presets : 20 banques de 4 (`01A` à `20D`).
- Chaque preset a un nom, une couleur, un tempo, un volume, une grille de blocs, 8 scènes, une configuration de footswitchs (mode Stomp) et une pédale d'expression.

### Grille : 2 rangées
- **Rangée A** : la chaîne principale, 8 colonnes.
- **Rangée B** : les sections parallèles. **Chaque groupe de blocs côte à côte sur B forme une section parallèle à lui seul** : split juste avant sa première colonne, merge juste après sa dernière, en parallèle des mêmes colonnes de A.
  - Exemple (preset 04A « Dual Amp Parallèle ») : `Gate → OD → [Plexi / Rectifier] → Room → [IR / IR]`.
  - Chaque section a sa **balance A/B**. Elle apparaît dans l'éditeur du bloc quand celui-ci fait partie d'une section.
- Le DSP de chaque bloc est additionné. Au-delà de 100 %, l'ajout est refusé.

### Scènes
- 8 scènes par preset (A à H). Chaque scène mémorise **le bypass et les réglages** de chaque bloc.
- Le sélecteur « Toutes scènes / Scène X seule » décide si une modification s'applique à toutes les scènes ou seulement à la scène active.

### Footswitchs (2 physiques : gauche / droite)

| Mode | Gauche | Droite |
|---|---|---|
| Preset | preset − (maintien : accordeur) | preset + (maintien : tap) |
| Scène | scène précédente (maintien : preset −) | scène suivante (maintien : preset +) |
| Stomp | affectation libre par preset : bloc, scène, tap, accordeur… avec couleur de LED | idem |

Appui simultané **G + D** : action globale configurable (accordeur par défaut).

### Captures NAM
- La pédale exécute nativement les modèles **NAM A2 en mode Lite**.
- Import de fichiers `.nam` : l'app lit le JSON (`version`, `architecture`, `config`, `weights`, `sample_rate`, `metadata`).
- Vérifications : modèle A2 (détecté par la présence de « Slimmable » dans l'architecture ou la config, **heuristique à confirmer avec un vrai fichier**), 48 kHz, taille maximale par emplacement.
- Les poids sont stockés dans **IndexedDB** (trop lourds pour localStorage), et les métadonnées dans l'état.

### IR
- 32 emplacements, 48 kHz mono, 2048 points.
- Un `.wav` importé est rééchantillonné à 48 kHz, raccourci si besoin (avec un fondu en sortie) et normalisé.
- L'app affiche la réponse en fréquence (FFT) et la forme d'onde.

---

## 3. L'éditeur sur PC

L'interface PC s'affiche **à la souris sur une fenêtre d'au moins 1200 px de large**.

- **Colonne de gauche** :
  - onglet **Presets** : liste par banque, recherche, copier / coller / init / importer / exporter (JSON) ;
  - onglet **Blocs** : bibliothèque à glisser sur la grille, ou un clic pour ajouter dans la case sélectionnée ou la première libre.
- **Grille** :
  - case vide `+` : choisir un bloc ;
  - clic sur un bloc : l'éditer ; double-clic : bypass.
- **Glisser-déposer** (blocs de la grille ou de la bibliothèque) :
  - **bord gauche/droit d'un bloc** : insertion, les blocs voisins s'écartent vers la case libre la plus proche ;
  - **centre d'un bloc** : échange (ou remplacement si le bloc vient de la bibliothèque) ;
  - **case vide** : le bloc est posé.
- **Éditeur de bloc** (en bas) : potards (glisser, molette, double-clic = défaut, Maj = réglage fin), modèle, bypass, balance A/B, copier/coller les réglages, réinitialiser, supprimer.
- **Barre de scènes** : 8 scènes (double-clic : renommer / copier vers une autre scène), tempo, TAP.
- **Onglets** :

  | Onglet | Contenu |
  |---|---|
  | Grille | la chaîne du preset |
  | Contrôles | footswitchs et pédale d'expression |
  | NAM | captures NAM |
  | IR | réponses impulsionnelles |
  | Global | entrée/sortie, EQ global, tempo, diapason, MIDI, Bluetooth, système, choix de l'interface |
  | Appareil | connexion, infos, firmware, sauvegarde, profil de connexion, console protocole |

- **Raccourcis** :

  | Touche | Action |
  |---|---|
  | ← → | preset précédent / suivant |
  | 1 à 8 | scènes |
  | Espace | bypass du bloc sélectionné |
  | Suppr | supprimer le bloc sélectionné |
  | Ctrl+Z / Ctrl+Maj+Z | annuler / rétablir |
  | Ctrl+S | sauver sur la pédale |
  | T | accordeur |
  | Échap | désélectionner |

---

## 4. Mode tactile (tablette, téléphone)

### Activation
- Automatique sur **tout écran tactile**, et sur **toute fenêtre de moins de 1200 px de large**.
- Forçable dans **Global → Système → Interface** : Auto / PC / Tactile.

### Principe
La tablette doit être **l'extension de la pédale**, pas un site web. L'écran n'affiche que ce qui sert à l'instant : c'est le principe de l'écran tactile de la Quad Cortex (dont on reprend les principes, pas le visuel).

- **Accueil = la grille seule** :
  - les blocs sont des **tuiles-icônes sans texte**, une icône par type d'effet (éclair = overdrive, tête d'ampli, réseau de neurones = NAM, cathédrale = hall…) ;
  - les cases vides sont des points discrets.
- **Barre du haut minimale** :
  - menu ☰ ;
  - nom du preset en grand (toucher : navigateur plein écran des presets) ;
  - mode des footswitchs (toucher : changer de mode) ;
  - accordeur, Sauver, connexion.
- **Réglages en tiroir** :
  - il s'ouvre quand on touche un bloc, avec 6 potards maximum par page ;
  - les actions secondaires sont sous `⋯` ;
  - on le ferme avec ✕ ou en touchant le fond de la grille ;
  - **déplacer ou coller un bloc n'ouvre pas ses réglages.**
- **Menu ☰ (grandes tuiles)** : Grille, Presets, Bibliothèque de blocs (panneau ancré à gauche pour le glisser-déposer), Live, Contrôles, NAM, IR, Global, Appareil, Écran de la pédale, Plein écran, Annuler / Rétablir.
- **Vue Live** : nom du preset en très grand, 8 scènes en tuiles géantes, TAP, accordeur. On l'ouvre par le menu ou en **glissant vers le haut sur la barre des scènes**.
- **Sélecteurs en tuiles** : modèles, options, IR et NAM (aucune liste déroulante native).

### Appuis longs
Ils donnent un retour visuel et une petite vibration.

| Où | Appui court | Appui long |
|---|---|---|
| Bloc | ouvrir ses réglages (double-tap : bypass) | actions : bypass, réglages, remplacer, copier le bloc, coller les réglages, défaut, supprimer |
| Case vide | choisir un effet | coller le bloc copié (modèle + réglages) |
| Potard | — | valeur par défaut |
| Scène | changer de scène | renommer, copier vers une autre scène |
| Nom du preset | liste des presets | sauver, renommer, copier, coller, réinitialiser |
| Chip de mode | changer de mode | réglages des footswitchs |
| TAP | tempo | accordeur |

### « Pas un navigateur »
- Pas de menu contextuel, de sélection de texte, de loupe, de zoom ni de barres de défilement.
- **Plein écran automatique** au premier toucher (désactivable dans Global → Système).
- **L'écran reste allumé** (Wake Lock).
- Installée sur l'écran d'accueil, l'app s'ouvre directement en plein écran (`display: fullscreen`).

### Petites hauteurs
En téléphone paysage, ou dans une fenêtre de moins de 560 px de haut, tout est compacté et le tiroir de réglages se superpose à la grille.

---

## 5. `ecran.php` : façade et écran de la pédale

Simulation de l'ANNBLACKBOX (113 × 109 mm, écran **1,54″ de 240 × 240 px**) :
- MASTER à gauche, encodeur PARA à droite ;
- touches HOME FX AMP MOD DLY REV CAB ;
- 2 footswitchs avec **TUNER** entre les deux.

### Écran principal
L'écran ne montre que l'essentiel :
- **Barre du haut** : numéro et nom du preset, batterie (verte, puis orange, puis rouge), liseré à la couleur du preset.
- **Chaîne** : mêmes tuiles-icônes que l'éditeur, bypass en gris.
  - Elle s'affiche **comme du texte** : quand une ligne est pleine, le câble revient à gauche sur la ligne suivante, en serpentin.
  - L'écran prend le moins de lignes possible (3 au maximum) tant que les tuiles font au moins 36 px.
  - **Chaque section parallèle est une seule unité** : ses deux chemins sont empilés dans la ligne, entre un crochet de split/merge. Une section n'est jamais coupée entre deux lignes.
  - Seules les colonnes occupées sont affichées.
- Pas de barre du bas.

### Autres écrans
| Écran | Contenu |
|---|---|
| Changement de preset | numéro + nom en grand pendant 0,9 s |
| Page de bloc (touches FX… CAB) | icône, modèle, ON/OFF, 4 paramètres visibles avec valeur et jauge, indicateur de page, mode réglage ◆ |
| MASTER | volume en dB et jauge, quelques instants |
| Accordeur | note en très grand (fond vert quand c'est juste), barre de justesse, cents |

### Commandes
- **HOME** : écran principal.
- **FX / AMP / MOD / DLY / REV / CAB** : page du premier bloc de la famille. Rappuyer passe au bloc suivant de la même famille (ex. 2e ampli). FX regroupe dynamique, overdrive, pitch, EQ et utilitaires.
- **PARA** (molette, ou glisser vertical : un cran tous les 14 px) :

  | Où | Tourner | Appuyer | Maintenir |
  |---|---|---|---|
  | écran principal | curseur sur les blocs | ouvrir le bloc | bypass du bloc sous le curseur |
  | page de bloc | choisir un paramètre ; en mode ◆, changer sa valeur | entrer/sortir du mode réglage ◆ | bypass du bloc |

- **MASTER** : volume général (−60 à +6 dB).
- **Footswitchs** : appui, maintien, G + D (TUNER). N'importe quel switch quitte l'accordeur.
- **Clavier** :

  | Touche | Action |
  |---|---|
  | ← → | footswitchs |
  | ↑ ↓ | tourner PARA |
  | Entrée | appuyer PARA |
  | H / Échap | HOME |

### Taille
- **Taille réelle** : la façade est dessinée en millimètres.
  - **Calibrer** : poser une carte bancaire ou une carte d'identité (85,6 mm) contre l'écran et ajuster le rectangle à sa largeur.
  - Le calibrage est mémorisé en pixels physiques par mm, donc il reste juste malgré le zoom du navigateur. Il est propre à chaque appareil.
  - Une **règle de 10 cm** permet de vérifier.
  - Le champ « écran » règle la diagonale (1,54″ par défaut).
- **Écran 240 px** : 1 pixel de l'écran de la pédale = 1 pixel de l'affichage, pour travailler le graphisme.

### Synchronisation avec l'éditeur
- Ouvrir l'éditeur et `ecran.php` dans deux onglets du même navigateur. Le badge « éditeur lié » s'allume.
- **Éditeur → écran** : chaque modification est enregistrée dans `localStorage` et l'écran la relit (événement `storage`).
- **Écran → éditeur** : footswitchs, réglages PARA, bypass et MASTER passent par un `BroadcastChannel('tbbr')`, et l'éditeur les applique.
- Sans éditeur, l'écran fonctionne seul avec les presets enregistrés (ou les presets d'usine).

---

## 6. Connexion et protocole

### Transports
| Transport | Fonctionnement |
|---|---|
| Pédale simulée | se connecte automatiquement au chargement ; répond aux commandes, envoie des vu-mètres et un accordeur simulés |
| Bluetooth LE (Web Bluetooth) | service de type Nordic UART : l'app écrit sur **RX**, la pédale notifie sur **TX**. Les trames sont découpées par paquets de 180 octets. |
| USB (Web Serial) | port série CDC-ACM, 115 200 bauds par défaut |

Les UUID, le préfixe du nom Bluetooth et la vitesse sont réglables dans **Appareil → Profil de connexion**.

### Trame (identique en BLE et en USB)

```
[0xA5] [CMD] [LEN lo] [LEN hi] [PAYLOAD × LEN] [XOR de CMD … fin du payload]
```

- Payload binaire pour le temps réel (paramètres, bypass, accordeur, vu-mètres, morceaux de fichiers).
- Payload JSON UTF-8 pour le structuré (infos, preset complet, début de transfert IR/NAM, réglages globaux).

| Commande | Code | Payload |
|---|---|---|
| HELLO / INFO | 0x01 / 0x02 | JSON. INFO : modèle, firmware, batterie, limites |
| ACK / NAK | 0x06 / 0x15 | `[commande]` |
| PRESET_SELECT / SET / SAVE | 0x10 / 0x11 / 0x12 | `[index]` / JSON / `[index]` |
| SCENE_SELECT / TEMPO / LEVEL | 0x18 / 0x19 / 0x1A | `[scène]` / `[bpm lo, bpm hi]` / `[niveau float32 LE, dB]` |
| BLOCK_SET / CLEAR / MOVE | 0x20 / 0x21 / 0x22 | JSON / `[rangée, col]` / `[r1, c1, r2, c2]` |
| BYPASS | 0x23 | `[rangée, col, on]` |
| PARAM | 0x24 | `[rangée, col, index param, float32 LE]` |
| SPLIT | 0x25 | `[col début, col fin, balance]` |
| GLOBAL / FS_CONFIG | 0x30 / 0x31 | JSON |
| TUNER / TUNER_DATA | 0x38 / 0x39 | `[on]` / `[note, octave, cents×10 int16, niveau]` |
| IR_BEGIN / CHUNK / END | 0x40–0x42 | JSON / `[slot, idx lo, idx hi, int16…]` / `[slot]` |
| NAM_BEGIN / CHUNK / END / DELETE | 0x44–0x47 | JSON (avec CRC32) / `[slot, idx lo, idx hi, données]` / `[slot, CRC32 LE]` / `[slot]` |
| FW_BEGIN / CHUNK / END | 0x50–0x52 | JSON / `[index uint32 LE, données]` / — |
| METER | 0x60 | `[entrée, sortie, batterie]` (0–255 ; batterie en %, 127 = inconnue) |
| FACTORY_RESET | 0x7E | `[0x5A]` |

Une capture NAM ou une IR réécrite dans un emplacement déjà utilisé est **rechargée immédiatement** par le bloc concerné (même numéro de slot). `BLOCK_MOVE` répond ACK : l'app renvoie ensuite le preset complet (`PRESET_SET`) pour remettre la mémoire en ordre.

La **console protocole** (Appareil) affiche les trames émises et reçues. On peut y envoyer :
- des octets bruts : `A5 01 00 00 01` ;
- une commande nommée avec des octets : `PRESET_SELECT 03` ;
- une commande nommée avec du JSON : `GLOBAL {"bright":40}`.

---

## 7. Stockage

| Où | Quoi |
|---|---|
| `localStorage` `tbbr.state.v1` | presets, réglages globaux, métadonnées IR/NAM, préférences |
| `localStorage` `tbbr.ecran.*` | mode d'affichage, diagonale et calibrage de l'écran simulé |
| IndexedDB `tbbr` / `nam` | poids des captures NAM |

- **Appareil → Sauvegarde complète** : un fichier JSON avec presets, réglages globaux, IR utilisateur et captures NAM (poids compris).
- **Restaurer** recharge ce fichier.
- **Réinitialisation usine** efface tout (après confirmation).

---

## 8. À aligner avec le vrai firmware

- Protocole, codes de commande, format des trames, UUID Bluetooth.
- Limites : nombre de presets, banques, scènes, colonnes, emplacements IR/NAM, longueur des IR, taille maximale d'une capture NAM.
- Détection des modèles NAM A2 (fournir un vrai `.nam` A2).
- Liste réelle des blocs et de leurs paramètres.
- Batterie et état Bluetooth/USB envoyés par la pédale à l'écran.
