; engine/gfx/unreferenced_palette_library.asm
; bank 29, $5090-$5376 (742 bytes); pinned by layout.link
; self-contained routine library with no caller (palette/OAM/PRNG idioms)

SECTION "engine/gfx/unreferenced_palette_library", ROMX

Function_29_5090:: ; 29:5090
	; [HYPOTHESIS] self-contained routine library that decodes cleanly (460 legal instructions,
	; internal calls/jumps all land on instruction starts inside the span, idioms: LCDC bit2 toggles
	; 5090/5097, OAM copy/clear, PRNG hl=hl*5+$3711 mixed with LY at 50DA, wait LY=$90 at 5117, ROM
	; bank write $2000/$3000 at 510F, CGB palette fade routines through rBCPS/BCPD $FF68-6B with the
	; $DBD0 buffer at 520D-52xx). NO caller/pointer/far pointer to any address inside was found in
	; the ROM (top-level entries 5159 and 517D are uncalled), and 'call $7BB7' at 5120 lands in this
	; bank's zero padding (so it cannot be running in place in bank 29). Kept as code HYPOTHESIS;
	; could be dead code or an image meant for another bank/RAM [verifier: additional evidence
	; against a live routine in place: the PRNG uses ld a,[$0C0E]/ld [$0C0E],a (a ROM address, an
	; MBC RAM-enable write area) and the internal 'call $7BB7' lands in this bank's zero padding;
	; the library is unique in the ROM (no 24-byte window of it appears elsewhere); no
	; word/call/jp/ld r16/far pointer to any of its 460 instruction starts exists outside it; stays
	; HYPOTHESIS] | forced execution: 187/460 instruction starts ran in forced_dead (traces/forced/,
	; not natural evidence; status unchanged)
	ldh a, [rLCDC]
	and a, $FB
	ldh [rLCDC], a
	ret

	ldh a, [rLCDC]
	or a, $04
	ldh [rLCDC], a
	ret

	call Function_29_5090
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
.l50C7 ; 29:50C7
	call VBlank_WaitAndService
	dec b
	jr nz, .l50C7
	ret

	call Function_29_511E
	dec b
	jr nz, .l50C7
	ret
.l50D5 ; 29:50D5
	dec c
	ret z
	add hl, de
	jr .l50D5

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

	ld [rROMB0], a
	xor a, a
	ld [rROMB1], a
	ret

PalLibUnused_WaitLY90:: ; 29:5117
Function_29_5117::
	ldh a, [rLY]
	cp a, $90
	jr nz, PalLibUnused_WaitLY90
	ret

Function_29_511E:: ; 29:511E
	push bc
	push de
	call $7BB7
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $01
	jr z, .l513B
.loop ; 29:512B
	ldh a, [rLY]
	cp a, $24
	ret z
	cp a, $48
	ret z
	cp a, $6C
	ret z
	cp a, $90
	jr nz, .loop
	ret
.l513B ; 29:513B
	ldh a, [rLY]
	cp a, $48
	ret z
	cp a, $90
	jr nz, .l513B
	ret

PalLibUnused_DisableVBlankIrq:: ; 29:5145
Function_29_5145::
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $FE
	ldh [rIE], a
	ret

PalLibUnused_EnableVBlankIrq:: ; 29:514F
Function_29_514F::
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	or a, $01
	ldh [rIE], a
	ret

	ldh a, [rSVBK]
	push af
	ld b, $04
.l515E ; 29:515E
	push bc
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_ReadPalettesToBuffer
	ld b, $08
.l5167 ; 29:5167
	push bc
	call PalLibUnused_FadeStepTowardBlack
	pop bc
	dec b
	jr nz, .l5167
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop bc
	dec b
	jr nz, .l515E
	pop af
	ldh [rSVBK], a
	ret

	ldh a, [rSVBK]
	push af
	ld b, $04
.l5182 ; 29:5182
	push bc
	push hl
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_FillBufferFromBlock
	ld c, b
.l518B ; 29:518B
	ld b, $08
.l518D ; 29:518D
	push bc
	call PalLibUnused_FadeStepTowardBlack
	pop bc
	dec b
	jr nz, .l518D
	dec c
	jr nz, .l518B
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop hl
	pop bc
	dec b
	jr nz, .l5182
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_FillBufferFromBlock
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop af
	ldh [rSVBK], a
	ret

	ldh a, [rSVBK]
	push af
	ld b, $04
.l51B8 ; 29:51B8
	push bc
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_ReadPalettesToBuffer
	ld b, $08
