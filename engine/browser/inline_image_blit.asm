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
	jr nz, .reject_header
	ld a, [hli]
	cp a, $4D
	jr nz, .reject_header
	ld de, $0008
	add hl, de
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	or a, [hl]
	jr nz, .reject_header
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
	jr nz, .reject_header
	ld a, [hli]
	ldh [hBmp_Height], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	and a, e
	ld a, [hli]
	and a, e
	jr z, .clear_top_down_flag
	cp a, $FF
	jr nz, .reject_header
	ld [wBmpTopDownFlag], a
	jr .check_remaining_header_fields
.clear_top_down_flag ; 51:712E
	xor a, a
	ld [wBmpTopDownFlag], a
.check_remaining_header_fields ; 51:7132
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, .reject_header
	inc hl
	ld a, [hli]
	dec a
	or a, [hl]
	jr nz, .reject_header
	inc hl
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, .reject_header
	ld de, $000D
	add hl, de
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	jr nz, .reject_header
	pop hl
	add hl, bc
	ld a, $01
	ret

.reject_header ; 51:7157
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
	jr nc, .reject_size
	ld d, a
	ldh a, [hBmp_Height]
	or a, a
	jr z, .reject_size
	cp a, $61
	jr nc, .reject_size
	ld e, a
	ld a, $01
	ret
.reject_size ; 51:7175
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
	jp nz, .return_success
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
	jp c, .return_failure
	and a, $F8
	rrca
	rrca
	rrca
	ld [wBrowserNavigating], a
	add a, $03
	jp c, .return_failure
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
	jp c, .return_failure
	and a, $F8
	rrca
	rrca
	rrca
	add a, $03
	jp c, .return_failure
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
.process_source_row ; 51:7251
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
	jr z, .check_row_end_bits

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	ld a, [wBrowserNavigating]
	or a, a
	jr z, .check_row_end_bits
	ld c, a
.invert_row_bytes ; 51:726F
	ld a, [hl]
	xor a, $FF
	ld [hli], a
	dec c
	jr nz, .invert_row_bytes

.check_row_end_bits ; 51:7276
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 2 scenarios]
	ldh a, [hBmp_Width]
	and a, $07
	jr z, .advance_row_pointers

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

.advance_row_pointers ; 51:7287
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
	jr nc, .process_source_row
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
	jp .return_failure

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
.scan_following_records ; 51:72F8
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
.scan_zero_terminated_bytes ; 51:7315
	inc bc
	ld a, [hli]
	or a, a
	jr nz, .scan_zero_terminated_bytes
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
	jr z, .advance_record
	ldh a, [hHtmlLayout_RecordList]
	ld l, a
	ldh a, [hHtmlLayout_RecordListHi]
	ld h, a
.scan_layout_records ; 51:7334
	ldh a, [hHtml_PageBank]
	call BankSwitch_H
	push bc
	push hl
	ld bc, $0008
	add hl, bc
	ld a, [hl]
	cp a, $04
	jr nz, .next_layout_record

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	ld bc, $0003
	add hl, bc
	ld a, [hli]
	cp a, e
	jr nz, .next_layout_record
	ld a, [hld]
	cp a, d
	jr nz, .next_layout_record
	ld a, [wHtmlBoldCount + 1]
	add a, e
	ld [hli], a
	ld a, [wHtmlListCounter]
	adc a, d
	ld [hli], a

.next_layout_record ; 51:735A
	; [CONFIRMED] 82 insn(s) executed; cut out of the PROBABLE region 70E0-73D1 by apply_coverage
	; --split [executed in 1 scenarios]
	pop hl
	ld bc, $0010
	add hl, bc
	pop bc
	dec bc
	ld a, b
	or a, c
	jr nz, .scan_layout_records
.advance_record ; 51:7365
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
	jp .scan_following_records
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
	jr z, .copy_staged_output
	call CopyBytes
.copy_staged_output ; 51:73AB
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
.return_success ; 51:73CB
	ld a, $01
	ret

.return_failure ; 51:73CE
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 70E0-73D1 by apply_coverage --split
	pop hl
	xor a, a
	ret

