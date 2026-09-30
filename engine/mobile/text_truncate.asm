; engine/mobile/text_truncate.asm
; bank 54, $4C47-$4CB0 (105 bytes); pinned by layout.link
; Text_TruncateSjis

SECTION "engine/mobile/text_truncate", ROMX

Text_TruncateSjis:: ; 54:4C47
	; [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 14;
	; entered by call from 54:4A87 (PROBABLE code) | 9 insn(s) executed; cut out of the PROBABLE
	; region 4C47-4CAD by apply_coverage --split [executed in 6 scenarios]
	ld c, $01
.loop ; 54:4C49
	dec b
	ld a, [hli]
	or a, a
	ret z
	cp a, $81
	jr c, .l4C65
	cp a, $A0
	jr c, .l4C66

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C47-4CAD by apply_coverage --split
	cp a, $E0
	jr c, .l4C65
	cp a, $F0
	jr c, .l4C66
	cp a, $F8
	jr c, .l4C65
	cp a, $FA
	jr c, .l4C66

.l4C65 ; 54:4C65
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l4C66 ; 54:4C66
	jr nc, .skip
	inc hl
	dec b
.skip ; 54:4C6A
	ld a, b
	cp a, $FF
	jr nz, .l4C8D
	ld a, [hl]
	cp a, $81
	jr c, .l4C88

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C47-4CAD by apply_coverage --split
	cp a, $A0
	jr c, .l4C89
	cp a, $E0
	jr c, .l4C88
	cp a, $F0
	jr c, .l4C89
	cp a, $F8
	jr c, .l4C88
	cp a, $FA
	jr c, .l4C89

.l4C88 ; 54:4C88
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage
	; --split [executed in 8 scenarios]
	or a, a
.l4C89 ; 54:4C89
	jr nc, .loop

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C47-4CAD by apply_coverage --split
	jr .l4C91

.l4C8D ; 54:4C8D
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage
	; --split [executed in 10 scenarios]
	cp a, $FE
	jr nz, .loop
.l4C91 ; 54:4C91
	dec hl
	dec hl
	ld e, l
	ld d, h
	ld hl, String_Text_Ellipsis
	xor a, a
	or a, c
	jr nz, .l4CA3

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C47-4CAD by apply_coverage --split
	farcall CopyString
	ret

.l4CA3 ; 54:4CA3
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage
	; --split [executed in 10 scenarios]
	ld bc, $0002
	farcall CopyBytes
	ret

; ---- data $4CAD-$4CB0 (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

String_Text_Ellipsis:: ; 54:4CAD
Data_54_4CAD::
	db $81, $63, $00
