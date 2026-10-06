; engine/keyboard/keyboard.asm
; bank 55, $5BA2-$6CC6 (4388 bytes); pinned by layout.link
; on-screen keyboard: open, run, cursor, slide in/out, type picker, page graphics, glyph preview

SECTION "engine/keyboard/keyboard", ROMX

Kbd_Open:: ; 55:5BA2
Function_55_5BA2::
	; [CONFIRMED] 106 insn(s); 106 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wKbdType], a
	ld a, b
	ld [wKbdMode], a
	ld a, c
	call Kbd_LoadInputMode
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	xor a, a
	ld [wKbdPage], a
	ld a, [wKbdType]
	ld hl, Table_Kbd_StartCell
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld [wKbdCursorCell], a
	ld a, $FF
	ld [wKbdStickyCol], a
	ld [wKbdStickyRow], a
	ld [wRam_C2B0], a
	ld a, $01
	ld [wRam_C2B1], a
	jr .l5BDD
.l5BDD ; 55:5BDD
	ldh a, [rLCDC]
	and a, $9F
	ld b, a
	and a, $08
	xor a, $08
	rlca
	rlca
	rlca
	or a, b
	ldh [rLCDC], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, BANK(Data_5F_49D0)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $0018
	ld de, wPaletteBufObj + $28
	ld hl, Palette_5F_4CD0 + $10 ; 5F:4CE0
	ld a, BANK(Palette_5F_4CD0)
	farcall Palette_LoadToBuffer
	ld a, [wKbdType]
	call Kbd_TypeNeedsExtraPalette
	or a, a
	jp z, .l5C5A
	ld bc, $0010
	ld de, wPaletteBufBg + $30
	ld hl, Palette_5F_4CD0
	ld a, BANK(Palette_5F_4CD0)
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr .l5C5A
.l5C5A ; 55:5C5A
	ld a, [wKbdMode]
	cp a, $02
	jr nz, .l5C71
	call Kbd_ShowInstant
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Sound_FrameService
.l5C71 ; 55:5C71
	ld a, $01
	call Kbd_LoadPageGraphics
	ld hl, wSpriteSlot11
	ld de, Kbd_ObjTable
	ld a, BANK(Kbd_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $FF
	ld [wSpriteSlot11 + $04], a
	call Kbd_ClearSticky
	ret

Kbd_Run:: ; 55:5C8F
	ld a, c
	ld [wKbdRunArgC], a
	ld a, $01
	ld [wKbdRunArgB], a
	ld a, [wKbdType]
	cp a, $05
	jr nz, .skip

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 55:5C9D (executed) [executed in 4 scenarios]
	ld a, b
	ld [wKbdRunArgB], a

.skip ; 55:5CA3
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 11/18 scenarios)
	xor a, a
	ld [wKbdGlyphDirty], a
	ld a, [wKbdType]
	cp a, $0A
	jp z, Kbd_Run_TypePicker
	ld a, [wKbdMode]
	cp a, $02
	jr z, .l5CBC
	cp a, $00
	jr z, .l5CDD
	jr .l5CE0
.l5CBC ; 55:5CBC
	ld a, [wKbdType]
	call Function_55_6EAA
	or a, a
	jr z, .l5CE0
	ld a, [wKbdType]
	ld hl, $400A
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld [wKbdCursorCell], a
	call Kbd_FetchCell
	call Kbd_UpdateCursorSprite
	jr .l5CE0
.l5CDD ; 55:5CDD
	call Kbd_SlideIn
.l5CE0 ; 55:5CE0
	ld a, [wKbdType]
	call Function_55_6EC0
	or a, a
	jr z, .l5D05
	ld a, [wKbdRunArgC]
	or a, a
	jr z, .l5D05
	ld a, [wKbdType]
	ld hl, $400A
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld [wKbdCursorCell], a
	call Kbd_FetchCell
	call Kbd_UpdateCursorSprite
.l5D05 ; 55:5D05
	ld a, $01
	ld [wKbdMode], a
	call Kbd_FetchCell
	call Kbd_UpdateCursorSprite
	ld a, [wKbdType]
	cp a, $07
	jr nz, .l5D36
	ld a, [wKbdRunArgC]
	or a, a
	jr z, .l5D36
	ld hl, wSpriteSlot13
	ld de, Kbd_ObjTable_Entry18
	ld a, BANK(Kbd_ObjTable_Entry18)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7870
	ld hl, wSpriteSlot13
	call Sprite_SetPosition
.l5D36 ; 55:5D36
	ld a, [wKbdType]
	cp a, $05
	jr nz, Kbd_Run_Loop

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 55:5D3B (executed) [executed in 4 scenarios]
	call Kbd_HideMarkerSprite
	ld a, [wKbdRunArgB]
	or a, a
	jr nz, Kbd_Run_Loop
	call Kbd_ShowMarkerSprite

Kbd_Run_Loop:: ; 55:5D49
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 11/18 scenarios)
	call Kbd_DrawGlyphPreview
	farcall Joypad_Update
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l5D66
	call VBlank_WaitAndService
	jr .l5D69
.l5D66 ; 55:5D66
	call VBlank_Wait
.l5D69 ; 55:5D69
	ld a, [wKbdType]
	cp a, $05
	jr nz, .l5D76

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 55:5D6E (executed) [executed in 4 scenarios]
	farcall ConnectDialog_RefreshFieldIfDirty

