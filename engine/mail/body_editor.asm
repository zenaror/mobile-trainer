; engine/mail/body_editor.asm
; bank 2D, $4722-$5AC0 (5022 bytes); pinned by layout.link
; mail body editor with kana keyboard, text-tile buffer helpers

SECTION "engine/mail/body_editor", ROMX

MailBody_Edit:: ; 2D:4722
Function_2D_4722::
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 2/18 scenarios); entry proven: target of an
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call MailBody_SetupScreen
	call Function_2D_4F03
	ld d, $07
.l474A ; 2D:474A
	push de
	call MailBody_CursorDownStep
	pop de
	dec d
	jr nz, .l474A
	ld d, $18
.l4754 ; 2D:4754
	push de
	call MailBody_CursorRightStep
	pop de
	dec d
	jr nz, .l4754
.l475C ; 2D:475C
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call MailBody_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, .l4868
	call MailBody_KeyboardLoop

.l477A ; 2D:477A
	; [CONFIRMED] 107 insn(s) reached by static flow only; seeds: exec x107; min discovery hops 0;
	; fall-through of the call at 2D:4777 (executed) | 2 insn(s) executed; cut out of the PROBABLE
	; region 477A-485F by apply_coverage --split [executed in 3 scenarios]
	cp a, $06
	jp nz, .l47F3

	; [PROBABLE] 58 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l4791
	ld de, $0200
	jr .l479C
.l4791 ; 2D:4791
	dec a
	jr nz, .l4799
	ld de, $0211
	jr .l479C
.l4799 ; 2D:4799
	ld de, $020F
.l479C ; 2D:479C
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
	pop bc
	dec a
	jp nz, .l4862
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l47E0
	jr .l47E5
.l47E0 ; 2D:47E0
	dec a
	jr nz, .l47E5
	jr .l47E5
.l47E5 ; 2D:47E5
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

.l47F3 ; 2D:47F3
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 477A-485F by apply_coverage
	; --split [executed in 3 scenarios]
	cp a, $04
	jr nz, .l4847

	; [PROBABLE] 38 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	push bc
	ld de, $0202
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
	pop bc
	dec a
	jr nz, .l4862
	farcall MailDraft_SaveToSram
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ld a, $01
	ret

.l4847 ; 2D:4847
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 477A-485F by apply_coverage
	; --split [executed in 3 scenarios]
	cp a, $05
	jp nz, .l475C

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 477A-485F by apply_coverage --split
	farcall Palette_FadeOutToWhite
	ld a, $B0
	ldh [rWX], a
	farcall MailBody_ViewScreen
	jp MailBody_Edit

	; [PROBABLE] fall-through of the preceding PROBABLE code region (ld [hli],a ; ld b,a ends
	; without a terminator): jp $475C
	jp .l475C

.l4862 ; 2D:4862
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 2;
	; entered by jpcc from 2D:47CF (PROBABLE code)
	call MailBody_KeyboardLoop
	jp .l477A

.l4868 ; 2D:4868
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4894
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l4894 ; 2D:4894
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, MailBody_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, MailBody_CursorRight
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, MailBody_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, MailBody_CursorDown
	jp .l475C

MailBody_CursorLeft:: ; 2D:48B3
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	dec c
	jr nz, .l48D4
	inc b
	dec b
	ret z

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the retcc at 2D:48CD (executed) | 4 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 48CE-48DA by apply_coverage --split
	dec b
	call MailBody_GetCharPtr
	ld c, e
	ret

