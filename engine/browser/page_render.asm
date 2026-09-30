; engine/browser/page_render.asm
; bank 4E, $5204-$5B69 (2405 bytes); pinned by layout.link
; title bar, page rendering, link selection, element drawing

SECTION "engine/browser/page_render", ROMX

; ---- code $5204-$5215 (17 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Browser_DrawTitleBar:: ; 4E:5204
Function_4E_5204::
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ldh a, [hPageHeaderPtr + 2]
	call BankSwitch_H
	ld a, [hl]
	or a, a
	jr nz, Label_4E_5225

; ---- code $5215-$5225 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 4E:5213 (executed) [executed in 2 scenarios]
	ld hl, $D500
	ld a, $06
	call BankSwitch_H
	farcall Browser_MakeShortTitle
	jr Label_4E_522E

; ---- code $5225-$5274 (79 bytes) [CONFIRMED] 32 insn(s); 32 executed (in up to 2/18 scenarios)

Label_4E_5225:: ; 4E:5225
	ld de, $C340
	ld bc, $0016
	call CopyBytes

Label_4E_522E:: ; 4E:522E
	farcall Browser_ClearTitleArea
	ld a, $03
	ldh [hRam_FFBA], a
	ld a, $00
	ldh [hRam_FFBB], a
	ld a, $82
	ldh [hTextY], a
	ldh [hRam_FFC0], a
	ld a, $8F
	ldh [hRam_FFC3], a
	ld a, $84
	ldh [hRam_FFC4], a
	ld a, $10
	ldh [hTextX], a
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hTextX + 1], a
	ldh [hRam_FFC2], a
	ldh [hRam_FFC5], a
	ld a, $FF
	ldh [hRam_FFC6], a
	ld a, $06
	ldh [hRam_FFC7], a
	call Function_00_0392
	ld hl, $C340
	xor a, a
	farcall Function_00_0ED3
	farcall Browser_UploadTitleCanvas
	ret

; ---- code $5274-$5282 (14 bytes) [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1; entered by far from 4E:521D (PROBABLE code) | 11 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]

Browser_MakeShortTitle:: ; 4E:5274
	push hl
	xor a, a
	ld c, a
	ld b, a
	ld e, a
	ld d, a

Label_4E_527A:: ; 4E:527A
	ld a, [hli]
	or a, a
	jr z, Label_4E_52D5
	cp a, $81
	jr c, Label_4E_5296

