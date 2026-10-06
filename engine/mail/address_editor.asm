; engine/mail/address_editor.asm
; bank 2D, $65B0-$7120 (2928 bytes); pinned by layout.link
; mail address editor, joypad repeat reset

SECTION "engine/mail/address_editor", ROMX

MailAddr_Edit:: ; 2D:65B0
Function_2D_65B0::
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
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
	call VBlank_Wait
	pop af
	push af
	call MailAddr_SetupScreen
	ld d, $40
.loop ; 2D:65F0
	push de
	call MailAddr_CursorRightStep
	pop de
	dec d
	jr nz, .loop
	pop af
	cp a, $01
	jr nz, .l6603

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:65FB (executed); upgraded by classifier g3: all 2 instruction
	; starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the
	; mapper run, e.g. mail_inbox/mail_send/mail_compose)
	call MailAddr_KeyboardLoop
	jp .l6621

.l6603 ; 2D:6603
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call MailAddr_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, .l669B
	call MailAddr_OpenKeyboard
.l6621 ; 2D:6621
	cp a, $07
	jr nz, .l6693
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditAddressBuf
	ld a, [hl]
	cp a, $00
	jr nz, .l666B

	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 0;
	; fall-through of the jrcc at 2D:6632 (executed) [executed in 3 scenarios]
	ld de, $0205
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
	jr .l6603

.l666B ; 2D:666B
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	xor a, a
	ret

.l6693 ; 2D:6693
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 2D:6623 (executed) [executed in 4 scenarios]
	push bc
	farcall Joypad_Update
	pop bc

.l669B ; 2D:669B
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jp z, .l6784

	; [CONFIRMED] 108 insn(s) reached by static flow only; seeds: exec x108; min discovery hops 0;
	; fall-through of the jpcc at 2D:669F (executed) | 65 insn(s) executed; cut out of the PROBABLE
	; region 66A2-6784 by apply_coverage --split [executed in 1 scenarios]
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
	ld a, c
	cp a, $14
	jr c, .l66CD
	ld de, $D000
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $D000
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
.l66CD ; 2D:66CD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jp z, .l676F
	dec a
	jr nz, .l6726
	push bc
	ld de, $0211
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
	jp nz, .l6603
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l6726 ; 2D:6726
	; [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 66A2-6784 by apply_coverage --split
	push bc
	ld de, $020F
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
	jp nz, .l6603
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l676F ; 2D:676F
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 66A2-6784 by apply_coverage
	; --split [executed in 5 scenarios]
	call MailCompose_ConfirmDiscard
	inc a
	jr z, .l6784
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l6784 ; 2D:6784
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $04
	jr z, .l67B8
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	call MailAddr_OpenAddressBook
	inc a
	jr nz, .l67AB
	pop af
	xor a, a
	jp MailAddr_Edit

.l67AB ; 2D:67AB
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 2D:67A4 (executed) [executed in 3 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [wMailComposeMode], a
	jp MailAddr_Edit

.l67B8 ; 2D:67B8
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, MailAddr_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, MailAddr_CursorRight
	ld d, $10
	jp .l6603

MailAddr_OpenAddressBook:: ; 2D:67CB
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	farcall AddrPick_Menu
	ret

MailAddr_CursorLeft:: ; 2D:67E1
	; [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 1;
	; entered by callcc from 2D:67BC (executed) | 18 insn(s) executed; cut out of the PROBABLE
	; region 67E1-6808 by apply_coverage --split [executed in 6 scenarios]
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
	jr nz, .l6802
	inc b
	dec b
	ret z

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 67E1-6808 by apply_coverage --split
	dec b
	call MailAddr_GetCharPtr
	ld c, e
	ret

.l6802 ; 2D:6802
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 67E1-6808 by apply_coverage
	; --split [executed in 2 scenarios]
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

MailAddr_CursorRight:: ; 2D:6808
Function_2D_6808::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios); entry proven: target of an
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

MailAddr_CursorRightStep:: ; 2D:681C
	jr .l6827

	; [HYPOTHESIS] ld a,b ; cp $07 ; jr nz,$6827 ; ld a,c ; cp $0B ; ret z - unreached block the
	; previous region jumps over (jr $6827); no reference found
	ld a, b
	cp a, $07
	jr nz, .l6827
	ld a, c
	cp a, $0B
	ret z

.l6827 ; 2D:6827
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)
	inc c
	dec c
	jr nz, .l6838
	call MailAddr_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

.l6838 ; 2D:6838
	; [CONFIRMED] 62 insn(s) reached by static flow only; seeds: exec x62; min discovery hops 0;
	; entered by jrcc from 2D:6829 (executed) | 9 insn(s) executed; cut out of the PROBABLE region
	; 6838-68A9 by apply_coverage --split [executed in 8 scenarios]
	call MailAddr_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $41
	cp a, c
	ret nz

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6838-68A9 by apply_coverage --split
	ld c, $40
	ld a, $40
	ld [wTextEditGoalColumn], a
	ret

MailCompose_ConfirmDiscard:: ; 2D:684F
	; [CONFIRMED] 32 insn(s) executed; cut out of the PROBABLE region 6838-68A9 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wEditBodyBuf]
	cp a, $00
	jr nz, .l686E
	ld a, [wEditAddressBuf]
	cp a, $00
	jr nz, .l686E
	ld a, [wEditSubjectBuf]
	cp a, $00
	jr nz, .l686E
