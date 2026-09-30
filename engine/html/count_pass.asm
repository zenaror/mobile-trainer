; engine/html/count_pass.asm
; bank 74, $4F4F-$5252 (771 bytes); pinned by layout.link
; parser init and the list item counting pass

SECTION "engine/html/count_pass", ROMX

; ---- code $4F4F-$4FA6 (87 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_InitParser:: ; 74:4F4F
Function_74_4F4F::
	xor a, a
	ldh [hRam_FFB6], a
	ldh [hRam_FFB7], a
	ldh [hTextX + 1], a
	ldh [hRam_FFBF], a
	ldh [hRam_FFDF], a
	ldh [hRam_FFE0], a
	ld [wHtmlAlign], a
	ld [wHtmlAlignSp], a
	ldh [hRam_FFDA], a
	ldh [hRam_FFDB], a
	ld [wHtmlListDepth], a
	ldh [hRam_FFD8], a
	ldh [hRam_FFD9], a
	ld [wHtmlListCounter], a
	ld [wHtmlListCounter + 1], a
	ld [wHtmlBoldCount], a
	ld [wHtmlBoldCount + 1], a
	ldh [hRam_FFDC], a
	ldh [hRam_FFDD], a
	ld [wRam_C331], a
	ld [wRam_C332], a
	ld [wHtmlFlags], a
	ldh [hRam_FFD0], a
	ldh [hRam_FFD1], a
	ldh [hRam_FFD6], a
	ldh [hRam_FFD7], a
	ldh [hRam_FFD2], a
	ldh [hRam_FFD3], a
	ldh [hRam_FFD4], a
	ldh [hRam_FFD5], a
	ret

Function_74_4F97:: ; 74:4F97
	ld a, [wRam_C331]
	ld c, a
	ld a, [wRam_C332]
	ld b, a
	or a, c
	jr z, Label_74_4FB6
	ld a, e
	cp a, c
	jr nz, Label_74_4FAA

; ---- code $4FA6-$4FAA (4 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 74:4FA4 (executed)
	ld a, d
	cp a, b
	jr z, Label_74_4FB6

; ---- code $4FAA-$4FF2 (72 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)

Label_74_4FAA:: ; 74:4FAA
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine

Label_74_4FB6:: ; 74:4FB6
	xor a, a
	ld [wRam_C331], a
	ld [wRam_C332], a
	ret

Function_74_4FBE:: ; 74:4FBE
	ldh a, [hRam_FFBB]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, Label_74_4FDB
	ld a, d
	cp a, b
	jr nz, Label_74_4FDB
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	or a, c
	jr nz, Label_74_4FDB
	farcall Html_Layout_WrapRun
	ret

Label_74_4FDB:: ; 74:4FDB
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, $0C
	ldh [hRam_FFC7], a
	farcall Html_Layout_EndLine
	ret

; ---- code $4FF2-$5019 (39 bytes) [CONFIRMED] 164 insn(s) reached by static flow only; seeds: site x164; min discovery hops 1; entered by far from 74:4879 (PROBABLE code) | 21 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 5 scenarios]

Html_CountListItems:: ; 74:4FF2
	push bc
	push de
	push hl
	xor a, a
	ldh [hRam_FFD6], a
	ldh [hRam_FFD7], a

Label_74_4FFA:: ; 74:4FFA
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Label_74_508D
	cp a, $21
	jr c, Label_74_502F
	cp a, $3C
	jp z, Label_74_5091
	cp a, $26
	jr z, Label_74_5067
	ldh [hRam_FFB3], a
	cp a, $81
	jr c, Label_74_5029
	cp a, $A0
	jr c, Label_74_502A

; ---- code $5019-$5029 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split
	cp a, $E0
	jr c, Label_74_5029
	cp a, $F0
	jr c, Label_74_502A
	cp a, $F8
	jr c, Label_74_5029
	cp a, $FA
	jr c, Label_74_502A

; ---- code $5029-$5037 (14 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 5 scenarios]

Label_74_5029:: ; 74:5029
	or a, a

Label_74_502A:: ; 74:502A
	jr nc, Label_74_4FFA
	ld a, [hli]
	jr Label_74_4FFA

Label_74_502F:: ; 74:502F
	ld c, a
	ld a, [wHtmlFlags]
	and a, $08
	jr z, Label_74_504A

; ---- code $5037-$504A (19 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split
	ld a, c
	cp a, $0D
	jp z, Label_74_505E
	cp a, $0A
	jp z, Label_74_5064
	cp a, $09
	jr z, Label_74_505B
	ld c, $20
	jr Label_74_505B

; ---- code $504A-$505E (20 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 5 scenarios]

Label_74_504A:: ; 74:504A
	ld a, [hli]
	or a, a
	jr z, Label_74_508D
	cp a, $21
	jr c, Label_74_504A
	dec hl
	ldh a, [hRam_FFB3]
	cp a, $20
	jr z, Label_74_4FFA
	ld c, $20

Label_74_505B:: ; 74:505B
	jp Label_74_4FFA

; ---- code $505E-$508D (47 bytes) [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split

Label_74_505E:: ; 74:505E
	ld a, [hl]
	cp a, $0A
	jr nz, Label_74_5064
	inc hl

Label_74_5064:: ; 74:5064
	jp Label_74_4FFA

Label_74_5067:: ; 74:5067
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld bc, Html_EntityPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr z, Label_74_5084
	ldh [hRam_FFB3], a
	ld a, [hli]
	cp a, $3B
	jp z, Label_74_4FFA
	dec hl
	jp Label_74_4FFA

Label_74_5084:: ; 74:5084
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jp Label_74_4FFA

; ---- code $508D-$50D5 (72 bytes) [CONFIRMED] 41 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 4 scenarios]

Label_74_508D:: ; 74:508D
	pop hl
	pop de
	pop bc
	ret

Label_74_5091:: ; 74:5091
	ld a, [hl]
	ldh [hRam_FFB4], a
	cp a, $2F
	jr nz, Label_74_5099
	inc hl

Label_74_5099:: ; 74:5099
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ldh a, [hRam_FFB6]
	ld c, a
	ldh a, [hRam_FFB7]
	or a, c
	jp nz, Label_74_514E
	ld bc, Html_TagPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr nz, Label_74_50FB

Label_74_50B3:: ; 74:50B3
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a

Label_74_50B9:: ; 74:50B9
	ldh a, [hRam_FFB5]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D

Label_74_50C3:: ; 74:50C3
	ld a, $20
	ldh [hRam_FFB3], a

Label_74_50C7:: ; 74:50C7
	ld a, [hli]
	or a, a
	jp z, Label_74_508D
	cp a, $3E
	jp z, Label_74_4FFA
	cp a, $81
	jr c, Label_74_50E9

; ---- code $50D5-$50E9 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split
	cp a, $A0
	jr c, Label_74_50EA
	cp a, $E0
	jr c, Label_74_50E9
	cp a, $F0
	jr c, Label_74_50EA
	cp a, $F8
	jr c, Label_74_50E9
	cp a, $FA
	jr c, Label_74_50EA

; ---- code $50E9-$50ED (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 4 scenarios]

Label_74_50E9:: ; 74:50E9
	or a, a

Label_74_50EA:: ; 74:50EA
	jp nc, Label_74_50F1

; ---- code $50ED-$50F1 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split
	ld a, [hli]
	jp Label_74_50C7

; ---- code $50F1-$511A (41 bytes) [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4FF2-511A by apply_coverage --split [executed in 4 scenarios]

Label_74_50F1:: ; 74:50F1
	dec hl
	ld bc, $4110
	call Function_00_1119
	jp Label_74_50C7

Label_74_50FB:: ; 74:50FB
	cp a, $0F
	jr z, Label_74_510A
	ld b, a
	ld a, [hl]
	cp a, $3E
	jr z, Label_74_5109
	cp a, $21
	jr nc, Label_74_50C3

Label_74_5109:: ; 74:5109
	ld a, b

Label_74_510A:: ; 74:510A
	add a, a
	push hl
	add a, $1A
	ld l, a
	ld a, $00
	adc a, $51
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	push bc
	ret

; ---- ptrtable $511A-$513E (36 bytes) [PROBABLE] 18-word jump table: dispatcher at 74:510A-5119 (add a,a; push hl; add a,$1A; ld l,a; ld a,0; adc a,$51; ld h,a; ld a,[hli]; ld b,[hl]; ld c,a; pop hl; push bc; ret), same idiom as Table_74_44A0; the dispatcher is executed: traces/detail/*/dataaccess.tsv (browser scenarios) list rom_read 74 512E-5130 and 5134-5138, i.e. entries 10 ($50B3), 13 ($521B) and 14 ($5238) were fetched by 74:5114; the table extent (18 words) is by analogy with Table_74_44A0, hence PROBABLE; all 18 targets are code instruction starts: $50B3, $50B3, $513E, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $50B3, $51FE, $521B, $5238, $519A, $50B3, $51E4

Html_CountPassTagTable:: ; 74:511A
Table_74_511A::
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_513E
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_50B3
	dw Label_74_51FE
	dw Label_74_521B
	dw Label_74_5238
	dw Label_74_519A
	dw Label_74_50B3
	dw Label_74_51E4

; ---- code $513E-$51E4 (166 bytes) [PROBABLE] 86 insn(s) reached by static flow only; seeds: site x39, table x47; min discovery hops 0; run starts at an entry of the code-pointer table at 74:511A

Label_74_513E:: ; 74:513E
	ldh a, [hRam_FFB4]
	cp a, $2F
	jp z, Label_74_50B3
	ld a, e
	ldh [hRam_FFB6], a
	ld a, d
	ldh [hRam_FFB7], a
	jp Label_74_50B3

Label_74_514E:: ; 74:514E
	ld bc, Html_TitleTagPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr z, Label_74_5167
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr nz, Label_74_5167
	xor a, a
	ldh [hRam_FFB6], a
	ldh [hRam_FFB7], a
	jp Label_74_50B3

Label_74_5167:: ; 74:5167
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a

Label_74_516D:: ; 74:516D
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Label_74_508D
	cp a, $3E
	jp z, Label_74_4FFA
	cp a, $81
	jr c, Label_74_5192
	cp a, $A0
	jr c, Label_74_5193
	cp a, $E0
	jr c, Label_74_5192
	cp a, $F0
	jr c, Label_74_5193
	cp a, $F8
	jr c, Label_74_5192
	cp a, $FA
	jr c, Label_74_5193

Label_74_5192:: ; 74:5192
	or a, a

Label_74_5193:: ; 74:5193
	jp nc, Label_74_516D
	ld a, [hli]
	jp Label_74_516D

Label_74_519A:: ; 74:519A
	ld a, [hli]

Label_74_519B:: ; 74:519B
	or a, a
	jp z, Label_74_508D
	cp a, $2D
	jr z, Label_74_51C5
	cp a, $3E
	jr z, Label_74_51DD
	cp a, $81
	jr c, Label_74_51BF
	cp a, $A0
	jr c, Label_74_51C0
	cp a, $E0
	jr c, Label_74_51BF
	cp a, $F0
	jr c, Label_74_51C0
	cp a, $F8
	jr c, Label_74_51BF
	cp a, $FA
	jr c, Label_74_51C0

Label_74_51BF:: ; 74:51BF
	or a, a

Label_74_51C0:: ; 74:51C0
	jr nc, Label_74_519A
	ld a, [hli]
	jr Label_74_519A

Label_74_51C5:: ; 74:51C5
	ld a, [hli]
	cp a, $2D
	jr nz, Label_74_519B

Label_74_51CA:: ; 74:51CA
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Label_74_508D
	cp a, $2D
	jr nz, Label_74_51CA
	ld a, [hli]
	cp a, $2D
	jr nz, Label_74_51CA
	jr Label_74_519A

Label_74_51DD:: ; 74:51DD
	ld a, $20
	ldh [hRam_FFB3], a
	jp Label_74_4FFA

; ---- code $51E4-$51FE (26 bytes) [PROBABLE] table entry 18 (last word) of Table_74_511A ($51E4) validated jump-table target; decode chain cp $2F / jr z / ld a,[$C2C1] / or $08 ... jp $50B9 ends in unconditional jumps to known code and lands exactly on the next code region 51FE (also a table target)

Label_74_51E4:: ; 74:51E4
	cp a, $2F
	jr z, Label_74_51F3
	ld a, [wHtmlFlags]
	or a, $08
	ld [wHtmlFlags], a
	jp Label_74_50B9

Label_74_51F3:: ; 74:51F3
	ld a, [wHtmlFlags]
	and a, $F7
	ld [wHtmlFlags], a
	jp Label_74_50B9

; ---- code $51FE-$5252 (84 bytes) [CONFIRMED] 40 insn(s) reached by static flow only; seeds: table x40; min discovery hops 0; run starts at an entry of the code-pointer table at 74:511A [executed in 1 scenarios]

Label_74_51FE:: ; 74:51FE
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_520F
	ldh a, [hRam_FFD7]
	inc a
	jp z, Label_74_50B9
	ldh [hRam_FFD7], a
	jp Label_74_50B9

Label_74_520F:: ; 74:520F
	ldh a, [hRam_FFD7]
	or a, a
	jp z, Label_74_50B9
	dec a
	ldh [hRam_FFD7], a
	jp Label_74_50B9

Label_74_521B:: ; 74:521B
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_522C
	ldh a, [hRam_FFD7]
	inc a
	jp z, Label_74_50B9
	ldh [hRam_FFD7], a
	jp Label_74_50B9

Label_74_522C:: ; 74:522C
	ldh a, [hRam_FFD7]
	or a, a
	jp z, Label_74_508D
	dec a
	ldh [hRam_FFD7], a
	jp Label_74_50B9

Label_74_5238:: ; 74:5238
	ldh a, [hRam_FFB4]
	cp a, $2F
	jp z, Label_74_50B9
	ldh a, [hRam_FFD7]
	or a, a
	jp nz, Label_74_50B9
	ldh a, [hRam_FFD6]
	inc a
	ldh [hRam_FFD6], a
	cp a, $0A
	jp c, Label_74_50B9
	jp Label_74_508D
