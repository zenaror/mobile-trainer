; engine/html/layout.asm
; bank 74, $5252-$5905 (1715 bytes); pinned by layout.link
; page line layout, floats, image placement

SECTION "engine/html/layout", ROMX

Html_Layout_ClearAllFloats:: ; 74:5252
Function_74_5252::
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Html_Layout_EndLine
	push de
	push hl
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hRam_FFC4]
	cp a, e
	jr nz, .l5293
	ldh a, [hRam_FFC5]
	cp a, d
	jr nz, .l5293
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hRam_FFC2]
	cp a, e
	jr nz, .l5293
	ldh a, [hRam_FFC3]
	cp a, d
	jr nz, .l5293
	pop hl
	pop de
	ldh a, [hRam_FFB5]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D
	ret

.l5293 ; 74:5293
	; [CONFIRMED] 148 insn(s) reached by static flow only; seeds: exec x7, site x141; min discovery
	; hops 1; entered by jrcc from 74:526F (executed) | 80 insn(s) executed; cut out of the PROBABLE
	; region 5293-537D by apply_coverage --split [executed in 1 scenarios]
	pop hl
	pop de
	ld a, $0C
	ldh [hRam_FFC7], a
	xor a, a
	ldh [hRam_FFC6], a
	jp Html_Layout_ClearAllFloats

Html_Layout_PlaceImage:: ; 74:529F
	ld a, [wHtmlScanOnly]
	or a, a
	ret nz
	ldh a, [hRam_FFD6]
	ld e, a
	ld hl, $000C
	ld d, h
	ld c, h
	ld b, h
	call Divide32by15
	ld a, c
	or a, c
	jr z, .l52B5
	inc de
.l52B5 ; 74:52B5
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	add hl, de
	add hl, hl
	ld a, l
	ldh [hRam_FFD6], a
	ldh a, [hRam_FFD7]
	ld e, a
	ld hl, $000C
	ld d, h
	ld c, h
	ld b, h
	call Divide32by15
	ld a, c
	or a, c
	jr z, .l52D0
	inc de
.l52D0 ; 74:52D0
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	add hl, de
	add hl, hl
	ld a, l
	ldh [hRam_FFD7], a
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	add a, c
	jr nz, .l52E7
	push hl
	call Function_74_57AD
	pop hl
.l52E7 ; 74:52E7
	call Sound_FrameService
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC2]
	sub a, c
	ld c, a
	ldh [hRam_FFC0], a
	ldh a, [hRam_FFC3]
	sbc a, b
	ld b, a
	ldh [hRam_FFC1], a
	ldh a, [hRam_FFD6]
	ld l, a
	ld a, c
	sub a, l
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	jr nc, .l531D

	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5293-537D by apply_coverage --split
	ld a, c
	add a, l
	ld c, a
	ld a, b
	adc a, $00
	ld b, a
	call Html_Layout_PlaceLine
	ld a, c
	or a, b
	jp nz, .l52E7
	call Html_Layout_SkipPastFloats
	jp .l52E7

.l531D ; 74:531D
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 5293-537D by apply_coverage
	; --split [executed in 1 scenarios]
	or a, c
	jr nz, .l5326
	call Html_Layout_AppendImageRecord
	jp Html_Layout_PlaceLine
.l5326 ; 74:5326
	call Html_Layout_AppendImageRecord
	ret

Html_Layout_AppendImageRecord:: ; 74:532A
Function_74_532A::
	ldh a, [hRam_FFCA]
	ld l, a
	ldh a, [hRam_FFCB]
	ld h, a
	push bc
	ldh a, [hRam_FFD6]
	ld c, a
	ldh a, [hRam_FFD7]
	ld b, a
	ldh a, [hRam_FFD2]
	ld e, a
	ldh a, [hRam_FFD3]
	ld d, a
	ld a, $04
	ldh [hRam_FFB0], a
	ldh a, [hRam_FFD4]
	call Html_Layout_AppendRecord
	pop bc
	ret

