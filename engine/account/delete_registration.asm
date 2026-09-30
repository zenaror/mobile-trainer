; engine/account/delete_registration.asm
; bank 68, $7951-$7D8D (1084 bytes); pinned by layout.link
; delete-registration flow

SECTION "engine/account/delete_registration", ROMX

; ---- code $7951-$7990 (63 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Registration_DeleteFlow:: ; 68:7951
Function_68_7951::
	ld a, $08
	farcall Notice_ShowPage
	or a, a
	jr z, Label_68_798F

Label_68_795C:: ; 68:795C
	ld a, $09
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_DeleteFlow

Label_68_7967:: ; 68:7967
	xor a, a
	call Registration_DeleteConfirmPage
	or a, a
	jr z, Label_68_795C
	cp a, $02
	jr z, Label_68_7990
	ld a, $01
	call Registration_DeleteConfirmPage
	or a, a
	jr z, Label_68_7967
	cp a, $02
	jr z, Label_68_7990
	farcall Registration_DeleteExecute
	or a, a
	jr z, Label_68_7999
	ld a, $0B
	farcall Notice_ShowPage

Label_68_798F:: ; 68:798F
	ret

; ---- code $7990-$7999 (9 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 68:7970 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 7990-799A by apply_coverage --split [executed in 7 scenarios]

Label_68_7990:: ; 68:7990
	ld a, $0A
	farcall Notice_ShowPage
	ret

; ---- code $7999-$799A (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 7990-799A by apply_coverage --split

Label_68_7999:: ; 68:7999
	ret

; ---- code $799A-$7ACB (305 bytes) [CONFIRMED] 105 insn(s); 105 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Registration_DeleteConfirmPage:: ; 68:799A
Function_68_799A::
	ld [wRam_C27C], a
	call Registration_DeleteConfirm_Setup
	farcall Palette_FadeInFromWhite
	call Registration_DeleteConfirm_InputLoop
	push af
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	pop af
	ret

Registration_DeleteConfirm_Setup:: ; 68:79B8
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld a, $01
	ld [wRam_C27D], a
	ld a, [wRam_C27C]
	or a, a
	jr nz, Label_68_7A0A
	ld de, $9001
	ld hl, Data_71_5340
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_71_5740
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_71_66C8
	ld a, $71
	farcall Function_00_08EA
	jr Label_68_7A3F

Label_68_7A0A:: ; 68:7A0A
	ld de, $9001
	ld hl, $59C0
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_71_5DC0
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Data_71_6998
	ld a, $71
	farcall Function_00_08EA

Label_68_7A3F:: ; 68:7A3F
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, $5F
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_71_6680
	ld a, $71
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, $D868
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	call Registration_DeleteConfirm_PrintMessage
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_4A_4000
	ld a, $4A
	ld b, $81
	farcall Function_00_0A82
	call Registration_DeleteConfirm_UpdateCursor
	ret

Registration_DeleteConfirm_InputLoop:: ; 68:7A8F
	farcall Function_00_0956
	farcall Joypad_Update
	call Function_00_044B
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_68_7AB2
	bit 1, a
	jr nz, Label_68_7ACE
	bit 5, a
	jr nz, Label_68_7AE0
	bit 4, a
	jr nz, Label_68_7AE0
	jr Registration_DeleteConfirm_InputLoop

Label_68_7AB2:: ; 68:7AB2
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_68_7ACB
	ld a, $01
	ret

; ---- code $7ACB-$7AE0 (21 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by jrcc from 68:7AC6 (executed) [executed in 3 scenarios]

Label_68_7ACB:: ; 68:7ACB
	ld a, $02
	ret

Label_68_7ACE:: ; 68:7ACE
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ret

; ---- code $7AE0-$7B19 (57 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)

Label_68_7AE0:: ; 68:7AE0
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	ld b, $01
	xor a, b
	ld [wRam_C27D], a
	call Registration_DeleteConfirm_UpdateCursor
	jr Label_68_7AFE

Label_68_7AFE:: ; 68:7AFE
	jp Registration_DeleteConfirm_InputLoop

Registration_DeleteConfirm_UpdateCursor:: ; 68:7B01
	ld a, [wRam_C27D]
	add a, a
	ld hl, Registration_DeleteCursorPositions
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $DA00
	call Function_00_0A65
	ret

; ---- data $7B19-$7B1D (4 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Registration_DeleteCursorPositions:: ; 68:7B19
Data_68_7B19::
	db $28, $30, $58, $30

; ---- code $7B1D-$7C6B (334 bytes) [CONFIRMED] 119 insn(s); 119 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Registration_DeleteConfirm_PrintMessage:: ; 68:7B1D
Function_68_7B1D::
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $48
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wRam_C27C]
	or a, a
	jr nz, Label_68_7B70
	ld a, $06
	farcall Function_00_153D
	jr Label_68_7B78

Label_68_7B70:: ; 68:7B70
	ld a, $07
	farcall Function_00_153D

Label_68_7B78:: ; 68:7B78
	call Function_00_0ED3
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, $D121
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret

Registration_DeleteExecute:: ; 68:7B9A
	call Registration_DeleteExecute_Setup
	farcall Palette_FadeInFromWhite
	call Registration_DeleteExecute_RunState
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C27C]
	ret

Registration_DeleteExecute_Setup:: ; 68:7BB0
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
	ld de, $8801
	ld hl, $6180
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_71_6580
	ld a, $71
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $8000
	ld hl, $6140
	ld a, $71
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Data_71_6680
	ld a, $71
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, $D840
	ld hl, $66C0
	ld a, $71
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_71_6C68
	ld a, $71
	farcall Function_00_08EA
	call Registration_DeleteExecute_PrintMessage
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_71_6F38
	ld a, $71
	ld b, $81
	farcall Function_00_0A82
	ld de, $1C44
	ld hl, $DA00
	call Function_00_0A65
	ret

Registration_DeleteExecute_RunState:: ; 68:7C52
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wRam_C27D]
	add a, a
	add a, $6B
	ld l, a
	ld a, $7C
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $7C6B-$7C71 (6 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [retyped data->words by classify_g2: every word is an instruction start of a code region of this bank (jump/dispatch table)]

Registration_DeleteExecute_StateTable:: ; 68:7C6B
Table_68_7C6B::
	dw $7C71, $7C86, $7CBD

; ---- code $7C71-$7CE8 (119 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios)
	call Config_ClearSramMirror
	ld de, $C271
	ld hl, $0068
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRam_C27D], a
	jr Registration_DeleteExecute_RunState

	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_68_7CE8
	bit 0, a
	jp nz, Registration_DeleteExecute_RunState
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld c, $C0
	ld hl, $A000
	ld de, $0000
	ld a, $04
	call MobileAPI
	ld a, $02
	ld [wRam_C27D], a
	jp Registration_DeleteExecute_RunState

	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_68_7CE8
	bit 0, a
	jp nz, Registration_DeleteExecute_RunState
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
	call Sram_WipeAllBanks
	ld a, $01
	ld [wRam_C27C], a
	ret

; ---- code $7CE8-$7D1C (52 bytes) [PROBABLE] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1; entered by jpcc from 68:7C8B (executed)

Label_68_7CE8:: ; 68:7CE8
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	ld a, $36
	call MobileAPI
	ld a, $0A
	farcall Notice_ShowPage
	xor a, a
	ld [wRam_C27C], a
	ret

; ---- code $7D1C-$7D8D (113 bytes) [CONFIRMED] 46 insn(s); 46 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Registration_DeleteExecute_PrintMessage:: ; 68:7D1C
Function_68_7D1C::
	ld a, $03
	farcall Function_00_153D
	push hl
	push af
	ld de, $FFFF
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $58
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $58
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $88
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	pop af
	pop hl
	call Function_00_0ED3
	ld de, $9000
	ld hl, $0B01
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, $D161
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret
