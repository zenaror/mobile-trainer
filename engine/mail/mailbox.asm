; engine/mail/mailbox.asm
; bank 25, $4000-$4B0D (2829 bytes); pinned by layout.link
; mailbox list (12 records): main loop, icon menu, cursor movement, record scanning

SECTION "engine/mail/mailbox", ROMX

; ---- code $4000-$402E (46 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Mailbox_Main:: ; 25:4000
Function_25_4000::
	push bc
	push hl
	push de
	call Function_00_044B
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
	pop de
	pop hl
	ld a, [wMailScreenMode]
	inc a
	jr nz, Label_25_403F

; ---- code $402E-$403F (17 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 25:402C (executed) [executed in 3 scenarios]
	push bc
	dec h
	call z, Mailbox_LoadScreen
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	pop bc
	call Mailbox_UpdateScrollArrows
	jr Label_25_4042

; ---- code $403F-$408A (75 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 1/18 scenarios)

Label_25_403F:: ; 25:403F
	call Mailbox_LoadScreen

Label_25_4042:: ; 25:4042
	pop bc

Mailbox_Main_Loop:: ; 25:4043
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr nz, Label_25_408A
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Mailbox_Main_Loop
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- code $408A-$4310 (646 bytes) [CONFIRMED] 466 insn(s) reached by static flow only; seeds: exec x466; min discovery hops 1; entered by jrcc from 25:405A (executed) | 307 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 3 scenarios]

Label_25_408A:: ; 25:408A
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_25_40DF
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wMailScreenMode]
	inc a
	jp z, Label_25_40C3
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld a, [hl]
	cp a, $00
	jr nz, Label_25_40C3
	ld a, $01
	jr Label_25_40C5

Label_25_40C3:: ; 25:40C3
	ld a, $02

Label_25_40C5:: ; 25:40C5
	call Mailbox_SetIconBarAttrs
	ld de, $68D0
	ld hl, $DA40
	call Function_00_0A65
	ld de, $30D0
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	jp Label_25_411E

Label_25_40DF:: ; 25:40DF
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_25_410D
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

Label_25_410D:: ; 25:410D
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, Mailbox_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, Mailbox_CursorDown
	jp Mailbox_Main_Loop

Label_25_411E:: ; 25:411E
	push bc
	ld hl, $DA10
	ld de, Mailbox_ObjTable
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $7020
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $7B10
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $7020
	ld hl, $DA20
	call Function_00_0A65
	ld d, $00
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	pop bc
	ld d, $00

Mailbox_IconMenu_Loop:: ; 25:415C
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_25_41C0
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld de, $6848
	ld hl, $DA40
	call Function_00_0A65
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	ld de, $70D0
	ld hl, $DA10
	call Function_00_0A65
	ld de, $70D0
	ld hl, $DA20
	call Function_00_0A65
	xor a, a
	call Mailbox_SetIconBarAttrs
	push bc
	push de
	ld d, $FF
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	jp Mailbox_Main_Loop

Label_25_41C0:: ; 25:41C0
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, Label_25_41E5
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec d
	ld a, $FF
	cp a, d
	jr nz, Label_25_41E2
	ld d, $02

Label_25_41E2:: ; 25:41E2
	call Mailbox_SetActionCursor

Label_25_41E5:: ; 25:41E5
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, Mailbox_IconMenu_PressA
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc d
	ld a, $03
	cp a, d
	jr nz, Label_25_4207
	ld d, $00

Label_25_4207:: ; 25:4207
	call Mailbox_SetActionCursor

Mailbox_IconMenu_PressA:: ; 25:420A
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Mailbox_IconMenu_Loop
	ld a, d
	cp a, $02
	jp nz, Mailbox_IconMenu_ReplyOrRead
	push bc
	push de
	farcall Sprites_SaveSlotsToBank3
	ld de, $70D0
	ld hl, $DA10
	call Function_00_0A65
	ld de, $70D0
	ld hl, $DA20
	call Function_00_0A65
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, [wSpriteSlots + 64]
	ld d, a
	ld a, $D0
	ld [wSpriteSlots + 64], a
	push de
	ld de, $0206
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
	pop de
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $08
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, d
	ld [wSpriteSlots + 64], a
	farcall Sprites_RestoreSlotsFromBank3
	pop af
	pop de
	pop bc
	push af
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $01
	call nz, Mailbox_SetActionCursor
	push bc
	push de
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $01
	call nz, Mailbox_ShowRowStatusIcons
	pop de
	pop bc
	pop af
	dec a
	jp nz, Mailbox_IconMenu_Loop
	push bc
	ld a, b
	add a, c
	ld b, a
	farcall MailRecord_Delete
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0033
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	call Mailbox_SetIconBarAttrs
	pop de
	pop bc
	pop bc
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $00
	jr z, Label_25_4341
	call Mailbox_RedrawAfterDelete
	push bc
	push de
	ld d, $FF
	call Mailbox_ShowHint
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr nz, Label_25_4315

