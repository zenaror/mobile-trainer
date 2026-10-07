; engine/browser/inline_image_blit.asm
; bank 51, $70E0-$7900 (2080 bytes); pinned by layout.link
; 1-bit BMP validator/converter and tile-canvas blitters for inline images

SECTION "engine/browser/inline_image_blit", ROMX

Bmp_Validate:: ; 51:70E0
	; [CONFIRMED] 500 insn(s) reached by static flow only; seeds: exec x500; min discovery hops 1;
	; entered by far from 4C:4E56 (PROBABLE code) | 83 insn(s) executed; cut out of the PROBABLE
	; region 70E0-73D1 by apply_coverage --split [executed in 1 scenarios]
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Bmp_ParseHeader
	or a, a
	ret z
	call Bmp_CheckSize
	or a, a
	ret z
	ld a, $01
	ret

Bmp_ParseHeader:: ; 51:70F4
	push hl
	ld a, [hli]
	cp a, $42
	jr nz, .l7157
	ld a, [hli]
	cp a, $4D
	jr nz, .l7157
	ld de, $0008
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	or a, [hl]
	jr nz, .l7157
	ld de, $0005
	add hl, de
	ld a, [hli]
	ldh [hBmp_Width], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	or a, e
	ld a, [hli]
	or a, e
	jr nz, .l7157
	ld a, [hli]
	ldh [hBmp_Height], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	and a, e
	ld a, [hli]
	and a, e
	jr z, .l712E
	cp a, $FF
	jr nz, .l7157
	ld [wBmpTopDownFlag], a
	jr .l7132
.l712E ; 51:712E
	xor a, a
	ld [wBmpTopDownFlag], a
.l7132 ; 51:7132
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, .l7157
	inc hl
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, .l7157
	inc hl
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, .l7157
	ld de, $000D
	add hl, de
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, .l7157
	pop hl
	add hl, bc
	ld a, $01
	ret

.l7157 ; 51:7157
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	xor a, a
	ldh [hBmp_Width], a
	ldh [hBmp_Height], a
	ld [wBmpTopDownFlag], a
	pop hl
	ret

Bmp_CheckSize:: ; 51:7161
	; [CONFIRMED] 155 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hBmp_Width]
	cp a, $91
	jr nc, .l7175
	ld d, a
	ldh a, [hBmp_Height]
	or a, a
	jr z, .l7175
	cp a, $61
	jr nc, .l7175
	ld e, a
	ld a, $01
	ret
.l7175 ; 51:7175
	xor a, a
	ret

Bmp_ConvertToTiles:: ; 51:7177
	ld a, l
	ld [wHtmlLinkHeapPtr + 1], a
	ld a, h
	ld [wHtmlBoldCount], a
	push hl
	call Bmp_Validate
	pop de
	or a, a
	ret z
	dec hl
	dec hl
	dec hl
	dec hl
	ld a, [wBmpTopDownFlag]
	or a, a
	jp nz, .l73CB
	push hl
	push de
	ld hl, $000E
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hld]
	ld d, a
	add hl, de
	call Bmp_ColorSum
	push de
	call Bmp_ColorSum
	pop hl
	dec hl
	ld a, l
	cpl
	ld l, a
	ld a, h
	cpl
	ld h, a
	add hl, de
	pop de
	ld a, l
	ld [wHtmlBrClear], a
	ld a, h
	ld [wBmp_ColorDiffHi], a
	ld hl, $0017
	add hl, de
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hBmp_Width]
	add a, $07
	jp c, .l73CE
	and a, $F8
	rrca
	rrca
	rrca
	ld [wBrowserNavigating], a
	add a, $03
	jp c, .l73CE
	and a, $FC
	ld [wHtmlScanOnly], a
	ldh a, [hBmp_Height]
	call Bmp_RoundUpToTextRow
	ld [wBmpRowAlignedHeight], a
	ld e, a
	ldh a, [hBmp_Width]
	call Bmp_RoundUpToTextRow
	ld [wRam_C332], a
	add a, $07
	jp c, .l73CE
	and a, $F8
	rrca
	rrca
	rrca
	add a, $03
	jp c, .l73CE
	and a, $FC
	ldh [hBmpConvert_RowStride], a
	ld d, $00
	call Multiply8x16
	ld c, l
	ld b, h
	pop hl
	push hl
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ldh a, [hBmpConvert_RowStride]
	and a, $1F
	rlca
	rlca
	rlca
	ld [wHtmlLinkHeapPtr], a
	ld [hli], a
	ld a, [wBmpRowAlignedHeight]
	ld [hli], a
	push bc
	push hl
	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, l
	ld [wHtmlListCounter + 1], a
	ld a, h
	ld [wHtmlAlign], a
	call Sound_FrameService
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld a, $FF
	call FillBytes
	ldh a, [hBmp_Height]
	dec a
	ld e, a
	ldh a, [hBmpConvert_RowStride]
	ld d, $00
	call Multiply8x16
	ld de, wTileStage3
	add hl, de
	ld e, l
	ld d, h
	pop hl
