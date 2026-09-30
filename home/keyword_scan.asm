; home/keyword_scan.asm
; bank 00, $10E9-$131A (561 bytes); pinned by layout.link
; keyword lookup and token/attribute scanner

SECTION "home/keyword_scan", ROM0

Html_MatchKeyword:: ; 00:10E9
Function_00_10E9::
	; [CONFIRMED] keyword lookup: BC = table of word pointers to strings (0 terminates); compares
	; [HL] with each ignoring ASCII case; returns A = byte after the matched keyword [reached via
	; inferred links; raw refs 30] [executed in 5 scenarios]
	call Sound_FrameService
.l10EC ; 00:10EC
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	ret z
	push bc
.l10F5 ; 00:10F5
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, .l110A
	cp a, $41
	jr c, .l1106
	cp a, $5B
	jr nc, .l1106
	add a, $20
.l1106 ; 00:1106
	cp a, c
	jr z, .l10F5
	dec hl
.l110A ; 00:110A
	ld a, c
	pop bc
	or a, a
	jr z, .l1117
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jr .l10EC
.l1117 ; 00:1117
	ld a, [de]
	ret

Html_ScanAttributes:: ; 00:1119
Function_00_1119::
	; [CONFIRMED] token/attribute scanner over an ASCII-like stream: stops at $00 or $3E (>),
	; handles $3D (=), quotes $22/$27, skips bytes <$21; uses 10E9 for keywords, DE=$C380 output.
	; HYPOTHESIS: HTML-like tag parser [reached via inferred links; raw refs 236] | 12 insn(s)
	; executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15
	; scenarios]
	call Sound_FrameService
.l111C ; 00:111C
	ld a, [hli]
	or a, a
	jr z, .l1152
	cp a, $3E
	jr z, .l1152
	cp a, $3D
	jp z, .l127A
	cp a, $21
	jr c, .l1155
	cp a, $81
	jr c, .l1145

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .l1146
	cp a, $E0
	jr c, .l1145
	cp a, $F0
	jr c, .l1146
	cp a, $F8
	jr c, .l1145
	cp a, $FA
	jr c, .l1146

.l1145 ; 00:1145
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	or a, a
.l1146 ; 00:1146
	jr nc, .l1165

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ld a, [hli]
	jr .l111C
.l114B ; 00:114B
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc

.l1152 ; 00:1152
	; [CONFIRMED] 46 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	dec hl
	xor a, a
	ret
.l1155 ; 00:1155
	ld a, [hli]
	or a, a
	jr z, .l1152
	cp a, $3D
	jp z, .l127A
	cp a, $21
	jr c, .l1155
	dec hl
	jr .l111C
.l1165 ; 00:1165
	dec hl
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	push bc
	push de
	call Html_MatchKeyword
	pop de
	or a, a
	jr nz, .l117F
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	inc hl
	pop bc
	jr .l111C
.l117F ; 00:117F
	ld c, a
	ld b, $00
	ld a, e
	ldh [hRam_FFB0], a
	ld a, d
	ldh [hRam_FFB1], a
	ld de, $C380
.l118B ; 00:118B
	ld a, [hli]
	or a, a
	jr z, .l114B
	cp a, $3E
	jr z, .l114B
	cp a, $21
	jr c, .l11A5
	cp a, $3D
	jr z, .l11B0

	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc
	jp .l111C
.l11A5 ; 00:11A5
	ld a, [hli]
	or a, a
	jr z, .l114B
	cp a, $21
	jr c, .l11A5
	dec hl
	jr .l118B

.l11B0 ; 00:11B0
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, [hli]
	or a, a
	jr z, .l114B
	cp a, $3E
	jr z, .l114B
	cp a, $22
	jp z, .l120A
	cp a, $27
	jp z, .l1242
	cp a, $21
	jr c, .l11B0
	dec hl
.l11C7 ; 00:11C7
	ld a, [hli]
	or a, a
	jr z, .l11FB
	cp a, $3E
	jr z, .l11FB
	cp a, $21
	jr c, .l11FF
	inc b
	jr z, .l11FF
	ld [de], a
	inc de
	cp a, $81
	jr c, .l11F0

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .l11F1
	cp a, $E0
	jr c, .l11F0
	cp a, $F0
	jr c, .l11F1
	cp a, $F8
	jr c, .l11F0
	cp a, $FA
	jr c, .l11F1

