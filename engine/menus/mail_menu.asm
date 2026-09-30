; engine/menus/mail_menu.asm
; bank 1D, $4000-$45C1 (1473 bytes); pinned by layout.link
; mail menu (6 plates) code, ticker table, item strings

SECTION "engine/menus/mail_menu", ROMX

MailMenu_Run:: ; 1D:4000
Function_1D_4000::
	; [CONFIRMED] 145 insn(s); 145 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	call Function_00_044B
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	call Function_00_044B
	ld a, $01
	ld hl, $A8B8
	call ReadByteFar
	or a, a
	jr nz, .skip
	ld a, $01
.skip ; 1D:4023
	ld [wRam_C0E5], a
	ld a, $01
	ld [wRam_C0E7], a
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Gfx_MailMenu_Tiles0
	ld a, $1D
	ld b, $96
	ld c, $19
	farcall Function_00_0787
	ld de, $8800
	ld hl, Gfx_MailMenu_Tiles1
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, Gfx_MailMenu_Tiles2
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, Gfx_MailMenu_Tiles3
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, $5A30
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_MailMenu_Tiles5
	ld a, $1D
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailMenu_Bg
	ld a, $1D
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailMenu_Screen
	ld a, $1D
	farcall Function_00_08EA
	ld hl, $DA10
	ld de, $63B6
	ld a, $1D
	ld b, $80
	farcall Function_00_0A82
	ld de, $431A
	ld hl, $DA10
	call Function_00_0A65
	ld bc, $0040
	ld de, $D840
	ld hl, $6270
	ld a, $1D
	farcall Palette_LoadToBuffer
	ld a, $40
	ld bc, $0220
	ld de, $8000
	ld hl, $D200
	farcall Tilemap_FillRectSequential
	call Function_00_044B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $02
	ld [wRam_C0E6], a
	call MailMenu_DrawItemNormal
	ld a, $01
	ld [wRam_C0E6], a
	call MailMenu_DrawItemSelected
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ld a, [wRam_C0E5]
	dec a
	cp a, $01
	call z, MailMenu_GetLabelIndexA
	ld b, a
	ld hl, Data_MailMenu_StringIndexBank
	ld a, $1D
	farcall Ticker_Start
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0003
	call Function_00_20B2
	pop af
	ldh [rSVBK], a

MailMenu_Loop:: ; 1D:4188
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $41A0-$41AA (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 1D:419D: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Table_MailMenu_Buttons:: ; 1D:41A0
Table_1D_41A0::
	dw MailMenu_OnA
	dw MailMenu_OnB
	dw MailMenu_Ignore
	dw MailMenu_Ignore
	dw MailMenu_Idle

MailMenu_Idle:: ; 1D:41AA
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 9/18 scenarios)
	farcall Ticker_Update
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, MailMenu_HandleDpad
	call MailMenu_AnimateIcon
	jp MailMenu_Loop

MailMenu_OnA:: ; 1D:41BD
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0E5]
	ld b, a
	ld a, $01
	ld hl, $A8B8
	farcall WriteByteFar
	ld a, [wRam_C0E5]
	ret

MailMenu_OnB:: ; 1D:41EC
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld b, $00
	ld a, $01
	ld hl, $A8B8
	farcall WriteByteFar
	xor a, a
	ret

MailMenu_Ignore:: ; 1D:4217
	jp MailMenu_Loop

MailMenu_GetLabelIndexA:: ; 1D:421A
	ld a, $00
	ld hl, $A000
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $06
	ret

MailMenu_HandleDpad:: ; 1D:4229
	bit 6, a
	jr nz, .l4232
	bit 7, a
	jr nz, .l4256
	ret
.l4232 ; 1D:4232
	ld a, [wRam_C0E5]
	ld [wRam_C0E6], a
	dec a
	jr nz, .l423D

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1D:4239 (executed) [executed in 5 scenarios]
	ld a, $06

.l423D ; 1D:423D
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 7/18 scenarios)
	ld [wRam_C0E5], a
	call MailMenu_DrawItemNormal
	call MailMenu_DrawItemSelected
	farcall Function_00_0956
	ldh a, [rLCDC]
	call Function_00_082C
	call MailMenu_AnimateIcon
	jr MailMenu_AfterMove
.l4256 ; 1D:4256
	ld a, [wRam_C0E5]
	ld [wRam_C0E6], a
	inc a
	cp a, $07
	jr nz, .l4263

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 1D:425F (executed) [executed in 5 scenarios]
	ld a, $01

