; engine/address_book/address_editor.asm
; bank 2F, $6D00-$77D0 (2768 bytes); pinned by layout.link
; address book address editor

SECTION "engine/address_book/address_editor", ROMX

; ---- code $6D00-$6D35 (53 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_Edit:: ; 2F:6D00
Function_2F_6D00::
	push af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0A
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	push af
	call AbookAddr_SetupScreen
	ld d, $40

Label_2F_6D28:: ; 2F:6D28
	push de
	call AbookAddr_CursorRightStep
	pop de
	dec d
	jr nz, Label_2F_6D28
	pop af
	cp a, $01
	jr nz, Label_2F_6D40

; ---- code $6D35-$6D3B (6 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2F:6D33 (executed) [executed in 2 scenarios]
	call AbookAddr_KeyboardLoop
	jp Label_2F_6D5E

; ---- data $6D3B-$6D40 (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_6D3B:: ; 2F:6D3B
	db $F1, $FE, $01, $28, $1B

; ---- code $6D40-$6D63 (35 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_2F_6D40:: ; 2F:6D40
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call AbookAddr_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2F_6DF9
	call AbookAddr_OpenKeyboard

Label_2F_6D5E:: ; 2F:6D5E
	cp a, $07
	jp nz, Label_2F_6DF1

; ---- code $6D63-$6DF1 (142 bytes) [CONFIRMED] 65 insn(s) reached by static flow only; seeds: exec x65; min discovery hops 0; fall-through of the jpcc at 2F:6D60 (executed) [executed in 1 scenarios]
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld a, [hl]
	cp a, $00
	jr nz, Label_2F_6DC9
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 16]
	push af
	ld a, $D0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld de, $0205
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
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	pop bc
	jp Label_2F_6D40

Label_2F_6DC9:: ; 2F:6DC9
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	farcall Function_00_0956
	xor a, a
	ret

; ---- code $6DF1-$6E00 (15 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_2F_6DF1:: ; 2F:6DF1
	push bc
	farcall Joypad_Update
	pop bc

Label_2F_6DF9:: ; 2F:6DF9
	ldh a, [hJoyPressed]
	and a, $02
	jp z, Label_2F_6EF4

; ---- code $6E00-$6E29 (41 bytes) [CONFIRMED] 124 insn(s) reached by static flow only; seeds: exec x124; min discovery hops 0; fall-through of the jpcc at 2F:6DFD (executed) | 22 insn(s) executed; cut out of the PROBABLE region 6E00-6EF4 by apply_coverage --split [executed in 3 scenarios]
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
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]
	cp a, $01
	jr z, Label_2F_6E85
	call AbookAddr_BuffersEmpty
	inc a
	jp z, Label_2F_6EE1

; ---- code $6E29-$6E85 (92 bytes) [PROBABLE] 48 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6E00-6EF4 by apply_coverage --split
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 16]
	push af
	ld a, $D0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld de, $0217
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
	ld e, a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, e
	dec a
	jr z, Label_2F_6EE1
	pop bc
	jp Label_2F_6D40

; ---- code $6E85-$6EF4 (111 bytes) [CONFIRMED] 54 insn(s) executed; cut out of the PROBABLE region 6E00-6EF4 by apply_coverage --split [executed in 1 scenarios]

Label_2F_6E85:: ; 2F:6E85
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 16]
	push af
	ld a, $D0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld de, $0218
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
	ld e, a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, e
	dec a
	jr z, Label_2F_6EE1
	pop bc
	jp Label_2F_6D40

Label_2F_6EE1:: ; 2F:6EE1
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- code $6EF4-$6F07 (19 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

Label_2F_6EF4:: ; 2F:6EF4
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, AbookAddr_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, AbookAddr_CursorRight
	ld d, $10
	jp Label_2F_6D40

; ---- code $6F07-$6F22 (27 bytes) [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1; entered by callcc from 2F:6EF8 (executed) | 18 insn(s) executed; cut out of the PROBABLE region 6F07-6F42 by apply_coverage --split [executed in 1 scenarios]

AbookAddr_CursorLeft:: ; 2F:6F07
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
	jr nz, Label_2F_6F28
	inc b
	dec b
	ret z

; ---- code $6F22-$6F28 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F07-6F42 by apply_coverage --split
	dec b
	call AbookAddr_GetCharPtr
	ld c, e
	ret

; ---- code $6F28-$6F42 (26 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 6F07-6F42 by apply_coverage --split [executed in 2 scenarios]

Label_2F_6F28:: ; 2F:6F28
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

AbookAddr_CursorRight:: ; 2F:6F2E
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

; ---- code $6F42-$6F44 (2 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_CursorRightStep:: ; 2F:6F42
Function_2F_6F42::
	jr Label_2F_6F4D

; ---- code $6F44-$6F4D (9 bytes) [HYPOTHESIS] 6 insn(s) (ld a,b ; cp $07 ; jr nz,end ; ld a,c ; cp $0B ; ret z) falling into the code at $6F4D; identical bytes at 2F:590B and 2F:6F44; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly
	ld a, b
	cp a, $07
	jr nz, Label_2F_6F4D
	ld a, c
	cp a, $0B
	ret z

; ---- code $6F4D-$6F5E (17 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_2F_6F4D:: ; 2F:6F4D
	inc c
	dec c
	jr nz, Label_2F_6F5E
	call AbookAddr_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

; ---- code $6F5E-$6F6D (15 bytes) [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0; entered by jrcc from 2F:6F4F (executed) | 9 insn(s) executed; cut out of the PROBABLE region 6F5E-6F8C by apply_coverage --split [executed in 5 scenarios]

Label_2F_6F5E:: ; 2F:6F5E
	call AbookAddr_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $41
	cp a, c
	ret nz

; ---- code $6F6D-$6F73 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F5E-6F8C by apply_coverage --split
	ld c, $40
	ld [wTextEditGoalColumn], a
	ret

; ---- code $6F73-$6F8A (23 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 6F5E-6F8C by apply_coverage --split [executed in 3 scenarios]

AbookAddr_BuffersEmpty:: ; 2F:6F73
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wEditAddressBuf]
	cp a, $00
	jr nz, Label_2F_6F8A
	ld a, [wEditNameBuf]
	cp a, $00
	jr nz, Label_2F_6F8A
	ld a, $FF
	ret

; ---- code $6F8A-$6F8C (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F5E-6F8C by apply_coverage --split

Label_2F_6F8A:: ; 2F:6F8A
	xor a, a
	ret

; ---- code $6F8C-$7050 (196 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_SetupScreen:: ; 2F:6F8C
Function_2F_6F8C::
	push af
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, $61D0
	ld a, $22
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $9701
	ld hl, $65D0
	ld a, $22
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	ld de, $8800
	ld hl, Data_2F_77D0
	ld a, $2F
	ld b, $94
	ld c, $32
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
	ld hl, Palette_AbookAddr_Bg
	ld a, $2F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_AbookAddr
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
	jr nz, Label_2F_7088

; ---- code $7050-$7088 (56 bytes) [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 0; fall-through of the jrcc at 2F:704E (executed) [executed in 2 scenarios]
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
	ld a, $09
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
	ld a, $39
	ld [wSplitScrollY], a

; ---- code $7088-$70C2 (58 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)

Label_2F_7088:: ; 2F:7088
	ld bc, $0000
	call AbookAddr_PlaceCursorSprites
	farcall LCDOn
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	farcall TextTiles_UploadBuffersShort
	pop af
	dec a
	jr nz, Label_2F_70EA

; ---- code $70C2-$70EA (40 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 2F:70C0 (executed) [executed in 2 scenarios]
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
	jr Label_2F_7119

; ---- code $70EA-$7135 (75 bytes) [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios)

Label_2F_70EA:: ; 2F:70EA
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
	ld a, $0A
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit

Label_2F_7119:: ; 2F:7119
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

AbookAddr_PlaceCursorSprites:: ; 2F:7121
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, c
	add a, $04
	add a, $04
	ld c, a
	ld a, c
	cp a, $30
	jr c, Label_2F_713A

; ---- code $7135-$713A (5 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2F:7133 (executed) [executed in 2 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

; ---- code $713A-$713F (5 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_2F_713A:: ; 2F:713A
	ld a, c
	cp a, $18
	jr c, Label_2F_7144

; ---- code $713F-$7144 (5 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2F:713D (executed) | upgraded by classifier 6: all 4 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc b
	ld a, c
	sub a, $18
	ld c, a

; ---- code $7144-$714B (7 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_2F_7144:: ; 2F:7144
	inc b
	inc c
	ld a, $38

Label_2F_7148:: ; 2F:7148
	dec b
	jr z, Label_2F_714F

; ---- code $714B-$714F (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2F:7149 (executed) | upgraded by classifier 6: all 2 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	add a, $0C
	jr Label_2F_7148

; ---- code $714F-$7180 (49 bytes) [CONFIRMED] 25 insn(s); 25 executed (in up to 1/18 scenarios)

Label_2F_714F:: ; 2F:714F
	add a, $10
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $08

Label_2F_7160:: ; 2F:7160
	dec c
	jr z, Label_2F_7167
	add a, $06
	jr Label_2F_7160

Label_2F_7167:: ; 2F:7167
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

AbookAddr_DrawLine1:: ; 2F:716F
	ld a, $11
	ld [wTextCellsLeft], a

Label_2F_7174:: ; 2F:7174
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_720F

; ---- code $7180-$718E (14 bytes) [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0; fall-through of the jpcc at 2F:717D (executed) | 6 insn(s) executed; cut out of the PROBABLE region 7180-720F by apply_coverage --split [executed in 6 scenarios]
	cp a, $0D
	jr z, Label_2F_71F4
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_71CF

; ---- code $718E-$71CF (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7180-720F by apply_coverage --split
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
	call AbookAddr_DrawLine1_Glyph
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
	jr z, Label_2F_720F
	cp a, $01
	jr z, Label_2F_720F
	jr Label_2F_7174

; ---- code $71CF-$71F4 (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 7180-720F by apply_coverage --split [executed in 6 scenarios]

Label_2F_71CF:: ; 2F:71CF
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
	call AbookAddr_DrawLine1_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_720F
	cp a, $01
	jr z, Label_2F_720F
	jr Label_2F_7174

; ---- code $71F4-$720F (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7180-720F by apply_coverage --split

Label_2F_71F4:: ; 2F:71F4
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
	call AbookAddr_DrawLine1_Pad

; ---- code $720F-$722A (27 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)

Label_2F_720F:: ; 2F:720F
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2F_721B:: ; 2F:721B
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookAddr_DrawLine1_Pad
	jr Label_2F_721B

; ---- code $722A-$723E (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by call from 2F:71A7 (PROBABLE code) | upgraded by classifier 6: all 12 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

AbookAddr_DrawLine1_Glyph:: ; 2F:722A
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

; ---- code $723E-$7267 (41 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_DrawLine1_Pad:: ; 2F:723E
Function_2F_723E::
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

AbookAddr_DrawLine:: ; 2F:7256
	ld a, $19
	ld [wTextCellsLeft], a

Label_2F_725B:: ; 2F:725B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2F_72F6

; ---- code $7267-$7275 (14 bytes) [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0; fall-through of the jpcc at 2F:7264 (executed) | 6 insn(s) executed; cut out of the PROBABLE region 7267-72F6 by apply_coverage --split [executed in 5 scenarios]
	cp a, $0D
	jr z, Label_2F_72DB
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2F_72B6

; ---- code $7275-$72B6 (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7267-72F6 by apply_coverage --split
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
	call AbookAddr_DrawLine_Glyph
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
	jr z, Label_2F_72F6
	cp a, $01
	jr z, Label_2F_72F6
	jr Label_2F_725B

; ---- code $72B6-$72DB (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 7267-72F6 by apply_coverage --split [executed in 5 scenarios]

Label_2F_72B6:: ; 2F:72B6
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
	call AbookAddr_DrawLine_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2F_72F6
	cp a, $01
	jr z, Label_2F_72F6
	jr Label_2F_725B

; ---- code $72DB-$72F6 (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7267-72F6 by apply_coverage --split

Label_2F_72DB:: ; 2F:72DB
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
	call AbookAddr_DrawLine_Pad

; ---- code $72F6-$7311 (27 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)

Label_2F_72F6:: ; 2F:72F6
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2F_7302:: ; 2F:7302
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookAddr_DrawLine_Pad
	jr Label_2F_7302

; ---- code $7311-$7325 (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by call from 2F:728E (PROBABLE code) | upgraded by classifier 6: all 12 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

AbookAddr_DrawLine_Glyph:: ; 2F:7311
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

; ---- code $7325-$733D (24 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_DrawLine_Pad:: ; 2F:7325
Function_2F_7325::
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

; ---- code $733D-$7385 (72 bytes) [CONFIRMED] 39 insn(s) reached by static flow only; seeds: exec x39; min discovery hops 8; entered by call from 2F:7713 (PROBABLE code) | upgraded by classifier 6: all 39 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

AbookAddr_UploadTextTiles:: ; 2F:733D
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
	call Function_2F_7365
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Function_2F_7365
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Function_2F_7365:: ; 2F:7365
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2F_7374:: ; 2F:7374
	ld a, [de]
	cp a, $8F
	jr nz, Label_2F_7374
	ld b, $91

Label_2F_737B:: ; 2F:737B
	ld a, [de]
	cp a, b
	jr nz, Label_2F_737B
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

; ---- code $7385-$7399 (20 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_GetCharPtr:: ; 2F:7385
Function_2F_7385::
	push bc
	call AbookAddr_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, Label_2F_73AC
	inc c
	ld a, [hl]

Label_2F_7396:: ; 2F:7396
	dec c
	jr z, Label_2F_73AA

; ---- code $7399-$73A6 (13 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 2F:7397 (executed) | upgraded by classifier 6: all 8 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_73AC
	ld a, [hl]
	cp a, $0D
	jr z, Label_2F_73B2
	jr Label_2F_7396

; ---- data $73A6-$73AA (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_73A6:: ; 2F:73A6
	db $0C, $0D, $20, $02

; ---- code $73AA-$73AC (2 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2F_73AA:: ; 2F:73AA
	pop bc
	ret

; ---- code $73AC-$73B2 (6 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1; entered by jrcc from 2F:7392 (executed) | 4 insn(s) executed; cut out of the PROBABLE region 73AC-73B8 by apply_coverage --split [executed in 6 scenarios]

Label_2F_73AC:: ; 2F:73AC
	ld a, $FF
	ld d, $FF
	pop bc
	ret

; ---- code $73B2-$73B8 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73AC-73B8 by apply_coverage --split

Label_2F_73B2:: ; 2F:73B2
	ld a, $0D
	ld d, $FF
	pop bc
	ret

; ---- code $73B8-$73CA (18 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_GetRowPtr:: ; 2F:73B8
Function_2F_73B8::
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	inc b

Label_2F_73C3:: ; 2F:73C3
	ld d, $00
	ld e, $18
	dec b
	jr z, Label_2F_73DB

; ---- code $73CA-$73DB (17 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 2F:73C8 (executed) [executed in 1 scenarios]

Label_2F_73CA:: ; 2F:73CA
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_73DB
	inc hl
	cp a, $0D
	jr z, Label_2F_73C3
	dec e
	jr nz, Label_2F_73CA
	jr Label_2F_73C3

; ---- code $73DB-$73E9 (14 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_2F_73DB:: ; 2F:73DB
	ld a, $FF
	cp a, d
	jr z, Label_2F_73F4
	ld e, $00
	push hl

Label_2F_73E3:: ; 2F:73E3
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, Label_2F_73F3

; ---- code $73E9-$73F3 (10 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2F:73E7 (executed) | upgraded by classifier 6: all 6 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $0D
	jr z, Label_2F_73F3
	inc e
	ld a, $17
	cp a, e
	jr nz, Label_2F_73E3

; ---- code $73F3-$73FA (7 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_2F_73F3:: ; 2F:73F3
	pop hl

Label_2F_73F4:: ; 2F:73F4
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

; ---- code $73FA-$7408 (14 bytes) [CONFIRMED] 227 insn(s) reached by static flow only; seeds: exec x227; min discovery hops 2; entered by call from 2F:7624 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 6 scenarios]

AbookAddr_InsertChar:: ; 2F:73FA
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2F_741D

; ---- code $7408-$741D (21 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split
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

; ---- code $741D-$74C9 (172 bytes) [CONFIRMED] 86 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 6 scenarios]

Label_2F_741D:: ; 2F:741D
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
	call AbookAddr_PlaceCursorSprites
	ld d, $14

Label_2F_744A:: ; 2F:744A
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, Label_2F_746C
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2F_746C
	dec d
	jr nz, Label_2F_744A

Label_2F_746C:: ; 2F:746C
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	call AbookAddr_PlaceCursorSprites
	farcall Function_00_0956
	pop bc
	pop de
	push de
	call AbookAddr_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D4FF
	ld bc, $D4FE

Label_2F_74A3:: ; 2F:74A3
	ld a, d
	cp a, h
	jr nz, Label_2F_74AB
	ld a, e
	cp a, l
	jr z, Label_2F_74B1

Label_2F_74AB:: ; 2F:74AB
	ld a, [bc]
	ld [de], a
	dec bc
	dec de
	jr Label_2F_74A3

Label_2F_74B1:: ; 2F:74B1
	pop hl
	pop de
	pop bc
	ld a, e
	ld [hl], a
	call AbookAddr_RedrawAfterInsert
	ld a, c
	cp a, $40
	jr z, Label_2F_74D6
	call AbookAddr_GetCharPtr
	cp a, $FF
	jr z, Label_2F_74D6
	cp a, $0D
	jr nz, Label_2F_74D2

; ---- code $74C9-$74D2 (9 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr Label_2F_74D6

; ---- code $74D2-$750C (58 bytes) [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 5 scenarios]

Label_2F_74D2:: ; 2F:74D2
	inc c
	ld [wTextEditGoalColumn], a

Label_2F_74D6:: ; 2F:74D6
	ret

AbookAddr_Backspace:: ; 2F:74D7
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
	call AbookAddr_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, Label_2F_7514

; ---- code $750C-$7514 (8 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, Label_2F_7515
	dec b
	ld c, e
	inc c

; ---- code $7514-$755B (71 bytes) [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 5 scenarios]

Label_2F_7514:: ; 2F:7514
	dec c

Label_2F_7515:: ; 2F:7515
	call AbookAddr_PlaceCursorSprites
	pop bc
	ld d, $14

Label_2F_751B:: ; 2F:751B
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, Label_2F_753D
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2F_753D
	dec d
	jr nz, Label_2F_751B

Label_2F_753D:: ; 2F:753D
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call AbookAddr_PlaceCursorSprites
	inc c
	dec c
	jr nz, Label_2F_7566

; ---- code $755B-$7566 (11 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split
	inc b
	dec b
	jr z, Label_2F_756B
	dec b
	call AbookAddr_GetCharPtr
	ld c, e
	jr Label_2F_756B

; ---- code $7566-$7582 (28 bytes) [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 5 scenarios]

Label_2F_7566:: ; 2F:7566
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a

Label_2F_756B:: ; 2F:756B
	call AbookAddr_GetCharPtr
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
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, Label_2F_7584

; ---- code $7582-$7584 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split
	ld e, $01

; ---- code $7584-$75A0 (28 bytes) [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage --split [executed in 5 scenarios]

Label_2F_7584:: ; 2F:7584
	ld a, $FF
	cp a, l
	jr nz, Label_2F_758E
	ld a, $D4
	cp a, h
	jr z, Label_2F_7593

Label_2F_758E:: ; 2F:758E
	ld a, [bc]
	ld [hli], a
	inc bc
	jr Label_2F_7584

Label_2F_7593:: ; 2F:7593
	xor a, a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push de
	call AbookAddr_RedrawAfterBackspace
	pop de
	ret

; ---- code $75A0-$75F5 (85 bytes) [CONFIRMED] 42 insn(s); 42 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_OpenKeyboard:: ; 2F:75A0
Function_2F_75A0::
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
	ld a, $09
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

AbookAddr_KeyboardLoop:: ; 2F:75D3
	push bc
	call AbookAddr_PlaceCursorSprites
	ld d, $70
	farcall Function_00_0956
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, AbookAddr_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, Label_2F_7629

; ---- code $75F5-$7603 (14 bytes) [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 2F:75F3 (executed) | 7 insn(s) executed; cut out of the PROBABLE region 75F5-7629 by apply_coverage --split [executed in 6 scenarios]
	cp a, $07
	ret z
	cp a, $08
	jr z, Label_2F_7634
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Label_2F_760C

; ---- code $7603-$760C (9 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 75F5-7629 by apply_coverage --split
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2F_760C
	jr AbookAddr_KeyboardLoop

; ---- code $760C-$7613 (7 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 75F5-7629 by apply_coverage --split [executed in 6 scenarios]

Label_2F_760C:: ; 2F:760C
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, Label_2F_761C

; ---- code $7613-$761C (9 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 75F5-7629 by apply_coverage --split
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2F_761C
	jr AbookAddr_KeyboardLoop

; ---- code $761C-$7629 (13 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 75F5-7629 by apply_coverage --split [executed in 6 scenarios]

Label_2F_761C:: ; 2F:761C
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call AbookAddr_InsertChar
	jr AbookAddr_KeyboardLoop

; ---- code $7629-$7646 (29 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)

Label_2F_7629:: ; 2F:7629
	ld a, c
	or a, b
	jr nz, Label_2F_7646
	call AbookAddr_GetLength
	cp a, $00
	jr nz, Label_2F_7646

Label_2F_7634:: ; 2F:7634
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

; ---- code $7646-$764C (6 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 2F:762B (executed) [executed in 5 scenarios]

Label_2F_7646:: ; 2F:7646
	call AbookAddr_Backspace
	jp AbookAddr_KeyboardLoop

; ---- data $764C-$764D (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_764C:: ; 2F:764C
	db $C9

; ---- code $764D-$765F (18 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookAddr_GetLength:: ; 2F:764D
Function_2F_764D::
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld d, $00

Label_2F_765A:: ; 2F:765A
	ld a, [hli]
	cp a, $00
	jr z, Label_2F_7665

; ---- code $765F-$7665 (6 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2F:765D (executed) | upgraded by classifier 6: all 4 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc d
	ld a, $40
	cp a, d
	jr nz, Label_2F_765A

; ---- code $7665-$7669 (4 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_2F_7665:: ; 2F:7665
	ld a, d
	pop de
	pop hl
	ret

; ---- code $7669-$76EF (134 bytes) [CONFIRMED] 135 insn(s) reached by static flow only; seeds: exec x135; min discovery hops 5; entered by call from 2F:74B6 (PROBABLE code) | 53 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split [executed in 2 scenarios]

AbookAddr_RedrawAfterInsert:: ; 2F:7669
	push bc
	inc c
	call AbookAddr_GetLength
	cp a, $10
	jr nc, Label_2F_7681
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	jp Label_2F_7713

Label_2F_7681:: ; 2F:7681
	ld a, c
	cp a, $29
	jr c, Label_2F_7695
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jp Label_2F_7713

Label_2F_7695:: ; 2F:7695
	ld a, c
	cp a, $11
	jr c, Label_2F_76AF
	call AbookAddr_GetLength
	cp a, $28
	jr nc, Label_2F_76AF
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr Label_2F_7713

Label_2F_76AF:: ; 2F:76AF
	ld a, c
	cp a, $11
	jr c, Label_2F_76CE
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jr Label_2F_7713

Label_2F_76CE:: ; 2F:76CE
	call AbookAddr_GetLength
	cp a, $28
	jr nc, Label_2F_76EF
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr Label_2F_7713

; ---- code $76EF-$7713 (36 bytes) [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split

Label_2F_76EF:: ; 2F:76EF
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine

; ---- code $7713-$7762 (79 bytes) [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split [executed in 1 scenarios]

Label_2F_7713:: ; 2F:7713
	call AbookAddr_UploadTextTiles
	pop bc
	ret

AbookAddr_RedrawAfterBackspace:: ; 2F:7718
	push bc
	call AbookAddr_GetLength
	cp a, $10
	jr nc, Label_2F_772F
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	jp Label_2F_77C1

Label_2F_772F:: ; 2F:772F
	ld a, c
	cp a, $29
	jr c, Label_2F_7743
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jp Label_2F_77C1

Label_2F_7743:: ; 2F:7743
	ld a, c
	cp a, $11
	jr c, Label_2F_775D
	call AbookAddr_GetLength
	cp a, $28
	jr nc, Label_2F_775D
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr Label_2F_77C1

Label_2F_775D:: ; 2F:775D
	ld a, c
	cp a, $11
	jr c, Label_2F_777C

; ---- code $7762-$777C (26 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jr Label_2F_77C1

; ---- code $777C-$779D (33 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split [executed in 1 scenarios]

Label_2F_777C:: ; 2F:777C
	call AbookAddr_GetLength
	cp a, $28
	jr nc, Label_2F_779D
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr Label_2F_77C1

; ---- code $779D-$77C1 (36 bytes) [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split

Label_2F_779D:: ; 2F:779D
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine

; ---- code $77C1-$77C6 (5 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage --split [executed in 5 scenarios]

Label_2F_77C1:: ; 2F:77C1
	call AbookAddr_UploadTextTiles
	pop bc
	ret

; ---- zero $77C6-$77D0 (10 bytes) [PROBABLE] all-zero padding before the tile block 77D0
	ds $A, $00
