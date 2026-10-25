# Natural HomePage HelpScript route (2026-10-23)

## Result

The unlocked Help menu path to the HomePage topic is now **CONFIRMED** for the observed natural save state. From the `browser_pagelist` save, ordinary buttons open Help page 3 and select its first item. `HelpMenu_OnA` returns ID `$11` for page 3, cursor 1; the script displays 14 consecutive HomePage screens, then the next A returns to the page-3 menu. The final menu-return screenshot is at frame 12678. No `force`, `ramset`, SRAM poke, or ROM change was used.

This supplies a natural menu entry and full rendered sequence for the HomePage Help topic on this state. It does not establish the first-use gate variant (`$91`), other HelpScript topics, every conditional branch, or hardware behavior.

## SRAM and naming evidence

The seed's SRAM bank 1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the route they are `11 01 01 01 01 01 00 00`. Only file offset `$2684` changed, from the selected script ID `$92` to `$11`; the HomePage flag at `$A688` was already 1 in the seed. The dynamic data-access output reports a write span at bank 1 `$A688–$A689`; the source tail at `6C:56EE` stores script variable 4, which maps to `$A688`. The rendered topic title, selected menu item, source store, dynamic write span, and return to the menu together confirm the `sHelpSeenHomepage` association. The saved state does not demonstrate a 0-to-1 transition because the input save already had that flag set. The existing `sHelpSeenPageList` confidence remains unchanged.

## Reproduction

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`.

```sh
./.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario help_homepage_topic_complete --outdir run-final --frames 14000 --macro homepage_topic_complete.macro --record-input homepage_topic_complete.txt --mobile on --net fake --mobile-config-in help_after_page_list_v2.cfg --save-in help_after_page_list_v2.sav --save-out homepage_complete.sav --shots shots
```

The completed macro generated 15 captures: 14 topic screens (`page_00`–`page_13`) and the return menu (`page_14`). Each capture is 634 frames after the preceding one. The emulator exited 0 at frame 12678 after 58,381,402 instructions. The 15 images reproduce byte-for-byte against the corresponding prefix of a longer exploratory replay; that longer replay continued into the topic again after the menu returned, so the repeated pages are not counted as part of the 14-page sequence.

Private checksum manifest: `MANIFEST.json` (review artifact), SHA-256 `4dc4e86faad30cb50de8afae49d21126541fc294d4f3b1675fd077460da09d2e`. It records the command, ROM/tool/library/save/config/input/output hashes, all 15 screenshot hashes, counters, and observed SRAM bytes. The final stats, coverage, data-access report and saved SRAM are retained beside the screenshots under `run-final` (review artifact).