.l5D76 ; 55:5D76
	; [CONFIRMED] 56 insn(s); 56 executed (in up to 11/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l5D9A
	bit PADB_B, a
	jr nz, .l5D9D
	bit PADB_UP, a
	jr nz, .l5DB6
	bit PADB_DOWN, a
	jr nz, .l5DC1
	bit PADB_LEFT, a
	jr nz, .l5DA0
	bit PADB_RIGHT, a
	jr nz, .l5DAB
	bit PADB_START, a
	jr nz, .l5DCC
	bit PADB_SELECT, a
	jr nz, .l5E02
	jr Kbd_Run_Loop
.l5D9A ; 55:5D9A
	jp Kbd_Run_ButtonA
.l5D9D ; 55:5D9D
	jp Kbd_Run_ReturnB
.l5DA0 ; 55:5DA0
	ld a, $00
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Kbd_Run_ContinueLoop
.l5DAB ; 55:5DAB
	ld a, $01
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Kbd_Run_ContinueLoop
.l5DB6 ; 55:5DB6
	ld a, $02
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Kbd_Run_ContinueLoop
.l5DC1 ; 55:5DC1
	ld a, $03
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Kbd_Run_ContinueLoop
.l5DCC ; 55:5DCC
	ld a, [wKbdType]
	ld hl, $400A
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld [wKbdCursorCell], a
	call Kbd_FetchCell
	call Kbd_UpdateCursorSprite
	play_sfx SFX_CURSOR_MOVE
	jp Kbd_Run_ContinueLoop

	; [HYPOTHESIS] 13-byte routine ld a,[$C2AB] ; call $6EEC ; or a ; jp z,$5E5A ; jp $5F29 - the
	; state variable and the jp targets match the neighbouring CONFIRMED handlers, and it calls the
	; (now classified) lookup routine 6EEC; no branch into it found [verifier: no entry proven (no
	; caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	ld a, [wKbdType]
	call Function_55_6EEC
	or a, a
	jp z, Kbd_Run_ContinueLoop
	jp Label_55_5F29

.l5E02 ; 55:5E02
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 4/18 scenarios)
	ld a, [wKbdType]
	cp a, $05
	jr z, .l5E42
	cp a, $01
	jr z, .l5E57
	ld a, [wKbdType]
	call Kbd_TypeHasPages
	or a, a
	jp z, Kbd_Run_Loop
	play_sfx $003A
	ld hl, wKbdPage
	ld a, [hl]
	inc a
	cp a, $04
	jr nz, .skip

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 55:5E2E (executed) [executed in 3 scenarios]
	xor a, a

.skip ; 55:5E31
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld [hl], a
	call Kbd_FetchCell
	call Kbd_RequestGlyphRedraw
	xor a, a
	call Kbd_LoadPageGraphics
	call Kbd_ShowPageIndicator
	jp Kbd_Run_Loop

.l5E42 ; 55:5E42
	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jrcc from 55:5E07 (executed) [executed in 4 scenarios]
	ld a, [wKbdRunArgB]
	or a, a
	jr nz, .l5E4B
	jp Kbd_Run_Loop
.l5E4B ; 55:5E4B
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jp Kbd_Run_ReturnSelect

.l5E57 ; 55:5E57
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 10/18 scenarios)
	jp Kbd_Run_ReturnSelect

Kbd_Run_ContinueLoop:: ; 55:5E5A
Label_55_5E5A::
	jp Kbd_Run_Loop

Kbd_Run_ButtonA:: ; 55:5E5D
	ld hl, wKeyboardCharHi
	ld a, [hld]
	cp a, $01
	jr z, .l5E6C
	cp a, $FF
	jr z, .l5E99
	jp .l5F09
.l5E6C ; 55:5E6C
	ld a, [hl]
	cp a, $0D
	jr z, .l5E78
	cp a, $20
	jr z, .l5E7B

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 55:5E73 (executed) | 1 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 5E75-5E7B by apply_coverage --split
	jp .l5F09

.l5E78 ; 55:5E78
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5E75-5E7B by apply_coverage
	; --split [executed in 5 scenarios]
	jp Kbd_Run_ReturnNewline

.l5E7B ; 55:5E7B
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wKbdType]
	cp a, $03
	jr nz, .l5E8E

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 55:5E80 (executed)
	ld hl, wKeyboardCharHi
	ld a, $00
	ld [hld], a
	ld a, $20
	ld [hl], a
	jp .l5F17

.l5E8E ; 55:5E8E
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 9/18 scenarios)
	ld hl, wKeyboardCharHi
	ld a, $81
	ld [hld], a
	ld a, $40
	ld [hl], a
	jr .l5F17
.l5E99 ; 55:5E99
	ld a, [hl]
	cp a, $80
	jr z, .l5EAC
	cp a, $81
	jr z, .l5EB7
	cp a, $82
	jr z, .l5EB9
	cp a, $83
	jr z, .l5EE7

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 55:5EA8 (executed)
	jr .l5F09
.l5EAC ; 55:5EAC
	ld hl, wKeyboardCharHi
	ld a, $00
	ld [hld], a
	ld a, $20
	ld [hl], a
	jr .l5F17
.l5EB7 ; 55:5EB7
	jr Kbd_Run_ReturnNewline

.l5EB9 ; 55:5EB9
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 9/18 scenarios)
	ld a, [wKbdRunArgB]
	or a, a
	jp nz, .l5ED3

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jpcc at 55:5EBD (executed) [executed in 4 scenarios]
	play_sfx SFX_REJECT
	jp Kbd_Run_Loop

.l5ED3 ; 55:5ED3
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 9/18 scenarios)
	ld a, [wKbdType]
	call Kbd_TypeHidesOnKey82
	or a, a
	jr z, Kbd_Run_ReturnKey82
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jr Kbd_Run_ReturnKey82
.l5EE7 ; 55:5EE7
	ld a, [wKbdType]
	cp a, $07
	jr nz, .l5EF5

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 55:5EEC (executed) [executed in 1 scenarios]
	ld a, [wKbdRunArgC]
	or a, a
	jp nz, Kbd_Run_Loop

.l5EF5 ; 55:5EF5
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 4/18 scenarios)
	ld a, [wKbdType]
	call Kbd_TypeHidesOnKey83
	or a, a
	jr z, Kbd_Run_ReturnKey83

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 55:5EFC (executed) [executed in 4 scenarios]
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jr Kbd_Run_ReturnKey83

.l5F09 ; 55:5F09
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 10/18 scenarios)
	ld a, [wKbdType]
	cp a, $01
	jr nz, .l5F17
	call Kbd_RejectSymbol
	or a, a
	jp nz, Kbd_Run_ContinueLoop
.l5F17 ; 55:5F17
	ld a, $01
	ret

Kbd_Run_ReturnB:: ; 55:5F1A
Label_55_5F1A::
	ld a, $02
	ret

Kbd_Run_ReturnNewline:: ; 55:5F1D
Label_55_5F1D::
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 2;
	; entered by jp from 55:5E78 (PROBABLE code) [executed in 3 scenarios]
	ld a, $03
	ret

Kbd_Run_ReturnKey83:: ; 55:5F20
Label_55_5F20::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 9/18 scenarios)
	ld a, $08
	ret

Kbd_Run_ReturnKey82:: ; 55:5F23
Label_55_5F23::
	ld a, $07
	ret

Kbd_Run_ReturnSelect:: ; 55:5F26
Label_55_5F26::
	ld a, $0A
	ret

Label_55_5F29:: ; 55:5F29
	; [HYPOTHESIS] xor a ; call $6427 ; ld a,0 ; ld [$C2AF],a ; ld a,9 ; ret - target of the jp
	; $5F29 at 55:5DFF, sibling of the "ld a,N ; ret" handlers at 5F1D/5F20 [verifier: no entry
	; proven (no caller, no valid table word, never executed): decode chain alone is not proof ->
	; HYPOTHESIS; its only jumper is the HYPOTHESIS routine 5DF5]
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	ld a, $09
	ret

