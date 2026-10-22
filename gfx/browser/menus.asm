; gfx/browser/menus.asm
; bank 72, $6C10-$7A1F (3599 bytes); pinned by layout.link
; browser menu tiles, maps, palette, cursor object table

SECTION "gfx/browser/menus", ROMX

; ---- gfx $6C10-$7010 (1024 bytes) [CONFIRMED] tiles-vram: 3 call site(s) (4E:61C1 4E:62BC 72:6733); first: hdma_rom_to_vram at 4E:61C1: hl=$6C10 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

BrowserMenu3_Tiles0:: ; 72:6C10
	INCBIN "gfx/browser/menus/browser_menu3_tiles0.2bpp"

; ---- gfx $7010-$7110 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:6745: hl=$7010 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1)

BrowserMenu3_Tiles1:: ; 72:7010
	INCBIN "gfx/browser/menus/browser_menu3_tiles1.2bpp"

; ---- data $7110-$7200 (240 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:6767: hl=$7110 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180

BrowserMenu3_Map:: ; 72:7110
	INCBIN "gfx/browser/menus/browser_menu3_map.tilemap"
	INCBIN "gfx/browser/menus/browser_menu3_map.attrmap"

; ---- data $7200-$7210 (16 bytes) [CONFIRMED] palette-rgb555: 8 colours (2 palettes) read by Palette_LoadToBuffer: +$00 bc=$10 into wPaletteBufBg + $30 (engine/browser/menus.asm:451, call 72:6756 executed 17 hits in 6 scenarios (analysis/coverage_union.tsv))

Palette_BrowserMenu_Bg6:: ; 72:7200
	INCLUDE "gfx/browser/menus/browser_menu_bg6.pal"

; ---- data $7210-$7218 (8 bytes) [CONFIRMED] palette-rgb555: 4 colours (1 palettes) read by Palette_LoadToBuffer: +$00 bc=$08 into wPaletteBufObj + $20 (engine/browser/menus.asm:461, call 72:6778 executed 17 hits in 6 scenarios (analysis/coverage_union.tsv))

Palette_BrowserMenu_Obj4:: ; 72:7210
	INCLUDE "gfx/browser/menus/browser_menu_obj4.pal"

; ---- zero $7218-$7220 (8 bytes) [PROBABLE] 8 x 00 padding between the palette/data at 72:7206-7218 and the tile block 72:7220
	ds $8, $00

; ---- gfx $7220-$7620 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:640B: hl=$7220 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

BrowserMenu2_Tiles0:: ; 72:7220
	INCBIN "gfx/browser/menus/browser_menu2_tiles0.2bpp"

; ---- gfx $7620-$7720 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:63F9: hl=$7620 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1) [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

BrowserMenu2_Tiles1:: ; 72:7620
	INCBIN "gfx/browser/menus/browser_menu2_tiles1.2bpp"

; ---- data $7720-$7810 (240 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:642D: hl=$7720 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180 [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

BrowserMenu2_Map:: ; 72:7720
	INCBIN "gfx/browser/menus/browser_menu2_map.tilemap"
	INCBIN "gfx/browser/menus/browser_menu2_map.attrmap"

; ---- data $7810-$7828 (24 bytes) [PROBABLE] 3 RGB555 palettes of 4 colours (bit15 clear, black/white ends); 7810 is loaded by ld hl,$7810 (bc=$0010 -> de=$D830, far call 4F:4000) at 72:6417; the third group (7820) follows the same format

BrowserMenu2_Palette:: ; 72:7810
	INCLUDE "gfx/browser/menus/browser_menu2_palette.pal"

; ---- words $7828-$786C (68 bytes) [PROBABLE] object table for init_object_from_table (00:0A82, de=$7828 a=$72, 4-byte entries = 2 words; callers 4E:5F08.., 72:45D2, 72:46D4, 72:64C6, 72:66BE, 72:6802, 72:6A12); 17 entries, every word lands exactly on a descriptor start of the data block 72:786C-7A1F (partition check)

BrowserShared_ObjTable:: ; 72:7828
	sprite_object_entry BrowserMenu_Cursor_ObjAnimData_72_78CA, SpriteScript_BrowserShared_ObjectEntry00 ; entry 0
	sprite_object_entry BrowserMenu_Cursor_ObjAnimData_72_78CA, SpriteScript_BrowserShared_ObjectEntry00 ; entry 1
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry02, SpriteScript_BrowserShared_ObjectEntry02 ; entry 2
	sprite_object_entry BrowserShared_ObjAnimData_72_79A0, SpriteScript_BrowserShared_ObjectEntry03 ; entry 3
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry04, SpriteScript_BrowserShared_ObjectEntry04 ; entry 4
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry05, SpriteScript_BrowserShared_ObjectEntry05 ; entry 5
	sprite_object_entry BrowserShared_ObjAnimData_72_795B, SpriteScript_BrowserShared_ObjectEntry06 ; entry 6
	sprite_object_entry BrowserShared_ObjAnimData_72_78F5, SpriteScript_BrowserShared_ObjectEntry07 ; entry 7
	sprite_object_entry BrowserShared_ObjAnimData_72_7894, SpriteScript_BrowserShared_ObjectEntry08 ; entry 8
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry09, SpriteScript_BrowserShared_ObjectEntry09 ; entry 9
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry10, SpriteScript_BrowserShared_ObjectEntry10 ; entry 10
	sprite_object_entry BrowserShared_ObjAnimData_72_7A04, SpriteScript_BrowserShared_ObjectEntry11 ; entry 11
BrowserShared_ObjTable_Entry12:: ; 72:7858
	sprite_object_entry BrowserShared_Anim12Frames, SpriteScript_BrowserShared_ObjectEntry12 ; entry 12
	sprite_object_entry BrowserShared_Anim12Frames, SpriteScript_BrowserShared_ObjectEntry12 ; entry 13
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry14, SpriteScript_BrowserShared_ObjectEntry14 ; entry 14
	sprite_object_entry BrowserShared_ObjAnimData_72_7880, SpriteScript_BrowserShared_ObjectEntry15 ; entry 15
	sprite_object_entry SpriteFrameTable_BrowserShared_ObjectEntry16, SpriteScript_BrowserShared_ObjectEntry16 ; entry 16

; ---- data $786C-$786E (2 bytes) [PROBABLE] descriptor $786C = dw $786E (first word of the animation/sprite data block; target of table entry words)

BrowserShared_Anim12Frames:: ; 72:786C
	sprite_frame_table BrowserShared_ObjAnimData_72_786E

; ---- data $786E-$7880 (18 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_786E:: ; 72:786E
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_BrowserShared_ObjectEntry12:: ; 72:7873
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_BrowserShared_ObjectEntry14:: ; 72:7876
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry14_Frame00
SpriteFrame_BrowserShared_ObjectEntry14_Frame00:: ; 72:7878
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_BrowserShared_ObjectEntry14:: ; 72:787D
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $7880-$7894 (20 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_7880:: ; 72:7880
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry15_Frame00
SpriteFrame_BrowserShared_ObjectEntry15_Frame00:: ; 72:7882
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_BrowserShared_ObjectEntry15:: ; 72:7887
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_BrowserShared_ObjectEntry16:: ; 72:788A
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry16_Frame00
SpriteFrame_BrowserShared_ObjectEntry16_Frame00:: ; 72:788C
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_BrowserShared_ObjectEntry16:: ; 72:7891
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $7894-$78CA (54 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_7894:: ; 72:7894
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry08_Frame00, SpriteFrame_BrowserShared_ObjectEntry08_Frame01
SpriteFrame_BrowserShared_ObjectEntry08_Frame00:: ; 72:7898
	sprite_frame 2
	sprite_oam 0, 0, $0B, 7
	sprite_oam 0, 8, $0C, 7
SpriteFrame_BrowserShared_ObjectEntry08_Frame01:: ; 72:78A1
	sprite_frame 2
	sprite_oam -1, 0, $0B, 7
	sprite_oam -1, 8, $0C, 7
SpriteScript_BrowserShared_ObjectEntry08:: ; 72:78AA
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_BrowserShared_ObjectEntry09:: ; 72:78AF
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry09_Frame00, SpriteFrame_BrowserShared_ObjectEntry09_Frame01
SpriteFrame_BrowserShared_ObjectEntry09_Frame00:: ; 72:78B3
	sprite_frame 2
	sprite_oam 0, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 0, 8, $0C, OAMF_YFLIP | 7
SpriteFrame_BrowserShared_ObjectEntry09_Frame01:: ; 72:78BC
	sprite_frame 2
	sprite_oam 1, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 1, 8, $0C, OAMF_YFLIP | 7
SpriteScript_BrowserShared_ObjectEntry09:: ; 72:78C5
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $78CA-$78F5 (43 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_78CA:: ; 72:78CA
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry00_Frame00, SpriteFrame_BrowserShared_ObjectEntry00_Frame01
SpriteFrame_BrowserShared_ObjectEntry00_Frame00:: ; 72:78CE
	sprite_frame 4
	sprite_oam -2, -2, $81, OAMF_BANK1 | 4
	sprite_oam -2, 10, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 10, -2, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam 10, 10, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteFrame_BrowserShared_ObjectEntry00_Frame01:: ; 72:78DF
	sprite_frame 4
	sprite_oam -3, -3, $81, OAMF_BANK1 | 4
	sprite_oam -3, 11, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 11, -3, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam 11, 11, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteScript_BrowserShared_ObjectEntry00:: ; 72:78F0
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $78F5-$795B (102 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_78F5:: ; 72:78F5
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry07_Frame00, SpriteFrame_BrowserShared_ObjectEntry07_Frame01
SpriteFrame_BrowserShared_ObjectEntry07_Frame00:: ; 72:78F9
	sprite_frame 8
	sprite_oam -19, -8, $F8, OAMF_BANK1 | 4
	sprite_oam -19, 0, $F9, OAMF_BANK1 | 4
	sprite_oam -19, 8, $FA, OAMF_BANK1 | 4
	sprite_oam -19, 16, $FB, OAMF_BANK1 | 4
	sprite_oam -11, -8, $FC, OAMF_BANK1 | 4
	sprite_oam -11, 0, $FD, OAMF_BANK1 | 4
	sprite_oam -11, 8, $FE, OAMF_BANK1 | 4
	sprite_oam -11, 16, $FF, OAMF_BANK1 | 4
SpriteFrame_BrowserShared_ObjectEntry07_Frame01:: ; 72:791A
	sprite_frame 8
	sprite_oam -20, -8, $F8, OAMF_BANK1 | 4
	sprite_oam -20, 0, $F9, OAMF_BANK1 | 4
	sprite_oam -20, 8, $FA, OAMF_BANK1 | 4
	sprite_oam -20, 16, $FB, OAMF_BANK1 | 4
	sprite_oam -12, -8, $FC, OAMF_BANK1 | 4
	sprite_oam -12, 0, $FD, OAMF_BANK1 | 4
	sprite_oam -12, 8, $FE, OAMF_BANK1 | 4
	sprite_oam -12, 16, $FF, OAMF_BANK1 | 4
SpriteScript_BrowserShared_ObjectEntry07:: ; 72:793B
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_BrowserShared_ObjectEntry05:: ; 72:7940
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry05_Frame00, SpriteFrame_BrowserShared_ObjectEntry05_Frame01
SpriteFrame_BrowserShared_ObjectEntry05_Frame00:: ; 72:7944
	sprite_frame 2
	sprite_oam 0, 0, $0B, 7
	sprite_oam 0, 8, $0C, 7
SpriteFrame_BrowserShared_ObjectEntry05_Frame01:: ; 72:794D
	sprite_frame 2
	sprite_oam -1, 0, $0B, 7
	sprite_oam -1, 8, $0C, 7
SpriteScript_BrowserShared_ObjectEntry05:: ; 72:7956
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $795B-$79A0 (69 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_795B:: ; 72:795B
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry06_Frame00, SpriteFrame_BrowserShared_ObjectEntry06_Frame01
SpriteFrame_BrowserShared_ObjectEntry06_Frame00:: ; 72:795F
	sprite_frame 2
	sprite_oam 0, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 0, 8, $0C, OAMF_YFLIP | 7
SpriteFrame_BrowserShared_ObjectEntry06_Frame01:: ; 72:7968
	sprite_frame 2
	sprite_oam 1, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 1, 8, $0C, OAMF_YFLIP | 7
SpriteScript_BrowserShared_ObjectEntry06:: ; 72:7971
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_BrowserShared_ObjectEntry02:: ; 72:7976
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry02_Frame00
SpriteFrame_BrowserShared_ObjectEntry02_Frame00:: ; 72:7978
	sprite_frame 9
	sprite_oam -19, -8, $82, OAMF_BANK1 | 4
	sprite_oam -19, 0, $83, OAMF_BANK1 | 4
	sprite_oam -19, 8, $84, OAMF_BANK1 | 4
	sprite_oam -19, 16, $85, OAMF_BANK1 | 4
	sprite_oam -11, -8, $92, OAMF_BANK1 | 4
	sprite_oam -11, 0, $93, OAMF_BANK1 | 4
	sprite_oam -11, 8, $94, OAMF_BANK1 | 4
	sprite_oam -11, 16, $95, OAMF_BANK1 | 4
	sprite_oam -11, 24, $96, OAMF_BANK1 | 4
SpriteScript_BrowserShared_ObjectEntry02:: ; 72:799D
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $79A0-$7A04 (100 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_79A0:: ; 72:79A0
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry03_Frame00
SpriteFrame_BrowserShared_ObjectEntry03_Frame00:: ; 72:79A2
	sprite_frame 7
	sprite_oam -19, -7, $87, OAMF_BANK1 | 4
	sprite_oam -19, 1, $88, OAMF_BANK1 | 4
	sprite_oam -19, 9, $89, OAMF_BANK1 | 4
	sprite_oam -11, -7, $97, OAMF_BANK1 | 4
	sprite_oam -11, 1, $98, OAMF_BANK1 | 4
	sprite_oam -11, 9, $99, OAMF_BANK1 | 4
	sprite_oam -11, 17, $86, OAMF_BANK1 | 4
SpriteScript_BrowserShared_ObjectEntry03:: ; 72:79BF
	sprite_anim 1
	sprite_anim_step 0, 4
	db $00
SpriteFrameTable_BrowserShared_ObjectEntry04:: ; 72:79C3
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry04_Frame00
SpriteFrame_BrowserShared_ObjectEntry04_Frame00:: ; 72:79C5
	sprite_frame 8
	sprite_oam -19, -8, $8A, OAMF_BANK1 | 4
	sprite_oam -19, 0, $8B, OAMF_BANK1 | 4
	sprite_oam -19, 8, $8C, OAMF_BANK1 | 4
	sprite_oam -19, 16, $8D, OAMF_BANK1 | 4
	sprite_oam -11, -8, $9A, OAMF_BANK1 | 4
	sprite_oam -11, 0, $9B, OAMF_BANK1 | 4
	sprite_oam -11, 8, $9C, OAMF_BANK1 | 4
	sprite_oam -11, 16, $9D, OAMF_BANK1 | 4
SpriteScript_BrowserShared_ObjectEntry04:: ; 72:79E6
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_BrowserShared_ObjectEntry10:: ; 72:79E9
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry10_Frame00, SpriteFrame_BrowserShared_ObjectEntry10_Frame01
SpriteFrame_BrowserShared_ObjectEntry10_Frame00:: ; 72:79ED
	sprite_frame 2
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
SpriteFrame_BrowserShared_ObjectEntry10_Frame01:: ; 72:79F6
	sprite_frame 2
	sprite_oam -1, 0, $00, 0
	sprite_oam -1, 8, $01, 0
SpriteScript_BrowserShared_ObjectEntry10:: ; 72:79FF
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $7A04-$7A1F (27 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_7A04:: ; 72:7A04
	sprite_frame_table SpriteFrame_BrowserShared_ObjectEntry11_Frame00, SpriteFrame_BrowserShared_ObjectEntry11_Frame01
SpriteFrame_BrowserShared_ObjectEntry11_Frame00:: ; 72:7A08
	sprite_frame 2
	sprite_oam 0, 0, $00, OAMF_YFLIP
	sprite_oam 0, 8, $01, OAMF_YFLIP
SpriteFrame_BrowserShared_ObjectEntry11_Frame01:: ; 72:7A11
	sprite_frame 2
	sprite_oam 1, 0, $00, OAMF_YFLIP
	sprite_oam 1, 8, $01, OAMF_YFLIP
SpriteScript_BrowserShared_ObjectEntry11:: ; 72:7A1A
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
