; engine/menus/mail_menu.asm
; bank 1D, $4000-$45C1 (1473 bytes); pinned by layout.link
; mail menu (6 plates) code, ticker table, item strings

SECTION "engine/menus/mail_menu", ROMX

MailMenu_Run:: ; 1D:4000
Function_1D_4000::
	; [CONFIRMED] 145 insn(s); 145 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	call VBlank_WaitAndService
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4 ; raw: start of the 252-byte per-screen window wipe
	call FillBytes
	farcall Stub_Nop_48_48BB
	call VBlank_WaitAndService
	ld a, $01
	ld hl, sMailMenuCursor
	call ReadByteFar
	or a, a
	jr nz, .skip
	ld a, $01
.skip ; 1D:4023
	ld [wMailMenu_Cursor], a
	ld a, $01
	ld [wMailMenu_AnimCounter], a
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
	ld hl, Gfx_MailMenu_Tiles0
	ld a, BANK(Gfx_MailMenu_Tiles0)
	ld b, $96
	ld c, $19
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, Gfx_MailMenu_Tiles1
	ld a, BANK(Gfx_MailMenu_Tiles1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, Gfx_MailMenu_Tiles2
	ld a, BANK(Gfx_MailMenu_Tiles2)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, Gfx_MailMenu_Tiles3
	ld a, BANK(Gfx_MailMenu_Tiles3)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, $5A30
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_MailMenu_Tiles5
	ld a, BANK(Gfx_MailMenu_Tiles5)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailMenu_Bg
	ld a, BANK(Palette_MailMenu_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailMenu_Screen
	ld a, BANK(Tilemap_MailMenu_Screen)
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, Table_MailMenu_Objects
	ld a, BANK(Table_MailMenu_Objects)
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $431A
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailMenu_Obj
	ld a, BANK(Palette_MailMenu_Obj)
	farcall Palette_LoadToBuffer
	ld a, $40
	ld bc, $0220
	ld de, $8000
	ld hl, wScreenTileMap + $200
	farcall Tilemap_FillRectSequential
	call VBlank_WaitAndService
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $02
	ld [wMailMenu_NormalItem], a
	call MailMenu_DrawItemNormal
	ld a, $01
	ld [wMailMenu_NormalItem], a
	call MailMenu_DrawItemSelected
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ld a, [wMailMenu_Cursor]
	dec a
	cp a, $01
	call z, MailMenu_GetLabelIndexA
	ld b, a
	ld hl, Data_MailMenu_StringIndexBank
	ld a, $1D
	farcall Ticker_Start
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0003
	call Sound_PlayMusic
	pop af
	ldh [rSVBK], a

MailMenu_Loop:: ; 1D:4188
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41A0-$41AA (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 1D:419D: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Table_MailMenu_Buttons:: ; 1D:41A0
Table_1D_41A0::
	dw MailMenu_OnA
	dw MailMenu_OnB
	dw MailMenu_Ignore
	dw MailMenu_Ignore
	dw MailMenu_Idle

MailMenu_Idle:: ; 1D:41AA
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 9/18 scenarios)
	farcall Ticker_Update
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DPAD
	call nz, MailMenu_HandleDpad
	call MailMenu_AnimateIcon
	jp MailMenu_Loop

MailMenu_OnA:: ; 1D:41BD
	play_sfx SFX_CONFIRM
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wMailMenu_Cursor]
	ld b, a
	ld a, $01
	ld hl, sMailMenuCursor
	farcall WriteByteFar
	ld a, [wMailMenu_Cursor]
	ret

MailMenu_OnB:: ; 1D:41EC
	play_sfx SFX_CANCEL
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld b, $00
	ld a, $01
	ld hl, sMailMenuCursor
	farcall WriteByteFar
	xor a, a
	ret

MailMenu_Ignore:: ; 1D:4217
	jp MailMenu_Loop

MailMenu_GetLabelIndexA:: ; 1D:421A
	ld a, $00
	ld hl, sMailDraft_ToAddress
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $06
	ret

MailMenu_HandleDpad:: ; 1D:4229
	bit 6, a
	jr nz, .l4232
	bit 7, a
	jr nz, .l4256
	ret
.l4232 ; 1D:4232
	ld a, [wMailMenu_Cursor]
	ld [wMailMenu_NormalItem], a
	dec a
	jr nz, .l423D

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1D:4239 (executed) [executed in 5 scenarios]
	ld a, $06

.l423D ; 1D:423D
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 7/18 scenarios)
	ld [wMailMenu_Cursor], a
	call MailMenu_DrawItemNormal
	call MailMenu_DrawItemSelected
	farcall Sprite_UpdateAll
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call MailMenu_AnimateIcon
	jr MailMenu_AfterMove
