; gfx/browser/menus.asm
; bank 72, $6C10-$7A1F (3599 bytes); pinned by layout.link
; browser menu tiles, maps, palette, cursor object table

SECTION "gfx/browser/menus", ROMX

; ---- gfx $6C10-$7010 (1024 bytes) [CONFIRMED] tiles-vram: 3 call site(s) (4E:61C1 4E:62BC 72:6733); first: hdma_rom_to_vram at 4E:61C1: hl=$6C10 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

BrowserMenu3_Tiles0:: ; 72:6C10
Data_72_6C10::
	INCBIN "gfx/browser/menus/browser_menu3_tiles0.2bpp"

; ---- gfx $7010-$7110 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:6745: hl=$7010 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1)

BrowserMenu3_Tiles1:: ; 72:7010
Data_72_7010::
	INCBIN "gfx/browser/menus/browser_menu3_tiles1.2bpp"

; ---- data $7110-$7200 (240 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:6767: hl=$7110 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180

BrowserMenu3_Map:: ; 72:7110
Data_72_7110::
	INCBIN "gfx/browser/menus/browser_menu3_map.tilemap"
	INCBIN "gfx/browser/menus/browser_menu3_map.attrmap"

; ---- data $7200-$7206 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6C10-7218 by higher-priority evidence]

Palette_BrowserMenu_Bg6:: ; 72:7200
Data_72_7200::
	db $00, $00, $6D, $7A, $20, $69

; ---- data $7206-$7216 (16 bytes) [PROBABLE] palette-rgb555: heuristic: 8 RGB555 words as 2 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_72_7206:: ; 72:7206
	INCLUDE "gfx/browser/menus/palette_7206.pal"

; ---- data $7216-$7218 (2 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 6C10-7218 by higher-priority evidence]

Data_72_7216:: ; 72:7216
	db $00, $00

; ---- zero $7218-$7220 (8 bytes) [PROBABLE] 8 x 00 padding between the palette/data at 72:7206-7218 and the tile block 72:7220
	ds $8, $00

; ---- gfx $7220-$7620 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:640B: hl=$7220 a=$72 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Tiles0:: ; 72:7220
Data_72_7220::
	INCBIN "gfx/browser/menus/browser_menu2_tiles0.2bpp"

