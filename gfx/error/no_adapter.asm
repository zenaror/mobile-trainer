; gfx/error/no_adapter.asm
; bank 63, $6080-$732F (4783 bytes); pinned by layout.link
; no-adapter screen tiles, tilemap, palettes, object table and animation

SECTION "gfx/error/no_adapter", ROMX

; ---- gfx $6080-$6480 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7365: hl=$6080 a=$63 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

NoAdapter_Gfx_8000:: ; 63:6080
Data_63_6080::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8000.2bpp"

NoAdapter_Gfx_8800:: ; 63:60C0
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8800.2bpp"

; ---- gfx $6480-$64C0 (64 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7377: hl=$60C0 a=$63 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 60C0-64C0 by higher-priority evidence]

Data_63_6480:: ; 63:6480
	INCBIN "gfx/error/no_adapter/tiles_6480.2bpp"

; ---- gfx $64C0-$68C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7389: hl=$64C0 a=$63 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

NoAdapter_Gfx_8C00:: ; 63:64C0
Data_63_64C0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8c00.2bpp"

; ---- gfx $68C0-$6CC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:739B: hl=$68C0 a=$63 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

NoAdapter_Gfx_9000:: ; 63:68C0
Data_63_68C0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_9000.2bpp"

; ---- gfx $6CC0-$70C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:73AD: hl=$6CC0 a=$63 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

NoAdapter_Gfx_9400:: ; 63:6CC0
Data_63_6CC0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_9400.2bpp"

NoAdapter_Tilemap:: ; 63:6FC0
	db $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8, $E9, $10, $11
	db $12, $13, $14, $15, $16, $17, $18, $19, $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7
	db $F8, $F9, $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $00, $01, $02, $03
	db $04, $05, $06, $07, $08, $09, $30, $31, $32, $33, $2A, $2B, $2C, $2D, $2E, $2F
	db $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $36, $37, $38, $EB, $EC
	db $ED, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $46
	db $47, $48, $FB, $FC, $FD, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $56, $57, $58, $0B, $0C, $0D, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $66, $67, $68, $1B, $1C, $1D, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34, $34
	db $34, $34, $34, $34, $34, $34, $34, $34, $34, $EE, $EF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $EF, $EE, $34, $34, $FE, $80, $81
	db $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F, $FE, $34
	db $34, $FE, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D

; ---- data $70C0-$7290 (464 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 63:73E0: hl=$6FC0 a=$63 b=18 rows c=20 cols (tiles then attrs) de=$D000 [clipped from 6FC0-7290 by higher-priority evidence]

Data_63_70C0:: ; 63:70C0
	db $9E, $9F, $FE, $34, $34, $FE, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9
	db $AA, $AB, $AC, $AD, $AE, $AF, $FE, $34, $34, $FE, $B0, $B1, $B2, $B3, $B4, $B5
	db $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $FE, $34, $34, $FE, $C0, $C1
	db $C2, $C3, $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $FE, $34
	db $34, $0E, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC, $DD
	db $DE, $DF, $0E, $34, $34, $1E, $1F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F
	db $0F, $0F, $0F, $0F, $0F, $0F, $1E, $34, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $08, $08, $08, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $08, $0A, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0A, $08, $0A, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $08
	db $08, $08, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $29, $29, $0B, $0B, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $29, $0B, $0B, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $0B, $0B, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $0B
	db $0B, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $29, $0B, $0B, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $29, $0B, $0B, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $0B, $0B, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $0B

; ---- data $7290-$72B8 (40 bytes) [PROBABLE] palette-rgb555: heuristic: 20 RGB555 words as 5 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

NoAdapter_Palette_Bg:: ; 63:7290
Data_63_7290::
	INCLUDE "gfx/error/no_adapter/no_adapter_palette_bg.pal"

; ---- data $72B8-$7310 (88 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6080-7310 by higher-priority evidence]

Data_63_72B8:: ; 63:72B8
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00

NoAdapter_Palette_Obj:: ; 63:72D0
	INCLUDE "gfx/error/no_adapter/no_adapter_palette_obj.pal"

; ---- words $7310-$7318 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$7310 a=$63 at 63:73F5 (entry 0 unused, entry 1 = 7318/732A); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 7314-7318 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

NoAdapter_ObjTable:: ; 63:7310
Table_63_7310::
	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry NoAdapter_ObjAnim, SpriteScript_63_732A ; entry 1

; ---- data $7318-$732F (23 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 63:7318-732F [v4: bytes 7318-732F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

NoAdapter_ObjAnim:: ; 63:7318
Data_63_7318::
	sprite_frame_table SpriteFrame_63_731C, SpriteFrame_63_7325
SpriteFrame_63_731C:: ; 63:731C
	sprite_frame 2
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
SpriteFrame_63_7325:: ; 63:7325
	sprite_frame 1
	sprite_oam 8, 8, $02, 0
SpriteScript_63_732A:: ; 63:732A
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 30
