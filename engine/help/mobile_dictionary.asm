; engine/help/mobile_dictionary.asm
; bank 1A, $4000-$47B5 (1973 bytes); pinned by layout.link
; mobile dictionary index screen with category string tables

SECTION "engine/help/mobile_dictionary", ROMX

MobileDict_Run:: ; 1A:4000
Function_1A_4000::
	; [CONFIRMED] 121 insn(s); 121 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Stub_Nop_48_48BB
	ld a, $01
	ld [wMobileDict_Category], a
	ld [wMobileDict_RowCursor], a

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
	farcall Sprite_ResetAll
	ld de, $8000
	ld hl, Gfx_MobileDict_Tiles0
	ld a, $1A
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $8B01
	ld hl, Gfx_MobileDict_Tiles1
	ld a, $1A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8F01
	ld hl, Gfx_MobileDict_Tiles2
	ld a, $1A
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MobileDict_Bg
	ld a, $1A
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MobileDict_Screen
	ld a, $1A
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot2
	ld de, Objects_MobileDict
	ld a, $1A
	ld b, $80
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot3
	ld de, Objects_MobileDict
	ld a, $1A
	ld b, $81
	farcall Sprite_InitSlot
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, $53D0
	ld a, $1A
	farcall Palette_LoadToBuffer
	ld a, $00
	ld bc, $0A10
	ld de, $F000
	ld hl, $D0A1
	farcall Tilemap_FillRectSequential
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
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
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, $D000
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001A
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

MobileDict_Loop:: ; 1A:414B
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4163-$416D (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 1A:4160: 5 entries; fixed length (5 words) by the routine

Table_MobileDict_Buttons:: ; 1A:4163
Table_1A_4163::
	dw MobileDict_OnA
	dw MobileDict_OnB
	dw MobileDict_Ignore
	dw MobileDict_Ignore
	dw MobileDict_Idle

MobileDict_Idle:: ; 1A:416D
	; [CONFIRMED] 65 insn(s); 65 executed (in up to 1/18 scenarios)
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld a, [wMobileDict_Category]
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
	ld a, [wMobileDict_RowCursor]
	dec a
	ld b, a
	ld a, [wMobileDict_ScrollOffset]
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MobileDict_Ignore:: ; 1A:41E2
Label_1A_41E2::
	jp MobileDict_Loop

MobileDict_HandleDpad:: ; 1A:41E5
	bit 6, a
	jr nz, MobileDict_CursorUp
	bit 7, a
	jr nz, MobileDict_CursorDown
	bit 4, a
	jp nz, MobileDict_NextCategory

	; [CONFIRMED] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 0;
	; fall-through of the jpcc at 1A:41EF (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 41F2-4238 by apply_coverage --split [executed in 5 scenarios]
	bit 5, a
	jp nz, MobileDict_PrevCategory

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 41F2-4238 by apply_coverage --split
	ret

MobileDict_CursorUp:: ; 1A:41F8
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 41F2-4238 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wMobileDict_RowCursor]
	dec a
	jr z, MobileDict_ScrollUp
	ld [wMobileDict_RowCursor], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call MobileDict_DrawRowHighlight
	ret

MobileDict_ScrollUp:: ; 1A:4215
	ld a, [wMobileDict_ScrollOffset]
	or a, a
	ret z
	dec a
	ld [wMobileDict_ScrollOffset], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ret

MobileDict_CursorDown:: ; 1A:4238
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 1/18 scenarios)
	ld a, [wMobileDict_EntryCount]
	ld b, a
	ld a, [wMobileDict_RowCursor]
	ld c, a
	ld a, [wMobileDict_ScrollOffset]
	add a, c
	cp a, b
	ret z
	ld a, c
	cp a, $05
	jr z, MobileDict_ScrollDown
	inc a
	ld [wMobileDict_RowCursor], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call MobileDict_DrawRowHighlight
	ret

MobileDict_ScrollDown:: ; 1A:4263
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by jrcc from 1A:4249 (executed) [executed in 1 scenarios]
	ld hl, wMobileDict_ScrollOffset
	inc [hl]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ret

MobileDict_NextCategory:: ; 1A:4281
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wMobileDict_Category]
	cp a, $0B
	jr nz, .skip

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1A:4286 (executed) [executed in 3 scenarios]
	xor a, a

