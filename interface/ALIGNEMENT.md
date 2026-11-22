# The Big Black Rig — alignement maquette ↔ vrai firmware

État au 2026-11-21. Maquette : `maquette/thebigblackrig/` (zip d'origine intact). Version intégrée : `app/` (copie modifiée).

## 1. Ce qui correspond déjà au matériel (vérifié sur la pédale)

| Maquette | Réalité (firmware maison, `save.md` §8) | État |
|---|---|---|
| Touches HOME FX AMP MOD DLY REV CAB | HOME = PA01, FX = PA00, AMP = PH09, MOD = PH08 ; DLY / REV / CAB sur l'échelle ADC de PC10 | ✅ |
| 2 footswitchs, G + D = accordeur | gauche = PA03, droit = PA02 | ✅ (pas de touche TUNER physique : c'est G + D) |
| MASTER (volume) | potard PA10 (ADC canal 2), lu toutes les ~21 ms | ✅ |
| Encodeur PARA (rotation + appui) | A/B = PC00/PC01, appui = PH06 | ✅ câblé, pas encore utilisé |
| Écran 240 × 240 | ST7789 240 × 240, SPI | ✅ (aujourd'hui en SPI logiciel, lent : passer au SPI1 matériel pour l'écran de la maquette) |
| 8 LED des touches | 74HC595 (HOME … CAB = bits 0..6) | ✅ |
| Entrée / sortie audio | ALINK 16 bits 48 kHz, guitare sur la voie gauche | ✅ |
| CPU « Dual-core 240 MHz » (démo) | AC791N bicœur, **360 MHz** (horloge du SPL), un seul cœur utilisé pour l'instant | ⚠️ corrigé dans `app/` |
| Batterie | **inconnue** : rien trouvé pour l'instant (à chercher : canal ADC de la batterie dans le firmware d'origine) | ❓ |

## 2. Transport et protocole

- **La trame de la maquette est gardée telle quelle** : `[A5] [CMD] [LEN lo] [LEN hi] [PAYLOAD] [XOR]`, mêmes codes de commande.
- **Transport USB = MIDI USB compatible classe** (port « BlackBox Custom », VID/PID 0x1209/0x0001 provisoires) au lieu de Web Serial :
  - aucun pilote (Windows, macOS, Android, iOS) ; **WebMIDI marche dans Chrome Android**, Web Serial non ;
  - la trame est transportée dans un SysEx : `F0 7D 42 58 70 <trame codée 7 bits> F7` (7D = identifiant « non commercial » ; 7 bits : un octet d'en-tête par groupe de 7, bit k = bit 7 de l'octet k) ;
  - nouveau transport `MidiTransport` dans `app/js/transport.js` (choix « USB » de l'app) ; `SerialTransport` reste disponible pour plus tard (interface CDC à ajouter au firmware si besoin, le SDK l'a).
- **Bluetooth LE** : la puce l'a (UltraRig l'utilise), pas encore fait dans le firmware. Les UUID de la maquette restent des hypothèses.
- Les commandes propres au firmware (mise à jour, stockage, diagnostic : `F0 7D 42 58 <01..7E> … F7`) restent à côté, sur le même port.

## 3. Limites → place en flash

Flash 1 Mio. Zones utilisables pour le firmware maison : application (le code fait ~40 Ko) + stockage.

| Donnée | Maquette | Taille réelle | Total |
|---|---|---|---|
| IR | 32 × 2048 points | int16 : 4 Ko | **128 Ko** |
| NAM A2 Lite | 16 slots × « 1024 Ko » | **1 871 poids** (A2 Lite) : 7,5 Ko en float32, 3,7 Ko en int16 | **~120 Ko** (float32) |
| Presets | 80 × 8 scènes × 16 blocs | binaire compact ≈ 2,5 Ko | **~200 Ko** |

