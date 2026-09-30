; engine/mail_server/tidy_screen.asm
; bank 2E, $4B2E-$56E0 (2994 bytes); pinned by layout.link
; tidy-up screen: setup, mail info/field/date/number drawing, messages, timer

SECTION "engine/mail_server/tidy_screen", ROMX

; ---- code $4B2E-$4C58 (298 bytes) [CONFIRMED] 100 insn(s); 100 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerMgr_SetupScreen:: ; 2E:4B2E
Function_2E_4B2E::
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ld a, $F0
	ldh [rWY], a
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailServerMgr_Bg
	ld a, $2E
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $75D0
	ld a, $2E
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Gfx_MailServerMgr_Tiles0
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_MailServerMgr_Tiles1
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8801
	ld hl, Gfx_MailServerMgr_Tiles2
	ld a, $2E
	ld b, $97
	ld c, $12
	farcall Function_00_0787
	ld de, $8000
	ld hl, Gfx_MailServerMgr_Tiles5
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8A80
	ld hl, Gfx_MailServerMgr_Tiles3
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8E80
	ld hl, Gfx_MailServerMgr_Tiles4
	ld a, $2E
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_Main
	ld a, $2E
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld bc, $0614
	ld de, $D0A0
	ld hl, Tilemap_MailServerMgr_Footer
	ld a, $2E
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	call MailServerMgr_UpdateTimerDisplay
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000C
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	farcall Stat_DisableScrollSplit
	call Function_00_0464
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

; ---- code $4C58-$4DBF (359 bytes) [PROBABLE] 260 insn(s) reached by static flow only; seeds: exec x260; min discovery hops 9; entered by call from 2E:4AD4 (PROBABLE code) | 138 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C58-4EB2 by apply_coverage --split

MailServerMgr_RedrawScreen:: ; 2E:4C58
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ld a, $F0
	ldh [rWY], a
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailServerMgr_Bg
	ld a, $2E
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $75D0
	ld a, $2E
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Gfx_MailServerMgr_Tiles0
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_MailServerMgr_Tiles1
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8801
	ld hl, Gfx_MailServerMgr_Tiles2
	ld a, $2E
	ld b, $97
	ld c, $12
	farcall Function_00_0787
	ld de, $8000
	ld hl, Gfx_MailServerMgr_Tiles5
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8A80
	ld hl, Gfx_MailServerMgr_Tiles3
	ld a, $2E
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8E80
	ld hl, Gfx_MailServerMgr_Tiles4
	ld a, $2E
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_Main
	ld a, $2E
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld bc, $0614
	ld de, $D0A0
	ld hl, Tilemap_MailServerMgr_Footer
	ld a, $2E
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	call MailServerMgr_UpdateTimerDisplay
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D635
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld l, a
	ld a, [hl]
	ld h, a
	push hl
	push af
	call MailServerMgr_DrawMailInfo
	pop af
	call MailServerMgr_DrawMailDate
	call MailServerMgr_DrawMailFields
	pop hl
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
	pop bc
	ld a, c
	call MailServerMgr_ShowChoiceHelp
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000C
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	farcall Stat_DisableScrollSplit
	call Function_00_0464
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ret

; ---- code $4DBF-$4E3F (128 bytes) [CONFIRMED] 66 insn(s) executed; cut out of the PROBABLE region 4C58-4EB2 by apply_coverage --split [executed in 5 scenarios]

MailServerMgr_DrawMailInfo:: ; 2E:4DBF
	push bc
	push de
	push hl
	pop hl
	pop de
	pop bc
	call MailServerMgr_ClearTextTiles
	push bc
	push hl
	dec d
	jr z, Label_2E_4E3F
	ld a, e
	dec e
	jr z, Label_2E_4E08
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0800

Label_2E_4DDD:: ; 2E:4DDD
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2E_4DDD
	call MailServerMgr_UploadTextTiles
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_Main
	ld a, $2E
	farcall Function_00_08EA
	call MailServerMgr_DrawTimer
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	call Function_2E_4EB1
	pop hl
	pop bc
	ret

Label_2E_4E08:: ; 2E:4E08
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0800

