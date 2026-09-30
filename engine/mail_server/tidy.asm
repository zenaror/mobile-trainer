; engine/mail_server/tidy.asm
; bank 2E, $4000-$4B2E (2862 bytes); pinned by layout.link
; mail-server tidy-up: run loop (fetch each mail, delete/next/stop)

SECTION "engine/mail_server/tidy", ROMX

MailServerMgr_Run:: ; 2E:4000
Function_2E_4000::
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailServerMgr_SetupScreen
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	call MailServerMgr_ShowLoadingMsg
	ld hl, $DAD0
	ld de, $7700
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DAD0
	call Sprite_SetPosition
	farcall Timer_ResetClockB
	farcall Pop3_StartLogin
.l4067 ; 2E:4067
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	ldh a, [hJoyHeld]
	and a, $02
	jp nz, Label_2E_4A47
	farcall Pop3_LoginStatPoll
	cp a, $01
	jr z, .l4067
	cp a, $FF
	jr nz, .l4099

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2E:408E (executed) [executed in 1 scenarios]
	farcall MailSession_ShowCommError
	ld a, $80
	ret

.l4099 ; 2E:4099
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios)
	push bc
	push de
	push hl
	ld de, $9401
	ld hl, Gfx_MailServerMgr_Tiles1
	ld a, $2E
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	pop hl
	pop de
	pop bc
	ld d, h
	ld e, l
	push de
	ld a, d
	or a, e
	jp z, .l417F

	; [CONFIRMED] 104 insn(s) reached by static flow only; seeds: exec x104; min discovery hops 0;
	; fall-through of the jpcc at 2E:40B6 (executed) | 16 insn(s) executed; cut out of the PROBABLE
	; region 40B9-417F by apply_coverage --split [executed in 8 scenarios]
	ld bc, $0000
	ld hl, $0001
.l40BF ; 2E:40BF
	push bc
	push hl
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l4107
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l4108
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l4107

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40B9-417F by apply_coverage --split
	jr nz, .l40E3
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l4107
.l40E3 ; 2E:40E3
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l40F3
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l4107
	set 1, [hl]
.l40F3 ; 2E:40F3
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l4108
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l4108

.l4107 ; 2E:4107
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 40B9-417F by apply_coverage
	; --split [executed in 8 scenarios]
	xor a, a
.l4108 ; 2E:4108
	pop hl
	cp a, $00
	call nz, MailServerMgr_TimeWarningPopup
	pop hl
	pop bc
	push bc
	push de
	push hl
	ld c, $00
	farcall Timer_ResetClockB
	xor a, a
	farcall Pop3_StartTop
	pop hl
	pop de
	pop bc
.l4125 ; 2E:4125
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	call MailServerMgr_UpdateTimerDisplay
	farcall Joypad_Update
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l4149

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40B9-417F by apply_coverage --split
	pop de
	jp Label_2E_4A47

.l4149 ; 2E:4149
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 40B9-417F by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	push hl
	xor a, a
	farcall Pop3_TopPoll
	cp a, $01
	jr nz, .l415C
	pop hl
	pop de
	pop bc
	jr .l4125
.l415C ; 2E:415C
	cp a, $FF
	jr nz, .l416D
	pop hl
	pop de
	pop bc
	farcall MailSession_ShowCommError

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40B9-417F by apply_coverage --split
	pop de
	ld a, $80
	ret

.l416D ; 2E:416D
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 40B9-417F by apply_coverage
	; --split [executed in 8 scenarios]
	ld a, b
	pop hl
	pop de
	pop bc
	cp a, $02
	jr nz, .l4176

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40B9-417F by apply_coverage --split
	inc bc

.l4176 ; 2E:4176
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 40B9-417F by apply_coverage
	; --split [executed in 7 scenarios]
	inc hl
	dec de
	ld a, d
	or a, e
	jp nz, .l40BF
	ld e, c
	ld d, b

