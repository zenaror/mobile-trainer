; engine/mail/mail_viewer_sender.asm
; bank 2B, $6482-$6DD0 (2382 bytes); pinned by layout.link
; received mail viewer, page 1 (sender/title/address/date)

SECTION "engine/mail/mail_viewer_sender", ROMX

MailView_SenderPage:: ; 2B:6482
	; [CONFIRMED] 48 insn(s) reached by static flow only; seeds: exec x48; min discovery hops 7;
	; entered by far from 25:475C (PROBABLE code) [executed in 2 scenarios]
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop bc
	call MailView_SenderPage_InitScreen

MailView_SenderPage_Loop:: ; 2B:64A7
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jp z, MailView_SenderPage_CheckBAndSelect
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
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	farcall MailView_BodyPage
	cp a, $FF
	jp z, MailView_SenderPage
	xor a, a
	ret

Function_2B_64F1:: ; 2B:64F1
	; [HYPOTHESIS] function prologue (push bc; ld a,7; ldh [$8D],a; ldh [$70],a; ld a,$E0; ld
	; [$DA10],a; ld [$DA20],a) that falls into the far-call site at 2B:6500 (PROBABLE code), after
	; the ret at 64F0; no caller/pointer to 64F1 found
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a

	; [PROBABLE] 397 insn(s) reached by static flow only; seeds: exec x374, site x23; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 23 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6500-6863 by apply_coverage --split
	farcall Sprite_UpdateAll
	ld de, $0206
	push de
	pop de
	farcall Dialog_Show
	push af
	ld a, $68
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	farcall Sprite_UpdateAll
	pop af
	pop bc
	dec a
	jp nz, MailView_SenderPage_Loop
	farcall MailRecord_Delete
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	farcall Sprite_UpdateAll
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ret

MailView_SenderPage_CheckBAndSelect:: ; 2B:6548
Label_2B_6548::
	; [CONFIRMED] 298 insn(s) executed; cut out of the PROBABLE region 6500-6863 by apply_coverage
	; --split [executed in 3 scenarios]
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l6574
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
.l6574 ; 2B:6574
	ldh a, [hJoyPressed]
	and a, $04
	jr z, .l65A8
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
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	farcall SaveSenderAddr_Menu
	jp MailView_SenderPage
.l65A8 ; 2B:65A8
	jp MailView_SenderPage_Loop

MailView_SenderPage_InitScreen:: ; 2B:65AB
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	call VBlank_Wait
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $40
	ld hl, $D4C0
.l65D2 ; 2B:65D2
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l65D2
	call VBlank_Wait
	farcall MailDraft_LoadFromSram
	call VBlank_Wait
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailView_Bg
	ld a, $2B
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $8000
	ld hl, Gfx_MailView_Tiles8000
	ld a, $2B
	ld b, $96
	ld c, $18
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_MailView_Obj
	ld a, $2B
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $9001
	ld hl, Gfx_MailView_Tiles9000Vb1
	ld a, $2B
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $9401
	ld hl, Gfx_MailView_Tiles9400Vb1
	ld a, $2B
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld bc, $1214
	ld de, $D000
	ld hl, Data_MailView_TilemapAttr
	ld a, $2B
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	ld hl, $DA30
	ld de, Table_MailView_Anims
	ld a, $2B
	ld b, $81
	farcall Sprite_InitSlot
	call VBlank_Wait
	ld de, $1808
	ld hl, $DA30
	call Sprite_SetPosition
	ld hl, $DA10
	ld de, $78C0
	ld a, $2B
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6810
	ld hl, $DA10
	call Sprite_SetPosition
	xor a, a
	ldh [rVBK], a
	ld a, $AF
	ld [$998F], a
	ld a, $01
	ldh [rVBK], a
	ld a, $02
	ld [$998F], a
	call VBlank_Wait
	farcall LCDOn
	pop bc
	push bc
	call MailView_DrawDateTime
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00C9
	add hl, de
	ld a, [hl]
	cp a, $00
	jr z, .l66F9
	ld hl, $DA60
	ld de, $7900
	ld a, $2B
	ld b, $00
	farcall Sprite_InitSlot
	ld de, $0868
	ld hl, $DA60
	call Sprite_SetPosition
