; engine/text/sjis_validity.asm
; bank 63, $4000-$407A (122 bytes); pinned by layout.link
; Font_ValidateSjisCode and its bit jump table

SECTION "engine/text/sjis_validity", ROMX

Font_ValidateSjisCode:: ; 63:4000
Function_63_4000::
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 13/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	push de
	push hl
	ld a, l
	and a, $07
	ld b, a
	srl h
	rr l
	srl h
	rr l
	srl h
	rr l
	ld de, $407A
	ld a, e
	add a, l
	ld l, a
	ld a, d
	adc a, h
	ld h, a
	ld a, [hl]
	ld c, a
	ld a, b
	add a, a
	add a, $2D
	ld l, a
	ld a, $40
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $402D-$403D (16 bytes) [CONFIRMED] code-pointer table, 8 entries: 8/8 words hit own-bank code starts (survey pointer-table extent); 8/8 targets executed; every byte read as data in a trace

Font_SjisBitJumpTable:: ; 63:402D
Table_63_402D::
	dw Font_ValidateSjisCode_TestBit0
	dw Font_ValidateSjisCode_TestBit1
	dw Font_ValidateSjisCode_TestBit2
	dw Font_ValidateSjisCode_TestBit3
	dw Font_ValidateSjisCode_TestBit4
	dw Font_ValidateSjisCode_TestBit5
	dw Font_ValidateSjisCode_TestBit6
	dw Font_ValidateSjisCode_TestBit7

Font_ValidateSjisCode_TestBit0:: ; 63:403D
Label_63_403D::
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 13/18 scenarios)
	bit 0, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit1:: ; 63:4043
Label_63_4043::
	bit 1, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit2:: ; 63:4049
Label_63_4049::
	bit 2, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit3:: ; 63:404F
Label_63_404F::
	bit 3, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit4:: ; 63:4055
Label_63_4055::
	bit 4, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit5:: ; 63:405B
Label_63_405B::
	bit 5, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit6:: ; 63:4061
Label_63_4061::
	bit 6, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_TestBit7:: ; 63:4067
Label_63_4067::
	bit 7, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_Valid:: ; 63:406D
	pop hl
	pop de
	pop bc
	pop af
	ret

Font_ValidateSjisCode_Invalid:: ; 63:4072
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 63:403F (executed) [executed in 1 scenarios]
	pop hl
	pop de
	pop bc
	pop af
	ld hl, $81A1
	ret
