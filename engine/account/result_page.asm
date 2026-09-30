; engine/account/result_page.asm
; bank 68, $766E-$7951 (739 bytes); pinned by layout.link
; account result page, banner, time digits

SECTION "engine/account/result_page", ROMX

Account_ResultPage:: ; 68:766E
Function_68_766E::
	; [CONFIRMED] 59 insn(s); 59 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wRam_C27C], a
	ld a, b
	ld [wRam_C27D], a
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	call VBlank_Wait
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
	farcall Sprite_ResetAll
	call Sound_FrameService
	ld de, $8801
	ld hl, Data_4B_42D0
	ld a, $4B
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Data_4B_46D0
	ld a, $4B
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call Account_ResultPage_LoadBanner
	ld bc, $0028
	ld de, $D800
	ld hl, $5870
	ld a, $4B
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_4B_5898
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	call Account_ResultPage_DrawTimeDigits
	call Account_ResultPage_PrintMessage
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0013
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

Label_68_7708:: ; 68:7708
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $771A-$7724 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 68:7717: 5 entries; fixed length (5 words) by the routine

Account_ResultPage_InputTable:: ; 68:771A
Table_68_771A::
	dw Label_68_7727
	dw Label_68_773E
	dw Label_68_7741
	dw Label_68_7743
	dw Label_68_7724

Label_68_7724:: ; 68:7724
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 4/18 scenarios)
	jp Label_68_7708

Label_68_7727:: ; 68:7727
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ret

Label_68_773E:: ; 68:773E
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by table from 68:7717 (executed)
	jr Label_68_7708

	; [HYPOTHESIS] single ret between the jr thunks 773E, 7741 and 7743 (all jr $7708); nothing
	; branches to it
	ret

Label_68_7741:: ; 68:7741
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by table from 68:7717 (executed)
	jr Label_68_7708

Label_68_7743:: ; 68:7743
	jr Label_68_7708

Account_ResultPage_PrintMessage:: ; 68:7745
Function_68_7745::
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $48
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $98
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, [wRam_C27D]
	cp a, $01
	jr z, .l7798
	cp a, $02
	jr z, .l779C
	ld a, [wRam_C27C]
	jr .l779E
.l7798 ; 68:7798
	ld a, $04
	jr .l779E

.l779C ; 68:779C
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 68:7791 (executed)
	ld a, $05

.l779E ; 68:779E
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 4/18 scenarios)
	ld hl, Account_ResultMessageIds
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	farcall PromptText_Load
	call TextEngine_Run
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ld hl, $D121
	ld bc, $0612
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ret

; ---- data $77D0-$77D6 (6 bytes) [PROBABLE] contiguous data block 77D0-77D6: 2 bytes were read as data by executed code in mGBA traces (2 separate read ranges, e.g. 77D0-77D1,77D4-77D5) and 4 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 4 regions by classify_g2]

Account_ResultMessageIds:: ; 68:77D0
Data_68_77D0::
	db $05, $0E, $0F, $10, $11, $12

Account_ResultPage_LoadBanner:: ; 68:77D6
Function_68_77D6::
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C27C]
	ld hl, $7831
	ld b, a
	add a, a
	add a, b
	ld d, $00
	ld e, a
	add hl, de
	ld d, h
	ld e, l
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	ld a, [de]
	ld de, $9001
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMAWithService
	ld a, [wRam_C27D]
	or a, a
	jr nz, .l780E
	ld a, [wRam_C27C]
	ld hl, $7849
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	jr .l7810
.l780E ; 68:780E
	ld a, $01
.l7810 ; 68:7810
	ld hl, $7840
	ld b, a
	add a, a
	add a, b
	ld d, $00
	ld e, a
	add hl, de
	ld d, h
	ld e, l
	ld a, [de]
	inc de
	ld l, a
	ld a, [de]
	inc de
	ld h, a
	ld a, [de]
	ld de, $9281
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMAWithService
	ret

