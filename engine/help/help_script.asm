; engine/help/help_script.asm
; bank 6C, $5987-$61CB (2116 bytes); pinned by layout.link
; HelpMenu_Run and the help script player

SECTION "engine/help/help_script", ROMX

; ---- code $5987-$5B79 (498 bytes) [CONFIRMED] 185 insn(s); 185 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

HelpMenu_Run:: ; 6C:5987
Function_6C_5987::
	ld b, $01

Label_6C_5989:: ; 6C:5989
	farcall HelpMenu_ShowPage
	or a, a
	ret z
	cp a, $04
	jr z, Label_6C_59A8
	ld b, a
	ld a, $01
	ld hl, $A684
	farcall WriteByteFar
	push bc
	call HelpScript_Run
	pop bc
	jr Label_6C_5989

Label_6C_59A8:: ; 6C:59A8
	farcall MobileDict_Run
	ld b, $04
	jr Label_6C_5989

HelpScript_Run:: ; 6C:59B2
	push bc
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	pop bc
	ld a, $01
	ld hl, $A684
	farcall WriteByteFar
	ld a, $09
	ld [wHelpScriptPtr], a
	ld [wHelpScriptRestartPtr], a
	ld a, $48
	ld [wHelpScriptPtr + 1], a
	ld [wHelpScriptRestartPtr + 1], a
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Data_6A_69F0
	ld a, $6A
	ld b, $98
	ld c, $02
	farcall Function_00_0787
	ld de, $8AF1
	ld hl, Data_6A_6A10
	ld a, $6A
	ld b, $98
	ld c, $01
	farcall Function_00_0787
	ld de, $8B01
	ld hl, Data_6A_6A20
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_6A_7220
	ld a, $6A
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_6A_6716
	ld a, $6A
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D840
	ld hl, $7260
	ld a, $6A
	farcall Palette_LoadToBuffer
	ld a, $60
	ld bc, $020C
	ld de, $1700
	ld hl, $D004
	farcall Tilemap_FillRectSequential
	ld a, $80
	ld bc, $060C
	ld de, $1700
	ld hl, $D064
	farcall Tilemap_FillRectSequential
	ld a, $00
	ld bc, $0610
	ld de, $1700
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld de, $8800
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_ReadHardwareToBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0017
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

Label_6C_5B47:: ; 6C:5B47
	ld a, [wHelpScriptPtr]
	ld l, a
	ld a, [wHelpScriptPtr + 1]
	ld h, a

Label_6C_5B4F:: ; 6C:5B4F
	ld a, [hli]
	ld [wRam_C1AC], a
	cp a, $01
	jr c, Label_6C_5B7E
	jp z, Label_6C_5C34
	cp a, $03
	jp c, Label_6C_5C35
	jp z, Label_6C_5C36
	cp a, $05
	jr c, Label_6C_5B81
	jr z, Label_6C_5B88
	cp a, $07
	jr c, Label_6C_5B8F
	cp a, $09
	jp c, Label_6C_5B9D
	cp a, $10
	jr z, Label_6C_5BAF
	cp a, $18
	jr z, Label_6C_5BC7