Kbd_FetchCell:: ; 55:5F35
Function_55_5F35::
	; [CONFIRMED] 98 insn(s); 98 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wKbdType]
	ld hl, Table_Kbd_PagePointers
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wKbdPage]
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wKbdCursorCell]
	ld d, $00
	ld e, a
	add hl, de
	add hl, de
	ld de, wKeyboardCharHi
	ld a, [hli]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call Kbd_RequestGlyphRedraw
	ret

Kbd_MoveCursor:: ; 55:5F66
	push af
	play_sfx SFX_CURSOR_MOVE
	pop af
	ld [wKbdMoveDirection], a
	push af
	ld a, [wKbdCursorCell]
	ld b, $00
	ld c, a
	ld d, $00
	ld e, $06
	call Multiply16
	ld d, h
	ld e, l
	ld a, [wKbdType]
	ld hl, Table_Kbd_NeighbourRecords
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld a, $04
	push hl
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld [wKbdNeighbourFlagsA], a
	ld a, [hl]
	ld [wKbdNeighbourFlagsB], a
	pop hl
	pop af
	push af
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld [wKbdNeighbourCell], a
	pop af
	add a, a
	add a, $C8
	ld l, a
	ld a, $5F
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $5FC8-$5FD0 (8 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Kbd_MoveCursor_DirTable:: ; 55:5FC8
Table_55_5FC8::
	dw $5FD0, $5FF4, $5FFD, $6020

	; [CONFIRMED] 51 insn(s); 51 executed (in up to 8/18 scenarios)
	ld a, [wKbdNeighbourFlagsA]
	bit 7, a
	jp z, .l602E
.l5FD8 ; 55:5FD8
	ld a, [wKbdStickyRow]
	cp a, $FF
	jr z, .l602E
	ld a, [wKbdNeighbourCell]
	call Kbd_IndexToColRow
	call Kbd_AdjustColRowForSticky
	ld a, [wKbdStickyRow]
	ld c, a
	call Kbd_ColRowToIndex
	ld [wKbdCursorCell], a
	jr .l6029

	ld a, [wKbdNeighbourFlagsA]
	bit 6, a
	jr z, .l602E
	jr .l5FD8

	ld a, [wKbdNeighbourFlagsA]
	bit 5, a
	jr z, .l602E
.l6004 ; 55:6004
	ld a, [wKbdStickyCol]
	cp a, $FF
	jr z, .l602E
	ld a, [wKbdNeighbourCell]
	call Kbd_IndexToColRow
	call Kbd_AdjustColRowForSticky
	ld a, [wKbdStickyCol]
	ld b, a
	call Kbd_ColRowToIndex
	ld [wKbdCursorCell], a
	jr .l6029

	ld a, [wKbdNeighbourFlagsA]
	bit 4, a
	jr z, .l602E
	jr .l6004
.l6029 ; 55:6029
	call Kbd_UpdateSticky
	jr .l603D
.l602E ; 55:602E
	ld a, [wKbdCursorCell]
	call Kbd_SplitCursorIndex
	call Kbd_UpdateSticky
	ld a, [wKbdNeighbourCell]
	ld [wKbdCursorCell], a
.l603D ; 55:603D
	call Kbd_FetchCell
	ret

Kbd_AdjustColRowForSticky:: ; 55:6041
Function_55_6041::
	ld a, [wKbdType]
	cp a, $01
	jr z, .l604D
	cp a, $03
	jr z, .l605A
	ret

.l604D ; 55:604D
	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 1;
	; entered by jrcc from 55:6046 (executed) | 8 insn(s) executed; cut out of the PROBABLE region
	; 604D-6068 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wKbdMoveDirection]
	or a, a
	ret nz
	ld a, [wKbdStickyRow]
	cp a, $03
	ret nz
	inc b
	ret

.l605A ; 55:605A
	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 604D-6068 by apply_coverage --split
	ld a, [wKbdMoveDirection]
	cp a, $02
	ret nz
	ld a, [wKbdStickyCol]
	cp a, $11
	ret nz
	inc c
	ret

