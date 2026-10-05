; engine/account/action_confirm.asm
; bank 68, $6E1A-$7019 (511 bytes); pinned by layout.link
; action confirm page

SECTION "engine/account/action_confirm", ROMX

Account_ActionConfirmPage:: ; 68:6E1A
Function_68_6E1A::
	; [CONFIRMED] 147 insn(s); 147 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wActionConfirmPage_Variant], a
	call Account_ActionConfirmPage_Setup
	farcall Palette_FadeInFromWhite
	call Account_ActionConfirmPage_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wActionConfirmPage_Result]
	ret

Account_ActionConfirmPage_Setup:: ; 68:6E39
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wActionConfirmPage_Result], a
	ld a, $00
	ld [wActionConfirmPage_Cursor], a
	ld de, $9001
	ld hl, Gfx_Account_ActionConfirmPage_Tiles9000Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Account_ActionConfirmPage_Tiles9400Vb1
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, $5F
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, $72C0
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld a, [wActionConfirmPage_Variant]
	or a, a
	jr z, .l6EC3
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_Account_ActionConfirmPage
	ld a, $5E
	farcall Tilemap_CopyRectAndAttr
	jr .l6ED4
.l6EC3 ; 68:6EC3
	ld bc, $1214
	ld de, $D000
	ld hl, $7300
	ld a, $5E
	farcall Tilemap_CopyRectAndAttr
.l6ED4 ; 68:6ED4
	call Account_ActionConfirmPage_PrintMessage
	call Account_ActionConfirmPage_UploadTextTiles
	call Account_ActionConfirmPage_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, $4A
	ld b, $81
	farcall Sprite_InitSlot
	call Account_ActionConfirmPage_UpdateCursor
	ret

Account_ActionConfirmPage_InputLoop:: ; 68:6EF6
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l6F19
	bit 1, a
	jr nz, .l6F40
	bit 5, a
	jr nz, .l6F5E
	bit 4, a
	jr nz, .l6F5E
	jr Account_ActionConfirmPage_InputLoop
.l6F19 ; 68:6F19
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wActionConfirmPage_Cursor]
	or a, a
	jr nz, .l6F35
	ld a, $01
	ld [wActionConfirmPage_Result], a
	ret
.l6F35 ; 68:6F35
	ld a, $02
	ld [wActionConfirmPage_Result], a
	ld a, $01
	ld [wActionConfirmPage_NoFlag], a
	ret
.l6F40 ; 68:6F40
	ld a, [wActionConfirmPage_Variant]
	or a, a
	jr z, Account_ActionConfirmPage_InputLoop
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wActionConfirmPage_Result], a
	ld [wActionConfirmPage_NoFlag], a
	ret
.l6F5E ; 68:6F5E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wActionConfirmPage_Cursor]
	ld b, $01
	xor a, b
	ld [wActionConfirmPage_Cursor], a
	call Account_ActionConfirmPage_UpdateCursor
	jr .l6F7C
.l6F7C ; 68:6F7C
	jp Account_ActionConfirmPage_InputLoop

Account_ActionConfirmPage_UpdateCursor:: ; 68:6F7F
	ld a, [wActionConfirmPage_Cursor]
	add a, a
	ld hl, Account_ActionConfirmCursorPositions
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

; ---- data $6F97-$6F9B (4 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Account_ActionConfirmCursorPositions:: ; 68:6F97
Data_68_6F97::
	db $28, $30, $58, $30

Account_ActionConfirmPage_BuildTextMap:: ; 68:6F9B
Function_68_6F9B::
	; [CONFIRMED] 46 insn(s); 46 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $D121
	ld de, $0000
	ld bc, $0612
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_ActionConfirmPage_PrintMessage:: ; 68:6FAB
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $48
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
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $C8
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wActionConfirmPage_Variant]
	ld hl, Account_ActionMessageIds
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	farcall PromptText_Load
	call TextEngine_Run
	ret

; ---- data $7005-$7009 (4 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Account_ActionMessageIds:: ; 68:7005
Data_68_7005::
	db $04, $0B, $0C, $0D

Account_ActionConfirmPage_UploadTextTiles:: ; 68:7009
Function_68_7009::
	; [CONFIRMED] 47 insn(s); 47 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $7009-$7079)
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret
