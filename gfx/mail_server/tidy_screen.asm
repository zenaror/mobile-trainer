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
	sprite_object_entry SpriteFrameTable_2E_77FA, SpriteScript_2E_7838 ; entry 0
	sprite_object_entry SpriteFrameTable_2E_77FA, SpriteScript_2E_7838 ; entry 1
	sprite_object_entry SpriteFrameTable_2E_77FA, SpriteScript_2E_7838 ; entry 2
	sprite_object_entry SpriteFrameTable_2E_77FA, SpriteScript_2E_7838 ; entry 3
	sprite_object_entry SpriteFrameTable_2E_783D, SpriteScript_2E_787B ; entry 4
	sprite_object_entry SpriteFrameTable_2E_783D, SpriteScript_2E_787B ; entry 5
	sprite_object_entry SpriteFrameTable_2E_783D, SpriteScript_2E_787B ; entry 6
	sprite_object_entry SpriteFrameTable_2E_783D, SpriteScript_2E_787B ; entry 7
	sprite_object_entry SpriteFrameTable_2E_7880, SpriteScript_2E_78BE ; entry 8
	sprite_object_entry SpriteFrameTable_2E_7880, SpriteScript_2E_78BE ; entry 9
	sprite_object_entry SpriteFrameTable_2E_7880, SpriteScript_2E_78BE ; entry 10
	sprite_object_entry SpriteFrameTable_2E_7880, SpriteScript_2E_78BE ; entry 11
	sprite_object_entry SpriteFrameTable_2E_78C3, SpriteScript_2E_7919 ; entry 12
	sprite_object_entry SpriteFrameTable_2E_78C3, SpriteScript_2E_7919 ; entry 13
	sprite_object_entry SpriteFrameTable_2E_78C3, SpriteScript_2E_7919 ; entry 14
	sprite_object_entry SpriteFrameTable_2E_78C3, SpriteScript_2E_7919 ; entry 15
	sprite_object_entry MailServerMgr_ObjAnimData_2E_7921, SpriteScript_2E_7957 ; entry 16
	sprite_object_entry MailServerMgr_ObjAnimData_2E_7921, SpriteScript_2E_7957 ; entry 17
	sprite_object_entry MailServerMgr_ObjAnimData_2E_7921, SpriteScript_2E_7957 ; entry 18
	sprite_object_entry MailServerMgr_ObjAnimData_2E_7921, SpriteScript_2E_7957 ; entry 19

; ---- data $7710-$7720 (16 bytes) [PROBABLE] animation descriptors / sprite lists (same format as bank 72:786C-7A1F: count + count*(y,x,tile,attr) and descriptors 01 00 04 dw / 02 .. dw dw) reached from the object tables 2E:76C0

Data_2E_7710:: ; 2E:7710
	db $12, $77, $02, $00, $00, $0A, $00, $08, $00, $1A, $00, $01, $00, $04, $20, $77

