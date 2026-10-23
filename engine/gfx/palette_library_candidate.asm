; engine/gfx/palette_library_candidate.asm
; bank 29, $5090-$5376 (742 bytes); pinned by layout.link
; candidate library image; entry and live bank context remain unestablished

SECTION "engine/gfx/palette_library_candidate", ROMX
ClearLcdcBit2:: ; 29:5090

	; [HYPOTHESIS] 742-byte library admits460 conditional starts; entry/purpose/live bank unproved.
	; [PROBABLE] ClearLcdcBit2:7B/4 starts; executed6B/3-start relatives at27:468B and50:400F.
	; Leaf511E:39B/24 starts saves BC/DE, CALL7BB7; balanced return required, HL not saved.
	; Static internal CALL 29:50CE -> 29:511E was already confirmed; entry to 50CE/span remains unproved.
	; FFA4.bit0 selects unbounded LY poll24/48/6C/90 or48/90; no explicit WRAM store in leaf.
	; Natural corpus: 69 coverage, 69 dataaccess and 69 callgraphs; no span instruction/data-read/callgraph rows.
	; Outside-span: 4,001 raw words/323 opcode-shaped patterns (14-opcode scan); no physical29 CALL/JP; patterns are not caller proofs.
	; $7BB7 is zero padding in physical bank 29; entry/copy/relocation and selected bank are unknown.
	; Writes to $2000/$3000 at $510F can change later fetches; padding cannot exclude every leaf.
	; 50DA reads ROM0 CD 18, computes $B312, writes $12 then $B3+LY to MBC5 RAMG; entry/purpose unproved.
	; Standalone $DBD0 entries need a bank precondition; $520D explicitly sets real SVBK=1.
	; At $526D BG uses B=$40 zero writes; OBJ uses B=$00, DEC/JR NZ and [DE], not a 64-byte clear.
	; No 24-byte window occurs outside this span; these raw/static facts do not establish live use.
	; Historical forced_dead: 187/460 starts (traces/forced/), inherited evidence only;
	; not natural evidence or full-path proof; candidate entry and purpose remain HYPOTHESIS.
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ret

PalLibCandidate_SetLcdcBit2:: ; 29:5097
	; [CONFIRMED] set LCDC bit 2; natural entry and library purpose remain HYPOTHESIS.
	ldh a, [rLCDC]
	or a, $04
	ldh [rLCDC], a
	ret

PalLibCandidate_ClearLcdcBit2AndCopyOffsetRecordsUntilFF:: ; 29:509E
	; [CONFIRMED] clear LCDC bit 2, then copy four-byte records from HL to $C000+C until
	; the first source byte is $FF; add D/E to the first/second bytes. Entry and caller are unproved.
	call ClearLcdcBit2
	ld b, $C0
.l50A3 ; 29:50A3
	ld a, [hli]
	cp a, $FF
	ret z
	add a, d
	ld [bc], a
	inc bc
	ld a, [hli]
	add a, e
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	ld a, [hli]
	ld [bc], a
	inc bc
	jr .l50A3

PalLibCandidate_ClearShadowOam160BytesAndReturnSavedBCInDE:: ; 29:50B6
	; [CONFIRMED] zero $C000-$C09F, restore AF/HL, and place entry BC in DE; entry and purpose
	; remain HYPOTHESIS.
	push af
	push bc
	push hl
	ld b, $A0
	ld hl, wShadowOAM
	xor a, a
.l50BF ; 29:50BF
	ld [hli], a
	dec b
	jr nz, .l50BF
	pop hl
	pop de
	pop af
	ret
PalLibCandidate_WaitAndServiceVBlankForBCount:: ; 29:50C7
	; [CONFIRMED] call VBlank_WaitAndService, decrement B, and repeat until B reaches zero;
	; B=0 wraps to 256 iterations. Entry and caller are unproved.
.l50C7 ; 29:50C7
	call VBlank_WaitAndService
	dec b
	jr nz, .l50C7
	ret

PalLibCandidate_Call511EThenWaitVBlanksForBMinusOneCount:: ; 29:50CE
	; [CONFIRMED] call 29:511E, decrement B, then run the preceding wait loop while nonzero;
	; B=1 waits zero times and B=0 wraps. Entry and caller are unproved.
	call CallSelected7BB7_IfReturnsPollLyByFFA4Bit0
	dec b
	jr nz, PalLibCandidate_WaitAndServiceVBlankForBCount
	ret

