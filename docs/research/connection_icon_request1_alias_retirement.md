# Connection-icon Request1: two redundant tile-source aliases

## Existing names and bounded contract

This unit retires only `Data_69_4160` and `Data_69_4560` in `gfx/comm/connection_icon.asm`. The existing proper co-labels `ConnIcon_Tiles0` and `ConnIcon_Tiles1` stay at the same addresses, in the same order. The two existing **CONFIRMED** resource headers and all evidence text remain byte-for-byte unchanged. This is redundant alias retirement for readability, not new semantic identification, a confidence upgrade, or evidence that all neutral data/functions are understood.

The positive literal reader is `ConnIcon_LoadGraphics_Request1` in `engine/comm/connection_icon.asm`. The first block at 69:4118 calls `Gfx_StartHDMAWithService` at 69:4124 with A=$69, HL=$4160, DE=$8200, B=$92 and C=$40; it reads exactly 1024 bytes through 69:4560 exclusive, into VRAM0:$8200–8600. The next call at 69:4136 uses A=$69, HL=$4560, DE=$8600, B=$95 and C=$20; it reads 512 bytes through 69:4760 exclusive, into VRAM0:$8600–8800. Both 18-byte argument/FarCall blocks match the original ROM. These legal C values count 16-byte transfers under the existing helper contract; the two B values qualify its LCD-on wait and do not establish a universal timing guarantee.

The owner is pinned by `layout.link` at bank $69, org $4152; its fourteen-byte zero prefix precedes $4160.

Neither transfer includes the prefix, palette at $4760, or following pointer/animation records.

All 41 other generic aliases in this owner stay **KEEP** with their inherited **PROBABLE** headers: the 14-byte prefix, palette, seven pointer-table groups, and frame/animation data. Their pointer/ABI contracts and content classifications are outside this narrow confirmed-resource unit. The Request2 resource set is also outside this selection; no owner in queued graphics/settings work, Notice4B, Shared5E, Error10, Label8 or Settings17 is edited. KEEP is not a finding that these bytes are unused or have no meaning.