.loop ; 2D:686B
	pop bc
	xor a, a
	ret
.l686E ; 2D:686E
	ld de, $0200
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

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6838-68A9 by apply_coverage --split
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
	dec a
	jr z, .loop
	pop bc
	ld a, $FF
	ret

MailAddr_SetupScreen:: ; 2D:68A9
Function_2D_68A9::
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	xor a, a
	ld [wTextEditGoalColumn], a
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	call TextTiles_UploadBuffersShort
	ld de, $9301
	ld hl, Gfx_MailAddr_Tiles
	ld a, $2D
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, $7520
	ld a, $2D
	ld b, $97
	ld c, $0B
	farcall Gfx_StartHDMA
	ld de, $8800
	ld hl, $75D0
	ld a, $2D
	ld b, $94
	ld c, $2B
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, $7880
	ld a, $2D
	ld b, $94
	ld c, $2D
	farcall Gfx_StartHDMA
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailAddr
	ld a, $2D
	farcall Tilemap_CopyRectAndAttr
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld bc, $0000
	call MailAddr_PlaceCursorSprites
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20
	call TextTiles_UploadBuffersShort
	pop af
	push af
	dec a
	jr nz, .l69B3

	; [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 0;
	; fall-through of the jrcc at 2D:6971 (executed); upgraded by classifier g3: all 31 instruction
	; starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the
	; mapper run, e.g. mail_inbox/mail_send/mail_compose)
	farcall LCDOff
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
	ld a, $09
	ld b, $02
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
	ld a, $28
	ld [wSplitScrollY], a
	jr .l69B3

.l69B3 ; 2D:69B3
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld bc, $0028
	ld de, wPaletteBufObj
	ld hl, Palette_TextCursor_Obj
	ld a, $7F
	farcall Palette_LoadToBuffer
	ld bc, $0030
	ld de, wPaletteBufBg
	ld hl, Palette_MailAddr_Bg
	ld a, $2D
	farcall Palette_LoadToBuffer
	farcall LCDOn
	pop af
	dec a
	jr nz, .l6A07

	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0;
	; fall-through of the jrcc at 2D:69DD (executed); upgraded by classifier g3: all 18 instruction
	; starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the
	; mapper run, e.g. mail_inbox/mail_send/mail_compose)
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
	jr .l6A36

.l6A07 ; 2D:6A07
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios)
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
.l6A36 ; 2D:6A36
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	ld bc, $0000
	ret

MailAddr_PlaceCursorSprites:: ; 2D:6A4C
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, c
	add a, $04
	ld c, a
	ld a, c
	cp a, $30
	jr c, .l6A63

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:6A5C (executed) [executed in 1 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

.l6A63 ; 2D:6A63
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, c
	cp a, $18
	jr c, .l6A6D

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:6A66 (executed) [executed in 1 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

.l6A6D ; 2D:6A6D
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	inc b
	inc c
	ld a, $38
.l6A71 ; 2D:6A71
	dec b
	jr z, .l6A78

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2D:6A72 (executed) [executed in 1 scenarios]
	add a, $0C
	jr .l6A71

.l6A78 ; 2D:6A78
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 2/18 scenarios)
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld a, $08
.l6A87 ; 2D:6A87
	dec c
	jr z, .l6A8E
	add a, $06
	jr .l6A87
.l6A8E ; 2D:6A8E
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a
	pop bc
	ret

MailAddr_DrawLine20:: ; 2D:6A96
	ld a, $15
	ld [wTextCellsLeft], a
.l6A9B ; 2D:6A9B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l6B36
	cp a, $0D
	jr z, .l6B1B
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l6AF6

	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0;
	; fall-through of the jrcc at 2D:6AB3 (executed)
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
	call MailAddr_DrawLine20_Glyph
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
	jr z, .l6B36
	cp a, $01
	jr z, .l6B36
	jr .l6A9B

.l6AF6 ; 2D:6AF6
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)
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
	call MailAddr_DrawLine20_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l6B36
	cp a, $01
	jr z, .l6B36
	jr .l6A9B