.l7251 ; 51:7251
	call Sound_FrameService
	ld a, [wBrowserNavigating]
	ld c, a
	ld b, $00
	push hl
	push de
	push de
	call CopyBytes
	pop hl
	ld a, [wBmp_ColorDiffHi]
	bit 7, a
	jr z, .l7276

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	ld a, [wBrowserNavigating]
	or a, a
	jr z, .l7276
	ld c, a
.l726F ; 51:726F
	ld a, [hl]
	xor a, $FF
	ld [hli], a
	dec c
	jr nz, .l726F

.l7276 ; 51:7276
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 2 scenarios]
	ldh a, [hBmp_Width]
	and a, $07
	jr z, .l7287

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	dec de
	ld c, a
	ld b, $00
	ld hl, Table_Bmp_RowEndMask
	add hl, bc
	ld a, [de]
	or a, [hl]
	ld [de], a

.l7287 ; 51:7287
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 2 scenarios]
	pop de
	pop hl
	ld a, [wHtmlScanOnly]
	ld c, a
	ld b, $00
	add hl, bc
	ldh a, [hBmpConvert_RowStride]
	ld c, a
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
	cp a, $D0
	jr nc, .l7251
	call Sound_FrameService
	pop de
	pop bc
	inc hl
	inc hl
	push de
	push hl
	ld a, [wHtmlLinkHeapPtr + 1]
	ld l, a
	ld a, [wHtmlBoldCount]
	ld h, a
	ld de, $000A
	add hl, de
	ld d, a
	ld a, [wHtmlLinkHeapPtr + 1]
	ld e, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	push hl
	add hl, de
	ld a, h
	pop hl
	cp a, $C0
	jr c, .l72D4

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	dec de
	dec de
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	pop hl
	pop de
	jp .l73CE

.l72D4 ; 51:72D4
	; [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 1 scenarios]
	dec de
	dec de
	push bc
	inc hl
	inc hl
	ld a, [de]
	cpl
	ld c, a
	ld a, l
	ld [de], a
	inc de
	ld a, [de]
	cpl
	ld b, a
	ld a, h
	ld [de], a
	dec hl
	dec hl
	inc bc
	inc bc
	inc bc
	add hl, bc
	ld a, l
	ld [wHtmlBoldCount + 1], a
	ld a, h
	ld [wHtmlListCounter], a
	pop bc
	pop hl
	push hl
	push bc
	ld e, c
	ld d, b
.l72F8 ; 51:72F8
	ld a, [wHtmlListCounter + 1]
	add a, c
	ld a, [wHtmlAlign]
	adc a, b
	cp a, $C0
	jr nc, .l7383
	ld a, b
	cp a, $10
	jp nc, .l7383
	ld e, c
	ld d, b
	ld a, [hli]
	ld a, [hli]
	ld a, [hli]
	or a, a
	jp z, .l7383
	inc bc
	inc bc
.l7315 ; 51:7315
	inc bc
	ld a, [hli]
	or a, a
	jr nz, .l7315
	push bc
	push de
	push hl
	ld e, l
	ld d, h
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hHtmlLayout_RecordCount]
	ld c, a
	ldh a, [hHtmlLayout_RecordCountHi]
	ld b, a
	or a, c
	jr z, .l7365
	ldh a, [hHtmlLayout_RecordList]
	ld l, a
	ldh a, [hHtmlLayout_RecordListHi]
	ld h, a
