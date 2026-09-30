; engine/text/glyph.asm
; bank 7F, $4000-$41EA (490 bytes); pinned by layout.link
; glyph fetch (ASCII/wide), Shift-JIS to JIS to ku/ten, font row tables

SECTION "engine/text/glyph", ROMX

Glyph_LoadAsciiSinglePlane:: ; 7F:4000
Function_7F_4000::
	; [HYPOTHESIS] complete 3-insn function (call $400E ; call $0DCE ; ret): twin of the executed
	; 7F:4007 (call $400E ; call $0DB9 ; ret); both callees are proven (400E executed 12/18; 00:0DCE
	; = the non-duplicating variant of 00:0DB9); no caller/pointer to 7F:4000 found in the ROM
	; (whole-ROM search of far calls, ld r16, words), entry unproven [verifier: downgraded
	; PROBABLE->HYPOTHESIS: complete-looking function with no caller, no table entry and no flow
	; from/into proven code; "decodes cleanly" is not an entry]
	call Glyph_AsciiAddr
	call Glyph_CopyAsciiRowsSingle
	ret

Glyph_LoadAscii:: ; 7F:4007
Function_7F_4007::
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	call Glyph_AsciiAddr
	call Glyph_CopyAsciiRowsDoubled
	ret

Glyph_AsciiAddr:: ; 7F:400E
	ld a, b
	cp a, $20
	jr c, .l4019
	cp a, $80
	jr nc, .l4019
	jr .l401B

.l4019 ; 7F:4019
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 7F:4011 (executed)
	ld a, $3F

.l401B ; 7F:401B
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 12/18 scenarios)
	sub a, $20
	push de
	ld e, $0C
	push af
	push de
	ld d, $00
	ld hl, $0000
	ld b, $08
.loop ; 7F:4029
	rrca
	jr nc, .skip
	add hl, de
.skip ; 7F:402D
	sla e
	rl d
	dec b
	jr nz, .loop
	pop de
	pop af
	ld de, $67A8
	add hl, de
	ld d, h
	ld e, l
	pop hl
	ld a, $76
	ld c, $7F
	ret

Glyph_LoadWideSinglePlane:: ; 7F:4042
Function_7F_4042::
	; [PROBABLE] head of the function that contains the validated far-call site at 404C: push bc ;
	; ld b,d ; ld c,e ; ld hl,$000C ; add hl,de ; ld d,h ; ld e,l ; pop hl (argument set-up),
	; starting right after the ret at 4041 of the executed glyph routine; no caller found, entry
	; unproven
	push bc
	ld b, d
	ld c, e
	ld hl, $000C
	add hl, de
	ld d, h
	ld e, l
	pop hl

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Font_ValidateSjisCode
	call Glyph_SjisToJis
	call Glyph_JisToKuTen
	call Glyph_KuTenAddr
	call Glyph_UnpackWideHalves
	ret

Glyph_LoadWide:: ; 7F:405F
Function_7F_405F::
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 13/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Font_ValidateSjisCode
	call Glyph_SjisToJis
	call Glyph_JisToKuTen
	call Glyph_KuTenAddr
	call Glyph_UnpackWideHalvesDoubled
	ret

Glyph_SjisToJis:: ; 7F:4072
	push bc
	ld a, l
	cp a, $9F
	jr c, .l407C
	ld b, $00
	jr .l407E
.l407C ; 7F:407C
	ld b, $01
.l407E ; 7F:407E
	ld a, h
	cp a, $A0
	jr c, .l4087

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 7F:4081 (executed)
	ld c, $B0
	jr .l4089

.l4087 ; 7F:4087
	; [CONFIRMED] 82 insn(s); 82 executed (in up to 13/18 scenarios)
	ld c, $70
.l4089 ; 7F:4089
	ld a, b
	cp a, $00
	jr nz, .l4094
	ld a, $7E
	ldh [hRam_FFB0], a
	jr .l40A3
.l4094 ; 7F:4094
	ld a, l
	cp a, $80
	jr nc, .l409F
	ld a, $1F
	ldh [hRam_FFB0], a
	jr .l40A3
.l409F ; 7F:409F
	ld a, $20
	ldh [hRam_FFB0], a