Kbd_UpdateSticky:: ; 55:6068
Function_55_6068::
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 8/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wKeyboardCharHi]
	cp a, $FF
	jr z, Kbd_UpdateSticky_SpecialKey
	ld a, $FF
	ld [wKbdStickyCol], a
	ld [wKbdStickyRow], a
	ld a, [wKbdMoveDirection]
	add a, a
	add a, $87
	ld l, a
	ld a, $60
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $6087-$608F (8 bytes) [CONFIRMED] read as data by executed code (in up to 7/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Kbd_UpdateSticky_StoreDirTable:: ; 55:6087
Table_55_6087::
	dw $608F, $60A0, $60B1, $60C2

	; [CONFIRMED] 45 insn(s); 45 executed (in up to 7/18 scenarios)
	ld a, [wKbdNeighbourFlagsB]
	bit 7, a
	call nz, Kbd_StoreStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 3, a
	call nz, Kbd_StoreStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 6, a
	call nz, Kbd_StoreStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 2, a
	call nz, Kbd_StoreStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 5, a
	call nz, Kbd_StoreStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 1, a
	call nz, Kbd_StoreStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 4, a
	call nz, Kbd_StoreStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 0, a
	call nz, Kbd_StoreStickyRow
	ret

Kbd_StoreStickyCol:: ; 55:60D3
Function_55_60D3::
	ld a, [wKbdCursorCol]
	ld [wKbdStickyCol], a
	ret

Kbd_StoreStickyRow:: ; 55:60DA
Function_55_60DA::
	ld a, [wKbdCursorRow]
	ld [wKbdStickyRow], a
	ret

Kbd_UpdateSticky_SpecialKey:: ; 55:60E1
Label_55_60E1::
	ld a, [wKbdMoveDirection]
	add a, a
	add a, $F1
	ld l, a
	ld a, $60
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $60F1-$60F9 (8 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Kbd_UpdateSticky_ClearDirTable:: ; 55:60F1
Table_55_60F1::
	dw $60F9, $610A, $611B, $612C

	; [CONFIRMED] 67 insn(s); 67 executed (in up to 11/18 scenarios)
	ld a, [wKbdNeighbourFlagsB]
	bit 7, a
	call z, Kbd_ClearStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 3, a
	call z, Kbd_ClearStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 6, a
	call z, Kbd_ClearStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 2, a
	call z, Kbd_ClearStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 5, a
	call z, Kbd_ClearStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 1, a
	call z, Kbd_ClearStickyRow
	ret

	ld a, [wKbdNeighbourFlagsB]
	bit 4, a
	call z, Kbd_ClearStickyCol
	ld a, [wKbdNeighbourFlagsB]
	bit 0, a
	call z, Kbd_ClearStickyRow
	ret

Kbd_ClearStickyCol:: ; 55:613D
Function_55_613D::
	ld a, $FF
	ld [wKbdStickyCol], a
	ret

Kbd_ClearStickyRow:: ; 55:6143
Function_55_6143::
	ld a, $FF
	ld [wKbdStickyRow], a
	ret

Kbd_SplitCursorIndex:: ; 55:6149
	ld a, [wKbdCursorCell]
	ld b, $00
.loop ; 55:614E
	sub a, $12
	jr c, .l6155
	inc b
	jr .loop
.l6155 ; 55:6155
	add a, $12
	ld [wKbdCursorCol], a
	ld a, b
	ld [wKbdCursorRow], a
	ret

Kbd_IndexToColRow:: ; 55:615F
	ld b, $00
.loop ; 55:6161
	sub a, $12
	jr c, .l6168
	inc b
	jr .loop
.l6168 ; 55:6168
	add a, $12
	ld c, b
	ld b, a
	ret

Kbd_ColRowToIndex:: ; 55:616D
	push bc
	ld d, $00
	ld e, c
	ld bc, $0012
	call Multiply16
	pop bc
	ld a, b
	add a, l
	ret

Kbd_ClearSticky:: ; 55:617B
Function_55_617B::
	ld a, $FF
	ld [wKbdStickyCol], a
	ld [wKbdStickyRow], a
	ret

	; [HYPOTHESIS] two 6-byte routines (ld a,$FF ; ld [$C2BD],a ; ret) and (ld a,$FF ; ld [$C2BE],a
	; ; ret): siblings of the called routines 613D/6143 and of 617B (which writes both); nothing
	; calls them
	ld a, $FF
	ld [wKbdStickyCol], a
	ret

	ld a, $FF
	ld [wKbdStickyRow], a
	ret

Kbd_UpdateCursorSprite:: ; 55:6190
Function_55_6190::
	; [CONFIRMED] 103 insn(s); 103 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	call Kbd_SplitCursorIndex
	ld a, [wKbdType]
	ld hl, Table_Kbd_CursorSpriteOrigin
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ld hl, wKeyboardCharHi
	ld a, [hld]
	cp a, $FF
	jr z, .l61BF
	push bc
	ld hl, wSpriteSlot11
	ld de, Kbd_ObjTable
	ld a, BANK(Kbd_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	jr .l61F6
.l61BF ; 55:61BF
	push bc
	ld hl, wSpriteSlot11
	ld de, Kbd_ObjTable
	ld a, BANK(Kbd_ObjTable)
	ld b, $82
	farcall Sprite_InitSlot
	pop bc
	ld a, [wKbdType]
	ld hl, Table_Kbd_CursorSpriteCharOffsetPtrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wKeyboardCharLo]
	sub a, $80
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld d, [hl]
	inc hl
	ld e, [hl]
	ld a, b
	add a, d
	ld b, a
	ld a, c
	add a, e
	ld c, a
.l61F6 ; 55:61F6
	ld a, [wKbdCursorRow]
	sla a
	sla a
	sla a
	sla a
	add a, c
	ld e, a
	ld a, [wKbdCursorCol]
	sla a
	sla a
	sla a
	add a, b
	ld d, a
	ld a, e
	ld [wKbdCursorSpriteY], a
	ld a, d
	ld [wKbdCursorSpriteX], a
	ld a, [wKeyboardCharHi]
	cp a, $FF
	jr nz, .l623B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	ld [wSpriteSlot11], a
	ld a, d
	ld [wSpriteSlot11 + $01], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
.l623B ; 55:623B
	ld a, [wKeyboardCharHi]
	cp a, $FF
	jr nz, .l6299
	ld a, [wKeyboardCharLo]
	cp a, $82
	jr z, .l624F
	cp a, $83
	jr z, .l6261

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 55:624B (executed)
	jr .done

.l624F ; 55:624F
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 11/18 scenarios)
	ld hl, wSpriteSlot10
	ld de, Kbd_ObjTable_Entry8
	ld a, BANK(Kbd_ObjTable_Entry8)
	ld b, $85
	farcall Sprite_InitSlot
	jr .l6271
.l6261 ; 55:6261
	ld hl, wSpriteSlot10
	ld de, Kbd_ObjTable_Entry8
	ld a, BANK(Kbd_ObjTable_Entry8)
	ld b, $84
	farcall Sprite_InitSlot
.l6271 ; 55:6271
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlot11]
	sub a, $09
	ld [wSpriteSlot10], a
	ld a, [wSpriteSlot11 + $01]
	sub a, $02
	ld [wSpriteSlot10 + $01], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr .done
.l6299 ; 55:6299
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
.done ; 55:629F
	ret

