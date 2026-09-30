; engine/mail/mail_title_entry.asm
; bank 2C, $4000-$4A30 (2608 bytes); pinned by layout.link
; mail title (subject) entry with the kana keyboard

SECTION "engine/mail/mail_title_entry", ROMX

; ---- code $4000-$4040 (64 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailTitle_Entry:: ; 2C:4000
Function_2C_4000::
	push af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	push af
	call MailTitle_InitScreen
	ld d, $0A

Label_2C_4028:: ; 2C:4028
	push de
	call MailTitle_MoveCursorRight
	pop de
	dec d
	jr nz, Label_2C_4028
	pop af
	cp a, $01
	jr nz, Label_2C_403B
	call MailTitle_KeyboardLoop
	jp Label_2C_405F

Label_2C_403B:: ; 2C:403B
	ld a, c
	cp a, $0B
	jr nz, MailTitle_Entry_Loop

; ---- code $4040-$4042 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2C:403E (executed)
	ld c, $0A

; ---- code $4042-$4082 (64 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)

MailTitle_Entry_Loop:: ; 2C:4042
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call MailTitle_PlaceTextCursor
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_2C_407C
	call MailTitle_OpenKeyboard

Label_2C_405F:: ; 2C:405F
	cp a, $07
	jr nz, Label_2C_407C
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ret

Label_2C_407C:: ; 2C:407C
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2C_40C1

; ---- code $4082-$40C1 (63 bytes) [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0; fall-through of the jrcc at 2C:4080 (executed) [executed in 1 scenarios]
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
	call Function_00_044B
	ld a, $FF
	ret

; ---- code $40C1-$40D4 (19 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_2C_40C1:: ; 2C:40C1
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, MailTitle_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, MailTitle_CursorRight
	ld d, $10
	jp Label_2C_403B

; ---- code $40D4-$40EF (27 bytes) [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1; entered by callcc from 2C:40C5 (executed) | 18 insn(s) executed; cut out of the PROBABLE region 40D4-410F by apply_coverage --split [executed in 3 scenarios]

MailTitle_CursorLeft:: ; 2C:40D4
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
	jr nz, Label_2C_40F5
	inc b
	dec b
	ret z

; ---- code $40EF-$40F5 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 40D4-410F by apply_coverage --split
	dec b
	call MailTitle_CharPtr
	ld c, e
	ret

; ---- code $40F5-$410F (26 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 40D4-410F by apply_coverage --split [executed in 3 scenarios]

Label_2C_40F5:: ; 2C:40F5
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailTitle_CursorRight:: ; 2C:40FB
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

; ---- code $410F-$4114 (5 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailTitle_MoveCursorRight:: ; 2C:410F
Function_2C_410F::
	ld a, b
	cp a, $07
	jr nz, Label_2C_4118

; ---- code $4114-$4118 (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; fall-through of the jrcc at 2C:4112 (executed)
	ld a, c
	cp a, $0B
	ret z

; ---- code $4118-$4133 (27 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Label_2C_4118:: ; 2C:4118
	inc c
	dec c
	jr nz, Label_2C_4129
	call MailTitle_CharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

Label_2C_4129:: ; 2C:4129
	call MailTitle_CharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, Label_2C_413B

; ---- code $4133-$413B (8 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1; fall-through of the jrcc at 2C:4131 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $413B-$4144 (9 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_2C_413B:: ; 2C:413B
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	ret nz

; ---- code $4144-$414C (8 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the retcc at 2C:4143 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $414C-$42FB (431 bytes) [CONFIRMED] 171 insn(s); 171 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailTitle_InitScreen:: ; 2C:414C
Function_2C_414C::
	push af
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailTitle_Tiles9300
	ld a, $2C
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $8800
	ld hl, $5410
	ld a, $2C
	ld b, $95
	ld c, $26
	farcall Function_00_0749
	ld de, $8000
	ld hl, $5140
	ld a, $2C
	ld b, $94
	ld c, $2D
	farcall Function_00_0749
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_MailTitle_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailTitle_Bg
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_MailTitle_TilemapAttr
	ld a, $2C
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
	ld de, $14D0
	ld hl, $DA30
	call Function_00_0A65
	ld a, $D0
	ld [wSpriteSlots + 48], a
	xor a, a
	ld [wSpriteSlots + 49], a
	ldh a, [rLCDC]
	call Function_00_082C
	pop af
	push af
	dec a
	jr nz, Label_2C_4258
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
	ld a, $24
	ld [wSplitScrollY], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

Label_2C_4258:: ; 2C:4258
	ld bc, $0000
	call MailTitle_PlaceTextCursor
	farcall LCDOn
	ld bc, $0000
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop af
	dec a
	jr nz, Label_2C_42B4
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
	jr Label_2C_42E3

Label_2C_42B4:: ; 2C:42B4
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit

Label_2C_42E3:: ; 2C:42E3
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

MailTitle_PlaceTextCursor:: ; 2C:42EB
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $38

Label_2C_42F8:: ; 2C:42F8
	dec b
	jr z, Label_2C_42FF

; ---- code $42FB-$42FF (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2C:42F9 (executed)
	add a, $0C
	jr Label_2C_42F8

; ---- code $42FF-$437D (126 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 2/18 scenarios)

Label_2C_42FF:: ; 2C:42FF
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $20

Label_2C_430E:: ; 2C:430E
	dec c
	jr z, Label_2C_4315
	add a, $0C
	jr Label_2C_430E

Label_2C_4315:: ; 2C:4315
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

MailTitle_DrawTextLine:: ; 2C:431D
	ld a, $14
	ld [wTextCellsLeft], a

Label_2C_4322:: ; 2C:4322
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2C_43BD
	cp a, $0D
	jr z, Label_2C_43A2
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2C_437D
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
	call MailTitle_DrawTextLine_BlitGlyphAdvance
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
	jr z, Label_2C_43BD
	cp a, $01
	jr z, Label_2C_43BD
	jr Label_2C_4322

; ---- code $437D-$43BD (64 bytes) [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1; entered by jrcc from 2C:433A (executed)

Label_2C_437D:: ; 2C:437D
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
	call MailTitle_DrawTextLine_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2C_43BD
	cp a, $01
	jr z, Label_2C_43BD
	jr Label_2C_4322

Label_2C_43A2:: ; 2C:43A2
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
	call MailTitle_DrawTextLine_BlitBlankAdvance

; ---- code $43BD-$4463 (166 bytes) [CONFIRMED] 96 insn(s); 96 executed (in up to 2/18 scenarios)

Label_2C_43BD:: ; 2C:43BD
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2C_43C9:: ; 2C:43C9
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailTitle_DrawTextLine_BlitBlankAdvance
	jr Label_2C_43C9

MailTitle_DrawTextLine_BlitGlyphAdvance:: ; 2C:43D8
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

MailTitle_DrawTextLine_BlitBlankAdvance:: ; 2C:43EC
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

MailTitle_UploadTextTiles:: ; 2C:4404
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
	call Gfx_StartHDMAAtVBlank_2C_4421
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2C_4421:: ; 2C:4421
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2C_4430:: ; 2C:4430
	ld a, [de]
	cp a, $8F
	jr nz, Label_2C_4430
	ld b, $91

Label_2C_4437:: ; 2C:4437
	ld a, [de]
	cp a, b
	jr nz, Label_2C_4437
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

MailTitle_CharPtr:: ; 2C:4441
	push bc
	call MailTitle_FindLine
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, Label_2C_4469
	inc c
	ld a, [hl]

Label_2C_4452:: ; 2C:4452
	dec c
	jr z, Label_2C_4467
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, Label_2C_4469
	ld a, [hl]
	cp a, $0D
	jr z, Label_2C_446F
	jr Label_2C_4452

; ---- data $4463-$4467 (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_4463:: ; 2C:4463
	db $0C, $0D, $20, $02

; ---- code $4467-$446F (8 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_2C_4467:: ; 2C:4467
	pop bc
	ret

Label_2C_4469:: ; 2C:4469
	ld a, $FF
	ld d, $FF
	pop bc
	ret

; ---- code $446F-$4475 (6 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 2C:445F (executed)

Label_2C_446F:: ; 2C:446F
	ld a, $0D
	ld d, $FF
	pop bc
	ret

; ---- code $4475-$4497 (34 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailTitle_FindLine:: ; 2C:4475
Function_2C_4475::
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	inc b

Label_2C_4480:: ; 2C:4480
	ld d, $00
	ld e, $0C
	dec b
	jr z, Label_2C_4499

Label_2C_4487:: ; 2C:4487
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2C_4499
	inc hl
	inc hl
	cp a, $0D
	jr z, Label_2C_4480
	dec e
	jr nz, Label_2C_4487

; ---- code $4497-$4499 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2C:4495 (executed) [executed in 1 scenarios]
	jr Label_2C_4480

; ---- code $4499-$44C6 (45 bytes) [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)

Label_2C_4499:: ; 2C:4499
	ld a, $FF
	cp a, d
	jr z, Label_2C_44B2
	ld e, $00
	push hl

Label_2C_44A1:: ; 2C:44A1
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, Label_2C_44B1
	cp a, $0D
	jr z, Label_2C_44B1
	inc e
	ld a, $0B
	cp a, e
	jr nz, Label_2C_44A1

Label_2C_44B1:: ; 2C:44B1
	pop hl

Label_2C_44B2:: ; 2C:44B2
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

MailTitle_InsertChar:: ; 2C:44B8
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D512
	ld a, [hl]
	cp a, $00
	jr z, Label_2C_44DC

; ---- code $44C6-$44DB (21 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 2C:44C4 (executed) [executed in 3 scenarios]
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

; ---- data $44DB-$44DC (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_44DB:: ; 2C:44DB
	db $C0

; ---- code $44DC-$455C (128 bytes) [CONFIRMED] 58 insn(s); 58 executed (in up to 2/18 scenarios)

Label_2C_44DC:: ; 2C:44DC
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
	call MailTitle_PlaceTextCursor
	ld d, $14

Label_2C_4509:: ; 2C:4509
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	cp a, $00
	jr nz, Label_2C_452D
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2C_452D
	dec d
	jr nz, Label_2C_4509

Label_2C_452D:: ; 2C:452D
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	call MailTitle_PlaceTextCursor
	farcall Function_00_0956
	pop bc
	pop de
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailTitle_FindLine
	inc d
	jr z, Label_2C_459C

; ---- code $455C-$456D (17 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 2C:455A (executed)
	pop bc
	push bc
	ld c, $0B

Label_2C_4560:: ; 2C:4560
	call MailTitle_CharPtr
	inc d
	jr nz, Label_2C_457A
	ld a, e
	cp a, $0B
	jr z, Label_2C_4585
	jr Label_2C_459C

; ---- data $456D-$457A (13 bytes) [HYPOTHESIS] UNCLASSIFIED 13 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_456D:: ; 2C:456D
	db $3E, $01, $E0, $8D, $E0, $70, $7E, $FE, $0D, $FE, $00, $28, $22

; ---- code $457A-$459C (34 bytes) [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1; entered by jrcc from 2C:4564 (PROBABLE code)

Label_2C_457A:: ; 2C:457A
	ld a, $08
	cp a, b
	jr z, Label_2C_4585
	inc b
	ld a, $08
	cp a, b
	jr nz, Label_2C_4560

Label_2C_4585:: ; 2C:4585
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

; ---- code $459C-$45E7 (75 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)

Label_2C_459C:: ; 2C:459C
	pop bc
	pop de
	push de
	call MailTitle_CharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D512
	ld bc, $D510

Label_2C_45B2:: ; 2C:45B2
	ld a, d
	cp a, h
	jr nz, Label_2C_45BA
	ld a, e
	cp a, l
	jr z, Label_2C_45C6

Label_2C_45BA:: ; 2C:45BA
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
	jr Label_2C_45B2

Label_2C_45C6:: ; 2C:45C6
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
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ld a, b
	cp a, $07
	jr nz, Label_2C_45EC

; ---- code $45E7-$45EC (5 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 2C:45E5 (executed)
	ld a, c
	cp a, $0B
	jr z, Label_2C_4611

; ---- code $45EC-$45F7 (11 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)

Label_2C_45EC:: ; 2C:45EC
	call MailTitle_CharPtr
	cp a, $FF
	jr z, Label_2C_4611
	cp a, $0D
	jr nz, Label_2C_4600

; ---- code $45F7-$4600 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:45F5 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr Label_2C_4611

; ---- code $4600-$460A (10 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_2C_4600:: ; 2C:4600
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, Label_2C_4611

; ---- code $460A-$4611 (7 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2C:4608 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

; ---- code $4611-$4647 (54 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 2/18 scenarios)

Label_2C_4611:: ; 2C:4611
	ret

MailTitle_DeleteChar:: ; 2C:4612
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
	call MailTitle_CharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, Label_2C_464F

; ---- code $4647-$464C (5 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2C:4645 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 4647-464F by apply_coverage --split [executed in 1 scenarios]
	ld a, b
	cp a, $00
	jr z, Label_2C_4650

; ---- code $464C-$464F (3 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4647-464F by apply_coverage --split
	dec b
	ld c, e
	inc c

; ---- code $464F-$4695 (70 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)

Label_2C_464F:: ; 2C:464F
	dec c

Label_2C_4650:: ; 2C:4650
	call MailTitle_PlaceTextCursor
	pop bc
	ld d, $14

Label_2C_4656:: ; 2C:4656
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	cp a, $00
	jr nz, Label_2C_467A
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2C_467A
	dec d
	jr nz, Label_2C_4656

Label_2C_467A:: ; 2C:467A
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	inc c
	dec c
	jr nz, Label_2C_46A0

; ---- code $4695-$4699 (4 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 2C:4693 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 4695-46A0 by apply_coverage --split [executed in 1 scenarios]
	inc b
	dec b
	jr z, Label_2C_46A5

; ---- code $4699-$46A0 (7 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4695-46A0 by apply_coverage --split
	dec b
	call MailTitle_CharPtr
	ld c, e
	jr Label_2C_46A5

; ---- code $46A0-$46BD (29 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)

Label_2C_46A0:: ; 2C:46A0
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a

Label_2C_46A5:: ; 2C:46A5
	call MailTitle_CharPtr
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
	jr nz, Label_2C_46BF

; ---- code $46BD-$46BF (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2C:46BB (executed)
	ld e, $01

; ---- code $46BF-$46EB (44 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)

Label_2C_46BF:: ; 2C:46BF
	ld a, $12
	cp a, l
	jr nz, Label_2C_46C9
	ld a, $D5
	cp a, h
	jr z, Label_2C_46D1

Label_2C_46C9:: ; 2C:46C9
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr Label_2C_46BF

Label_2C_46D1:: ; 2C:46D1
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
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

; ---- code $46EB-$46F3 (8 bytes) [CONFIRMED] 68 insn(s) reached by static flow only; seeds: exec x68; min discovery hops 1; entered by call from 2C:49A9 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE region 46EB-4760 by apply_coverage --split [executed in 1 scenarios]

MailTitle_ApplyDakuten:: ; 2C:46EB
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, Label_2C_46F9

; ---- code $46F3-$46F9 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 46EB-4760 by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, Label_2C_4774

; ---- code $46F9-$4739 (64 bytes) [CONFIRMED] 43 insn(s) executed; cut out of the PROBABLE region 46EB-4760 by apply_coverage --split [executed in 1 scenarios]

Label_2C_46F9:: ; 2C:46F9
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_MailTitle_DakutenKana

Label_2C_4705:: ; 2C:4705
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2C_4768
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2C_475D
	ld a, [hl]
	cp a, c
	jr nz, Label_2C_475D
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
	jr nz, Label_2C_474B

; ---- code $4739-$474B (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 46EB-4760 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

; ---- code $474B-$4760 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 46EB-4760 by apply_coverage --split [executed in 1 scenarios]

Label_2C_474B:: ; 2C:474B
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

Label_2C_475D:: ; 2C:475D
	pop hl
	jr Label_2C_4705

; ---- code $4760-$4768 (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $4768-$4774 (12 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2; entered by jrcc from 2C:4709 (PROBABLE code) | 9 insn(s) executed; cut out of the PROBABLE region 4768-4779 by apply_coverage --split [executed in 1 scenarios]

Label_2C_4768:: ; 2C:4768
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $4774-$4779 (5 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4768-4779 by apply_coverage --split

Label_2C_4774:: ; 2C:4774
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $4779-$47CA (81 bytes) [PROBABLE] NUL-terminated Shift-JIS string of 40 kana (rows that can take dakuten: かきくけこ さしすせそ たちつてと はひふへほ, then the katakana カ..ホ; 81 bytes + NUL at 47C9); ld de,$4779 at 2C:4702; identical bytes at 2F:5F41. Verified by decoding all 40 double-byte characters with cp932. Verifier fix: the former ptrtable Table_2C_47AF (47AF-47BD, "7/7 words hit code starts") was the katakana スセソタチツテト bytes 83 58 83 5A ... read as little-endian words, not pointers

String_MailTitle_DakutenKana:: ; 2C:4779
String_2C_4779::
	db $82, $A9, $82, $AB, $82, $AD, $82, $AF, $82, $B1, $82, $B3, $82, $B5, $82, $B7, $82, $B9, $82, $BB, $82, $BD, $82, $BF, $82, $C2, $82, $C4, $82, $C6, $82, $CD, $82, $D0 ; "かきくけこさしすせそたちつてとはひ"
	db $82, $D3, $82, $D6, $82, $D9, $83, $4A, $83, $4C, $83, $4E, $83, $50, $83, $52, $83, $54, $83, $56, $83, $58, $83, $5A, $83, $5C, $83, $5E, $83, $60, $83, $63, $83, $65 ; "ふへほカキクケコサシスセソタチツテ"
	db $83, $67, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "トハヒフヘホ"

; ---- data $47CA-$47CB (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_47CA:: ; 2C:47CA
	db $C9

; ---- code $47CB-$47D3 (8 bytes) [CONFIRMED] 66 insn(s) reached by static flow only; seeds: exec x66; min discovery hops 1; entered by call from 2C:49B3 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE region 47CB-483F by apply_coverage --split [executed in 1 scenarios]

MailTitle_ApplyVu:: ; 2C:47CB
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, Label_2C_47D9

; ---- code $47D3-$47D9 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47CB-483F by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, Label_2C_4863

; ---- code $47D9-$4818 (63 bytes) [CONFIRMED] 41 insn(s) executed; cut out of the PROBABLE region 47CB-483F by apply_coverage --split [executed in 1 scenarios]

Label_2C_47D9:: ; 2C:47D9
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_2C_4878

Label_2C_47E5:: ; 2C:47E5
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2C_4847
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, Label_2C_483C
	ld a, [hl]
	cp a, $45
	jr nz, Label_2C_483C
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
	jr nz, Label_2C_482A

; ---- code $4818-$482A (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47CB-483F by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

; ---- code $482A-$483C (18 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 47CB-483F by apply_coverage --split [executed in 1 scenarios]

Label_2C_482A:: ; 2C:482A
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

; ---- code $483C-$483F (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47CB-483F by apply_coverage --split

Label_2C_483C:: ; 2C:483C
	pop hl
	jr Label_2C_47E5

; ---- code $483F-$4847 (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $4847-$4878 (49 bytes) [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2; entered by jrcc from 2C:47E9 (PROBABLE code)

Label_2C_4847:: ; 2C:4847
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

Label_2C_4863:: ; 2C:4863
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

; ---- text $4878-$487D (5 bytes) [PROBABLE] NUL-terminated Shift-JIS string (82 A4 82 A4 00); read byte by byte by 2C:47E2 (ld de,$4878; ld a,[de]; inc de; cp $00; jr z); identical bytes at 2F:6040. The following $C9 (ret) stays unresolved in the next region

String_2C_4878:: ; 2C:4878
	db $82, $A4, $82, $A4, $00 ; "うう"

; ---- data $487D-$487E (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 byte $C9 (ret) between a string and code; no entry found

Data_2C_487D:: ; 2C:487D
	db $C9

; ---- code $487E-$4886 (8 bytes) [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 1; entered by call from 2C:49C6 (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE region 487E-48F0 by apply_coverage --split [executed in 1 scenarios]

MailTitle_ApplyHandakuten:: ; 2C:487E
	call MailTitle_CharPtr
	ld a, $00
	cp a, l
	jr nz, Label_2C_488C

; ---- code $4886-$488C (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 487E-48F0 by apply_coverage --split
	ld a, $D5
	cp a, h
	jp z, Label_2C_4914

; ---- code $488C-$48C9 (61 bytes) [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 487E-48F0 by apply_coverage --split [executed in 1 scenarios]

Label_2C_488C:: ; 2C:488C
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, String_MailTitle_HandakutenKana

Label_2C_4898:: ; 2C:4898
	ld a, [de]
	inc de
	cp a, $00
	jr z, Label_2C_48F8
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, Label_2C_48ED
	ld a, [hl]
	cp a, c
	jr nz, Label_2C_48ED
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
	jr nz, Label_2C_48DB

; ---- code $48C9-$48DB (18 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 487E-48F0 by apply_coverage --split
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

; ---- code $48DB-$48F0 (21 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 487E-48F0 by apply_coverage --split [executed in 1 scenarios]

Label_2C_48DB:: ; 2C:48DB
	push bc
	ld bc, $0300
	ld de, $0420
	ld hl, $D500
	call MailTitle_DrawTextLine
	call MailTitle_UploadTextTiles
	pop bc
	ret

Label_2C_48ED:: ; 2C:48ED
	pop hl
	jr Label_2C_4898

; ---- code $48F0-$48F8 (8 bytes) [HYPOTHESIS] 5 insn(s) SRAM-disable epilogue (xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop bc ; ret), identical bytes to 2F:5F28/6007/60B8; follows an unconditional jr; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $48F8-$4929 (49 bytes) [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2; entered by jrcc from 2C:489C (PROBABLE code)

Label_2C_48F8:: ; 2C:48F8
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

Label_2C_4914:: ; 2C:4914
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

; ---- text $4929-$493E (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailTitle_HandakutenKana:: ; 2C:4929
String_2C_4929::
	db $82, $CD, $82, $D0, $82, $D3, $82, $D6, $82, $D9, $83, $6E, $83, $71, $83, $74, $83, $77, $83, $7A, $00 ; "はひふへほハヒフヘホ"

; ---- data $493E-$493F (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_493E:: ; 2C:493E
	db $C9

; ---- code $493F-$49A2 (99 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailTitle_OpenKeyboard:: ; 2C:493F
Function_2C_493F::
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

MailTitle_KeyboardLoop:: ; 2C:4972
	push bc
	call MailTitle_PlaceTextCursor
	ld d, $70
	farcall Function_00_0956
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, MailTitle_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, Label_2C_49D8
	cp a, $07
	ret z
	cp a, $08
	jr z, Label_2C_49E9
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Label_2C_49B8

; ---- code $49A2-$49B8 (22 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 2C:49A0 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2C_49B8
	call MailTitle_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, MailTitle_KeyboardLoop
	call MailTitle_ApplyVu
	jr MailTitle_KeyboardLoop

; ---- code $49B8-$49BF (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2C_49B8:: ; 2C:49B8
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, Label_2C_49CB

; ---- code $49BF-$49CB (12 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2C:49BD (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2C_49CB
	call MailTitle_ApplyHandakuten
	jr MailTitle_KeyboardLoop

; ---- code $49CB-$49DF (20 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)

Label_2C_49CB:: ; 2C:49CB
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call MailTitle_InsertChar
	jr MailTitle_KeyboardLoop

Label_2C_49D8:: ; 2C:49D8
	call MailTitle_GetLength
	cp a, $00
	jr nz, Label_2C_49E3

; ---- code $49DF-$49E3 (4 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 2C:49DD (executed) [executed in 2 scenarios]
	ld a, b
	or a, c
	jr z, Label_2C_49E9

; ---- code $49E3-$49E8 (5 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2C_49E3:: ; 2C:49E3
	call MailTitle_DeleteChar
	jr MailTitle_KeyboardLoop

; ---- data $49E8-$49E9 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_49E8:: ; 2C:49E8
	db $C9

; ---- code $49E9-$4A01 (24 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 2C:4999 (executed) [executed in 2 scenarios]

Label_2C_49E9:: ; 2C:49E9
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall Joypad_Update
	pop bc
	ret

; ---- data $4A01-$4A05 (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2C_4A01:: ; 2C:4A01
	db $C3, $72, $49, $C9

; ---- code $4A05-$4A21 (28 bytes) [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailTitle_GetLength:: ; 2C:4A05
Function_2C_4A05::
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld d, $00

Label_2C_4A12:: ; 2C:4A12
	ld a, [hli]
	cp a, $00
	jr z, Label_2C_4A1D
	inc d
	ld a, $14
	cp a, d
	jr nz, Label_2C_4A12

Label_2C_4A1D:: ; 2C:4A1D
	ld a, d
	pop de
	pop hl
	ret

; ---- zero $4A21-$4A30 (15 bytes) [PROBABLE] all-zero padding before an aligned tile/data block (mapper hint: padding-like)
	ds $F, $00
