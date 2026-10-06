; engine/mail/result_screens.asm
; bank 29, $4000-$5090 (4240 bytes); pinned by layout.link
; communication result and server status screens: strings, number formatters, 3 status tiles (5060, loaded by 29:4686)

SECTION "engine/mail/result_screens", ROMX

MailResult_Screen:: ; 29:4000
Function_29_4000::
	; [CONFIRMED] 167 insn(s); 167 executed (in up to 1/18 scenarios); entry proven: target of an
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
	call MailResult_InitScreen
	ld hl, wSpriteSlot2
	ld de, MailResult_ObjTable
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3038
	ld hl, wSpriteSlot2
	call Sprite_SetPosition
.loop ; 29:403C
	push bc
	push hl
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop hl
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .loop
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
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MailResult_InitScreen:: ; 29:407A
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ld a, $F0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $DB
	ldh [rLCDC], a
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailResult_BgPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailResult_ObjPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld de, $8801
	ld hl, MailResult_Tiles_6BF0
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, MailResult_Tiles_6FF0
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, MailResult_Tiles_73F0
	ld a, $24
	ld b, $98
	ld c, $0A
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, MailResult_Tiles_7490
	ld a, $24
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailResult_Tilemap
	ld a, $24
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall LCDOn
	ld hl, wSpriteSlot1
	ld de, $7B30
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3038
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000E
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
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
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld a, [hli]
	ld d, a
	ld e, a
	call MailResult_ShowSentMessage
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	call MailResult_ShowReceivedMessage
	ret

MailResult_ShowSentMessage:: ; 29:41AD
	ld a, d
	or a, e
	jr nz, .l41B6
	ld hl, $423B
	jr .l41CD

.l41B6 ; 29:41B6
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 29:41AF (executed) [executed in 1 scenarios]
	inc de
	ld a, d
	or a, e
	jr nz, .l41C0
	ld hl, MailResult_Txt_SendFailed
	jr .l41CD
.l41C0 ; 29:41C0
	ld a, $03
	cp a, e
	jr nz, .l41CA
	ld hl, $426B
	jr .l41CD
.l41CA ; 29:41CA
	ld hl, MailResult_Txt_SentOk

.l41CD ; 29:41CD
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D524
.l41D6 ; 29:41D6
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l41D6
	ld hl, $D526
.l41E0 ; 29:41E0
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	push af
	xor a, a
	ld [hl], a
	push hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $D524
	ld bc, $D000
	ld de, $D100
	farcall TextTiles_RenderLine
	farcall MailResult_UploadTextTiles
	call VBlank_Wait
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop af
	ld [hli], a
	inc hl
	cp a, $00
	jr nz, .l41E0
	ret

