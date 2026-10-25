# Shared text-entry graphics and entry UI palette

`Gfx_SharedTextEntry_Vram8800Vb1` (5E:4000..4400) and `Gfx_SharedTextEntry_Vram8C00Vb1` (5E:4400..4800) each contain exactly 1024 bytes.

Phone number/comment setup and account login/mail entry setup explicitly select ROM bank 5E and request C=$40 HDMA blocks, with DE=$8801/$8C01.

The complete windows therefore go to VRAM bank 1 at $8800..8C00 and $8C00..9000.

The names describe shared text-entry source/load roles; HDMA alone is not a new proof of content classification or screen appearance.

`Palette_SharedEntryUi_Bg` (5E:4D00..4D40) contains exactly 64 bytes: 32 RGB555 colors in eight palettes.

Keyboard type 4 reads only source +$28 for $18 bytes into destination +$28, exactly BG5..7.

Every read ends at or before $4D40, and the preceding HDMA at $4C00 ends exactly at $4D00.

The additional complete palette calls at 68:566E, 5C51, 5E20 and 6148 execute 155/8, 77/8, 934/21 and 125/8; keyboard call 55:6784 executes 933/21.

Only 17 screen_ops label cells, three asset label cells and three worklist decisions change; no active file/line locator points into the two definition files.

Next are the registration sprite table at 5D:7318 and the result-page resources at 68:7831, followed by the remaining groups in worklist order.
