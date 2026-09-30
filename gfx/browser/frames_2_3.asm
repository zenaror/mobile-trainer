; gfx/browser/frames_2_3.asm
; bank 47, $5BA0-$7640 (6816 bytes); pinned by layout.link
; browser frame packages 2 and 3 (package 3 is not referenced by any descriptor)

SECTION "gfx/browser/frames_2_3", ROMX

; ---- gfx $5BA0-$65A0 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 3/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found (address is computed) ; the executed-code reads of 47:4E50-5BA0 (homepage trace) and 47:5BA0-68F0 (monkey_1 trace) cover exactly blocks 2 and 3 (CONFIRMED whole-block data reads; the split into tiles/map/palette is PROBABLE) | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tiles_47_5BA0:: ; 47:5BA0
	INCBIN "gfx/browser/frames_2_3/tiles_5ba0.2bpp"

; ---- data $65A0-$6870 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 3/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tilemap_47_65A0:: ; 47:65A0
	INCBIN "gfx/browser/frames_2_3/tilemap_65a0.tilemap"
	INCBIN "gfx/browser/frames_2_3/tilemap_65a0.attrmap"

; ---- data $6870-$68F0 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 3/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Palette_47_6870:: ; 47:6870
	INCLUDE "gfx/browser/frames_2_3/palette_6870.pal"

; ---- gfx $68F0-$72F0 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 4/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found (address is computed) ; the executed-code reads of 47:4E50-5BA0 (homepage trace) and 47:5BA0-68F0 (monkey_1 trace) cover exactly blocks 2 and 3 (CONFIRMED whole-block data reads; the split into tiles/map/palette is PROBABLE)

Tiles_47_68F0:: ; 47:68F0
	INCBIN "gfx/browser/frames_2_3/tiles_68f0.2bpp"

; ---- data $72F0-$75C0 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 4/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

Tilemap_47_72F0:: ; 47:72F0
	INCBIN "gfx/browser/frames_2_3/tilemap_72f0.tilemap"
	INCBIN "gfx/browser/frames_2_3/tilemap_72f0.attrmap"

; ---- data $75C0-$7640 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 4/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

Palette_47_75C0:: ; 47:75C0
	INCLUDE "gfx/browser/frames_2_3/palette_75c0.pal"