; ---- text $421E-$4286 (104 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailResult_Txt_SendFailed:: ; 29:421E
String_29_421E::
	db "おくるのにしっぱいしました！", 0

MailResult_Txt_NothingSent:: ; 29:423B
	db "メールはおくっていません", 0

MailResult_Txt_SentOk:: ; 29:4254
	db "ちゃんとおくれました！", 0

MailResult_Txt_SentUnsure:: ; 29:426B
	db "おくれているかわかりません", 0
POPC

MailResult_ShowReceivedMessage:: ; 29:4286
Function_29_4286::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, d
	or a, e
	jr nz, .l429F
	ld hl, MailResult_Txt_NothingArrived
	push de
	farcall Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $0C
	jr nz, .l42AF

	; [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 29:4298 (executed) | 2 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 429A-42AF by apply_coverage --split
	ld hl, MailResult_Txt_CannotReceive
	jr .l42AF

.l429F ; 29:429F
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 429A-42AF by apply_coverage
	; --split [executed in 5 scenarios]
	inc de
	ld a, d
	or a, e
	jr nz, .l42A9
	ld hl, MailResult_Txt_ReceiveFailed
	jr .l42AF
.l42A9 ; 29:42A9
	ld hl, $433C
	call MailResult_SetReceivedSprite

.l42AF ; 29:42AF
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 1/18 scenarios)
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D524
.l42B8 ; 29:42B8
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l42B8
	ld hl, $D526
.l42C2 ; 29:42C2
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	push af
	xor a, a
	ld [hl], a
	push hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $D524
	ld bc, $D200
	ld de, $D300
	farcall TextTiles_RenderLine
	farcall MailResult_UploadTextTiles
	farcall Sprite_UpdateAll
	call VBlank_Wait
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop af
	ld [hli], a
	inc hl
	cp a, $00
	jr nz, .l42C2
	ret

; ---- text $4306-$4374 (110 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailResult_Txt_ReceiveFailed:: ; 29:4306
String_29_4306::
	db "うけとりにしっぱいしました！", 0

MailResult_Txt_NothingArrived:: ; 29:4323
	db "メールはとどいていません", 0

MailResult_Txt_ArrivedCount:: ; 29:433C
	db "　　つうとどいています！！", 0

MailResult_Txt_CannotReceive:: ; 29:4357
	db "メールはうけとれませんでした", 0
POPC

MailResult_SetReceivedSprite:: ; 29:4374
	; [CONFIRMED] 138 insn(s) reached by static flow only; seeds: exec x138; min discovery hops 3;
	; entered by call from 29:42AC (PROBABLE code) | 18 insn(s) executed; cut out of the PROBABLE
	; region 4374-44F6 by apply_coverage --split [executed in 2 scenarios]
	push bc
	push de
	push hl
	ld a, e
	dec a
	cp a, $01
	jr nz, .l4399
	ld hl, wSpriteSlot3
	ld de, $7B40
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2
.l4399 ; 29:4399
	cp a, $02
	jr nz, .l43B9

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7B50
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l43B9 ; 29:43B9
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $03
	jr nz, .l43D9
	ld hl, wSpriteSlot3
	ld de, $7B60
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2
.l43D9 ; 29:43D9
	cp a, $04
	jr nz, .l43F9
	ld hl, wSpriteSlot3
	ld de, $7B70
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2
.l43F9 ; 29:43F9
	cp a, $05
	jr nz, .l4419

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7B80
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l4419 ; 29:4419
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 2 scenarios]
	cp a, $06
	jr nz, .l4439

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7B90
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l4439 ; 29:4439
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 2 scenarios]
	cp a, $07
	jr nz, .l4459

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7BA0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l4459 ; 29:4459
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $08
	jr nz, .l4479
	ld hl, wSpriteSlot3
	ld de, $7BB0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2
.l4479 ; 29:4479
	cp a, $09
	jr nz, .l4499

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7BC0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3035
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l4499 ; 29:4499
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $0A
	jr nz, .l44B9

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7BD0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3037
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l44B9 ; 29:44B9
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $0B
	jr nz, .l44D9

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4374-44F6 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, $7BE0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3037
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
	jp .l44F2

.l44D9 ; 29:44D9
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, wSpriteSlot3
	ld de, $7BF0
	ld a, $24
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $3037
	ld hl, wSpriteSlot3
	call Sprite_SetPosition
.l44F2 ; 29:44F2
	pop hl
	pop de
	pop bc
	ret