.l7334 ; 51:7334
	ldh a, [hHtml_PageBank]
	call BankSwitch_H
	push bc
	push hl
	ld bc, $0008
	add hl, bc
	ld a, [hl]
	cp a, $04
	jr nz, .l735A

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	ld bc, $0003
	add hl, bc
	ld a, [hli]
	cp a, e
	jr nz, .l735A
	ld a, [hld]
	cp a, d
	jr nz, .l735A
	ld a, [wHtmlBoldCount + 1]
	add a, e
	ld [hli], a
	ld a, [wHtmlListCounter]
	adc a, d
	ld [hli], a

.l735A ; 51:735A
	; [CONFIRMED] 82 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 1 scenarios]
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jr nz, .l7334
.l7365 ; 51:7365
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	inc bc
	inc bc
	inc bc
	inc bc
	inc bc
	push de
	ld a, [hli]
	ld e, a
	add a, c
	ld c, a
	ld a, [hli]
	ld d, a
	adc a, b
	ld b, a
	add hl, de
	pop de
	inc hl
	inc hl
	jp .l72F8
.l7383 ; 51:7383
	ld c, e
	ld b, d
	pop de
	dec de
	ld a, e
	cpl
	ld [wHtmlBoldCount + 1], a
	ld a, d
	cpl
	ld [wHtmlListCounter], a
	ld hl, wTileStage3 + $01 ; the +1 undoes the dec de above: HL = wTileStage3 + the DE popped
	add hl, de
	ld e, l
	ld d, h
	pop hl
	dec hl
	dec hl
	push bc
	ld a, [wHtmlBoldCount + 1]
	add a, c
	ld c, a
	ld a, [wHtmlListCounter]
	adc a, b
	ld b, a
	or a, c
	jr z, .l73AB
	call CopyBytes
.l73AB ; 51:73AB
	pop bc
	call Sound_FrameService
	pop de
	ld hl, wTileStage3
	call CopyBytes
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	ld a, [wBmpRowAlignedHeight]
	ldh [hBmp_Height], a
	ld a, [wHtmlLinkHeapPtr]
	ldh [hBmp_Width], a
	pop hl
.l73CB ; 51:73CB
	ld a, $01
	ret

.l73CE ; 51:73CE
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	pop hl
	xor a, a
	ret