Label_2E_4E14:: ; 2E:4E14
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2E_4E14
	call MailServerMgr_UploadTextTiles
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_InfoB
	ld a, $2E
	farcall Function_00_08EA
	call MailServerMgr_DrawTimer
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	call Function_2E_4EB1
	pop hl
	pop bc
	ret

; ---- code $4E3F-$4EB1 (114 bytes) [PROBABLE] 55 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C58-4EB2 by apply_coverage --split

Label_2E_4E3F:: ; 2E:4E3F
	ld a, e
	dec e
	jr z, Label_2E_4E7A
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0800

Label_2E_4E4F:: ; 2E:4E4F
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2E_4E4F
	call MailServerMgr_UploadTextTiles
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_InfoC
	ld a, $2E
	farcall Function_00_08EA
	call MailServerMgr_DrawTimer
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	call Function_2E_4EB1
	pop hl
	pop bc
	ret

Label_2E_4E7A:: ; 2E:4E7A
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0800

Label_2E_4E86:: ; 2E:4E86
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2E_4E86
	call MailServerMgr_UploadTextTiles
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailServerMgr_InfoD
	ld a, $2E
	farcall Function_00_08EA
	call MailServerMgr_DrawTimer
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	call Function_2E_4EB1
	pop hl
	pop bc
	ret

; ---- code $4EB1-$4EB2 (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4C58-4EB2 by apply_coverage --split [executed in 7 scenarios]

Function_2E_4EB1:: ; 2E:4EB1
	ret

; ---- code $4EB2-$4EBD (11 bytes) [HYPOTHESIS] complete 11-byte function (ld b,$3C ; loop: push bc ; call $0464 ; pop bc ; dec b ; jr nz ; ret): waits 60 x the 00:0464 routine (executed 21685 times, 13 scenarios); jr lands on its own instruction start; no caller found (entry unproven) [verifier: downgraded PROBABLE->HYPOTHESIS: complete-looking function with no caller, no table entry and no flow from/into proven code; "decodes cleanly" is not an entry]

Function_2E_4EB2:: ; 2E:4EB2
	ld b, $3C

Label_2E_4EB4:: ; 2E:4EB4
	push bc
	call Function_00_0464
	pop bc
	dec b
	jr nz, Label_2E_4EB4
	ret

; ---- code $4EBD-$4F25 (104 bytes) [CONFIRMED] 104 insn(s) reached by static flow only; seeds: exec x104; min discovery hops 9; entered by call from 2E:43D3 (PROBABLE code) | 40 insn(s) executed; cut out of the PROBABLE region 4EBD-4F9A by apply_coverage --split [executed in 7 scenarios]

MailServerMgr_DrawMailFields:: ; 2E:4EBD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld bc, $0300
	ld de, $0220
	ld hl, $D406
	farcall MailServerMgr_DrawFieldText
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $14
	ld bc, $0300
	ld de, $1220
	ld hl, $D4C0
	farcall MailServerMgr_DrawFieldText
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $14
	ld bc, $0300
	ld de, $2220
	ld hl, $D41B
	farcall MailServerMgr_DrawFieldText
	call MailServerMgr_UploadTextTiles
	ret

MailServerMgr_DrawFieldText:: ; 2E:4F06
	ld [wTextCellsLeft], a

Label_2E_4F09:: ; 2E:4F09
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jr z, Label_2E_4F88
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2E_4F66
	ld a, [wTextCellsLeft]
	cp a, $01
	jr nz, Label_2E_4F29

; ---- code $4F25-$4F29 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4EBD-4F9A by apply_coverage --split
	pop af
	jp Label_2E_4F88

; ---- code $4F29-$4F9A (113 bytes) [CONFIRMED] 62 insn(s) executed; cut out of the PROBABLE region 4EBD-4F9A by apply_coverage --split [executed in 7 scenarios]

Label_2E_4F29:: ; 2E:4F29
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailServerMgr_DrawFieldText_Glyph
	push bc
	push de
	push hl
	ld hl, $C0B8
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
	jr z, Label_2E_4F88
	jr Label_2E_4F09

Label_2E_4F66:: ; 2E:4F66
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailServerMgr_DrawFieldText_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2E_4F88
	jp Label_2E_4F09

Label_2E_4F88:: ; 2E:4F88
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_2E_4F99:: ; 2E:4F99
	ret

; ---- code $4F9A-$4FA9 (15 bytes) [HYPOTHESIS] complete function (ld a,[C2EE] ; cp 0 ; ret z ; dec a ; ld [C2EE],a ; call $4FA9 ; jr -> ret at 4F99): counted loop around the function 2E:4FA9, which is a PROBABLE entry (called from 2E:4F42); the jr target 4F99 is a ret inside the previous code region; no caller of 4F9A found [verifier: downgraded PROBABLE->HYPOTHESIS: complete-looking function with no caller, no table entry and no flow from/into proven code; "decodes cleanly" is not an entry]

Function_2E_4F9A:: ; 2E:4F9A
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailServerMgr_DrawFieldText_Glyph
	jr Label_2E_4F99

; ---- code $4FA9-$519A (497 bytes) [CONFIRMED] 528 insn(s) reached by static flow only; seeds: exec x528; min discovery hops 6; entered by call from 2E:4F42 (PROBABLE code) | 325 insn(s) executed; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split [executed in 7 scenarios]

MailServerMgr_DrawFieldText_Glyph:: ; 2E:4FA9
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailServerMgr_UploadTextTiles:: ; 2E:4FBD
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
	call MailServerMgr_HdmaBlock
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call MailServerMgr_HdmaBlock
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailServerMgr_HdmaBlock:: ; 2E:4FE5
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2E_4FF4:: ; 2E:4FF4
	ld a, [de]
	cp a, $8F
	jr nz, Label_2E_4FF4
	ld b, $91

Label_2E_4FFB:: ; 2E:4FFB
	ld a, [de]
	cp a, b
	jr nz, Label_2E_4FFB
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

MailServerMgr_DrawMailDate:: ; 2E:5005
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D400
	ld de, $D524
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $06

Label_2E_501A:: ; 2E:501A
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hl]
	swap a
	and a, $0F
	add a, $20
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	and a, $0F
	add a, $20
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	dec b
	jr nz, Label_2E_501A
	ld de, $9881
	ld hl, $D524
	xor a, a
	ldh [rVBK], a
	di

