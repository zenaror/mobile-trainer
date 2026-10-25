# Bank 5C communication-error palettes and sprite structure

> Status: **reference (current)**. Consumer-driven typing of the exact 223-byte interval 5C:6350–642F. The original bytes and all existing symbols are preserved.

| Range, end exclusive | Meaning | Bytes |
| --- | --- | ---: |
| 6350–6390 | Timer BG palette, 32 RGB555 words | 64 |
| 6390–63D0 | BG palette, 32 RGB555 words | 64 |
| 63D0–6410 | OBJ palette, 32 RGB555 words | 64 |
| 6410–6414 | Two frame pointers | 4 |
| 6414–6425 | Count four and four OAM pieces | 17 |
| 6425–6426 | Empty frame, count zero | 1 |
| 6426–642B | Two frame-index/delay steps | 5 |
| 642B–642F | Frame-table/script-pointer object entry | 4 |

Palette callers 5C:51DB, 51EC and 52E1 explicitly pass bank5C, BC=$0040 and the BG/OBJ palette-buffer destination. They select BG6390 (145 hits/23 scenarios), OBJ63D0 (145/23) and timer BG6350 (68/14), respectively. Palette_LoadToBuffer at4F:4000 selects WRAM7 and forwards the source bank through hFarBank to CopyBytes. Each RGB555 word remains identical to the original ROM. Palette copying establishes the content contract independently of the previous tile heuristic.

Sprite_InitSlot at5C:52C7 receives wSpriteSlot1, DE=$642B, A=$5C and B=$80, selecting looping entry0. It runs68 times across14 natural scenarios. Entry bytes10 64 26 64 point to the frame table6410 and script6426. The table contains6414 and6425. Script bytes02 00 0C 01 0C select frames0/1 with delay12. Sprite_UpdateAll selects the slot's recorded ROM bank; Sprite_StepAndDrawSlot at00:0AE8/0B9D reads the count and four-byte OAM records in that bank.

## Preserving the interior attribute symbol

`CommErr_Frame0_Piece2Attr::` denotes the third piece's attribute byte at bank5C:6420. It remains a real source symbol at that address. The existing sprite_oam macro emits all four bytes together and cannot place this literal label between its operands. A macro-generated alias would also escape the source-symbol scanner.

The file-local commerr_sprite_oam_prefix helper asserts exactly three arguments and a positive piece counter, decrements that counter once and emits Y/X/tile. Its sole call is followed by the literal existing attribute label and `db $08`; the fourth piece uses sprite_oam normally. Counter progression is4→3→2→1→0. An explicit assertion checks closure and another checks the attribute's offset12 from the new neutral `SpriteFrame_5C_6414`. PURGE removes the helper before the empty frame. The animation counter closes2→1→0. Shared macros remain unchanged.

The old208-byte tile heuristic at6350–6420 combined palettes with part of a sprite. The old comment that6420 was not reached by a walked sprite chain is contradicted by the complete natural OAM reads. Eight exact headers now replace those two mixed headers. All nine prior exported labels retain their bank/address; only the first frame's neutral label is added. No engine instruction or operand changes.

The separate bank6A palette/OAM contradiction and structured macro at72A0 also remain open.
