; engine/account/action_confirm.asm
; bank 68, $6E1A-$7019 (511 bytes); pinned by layout.link
; action confirm page

SECTION "engine/account/action_confirm", ROMX

Account_ActionConfirmPage:: ; 68:6E1A
Function_68_6E1A::
	; [CONFIRMED] 147 insn(s); 147 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wRam_C27E], a
	call Account_ActionConfirmPage_Setup
	farcall Palette_FadeInFromWhite
	call Account_ActionConfirmPage_InputLoop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

Account_ActionConfirmPage_Setup:: ; 68:6E39
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld a, $00
	ld [wRam_C27D], a
	ld de, $9001
	ld hl, Data_5E_6BA0
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_5E_6FA0
	ld a, $5E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, $5F
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, $72C0
	ld a, $5E
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, $D868
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld a, [wRam_C27E]
	or a, a
	jr z, .l6EC3
	ld bc, $1214
	ld de, $D000
	ld hl, Data_5E_75D0
	ld a, $5E
	farcall Function_00_08EA
	jr .l6ED4
.l6EC3 ; 68:6EC3
	ld bc, $1214
	ld de, $D000
	ld hl, $7300
	ld a, $5E
	farcall Function_00_08EA
.l6ED4 ; 68:6ED4
	call Account_ActionConfirmPage_PrintMessage
	call Account_ActionConfirmPage_UploadTextTiles
	call Account_ActionConfirmPage_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_4A_4000
	ld a, $4A
	ld b, $81
	farcall Function_00_0A82
	call Account_ActionConfirmPage_UpdateCursor
	ret

Account_ActionConfirmPage_InputLoop:: ; 68:6EF6
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l6F19
	bit 1, a
	jr nz, .l6F40
	bit 5, a
	jr nz, .l6F5E
	bit 4, a
	jr nz, .l6F5E
	jr Account_ActionConfirmPage_InputLoop
.l6F19 ; 68:6F19
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
	jr nz, .l6F35
	ld a, $01
	ld [wRam_C27C], a
	ret
.l6F35 ; 68:6F35
	ld a, $02
	ld [wRam_C27C], a
	ld a, $01
	ld [wRam_C28E], a
	ret
.l6F40 ; 68:6F40
	ld a, [wRam_C27E]
	or a, a
	jr z, Account_ActionConfirmPage_InputLoop
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C28E], a
	ret
.l6F5E ; 68:6F5E
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
	call Account_ActionConfirmPage_UpdateCursor
	jr .l6F7C
.l6F7C ; 68:6F7C
	jp Account_ActionConfirmPage_InputLoop

Account_ActionConfirmPage_UpdateCursor:: ; 68:6F7F
	ld a, [wRam_C27D]
	add a, a
	ld hl, Account_ActionConfirmCursorPositions
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

; ---- data $6F97-$6F9B (4 bytes) [CONFIRMED] read as data by executed code (in up to 6/18 scenarios); content class unknown

Account_ActionConfirmCursorPositions:: ; 68:6F97
Data_68_6F97::
	db $28, $30, $58, $30

Account_ActionConfirmPage_BuildTextMap:: ; 68:6F9B
Function_68_6F9B::
	; [CONFIRMED] 46 insn(s); 46 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $D121
	ld de, $0000
	ld bc, $0612
	farcall Tilemap_FillAscendingWithAttr
	ret

Account_ActionConfirmPage_PrintMessage:: ; 68:6FAB
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
	ld a, $C8
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wRam_C27E]
	ld hl, Account_ActionMessageIds
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	farcall Function_00_153D
	call Function_00_0ED3
	ret

; ---- data $7005-$7009 (4 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown

Account_ActionMessageIds:: ; 68:7005
Data_68_7005::
	db $04, $0B, $0C, $0D

Account_ActionConfirmPage_UploadTextTiles:: ; 68:7009
Function_68_7009::
	; [CONFIRMED] 47 insn(s); 47 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $7009-$7079)
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret
