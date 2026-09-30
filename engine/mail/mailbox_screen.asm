; engine/mail/mailbox_screen.asm
; bank 25, $4B0D-$5A10 (3843 bytes); pinned by layout.link
; mailbox screen load, row/timestamp/text drawing, hints, reply, icon bar attributes

SECTION "engine/mail/mailbox_screen", ROMX

; ---- code $4B0D-$4BD0 (195 bytes) [CONFIRMED] 62 insn(s); 62 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Mailbox_LoadScreen:: ; 25:4B0D
Function_25_4B0D::
	push de
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	ld a, [wMailScreenMode]
	inc a
	jp z, Label_25_4BD0
	ld bc, $0040
	ld de, $D800
	ld hl, Mailbox_BgPalette
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, $6EF0
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld de, $9301
	ld hl, Mailbox_Tiles_5A10
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	call Function_00_0464
	ld de, $9701
	ld hl, Mailbox_Tiles_5E10
	ld a, $25
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8000
	ld hl, $69F0
	ld a, $25
	ld b, $94
	ld c, $30
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8700
	ld hl, $6A00
	ld a, $25
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8D00
	ld hl, $6CF0
	ld a, $25
	ld b, $95
	ld c, $20
	farcall Function_00_0749
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, Mailbox_Tilemap_Normal
	ld a, $25
	farcall Function_00_08EA
	call Function_00_0464
	jp Label_25_4C75

; ---- code $4BD0-$4C75 (165 bytes) [CONFIRMED] 53 insn(s) reached by static flow only; seeds: exec x53; min discovery hops 1; entered by jpcc from 25:4B25 (executed) [executed in 3 scenarios]

Label_25_4BD0:: ; 25:4BD0
	ld bc, $0040
	ld de, $D800
	ld hl, Mailbox_BgPalette
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, $6EF0
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld de, $9301
	ld hl, Mailbox_Tiles_5F10
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	call Function_00_0464
	ld de, $9701
	ld hl, Mailbox_Tiles_6310
	ld a, $25
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8000
	ld hl, $69F0
	ld a, $25
	ld b, $94
	ld c, $30
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8700
	ld hl, $6A00
	ld a, $25
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8D00
	ld hl, $6CF0
	ld a, $25
	ld b, $95
	ld c, $20
	farcall Function_00_0749
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, Mailbox_Tilemap_DeleteSelect
	ld a, $25
	farcall Function_00_08EA
	call Function_00_0464

; ---- code $4C75-$4CED (120 bytes) [CONFIRMED] 68 insn(s); 68 executed (in up to 1/18 scenarios)

Label_25_4C75:: ; 25:4C75
	ld bc, $0040
	ld de, $D800
	ld hl, Mailbox_BgPalette
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, $6EF0
	ld a, $25
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ldh a, [rLCDC]
	call Function_00_082C

Label_25_4CA2:: ; 25:4CA2
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_25_4CA2
	call Function_00_0464
	ld a, $01
	ldh [rVBK], a
	ld hl, $98A1
	ld a, $02
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	call Function_00_0464
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4A1
	ld a, $02
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	inc hl
	ld [hli], a
	ld [hli], a
	pop bc
	pop de
	ld e, d
	push bc
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr z, Label_25_4CFB

