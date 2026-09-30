; home/double_speed.asm
; bank 00, $0602-$0622 (32 bytes); pinned by layout.link
; SwitchCPUSpeed

SECTION "home/double_speed", ROM0

; ---- code $0602-$0622 (32 bytes) [CONFIRMED] A bit7 = requested speed: if rKEY1 bit7 differs, rKEY1=1, IF=IE=0, P1=$30, STOP, restore IE (CGB double-speed switch). Boot calls it with A=$80

SwitchCPUSpeed:: ; 00:0602
	ld b, a
	ldh a, [rIE]
	ld c, a
	ldh a, [rKEY1]
	xor a, b
	rlca
	jr nc, Label_00_0621
	ld a, $01
	ldh [rKEY1], a
	xor a, a
	ldh [rIF], a
	ldh [rIE], a
	ld a, $30
	ldh [rP1], a
	stop
	xor a, a
	ldh [rIF], a
	ld a, c
	ldh [rIE], a

Label_00_0621:: ; 00:0621
	ret
