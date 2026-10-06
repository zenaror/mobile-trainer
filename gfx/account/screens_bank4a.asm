; gfx/account/screens_bank4a.asm
; bank 4A, $4000-$5F80 (8064 bytes); pinned by layout.link
; account/registration screen art (loaded by bank 68)

SECTION "gfx/account/screens_bank4a", ROMX

; ---- words $4000-$4004 (4 bytes) [PROBABLE] entry 0 (all zero, unused) of the 4-byte-entry object table at 4A:4000 read by init_object_from_table (00:0A82; entry 1 at 4004 = 4008,402E is the CONFIRMED read data right after); same family as 72:4E40/72:7828 [verifier: the original text said 4E:4E40, which is code; the sibling table is 72:4E40]

ConfirmPages_ObjTable:: ; 4A:4000
Table_4A_4000::
	sprite_object_entry 0, 0 ; entry 0

; ---- data $4004-$4033 (47 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Data_4A_4004:: ; 4A:4004
	sprite_object_entry SpriteFrameTable_4A_4008, SpriteScript_4A_402E ; entry 1
SpriteFrameTable_4A_4008:: ; 4A:4008
	sprite_frame_table SpriteFrame_4A_400C, SpriteFrame_4A_401D
SpriteFrame_4A_400C:: ; 4A:400C
	sprite_frame 4
	sprite_oam 0, 0, $00, OAMF_BANK1 | 7
	sprite_oam 8, 0, $00, OAMF_YFLIP | OAMF_BANK1 | 7
	sprite_oam 0, 24, $00, OAMF_XFLIP | OAMF_BANK1 | 7
	sprite_oam 8, 24, $00, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 7
SpriteFrame_4A_401D:: ; 4A:401D
	sprite_frame 4
	sprite_oam -1, -1, $00, OAMF_BANK1 | 7
	sprite_oam 9, -1, $00, OAMF_YFLIP | OAMF_BANK1 | 7
	sprite_oam -1, 25, $00, OAMF_XFLIP | OAMF_BANK1 | 7
	sprite_oam 9, 25, $00, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 7
SpriteScript_4A_402E:: ; 4A:402E
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- zero $4033-$4040 (13 bytes) [PROBABLE] 13 x 00 between the descriptor data ending at 4033 and the tile block at 4A:4040
	ds $D, $00

; ---- gfx $4040-$4240 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:5107: hl=$4040 a=$4A c=$20 de=$8001 (dest VRAM $8000, vbank=1)

Gfx_SettingsMenu_Tiles8000Vb1:: ; 4A:4040
Data_4A_4040::
	INCBIN "gfx/account/screens_bank4a/tiles_4040.2bpp"

; ---- gfx $4240-$4640 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:50BF: hl=$4240 a=$4A c=$40 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_SettingsMenu_Tiles8800Vb1:: ; 4A:4240
Data_4A_4240::
	INCBIN "gfx/account/screens_bank4a/tiles_4240.2bpp"

; ---- gfx $4640-$4A40 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:50D1: hl=$4640 a=$4A c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_SettingsMenu_Tiles8C00Vb1:: ; 4A:4640
Data_4A_4640::
	INCBIN "gfx/account/screens_bank4a/tiles_4640.2bpp"

; ---- gfx $4A40-$4E40 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:50E3: hl=$4A40 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_SettingsMenu_Tiles9000Vb1:: ; 4A:4A40
Data_4A_4A40::
	INCBIN "gfx/account/screens_bank4a/tiles_4a40.2bpp"

; ---- gfx $4E40-$5180 (832 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:50F5: hl=$4E40 a=$4A c=$40 de=$9401 (dest VRAM $9400, vbank=1); the last $C0 bytes of the old blob hold 2 palettes, a 32-byte gap that no code reads and the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_SettingsMenu_Tiles9400Vb1:: ; 4A:4E40
Data_4A_4E40::
	INCBIN "gfx/account/screens_bank4a/tiles_4e40.2bpp"

; ---- data $5180-$51A8 (40 bytes) [CONFIRMED] palette-rgb555: 20 colours (5 palettes) read by Palette_LoadToBuffer: +$00 bc=$28 into wPaletteBufBg (engine/account/settings_menu.asm:190, call 68:5118 executed 538 hits in 15 scenarios (analysis/coverage_union.tsv))

Palette_SettingsMenu_Bg:: ; 4A:5180
	INCLUDE "gfx/account/screens_bank4a/settings_menu_bg.pal"

; ---- data $51A8-$51B0 (8 bytes) [CONFIRMED] palette-rgb555: 4 colours (1 palettes) read by Palette_LoadToBuffer: +$00 bc=$08 into wPaletteBufObj (engine/account/settings_menu.asm:195, call 68:5129 executed 538 hits in 15 scenarios (analysis/coverage_union.tsv))

Palette_SettingsMenu_Obj:: ; 4A:51A8
	INCLUDE "gfx/account/screens_bank4a/settings_menu_obj.pal"

; ---- data $51B0-$51D0 (32 bytes) [HYPOTHESIS] four copies of the colours 0000 294A 56B5 7FFF (a grey ramp: the same 32 bytes occur 55 times in the ROM as a default palette block); between the OBJ palette and the tilemap, read by no code that was found; probably unread OBJ palettes 1-4

Data_4A_51B0:: ; 4A:51B0
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $51D0-$54A0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:523D: hl=$51D0 a=$4A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_SettingsMenu_4A_51D0:: ; 4A:51D0
	INCBIN "gfx/account/screens_bank4a/settings_menu_4a_51d0.tilemap"
	INCBIN "gfx/account/screens_bank4a/settings_menu_4a_51d0.attrmap"

; ---- data $54A0-$5770 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:5250: hl=$54A0 a=$4A b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 96 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsMenu:: ; 4A:54A0
Data_4A_54A0::
	INCBIN "gfx/account/screens_bank4a/tilemap_54a0.tilemap"
	INCBIN "gfx/account/screens_bank4a/tilemap_54a0.attrmap"

; ---- data $5770-$5810 (160 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_4A_5770:: ; 4A:5770
	db $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $90, $91, $92, $93, $94, $95
	db $96, $97, $98, $99, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $8A, $8B, $8C, $8D, $8E, $8F, $A0, $A1
	db $A2, $A3, $9A, $9B, $9C, $9D, $9E, $9F, $B0, $B1, $B2, $B3, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $8A, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $A3, $9A, $B4, $B5, $B6, $B7, $B8
	db $B9, $BA, $BB, $B3, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $AC, $AD, $AE, $AF, $C0, $C1, $C2, $C3
	db $C4, $C5, $BC, $BD, $BE, $BF, $D0, $D1, $D2, $D3, $D4, $D5, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

; ---- data $5810-$5838 (40 bytes) [PROBABLE] tail of the 10-row x 20-column block of tile numbers 4A:5770-5838 (rows of 20: 80..99 / $0A filler / 8A.. ; the first 160 bytes are CONFIRMED read data): two more rows, 40 bytes

Data_4A_5810:: ; 4A:5810
	db $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $89, $D6, $D7, $D8, $D9, $DA, $DB
	db $DC, $DD, $DE, $99, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A

; ---- words $5838-$583C (4 bytes) [PROBABLE] entry 0 (4 x 00, unused) of the object table at 4A:5838: ld de,$5838 ; a=$4A ; b=$81 ; init_object_from_table (00:0A82) at 68:513A-5145; entry 1 (583C, CONFIRMED read) follows

SettingsMenu_ObjTable:: ; 4A:5838
Table_4A_5838::
	sprite_object_entry 0, 0 ; entry 0

; ---- data $583C-$5860 (36 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 583C-586B by higher-priority evidence]

Data_4A_583C:: ; 4A:583C
	db $40, $58, $66, $58 ; sprite object-table entry kept as db: pointer target 4A:5866 has no label
SpriteFrameTable_4A_5840:: ; 4A:5840
	sprite_frame_table SpriteFrame_4A_5844, SpriteFrame_4A_5855
SpriteFrame_4A_5844:: ; 4A:5844
	sprite_frame 4
	sprite_oam 0, -1, $00, OAMF_BANK1
	sprite_oam 8, -1, $10, OAMF_BANK1
	sprite_oam 0, 89, $00, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 8, 89, $10, OAMF_XFLIP | OAMF_BANK1
SpriteFrame_4A_5855:: ; 4A:5855
	db $04, $00, $FE, $00, $08, $08, $FE, $10, $08, $00, $5A ; sprite frame record kept as db: the item crosses the end of its block

; ---- gfx $5860-$5870 (16 bytes) [PROBABLE] tiles-2bpp: heuristic: 56 coherent tiles (hsim2=0.705 vsim2=0.733, 10 blank) parity 0; 1024/1104 bytes also covered by call-site blocks [clipped from 5860-5CB0 by higher-priority evidence]

Data_4A_5860:: ; 4A:5860
	INCBIN "gfx/account/screens_bank4a/tiles_5860.2bpp"

; ---- gfx $5870-$5C70 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 68:649A: hl=$5870 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 10 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_Account_ConfirmManualScreen_Tiles9000Vb1:: ; 4A:5870
Data_4A_5870::
	INCBIN "gfx/account/screens_bank4a/tiles_5870.2bpp"

; ---- data $5C70-$5CB0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/account/confirm_screens.asm:291, call 68:64BD executed 10 hits in 2 scenarios (analysis/coverage_union.tsv))

Palette_Account_ConfirmManualScreen_Bg:: ; 4A:5C70
Data_4A_5C70::
	INCLUDE "gfx/account/screens_bank4a/account_confirm_manual_screen_bg.pal"

; ---- data $5CB0-$5F80 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 68:64DF: hl=$5CB0 a=$4A b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 10 hits in 2 scenarios (analysis/coverage_union.tsv)]

Tilemap_Account_ConfirmManualScreen:: ; 4A:5CB0
Data_4A_5CB0::
	INCBIN "gfx/account/screens_bank4a/tilemap_5cb0.tilemap"
	INCBIN "gfx/account/screens_bank4a/tilemap_5cb0.attrmap"