MailServerStatus_Screen:: ; 29:44F6
Function_29_44F6::
	; [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an
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
	call MailServerStatus_InitScreen
.loop ; 29:4519
	push bc
	push hl
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop hl
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .loop
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
	ld a, [wMailScreenMode]
	cp a, $00
	jp nz, .l45E2

	; [CONFIRMED] 88 insn(s) reached by static flow only; seeds: exec x88; min discovery hops 0;
	; fall-through of the jpcc at 29:454B (executed) | 42 insn(s) executed; cut out of the PROBABLE
	; region 454E-45E2 by apply_coverage --split [executed in 1 scenarios]
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	push de
	ld de, $D631
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld b, a
	pop de
	add hl, bc
	ld a, h
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, a
	inc bc
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	ld a, h
	or a, l
	jr z, .l45E2
	ld a, l
	cp a, $01
	jr z, .l45A9
	cp a, $02
	jr z, .l45A9
	cp a, $03
	jr z, .l45A9

	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 454E-45E2 by apply_coverage --split
	cp a, $04
	jr z, .l45AE
	cp a, $05
	jr z, .l45AE
	cp a, $06
	jr z, .l45AE
	cp a, $07
	jr z, .l45AE
	cp a, $08
	jr z, .l45AE
	cp a, $09
	jr z, .l45AE
	cp a, $0A
	jr z, .l45AE
	ld de, $0226
	jr .l45B1

.l45A9 ; 29:45A9
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 454E-45E2 by apply_coverage
	; --split [executed in 3 scenarios]
	ld de, $0224
	jr .l45B1

.l45AE ; 29:45AE
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 454E-45E2 by apply_coverage --split
	ld de, $0225

.l45B1 ; 29:45B1
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 454E-45E2 by apply_coverage
	; --split [executed in 1 scenarios]
	push de
	pop de
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

.l45E2 ; 29:45E2
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	cp a, $00
	jr z, .l4605

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; fall-through of the jrcc at 29:45FD (executed) [executed in 2 scenarios]
	cp a, $FF
	jr z, .l4605
	xor a, a
	ret

.l4605 ; 29:4605
	; [CONFIRMED] 53 insn(s); 53 executed (in up to 2/18 scenarios)
	ld a, $FF
	ret

MailServerStatus_InitScreen:: ; 29:4608
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ld a, $F0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $DB
	ldh [rLCDC], a
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailServerStatus_BgPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld de, $9400
	ld hl, MailServerStatus_Tiles_7420
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, MailServerStatus_Tiles_6F30
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, MailServerStatus_Tiles_7330
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9301
	ld hl, MailServerStatus_Tiles_5060
	ld a, $29
	ld b, $98
	ld c, $03
	farcall Gfx_StartHDMAWithService
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l46CD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	cp a, $00
	jr z, .l46B9

	; [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0;
	; fall-through of the jrcc at 29:469F (executed) [executed in 2 scenarios]
	cp a, $FF
	jr z, .l46B9
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerStatus_Tilemap_Received
	ld a, $25
	farcall Tilemap_CopyRectAndAttr
	jp .l46DE

.l46B9 ; 29:46B9
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerStatus_Tilemap_NoneReceived
	ld a, $25
	farcall Tilemap_CopyRectAndAttr
	jp .l46DE
.l46CD ; 29:46CD
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerStatus_Tilemap_ServerMgmt
	ld a, $25
	farcall Tilemap_CopyRectAndAttr
.l46DE ; 29:46DE
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall LCDOn
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, .l46F5
	call MailServerStatus_DrawCounts_Mode0
	jr .l4701
.l46F5 ; 29:46F5
	cp a, $01
	jr nz, .l46FE

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:46F7 (executed) [executed in 3 scenarios]
	call MailServerStatus_DrawCounts_Mode1
	jr .l4701

.l46FE ; 29:46FE
	; [CONFIRMED] 56 insn(s); 56 executed (in up to 2/18 scenarios)
	call MailServerStatus_DrawCounts_Mode2
.l4701 ; 29:4701
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000E
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
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
	ret

MailServerStatus_DrawCounts_Mode0:: ; 29:4745
	push af
	push bc
	push de
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D637
	ld a, [de]
	cp a, $00
	jr nz, MailServerStatus_DrawCounts_Mode0_Unknown
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D627
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc hl
	ld a, h
	or a, l
	jp nz, MailServerStatus_DrawCounts_Mode0_Numbers

MailServerStatus_DrawCounts_Mode0_Unknown:: ; 29:476B
Label_29_476B::
	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0;
	; entered by jrcc from 29:4755 (executed) [executed in 4 scenarios]
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, MailServerStatus_Txt_Unknown
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, MailServerStatus_Txt_Unknown
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D140
	ld de, $D190
	ld hl, MailServerStatus_Txt_Unknown
	farcall TextTiles_RenderLine
	call MailServerStatus_UploadNumberTiles_Blank
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- text $47B2-$47BD (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '？' (81 48) + NUL; address loaded by 'ld hl,$47B2 at 29:47A1' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

PUSHC sjis
MailServerStatus_Txt_Unknown:: ; 29:47B2
String_29_47B2::
	db "？？？？？", 0
POPC

MailServerStatus_DrawCounts_Mode0_Numbers:: ; 29:47BD
Label_29_47BD::
	; [CONFIRMED] 116 insn(s); 116 executed (in up to 1/18 scenarios)
	push bc
	push de
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
	pop de
	pop bc
	dec hl
	push hl
	call MailServerStatus_FormatNumber_M0
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M0
	ld hl, $D000
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc de
	inc bc
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	push bc
	push de
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
	pop de
	pop bc
	push hl
	call MailServerStatus_FormatNumber_M0
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M0
	ld hl, $D0A0
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc de
	inc bc
	inc de
	inc de
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	push hl
	ld a, h
	cp a, $FF
	jr nz, .l487C

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 29:4871 (executed) [executed in 1 scenarios]
	ld a, l
	cp a, $FF
	jr nz, .l487C
	pop hl
	jp MailServerStatus_DrawCounts_Mode0_Unknown

.l487C ; 29:487C
	; [CONFIRMED] 67 insn(s); 67 executed (in up to 1/18 scenarios)
	pop hl
	add hl, bc
	push bc
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D62F
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc bc
	add hl, bc
	pop de
	pop bc
	push hl
	call MailServerStatus_FormatNumber_M0
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M0
	ld hl, $D140
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	call MailServerStatus_UploadNumberTiles_M0
	pop hl
	pop de
	pop bc
	pop af
	ret

MailServerStatus_FormatNumber_M0:: ; 29:48C3
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Data_MailServerStatus_NumberTemplate_M0
	ld de, $D524
.loop ; 29:48D1
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .loop
	pop bc
	pop hl
	push bc
	ld bc, $D525
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4934

	; [PROBABLE] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0;
	; fall-through of the jrcc at 29:48EC (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $05
	jp .l49D8

.l4934 ; 29:4934
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l497A

	; [PROBABLE] 35 insn(s) reached by static flow only; seeds: exec x35; min discovery hops 0;
	; fall-through of the jrcc at 29:4944 (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $04
	jp .l49D8

.l497A ; 29:497A
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l49AE

	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 29:498A (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $03
	jp .l49D8

.l49AE ; 29:49AE
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l49D0

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 29:49BE (executed) [executed in 2 scenarios]
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $02
	jp .l49D8

.l49D0 ; 29:49D0
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l49D8 ; 29:49D8
	pop bc
	ret

; ---- data $49DA-$49E5 (11 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown
; kept as raw bytes: the bytes read as Shift-JIS/ASCII text, but the header does not say `text` (executed-read data of unknown content class, or unclassified), so not provably a string

Data_MailServerStatus_NumberTemplate_M0:: ; 29:49DA
Data_29_49DA::
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00

MailServerStatus_NumberOffset_M0:: ; 29:49E5
Function_29_49E5::
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l49FB

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:49F3 (executed)
	ld bc, $0000
	jp .l4A42

.l49FB ; 29:49FB
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4A11

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4A09 (executed)
	ld bc, $0010
	jp .l4A42

.l4A11 ; 29:4A11
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4A27

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4A1F (executed)
	ld bc, $0020
	jp .l4A42

.l4A27 ; 29:4A27
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4A3D

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4A35 (executed) [executed in 2 scenarios]
	ld bc, $0030
	jp .l4A42

.l4A3D ; 29:4A3D
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)
	ld bc, $0040
	ld a, $01
.l4A42 ; 29:4A42
	pop hl
	pop de
	ret

MailServerStatus_UploadNumberTiles_M0:: ; 29:4A45
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $1F
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailServerStatus_DrawCounts_Mode1:: ; 29:4A65
	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1;
	; entered by call from 29:46F9 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE
	; region 4A65-4AC4 by apply_coverage --split [executed in 4 scenarios]
	push af
	push bc
	push de
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D627
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc hl
	ld a, h
	or a, l
	jp nz, MailServerStatus_DrawCounts_Mode1_Numbers

MailServerStatus_DrawCounts_Mode1_Unknown:: ; 29:4A7D
Label_29_4A7D::
	; [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4A65-4AC4 by apply_coverage --split
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, MailServerStatus_Txt_Unknown_M1
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, MailServerStatus_Txt_Unknown_M1
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D140
	ld de, $D190
	ld hl, MailServerStatus_Txt_Unknown_M1
	farcall TextTiles_RenderLine
	call MailServerStatus_UploadNumberTiles_Blank
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- text $4AC4-$4ACF (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '？' (81 48) + NUL; address loaded by 'ld hl,$4AC4' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

PUSHC sjis
MailServerStatus_Txt_Unknown_M1:: ; 29:4AC4
String_29_4AC4::
	db "？？？？？", 0
POPC

MailServerStatus_DrawCounts_Mode1_Numbers:: ; 29:4ACF
Label_29_4ACF::
	; [CONFIRMED] 279 insn(s) reached by static flow only; seeds: exec x279; min discovery hops 2;
	; entered by jpcc from 29:4A7A (PROBABLE code) | 71 insn(s) executed; cut out of the PROBABLE
	; region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]
	dec hl
	push hl
	call MailServerStatus_FormatNumber_M1
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M1
	ld hl, $D000
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc de
	inc bc
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	add hl, bc
	push hl
	call MailServerStatus_FormatNumber_M1
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M1
	ld hl, $D0A0
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D629
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	push hl
	ld a, h
	cp a, $FF
	jr nz, .l4B51

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4ACF-4C96 by apply_coverage --split
	ld a, l
	cp a, $FF
	jr nz, .l4B51
	pop hl
	jp MailServerStatus_DrawCounts_Mode1_Unknown

.l4B51 ; 29:4B51
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage
	; --split [executed in 4 scenarios]
	pop hl
	push hl
	call MailServerStatus_FormatNumber_M1
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M1
	ld hl, $D140
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	call MailServerStatus_UploadNumberTiles_M1
	pop hl
	pop de
	pop bc
	pop af
	ret

MailServerStatus_FormatNumber_M1:: ; 29:4B7F
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_MailServerStatus_NumberTemplate_M1
	ld de, $D524
.loop ; 29:4B8D
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .loop
	pop bc
	pop hl
	push bc
	ld bc, $D525
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4BF0

	; [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4ACF-4C96 by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $05
	jp .l4C94

.l4BF0 ; 29:4BF0
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4C36

	; [PROBABLE] 35 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4ACF-4C96 by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $04
	jp .l4C94

.l4C36 ; 29:4C36
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4C6A

	; [PROBABLE] 24 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4ACF-4C96 by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $03
	jp .l4C94

.l4C6A ; 29:4C6A
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4C8C

	; [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4ACF-4C96 by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $02
	jp .l4C94

.l4C8C ; 29:4C8C
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l4C94 ; 29:4C94
	pop bc
	ret

; ---- text $4C96-$4CA1 (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '０' (82 4f) + NUL; address loaded by 'ld hl,$4C96' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

PUSHC sjis
String_MailServerStatus_NumberTemplate_M1:: ; 29:4C96
String_29_4C96::
	db "０００００", 0
POPC

MailServerStatus_NumberOffset_M1:: ; 29:4CA1
	; [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 3;
	; entered by call from 29:4AD6 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE
	; region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4CB7

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CA1-4D21 by apply_coverage --split
	ld bc, $0000
	jp .l4CFE

.l4CB7 ; 29:4CB7
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4CCD

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CA1-4D21 by apply_coverage --split
	ld bc, $0010
	jp .l4CFE

.l4CCD ; 29:4CCD
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4CE3

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CA1-4D21 by apply_coverage --split
	ld bc, $0020
	jp .l4CFE

.l4CE3 ; 29:4CE3
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4CF9

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CA1-4D21 by apply_coverage --split
	ld bc, $0030
	jp .l4CFE

.l4CF9 ; 29:4CF9
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage
	; --split [executed in 4 scenarios]
	ld bc, $0040
	ld a, $01
.l4CFE ; 29:4CFE
	pop hl
	pop de
	ret

MailServerStatus_UploadNumberTiles_M1:: ; 29:4D01
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $1F
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailServerStatus_DrawCounts_Mode2:: ; 29:4D21
Function_29_4D21::
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	push de
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D627
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	inc hl
	ld a, h
	or a, l
	jp nz, MailServerStatus_DrawCounts_Mode2_Numbers

MailServerStatus_DrawCounts_Mode2_Unknown:: ; 29:4D39
Label_29_4D39::
	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0;
	; fall-through of the jpcc at 29:4D36 (executed) [executed in 2 scenarios]
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, MailServerStatus_Txt_Unknown_M2
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, MailServerStatus_Txt_Unknown_M2
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $29
	ld bc, $D140
	ld de, $D190
	ld hl, MailServerStatus_Txt_Unknown_M2
	farcall TextTiles_RenderLine
	call MailServerStatus_UploadNumberTiles_Blank
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- text $4D80-$4D8B (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '？' (81 48) + NUL; address loaded by 'ld hl,$4D80' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

PUSHC sjis
MailServerStatus_Txt_Unknown_M2:: ; 29:4D80
String_29_4D80::
	db "？？？？？", 0
POPC

MailServerStatus_DrawCounts_Mode2_Numbers:: ; 29:4D8B
Label_29_4D8B::
	; [CONFIRMED] 88 insn(s); 88 executed (in up to 1/18 scenarios)
	dec hl
	push bc
	push de
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
	pop de
	pop bc
	push hl
	call MailServerStatus_FormatNumber_M2
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M2
	ld hl, $D000
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	push hl
	call MailServerStatus_FormatNumber_M2
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M2
	ld hl, $D0A0
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D625
	ld a, [hli]
	xor a, $FF
	ld e, a
	ld a, [hli]
	xor a, $FF
	ld d, a
	inc de
	push de
	ld de, $D629
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	ld h, a
	pop de
	push hl
	ld a, h
	cp a, $FF
	jr nz, .l4E27

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 29:4E1C (executed)
	ld a, l
	cp a, $FF
	jr nz, .l4E27
	pop hl
	jp MailServerStatus_DrawCounts_Mode2_Unknown

.l4E27 ; 29:4E27
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios)
	pop hl
	push hl
	call MailServerStatus_FormatNumber_M2
	pop hl
	push hl
	call MailServerStatus_NumberOffset_M2
	ld hl, $D140
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0050
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	call MailServerStatus_UploadNumberTiles_M2
	pop hl
	pop de
	pop bc
	pop af
	ret

MailServerStatus_FormatNumber_M2:: ; 29:4E55
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, Data_MailServerStatus_NumberTemplate_M2
	ld de, $D524
.loop ; 29:4E63
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .loop
	pop bc
	pop hl
	push bc
	ld bc, $D525
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4EC6

	; [PROBABLE] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0;
	; fall-through of the jrcc at 29:4E7E (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $05
	jp .l4F6A

.l4EC6 ; 29:4EC6
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4F0C

	; [PROBABLE] 35 insn(s) reached by static flow only; seeds: exec x35; min discovery hops 0;
	; fall-through of the jrcc at 29:4ED6 (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $04
	jp .l4F6A

.l4F0C ; 29:4F0C
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4F40

	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 29:4F1C (executed)
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $03
	jp .l4F6A

.l4F40 ; 29:4F40
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4F62

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 29:4F50 (executed) [executed in 1 scenarios]
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $02
	jp .l4F6A

.l4F62 ; 29:4F62
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l4F6A ; 29:4F6A
	pop bc
	ret

; ---- data $4F6C-$4F77 (11 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown
; kept as raw bytes: the bytes read as Shift-JIS/ASCII text, but the header does not say `text` (executed-read data of unknown content class, or unclassified), so not provably a string

Data_MailServerStatus_NumberTemplate_M2:: ; 29:4F6C
Data_29_4F6C::
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00

MailServerStatus_NumberOffset_M2:: ; 29:4F77
Function_29_4F77::
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4F8D

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4F85 (executed)
	ld bc, $0000
	jp .l4FD4

.l4F8D ; 29:4F8D
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4FA3

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4F9B (executed)
	ld bc, $0010
	jp .l4FD4

.l4FA3 ; 29:4FA3
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4FB9

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4FB1 (executed)
	ld bc, $0020
	jp .l4FD4

.l4FB9 ; 29:4FB9
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4FCF

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 29:4FC7 (executed) [executed in 1 scenarios]
	ld bc, $0030
	jp .l4FD4

.l4FCF ; 29:4FCF
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)
	ld bc, $0040
	ld a, $01
.l4FD4 ; 29:4FD4
	pop hl
	pop de
	ret

MailServerStatus_UploadNumberTiles_M2:: ; 29:4FD7
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $1F
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailServerStatus_UploadNumberTiles_Blank:: ; 29:4FF7
	; [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 1;
	; entered by call from 29:47AA (PROBABLE code) [executed in 5 scenarios]
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $1F
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailResult_UploadTextTiles:: ; 29:5017
Function_29_5017::
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	call MailResult_StartHDMAAtVBlank
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call MailResult_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailResult_StartHDMAAtVBlank:: ; 29:503F
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l504E ; 29:504E
	ld a, [de]
	cp a, $8F
	jr nz, .l504E
	ld b, $91
.l5055 ; 29:5055
	ld a, [de]
	cp a, b
	jr nz, .l5055
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

; ---- zero $505F-$5060 (1 bytes) [PROBABLE] 1 byte of $00 padding between the code ending at 505E and the tiles at 5060
	ds $1, $00

; ---- gfx $5060-$5090 (48 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4686: hl=$5060 a=$29 c=$03 de=$9301 (dest VRAM $9300, vbank=1)

MailServerStatus_Tiles_5060:: ; 29:5060
Data_29_5060::
	INCBIN "gfx/mail/result_screens/mail_server_status_tiles_5060.2bpp"
