; engine/html/tags.asm
; bank 74, $44A0-$4F4F (2735 bytes); pinned by layout.link
; tag handler table and Html_Tag_* handlers

SECTION "engine/html/tags", ROMX

; ---- ptrtable $44A0-$44C4 (36 bytes) [CONFIRMED] 18-word jump table indexed by the HTML tag id: dispatcher at 74:4490-449F (add a,a; add a,$A0; ld l,a; adc a,$44; ld h,a; ld a,[hli]; ld b,[hl]; ld c,a; push bc; ret) - executed in the homepage/monkey traces, which read entries 44A2-44BE as data; all 18 targets are instruction starts of code regions: $4439, $4623, $44C4, $462E, $464A, $4718, $472E, $4B98, $4CA6, $4DF9, $4A91, $4A32, $47AA, $4867, $493F, $45D9, $4698, $4666

Html_TagHandlerTable:: ; 74:44A0
Table_74_44A0::
	dw Label_74_4439
	dw Html_Tag_Html
	dw Html_Tag_Title
	dw Html_Tag_Head
	dw Html_Tag_Body
	dw Html_Tag_Center
	dw Html_Tag_Div
	dw Html_Tag_Br
	dw Html_Tag_Hr
	dw Html_Tag_Img
	dw Html_Tag_A
	dw Html_Tag_B
	dw Html_Tag_Ul
	dw Html_Tag_Ol
	dw Html_Tag_Li
	dw Html_Tag_Comment
	dw Html_Tag_Meta
	dw Html_Tag_Pre

; ---- code $44C4-$44EB (39 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)

Html_Tag_Title:: ; 74:44C4
	ldh a, [hRam_FFB4]
	cp a, $2F
	jp z, Label_74_4439
	ld a, e
	ldh [hRam_FFB6], a
	ld a, d
	ldh [hRam_FFB7], a
	jp Label_74_4439

Html_ParseSource_TitleTag:: ; 74:44D4
	ld bc, Html_TitleTagPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr z, Label_74_44EB
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr nz, Label_74_44EB
	call Html_StoreTitle
	jp Label_74_4439

; ---- code $44EB-$4530 (69 bytes) [PROBABLE] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 1; entered by jrcc from 74:44DD (executed)

Label_74_44EB:: ; 74:44EB
	ld a, $3C
	ld [de], a
	inc de
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a

Label_74_44F5:: ; 74:44F5
	call Function_00_0392
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Html_ParseSource_End
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jp z, Html_ParseSource_Loop
	cp a, $81
	jr c, Label_74_4526
	cp a, $A0
	jr c, Label_74_4527
	cp a, $E0
	jr c, Label_74_4526
	cp a, $F0
	jr c, Label_74_4527
	cp a, $F8
	jr c, Label_74_4526
	cp a, $FA
	jr c, Label_74_4527

Label_74_4526:: ; 74:4526
	or a, a

Label_74_4527:: ; 74:4527
	jp nc, Label_74_44F5
	ld a, [hli]
	ld [de], a
	inc de
	jp Label_74_44F5

