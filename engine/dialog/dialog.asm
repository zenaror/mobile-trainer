; engine/dialog/dialog.asm
; bank 72, $4000-$48C0 (2240 bytes); pinned by layout.link
; message dialog service (open, wait input, close, slide, save/restore background)

SECTION "engine/dialog/dialog", ROMX

; ---- code $4000-$43A1 (929 bytes) [CONFIRMED] 351 insn(s); 351 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Dialog_ShowMonitored:: ; 72:4000
Function_72_4000::
	farcall Dialog_Open
	farcall Dialog_WaitInputMonitored
	farcall Dialog_Close
	ldh a, [hDialogResult]
	ret

Dialog_Show:: ; 72:4015
	farcall Dialog_Open
	farcall Dialog_WaitInput
	farcall Dialog_Close
	ldh a, [hDialogResult]
	ret

Dialog_Open:: ; 72:402A
	ld c, d
	ld b, $00
	ld hl, Dialog_ListTable
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, $00
	add hl, de
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	push hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	ld a, [hli]
	cp a, $03
	jp nc, Dialog_OpenTall
	farcall Dialog_SaveBackground
	farcall Dialog_InitWindowRegs
	ld de, $8801
	ld hl, Dialog_WindowTiles
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0010
	ld de, $D830
	ld hl, Dialog_Palette
	ld a, $72
	farcall Palette_LoadToBuffer
	ld bc, $0914
	ld de, $D180
	ld hl, Dialog_WindowMap
	ld a, $72
	farcall Function_00_08EA
	ld bc, $0008
	ld de, $D860
	ld hl, $4E38
	ld a, $72
	farcall Palette_LoadToBuffer
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
	ld hl, $DAC0
	ld de, Dialog_CursorObjTable
	ld a, $72
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	ld a, [hli]
	ld a, [hli]
	ld [wDialogType], a
	ld a, [hli]
	ldh [hDialogResult], a
	push hl
	ld a, [wDialogType]
	call Dialog_SetupCursorByType
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DC00
	ld bc, $0400
	xor a, a
	call FillBytes
	ld hl, $D1A2
	ld bc, $0410
	ld de, $0EC0
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	call Function_00_0392
	ld bc, $DC00
	ld de, $DD00
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	ld bc, $DE00
	ld de, $DF00
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	ld de, $8C01
	ld hl, $DC00
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMap
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D180
	ld de, $D120
	ld bc, $0120
	call CopyBytes
	ld hl, $D580
	ld de, $D520
	ld bc, $0120
	call CopyBytes
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld c, $02
	ldh a, [rWY]
	cp a, $48
	jr z, Label_72_4196
	ld hl, Data_72_43A1
	farcall Dialog_SlideIn

Label_72_4196:: ; 72:4196
	ldh a, [rLCDC]
	call Function_00_07CB
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0030
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wJoyRepeatInterval]
	ld [wRam_C2E4], a
	ld a, [wJoyRepeatDelay]
	ld [wRam_C2E3], a
	ld b, $14
	ld c, $04
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Dialog_OpenTall:: ; 72:41D8
	farcall Dialog_SaveBackgroundTall
	farcall Dialog_InitWindowRegs
	ld de, $8801
	ld hl, Dialog_WindowTiles
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0010
	ld de, $D830
	ld hl, Dialog_Palette
	ld a, $72
	farcall Palette_LoadToBuffer
	ld bc, $0B14
	ld de, $D140
	ld hl, Dialog_WindowMapTall
	ld a, $72
	farcall Function_00_08EA
	ld bc, $0008
	ld de, $D860
	ld hl, $4E38
	ld a, $72
	farcall Palette_LoadToBuffer
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
	ld hl, $DAC0
	ld de, Dialog_CursorObjTable
	ld a, $72
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	ld a, [hli]
	ld a, [hli]
	ld [wDialogType], a
	ld a, [hli]
	ldh [hDialogResult], a
	push hl
	ld a, [wDialogType]
	call Dialog_SetupCursorByType
	ld hl, $DC00
	ld bc, $0400
	xor a, a
	call FillBytes
	ld hl, $D162
	ld bc, $0410
	ld de, $0EC0
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D1E2
	ld bc, $0210
	ld de, $0E00
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	call Function_00_0392
	ld bc, $DC00
	ld de, $DD00
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	ld bc, $DE00
	ld de, $DF00
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	push hl
	ld de, $8C01
	ld hl, $DC00
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DC00
	ld bc, $0400
	xor a, a
	call FillBytes
	call Function_00_0392
	pop hl
	ld bc, $DC00
	ld de, $DD00
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	ld de, $9001
	ld hl, $DC00
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMapTall
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D140
	ld de, $D0E0
	ld bc, $0160
	call CopyBytes
	ld hl, $D540
	ld de, $D4E0
	ld bc, $0160
	call CopyBytes
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld c, $02
	ldh a, [rWY]
	cp a, $38
	jr z, Label_72_435F
	ld hl, $43A4
	farcall Dialog_SlideIn

