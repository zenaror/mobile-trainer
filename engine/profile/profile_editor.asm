; engine/profile/profile_editor.asm
; bank 2A, $5495-$6300 (3691 bytes); pinned by layout.link
; profile (nickname) editor with the kana keyboard

SECTION "engine/profile/profile_editor", ROMX

; ---- code $5495-$5502 (109 bytes) [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Profile_Edit:: ; 2A:5495
Function_2A_5495::
	ld [wMailScreenMode], a
	call Function_00_044B
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call Function_00_0464
	push bc
	ld a, $00
	ld hl, $AF50
	farcall Account_CopyMailAddressToFar
	farcall SramCheck_Bank0Commit
	pop bc
	call Profile_InitScreen
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr z, Label_2A_552A
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_PlaceTextCursor

Profile_Edit_Loop:: ; 2A:54FD
	ld a, c
	cp a, $09
	jr nz, Label_2A_5504

; ---- code $5502-$5504 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2A:5500 (executed)
	ld c, $08

; ---- code $5504-$554B (71 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)

Label_2A_5504:: ; 2A:5504
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call Profile_PlaceTextCursor
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlots + 33], a
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2A_56EC

Label_2A_552A:: ; 2A:552A
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	call Profile_KeyboardLoop
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	cp a, $09
	jr nz, Label_2A_55AD

; ---- code $554B-$55AD (98 bytes) [PROBABLE] 52 insn(s) reached by static flow only; seeds: exec x52; min discovery hops 0; fall-through of the jrcc at 2A:5549 (executed)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jp nz, Label_2A_5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	push bc
	ld de, $0214
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
	push de
	pop de
	farcall Dialog_Show
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
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	jp Label_2A_552A