; ---- data $73D1-$73DA (9 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [boundary trimmed 73D1-73E9 -> 73D1-73DA against proven code]

Table_Bmp_RowEndMask:: ; 51:73D1
Data_51_73D1::
	db $FF, $7F, $3F, $1F, $0F, $07, $03, $01, $00

Bmp_ColorSum:: ; 51:73DA
	; [CONFIRMED] 43 insn(s) reached by static flow only; seeds: exec x43; min discovery hops 2;
	; entered by call from 51:719C (PROBABLE code) [executed in 1 scenarios]
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	push hl
	ld hl, $0000
	ld b, l
	add hl, bc
	add hl, bc
	ld c, d
	add hl, bc
	add hl, bc
	ld c, e
	add hl, bc
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ret

Bmp_RoundUpToTextRow:: ; 51:73F2
	push de
	ld e, a
	ld hl, $000C
	ld d, h
	ld c, h
	ld b, h
	call Divide32by15
	ld a, c
	or a, c
	jr z, .skip
	inc de
.skip ; 51:7402
	ld l, e
	ld h, d
	add hl, hl
	add hl, hl
	add hl, de
	add hl, de
	add hl, hl
	ld a, l
	pop de
	ret

; ---- data $740C-$740D (1 bytes) [PROBABLE] single $FF byte between the ret at 740B and the function at 740D (ldh [$FFD0],a ...); read as an all-ones mask by the edge-strip blit code at 51:75A0 and 51:765B
; (ld a, [Data_51_740C] ; and a, d: the edge mask passes unchanged); both reads are in code that never ran naturally, so the role is PROBABLE (earlier text: "probably padding, not referenced")

ImageBlit_AllBitsMask:: ; 51:740C
Data_51_740C::
	db $FF

Image_BlitToTileCanvas:: ; 51:740D
	; [CONFIRMED] 822 insn(s) reached by static flow only; seeds: site x822; min discovery hops 1;
	; entered by far from 4E:5B5C (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE
	; region 740D-7900 by apply_coverage --split [executed in 1 scenarios]
	ldh [hImageBlit_Colors], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Image_MakeEdgeMasks
	call Sound_FrameService
	push bc
	ld a, d
	and a, $07
	xor a, $07
	inc a
	ld c, a
	add a, b
	and a, $07
	ldh [hImageBlit_BitShift], a
	ld b, $00
	ld a, c
	and a, $07
	jr z, .l7431

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	inc b

.l7431 ; 51:7431
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld c, a
	ldh a, [hBmp_Width]
	sub a, c
	add a, $07
	and a, $F8
	rrca
	rrca
	rrca
	add a, b
	ldh [hImageBlit_DestColumns], a
	pop bc
	inc hl
	inc hl
	ld a, [hli]
	add a, $07
	and a, $F8
	rrca
	rrca
	rrca
	ldh [hImageBlit_SrcRowBytes], a
	inc hl
	ld a, c
	or a, a
	jr z, .l745D

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	push de
	ldh a, [hImageBlit_SrcRowBytes]
	ld e, a
	ld d, $00
	ld a, c
.l7458 ; 51:7458
	add hl, de
	dec a
	jr nz, .l7458
	pop de

.l745D ; 51:745D
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	push de
	ld a, d
	and a, $07
	ld d, a
	ld a, b
	sub a, d
	cp a, $F9
	jr nc, .l7473
	and a, $F8
	rrca
	rrca
	rrca
	ld e, a
	ld d, $00
	add hl, de
	jr .l7474

.l7473 ; 51:7473
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	dec hl

.l7474 ; 51:7474
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	pop de
	push hl
	ld h, e
	ldh a, [hBmp_Height]
	add a, e
	ld l, a
	push hl
	ld a, e
	cp a, $60
	jr c, .l7487

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $03
	ld h, $C1
	jr .l748B

.l7487 ; 51:7487
	; [CONFIRMED] 68 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $02
	ld h, $D0
.l748B ; 51:748B
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	and a, $07
	rlca
	ld l, a
	ld a, e
	and a, $F8
	jr z, .l74A3
	rrca
	rrca
	rrca
	ld bc, $0140
.l749F ; 51:749F
	add hl, bc
	dec a
	jr nz, .l749F
.l74A3 ; 51:74A3
	ld a, d
	and a, $F8
	ld b, $00
	rla
	rl b
	ld c, a
	add hl, bc
	pop bc
	pop de
.l74AF ; 51:74AF
	call Sound_FrameService
	push de
	push hl
	push bc
	call Image_BlitEdgeStrip
	pop bc
	pop hl
	pop de
	inc b
	ld a, b
	and a, $07
	jr nz, .l74D8
	ld a, l
	add a, $32
	ld l, a
	ld a, h
	adc a, $01
	ld h, a
	cp a, $DF
	jr c, .l74DA
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	jr .l74DA
.l74D8 ; 51:74D8
	inc l
	inc l
.l74DA ; 51:74DA
	ldh a, [hImageBlit_SrcRowBytes]
	add a, e
	ld e, a
	jr nc, .l74E1
	inc d
.l74E1 ; 51:74E1
	ld a, c
	cp a, b
	jr nz, .l74AF
	ret

Image_MakeEdgeMasks:: ; 51:74E6
	push bc
	ld a, d
	and a, $07
	jr z, .l74F9

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	xor a, $07
	inc a
	ld b, a
	ld a, $01
.l74F2 ; 51:74F2
	rlca
	dec b
	jr nz, .l74F2
	dec a
	jr .l74FB

.l74F9 ; 51:74F9
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $FF
.l74FB ; 51:74FB
	ldh [hImageBlit_LeftMask], a
	ldh a, [hBmp_Width]
	ld b, a
	ld a, d
	add a, b
	and a, $07
	jr z, .l7511

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld b, a
	ld a, $01
.l7509 ; 51:7509
	rrca
	dec b
	jr nz, .l7509
	dec a
	cpl
	jr .l7513

.l7511 ; 51:7511
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $FF
.l7513 ; 51:7513
	ldh [hImageBlit_RightMask], a
	pop bc
	ret

Image_BlitEdgeStrip:: ; 51:7517
	ldh a, [hImageBlit_DestColumns]
	ld c, a
	cp a, $02
	jr nc, .l7584

	; [PROBABLE] 70 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ldh a, [hImageBlit_BitShift]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, .l752F
.l7529 ; 51:7529
	rla
	rl b
	dec c
	jr nz, .l7529
.l752F ; 51:752F
	push de
	ldh a, [hImageBlit_LeftMask]
	ld d, a
	ldh a, [hImageBlit_RightMask]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l7549
	bit 4, a
	jr nz, .l7546
	xor a, a
	jr .l7553
.l7546 ; 51:7546
	ld a, b
	jr .l7553
.l7549 ; 51:7549
	bit 4, a
	jr nz, .l7551
	ld a, b
	cpl
	jr .l7553
.l7551 ; 51:7551
	ld a, $01
.l7553 ; 51:7553
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l7569
	bit 5, a
	jr nz, .l7566
	xor a, a
	jr .l7573
.l7566 ; 51:7566
	ld a, b
	jr .l7573
.l7569 ; 51:7569
	bit 5, a
	jr nz, .l7571
	ld a, b
	cpl
	jr .l7573
.l7571 ; 51:7571
	ld a, $01
.l7573 ; 51:7573
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	pop de
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .l7581
	inc h
.l7581 ; 51:7581
	jp .done

.l7584 ; 51:7584
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hImageBlit_LeftMask]
	cp a, $FF
	jr z, .l75F1

	; [PROBABLE] 72 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	push bc
	ldh a, [hImageBlit_BitShift]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, .l759C
.l7596 ; 51:7596
	rla
	rl b
	dec c
	jr nz, .l7596
.l759C ; 51:759C
	push de
	ldh a, [hImageBlit_LeftMask]
	ld d, a
	ld a, [ImageBlit_AllBitsMask]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l75B7
	bit 4, a
	jr nz, .l75B4
	xor a, a
	jr .l75C1
.l75B4 ; 51:75B4
	ld a, b
	jr .l75C1
.l75B7 ; 51:75B7
	bit 4, a
	jr nz, .l75BF
	ld a, b
	cpl
	jr .l75C1
.l75BF ; 51:75BF
	ld a, $01
.l75C1 ; 51:75C1
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l75D7
	bit 5, a
	jr nz, .l75D4
	xor a, a
	jr .l75E1
.l75D4 ; 51:75D4
	ld a, b
	jr .l75E1
.l75D7 ; 51:75D7
	bit 5, a
	jr nz, .l75DF
	ld a, b
	cpl
	jr .l75E1
.l75DF ; 51:75DF
	ld a, $01
.l75E1 ; 51:75E1
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	pop de
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .l75EF
	inc h
.l75EF ; 51:75EF
	pop bc
	dec c

.l75F1 ; 51:75F1
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hImageBlit_RightMask]
	cp a, $FF
	jr z, .l75F8

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	dec c