.l417F ; 2E:417F
	; [CONFIRMED] 139 insn(s); 139 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D62F
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	xor a, a
	ld [hli], a
	ld [hli], a
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D633
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D62F
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld e, l
	ld d, h
	ld a, d
	or a, e
	jp nz, .l4292
	ld hl, $0000
	ld a, $05
	farcall SpriteCounter_StubA
	ld hl, $0000
	ld a, $04
	farcall SpriteCounter_StubB
	call MailServerMgr_ClearTextTiles
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_Main
	ld a, $2E
	farcall Tilemap_CopyRectAndAttr
	call MailServerMgr_UpdateTimerDisplay
	ld de, $0228
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Open
	ld a, $78
.l4241 ; 2E:4241
	push af
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l4255
	pop af
	ld a, $01
	push af
.l4255 ; 2E:4255
	pop af
	dec a
	jr nz, .l4241
	farcall Dialog_Close
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	call MailServerMgr_UpdateTimerDisplay
	ld a, $01
.l4279 ; 2E:4279
	push af
	call VBlank_Wait
	pop af
	dec a
	jr nz, .l4279
	call MailServerMgr_UpdateTimerDisplay
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.l4292 ; 2E:4292
	; [CONFIRMED] 762 insn(s) reached by static flow only; seeds: exec x762; min discovery hops 5;
	; entered by jpcc from 2E:41E2 (executed) | 89 insn(s) executed; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split [executed in 1 scenarios]
	ld bc, $0000
	ld hl, $0000

Label_2E_4298:: ; 2E:4298
	push bc
	push hl
	push hl
	push bc
	ld l, c
	ld h, b
	ld a, $05
	farcall SpriteCounter_StubC
	pop bc
	pop hl
	ld a, b
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, c
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	ld h, a
	ld a, $04
	farcall SpriteCounter_StubB
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	pop hl
	pop bc
	push bc
	push hl
	push hl
	pop hl
	push hl
	inc hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D631
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc bc
	add hl, bc
	ld a, $B8
	call MailServerMgr_DrawMailNumber
	pop hl
	inc hl
	farcall Timer_ResetClockB
	xor a, a
	ld c, $01
	farcall Pop3_StartTop
.l430D ; 2E:430D
	push bc
	push de
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	pop hl
	pop de
	pop bc
	ldh a, [hJoyHeld]
	and a, $02
	jr z, .l4332
	pop hl
	pop bc
	jp Label_2E_4A47
.l4332 ; 2E:4332
	xor a, a
	farcall Pop3_TopPoll
	cp a, $01
	jr z, .l430D
	cp a, $FF
	jr nz, .l434C

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	pop hl
	pop bc
	farcall MailSession_ShowCommError
	ld a, $80
	ret

.l434C ; 2E:434C
	; [CONFIRMED] 44 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, b
	ld d, c
	ld e, b
	pop hl
	pop bc
	inc hl
	push bc
	push hl
	push de
	push bc
	push hl
	push af
	ld de, $B000
	ld hl, $DAD0
	call Sprite_SetPosition
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	pop af
	pop hl
	pop bc
	pop de
	push af
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D627
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	pop de
	pop af
	pop hl
	pop bc
	push bc
	push hl
	cp a, $00
	jr z, .l43AF
	cp a, $01
	jr z, .l43AF

	; [PROBABLE] 23 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	cp a, $02
	jr z, .l4394
.l4392 ; 2E:4392
	jr .l4392
.l4394 ; 2E:4394
	pop hl
	pop bc
	push bc
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D631
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	inc bc
	ld a, b
	ld [hld], a
	ld a, c
	ld [hl], a
	pop hl
	pop bc
	jp .l477E

