; engine/startup/notice_pages.asm
; bank 65, $487C-$4C6E (1010 bytes); pinned by layout.link
; full-screen notice pages

SECTION "engine/startup/notice_pages", ROMX

Notice_ShowPage:: ; 65:487C
Function_65_487C::
	; [CONFIRMED] 76 insn(s); 76 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wNotice_PageArg], a
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	call VBlank_WaitAndService
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
	ld a, [wNotice_PageArg]
	ld b, $00
	ld c, a
	ld de, $0006
	call Multiply16
	ld de, $4BDE
	add hl, de
	ld a, l
	ld [wNotice_RecordPtr], a
	ld a, h
	ld [wNotice_RecordPtrHi], a
	inc hl
	ld a, [hl]
	ld [wNotice_FooterKind], a
	ld de, $9001
	ld hl, Gfx_Notice_Tiles9000Vb1
	ld a, BANK(Gfx_Notice_Tiles9000Vb1)
	ld b, $96
	ld c, $1D
	farcall Gfx_StartHDMAWithService
	ld bc, $0028
	ld de, wPaletteBufBg
	ld hl, Palette_Notice_Bg
	ld a, BANK(Palette_Notice_Bg)
	farcall Palette_LoadToBuffer
	ld a, [wNotice_RecordPtr]
	ld l, a
	ld a, [wNotice_RecordPtrHi]
	ld h, a
	ld a, [hl]
	cp a, $04
	jr z, .l4908
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Notice_58_7B78
	ld a, BANK(Tilemap_Notice_58_7B78)
	farcall Tilemap_CopyRectAndAttr
	jr .l4919
.l4908 ; 65:4908
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Notice_4B_4000
	ld a, BANK(Tilemap_Notice_4B_4000)
	farcall Tilemap_CopyRectAndAttr
.l4919 ; 65:4919
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call Notice_LoadHeaderGfx
	call Notice_DrawPageCounter
	call Notice_DrawBodyText
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Palette_FadeInFromWhite
	call Notice_RequestPageSound
	ld a, [wNotice_FooterKind]
	cp a, $02
	jr z, Notice_ShowPage_Locked

Notice_ShowPage_InputLoop:: ; 65:493C
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $494E-$4958 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 65:494B: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

Notice_JoypadTable:: ; 65:494E
Table_65_494E::
	dw Notice_ShowPage_ButtonA
	dw Notice_ShowPage_ButtonB
	dw Notice_ShowPage_IgnoreSelect
	dw Notice_ShowPage_IgnoreStart
	dw Notice_ShowPage_Idle

Notice_ShowPage_Idle:: ; 65:4958
Label_65_4958::
	; [CONFIRMED] 138 insn(s); 138 executed (in up to 9/18 scenarios)
	jp Notice_ShowPage_InputLoop

Notice_ShowPage_ButtonA:: ; 65:495B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld a, $01
	ret

Notice_ShowPage_ButtonB:: ; 65:4974
	ld a, [wNotice_FooterKind]
	cp a, $01
	jr z, .l4981
	cp a, $05
	jr z, .l4981
	jr Notice_ShowPage_InputLoop
.l4981 ; 65:4981
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Notice_ShowPage_IgnoreSelect:: ; 65:4999
Label_65_4999::
	jr Notice_ShowPage_InputLoop

Notice_ShowPage_IgnoreStart:: ; 65:499B
Label_65_499B::
	jr Notice_ShowPage_InputLoop

Notice_ShowPage_Locked:: ; 65:499D
	call VBlank_WaitAndService
	jr Notice_ShowPage_Locked

Notice_DrawBodyText:: ; 65:49A2
	ld de, $FFFF
	ld hl, $0301
	ld bc, $0C12
	farcall TileCanvas_FillRect
	ld a, [wNotice_RecordPtr]
	ld l, a
	ld a, [wNotice_RecordPtrHi]
	ld h, a
	ld de, $0004
	add hl, de
	ld a, [hli]
	ld b, a
	ld a, [hl]
	ld h, a
	ld l, b
	ld a, $00
	ldh [hTextBox_ColorSelB], a
	ld a, $03
	ldh [hTextBox_ColorSelC], a
	ld a, $18
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $18
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hTextBox_LineStartX], a
	ld a, $00
	ldh [hTextBox_LineStartXHi], a
	ld a, $78
	ldh [hTextBox_MaxLineY], a
	ld a, $98
	ldh [hTextBox_RightLimitX], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hTextBox_LineAdvance], a
	ld a, $0C
	ldh [hRam_FFC7], a
	xor a, a
	call TextEngine_Run
	ld de, $9000
	ld hl, $0301
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0A01
	ld bc, $0512
	farcall TileCanvas_UploadRect
	ld hl, wScreenTileMap + $61
	ld bc, $0712
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	ld hl, wScreenTileMap + $141
	ld bc, $0512
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ret

