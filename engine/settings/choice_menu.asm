; engine/settings/choice_menu.asm
; bank 67, $4631-$4924 (755 bytes); pinned by layout.link
; phone-settings choice menu

SECTION "engine/settings/choice_menu", ROMX

; ---- code $4631-$486D (572 bytes) [CONFIRMED] 275 insn(s) executed; cut out of the PROBABLE region 4593-486D by apply_coverage --split [executed in 1 scenarios] (part of region $45AB-$486D)

SettingsPhone_ChoiceMenu:: ; 67:4631
	ld [wRam_C27E], a
	call SettingsPhone_ChoiceMenu_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0009
	call Function_00_20E8
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
	ld a, [wRam_C27E]
	or a, a
	jr nz, Label_67_4678
	ld a, [wRam_C27D]
	ld [sPhoneTopMenuCursor], a
	jr Label_67_467E

Label_67_4678:: ; 67:4678
	ld a, [wRam_C27D]
	ld [sPhoneMethodMenuCursor], a

Label_67_467E:: ; 67:467E
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wRam_C27C]
	ret

SettingsPhone_ChoiceMenu_Setup:: ; 67:4688
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wRam_C27E]
	or a, a
	jr nz, Label_67_46B5
	ld a, [sPhoneTopMenuCursor]
	jr Label_67_46B8

Label_67_46B5:: ; 67:46B5
	ld a, [sPhoneMethodMenuCursor]

Label_67_46B8:: ; 67:46B8
	ld b, a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [wRam_C27D], a
	ld a, [wRam_C27E]
	or a, a
	jr nz, Label_67_4724
	ld de, $8801
	ld hl, $4110
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_4D_4510
	ld a, $4D
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_4D_4610
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_4D_4A10
	ld a, $4D
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, $5540
	ld a, $4D
	farcall Function_00_08EA
	jr Label_67_477D

Label_67_4724:: ; 67:4724
	ld de, $8801
	ld hl, $4C10
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_4D_5010
	ld a, $4D
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_4D_5110
	ld a, $4D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_4D_5510
	ld a, $4D
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_4D_5810
	ld a, $4D
	farcall Function_00_08EA

Label_67_477D:: ; 67:477D
	ld de, $8001
	ld hl, Data_4D_4000
	ld a, $4D
	ld b, $95
	ld c, $20
	farcall Function_00_0787
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
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_4D_5D10
	ld a, $4D
	ld b, $81
	farcall Function_00_0A82
	call SettingsPhone_ChoiceMenu_PlaceCursor
	farcall Function_00_0956
	ret

SettingsPhone_ChoiceMenu_Loop:: ; 67:47DC
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_67_47FF
	bit 1, a
	jr nz, Label_67_4817
	bit 6, a
	jr nz, Label_67_482C
	bit 7, a
	jr nz, Label_67_482C
	jr SettingsPhone_ChoiceMenu_Loop

Label_67_47FF:: ; 67:47FF
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	inc a
	ld [wRam_C27C], a
	ret

Label_67_4817:: ; 67:4817
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wRam_C27C], a
	ret

Label_67_482C:: ; 67:482C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	ld b, $01
	xor a, b
	ld [wRam_C27D], a
	call SettingsPhone_ChoiceMenu_PlaceCursor
	call SettingsPhone_ChoiceMenu_LoadTilemap
	ldh a, [rLCDC]
	call Function_00_082C
	jr Label_67_4852

Label_67_4852:: ; 67:4852
	jp SettingsPhone_ChoiceMenu_Loop

SettingsPhone_ChoiceMenu_PlaceCursor:: ; 67:4855
	ld a, [wRam_C27D]
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
	call Function_00_0A65
	ret

; ---- data $486D-$4871 (4 bytes) [PROBABLE] 2 entries x 2 bytes (10 17 / 10 2F) indexed by [$C27D]*2 (ld hl,$486D at 67:4859): e=[hl], d=[hl+1] then ld hl,$DA00 ; call $0A65 which stores D,E into the sprite slot (positions); values are coordinates

SettingsPhone_ChoiceMenu_CursorPos:: ; 67:486D
Data_67_486D::
	db $10, $17, $10, $2F

; ---- code $4871-$491C (171 bytes) [CONFIRMED] 74 insn(s) reached by static flow only; seeds: exec x74; min discovery hops 6; entered by call from 67:47BA (PROBABLE code) [executed in 2 scenarios]

SettingsPhone_ChoiceMenu_BuildTextMap:: ; 67:4871
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
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $48
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $C8
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wRam_C27E]
	or a, a
	jr nz, Label_67_48D4
	ld a, $08
	farcall Function_00_153D
	jr Label_67_48DC

Label_67_48D4:: ; 67:48D4
	ld a, $09
	farcall Function_00_153D

Label_67_48DC:: ; 67:48DC
	call Function_00_0ED3
	ret

SettingsPhone_ChoiceMenu_UploadTextTiles:: ; 67:48E0
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret

SettingsPhone_ChoiceMenu_LoadTilemap:: ; 67:48F0
	ld a, [wRam_C27D]
	ld c, a
	ld a, [wRam_C27E]
	or a, a
	jr nz, Label_67_48FD
	xor a, a
	jr Label_67_48FF

Label_67_48FD:: ; 67:48FD
	ld a, $02

Label_67_48FF:: ; 67:48FF
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
	farcall Function_00_08EA
	ret

; ---- words $491C-$4924 (8 bytes) [PROBABLE] 4 words $5AE0,$5B6C,$5BF8,$5C84 indexed by [$C27D]*2 (ld hl,$491C at 67:4906): hl=[table] then ld a,$4D ; far call to 00:08EA (tilemap loader) at 67:4913-4917, i.e. source addresses in bank 4D (not this bank; dw kept numeric)

SettingsPhone_ChoiceMenu_TilemapTable:: ; 67:491C
Table_67_491C::
	dw $5AE0, $5B6C, $5BF8, $5C84
