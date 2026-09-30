; engine/keyboard/keyboard.asm
; bank 55, $5BA2-$6CC6 (4388 bytes); pinned by layout.link
; on-screen keyboard: open, run, cursor, slide in/out, type picker, page graphics, glyph preview

SECTION "engine/keyboard/keyboard", ROMX

; ---- code $5BA2-$5C9F (253 bytes) [CONFIRMED] 106 insn(s); 106 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_Open:: ; 55:5BA2
Function_55_5BA2::
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
	jr Label_55_5BDD

Label_55_5BDD:: ; 55:5BDD
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
	ld a, $5F
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0018
	ld de, $D868
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld a, [wKbdType]
	call Function_55_6ED6
	or a, a
	jp z, Label_55_5C5A
	ld bc, $0010
	ld de, $D830
	ld hl, Palette_5F_4CD0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr Label_55_5C5A

Label_55_5C5A:: ; 55:5C5A
	ld a, [wKbdMode]
	cp a, $02
	jr nz, Label_55_5C71
	call Kbd_ShowInstant
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392

Label_55_5C71:: ; 55:5C71
	ld a, $01
	call Kbd_LoadPageGraphics
	ld hl, $DAB0
	ld de, Table_5F_4CF8
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld a, $FF
	ld [wSpriteSlots + 180], a
	call Function_55_617B
	ret

Kbd_Run:: ; 55:5C8F
	ld a, c
	ld [wRam_C2B4], a
	ld a, $01
	ld [wRam_C2B3], a
	ld a, [wKbdType]
	cp a, $05
	jr nz, Label_55_5CA3