; ---- data $62A0-$62B4 (20 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 62A0-62B4 that executed code reads piecewise [split by classify_g2]

Table_Kbd_CursorSpriteOrigin:: ; 55:62A0
Data_55_62A0::
	db $34, $07, $34, $07, $34, $07, $2C, $07, $2C, $07, $2C, $07, $3C, $07, $3C, $07
	db $3C, $07, $3C, $07

; ---- ptrtable $62B4-$62C8 (20 bytes) [PROBABLE] little-endian word table, 10 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $62C8..$6310; referenced by ld r16,$62B4 at 55:61D4

Table_Kbd_CursorSpriteCharOffsetPtrs:: ; 55:62B4
Table_55_62B4::
	dw Data_55_62C8
	dw $62D0
	dw $62D8
	dw $62E0
	dw $62E8
	dw $62F0
	dw $62F8
	dw $6300
	dw $6308
	dw $6310

; ---- data $62C8-$6318 (80 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 62C8-6318 that executed code reads piecewise [split by classify_g2]

Data_55_62C8:: ; 55:62C8
	db $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA
	db $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA
	db $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA
	db $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA
	db $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA, $FF, $FA

Kbd_SlideIn:: ; 55:6318
Function_55_6318::
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	play_sfx SFX_POPUP_OPEN
	call Kbd_GetSlideTargetY
	ld [wRam_C2A2], a
	ld a, [wKbdType]
	cp a, $06
	jr nz, .l6348
	farcall KbdSlide_InPrepMode6
.l6348 ; 55:6348
	cp a, $08
	jr nz, .l6352
	farcall KbdSlide_InPrepMode8
.l6352 ; 55:6352
	cp a, $09
	jr nz, .l635C
	farcall KbdSlide_InPrepMode9
.l635C ; 55:635C
	cp a, $07
	jr nz, .l6366
	farcall KbdSlide_InPrepMode7
.l6366 ; 55:6366
	ld a, [wKbdType]
	cp a, $05
	jr nz, .l6386

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 55:636B (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 636D-6386 by apply_coverage --split [executed in 4 scenarios]
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6381
	call VBlank_WaitAndService
	jr .l6384

.l6381 ; 55:6381
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 636D-6386 by apply_coverage --split
	call VBlank_Wait

.l6384 ; 55:6384
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 636D-6386 by apply_coverage
	; --split [executed in 4 scenarios]
	jr .l63D2

.l6386 ; 55:6386
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 5/18 scenarios)
	ld a, [wKbdType]
	cp a, $06
	jr nz, .l639A
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_InStepMode6
	jr .l63D2
.l639A ; 55:639A
	cp a, $08
	jr nz, .l63AB
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_InStepMode8
	jr .l63D2
.l63AB ; 55:63AB
	cp a, $09
	jr nz, .l63BC
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_InStepMode9
	jr .l63D2
.l63BC ; 55:63BC
	cp a, $07
	jr nz, .l63CD
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_InStepMode7
	jr .l63D2

.l63CD ; 55:63CD
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 55:63BE (executed)
	push de
	call VBlank_Wait
	pop de

.l63D2 ; 55:63D2
	; [CONFIRMED] 38 insn(s); 38 executed (in up to 11/18 scenarios)
	ld hl, rWY
	ld a, [hl]
	sub a, $08
	ld [hl], a
	push af
	ld a, [wRam_C2A2]
	ld b, a
	pop af
	cp a, b
	jp nz, .l6366
	call Kbd_ShowPageIndicator
	ret

Kbd_ShowInstant:: ; 55:63E7
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l63F5
	call VBlank_WaitAndService
	jr .l63F8
.l63F5 ; 55:63F5
	call VBlank_Wait
.l63F8 ; 55:63F8
	call Kbd_GetSlideTargetY
	ldh [rWY], a
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	call Kbd_ShowPageIndicator
	ret

Kbd_GetSlideTargetY:: ; 55:640E
	ld a, [wKbdType]
	ld hl, Table_Kbd_GetSlideTargetY_ByType
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $641C-$6427 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 641C-6427 that executed code reads piecewise [split by classify_g2]

Table_Kbd_GetSlideTargetY_ByType:: ; 55:641C
Data_55_641C::
	db $28, $28, $28, $28, $28, $28, $38, $38, $38, $38, $38

Kbd_SlideOut:: ; 55:6427
Function_55_6427::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	ld hl, wSpriteSlot12
	call Sprite_ClearSlot
	ld hl, wSpriteSlot13
	call Sprite_ClearSlot
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6453

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 55:644C (executed) [executed in 4 scenarios]
	call VBlank_WaitAndService
	jr .l6456

.l6453 ; 55:6453
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 4/18 scenarios)
	call VBlank_Wait
.l6456 ; 55:6456
	ldh a, [rWY]
	cp a, $90
	ret nc
	play_sfx SFX_POPUP_CLOSE
	ld a, [wKbdType]
	cp a, $06
	jr nz, .l6478
	farcall KbdSlide_OutPrepMode6
.l6478 ; 55:6478
	cp a, $08
	jr nz, .l6482
	farcall KbdSlide_OutPrepMode8
.l6482 ; 55:6482
	cp a, $09
	jr nz, .l648C
	farcall KbdSlide_OutPrepMode9
.l648C ; 55:648C
	cp a, $07
	jr nz, .l6496
	farcall KbdSlide_OutPrepMode7
.l6496 ; 55:6496
	ld a, [wKbdType]
	cp a, $05
	jr nz, .l64B6

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 55:649B (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 649D-64B6 by apply_coverage --split [executed in 4 scenarios]
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l64B1
	call VBlank_WaitAndService
	jr .l64B4

.l64B1 ; 55:64B1
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 649D-64B6 by apply_coverage --split
	call VBlank_Wait

.l64B4 ; 55:64B4
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 649D-64B6 by apply_coverage
	; --split [executed in 4 scenarios]
	jr .l6502

.l64B6 ; 55:64B6
	; [CONFIRMED] 60 insn(s); 60 executed (in up to 8/18 scenarios)
	ld a, [wKbdType]
	cp a, $06
	jr nz, .l64CA
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_OutStepMode6
	jr .l6502
.l64CA ; 55:64CA
	cp a, $08
	jr nz, .l64DB
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_OutStepMode8
	jr .l6502
.l64DB ; 55:64DB
	cp a, $09
	jr nz, .l64EC
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_OutStepMode9
	jr .l6502
.l64EC ; 55:64EC
	cp a, $07
	jr nz, .l64FD
	push de
	call VBlank_Wait
	pop de
	farcall KbdSlide_OutStepMode7
	jr .l6502
.l64FD ; 55:64FD
	push de
	call VBlank_Wait
	pop de
.l6502 ; 55:6502
	ld hl, rWY
	ld a, [hl]
	add a, $08
	ld [hl], a
	cp a, $90
	jp c, .l6496
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	ret

Kbd_HideInstant:: ; 55:651C
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	ld hl, wSpriteSlot12
	call Sprite_ClearSlot
	ld hl, wSpriteSlot13
	call Sprite_ClearSlot
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6548
	call VBlank_WaitAndService
	jr .l654B

.l6548 ; 55:6548
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 55:6541 (executed) [executed in 1 scenarios]
	call VBlank_Wait

.l654B ; 55:654B
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 8/18 scenarios)
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	ret

Kbd_Hide:: ; 55:6559
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	ret

Kbd_Run_TypePicker:: ; 55:6563
Label_55_6563::
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	play_sfx SFX_POPUP_OPEN
.loop ; 55:6580
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6594

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 55:658D (executed)
	call VBlank_WaitAndService
	jr .l6597

.l6594 ; 55:6594
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios)
	call VBlank_Wait
.l6597 ; 55:6597
	ldh a, [rWY]
	sub a, $08
	cp a, $80
	jr nz, .l65A4
	push af
	call Kbd_LoadPickerTabTiles
	pop af
