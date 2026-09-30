; engine/help/mobile_dictionary.asm
; bank 1A, $4000-$47B5 (1973 bytes); pinned by layout.link
; mobile dictionary index screen with category string tables

SECTION "engine/help/mobile_dictionary", ROMX

; ---- code $4000-$4163 (355 bytes) [CONFIRMED] 121 insn(s); 121 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MobileDict_Run:: ; 1A:4000
Function_1A_4000::
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	ld a, $01
	ld [wRam_C0D4], a
	ld [wRam_C0D6], a

MobileDict_Redraw:: ; 1A:4018
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Gfx_MobileDict_Tiles0
	ld a, $1A
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld de, $8B01
	ld hl, Gfx_MobileDict_Tiles1
	ld a, $1A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8F01
	ld hl, Gfx_MobileDict_Tiles2
	ld a, $1A
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MobileDict_Bg
	ld a, $1A
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MobileDict_Screen
	ld a, $1A
	farcall Function_00_08EA
	ld hl, $DA20
	ld de, Objects_MobileDict
	ld a, $1A
	ld b, $80
	farcall Function_00_0A82
	ld hl, $DA30
	ld de, Objects_MobileDict
	ld a, $1A
	ld b, $81
	farcall Function_00_0A82
	ld bc, $0040
	ld de, $D840
	ld hl, $53D0
	ld a, $1A
	farcall Palette_LoadToBuffer
	ld a, $00
	ld bc, $0A10
	ld de, $F000
	ld hl, $D0A1
	farcall Tilemap_FillRectSequential
	ldh a, [rLCDC]
	call Function_00_082C
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001A
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

MobileDict_Loop:: ; 1A:414B
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4163-$416D (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 1A:4160: 5 entries; fixed length (5 words) by the routine

Table_MobileDict_Buttons:: ; 1A:4163
Table_1A_4163::
	dw MobileDict_OnA
	dw MobileDict_OnB
	dw Label_1A_41E2
	dw Label_1A_41E2
	dw MobileDict_Idle

; ---- code $416D-$41F2 (133 bytes) [CONFIRMED] 65 insn(s); 65 executed (in up to 1/18 scenarios)

MobileDict_Idle:: ; 1A:416D
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, MobileDict_HandleDpad
	jp MobileDict_Loop

MobileDict_OnA:: ; 1A:4177
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C0D4]
	dec a
	add a, a
	ld hl, $40B9
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld d, $3F
	ld a, d
	call ReadByteFar
	ld c, a
	ld a, d
	call ReadByteFar
	ld h, a
	ld l, c
	ld a, [wRam_C0D6]
	dec a
	ld b, a
	ld a, [wRam_C0E5]
	add a, b
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $3F
	call ReadByteFar
	ld c, a
	ld b, $00
	ld a, $02
	farcall MobileDictView_Show
	jp MobileDict_Redraw

MobileDict_OnB:: ; 1A:41CA
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Label_1A_41E2:: ; 1A:41E2
	jp MobileDict_Loop

MobileDict_HandleDpad:: ; 1A:41E5
	bit 6, a
	jr nz, MobileDict_CursorUp
	bit 7, a
	jr nz, MobileDict_CursorDown
	bit 4, a
	jp nz, MobileDict_NextCategory

; ---- code $41F2-$41F7 (5 bytes) [CONFIRMED] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 0; fall-through of the jpcc at 1A:41EF (executed) | 2 insn(s) executed; cut out of the PROBABLE region 41F2-4238 by apply_coverage --split [executed in 5 scenarios]
	bit 5, a
	jp nz, MobileDict_PrevCategory

; ---- code $41F7-$41F8 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 41F2-4238 by apply_coverage --split
	ret