Label_2E_5057:: ; 2E:5057
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_2E_5057
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
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld de, $D081
	ld hl, $D524
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	inc de
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, [hli]
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [de], a
	pop bc
	ret

MailServerMgr_DrawMailNumber:: ; 2E:5184
	push hl
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $2710
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_2E_51FD

; ---- code $519A-$51FD (99 bytes) [PROBABLE] 45 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split
	ld a, l
	add a, $D0
	ld [wRam_D041], a
	add a, $10
	ld [wRam_D061], a
	push de
	pop hl
	ld de, $03E8
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D042], a
	add a, $10
	ld [wRam_D062], a
	push de
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D043], a
	add a, $10
	ld [wRam_D063], a
	push de
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D044], a
	add a, $10
	ld [wRam_D064], a
	push de
	pop hl
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D045], a
	add a, $10
	ld [wRam_D065], a
	ld e, $28
	jp Label_2E_52DC

; ---- code $51FD-$520D (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split [executed in 7 scenarios]

Label_2E_51FD:: ; 2E:51FD
	ld l, e
	ld h, d
	ld de, $03E8
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_2E_525A

; ---- code $520D-$525A (77 bytes) [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D041], a
	add a, $10
	ld [wRam_D061], a
	push de
	pop hl
	ld de, $0064
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D042], a
	add a, $10
	ld [wRam_D062], a
	push de
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D043], a
	add a, $10
	ld [wRam_D063], a
	push de
	pop hl
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D044], a
	add a, $10
	ld [wRam_D064], a
	ld e, $20
	jp Label_2E_52DC

