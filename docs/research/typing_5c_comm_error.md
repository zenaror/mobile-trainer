# Bank 5C communication-error palettes and sprite structure

> Status: **reference (current)**. Consumer-driven typing of the exact 223-byte interval 5C:6350–642F. The original bytes and all existing symbols are preserved.

## Exact units and evidence

| Range, end exclusive | Meaning | Bytes | Natural read scenarios |
|---|---|---:|---:|
| 6350–6390 | Timer BG palette, 32 RGB555 words | 64 | 14 |
| 6390–63D0 | BG palette, 32 RGB555 words | 64 | 23 |
| 63D0–6410 | OBJ palette, 32 RGB555 words | 64 | 23 |
| 6410–6414 | Two frame pointers | 4 | 14 |
| 6414–6425 | Count four and four OAM pieces | 17 | 14 |
| 6425–6426 | Empty frame, count zero | 1 | 14 |
| 6426–642B | Two frame-index/delay steps | 5 | 14 |
| 642B–642F | Frame-table/script-pointer object entry | 4 | 14 |

Every byte in these eight exact units was naturally read. Their CONFIRMED headers follow complete-unit evidence rather than inheriting a larger heuristic classification. The three existing 64-byte palette catalog entries and matching README rows move from PROBABLE to CONFIRMED; their values, dimensions, paths and aliases remain unchanged. Existing natural coverage and `traces/detail/*/dataaccess.tsv` establish reads; no new runtime or hardware observation is asserted.

Palette callers 5C:51DB, 51EC and 52E1 explicitly pass bank5C, BC=$0040 and the BG/OBJ palette-buffer destination. They select BG6390 (145 hits/23 scenarios), OBJ63D0 (145/23) and timer BG6350 (68/14), respectively. Palette_LoadToBuffer at4F:4000 selects WRAM7 and forwards the source bank through hFarBank to CopyBytes. Each RGB555 word remains identical to the original ROM. Palette copying establishes the content contract independently of the previous tile heuristic.

Sprite_InitSlot at5C:52C7 receives wSpriteSlot1, DE=$642B, A=$5C and B=$80, selecting looping entry0. It runs68 times across14 natural scenarios. Entry bytes10 64 26 64 point to the frame table6410 and script6426. The table contains6414 and6425. Script bytes02 00 0C 01 0C select frames0/1 with delay12. Sprite_UpdateAll selects the slot's recorded ROM bank; Sprite_StepAndDrawSlot at00:0AE8/0B9D reads the count and four-byte OAM records in that bank.

Frame6414 contains four `(Y,X,tile,attr)` pieces: `(00,00,00,08)`, `(00,08,01,08)`, `(08,00,10,08)` and `(08,08,11,08)`. Frame6425 is empty. All31 bytes of the pointer/frame/script/entry chain were read naturally in14 scenarios. Existing sprite previews also compare the four loaded tile slots exactly in14/14 cases. These facts identify the format without inventing an image identity or proving new visual behavior.

## Preserving the interior attribute symbol

`Data_5C_6420::` denotes the third piece's attribute byte. It must remain a real bank5C symbol at6420. The existing sprite_oam macro emits all four bytes together and cannot place this literal label between its operands. A macro-generated alias would also escape the source-symbol scanner.

The file-local commerr_sprite_oam_prefix helper asserts exactly three arguments and a positive piece counter, decrements that counter once and emits Y/X/tile. Its sole call is followed by the literal existing attribute label and `db $08`; the fourth piece uses sprite_oam normally. Counter progression is4→3→2→1→0. An explicit assertion checks closure and another checks the attribute's offset12 from the new neutral `SpriteFrame_5C_6414`. PURGE removes the helper before the empty frame. The animation counter closes2→1→0. Shared macros remain unchanged.

The old208-byte tile heuristic at6350–6420 combined palettes with part of a sprite. The old comment that6420 was not reached by a walked sprite chain is contradicted by the complete natural OAM reads. Eight exact headers now replace those two mixed headers. All nine prior exported labels retain their bank/address; only the first frame's neutral label is added. No engine instruction or operand changes.

## Scope and remaining questions

The final input inventory contains289 TSVs. Fifteen rows name the gfx source:13 asset rows and two historical layout rows. There is no explicit physical source-line locator into this changed file. Six guarded metadata changes concern only the three palette statuses in assets.tsv and the matching three gfx README rows. Engine/error source lines and screen-operation callers remain unchanged.

The historical section_order.tsv classification summary remains explicit debt: old data2175/gfx1680/zero10 versus revised header composition data2187/gfx1664/ptrtable4/zero10. Physical allocation, bank, section order and3865-byte size remain identical; this historical summary is not silently rewritten.

The digit-pair table545B retains four unread bytes at546B–546E and lacks a proven decimal input bound. The85-byte text record retains28 unread bytes, including its terminator; the existing broad CONFIRMED header is not evidence that every record byte was consumed. Text records, message pointers, the ten-byte zero gap and neighboring banks remain outside this pass. The separate bank6A palette/OAM contradiction and structured macro at72A0 also remain open.
