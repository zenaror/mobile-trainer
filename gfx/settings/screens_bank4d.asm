; gfx/settings/screens_bank4d.asm
; bank 4D, $4000-$7983 (14723 bytes); pinned by layout.link
; tiles, tilemaps, object tables loaded by bank 67

SECTION "gfx/settings/screens_bank4d", ROMX

; ---- gfx $4000-$4200 (512 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4789: hl=$4000 a=$4D c=$20 de=$8001 (dest VRAM $8000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_4000:: ; 4D:4000
	INCBIN "gfx/settings/screens_bank4d/tiles_4000.2bpp"

; ---- gfx $4200-$4510 (784 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46D5: hl=$4110 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE] [clipped from 4110-4510 by higher-priority evidence]

Data_4D_4200:: ; 4D:4200
	INCBIN "gfx/settings/screens_bank4d/tiles_4200.2bpp"

; ---- gfx $4510-$4610 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46E7: hl=$4510 a=$4D c=$10 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_4510:: ; 4D:4510
	INCBIN "gfx/settings/screens_bank4d/tiles_4510.2bpp"

; ---- gfx $4610-$4A10 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46F9: hl=$4610 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_4610:: ; 4D:4610
	INCBIN "gfx/settings/screens_bank4d/tiles_4610.2bpp"

; ---- gfx $4A10-$4D10 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:470B: hl=$4A10 a=$4D c=$30 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_4A10:: ; 4D:4A10
	INCBIN "gfx/settings/screens_bank4d/tiles_4a10.2bpp"

; ---- gfx $4D10-$5010 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4730: hl=$4C10 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE] [clipped from 4C10-5010 by higher-priority evidence]

Data_4D_4D10:: ; 4D:4D10
	INCBIN "gfx/settings/screens_bank4d/tiles_4d10.2bpp"

; ---- gfx $5010-$5110 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4742: hl=$5010 a=$4D c=$10 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5010:: ; 4D:5010
	INCBIN "gfx/settings/screens_bank4d/tiles_5010.2bpp"

; ---- gfx $5110-$5510 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4754: hl=$5110 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5110:: ; 4D:5110
	INCBIN "gfx/settings/screens_bank4d/tiles_5110.2bpp"

; ---- gfx $5510-$5810 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4766: hl=$5510 a=$4D c=$30 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5510:: ; 4D:5510
	INCBIN "gfx/settings/screens_bank4d/tiles_5510.2bpp"

; ---- data $5810-$5AE0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:4777: hl=$5810 a=$4D b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5810:: ; 4D:5810
	INCBIN "gfx/settings/screens_bank4d/tilemap_5810.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5810.attrmap"

; ---- data $5AE0-$5B6C (140 bytes) [PROBABLE] 14x5 tilemap: 70 tile indices then 70 attribute bytes (0x8C); one of 4 words {5AE0,5B6C,5BF8,5C84} of the pointer table at 67:491C (`ld hl,$491C` at 67:4906, bc=$050E = 5 rows x 14 cols) (bank 67 bytes at 491C: e0 5a 6c 5b f8 5b 84 5c); rows visible in the bytes (00 0b 01 02..); the mapper ptrtable guesses at 5B0A/5B18 were tile indices

Tilemap_4D_5AE0:: ; 4D:5AE0
	INCBIN "gfx/settings/screens_bank4d/tilemap_5ae0.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5ae0.attrmap"

; ---- data $5B6C-$5BF8 (140 bytes) [PROBABLE] 14x5 tilemap: 70 tile indices then 70 attribute bytes (0x8C); one of 4 words {5AE0,5B6C,5BF8,5C84} of the pointer table at 67:491C (`ld hl,$491C` at 67:4906, bc=$050E = 5 rows x 14 cols) (bank 67 bytes at 491C: e0 5a 6c 5b f8 5b 84 5c); rows visible in the bytes (00 0b 01 02..); the mapper ptrtable guesses at 5B0A/5B18 were tile indices

Tilemap_4D_5B6C:: ; 4D:5B6C
	INCBIN "gfx/settings/screens_bank4d/tilemap_5b6c.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5b6c.attrmap"

; ---- data $5BF8-$5C84 (140 bytes) [PROBABLE] 14x5 tilemap: 70 tile indices then 70 attribute bytes (0x8C); one of 4 words {5AE0,5B6C,5BF8,5C84} of the pointer table at 67:491C (`ld hl,$491C` at 67:4906, bc=$050E = 5 rows x 14 cols) (bank 67 bytes at 491C: e0 5a 6c 5b f8 5b 84 5c); rows visible in the bytes (00 0b 01 02..); the mapper ptrtable guesses at 5B0A/5B18 were tile indices

Tilemap_4D_5BF8:: ; 4D:5BF8
	INCBIN "gfx/settings/screens_bank4d/tilemap_5bf8.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5bf8.attrmap"

; ---- data $5C84-$5D10 (140 bytes) [PROBABLE] 14x5 tilemap: 70 tile indices then 70 attribute bytes (0x8C); one of 4 words {5AE0,5B6C,5BF8,5C84} of the pointer table at 67:491C (`ld hl,$491C` at 67:4906, bc=$050E = 5 rows x 14 cols) (bank 67 bytes at 491C: e0 5a 6c 5b f8 5b 84 5c); rows visible in the bytes (00 0b 01 02..); the mapper ptrtable guesses at 5B0A/5B18 were tile indices

Tilemap_4D_5C84:: ; 4D:5C84
	INCBIN "gfx/settings/screens_bank4d/tilemap_5c84.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5c84.attrmap"

; ---- words $5D10-$5D18 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$5D10 a=$4D at 67:47C6 (entry 0 unused, entry 1 = 5D18/5D3E); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Table_4D_5D10:: ; 4D:5D10
	dw $0000, $0000, Data_4D_5D18, $5D3E

; ---- data $5D18-$5D50 (56 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 4D:5D18-5D50 (ends with zero padding to the tile block)

Data_4D_5D18:: ; 4D:5D18
	db $1C, $5D, $2D, $5D, $04, $00, $00, $00, $08, $08, $00, $10, $08, $00, $78, $00
	db $28, $08, $78, $10, $28, $04, $00, $FF, $00, $08, $08, $FF, $10, $08, $00, $79
	db $00, $28, $08, $79, $10, $28, $02, $00, $1E, $01, $05, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5D50-$5D70 (32 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4DBC: hl=$5D50 a=$4D c=$02 de=$8001 (dest VRAM $8000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5D50:: ; 4D:5D50
	INCBIN "gfx/settings/screens_bank4d/tiles_5d50.2bpp"

; ---- gfx $5D70-$6170 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D2A: hl=$5D70 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_5D70:: ; 4D:5D70
	INCBIN "gfx/settings/screens_bank4d/tiles_5d70.2bpp"

; ---- gfx $6170-$6570 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D3C: hl=$6170 a=$4D c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_6170:: ; 4D:6170
	INCBIN "gfx/settings/screens_bank4d/tiles_6170.2bpp"

; ---- gfx $6570-$6870 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D4E: hl=$6470 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE] [clipped from 6470-6870 by higher-priority evidence]

Data_4D_6570:: ; 4D:6570
	INCBIN "gfx/settings/screens_bank4d/tiles_6570.2bpp"

; ---- gfx $6870-$6C70 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D60: hl=$6870 a=$4D c=$40 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_6870:: ; 4D:6870
	INCBIN "gfx/settings/screens_bank4d/tiles_6870.2bpp"

; ---- gfx $6C70-$6D70 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D74: hl=$6970 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE] [clipped from 6970-6D70 by higher-priority evidence]

Data_4D_6C70:: ; 4D:6C70
	INCBIN "gfx/settings/screens_bank4d/tiles_6c70.2bpp"

; ---- gfx $6D70-$7170 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D86: hl=$6D70 a=$4D c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_6D70:: ; 4D:6D70
	INCBIN "gfx/settings/screens_bank4d/tiles_6d70.2bpp"

; ---- gfx $7170-$7470 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D98: hl=$7070 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE] [clipped from 7070-7470 by higher-priority evidence]

Data_4D_7170:: ; 4D:7170
	INCBIN "gfx/settings/screens_bank4d/tiles_7170.2bpp"

; ---- gfx $7470-$7870 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4DAA: hl=$7470 a=$4D c=$40 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_4D_7470:: ; 4D:7470
	INCBIN "gfx/settings/screens_bank4d/tiles_7470.2bpp"

; ---- data $7870-$78C0 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_4D_7870:: ; 4D:7870
	INCBIN "gfx/settings/screens_bank4d/tilemap_7870.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_7870.attrmap"

; ---- data $78C0-$7910 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_4D_78C0:: ; 4D:78C0
	INCBIN "gfx/settings/screens_bank4d/tilemap_78c0.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_78c0.attrmap"

; ---- data $7910-$7960 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_4D_7910:: ; 4D:7910
	INCBIN "gfx/settings/screens_bank4d/tilemap_7910.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_7910.attrmap"

; ---- words $7960-$7968 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$7960 a=$4D at 67:4E0A (entry 0 unused, entry 1 = 7968/797E); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Table_4D_7960:: ; 4D:7960
	dw $0000, $0000, Data_4D_7968, $797E

; ---- data $7968-$7983 (27 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 4D:7968-7983

Data_4D_7968:: ; 4D:7968
	db $6C, $79, $75, $79, $02, $00, $00, $00, $08, $00, $08, $01, $08, $02, $FF, $00
	db $00, $08, $FF, $08, $01, $08, $02, $00, $1E, $01, $05