; ---- code $41F8-$4238 (64 bytes) [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 41F2-4238 by apply_coverage --split [executed in 1 scenarios]

MobileDict_CursorUp:: ; 1A:41F8
	ld a, [wRam_C0D6]
	dec a
	jr z, MobileDict_ScrollUp
	ld [wRam_C0D6], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call MobileDict_DrawRowHighlight
	ret

MobileDict_ScrollUp:: ; 1A:4215
	ld a, [wRam_C0E5]
	or a, a
	ret z
	dec a
	ld [wRam_C0E5], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ret

; ---- code $4238-$4263 (43 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 1/18 scenarios)

MobileDict_CursorDown:: ; 1A:4238
	ld a, [wRam_C0D8]
	ld b, a
	ld a, [wRam_C0D6]
	ld c, a
	ld a, [wRam_C0E5]
	add a, c
	cp a, b
	ret z
	ld a, c
	cp a, $05
	jr z, MobileDict_ScrollDown
	inc a
	ld [wRam_C0D6], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call MobileDict_DrawRowHighlight
	ret

; ---- code $4263-$4281 (30 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1; entered by jrcc from 1A:4249 (executed) [executed in 1 scenarios]

MobileDict_ScrollDown:: ; 1A:4263
	ld hl, $C0E5
	inc [hl]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ret

; ---- code $4281-$4288 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

MobileDict_NextCategory:: ; 1A:4281
	ld a, [wRam_C0D4]
	cp a, $0B
	jr nz, Label_1A_4289

; ---- code $4288-$4289 (1 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 1A:4286 (executed) [executed in 3 scenarios]
	xor a, a

; ---- code $4289-$42B0 (39 bytes) [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios)

Label_1A_4289:: ; 1A:4289
	inc a
	ld [wRam_C0D4], a
	ld a, $01
	ld [wRam_C0D6], a
	dec a
	ld [wRam_C0E5], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $42B0-$42DE (46 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 1; entered by jpcc from 1A:41F4 (PROBABLE code) [executed in 3 scenarios]

MobileDict_PrevCategory:: ; 1A:42B0
	ld a, [wRam_C0D4]
	dec a
	jr nz, Label_1A_42B8
	ld a, $0B

Label_1A_42B8:: ; 1A:42B8
	ld [wRam_C0D4], a
	ld a, $01
	ld [wRam_C0D6], a
	dec a
	ld [wRam_C0E5], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $42DE-$4346 (104 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MobileDict_DrawRowHighlight:: ; 1A:42DE
Function_1A_42DE::
	ld hl, $D4A1
	ld bc, $0A10
	ld de, $F800
	ld a, $07
	farcall Function_00_091C
	ld a, [wRam_C0D6]
	dec a
	swap a
	ld h, a
	and a, $F0
	ld l, a
	ld a, h
	and a, $0F
	ld h, a
	add hl, hl
	add hl, hl
	ld de, $D4A1
	add hl, de
	ld bc, $0210
	ld de, $F801
	ld a, $07
	farcall Function_00_091C
	ldh a, [rLCDC]
	call Function_00_082C
	ret

MobileDict_UpdateTabSprites:: ; 1A:4317
	ld a, [wRam_C0D4]
	dec a
	add a, a
	ld hl, Table_MobileDict_TabPositions
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld b, [hl]
	inc hl
	push hl
	ld de, $55A8
	ld hl, $DA40
	ld a, $1A
	farcall Function_00_0A82
	pop hl
	ld a, [hl]
	ld [wSpriteSlots + 65], a
	ld a, $15
	ld [wSpriteSlots + 64], a
	ld a, [wRam_C0E5]
	or a, a
	jr z, Label_1A_4351

; ---- code $4346-$4351 (11 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 1A:4344 (executed) [executed in 1 scenarios]
	ld de, $2048
	ld hl, $DA20
	call Function_00_0A65
	jr Label_1A_435A

; ---- code $4351-$437B (42 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)

Label_1A_4351:: ; 1A:4351
	ld de, $00A0
	ld hl, $DA20
	call Function_00_0A65

Label_1A_435A:: ; 1A:435A
	ld a, [wRam_C0D8]
	ld b, a
	ld a, [wRam_C0E5]
	add a, $05
	cp a, b
	jr nc, Label_1A_4371
	ld de, $7848
	ld hl, $DA30
	call Function_00_0A65
	jr Label_1A_437A

Label_1A_4371:: ; 1A:4371
	ld de, $00A0
	ld hl, $DA30
	call Function_00_0A65

Label_1A_437A:: ; 1A:437A
	ret

; ---- data $437B-$4391 (22 bytes) [PROBABLE] 11 pairs (index,value): 00 08 / 01 14 / 02 20 / 03 2C ... 0A 80 (value = 8 + 12*index), right after the ret of the preceding routine and before Function_1A_4391; first 4 bytes read in a trace; the 18-byte mapper hole is the rest of this table

Table_MobileDict_TabPositions:: ; 1A:437B
Data_1A_437B::
	db $00, $08, $01, $14, $02, $20, $03, $2C, $04, $38, $05, $44, $06, $50, $07, $5C
	db $08, $68, $09, $74, $0A, $80

; ---- code $4391-$4439 (168 bytes) [CONFIRMED] 83 insn(s); 83 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MobileDict_LoadPage:: ; 1A:4391
Function_1A_4391::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, $D000
	call FillBytes
	ld d, $00

Label_1A_43AA:: ; 1A:43AA
	ld a, [wRam_C0D4]
	ld hl, Table_MobileDict_Categories
	dec a
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld [wRam_C0D8], a
	ld a, [wRam_C0E5]
	add a, d
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push de
	ld a, d
	add a, a
	ldh [hRam_FFB1], a
	ld a, $05
	ldh [hRam_FFB2], a
	ld de, $D000
	ld a, $02
	ldh [hRam_FFB0], a
	ld bc, $0010
	ld a, $1A
	farcall TextTiles_RenderGridRows
	call Function_00_0392
	pop de
	inc d
	ld a, d
	cp a, $05
	jr z, Label_1A_43F9
	ld b, a
	ld a, [wRam_C0D8]
	cp a, b
	jr nz, Label_1A_43AA

Label_1A_43F9:: ; 1A:43F9
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, $D800
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- ptrtable $4439-$444F (22 bytes) [PROBABLE] 11 pointers to the string-group headers 444F 44C7 44E0 453F 456B 45A8 4608 46F9 4705 471E 4736; every target is a count byte followed by count word pointers whose first target equals the end of the header (all 11 validated); first 4 bytes read by executed code

Table_MobileDict_Categories:: ; 1A:4439
Table_1A_4439::
	dw Data_MobileDict_Cat01Count
	dw Data_MobileDict_Cat02Count
	dw Data_MobileDict_Cat03Count
	dw Data_MobileDict_Cat04Count
	dw Data_MobileDict_Cat05Count
	dw Data_MobileDict_Cat06Count
	dw Data_MobileDict_Cat07Count
	dw Data_MobileDict_Cat08Count
	dw Data_MobileDict_Cat09Count
	dw Data_MobileDict_Cat10Count
	dw Data_MobileDict_Cat11Count

; ---- data $444F-$4450 (1 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 444F-445A by higher-priority evidence]

Data_MobileDict_Cat01Count:: ; 1A:444F
Data_1A_444F::
	db $09

; ---- ptrtable $4450-$4462 (18 bytes) [PROBABLE] little-endian word table, 12 entries, monotone=0.82, 75% of targets on string start/after NUL, targets $4462..$4583; regular record stride between targets [clipped from 4450-4468 by higher-priority proposals]

Table_MobileDict_Cat01Strings:: ; 1A:4450
Table_1A_4450::
	dw String_1A_4462
	dw $446D
	dw $4476
	dw $447F
	dw $448E
	dw String_1A_449D
	dw String_1A_44A4
	dw $44B1
	dw $44BC

; ---- text $4462-$449D (59 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_4462:: ; 1A:4462
	db $83, $41, $83, $4A, $83, $45, $83, $93, $83, $67, $00 ; "アカウント"
	db $82, $A0, $82, $C4, $82, $B3, $82, $AB, $00 ; "あてさき"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $00 ; "アドレス"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $00 ; "アドレスちょう"
	db $83, $43, $83, $93, $83, $5E, $81, $5B, $83, $6C, $83, $62, $83, $67, $00 ; "インターネット"

; ---- text $449D-$44A4 (7 bytes) [PROBABLE] Shift-JIS "ウェブ" NUL-terminated; target of the pointer at 445A (group 444F entry 5)

String_1A_449D:: ; 1A:449D
	db $83, $45, $83, $46, $83, $75, $00 ; "ウェブ"

; ---- text $44A4-$44C7 (35 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_44A4:: ; 1A:44A4
	db $83, $45, $83, $46, $83, $75, $83, $54, $83, $43, $83, $67, $00 ; "ウェブサイト"
	db $83, $49, $83, $74, $83, $89, $83, $43, $83, $93, $00 ; "オフライン"
	db $83, $49, $83, $93, $83, $89, $83, $43, $83, $93, $00 ; "オンライン"

; ---- data $44C7-$44CC (5 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 44C7-44E0 by higher-priority evidence]

Data_MobileDict_Cat02Count:: ; 1A:44C7
Data_1A_44C7::
	db $02

Table_MobileDict_Cat02Strings:: ; 1A:44C8
	db $CC, $44, $D5, $44

; ---- text $44CC-$44E0 (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_44CC:: ; 1A:44CC
	db $82, $A9, $82, $A8, $82, $E0, $82, $B6, $00 ; "かおもじ"
	db $83, $52, $83, $93, $83, $65, $83, $93, $83, $63, $00 ; "コンテンツ"

; ---- data $44E0-$44E1 (1 bytes) [PROBABLE] group count byte = 08 (group header, see Table_1A_4439)

Data_MobileDict_Cat03Count:: ; 1A:44E0
Data_1A_44E0::
	db $08

; ---- ptrtable $44E1-$44F1 (16 bytes) [PROBABLE] 8 string pointers 44F1 44F8 44FF 4508 4511 4520 452D 4536 (first = end of header)

Table_MobileDict_Cat03Strings:: ; 1A:44E1
Table_1A_44E1::
	dw String_1A_44F1
	dw $44F8
	dw String_1A_44FF
	dw $4508
	dw $4511
	dw $4520
	dw $452D
	dw $4536

; ---- text $44F1-$44FF (14 bytes) [PROBABLE] 2 strings: "サーバ" (83 54 81 5B 83 6F 00) and "サイト" (83 54 83 43 83 67 00) - targets of the pointers 44F1/44F8

String_1A_44F1:: ; 1A:44F1
	db $83, $54, $81, $5B, $83, $6F, $00 ; "サーバ"
	db $83, $54, $83, $43, $83, $67, $00 ; "サイト"

; ---- text $44FF-$453F (64 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_44FF:: ; 1A:44FF
	db $83, $57, $83, $83, $83, $93, $83, $76, $00 ; "ジャンプ"
	db $82, $B6, $82, $E3, $82, $B5, $82, $F1, $00 ; "じゅしん"
	db $82, $B5, $82, $E5, $82, $AB, $82, $C6, $82, $A4, $82, $EB, $82, $AD, $00 ; "しょきとうろく"
	db $83, $5A, $83, $4C, $83, $85, $83, $8A, $83, $65, $83, $42, $00 ; "セキュリティ"
	db $82, $B9, $82, $C2, $82, $BC, $82, $AD, $00 ; "せつぞく"
	db $82, $BB, $82, $A4, $82, $B5, $82, $F1, $00 ; "そうしん"

; ---- data $453F-$4540 (1 bytes) [PROBABLE] group count byte = 03

Data_MobileDict_Cat04Count:: ; 1A:453F
Data_1A_453F::
	db $03

; ---- ptrtable $4540-$4546 (6 bytes) [PROBABLE] 3 string pointers 4546 454F 455C (first = end of header)

Table_MobileDict_Cat04Strings:: ; 1A:4540
Table_1A_4540::
	dw String_1A_4546
	dw $454F
	dw $455C

; ---- text $4546-$456B (37 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_4546:: ; 1A:4546
	db $83, $5E, $83, $43, $83, $67, $83, $8B, $00 ; "タイトル"
	db $83, $5F, $83, $45, $83, $93, $83, $8D, $81, $5B, $83, $68, $00 ; "ダウンロード"
	db $82, $C2, $82, $A4, $82, $B5, $82, $F1, $83, $47, $83, $89, $81, $5B, $00 ; "つうしんエラー"

; ---- data $456B-$456C (1 bytes) [PROBABLE] group count byte = 04 (group header of Table_1A_4439)

Data_MobileDict_Cat05Count:: ; 1A:456B
Data_1A_456B::
	db $04

; ---- ptrtable $456C-$4574 (8 bytes) [PROBABLE] 4 string pointers, first = end of the header (4574); mapper had these header bytes inside the following text run

Table_MobileDict_Cat05Strings:: ; 1A:456C
Table_1A_456C::
	dw String_1A_4574
	dw $4581
	dw $458C
	dw $4597

; ---- text $4574-$45A8 (52 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 4546-45A8 by higher-priority evidence]

String_1A_4574:: ; 1A:4574
	db $83, $6A, $83, $62, $83, $4E, $83, $6C, $81, $5B, $83, $80, $00 ; "ニックネーム"
	db $82, $C9, $82, $F1, $82, $B5, $82, $E5, $82, $A4, $00 ; "にんしょう"
	db $83, $6C, $83, $60, $83, $50, $83, $62, $83, $67, $00 ; "ネチケット"
	db $83, $6C, $83, $62, $83, $67, $83, $54, $81, $5B, $83, $74, $83, $42, $83, $93, $00 ; "ネットサーフィン"

; ---- data $45A8-$45A9 (1 bytes) [PROBABLE] group count byte = 07

Data_MobileDict_Cat06Count:: ; 1A:45A8
Data_1A_45A8::
	db $07

; ---- ptrtable $45A9-$45B7 (14 bytes) [PROBABLE] 7 string pointers 45B7 45C2 45D1 45DA 45E5 45F2 45FB (first = end of header)

Table_MobileDict_Cat06Strings:: ; 1A:45A9
Table_1A_45A9::
	dw String_1A_45B7
	dw $45C2
	dw $45D1
	dw $45DA
	dw $45E5
	dw $45F2
	dw $45FB

; ---- text $45B7-$4608 (81 bytes) [PROBABLE] text: 7 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_45B7:: ; 1A:45B7
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $00 ; "パスワード"
	db $83, $74, $83, $46, $83, $43, $83, $58, $83, $7D, $81, $5B, $83, $4E, $00 ; "フェイスマーク"
	db $83, $75, $83, $89, $83, $45, $83, $55, $00 ; "ブラウザ"
	db $83, $76, $83, $8D, $83, $6F, $83, $43, $83, $5F, $00 ; "プロバイダ"
	db $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00 ; "ページリスト"
	db $82, $D6, $82, $F1, $82, $B5, $82, $F1, $00 ; "へんしん"
	db $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "ホームページ"

; ---- data $4608-$4609 (1 bytes) [PROBABLE] group count byte = 0E, followed by Table_1A_4609 (14 pointers)

Data_MobileDict_Cat07Count:: ; 1A:4608
Data_1A_4608::
	db $0E

; ---- ptrtable $4609-$4625 (28 bytes) [PROBABLE] little-endian word table, 14 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4625..$46E4

Table_MobileDict_Cat07Strings:: ; 1A:4609
Table_1A_4609::
	dw String_1A_4625
	dw $462E
	dw String_1A_4637
	dw String_1A_463E
	dw $464D
	dw $465A
	dw $4667
	dw $4674
	dw $467D
	dw $4692
	dw $46AB
	dw $46C0
	dw $46D1
	dw $46E4

; ---- text $4625-$4637 (18 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_4625:: ; 1A:4625
	db $83, $81, $81, $5B, $83, $89, $81, $5B, $00 ; "メーラー"
	db $83, $81, $83, $8B, $82, $C6, $82, $E0, $00 ; "メルとも"

; ---- text $4637-$463E (7 bytes) [PROBABLE] Shift-JIS "メール" NUL-terminated; target of a pointer of Table_1A_4609 (463E-.. list, 4637)

String_1A_4637:: ; 1A:4637
	db $83, $81, $81, $5B, $83, $8B, $00 ; "メール"

; ---- text $463E-$46F9 (187 bytes) [PROBABLE] text: 11 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_463E:: ; 1A:463E
	db $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $00 ; "メールアドレス"
	db $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $00 ; "メールサーバ"
	db $83, $81, $81, $5B, $83, $8B, $83, $5C, $83, $74, $83, $67, $00 ; "メールソフト"
	db $83, $81, $83, $93, $83, $65, $83, $69, $83, $93, $83, $58, $00 ; "メンテナンス"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $00 ; "モバイル"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $66, $82, $61, $00 ; "モバイルアダプタＧＢ"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $54, $83, $7C, $81, $5B, $83, $67, $83, $5A, $83, $93, $83, $5E, $81, $5B, $00 ; "モバイルサポートセンター"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $56, $83, $58, $83, $65, $83, $80, $82, $66, $82, $61, $00 ; "モバイルシステムＧＢ"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $5A, $83, $93, $83, $5E, $81, $5B, $00 ; "モバイルセンター"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C, $81, $5B, $83, $69, $81, $5B, $00 ; "モバイルトレーナー"
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "モバイルホームページ"

; ---- data $46F9-$46FA (1 bytes) [PROBABLE] group count byte = 01 (group header of Table_1A_4439)

Data_MobileDict_Cat08Count:: ; 1A:46F9
Data_1A_46F9::
	db $01

; ---- ptrtable $46FA-$46FC (2 bytes) [PROBABLE] 1 string pointers, first = end of the header (46FC); mapper had these header bytes inside the following text run

Table_MobileDict_Cat08Strings:: ; 1A:46FA
Table_1A_46FA::
	dw String_1A_46FC

; ---- text $46FC-$4705 (9 bytes) [PROBABLE] text block: 12 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 463E-4705 by higher-priority evidence]

String_1A_46FC:: ; 1A:46FC
	db $83, $86, $81, $5B, $83, $55, $81, $5B, $00 ; "ユーザー"

; ---- data $4705-$4706 (1 bytes) [PROBABLE] group count byte = 02

Data_MobileDict_Cat09Count:: ; 1A:4705
Data_1A_4705::
	db $02

; ---- ptrtable $4706-$470A (4 bytes) [PROBABLE] 2 string pointers 470A 4711 (first = end of header)

Table_MobileDict_Cat09Strings:: ; 1A:4706
Table_1A_4706::
	dw String_1A_470A
	dw String_1A_4711

; ---- text $470A-$4711 (7 bytes) [PROBABLE] Shift-JIS "リンク" NUL-terminated (target of the pointer 470A)

String_1A_470A:: ; 1A:470A
	db $83, $8A, $83, $93, $83, $4E, $00 ; "リンク"

; ---- text $4711-$471E (13 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_4711:: ; 1A:4711
	db $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $00 ; "ログインＩＤ"

; ---- data $471E-$471F (1 bytes) [PROBABLE] group count byte = 01 (group header of Table_1A_4439)

Data_MobileDict_Cat10Count:: ; 1A:471E
Data_1A_471E::
	db $01

; ---- ptrtable $471F-$4721 (2 bytes) [PROBABLE] 1 string pointers, first = end of the header (4721); mapper had these header bytes inside the following text run

Table_MobileDict_Cat10Strings:: ; 1A:471F
Table_1A_471F::
	dw String_1A_4721

; ---- text $4721-$4736 (21 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 4711-4736 by higher-priority evidence]

String_1A_4721:: ; 1A:4721
	db $83, $8F, $81, $5B, $83, $8B, $83, $68, $83, $8F, $83, $43, $83, $68, $83, $45, $83, $46, $83, $75, $00 ; "ワールドワイドウェブ"

; ---- data $4736-$4737 (1 bytes) [PROBABLE] group count byte = 0A, followed by Table_1A_4737 (10 pointers)

Data_MobileDict_Cat11Count:: ; 1A:4736
Data_1A_4736::
	db $0A

; ---- ptrtable $4737-$474B (20 bytes) [PROBABLE] little-endian word table, 10 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $474B..$47A4; regular record stride between targets

Table_MobileDict_Cat11Strings:: ; 1A:4737
Table_1A_4737::
	dw String_1A_474B
	dw String_1A_475A
	dw String_1A_4763
	dw String_1A_477E
	dw $4785
	dw $478C
	dw $4793
	dw $479A
	dw $47A1
	dw String_1A_47A4

; ---- text $474B-$475A (15 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_474B:: ; 1A:474B
	db $82, $83, $82, $84, $82, $8D, $82, $81, $82, $6E, $82, $8E, $82, $85, $00 ; "ｃｄｍａＯｎｅ"

; ---- text $475A-$4763 (9 bytes) [PROBABLE] text block: 3 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 474B-477E by higher-priority evidence]

String_1A_475A:: ; 1A:475A
	db $82, $63, $82, $68, $82, $6E, $82, $6D, $00 ; "ＤＩＯＮ"

; ---- text $4763-$477E (27 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_4763:: ; 1A:4763
	db $82, $63, $82, $68, $82, $6E, $82, $6D, $83, $82, $83, $6F, $83, $43, $83, $8B, $82, $66, $82, $61, $83, $52, $81, $5B, $83, $58, $00 ; "ＤＩＯＮモバイルＧＢコース"

; ---- text $477E-$47A4 (38 bytes) [PROBABLE] 7 NUL-terminated strings "ＩＤＳＰ" "ＰＤＣ" "ＰＨＳ" "Ｗｅｂ" "ＷＷＷ" "※" (targets of the pointers 477E 4785 478C 4793 479A .. of Table_1A_4737)

String_1A_477E:: ; 1A:477E
	db $82, $68, $82, $72, $82, $6F, $00 ; "ＩＳＰ"
	db $82, $6F, $82, $63, $82, $62, $00 ; "ＰＤＣ"
	db $82, $6F, $82, $67, $82, $72, $00 ; "ＰＨＳ"
	db $82, $76, $82, $85, $82, $82, $00 ; "Ｗｅｂ"
	db $82, $76, $82, $76, $82, $76, $00 ; "ＷＷＷ"
	db $81, $97, $00 ; "＠"

; ---- text $47A4-$47B5 (17 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_1A_47A4:: ; 1A:47A4
	db $82, $AB, $82, $B2, $82, $A4, $82, $CC, $82, $E6, $82, $DD, $82, $A9, $82, $BD, $00 ; "きごうのよみかた"