.l65A4 ; 55:65A4
	ldh [rWY], a
	cp a, $60
	jp nz, .loop
	call Kbd_TypePickerLoop
	push af
	call Kbd_SlideOut
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	call Kbd_SaveInputMode
	pop af
	or a, a
	jr nz, .l65C9
	ld a, $09
	ret
.l65C9 ; 55:65C9
	ld a, [wKbdInputMode]
	ld hl, Data_55_65D7
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $65D7-$65DA (3 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 65D7-65DA that executed code reads piecewise [split by classify_g2]

Data_55_65D7:: ; 55:65D7
	db $04, $05, $06

Kbd_TypePickerLoop:: ; 55:65DA
Function_55_65DA::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, wSpriteSlot11
	ld de, Kbd_ObjTable
	ld a, BANK(Kbd_ObjTable)
	ld b, $82
	farcall Sprite_InitSlot
.l65EA ; 55:65EA
	call Kbd_UpdatePickerSprites
.l65ED ; 55:65ED
	farcall Joypad_Update
	farcall Sprite_UpdateAll
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6607

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 55:6600 (executed)
	call VBlank_WaitAndService
	jr .l660A

.l6607 ; 55:6607
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)
	call VBlank_Wait
.l660A ; 55:660A
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l661E
	bit PADB_B, a
	jr nz, .l6622
	bit PADB_LEFT, a
	jr nz, .l6626
	bit PADB_RIGHT, a
	jr nz, .l6646
	jr .l65ED
.l661E ; 55:661E
	ld a, $01
	jr .l6666
.l6622 ; 55:6622
	ld a, $00
	jr .l6666
.l6626 ; 55:6626
	play_sfx SFX_CURSOR_MOVE
	ld hl, wKbdInputMode
	ld a, [hl]
	or a, a
	jr z, .l6641
	dec a
	ld [hl], a
	jr .l65EA
.l6641 ; 55:6641
	ld a, $02
	ld [hl], a
	jr .l65EA
.l6646 ; 55:6646
	play_sfx SFX_CURSOR_MOVE
	ld hl, wKbdInputMode
	ld a, [hl]
	cp a, $02
	jr z, .l6662
	inc a
	ld [hl], a
	jr .l65EA

.l6662 ; 55:6662
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 55:665C (executed) [executed in 1 scenarios]
	xor a, a
	ld [hl], a
	jr .l65EA

.l6666 ; 55:6666
	; [CONFIRMED] 42 insn(s); 42 executed (in up to 2/18 scenarios)
	push af
	ld hl, wSpriteSlot10
	call Sprite_ClearSlot
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	farcall Sprite_UpdateAll
	pop af
	ret

Kbd_UpdatePickerSprites:: ; 55:667B
	ld hl, Table_Kbd_PickerSpritePositions
	ld a, [wKbdInputMode]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld d, $66
	ld e, a
	ld hl, wSpriteSlot11
	call Sprite_SetPosition
	ld a, [wKbdInputMode]
	inc a
	set 7, a
	ld b, a
	ld hl, wSpriteSlot10
	ld de, Kbd_ObjTable_Entry8
	ld a, BANK(Kbd_ObjTable_Entry8)
	farcall Sprite_InitSlot
	ld hl, $66C3
	ld a, [wKbdInputMode]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld d, $5D
	ld e, a
	ld hl, wSpriteSlot10
	call Sprite_SetPosition
	call Kbd_LoadPickerTabTiles
	ret

; ---- data $66C0-$66C6 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Table_Kbd_PickerSpritePositions:: ; 55:66C0
Data_55_66C0::
	db $1E, $46, $6E, $1C, $44, $6C

Kbd_LoadPageGraphics:: ; 55:66C6
Function_55_66C6::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hKbd_LoadPageArg], a
	ld a, [wKbdType]
	ld hl, Kbd_LoadPageGraphics_TypeTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $66D9-$66EF (22 bytes) [PROBABLE] code-pointer table, 11 entries: 8/11 words hit known code starts (dispatch idiom `ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` at 55:66D8, base from `ld hl,$66D9`; end = cfg inline-table rule, HYPOTHESIS for the exact length); 8/11 targets executed

Kbd_LoadPageGraphics_TypeTable:: ; 55:66D9
Table_55_66D9::
	dw Kbd_LoadPageGraphics_T0
	dw Kbd_LoadPageGraphics_T1
	dw Kbd_LoadPageGraphics_T2
	dw Kbd_LoadPageGraphics_T3
	dw Kbd_LoadPageGraphics_T4
	dw Kbd_LoadPageGraphics_T5
	dw Kbd_LoadPageGraphics_T6
	dw Kbd_LoadPageGraphics_T78
	dw Kbd_LoadPageGraphics_T78
	dw Kbd_LoadPageGraphics_T9
	dw Kbd_LoadPageGraphics_T10

Kbd_LoadPageGraphics_T0:: ; 55:66EF
Label_55_66EF::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 3/18 scenarios)
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T0
	ld a, BANK(Tilemap_Kbd_T0)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T1:: ; 55:6704
Label_55_6704::
	ld de, $8800
	ld hl, Gfx_Kbd_T1_Tiles8800
	ld a, BANK(Gfx_Kbd_T1_Tiles8800)
	ld b, $98
	ld c, $02
	farcall Gfx_StartHDMAWithService
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T1
	ld a, BANK(Tilemap_Kbd_T1)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T2:: ; 55:672B
Label_55_672B::
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: site x6, table x8; min discovery
	; hops 0; run starts at an entry of the code-pointer table at 55:66D9 [executed in 1 scenarios]
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T2
	ld a, BANK(Tilemap_Kbd_T2)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T3:: ; 55:6740
Label_55_6740::
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T3
	ld a, BANK(Tilemap_Kbd_T3)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T4:: ; 55:6755
Label_55_6755::
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 7/18 scenarios)
	ld de, $8801
	ld hl, Gfx_Kbd_T4_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T4_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T4_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T4_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0018
	ld de, wPaletteBufBg + $28
	ld hl, Data_5E_4D00 + $28 ; 5E:4D28
	ld a, BANK(Data_5E_4D00)
	farcall Palette_LoadToBuffer
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T4
	ld a, BANK(Tilemap_Kbd_T4)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T5:: ; 55:679F