; ---- data $73D1-$73DA (9 bytes) [PROBABLE] row-end bit masks indexed by width modulo 8;
; for remainders 1-7, the selected mask is ORed into the final byte of a bitmap row.
; Remainder 0 skips the table; entries 0 and 8 are not selected by this consumer.
; Static values and consumer agree; the non-aligned branch is not claimed as executed.

Table_Bmp_RowEndMask:: ; 51:73D1
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
; (ld a, [ImageBlit_AllBitsMask] ; and a, d: the edge mask passes unchanged); both reads are in code that never ran naturally, so the role is PROBABLE (earlier text: "probably padding, not referenced")

ImageBlit_AllBitsMask:: ; 51:740C
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
	jr z, .compute_dest_columns

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	inc b

.compute_dest_columns ; 51:7431
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
	jr z, .adjust_source_column

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	push de
	ldh a, [hImageBlit_SrcRowBytes]
	ld e, a
	ld d, $00
	ld a, c
.skip_source_rows ; 51:7458
	add hl, de
	dec a
	jr nz, .skip_source_rows
	pop de

.adjust_source_column ; 51:745D
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	push de
	ld a, d
	and a, $07
	ld d, a
	ld a, b
	sub a, d
	cp a, $F9
	jr nc, .back_up_source_byte
	and a, $F8
	rrca
	rrca
	rrca
	ld e, a
	ld d, $00
	add hl, de
	jr .select_canvas_base

.back_up_source_byte ; 51:7473
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	dec hl

.select_canvas_base ; 51:7474
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
	jr c, .use_bank2_canvas

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $03
	ld h, $C1
	jr .set_canvas_bank

.use_bank2_canvas ; 51:7487
	; [CONFIRMED] 68 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $02
	ld h, $D0
.set_canvas_bank ; 51:748B
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, e
	and a, $07
	rlca
	ld l, a
	ld a, e
	and a, $F8
	jr z, .add_column_offset
	rrca
	rrca
	rrca
	ld bc, $0140
.add_canvas_row_strides ; 51:749F
	add hl, bc
	dec a
	jr nz, .add_canvas_row_strides
.add_column_offset ; 51:74A3
	ld a, d
	and a, $F8
	ld b, $00
	rla
	rl b
	ld c, a
	add hl, bc
	pop bc
	pop de
.blit_rows ; 51:74AF
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
	jr nz, .advance_within_tile_row
	ld a, l
	add a, $32
	ld l, a
	ld a, h
	adc a, $01
	ld h, a
	cp a, $DF
	jr c, .advance_source_row
	sub a, $0F
	ld h, a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	jr .advance_source_row
.advance_within_tile_row ; 51:74D8
	inc l
	inc l
.advance_source_row ; 51:74DA
	ldh a, [hImageBlit_SrcRowBytes]
	add a, e
	ld e, a
	jr nc, .check_row_limit
	inc d
.check_row_limit ; 51:74E1
	ld a, c
	cp a, b
	jr nz, .blit_rows
	ret

Image_MakeEdgeMasks:: ; 51:74E6
	push bc
	ld a, d
	and a, $07
	jr z, .full_left_mask

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	xor a, $07
	inc a
	ld b, a
	ld a, $01
.rotate_left_mask_bit ; 51:74F2
	rlca
	dec b
	jr nz, .rotate_left_mask_bit
	dec a
	jr .store_left_mask

.full_left_mask ; 51:74F9
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $FF
.store_left_mask ; 51:74FB
	ldh [hImageBlit_LeftMask], a
	ldh a, [hBmp_Width]
	ld b, a
	ld a, d
	add a, b
	and a, $07
	jr z, .full_right_mask

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld b, a
	ld a, $01
.rotate_right_mask_bit ; 51:7509
	rrca
	dec b
	jr nz, .rotate_right_mask_bit
	dec a
	cpl
	jr .store_right_mask

.full_right_mask ; 51:7511
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $FF
.store_right_mask ; 51:7513
	ldh [hImageBlit_RightMask], a
	pop bc
	ret

Image_BlitEdgeStrip:: ; 51:7517
	ldh a, [hImageBlit_DestColumns]
	ld c, a
	cp a, $02
	jr nc, .multi_column_strip

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
	jr z, .single_prepare_mask
.single_shift_pair ; 51:7529
	rla
	rl b
	dec c
	jr nz, .single_shift_pair