; ---- code $525A-$526A (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split [executed in 7 scenarios]

Label_2E_525A:: ; 2E:525A
	ld l, e
	ld h, d
	ld de, $0064
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_2E_52A0

; ---- code $526A-$52A0 (54 bytes) [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D041], a
	add a, $10
	ld [wRam_D061], a
	push de
	pop hl
	ld de, $000A
	farcall Divide16
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D042], a
	add a, $10
	ld [wRam_D062], a
	push de
	pop hl
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D043], a
	add a, $10
	ld [wRam_D063], a
	ld e, $18
	jp Label_2E_52DC

; ---- code $52A0-$5300 (96 bytes) [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split [executed in 1 scenarios]

Label_2E_52A0:: ; 2E:52A0
	ld l, e
	ld h, d
	ld de, $000A
	farcall Divide16
	ld a, h
	or a, l
	jp z, Label_2E_52CF
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D041], a
	add a, $10
	ld [wRam_D061], a
	push de
	pop hl
	ld a, l
	ld a, l
	add a, $D0
	ld [wRam_D042], a
	add a, $10
	ld [wRam_D062], a
	ld e, $10
	jp Label_2E_52DC

Label_2E_52CF:: ; 2E:52CF
	ld a, e
	add a, $D0
	ld [wRam_D041], a
	add a, $10
	ld [wRam_D061], a
	ld e, $08

Label_2E_52DC:: ; 2E:52DC
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, e
	sub a, $20
	add a, $08
	add a, $08
	add a, $08
	add a, $08
	cp a, $08
	jr nz, Label_2E_52F7
	ld hl, $D042
	jr Label_2E_5315

Label_2E_52F7:: ; 2E:52F7
	cp a, $10
	jr nz, Label_2E_5300
	ld hl, $D043
	jr Label_2E_5315