; ---- data $7831-$784E (29 bytes) [PROBABLE] contiguous data block 7831-784E: 22 bytes were read as data by executed code in mGBA traces (2 separate read ranges, e.g. 7831-7840,7843-784A) and 7 bytes between/around those reads were never read; the whole run is one table/buffer read by index (gaps unread in the traces); content class not decoded [merged from 4 regions by classify_g2]

Data_68_7831:: ; 68:7831
	db $F0, $46, $4B, $70, $49, $4B, $70, $4E, $4B, $F0, $4B, $4B, $F0, $46, $4B, $F0
	db $50, $4B, $70, $53, $4B, $F0, $55, $4B, $02, $01, $00, $00, $01

Account_ResultPage_DrawTimeDigits:: ; 68:784E
Function_68_784E::
	; [CONFIRMED] 130 insn(s); 130 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall CommTime_AddTimerA
	ldh a, [hRam_FFB0]
	ld [wCommTimeTotal], a
	ldh a, [hRam_FFB1]
	ld [wCommTimeTotal + 1], a
	ldh a, [hRam_FFB2]
	ld [wCommTimeTotal + 2], a
	ld a, [wRam_C27C]
	cp a, $02
	jr z, .l7873
	cp a, $03
	jr z, .l7873
.l786E ; 68:786E
	ld a, [wTimerAMinutes]
	jr .l7884
.l7873 ; 68:7873
	xor a, a
	ld hl, $C2D8
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	or a, b
	jr z, .l786E
	ld a, [wCommTimeTotal + 2]
.l7884 ; 68:7884
	ld d, a
	call Byte_ToPackedBcd
	push af
	swap a
	and a, $0F
	ld hl, Account_DigitTilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0201
	ld de, $D0A8
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	pop af
	and a, $0F
	ld hl, Account_DigitTilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0201
	ld de, $D0A9
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	ld a, [wRam_C27C]
	cp a, $02
	jr z, .l78D6
	cp a, $03
	jr z, .l78D6
.l78D1 ; 68:78D1
	ld a, [wTimerASeconds]
	jr .l78E7
.l78D6 ; 68:78D6
	xor a, a
	ld hl, $C2D8
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	inc hl
	or a, b
	ld b, [hl]
	or a, b
	jr z, .l78D1
	ld a, [wCommTimeTotal + 1]
.l78E7 ; 68:78E7
	ld d, a
	call Byte_ToPackedBcd
	push af
	swap a
	and a, $0F
	ld hl, Account_DigitTilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0201
	ld de, $D0AB
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	pop af
	and a, $0F
	ld hl, Account_DigitTilemapTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0201
	ld de, $D0AC
	ld a, $4B
	farcall Tilemap_CopyRectAndAttr
	ret

Byte_ToPackedBcd:: ; 68:792A
	xor a, a
	ld b, $FF
.loop ; 68:792D
	ld a, d
	sub a, $0A
	ld d, a
	inc b
	jr nc, .loop
	ld a, d
	add a, $0A
	ld d, a
	ld a, b
	swap a
	or a, d
	ret

; ---- ptrtable $793D-$793F (2 bytes) [PROBABLE] little-endian word table, 10 entries, monotone=1.00, 30% of targets on string start/after NUL, targets $5B68..$5B8C; referenced by ld r16,$793D at 68:788D [clipped from 793D-7951 by higher-priority evidence]

Account_DigitTilemapTable:: ; 68:793D
Table_68_793D::
	dw $5B68

; ---- ptrtable $793F-$7951 (18 bytes) [PROBABLE] code-pointer table, 9 entries: 9/9 words hit own-bank code starts (survey pointer-table extent); 9/9 targets executed

Table_68_793F:: ; 68:793F
	dw Label_68_5B6C
	dw Label_68_5B70
	dw Label_68_5B74
	dw Label_68_5B78
	dw Label_68_5B7C
	dw Label_68_5B80
	dw Label_68_5B84
	dw Label_68_5B88
	dw Label_68_5B8C
