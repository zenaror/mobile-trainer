; engine/title/title_screen.asm
; bank 0E, $4000-$43C0 (960 bytes); pinned by layout.link
; Title_Run state machine, title menu, logo loader

SECTION "engine/title/title_screen", ROMX

Title_Run:: ; 0E:4000
Function_0E_4000::
	; [CONFIRMED] 70 insn(s); 70 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wRam_C280], a
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	ld a, [wRam_C280]
	or a, a
	jr nz, .l4019
	xor a, a
	ld [wRam_C27C], a
	jr .l401E
.l4019 ; 0E:4019
	ld a, $03
	ld [wRam_C27C], a
.l401E ; 0E:401E
	call Title_StateLoop
	ld a, [wRam_C27D]
	ld hl, $BF00
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, [wRam_C27D]
	inc a
	ret

Title_StateLoop:: ; 0E:405F
	farcall Joypad_Update
	call Title_DispatchState
	farcall Function_00_0956
	call Function_00_044B
	ld a, [wRam_C27C]
	cp a, $FF
	jr nz, Title_StateLoop
	call Function_00_044B
	ld hl, $FF40
	ld a, [hl]
	and a, $FB
	ld [hl], a
	ret

Title_DispatchState:: ; 0E:4083
	ld a, [wRam_C27C]
	ld hl, Table_Title_States
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

; ---- ptrtable $4094-$40A2 (14 bytes) [PROBABLE] code-pointer table, 7 entries: 7/7 words hit own-bank code starts (survey pointer-table extent); 6/7 targets executed

Table_Title_States:: ; 0E:4094
Table_0E_4094::
	dw Title_StateLoadLogo
	dw Title_StateLogoWait
	dw Title_StateLogoFadeOut
	dw Title_StateLoadTitle
	dw Title_StateMenu
	dw Title_StateExit
	dw Title_StateTimeoutRestart

Title_StateLoadLogo:: ; 0E:40A2
	; [CONFIRMED] 114 insn(s); 114 executed (in up to 14/18 scenarios)
	call Title_LoadLogoScreen
	farcall Palette_FadeInFromWhiteSlow
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wRam_C27E], a
	ld [wRam_C27F], a
	ld a, [wRam_C27C]
	inc a
	ld [wRam_C27C], a
	ret

Title_StateLogoWait:: ; 0E:40CA
	ld a, [wRam_C27E]
	ld b, a
	ld a, [wRam_C27F]
	ld c, a
	ld h, b
	ld l, c
	ld de, $00B4
	ld a, d
	cp a, b
	jr nz, .skip
	ld a, e
	cp a, c
.skip ; 0E:40DD
	jr z, .l4104
	inc hl
	ld a, h
	ld [wRam_C27E], a
	ld a, l
	ld [wRam_C27F], a
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l40F4
	bit 3, a
	jr nz, .l40F4
	jr .done
.l40F4 ; 0E:40F4
	farcall Palette_FadeOutToWhite
	ld a, [wRam_C27C]
	add a, $02
	ld [wRam_C27C], a
	jr .done
.l4104 ; 0E:4104
	ld a, [wRam_C27C]
	inc a
	ld [wRam_C27C], a
.done ; 0E:410B
	ret

Title_StateLogoFadeOut:: ; 0E:410C
	farcall Palette_FadeOutToWhiteSlow
	ld a, [wRam_C27C]
	inc a
	ld [wRam_C27C], a
	ret

Title_StateLoadTitle:: ; 0E:411A
	ld hl, $BF00
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hl]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	ld [wRam_C27D], a
	call Title_LoadTitleScreen
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0001
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wRam_C27E], a
	ld [wRam_C27F], a
	ld a, [wRam_C27C]
	inc a
	ld [wRam_C27C], a
	ret

Title_StateMenu:: ; 0E:417B
	ld a, [wRam_C280]
	or a, a
	jr nz, Title_MenuHandleButtons
	ld a, [wRam_C27E]
	ld b, a
	ld a, [wRam_C27F]
	ld c, a
	ld h, b
	ld l, c
	ld de, $2A30
	ld a, d
	cp a, b
	jr nz, .skip

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 0E:4190 (executed)
	ld a, e
	cp a, c