; ---- code $5282-$5296 (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split
	cp a, $A0
	jr c, Label_4E_5297
	cp a, $E0
	jr c, Label_4E_5296
	cp a, $F0
	jr c, Label_4E_5297
	cp a, $F8
	jr c, Label_4E_5296
	cp a, $FA
	jr c, Label_4E_5297

; ---- code $5296-$52A5 (15 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]

Label_4E_5296:: ; 4E:5296
	or a, a

Label_4E_5297:: ; 4E:5297
	jp c, Label_4E_52A5
	ld a, c
	cp a, $13
	jr nc, Label_4E_52B2
	ld d, e
	ld e, b
	ld b, c
	inc c
	jr Label_4E_527A

; ---- code $52A5-$52B2 (13 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split

Label_4E_52A5:: ; 4E:52A5
	ld a, c
	cp a, $13
	jr nc, Label_4E_52B2
	ld a, [hli]
	ld d, e
	ld e, b
	ld b, c
	inc c
	inc c
	jr Label_4E_527A

; ---- code $52B2-$52B7 (5 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]

Label_4E_52B2:: ; 4E:52B2
	ld a, b
	cp a, $13
	jr c, Label_4E_52BD

; ---- code $52B7-$52BD (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split
	ld a, e
	cp a, $13
	jr c, Label_4E_52BD
	ld a, d

; ---- code $52BD-$52D5 (24 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]

Label_4E_52BD:: ; 4E:52BD
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
	jr Label_4E_52E4

; ---- code $52D5-$52E4 (15 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split

Label_4E_52D5:: ; 4E:52D5
	ld de, $C340
	pop hl
	ld a, c
	or a, a
	jr z, Label_4E_52E4
	ld b, $00
	push bc
	call CopyBytes
	pop bc

; ---- code $52E4-$52E7 (3 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 5274-52E7 by apply_coverage --split [executed in 2 scenarios]

Label_4E_52E4:: ; 4E:52E4
	xor a, a
	ld [de], a
	ret

; ---- code $52E7-$5306 (31 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Browser_RenderPage:: ; 4E:52E7
Function_4E_52E7::
	farcall Browser_DrawTitleBar
	farcall Browser_ClearBodyArea
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500

Label_4E_52FC:: ; 4E:52FC
	ld a, [hli]
	cp a, $23
	jr z, Label_4E_5306
	or a, a
	jr nz, Label_4E_52FC
	jr Label_4E_532B

; ---- code $5306-$531C (22 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1; entered by jrcc from 4E:52FF (executed) | 12 insn(s) executed; cut out of the PROBABLE region 5306-532B by apply_coverage --split [executed in 1 scenarios]

Label_4E_5306:: ; 4E:5306
	ld de, $C380
	dec hl

Label_4E_530A:: ; 4E:530A
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	jr nz, Label_4E_530A
	ld hl, $C380
	ld bc, $D600
	call Browser_FindAnchor
	or a, a
	jr z, Label_4E_532B

; ---- code $531C-$532B (15 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5306-532B by apply_coverage --split
	ld hl, $D602
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	dec hl
	ld a, [hld]
	ldh [hViewY + 1], a
	ld a, [hld]
	ldh [hViewY], a

; ---- code $532B-$534B (32 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_4E_532B:: ; 4E:532B
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	farcall Browser_DrawVisibleElements
	farcall Browser_UploadBodyCanvas
	ldh a, [rLCDC]
	call Function_00_07CB
	jp Browser_DrawScrollIndicators

; ---- code $534B-$536F (36 bytes) [CONFIRMED] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 2; entered by call from 4E:5316 (PROBABLE code) | 26 insn(s) executed; cut out of the PROBABLE region 534B-5390 by apply_coverage --split [executed in 1 scenarios]

Browser_FindAnchor:: ; 4E:534B
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld de, $FFFF

Label_4E_5354:: ; 4E:5354
	inc de
	ld a, d
	or a, a
	jr nz, Label_4E_539D
	push de
	ld a, [bc]
	inc bc
	ld e, a
	ld a, [bc]
	inc bc
	ld d, a
	or a, e
	jr z, Label_4E_539B
	push bc
	ld b, $00

Label_4E_5366:: ; 4E:5366
	inc b
	jr z, Label_4E_5391
	ld a, [de]
	inc de
	cp a, $41
	jr c, Label_4E_5375

; ---- code $536F-$5375 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 534B-5390 by apply_coverage --split
	cp a, $5B
	jr nc, Label_4E_5375
	add a, $20

; ---- code $5375-$537E (9 bytes) [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 534B-5390 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5375:: ; 4E:5375
	ld c, a
	ld a, [hli]
	or a, a
	jr z, Label_4E_538A
	cp a, $41
	jr c, Label_4E_5384

; ---- code $537E-$5384 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 534B-5390 by apply_coverage --split
	cp a, $5B
	jr nc, Label_4E_5384
	add a, $20

; ---- code $5384-$538A (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 534B-5390 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5384:: ; 4E:5384
	cp a, c
	jr z, Label_4E_5366
	pop bc
	jr Label_4E_5391

; ---- code $538A-$5390 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 534B-5390 by apply_coverage --split

Label_4E_538A:: ; 4E:538A
	sub a, c
	pop bc
	jr z, Label_4E_539A
	jr Label_4E_5391

; ---- data $5390-$5391 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $C1 (pop bc) that would fall into the PROBABLE code at 5391; the two preceding paths jr $5391 (5388, 538E) skip it and no branch to 5390 was found in the decoded code; left unclassified

Data_4E_5390:: ; 4E:5390
	db $C1

; ---- code $5391-$539A (9 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 3; entered by jrcc from 4E:5367 (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE region 5391-53A1 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5391:: ; 4E:5391
	pop de
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jr Label_4E_5354

; ---- code $539A-$539B (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5391-53A1 by apply_coverage --split

Label_4E_539A:: ; 4E:539A
	inc a

; ---- code $539B-$539D (2 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 5391-53A1 by apply_coverage --split [executed in 1 scenarios]

Label_4E_539B:: ; 4E:539B
	pop de
	ret

; ---- code $539D-$53A1 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5391-53A1 by apply_coverage --split

Label_4E_539D:: ; 4E:539D
	ld de, $FFFF
	ret

; ---- code $53A1-$53A9 (8 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Browser_ScrollUpLine:: ; 4E:53A1
Function_4E_53A1::
	ldh a, [hViewY]
	ld c, a
	ldh a, [hViewY + 1]
	ld b, a
	or a, c
	ret z

; ---- code $53A9-$5423 (122 bytes) [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 0; fall-through of the retcc at 4E:53A8 (executed) [executed in 2 scenarios]
	ld a, c
	sub a, $0C
	ldh [hViewY], a
	ld a, b
	sbc a, $00
	ldh [hViewY + 1], a
	ld bc, $0090
	ld de, $000C
	farcall Browser_SetViewport
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	farcall Browser_ShiftCanvasDown
	farcall Browser_DrawVisibleElements
	ret

Browser_ScrollDownLine:: ; 4E:53D1
	ldh a, [hViewScrollMax]
	ld c, a
	ldh a, [hViewScrollMax + 1]
	or a, c
	ret z
	ldh a, [hViewY]
	ld c, a
	ldh a, [hViewY + 1]
	ld b, a
	ldh a, [hViewScrollMax]
	sub a, c
	ld e, a
	ldh a, [hViewScrollMax + 1]
	sbc a, b
	ld d, a
	ret c
	ld a, c
	add a, $60
	ldh [hViewY], a
	ld a, b
	adc a, $00
	ldh [hViewY + 1], a
	ld bc, $0090
	ld de, $000C
	farcall Browser_SetViewport
	ld a, $54
	ldh [hBrowserDrawYOffset], a
	ld a, $00
	ldh [hBrowserDrawYOffset + 1], a
	farcall Browser_ShiftCanvasUp
	farcall Browser_DrawVisibleElements
	ldh a, [hViewY]
	sub a, $54
	ldh [hViewY], a
	ldh a, [hViewY + 1]
	sbc a, $00
	ldh [hViewY + 1], a
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	ret

; ---- code $5423-$55CC (425 bytes) [CONFIRMED] 266 insn(s); 266 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Browser_SetScroll:: ; 4E:5423
Function_4E_5423::
	ld a, c
	ldh [hViewX], a
	ld a, b
	ldh [hViewX + 1], a
	ld a, e
	ldh [hViewY], a
	ld a, d
	ldh [hViewY + 1], a
	xor a, a
	ldh [hBrowserDrawYOffset], a
	ldh [hBrowserDrawYOffset + 1], a
	ret

Browser_SetViewport:: ; 4E:5435
	ldh a, [hViewX]
	add a, c
	ldh [hViewRight], a
	ldh a, [hViewX + 1]
	adc a, b
	ldh [hViewRight + 1], a
	ldh a, [hViewY]
	add a, e
	ldh [hViewBottom], a
	ldh a, [hViewY + 1]
	adc a, d
	ldh [hViewBottom + 1], a
	ret

Browser_RedrawLinkById:: ; 4E:544A
	ldh [hRam_FFB1], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a

Label_4E_547D:: ; 4E:547D
	call Function_00_0392
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jr nz, Label_4E_5505
	ld a, b
	ldh [hRam_FFB2], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, Label_4E_5505
	or a, c
	jp z, Label_4E_5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, Label_4E_5505
	or a, c
	jp z, Label_4E_5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, Label_4E_5505
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, Label_4E_5505
	ldh a, [hRam_FFB1]
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr nz, Label_4E_5505
	pop hl
	push hl
	ldh a, [hRam_FFB1]
	push af
	call Browser_DrawElement
	pop af
	ldh [hRam_FFB1], a

Label_4E_5505:: ; 4E:5505
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, Label_4E_547D
	ret

Browser_FindLinkElement:: ; 4E:5512
	ldh [hRam_FFB1], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a

Label_4E_5545:: ; 4E:5545
	call Function_00_0392
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jr nz, Label_4E_55D5
	ld a, b
	ldh [hRam_FFB2], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, Label_4E_55D5
	or a, c
	jp z, Label_4E_55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, Label_4E_55D5
	or a, c
	jp z, Label_4E_55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, Label_4E_55D5
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, Label_4E_55D5
	ldh a, [hRam_FFB1]
	or a, a
	jr z, Label_4E_55D1
	cp a, $FF
	jr z, Label_4E_55CC
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr nz, Label_4E_55D5
	pop hl
	pop bc
	ret

; ---- code $55CC-$55D5 (9 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1; entered by jrcc from 4E:55C1 (executed)

Label_4E_55CC:: ; 4E:55CC
	ldh a, [hRam_FFB2]
	pop hl
	pop bc
	ret

Label_4E_55D1:: ; 4E:55D1
	ldh a, [hRam_FFB2]
	ldh [hRam_FFB0], a

; ---- code $55D5-$55E1 (12 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_4E_55D5:: ; 4E:55D5
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, Label_4E_5545

; ---- code $55E1-$55E8 (7 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jpcc at 4E:55DE (executed)
	ldh a, [hRam_FFB1]
	or a, a
	ret z
	ldh a, [hRam_FFB0]
	ret

; ---- code $55E8-$56B6 (206 bytes) [CONFIRMED] 125 insn(s); 125 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Browser_FindVisibleLink:: ; 4E:55E8
Function_4E_55E8::
	ldh [hRam_FFB1], a
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de
	xor a, a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB3], a

Label_4E_561D:: ; 4E:561D
	call Function_00_0392
	push bc
	push hl
	ld bc, $0009
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, c
	and a, $03
	cp a, $01
	jp nz, Label_4E_56CC
	ld a, b
	ldh [hRam_FFB2], a
	pop hl
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, Label_4E_56BC
	or a, c
	jp z, Label_4E_56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, Label_4E_56BC
	or a, c
	jp z, Label_4E_56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, Label_4E_56BC
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, Label_4E_56BC
	ldh a, [hRam_FFB3]
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr z, Label_4E_56C9
	ldh a, [hRam_FFB1]
	or a, a
	jr z, Label_4E_56B6
	cp a, $FF
	jr z, Label_4E_56AE
	ld b, a
	ldh a, [hRam_FFB2]
	cp a, b
	jr nz, Label_4E_56CC
	ldh [hRam_FFB0], a
	jr Label_4E_56CC

Label_4E_56AE:: ; 4E:56AE
	ldh a, [hRam_FFB2]
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	jr Label_4E_56CC

; ---- code $56B6-$56BC (6 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 4E:569E (executed)

Label_4E_56B6:: ; 4E:56B6
	ldh a, [hRam_FFB2]
	ldh [hRam_FFB0], a
	jr Label_4E_56CC

; ---- code $56BC-$56C9 (13 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

Label_4E_56BC:: ; 4E:56BC
	ldh a, [hRam_FFB2]
	or a, a
	jr z, Label_4E_56CC
	ldh [hRam_FFB3], a
	ld b, a
	ldh a, [hRam_FFB0]
	cp a, b
	jr nz, Label_4E_56CC

; ---- code $56C9-$56CC (3 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1; entered by jrcc from 4E:5699 (executed) [executed in 1 scenarios]

Label_4E_56C9:: ; 4E:56C9
	xor a, a
	ldh [hRam_FFB0], a

; ---- code $56CC-$56F3 (39 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)

Label_4E_56CC:: ; 4E:56CC
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, Label_4E_561D
	ldh a, [hRam_FFB0]
	ret

Browser_SelectPrevLink:: ; 4E:56DB
	ldh a, [hBrowserSelectedLink]
	ldh [hRam_FFDF], a
	dec a
	jr z, Label_4E_56E8
	call Browser_FindVisibleLink
	or a, a
	jr nz, Label_4E_56F6

Label_4E_56E8:: ; 4E:56E8
	farcall Browser_ScrollUpLine
	ldh a, [hBrowserSelectedLink]
	dec a
	jr z, Label_4E_570D

; ---- code $56F3-$56F6 (3 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 4E:56F1 (executed)
	call Browser_FindVisibleLink

; ---- code $56F6-$5704 (14 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_4E_56F6:: ; 4E:56F6
	or a, a
	jp z, Label_4E_56FF
	ldh [hBrowserSelectedLink], a
	call Browser_RedrawLinkById

Label_4E_56FF:: ; 4E:56FF
	ldh a, [hRam_FFDF]
	or a, a
	jr z, Label_4E_570D

; ---- code $5704-$570D (9 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 4E:5702 (executed) [executed in 2 scenarios]
	call Browser_FindVisibleLink
	or a, a
	jr z, Label_4E_570D
	call Browser_RedrawLinkById

; ---- code $570D-$5721 (20 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)

Label_4E_570D:: ; 4E:570D
	farcall Browser_UploadBodyCanvas
	jp Browser_DrawScrollIndicators

Browser_SelectNextLink:: ; 4E:5716
	ldh a, [hBrowserSelectedLink]
	ldh [hRam_FFDF], a
	inc a
	call Browser_FindVisibleLink
	or a, a
	jr nz, Label_4E_572D

; ---- code $5721-$572D (12 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 4E:571F (executed) [executed in 6 scenarios]
	farcall Browser_ScrollDownLine
	ldh a, [hBrowserSelectedLink]
	inc a
	call Browser_FindVisibleLink

; ---- code $572D-$57FA (205 bytes) [CONFIRMED] 125 insn(s); 125 executed (in up to 2/18 scenarios)

Label_4E_572D:: ; 4E:572D
	or a, a
	jp z, Label_4E_5736
	ldh [hBrowserSelectedLink], a
	call Browser_RedrawLinkById

Label_4E_5736:: ; 4E:5736
	ldh a, [hRam_FFDF]
	or a, a
	jr z, Label_4E_5744
	call Browser_FindVisibleLink
	or a, a
	jr z, Label_4E_5744
	call Browser_RedrawLinkById

Label_4E_5744:: ; 4E:5744
	farcall Browser_UploadBodyCanvas
	jp Browser_DrawScrollIndicators

Browser_DrawVisibleElements:: ; 4E:574D
	ldh a, [hPageHeaderPtr]
	ld l, a
	ldh a, [hPageHeaderPtr + 1]
	ld h, a
	or a, l
	ret z
	ld d, h
	ld e, l
	ld bc, $0015
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld a, b
	or a, c
	ret z
	ld hl, $0020
	add hl, de

Label_4E_576F:: ; 4E:576F
	call Function_00_0392
	push bc
	push hl
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewRight]
	sub a, c
	ld c, a
	ldh a, [hViewRight + 1]
	sbc a, b
	jp c, Label_4E_57CF
	or a, c
	jp z, Label_4E_57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewBottom]
	sub a, c
	ld c, a
	ldh a, [hViewBottom + 1]
	sbc a, b
	jp c, Label_4E_57CF
	or a, c
	jp z, Label_4E_57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewX]
	sub a, c
	ldh a, [hViewX + 1]
	sbc a, b
	jp nc, Label_4E_57CF
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hViewY]
	sub a, c
	ldh a, [hViewY + 1]
	sbc a, b
	jp nc, Label_4E_57CF
	pop hl
	push hl
	call Browser_DrawElement

Label_4E_57CF:: ; 4E:57CF
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jp nz, Label_4E_576F
	ret

Browser_DrawElement:: ; 4E:57DC
	call Function_00_0392
	ld bc, $0006
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewBottom]
	sub a, c
	ldh a, [hViewBottom + 1]
	sbc a, b
	jr nc, Label_4E_5800

; ---- code $57FA-$5800 (6 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 4E:57F8 (executed) [executed in 1 scenarios]
	ldh a, [hViewBottom]
	ld c, a
	ldh a, [hViewBottom + 1]
	ld b, a

; ---- code $5800-$5831 (49 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)

Label_4E_5800:: ; 4E:5800
	ldh a, [hViewY]
	ld e, a
	ld a, c
	sub a, e
	ldh [hRam_FFCE], a
	ldh a, [hViewY + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hRam_FFCF], a
	ld bc, $0004
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewRight]
	sub a, c
	ldh a, [hViewRight + 1]
	sbc a, b
	jr c, Label_4E_5831
	ld a, c
	ldh [hRam_FFCC], a
	ld a, b
	ldh [hRam_FFCD], a
	jr Label_4E_5839

; ---- code $5831-$5839 (8 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 4E:5827 (executed)

Label_4E_5831:: ; 4E:5831
	ldh a, [hViewRight]
	ldh [hRam_FFCC], a
	ldh a, [hViewRight + 1]
	ldh [hRam_FFCD], a

; ---- code $5839-$589B (98 bytes) [CONFIRMED] 69 insn(s); 69 executed (in up to 2/18 scenarios)

Label_4E_5839:: ; 4E:5839
	ld bc, $0000
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewX]
	ld e, a
	ld a, c
	sub a, e
	ldh [hRam_FFC8], a
	ldh a, [hViewX + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hRam_FFC9], a
	ld bc, $0002
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hViewY]
	ld e, a
	ld a, c
	sub a, e
	ldh [hRam_FFCA], a
	ldh a, [hViewY + 1]
	ld e, a
	ld a, b
	sbc a, e
	ldh [hRam_FFCB], a
	ld bc, $0008
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld d, h
	ld e, l
	ld b, $00
	ld hl, Table_Browser_ElementDrawHandlers
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $589B-$58AB (16 bytes) [PROBABLE] code-pointer table, 8 entries: 1/8 words hit known code starts (dispatch idiom `ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl` at 4E:589A, base from `ld hl,$589B`; end = cfg inline-table rule, HYPOTHESIS for the exact length); 1/8 targets executed

Table_Browser_ElementDrawHandlers:: ; 4E:589B
Table_4E_589B::
	dw Label_4E_58AB
	dw Browser_DrawElement_Text
	dw Label_4E_58AB
	dw Label_4E_58AB
	dw Browser_DrawElement_Bitmap
	dw Browser_DrawElement_Bitmap
	dw Label_4E_58AB
	dw Label_4E_58AB

; ---- code $58AB-$58AC (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: table x1; min discovery hops 0; run starts at an entry of the code-pointer table at 4E:589B

Label_4E_58AB:: ; 4E:58AB
	ret

; ---- code $58AC-$590D (97 bytes) [CONFIRMED] 55 insn(s); 55 executed (in up to 2/18 scenarios)

Browser_DrawElement_Text:: ; 4E:58AC
	ld h, d
	ld l, e
	ld bc, $0009
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld a, b
	ldh [hRam_FFB6], a
	ld a, c
	ldh [hRam_FFB5], a
	and a, $03
	cp a, $01
	jr z, Label_4E_58DB
	cp a, $02
	jr z, Label_4E_58F7
	ld a, $03
	ldh [hRam_FFBA], a
	ld a, $00
	ldh [hRam_FFBB], a
	jr Label_4E_58FF

Label_4E_58DB:: ; 4E:58DB
	ldh a, [hBrowserSelectedLink]
	ld b, a
	ldh a, [hRam_FFB6]
	cp a, b
	jr z, Label_4E_58ED
	ld a, $02
	ldh [hRam_FFBA], a
	ld a, $00
	ldh [hRam_FFBB], a
	jr Label_4E_58FF

Label_4E_58ED:: ; 4E:58ED
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $02
	ldh [hRam_FFBB], a
	jr Label_4E_58FF

Label_4E_58F7:: ; 4E:58F7
	ld a, $01
	ldh [hRam_FFBA], a
	ld a, $00
	ldh [hRam_FFBB], a

Label_4E_58FF:: ; 4E:58FF
	ldh a, [hRam_FFB5]
	and a, $30
	cp a, $20
	jr z, Label_4E_590D
	cp a, $30
	jr z, Label_4E_593E
	jr Label_4E_594A

; ---- code $590D-$594A (61 bytes) [PROBABLE] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 1; entered by jrcc from 4E:5905 (executed)

Label_4E_590D:: ; 4E:590D
	ldh a, [hRam_FFCA]
	ld c, a
	ldh a, [hRam_FFCB]
	ld b, a
	ldh a, [hRam_FFCE]
	sub a, c
	ld c, a
	ldh a, [hRam_FFCF]
	sbc a, b
	ld b, a
	bit 7, b
	jr z, Label_4E_5926
	dec bc
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a

Label_4E_5926:: ; 4E:5926
	srl b
	rr c
	ldh a, [hRam_FFCA]
	add a, c
	ld c, a
	ldh a, [hRam_FFCB]
	adc a, b
	ld b, a
	ld a, c
	sub a, $0C
	ldh [hRam_FFCA], a
	ld a, b
	sbc a, $00
	ldh [hRam_FFCB], a
	jr Label_4E_594A

Label_4E_593E:: ; 4E:593E
	ldh a, [hRam_FFCE]
	sub a, $0C
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCF]
	sbc a, $00
	ldh [hRam_FFCB], a

; ---- code $594A-$5969 (31 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)

Label_4E_594A:: ; 4E:594A
	ld bc, $000B
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ldh a, [hRam_FFB0]
	ldh [hRam_FFB7], a
	ld h, b
	ld l, c

Label_4E_5963:: ; 4E:5963
	ldh a, [hRam_FFCB]
	bit 7, a
	jr z, Label_4E_5993

; ---- code $5969-$5993 (42 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 4E:5967 (executed)
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	ldh a, [hRam_FFCC]
	ld c, a
	ldh a, [hRam_FFCD]
	ld b, a
	ldh a, [hRam_FFB7]
	call Function_00_1408
	ld a, b
	or a, c
	jp z, Label_4E_5A6C
	ldh a, [hRam_FFCA]
	add a, $0C
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCB]
	adc a, $00
	ldh [hRam_FFCB], a
	ld a, [hli]
	cp a, $0D
	jr z, Label_4E_5963
	dec hl
	jr Label_4E_5963

; ---- code $5993-$59BE (43 bytes) [CONFIRMED] 25 insn(s); 25 executed (in up to 2/18 scenarios)

Label_4E_5993:: ; 4E:5993
	ldh a, [hRam_FFCA]
	ld e, a
	ldh a, [hRam_FFCB]
	ld d, a
	ldh a, [hRam_FFCE]
	sub a, e
	ldh a, [hRam_FFCF]
	sbc a, d
	jp c, Label_4E_5A6C
	ldh a, [hRam_FFCE]
	sub a, e
	jp z, Label_4E_5A6C
	ldh a, [hRam_FFC8]
	ld e, a
	ldh a, [hRam_FFC9]
	ld d, a
	ldh a, [hRam_FFCC]
	ld c, a
	ldh a, [hRam_FFCD]
	ld b, a
	ldh a, [hRam_FFB5]
	and a, $0C
	ldh [hRam_FFB4], a
	ldh [hRam_FFB3], a
	jr z, Label_4E_59F4

; ---- code $59BE-$59F4 (54 bytes) [PROBABLE] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 0; fall-through of the jrcc at 4E:59BC (executed)
	push hl
	ldh a, [hRam_FFB7]
	call Function_00_1408
	ldh a, [hRam_FFCC]
	sub a, e
	ldh [hRam_FFB4], a
	ld e, a
	ldh a, [hRam_FFCD]
	sbc a, d
	ldh [hRam_FFB3], a
	or a, e
	pop de
	jr z, Label_4E_59F9
	ld h, d
	ld l, e
	ldh a, [hRam_FFB4]
	ld e, a
	ldh a, [hRam_FFB5]
	and a, $0C
	cp a, $04
	jr z, Label_4E_59E5
	srl e
	ld a, e
	ldh [hRam_FFB4], a

Label_4E_59E5:: ; 4E:59E5
	ldh a, [hRam_FFC8]
	add a, e
	ld e, a
	ldh a, [hRam_FFC9]
	adc a, $00
	ld d, a
	ldh a, [hRam_FFCC]
	ld c, a
	ldh a, [hRam_FFCD]
	ld b, a

; ---- code $59F4-$5A6D (121 bytes) [CONFIRMED] 66 insn(s); 66 executed (in up to 2/18 scenarios)

Label_4E_59F4:: ; 4E:59F4
	ldh a, [hRam_FFB7]
	call Function_00_1408

Label_4E_59F9:: ; 4E:59F9
	ld a, b
	or a, c
	jr z, Label_4E_5A6C
	push hl
	dec bc
	ld a, c
	cpl
	ld e, a
	ld a, b
	cpl
	ld d, a
	add hl, de
	inc bc
	ld de, $C340
	ldh a, [hRam_FFB7]
	call BankSwitch_H
	call CopyBytes
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB4]
	ld c, a
	ldh a, [hRam_FFC8]
	add a, c
	add a, $08
	ldh [hTextX], a
	ldh [hRam_FFC1], a
	ldh a, [hRam_FFC9]
	adc a, $00
	ldh [hTextX + 1], a
	ldh [hRam_FFC2], a
	ldh a, [hBrowserDrawYOffset]
	ld c, a
	ldh a, [hRam_FFCA]
	add a, c
	ldh [hTextY], a
	ldh [hRam_FFC0], a
	ld a, $8F
	ldh [hRam_FFC3], a
	ld a, $9F
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $06
	ldh [hRam_FFC7], a
	ld a, $FF
	ldh [hRam_FFC6], a
	ld hl, $C340
	xor a, a
	farcall Function_00_0ED3
	pop hl
	ldh a, [hRam_FFCA]
	add a, $0C
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCB]
	adc a, $00
	ldh [hRam_FFCB], a
	ldh a, [hRam_FFB7]
	call BankSwitch_H
	ld a, [hli]
	cp a, $0D
	jp z, Label_4E_5963
	dec hl
	jp Label_4E_5963

Label_4E_5A6C:: ; 4E:5A6C
	ret

; ---- code $5A6D-$5A9A (45 bytes) [CONFIRMED] 416 insn(s) reached by static flow only; seeds: exec x265, site x5, table x146; min discovery hops 0; run starts at an entry of the code-pointer table at 4E:589B | 28 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1 scenarios]

Browser_DrawElement_Bitmap:: ; 4E:5A6D
	ld h, d
	ld l, e
	ld bc, $0009
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld a, b
	ldh [hRam_FFB6], a
	ld a, c
	ldh [hRam_FFB5], a
	and a, $03
	cp a, $01
	jr z, Label_4E_5A9A
	cp a, $02
	jr z, Label_4E_5AB2
	ld a, $03
	ldh [hRam_FFC2], a
	ldh [hRam_FFC3], a
	jr Label_4E_5AB8

; ---- code $5A9A-$5AB8 (30 bytes) [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split

Label_4E_5A9A:: ; 4E:5A9A
	ldh a, [hBrowserSelectedLink]
	ld b, a
	ldh a, [hRam_FFB6]
	cp a, b
	jr z, Label_4E_5AAA
	ld a, $02
	ldh [hRam_FFC2], a
	ldh [hRam_FFC3], a
	jr Label_4E_5AB8

Label_4E_5AAA:: ; 4E:5AAA
	ld a, $20
	ldh [hRam_FFC2], a
	ldh [hRam_FFC3], a
	jr Label_4E_5AB8

Label_4E_5AB2:: ; 4E:5AB2
	ld a, $01
	ldh [hRam_FFC2], a
	ldh [hRam_FFC3], a

; ---- code $5AB8-$5B26 (110 bytes) [CONFIRMED] 67 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5AB8:: ; 4E:5AB8
	ldh a, [hBrowserDrawYOffset]
	ld c, a
	ldh a, [hBrowserDrawYOffset + 1]
	ld b, a
	ldh a, [hRam_FFCA]
	add a, c
	ldh [hRam_FFCA], a
	ldh a, [hRam_FFCB]
	adc a, b
	ldh [hRam_FFCB], a
	ldh a, [hRam_FFCE]
	add a, c
	ldh [hRam_FFCE], a
	ldh a, [hRam_FFCF]
	adc a, b
	ldh [hRam_FFCF], a
	ldh a, [hRam_FFC8]
	add a, $08
	ldh [hRam_FFC8], a
	ldh a, [hRam_FFC9]
	adc a, $00
	ldh [hRam_FFC9], a
	ldh a, [hRam_FFCC]
	add a, $08
	ldh [hRam_FFCC], a
	ldh a, [hRam_FFCD]
	adc a, $00
	ldh [hRam_FFCD], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld bc, $000B
	push hl
	add hl, bc
	ldh a, [hPageHeaderPtr + 2]
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	pop hl
	ld h, b
	ld l, c
	ldh a, [hRam_FFB0]
	call BankSwitch_H
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [hRam_FFCB]
	or a, a
	jr nz, Label_4E_5B26
	ld c, $00
	ldh a, [hRam_FFCA]
	ld e, a
	ldh a, [hRam_FFCE]
	sub a, e
	cp a, h
	jr c, Label_4E_5B22
	ld a, h

Label_4E_5B22:: ; 4E:5B22
	ldh [hRam_FFD7], a
	jr Label_4E_5B35

; ---- code $5B26-$5B35 (15 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split

Label_4E_5B26:: ; 4E:5B26
	ld e, $00
	ldh a, [hRam_FFCA]
	dec a
	cpl
	ld c, a
	ldh a, [hRam_FFCE]
	cp a, h
	jr c, Label_4E_5B33
	ld a, h

Label_4E_5B33:: ; 4E:5B33
	ldh [hRam_FFD7], a

; ---- code $5B35-$5B45 (16 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5B35:: ; 4E:5B35
	ldh a, [hRam_FFC9]
	or a, a
	jr nz, Label_4E_5B4A
	ld b, $00
	ldh a, [hRam_FFC8]
	ld d, a
	ldh a, [hRam_FFCC]
	sub a, d
	cp a, l
	jr c, Label_4E_5B46

; ---- code $5B45-$5B46 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split
	ld a, l

; ---- code $5B46-$5B4A (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1 scenarios]

Label_4E_5B46:: ; 4E:5B46
	ldh [hRam_FFD6], a
	jr Label_4E_5B59

; ---- code $5B4A-$5B59 (15 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split

Label_4E_5B4A:: ; 4E:5B4A
	ld d, $00
	ldh a, [hRam_FFC8]
	dec a
	cpl
	ld b, a
	ldh a, [hRam_FFCC]
	cp a, l
	jr c, Label_4E_5B57
	ld a, l

Label_4E_5B57:: ; 4E:5B57
	ldh [hRam_FFD6], a

; ---- code $5B59-$5B69 (16 bytes) [CONFIRMED] 272 insn(s) executed; cut out of the PROBABLE region 5A6D-5CB6 by apply_coverage --split [executed in 1 scenarios] (part of region $5B59-$5CB6)

Label_4E_5B59:: ; 4E:5B59
	pop hl
	ldh a, [hRam_FFC2]
	farcall Image_BlitToTileCanvas
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
