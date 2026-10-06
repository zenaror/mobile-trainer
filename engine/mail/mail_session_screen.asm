; engine/mail/mail_session_screen.asm
; bank 26, $5067-$59D8 (2417 bytes); pinned by layout.link
; transfer screen: comm error display, screen init, mail counters, messages, timer display

SECTION "engine/mail/mail_session_screen", ROMX

MailSession_ShowCommError:: ; 26:5067
	; [CONFIRMED] 28 insn(s) reached by static flow only; seeds: exec x28; min discovery hops 7;
	; entered by jpcc from 26:46B7 (executed) [executed in 4 scenarios]
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld b, a
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D629
	ld a, $FF
	ld [hli], a
	ld [hli], a
	xor a, a
	ld a, $07
	ldh [rWX], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $DB
	ldh [rLCDC], a
	farcall Mobile_ShowLastError
	ld a, $80
	pop bc
	ret

MailSession_PollAdapterError:: ; 26:50AC
Function_26_50AC::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l50B6
	xor a, a
	inc a
	ret

.l50B6 ; 26:50B6
	; [PROBABLE] 106 insn(s) reached by static flow only; seeds: exec x106; min discovery hops 1;
	; entered by jrcc from 26:50B1 (executed) | 10 insn(s) never executed in the traced runs; cut
	; out of the PROBABLE region 50B6-5168 by apply_coverage --split
	push bc
	push de
	push hl
	farcall Mobile_FetchResult
	pop hl
	pop de
	pop bc
	ld a, $FF
	inc a
	ret

MailSession_ShowCommErrorNoWindow:: ; 26:50C6
	; [CONFIRMED] 76 insn(s) executed; cut out of the PROBABLE region 50B6-5168 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, [wMobileResultDetail]
	ld [wMobileErrorDetail], a
	ld a, [wMobileResultDetail + 1]
	ld [wMobileErrorDetailHi], a
	ld a, [wMobileResultCode]
	ld [wMobileErrorCode], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D629
	ld a, $FF
	ld [hli], a
	ld [hli], a
	xor a, a
	ldh [rWX], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ldh a, [rLCDC]
	and a, $DB
	ldh [rLCDC], a
	farcall Mobile_ShowLastError
	ld a, $80
	ret

Function_26_5106:: ; 26:5106
	push bc
	push de
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D627
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D631
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld hl, $D62F
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ld a, h
	xor a, $FF
	ld b, a
	ld a, l
	xor a, $FF
	ld c, a
	inc bc
	pop hl
	add hl, bc
	ld a, h
	or a, l
	jr z, .l514D
	pop hl
	pop de
	pop bc
	xor a, a
	ret

.l514D ; 26:514D
	; [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 50B6-5168 by apply_coverage --split
	ld hl, $D62F
	ld de, $D631
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld hl, $D629
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
	ld l, c
	ld h, b
	pop de
	pop bc
	ld a, $01
	ret

MailSession_InitScreen:: ; 26:5168
Function_26_5168::
	; [CONFIRMED] 122 insn(s); 122 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push af
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $D0
	ldh [rWY], a
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	pop af
	pop bc
	push bc
	ld a, $00
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $1800
.l519E ; 26:519E
	ld a, $00
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l519E
	ld a, $01
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $1800
.l51B0 ; 26:51B0
	ld a, $00
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l51B0
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0F00
.l51C4 ; 26:51C4
	ld a, $00
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l51C4
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_CommProgress_Bg
	ld a, $22
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, $5C90
	ld a, $22
	farcall Palette_LoadToBuffer
	ld de, $8001
	ld hl, MailSession_Tiles_59E0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8401
	ld hl, MailSession_Tiles_5DE0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8801
	ld hl, MailSession_Tiles_61E0
	ld a, $26
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, MailSession_Tiles_62E0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, MailSession_Tiles_66E0
	ld a, $26
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, MailSession_Tiles_67E0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, MailSession_Tiles_6BE0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, MailSession_Tiles_6FE0
	ld a, $26
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, $7520
	ld a, $27
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_CommProgress_Screen
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	di
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ei
	pop bc
	jp .l52D8

	; [PROBABLE] function prologue (di / ldh [$FFF2],a / ldh a,[$FF8D] / push af / ... ld a,$07 /
	; ldh [$FF8D],a / ldh [$FF70],a / call $047A / ld hl,$D800) identical in shape to 4F:42B4; chain
	; falls through into the site-validated far call at 52BF; entry unproven
	di
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg

	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: site x11; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
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
	ei

.l52D8 ; 26:52D8
	; [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)
	xor a, a
	ldh [rVBK], a
	ld hl, $9960
	ld b, $40
	xor a, a
.l52E1 ; 26:52E1
	ld [hli], a
	inc a
	dec b
	jr nz, .l52E1
	farcall LCDOn
	call MailSession_UpdateTimerDisplay
	ldh a, [rLCDC]
	or a, $04
	ldh [rLCDC], a
	ld de, $000E
	ld hl, $3039
	ld bc, $0000
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000C
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
	ret

Stub_Nop_26_5343:: ; 26:5343
Function_26_5343::
	ret

; ---- data $5344-$537C (56 bytes) [HYPOTHESIS] UNCLASSIFIED 56 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) [g4: complete self-contained decode ending in ret with no caller/table/far-pointer reference found, so left unclassified]