.l40A3 ; 7F:40A3
	ld a, h
	sub a, c
	add a, a
	sub a, b
	ld h, a
	ldh a, [hRam_FFB0]
	ld b, a
	ld a, l
	sub a, b
	ld l, a
	pop bc
	ret

Glyph_JisToKuTen:: ; 7F:40B0
	ld a, h
	sub a, $20
	ld h, a
	ld a, l
	sub a, $20
	ld l, a
	ret

Glyph_KuTenAddr:: ; 7F:40B9
	push bc
	push de
	ld b, h
	ld c, l
	ld hl, GlyphFont_RowBankTable
	ld a, b
	dec a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	push af
	ld hl, GlyphFont_RowFirstTable
	ld a, b
	dec a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, b
	ld b, [hl]
	sub a, b
	ld e, a
	push bc
	xor a, a
	ld d, a
	ld bc, $005E
	call Glyph_Mul16
	pop bc
	dec c
	xor a, a
	ld b, a
	add hl, bc
	ld d, h
	ld e, l
	ld bc, $0012
	call Glyph_Mul16
	ld bc, $4000
	add hl, bc
	ld d, h
	ld e, l
	pop af
	pop bc
	pop hl
	ret

; ---- data $40F9-$4150 (87 bytes) [PROBABLE] font_row_bank_table: 87 bytes: ROM bank holding JIS row r (index r-1), read at 7F:40C0-40C8 (ld hl,$40F9 ; a=row-1 ; add a,l) (verified structure, layout from engine code)

GlyphFont_RowBankTable:: ; 7F:40F9
Data_7F_40F9::
	db $7E, $7E, $7E, $7E, $7E, $7E, $7E, $7E, $FF, $FF, $FF, $FF, $7E, $FF, $FF, $7D
	db $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7C, $7C, $7C, $7C, $7C, $7C, $7C, $7C
	db $7C, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7B, $7A, $7A, $7A, $7A, $7A, $7A
	db $7A, $7A, $7A, $79, $79, $79, $79, $79, $79, $79, $79, $79, $78, $78, $78, $78
	db $78, $78, $78, $78, $78, $77, $77, $77, $77, $77, $77, $77, $77, $77, $76, $76
	db $76, $76, $76, $76, $76, $76, $76

; ---- data $4150-$41A7 (87 bytes) [PROBABLE] font_row_first_table: 87 bytes: first JIS row stored in the bank of row r, read at 7F:40CA-40D6 (ld hl,$4150) (verified structure, layout from engine code)

GlyphFont_RowFirstTable:: ; 7F:4150
Data_7F_4150::
	db $01, $01, $01, $01, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $05, $FF, $FF, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $19, $19, $19, $19, $19, $19, $19, $19
	db $19, $22, $22, $22, $22, $22, $22, $22, $22, $22, $2B, $2B, $2B, $2B, $2B, $2B
	db $2B, $2B, $2B, $34, $34, $34, $34, $34, $34, $34, $34, $34, $3D, $3D, $3D, $3D
	db $3D, $3D, $3D, $3D, $3D, $46, $46, $46, $46, $46, $46, $46, $46, $46, $4F, $4F
	db $4F, $4F, $4F, $4F, $4F, $4F, $4F

Glyph_IsSjisLeadByte:: ; 7F:41A7
Function_7F_41A7::
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ld d, a
	ld b, a
	sub a, $81
	jr c, .l41C5
	cp a, $1F
	jr c, .l41CA

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 7F:41B1 (executed)
	ld a, b
	sub a, $E0
	jr c, .l41C5
	cp a, $10
	jr c, .l41CA
	ld a, b
	sub a, $F8
	jr c, .l41C5
	cp a, $02
	jr c, .l41CA

.l41C5 ; 7F:41C5
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios) (part of region $41C5-$4202)
	xor a, a
	scf
	ccf
	jr .l41CD
.l41CA ; 7F:41CA
	scf
	ld a, $01
.l41CD ; 7F:41CD
	pop de
	pop bc
	ret

Glyph_Mul16:: ; 7F:41D0
	push af
	push bc
	push de
	ld hl, $0000
	ld a, $10
.loop ; 7F:41D8
	srl b
	rr c
	jr nc, .skip
	add hl, de
.skip ; 7F:41DF
	sla e
	rl d
	dec a
	jr nz, .loop
	pop de
	pop bc
	pop af
	ret
