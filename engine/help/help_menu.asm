; engine/help/help_menu.asm
; bank 6C, $4000-$4809 (2057 bytes); pinned by layout.link
; help menu pages, cursor, item drawing

SECTION "engine/help/help_menu", ROMX

; ---- code $4000-$4101 (257 bytes) [CONFIRMED] 95 insn(s); 95 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

HelpMenu_ShowPage:: ; 6C:4000
Function_6C_4000::
	push bc
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	pop bc
	ld a, b
	srl a
	srl a
	srl a
	inc a
	ld [wRam_C0D8], a
	ld a, b
	and a, $07
	ld [wRam_C0E5], a

Label_6C_401D:: ; 6C:401D
	ld a, $01
	ld [wRam_C0E7], a
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
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Data_6A_4E90
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, Data_6A_5290
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, Data_6A_5690
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, Data_6A_5A90
	ld a, $6A
	ld b, $98
	ld c, $02
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_6A_5AB0
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_6A_5EB0
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_6A_62B0
	ld a, $6A
	farcall Palette_LoadToBuffer
	ld a, [wRam_C0D8]
	cp a, $02
	jr z, Label_6C_40E6
	cp a, $03
	jr z, Label_6C_4101
	ld bc, $1214
	ld de, $D000
	ld hl, Data_6A_4000
	ld a, $6A
	farcall Function_00_08EA
	ld a, $02
	ld [wRam_C0E6], a
	call HelpMenu_DrawItemNormal
	ld a, $03
	ld [wRam_C0E6], a
	call HelpMenu_DrawItemNormal
	jr Label_6C_411A

Label_6C_40E6:: ; 6C:40E6
	ld bc, $1214
	ld de, $D000
	ld hl, Data_6A_42D0
	ld a, $6A
	farcall Function_00_08EA
	ld a, $02
	ld [wRam_C0E6], a
	call HelpMenu_DrawItemNormal
	jr Label_6C_411A

; ---- code $4101-$411A (25 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by jrcc from 6C:40C1 (executed) [executed in 2 scenarios]

Label_6C_4101:: ; 6C:4101
	ld bc, $1214
	ld de, $D000
	ld hl, Data_6A_45A0
	ld a, $6A
	farcall Function_00_08EA
	ld a, $02
	ld [wRam_C0E6], a
	call HelpMenu_DrawItemNormal

; ---- code $411A-$41CB (177 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 3/18 scenarios)

Label_6C_411A:: ; 6C:411A
	ld a, $01
	ld [wRam_C0E6], a
	ld hl, $DA10
	ld de, $64AE
	ld a, $6A
	ld b, $80
	farcall Function_00_0A82
	ld de, $371F
	ld hl, $DA10
	call Function_00_0A65
	ld bc, $0040
	ld de, $D840
	ld hl, $62F0
	ld a, $6A
	farcall Palette_LoadToBuffer
	call HelpMenu_DrawItemSelected
	ld a, $40
	ld bc, $0220
	ld de, $8000
	ld hl, $D200
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	call HelpMenu_ShowItemText
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0016
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

Label_6C_41B3:: ; 6C:41B3
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41CB-$41D5 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 6C:41C8: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

HelpMenu_InputTable:: ; 6C:41CB
Table_6C_41CB::
	dw Label_6C_41E5
	dw Label_6C_425A
	dw Label_6C_429C
	dw Label_6C_429C
	dw Label_6C_41D5

; ---- code $41D5-$422E (89 bytes) [CONFIRMED] 35 insn(s); 35 executed (in up to 3/18 scenarios)

Label_6C_41D5:: ; 6C:41D5
	farcall Ticker_Update
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, HelpMenu_HandleDpad
	jp Label_6C_41B3

Label_6C_41E5:: ; 6C:41E5
	ld a, [wRam_C0E5]
	call HelpMenu_ItemIsLocked
	or a, a
	jp nz, Label_6C_4247
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0D8]
	cp a, $02
	jr z, Label_6C_423B
	cp a, $03
	jr z, Label_6C_4241
	ld a, [wRam_C0E5]
	cp a, $02
	jr z, Label_6C_4222
	cp a, $03
	jr z, Label_6C_422E
	ret

Label_6C_4222:: ; 6C:4222
	ld a, $02
	ld [wRam_C0D8], a
	dec a
	ld [wRam_C0E5], a
	jp Label_6C_401D

