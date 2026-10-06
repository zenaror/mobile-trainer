# Three shared CommScene VRAM source units

Independent source/ROM derivation on baseline 37a4fa9, reconciled onto the preceding account checkpoint before integration. Consumers and original bytes did not change. No new execution or translation evidence was used.

## Three bounded role names

| Neutral alias preserved | Accepted role name | Exact existing source unit |
|---|---|---|
| Data_70_6490 | Gfx_CommScene_SharedVramSource0 | 70:6490..6690,512 bytes |
| Data_70_6890 | Gfx_CommScene_SharedVramSource2 | 70:6890..6A90,512 bytes |
| Data_70_6690 | Gfx_CommScene_SharedVramSource1 | 70:6690..6890,512 bytes |

Roles are CONFIRMED by four natural consumers. Source0/1/2 enumerate the three adjacent existing source units in physical order6490/6690/6890. Each unit contributes to two destination windows, so none receives a destination-only name. The names claim neither visual identity nor a new type classification. Existing graphics/tiles asset kinds, CONFIRMED status, byte lengths, INCBIN expressions and source bounds are preserved. No content is classified merely because HDMA consumes it. Existing semantic labels for preceding/following assets do not truthfully alias these separate byte units and are not reused globally.

## Every operand, source bank and transfer

All eight source operands are in `engine/comm/comm_scene.asm`. Each row below includes both named loads, all argument assignments and its call. Every instruction in these four argument/call sequences executed 160 times in 18 natural scenarios from the existing 69-scenario union. No additional execution, replay or forced entry was used.

| Source line range | DE assignment | HL assignment | A bank assignment | B / C assignments | Farcall |
|---|---|---|---|---|---|
|703..708|70:451E,9000|70:4521,6490|70:4524,70|70:4526,95 /4528,20|70:452A|
|709..714|70:4530,8001|70:4533,6490|70:4536,70|70:4538,92 /453A,40|70:453C|
|715..720|70:4542,8401|70:4545,6890|70:4548,70|70:454A,95 /454C,20|70:454E|
|721..726|70:4554,9001|70:4557,6690|70:455A,70|70:455C,92 /455E,40|70:4560|

The exact18-byte original-ROM sequence per row is checked, including each six-byte farcall to00:0787. HL always addresses ROMX; A=$70 selects source bank70 through BankSwitch_H. FarCall_Common saves and restores caller bank70 between calls. `Gfx_StartHDMAWithService` writes source HL to HDMA1/2, masks destination low byte with `$F0`, selects VBK via E&1, and writes C-1 to HDMA5. Thus C=$20 requests `$200 bytes (512)`; C=$40 requests `$400 bytes (1024)`. B=$95/$92 is the LY service limit, not a byte count. All source addresses are sixteen-byte aligned.

| Call | Requested source span bank70 | Requested destination span | VBK | Count |
|---|---|---|---:|---:|
|452A|6490..6690|9000..9200|0|$200/512|
|453C|6490..6890|8000..8400|1|$400/1024|
|454E|6890..6A90|8400..8600|1|$200/512|
|4560|6690..6A90|9000..9400|1|$400/1024|

All endpoints are exclusive. Their exact existing source-unit contributions are:

| Existing unit | Consumer | Offset inside request | Destination contribution |
|---|---|---:|---|
|6490..6690|452A|$000|9000..9200/VB0|
|6490..6690|453C|$000|8000..8200/VB1|
|6690..6890|453C|$200|8200..8400/VB1|
|6690..6890|4560|$000|9000..9200/VB1|
|6890..6A90|454E|$000|8400..8600/VB1|
|6890..6A90|4560|$200|9200..9400/VB1|

Therefore neither512-byte source-unit boundary is the end of its larger 1024-byte request. Source6490 has two direct loads with different lengths/destinations. Source6690 has one direct load spanning its neighbor6890 and also contributes to the request beginning6490. Source6890 has its own direct 512-byte load and contributes to the request beginning6690. Nothing spills outside these three units for these four transfers. Preceding CommScene uploads5490..5890,5890..5C90,5C90..6090,6090..6490 end before this pool; following request6A90..6E90 starts after it. Its existing palette/map overlap is a different unit and remains untouched.

