; home/string.asm
; bank 00, $14BF-$153D (126 bytes); pinned by layout.link
; CopyString, CompareString, StringLength, XOR-$A5 coders

SECTION "home/string", ROM0

CopyString:: ; 00:14BF
	; [CONFIRMED] copy [HL++] to [DE++] up to and including the $00 terminator [reached via inferred
	; links; raw refs 33] [executed in 32 scenarios]
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jr nz, CopyString
	ret

CopyStringMax:: ; 00:14C6
	; [CONFIRMED] copy at most BC bytes, stop after the terminator [reached via inferred links; raw
	; refs 6] [executed in 6 scenarios]
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

Function_00_14D1:: ; 00:14D1
	; [CONFIRMED] like 14C6; when BC==0 writes a $00 at [HL] (source pointer) [reached via inferred
	; links; raw refs 4] | 10 insn(s) executed; cut out of the PROBABLE region 14D1-14E0 by
	; apply_coverage --split [executed in 2 scenarios]
	ld a, c
	or a, b
	jr z, .l14DD
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	or a, a
	jr nz, CopyStringMax
	ret

.l14DD ; 00:14DD
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 14D1-14E0 by apply_coverage --split
	xor a, a
	ld [hl], a
	ret

EncodeXorA5:: ; 00:14E0
	; [CONFIRMED] copy [HL++] to [DE++] XOR $A5 until the source byte is $00 (terminator is stored
	; as $A5) [candidate; raw refs 6] [executed in 8 scenarios]
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	xor a, $A5
	jr nz, EncodeXorA5
	ret

DecodeXorA5:: ; 00:14EA
	; [CONFIRMED] copy [HL++] XOR $A5 to [DE++] until the decoded byte is $00 (inverse of
	; EncodeXorA5) [reached via inferred links; raw refs 23] [executed in 11 scenarios]
	ld a, [hli]
	xor a, $A5
	ld [de], a
	inc de
	or a, a
	jr nz, DecodeXorA5
	ret

StringAppend:: ; 00:14F3
Function_00_14F3::
	; [CONFIRMED] string append: finds the first byte equal to A in the string at DE and copies the
	; string at HL there (A=0: strcat) [reached via inferred links; raw refs 19] [executed in 10
	; scenarios]
	push hl
	ld h, d
	ld l, e
	pop de
.l14F7 ; 00:14F7
	cp a, [hl]
	inc hl
	jr nz, .l14F7
	dec hl
	push hl
	ld h, d
	ld l, e
	pop de
.l1500 ; 00:1500
	ld a, [hli]
	ld b, a
	ld [de], a
	inc de
	ld a, b
	or a, a
	jr nz, .l1500
	ret

CompareString:: ; 00:1509
	; [CONFIRMED] strcmp(HL, DE): A = [HL]-[DE] at the first difference (0 only if both strings end
	; together); verified on interpreter [reached via inferred links; raw refs 11] [executed in 14
	; scenarios]
	push hl
	ld h, d
	ld l, e
	pop de
	dec de
	dec hl
.loop ; 00:150F
	inc de
	inc hl
	ld a, [de]
	or a, a
	jr z, .l1518
	cp a, [hl]
	jr z, .loop
.l1518 ; 00:1518
	sub a, [hl]
	ret

CompareStringN:: ; 00:151A
	; [CONFIRMED] like CompareString but compares at most B bytes (A = [HL]-[DE]); verified on
	; interpreter [candidate; raw refs 2] [executed in 34 scenarios]
	ld a, b
	and a, a
	jr z, .done
.loop ; 00:151E
	dec b
	jr z, .l152E
	ld a, [hl]
	or a, a
	jr z, .l152E
	ld c, a
	ld a, [de]
	cp a, c
	jr nz, .l152E
	inc hl
	inc de
	jr .loop
.l152E ; 00:152E
	ld a, [de]
	ld c, a
	ld a, [hl]
	sub a, c
.done ; 00:1532
	ret

StringLength:: ; 00:1533
	; [CONFIRMED] BC = length of the $00-terminated string at HL [reached via inferred links; raw
	; refs 5] [executed in 7 scenarios]
	xor a, a
	ld bc, $FFFF
.loop ; 00:1537
	cp a, [hl]
	inc hl
	inc bc
	jr nz, .loop
	ret
