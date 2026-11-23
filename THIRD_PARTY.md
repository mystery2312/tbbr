# Third-party components

TBBR's own code is released under **GPL-3.0** (see `LICENSE`). It includes or uses the following components, under their own licenses:

| Component | Location | License | Source |
|---|---|---|---|
| USB and flash drivers from the JieLi AC79 SDK (LLVM IR extracted from `cpu.a`) | `fw_maison/fw6/sdk/*.ll` | Apache-2.0 (`fw_maison/fw6/sdk/LICENSE-JieLi-SDK-Apache-2.0.txt`) | Gitee `Jieli-Tech/fw-AC79_AIoT_SDK` |
| `CORE_SYSTEM_RESET` restart recipe (one register write) | `fw_maison/reboot/reboot.c` | Apache-2.0 (JieLi SDK, `cpu/wl82/p33.c`) | same |
| `wl82loader.bin` (WL82 mask ROM USB loader) and the SCSI/loader protocol in `bb_tool.py` | `third_party/jl-uboot-tool/`, `scripts/bb_tool.py` | MIT (`third_party/jl-uboot-tool/LICENSE`) | https://github.com/kagaimiq/jl-uboot-tool (commit adb3f18) |
| Cabinet IRs "Jester's Brutal Pack" (4 IRs, Vintage 30 / G12F) | `third_party/irs/jester-brutal/` → factory cabinets | CC0 1.0 (public domain) | Jester Dyne Productions, https://jester-dyne-productions.com |
| Orbit cabinet IRs (7 synthesized cabinets: 4x12, 2x12, 1x12, 4x10) | `third_party/irs/darwinscat-orbit/` → factory cabinets | **CC BY 4.0** — IR: Darwin's Cat, darwinscat.com (truncated to 1,024 samples and level-normalized) | https://darwinscat.com/felitronics/ir/guitar-cab-free-irs |
| Inter font | `interface/fonts/`, `installer/resources/ui/fonts/` | SIL OFL 1.1 (`OFL-Inter.txt`) | https://github.com/rsms/inter |
| JetBrains Mono font | `interface/fonts/` | SIL OFL 1.1 (`OFL-JetBrainsMono.txt`) | https://github.com/JetBrains/JetBrainsMono |

**Not included and not redistributed:** M-VAVE firmware files, the M-UPGRADE software, the JieLi toolchain (to be obtained separately, see README) and pedal backups.

M-VAVE and BlackBox are trademarks of their respective owners. TBBR is an independent project, neither affiliated with nor endorsed by M-VAVE. Amp and pedal names are only used to describe the intended sound.
