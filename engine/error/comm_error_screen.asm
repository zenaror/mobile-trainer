; engine/error/comm_error_screen.asm
; bank 5C, $5150-$5516 (966 bytes); pinned by layout.link
; communication error screen

SECTION "engine/error/comm_error_screen", ROMX

CommErr_ShowScreen:: ; 5C:5150
Function_5C_5150::
	; [CONFIRMED] 78 insn(s); 78 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push hl
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4 ; raw: start of the 252-byte per-screen window wipe
	call FillBytes
	farcall Stub_Nop_48_48BB
	pop hl
	ld a, h
	ld [wCommErrCodeHi], a
	ld a, l
	ld [wCommErrCodeLo], a
	pop af
	ld [wCommErrCategory], a
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	ld de, $8001
	ld hl, CommErr_Gfx_Obj8000
	ld a, $5C
	ld b, $98
	ld c, $02
	farcall Gfx_StartHDMAWithService
	ld de, $8101
	ld hl, CommErr_Gfx_Obj8100
	ld a, $5C
	ld b, $98
	ld c, $02
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, CommErr_Gfx_Bg9000
	ld a, $5C
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, CommErr_Gfx_Bg9400
	ld a, $5C
	ld b, $96
	ld c, $18
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, $6390
	ld a, $5C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $63D0
	ld a, $5C
	farcall Palette_LoadToBuffer
	call CommErr_DrawMessage
	call CommErr_DrawErrorNumber
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0015
	call Sound_PlayMusic
	pop af
	ldh [rSVBK], a

CommErr_ShowScreen_FrameLoop:: ; 5C:5219
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $5231-$523B (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 5C:522E: 5 entries; fixed length (5 words) by the routine

CommErr_JoypadTable:: ; 5C:5231
Table_5C_5231::
	dw CommErr_ShowScreen_ButtonA
	dw CommErr_ShowScreen_Ignore
	dw CommErr_ShowScreen_Ignore
	dw CommErr_ShowScreen_Ignore
	dw CommErr_ShowScreen_Idle

CommErr_ShowScreen_Idle:: ; 5C:523B
	; [CONFIRMED] 155 insn(s); 155 executed (in up to 3/18 scenarios)
	ld a, [wCommErr_TimerVariantFlag]
	or a, a
	call nz, CommErr_UpdateCommFooter
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, Stub_Nop_5C_5266
	jp CommErr_ShowScreen_FrameLoop

CommErr_ShowScreen_ButtonA:: ; 5C:524C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

CommErr_ShowScreen_Ignore:: ; 5C:5264
Label_5C_5264::
	jr CommErr_ShowScreen_FrameLoop

Stub_Nop_5C_5266:: ; 5C:5266
Function_5C_5266::
	ret

CommErr_DrawMessage:: ; 5C:5267
	ld de, $FFFF
	ld hl, $0301
	ld bc, $0C12
	farcall TileCanvas_FillRect
	ld a, [wCommErrCategory]
	ld b, a
	ld hl, CommErr_RecordTable

CommErr_FindRecord:: ; 5C:527D
	ld a, [hli]
	cp a, $FF
	jp z, CommErr_FindRecord_NotFound
	cp a, b
	jr z, .l528B
	inc hl
	inc hl
	inc hl
	jr CommErr_FindRecord
.l528B ; 5C:528B
	ld a, [hli]
	dec a
	jr nz, CommErr_DrawMessage_PlainVariant
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, CommErr_DrawMessage_TimerVariant
	push hl
	ld bc, $1214
	ld de, $D000
	ld hl, CommErr_Tilemap_Comm
	ld a, $5C
	farcall Tilemap_CopyRectAndAttr
	pop hl
	jr CommErr_LookupTriple

CommErr_DrawMessage_TimerVariant:: ; 5C:52AB
	push hl
	ld bc, $1214
	ld de, $D000
	ld hl, CommErr_Tilemap_CommTimer
	ld a, $5C
	farcall Tilemap_CopyRectAndAttr
	ld hl, $DA10
	ld de, $642B
	ld a, $5C
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $8010
	ld hl, $DA10
	call Sprite_SetPosition
	ld bc, $0040
	ld de, $D800
	ld hl, CommErr_Palette_BgTimer
	ld a, $5C
	farcall Palette_LoadToBuffer
	pop hl
	ld a, $01
	ld [wCommErr_TimerVariantFlag], a
	jr CommErr_LookupTriple

CommErr_DrawMessage_PlainVariant:: ; 5C:52EF
	push hl
	ld bc, $1214
	ld de, $D000
	ld hl, CommErr_Tilemap_Plain
	ld a, $5C
	farcall Tilemap_CopyRectAndAttr
	pop hl

CommErr_LookupTriple:: ; 5C:5302
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCommErrCodeHi]
	ld d, a
	ld a, [wCommErrCodeLo]
	ld e, a
.loop ; 5C:530D
	ld a, [hli]
	cp a, $FF
	jp z, CommErr_PrintMessage
	cp a, d
	jr nz, .l531A
	ld a, [hl]
	cp a, e
	jr z, CommErr_PrintMessage
.l531A ; 5C:531A
	inc hl
	inc hl
	jr .loop

