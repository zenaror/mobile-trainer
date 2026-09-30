; gfx/help/help_screens_b.asm
; bank 6A, $6716-$72BF (2985 bytes); pinned by layout.link
; help screen tilemap, tiles, palettes, object tables loaded by bank 6C

SECTION "gfx/help/help_screens_b", ROMX

; ---- data $6716-$69E6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:5A45: hl=$6716 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_6A_6716:: ; 6A:6716
	INCBIN "gfx/help/help_screens_b/tilemap_6716.tilemap"
	INCBIN "gfx/help/help_screens_b/tilemap_6716.attrmap"

; ---- gfx $69E6-$69F0 (10 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.680 vsim2=0.789, 1 blank) parity 1; 854/864 bytes also covered by call-site blocks [clipped from 68C1-6C21 by higher-priority evidence]

Data_6A_69E6:: ; 6A:69E6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $69F0-$6A10 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:59FF: hl=$69F0 a=$6A c=$02 de=$8000 (dest VRAM $8000, vbank=0)

Data_6A_69F0:: ; 6A:69F0
	INCBIN "gfx/help/help_screens_b/tiles_69f0.2bpp"

; ---- gfx $6A10-$6A20 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A11: hl=$6A10 a=$6A c=$01 de=$8AF1 (dest VRAM $8AF0, vbank=1)

Data_6A_6A10:: ; 6A:6A10
	INCBIN "gfx/help/help_screens_b/tiles_6a10.2bpp"

; ---- gfx $6A20-$6E20 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A23: hl=$6A20 a=$6A c=$40 de=$8B01 (dest VRAM $8B00, vbank=1)

Data_6A_6A20:: ; 6A:6A20
	INCBIN "gfx/help/help_screens_b/tiles_6a20.2bpp"

; ---- gfx $6E20-$7220 (1024 bytes) [PROBABLE] 64 x 2bpp tiles (0x400, continues the 0x400 HDMA block 6A20-6E20; rendered: button glyphs "A すすむ B もどる"); no call site with hl=$6E20 found; the mapper heuristic cut it at 70A1 (parity 1) which is wrong

Tiles_6A_6E20:: ; 6A:6E20
	INCBIN "gfx/help/help_screens_b/tiles_6e20.2bpp"

; ---- data $7220-$72A0 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80, all bit15 clear); 6C:5A2F loads hl=$7220 bc=$0040 de=$D800 then calls far 4F:4000; first 0x10 bytes read in 12/18 scenarios

Palette_6A_7220:: ; 6A:7220
	INCLUDE "gfx/help/help_screens_b/palette_7220.pal"

; ---- data $72A0-$72BB (27 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 6A:72A0-72BB [v4: bytes 72B8-72BB were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_6A_72A0:: ; 6A:72A0
	db $A4, $72, $AD, $72, $02, $00, $00, $00, $00, $00, $08, $01, $00, $02, $01, $00
	db $00, $00, $01, $08, $01, $00, $02, $00, $2E, $01, $08

; ---- words $72BB-$72BF (4 bytes) [PROBABLE] 1 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$72BB a=$6A at 6C:5D1E (1 entry: 72A0/72B6); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 72BB-72BF were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_6A_72BB:: ; 6A:72BB
	dw Data_6A_72A0, $72B6