.l4256 ; 1D:4256
	ld a, [wMailMenu_Cursor]
	ld [wMailMenu_NormalItem], a
	inc a
	cp a, $07
	jr nz, .l4263

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1D:425F (executed) [executed in 5 scenarios]
	ld a, $01

.l4263 ; 1D:4263
	; [CONFIRMED] 89 insn(s); 89 executed (in up to 9/18 scenarios)
	ld [wMailMenu_Cursor], a
	call MailMenu_DrawItemNormal
	call MailMenu_DrawItemSelected
	farcall Sprite_UpdateAll
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call MailMenu_AnimateIcon

MailMenu_AfterMove:: ; 1D:427A
	play_sfx SFX_CURSOR_MOVE
	ld a, [wMailMenu_Cursor]
	dec a
	cp a, $01
	call z, MailMenu_GetLabelIndexB
	ld b, a
	ld hl, Data_MailMenu_StringIndexBank
	ld a, $1D
	farcall Ticker_Start
	ret

MailMenu_GetLabelIndexB:: ; 1D:42A0
	ld a, $00
	ld hl, sMailDraft_ToAddress
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $06
	ret

MailMenu_DrawItemNormal:: ; 1D:42AF
	ld a, [wMailMenu_NormalItem]
	dec a
	cp a, $01
	call z, MailMenu_GetPlateIndexA
	ld b, $03
	ld c, a
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, Table_MailMenu_PlateBufferOffsets
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, wScreenTileMap
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, Data_MailMenu_PlateOffsets
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4891
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $F0
	add a, l
	ld [wMailMenu_AttrSrcLo], a
	ld a, h
	adc a, $00
	ld [wMailMenu_AttrSrcHi], a
	ld c, $0A
	ld a, $1D
	call Tilemap_CopyRectAndAttrPtr
	ret

MailMenu_GetPlateIndexA:: ; 1D:42FE
	ld a, $00
	ld hl, sMailDraft_ToAddress
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $07
	ret

; ---- words $430D-$431D (16 bytes) [PROBABLE] 8 words: first 6 = WRAM tile-buffer offsets ($09,$69,$A9,$109,$149,$1A9 = row*32+9 for rows 0,3,5,8,10,13) that the code adds to $D000 (ld hl,$430D at 1D:42C1, index*2, ld hl,[hl]); words 7-8 ($0000,$0069) not exercised; the never-read gap bytes are folded in

Table_MailMenu_PlateBufferOffsets:: ; 1D:430D
Table_1D_430D::
	dw $0009, $0069, $00A9, $0109, $0149, $01A9, $0000, $0069

; ---- data $431D-$4325 (8 bytes) [PROBABLE] byte table indexed by c (00 28 46 6e 8c b4 00 d2), read via 'ld hl,$431D' at 1D:42D6 (executed reads)

Data_MailMenu_PlateOffsets:: ; 1D:431D
Data_1D_431D::
	db $00, $28, $46, $6E, $8C, $B4, $00, $D2

MailMenu_DrawItemSelected:: ; 1D:4325
Function_1D_4325::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wMailMenu_Cursor]
	dec a
	cp a, $01
	call z, MailMenu_GetPlateIndexB
	ld b, $03
	ld c, a
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, Table_MailMenu_SelectedBufferOffsets
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, wScreenTileMap
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, Data_MailMenu_SelectedPlateOffsets
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4A71
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $F0
	add a, l
	ld [wMailMenu_AttrSrcLo], a
	ld a, h
	adc a, $00
	ld [wMailMenu_AttrSrcHi], a
	ld c, $0A
	ld a, $1D
	call Tilemap_CopyRectAndAttrPtr
	ret

MailMenu_GetPlateIndexB:: ; 1D:4374
	ld a, $00
	ld hl, sMailDraft_ToAddress
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $07
	ret

; ---- words $4383-$4393 (16 bytes) [PROBABLE] 8 words: first 6 = WRAM tile-buffer offsets ($09,$69,$A9,$109,$149,$1A9 = row*32+9 for rows 0,3,5,8,10,13) that the code adds to $D000 (ld hl,$4383 at 1D:4337, index*2, ld hl,[hl]); words 7-8 ($0000,$0069) not exercised; the never-read gap bytes are folded in