Label_55_679F::
	; [CONFIRMED] 69 insn(s) reached by static flow only; seeds: site x64, table x5; min discovery
	; hops 0; run starts at an entry of the code-pointer table at 55:66D9 [executed in 4 scenarios]
	ld de, $8801
	ld hl, Gfx_Kbd_T5_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T5_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T5_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T5_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T5_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T5_Tiles9000Vb1)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld bc, $0008
	ld de, wPaletteBufBg + $08
	ld hl, Palette_Kbd_T5_Bg1
	ld a, BANK(Palette_Kbd_T5_Bg1)
	farcall Palette_LoadToBuffer
	ld bc, $0010
	ld de, wPaletteBufBg + $30
	ld hl, Palette_Kbd_T5_Bg1 + $08 ; 5F:6BC0
	ld a, BANK(Palette_Kbd_T5_Bg1)
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld bc, $0D14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T5
	ld a, BANK(Tilemap_Kbd_T5)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap13Rows
	ret

Kbd_LoadPageGraphics_T6:: ; 55:6858
Label_55_6858::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	ld a, [wKbdPage]
	ld hl, Table_Kbd_T6_PageLoaders
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $6869-$686F (6 bytes) [CONFIRMED] code-pointer table, 3 entries: 3/3 words hit own-bank code starts (start is the operand of ld r16); 3/3 targets executed; every byte read as data in a trace

Table_Kbd_T6_PageLoaders:: ; 55:6869
Table_55_6869::
	dw Kbd_LoadPageGraphics_T6_Page0
	dw Kbd_LoadPageGraphics_T6_Page1
	dw Kbd_LoadPageGraphics_T6_Page2

; ---- ptrtable $686F-$6871 (2 bytes) [PROBABLE] one more code pointer ($691C) at the end of the dispatch table that precedes it; target = the code classified at 691C

Table_Kbd_T6_PageLoaders_Page3:: ; 55:686F
Table_55_686F::
	dw Kbd_LoadPageGraphics_T6_Page3

Kbd_LoadPageGraphics_T6_Page0:: ; 55:6871
Label_55_6871::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 2/18 scenarios)
	ld de, $8801
	ld hl, Gfx_Kbd_T6_Page0_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T6_Page0_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T6_Page0_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T6_Page0_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T6_Page0_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T6_Page0_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T6_Tail

Kbd_LoadPageGraphics_T6_Page1:: ; 55:68AA
Label_55_68AA::
	ld de, $8801
	ld hl, Gfx_Kbd_T6_Page1_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T6_Page1_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T6_Page1_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T6_Page1_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T6_Page1_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T6_Page1_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T6_Tail

Kbd_LoadPageGraphics_T6_Page2:: ; 55:68E3
Label_55_68E3::
	ld de, $8801
	ld hl, Gfx_Kbd_T6_Page2_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T6_Page2_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T6_Page2_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T6_Page2_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T6_Page2_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T6_Page2_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T6_Tail

Kbd_LoadPageGraphics_T6_Page3:: ; 55:691C
Label_55_691C::
	; [CONFIRMED] ld de,$8801 ; ld hl,$5EC0 ; ld a,$66 ; ld b,$92 ; ld c,$40: argument set-up for
	; the far call of the tile uploader that follows (region 6928); its address $691C is the last
	; word of the code-pointer table before it (55:686F word $691C) [executed in 2 scenarios]
	ld de, $8801
	ld hl, Gfx_Kbd_T6_Page3_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T6_Page3_Tiles8800Vb1)
	ld b, $92
	ld c, $40

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	; [executed in 2 scenarios]
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T6_Page3_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T6_Page3_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T6_Page3_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T6_Page3_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService

Kbd_LoadPageGraphics_T6_Tail:: ; 55:6952
Label_55_6952::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 4/18 scenarios)
	ldh a, [hKbd_LoadPageArg]
	or a, a
	ret z
	ld bc, $0B14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T6And78_PageTail
	ld a, BANK(Tilemap_Kbd_T6And78_PageTail)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap11Rows
	ret

Kbd_LoadPageGraphics_T78:: ; 55:696B
Label_55_696B::
	ld a, [wKbdPage]
	ld hl, Table_Kbd_T78_PageLoaders
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $697C-$6982 (6 bytes) [CONFIRMED] code-pointer table, 3 entries: 3/3 words hit own-bank code starts (start is the operand of ld r16); 3/3 targets executed; every byte read as data in a trace

Table_Kbd_T78_PageLoaders:: ; 55:697C
Table_55_697C::
	dw Kbd_LoadPageGraphics_T78_Page0
	dw Kbd_LoadPageGraphics_T78_Page1
	dw Kbd_LoadPageGraphics_T78_Page2

; ---- ptrtable $6982-$6984 (2 bytes) [PROBABLE] one more code pointer ($6A2F) at the end of the dispatch table that precedes it

Table_Kbd_T78_PageLoaders_Page3:: ; 55:6982
Table_55_6982::
	dw Kbd_LoadPageGraphics_T78_Page3

Kbd_LoadPageGraphics_T78_Page0:: ; 55:6984
Label_55_6984::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 4/18 scenarios)
	ld de, $8801
	ld hl, Gfx_Kbd_T78_Page0_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T78_Page0_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T78_Page0_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T78_Page0_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T78_Page0_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T78_Page0_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T78_Tail

Kbd_LoadPageGraphics_T78_Page1:: ; 55:69BD
Label_55_69BD::
	ld de, $8801
	ld hl, Gfx_Kbd_T78_Page1_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T78_Page1_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T78_Page1_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T78_Page1_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T78_Page1_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T78_Page1_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T78_Tail

Kbd_LoadPageGraphics_T78_Page2:: ; 55:69F6
Label_55_69F6::
	ld de, $8801
	ld hl, Gfx_Kbd_T78_Page2_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T78_Page2_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T78_Page2_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T78_Page2_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T78_Page2_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T78_Page2_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService
	jp Kbd_LoadPageGraphics_T78_Tail

Kbd_LoadPageGraphics_T78_Page3:: ; 55:6A2F
Label_55_6A2F::
	; [CONFIRMED] ld de,$8801 ; ld hl,$6100 ; ld a,$62 ; ld b,$92 ; ld c,$40: argument set-up for
	; the tile uploader that follows at 6A3B; its address is the last word $6A2F of the table at
	; 55:6982 [executed in 4 scenarios]
	ld de, $8801
	ld hl, Gfx_Kbd_T78_Page3_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T78_Page3_Tiles8800Vb1)
	ld b, $92
	ld c, $40

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	; [executed in 4 scenarios]
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T78_Page3_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T78_Page3_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T78_Page3_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T78_Page3_Tiles9000Vb1)
	ld b, $95
	ld c, $24
	farcall Gfx_StartHDMAWithService