; ---- code $4530-$455B (43 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_StoreTitle:: ; 74:4530
Function_74_4530::
	ldh a, [hRam_FFB8]
	ld l, a
	ldh a, [hRam_FFB9]
	ld h, a
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	ld a, [hl]
	or a, a
	ret nz
	ldh a, [hRam_FFB6]
	ld l, a
	ldh a, [hRam_FFB7]
	ld h, a
	ldh a, [hTextX]
	call BankSwitch_H
	push hl
	xor a, a
	ld c, a
	ld b, a
	ld e, a
	ld d, a

Label_74_454F:: ; 74:454F
	ld a, [hli]
	or a, a
	jr z, Label_74_45AA
	cp a, $81
	jr c, Label_74_456B
	cp a, $A0
	jr c, Label_74_456C

; ---- code $455B-$456B (16 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 74:4559 (executed) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 455B-456C by apply_coverage --split
	cp a, $E0
	jr c, Label_74_456B
	cp a, $F0
	jr c, Label_74_456C
	cp a, $F8
	jr c, Label_74_456B
	cp a, $FA
	jr c, Label_74_456C

; ---- code $456B-$456C (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 455B-456C by apply_coverage --split [executed in 3 scenarios]

Label_74_456B:: ; 74:456B
	or a, a

; ---- code $456C-$456F (3 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)

Label_74_456C:: ; 74:456C
	jp c, Label_74_457A

; ---- code $456F-$457A (11 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jpcc at 74:456C (executed) [executed in 1 scenarios]
	ld a, c
	cp a, $13
	jr nc, Label_74_4587
	ld d, e
	ld e, b
	ld b, c
	inc c
	jr Label_74_454F

; ---- code $457A-$4587 (13 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)

Label_74_457A:: ; 74:457A
	ld a, c
	cp a, $13
	jr nc, Label_74_4587
	ld a, [hli]
	ld d, e
	ld e, b
	ld b, c
	inc c
	inc c
	jr Label_74_454F

; ---- code $4587-$458C (5 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1; entered by jrcc from 74:457D (executed) | 3 insn(s) executed; cut out of the PROBABLE region 4587-45AA by apply_coverage --split [executed in 3 scenarios]

Label_74_4587:: ; 74:4587
	ld a, b
	cp a, $13
	jr c, Label_74_4592

; ---- code $458C-$4592 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4587-45AA by apply_coverage --split
	ld a, e
	cp a, $13
	jr c, Label_74_4592
	ld a, d

; ---- code $4592-$45AA (24 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4587-45AA by apply_coverage --split [executed in 3 scenarios]

Label_74_4592:: ; 74:4592
	ld de, $C340
	pop hl
	ld c, a
	ld b, $00
	push bc
	call CopyBytes
	pop bc
	ld a, $81
	ld [de], a
	inc de
	ld a, $63
	ld [de], a
	inc de
	inc bc
	inc bc
	jr Label_74_45B9

; ---- code $45AA-$45D9 (47 bytes) [CONFIRMED] 28 insn(s); 28 executed (in up to 2/18 scenarios)

Label_74_45AA:: ; 74:45AA
	ld de, $C340
	pop hl
	ld a, c
	or a, a
	jr z, Label_74_45B9
	ld b, $00
	push bc
	call CopyBytes
	pop bc

Label_74_45B9:: ; 74:45B9
	xor a, a
	ld [de], a
	ld hl, $C340
	ldh a, [hRam_FFB8]
	ld e, a
	ldh a, [hRam_FFB9]
	ld d, a
	ldh a, [hRam_FFBA]
	call BankSwitch_D
	inc bc
	call CopyBytes
	ldh a, [hRam_FFB6]
	ld e, a
	ldh a, [hRam_FFB7]
	ld d, a
	xor a, a
	ldh [hRam_FFB6], a
	ldh [hRam_FFB7], a
	ret

; ---- code $45D9-$45EE (21 bytes) [CONFIRMED] 39 insn(s) reached by static flow only; seeds: table x39; min discovery hops 0; run starts at an entry of the code-pointer table at 74:44A0 | 11 insn(s) executed; cut out of the PROBABLE region 45D9-4623 by apply_coverage --split [executed in 1 scenarios]

Html_Tag_Comment:: ; 74:45D9
	ld a, [hli]

Label_74_45DA:: ; 74:45DA
	or a, a
	jp z, Html_ParseSource_End
	cp a, $2D
	jr z, Label_74_4604
	cp a, $3E
	jr z, Label_74_461C
	cp a, $81
	jr c, Label_74_45FE
	cp a, $A0
	jr c, Label_74_45FF

; ---- code $45EE-$45FE (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 45D9-4623 by apply_coverage --split
	cp a, $E0
	jr c, Label_74_45FE
	cp a, $F0
	jr c, Label_74_45FF
	cp a, $F8
	jr c, Label_74_45FE
	cp a, $FA
	jr c, Label_74_45FF

; ---- code $45FE-$4623 (37 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 45D9-4623 by apply_coverage --split [executed in 1 scenarios]

Label_74_45FE:: ; 74:45FE
	or a, a

Label_74_45FF:: ; 74:45FF
	jr nc, Html_Tag_Comment
	ld a, [hli]
	jr Html_Tag_Comment

Label_74_4604:: ; 74:4604
	ld a, [hli]
	cp a, $2D
	jr nz, Label_74_45DA

Label_74_4609:: ; 74:4609
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $2D
	jr nz, Label_74_4609
	ld a, [hli]
	cp a, $2D
	jr nz, Label_74_4609
	jr Html_Tag_Comment

Label_74_461C:: ; 74:461C
	ld a, $20
	ldh [hRam_FFB3], a
	jp Html_ParseSource_Loop

; ---- code $4623-$464A (39 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Html_Tag_Html:: ; 74:4623
	ld a, [wHtmlFlags]
	or a, $01
	ld [wHtmlFlags], a
	jp Label_74_4439

Html_Tag_Head:: ; 74:462E
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_463F
	ld a, [wHtmlFlags]
	or a, $02
	ld [wHtmlFlags], a
	jp Label_74_4439

Label_74_463F:: ; 74:463F
	ld a, [wHtmlFlags]
	and a, $FD
	ld [wHtmlFlags], a
	jp Label_74_4439

; ---- code $464A-$4666 (28 bytes) [PROBABLE] 83 insn(s) reached by static flow only; seeds: site x72, table x11; min discovery hops 0; run starts at an entry of the code-pointer table at 74:44A0 | 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 464A-4718 by apply_coverage --split

Html_Tag_Body:: ; 74:464A
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_465B
	ld a, [wHtmlFlags]
	or a, $04
	ld [wHtmlFlags], a
	jp Label_74_4439

Label_74_465B:: ; 74:465B
	ld a, [wHtmlFlags]
	and a, $FB
	ld [wHtmlFlags], a
	jp Label_74_4439

; ---- code $4666-$46C1 (91 bytes) [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 464A-4718 by apply_coverage --split [executed in 4 scenarios]

Html_Tag_Pre:: ; 74:4666
	farcall Html_Layout_WrapRun
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_4683
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	or a, $08
	ld [wHtmlFlags], a
	jp Label_74_443F

Label_74_4683:: ; 74:4683
	ld a, $0C
	ldh [hRam_FFC7], a
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	and a, $F7
	ld [wHtmlFlags], a
	jp Label_74_443F

Html_Tag_Meta:: ; 74:4698
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, [wHtmlFlags]
	and a, $02
	jp z, Label_74_443F
	ld bc, $4033
	call Function_00_1119
	cp a, $01
	jr z, Label_74_46C1
	cp a, $02
	jr z, Label_74_46DE
	cp a, $03
	jr z, Label_74_46FB
	jp Label_74_443F

; ---- code $46C1-$4718 (87 bytes) [PROBABLE] 42 insn(s) never executed in the traced runs; cut out of the PROBABLE region 464A-4718 by apply_coverage --split

Label_74_46C1:: ; 74:46C1
	push hl
	push de
	ld hl, $C380
	ld de, $D300
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wRam_D33F], a
	pop de
	pop hl
	jp Label_74_443F

Label_74_46DE:: ; 74:46DE
	push hl
	push de
	ld hl, $C380
	ld de, $D340
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wRam_D37F], a
	pop de
	pop hl
	jp Label_74_443F

Label_74_46FB:: ; 74:46FB
	push hl
	push de
	ld hl, $C380
	ld de, $D380
	ld bc, $0040
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	xor a, a
	ld [wRam_D3BF], a
	pop de
	pop hl
	jp Label_74_443F

; ---- code $4718-$472E (22 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Html_Tag_Center:: ; 74:4718
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_4740
	ld b, $08
	jr Label_74_4788

; ---- code $472E-$4740 (18 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: site x5; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code [executed in 2 scenarios]

Html_Tag_Div:: ; 74:472E
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr nz, Label_74_4761

; ---- code $4740-$4761 (33 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)

Label_74_4740:: ; 74:4740
	ld a, [wHtmlAlignSp]
	ld [wHtmlAlign], a
	or a, a
	jp z, Label_74_443F
	push hl
	ld h, $D0
	ld l, a
	dec hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	ld [wHtmlAlign], a
	ld a, l
	ld [wHtmlAlignSp], a
	pop hl
	jp Label_74_443F

; ---- code $4761-$4788 (39 bytes) [CONFIRMED] 20 insn(s) reached by static flow only; seeds: site x20; min discovery hops 1; entered by jrcc from 74:473E (PROBABLE code) [executed in 1 scenarios]

Label_74_4761:: ; 74:4761
	ld bc, $406D
	call Function_00_1119
	or a, a
	jp z, Label_74_443F
	push de
	push hl
	ld hl, $C380
	ld bc, Html_AlignValuePtrs
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	call Function_00_10E9
	pop hl
	pop de
	or a, a
	jp z, Label_74_443F
	and a, $0C
	jp z, Label_74_443F
	ld b, a

; ---- code $4788-$481A (146 bytes) [CONFIRMED] 71 insn(s); 71 executed (in up to 1/18 scenarios)

Label_74_4788:: ; 74:4788
	ld a, [wHtmlAlignSp]
	cp a, $FF
	jp z, Label_74_443F
	push hl
	ld h, $D0
	ld l, a
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlAlign]
	ld [hli], a
	ld a, l
	ld [wHtmlAlignSp], a
	ld a, b
	ld [wHtmlAlign], a
	pop hl
	jp Label_74_443F

Html_Tag_Ul:: ; 74:47AA
	farcall Function_74_4F97
	farcall Function_74_4FBE
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_47F9
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	cp a, $FF
	jr z, Label_74_47E0
	ld c, a
	ld b, $00
	inc a
	ld [wHtmlListDepth], a
	ld hl, $D100
	add hl, bc
	add hl, bc
	ld a, [wHtmlListCounter]
	ld [hli], a
	ld a, [wHtmlListCounter + 1]
	or a, $80
	ld [hli], a

Label_74_47E0:: ; 74:47E0
	pop hl
	ld a, $00
	ld [wHtmlListCounter], a
	ld a, $3F
	ld [wHtmlListCounter + 1], a
	ldh a, [hRam_FFD9]
	add a, $0C
	jp c, Label_74_443F
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	jp Label_74_443F

Label_74_47F9:: ; 74:47F9
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr z, Label_74_4853

Label_74_4808:: ; 74:4808
	ld [wHtmlListDepth], a
	ld c, a
	ld b, $00
	ld hl, $D100
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr nz, Label_74_4840

; ---- code $481A-$4840 (38 bytes) [PROBABLE] 20 insn(s) reached by static flow only; seeds: exec x20; min discovery hops 0; fall-through of the jrcc at 74:4818 (executed)
	ld c, $0C
	bit 6, b
	jr z, Label_74_4822
	ld c, $12

Label_74_4822:: ; 74:4822
	ldh a, [hRam_FFD9]
	sub a, c
	jr nc, Label_74_4828
	xor a, a

Label_74_4828:: ; 74:4828
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr nz, Label_74_4808
	ld a, $01
	ld [wHtmlListDepth], a
	ld a, c
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	jr Label_74_4853

; ---- code $4840-$484E (14 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_74_4840:: ; 74:4840
	ld a, c
	ld [wHtmlListCounter], a
	ld a, b
	ld [wHtmlListCounter + 1], a
	ldh a, [hRam_FFD9]
	sub a, $0C
	jr nc, Label_74_484F

; ---- code $484E-$484F (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 74:484C (executed)
	xor a, a

; ---- code $484F-$4867 (24 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_74_484F:: ; 74:484F
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a

Label_74_4853:: ; 74:4853
	ld a, [wHtmlListDepth]
	or a, a
	jr nz, Label_74_4863
	ld a, $0C
	ldh [hRam_FFC7], a
	farcall Html_Layout_EndLine

Label_74_4863:: ; 74:4863
	pop hl
	jp Label_74_443F

; ---- code $4867-$48F1 (138 bytes) [CONFIRMED] 104 insn(s) reached by static flow only; seeds: site x104; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 66 insn(s) executed; cut out of the PROBABLE region 4867-493F by apply_coverage --split [executed in 1 scenarios]

Html_Tag_Ol:: ; 74:4867
	farcall Function_74_4F97
	farcall Function_74_4FBE
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_48D0
	farcall Html_CountListItems
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	cp a, $FF
	jr z, Label_74_48AE
	ld c, a
	ld b, $00
	inc a
	ld [wHtmlListDepth], a
	ld hl, $D100
	add hl, bc
	add hl, bc
	ld c, $00
	ldh a, [hRam_FFD6]
	cp a, $0A
	jr c, Label_74_48A3
	ld c, $40

Label_74_48A3:: ; 74:48A3
	ld a, [wHtmlListCounter]
	ld [hli], a
	ld a, [wHtmlListCounter + 1]
	and a, $7F
	or a, c
	ld [hli], a

Label_74_48AE:: ; 74:48AE
	pop hl
	ld c, $0C
	ldh a, [hRam_FFD6]
	cp a, $0A
	jr c, Label_74_48B9
	ld c, $12

Label_74_48B9:: ; 74:48B9
	ld a, $01
	ld [wHtmlListCounter], a
	ld a, $00
	ld [wHtmlListCounter + 1], a
	ldh a, [hRam_FFD9]
	add a, c
	jp c, Label_74_443F
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	jp Label_74_443F

Label_74_48D0:: ; 74:48D0
	push hl
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr z, Label_74_492B

Label_74_48DF:: ; 74:48DF
	ld [wHtmlListDepth], a
	ld c, a
	ld b, $00
	ld hl, $D100
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld b, [hl]
	bit 7, b
	jr z, Label_74_4911

; ---- code $48F1-$4911 (32 bytes) [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4867-493F by apply_coverage --split
	ldh a, [hRam_FFD9]
	sub a, $0C
	jr nc, Label_74_48F8
	xor a, a

Label_74_48F8:: ; 74:48F8
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	ld a, [wHtmlListDepth]
	dec a
	cp a, $FF
	jr nz, Label_74_48DF
	ld a, $01
	ld [wHtmlListDepth], a
	ld a, $0C
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a
	jr Label_74_492B

; ---- code $4911-$493F (46 bytes) [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4867-493F by apply_coverage --split [executed in 1 scenarios]

Label_74_4911:: ; 74:4911
	ld a, c
	ld [wHtmlListCounter], a
	ld a, b
	ld [wHtmlListCounter + 1], a
	ld c, $0C
	bit 6, b
	jr z, Label_74_4921
	ld c, $12

Label_74_4921:: ; 74:4921
	ldh a, [hRam_FFD9]
	sub a, c
	jr nc, Label_74_4927
	xor a, a

Label_74_4927:: ; 74:4927
	ldh [hRam_FFD9], a
	ldh [hRam_FFD8], a

Label_74_492B:: ; 74:492B
	ld a, [wHtmlListDepth]
	or a, a
	jr nz, Label_74_493B
	ld a, $0C
	ldh [hRam_FFC7], a
	farcall Html_Layout_EndLine

Label_74_493B:: ; 74:493B
	pop hl
	jp Label_74_443F

; ---- code $493F-$4987 (72 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 1/18 scenarios)

Html_Tag_Li:: ; 74:493F
	farcall Function_74_4F97
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr z, Label_74_4987
	ld a, [wHtmlListCounter]
	ld c, a
	ld a, [wHtmlListCounter + 1]
	and a, $3F
	ld b, a
	cp a, $3F
	jr nz, Label_74_4997

Label_74_4959:: ; 74:4959
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Label_74_4973
	ld a, $95
	add a, c
	ld c, a
	ld a, $49
	adc a, $00
	ld b, a
	ld a, [bc]
	ld [de], a
	inc de
	inc bc
	ld a, [bc]
	ld [de], a
	inc de

Label_74_4973:: ; 74:4973
	ldh a, [hRam_FFD8]
	sub a, $0C
	jr nc, Label_74_497A
	xor a, a

Label_74_497A:: ; 74:497A
	ldh [hRam_FFD8], a
	ld a, e
	ld [wRam_C331], a
	ld a, d
	ld [wRam_C331], a
	jp Label_74_443F

; ---- code $4987-$4995 (14 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1; entered by jrcc from 74:4949 (executed)

Label_74_4987:: ; 74:4987
	ldh a, [hRam_FFD9]
	ldh [hRam_FFD8], a
	xor a, a
	ld [wRam_C331], a
	ld [wRam_C331], a
	jp Label_74_443F

; ---- data $4995-$4997 (2 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Html_ListBullet:: ; 74:4995
Data_74_4995::
	db $81, $45

; ---- code $4997-$49D2 (59 bytes) [CONFIRMED] 94 insn(s) reached by static flow only; seeds: exec x94; min discovery hops 1; entered by jrcc from 74:4957 (executed) | 38 insn(s) executed; cut out of the PROBABLE region 4997-4A32 by apply_coverage --split [executed in 5 scenarios]

Label_74_4997:: ; 74:4997
	or a, c
	jr z, Label_74_4959
	inc de
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	dec de
	jp z, Label_74_443F
	push bc
	push hl
	ld h, b
	ld l, c
	ld bc, $FF9C
	ld a, $FF

Label_74_49B1:: ; 74:49B1
	inc a
	add hl, bc
	bit 7, h
	jr z, Label_74_49B1
	ld bc, $0064
	add hl, bc
	or a, a
	jr nz, Label_74_49D2
	ld bc, $FFF6
	ld a, $FF

Label_74_49C3:: ; 74:49C3
	inc a
	add hl, bc
	bit 7, h
	jr z, Label_74_49C3
	ld bc, $000A
	add hl, bc
	or a, a
	jr nz, Label_74_49EE
	jr Label_74_49FB

; ---- code $49D2-$49EE (28 bytes) [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4997-4A32 by apply_coverage --split

Label_74_49D2:: ; 74:49D2
	add a, $30
	ld [de], a
	inc de
	ldh a, [hRam_FFD8]
	sub a, $06
	jr nc, Label_74_49DD
	xor a, a

Label_74_49DD:: ; 74:49DD
	ldh [hRam_FFD8], a
	ld bc, $FFF6
	ld a, $FF

Label_74_49E4:: ; 74:49E4
	inc a
	add hl, bc
	bit 7, h
	jr z, Label_74_49E4
	ld bc, $000A
	add hl, bc

; ---- code $49EE-$4A14 (38 bytes) [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 4997-4A32 by apply_coverage --split [executed in 1 scenarios]

Label_74_49EE:: ; 74:49EE
	add a, $30
	ld [de], a
	inc de
	ldh a, [hRam_FFD8]
	sub a, $06
	jr nc, Label_74_49F9
	xor a, a

Label_74_49F9:: ; 74:49F9
	ldh [hRam_FFD8], a

Label_74_49FB:: ; 74:49FB
	ld a, l
	add a, $30
	ld [de], a
	inc de
	ld a, $2E
	ld [de], a
	inc de
	pop hl
	ldh a, [hRam_FFD8]
	sub a, $0C
	jr nc, Label_74_4A0C
	xor a, a

Label_74_4A0C:: ; 74:4A0C
	ldh [hRam_FFD8], a
	pop bc
	ld a, c
	cp a, $63
	jr nz, Label_74_4A19

; ---- code $4A14-$4A19 (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4997-4A32 by apply_coverage --split
	ld a, b
	cp a, $00
	jr z, Label_74_4A27

; ---- code $4A19-$4A32 (25 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 4997-4A32 by apply_coverage --split [executed in 5 scenarios]

Label_74_4A19:: ; 74:4A19
	inc bc
	ld a, c
	ld [wHtmlListCounter], a
	ld a, [wHtmlListCounter + 1]
	and a, $C0
	or a, b
	ld [wHtmlListCounter + 1], a

Label_74_4A27:: ; 74:4A27
	ld a, e
	ld [wRam_C331], a
	ld a, d
	ld [wRam_C331], a
	jp Label_74_443F

; ---- code $4A32-$4AA4 (114 bytes) [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios)

Html_Tag_B:: ; 74:4A32
	farcall Html_Layout_WrapRun
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr nz, Label_74_4A6D
	ld a, [wHtmlBoldCount]
	ld c, a
	ld a, [wHtmlBoldCount + 1]
	or a, c
	jp z, Label_74_443F
	ld a, [wHtmlBoldCount]
	sub a, $01
	ld [wHtmlBoldCount], a
	ld a, [wHtmlBoldCount + 1]
	sbc a, $00
	ld [wHtmlBoldCount + 1], a
	ldh a, [hRam_FFB2]
	and a, $03
	cp a, $02
	jp nz, Label_74_443F
	ldh a, [hRam_FFB2]
	and a, $FC
	or a, $00
	ldh [hRam_FFB2], a
	jp Label_74_443F

Label_74_4A6D:: ; 74:4A6D
	ld a, [wHtmlBoldCount]
	add a, $01
	ld [wHtmlBoldCount], a
	ld a, [wHtmlBoldCount + 1]
	adc a, $00
	ld [wHtmlBoldCount + 1], a
	ldh a, [hRam_FFB2]
	and a, $03
	cp a, $01
	jp z, Label_74_443F
	ldh a, [hRam_FFB2]
	and a, $FC
	or a, $02
	ldh [hRam_FFB2], a
	jp Label_74_443F

Html_Tag_A:: ; 74:4A91
	ldh a, [hRam_FFB4]
	cp a, $2F
	jr nz, Label_74_4AD5
	ldh a, [hRam_FFDC]
	ld c, a
	ldh a, [hRam_FFDD]
	ld b, a
	or a, c
	jr z, Label_74_4AB8
	ld a, e
	cp a, c
	jr nz, Label_74_4AB8

; ---- code $4AA4-$4AB8 (20 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0; fall-through of the jrcc at 74:4AA2 (executed)
	ld a, d
	cp a, b
	jr nz, Label_74_4AB8
	ldh a, [hRam_FFB2]
	and a, $03
	cp a, $01
	jp nz, Label_74_4AB8
	ldh a, [hRam_FFDF]
	dec a
	ldh [hRam_FFDF], a
	jr Label_74_4ABE

; ---- code $4AB8-$4AE5 (45 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 2/18 scenarios)

Label_74_4AB8:: ; 74:4AB8
	farcall Html_Layout_WrapRun

Label_74_4ABE:: ; 74:4ABE
	ldh a, [hRam_FFB2]
	and a, $03
	cp a, $01
	jp nz, Label_74_443F
	ldh a, [hRam_FFB2]
	and a, $FC
	ldh [hRam_FFB2], a
	xor a, a
	ldh [hRam_FFDC], a
	ldh [hRam_FFDD], a
	jp Label_74_443F

Label_74_4AD5:: ; 74:4AD5
	farcall Html_Layout_WrapRun
	ld bc, $4078
	call Function_00_1119
	cp a, $01
	jr z, Label_74_4B21

; ---- code $4AE5-$4B21 (60 bytes) [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 0; fall-through of the jrcc at 74:4AE3 (executed) [executed in 3 scenarios]
	cp a, $02
	jp nz, Label_74_443F
	push de
	push hl
	ld a, [wHtmlLinkHeapPtr]
	ld e, a
	ld a, [wHtmlLinkHeapPtr + 1]
	ld d, a
	cp a, $E0
	jp z, Label_74_4B81
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [de], a
	ld hl, $DFFE
	ld bc, $D600
	farcall Html_StringTable_Add
	or a, a
	jr nz, Label_74_4B6D
	ldh a, [hRam_FFC8]
	ld [hli], a
	ldh a, [hRam_FFC9]
	ld [hli], a
	ld a, l
	ld [wHtmlLinkHeapPtr], a
	ld a, h
	ld [wHtmlLinkHeapPtr + 1], a
	jr Label_74_4B6D

; ---- code $4B21-$4B81 (96 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)

Label_74_4B21:: ; 74:4B21
	ldh a, [hRam_FFB2]
	and a, $FC
	or a, $01
	ldh [hRam_FFB2], a
	ldh a, [hRam_FFDF]
	inc a
	ldh [hRam_FFDF], a
	push de
	push hl
	ld a, [wHtmlLinkHeapPtr]
	ld e, a
	ld a, [wHtmlLinkHeapPtr + 1]
	ld d, a
	cp a, $E0
	jr z, Label_74_4B81
	push bc
	push de
	ld hl, $C380
	farcall HtmlUrl_GetSchemeId
	pop de
	pop bc
	cp a, $FF
	jr z, Label_74_4B81
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [de], a
	ld hl, $DFFE
	ld bc, $D600
	farcall Html_StringTable_Add
	or a, a
	jr nz, Label_74_4B6D
	ld a, l
	ld [wHtmlLinkHeapPtr], a
	ld a, h
	ld [wHtmlLinkHeapPtr + 1], a

Label_74_4B6D:: ; 74:4B6D
	ld a, d
	inc d
	jr z, Label_74_4B81
	ld a, e
	ldh [hRam_FFE0], a
	pop hl
	pop de
	ldh a, [hRam_FFBB]
	ldh [hRam_FFDC], a
	ldh a, [hTextY]
	ldh [hRam_FFDD], a
	jp Label_74_443F

; ---- code $4B81-$4B98 (23 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 74:4B3A (executed) [executed in 1 scenarios]

Label_74_4B81:: ; 74:4B81
	pop hl
	pop de
	ldh a, [hRam_FFB2]
	and a, $FC
	ldh [hRam_FFB2], a
	ldh a, [hRam_FFDF]
	dec a
	ldh [hRam_FFDF], a
	xor a, a
	ldh [hRam_FFE0], a
	ldh [hRam_FFDC], a
	ldh [hRam_FFDD], a
	jp Label_74_443F

; ---- code $4B98-$4BA1 (9 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)

Html_Tag_Br:: ; 74:4B98
	ld bc, $4057
	call Function_00_1119
	or a, a
	jr z, Label_74_4BB9

; ---- code $4BA1-$4BB8 (23 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 74:4B9F (executed) | 13 insn(s) executed; cut out of the PROBABLE region 4BA1-4BB9 by apply_coverage --split [executed in 1 scenarios]
	push de
	push hl
	ld hl, $C380
	ld bc, Html_ClearValuePtrs
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	call Function_00_10E9
	pop hl
	pop de
	cp a, $04
	jr c, Label_74_4BB9

; ---- code $4BB8-$4BB9 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BA1-4BB9 by apply_coverage --split
	xor a, a

; ---- code $4BB9-$4BD2 (25 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)

Label_74_4BB9:: ; 74:4BB9
	ld [wHtmlBrClear], a
	ldh a, [hRam_FFBB]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, Label_74_4BD8
	ld a, d
	cp a, b
	jr nz, Label_74_4BD8
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	or a, c
	jr nz, Label_74_4BD8

; ---- code $4BD2-$4BD8 (6 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 74:4BD0 (executed) [executed in 1 scenarios]
	ld a, $0C
	ldh [hRam_FFC7], a
	jr Label_74_4BDE

; ---- code $4BD8-$4BEC (20 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_74_4BD8:: ; 74:4BD8
	farcall Html_Layout_WrapRun

Label_74_4BDE:: ; 74:4BDE
	farcall Html_Layout_EndLine
	push de
	push hl
	ld a, [wHtmlBrClear]
	call JumpTableInline

; ---- ptrtable $4BEC-$4BF4 (8 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 74:4BE9: 4 entries; end = first entry target

Html_BrClearJumpTable:: ; 74:4BEC
Table_74_4BEC::
	dw Label_74_4C2E
	dw Label_74_4BF4
	dw Label_74_4C12
	dw Label_74_4C33

; ---- code $4BF4-$4C2E (58 bytes) [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1; entered by table from 74:4BE9 (executed) [executed in 1 scenarios]

Label_74_4BF4:: ; 74:4BF4
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hRam_FFC4]
	cp a, e
	jr nz, Label_74_4C5F
	ldh a, [hRam_FFC5]
	cp a, d
	jr nz, Label_74_4C5F
	jr Label_74_4C2E

Label_74_4C12:: ; 74:4C12
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hRam_FFC2]
	cp a, e
	jr nz, Label_74_4C5F
	ldh a, [hRam_FFC3]
	cp a, d
	jr nz, Label_74_4C5F

; ---- code $4C2E-$4C33 (5 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_74_4C2E:: ; 74:4C2E
	pop hl
	pop de
	jp Label_74_443F

; ---- code $4C33-$4C5F (44 bytes) [CONFIRMED] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 1; entered by table from 74:4BE9 (executed) | 25 insn(s) executed; cut out of the PROBABLE region 4C33-4CA6 by apply_coverage --split [executed in 1 scenarios]

Label_74_4C33:: ; 74:4C33
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hViewX]
	ld e, a
	ldh a, [hViewX + 1]
	ld d, a
	ldh a, [hRam_FFC4]
	cp a, e
	jr nz, Label_74_4C5F
	ldh a, [hRam_FFC5]
	cp a, d
	jr nz, Label_74_4C5F
	ldh a, [hViewRight]
	ld e, a
	ldh a, [hViewRight + 1]
	ld d, a
	ldh a, [hRam_FFC2]
	cp a, e
	jr nz, Label_74_4C5F
	ldh a, [hRam_FFC3]
	cp a, d
	jr z, Label_74_4C2E

; ---- code $4C5F-$4C6B (12 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C33-4CA6 by apply_coverage --split

Label_74_4C5F:: ; 74:4C5F
	pop hl
	pop de
	ld a, $0C
	ldh [hRam_FFC7], a
	xor a, a
	ldh [hRam_FFC6], a
	jp Label_74_4BDE

; ---- code $4C6B-$4CA6 (59 bytes) [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4C33-4CA6 by apply_coverage --split [executed in 1 scenarios]

Html_ParseSource_PreCR:: ; 74:4C6B
	ld a, [hl]
	cp a, $0A
	jr nz, Label_74_4C71
	inc hl

Label_74_4C71:: ; 74:4C71
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ldh a, [hRam_FFBB]
	ld c, a
	ldh a, [hTextY]
	ld b, a
	ld a, e
	cp a, c
	jr nz, Label_74_4C93
	ld a, d
	cp a, b
	jr nz, Label_74_4C93
	ldh a, [hRam_FFC6]
	ld c, a
	ldh a, [hRam_FFC7]
	or a, c
	jr nz, Label_74_4C93
	ld a, $0C
	ldh [hRam_FFC7], a
	jr Label_74_4C99

Label_74_4C93:: ; 74:4C93
	farcall Html_Layout_WrapRun

Label_74_4C99:: ; 74:4C99
	farcall Html_Layout_EndLine
	ld a, $20
	ldh [hRam_FFB3], a
	jp Html_ParseSource_Loop

; ---- code $4CA6-$4CD1 (43 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 2/18 scenarios)

Html_Tag_Hr:: ; 74:4CA6
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	ld a, [wHtmlAlign]
	push af
	ldh a, [hViewX]
	ld c, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewX + 1]
	ld b, a
	ldh a, [hViewRight + 1]
	sbc a, b
	ld b, a
	push bc
	ld bc, $4062
	call Function_00_1119
	pop bc
	push hl
	push de
	or a, a
	jr z, Label_74_4CF2

; ---- code $4CD1-$4CE0 (15 bytes) [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0; fall-through of the jrcc at 74:4CCF (executed) | 7 insn(s) executed; cut out of the PROBABLE region 4CD1-4CF2 by apply_coverage --split [executed in 3 scenarios]
	push bc
	ld hl, $C380
	farcall Html_ParseDecimal
	inc c
	dec c
	pop bc
	jr z, Label_74_4CE2

; ---- code $4CE0-$4CE2 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CD1-4CF2 by apply_coverage --split
	jr Label_74_4CF2

; ---- code $4CE2-$4CF2 (16 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4CD1-4CF2 by apply_coverage --split [executed in 1 scenarios]

Label_74_4CE2:: ; 74:4CE2
	cp a, $25
	jr nz, Label_74_4CF0
	farcall Multiply16
	ld b, h
	ld c, l
	jr Label_74_4CF2

Label_74_4CF0:: ; 74:4CF0
	ld b, d
	ld c, e

; ---- code $4CF2-$4D1E (44 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)

Label_74_4CF2:: ; 74:4CF2
	push bc
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	farcall Html_Layout_GetLimitsAtY
	ldh a, [hRam_FFC4]
	ld c, a
	ldh a, [hRam_FFC2]
	sub a, c
	ldh [hRam_FFC0], a
	ldh a, [hRam_FFC5]
	ld b, a
	ldh a, [hRam_FFC3]
	sbc a, b
	ldh [hRam_FFC1], a
	pop hl
	ldh a, [hRam_FFC0]
	sub a, l
	ldh a, [hRam_FFC1]
	sbc a, h
	ld de, $FFF4
	ld bc, $FFFF
	jr nc, Label_74_4D24

; ---- code $4D1E-$4D24 (6 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 74:4D1C (executed) [executed in 3 scenarios]
	ldh a, [hRam_FFC0]
	ld l, a
	ldh a, [hRam_FFC1]
	ld h, a

; ---- code $4D24-$4D40 (28 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Label_74_4D24:: ; 74:4D24
	ld a, l
	or a, h
	jr z, Label_74_4D2C
	inc bc
	add hl, de
	jr c, Label_74_4D24

Label_74_4D2C:: ; 74:4D2C
	push hl
	ld a, [wHtmlAlign]
	and a, $0C
	jr nz, Label_74_4D40
	ld a, [wHtmlAlign]
	and a, $F3
	or a, $08
	ld [wHtmlAlign], a
	jr Label_74_4D44

; ---- code $4D40-$4D44 (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 74:4D32 (executed)

Label_74_4D40:: ; 74:4D40
	cp a, $0C
	jr z, Label_74_4D4D

; ---- code $4D44-$4DBE (122 bytes) [CONFIRMED] 77 insn(s); 77 executed (in up to 2/18 scenarios)

Label_74_4D44:: ; 74:4D44
	dec hl
	ld a, l
	cpl
	ldh [hRam_FFDA], a
	ld a, h
	cpl
	ldh [hRam_FFDB], a

Label_74_4D4D:: ; 74:4D4D
	pop hl
	ld de, $83E6
	add hl, de
	pop de
	ldh a, [hTextX]
	call BankSwitch_D
	inc c
	dec c
	jr z, Label_74_4D73

Label_74_4D5C:: ; 74:4D5C
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	jp z, Label_74_4D8E
	ld a, $83
	ld [de], a
	inc de
	ld a, $E6
	ld [de], a
	inc de
	dec c
	jr nz, Label_74_4D5C

Label_74_4D73:: ; 74:4D73
	inc de
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	dec de
	jp z, Label_74_4D8E
	ld a, l
	cp a, $DB
	jr c, Label_74_4D8E
	cp a, $E7
	jr nc, Label_74_4D8E
	ld a, h
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	inc de

Label_74_4D8E:: ; 74:4D8E
	xor a, a
	ld [de], a
	inc de
	pop hl
	ldh a, [hRam_FFB2]
	push af
	and a, $FC
	ldh [hRam_FFB2], a
	farcall Html_Layout_WrapRun
	farcall Html_Layout_EndLine
	xor a, a
	ldh [hRam_FFDA], a
	ldh [hRam_FFDB], a
	pop af
	ldh [hRam_FFB2], a
	pop af
	ld [wHtmlAlign], a
	ld a, $20
	ldh [hRam_FFB3], a

Label_74_4DB5:: ; 74:4DB5
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jr z, Label_74_4DE8

; ---- code $4DBE-$4DE8 (42 bytes) [PROBABLE] 20 insn(s) reached by static flow only; seeds: exec x20; min discovery hops 0; fall-through of the jrcc at 74:4DBC (executed)
	cp a, $81
	jr c, Label_74_4DD6
	cp a, $A0
	jr c, Label_74_4DD7
	cp a, $E0
	jr c, Label_74_4DD6
	cp a, $F0
	jr c, Label_74_4DD7
	cp a, $F8
	jr c, Label_74_4DD6
	cp a, $FA
	jr c, Label_74_4DD7

Label_74_4DD6:: ; 74:4DD6
	or a, a

Label_74_4DD7:: ; 74:4DD7
	jp nc, Label_74_4DDE
	ld a, [hli]
	jp Label_74_4DB5

Label_74_4DDE:: ; 74:4DDE
	dec hl
	ld bc, $4110
	call Function_00_1119
	jp Label_74_4DB5

; ---- code $4DE8-$4DF9 (17 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)

Label_74_4DE8:: ; 74:4DE8
	ld a, [hl]
	cp a, $0D
	jp nz, Label_74_4DF0
	inc hl
	ld a, [hl]

Label_74_4DF0:: ; 74:4DF0
	cp a, $0A
	jp nz, Html_ParseSource_Loop
	inc hl
	jp Html_ParseSource_Loop

; ---- code $4DF9-$4E5A (97 bytes) [CONFIRMED] 180 insn(s) reached by static flow only; seeds: site x164, table x16; min discovery hops 0; run starts at an entry of the code-pointer table at 74:44A0 | 46 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split [executed in 2 scenarios]

Html_Tag_Img:: ; 74:4DF9
	ld a, [wHtmlScanOnly]
	or a, a
	jp nz, Label_74_4F09
	ldh a, [hRam_FFB4]
	cp a, $2F
	jp z, Label_74_443F
	xor a, a
	ldh [hRam_FFD2], a
	ldh [hRam_FFD3], a
	ldh [hRam_FFD4], a
	ldh [hRam_FFD5], a
	ldh [hRam_FFD6], a
	ldh [hRam_FFD7], a

Label_74_4E14:: ; 74:4E14
	ld bc, $408A
	call Function_00_1119
	cp a, $01
	jp z, Label_74_4E6B
	cp a, $02
	jp z, Label_74_4EB1
	push de
	push hl
	ldh a, [hRam_FFD2]
	ld l, a
	ldh a, [hRam_FFD3]
	ld h, a
	ldh a, [hRam_FFD4]
	or a, h
	or a, l
	jp z, Label_74_4ECD
	ldh a, [hRam_FFD4]
	farcall Html_NextResourceRecord
	farcall Bmp_Validate
	or a, a
	jp z, Label_74_4ECD
	pop hl
	pop de
	farcall Html_Layout_WrapRun
	push de
	push hl
	ldh a, [hRam_FFB2]
	push af
	and a, $03
	ld c, a
	ldh a, [hRam_FFD5]
	or a, a
	jr z, Label_74_4E5D

; ---- code $4E5A-$4E5D (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split
	or a, c
	ldh [hRam_FFB2], a

; ---- code $4E5D-$4EB1 (84 bytes) [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split [executed in 1 scenarios]

Label_74_4E5D:: ; 74:4E5D
	farcall Html_Layout_PlaceImage
	pop af
	ldh [hRam_FFB2], a
	pop hl
	pop de
	jp Label_74_443F

Label_74_4E6B:: ; 74:4E6B
	push hl
	push de
	ld hl, $B000

Label_74_4E70:: ; 74:4E70
	ld a, $03
	farcall Html_NextResourceRecord
	inc de
	inc de
	ld a, [de]
	or a, a
	jr z, Label_74_4E9E
	ld hl, $C380

Label_74_4E81:: ; 74:4E81
	ld a, [hli]
	ld c, a
	ld a, [de]
	inc de
	or a, a
	jr z, Label_74_4E94
	cp a, c
	jr z, Label_74_4E81

Label_74_4E8B:: ; 74:4E8B
	ld a, [de]
	inc de
	or a, a
	jr nz, Label_74_4E8B
	ld h, d
	ld l, e
	jr Label_74_4E70

Label_74_4E94:: ; 74:4E94
	ld a, e
	ldh [hRam_FFD2], a
	ld a, d
	ldh [hRam_FFD3], a
	ld a, $03
	ldh [hRam_FFD4], a

Label_74_4E9E:: ; 74:4E9E
	pop de
	pop hl
	ldh a, [hRam_FFB5]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, $20
	ldh [hRam_FFB3], a
	jp Label_74_4E14

; ---- code $4EB1-$4ECD (28 bytes) [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split

Label_74_4EB1:: ; 74:4EB1
	push hl
	push de
	ld hl, $C380
	ld bc, Html_AlignValuePtrs
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	call Function_00_10E9
	or a, a
	jr z, Label_74_4E9E
	cp a, $08
	jr z, Label_74_4E9E
	ldh [hRam_FFD5], a
	jr Label_74_4E9E

; ---- code $4ECD-$4EFA (45 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split [executed in 1 scenarios]

Label_74_4ECD:: ; 74:4ECD
	pop hl
	pop de
	farcall Html_Layout_WrapRun
	ldh a, [hTextX]
	call BankSwitch_D
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Label_74_4EEF
	ld a, $82
	ld [de], a
	inc de
	ld a, $45
	ld [de], a
	inc de
	xor a, a
	ld [de], a
	inc de

Label_74_4EEF:: ; 74:4EEF
	ldh a, [hRam_FFB2]
	push af
	and a, $03
	ld c, a
	ldh a, [hRam_FFD5]
	or a, a
	jr z, Label_74_4EFD

; ---- code $4EFA-$4EFD (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split
	or a, c
	ldh [hRam_FFB2], a

; ---- code $4EFD-$4F4F (82 bytes) [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4DF9-4F4F by apply_coverage --split [executed in 1 scenarios]

Label_74_4EFD:: ; 74:4EFD
	farcall Html_Layout_WrapRun
	pop af
	ldh [hRam_FFB2], a
	jp Label_74_443F

Label_74_4F09:: ; 74:4F09
	ldh a, [hRam_FFB4]
	cp a, $2F
	jp z, Label_74_443F

Label_74_4F10:: ; 74:4F10
	ld bc, $408A
	call Function_00_1119
	or a, a
	jp z, Label_74_443F
	cp a, $01
	jp nz, Label_74_4F10
	push hl
	push de
	ldh a, [hRam_FFCA]
	ld e, a
	ldh a, [hRam_FFCB]
	ld d, a
	ldh a, [hRam_FFBA]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [de], a
	ld hl, $DCFE
	ld bc, $DE00
	farcall Html_StringTable_Add
	or a, a
	jr nz, Label_74_4F45
	ld a, l
	ldh [hRam_FFCA], a
	ld a, h
	ldh [hRam_FFCB], a

Label_74_4F45:: ; 74:4F45
	ld a, d
	inc d
	jr z, Label_74_4F4A
	ld a, e

Label_74_4F4A:: ; 74:4F4A
	pop de
	pop hl
	jp Label_74_4F10