; ---- code $422E-$423B (13 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 6C:421F (executed) [executed in 2 scenarios]

Label_6C_422E:: ; 6C:422E
	ld a, $03
	ld [wRam_C0D8], a
	ld a, $01
	ld [wRam_C0E5], a
	jp Label_6C_401D

; ---- code $423B-$4241 (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_6C_423B:: ; 6C:423B
	ld a, [wRam_C0E5]
	add a, $08
	ret

; ---- code $4241-$4247 (6 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 6C:4214 (executed) [executed in 2 scenarios]

Label_6C_4241:: ; 6C:4241
	ld a, [wRam_C0E5]
	add a, $10
	ret

; ---- code $4247-$428F (72 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 3/18 scenarios)

Label_6C_4247:: ; 6C:4247
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_6C_41B3

Label_6C_425A:: ; 6C:425A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0D8]
	cp a, $02
	jr z, Label_6C_4283
	cp a, $03
	jr z, Label_6C_428F
	xor a, a
	ret

Label_6C_4283:: ; 6C:4283
	ld a, $01
	ld [wRam_C0D8], a
	inc a
	ld [wRam_C0E5], a
	jp Label_6C_401D

; ---- code $428F-$429C (13 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; entered by jrcc from 6C:427F (executed) [executed in 2 scenarios]

Label_6C_428F:: ; 6C:428F
	ld a, $01
	ld [wRam_C0D8], a
	ld a, $03
	ld [wRam_C0E5], a
	jp Label_6C_401D

; ---- code $429C-$4344 (168 bytes) [CONFIRMED] 75 insn(s); 75 executed (in up to 3/18 scenarios)

Label_6C_429C:: ; 6C:429C
	jp Label_6C_41B3

HelpMenu_HandleDpad:: ; 6C:429F
	bit 6, a
	jr nz, Label_6C_42A8
	bit 7, a
	jr nz, Label_6C_42DB
	ret

Label_6C_42A8:: ; 6C:42A8
	ld a, [wRam_C0E5]
	ld [wRam_C0E6], a
	dec a
	jr nz, Label_6C_42BE
	ld a, [wRam_C0D8]
	cp a, $01
	jr nz, Label_6C_42BC
	ld a, $04
	jr Label_6C_42BE

Label_6C_42BC:: ; 6C:42BC
	ld a, $02

Label_6C_42BE:: ; 6C:42BE
	ld [wRam_C0E5], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call HelpMenu_DrawItemNormal
	call HelpMenu_DrawItemSelected
	call HelpMenu_ShowItemText
	ret

Label_6C_42DB:: ; 6C:42DB
	ld a, [wRam_C0D8]
	cp a, $01
	jr nz, Label_6C_42F1
	ld a, [wRam_C0E5]
	ld [wRam_C0E6], a
	inc a
	cp a, $05
	jr nz, Label_6C_42FE
	ld a, $01
	jr Label_6C_42FE

Label_6C_42F1:: ; 6C:42F1
	ld a, [wRam_C0E5]
	ld [wRam_C0E6], a
	inc a
	cp a, $03
	jr nz, Label_6C_42FE
	ld a, $01

Label_6C_42FE:: ; 6C:42FE
	ld [wRam_C0E5], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call HelpMenu_DrawItemNormal
	call HelpMenu_DrawItemSelected
	call HelpMenu_ShowItemText
	ret

HelpMenu_DrawItemNormal:: ; 6C:431B
	ld a, [wRam_C0D8]
	cp a, $02
	jp z, Label_6C_440B
	cp a, $03
	jp z, Label_6C_4498
	ld a, [wRam_C0E6]
	cp a, $02
	jp nz, Label_6C_436C
	ld a, $01
	ld hl, $A686
	call ReadByteFar
	ld d, a
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, d
	jr nz, Label_6C_436C

; ---- code $4344-$436C (40 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 6C:4342 (executed) [executed in 1 scenarios]
	ld hl, $49CE
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $48FC
	ld de, $D0A9
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- code $436C-$4498 (300 bytes) [CONFIRMED] 148 insn(s); 148 executed (in up to 3/18 scenarios)

Label_6C_436C:: ; 6C:436C
	ld a, [wRam_C0E6]
	cp a, $03
	jr nz, Label_6C_43AF
	ld a, $01
	ld hl, $A688
	call ReadByteFar
	ld d, a
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, d
	jr nz, Label_6C_43AF
	ld hl, $49EC
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $491A
	ld de, $D0E9
	ld bc, $040A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_43AF:: ; 6C:43AF
	ld a, [wRam_C0E6]
	dec a
	ld c, a
	ld b, $03
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, HelpMenu_ItemDestOffsets
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $4535
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4870
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	push bc
	ld bc, $00D2
	add hl, bc
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	pop bc
	pop hl
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_440B:: ; 6C:440B
	ld a, [wRam_C0E6]
	cp a, $02
	jp nz, Label_6C_4446
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, a
	jr nz, Label_6C_4446
	ld hl, $4AAA
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4A50
	ld de, $D109
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_4446:: ; 6C:4446
	ld a, [wRam_C0E6]
	dec a
	ld c, a
	ld b, $03
	ld hl, $452D
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $4539
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4A14
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $5A
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- code $4498-$4525 (141 bytes) [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1; entered by jpcc from 6C:4325 (executed) [executed in 2 scenarios]

Label_6C_4498:: ; 6C:4498
	ld a, [wRam_C0E6]
	cp a, $02
	jp nz, Label_6C_44D3
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, a
	jr nz, Label_6C_44D3
	ld hl, $4B5E
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4B04
	ld de, $D109
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_44D3:: ; 6C:44D3
	ld a, [wRam_C0E6]
	dec a
	ld c, a
	ld b, $03
	ld hl, $4531
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $453B
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4AC8
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $5A
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- data $4525-$453D (24 bytes) [PROBABLE] 24-byte table 49 00 A9 00 E9 00 49 01 89 00 09 01 89 00 09 01 00 28 46 6E 00 1E 00 1E (12 words), read by executed code in up to 3 scenarios, directly after a ret and before Function_6C_453D; second identical copy at 4747; the 1-8 byte mapper holes inside this run are bytes not read in the traces; they sit between executed-read pieces of the same block and are not code (no branch enters them, bytes do not decode as a coherent routine)

HelpMenu_ItemDestOffsets:: ; 6C:4525
Data_6C_4525::
	db $49, $00, $A9, $00, $E9, $00, $49, $01, $89, $00, $09, $01, $89, $00, $09, $01
	db $00, $28, $46, $6E, $00, $1E, $00, $1E

; ---- code $453D-$4566 (41 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

HelpMenu_DrawItemSelected:: ; 6C:453D
Function_6C_453D::
	ld a, [wRam_C0D8]
	cp a, $02
	jp z, Label_6C_462D
	cp a, $03
	jp z, Label_6C_46BA
	ld a, [wRam_C0E5]
	cp a, $02
	jp nz, Label_6C_458E
	ld a, $01
	ld hl, $A686
	call ReadByteFar
	ld d, a
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, d
	jr nz, Label_6C_458E

; ---- code $4566-$458E (40 bytes) [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 6C:4564 (executed)
	ld hl, $4CDA
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4C08
	ld de, $D0A9
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- code $458E-$46BA (300 bytes) [CONFIRMED] 148 insn(s); 148 executed (in up to 3/18 scenarios)

Label_6C_458E:: ; 6C:458E
	ld a, [wRam_C0E5]
	cp a, $03
	jr nz, Label_6C_45D1
	ld a, $01
	ld hl, $A688
	call ReadByteFar
	ld d, a
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, d
	jr nz, Label_6C_45D1
	ld hl, $4CF8
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4C26
	ld de, $D0E9
	ld bc, $040A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_45D1:: ; 6C:45D1
	ld a, [wRam_C0E5]
	dec a
	ld c, a
	ld b, $03
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, HelpMenu_ItemDestOffsets2
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $4757
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4B7C
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	push bc
	ld bc, $00D2
	add hl, bc
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	pop bc
	pop hl
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_462D:: ; 6C:462D
	ld a, [wRam_C0E5]
	cp a, $02
	jp nz, Label_6C_4668
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, a
	jr nz, Label_6C_4668
	ld hl, $4DB6
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4D5C
	ld de, $D109
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_4668:: ; 6C:4668
	ld a, [wRam_C0E5]
	dec a
	ld c, a
	ld b, $03
	ld hl, $474F
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $475B
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4D20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $5A
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- code $46BA-$4747 (141 bytes) [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1; entered by jpcc from 6C:4547 (executed) [executed in 2 scenarios]

Label_6C_46BA:: ; 6C:46BA
	ld a, [wRam_C0E5]
	cp a, $02
	jp nz, Label_6C_46F5
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, a
	jr nz, Label_6C_46F5
	ld hl, $4E6A
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	ld hl, $4E10
	ld de, $D109
	ld bc, $030A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

Label_6C_46F5:: ; 6C:46F5
	ld a, [wRam_C0E5]
	dec a
	ld c, a
	ld b, $03
	ld hl, $4753
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, $475D
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4DD4
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $5A
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $6A
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	ret

; ---- data $4747-$4763 (28 bytes) [PROBABLE] same 24-byte table as 4525 (49 00 A9 00 E9 00 49 01 ...) followed by 4 bytes 8C AA 3C 3C before Function_6C_4763; read in up to 3 scenarios; the 1-8 byte mapper holes inside this run are bytes not read in the traces; they sit between executed-read pieces of the same block and are not code (no branch enters them, bytes do not decode as a coherent routine)

HelpMenu_ItemDestOffsets2:: ; 6C:4747
Data_6C_4747::
	db $49, $00, $A9, $00, $E9, $00, $49, $01, $89, $00, $09, $01, $89, $00, $09, $01
	db $00, $28, $46, $6E, $00, $1E, $00, $1E, $8C, $AA, $3C, $3C

; ---- code $4763-$4776 (19 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

HelpMenu_ShowItemText:: ; 6C:4763
Function_6C_4763::
	ld a, [wRam_C0D8]
	ld b, $00
	cp a, $02
	jr z, Label_6C_4772
	cp a, $03
	jr z, Label_6C_4776
	jr Label_6C_4778

Label_6C_4772:: ; 6C:4772
	ld b, $04
	jr Label_6C_4778

; ---- code $4776-$4778 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 6C:476E (executed) [executed in 2 scenarios]

Label_6C_4776:: ; 6C:4776
	ld b, $06

; ---- code $4778-$47C0 (72 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 3/18 scenarios)

Label_6C_4778:: ; 6C:4778
	ld a, [wRam_C0E5]
	push bc
	call HelpMenu_ItemIsLocked
	pop bc
	ld hl, $64B2
	or a, a
	jr z, Label_6C_4789
	ld hl, Data_6A_6651

Label_6C_4789:: ; 6C:4789
	ld a, [wRam_C0E5]
	dec a
	add a, b
	ld b, a
	ld a, $6A
	farcall Ticker_Start
	ret

HelpMenu_ItemIsLocked:: ; 6C:4798
	ld c, a
	ld a, [wRam_C0D8]
	cp a, $02
	jp z, Label_6C_47DF
	cp a, $03
	jp z, Label_6C_47F3
	ld a, c
	cp a, $02
	jp nz, Label_6C_47C3
	ld a, $01
	ld hl, $A686
	call ReadByteFar
	ld b, a
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, b
	jr nz, Label_6C_4807

; ---- code $47C0-$47C3 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 6C:47BE (executed)
	ld a, $FF
	ret

; ---- code $47C3-$47F3 (48 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 3/18 scenarios)

Label_6C_47C3:: ; 6C:47C3
	ld a, c
	cp a, $03
	jr nz, Label_6C_4807
	ld a, $01
	ld hl, $A688
	call ReadByteFar
	ld d, a
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, d
	jr nz, Label_6C_4807
	ld a, $FF
	ret

Label_6C_47DF:: ; 6C:47DF
	ld a, c
	cp a, $02
	jp nz, Label_6C_4807
	ld a, $01
	ld hl, $A687
	call ReadByteFar
	or a, a
	jr nz, Label_6C_4807
	ld a, $FF
	ret

; ---- code $47F3-$4807 (20 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1; entered by jpcc from 6C:47A3 (executed) [executed in 2 scenarios]

Label_6C_47F3:: ; 6C:47F3
	ld a, c
	cp a, $02
	jp nz, Label_6C_4807
	ld a, $01
	ld hl, $A689
	call ReadByteFar
	or a, a
	jr nz, Label_6C_4807
	ld a, $FF
	ret

; ---- code $4807-$4809 (2 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 3/18 scenarios)

Label_6C_4807:: ; 6C:4807
	xor a, a
	ret
