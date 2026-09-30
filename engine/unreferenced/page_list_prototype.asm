; engine/unreferenced/page_list_prototype.asm
; bank 7F, $4C78-$61FC (5508 bytes); pinned by layout.link
; text-canvas demo and page-list prototype with no caller (about 6 KB, hypothesis)

SECTION "engine/unreferenced/page_list_prototype", ROMX

; ---- code $4C78-$4D50 (216 bytes) [PROBABLE] 116 insn(s) reached by static flow only; seeds: site x116; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 115/116 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_7F_4C78:: ; 7F:4C78
	farcall Function_00_09B6
	call Canvas_InitScreen
	call Function_7F_4E85

Label_7F_4C84:: ; 7F:4C84
	call Function_7F_4D95

Label_7F_4C87:: ; 7F:4C87
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_7F_4C87
	call Function_7F_4E0D

Label_7F_4C96:: ; 7F:4C96
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, $02
	ret nz
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_7F_4C96
	jr Label_7F_4C84

Canvas_InitScreen:: ; 7F:4CA9
	ldh a, [rLCDC]
	push af
	and a, $80
	jr z, Label_7F_4CBE
	di

Label_7F_4CB1:: ; 7F:4CB1
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_7F_4CB1
	ldh a, [rLCDC]
	and a, $7F
	ldh [rLCDC], a
	ei

Label_7F_4CBE:: ; 7F:4CBE
	xor a, a
	ldh [rVBK], a
	ld hl, $8800
	ld bc, $1000

Label_7F_4CC7:: ; 7F:4CC7
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_4CC7
	ld hl, $9800
	ld b, $12
	ld c, $14
	ld d, $00

Label_7F_4CD7:: ; 7F:4CD7
	ld a, d
	cp a, $F0
	jr nz, Label_7F_4CDE
	xor a, a
	ld d, a

Label_7F_4CDE:: ; 7F:4CDE
	ld [hli], a
	inc d
	dec c
	jr nz, Label_7F_4CD7
	ld c, $14
	push bc
	ld bc, $000C
	add hl, bc
	pop bc
	dec b
	jr nz, Label_7F_4CD7
	ld a, $01
	ldh [rVBK], a
	ld hl, $8800
	ld bc, $1000

Label_7F_4CF8:: ; 7F:4CF8
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_4CF8
	ld hl, $9800
	ld bc, $0180

Label_7F_4D05:: ; 7F:4D05
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_4D05
	ld hl, $9980
	ld b, $C0

Label_7F_4D11:: ; 7F:4D11
	ld a, $08
	ld [hli], a
	dec b
	jr nz, Label_7F_4D11
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $1000
	ld hl, $D000

Label_7F_4D23:: ; 7F:4D23
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_4D23
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0800
	ld hl, $D000

Label_7F_4D36:: ; 7F:4D36
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_4D36
	ld a, $80
	ldh [rBCPS], a
	ld hl, Palette_7F_4D50
	ld b, $08

Label_7F_4D46:: ; 7F:4D46
	ld a, [hli]
	ldh [rBCPD], a
	dec b
	jr nz, Label_7F_4D46
	pop af
	ldh [rLCDC], a
	ret

; ---- data $4D50-$4D58 (8 bytes) [PROBABLE] 8 bytes = one RGB555 palette (7FFF 7C00 001F 0000) written to the palette port with ld hl,$4D50 ; ld b,8 ; ld a,[hli] ; ldh [$69],a at 7F:4D41-4D49

Palette_7F_4D50:: ; 7F:4D50
	db $FF, $7F, $00, $7C, $1F, $00, $00, $00

; ---- code $4D58-$4D5E (6 bytes) [PROBABLE] function head ld hl,$4D88 ; ld de,$0000 : the loop that follows (4D5E, PROBABLE, jr nz back at 4D85) prints the string at 7F:4D88 ("Sample DATA.") glyph by glyph; immediate = exact string start; no caller found, entry unproven
	ld hl, $4D88
	ld de, $0000

; ---- code $4D5E-$4D88 (42 bytes) [PROBABLE] 25 insn(s) reached by static flow only; seeds: site x25; min discovery hops 0; entered by jrcc from 7F:4D85 (PROBABLE code)

Label_7F_4D5E:: ; 7F:4D5E
	ld a, [hli]
	push hl
	push de
	ld b, a
	ld de, $C0A0
	call Glyph_LoadAscii
	pop de
	push de
	ld hl, $C0A0
	ld b, $03
	ld c, $00
	farcall Canvas_BlitGlyph
	call Canvas_UploadToVram
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	pop hl
	ld a, [hl]
	cp a, $00
	jr nz, Label_7F_4D5E
	ret

; ---- text $4D88-$4D95 (13 bytes) [PROBABLE] ASCII string "Sample DATA." + NUL, address loaded by ld hl,$4D88 at 7F:4D58

String_7F_4D88:: ; 7F:4D88
	db $53, $61, $6D, $70, $6C, $65, $20, $44, $41, $54, $41, $2E, $00 ; "Sample DATA."

; ---- code $4D95-$4DF2 (93 bytes) [PROBABLE] 56 insn(s) reached by static flow only; seeds: site x56; min discovery hops 0; entered by call from 7F:4C84 (PROBABLE code) | forced execution: 56/56 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_7F_4D95:: ; 7F:4D95
	ld b, $0C
	ld de, $0000

Label_7F_4D9A:: ; 7F:4D9A
	push bc
	push de
	ld e, $00
	ld hl, String_7F_4DF2

Label_7F_4DA1:: ; 7F:4DA1
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	push de
	ld h, b
	ld l, c
	ld a, $00
	ld de, $C0B8
	ld bc, $C0A0
	call Glyph_LoadWide
	pop de
	push de
	ld hl, $C0A0
	ld b, $03
	ld c, $00
	farcall Canvas_BlitGlyph
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	push de
	ld hl, $C0B8
	ld b, $03
	ld c, $00
	farcall Canvas_BlitGlyph
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	pop hl
	ld a, [hl]
	cp a, $00
	jr nz, Label_7F_4DA1
	pop de
	pop bc
	ld a, d
	add a, $0C
	ld d, a
	dec b
	jr nz, Label_7F_4D9A
	call Canvas_UploadToVram
	ret