Notice_LoadHeaderGfx:: ; 65:4A37
	ld a, [wNotice_RecordPtr]
	ld l, a
	ld a, [wNotice_RecordPtrHi]
	ld h, a
	push hl
	ld a, [hl]
	ld hl, $4A81
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
	ld de, $9301
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMAWithService
	pop hl
	inc hl
	ld a, [hl]
	ld hl, $4AC9
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $9581
	ld a, $58
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMAWithService
	ret

; ---- data $4A81-$4AD7 (86 bytes) [PROBABLE] descriptor table read by the executed code (up to 9 scenarios), 86 bytes: repeating groups of a flag byte (D0/50/90/10/40/C0) + 16-bit address (5841 5844 5846 ... = bank-58 tile sources; 4B5B 4B5E 4B60 ... and 7172 7174 = bank-65 / other addresses); exact record layout not decoded; the mapper 1-6 byte holes (4A84 4A90 4A9C 4AB1 4ACF) were unread bytes of this same table

Notice_HeaderGfxTable:: ; 65:4A81
Data_65_4A81::
	db $D0, $41, $58, $50, $44, $58, $D0, $46, $58, $50, $49, $58, $D0, $4B, $58, $50
	db $4E, $58, $D0, $50, $58, $50, $53, $58, $D0, $55, $58, $50, $58, $58, $D0, $5A
	db $58, $50, $5D, $58, $D0, $5F, $58, $50, $62, $58, $D0, $64, $58, $50, $67, $58
	db $90, $5B, $4B, $10, $5E, $4B, $90, $60, $4B, $10, $63, $4B, $90, $65, $4B, $10
	db $68, $4B, $40, $72, $71, $C0, $74, $71

Notice_FooterGfxTable:: ; 65:4AC9
	db $D0, $69, $50, $6C, $D0, $6E, $50, $71, $D0, $73, $50, $76, $D0, $78

Notice_DrawPageCounter:: ; 65:4AD7
Function_65_4AD7::
	; [CONFIRMED] 100 insn(s); 100 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wNotice_RecordPtr]
	ld l, a
	ld a, [wNotice_RecordPtrHi]
	ld h, a
	ld a, [hl]
	cp a, $04
	jr nz, .l4AEB
	ld a, $01
	ld [wNotice_DigitVariant], a
	jr .l4AEF
.l4AEB ; 65:4AEB
	xor a, a
	ld [wNotice_DigitVariant], a
.l4AEF ; 65:4AEF
	inc hl
	inc hl
	ld a, [hli]
	or a, a
	ret z
	push hl
	push af
	ld a, [wNotice_DigitVariant]
	ld hl, Notice_DigitRecordLists
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
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
	ld de, wScreenTileMap + $210
	ld a, $58
	farcall Tilemap_CopyRectAndAttr
	pop hl
	ld a, [hl]
	push af
	ld a, [wNotice_DigitVariant]
	ld hl, Notice_DigitRecordLists
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
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
	ld de, wScreenTileMap + $212
	ld a, $58
	farcall Tilemap_CopyRectAndAttr
	ld a, $0A
	push af
	ld a, [wNotice_DigitVariant]
	ld hl, Notice_DigitRecordLists
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
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
	ld de, wScreenTileMap + $211
	ld a, $58
	farcall Tilemap_CopyRectAndAttr
	ret

; ---- words $4B78-$4B7C (4 bytes) [PROBABLE] 2 pointers to the two lists below (4B7C, 4B92), read by the executed function 4AD7

Notice_DigitRecordLists:: ; 65:4B78
Table_65_4B78::
	dw Notice_DigitRecords_Normal, Notice_DigitRecords_Variant

; ---- words $4B7C-$4B92 (22 bytes) [PROBABLE] 11 words 7E48 7E4C ... 7E70 = addresses of the first 11 four-byte digit-glyph records (top tile, bottom tile, attr, attr) at 58:7E48 (bank 58 table 7E48-7EA0, 22 records); bank-58 addresses, not bank 65

