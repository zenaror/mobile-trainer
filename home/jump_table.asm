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
	; [CONFIRMED] inline table (5 words) follows the call (22 `call $056A` sites, each with 5 words): index = lowest set bit among bits 0-3 of (FFA5|FFA7)
	; (FFA7 is cleared), 4 if none (a D-pad-only press also gives 4); jumps through 0545 (call sites in other banks).  FFA5 = newly pressed buttons computed by
	; 7D:7BC1 ((old xor new) and new, new = rP1 read by 7D:7B7C: bits 4-7 the D-pad (Right, Left, Up, Down), bits 0-3 the buttons A, B, Select, Start, active
	; high), so index 0 = A, 1 = B, 2 = Select, 3 = Start, 4 = none of them.  Confirmed by execution: in the natural scenarios the handler of a word ran only
	; in scenarios whose input script presses that button (501 site/word/scenario triples, 0 violations; B is fixed by the hJoyHeld tests of
	; dynamic_tracing 9.3, B+Select+Right and Select+Left); hits 804,050 = 5,231 A (word 0) + 1,654 B + 767 Select + 950 Start + 795,448 none.  FFA7 writers store 0,
	; except 51:41D3, which stores the A returned by a farcall [executed in 61 scenarios]
	ldh a, [hJoyDispatchExtraMask]
	ld l, a
	xor a, a
	ldh [hJoyDispatchExtraMask], a
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