; ---- text $4DF2-$4E0D (27 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_7F_4DF2:: ; 7F:4DF2
	db $83, $54, $83, $93, $83, $76, $83, $8B, $83, $66, $81, $5B, $83, $5E, $82, $C5, $82, $B7, $82, $A9, $82, $E7, $82, $CB, $81, $60, $00 ; "サンプルデータですからね～"

; ---- code $4E0D-$4E6A (93 bytes) [PROBABLE] 56 insn(s) reached by static flow only; seeds: site x56; min discovery hops 0; entered by call from 7F:4C93 (PROBABLE code) | forced execution: 56/56 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_7F_4E0D:: ; 7F:4E0D
	ld b, $0C
	ld de, $0000

Label_7F_4E12:: ; 7F:4E12
	push bc
	push de
	ld e, $00
	ld hl, String_7F_4E6A

Label_7F_4E19:: ; 7F:4E19
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	push de
	ld h, b
	ld l, c
	ld a, $00
	ld de, $C0B8
	ld bc, $C0A0
	call Glyph_LoadWide
	pop de
	push de
	ld hl, $C0A0
	ld b, $00
	ld c, $03
	farcall Canvas_BlitGlyph
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	push de
	ld hl, $C0B8
	ld b, $00
	ld c, $03
	farcall Canvas_BlitGlyph
	pop de
	inc e
	inc e
	inc e
	inc e
	inc e
	inc e
	pop hl
	ld a, [hl]
	cp a, $00
	jr nz, Label_7F_4E19
	pop de
	pop bc
	ld a, d
	add a, $0C
	ld d, a
	dec b
	jr nz, Label_7F_4E12
	call Canvas_UploadToVram
	ret

; ---- text $4E6A-$4E85 (27 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_7F_4E6A:: ; 7F:4E6A
	db $83, $54, $83, $93, $83, $76, $83, $8B, $83, $66, $81, $5B, $83, $5E, $82, $C5, $82, $B7, $82, $A9, $82, $E7, $82, $CB, $81, $60, $00 ; "サンプルデータですからね～"

; ---- code $4E85-$4E89 (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 1; entered by call from 7F:4C81 (PROBABLE code) | forced execution: 2/2 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Function_7F_4E85:: ; 7F:4E85
	call Canvas_UploadToVram
	ret

; ---- ptrtable $4E89-$4E95 (12 bytes) [PROBABLE] 6 x dw string pointers (4E95, 4EA8, 4EC1, 4ED0, 4EE1, 4EE8); every target is a string start of the text below (Japanese/ASCII page names); 7F:4E85 (call $4BBC ; ret) precedes it; no ld hl,$4E89 found, so the reader is unlocated

Sample_PageNamePtrs:: ; 7F:4E89
Table_7F_4E89::
	dw String_7F_4E95
	dw $4EA8
	dw $4EC1
	dw String_7F_4ED0
	dw $4EE1
	dw $4EE8

; ---- text $4E95-$4ED0 (59 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_7F_4E95:: ; 7F:4E95
	db $94, $43, $93, $56, $93, $B0, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "任天堂ホームページ"
	db $83, $7C, $83, $50, $83, $62, $83, $67, $83, $82, $83, $93, $83, $58, $83, $5E, $81, $5B, $81, $63, $81, $49, $81, $48, $00 ; "ポケットモンスター…！？"
	db $47, $41, $4D, $45, $46, $52, $45, $41, $4B, $20, $48, $4F, $4D, $45, $00 ; "GAMEFREAK HOME"

; ---- text $4ED0-$4EF0 (32 bytes) [PROBABLE] ASCII "MissingLink_HOME" + $07 (control byte) + "sample" + NUL, followed by "sample" and "sample2" strings that are the last targets (4EE1, 4EE8) of the table 7F:4E89

String_7F_4ED0:: ; 7F:4ED0
	db $4D, $69, $73, $73, $69, $6E, $67, $4C, $69, $6E, $6B, $5F, $48, $4F, $4D, $45, $07, $73, $61, $6D, $70, $6C, $65, $00 ; "MissingLink_HOME<$07>sample"
	db $73, $61, $6D, $70, $6C, $65, $32, $00 ; "sample2"

; ---- ptrtable $4EF0-$4EFC (12 bytes) [PROBABLE] little-endian word table, 6 entries, monotone=1.00, 83% of targets on string start/after NUL, targets $4EFC..$4F79; regular record stride between targets; verifier: truncated from 8 to 6 entries: entry 0 = 4EFC is where the table ends

Sample_PageUrlPtrs:: ; 7F:4EF0
Table_7F_4EF0::
	dw String_7F_4EFC
	dw String_7F_4F15
	dw $4F2F
	dw $4F49
	dw $4F67
	dw $4F79

; ---- text $4EFC-$4F15 (25 bytes) [PROBABLE] ASCII URL "http://www.nintendo.com/" + NUL = first target (4EFC) of the pointer table 7F:4EF0

String_7F_4EFC:: ; 7F:4EFC
	db $68, $74, $74, $70, $3A, $2F, $2F, $77, $77, $77, $2E, $6E, $69, $6E, $74, $65, $6E, $64, $6F, $2E, $63, $6F, $6D, $2F, $00 ; "http://www.nintendo.com/"

; ---- text $4F15-$4FC3 (174 bytes) [PROBABLE] text: 8 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_7F_4F15:: ; 7F:4F15
	db $68, $74, $74, $70, $3A, $2F, $2F, $77, $77, $77, $2E, $70, $6F, $6B, $65, $6D, $6F, $6E, $2E, $63, $6F, $2E, $6A, $70, $2F, $00 ; "http://www.pokemon.co.jp/"
	db $68, $74, $74, $70, $3A, $2F, $2F, $77, $77, $77, $2E, $67, $61, $6D, $65, $66, $72, $65, $65, $6B, $2E, $6E, $65, $74, $2F, $00 ; "http://www.gamefreek.net/"
	db $68, $74, $74, $70, $3A, $2F, $2F, $77, $77, $77, $2E, $6D, $69, $73, $73, $69, $6E, $67, $6C, $69, $6E, $6B, $2E, $63, $6F, $2E, $6A, $70, $2F, $00 ; "http://www.missinglink.co.jp/"
	db $68, $74, $74, $70, $3A, $2F, $2F, $73, $61, $6D, $70, $6C, $65, $2E, $74, $6F, $2F, $00 ; "http://sample.to/"
	db $68, $74, $74, $70, $3A, $2F, $2F, $73, $61, $6D, $70, $6C, $65, $32, $2E, $74, $6F, $2F, $00 ; "http://sample2.to/"
	db $83, $65, $83, $58, $83, $67, $83, $79, $81, $5B, $83, $57, $00 ; "テストページ"
	db $68, $74, $70, $70, $3A, $2F, $2F, $77, $6F, $72, $6B, $2E, $64, $61, $6D, $6D, $79, $2E, $63, $6F, $2E, $6A, $70, $2F, $00 ; "htpp://work.dammy.co.jp/"
	db $8D, $7C, $83, $7C, $83, $50, $83, $82, $83, $93, $82, $C9, $90, $69, $89, $BB, $00 ; "鋼ポケモンに進化"

; ---- words $4FC3-$4FCF (12 bytes) [PROBABLE] 6 words = SRAM addresses A084,A184,A284,A384,A484,A584 (not text although the bytes 84 A0.. are valid Shift-JIS): read by 7 code sites as ld hl,$4FC3 ; ld a,[hli] ; ld e,a ; ld a,[hli] ; ld d,a ; ld a,[de] (7F:5386 ...) and by ld hl,$4FC5/$4FC7/... (entries)

PageListProto_UrlSlotTable:: ; 7F:4FC3
Table_7F_4FC3::
	dw $A084, $A184, $A284, $A384, $A484, $A584

; ---- words $4FCF-$4FDB (12 bytes) [PROBABLE] 6 words = SRAM addresses A000,A016,A02C,A042,A058,A06E (stride $16), read via ld hl,$4FCF at 7 code sites (7F:5709, 5731, 579A, 57C2, 5F2E, 5F87, 61B5)

PageListProto_TitleSlotTable:: ; 7F:4FCF
Table_7F_4FCF::
	dw $A000, $A016, $A02C, $A042, $A058, $A06E

; ---- code $4FDB-$4FF5 (26 bytes) [PROBABLE] function head (push af ; ldh a,[$FF70] ; push af ; ld a,1 ; ... ld [$D724],a ; ld a,0 ; ld [$D725],a ; pop af ... pop af) flowing into the validated far-call site at 4FF5 (call 7F:7271, an executed function); starts right after the word table above; no caller found, entry unproven

Function_7F_4FDB:: ; 7F:4FDB
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

; ---- code $4FF5-$51ED (504 bytes) [PROBABLE] 221 insn(s) reached by static flow only; seeds: site x221; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Stat_EnableScrollSplit
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D500]
	cp a, $00
	jr nz, Label_7F_500C
	xor a, a
	ld [wDialogOnlineSnapshot], a

Label_7F_500C:: ; 7F:500C
	call Function_7F_51EE
	ld c, $00

Function_7F_5011:: ; 7F:5011
	push bc
	farcall Function_00_0956
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, Label_7F_5128
	ld a, [wTimerEnable]
	bit 1, a
	jr z, Label_7F_503A
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_7F_503A:: ; 7F:503A
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_7F_5091
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_7F_5088
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_7F_5089
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_7F_5088
	jr nz, Label_7F_5064
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_7F_5088

Label_7F_5064:: ; 7F:5064
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_7F_5074
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_7F_5088
	set 1, [hl]

Label_7F_5074:: ; 7F:5074
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_7F_5089
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_7F_5089

Label_7F_5088:: ; 7F:5088
	xor a, a

Label_7F_5089:: ; 7F:5089
	pop hl
	or a, a
	jp nz, Label_7F_5115
	jp Label_7F_5128

Label_7F_5091:: ; 7F:5091
	xor a, a
	ld [wBrowserFetchResult], a
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0110
	farcall Dialog_Open
	farcall Dialog_WaitInputMonitored
	farcall Dialog_Close
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	pop bc
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call Function_7F_51EE
	farcall Sprites_RestoreSlotsFromBank3
	farcall Function_00_0956
	call Function_00_044B
	pop bc
	jp Function_7F_5011

Label_7F_5115:: ; 7F:5115
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_7F_5128:: ; 7F:5128
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_7F_516A
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
	call Function_7F_5647
	call Function_7F_56AE
	pop bc
	call Function_7F_5989
	inc a
	ret z
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call Function_7F_56AE
	ld a, $03
	ld b, $00
	call Function_7F_591E
	pop bc

Label_7F_516A:: ; 7F:516A
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_7F_5196
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0048
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_7F_5196:: ; 7F:5196
	ldh a, [hJoyPressedRepeat]
	and a, $40
	jr z, Label_7F_51C0
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	dec c
	ld a, $FF
	cp a, c
	jr nz, Label_7F_51B9
	ld c, $05

Label_7F_51B9:: ; 7F:51B9
	ld a, d
	call Function_7F_56F1
	call Function_7F_5306

Label_7F_51C0:: ; 7F:51C0
	ldh a, [hJoyPressedRepeat]
	and a, $80
	jr z, Label_7F_51EA
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	inc c
	ld a, $06
	cp a, c
	jr nz, Label_7F_51E3
	ld c, $00

Label_7F_51E3:: ; 7F:51E3
	ld a, d
	call Function_7F_56F1
	call Function_7F_5306

Label_7F_51EA:: ; 7F:51EA
	jp Function_7F_5011

; ---- data $51ED-$51EE (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $C9 (ret) after the unconditional jp $5011 at 51EA and before the function 51EE; no branch/call to 51ED found; left unclassified

Data_7F_51ED:: ; 7F:51ED
	db $C9

; ---- code $51EE-$5CB8 (2762 bytes) [PROBABLE] 1292 insn(s) reached by static flow only; seeds: site x1292; min discovery hops 0; entered by call from 7F:500C (PROBABLE code)

Function_7F_51EE:: ; 7F:51EE
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $1000

Label_7F_51FB:: ; 7F:51FB
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_51FB
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0780

Label_7F_520E:: ; 7F:520E
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_7F_520E
	farcall Canvas_UploadToVram
	farcall LCDOff
	farcall Function_00_09B6
	ld de, $9001
	ld hl, Data_7F_62B0
	ld a, $7F
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_7F_66B0
	ld a, $7F
	ld b, $97
	ld c, $12
	farcall Function_00_0787
	ld de, $8000
	ld hl, Data_7F_6AE0
	ld a, $7F
	ld b, $94
	ld c, $29
	farcall Function_00_0787
	ld hl, $DA10
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld de, $6000
	ld hl, $DA10
	call Function_00_0A65
	ld bc, $1214
	ld de, $D000
	ld hl, Data_7F_67D0
	ld a, $7F
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	di
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_7F_6D70
	ld a, $7F
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_7F_6AA0
	ld a, $7F
	farcall Palette_LoadToBuffer
	ei
	farcall LCDOn
	call Function_7F_577D
	ld c, $00
	call Function_7F_5306
	ld a, $03
	ld b, $00
	call Function_7F_591E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001A
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
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
	pop bc
	ret

Function_7F_5306:: ; 7F:5306
	push bc
	call Function_7F_530F
	call Function_7F_546A
	pop bc
	ret

Function_7F_530F:: ; 7F:530F
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld hl, $DA10
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA30
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA40
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA50
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA60
	ld de, $6DF0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, PageListProto_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_53A2
	ld hl, $DA10
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_53A2:: ; 7F:53A2
	ld hl, $4FC5
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_53BE
	ld hl, $DA20
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_53BE:: ; 7F:53BE
	ld hl, $4FC7
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_53DA
	ld hl, $DA30
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_53DA:: ; 7F:53DA
	ld hl, $4FC9
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_53F6
	ld hl, $DA40
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_53F6:: ; 7F:53F6
	ld hl, $4FCB
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_5412
	ld hl, $DA50
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_5412:: ; 7F:5412
	ld hl, $4FCD
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_542E
	ld hl, $DA60
	ld de, $6DE0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82

Label_7F_542E:: ; 7F:542E
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $22
	ld [wSpriteSlots + 32], a
	ld a, $2E
	ld [wSpriteSlots + 48], a
	ld a, $3A
	ld [wSpriteSlots + 64], a
	ld a, $46
	ld [wSpriteSlots + 80], a
	ld a, $52
	ld [wSpriteSlots + 96], a
	ld a, $05
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 65], a
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 97], a
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

Function_7F_546A:: ; 7F:546A
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	xor a, a
	cp a, c
	jr nz, Label_7F_54CB
	ld hl, PageListProto_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_54AE
	ld hl, $DA10
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $05
	ld [wSpriteSlots + 17], a
	jp Label_7F_563D

Label_7F_54AE:: ; 7F:54AE
	ld hl, $DA10
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $05
	ld [wSpriteSlots + 17], a
	jp Label_7F_563D

Label_7F_54CB:: ; 7F:54CB
	inc a
	cp a, c
	jr nz, Label_7F_5515
	ld hl, $4FC5
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_54F8
	ld hl, $DA20
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $22
	ld [wSpriteSlots + 32], a
	ld a, $05
	ld [wSpriteSlots + 33], a
	jp Label_7F_563D

Label_7F_54F8:: ; 7F:54F8
	ld hl, $DA20
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $22
	ld [wSpriteSlots + 32], a
	ld a, $05
	ld [wSpriteSlots + 33], a
	jp Label_7F_563D

Label_7F_5515:: ; 7F:5515
	inc a
	cp a, c
	jr nz, Label_7F_555F
	ld hl, $4FC7
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_5542
	ld hl, $DA30
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $2E
	ld [wSpriteSlots + 48], a
	ld a, $05
	ld [wSpriteSlots + 49], a
	jp Label_7F_563D

Label_7F_5542:: ; 7F:5542
	ld hl, $DA30
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $2E
	ld [wSpriteSlots + 48], a
	ld a, $05
	ld [wSpriteSlots + 49], a
	jp Label_7F_563D

Label_7F_555F:: ; 7F:555F
	inc a
	cp a, c
	jr nz, Label_7F_55A9
	ld hl, $4FC9
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_558C
	ld hl, $DA40
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $3A
	ld [wSpriteSlots + 64], a
	ld a, $05
	ld [wSpriteSlots + 65], a
	jp Label_7F_563D

Label_7F_558C:: ; 7F:558C
	ld hl, $DA40
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $3A
	ld [wSpriteSlots + 64], a
	ld a, $05
	ld [wSpriteSlots + 65], a
	jp Label_7F_563D

Label_7F_55A9:: ; 7F:55A9
	inc a
	cp a, c
	jr nz, Label_7F_55F3
	ld hl, $4FCB
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_55D6
	ld hl, $DA50
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $46
	ld [wSpriteSlots + 80], a
	ld a, $05
	ld [wSpriteSlots + 81], a
	jp Label_7F_563D

Label_7F_55D6:: ; 7F:55D6
	ld hl, $DA50
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $46
	ld [wSpriteSlots + 80], a
	ld a, $05
	ld [wSpriteSlots + 81], a
	jp Label_7F_563D

Label_7F_55F3:: ; 7F:55F3
	inc a
	cp a, c
	jr nz, Label_7F_563D
	ld hl, $4FCD
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_7F_5620
	ld hl, $DA60
	ld de, $6DC0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $52
	ld [wSpriteSlots + 96], a
	ld a, $05
	ld [wSpriteSlots + 97], a
	jp Label_7F_563D

Label_7F_5620:: ; 7F:5620
	ld hl, $DA60
	ld de, $6DD0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $52
	ld [wSpriteSlots + 96], a
	ld a, $05
	ld [wSpriteSlots + 97], a
	jp Label_7F_563D

Label_7F_563D:: ; 7F:563D
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

Function_7F_5647:: ; 7F:5647
	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld e, c
	sla e
	ld d, $00
	ld hl, PageListProto_UrlSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr nz, Label_7F_568B
	ld d, $00
	ld e, $00
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	jr z, Label_7F_5686
	ld a, $01

Label_7F_5686:: ; 7F:5686
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret

Label_7F_568B:: ; 7F:568B
	ld d, $01
	ld e, $01
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	jr z, Label_7F_56A9
	ld a, $01
	ld d, $01

Label_7F_56A9:: ; 7F:56A9
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret

Function_7F_56AE:: ; 7F:56AE
	push bc
	di
	ld b, a
	ld a, $01
	ldh [rVBK], a

Label_7F_56B5:: ; 7F:56B5
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_7F_56B5
	ld a, $0B
	dec b
	jr z, Label_7F_56C2
	ld a, $0C

Label_7F_56C2:: ; 7F:56C2
	ld hl, $99A4
	ld [hli], a
	ld [hl], a
	ld hl, $99C4
	ld [hli], a
	ld [hl], a
	ld a, $0B
	dec d
	jr z, Label_7F_56D3
	ld a, $0C

Label_7F_56D3:: ; 7F:56D3
	ld hl, $99A9
	ld [hli], a
	ld [hl], a
	ld hl, $99C9
	ld [hli], a
	ld [hl], a
	ld a, $0B
	dec e
	jr z, Label_7F_56E4
	ld a, $0C

Label_7F_56E4:: ; 7F:56E4
	ld hl, $99AE
	ld [hli], a
	ld [hl], a
	ld hl, $99CE
	ld [hli], a
	ld [hl], a
	ei
	pop bc
	ret

Function_7F_56F1:: ; 7F:56F1
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, PageListProto_TitleSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0018
	ld b, a
	xor a, a
	inc b

Label_7F_5719:: ; 7F:5719
	dec b
	jr z, Label_7F_5720
	add a, $0C
	jr Label_7F_5719

Label_7F_5720:: ; 7F:5720
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call Function_7F_5805
	pop bc
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, PageListProto_TitleSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
	push hl
	ld de, $0018
	ld b, c
	xor a, a
	inc b

Label_7F_5742:: ; 7F:5742
	dec b
	jr z, Label_7F_5749
	add a, $0C
	jr Label_7F_5742

Label_7F_5749:: ; 7F:5749
	add a, $10
	ld d, a
	ld b, $00
	ld c, $01
	call Function_7F_5805
	pop hl
	pop bc
	push bc
	ld b, $03
	ld c, $00
	ld de, $0218
	ld hl, $D3C0
	call Function_7F_5805
	farcall Function_7F_58B9
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call Function_7F_56AE
	pop bc
	ret

Function_7F_577D:: ; 7F:577D
	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	xor a, a
	ld d, $06

Label_7F_5791:: ; 7F:5791
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, PageListProto_TitleSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0018
	ld b, a
	xor a, a
	inc b

Label_7F_57AA:: ; 7F:57AA
	dec b
	jr z, Label_7F_57B1
	add a, $0C
	jr Label_7F_57AA

Label_7F_57B1:: ; 7F:57B1
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call Function_7F_5805
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, Label_7F_5791
	ld hl, PageListProto_TitleSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	push hl
	ld de, $1018
	ld b, $00
	ld c, $01
	call Function_7F_5805
	pop hl
	pop bc
	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $03
	ld c, $00
	ld de, $0218
	ld hl, $D3C0
	call Function_7F_5805
	farcall Function_7F_58B9
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call Function_7F_56AE
	pop bc
	ret

Function_7F_5805:: ; 7F:5805
	ld a, $14
	ld [wTextCellsLeft], a

Label_7F_580A:: ; 7F:580A
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jr z, Label_7F_5885
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_7F_5860
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
	call Function_7F_58A5
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
	jr z, Label_7F_5885
	cp a, $01
	jr z, Label_7F_5885
	jr Label_7F_580A

Label_7F_5860:: ; 7F:5860
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
	call Function_7F_58A5
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_7F_5885
	cp a, $01
	jr z, Label_7F_5885
	jr Label_7F_580A

Label_7F_5885:: ; 7F:5885
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_7F_5896:: ; 7F:5896
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call Function_7F_58A5
	jr Label_7F_5896

Function_7F_58A5:: ; 7F:58A5
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

Function_7F_58B9:: ; 7F:58B9
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Function_7F_58F9
	call Function_00_0392
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Function_7F_58F9
	call Function_00_0392
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D800
	ld de, $8800
	ld c, $6F
	call Function_7F_58F9
	call Function_00_0392
	ret

Function_7F_58F9:: ; 7F:58F9
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44
	di

Label_7F_5909:: ; 7F:5909
	ld a, [de]
	cp a, $8F
	jr nz, Label_7F_5909
	ld b, $91

Label_7F_5910:: ; 7F:5910
	ld a, [de]
	cp a, b
	jr nz, Label_7F_5910
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	xor a, a
	ldh [rSCY], a
	ei
	ret

Function_7F_591E:: ; 7F:591E
	push bc
	push de
	push hl
	cp a, $00
	jr z, Label_7F_5946
	cp a, $01
	jr z, Label_7F_595B
	cp a, $02
	jr z, Label_7F_5970
	cp a, $03
	jr z, Label_7F_5931

Label_7F_5931:: ; 7F:5931
	ld de, $9581
	ld hl, Tiles_52_4080
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Function_00_0749
	jp Label_7F_5985

Label_7F_5946:: ; 7F:5946
	ld de, $9581
	ld hl, $4680
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Function_00_0749
	jp Label_7F_5985

Label_7F_595B:: ; 7F:595B
	ld de, $9581
	ld hl, $4380
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Function_00_0749
	jp Label_7F_5985

Label_7F_5970:: ; 7F:5970
	ld de, $9581
	ld hl, $4980
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Function_00_0749
	jp Label_7F_5985

Label_7F_5985:: ; 7F:5985
	pop hl
	pop de
	pop bc
	ret

Function_7F_5989:: ; 7F:5989
	call Function_7F_5BB5
	call Function_7F_61E7
	ld b, $00

Label_7F_5991:: ; 7F:5991
	push bc
	farcall Function_00_0956
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, Label_7F_5ACF
	ld a, [wTimerEnable]
	bit 1, a
	jr z, Label_7F_59BA
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_7F_59BA:: ; 7F:59BA
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_7F_5A11
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_7F_5A08
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_7F_5A09
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_7F_5A08
	jr nz, Label_7F_59E4
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_7F_5A08

Label_7F_59E4:: ; 7F:59E4
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_7F_59F4
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_7F_5A08
	set 1, [hl]

Label_7F_59F4:: ; 7F:59F4
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_7F_5A09
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_7F_5A09

Label_7F_5A08:: ; 7F:5A08
	xor a, a

Label_7F_5A09:: ; 7F:5A09
	pop hl
	or a, a
	jp nz, Label_7F_5AC4
	jp Label_7F_5ACF

Label_7F_5A11:: ; 7F:5A11
	xor a, a
	ld [wBrowserFetchResult], a
	farcall Sprites_SaveSlotsToBank3
	ld hl, $DAB0
	call Function_00_09E6
	ld de, $0110
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
	farcall Dialog_Open
	farcall Dialog_WaitInputMonitored
	farcall Dialog_Close
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
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	farcall Function_00_09B6
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wRam_C1DC], a
	ld a, [wTimerEnable]
	ld [wDialogOnlineSnapshot], a
	pop bc
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
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call Function_7F_51EE
	farcall Sprites_RestoreSlotsFromBank3
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	jp Label_7F_5991

Label_7F_5AC4:: ; 7F:5AC4
	pop bc
	pop af
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_7F_5ACF:: ; 7F:5ACF
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	call nz, Function_7F_61E6
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_7F_5B2D
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
	ld a, b
	cp a, $01
	jr nz, Label_7F_5B02
	call Function_7F_5D0A
	jr Label_7F_5B09

Label_7F_5B02:: ; 7F:5B02
	cp a, $02
	jr nz, Label_7F_5B1A
	call Function_7F_5FBC

Label_7F_5B09:: ; 7F:5B09
	inc a
	jp nz, Label_7F_5991
	call Function_7F_5C13
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret

Label_7F_5B1A:: ; 7F:5B1A
	call Function_7F_5F5D
	inc a
	jp nz, Label_7F_5991
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ret

Label_7F_5B2D:: ; 7F:5B2D
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_7F_5B54
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0048
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	call Function_7F_5C13
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret

Label_7F_5B54:: ; 7F:5B54
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, Label_7F_5B83
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, b
	dec b
	ld a, $FF
	cp a, b
	jr nz, Label_7F_5B77
	ld b, $02

Label_7F_5B77:: ; 7F:5B77
	ld a, d
	call Function_7F_5CB4
	ld a, b
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d

Label_7F_5B83:: ; 7F:5B83
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, Label_7F_5BB2
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, b
	inc b
	ld a, $03
	cp a, b
	jr nz, Label_7F_5BA6
	ld b, $00

Label_7F_5BA6:: ; 7F:5BA6
	ld a, d
	call Function_7F_5CB4
	ld a, b
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d

Label_7F_5BB2:: ; 7F:5BB2
	jp Label_7F_5991

Function_7F_5BB5:: ; 7F:5BB5
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA80
	ld de, $6E00
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $1F
	ld [wSpriteSlots + 129], a
	ld hl, $DA70
	ld de, Table_7F_6DB0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld de, $6000
	ld hl, $DA70
	call Function_00_0A65
	ld a, $F2
	ld [wSpriteSlots + 113], a
	ld a, $66
	ld [wSpriteSlots + 112], a

Label_7F_5BF9:: ; 7F:5BF9
	ld a, [wSpriteSlots + 113]
	inc a
	inc a
	inc a
	inc a
	cp a, $22
	jr z, Label_7F_5C09
	ld [wSpriteSlots + 113], a
	jr Label_7F_5BF9

Label_7F_5C09:: ; 7F:5C09
	pop bc
	xor a, a
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d
	ret

Function_7F_5C13:: ; 7F:5C13
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, $E8
	ld [wSpriteSlots + 129], a
	farcall Function_00_0956
	ld a, [wSpriteSlots + 113]
	inc a
	inc a
	inc a
	inc a
	inc a
	inc a
	inc a
	inc a
	cp a, $AE
	ld a, $AE
	ld [wSpriteSlots + 113], a
	pop bc
	ret

Function_7F_5C39:: ; 7F:5C39
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	cp a, b
	jr nz, Label_7F_5C66
	ld hl, $DA80
	ld de, $6E00
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $1F
	ld [wSpriteSlots + 129], a
	ld a, $1E
	ld [wSpriteSlots + 113], a
	pop bc
	ret

Label_7F_5C66:: ; 7F:5C66
	ld a, $01
	cp a, b
	jr nz, Label_7F_5C8C
	ld hl, $DA80
	ld de, $6E10
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $46
	ld [wSpriteSlots + 129], a
	ld a, $46
	ld [wSpriteSlots + 113], a
	pop bc
	ret

Label_7F_5C8C:: ; 7F:5C8C
	ld a, $02
	cp a, b
	jr nz, Label_7F_5CB2
	ld hl, $DA80
	ld de, $6E20
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $71
	ld [wSpriteSlots + 129], a
	ld a, $6E
	ld [wSpriteSlots + 113], a
	pop bc
	ret

Label_7F_5CB2:: ; 7F:5CB2
	pop bc
	ret

Function_7F_5CB4:: ; 7F:5CB4
	call Function_7F_5C39
	ret

; ---- code $5CB8-$5CDC (36 bytes) [PROBABLE] first half of a function (cp a,b ; ret z ; push af ; ld a,$E8 ; ld [$DA81],a ... jr c,$5CE7 ; ... call $5C39 (called from 7F:5CB4) ; push bc ; far call) that continues in the PROBABLE site region 5CDC and, through the jr c target 5CE7, in the second half; all direct targets land on instruction starts (5C39, 5CE7, 0464, 5CCA loop)
	cp a, b
	ret z
	push af
	ld a, $E8
	ld [wSpriteSlots + 129], a
	pop af
	push bc
	jr c, Label_7F_5CE7
	ld a, [wSpriteSlots + 113]
	sub a, $28
	ld d, a

Label_7F_5CCA:: ; 7F:5CCA
	ld a, [wSpriteSlots + 113]
	dec a
	dec a
	dec a
	dec a
	ld [wSpriteSlots + 113], a
	cp a, d
	jr nz, Label_7F_5CCA
	pop bc
	call Function_7F_5C39
	push bc

; ---- code $5CDC-$5CE7 (11 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	ret

; ---- code $5CE7-$5CFF (24 bytes) [PROBABLE] second half (jr c target of 5CC2, 5CE7): add a,$28 ... loop ... pop bc ; call $5C39 ; push bc, flowing into the far-call site region at 5CFF; twin of the first half 5CB8-5CE7

Label_7F_5CE7:: ; 7F:5CE7
	ld a, [wSpriteSlots + 113]
	add a, $28
	ld d, a

Label_7F_5CED:: ; 7F:5CED
	ld a, [wSpriteSlots + 113]
	inc a
	inc a
	inc a
	inc a
	ld [wSpriteSlots + 113], a
	cp a, d
	jr nz, Label_7F_5CED
	pop bc
	call Function_7F_5C39
	push bc

; ---- code $5CFF-$61E8 (1257 bytes) [PROBABLE] 626 insn(s) reached by static flow only; seeds: site x626; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	ret

Function_7F_5D0A:: ; 7F:5D0A
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	ret z
	push bc
	push de
	ld d, $68
	ld e, $48
	pop de
	pop bc
	ld a, b
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld e, c
	ld d, $00
	sla e
	ld hl, PageListProto_UrlSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push bc
	push de
	ld a, [de]
	cp a, $00
	jp z, Label_7F_5DFC
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 81]
	ld c, a
	ld a, $C0
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 97], a
	ld a, [wSpriteSlots + 112]
	ld b, a
	ld a, $C0
	ld [wSpriteSlots + 112], a
	ld [wSpriteSlots + 128], a
	push bc
	ld de, $0104
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
	pop bc
	push af
	ld a, c
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 97], a
	ld a, b
	ld [wSpriteSlots + 112], a
	sub a, $10
	ld [wSpriteSlots + 128], a
	ld hl, $DA70
	ld de, Table_7F_6DB0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA80
	ld de, $6E10
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $46
	ld [wSpriteSlots + 129], a
	ld a, $46
	ld [wSpriteSlots + 113], a
	ld a, $66
	ld [wSpriteSlots + 112], a
	pop af
	pop de
	pop bc
	push af
	call Function_7F_5647
	call Function_7F_56AE
	pop af
	dec a
	jr z, Label_7F_5DFC
	call Function_7F_5306
	pop de
	pop bc
	xor a, a
	ldh [hJoyPressed], a
	ret

