; home/keyword_scan.asm
; bank 00, $10E9-$131A (561 bytes); pinned by layout.link
; keyword lookup and token/attribute scanner

SECTION "home/keyword_scan", ROM0

; ---- code $10E9-$1119 (48 bytes) [CONFIRMED] keyword lookup: BC = table of word pointers to strings (0 terminates); compares [HL] with each ignoring ASCII case; returns A = byte after the matched keyword [reached via inferred links; raw refs 30] [executed in 5 scenarios]

Function_00_10E9:: ; 00:10E9
	call Function_00_0392

Label_00_10EC:: ; 00:10EC
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	ret z
	push bc

Label_00_10F5:: ; 00:10F5
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, Label_00_110A
	cp a, $41
	jr c, Label_00_1106
	cp a, $5B
	jr nc, Label_00_1106
	add a, $20

Label_00_1106:: ; 00:1106
	cp a, c
	jr z, Label_00_10F5
	dec hl

Label_00_110A:: ; 00:110A
	ld a, c
	pop bc
	or a, a
	jr z, Label_00_1117
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jr Label_00_10EC

Label_00_1117:: ; 00:1117
	ld a, [de]
	ret

; ---- code $1119-$1131 (24 bytes) [CONFIRMED] token/attribute scanner over an ASCII-like stream: stops at $00 or $3E (>), handles $3D (=), quotes $22/$27, skips bytes <$21; uses 10E9 for keywords, DE=$C380 output. HYPOTHESIS: HTML-like tag parser [reached via inferred links; raw refs 236] | 12 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15 scenarios]

Function_00_1119:: ; 00:1119
	call Function_00_0392

Label_00_111C:: ; 00:111C
	ld a, [hli]
	or a, a
	jr z, Label_00_1152
	cp a, $3E
	jr z, Label_00_1152
	cp a, $3D
	jp z, Label_00_127A
	cp a, $21
	jr c, Label_00_1155
	cp a, $81
	jr c, Label_00_1145

; ---- code $1131-$1145 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, Label_00_1146
	cp a, $E0
	jr c, Label_00_1145
	cp a, $F0
	jr c, Label_00_1146
	cp a, $F8
	jr c, Label_00_1145
	cp a, $FA
	jr c, Label_00_1146

; ---- code $1145-$1148 (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15 scenarios]

Label_00_1145:: ; 00:1145
	or a, a

Label_00_1146:: ; 00:1146
	jr nc, Label_00_1165

; ---- code $1148-$1152 (10 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	ld a, [hli]
	jr Label_00_111C

Label_00_114B:: ; 00:114B
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc

; ---- code $1152-$119B (73 bytes) [CONFIRMED] 46 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15 scenarios]

Label_00_1152:: ; 00:1152
	dec hl
	xor a, a
	ret

Label_00_1155:: ; 00:1155
	ld a, [hli]
	or a, a
	jr z, Label_00_1152
	cp a, $3D
	jp z, Label_00_127A
	cp a, $21
	jr c, Label_00_1155
	dec hl
	jr Label_00_111C

Label_00_1165:: ; 00:1165
	dec hl
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	push bc
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr nz, Label_00_117F
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	inc hl
	pop bc
	jr Label_00_111C

Label_00_117F:: ; 00:117F
	ld c, a
	ld b, $00
	ld a, e
	ldh [hRam_FFB0], a
	ld a, d
	ldh [hRam_FFB1], a
	ld de, $C380

Label_00_118B:: ; 00:118B
	ld a, [hli]
	or a, a
	jr z, Label_00_114B
	cp a, $3E
	jr z, Label_00_114B
	cp a, $21
	jr c, Label_00_11A5
	cp a, $3D
	jr z, Label_00_11B0

