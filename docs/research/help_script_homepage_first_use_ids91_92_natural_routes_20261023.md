# Natural first-use HomePage gates: HelpScript $91 and $92 (2026-10-23)

## Findings

Two natural first-use routes through `Tutorial_GateHomepage` (48:498C) are confirmed in mGBA for the exact seed saves below. The runs use ordinary recorded button inputs, the Mobile Adapter emulator, and fake Internet. No forced inputs, RAM/SRAM pokes, ROM patch, or hardware claim is involved.

From `tutorial_profile.sav`, the gate counter `sTutorialGateHomepage` at SRAM bank 1 `$A881` begins at 0. The gate calls HelpScript `$91` at 48:49A9. Eleven consecutive captures (`page_00`–`page_10`) show the HomePage tutorial; `page_11` is the browser start-choice menu after the script returns. The script stores its seen flag at `$A688`, and the gate advances `$A881` from 0 to 1. Both complete macro replays produced 17 captures and all 17 image hashes match. The separate Mail gate counter `$A89A` stays at 1.

From `browser_bookmarks.sav`, `$A881` begins at 1. The gate calls HelpScript `$92` at 48:49B6. Five consecutive captures (`page_00`–`page_04`) show the PageList tutorial; `page_05` is the browser start-choice menu after return. The script stores its seen flag at `$A689`, and `$A881` advances from 1 to 2. Both complete macro replays produced 9 captures and all 9 image hashes match. `$A89A` stays at 6.

The ROM source places the HomePage stream at 6C:5433 and PageList at 6C:56F4; their terminal stores are `$10,$04,$01` at 6C:56EE and `$10,$05,$01` at 6C:58C0. Help-script variables begin at SRAM `$A684`, so vars 4 and 5 map to `$A688` and `$A689`. Dynamic traces record writes spanning `$A688–A689` and `$A689–A68A`, respectively, plus the gate-counter write at `$A881–A882`. The merged ROM data-read spans cross adjacent stream/glyph boundaries; they do not independently establish exact stream limits. Source dispatch, gate call sites, rendered screens, observed return, and SRAM effects together support the route association.

## Scope and reproduction evidence

This confirms the observed route and its complete rendered topic on those seed states, not every HelpScript branch or all possible gate states. The counter's other values and aborted-script paths remain bounded by static analysis in `ram/banked.asm` and `engine/tutorial/gates.asm`.

The immutable Japanese ROM SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; tracer SHA-256 is `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. The seed saves are the preserved `tutorial_profile.sav` fixture (SHA-256 `84a20c94e6f7d5f4c1e0d9905f22ab5046272c1b151ba04f4fd6c43ef161874a`) and `browser_bookmarks.sav` fixture (SHA-256 `3bab29651c18b77dc0b43028f9fa6225da9c23587cb02fe855ab8966a0cd9121`). Exact input macros, config/save hashes, every captured PNG, per-run outputs, SRAM results, and artifact hashes are recorded in `MANIFEST.json` (review artifact).
