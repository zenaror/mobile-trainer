; gfx/address_book/list.asm
; bank 2F, $4D40-$5098 (856 bytes); pinned by layout.link
; list tilemap and cursor animation table

SECTION "gfx/address_book/list", ROMX

; ---- data $4D40-$5010 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:45EA: hl=$4D40 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Abook_List:: ; 2F:4D40
Data_2F_4D40::
	INCBIN "gfx/address_book/list/abook_list.tilemap"
	INCBIN "gfx/address_book/list/abook_list.attrmap"

; ---- ptrtable $5010-$5050 (64 bytes) [PROBABLE] 32 words, all inside $5050-$5098 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; callers 2F:4507 ld de,$5010, 2F:4522 $5020, 2F:453D $5030, 2F:4558 $5040 (a=$2F b=$81)

Table_Abook_ButtonCursorAnims:: ; 2F:5010
Table_2F_5010::
	dw Abook_ButtonCursor_ObjAnimData
	dw $505F
	dw Abook_ButtonCursor_ObjAnimData
	dw $505F
	dw Abook_ButtonCursor_ObjAnimData
	dw $505F
	dw Abook_ButtonCursor_ObjAnimData
	dw $505F
	dw $5062
	dw $5071
	dw $5062
	dw $5071
	dw $5062
	dw $5071
	dw $5062
	dw $5071
	dw $5074
	dw $5083
	dw $5074
	dw $5083
	dw $5074
	dw $5083
	dw $5074
	dw $5083
	dw $5086
	dw $5095
	dw $5086
	dw $5095
	dw $5086
	dw $5095
	dw $5086
	dw $5095

; ---- data $5050-$5098 (72 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; frames of the 5010 tables (records at 5050/5062/5074/5086: dw list, count 3 x (y,x,tile,attr), 01 00 40)

Abook_ButtonCursor_ObjAnimData:: ; 2F:5050
Data_2F_5050::
	db $52, $50, $03, $F5, $FC, $44, $03, $F5, $04, $45, $03, $F5, $0C, $46, $03, $01
	db $00, $40, $64, $50, $03, $F5, $FC, $47, $03, $F5, $04, $48, $03, $F5, $0C, $49
	db $03, $01, $00, $40, $76, $50, $03, $F5, $FC, $4A, $03, $F5, $04, $4B, $03, $F5
	db $0C, $4C, $03, $01, $00, $40, $88, $50, $03, $F5, $FC, $4D, $03, $F5, $04, $4E
	db $03, $F5, $0C, $4F, $03, $01, $00, $40