Html_Layout_SkipPastFloats:: ; 74:5348
Function_74_5348::
	; [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5293-537D by apply_coverage --split
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hRam_FFC4]
	cp a, e
	jr nz, .l5369
	ldh a, [hRam_FFC5]
	cp a, d
	jr nz, .l5369
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hRam_FFC2]
	cp a, e
	jr nz, .l5369
	ldh a, [hRam_FFC3]
	cp a, d
	jr nz, .l5369
	ret
.l5369 ; 74:5369
	ldh a, [hRam_FFC8]
	add a, $0C
	ldh [hRam_FFC8], a
	ld e, a
	ldh a, [hRam_FFC9]
	adc a, $00
	ldh [hRam_FFC9], a
	ld d, a
	call Html_Layout_GetLimitsAtY
	jp Html_Layout_SkipPastFloats

Html_LoadPageImages:: ; 74:537D
Function_74_537D::
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hRam_FFCE]
	ld c, a
	ldh a, [hRam_FFCF]
	ld b, a
	or a, c
	jr z, .l53DC
	ldh a, [hRam_FFCC]
	ld l, a
	ldh a, [hRam_FFCD]
	ld h, a
.loop ; 74:5393
	call Sound_FrameService
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	push bc
	push hl
	ld bc, $0008
	add hl, bc
	ld a, [hl]
	cp a, $04
	jr nz, .l53D1

	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 74:53A4 (executed) [executed in 1 scenarios]
	ld a, $05
	ld [hl], a
	ld bc, $0003
	add hl, bc
	push hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $03
	farcall Html_NextResourceRecord
	farcall Bmp_ConvertToTiles
	or a, a
	jr z, .l53D1
	ld d, h
	ld e, l
	pop hl
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $03
	ld [hli], a

.l53D1 ; 74:53D1
	; [CONFIRMED] 110 insn(s); 110 executed (in up to 2/18 scenarios)
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
.l53DC ; 74:53DC
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

Html_Layout_Init:: ; 74:53E3
	xor a, a
	ldh [hRam_FFC6], a
	ldh [hRam_FFC7], a
	ldh [hRam_FFC8], a
	ldh [hRam_FFC9], a
	ldh [hRam_FFB2], a
	ldh a, [hRam_FFB8]
	add a, $20
	ldh [hRam_FFCA], a
	ldh [hRam_FFCC], a
	ldh a, [hRam_FFB9]
	adc a, $00
	ldh [hRam_FFCB], a
	ldh [hRam_FFCD], a
	ldh a, [hTextX + 1]
	ldh [hRam_FFCE], a
	ldh a, [hRam_FFBF]
	ldh [hRam_FFCF], a
	ldh a, [hViewRight]
	ldh [hRam_FFC2], a
	ldh a, [hViewRight + 1]
	ldh [hRam_FFC3], a
	ldh a, [hViewX]
	ldh [hRam_FFC4], a
	ldh a, [hViewX + 1]
	ldh [hRam_FFC5], a
	ret

Html_Layout_EndLine:: ; 74:5417
	ld a, [wHtmlScanOnly]
	or a, a
	ret nz
	push de
	push hl
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC2]
	sub a, c
	ld c, a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC3]
	sbc a, b
	ld b, a
	ldh a, [hTextX]
	call BankSwitch_H
	call Html_Layout_PlaceLine
	pop hl
	pop de
	ldh a, [hRam_FFB5]
	call BankSwitch_H
	ldh a, [hTextX]
	jp BankSwitch_D

Html_Layout_WrapRun:: ; 74:5440
	ld a, [wHtmlScanOnly]
	or a, a
	ret nz
	push hl
	push de