.l43AF ; 2E:43AF
	; [CONFIRMED] 101 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 7 scenarios]
	push af
	push bc
	push de
	push hl
	ld b, h
	ld c, l
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D635
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hl], a
	pop hl
	pop de
	pop bc
	pop af
	push af
	call MailServerMgr_DrawMailInfo
	pop af
	dec a
	call MailServerMgr_DrawMailDate
	call MailServerMgr_DrawMailFields
	pop hl
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D631
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc bc
	add hl, bc
	ld a, $B8
	call MailServerMgr_DrawMailNumber
	pop hl
	pop bc
	push bc
	push hl
	push hl
	ld l, c
	ld h, b
	ld a, $05
	farcall SpriteCounter_StubC
	pop hl
	ld a, h
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	ld h, a
	ld a, $04
	farcall SpriteCounter_StubB
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	pop hl
	pop bc
	push bc
	push hl
	ld hl, $DA00
	ld de, Table_MailServerMgr_ObjAnims
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7010
	ld hl, $DA00
	call Sprite_SetPosition
	ld a, $00
	call MailServerMgr_ShowChoiceHelp
	ld c, $00
.l4458 ; 2E:4458
	push bc
	di
	farcall Sprite_UpdateAll
	ei
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .l447A

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	farcall Mobile_FetchResult
	farcall MailSession_ShowCommError
	pop bc
	pop hl
	pop bc
	ld a, $80
	ret

.l447A ; 2E:447A
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 1 scenarios]
	call MailServerMgr_UpdateTimerDisplay
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l44C3
	ld hl, $C26F
	bit 0, [hl]
	jr nz, .l44C4
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .l44C3
	jr nz, .l449F
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .l44C3
.l449F ; 2E:449F
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .l44AF

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	ld hl, $C26F
	bit 1, [hl]
	jr nz, .l44C3
	set 1, [hl]

.l44AF ; 2E:44AF
	; [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, .l44C4
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .l44C4
.l44C3 ; 2E:44C3
	xor a, a
.l44C4 ; 2E:44C4
	pop hl
	cp a, $00
	call nz, MailServerMgr_TimeWarningPopupRedraw
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, .l44F6
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	ld a, c
	cp a, $FF
	jr nz, .l44F6
	ld c, $02
.l44F6 ; 2E:44F6
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, .l4518
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	ld a, c
	cp a, $03
	jr nz, .l4518

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	ld c, $00

.l4518 ; 2E:4518
	; [CONFIRMED] 244 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hJoyHeld]
	and a, $FF
	jp z, .l4458
	ld a, c
	cp a, $00
	jr nz, .l4544
	push bc
	ld hl, $DA00
	ld de, Table_MailServerMgr_ObjAnims
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7010
	ld hl, $DA00
	call Sprite_SetPosition
	ld a, $00
	call MailServerMgr_ShowChoiceHelp
	pop bc
.l4544 ; 2E:4544
	ld a, c
	cp a, $01
	jr nz, .l4569
	push bc
	ld hl, $DA00
	ld de, $76D0
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7030
	ld hl, $DA00
	call Sprite_SetPosition
	ld a, $01
	call MailServerMgr_ShowChoiceHelp
	pop bc
.l4569 ; 2E:4569
	ld a, c
	cp a, $02
	jr nz, .l458E
	push bc
	ld hl, $DA00
	ld de, $76E0
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7050
	ld hl, $DA00
	call Sprite_SetPosition
	ld a, $02
	call MailServerMgr_ShowChoiceHelp
	pop bc
.l458E ; 2E:458E
	ldh a, [hJoyPressed]
	and a, $01
	jp z, .l4458
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	pop hl
	pop bc
	cp a, $00
	jp z, .l467A
	cp a, $01
	jp z, .l4736
	push bc
	push hl
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	ld de, $022A
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop hl
	pop bc
	dec a
	jp nz, .l4611
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4611 ; 2E:4611
	push bc
	push hl
	push hl
	ld l, c
	ld h, b
	ld a, $05
	farcall SpriteCounter_StubC
	pop hl
	ld a, h
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $04
	farcall SpriteCounter_StubB
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	pop hl
	pop bc
	push bc
	push hl
	ld hl, $DA00
	ld de, $76E0
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7050
	ld hl, $DA00
	call Sprite_SetPosition
	ld a, $02
	call MailServerMgr_ShowChoiceHelp
	ld c, $02
	jp .l4458