; ---- code $55AD-$55B6 (9 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_2A_55AD:: ; 2A:55AD
	cp a, $08
	jr z, Label_2A_55B6
	cp a, $07
	jp z, Label_2A_563D

; ---- code $55B6-$563D (135 bytes) [CONFIRMED] 72 insn(s) reached by static flow only; seeds: exec x72; min discovery hops 0; entered by jrcc from 2A:55AF (executed) [executed in 1 scenarios]

Label_2A_55B6:: ; 2A:55B6
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr nz, Label_2A_5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	push bc
	ld de, $0214
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
	push de
	pop de
	farcall Dialog_Show
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
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	jp Label_2A_552A

Label_2A_5617:: ; 2A:5617
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	push bc
	ld de, $020E
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	dec a
	call Profile_SaveToSram
	jp Profile_Edit_Loop

; ---- code $563D-$564B (14 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_2A_563D:: ; 2A:563D
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr nz, Label_2A_569E

; ---- code $564B-$569E (83 bytes) [CONFIRMED] 45 insn(s) reached by static flow only; seeds: exec x45; min discovery hops 0; fall-through of the jrcc at 2A:5649 (executed) [executed in 1 scenarios]
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	push bc
	ld de, $0214
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
	push de
	pop de
	farcall Dialog_Show
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
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	jp Label_2A_552A

; ---- code $569E-$56C8 (42 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)

Label_2A_569E:: ; 2A:569E
	push af
	push bc
	ld de, $40D0
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	push bc
	ld de, $020E
	pop bc
	push af
	push bc
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	pop bc
	pop af
	dec a
	call Profile_SaveToSram
	ld a, [wMailScreenMode]
	dec a
	jp z, Label_2A_5706

; ---- code $56C8-$56CB (3 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 2A:56C5 (executed) [executed in 5 scenarios]
	jp Profile_Edit_Loop

; ---- code $56CB-$56EC (33 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $56CB-$56EC was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: call chain (call $6257, 9 x call $577F, jp $54FD, call $62C5): all call targets are known code; directly after the unconditional 'jp $54FD' at 2A:56C8
	call Profile_LoadAndDraw
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	call Profile_MoveCursorRight
	jp Profile_Edit_Loop

	call Profile_SaveToSram

; ---- code $56EC-$56F2 (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_2A_56EC:: ; 2A:56EC
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2A_5731

; ---- code $56F2-$5706 (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 2A:56F0 (executed) [executed in 5 scenarios]
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

; ---- code $5706-$5744 (62 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 1/18 scenarios)

Label_2A_5706:: ; 2A:5706
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

Label_2A_5731:: ; 2A:5731
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, Profile_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, Profile_CursorRight
	ld d, $10
	jp Profile_Edit_Loop

; ---- code $5744-$575F (27 bytes) [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1; entered by callcc from 2A:5735 (executed) | 18 insn(s) executed; cut out of the PROBABLE region 5744-577F by apply_coverage --split [executed in 1 scenarios]

Profile_CursorLeft:: ; 2A:5744
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
	jr nz, Label_2A_5765
	inc b
	dec b
	ret z

; ---- code $575F-$5765 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5744-577F by apply_coverage --split
	dec b
	call $4441
	ld c, e
	ret

; ---- code $5765-$577F (26 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5744-577F by apply_coverage --split [executed in 2 scenarios]

Label_2A_5765:: ; 2A:5765
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

Profile_CursorRight:: ; 2A:576B
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

; ---- code $577F-$5781 (2 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Profile_MoveCursorRight:: ; 2A:577F
Function_2A_577F::
	jr Label_2A_578A

; ---- code $5781-$578A (9 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $5781-$578A was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: ld a,b; cp 7; jr nz; ld a,c; cp 9; ret z - skipped by the unconditional 'jr $578A' at 2A:577F, falls into 578A
	ld a, b
	cp a, $07
	jr nz, Label_2A_578A
	ld a, c
	cp a, $09
	ret z

; ---- code $578A-$57A5 (27 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)

Label_2A_578A:: ; 2A:578A
	inc c
	dec c
	jr nz, Label_2A_579B
	call Profile_CharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

Label_2A_579B:: ; 2A:579B
	call Profile_CharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, Label_2A_57AD

; ---- code $57A5-$57AD (8 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2A:57A3 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $57AD-$57B6 (9 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_2A_57AD:: ; 2A:57AD
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $09
	cp a, c
	ret nz

; ---- code $57B6-$57BD (7 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the retcc at 2A:57B5 (executed)
	ld c, $08
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $57BD-$591B (350 bytes) [CONFIRMED] 123 insn(s); 123 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Profile_InitScreen:: ; 2A:57BD
Function_2A_57BD::
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	ld de, $9301
	ld hl, Gfx_Profile_Tiles9300
	ld a, $2A
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	call Function_00_0464
	ld de, $9701
	ld hl, $6700
	ld a, $2A
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8800
	ld hl, $6800
	ld a, $2A
	ld b, $93
	ld c, $34
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8000
	ld hl, Data_26_7820
	ld a, $26
	ld b, $94
	ld c, $2A
	farcall Function_00_0749
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_26_7AC0
	ld a, $26
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_Profile_Bg
	ld a, $2A
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, Data_Profile_TilemapAttr
	ld a, $2A
	farcall Function_00_08EA
	call Function_00_0464
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
	ld hl, $DA30
	ld de, $6E70
	ld a, $2A
	ld b, $81
	farcall Function_00_0A82
	ld de, $2000
	ld hl, $DA30
	call Function_00_0A65
	ld hl, $DA60
	ld de, $6E80
	ld a, $2A
	ld b, $81
	farcall Function_00_0A82
	ld de, $4000
	ld hl, $DA60
	call Function_00_0A65
	ldh a, [rLCDC]
	call Function_00_082C
	ld bc, $0000
	call Profile_PlaceTextCursor
	call Profile_LoadAndDraw
	call Function_00_0464
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000F
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

Profile_PlaceTextCursor:: ; 2A:590B
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $2C

Label_2A_5918:: ; 2A:5918
	dec b
	jr z, Label_2A_591F

; ---- code $591B-$591F (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2A:5919 (executed)
	add a, $0C
	jr Label_2A_5918

; ---- code $591F-$59B3 (148 bytes) [CONFIRMED] 78 insn(s); 78 executed (in up to 2/18 scenarios)

Label_2A_591F:: ; 2A:591F
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $38

Label_2A_592E:: ; 2A:592E
	dec c
	jr z, Label_2A_5935
	add a, $0C
	jr Label_2A_592E

Label_2A_5935:: ; 2A:5935
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	push af
	ld a, [wSplitScrollY]
	cp a, $00
	jr z, Label_2A_5948
	ld a, $D0
	ld [wSpriteSlots + 33], a

Label_2A_5948:: ; 2A:5948
	pop af
	pop bc
	ret

Profile_RedrawNickname:: ; 2A:594B
	ld a, $01
	call Profile_DrawNickname
	xor a, a
	ret

Profile_DrawNickname:: ; 2A:5952
	ld a, $10
	ld [wTextCellsLeft], a

Label_2A_5957:: ; 2A:5957
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_59F4
	cp a, $0D
	jr z, Label_2A_59D9
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_59B3
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
	call Profile_DrawNickname_BlitGlyphAdvance
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
	jr z, Label_2A_59F4
	cp a, $01
	jr z, Label_2A_59F4
	jp Label_2A_5957

; ---- code $59B3-$59F4 (65 bytes) [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1; entered by jrcc from 2A:596F (executed)

Label_2A_59B3:: ; 2A:59B3
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
	call Profile_DrawNickname_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_59F4
	cp a, $01
	jr z, Label_2A_59F4
	jp Label_2A_5957

Label_2A_59D9:: ; 2A:59D9
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
	call Profile_DrawNickname_BlitBlankAdvance

; ---- code $59F4-$5A5A (102 bytes) [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)

Label_2A_59F4:: ; 2A:59F4
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2A_5A00:: ; 2A:5A00
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawNickname_BlitBlankAdvance
	jr Label_2A_5A00

Profile_DrawNickname_BlitGlyphAdvance:: ; 2A:5A0F
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

Profile_DrawNickname_BlitBlankAdvance:: ; 2A:5A23
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

Profile_DrawAddressLine1:: ; 2A:5A3B
	ld a, $0A
	ld [wTextCellsLeft], a

Label_2A_5A40:: ; 2A:5A40
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_5ADB
	cp a, $0D
	jr z, Label_2A_5AC0
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_5A9B

; ---- code $5A5A-$5A9B (65 bytes) [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0; fall-through of the jrcc at 2A:5A58 (executed)
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
	call Profile_DrawAddressLine1_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl

Label_2A_5A83:: ; 2A:5A83
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
	jr z, Label_2A_5ADB
	cp a, $01
	jr z, Label_2A_5ADB
	jr Label_2A_5A40

; ---- code $5A9B-$5AC0 (37 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)

Label_2A_5A9B:: ; 2A:5A9B
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
	call Profile_DrawAddressLine1_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5ADB
	cp a, $01
	jr z, Label_2A_5ADB
	jr Label_2A_5A40

; ---- code $5AC0-$5ADB (27 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 2A:5A4E (executed)

Label_2A_5AC0:: ; 2A:5AC0
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine1_BlitBlankAdvance

; ---- code $5ADB-$5B46 (107 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 2/18 scenarios)

Label_2A_5ADB:: ; 2A:5ADB
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2A_5AEC:: ; 2A:5AEC
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine1_BlitBlankAdvance
	jr Label_2A_5AEC

Profile_DrawAddressLine1_BlitGlyphAdvance:: ; 2A:5AFB
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

Profile_DrawAddressLine1_BlitBlankAdvance:: ; 2A:5B0F
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_DrawAddressLine2:: ; 2A:5B27
	ld a, $10
	ld [wTextCellsLeft], a

Label_2A_5B2C:: ; 2A:5B2C
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2A_5BC7
	cp a, $0D
	jr z, Label_2A_5BAC
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2A_5B87

; ---- code $5B46-$5B87 (65 bytes) [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0; fall-through of the jrcc at 2A:5B44 (executed)
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
	call Profile_DrawAddressLine2_BlitGlyphAdvance
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
	jr z, Label_2A_5BC7

Label_2A_5B81:: ; 2A:5B81
	cp a, $01
	jr z, Label_2A_5BC7
	jr Label_2A_5B2C

; ---- code $5B87-$5BAC (37 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)

Label_2A_5B87:: ; 2A:5B87
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
	call Profile_DrawAddressLine2_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2A_5BC7
	cp a, $01
	jr z, Label_2A_5BC7
	jr Label_2A_5B2C

; ---- code $5BAC-$5BC7 (27 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 2A:5B3A (executed)

Label_2A_5BAC:: ; 2A:5BAC
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine2_BlitBlankAdvance

; ---- code $5BC7-$5C7D (182 bytes) [CONFIRMED] 102 insn(s); 102 executed (in up to 2/18 scenarios)

Label_2A_5BC7:: ; 2A:5BC7
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2A_5BD8:: ; 2A:5BD8
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Profile_DrawAddressLine2_BlitBlankAdvance
	jr Label_2A_5BD8

Profile_DrawAddressLine2_BlitGlyphAdvance:: ; 2A:5BE7
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

Profile_DrawAddressLine2_BlitBlankAdvance:: ; 2A:5BFB
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Profile_UploadTextTiles:: ; 2A:5C13
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2A_5C3B
	ld hl, $D400
	ld de, $9400
	ld c, $37
	call Gfx_StartHDMAAtVBlank_2A_5C3B
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2A_5C3B:: ; 2A:5C3B
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2A_5C4A:: ; 2A:5C4A
	ld a, [de]
	cp a, $8F
	jr nz, Label_2A_5C4A
	ld b, $91

Label_2A_5C51:: ; 2A:5C51
	ld a, [de]
	cp a, b
	jr nz, Label_2A_5C51
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

Profile_CharPtr:: ; 2A:5C5B
	push bc
	call Profile_FindLine
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, Label_2A_5C83
	inc c
	ld a, [hl]

Label_2A_5C6C:: ; 2A:5C6C
	dec c
	jr z, Label_2A_5C81
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, Label_2A_5C83
	ld a, [hl]
	cp a, $0D
	jr z, Label_2A_5C89
	jr Label_2A_5C6C

; ---- code $5C7D-$5C81 (4 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $5C7D-$5C81 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: inc c; dec c; jr nz,$5C83 - skipped by the unconditional 'jr $5C6C' at 2A:5C7B... falls into 5C81 (pop bc; ret)
	inc c
	dec c
	jr nz, Label_2A_5C83

; ---- code $5C81-$5C89 (8 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_2A_5C81:: ; 2A:5C81
	pop bc
	ret

Label_2A_5C83:: ; 2A:5C83
	ld a, $FF
	ld d, $FF
	pop bc
	ret

; ---- code $5C89-$5C8F (6 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 2A:5C79 (executed)

Label_2A_5C89:: ; 2A:5C89
	ld a, $0D
	ld d, $FF
	pop bc
	ret

; ---- code $5C8F-$5CB1 (34 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Profile_FindLine:: ; 2A:5C8F
Function_2A_5C8F::
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	inc b

Label_2A_5C9A:: ; 2A:5C9A
	ld d, $00
	ld e, $0C
	dec b
	jr z, Label_2A_5CB3

Label_2A_5CA1:: ; 2A:5CA1
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2A_5CB3
	inc hl
	inc hl
	cp a, $0D
	jr z, Label_2A_5C9A
	dec e
	jr nz, Label_2A_5CA1

; ---- code $5CB1-$5CB3 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2A:5CAF (executed)
	jr Label_2A_5C9A

; ---- code $5CB3-$5CE0 (45 bytes) [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)

Label_2A_5CB3:: ; 2A:5CB3
	ld a, $FF
	cp a, d
	jr z, Label_2A_5CCC
	ld e, $00
	push hl

Label_2A_5CBB:: ; 2A:5CBB
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, Label_2A_5CCB
	cp a, $0D
	jr z, Label_2A_5CCB
	inc e
	ld a, $0B
	cp a, e
	jr nz, Label_2A_5CBB

Label_2A_5CCB:: ; 2A:5CCB
	pop hl

Label_2A_5CCC:: ; 2A:5CCC
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

Profile_InsertChar:: ; 2A:5CD2
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D522
	ld a, [hl]
	cp a, $00
	jr z, Label_2A_5CF5

; ---- code $5CE0-$5CF5 (21 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 2A:5CDE (executed) [executed in 5 scenarios]
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

; ---- code $5CF5-$5D6D (120 bytes) [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)

Label_2A_5CF5:: ; 2A:5CF5
	push de
	push bc
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
	push bc
	ld hl, $DA10
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call Profile_PlaceTextCursor
	ld d, $14

Label_2A_5D22:: ; 2A:5D22
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, Label_2A_5D3E
	dec d
	jr nz, Label_2A_5D22

Label_2A_5D3E:: ; 2A:5D3E
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	call Profile_PlaceTextCursor
	farcall Function_00_0956
	pop bc
	pop de
	push de
	push bc
	ld b, $07
	ld c, $00
	call Profile_FindLine
	inc d
	jr z, Label_2A_5DAD

; ---- code $5D6D-$5D7E (17 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 2A:5D6B (executed)
	pop bc
	push bc
	ld c, $0B

Label_2A_5D71:: ; 2A:5D71
	call Profile_CharPtr
	inc d
	jr nz, Label_2A_5D8B
	ld a, e
	cp a, $0B
	jr z, Label_2A_5D96
	jr Label_2A_5DAD

; ---- code $5D7E-$5D8B (13 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $5D7E-$5D8B was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: ld a,1; ldh [$8D],a; ldh [$70],a; ld a,[hl]; cp $0D; cp 0; jr z,$5DAD - skipped by the unconditional 'jr $5DAD' at 2A:5D7C, falls into 5D8B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $0D
	cp a, $00
	jr z, Label_2A_5DAD

; ---- code $5D8B-$5DAD (34 bytes) [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1; entered by jrcc from 2A:5D75 (PROBABLE code)

Label_2A_5D8B:: ; 2A:5D8B
	ld a, $08
	cp a, b
	jr z, Label_2A_5D96
	inc b
	ld a, $08
	cp a, b
	jr nz, Label_2A_5D71

Label_2A_5D96:: ; 2A:5D96
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

; ---- code $5DAD-$5DF8 (75 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)

Label_2A_5DAD:: ; 2A:5DAD
	pop bc
	pop de
	push de
	call Profile_CharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D522
	ld bc, $D520

Label_2A_5DC3:: ; 2A:5DC3
	ld a, d
	cp a, h
	jr nz, Label_2A_5DCB
	ld a, e
	cp a, l
	jr z, Label_2A_5DD7

Label_2A_5DCB:: ; 2A:5DCB
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
	jr Label_2A_5DC3

Label_2A_5DD7:: ; 2A:5DD7
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
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ld a, b
	cp a, $07
	jr nz, Label_2A_5DFD

; ---- code $5DF8-$5DFD (5 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 2A:5DF6 (executed)
	ld a, c
	cp a, $0B
	jr z, Label_2A_5E22

; ---- code $5DFD-$5E08 (11 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)

Label_2A_5DFD:: ; 2A:5DFD
	call Profile_CharPtr
	cp a, $FF
	jr z, Label_2A_5E22
	cp a, $0D
	jr nz, Label_2A_5E11

; ---- code $5E08-$5E11 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2A:5E06 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr Label_2A_5E22

; ---- code $5E11-$5E1B (10 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_2A_5E11:: ; 2A:5E11
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, Label_2A_5E22

; ---- code $5E1B-$5E22 (7 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2A:5E19 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

; ---- code $5E22-$5E58 (54 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)

Label_2A_5E22:: ; 2A:5E22
	ret

Profile_DeleteChar:: ; 2A:5E23
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
	call Profile_CharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, Label_2A_5E60

; ---- code $5E58-$5E5D (5 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2A:5E56 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 5E58-5E60 by apply_coverage --split [executed in 4 scenarios]
	ld a, b
	cp a, $00
	jr z, Label_2A_5E61

; ---- code $5E5D-$5E60 (3 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5E58-5E60 by apply_coverage --split
	dec b
	ld c, e
	inc c

; ---- code $5E60-$5E9E (62 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)

Label_2A_5E60:: ; 2A:5E60
	dec c

Label_2A_5E61:: ; 2A:5E61
	call Profile_PlaceTextCursor
	pop bc
	ld d, $14

Label_2A_5E67:: ; 2A:5E67
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, Label_2A_5E83
	dec d
	jr nz, Label_2A_5E67

Label_2A_5E83:: ; 2A:5E83
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	inc c
	dec c
	jr nz, Label_2A_5EA9

; ---- code $5E9E-$5EA2 (4 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 2A:5E9C (executed) | 3 insn(s) executed; cut out of the PROBABLE region 5E9E-5EA9 by apply_coverage --split [executed in 4 scenarios]
	inc b
	dec b
	jr z, Label_2A_5EAE

; ---- code $5EA2-$5EA9 (7 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5E9E-5EA9 by apply_coverage --split
	dec b
	call Profile_CharPtr
	ld c, e
	jr Label_2A_5EAE

; ---- code $5EA9-$5EC6 (29 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)

Label_2A_5EA9:: ; 2A:5EA9
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a

Label_2A_5EAE:: ; 2A:5EAE
	call Profile_CharPtr
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
	jr nz, Label_2A_5EC8

; ---- code $5EC6-$5EC8 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2A:5EC4 (executed)
	ld e, $01

; ---- code $5EC8-$5EF4 (44 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)

Label_2A_5EC8:: ; 2A:5EC8
	ld a, $22
	cp a, l
	jr nz, Label_2A_5ED2
	ld a, $D5
	cp a, h
	jr z, Label_2A_5EDA

Label_2A_5ED2:: ; 2A:5ED2
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr Label_2A_5EC8

Label_2A_5EDA:: ; 2A:5EDA
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
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

; ---- code $5EF4-$5F42 (78 bytes) [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1; entered by call from 2A:61EA (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE region 5EF4-5F69 by apply_coverage --split [executed in 1 scenarios]

Profile_ApplyDakuten:: ; 2A:5EF4
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2A_5F02
	ld a, $D5
	cp a, h
	jp z, Label_2A_5F7D

Label_2A_5F02:: ; 2A:5F02
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Profile_DakutenKana

Label_2A_5F0E:: ; 2A:5F0E
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2A_5F71
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2A_5F66
	ld a, [hl]
	cp a, c
	jr nz, Label_2A_5F66
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
	jr nz, Label_2A_5F54

; ---- code $5F42-$5F54 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5EF4-5F69 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

; ---- code $5F54-$5F69 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5EF4-5F69 by apply_coverage --split [executed in 1 scenarios]

Label_2A_5F54:: ; 2A:5F54
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

Label_2A_5F66:: ; 2A:5F66
	pop hl
	jr Label_2A_5F0E

; ---- code $5F69-$5F71 (8 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $5F69-$5F71 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $5F0E' at 2A:5F67
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $5F71-$5F82 (17 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2; entered by jrcc from 2A:5F12 (PROBABLE code) [executed in 1 scenarios]

Label_2A_5F71:: ; 2A:5F71
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

Label_2A_5F7D:: ; 2A:5F7D
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $5F82-$5FD3 (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Profile_DakutenKana:: ; 2A:5F82
String_2A_5F82::
	db $82, $A9, $82, $AB, $82, $AD, $82, $AF, $82, $B1, $82, $B3, $82, $B5, $82, $B7, $82, $B9, $82, $BB, $82, $BD, $82, $BF, $82, $C2, $82, $C4, $82, $C6, $82, $CD, $82, $D0 ; "かきくけこさしすせそたちつてとはひ"
	db $82, $D3, $82, $D6, $82, $D9, $83, $4A, $83, $4C, $83, $4E, $83, $50, $83, $52, $83, $54, $83, $56, $83, $58, $83, $5A, $83, $5C, $83, $5E, $83, $60, $83, $63, $83, $65 ; "ふへほカキクケコサシスセソタチツテ"
	db $83, $67, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "トハヒフヘホ"

; ---- code $5FD3-$5FD4 (1 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $5FD3-$5FD4 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9) directly after a NUL-terminated string that follows the function ending before it
	ret

; ---- code $5FD4-$6021 (77 bytes) [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 1; entered by call from 2A:61F4 (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE region 5FD4-6048 by apply_coverage --split [executed in 1 scenarios]

Profile_ApplyVu:: ; 2A:5FD4
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2A_5FE2
	ld a, $D5
	cp a, h
	jp z, Label_2A_606C

Label_2A_5FE2:: ; 2A:5FE2
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_2A_6081

Label_2A_5FEE:: ; 2A:5FEE
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2A_6050
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, Label_2A_6045
	ld a, [hl]
	cp a, $45
	jr nz, Label_2A_6045
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
	jr nz, Label_2A_6033

; ---- code $6021-$6033 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5FD4-6048 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

; ---- code $6033-$6048 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5FD4-6048 by apply_coverage --split [executed in 1 scenarios]

Label_2A_6033:: ; 2A:6033
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

Label_2A_6045:: ; 2A:6045
	pop hl
	jr Label_2A_5FEE

; ---- code $6048-$6050 (8 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $6048-$6050 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $5FEE'
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $6050-$6081 (49 bytes) [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2; entered by jrcc from 2A:5FF2 (PROBABLE code) [executed in 1 scenarios]

Label_2A_6050:: ; 2A:6050
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

Label_2A_606C:: ; 2A:606C
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

; ---- text $6081-$6086 (5 bytes) [PROBABLE] Shift-JIS NUL-terminated string (2 x 82 A4 = full-width 'う' x2); address loaded by 'ld de,$6081' at 2A:5FEA

String_2A_6081:: ; 2A:6081
	db $82, $A4, $82, $A4, $00 ; "うう"

; ---- code $6086-$6087 (1 bytes) [HYPOTHESIS] lone 'ret' (c9) after the string at 6081, before the PROBABLE code at 6087; nothing branches to it
	ret

; ---- code $6087-$60D2 (75 bytes) [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 1; entered by call from 2A:6208 (PROBABLE code) | 49 insn(s) executed; cut out of the PROBABLE region 6087-60F9 by apply_coverage --split [executed in 1 scenarios]

Profile_ApplyHandakuten:: ; 2A:6087
	call Profile_CharPtr
	ld a, $14
	cp a, l
	jr nz, Label_2A_6095
	ld a, $D5
	cp a, h
	jp z, Label_2A_611D

Label_2A_6095:: ; 2A:6095
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_Profile_HandakutenKana

Label_2A_60A1:: ; 2A:60A1
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2A_6101
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2A_60F6
	ld a, [hl]
	cp a, c
	jr nz, Label_2A_60F6
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
	jr nz, Label_2A_60E4

; ---- code $60D2-$60E4 (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6087-60F9 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

; ---- code $60E4-$60F9 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 6087-60F9 by apply_coverage --split [executed in 1 scenarios]

Label_2A_60E4:: ; 2A:60E4
	push bc
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	call Profile_UploadTextTiles
	pop bc
	ret

Label_2A_60F6:: ; 2A:60F6
	pop hl
	jr Label_2A_60A1

; ---- code $60F9-$6101 (8 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $60F9-$6101 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: xor a; ldh [$F5],a; ld [$0000],a; pop bc; ret (SRAM-disable epilogue) - after the unconditional 'jr $60A1'
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $6101-$6132 (49 bytes) [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2; entered by jrcc from 2A:60A5 (PROBABLE code) [executed in 1 scenarios]

Label_2A_6101:: ; 2A:6101
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

Label_2A_611D:: ; 2A:611D
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

; ---- text $6132-$6147 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Profile_HandakutenKana:: ; 2A:6132
String_2A_6132::
	db $82, $CD, $82, $D0, $82, $D3, $82, $D6, $82, $D9, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "はひふへほハヒフヘホ"

; ---- code $6147-$6148 (1 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $6147-$6148 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9) directly after a NUL-terminated string
	ret

; ---- code $6148-$61E3 (155 bytes) [CONFIRMED] 78 insn(s); 78 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Profile_KeyboardLoop:: ; 2A:6148
Function_2A_6148::
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
	ld a, $07
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

Profile_KeyboardLoop_Poll:: ; 2A:617B
	push bc
	call Profile_PlaceTextCursor
	ld d, $70
	farcall Function_00_0956
	ld a, [wMailScreenMode]
	ld c, a
	ld b, $01
	farcall Kbd_Run
	pop bc
	cp a, $08
	jr z, Label_2A_619C
	cp a, $07
	jr nz, Label_2A_61CA

Label_2A_619C:: ; 2A:619C
	push af
	push bc
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D514
	ld a, [de]
	cp a, $00
	jr z, Label_2A_61C0
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	call Profile_SaveToSram

Label_2A_61C0:: ; 2A:61C0
	farcall Kbd_Hide
	pop de
	pop bc
	pop af
	ret

Label_2A_61CA:: ; 2A:61CA
	cp a, $00
	jr z, Profile_KeyboardLoop_Poll
	cp a, $09
	ret z
	cp a, $02
	jr z, Label_2A_621C
	cp a, $07
	ret z
	cp a, $08
	jr z, Label_2A_6223
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Label_2A_61FA

; ---- code $61E3-$61FA (23 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 2A:61E1 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2A_61FA
	call Profile_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Profile_KeyboardLoop_Poll
	call Profile_ApplyVu
	jp Profile_KeyboardLoop_Poll

; ---- code $61FA-$6201 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2A_61FA:: ; 2A:61FA
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, Label_2A_620E

; ---- code $6201-$620E (13 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2A:61FF (executed) [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2A_620E
	call Profile_ApplyHandakuten
	jp Profile_KeyboardLoop_Poll

; ---- code $620E-$6222 (20 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_2A_620E:: ; 2A:620E
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call Profile_InsertChar
	jp Profile_KeyboardLoop_Poll

Label_2A_621C:: ; 2A:621C
	call Profile_DeleteChar
	jp Profile_KeyboardLoop_Poll

; ---- code $6222-$6223 (1 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $6222-$6223 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: lone 'ret' (c9) after the unconditional 'jp $617B' at 2A:621F
	ret

; ---- code $6223-$6253 (48 bytes) [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1; entered by jrcc from 2A:61DA (executed)

Label_2A_6223:: ; 2A:6223
	push af
	push bc
	farcall Kbd_HideInstant
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld hl, $DA30
	ld de, $6E70
	ld a, $2A
	ld b, $81
	farcall Function_00_0A82
	ld de, $2000
	ld hl, $DA30
	call Function_00_0A65
	pop bc
	call Profile_PlaceTextCursor
	pop af
	ret

; ---- code $6253-$6257 (4 bytes) [HYPOTHESIS] no branch/call/pointer to any address in $6253-$6257 was found (tgt scan of all code regions of bank 2A + ROM word scan), so it is unreachable or entered only from unseen code; linear decode is legal and continues exactly into the next region: jp $617B ; ret - after the ret at 2A:6252
	jp Profile_KeyboardLoop_Poll

	ret

; ---- code $6257-$62FE (167 bytes) [CONFIRMED] 81 insn(s); 81 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Profile_LoadAndDraw:: ; 2A:6257
Function_2A_6257::
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld hl, $AF40
	ld de, $D514

Label_2A_6274:: ; 2A:6274
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2A_6274
	ld b, $40
	ld hl, $AF50
	ld de, $D4C0

Label_2A_6282:: ; 2A:6282
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2A_6282
	pop bc
	push bc
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $0000
	ld hl, $D514
	call Profile_RedrawNickname
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1000
	ld hl, $D4C0
	call Profile_DrawAddressLine1
	ld a, $14
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0300
	ld de, $1C00
	ld hl, $D4C9
	call Profile_DrawAddressLine2
	call Profile_UploadTextTiles
	pop bc
	ret

Profile_SaveToSram:: ; 2A:62C5
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $AF40
	ld hl, $D514

Label_2A_62E2:: ; 2A:62E2
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2A_62E2
	ld b, $40
	ld de, $AF50
	ld hl, $D4C0

Label_2A_62F0:: ; 2A:62F0
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2A_62F0
	pop bc
	farcall SramCheck_Bank0Commit
	ret

; ---- zero $62FE-$6300 (2 bytes) [PROBABLE] 2 bytes of $00 alignment padding between the last ret and the data block at $6300
	ds $2, $00