Label_72_435F:: ; 72:435F
	ldh a, [rLCDC]
	call Function_00_07CB
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0030
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wJoyRepeatInterval]
	ld [wRam_C2E4], a
	ld a, [wJoyRepeatDelay]
	ld [wRam_C2E3], a
	ld b, $14
	ld c, $04
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $43A1-$43A7 (6 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_72_43A1:: ; 72:43A1
	db $48, $00, $80, $58, $00, $80

; ---- code $43A7-$43AA (3 bytes) [CONFIRMED] 1 insn(s); 1 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Dialog_SetupCursorByType:: ; 72:43A7
Function_72_43A7::
	call JumpTableInline

; ---- ptrtable $43AA-$43B6 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 72:43A7: 6 entries; end pinned by the executed instruction at 43B6

Table_72_43AA:: ; 72:43AA
	dw Label_72_43B6
	dw Label_72_4412
	dw Label_72_43DC
	dw Label_72_43B6
	dw Label_72_4407
	dw Label_72_43C1

; ---- code $43B6-$43C1 (11 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_72_43B6:: ; 72:43B6
	ld hl, $DAC0
	call Function_00_09E6
	ld a, $00
	ldh [hDialogResult], a
	ret

; ---- code $43C1-$43C6 (5 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1; entered by table from 72:43A7 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 43C1-43DC by apply_coverage --split [executed in 3 scenarios]

Label_72_43C1:: ; 72:43C1
	ldh a, [hDialogResult]
	or a, a
	jr z, Label_72_43D1

; ---- code $43C6-$43D1 (11 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 43C1-43DC by apply_coverage --split
	ld de, $D058
	ld hl, $DAC0
	call Function_00_0A65
	jr Label_72_43F7

; ---- code $43D1-$43DC (11 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 43C1-43DC by apply_coverage --split [executed in 3 scenarios]

Label_72_43D1:: ; 72:43D1
	ld de, $D028
	ld hl, $DAC0
	call Function_00_0A65
	jr Label_72_43F7

; ---- code $43DC-$4572 (406 bytes) [CONFIRMED] 177 insn(s); 177 executed (in up to 4/18 scenarios)

Label_72_43DC:: ; 72:43DC
	ldh a, [hDialogResult]
	or a, a
	jr z, Label_72_43EC
	ld de, $C058
	ld hl, $DAC0
	call Function_00_0A65
	jr Label_72_43F7

Label_72_43EC:: ; 72:43EC
	ld de, $C028
	ld hl, $DAC0
	call Function_00_0A65
	jr Label_72_43F7

Label_72_43F7:: ; 72:43F7
	ld hl, $D245
	ld a, $88
	call Dialog_DrawButtonTiles
	ld hl, $D24B
	ld a, $8C
	jp Dialog_DrawButtonTiles

Label_72_4407:: ; 72:4407
	ld de, $D040
	ld hl, $DAC0
	call Function_00_0A65
	jr Label_72_441B

Label_72_4412:: ; 72:4412
	ld de, $C040
	ld hl, $DAC0
	call Function_00_0A65

Label_72_441B:: ; 72:441B
	ld a, $00
	ldh [hDialogResult], a
	ld hl, $D248
	ld a, $A0

Dialog_DrawButtonTiles:: ; 72:4424
	push hl
	ld c, a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	pop de
	ld hl, $0020
	add hl, de
	ld a, c
	add a, $10
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	inc a
	ld [hli], a
	ld hl, $0400
	add hl, de
	ld a, $0F
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld hl, $0420
	add hl, de
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ret

Dialog_Close:: ; 72:444F
	call Function_00_0392
	ld a, [wDialogType]
	cp a, $03
	jp nc, Dialog_CloseTall
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D23F
	ld de, $D29F
	ld bc, $0120
	call CopyBytesBackward
	ld hl, $D63F
	ld de, $D69F
	ld bc, $0120
	call CopyBytesBackward
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMap
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	farcall Dialog_RestoreBackground
	ldh a, [rLCDC]
	call Function_00_07CB
	ld c, $02
	ldh a, [rWY]
	cp a, $90
	jr z, Label_72_44BB
	ld hl, Data_72_4572
	farcall Dialog_SlideOut

Label_72_44BB:: ; 72:44BB
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld hl, $DAC0
	call Function_00_09E6
	ld a, [wRam_C2E4]
	ld c, a
	ld a, [wRam_C2E3]
	ld b, a
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Dialog_CloseTall:: ; 72:44E6
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D1FF
	ld de, $D25F
	ld bc, $0120
	call CopyBytesBackward
	ld hl, $D5FF
	ld de, $D65F
	ld bc, $0120
	call CopyBytesBackward
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMapTall
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	farcall Dialog_RestoreBackgroundTall
	ldh a, [rLCDC]
	call Function_00_07CB
	ld c, $02
	ldh a, [rWY]
	cp a, $90
	jr z, Label_72_4547
	ld hl, $4575
	farcall Dialog_SlideOut

Label_72_4547:: ; 72:4547
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld hl, $DAC0
	call Function_00_09E6
	ld a, [wRam_C2E4]
	ld c, a
	ld a, [wRam_C2E3]
	ld b, a
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $4572-$4578 (6 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown

Data_72_4572:: ; 72:4572
	db $48, $00, $80, $58, $00, $80

; ---- code $4578-$4596 (30 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

Dialog_WaitInput:: ; 72:4578
Function_72_4578::
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4596-$45A0 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 72:4593: 5 entries; fixed length (5 words) by the routine

Dialog_WaitInputTable:: ; 72:4596
Table_72_4596::
	dw Label_72_45EA
	dw Label_72_4606
	dw Label_72_4600
	dw Label_72_4603
	dw Label_72_45A0

; ---- code $45A0-$4603 (99 bytes) [CONFIRMED] 45 insn(s); 45 executed (in up to 3/18 scenarios)

Label_72_45A0:: ; 72:45A0
	ld a, [wDialogType]
	cp a, $05
	jr z, Label_72_45AC
	cp a, $02
	jp nz, Dialog_WaitInput

Label_72_45AC:: ; 72:45AC
	ldh a, [hJoyPressedRepeat]
	bit 4, a
	jr nz, Label_72_45B9
	bit 5, a
	jr nz, Label_72_45B9
	jp Dialog_WaitInput

Label_72_45B9:: ; 72:45B9
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	xor a, $01
	ldh [hDialogResult], a
	or a, a
	jr nz, Label_72_45DE
	ld de, $7828
	ld hl, $DAC0
	call Function_00_0A65
	jp Dialog_WaitInput

Label_72_45DE:: ; 72:45DE
	ld de, $7858
	ld hl, $DAC0
	call Function_00_0A65
	jp Dialog_WaitInput

Label_72_45EA:: ; 72:45EA
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002D
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	inc a
	ldh [hDialogResult], a
	ret

Label_72_4600:: ; 72:4600
	jp Dialog_WaitInput

; ---- code $4603-$4606 (3 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by table from 72:4593 (executed) [executed in 4 scenarios]

Label_72_4603:: ; 72:4603
	jp Dialog_WaitInput

; ---- code $4606-$4647 (65 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 1/18 scenarios)

Label_72_4606:: ; 72:4606
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ldh [hDialogResult], a
	ret

Dialog_WaitInputMonitored:: ; 72:461A
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_72_467A
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_72_4726
	bit 4, a
	jp z, Label_72_471C
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_72_4674
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_72_4675
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_72_4674

; ---- code $4647-$4657 (16 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 72:4645 (executed) | 7 insn(s) executed; cut out of the PROBABLE region 4647-4674 by apply_coverage --split [executed in 1 scenarios]
	jr nz, Label_72_4650
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_72_4674

Label_72_4650:: ; 72:4650
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_72_4660

; ---- code $4657-$4660 (9 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4647-4674 by apply_coverage --split
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_72_4674
	set 1, [hl]

; ---- code $4660-$4674 (20 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4647-4674 by apply_coverage --split [executed in 1 scenarios]

Label_72_4660:: ; 72:4660
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_72_4675
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_72_4675

; ---- code $4674-$4698 (36 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_72_4674:: ; 72:4674
	xor a, a

Label_72_4675:: ; 72:4675
	pop hl
	or a, a
	jp nz, Label_72_4721

Label_72_467A:: ; 72:467A
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $4698-$46A2 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 72:4695: 5 entries; fixed length (5 words) by the routine

Dialog_WaitInputMonitoredTable:: ; 72:4698
Table_72_4698::
	dw Label_72_46EC
	dw Label_72_4708
	dw Label_72_4702
	dw Label_72_4705
	dw Label_72_46A2

; ---- code $46A2-$46AE (12 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_72_46A2:: ; 72:46A2
	ld a, [wDialogType]
	cp a, $05
	jr z, Label_72_46AE
	cp a, $02
	jp nz, Dialog_WaitInputMonitored

; ---- code $46AE-$4708 (90 bytes) [CONFIRMED] 41 insn(s) reached by static flow only; seeds: exec x41; min discovery hops 0; entered by jrcc from 72:46A7 (executed) [executed in 1 scenarios]

Label_72_46AE:: ; 72:46AE
	ldh a, [hJoyPressedRepeat]
	bit 4, a
	jr nz, Label_72_46BB
	bit 5, a
	jr nz, Label_72_46BB
	jp Dialog_WaitInputMonitored

Label_72_46BB:: ; 72:46BB
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	xor a, $01
	ldh [hDialogResult], a
	or a, a
	jr nz, Label_72_46E0
	ld de, $7828
	ld hl, $DAC0
	call Function_00_0A65
	jp Dialog_WaitInputMonitored

Label_72_46E0:: ; 72:46E0
	ld de, $7858
	ld hl, $DAC0
	call Function_00_0A65
	jp Dialog_WaitInputMonitored

Label_72_46EC:: ; 72:46EC
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002D
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	inc a
	ldh [hDialogResult], a
	ret

Label_72_4702:: ; 72:4702
	jp Dialog_WaitInputMonitored

Label_72_4705:: ; 72:4705
	jp Dialog_WaitInputMonitored

; ---- code $4708-$471C (20 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios)

Label_72_4708:: ; 72:4708
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ldh [hDialogResult], a
	ret

; ---- code $471C-$4721 (5 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jpcc from 72:462B (executed) | 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 471C-472B by apply_coverage --split

Label_72_471C:: ; 72:471C
	ld a, $03
	ldh [hDialogResult], a
	ret

; ---- code $4721-$4726 (5 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 471C-472B by apply_coverage --split [executed in 1 scenarios]

Label_72_4721:: ; 72:4721
	ld a, $04
	ldh [hDialogResult], a
	ret

; ---- code $4726-$472B (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 471C-472B by apply_coverage --split

Label_72_4726:: ; 72:4726
	ld a, $05
	ldh [hDialogResult], a
	ret

; ---- code $472B-$4836 (267 bytes) [CONFIRMED] 123 insn(s); 123 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Dialog_SaveBackground:: ; 72:472B
Function_72_472B::
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0120
	ld hl, $D120
	ld de, $D2E0
	call CopyBytes
	ld bc, $0120
	ld hl, $D520
	ld de, $D6E0
	jp CopyBytes

Dialog_SaveBackgroundTall:: ; 72:4749
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0160
	ld hl, $D0E0
	ld de, $D2A0
	call CopyBytes
	ld bc, $0160
	ld hl, $D4E0
	ld de, $D6A0
	jp CopyBytes

Dialog_RestoreBackground:: ; 72:4767
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0120
	ld hl, $D2E0
	ld de, $D120
	call CopyBytes
	ld bc, $0120
	ld hl, $D6E0
	ld de, $D520
	jp CopyBytes

Dialog_RestoreBackgroundTall:: ; 72:4785
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0160
	ld hl, $D2A0
	ld de, $D0E0
	call CopyBytes
	ld bc, $0160
	ld hl, $D6A0
	ld de, $D4E0
	jp CopyBytes

Dialog_UploadWindowMap:: ; 72:47A3
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	di
	call Function_00_08B7
	ld b, $97
	ld c, $12
	ld hl, $D180
	xor a, a
	call Function_00_0749
	inc e
	ld b, $97
	ld c, $12
	ld hl, $D580
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

Dialog_UploadWindowMapTall:: ; 72:47D4
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	di
	call Function_00_08B7
	ld b, $96
	ld c, $16
	ld hl, $D140
	xor a, a
	call Function_00_0749
	inc e
	ld b, $96
	ld c, $16
	ld hl, $D540
	xor a, a
	call Function_00_0749
	ei
	call Function_00_0392
	ret

Dialog_InitWindowRegs:: ; 72:4805
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $9F
	ld b, a
	and a, $08
	xor a, $08
	rlca
	rlca
	rlca
	or a, b
	ldh [rLCDC], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	ei
	call Function_00_0392
	ret

Dialog_SlideIn:: ; 72:4824
	ld a, $FF
	ld [wConnIconGfxRequest], a

Label_72_4829:: ; 72:4829
	ld a, [hli]
	cp a, $80
	jr z, Label_72_486D
	ld de, $0000
	ld b, a
	bit 0, c
	jr z, Label_72_4837

; ---- code $4836-$4837 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 72:4834 (executed)
	ld e, a

; ---- code $4837-$4840 (9 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios)

Label_72_4837:: ; 72:4837
	bit 1, c
	jr z, Label_72_483C
	ld d, a

Label_72_483C:: ; 72:483C
	bit 2, c
	jr z, Label_72_4842

; ---- code $4840-$4842 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 72:483E (executed)
	ld a, [hli]
	ld e, a

; ---- code $4842-$4846 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)

Label_72_4842:: ; 72:4842
	bit 3, c
	jr z, Label_72_4848

; ---- code $4846-$4848 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 72:4844 (executed)
	ld a, [hli]
	ld d, a

; ---- code $4848-$4884 (60 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 4/18 scenarios)

Label_72_4848:: ; 72:4848
	ldh a, [hRam_FFF1]
	sub a, d
	ldh [hRam_FFF1], a
	ld d, b
	push hl
	push bc
	push de
	farcall Function_00_0956
	call Function_00_047A
	pop de
	ldh a, [rWY]
	sub a, d
	ldh [rWY], a
	ldh a, [rSCY]
	add a, e
	ldh [rSCY], a
	pop bc
	pop hl
	ei
	call Function_00_0392
	jr Label_72_4829

Label_72_486D:: ; 72:486D
	xor a, a
	ld [wConnIconGfxRequest], a
	ret

Dialog_SlideOut:: ; 72:4872
	ld a, $FF
	ld [wConnIconGfxRequest], a

Label_72_4877:: ; 72:4877
	ld a, [hli]
	cp a, $80
	jr z, Label_72_48BB
	ld de, $0000
	ld b, a
	bit 0, c
	jr z, Label_72_4885

; ---- code $4884-$4885 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 72:4882 (executed)
	ld e, a

; ---- code $4885-$488E (9 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios)

Label_72_4885:: ; 72:4885
	bit 1, c
	jr z, Label_72_488A
	ld d, a

Label_72_488A:: ; 72:488A
	bit 2, c
	jr z, Label_72_4890

; ---- code $488E-$4890 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 72:488C (executed)
	ld a, [hli]
	ld e, a

; ---- code $4890-$4894 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)

Label_72_4890:: ; 72:4890
	bit 3, c
	jr z, Label_72_4896

; ---- code $4894-$4896 (2 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 72:4892 (executed)
	ld a, [hli]
	ld d, a

; ---- code $4896-$48C0 (42 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 4/18 scenarios)

Label_72_4896:: ; 72:4896
	ldh a, [hRam_FFF1]
	add a, d
	ldh [hRam_FFF1], a
	ld d, b
	push hl
	push bc
	push de
	farcall Function_00_0956
	call Function_00_047A
	pop de
	ldh a, [rWY]
	add a, d
	ldh [rWY], a
	ldh a, [rSCY]
	sub a, e
	ldh [rSCY], a
	pop bc
	pop hl
	ei
	call Function_00_0392
	jr Label_72_4877

Label_72_48BB:: ; 72:48BB
	xor a, a
	ld [wConnIconGfxRequest], a
	ret
