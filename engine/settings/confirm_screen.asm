; engine/settings/confirm_screen.asm
; bank 67, $510A-$53DC (722 bytes); pinned by layout.link
; phone settings confirm screen

SECTION "engine/settings/confirm_screen", ROMX

SettingsPhone_ConfirmScreen:: ; 67:510A
	; [CONFIRMED] 139 insn(s) reached by static flow only; seeds: exec x139; min discovery hops 5;
	; entered by far from 67:40B9 (PROBABLE code) | 95 insn(s) executed; cut out of the PROBABLE
	; region 510A-5275 by apply_coverage --split [executed in 1 scenarios]
	ld [wConfirmScreen_Slot], a
	call SettingsPhone_ConfirmScreen_Setup
	farcall Palette_FadeInFromWhite
	call SettingsPhone_ConfirmScreen_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wConfirmScreen_Result]
	ret

SettingsPhone_ConfirmScreen_Setup:: ; 67:5129
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wConfirmScreen_Result], a
	ld a, $00
	ld [wConfirmScreen_Cursor], a
	ld de, $8801
	ld hl, Gfx_SettingsPhone_ConfirmScreen_Tiles8800Vb1
	ld a, $4B
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsPhone_ConfirmScreen_Tiles8C00Vb1
	ld a, $4B
	ld b, $95
	ld c, $22
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, $7090
	ld a, $4B
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
	ld hl, $73B0
	ld a, $4B
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, $73F0
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	call SettingsPhone_ConfirmScreen_LoadSlotTilemap
	call SettingsPhone_ConfirmScreen_PrintFields
	call SettingsPhone_ConfirmScreen_UploadTextTiles
	call SettingsPhone_ConfirmScreen_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, ConfirmPages_ObjTable
	ld a, $4A
	ld b, $81
	farcall Sprite_InitSlot
	call SettingsPhone_ConfirmScreen_PlaceCursor
	ret

SettingsPhone_ConfirmScreen_Loop:: ; 67:51E2
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l5205
	bit 1, a
	jr nz, .l5227
	bit 5, a
	jr nz, .l523C
	bit 4, a
	jr nz, .l523C
	jr SettingsPhone_ConfirmScreen_Loop
.l5205 ; 67:5205
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wConfirmScreen_Cursor]
	or a, a
	jr nz, .l5221
	ld a, $01
	ld [wConfirmScreen_Result], a
	ret

.l5221 ; 67:5221
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region
	; 510A-5275 by apply_coverage --split [executed in 1 scenarios]
	ld a, $02
	ld [wConfirmScreen_Result], a
	ret
.l5227 ; 67:5227
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wConfirmScreen_Result], a
	ret
.l523C ; 67:523C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wConfirmScreen_Cursor]
	ld b, $01
	xor a, b
	ld [wConfirmScreen_Cursor], a
	call SettingsPhone_ConfirmScreen_PlaceCursor
	jr .l525A
.l525A ; 67:525A
	jp SettingsPhone_ConfirmScreen_Loop

SettingsPhone_ConfirmScreen_PlaceCursor:: ; 67:525D
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 510A-5275 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wConfirmScreen_Cursor]
	add a, a
	ld hl, SettingsPhone_ConfirmScreen_CursorPos
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

; ---- data $5275-$5279 (4 bytes) [PROBABLE] 2 entries x 2 bytes (28 68 / 58 68), indexed by [$C27D]*2 (ld hl,$5275 at 67:5261), stored into sprite slot $DA00 by call $0A65 (coordinates)

SettingsPhone_ConfirmScreen_CursorPos:: ; 67:5275
Data_67_5275::
	db $28, $68, $58, $68

SettingsPhone_ConfirmScreen_BuildTextMap:: ; 67:5279
	; [CONFIRMED] 142 insn(s) reached by static flow only; seeds: exec x142; min discovery hops 7;
	; entered by call from 67:51C6 (PROBABLE code) [executed in 1 scenarios]
	ld hl, $D0A7
	ld de, $0000
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D0E7
	ld de, $0020
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D126
	ld de, $0040
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ret

SettingsPhone_ConfirmScreen_PrintFields:: ; 67:52A7
	ld de, $FFFF
	ld hl, $0507
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $2A
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $28
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $38
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
	ld hl, $DEDD
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0707
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $3A
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $38
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $48
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
	ld hl, $DEEE
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0906
	ld bc, $020D
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $4A
	ldh [hTextY], a
	ld a, $30
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $30
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
	ld hl, $DEFF
	call TextEngine_Run
	ret

SettingsPhone_ConfirmScreen_UploadTextTiles:: ; 67:5389
	ld de, $9000
	ld hl, $0507
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $9200
	ld hl, $0707
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $9400
	ld hl, $0906
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ret

SettingsPhone_ConfirmScreen_LoadSlotTilemap:: ; 67:53B7
	ld a, [wConfirmScreen_Slot]
	ld hl, SettingsPhone_ConfirmScreen_SlotTilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0201
	ld de, $D066
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	ret

; ---- words $53D6-$53DC (6 bytes) [PROBABLE] 3 words $76C0,$76C4,$76C8 indexed by (ld hl,$53D6 at 67:53BA); hl=[table], ld a,$4B, far call 00:08EA (tilemap loader) at 67:53CD-53D1: source addresses in bank 4B (dw kept numeric)

SettingsPhone_ConfirmScreen_SlotTilemapTable:: ; 67:53D6
Table_67_53D6::
	dw $76C0, $76C4, $76C8
