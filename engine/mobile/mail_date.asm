; engine/mobile/mail_date.asm
; bank 54, $5168-$5386 (542 bytes); pinned by layout.link
; mail date parsing with month/day tables

SECTION "engine/mobile/mail_date", ROMX

Mail_ParseDate:: ; 54:5168
	; [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 12;
	; entered by call from 54:49A2 (PROBABLE code) | 79 insn(s) executed; cut out of the PROBABLE
	; region 511D-5343 by apply_coverage --split [executed in 3 scenarios] (part of region
	; $511D-$51B9)
	ld hl, wRam_C480
	add hl, bc
	xor a, a
	ld [hl], a
	ld hl, wRam_C580
	ld bc, $0600
	xor a, a
.l5175 ; 54:5175
	ld [hli], a
	dec b
	jr nz, .l5175
	ld hl, wRam_C480
	call Mail_SkipToDigit
	call Mail_CountDigits
	ld a, $01
	cp a, b
	jr z, .l518D
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
.l518D ; 54:518D
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C583], a
	call Mail_SkipSpaces
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
.l51A9 ; 54:51A9
	inc e
	ld a, [hli]
	or a, a
	jr z, .l51CA
	cp a, b
	jr z, .l51B5
	inc hl
	inc hl
	jr .l51A9
.l51B5 ; 54:51B5
	ld a, [hli]
	cp a, c
	jr z, .l51BC

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 511D-5343 by apply_coverage --split
	inc hl
	jr .l51A9

.l51BC ; 54:51BC
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, [hli]
	cp a, d
	jr nz, .l51A9
	ld d, $00
	ld hl, Table_Mail_MonthBcd
	add hl, de
	ld a, [hl]
	ld [wRam_C582], a
.l51CA ; 54:51CA
	pop hl
	call Mail_SkipToDigit
	call Mail_CountDigits
	ld a, $02
	cp a, b
	jr z, .l51EE
	ld a, $04
	cp a, b
	jr z, .l51E1

.l51DB ; 54:51DB
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 511D-5343 by apply_coverage --split
	inc hl
	dec b
	jr z, .l51DB
	jr .l51FB

.l51E1 ; 54:51E1
	; [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C580], a
.l51EE ; 54:51EE
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C581], a
.l51FB ; 54:51FB
	call Mail_SkipToDigit
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C584], a
	call Mail_SkipToDigit
	ld a, [hli]
	and a, $0F
	swap a
	ld c, a
	ld a, [hli]
	and a, $0F
	or a, c
	ld [wRam_C585], a
	call Mail_ApplyTimezoneOffset
	ret

Mail_SkipToDigit:: ; 54:521F
Function_54_521F::
	ld a, [hli]
	cp a, $30
	jr c, Mail_SkipToDigit
	cp a, $3A
	jr nc, Mail_SkipToDigit
	dec hl
	ret

Mail_SkipSpaces:: ; 54:522A
Function_54_522A::
	ld a, [hli]
	cp a, $20
	jr z, Mail_SkipSpaces
	dec hl
	ret

Mail_CountDigits:: ; 54:5231
Function_54_5231::
	push hl
	ld b, $FF
.loop ; 54:5234
	inc b
	ld a, [hli]
	cp a, $30
	jr c, .l523E
	cp a, $3A
	jr c, .loop
.l523E ; 54:523E
	pop hl
	ret

Mail_ApplyTimezoneOffset:: ; 54:5240
Function_54_5240::
	inc hl
	inc hl
	inc hl
	call Mail_SkipSpaces
	ld a, [hli]
	cp a, $2B
	jr z, .l524E

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 511D-5343 by apply_coverage --split
	cp a, $2D
	ret nz

.l524E ; 54:524E
	; [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage
	; --split [executed in 12 scenarios]
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
	jp z, .l532E
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
.l5287 ; 54:5287
	ld a, [wRam_C584]
	add a, $09
	daa
	ld b, a
	ld [wRam_C584], a
	cp a, $24
	ret c

	; [PROBABLE] 98 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 511D-5343 by apply_coverage --split
	cp a, $48
	jr nc, .l52E6
	sub a, $24
	daa
	ld [wRam_C584], a
	ld hl, wRam_C583
	ld a, [hl]
	ld c, a
	add a, $01
	daa
	ld [hl], a
	ld a, [wRam_C582]
	cp a, $02
	jr z, .l52DA
	ld e, a
	ld d, $00
	ld hl, $5373
	add hl, de
	ld a, [hl]
.l52B6 ; 54:52B6
	cp a, c
	ret nz
	ld a, $01
	ld [wRam_C583], a
	ld a, [wRam_C582]
	add a, $01
	daa
	cp a, $13
	jr nz, .l52D6
	ld hl, wRam_C581
	ld a, [hl]
	add a, $01
	daa
	ld [hld], a
	ld a, [hl]
	adc a, $00
	daa
	ld [hl], a
	ld a, $01
.l52D6 ; 54:52D6
	ld [wRam_C582], a
	ret
.l52DA ; 54:52DA
	ld a, [wRam_C581]
	and a, $03
	ld a, $1C
	jr nz, .l52B6
	inc a
	jr .l52B6
.l52E6 ; 54:52E6
	add a, $24
	daa
	ld [wRam_C584], a
	ld hl, wRam_C583
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
	jr nz, .l530F
	ld hl, wRam_C581
	ld a, [hl]
	sub a, $01
	daa
	ld [hld], a
	ld a, [hl]
	sbc a, $00
	daa
	ld [hl], a
	ld a, $12
.l530F ; 54:530F
	ld [wRam_C582], a
	cp a, $02
	jr z, .l5322
	ld e, a
	ld d, $00
	ld hl, $5373
	add hl, de
	ld a, [hl]
.l531E ; 54:531E
	ld [wRam_C583], a
	ret
.l5322 ; 54:5322
	ld a, [wRam_C581]
	and a, $03
	ld a, $1C
	jr nz, .l531E
	inc a
	jr .l531E
.l532E ; 54:532E
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
	jp .l5287

; ---- text $5343-$5368 (37 bytes) [PROBABLE] ASCII month abbreviations "jan" "feb" ... "dec" (12 x 3) + NUL; walked by 54:51A6 (ld hl,$5343 ; inc e ; ld a,[hli] ; or a ; jr z ...) to turn a 3-letter month into an index

PUSHC sjis
String_Mail_Months:: ; 54:5343
String_54_5343::
	db "janfebmaraprmayjunjulaugsepoctnovdec", 0
POPC

; ---- data $5368-$5374 (12 bytes) [PROBABLE] 12 BCD month numbers 01..09,10,11,12 (byte-exact); indexed by the month index at 54:51C2 (ld hl,$5368 ; add hl,de ; ld a,[hl] ; ld [$C582],a)

Table_Mail_MonthBcd:: ; 54:5368
Table_54_5368::
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $10, $11, $12

; ---- data $5374-$5386 (18 bytes) [PROBABLE] days per month in BCD: 31 28 31 30 31 30 31 31 30, 6 zero bytes, 31 30 31 - indexed by the BCD month number from base $5373 (54:52B1 and 54:5319: ld hl,$5373 ; add hl,de) so BCD 10/11/12 land on the last three entries

Table_Mail_DaysPerMonth:: ; 54:5374
Table_54_5374::
	db $31, $28, $31, $30, $31, $30, $31, $31, $30, $00, $00, $00, $00, $00, $00, $31
	db $30, $31