CommErr_PrintMessage:: ; 5C:531E
	inc hl
	ld a, [hl]
	ld hl, CommErr_MessagePointers
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $18
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	xor a, a
	ldh [hTextX + 1], a
	ld a, $18
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	xor a, a
	ldh [hTextBox_LineStartXHi], a
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $5C
	call TextEngine_Run
	ld de, $9000
	ld hl, $0301
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0A01
	ld bc, $0512
	farcall TileCanvas_UploadRect
	ld hl, $D061
	ld bc, $0712
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ld hl, $D141
	ld bc, $0512
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ret

CommErr_FindRecord_NotFound:: ; 5C:53A1
Label_5C_53A1::
	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jpcc from 5C:5280 (executed) | forced execution: 6/6 instruction starts ran in
	; forced_debug (traces/forced/, not natural evidence; status unchanged)
	ld bc, $1214
	ld de, $D000
	ld hl, CommErr_Tilemap_Plain
	ld a, $5C
	farcall Tilemap_CopyRectAndAttr
	ret

CommErr_DrawErrorNumber:: ; 5C:53B3
Function_5C_53B3::
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wCommErrCategory]
	ld d, a
	swap a
	and a, $0F
	ld hl, $D00C
	call CommErr_DrawDigit
	inc hl
	ld a, d
	and a, $0F
	call CommErr_DrawDigit
	ld a, [wCommErrCategory]
	cp a, $F0
	jr nz, .l53E1
	push hl
	call CommErr_DrawFCategoryGlyph
	pop hl
.l53E1 ; 5C:53E1
	inc hl
	ld a, $1A
	ld [hl], a
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $44
	ld [hl], a
	ld a, [wCommErrCodeHi]
	ld d, a
	swap a
	and a, $0F
	ld hl, $D00F
	ld b, a
	ld a, [wCommErrCategory]
	cp a, $40
	jr nz, .l5407

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 5C:5401 (executed) [executed in 1 scenarios]
	ld a, b
	call CommErr_DrawDigit

.l5407 ; 5C:5407
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 3/18 scenarios)
	inc hl
	ld a, d
	and a, $0F
	call CommErr_DrawDigit
	inc hl
	ld a, [wCommErrCodeLo]
	ld d, a
	swap a
	and a, $0F
	call CommErr_DrawDigit
	inc hl
	ld a, d
	and a, $0F
	call CommErr_DrawDigit
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D40C
	ld bc, $0208
	ld de, $F008
	ld a, $07
	farcall Tilemap_ApplyMaskRect
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

CommErr_DrawDigit:: ; 5C:5441
	push hl
	add a, a
	ld bc, CommErr_DigitTilePairs
	add a, c
	ld c, a
	ld a, b
	adc a, $00
	ld b, a
	ld a, [bc]
	inc bc
	ld [hl], a
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [bc]
	ld [hl], a
	pop hl
	ret

; ---- data $545B-$546F (20 bytes) [PROBABLE] 20 bytes = 10 pairs of tile numbers ($27,$37 ; $28,$38 ; ... $2F,$3F ; $40,$50) for the digits 0-9 (two-tile-high glyphs): read by the code at 5C:5440-5455 (ld bc,$545B ; add hl,bc, 2 bytes per digit); the first 10 bytes are CONFIRMED read data

CommErr_DigitTilePairs:: ; 5C:545B
Table_5C_545B::
	db $27, $37, $28, $38, $29, $39, $2A, $3A, $2B, $3B, $2C, $3C, $2D, $3D, $2E, $3E
	db $2F, $3F, $40, $50

CommErr_UpdateCommFooter:: ; 5C:546F
Function_5C_546F::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, .l54A5

	; [PROBABLE] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 0;
	; fall-through of the jrcc at 5C:5474 (executed)
	ld a, $BE
	ld [wCommErr_AttrSrc], a
	ld a, $57
	ld [wCommErr_AttrSrcHi], a
	ld bc, $0214
	ld de, $D200
	ld hl, $5656
	ld a, $5C
	farcall Tilemap_CopyRectAndAttrPtr
	ld de, $80A0
	ld hl, $DA10
	call Sprite_SetPosition
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, $00
	ld [wCommErr_TimerVariantFlag], a
	ret

.l54A5 ; 5C:54A5
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l54EB
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .l54EC
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l54EB

	; [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; fall-through of the jrcc at 5C:54BC (executed)
	jr nz, .l54C7
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l54EB
.l54C7 ; 5C:54C7
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l54D7
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .l54EB
	set 1, [hl]
.l54D7 ; 5C:54D7
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .l54EC
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l54EC

.l54EB ; 5C:54EB
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	xor a, a
.l54EC ; 5C:54EC
	pop hl
	or a, a
	ret z

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the retcc at 5C:54EE (executed)
	ld hl, wTimerAWarnFlags
	res 0, [hl]
	farcall CommNotice_ShowDialog
	pop bc
	push af
	farcall Palette_FadeOutToWhite
	pop af
	ret

CommErr_DrawFCategoryGlyph:: ; 5C:5504
Function_5C_5504::
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $40
	ld hl, $D00C
	ld [hli], a
	inc a
	ld [hl], a
	ld bc, $001F
	add hl, bc
	add a, $0F
	ld [hli], a
	inc a
	ld [hl], a
	ret