.l4263 ; 1D:4263
	; [CONFIRMED] 89 insn(s); 89 executed (in up to 9/18 scenarios)
	ld [wRam_C0E5], a
	call MailMenu_DrawItemNormal
	call MailMenu_DrawItemSelected
	farcall Function_00_0956
	ldh a, [rLCDC]
	call Function_00_082C
	call MailMenu_AnimateIcon

MailMenu_AfterMove:: ; 1D:427A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C0E5]
	dec a
	cp a, $01
	call z, MailMenu_GetLabelIndexB
	ld b, a
	ld hl, Data_MailMenu_StringIndexBank
	ld a, $1D
	farcall Ticker_Start
	ret

MailMenu_GetLabelIndexB:: ; 1D:42A0
	ld a, $00
	ld hl, $A000
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $06
	ret

MailMenu_DrawItemNormal:: ; 1D:42AF
	ld a, [wRam_C0E6]
	dec a
	cp a, $01
	call z, MailMenu_GetPlateIndexA
	ld b, $03
	ld c, a
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, Table_MailMenu_PlateBufferOffsets
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, Data_MailMenu_PlateOffsets
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4891
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $F0
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $1D
	call Function_00_16A2
	ret

MailMenu_GetPlateIndexA:: ; 1D:42FE
	ld a, $00
	ld hl, $A000
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $07
	ret

; ---- words $430D-$431D (16 bytes) [PROBABLE] 8 words: first 6 = WRAM tile-buffer offsets ($09,$69,$A9,$109,$149,$1A9 = row*32+9 for rows 0,3,5,8,10,13) that the code adds to $D000 (ld hl,$430D at 1D:42C1, index*2, ld hl,[hl]); words 7-8 ($0000,$0069) not exercised; the never-read gap bytes are folded in

Table_MailMenu_PlateBufferOffsets:: ; 1D:430D
Table_1D_430D::
	dw $0009, $0069, $00A9, $0109, $0149, $01A9, $0000, $0069

; ---- data $431D-$4325 (8 bytes) [PROBABLE] byte table indexed by c (00 28 46 6e 8c b4 00 d2), read via 'ld hl,$431D' at 1D:42D6 (executed reads)

Data_MailMenu_PlateOffsets:: ; 1D:431D
Data_1D_431D::
	db $00, $28, $46, $6E, $8C, $B4, $00, $D2

MailMenu_DrawItemSelected:: ; 1D:4325
Function_1D_4325::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C0E5]
	dec a
	cp a, $01
	call z, MailMenu_GetPlateIndexB
	ld b, $03
	ld c, a
	and a, $01
	xor a, $01
	add a, b
	ld b, a
	ld hl, Table_MailMenu_SelectedBufferOffsets
	ld a, c
	sla a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld de, $D000
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld d, h
	ld e, l
	ld hl, Data_MailMenu_SelectedPlateOffsets
	ld a, c
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hl]
	ld hl, $4A71
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $F0
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld c, $0A
	ld a, $1D
	call Function_00_16A2
	ret

MailMenu_GetPlateIndexB:: ; 1D:4374
	ld a, $00
	ld hl, $A000
	call ReadByteFar
	or a, a
	ld a, $01
	ret z
	ld a, $07
	ret

; ---- words $4383-$4393 (16 bytes) [PROBABLE] 8 words: first 6 = WRAM tile-buffer offsets ($09,$69,$A9,$109,$149,$1A9 = row*32+9 for rows 0,3,5,8,10,13) that the code adds to $D000 (ld hl,$4383 at 1D:4337, index*2, ld hl,[hl]); words 7-8 ($0000,$0069) not exercised; the never-read gap bytes are folded in

Table_MailMenu_SelectedBufferOffsets:: ; 1D:4383
Table_1D_4383::
	dw $0009, $0069, $00A9, $0109, $0149, $01A9, $0000, $0069

; ---- data $4393-$439B (8 bytes) [PROBABLE] byte table indexed by c (00 28 46 6e 8c b4 00 d2), read via 'ld hl,$4393' at 1D:434C (executed reads)

Data_MailMenu_SelectedPlateOffsets:: ; 1D:4393
Data_1D_4393::
	db $00, $28, $46, $6E, $8C, $B4, $00, $D2

MailMenu_AnimateIcon:: ; 1D:439B
Function_1D_439B::
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C0E7
	dec [hl]
	ret nz
	ld [hl], $1E
	ld a, [wRam_C0E8]
	xor a, $01
	ld [wRam_C0E8], a
	jr nz, .l43D3
	ld a, $B1
	ld [wRam_C10E], a
	ld a, $4C
	ld [wRam_C10F], a
	ld bc, $0608
	ld de, $D0C1
	ld hl, Tilemap_MailMenu_IconFrames
	ld a, $1D
	farcall Function_00_16A2
	farcall Function_00_0956
	ldh a, [rLCDC]
	call Function_00_082C
	ret
