; engine/help/mobile_dictionary.asm
; bank 1A, $4000-$47B5 (1973 bytes); pinned by layout.link
; mobile dictionary index screen with category string tables

SECTION "engine/help/mobile_dictionary", ROMX

MobileDict_Run:: ; 1A:4000

	; [CONFIRMED] 121 insn(s); 121 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall ReturnImmediately
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
	ld hl, Gfx_MobileDict_Tiles8000Vb0
	ld a, BANK(Gfx_MobileDict_Tiles8000Vb0)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $8B01
	ld hl, Gfx_MobileDict_Tiles8B00Vb1
	ld a, BANK(Gfx_MobileDict_Tiles8B00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8F01
	ld hl, Gfx_MobileDict_Tiles8F00Vb1
	ld a, BANK(Gfx_MobileDict_Tiles8F00Vb1)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MobileDict_Bg
	ld a, BANK(Palette_MobileDict_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MobileDict_Screen
	ld a, BANK(Tilemap_MobileDict_Screen)
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot2
	ld de, Objects_MobileDict
	ld a, BANK(Objects_MobileDict)
	ld b, $80
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot3
	ld de, Objects_MobileDict
	ld a, BANK(Objects_MobileDict)
	ld b, $81
	farcall Sprite_InitSlot
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MobileDict_Obj
	ld a, BANK(Palette_MobileDict_Obj)
	farcall Palette_LoadToBuffer
	ld a, $00
	ld bc, $0A10
	ld de, $F000
	ld hl, wScreenTileMap + $A1
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
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, wTileStage2
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
	dw MobileDict_OnA
	dw MobileDict_OnB
	dw MobileDict_Ignore
	dw MobileDict_Ignore
	dw MobileDict_Idle

MobileDict_Idle:: ; 1A:416D
	; [CONFIRMED] 65 insn(s); 65 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DPAD
	call nz, MobileDict_HandleDpad
	jp MobileDict_Loop

MobileDict_OnA:: ; 1A:4177
	play_sfx SFX_CONFIRM
	farcall Palette_FadeOutToWhite
	ld a, [wMobileDict_Category]
	dec a
	add a, a
	ld hl, Table_MobileDict_CategoryPageLists
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
	play_sfx SFX_CANCEL
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MobileDict_Ignore:: ; 1A:41E2
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
	play_sfx SFX_CURSOR_MOVE
	call MobileDict_DrawRowHighlight
	ret

MobileDict_ScrollUp:: ; 1A:4215
	ld a, [wMobileDict_ScrollOffset]
	or a, a
	ret z
	dec a
	ld [wMobileDict_ScrollOffset], a
	play_sfx SFX_CURSOR_MOVE
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
	play_sfx SFX_CURSOR_MOVE
	call MobileDict_DrawRowHighlight
	ret

MobileDict_ScrollDown:: ; 1A:4263
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by jrcc from 1A:4249 (executed) [executed in 1 scenarios]
	ld hl, wMobileDict_ScrollOffset
	inc [hl]
	play_sfx SFX_CURSOR_MOVE
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	ret

MobileDict_NextCategory:: ; 1A:4281
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wMobileDict_Category]
	cp a, $0B
	jr nz, .increment_category

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1A:4286 (executed) [executed in 3 scenarios]
	xor a, a

.increment_category ; 1A:4289
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
	play_sfx SFX_CURSOR_MOVE
	ret

MobileDict_PrevCategory:: ; 1A:42B0
	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 1;
	; entered by jpcc from 1A:41F4 (PROBABLE code) [executed in 3 scenarios]
	ld a, [wMobileDict_Category]
	dec a
	jr nz, .store_previous_category
	ld a, $0B
.store_previous_category ; 1A:42B8
	ld [wMobileDict_Category], a
	ld a, $01
	ld [wMobileDict_RowCursor], a
	dec a
	ld [wMobileDict_ScrollOffset], a
	call MobileDict_LoadPage
	call MobileDict_DrawRowHighlight
	call MobileDict_UpdateTabSprites
	play_sfx SFX_CURSOR_MOVE
	ret

MobileDict_DrawRowHighlight:: ; 1A:42DE

	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wScreenAttrMap + $A1
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
	ld de, wScreenAttrMap + $A1
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
	ld de, Objects_MobileDict_Entry2
	ld hl, wSpriteSlot4
	ld a, BANK(Objects_MobileDict_Entry2)
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
	jr .return_to_caller
.l4371 ; 1A:4371
	ld de, $00A0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.return_to_caller ; 1A:437A
	ret

; ---- data $437B-$4391 (22 bytes) [PROBABLE] 11 pairs (index,value): 00 08 / 01 14 / 02 20 / 03 2C ... 0A 80 (value = 8 + 12*index), right after the ret of the preceding routine and before MobileDict_LoadPage; first 4 bytes read in a trace; the 18-byte mapper hole is the rest of this table

Table_MobileDict_TabPositions:: ; 1A:437B

	db $00, $08, $01, $14, $02, $20, $03, $2C, $04, $38, $05, $44, $06, $50, $07, $5C
	db $08, $68, $09, $74, $0A, $80

MobileDict_LoadPage:: ; 1A:4391

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
	ld hl, wTileStage2
	call FillBytes
	ld d, $00
.render_next_entry ; 1A:43AA
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
	ld de, wTileStage2
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
	jr nz, .render_next_entry
.l43F9 ; 1A:43F9
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, wTileStage2 + $800
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

; English dictionary entry pointers; original code, counts and unselected slots retained.
; [PROBABLE] Static donor text, pointer bounds and Bank48 glyph repertoire checked; runtime unvalidated.

Table_MobileDict_Categories:: ; 1A:4439
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

PUSHC sjis

Data_MobileDict_Cat01Count:: ; 1A:444F
	db 9
Table_MobileDict_Cat01Strings:: ; 1A:4450
	dw String_MobileDict_Cat01Entry00
	dw String_MobileDict_Cat01Entry01
	dw String_MobileDict_Cat01Entry02
	dw String_MobileDict_Cat01Entry03
	dw String_MobileDict_Cat01Entry04
	dw String_MobileDict_Cat01Entry05
	dw String_MobileDict_Cat01Entry06
	dw String_MobileDict_Cat01Entry07
	dw String_MobileDict_Cat01Entry08

; Unselected original slot at 1A:4462; its English label is in the same-bank tail.
	db "アカウント", 0

; Unselected original slot at 1A:446D; its English label is in the same-bank tail.
	db "あてさき", 0

; Unselected original slot at 1A:4476; its English label is in the same-bank tail.
	db "アドレス", 0

; Unselected original slot at 1A:447F; its English label is in the same-bank tail.
	db "アドレスちょう", 0

; Unselected original slot at 1A:448E; its English label is in the same-bank tail.
	db "インターネット", 0

String_MobileDict_Cat01Entry05:: ; 1A:449D
	db "Ｗｅｂ", 0

; Unselected original slot at 1A:44A4; its English label is in the same-bank tail.
	db "ウェブサイト", 0

; Unselected original slot at 1A:44B1; its English label is in the same-bank tail.
	db "オフライン", 0

; Unselected original slot at 1A:44BC; its English label is in the same-bank tail.
	db "オンライン", 0

Data_MobileDict_Cat02Count:: ; 1A:44C7
	db 2
Table_MobileDict_Cat02Strings:: ; 1A:44C8
	dw String_MobileDict_Cat02Entry00
	dw String_MobileDict_EnglishCat02Entry01

; Unselected original slot at 1A:44CC; its English label is in the same-bank tail.
	db "かおもじ", 0

; Unselected original slot at 1A:44D5; its English label is in the same-bank tail.
	db "コンテンツ", 0

Data_MobileDict_Cat03Count:: ; 1A:44E0
	db 8
Table_MobileDict_Cat03Strings:: ; 1A:44E1
	dw String_MobileDict_Cat03Entry00
	dw String_MobileDict_Cat03Entry01
	dw String_MobileDict_Cat03Entry02
	dw String_MobileDict_Cat03Entry03
	dw String_MobileDict_Cat03Entry04
	dw String_MobileDict_Cat03Entry05
	dw String_MobileDict_Cat03Entry06
	dw String_MobileDict_Cat03Entry07

; Unselected original slot at 1A:44F1; its English label is in the same-bank tail.
	db "サーバ", 0

; Unselected original slot at 1A:44F8; its English label is in the same-bank tail.
	db "サイト", 0

String_MobileDict_Cat03Entry02:: ; 1A:44FF
	db "Ｊｕｍｐ", 0

; Unselected original slot at 1A:4508; its English label is in the same-bank tail.
	db "じゅしん", 0

; Unselected original slot at 1A:4511; its English label is in the same-bank tail.
	db "しょきとうろく", 0

; Unselected original slot at 1A:4520; its English label is in the same-bank tail.
	db "セキュリティ", 0

; Unselected original slot at 1A:452D; its English label is in the same-bank tail.
	db "せつぞく", 0

String_MobileDict_Cat03Entry07:: ; 1A:4536
	db "Ｓｅｎｄ", 0

Data_MobileDict_Cat04Count:: ; 1A:453F
	db 3
Table_MobileDict_Cat04Strings:: ; 1A:4540
	dw String_MobileDict_Cat04Entry00
	dw String_MobileDict_Cat04Entry01
	dw String_MobileDict_Cat04Entry02

; Unselected original slot at 1A:4546; its English label is in the same-bank tail.
	db "タイトル", 0

; Unselected original slot at 1A:454F; its English label is in the same-bank tail.
	db "ダウンロード", 0

; Unselected original slot at 1A:455C; its English label is in the same-bank tail.
	db "つうしんエラー", 0

Data_MobileDict_Cat05Count:: ; 1A:456B
	db 4
Table_MobileDict_Cat05Strings:: ; 1A:456C
	dw String_MobileDict_Cat05Entry00
	dw String_MobileDict_Cat05Entry01
	dw String_MobileDict_Cat05Entry02
	dw String_MobileDict_Cat05Entry03

; Unselected original slot at 1A:4574; its English label is in the same-bank tail.
	db "ニックネーム", 0

String_MobileDict_Cat05Entry01:: ; 1A:4581
	db "Ａｕｔｈ．", 0

; Unselected original slot at 1A:458C; its English label is in the same-bank tail.
	db "ネチケット", 0

; Unselected original slot at 1A:4597; its English label is in the same-bank tail.
	db "ネットサーフィン", 0

Data_MobileDict_Cat06Count:: ; 1A:45A8
	db 7
Table_MobileDict_Cat06Strings:: ; 1A:45A9
	dw String_MobileDict_Cat06Entry00
	dw String_MobileDict_Cat06Entry01
	dw String_MobileDict_Cat06Entry02
	dw String_MobileDict_Cat06Entry03
	dw String_MobileDict_Cat06Entry04
	dw String_MobileDict_Cat06Entry05
	dw String_MobileDict_Cat06Entry06

; Unselected original slot at 1A:45B7; its English label is in the same-bank tail.
	db "パスワード", 0

; Unselected original slot at 1A:45C2; its English label is in the same-bank tail.
	db "フェイスマーク", 0

; Unselected original slot at 1A:45D1; its English label is in the same-bank tail.
	db "ブラウザ", 0

; Unselected original slot at 1A:45DA; its English label is in the same-bank tail.
	db "プロバイダ", 0

; Unselected original slot at 1A:45E5; its English label is in the same-bank tail.
	db "ページリスト", 0

; Unselected original slot at 1A:45F2; its English label is in the same-bank tail.
	db "へんしん", 0

; Unselected original slot at 1A:45FB; its English label is in the same-bank tail.
	db "ホームページ", 0

Data_MobileDict_Cat07Count:: ; 1A:4608
	db 14
Table_MobileDict_Cat07Strings:: ; 1A:4609
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

; Unselected original slot at 1A:4625; its English label is in the same-bank tail.
	db "メーラー", 0

; Unselected original slot at 1A:462E; its English label is in the same-bank tail.
	db "メルとも", 0

; Unselected original slot at 1A:4637; its English label is in the same-bank tail.
	db "メール", 0

; Unselected original slot at 1A:463E; its English label is in the same-bank tail.
	db "メールアドレス", 0

; Unselected original slot at 1A:464D; its English label is in the same-bank tail.
	db "メールサーバ", 0

; Unselected original slot at 1A:465A; its English label is in the same-bank tail.
	db "メールソフト", 0

; Unselected original slot at 1A:4667; its English label is in the same-bank tail.
	db "メンテナンス", 0

; Unselected original slot at 1A:4674; its English label is in the same-bank tail.
	db "モバイル", 0

; Unselected original slot at 1A:467D; its English label is in the same-bank tail.
	db "モバイルアダプタＧＢ", 0

; Unselected original slot at 1A:4692; its English label is in the same-bank tail.
	db "モバイルサポートセンター", 0

; Unselected original slot at 1A:46AB; its English label is in the same-bank tail.
	db "モバイルシステムＧＢ", 0

; Unselected original slot at 1A:46C0; its English label is in the same-bank tail.
	db "モバイルセンター", 0

; Unselected original slot at 1A:46D1; its English label is in the same-bank tail.
	db "モバイルトレーナー", 0

; Unselected original slot at 1A:46E4; its English label is in the same-bank tail.
	db "モバイルホームページ", 0

Data_MobileDict_Cat08Count:: ; 1A:46F9
	db 1
Table_MobileDict_Cat08Strings:: ; 1A:46FA
	dw String_MobileDict_Cat08Entry00

String_MobileDict_Cat08Entry00:: ; 1A:46FC
	db "Ｕｓｅｒ", 0

Data_MobileDict_Cat09Count:: ; 1A:4705
	db 2
Table_MobileDict_Cat09Strings:: ; 1A:4706
	dw String_MobileDict_Cat09Entry00
	dw String_MobileDict_Cat09Entry01

; Unselected original slot at 1A:470A; its English label is in the same-bank tail.
	db "リンク", 0

; Unselected original slot at 1A:4711; its English label is in the same-bank tail.
	db "ログインＩＤ", 0

Data_MobileDict_Cat10Count:: ; 1A:471E
	db 1
Table_MobileDict_Cat10Strings:: ; 1A:471F
	dw String_MobileDict_Cat10Entry00

; Unselected original slot at 1A:4721; its English label is in the same-bank tail.
	db "ワールドワイドウェブ", 0

Data_MobileDict_Cat11Count:: ; 1A:4736
	db 10
Table_MobileDict_Cat11Strings:: ; 1A:4737
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

String_MobileDict_Cat11Entry00:: ; 1A:474B
	db "ｃｄｍａＯｎｅ", 0

String_MobileDict_Cat11Entry01:: ; 1A:475A
	db "ＤＩＯＮ", 0

; Unselected original slot at 1A:4763; its English label is in the same-bank tail.
	db "ＤＩＯＮモバイルＧＢコース", 0

String_MobileDict_Cat11Entry03:: ; 1A:477E
	db "ＩＳＰ", 0

String_MobileDict_Cat11Entry04:: ; 1A:4785
	db "ＰＤＣ", 0

String_MobileDict_Cat11Entry05:: ; 1A:478C
	db "ＰＨＳ", 0

String_MobileDict_Cat11Entry06:: ; 1A:4793
	db "Ｗｅｂ", 0

String_MobileDict_Cat11Entry07:: ; 1A:479A
	db "ＷＷＷ", 0

String_MobileDict_Cat11Entry08:: ; 1A:47A1
	db "＠", 0

; Unselected original slot at 1A:47A4; its English label is in the same-bank tail.
	db "きごうのよみかた", 0

POPC