PalLibCandidate_AdvanceHLByDEStrideUntilCZero:: ; 29:50D5
	; [CONFIRMED] decrement C; return at zero, otherwise add DE to HL and repeat. Initial C=0
	; wraps through 255 iterations. Entry and caller are unproved.
.l50D5 ; 29:50D5
	dec c
	ret z
	add hl, de
	jr .l50D5

PalLibCandidate_DisableMbc5RamThenWriteLyDerivedGateValue:: ; 29:50DA
	; [CONFIRMED MBC5 decode] ROM0 CD 18 -> $18CD; arithmetic -> $B312; $0C0E/$0C0F are RAMG mirrors.
	; Writes $12 (disable), then $B3+LY (enable iff LY&$0F=$7); natural entry, runtime LY and purpose remain HYPOTHESIS.
	push de
	push hl
	ld a, [$0C0E]
	ld l, a
	ld a, [$0C0F]
	ld h, a
	ld d, h
	ld e, l
	add hl, hl
	add hl, hl
	add hl, de
	ld de, $3711
	add hl, de
	ld a, l
	ld [$0C0E], a
	ldh a, [rLY]
	ld l, a
	ld a, h
	add a, l
	ld [$0C0F], a
	pop hl
	pop de
	ret

PalLibCandidate_DivideABy10ToFfb1QuotientFfb0Remainder:: ; 29:50FC
	; [CONFIRMED] store floor(A/10) in $FFB1 and A mod 10 in $FFB0; preserve HL. Entry and
	; caller are unproved.
	push hl
	ld hl, hRam_FFB1
	ld [hl], $00
.l5102 ; 29:5102
	cp a, $0A
	jr c, .l510B
	sub a, $0A
	inc [hl]
	jr .l5102
.l510B ; 29:510B
	ldh [hRam_FFB0], a
	pop hl
	ret

PalLibCandidate_WriteRomBankLowAAndZeroHigh:: ; 29:510F
	; [CONFIRMED] write A to $2000 and zero to $3000; mapper-level purpose and entry are unproved.
	ld [rROMB0], a
	xor a, a
	ld [rROMB1], a
	ret

PalLibCandidate_WaitLY90:: ; 29:5117

	ldh a, [rLY]
	cp a, $90
	jr nz, PalLibCandidate_WaitLY90
	ret
CallSelected7BB7_IfReturnsPollLyByFFA4Bit0:: ; 29:511E [PROBABLE] operation; entry unproved

	push bc
	push de
	call $7BB7
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, PADF_A
	jr z, .wait_ly_48_or_90
.wait_ly_24_48_6c_or90 ; 29:512B
	ldh a, [rLY]
	cp a, $24
	ret z
	cp a, $48
	ret z
	cp a, $6C
	ret z
	cp a, $90
	jr nz, .wait_ly_24_48_6c_or90
	ret
.wait_ly_48_or_90 ; 29:513B
	ldh a, [rLY]
	cp a, $48
	ret z
	cp a, $90
	jr nz, .wait_ly_48_or_90
	ret

PalLibCandidate_DisableVBlankIrq:: ; 29:5145

	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $FE
	ldh [rIE], a
	ret

PalLibCandidate_EnableVBlankIrq:: ; 29:514F

	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	or a, $01
	ldh [rIE], a
	ret

PalLibCandidate_FadeCurrentPalettesTowardBlack:: ; 29:5159
	; [PROBABLE] Repeat four rounds of eight blackward palette steps: read the current BG/OBJ
	; palettes, update the working buffer, and write each round. Natural entry, caller, source bank
	; and buffer-bank contract remain unknown.
	ldh a, [rSVBK]
	push af
	ld b, $04
.fade_pass ; 29:515E
	push bc
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_ReadPalettesToBuffer
	ld b, $08
.fade_step ; 29:5167
	push bc
	call PalLibCandidate_FadeStepTowardBlack
	pop bc
	dec b
	jr nz, .fade_step
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop bc
	dec b
	jr nz, .fade_pass
	pop af
	ldh [rSVBK], a
	ret

PalLibCandidate_FadePaletteBlockTowardBlackThenReload:: ; 29:517D
	; [PROBABLE] The outer pass count runs from four down to one. Each pass copies the palette block
	; at HL, then runs that many groups of eight blackward steps and writes the result. If each step
	; helper returns, this is 32, 24, 16, and 8 calls (80 total); then the source block is copied and
	; written unchanged. Entry and bank contracts remain unknown.
	ldh a, [rSVBK]
	push af
	ld b, $04
