; home/interrupt_handlers.asm
; bank 00, $16C4-$1711 (77 bytes); pinned by layout.link
; alternative STAT/VBlank handlers installed into the RAM stubs by other banks

SECTION "home/interrupt_handlers", ROM0

; ---- code $16C4-$16D4 (16 bytes) [CONFIRMED] alternative STAT handler (installed by 48:4437 into CBF4): if LY==$80 then SCX=[C0EF] [candidate; raw refs 4] [executed in 28 scenarios]

Function_00_16C4:: ; 00:16C4
	push af
	ldh a, [rLY]
	cp a, $80
	jr z, Label_00_16CD
	pop af
	reti

Label_00_16CD:: ; 00:16CD
	ld a, [wTickerScrollX]
	ldh [rSCX], a
	pop af
	reti

; ---- code $16D4-$16DC (8 bytes) [CONFIRMED] alternative VBlank handler prologue (installed by 48:4446 into CBF1): SCX=0 then jp $C133 (copy of the original VBlank stub saved by 48:4425) [candidate; no static referrer] [executed in 28 scenarios]

Function_00_16D4:: ; 00:16D4
	push af
	xor a, a
	ldh [rSCX], a
	pop af
	jp $C133

; ---- code $16DC-$1711 (53 bytes) [CONFIRMED] alternative STAT handler (installed by 57:4537 into CBF4): raster effect using WY, C0F6, LYC [candidate; raw refs 1] [executed in 4 scenarios]

Function_00_16DC:: ; 00:16DC
	push af
	ldh a, [rLY]
	cp a, $8E
	jr z, Label_00_1708
	ldh a, [rWY]
	cp a, $78
	jr nc, Label_00_1706
	push bc
	sub a, $28
	srl a
	srl a
	srl a
	ld b, a
	ld a, [wRam_C0F6]
	xor a, $FF
	inc a
	add a, $09
	ldh [rSCY], a
	ld a, b
	ld [wRam_C0F6], a
	ld a, $8E
	ldh [rLYC], a
	pop bc

Label_00_1706:: ; 00:1706
	pop af
	reti

Label_00_1708:: ; 00:1708
	xor a, a
	ldh [rSCY], a
	ld a, $1A
	ldh [rLYC], a
	pop af
	reti
