; home/random.asm
; bank 00, $0C0E-$0D34 (294 bytes); pinned by layout.link
; Random16, Random, xor table

SECTION "home/random", ROM0

; ---- code $0C0E-$0C18 (10 bytes) [PROBABLE] HL = (Random, Random) : H=first byte, L=second byte [candidate; raw refs 4]

Random16:: ; 00:0C0E
	call Random
	ld d, a
	call Random
	ld l, a
	ld h, d
	ret

; ---- code $0C18-$0C34 (28 bytes) [PROBABLE] A(hFFFE) = (5*hFFFE + 2) xor Table_00_0C34[++hFFFD] ; returns in hFFFE (index hFFFD wraps at 256). No seeding code in ROM0 [candidate; raw refs 26]

Random:: ; 00:0C18
	push bc
	ldh a, [hRandomIndex]
	inc a
	ldh [hRandomIndex], a
	ld hl, Table_00_0C34
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ldh a, [hRandomState]
	ld b, a
	add a, a
	add a, a
	add a, b
	add a, $02
	xor a, [hl]
	ldh [hRandomState], a
	pop bc
	ret

; ---- data $0C34-$0D34 (256 bytes) [CONFIRMED] 256 bytes indexed by hFFFD, xor operand of Random (0C2F)

Table_00_0C34:: ; 00:0C34
	db $35, $4C, $34, $E4, $CA, $A8, $0C, $DC, $A5, $0F, $37, $7B, $AA, $9D, $F2, $5A
	db $1A, $65, $94, $C6, $1F, $B5, $C1, $21, $A5, $9C, $E1, $86, $6C, $AA, $D0, $AC
	db $5B, $F7, $D7, $0D, $18, $66, $DC, $47, $D5, $2B, $D5, $C2, $6D, $8B, $83, $93
	db $AF, $E3, $5C, $A0, $F9, $EC, $C9, $05, $0A, $3D, $91, $B7, $11, $12, $95, $67
	db $09, $4B, $BF, $AA, $49, $B8, $35, $56, $57, $93, $D2, $2F, $FE, $4E, $D6, $C3
	db $A0, $90, $DC, $92, $CD, $7A, $0D, $72, $13, $2E, $94, $32, $18, $92, $51, $7E
	db $E7, $51, $D2, $02, $88, $23, $7F, $D3, $D3, $4F, $14, $0A, $85, $6E, $55, $B2
	db $94, $71, $FD, $E4, $C0, $E5, $F7, $30, $6B, $76, $D0, $3F, $AA, $B2, $6D, $B7
	db $9C, $10, $F9, $5F, $FB, $31, $22, $84, $F0, $65, $85, $9B, $2C, $71, $66, $27
	db $34, $90, $A5, $DD, $FC, $B7, $ED, $06, $B8, $1D, $2F, $26, $EF, $FB, $4F, $DB
	db $D1, $90, $1D, $07, $CA, $69, $86, $31, $57, $DF, $0C, $29, $19, $E1, $73, $EB
	db $28, $F4, $BD, $C6, $A9, $77, $59, $BE, $A3, $2C, $98, $2E, $0E, $F4, $60, $B2
	db $2D, $DA, $24, $43, $1E, $53, $13, $A4, $B0, $C4, $90, $FE, $74, $45, $E3, $C7
	db $17, $A5, $2E, $E7, $EE, $AE, $A2, $1E, $D3, $AA, $F2, $A0, $30, $26, $08, $03
	db $59, $F5, $F8, $5B, $1F, $78, $32, $A4, $A2, $1D, $FB, $60, $66, $26, $1E, $80
	db $A9, $AC, $DE, $88, $F4, $E3, $30, $EF, $F1, $9F, $27, $C4, $7C, $17, $B0, $98
