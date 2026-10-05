; engine/settings/choice_menu.asm
; bank 67, $4631-$4924 (755 bytes); pinned by layout.link
; phone-settings choice menu

SECTION "engine/settings/choice_menu", ROMX

SettingsPhone_ChoiceMenu:: ; 67:4631
	; [CONFIRMED] 275 insn(s) executed; cut out of the PROBABLE region 4593-486D by apply_coverage
	; --split [executed in 1 scenarios] (part of region $45AB-$486D)
	ld [wChoiceMenu_Variant], a
	call SettingsPhone_ChoiceMenu_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0009
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	call SettingsPhone_ChoiceMenu_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wChoiceMenu_Variant]
	or a, a
	jr nz, .l4678
	ld a, [wChoiceMenu_Cursor]
	ld [sPhoneTopMenuCursor], a
	jr .l467E
.l4678 ; 67:4678
	ld a, [wChoiceMenu_Cursor]
	ld [sPhoneMethodMenuCursor], a
.l467E ; 67:467E
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wChoiceMenu_Result]
	ret

SettingsPhone_ChoiceMenu_Setup:: ; 67:4688
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wChoiceMenu_Result], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wChoiceMenu_Variant]
	or a, a
	jr nz, .l46B5
	ld a, [sPhoneTopMenuCursor]
	jr .l46B8
.l46B5 ; 67:46B5
	ld a, [sPhoneMethodMenuCursor]
.l46B8 ; 67:46B8
	ld b, a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [wChoiceMenu_Cursor], a
	ld a, [wChoiceMenu_Variant]
	or a, a
	jr nz, .l4724
	ld de, $8801
	ld hl, $4110
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_4510
	ld a, $4D
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_4610
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles9400Vb1
	ld a, $4D
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, $D000
	ld hl, $5540
	ld a, $4D
	farcall Tilemap_CopyRectAndAttr
	jr .l477D
.l4724 ; 67:4724
	ld de, $8801
	ld hl, $4C10
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_5010
	ld a, $4D
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_5110
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Data_4D_5510
	ld a, $4D
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_SettingsPhone_ChoiceMenu
	ld a, $4D
	farcall Tilemap_CopyRectAndAttr
.l477D ; 67:477D
	ld de, $8001
	ld hl, Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1
	ld a, $4D
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Data_4D_5510
	ld a, $4D
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, $D840
	ld hl, $5538
	ld a, $4D
	farcall Palette_LoadToBuffer
	call SettingsPhone_ChoiceMenu_LoadTilemap
	call SettingsPhone_ChoiceMenu_PrintPrompt
	call SettingsPhone_ChoiceMenu_UploadTextTiles
	call SettingsPhone_ChoiceMenu_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, $DA00
	ld de, SettingsPhone_ChoiceMenu_ObjTable
	ld a, $4D
	ld b, $81
	farcall Sprite_InitSlot
	call SettingsPhone_ChoiceMenu_PlaceCursor
	farcall Sprite_UpdateAll
	ret

SettingsPhone_ChoiceMenu_Loop:: ; 67:47DC
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l47FF
	bit 1, a
	jr nz, .l4817
	bit 6, a
	jr nz, .l482C
	bit 7, a
	jr nz, .l482C
	jr SettingsPhone_ChoiceMenu_Loop
.l47FF ; 67:47FF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wChoiceMenu_Cursor]
	inc a
	ld [wChoiceMenu_Result], a
	ret
.l4817 ; 67:4817
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wChoiceMenu_Result], a
	ret
.l482C ; 67:482C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wChoiceMenu_Cursor]
	ld b, $01
	xor a, b
	ld [wChoiceMenu_Cursor], a
	call SettingsPhone_ChoiceMenu_PlaceCursor
	call SettingsPhone_ChoiceMenu_LoadTilemap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	jr .l4852
.l4852 ; 67:4852
	jp SettingsPhone_ChoiceMenu_Loop

SettingsPhone_ChoiceMenu_PlaceCursor:: ; 67:4855
	ld a, [wChoiceMenu_Cursor]
	add a, a
	ld hl, SettingsPhone_ChoiceMenu_CursorPos
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $DA00
	call Sprite_SetPosition
	ret

; ---- data $486D-$4871 (4 bytes) [PROBABLE] 2 entries x 2 bytes (10 17 / 10 2F) indexed by [$C27D]*2 (ld hl,$486D at 67:4859): e=[hl], d=[hl+1] then ld hl,$DA00 ; call $0A65 which stores D,E into the sprite slot (positions); values are coordinates

SettingsPhone_ChoiceMenu_CursorPos:: ; 67:486D
Data_67_486D::
	db $10, $17, $10, $2F

SettingsPhone_ChoiceMenu_BuildTextMap:: ; 67:4871
	; [CONFIRMED] 74 insn(s) reached by static flow only; seeds: exec x74; min discovery hops 6;
	; entered by call from 67:47BA (PROBABLE code) [executed in 2 scenarios]
	ld hl, $D121
	ld de, $0000
	ld bc, $0612
	farcall Tilemap_FillAscendingWithAttr
	ret

SettingsPhone_ChoiceMenu_PrintPrompt:: ; 67:4881
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
	ld a, [wChoiceMenu_Variant]
	or a, a
	jr nz, .l48D4
	ld a, $08
	farcall PromptText_Load
	jr .l48DC
.l48D4 ; 67:48D4
	ld a, $09
	farcall PromptText_Load
.l48DC ; 67:48DC
	call TextEngine_Run
	ret

SettingsPhone_ChoiceMenu_UploadTextTiles:: ; 67:48E0
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret

SettingsPhone_ChoiceMenu_LoadTilemap:: ; 67:48F0
	ld a, [wChoiceMenu_Cursor]
	ld c, a
	ld a, [wChoiceMenu_Variant]
	or a, a
	jr nz, .l48FD
	xor a, a
	jr .l48FF
.l48FD ; 67:48FD
	ld a, $02
.l48FF ; 67:48FF
	add a, c
	ld de, $D063
	ld bc, $050E
	ld hl, SettingsPhone_ChoiceMenu_TilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $4D
	farcall Tilemap_CopyRectAndAttr
	ret

; ---- words $491C-$4924 (8 bytes) [PROBABLE] 4 words $5AE0,$5B6C,$5BF8,$5C84 indexed by [$C27D]*2 (ld hl,$491C at 67:4906): hl=[table] then ld a,$4D ; far call to 00:08EA (tilemap loader) at 67:4913-4917, i.e. source addresses in bank 4D (not this bank; dw kept numeric)

SettingsPhone_ChoiceMenu_TilemapTable:: ; 67:491C
Table_67_491C::
	dw $5AE0, $5B6C, $5BF8, $5C84