.l48D4 ; 2D:48D4
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 48CE-48DA by apply_coverage
	; --split [executed in 1 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailBody_CursorRight:: ; 2D:48DA
Function_2D_48DA::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

MailBody_CursorRightStep:: ; 2D:48EE
	ld a, b
	cp a, $07
	jr nz, .l490E

	; [PROBABLE] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 2D:48F1 (executed)
	ld a, c
	cp a, $0C
	ret z
	cp a, $0B
	jr nz, .l490E
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.l490E ; 2D:490E
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	inc c
	dec c
	jr nz, .l491F
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

.l491F ; 2D:491F
	; [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0;
	; entered by jrcc from 2D:4910 (executed) | 5 insn(s) executed; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split [executed in 2 scenarios]
	call MailBody_GetCharPtr
	cp a, $FF
	ret z
	cp a, $0D
	jr nz, .l4931

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.l4931 ; 2D:4931
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 491F-4942 by apply_coverage
	; --split [executed in 2 scenarios]
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	ret nz

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 491F-4942 by apply_coverage --split
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailBody_CursorUp:: ; 2D:4942
Function_2D_4942::
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc b
	dec b
	jr nz, .l495B
	ret

.l495B ; 2D:495B
	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 1;
	; entered by jrcc from 2D:4958 (executed) | 6 insn(s) executed; cut out of the PROBABLE region
	; 495B-4968 by apply_coverage --split [executed in 1 scenarios]
	dec b
	call MailBody_GetCharPtr
	ld a, [wTextEditGoalColumn]
	ld c, a
	cp a, e
	jr c, .done

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 495B-4968 by apply_coverage --split
	ld c, e

.done ; 2D:4967
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 495B-4968 by apply_coverage
	; --split [executed in 1 scenarios]
	ret

MailBody_CursorDown:: ; 2D:4968
Function_2D_4968::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

MailBody_CursorDownStep:: ; 2D:497C
	ld a, $07
	cp a, b
	ret z
	inc b
	call MailBody_GetRowPtr
	dec b
	ld a, d
	cp a, $FF
	ret z

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the retcc at 2D:4988 (executed) | 5 insn(s) executed; cut out of the PROBABLE
	; region 4989-499E by apply_coverage --split [executed in 1 scenarios]
	inc b
	ld a, [wTextEditGoalColumn]
	ld c, a
	cp a, e
	jr c, .done

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4989-499E by apply_coverage --split
	ld c, e
	ld a, $07
	cp a, b
	ret nz
	ld a, [wTextEditGoalColumn]
	cp a, $0C
	ret nz
	ld c, a

.done ; 2D:499D
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4989-499E by apply_coverage
	; --split [executed in 1 scenarios]
	ret

MailBody_SetupScreen:: ; 2D:499E
Function_2D_499E::
	; [CONFIRMED] 148 insn(s); 148 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call TextTiles_ClearBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, $2D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, $5EC0
	ld a, $2D
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_MailBody_ObjTiles
	ld a, $2D
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMA
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailBody_Obj
	ld a, $2D
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailBody_Bg
	ld a, $2D
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailBody
	ld a, $2D
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	farcall LCDOn
	call TextTiles_UploadBuffers
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0005
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	ret

	; [HYPOTHESIS] push bc before the raw far-call site 4B2E; the previous region ends with ret so
	; 4B2D would be a function entry; no caller found
	push bc

	; [PROBABLE] 140 insn(s) reached by static flow only; seeds: site x140; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Stat_EnableScrollSplit
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call TextTiles_ClearBuffers
	call TextTiles_UploadBuffers
	farcall LCDOff
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, $2D
	ld b, $93
	ld c, $3C
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, Gfx_MailBody_ObjTiles
	ld a, $2D
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_MailBody_Obj
	ld a, $2D
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_MailBody_Bg
	ld a, $2D
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailBody
	ld a, $2D
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1414
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $06
	ld b, $02
	ld a, $0A
	ld b, $00
	ld c, $01
	pop bc
	farcall LCDOn
	call TextTiles_UploadBuffers
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	ld bc, $0000
	xor a, a
	ld [wTextEditGoalColumn], a
	pop bc
	ret

MailBody_PlaceCursorSprites:: ; 2D:4CA5
Function_2D_4CA5::
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	inc b
	inc c
	ld a, $0D
.l4CB0 ; 2D:4CB0
	dec b
	jr z, .l4CB7

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:4CB1 (executed) [executed in 4 scenarios]
	add a, $0C
	jr .l4CB0

.l4CB7 ; 2D:4CB7
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld a, $08
.l4CC6 ; 2D:4CC6
	dec c
	jr z, .l4CCD
	add a, $0C
	jr .l4CC6
.l4CCD ; 2D:4CCD
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a
	pop bc
	ldh a, [hJoyHeld]
	cp a, $00
	ret z
	ret

	; [PROBABLE] compare chain push bc ; ld a,b ; cp 0 ; jp z,$4D04 ; cp 1 ; jp z,$4D24 ... cp 7 ;
	; jp z,$4DE4 followed by the default block at 4D04 (ld hl,$DA40 ; ld de,$6350 ; ld a,$29 ; ld
	; b,$81 ; call FarCall 00:0A82 ...): its 8 jp z targets land exactly on the starts of the 8
	; ten-byte holes below + 4D04 and each is followed by a raw far-call site; entry of the chain
	; not located
	push bc
	ld a, b
	cp a, $00
	jp z, .l4D04
	cp a, $01
	jp z, .l4D24
	cp a, $02
	jp z, .l4D44
	cp a, $03
	jp z, .l4D64
	cp a, $04
	jp z, .l4D84
	cp a, $05
	jp z, .l4DA4
	cp a, $06
	jp z, .l4DC4
	cp a, $07
	jp z, .l4DE4
.l4D04 ; 2D:4D04
	ld hl, wSpriteSlot4
	ld de, $6350
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $13
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4D24 ; 2D:4D24
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $6360
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $1F
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4D44 ; 2D:4D44
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $6370
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $2B
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4D64 ; 2D:4D64
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $6380
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $37
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4D84 ; 2D:4D84
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $6390
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $43
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4DA4 ; 2D:4DA4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $63A0
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $4F
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4DC4 ; 2D:4DC4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $63B0
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $5B
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

.l4DE4 ; 2D:4DE4
	; [PROBABLE] block target of the jp z chain at 2D:4CDA (ld hl,$DA40 ; ld de,$63x0 ; ld a,$29 ;
	; ld b,$81) that falls into the far-call site (call 00:0A82, init_object_from_table) right after
	ld hl, wSpriteSlot4
	ld de, $63C0
	ld a, $29
	ld b, $81

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: site x10; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	xor a, a
	ld [wSpriteSlots + 65], a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, $67
	sub a, e
	ld [wSpriteSlots + 64], a
	pop bc
	ret

	; [HYPOTHESIS] pop bc ; ret - epilogue after the last block of the 4CDA chain; no reference
	; found
	pop bc
	ret

TextTiles_ClearBuffers:: ; 2D:4E06
Function_2D_4E06::
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 7/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $1000
.l4E12 ; 2D:4E12
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l4E12
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0780
.l4E25 ; 2D:4E25
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l4E25
	ret

MailBody_ClearBuffer:: ; 2D:4E2D
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	ld b, $C0
.loop ; 2D:4E38
	xor a, a
	ld [hli], a
	dec b
	jr nz, .loop
	xor a, a
	ld [rRAMG], a
	ret

Function_2D_4E42:: ; 2D:4E42
	; [PROBABLE] two small routines: 4E42 (push bc ; WRAM bank 1 ; call $4E54 ; ... pop bc ; ret)
	; and 4E54 (scan of the $D400 buffer in 2-byte units for $0D / $00 terminators returning
	; A,E,HL); the call 4E42->4E54 targets an instruction boundary inside the hole and both end in
	; ret; between two executed functions; entry not located
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_2D_4E54
	push af
	xor a, a
	ld [rRAMG], a
	pop af
	pop bc
	ret

Function_2D_4E54:: ; 2D:4E54
	push bc
	ld hl, wEditBodyBuf
	inc b
.l4E59 ; 2D:4E59
	dec b
	jr z, .l4E73
	ld d, $0C
.l4E5E ; 2D:4E5E
	ld a, [hli]
	inc hl
	cp a, $0D
	jr z, .l4E59
	dec d
	jr z, .l4E59
	cp a, $00
	jr nz, .l4E5E
	ld a, $FF
	ld e, $FF
	ld hl, $FFFF
	ret
.l4E73 ; 2D:4E73
	ld e, c
	inc c
.l4E75 ; 2D:4E75
	dec c
	jr z, .l4E85
	ld a, [hl]
	cp a, $0D
	jr z, .l4E85
	inc hl
	inc hl
	cp a, $00
	jr nz, .l4E75
	dec hl
	dec hl
.l4E85 ; 2D:4E85
	ld a, e
	sub a, c
	ld c, a
	ld a, [hl]
	ld e, c
	pop bc
	ret

MailBody_GetCharPtr:: ; 2D:4E8C
Function_2D_4E8C::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	call MailBody_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, .l4EB4
	inc c
	ld a, [hl]
.loop ; 2D:4E9D
	dec c
	jr z, .l4EB2
	inc hl
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, .l4EB4
	ld a, [hl]
	cp a, $0D
	jr z, .l4EBA
	jr .loop

	; [HYPOTHESIS] inc c ; dec c ; jr nz,$4EB4 - unreached alternative tail before the executed pop
	; bc ; ret at 4EB2 (same 4-byte pattern also at 6CCD)
	inc c
	dec c
	jr nz, .l4EB4

.l4EB2 ; 2D:4EB2
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop bc
	ret
.l4EB4 ; 2D:4EB4
	ld a, $FF
	ld d, $FF
	pop bc
	ret

.l4EBA ; 2D:4EBA
	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 2D:4EAA (executed) [executed in 3 scenarios]
	ld a, $0D
	ld d, $FF
	pop bc
	ret

MailBody_GetRowPtr:: ; 2D:4EC0
Function_2D_4EC0::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	inc b
.l4ECB ; 2D:4ECB
	ld d, $00
	ld e, $0C
	dec b
	jr z, .l4EE4
.l4ED2 ; 2D:4ED2
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l4EE4
	inc hl
	inc hl
	cp a, $0D
	jr z, .l4ECB
	dec e
	jr nz, .l4ED2

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:4EE0 (executed) [executed in 4 scenarios]
	jr .l4ECB

.l4EE4 ; 2D:4EE4
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .l4EFD
	ld e, $00
	push hl
.l4EEC ; 2D:4EEC
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l4EFC
	cp a, $0D
	jr z, .l4EFC
	inc e
	ld a, $0B
	cp a, e
	jr nz, .l4EEC
.l4EFC ; 2D:4EFC
	pop hl
.l4EFD ; 2D:4EFD
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

Function_2D_4F03:: ; 2D:4F03
	push bc
	ld b, $07
	call MailBody_GetRowPtr
	ld a, $FF
	cp a, d
	jr nz, .l4F12
	ld a, $01
	pop bc
	ret

.l4F12 ; 2D:4F12
	; [PROBABLE] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 1;
	; entered by jrcc from 2D:4F0C (executed)
	ld a, $0B
	cp a, e
	jr nz, .l4F2C
	ld b, $07
	ld c, $0B
	call MailBody_GetCharPtr
	inc d
	jr nz, .l4F24
	xor a, a
	pop bc
	ret
.l4F24 ; 2D:4F24
	xor a, a
	ld [rRAMG], a
	ld a, $FF
	pop bc
	ret
.l4F2C ; 2D:4F2C
	xor a, a
	pop bc
	ret

MailBody_DrawRow:: ; 2D:4F2F
Function_2D_4F2F::
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $18
	ld [wTextCellsLeft], a
.l4F34 ; 2D:4F34
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l4FCF
	cp a, $0D
	jr z, .l4FB4
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l4F8F
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, wGlyphBufLeft
	ld de, wGlyphBufRight
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailBody_DrawRow_Glyph
	push bc
	push de
	push hl
	ld hl, wGlyphBufRight
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l4FCF
	cp a, $01
	jr z, .l4FCF
	jr .l4F34

.l4F8F ; 2D:4F8F
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jrcc from 2D:4F4C (executed) | 19 insn(s) never executed in the traced runs; cut
	; out of the PROBABLE region 4F8F-4FCF by apply_coverage --split
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailBody_DrawRow_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l4FCF
	cp a, $01
	jr z, .l4FCF
	jr .l4F34

.l4FB4 ; 2D:4FB4
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4F8F-4FCF by apply_coverage
	; --split [executed in 5 scenarios]
	push bc
	push de
	push hl
	ld b, $7F
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailBody_DrawRow_Pad

.l4FCF ; 2D:4FCF
	; [CONFIRMED] 119 insn(s); 119 executed (in up to 5/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l4FDB ; 2D:4FDB
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailBody_DrawRow_Pad
	jr .l4FDB

MailBody_DrawRow_Glyph:: ; 2D:4FEA
	push bc
	push de
	push hl
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailBody_DrawRow_Pad:: ; 2D:4FFE
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

TextTiles_UploadBuffers:: ; 2D:5016
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $3F
	call TextTiles_HdmaBlock
	ld hl, wTileStage2 + $C00
	ld de, $8C00
	ld c, $3F
	call TextTiles_HdmaBlock
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

TextTiles_HdmaBlock:: ; 2D:5054
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l5063 ; 2D:5063
	ld a, [de]
	cp a, $8F
	jr nz, .l5063
	di
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wStatSplitLine]
	ldh [rLYC], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rSCY], a
	ld b, $91
.l5081 ; 2D:5081
	ld a, [de]
	cp a, b
	jr nz, .l5081
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret

MailBody_GetRowFill:: ; 2D:508C
	push bc
	call MailBody_GetRowPtr
	ld b, $00
.loop ; 2D:5092
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	inc hl
	cp a, $0D
	jr z, .l50A5
	cp a, $00
	jr z, .l50A5
	inc b
	jr .loop
.l50A5 ; 2D:50A5
	ld d, $00
	ld a, b
	cp a, $00
	jr nz, .skip

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:50AA (executed) [executed in 4 scenarios]
	ld d, $FF

.skip ; 2D:50AE
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)
	cp a, $0C
	jr nc, .l50B4
	pop bc
	ret