Label_7F_5DFC:: ; 7F:5DFC
	push bc
	push de
	call Function_7F_5306
	pop de
	pop bc
	pop de
	pop bc
	push de
	push bc
	ld a, c
	cp a, $00
	jr nz, Label_7F_5E2F
	ld hl, $DA10
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $05
	ld [wSpriteSlots + 17], a
	jp Label_7F_5EF2

Label_7F_5E2F:: ; 7F:5E2F
	cp a, $01
	jr nz, Label_7F_5E56
	ld hl, $DA20
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $22
	ld [wSpriteSlots + 32], a
	ld a, $05
	ld [wSpriteSlots + 33], a
	jp Label_7F_5EF2

Label_7F_5E56:: ; 7F:5E56
	cp a, $02
	jr nz, Label_7F_5E7D
	ld hl, $DA30
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2E
	ld [wSpriteSlots + 48], a
	ld a, $05
	ld [wSpriteSlots + 49], a
	jp Label_7F_5EF2

Label_7F_5E7D:: ; 7F:5E7D
	cp a, $03
	jr nz, Label_7F_5EA4
	ld hl, $DA40
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3A
	ld [wSpriteSlots + 64], a
	ld a, $05
	ld [wSpriteSlots + 65], a
	jp Label_7F_5EF2