.l66F9 ; 2B:66F9
	pop bc
	push bc
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00D9
	add hl, de
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	ld bc, $0300
	ld d, $14
	ld e, $20
	call MailView_DrawTextLine20
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop bc
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00C9
	add hl, de
	ld bc, $0300
	ld d, $02
	ld e, $20
	call MailView_DrawTextLine16
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop bc
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $00ED
	add hl, de
	ld bc, $0300
	ld d, $24
	ld e, $20
	push hl
	call MailView_DrawTextLine20
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop hl
	ld de, $0013
	add hl, de
	ld a, [hli]
	cp a, $00
	jr z, .l67E0
	ld bc, $0300
	ld d, $30
	ld e, $08
	push hl
	call MailView_DrawTextLine24
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	pop hl
	ld de, $0017
	add hl, de
	ld a, [hli]
	cp a, $00
	jr z, .l67E0

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6500-6863 by apply_coverage --split
	ld bc, $0300
	ld d, $3C
	ld e, $08
	call MailView_DrawTextLine20

.l67E0 ; 2B:67E0
	; [CONFIRMED] 72 insn(s) executed; cut out of the PROBABLE region 6500-6863 by apply_coverage
	; --split [executed in 9 scenarios]
	pop bc
	push bc
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	call MailView_UploadTextTiles
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $9800
	ld b, $14
	ld de, $D000
.l6808 ; 2B:6808
	ldh a, [rLY]
	cp a, $90
	jr nz, .l6808
.l680E ; 2B:680E
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l680E
	push bc
	push de
	push hl
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0007
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop bc
	ld b, c
	ld c, $00
	ret

; ---- words $6863-$687B (24 bytes) [PROBABLE] 12 words $A124..$AE13 (SRAM record bases); ld hl,$6863 at 2B:66CD, 6717, 6756, 678C

Table_MailView_RecAddrs:: ; 2B:6863
Table_2B_6863::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

	; [HYPOTHESIS] lone 'ret' (c9) between the table and the next function; nothing branches to it
	ret

Function_2B_687C:: ; 2B:687C
	; [HYPOTHESIS] part of a switch-like function at 2B:687C-6909 (push bc; ld a,c; cp n; jr nz
	; next; ld de,$68xx ; ld hl,$DA10 ; call $0A65 ; ld hl,$DA20 ; ld de,$78xx ; ld a,$2B ; ld b,$81
	; ; far call 00:0A82). Block 687C is entered by the 'jr nz' of the previous block (in-span
	; targets) and continues into the PROBABLE far-call site that follows; the function entry 687C
	; has no caller/pointer in the ROM
	push bc
	ld a, c
	cp a, $00
	jr nz, .l68A6
	ld de, $6810
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, $78D0
	ld a, $2B
	ld b, $81

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	ld de, $6810
	ld hl, $DA20
	call Sprite_SetPosition
	pop bc
	ret

.l68A6 ; 2B:68A6
	; [HYPOTHESIS] part of a switch-like function at 2B:687C-6909 (push bc; ld a,c; cp n; jr nz
	; next; ld de,$68xx ; ld hl,$DA10 ; call $0A65 ; ld hl,$DA20 ; ld de,$78xx ; ld a,$2B ; ld b,$81
	; ; far call 00:0A82). Block 68A6 is entered by the 'jr nz' of the previous block (in-span
	; targets) and continues into the PROBABLE far-call site that follows; the function entry 687C
	; has no caller/pointer in the ROM
	cp a, $01
	jr nz, .l68CE
	ld de, $6830
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, $7910
	ld a, $2B
	ld b, $81

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	ld de, $6830
	ld hl, $DA20
	call Sprite_SetPosition
	pop bc
	ret

.l68CE ; 2B:68CE
	; [HYPOTHESIS] part of a switch-like function at 2B:687C-6909 (push bc; ld a,c; cp n; jr nz
	; next; ld de,$68xx ; ld hl,$DA10 ; call $0A65 ; ld hl,$DA20 ; ld de,$78xx ; ld a,$2B ; ld b,$81
	; ; far call 00:0A82). Block 68CE is entered by the 'jr nz' of the previous block (in-span
	; targets) and continues into the PROBABLE far-call site that follows; the function entry 687C
	; has no caller/pointer in the ROM
	cp a, $02
	jr nz, .l68F6
	ld de, $6850
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, $78E0
	ld a, $2B
	ld b, $81

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_InitSlot
	ld de, $6850
	ld hl, $DA20
	call Sprite_SetPosition
	pop bc
	ret

.l68F6 ; 2B:68F6
	; [HYPOTHESIS] part of a switch-like function at 2B:687C-6909 (push bc; ld a,c; cp n; jr nz
	; next; ld de,$68xx ; ld hl,$DA10 ; call $0A65 ; ld hl,$DA20 ; ld de,$78xx ; ld a,$2B ; ld b,$81
	; ; far call 00:0A82). Block 68F6 is entered by the 'jr nz' of the previous block (in-span
	; targets) and continues into the PROBABLE far-call site that follows; the function entry 687C
	; has no caller/pointer in the ROM
	ld de, $6870
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, $78F0
	ld a, $2B
	ld b, $81

	; [PROBABLE] 111 insn(s) reached by static flow only; seeds: exec x105, site x6; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6909-69AD by apply_coverage --split
	farcall Sprite_InitSlot
	ld de, $6870
	ld hl, $DA20
	call Sprite_SetPosition
	pop bc
	ret

