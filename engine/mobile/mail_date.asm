; engine/mobile/mail_date.asm
; bank 54, $5168-$5386 (542 bytes); pinned by layout.link
; mail date parsing with month/day tables

SECTION "engine/mobile/mail_date", ROMX

; ---- code $5168-$51B9 (81 bytes) [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 12; entered by call from 54:49A2 (PROBABLE code) | 79 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage --split [executed in 3 scenarios] (part of region $511D-$51B9)

Mail_ParseDate:: ; 54:5168
	ld hl, $C480
	add hl, bc
	xor a, a
	ld [hl], a
	ld hl, $C580
	ld bc, $0600
	xor a, a

Label_54_5175:: ; 54:5175
	ld [hli], a
	dec b
	jr nz, Label_54_5175
	ld hl, $C480
	call Function_54_521F
	call Function_54_5231
	ld a, $01
	cp a, b
	jr z, Label_54_518D
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a

Label_54_518D:: ; 54:518D
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C583], a
	call Function_54_522A
	ld a, [hli]
	or a, $20
	ld b, a
	ld a, [hli]
	or a, $20
	ld c, a
	ld a, [hli]
	or a, $20
	ld d, a
	push hl
	ld e, $FF
	ld hl, String_Mail_Months

Label_54_51A9:: ; 54:51A9
	inc e
	ld a, [hli]
	or a, a
	jr z, Label_54_51CA
	cp a, b
	jr z, Label_54_51B5
	inc hl
	inc hl
	jr Label_54_51A9

Label_54_51B5:: ; 54:51B5
	ld a, [hli]
	cp a, c
	jr z, Label_54_51BC

; ---- code $51B9-$51BC (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 511D-5343 by apply_coverage --split
	inc hl
	jr Label_54_51A9

; ---- code $51BC-$51DB (31 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage --split [executed in 12 scenarios]

Label_54_51BC:: ; 54:51BC
	ld a, [hli]
	cp a, d
	jr nz, Label_54_51A9
	ld d, $00
	ld hl, Table_Mail_MonthBcd
	add hl, de
	ld a, [hl]
	ld [wRam_C582], a

Label_54_51CA:: ; 54:51CA
	pop hl
	call Function_54_521F
	call Function_54_5231
	ld a, $02
	cp a, b
	jr z, Label_54_51EE
	ld a, $04
	cp a, b
	jr z, Label_54_51E1

; ---- code $51DB-$51E1 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 511D-5343 by apply_coverage --split

Label_54_51DB:: ; 54:51DB
	inc hl
	dec b
	jr z, Label_54_51DB
	jr Label_54_51FB

; ---- code $51E1-$524B (106 bytes) [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage --split [executed in 12 scenarios]

Label_54_51E1:: ; 54:51E1
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C580], a

Label_54_51EE:: ; 54:51EE
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C581], a

Label_54_51FB:: ; 54:51FB
	call Function_54_521F
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C584], a
	call Function_54_521F
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C585], a
	call Function_54_5240
	ret

Function_54_521F:: ; 54:521F
	ld a, [hli]
	cp a, $30
	jr c, Function_54_521F
	cp a, $3A
	jr nc, Function_54_521F
	dec hl
	ret

Function_54_522A:: ; 54:522A
	ld a, [hli]
	cp a, $20
	jr z, Function_54_522A
	dec hl
	ret

Function_54_5231:: ; 54:5231
	push hl
	ld b, $FF

Label_54_5234:: ; 54:5234
	inc b
	ld a, [hli]
	cp a, $30
	jr c, Label_54_523E
	cp a, $3A
	jr c, Label_54_5234

Label_54_523E:: ; 54:523E
	pop hl
	ret

Function_54_5240:: ; 54:5240
	inc hl
	inc hl
	inc hl
	call Function_54_522A
	ld a, [hli]
	cp a, $2B
	jr z, Label_54_524E

; ---- code $524B-$524E (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 511D-5343 by apply_coverage --split
	cp a, $2D
	ret nz

; ---- code $524E-$5294 (70 bytes) [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage --split [executed in 12 scenarios]

Label_54_524E:: ; 54:524E
	ld [wRam_C590], a
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C591], a
	ld b, a
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C592], a
	ld c, a
	ld a, [wRam_C590]
	cp a, $2D
	jp z, Label_54_532E
	ld a, [wRam_C585]
	sub a, c
	daa
	ld c, a
	ld [wRam_C585], a
	ld a, [wRam_C584]
	sbc a, b
	daa
	ld b, a
	ld [wRam_C584], a