Notice_DigitRecords_Normal:: ; 65:4B7C
Table_65_4B7C::
	dw $7E48, $7E4C, $7E50, $7E54, $7E58, $7E5C, $7E60, $7E64
	dw $7E68, $7E6C, $7E70

; ---- words $4B92-$4BA8 (22 bytes) [PROBABLE] 11 words 7E74 7E78 ... 7E9C = addresses of the other 11 four-byte records (attr 0A variant) at 58:7E74-7E9C; bank-58 addresses, not bank 65

Notice_DigitRecords_Variant:: ; 65:4B92
Table_65_4B92::
	dw $7E74, $7E78, $7E7C, $7E80, $7E84, $7E88, $7E8C, $7E90
	dw $7E94, $7E98, $7E9C

Notice_RequestPageSound:: ; 65:4BA8
Function_65_4BA8::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 9/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, Notice_PageSoundTable
	ld a, [wNotice_PageArg]
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hl]
	ld b, $00
	ld c, a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ret

; ---- data $4BC6-$4BE2 (28 bytes) [PROBABLE] 28 bytes read by the executed function 4BA8 (ld hl,$4BC6 ; indexed by [C27C]): 09 09 09 09 09 19 19 09 09 09 09 13 09 x12 then 00 00 00 00 (attribute-like/byte table); 1-byte unread holes at 4BD0 4BD2 4BD8 4BE1 merged

Notice_PageSoundTable:: ; 65:4BC6
Data_65_4BC6::
	db $09, $09, $09, $09, $09, $19, $19, $09, $09, $09, $09, $13, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09

Notice_PageTable:: ; 65:4BDE
	db $00, $00, $00, $00

; ---- data $4BE2-$4C6C (138 bytes) [PROBABLE] 23 records x 6 bytes: 16-bit pointer to a dialogue string (6E 4C -> 4C6E, FA 4C -> 4CFA, 50 4D -> 4D50 ... every pointer lands exactly on a string start of analysis/strings.tsv) + 4 bytes (id, 0/1/2 flags..., last byte unread in traces); the 1-byte and 6-byte mapper holes are the unread 6th bytes

Data_65_4BE2:: ; 65:4BE2
	dw NoticeText_RegistrationStart
	db $02, $01, $01, $03
	dw NoticeText_HaveManualReady
	db $02, $01, $02, $03
	dw NoticeText_AgreeToTerms
	db $02, $01, $03, $03
	dw NoticeText_ReadTerms
	db $03, $02, $00, $00
	dw NoticeText_RegistrationCancelled
	db $04, $00, $01, $02
	dw NoticeText_Welcome
	db $04, $05, $02, $02
	dw NoticeText_MailRegistrationForm
	db $16, $01, $00, $00
	dw NoticeText_UsageFeeWarning
	db $0F, $01, $01, $02
	dw NoticeText_DeleteRegistrationWarning
	db $15, $01, $02, $02
	dw NoticeText_DeleteBeforeDisposal
	db $06, $06, $00, $00
	dw NoticeText_DeleteCancelled
	db $07, $02, $00, $00
	dw NoticeText_DeleteDone
	db $10, $01, $00, $00
	dw NoticeText_ManualPhoneEntry
	db $11, $06, $00, $00
	dw NoticeText_PhoneChangeDone
	db $12, $06, $00, $00
	dw NoticeText_PhoneChangeCancelled
	db $08, $01, $00, $00
	dw NoticeText_PasswordChangeIntro
	db $14, $01, $00, $00
	dw NoticeText_PasswordRules
	db $0A, $06, $00, $00
	dw NoticeText_PasswordChangeCancelled
	db $13, $06, $00, $00
	dw NoticeText_PasswordChangeDone
	db $0B, $01, $00, $00
	dw NoticeText_UsageTimeIntro
	db $0C, $06, $00, $00
	dw NoticeText_UsageTimeCancelled
	db $0D, $01, $00, $00
	dw NoticeText_UsageFeeIntro
	db $0E, $06, $00, $00
	dw NoticeText_UsageFeeCancelled
	db $17, $00, $00, $00

; ---- data $4C6C-$4C6E (2 bytes) [PROBABLE] 24 56 = word 5624, the 24th string pointer of Data_65_4BE2 (string at 5624 exists); the mapper included these two bytes in the text run

Data_65_4C6C:: ; 65:4C6C
	dw NoticeText_ResumeRegistration
