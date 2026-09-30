; gfx/mail_server/tidy_screen.asm
; bank 2E, $56E0-$7961 (8833 bytes); pinned by layout.link
; tidy-up screen tiles, tilemaps, palettes, object tables

SECTION "gfx/mail_server/tidy_screen", ROMX

; ---- gfx $56E0-$5AE0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4B81 2E:4CAC); first: hdma_rom_to_vram at 2E:4B81: hl=$56E0 a=$2E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_MailServerMgr_Tiles0:: ; 2E:56E0
Data_2E_56E0::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles0.2bpp"

; ---- gfx $5AE0-$5AF0 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2E:40A8: hl=$5AE0 a=$2E c=$01 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_MailServerMgr_Tiles1:: ; 2E:5AE0
Data_2E_5AE0::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles1.2bpp"

; ---- gfx $5AF0-$5EE0 (1008 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4B93 2E:4CBE); first: hdma_rom_to_vram at 2E:4B93: hl=$5AE0 a=$2E c=$40 de=$9401 (dest VRAM $9400, vbank=1) [clipped from 5AE0-5EE0 by higher-priority evidence]

Data_2E_5AF0:: ; 2E:5AF0
	INCBIN "gfx/mail_server/tidy_screen/tiles_5af0.2bpp"

; ---- gfx $5EE0-$6000 (288 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4BA5 2E:4CD0); first: hdma_rom_to_vram at 2E:4BA5: hl=$5EE0 a=$2E c=$12 de=$8801 (dest VRAM $8800, vbank=1)

Gfx_MailServerMgr_Tiles2:: ; 2E:5EE0
Data_2E_5EE0::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles2.2bpp"

; ---- gfx $6000-$6400 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4BC9 2E:4CF4); first: hdma_rom_to_vram at 2E:4BC9: hl=$6000 a=$2E c=$40 de=$8A80 (dest VRAM $8A80, vbank=0)

Gfx_MailServerMgr_Tiles3:: ; 2E:6000
Data_2E_6000::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles3.2bpp"

; ---- gfx $6400-$6560 (352 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4BDB 2E:4D06); first: hdma_rom_to_vram at 2E:4BDB: hl=$6400 a=$2E c=$16 de=$8E80 (dest VRAM $8E80, vbank=0)

Gfx_MailServerMgr_Tiles4:: ; 2E:6400
Data_2E_6400::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles4.2bpp"

; ---- gfx $6560-$6960 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (2E:4BB7 2E:4CE2); first: hdma_rom_to_vram at 2E:4BB7: hl=$6560 a=$2E c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MailServerMgr_Tiles5:: ; 2E:6560
Data_2E_6560::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_tiles5.2bpp"

; ---- data $6960-$6C30 (720 bytes) [CONFIRMED] tilemap+attr: 5 call site(s) (2E:4217 2E:4819 2E:4BEC 2E:4D17); first: copy_tilemap_rect_pair at 2E:4217: hl=$6960 a=$2E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MailServerMgr_Main:: ; 2E:6960
Data_2E_6960::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_main.tilemap"
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_main.attrmap"

; ---- data $6C30-$6D20 (240 bytes) [PROBABLE] tilemap+attr: 4 call site(s) (2E:4697 2E:4753 2E:4C02 2E:4D2D); first: copy_tilemap_rect_pair at 2E:4697: hl=$6C30 a=$2E b=6 rows c=20 cols (tiles then attrs) de=$D0A0 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailServerMgr_Footer:: ; 2E:6C30
Data_2E_6C30::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_footer.tilemap"
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_footer.attrmap"

; ---- data $6D20-$6FF0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2E:4E29: hl=$6D20 a=$2E b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailServerMgr_InfoB:: ; 2E:6D20
Data_2E_6D20::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_b.tilemap"
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_b.attrmap"

; ---- data $6FF0-$72C0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2E:4E64: hl=$6FF0 a=$2E b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailServerMgr_InfoC:: ; 2E:6FF0
Data_2E_6FF0::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_c.tilemap"
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_c.attrmap"