.l6B1B ; 2D:6B1B
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 2D:6AA9 (executed)
	push bc
	push de
	push hl
	ld b, $3C
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine20_Pad

.l6B36 ; 2D:6B36
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l6B42 ; 2D:6B42
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine20_Pad
	jr .l6B42

MailAddr_DrawLine20_Glyph:: ; 2D:6B51
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

MailAddr_DrawLine20_Pad:: ; 2D:6B65
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

MailAddr_DrawLine24:: ; 2D:6B7D
	ld a, $19
	ld [wTextCellsLeft], a
.l6B82 ; 2D:6B82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l6C1D

	; [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0;
	; fall-through of the jpcc at 2D:6B8B (executed) | 6 insn(s) executed; cut out of the PROBABLE
	; region 6B8E-6C1D by apply_coverage --split [executed in 5 scenarios]
	cp a, $0D
	jr z, .l6C02
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l6BDD

	; [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B8E-6C1D by apply_coverage --split
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
	call MailAddr_DrawLine24_Glyph
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
	jr z, .l6C1D
	cp a, $01
	jr z, .l6C1D
	jr .l6B82

.l6BDD ; 2D:6BDD
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 6B8E-6C1D by apply_coverage
	; --split [executed in 5 scenarios]
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
	call MailAddr_DrawLine24_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l6C1D
	cp a, $01
	jr z, .l6C1D
	jr .l6B82

.l6C02 ; 2D:6C02
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6B8E-6C1D by apply_coverage --split
	push bc
	push de
	push hl
	ld b, $3C
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine24_Pad

.l6C1D ; 2D:6C1D
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc
.l6C29 ; 2D:6C29
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine24_Pad
	jr .l6C29

MailAddr_DrawLine24_Glyph:: ; 2D:6C38
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by call from 2D:6BB5 (PROBABLE code) [executed in 1 scenarios]
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

MailAddr_DrawLine24_Pad:: ; 2D:6C4C
Function_2D_6C4C::
	; [CONFIRMED] 73 insn(s); 73 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
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

TextTiles_UploadBuffersShort:: ; 2D:6C64
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
	call Gfx_StartHDMAAtVBlank_2D_6C8C
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2D_6C8C
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2D_6C8C:: ; 2D:6C8C
Function_2D_6C8C::
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l6C9B ; 2D:6C9B
	ld a, [de]
	cp a, $8F
	jr nz, .l6C9B
	ld b, $91
.l6CA2 ; 2D:6CA2
	ld a, [de]
	cp a, b
	jr nz, .l6CA2
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

MailAddr_GetCharPtr:: ; 2D:6CAC
	push bc
	call MailAddr_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, .l6CD3
	inc c
	ld a, [hl]
.loop ; 2D:6CBD
	dec c
	jr z, .l6CD1
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, .l6CD3
	ld a, [hl]
	cp a, $0D
	jr z, .l6CD9
	jr .loop

	; [HYPOTHESIS] inc c ; dec c ; jr nz,$6CD3 - unreached tail before the executed pop bc ; ret at
	; 6CD1 (same pattern as 4EAE)
	inc c
	dec c
	jr nz, .l6CD3

.l6CD1 ; 2D:6CD1
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	pop bc
	ret
.l6CD3 ; 2D:6CD3
	ld a, $FF
	ld d, $FF
	pop bc
	ret

.l6CD9 ; 2D:6CD9
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 2D:6CC9 (executed)
	ld a, $0D
	ld d, $FF
	pop bc
	ret

MailAddr_GetRowPtr:: ; 2D:6CDF
Function_2D_6CDF::
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	inc b
.l6CEA ; 2D:6CEA
	ld d, $00
	ld e, $18
	dec b
	jr z, .l6D02
.l6CF1 ; 2D:6CF1
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, .l6D02
	inc hl
	cp a, $0D
	jr z, .l6CEA
	dec e
	jr nz, .l6CF1

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:6CFE (executed) [executed in 4 scenarios]
	jr .l6CEA

.l6D02 ; 2D:6D02
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, d
	jr z, .l6D1B
	ld e, $00
	push hl
.l6D0A ; 2D:6D0A
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, .l6D1A
	cp a, $0D
	jr z, .l6D1A
	inc e
	ld a, $17
	cp a, e
	jr nz, .l6D0A
.l6D1A ; 2D:6D1A
	pop hl
.l6D1B ; 2D:6D1B
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

MailAddr_InsertChar:: ; 2D:6D21
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditAddressBuf + $3F
	ld a, [hl]
	cp a, $00
	jr z, .l6D44

	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2D:6D2D (executed)
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

.l6D44 ; 2D:6D44
	; [CONFIRMED] 89 insn(s); 89 executed (in up to 2/18 scenarios)
	push de
	push bc
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
	push bc
	ld hl, wSpriteSlot1
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call MailAddr_PlaceCursorSprites
	ld d, $14
	xor a, a
	ldh [hJoyPressed], a
.l6D74 ; 2D:6D74
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
	jr nz, .l6D98
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l6D98
	dec d
	jr nz, .l6D74
.l6D98 ; 2D:6D98
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	push bc
	call MailAddr_PlaceCursorSprites
	farcall Sprite_UpdateAll
	pop bc
	pop de
	push de
	call MailAddr_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D4FF
	ld bc, $D4FE
.l6DCF ; 2D:6DCF
	ld a, d
	cp a, h
	jr nz, .l6DD7
	ld a, e
	cp a, l
	jr z, .l6DDD
.l6DD7 ; 2D:6DD7
	ld a, [bc]
	ld [de], a
	dec bc
	dec de
	jr .l6DCF
.l6DDD ; 2D:6DDD
	pop hl
	pop de
	pop bc
	ld a, e
	ld [hl], a
	call MailAddr_RedrawAfterInsert
	ld a, c
	cp a, $40
	jr z, .done
	call MailAddr_GetCharPtr
	cp a, $FF
	jr z, .done
	cp a, $0D
	jr nz, .l6DFE

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2D:6DF3 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr .done

.l6DFE ; 2D:6DFE
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)
	inc c
	ld [wTextEditGoalColumn], a
.done ; 2D:6E02
	ret

MailAddr_Backspace:: ; 2D:6E03
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
	call MailAddr_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, .l6E40

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2D:6E36 (executed)
	ld a, b
	cp a, $00
	jr z, .l6E41
	dec b
	ld c, e
	inc c

.l6E40 ; 2D:6E40
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 1/18 scenarios)
	dec c