.skip ; 1A:4289
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios)
	inc a
	ld [wMobileDict_Category], a
	ld a, $01
	ld [wMobileDict_RowCursor], a
	dec a
	ld [wMobileDict_ScrollOffset], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ret

MobileDict_PrevCategory:: ; 1A:42B0
	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 1;
	; entered by jpcc from 1A:41F4 (PROBABLE code) [executed in 3 scenarios]
	ld a, [wMobileDict_Category]
	dec a
	jr nz, .skip
	ld a, $0B
.skip ; 1A:42B8
	ld [wMobileDict_Category], a
	ld a, $01
	ld [wMobileDict_RowCursor], a
	dec a
	ld [wMobileDict_ScrollOffset], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ret

MobileDict_DrawRowHighlight:: ; 1A:42DE
Function_1A_42DE::
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $D4A1
	ld bc, $0A10
	ld de, $F800
	ld a, $07
	farcall Tilemap_ApplyMaskRect
	ld a, [wMobileDict_RowCursor]
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
	farcall Tilemap_ApplyMaskRect
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

MobileDict_UpdateTabSprites:: ; 1A:4317
	ld a, [wMobileDict_Category]
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
	ld hl, wSpriteSlot4
	ld a, $1A
	farcall Sprite_InitSlot
	pop hl
	ld a, [hl]
	ld [wSpriteSlot4 + $01], a
	ld a, $15
	ld [wSpriteSlot4], a
	ld a, [wMobileDict_ScrollOffset]
	or a, a
	jr z, .l4351

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 1A:4344 (executed) [executed in 1 scenarios]
	ld de, $2048
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	jr .l435A

.l4351 ; 1A:4351
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	ld de, $00A0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
.l435A ; 1A:435A
	ld a, [wMobileDict_EntryCount]
	ld b, a
	ld a, [wMobileDict_ScrollOffset]
	add a, $05
	cp a, b
	jr nc, .l4371
	ld de, $7848
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jr .done
.l4371 ; 1A:4371
	ld de, $00A0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.done ; 1A:437A
	ret

; ---- data $437B-$4391 (22 bytes) [PROBABLE] 11 pairs (index,value): 00 08 / 01 14 / 02 20 / 03 2C ... 0A 80 (value = 8 + 12*index), right after the ret of the preceding routine and before Function_1A_4391; first 4 bytes read in a trace; the 18-byte mapper hole is the rest of this table

Table_MobileDict_TabPositions:: ; 1A:437B
Data_1A_437B::
	db $00, $08, $01, $14, $02, $20, $03, $2C, $04, $38, $05, $44, $06, $50, $07, $5C
	db $08, $68, $09, $74, $0A, $80

MobileDict_LoadPage:: ; 1A:4391
Function_1A_4391::
	; [CONFIRMED] 83 insn(s); 83 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
.loop ; 1A:43AA
	ld a, [wMobileDict_Category]
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
	ld [wMobileDict_EntryCount], a
	ld a, [wMobileDict_ScrollOffset]
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
	ldh [hTextTiles_GridRow], a
	ld a, $05
	ldh [hTextTiles_GridRowEnd], a
	ld de, $D000
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld bc, $0010
	ld a, $1A
	farcall TextTiles_RenderGridRows
	call Sound_FrameService
	pop de
	inc d
	ld a, d
	cp a, $05
	jr z, .l43F9
	ld b, a
	ld a, [wMobileDict_EntryCount]
	cp a, b
	jr nz, .loop
.l43F9 ; 1A:43F9
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, $D800
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
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
	dw String_MobileDict_Cat01Entry00
	dw String_MobileDict_Cat01Entry01
	dw String_MobileDict_Cat01Entry02
	dw String_MobileDict_Cat01Entry03
	dw String_MobileDict_Cat01Entry04
	dw String_MobileDict_Cat01Entry05
	dw String_MobileDict_Cat01Entry06
	dw String_MobileDict_Cat01Entry07
	dw String_MobileDict_Cat01Entry08