; ---- data $72C0-$7590 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2E:4E9B: hl=$72C0 a=$2E b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailServerMgr_InfoD:: ; 2E:72C0
Data_2E_72C0::
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_d.tilemap"
	INCBIN "gfx/mail_server/tidy_screen/mail_server_mgr_info_d.attrmap"

; ---- data $7590-$75C0 (48 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 7590-7610 by higher-priority evidence]

Palette_MailServerMgr_Bg:: ; 2E:7590
Data_2E_7590::
	INCLUDE "gfx/mail_server/tidy_screen/mail_server_mgr_bg.pal"

; ---- data $75C0-$76C0 (256 bytes) [PROBABLE] palette-rgb555: heuristic (RGB555 words with bit15 clear); region shortened to end at 76C0 where the object tables start (the old region ran on to 7720 over the tables 76C0-7710)

Data_2E_75C0:: ; 2E:75C0
	INCLUDE "gfx/mail_server/tidy_screen/palette_75c0.pal"

Palette_MailServerMgr_Obj:: ; 2E:75D0
	INCLUDE "gfx/mail_server/tidy_screen/mail_server_mgr_obj.pal"

; ---- words $76C0-$7710 (80 bytes) [PROBABLE] 5 object tables of 4 entries x 2 words (76C0,76D0,76E0,76F0,7700) read by init_object_from_table (00:0A82, de=$76C0..$7700, a=$2E: callers 2E:4442,452F,4554,4579,4661,46AE,404C,476A); all 40 words (10 distinct: 77FA..7957) land inside the animation block 2E:7710-7961

Table_MailServerMgr_ObjAnims:: ; 2E:76C0
Table_2E_76C0::
	dw $77FA, $7838, $77FA, $7838, $77FA, $7838, $77FA, $7838
	dw $783D, $787B, $783D, $787B, $783D, $787B, $783D, $787B
	dw $7880, $78BE, $7880, $78BE, $7880, $78BE, $7880, $78BE
	dw $78C3, $7919, $78C3, $7919, $78C3, $7919, $78C3, $7919
	dw MailServerMgr_ObjAnimData_2E_7921, $7957, MailServerMgr_ObjAnimData_2E_7921, $7957, MailServerMgr_ObjAnimData_2E_7921, $7957, MailServerMgr_ObjAnimData_2E_7921, $7957

; ---- data $7710-$7720 (16 bytes) [PROBABLE] animation descriptors / sprite lists (same format as bank 72:786C-7A1F: count + count*(y,x,tile,attr) and descriptors 01 00 04 dw / 02 .. dw dw) reached from the object tables 2E:76C0

Data_2E_7710:: ; 2E:7710
	db $12, $77, $02, $00, $00, $0A, $00, $08, $00, $1A, $00, $01, $00, $04, $20, $77

