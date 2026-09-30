; engine/browser/frame_style_chooser.asm
; bank 4E, $4000-$4658 (1624 bytes); pinned by layout.link
; frame-style chooser with no caller, wipe list, cursor copier

SECTION "engine/browser/frame_style_chooser", ROMX

; ---- code $4000-$4002 (2 bytes) [HYPOTHESIS] 1 instruction (ldh [$FFD2],a) that falls straight into the proven far-call site at 4E:4002 (same function: the code from 4002 uses hFFD2); first instruction of the bank; no caller/pointer to 4E:4000 found (whole-ROM search), so the entry is unproven | forced execution: 1/1 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_4E_4000:: ; 4E:4000
	ldh [hRam_FFD2], a

; ---- code $4002-$4172 (368 bytes) [PROBABLE] 160 insn(s) reached by static flow only; seeds: site x160; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 160/160 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)
	farcall Function_4E_6291
	ld de, $18A0
	ld hl, $DA90
	call Function_00_0A65
	ld hl, $DAA0
	call Function_00_09E6
	ld hl, $DAB0
	call Function_00_09E6
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0009
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld de, $8000
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, b
	ld l, c
	push af
	ld bc, $0028
	ld de, $D840
	farcall Palette_LoadToBuffer
	ld bc, $0010
	add hl, bc
	pop af
	ld bc, $0008
	ld de, $D878
	farcall Palette_LoadToBuffer
	ld a, $0C
	ld [wConnIconState], a
	xor a, a
	ld [wConnIconGfxRequest], a
	farcall ConnIcon_Refresh
	call Function_00_0A09
	ld a, $04
	ld [wRam_C2F3], a
	farcall Browser_DrawCommTimer
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	ld a, $E0
	ldh [hRam_FFD0], a
	ld a, $41
	ldh [hRam_FFD1], a

Label_4E_409C:: ; 4E:409C
	ldh a, [hRam_FFD0]
	ld l, a
	ldh a, [hRam_FFD1]
	ld h, a
	or a, a
	jr z, Label_4E_40C8
	farcall Function_4E_45FE
	ld a, l
	ldh [hRam_FFD0], a
	ld a, h
	ldh [hRam_FFD1], a
	ldh a, [rLCDC]
	call Function_00_07CB
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	jp Label_4E_409C

Label_4E_40C8:: ; 4E:40C8
	ldh a, [hRam_FFD2]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0009
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld de, $8000
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld h, b
	ld l, c
	push af
	ld bc, $0028
	ld de, $D840
	farcall Palette_LoadToBuffer
	ld bc, $0010
	add hl, bc
	pop af
	ld bc, $0008
	ld de, $D878
	farcall Palette_LoadToBuffer
	xor a, a
	ld [wBrowserTimerSecToggle], a
	dec a
	ld [wBrowserTimerLastSec], a
	ldh a, [hRam_FFD2]
	ld [wBrowserFrameStyle], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $DA80
	call Function_00_09E6
	call Function_00_044B

Label_4E_4154:: ; 4E:4154
	farcall Function_00_0956
	farcall Browser_DrawCommTimer
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4172-$417C (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 4E:416F: 5 entries; fixed length (5 words) by the routine

Table_4E_4172:: ; 4E:4172
	dw Label_4E_417C
	dw Label_4E_41A1
	dw Label_4E_41C2
	dw Label_4E_41C5
	dw Label_4E_4154

; ---- code $417C-$41E0 (100 bytes) [PROBABLE] 39 insn(s) reached by static flow only; seeds: site x39; min discovery hops 0; entered by table from 4E:416F (PROBABLE code) | forced execution: 23/39 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Label_4E_417C:: ; 4E:417C
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hRam_FFD2]
	or a, $80
	ld [wBrowserFrameStyle], a
	ld [sSram_A9EF], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hDialogResult], a
	jp Label_4E_41C8

Label_4E_41A1:: ; 4E:41A1
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sSram_A9EF]
	ld [wBrowserFrameStyle], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $00
	ldh [hDialogResult], a
	jp Label_4E_41C8

Label_4E_41C2:: ; 4E:41C2
	jp Label_4E_4154

Label_4E_41C5:: ; 4E:41C5
	jp Label_4E_4154

Label_4E_41C8:: ; 4E:41C8
	farcall SaveCheck_Update
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	xor a, a
	ldh [hRam_FFA7], a
	ldh a, [hDialogResult]
	ret

; ---- words $41E0-$45FE (1054 bytes) [PROBABLE] list of little-endian words grouped into 43 groups separated by $FFFF: each group = one delay-like word ($0004/$0008/$000C/$0010/$0002/$0001) followed by tilemap offsets row*32+col that walk the 32-wide BG map along anti-diagonals ($0000,$0001,$0020,$0002,$0021,$0040,...,$0294; verified by listing every group, offsets grow by $20-1 per step); consumer not located (no code word/immediate pointing into the table), so the use is inferred from the values only

Data_4E_41E0:: ; 4E:41E0
	dw $0000, $FFFF, $0004, $0001, Rst_20, $FFFF, $0004, $0002
	dw $0021, Vector_VBlank, $FFFF, Rst_08, $0003, $0022, $0041, Vector_Joypad
	dw $FFFF, Rst_08, $0004, $0023, $0042, $0061, $0080, $FFFF
	dw $000C, $0005, $0024, $0043, $0062, $0081, $00A0, $FFFF
	dw $000C, $0006, $0025, $0044, $0063, $0082, $00A1, $00C0
	dw $FFFF, Rst_10, $0007, $0026, $0045, $0064, $0083, $00A2
	dw $00C1, $00E0, $FFFF, Rst_10, Rst_08, $0027, $0046, $0065
	dw $0084, $00A3, $00C2, $00E1, Entry, $FFFF, Rst_10, $0009
	dw Rst_28, $0047, $0066, $0085, $00A4, $00C3, $00E2, $0101
	dw $0120, $FFFF, $000C, $000A, $0029, Vector_STAT, $0067, $0086
	dw $00A5, $00C4, $00E3, $0102, $0121, $0140, $FFFF, $000C
	dw $000B, $002A, $0049, $0068, $0087, $00A6, $00C5, $00E4
	dw $0103, $0122, $0141, $0160, $FFFF, $000C, $000C, $002B
	dw $004A, $0069, $0088, $00A7, $00C6, $00E5, Header, $0123
	dw $0142, $0161, $0180, $FFFF, $000C, $000D, $002C, $004B
	dw $006A, $0089, $00A8, $00C7, $00E6, $0105, $0124, $0143
	dw $0162, $0181, $01A0, $FFFF, Rst_08, $000E, $002D, $004C
	dw $006B, $008A, $00A9, $00C8, $00E7, $0106, $0125, $0144
	dw $0163, $0182, $01A1, $01C0, $FFFF, Rst_08, $000F, $002E
	dw $004D, $006C, $008B, $00AA, $00C9, $00E8, $0107, $0126
	dw $0145, $0164, $0183, $01A2, $01C1, $01E0, $FFFF, Rst_08
	dw Rst_10, $002F, $004E, $006D, $008C, $00AB, $00CA, $00E9
	dw $0108, $0127, $0146, $0165, $0184, $01A3, $01C2, $01E1
	dw $0200, $FFFF, Rst_08, $0011, Rst_30, $004F, $006E, $008D
	dw $00AC, $00CB, $00EA, $0109, $0128, $0147, $0166, $0185
	dw $01A4, $01C3, $01E2, $0201, $0220, $FFFF, Rst_08, $0012
	dw $0031, Vector_Timer, $006F, $008E, $00AD, $00CC, $00EB, $010A
	dw $0129, $0148, $0167, $0186, $01A5, $01C4, $01E3, $0202
	dw $0221, $0240, $FFFF, Rst_08, $0013, $0032, $0051, $0070
	dw $008F, $00AE, $00CD, $00EC, $010B, $012A, $0149, $0168
	dw $0187, $01A6, $01C5, $01E4, $0203, $0222, $0241, $0260
	dw $FFFF, Rst_08, $0014, $0033, $0052, $0071, $0090, $00AF
	dw $00CE, $00ED, $010C, $012B, $014A, $0169, $0188, $01A7
	dw $01C6, $01E5, $0204, $0223, $0242, $0261, $0280, $FFFF
	dw Rst_08, $0034, $0053, $0072, $0091, $00B0, $00CF, $00EE
	dw $010D, $012C, $014B, $016A, $0189, $01A8, $01C7, $01E6
	dw $0205, $0224, $0243, $0262, $0281, $FFFF, Rst_08, $0054
	dw $0073, $0092, $00B1, $00D0, $00EF, $010E, $012D, $014C
	dw $016B, $018A, $01A9, $01C8, $01E7, $0206, $0225, $0244
	dw $0263, $0282, $FFFF, $0004, $0074, $0093, $00B2, $00D1
	dw $00F0, $010F, $012E, $014D, $016C, $018B, $01AA, $01C9
	dw $01E8, $0207, $0226, $0245, $0264, $0283, $FFFF, $0004
	dw $0094, $00B3, $00D2, $00F1, $0110, $012F, $014E, $016D
	dw $018C, $01AB, $01CA, $01E9, $0208, $0227, $0246, $0265
	dw $0284, $FFFF, $0004, $00B4, $00D3, $00F2, $0111, $0130
	dw $014F, $016E, ReturnMobileAPI, $01AC, $01CB, $01EA, $0209, $0228
	dw Function_00_0247, $0266, $0285, $FFFF, $0004, $00D4, $00F3, $0112
	dw $0131, MobileAPI, $016F, $018E, $01AD, $01CC, $01EB, $020A
	dw $0229, $0248, $0267, $0286, $FFFF, $0004, $00F4, $0113
	dw $0132, $0151, $0170, $018F, $01AE, $01CD, $01EC, $020B
	dw $022A, $0249, $0268, $0287, $FFFF, $0004, $0114, $0133
	dw $0152, $0171, $0190, $01AF, $01CE, Int_Timer, $020C, $022B
	dw $024A, $0269, $0288, $FFFF, $0004, $0134, $0153, $0172
	dw $0191, $01B0, $01CF, $01EE, $020D, $022C, $024B, $026A
	dw $0289, $FFFF, $0004, $0154, $0173, $0192, $01B1, $01D0
	dw $01EF, $020E, $022D, $024C, $026B, $028A, $FFFF, $0002
	dw $0174, $0193, $01B2, $01D1, $01F0, $020F, $022E, $024D
	dw $026C, $028B, $FFFF, $0002, $0194, $01B3, $01D2, $01F1
	dw $0210, $022F, $024E, $026D, $028C, $FFFF, $0002, $01B4
	dw $01D3, $01F2, $0211, $0230, $024F, $026E, $028D, $FFFF
	dw $0002, $01D4, $01F3, $0212, $0231, $0250, $026F, $028E
	dw $FFFF, $0002, $01F4, $0213, $0232, $0251, $0270, $028F
	dw $FFFF, $0002, $0214, $0233, $0252, $0271, $0290, $FFFF
	dw $0002, $0234, $0253, $0272, $0291, $FFFF, $0002, $0254
	dw $0273, $0292, $FFFF, $0001, $0274, $0293, $FFFF, $0001
	dw $0294, $FFFF, $0001, $FFFF, $0000, $FFFF, $FFFF

; ---- code $45FE-$4658 (90 bytes) [PROBABLE] 54 insn(s) reached by static flow only; seeds: site x54; min discovery hops 2; entered by far from 4E:40A5 (PROBABLE code) | forced execution: 54/54 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_4E_45FE:: ; 4E:45FE
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a

Label_4E_4612:: ; 4E:4612
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	and a, c
	cp a, $FF
	jr z, Label_4E_4637
	push hl
	ld hl, $D000
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $B000
	add hl, bc
	ld a, [hl]
	ld [de], a
	ld hl, $D400
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $B400
	add hl, bc
	ld a, [hl]
	ld [de], a
	pop hl
	jr Label_4E_4612

Label_4E_4637:: ; 4E:4637
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wSpriteSlots + 129]
	add a, [hl]
	ld [wSpriteSlots + 129], a
	inc hl
	inc hl
	ld a, [hli]
	and a, [hl]
	cp a, $FF
	jr nz, Label_4E_4650
	ld hl, $0000
	ret

Label_4E_4650:: ; 4E:4650
	dec hl
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