.skip ; 0E:4194
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 14/18 scenarios)
	jr z, Title_MenuTimeout
	inc hl
	ld a, h
	ld [wRam_C27E], a
	ld a, l
	ld [wRam_C27F], a

Title_MenuHandleButtons:: ; 0E:419F
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Title_MenuConfirm
	bit 3, a
	jr nz, Title_MenuConfirm
	bit 6, a
	jr nz, Title_MenuToggleSelection
	bit 7, a
	jr nz, Title_MenuToggleSelection
	jr Label_0E_41FD

Title_MenuTimeout:: ; 0E:41B3
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 0E:4194 (executed)
	ld a, $06
	ld [wRam_C27C], a
	jr Label_0E_41FD

Title_MenuToggleSelection:: ; 0E:41BA
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 14/18 scenarios)
	xor a, a
	ld [wRam_C27E], a
	ld [wRam_C27F], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	xor a, $01
	ld [wRam_C27D], a
	call Title_PlaceCursor
	call Title_DrawMenuHighlight
	ldh a, [rLCDC]
	call Function_00_07CB
	jr Label_0E_41FD

Title_MenuConfirm:: ; 0E:41E6
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27C]
	inc a
	ld [wRam_C27C], a

Label_0E_41FD:: ; 0E:41FD
	ret

Title_StateExit:: ; 0E:41FE
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ld [wRam_C27C], a
	ret

Title_StateTimeoutRestart:: ; 0E:420A
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_FadeOutToWhite
	xor a, a
	ld [wRam_C27C], a
	ret

Title_LoadTitleScreen:: ; 0E:4215
Function_0E_4215::
	; [CONFIRMED] 98 insn(s); 98 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	call Function_00_044B
	ld hl, $FF40
	ld a, [hl]
	or a, $04
	ld [hl], a
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Gfx_Title_Tiles0
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, Gfx_Title_Tiles1
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8001
	ld hl, $49C0
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8801
	ld hl, Gfx_Title_Tiles2
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, Gfx_Title_Tiles4
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, Gfx_Title_Tiles5
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_Title_Tiles6
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_Title_Bg
	ld a, $0E
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $5F70
	ld a, $0E
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_Title_Screen
	ld a, $0E
	farcall Function_00_08EA
	call Title_DrawMenuHighlight
	ldh a, [rLCDC]
	call Function_00_07CB
	ld hl, $DA10
	ld de, $5FB0
	ld a, $0E
	ld b, $81
	farcall Function_00_0A82
	call Title_PlaceCursor
	ld hl, $DA20
	ld de, $5FB0
	ld a, $0E
	ld b, $82
	farcall Function_00_0A82
	ld de, $0000
	ld hl, $DA20
	call Function_00_0A65
	farcall Function_00_0956
	ret

Title_DrawMenuHighlight:: ; 0E:4311
	ld a, [wRam_C27D]
	ld de, $D185
	ld bc, $040A
	ld hl, Table_Title_HighlightTilemaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $0E
	farcall Function_00_08EA
	ret

; ---- data $4330-$4334 (4 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Table_Title_HighlightTilemaps:: ; 0E:4330
Data_0E_4330::
	db $90, $5E, $E0, $5E

Title_PlaceCursor:: ; 0E:4334
Function_0E_4334::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C27D]
	ld hl, Table_Title_CursorPositions
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $DA10
	call Function_00_0A65
	ret

; ---- data $434B-$434F (4 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Table_Title_CursorPositions:: ; 0E:434B
Data_0E_434B::
	db $18, $60, $18, $70

Title_LoadLogoScreen:: ; 0E:434F
Function_0E_434F::
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	call Function_00_044B
	ld hl, $FF40
	ld a, [hl]
	or a, $04
	ld [hl], a
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Gfx_TitleLogo_Tiles0
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_TitleLogo_Tiles1
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_TitleLogo
	ld a, $0E
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_TitleLogo_Screen
	ld a, $0E
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_07CB
	farcall Function_00_0956
	ret

; ---- zero $43B1-$43C0 (15 bytes) [PROBABLE] 15 zero bytes: padding between the ret at 43B0 and the tile block at 43C0 (all bytes are $00)
	ds $F, $00
