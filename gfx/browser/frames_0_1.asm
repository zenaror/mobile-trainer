; gfx/browser/frames_0_1.asm
; bank 47, $4000-$5BA0 (7072 bytes); pinned by layout.link
; browser frame packages 0 and 1 (+ scroll bar tiles at 4000-40FF), referenced by the frame descriptors of bank 4E

SECTION "gfx/browser/frames_0_1", ROMX

; ---- gfx $4000-$4010 (16 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5D3E: hl=$4000 a=$47 c=$01 de=$8FF0 (dest VRAM $8FF0, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_BrowserScrollbar_Tiles8FF0_47_4000:: ; 47:4000
Data_47_4000::
	INCBIN "gfx/browser/frames_0_1/tiles_4000.2bpp"

; ---- gfx $4010-$4040 (48 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5D50: hl=$4010 a=$47 c=$03 de=$97D0 (dest VRAM $97D0, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_BrowserScrollbar_Tiles97D0_47_4010:: ; 47:4010
Data_47_4010::
	INCBIN "gfx/browser/frames_0_1/tiles_4010.2bpp"

; ---- gfx $4040-$4080 (64 bytes) [PROBABLE] tiles-2bpp: heuristic: 53 coherent tiles (hsim2=0.748 vsim2=0.682, 2 blank) parity 0; 192/928 bytes also covered by call-site blocks [clipped from 4000-43A0 by higher-priority evidence]

Data_47_4040:: ; 47:4040
	INCBIN "gfx/browser/frames_0_1/tiles_4040.2bpp"

; ---- gfx $4080-$4090 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5CD0: hl=$4080 a=$47 c=$01 de=$8FF0 (dest VRAM $8FF0, vbank=0)

Gfx_BrowserScrollbar_Tiles8FF0_47_4080:: ; 47:4080
Data_47_4080::
	INCBIN "gfx/browser/frames_0_1/tiles_4080.2bpp"

; ---- gfx $4090-$40C0 (48 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5CE2: hl=$4090 a=$47 c=$03 de=$97D0 (dest VRAM $97D0, vbank=0)

Gfx_BrowserScrollbar_Tiles97D0_47_4090:: ; 47:4090
Data_47_4090::
	INCBIN "gfx/browser/frames_0_1/tiles_4090.2bpp"

; ---- gfx $40C0-$40D0 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5D07: hl=$40C0 a=$47 c=$01 de=$8FF0 (dest VRAM $8FF0, vbank=0)

Gfx_BrowserScrollbar_Tiles8FF0_47_40C0:: ; 47:40C0
Data_47_40C0::
	INCBIN "gfx/browser/frames_0_1/tiles_40c0.2bpp"

; ---- gfx $40D0-$4100 (48 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 4E:5D19: hl=$40D0 a=$47 c=$03 de=$97D0 (dest VRAM $97D0, vbank=0)

Gfx_BrowserScrollbar_Tiles97D0_47_40D0:: ; 47:40D0
Data_47_40D0::
	INCBIN "gfx/browser/frames_0_1/tiles_40d0.2bpp"

; ---- gfx $4100-$4B00 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 1/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found (address is computed) ; the executed-code reads of 47:4E50-5BA0 (homepage trace) and 47:5BA0-68F0 (monkey_1 trace) cover exactly blocks 2 and 3 (CONFIRMED whole-block data reads; the split into tiles/map/palette is PROBABLE) | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tiles_47_4100:: ; 47:4100
	INCBIN "gfx/browser/frames_0_1/tiles_4100.2bpp"

; ---- data $4B00-$4DD0 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 1/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tilemap_47_4B00:: ; 47:4B00
	INCBIN "gfx/browser/frames_0_1/tilemap_4b00.tilemap"
	INCBIN "gfx/browser/frames_0_1/tilemap_4b00.attrmap"

; ---- data $4DD0-$4E50 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 1/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Palette_47_4DD0:: ; 47:4DD0
	INCLUDE "gfx/browser/frames_0_1/palette_4dd0.pal"

; ---- gfx $4E50-$5850 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 2/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found (address is computed) ; the executed-code reads of 47:4E50-5BA0 (homepage trace) and 47:5BA0-68F0 (monkey_1 trace) cover exactly blocks 2 and 3 (CONFIRMED whole-block data reads; the split into tiles/map/palette is PROBABLE) | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tiles_47_4E50:: ; 47:4E50
	INCBIN "gfx/browser/frames_0_1/tiles_4e50.2bpp"

; ---- data $5850-$5B20 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 2/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Tilemap_47_5850:: ; 47:5850
	INCBIN "gfx/browser/frames_0_1/tilemap_5850.tilemap"
	INCBIN "gfx/browser/frames_0_1/tilemap_5850.attrmap"

; ---- data $5B20-$5BA0 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 2/4 of bank 47: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50 | independent evidence: the screen descriptors of the table 4E:654B (4E:6581, 65A0, 65BF) contain far pointers to exactly these block parts: 47:4100 tiles / 47:4DD0 palettes / 47:4B00 tilemap (block 1), 47:4E50 / 47:5B20 / 47:5850 (block 2), 47:5BA0 / 47:6870 / 47:65A0 (block 3); the OBJ palette pointers 47:4E10, 47:5B60, 47:68B0 = palette+$40

Palette_47_5B20:: ; 47:5B20
	INCLUDE "gfx/browser/frames_0_1/palette_5b20.pal"