; ---- gfx $7620-$7720 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 72:63F9: hl=$7620 a=$72 c=$10 de=$8F01 (dest VRAM $8F00, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Tiles1:: ; 72:7620
Data_72_7620::
	INCBIN "gfx/browser/menus/browser_menu2_tiles1.2bpp"

; ---- data $7720-$7810 (240 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 72:642D: hl=$7720 a=$72 b=6 rows c=20 cols (tiles then attrs) de=$D180 [verifier: call site never executed in a trace -> PROBABLE]

BrowserMenu2_Map:: ; 72:7720
Data_72_7720::
	INCBIN "gfx/browser/menus/browser_menu2_map.tilemap"
	INCBIN "gfx/browser/menus/browser_menu2_map.attrmap"

; ---- data $7810-$7828 (24 bytes) [PROBABLE] 3 RGB555 palettes of 4 colours (bit15 clear, black/white ends); 7810 is loaded by ld hl,$7810 (bc=$0010 -> de=$D830, far call 4F:4000) at 72:6417; the third group (7820) follows the same format

BrowserMenu2_Palette:: ; 72:7810
Palette_72_7810::
	INCLUDE "gfx/browser/menus/browser_menu2_palette.pal"

; ---- words $7828-$786C (68 bytes) [PROBABLE] object table for init_object_from_table (00:0A82, de=$7828 a=$72, 4-byte entries = 2 words; callers 4E:5F08.., 72:45D2, 72:46D4, 72:64C6, 72:66BE, 72:6802, 72:6A12); 17 entries, every word lands exactly on a descriptor start of the data block 72:786C-7A1F (partition check)

BrowserShared_ObjTable:: ; 72:7828
Table_72_7828::
	sprite_object_entry BrowserMenu_Cursor_ObjAnimData_72_78CA, SpriteScript_72_78F0 ; entry 0
	sprite_object_entry BrowserMenu_Cursor_ObjAnimData_72_78CA, SpriteScript_72_78F0 ; entry 1
	sprite_object_entry SpriteFrameTable_72_7976, SpriteScript_72_799D ; entry 2
	sprite_object_entry BrowserShared_ObjAnimData_72_79A0, SpriteScript_72_79BF ; entry 3
	sprite_object_entry SpriteFrameTable_72_79C3, SpriteScript_72_79E6 ; entry 4
	sprite_object_entry SpriteFrameTable_72_7940, SpriteScript_72_7956 ; entry 5
	sprite_object_entry BrowserShared_ObjAnimData_72_795B, SpriteScript_72_7971 ; entry 6
	sprite_object_entry BrowserShared_ObjAnimData_72_78F5, SpriteScript_72_793B ; entry 7
	sprite_object_entry BrowserShared_ObjAnimData_72_7894, SpriteScript_72_78AA ; entry 8
	sprite_object_entry SpriteFrameTable_72_78AF, SpriteScript_72_78C5 ; entry 9
	sprite_object_entry SpriteFrameTable_72_79E9, SpriteScript_72_79FF ; entry 10
	sprite_object_entry BrowserShared_ObjAnimData_72_7A04, SpriteScript_72_7A1A ; entry 11
	sprite_object_entry BrowserShared_Anim12Frames, SpriteScript_72_7873 ; entry 12
	sprite_object_entry BrowserShared_Anim12Frames, SpriteScript_72_7873 ; entry 13
	sprite_object_entry SpriteFrameTable_72_7876, SpriteScript_72_787D ; entry 14
	sprite_object_entry BrowserShared_ObjAnimData_72_7880, SpriteScript_72_7887 ; entry 15
	sprite_object_entry SpriteFrameTable_72_788A, SpriteScript_72_7891 ; entry 16

; ---- data $786C-$786E (2 bytes) [PROBABLE] descriptor $786C = dw $786E (first word of the animation/sprite data block; target of table entry words)

BrowserShared_Anim12Frames:: ; 72:786C
Data_72_786C::
	sprite_frame_table BrowserShared_ObjAnimData_72_786E

; ---- data $786E-$7880 (18 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_786E:: ; 72:786E
Data_72_786E::
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_72_7873:: ; 72:7873
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_72_7876:: ; 72:7876
	sprite_frame_table SpriteFrame_72_7878
SpriteFrame_72_7878:: ; 72:7878
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_72_787D:: ; 72:787D
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $7880-$7894 (20 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_7880:: ; 72:7880
Data_72_7880::
	sprite_frame_table SpriteFrame_72_7882
SpriteFrame_72_7882:: ; 72:7882
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_72_7887:: ; 72:7887
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_72_788A:: ; 72:788A
	sprite_frame_table SpriteFrame_72_788C
SpriteFrame_72_788C:: ; 72:788C
	sprite_frame 1
	sprite_oam 0, 0, $FF, 7
SpriteScript_72_7891:: ; 72:7891
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $7894-$78CA (54 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_7894:: ; 72:7894
Data_72_7894::
	sprite_frame_table SpriteFrame_72_7898, SpriteFrame_72_78A1
SpriteFrame_72_7898:: ; 72:7898
	sprite_frame 2
	sprite_oam 0, 0, $0B, 7
	sprite_oam 0, 8, $0C, 7
SpriteFrame_72_78A1:: ; 72:78A1
	sprite_frame 2
	sprite_oam -1, 0, $0B, 7
	sprite_oam -1, 8, $0C, 7
SpriteScript_72_78AA:: ; 72:78AA
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_72_78AF:: ; 72:78AF
	sprite_frame_table SpriteFrame_72_78B3, SpriteFrame_72_78BC
SpriteFrame_72_78B3:: ; 72:78B3
	sprite_frame 2
	sprite_oam 0, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 0, 8, $0C, OAMF_YFLIP | 7
SpriteFrame_72_78BC:: ; 72:78BC
	sprite_frame 2
	sprite_oam 1, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 1, 8, $0C, OAMF_YFLIP | 7
SpriteScript_72_78C5:: ; 72:78C5
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $78CA-$78F5 (43 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_78CA:: ; 72:78CA
Data_72_78CA::
	sprite_frame_table SpriteFrame_72_78CE, SpriteFrame_72_78DF
SpriteFrame_72_78CE:: ; 72:78CE
	sprite_frame 4
	sprite_oam -2, -2, $81, OAMF_BANK1 | 4
	sprite_oam -2, 10, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 10, -2, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam 10, 10, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteFrame_72_78DF:: ; 72:78DF
	sprite_frame 4
	sprite_oam -3, -3, $81, OAMF_BANK1 | 4
	sprite_oam -3, 11, $81, OAMF_XFLIP | OAMF_BANK1 | 4
	sprite_oam 11, -3, $81, OAMF_YFLIP | OAMF_BANK1 | 4
	sprite_oam 11, 11, $81, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 4
SpriteScript_72_78F0:: ; 72:78F0
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $78F5-$795B (102 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_78F5:: ; 72:78F5
Data_72_78F5::
	sprite_frame_table SpriteFrame_72_78F9, SpriteFrame_72_791A
SpriteFrame_72_78F9:: ; 72:78F9
	sprite_frame 8
	sprite_oam -19, -8, $F8, OAMF_BANK1 | 4
	sprite_oam -19, 0, $F9, OAMF_BANK1 | 4
	sprite_oam -19, 8, $FA, OAMF_BANK1 | 4
	sprite_oam -19, 16, $FB, OAMF_BANK1 | 4
	sprite_oam -11, -8, $FC, OAMF_BANK1 | 4
	sprite_oam -11, 0, $FD, OAMF_BANK1 | 4
	sprite_oam -11, 8, $FE, OAMF_BANK1 | 4
	sprite_oam -11, 16, $FF, OAMF_BANK1 | 4
SpriteFrame_72_791A:: ; 72:791A
	sprite_frame 8
	sprite_oam -20, -8, $F8, OAMF_BANK1 | 4
	sprite_oam -20, 0, $F9, OAMF_BANK1 | 4
	sprite_oam -20, 8, $FA, OAMF_BANK1 | 4
	sprite_oam -20, 16, $FB, OAMF_BANK1 | 4
	sprite_oam -12, -8, $FC, OAMF_BANK1 | 4
	sprite_oam -12, 0, $FD, OAMF_BANK1 | 4
	sprite_oam -12, 8, $FE, OAMF_BANK1 | 4
	sprite_oam -12, 16, $FF, OAMF_BANK1 | 4
SpriteScript_72_793B:: ; 72:793B
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_72_7940:: ; 72:7940
	sprite_frame_table SpriteFrame_72_7944, SpriteFrame_72_794D
SpriteFrame_72_7944:: ; 72:7944
	sprite_frame 2
	sprite_oam 0, 0, $0B, 7
	sprite_oam 0, 8, $0C, 7
SpriteFrame_72_794D:: ; 72:794D
	sprite_frame 2
	sprite_oam -1, 0, $0B, 7
	sprite_oam -1, 8, $0C, 7
SpriteScript_72_7956:: ; 72:7956
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $795B-$79A0 (69 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_795B:: ; 72:795B
Data_72_795B::
	sprite_frame_table SpriteFrame_72_795F, SpriteFrame_72_7968
SpriteFrame_72_795F:: ; 72:795F
	sprite_frame 2
	sprite_oam 0, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 0, 8, $0C, OAMF_YFLIP | 7
SpriteFrame_72_7968:: ; 72:7968
	sprite_frame 2
	sprite_oam 1, 0, $0B, OAMF_YFLIP | 7
	sprite_oam 1, 8, $0C, OAMF_YFLIP | 7
SpriteScript_72_7971:: ; 72:7971
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_72_7976:: ; 72:7976
	sprite_frame_table SpriteFrame_72_7978
SpriteFrame_72_7978:: ; 72:7978
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
SpriteScript_72_799D:: ; 72:799D
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $79A0-$7A04 (100 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserShared_ObjAnimData_72_79A0:: ; 72:79A0
Data_72_79A0::
	sprite_frame_table SpriteFrame_72_79A2
SpriteFrame_72_79A2:: ; 72:79A2
	sprite_frame 7
	sprite_oam -19, -7, $87, OAMF_BANK1 | 4
	sprite_oam -19, 1, $88, OAMF_BANK1 | 4
	sprite_oam -19, 9, $89, OAMF_BANK1 | 4
	sprite_oam -11, -7, $97, OAMF_BANK1 | 4
	sprite_oam -11, 1, $98, OAMF_BANK1 | 4
	sprite_oam -11, 9, $99, OAMF_BANK1 | 4
	sprite_oam -11, 17, $86, OAMF_BANK1 | 4
SpriteScript_72_79BF:: ; 72:79BF
	sprite_anim 1
	sprite_anim_step 0, 4
	db $00
SpriteFrameTable_72_79C3:: ; 72:79C3
	sprite_frame_table SpriteFrame_72_79C5
SpriteFrame_72_79C5:: ; 72:79C5
	sprite_frame 8
	sprite_oam -19, -8, $8A, OAMF_BANK1 | 4
	sprite_oam -19, 0, $8B, OAMF_BANK1 | 4
	sprite_oam -19, 8, $8C, OAMF_BANK1 | 4
	sprite_oam -19, 16, $8D, OAMF_BANK1 | 4
	sprite_oam -11, -8, $9A, OAMF_BANK1 | 4
	sprite_oam -11, 0, $9B, OAMF_BANK1 | 4
	sprite_oam -11, 8, $9C, OAMF_BANK1 | 4
	sprite_oam -11, 16, $9D, OAMF_BANK1 | 4
SpriteScript_72_79E6:: ; 72:79E6
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_72_79E9:: ; 72:79E9
	sprite_frame_table SpriteFrame_72_79ED, SpriteFrame_72_79F6
SpriteFrame_72_79ED:: ; 72:79ED
	sprite_frame 2
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
SpriteFrame_72_79F6:: ; 72:79F6
	sprite_frame 2
	sprite_oam -1, 0, $00, 0
	sprite_oam -1, 8, $01, 0
SpriteScript_72_79FF:: ; 72:79FF
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- data $7A04-$7A1F (27 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserShared_ObjAnimData_72_7A04:: ; 72:7A04
Data_72_7A04::
	sprite_frame_table SpriteFrame_72_7A08, SpriteFrame_72_7A11
SpriteFrame_72_7A08:: ; 72:7A08
	sprite_frame 2
	sprite_oam 0, 0, $00, OAMF_YFLIP
	sprite_oam 0, 8, $01, OAMF_YFLIP
SpriteFrame_72_7A11:: ; 72:7A11
	sprite_frame 2
	sprite_oam 1, 0, $00, OAMF_YFLIP
	sprite_oam 1, 8, $01, OAMF_YFLIP
SpriteScript_72_7A1A:: ; 72:7A1A
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