## Loader context and natural limits

All three named caller instructions to `CommScene_LoadGraphics` / Function_70_44B0 are:

| Handler | Call address | Hits/scenarios |
|---|---|---:|
|CommScene_Kind0_StateSetup|70:40E3|54/18|
|CommScene_Kind1_StateSetup|70:428D|79/14|
|CommScene_Kind2_StateSetup|70:4418|27/5|

Total 160 calls, consistent with all four transfers. The loader initializes graphics before the state handlers choose their text-box/scroll/state setup. None introduces another meaning for these source units. Source and original bank70 opcode-pattern census agree: HL6490 occurs exactly at4521/4533; HL6690 at4557; HL6890 at4545; direct call44B0 appears exactly at40E3/428D/4418. This pattern census corroborates the source census and is not a general proof that arbitrary byte patterns are executable code. There are no additional named data/macro consumers or numeric6490/6690/6890 source operands in the maintained source tree.

Natural execution confirms the consumer role, not an independent visual identification of every transferred byte. Existing preview screen_ops rows are static metadata corroboration; screen summary has no match count proving these three blocks' artwork. Sprite preview metadata concerns an object table and is not used to infer a visual meaning for this pool. No new emulator/hardware validation is claimed.

## Existing asset bytes and explicit header corrections

All three current 512-byte `.2bpp` files exactly match original bank70 bytes at their existing labels:

| Asset suffix | SHA256 compiled bytes |
|---|---|
|tiles_6490.2bpp|ad0a3e0ddb9d96967934304a9c427081eee49a002ca5637b898cdc993834c8f0|
|tiles_6690.2bpp|1a0aacce0f42ce4405680824b142a29060a8eb19fef83e0e2881f87c4f746c1c|
|tiles_6890.2bpp|e4516001ad837a65e35be9de3a2d0a28f141b59b438e3e5778d92aaa61ccc886|

Three comment-only header corrections preserve existing source units. Headers remain gfx512/CONFIRMED; no byte/layout/type/status change.

1. The previous $6490 header cited only call $452A. The revised header states both its short window and call $453C's longer window, with exact contributions of this slice.
2. The previous $6690 header cited only call $453C with source $6490 and clipping. That contributing request was real but incomplete. The revised header also states the direct $6690 load at $4557/call $4560 and its window into the neighboring source unit. It distinguishes the 512-byte storage slice from each 1024-byte request.
3. The previous $6890 header described only call $4560 with source $6690, despite the explicit $6890 operand at $4545/call $454E. The revised header preserves the real cross-window contribution and documents the direct 512-byte transfer. The old clipping citation describes a contributing window, rather than this unit's sole explicit base.

No existing source boundaries are moved to make them resemble transfer boundaries. No bytes are retyped or converted. These are factual role/header corrections of current hand-maintained source; frozen historical mapper/config remain unchanged.

## Complete metadata and locator scope

The original consumer census records 46 identifier occurrences, including definitions, operands and historical references; none includes unrelated sample record payloads.

Updated active metadata: assets.tsv394..396 (three labels), previews/screen_ops.tsv227..230 (four labels), naming2/neutral_code_worklist.tsv17..19 (three rows with settled evidence). Existing neutral aliases allow old historical references to remain valid.

Preserve frozen/historical occurrences: mapper/bank70.tsv50..52; naming2/data2_renames.tsv737..739 (seven name occurrences in old evidence); proposals/survey_regions_bank70.tsv19..21; analysis/xrefs/rows.tsv971..974; config/regions/bank70.tsv159..161; config/xrefs.tsv1000..1003; docs/research/naming2_data2.md117. Do not rewrite the frozen type mapper or generator tables.

Only gfx/comm/comm_scene.asm gains aliases/header lines. No active colon or explicit file/line locators into that definition file were found. File-only asset/worklist metadata has bank/address fields, not line numbers. Engine source lines do not move; all 17 existing screen_ops engine locators remain valid. Other engine locators in ram12 manual records and historical naming docs were audited against the preceding checkpoint and remain unaffected. All labels remain pinned to original ROM addresses.