Label_7F_5EA4:: ; 7F:5EA4
	cp a, $04
	jr nz, Label_7F_5ECB
	ld hl, $DA50
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $46
	ld [wSpriteSlots + 80], a
	ld a, $05
	ld [wSpriteSlots + 81], a
	jp Label_7F_5EF2

Label_7F_5ECB:: ; 7F:5ECB
	cp a, $05
	jr nz, Label_7F_5EF2
	ld hl, $DA60
	ld de, $6E30
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $52
	ld [wSpriteSlots + 96], a
	ld a, $05
	ld [wSpriteSlots + 97], a
	jp Label_7F_5EF2

Label_7F_5EF2:: ; 7F:5EF2
	pop bc
	ld e, $32

Label_7F_5EF5:: ; 7F:5EF5
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	pop de
	pop bc
	dec e
	jr nz, Label_7F_5EF5
	pop de
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	ld hl, $D500
	ld c, $00

Label_7F_5F22:: ; 7F:5F22
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_7F_5F22
	pop bc
	ld e, c
	ld d, $00
	sla e
	ld hl, PageListProto_TitleSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push bc
	ld hl, $D3C0
	ld a, [hl]
	cp a, $00
	jr nz, Label_7F_5F42
	ld hl, $D500

Label_7F_5F42:: ; 7F:5F42
	ld c, $16