.l467A ; 2E:467A
	push bc
	push hl
	ld de, $D010
	ld hl, $DA00
	call Sprite_SetPosition
	pop hl
	pop bc
	push bc
	push hl
	call MailServerMgr_ClearTextTiles
	ld bc, $0614
	ld de, $D0A0
	ld hl, Tilemap_MailServerMgr_Footer
	ld a, $2E
	farcall Tilemap_CopyRectAndAttr
	di
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ei
	ld hl, $DAD0
	ld de, $76F0
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DAD0
	call Sprite_SetPosition
	call MailServerMgr_ShowDeletingMsg
	pop hl
	pop bc
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	inc de
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	dec de
	dec bc
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	pop bc
	push bc
	push hl
	farcall Timer_ResetClockB
	xor a, a
	farcall Pop3_StartDele
.l46F8 ; 2E:46F8
	call VBlank_Wait
	di
	farcall Sprite_UpdateAll
	ei
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4717
	pop hl
	pop bc
	jp Label_2E_4A47
.l4717 ; 2E:4717
	xor a, a
	farcall Pop3_DelePoll
	cp a, $01
	jr z, .l46F8
	cp a, $FF
	jr nz, .l4731

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	farcall MailSession_ShowCommError
	pop hl
	pop bc
	ld a, $80
	ret

.l4731 ; 2E:4731
	; [CONFIRMED] 138 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 1 scenarios]
	pop hl
	pop bc
	jp .l477E
.l4736 ; 2E:4736
	push bc
	push hl
	ld de, $D010
	ld hl, $DA00
	call Sprite_SetPosition
	pop hl
	pop bc
	push bc
	push hl
	call MailServerMgr_ClearTextTiles
	ld bc, $0614
	ld de, $D0A0
	ld hl, Tilemap_MailServerMgr_Footer
	ld a, $2E
	farcall Tilemap_CopyRectAndAttr
	di
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ei
	ld hl, $DAD0
	ld de, $7700
	ld a, $2E
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, $DAD0
	call Sprite_SetPosition
	call MailServerMgr_ShowLoadingMsg
	pop hl
	pop bc
.l477E ; 2E:477E
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D633
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	dec de
	dec bc
	ld a, c
	ld [de], a
	inc de
	ld a, b
	ld [de], a
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D633
	ld a, [de]
	cp a, $00
	jp nz, .l4887
	inc de
	ld a, [de]
	cp a, $00
	inc de
	jp nz, .l4887
	call MailServerMgr_ClearTextTiles
	push af
	push bc
	push de
	push hl
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	call MailServerMgr_UpdateTimerDisplay
	pop hl
	pop de
	pop bc
	pop af
	push hl
	ld l, c
	ld h, b
	ld a, $05
	farcall SpriteCounter_StubC
	pop hl
	ld a, h
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, a
	inc bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, $04
	farcall SpriteCounter_StubB
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	call MailServerMgr_UpdateTimerDisplay
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_Main
	ld a, $2E
	farcall Tilemap_CopyRectAndAttr
	call MailServerMgr_DrawTimer
	ld de, $0229
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Open
	ld a, $78
.l4843 ; 2E:4843
	push af
	call VBlank_WaitAndService
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .skip

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4292-488A by apply_coverage --split
	pop af
	ld a, $01
	push af

