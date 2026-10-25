# Natural first-use HomePage gates: HelpScript $91 and $92

## Findings

Two natural first-use routes through `Tutorial_GateHomepage` (48:498C) are confirmed in mGBA for the exact seed saves below. The runs use ordinary recorded button inputs, the Mobile Adapter emulator, and fake Internet. No forced inputs, RAM/SRAM pokes, ROM patch, or hardware claim is involved.

The gate calls HelpScript `$91` at 48:49A9.

Eleven consecutive captures (`page_00`–`page_10`) show the HomePage tutorial; `page_11` is the browser start-choice menu after the script returns.

The script stores its seen flag at `$A688`, and the gate advances `$A881` from 0 to 1.

Both complete macro replays produced 17 captures and all 17 image hashes match.

The separate Mail gate counter `$A89A` stays at 1.

From `browser_bookmarks.sav`, `$A881` begins at 1. The gate calls HelpScript `$92` at 48:49B6. Five consecutive captures (`page_00`–`page_04`) show the PageList tutorial; `page_05` is the browser start-choice menu after return. The script stores its seen flag at `$A689`, and `$A881` advances from 1 to 2. Both complete macro replays produced 9 captures and all 9 image hashes match. `$A89A` stays at 6.

The ROM source places the HomePage stream at 6C:5433 and PageList at 6C:56F4; their terminal stores are `$10,$04,$01` at 6C:56EE and `$10,$05,$01` at 6C:58C0. Help-script variables begin at SRAM `$A684`, so vars 4 and 5 map to `$A688` and `$A689`. Dynamic traces record writes spanning `$A688–A689` and `$A689–A68A`, respectively, plus the gate-counter write at `$A881–A882`. The merged ROM data-read spans cross adjacent stream/glyph boundaries; they do not independently establish exact stream limits. Source dispatch, gate call sites, rendered screens, observed return, and SRAM effects together support the route association.

This confirms the observed route and its complete rendered topic on those seed states, not every HelpScript branch or all possible gate states. The counter's other values and aborted-script paths remain bounded by static analysis in `ram/banked.asm` and `engine/tutorial/gates.asm`.