Label_7F_5F44:: ; 7F:5F44
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_7F_5F44
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, c
	call Function_7F_56F1
	call Function_7F_546A
	ld a, $FF
	ret

Function_7F_5F5D:: ; 7F:5F5D
	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	jr nz, Label_7F_5F6C

Label_7F_5F6C:: ; 7F:5F6C
	push bc
	push de
	pop de
	pop bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld b, $00
	sla c
	ld e, c
	ld d, $00
	ld hl, PageListProto_TitleSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, PageListProto_UrlSlotTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld h, a
	ld l, c
	ld a, [hl]
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	cp a, $00
	ret z
	push bc
	push de
	push hl
	ld d, $68
	ld e, $20
	pop hl
	pop de
	pop bc
	push de
	ld a, b
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d
	pop de
	ld a, $FF
	ret

Function_7F_5FBC:: ; 7F:5FBC
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	sla c
	ld b, $00
	ld hl, PageListProto_UrlSlotTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	ld a, [bc]
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	cp a, $00
	ret z
	push bc
	push de
	ld d, $68
	ld e, $70
	pop de
	pop bc
	ld a, b
	ld d, b
	ld b, $00
	call Function_7F_591E
	ld b, d
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 81]
	ld c, a
	ld a, $C0
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 97], a
	ld a, [wSpriteSlots + 112]
	ld b, a
	ld a, $C0
	ld [wSpriteSlots + 112], a
	ld [wSpriteSlots + 128], a
	push bc
	ld de, $0103
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
	pop bc
	push af
	ld a, c
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 97], a
	ld a, b
	ld [wSpriteSlots + 112], a
	sub a, $10
	ld [wSpriteSlots + 128], a
	ld hl, $DA70
	ld de, Table_7F_6DB0
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $57
	ld [wSpriteSlots + 128], a
	ld a, $71
	ld [wSpriteSlots + 129], a
	ld a, $66
	ld [wSpriteSlots + 112], a
	ld a, $6E
	ld [wSpriteSlots + 113], a
	call Function_7F_5306
	pop af
	pop de
	pop bc
	push af
	call Function_7F_5647
	call Function_7F_56AE
	pop af
	dec a
	jr z, Label_7F_609A
	xor a, a
	ldh [hJoyPressed], a
	ret