.l43D3 ; 1D:43D3
	ld a, $E1
	ld [wRam_C10E], a
	ld a, $4C
	ld [wRam_C10F], a
	ld bc, $0608
	ld de, $D0C1
	ld hl, $4C81
	ld a, $1D
	farcall Function_00_16A2
	farcall Function_00_0956
	ldh a, [rLCDC]
	call Function_00_082C
	ret

; ---- data $43FA-$43FB (1 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 43FA-4945 by higher-priority evidence]

Data_MailMenu_StringIndexBank:: ; 1D:43FA
Data_1D_43FA::
	db $1D

; ---- ptrtable $43FB-$4413 (24 bytes) [PROBABLE] little-endian word table, 14 entries, monotone=1.00, 93% of targets on string start/after NUL, targets $4417..$4592 [clipped from 43FB-4417 by higher-priority proposals]

Table_MailMenu_Strings:: ; 1D:43FB
Table_1D_43FB::
	dw String_MailMenu_Items
	dw $4428
	dw $4467
	dw $4474
	dw $4491
	dw $44A0
	dw $44C5
	dw $44D4
	dw $44FF
	dw $450C
	dw $4549
	dw $4556

; ---- text $4413-$45C1 (430 bytes) [PROBABLE] text: 14 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

Table_MailMenu_StringsTail:: ; 1D:4413
String_1D_4413::
	db $81, $45, $92, $45 ; "・脱"

String_MailMenu_Items:: ; 1D:4417
	db $82, $A8, $82, $AD, $82, $E9, $81, $5E, $82, $A4, $82, $AF, $82, $C6, $82, $E9, $00 ; "おくる／うけとる"
	db $83, $43, $83, $93, $83, $5E, $81, $5B, $83, $6C, $83, $62, $83, $67, $82, $F0, $82, $C2, $82, $A9, $82, $C1, $82, $C4, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $CC ; "インターネットをつかって　メールの"
	db $82, $BB, $82, $A4, $82, $B5, $82, $F1, $82, $C6, $82, $B6, $82, $E3, $82, $B5, $82, $F1, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "そうしんとじゅしんができます"
	db $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $A9, $82, $AD, $00 ; "メールをかく"
	db $82, $A0, $82, $BD, $82, $E7, $82, $B5, $82, $AD, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $A9, $82, $AB, $82, $DC, $82, $B7, $00 ; "あたらしく　メールをかきます"
	db $83, $81, $81, $5B, $83, $8B, $83, $7B, $83, $62, $83, $4E, $83, $58, $00 ; "メールボックス"
	db $82, $E0, $82, $E7, $82, $C1, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $DD, $82, $E9, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC ; "もらったメールを　みることができま"
	db $82, $B7, $00 ; "す"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $00 ; "アドレスちょう"
	db $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $82, $C9, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $A9, $82, $AB ; "アドレスちょうに　アドレスを　かき"
	db $82, $B1, $82, $DD, $82, $DC, $82, $B7, $00 ; "こみます"
	db $83, $76, $83, $8D, $83, $74, $83, $42, $81, $5B, $83, $8B, $00 ; "プロフィール"
	db $82, $B6, $82, $D4, $82, $F1, $82, $CC, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $82, $DD, $82, $BD, $82, $E8, $81, $40, $83, $6A, $83, $62, $83, $4E, $83, $6C ; "じぶんのアドレスをみたり　ニックネ"
	db $81, $5B, $83, $80, $82, $F0, $82, $A9, $82, $A6, $82, $E9, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "ームをかえることができます"
	db $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $00 ; "メールサーバ"
	db $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $82, $C9, $82, $A0, $82, $E9, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $40, $82, $B9, $82, $A2, $82, $E8 ; "メールサーバにあるメールを　せいり"
	db $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "できます"
	db $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $A9, $82, $AD, $82, $C9, $82, $F1, $00 ; "メールをかくにん"
	db $82, $A9, $82, $A2, $82, $BD, $83, $81, $81, $5B, $83, $8B, $82, $CC, $81, $40, $82, $A9, $82, $AD, $82, $C9, $82, $F1, $82, $C6, $82, $B5, $82, $E3, $82, $A4, $82, $B9 ; "かいたメールの　かくにんとしゅうせ"
	db $82, $A2, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $00 ; "いができます"