; ---- data $7720-$7921 (513 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

MailServerMgr_ObjAnimData_2E_7720:: ; 2E:7720
Data_2E_7720::
	db $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $0B, $00, $08, $00, $1B ; not reached by any walked sprite chain
	db $00, $01, $00, $04, $36, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00 ; not reached by any walked sprite chain
	db $00, $0C, $00, $08, $00, $1C, $00, $01, $00, $04, $4C, $77, $04, $E0, $D0, $0A ; not reached by any walked sprite chain
	db $00, $E8, $D0, $1A, $00, $00, $00, $0D, $00, $08, $00, $1D, $00, $01, $00, $04 ; not reached by any walked sprite chain
	db $62, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $0E, $00, $08 ; not reached by any walked sprite chain
	db $00, $1E, $00, $01, $00, $04, $78, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A ; not reached by any walked sprite chain
	db $00, $00, $00, $0F, $00, $08, $00, $1F, $00, $01, $00, $04, $8E, $77, $04, $E0 ; not reached by any walked sprite chain
	db $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $10, $00, $08, $00, $14, $00, $01 ; not reached by any walked sprite chain
	db $00, $04, $A4, $77, $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $11 ; not reached by any walked sprite chain
	db $00, $08, $00, $15, $00, $01, $00, $04, $BA, $77, $04, $E0, $D0, $0A, $00, $E8 ; not reached by any walked sprite chain
	db $D0, $1A, $00, $00, $00, $12, $00, $08, $00, $16, $00, $01, $00, $04, $D0, $77 ; not reached by any walked sprite chain
	db $04, $E0, $D0, $0A, $00, $E8, $D0, $1A, $00, $00, $00, $13, $00, $08, $00, $17 ; not reached by any walked sprite chain
	db $00, $01, $00, $04, $E6, $77, $04, $FE, $FE, $0A, $00, $FE, $0A, $0A, $20, $0A ; not reached by any walked sprite chain
	db $FE, $0A, $40, $0A, $0A, $0A, $60, $01, $00, $04 ; not reached by any walked sprite chain
SpriteFrameTable_2E_77FA:: ; 2E:77FA
	sprite_frame_table SpriteFrame_2E_77FE, SpriteFrame_2E_781B
SpriteFrame_2E_77FE:: ; 2E:77FE
	sprite_frame 7
	sprite_oam -11, -4, $10, 0
	sprite_oam -11, 4, $11, 0
	sprite_oam -11, 12, $12, 0
	sprite_oam -2, -2, $0A, 0
	sprite_oam -2, 10, $0A, OAMF_XFLIP
	sprite_oam 10, -2, $0A, OAMF_YFLIP
	sprite_oam 10, 10, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_2E_781B:: ; 2E:781B
	sprite_frame 7
	sprite_oam -11, -4, $10, 0
	sprite_oam -11, 4, $11, 0
	sprite_oam -11, 12, $12, 0
	sprite_oam -3, -3, $0A, 0
	sprite_oam -3, 11, $0A, OAMF_XFLIP
	sprite_oam 11, -3, $0A, OAMF_YFLIP
	sprite_oam 11, 11, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_2E_7838:: ; 2E:7838
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_2E_783D:: ; 2E:783D
	sprite_frame_table SpriteFrame_2E_7841, SpriteFrame_2E_785E
SpriteFrame_2E_7841:: ; 2E:7841
	sprite_frame 7
	sprite_oam -11, -4, $13, 0
	sprite_oam -11, 4, $14, 0
	sprite_oam -11, 12, $15, 0
	sprite_oam -2, -2, $0A, 0
	sprite_oam -2, 10, $0A, OAMF_XFLIP
	sprite_oam 10, -2, $0A, OAMF_YFLIP
	sprite_oam 10, 10, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_2E_785E:: ; 2E:785E
	sprite_frame 7
	sprite_oam -11, -4, $13, 0
	sprite_oam -11, 4, $14, 0
	sprite_oam -11, 12, $15, 0
	sprite_oam -3, -3, $0A, 0
	sprite_oam -3, 11, $0A, OAMF_XFLIP
	sprite_oam 11, -3, $0A, OAMF_YFLIP
	sprite_oam 11, 11, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_2E_787B:: ; 2E:787B
	sprite_anim 2
	sprite_anim_step 0, 64
	sprite_anim_step 1, 8
SpriteFrameTable_2E_7880:: ; 2E:7880
	sprite_frame_table SpriteFrame_2E_7884, SpriteFrame_2E_78A1
SpriteFrame_2E_7884:: ; 2E:7884
	sprite_frame 7
	sprite_oam -11, -4, $16, 0
	sprite_oam -11, 4, $17, 0
	sprite_oam -11, 12, $18, 0
	sprite_oam -2, -2, $0A, 0
	sprite_oam -2, 10, $0A, OAMF_XFLIP
	sprite_oam 10, -2, $0A, OAMF_YFLIP
	sprite_oam 10, 10, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteFrame_2E_78A1:: ; 2E:78A1
	sprite_frame 7
	sprite_oam -11, -4, $16, 0
	sprite_oam -11, 4, $17, 0
	sprite_oam -11, 12, $18, 0
	sprite_oam -3, -3, $0A, 0
	sprite_oam -3, 11, $0A, OAMF_XFLIP
	sprite_oam 11, -3, $0A, OAMF_YFLIP
	sprite_oam 11, 11, $0A, OAMF_YFLIP | OAMF_XFLIP
SpriteScript_2E_78BE:: ; 2E:78BE
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
SpriteFrameTable_2E_78C3:: ; 2E:78C3
	sprite_frame_table SpriteFrame_2E_78C7, SpriteFrame_2E_78F0
SpriteFrame_2E_78C7:: ; 2E:78C7
	sprite_frame 10
	sprite_oam 55, 20, $19, 1
	sprite_oam 55, 28, $1A, 1
	sprite_oam 63, 20, $1B, 1
	sprite_oam 63, 28, $1C, 1
	sprite_oam 71, 20, $1D, 1
	sprite_oam 71, 28, $1E, 1
	sprite_oam 43, 20, $0C, 2
	sprite_oam 43, 28, $0D, 2
	sprite_oam 51, 20, $0E, 2
	sprite_oam 51, 28, $0F, 2
SpriteFrame_2E_78F0:: ; 2E:78F0
	sprite_frame 10
	sprite_oam 55, 20, $19, 1
	sprite_oam 55, 28, $1A, 1
	sprite_oam 63, 20, $1B, 1
	sprite_oam 63, 28, $1C, 1
	sprite_oam 71, 20, $1D, 1
	sprite_oam 71, 28, $1E, 1
	sprite_oam 42, 16, $1F, 2
	sprite_oam 50, 16, $0B, 2
	sprite_oam 42, 32, $1F, OAMF_XFLIP | 2
	sprite_oam 50, 32, $0B, OAMF_XFLIP | 2
SpriteScript_2E_7919:: ; 2E:7919
	sprite_anim 2
	sprite_anim_step 0, 20
	sprite_anim_step 1, 29
	db $01, $00, $04 ; not reached by any walked sprite chain

; ---- data $7921-$7923 (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

MailServerMgr_ObjAnimData_2E_7921:: ; 2E:7921
Data_2E_7921::
	db $25, $79 ; sprite frame table kept as db: the item crosses the end of its block

; ---- data $7923-$7925 (2 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

Data_2E_7923:: ; 2E:7923
	db $3E, $79

; ---- data $7925-$793E (25 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_2E_7925:: ; 2E:7925
	sprite_frame 6
	sprite_oam 54, 20, $20, 1
	sprite_oam 54, 28, $21, 1
	sprite_oam 62, 20, $22, 1
	sprite_oam 62, 28, $23, 1
	sprite_oam 70, 20, $24, 1
	sprite_oam 70, 28, $25, 1

; ---- data $793E-$7958 (26 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

MailServerMgr_ObjAnimData_2E_793E:: ; 2E:793E
Data_2E_793E::
	sprite_frame 6
	sprite_oam 54, 20, $26, 1
	sprite_oam 54, 28, $27, 1
	sprite_oam 62, 20, $28, 1
	sprite_oam 62, 28, $29, 1
	sprite_oam 70, 20, $2A, 1
	sprite_oam 70, 28, $2B, 1
SpriteScript_2E_7957:: ; 2E:7957
	db $02 ; sprite script kept as db: the item crosses the end of its block

; ---- data $7958-$795A (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_2E_7958:: ; 2E:7958
	db $00, $1C

; ---- data $795A-$7961 (7 bytes) [PROBABLE] animation descriptors / sprite lists reached from the object tables 2E:76C0-7710 (same format as bank 72:786C-7A1F); the table words (77FA..7957) point into this block

Data_2E_795A:: ; 2E:795A
	db $01, $19, $02, $00, $0A, $01, $0A
