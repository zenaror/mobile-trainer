; home/jump_table.asm
; bank 00, $0540-$059F (95 bytes); pinned by layout.link
; JumpTableBank/JumpTableInline/FarJumpTable, JoypadDispatch

SECTION "home/jump_table", ROM0

JumpTableBank:: ; 00:0540
	; [PROBABLE] A=bank, HL=table of 16-bit pointers, C=index: bank switch via 0622, then jp
	; [HL+2*C] (0545 is the entry that takes A=index and the table inline) [candidate; raw refs 33]
	; | 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 0540-0551 by
	; apply_coverage --split
	call BankSwitch_H
	push hl
	ld a, c

JumpTableInline:: ; 00:0545
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 0540-0551 by apply_coverage
	; --split [executed in 62 scenarios]
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

FarJumpTable:: ; 00:0551
	; [PROBABLE] A=bank, HL=table of 3-byte entries (addr16, bank), C=index: switch to the table
	; bank, read entry, switch to the entry bank, jp to it [candidate; raw refs 4]
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

JoypadDispatch:: ; 00:056A
	; [CONFIRMED] inline table (5 words) follows the call: index = lowest set bit among bits0-3 of
	; (FFA5|FFA7) (FFA7 is cleared), 4 if none; jumps through 0545 (call sites in other banks). FFA5
	; = newly pressed buttons computed by 7D:7BC1 ((old xor new) and new, new = rP1 read by 7D:7B7C:
	; high nibble D-pad, low nibble A,B,Select,Start, active high), so by the rP1 layout index 0=A
	; 1=B 2=Select 3=Start 4=none (PROBABLE); FFA7 has raw `ldh [$FFA7],a` byte patterns in other
	; banks (1D:5F3F, 2D:70FD, 4A:62DF ...; not checked whether they are code), meaning unknown
	; [reached via inferred links; raw refs 26] [executed in 14 scenarios]
	ldh a, [hRam_FFA7]
	ld l, a
	xor a, a
	ldh [hRam_FFA7], a
	ldh a, [hJoyPressed]
	or a, l
	bit 0, a
	jp nz, .l059B
	bit 1, a
	jp nz, .l0596
	bit 2, a
	jp nz, .l0591
	bit 3, a
	jp nz, .l058C
	ld a, $04
	jp JumpTableInline
.l058C ; 00:058C
	ld a, $03
	jp JumpTableInline
.l0591 ; 00:0591
	ld a, $02
	jp JumpTableInline
.l0596 ; 00:0596
	ld a, $01
	jp JumpTableInline
.l059B ; 00:059B
	xor a, a
	jp JumpTableInline