.l5447 ; 74:5447
	ld bc, $0C00
	ldh a, [hRam_FFBB]
	ld e, a
	ldh a, [hTextY]
	ld d, a
	ld a, $01
	ldh [hRam_FFB0], a
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, [de]
	or a, a
	jp z, .l54F4
	ldh a, [hTextX]
	call Html_Layout_AppendRecord
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC2]
	sub a, c
	ld c, a
	ldh [hRam_FFC0], a
	ldh a, [hRam_FFC3]
	sbc a, b
	ld b, a
	ldh [hRam_FFC1], a
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ldh a, [hRam_FFBB]
	ld l, a
	ldh a, [hTextY]
	ld h, a
	ldh a, [hTextX]
	call BankSwitch_H
.l5486 ; 74:5486
	call Sound_FrameService
	ld a, [hli]
	cp a, $20
	jr nc, .l54AA
	or a, a
	jr z, .l54EE

	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 74:548F (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 5491-54AA by apply_coverage --split [executed in 1 scenarios]
	cp a, $09
	jr z, .l5497

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5491-54AA by apply_coverage --split
	jr .l5486

.l5497 ; 74:5497
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5491-54AA by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, c
	sub a, $30
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	jr nc, .l54FE

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5491-54AA by apply_coverage --split
	dec hl
	ld a, c
	add a, $30
	ld c, a
	ld b, $00
	jr .l5502

.l54AA ; 74:54AA
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	cp a, $81
	jr c, .l54C2
	cp a, $A0
	jr c, .l54C3

	; [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 74:54B0 (executed) | 8 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 54B2-54C3 by apply_coverage --split
	cp a, $E0
	jr c, .l54C2
	cp a, $F0
	jr c, .l54C3
	cp a, $F8
	jr c, .l54C2
	cp a, $FA
	jr c, .l54C3

.l54C2 ; 74:54C2
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 54B2-54C3 by apply_coverage
	; --split [executed in 8 scenarios]
	or a, a

.l54C3 ; 74:54C3
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)
	jp c, .l54D9

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jpcc at 74:54C3 (executed) | 7 insn(s) executed; cut out of the PROBABLE
	; region 54C6-54D9 by apply_coverage --split [executed in 8 scenarios]
	ld a, c
	sub a, $06
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	jr nc, .l54FE

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 54C6-54D9 by apply_coverage --split
	dec hl
	ld a, c
	add a, $06
	ld c, a
	ld b, $00
	jr .l5502

.l54D9 ; 74:54D9
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	inc hl
	ld a, c
	sub a, $0C
	ld c, a
	ld a, b
	sbc a, $00
	ld b, a
	jr nc, .l54FE

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 74:54E2 (executed) [executed in 1 scenarios]
	dec hl
	dec hl
	ld a, c
	add a, $0C
	ld c, a
	ld b, $00
	jr .l5502

.l54EE ; 74:54EE
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 2/18 scenarios)
	call Html_Layout_CloseRunRecord
	call Function_74_55BE
.l54F4 ; 74:54F4
	pop de
	pop hl
	inc de
	ld a, e
	ldh [hRam_FFBB], a
	ld a, d
	ldh [hTextY], a
	ret
.l54FE ; 74:54FE
	or a, c
	jp nz, .l5486
.l5502 ; 74:5502
	call Html_Layout_CloseRunRecord
	call Function_74_55BE
	ld bc, $0000
	call Html_Layout_PlaceLine
	ldh a, [hRam_FFBB]
	ld e, a
	ldh a, [hTextY]
	ld d, a
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, [de]
	cp a, $20
	jr nz, .l5525

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 74:551C (executed) [executed in 1 scenarios]
	inc de
	ld a, e
	ldh [hRam_FFBB], a
	ld a, d
	ldh [hTextY], a

.l5525 ; 74:5525
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)
	jp .l5447

Html_Layout_CloseRunRecord:: ; 74:5528
Function_74_5528::
	ld a, l
	ldh [hRam_FFBB], a
	ld a, h
	ldh [hTextY], a
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	push hl
	ld de, $0004
	add hl, de
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	ldh a, [hRam_FFC0]
	sub a, c
	ld [hli], a
	ldh a, [hRam_FFC1]
	sbc a, b
	ld [hli], a
	pop hl
	ret

