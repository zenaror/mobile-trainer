# Three shared CommScene VRAM source units

## Three bounded role names

No content is classified merely because HDMA consumes it.

## Every operand, source bank and transfer

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

| Existing unit | Consumer | Offset inside request | Destination contribution |
|---|---|---:|---|
|6490..6690|452A|$000|9000..9200/VB0|
|6490..6690|453C|$000|8000..8200/VB1|
|6690..6890|453C|$200|8200..8400/VB1|
|6690..6890|4560|$000|9000..9200/VB1|
|6890..6A90|454E|$000|8400..8600/VB1|
|6890..6A90|4560|$200|9200..9400/VB1|

## Loader context and natural limits

All three named caller instructions to `CommScene_LoadGraphics` / Function_70_44B0 are:

| Handler | Call address |
| --- | --- |
| CommScene_Kind0_StateSetup | 70:40E3 |
| CommScene_Kind1_StateSetup | 70:428D |
| CommScene_Kind2_StateSetup | 70:4418 |

All three current 512-byte `.2bpp` files exactly match original bank70 bytes at their existing labels:

Three comment-only header corrections preserve existing source units. Headers remain gfx512/CONFIRMED; no byte/layout/type/status change.

1. The previous $6490 header cited only call $452A. The revised header states both its short window and call $453C's longer window, with exact contributions of this slice.
2. The previous $6690 header cited only call $453C with source $6490 and clipping. That contributing request was real but incomplete. The revised header also states the direct $6690 load at $4557/call $4560 and its window into the neighboring source unit. It distinguishes the 512-byte storage slice from each 1024-byte request.
3. The previous $6890 header described only call $4560 with source $6690, despite the explicit $6890 operand at $4545/call $454E. The revised header preserves the real cross-window contribution and documents the direct 512-byte transfer. The old clipping citation describes a contributing window, rather than this unit's sole explicit base.

Only gfx/comm/comm_scene.asm gains aliases/header lines.