.single_prepare_mask ; 51:752F
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
	jr nz, .single_byte0_low_bit_set
	bit 4, a
	jr nz, .single_byte0_use_source
	xor a, a
	jr .single_byte0_merge
.single_byte0_use_source ; 51:7546
	ld a, b
	jr .single_byte0_merge
.single_byte0_low_bit_set ; 51:7549
	bit 4, a
	jr nz, .single_byte0_use_one
	ld a, b
	cpl
	jr .single_byte0_merge
.single_byte0_use_one ; 51:7551
	ld a, $01
.single_byte0_merge ; 51:7553
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .single_byte1_low_bit_set
	bit 5, a
	jr nz, .single_byte1_use_source
	xor a, a
	jr .single_byte1_merge
.single_byte1_use_source ; 51:7566
	ld a, b
	jr .single_byte1_merge
.single_byte1_low_bit_set ; 51:7569
	bit 5, a
	jr nz, .single_byte1_use_one
	ld a, b
	cpl
	jr .single_byte1_merge
.single_byte1_use_one ; 51:7571
	ld a, $01
.single_byte1_merge ; 51:7573
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
	jr nc, .return_single_strip
	inc h
.return_single_strip ; 51:7581
	jp .done

.multi_column_strip ; 51:7584
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hImageBlit_LeftMask]
	cp a, $FF
	jr z, .check_right_column

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
	jr z, .left_prepare_mask
.left_shift_pair ; 51:7596
	rla
	rl b
	dec c
	jr nz, .left_shift_pair
.left_prepare_mask ; 51:759C
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
	jr nz, .left_byte0_low_bit_set
	bit 4, a
	jr nz, .left_byte0_use_source
	xor a, a
	jr .left_byte0_merge
.left_byte0_use_source ; 51:75B4
	ld a, b
	jr .left_byte0_merge
.left_byte0_low_bit_set ; 51:75B7
	bit 4, a
	jr nz, .left_byte0_use_one
	ld a, b
	cpl
	jr .left_byte0_merge
.left_byte0_use_one ; 51:75BF
	ld a, $01
.left_byte0_merge ; 51:75C1
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .left_byte1_low_bit_set
	bit 5, a
	jr nz, .left_byte1_use_source
	xor a, a
	jr .left_byte1_merge
.left_byte1_use_source ; 51:75D4
	ld a, b
	jr .left_byte1_merge
.left_byte1_low_bit_set ; 51:75D7
	bit 5, a
	jr nz, .left_byte1_use_one
	ld a, b
	cpl
	jr .left_byte1_merge
.left_byte1_use_one ; 51:75DF
	ld a, $01
.left_byte1_merge ; 51:75E1
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
	jr nc, .count_left_column
	inc h
.count_left_column ; 51:75EF
	pop bc
	dec c

.check_right_column ; 51:75F1
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hImageBlit_RightMask]
	cp a, $FF
	jr z, .dispatch_full_columns

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	dec c

.dispatch_full_columns ; 51:75F8
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, c
	or a, a
	jr z, .check_right_edge
	ldh a, [hImageBlit_BitShift]
	bit 2, a
	jr nz, .test_shift_bits1_0
	bit 1, a
	jr nz, .test_shift_bit0_for_2_3
	bit 0, a
	jr nz, .blit_shift1
	call Image_BlitStripShift0
	jr .check_right_edge

.blit_shift1 ; 51:760F
	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	call Image_BlitStripShift1
	jr .check_right_edge
.test_shift_bit0_for_2_3 ; 51:7614
	bit 0, a
	jr nz, .blit_shift3
	call Image_BlitStripShift2
	jr .check_right_edge
.blit_shift3 ; 51:761D
	call Image_BlitStripShift3
	jr .check_right_edge
.test_shift_bits1_0 ; 51:7622
	bit 1, a
	jr nz, .test_shift_bit0_for_6_7
	bit 0, a
	jr nz, .blit_shift5
	call Image_BlitStripShift4
	jr .check_right_edge
.blit_shift5 ; 51:762F
	call Image_BlitStripShift5
	jr .check_right_edge
.test_shift_bit0_for_6_7 ; 51:7634
	bit 0, a
	jr nz, .blit_shift7
	call Image_BlitStripShift6
	jr .check_right_edge
.blit_shift7 ; 51:763D
	call Image_BlitStripShift7

