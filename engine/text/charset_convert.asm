; engine/text/charset_convert.asm
; bank 7E, $7B7C-$7EB3 (823 bytes); pinned by layout.link
; Shift-JIS / ISO-2022-JP / EUC-JP conversion

SECTION "engine/text/charset_convert", ROMX

Charset_JisToSjis:: ; 7E:7B7C
	; [CONFIRMED] 268 insn(s) reached by static flow only; seeds: exec x268; min discovery hops 1;
	; entered by call from 7E:7BDA (PROBABLE code) | 3 insn(s) executed; cut out of the PROBABLE
	; region 7B7C-7D19 by apply_coverage --split [executed in 12 scenarios]
	ld a, b
	cp a, $5F
	jr c, .l7B84

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	add a, $80
	ld b, a

.l7B84 ; 7E:7B84
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 6 scenarios]
	srl a
	jr c, .l7B91
	add a, $70
	ld b, a
	ld a, c
	add a, $7E
	ld c, a
	jr .done
.l7B91 ; 7E:7B91
	ld a, c
	cp a, $60
	jr c, .l7B97
	inc c
.l7B97 ; 7E:7B97
	ld a, c
	add a, $1F
	ld c, a
	srl b
	ld a, b
	add a, $71
	ld b, a
	xor a, a
.done ; 7E:7BA2
	ret

Charset_SjisToJis:: ; 7E:7BA3
	ld b, h
	ld c, l
	ld a, b
	cp a, $80
	jr c, .l7BCF
	cp a, $A0
	jr c, .l7BB4

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	cp a, $E0
	jr c, .l7BCF
	sub a, $40

.l7BB4 ; 7E:7BB4
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 2 scenarios]
	sub a, $70
	ld d, a
	ld a, c
	cp a, $9F
	jr nc, .l7BBD
	dec d
.l7BBD ; 7E:7BBD
	sla d
	cp a, $9F
	jr nc, .l7BCB
	inc d
	cp a, $80
	jr c, .l7BC9

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	dec a

.l7BC9 ; 7E:7BC9
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 2 scenarios]
	add a, $5F
.l7BCB ; 7E:7BCB
	sub a, $7E
	ld b, a
	ld c, d
.l7BCF ; 7E:7BCF
	ld a, b
	ld b, c
	ld c, a
	xor a, a
	ld h, b
	ld l, c
	ret

Charset_EucJpToSjis:: ; 7E:7BD6
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	res 7, b
	res 7, c
	call Charset_JisToSjis
	ret