.l51C1 ; 29:51C1
	push bc
	call PalLibUnused_FadeStepTowardWhite
	pop bc
	dec b
	jr nz, .l51C1
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop bc
	dec b
	jr nz, .l51B8
	pop af
	ldh [rSVBK], a
	ret

	ldh a, [rSVBK]
	push af
	ld b, $04
.l51DC ; 29:51DC
	push bc
	push hl
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_FillBufferFromBlock
	ld c, b
.l51E5 ; 29:51E5
	ld b, $08
.l51E7 ; 29:51E7
	push bc
	call PalLibUnused_FadeStepTowardWhite
	pop bc
	dec b
	jr nz, .l51E7
	dec c
	jr nz, .l51E5
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop hl
	pop bc
	dec b
	jr nz, .l51DC
	call PalLibUnused_DisableVBlankIrq
	call PalLibUnused_FillBufferFromBlock
	call PalLibUnused_WriteBufferToPalettes
	call PalLibUnused_EnableVBlankIrq
	pop af
	ldh [rSVBK], a
	ret

PalLibUnused_ReadPalettesToBuffer:: ; 29:520D
Function_29_520D::
	ld a, $01
	ldh [rSVBK], a
	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only): bank 1 is selected on the real register at 29:520D, but no name covers $DBD0 of bank 1
	xor a, a
	ldh [rBCPS], a
	call PalLibUnused_WaitLY90
	ld b, $40
	ld c, $00
.l521E ; 29:521E
	ldh a, [rBCPD]
	ld [de], a
	inc c
	ld a, c
	ldh [rBCPS], a
	inc de
	dec b
	jr nz, .l521E
	xor a, a
	ldh [rOCPS], a
	call PalLibUnused_WaitLY90
	ld b, $40
	ld c, $00
.l5233 ; 29:5233
	ldh a, [rOCPD]
	ld [de], a
	inc c
	ld a, c
	ldh [rOCPS], a
	inc de
	dec b
	jr nz, .l5233
	ret

PalLibUnused_WriteBufferToPalettes:: ; 29:523F
Function_29_523F::
	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	xor a, a
	ldh [rBCPS], a
	call PalLibUnused_WaitLY90
	ld b, $40
	ld c, $00
.l524C ; 29:524C
	ld a, [de]
	ldh [rBCPD], a
	inc c
	ld a, c
	ldh [rBCPS], a
	inc de
	dec b
	jr nz, .l524C
	xor a, a
	ldh [rOCPS], a
	call PalLibUnused_WaitLY90
	ld b, $40
	ld c, $00
.l5261 ; 29:5261
	ld a, [de]
	ldh [rOCPD], a
	inc c
	ld a, c
	ldh [rOCPS], a
	inc de
	dec b
	jr nz, .l5261
	ret

	call PalLibUnused_DisableVBlankIrq
	xor a, a
	ldh [rBCPS], a
	call PalLibUnused_WaitLY90
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
	call PalLibUnused_WaitLY90
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
	call PalLibUnused_EnableVBlankIrq
	ret

PalLibUnused_FadeStepTowardWhite:: ; 29:529F
Function_29_529F::
	ld hl, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	ld b, $40
.loop ; 29:52A4
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
	jr nz, .loop
	ret

PalLibUnused_FadeStepTowardBlack:: ; 29:52ED
Function_29_52ED::
	ld hl, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
	ld b, $40
.loop ; 29:52F2
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
	jr nz, .loop
	ret

PalLibUnused_FillBufferFromBlock:: ; 29:5335
Function_29_5335::
	push bc
	ld c, $02
	ld de, $DBD0 ; raw: unreferenced palette library (no caller, forced execution only), the bank in force is not shown
.l533B ; 29:533B
	ld b, $40
	push hl
.l533E ; 29:533E
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l533E
	pop hl
	dec c
	jr nz, .l533B
	pop bc
	ret

	ld a, $80
	ldh [rBCPS], a
	ld b, $40
.l5350 ; 29:5350
	ldh a, [rLY]
	cp a, $90
	jr nz, .l5350
.l5356 ; 29:5356
	ld a, [hli]
	ldh [rBCPD], a
	dec b
	jr nz, .l5356
	ld a, $80
	ldh [rOCPS], a
	ld b, $40
.l5362 ; 29:5362
	ldh a, [rLY]
	cp a, $90
	jr nz, .l5362
.l5368 ; 29:5368
	ld a, [hli]
	ldh [rOCPD], a
	dec b
	jr nz, .l5368
	ret

	ldh a, [rLCDC]
	or a, $02
	ldh [rLCDC], a
	ret
