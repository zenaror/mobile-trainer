; engine/text/sjis_validity.asm
; bank 63, $4000-$407A (122 bytes); pinned by layout.link
; Font_ValidateSjisCode and its bit jump table

SECTION "engine/text/sjis_validity", ROMX

; ---- code $4000-$402D (45 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 13/18 scenarios); entry proven: target of an executed call/far call

Font_ValidateSjisCode:: ; 63:4000
Function_63_4000::
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
	dw Label_63_403D
	dw Label_63_4043
	dw Label_63_4049
	dw Label_63_404F
	dw Label_63_4055
	dw Label_63_405B
	dw Label_63_4061
	dw Label_63_4067

; ---- code $403D-$4072 (53 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 13/18 scenarios)

Label_63_403D:: ; 63:403D
	bit 0, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_4043:: ; 63:4043
	bit 1, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_4049:: ; 63:4049
	bit 2, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_404F:: ; 63:404F
	bit 3, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_4055:: ; 63:4055
	bit 4, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_405B:: ; 63:405B
	bit 5, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_4061:: ; 63:4061
	bit 6, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Label_63_4067:: ; 63:4067
	bit 7, c
	jr z, Font_ValidateSjisCode_Invalid
	jr Font_ValidateSjisCode_Valid

Font_ValidateSjisCode_Valid:: ; 63:406D
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- code $4072-$407A (8 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1; entered by jrcc from 63:403F (executed) [executed in 1 scenarios]

Font_ValidateSjisCode_Invalid:: ; 63:4072
	pop hl
	pop de
	pop bc
	pop af
	ld hl, $81A1
	ret