Html_Layout_AppendRecord:: ; 74:5548
	ldh [hRam_FFB1], a
	ldh a, [hRam_FFCA]
	ld l, a
	add a, $10
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCB]
	ld h, a
	adc a, $00
	ldh [hRam_FFCB], a
	cp a, $E0
	jp nz, .l556B

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jpcc at 74:555A (executed)
	ldh a, [hRam_FFCA]
	sub a, $10
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCB]
	sbc a, $00
	ldh [hRam_FFCB], a
	jr .l557B

.l556B ; 74:556B
	; [CONFIRMED] 109 insn(s); 109 executed (in up to 2/18 scenarios)
	ldh a, [hTextX + 1]
	add a, $01
	ldh [hTextX + 1], a
	ldh [hRam_FFCE], a
	ldh a, [hRam_FFBF]
	adc a, $00
	ldh [hRam_FFBF], a
	ldh [hRam_FFCF], a
.l557B ; 74:557B
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	push hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, c
	ld [hli], a
	xor a, a
	ld [hli], a
	ld a, b
	ld [hli], a
	xor a, a
	ld [hli], a
	ldh a, [hRam_FFB0]
	ld [hli], a
	ldh a, [hRam_FFB2]
	or a, $80
	ld [hli], a
	and a, $01
	jr z, .l559C
	ldh a, [hRam_FFDF]
.l559C ; 74:559C
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ldh a, [hRam_FFB1]
	ld [hli], a
	ldh a, [hRam_FFB2]
	and a, $01
	jr z, .l55AC
	ldh a, [hRam_FFE0]
.l55AC ; 74:55AC
	ld [hli], a
	pop hl
	ldh a, [hRam_FFB2]
	and a, $0C
	cp a, $04
	jr z, .done
	cp a, $0C
	jr z, .done
	call Function_74_55BE
.done ; 74:55BD
	ret

Function_74_55BE:: ; 74:55BE
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	add a, c
	jr nz, .l55CB
	push hl
	call Function_74_57AD
	pop hl
.l55CB ; 74:55CB
	call Sound_FrameService
	push hl
	ld bc, $0009
	add hl, bc
	ld a, [hli]
	pop hl
	bit 7, a
	ret z
	push hl
	ld bc, $0004
	add hl, bc
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC2]
	sub a, c
	ld c, a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC3]
	sbc a, b
	ld b, a
	ld a, c
	sub a, [hl]
	ld c, a
	inc hl
	ld a, b
	sbc a, [hl]
	ld b, a
	dec hl
	jp c, .l565C
	ldh a, [hRam_FFC4]
	add a, [hl]
	ldh [hRam_FFC4], a
	inc hl
	ldh a, [hRam_FFC5]
	adc a, [hl]
	ldh [hRam_FFC5], a
	inc hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld a, [hli]
	ld a, [hli]
	pop hl
	bit 7, a
	ret z
	and a, $30
	jr z, .l5622

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 74:560D (executed)
	cp a, $10
	jr z, .l5622
	cp a, $20
	jr z, .l562E
	ldh a, [hRam_FFC6]
	cp a, c
	ret nc
	ld a, c
	ldh [hRam_FFC6], a
	xor a, a
	ldh [hRam_FFC7], a
	ret

.l5622 ; 74:5622
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	ldh a, [hRam_FFC6]
	or a, a
	ret nz
	ldh a, [hRam_FFC7]
	cp a, c
	ret nc
	ld a, c
	ldh [hRam_FFC7], a
	ret

