; engine/tutorial/gates.asm
; bank 48, $498C-$4AAB (287 bytes); pinned by layout.link
; first-use tutorial gates (top menu, mail menu, homepage) and a copy of 00:091C

SECTION "engine/tutorial/gates", ROMX

Tutorial_GateHomepage:: ; 48:498C
	; [CONFIRMED] 84 insn(s); 84 executed (in up to 17/18 scenarios) (part of region $48FE-$49A3)
	farcall ReturnImmediately
	ld b, $00
	ld a, $01
	ld hl, sTutorialGateHomepage
	call ReadByteFar
	cp a, $FF
	ret z
	cp a, $00
	jr z, .l49A9

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 48:49A1 (executed) [executed in 4 scenarios]
	cp a, $01
	jr z, .l49B6
	jr .l49C3

.l49A9 ; 48:49A9
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	ld b, $91
	farcall HelpScript_Run
	xor a, a
	or a, b
	ret nz
	jr .l49C3

.l49B6 ; 48:49B6
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 48:49A5 (PROBABLE code) [executed in 3 scenarios]
	ld b, $92
	farcall HelpScript_Run
	xor a, a
	or a, b
	ret nz
	jr .l49C3

.l49C3 ; 48:49C3
	; [CONFIRMED] 82 insn(s); 82 executed (in up to 12/18 scenarios)
	ld a, $01
	ld hl, sTutorialGateHomepage
	call ReadByteFar
	inc a
	ld b, a
	ld a, $01
	ld hl, sTutorialGateHomepage
	farcall WriteByteFar
	ld b, $00
	ret

Tutorial_GateMailMenu:: ; 48:49DB
	farcall ReturnImmediately
	ld b, $00
	ld a, $01
	ld hl, sTutorialGateMailMenu
	call ReadByteFar
	cp a, $FF
	ret z
	cp a, $00
	jr z, .l49F8
	cp a, $01
	jr z, .l4A29
	jr .l4A36
.l49F8 ; 48:49F8
	ld b, $89
	farcall HelpScript_Run
	xor a, a
	or a, b
	ret nz
	farcall SramCheck_VerifyAndRepairAll
	ld a, $01
	farcall Profile_Edit
	ld a, $01
	ld hl, sTutorialGateMailMenu
	call ReadByteFar
	inc a
	ld b, a
	ld a, $01
	ld hl, sTutorialGateMailMenu
	farcall WriteByteFar
	ld b, $00
	ret
.l4A29 ; 48:4A29
	ld b, $8A
	farcall HelpScript_Run
	xor a, a
	or a, b
	ret nz
	jr .l4A36
.l4A36 ; 48:4A36
	ld a, $01
	ld hl, sTutorialGateMailMenu
	call ReadByteFar
	inc a
	ld b, a
	ld a, $01
	ld hl, sTutorialGateMailMenu
	farcall WriteByteFar
	ld b, $00
	ret

Tutorial_GateTopMenu:: ; 48:4A4E
	farcall ReturnImmediately
	ld b, $00
	ld a, $01
	ld hl, sTutorialGateTopMenu
	call ReadByteFar
	cp a, $FF
	ret z
	cp a, $00
	jr z, .l4A67
	jr .l4A74
.l4A67 ; 48:4A67
	ld b, $81
	farcall HelpScript_Run
	xor a, a
	or a, b
	ret nz
	jr .l4A74
.l4A74 ; 48:4A74
	ld a, $01
	ld hl, sTutorialGateTopMenu
	call ReadByteFar
	inc a
	ld b, a
	ld a, $01
	ld hl, sTutorialGateTopMenu
	farcall WriteByteFar
	ld b, $00
	ret

Tilemap_ApplyMaskRect_48_4A8C:: ; 48:4A8C

	; [HYPOTHESIS] byte-identical to ROM0 Tilemap_ApplyMaskRect: B rows apply [HL]=([HL]&D)|E;
	; the next-row advance is ceil(C/32)*32 for C=1..255 (32 only for widths 1..32); C=0 processes
	; 256 bytes and advances 256, while B=0 wraps to 256 rows. No caller/pointer to 48:4A8C is known;
	; a 32-byte stride requires C=1..32. The bank-selection and writable-destination contract is
	; unproved for this copy; it follows RET at 4A8B and ends at RET 4AAA.
	call BankSwitch_H
	ld a, c
	ldh [hTileMaskRect_Width], a
.apply_mask_to_cell ; 48:4A92
	ld a, [hl]
	and a, d
	or a, e
	ld [hli], a
	dec c
	jr nz, .apply_mask_to_cell
	ldh a, [hTileMaskRect_Width]
	ld c, a
	xor a, $1F
	inc a
	and a, $1F
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	dec b
	jr nz, .apply_mask_to_cell
	ret