Label_54_5287:: ; 54:5287
	ld a, [wRam_C584]
	add a, $09
	daa
	ld b, a
	ld [wRam_C584], a
	cp a, $24
	ret c

; ---- code $5294-$5343 (175 bytes) [PROBABLE] 98 insn(s) never executed in the traced runs; cut out of the PROBABLE region 511D-5343 by apply_coverage --split
	cp a, $48
	jr nc, Label_54_52E6
	sub a, $24
	daa
	ld [wRam_C584], a
	ld hl, $C583
	ld a, [hl]
	ld c, a
	add a, $01
	daa
	ld [hl], a
	ld a, [wRam_C582]
	cp a, $02
	jr z, Label_54_52DA
	ld e, a
	ld d, $00
	ld hl, $5373
	add hl, de
	ld a, [hl]

Label_54_52B6:: ; 54:52B6
	cp a, c
	ret nz
	ld a, $01
	ld [wRam_C583], a
	ld a, [wRam_C582]
	add a, $01
	daa
	cp a, $13
	jr nz, Label_54_52D6
	ld hl, $C581
	ld a, [hl]
	add a, $01
	daa
	ld [hld], a
	ld a, [hl]
	adc a, $00
	daa
	ld [hl], a
	ld a, $01

Label_54_52D6:: ; 54:52D6
	ld [wRam_C582], a
	ret

Label_54_52DA:: ; 54:52DA
	ld a, [wRam_C581]
	and a, $03
	ld a, $1C
	jr nz, Label_54_52B6
	inc a
	jr Label_54_52B6

Label_54_52E6:: ; 54:52E6
	add a, $24
	daa
	ld [wRam_C584], a
	ld hl, $C583
	ld a, [hl]
	sub a, $01
	daa
	ld [hl], a
	or a, a
	ret nz
	ld a, [wRam_C582]
	sub a, $01
	daa
	cp a, $00
	jr nz, Label_54_530F
	ld hl, $C581
	ld a, [hl]
	sub a, $01
	daa
	ld [hld], a
	ld a, [hl]
	sbc a, $00
	daa
	ld [hl], a
	ld a, $12

Label_54_530F:: ; 54:530F
	ld [wRam_C582], a
	cp a, $02
	jr z, Label_54_5322
	ld e, a
	ld d, $00
	ld hl, $5373
	add hl, de
	ld a, [hl]

Label_54_531E:: ; 54:531E
	ld [wRam_C583], a
	ret

Label_54_5322:: ; 54:5322
	ld a, [wRam_C581]
	and a, $03
	ld a, $1C
	jr nz, Label_54_531E
	inc a
	jr Label_54_531E

Label_54_532E:: ; 54:532E
	ld a, [wRam_C585]
	add a, c
	daa
	ld c, a
	ld [wRam_C585], a
	ld a, [wRam_C584]
	adc a, b
	daa
	ld b, a
	ld [wRam_C584], a
	jp Label_54_5287

; ---- text $5343-$5368 (37 bytes) [PROBABLE] ASCII month abbreviations "jan" "feb" ... "dec" (12 x 3) + NUL; walked by 54:51A6 (ld hl,$5343 ; inc e ; ld a,[hli] ; or a ; jr z ...) to turn a 3-letter month into an index

String_Mail_Months:: ; 54:5343
String_54_5343::
	db $6A, $61, $6E, $66, $65, $62, $6D, $61, $72, $61, $70, $72, $6D, $61, $79, $6A, $75, $6E, $6A, $75, $6C, $61, $75, $67, $73, $65, $70, $6F, $63, $74, $6E, $6F, $76, $64 ; "janfebmaraprmayjunjulaugsepoctnovd"
	db $65, $63, $00 ; "ec"

; ---- data $5368-$5374 (12 bytes) [PROBABLE] 12 BCD month numbers 01..09,10,11,12 (byte-exact); indexed by the month index at 54:51C2 (ld hl,$5368 ; add hl,de ; ld a,[hl] ; ld [$C582],a)

Table_Mail_MonthBcd:: ; 54:5368
Table_54_5368::
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12

; ---- data $5374-$5386 (18 bytes) [PROBABLE] days per month in BCD: 31 28 31 30 31 30 31 31 30, 6 zero bytes, 31 30 31 - indexed by the BCD month number from base $5373 (54:52B1 and 54:5319: ld hl,$5373 ; add hl,de) so BCD 10/11/12 land on the last three entries

Table_Mail_DaysPerMonth:: ; 54:5374
Table_54_5374::
	db $31, $28, $31, $30, $31, $30, $31, $31, $30, $00, $00, $00, $00, $00, $00, $31
	db $30, $31