.l11F0 ; 00:11F0
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 3 scenarios]
	or a, a
.l11F1 ; 00:11F1
	jr nc, .l11C7

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	inc b
	jr z, .l11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr .l11C7

.l11FB ; 00:11FB
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 4 scenarios]
	dec hl
	jr .l11FF

.l11FE ; 00:11FE
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	dec de

.l11FF ; 00:11FF
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	ld a, c
	pop bc
	ret
.l120A ; 00:120A
	ld a, [hli]
	or a, a
	jr z, .l11FB
	cp a, $3E
	jr z, .l11FB
	cp a, $22
	jr z, .l11FF
	inc b
	jr z, .l11FF
	cp a, $20
	jr c, .l120A
	ld [de], a
	inc de
	cp a, $81
	jr c, .l1237

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .l1238
	cp a, $E0
	jr c, .l1237
	cp a, $F0
	jr c, .l1238
	cp a, $F8
	jr c, .l1237
	cp a, $FA
	jr c, .l1238

.l1237 ; 00:1237
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 15 scenarios]
	or a, a
.l1238 ; 00:1238
	jr nc, .l120A

	; [PROBABLE] 39 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	inc b
	jr z, .l11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr .l120A
.l1242 ; 00:1242
	ld a, [hli]
	or a, a
	jr z, .l11FB
	cp a, $3E
	jr z, .l11FB
	cp a, $27
	jr z, .l11FF
	inc b
	jr z, .l11FF
	cp a, $20
	jr c, .l1242
	ld [de], a
	inc de
	cp a, $81
	jr c, .l126F
	cp a, $A0
	jr c, .l1270
	cp a, $E0
	jr c, .l126F
	cp a, $F0
	jr c, .l1270
	cp a, $F8
	jr c, .l126F
	cp a, $FA
	jr c, .l1270
.l126F ; 00:126F
	or a, a
.l1270 ; 00:1270
	jr nc, .l1242
	inc b
	jr z, .l11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr .l1242

.l127A ; 00:127A
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [hli]
	or a, a
	jp z, .l1152
	cp a, $3E
	jp z, .l1152
	cp a, $22
	jp z, .l12C0

	; [PROBABLE] 28 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $27
	jp z, .l12ED
	cp a, $21
	jr c, .l127A
	dec hl
.l1293 ; 00:1293
	ld a, [hli]
	or a, a
	jp z, .l1152
	cp a, $3E
	jp z, .l1152
	cp a, $21
	jp c, .l111C
	cp a, $81
	jr c, .l12BA
	cp a, $A0
	jr c, .l12BB
	cp a, $E0
	jr c, .l12BA
	cp a, $F0
	jr c, .l12BB
	cp a, $F8
	jr c, .l12BA
	cp a, $FA
	jr c, .l12BB
.l12BA ; 00:12BA
	or a, a
.l12BB ; 00:12BB
	jr nc, .l1293
	ld a, [hli]
	jr .l1293

.l12C0 ; 00:12C0
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [hli]
	or a, a
	jp z, .l1152
	cp a, $3E
	jp z, .l1152
	cp a, $22
	jp z, .l111C
	cp a, $81
	jr c, .l12E7

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, .l12E8
	cp a, $E0
	jr c, .l12E7
	cp a, $F0
	jr c, .l12E8
	cp a, $F8
	jr c, .l12E7
	cp a, $FA
	jr c, .l12E8

.l12E7 ; 00:12E7
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l12E8 ; 00:12E8
	jr nc, .l12C0

	; [PROBABLE] 25 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 1119-131A by apply_coverage --split
	ld a, [hli]
	jr .l12C0
.l12ED ; 00:12ED
	ld a, [hli]
	or a, a
	jp z, .l1152
	cp a, $3E
	jp z, .l1152
	cp a, $27
	jp z, .l111C
	cp a, $81
	jr c, .l1314
	cp a, $A0
	jr c, .l1315
	cp a, $E0
	jr c, .l1314
	cp a, $F0
	jr c, .l1315
	cp a, $F8
	jr c, .l1314
	cp a, $FA
	jr c, .l1315
.l1314 ; 00:1314
	or a, a
.l1315 ; 00:1315
	jr nc, .l12ED
	ld a, [hli]
	jr .l12ED