.l6E41 ; 2D:6E41
	call MailAddr_PlaceCursorSprites
	pop bc
	ld d, $14
.loop ; 2D:6E47
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
	jr nz, .l6E6B
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, .l6E6B
	dec d
	jr nz, .loop
.l6E6B ; 2D:6E6B
	farcall Joypad_ClearAndResetRepeat
	ld hl, wSpriteSlot1
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call MailAddr_PlaceCursorSprites
	inc c
	dec c
	jr nz, .l6E94

	; [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0;
	; fall-through of the jrcc at 2D:6E87 (executed)
	inc b
	dec b
	jr z, .l6E99
	dec b
	call MailAddr_GetCharPtr
	ld c, e
	jr .l6E99

.l6E94 ; 2D:6E94
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios)
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
.l6E99 ; 2D:6E99
	call MailAddr_GetCharPtr
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
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, .l6EB2

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 2D:6EAE (executed)
	ld e, $01

.l6EB2 ; 2D:6EB2
	; [CONFIRMED] 70 insn(s); 70 executed (in up to 2/18 scenarios)
	ld a, $FF
	cp a, l
	jr nz, .l6EBC
	ld a, $D4
	cp a, h
	jr z, .l6EC1
.l6EBC ; 2D:6EBC
	ld a, [bc]
	ld [hli], a
	inc bc
	jr .l6EB2
.l6EC1 ; 2D:6EC1
	xor a, a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push de
	call MailAddr_RedrawAfterBackspace
	pop de
	ret

MailAddr_OpenKeyboard:: ; 2D:6ECE
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
	ld a, $09
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

MailAddr_KeyboardLoop:: ; 2D:6F01
	push bc
	call MailAddr_PlaceCursorSprites
	ld d, $70
	farcall Sprite_UpdateAll
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, MailAddr_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, .l6F57
	cp a, $07
	ret z
	cp a, $08
	jr z, .l6F62
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, .l6F3A

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:6F2F (executed)
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l6F3A
	jr MailAddr_KeyboardLoop