→ ~450 Ko : plus que la zone actuelle [0x60000, 0xA7000) (284 Ko) ; il faudra **étendre le stockage à [0x60000, 0x100000)** (640 Ko ; la VM et la zone USR de M-VAVE ne servent plus, la sauvegarde permet de les restaurer).
→ `namMaxKB` de la maquette (1024) est irréaliste : la pédale annoncera **8 Ko** par slot (A2 Lite float32).
→ La pédale annonce ses vraies limites dans `INFO` ; l'app les lit déjà (`presets`, `irSlots`, `irLen`, `namSlots`, `namMaxKB`).

✅ **Écriture flash par le firmware : résolue (fw6).** Zone de stockage = **636 Ko** ([0x60000, 0xC2000) + [0xC3000, 0x100000)) : 80 presets (1 secteur chacun, JSON compact de l'app), 32 IR × 4 Ko, 16 NAM × 8 Ko, une table de noms. PRESET_SAVE, IR_* et NAM_* (avec contrôle CRC32) sont acceptés ; la pédale recharge le dernier preset sauvé au démarrage. `INFO.storage = true`.
→ Les limites de la maquette (80 / 32 / 16) tiennent toutes en flash.

## 4. Captures NAM A2 : format réel (fichier `A2.nam` de NeuralAmpModelerCore, MIT)

- Racine : `{"version":"0.7.0","architecture":"SlimmableContainer","config":{"submodels":[...]}}` — **pas de `weights` ni de `sample_rate` à la racine**.
- `submodels[i] = {"max_value": 0.5 | 1.0, "model": {"architecture":"WaveNet","config":{...},"weights":[...],"sample_rate":48000,"metadata":{...}}}`.
- **Lite = sous-modèle de plus petit `max_value`** (0,5) : WaveNet, 1 layer array, 3 canaux, 23 couches, noyaux `[6×14, 15, 15, 6×7]`, dilatations `[1,3,7,17,41,101,239] ×2, [1,13], [1,3,7,17,41,101,239]`, LeakyReLU 0,01, sans gating, `layer1x1` actif, `head1x1` inactif, head 3→1 noyau 16 + biais, `head_scale` ; **1 871 poids**.
- La maquette refusait ces fichiers (`weights` absent) → corrigé dans `app/js/app.js` : détection `SlimmableContainer`, extraction du Lite, contrôle de la topologie exacte, 48 kHz lu dans le sous-modèle ; les A1 (WaveNet seul) restent refusés avec le message existant.

## 5. Blocs (catalogue `data.js`, 43 modèles)

**Décision (utilisateur, 2026-11-21) : effets génériques par famille pour l'instant ; réglage fin effet par effet quand tout le reste sera en place.** État : 41 modèles actifs (pitch compris : décaleur générique), `nam` et `ir` attendent leurs moteurs (inférence A2 Lite, convolution).


Le firmware implémente les blocs progressivement ; `INFO.models` liste ceux qu'il sait faire tourner (l'app grise les autres). Correspondance prévue avec le DSP existant (fw3) :

| Famille | Modèles maquette | DSP firmware |
|---|---|---|
| drive | green, gold, grit, fuzz, metal | saturation suréchantillonnée x2 + filtres (à décliner par modèle) |
| amp | usclean, chime, brit, plexi, rect, lead51, bassamp | préampli (saturation + EQ d'ampli) ; **nam** = moteur A2 Lite (à faire) |
| cab | cab412, cab212, ir | cab412/212 = cascade de biquads ; ir = convolution (à faire, accélérateur FFT de la puce) |
| eq | peq, geq | biquads |
| mod | chorus, flanger, phaser, trem, vibe, rotary | chorus/trem existants ; les autres à faire |
| delay | ddl, analog, tape, pingpong, reverse | écho filtré existant (variantes à faire) |
| reverb | room, hall, plate, spring, shimmer | Freeverb Q23 existant (variantes à faire) |
| dyn / util / pitch | gate, comp, squash, boost, vol, fxl, octave, shift, harm | à faire (boost/vol triviaux) |

Le pourcentage `dsp` de la maquette sera remplacé par le coût mesuré sur la pédale (la charge est déjà mesurée en continu).