.l50B4 ; 2D:50B4
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 2D:50B0 (executed) [executed in 4 scenarios]
	ld d, $01
	pop bc
	ret

MailBody_InsertChar:: ; 2D:50B8
Function_2D_50B8::
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailBody_GetRowPtr
	inc d
	jr z, .l5102

	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 0;
	; fall-through of the jrcc at 2D:50C2 (executed) | 10 insn(s) executed; cut out of the PROBABLE
	; region 50C4-5102 by apply_coverage --split [executed in 1 scenarios]
	pop bc
	push bc
	ld c, $0B
.l50C8 ; 2D:50C8
	call MailBody_GetCharPtr
	inc d
	jr nz, .l50DC
	ld a, e
	cp a, $0B
	jr z, .l50D5
	jr .l5102

.l50D5 ; 2D:50D5
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50C4-5102 by apply_coverage --split
	ld a, $07
	cp a, b
	jr nz, .l50EB
	jr .l5102

.l50DC ; 2D:50DC
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 50C4-5102 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $0D
	jr z, .l50EB
	ld a, $08
	cp a, b
	jr z, .l50EB
	inc b
	ld a, $08
	cp a, b
	jr nz, .l50C8

.l50EB ; 2D:50EB
	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50C4-5102 by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	ret

.l5102 ; 2D:5102
	; [CONFIRMED] 92 insn(s); 92 executed (in up to 2/18 scenarios)
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	push de
	push bc
	push bc
	ld hl, wSpriteSlot1
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call MailBody_PlaceCursorSprites
	ld d, $14
