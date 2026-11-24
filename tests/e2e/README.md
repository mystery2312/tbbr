# Tests de bout en bout TBBR

```
powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1          # tout (~40 s)
powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1 -Only app
```

## Ce qui est testé

```
 app réelle (interface/app, Edge headless)          ── app.test.js
        │  WebMIDI simulé, port « BlackBox Custom »
        ▼
 trames A5… dans des SysEx F0 7D 42 58 70 … F7       ── protocol.test.js
        │
        ▼
 émulateur de pédale (emu/out/pedal_emu.exe)
   = VRAI proto.c + engine.c + models.c + circuit.c du firmware fw6,
     compilés pour PC ; flash NOR 1 Mio simulée
```

- **static.test.js** : syntaxe JS, script inline de l'installateur, `docs/sim` à jour, `catalog.h` à jour, aucun fichier privé suivi par git.
- **protocol.test.js** : INFO et catalogue (coûts DSP firmware = `data.js`), banque d'usine, aller-retour de chaque preset d'usine, sauvegarde + redémarrage, budget DSP 115 %, IR, NAM (CRC), réglages globaux, Bluetooth, remise à zéro usine, scènes/bypass, trames corrompues. Chaque test vérifie aussi qu'aucune écriture flash ne s'est faite sans effacement.
- **app.test.js** : connexion USB et synchro, changement de preset, modification + sauvegarde (relue dans la flash), export/import d'un preset avec ses NAM/IR vers une autre pédale (remappage des slots), remise à zéro usine depuis l'app, mode démo sans message d'erreur.

## Limites de l'émulateur

- Le calcul NAM/A2L/AMX est en assembleur pi32v2 : son chargement échoue proprement dans l'émulateur (le bloc laisse passer le son). Le transfert, le CRC, les slots et les presets sont le vrai code.
- Pas de 2e cœur, d'écran, de footswitchs ni de timing réel : les coûts CPU et le son se vérifient sur la pédale (`interface/tests/dsp_bench.py`, `nam_check.py`).
- L'app servie aux tests reçoit une ligne en plus à la fin de son IIFE (`window.__t = src => eval(src)`), pour que les tests lisent son état ; le fichier `app.js` n'est pas modifié.
