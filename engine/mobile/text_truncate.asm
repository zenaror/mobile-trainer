; engine/mobile/text_truncate.asm
; bank 54, $4C47-$4CB0 (105 bytes); pinned by layout.link
; Text_TruncateSjis

SECTION "engine/mobile/text_truncate", ROMX

; ---- code $4C47-$4C55 (14 bytes) [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 14; entered by call from 54:4A87 (PROBABLE code) | 9 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split [executed in 6 scenarios]

Text_TruncateSjis:: ; 54:4C47
	ld c, $01

Label_54_4C49:: ; 54:4C49
	dec b
	ld a, [hli]
	or a, a
	ret z
	cp a, $81
	jr c, Label_54_4C65
	cp a, $A0
	jr c, Label_54_4C66

; ---- code $4C55-$4C65 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split
	cp a, $E0
	jr c, Label_54_4C65
	cp a, $F0
	jr c, Label_54_4C66
	cp a, $F8
	jr c, Label_54_4C65
	cp a, $FA
	jr c, Label_54_4C66

; ---- code $4C65-$4C74 (15 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split [executed in 6 scenarios]

Label_54_4C65:: ; 54:4C65
	or a, a

Label_54_4C66:: ; 54:4C66
	jr nc, Label_54_4C6A
	inc hl
	dec b

Label_54_4C6A:: ; 54:4C6A
	ld a, b
	cp a, $FF
	jr nz, Label_54_4C8D
	ld a, [hl]
	cp a, $81
	jr c, Label_54_4C88

; ---- code $4C74-$4C88 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split
	cp a, $A0
	jr c, Label_54_4C89
	cp a, $E0
	jr c, Label_54_4C88
	cp a, $F0
	jr c, Label_54_4C89
	cp a, $F8
	jr c, Label_54_4C88
	cp a, $FA
	jr c, Label_54_4C89

; ---- code $4C88-$4C8B (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split [executed in 8 scenarios]

Label_54_4C88:: ; 54:4C88
	or a, a

Label_54_4C89:: ; 54:4C89
	jr nc, Label_54_4C49

; ---- code $4C8B-$4C8D (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split
	jr Label_54_4C91

; ---- code $4C8D-$4C9C (15 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split [executed in 10 scenarios]

Label_54_4C8D:: ; 54:4C8D
	cp a, $FE
	jr nz, Label_54_4C49

Label_54_4C91:: ; 54:4C91
	dec hl
	dec hl
	ld e, l
	ld d, h
	ld hl, String_Text_Ellipsis
	xor a, a
	or a, c
	jr nz, Label_54_4CA3

; ---- code $4C9C-$4CA3 (7 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split
	farcall CopyString
	ret

; ---- code $4CA3-$4CAD (10 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4C47-4CAD by apply_coverage --split [executed in 10 scenarios]

Label_54_4CA3:: ; 54:4CA3
	ld bc, $0002
	farcall CopyBytes
	ret

; ---- data $4CAD-$4CB0 (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

String_Text_Ellipsis:: ; 54:4CAD
Data_54_4CAD::
	db $81, $63, $00
