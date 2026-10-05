; engine/address_book/name_editor.asm
; bank 2F, $57F2-$61F0 (2558 bytes); pinned by layout.link
; address book name editor with kana keyboard

SECTION "engine/address_book/name_editor", ROMX

AbookName_Edit:: ; 2F:57F2
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by far from 2F:7F1C (PROBABLE code) [executed in 1 scenarios]
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	push af
	call AbookName_SetupScreen
	ld d, $0A
.loop ; 2F:581A
	push de
	call AbookName_CursorRightStep
	pop de
	dec d
	jr nz, .loop
	pop af
	cp a, $01
	jr nz, AbookName_Edit_Loop
	call AbookName_KeyboardLoop
	jp AbookName_Edit_AfterKeyboard

; ---- data $582D-$5832 (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_582D:: ; 2F:582D
	db $F1, $FE, $01, $28, $22

AbookName_Edit_Loop:: ; 2F:5832
Label_2F_5832::
	; [CONFIRMED] 102 insn(s) reached by static flow only; seeds: exec x102; min discovery hops 3;
	; entered by jrcc from 2F:5825 (PROBABLE code) | 3 insn(s) executed; cut out of the PROBABLE
	; region 5832-590B by apply_coverage --split [executed in 6 scenarios]
	ld a, c
	cp a, $09
	jr c, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5832-590B by apply_coverage --split
	ld c, $08

.skip ; 2F:5839
	; [CONFIRMED] 77 insn(s) executed; cut out of the PROBABLE region 5832-590B by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call AbookName_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, AbookName_Edit_CheckButtonB
	call AbookName_OpenKeyboard

AbookName_Edit_AfterKeyboard:: ; 2F:5857
Label_2F_5857::
	cp a, $07
	jr nz, AbookName_Edit_CheckButtonB
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	pop bc
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ret

AbookName_Edit_CheckButtonB:: ; 2F:5876
Label_2F_5876::
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l58BB
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call VBlank_Wait
	ld a, $FF
	ret
.l58BB ; 2F:58BB
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, AbookName_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, AbookName_CursorRight
	ld d, $10
	jp AbookName_Edit_Loop

AbookName_CursorLeft:: ; 2F:58CE
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	dec c
	jr nz, .l58EF
	inc b
	dec b
	ret z

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5832-590B by apply_coverage --split
	dec b
	call AbookName_GetCharPtr
	ld c, e
	ret

.l58EF ; 2F:58EF
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 5832-590B by apply_coverage
	; --split [executed in 1 scenarios]
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

AbookName_CursorRightStep:: ; 2F:5909
	jr .l5914

	; [HYPOTHESIS] 6 insn(s) (ld a,b ; cp $07 ; jr nz,end ; ld a,c ; cp $0B ; ret z) falling into
	; the code at $5914; identical bytes at 2F:590B and 2F:6F44; well-formed instruction chain
	; (clean decode, all direct targets land on instruction starts, lands exactly on the next code
	; region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to
	; HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank
	; search for the address word) and it is not a fall-through of proven code, so it is only bytes
	; that decode cleanly
	ld a, b
	cp a, $07
	jr nz, .l5914
	ld a, c
	cp a, $0B
	ret z

.l5914 ; 2F:5914
	; [CONFIRMED] 372 insn(s) reached by static flow only; seeds: exec x372; min discovery hops 3;
	; entered by jr from 2F:5909 (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE
	; region 5914-5C30 by apply_coverage --split [executed in 3 scenarios]
	inc c
	dec c
	jr nz, .l5925
	call AbookName_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
.l5925 ; 2F:5925
	call AbookName_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $09
	cp a, c
	ret nz

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5914-5C30 by apply_coverage --split
	ld c, $08
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

AbookName_SetupScreen:: ; 2F:593B
	; [CONFIRMED] 152 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage
	; --split [executed in 1 scenarios]
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_AbookName_Tiles9300Vb1
	ld a, $2F
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, Gfx_AbookName_Tiles9700Vb1
	ld a, $2F
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8800
	ld hl, Gfx_AbookName_Tiles8800
	ld a, $2F
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_AbookEdit_Tiles8000
	ld a, $29
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMA
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AbookEdit_Obj
	ld a, $29
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_AbookName_Bg
	ld a, $2F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_AbookName
	ld a, $2F
	farcall Tilemap_CopyRectAndAttr
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, $DA20
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	pop af
	push af
	dec a
	jr nz, .l5A37
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
.l5A37 ; 2F:5A37
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
	jr nz, .l5A81
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr .l5AB0
.l5A81 ; 2F:5A81
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
.l5AB0 ; 2F:5AB0
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
.l5AC5 ; 2F:5AC5
	dec b
	jr z, .l5ACC

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5914-5C30 by apply_coverage --split
	add a, $0C
	jr .l5AC5

.l5ACC ; 2F:5ACC
	; [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage
	; --split [executed in 4 scenarios]
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $38
.l5ADB ; 2F:5ADB
	dec c
	jr z, .l5AE2
	add a, $0C
	jr .l5ADB
.l5AE2 ; 2F:5AE2
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

AbookName_DrawName:: ; 2F:5AEA
	ld a, $10
	ld [wTextCellsLeft], a
.l5AEF ; 2F:5AEF
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l5B8A
	cp a, $0D
	jr z, .l5B6F
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l5B4A
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
	jr z, .l5B8A
	cp a, $01
	jr z, .l5B8A
	jr .l5AEF

.l5B4A ; 2F:5B4A
	; [PROBABLE] 32 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5914-5C30 by apply_coverage --split
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
	jr z, .l5B8A
	cp a, $01
	jr z, .l5B8A
	jr .l5AEF
.l5B6F ; 2F:5B6F
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

.l5B8A ; 2F:5B8A
	; [CONFIRMED] 96 insn(s) executed; cut out of the PROBABLE region 5914-5C30 by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l5B96 ; 2F:5B96
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookName_DrawName_Pad
	jr .l5B96

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
.l5BFD ; 2F:5BFD
	ld a, [de]
	cp a, $8F
	jr nz, .l5BFD
	ld b, $91
.l5C04 ; 2F:5C04
	ld a, [de]
	cp a, b
	jr nz, .l5C04
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
	jr z, AbookName_GetCharPtr_NoChar
	inc c
	ld a, [hl]
.loop ; 2F:5C1F
	dec c
	jr z, AbookName_GetCharPtr_Found
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, AbookName_GetCharPtr_NoChar
	ld a, [hl]
	cp a, $0D
	jr z, AbookName_GetCharPtr_Newline
	jr .loop

; ---- data $5C30-$5C34 (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5C30:: ; 2F:5C30
	db $0C, $0D, $20, $02

AbookName_GetCharPtr_Found:: ; 2F:5C34
Label_2F_5C34::
	; [CONFIRMED] 88 insn(s) reached by static flow only; seeds: exec x88; min discovery hops 7;
	; entered by jrcc from 2F:5C20 (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE
	; region 5C34-5CC5 by apply_coverage --split [executed in 4 scenarios]
	pop bc
	ret

AbookName_GetCharPtr_NoChar:: ; 2F:5C36
Label_2F_5C36::
	ld a, $FF
	ld d, $FF
	pop bc
	ret

AbookName_GetCharPtr_Newline:: ; 2F:5C3C
Label_2F_5C3C::
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5C34-5CC5 by apply_coverage --split
	ld a, $0D
	ld d, $FF
	pop bc
	ret

AbookName_GetRowPtr:: ; 2F:5C42
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	inc b
.l5C4D ; 2F:5C4D
	ld d, $00
	ld e, $0C
	dec b
	jr z, .l5C66
.l5C54 ; 2F:5C54
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l5C66
	inc hl
	inc hl
	cp a, $0D
	jr z, .l5C4D
	dec e
	jr nz, .l5C54

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5C34-5CC5 by apply_coverage --split
	jr .l5C4D

.l5C66 ; 2F:5C66
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 5C34-5CC5 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $FF
	cp a, d
	jr z, .l5C7F
	ld e, $00
	push hl
.l5C6E ; 2F:5C6E
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l5C7E
	cp a, $0D
	jr z, .l5C7E
	inc e
	ld a, $0B
	cp a, e
	jr nz, .l5C6E
.l5C7E ; 2F:5C7E
	pop hl
.l5C7F ; 2F:5C7F
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
	jr z, .l5CA8
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret
.l5CA8 ; 2F:5CA8
	push de
	push bc
	ld b, $07
	ld c, $00
	call AbookName_GetRowPtr
	inc d
	jr z, AbookName_InsertChar_Insert

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5C34-5CC5 by apply_coverage --split
	pop bc
	push bc
	ld c, $0B

AbookName_InsertChar_CheckRow:: ; 2F:5CB8
Label_2F_5CB8::
	call AbookName_GetCharPtr
	inc d
	jr nz, AbookName_InsertChar_NextRow
	ld a, e
	cp a, $0B
	jr z, AbookName_InsertChar_Reject
	jr AbookName_InsertChar_Insert

; ---- data $5CC5-$5CD2 (13 bytes) [HYPOTHESIS] UNCLASSIFIED 13 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5CC5:: ; 2F:5CC5
	db $3E, $01, $E0, $8D, $E0, $70, $7E, $FE, $0D, $FE, $00, $28, $22

AbookName_InsertChar_NextRow:: ; 2F:5CD2
Label_2F_5CD2::
	; [PROBABLE] 334 insn(s) reached by static flow only; seeds: exec x334; min discovery hops 5;
	; entered by jrcc from 2F:5CBC (PROBABLE code) | 22 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage --split
	ld a, $08
	cp a, b
	jr z, AbookName_InsertChar_Reject
	inc b
	ld a, $08
	cp a, b
	jr nz, AbookName_InsertChar_CheckRow

AbookName_InsertChar_Reject:: ; 2F:5CDD
Label_2F_5CDD::
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	ret

AbookName_InsertChar_Insert:: ; 2F:5CF4
Label_2F_5CF4::
	; [CONFIRMED] 99 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
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
	farcall Sprite_InitSlot
	pop bc
	call AbookName_PlaceCursorSprites
	ld d, $14
.l5D23 ; 2F:5D23
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, .l5D45
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l5D45
	dec d
	jr nz, .l5D23
.l5D45 ; 2F:5D45
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	call AbookName_PlaceCursorSprites
	farcall Sprite_UpdateAll
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
.l5D7C ; 2F:5D7C
	ld a, d
	cp a, h
	jr nz, .l5D84
	ld a, e
	cp a, l
	jr z, .l5D90
.l5D84 ; 2F:5D84
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
	jr .l5D7C
.l5D90 ; 2F:5D90
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
	jr nz, .l5DB6

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	ld a, c
	cp a, $0B
	jr z, .done

.l5DB6 ; 2F:5DB6
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 3 scenarios]
	call AbookName_GetCharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l5DCA

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l5DCA ; 2F:5DCA
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 3 scenarios]
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .done

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.done ; 2F:5DDB
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 2 scenarios]
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B80
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	dec b
	ld c, $0B
	call AbookName_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l5E19

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, .l5E1A
	dec b
	ld c, e
	inc c

.l5E19 ; 2F:5E19
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 2 scenarios]
	dec c
.l5E1A ; 2F:5E1A
	call AbookName_PlaceCursorSprites
	pop bc
	ld d, $14
.loop ; 2F:5E20
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, .l5E42
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l5E42
	dec d
	jr nz, .loop
.l5E42 ; 2F:5E42
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	inc c
	dec c
	jr nz, .l5E68

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	inc b
	dec b
	jr z, .l5E6D
	dec b
	call AbookName_GetCharPtr
	ld c, e
	jr .l5E6D

.l5E68 ; 2F:5E68
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 2 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l5E6D ; 2F:5E6D
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
	jr nz, .l5E87

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	ld e, $01

.l5E87 ; 2F:5E87
	; [CONFIRMED] 79 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $22
	cp a, l
	jr nz, .l5E91
	ld a, $D5
	cp a, h
	jr z, .l5E99
.l5E91 ; 2F:5E91
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l5E87
.l5E99 ; 2F:5E99
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
	jr nz, .l5EC1
	ld a, $D5
	cp a, h
	jp z, .l5F3C
.l5EC1 ; 2F:5EC1
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Abook_DakutenKanaList
.loop ; 2F:5ECD
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l5F30
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l5F25
	ld a, [hl]
	cp a, c
	jr nz, .l5F25
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
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
	jr nz, .l5F13

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5CD2-5F28 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

.l5F13 ; 2F:5F13
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5CD2-5F28 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret
.l5F25 ; 2F:5F25
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l5F30 ; 2F:5F30
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 6;
	; entered by jrcc from 2F:5ED1 (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.l5F3C ; 2F:5F3C
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $5F41-$5F92 (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Abook_DakutenKanaList:: ; 2F:5F41
String_2F_5F41::
	db "かきくけこさしすせそたちつてとはひふへほカキクケコサシスセソタチツテトハヒフヘホ", 0
POPC

; ---- data $5F92-$5F93 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_5F92:: ; 2F:5F92
	db $C9

AbookName_ApplyDakutenU:: ; 2F:5F93
	; [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 5;
	; entered by call from 2F:617B (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE
	; region 5F93-6007 by apply_coverage --split [executed in 1 scenarios]
	call AbookName_GetCharPtr
	ld a, $14
	cp a, l
	jr nz, .l5FA1
	ld a, $D5
	cp a, h
	jp z, .l602B
.l5FA1 ; 2F:5FA1
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, Table_AbookName_ApplyDakutenU_LoopPairs
.loop ; 2F:5FAD
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l600F
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, .l6004
	ld a, [hl]
	cp a, $45
	jr nz, .l6004
	ld a, $94
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l5FF2

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F93-6007 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

.l5FF2 ; 2F:5FF2
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 5F93-6007 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

.l6004 ; 2F:6004
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5F93-6007 by apply_coverage --split
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l600F ; 2F:600F
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 6;
	; entered by jrcc from 2F:5FB1 (PROBABLE code) | 17 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 600F-6040 by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l602B ; 2F:602B
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 600F-6040 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $6040-$6045 (5 bytes) [PROBABLE] NUL-terminated Shift-JIS string (82 A4 82 A4 00); read byte by byte by 2F:5FAA (ld de,$6040; ld a,[de]; inc de; cp $00); identical bytes at 2C:4878. The following $C9 (ret) stays unresolved in the next region

PUSHC sjis
Table_AbookName_ApplyDakutenU_LoopPairs:: ; 2F:6040
String_2F_6040::
	db "うう", 0
POPC

; ---- data $6045-$6046 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 byte $C9 (ret) between a string and code; no entry found

Data_2F_6045:: ; 2F:6045
	db $C9

AbookName_ApplyHandakuten:: ; 2F:6046
	; [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 6;
	; entered by call from 2F:618E (PROBABLE code) | 49 insn(s) executed; cut out of the PROBABLE
	; region 6046-60B8 by apply_coverage --split [executed in 1 scenarios]
	call AbookName_GetCharPtr
	ld a, $14
	cp a, l
	jr nz, .l6054
	ld a, $D5
	cp a, h
	jp z, .l60DC
.l6054 ; 2F:6054
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Abook_HandakutenKanaList
.loop ; 2F:6060
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l60C0
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l60B5
	ld a, [hl]
	cp a, c
	jr nz, .l60B5
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l60A3

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6046-60B8 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret

.l60A3 ; 2F:60A3
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 6046-60B8 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, $0300
	ld de, $0038
	ld hl, $D514
	call AbookName_DrawName
	call AbookName_UploadTextTiles
	pop bc
	ret
.l60B5 ; 2F:60B5
	pop hl
	jr .loop

	; [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ;
	; ret), identical bytes to 2C:4760/483F/48F0; follows an unconditional jr; well-formed
	; instruction chain (clean decode, all direct targets land on instruction starts, lands exactly
	; on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier:
	; downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the
	; ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it
	; is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l60C0 ; 2F:60C0
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 7;
	; entered by jrcc from 2F:6064 (PROBABLE code) | 17 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 60C0-60F1 by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l60DC ; 2F:60DC
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 60C0-60F1 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $60F1-$6106 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Abook_HandakutenKanaList:: ; 2F:60F1
String_2F_60F1::
	db "はひふへほハヒフヘホ", 0
POPC

; ---- data $6106-$6107 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_6106:: ; 2F:6106
	db $C9

AbookName_OpenKeyboard:: ; 2F:6107
	; [CONFIRMED] 89 insn(s) reached by static flow only; seeds: exec x89; min discovery hops 4;
	; entered by call from 2F:5854 (PROBABLE code) [executed in 1 scenarios]
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
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, AbookName_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, .l61A0
	cp a, $07
	ret z
	cp a, $08
	jr z, .l61AB
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l6180
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l6180
	call AbookName_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, AbookName_KeyboardLoop
	call AbookName_ApplyDakutenU
	jr AbookName_KeyboardLoop
.l6180 ; 2F:6180
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l6193
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l6193
	call AbookName_ApplyHandakuten
	jr AbookName_KeyboardLoop
.l6193 ; 2F:6193
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call AbookName_InsertChar
	jr AbookName_KeyboardLoop
.l61A0 ; 2F:61A0
	ld a, c
	or a, b
	jr nz, .l61C3
	call AbookName_GetLength
	cp a, $00
	jr nz, .l61C3
.l61AB ; 2F:61AB
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall Joypad_Update
	pop bc
	ret
.l61C3 ; 2F:61C3
	call AbookName_Backspace
	jp AbookName_KeyboardLoop

; ---- data $61C9-$61CE (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_61C9:: ; 2F:61C9
	db $C9, $C3, $3A, $61, $C9

AbookName_GetLength:: ; 2F:61CE
	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 6;
	; entered by call from 2F:61A4 (PROBABLE code) | 10 insn(s) executed; cut out of the PROBABLE
	; region 61CE-61EA by apply_coverage --split [executed in 1 scenarios]
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	ld d, $00
.loop ; 2F:61DB
	ld a, [hli]
	cp a, $00
	jr z, .l61E6

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 61CE-61EA by apply_coverage --split
	inc d
	ld a, $10
	cp a, d
	jr nz, .loop

.l61E6 ; 2F:61E6
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 61CE-61EA by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, d
	pop de
	pop hl
	ret

; ---- zero $61EA-$61F0 (6 bytes) [PROBABLE] 6 zero bytes of padding before the tile block at 61F0
	ds $6, $00
