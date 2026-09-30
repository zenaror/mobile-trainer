; home/string.asm
; bank 00, $14BF-$153D (126 bytes); pinned by layout.link
; CopyString, CompareString, StringLength, XOR-$A5 coders

SECTION "home/string", ROM0

; ---- code $14BF-$14C6 (7 bytes) [CONFIRMED] copy [HL++] to [DE++] up to and including the $00 terminator [reached via inferred links; raw refs 33] [executed in 32 scenarios]

CopyString:: ; 00:14BF
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jr nz, CopyString
	ret

; ---- code $14C6-$14D1 (11 bytes) [CONFIRMED] copy at most BC bytes, stop after the terminator [reached via inferred links; raw refs 6] [executed in 6 scenarios]

CopyStringMax:: ; 00:14C6
	ld a, c
	or a, b
	ret z
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, CopyStringMax
	ret

; ---- code $14D1-$14DD (12 bytes) [CONFIRMED] like 14C6; when BC==0 writes a $00 at [HL] (source pointer) [reached via inferred links; raw refs 4] | 10 insn(s) executed; cut out of the PROBABLE region 14D1-14E0 by apply_coverage --split [executed in 2 scenarios]

Function_00_14D1:: ; 00:14D1
	ld a, c
	or a, b
	jr z, Label_00_14DD
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, CopyStringMax
	ret

; ---- code $14DD-$14E0 (3 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 14D1-14E0 by apply_coverage --split

Label_00_14DD:: ; 00:14DD
	xor a, a
	ld [hl], a
	ret

; ---- code $14E0-$14EA (10 bytes) [CONFIRMED] copy [HL++] to [DE++] XOR $A5 until the source byte is $00 (terminator is stored as $A5) [candidate; raw refs 6] [executed in 8 scenarios]

EncodeXorA5:: ; 00:14E0
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	xor a, $A5
	jr nz, EncodeXorA5
	ret

; ---- code $14EA-$14F3 (9 bytes) [CONFIRMED] copy [HL++] XOR $A5 to [DE++] until the decoded byte is $00 (inverse of EncodeXorA5) [reached via inferred links; raw refs 23] [executed in 11 scenarios]

DecodeXorA5:: ; 00:14EA
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	or a, a
	jr nz, DecodeXorA5
	ret

; ---- code $14F3-$1509 (22 bytes) [CONFIRMED] string append: finds the first byte equal to A in the string at DE and copies the string at HL there (A=0: strcat) [reached via inferred links; raw refs 19] [executed in 10 scenarios]

Function_00_14F3:: ; 00:14F3
	push hl
	ld h, d
	ld l, e
	pop de

Label_00_14F7:: ; 00:14F7
	cp a, [hl]
	inc hl
	jr nz, Label_00_14F7
	dec hl
	push hl
	ld h, d
	ld l, e
	pop de

Label_00_1500:: ; 00:1500
	ld a, [hli]
	ld b, a
	ld [de], a
	inc de
	ld a, b
	or a, a
	jr nz, Label_00_1500
	ret

; ---- code $1509-$151A (17 bytes) [CONFIRMED] strcmp(HL, DE): A = [HL]-[DE] at the first difference (0 only if both strings end together); verified on interpreter [reached via inferred links; raw refs 11] [executed in 14 scenarios]

CompareString:: ; 00:1509
	push hl
	ld h, d
	ld l, e
	pop de
	dec de
	dec hl

Label_00_150F:: ; 00:150F
	inc de
	inc hl
	ld a, [de]
	or a, a
	jr z, Label_00_1518
	cp a, [hl]
	jr z, Label_00_150F

Label_00_1518:: ; 00:1518
	sub a, [hl]
	ret

; ---- code $151A-$1533 (25 bytes) [CONFIRMED] like CompareString but compares at most B bytes (A = [HL]-[DE]); verified on interpreter [candidate; raw refs 2] [executed in 34 scenarios]

CompareStringN:: ; 00:151A
	ld a, b
	and a, a
	jr z, Label_00_1532

Label_00_151E:: ; 00:151E
	dec b
	jr z, Label_00_152E
	ld a, [hl]
	or a, a
	jr z, Label_00_152E
	ld c, a
	ld a, [de]
	cp a, c
	jr nz, Label_00_152E
	inc hl
	inc de
	jr Label_00_151E

Label_00_152E:: ; 00:152E
	ld a, [de]
	ld c, a
	ld a, [hl]
	sub a, c

Label_00_1532:: ; 00:1532
	ret

; ---- code $1533-$153D (10 bytes) [CONFIRMED] BC = length of the $00-terminated string at HL [reached via inferred links; raw refs 5] [executed in 7 scenarios]

StringLength:: ; 00:1533
	xor a, a
	ld bc, $FFFF

Label_00_1537:: ; 00:1537
	cp a, [hl]
	inc hl
	inc bc
	jr nz, Label_00_1537
	ret