; ---- text $4462-$449D (59 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat01Entry00:: ; 1A:4462
String_1A_4462::
	db "アカウント", 0
String_MobileDict_Cat01Entry01:: ; 1A:446D
String_1A_446D::
	db "あてさき", 0
String_MobileDict_Cat01Entry02:: ; 1A:4476
String_1A_4476::
	db "アドレス", 0
String_MobileDict_Cat01Entry03:: ; 1A:447F
String_1A_447F::
	db "アドレスちょう", 0
String_MobileDict_Cat01Entry04:: ; 1A:448E
String_1A_448E::
	db "インターネット", 0
POPC

; ---- text $449D-$44A4 (7 bytes) [PROBABLE] Shift-JIS "ウェブ" NUL-terminated; target of the pointer at 445A (group 444F entry 5)

PUSHC sjis
String_MobileDict_Cat01Entry05:: ; 1A:449D
String_1A_449D::
	db "ウェブ", 0
POPC

; ---- text $44A4-$44C7 (35 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat01Entry06:: ; 1A:44A4
String_1A_44A4::
	db "ウェブサイト", 0
String_MobileDict_Cat01Entry07:: ; 1A:44B1
String_1A_44B1::
	db "オフライン", 0
String_MobileDict_Cat01Entry08:: ; 1A:44BC
String_1A_44BC::
	db "オンライン", 0
POPC

; ---- data $44C7-$44CC (5 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 44C7-44E0 by higher-priority evidence]

Data_MobileDict_Cat02Count:: ; 1A:44C7
Data_1A_44C7::
	db $02

Table_MobileDict_Cat02Strings:: ; 1A:44C8
	db $CC, $44, $D5, $44

; ---- text $44CC-$44E0 (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat02Entry00:: ; 1A:44CC
String_1A_44CC::
	db "かおもじ", 0
	db "コンテンツ", 0
POPC

; ---- data $44E0-$44E1 (1 bytes) [PROBABLE] group count byte = 08 (group header, see Table_1A_4439)

Data_MobileDict_Cat03Count:: ; 1A:44E0
Data_1A_44E0::
	db $08

; ---- ptrtable $44E1-$44F1 (16 bytes) [PROBABLE] 8 string pointers 44F1 44F8 44FF 4508 4511 4520 452D 4536 (first = end of header)

Table_MobileDict_Cat03Strings:: ; 1A:44E1
Table_1A_44E1::
	dw String_MobileDict_Cat03Entry00
	dw String_MobileDict_Cat03Entry01
	dw String_MobileDict_Cat03Entry02
	dw String_MobileDict_Cat03Entry03
	dw String_MobileDict_Cat03Entry04
	dw String_MobileDict_Cat03Entry05
	dw String_MobileDict_Cat03Entry06
	dw String_MobileDict_Cat03Entry07

; ---- text $44F1-$44FF (14 bytes) [PROBABLE] 2 strings: "サーバ" (83 54 81 5B 83 6F 00) and "サイト" (83 54 83 43 83 67 00) - targets of the pointers 44F1/44F8

PUSHC sjis
String_MobileDict_Cat03Entry00:: ; 1A:44F1
String_1A_44F1::
	db "サーバ", 0
String_MobileDict_Cat03Entry01:: ; 1A:44F8
String_1A_44F8::
	db "サイト", 0
POPC

; ---- text $44FF-$453F (64 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat03Entry02:: ; 1A:44FF
String_1A_44FF::
	db "ジャンプ", 0
String_MobileDict_Cat03Entry03:: ; 1A:4508
String_1A_4508::
	db "じゅしん", 0
String_MobileDict_Cat03Entry04:: ; 1A:4511
String_1A_4511::
	db "しょきとうろく", 0
String_MobileDict_Cat03Entry05:: ; 1A:4520
String_1A_4520::
	db "セキュリティ", 0
String_MobileDict_Cat03Entry06:: ; 1A:452D
String_1A_452D::
	db "せつぞく", 0
String_MobileDict_Cat03Entry07:: ; 1A:4536
String_1A_4536::
	db "そうしん", 0
POPC

; ---- data $453F-$4540 (1 bytes) [PROBABLE] group count byte = 03

Data_MobileDict_Cat04Count:: ; 1A:453F
Data_1A_453F::
	db $03

; ---- ptrtable $4540-$4546 (6 bytes) [PROBABLE] 3 string pointers 4546 454F 455C (first = end of header)

Table_MobileDict_Cat04Strings:: ; 1A:4540
Table_1A_4540::
	dw String_MobileDict_Cat04Entry00
	dw String_MobileDict_Cat04Entry01
	dw String_MobileDict_Cat04Entry02

; ---- text $4546-$456B (37 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat04Entry00:: ; 1A:4546
String_1A_4546::
	db "タイトル", 0
String_MobileDict_Cat04Entry01:: ; 1A:454F
String_1A_454F::
	db "ダウンロード", 0
String_MobileDict_Cat04Entry02:: ; 1A:455C
String_1A_455C::
	db "つうしんエラー", 0
POPC

; ---- data $456B-$456C (1 bytes) [PROBABLE] group count byte = 04 (group header of Table_1A_4439)

Data_MobileDict_Cat05Count:: ; 1A:456B
Data_1A_456B::
	db $04

; ---- ptrtable $456C-$4574 (8 bytes) [PROBABLE] 4 string pointers, first = end of the header (4574); mapper had these header bytes inside the following text run

Table_MobileDict_Cat05Strings:: ; 1A:456C
Table_1A_456C::
	dw String_MobileDict_Cat05Entry00
	dw String_MobileDict_Cat05Entry01
	dw String_MobileDict_Cat05Entry02
	dw String_MobileDict_Cat05Entry03

; ---- text $4574-$45A8 (52 bytes) [PROBABLE] text block: 7 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 4546-45A8 by higher-priority evidence]

PUSHC sjis
String_MobileDict_Cat05Entry00:: ; 1A:4574
String_1A_4574::
	db "ニックネーム", 0
String_MobileDict_Cat05Entry01:: ; 1A:4581
String_1A_4581::
	db "にんしょう", 0
String_MobileDict_Cat05Entry02:: ; 1A:458C
String_1A_458C::
	db "ネチケット", 0
String_MobileDict_Cat05Entry03:: ; 1A:4597
String_1A_4597::
	db "ネットサーフィン", 0
POPC

; ---- data $45A8-$45A9 (1 bytes) [PROBABLE] group count byte = 07

Data_MobileDict_Cat06Count:: ; 1A:45A8
Data_1A_45A8::
	db $07

; ---- ptrtable $45A9-$45B7 (14 bytes) [PROBABLE] 7 string pointers 45B7 45C2 45D1 45DA 45E5 45F2 45FB (first = end of header)

Table_MobileDict_Cat06Strings:: ; 1A:45A9
Table_1A_45A9::
	dw String_MobileDict_Cat06Entry00
	dw String_MobileDict_Cat06Entry01
	dw String_MobileDict_Cat06Entry02
	dw String_MobileDict_Cat06Entry03
	dw String_MobileDict_Cat06Entry04
	dw String_MobileDict_Cat06Entry05
	dw String_MobileDict_Cat06Entry06

; ---- text $45B7-$4608 (81 bytes) [PROBABLE] text: 7 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat06Entry00:: ; 1A:45B7
String_1A_45B7::
	db "パスワード", 0
String_MobileDict_Cat06Entry01:: ; 1A:45C2
String_1A_45C2::
	db "フェイスマーク", 0
String_MobileDict_Cat06Entry02:: ; 1A:45D1
String_1A_45D1::
	db "ブラウザ", 0
String_MobileDict_Cat06Entry03:: ; 1A:45DA
String_1A_45DA::
	db "プロバイダ", 0
String_MobileDict_Cat06Entry04:: ; 1A:45E5
String_1A_45E5::
	db "ページリスト", 0
String_MobileDict_Cat06Entry05:: ; 1A:45F2
String_1A_45F2::
	db "へんしん", 0
String_MobileDict_Cat06Entry06:: ; 1A:45FB
String_1A_45FB::
	db "ホームページ", 0
POPC

; ---- data $4608-$4609 (1 bytes) [PROBABLE] group count byte = 0E, followed by Table_1A_4609 (14 pointers)

Data_MobileDict_Cat07Count:: ; 1A:4608
Data_1A_4608::
	db $0E

; ---- ptrtable $4609-$4625 (28 bytes) [PROBABLE] little-endian word table, 14 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4625..$46E4

Table_MobileDict_Cat07Strings:: ; 1A:4609
Table_1A_4609::
	dw String_MobileDict_Cat07Entry00
	dw String_MobileDict_Cat07Entry01
	dw String_MobileDict_Cat07Entry02
	dw String_MobileDict_Cat07Entry03
	dw String_MobileDict_Cat07Entry04
	dw String_MobileDict_Cat07Entry05
	dw String_MobileDict_Cat07Entry06
	dw String_MobileDict_Cat07Entry07
	dw String_MobileDict_Cat07Entry08
	dw String_MobileDict_Cat07Entry09
	dw String_MobileDict_Cat07Entry10
	dw String_MobileDict_Cat07Entry11
	dw String_MobileDict_Cat07Entry12
	dw String_MobileDict_Cat07Entry13

; ---- text $4625-$4637 (18 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat07Entry00:: ; 1A:4625
String_1A_4625::
	db "メーラー", 0
String_MobileDict_Cat07Entry01:: ; 1A:462E
String_1A_462E::
	db "メルとも", 0
POPC

; ---- text $4637-$463E (7 bytes) [PROBABLE] Shift-JIS "メール" NUL-terminated; target of a pointer of Table_1A_4609 (463E-.. list, 4637)

PUSHC sjis
String_MobileDict_Cat07Entry02:: ; 1A:4637
String_1A_4637::
	db "メール", 0
POPC

; ---- text $463E-$46F9 (187 bytes) [PROBABLE] text: 11 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat07Entry03:: ; 1A:463E
String_1A_463E::
	db "メールアドレス", 0
String_MobileDict_Cat07Entry04:: ; 1A:464D
String_1A_464D::
	db "メールサーバ", 0
String_MobileDict_Cat07Entry05:: ; 1A:465A
String_1A_465A::
	db "メールソフト", 0
String_MobileDict_Cat07Entry06:: ; 1A:4667
String_1A_4667::
	db "メンテナンス", 0
String_MobileDict_Cat07Entry07:: ; 1A:4674
String_1A_4674::
	db "モバイル", 0
String_MobileDict_Cat07Entry08:: ; 1A:467D
String_1A_467D::
	db "モバイルアダプタＧＢ", 0
String_MobileDict_Cat07Entry09:: ; 1A:4692
String_1A_4692::
	db "モバイルサポートセンター", 0
String_MobileDict_Cat07Entry10:: ; 1A:46AB
String_1A_46AB::
	db "モバイルシステムＧＢ", 0
String_MobileDict_Cat07Entry11:: ; 1A:46C0
String_1A_46C0::
	db "モバイルセンター", 0
String_MobileDict_Cat07Entry12:: ; 1A:46D1
String_1A_46D1::
	db "モバイルトレーナー", 0
String_MobileDict_Cat07Entry13:: ; 1A:46E4
String_1A_46E4::
	db "モバイルホームページ", 0
POPC

; ---- data $46F9-$46FA (1 bytes) [PROBABLE] group count byte = 01 (group header of Table_1A_4439)

Data_MobileDict_Cat08Count:: ; 1A:46F9
Data_1A_46F9::
	db $01

; ---- ptrtable $46FA-$46FC (2 bytes) [PROBABLE] 1 string pointers, first = end of the header (46FC); mapper had these header bytes inside the following text run

Table_MobileDict_Cat08Strings:: ; 1A:46FA
Table_1A_46FA::
	dw String_MobileDict_Cat08Entry00

; ---- text $46FC-$4705 (9 bytes) [PROBABLE] text block: 12 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 463E-4705 by higher-priority evidence]

PUSHC sjis
String_MobileDict_Cat08Entry00:: ; 1A:46FC
String_1A_46FC::
	db "ユーザー", 0
POPC

; ---- data $4705-$4706 (1 bytes) [PROBABLE] group count byte = 02

Data_MobileDict_Cat09Count:: ; 1A:4705
Data_1A_4705::
	db $02

; ---- ptrtable $4706-$470A (4 bytes) [PROBABLE] 2 string pointers 470A 4711 (first = end of header)

Table_MobileDict_Cat09Strings:: ; 1A:4706
Table_1A_4706::
	dw String_MobileDict_Cat09Entry00
	dw String_MobileDict_Cat09Entry01

; ---- text $470A-$4711 (7 bytes) [PROBABLE] Shift-JIS "リンク" NUL-terminated (target of the pointer 470A)

PUSHC sjis
String_MobileDict_Cat09Entry00:: ; 1A:470A
String_1A_470A::
	db "リンク", 0
POPC

; ---- text $4711-$471E (13 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat09Entry01:: ; 1A:4711
String_1A_4711::
	db "ログインＩＤ", 0
POPC

; ---- data $471E-$471F (1 bytes) [PROBABLE] group count byte = 01 (group header of Table_1A_4439)

Data_MobileDict_Cat10Count:: ; 1A:471E
Data_1A_471E::
	db $01

; ---- ptrtable $471F-$4721 (2 bytes) [PROBABLE] 1 string pointers, first = end of the header (4721); mapper had these header bytes inside the following text run

Table_MobileDict_Cat10Strings:: ; 1A:471F
Table_1A_471F::
	dw String_MobileDict_Cat10Entry00

; ---- text $4721-$4736 (21 bytes) [PROBABLE] text block: 2 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 4711-4736 by higher-priority evidence]

PUSHC sjis
String_MobileDict_Cat10Entry00:: ; 1A:4721
String_1A_4721::
	db "ワールドワイドウェブ", 0
POPC

; ---- data $4736-$4737 (1 bytes) [PROBABLE] group count byte = 0A, followed by Table_1A_4737 (10 pointers)

Data_MobileDict_Cat11Count:: ; 1A:4736
Data_1A_4736::
	db $0A

; ---- ptrtable $4737-$474B (20 bytes) [PROBABLE] little-endian word table, 10 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $474B..$47A4; regular record stride between targets

Table_MobileDict_Cat11Strings:: ; 1A:4737
Table_1A_4737::
	dw String_MobileDict_Cat11Entry00
	dw String_MobileDict_Cat11Entry01
	dw String_MobileDict_Cat11Entry02
	dw String_MobileDict_Cat11Entry03
	dw String_MobileDict_Cat11Entry04
	dw String_MobileDict_Cat11Entry05
	dw String_MobileDict_Cat11Entry06
	dw String_MobileDict_Cat11Entry07
	dw String_MobileDict_Cat11Entry08
	dw String_MobileDict_Cat11Entry09

; ---- text $474B-$475A (15 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat11Entry00:: ; 1A:474B
String_1A_474B::
	db "ｃｄｍａＯｎｅ", 0
POPC

; ---- text $475A-$4763 (9 bytes) [PROBABLE] text block: 3 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 474B-477E by higher-priority evidence]

PUSHC sjis
String_MobileDict_Cat11Entry01:: ; 1A:475A
String_1A_475A::
	db "ＤＩＯＮ", 0
POPC

; ---- text $4763-$477E (27 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat11Entry02:: ; 1A:4763
String_1A_4763::
	db "ＤＩＯＮモバイルＧＢコース", 0
POPC

; ---- text $477E-$47A4 (38 bytes) [PROBABLE] 7 NUL-terminated strings "ＩＤＳＰ" "ＰＤＣ" "ＰＨＳ" "Ｗｅｂ" "ＷＷＷ" "※" (targets of the pointers 477E 4785 478C 4793 479A .. of Table_1A_4737)

PUSHC sjis
String_MobileDict_Cat11Entry03:: ; 1A:477E
String_1A_477E::
	db "ＩＳＰ", 0
String_MobileDict_Cat11Entry04:: ; 1A:4785
String_1A_4785::
	db "ＰＤＣ", 0
String_MobileDict_Cat11Entry05:: ; 1A:478C
String_1A_478C::
	db "ＰＨＳ", 0
String_MobileDict_Cat11Entry06:: ; 1A:4793
String_1A_4793::
	db "Ｗｅｂ", 0
String_MobileDict_Cat11Entry07:: ; 1A:479A
String_1A_479A::
	db "ＷＷＷ", 0
String_MobileDict_Cat11Entry08:: ; 1A:47A1
String_1A_47A1::
	db "＠", 0
POPC

; ---- text $47A4-$47B5 (17 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MobileDict_Cat11Entry09:: ; 1A:47A4
String_1A_47A4::
	db "きごうのよみかた", 0
POPC
