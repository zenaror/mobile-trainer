; engine/mail/result_screens.asm
; bank 29, $4000-$5090 (4240 bytes); pinned by layout.link
; communication result and server status screens: strings, number formatters, 3 status tiles (5060, loaded by 29:4686)

SECTION "engine/mail/result_screens", ROMX

; ---- code $4000-$41B6 (438 bytes) [CONFIRMED] 167 insn(s); 167 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailResult_Screen:: ; 29:4000
Function_29_4000::
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
	call MailResult_InitScreen
	ld hl, $DA20
	ld de, MailResult_ObjTable
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3038
	ld hl, $DA20
	call Function_00_0A65

Label_29_403C:: ; 29:403C
	push bc
	push hl
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop hl
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_29_403C
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
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

MailResult_InitScreen:: ; 29:407A
	farcall Function_00_09B6
	farcall Function_00_0956
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
	ld de, $D800
	ld hl, MailResult_BgPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, MailResult_ObjPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld de, $8801
	ld hl, MailResult_Tiles_6BF0
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, MailResult_Tiles_6FF0
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, MailResult_Tiles_73F0
	ld a, $24
	ld b, $98
	ld c, $0A
	farcall Function_00_0787
	ld de, $8000
	ld hl, MailResult_Tiles_7490
	ld a, $24
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, MailResult_Tilemap
	ld a, $24
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	ld hl, $DA10
	ld de, $7B30
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3038
	ld hl, $DA10
	call Function_00_0A65
	farcall Function_00_0956
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000E
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
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
	jr nz, Label_29_41B6
	ld hl, $423B
	jr Label_29_41CD

