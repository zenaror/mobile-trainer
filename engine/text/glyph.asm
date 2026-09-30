; engine/text/glyph.asm
; bank 7F, $4000-$41EA (490 bytes); pinned by layout.link
; glyph fetch (ASCII/wide), Shift-JIS to JIS to ku/ten, font row tables

SECTION "engine/text/glyph", ROMX

; ---- code $4000-$4007 (7 bytes) [HYPOTHESIS] complete 3-insn function (call $400E ; call $0DCE ; ret): twin of the executed 7F:4007 (call $400E ; call $0DB9 ; ret); both callees are proven (400E executed 12/18; 00:0DCE = the non-duplicating variant of 00:0DB9); no caller/pointer to 7F:4000 found in the ROM (whole-ROM search of far calls, ld r16, words), entry unproven [verifier: downgraded PROBABLE->HYPOTHESIS: complete-looking function with no caller, no table entry and no flow from/into proven code; "decodes cleanly" is not an entry]

Function_7F_4000:: ; 7F:4000
	call Glyph_AsciiAddr
	call Function_00_0DCE
	ret

; ---- code $4007-$4019 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 12/18 scenarios); entry proven: target of an executed call/far call

Glyph_LoadAscii:: ; 7F:4007
Function_7F_4007::
	call Glyph_AsciiAddr
	call Function_00_0DB9
	ret

Glyph_AsciiAddr:: ; 7F:400E
	ld a, b
	cp a, $20
	jr c, Label_7F_4019
	cp a, $80
	jr nc, Label_7F_4019
	jr Label_7F_401B

; ---- code $4019-$401B (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 7F:4011 (executed)

Label_7F_4019:: ; 7F:4019
	ld a, $3F

; ---- code $401B-$4042 (39 bytes) [CONFIRMED] 25 insn(s); 25 executed (in up to 12/18 scenarios)

Label_7F_401B:: ; 7F:401B
	sub a, $20
	push de
	ld e, $0C
	push af
	push de
	ld d, $00
	ld hl, $0000
	ld b, $08

Label_7F_4029:: ; 7F:4029
	rrca
	jr nc, Label_7F_402D
	add hl, de

Label_7F_402D:: ; 7F:402D
	sla e
	rl d
	dec b
	jr nz, Label_7F_4029
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

; ---- code $4042-$404C (10 bytes) [PROBABLE] head of the function that contains the validated far-call site at 404C: push bc ; ld b,d ; ld c,e ; ld hl,$000C ; add hl,de ; ld d,h ; ld e,l ; pop hl (argument set-up), starting right after the ret at 4041 of the executed glyph routine; no caller found, entry unproven

Function_7F_4042:: ; 7F:4042
	push bc
	ld b, d
	ld c, e
	ld hl, $000C
	add hl, de
	ld d, h
	ld e, l
	pop hl

; ---- code $404C-$405F (19 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Font_ValidateSjisCode
	call Glyph_SjisToJis
	call Glyph_JisToKuTen
	call Glyph_KuTenAddr
	call Function_00_0E32
	ret

; ---- code $405F-$4083 (36 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 13/18 scenarios); entry proven: target of an executed call/far call

Glyph_LoadWide:: ; 7F:405F
Function_7F_405F::
	farcall Font_ValidateSjisCode
	call Glyph_SjisToJis
	call Glyph_JisToKuTen
	call Glyph_KuTenAddr
	call Function_00_0DE2
	ret

Glyph_SjisToJis:: ; 7F:4072
	push bc
	ld a, l
	cp a, $9F
	jr c, Label_7F_407C
	ld b, $00
	jr Label_7F_407E

Label_7F_407C:: ; 7F:407C
	ld b, $01

Label_7F_407E:: ; 7F:407E
	ld a, h
	cp a, $A0
	jr c, Label_7F_4087

; ---- code $4083-$4087 (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 7F:4081 (executed)
	ld c, $B0
	jr Label_7F_4089

; ---- code $4087-$40F9 (114 bytes) [CONFIRMED] 82 insn(s); 82 executed (in up to 13/18 scenarios)

Label_7F_4087:: ; 7F:4087
	ld c, $70

Label_7F_4089:: ; 7F:4089
	ld a, b
	cp a, $00
	jr nz, Label_7F_4094
	ld a, $7E
	ldh [hRam_FFB0], a
	jr Label_7F_40A3

Label_7F_4094:: ; 7F:4094
	ld a, l
	cp a, $80
	jr nc, Label_7F_409F
	ld a, $1F
	ldh [hRam_FFB0], a
	jr Label_7F_40A3

Label_7F_409F:: ; 7F:409F
	ld a, $20
	ldh [hRam_FFB0], a

Label_7F_40A3:: ; 7F:40A3
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

; ---- code $41A7-$41B3 (12 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Glyph_IsSjisLeadByte:: ; 7F:41A7
Function_7F_41A7::
	push bc
	push de
	ld d, a
	ld b, a
	sub a, $81
	jr c, Label_7F_41C5
	cp a, $1F
	jr c, Label_7F_41CA

; ---- code $41B3-$41C5 (18 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 7F:41B1 (executed)
	ld a, b
	sub a, $E0
	jr c, Label_7F_41C5
	cp a, $10
	jr c, Label_7F_41CA
	ld a, b
	sub a, $F8
	jr c, Label_7F_41C5
	cp a, $02
	jr c, Label_7F_41CA

; ---- code $41C5-$41EA (37 bytes) [CONFIRMED] 43 insn(s); 43 executed (in up to 14/18 scenarios) (part of region $41C5-$4202)

Label_7F_41C5:: ; 7F:41C5
	xor a, a
	scf
	ccf
	jr Label_7F_41CD

Label_7F_41CA:: ; 7F:41CA
	scf
	ld a, $01

Label_7F_41CD:: ; 7F:41CD
	pop de
	pop bc
	ret

Glyph_Mul16:: ; 7F:41D0
	push af
	push bc
	push de
	ld hl, $0000
	ld a, $10

Label_7F_41D8:: ; 7F:41D8
	srl b
	rr c
	jr nc, Label_7F_41DF
	add hl, de

Label_7F_41DF:: ; 7F:41DF
	sla e
	rl d
	dec a
	jr nz, Label_7F_41D8
	pop de
	pop bc
	pop af
	ret