Label_7F_609A:: ; 7F:609A
	push bc
	push de
	call Function_7F_5306
	pop de
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr nz, Label_7F_60CA
	ld hl, $DA10
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $16
	ld [wSpriteSlots + 16], a
	ld a, $05
	ld [wSpriteSlots + 17], a
	jp Label_7F_618D

Label_7F_60CA:: ; 7F:60CA
	cp a, $01
	jr nz, Label_7F_60F1
	ld hl, $DA20
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $22
	ld [wSpriteSlots + 32], a
	ld a, $05
	ld [wSpriteSlots + 33], a
	jp Label_7F_618D

Label_7F_60F1:: ; 7F:60F1
	cp a, $02
	jr nz, Label_7F_6118
	ld hl, $DA30
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2E
	ld [wSpriteSlots + 48], a
	ld a, $05
	ld [wSpriteSlots + 49], a
	jp Label_7F_618D

Label_7F_6118:: ; 7F:6118
	cp a, $03
	jr nz, Label_7F_613F
	ld hl, $DA40
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3A
	ld [wSpriteSlots + 64], a
	ld a, $05
	ld [wSpriteSlots + 65], a
	jp Label_7F_618D

Label_7F_613F:: ; 7F:613F
	cp a, $04
	jr nz, Label_7F_6166
	ld hl, $DA50
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $46
	ld [wSpriteSlots + 80], a
	ld a, $05
	ld [wSpriteSlots + 81], a
	jp Label_7F_618D

