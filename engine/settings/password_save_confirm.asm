; engine/settings/password_save_confirm.asm
; bank 67, $6536-$6731 (507 bytes); pinned by layout.link
; password save confirm screen

SECTION "engine/settings/password_save_confirm", ROMX

PwSaveConfirm_Run:: ; 67:6536
	; [CONFIRMED] 114 insn(s); 114 executed (in up to 18/18 scenarios) (part of region $64B4-$65F2)
	ld [wPwSaveConfirm_Variant], a
	call PwSaveConfirm_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0009
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	call PwSaveConfirm_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wPwSaveConfirm_Result]
	ret

PwSaveConfirm_Setup:: ; 67:6565
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wPwSaveConfirm_Result], a
	ld a, [wSavePasswordFlag]
	xor a, $01
	ld [wPwSaveConfirm_Cursor], a
	ld de, $9001
	ld hl, Gfx_PwSaveConfirm_Tiles9000Vb1
	ld a, BANK(Gfx_PwSaveConfirm_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_PwSaveConfirm_Tiles9400Vb1
	ld a, BANK(Gfx_PwSaveConfirm_Tiles9400Vb1)
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
	ld hl, Palette_PwSaveConfirm_Bg
	ld a, BANK(Palette_PwSaveConfirm_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, Palette_5F_4CD0 + $10 ; 5F:4CE0
	ld a, BANK(Palette_5F_4CD0)
	farcall Palette_LoadToBuffer
	ld a, [wPwSaveConfirm_Variant]
	or a, a
	jr nz, .l65F2
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_PwSaveConfirm_5D_7BA0
	ld a, BANK(Tilemap_PwSaveConfirm_5D_7BA0)
	farcall Tilemap_CopyRectAndAttr
	jr .l6603

.l65F2 ; 67:65F2
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 67:65DD (executed)
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_PwSaveConfirm_71_6F6F
	ld a, BANK(Tilemap_PwSaveConfirm_71_6F6F)
	farcall Tilemap_CopyRectAndAttr

.l6603 ; 67:6603
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 2/18 scenarios)
	call PwSaveConfirm_PrintPrompt
	call PwSaveConfirm_UploadTextTiles
	call PwSaveConfirm_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, BANK(ConfirmPages_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call PwSaveConfirm_PlaceCursor
	ret

PwSaveConfirm_Loop:: ; 67:6625
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l6648
	bit PADB_B, a
	jr nz, .l666A
	bit PADB_LEFT, a
	jr nz, .l6685
	bit PADB_RIGHT, a
	jr nz, .l6685
	jr PwSaveConfirm_Loop
.l6648 ; 67:6648
	play_sfx SFX_CONFIRM
	ld a, [wPwSaveConfirm_Cursor]
	or a, a
	jr nz, .l6664
	ld a, $01
	ld [wPwSaveConfirm_Result], a
	ret

.l6664 ; 67:6664
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jrcc from 67:665C (executed)
	ld a, $02
	ld [wPwSaveConfirm_Result], a
	ret
.l666A ; 67:666A
	ld a, [wPwSaveConfirm_Variant]
	or a, a
	jr nz, PwSaveConfirm_Loop
	play_sfx SFX_CANCEL
	xor a, a
	ld [wPwSaveConfirm_Result], a
	ret
.l6685 ; 67:6685
	play_sfx SFX_CURSOR_MOVE
	ld a, [wPwSaveConfirm_Cursor]
	ld b, $01
	xor a, b
	ld [wPwSaveConfirm_Cursor], a
	call PwSaveConfirm_PlaceCursor
	jr .l66A3
.l66A3 ; 67:66A3
	jp PwSaveConfirm_Loop

PwSaveConfirm_PlaceCursor:: ; 67:66A6
Function_67_66A6::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wPwSaveConfirm_Cursor]
	add a, a
	ld hl, PwSaveConfirm_CursorPos
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

; ---- data $66BE-$66C2 (4 bytes) [PROBABLE] 2 entries x 2 bytes (28 30 / 58 30), coordinate pairs read by the executed code before it (e=[hl], d=[hl+1] ; call $0A65 sprite-slot init at 67:66A6...); replaces a CONFIRMED read fragment + 2 unread bytes

PwSaveConfirm_CursorPos:: ; 67:66BE
Data_67_66BE::
	db $28, $30, $58, $30

PwSaveConfirm_BuildTextMap:: ; 67:66C2
Function_67_66C2::
	; [CONFIRMED] 166 insn(s); 166 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $66C2-$67DB)
	ld hl, wScreenTileMap + $121
	ld de, $0000
	ld bc, $0612
	farcall Tilemap_FillAscendingWithAttr
	ret

PwSaveConfirm_PrintPrompt:: ; 67:66D2
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
	ld a, $13
	farcall PromptText_Load
	call TextEngine_Run
	ret

PwSaveConfirm_UploadTextTiles:: ; 67:6721
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret
