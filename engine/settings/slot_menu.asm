; engine/settings/slot_menu.asm
; bank 67, $4C73-$510A (1175 bytes); pinned by layout.link
; phone slot menu

SECTION "engine/settings/slot_menu", ROMX

SettingsPhone_SlotMenu:: ; 67:4C73
	; [CONFIRMED] 370 insn(s) reached by static flow only; seeds: exec x370; min discovery hops 4;
	; entered by call from 67:4BAF (PROBABLE code) | 246 insn(s) executed; cut out of the PROBABLE
	; region 4BD5-4F68 by apply_coverage --split [executed in 1 scenarios] (part of region
	; $4BD5-$4E56)
	ld [wSlotMenu_OnlyFilled], a
	call SettingsPhone_SlotMenu_Setup
	farcall Palette_FadeInFromWhite
	call SettingsPhone_SlotMenu_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wSlotMenu_Cursor]
	ld hl, sPhoneSlotMenuCursor
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, [wSlotMenu_Result]
	ret

SettingsPhone_SlotMenu_Setup:: ; 67:4CCB
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wSlotMenu_Result], a
	ld hl, sPhoneSlotMenuCursor
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hl]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	ld [wSlotMenu_Cursor], a
	ld a, [wSlotMenu_OnlyFilled]
	or a, a
	jr z, .l4D68
	ld de, $8801
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles8800Vb1
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6170
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6170)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, $6470
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_6870
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_6870)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	jr .l4DB0
.l4D68 ; 67:4D68
	ld de, $8801
	ld hl, $6970
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6D70
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6D70)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, $7070
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_7470
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_7470)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
.l4DB0 ; 67:4DB0
	ld de, $8001
	ld hl, Gfx_SettingsPhone_SlotMenu_Tiles8000Vb1
	ld a, BANK(Gfx_SettingsPhone_SlotMenu_Tiles8000Vb1)
	ld b, $98
	ld c, $02
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, $7570
	ld a, $4D
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, wPaletteBufObj
	ld hl, $7598
	ld a, $4D
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, $75A0
	ld a, $4D
	farcall Tilemap_CopyRectAndAttr
	call SettingsPhone_SlotMenu_LoadTabTilemap
	call SettingsPhone_SlotMenu_PrintSlotFields
	call SettingsPhone_SlotMenu_UploadTextTiles
	call SettingsPhone_SlotMenu_BuildTextMap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, SettingsPhone_SlotMenu_ObjTable
	ld a, BANK(SettingsPhone_SlotMenu_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call SettingsPhone_SlotMenu_PlaceCursor
	farcall Sprite_UpdateAll
	ret

SettingsPhone_SlotMenu_Loop:: ; 67:4E20
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l4E44
	bit 1, a
	jr nz, .l4E81
	bit 5, a
	jr nz, .l4E96
	bit 4, a
	jp nz, .l4EE4
	jr SettingsPhone_SlotMenu_Loop
.l4E44 ; 67:4E44
	ld a, [wSlotMenu_OnlyFilled]
	or a, a
	jr z, .l4E69
	ld a, [wSlotMenu_Cursor]
	farcall Dial_EntryHasNumber
	or a, a
	jr nz, .l4E69

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BD5-4F68 by apply_coverage --split
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jp .l4F4D

.l4E69 ; 67:4E69
	; [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wSlotMenu_Cursor]
	inc a
	ld [wSlotMenu_Result], a
	ret
.l4E81 ; 67:4E81
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wSlotMenu_Result], a
	ret
.l4E96 ; 67:4E96
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wSlotMenu_OnlyFilled]
	or a, a
	jr nz, .l4ECC

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BD5-4F68 by apply_coverage --split
	ld a, $01
	farcall Dial_EntryHasNumber
	or a, a
	jr nz, .l4EC1
.l4EB7 ; 67:4EB7
	ld a, [wSlotMenu_Cursor]
	xor a, $01
	ld [wSlotMenu_Cursor], a
	jr .l4F36
.l4EC1 ; 67:4EC1
	ld a, [wSlotMenu_Cursor]
	or a, a
	jr nz, .l4EC9
	ld a, $03
.l4EC9 ; 67:4EC9
	dec a
	jr .l4F33

.l4ECC ; 67:4ECC
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $01
	farcall Dial_EntryHasNumber
	or a, a
	jr z, .l4F4D

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BD5-4F68 by apply_coverage --split
	ld a, $02
	farcall Dial_EntryHasNumber
	or a, a
	jr z, .l4EB7
	jr .l4EC1

.l4EE4 ; 67:4EE4
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, [wSlotMenu_OnlyFilled]
	or a, a
	jr nz, .l4F1B
	ld a, $01
	farcall Dial_EntryHasNumber
	or a, a
	jr nz, .l4F0F
.l4F05 ; 67:4F05
	ld a, [wSlotMenu_Cursor]
	xor a, $01
	ld [wSlotMenu_Cursor], a
	jr .l4F36

.l4F0F ; 67:4F0F
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BD5-4F68 by apply_coverage --split
	ld a, [wSlotMenu_Cursor]
	cp a, $02
	jr nz, .l4F18
	ld a, $FF
.l4F18 ; 67:4F18
	inc a
	jr .l4F33

.l4F1B ; 67:4F1B
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $01
	farcall Dial_EntryHasNumber
	or a, a
	jr z, .l4F4D
	ld a, $02
	farcall Dial_EntryHasNumber
	or a, a
	jr z, .l4F05

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BD5-4F68 by apply_coverage --split
	jr .l4F0F
.l4F33 ; 67:4F33
	ld [wSlotMenu_Cursor], a

.l4F36 ; 67:4F36
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 4BD5-4F68 by apply_coverage
	; --split [executed in 1 scenarios]
	call SettingsPhone_SlotMenu_PlaceCursor
	farcall Sprite_UpdateAll
	call SettingsPhone_SlotMenu_LoadTabTilemap
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call SettingsPhone_SlotMenu_PrintSlotFields
	call SettingsPhone_SlotMenu_UploadTextTiles
.l4F4D ; 67:4F4D
	jp SettingsPhone_SlotMenu_Loop

SettingsPhone_SlotMenu_PlaceCursor:: ; 67:4F50
	ld a, [wSlotMenu_Cursor]
	add a, a
	ld hl, SettingsPhone_SlotMenu_CursorPos
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

; ---- data $4F68-$4F6E (6 bytes) [PROBABLE] 3 entries x 2 bytes (18 2F / 47 2F / 77 2F) indexed by [$C27D]*2 (ld hl,$4F68 at 67:4F54), e=[hl], d=[hl+1], stored into sprite slot $DA00 by call $0A65 (coordinates)

SettingsPhone_SlotMenu_CursorPos:: ; 67:4F68
Data_67_4F68::
	db $18, $2F, $47, $2F, $77, $2F

SettingsPhone_SlotMenu_BuildTextMap:: ; 67:4F6E
	; [CONFIRMED] 143 insn(s) reached by static flow only; seeds: exec x143; min discovery hops 7;
	; entered by call from 67:4DFE (PROBABLE code) [executed in 2 scenarios]
	ld hl, wScreenTileMap + $127
	ld de, $0000
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $167
	ld de, $0020
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $1A6
	ld de, $0040
	ld bc, $020C
	farcall Tilemap_FillAscendingWithAttr
	ret

SettingsPhone_SlotMenu_PrintSlotFields:: ; 67:4F9C
	ld de, $FFFF
	ld hl, $0907
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $4B
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $38
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
	ld a, [wSlotMenu_Cursor]
	ld hl, SettingsPhone_SlotMenu_FieldTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $03
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0B07
	ld bc, $020C
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $5B
	ldh [hTextY], a
	ld a, $38
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $38
	ldh [hRam_FFC0], a
	ld a, $58
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $68
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wSlotMenu_Cursor]
	ld hl, $50AB
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $03
	call TextEngine_Run
	ld de, $FFFF
	ld hl, $0D06
	ld bc, $0212
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $6B
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
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wSlotMenu_Cursor]
	ld hl, $50B1
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $03
	call TextEngine_Run
	ret

; ---- words $50A5-$50B7 (18 bytes) [PROBABLE] 9 words $DF10, $DF43, $DF76, $DF21, $DF54, $DF87, $DF32, $DF65, $DF98 = WRAM buffer addresses (3 groups of 3, step $11 / $33); used as hl=[table+2*idx] (ld hl,$50A5 at 67:4FE2) then ld a,$03 ; call $0ED3 (text interpreter) at 67:4FEF-4FF1, i.e. text-buffer pointers, not ROM pointers

SettingsPhone_SlotMenu_FieldTable:: ; 67:50A5
Table_67_50A5::
	dw wDialEntries, wDialEntries + $33, wDialEntries + $66, wDialEntries + $11, wDialEntries + $44, wDialEntries + $77, wDialEntries + $22, wDialEntries + $55
	dw wDialEntries + $88

SettingsPhone_SlotMenu_UploadTextTiles:: ; 67:50B7
	; [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 8;
	; entered by call from 67:4DFB (PROBABLE code) [executed in 2 scenarios]
	ld de, $9000
	ld hl, $0907
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $9200
	ld hl, $0B07
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ld de, $9400
	ld hl, $0D06
	ld bc, $020C
	farcall TileCanvas_UploadRect
	ret

SettingsPhone_SlotMenu_LoadTabTilemap:: ; 67:50E5
	ld de, wScreenTileMap + $E0
	ld bc, $0214
	ld a, [wSlotMenu_Cursor]
	ld hl, SettingsPhone_SlotMenu_TabTilemapTable
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

; ---- words $5104-$510A (6 bytes) [PROBABLE] 3 words $7870,$78C0,$7910 indexed by [$C27D]*2 (ld hl,$5104 at 67:50EE); hl=[table], ld a,$4D, far call 00:08EA (tilemap loader): source addresses in bank 4D (dw kept numeric)

SettingsPhone_SlotMenu_TabTilemapTable:: ; 67:5104
Table_67_5104::
	dw $7870, $78C0, $7910