; ---- code $41B6-$41CD (23 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by jrcc from 29:41AF (executed) [executed in 1 scenarios]

Label_29_41B6:: ; 29:41B6
	inc de
	ld a, d
	or a, e
	jr nz, Label_29_41C0
	ld hl, MailResult_Txt_SendFailed
	jr Label_29_41CD

Label_29_41C0:: ; 29:41C0
	ld a, $03
	cp a, e
	jr nz, Label_29_41CA
	ld hl, $426B
	jr Label_29_41CD

Label_29_41CA:: ; 29:41CA
	ld hl, $4254

; ---- code $41CD-$421E (81 bytes) [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)

Label_29_41CD:: ; 29:41CD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D524

Label_29_41D6:: ; 29:41D6
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_29_41D6
	ld hl, $D526

Label_29_41E0:: ; 29:41E0
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
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $D524
	ld bc, $D000
	ld de, $D100
	farcall TextTiles_RenderLine
	farcall MailResult_UploadTextTiles
	call Function_00_0464
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop af
	ld [hli], a
	inc hl
	cp a, $00
	jr nz, Label_29_41E0
	ret

; ---- text $421E-$4286 (104 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailResult_Txt_SendFailed:: ; 29:421E
String_29_421E::
	db $82, $A8, $82, $AD, $82, $E9, $82, $CC, $82, $C9, $82, $B5, $82, $C1, $82, $CF, $82, $A2, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $49, $00 ; "おくるのにしっぱいしました！"

MailResult_Txt_NothingSent:: ; 29:423B
	db $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $A8, $82, $AD, $82, $C1, $82, $C4, $82, $A2, $82, $DC, $82, $B9, $82, $F1, $00 ; "メールはおくっていません"

MailResult_Txt_SentOk:: ; 29:4254
	db $82, $BF, $82, $E1, $82, $F1, $82, $C6, $82, $A8, $82, $AD, $82, $EA, $82, $DC, $82, $B5, $82, $BD, $81, $49, $00 ; "ちゃんとおくれました！"

MailResult_Txt_SentUnsure:: ; 29:426B
	db $82, $A8, $82, $AD, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $82, $A9, $82, $ED, $82, $A9, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $00 ; "おくれているかわかりません"

; ---- code $4286-$429A (20 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailResult_ShowReceivedMessage:: ; 29:4286
Function_29_4286::
	ld a, d
	or a, e
	jr nz, Label_29_429F
	ld hl, $4323
	push de
	farcall Mailbox_CountRecords
	ld a, d
	pop de
	cp a, $0C
	jr nz, Label_29_42AF

; ---- code $429A-$429F (5 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 29:4298 (executed) | 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 429A-42AF by apply_coverage --split
	ld hl, $4357
	jr Label_29_42AF

; ---- code $429F-$42AF (16 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 429A-42AF by apply_coverage --split [executed in 5 scenarios]

Label_29_429F:: ; 29:429F
	inc de
	ld a, d
	or a, e
	jr nz, Label_29_42A9
	ld hl, MailResult_Txt_ReceiveFailed
	jr Label_29_42AF

Label_29_42A9:: ; 29:42A9
	ld hl, $433C
	call MailResult_SetReceivedSprite

; ---- code $42AF-$4306 (87 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 1/18 scenarios)

Label_29_42AF:: ; 29:42AF
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D524

Label_29_42B8:: ; 29:42B8
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_29_42B8
	ld hl, $D526

Label_29_42C2:: ; 29:42C2
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
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $D524
	ld bc, $D200
	ld de, $D300
	farcall TextTiles_RenderLine
	farcall MailResult_UploadTextTiles
	farcall Function_00_0956
	call Function_00_0464
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop af
	ld [hli], a
	inc hl
	cp a, $00
	jr nz, Label_29_42C2
	ret

; ---- text $4306-$4374 (110 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailResult_Txt_ReceiveFailed:: ; 29:4306
String_29_4306::
	db $82, $A4, $82, $AF, $82, $C6, $82, $E8, $82, $C9, $82, $B5, $82, $C1, $82, $CF, $82, $A2, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $49, $00 ; "うけとりにしっぱいしました！"

MailResult_Txt_NothingArrived:: ; 29:4323
	db $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $C6, $82, $C7, $82, $A2, $82, $C4, $82, $A2, $82, $DC, $82, $B9, $82, $F1, $00 ; "メールはとどいていません"

MailResult_Txt_ArrivedCount:: ; 29:433C
	db $81, $40, $81, $40, $82, $C2, $82, $A4, $82, $C6, $82, $C7, $82, $A2, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $81, $49, $81, $49, $00 ; "　　つうとどいています！！"

MailResult_Txt_CannotReceive:: ; 29:4357
	db $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $A4, $82, $AF, $82, $C6, $82, $EA, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $00 ; "メールはうけとれませんでした"

; ---- code $4374-$439D (41 bytes) [CONFIRMED] 138 insn(s) reached by static flow only; seeds: exec x138; min discovery hops 3; entered by call from 29:42AC (PROBABLE code) | 18 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 2 scenarios]

MailResult_SetReceivedSprite:: ; 29:4374
	push bc
	push de
	push hl
	ld a, e
	dec a
	cp a, $01
	jr nz, Label_29_4399
	ld hl, $DA30
	ld de, $7B40
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

Label_29_4399:: ; 29:4399
	cp a, $02
	jr nz, Label_29_43B9

; ---- code $439D-$43B9 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7B50
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $43B9-$43FD (68 bytes) [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 1 scenarios]

Label_29_43B9:: ; 29:43B9
	cp a, $03
	jr nz, Label_29_43D9
	ld hl, $DA30
	ld de, $7B60
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

Label_29_43D9:: ; 29:43D9
	cp a, $04
	jr nz, Label_29_43F9
	ld hl, $DA30
	ld de, $7B70
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

Label_29_43F9:: ; 29:43F9
	cp a, $05
	jr nz, Label_29_4419

; ---- code $43FD-$4419 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7B80
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $4419-$441D (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 2 scenarios]

Label_29_4419:: ; 29:4419
	cp a, $06
	jr nz, Label_29_4439

; ---- code $441D-$4439 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7B90
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $4439-$443D (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 2 scenarios]

Label_29_4439:: ; 29:4439
	cp a, $07
	jr nz, Label_29_4459

; ---- code $443D-$4459 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7BA0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $4459-$447D (36 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 1 scenarios]

Label_29_4459:: ; 29:4459
	cp a, $08
	jr nz, Label_29_4479
	ld hl, $DA30
	ld de, $7BB0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

Label_29_4479:: ; 29:4479
	cp a, $09
	jr nz, Label_29_4499

; ---- code $447D-$4499 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7BC0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3035
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $4499-$449D (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 1 scenarios]

Label_29_4499:: ; 29:4499
	cp a, $0A
	jr nz, Label_29_44B9

; ---- code $449D-$44B9 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7BD0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3037
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $44B9-$44BD (4 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 1 scenarios]

Label_29_44B9:: ; 29:44B9
	cp a, $0B
	jr nz, Label_29_44D9

; ---- code $44BD-$44D9 (28 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split
	ld hl, $DA30
	ld de, $7BE0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3037
	ld hl, $DA30
	call Function_00_0A65
	jp Label_29_44F2

; ---- code $44D9-$44F6 (29 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 4374-44F6 by apply_coverage --split [executed in 1 scenarios]

Label_29_44D9:: ; 29:44D9
	ld hl, $DA30
	ld de, $7BF0
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld de, $3037
	ld hl, $DA30
	call Function_00_0A65

Label_29_44F2:: ; 29:44F2
	pop hl
	pop de
	pop bc
	ret

; ---- code $44F6-$454E (88 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailServerStatus_Screen:: ; 29:44F6
Function_29_44F6::
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
	call MailServerStatus_InitScreen

Label_29_4519:: ; 29:4519
	push bc
	push hl
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop hl
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_29_4519
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
	ld a, [wMailScreenMode]
	cp a, $00
	jp nz, Label_29_45E2

; ---- code $454E-$4588 (58 bytes) [CONFIRMED] 88 insn(s) reached by static flow only; seeds: exec x88; min discovery hops 0; fall-through of the jpcc at 29:454B (executed) | 42 insn(s) executed; cut out of the PROBABLE region 454E-45E2 by apply_coverage --split [executed in 1 scenarios]
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
	jr z, Label_29_45E2
	ld a, l
	cp a, $01
	jr z, Label_29_45A9
	cp a, $02
	jr z, Label_29_45A9
	cp a, $03
	jr z, Label_29_45A9

; ---- code $4588-$45A9 (33 bytes) [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region 454E-45E2 by apply_coverage --split
	cp a, $04
	jr z, Label_29_45AE
	cp a, $05
	jr z, Label_29_45AE
	cp a, $06
	jr z, Label_29_45AE
	cp a, $07
	jr z, Label_29_45AE
	cp a, $08
	jr z, Label_29_45AE
	cp a, $09
	jr z, Label_29_45AE
	cp a, $0A
	jr z, Label_29_45AE
	ld de, $0226
	jr Label_29_45B1

; ---- code $45A9-$45AE (5 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 454E-45E2 by apply_coverage --split [executed in 3 scenarios]

Label_29_45A9:: ; 29:45A9
	ld de, $0224
	jr Label_29_45B1

; ---- code $45AE-$45B1 (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 454E-45E2 by apply_coverage --split

Label_29_45AE:: ; 29:45AE
	ld de, $0225

; ---- code $45B1-$45E2 (49 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 454E-45E2 by apply_coverage --split [executed in 1 scenarios]

Label_29_45B1:: ; 29:45B1
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

; ---- code $45E2-$45FF (29 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_29_45E2:: ; 29:45E2
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	cp a, $00
	jr z, Label_29_4605

; ---- code $45FF-$4605 (6 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; fall-through of the jrcc at 29:45FD (executed) [executed in 2 scenarios]
	cp a, $FF
	jr z, Label_29_4605
	xor a, a
	ret

; ---- code $4605-$46A1 (156 bytes) [CONFIRMED] 53 insn(s); 53 executed (in up to 2/18 scenarios)

Label_29_4605:: ; 29:4605
	ld a, $FF
	ret

MailServerStatus_InitScreen:: ; 29:4608
	farcall Function_00_09B6
	farcall Function_00_0956
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
	ld de, $D800
	ld hl, MailServerStatus_BgPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	ld de, $9400
	ld hl, MailServerStatus_Tiles_7420
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, MailServerStatus_Tiles_6F30
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, MailServerStatus_Tiles_7330
	ld a, $25
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9301
	ld hl, MailServerStatus_Tiles_5060
	ld a, $29
	ld b, $98
	ld c, $03
	farcall Function_00_0787
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_29_46CD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D625
	ld a, [de]
	cp a, $00
	jr z, Label_29_46B9

; ---- code $46A1-$46B9 (24 bytes) [CONFIRMED] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; fall-through of the jrcc at 29:469F (executed) [executed in 2 scenarios]
	cp a, $FF
	jr z, Label_29_46B9
	ld bc, $1214
	ld de, $D000
	ld hl, MailServerStatus_Tilemap_Received
	ld a, $25
	farcall Function_00_08EA
	jp Label_29_46DE

; ---- code $46B9-$46F9 (64 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios)

Label_29_46B9:: ; 29:46B9
	ld bc, $1214
	ld de, $D000
	ld hl, MailServerStatus_Tilemap_NoneReceived
	ld a, $25
	farcall Function_00_08EA
	jp Label_29_46DE

Label_29_46CD:: ; 29:46CD
	ld bc, $1214
	ld de, $D000
	ld hl, MailServerStatus_Tilemap_ServerMgmt
	ld a, $25
	farcall Function_00_08EA

Label_29_46DE:: ; 29:46DE
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	ld a, [wMailScreenMode]
	cp a, $00
	jr nz, Label_29_46F5
	call MailServerStatus_DrawCounts_Mode0
	jr Label_29_4701

Label_29_46F5:: ; 29:46F5
	cp a, $01
	jr nz, Label_29_46FE

; ---- code $46F9-$46FE (5 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:46F7 (executed) [executed in 3 scenarios]
	call MailServerStatus_DrawCounts_Mode1
	jr Label_29_4701

; ---- code $46FE-$476B (109 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 2/18 scenarios)

Label_29_46FE:: ; 29:46FE
	call MailServerStatus_DrawCounts_Mode2

Label_29_4701:: ; 29:4701
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000E
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
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
	jr nz, Label_29_476B
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
	jp nz, Label_29_47BD

; ---- code $476B-$47B2 (71 bytes) [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0; entered by jrcc from 29:4755 (executed) [executed in 4 scenarios]

Label_29_476B:: ; 29:476B
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, MailServerStatus_Txt_Unknown
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, MailServerStatus_Txt_Unknown
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
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

MailServerStatus_Txt_Unknown:: ; 29:47B2
String_29_47B2::
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？？"

; ---- code $47BD-$4873 (182 bytes) [CONFIRMED] 116 insn(s); 116 executed (in up to 1/18 scenarios)

Label_29_47BD:: ; 29:47BD
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
	ldh [hRam_FFB0], a
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
	ldh [hRam_FFB0], a
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
	jr nz, Label_29_487C

; ---- code $4873-$487C (9 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 29:4871 (executed) [executed in 1 scenarios]
	ld a, l
	cp a, $FF
	jr nz, Label_29_487C
	pop hl
	jp Label_29_476B

; ---- code $487C-$48EE (114 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 1/18 scenarios)

Label_29_487C:: ; 29:487C
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
	ldh [hRam_FFB0], a
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
	ld hl, Data_29_49DA
	ld de, $D524

Label_29_48D1:: ; 29:48D1
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_29_48D1
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
	jr z, Label_29_4934

; ---- code $48EE-$4934 (70 bytes) [PROBABLE] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0; fall-through of the jrcc at 29:48EC (executed)
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
	jp Label_29_49D8

; ---- code $4934-$4946 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_4934:: ; 29:4934
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_497A

; ---- code $4946-$497A (52 bytes) [PROBABLE] 35 insn(s) reached by static flow only; seeds: exec x35; min discovery hops 0; fall-through of the jrcc at 29:4944 (executed)
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
	jp Label_29_49D8

; ---- code $497A-$498C (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_497A:: ; 29:497A
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_49AE

; ---- code $498C-$49AE (34 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 29:498A (executed)
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
	jp Label_29_49D8

; ---- code $49AE-$49C0 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_49AE:: ; 29:49AE
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_49D0

; ---- code $49C0-$49D0 (16 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 29:49BE (executed) [executed in 2 scenarios]
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
	jp Label_29_49D8

; ---- code $49D0-$49DA (10 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_49D0:: ; 29:49D0
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01

Label_29_49D8:: ; 29:49D8
	pop bc
	ret

; ---- data $49DA-$49E5 (11 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_29_49DA:: ; 29:49DA
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00

; ---- code $49E5-$49F5 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerStatus_NumberOffset_M0:: ; 29:49E5
Function_29_49E5::
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_49FB

; ---- code $49F5-$49FB (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:49F3 (executed)
	ld bc, $0000
	jp Label_29_4A42

; ---- code $49FB-$4A0B (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_49FB:: ; 29:49FB
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4A11

; ---- code $4A0B-$4A11 (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4A09 (executed)
	ld bc, $0010
	jp Label_29_4A42

; ---- code $4A11-$4A21 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_4A11:: ; 29:4A11
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4A27

; ---- code $4A21-$4A27 (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4A1F (executed)
	ld bc, $0020
	jp Label_29_4A42

; ---- code $4A27-$4A37 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_4A27:: ; 29:4A27
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4A3D

; ---- code $4A37-$4A3D (6 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4A35 (executed) [executed in 2 scenarios]
	ld bc, $0030
	jp Label_29_4A42

; ---- code $4A3D-$4A65 (40 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)

Label_29_4A3D:: ; 29:4A3D
	ld bc, $0040
	ld a, $01

Label_29_4A42:: ; 29:4A42
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

; ---- code $4A65-$4A7D (24 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1; entered by call from 29:46F9 (PROBABLE code) | 17 insn(s) executed; cut out of the PROBABLE region 4A65-4AC4 by apply_coverage --split [executed in 4 scenarios]

MailServerStatus_DrawCounts_Mode1:: ; 29:4A65
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
	jp nz, Label_29_4ACF

; ---- code $4A7D-$4AC4 (71 bytes) [PROBABLE] 27 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4A65-4AC4 by apply_coverage --split

Label_29_4A7D:: ; 29:4A7D
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, String_29_4AC4
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, String_29_4AC4
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D140
	ld de, $D190
	ld hl, String_29_4AC4
	farcall TextTiles_RenderLine
	call MailServerStatus_UploadNumberTiles_Blank
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- text $4AC4-$4ACF (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '？' (81 48) + NUL; address loaded by 'ld hl,$4AC4' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

String_29_4AC4:: ; 29:4AC4
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？？"

; ---- code $4ACF-$4B48 (121 bytes) [CONFIRMED] 279 insn(s) reached by static flow only; seeds: exec x279; min discovery hops 2; entered by jpcc from 29:4A7A (PROBABLE code) | 71 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4ACF:: ; 29:4ACF
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
	ldh [hRam_FFB0], a
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
	ldh [hRam_FFB0], a
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
	jr nz, Label_29_4B51

; ---- code $4B48-$4B51 (9 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split
	ld a, l
	cp a, $FF
	jr nz, Label_29_4B51
	pop hl
	jp Label_29_4A7D

; ---- code $4B51-$4BAA (89 bytes) [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4B51:: ; 29:4B51
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
	ldh [hRam_FFB0], a
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
	ld hl, String_29_4C96
	ld de, $D524

Label_29_4B8D:: ; 29:4B8D
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_29_4B8D
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
	jr z, Label_29_4BF0

; ---- code $4BAA-$4BF0 (70 bytes) [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split
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
	jp Label_29_4C94

; ---- code $4BF0-$4C02 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4BF0:: ; 29:4BF0
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4C36

; ---- code $4C02-$4C36 (52 bytes) [PROBABLE] 35 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split
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
	jp Label_29_4C94

; ---- code $4C36-$4C48 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4C36:: ; 29:4C36
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4C6A

; ---- code $4C48-$4C6A (34 bytes) [PROBABLE] 24 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split
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
	jp Label_29_4C94

; ---- code $4C6A-$4C7C (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4C6A:: ; 29:4C6A
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4C8C

; ---- code $4C7C-$4C8C (16 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split
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
	jp Label_29_4C94

; ---- code $4C8C-$4C96 (10 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4ACF-4C96 by apply_coverage --split [executed in 4 scenarios]

Label_29_4C8C:: ; 29:4C8C
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01

Label_29_4C94:: ; 29:4C94
	pop bc
	ret

; ---- text $4C96-$4CA1 (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '０' (82 4f) + NUL; address loaded by 'ld hl,$4C96' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

String_29_4C96:: ; 29:4C96
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00 ; "０００００"

; ---- code $4CA1-$4CB1 (16 bytes) [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 3; entered by call from 29:4AD6 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]

MailServerStatus_NumberOffset_M1:: ; 29:4CA1
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4CB7

; ---- code $4CB1-$4CB7 (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split
	ld bc, $0000
	jp Label_29_4CFE

; ---- code $4CB7-$4CC7 (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]

Label_29_4CB7:: ; 29:4CB7
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4CCD

; ---- code $4CC7-$4CCD (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split
	ld bc, $0010
	jp Label_29_4CFE

; ---- code $4CCD-$4CDD (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]

Label_29_4CCD:: ; 29:4CCD
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4CE3

; ---- code $4CDD-$4CE3 (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split
	ld bc, $0020
	jp Label_29_4CFE

; ---- code $4CE3-$4CF3 (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]

Label_29_4CE3:: ; 29:4CE3
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4CF9

; ---- code $4CF3-$4CF9 (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split
	ld bc, $0030
	jp Label_29_4CFE

; ---- code $4CF9-$4D21 (40 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4CA1-4D21 by apply_coverage --split [executed in 4 scenarios]

Label_29_4CF9:: ; 29:4CF9
	ld bc, $0040
	ld a, $01

Label_29_4CFE:: ; 29:4CFE
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

; ---- code $4D21-$4D39 (24 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerStatus_DrawCounts_Mode2:: ; 29:4D21
Function_29_4D21::
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
	jp nz, Label_29_4D8B

; ---- code $4D39-$4D80 (71 bytes) [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 0; fall-through of the jpcc at 29:4D36 (executed) [executed in 2 scenarios]

Label_29_4D39:: ; 29:4D39
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D000
	ld de, $D050
	ld hl, String_29_4D80
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D0A0
	ld de, $D0F0
	ld hl, String_29_4D80
	farcall TextTiles_RenderLine
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $29
	ld bc, $D140
	ld de, $D190
	ld hl, String_29_4D80
	farcall TextTiles_RenderLine
	call MailServerStatus_UploadNumberTiles_Blank
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- text $4D80-$4D8B (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string: 5 x full-width '？' (81 48) + NUL; address loaded by 'ld hl,$4D80' as a text argument (hl=string, ld a,$29, then a far call to 48:403E follows) - placeholder/mask string

String_29_4D80:: ; 29:4D80
	db $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $00 ; "？？？？？"

; ---- code $4D8B-$4E1E (147 bytes) [CONFIRMED] 88 insn(s); 88 executed (in up to 1/18 scenarios)

Label_29_4D8B:: ; 29:4D8B
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
	ldh [hRam_FFB0], a
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
	ldh [hRam_FFB0], a
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
	jr nz, Label_29_4E27

; ---- code $4E1E-$4E27 (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 29:4E1C (executed)
	ld a, l
	cp a, $FF
	jr nz, Label_29_4E27
	pop hl
	jp Label_29_4D39

; ---- code $4E27-$4E80 (89 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios)

Label_29_4E27:: ; 29:4E27
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
	ldh [hRam_FFB0], a
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
	ld hl, Data_29_4F6C
	ld de, $D524

Label_29_4E63:: ; 29:4E63
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_29_4E63
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
	jr z, Label_29_4EC6

; ---- code $4E80-$4EC6 (70 bytes) [PROBABLE] 46 insn(s) reached by static flow only; seeds: exec x46; min discovery hops 0; fall-through of the jrcc at 29:4E7E (executed)
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
	jp Label_29_4F6A

; ---- code $4EC6-$4ED8 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_4EC6:: ; 29:4EC6
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4F0C

; ---- code $4ED8-$4F0C (52 bytes) [PROBABLE] 35 insn(s) reached by static flow only; seeds: exec x35; min discovery hops 0; fall-through of the jrcc at 29:4ED6 (executed)
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
	jp Label_29_4F6A

; ---- code $4F0C-$4F1E (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_4F0C:: ; 29:4F0C
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4F40

; ---- code $4F1E-$4F40 (34 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 29:4F1C (executed)
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
	jp Label_29_4F6A

; ---- code $4F40-$4F52 (18 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_4F40:: ; 29:4F40
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_29_4F62

; ---- code $4F52-$4F62 (16 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 29:4F50 (executed) [executed in 1 scenarios]
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
	jp Label_29_4F6A

; ---- code $4F62-$4F6C (10 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_29_4F62:: ; 29:4F62
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01

Label_29_4F6A:: ; 29:4F6A
	pop bc
	ret

; ---- data $4F6C-$4F77 (11 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_29_4F6C:: ; 29:4F6C
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00

; ---- code $4F77-$4F87 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailServerStatus_NumberOffset_M2:: ; 29:4F77
Function_29_4F77::
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4F8D

; ---- code $4F87-$4F8D (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4F85 (executed)
	ld bc, $0000
	jp Label_29_4FD4

; ---- code $4F8D-$4F9D (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_4F8D:: ; 29:4F8D
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4FA3

; ---- code $4F9D-$4FA3 (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4F9B (executed)
	ld bc, $0010
	jp Label_29_4FD4

; ---- code $4FA3-$4FB3 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_4FA3:: ; 29:4FA3
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4FB9

; ---- code $4FB3-$4FB9 (6 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4FB1 (executed)
	ld bc, $0020
	jp Label_29_4FD4

; ---- code $4FB9-$4FC9 (16 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_29_4FB9:: ; 29:4FB9
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_29_4FCF

; ---- code $4FC9-$4FCF (6 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 29:4FC7 (executed) [executed in 1 scenarios]
	ld bc, $0030
	jp Label_29_4FD4

; ---- code $4FCF-$4FF7 (40 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)

Label_29_4FCF:: ; 29:4FCF
	ld bc, $0040
	ld a, $01

Label_29_4FD4:: ; 29:4FD4
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

; ---- code $4FF7-$5017 (32 bytes) [CONFIRMED] 15 insn(s) reached by static flow only; seeds: exec x15; min discovery hops 1; entered by call from 29:47AA (PROBABLE code) [executed in 5 scenarios]

MailServerStatus_UploadNumberTiles_Blank:: ; 29:4FF7
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

; ---- code $5017-$505F (72 bytes) [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

MailResult_UploadTextTiles:: ; 29:5017
Function_29_5017::
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
	ld de, $FF44

Label_29_504E:: ; 29:504E
	ld a, [de]
	cp a, $8F
	jr nz, Label_29_504E
	ld b, $91

Label_29_5055:: ; 29:5055
	ld a, [de]
	cp a, b
	jr nz, Label_29_5055
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

; ---- zero $505F-$5060 (1 bytes) [PROBABLE] 1 byte of $00 padding between the code ending at 505E and the tiles at 5060
	ds $1, $00

; ---- gfx $5060-$5090 (48 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4686: hl=$5060 a=$29 c=$03 de=$9301 (dest VRAM $9300, vbank=1)

MailServerStatus_Tiles_5060:: ; 29:5060
Data_29_5060::
	db $04, $88, $00, $28, $00, $28, $10, $C7, $38, $10, $EF, $FF, $00, $FF, $FF, $00
	db $00, $08, $05, $02, $00, $05, $14, $93, $38, $10, $EF, $FF, $00, $FF, $FF, $00
	db $17, $58, $17, $58, $17, $58, $37, $98, $67, $38, $CF, $F0, $1F, $E0, $FF, $00
