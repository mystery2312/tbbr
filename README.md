# TBBR — The Big Black Rig

Open firmware for the **M-VAVE BlackBox** multi-effects pedal (JieLi AC791N chip), with its editor (Windows and Android) and its installer.

- **NAM A2 Lite** captures played natively in real time (both cores, 396 MHz)
- Factory cabinets as real impulse responses, plus 32 slots for your own IRs
- Modeled amps and pedals, 2 × 8 block grid with parallel sections, 8 scenes per preset
- 80 presets stored in the pedal, tuner, LED level meter, global input noise gate
- Editor in French and English over USB MIDI, one-click updates from GitHub Releases

**Website and full documentation: https://mystery2312.github.io/tbbr/**

> ⚠️ **Experimental project.** TBBR is independent and neither affiliated with nor endorsed by M-VAVE. The installation procedure is reasonably under control (full verified backup before any write, bootloader never modified, every sector read back, way back to the M-VAVE firmware), but **you install and use TBBR at your own risk**. Neither the authors nor M-VAVE can be held liable for any damage to your pedal or loss of data.

## Install

1. Your pedal must run the official M-VAVE firmware **V19** (install it with M-UPGRADE if it runs 022/023 — see the [documentation](https://mystery2312.github.io/tbbr/doc.html#v19-en)).
2. Download **BlackBox_TBBR_App.exe** from the [latest release](../../releases/latest) (Windows 10/11, single file).
3. Connect the pedal directly by USB (no hub) and close M-UPGRADE.
4. In the app: **Device → Open the installer**, then **Back up**, then **Install**.

**Updates:** the app shows an "Update the pedal" banner when a new release is out, or drop the release's `TBBR_fw6_x.y.tbbr` file into the installer. Presets, IRs and NAM captures are kept.

**Android:** `TBBR_Android.apk` in the releases is the same editor for phones and tablets (USB OTG). Firmware installation and updates require the Windows PC.

## Repository layout

| Folder | Content |
|---|---|
| `fw_maison/fw6/` | Firmware (C and pi32v2 assembly) |
| `fw_maison/reboot/` | Tiny RAM program that restarts the chip after a write |
| `interface/app/` | Editor (plain HTML/JS); `interface/tests/` protocol test tools |
| `installer/` | Windows firmware installer (Python; HTML UI served locally) and `.tbbr` update packages |
| `electron/` | Desktop app (Electron) bundling the editor and the installer |
| `android/` | Android app (WebView + native USB MIDI bridge) bundling the editor |
| `scripts/` | `bb_tool.py` (UBOOT access: backup, write, restart), `mkfw.py` (JieLi flash format) |
| `third_party/` | USB loader (MIT) and factory cabinet IRs (CC0 / CC BY 4.0) |
| `docs/` | Website (GitHub Pages) and documentation |

## Build

- **Firmware**: requires the JieLi `pi32` toolchain (clang for pi32v2), distributed with JieLi's AC79 SDK and not included here. Point `JL_PI32` to it, then run `powershell -File fw_maison\fw6\build.ps1` (Python 3 and Node.js required).
- **Everything** (firmware → installer → desktop app → website): `powershell -File build_all.ps1` (PyInstaller in `..\venv`, `npm install` in `electron/`).
- **Android**: `powershell -File android\build_apk.ps1` (Android SDK, JDK 17+).
- **Release**: bump `FW_VERSION` in `fw_maison/fw6/main.c` and `version` in `electron/package.json`, then `powershell -File release.ps1`.
- **Beta**: set a version like `0.9.5-beta.1` in `electron/package.json`, then `powershell -File beta.ps1`. It builds and publishes only to the private `mystery2312/tbbr-beta` repository; `release.ps1` refuses beta versions.

## License

GPL-3.0 (see `LICENSE`). Third-party components and credits: `THIRD_PARTY.md`. M-VAVE and BlackBox are trademarks of their respective owners.