.l6F3A ; 2D:6F3A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, .l6F4A

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 2D:6F3F (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 6F41-6F4A by apply_coverage --split [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, .l6F4A

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6F41-6F4A by apply_coverage --split
	jr MailAddr_KeyboardLoop

.l6F4A ; 2D:6F4A
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call MailAddr_InsertChar
	jr MailAddr_KeyboardLoop
.l6F57 ; 2D:6F57
	ld a, c
	or a, b
	jr nz, .l6F74

	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0;
	; fall-through of the jrcc at 2D:6F59 (executed) [executed in 4 scenarios]
	call MailAddr_GetLength
	cp a, $00
	jr nz, .l6F74
.l6F62 ; 2D:6F62
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

.l6F74 ; 2D:6F74
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	call MailAddr_Backspace
	jp MailAddr_KeyboardLoop

	; [HYPOTHESIS] single ret after a jp; no reference found
	ret

MailAddr_RedrawAfterInsert:: ; 2D:6F7B
Function_2D_6F7B::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	inc c
	call MailAddr_GetLength
	cp a, $14
	jr nc, .l6F93
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	jp .l7025

.l6F93 ; 2D:6F93
	; [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1;
	; entered by jrcc from 2D:6F82 (executed) | 43 insn(s) executed; cut out of the PROBABLE region
	; 6F93-7025 by apply_coverage --split [executed in 1 scenarios]
	ld a, c
	cp a, $2D
	jr c, .l6FA7
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20
	jp .l7025
.l6FA7 ; 2D:6FA7
	ld a, c
	cp a, $15
	jr c, .l6FC1
	call MailAddr_GetLength
	cp a, $2C
	jr nc, .l6FC1
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	jr .l7025
.l6FC1 ; 2D:6FC1
	ld a, c
	cp a, $15
	jr c, .l6FE0
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20
	jr .l7025
.l6FE0 ; 2D:6FE0
	call MailAddr_GetLength
	cp a, $2C
	jr nc, .l7001
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	jr .l7025

.l7001 ; 2D:7001
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6F93-7025 by apply_coverage --split
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20

.l7025 ; 2D:7025
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 2/18 scenarios)
	call TextTiles_UploadBuffersShort
	pop bc
	ret

MailAddr_GetLength:: ; 2D:702A
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld d, $00
.loop ; 2D:7037
	ld a, [hli]
	cp a, $00
	jr z, .l7042
	inc d
	ld a, $40
	cp a, d
	jr nz, .loop
.l7042 ; 2D:7042
	ld a, d
	pop de
	pop hl
	ret

MailAddr_RedrawAfterBackspace:: ; 2D:7046
	push bc
	call MailAddr_GetLength
	cp a, $14
	jr nc, .l705D
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	jp .l70EF

.l705D ; 2D:705D
	; [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1;
	; entered by jrcc from 2D:704C (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 705D-70EF by apply_coverage --split [executed in 4 scenarios]
	ld a, c
	cp a, $2D
	jr c, .l7071

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 705D-70EF by apply_coverage --split
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20
	jp .l70EF

.l7071 ; 2D:7071
	; [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 705D-70EF by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, c
	cp a, $15
	jr c, .l708B
	call MailAddr_GetLength
	cp a, $2C
	jr nc, .l708B
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	jr .l70EF
.l708B ; 2D:708B
	ld a, c
	cp a, $15
	jr c, .l70AA

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 705D-70EF by apply_coverage --split
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20
	jr .l70EF

.l70AA ; 2D:70AA
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 705D-70EF by apply_coverage
	; --split [executed in 2 scenarios]
	call MailAddr_GetLength
	cp a, $2C
	jr nc, .l70CB
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	jr .l70EF

.l70CB ; 2D:70CB
	; [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 705D-70EF by apply_coverage --split
	ld bc, $0300
	ld de, $0420
	ld hl, wEditAddressBuf
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, wEditAddressBuf + $14
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, wEditAddressBuf + $2C
	call MailAddr_DrawLine20

.l70EF ; 2D:70EF
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 4/18 scenarios)
	call TextTiles_UploadBuffersShort
	pop bc
	ret

Joypad_ClearAndResetRepeat:: ; 2D:70F4
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hRam_FFA7], a
	ldh [hJoyPressedRepeat], a
	ld [wJoyIdleFrames], a
	ld b, $14
	ld c, $02
	ld a, c
	ld [wJoyRepeatInterval], a
	ld a, b
	ld [wJoyRepeatDelay], a
	ld hl, wJoyRepeatCounters
	ld b, $04
.loop ; 2D:7115
	ld [hli], a
	dec b
	jr nz, .loop
	pop hl
	pop de
	pop bc
	pop af
	dec a
	ret

; ---- zero $711F-$7120 (1 bytes) [PROBABLE] 1 byte $00 padding between the last code and the data at 7120
	ds $1, $00