.l75F8 ; 51:75F8
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, c
	or a, a
	jr z, .l7640
	ldh a, [hImageBlit_BitShift]
	bit 2, a
	jr nz, .l7622
	bit 1, a
	jr nz, .l7614
	bit 0, a
	jr nz, .l760F
	call Image_BlitStripShift0
	jr .l7640

.l760F ; 51:760F
	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	call Image_BlitStripShift1
	jr .l7640
.l7614 ; 51:7614
	bit 0, a
	jr nz, .l761D
	call Image_BlitStripShift2
	jr .l7640
.l761D ; 51:761D
	call Image_BlitStripShift3
	jr .l7640
.l7622 ; 51:7622
	bit 1, a
	jr nz, .l7634
	bit 0, a
	jr nz, .l762F
	call Image_BlitStripShift4
	jr .l7640
.l762F ; 51:762F
	call Image_BlitStripShift5
	jr .l7640
.l7634 ; 51:7634
	bit 0, a
	jr nz, .l763D
	call Image_BlitStripShift6
	jr .l7640
.l763D ; 51:763D
	call Image_BlitStripShift7

.l7640 ; 51:7640
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hImageBlit_RightMask]
	cp a, $FF
	jr z, .done

	; [PROBABLE] 69 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ldh a, [hImageBlit_BitShift]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, .l7657
.l7651 ; 51:7651
	rla
	rl b
	dec c
	jr nz, .l7651
.l7657 ; 51:7657
	push de
	ldh a, [hImageBlit_RightMask]
	ld d, a
	ld a, [ImageBlit_AllBitsMask]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l7672
	bit 4, a
	jr nz, .l766F
	xor a, a
	jr .l767C
.l766F ; 51:766F
	ld a, b
	jr .l767C
.l7672 ; 51:7672
	bit 4, a
	jr nz, .l767A
	ld a, b
	cpl
	jr .l767C
.l767A ; 51:767A
	ld a, $01