; ---- code $4CED-$4CFB (14 bytes) [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 25:4CEB (executed) | upgraded by classifier 6: all 7 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	push de
	call Mailbox_ClearTimestamp
	pop de
	ld d, e
	call Mailbox_ShowHint
	call Mailbox_DrawMailCount
	jr Label_25_4D03

; ---- code $4CFB-$4D0E (19 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_25_4CFB:: ; 25:4CFB
	ld d, $03
	call Mailbox_ShowHint
	call Mailbox_ClearTimestamp

Label_25_4D03:: ; 25:4D03
	call Mailbox_UploadTextTiles
	pop bc
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr z, Label_25_4D4D

; ---- code $4D0E-$4D4D (63 bytes) [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 0; fall-through of the jrcc at 25:4D0C (executed) [executed in 4 scenarios]
	push bc
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	pop bc
	push bc
	call Mailbox_DrawSenderName
	call Mailbox_DrawRowTitles
	call Mailbox_UploadTextTiles
	pop bc
	push bc
	call Mailbox_DrawTimestamp
	pop bc
	push bc
	call Mailbox_UpdateScrollArrows_B
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_4D33
	jr Label_25_4D4C

Label_25_4D33:: ; 25:4D33
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_4D4C:: ; 25:4D4C
	pop bc

; ---- code $4D4D-$4D99 (76 bytes) [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios)

Label_25_4D4D:: ; 25:4D4D
	push bc
	ldh a, [rLCDC]
	call Function_00_082C
	call Function_00_0464
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0007
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ret

; ---- code $4D99-$4E2B (146 bytes) [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 1; entered by call from 25:4D27 (PROBABLE code) [executed in 4 scenarios]

Mailbox_UpdateScrollArrows_B:: ; 25:4D99
	push bc
	push de
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr z, Label_25_4DE8
	cp a, $01
	jr z, Label_25_4DE8
	cp a, $02
	jr z, Label_25_4DE8
	cp a, $03
	jr z, Label_25_4DE8
	cp a, $04
	jr z, Label_25_4DE8
	ld hl, $DA40
	ld de, $7B50
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $6848
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	ret

Label_25_4DE8:: ; 25:4DE8
	ld de, $68D0
	ld hl, $DA40
	call Function_00_0A65
	ld de, $30D0
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	ret

Mailbox_DrawSenderName:: ; 25:4DFD
	push bc
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4E2B
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $00C9
	add hl, de
	ld bc, $0300
	ld de, $0230
	ld a, $10
	call Mailbox_DrawTextLine
	pop bc
	ret

; ---- words $4E2B-$4E43 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:4E13

Mailbox_RecordAddrs_4E2B:: ; 25:4E2B
Table_25_4E2B::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $4E43-$4F28 (229 bytes) [CONFIRMED] 125 insn(s) reached by static flow only; seeds: exec x125; min discovery hops 7; entered by call from 25:48CF (PROBABLE code) | upgraded by classifier 6: all 125 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Mailbox_DrawRowTitles:: ; 25:4E43
	push bc
	ld de, $0300
	ld a, $00
	cp a, c
	jr nz, Label_25_4E4F
	ld de, $0001

Label_25_4E4F:: ; 25:4E4F
	push de
	ld c, $00
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4F28
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $00D9
	add hl, de
	ld de, $1020
	pop bc
	ld a, $14
	call Mailbox_DrawTextLine
	pop bc
	push bc
	ld de, $0300
	ld a, $01
	cp a, c
	jr nz, Label_25_4E88
	ld de, $0001

Label_25_4E88:: ; 25:4E88
	push de
	ld c, $01
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4F28
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $00D9
	add hl, de
	pop bc
	ld de, $1C20
	ld a, $14
	call Mailbox_DrawTextLine
	pop bc
	push bc
	ld de, $0300
	ld a, $02
	cp a, c
	jr nz, Label_25_4EC1
	ld de, $0001

Label_25_4EC1:: ; 25:4EC1
	push de
	ld c, $02
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4F28
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $00D9
	add hl, de
	pop bc
	ld de, $2820
	ld a, $14
	call Mailbox_DrawTextLine
	pop bc
	push bc
	ld de, $0300
	ld a, $03
	cp a, c
	jr nz, Label_25_4EFA
	ld de, $0001

Label_25_4EFA:: ; 25:4EFA
	push de
	ld c, $03
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4F28
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $00D9
	add hl, de
	pop bc
	ld de, $3420
	ld a, $14
	call Mailbox_DrawTextLine
	pop bc
	ret

; ---- words $4F28-$4F40 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:4E67/4EA0/4ED9/4F12

Mailbox_RecordAddrs_4F28:: ; 25:4F28
Table_25_4F28::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $4F40-$50AA (362 bytes) [CONFIRMED] 254 insn(s) reached by static flow only; seeds: exec x254; min discovery hops 7; entered by call from 25:48DD (PROBABLE code) | upgraded by classifier 6: all 254 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Mailbox_DrawTimestamp:: ; 25:4F40
	push bc
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld hl, Mailbox_RecordAddrs_50AA
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $0003
	add hl, de
	ld de, $D524
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $06

Label_25_4F61:: ; 25:4F61
	ld a, [hl]
	swap a
	and a, $0F
	add a, $D0
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	add a, $D0
	ld [de], a
	inc de
	dec b
	jr nz, Label_25_4F61
	ld de, $98A1
	ld hl, $D524
	xor a, a
	ldh [rVBK], a
	di

Label_25_4F7E:: ; 25:4F7E
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_25_4F7E
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ei
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld de, $D0A1
	ld hl, $D524
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	ret

; ---- words $50AA-$50C2 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:4F48

Mailbox_RecordAddrs_50AA:: ; 25:50AA
Table_25_50AA::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $50C2-$5228 (358 bytes) [CONFIRMED] 251 insn(s); 251 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Mailbox_ClearTimestamp:: ; 25:50C2
Function_25_50C2::
	push bc
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld hl, Mailbox_RecordAddrs_5228
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $0003
	add hl, de
	ld de, $D524
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $06

Label_25_50E3:: ; 25:50E3
	ld a, [hl]
	swap a
	and a, $0F
	add a, $D0
	ld a, $D0
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	add a, $D0
	ld a, $D0
	ld [de], a
	inc de
	dec b
	jr nz, Label_25_50E3
	ld de, $98A1
	ld hl, $D524
	xor a, a
	ldh [rVBK], a
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld de, $D0A1
	ld hl, $D524
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	ret

; ---- words $5228-$5240 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:5228 first entry read by executed code (region Data_25_5228 CONFIRMED); no direct ld hl,imm found

Mailbox_RecordAddrs_5228:: ; 25:5228
Table_25_5228::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $5240-$5267 (39 bytes) [CONFIRMED] 145 insn(s) reached by static flow only; seeds: exec x145; min discovery hops 7; entered by call from 25:4E26 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE region 5240-534C by apply_coverage --split [executed in 9 scenarios]

Mailbox_DrawTextLine:: ; 25:5240
	ld [wTextCellsLeft], a

Label_25_5243:: ; 25:5243
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hli]
	cp a, $00
	jr z, Label_25_52CA
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_25_52A8
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, Label_25_526B

; ---- code $5267-$526B (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5240-534C by apply_coverage --split
	pop af
	jp Label_25_52CA

; ---- code $526B-$531C (177 bytes) [CONFIRMED] 96 insn(s) executed; cut out of the PROBABLE region 5240-534C by apply_coverage --split [executed in 3 scenarios]

Label_25_526B:: ; 25:526B
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call Mailbox_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_25_52CA
	jr Label_25_5243

Label_25_52A8:: ; 25:52A8
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call Mailbox_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_25_52CA
	jp Label_25_5243

Label_25_52CA:: ; 25:52CA
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_25_52DB:: ; 25:52DB
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Mailbox_BlitGlyphAdvance
	jr Label_25_52DB

Mailbox_BlitGlyphAdvance:: ; 25:52EA
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

Mailbox_DrawMailCount:: ; 25:52FE
	push bc
	push de
	call Mailbox_CountRecords
	ld a, d
	cp a, $0C
	jr nz, Label_25_530E
	ld b, $01
	ld c, $02
	jr Label_25_5325

Label_25_530E:: ; 25:530E
	cp a, $0B
	jr nz, Label_25_5318
	ld b, $01
	ld c, $01
	jr Label_25_5325

Label_25_5318:: ; 25:5318
	cp a, $0A
	jr nz, Label_25_5322

; ---- code $531C-$5322 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5240-534C by apply_coverage --split
	ld b, $01
	ld c, $00
	jr Label_25_5325

; ---- code $5322-$534C (42 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 5240-534C by apply_coverage --split [executed in 4 scenarios]

Label_25_5322:: ; 25:5322
	ld b, $00
	ld c, a

Label_25_5325:: ; 25:5325
	ld d, $00

Label_25_5327:: ; 25:5327
	xor a, a
	ldh [rVBK], a
	ld hl, $98CE
	ld a, b
	add a, $E0
	ld [hli], a
	ld a, c
	add a, $E0
	ld [hl], a
	dec d
	jr nz, Label_25_5327
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D0CE
	ld a, b
	add a, $E0
	ld [hli], a
	ld a, c
	add a, $E0
	ld [hl], a
	pop de
	pop bc
	ret

; ---- code $534C-$53D0 (132 bytes) [CONFIRMED] 68 insn(s); 68 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Mailbox_UploadTextTiles:: ; 25:534C
Function_25_534C::
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_StartHDMAAtVBlank
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call Gfx_StartHDMAAtVBlank
	ld hl, $DC00
	ld de, $8C00
	ld c, $07
	call Gfx_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank:: ; 25:538A
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_25_5399:: ; 25:5399
	ld a, [de]
	cp a, $8F
	jr nz, Label_25_5399
	ld b, $91

Label_25_53A0:: ; 25:53A0
	ld a, [de]
	cp a, b
	jr nz, Label_25_53A0
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

Mailbox_ShowHint:: ; 25:53AA
	push bc
	push de
	inc d
	ld e, d
	ld d, $00
	sla e
	ld hl, Mailbox_HintTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $25
	ld bc, $DA00
	ld de, $DB40
	farcall TextTiles_RenderLine
	pop de
	pop bc
	ret

; ---- ptrtable $53D0-$53DA (10 bytes) [PROBABLE] 5 pointers, every target is the first byte of one of the 5 NUL-terminated strings of String_25_53DA; read by 25:53B2 (ld e,d; sla e; ld hl,$53D0; add hl,de)

Mailbox_HintTable:: ; 25:53D0
Table_25_53D0::
	dw Mailbox_Hint_SelectMail
	dw Mailbox_Hint_Read
	dw Mailbox_Hint_Reply
	dw Mailbox_Hint_Delete
	dw Mailbox_Hint_NoMail

; ---- text $53DA-$54A7 (205 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

Mailbox_Hint_SelectMail:: ; 25:53DA
String_25_53DA::
	db $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $B9, $82, $F1, $82, $BD, $82, $AD, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2 ; "　　メールを　せんたくしてください"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

Mailbox_Hint_Read:: ; 25:5403
	db $81, $40, $81, $40, $81, $40, $82, $E0, $82, $E7, $82, $C1, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $E6, $82, $DD, $82, $DC, $82, $B7, $81, $40 ; "　　　もらったメールを　よみます　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

Mailbox_Hint_Reply:: ; 25:542C
	db $81, $40, $81, $40, $82, $B1, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $C9, $81, $40, $82, $D6, $82, $F1, $82, $B6, $82, $F0, $82, $A9, $82, $AB, $82, $DC, $82, $B7 ; "　　このメールに　へんじをかきます"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

Mailbox_Hint_Delete:: ; 25:5455
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $B1, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $40, $81, $40 ; "　　　　このメールを　けします　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

Mailbox_Hint_NoMail:: ; 25:547E
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $AA, $81, $40, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $81, $40, $81, $40 ; "　　　　　メールが　ありません　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $54A7-$5534 (141 bytes) [CONFIRMED] 105 insn(s) reached by static flow only; seeds: exec x105; min discovery hops 8; entered by call from 25:4591 (PROBABLE code) | 80 insn(s) executed; cut out of the PROBABLE region 54A7-5569 by apply_coverage --split [executed in 1 scenarios]

Mailbox_ReplyToRecord:: ; 25:54A7
	ld a, c
	add a, b
	ld b, a
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $D400
	ld bc, $0124

Label_25_54C5:: ; 25:54C5
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_25_54C5
	pop bc
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Mailbox_RecordAddrs_5569
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	push hl
	ld de, $00ED
	add hl, de
	ld de, $D4C0
	ld b, $40

Label_25_54F6:: ; 25:54F6
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_25_54F6
	pop hl
	ld de, $00C9
	add hl, de
	ld de, $D514
	ld b, $10

Label_25_5506:: ; 25:5506
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_25_5506
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $03
	ld [wMailComposeMode], a
	ld a, b
	ld [wRam_D525], a
	ld a, b
	ld [wRam_D526], a
	xor a, a
	ld a, $01
	jr Label_25_5527

Label_25_5525:: ; 25:5525
	ld a, $01

Label_25_5527:: ; 25:5527
	farcall MailAddr_Edit
	cp a, $FF
	jr z, Label_25_555C
	xor a, a
	jr Label_25_5536

; ---- code $5534-$5536 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 54A7-5569 by apply_coverage --split

Label_25_5534:: ; 25:5534
	ld a, $01

; ---- code $5536-$555C (38 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 54A7-5569 by apply_coverage --split [executed in 1 scenarios]

Label_25_5536:: ; 25:5536
	farcall MailTitle_Entry
	cp a, $FF
	jr z, Label_25_5525
	farcall MailBody_Edit
	cp a, $FF
	jr z, Label_25_5534
	cp a, $00
	jr z, Label_25_555C
	pop af
	pop af
	pop af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D526]
	ld c, a
	ret

; ---- code $555C-$5569 (13 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 54A7-5569 by apply_coverage --split

Label_25_555C:: ; 25:555C
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D526]
	ld c, a
	ld a, $FF
	ret

; ---- words $5569-$5581 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:54E2

Mailbox_RecordAddrs_5569:: ; 25:5569
Table_25_5569::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $5581-$5871 (752 bytes) [CONFIRMED] 310 insn(s) reached by static flow only; seeds: exec x310; min discovery hops 1; entered by call from 25:4033 (PROBABLE code) | upgraded by classifier 6: all 310 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Mailbox_ShowRowNumbers:: ; 25:5581
	push de
	push bc
	ld c, b
	ld b, $00
	swap c
	xor a, a
	ldh [rVBK], a
	ld hl, $8700
	add hl, bc
	ld de, $8010
	ld b, $40

Label_25_5594:: ; 25:5594
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_25_5594

Label_25_559A:: ; 25:559A
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_25_559A
	ld de, $38D0
	ld hl, $DA50
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DA60
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DA70
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DA80
	call Function_00_0A65
	pop bc
	push bc
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr z, Label_25_563E
	cp a, $01
	jr z, Label_25_5625
	cp a, $02
	jr z, Label_25_560C
	cp a, $03
	jr z, Label_25_55F3
	ld hl, $DA80
	ld de, $7B90
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $5C08
	ld hl, $DA80
	call Function_00_0A65

Label_25_55F3:: ; 25:55F3
	ld hl, $DA70
	ld de, $7B80
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $5008
	ld hl, $DA70
	call Function_00_0A65

Label_25_560C:: ; 25:560C
	ld hl, $DA60
	ld de, $7B70
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $4408
	ld hl, $DA60
	call Function_00_0A65

Label_25_5625:: ; 25:5625
	ld hl, $DA50
	ld de, $7B60
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3808
	ld hl, $DA50
	call Function_00_0A65

Label_25_563E:: ; 25:563E
	pop bc
	pop de
	ret

Mailbox_ShowRowStatusIcons:: ; 25:5641
	push de
	push bc
	ld de, $38D0
	ld hl, $DA90
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DAA0
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DAB0
	call Function_00_0A65
	ld de, $38D0
	ld hl, $DAC0
	call Function_00_0A65
	pop bc
	push bc
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jp z, Label_25_5755
	cp a, $01
	jp z, Label_25_5720
	cp a, $02
	jp z, Label_25_56EB
	cp a, $03
	jp z, Label_25_56B6
	push bc
	ld hl, $DAC0
	ld de, $7BB0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Function_25_5848
	inc a
	jr nz, Label_25_56AC
	ld hl, $DAC0
	ld de, $7BA0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_56AC:: ; 25:56AC
	ld de, $5C08
	ld hl, $DAC0
	call Function_00_0A65
	pop bc

Label_25_56B6:: ; 25:56B6
	push bc
	ld hl, $DAA0
	ld de, $7BB0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Function_25_5848
	inc a
	jr nz, Label_25_56E1
	ld hl, $DAA0
	ld de, $7BA0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_56E1:: ; 25:56E1
	ld de, $5008
	ld hl, $DAA0
	call Function_00_0A65
	pop bc

Label_25_56EB:: ; 25:56EB
	push bc
	ld hl, $DAB0
	ld de, $7BB0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Function_25_5848
	inc a
	jr nz, Label_25_5716
	ld hl, $DAB0
	ld de, $7BA0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_5716:: ; 25:5716
	ld de, $4408
	ld hl, $DAB0
	call Function_00_0A65
	pop bc

Label_25_5720:: ; 25:5720
	push bc
	ld hl, $DA90
	ld de, $7BB0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Function_25_5848
	inc a
	jr nz, Label_25_574B
	ld hl, $DA90
	ld de, $7BA0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_574B:: ; 25:574B
	ld de, $3808
	ld hl, $DA90
	call Function_00_0A65
	pop bc

Label_25_5755:: ; 25:5755
	ld a, c
	cp a, $00
	jp z, Label_25_580D
	cp a, $01
	jp z, Label_25_57D5
	cp a, $02
	jp z, Label_25_579D
	push bc
	ld hl, $DAC0
	ld de, $7BD0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Function_25_5848
	inc a
	jr nz, Label_25_5790
	ld hl, $DAC0
	ld de, $7BC0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_5790:: ; 25:5790
	ld de, $5C08
	ld hl, $DAC0
	call Function_00_0A65
	pop bc
	jp Label_25_5845

Label_25_579D:: ; 25:579D
	push bc
	ld hl, $DAA0
	ld de, $7BD0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Function_25_5848
	inc a
	jr nz, Label_25_57C8
	ld hl, $DAA0
	ld de, $7BC0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_57C8:: ; 25:57C8
	ld de, $5008
	ld hl, $DAA0
	call Function_00_0A65
	pop bc
	jp Label_25_5845

Label_25_57D5:: ; 25:57D5
	push bc
	ld hl, $DAB0
	ld de, $7BD0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Function_25_5848
	inc a
	jr nz, Label_25_5800
	ld hl, $DAB0
	ld de, $7BC0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_5800:: ; 25:5800
	ld de, $4408
	ld hl, $DAB0
	call Function_00_0A65
	pop bc
	jp Label_25_5845

Label_25_580D:: ; 25:580D
	push bc
	ld hl, $DA90
	ld de, $7BD0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Function_25_5848
	inc a
	jr nz, Label_25_5838
	ld hl, $DA90
	ld de, $7BC0
	ld a, $26
	ld b, $81
	farcall Function_00_0A82

Label_25_5838:: ; 25:5838
	ld de, $3808
	ld hl, $DA90
	call Function_00_0A65
	pop bc
	jp Label_25_5845

Label_25_5845:: ; 25:5845
	pop bc
	pop de
	ret

Function_25_5848:: ; 25:5848
	add a, b
	ld c, a
	sla c
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_5871
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0000
	add hl, bc
	ld a, [hl]
	cp a, $01
	jr nz, Label_25_586F
	ld a, $FF
	ret

Label_25_586F:: ; 25:586F
	xor a, a
	ret

; ---- words $5871-$5889 (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:585C

Mailbox_RecordAddrs_5871:: ; 25:5871
Table_25_5871::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $5889-$58E7 (94 bytes) [CONFIRMED] 62 insn(s) reached by static flow only; seeds: exec x62; min discovery hops 3; entered by call from 25:40C5 (PROBABLE code) | upgraded by classifier 6: all 62 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Mailbox_SetIconBarAttrs:: ; 25:5889
	push bc
	push de
	push hl
	sla a
	ld c, a
	ld b, $00
	ld hl, Mailbox_IconBarAttrTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld h, [hl]
	ld l, c
	push hl
	ld de, $99C0
	ld c, $14
	ld a, $01
	ldh [rVBK], a

Label_25_58A3:: ; 25:58A3
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_25_58A3

Label_25_58A9:: ; 25:58A9
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_25_58A9
	pop hl
	push hl
	ld de, $0018
	add hl, de
	ld de, $99E0
	ld c, $14

Label_25_58BA:: ; 25:58BA
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_25_58BA
	pop hl
	push hl
	ld de, $0018
	add hl, de
	ld de, $D5C0
	ld c, $14
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_25_58D1:: ; 25:58D1
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_25_58D1
	pop hl
	ld de, $D5E0
	ld c, $14

Label_25_58DD:: ; 25:58DD
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_25_58DD
	pop hl
	pop de
	pop bc
	ret

; ---- ptrtable $58E7-$58ED (6 bytes) [PROBABLE] 3 pointers to the 48-byte attribute blocks at 25:58ED/591D/594D; read by 25:5891 (sla a; ld c,a; ld hl,$58E7; add hl,bc; ld a,[hli]; ld c,a; ld h,[hl]; ld l,c)

Mailbox_IconBarAttrTable:: ; 25:58E7
Table_25_58E7::
	dw Mailbox_IconBarAttrs
	dw $591D
	dw $594D

; ---- data $58ED-$5A0D (288 bytes) [PROBABLE] 12 rows of 24 bytes (20 used + 4 zero pad): BG attribute bytes ($09/$0B/$0C/$29 = palette+VRAM-bank-1 flags; values as in the attribute half of the rect-copy maps); 25:5889 copies 20 bytes per row to VRAM bank 1 $99C0/$99E0 and WRAM7 $D5C0/$D5E0; blocks 58ED/591D/594D are addressed through Table_25_58E7, 597D..59F5 have no table entry (unreferenced HYPOTHESIS). Replaces the mapper heuristic gfx region 58F0-5C40 (the real tile load starts at 5A10)

Mailbox_IconBarAttrs:: ; 25:58ED
Data_25_58ED::
	db $29, $29, $29, $29, $0B, $0B, $09, $09, $09, $0B, $0B, $09, $09, $09, $0B, $0B
	db $09, $09, $09, $09, $00, $00, $00, $00, $29, $09, $09, $09, $0B, $0B, $09, $09
	db $09, $0B, $0B, $09, $09, $09, $0B, $0B, $09, $09, $09, $09, $00, $00, $00, $00
	db $29, $29, $29, $29, $0C, $0C, $09, $09, $09, $0C, $0C, $09, $09, $09, $0C, $0C
	db $09, $09, $09, $09, $00, $00, $00, $00, $29, $09, $09, $09, $0C, $0C, $09, $09
	db $09, $0C, $0C, $09, $09, $09, $0C, $0C, $09, $09, $09, $09, $00, $00, $00, $00
	db $29, $29, $29, $29, $0C, $0C, $09, $09, $09, $0B, $0B, $09, $09, $09, $0C, $0C
	db $09, $09, $09, $09, $00, $00, $00, $00, $29, $09, $09, $09, $0C, $0C, $09, $09
	db $09, $0B, $0B, $09, $09, $09, $0C, $0C, $09, $09, $09, $09, $00, $00, $00, $00
	db $09, $29, $29, $29, $0B, $0B, $09, $09, $09, $0B, $0B, $09, $09, $09, $0B, $0B
	db $09, $09, $09, $09, $00, $00, $00, $00, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $00, $00, $00, $00
	db $09, $29, $29, $29, $0C, $0C, $09, $09, $09, $0C, $0C, $09, $09, $09, $0C, $0C
	db $09, $09, $09, $09, $00, $00, $00, $00, $0B, $0B, $0B, $0B, $0C, $0C, $0B, $0B
	db $0B, $0C, $0C, $0B, $0B, $0B, $0C, $0C, $0B, $0B, $0B, $0B, $00, $00, $00, $00
	db $09, $29, $29, $29, $0C, $0C, $09, $09, $09, $0B, $0B, $09, $09, $09, $0C, $0C
	db $09, $09, $09, $09, $00, $00, $00, $00, $0B, $0B, $0B, $0B, $0C, $0C, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0C, $0C, $0B, $0B, $0B, $0B, $00, $00, $00, $00

; ---- zero $5A0D-$5A10 (3 bytes) [PROBABLE] 3 bytes of zero padding to the 16-byte alignment of the tile block at 25:5A10
	ds $3, $00
