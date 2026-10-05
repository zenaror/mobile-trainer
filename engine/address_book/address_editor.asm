; engine/address_book/address_editor.asm
; bank 2F, $6D00-$77D0 (2768 bytes); pinned by layout.link
; address book address editor

SECTION "engine/address_book/address_editor", ROMX

AbookAddr_Edit:: ; 2F:6D00
Function_2F_6D00::
	; [CONFIRMED] 28 insn(s); 28 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	push af
	call AbookAddr_SetupScreen
	ld d, $40
.loop ; 2F:6D28
	push de
	call AbookAddr_CursorRightStep
	pop de
	dec d
	jr nz, .loop
	pop af
	cp a, $01
	jr nz, AbookAddr_Edit_Loop

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:6D33 (executed) [executed in 2 scenarios]
	call AbookAddr_KeyboardLoop
	jp AbookAddr_Edit_AfterKeyboard

; ---- data $6D3B-$6D40 (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_6D3B:: ; 2F:6D3B
	db $F1, $FE, $01, $28, $1B

AbookAddr_Edit_Loop:: ; 2F:6D40
Label_2F_6D40::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call AbookAddr_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, AbookAddr_Edit_CheckButtonB
	call AbookAddr_OpenKeyboard

AbookAddr_Edit_AfterKeyboard:: ; 2F:6D5E
Label_2F_6D5E::
	cp a, $07
	jp nz, .l6DF1

	; [CONFIRMED] 65 insn(s) reached by static flow only; seeds: exec x65; min discovery hops 0;
	; fall-through of the jpcc at 2F:6D60 (executed) [executed in 1 scenarios]
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld a, [hl]
	cp a, $00
	jr nz, .l6DC9
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
	jp AbookAddr_Edit_Loop
.l6DC9 ; 2F:6DC9
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	xor a, a
	ret

.l6DF1 ; 2F:6DF1
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	push bc
	farcall Joypad_Update
	pop bc

AbookAddr_Edit_CheckButtonB:: ; 2F:6DF9
Label_2F_6DF9::
	ldh a, [hJoyPressed]
	and a, $02
	jp z, .l6EF4

	; [CONFIRMED] 124 insn(s) reached by static flow only; seeds: exec x124; min discovery hops 0;
	; fall-through of the jpcc at 2F:6DFD (executed) | 22 insn(s) executed; cut out of the PROBABLE
	; region 6E00-6EF4 by apply_coverage --split [executed in 3 scenarios]
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
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]
	cp a, $01
	jr z, .l6E85
	call AbookAddr_BuffersEmpty
	inc a
	jp z, .l6EE1

	; [PROBABLE] 48 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6E00-6EF4 by apply_coverage --split
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
	jr z, .l6EE1
	pop bc
	jp AbookAddr_Edit_Loop

.l6E85 ; 2F:6E85
	; [CONFIRMED] 54 insn(s) executed; cut out of the PROBABLE region 6E00-6EF4 by apply_coverage
	; --split [executed in 1 scenarios]
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
	jr z, .l6EE1
	pop bc
	jp AbookAddr_Edit_Loop
.l6EE1 ; 2F:6EE1
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

.l6EF4 ; 2F:6EF4
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, AbookAddr_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, AbookAddr_CursorRight
	ld d, $10
	jp AbookAddr_Edit_Loop

AbookAddr_CursorLeft:: ; 2F:6F07
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by callcc from 2F:6EF8 (executed) | 18 insn(s) executed; cut out of the PROBABLE
	; region 6F07-6F42 by apply_coverage --split [executed in 1 scenarios]
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
	jr nz, .l6F28
	inc b
	dec b
	ret z

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6F07-6F42 by apply_coverage --split
	dec b
	call AbookAddr_GetCharPtr
	ld c, e
	ret

.l6F28 ; 2F:6F28
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 6F07-6F42 by apply_coverage
	; --split [executed in 2 scenarios]
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