.l562E ; 74:562E
	; [PROBABLE] 39 insn(s) reached by static flow only; seeds: exec x39; min discovery hops 1;
	; entered by jrcc from 74:5615 (PROBABLE code)
	push hl
	push de
	push bc
	srl c
	ld e, c
	ld hl, $000C
	ld d, h
	ld c, h
	ld b, h
	call Divide32by15
	ld a, c
	cp a, $06
	jr c, .skip
	inc de
.skip ; 74:5643
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	add hl, de
	add hl, hl
	ld c, l
	pop de
	ld a, e
	sub a, c
	ld b, a
	pop de
	pop hl
	ldh a, [hRam_FFC6]
	cp a, c
	ret nc
	ld a, c
	ldh [hRam_FFC6], a
	ld a, b
	ldh [hRam_FFC7], a
	ret
.l565C ; 74:565C
	call Html_Layout_PlaceLine
	pop hl
	jp Function_74_55BE

Html_Layout_PlaceLine:: ; 74:5663
Function_74_5663::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh a, [hRam_FFC6]
	ld e, a
	ldh a, [hRam_FFC7]
	ld d, a
	push de
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	push bc
	call Html_Layout_GetLimitsAtY
	pop bc
	ld a, c
	or a, b
	jr z, .l56B0
	ld a, [wHtmlAlign]
	and a, $0C
	cp a, $08
	jr z, .l569A
	cp a, $04
	jr nz, .l56B0

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 74:5684 (executed) [executed in 1 scenarios]
	ldh a, [hRam_FFDA]
	add a, c
	ld c, a
	ldh a, [hRam_FFDB]
	adc a, b
	ld b, a
	ldh a, [hRam_FFC4]
	add a, c
	ldh [hRam_FFC4], a
	ldh a, [hRam_FFC5]
	adc a, b
	ldh [hRam_FFC5], a
	jr .l56B0

.l569A ; 74:569A
	; [CONFIRMED] 56 insn(s); 56 executed (in up to 2/18 scenarios)
	ldh a, [hRam_FFDA]
	add a, c
	ld c, a
	ldh a, [hRam_FFDB]
	adc a, b
	ld b, a
	srl b
	rr c
	ldh a, [hRam_FFC4]
	add a, c
	ldh [hRam_FFC4], a
	ldh a, [hRam_FFC5]
	adc a, b
	ldh [hRam_FFC5], a
.l56B0 ; 74:56B0
	pop bc
	ld a, c
	ldh [hRam_FFC6], a
	ld a, b
	ldh [hRam_FFC7], a
	ld a, e
	add a, c
	ld e, a
	ld a, d
	adc a, $00
	ld d, a
	ldh a, [hRam_FFCE]
	ld c, a
	ldh a, [hRam_FFCF]
	ld b, a
	or a, c
	jp z, .l5795
	ldh a, [hRam_FFCC]
	ld l, a
	ldh a, [hRam_FFCD]
	ld h, a
	ldh a, [hRam_FFBA]
	call BankSwitch_H
.loop ; 74:56D3
	call Sound_FrameService
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ld a, [hld]
	bit 7, a
	jp z, .l5789
	and a, $0C
	cp a, $0C
	jp z, .l5789
	cp a, $04
	jp z, .l5789
	ld a, [hli]
	ld c, a
	ld a, [hld]
	dec hl
	and a, $30
	jr z, .l572F

	; [PROBABLE] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 0;
	; fall-through of the jrcc at 74:56F4 (executed)
	cp a, $10
	jr z, .l572F
	cp a, $20
	jr nz, .l574A
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	push hl
	push de
	push bc
	srl b
	rr c
	ld e, c
	ld hl, $000C
	ld d, h
	ld c, h
	ld b, h
	call Divide32by15
	ld a, c
	cp a, $06
	jr c, .skip
	inc de
.skip ; 74:5719
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	add hl, de
	add hl, hl
	ld c, l
	ld b, $00
	pop de
	ld a, e
	sub a, c
	ldh [hRam_FFC0], a
	xor a, a
	ldh [hRam_FFC1], a
	pop de
	pop hl
	jr .l5755