Table_MailMenu_SelectedBufferOffsets:: ; 1D:4383
Table_1D_4383::
	dw $0009, $0069, $00A9, $0109, $0149, $01A9, $0000, $0069

; ---- data $4393-$439B (8 bytes) [PROBABLE] byte table indexed by c (00 28 46 6e 8c b4 00 d2), read via 'ld hl,$4393' at 1D:434C (executed reads)

Data_MailMenu_SelectedPlateOffsets:: ; 1D:4393
Data_1D_4393::
	db $00, $28, $46, $6E, $8C, $B4, $00, $D2

MailMenu_AnimateIcon:: ; 1D:439B
Function_1D_439B::
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wMailMenu_AnimCounter
	dec [hl]
	ret nz
	ld [hl], $1E
	ld a, [wMailMenu_AnimFrame]
	xor a, $01
	ld [wMailMenu_AnimFrame], a
	jr nz, .l43D3
	ld a, $B1
	ld [wMailMenu_AttrSrcLo], a
	ld a, $4C
	ld [wMailMenu_AttrSrcHi], a
	ld bc, $0608
	ld de, wScreenTileMap + $C1
	ld hl, Tilemap_MailMenu_IconFrames
	ld a, BANK(Tilemap_MailMenu_IconFrames)
	farcall Tilemap_CopyRectAndAttrPtr
	farcall Sprite_UpdateAll
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret
.l43D3 ; 1D:43D3
	ld a, $E1
	ld [wMailMenu_AttrSrcLo], a
	ld a, $4C
	ld [wMailMenu_AttrSrcHi], a
	ld bc, $0608
	ld de, wScreenTileMap + $C1
	ld hl, $4C81
	ld a, $1D
	farcall Tilemap_CopyRectAndAttrPtr
	farcall Sprite_UpdateAll
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

; ---- data $43FA-$43FB (1 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 43FA-4945 by higher-priority evidence]

Data_MailMenu_StringIndexBank:: ; 1D:43FA
Data_1D_43FA::
	db $1D

; ---- ptrtable $43FB-$4413 (24 bytes) [PROBABLE] little-endian word table, 14 entries, monotone=1.00, 93% of targets on string start/after NUL, targets $4417..$4592 [clipped from 43FB-4417 by higher-priority proposals]

Table_MailMenu_Strings:: ; 1D:43FB
Table_1D_43FB::
	dw String_MailMenu_Items
	dw String_MailMenu_Text0
	dw String_MailMenu_Title1
	dw String_MailMenu_Text1
	dw String_MailMenu_Title2
	dw String_MailMenu_Text2
	dw String_MailMenu_Title3
	dw String_MailMenu_Text3
	dw String_MailMenu_Title4
	dw String_MailMenu_Text4
	dw String_MailMenu_Title5
	dw String_MailMenu_Text5

; ---- text $4413-$45C1 (430 bytes) [PROBABLE] text: 14 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
Table_MailMenu_StringsTail:: ; 1D:4413
String_1D_4413::
	db "・脱"

String_MailMenu_Items:: ; 1D:4417
	db "おくる／うけとる", 0
String_MailMenu_Text0:: ; 1D:4428
String_1D_4428::
	db "インターネットをつかって　メールのそうしんとじゅしんができます", 0
String_MailMenu_Title1:: ; 1D:4467
String_1D_4467::
	db "メールをかく", 0
String_MailMenu_Text1:: ; 1D:4474
String_1D_4474::
	db "あたらしく　メールをかきます", 0
String_MailMenu_Title2:: ; 1D:4491
String_1D_4491::
	db "メールボックス", 0
String_MailMenu_Text2:: ; 1D:44A0
String_1D_44A0::
	db "もらったメールを　みることができます", 0
String_MailMenu_Title3:: ; 1D:44C5
String_1D_44C5::
	db "アドレスちょう", 0
String_MailMenu_Text3:: ; 1D:44D4
String_1D_44D4::
	db "アドレスちょうに　アドレスを　かきこみます", 0
String_MailMenu_Title4:: ; 1D:44FF
String_1D_44FF::
	db "プロフィール", 0
String_MailMenu_Text4:: ; 1D:450C
String_1D_450C::
	db "じぶんのアドレスをみたり　ニックネームをかえることができます", 0
String_MailMenu_Title5:: ; 1D:4549
String_1D_4549::
	db "メールサーバ", 0
String_MailMenu_Text5:: ; 1D:4556
String_1D_4556::
	db "メールサーバにあるメールを　せいりできます", 0
	db "メールをかくにん", 0
	db "かいたメールの　かくにんとしゅうせいができます", 0
POPC
