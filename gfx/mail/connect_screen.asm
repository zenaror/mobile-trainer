; gfx/mail/connect_screen.asm
; bank 27, $5060-$7CE4 (11396 bytes); pinned by layout.link
; connect/disconnect screen tiles, panorama tilemap, palettes, window message strips, object table

SECTION "gfx/mail/connect_screen", ROMX

; ---- gfx $5060-$5460 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4BDB: hl=$5060 a=$27 c=$40 de=$8001 (dest VRAM $8000, vbank=1)

MailConnect_Tiles_5060:: ; 27:5060
Data_27_5060::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_5060.2bpp"

; ---- gfx $5460-$5860 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4BED: hl=$5460 a=$27 c=$40 de=$8401 (dest VRAM $8400, vbank=1)

MailConnect_Tiles_5460:: ; 27:5460
Data_27_5460::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_5460.2bpp"

; ---- gfx $5860-$5C60 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C35: hl=$5860 a=$27 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

MailConnect_Tiles_5860:: ; 27:5860
Data_27_5860::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_5860.2bpp"

; ---- gfx $5C60-$5E60 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C47: hl=$5C60 a=$27 c=$20 de=$9401 (dest VRAM $9400, vbank=1)

MailConnect_Tiles_5C60:: ; 27:5C60
Data_27_5C60::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_5c60.2bpp"

; ---- gfx $5E60-$6260 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4BFF: hl=$5E60 a=$27 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

MailConnect_Tiles_5E60:: ; 27:5E60
Data_27_5E60::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_5e60.2bpp"

; ---- gfx $6260-$6660 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C11: hl=$6260 a=$27 c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

MailConnect_Tiles_6260:: ; 27:6260
Data_27_6260::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_6260.2bpp"

; ---- gfx $6660-$6860 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C23: hl=$6660 a=$27 c=$20 de=$9000 (dest VRAM $9000, vbank=0)

MailConnect_Tiles_6660:: ; 27:6660
Data_27_6660::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_6660.2bpp"

; ---- gfx $6860-$6C60 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C59: hl=$6860 a=$27 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

MailConnect_Tiles_6860:: ; 27:6860
Data_27_6860::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_6860.2bpp"

; ---- gfx $6C60-$7060 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4C6B: hl=$6C60 a=$27 c=$40 de=$8400 (dest VRAM $8400, vbank=0)

MailConnect_Tiles_6C60:: ; 27:6C60
Data_27_6C60::
	INCBIN "gfx/mail/connect_screen/mail_connect_tiles_6c60.2bpp"

