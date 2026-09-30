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
	dw Data_27_7AF0
	dw $7B2B
	dw Data_27_7AF0
	dw $7B2B
	dw Data_27_7AF0
	dw $7B2B
	dw Data_27_7AF0
	dw $7B2B
	dw $7B2E
	dw $7B69
	dw $7B2E
	dw $7B69
	dw $7B2E
	dw $7B69
	dw $7B2E
	dw $7B69
	dw $7B6C
	dw $7B92
	dw $7B6C
	dw $7B92
	dw $7B6C
	dw $7B92
	dw $7B6C
	dw $7B92
	dw $7B97
	dw $7BA2
	dw $7B97
	dw $7BA2
	dw $7B97
	dw $7BA2
	dw $7B97
	dw $7BA2
	dw Data_27_7BA5
	dw $7BB0
	dw Data_27_7BA5
	dw $7BB0
	dw Data_27_7BA5
	dw $7BB0
	dw Data_27_7BA5
	dw $7BB0
	dw $7BB3
	dw $7BBE
	dw $7BB3
	dw $7BBE
	dw $7BB3
	dw $7BBE
	dw $7BB3
	dw $7BBE
	dw Data_27_7BC1
	dw $7BCC
	dw Data_27_7BC1
	dw $7BCC
	dw Data_27_7BC1
	dw $7BCC
	dw Data_27_7BC1
	dw $7BCC
	dw Data_27_7BCF
	dw $7BDA
	dw Data_27_7BCF
	dw $7BDA
	dw Data_27_7BCF
	dw $7BDA
	dw Data_27_7BCF
	dw $7BDA
	dw $7BDD
	dw $7BF0
	dw $7BDD
	dw $7BF0
	dw $7BDD
	dw $7BF0
	dw $7BDD
	dw $7BF0
	dw $7BF3
	dw $7BFE
	dw $7BF3
	dw $7BFE
	dw $7BF3
	dw $7BFE
	dw $7BF3
	dw $7BFE
	dw $7C01
	dw $7C0C
	dw $7C01
	dw $7C0C
	dw $7C01
	dw $7C0C
	dw $7C01
	dw $7C0C
	dw Data_27_7C0F
	dw $7C5B
	dw Data_27_7C0F
	dw $7C5B
	dw Data_27_7C0F
	dw $7C5B
	dw Data_27_7C0F
	dw $7C5B
	dw $7C64
	dw $7CB0
	dw $7C64
	dw $7CB0
	dw $7C64
	dw $7CB0
	dw $7C64
	dw $7CB0
	dw Data_27_7CB9
	dw $7CDF
	dw Data_27_7CB9
	dw $7CDF
	dw Data_27_7CB9
	dw $7CDF
	dw Data_27_7CB9
	dw $7CDF

; ---- data $7AF0-$7BA5 (181 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_27_7AF0:: ; 27:7AF0
	db $F2, $7A, $0E, $00, $00, $00, $0B, $F0, $00, $00, $0B, $10, $00, $00, $0B, $20
	db $00, $00, $0B, $40, $00, $00, $0B, $30, $00, $00, $0B, $F0, $10, $02, $2B, $F0
	db $08, $04, $2B, $40, $10, $02, $6B, $40, $08, $04, $6B, $00, $08, $06, $2B, $30
	db $08, $06, $6B, $10, $08, $06, $2B, $20, $08, $06, $2B, $01, $00, $04, $30, $7B
	db $0E, $F0, $10, $00, $2B, $00, $10, $00, $2B, $10, $10, $00, $2B, $20, $10, $00
	db $2B, $40, $10, $00, $2B, $30, $10, $00, $2B, $F0, $00, $02, $0B, $F0, $08, $04
	db $0B, $40, $00, $02, $4B, $40, $08, $04, $4B, $10, $08, $06, $0B, $30, $08, $06
	db $4B, $00, $08, $06, $0B, $20, $08, $06, $4B, $01, $00, $04, $70, $7B, $81, $7B
	db $04, $03, $00, $00, $00, $03, $08, $02, $00, $13, $00, $20, $00, $13, $08, $22
	db $00, $04, $03, $00, $04, $00, $03, $08, $06, $00, $13, $00, $24, $00, $13, $08
	db $26, $00, $02, $00, $08, $01, $08, $99, $7B, $02, $0B, $00, $58, $02, $0B, $08
	db $5A, $02, $01, $00, $08

; ---- data $7BA5-$7BC1 (28 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7BA5) and lies between CONFIRMED-read frame data

Data_27_7BA5:: ; 27:7BA5
	db $A7, $7B, $02, $0B, $00, $78, $02, $0B, $08, $7A, $02, $01, $00, $08, $B5, $7B
	db $02, $0B, $08, $78, $22, $0B, $00, $7A, $22, $01, $00, $08

; ---- data $7BC1-$7BCF (14 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_27_7BC1:: ; 27:7BC1
	db $C3, $7B, $02, $F8, $00, $3C, $01, $F8, $08, $3E, $01, $01, $00, $04

; ---- data $7BCF-$7C0F (64 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7BCF)

Data_27_7BCF:: ; 27:7BCF
	db $D1, $7B, $02, $00, $00, $70, $06, $00, $08, $72, $06, $01, $00, $04, $DF, $7B
	db $04, $00, $00, $50, $06, $00, $08, $52, $06, $00, $10, $54, $06, $00, $18, $56
	db $06, $01, $00, $04, $F5, $7B, $02, $0B, $00, $5C, $03, $0B, $08, $5E, $03, $01
	db $00, $08, $03, $7C, $02, $0B, $08, $5C, $23, $0B, $00, $5E, $23, $01, $00, $08

; ---- data $7C0F-$7CB9 (170 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_27_7C0F:: ; 27:7C0F
	db $17, $7C, $28, $7C, $39, $7C, $4A, $7C, $04, $03, $00, $10, $00, $03, $08, $12
	db $00, $13, $00, $30, $00, $13, $08, $22, $00, $04, $03, $00, $60, $08, $03, $08
	db $62, $08, $13, $00, $68, $08, $13, $08, $6A, $08, $04, $03, $00, $10, $00, $03
	db $08, $12, $00, $13, $00, $30, $00, $13, $08, $22, $00, $04, $03, $00, $64, $08
	db $03, $08, $66, $08, $13, $00, $6C, $08, $13, $08, $6E, $08, $04, $00, $08, $01
	db $08, $02, $08, $03, $08, $6C, $7C, $7D, $7C, $8E, $7C, $9F, $7C, $04, $03, $08
	db $10, $20, $03, $00, $12, $20, $13, $08, $30, $20, $13, $00, $22, $20, $04, $03
	db $08, $60, $28, $03, $00, $62, $28, $13, $08, $68, $28, $13, $00, $6A, $28, $04
	db $03, $08, $10, $20, $03, $00, $12, $20, $13, $08, $30, $20, $13, $00, $22, $20
	db $04, $03, $08, $64, $28, $03, $00, $66, $28, $13, $08, $6C, $28, $13, $00, $6E
	db $28, $04, $00, $08, $01, $08, $02, $08, $03, $08

; ---- data $7CB9-$7CE4 (43 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; span starts at a table target (7CB9); ends at the zero padding of the bank

Data_27_7CB9:: ; 27:7CB9
	db $BD, $7C, $CE, $7C, $04, $03, $08, $08, $29, $03, $00, $0A, $29, $13, $08, $22
	db $01, $13, $00, $30, $01, $04, $03, $08, $0C, $29, $03, $00, $0E, $29, $13, $08
	db $2C, $29, $13, $00, $2E, $29, $02, $00, $08, $01, $08
