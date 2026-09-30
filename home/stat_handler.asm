; home/stat_handler.asm
; bank 00, $0E93-$0ED3 (64 bytes); pinned by layout.link
; alternative STAT interrupt handler (scroll split)

SECTION "home/stat_handler", ROM0

; ---- code $0E93-$0ED3 (64 bytes) [CONFIRMED] alternative STAT interrupt handler (installed into RAM vector CBF4 by 7F:727D): if LY==0: LYC=[D724], SCY=0; else SCY=[C0D3], LYC=0 and, if [D824]!=0, call 0392; saves/restores rSVBK (uses WRAM bank 1) [candidate; raw refs 1] [executed in 21 scenarios]

Function_00_0E93:: ; 00:0E93
	push af
	ldh a, [rLY]
	cp a, $00
	jr nz, Label_00_0EB2
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wStatSplitLine]
	ldh [rLYC], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rSCY], a
	pop af
	reti

Label_00_0EB2:: ; 00:0EB2
	ldh a, [rSVBK]
	push af
	ld a, [wSplitScrollY]
	ldh [rSCY], a
	xor a, a
	ldh [rLYC], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wStatIrqServiceFlag]
	or a, a
	jr z, Label_00_0ECC
	call Function_00_0392

Label_00_0ECC:: ; 00:0ECC
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	reti