AbookAddr_CursorRightStep:: ; 2F:6F42
Function_2F_6F42::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	jr .l6F4D

	; [HYPOTHESIS] 6 insn(s) (ld a,b ; cp $07 ; jr nz,end ; ld a,c ; cp $0B ; ret z) falling into
	; the code at $6F4D; identical bytes at 2F:590B and 2F:6F44; well-formed instruction chain
	; (clean decode, all direct targets land on instruction starts, lands exactly on the next code
	; region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to
	; HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank
	; search for the address word) and it is not a fall-through of proven code, so it is only bytes
	; that decode cleanly
	ld a, b
	cp a, $07
	jr nz, .l6F4D
	ld a, c
	cp a, $0B
	ret z

.l6F4D ; 2F:6F4D
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	inc c
	dec c
	jr nz, .l6F5E
	call AbookAddr_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

.l6F5E ; 2F:6F5E
	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0;
	; entered by jrcc from 2F:6F4F (executed) | 9 insn(s) executed; cut out of the PROBABLE region
	; 6F5E-6F8C by apply_coverage --split [executed in 5 scenarios]
	call AbookAddr_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $41
	cp a, c
	ret nz

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6F5E-6F8C by apply_coverage --split
	ld c, $40
	ld [wTextEditGoalColumn], a
	ret

AbookAddr_BuffersEmpty:: ; 2F:6F73
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 6F5E-6F8C by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wEditAddressBuf]
	cp a, $00
	jr nz, .l6F8A
	ld a, [wEditNameBuf]
	cp a, $00
	jr nz, .l6F8A
	ld a, $FF
	ret

.l6F8A ; 2F:6F8A
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6F5E-6F8C by apply_coverage --split
	xor a, a
	ret

AbookAddr_SetupScreen:: ; 2F:6F8C
Function_2F_6F8C::
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, $61D0
	ld a, $22
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, $65D0
	ld a, $22
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8800
	ld hl, Gfx_AbookAddr_Tiles8800
	ld a, $2F
	ld b, $94
	ld c, $32
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
	ld hl, Palette_AbookAddr_Bg
	ld a, $2F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_AbookAddr
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
	jr nz, .l7088

	; [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 0;
	; fall-through of the jrcc at 2F:704E (executed) [executed in 2 scenarios]
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

.l7088 ; 2F:7088
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)
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
	jr nz, .l70EA

	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0;
	; fall-through of the jrcc at 2F:70C0 (executed) [executed in 2 scenarios]
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
	jr .l7119

.l70EA ; 2F:70EA
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios)
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
	ld a, $0A
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
.l7119 ; 2F:7119
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
	jr c, .l713A

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2F:7133 (executed) [executed in 2 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

.l713A ; 2F:713A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, c
	cp a, $18
	jr c, .l7144

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2F:713D (executed) | upgraded by classifier 6: all 4 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc b
	ld a, c
	sub a, $18
	ld c, a

.l7144 ; 2F:7144
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	inc b
	inc c
	ld a, $38
.l7148 ; 2F:7148
	dec b
	jr z, .l714F

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:7149 (executed) | upgraded by classifier 6: all 2 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	add a, $0C
	jr .l7148

.l714F ; 2F:714F
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 1/18 scenarios)
	add a, $10
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $08
.l7160 ; 2F:7160
	dec c
	jr z, .l7167
	add a, $06
	jr .l7160
.l7167 ; 2F:7167
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

AbookAddr_DrawLine1:: ; 2F:716F
	ld a, $11
	ld [wTextCellsLeft], a
