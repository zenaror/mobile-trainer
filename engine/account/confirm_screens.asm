; engine/account/confirm_screens.asm
; bank 68, $61F7-$67E0 (1513 bytes); pinned by layout.link
; account confirm screens (automatic and manual) with default dial number strings

SECTION "engine/account/confirm_screens", ROMX

Account_ConfirmScreen:: ; 68:61F7
	; [CONFIRMED] 284 insn(s); 284 executed (in up to 7/18 scenarios) (part of region $6022-$6308)
	call Account_ConfirmScreen_Setup
	farcall Palette_FadeInFromWhite
	call Account_ConfirmScreen_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wAccountConfirm_Result]
	ret

Account_ConfirmScreen_Setup:: ; 68:6213
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wAccountConfirm_Result], a
	ld a, $00
	ld [wAccountConfirm_Cursor], a
	ld de, $8801
	ld hl, Gfx_Account_ConfirmScreens_Tiles8800Vb1
	ld a, BANK(Gfx_Account_ConfirmScreens_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Account_ConfirmScreens_Tiles8C00Vb1
	ld a, BANK(Gfx_Account_ConfirmScreens_Tiles8C00Vb1)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Account_ConfirmScreen_Tiles9000Vb1
	ld a, BANK(Gfx_Account_ConfirmScreen_Tiles9000Vb1)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, BANK(Data_5F_49D0)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_Account_ConfirmScreen_Bg
	ld a, BANK(Palette_Account_ConfirmScreen_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, Palette_5F_4CD0 + $10 ; 5F:4CE0
	ld a, BANK(Palette_5F_4CD0)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Account_ConfirmScreen
	ld a, BANK(Tilemap_Account_ConfirmScreen)
	farcall Tilemap_CopyRectAndAttr
	call Account_ConfirmScreen_PrintAccount
	call Account_ConfirmScreen_UploadTextTiles
	call Account_ConfirmScreen_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, BANK(ConfirmPages_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call Account_ConfirmScreen_UpdateCursor
	ret

Account_ConfirmScreen_InputLoop:: ; 68:62C9
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l62EC
	bit PADB_B, a
	jr nz, .l630E
	bit PADB_LEFT, a
	jr nz, .l6323
	bit PADB_RIGHT, a
	jr nz, .l6323
	jr Account_ConfirmScreen_InputLoop
.l62EC ; 68:62EC
	play_sfx SFX_CONFIRM
	ld a, [wAccountConfirm_Cursor]
	or a, a
	jr nz, .l6308
	ld a, $01
	ld [wAccountConfirm_Result], a
	ret

.l6308 ; 68:6308
	; [PROBABLE] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 1;
	; entered by jrcc from 68:6300 (executed)
	ld a, $02
	ld [wAccountConfirm_Result], a
	ret
.l630E ; 68:630E
	play_sfx SFX_CANCEL
	xor a, a
	ld [wAccountConfirm_Result], a
	ret
.l6323 ; 68:6323
	play_sfx SFX_CURSOR_MOVE
	ld a, [wAccountConfirm_Cursor]
	ld b, $01
	xor a, b
	ld [wAccountConfirm_Cursor], a
	call Account_ConfirmScreen_UpdateCursor
	jr .l6341
.l6341 ; 68:6341
	jp Account_ConfirmScreen_InputLoop

Account_ConfirmScreen_UpdateCursor:: ; 68:6344
Function_68_6344::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wAccountConfirm_Cursor]
	add a, a
	ld hl, Account_ConfirmCursorPositions
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

; ---- words $635C-$6360 (4 bytes) [PROBABLE] 2 words $6828,$6858 (configuration record addresses) read as ld a,[hli]/ld e,a/ld d,[hl] with base $635C by the code at 6344-635C (index [$C27D]*2); extent bounded by the code at 6360

Account_ConfirmCursorPositions:: ; 68:635C
Table_68_635C::
	dw $6828, $6858

Account_ConfirmScreen_BuildTextMap:: ; 68:6360
Function_68_6360::
	; [CONFIRMED] 85 insn(s); 85 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wScreenTileMap + $A6
	ld de, $0000
	ld bc, $0208
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $121
	ld de, $0010
	ld bc, $0212
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_ConfirmScreen_PrintAccount:: ; 68:637F
	ld de, $FFFF
	ld hl, $0506
	ld bc, $0208
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $2B
	ldh [hTextY], a
	ld a, $30
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $28
	ldh [hRam_FFC0], a
	ld a, $30
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $38
	ldh [hTextBox_MaxLineY], a
	ld a, $70
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctLoginId
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0212
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $4B
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $58
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctMailAddress
	call TextEngine_Run
	ret

Account_ConfirmScreen_UploadTextTiles:: ; 68:6416
	ld de, $9000
	ld hl, $0506
	ld bc, $0208
	farcall TileCanvas_UploadRect
	ld de, $9100
	ld hl, $0901
	ld bc, $0212
	farcall TileCanvas_UploadRect
	ret

Account_ConfirmManualScreen:: ; 68:6435
	; [CONFIRMED] 137 insn(s) reached by static flow only; seeds: exec x137; min discovery hops 5;
	; entered by far from 65:462C (PROBABLE code) [executed in 1 scenarios]
	call Account_ConfirmManualScreen_Setup
	farcall Palette_FadeInFromWhite
	call Account_ConfirmManualScreen_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wAccountConfirm_Result]
	ret

Account_ConfirmManualScreen_Setup:: ; 68:6451
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wAccountConfirm_Result], a
	ld a, $00
	ld [wAccountConfirm_Cursor], a
	ld de, $8801
	ld hl, Gfx_Account_ConfirmScreens_Tiles8800Vb1
	ld a, BANK(Gfx_Account_ConfirmScreens_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Account_ConfirmScreens_Tiles8C00Vb1
	ld a, BANK(Gfx_Account_ConfirmScreens_Tiles8C00Vb1)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Account_ConfirmManualScreen_Tiles9000Vb1
	ld a, BANK(Gfx_Account_ConfirmManualScreen_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, BANK(Data_5F_49D0)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_Account_ConfirmManualScreen_Bg
	ld a, BANK(Palette_Account_ConfirmManualScreen_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, Palette_5F_4CD0 + $10 ; 5F:4CE0
	ld a, BANK(Palette_5F_4CD0)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Account_ConfirmManualScreen
	ld a, BANK(Tilemap_Account_ConfirmManualScreen)
	farcall Tilemap_CopyRectAndAttr
	call Account_ConfirmManualScreen_PrintAccount
	call Account_ConfirmManualScreen_UploadTextTiles
	call Account_ConfirmManualScreen_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, BANK(ConfirmPages_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call Account_ConfirmManualScreen_UpdateCursor
	ret

Account_ConfirmManualScreen_InputLoop:: ; 68:6507
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l652A
	bit PADB_B, a
	jr nz, .l654C
	bit PADB_LEFT, a
	jr nz, .l6561
	bit PADB_RIGHT, a
	jr nz, .l6561
	jr Account_ConfirmManualScreen_InputLoop
.l652A ; 68:652A
	play_sfx SFX_CONFIRM
	ld a, [wAccountConfirm_Cursor]
	or a, a
	jr nz, .l6546
	ld a, $01
	ld [wAccountConfirm_Result], a
	ret
.l6546 ; 68:6546
	ld a, $02
	ld [wAccountConfirm_Result], a
	ret
.l654C ; 68:654C
	play_sfx SFX_CANCEL
	xor a, a
	ld [wAccountConfirm_Result], a
	ret
.l6561 ; 68:6561
	play_sfx SFX_CURSOR_MOVE
	ld a, [wAccountConfirm_Cursor]
	ld b, $01
	xor a, b
	ld [wAccountConfirm_Cursor], a
	call Account_ConfirmManualScreen_UpdateCursor
	jr .l657F
.l657F ; 68:657F
	jp Account_ConfirmManualScreen_InputLoop

Account_ConfirmManualScreen_UpdateCursor:: ; 68:6582
	ld a, [wAccountConfirm_Cursor]
	add a, a
	ld hl, Account_ConfirmManualCursorPositions
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	ret

; ---- words $659A-$659E (4 bytes) [PROBABLE] 2 words $7058,$7080 addressed by ld hl,$659A at 68:6586 (word read + call $0A65); extent bounded by the code at 659E

Account_ConfirmManualCursorPositions:: ; 68:659A
Table_68_659A::
	dw $7058, $7080

Account_ConfirmManualScreen_BuildTextMap:: ; 68:659E
Function_68_659E::
	; [CONFIRMED] 208 insn(s) reached by static flow only; seeds: exec x208; min discovery hops 7;
	; entered by call from 68:64EB (PROBABLE code) [executed in 2 scenarios]
	ld hl, wScreenTileMap + $48
	ld de, $0000
	ld bc, $0208
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $C1
	ld de, $0010
	ld bc, $0212
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $107
	ld de, $0040
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $147
	ld de, $0060
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $186
	ld de, $0080
	ld bc, $020D
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_ConfirmManualScreen_PrintAccount:: ; 68:65EA
	ld de, $FFFF
	ld hl, $0208
	ld bc, $0208
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $13
	ldh [hTextY], a
	ld a, $40
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $10
	ldh [hRam_FFC0], a
	ld a, $40
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $20
	ldh [hTextBox_MaxLineY], a
	ld a, $80
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctLoginId
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0601
	ld bc, $0212
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $33
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $30
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $40
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctMailAddress
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0807
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $43
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $40
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $50
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctNumberInternet
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0A07
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $53
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $50
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $60
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctNumberSelfPage
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0C06
	ld bc, $020D
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $63
	ldh [hTextY], a
	ld a, $30
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $68
	ldh [hRam_FFC0], a
	ld a, $30
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $70
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $03
	ld hl, wAcctNumberComment
	call TextEngine_Run
	ret

Account_ConfirmManualScreen_UploadTextTiles:: ; 68:6762
Function_68_6762::
	ld de, $9000
	ld hl, $0208
	ld bc, $0208
	farcall TileCanvas_UploadRect
	ld de, $9100
	ld hl, $0601
	ld bc, $0212
	farcall TileCanvas_UploadRect
	ld de, $9400
	ld hl, $0807
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $9600
	ld hl, $0A07
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0C06
	ld bc, $020D
	farcall TileCanvas_UploadRect
	ret

; ---- words $67AE-$67B6 (8 bytes) [PROBABLE] 4 words $67B6,$67BC,$67C2,$67CD = the four dial-string addresses below (each word points exactly at a NUL-terminated ASCII string)

Dial_DefaultNumberTable:: ; 68:67AE
Table_68_67AE::
	dw Dial_DefaultNumber0, Dial_DefaultNumber1, Dial_DefaultNumber2, Dial_DefaultNumber3

; ---- text $67B6-$67BC (6 bytes) [PROBABLE] ASCII "#9477" NUL (dial string pointed to by the word at 67AE)

PUSHC sjis
Dial_DefaultNumber0:: ; 68:67B6
String_68_67B6::
	db "#9477", 0
POPC

; ---- text $67BC-$67C2 (6 bytes) [PROBABLE] ASCII "#9477" NUL (dial string pointed to by the word at 67B0)

PUSHC sjis
Dial_DefaultNumber1:: ; 68:67BC
String_68_67BC::
	db "#9477", 0
POPC

; ---- text $67C2-$67CD (11 bytes) [PROBABLE] ASCII "0077487752" NUL (dial string pointed to by the word at 67B2)

PUSHC sjis
Dial_DefaultNumber2:: ; 68:67C2
String_68_67C2::
	db "0077487752", 0
POPC

; ---- text $67CD-$67D8 (11 bytes) [PROBABLE] ASCII "0077487752" NUL (dial string pointed to by the word at 67B4)

PUSHC sjis
Dial_DefaultNumber3:: ; 68:67CD
String_68_67CD::
	db "0077487752", 0
POPC

; ---- words $67D8-$67E0 (8 bytes) [PROBABLE] 4 words $67E0,$68A0,$6960,$6A20 = the starts of the four 192-byte "MA" records (each word points exactly at a block that starts with "MA 01 00")

Config_DefaultImageTable:: ; 68:67D8
Table_68_67D8::
	dw Config_DefaultImage0, Config_DefaultImage1, Config_DefaultImage2, Config_DefaultImage3
