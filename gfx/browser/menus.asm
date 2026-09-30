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

BrowserMenu_CursorObjTable:: ; 72:7828
Table_72_7828::
	dw BrowserMenu_Cursor_ObjAnimData_72_78CA, $78F0, BrowserMenu_Cursor_ObjAnimData_72_78CA, $78F0, $7976, $799D, BrowserMenu_Cursor_ObjAnimData_72_79A0, $79BF
	dw $79C3, $79E6, $7940, $7956, BrowserMenu_Cursor_ObjAnimData_72_795B, $7971, BrowserMenu_Cursor_ObjAnimData_72_78F5, $793B
	dw BrowserMenu_Cursor_ObjAnimData_72_7894, $78AA, $78AF, $78C5, $79E9, $79FF, BrowserMenu_Cursor_ObjAnimData_72_7A04, $7A1A
	dw BrowserMenu_Cursor_Anim12Frames, $7873, BrowserMenu_Cursor_Anim12Frames, $7873, $7876, $787D, BrowserMenu_Cursor_ObjAnimData_72_7880, $7887
	dw $788A, $7891

; ---- data $786C-$786E (2 bytes) [PROBABLE] descriptor $786C = dw $786E (first word of the animation/sprite data block; target of table entry words)

BrowserMenu_Cursor_Anim12Frames:: ; 72:786C
Data_72_786C::
	db $6E, $78

; ---- data $786E-$7880 (18 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserMenu_Cursor_ObjAnimData_72_786E:: ; 72:786E
Data_72_786E::
	db $01, $00, $00, $FF, $07, $01, $00, $04, $78, $78, $01, $00, $00, $FF, $07, $01
	db $00, $04

; ---- data $7880-$7894 (20 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_7880:: ; 72:7880
Data_72_7880::
	db $82, $78, $01, $00, $00, $FF, $07, $01, $00, $04, $8C, $78, $01, $00, $00, $FF
	db $07, $01, $00, $04

; ---- data $7894-$78CA (54 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserMenu_Cursor_ObjAnimData_72_7894:: ; 72:7894
Data_72_7894::
	db $98, $78, $A1, $78, $02, $00, $00, $0B, $07, $00, $08, $0C, $07, $02, $FF, $00
	db $0B, $07, $FF, $08, $0C, $07, $02, $00, $2E, $01, $08, $B3, $78, $BC, $78, $02
	db $00, $00, $0B, $47, $00, $08, $0C, $47, $02, $01, $00, $0B, $47, $01, $08, $0C
	db $47, $02, $00, $2E, $01, $08

; ---- data $78CA-$78F5 (43 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_78CA:: ; 72:78CA
Data_72_78CA::
	db $CE, $78, $DF, $78, $04, $FE, $FE, $81, $0C, $FE, $0A, $81, $2C, $0A, $FE, $81
	db $4C, $0A, $0A, $81, $6C, $04, $FD, $FD, $81, $0C, $FD, $0B, $81, $2C, $0B, $FD
	db $81, $4C, $0B, $0B, $81, $6C, $02, $00, $2E, $01, $08

; ---- data $78F5-$795B (102 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserMenu_Cursor_ObjAnimData_72_78F5:: ; 72:78F5
Data_72_78F5::
	db $F9, $78, $1A, $79, $08, $ED, $F8, $F8, $0C, $ED, $00, $F9, $0C, $ED, $08, $FA
	db $0C, $ED, $10, $FB, $0C, $F5, $F8, $FC, $0C, $F5, $00, $FD, $0C, $F5, $08, $FE
	db $0C, $F5, $10, $FF, $0C, $08, $EC, $F8, $F8, $0C, $EC, $00, $F9, $0C, $EC, $08
	db $FA, $0C, $EC, $10, $FB, $0C, $F4, $F8, $FC, $0C, $F4, $00, $FD, $0C, $F4, $08
	db $FE, $0C, $F4, $10, $FF, $0C, $02, $00, $2E, $01, $08, $44, $79, $4D, $79, $02
	db $00, $00, $0B, $07, $00, $08, $0C, $07, $02, $FF, $00, $0B, $07, $FF, $08, $0C
	db $07, $02, $00, $2E, $01, $08

; ---- data $795B-$79A0 (69 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_795B:: ; 72:795B
Data_72_795B::
	db $5F, $79, $68, $79, $02, $00, $00, $0B, $47, $00, $08, $0C, $47, $02, $01, $00
	db $0B, $47, $01, $08, $0C, $47, $02, $00, $2E, $01, $08, $78, $79, $09, $ED, $F8
	db $82, $0C, $ED, $00, $83, $0C, $ED, $08, $84, $0C, $ED, $10, $85, $0C, $F5, $F8
	db $92, $0C, $F5, $00, $93, $0C, $F5, $08, $94, $0C, $F5, $10, $95, $0C, $F5, $18
	db $96, $0C, $01, $00, $04

; ---- data $79A0-$7A04 (100 bytes) [PROBABLE] animation-descriptor / sprite-list block reached from the object table 72:7828: sprite lists = count + count*(y,x,tile,attr) (e.g. 72:78CE 04 fe fe 81 0c ...) and descriptors (01 00 04 dw / 02 00 2e 01 08 dw dw); the table words partition 786C-7A1F exactly at descriptor starts; other bytes of this block are CONFIRMED read by executed code (1/18)

BrowserMenu_Cursor_ObjAnimData_72_79A0:: ; 72:79A0
Data_72_79A0::
	db $A2, $79, $07, $ED, $F9, $87, $0C, $ED, $01, $88, $0C, $ED, $09, $89, $0C, $F5
	db $F9, $97, $0C, $F5, $01, $98, $0C, $F5, $09, $99, $0C, $F5, $11, $86, $0C, $01
	db $00, $04, $00, $C5, $79, $08, $ED, $F8, $8A, $0C, $ED, $00, $8B, $0C, $ED, $08
	db $8C, $0C, $ED, $10, $8D, $0C, $F5, $F8, $9A, $0C, $F5, $00, $9B, $0C, $F5, $08
	db $9C, $0C, $F5, $10, $9D, $0C, $01, $00, $04, $ED, $79, $F6, $79, $02, $00, $00
	db $00, $00, $00, $08, $01, $00, $02, $FF, $00, $00, $00, $FF, $08, $01, $00, $02
	db $00, $2E, $01, $08

; ---- data $7A04-$7A1F (27 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserMenu_Cursor_ObjAnimData_72_7A04:: ; 72:7A04
Data_72_7A04::
	db $08, $7A, $11, $7A, $02, $00, $00, $00, $40, $00, $08, $01, $40, $02, $01, $00
	db $00, $40, $01, $08, $01, $40, $02, $00, $2E, $01, $08