.l572F ; 74:572F
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	ldh a, [hRam_FFC6]
	or a, a
	jr nz, .l573F
	ld bc, $0000
	ld a, [hld]
	ldh [hRam_FFC1], a
	ld a, [hld]
	ldh [hRam_FFC0], a
	jr .l5755

.l573F ; 74:573F
	; [PROBABLE] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 1;
	; entered by jrcc from 74:5732 (executed)
	xor a, a
	ldh [hRam_FFC1], a
	ldh [hRam_FFC0], a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	jr .l5755
.l574A ; 74:574A
	xor a, a
	ldh [hRam_FFC0], a
	ldh [hRam_FFC1], a
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	jr .l5755

.l5755 ; 74:5755
	; [CONFIRMED] 115 insn(s); 115 executed (in up to 2/18 scenarios)
	pop hl
	push hl
	ldh a, [hRam_FFC4]
	ld [hli], a
	ldh a, [hRam_FFC5]
	ld [hli], a
	ld a, e
	sub a, c
	ld [hli], a
	ld a, d
	sbc a, b
	ld [hli], a
	ldh a, [hRam_FFC4]
	add a, [hl]
	ld [hli], a
	ldh [hRam_FFC4], a
	ld c, a
	ldh a, [hRam_FFC5]
	adc a, [hl]
	ld [hli], a
	ldh [hRam_FFC5], a
	ld b, a
	ldh a, [hRam_FFC0]
	add a, e
	ld [hli], a
	ldh a, [hRam_FFC1]
	adc a, d
	ld [hli], a
	inc hl
	res 7, [hl]
	inc bc
	ldh a, [hRam_FFC2]
	sub a, c
	ldh a, [hRam_FFC3]
	sbc a, b
	jr nc, .l5789
	pop hl
	pop bc
	jr .l5795
.l5789 ; 74:5789
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, c
	or a, b
	jp nz, .loop
.l5795 ; 74:5795
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	ld b, a
	add a, e
	ldh [hRam_FFC8], a
	ld a, $00
	adc a, d
	ldh [hRam_FFC9], a
	ldh a, [hRam_FFD9]
	ldh [hRam_FFD8], a
	xor a, a
	ldh [hRam_FFC6], a
	ldh [hRam_FFC7], a
	ret

Function_74_57AD:: ; 74:57AD
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	call Html_Layout_GetLimitsAtY
	ldh a, [hRam_FFCE]
	ld c, a
	ldh a, [hRam_FFCF]
	ld b, a
	or a, c
	ret z
	ldh a, [hRam_FFCC]
	ld l, a
	ldh a, [hRam_FFCD]
	ld h, a
	ldh a, [hRam_FFBA]
	call BankSwitch_H
.loop ; 74:57C9
	call Sound_FrameService
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ld a, [hl]
	bit 7, a
	jp z, .l5861
	ldh [hRam_FFC0], a
	ld bc, $FFFB
	add hl, bc
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC2]
	sub a, c
	ld c, a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC3]
	sbc a, b
	ld b, a
	ld a, c
	sub a, [hl]
	inc hl
	ld a, [hl]
	ldh [hRam_FFC1], a
	ld a, b
	sbc a, [hl]
	dec hl
	jr c, .l584A
	ldh a, [hRam_FFC0]
	and a, $0C
	cp a, $0C
	jr z, .l5825
	cp a, $04
	jr nz, .l5861

	; [PROBABLE] 69 insn(s) reached by static flow only; seeds: exec x69; min discovery hops 0;
	; fall-through of the jrcc at 74:5801 (executed)
	ld c, [hl]
	pop hl
	push hl
	ldh a, [hRam_FFC1]
	ld b, a
	ldh a, [hRam_FFC2]
	ldh [hRam_FFC0], a
	sub a, c
	ld [hli], a
	ldh [hRam_FFC2], a
	ldh a, [hRam_FFC3]
	ldh [hRam_FFC1], a
	sbc a, b
	ld [hli], a
	ldh [hRam_FFC3], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ldh a, [hRam_FFC0]
	ld [hli], a
	ldh a, [hRam_FFC1]
	ld [hli], a
	jr .l583D