; ---- code $5C9F-$5CA3 (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 55:5C9D (executed) [executed in 4 scenarios]
	ld a, b
	ld [wRam_C2B3], a

; ---- code $5CA3-$5D3D (154 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 11/18 scenarios)

Label_55_5CA3:: ; 55:5CA3
	xor a, a
	ld [wKbdGlyphDirty], a
	ld a, [wKbdType]
	cp a, $0A
	jp z, Label_55_6563
	ld a, [wKbdMode]
	cp a, $02
	jr z, Label_55_5CBC
	cp a, $00
	jr z, Label_55_5CDD
	jr Label_55_5CE0

Label_55_5CBC:: ; 55:5CBC
	ld a, [wKbdType]
	call Function_55_6EAA
	or a, a
	jr z, Label_55_5CE0
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
	jr Label_55_5CE0

Label_55_5CDD:: ; 55:5CDD
	call Kbd_SlideIn

Label_55_5CE0:: ; 55:5CE0
	ld a, [wKbdType]
	call Function_55_6EC0
	or a, a
	jr z, Label_55_5D05
	ld a, [wRam_C2B4]
	or a, a
	jr z, Label_55_5D05
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

Label_55_5D05:: ; 55:5D05
	ld a, $01
	ld [wKbdMode], a
	call Kbd_FetchCell
	call Kbd_UpdateCursorSprite
	ld a, [wKbdType]
	cp a, $07
	jr nz, Label_55_5D36
	ld a, [wRam_C2B4]
	or a, a
	jr z, Label_55_5D36
	ld hl, $DAD0
	ld de, $4D40
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	ld de, $7870
	ld hl, $DAD0
	call Function_00_0A65

Label_55_5D36:: ; 55:5D36
	ld a, [wKbdType]
	cp a, $05
	jr nz, Kbd_Run_Loop

; ---- code $5D3D-$5D49 (12 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 55:5D3B (executed) [executed in 4 scenarios]
	call Kbd_HideMarkerSprite
	ld a, [wRam_C2B3]
	or a, a
	jr nz, Kbd_Run_Loop
	call Kbd_ShowMarkerSprite

; ---- code $5D49-$5D70 (39 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 11/18 scenarios)

Kbd_Run_Loop:: ; 55:5D49
	call Kbd_DrawGlyphPreview
	farcall Joypad_Update
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_5D66
	call Function_00_044B
	jr Label_55_5D69

Label_55_5D66:: ; 55:5D66
	call Function_00_0464

Label_55_5D69:: ; 55:5D69
	ld a, [wKbdType]
	cp a, $05
	jr nz, Label_55_5D76

; ---- code $5D70-$5D76 (6 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 55:5D6E (executed) [executed in 4 scenarios]
	farcall ConnectDialog_RefreshFieldIfDirty

; ---- code $5D76-$5DF5 (127 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 11/18 scenarios)

Label_55_5D76:: ; 55:5D76
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_55_5D9A
	bit 1, a
	jr nz, Label_55_5D9D
	bit 6, a
	jr nz, Label_55_5DB6
	bit 7, a
	jr nz, Label_55_5DC1
	bit 5, a
	jr nz, Label_55_5DA0
	bit 4, a
	jr nz, Label_55_5DAB
	bit 3, a
	jr nz, Label_55_5DCC
	bit 2, a
	jr nz, Label_55_5E02
	jr Kbd_Run_Loop

Label_55_5D9A:: ; 55:5D9A
	jp Kbd_Run_ButtonA

Label_55_5D9D:: ; 55:5D9D
	jp Label_55_5F1A

Label_55_5DA0:: ; 55:5DA0
	ld a, $00
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Label_55_5E5A

Label_55_5DAB:: ; 55:5DAB
	ld a, $01
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Label_55_5E5A

Label_55_5DB6:: ; 55:5DB6
	ld a, $02
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Label_55_5E5A

Label_55_5DC1:: ; 55:5DC1
	ld a, $03
	call Kbd_MoveCursor
	call Kbd_UpdateCursorSprite
	jp Label_55_5E5A

Label_55_5DCC:: ; 55:5DCC
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
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_55_5E5A

; ---- code $5DF5-$5E02 (13 bytes) [HYPOTHESIS] 13-byte routine ld a,[$C2AB] ; call $6EEC ; or a ; jp z,$5E5A ; jp $5F29 - the state variable and the jp targets match the neighbouring CONFIRMED handlers, and it calls the (now classified) lookup routine 6EEC; no branch into it found [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	ld a, [wKbdType]
	call Function_55_6EEC
	or a, a
	jp z, Label_55_5E5A
	jp Label_55_5F29

; ---- code $5E02-$5E30 (46 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 4/18 scenarios)

Label_55_5E02:: ; 55:5E02
	ld a, [wKbdType]
	cp a, $05
	jr z, Label_55_5E42
	cp a, $01
	jr z, Label_55_5E57
	ld a, [wKbdType]
	call Kbd_TypeHasPages
	or a, a
	jp z, Kbd_Run_Loop
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003A
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $C2AC
	ld a, [hl]
	inc a
	cp a, $04
	jr nz, Label_55_5E31

; ---- code $5E30-$5E31 (1 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 55:5E2E (executed) [executed in 3 scenarios]
	xor a, a

; ---- code $5E31-$5E42 (17 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_55_5E31:: ; 55:5E31
	ld [hl], a
	call Kbd_FetchCell
	call Kbd_RequestGlyphRedraw
	xor a, a
	call Kbd_LoadPageGraphics
	call Kbd_ShowPageIndicator
	jp Kbd_Run_Loop

; ---- code $5E42-$5E57 (21 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 55:5E07 (executed) [executed in 4 scenarios]

Label_55_5E42:: ; 55:5E42
	ld a, [wRam_C2B3]
	or a, a
	jr nz, Label_55_5E4B
	jp Kbd_Run_Loop

Label_55_5E4B:: ; 55:5E4B
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jp Label_55_5F26

; ---- code $5E57-$5E75 (30 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 10/18 scenarios)

Label_55_5E57:: ; 55:5E57
	jp Label_55_5F26

Label_55_5E5A:: ; 55:5E5A
	jp Kbd_Run_Loop

Kbd_Run_ButtonA:: ; 55:5E5D
	ld hl, $C2AE
	ld a, [hld]
	cp a, $01
	jr z, Label_55_5E6C
	cp a, $FF
	jr z, Label_55_5E99
	jp Label_55_5F09

Label_55_5E6C:: ; 55:5E6C
	ld a, [hl]
	cp a, $0D
	jr z, Label_55_5E78
	cp a, $20
	jr z, Label_55_5E7B

; ---- code $5E75-$5E78 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 55:5E73 (executed) | 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5E75-5E7B by apply_coverage --split
	jp Label_55_5F09

; ---- code $5E78-$5E7B (3 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 5E75-5E7B by apply_coverage --split [executed in 5 scenarios]

Label_55_5E78:: ; 55:5E78
	jp Label_55_5F1D

; ---- code $5E7B-$5E82 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_55_5E7B:: ; 55:5E7B
	ld a, [wKbdType]
	cp a, $03
	jr nz, Label_55_5E8E

; ---- code $5E82-$5E8E (12 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 55:5E80 (executed)
	ld hl, $C2AE
	ld a, $00
	ld [hld], a
	ld a, $20
	ld [hl], a
	jp Label_55_5F17

; ---- code $5E8E-$5EAA (28 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 9/18 scenarios)

Label_55_5E8E:: ; 55:5E8E
	ld hl, $C2AE
	ld a, $81
	ld [hld], a
	ld a, $40
	ld [hl], a
	jr Label_55_5F17

Label_55_5E99:: ; 55:5E99
	ld a, [hl]
	cp a, $80
	jr z, Label_55_5EAC
	cp a, $81
	jr z, Label_55_5EB7
	cp a, $82
	jr z, Label_55_5EB9
	cp a, $83
	jr z, Label_55_5EE7

; ---- code $5EAA-$5EB9 (15 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 55:5EA8 (executed)
	jr Label_55_5F09

Label_55_5EAC:: ; 55:5EAC
	ld hl, $C2AE
	ld a, $00
	ld [hld], a
	ld a, $20
	ld [hl], a
	jr Label_55_5F17

Label_55_5EB7:: ; 55:5EB7
	jr Label_55_5F1D

; ---- code $5EB9-$5EC0 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 9/18 scenarios)

Label_55_5EB9:: ; 55:5EB9
	ld a, [wRam_C2B3]
	or a, a
	jp nz, Label_55_5ED3

; ---- code $5EC0-$5ED3 (19 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jpcc at 55:5EBD (executed) [executed in 4 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Kbd_Run_Loop

; ---- code $5ED3-$5EEE (27 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 9/18 scenarios)

Label_55_5ED3:: ; 55:5ED3
	ld a, [wKbdType]
	call Function_55_6F02
	or a, a
	jr z, Label_55_5F23
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jr Label_55_5F23

Label_55_5EE7:: ; 55:5EE7
	ld a, [wKbdType]
	cp a, $07
	jr nz, Label_55_5EF5

; ---- code $5EEE-$5EF5 (7 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 55:5EEC (executed) [executed in 1 scenarios]
	ld a, [wRam_C2B4]
	or a, a
	jp nz, Kbd_Run_Loop

; ---- code $5EF5-$5EFE (9 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 4/18 scenarios)

Label_55_5EF5:: ; 55:5EF5
	ld a, [wKbdType]
	call Function_55_6F18
	or a, a
	jr z, Label_55_5F20

; ---- code $5EFE-$5F09 (11 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 55:5EFC (executed) [executed in 4 scenarios]
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	jr Label_55_5F20

; ---- code $5F09-$5F1D (20 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 10/18 scenarios)

Label_55_5F09:: ; 55:5F09
	ld a, [wKbdType]
	cp a, $01
	jr nz, Label_55_5F17
	call Kbd_RejectSymbol
	or a, a
	jp nz, Label_55_5E5A

Label_55_5F17:: ; 55:5F17
	ld a, $01
	ret

Label_55_5F1A:: ; 55:5F1A
	ld a, $02
	ret

; ---- code $5F1D-$5F20 (3 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 2; entered by jp from 55:5E78 (PROBABLE code) [executed in 3 scenarios]

Label_55_5F1D:: ; 55:5F1D
	ld a, $03
	ret

; ---- code $5F20-$5F29 (9 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 9/18 scenarios)

Label_55_5F20:: ; 55:5F20
	ld a, $08
	ret

Label_55_5F23:: ; 55:5F23
	ld a, $07
	ret

Label_55_5F26:: ; 55:5F26
	ld a, $0A
	ret

; ---- code $5F29-$5F35 (12 bytes) [HYPOTHESIS] xor a ; call $6427 ; ld a,0 ; ld [$C2AF],a ; ld a,9 ; ret - target of the jp $5F29 at 55:5DFF, sibling of the "ld a,N ; ret" handlers at 5F1D/5F20 [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS; its only jumper is the HYPOTHESIS routine 5DF5]

Label_55_5F29:: ; 55:5F29
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	ld a, $09
	ret

; ---- code $5F35-$5FC8 (147 bytes) [CONFIRMED] 98 insn(s); 98 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_FetchCell:: ; 55:5F35
Function_55_5F35::
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
	ld de, $C2AE
	ld a, [hli]
	ld [de], a
	dec de
	ld a, [hl]
	ld [de], a
	call Kbd_RequestGlyphRedraw
	ret

Kbd_MoveCursor:: ; 55:5F66
	push af
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
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
	ld [wRam_C2B7], a
	ld a, [hl]
	ld [wRam_C2B8], a
	pop hl
	pop af
	push af
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld [wRam_C2B6], a
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

Table_55_5FC8:: ; 55:5FC8
	dw $5FD0, $5FF4, $5FFD, $6020

; ---- code $5FD0-$604D (125 bytes) [CONFIRMED] 51 insn(s); 51 executed (in up to 8/18 scenarios)
	ld a, [wRam_C2B7]
	bit 7, a
	jp z, Label_55_602E

Label_55_5FD8:: ; 55:5FD8
	ld a, [wKbdStickyRow]
	cp a, $FF
	jr z, Label_55_602E
	ld a, [wRam_C2B6]
	call Kbd_IndexToColRow
	call Function_55_6041
	ld a, [wKbdStickyRow]
	ld c, a
	call Kbd_ColRowToIndex
	ld [wKbdCursorCell], a
	jr Label_55_6029

	ld a, [wRam_C2B7]
	bit 6, a
	jr z, Label_55_602E
	jr Label_55_5FD8

	ld a, [wRam_C2B7]
	bit 5, a
	jr z, Label_55_602E

Label_55_6004:: ; 55:6004
	ld a, [wKbdStickyCol]
	cp a, $FF
	jr z, Label_55_602E
	ld a, [wRam_C2B6]
	call Kbd_IndexToColRow
	call Function_55_6041
	ld a, [wKbdStickyCol]
	ld b, a
	call Kbd_ColRowToIndex
	ld [wKbdCursorCell], a
	jr Label_55_6029

	ld a, [wRam_C2B7]
	bit 4, a
	jr z, Label_55_602E
	jr Label_55_6004

Label_55_6029:: ; 55:6029
	call Function_55_6068
	jr Label_55_603D

Label_55_602E:: ; 55:602E
	ld a, [wKbdCursorCell]
	call Kbd_SplitCursorIndex
	call Function_55_6068
	ld a, [wRam_C2B6]
	ld [wKbdCursorCell], a

Label_55_603D:: ; 55:603D
	call Kbd_FetchCell
	ret

Function_55_6041:: ; 55:6041
	ld a, [wKbdType]
	cp a, $01
	jr z, Label_55_604D
	cp a, $03
	jr z, Label_55_605A
	ret

; ---- code $604D-$605A (13 bytes) [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 1; entered by jrcc from 55:6046 (executed) | 8 insn(s) executed; cut out of the PROBABLE region 604D-6068 by apply_coverage --split [executed in 1 scenarios]

Label_55_604D:: ; 55:604D
	ld a, [wKbdMoveDirection]
	or a, a
	ret nz
	ld a, [wKbdStickyRow]
	cp a, $03
	ret nz
	inc b
	ret

; ---- code $605A-$6068 (14 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 604D-6068 by apply_coverage --split

Label_55_605A:: ; 55:605A
	ld a, [wKbdMoveDirection]
	cp a, $02
	ret nz
	ld a, [wKbdStickyCol]
	cp a, $11
	ret nz
	inc c
	ret

; ---- code $6068-$6087 (31 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 8/18 scenarios); entry proven: target of an executed call/far call

Function_55_6068:: ; 55:6068
	ld a, [wKeyboardCharHi]
	cp a, $FF
	jr z, Label_55_60E1
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

Table_55_6087:: ; 55:6087
	dw $608F, $60A0, $60B1, $60C2

; ---- code $608F-$60F1 (98 bytes) [CONFIRMED] 45 insn(s); 45 executed (in up to 7/18 scenarios)
	ld a, [wRam_C2B8]
	bit 7, a
	call nz, Function_55_60D3
	ld a, [wRam_C2B8]
	bit 3, a
	call nz, Function_55_60DA
	ret

	ld a, [wRam_C2B8]
	bit 6, a
	call nz, Function_55_60D3
	ld a, [wRam_C2B8]
	bit 2, a
	call nz, Function_55_60DA
	ret

	ld a, [wRam_C2B8]
	bit 5, a
	call nz, Function_55_60D3
	ld a, [wRam_C2B8]
	bit 1, a
	call nz, Function_55_60DA
	ret

	ld a, [wRam_C2B8]
	bit 4, a
	call nz, Function_55_60D3
	ld a, [wRam_C2B8]
	bit 0, a
	call nz, Function_55_60DA
	ret

Function_55_60D3:: ; 55:60D3
	ld a, [wKbdCursorCol]
	ld [wKbdStickyCol], a
	ret

Function_55_60DA:: ; 55:60DA
	ld a, [wKbdCursorRow]
	ld [wKbdStickyRow], a
	ret

Label_55_60E1:: ; 55:60E1
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

Table_55_60F1:: ; 55:60F1
	dw $60F9, $610A, $611B, $612C

; ---- code $60F9-$6184 (139 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 11/18 scenarios)
	ld a, [wRam_C2B8]
	bit 7, a
	call z, Function_55_613D
	ld a, [wRam_C2B8]
	bit 3, a
	call z, Function_55_6143
	ret

	ld a, [wRam_C2B8]
	bit 6, a
	call z, Function_55_613D
	ld a, [wRam_C2B8]
	bit 2, a
	call z, Function_55_6143
	ret

	ld a, [wRam_C2B8]
	bit 5, a
	call z, Function_55_613D
	ld a, [wRam_C2B8]
	bit 1, a
	call z, Function_55_6143
	ret

	ld a, [wRam_C2B8]
	bit 4, a
	call z, Function_55_613D
	ld a, [wRam_C2B8]
	bit 0, a
	call z, Function_55_6143
	ret

Function_55_613D:: ; 55:613D
	ld a, $FF
	ld [wKbdStickyCol], a
	ret

Function_55_6143:: ; 55:6143
	ld a, $FF
	ld [wKbdStickyRow], a
	ret

Kbd_SplitCursorIndex:: ; 55:6149
	ld a, [wKbdCursorCell]
	ld b, $00

Label_55_614E:: ; 55:614E
	sub a, $12
	jr c, Label_55_6155
	inc b
	jr Label_55_614E

Label_55_6155:: ; 55:6155
	add a, $12
	ld [wKbdCursorCol], a
	ld a, b
	ld [wKbdCursorRow], a
	ret

Kbd_IndexToColRow:: ; 55:615F
	ld b, $00

Label_55_6161:: ; 55:6161
	sub a, $12
	jr c, Label_55_6168
	inc b
	jr Label_55_6161

Label_55_6168:: ; 55:6168
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

Function_55_617B:: ; 55:617B
	ld a, $FF
	ld [wKbdStickyCol], a
	ld [wKbdStickyRow], a
	ret

; ---- code $6184-$6190 (12 bytes) [HYPOTHESIS] two 6-byte routines (ld a,$FF ; ld [$C2BD],a ; ret) and (ld a,$FF ; ld [$C2BE],a ; ret): siblings of the called routines 613D/6143 and of 617B (which writes both); nothing calls them
	ld a, $FF
	ld [wKbdStickyCol], a
	ret

	ld a, $FF
	ld [wKbdStickyRow], a
	ret

; ---- code $6190-$624D (189 bytes) [CONFIRMED] 103 insn(s); 103 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_UpdateCursorSprite:: ; 55:6190
Function_55_6190::
	call Kbd_SplitCursorIndex
	ld a, [wKbdType]
	ld hl, Data_55_62A0
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	ld hl, $C2AE
	ld a, [hld]
	cp a, $FF
	jr z, Label_55_61BF
	push bc
	ld hl, $DAB0
	ld de, Table_5F_4CF8
	ld a, $5F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	jr Label_55_61F6

Label_55_61BF:: ; 55:61BF
	push bc
	ld hl, $DAB0
	ld de, Table_5F_4CF8
	ld a, $5F
	ld b, $82
	farcall Function_00_0A82
	pop bc
	ld a, [wKbdType]
	ld hl, Table_55_62B4
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

Label_55_61F6:: ; 55:61F6
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
	jr nz, Label_55_623B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	ld [wSpriteSlots + 176], a
	ld a, d
	ld [wSpriteSlots + 177], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]

Label_55_623B:: ; 55:623B
	ld a, [wKeyboardCharHi]
	cp a, $FF
	jr nz, Label_55_6299
	ld a, [wKeyboardCharLo]
	cp a, $82
	jr z, Label_55_624F
	cp a, $83
	jr z, Label_55_6261

; ---- code $624D-$624F (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 55:624B (executed)
	jr Label_55_629F

; ---- code $624F-$62A0 (81 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 11/18 scenarios)

Label_55_624F:: ; 55:624F
	ld hl, $DAA0
	ld de, $4D18
	ld a, $5F
	ld b, $85
	farcall Function_00_0A82
	jr Label_55_6271

Label_55_6261:: ; 55:6261
	ld hl, $DAA0
	ld de, $4D18
	ld a, $5F
	ld b, $84
	farcall Function_00_0A82

Label_55_6271:: ; 55:6271
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 176]
	sub a, $09
	ld [wSpriteSlots + 160], a
	ld a, [wSpriteSlots + 177]
	sub a, $02
	ld [wSpriteSlots + 161], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr Label_55_629F

Label_55_6299:: ; 55:6299
	ld hl, $DAA0
	call Function_00_09E6

Label_55_629F:: ; 55:629F
	ret

; ---- data $62A0-$62B4 (20 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 62A0-62B4 that executed code reads piecewise [split by classify_g2]

Data_55_62A0:: ; 55:62A0
	db $34, $07, $34, $07, $34, $07, $2C, $07, $2C, $07, $2C, $07, $3C, $07, $3C, $07
	db $3C, $07, $3C, $07

; ---- ptrtable $62B4-$62C8 (20 bytes) [PROBABLE] little-endian word table, 10 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $62C8..$6310; referenced by ld r16,$62B4 at 55:61D4

Table_55_62B4:: ; 55:62B4
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

; ---- code $6318-$636D (85 bytes) [CONFIRMED] 32 insn(s); 32 executed (in up to 5/18 scenarios); entry proven: target of an executed call/far call

Kbd_SlideIn:: ; 55:6318
Function_55_6318::
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Kbd_GetSlideTargetY
	ld [wRam_C2A2], a
	ld a, [wKbdType]
	cp a, $06
	jr nz, Label_55_6348
	farcall KbdSlide_InPrepMode6

Label_55_6348:: ; 55:6348
	cp a, $08
	jr nz, Label_55_6352
	farcall KbdSlide_InPrepMode8

Label_55_6352:: ; 55:6352
	cp a, $09
	jr nz, Label_55_635C
	farcall KbdSlide_InPrepMode9

Label_55_635C:: ; 55:635C
	cp a, $07
	jr nz, Label_55_6366
	farcall KbdSlide_InPrepMode7

Label_55_6366:: ; 55:6366
	ld a, [wKbdType]
	cp a, $05
	jr nz, Label_55_6386

; ---- code $636D-$6381 (20 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 55:636B (executed) | 7 insn(s) executed; cut out of the PROBABLE region 636D-6386 by apply_coverage --split [executed in 4 scenarios]
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6381
	call Function_00_044B
	jr Label_55_6384

; ---- code $6381-$6384 (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 636D-6386 by apply_coverage --split

Label_55_6381:: ; 55:6381
	call Function_00_0464

; ---- code $6384-$6386 (2 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 636D-6386 by apply_coverage --split [executed in 4 scenarios]

Label_55_6384:: ; 55:6384
	jr Label_55_63D2

; ---- code $6386-$63CD (71 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 5/18 scenarios)

Label_55_6386:: ; 55:6386
	ld a, [wKbdType]
	cp a, $06
	jr nz, Label_55_639A
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_InStepMode6
	jr Label_55_63D2

Label_55_639A:: ; 55:639A
	cp a, $08
	jr nz, Label_55_63AB
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_InStepMode8
	jr Label_55_63D2

Label_55_63AB:: ; 55:63AB
	cp a, $09
	jr nz, Label_55_63BC
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_InStepMode9
	jr Label_55_63D2

Label_55_63BC:: ; 55:63BC
	cp a, $07
	jr nz, Label_55_63CD
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_InStepMode7
	jr Label_55_63D2

; ---- code $63CD-$63D2 (5 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 55:63BE (executed)

Label_55_63CD:: ; 55:63CD
	push de
	call Function_00_0464
	pop de

; ---- code $63D2-$641C (74 bytes) [CONFIRMED] 38 insn(s); 38 executed (in up to 11/18 scenarios)

Label_55_63D2:: ; 55:63D2
	ld hl, $FF4A
	ld a, [hl]
	sub a, $08
	ld [hl], a
	push af
	ld a, [wRam_C2A2]
	ld b, a
	pop af
	cp a, b
	jp nz, Label_55_6366
	call Kbd_ShowPageIndicator
	ret

Kbd_ShowInstant:: ; 55:63E7
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_63F5
	call Function_00_044B
	jr Label_55_63F8

Label_55_63F5:: ; 55:63F5
	call Function_00_0464

Label_55_63F8:: ; 55:63F8
	call Kbd_GetSlideTargetY
	ldh [rWY], a
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	call Kbd_ShowPageIndicator
	ret

Kbd_GetSlideTargetY:: ; 55:640E
	ld a, [wKbdType]
	ld hl, Data_55_641C
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ret

; ---- data $641C-$6427 (11 bytes) [PROBABLE] zero/short bytes of the keyboard page tables between text rows; part of the run 641C-6427 that executed code reads piecewise [split by classify_g2]

Data_55_641C:: ; 55:641C
	db $28, $28, $28, $28, $28, $28, $38, $38, $38, $38, $38

; ---- code $6427-$644E (39 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Kbd_SlideOut:: ; 55:6427
Function_55_6427::
	ld hl, $DAA0
	call Function_00_09E6
	ld hl, $DAB0
	call Function_00_09E6
	ld hl, $DAC0
	call Function_00_09E6
	ld hl, $DAD0
	call Function_00_09E6
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6453

; ---- code $644E-$6453 (5 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 55:644C (executed) [executed in 4 scenarios]
	call Function_00_044B
	jr Label_55_6456

; ---- code $6453-$649D (74 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 4/18 scenarios)

Label_55_6453:: ; 55:6453
	call Function_00_0464

Label_55_6456:: ; 55:6456
	ldh a, [rWY]
	cp a, $90
	ret nc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0035
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wKbdType]
	cp a, $06
	jr nz, Label_55_6478
	farcall KbdSlide_OutPrepMode6

Label_55_6478:: ; 55:6478
	cp a, $08
	jr nz, Label_55_6482
	farcall KbdSlide_OutPrepMode8

Label_55_6482:: ; 55:6482
	cp a, $09
	jr nz, Label_55_648C
	farcall KbdSlide_OutPrepMode9

Label_55_648C:: ; 55:648C
	cp a, $07
	jr nz, Label_55_6496
	farcall KbdSlide_OutPrepMode7

Label_55_6496:: ; 55:6496
	ld a, [wKbdType]
	cp a, $05
	jr nz, Label_55_64B6

; ---- code $649D-$64B1 (20 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 55:649B (executed) | 7 insn(s) executed; cut out of the PROBABLE region 649D-64B6 by apply_coverage --split [executed in 4 scenarios]
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_64B1
	call Function_00_044B
	jr Label_55_64B4

; ---- code $64B1-$64B4 (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 649D-64B6 by apply_coverage --split

Label_55_64B1:: ; 55:64B1
	call Function_00_0464

; ---- code $64B4-$64B6 (2 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 649D-64B6 by apply_coverage --split [executed in 4 scenarios]

Label_55_64B4:: ; 55:64B4
	jr Label_55_6502

; ---- code $64B6-$6548 (146 bytes) [CONFIRMED] 60 insn(s); 60 executed (in up to 8/18 scenarios)

Label_55_64B6:: ; 55:64B6
	ld a, [wKbdType]
	cp a, $06
	jr nz, Label_55_64CA
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_OutStepMode6
	jr Label_55_6502

Label_55_64CA:: ; 55:64CA
	cp a, $08
	jr nz, Label_55_64DB
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_OutStepMode8
	jr Label_55_6502

Label_55_64DB:: ; 55:64DB
	cp a, $09
	jr nz, Label_55_64EC
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_OutStepMode9
	jr Label_55_6502

Label_55_64EC:: ; 55:64EC
	cp a, $07
	jr nz, Label_55_64FD
	push de
	call Function_00_0464
	pop de
	farcall KbdSlide_OutStepMode7
	jr Label_55_6502

Label_55_64FD:: ; 55:64FD
	push de
	call Function_00_0464
	pop de

Label_55_6502:: ; 55:6502
	ld hl, $FF4A
	ld a, [hl]
	add a, $08
	ld [hl], a
	cp a, $90
	jp c, Label_55_6496
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ret

Kbd_HideInstant:: ; 55:651C
	ld hl, $DAA0
	call Function_00_09E6
	ld hl, $DAB0
	call Function_00_09E6
	ld hl, $DAC0
	call Function_00_09E6
	ld hl, $DAD0
	call Function_00_09E6
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6548
	call Function_00_044B
	jr Label_55_654B

; ---- code $6548-$654B (3 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 55:6541 (executed) [executed in 1 scenarios]

Label_55_6548:: ; 55:6548
	call Function_00_0464

; ---- code $654B-$658F (68 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 8/18 scenarios)

Label_55_654B:: ; 55:654B
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ret

Kbd_Hide:: ; 55:6559
	xor a, a
	call Kbd_SlideOut
	ld a, $00
	ld [wKbdMode], a
	ret

Label_55_6563:: ; 55:6563
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0034
	call Function_00_20AC
	pop af
	ldh [rSVBK], a

Label_55_6580:: ; 55:6580
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6594

; ---- code $658F-$6594 (5 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 55:658D (executed)
	call Function_00_044B
	jr Label_55_6597

; ---- code $6594-$65D7 (67 bytes) [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios)

Label_55_6594:: ; 55:6594
	call Function_00_0464

Label_55_6597:: ; 55:6597
	ldh a, [rWY]
	sub a, $08
	cp a, $80
	jr nz, Label_55_65A4
	push af
	call Kbd_LoadPickerTabTiles
	pop af

Label_55_65A4:: ; 55:65A4
	ldh [rWY], a
	cp a, $60
	jp nz, Label_55_6580
	call Kbd_TypePickerLoop
	push af
	call Kbd_SlideOut
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	call Kbd_SaveInputMode
	pop af
	or a, a
	jr nz, Label_55_65C9
	ld a, $09
	ret

Label_55_65C9:: ; 55:65C9
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

; ---- code $65DA-$6602 (40 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Kbd_TypePickerLoop:: ; 55:65DA
Function_55_65DA::
	ld hl, $DAB0
	ld de, Table_5F_4CF8
	ld a, $5F
	ld b, $82
	farcall Function_00_0A82

Label_55_65EA:: ; 55:65EA
	call Kbd_UpdatePickerSprites

Label_55_65ED:: ; 55:65ED
	farcall Joypad_Update
	farcall Function_00_0956
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6607

; ---- code $6602-$6607 (5 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 55:6600 (executed)
	call Function_00_044B
	jr Label_55_660A

; ---- code $6607-$6662 (91 bytes) [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)

Label_55_6607:: ; 55:6607
	call Function_00_0464

Label_55_660A:: ; 55:660A
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_55_661E
	bit 1, a
	jr nz, Label_55_6622
	bit 5, a
	jr nz, Label_55_6626
	bit 4, a
	jr nz, Label_55_6646
	jr Label_55_65ED

Label_55_661E:: ; 55:661E
	ld a, $01
	jr Label_55_6666

Label_55_6622:: ; 55:6622
	ld a, $00
	jr Label_55_6666

Label_55_6626:: ; 55:6626
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $C2BC
	ld a, [hl]
	or a, a
	jr z, Label_55_6641
	dec a
	ld [hl], a
	jr Label_55_65EA

Label_55_6641:: ; 55:6641
	ld a, $02
	ld [hl], a
	jr Label_55_65EA

Label_55_6646:: ; 55:6646
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $C2BC
	ld a, [hl]
	cp a, $02
	jr z, Label_55_6662
	inc a
	ld [hl], a
	jr Label_55_65EA

; ---- code $6662-$6666 (4 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 55:665C (executed) [executed in 1 scenarios]

Label_55_6662:: ; 55:6662
	xor a, a
	ld [hl], a
	jr Label_55_65EA

; ---- code $6666-$66C0 (90 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 2/18 scenarios)

Label_55_6666:: ; 55:6666
	push af
	ld hl, $DAA0
	call Function_00_09E6
	ld hl, $DAB0
	call Function_00_09E6
	farcall Function_00_0956
	pop af
	ret

Kbd_UpdatePickerSprites:: ; 55:667B
	ld hl, Data_55_66C0
	ld a, [wKbdInputMode]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld d, $66
	ld e, a
	ld hl, $DAB0
	call Function_00_0A65
	ld a, [wKbdInputMode]
	inc a
	set 7, a
	ld b, a
	ld hl, $DAA0
	ld de, $4D18
	ld a, $5F
	farcall Function_00_0A82
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
	ld hl, $DAA0
	call Function_00_0A65
	call Kbd_LoadPickerTabTiles
	ret

; ---- data $66C0-$66C6 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_55_66C0:: ; 55:66C0
	db $1E, $46, $6E, $1C, $44, $6C

; ---- code $66C6-$66D9 (19 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_LoadPageGraphics:: ; 55:66C6
Function_55_66C6::
	ldh [hRam_FFB0], a
	ld a, [wKbdType]
	ld hl, Table_55_66D9
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

Table_55_66D9:: ; 55:66D9
	dw Label_55_66EF
	dw Label_55_6704
	dw Label_55_672B
	dw Label_55_6740
	dw Label_55_6755
	dw Label_55_679F
	dw Label_55_6858
	dw Label_55_696B
	dw Label_55_696B
	dw Label_55_6A7E
	dw Label_55_6AC9

; ---- code $66EF-$672B (60 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 3/18 scenarios)

Label_55_66EF:: ; 55:66EF
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_4ECB
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

Label_55_6704:: ; 55:6704
	ld de, $8800
	ld hl, Data_5E_57E0
	ld a, $5E
	ld b, $98
	ld c, $02
	farcall Function_00_0787
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_50D3
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

; ---- code $672B-$6755 (42 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: site x6, table x8; min discovery hops 0; run starts at an entry of the code-pointer table at 55:66D9 [executed in 1 scenarios]

Label_55_672B:: ; 55:672B
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_54E3
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

Label_55_6740:: ; 55:6740
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_56EB
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

; ---- code $6755-$679F (74 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 7/18 scenarios)

Label_55_6755:: ; 55:6755
	ld de, $8801
	ld hl, Data_5D_4000
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5D_4400
	ld a, $5D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0018
	ld de, $D828
	ld hl, $4D28
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_52DB
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

; ---- code $679F-$6858 (185 bytes) [CONFIRMED] 69 insn(s) reached by static flow only; seeds: site x64, table x5; min discovery hops 0; run starts at an entry of the code-pointer table at 55:66D9 [executed in 4 scenarios]

Label_55_679F:: ; 55:679F
	ld de, $8801
	ld hl, Data_5F_5900
	ld a, $5F
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5F_5D00
	ld a, $5F
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_5F_6100
	ld a, $5F
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld bc, $0008
	ld de, $D808
	ld hl, Data_5F_6BB8
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld bc, $0010
	ld de, $D830
	ld hl, $6BC0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
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
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld bc, $0D14
	ld de, $D240
	ld hl, Data_5F_69B0
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap13Rows
	ret

; ---- code $6858-$6869 (17 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)

Label_55_6858:: ; 55:6858
	ld a, [wKbdPage]
	ld hl, Table_55_6869
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

Table_55_6869:: ; 55:6869
	dw Label_55_6871
	dw Label_55_68AA
	dw Label_55_68E3

; ---- ptrtable $686F-$6871 (2 bytes) [PROBABLE] one more code pointer ($691C) at the end of the dispatch table that precedes it; target = the code classified at 691C

Table_55_686F:: ; 55:686F
	dw Label_55_691C

; ---- code $6871-$691C (171 bytes) [CONFIRMED] 57 insn(s); 57 executed (in up to 2/18 scenarios)

Label_55_6871:: ; 55:6871
	ld de, $8801
	ld hl, Data_66_4000
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_66_4400
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_66_4800
	ld a, $66
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6952

Label_55_68AA:: ; 55:68AA
	ld de, $8801
	ld hl, Data_66_4A40
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_66_4E40
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_66_5240
	ld a, $66
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6952

Label_55_68E3:: ; 55:68E3
	ld de, $8801
	ld hl, Data_66_5480
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_66_5880
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_66_5C80
	ld a, $66
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6952

; ---- code $691C-$6928 (12 bytes) [CONFIRMED] ld de,$8801 ; ld hl,$5EC0 ; ld a,$66 ; ld b,$92 ; ld c,$40: argument set-up for the far call of the tile uploader that follows (region 6928); its address $691C is the last word of the code-pointer table before it (55:686F word $691C) [executed in 2 scenarios]

Label_55_691C:: ; 55:691C
	ld de, $8801
	ld hl, $5EC0
	ld a, $66
	ld b, $92
	ld c, $40

; ---- code $6928-$6952 (42 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code [executed in 2 scenarios]
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_66_62C0
	ld a, $66
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_66_66C0
	ld a, $66
	ld b, $95
	ld c, $24
	farcall Function_00_0787

; ---- code $6952-$697C (42 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 4/18 scenarios)

Label_55_6952:: ; 55:6952
	ldh a, [hRam_FFB0]
	or a, a
	ret z
	ld bc, $0B14
	ld de, $D240
	ld hl, Data_66_7210
	ld a, $66
	farcall Function_00_08EA
	call Kbd_UploadPanelMap11Rows
	ret

Label_55_696B:: ; 55:696B
	ld a, [wKbdPage]
	ld hl, Table_55_697C
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

Table_55_697C:: ; 55:697C
	dw Label_55_6984
	dw Label_55_69BD
	dw Label_55_69F6

; ---- ptrtable $6982-$6984 (2 bytes) [PROBABLE] one more code pointer ($6A2F) at the end of the dispatch table that precedes it

Table_55_6982:: ; 55:6982
	dw Label_55_6A2F

; ---- code $6984-$6A2F (171 bytes) [CONFIRMED] 57 insn(s); 57 executed (in up to 4/18 scenarios)

Label_55_6984:: ; 55:6984
	ld de, $8801
	ld hl, Data_62_4000
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_62_4400
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_62_4800
	ld a, $62
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6A65

Label_55_69BD:: ; 55:69BD
	ld de, $8801
	ld hl, Data_62_4B00
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_62_4F00
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_62_5300
	ld a, $62
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6A65

Label_55_69F6:: ; 55:69F6
	ld de, $8801
	ld hl, Data_62_5600
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_62_5A00
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_62_5E00
	ld a, $62
	ld b, $95
	ld c, $24
	farcall Function_00_0787
	jp Label_55_6A65

; ---- code $6A2F-$6A3B (12 bytes) [CONFIRMED] ld de,$8801 ; ld hl,$6100 ; ld a,$62 ; ld b,$92 ; ld c,$40: argument set-up for the tile uploader that follows at 6A3B; its address is the last word $6A2F of the table at 55:6982 [executed in 4 scenarios]

Label_55_6A2F:: ; 55:6A2F
	ld de, $8801
	ld hl, $6100
	ld a, $62
	ld b, $92
	ld c, $40

; ---- code $6A3B-$6A65 (42 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code [executed in 4 scenarios]
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_62_6500
	ld a, $62
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_62_6900
	ld a, $62
	ld b, $95
	ld c, $24
	farcall Function_00_0787

; ---- code $6A65-$6B18 (179 bytes) [CONFIRMED] 68 insn(s); 68 executed (in up to 5/18 scenarios)

Label_55_6A65:: ; 55:6A65
	ldh a, [hRam_FFB0]
	or a, a
	ret z
	ld bc, $0B14
	ld de, $D240
	ld hl, Data_66_7210
	ld a, $66
	farcall Function_00_08EA
	call Kbd_UploadPanelMap11Rows
	ret

Label_55_6A7E:: ; 55:6A7E
	ld de, $8801
	ld hl, Data_5F_4000
	ld a, $5F
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Data_5F_4400
	ld a, $5F
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_5F_4800
	ld a, $5F
	ld b, $98
	ld c, $01
	farcall Function_00_0787
	ld bc, $0B14
	ld de, $D240
	ld hl, Data_5F_4810
	ld a, $5F
	farcall Function_00_08EA
	call Kbd_UploadPanelMap11Rows
	ret

Label_55_6AC9:: ; 55:6AC9
	ld de, $8A81
	ld hl, Data_66_6900
	ld a, $66
	ld b, $96
	ld c, $19
	farcall Function_00_0787
	ld bc, $0614
	ld de, $D240
	ld hl, Data_66_73C8
	ld a, $66
	farcall Function_00_08EA
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
	ld hl, $D240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6B21

; ---- code $6B18-$6B21 (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 55:6B16 (executed)
	xor a, a
	farcall Function_00_0787
	jr Label_55_6B27

; ---- code $6B21-$6B38 (23 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 5/18 scenarios)

Label_55_6B21:: ; 55:6B21
	farcall Function_00_0749

Label_55_6B27:: ; 55:6B27
	inc e
	ld b, $96
	ld c, $16
	ld hl, $D640
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6B41

; ---- code $6B38-$6B41 (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 55:6B36 (executed)
	xor a, a
	farcall Function_00_0787
	jr Label_55_6B47

; ---- code $6B41-$6B82 (65 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 7/18 scenarios)

Label_55_6B41:: ; 55:6B41
	farcall Function_00_0749

Label_55_6B47:: ; 55:6B47
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
	ld hl, $D240
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6B82
	xor a, a
	farcall Function_00_0787
	jr Label_55_6B88

; ---- code $6B82-$6B88 (6 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 55:6B77 (executed)

Label_55_6B82:: ; 55:6B82
	farcall Function_00_0749

; ---- code $6B88-$6BA2 (26 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 7/18 scenarios)

Label_55_6B88:: ; 55:6B88
	inc e
	ld b, $96
	ld c, $1A
	ld hl, $D640
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6BA2
	xor a, a
	farcall Function_00_0787
	jr Label_55_6BA8

; ---- code $6BA2-$6BA8 (6 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 55:6B97 (executed)

Label_55_6BA2:: ; 55:6BA2
	farcall Function_00_0749

; ---- code $6BA8-$6BF7 (79 bytes) [CONFIRMED] 39 insn(s); 39 executed (in up to 11/18 scenarios)

Label_55_6BA8:: ; 55:6BA8
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
	ld hl, $DAC0
	ld de, $4D04
	ld a, $5F
	farcall Function_00_0A82
	ld de, $8808
	ld hl, $DAC0
	call Function_00_0A65
	ret

Kbd_LoadPickerTabTiles:: ; 55:6BD7
	ld a, [wKbdInputMode]
	ld hl, Data_55_6C0A
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
	jr z, Label_55_6C01

; ---- code $6BF7-$6C01 (10 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 55:6BF5 (executed)
	ld a, $66
	farcall Function_00_0787
	jr Label_55_6C09

; ---- code $6C01-$6C0A (9 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_55_6C01:: ; 55:6C01
	ld a, $66
	farcall Function_00_0749

Label_55_6C09:: ; 55:6C09
	ret

; ---- data $6C0A-$6C10 (6 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown

Data_55_6C0A:: ; 55:6C0A
	db $90, $6A, $10, $6D, $90, $6F

; ---- code $6C10-$6C39 (41 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 11/18 scenarios); entry proven: target of an executed call/far call

Kbd_RequestGlyphRedraw:: ; 55:6C10
Function_55_6C10::
	ld a, $01
	ld [wKbdGlyphDirty], a
	ret

Kbd_DrawGlyphPreview:: ; 55:6C16
	ld a, [wKbdGlyphDirty]
	or a, a
	ret z
	ld hl, $C2AE
	ld a, [hl]
	or a, a
	jr z, Label_55_6C28
	cp a, $01
	jr z, Label_55_6C2F
	jr Label_55_6C45

Label_55_6C28:: ; 55:6C28
	dec hl
	ld a, [hl]
	call Text_HalfToFullWidth
	jr Label_55_6C48

Label_55_6C2F:: ; 55:6C2F
	dec hl
	ld a, [hl]
	cp a, $0D
	jr z, Label_55_6C3B
	cp a, $20
	jr z, Label_55_6C40

; ---- code $6C39-$6C3B (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 55:6C37 (executed)
	jr Label_55_6C48

; ---- code $6C3B-$6CC6 (139 bytes) [CONFIRMED] 72 insn(s); 72 executed (in up to 11/18 scenarios) (part of region $6C3B-$6CD4)

Label_55_6C3B:: ; 55:6C3B
	ld bc, $83C0
	jr Label_55_6C48

Label_55_6C40:: ; 55:6C40
	ld bc, $83BF
	jr Label_55_6C48

Label_55_6C45:: ; 55:6C45
	dec hl
	ld b, a
	ld c, [hl]

Label_55_6C48:: ; 55:6C48
	ld hl, $0003
	push hl
	ld hl, $DE10
	push hl
	ld hl, $0003
	push hl
	ld hl, $DE00
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
	ld [wSpriteSlots + 176], a
	ld a, [wKbdCursorSpriteX]
	ld [wSpriteSlots + 177], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	farcall Function_00_0956
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $8241
	ld hl, $DE00
	ld b, $98
	ld c, $02
	ld a, [wKbdType]
	call Kbd_TypeWaitsWithService
	or a, a
	jr z, Label_55_6CB2
	xor a, a
	farcall Function_00_0787
	jr Label_55_6CB8

Label_55_6CB2:: ; 55:6CB2
	farcall Function_00_0749

Label_55_6CB8:: ; 55:6CB8
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ld [wKbdGlyphDirty], a
	ret
