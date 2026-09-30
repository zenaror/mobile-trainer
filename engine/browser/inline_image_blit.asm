; engine/browser/inline_image_blit.asm
; bank 51, $70E0-$7900 (2080 bytes); pinned by layout.link
; 1-bit BMP validator/converter and tile-canvas blitters for inline images

SECTION "engine/browser/inline_image_blit", ROMX

; ---- code $70E0-$7157 (119 bytes) [CONFIRMED] 500 insn(s) reached by static flow only; seeds: exec x500; min discovery hops 1; entered by far from 4C:4E56 (PROBABLE code) | 83 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 1 scenarios]

Bmp_Validate:: ; 51:70E0
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
	jr nz, Label_51_7157
	ld a, [hli]
	cp a, $4D
	jr nz, Label_51_7157
	ld de, $0008
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	or a, [hl]
	jr nz, Label_51_7157
	ld de, $0005
	add hl, de
	ld a, [hli]
	ldh [hRam_FFD6], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	or a, e
	ld a, [hli]
	or a, e
	jr nz, Label_51_7157
	ld a, [hli]
	ldh [hRam_FFD7], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	and a, e
	ld a, [hli]
	and a, e
	jr z, Label_51_712E
	cp a, $FF
	jr nz, Label_51_7157
	ld [wRam_C33F], a
	jr Label_51_7132

Label_51_712E:: ; 51:712E
	xor a, a
	ld [wRam_C33F], a

Label_51_7132:: ; 51:7132
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, Label_51_7157
	inc hl
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, Label_51_7157
	inc hl
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, Label_51_7157
	ld de, $000D
	add hl, de
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, Label_51_7157
	pop hl
	add hl, bc
	ld a, $01
	ret

; ---- code $7157-$7161 (10 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split

Label_51_7157:: ; 51:7157
	xor a, a
	ldh [hRam_FFD6], a
	ldh [hRam_FFD7], a
	ld [wRam_C33F], a
	pop hl
	ret

; ---- code $7161-$7268 (263 bytes) [CONFIRMED] 155 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 1 scenarios]

Bmp_CheckSize:: ; 51:7161
	ldh a, [hRam_FFD6]
	cp a, $91
	jr nc, Label_51_7175
	ld d, a
	ldh a, [hRam_FFD7]
	or a, a
	jr z, Label_51_7175
	cp a, $61
	jr nc, Label_51_7175
	ld e, a
	ld a, $01
	ret

Label_51_7175:: ; 51:7175
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
	ld a, [wRam_C33F]
	or a, a
	jp nz, Label_51_73CB
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
	ld [wRam_C331], a
	ld hl, $0017
	add hl, de
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hRam_FFD6]
	add a, $07
	jp c, Label_51_73CE
	and a, $F8
	rrca
	rrca
	rrca
	ld [wBrowserNavigating], a
	add a, $03
	jp c, Label_51_73CE
	and a, $FC
	ld [wHtmlScanOnly], a
	ldh a, [hRam_FFD7]
	call Bmp_RoundUpToTextRow
	ld [wRam_C333], a
	ld e, a
	ldh a, [hRam_FFD6]
	call Bmp_RoundUpToTextRow
	ld [wRam_C332], a
	add a, $07
	jp c, Label_51_73CE
	and a, $F8
	rrca
	rrca
	rrca
	add a, $03
	jp c, Label_51_73CE
	and a, $FC
	ldh [hRam_FFD4], a
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
	ldh a, [hRam_FFD4]
	and a, $1F
	rlca
	rlca
	rlca
	ld [wHtmlLinkHeapPtr], a
	ld [hli], a
	ld a, [wRam_C333]
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
	call Function_00_0392
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld a, $FF
	call FillBytes
	ldh a, [hRam_FFD7]
	dec a
	ld e, a
	ldh a, [hRam_FFD4]
	ld d, $00
	call Multiply8x16
	ld de, $D000
	add hl, de
	ld e, l
	ld d, h
	pop hl

Label_51_7251:: ; 51:7251
	call Function_00_0392
	ld a, [wBrowserNavigating]
	ld c, a
	ld b, $00
	push hl
	push de
	push de
	call CopyBytes
	pop hl
	ld a, [wRam_C331]
	bit 7, a
	jr z, Label_51_7276