.l767C ; 51:767C
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l7692
	bit 5, a
	jr nz, .l768F
	xor a, a
	jr .l769C
.l768F ; 51:768F
	ld a, b
	jr .l769C
.l7692 ; 51:7692
	bit 5, a
	jr nz, .l769A
	ld a, b
	cpl
	jr .l769C
.l769A ; 51:769A
	ld a, $01
.l769C ; 51:769C
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	pop de
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .done
	inc h

.done ; 51:76AA
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ret

Image_BlitStripShift0:: ; 51:76AB
	ld a, [de]
	ld b, a
	inc de
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l76BE

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	bit 4, a
	jr nz, .l76BB
	xor a, a
	jr .l76C8
.l76BB ; 51:76BB
	ld a, b
	jr .l76C8

.l76BE ; 51:76BE
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	bit 4, a
	jr nz, .l76C6
	ld a, b
	cpl
	jr .l76C8

.l76C6 ; 51:76C6
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $01

.l76C8 ; 51:76C8
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l76D9

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	bit 5, a
	jr nz, .l76D6
	xor a, a
	jr .l76E3
.l76D6 ; 51:76D6
	ld a, b
	jr .l76E3

.l76D9 ; 51:76D9
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	bit 5, a
	jr nz, .l76E1
	ld a, b
	cpl
	jr .l76E3

.l76E1 ; 51:76E1
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $01

.l76E3 ; 51:76E3
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:76EB
	dec c
	jr nz, Image_BlitStripShift0
	ret

Image_BlitStripShift1:: ; 51:76EF
	; [PROBABLE] 340 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rla
	rl b
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l7706
	bit 4, a
	jr nz, .l7703
	xor a, a
	jr .l7710
.l7703 ; 51:7703
	ld a, b
	jr .l7710
.l7706 ; 51:7706
	bit 4, a
	jr nz, .l770E
	ld a, b
	cpl
	jr .l7710
.l770E ; 51:770E
	ld a, $01
.l7710 ; 51:7710
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l7721
	bit 5, a
	jr nz, .l771E
	xor a, a
	jr .l772B
.l771E ; 51:771E
	ld a, b
	jr .l772B
.l7721 ; 51:7721
	bit 5, a
	jr nz, .l7729
	ld a, b
	cpl
	jr .l772B
.l7729 ; 51:7729
	ld a, $01
.l772B ; 51:772B
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:7733
	dec c
	jr nz, Image_BlitStripShift1
	ret

Image_BlitStripShift2:: ; 51:7737
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rla
	rl b
	rla
	rl b
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l7751
	bit 4, a
	jr nz, .l774E
	xor a, a
	jr .l775B
.l774E ; 51:774E
	ld a, b
	jr .l775B
.l7751 ; 51:7751
	bit 4, a
	jr nz, .l7759
	ld a, b
	cpl
	jr .l775B
.l7759 ; 51:7759
	ld a, $01
.l775B ; 51:775B
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l776C
	bit 5, a
	jr nz, .l7769
	xor a, a
	jr .l7776
.l7769 ; 51:7769
	ld a, b
	jr .l7776
.l776C ; 51:776C
	bit 5, a
	jr nz, .l7774
	ld a, b
	cpl
	jr .l7776
.l7774 ; 51:7774
	ld a, $01
.l7776 ; 51:7776
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:777E
	dec c
	jr nz, Image_BlitStripShift2
	ret

Image_BlitStripShift3:: ; 51:7782
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rla
	rl b
	rla
	rl b
	rla
	rl b
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l779F
	bit 4, a
	jr nz, .l779C
	xor a, a
	jr .l77A9
.l779C ; 51:779C
	ld a, b
	jr .l77A9
.l779F ; 51:779F
	bit 4, a
	jr nz, .l77A7
	ld a, b
	cpl
	jr .l77A9
.l77A7 ; 51:77A7
	ld a, $01
.l77A9 ; 51:77A9
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l77BA
	bit 5, a
	jr nz, .l77B7
	xor a, a
	jr .l77C4
.l77B7 ; 51:77B7
	ld a, b
	jr .l77C4
.l77BA ; 51:77BA
	bit 5, a
	jr nz, .l77C2
	ld a, b
	cpl
	jr .l77C4
.l77C2 ; 51:77C2
	ld a, $01
