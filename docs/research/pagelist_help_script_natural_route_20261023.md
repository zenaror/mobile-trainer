# Natural PageList HelpScript route (2026-10-23)

## Result

The PageList HelpScript menu route is **CONFIRMED** for the observed natural `browser_pagelist` save. Ordinary inputs open Help page 3, move to cursor 2, and select the unlocked PageList item. `HelpMenu_OnA` returns ID `$12`; seven consecutive PageList screens render, and the next A returns to the Help page-3 menu. The bounded run stops on that return screen. No `force`, `ramset`, SRAM poke, or ROM change was used.

The selected topic title and sequence match the static stream beginning at `6C:56F4`; its end block at `6C:58C0` stores script variable 5 (`10 05 01`), mapped to SRAM bank 1 `$A689`. The dynamic trace reports a write span at `$A689–$A68A`. This confirms the `sHelpSeenPageList` flag/topic association on the observed natural route. The seed already had `$A689=1`, so no 0-to-1 transition was observed.

This does not establish the first-use gate variant (`$92`), other HelpScript topics, every conditional branch, or hardware behavior.

## SRAM and replay evidence

The natural seed's bank-1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the bounded route they are `12 01 01 01 01 01 00 00`. Only the selected script ID changed within that eight-byte block; other save/checksum bytes also changed during the run. The A689 flag remained 1. The output contains eight screenshots: seven PageList screens (`page_00`–`page_06`) followed by the return menu (`page_07`). All eight PNGs are byte-identical to the corresponding prefix from a longer exploratory replay; that exploratory macro continued after return and is not used to count topic screens.

The emulator exited 0 at frame 8938 after 44,083,707 instructions. It used the original ROM and a naturally obtained `browser_pagelist` save/config, with mobile on, fake network and ordinary A/D-pad inputs. This is emulator evidence, not hardware evidence.

## Reproduction

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`.

```sh
./.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario help_pagelist_topic_bounded --outdir run-bounded --frames 10000 --macro pagelist_topic_bounded.macro --record-input pagelist_topic_bounded.txt --mobile on --net fake --mobile-config-in help_after_page_list_v2.cfg --save-in help_after_page_list_v2.sav --save-out pagelist_return.sav --shots shots
```

Private evidence manifest: `MANIFEST.json` (review artifact), SHA-256 `b60027ce27ae07a466fec3e8f4f0d227a8928e1df5cc3981a4ecb74515635f12`. It records ROM, tracer, seed, config, macro, input/output, stats, data-access and per-image hashes. The longer exploratory run and its excluded post-return re-entry remain under the same ignored task directory.
