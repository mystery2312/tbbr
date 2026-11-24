# Tests de bout en bout TBBR

```
powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1             # tout (~4 min)
powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1 -Only apk
powershell -ExecutionPolicy Bypass -File tests\e2e\run.ps1 -Packaged   # + vrais exe portables (~10 min)
```

`release.ps1` et `beta.ps1` lancent `run.ps1` : rien n'est publié si un test échoue.

## Architecture

```
 app web (Edge)     app de bureau (Electron réel)     APK : ses fichiers web + pont Android simulé
        \                     |                          /
         WebMIDI simulé « BlackBox Custom »   /   window.TBBRMidi (mêmes méthodes que MidiBridge.java)
                              |
        trames A5… dans des SysEx F0 7D 42 58 70 … F7
                              |
 émulateur de pédale (emu/out/pedal_emu.exe)
   = VRAI proto.c + engine.c + models.c + circuit.c du firmware fw6, compilés pour PC ;
     flash NOR 1 Mio simulée (effacement / écriture comme la vraie : écriture sans effacement détectée)
```

| Fichier | Ce qui est testé |
|---|---|
| `static.test.js` | syntaxe JS, installateur, `docs/sim` à jour, `catalog.h` à jour, rien de privé ni de cité à tort dans git |
| `protocol.test.js` | firmware : INFO/catalogue = `data.js`, banque d'usine, aller-retour des presets, sauvegarde + redémarrage, budget DSP, IR, NAM, empreintes CRC, réglages globaux, Bluetooth, remise à zéro, scènes, trames corrompues |
| `updater.test.js` | mise à jour de l'app Windows (`electron/updater.js`) : canaux stable/beta, SHA-256, remplacement de l'exe, nettoyage |
| `app.test.js` | app web : connexion, synchro, sauvegarde, export/import NAM+IR, remise à zéro, mode démo |
| `desktop.test.js` | app de bureau réelle : USB + sauvegarde, mise à jour auto (redémarrage, à la fermeture, fichier altéré, app non portable) |
| `apk.test.js` | APK : paquet (aapt2), fichiers web = éditeur actuel, tests JVM de la mise à jour Android, USB OTG, export vers Téléchargements, débranchement |
| `ensemble.test.js` | PC → téléphone → navigateur sur la même pédale : preset NAM+IR créé sur le PC, importé sur le téléphone, rejoué après redémarrage |
| `packaged.test.js` | (`-Packaged`) deux vrais exe portables : 0.9.90 se remplace par 0.9.91 |

## Limites

- Le calcul NAM/A2L/AMX est en assembleur pi32v2 : il ne tourne pas dans l'émulateur (le bloc laisse passer le son). Transfert, CRC, slots et presets sont le vrai code. Les coûts CPU et le son se vérifient sur la pédale.
- L'APK est testé sans téléphone : son code Java natif est couvert par les tests JVM (`UpdateLogicTest`) et par la simulation fidèle de `MidiBridge`. Un test sur appareil Android virtuel demande une image système (`sdkmanager "system-images;android-35;google_apis;x86_64"`).
- Les tests lisent l'état interne de l'app : la copie d'`app.js` servie aux tests reçoit `window.__t = src => eval(src)` (navigateur : interception Playwright ; app de bureau : serveur de `main.js` avec `TBBR_E2E=1`, jamais dans l'exe livré).
