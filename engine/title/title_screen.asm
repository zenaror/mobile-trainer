; engine/title/title_screen.asm
; bank 0E, $4000-$43C0 (960 bytes); pinned by layout.link
; Title_Run state machine, title menu, logo loader

SECTION "engine/title/title_screen", ROMX

Title_Run:: ; 0E:4000
Function_0E_4000::
	; [CONFIRMED] 70 insn(s); 70 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wTitle_Arg], a
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	ld a, [wTitle_Arg]
	or a, a
	jr nz, .l4019
	xor a, a
	ld [wTitle_State], a
	jr .l401E
.l4019 ; 0E:4019
	ld a, $03
	ld [wTitle_State], a
.l401E ; 0E:401E
	call Title_StateLoop
	ld a, [wTitle_Cursor]
	ld hl, sTitleMenuCursor
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
	ld a, [wTitle_Cursor]
	inc a
	ret

Title_StateLoop:: ; 0E:405F
	farcall Joypad_Update
	call Title_DispatchState
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wTitle_State]
	cp a, $FF
	jr nz, Title_StateLoop
	call VBlank_WaitAndService
	ld hl, rLCDC
	ld a, [hl]
	and a, $FB
	ld [hl], a
	ret

Title_DispatchState:: ; 0E:4083
	ld a, [wTitle_State]
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
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wTitle_FrameCounterHi], a
	ld [wTitle_FrameCounterLo], a
	ld a, [wTitle_State]
	inc a
	ld [wTitle_State], a
	ret

Title_StateLogoWait:: ; 0E:40CA
	ld a, [wTitle_FrameCounterHi]
	ld b, a
	ld a, [wTitle_FrameCounterLo]
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
	ld [wTitle_FrameCounterHi], a
	ld a, l
	ld [wTitle_FrameCounterLo], a
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .l40F4
	bit 3, a
	jr nz, .l40F4
	jr .done
.l40F4 ; 0E:40F4
	farcall Palette_FadeOutToWhite
	ld a, [wTitle_State]
	add a, $02
	ld [wTitle_State], a
	jr .done
.l4104 ; 0E:4104
	ld a, [wTitle_State]
	inc a
	ld [wTitle_State], a
.done ; 0E:410B
	ret

Title_StateLogoFadeOut:: ; 0E:410C
	farcall Palette_FadeOutToWhiteSlow
	ld a, [wTitle_State]
	inc a
	ld [wTitle_State], a
	ret

Title_StateLoadTitle:: ; 0E:411A
	ld hl, sTitleMenuCursor
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
	ld [wTitle_Cursor], a
	call Title_LoadTitleScreen
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0001
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wTitle_FrameCounterHi], a
	ld [wTitle_FrameCounterLo], a
	ld a, [wTitle_State]
	inc a
	ld [wTitle_State], a
	ret

Title_StateMenu:: ; 0E:417B
	ld a, [wTitle_Arg]
	or a, a
	jr nz, Title_MenuHandleButtons
	ld a, [wTitle_FrameCounterHi]
	ld b, a
	ld a, [wTitle_FrameCounterLo]
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
	ld [wTitle_FrameCounterHi], a
	ld a, l
	ld [wTitle_FrameCounterLo], a

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
	jr Title_StateMenu_Done

Title_MenuTimeout:: ; 0E:41B3
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 0E:4194 (executed)
	ld a, $06
	ld [wTitle_State], a
	jr Title_StateMenu_Done

Title_MenuToggleSelection:: ; 0E:41BA
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 14/18 scenarios)
	xor a, a
	ld [wTitle_FrameCounterHi], a
	ld [wTitle_FrameCounterLo], a
	play_sfx SFX_CURSOR_MOVE
	ld a, [wTitle_Cursor]
	xor a, $01
	ld [wTitle_Cursor], a
	call Title_PlaceCursor
	call Title_DrawMenuHighlight
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	jr Title_StateMenu_Done

