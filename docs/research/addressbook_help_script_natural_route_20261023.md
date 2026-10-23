# Natural AddressBook HelpScript route (2026-10-23)

## Result

The AddressBook HelpScript route is **CONFIRMED** for the observed natural `browser_pagelist` save. Ordinary inputs open Help page 2, move to cursor 2, and select the unlocked AddressBook topic. `HelpMenu_OnA` returns ID `$0A`; 13 consecutive AddressBook screens render, and the next A returns to the Help page-2 menu. The bounded run stops on that first return. No `force`, `ramset`, SRAM poke, or ROM change was used.

The topic begins at `6C:51AA` and displays the `アドレスちょう` title. Its terminal block at `6C:542D` stores script variable 3 (`10 03 01`), mapped to SRAM bank 1 `$A687`, before the stream ends at `6C:58C6`. The dynamic data-access trace records bank-1 write span `$A687–$A688`, and the screenshots show the natural topic entry and complete screen sequence through return. Together these confirm the `sHelpSeenAddressBook` association. The seed already had `$A687=1`, so this run does not demonstrate a 0-to-1 transition.

An early B press at the introductory page also returns to the menu, but it skips the rest of the topic and does not exercise the terminal store. A separate exploratory run with an invalid adapter-config path rendered unrelated login-ID/email forms; it is excluded from this result. A corrected longer exploration continued after the first return and re-entered the topic; only the first 14 captures are counted here.

This does not establish the first-use gate variant (`$8A`), every conditional branch, or hardware behavior.

## SRAM and replay evidence

The natural seed's bank-1 bytes `$A684–$A68B` are `92 01 01 01 01 01 00 00`; after the bounded route they are `0a 01 01 01 01 01 00 00`. Within that block, only the selected script ID changed, from `$92` to `$0A`; other save/checksum bytes also changed during execution. `$A687` remained 1. The bounded run contains 14 screenshots: 13 AddressBook topic screens (`page_00`–`page_12`) and the page-2 menu return (`page_13`). All images are byte-identical to the corresponding prefix of the longer corrected replay.

The emulator exited 0 at frame 12064 after 55,317,248 instructions. It used the original Japanese ROM, the naturally obtained `browser_pagelist` SRAM/config, mobile on, fake network and ordinary A/D-pad inputs. This is emulator evidence, not hardware evidence.

## Reproduction

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`.

```sh
./.cache/trace/mgba_trace --rom 'Mobile Trainer (Japan).gbc' --scenario help_addressbook_bounded --outdir .tmp/jp-help-addressbook-natural-20261023/run-bounded --frames 13000 --macro .tmp/jp-help-addressbook-natural-20261023/addressbook_bounded.macro --record-input .tmp/jp-help-addressbook-natural-20261023/addressbook_bounded.txt --mobile on --net fake --mobile-config-in .tmp/jp-help-unlock-followup-20261023/state/help_after_page_list_v2.cfg --save-in .tmp/jp-help-unlock-followup-20261023/state/help_after_page_list_v2.sav --save-out .tmp/jp-help-addressbook-natural-20261023/run-bounded/addressbook_return.sav --shots .tmp/jp-help-addressbook-natural-20261023/run-bounded/shots
```

Private evidence manifest: `.tmp/jp-help-addressbook-natural-20261023/MANIFEST.json`, SHA-256 `73520b71ae81e07b4b9ffeab939b07385d309424d3182b0ad17c4045ead6bcbb`. It records command, ROM/tool/config/seed/input/output/stats/data-access hashes and all screenshot hashes.