.l5131 ; 2D:5131
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	cp a, $00
	jr nz, .l5155
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l5155
	dec d
	jr nz, .l5131
.l5155 ; 2D:5155
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	pop de
	push de
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, wEditBodyBuf + $BE
	ld bc, wEditBodyBuf + $BC
.l5181 ; 2D:5181
	ld a, d
	cp a, h
	jr nz, .l5189
	ld a, e
	cp a, l
	jr z, .l5195
.l5189 ; 2D:5189
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr .l5181
.l5195 ; 2D:5195
	pop hl
	pop de
	pop bc
	ld a, d
	ld [hli], a
	ld a, e
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ld a, b
	cp a, $07
	jr nz, .l51C5

	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 0;
	; fall-through of the jrcc at 2D:51A8 (executed) | 5 insn(s) executed; cut out of the PROBABLE
	; region 51AA-51C5 by apply_coverage --split [executed in 1 scenarios]
	ld a, c
	cp a, $0C
	ret z
	cp a, $0B
	jr nz, .l51C5

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 51AA-51C5 by apply_coverage --split
	call MailBody_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

.l51C5 ; 2D:51C5
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	call MailBody_GetCharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l51D9

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2D:51CE (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l51D9 ; 2D:51D9
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .done

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:51E1 (executed) [executed in 4 scenarios]
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.done ; 2D:51EA
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 2/18 scenarios)
	ret

MailBody_RedrawFromRow:: ; 2D:51EB
	ld c, $0B