MailView_DrawDateTime:: ; 2B:691A
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 6909-69AD by apply_coverage
	; --split [executed in 7 scenarios]
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs_DateTime
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld a, [hl]
	dec a
	jr z, .l6942
	dec a
	jr z, .l6942

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 6909-69AD by apply_coverage --split | forced execution: 1/1 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	jp .l69AB

.l6942 ; 2B:6942
	; [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 6909-69AD by apply_coverage
	; --split [executed in 9 scenarios]
	push bc
	ld b, $00
	sla c
	ld hl, Table_MailView_RecAddrs_DateTime
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld de, $0003
	add hl, de
	ld de, $D524
	xor a, a
	ldh [rVBK], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $06
.l6963 ; 2B:6963
	ld a, [hl]
	swap a
	and a, $0F
	add a, $30
	ld [de], a
	inc de
	ld a, [hli]
	and a, $0F
	add a, $30
	ld [de], a
	inc de
	dec b
	jr nz, .l6963
	ld de, $9801
	ld hl, $D524
	di
.l697D ; 2B:697D
	ldh a, [rLY]
	cp a, $90
	jr nz, .l697D
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ei
.l69AB ; 2B:69AB
	pop bc
	ret

; ---- words $69AD-$69C5 (24 bytes) [PROBABLE] 12 words $A124..$AE13 (SRAM record bases); ld hl,$69AD at 2B:692E and 6947

Table_MailView_RecAddrs_DateTime:: ; 2B:69AD
Table_2B_69AD::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

MailView_DrawTextLine20:: ; 2B:69C5
	; [CONFIRMED] 425 insn(s) reached by static flow only; seeds: exec x425; min discovery hops 9;
	; entered by call from 2B:6735 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE
	; region 69C5-6CF5 by apply_coverage --split [executed in 8 scenarios]
	ld a, $14
	ld [wTextCellsLeft], a
.l69CA ; 2B:69CA
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l6A69
	cp a, $0D
	jr z, .l6A4E
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l6A2C
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, .l69EF

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
	pop af
	jp .l6A69

.l69EF ; 2B:69EF
	; [CONFIRMED] 52 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
	; --split [executed in 8 scenarios]
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
	call MailView_DrawTextLine20_BlitGlyphAdvance
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
	jr z, .l6A69
	jr .l69CA
.l6A2C ; 2B:6A2C
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
	call MailView_DrawTextLine20_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l6A69
	jp .l69CA

.l6A4E ; 2B:6A4E
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
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
	call MailView_DrawTextLine20_BlitBlankAdvance

.l6A69 ; 2B:6A69
	; [CONFIRMED] 56 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
	; --split [executed in 5 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l6A7A ; 2B:6A7A
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailView_DrawTextLine20_BlitBlankAdvance
	jr .l6A7A

MailView_DrawTextLine20_BlitGlyphAdvance:: ; 2B:6A89
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

MailView_DrawTextLine20_BlitBlankAdvance:: ; 2B:6A9D
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailView_DrawTextLine24:: ; 2B:6AB5
	ld a, $18
	ld [wTextCellsLeft], a
.l6ABA ; 2B:6ABA
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l6B5A
	cp a, $0D
	jr z, .l6B3F
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l6B1D

	; [PROBABLE] 40 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, .l6ADF
	pop af
	jp .l6B5A
.l6ADF ; 2B:6ADF
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
	call MailView_DrawTextLine24_BlitGlyphAdvance
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
	jr z, .l6B5A
	jp .l6ABA

.l6B1D ; 2B:6B1D
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
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
	call MailView_DrawTextLine24_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l6B5A
	jp .l6ABA

.l6B3F ; 2B:6B3F
	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
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
	call MailView_DrawTextLine24_BlitBlankAdvance

.l6B5A ; 2B:6B5A
	; [CONFIRMED] 59 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
	; --split [executed in 5 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l6B6B ; 2B:6B6B
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailView_DrawTextLine24_BlitBlankAdvance
	jr .l6B6B

MailView_DrawTextLine24_BlitGlyphAdvance:: ; 2B:6B7A
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

MailView_DrawTextLine24_BlitBlankAdvance:: ; 2B:6B8E
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailView_DrawTextLine16:: ; 2B:6BA6
	ld a, $10
	ld [wTextCellsLeft], a
.l6BAB ; 2B:6BAB
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, .l6C4B
	cp a, $0D
	jr z, .l6C30
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .l6C0E
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, .l6BD0

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
	pop af
	jp .l6C4B

.l6BD0 ; 2B:6BD0
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
	; --split [executed in 8 scenarios]
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
	call MailView_DrawTextLine16_BlitGlyphAdvance
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
	jr z, .l6C4B
	jp .l6BAB

.l6C0E ; 2B:6C0E
	; [PROBABLE] 30 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 69C5-6CF5 by apply_coverage --split
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
	call MailView_DrawTextLine16_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .l6C4B
	jp .l6BAB
.l6C30 ; 2B:6C30
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
	call MailView_DrawTextLine16_BlitBlankAdvance

.l6C4B ; 2B:6C4B
	; [CONFIRMED] 89 insn(s) executed; cut out of the PROBABLE region 69C5-6CF5 by apply_coverage
	; --split [executed in 8 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.l6C5C ; 2B:6C5C
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailView_DrawTextLine16_BlitBlankAdvance
	jr .l6C5C

MailView_DrawTextLine16_BlitGlyphAdvance:: ; 2B:6C6B
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

MailView_DrawTextLine16_BlitBlankAdvance:: ; 2B:6C7F
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailView_UploadTextTiles:: ; 2B:6C97
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_6CD5
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_6CD5
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_6CD5
	ld hl, $DC00
	ld de, $8C00
	ld c, $3F
	call Gfx_StartHDMAAtVBlank_2B_6CD5
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Gfx_StartHDMAAtVBlank_2B_6CD5:: ; 2B:6CD5
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l6CE4 ; 2B:6CE4
	ld a, [de]
	cp a, $8F
	jr nz, .l6CE4
	ld b, $91
.l6CEB ; 2B:6CEB
	ld a, [de]
	cp a, b
	jr nz, .l6CEB
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

Function_2B_6CF5:: ; 2B:6CF5
	; [HYPOTHESIS] function at 2B:6CF5 (push bc; ld a,1; ldh [$8D],a; ldh [$70],a; SRAM enable;
	; clears $24 bytes at $D400; ld hl,$6DB0 table index; ...) that flows into the PROBABLE code at
	; 6D6B; after the ret at 6CF4; no caller/pointer to 6CF5 found. Decode legal, all branch targets
	; valid | forced execution: 68/68 instruction starts ran in forced_dead (traces/forced/, not
	; natural evidence; status unchanged)
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $D400
	ld b, $24
.l6D0F ; 2B:6D0F
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l6D0F
	pop bc
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, Table_2B_6DB0
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	push hl
	ld de, $00ED
	add hl, de
	ld de, $D4C0
	ld b, $40
.l6D3E ; 2B:6D3E
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l6D3E
	pop hl
	ld de, $00C9
	add hl, de
	ld de, $D514
	ld b, $10
.l6D4E ; 2B:6D4E
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l6D4E
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $03
	ld [wMailComposeMode], a
	ld a, b
	ld [wRam_D525], a
	ld a, b
	ld [wRam_D526], a
	xor a, a
	jr .l6D6D

.l6D6B ; 2B:6D6B
	; [PROBABLE] 32 insn(s) reached by static flow only; seeds: site x32; min discovery hops 0;
	; entered by jrcc from 2B:6D84 (PROBABLE code) | forced execution: 1/32 instruction starts ran
	; in forced_dead (traces/forced/, not natural evidence; status unchanged)
	ld a, $01
.l6D6D ; 2B:6D6D
	farcall MailAddr_Edit
	cp a, $FF
	jr z, .l6DA3
	xor a, a
	jr .l6D7C
.l6D7A ; 2B:6D7A
	ld a, $01
.l6D7C ; 2B:6D7C
	farcall MailTitle_Entry
	cp a, $FF
	jr z, .l6D6B
	farcall MailBody_Edit
	cp a, $FF
	jr z, .l6D7A
	cp a, $00
	jr z, .l6DA3
	pop af
	pop af
	pop af
	pop af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D526]
	ld c, a
	ret
.l6DA3 ; 2B:6DA3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D526]
	ld c, a
	ld a, $FF
	ret

; ---- words $6DB0-$6DC8 (24 bytes) [PROBABLE] 12 words $A124..$AE13 (SRAM record bases); ld hl,$6DB0 at 2B:6D2A (hl=[table+2c], then + $00ED)

Table_2B_6DB0:: ; 2B:6DB0
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- zero $6DC8-$6DD0 (8 bytes) [PROBABLE] 8 bytes of $00 between the table and the tile block at 6DD0
	ds $8, $00
