; engine/account/comm_panel.asm
; bank 68, $733C-$766E (818 bytes); pinned by layout.link
; 'connecting' communication panel

SECTION "engine/account/comm_panel", ROMX

CommPanel_WaitClose:: ; 68:733C
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 3/18 scenarios) (part of region $7313-$734D)
	ld a, $01
	farcall CommPanel_Step
	or a, a
	jr nz, CommPanel_WaitClose
	ld a, $01
	ld [wRam_C27C], a
	ret

Registration_Verify_OnTimeLimit:: ; 68:734D
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 1;
	; entered by jpcc from 68:7213 (executed)
	ld hl, $C26F
	res 0, [hl]
	ld a, $00
	ld [wRam_C1D0], a
	ld a, $01
	ld [wRam_C1D1], a
	farcall CommNotice_ShowDialog
	jr Registration_Verify_Abort

Registration_Verify_OnTimeout:: ; 68:7364
	ld a, $26
	ld [wMobileErrorCode], a
	xor a, a
	ld [wRam_C273], a
	ld [wRam_C274], a
	jr Registration_Verify_Abort

Registration_Verify_OnAdapterError:: ; 68:7372
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	call Function_68_4101
	farcall Mobile_SaveLastResult

Registration_Verify_Abort:: ; 68:737B
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l73B1
	ld a, $02
	farcall CommPanel_DrawCaption
	ld a, [wTimerEnable]
	bit 0, a
	jr z, .l7398

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 68:738F (executed)
	ld a, $34
	call MobileAPI
	jr .l739D

.l7398 ; 68:7398
	; [CONFIRMED] 69 insn(s); 69 executed (in up to 6/18 scenarios)
	ld a, $0A
	call MobileAPI
.l739D ; 68:739D
	xor a, a
	farcall CommPanel_Step
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, .l73B1
	bit 0, a
	jp nz, .l739D
.l73B1 ; 68:73B1
	call CommPanel_WaitClose
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	call Config_ClearSramMirror
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
	xor a, a
	ld [wRam_C27C], a
	ret

Function_68_73DD:: ; 68:73DD
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	call Function_00_044B
	ld hl, $FF40
	ld a, [hl]
	and a, $FB
	ld [hl], a
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ret

CommPanel_SetVariant:: ; 68:7401
	ld [wCommPanelVariant], a
	ret

CommPanel_Init:: ; 68:7405
	ld [wCommPanelPhase], a
	xor a, a
	ld [wCommPanelState], a
	ld [wCommPanelArg], a
	ld [wCommPanelBusy], a
	ret

CommPanel_Step:: ; 68:7413
	ld [wCommPanelArg], a
	ld a, $01
	ld [wCommPanelBusy], a
	farcall Joypad_Update
	call CommPanel_RunState
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wCommPanelBusy]
	ret

CommPanel_RunState:: ; 68:7431
	ld a, [wCommPanelState]
	ld hl, CommPanel_StateTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $7442-$744A (8 bytes) [CONFIRMED] code-pointer table, 4 entries: 4/4 words hit own-bank code starts (survey pointer-table extent); 4/4 targets executed; every byte read as data in a trace

CommPanel_StateTable:: ; 68:7442
Table_68_7442::
	dw CommPanel_StateDraw
	dw CommPanel_StateScreenOn
	dw CommPanel_StateWait
	dw CommPanel_StateHide

; ---- ptrtable $744A-$744C (2 bytes) [PROBABLE] little-endian word table, 5 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $744C..$7594; referenced by ld r16,$7442 at 68:7434 [clipped from 7442-744C by higher-priority evidence]

Table_68_744A:: ; 68:744A
	dw Label_68_7594

