# Natural Mail HelpScript route (2026-10-23)

## Finding

The Mail HelpScript topic is **CONFIRMED** on the observed natural `browser_pagelist` save. Ordinary menu inputs select Help page 2 cursor 1 and enter Mail topic ID `$09`. Thirty-one consecutive Mail screens render (`page_00`–`page_30`); the next A returns to the Help page-2 menu (`page_31`). No `force`, `ramset`, SRAM poke or ROM modification was used.

The topic starts at `6C:4BC2`, with caption `メール` at `6C:4BC9`. Its terminal block at `6C:51A4` stores script variable 2 (`10 02 01`) to SRAM bank 1 `$A686`; the following `$04,$1C,$07` branch reaches END at `6C:58C6`. The dynamic trace records writes at bank-1 `$A684–$A685` and `$A686–$A687`. The two complete replays each render 32 captures, and all 32 PNGs match byte-for-byte. Together, the natural menu entry, title, complete topic sequence, terminal store, SRAM write span and return confirm the Mail flag/topic association.

The seed already contained `$A686=1`; it remains 1 after the route. This evidence does not demonstrate a 0-to-1 transition. The selected script ID changes from `$92` to `$09` at `$A684`; the other bytes in `$A684–$A68B` do not change. This is emulator evidence, not hardware evidence, and it does not establish the first-use gate variant `$89` or every conditional branch.

## Reproduction

ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Local linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`. Adapter config SHA-256: `45fdd476f1adf5c1d87aedaeda675d11f610ab7d7d056231f955aff71c4769ef`. Natural seed save SHA-256: `7ad305f31a96c3726e5d319741be0b780eb38d4664b5518346da2a072ca52f19`.

The complete run ended at frame 23412 after 99,562,533 instructions. The `waitstable` macro command hit its 600-frame cap on captures; the fixed input sequence still emitted all screenshots, and an independent complete replay reproduced all 32 images byte-for-byte. A separate 13,000-frame recheck ended after 15 captures and is excluded as incomplete.

Private evidence manifest: `.tmp/jp-help-mail-natural-20261023/MANIFEST_recheck.json`, SHA-256 `32224dfb6a565e84550ce092c903a65414f54c15b89aca0f13d4414e39cd5a7f`. It records the command, runtime/input hashes, both replay capture hashes, SRAM before/after bytes, dynamic write spans and limitations.
