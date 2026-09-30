; home/lcd.asm
; bank 00, $059F-$0602 (99 bytes); pinned by layout.link
; OAM DMA routine copy + image, LCDOn, LCDOff

SECTION "home/lcd", ROM0

; ---- code $059F-$05AC (13 bytes) [CONFIRMED] copies the 10-byte OAM DMA routine from 05AC to HRAM $FF80 (ld bc,$0A80: B=count, C=dest)

Function_00_059F:: ; 00:059F
	ld hl, $05AC
	ld bc, $0A80

Label_00_05A5:: ; 00:05A5
	ld a, [hli]
	ldh [c], a
	inc c
	dec b
	jr nz, Label_00_05A5
	ret

; ---- ramcode $05AC-$05B6 (10 bytes) [CONFIRMED] runaddr=$FF80 ; OAM DMA routine image: ld a,$C0 ; ldh [rDMA],a ; ld a,$28 ; .w dec a ; jr nz,.w ; ret. Copied by 059F, called at 03C1 as call $FF80
	LOAD "RAM_00_05AC", HRAM[$FF80]

OAMDMARoutine:: ; 00:05AC (runs at $FF80)
	ld a, $C0
	ldh [rDMA], a
	ld a, $28

Label_00_FF86:: ; 00:05B2 (runs at $FF86)
	dec a
	jr nz, Label_00_FF86
	ret

	ENDL

; ---- code $05B6-$05BD (7 bytes) [CONFIRMED] LCDC |= $80

LCDOn:: ; 00:05B6
	ldh a, [rLCDC]
	or a, $80
	ldh [rLCDC], a
	ret

; ---- code $05BD-$0602 (69 bytes) [CONFIRMED] if LCD on: wait for LY in [$91,$98), clear LCDC bit7, ei, call 0392. Two variants selected by FFA3==$11 (CGB path does not touch IE/IF)

LCDOff:: ; 00:05BD
	ldh a, [rLCDC]
	bit 7, a
	ret z
	di
	ldh a, [hBootA]
	cp a, $11
	jr z, Label_00_05ED
	ldh a, [rIE]
	ld b, a
	res 1, a
	ldh [rIF], a
	ldh [rIE], a

Label_00_05D2:: ; 00:05D2
	ldh a, [rLY]
	cp a, $91
	jr c, Label_00_05D2
	cp a, $98
	jr nc, Label_00_05D2
	ldh a, [rLCDC]
	and a, $7F
	ldh [rLCDC], a
	xor a, a
	ldh [rIF], a
	ld a, b
	ldh [rIE], a
	ei
	call Function_00_0392
	ret

Label_00_05ED:: ; 00:05ED
	ldh a, [rLY]
	cp a, $91
	jr c, Label_00_05ED
	cp a, $98
	jr nc, Label_00_05ED
	ldh a, [rLCDC]
	and a, $7F
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ret
