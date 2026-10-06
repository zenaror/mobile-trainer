; engine/mail/mailbox.asm
; bank 25, $4000-$4B0D (2829 bytes); pinned by layout.link
; mailbox list (12 records): main loop, icon menu, cursor movement, record scanning

SECTION "engine/mail/mailbox", ROMX

Mailbox_Main:: ; 25:4000
Function_25_4000::
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push hl
	push de
	call VBlank_WaitAndService
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
	pop de
	pop hl
	ld a, [wMailScreenMode]
	inc a
	jr nz, .l403F

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 25:402C (executed) [executed in 3 scenarios]
	push bc
	dec h
	call z, Mailbox_LoadScreen
	call Mailbox_ShowRowNumbers
	call Mailbox_ShowRowStatusIcons
	pop bc
	call Mailbox_UpdateScrollArrows
	jr .l4042

.l403F ; 25:403F
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 1/18 scenarios)
	call Mailbox_LoadScreen
.l4042 ; 25:4042
	pop bc

Mailbox_Main_Loop:: ; 25:4043
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr nz, .l408A
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
	ld a, $FF
	ret

.l408A ; 25:408A
	; [CONFIRMED] 466 insn(s) reached by static flow only; seeds: exec x466; min discovery hops 1;
	; entered by jrcc from 25:405A (executed) | 307 insn(s) executed; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split [executed in 3 scenarios]
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l40DF
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
	ld a, [wMailScreenMode]
	inc a
	jp z, .l40C3
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sMailDraft_ToAddress
	ld a, [hl]
	cp a, $00
	jr nz, .l40C3
	ld a, $01
	jr .l40C5
.l40C3 ; 25:40C3
	ld a, $02
.l40C5 ; 25:40C5
	call Mailbox_SetIconBarAttrs
	ld de, $68D0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld de, $30D0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	pop de
	pop bc
	jp Mailbox_IconMenu_Enter
.l40DF ; 25:40DF
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l410D
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
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret
.l410D ; 25:410D
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, Mailbox_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, Mailbox_CursorDown
	jp Mailbox_Main_Loop