Title_MenuConfirm:: ; 0E:41E6
	play_sfx SFX_CONFIRM
	ld a, [wTitle_State]
	inc a
	ld [wTitle_State], a

Title_StateMenu_Done:: ; 0E:41FD
Label_0E_41FD::
	ret

Title_StateExit:: ; 0E:41FE
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ld [wTitle_State], a
	ret

Title_StateTimeoutRestart:: ; 0E:420A
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Palette_FadeOutToWhite
	xor a, a
	ld [wTitle_State], a
	ret

Title_LoadTitleScreen:: ; 0E:4215
Function_0E_4215::
	; [CONFIRMED] 98 insn(s); 98 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	call VBlank_WaitAndService
	ld hl, rLCDC
	ld a, [hl]
	or a, $04
	ld [hl], a
	farcall Sprite_ResetAll
	ld de, $8000
	ld hl, Gfx_Title_Tiles0
	ld a, BANK(Gfx_Title_Tiles0)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, Gfx_Title_Tiles1
	ld a, BANK(Gfx_Title_Tiles1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, $49C0
	ld a, $0E
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8801
	ld hl, Gfx_Title_Tiles2
	ld a, BANK(Gfx_Title_Tiles2)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_Title_Tiles4
	ld a, BANK(Gfx_Title_Tiles4)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_Title_Tiles5
	ld a, BANK(Gfx_Title_Tiles5)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_Title_Tiles6
	ld a, BANK(Gfx_Title_Tiles6)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_Title_Bg
	ld a, BANK(Palette_Title_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_Title_Obj
	ld a, BANK(Palette_Title_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Title_Screen
	ld a, BANK(Tilemap_Title_Screen)
	farcall Tilemap_CopyRectAndAttr
	call Title_DrawMenuHighlight
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	ld hl, wSpriteSlot1
	ld de, Objects_Title
	ld a, BANK(Objects_Title)
	ld b, $81
	farcall Sprite_InitSlot
	call Title_PlaceCursor
	ld hl, wSpriteSlot2
	ld de, Objects_Title
	ld a, BANK(Objects_Title)
	ld b, $82
	farcall Sprite_InitSlot
	ld de, $0000
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	ret

Title_DrawMenuHighlight:: ; 0E:4311
	ld a, [wTitle_Cursor]
	ld de, wScreenTileMap + $185
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
	farcall Tilemap_CopyRectAndAttr
	ret

; ---- data $4330-$4334 (4 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Table_Title_HighlightTilemaps:: ; 0E:4330
Data_0E_4330::
	db $90, $5E, $E0, $5E

Title_PlaceCursor:: ; 0E:4334
Function_0E_4334::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTitle_Cursor]
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
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ret

; ---- data $434B-$434F (4 bytes) [CONFIRMED] read as data by executed code (in up to 14/18 scenarios); content class unknown

Table_Title_CursorPositions:: ; 0E:434B
Data_0E_434B::
	db $18, $60, $18, $70

Title_LoadLogoScreen:: ; 0E:434F
Function_0E_434F::
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 14/18 scenarios); entry proven: target of an
	; executed call/far call
	call VBlank_WaitAndService
	ld hl, rLCDC
	ld a, [hl]
	or a, $04
	ld [hl], a
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, Gfx_TitleLogo_Tiles0
	ld a, BANK(Gfx_TitleLogo_Tiles0)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_TitleLogo_Tiles1
	ld a, BANK(Gfx_TitleLogo_Tiles1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_TitleLogo
	ld a, BANK(Palette_TitleLogo)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_TitleLogo_Screen
	ld a, BANK(Tilemap_TitleLogo_Screen)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	farcall Sprite_UpdateAll
	ret

; ---- zero $43B1-$43C0 (15 bytes) [PROBABLE] 15 zero bytes: padding between the ret at 43B0 and the tile block at 43C0 (all bytes are $00)
	ds $F, $00