.fade_pass ; 29:5182
	push bc
	push hl
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_FillBufferFromBlock
	ld c, b
.fade_group ; 29:518B
	ld b, $08
.fade_step ; 29:518D
	push bc
	call PalLibCandidate_FadeStepTowardBlack
	pop bc
	dec b
	jr nz, .fade_step
	dec c
	jr nz, .fade_group
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop hl
	pop bc
	dec b
	jr nz, .fade_pass
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_FillBufferFromBlock
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop af
	ldh [rSVBK], a
	ret

PalLibCandidate_FadeCurrentPalettesTowardWhite:: ; 29:51B3
	; [PROBABLE] Repeat four rounds of eight whiteward palette steps: read the current BG/OBJ
	; palettes, update the working buffer, and write each round. Natural entry, caller, source bank
	; and buffer-bank contract remain unknown.
	ldh a, [rSVBK]
	push af
	ld b, $04
.fade_pass ; 29:51B8
	push bc
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_ReadPalettesToBuffer
	ld b, $08
.fade_step ; 29:51C1
	push bc
	call PalLibCandidate_FadeStepTowardWhite
	pop bc
	dec b
	jr nz, .fade_step
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop bc
	dec b
	jr nz, .fade_pass
	pop af
	ldh [rSVBK], a
	ret

PalLibCandidate_FadePaletteBlockTowardWhiteThenReload:: ; 29:51D7
	; [PROBABLE] The outer pass count runs from four down to one. Each pass copies the palette block
	; at HL, then runs that many groups of eight whiteward steps and writes the result. If each step
	; helper returns, this is 32, 24, 16, and 8 calls (80 total); then the source block is copied and
	; written unchanged. Entry and bank contracts remain unknown.
	ldh a, [rSVBK]
	push af
	ld b, $04
.fade_pass ; 29:51DC
	push bc
	push hl
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_FillBufferFromBlock
	ld c, b
.fade_group ; 29:51E5
	ld b, $08
.fade_step ; 29:51E7
	push bc
	call PalLibCandidate_FadeStepTowardWhite
	pop bc
	dec b
	jr nz, .fade_step
	dec c
	jr nz, .fade_group
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop hl
	pop bc
	dec b
	jr nz, .fade_pass
	call PalLibCandidate_DisableVBlankIrq
	call PalLibCandidate_FillBufferFromBlock
	call PalLibCandidate_WriteBufferToPalettes
	call PalLibCandidate_EnableVBlankIrq
	pop af
	ldh [rSVBK], a
	ret