.loop ; 2D:51ED
	call MailBody_RedrawRow
	call MailBody_GetRowFill
	inc d
	jr z, .l5201
	dec d
	jr z, .l520C

	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 2D:51F7 (executed) [executed in 4 scenarios]
	inc b
	ld a, b
	cp a, $08
	jr z, .l520C
	jr .loop
.l5201 ; 2D:5201
	inc b
	ld a, b
	cp a, $08
	jr z, .l520C
	call MailBody_RedrawRow
	jr .l5201

.l520C ; 2D:520C
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	call TextTiles_UploadBuffers
	ret

MailBody_RedrawRow:: ; 2D:5210
	push bc
	push bc
	call MailBody_GetRowPtr
	pop bc
	xor a, a
	inc b
.loop ; 2D:5218
	dec b
	jr z, .l521F

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:5219 (executed) [executed in 4 scenarios]
	add a, $0C
	jr .loop

.l521F ; 2D:521F
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ld d, a
	ld b, $03
	ld c, $00
	ld e, $08
	call MailBody_DrawRow
	pop bc
	ret

MailBody_InsertNewline:: ; 2D:522B
	; [CONFIRMED] 168 insn(s) reached by static flow only; seeds: exec x168; min discovery hops 2;
	; entered by call from 2D:5761 (PROBABLE code) | 143 insn(s) executed; cut out of the PROBABLE
	; region 522B-535C by apply_coverage --split [executed in 1 scenarios]
	push de
	push bc
	ld b, $07
	ld c, $00
	call MailBody_GetRowPtr
	inc d
	jr z, .l525C
	pop bc
	push bc
	ld a, $07
	cp a, b
	jr z, .l5243
	ld a, [hl]
	cp a, $00
	jr z, .l525C
.l5243 ; 2D:5243
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	ld a, $FF
	ret
.l525C ; 2D:525C
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $003B
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop bc
	pop de
	push de
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, wEditBodyBuf + $BE
	ld bc, wEditBodyBuf + $BC
.loop ; 2D:5286
	ld a, d
	cp a, h
	jr nz, .l528E
	ld a, e
	cp a, l
	jr z, .l529A
.l528E ; 2D:528E
	ld a, [bc]
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [de], a
	dec bc
	dec bc
	dec de
	dec de
	jr .loop
.l529A ; 2D:529A
	pop hl
	pop de
	pop bc
	ld a, $0D
	ld [hli], a
	ld a, $0A
	ld [hl], a
	xor a, a
	ld [rRAMG], a
	push bc
	ld b, $00
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld de, $0008
	call MailBody_DrawRow
	ld b, $01
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $0C
	ld e, $08
	call MailBody_DrawRow
	ld b, $02
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $18
	ld e, $08
	call MailBody_DrawRow
	ld b, $03
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $24
	ld e, $08
	call MailBody_DrawRow
	ld b, $04
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $30
	ld e, $08
	call MailBody_DrawRow
	ld b, $05
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $3C
	ld e, $08
	call MailBody_DrawRow
	ld b, $06
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $48
	ld e, $08
	call MailBody_DrawRow
	ld b, $07
	call MailBody_GetRowPtr
	ld b, $03
	ld c, $00
	ld d, $54
	ld e, $08
	call MailBody_DrawRow
	call TextTiles_UploadBuffers
	pop bc
	ld a, b
	cp a, $07
	jr nz, .l5335

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 522B-535C by apply_coverage --split
	ld a, c
	cp a, $0B
	jr z, .l535A

.l5335 ; 2D:5335
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 522B-535C by apply_coverage
	; --split [executed in 5 scenarios]
	call MailBody_GetCharPtr
	cp a, $FF
	jr z, .l535A
	cp a, $0D
	jr nz, .l5349
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .l535A

.l5349 ; 2D:5349
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 522B-535C by apply_coverage --split
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $0C
	cp a, c
	jr nz, .l535A
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a

.l535A ; 2D:535A
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 522B-535C by apply_coverage
	; --split [executed in 5 scenarios]
	xor a, a
	ret

MailBody_Backspace:: ; 2D:535C
Function_2D_535C::
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, wSpriteSlot1
	ld de, $7B80
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	dec b
	ld c, $0B
	call MailBody_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l5399

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2D:538F (executed) [executed in 2 scenarios]
	ld a, b
	cp a, $00
	jr z, .l539A
	dec b
	ld c, e
	inc c

.l5399 ; 2D:5399
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	dec c
.l539A ; 2D:539A
	call MailBody_PlaceCursorSprites
	pop bc
	ld d, $14
.loop ; 2D:53A0
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	cp a, $00
	jr nz, .l53C4
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l53C4
	dec d
	jr nz, .loop
.l53C4 ; 2D:53C4
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	inc c
	dec c
	jr nz, .l53EA

	; [CONFIRMED] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 2D:53DD (executed) [executed in 2 scenarios]
	inc b
	dec b
	jr z, .l53EF
	dec b
	call MailBody_GetCharPtr
	ld c, e
	jr .l53EF

.l53EA ; 2D:53EA
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios)
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l53EF ; 2D:53EF
	call MailBody_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	pop bc
	push hl
	inc bc
	inc bc
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, .l5409

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:5405 (executed) [executed in 1 scenarios]
	ld e, $01

.l5409 ; 2D:5409
	; [CONFIRMED] 35 insn(s); 35 executed (in up to 1/18 scenarios)
	ld a, $BE
	cp a, l
	jr nz, .l5413
	ld a, $D4
	cp a, h
	jr z, .l541B