Mailbox_IconMenu_Enter:: ; 25:411E
Label_25_411E::
	push bc
	ld hl, wSpriteSlot1
	ld de, Mailbox_ObjTable
	ld a, BANK(Mailbox_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7020
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, wSpriteSlot2
	ld de, Mailbox_ObjTable_Entry4
	ld a, BANK(Mailbox_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7020
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ld d, $00
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	pop bc
	ld d, $00

Mailbox_IconMenu_Loop:: ; 25:415C
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l41C0
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
	ld de, $6848
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	pop de
	pop bc
	ld de, $70D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $70D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
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
.l41C0 ; 25:41C0
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, .l41E5
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
	dec d
	ld a, $FF
	cp a, d
	jr nz, .l41E2
	ld d, $02
.l41E2 ; 25:41E2
	call Mailbox_SetActionCursor
.l41E5 ; 25:41E5
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc d
	ld a, $03
	cp a, d
	jr nz, .l4207
	ld d, $00
.l4207 ; 25:4207
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
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $70D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, [wSpriteSlot4]
	ld d, a
	ld a, $D0
	ld [wSpriteSlot4], a
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
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, d
	ld [wSpriteSlot4], a
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
	call Sound_PlaySfx
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
	jr z, .l4341
	call Mailbox_RedrawAfterDelete
	push bc
	push de
	ld d, $FF
	call Mailbox_ShowHint
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr nz, .l4315

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint

.l4315 ; 25:4315
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage
	; --split [executed in 1 scenarios]
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	push bc
	ld a, b
	cp a, $00
	jr nz, .l4322
	jr .l433B
.l4322 ; 25:4322
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l433B ; 25:433B
	pop bc
	call Mailbox_UpdateScrollArrows
	jr .l4344

.l4341 ; 25:4341
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split
	call Mailbox_ShowEmptyList

.l4344 ; 25:4344
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	ld de, $70D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $70D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	pop bc
	call Mailbox_DrawMailCount
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $00
	jr nz, .l436D

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles

.l436D ; 25:436D
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, [wMailScreenMode]
	inc a
	jp nz, Mailbox_Main_Loop
	push de
	call Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $00
	jr nz, .l4386

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint
	jp .l4454

.l4386 ; 25:4386
	; [CONFIRMED] 93 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push de
	ld de, $70D0
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $70D0
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, [wSpriteSlot4]
	ld d, a
	ld a, $D0
	ld [wSpriteSlot4], a
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
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, d
	ld [wSpriteSlot4], a
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
	jp nz, .l4454
	ld de, $D020
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $D020
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	push bc
	push de
	ld d, $FF
	call Mailbox_ShowHint
	call Mailbox_CountRecords
	xor a, a
	cp a, d
	jr nz, .l444C

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 408A-446B by apply_coverage --split
	ld d, $03
	call Mailbox_ShowHint

.l444C ; 25:444C
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 408A-446B by apply_coverage
	; --split [executed in 1 scenarios]
	call Mailbox_UploadTextTiles
	pop de
	pop bc
	jp Mailbox_Main_Loop
.l4454 ; 25:4454
	push bc
	call Mailbox_UploadTextTiles
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- data $446B-$446E (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_446B:: ; 25:446B
	db $C3, $43, $40

Mailbox_IconMenu_ReplyOrRead:: ; 25:446E
	; [CONFIRMED] 223 insn(s) reached by static flow only; seeds: exec x223; min discovery hops 5;
	; entered by jpcc from 25:4214 (PROBABLE code) | 139 insn(s) executed; cut out of the PROBABLE
	; region 446E-4659 by apply_coverage --split [executed in 1 scenarios]
	cp a, $01
	jp nz, Mailbox_ReadMail
	ld a, [wMailScreenMode]
	inc a
	jr nz, .l4490
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
	jp Mailbox_IconMenu_Loop
.l4490 ; 25:4490
	farcall Sprites_SaveSlotsToBank3
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sMailDraft_ToAddress
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
	call Sound_PlaySfx
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
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, [wSpriteSlot4]
	ld d, a
	push de
	ld a, $E0
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld [wSpriteSlot4], a
	farcall Sprite_UpdateAll
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
	ld [wSpriteSlot4], a
	pop af
	push af
	ld a, $08
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, $70
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	farcall Sprite_UpdateAll
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push de
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	push bc
	farcall Sprites_SaveSlotsToBank3
	call Mailbox_ReplyToRecord

	; [PROBABLE] 84 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 446E-4659 by apply_coverage --split
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
	ld [wKbdSlideDeltaRow], a
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
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	pop af
	pop bc
	pop de
	ld h, $01
	cp a, $00
	jr nz, .l45D3
	ld d, $FF
	jp Mailbox_Main
.l45D3 ; 25:45D3
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
	jr nz, .l45E8
	jr .l4601
.l45E8 ; 25:45E8
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l4601 ; 25:4601
	ld hl, wSpriteSlot1
	ld de, Mailbox_ObjTable
	ld a, BANK(Mailbox_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, Mailbox_ObjTable_Entry4
	ld a, BANK(Mailbox_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld d, $01
	call Mailbox_ShowHint
	call Mailbox_UploadTextTiles
	ld de, $7020
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld de, $68D0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld de, $30D0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld d, $01
	call Mailbox_SetActionCursor
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $70
	ld [wSpriteSlot1], a
	pop bc
	pop de
	jp Mailbox_IconMenu_Loop

; ---- data $4659-$465C (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_4659:: ; 25:4659
	db $C3, $1E, $41

Mailbox_ReadMail:: ; 25:465C
	; [CONFIRMED] 202 insn(s) reached by static flow only; seeds: exec x202; min discovery hops 6;
	; entered by jpcc from 25:4470 (PROBABLE code) | 62 insn(s) executed; cut out of the PROBABLE
	; region 465C-47F8 by apply_coverage --split [executed in 1 scenarios]
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
	jp z, .l473D
	push af
	xor a, a
	ld [hl], a
	farcall SramCheck_Bank0Commit
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, [wSpriteSlot4]
	ld d, a
	pop af
	push de
	push af
	ld a, $E0
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	ld [wSpriteSlot4], a
	farcall Sprite_UpdateAll
	pop af
	ld de, $021E
	cp a, $01
	jr z, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 465C-47F8 by apply_coverage --split
	ld de, $022B

.skip ; 25:46DB
	; [CONFIRMED] 139 insn(s) executed; cut out of the PROBABLE region 465C-47F8 by apply_coverage
	; --split [executed in 1 scenarios]
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
	ld [wSpriteSlot4], a
	pop af
	push af
	ld a, $08
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot7 + $01], a
	ld [wSpriteSlot8 + $01], a
	ld [wSpriteSlot10 + $01], a
	ld [wSpriteSlot11 + $01], a
	ld [wSpriteSlot12 + $01], a
	ld a, $70
	ld [wSpriteSlot1], a
	ld [wSpriteSlot2], a
	farcall Sprite_UpdateAll
	pop af
.l473D ; 25:473D
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
	call VBlank_Wait
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	pop af
	pop de
	pop bc
	cp a, $FF
	jr nz, Mailbox_ReadMail_RestartList
	push de
	push bc
	ld d, $FF
	call Mailbox_LoadScreen
	push bc
	push de
	push hl
	ld de, $68D0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	ld de, $68D0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	pop hl
	pop de
	pop bc
	ld a, [wMailScreenMode]
	inc a
	jp z, .l47CA
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sMailDraft_ToAddress
	ld a, [hl]
	cp a, $00
	jr nz, .l47CA
	ld a, $01
	jr .l47CC
.l47CA ; 25:47CA
	ld a, $02
.l47CC ; 25:47CC
	call Mailbox_SetIconBarAttrs
	pop bc
	pop de
	push de
	push bc
	ld a, b
	cp a, $00
	jr nz, .l47DA
	jr .l47F3
.l47DA ; 25:47DA
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l47F3 ; 25:47F3
	pop bc
	pop de
	jp Mailbox_IconMenu_Enter

; ---- data $47F8-$47FD (5 bytes) [HYPOTHESIS] UNCLASSIFIED 5 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_25_47F8:: ; 25:47F8
	db $26, $01, $C3, $00, $40

Mailbox_ReadMail_RestartList:: ; 25:47FD
Label_25_47FD::
	; [CONFIRMED] 262 insn(s) reached by static flow only; seeds: exec x262; min discovery hops 1;
	; entered by jrcc from 25:4788 (PROBABLE code) | 138 insn(s) executed; cut out of the PROBABLE
	; region 47FD-4A15 by apply_coverage --split [executed in 1 scenarios]
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
.loop ; 25:480E
	dec l
	jr z, .l4815
	add a, $28
	jr .loop
.l4815 ; 25:4815
	ld [wSpriteSlot1 + $01], a
	push bc
	push de
	ld a, d
	cp a, $00
	jr nz, .l483A
	ld hl, wSpriteSlot2
	ld de, Mailbox_ObjTable_Entry4
	ld a, BANK(Mailbox_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7020
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	jr .l4878
.l483A ; 25:483A
	cp a, $01
	jr nz, .l4859
	ld hl, wSpriteSlot2
	ld de, Mailbox_ObjTable_Entry8
	ld a, BANK(Mailbox_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7048
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	jr .l4878
.l4859 ; 25:4859
	cp a, $02
	jr nz, .l4878
	ld hl, wSpriteSlot2
	ld de, Mailbox_ObjTable_Entry12
	ld a, BANK(Mailbox_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7070
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
	jr .l4878
.l4878 ; 25:4878
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
	jr nz, .l48B6
	ld a, b
	cp a, $00
	jr nz, .l48B4
	call Mailbox_CountRecords
	ld a, d
	cp a, $01
	jr z, .l48A5
	cp a, $02
	jr z, .l48A5
	cp a, $03
	jr z, .l48A5
	cp a, $04
	jr z, .l48A5
	jr .l48A5
.l48A5 ; 25:48A5
	dec d
	ld c, d
	ld b, $01
	ld a, d
	cp a, $04
	jr c, .l48B4
	sub a, $03
	ld b, a
	inc b
	ld c, $03
.l48B4 ; 25:48B4
	dec b
	inc c
.l48B6 ; 25:48B6
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
	jr nz, .l48E9
	jr .l4902
.l48E9 ; 25:48E9
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l4902 ; 25:4902
	pop bc
	call Mailbox_UpdateScrollArrows
	ret

Mailbox_CursorDown:: ; 25:4907
	call Mailbox_NextRecordUsed
	inc a
	dec a
	jr nz, .l492F
	ld a, b
	cp a, $00
	jr nz, .l4929
	call Mailbox_CountRecords
	ld a, d
	cp a, $01
	jr z, .l4929

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47FD-4A15 by apply_coverage --split
	cp a, $02
	jr z, .l4929
	cp a, $03
	jr z, .l4929
	cp a, $04
	jr z, .l4929
	jr .l4929

.l4929 ; 25:4929
	; [CONFIRMED] 117 insn(s) executed; cut out of the PROBABLE region 47FD-4A15 by apply_coverage
	; --split [executed in 2 scenarios]
	ld b, $00
	ld c, $FF
	jr .l4936
.l492F ; 25:492F
	ld a, c
	cp a, $03
	jr nz, .l4936
	inc b
	dec c
.l4936 ; 25:4936
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
	jr nz, .l4969
	jr .l4982
.l4969 ; 25:4969
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l4982 ; 25:4982
	pop bc
	call Mailbox_UpdateScrollArrows
	ret

Mailbox_UpdateScrollArrows:: ; 25:4987
	push bc
	push de
	call Mailbox_CountRecords
	ld a, d
	cp a, $00
	jr z, .l49D6
	cp a, $01
	jr z, .l49D6
	cp a, $02
	jr z, .l49D6
	cp a, $03
	jr z, .l49D6
	cp a, $04
	jr z, .l49D6
	ld hl, wSpriteSlot4
	ld de, Mailbox_ObjTable_Entry20
	ld a, BANK(Mailbox_ObjTable_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6848
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld de, Mailbox_ObjTable_Entry16
	ld a, BANK(Mailbox_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	pop de
	pop bc
	ret
.l49D6 ; 25:49D6
	ld de, $68D0
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld de, $30D0
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	pop de
	pop bc
	ret

Mailbox_NextRecordUsed:: ; 25:49EB
	push bc
	inc c
	ld a, c
	add a, b
	cp a, $0C
	jr nz, .l49F6
	xor a, a
	pop bc
	ret
.l49F6 ; 25:49F6
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

Mailbox_RedrawAfterDelete:: ; 25:4A2D
	; [CONFIRMED] 52 insn(s) reached by static flow only; seeds: exec x52; min discovery hops 5;
	; entered by call from 25:42FF (PROBABLE code) | 34 insn(s) executed; cut out of the PROBABLE
	; region 4A2D-4A90 by apply_coverage --split [executed in 1 scenarios]
	ld a, b
	cp a, $00
	jr z, .l4A36
	dec b
	inc c
	jr .l4A3C
.l4A36 ; 25:4A36
	ld a, c
	cp a, $00
	jr nz, .l4A3C
	inc c
.l4A3C ; 25:4A3C
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

Mailbox_ShowEmptyList:: ; 25:4A68
	; [PROBABLE] 18 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4A2D-4A90 by apply_coverage --split
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $0D00
.loop ; 25:4A75
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	call Mailbox_DrawTimestamp
	call Mailbox_UploadTextTiles
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	pop bc
	ret

Mailbox_CountRecords:: ; 25:4A90
Function_25_4A90::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
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

	; [CONFIRMED] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0;
	; fall-through of the retcc at 25:4AA5 (executed) [executed in 5 scenarios]
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