CommPanel_StateDraw:: ; 68:744C
	; [CONFIRMED] 94 insn(s); 94 executed (in up to 4/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld de, $8801
	ld hl, $4200
	ld a, $71
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $9001
	ld hl, $4490
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_71_4890
	ld a, $71
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8000
	ld hl, Data_71_4000
	ld a, $71
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, $4C50
	ld a, $71
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, $D840
	ld hl, Data_71_4C90
	ld a, $71
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_71_4C98
	ld a, $71
	farcall Function_00_08EA
	ld a, [wCommPanelPhase]
	call CommPanel_DrawCaption
	ld a, [wCommPanelPhase]
	cp a, $02
	jr z, .l74EA
	ld a, [wCommPanelVariant]
	or a, a
	jr nz, .l74FB
.l74EA ; 68:74EA
	ld bc, $0214
	ld de, $D200
	ld hl, Data_71_4F68
	ld a, $71
	farcall Function_00_08EA
.l74FB ; 68:74FB
	call CommPanel_PrintWarningText
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_71_4FB8
	ld a, $71
	ld b, $81
	farcall Function_00_0A82
	ld de, $1C14
	ld hl, $DA00
	call Function_00_0A65
	ld a, $01
	ld [wCommPanelState], a
	ret

CommPanel_StateScreenOn:: ; 68:7522
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000A
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wCommPanelState], a
	ret

CommPanel_StateWait:: ; 68:7544
	ldh a, [hJoyHeld]
	bit 1, a
	jr nz, .l755B
	ld a, [wCommPanelArg]
	or a, a
	jr z, .done
	cp a, $01
	jr z, .l7554
.l7554 ; 68:7554
	ld a, $03
	ld [wCommPanelState], a
	jr .done

.l755B ; 68:755B
	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1;
	; entered by jrcc from 68:7548 (executed) [executed in 4 scenarios]
	ld a, [wCommPanelVariant]
	or a, a
	jr z, .done
	ld a, [wCommPanelPhase]
	cp a, $02
	jr z, .done
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wCommPanelBusy], a
	ld a, $04
	ld [wCommPanelState], a

.done ; 68:7582
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 4/18 scenarios)
	ret

CommPanel_StateHide:: ; 68:7583
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	xor a, a
	ld [wCommPanelBusy], a
	ret

Label_68_7594:: ; 68:7594
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: table x8; min discovery hops 0; run
	; starts at an entry of the code-pointer table at 68:7442 [executed in 4 scenarios]
	ld a, [wCommPanelArg]
	or a, a
	jr z, .done
	cp a, $01
	jr z, .l759E
.l759E ; 68:759E
	ld a, $03
	ld [wCommPanelState], a
.done ; 68:75A3
	ret

CommPanel_PrintWarningText:: ; 68:75A4
Function_68_75A4::
	; [CONFIRMED] 77 insn(s); 77 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
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
	ld a, $03
	farcall Function_00_153D
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

CommPanel_DrawCaption:: ; 68:7611
	ld hl, CommPanel_CaptionSets
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wCommPanelVariant]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld hl, CommPanel_CaptionMaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $040C
	ld de, $D067
	ld a, $71
	farcall Function_00_08EA
	call Function_00_044B
	ldh a, [rLCDC]
	call Function_00_07CB
	ret

; ---- words $764C-$7652 (6 bytes) [PROBABLE] 3 words $7652,$7656,$765A = the starts of the three 4-byte records below

CommPanel_CaptionSets:: ; 68:764C
Table_68_764C::
	dw Data_68_7652, $7656, $765A

; ---- data $7652-$765E (12 bytes) [PROBABLE] three 4-byte records (00 00 00 00 / 02 05 06 07 / 04 04 04 04) addressed by the word table at 764C; use not decoded

Data_68_7652:: ; 68:7652
	db $00, $00, $00, $00, $02, $05, $06, $07, $04, $04, $04, $04

; ---- words $765E-$766E (16 bytes) [PROBABLE] 8 words $5038,$5098,$50F8,$5158,$51B8,$5218,$5278,$52D8 (constant stride $60), directly after the 4-byte records; targets are not in this bank; use not decoded

CommPanel_CaptionMaps:: ; 68:765E
Table_68_765E::
	dw $5038, $5098, $50F8, $5158, $51B8, $5218, $5278, $52D8