; ---- code $4310-$4315 (5 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint

; ---- code $4315-$4341 (44 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 1 scenarios]

Label_25_4315:: ; 25:4315
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_4322
	jr Label_25_433B

Label_25_4322:: ; 25:4322
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_433B:: ; 25:433B
	pop bc
	call Mailbox_UpdateScrollArrows
	jr Label_25_4344

; ---- code $4341-$4344 (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 408A-446B by apply_coverage --split

Label_25_4341:: ; 25:4341
	call Mailbox_ShowEmptyList

; ---- code $4344-$4365 (33 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 4 scenarios]

Label_25_4344:: ; 25:4344
	push bc
	ld de, $70D0
	ld hl, $DA10
	call Function_00_0A65
	ld de, $70D0
	ld hl, $DA20
	call Function_00_0A65
	pop bc
	call Mailbox_DrawMailCount
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $00
	jr nz, Label_25_436D

; ---- code $4365-$436D (8 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles

; ---- code $436D-$437E (17 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 2 scenarios]

Label_25_436D:: ; 25:436D
	ld a, [wMailScreenMode]
	inc a
	jp nz, Mailbox_Main_Loop
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $00
	jr nz, Label_25_4386

; ---- code $437E-$4386 (8 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint
	jp Label_25_4454

; ---- code $4386-$4447 (193 bytes) [CONFIRMED] 93 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 1 scenarios]

Label_25_4386:: ; 25:4386
	push bc
	push de
	ld de, $70D0
	ld hl, $DA10
	call Function_00_0A65
	ld de, $70D0
	ld hl, $DA20
	call Function_00_0A65
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, [wSpriteSlots + 64]
	ld d, a
	ld a, $D0
	ld [wSpriteSlots + 64], a
	push de
	ld de, $0221
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
	pop de
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $08
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, d
	ld [wSpriteSlots + 64], a
	pop af
	pop de
	pop bc
	push af
	ld d, $FF
	call Mailbox_SetActionCursor
	push bc
	push de
	call Mailbox_ShowRowStatusIcons
	pop de
	pop bc
	pop af
	dec a
	jp nz, Label_25_4454
	ld de, $D020
	ld hl, $DA10
	call Function_00_0A65
	ld de, $D020
	ld hl, $DA20
	call Function_00_0A65
	push bc
	push de
	ld d, $FF
	call Mailbox_ShowHint
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr nz, Label_25_444C

; ---- code $4447-$444C (5 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint

; ---- code $444C-$446B (31 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage --split [executed in 1 scenarios]

Label_25_444C:: ; 25:444C
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	jp Mailbox_Main_Loop

Label_25_4454:: ; 25:4454
	push bc
	call Mailbox_UploadTextTiles
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- data $446B-$446E (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_446B:: ; 25:446B
	db $C3, $43, $40

; ---- code $446E-$4594 (294 bytes) [CONFIRMED] 223 insn(s) reached by static flow only; seeds: exec x223; min discovery hops 5; entered by jpcc from 25:4214 (PROBABLE code) | 139 insn(s) executed; cut out of the PROBABLE region 446E-4659 by apply_coverage --split [executed in 1 scenarios]

Mailbox_IconMenu_ReplyOrRead:: ; 25:446E
	cp a, $01
	jp nz, Mailbox_ReadMail
	ld a, [wMailScreenMode]
	inc a
	jr nz, Label_25_4490
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	jp Mailbox_IconMenu_Loop

Label_25_4490:: ; 25:4490
	farcall Sprites_SaveSlotsToBank3
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld a, [hl]
	cp a, $00
	jp z, Mailbox_ReplyStart
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, [wSpriteSlots + 64]
	ld d, a
	push de
	ld a, $E0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld [wSpriteSlots + 64], a
	farcall Function_00_0956
	ld de, $0213
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
	pop de
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	ld [wSpriteSlots + 64], a
	pop af
	push af
	ld a, $08
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, $70
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	farcall Function_00_0956
	pop af
	pop de
	pop bc
	push bc
	push de
	call Mailbox_ShowRowStatusIcons
	pop de
	pop bc
	jp Mailbox_IconMenu_Loop

Mailbox_ReplyStart:: ; 25:4564
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push de
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	push bc
	farcall Sprites_SaveSlotsToBank3
	call Mailbox_ReplyToRecord

; ---- code $4594-$4659 (197 bytes) [PROBABLE] 84 insn(s) never executed in the traced runs; cut out of the PROBABLE region 446E-4659 by apply_coverage --split
	push af
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
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0007
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	pop af
	pop bc
	pop de
	ld h, $01
	cp a, $00
	jr nz, Label_25_45D3
	ld d, $FF
	jp Mailbox_Main

Label_25_45D3:: ; 25:45D3
	push de
	push bc
	ld d, $01
	call Mailbox_LoadScreen
	ld a, $01
	call Mailbox_SetIconBarAttrs
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_45E8
	jr Label_25_4601

Label_25_45E8:: ; 25:45E8
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_4601:: ; 25:4601
	ld hl, $DA10
	ld de, Mailbox_ObjTable
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, $7B10
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld d, $01
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	ld de, $7020
	ld hl, $DA10
	call Function_00_0A65
	ld de, $68D0
	ld hl, $DA40
	call Function_00_0A65
	ld de, $30D0
	ld hl, $DA30
	call Function_00_0A65
	ld d, $01
	call Mailbox_SetActionCursor
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $70
	ld [wSpriteSlots + 16], a
	pop bc
	pop de
	jp Mailbox_IconMenu_Loop

; ---- data $4659-$465C (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_4659:: ; 25:4659
	db $C3, $1E, $41

; ---- code $465C-$46D8 (124 bytes) [CONFIRMED] 202 insn(s) reached by static flow only; seeds: exec x202; min discovery hops 6; entered by jpcc from 25:4470 (PROBABLE code) | 62 insn(s) executed; cut out of the PROBABLE region 465C-47F8 by apply_coverage --split [executed in 1 scenarios]

Mailbox_ReadMail:: ; 25:465C
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	push de
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld hl, Mailbox_RecordAddrs_4A15
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	inc hl
	ld a, [hl]
	cp a, $00
	jp z, Label_25_473D
	push af
	xor a, a
	ld [hl], a
	farcall SramCheck_Bank0Commit
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, [wSpriteSlots + 64]
	ld d, a
	pop af
	push de
	push af
	ld a, $E0
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld [wSpriteSlots + 64], a
	farcall Function_00_0956
	pop af
	ld de, $021E
	cp a, $01
	jr z, Label_25_46DB

; ---- code $46D8-$46DB (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 465C-47F8 by apply_coverage --split
	ld de, $022B

; ---- code $46DB-$47F8 (285 bytes) [CONFIRMED] 139 insn(s) executed; cut out of the PROBABLE region 465C-47F8 by apply_coverage --split [executed in 1 scenarios]

Label_25_46DB:: ; 25:46DB
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
	pop de
	push af
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, d
	ld [wSpriteSlots + 64], a
	pop af
	push af
	ld a, $08
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 113], a
	ld [wSpriteSlots + 129], a
	ld [wSpriteSlots + 161], a
	ld [wSpriteSlots + 177], a
	ld [wSpriteSlots + 193], a
	ld a, $70
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	farcall Function_00_0956
	pop af

Label_25_473D:: ; 25:473D
	pop de
	pop bc
	push bc
	push de
	call Mailbox_ShowRowStatusIcons
	pop de
	pop bc
	push bc
	push de
	ld a, c
	add a, b
	ld c, a
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	farcall MailView_SenderPage
	push af
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
	pop af
	pop de
	pop bc
	cp a, $FF
	jr nz, Label_25_47FD
	push de
	push bc
	ld d, $FF
	call Mailbox_LoadScreen
	push bc
	push de
	push hl
	ld de, $68D0
	ld hl, $DA30
	call Function_00_0A65
	ld de, $68D0
	ld hl, $DA40
	call Function_00_0A65
	pop hl
	pop de
	pop bc
	ld a, [wMailScreenMode]
	inc a
	jp z, Label_25_47CA
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld a, [hl]
	cp a, $00
	jr nz, Label_25_47CA
	ld a, $01
	jr Label_25_47CC

Label_25_47CA:: ; 25:47CA
	ld a, $02

Label_25_47CC:: ; 25:47CC
	call Mailbox_SetIconBarAttrs
	pop bc
	pop de
	push de
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_47DA
	jr Label_25_47F3

Label_25_47DA:: ; 25:47DA
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_47F3:: ; 25:47F3
	pop bc
	pop de
	jp Label_25_411E

; ---- data $47F8-$47FD (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_47F8:: ; 25:47F8
	db $26, $01, $C3, $00, $40

; ---- code $47FD-$491B (286 bytes) [CONFIRMED] 262 insn(s) reached by static flow only; seeds: exec x262; min discovery hops 1; entered by jrcc from 25:4788 (PROBABLE code) | 138 insn(s) executed; cut out of the PROBABLE region 47FD-4A15 by apply_coverage --split [executed in 1 scenarios]

Label_25_47FD:: ; 25:47FD
	ld h, $01
	ld d, $FF
	jp Mailbox_Main

Mailbox_SetActionCursor:: ; 25:4804
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld l, d
	ld a, $20
	inc l

Label_25_480E:: ; 25:480E
	dec l
	jr z, Label_25_4815
	add a, $28
	jr Label_25_480E

Label_25_4815:: ; 25:4815
	ld [wSpriteSlots + 17], a
	push bc
	push de
	ld a, d
	cp a, $00
	jr nz, Label_25_483A
	ld hl, $DA20
	ld de, $7B10
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $7020
	ld hl, $DA20
	call Function_00_0A65
	jr Label_25_4878

Label_25_483A:: ; 25:483A
	cp a, $01
	jr nz, Label_25_4859
	ld hl, $DA20
	ld de, $7B20
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $7048
	ld hl, $DA20
	call Function_00_0A65
	jr Label_25_4878

Label_25_4859:: ; 25:4859
	cp a, $02
	jr nz, Label_25_4878
	ld hl, $DA20
	ld de, $7B30
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $7070
	ld hl, $DA20
	call Function_00_0A65
	jr Label_25_4878

Label_25_4878:: ; 25:4878
	pop de
	pop bc
	push bc
	push de
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	ret

Mailbox_CursorUp:: ; 25:4885
	ld a, c
	cp a, $00
	jr nz, Label_25_48B6
	ld a, b
	cp a, $00
	jr nz, Label_25_48B4
	call Mailbox_CountRecords
	ld a, d
	cp a, $01
	jr z, Label_25_48A5
	cp a, $02
	jr z, Label_25_48A5
	cp a, $03
	jr z, Label_25_48A5
	cp a, $04
	jr z, Label_25_48A5
	jr Label_25_48A5

Label_25_48A5:: ; 25:48A5
	dec d
	ld c, d
	ld b, $01
	ld a, d
	cp a, $04
	jr c, Label_25_48B4
	sub a, $03
	ld b, a
	inc b
	ld c, $03

Label_25_48B4:: ; 25:48B4
	dec b
	inc c

Label_25_48B6:: ; 25:48B6
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	push bc
	call Mailbox_DrawSenderName
	call Mailbox_DrawRowTitles
	call Mailbox_UploadTextTiles
	pop bc
	push bc
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	call Mailbox_DrawTimestamp
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_48E9
	jr Label_25_4902

Label_25_48E9:: ; 25:48E9
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_4902:: ; 25:4902
	pop bc
	call Mailbox_UpdateScrollArrows
	ret

Mailbox_CursorDown:: ; 25:4907
	call Mailbox_NextRecordUsed
	inc a
	dec a
	jr nz, Label_25_492F
	ld a, b
	cp a, $00
	jr nz, Label_25_4929
	call Mailbox_CountRecords
	ld a, d
	cp a, $01
	jr z, Label_25_4929

; ---- code $491B-$4929 (14 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47FD-4A15 by apply_coverage --split
	cp a, $02
	jr z, Label_25_4929
	cp a, $03
	jr z, Label_25_4929
	cp a, $04
	jr z, Label_25_4929
	jr Label_25_4929

; ---- code $4929-$4A15 (236 bytes) [CONFIRMED] 117 insn(s) executed; cut out of the PROBABLE region 47FD-4A15 by apply_coverage --split [executed in 2 scenarios]

Label_25_4929:: ; 25:4929
	ld b, $00
	ld c, $FF
	jr Label_25_4936

Label_25_492F:: ; 25:492F
	ld a, c
	cp a, $03
	jr nz, Label_25_4936
	inc b
	dec c

Label_25_4936:: ; 25:4936
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	push bc
	call Mailbox_DrawSenderName
	call Mailbox_DrawRowTitles
	call Mailbox_UploadTextTiles
	pop bc
	push bc
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	call Mailbox_DrawTimestamp
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, Label_25_4969
	jr Label_25_4982

Label_25_4969:: ; 25:4969
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65

Label_25_4982:: ; 25:4982
	pop bc
	call Mailbox_UpdateScrollArrows
	ret

Mailbox_UpdateScrollArrows:: ; 25:4987
	push bc
	push de
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr z, Label_25_49D6
	cp a, $01
	jr z, Label_25_49D6
	cp a, $02
	jr z, Label_25_49D6
	cp a, $03
	jr z, Label_25_49D6
	cp a, $04
	jr z, Label_25_49D6
	ld hl, $DA40
	ld de, $7B50
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $6848
	ld hl, $DA40
	call Function_00_0A65
	ld hl, $DA30
	ld de, $7B40
	ld a, $26
	ld b, $81
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	ret

Label_25_49D6:: ; 25:49D6
	ld de, $68D0
	ld hl, $DA40
	call Function_00_0A65
	ld de, $30D0
	ld hl, $DA30
	call Function_00_0A65
	pop de
	pop bc
	ret

Mailbox_NextRecordUsed:: ; 25:49EB
	push bc
	inc c
	ld a, c
	add a, b
	cp a, $0C
	jr nz, Label_25_49F6
	xor a, a
	pop bc
	ret

Label_25_49F6:: ; 25:49F6
	ld a, b
	add a, c
	sla a
	ld c, a
	ld b, $00
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, Mailbox_RecordAddrs_4A15
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop bc
	ld a, [hl]
	ret

; ---- words $4A15-$4A2D (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with 25:4687 and 25:4A0B (ld hl,$4A15; add hl,bc; ld a,[hli]; ld h,[hl]; ld l,a)

Mailbox_RecordAddrs_4A15:: ; 25:4A15
Table_25_4A15::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13

; ---- code $4A2D-$4A68 (59 bytes) [CONFIRMED] 52 insn(s) reached by static flow only; seeds: exec x52; min discovery hops 5; entered by call from 25:42FF (PROBABLE code) | 34 insn(s) executed; cut out of the PROBABLE region 4A2D-4A90 by apply_coverage --split [executed in 1 scenarios]

Mailbox_RedrawAfterDelete:: ; 25:4A2D
	ld a, b
	cp a, $00
	jr z, Label_25_4A36
	dec b
	inc c
	jr Label_25_4A3C

Label_25_4A36:: ; 25:4A36
	ld a, c
	cp a, $00
	jr nz, Label_25_4A3C
	inc c

Label_25_4A3C:: ; 25:4A3C
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	push bc
	call Mailbox_DrawSenderName
	call Mailbox_DrawRowTitles
	call Mailbox_UploadTextTiles
	pop bc
	push bc
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	call Mailbox_DrawTimestamp
	pop bc
	ret

; ---- code $4A68-$4A90 (40 bytes) [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4A2D-4A90 by apply_coverage --split

Mailbox_ShowEmptyList:: ; 25:4A68
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0D00

Label_25_4A75:: ; 25:4A75
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_25_4A75
	call Mailbox_DrawTimestamp
	call Mailbox_UploadTextTiles
	farcall Function_00_09B6
	farcall Function_00_0956
	pop bc
	ret

; ---- code $4A90-$4AA6 (22 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 5/18 scenarios); entry proven: target of an executed call/far call

Mailbox_CountRecords:: ; 25:4A90
Function_25_4A90::
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld d, $00
	ld a, [sSram_MailRecords]
	cp a, $00
	ret z

; ---- code $4AA6-$4AF5 (79 bytes) [CONFIRMED] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0; fall-through of the retcc at 25:4AA5 (executed) [executed in 5 scenarios]
	inc d
	ld a, [sSram_MailRecords + 301]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 602]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 903]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 1204]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 1505]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 1806]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 2107]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 2408]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 2709]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 3010]
	cp a, $00
	ret z
	inc d
	ld a, [sSram_MailRecords + 3311]
	cp a, $00
	ret z
	inc d
	ret

; ---- words $4AF5-$4B0D (24 bytes) [PROBABLE] 12 SRAM record addresses $A124..$AE13, constant stride $12D (301), verified arithmetic progression; indexed table read with no direct ld hl,imm found (identical 12 words to the tables at 25:4A15/4E2B)

Mailbox_RecordAddrs_4AF5:: ; 25:4AF5
Table_25_4AF5::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13