.l7174 ; 2F:7174
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l720F

	; [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0;
	; fall-through of the jpcc at 2F:717D (executed) | 6 insn(s) executed; cut out of the PROBABLE
	; region 7180-720F by apply_coverage --split [executed in 6 scenarios]
	cp a, $0D
	jr z, .l71F4
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l71CF

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7180-720F by apply_coverage --split
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
	jr z, .l720F
	cp a, $01
	jr z, .l720F
	jr .l7174

.l71CF ; 2F:71CF
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 7180-720F by apply_coverage
	; --split [executed in 6 scenarios]
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
	jr z, .l720F
	cp a, $01
	jr z, .l720F
	jr .l7174

.l71F4 ; 2F:71F4
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7180-720F by apply_coverage --split
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

.l720F ; 2F:720F
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l721B ; 2F:721B
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookAddr_DrawLine1_Pad
	jr .l721B

AbookAddr_DrawLine1_Glyph:: ; 2F:722A
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by call from 2F:71A7 (PROBABLE code) | upgraded by classifier 6: all 12 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
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

AbookAddr_DrawLine1_Pad:: ; 2F:723E
Function_2F_723E::
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
.l725B ; 2F:725B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l72F6

	; [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0;
	; fall-through of the jpcc at 2F:7264 (executed) | 6 insn(s) executed; cut out of the PROBABLE
	; region 7267-72F6 by apply_coverage --split [executed in 5 scenarios]
	cp a, $0D
	jr z, .l72DB
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l72B6

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7267-72F6 by apply_coverage --split
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
	jr z, .l72F6
	cp a, $01
	jr z, .l72F6
	jr .l725B

.l72B6 ; 2F:72B6
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 7267-72F6 by apply_coverage
	; --split [executed in 5 scenarios]
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
	jr z, .l72F6
	cp a, $01
	jr z, .l72F6
	jr .l725B

.l72DB ; 2F:72DB
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7267-72F6 by apply_coverage --split
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

.l72F6 ; 2F:72F6
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l7302 ; 2F:7302
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call AbookAddr_DrawLine_Pad
	jr .l7302

AbookAddr_DrawLine_Glyph:: ; 2F:7311
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by call from 2F:728E (PROBABLE code) | upgraded by classifier 6: all 12 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
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

AbookAddr_DrawLine_Pad:: ; 2F:7325
Function_2F_7325::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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

AbookAddr_UploadTextTiles:: ; 2F:733D
	; [CONFIRMED] 39 insn(s) reached by static flow only; seeds: exec x39; min discovery hops 8;
	; entered by call from 2F:7713 (PROBABLE code) | upgraded by classifier 6: all 39 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
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
	call Gfx_StartHDMAAtVBlank_2F_7365
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2F_7365
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2F_7365:: ; 2F:7365
Function_2F_7365::
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
.l7374 ; 2F:7374
	ld a, [de]
	cp a, $8F
	jr nz, .l7374
	ld b, $91
.l737B ; 2F:737B
	ld a, [de]
	cp a, b
	jr nz, .l737B
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

AbookAddr_GetCharPtr:: ; 2F:7385
Function_2F_7385::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	call AbookAddr_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, AbookAddr_GetCharPtr_NoChar
	inc c
	ld a, [hl]
.loop ; 2F:7396
	dec c
	jr z, AbookAddr_GetCharPtr_Found

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 2F:7397 (executed) | upgraded by classifier 6: all 8 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, AbookAddr_GetCharPtr_NoChar
	ld a, [hl]
	cp a, $0D
	jr z, AbookAddr_GetCharPtr_Newline
	jr .loop

; ---- data $73A6-$73AA (4 bytes) [HYPOTHESIS] UNCLASSIFIED 4 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_73A6:: ; 2F:73A6
	db $0C, $0D, $20, $02

AbookAddr_GetCharPtr_Found:: ; 2F:73AA
Label_2F_73AA::
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	pop bc
	ret

AbookAddr_GetCharPtr_NoChar:: ; 2F:73AC
Label_2F_73AC::
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 2F:7392 (executed) | 4 insn(s) executed; cut out of the PROBABLE region
	; 73AC-73B8 by apply_coverage --split [executed in 6 scenarios]
	ld a, $FF
	ld d, $FF
	pop bc
	ret

AbookAddr_GetCharPtr_Newline:: ; 2F:73B2
Label_2F_73B2::
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73AC-73B8 by apply_coverage --split
	ld a, $0D
	ld d, $FF
	pop bc
	ret

AbookAddr_GetRowPtr:: ; 2F:73B8
Function_2F_73B8::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	inc b
.l73C3 ; 2F:73C3
	ld d, $00
	ld e, $18
	dec b
	jr z, .l73DB

.l73CA ; 2F:73CA
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 2F:73C8 (executed) [executed in 1 scenarios]
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l73DB
	inc hl
	cp a, $0D
	jr z, .l73C3
	dec e
	jr nz, .l73CA
	jr .l73C3

.l73DB ; 2F:73DB
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .l73F4
	ld e, $00
	push hl
.l73E3 ; 2F:73E3
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l73F3

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2F:73E7 (executed) | upgraded by classifier 6: all 6 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $0D
	jr z, .l73F3
	inc e
	ld a, $17
	cp a, e
	jr nz, .l73E3

.l73F3 ; 2F:73F3
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	pop hl
.l73F4 ; 2F:73F4
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

AbookAddr_InsertChar:: ; 2F:73FA
	; [CONFIRMED] 227 insn(s) reached by static flow only; seeds: exec x227; min discovery hops 2;
	; entered by call from 2F:7624 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE
	; region 73FA-75A0 by apply_coverage --split [executed in 6 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4FF
	ld a, [hl]
	cp a, $00
	jr z, .l741D

	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73FA-75A0 by apply_coverage --split
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

.l741D ; 2F:741D
	; [CONFIRMED] 86 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage
	; --split [executed in 6 scenarios]
	push de
	push bc
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
	push bc
	ld hl, $DA10
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call AbookAddr_PlaceCursorSprites
	ld d, $14
.l744A ; 2F:744A
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	jr nz, .l746C
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l746C
	dec d
	jr nz, .l744A
.l746C ; 2F:746C
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	call AbookAddr_PlaceCursorSprites
	farcall Sprite_UpdateAll
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
.l74A3 ; 2F:74A3
	ld a, d
	cp a, h
	jr nz, .l74AB
	ld a, e
	cp a, l
	jr z, .l74B1
.l74AB ; 2F:74AB
	ld a, [bc]
	ld [de], a
	dec bc
	dec de
	jr .l74A3
.l74B1 ; 2F:74B1
	pop hl
	pop de
	pop bc
	ld a, e
	ld [hl], a
	call AbookAddr_RedrawAfterInsert
	ld a, c
	cp a, $40
	jr z, .done
	call AbookAddr_GetCharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l74D2

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73FA-75A0 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l74D2 ; 2F:74D2
	; [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage
	; --split [executed in 5 scenarios]
	inc c
	ld [wTextEditGoalColumn], a
.done ; 2F:74D6
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
	call AbookAddr_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l7514

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73FA-75A0 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, .l7515
	dec b
	ld c, e
	inc c

.l7514 ; 2F:7514
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage
	; --split [executed in 5 scenarios]
	dec c
.l7515 ; 2F:7515
	call AbookAddr_PlaceCursorSprites
	pop bc
	ld d, $14
.loop ; 2F:751B
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	jr nz, .l753D
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l753D
	dec d
	jr nz, .loop
.l753D ; 2F:753D
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call AbookAddr_PlaceCursorSprites
	inc c
	dec c
	jr nz, .l7566

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73FA-75A0 by apply_coverage --split
	inc b
	dec b
	jr z, .l756B
	dec b
	call AbookAddr_GetCharPtr
	ld c, e
	jr .l756B

.l7566 ; 2F:7566
	; [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage
	; --split [executed in 5 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l756B ; 2F:756B
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
	jr nz, .l7584

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 73FA-75A0 by apply_coverage --split
	ld e, $01

.l7584 ; 2F:7584
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 73FA-75A0 by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, $FF
	cp a, l
	jr nz, .l758E
	ld a, $D4
	cp a, h
	jr z, .l7593
.l758E ; 2F:758E
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l7584
.l7593 ; 2F:7593
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

AbookAddr_OpenKeyboard:: ; 2F:75A0
Function_2F_75A0::
	; [CONFIRMED] 42 insn(s); 42 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, AbookAddr_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, .l7629

	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 2F:75F3 (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 75F5-7629 by apply_coverage --split [executed in 6 scenarios]
	cp a, $07
	ret z
	cp a, $08
	jr z, .l7634
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l760C

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 75F5-7629 by apply_coverage --split
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l760C
	jr AbookAddr_KeyboardLoop

.l760C ; 2F:760C
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 75F5-7629 by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l761C

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 75F5-7629 by apply_coverage --split
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l761C
	jr AbookAddr_KeyboardLoop

.l761C ; 2F:761C
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 75F5-7629 by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call AbookAddr_InsertChar
	jr AbookAddr_KeyboardLoop

.l7629 ; 2F:7629
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)
	ld a, c
	or a, b
	jr nz, .l7646
	call AbookAddr_GetLength
	cp a, $00
	jr nz, .l7646
.l7634 ; 2F:7634
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

.l7646 ; 2F:7646
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 2F:762B (executed) [executed in 5 scenarios]
	call AbookAddr_Backspace
	jp AbookAddr_KeyboardLoop

; ---- data $764C-$764D (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_764C:: ; 2F:764C
	db $C9

AbookAddr_GetLength:: ; 2F:764D
Function_2F_764D::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld d, $00
.loop ; 2F:765A
	ld a, [hli]
	cp a, $00
	jr z, .l7665

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2F:765D (executed) | upgraded by classifier 6: all 4 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	inc d
	ld a, $40
	cp a, d
	jr nz, .loop

.l7665 ; 2F:7665
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	ld a, d
	pop de
	pop hl
	ret

AbookAddr_RedrawAfterInsert:: ; 2F:7669
	; [CONFIRMED] 135 insn(s) reached by static flow only; seeds: exec x135; min discovery hops 5;
	; entered by call from 2F:74B6 (PROBABLE code) | 53 insn(s) executed; cut out of the PROBABLE
	; region 7669-77C6 by apply_coverage --split [executed in 2 scenarios]
	push bc
	inc c
	call AbookAddr_GetLength
	cp a, $10
	jr nc, .l7681
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	jp .l7713
.l7681 ; 2F:7681
	ld a, c
	cp a, $29
	jr c, .l7695
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jp .l7713
.l7695 ; 2F:7695
	ld a, c
	cp a, $11
	jr c, .l76AF
	call AbookAddr_GetLength
	cp a, $28
	jr nc, .l76AF
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr .l7713
.l76AF ; 2F:76AF
	ld a, c
	cp a, $11
	jr c, .l76CE
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jr .l7713
.l76CE ; 2F:76CE
	call AbookAddr_GetLength
	cp a, $28
	jr nc, .l76EF
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr .l7713

.l76EF ; 2F:76EF
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7669-77C6 by apply_coverage --split
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

.l7713 ; 2F:7713
	; [CONFIRMED] 34 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage
	; --split [executed in 1 scenarios]
	call AbookAddr_UploadTextTiles
	pop bc
	ret

AbookAddr_RedrawAfterBackspace:: ; 2F:7718
	push bc
	call AbookAddr_GetLength
	cp a, $10
	jr nc, .l772F
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	jp .l77C1
.l772F ; 2F:772F
	ld a, c
	cp a, $29
	jr c, .l7743
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jp .l77C1
.l7743 ; 2F:7743
	ld a, c
	cp a, $11
	jr c, .l775D
	call AbookAddr_GetLength
	cp a, $28
	jr nc, .l775D
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr .l77C1
.l775D ; 2F:775D
	ld a, c
	cp a, $11
	jr c, .l777C

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7669-77C6 by apply_coverage --split
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4E8
	call AbookAddr_DrawLine
	jr .l77C1

.l777C ; 2F:777C
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage
	; --split [executed in 1 scenarios]
	call AbookAddr_GetLength
	cp a, $28
	jr nc, .l779D
	ld bc, $0300
	ld de, $0438
	ld hl, $D4C0
	call AbookAddr_DrawLine1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D0
	call AbookAddr_DrawLine
	jr .l77C1

.l779D ; 2F:779D
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7669-77C6 by apply_coverage --split
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

.l77C1 ; 2F:77C1
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 7669-77C6 by apply_coverage
	; --split [executed in 5 scenarios]
	call AbookAddr_UploadTextTiles
	pop bc
	ret

; ---- zero $77C6-$77D0 (10 bytes) [PROBABLE] all-zero padding before the tile block 77D0
	ds $A, $00