.l77C4 ; 51:77C4
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:77CC
	dec c
	jr nz, Image_BlitStripShift3
	ret

Image_BlitStripShift4:: ; 51:77D0
	ld a, [de]
	and a, $0F
	ld b, a
	inc de
	ld a, [de]
	and a, $F0
	or a, b
	swap a
	ld b, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l77EC
	bit 4, a
	jr nz, .l77E9
	xor a, a
	jr .l77F6
.l77E9 ; 51:77E9
	ld a, b
	jr .l77F6
.l77EC ; 51:77EC
	bit 4, a
	jr nz, .l77F4
	ld a, b
	cpl
	jr .l77F6
.l77F4 ; 51:77F4
	ld a, $01
.l77F6 ; 51:77F6
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l7807
	bit 5, a
	jr nz, .l7804
	xor a, a
	jr .l7811
.l7804 ; 51:7804
	ld a, b
	jr .l7811
.l7807 ; 51:7807
	bit 5, a
	jr nz, .l780F
	ld a, b
	cpl
	jr .l7811
.l780F ; 51:780F
	ld a, $01
.l7811 ; 51:7811
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:7819
	dec c
	jr nz, Image_BlitStripShift4
	ret

Image_BlitStripShift5:: ; 51:781D
	ld a, [de]
	and a, $07
	ld b, a
	inc de
	ld a, [de]
	and a, $F8
	or a, b
	rrca
	rrca
	rrca
	ld b, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l783A
	bit 4, a
	jr nz, .l7837
	xor a, a
	jr .l7844
.l7837 ; 51:7837
	ld a, b
	jr .l7844
.l783A ; 51:783A
	bit 4, a
	jr nz, .l7842
	ld a, b
	cpl
	jr .l7844
.l7842 ; 51:7842
	ld a, $01
.l7844 ; 51:7844
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l7855
	bit 5, a
	jr nz, .l7852
	xor a, a
	jr .l785F
.l7852 ; 51:7852
	ld a, b
	jr .l785F
.l7855 ; 51:7855
	bit 5, a
	jr nz, .l785D
	ld a, b
	cpl
	jr .l785F
.l785D ; 51:785D
	ld a, $01
.l785F ; 51:785F
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:7867
	dec c
	jr nz, Image_BlitStripShift5
	ret

Image_BlitStripShift6:: ; 51:786B
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rr b
	rra
	rr b
	rra
	ld b, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l7886
	bit 4, a
	jr nz, .l7883
	xor a, a
	jr .l7890
.l7883 ; 51:7883
	ld a, b
	jr .l7890
.l7886 ; 51:7886
	bit 4, a
	jr nz, .l788E
	ld a, b
	cpl
	jr .l7890
.l788E ; 51:788E
	ld a, $01
.l7890 ; 51:7890
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l78A1
	bit 5, a
	jr nz, .l789E
	xor a, a
	jr .l78AB
.l789E ; 51:789E
	ld a, b
	jr .l78AB
.l78A1 ; 51:78A1
	bit 5, a
	jr nz, .l78A9
	ld a, b
	cpl
	jr .l78AB
.l78A9 ; 51:78A9
	ld a, $01
.l78AB ; 51:78AB
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:78B3
	dec c
	jr nz, Image_BlitStripShift6
	ret

Image_BlitStripShift7:: ; 51:78B7
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rr b
	rra
	ld b, a
	ldh a, [hImageBlit_Colors]
	bit 0, a
	jr nz, .l78CF
	bit 4, a
	jr nz, .l78CC
	xor a, a
	jr .l78D9
.l78CC ; 51:78CC
	ld a, b
	jr .l78D9
.l78CF ; 51:78CF
	bit 4, a
	jr nz, .l78D7
	ld a, b
	cpl
	jr .l78D9
.l78D7 ; 51:78D7
	ld a, $01
.l78D9 ; 51:78D9
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .l78EA
	bit 5, a
	jr nz, .l78E7
	xor a, a
	jr .l78F4
.l78E7 ; 51:78E7
	ld a, b
	jr .l78F4
.l78EA ; 51:78EA
	bit 5, a
	jr nz, .l78F2
	ld a, b
	cpl
	jr .l78F4
.l78F2 ; 51:78F2
	ld a, $01
.l78F4 ; 51:78F4
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, .skip
	inc h
.skip ; 51:78FC
	dec c
	jr nz, Image_BlitStripShift7
	ret