; ---- data $7060-$74E0 (1152 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4C7C: hl=$7060 a=$27 b=18 rows c=32 cols (tiles then attrs) de=$D000

MailConnect_Tilemap:: ; 27:7060
Data_27_7060::
	INCBIN "gfx/mail/connect_screen/mail_connect_tilemap.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_connect_tilemap.attrmap"

; ---- data $74E0-$7518 (56 bytes) [PROBABLE] palette-rgb555: heuristic: 28 RGB555 words as 7 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

MailConnect_BgPalette:: ; 27:74E0
Data_27_74E0::
	INCLUDE "gfx/mail/connect_screen/mail_connect_bg_palette.pal"

; ---- data $7518-$7560 (72 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [clipped from 5060-7A10 by higher-priority evidence]

Data_27_7518:: ; 27:7518
	db $00, $00, $00, $00, $00, $00, $00, $00

MailScreens_ObjPalette_7520:: ; 27:7520
	INCLUDE "gfx/mail/connect_screen/mail_screens_obj_palette_7520.pal"

; ---- data $7560-$7628 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:44EF: hl=$7560 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailConnect_WinMsg_Cancelling:: ; 27:7560
Data_27_7560::
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_cancelling.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_cancelling.attrmap"

; ---- data $7628-$76F0 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4633: hl=$7628 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailConnect_WinMsg_Cancelled:: ; 27:7628
Data_27_7628::
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_cancelled.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_cancelled.attrmap"

; ---- data $76F0-$77B8 (200 bytes) [CONFIRMED] tilemap+attr: 3 call site(s) (27:47A7 27:49F7 27:4CBA); first: copy_tilemap_rect_pair at 27:47A7: hl=$76F0 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailDisconnect_WinMsg_Ending:: ; 27:76F0
Data_27_76F0::
	INCBIN "gfx/mail/connect_screen/mail_disconnect_win_msg_ending.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_disconnect_win_msg_ending.attrmap"

; ---- data $77B8-$7880 (200 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (27:4950 27:4B35); first: copy_tilemap_rect_pair at 27:4950: hl=$77B8 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailDisconnect_WinMsg_Ended:: ; 27:77B8
Data_27_77B8::
	INCBIN "gfx/mail/connect_screen/mail_disconnect_win_msg_ended.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_disconnect_win_msg_ended.attrmap"

; ---- data $7880-$7948 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4CA7: hl=$7880 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailConnect_WinMsg_Connecting:: ; 27:7880
Data_27_7880::
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_connecting.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_connecting.attrmap"

; ---- data $7948-$7A10 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4423: hl=$7948 a=$27 b=5 rows c=20 cols (tiles then attrs) de=$D000

MailConnect_WinMsg_Connected:: ; 27:7948
Data_27_7948::
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_connected.tilemap"
	INCBIN "gfx/mail/connect_screen/mail_connect_win_msg_connected.attrmap"

; ---- ptrtable $7A10-$7AF0 (224 bytes) [PROBABLE] 112 words, all inside $7AF0-$7CE4 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; callers e.g. 26:4064 ld de,$7A30, 27:4247, 27:4CCB ld de,$7A10 (a=$27 b=$81)

MailConnect_ObjTable:: ; 27:7A10
Table_27_7A10::
	sprite_object_entry MailConnect_ObjAnimData_27_7AF0, SpriteScript_27_7B2B ; entry 0
	sprite_object_entry MailConnect_ObjAnimData_27_7AF0, SpriteScript_27_7B2B ; entry 1
	sprite_object_entry MailConnect_ObjAnimData_27_7AF0, SpriteScript_27_7B2B ; entry 2
	sprite_object_entry MailConnect_ObjAnimData_27_7AF0, SpriteScript_27_7B2B ; entry 3
	sprite_object_entry SpriteFrameTable_27_7B2E, SpriteScript_27_7B69 ; entry 4
	sprite_object_entry SpriteFrameTable_27_7B2E, SpriteScript_27_7B69 ; entry 5
	sprite_object_entry SpriteFrameTable_27_7B2E, SpriteScript_27_7B69 ; entry 6
	sprite_object_entry SpriteFrameTable_27_7B2E, SpriteScript_27_7B69 ; entry 7
	sprite_object_entry SpriteFrameTable_27_7B6C, SpriteScript_27_7B92 ; entry 8
	sprite_object_entry SpriteFrameTable_27_7B6C, SpriteScript_27_7B92 ; entry 9
	sprite_object_entry SpriteFrameTable_27_7B6C, SpriteScript_27_7B92 ; entry 10
	sprite_object_entry SpriteFrameTable_27_7B6C, SpriteScript_27_7B92 ; entry 11
	sprite_object_entry SpriteFrameTable_27_7B97, SpriteScript_27_7BA2 ; entry 12
	sprite_object_entry SpriteFrameTable_27_7B97, SpriteScript_27_7BA2 ; entry 13
	sprite_object_entry SpriteFrameTable_27_7B97, SpriteScript_27_7BA2 ; entry 14
	sprite_object_entry SpriteFrameTable_27_7B97, SpriteScript_27_7BA2 ; entry 15
	sprite_object_entry MailConnect_ObjAnimData_27_7BA5, SpriteScript_27_7BB0 ; entry 16
	sprite_object_entry MailConnect_ObjAnimData_27_7BA5, SpriteScript_27_7BB0 ; entry 17
	sprite_object_entry MailConnect_ObjAnimData_27_7BA5, SpriteScript_27_7BB0 ; entry 18
	sprite_object_entry MailConnect_ObjAnimData_27_7BA5, SpriteScript_27_7BB0 ; entry 19
	sprite_object_entry SpriteFrameTable_27_7BB3, SpriteScript_27_7BBE ; entry 20
	sprite_object_entry SpriteFrameTable_27_7BB3, SpriteScript_27_7BBE ; entry 21
	sprite_object_entry SpriteFrameTable_27_7BB3, SpriteScript_27_7BBE ; entry 22
	sprite_object_entry SpriteFrameTable_27_7BB3, SpriteScript_27_7BBE ; entry 23
	sprite_object_entry MailConnect_ObjAnimData_27_7BC1, SpriteScript_27_7BCC ; entry 24
	sprite_object_entry MailConnect_ObjAnimData_27_7BC1, SpriteScript_27_7BCC ; entry 25
	sprite_object_entry MailConnect_ObjAnimData_27_7BC1, SpriteScript_27_7BCC ; entry 26
	sprite_object_entry MailConnect_ObjAnimData_27_7BC1, SpriteScript_27_7BCC ; entry 27
	sprite_object_entry MailConnect_ObjAnimData_27_7BCF, SpriteScript_27_7BDA ; entry 28
	sprite_object_entry MailConnect_ObjAnimData_27_7BCF, SpriteScript_27_7BDA ; entry 29
	sprite_object_entry MailConnect_ObjAnimData_27_7BCF, SpriteScript_27_7BDA ; entry 30
	sprite_object_entry MailConnect_ObjAnimData_27_7BCF, SpriteScript_27_7BDA ; entry 31
	sprite_object_entry SpriteFrameTable_27_7BDD, SpriteScript_27_7BF0 ; entry 32
	sprite_object_entry SpriteFrameTable_27_7BDD, SpriteScript_27_7BF0 ; entry 33
	sprite_object_entry SpriteFrameTable_27_7BDD, SpriteScript_27_7BF0 ; entry 34
	sprite_object_entry SpriteFrameTable_27_7BDD, SpriteScript_27_7BF0 ; entry 35
	sprite_object_entry SpriteFrameTable_27_7BF3, SpriteScript_27_7BFE ; entry 36
	sprite_object_entry SpriteFrameTable_27_7BF3, SpriteScript_27_7BFE ; entry 37
	sprite_object_entry SpriteFrameTable_27_7BF3, SpriteScript_27_7BFE ; entry 38
	sprite_object_entry SpriteFrameTable_27_7BF3, SpriteScript_27_7BFE ; entry 39
	sprite_object_entry SpriteFrameTable_27_7C01, SpriteScript_27_7C0C ; entry 40
	sprite_object_entry SpriteFrameTable_27_7C01, SpriteScript_27_7C0C ; entry 41
	sprite_object_entry SpriteFrameTable_27_7C01, SpriteScript_27_7C0C ; entry 42
	sprite_object_entry SpriteFrameTable_27_7C01, SpriteScript_27_7C0C ; entry 43
	sprite_object_entry MailConnect_ObjAnimData_27_7C0F, SpriteScript_27_7C5B ; entry 44
	sprite_object_entry MailConnect_ObjAnimData_27_7C0F, SpriteScript_27_7C5B ; entry 45
	sprite_object_entry MailConnect_ObjAnimData_27_7C0F, SpriteScript_27_7C5B ; entry 46
	sprite_object_entry MailConnect_ObjAnimData_27_7C0F, SpriteScript_27_7C5B ; entry 47
	sprite_object_entry SpriteFrameTable_27_7C64, SpriteScript_27_7CB0 ; entry 48
	sprite_object_entry SpriteFrameTable_27_7C64, SpriteScript_27_7CB0 ; entry 49
	sprite_object_entry SpriteFrameTable_27_7C64, SpriteScript_27_7CB0 ; entry 50
	sprite_object_entry SpriteFrameTable_27_7C64, SpriteScript_27_7CB0 ; entry 51
	sprite_object_entry MailConnect_ObjAnimData_27_7CB9, SpriteScript_27_7CDF ; entry 52
	sprite_object_entry MailConnect_ObjAnimData_27_7CB9, SpriteScript_27_7CDF ; entry 53
	sprite_object_entry MailConnect_ObjAnimData_27_7CB9, SpriteScript_27_7CDF ; entry 54
	sprite_object_entry MailConnect_ObjAnimData_27_7CB9, SpriteScript_27_7CDF ; entry 55

; ---- data $7AF0-$7BA5 (181 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

MailConnect_ObjAnimData_27_7AF0:: ; 27:7AF0
Data_27_7AF0::
	sprite_frame_table SpriteFrame_27_7AF2
SpriteFrame_27_7AF2:: ; 27:7AF2
	sprite_frame 14
	sprite_oam 0, 0, $00, OAMF_BANK1 | 3
	sprite_oam -16, 0, $00, OAMF_BANK1 | 3
	sprite_oam 16, 0, $00, OAMF_BANK1 | 3
	sprite_oam 32, 0, $00, OAMF_BANK1 | 3
	sprite_oam 64, 0, $00, OAMF_BANK1 | 3
	sprite_oam 48, 0, $00, OAMF_BANK1 | 3
	sprite_oam -16, 16, $02, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam -16, 8, $04, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 64, 16, $02, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 64, 8, $04, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 0, 8, $06, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 48, 8, $06, OAMF_YFLIP | OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 16, 8, $06, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 32, 8, $06, OAMF_XFLIP | OAMF_BANK1 | 3
SpriteScript_27_7B2B:: ; 27:7B2B
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_27_7B2E:: ; 27:7B2E
	sprite_frame_table SpriteFrame_27_7B30
SpriteFrame_27_7B30:: ; 27:7B30
	sprite_frame 14
	sprite_oam -16, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 0, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 16, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 32, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 64, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam 48, 16, $00, OAMF_XFLIP | OAMF_BANK1 | 3
	sprite_oam -16, 0, $02, OAMF_BANK1 | 3
	sprite_oam -16, 8, $04, OAMF_BANK1 | 3
	sprite_oam 64, 0, $02, OAMF_YFLIP | OAMF_BANK1 | 3
	sprite_oam 64, 8, $04, OAMF_YFLIP | OAMF_BANK1 | 3
	sprite_oam 16, 8, $06, OAMF_BANK1 | 3
	sprite_oam 48, 8, $06, OAMF_YFLIP | OAMF_BANK1 | 3
	sprite_oam 0, 8, $06, OAMF_BANK1 | 3
	sprite_oam 32, 8, $06, OAMF_YFLIP | OAMF_BANK1 | 3
SpriteScript_27_7B69:: ; 27:7B69
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_27_7B6C:: ; 27:7B6C
	sprite_frame_table SpriteFrame_27_7B70, SpriteFrame_27_7B81
SpriteFrame_27_7B70:: ; 27:7B70
	sprite_frame 4
	sprite_oam 3, 0, $00, 0
	sprite_oam 3, 8, $02, 0
	sprite_oam 19, 0, $20, 0
	sprite_oam 19, 8, $22, 0
SpriteFrame_27_7B81:: ; 27:7B81
	sprite_frame 4
	sprite_oam 3, 0, $04, 0
	sprite_oam 3, 8, $06, 0
	sprite_oam 19, 0, $24, 0
	sprite_oam 19, 8, $26, 0
SpriteScript_27_7B92:: ; 27:7B92
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
SpriteFrameTable_27_7B97:: ; 27:7B97
	sprite_frame_table SpriteFrame_27_7B99
SpriteFrame_27_7B99:: ; 27:7B99
	sprite_frame 2
	sprite_oam 11, 0, $58, 2
	sprite_oam 11, 8, $5A, 2
SpriteScript_27_7BA2:: ; 27:7BA2
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- data $7BA5-$7BC1 (28 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7BA5) and lies between CONFIRMED-read frame data

MailConnect_ObjAnimData_27_7BA5:: ; 27:7BA5
Data_27_7BA5::
	sprite_frame_table SpriteFrame_27_7BA7
SpriteFrame_27_7BA7:: ; 27:7BA7
	sprite_frame 2
	sprite_oam 11, 0, $78, 2
	sprite_oam 11, 8, $7A, 2
SpriteScript_27_7BB0:: ; 27:7BB0
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_27_7BB3:: ; 27:7BB3
	sprite_frame_table SpriteFrame_27_7BB5
SpriteFrame_27_7BB5:: ; 27:7BB5
	sprite_frame 2
	sprite_oam 11, 8, $78, OAMF_XFLIP | 2
	sprite_oam 11, 0, $7A, OAMF_XFLIP | 2
SpriteScript_27_7BBE:: ; 27:7BBE
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- data $7BC1-$7BCF (14 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

MailConnect_ObjAnimData_27_7BC1:: ; 27:7BC1
Data_27_7BC1::
	sprite_frame_table SpriteFrame_27_7BC3
SpriteFrame_27_7BC3:: ; 27:7BC3
	sprite_frame 2
	sprite_oam -8, 0, $3C, 1
	sprite_oam -8, 8, $3E, 1
SpriteScript_27_7BCC:: ; 27:7BCC
	sprite_anim 1
	sprite_anim_step 0, 4

; ---- data $7BCF-$7C0F (64 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7BCF)

MailConnect_ObjAnimData_27_7BCF:: ; 27:7BCF
Data_27_7BCF::
	sprite_frame_table SpriteFrame_27_7BD1
SpriteFrame_27_7BD1:: ; 27:7BD1
	sprite_frame 2
	sprite_oam 0, 0, $70, 6
	sprite_oam 0, 8, $72, 6
SpriteScript_27_7BDA:: ; 27:7BDA
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_27_7BDD:: ; 27:7BDD
	sprite_frame_table SpriteFrame_27_7BDF
SpriteFrame_27_7BDF:: ; 27:7BDF
	sprite_frame 4
	sprite_oam 0, 0, $50, 6
	sprite_oam 0, 8, $52, 6
	sprite_oam 0, 16, $54, 6
	sprite_oam 0, 24, $56, 6
SpriteScript_27_7BF0:: ; 27:7BF0
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_27_7BF3:: ; 27:7BF3
	sprite_frame_table SpriteFrame_27_7BF5
SpriteFrame_27_7BF5:: ; 27:7BF5
	sprite_frame 2
	sprite_oam 11, 0, $5C, 3
	sprite_oam 11, 8, $5E, 3
SpriteScript_27_7BFE:: ; 27:7BFE
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_27_7C01:: ; 27:7C01
	sprite_frame_table SpriteFrame_27_7C03
SpriteFrame_27_7C03:: ; 27:7C03
	sprite_frame 2
	sprite_oam 11, 8, $5C, OAMF_XFLIP | 3
	sprite_oam 11, 0, $5E, OAMF_XFLIP | 3
SpriteScript_27_7C0C:: ; 27:7C0C
	sprite_anim 1
	sprite_anim_step 0, 8

; ---- data $7C0F-$7CB9 (170 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

MailConnect_ObjAnimData_27_7C0F:: ; 27:7C0F
Data_27_7C0F::
	sprite_frame_table SpriteFrame_27_7C17, SpriteFrame_27_7C28, SpriteFrame_27_7C39, SpriteFrame_27_7C4A
SpriteFrame_27_7C17:: ; 27:7C17
	sprite_frame 4
	sprite_oam 3, 0, $10, 0
	sprite_oam 3, 8, $12, 0
	sprite_oam 19, 0, $30, 0
	sprite_oam 19, 8, $22, 0
SpriteFrame_27_7C28:: ; 27:7C28
	sprite_frame 4
	sprite_oam 3, 0, $60, OAMF_BANK1
	sprite_oam 3, 8, $62, OAMF_BANK1
	sprite_oam 19, 0, $68, OAMF_BANK1
	sprite_oam 19, 8, $6A, OAMF_BANK1
SpriteFrame_27_7C39:: ; 27:7C39
	sprite_frame 4
	sprite_oam 3, 0, $10, 0
	sprite_oam 3, 8, $12, 0
	sprite_oam 19, 0, $30, 0
	sprite_oam 19, 8, $22, 0
SpriteFrame_27_7C4A:: ; 27:7C4A
	sprite_frame 4
	sprite_oam 3, 0, $64, OAMF_BANK1
	sprite_oam 3, 8, $66, OAMF_BANK1
	sprite_oam 19, 0, $6C, OAMF_BANK1
	sprite_oam 19, 8, $6E, OAMF_BANK1
SpriteScript_27_7C5B:: ; 27:7C5B
	sprite_anim 4
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8
SpriteFrameTable_27_7C64:: ; 27:7C64
	sprite_frame_table SpriteFrame_27_7C6C, SpriteFrame_27_7C7D, SpriteFrame_27_7C8E, SpriteFrame_27_7C9F
SpriteFrame_27_7C6C:: ; 27:7C6C
	sprite_frame 4
	sprite_oam 3, 8, $10, OAMF_XFLIP
	sprite_oam 3, 0, $12, OAMF_XFLIP
	sprite_oam 19, 8, $30, OAMF_XFLIP
	sprite_oam 19, 0, $22, OAMF_XFLIP
SpriteFrame_27_7C7D:: ; 27:7C7D
	sprite_frame 4
	sprite_oam 3, 8, $60, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 3, 0, $62, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 19, 8, $68, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 19, 0, $6A, OAMF_XFLIP | OAMF_BANK1
SpriteFrame_27_7C8E:: ; 27:7C8E
	sprite_frame 4
	sprite_oam 3, 8, $10, OAMF_XFLIP
	sprite_oam 3, 0, $12, OAMF_XFLIP
	sprite_oam 19, 8, $30, OAMF_XFLIP
	sprite_oam 19, 0, $22, OAMF_XFLIP
SpriteFrame_27_7C9F:: ; 27:7C9F
	sprite_frame 4
	sprite_oam 3, 8, $64, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 3, 0, $66, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 19, 8, $6C, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 19, 0, $6E, OAMF_XFLIP | OAMF_BANK1
SpriteScript_27_7CB0:: ; 27:7CB0
	sprite_anim 4
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 8
	sprite_anim_step 3, 8

; ---- data $7CB9-$7CE4 (43 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7CB9); ends at the zero padding of the bank

MailConnect_ObjAnimData_27_7CB9:: ; 27:7CB9
Data_27_7CB9::
	sprite_frame_table SpriteFrame_27_7CBD, SpriteFrame_27_7CCE
SpriteFrame_27_7CBD:: ; 27:7CBD
	sprite_frame 4
	sprite_oam 3, 8, $08, OAMF_XFLIP | OAMF_BANK1 | 1
	sprite_oam 3, 0, $0A, OAMF_XFLIP | OAMF_BANK1 | 1
	sprite_oam 19, 8, $22, 1
	sprite_oam 19, 0, $30, 1
SpriteFrame_27_7CCE:: ; 27:7CCE
	sprite_frame 4
	sprite_oam 3, 8, $0C, OAMF_XFLIP | OAMF_BANK1 | 1
	sprite_oam 3, 0, $0E, OAMF_XFLIP | OAMF_BANK1 | 1
	sprite_oam 19, 8, $2C, OAMF_XFLIP | OAMF_BANK1 | 1
	sprite_oam 19, 0, $2E, OAMF_XFLIP | OAMF_BANK1 | 1
SpriteScript_27_7CDF:: ; 27:7CDF
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