Charset_DetectEncoding:: ; 7E:7BDE
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 1 scenarios]
	call Charset_ReadByteCounted
	or a, a
	jr z, .l7C27
	cp a, $1B
	jr z, .l7BF2
	cp a, $A1
	jr nc, Charset_DetectEncoding
	cp a, $80
	jr c, Charset_DetectEncoding

	; [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	jr .l7C21
.l7BF2 ; 7E:7BF2
	call Charset_ReadByteCounted
	or a, a
	jr z, .l7C27
	ld d, a
	call Charset_ReadByteCounted
	or a, a
	jr z, .l7C27
	ld e, a
	ld a, d
	cp a, $24
	jr z, .l7C0B
	cp a, $28
	jr z, .l7C16
	jr Charset_DetectEncoding
.l7C0B ; 7E:7C0B
	ld a, e
	cp a, $42
	jr z, .l7C24
	cp a, $40
	jr z, .l7C24
	jr Charset_DetectEncoding
.l7C16 ; 7E:7C16
	ld a, e
	cp a, $4A
	jr z, .l7C24
	cp a, $42
	jr z, .l7C24
	jr Charset_DetectEncoding
.l7C21 ; 7E:7C21
	ld a, $01
	ret
.l7C24 ; 7E:7C24
	ld a, $02
	ret

.l7C27 ; 7E:7C27
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $03
	ret

Charset_ReadByteCounted:: ; 7E:7C2A
	ld a, b
	or a, c
	jp z, .l7C32
	dec bc
	ld a, [hli]
	ret
.l7C32 ; 7E:7C32
	xor a, a
	ret

Charset_SjisToIso2022Jp:: ; 7E:7C34
	ld a, e
	ldh [hRam_FFB3], a
	ld a, d
	ldh [hRam_FFB4], a
	ld a, b
	or a, c
	jp z, .l7D0A
	ld a, $00
	ldh [hRam_FFB0], a
.loop ; 7E:7C43
	ld a, [hli]
	or a, a
	jp z, .l7CE7
	ldh [hRam_FFB1], a
	cp a, $81
	jr c, .l7C62
	cp a, $A0
	jr c, .l7C63

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	cp a, $E0
	jr c, .l7C62
	cp a, $F0
	jr c, .l7C63
	cp a, $F8
	jr c, .l7C62
	cp a, $FA
	jr c, .l7C63

.l7C62 ; 7E:7C62
	; [CONFIRMED] 90 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l7C63 ; 7E:7C63
	jr c, .l7C98
	ldh a, [hRam_FFB0]
	or a, a
	jr z, .l7C8C
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $28
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $00
	ldh [hRam_FFB0], a
.l7C8C ; 7E:7C8C
	ldh a, [hRam_FFB1]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	jr .loop
.l7C98 ; 7E:7C98
	ldh a, [hRam_FFB0]
	or a, a
	jr nz, .l7CBF
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $24
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $01
	ldh [hRam_FFB0], a
.l7CBF ; 7E:7CBF
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
	jr z, .l7CE4
	ld a, l
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jr z, .l7CE4
	pop hl
	jp .loop

.l7CE4 ; 7E:7CE4
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7B7C-7D19 by apply_coverage --split
	pop hl
	jr .l7D0A

.l7CE7 ; 7E:7CE7
	; [CONFIRMED] 37 insn(s) executed; cut out of the PROBABLE region 7B7C-7D19 by apply_coverage
	; --split [executed in 6 scenarios]
	ldh a, [hRam_FFB0]
	or a, a
	jr z, .l7D0A
	ld a, $1B
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $28
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
	ld a, $42
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7D0A
.l7D0A ; 7E:7D0A
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

Charset_ConvertPage:: ; 7E:7D19
Function_7E_7D19::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, b
	or a, a
	jr nz, .l7D26

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 7E:7D1B (executed)
	ld a, c
	cp a, $04
	jr nc, .l7D26
	ld bc, $0000
	ret

.l7D26 ; 7E:7D26
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)
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
	jr nz, .l7D5A

	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0;
	; fall-through of the jrcc at 7E:7D33 (executed) | 19 insn(s) executed; cut out of the PROBABLE
	; region 7D35-7D5A by apply_coverage --split [executed in 1 scenarios]
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
	jr z, .l7D50
	cp a, $02
	jr z, .l7D5A
	cp a, $03
	jr z, .l7D56

.l7D50 ; 7E:7D50
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7D35-7D5A by apply_coverage --split
	dec hl
	dec hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ret

.l7D56 ; 7E:7D56
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 7D35-7D5A by apply_coverage
	; --split [executed in 1 scenarios]
	call Charset_EucJpToSjisStream
	ret

.l7D5A ; 7E:7D5A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, $01
	ld [wRam_C282], a
	jp Label_7E_7D66

Charset_Iso2022JpToSjis:: ; 7E:7D62
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 14;
	; entered by far from 54:4A73 (PROBABLE code) [upgraded PROBABLE->CONFIRMED by the classify_g1
	; pass: every instruction start of the region appears in analysis/coverage_union.tsv]
	xor a, a
	ld [wRam_C282], a

Label_7E_7D66:: ; 7E:7D66
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios)
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
	call Sound_FrameService
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

	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $1B
	jr z, .l7DAA
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, Label_7E_7E37
	jr Label_7E_7D75