.skip ; 2E:4857
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4292-488A by apply_coverage
	; --split [executed in 1 scenarios]
	pop af
	dec a
	jr nz, .l4843
	farcall Dialog_Close
	call MailServerMgr_DrawTimer
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4887 ; 2E:4887
	jp Label_2E_4298

	; [HYPOTHESIS] function prologue push af/bc/de/hl right after the unconditional jp $4298 at 4887
	; and directly before the far-call site region at 488E; the matching pop sequence was not
	; proven, no caller/pointer found, entry unproven
	push af
	push bc
	push de
	push hl

	; [PROBABLE] 298 insn(s) reached by static flow only; seeds: exec x130, site x168; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 195 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 488E-4B2E by apply_coverage --split
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, .l48EE
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailServerMgr_SetupScreen
	call MailServerMgr_ShowLoadingMsg
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret
.l48EE ; 2E:48EE
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	ld a, $80
	ret

MailServerMgr_TimeWarningPopup:: ; 2E:48F8
Function_2E_48F8::
	push af
	push bc
	push de
	push hl
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	inc a
	jr z, .l495C
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailServerMgr_SetupScreen
	call MailServerMgr_ShowLoadingMsg
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret
.l495C ; 2E:495C
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop hl
	pop bc
	pop de
	ld a, $80
	ret

	farcall Timer_ResetClockB
	ld de, $C0A9
	farcall CommNotice_ShowDialogMode0
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret
.l4988 ; 2E:4988
	push hl
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	pop hl
	inc hl
	ld a, $B8
	call MailServerMgr_DrawMailNumber
	jr .l4988

	farcall Timer_ResetClockB
	xor a, a
	farcall Pop3_StartDele
.l49AA ; 2E:49AA
	di
	farcall Sprite_UpdateAll
	ei
	call VBlank_Wait
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l49DA
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D629
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	jp Label_2E_4A47
.l49DA ; 2E:49DA
	xor a, a
	farcall Pop3_DelePoll
	cp a, $01
	jr z, .l49AA
	cp a, $FF
	jr nz, .l49F2
	farcall MailSession_ShowCommError
	ld a, $80
	ret
.l49F2 ; 2E:49F2
	pop hl
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D627
	ld a, l
	ld [bc], a
	inc bc
	ld a, h
	ld [bc], a
	inc bc
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	dec bc
	dec de
	ld a, e
	ld [bc], a
	inc bc
	ld a, d
	ld [bc], a
	pop hl
	ld a, d
	or a, e
	jp nz, Label_2E_4298
	call $58C4
	ld hl, $0000
	call $5FA2
	di
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	ei
	call $6DD0
	ld a, $78
.l4A31 ; 2E:4A31
	push af
	call VBlank_Wait
	pop af
	dec a
	jr nz, .l4A31
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Label_2E_4A47:: ; 2E:4A47
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 488E-4B2E by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $04
	call MailServerMgr_ShowChoiceHelp
	ld a, $78
	ld a, $01
.loop ; 2E:4A50
	push af
	call VBlank_Wait
	pop af
	dec a
	jr nz, .loop
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $D625
	ld a, $FF
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	inc bc
	ld [bc], a
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

MailServerMgr_TimeWarningPopupRedraw:: ; 2E:4A7D
Function_2E_4A7D::
	push af
	push bc
	push de
	push hl
	push bc
	farcall Sprites_SaveSlotsToBank3
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeOutToWhite
	pop af
	pop bc
	inc a
	jr z, .l4AE2

	; [PROBABLE] 24 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 488E-4B2E by apply_coverage --split
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop bc
	call MailServerMgr_RedrawScreen
	farcall Sprites_RestoreSlotsFromBank3
	pop hl
	pop de
	pop bc
	pop af
	ret

.l4AE2 ; 2E:4AE2
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 488E-4B2E by apply_coverage
	; --split [executed in 1 scenarios]
	pop hl
	pop de
	pop bc
	pop af
	pop af
	pop bc
	pop hl
	pop bc
	ld a, $80
	ret

	; [PROBABLE] 22 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 488E-4B2E by apply_coverage --split
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	farcall CommNotice_ShowDialogMode1
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $80
	ret
