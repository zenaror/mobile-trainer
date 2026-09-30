; home/jump_table.asm
; bank 00, $0540-$059F (95 bytes); pinned by layout.link
; JumpTableBank/JumpTableInline/FarJumpTable, JoypadDispatch

SECTION "home/jump_table", ROM0

; ---- code $0540-$0545 (5 bytes) [PROBABLE] A=bank, HL=table of 16-bit pointers, C=index: bank switch via 0622, then jp [HL+2*C] (0545 is the entry that takes A=index and the table inline) [candidate; raw refs 33] | 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 0540-0551 by apply_coverage --split

JumpTableBank:: ; 00:0540
	call BankSwitch_H
	push hl
	ld a, c

; ---- code $0545-$0551 (12 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 0540-0551 by apply_coverage --split [executed in 62 scenarios]

JumpTableInline:: ; 00:0545
	pop hl
	push de
	ld e, a
	ld d, $00
	add hl, de
	add hl, de
	pop de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- code $0551-$056A (25 bytes) [PROBABLE] A=bank, HL=table of 3-byte entries (addr16, bank), C=index: switch to the table bank, read entry, switch to the entry bank, jp to it [candidate; raw refs 4]

FarJumpTable:: ; 00:0551
	call BankSwitch_H
	push hl
	ld a, c
	pop hl
	push de
	ld e, a
	ld d, $00
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld h, d
	ld l, e
	pop de
	call BankSwitch_H
	jp hl

; ---- code $056A-$059F (53 bytes) [CONFIRMED] inline table (5 words) follows the call: index = lowest set bit among bits0-3 of (FFA5|FFA7) (FFA7 is cleared), 4 if none; jumps through 0545 (call sites in other banks). FFA5 = newly pressed buttons computed by 7D:7BC1 ((old xor new) and new, new = rP1 read by 7D:7B7C: high nibble D-pad, low nibble A,B,Select,Start, active high), so by the rP1 layout index 0=A 1=B 2=Select 3=Start 4=none (PROBABLE); FFA7 has raw `ldh [$FFA7],a` byte patterns in other banks (1D:5F3F, 2D:70FD, 4A:62DF ...; not checked whether they are code), meaning unknown [reached via inferred links; raw refs 26] [executed in 14 scenarios]

JoypadDispatch:: ; 00:056A
	ldh a, [hRam_FFA7]
	ld l, a
	xor a, a
	ldh [hRam_FFA7], a
	ldh a, [hJoyPressed]
	or a, l
	bit 0, a
	jp nz, Label_00_059B
	bit 1, a
	jp nz, Label_00_0596
	bit 2, a
	jp nz, Label_00_0591
	bit 3, a
	jp nz, Label_00_058C
	ld a, $04
	jp JumpTableInline

Label_00_058C:: ; 00:058C
	ld a, $03
	jp JumpTableInline

Label_00_0591:: ; 00:0591
	ld a, $02
	jp JumpTableInline

Label_00_0596:: ; 00:0596
	ld a, $01
	jp JumpTableInline

Label_00_059B:: ; 00:059B
	xor a, a
	jp JumpTableInline