; ---- code $7268-$7276 (14 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split
	ld a, [wBrowserNavigating]
	or a, a
	jr z, Label_51_7276
	ld c, a

Label_51_726F:: ; 51:726F
	ld a, [hl]
	xor a, $FF
	ld [hli], a
	dec c
	jr nz, Label_51_726F

; ---- code $7276-$727C (6 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 2 scenarios]

Label_51_7276:: ; 51:7276
	ldh a, [hRam_FFD6]
	and a, $07
	jr z, Label_51_7287

; ---- code $727C-$7287 (11 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split
	dec de
	ld c, a
	ld b, $00
	ld hl, Table_Bmp_RowEndMask
	add hl, bc
	ld a, [de]
	or a, [hl]
	ld [de], a

; ---- code $7287-$72C4 (61 bytes) [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 2 scenarios]

Label_51_7287:: ; 51:7287
	pop de
	pop hl
	ld a, [wHtmlScanOnly]
	ld c, a
	ld b, $00
	add hl, bc
	ldh a, [hRam_FFD4]
	ld c, a
	ld a, e
	sub a, c
	ld e, a
	ld a, d
	sbc a, $00
	ld d, a
	cp a, $D0
	jr nc, Label_51_7251
	call Function_00_0392
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
	jr c, Label_51_72D4

; ---- code $72C4-$72D4 (16 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split
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
	jp Label_51_73CE

; ---- code $72D4-$7344 (112 bytes) [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 1 scenarios]

Label_51_72D4:: ; 51:72D4
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

Label_51_72F8:: ; 51:72F8
	ld a, [wHtmlListCounter + 1]
	add a, c
	ld a, [wHtmlAlign]
	adc a, b
	cp a, $C0
	jr nc, Label_51_7383
	ld a, b
	cp a, $10
	jp nc, Label_51_7383
	ld e, c
	ld d, b
	ld a, [hli]
	ld a, [hli]
	ld a, [hli]
	or a, a
	jp z, Label_51_7383
	inc bc
	inc bc

Label_51_7315:: ; 51:7315
	inc bc
	ld a, [hli]
	or a, a
	jr nz, Label_51_7315
	push bc
	push de
	push hl
	ld e, l
	ld d, h
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hRam_FFCE]
	ld c, a
	ldh a, [hRam_FFCF]
	ld b, a
	or a, c
	jr z, Label_51_7365
	ldh a, [hRam_FFCC]
	ld l, a
	ldh a, [hRam_FFCD]
	ld h, a

Label_51_7334:: ; 51:7334
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	push bc
	push hl
	ld bc, $0008
	add hl, bc
	ld a, [hl]
	cp a, $04
	jr nz, Label_51_735A

; ---- code $7344-$735A (22 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split
	ld bc, $0003
	add hl, bc
	ld a, [hli]
	cp a, e
	jr nz, Label_51_735A
	ld a, [hld]
	cp a, d
	jr nz, Label_51_735A
	ld a, [wHtmlBoldCount + 1]
	add a, e
	ld [hli], a
	ld a, [wHtmlListCounter]
	adc a, d
	ld [hli], a

; ---- code $735A-$73CE (116 bytes) [CONFIRMED] 82 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split [executed in 1 scenarios]

Label_51_735A:: ; 51:735A
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jr nz, Label_51_7334

Label_51_7365:: ; 51:7365
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
	jp Label_51_72F8

Label_51_7383:: ; 51:7383
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
	ld hl, $D001
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
	jr z, Label_51_73AB
	call CopyBytes

Label_51_73AB:: ; 51:73AB
	pop bc
	call Function_00_0392
	pop de
	ld hl, $D000
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
	ld a, [wRam_C333]
	ldh [hRam_FFD7], a
	ld a, [wHtmlLinkHeapPtr]
	ldh [hRam_FFD6], a
	pop hl

Label_51_73CB:: ; 51:73CB
	ld a, $01
	ret

; ---- code $73CE-$73D1 (3 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 70E0-73D1 by apply_coverage --split

Label_51_73CE:: ; 51:73CE
	pop hl
	xor a, a
	ret

; ---- data $73D1-$73DA (9 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [boundary trimmed 73D1-73E9 -> 73D1-73DA against proven code]

Table_Bmp_RowEndMask:: ; 51:73D1
Data_51_73D1::
	db $FF, $7F, $3F, $1F, $0F, $07, $03, $01, $00

; ---- code $73DA-$740C (50 bytes) [CONFIRMED] 43 insn(s) reached by static flow only; seeds: exec x43; min discovery hops 2; entered by call from 51:719C (PROBABLE code) [executed in 1 scenarios]

Bmp_ColorSum:: ; 51:73DA
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
	jr z, Label_51_7402
	inc de

Label_51_7402:: ; 51:7402
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

; ---- data $740C-$740D (1 bytes) [HYPOTHESIS] single $FF byte between the ret at 740B and the function at 740D (ldh [$FFD0],a ...); probably padding, not referenced, not an instruction reached by flow

Data_51_740C:: ; 51:740C
	db $FF

; ---- code $740D-$7430 (35 bytes) [CONFIRMED] 822 insn(s) reached by static flow only; seeds: site x822; min discovery hops 1; entered by far from 4E:5B5C (PROBABLE code) | 19 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Image_BlitToTileCanvas:: ; 51:740D
	ldh [hRam_FFD0], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Image_MakeEdgeMasks
	call Function_00_0392
	push bc
	ld a, d
	and a, $07
	xor a, $07
	inc a
	ld c, a
	add a, b
	and a, $07
	ldh [hRam_FFD5], a
	ld b, $00
	ld a, c
	and a, $07
	jr z, Label_51_7431

; ---- code $7430-$7431 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	inc b

; ---- code $7431-$7451 (32 bytes) [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7431:: ; 51:7431
	ld c, a
	ldh a, [hRam_FFD6]
	sub a, c
	add a, $07
	and a, $F8
	rrca
	rrca
	rrca
	add a, b
	ldh [hRam_FFD4], a
	pop bc
	inc hl
	inc hl
	ld a, [hli]
	add a, $07
	and a, $F8
	rrca
	rrca
	rrca
	ldh [hRam_FFD3], a
	inc hl
	ld a, c
	or a, a
	jr z, Label_51_745D

; ---- code $7451-$745D (12 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	push de
	ldh a, [hRam_FFD3]
	ld e, a
	ld d, $00
	ld a, c

Label_51_7458:: ; 51:7458
	add hl, de
	dec a
	jr nz, Label_51_7458
	pop de

; ---- code $745D-$7473 (22 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_745D:: ; 51:745D
	push de
	ld a, d
	and a, $07
	ld d, a
	ld a, b
	sub a, d
	cp a, $F9
	jr nc, Label_51_7473
	and a, $F8
	rrca
	rrca
	rrca
	ld e, a
	ld d, $00
	add hl, de
	jr Label_51_7474

; ---- code $7473-$7474 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split

Label_51_7473:: ; 51:7473
	dec hl

; ---- code $7474-$7481 (13 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7474:: ; 51:7474
	pop de
	push hl
	ld h, e
	ldh a, [hRam_FFD7]
	add a, e
	ld l, a
	push hl
	ld a, e
	cp a, $60
	jr c, Label_51_7487

; ---- code $7481-$7487 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	ld a, $03
	ld h, $C1
	jr Label_51_748B

; ---- code $7487-$74EC (101 bytes) [CONFIRMED] 68 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7487:: ; 51:7487
	ld a, $02
	ld h, $D0

Label_51_748B:: ; 51:748B
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	and a, $07
	rlca
	ld l, a
	ld a, e
	and a, $F8
	jr z, Label_51_74A3
	rrca
	rrca
	rrca
	ld bc, $0140

Label_51_749F:: ; 51:749F
	add hl, bc
	dec a
	jr nz, Label_51_749F

Label_51_74A3:: ; 51:74A3
	ld a, d
	and a, $F8
	ld b, $00
	rla
	rl b
	ld c, a
	add hl, bc
	pop bc
	pop de

Label_51_74AF:: ; 51:74AF
	call Function_00_0392
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
	jr nz, Label_51_74D8
	ld a, l
	add a, $32
	ld l, a
	ld a, h
	adc a, $01
	ld h, a
	cp a, $DF
	jr c, Label_51_74DA
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	jr Label_51_74DA

Label_51_74D8:: ; 51:74D8
	inc l
	inc l

Label_51_74DA:: ; 51:74DA
	ldh a, [hRam_FFD3]
	add a, e
	ld e, a
	jr nc, Label_51_74E1
	inc d

Label_51_74E1:: ; 51:74E1
	ld a, c
	cp a, b
	jr nz, Label_51_74AF
	ret

Image_MakeEdgeMasks:: ; 51:74E6
	push bc
	ld a, d
	and a, $07
	jr z, Label_51_74F9

; ---- code $74EC-$74F9 (13 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	xor a, $07
	inc a
	ld b, a
	ld a, $01

Label_51_74F2:: ; 51:74F2
	rlca
	dec b
	jr nz, Label_51_74F2
	dec a
	jr Label_51_74FB

; ---- code $74F9-$7506 (13 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_74F9:: ; 51:74F9
	ld a, $FF

Label_51_74FB:: ; 51:74FB
	ldh [hRam_FFD1], a
	ldh a, [hRam_FFD6]
	ld b, a
	ld a, d
	add a, b
	and a, $07
	jr z, Label_51_7511

; ---- code $7506-$7511 (11 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	ld b, a
	ld a, $01

Label_51_7509:: ; 51:7509
	rrca
	dec b
	jr nz, Label_51_7509
	dec a
	cpl
	jr Label_51_7513

; ---- code $7511-$751E (13 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7511:: ; 51:7511
	ld a, $FF

Label_51_7513:: ; 51:7513
	ldh [hRam_FFD2], a
	pop bc
	ret

Image_BlitEdgeStrip:: ; 51:7517
	ldh a, [hRam_FFD4]
	ld c, a
	cp a, $02
	jr nc, Label_51_7584

; ---- code $751E-$7584 (102 bytes) [PROBABLE] 70 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	ldh a, [hRam_FFD5]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, Label_51_752F

Label_51_7529:: ; 51:7529
	rla
	rl b
	dec c
	jr nz, Label_51_7529

Label_51_752F:: ; 51:752F
	push de
	ldh a, [hRam_FFD1]
	ld d, a
	ldh a, [hRam_FFD2]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_7549
	bit 4, a
	jr nz, Label_51_7546
	xor a, a
	jr Label_51_7553

Label_51_7546:: ; 51:7546
	ld a, b
	jr Label_51_7553

Label_51_7549:: ; 51:7549
	bit 4, a
	jr nz, Label_51_7551
	ld a, b
	cpl
	jr Label_51_7553

Label_51_7551:: ; 51:7551
	ld a, $01

Label_51_7553:: ; 51:7553
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_7569
	bit 5, a
	jr nz, Label_51_7566
	xor a, a
	jr Label_51_7573

Label_51_7566:: ; 51:7566
	ld a, b
	jr Label_51_7573

Label_51_7569:: ; 51:7569
	bit 5, a
	jr nz, Label_51_7571
	ld a, b
	cpl
	jr Label_51_7573

Label_51_7571:: ; 51:7571
	ld a, $01

Label_51_7573:: ; 51:7573
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
	jr nc, Label_51_7581
	inc h

Label_51_7581:: ; 51:7581
	jp Label_51_76AA

; ---- code $7584-$758A (6 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7584:: ; 51:7584
	ldh a, [hRam_FFD1]
	cp a, $FF
	jr z, Label_51_75F1

; ---- code $758A-$75F1 (103 bytes) [PROBABLE] 72 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	push bc
	ldh a, [hRam_FFD5]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, Label_51_759C

Label_51_7596:: ; 51:7596
	rla
	rl b
	dec c
	jr nz, Label_51_7596

Label_51_759C:: ; 51:759C
	push de
	ldh a, [hRam_FFD1]
	ld d, a
	ld a, [$740C]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_75B7
	bit 4, a
	jr nz, Label_51_75B4
	xor a, a
	jr Label_51_75C1

Label_51_75B4:: ; 51:75B4
	ld a, b
	jr Label_51_75C1

Label_51_75B7:: ; 51:75B7
	bit 4, a
	jr nz, Label_51_75BF
	ld a, b
	cpl
	jr Label_51_75C1

Label_51_75BF:: ; 51:75BF
	ld a, $01

Label_51_75C1:: ; 51:75C1
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_75D7
	bit 5, a
	jr nz, Label_51_75D4
	xor a, a
	jr Label_51_75E1

Label_51_75D4:: ; 51:75D4
	ld a, b
	jr Label_51_75E1

Label_51_75D7:: ; 51:75D7
	bit 5, a
	jr nz, Label_51_75DF
	ld a, b
	cpl
	jr Label_51_75E1

Label_51_75DF:: ; 51:75DF
	ld a, $01

Label_51_75E1:: ; 51:75E1
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
	jr nc, Label_51_75EF
	inc h

Label_51_75EF:: ; 51:75EF
	pop bc
	dec c

; ---- code $75F1-$75F7 (6 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_75F1:: ; 51:75F1
	ldh a, [hRam_FFD2]
	cp a, $FF
	jr z, Label_51_75F8

; ---- code $75F7-$75F8 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	dec c

; ---- code $75F8-$760F (23 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_75F8:: ; 51:75F8
	ld a, c
	or a, a
	jr z, Label_51_7640
	ldh a, [hRam_FFD5]
	bit 2, a
	jr nz, Label_51_7622
	bit 1, a
	jr nz, Label_51_7614
	bit 0, a
	jr nz, Label_51_760F
	call Image_BlitStripShift0
	jr Label_51_7640

; ---- code $760F-$7640 (49 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split

Label_51_760F:: ; 51:760F
	call Image_BlitStripShift1
	jr Label_51_7640

Label_51_7614:: ; 51:7614
	bit 0, a
	jr nz, Label_51_761D
	call Image_BlitStripShift2
	jr Label_51_7640

Label_51_761D:: ; 51:761D
	call Image_BlitStripShift3
	jr Label_51_7640

Label_51_7622:: ; 51:7622
	bit 1, a
	jr nz, Label_51_7634
	bit 0, a
	jr nz, Label_51_762F
	call Image_BlitStripShift4
	jr Label_51_7640

Label_51_762F:: ; 51:762F
	call Image_BlitStripShift5
	jr Label_51_7640

Label_51_7634:: ; 51:7634
	bit 0, a
	jr nz, Label_51_763D
	call Image_BlitStripShift6
	jr Label_51_7640

Label_51_763D:: ; 51:763D
	call Image_BlitStripShift7

; ---- code $7640-$7646 (6 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_7640:: ; 51:7640
	ldh a, [hRam_FFD2]
	cp a, $FF
	jr z, Label_51_76AA

; ---- code $7646-$76AA (100 bytes) [PROBABLE] 69 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	ldh a, [hRam_FFD5]
	ld c, a
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	dec c
	inc c
	jr z, Label_51_7657

Label_51_7651:: ; 51:7651
	rla
	rl b
	dec c
	jr nz, Label_51_7651

Label_51_7657:: ; 51:7657
	push de
	ldh a, [hRam_FFD2]
	ld d, a
	ld a, [$740C]
	and a, d
	ld d, a
	cpl
	ld e, a
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_7672
	bit 4, a
	jr nz, Label_51_766F
	xor a, a
	jr Label_51_767C

Label_51_766F:: ; 51:766F
	ld a, b
	jr Label_51_767C

Label_51_7672:: ; 51:7672
	bit 4, a
	jr nz, Label_51_767A
	ld a, b
	cpl
	jr Label_51_767C

Label_51_767A:: ; 51:767A
	ld a, $01

Label_51_767C:: ; 51:767C
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_7692
	bit 5, a
	jr nz, Label_51_768F
	xor a, a
	jr Label_51_769C

Label_51_768F:: ; 51:768F
	ld a, b
	jr Label_51_769C

Label_51_7692:: ; 51:7692
	bit 5, a
	jr nz, Label_51_769A
	ld a, b
	cpl
	jr Label_51_769C

Label_51_769A:: ; 51:769A
	ld a, $01

Label_51_769C:: ; 51:769C
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
	jr nc, Label_51_76AA
	inc h

; ---- code $76AA-$76B4 (10 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_76AA:: ; 51:76AA
	ret

Image_BlitStripShift0:: ; 51:76AB
	ld a, [de]
	ld b, a
	inc de
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_76BE

; ---- code $76B4-$76BE (10 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	bit 4, a
	jr nz, Label_51_76BB
	xor a, a
	jr Label_51_76C8

Label_51_76BB:: ; 51:76BB
	ld a, b
	jr Label_51_76C8

; ---- code $76BE-$76C6 (8 bytes) [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_76BE:: ; 51:76BE
	bit 4, a
	jr nz, Label_51_76C6
	ld a, b
	cpl
	jr Label_51_76C8

; ---- code $76C6-$76C8 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split

Label_51_76C6:: ; 51:76C6
	ld a, $01

; ---- code $76C8-$76CF (7 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_76C8:: ; 51:76C8
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_76D9

; ---- code $76CF-$76D9 (10 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split
	bit 5, a
	jr nz, Label_51_76D6
	xor a, a
	jr Label_51_76E3

Label_51_76D6:: ; 51:76D6
	ld a, b
	jr Label_51_76E3

; ---- code $76D9-$76E1 (8 bytes) [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_76D9:: ; 51:76D9
	bit 5, a
	jr nz, Label_51_76E1
	ld a, b
	cpl
	jr Label_51_76E3

; ---- code $76E1-$76E3 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split

Label_51_76E1:: ; 51:76E1
	ld a, $01

; ---- code $76E3-$76EF (12 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage --split [executed in 1 scenarios]

Label_51_76E3:: ; 51:76E3
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_76EB
	inc h

Label_51_76EB:: ; 51:76EB
	dec c
	jr nz, Image_BlitStripShift0
	ret

; ---- code $76EF-$7900 (529 bytes) [PROBABLE] 340 insn(s) never executed in the traced runs; cut out of the PROBABLE region 740D-7900 by apply_coverage --split

Image_BlitStripShift1:: ; 51:76EF
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	rla
	rl b
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_7706
	bit 4, a
	jr nz, Label_51_7703
	xor a, a
	jr Label_51_7710

Label_51_7703:: ; 51:7703
	ld a, b
	jr Label_51_7710

Label_51_7706:: ; 51:7706
	bit 4, a
	jr nz, Label_51_770E
	ld a, b
	cpl
	jr Label_51_7710

Label_51_770E:: ; 51:770E
	ld a, $01

Label_51_7710:: ; 51:7710
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_7721
	bit 5, a
	jr nz, Label_51_771E
	xor a, a
	jr Label_51_772B

Label_51_771E:: ; 51:771E
	ld a, b
	jr Label_51_772B

Label_51_7721:: ; 51:7721
	bit 5, a
	jr nz, Label_51_7729
	ld a, b
	cpl
	jr Label_51_772B

Label_51_7729:: ; 51:7729
	ld a, $01

Label_51_772B:: ; 51:772B
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_7733
	inc h

Label_51_7733:: ; 51:7733
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_7751
	bit 4, a
	jr nz, Label_51_774E
	xor a, a
	jr Label_51_775B

Label_51_774E:: ; 51:774E
	ld a, b
	jr Label_51_775B

Label_51_7751:: ; 51:7751
	bit 4, a
	jr nz, Label_51_7759
	ld a, b
	cpl
	jr Label_51_775B

Label_51_7759:: ; 51:7759
	ld a, $01

Label_51_775B:: ; 51:775B
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_776C
	bit 5, a
	jr nz, Label_51_7769
	xor a, a
	jr Label_51_7776

Label_51_7769:: ; 51:7769
	ld a, b
	jr Label_51_7776

Label_51_776C:: ; 51:776C
	bit 5, a
	jr nz, Label_51_7774
	ld a, b
	cpl
	jr Label_51_7776

Label_51_7774:: ; 51:7774
	ld a, $01

Label_51_7776:: ; 51:7776
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_777E
	inc h

Label_51_777E:: ; 51:777E
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_779F
	bit 4, a
	jr nz, Label_51_779C
	xor a, a
	jr Label_51_77A9

Label_51_779C:: ; 51:779C
	ld a, b
	jr Label_51_77A9

Label_51_779F:: ; 51:779F
	bit 4, a
	jr nz, Label_51_77A7
	ld a, b
	cpl
	jr Label_51_77A9

Label_51_77A7:: ; 51:77A7
	ld a, $01

Label_51_77A9:: ; 51:77A9
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_77BA
	bit 5, a
	jr nz, Label_51_77B7
	xor a, a
	jr Label_51_77C4

Label_51_77B7:: ; 51:77B7
	ld a, b
	jr Label_51_77C4

Label_51_77BA:: ; 51:77BA
	bit 5, a
	jr nz, Label_51_77C2
	ld a, b
	cpl
	jr Label_51_77C4

Label_51_77C2:: ; 51:77C2
	ld a, $01

Label_51_77C4:: ; 51:77C4
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_77CC
	inc h

Label_51_77CC:: ; 51:77CC
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_77EC
	bit 4, a
	jr nz, Label_51_77E9
	xor a, a
	jr Label_51_77F6

Label_51_77E9:: ; 51:77E9
	ld a, b
	jr Label_51_77F6

Label_51_77EC:: ; 51:77EC
	bit 4, a
	jr nz, Label_51_77F4
	ld a, b
	cpl
	jr Label_51_77F6

Label_51_77F4:: ; 51:77F4
	ld a, $01

Label_51_77F6:: ; 51:77F6
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_7807
	bit 5, a
	jr nz, Label_51_7804
	xor a, a
	jr Label_51_7811

Label_51_7804:: ; 51:7804
	ld a, b
	jr Label_51_7811

Label_51_7807:: ; 51:7807
	bit 5, a
	jr nz, Label_51_780F
	ld a, b
	cpl
	jr Label_51_7811

Label_51_780F:: ; 51:780F
	ld a, $01

Label_51_7811:: ; 51:7811
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_7819
	inc h

Label_51_7819:: ; 51:7819
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_783A
	bit 4, a
	jr nz, Label_51_7837
	xor a, a
	jr Label_51_7844

Label_51_7837:: ; 51:7837
	ld a, b
	jr Label_51_7844

Label_51_783A:: ; 51:783A
	bit 4, a
	jr nz, Label_51_7842
	ld a, b
	cpl
	jr Label_51_7844

Label_51_7842:: ; 51:7842
	ld a, $01

Label_51_7844:: ; 51:7844
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_7855
	bit 5, a
	jr nz, Label_51_7852
	xor a, a
	jr Label_51_785F

Label_51_7852:: ; 51:7852
	ld a, b
	jr Label_51_785F

Label_51_7855:: ; 51:7855
	bit 5, a
	jr nz, Label_51_785D
	ld a, b
	cpl
	jr Label_51_785F

Label_51_785D:: ; 51:785D
	ld a, $01

Label_51_785F:: ; 51:785F
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_7867
	inc h

Label_51_7867:: ; 51:7867
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_7886
	bit 4, a
	jr nz, Label_51_7883
	xor a, a
	jr Label_51_7890

Label_51_7883:: ; 51:7883
	ld a, b
	jr Label_51_7890

Label_51_7886:: ; 51:7886
	bit 4, a
	jr nz, Label_51_788E
	ld a, b
	cpl
	jr Label_51_7890

Label_51_788E:: ; 51:788E
	ld a, $01

Label_51_7890:: ; 51:7890
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_78A1
	bit 5, a
	jr nz, Label_51_789E
	xor a, a
	jr Label_51_78AB

Label_51_789E:: ; 51:789E
	ld a, b
	jr Label_51_78AB

Label_51_78A1:: ; 51:78A1
	bit 5, a
	jr nz, Label_51_78A9
	ld a, b
	cpl
	jr Label_51_78AB

Label_51_78A9:: ; 51:78A9
	ld a, $01

Label_51_78AB:: ; 51:78AB
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_78B3
	inc h

Label_51_78B3:: ; 51:78B3
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
	ldh a, [hRam_FFD0]
	bit 0, a
	jr nz, Label_51_78CF
	bit 4, a
	jr nz, Label_51_78CC
	xor a, a
	jr Label_51_78D9

Label_51_78CC:: ; 51:78CC
	ld a, b
	jr Label_51_78D9

Label_51_78CF:: ; 51:78CF
	bit 4, a
	jr nz, Label_51_78D7
	ld a, b
	cpl
	jr Label_51_78D9

Label_51_78D7:: ; 51:78D7
	ld a, $01

Label_51_78D9:: ; 51:78D9
	ld [hli], a
	ldh a, [hRam_FFD0]
	bit 1, a
	jr nz, Label_51_78EA
	bit 5, a
	jr nz, Label_51_78E7
	xor a, a
	jr Label_51_78F4

Label_51_78E7:: ; 51:78E7
	ld a, b
	jr Label_51_78F4

Label_51_78EA:: ; 51:78EA
	bit 5, a
	jr nz, Label_51_78F2
	ld a, b
	cpl
	jr Label_51_78F4

Label_51_78F2:: ; 51:78F2
	ld a, $01

Label_51_78F4:: ; 51:78F4
	ld [hli], a
	ld a, $0E
	add a, l
	ld l, a
	jr nc, Label_51_78FC
	inc h

Label_51_78FC:: ; 51:78FC
	dec c
	jr nz, Image_BlitStripShift7
	ret
