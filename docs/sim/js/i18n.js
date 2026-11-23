/* i18n.js — français / anglais pour The Big Black Rig.
 * Le texte source de l'app est en français ; ce module le traduit à l'affichage.
 * Il suit aussi les éléments recréés par les rendus dynamiques (MutationObserver).
 * Choix mémorisé dans localStorage (« tbbr.lang »).
 */
(function () {
  'use strict';

  var EN = {
    /* barre du haut / navigation */
    "Presets": "Presets",
    "Blocs": "Blocks",
    "Grille": "Grid",
    "Footswitchs": "Footswitches",
    "Contrôles": "Controls",
    "Captures NAM": "NAM captures",
    "Appareil": "Device",
    "Global": "Global",
    "Déconnecté": "Disconnected",
    "Connecté": "Connected",
    "Connexion…": "Connecting…",
    "Sauver": "Save",
    "Sauver sur la pédale": "Save to pedal",
    "Annuler": "Cancel",
    "Rétablir": "Redo",
    "Mode Live": "Live mode",
    "Accordeur": "Tuner",
    "Rechercher un preset": "Search presets",
    "Preset précédent": "Previous preset",
    "Preset suivant": "Next preset",
    "Preset précédent (←)": "Previous preset (←)",
    "Preset suivant (→)": "Next preset (→)",
    "Annuler (Ctrl+Z)": "Undo (Ctrl+Z)",
    "Rétablir (Ctrl+Maj+Z)": "Redo (Ctrl+Shift+Z)",
    "Mode des footswitchs (toucher pour changer)": "Footswitch mode (tap to change)",
    "Accordeur (T)": "Tuner (T)",
    "Sauver sur la pédale (Ctrl+S)": "Save to pedal (Ctrl+S)",
    "Vue Live (ou glisse vers le haut)": "Live view (or swipe up)",
    "Nom du preset": "Preset name",
    "Modifications non sauvées": "Unsaved changes",
    "Batterie de la pédale": "Pedal battery",
    "Entrée / Sortie": "Input / Output",
    "Charge DSP du preset": "Preset DSP load",
    "Mode des footswitchs": "Footswitch mode",
    "Retour à la grille": "Back to grid",
    "Tourne ton appareil en paysage": "Rotate your device to landscape",
    "Copier le preset": "Copy preset",
    "Coller sur ce preset": "Paste to this preset",
    "Réinitialiser le preset": "Reset preset",
    "Importer (.json)": "Import (.json)",
    "Exporter (.json)": "Export (.json)",

    /* presets / scènes */
    "Preset": "Preset",
    "Scène": "Scene",
    "Scènes": "Scenes",
    "SCÈNES": "SCENES",
    "SCÈNE": "SCENE",
    "Rythme": "Rhythm",
    "Ambiance": "Ambience",
    "Scène F": "Scene F",
    "Scène G": "Scene G",
    "Scène H": "Scene H",
    "Saisir le tempo": "Enter tempo",
    "Tempo du preset (BPM)": "Preset tempo (BPM)",
    "Tap tempo · maintenir : accordeur": "Tap tempo · hold: tuner",
    "Tap tempo": "Tap tempo",
    "Renommer / copier…": "Rename / copy…",
    "Copier vers": "Copy to",
    "Preset réinitialisé": "Preset reset",
    "Preset vide": "Empty preset",
    "Fichier de preset invalide": "Invalid preset file",
    "Rien à coller : copie d’abord un preset": "Nothing to paste: copy a preset first",
    "Rien à coller : appui long sur un bloc → Copier le bloc": "Nothing to paste: long-press a block → Copy block",
    "Choisis d’abord une case de la chaîne": "Select a slot in the chain first",

    /* grille / blocs */
    "Édition": "Edit",
    "Toutes scènes": "All scenes",
    "Pas de parallèle": "No parallel",
    "Rangée B = parallèle · glisse sur le bord d’un bloc pour insérer, au centre pour échanger":
      "Row B = parallel · drag to a block edge to insert, to the centre to swap",
    "Rangée parallèle : chaque groupe de blocs ici est en parallèle de la rangée A":
      "Parallel row: each group of blocks here runs in parallel with row A",
    "Rangée pleine : libère une case pour insérer": "Row full: free a slot to insert",
    "Plus de case libre sur le chemin A : glisse le bloc sur une case":
      "No free slot on path A: drag the block onto a slot",
    "Rechercher un bloc": "Search blocks",
    "Aucun bloc ne correspond.": "No matching block.",
    "Ajouter un bloc…": "Add a block…",
    "Ajouter un bloc": "Add a block",
    "Ajouter en": "Add in",
    "Remplacer le bloc": "Replace block",
    "Remplacer": "Replace",
    "Changer de modèle": "Change model",
    "Copier le bloc": "Copy block",
    "Coller le bloc": "Paste block",
    "Coller les réglages": "Paste settings",
    "Copier les réglages": "Copy settings",
    "Valeurs par défaut": "Default values",
    "Valeur par défaut": "Default value",
    "Réglages": "Settings",
    "Plus d’actions": "More actions",
    "Supprimer": "Delete",
    "Activer": "Enable",
    "Bypass": "Bypass",
    "Bloc": "Block",
    "Case": "Slot",
    "Section": "Section",
    "sections": "sections",
    "parallèle": "parallel",
    "parallèles": "parallel",
    "colonne": "column",
    "colonnes": "columns",
    "Toucher un bloc : l’éditer · double-tap : bypass · glisser : déplacer · 1–8 : scènes · ← → : presets":
      "Tap a block to edit · double-tap to bypass · drag to move · 1–8: scenes · ← →: presets",
    "Touche une case vide (+) pour ajouter un bloc.": "Tap an empty slot (+) to add a block.",
    "Toutes les scènes": "All scenes",
    "toutes scènes": "all scenes",
    "scène": "scene",

    /* catégories / paramètres */
    "Dynamique": "Dynamics",
    "Ampli": "Amp",
    "Égaliseur": "EQ",
    "Utilitaire": "Utility",
    "Overdrive": "Overdrive",
    "Modulation": "Modulation",
    "Cab / IR": "Cab / IR",
    "Entrée": "Input",
    "Sortie": "Output",
    "Niveau": "Level",
    "Volume": "Volume",
    "Master": "Master",
    "Présence": "Presence",
    "Gain": "Gain",
    "Decay": "Decay",
    "Pre-delay": "Pre-delay",
    "Mix": "Mix",
    "Tone": "Tone",
    "Low Cut": "Low Cut",
    "High Cut": "High Cut",
    "Tempo": "Tempo",
    "BPM": "BPM",
    "Mode": "Mode",
    "Action": "Action",
    "Appui": "Press",
    "Maintien": "Hold",
    "LED": "LED",
    "Cible": "Target",
    "Courbe": "Curve",
    "Min": "Min",
    "Max": "Max",
    "Valeur": "Value",
    "Linéaire": "Linear",
    "Footswitch": "Footswitch",
    "Footswitchs": "Footswitches",
    "maintien :": "hold:",
    "appui :": "press:",
    "appui": "press",
    "Gauche": "Left",
    "Droite": "Right",
    "Scène précédente": "Previous scene",
    "Scène suivante": "Next scene",
    "Changer de mode (Preset/Scène/Stomp)": "Change mode (Preset/Scene/Stomp)",
    "Tester la course": "Test the sweep",
    "TALON": "HEEL",
    "POINTE": "TOE",
    "Talon": "Heel",
    "Pointe": "Toe",
    "Footswitch gauche": "Left footswitch",
    "Footswitch droite": "Right footswitch",
    "Seuil": "Threshold",
    "Profondeur": "Depth",
    "Attaque": "Attack",
    "Niveau": "Level",
    "Entrée": "Input",
    "Sortie": "Output",
    "Canal": "Channel",
    "Canaux": "Channels",
    "Vide": "Empty",
    "Nom": "Name",
    "Longueur": "Length",
    "Usine (demo)": "Factory (demo)",
    "Usine (démo)": "Factory (demo)",
    "Réponses impulsionnelles": "Impulse responses",
    "RÉPONSE EN FRÉQUENCE": "FREQUENCY RESPONSE",
    "FORME D’ONDE": "WAVEFORM",
    "Neural Amp Modeler A2, exécuté en mode Lite par la pédale · 48 kHz":
      "Neural Amp Modeler A2, run in Lite mode by the pedal · 48 kHz",
    "Importer des .nam": "Import .nam files",
    "Importe un fichier .nam (exporté par le trainer NAM ou téléchargé sur TONE3000). Prends la version A2 : la pédale l’exécute en mode Lite.":
      "Import a .nam file (exported by the NAM trainer or downloaded from TONE3000). Use the A2 version: the pedal runs it in Lite mode.",
    "Dépose un ou plusieurs fichiers .nam ici": "Drop one or more .nam files here",
    "Un fichier va dans le slot 1, plusieurs remplissent les slots libres suivants.":
      "One file goes into slot 1; several fill the next free slots.",
    "32 slots · 48 kHz mono · 2048 points max. Glisse un .wav sur la zone pour le charger.":
      "32 slots · 48 kHz mono · 2048 points max. Drop a .wav onto the area to load it.",
    "Dépose un fichier .wav ici": "Drop a .wav file here",
    "choisis un fichier": "choose a file",
    "Choisis un fichier": "Choose a file",
    "ou": "or",
    "— il ira dans le slot 1": "— it will go into slot 1",
    "Communs à tous les presets, envoyés immédiatement à la pédale.":
      "Shared by all presets, sent immediately to the pedal.",
    "ENTRÉE / SORTIE": "INPUT / OUTPUT",
    "Entrée / sortie": "Input / Output",
    "GAIN ENTRÉE": "INPUT GAIN",
    "Gain entrée": "Input gain",
    "EQ GLOBAL DE SORTIE": "GLOBAL OUTPUT EQ",
    "EQ global de sortie": "Global output EQ",
    "Bypass global des cabs / IR (vers un ampli)": "Global cab / IR bypass (to an amp)",
    "TEMPO & ACCORDEUR": "TEMPO & TUNER",
    "Tempo & accordeur": "Tempo & tuner",
    "Par preset": "Per preset",
    "BPM GLOBAL": "GLOBAL BPM",
    "BPM global": "Global BPM",
    "DIAPASON A4": "A4 REFERENCE",
    "Diapason A4": "A4 reference",
    "Recevoir les Program Change": "Receive Program Change",
    "Suivre l’horloge MIDI": "Follow MIDI clock",
    "Nom de l’appareil": "Device name",
    "Streaming audio Bluetooth": "Bluetooth audio streaming",
    "SYSTÈME": "SYSTEM",
    "Système": "System",
    "Plein écran auto (tactile)": "Auto fullscreen (touch)",
    "Interface de l’app": "App interface",
    "Tactile": "Touch",
    "LUMINOSITÉ": "BRIGHTNESS",
    "Luminosité": "Brightness",
    "Mise en veille": "Sleep",
    "Jamais": "Never",
    "Ligne": "Line",
    "Stéréo": "Stereo",
    "Dual mono": "Dual mono",
    "Redresseur": "Rectifier",
    "Étages": "Stages",
    "Forme": "Shape",
    "Vitesse": "Speed",
    "Demi-tons": "Semitones",
    "Détune": "Detune",
    "Tonalité": "Key",
    "Gamme": "Scale",
    "Intervalle": "Interval",
    "Usure": "Wear",
    "Largeur": "Width",
    "Ressorts": "Springs",
    "Micro": "Mic",
    "Over Drive": "Overdrive",
    "Normaliser": "Normalize",

    /* niveau du preset / foot */
    "Niveau du preset": "Preset level",
    "Ajuste le niveau de ce preset par rapport aux autres. Il est sauvé avec le preset, et reste actif quand tu changes de scène.":
      "Adjusts this preset’s level relative to the others. It is saved with the preset and stays active when you change scenes.",
    "Footswitchs & expression": "Footswitches & expression",
    "2 footswitchs (gauche / droite) : appui, maintien, et appui simultané G + D. Clique-les pour tester.":
      "2 footswitches (left / right): press, hold, and G + D together. Click them to test.",
    "Simuler l’appui simultané des deux footswitchs": "Simulate pressing both footswitches together",
    "Appui simultané G + D": "G + D together",
    "Réglage global, valable dans tous les modes. Par exemple, changer de mode ou ouvrir l’accordeur.":
      "Global setting, valid in all modes. For example, change mode or open the tuner.",
    "Passe en mode Stomp pour affecter librement ce switch (par preset).":
      "Switch to Stomp mode to freely assign this switch (per preset).",
    "Pédale d’expression (EXP 1)": "Expression pedal (EXP 1)",
    "— Aucune —": "— None —",
    "Pédale": "Pedal",
    "Pédale + ampli": "Pedal + amp",
    "Ampli + cab": "Amp + cab",
    "Pédale + ampli + cab": "Pedal + amp + cab",
    "Préampli": "Preamp",
    "High gain": "High gain",

    /* NAM */
    "Capture NAM": "NAM capture",
    "Aucune capture": "No capture",
    "Aucun fichier .nam": "No .nam file",
    "Remplacer le slot": "Replace slot",
    "Plus de slot NAM libre": "No free NAM slot",
    "Vider le slot NAM": "Clear NAM slot",
    "Vider le slot": "Clear slot",
    "Vider": "Clear",
    "Sur la pédale": "On pedal",
    "Pas encore envoyée": "Not sent yet",
    "Envoyer vers la pédale": "Send to pedal",
    "Renvoyer vers la pédale": "Send to pedal again",
    "Utiliser dans le preset": "Use in preset",
    "Envoyer quand même ?": "Send anyway?",
    "Poids introuvables dans le navigateur : réimporte le fichier": "Weights not found in the browser: re-import the file",
    "Pense à envoyer la capture vers la pédale": "Remember to send the capture to the pedal",
    "Remplacer l’ampli ?": "Replace the amp?",
    "Pas de place pour un bloc NAM Loader": "No room for a NAM Loader block",
    "Connecte la pédale pour envoyer la capture": "Connect the pedal to send the capture",
    "Capture envoyée dans le slot NAM": "Capture sent to NAM slot",
    "Capturé par": "Captured by",
    "Niveaux d’étalonnage": "Calibration levels",
    "entrée": "input",
    "Échantillonnage": "Sample rate",
    "Transfert estimé": "Estimated transfer",
    "Place utilisée dans le slot": "Slot usage",
    "Poids": "Size",
    "Format": "Format",
    "A2 · Lite sur la pédale": "A2 · Lite on pedal",
    "Architecture «": "Architecture “",
    "sous-modèle non WaveNet ou plusieurs « layer arrays »": "non-WaveNet submodel or multiple layer arrays",
    "noyaux / dilatations différents du A2 Lite": "kernels / dilations differ from A2 Lite",
    "tête / couches 1x1 différentes du A2 Lite": "head / 1x1 layers differ from A2 Lite",
    "activation autre que LeakyReLU": "activation other than LeakyReLU",
    "gating non supporté": "unsupported gating",
    "JSON illisible": "unreadable JSON",
    "conteneur A2 sans sous-modèle": "A2 container without submodel",
    "pas de poids dans le modèle": "no weights in the model",
    "poids invalides": "invalid weights",
    "Trop lourde :": "Too large:",
    "Aucun fichier .nam": "No .nam file",

    /* IR */
    "Réponse impulsionnelle": "Impulse response",
    "Réponse en fréquence": "Frequency response",
    "Forme d’onde": "Waveform",
    "IR chargée dans le slot": "IR loaded into slot",
    "Fichier audio illisible :": "Unreadable audio file:",
    "Connecte la pédale pour envoyer l’IR": "Connect the pedal to send the IR",
    "Aucun bloc IR Loader dans ce preset": "No IR Loader block in this preset",
    "IR envoyée dans le slot": "IR sent to slot",
    "Remplacer le slot": "Replace slot",
    "Glisse un .wav sur la zone pour le charger.": "Drop a .wav onto the area to load it.",

    /* global / appareil */
    "Réglages globaux": "Global settings",
    "Réglages": "Settings",
    "Noise gate d’entrée": "Input noise gate",
    "Mettre à jour la pédale": "Update the pedal",
    "Recharger les presets d’usine": "Reload factory presets",
    "Presets d’usine rechargés": "Factory presets reloaded",
    "Baffle": "Cabinet",
    "Combo": "Combo",
    "Rechercher une mise à jour": "Check for updates",
    "Ouvrir l’installateur": "Open the installer",
    "Plus tard": "Later",
    "Coupe le souffle de l’entrée quand tu ne joues pas, sur tous les presets (même sans bloc Gate). Baisse le seuil si les fins de notes sont coupées.": "Mutes input hiss when you are not playing, on every preset (even without a Gate block). Lower the threshold if note tails get cut.",
    "Actif": "On",
    "Seuil": "Threshold",
    "Mode de sortie": "Output mode",
    "Casque": "Headphones",
    "Informations": "Information",
    "Modèle": "Model",
    "Firmware": "Firmware",
    "Bootloader": "Bootloader",
    "Matériel": "Hardware",
    "N° de série": "Serial number",
    "Processeur": "Processor",
    "Slots IR": "IR slots",
    "Batterie": "Battery",
    "Bluetooth": "Bluetooth",
    "Protocole": "Protocol",
    "Mise à jour du firmware": "Firmware update",
    "Choisir un .bin": "Choose a .bin",
    "Flasher": "Flash",
    "Les mises à jour de firmware passent par l’installateur PC : le navigateur ne peut pas accéder au disque UBOOT de la pédale. L’installateur sauvegarde le firmware d’origine, installe TBBR, et permet de restaurer la sauvegarde.":
      "Firmware updates use the PC installer: the browser cannot access the pedal’s UBOOT disk. The installer backs up the original firmware, installs TBBR, and can restore the backup.",
    "Télécharger l’installateur PC": "Download PC installer",
    "Sauvegarde & restauration": "Backup & restore",
    "Sauvegarde complète": "Full backup",
    "Restaurer": "Restore",
    "Réinitialisation usine": "Factory reset",
    "Presets dans la pédale": "Presets on the pedal",
    "Copier tous les presets dans la pédale": "Copy all presets to the pedal",
    "Profil de connexion (CFW)": "Connection profile (CFW)",
    "Préfixe du nom BLE": "BLE name prefix",
    "Service GATT": "GATT service",
    "Caract. RX (écriture)": "RX characteristic (write)",
    "Caract. TX (notif.)": "TX characteristic (notify)",
    "Débit USB série": "USB serial baud rate",
    "Console protocole": "Protocol console",
    "Temps réel": "Live stream",
    "Pause": "Pause",
    "Exporter le journal": "Export log",
    "Effacer": "Clear",
    "Envoyer": "Send",
    "Aucune pédale connectée": "No pedal connected",
    "Déconnecter": "Disconnect",
    "Connecter": "Connect",
    "Démo": "Demo",
    "USB": "USB",
    "Sans fil : répète, scène, canapé.": "Wireless: rehearsal, stage, couch.",
    "Sans pilote, PC et Android : IR, NAM, presets, mises à jour.": "Driverless, PC and Android: IR, NAM, presets, updates.",
    "Pédale simulée": "Simulated pedal",
    "Pour tester l’interface sans matériel.": "To test the interface without hardware.",
    "Simuler l’écran de la pédale (240 × 240)": "Simulate the pedal screen (240 × 240)",
    "Branche la pédale en USB et ne la débranche pas pendant le flash. Le bootloader d’origine reste intact : en cas de souci, la pédale redémarre en mode récupération.":
      "Connect the pedal by USB and do not unplug it during flashing. The original bootloader stays intact: if anything goes wrong, the pedal restarts in recovery mode.",
    "aucun fichier": "no file",
    "Tous les presets, les réglages globaux, les IR utilisateur et les captures NAM dans un seul fichier.":
      "All presets, global settings, user IRs and NAM captures in a single file.",
    "Sans l’app, les footswitchs ne font défiler que les presets copiés dans la pédale.":
      "Without the app, the footswitches only scroll through presets copied to the pedal.",
    "arrêté": "off",
    "actif (non appairé)": "on (not paired)",
    "appairé": "paired",
    "présent": "present",
    "Liste des presets de la pédale illisible": "Pedal preset list unreadable",
    "La pédale n'a pas renvoyé son preset (réessaie)": "The pedal did not return its preset (try again)",
    "La pédale n'a pas pu sauver dans": "The pedal could not save to",
    "Batterie": "Battery",
    "Mode de sortie": "Output mode",
    "Réglages globaux": "Global settings",
    "Entrée guitare": "Guitar input",
    "Sortie principale": "Main output",
    "Casque": "Headphones",
    "Niveau du casque": "Headphone level",
    "Volume général": "Master volume",
    "Accordeur": "Tuner",
    "Accordeur chromatique": "Chromatic tuner",
    "Note": "Note",
    "Cents": "Cents",
    "Fréquence": "Frequency",
    "Aucun signal": "No signal",
    "Trop grave": "Too low",
    "Trop aigu": "Too high",
    "Juste": "In tune",

    /* accordeur / écran */
    "Joue une corde": "Play a string",
    "TUNER · 440 Hz": "TUNER · 440 Hz",
    "SAUVEGARDER DANS": "SAVE TO",
    "preset en cours": "current preset",
    "emplacement vide": "empty slot",
    "PARA : choisir · appui : OK": "PARA: select · press: OK",
    "HOME : annuler": "HOME: cancel",
    "DSP insuffisant": "Insufficient DSP",
    "Preset trop lourd": "Preset too heavy",

    /* erreurs / divers */
    "Stockage du navigateur plein : exporte une sauvegarde": "Browser storage full: export a backup",
    "Aucun appareil sélectionné": "No device selected",
    "Connexion impossible :": "Connection failed:",
    "Échec de connexion :": "Connection failed:",
    "Erreur :": "Error:",
    "Commande refusée par la pédale :": "Command refused by the pedal:",
    "Connecté à": "Connected to",
    "la pédale": "the pedal",
    "La pédale n'a pas changé de preset": "The pedal did not change preset",
    "La pédale n'a pas pu sauver le preset": "The pedal could not save preset",
    "Pédale non connectée": "Pedal not connected",
    "Pédale non connectée : modifications gardées dans le navigateur": "Pedal not connected: changes kept in the browser",
    "Un seul NAM par preset": "Only one NAM per preset",
    "Aucun fichier sélectionné": "No file selected",
    "Annuler": "Cancel",
    "Oui": "Yes",
    "Non": "No",
    "Fermer": "Close",
    "Confirmer": "Confirm",
    "Sauvegarder": "Save",
    "Choisir…": "Choose…",
    "Choisir un fichier": "Choose a file",
    "Télécharger": "Download",
    "Copier": "Copy",
    "Coller": "Paste",
    "Renommer": "Rename",
    "Dupliquer": "Duplicate",
    "Importer": "Import",
    "Exporter": "Export",
    "Réinitialiser": "Reset",
    "Tout effacer": "Clear all",
    "Retour": "Back",
    "Suivant": "Next",
    "Précédent": "Previous"
  };

  var PATTERNS = [
    [/^(\d+) blocs? · (\d+) parallèle\(s\) · DSP (\d+)%$/, function (m) {
      return m[1] + " block" + (m[1] === "1" ? "" : "s") + " · " + m[2] + " parallel · DSP " + m[3] + "%";
    }],
    [/^(\d+) blocs? · /, function (m) { return m[1] + " block" + (m[1] === "1" ? "" : "s") + " · "; }],
    [/^(\d+) parallèle\(s\)$/, function (m) { return m[1] + " parallel"; }],
    [/^(\d+) sections? parallèles?$/, function (m) { return m[1] + " parallel section" + (m[1] === "1" ? "" : "s"); }],
    [/^Pas de parallèle$/, function () { return "No parallel"; }],
    [/^Preset « (.+) » copié$/, function (m) { return "Preset “" + m[1] + "” copied"; }],
    [/^Preset « (.+) » sauvé dans la pédale$/, function (m) { return "Preset “" + m[1] + "” saved to the pedal"; }],
    [/^Preset « (.+) » réinitialisé$/, function (m) { return "Preset “" + m[1] + "” reset"; }],
    [/^Preset « (.+) » collé sur (.+)$/, function (m) { return "Preset “" + m[1] + "” pasted to " + m[2]; }],
    [/^(.+) copié · appui long sur une case vide pour le coller$/, function (m) { return m[1] + " copied · long-press an empty slot to paste"; }],
    [/^(.+) collé en (.+)$/, function (m) { return m[1] + " pasted to " + m[2]; }],
    [/^(.+) ajouté en (.+)$/, function (m) { return m[1] + " added to " + m[2]; }],
    [/^Sauvé dans (.+)$/, function (m) { return "Saved to " + m[1]; }],
    [/^Importé dans (.+)$/, function (m) { return "Imported into " + m[1]; }],
    [/^Copié vers (.+)$/, function (m) { return "Copied to " + m[1]; }],
    [/^Scène ([A-H]) seule$/, function (m) { return "Scene " + m[1] + " only"; }],
    [/^Scène ([A-H])$/, function (m) { return "Scene " + m[1]; }],
    [/^Scène ([A-H]) · (.+)$/, function (m) { return "Scene " + m[1] + " · " + m[2]; }],
    [/^Mode footswitch : (.+)$/, function (m) { return "Footswitch mode: " + m[1]; }],
    [/^(.+) · SCN ([A-H])$/, function (m) { return m[1] + " · SCN " + m[2]; }],
    [/^(\d+) % DSP$/, function (m) { return m[1] + "% DSP"; }],
    [/^DSP insuffisant pour (.+)$/, function (m) { return "Insufficient DSP for " + m[1]; }],
    [/^Un seul NAM par preset$/, function () { return "Only one NAM per preset"; }],
    [/^NAM trop lourd pour le 2e cœur \((\d+) %\)$/, function (m) { return "NAM too heavy for core 2 (" + m[1] + "%)"; }],
    [/^Preset trop lourd : (\d+) % DSP \(maximum 100\)\. Retire un bloc pour que la pédale puisse le jouer\.$/, function (m) {
      return "Preset too heavy: " + m[1] + "% DSP (max 100). Remove a block so the pedal can play it.";
    }],
    [/^Connecté via (.+)$/, function (m) { return "Connected via " + m[1]; }],
    [/^Connecté à (.+) · (.+)$/, function (m) { return "Connected to " + m[1] + " · " + m[2]; }],
    [/^« (.+) » → slot NAM (\d+)$/, function (m) { return "“" + m[1] + "” → NAM slot " + m[2]; }],
    [/^Envoi de « (.+) » → slot NAM (\d+) \((.+) Ko\)$/, function (m) { return "Sending “" + m[1] + "” → NAM slot " + m[2] + " (" + m[3] + " KB)"; }],
    [/^Capture envoyée dans le slot NAM (\d+)$/, function (m) { return "Capture sent to NAM slot " + m[1]; }],
    [/^(\d+) captures? importées?$/, function (m) { return m[1] + " capture" + (m[1] === "1" ? "" : "s") + " imported"; }],
    [/^(\d+) captures? importée$/, function (m) { return m[1] + " capture imported"; }],
    [/^« (.+) » → slot (\d+)$/, function (m) { return "“" + m[1] + "” → slot " + m[2]; }],
    [/^IR envoyée dans le slot (\d+)$/, function (m) { return "IR sent to slot " + m[1]; }],
    [/^IR affectée au bloc (.+)$/, function (m) { return "IR assigned to block " + m[1]; }],
    [/^Capture (\d+) affectée au bloc (.+)$/, function (m) { return "Capture " + m[1] + " assigned to block " + m[2]; }],
    [/^Poids ([\d\s.,]+) · ([\d.]+) Ko \/ ([\d.]+) Ko$/, function (m) { return "Size " + m[1] + " · " + m[2] + " KB / " + m[3] + " KB"; }],
    [/^(.+) Ko \/ (.+) Ko$/, function (m) { return m[1] + " KB / " + m[2] + " KB"; }],
    [/^Batterie de la pédale : (\d+) %$/, function (m) { return "Pedal battery: " + m[1] + "%"; }],
    [/^(.+) % · (.+) V$/, function (m) { return m[1] + "% · " + m[2] + " V"; }],
    [/^Inspirée de l'(.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^Inspirée de la (.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^Inspirée du (.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^Inspiré de l'(.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^Inspiré de la (.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^Inspiré du (.+)$/, function (m) { return "Inspired by the " + m[1]; }],
    [/^D'après (.+)$/, function (m) { return "Based on " + m[1]; }],
    [/^(\d+) octets en ([\d.]+) s, CRC32 (.+)$/, function (m) { return m[1] + " bytes in " + m[2] + " s, CRC32 " + m[3]; }],
    [/^(\d+) \/ (\d+) actuellement$/, function (m) { return m[1] + " / " + m[2] + " currently"; }],
    [/^(\d+) preset\(s\) copié\(s\)$/, function (m) { return m[1] + " preset(s) copied"; }],
    [/^(\d+) bauds$/, function (m) { return m[1] + " baud"; }],
    [/^(\d+) Ko$/, function (m) { return m[1] + " KB"; }],
    [/^(.+) bicœur (.+)$/, function (m) { return m[1] + " dual-core " + m[2]; }],
    [/^(.+) \(démo\)$/, function (m) { return m[1] + " (demo)"; }],
    [/^(.+) démo$/, function (m) { return m[1] + " demo"; }],
    [/^(\d+) %$/, function (m) { return m[1] + "%"; }],
    [/^(.+) · SCN ([A-H]) · (.+)$/, function (m) { return translate(m[1]) + " · SCN " + m[2] + " · " + translate(m[3]); }],
    [/^(.+) · SCN ([A-H]) (.+) · (.+)$/, function (m) { return translate(m[1]) + " · SCN " + m[2] + " " + translate(m[3]) + " · " + m[4]; }],
    [/^SLOT (\d+) — VIDE$/, function (m) { return "SLOT " + m[1] + " — EMPTY"; }],
    [/^Slot (\d+) — vide$/, function (m) { return "Slot " + m[1] + " — empty"; }],
    [/^(\d+) \/ (\d+) slots · (.+)$/, function (m) { return m[1] + " / " + m[2] + " slots · " + translate(m[3]); }],
    [/^Canal (\d+)$/, function (m) { return "Channel " + m[1]; }],
    [/^ou choisis un fichier — il ira dans le slot (\d+)$/, function (m) { return "or choose a file — it will go into slot " + m[1]; }],
    [/^— il ira dans le slot (\d+)$/, function (m) { return "— it will go into slot " + m[1]; }],
    [/^(Gauche|Droite) · (.+)$/, function (m) { return (m[1] === "Gauche" ? "Left" : "Right") + " · " + translate(m[2]); }],
    [/^maintien : (.+)$/, function (m) { return "hold: " + translate(m[1]); }],
    [/^appui : (.+)$/, function (m) { return "press: " + translate(m[1]); }],
    [/^G \+ D : (.+)$/, function (m) { return "G + D: " + translate(m[1]); }],
    [/^(.+) · SCN ([A-H])$/, function (m) { return translate(m[1]) + " · SCN " + m[2]; }],
    [/^(.+) · (.+)$/, function (m) { return translate(m[1]) + " · " + translate(m[2]); }]
  ];

  var ATTRS = ["title", "placeholder", "aria-label", "alt"];
  var textState = new WeakMap();
  var attrState = new WeakMap();
  var applying = false;

  function norm(s) {
    return String(s).replace(/[’‘]/g, "'").replace(/\u00A0/g, " ");
  }

  var EN_NORM = Object.create(null);
  Object.keys(EN).forEach(function (k) { EN_NORM[norm(k)] = EN[k]; });

  function translate(s) {
    var m = String(s).match(/^(\s*)([\s\S]*?)(\s*)$/);
    if (!m) return s;
    var core = m[2];
    if (!/[A-Za-zÀ-ÿ]/.test(core)) return s;
    var n = norm(core);
    var exact = EN_NORM[n];
    if (exact) return m[1] + exact + m[3];
    for (var i = 0; i < PATTERNS.length; i++) {
      var re = PATTERNS[i][0];
      if (re.test(n)) {
        var out = n.replace(re, function () {
          var a = Array.prototype.slice.call(arguments, 0, 8);
          return PATTERNS[i][1](a);
        });
        return m[1] + out + m[3];
      }
    }
    return s;
  }

  function skip(node) {
    var el = node.nodeType === 1 ? node : node.parentElement;
    return !!(el && el.closest && el.closest("[data-no-i18n],script,style,textarea"));
  }

  function applyText(node) {
    if (skip(node)) return;
    var cur = node.nodeValue;
    if (!cur || !/[A-Za-zÀ-ÿ]/.test(cur)) return;
    var st = textState.get(node);
    if (lang === "fr") {
      if (st && cur === st.en) {
        if (st.fr !== cur) node.nodeValue = st.fr;
      } else if (!st || cur !== st.fr) textState.set(node, { fr: cur, en: translate(cur) });
      return;
    }
    if (st && cur === st.en) return;
    var fr = cur;
    var en = translate(fr);
    textState.set(node, { fr: fr, en: en });
    if (en !== fr) node.nodeValue = en;
  }

  function applyAttr(el, name) {
    if (!el.hasAttribute || !el.hasAttribute(name) || skip(el)) return;
    var cur = el.getAttribute(name);
    if (!cur || !/[A-Za-zÀ-ÿ]/.test(cur)) return;
    var st = attrState.get(el);
    if (!st) { st = {}; attrState.set(el, st); }
    var a = st[name];
    if (lang === "fr") {
      if (a && cur === a.en) {
        if (a.fr !== cur) el.setAttribute(name, a.fr);
      } else if (!a || cur !== a.fr) st[name] = { fr: cur, en: translate(cur) };
      return;
    }
    if (a && cur === a.en) return;
    var fr = cur, en = translate(fr);
    st[name] = { fr: fr, en: en };
    if (en !== fr) el.setAttribute(name, en);
  }

  function applyElement(el) {
    if (!el || el.nodeType !== 1 || skip(el)) return;
    var i, j, n;
    for (i = 0; i < ATTRS.length; i++) if (el.hasAttribute(ATTRS[i])) applyAttr(el, ATTRS[i]);
    var els = el.querySelectorAll("*");
    for (j = 0; j < els.length; j++) {
      if (skip(els[j])) continue;
      for (i = 0; i < ATTRS.length; i++) if (els[j].hasAttribute(ATTRS[i])) applyAttr(els[j], ATTRS[i]);
    }
    var walker = document.createTreeWalker(el, NodeFilter.SHOW_TEXT, {
      acceptNode: function (n) { return skip(n) ? NodeFilter.FILTER_REJECT : NodeFilter.FILTER_ACCEPT; }
    });
    while ((n = walker.nextNode())) applyText(n);
  }

  function applyAll() {
    applying = true;
    try {
      applyElement(document.body);
      document.title = translate(document.title);
      var md = document.querySelector('meta[name="description"]');
      if (md) applyAttr(md, "content");
    } finally { applying = false; }
  }

  var lang = localStorage.getItem("tbbr.lang");
  if (lang !== "fr" && lang !== "en") lang = (navigator.language || "fr").toLowerCase().indexOf("fr") === 0 ? "fr" : "en";

  function setLang(l) {
    lang = l === "fr" ? "fr" : "en";
    try { localStorage.setItem("tbbr.lang", lang); } catch (e) {}
    document.documentElement.lang = lang;
    updateButton();
    applyAll();
  }

  function updateButton() {
    var b = document.getElementById("langBtn");
    if (!b) return;
    b.textContent = lang === "en" ? "EN" : "FR";
    b.title = lang === "en" ? "Language: English (click for French)" : "Langue : français (cliquer pour l'anglais)";
  }

  window.addEventListener("storage", function (e) {
    if (e.key === "tbbr.lang" && (e.newValue === "fr" || e.newValue === "en") && e.newValue !== lang) {
      lang = e.newValue;
      document.documentElement.lang = lang;
      updateButton();
      applyAll();
    }
  });

  window.tbbrI18n = {
    get lang() { return lang; },
    setLang: setLang,
    t: function (fr, en) { return lang === "en" ? en : fr; },
    translate: translate
  };

  var observer = null;
  function startObserver() {
    if (observer || !document.body) return;
    observer = new MutationObserver(function (muts) {
      if (applying) return;
      applying = true;
      try {
        for (var i = 0; i < muts.length; i++) {
          var m = muts[i];
          if (m.type === "characterData") applyText(m.target);
          else if (m.type === "attributes") applyAttr(m.target, m.attributeName);
          else {
            for (var j = 0; j < m.addedNodes.length; j++) {
              var n = m.addedNodes[j];
              if (n.nodeType === 1) applyElement(n);
              else if (n.nodeType === 3) applyText(n);
            }
          }
        }
      } finally { applying = false; }
    });
    observer.observe(document.body, {
      subtree: true, childList: true, characterData: true,
      attributes: true, attributeFilter: ATTRS
    });
    window.__i18nObserver = observer;
  }

  function start() {
    document.documentElement.lang = lang;
    updateButton();
    applyAll();
    startObserver();
    var b = document.getElementById("langBtn");
    if (b && !b.__i18nBound) {
      b.__i18nBound = true;
      b.addEventListener("click", function () { setLang(lang === "en" ? "fr" : "en"); });
    }
  }

  window.__i18nApply = applyAll;
  window.__i18nApplyText = applyText;
  window.__i18nState = function (node) { return textState.get(node); };
  if (document.readyState === "loading") document.addEventListener("DOMContentLoaded", start);
  else start();
})();