Label_7F_6166:: ; 7F:6166
	cp a, $05
	jr nz, Label_7F_618D
	ld hl, $DA60
	ld de, $6E40
	ld a, $7F
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $52
	ld [wSpriteSlots + 96], a
	ld a, $05
	ld [wSpriteSlots + 97], a
	jp Label_7F_618D

Label_7F_618D:: ; 7F:618D
	pop bc
	ld e, $32

Label_7F_6190:: ; 7F:6190
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	pop de
	pop bc
	dec e
	jr nz, Label_7F_6190
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	sla c
	ld b, $00
	ld hl, PageListProto_TitleSlotTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	xor a, a
	ld [bc], a
	inc bc
	ld [bc], a
	pop bc
	push bc
	sla c
	ld b, $00
	ld hl, PageListProto_UrlSlotTable
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hl]
	ld b, a
	xor a, a
	ld [bc], a
	inc bc
	ld [bc], a
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, c
	call Function_7F_56F1
	call Function_7F_546A
	ld a, $FF
	ret

Function_7F_61E6:: ; 7F:61E6
	ret

Function_7F_61E7:: ; 7F:61E7
	ret

; ---- code $61E8-$61FC (20 bytes) [HYPOTHESIS] complete small function (ld a,7 ; ldh [hFF8D],a ; ldh [hFF70],a ; xor a ; ld [$C2D4..$C2D7],a ; ret) directly before the executed function 7F:61FC; no caller/pointer found, entry unproven
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wTimerAFrames], a
	ld [wTimerASeconds], a
	ld [wTimerAMinutes], a
	ld [wRam_C2D7], a
	ret
