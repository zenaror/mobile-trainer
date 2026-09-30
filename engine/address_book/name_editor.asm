; engine/address_book/name_editor.asm
; bank 2F, $57F2-$61F0 (2558 bytes); pinned by layout.link
; address book name editor with kana keyboard

SECTION "engine/address_book/name_editor", ROMX

; ---- code $57F2-$582D (59 bytes) [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2; entered by far from 2F:7F1C (PROBABLE code) [executed in 1 scenarios]

AbookName_Edit:: ; 2F:57F2
	push af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	push af
	call AbookName_SetupScreen
	ld d, $0A

Label_2F_581A:: ; 2F:581A
	push de
	call AbookName_CursorRightStep
	pop de
	dec d
	jr nz, Label_2F_581A
	pop af
	cp a, $01
	jr nz, Label_2F_5832
	call AbookName_KeyboardLoop
	jp Label_2F_5857

; ---- data $582D-$5832 (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_582D:: ; 2F:582D
	db $F1, $FE, $01, $28, $22

; ---- code $5832-$5837 (5 bytes) [CONFIRMED] 102 insn(s) reached by static flow only; seeds: exec x102; min discovery hops 3; entered by jrcc from 2F:5825 (PROBABLE code) | 3 insn(s) executed; cut out of the PROBABLE region 5832-590B by apply_coverage --split [executed in 6 scenarios]

Label_2F_5832:: ; 2F:5832
	ld a, c
	cp a, $09
	jr c, Label_2F_5839

; ---- code $5837-$5839 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5832-590B by apply_coverage --split
	ld c, $08

; ---- code $5839-$58E9 (176 bytes) [CONFIRMED] 77 insn(s) executed; cut out of the PROBABLE region 5832-590B by apply_coverage --split [executed in 1 scenarios]

Label_2F_5839:: ; 2F:5839
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call AbookName_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2F_5876
	call AbookName_OpenKeyboard

Label_2F_5857:: ; 2F:5857
	cp a, $07
	jr nz, Label_2F_5876
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	pop bc
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ret

Label_2F_5876:: ; 2F:5876
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2F_58BB
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	farcall Function_00_0956
	call Function_00_0464
	ld a, $FF
	ret

Label_2F_58BB:: ; 2F:58BB
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, AbookName_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, AbookName_CursorRight
	ld d, $10
	jp Label_2F_5832

AbookName_CursorLeft:: ; 2F:58CE
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	dec c
	jr nz, Label_2F_58EF
	inc b
	dec b
	ret z

; ---- code $58E9-$58EF (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5832-590B by apply_coverage --split
	dec b
	call AbookName_GetCharPtr
	ld c, e
	ret

; ---- code $58EF-$590B (28 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 5832-590B by apply_coverage --split [executed in 1 scenarios]

Label_2F_58EF:: ; 2F:58EF
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

AbookName_CursorRight:: ; 2F:58F5
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

AbookName_CursorRightStep:: ; 2F:5909
	jr Label_2F_5914

; ---- code $590B-$5914 (9 bytes) [HYPOTHESIS] 6 insn(s) (ld a,b ; cp $07 ; jr nz,end ; ld a,c ; cp $0B ; ret z) falling into the code at $5914; identical bytes at 2F:590B and 2F:6F44; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	ld a, b
	cp a, $07
	jr nz, Label_2F_5914
	ld a, c
	cp a, $0B
	ret z

; ---- code $5914-$5934 (32 bytes) [CONFIRMED] 372 insn(s) reached by static flow only; seeds: exec x372; min discovery hops 3; entered by jr from 2F:5909 (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5914:: ; 2F:5914
	inc c
	dec c
	jr nz, Label_2F_5925
	call AbookName_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

Label_2F_5925:: ; 2F:5925
	call AbookName_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $09
	cp a, c
	ret nz

; ---- code $5934-$593B (7 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split
	ld c, $08
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $593B-$5AC8 (397 bytes) [CONFIRMED] 152 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split [executed in 1 scenarios]

AbookName_SetupScreen:: ; 2F:593B
	push af
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Tiles_2F_61F0
	ld a, $2F
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $9701
	ld hl, Tiles_2F_65F0
	ld a, $2F
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	ld de, $8800
	ld hl, Tiles_2F_66F0
	ld a, $2F
	ld b, $94
	ld c, $30
	farcall Function_00_0749
	ld de, $8000
	ld hl, Data_29_5B10
	ld a, $29
	ld b, $94
	ld c, $30
	farcall Function_00_0749
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_29_5E10
	ld a, $29
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_2F_6CC0
	ld a, $2F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_AbookName
	ld a, $2F
	farcall Function_00_08EA
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ldh a, [rLCDC]
	call Function_00_082C
	pop af
	push af
	dec a
	jr nz, Label_2F_5A37
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $08
	ld b, $02
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $42
	ld [wSplitScrollY], a

Label_2F_5A37:: ; 2F:5A37
	ld bc, $0000
	call AbookName_PlaceCursorSprites
	farcall LCDOn
	ld bc, $0000
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop af
	dec a
	jr nz, Label_2F_5A81
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
	jr Label_2F_5AB0

Label_2F_5A81:: ; 2F:5A81
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0B
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit

Label_2F_5AB0:: ; 2F:5AB0
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

AbookName_PlaceCursorSprites:: ; 2F:5AB8
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $54

Label_2F_5AC5:: ; 2F:5AC5
	dec b
	jr z, Label_2F_5ACC

; ---- code $5AC8-$5ACC (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split
	add a, $0C
	jr Label_2F_5AC5

; ---- code $5ACC-$5B4A (126 bytes) [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split [executed in 4 scenarios]

Label_2F_5ACC:: ; 2F:5ACC
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $38

Label_2F_5ADB:: ; 2F:5ADB
	dec c
	jr z, Label_2F_5AE2
	add a, $0C
	jr Label_2F_5ADB

Label_2F_5AE2:: ; 2F:5AE2
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

AbookName_DrawName:: ; 2F:5AEA
	ld a, $10
	ld [wTextCellsLeft], a

Label_2F_5AEF:: ; 2F:5AEF
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_5B8A
	cp a, $0D
	jr z, Label_2F_5B6F
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_5B4A
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call AbookName_DrawName_Glyph
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_5B8A
	cp a, $01
	jr z, Label_2F_5B8A
	jr Label_2F_5AEF

; ---- code $5B4A-$5B8A (64 bytes) [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split

Label_2F_5B4A:: ; 2F:5B4A
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call AbookName_DrawName_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_5B8A
	cp a, $01
	jr z, Label_2F_5B8A
	jr Label_2F_5AEF

Label_2F_5B6F:: ; 2F:5B6F
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call AbookName_DrawName_Pad

; ---- code $5B8A-$5C30 (166 bytes) [CONFIRMED] 96 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage --split [executed in 4 scenarios]

Label_2F_5B8A:: ; 2F:5B8A
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2F_5B96:: ; 2F:5B96
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookName_DrawName_Pad
	jr Label_2F_5B96

AbookName_DrawName_Glyph:: ; 2F:5BA5
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

AbookName_DrawName_Pad:: ; 2F:5BB9
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

AbookName_UploadTextTiles:: ; 2F:5BD1
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $27
	call AbookName_HdmaBlock
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

AbookName_HdmaBlock:: ; 2F:5BEE
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2F_5BFD:: ; 2F:5BFD
	ld a, [de]
	cp a, $8F
	jr nz, Label_2F_5BFD
	ld b, $91

Label_2F_5C04:: ; 2F:5C04
	ld a, [de]
	cp a, b
	jr nz, Label_2F_5C04
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

AbookName_GetCharPtr:: ; 2F:5C0E
	push bc
	call AbookName_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, Label_2F_5C36
	inc c
	ld a, [hl]

Label_2F_5C1F:: ; 2F:5C1F
	dec c
	jr z, Label_2F_5C34
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_5C36
	ld a, [hl]
	cp a, $0D
	jr z, Label_2F_5C3C
	jr Label_2F_5C1F

; ---- data $5C30-$5C34 (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5C30:: ; 2F:5C30
	db $0C, $0D, $20, $02

; ---- code $5C34-$5C3C (8 bytes) [CONFIRMED] 88 insn(s) reached by static flow only; seeds: exec x88; min discovery hops 7; entered by jrcc from 2F:5C20 (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split [executed in 4 scenarios]

Label_2F_5C34:: ; 2F:5C34
	pop bc
	ret

Label_2F_5C36:: ; 2F:5C36
	ld a, $FF
	ld d, $FF
	pop bc
	ret

; ---- code $5C3C-$5C42 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split

Label_2F_5C3C:: ; 2F:5C3C
	ld a, $0D
	ld d, $FF
	pop bc
	ret

; ---- code $5C42-$5C64 (34 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split [executed in 3 scenarios]

AbookName_GetRowPtr:: ; 2F:5C42
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	inc b

Label_2F_5C4D:: ; 2F:5C4D
	ld d, $00
	ld e, $0C
	dec b
	jr z, Label_2F_5C66

Label_2F_5C54:: ; 2F:5C54
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_5C66
	inc hl
	inc hl
	cp a, $0D
	jr z, Label_2F_5C4D
	dec e
	jr nz, Label_2F_5C54

; ---- code $5C64-$5C66 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split
	jr Label_2F_5C4D

; ---- code $5C66-$5CB4 (78 bytes) [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5C66:: ; 2F:5C66
	ld a, $FF
	cp a, d
	jr z, Label_2F_5C7F
	ld e, $00
	push hl

Label_2F_5C6E:: ; 2F:5C6E
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, Label_2F_5C7E
	cp a, $0D
	jr z, Label_2F_5C7E
	inc e
	ld a, $0B
	cp a, e
	jr nz, Label_2F_5C6E

Label_2F_5C7E:: ; 2F:5C7E
	pop hl

Label_2F_5C7F:: ; 2F:5C7F
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

AbookName_InsertChar:: ; 2F:5C85
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D522
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_5CA8
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

Label_2F_5CA8:: ; 2F:5CA8
	push de
	push bc
	ld b, $07
	ld c, $00
	call AbookName_GetRowPtr
	inc d
	jr z, Label_2F_5CF4

; ---- code $5CB4-$5CC5 (17 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage --split
	pop bc
	push bc
	ld c, $0B

Label_2F_5CB8:: ; 2F:5CB8
	call AbookName_GetCharPtr
	inc d
	jr nz, Label_2F_5CD2
	ld a, e
	cp a, $0B
	jr z, Label_2F_5CDD
	jr Label_2F_5CF4

; ---- data $5CC5-$5CD2 (13 bytes) [HYPOTHESIS] UNCLASSIFIED 13 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5CC5:: ; 2F:5CC5
	db $3E, $01, $E0, $8D, $E0, $70, $7E, $FE, $0D, $FE, $00, $28, $22

; ---- code $5CD2-$5CF4 (34 bytes) [PROBABLE] 334 insn(s) reached by static flow only; seeds: exec x334; min discovery hops 5; entered by jrcc from 2F:5CBC (PROBABLE code) | 22 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split

Label_2F_5CD2:: ; 2F:5CD2
	ld a, $08
	cp a, b
	jr z, Label_2F_5CDD
	inc b
	ld a, $08
	cp a, b
	jr nz, Label_2F_5CB8

Label_2F_5CDD:: ; 2F:5CDD
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	ret

; ---- code $5CF4-$5DB1 (189 bytes) [CONFIRMED] 99 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5CF4:: ; 2F:5CF4
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	push de
	push bc
	push bc
	ld hl, $DA10
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call AbookName_PlaceCursorSprites
	ld d, $14

Label_2F_5D23:: ; 2F:5D23
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, Label_2F_5D45
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2F_5D45
	dec d
	jr nz, Label_2F_5D23

Label_2F_5D45:: ; 2F:5D45
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	call AbookName_PlaceCursorSprites
	farcall Function_00_0956
	pop bc
	pop de
	push de
	call AbookName_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D522
	ld bc, $D520

Label_2F_5D7C:: ; 2F:5D7C
	ld a, d
	cp a, h
	jr nz, Label_2F_5D84
	ld a, e
	cp a, l
	jr z, Label_2F_5D90

Label_2F_5D84:: ; 2F:5D84
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr Label_2F_5D7C

Label_2F_5D90:: ; 2F:5D90
	pop hl
	pop de
	pop bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ld a, b
	cp a, $07
	jr nz, Label_2F_5DB6

; ---- code $5DB1-$5DB6 (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld a, c
	cp a, $0B
	jr z, Label_2F_5DDB

; ---- code $5DB6-$5DC1 (11 bytes) [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5DB6:: ; 2F:5DB6
	call AbookName_GetCharPtr
	cp a, $FF
	jr z, Label_2F_5DDB
	cp a, $0D
	jr nz, Label_2F_5DCA

; ---- code $5DC1-$5DCA (9 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr Label_2F_5DDB

; ---- code $5DCA-$5DD4 (10 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 3 scenarios]

Label_2F_5DCA:: ; 2F:5DCA
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, Label_2F_5DDB

; ---- code $5DD4-$5DDB (7 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

; ---- code $5DDB-$5E11 (54 bytes) [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 2 scenarios]

Label_2F_5DDB:: ; 2F:5DDB
	ret

AbookName_Backspace:: ; 2F:5DDC
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B80
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	dec b
	ld c, $0B
	call AbookName_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, Label_2F_5E19

; ---- code $5E11-$5E19 (8 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, Label_2F_5E1A
	dec b
	ld c, e
	inc c

; ---- code $5E19-$5E5D (68 bytes) [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 2 scenarios]

Label_2F_5E19:: ; 2F:5E19
	dec c

Label_2F_5E1A:: ; 2F:5E1A
	call AbookName_PlaceCursorSprites
	pop bc
	ld d, $14

Label_2F_5E20:: ; 2F:5E20
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, Label_2F_5E42
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2F_5E42
	dec d
	jr nz, Label_2F_5E20

Label_2F_5E42:: ; 2F:5E42
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	inc c
	dec c
	jr nz, Label_2F_5E68

; ---- code $5E5D-$5E68 (11 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	inc b
	dec b
	jr z, Label_2F_5E6D
	dec b
	call AbookName_GetCharPtr
	ld c, e
	jr Label_2F_5E6D

; ---- code $5E68-$5E85 (29 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 2 scenarios]

Label_2F_5E68:: ; 2F:5E68
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a

Label_2F_5E6D:: ; 2F:5E6D
	call AbookName_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	pop bc
	push hl
	inc bc
	inc bc
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, Label_2F_5E87

; ---- code $5E85-$5E87 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld e, $01

; ---- code $5E87-$5F01 (122 bytes) [CONFIRMED] 79 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5E87:: ; 2F:5E87
	ld a, $22
	cp a, l
	jr nz, Label_2F_5E91
	ld a, $D5
	cp a, h
	jr z, Label_2F_5E99

Label_2F_5E91:: ; 2F:5E91
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr Label_2F_5E87

Label_2F_5E99:: ; 2F:5E99
	xor a, a
	ld [hli], a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

AbookName_ApplyDakuten:: ; 2F:5EB3
	call AbookName_GetCharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2F_5EC1
	ld a, $D5
	cp a, h
	jp z, Label_2F_5F3C

Label_2F_5EC1:: ; 2F:5EC1
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Abook_DakutenKanaList

Label_2F_5ECD:: ; 2F:5ECD
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2F_5F30
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2F_5F25
	ld a, [hl]
	cp a, c
	jr nz, Label_2F_5F25
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wKeyboardCharLo], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, Label_2F_5F13

; ---- code $5F01-$5F13 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

; ---- code $5F13-$5F28 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5F13:: ; 2F:5F13
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

Label_2F_5F25:: ; 2F:5F25
	pop hl
	jr Label_2F_5ECD

; ---- code $5F28-$5F30 (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $5F30-$5F41 (17 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 6; entered by jrcc from 2F:5ED1 (PROBABLE code) [executed in 1 scenarios]

Label_2F_5F30:: ; 2F:5F30
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

Label_2F_5F3C:: ; 2F:5F3C
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $5F41-$5F92 (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Abook_DakutenKanaList:: ; 2F:5F41
String_2F_5F41::
	db $82, $A9, $82, $AB, $82, $AD, $82, $AF, $82, $B1, $82, $B3, $82, $B5, $82, $B7, $82, $B9, $82, $BB, $82, $BD, $82, $BF, $82, $C2, $82, $C4, $82, $C6, $82, $CD, $82, $D0 ; "かきくけこさしすせそたちつてとはひ"
	db $82, $D3, $82, $D6, $82, $D9, $83, $4A, $83, $4C, $83, $4E, $83, $50, $83, $52, $83, $54, $83, $56, $83, $58, $83, $5A, $83, $5C, $83, $5E, $83, $60, $83, $63, $83, $65 ; "ふへほカキクケコサシスセソタチツテ"
	db $83, $67, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "トハヒフヘホ"

; ---- data $5F92-$5F93 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5F92:: ; 2F:5F92
	db $C9

; ---- code $5F93-$5FE0 (77 bytes) [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 5; entered by call from 2F:617B (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE region 5F93-6007 by apply_coverage --split [executed in 1 scenarios]

AbookName_ApplyDakutenU:: ; 2F:5F93
	call AbookName_GetCharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2F_5FA1
	ld a, $D5
	cp a, h
	jp z, Label_2F_602B

Label_2F_5FA1:: ; 2F:5FA1
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_2F_6040

Label_2F_5FAD:: ; 2F:5FAD
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2F_600F
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, Label_2F_6004
	ld a, [hl]
	cp a, $45
	jr nz, Label_2F_6004
	ld a, $94
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, Label_2F_5FF2

; ---- code $5FE0-$5FF2 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F93-6007 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

; ---- code $5FF2-$6004 (18 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5F93-6007 by apply_coverage --split [executed in 1 scenarios]

Label_2F_5FF2:: ; 2F:5FF2
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

; ---- code $6004-$6007 (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5F93-6007 by apply_coverage --split

Label_2F_6004:: ; 2F:6004
	pop hl
	jr Label_2F_5FAD

; ---- code $6007-$600F (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $600F-$602B (28 bytes) [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 6; entered by jrcc from 2F:5FB1 (PROBABLE code) | 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 600F-6040 by apply_coverage --split

Label_2F_600F:: ; 2F:600F
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $602B-$6040 (21 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 600F-6040 by apply_coverage --split [executed in 1 scenarios]

Label_2F_602B:: ; 2F:602B
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $6040-$6045 (5 bytes) [PROBABLE] NUL-terminated Shift-JIS string (82 A4 82 A4 00); read byte by byte by 2F:5FAA (ld de,$6040; ld a,[de]; inc de; cp $00); identical bytes at 2C:4878. The following $C9 (ret) stays unresolved in the next region

String_2F_6040:: ; 2F:6040
	db $82, $A4, $82, $A4, $00 ; "うう"

; ---- data $6045-$6046 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 byte $C9 (ret) between a string and code; no entry found

Data_2F_6045:: ; 2F:6045
	db $C9

; ---- code $6046-$6091 (75 bytes) [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 6; entered by call from 2F:618E (PROBABLE code) | 49 insn(s) executed; cut out of the PROBABLE region 6046-60B8 by apply_coverage --split [executed in 1 scenarios]

AbookName_ApplyHandakuten:: ; 2F:6046
	call AbookName_GetCharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2F_6054
	ld a, $D5
	cp a, h
	jp z, Label_2F_60DC

Label_2F_6054:: ; 2F:6054
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Abook_HandakutenKanaList

Label_2F_6060:: ; 2F:6060
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2F_60C0
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2F_60B5
	ld a, [hl]
	cp a, c
	jr nz, Label_2F_60B5
	inc a
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, Label_2F_60A3

; ---- code $6091-$60A3 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6046-60B8 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

; ---- code $60A3-$60B8 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 6046-60B8 by apply_coverage --split [executed in 1 scenarios]

Label_2F_60A3:: ; 2F:60A3
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

Label_2F_60B5:: ; 2F:60B5
	pop hl
	jr Label_2F_6060

; ---- code $60B8-$60C0 (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $60C0-$60DC (28 bytes) [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 7; entered by jrcc from 2F:6064 (PROBABLE code) | 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 60C0-60F1 by apply_coverage --split

Label_2F_60C0:: ; 2F:60C0
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $60DC-$60F1 (21 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 60C0-60F1 by apply_coverage --split [executed in 1 scenarios]

Label_2F_60DC:: ; 2F:60DC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $60F1-$6106 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Abook_HandakutenKanaList:: ; 2F:60F1
String_2F_60F1::
	db $82, $CD, $82, $D0, $82, $D3, $82, $D6, $82, $D9, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "はひふへほハヒフヘホ"

; ---- data $6106-$6107 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_6106:: ; 2F:6106
	db $C9

; ---- code $6107-$61C9 (194 bytes) [CONFIRMED] 89 insn(s) reached by static flow only; seeds: exec x89; min discovery hops 4; entered by call from 2F:5854 (PROBABLE code) [executed in 1 scenarios]

AbookName_OpenKeyboard:: ; 2F:6107
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $08
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc

AbookName_KeyboardLoop:: ; 2F:613A
	push bc
	call AbookName_PlaceCursorSprites
	ld d, $70
	farcall Function_00_0956
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, AbookName_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, Label_2F_61A0
	cp a, $07
	ret z
	cp a, $08
	jr z, Label_2F_61AB
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Label_2F_6180
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2F_6180
	call AbookName_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, AbookName_KeyboardLoop
	call AbookName_ApplyDakutenU
	jr AbookName_KeyboardLoop

Label_2F_6180:: ; 2F:6180
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, Label_2F_6193
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2F_6193
	call AbookName_ApplyHandakuten
	jr AbookName_KeyboardLoop

Label_2F_6193:: ; 2F:6193
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call AbookName_InsertChar
	jr AbookName_KeyboardLoop

Label_2F_61A0:: ; 2F:61A0
	ld a, c
	or a, b
	jr nz, Label_2F_61C3
	call AbookName_GetLength
	cp a, $00
	jr nz, Label_2F_61C3

Label_2F_61AB:: ; 2F:61AB
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall Joypad_Update
	pop bc
	ret

Label_2F_61C3:: ; 2F:61C3
	call AbookName_Backspace
	jp AbookName_KeyboardLoop

; ---- data $61C9-$61CE (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_61C9:: ; 2F:61C9
	db $C9, $C3, $3A, $61, $C9

; ---- code $61CE-$61E0 (18 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 6; entered by call from 2F:61A4 (PROBABLE code) | 10 insn(s) executed; cut out of the PROBABLE region 61CE-61EA by apply_coverage --split [executed in 1 scenarios]

AbookName_GetLength:: ; 2F:61CE
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	ld d, $00

Label_2F_61DB:: ; 2F:61DB
	ld a, [hli]
	cp a, $00
	jr z, Label_2F_61E6

; ---- code $61E0-$61E6 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 61CE-61EA by apply_coverage --split
	inc d
	ld a, $10
	cp a, d
	jr nz, Label_2F_61DB

; ---- code $61E6-$61EA (4 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 61CE-61EA by apply_coverage --split [executed in 1 scenarios]

Label_2F_61E6:: ; 2F:61E6
	ld a, d
	pop de
	pop hl
	ret

; ---- zero $61EA-$61F0 (6 bytes) [PROBABLE] 6 zero bytes of padding before the tile block at 61F0
	ds $6, $00
