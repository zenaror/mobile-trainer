; engine/text/charset_convert.asm
; bank 7E, $7B7C-$7EB3 (823 bytes); pinned by layout.link
; Shift-JIS / ISO-2022-JP / EUC-JP conversion

SECTION "engine/text/charset_convert", ROMX

; ---- code $7B7C-$7B81 (5 bytes) [CONFIRMED] 268 insn(s) reached by static flow only; seeds: exec x268; min discovery hops 1; entered by call from 7E:7BDA (PROBABLE code) | 3 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 12 scenarios]

Charset_JisToSjis:: ; 7E:7B7C
	ld a, b
	cp a, $5F
	jr c, Label_7E_7B84

; ---- code $7B81-$7B84 (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split
	add a, $80
	ld b, a

; ---- code $7B84-$7BAE (42 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 6 scenarios]

Label_7E_7B84:: ; 7E:7B84
	srl a
	jr c, Label_7E_7B91
	add a, $70
	ld b, a
	ld a, c
	add a, $7E
	ld c, a
	jr Label_7E_7BA2

Label_7E_7B91:: ; 7E:7B91
	ld a, c
	cp a, $60
	jr c, Label_7E_7B97
	inc c

Label_7E_7B97:: ; 7E:7B97
	ld a, c
	add a, $1F
	ld c, a
	srl b
	ld a, b
	add a, $71
	ld b, a
	xor a, a

Label_7E_7BA2:: ; 7E:7BA2
	ret

Charset_SjisToJis:: ; 7E:7BA3
	ld b, h
	ld c, l
	ld a, b
	cp a, $80
	jr c, Label_7E_7BCF
	cp a, $A0
	jr c, Label_7E_7BB4

; ---- code $7BAE-$7BB4 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split
	cp a, $E0
	jr c, Label_7E_7BCF
	sub a, $40

; ---- code $7BB4-$7BC8 (20 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 2 scenarios]

Label_7E_7BB4:: ; 7E:7BB4
	sub a, $70
	ld d, a
	ld a, c
	cp a, $9F
	jr nc, Label_7E_7BBD
	dec d

Label_7E_7BBD:: ; 7E:7BBD
	sla d
	cp a, $9F
	jr nc, Label_7E_7BCB
	inc d
	cp a, $80
	jr c, Label_7E_7BC9

; ---- code $7BC8-$7BC9 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split
	dec a

; ---- code $7BC9-$7BD6 (13 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 2 scenarios]

Label_7E_7BC9:: ; 7E:7BC9
	add a, $5F

Label_7E_7BCB:: ; 7E:7BCB
	sub a, $7E
	ld b, a
	ld c, d

Label_7E_7BCF:: ; 7E:7BCF
	ld a, b
	ld b, c
	ld c, a
	xor a, a
	ld h, b
	ld l, c
	ret

; ---- code $7BD6-$7BDE (8 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split

Charset_EucJpToSjis:: ; 7E:7BD6
	res 7, b
	res 7, c
	call Charset_JisToSjis
	ret

; ---- code $7BDE-$7BF0 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 1 scenarios]

Charset_DetectEncoding:: ; 7E:7BDE
	call Charset_ReadByteCounted
	or a, a
	jr z, Label_7E_7C27
	cp a, $1B
	jr z, Label_7E_7BF2
	cp a, $A1
	jr nc, Charset_DetectEncoding
	cp a, $80
	jr c, Charset_DetectEncoding

; ---- code $7BF0-$7C27 (55 bytes) [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split
	jr Label_7E_7C21

Label_7E_7BF2:: ; 7E:7BF2
	call Charset_ReadByteCounted
	or a, a
	jr z, Label_7E_7C27
	ld d, a
	call Charset_ReadByteCounted
	or a, a
	jr z, Label_7E_7C27
	ld e, a
	ld a, d
	cp a, $24
	jr z, Label_7E_7C0B
	cp a, $28
	jr z, Label_7E_7C16
	jr Charset_DetectEncoding

Label_7E_7C0B:: ; 7E:7C0B
	ld a, e
	cp a, $42
	jr z, Label_7E_7C24
	cp a, $40
	jr z, Label_7E_7C24
	jr Charset_DetectEncoding

Label_7E_7C16:: ; 7E:7C16
	ld a, e
	cp a, $4A
	jr z, Label_7E_7C24
	cp a, $42
	jr z, Label_7E_7C24
	jr Charset_DetectEncoding

Label_7E_7C21:: ; 7E:7C21
	ld a, $01
	ret

Label_7E_7C24:: ; 7E:7C24
	ld a, $02
	ret

; ---- code $7C27-$7C52 (43 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 1 scenarios]

Label_7E_7C27:: ; 7E:7C27
	ld a, $03
	ret

Charset_ReadByteCounted:: ; 7E:7C2A
	ld a, b
	or a, c
	jp z, Label_7E_7C32
	dec bc
	ld a, [hli]
	ret

Label_7E_7C32:: ; 7E:7C32
	xor a, a
	ret

Charset_SjisToIso2022Jp:: ; 7E:7C34
	ld a, e
	ldh [hRam_FFB3], a
	ld a, d
	ldh [hRam_FFB4], a
	ld a, b
	or a, c
	jp z, Label_7E_7D0A
	ld a, $00
	ldh [hRam_FFB0], a

Label_7E_7C43:: ; 7E:7C43
	ld a, [hli]
	or a, a
	jp z, Label_7E_7CE7
	ldh [hRam_FFB1], a
	cp a, $81
	jr c, Label_7E_7C62
	cp a, $A0
	jr c, Label_7E_7C63

; ---- code $7C52-$7C62 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split
	cp a, $E0
	jr c, Label_7E_7C62
	cp a, $F0
	jr c, Label_7E_7C63
	cp a, $F8
	jr c, Label_7E_7C62
	cp a, $FA
	jr c, Label_7E_7C63

; ---- code $7C62-$7CE4 (130 bytes) [CONFIRMED] 90 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 6 scenarios]

Label_7E_7C62:: ; 7E:7C62
	or a, a

Label_7E_7C63:: ; 7E:7C63
	jr c, Label_7E_7C98
	ldh a, [hRam_FFB0]
	or a, a
	jr z, Label_7E_7C8C
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $28
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $00
	ldh [hRam_FFB0], a

Label_7E_7C8C:: ; 7E:7C8C
	ldh a, [hRam_FFB1]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	jr Label_7E_7C43

Label_7E_7C98:: ; 7E:7C98
	ldh a, [hRam_FFB0]
	or a, a
	jr nz, Label_7E_7CBF
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $24
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $01
	ldh [hRam_FFB0], a

Label_7E_7CBF:: ; 7E:7CBF
	ld a, [hli]
	ldh [hRam_FFB2], a
	push hl
	ldh a, [hRam_FFB1]
	ld h, a
	ldh a, [hRam_FFB2]
	ld l, a
	push bc
	push de
	call Charset_SjisToJis
	pop de
	pop bc
	ld a, h
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jr z, Label_7E_7CE4
	ld a, l
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jr z, Label_7E_7CE4
	pop hl
	jp Label_7E_7C43

; ---- code $7CE4-$7CE7 (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split

Label_7E_7CE4:: ; 7E:7CE4
	pop hl
	jr Label_7E_7D0A

; ---- code $7CE7-$7D19 (50 bytes) [CONFIRMED] 37 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage --split [executed in 6 scenarios]

Label_7E_7CE7:: ; 7E:7CE7
	ldh a, [hRam_FFB0]
	or a, a
	jr z, Label_7E_7D0A
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $28
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7D0A

Label_7E_7D0A:: ; 7E:7D0A
	ldh a, [hRam_FFB3]
	ld c, a
	ldh a, [hRam_FFB4]
	ld b, a
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, b
	ld d, a
	ld c, e
	ld b, d
	ret

; ---- code $7D19-$7D1D (4 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Charset_ConvertPage:: ; 7E:7D19
Function_7E_7D19::
	ld a, b
	or a, a
	jr nz, Label_7E_7D26

; ---- code $7D1D-$7D26 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 7E:7D1B (executed)
	ld a, c
	cp a, $04
	jr nc, Label_7E_7D26
	ld bc, $0000
	ret

; ---- code $7D26-$7D35 (15 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)

Label_7E_7D26:: ; 7E:7D26
	inc hl
	inc hl
	inc de
	inc de
	dec bc
	dec bc
	dec bc
	dec bc
	ld a, [wCommSessionKind]
	cp a, $01
	jr nz, Label_7E_7D5A

; ---- code $7D35-$7D50 (27 bytes) [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0; fall-through of the jrcc at 7E:7D33 (executed) | 19 insn(s) executed; cut out of the PROBABLE region 7D35-7D5A by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	push hl
	dec hl
	dec hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	call Charset_DetectEncoding
	pop hl
	pop de
	pop bc
	cp a, $01
	jr z, Label_7E_7D50
	cp a, $02
	jr z, Label_7E_7D5A
	cp a, $03
	jr z, Label_7E_7D56

; ---- code $7D50-$7D56 (6 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7D35-7D5A by apply_coverage --split

Label_7E_7D50:: ; 7E:7D50
	dec hl
	dec hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

; ---- code $7D56-$7D5A (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 7D35-7D5A by apply_coverage --split [executed in 1 scenarios]

Label_7E_7D56:: ; 7E:7D56
	call Charset_EucJpToSjisStream
	ret

; ---- code $7D5A-$7D62 (8 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_7E_7D5A:: ; 7E:7D5A
	ld a, $01
	ld [wRam_C282], a
	jp Label_7E_7D66

; ---- code $7D62-$7D66 (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 14; entered by far from 54:4A73 (PROBABLE code) [upgraded PROBABLE->CONFIRMED by the classify_g1 pass: every instruction start of the region appears in analysis/coverage_union.tsv]

Charset_Iso2022JpToSjis:: ; 7E:7D62
	xor a, a
	ld [wRam_C282], a

; ---- code $7D66-$7D8F (41 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)

Label_7E_7D66:: ; 7E:7D66
	ld a, e
	ldh [hRam_FFB4], a
	ld a, d
	ldh [hRam_FFB5], a
	ld a, b
	or a, c
	jp z, Label_7E_7E37
	ld a, $00
	ldh [hRam_FFB1], a

Label_7E_7D75:: ; 7E:7D75
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Label_7E_7E37
	ldh [hRam_FFB0], a
	push hl
	ldh a, [hRam_FFB1]
	add a, a
	add a, $8F
	ld l, a
	ld a, $7D
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $7D8F-$7D99 (10 bytes) [PROBABLE] 5-entry jump table (7D99, 7DB0, 7DE5, 7E05, 7E1E) of the executed dispatcher at 7E:7D7B-7D8E (ldh a,[$FFB1] ; add a,a ; add a,$8F ; ... ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl); entry 0 is CONFIRMED read data, entries 1-4 are the starts of the handlers 7DB0/7DE5/7E05/7E1E (each begins with pop hl)

Charset_Iso2022JpStates:: ; 7E:7D8F
Table_7E_7D8F::
	dw $7D99, $7DB0, $7DE5, $7E05, $7E1E

; ---- code $7D99-$7DAA (17 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $1B
	jr z, Label_7E_7DAA
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7E37
	jr Label_7E_7D75

; ---- code $7DAA-$7DB0 (6 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 7E:7D9E (executed) [upgraded PROBABLE->CONFIRMED by the classify_g1 pass: every instruction start of the region appears in analysis/coverage_union.tsv]

Label_7E_7DAA:: ; 7E:7DAA
	ld a, $02
	ldh [hRam_FFB1], a
	jr Label_7E_7D75

; ---- code $7DB0-$7DDF (47 bytes) [CONFIRMED] handler 7DB0 (entry 1 of the jump table 7E:7D8F, each handler starts with pop hl); 7DB0-7DDF decodes to jp/jr targets on instruction starts, ends with jr $7D75 [executed in 6 scenarios]
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $1B
	jr z, Label_7E_7DAA
	push bc
	push de
	ld a, [hli]
	ld c, a
	ldh a, [hRam_FFB0]
	ld b, a
	call Charset_JisToSjis
	ld a, c
	ldh [hRam_FFB2], a
	ld a, b
	ldh [hRam_FFB3], a
	pop de
	pop bc
	ldh a, [hRam_FFB3]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7E37
	ldh a, [hRam_FFB2]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7E37
	jr Label_7E_7D75

; ---- code $7DDF-$7DE5 (6 bytes) [HYPOTHESIS] ld a,2 ; ldh [$FFB1],a ; jr $7D75 (same body as the executed 7E:7DAA): no decoded branch, table word or call targets 7DDF (checked by the verifier), it follows the unconditional jr $7D75 at 7DDD, so its entry is unproven
	ld a, $02
	ldh [hRam_FFB1], a
	jr Label_7E_7D75

; ---- code $7DE5-$7DF0 (11 bytes) [CONFIRMED] handlers 7DE5, 7E05, 7E1E (entries 2-4 of the jump table 7E:7D8F: words 7DE5/7E05/7E1E, each starts with pop hl; verified instruction starts); 19 direct targets of the whole 7DB0-7E37 block land on instruction starts (7D75, 7DAA, 7E37, ...), decoding ends with jp $7D75 exactly at the executed code 7E37 | 6 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split [executed in 12 scenarios]
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $28
	jr z, Label_7E_7DF7
	cp a, $24
	jr z, Label_7E_7DFE

; ---- code $7DF0-$7DF7 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

; ---- code $7DF7-$7E10 (25 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split [executed in 12 scenarios]

Label_7E_7DF7:: ; 7E:7DF7
	ld a, $03
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

Label_7E_7DFE:: ; 7E:7DFE
	ld a, $04
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

	pop hl
	ldh a, [hRam_FFB0]
	cp a, $4A
	jr z, Label_7E_7E17
	cp a, $42
	jr z, Label_7E_7E17

; ---- code $7E10-$7E17 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

; ---- code $7E17-$7E29 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split [executed in 12 scenarios]

Label_7E_7E17:: ; 7E:7E17
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

	pop hl
	ldh a, [hRam_FFB0]
	cp a, $4A
	jr z, Label_7E_7E30
	cp a, $42
	jr z, Label_7E_7E30

; ---- code $7E29-$7E30 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

; ---- code $7E30-$7E37 (7 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage --split [executed in 12 scenarios]

Label_7E_7E30:: ; 7E:7E30
	ld a, $01
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

; ---- code $7E37-$7E3D (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_7E_7E37:: ; 7E:7E37
	ld a, [wRam_C282]
	or a, a
	jr nz, Label_7E_7E4C

; ---- code $7E3D-$7E4C (15 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 7E:7E3B (executed) [upgraded PROBABLE->CONFIRMED by the classify_g1 pass: every instruction start of the region appears in analysis/coverage_union.tsv]
	ldh a, [hRam_FFB4]
	ld c, a
	ldh a, [hRam_FFB5]
	ld b, a
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, b
	ld d, a
	ld c, e
	ld b, d
	ret

; ---- code $7E4C-$7E68 (28 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)

Label_7E_7E4C:: ; 7E:7E4C
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ldh a, [hRam_FFB4]
	ld c, a
	ldh a, [hRam_FFB5]
	ld b, a
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, b
	ld d, a
	ld c, e
	ld b, d
	ld a, c
	ld [sSram_B000], a
	ld a, b
	ld [sSram_B001], a
	ret

; ---- code $7E68-$7E74 (12 bytes) [CONFIRMED] 49 insn(s) reached by static flow only; seeds: exec x49; min discovery hops 2; entered by call from 7E:7D56 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage --split [executed in 1 scenarios]

Charset_EucJpToSjisStream:: ; 7E:7E68
	ld a, [hli]
	or a, a
	jr z, Label_7E_7EAA
	cp a, $FF
	jr z, Label_7E_7E76
	cp a, $A1
	jr c, Label_7E_7E76

; ---- code $7E74-$7E76 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage --split
	jr Label_7E_7E80

; ---- code $7E76-$7E80 (10 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage --split [executed in 1 scenarios]

Label_7E_7E76:: ; 7E:7E76
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7EAA
	jr Charset_EucJpToSjisStream

; ---- code $7E80-$7EAA (42 bytes) [PROBABLE] 29 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage --split

Label_7E_7E80:: ; 7E:7E80
	ldh [hRam_FFB0], a
	push bc
	push de
	ld a, [hli]
	ld c, a
	ldh a, [hRam_FFB0]
	ld b, a
	call Charset_EucJpToSjis
	ld a, c
	ldh [hRam_FFB2], a
	ld a, b
	ldh [hRam_FFB3], a
	pop de
	pop bc
	ldh a, [hRam_FFB3]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7EAA
	ldh a, [hRam_FFB2]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7EAA
	jr Charset_EucJpToSjisStream

; ---- code $7EAA-$7EB3 (9 bytes) [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage --split [executed in 1 scenarios]

Label_7E_7EAA:: ; 7E:7EAA
	ld a, [sSram_B000]
	ld c, a
	ld a, [sSram_B001]
	ld b, a
	ret
