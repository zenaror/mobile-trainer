; home/glyph_data.asm
; bank 00, $0DB9-$0E93 (218 bytes); pinned by layout.link
; glyph-data copy/unpack helpers used by the bank 7F glyph pipeline

SECTION "home/glyph_data", ROM0

; ---- code $0DB9-$0DCE (21 bytes) [CONFIRMED] A=bank, DE=src, HL=dst, C=restore bank: switch ROM bank via FF8A/[2100], copy 12 bytes each written twice, restore bank C

Function_00_0DB9:: ; 00:0DB9
	ldh [hROMBankLo], a
	ld [$2100], a
	ld b, $0C

Label_00_0DC0:: ; 00:0DC0
	ld a, [de]
	inc de
	ld [hli], a
	ld [hli], a
	dec b
	jr nz, Label_00_0DC0
	ld a, c
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0DCE-$0DE2 (20 bytes) [PROBABLE] like 0DB9 without duplicating (12 bytes) [candidate; raw refs 8]

Function_00_0DCE:: ; 00:0DCE
	ldh [hROMBankLo], a
	ld [$2100], a
	ld b, $0C

Label_00_0DD5:: ; 00:0DD5
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, Label_00_0DD5
	ld a, c
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0DE2-$0E32 (80 bytes) [CONFIRMED] A=bank, DE=src (18 bytes), HL=dst1, BC=dst2: two bit-shuffling passes that unpack 4 six-bit values per 3 source bytes (value<<2), pass 1 -> HL, pass 2 -> BC, each output byte written twice; ends by selecting ROM bank $7F. Called only from bank 7F

Function_00_0DE2:: ; 00:0DE2
	ldh [hROMBankLo], a
	ld [$2100], a
	push bc
	push de
	ld c, $06

Label_00_0DEB:: ; 00:0DEB
	ld a, [de]
	inc de
	and a, $FC
	ld [hli], a
	ld [hli], a
	ld a, [de]
	inc de
	and a, $0F
	swap a
	ld b, a
	ld a, [de]
	inc de
	swap a
	and a, $0C
	or a, b
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, Label_00_0DEB
	pop de
	pop hl
	ld c, $06

Label_00_0E08:: ; 00:0E08
	ld b, $00
	ld a, [de]
	inc de
	srl a
	rr b
	srl a
	rr b
	ld a, [de]
	inc de
	srl a
	srl a
	or a, b
	and a, $FC
	ld [hli], a
	ld [hli], a
	ld a, [de]
	inc de
	sla a
	sla a
	ld [hli], a
	ld [hli], a
	dec c
	jr nz, Label_00_0E08
	ld a, $7F
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0E32-$0E7E (76 bytes) [PROBABLE] same unpacking as 0DE2 but each output byte is written once; ends with ROM bank $7F. Called only from bank 7F [candidate; raw refs 6]

Function_00_0E32:: ; 00:0E32
	ldh [hROMBankLo], a
	ld [$2100], a
	push bc
	push de
	ld c, $06

Label_00_0E3B:: ; 00:0E3B
	ld a, [de]
	inc de
	and a, $FC
	ld [hli], a
	ld a, [de]
	inc de
	and a, $0F
	swap a
	ld b, a
	ld a, [de]
	inc de
	swap a
	and a, $0C
	or a, b
	ld [hli], a
	dec c
	jr nz, Label_00_0E3B
	pop de
	pop hl
	ld c, $06

Label_00_0E56:: ; 00:0E56
	ld b, $00
	ld a, [de]
	inc de
	srl a
	rr b
	srl a
	rr b
	ld a, [de]
	inc de
	srl a
	srl a
	or a, b
	and a, $FC
	ld [hli], a
	ld a, [de]
	inc de
	sla a
	sla a
	ld [hli], a
	dec c
	jr nz, Label_00_0E56
	ld a, $7F
	ldh [hROMBankLo], a
	ld [$2100], a
	ret

; ---- code $0E7E-$0E93 (21 bytes) [PROBABLE] A=bank, DE=src, B=count, C=restore bank: copies B bytes into C0A0 (buffer directly after the shadow OAM, also used as glyph buffer by 1044) [candidate; no static referrer]

Function_00_0E7E:: ; 00:0E7E
	ldh [hROMBankLo], a
	ld [$2100], a
	ld hl, $C0A0

Label_00_0E86:: ; 00:0E86
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, Label_00_0E86
	ld a, c
	ldh [hROMBankLo], a
	ld [$2100], a
	ret