PalLibCandidate_ReadPalettesToBuffer:: ; 29:520D

	ld a, $01
	ldh [rSVBK], a
	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only): bank 1 is selected on the real register at 29:520D, but no name covers $DBD0 of bank 1
	xor a, a
	ldh [rBCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $40
	ld c, $00
.read_bg_palette_bytes ; 29:521E
	ldh a, [rBCPD]
	ld [de], a
	inc c
	ld a, c
	ldh [rBCPS], a
	inc de
	dec b
	jr nz, .read_bg_palette_bytes
	xor a, a
	ldh [rOCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $40
	ld c, $00
.read_obj_palette_bytes ; 29:5233
	ldh a, [rOCPD]
	ld [de], a
	inc c
	ld a, c
	ldh [rOCPS], a
	inc de
	dec b
	jr nz, .read_obj_palette_bytes
	ret

PalLibCandidate_WriteBufferToPalettes:: ; 29:523F

	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	xor a, a
	ldh [rBCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $40
	ld c, $00
.write_bg_palette_bytes ; 29:524C
	ld a, [de]
	ldh [rBCPD], a
	inc c
	ld a, c
	ldh [rBCPS], a
	inc de
	dec b
	jr nz, .write_bg_palette_bytes
	xor a, a
	ldh [rOCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $40
	ld c, $00
.write_obj_palette_bytes ; 29:5261
	ld a, [de]
	ldh [rOCPD], a
	inc c
	ld a, c
	ldh [rOCPS], a
	inc de
	dec b
	jr nz, .write_obj_palette_bytes
	ret

PalLibCandidate_Zero64BgPaletteBytesAndWriteObjStreamFromDE:: ; 29:526D
	; [CONFIRMED] zero 64 BG palette bytes, then write the B-counted stream from DE to OBJ palette
	; data; B starts at zero, so the OBJ loop runs 256 times. Entry and intent are unproved.
	call PalLibCandidate_DisableVBlankIrq
	xor a, a
	ldh [rBCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $40
	ld c, $00
.l527A ; 29:527A
	ld a, $00
	ldh [rBCPD], a
	inc c
	ld a, c
	ldh [rBCPS], a
	inc de
	dec b
	jr nz, .l527A
	xor a, a
	ldh [rOCPS], a
	call PalLibCandidate_WaitLY90
	ld b, $00
	ld c, $00
.l5290 ; 29:5290
	ld a, [de]
	ldh [rOCPD], a
	inc c
	ld a, c
	ldh [rOCPS], a
	inc de
	dec b
	jr nz, .l5290
	call PalLibCandidate_EnableVBlankIrq
	ret

PalLibCandidate_FadeStepTowardWhite:: ; 29:529F

	ld hl, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	ld b, $40
.increase_color_components ; 29:52A4
	push bc
	ld a, [hli]
	ld e, a
	inc a
	and a, $1F
	jr nz, .l52AE
	ld a, $1F
.l52AE ; 29:52AE
	ld c, a
	ld a, e
	and a, $E0
	swap a
	ld e, a
	ld a, [hli]
	ld d, a
	and a, $03
	swap a
	or a, e
	inc a
	inc a
	and a, $3E
	jr nz, .l52C4
	ld a, $3E
.l52C4 ; 29:52C4
	swap a
	ld e, a
	and a, $E0
	or a, c
	ld c, a
	ld a, e
	and a, $03
	ld e, a
	srl d
	srl d
	ld a, d
	inc a
	and a, $1F
	jr nz, .l52DB
	ld a, $1F
.l52DB ; 29:52DB
	sla a
	sla a
	or a, e
	ld d, a
	ld e, c
	dec hl
	dec hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	pop bc
	dec b
	jr nz, .increase_color_components
	ret

PalLibCandidate_FadeStepTowardBlack:: ; 29:52ED

	ld hl, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	ld b, $40
.decrease_color_components ; 29:52F2
	push bc
	ld a, [hli]
	ld e, a
	and a, $1F
	jr z, .l52FA
	dec a
.l52FA ; 29:52FA
	ld c, a
	ld a, e
	and a, $E0
	swap a
	ld e, a
	ld a, [hli]
	ld d, a
	and a, $03
	swap a
	or a, e
	and a, $3E
	jr z, .l530E
	dec a
	dec a
.l530E ; 29:530E
	swap a
	ld e, a
	and a, $E0
	or a, c
	ld c, a
	ld a, e
	and a, $03
	ld e, a
	srl d
	srl d
	ld a, d
	and a, $1F
	jr z, .l5323
	dec a
.l5323 ; 29:5323
	sla a
	sla a
	or a, e
	ld d, a
	ld e, c
	dec hl
	dec hl
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	pop bc
	dec b
	jr nz, .decrease_color_components
	ret

PalLibCandidate_FillBufferFromBlock:: ; 29:5335

	push bc
	ld c, $02
	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
.l533B ; 29:533B
	ld b, $40
	push hl
.copy_palette_block ; 29:533E
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .copy_palette_block
	pop hl
	dec c
	jr nz, .l533B
	pop bc
	ret

PalLibCandidate_Write64BgAnd64ObjPaletteBytesFromHLAtLy90:: ; 29:534A
	; [CONFIRMED] write 64 bytes each to BG and OBJ palette data, waiting for LY=$90 before each
	; group; entry and caller are unproved.
	ld a, $80
	ldh [rBCPS], a
	ld b, $40
.wait_bg_ly_90 ; 29:5350
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_bg_ly_90
.l5356 ; 29:5356
	ld a, [hli]
	ldh [rBCPD], a
	dec b
	jr nz, .l5356
	ld a, $80
	ldh [rOCPS], a
	ld b, $40
.wait_obj_ly_90 ; 29:5362
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_obj_ly_90
.l5368 ; 29:5368
	ld a, [hli]
	ldh [rOCPD], a
	dec b
	jr nz, .l5368
	ret

PalLibCandidate_SetLcdcBit1:: ; 29:536F
	; [CONFIRMED] set LCDC bit 1; natural entry and library purpose remain HYPOTHESIS.
	ldh a, [rLCDC]
	or a, $02
	ldh [rLCDC], a
	ret