; ---- code $5B79-$5B7E (5 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 6C:5B77 (executed)
	cp a, $19
	jr z, Label_6C_5BDF
	ret

; ---- code $5B7E-$5B88 (10 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 12/18 scenarios)

Label_6C_5B7E:: ; 6C:5B7E
	jp Label_6C_5C0B

Label_6C_5B81:: ; 6C:5B81
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	add hl, bc
	jr Label_6C_5B4F

; ---- code $5B88-$5B8F (7 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 6C:5B66 (executed)

Label_6C_5B88:: ; 6C:5B88
	ld a, [hli]
	dec a
	ld [wRam_C0E6], a
	jr Label_6C_5B4F

; ---- code $5B8F-$5BDF (80 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 12/18 scenarios)

Label_6C_5B8F:: ; 6C:5B8F
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [wRam_C1AB]
	cp a, $02
	jr nz, Label_6C_5B4F
	add hl, bc
	jr Label_6C_5B4F

Label_6C_5B9D:: ; 6C:5B9D
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	add hl, bc
	ld a, l
	ld [wRam_C1B0], a
	ld a, h
	ld [wRam_C1B1], a
	pop hl
	jp Label_6C_5B4F

Label_6C_5BAF:: ; 6C:5BAF
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	ld b, [hl]
	inc hl
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	farcall WriteByteFar
	pop hl
	jr Label_6C_5B4F

Label_6C_5BC7:: ; 6C:5BC7
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	call ReadByteFar
	pop hl
	ld b, [hl]
	inc hl
	cp a, b
	jr nz, Label_6C_5C06
	jr Label_6C_5B81

; ---- code $5BDF-$5C06 (39 bytes) [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1; entered by jrcc from 6C:5B7B (PROBABLE code)

Label_6C_5BDF:: ; 6C:5BDF
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	ld a, [hli]
	and a, $0F
	ld c, a
	ld b, $00
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	call ReadByteFar
	ld d, a
	ld hl, $A684
	add hl, bc
	ld a, $01
	call ReadByteFar
	pop hl
	cp a, d
	jr nz, Label_6C_5C06
	jp Label_6C_5B81

; ---- code $5C06-$5C34 (46 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 12/18 scenarios)

Label_6C_5C06:: ; 6C:5C06
	inc hl
	inc hl
	jp Label_6C_5B4F

Label_6C_5C0B:: ; 6C:5C0B
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, Label_6C_5C1B
	farcall Palette_FadeOutToWhite
	ld b, $00
	ret

Label_6C_5C1B:: ; 6C:5C1B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld b, $FF
	ret

; ---- code $5C34-$5C36 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jpcc from 6C:5B57 (executed)

Label_6C_5C34:: ; 6C:5C34
	ret

Label_6C_5C35:: ; 6C:5C35
	ret

; ---- code $5C36-$5CFD (199 bytes) [CONFIRMED] 86 insn(s); 86 executed (in up to 12/18 scenarios)

Label_6C_5C36:: ; 6C:5C36
	ld a, $01
	ld [wRam_C179], a
	ld [wRam_C0E2], a
	ld a, $06
	ld [wRam_C178], a
	xor a, a
	ld [wRam_C1A8], a
	ld [wRam_C1AB], a
	ld a, [wRam_C0D9]
	or a, a
	jr z, Label_6C_5C66
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0041
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop hl
	xor a, a
	ld [wRam_C0D9], a

Label_6C_5C66:: ; 6C:5C66
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	push hl
	ld a, $00
	ld [wRam_C1AA], a
	ld a, $00
	ld [wRam_C1A9], a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0600
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	pop hl
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [hli]
	or a, a
	ld a, [hli]
	or a, a
	call nz, HelpScript_ShowPicture
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a

Label_6C_5CC5:: ; 6C:5CC5
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wRam_C0E2]
	or a, a
	jr z, Label_6C_5CEE
	call HelpScript_StepText
	or a, a
	jp nz, Label_6C_5D9F
	ld a, [wRam_C1AB]
	cp a, $01
	jr nz, Label_6C_5CEE
	ldh a, [hJoyHeld]
	bit 0, a
	jr nz, Label_6C_5CEE
	xor a, a
	ld [wRam_C1AB], a
	jr Label_6C_5CEE

Label_6C_5CEE:: ; 6C:5CEE
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $5CFD-$5D07 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 6C:5CFA: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Table_6C_5CFD:: ; 6C:5CFD
	dw Label_6C_5D09
	dw Label_6C_5D30
	dw Label_6C_5D5A
	dw Label_6C_5D9C
	dw Label_6C_5D07

; ---- code $5D07-$5F6E (615 bytes) [CONFIRMED] 264 insn(s); 264 executed (in up to 12/18 scenarios)

Label_6C_5D07:: ; 6C:5D07
	jr Label_6C_5CC5

Label_6C_5D09:: ; 6C:5D09
	ld a, $01
	ld [wRam_C1AB], a
	ld a, [wRam_C0E2]
	or a, a
	jr nz, Label_6C_5CC5
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Function_00_0A82
	ld de, $00AA
	ld hl, $DA20
	call Function_00_0A65
	jp Label_6C_5E03

Label_6C_5D30:: ; 6C:5D30
	ld a, $02
	ld [wRam_C1AB], a
	ld a, [wRam_C0E2]
	or a, a
	jr nz, Label_6C_5D57
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Function_00_0A82
	ld de, $00AA
	ld hl, $DA20
	call Function_00_0A65
	jp Label_6C_5E03

Label_6C_5D57:: ; 6C:5D57
	jp Label_6C_5CC5

Label_6C_5D5A:: ; 6C:5D5A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	push hl
	ld a, $01
	ld hl, $A684
	call ReadByteFar
	pop hl
	bit 7, a
	jr nz, Label_6C_5D8D
	ld a, [wHelpScriptRestartPtr]
	ld [wHelpScriptPtr], a
	ld a, [wHelpScriptRestartPtr + 1]
	ld [wHelpScriptPtr + 1], a
	farcall Palette_FadeOutToWhite
	ld b, $00
	ret

Label_6C_5D8D:: ; 6C:5D8D
	ld a, [wRam_C1B0]
	ld [wHelpScriptPtr], a
	ld a, [wRam_C1B1]
	ld [wHelpScriptPtr + 1], a
	jp Label_6C_5B47

Label_6C_5D9C:: ; 6C:5D9C
	jp Label_6C_5CC5

Label_6C_5D9F:: ; 6C:5D9F
	xor a, a
	ld [wRam_C0E2], a
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, Label_6C_5DC6
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Function_00_0A82
	ld de, $7880
	ld hl, $DA20
	call Function_00_0A65
	jp Label_6C_5CC5

Label_6C_5DC6:: ; 6C:5DC6
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jp Label_6C_5D30

Label_6C_5E03:: ; 6C:5E03
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, Label_6C_5E1D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0040
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_6C_5B47

Label_6C_5E1D:: ; 6C:5E1D
	ld a, $01
	ld [wRam_C0D9], a
	jp Label_6C_5B47

HelpScript_RenderCaption:: ; 6C:5E25
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	xor a, a
	ld bc, $0180
	ld hl, $D000
	call FillBytes
	pop hl
	ld bc, $D000
	ld de, $D0C0
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $6C
	farcall TextTiles_RenderLine
	push hl
	ld de, $9600
	ld hl, $D000
	ld a, $00
	ld b, $96
	ld c, $18
	farcall Function_00_0787
	pop hl
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

HelpScript_ShowPicture:: ; 6C:5E6E
	ld b, a
	ld a, [wRam_C177]
	cp a, b
	ret z
	ld c, a
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	xor a, a
	or a, c
	jr z, Label_6C_5E8B
	push bc
	ld a, $40
	farcall Palette_FadeOutMasked
	pop bc

Label_6C_5E8B:: ; 6C:5E8B
	ld a, b
	ld [wRam_C177], a
	dec a
	ld b, a
	sla a
	sla a
	add a, b
	ld hl, $5F6E
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0900
	ld hl, $D000
	call FillBytes
	ld de, $8C80
	ld hl, $D480
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9080
	ld hl, $D880
	ld a, $00
	ld b, $98
	ld c, $08
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	ld a, [hli]
	ld [wRam_C110], a
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_C110]
	ld de, $D830
	ld bc, $0008
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D464
	ld bc, $060C
	ld de, $F806
	xor a, a
	farcall Function_00_091C
	ldh a, [rLCDC]
	call Function_00_082C
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [rLCDC]
	bit 7, a
	jr z, Label_6C_5F39

Label_6C_5F33:: ; 6C:5F33
	ldh a, [rLY]
	cp a, $8E
	jr nz, Label_6C_5F33

Label_6C_5F39:: ; 6C:5F39
	ld de, $8800
	ld b, $92
	ld c, $40
	ld a, [wRam_C110]
	farcall Function_00_0787
	ld bc, $0400
	add hl, bc
	ld de, $8C00
	ld b, $98
	ld c, $08
	ld a, [wRam_C110]
	farcall Function_00_0787
	ld a, $40
	farcall Palette_FadeInMasked
	ld a, [wRam_C10E]
	ld l, a
	ld a, [wRam_C10F]
	ld h, a
	ret

; ---- data $5F6E-$6009 (155 bytes) [PROBABLE] 31 records x 5 bytes (61 00 40 80 7A / 61 80 44 88 7A / 61 00 49 90 7A ...; pattern flag, x, y, 7A 61-style pointer tail), read in up to 8 scenarios; 155 bytes = 31 records; the 15 and 50 byte holes are unread records of the same table

HelpScript_PictureTable:: ; 6C:5F6E
Data_6C_5F6E::
	db $61, $00, $40, $80, $7A, $61, $80, $44, $88, $7A, $61, $00, $49, $90, $7A, $61
	db $80, $4D, $98, $7A, $61, $00, $52, $A0, $7A, $61, $80, $56, $A8, $7A, $61, $00
	db $5B, $B0, $7A, $61, $80, $5F, $B8, $7A, $61, $00, $64, $C0, $7A, $61, $80, $68
	db $C8, $7A, $61, $00, $6D, $D0, $7A, $61, $80, $71, $D8, $7A, $61, $00, $76, $E0
	db $7A, $60, $00, $40, $80, $7A, $60, $80, $44, $88, $7A, $60, $00, $49, $90, $7A
	db $60, $80, $4D, $98, $7A, $60, $00, $52, $A0, $7A, $60, $80, $56, $A8, $7A, $60
	db $00, $5B, $B0, $7A, $60, $80, $5F, $B8, $7A, $60, $00, $64, $C0, $7A, $60, $80
	db $68, $C8, $7A, $60, $00, $6D, $D0, $7A, $60, $80, $71, $D8, $7A, $60, $00, $76
	db $E0, $7A, $5B, $00, $40, $80, $56, $5B, $80, $44, $88, $56, $5B, $00, $49, $90
	db $56, $5B, $80, $4D, $98, $56, $5B, $00, $52, $A0, $56

; ---- code $6009-$6036 (45 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

HelpScript_StepText:: ; 6C:6009
Function_6C_6009::
	ld a, [wRam_C179]
	dec a
	ld [wRam_C179], a
	ld a, $00
	ret nz
	ld a, [wHelpScriptPtr]
	ld l, a
	ld a, [wHelpScriptPtr + 1]
	ld h, a

Label_6C_601B:: ; 6C:601B
	ld a, [hli]
	ld b, a
	bit 7, a
	jp nz, Label_6C_60AF
	swap a
	and a, $07
	cp a, $01
	jr c, Label_6C_603A
	jr z, Label_6C_6045
	cp a, $03
	jr c, Label_6C_605B
	jr z, Label_6C_6075
	cp a, $05
	jr c, Label_6C_607A

; ---- code $6036-$603A (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 6C:6034 (executed)
	jr z, Label_6C_6090
	xor a, a
	ret

; ---- code $603A-$6062 (40 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 11/18 scenarios)

Label_6C_603A:: ; 6C:603A
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a
	ld a, $FF
	ret

Label_6C_6045:: ; 6C:6045
	xor a, a
	ld [wRam_C1A8], a
	ld a, [wRam_C1A9]
	add a, $20
	ld [wRam_C1A9], a
	ld a, [wRam_C1AA]
	inc a
	inc a
	ld [wRam_C1AA], a
	jr Label_6C_601B

Label_6C_605B:: ; 6C:605B
	ld a, b
	cp a, $21
	jr c, Label_6C_6068
	jr z, Label_6C_606E

; ---- code $6062-$6068 (6 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 6C:6060 (executed)
	ld a, [hli]
	ld [wRam_C178], a
	jr Label_6C_601B

; ---- code $6068-$6090 (40 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 12/18 scenarios)

Label_6C_6068:: ; 6C:6068
	xor a, a
	ld [wRam_C17A], a
	jr Label_6C_601B

Label_6C_606E:: ; 6C:606E
	ld a, $01
	ld [wRam_C17A], a
	jr Label_6C_601B

Label_6C_6075:: ; 6C:6075
	call HelpScript_RenderCaption
	jr Label_6C_601B

Label_6C_607A:: ; 6C:607A
	ld a, [wRam_C1AB]
	or a, a
	jr nz, Label_6C_608C
	ld a, [wRam_C179]
	ld b, a
	ld a, [hli]
	add a, b
	ld [wRam_C179], a
	jp Label_6C_618E

Label_6C_608C:: ; 6C:608C
	inc hl
	jp Label_6C_601B

; ---- code $6090-$60AF (31 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 6C:6036 (PROBABLE code)

Label_6C_6090:: ; 6C:6090
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, Label_6C_608C
	ld a, [hli]
	or a, a
	jr z, Label_6C_60A9
	ld [wRam_C17B], a
	ld [wRam_C17C], a
	ld a, $01
	ld [wRam_C176], a
	jp Label_6C_601B

Label_6C_60A9:: ; 6C:60A9
	ld [wRam_C176], a
	jp Label_6C_601B

; ---- code $60AF-$60D4 (37 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 12/18 scenarios)

Label_6C_60AF:: ; 6C:60AF
	ld a, b
	cp a, $A0
	jr c, Label_6C_60C6
	push hl
	ld hl, $58C7
	sub a, $A0
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld b, [hl]
	inc hl
	ld c, [hl]
	jr Label_6C_60C9

Label_6C_60C6:: ; 6C:60C6
	ld c, [hl]
	inc hl
	push hl

Label_6C_60C9:: ; 6C:60C9
	ld a, [wRam_C17A]
	push af
	ld a, [wRam_C1A8]
	cp a, $10
	jr nz, Label_6C_60EB

; ---- code $60D4-$60EB (23 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 6C:60D2 (executed) [executed in 2 scenarios]
	xor a, a
	ld [wRam_C1A8], a
	ld a, [wRam_C1A9]
	add a, $20
	ld [wRam_C1A9], a
	ld a, [wRam_C1AA]
	inc a
	inc a
	ld [wRam_C1AA], a
	ld a, [wRam_C1A8]

; ---- code $60EB-$61AC (193 bytes) [CONFIRMED] 107 insn(s); 107 executed (in up to 12/18 scenarios)

Label_6C_60EB:: ; 6C:60EB
	ld e, a
	ld a, [wRam_C1A9]
	add a, e
	swap a
	ld d, a
	and a, $F0
	ld e, a
	ld a, d
	and a, $0F
	ld d, a
	push de
	ld a, d
	or a, $D0
	ld d, a
	push de
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $0003
	push hl
	ld hl, $0100
	add hl, de
	push hl
	ld hl, $0003
	push hl
	push de
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	pop de
	pop af
	or a, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	jr z, Label_6C_6158
	ld c, $08

Label_6C_6142:: ; 6C:6142
	ld a, [hli]
	xor a, a
	ld [hli], a
	dec c
	jr nz, Label_6C_6142
	ld bc, $00F0
	add hl, bc
	ld c, $08

Label_6C_614E:: ; 6C:614E
	ld a, [hli]
	xor a, a
	ld [hli], a
	dec c
	jr nz, Label_6C_614E
	ld bc, $FEF0
	add hl, bc

Label_6C_6158:: ; 6C:6158
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, Label_6C_6198
	ld a, $90
	add a, d
	ld d, a
	ld b, $97
	ld c, $11
	xor a, a
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C1AB]
	cp a, $01
	ld a, [wRam_C178]
	jr nz, Label_6C_6183
	ld a, $01

Label_6C_6183:: ; 6C:6183
	ld [wRam_C179], a
	ld a, [wRam_C1A8]
	inc a
	ld [wRam_C1A8], a
	pop hl

Label_6C_618E:: ; 6C:618E
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a
	xor a, a
	ret

Label_6C_6198:: ; 6C:6198
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C1A8]
	inc a
	ld [wRam_C1A8], a
	pop hl
	jp Label_6C_601B

; ---- code $61AC-$61C4 (24 bytes) [PROBABLE] coherent 24-byte routine (ld hl,$C0DA ; dec [hl] ; ret nz ; ld [hl],$23 ; toggle [C0D9] ; ld d,$78 ; ... ld hl,$DA20) that falls exactly into the raw far-call site at 61C4 (call 00:0A65); previous region ends with jp; entry not located

Function_6C_61AC:: ; 6C:61AC
	ld hl, $C0DA
	dec [hl]
	ret nz
	ld [hl], $23
	ld a, [wRam_C0D9]
	xor a, $01
	ld [wRam_C0D9], a
	ld d, $78
	add a, d
	ld d, a
	ld e, $80
	ld hl, $DA20

; ---- code $61C4-$61CB (7 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_0A65
	ret