; ---- code $5300-$5315 (21 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split

Label_2E_5300:: ; 2E:5300
	cp a, $18
	jr nz, Label_2E_5309
	ld hl, $D044
	jr Label_2E_5315

Label_2E_5309:: ; 2E:5309
	cp a, $20
	jr nz, Label_2E_5312
	ld hl, $D045
	jr Label_2E_5315

Label_2E_5312:: ; 2E:5312
	ld hl, $D046

; ---- code $5315-$533C (39 bytes) [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4FA9-533C by apply_coverage --split [executed in 7 scenarios]

Label_2E_5315:: ; 2E:5315
	push hl
	ld a, $DA
	ld [hli], a
	ld a, $DC
	ld [hli], a
	ld a, $DE
	ld [hli], a
	ld a, $EA
	ld [hl], a
	pop hl
	ld de, $0020
	add hl, de
	ld a, $DB
	ld [hli], a
	ld a, $DD
	ld [hli], a
	ld a, $DF
	ld [hli], a
	ld a, $EB
	ld [hl], a
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	pop hl
	ret

; ---- code $533C-$53A8 (108 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerMgr_ClearTextTiles:: ; 2E:533C
Function_2E_533C::
	push bc
	push de
	push hl
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $1000

Label_2E_534E:: ; 2E:534E
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2E_534E
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	farcall Gfx_GdmaAtVBlankNoDi
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	farcall Gfx_GdmaAtVBlankNoDi
	ld hl, $D800
	ld de, $8800
	ld c, $27
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	ret

MailServerMgr_ShowLoadingMsg:: ; 2E:538B
	push bc
	push hl
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $2E
	ld bc, $D000
	ld de, $D0C0
	ld hl, String_MailServerMgr_LoadingMail
	farcall TextTiles_RenderLine
	call MailServerMgr_UploadMessageTiles
	pop hl
	pop bc
	ret

; ---- text $53A8-$53C1 (25 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailServerMgr_LoadingMail:: ; 2E:53A8
String_2E_53A8::
	db $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $E6, $82, $DD, $82, $B1, $82, $F1, $82, $C5, $82, $A2, $82, $DC, $82, $B7, $00 ; "メールをよみこんでいます"

; ---- text $53C1-$53DA (25 bytes) [PROBABLE] second line of the message record (12 full-width spaces $8140 + NUL), same layout as 2E:5410/545F/55A8: line 1 string, blank line, then the function that far-calls the text drawer

String_2E_53C1:: ; 2E:53C1
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　"

; ---- code $53DA-$53EB (17 bytes) [PROBABLE] head of the message function (push bc ; push hl ; ld a,2 ; ldh [hFFB0],a ; ld a,$2E ; ld bc,$D000 ; ld de,$D0C0 ; ld hl,$53F7) continuing into the far-call site at 53EB and ending with ret at 53F6 before the string 2E:53F7; identical to the executed sibling 2E:5429; no caller found (entry unproven)

MailServerMgr_ShowNoMailMsg:: ; 2E:53DA
	push bc
	push hl
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $2E
	ld bc, $D000
	ld de, $D0C0
	ld hl, $53F7

; ---- code $53EB-$53F7 (12 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: site x5; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall TextTiles_RenderLine
	call MailServerMgr_UploadMessageTiles
	pop hl
	pop bc
	ret

; ---- text $53F7-$5410 (25 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailServerMgr_NoMail:: ; 2E:53F7
String_2E_53F7::
	db $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $00 ; "メールはありませんでした"

; ---- text $5410-$5429 (25 bytes) [PROBABLE] blank second line of a message record (12 full-width spaces $8140 + NUL) between the string before it and the message function after it (same as 2E:53C1); cp932-valid

String_2E_5410:: ; 2E:5410
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　"

; ---- code $5429-$5446 (29 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 12; entered by call from 2E:46BD (PROBABLE code) [executed in 3 scenarios]

MailServerMgr_ShowDeletingMsg:: ; 2E:5429
	push bc
	push hl
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $2E
	ld bc, $D000
	ld de, $D0C0
	ld hl, String_MailServerMgr_DeletingMail
	farcall TextTiles_RenderLine
	call MailServerMgr_UploadMessageTiles
	pop hl
	pop bc
	ret

; ---- text $5446-$545F (25 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailServerMgr_DeletingMail:: ; 2E:5446
String_2E_5446::
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $81, $40, $00 ; "　メールをけしています　"

; ---- text $545F-$5478 (25 bytes) [PROBABLE] blank second line of a message record (12 full-width spaces $8140 + NUL) between the string before it and the message function after it (same as 2E:53C1); cp932-valid

String_2E_545F:: ; 2E:545F
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　　　　　　　　　"

; ---- code $5478-$5498 (32 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerMgr_UploadMessageTiles:: ; 2E:5478
Function_2E_5478::
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $17
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

; ---- code $5498-$54F8 (96 bytes) [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 2; entered by call from 2E:4453 (PROBABLE code) [executed in 3 scenarios]

MailServerMgr_ShowChoiceHelp:: ; 2E:5498
	push bc
	push hl
	inc a
	ld e, a
	ld d, $00
	sla e
	ld hl, Table_MailServerMgr_HelpStrings
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $2E
	ld bc, $D800
	ld de, $D940
	farcall TextTiles_RenderLine
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D800
	ld de, $8800
	ld c, $27
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2E_54DE:: ; 2E:54DE
	ld a, [de]
	cp a, $8F
	jr nz, Label_2E_54DE
	di
	ld b, $91

Label_2E_54E6:: ; 2E:54E6
	ld a, [de]
	cp a, b
	jr nz, Label_2E_54E6
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop bc
	ret

; ---- ptrtable $54F8-$5504 (12 bytes) [PROBABLE] 6 x dw string pointers (5504, 552D, 5556, 557F, 55A8, 55D1; stride 41 = 20 full-width chars + NUL) indexed by 2*(a+1) at 2E:549A-54A6 (ld hl,$54F8 ; add hl,de ; ld a,[hli] ; ld h,[hl]); every target is a string start

Table_MailServerMgr_HelpStrings:: ; 2E:54F8
Table_2E_54F8::
	dw String_2E_5504
	dw String_MailServerMgr_HelpDeleteThis
	dw String_MailServerMgr_HelpLoadNext
	dw String_MailServerMgr_HelpStopTidy
	dw String_2E_55A8
	dw $55D1

; ---- text $5504-$552D (41 bytes) [PROBABLE] string 0 of the table 2E:54F8 (40 bytes of full-width spaces + NUL); 41-byte record like the CONFIRMED strings 552D-55A8

String_2E_5504:: ; 2E:5504
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "　　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- text $552D-$55A8 (123 bytes) [CONFIRMED] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailServerMgr_HelpDeleteThis:: ; 2E:552D
String_2E_552D::
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $B1, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $40, $81, $40 ; "　　　　このメールを　けします　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

String_MailServerMgr_HelpLoadNext:: ; 2E:5556
	db $81, $40, $81, $40, $81, $40, $82, $C2, $82, $AC, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $E6, $82, $DD, $82, $B1, $82, $DD, $82, $DC, $82, $B7 ; "　　　つぎのメールを　よみこみます"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

String_MailServerMgr_HelpStopTidy:: ; 2E:557F
	db $81, $40, $81, $40, $81, $40, $83, $54, $81, $5B, $83, $6F, $82, $CC, $82, $B9, $82, $A2, $82, $E8, $82, $F0, $81, $40, $82, $E2, $82, $DF, $82, $DC, $82, $B7, $81, $40 ; "　　　サーバのせいりを　やめます　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- text $55A8-$55FA (82 bytes) [PROBABLE] strings 4 and 5 of the table 2E:54F8 (55A8, 55D1: full-width spaces, 41 bytes each incl. NUL); cp932-valid, ends where the executed function 2E:55FA starts

String_2E_55A8:: ; 2E:55A8
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "　　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "　　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $55FA-$561C (34 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerMgr_UpdateTimerDisplay:: ; 2E:55FA
Function_2E_55FA::
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [rVBK], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerASeconds]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]
	cp a, b
	jr nz, Label_2E_5636
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- code $561C-$5636 (26 bytes) [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 10; entered by call from 2E:481F (PROBABLE code) [executed in 3 scenarios]

MailServerMgr_DrawTimer:: ; 2E:561C
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [rVBK], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerASeconds]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]

; ---- code $5636-$5641 (11 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_2E_5636:: ; 2E:5636
	ld a, b
	ld [wMailSessionBlock], a
	ld a, [wTimerAMinutes]
	cp a, $3C
	jr c, Label_2E_5683

; ---- code $5641-$565A (25 bytes) [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 2E:563F (executed)

Label_2E_5641:: ; 2E:5641
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D1EE
	ld a, $F5
	ld [hli], a
	ld a, $F9
	ld [hli], a
	inc hl
	ld a, $F5
	ld [hli], a
	ld a, $F9
	ld [hl], a
	jp Label_2E_56C5

; ---- code $565A-$5669 (15 bytes) [PROBABLE] first block of a twin of the executed block at 2E:5683: a=[C2D6]+$3C ; cp $64 ; jr nc,$5641 ; l=a ; h=0 ; de=$000A leading into the far-call site 5669 (00:0D67 with hl,de as in 5683); the jr target 5641 is a valid code start; reached only by a branch not found in the decoded code (follows the unconditional jp $56C5 at 5657)
	ld a, [wTimerAMinutes]
	add a, $3C
	cp a, $64
	jr nc, Label_2E_5641
	ld l, a
	ld h, $00
	ld de, $000A

; ---- code $5669-$5683 (26 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: site x11; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $F0
	ld [wRam_D1EE], a
	ld a, e
	add a, $F0
	ld [wRam_D1EF], a
	jr Label_2E_56A4

; ---- code $5683-$56D1 (78 bytes) [CONFIRMED] 37 insn(s); 37 executed (in up to 1/18 scenarios)

Label_2E_5683:: ; 2E:5683
	ld a, [wTimerAMinutes]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $F0
	ld [wRam_D1EE], a
	ld a, e
	add a, $F0
	ld [wRam_D1EF], a

Label_2E_56A4:: ; 2E:56A4
	ld a, [wTimerASeconds]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $F0
	ld [wRam_D1F1], a
	ld a, e
	add a, $F0
	ld [wRam_D1F2], a

Label_2E_56C5:: ; 2E:56C5
	di
	ldh a, [rLCDC]
	call Function_00_082C
	ei
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- zero $56D1-$56E0 (15 bytes) [PROBABLE] 15 x 00 padding after the ret at 2E:56D0 before the tile block 2E:56E0
	ds $F, $00