; ---- data $7720-$7921 (513 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

MailServerMgr_ObjAnimData_2E_7720:: ; 2E:7720
Data_2E_7720::
	db $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $0B, $00, $08, $00, $1B
	db $00, $01, $00, $04, $36, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00
	db $00, $0C, $00, $08, $00, $1C, $00, $01, $00, $04, $4C, $77, $04, $E0, $D0, $0A
	db $00, $E8, $D0, $1A, $00, $00, $00, $0D, $00, $08, $00, $1D, $00, $01, $00, $04
	db $62, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $0E, $00, $08
	db $00, $1E, $00, $01, $00, $04, $78, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A
	db $00, $00, $00, $0F, $00, $08, $00, $1F, $00, $01, $00, $04, $8E, $77, $04, $E0
	db $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $10, $00, $08, $00, $14, $00, $01
	db $00, $04, $A4, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $11
	db $00, $08, $00, $15, $00, $01, $00, $04, $BA, $77, $04, $E0, $D0, $0A, $00, $E8
	db $D0, $1A, $00, $00, $00, $12, $00, $08, $00, $16, $00, $01, $00, $04, $D0, $77
	db $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $13, $00, $08, $00, $17
	db $00, $01, $00, $04, $E6, $77, $04, $FE, $FE, $0A, $00, $FE, $0A, $0A, $20, $0A
	db $FE, $0A, $40, $0A, $0A, $0A, $60, $01, $00, $04, $FE, $77, $1B, $78, $07, $F5
	db $FC, $10, $00, $F5, $04, $11, $00, $F5, $0C, $12, $00, $FE, $FE, $0A, $00, $FE
	db $0A, $0A, $20, $0A, $FE, $0A, $40, $0A, $0A, $0A, $60, $07, $F5, $FC, $10, $00
	db $F5, $04, $11, $00, $F5, $0C, $12, $00, $FD, $FD, $0A, $00, $FD, $0B, $0A, $20
	db $0B, $FD, $0A, $40, $0B, $0B, $0A, $60, $02, $00, $2E, $01, $08, $41, $78, $5E
	db $78, $07, $F5, $FC, $13, $00, $F5, $04, $14, $00, $F5, $0C, $15, $00, $FE, $FE
	db $0A, $00, $FE, $0A, $0A, $20, $0A, $FE, $0A, $40, $0A, $0A, $0A, $60, $07, $F5
	db $FC, $13, $00, $F5, $04, $14, $00, $F5, $0C, $15, $00, $FD, $FD, $0A, $00, $FD
	db $0B, $0A, $20, $0B, $FD, $0A, $40, $0B, $0B, $0A, $60, $02, $00, $40, $01, $08
	db $84, $78, $A1, $78, $07, $F5, $FC, $16, $00, $F5, $04, $17, $00, $F5, $0C, $18
	db $00, $FE, $FE, $0A, $00, $FE, $0A, $0A, $20, $0A, $FE, $0A, $40, $0A, $0A, $0A
	db $60, $07, $F5, $FC, $16, $00, $F5, $04, $17, $00, $F5, $0C, $18, $00, $FD, $FD
	db $0A, $00, $FD, $0B, $0A, $20, $0B, $FD, $0A, $40, $0B, $0B, $0A, $60, $02, $00
	db $2E, $01, $08, $C7, $78, $F0, $78, $0A, $37, $14, $19, $01, $37, $1C, $1A, $01
	db $3F, $14, $1B, $01, $3F, $1C, $1C, $01, $47, $14, $1D, $01, $47, $1C, $1E, $01
	db $2B, $14, $0C, $02, $2B, $1C, $0D, $02, $33, $14, $0E, $02, $33, $1C, $0F, $02
	db $0A, $37, $14, $19, $01, $37, $1C, $1A, $01, $3F, $14, $1B, $01, $3F, $1C, $1C
	db $01, $47, $14, $1D, $01, $47, $1C, $1E, $01, $2A, $10, $1F, $02, $32, $10, $0B
	db $02, $2A, $20, $1F, $22, $32, $20, $0B, $22, $02, $00, $14, $01, $1D, $01, $00
	db $04

; ---- data $7921-$7923 (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

MailServerMgr_ObjAnimData_2E_7921:: ; 2E:7921
Data_2E_7921::
	db $25, $79

; ---- data $7923-$7925 (2 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

Data_2E_7923:: ; 2E:7923
	db $3E, $79

; ---- data $7925-$793E (25 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_2E_7925:: ; 2E:7925
	db $06, $36, $14, $20, $01, $36, $1C, $21, $01, $3E, $14, $22, $01, $3E, $1C, $23
	db $01, $46, $14, $24, $01, $46, $1C, $25, $01

; ---- data $793E-$7958 (26 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

MailServerMgr_ObjAnimData_2E_793E:: ; 2E:793E
Data_2E_793E::
	db $06, $36, $14, $26, $01, $36, $1C, $27, $01, $3E, $14, $28, $01, $3E, $1C, $29
	db $01, $46, $14, $2A, $01, $46, $1C, $2B, $01, $02

; ---- data $7958-$795A (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_2E_7958:: ; 2E:7958
	db $00, $1C

; ---- data $795A-$7961 (7 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

Data_2E_795A:: ; 2E:795A
	db $01, $19, $02, $00, $0A, $01, $0A