; ---- code $119B-$11B0 (21 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	pop bc
	jp Label_00_111C

Label_00_11A5:: ; 00:11A5
	ld a, [hli]
	or a, a
	jr z, Label_00_114B
	cp a, $21
	jr c, Label_00_11A5
	dec hl
	jr Label_00_118B

; ---- code $11B0-$11DC (44 bytes) [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 3 scenarios]

Label_00_11B0:: ; 00:11B0
	ld a, [hli]
	or a, a
	jr z, Label_00_114B
	cp a, $3E
	jr z, Label_00_114B
	cp a, $22
	jp z, Label_00_120A
	cp a, $27
	jp z, Label_00_1242
	cp a, $21
	jr c, Label_00_11B0
	dec hl

Label_00_11C7:: ; 00:11C7
	ld a, [hli]
	or a, a
	jr z, Label_00_11FB
	cp a, $3E
	jr z, Label_00_11FB
	cp a, $21
	jr c, Label_00_11FF
	inc b
	jr z, Label_00_11FF
	ld [de], a
	inc de
	cp a, $81
	jr c, Label_00_11F0

; ---- code $11DC-$11F0 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, Label_00_11F1
	cp a, $E0
	jr c, Label_00_11F0
	cp a, $F0
	jr c, Label_00_11F1
	cp a, $F8
	jr c, Label_00_11F0
	cp a, $FA
	jr c, Label_00_11F1

; ---- code $11F0-$11F3 (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 3 scenarios]

Label_00_11F0:: ; 00:11F0
	or a, a

Label_00_11F1:: ; 00:11F1
	jr nc, Label_00_11C7

; ---- code $11F3-$11FB (8 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	inc b
	jr z, Label_00_11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr Label_00_11C7

; ---- code $11FB-$11FE (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 4 scenarios]

Label_00_11FB:: ; 00:11FB
	dec hl
	jr Label_00_11FF

; ---- code $11FE-$11FF (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split

Label_00_11FE:: ; 00:11FE
	dec de

; ---- code $11FF-$1223 (36 bytes) [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15 scenarios]

Label_00_11FF:: ; 00:11FF
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB0]
	ld e, a
	ldh a, [hRam_FFB1]
	ld d, a
	ld a, c
	pop bc
	ret

Label_00_120A:: ; 00:120A
	ld a, [hli]
	or a, a
	jr z, Label_00_11FB
	cp a, $3E
	jr z, Label_00_11FB
	cp a, $22
	jr z, Label_00_11FF
	inc b
	jr z, Label_00_11FF
	cp a, $20
	jr c, Label_00_120A
	ld [de], a
	inc de
	cp a, $81
	jr c, Label_00_1237

; ---- code $1223-$1237 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, Label_00_1238
	cp a, $E0
	jr c, Label_00_1237
	cp a, $F0
	jr c, Label_00_1238
	cp a, $F8
	jr c, Label_00_1237
	cp a, $FA
	jr c, Label_00_1238

; ---- code $1237-$123A (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 15 scenarios]

Label_00_1237:: ; 00:1237
	or a, a

Label_00_1238:: ; 00:1238
	jr nc, Label_00_120A

; ---- code $123A-$127A (64 bytes) [PROBABLE] 39 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	inc b
	jr z, Label_00_11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr Label_00_120A

Label_00_1242:: ; 00:1242
	ld a, [hli]
	or a, a
	jr z, Label_00_11FB
	cp a, $3E
	jr z, Label_00_11FB
	cp a, $27
	jr z, Label_00_11FF
	inc b
	jr z, Label_00_11FF
	cp a, $20
	jr c, Label_00_1242
	ld [de], a
	inc de
	cp a, $81
	jr c, Label_00_126F
	cp a, $A0
	jr c, Label_00_1270
	cp a, $E0
	jr c, Label_00_126F
	cp a, $F0
	jr c, Label_00_1270
	cp a, $F8
	jr c, Label_00_126F
	cp a, $FA
	jr c, Label_00_1270

Label_00_126F:: ; 00:126F
	or a, a

Label_00_1270:: ; 00:1270
	jr nc, Label_00_1242
	inc b
	jr z, Label_00_11FE
	ld a, [hli]
	ld [de], a
	inc de
	jr Label_00_1242

; ---- code $127A-$1289 (15 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 6 scenarios]

Label_00_127A:: ; 00:127A
	ld a, [hli]
	or a, a
	jp z, Label_00_1152
	cp a, $3E
	jp z, Label_00_1152
	cp a, $22
	jp z, Label_00_12C0

; ---- code $1289-$12C0 (55 bytes) [PROBABLE] 28 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	cp a, $27
	jp z, Label_00_12ED
	cp a, $21
	jr c, Label_00_127A
	dec hl

Label_00_1293:: ; 00:1293
	ld a, [hli]
	or a, a
	jp z, Label_00_1152
	cp a, $3E
	jp z, Label_00_1152
	cp a, $21
	jp c, Label_00_111C
	cp a, $81
	jr c, Label_00_12BA
	cp a, $A0
	jr c, Label_00_12BB
	cp a, $E0
	jr c, Label_00_12BA
	cp a, $F0
	jr c, Label_00_12BB
	cp a, $F8
	jr c, Label_00_12BA
	cp a, $FA
	jr c, Label_00_12BB

Label_00_12BA:: ; 00:12BA
	or a, a

Label_00_12BB:: ; 00:12BB
	jr nc, Label_00_1293
	ld a, [hli]
	jr Label_00_1293

; ---- code $12C0-$12D3 (19 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 6 scenarios]

Label_00_12C0:: ; 00:12C0
	ld a, [hli]
	or a, a
	jp z, Label_00_1152
	cp a, $3E
	jp z, Label_00_1152
	cp a, $22
	jp z, Label_00_111C
	cp a, $81
	jr c, Label_00_12E7

; ---- code $12D3-$12E7 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	cp a, $A0
	jr c, Label_00_12E8
	cp a, $E0
	jr c, Label_00_12E7
	cp a, $F0
	jr c, Label_00_12E8
	cp a, $F8
	jr c, Label_00_12E7
	cp a, $FA
	jr c, Label_00_12E8

; ---- code $12E7-$12EA (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 1119-131A by apply_coverage --split [executed in 6 scenarios]

Label_00_12E7:: ; 00:12E7
	or a, a

Label_00_12E8:: ; 00:12E8
	jr nc, Label_00_12C0

; ---- code $12EA-$131A (48 bytes) [PROBABLE] 25 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1119-131A by apply_coverage --split
	ld a, [hli]
	jr Label_00_12C0

Label_00_12ED:: ; 00:12ED
	ld a, [hli]
	or a, a
	jp z, Label_00_1152
	cp a, $3E
	jp z, Label_00_1152
	cp a, $27
	jp z, Label_00_111C
	cp a, $81
	jr c, Label_00_1314
	cp a, $A0
	jr c, Label_00_1315
	cp a, $E0
	jr c, Label_00_1314
	cp a, $F0
	jr c, Label_00_1315
	cp a, $F8
	jr c, Label_00_1314
	cp a, $FA
	jr c, Label_00_1315

Label_00_1314:: ; 00:1314
	or a, a

Label_00_1315:: ; 00:1315
	jr nc, Label_00_12ED
	ld a, [hli]
	jr Label_00_12ED