.l5825 ; 74:5825
	pop hl
	push hl
	ldh a, [hRam_FFC4]
	ld [hli], a
	ld c, a
	ldh a, [hRam_FFC5]
	ld [hli], a
	ld b, a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, [hl]
	add a, c
	ld [hli], a
	ldh [hRam_FFC4], a
	ld a, [hl]
	adc a, b
	ld [hli], a
	ldh [hRam_FFC5], a
.l583D ; 74:583D
	ld a, [hl]
	ld c, a
	add a, e
	ld [hli], a
	ld a, $00
	adc a, d
	ld [hli], a
	inc hl
	res 7, [hl]
	jr .l5861
.l584A ; 74:584A
	ldh a, [hRam_FFC6]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	ldh a, [hRam_FFC7]
	add a, e
	ld e, a
	ldh [hRam_FFC8], a
	ld a, $00
	adc a, d
	ld d, a
	ldh [hRam_FFC9], a
	call Html_Layout_GetLimitsAtY

.l5861 ; 74:5861
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 2/18 scenarios)
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, c
	or a, b
	jp nz, .loop
	ret

Html_Layout_GetLimitsAtY:: ; 74:586E
	ldh a, [hViewRight]
	ldh [hRam_FFC2], a
	ldh a, [hViewRight + 1]
	ldh [hRam_FFC3], a
	ldh a, [hViewX]
	ldh [hRam_FFC4], a
	ldh a, [hViewX + 1]
	ldh [hRam_FFC5], a
	ldh a, [hRam_FFD8]
	ld c, a
	ldh a, [hRam_FFC4]
	add a, c
	ldh [hRam_FFC4], a
	ldh a, [hRam_FFC5]
	adc a, $00
	ldh [hRam_FFC5], a
	ldh a, [hRam_FFCE]
	ld c, a
	ldh a, [hRam_FFCF]
	ld b, a
	or a, c
	jr z, .l5900
	ldh a, [hRam_FFCC]
	ld l, a
	ldh a, [hRam_FFCD]
	ld h, a
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	inc de
.loop ; 74:58A1
	call Sound_FrameService
	push bc
	push hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	sub a, e
	ld a, [hli]
	sbc a, d
	jr nc, .l58F4
	ld a, [hli]
	ldh [hRam_FFC6], a
	ld a, [hli]
	ldh [hRam_FFC7], a
	ld a, [hli]
	sub a, e
	ld a, [hli]
	sbc a, d
	jr c, .l58F4
	inc hl
	ld a, [hli]
	bit 7, a
	jr nz, .l58F4

	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 0;
	; fall-through of the jrcc at 74:58C0 (executed)
	and a, $0C
	cp a, $0C
	jr z, .l58DC
	cp a, $04
	jr nz, .l58F4
	ldh a, [hRam_FFC2]
	sub a, c
	ldh a, [hRam_FFC3]
	sbc a, b
	jr c, .l58F4
	ld a, c
	ldh [hRam_FFC2], a
	ld a, b
	ldh [hRam_FFC3], a
	jr .l58F4
.l58DC ; 74:58DC
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	ld b, a
	ldh a, [hRam_FFC4]
	sub a, c
	ldh a, [hRam_FFC5]
	sbc a, b
	jr nc, .l58F4
	ldh a, [hRam_FFD8]
	add a, c
	ldh [hRam_FFC4], a
	ld a, $00
	adc a, b
	ldh [hRam_FFC5], a

.l58F4 ; 74:58F4
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	dec de
.l5900 ; 74:5900
	ldh [hRam_FFC6], a
	ldh [hRam_FFC7], a
	ret