.l7DAA ; 7E:7DAA
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 7E:7D9E (executed) [upgraded PROBABLE->CONFIRMED by the classify_g1 pass:
	; every instruction start of the region appears in analysis/coverage_union.tsv]
	ld a, $02
	ldh [hRam_FFB1], a
	jr Label_7E_7D75

	; [CONFIRMED] handler 7DB0 (entry 1 of the jump table 7E:7D8F, each handler starts with pop hl);
	; 7DB0-7DDF decodes to jp/jr targets on instruction starts, ends with jr $7D75 [executed in 6
	; scenarios]
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $1B
	jr z, .l7DAA
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

	; [HYPOTHESIS] ld a,2 ; ldh [$FFB1],a ; jr $7D75 (same body as the executed 7E:7DAA): no decoded
	; branch, table word or call targets 7DDF (checked by the verifier), it follows the
	; unconditional jr $7D75 at 7DDD, so its entry is unproven
	ld a, $02
	ldh [hRam_FFB1], a
	jr Label_7E_7D75

	; [CONFIRMED] handlers 7DE5, 7E05, 7E1E (entries 2-4 of the jump table 7E:7D8F: words
	; 7DE5/7E05/7E1E, each starts with pop hl; verified instruction starts); 19 direct targets of
	; the whole 7DB0-7E37 block land on instruction starts (7D75, 7DAA, 7E37, ...), decoding ends
	; with jp $7D75 exactly at the executed code 7E37 | 6 insn(s) executed; cut out of the PROBABLE
	; region 7DE5-7E37 by apply_coverage --split [executed in 12 scenarios]
	pop hl
	ldh a, [hRam_FFB0]
	cp a, $28
	jr z, .l7DF7
	cp a, $24
	jr z, .l7DFE

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

.l7DF7 ; 7E:7DF7
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, $03
	ldh [hRam_FFB1], a
	jp Label_7E_7D75
.l7DFE ; 7E:7DFE
	ld a, $04
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

	pop hl
	ldh a, [hRam_FFB0]
	cp a, $4A
	jr z, .l7E17
	cp a, $42
	jr z, .l7E17

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

.l7E17 ; 7E:7E17
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

	pop hl
	ldh a, [hRam_FFB0]
	cp a, $4A
	jr z, .l7E30
	cp a, $42
	jr z, .l7E30

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7DE5-7E37 by apply_coverage --split
	ld a, $00
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

.l7E30 ; 7E:7E30
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 7DE5-7E37 by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, $01
	ldh [hRam_FFB1], a
	jp Label_7E_7D75

Label_7E_7E37:: ; 7E:7E37
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wRam_C282]
	or a, a
	jr nz, .l7E4C

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 7E:7E3B (executed) [upgraded PROBABLE->CONFIRMED by the
	; classify_g1 pass: every instruction start of the region appears in
	; analysis/coverage_union.tsv]
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

.l7E4C ; 7E:7E4C
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
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

Charset_EucJpToSjisStream:: ; 7E:7E68
	; [CONFIRMED] 49 insn(s) reached by static flow only; seeds: exec x49; min discovery hops 2;
	; entered by call from 7E:7D56 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE
	; region 7E68-7EB3 by apply_coverage --split [executed in 1 scenarios]
	ld a, [hli]
	or a, a
	jr z, .l7EAA
	cp a, $FF
	jr z, .l7E76
	cp a, $A1
	jr c, .l7E76

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7E68-7EB3 by apply_coverage --split
	jr .l7E80

.l7E76 ; 7E:7E76
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7EAA
	jr Charset_EucJpToSjisStream

.l7E80 ; 7E:7E80
	; [PROBABLE] 29 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 7E68-7EB3 by apply_coverage --split
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
	jp z, .l7EAA
	ldh a, [hRam_FFB2]
	ld [de], a
	inc de
	dec bc
	ld a, c
	or a, b
	jp z, .l7EAA
	jr Charset_EucJpToSjisStream

.l7EAA ; 7E:7EAA
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 7E68-7EB3 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [sSram_B000]
	ld c, a
	ld a, [sSram_B001]
	ld b, a
	ret