Kbd_LoadPageGraphics_T78_Tail:: ; 55:6A65
Label_55_6A65::
	; [CONFIRMED] 68 insn(s); 68 executed (in up to 5/18 scenarios)
	ldh a, [hKbd_LoadPageArg]
	or a, a
	ret z
	ld bc, $0B14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T6And78_PageTail
	ld a, BANK(Tilemap_Kbd_T6And78_PageTail)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap11Rows
	ret

Kbd_LoadPageGraphics_T9:: ; 55:6A7E
Label_55_6A7E::
	ld de, $8801
	ld hl, Gfx_Kbd_T9_Tiles8800Vb1
	ld a, BANK(Gfx_Kbd_T9_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Kbd_T9_Tiles8C00Vb1
	ld a, BANK(Gfx_Kbd_T9_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Kbd_T9_Tiles9000Vb1
	ld a, BANK(Gfx_Kbd_T9_Tiles9000Vb1)
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld bc, $0B14
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T9
	ld a, BANK(Tilemap_Kbd_T9)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap11Rows
	ret

Kbd_LoadPageGraphics_T10:: ; 55:6AC9
Label_55_6AC9::
	ld de, $8A81
	ld hl, Gfx_Kbd_T10_Tiles8A80Vb1
	ld a, BANK(Gfx_Kbd_T10_Tiles8A80Vb1)
	ld b, $96
	ld c, $19
	farcall Gfx_StartHDMAWithService
	ld bc, $0614
	ld de, wScreenTileMap + $240
	ld hl, Tilemap_Kbd_T10
	ld a, BANK(Tilemap_Kbd_T10)
	farcall Tilemap_CopyRectAndAttr
	call Kbd_UploadPanelMap11Rows
	ret

Kbd_UploadPanelMap11Rows:: ; 55:6AF0
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [rLCDC]
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	ld b, $96
	ld c, $16
	ld hl, wScreenTileMap + $240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6B21

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 55:6B16 (executed)
	xor a, a
	farcall Gfx_StartHDMAWithService
	jr .l6B27

.l6B21 ; 55:6B21
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 5/18 scenarios)
	farcall Gfx_StartHDMA
.l6B27 ; 55:6B27
	inc e
	ld b, $96
	ld c, $16
	ld hl, wScreenAttrMap + $240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6B41

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 55:6B36 (executed)
	xor a, a
	farcall Gfx_StartHDMAWithService
	jr .l6B47

.l6B41 ; 55:6B41
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 7/18 scenarios)
	farcall Gfx_StartHDMA
.l6B47 ; 55:6B47
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Kbd_UploadPanelMap13Rows:: ; 55:6B51
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [rLCDC]
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	ld b, $96
	ld c, $1A
	ld hl, wScreenTileMap + $240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6B82
	xor a, a
	farcall Gfx_StartHDMAWithService
	jr .l6B88

.l6B82 ; 55:6B82
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 55:6B77 (executed)
	farcall Gfx_StartHDMA

.l6B88 ; 55:6B88
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 7/18 scenarios)
	inc e
	ld b, $96
	ld c, $1A
	ld hl, wScreenAttrMap + $240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6BA2
	xor a, a
	farcall Gfx_StartHDMAWithService
	jr .l6BA8

.l6BA2 ; 55:6BA2
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 55:6B97 (executed)
	farcall Gfx_StartHDMA

.l6BA8 ; 55:6BA8
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 11/18 scenarios)
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Kbd_ShowPageIndicator:: ; 55:6BB2
	ld a, [wKbdType]
	call Kbd_TypeHasPages
	or a, a
	ret z
	ld a, [wKbdPage]
	inc a
	ld b, a
	ld hl, wSpriteSlot12
	ld de, Kbd_ObjTable_Entry3
	ld a, BANK(Kbd_ObjTable_Entry3)
	farcall Sprite_InitSlot
	ld de, $8808
	ld hl, wSpriteSlot12
	call Sprite_SetPosition
	ret

Kbd_LoadPickerTabTiles:: ; 55:6BD7
	ld a, [wKbdInputMode]
	ld hl, Table_Kbd_PickerTabTilePtrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $8801
	ld b, $95
	ld c, $28
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6C01

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 55:6BF5 (executed)
	ld a, $66
	farcall Gfx_StartHDMAWithService
	jr .done

.l6C01 ; 55:6C01
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, $66
	farcall Gfx_StartHDMA
.done ; 55:6C09
	ret

; ---- data $6C0A-$6C10 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Table_Kbd_PickerTabTilePtrs:: ; 55:6C0A
Data_55_6C0A::
	db $90, $6A, $10, $6D, $90, $6F

Kbd_RequestGlyphRedraw:: ; 55:6C10
Function_55_6C10::
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 11/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $01
	ld [wKbdGlyphDirty], a
	ret

Kbd_DrawGlyphPreview:: ; 55:6C16
	ld a, [wKbdGlyphDirty]
	or a, a
	ret z
	ld hl, wKeyboardCharHi
	ld a, [hl]
	or a, a
	jr z, .l6C28
	cp a, $01
	jr z, .l6C2F
	jr .l6C45
.l6C28 ; 55:6C28
	dec hl
	ld a, [hl]
	call Text_HalfToFullWidth
	jr .l6C48
.l6C2F ; 55:6C2F
	dec hl
	ld a, [hl]
	cp a, $0D
	jr z, .l6C3B
	cp a, $20
	jr z, .l6C40

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 55:6C37 (executed)
	jr .l6C48

.l6C3B ; 55:6C3B
	; [CONFIRMED] 72 insn(s); 72 executed (in up to 11/18 scenarios) (part of region $6C3B-$6CD4)
	ld bc, $83C0
	jr .l6C48
.l6C40 ; 55:6C40
	ld bc, $83BF
	jr .l6C48
.l6C45 ; 55:6C45
	dec hl
	ld b, a
	ld c, [hl]
.l6C48 ; 55:6C48
	ld hl, $0003
	push hl
	ld hl, wKbdGlyphPreviewTiles + $10
	push hl
	ld hl, $0003
	push hl
	ld hl, wKbdGlyphPreviewTiles
	push hl
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wKbdCursorSpriteY]
	ld [wSpriteSlot11], a
	ld a, [wKbdCursorSpriteX]
	ld [wSpriteSlot11 + $01], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	farcall Sprite_UpdateAll
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $8241
	ld hl, wKbdGlyphPreviewTiles
	ld b, $98
	ld c, $02
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, .l6CB2
	xor a, a
	farcall Gfx_StartHDMAWithService
	jr .l6CB8
.l6CB2 ; 55:6CB2
	farcall Gfx_StartHDMA
.l6CB8 ; 55:6CB8
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ld [wKbdGlyphDirty], a
	ret
