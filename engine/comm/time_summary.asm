; engine/comm/time_summary.asm
; bank 51, $4000-$42A0 (672 bytes); pinned by layout.link
; connection-time summary screen and comm timer helpers

SECTION "engine/comm/time_summary", ROMX

CommTime_ShowSummary:: ; 51:4000
	; [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by far from 24:4168 (PROBABLE code) [executed in 4 scenarios]
	call CommTime_DrawSummaryScreen
	call CommTime_AddTimerA
	ldh a, [hRam_FFB0]
	ld [wCommTimeTotal], a
	ldh a, [hRam_FFB1]
	ld [wCommTimeTotal + 1], a
	ldh a, [hRam_FFB2]
	ld [wCommTimeTotal + 2], a
	xor a, a
	ld [wTimerAFrames], a
	ld [wTimerASeconds], a
	ld [wTimerAMinutes], a
	ld [wTimerAExtra], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sCommTimeTotal
	ld a, [wCommTimeTotal]
	ld [hli], a
	ld a, [wCommTimeTotal + 1]
	ld [hli], a
	ld a, [wCommTimeTotal + 2]
	ld [hli], a
	ld a, [wCommTimeTotal + 3]
	ld [hli], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

CommTime_DrawSummaryScreen:: ; 51:404A
Function_51_404A::
	; [CONFIRMED] 42 insn(s); 42 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	call LCDOff
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
	call LCDOn
	call CommTime_TimerAIsNonZero
	or a, a
	jp z, CommTime_Summary_Exit
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l40BF
	ld de, $9001
	ld hl, Gfx_CommTime_SummaryB_Tiles9000Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_CommTime_SummaryB_Tiles9400Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_CommTime_SummaryB
	ld a, $51
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_CommTime_SummaryB
	ld a, $51
	farcall Tilemap_CopyRectAndAttr
	jr .l4105

.l40BF ; 51:40BF
	; [CONFIRMED] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by jrcc from 51:4075 (executed) [executed in 1 scenarios]
	ld de, $9001
	ld hl, Gfx_CommTime_SummaryA_Tiles9000Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_CommTime_SummaryA_Tiles9400Vb1
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_CommTime_SummaryA
	ld a, $51
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_CommTime_SummaryA
	ld a, $51
	farcall Tilemap_CopyRectAndAttr

.l4105 ; 51:4105
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	ld a, [wTimerAMinutes]
	ld l, a
	ld h, $00
	cp a, $3C
	ld a, [wTimerASeconds]
	jr c, .skip

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 51:4110 (executed)
	ld hl, $003B
	ld a, $3B

.skip ; 51:4117
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	ldh [hRam_FFB1], a
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l4125
	ld de, wScreenTileMap + $162
	jr .l4128

.l4125 ; 51:4125
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 51:411E (executed) [executed in 1 scenarios]
	ld de, wScreenTileMap + $162

.l4128 ; 51:4128
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FF9C
	call CommTime_DrawNumber
	ld bc, $FFF6
	call CommTime_DrawNumber
	ld a, l
	call CommTime_PutDigit
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l4147
	ld de, wScreenTileMap + $167
	jr .l414A

.l4147 ; 51:4147
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 51:4140 (executed) [executed in 1 scenarios]
	ld de, wScreenTileMap + $167

.l414A ; 51:414A
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 2/18 scenarios)
	ldh a, [hRam_FFB1]
	ld l, a
	ld h, $00
	xor a, a
	ldh [hRam_FFB4], a
	ld bc, $FFF6
	call CommTime_DrawNumber
	ld a, l
	call CommTime_PutDigit
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l4186
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000D
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	jr .l4196

.l4186 ; 51:4186
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 51:4172 (executed) [executed in 1 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000D
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

.l4196 ; 51:4196
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	xor a, a
	ldh [hDialogResult], a

CommTime_Summary_FrameLoop:: ; 51:4199
Label_51_4199::
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41B1-$41BB (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 51:41AE: 5 entries; fixed length (5 words) by the routine

CommTime_SummaryInputTable:: ; 51:41B1
Table_51_41B1::
	dw CommTime_SummaryInput_ButtonA
	dw CommTime_SummaryInput_IgnoreB
	dw CommTime_SummaryInput_IgnoreSelect
	dw CommTime_SummaryInput_IgnoreStart
	dw CommTime_Summary_FrameLoop

CommTime_SummaryInput_ButtonA:: ; 51:41BB
Label_51_41BB::
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 2/18 scenarios)
	jp CommTime_Summary_Close

CommTime_SummaryInput_IgnoreB:: ; 51:41BE
Label_51_41BE::
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by table from 51:41AE (executed) [executed in 2 scenarios]
	jp CommTime_Summary_FrameLoop

CommTime_SummaryInput_IgnoreSelect:: ; 51:41C1
Label_51_41C1::
	jp CommTime_Summary_FrameLoop

CommTime_SummaryInput_IgnoreStart:: ; 51:41C4
Label_51_41C4::
	jp CommTime_Summary_FrameLoop

CommTime_Summary_Close:: ; 51:41C7
Label_51_41C7::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 4/18 scenarios)
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll

CommTime_Summary_Exit:: ; 51:41D3
Label_51_41D3::
	ldh [hRam_FFA7], a
	ldh a, [hDialogResult]
	ret

CommTime_DrawNumber:: ; 51:41D8
	inc a
	add hl, bc
	bit 7, h
	jr z, CommTime_DrawNumber
	dec a
	jr nz, .l41E8
	ldh a, [hRam_FFB4]
	or a, a
	jr z, .l41F3

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 51:41E4 (executed) | 1 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 41E6-41F3 by apply_coverage --split
	ld a, $00

.l41E8 ; 51:41E8
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 41E6-41F3 by apply_coverage
	; --split [executed in 20 scenarios]
	push bc
	push hl
	call CommTime_PutDigit
	pop hl
	pop bc
	ld a, $FF
	ldh [hRam_FFB4], a

.l41F3 ; 51:41F3
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 2/18 scenarios)
	inc de
	dec bc
	ld a, c
	cpl
	ld c, a
	ld a, b
	cpl
	ld b, a
	add hl, bc
	xor a, a
	ret

CommTime_PutDigit:: ; 51:41FE
	push bc
	push de
	ld h, d
	ld l, e
	add a, a
	add a, $25
	ld e, a
	ld a, $00
	adc a, $42
	ld d, a
	ld a, [de]
	ld [hl], a
	inc de
	ld bc, $0400
	add hl, bc
	ld a, $08
	ld [hl], a
	ld bc, $FC20
	add hl, bc
	ld a, [de]
	ld [hl], a
	ld bc, $0400
	add hl, bc
	ld a, $08
	ld [hl], a
	pop de
	pop bc
	ret

; ---- data $4225-$4239 (20 bytes) [PROBABLE] byte_pair_table: 10 x 2 bytes, indexed by the code at 51:4200-4224 (de = $4225 + 2*a via add a,a / add a,$25 / adc a,$42, two ld a,[de] reads); end = start of the next function at 51:4239; meaning of the values unknown (verified structure, layout from engine code)

Table_CommTime_DigitTiles:: ; 51:4225
Data_51_4225::
	db $67, $77, $68, $78, $69, $79, $69, $6F, $6A, $7A, $6B, $7B, $6C, $7C, $6D, $7D
	db $6E, $7E, $6E, $7F

CommTime_TimerAIsNonZero:: ; 51:4239
Function_51_4239::
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	ld hl, wTimerAFrames
	ld a, [hli]
	or a, [hl]
	inc hl
	or a, [hl]
	inc hl
	or a, [hl]
	pop hl
	ret

CommTime_Reset:: ; 51:4245
	xor a, a
	ld [wCommTimeTotal], a
	ld [wCommTimeTotal + 1], a
	ld [wCommTimeTotal + 2], a
	ld [wCommTimeTotal + 3], a
	ld [wTimerAFrames], a
	ld [wTimerASeconds], a
	ld [wTimerAMinutes], a
	ld [wTimerAExtra], a
	ret

CommTime_AddTimerA:: ; 51:425F
	ld hl, wCommTimeTotal
	ld a, [wTimerAFrames]
	add a, [hl]
	ldh [hRam_FFB0], a
	sub a, $3C
	jr c, .l426F

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 51:426A (executed)
	ldh [hRam_FFB0], a
	xor a, a

.l426F ; 51:426F
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 5/18 scenarios)
	ccf
	inc hl
	ld a, [wTimerASeconds]
	adc a, [hl]
	ldh [hRam_FFB1], a
	sub a, $3C
	jr c, .l427E

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 51:4279 (executed)
	ldh [hRam_FFB1], a
	xor a, a

.l427E ; 51:427E
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 5/18 scenarios)
	ccf
	inc hl
	ld a, [wTimerAMinutes]
	adc a, [hl]
	ldh [hRam_FFB2], a
	jr c, .l428C
	cp a, $3C
	jr c, .l4292

.l428C ; 51:428C
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; entered by jrcc from 51:4286 (executed)
	ld a, $3B
	ldh [hRam_FFB2], a
	ldh [hRam_FFB1], a

.l4292 ; 51:4292
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 5/18 scenarios)
	ldh a, [hRam_FFB2]
	ld l, a
	ld h, $00
	ldh a, [hRam_FFB1]
	ret

; ---- zero $429A-$42A0 (6 bytes) [PROBABLE] 6 x 00 between the code ending at 429A (ret at 4299) and the tile block at 51:42A0 (alignment)
	ds $6, $00
