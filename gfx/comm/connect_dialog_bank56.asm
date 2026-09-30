; gfx/comm/connect_dialog_bank56.asm
; bank 56, $418A-$79D0 (14406 bytes); pinned by layout.link
; connect dialog tilemaps, tiles, palettes, object table (loaded by bank 57)

SECTION "gfx/comm/connect_dialog_bank56", ROMX

; ---- data $418A-$445A (720 bytes) [PROBABLE] tilemap+attr: 3 call site(s) (57:49B4 57:4B25 57:5146); first: copy_tilemap_rect_pair at 57:49B4: hl=$418A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_56_418A:: ; 56:418A
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_418a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_418a.attrmap"

; ---- data $445A-$472A (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (57:4E8D 57:5192); first: copy_tilemap_rect_pair at 57:4E8D: hl=$445A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_56_445A:: ; 56:445A
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_445a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_445a.attrmap"

; ---- data $472A-$49FA (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (57:4F64 57:51B6); first: copy_tilemap_rect_pair at 57:4F64: hl=$472A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_56_472A:: ; 56:472A
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_472a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_472a.attrmap"

; ---- data $49FA-$4CCA (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (57:4BFE 57:516B); first: copy_tilemap_rect_pair at 57:4BFE: hl=$49FA a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_56_49FA:: ; 56:49FA
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_49fa.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_49fa.attrmap"

; ---- data $4CCA-$4F9A (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (57:4D6F 57:517F); first: copy_tilemap_rect_pair at 57:4D6F: hl=$4CCA a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_56_4CCA:: ; 56:4CCA
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4cca.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4cca.attrmap"

; ---- data $4F9A-$526A (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 57:4800: hl=$4F9A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_56_4F9A:: ; 56:4F9A
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4f9a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4f9a.attrmap"

; ---- gfx $526A-$52C0 (86 bytes) [PROBABLE] tiles-2bpp: heuristic: 54 coherent tiles (hsim2=0.695 vsim2=0.766, 0 blank) parity 1; 826/912 bytes also covered by call-site blocks [clipped from 5101-5491 by higher-priority evidence]

Data_56_526A:: ; 56:526A
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_526a.2bpp"
	db $00, $00, $00, $00, $00, $00

; ---- gfx $52C0-$56C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:47DD: hl=$52C0 a=$56 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Data_56_52C0:: ; 56:52C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_52c0.2bpp"

; ---- gfx $56C0-$5AC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:47EF: hl=$56C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Data_56_56C0:: ; 56:56C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_56c0.2bpp"

; ---- gfx $5AC0-$5DC0 (768 bytes) [PROBABLE] tiles-vram: 2 call site(s) (57:496A 57:4ADB); first: hdma_rom_to_vram at 57:496A: hl=$5AC0 a=$56 c=$30 de=$8800 (dest VRAM $8800, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Data_56_5AC0:: ; 56:5AC0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_5ac0.2bpp"

; ---- gfx $5DC0-$60C0 (768 bytes) [PROBABLE] tiles-vram: 2 call site(s) (57:498E 57:4AFF); first: hdma_rom_to_vram at 57:498E: hl=$5DC0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_56_5DC0:: ; 56:5DC0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_5dc0.2bpp"

; ---- gfx $60C0-$64C0 (1024 bytes) [PROBABLE] tiles-vram: 2 call site(s) (57:49A0 57:4B11); first: hdma_rom_to_vram at 57:49A0: hl=$60C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_56_60C0:: ; 56:60C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_60c0.2bpp"

; ---- gfx $64C0-$68C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E58: hl=$64C0 a=$56 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Data_56_64C0:: ; 56:64C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_64c0.2bpp"

; ---- gfx $68C0-$6AC0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E6A: hl=$67C0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [clipped from 67C0-6AC0 by higher-priority evidence]

Data_56_68C0:: ; 56:68C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_68c0.2bpp"

; ---- gfx $6AC0-$6EC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E7C: hl=$6AC0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Data_56_6AC0:: ; 56:6AC0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_6ac0.2bpp"

; ---- gfx $6EC0-$71C0 (768 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4D4C: hl=$6EC0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_56_6EC0:: ; 56:6EC0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_6ec0.2bpp"

; ---- gfx $71C0-$75C0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4D5E: hl=$71C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_56_71C0:: ; 56:71C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_71c0.2bpp"

; ---- gfx $75C0-$77C0 (512 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:5083 57:50E4); first: hdma_rom_to_vram at 57:5083: hl=$75C0 a=$56 c=$20 de=$8000 (dest VRAM $8000, vbank=0)

Data_56_75C0:: ; 56:75C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_75c0.2bpp"

; ---- data $77C0-$7880 (192 bytes) [PROBABLE] 24 CGB palettes x 4 RGB555 words, all 96 words have bit15 clear (77C0-7880); 7820-7836 and 798D.. parts read by executed code (copy to palette RAM in up to 6/18 scenarios); the mapper heuristic ended the second block at 7896 but the words at 7880+ are pointers (84 78 8d 78 ..)

Palette_56_77C0:: ; 56:77C0
	INCLUDE "gfx/comm/connect_dialog_bank56/palette_77c0.pal"

; ---- data $7880-$79B8 (312 bytes) [PROBABLE] 5 object record(s): 5 frame tables, 15 frames, 5 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 56:7880-79B8 [v4: bytes 798D-79B8 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_56_7880:: ; 56:7880
	db $84, $78, $8D, $78, $02, $02, $FF, $00, $00, $0A, $FF, $01, $00, $01, $00, $00
	db $1E, $00, $02, $00, $14, $01, $14, $9F, $78, $B0, $78, $C1, $78, $D2, $78, $04
	db $02, $FE, $09, $00, $02, $06, $0A, $00, $0A, $FE, $0B, $00, $0A, $06, $0C, $00
	db $04, $02, $FE, $0D, $00, $02, $06, $0E, $00, $0A, $FE, $0F, $00, $0A, $06, $10
	db $00, $04, $02, $FE, $11, $00, $02, $06, $12, $00, $0A, $FE, $13, $00, $0A, $06
	db $14, $00, $04, $02, $FE, $0D, $00, $02, $06, $0E, $00, $0A, $FE, $0F, $00, $0A
	db $06, $10, $00, $04, $00, $0C, $01, $0A, $02, $0F, $03, $0A, $F4, $78, $01, $79
	db $16, $79, $2B, $79, $03, $0A, $FE, $16, $00, $0A, $06, $17, $00, $02, $06, $15
	db $00, $05, $01, $06, $18, $00, $09, $FE, $19, $00, $09, $06, $1A, $00, $02, $FD
	db $07, $00, $0B, $07, $08, $00, $05, $02, $04, $1B, $00, $0A, $FC, $1C, $00, $0A
	db $04, $02, $00, $01, $FC, $07, $00, $0B, $08, $08, $00, $06, $04, $FB, $03, $00
	db $04, $03, $04, $00, $0C, $FB, $05, $00, $0C, $03, $06, $00, $00, $FB, $07, $00
	db $0B, $09, $08, $00, $04, $00, $0A, $01, $0A, $02, $05, $03, $0A, $53, $79, $64
	db $79, $75, $79, $04, $02, $FE, $09, $00, $02, $06, $0A, $00, $0A, $FE, $0B, $00
	db $0A, $06, $0C, $00, $04, $FE, $FE, $09, $00, $FE, $06, $0A, $00, $06, $FE, $0B
	db $00, $06, $06, $0C, $00, $04, $02, $FE, $09, $00, $02, $06, $0A, $00, $0A, $FE
	db $0B, $00, $0A, $06, $0C, $00, $03, $00, $05, $01, $08, $02, $0A, $91, $79, $A2
	db $79, $04, $FE, $FE, $1D, $00, $FE, $1A, $1D, $20, $0A, $FE, $1D, $40, $0A, $1A
	db $1D, $60, $04, $FD, $FD, $1D, $00, $FD, $1B, $1D, $20, $0B, $FD, $1D, $40, $0B
	db $1B, $1D, $60, $02, $00, $2E, $01, $08

; ---- words $79B8-$79D0 (24 bytes) [PROBABLE] 6 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$79B8 a=$56 is loaded before init_object_from_table at 57:42BA and 10 more sites; all 6 entries hit frame-table/script starts of the sweep 7880-79B8; object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 79CC-79D0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_56_79B8:: ; 56:79B8
	dw Data_56_7880, $7892, $7897, $78E3, $78EC, $7944, $794D, $7986
	dw $0000, $0000, $798D, $79B3