Data_26_5344:: ; 26:5344
	db $F5, $C5, $D5, $E5, $F0, $70, $5F, $16, $32, $D5, $3E, $01, $E0, $4F, $21, $10
	db $90, $06, $10, $3E, $FF, $22, $05, $20, $FA, $3E, $07, $E0, $8D, $E0, $70, $21
	db $60, $D1, $06, $40, $AF, $22, $3C, $05, $20, $FB, $D1, $15, $20, $DB, $7B, $E0
	db $8D, $E0, $70, $E1, $D1, $C1, $F1, $C9

MailSession_DrawMailCounts:: ; 26:537C
	; [CONFIRMED] 318 insn(s) reached by static flow only; seeds: exec x318; min discovery hops 5;
	; entered by call from 26:4798 (PROBABLE code) | 153 insn(s) executed; cut out of the PROBABLE
	; region 537C-5575 by apply_coverage --split [executed in 7 scenarios]
	push af
	push bc
	push de
	push hl
	push hl
	push de
	push bc
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
	pop bc
	pop de
	push af
	push bc
	push de
	push hl
	push hl
	push de
	push hl
	ld h, d
	ld l, e
	call MailSession_TotalNumberBuffer
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld hl, $0200
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MailSession_Txt_Total
	farcall TextTiles_RenderLine
	pop bc
	ld hl, $0040
	add hl, bc
	ld b, h
	ld c, l
	pop hl
	pop de
	push hl
	push bc
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D62F
	ld a, [hli]
	xor a, $FF
	ld c, a
	ld a, [hli]
	xor a, $FF
	ld b, a
	inc bc
	ld h, d
	ld l, e
	add hl, bc
	pop bc
	call MailSession_DrawNumber
	ld e, a
	ld d, $00
	swap e
	pop hl
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld hl, $0200
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MailSession_Txt_Counter
	farcall TextTiles_RenderLine
	pop hl
	push hl
	call MailSession_CurrentNumberBuffer
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld hl, $0200
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $566E
	pop bc
	pop hl
	push hl
	push bc
	call MailSession_DrawNumber
	ld e, a
	ld d, $00
	swap e
	pop hl
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld hl, $0200
	add hl, bc
	ld d, h
	ld e, l
	ld hl, MailSession_Txt_Checking
	farcall TextTiles_RenderLine
	call MailSession_UploadNumberTiles
	pop hl
	pop de
	pop bc
	pop af
	pop hl
	pop hl
	pop de
	pop bc
	pop af
	ret

MailSession_DrawNumber:: ; 26:5447
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, MailSession_NumberTemplate
	ld de, $D524
