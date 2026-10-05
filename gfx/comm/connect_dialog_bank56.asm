; gfx/comm/connect_dialog_bank56.asm
; bank 56, $418A-$79D0 (14406 bytes); pinned by layout.link
; connect dialog tilemaps, tiles, palettes, object table (loaded by bank 57)

SECTION "gfx/comm/connect_dialog_bank56", ROMX

; ---- data $418A-$445A (720 bytes) [CONFIRMED] tilemap+attr: 3 call site(s) (57:49B4 57:4B25 57:5146); first: copy_tilemap_rect_pair at 57:49B4: hl=$418A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 99 hits in 4 scenarios (analysis/coverage_union.tsv)]

Tilemap_ConnectDialog_56_418A:: ; 56:418A
Data_56_418A::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_418a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_418a.attrmap"

; ---- data $445A-$472A (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (57:4E8D 57:5192); first: copy_tilemap_rect_pair at 57:4E8D: hl=$445A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_ConnectDialog_56_445A:: ; 56:445A
Data_56_445A::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_445a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_445a.attrmap"

; ---- data $472A-$49FA (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (57:4F64 57:51B6); first: copy_tilemap_rect_pair at 57:4F64: hl=$472A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 10 hits in 6 scenarios (analysis/coverage_union.tsv)]

Tilemap_ConnectDialog_56_472A:: ; 56:472A
Data_56_472A::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_472a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_472a.attrmap"

; ---- data $49FA-$4CCA (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (57:4BFE 57:516B); first: copy_tilemap_rect_pair at 57:4BFE: hl=$49FA a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 12 hits in 4 scenarios (analysis/coverage_union.tsv)]

Tilemap_ConnectDialog_56_49FA:: ; 56:49FA
Data_56_49FA::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_49fa.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_49fa.attrmap"

; ---- data $4CCA-$4F9A (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (57:4D6F 57:517F); first: copy_tilemap_rect_pair at 57:4D6F: hl=$4CCA a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 3 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_ConnectDialog_56_4CCA:: ; 56:4CCA
Data_56_4CCA::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4cca.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4cca.attrmap"

; ---- data $4F9A-$526A (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 57:4800: hl=$4F9A a=$56 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_ConnectDialog_ConnectConfirm_56_4F9A:: ; 56:4F9A
Data_56_4F9A::
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4f9a.tilemap"
	INCBIN "gfx/comm/connect_dialog_bank56/tilemap_4f9a.attrmap"

; ---- gfx $526A-$52C0 (86 bytes) [PROBABLE] tiles-2bpp: heuristic: 54 coherent tiles (hsim2=0.695 vsim2=0.766, 0 blank) parity 1; 826/912 bytes also covered by call-site blocks [clipped from 5101-5491 by higher-priority evidence]

Tilemap_ConnectDialog_ConnectConfirm_56_526A:: ; 56:526A
Data_56_526A::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_526a.2bpp"
	db $00, $00, $00, $00, $00, $00

; ---- gfx $52C0-$56C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:47DD: hl=$52C0 a=$56 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_ConnectDialog_ConnectConfirm_Tiles9000Vb1:: ; 56:52C0
Data_56_52C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_52c0.2bpp"

; ---- gfx $56C0-$5AC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:47EF: hl=$56C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_ConnectDialog_ConnectConfirm_Tiles9400Vb1:: ; 56:56C0
Data_56_56C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_56c0.2bpp"

; ---- gfx $5AC0-$5DC0 (768 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:496A 57:4ADB); first: hdma_rom_to_vram at 57:496A: hl=$5AC0 a=$56 c=$30 de=$8800 (dest VRAM $8800, vbank=0) [first call site executed: 99 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800:: ; 56:5AC0
Data_56_5AC0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_5ac0.2bpp"

; ---- gfx $5DC0-$60C0 (768 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:498E 57:4AFF); first: hdma_rom_to_vram at 57:498E: hl=$5DC0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [first call site executed: 99 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1:: ; 56:5DC0
Data_56_5DC0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_5dc0.2bpp"

; ---- gfx $60C0-$64C0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:49A0 57:4B11); first: hdma_rom_to_vram at 57:49A0: hl=$60C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 99 hits in 4 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1:: ; 56:60C0
Data_56_60C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_60c0.2bpp"

; ---- gfx $64C0-$68C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E58: hl=$64C0 a=$56 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_ConnectDialog_StoredPassword_Tiles8800:: ; 56:64C0
Data_56_64C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_64c0.2bpp"

; ---- gfx $68C0-$6AC0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E6A: hl=$67C0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [clipped from 67C0-6AC0 by higher-priority evidence]

Data_56_68C0:: ; 56:68C0
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_68c0.2bpp"

; ---- gfx $6AC0-$6EC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4E7C: hl=$6AC0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_ConnectDialog_StoredPassword_Tiles9400Vb1:: ; 56:6AC0
Data_56_6AC0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_6ac0.2bpp"

; ---- gfx $6EC0-$71C0 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4D4C: hl=$6EC0 a=$56 c=$30 de=$9101 (dest VRAM $9100, vbank=1) [first call site executed: 3 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnectDialog_PasswordSaved_Tiles9100Vb1:: ; 56:6EC0
Data_56_6EC0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_6ec0.2bpp"

; ---- gfx $71C0-$75C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 57:4D5E: hl=$71C0 a=$56 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 3 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnectDialog_PasswordSaved_Tiles9400Vb1:: ; 56:71C0
Data_56_71C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_71c0.2bpp"

; ---- gfx $75C0-$77C0 (512 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:5083 57:50E4); first: hdma_rom_to_vram at 57:5083: hl=$75C0 a=$56 c=$20 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_ConnectDialog_Finish_Tiles8000:: ; 56:75C0
Data_56_75C0::
	INCBIN "gfx/comm/connect_dialog_bank56/tiles_75c0.2bpp"

; ---- data $77C0-$7880 (192 bytes) [PROBABLE] 24 CGB palettes x 4 RGB555 words, all 96 words have bit15 clear (77C0-7880); 7820-7836 and 798D.. parts read by executed code (copy to palette RAM in up to 6/18 scenarios); the mapper heuristic ended the second block at 7896 but the words at 7880+ are pointers (84 78 8d 78 ..)

Palette_ConnectDialog_Bg:: ; 56:77C0
Palette_56_77C0::
	INCLUDE "gfx/comm/connect_dialog_bank56/palette_77c0.pal"

; ---- data $7880-$79B8 (312 bytes) [PROBABLE] 5 object record(s): 5 frame tables, 15 frames, 5 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 56:7880-79B8 [v4: bytes 798D-79B8 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

ConnectDialog_ObjAnimData:: ; 56:7880
Data_56_7880::
	sprite_frame_table SpriteFrame_56_7884, SpriteFrame_56_788D
SpriteFrame_56_7884:: ; 56:7884
	sprite_frame 2
	sprite_oam 2, -1, $00, 0
	sprite_oam 10, -1, $01, 0
SpriteFrame_56_788D:: ; 56:788D
	sprite_frame 1
	sprite_oam 0, 0, $1E, 0
SpriteScript_56_7892:: ; 56:7892
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
SpriteFrameTable_56_7897:: ; 56:7897
	sprite_frame_table SpriteFrame_56_789F, SpriteFrame_56_78B0, SpriteFrame_56_78C1, SpriteFrame_56_78D2
SpriteFrame_56_789F:: ; 56:789F
	sprite_frame 4
	sprite_oam 2, -2, $09, 0
	sprite_oam 2, 6, $0A, 0
	sprite_oam 10, -2, $0B, 0
	sprite_oam 10, 6, $0C, 0
SpriteFrame_56_78B0:: ; 56:78B0
	sprite_frame 4
	sprite_oam 2, -2, $0D, 0
	sprite_oam 2, 6, $0E, 0
	sprite_oam 10, -2, $0F, 0
	sprite_oam 10, 6, $10, 0
SpriteFrame_56_78C1:: ; 56:78C1
	sprite_frame 4
	sprite_oam 2, -2, $11, 0
	sprite_oam 2, 6, $12, 0
	sprite_oam 10, -2, $13, 0
	sprite_oam 10, 6, $14, 0
SpriteFrame_56_78D2:: ; 56:78D2
	sprite_frame 4
	sprite_oam 2, -2, $0D, 0
	sprite_oam 2, 6, $0E, 0
	sprite_oam 10, -2, $0F, 0
	sprite_oam 10, 6, $10, 0
SpriteScript_56_78E3:: ; 56:78E3
	sprite_anim 4
	sprite_anim_step 0, 12
	sprite_anim_step 1, 10
	sprite_anim_step 2, 15
	sprite_anim_step 3, 10
SpriteFrameTable_56_78EC:: ; 56:78EC
	sprite_frame_table SpriteFrame_56_78F4, SpriteFrame_56_7901, SpriteFrame_56_7916, SpriteFrame_56_792B
SpriteFrame_56_78F4:: ; 56:78F4
	sprite_frame 3
	sprite_oam 10, -2, $16, 0
	sprite_oam 10, 6, $17, 0
	sprite_oam 2, 6, $15, 0
SpriteFrame_56_7901:: ; 56:7901
	sprite_frame 5
	sprite_oam 1, 6, $18, 0
	sprite_oam 9, -2, $19, 0
	sprite_oam 9, 6, $1A, 0
	sprite_oam 2, -3, $07, 0
	sprite_oam 11, 7, $08, 0
SpriteFrame_56_7916:: ; 56:7916
	sprite_frame 5
	sprite_oam 2, 4, $1B, 0
	sprite_oam 10, -4, $1C, 0
	sprite_oam 10, 4, $02, 0
	sprite_oam 1, -4, $07, 0
	sprite_oam 11, 8, $08, 0
SpriteFrame_56_792B:: ; 56:792B
	sprite_frame 6
	sprite_oam 4, -5, $03, 0
	sprite_oam 4, 3, $04, 0
	sprite_oam 12, -5, $05, 0
	sprite_oam 12, 3, $06, 0
	sprite_oam 0, -5, $07, 0
	sprite_oam 11, 9, $08, 0
SpriteScript_56_7944:: ; 56:7944
	sprite_anim 4
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
	sprite_anim_step 2, 5
	sprite_anim_step 3, 10
SpriteFrameTable_56_794D:: ; 56:794D
	sprite_frame_table SpriteFrame_56_7953, SpriteFrame_56_7964, SpriteFrame_56_7975
SpriteFrame_56_7953:: ; 56:7953
	sprite_frame 4
	sprite_oam 2, -2, $09, 0
	sprite_oam 2, 6, $0A, 0
	sprite_oam 10, -2, $0B, 0
	sprite_oam 10, 6, $0C, 0
SpriteFrame_56_7964:: ; 56:7964
	sprite_frame 4
	sprite_oam -2, -2, $09, 0
	sprite_oam -2, 6, $0A, 0
	sprite_oam 6, -2, $0B, 0
	sprite_oam 6, 6, $0C, 0
SpriteFrame_56_7975:: ; 56:7975
	sprite_frame 4
	sprite_oam 2, -2, $09, 0
	sprite_oam 2, 6, $0A, 0
	sprite_oam 10, -2, $0B, 0
	sprite_oam 10, 6, $0C, 0
SpriteScript_56_7986:: ; 56:7986
	sprite_anim 3
	sprite_anim_step 0, 5
	sprite_anim_step 1, 8
	sprite_anim_step 2, 10
SpriteFrameTable_56_798D:: ; 56:798D
	sprite_frame_table SpriteFrame_56_7991, SpriteFrame_56_79A2
SpriteFrame_56_7991:: ; 56:7991
	sprite_frame 4
	sprite_oam -2, -2, $1D, 0
	sprite_oam -2, 26, $1D, OAMF_XFLIP
	sprite_oam 10, -2, $1D, OAMF_YFLIP
	sprite_oam 10, 26, $1D, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_56_79A2:: ; 56:79A2
	sprite_frame 4
	sprite_oam -3, -3, $1D, 0
	sprite_oam -3, 27, $1D, OAMF_XFLIP
	sprite_oam 11, -3, $1D, OAMF_YFLIP
	sprite_oam 11, 27, $1D, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_56_79B3:: ; 56:79B3
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $79B8-$79D0 (24 bytes) [PROBABLE] 6 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$79B8 a=$56 is loaded before init_object_from_table at 57:42BA and 10 more sites; all 6 entries hit frame-table/script starts of the sweep 7880-79B8; object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 79CC-79D0 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

ConnectDialog_ObjTable:: ; 56:79B8
Table_56_79B8::
	sprite_object_entry ConnectDialog_ObjAnimData, SpriteScript_56_7892 ; entry 0
	sprite_object_entry SpriteFrameTable_56_7897, SpriteScript_56_78E3 ; entry 1
	sprite_object_entry SpriteFrameTable_56_78EC, SpriteScript_56_7944 ; entry 2
	sprite_object_entry SpriteFrameTable_56_794D, SpriteScript_56_7986 ; entry 3
	sprite_object_entry 0, 0 ; entry 4
	sprite_object_entry SpriteFrameTable_56_798D, SpriteScript_56_79B3 ; entry 5