.check_right_edge ; 51:7640
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
	jr z, .right_prepare_mask
.right_shift_pair ; 51:7651
	rla
	rl b
	dec c
	jr nz, .right_shift_pair
.right_prepare_mask ; 51:7657
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
	jr nz, .right_byte0_low_bit_set
	bit 4, a
	jr nz, .right_byte0_use_source
	xor a, a
	jr .right_byte0_merge
.right_byte0_use_source ; 51:766F
	ld a, b
	jr .right_byte0_merge
.right_byte0_low_bit_set ; 51:7672
	bit 4, a
	jr nz, .right_byte0_use_one
	ld a, b
	cpl
	jr .right_byte0_merge
.right_byte0_use_one ; 51:767A
	ld a, $01
.right_byte0_merge ; 51:767C
	and a, d
	ld c, a
	ld a, [hl]
	and a, e
	or a, c
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .right_byte1_low_bit_set
	bit 5, a
	jr nz, .right_byte1_use_source
	xor a, a
	jr .right_byte1_merge
.right_byte1_use_source ; 51:768F
	ld a, b
	jr .right_byte1_merge
.right_byte1_low_bit_set ; 51:7692
	bit 5, a
	jr nz, .right_byte1_use_one
	ld a, b
	cpl
	jr .right_byte1_merge
.right_byte1_use_one ; 51:769A
	ld a, $01
.right_byte1_merge ; 51:769C
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
	jr nz, .byte0_low_bit_set

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:76BB
	ld a, b
	jr .byte0_store

.byte0_low_bit_set ; 51:76BE
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store

.byte0_use_one ; 51:76C6
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $01

.byte0_store ; 51:76C8
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set

	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:76D6
	ld a, b
	jr .byte1_store

.byte1_low_bit_set ; 51:76D9
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 740D-7900 by apply_coverage
	; --split [executed in 1 scenarios]
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store

.byte1_use_one ; 51:76E1
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 740D-7900 by apply_coverage --split
	ld a, $01

.byte1_store ; 51:76E3
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:7703
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:7706
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:770E
	ld a, $01
.byte0_store ; 51:7710
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:771E
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:7721
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:7729
	ld a, $01
.byte1_store ; 51:772B
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:774E
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:7751
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:7759
	ld a, $01
.byte0_store ; 51:775B
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:7769
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:776C
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:7774
	ld a, $01
.byte1_store ; 51:7776
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:779C
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:779F
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:77A7
	ld a, $01
.byte0_store ; 51:77A9
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:77B7
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:77BA
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:77C2
	ld a, $01
.byte1_store ; 51:77C4
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:77E9
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:77EC
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:77F4
	ld a, $01
.byte0_store ; 51:77F6
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:7804
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:7807
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:780F
	ld a, $01
.byte1_store ; 51:7811
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:7837
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:783A
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:7842
	ld a, $01
.byte0_store ; 51:7844
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:7852
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:7855
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:785D
	ld a, $01
.byte1_store ; 51:785F
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:7883
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:7886
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:788E
	ld a, $01
.byte0_store ; 51:7890
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:789E
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:78A1
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:78A9
	ld a, $01
.byte1_store ; 51:78AB
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
	jr nz, .byte0_low_bit_set
	bit 4, a
	jr nz, .byte0_use_source
	xor a, a
	jr .byte0_store
.byte0_use_source ; 51:78CC
	ld a, b
	jr .byte0_store
.byte0_low_bit_set ; 51:78CF
	bit 4, a
	jr nz, .byte0_use_one
	ld a, b
	cpl
	jr .byte0_store
.byte0_use_one ; 51:78D7
	ld a, $01
.byte0_store ; 51:78D9
	ld [hli], a
	ldh a, [hImageBlit_Colors]
	bit 1, a
	jr nz, .byte1_low_bit_set
	bit 5, a
	jr nz, .byte1_use_source
	xor a, a
	jr .byte1_store
.byte1_use_source ; 51:78E7
	ld a, b
	jr .byte1_store
.byte1_low_bit_set ; 51:78EA
	bit 5, a
	jr nz, .byte1_use_one
	ld a, b
	cpl
	jr .byte1_store
.byte1_use_one ; 51:78F2
	ld a, $01
.byte1_store ; 51:78F4
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