.loop ; 26:5455
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
	jr z, .l54B8

	; [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 537C-5575 by apply_coverage --split
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
	jp .l555C

.l54B8 ; 26:54B8
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 537C-5575 by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l54FE

	; [PROBABLE] 35 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 537C-5575 by apply_coverage --split
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
	jp .l555C

.l54FE ; 26:54FE
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 537C-5575 by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l5532

	; [PROBABLE] 24 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 537C-5575 by apply_coverage --split
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
	jp .l555C

.l5532 ; 26:5532
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 537C-5575 by apply_coverage
	; --split [executed in 2 scenarios]
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l5554
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
	jp .l555C
.l5554 ; 26:5554
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l555C ; 26:555C
	pop bc
	push af
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0200
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop af
	ret

; ---- text $5575-$5580 (11 bytes) [PROBABLE] Shift-JIS full-width "00000" (5 x 82 4F) + NUL

PUSHC sjis
MailSession_NumberTemplate:: ; 26:5575
String_26_5575::
	db "０００００", 0
POPC

MailSession_TotalNumberBuffer:: ; 26:5580
	; [CONFIRMED] 101 insn(s) reached by static flow only; seeds: exec x101; min discovery hops 6;
	; entered by call from 26:53A2 (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE
	; region 5580-566E by apply_coverage --split [executed in 7 scenarios]
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l5596

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D070
	jp .l55DD

.l5596 ; 26:5596
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l55AC

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D080
	jp .l55DD

.l55AC ; 26:55AC
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l55C2

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D090
	jp .l55DD

.l55C2 ; 26:55C2
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 2 scenarios]
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l55D8
	ld bc, $D0A0
	jp .l55DD
.l55D8 ; 26:55D8
	ld bc, $D0B0
	ld a, $01
.l55DD ; 26:55DD
	pop hl
	pop de
	ret

MailSession_CurrentNumberBuffer:: ; 26:55E0
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l55F6

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D420
	jp .l563D

.l55F6 ; 26:55F6
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l560C

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D420
	jp .l563D

.l560C ; 26:560C
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l5622

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5580-566E by apply_coverage --split
	ld bc, $D420
	jp .l563D

.l5622 ; 26:5622
	; [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 5580-566E by apply_coverage
	; --split [executed in 2 scenarios]
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l5638
	ld bc, $D420
	jp .l563D
.l5638 ; 26:5638
	ld bc, $D430
	ld a, $01
.l563D ; 26:563D
	pop hl
	pop de
	ret

MailSession_UploadNumberTiles:: ; 26:5640
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
	farcall Gfx_GdmaAtVBlankNoDi
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

; ---- text $566E-$5677 (9 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Txt_Total:: ; 26:566E
String_26_566E::
	db "ぜんぶで", 0
POPC

; ---- text $5677-$567C (5 bytes) [PROBABLE] Shift-JIS "つう" + NUL between String_26_566E chunks (566E holds ぜんぶで / つう / つうめをチェックしています as consecutive NUL-terminated strings)

PUSHC sjis
MailSession_Txt_Counter:: ; 26:5677
String_26_5677::
	db "つう", 0
POPC

; ---- text $567C-$5697 (27 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Txt_Checking:: ; 26:567C
String_26_567C::
	db "つうめをチェックしています", 0
POPC

MailSession_ShowMsgSending:: ; 26:5697
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1;
	; entered by call from 26:403E (PROBABLE code) [executed in 5 scenarios]
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_Sending
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $56B2-$56DB (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_Sending:: ; 26:56B2
String_26_56B2::
	db "　　　　メールをそうしんしています　　　", 0
POPC

MailSession_ShowMsgReceiving:: ; 26:56DB
Function_26_56DB::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_Receiving
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $56F6-$571F (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_Receiving:: ; 26:56F6
String_26_56F6::
	db "　　　　メールをじゅしんしています　　　", 0
POPC

MailSession_ShowMsgSent:: ; 26:571F
Function_26_571F::
	; [PROBABLE] push bc / ld a,$02 / ldh [$FFB0],a / ld a,$26 / ld bc,$D400 / ld de,$D600 / ld
	; hl,$573A: loads the address of String_26_573A that follows the far call at 572F; chain falls
	; through into that site-validated far call; entry unproven
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, $573A

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $573A-$5763 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_Sent:: ; 26:573A
String_26_573A::
	db "　　　　メールをそうしんしました　　　　", 0
POPC

MailSession_ShowMsgReceiveDone:: ; 26:5763
Function_26_5763::
	; [PROBABLE] same as 26:571F but ld hl,$577E (String_26_577E); chain falls through into the far
	; call at 5773; entry unproven
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, $577E

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $577E-$57A7 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_ReceiveDone:: ; 26:577E
String_26_577E::
	db "　　　　メールじゅしんかんりょう　　　　", 0
POPC

MailSession_ShowMsgNoMail:: ; 26:57A7
Function_26_57A7::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_NoMail
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $57C2-$57EB (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_NoMail:: ; 26:57C2
String_26_57C2::
	db "　　　　メールはありませんでした　　　　", 0
POPC

MailSession_ShowMsgCannotReceive:: ; 26:57EB
	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1;
	; entered by call from 26:4A99 (PROBABLE code)
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_CannotReceive
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $5806-$582F (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_CannotReceive:: ; 26:5806
String_26_5806::
	db "　　　メールはうけとれませんでした　　　", 0
POPC

MailSession_ShowMsgReceived:: ; 26:582F
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 11;
	; entered by call from 26:4A1E (PROBABLE code) [executed in 2 scenarios]
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_Received
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- text $584A-$5873 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailSession_Msg_Received:: ; 26:584A
String_26_584A::
	db "　　　　メールをうけとりました　　　　　", 0
POPC

MailSession_ClearMsg:: ; 26:5873
Function_26_5873::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $26
	ld bc, $D400
	ld de, $D600
	ld hl, MailSession_Msg_Blank
	farcall TextTiles_RenderLine
	call MailSession_UploadMsgTiles
	pop bc
	ret

; ---- data $588E-$58B7 (41 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown
; kept as raw bytes: the bytes read as Shift-JIS/ASCII text, but the header does not say `text` (executed-read data of unknown content class, or unclassified), so not provably a string

MailSession_Msg_Blank:: ; 26:588E
Data_26_588E::
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40
	db $81, $40, $81, $40, $81, $40, $81, $40, $00

MailSession_UploadMsgTiles:: ; 26:58B7
Function_26_58B7::
	; [CONFIRMED] 57 insn(s); 57 executed (in up to 2/18 scenarios); entry proven: target of an
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
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call MailSession_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailSession_UpdateTimerDisplay:: ; 26:58DC
	push af
	push bc
	push de
	push hl
	call Stub_Nop_26_5343
	xor a, a
	ldh [rVBK], a
	ldh a, [rSVBK]
	ld c, a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerASeconds]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock + 7]
	cp a, b
	jr nz, .l5909
	ld a, c
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	pop af
	ret
.l5909 ; 26:5909
	ld a, b
	ld [wMailSessionBlock + 7], a
	ld de, $9401
	ld hl, MailSession_Tiles_66E0
	ld a, $26
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld a, [wTimerAMinutes]
	cp a, $3C
	jr c, .l5968

.loop ; 26:5926
	; [PROBABLE] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the jrcc at 26:5924 (executed)
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D221
	ld a, $45
	ld [hli], a
	ld a, $49
	ld [hli], a
	inc hl
	ld a, $45
	ld [hli], a
	ld a, $49
	ld [hl], a
	jp .l59AA

	; [PROBABLE] ld a,[$C2D6] / add a,$3C / cp a,$64 / jr nc,$5926 / ld l,a / ld h,$00 / ld
	; de,$000A: chain falls into the site-validated far call at 594E and jr nc targets the accepted
	; code at 5926; previous instruction is jp $59AA; entry unproven
	ld a, [wTimerAMinutes]
	add a, $3C
	cp a, $64
	jr nc, .loop
	ld l, a
	ld h, $00
	ld de, $000A

	; [PROBABLE] 11 insn(s) reached by static flow only; seeds: site x11; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D221], a
	ld a, e
	add a, $40
	ld [wRam_D222], a
	jr .l5989

.l5968 ; 26:5968
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 2/18 scenarios)
	ld a, [wTimerAMinutes]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D221], a
	ld a, e
	add a, $40
	ld [wRam_D222], a
.l5989 ; 26:5989
	ld a, [wTimerASeconds]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D224], a
	ld a, e
	add a, $40
	ld [wRam_D225], a
.l59AA ; 26:59AA
	di
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ei
	pop hl
	pop de
	pop bc
	pop af
	ret

MailSession_StartHDMAAtVBlank:: ; 26:59B6
	di
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
.l59C6 ; 26:59C6
	ld a, [de]
	cp a, $8F
	jr nz, .l59C6
	ld b, $91
.l59CD ; 26:59CD
	ld a, [de]
	cp a, b
	jr nz, .l59CD
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ei
	ret