.l5413 ; 2D:5413
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l5409
.l541B ; 2D:541B
	xor a, a
	ld [hli], a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	xor a, a
	ld [rRAMG], a
	push bc
	call MailBody_RedrawAfterBackspace
	pop bc
	ret

MailBody_RedrawAfterBackspace:: ; 2D:542D
	dec e
	jr z, .l545B
	ld c, $0B
.loop ; 2D:5432
	call MailBody_RedrawRow
	call MailBody_GetCharPtr
	ld a, e
	cp a, $0B
	jr nz, .l5448

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2D:543B (executed) [executed in 2 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $0D
	jr z, .l545E

.l5448 ; 2D:5448
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	call MailBody_GetRowFill
	inc d
	jr z, .l5469
	dec d
	jr z, .l5469

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2D:544F (executed) [executed in 1 scenarios]
	ld c, $0B
	inc b
	ld a, b
	cp a, $08
	jr z, .l5469
	jr .loop
.l545B ; 2D:545B
	call MailBody_RedrawRow
.l545E ; 2D:545E
	inc b
	ld a, b
	cp a, $08
	jr z, .l5469
	call MailBody_RedrawRow
	jr .l545E

.l5469 ; 2D:5469
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	call TextTiles_UploadBuffers
	ret

MailBody_ApplyDakuten:: ; 2D:546D
	; [CONFIRMED] 64 insn(s) reached by static flow only; seeds: exec x64; min discovery hops 1;
	; entered by call from 2D:5702 (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE
	; region 546D-54D2 by apply_coverage --split [executed in 1 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .l547B
	ld a, $D4
	cp a, h
	jp z, .l54E6
.l547B ; 2D:547B
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, MailBody_DakutenKanaList
.loop ; 2D:5487
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l54DA
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l54CF
	ld a, [hl]
	cp a, c
	jr nz, .l54CF
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wKeyboardCharLo], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l54C6

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 546D-54D2 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.l54C6 ; 2D:54C6
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 546D-54D2 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret
.l54CF ; 2D:54CF
	pop hl
	jr .loop

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l54DA ; 2D:54DA
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 2;
	; entered by jrcc from 2D:548B (PROBABLE code) [executed in 1 scenarios]
	push bc
	push de
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret
.l54E6 ; 2D:54E6
	push bc
	push de
	pop de
	pop bc
	ret

; ---- text $54EB-$553C (81 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailBody_DakutenKanaList:: ; 2D:54EB
String_2D_54EB::
	db "かきくけこさしすせそたちつてとはひふへほカキクケコサシスセソタチツテトハヒフヘホ", 0
POPC

	; [HYPOTHESIS] single ret between a text run and Function_2D_553D; no reference found
	ret

MailBody_ApplyDakutenU:: ; 2D:553D
	; [CONFIRMED] 62 insn(s) reached by static flow only; seeds: exec x62; min discovery hops 1;
	; entered by call from 2D:570C (PROBABLE code) | 48 insn(s) executed; cut out of the PROBABLE
	; region 553D-55A1 by apply_coverage --split [executed in 1 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .l554B
	ld a, $D4
	cp a, h
	jp z, .l55C5
.l554B ; 2D:554B
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, Table_MailBody_ApplyDakutenU_LoopPairs
.loop ; 2D:5557
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l55A9
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, $83
	jr nz, .l559E
	ld a, [hl]
	cp a, $45
	jr nz, .l559E
	ld a, $94
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l5595

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 553D-55A1 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.l5595 ; 2D:5595
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 553D-55A1 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.l559E ; 2D:559E
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 553D-55A1 by apply_coverage --split
	pop hl
	jr .loop

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l55A9 ; 2D:55A9
	; [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2D:555B (PROBABLE code) | 17 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 55A9-55DA by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l55C5 ; 2D:55C5
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 55A9-55DA by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- data $55DA-$55DF (5 bytes) [PROBABLE] 2-byte entries terminated by $00: 82 A4 82 A4 00 (Shift-JIS lead/trail pairs); read by the loop of Function_2D_553D (ld de,$55DA ; ld a,[de] ; inc de ; cp $00 ; jr z ...)
; kept as raw bytes: the bytes read as Shift-JIS/ASCII text, but the header does not say `text` (executed-read data of unknown content class, or unclassified), so not provably a string

Table_MailBody_ApplyDakutenU_LoopPairs:: ; 2D:55DA
Data_2D_55DA::
	db $82, $A4, $82, $A4, $00

	; [HYPOTHESIS] single ret ($C9) after the terminator of Data_2D_55DA; no reference found
	ret

MailBody_ApplyHandakuten:: ; 2D:55E0
	; [CONFIRMED] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 1;
	; entered by call from 2D:571F (PROBABLE code) | 4 insn(s) executed; cut out of the PROBABLE
	; region 55E0-5642 by apply_coverage --split [executed in 2 scenarios]
	call MailBody_GetCharPtr
	ld a, $00
	cp a, l
	jr nz, .l55EE

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55E0-5642 by apply_coverage --split
	ld a, $D4
	cp a, h
	jp z, .l5666

.l55EE ; 2D:55EE
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 55E0-5642 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	dec hl
	dec hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, MailBody_HandakutenKanaList
.loop ; 2D:55FA
	ld a, [de]
	inc de
	cp a, $00
	jr z, .l564A
	ld b, a
	ld a, [de]
	inc de
	ld c, a
	push hl
	ld a, [hli]
	cp a, b
	jr nz, .l563F
	ld a, [hl]
	cp a, c
	jr nz, .l563F
	inc a
	inc a
	ld [hl], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop hl
	pop bc
	ld a, c
	cp a, $00
	jr nz, .l5636

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 55E0-5642 by apply_coverage --split
	dec b
	call MailBody_RedrawRow
	inc b
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret

.l5636 ; 2D:5636
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 55E0-5642 by apply_coverage
	; --split [executed in 1 scenarios]
	call MailBody_RedrawRow
	push bc
	call MailBody_RedrawFromRow
	pop bc
	ret
.l563F ; 2D:563F
	pop hl
	jr .loop

	; [HYPOTHESIS] SRAM-disable epilogue xor a ; ldh [$F5],a ; ld [$0000],a ; pop bc ; ret (same 8
	; bytes at 54D2/55A1/5642); the previous region ends with an unconditional jr so no path reaches
	; it; no reference found
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l564A ; 2D:564A
	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 2;
	; entered by jrcc from 2D:55FE (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE
	; region 564A-567B by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop bc
	ret

.l5666 ; 2D:5666
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 564A-567B by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- text $567B-$5690 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailBody_HandakutenKanaList:: ; 2D:567B
String_2D_567B::
	db "はひふへほハヒフヘホ", 0
POPC

	; [HYPOTHESIS] single ret between a text run and Function_2D_5691; no reference found
	ret

MailBody_KeyboardLoop:: ; 2D:5691
Function_2D_5691::
	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
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
	ld a, $06
	ld b, $00
	farcall Kbd_Open
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
	pop bc
.l56C6 ; 2D:56C6
	push bc
	call MailBody_PlaceCursorSprites
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, .l56C6
	cp a, $09
	ret z
	cp a, $02
	jr z, .l5737
	cp a, $03
	jr z, .l5761
	cp a, $07
	jp z, .l579A
	cp a, $08
	jp z, .l5A6F
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l5711

	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0;
	; fall-through of the jrcc at 2D:56F9 (executed) [executed in 1 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l5711
	call MailBody_ApplyDakuten
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l56C6
	call MailBody_ApplyDakutenU
	jr .l56C6

.l5711 ; 2D:5711
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l5724

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2D:5716 (executed) [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l5724
	call MailBody_ApplyHandakuten
	jr .l56C6

.l5724 ; 2D:5724
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	ld a, b
	push af
	call MailBody_InsertChar
	pop af
	cp a, b
	jr nz, .l5768
	jr .l56C6
.l5737 ; 2D:5737
	call MailBody_GetLength
	cp a, $00
	jr nz, .l5742

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2D:573C (executed) [executed in 2 scenarios]
	ld a, b
	or a, c
	jr z, .l574F

.l5742 ; 2D:5742
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld a, b
	push af
	call MailBody_Backspace
	pop af
	cp a, b
	jr nz, .l5783
	jp .l56C6

	; [HYPOTHESIS] single ret after a jp; no reference found
	ret

.l574F ; 2D:574F
	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1;
	; entered by jrcc from 2D:5740 (PROBABLE code) [executed in 1 scenarios]
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret
.l5761 ; 2D:5761
	call MailBody_InsertNewline
	inc a
	jp z, .l56C6
.l5768 ; 2D:5768
	ld a, b
	cp a, $01
	jp z, .l56C6
	cp a, $07
	jp z, .l56C6
	cp a, $08
	jp z, .l56C6
	ld a, [wSplitScrollY]
	add a, $0C
	ld [wSplitScrollY], a
	jp .l56C6
.l5783 ; 2D:5783
	ld a, b
	cp a, $00
	jp z, .l56C6
	cp a, $06
	jp z, .l56C6
	ld a, [wSplitScrollY]
	sub a, $0C
	ld [wSplitScrollY], a
	jp .l56C6

	; [HYPOTHESIS] single ret after a jp; no reference found
	ret

.l579A ; 2D:579A
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .l57AF
	cp a, $07
	jr nz, .l57C1

.l57AF ; 2D:57AF
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; entered by jrcc from 2D:57A9 (executed) [executed in 1 scenarios]
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.l57C1 ; 2D:57C1
	; [CONFIRMED] 43 insn(s); 43 executed (in up to 2/18 scenarios)
	ld a, $0A
	ld b, $00
	ld c, $00
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
	farcall Kbd_Open
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
	pop bc
.l57F7 ; 2D:57F7
	push bc
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $04
	jr z, .l582C
	cp a, $05
	jp z, .l5952
	cp a, $06
	jp z, .l59B1
	cp a, $09
	jp z, .l581E

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jpcc at 2D:5819 (executed)
	jr .l57F7

.l581E ; 2D:581E
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios)
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	jp MailBody_KeyboardLoop
.l582C ; 2D:582C
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Sprites_SaveSlotsToBank3
	xor a, a
	cp a, b
	jr z, .l585C

	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 0;
	; fall-through of the jrcc at 2D:5840 (executed) [executed in 1 scenarios]
	inc a
	cp a, b
	jr z, .l585C
	inc a
	cp a, b
	jr z, .l585C
	inc a
	cp a, b
	jr z, .l585C
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a

.l585C ; 2D:585C
	; [CONFIRMED] 53 insn(s); 53 executed (in up to 2/18 scenarios)
	ld de, $0202
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
	farcall Sprites_RestoreSlotsFromBank3
	pop af
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
	pop bc
	dec a
	jr nz, .l58C8
	farcall MailDraft_SaveToSram
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0032
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	pop af
	ld a, $FF
	ld a, $01
	ret

.l58C8 ; 2D:58C8
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 1;
	; entered by jrcc from 2D:589A (executed) [executed in 2 scenarios]
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	jp .l579A

	; [HYPOTHESIS] jp $5691 after a jp; no reference found
	jp MailBody_KeyboardLoop

.l58D9 ; 2D:58D9
	; [CONFIRMED] 98 insn(s) reached by static flow only; seeds: exec x98; min discovery hops 1;
	; entered by jpcc from 2D:5A38 (executed) | 21 insn(s) executed; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split [executed in 2 scenarios]
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .l58F9
	cp a, $07
	jr nz, .l590B

.l58F9 ; 2D:58F9
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.l590B ; 2D:590B
	; [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 58D9-59AD by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $0A
	ld b, $00
	ld c, $02
	farcall Kbd_Open
	pop bc
	jp .l57F7
.l591B ; 2D:591B
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	push bc
	call MailBody_PlaceCursorSprites
	pop bc
	push bc
	ld a, b
	cp a, $06
	jr z, .l5930
	cp a, $07
	jr nz, .l5942

.l5930 ; 2D:5930
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 58D9-59AD by apply_coverage --split
	ld de, $14D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $14D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition

.l5942 ; 2D:5942
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 58D9-59AD by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $0A
	ld b, $00
	ld c, $01
	farcall Kbd_Open
	pop bc
	jp .l57F7
.l5952 ; 2D:5952
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Kbd_Hide
.l5964 ; 2D:5964
	ldh a, [rLY]
	cp a, $50
	jr c, .l5964
	cp a, $5A
	jr nc, .l5964
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $B0
	ldh [rWX], a
	farcall MailBody_ViewScreen
	pop bc
	push bc
	farcall Stat_EnableScrollSplit
	call MailBody_SetupScreen
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0005
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call Function_2D_4F03
	pop bc
	jp .l591B

	; [HYPOTHESIS] jp $56C6 ; ret after a jp; no reference found
	jp .l56C6

	ret

.l59B1 ; 2D:59B1
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios)
	push af
	push bc
	push de
	push hl
	call MailBody_ReloadTiles
	pop hl
	pop de
	pop bc
	pop af
	push bc
	farcall Sprites_SaveSlotsToBank3
	xor a, a
	cp a, b
	jr z, .l59E1

	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 0;
	; fall-through of the jrcc at 2D:59C5 (executed) [executed in 1 scenarios]
	inc a
	cp a, b
	jr z, .l59E1
	inc a
	cp a, b
	jr z, .l59E1
	inc a
	cp a, b
	jr z, .l59E1
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a

.l59E1 ; 2D:59E1
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l59F2
	ld de, $0200
	jr .l59FD

.l59F2 ; 2D:59F2
	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 2D:59EB (executed)
	dec a
	jr nz, .l59FA
	ld de, $0211
	jr .l59FD
.l59FA ; 2D:59FA
	ld de, $020F

.l59FD ; 2D:59FD
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)
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
	farcall Sprites_RestoreSlotsFromBank3
	pop af
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
	pop bc
	dec a
	jp nz, .l58D9
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jr nz, .l5A49
	jr .l5A4E

.l5A49 ; 2D:5A49
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 2D:5A45 (executed)
	dec a
	jr nz, .l5A4E
	jr .l5A4E

.l5A4E ; 2D:5A4E
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop af
	xor a, a
	ret

	; [HYPOTHESIS] push bc before the raw far-call site 5A61; previous region ends with ret; no
	; caller found
	push bc

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x6, site x6; min discovery hops
	; 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded
	; code
	farcall Kbd_Hide
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret
.l5A6F ; 2D:5A6F
	push bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

	; [HYPOTHESIS] ret ; jr $5A79 (self-loop filler) after a ret; no reference found
	ret
.l5A79 ; 2D:5A79
	jr .l5A79

MailBody_GetLength:: ; 2D:5A7B
Function_2D_5A7B::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	ld d, $00
.loop ; 2D:5A88
	ld a, [hli]
	cp a, $00
	jr z, .l5A93
	inc d
	ld a, $C0
	cp a, d
	jr nz, .loop
.l5A93 ; 2D:5A93
	ld a, d
	pop de
	pop hl
	ret

	; [HYPOTHESIS] single ret after a ret; no reference found
	ret

MailBody_ReloadTiles:: ; 2D:5A98
Function_2D_5A98::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $9301
	ld hl, Gfx_MailBody_Tiles
	ld a, $2D
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	ld de, $9501
	ld hl, $5CC0
	ld a, $2D
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMA
	ret

; ---- zero $5ABD-$5AC0 (3 bytes) [PROBABLE] 3 bytes $00 padding to the 16-byte tile alignment before the tile block at 5AC0
	ds $3, $00
