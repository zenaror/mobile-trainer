; engine/unreferenced/page_list_prototype.asm
; bank 7F, $4C78-$61FC (5508 bytes); pinned by layout.link
; text-canvas demo and page-list prototype with no caller (about 6 KB, hypothesis)

SECTION "engine/unreferenced/page_list_prototype", ROMX

Canvas_RunSampleDemo:: ; 7F:4C78

	; [PROBABLE] 116 insn(s) reached by static flow only; seeds: site x116; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 115/116 instruction starts ran in forced_screens (traces/forced/, not
	; natural evidence; status unchanged)
	farcall Sprite_ResetAll
	call Canvas_InitScreen
	call Canvas_UploadToVramWrapper
.draw_rows ; 7F:4C84
	call Canvas_DrawSampleRows
.poll_a ; 7F:4C87
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .poll_a
	call Canvas_DrawSampleRowsInverted
.poll_b_then_a ; 7F:4C96
	farcall Joypad_Update
	ldh a, [hJoyPressed]
	and a, PADF_B
	ret nz
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .poll_b_then_a
	jr .draw_rows

Canvas_InitScreen:: ; 7F:4CA9
	ldh a, [rLCDC]
	push af
	and a, $80
	jr z, .clear_vram_bank0
	di
.wait_ly90 ; 7F:4CB1
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_ly90
	ldh a, [rLCDC]
	and a, $7F
	ldh [rLCDC], a
	ei
.clear_vram_bank0 ; 7F:4CBE
	xor a, a
	ldh [rVBK], a
	ld hl, $8800
	ld bc, $1000
.clear_8800_bank0_loop ; 7F:4CC7
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_8800_bank0_loop
	ld hl, $9800
	ld b, $12
	ld c, $14
	ld d, $00
.write_map_index_loop ; 7F:4CD7
	ld a, d
	cp a, $F0
	jr nz, .write_map_index
	xor a, a
	ld d, a
.write_map_index ; 7F:4CDE
	ld [hli], a
	inc d
	dec c
	jr nz, .write_map_index_loop
	ld c, $14
	push bc
	ld bc, $000C
	add hl, bc
	pop bc
	dec b
	jr nz, .write_map_index_loop
	ld a, $01
	ldh [rVBK], a
	ld hl, $8800
	ld bc, $1000
.clear_8800_bank1_loop ; 7F:4CF8
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_8800_bank1_loop
	ld hl, $9800
	ld bc, $0180
.clear_9800_bank1_loop ; 7F:4D05
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_9800_bank1_loop
	ld hl, $9980
	ld b, $C0
.fill_9980_with08_loop ; 7F:4D11
	ld a, $08
	ld [hli], a
	dec b
	jr nz, .fill_9980_with08_loop
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $1000
	ld hl, wTileStage2
.clear_wram_bank2_loop ; 7F:4D23
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_wram_bank2_loop
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $0800
	ld hl, wTileStage3
.clear_wram_bank3_loop ; 7F:4D36
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_wram_bank3_loop
	ld a, $80
	ldh [rBCPS], a
	ld hl, Palette_Canvas_Bg
	ld b, $08
.copy_palette_bytes_loop ; 7F:4D46
	ld a, [hli]
	ldh [rBCPD], a
	dec b
	jr nz, .copy_palette_bytes_loop
	pop af
	ldh [rLCDC], a
	ret

; ---- data $4D50-$4D58 (8 bytes) [PROBABLE] 8 bytes = one RGB555 palette (7FFF 7C00 001F 0000) written to the palette port with ld hl,$4D50 ; ld b,8 ; ld a,[hli] ; ldh [$69],a at 7F:4D41-4D49

Palette_Canvas_Bg:: ; 7F:4D50
	db $FF, $7F, $00, $7C, $1F, $00, $00, $00

	; [PROBABLE] function head ld hl,$4D88 ; ld de,$0000 : the loop that follows (4D5E, PROBABLE, jr
	; nz back at 4D85) prints the string at 7F:4D88 ("Sample DATA.") glyph by glyph; immediate =
	; exact string start; no caller found, entry unproven
	ld hl, $4D88
	ld de, $0000

.draw_ascii_glyphs ; 7F:4D5E
	; [PROBABLE] 25 insn(s) reached by static flow only; seeds: site x25; min discovery hops 0;
	; entered by jrcc from 7F:4D85 (PROBABLE code)
	ld a, [hli]
	push hl
	push de
	ld b, a
	ld de, wGlyphBufLeft
	call Glyph_LoadAscii
	pop de
	push de
	ld hl, wGlyphBufLeft
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
	jr nz, .draw_ascii_glyphs
	ret

; ---- text $4D88-$4D95 (13 bytes) [PROBABLE] ASCII string "Sample DATA." + NUL, address loaded by ld hl,$4D88 at 7F:4D58

PUSHC sjis
String_Canvas_SampleAscii:: ; 7F:4D88

	db "Sample DATA.", 0
POPC

Canvas_DrawSampleRows:: ; 7F:4D95

	; [PROBABLE] 56 insn(s) reached by static flow only; seeds: site x56; min discovery hops 0;
	; entered by call from 7F:4C84 (PROBABLE code) | forced execution: 56/56 instruction starts ran
	; in forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld b, $0C
	ld de, $0000
.row_loop ; 7F:4D9A
	push bc
	push de
	ld e, $00
	ld hl, String_Canvas_SampleSentence_7F_4DF2
.read_pair_loop ; 7F:4DA1
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	push de
	ld h, b
	ld l, c
	ld a, $00
	ld de, wGlyphBufRight
	ld bc, wGlyphBufLeft
	call Glyph_LoadWide
	pop de
	push de
	ld hl, wGlyphBufLeft
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
	ld hl, wGlyphBufRight
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
	jr nz, .read_pair_loop
	pop de
	pop bc
	ld a, d
	add a, $0C
	ld d, a
	dec b
	jr nz, .row_loop
	call Canvas_UploadToVram
	ret

; ---- text $4DF2-$4E0D (27 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
; Unused original storage; String_Canvas_SampleSentence_7F_4DF2 is at 7F:7FCF.

	db "サンプルデータですからね～", 0
POPC

Canvas_DrawSampleRowsInverted:: ; 7F:4E0D

	; [PROBABLE] 56 insn(s) reached by static flow only; seeds: site x56; min discovery hops 0;
	; entered by call from 7F:4C93 (PROBABLE code) | forced execution: 56/56 instruction starts ran
	; in forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld b, $0C
	ld de, $0000
.row_loop ; 7F:4E12
	push bc
	push de
	ld e, $00
	ld hl, String_Canvas_SampleSentence_7F_4E6A
.read_pair_loop ; 7F:4E19
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	push hl
	push de
	ld h, b
	ld l, c
	ld a, $00
	ld de, wGlyphBufRight
	ld bc, wGlyphBufLeft
	call Glyph_LoadWide
	pop de
	push de
	ld hl, wGlyphBufLeft
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
	ld hl, wGlyphBufRight
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
	jr nz, .read_pair_loop
	pop de
	pop bc
	ld a, d
	add a, $0C
	ld d, a
	dec b
	jr nz, .row_loop
	call Canvas_UploadToVram
	ret

; ---- text $4E6A-$4E85 (27 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
; Unused original storage; String_Canvas_SampleSentence_7F_4E6A is at 7F:7F9E.

	db "サンプルデータですからね～", 0
POPC

Canvas_UploadToVramWrapper:: ; 7F:4E85

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 1;
	; entered by call from 7F:4C81 (PROBABLE code) | forced execution: 2/2 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	call Canvas_UploadToVram
	ret

; ---- ptrtable $4E89-$4E95 (12 bytes) [PROBABLE] 6 x dw string pointers (4E95, 4EA8, 4EC1, 4ED0, 4EE1, 4EE8); every target is a string start of the text below (Japanese/ASCII page names); 7F:4E85 (call $4BBC ; ret) precedes it; no ld hl,$4E89 found, so the reader is unlocated

Sample_PageNamePtrs:: ; 7F:4E89

	dw String_Sample_PageNames_0_2
	dw $4EA8
	dw $4EC1
	dw String_Sample_PageNames_3_5
	dw $4EE1
	dw $4EE8

; ---- text $4E95-$4ED0 (59 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
String_Sample_PageNames_0_2:: ; 7F:4E95
	db "ＮｉｎＨｏｍｅＰｇ", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $7C, $83, $50, $83, $62, $83, $67, $83, $82, $83, $93, $83, $58, $83, $5E
	db $81, $5B, $81, $63, $81, $49, $81, $48, $00, $47, $41, $4D, $45, $46, $52, $45
	db $41, $4B, $20, $48, $4F, $4D, $45, $00
POPC
POPC

; ---- text $4ED0-$4EF0 (32 bytes) [PROBABLE] ASCII "MissingLink_HOME" + $07 (control byte) + "sample" + NUL, followed by "sample" and "sample2" strings that are the last targets (4EE1, 4EE8) of the table 7F:4E89

PUSHC sjis
String_Sample_PageNames_3_5:: ; 7F:4ED0

	db "MissingLink_HOME", $07, "sample", 0
	db "sample2", 0
POPC

; ---- ptrtable $4EF0-$4EFC (12 bytes) [PROBABLE] little-endian word table, 6 entries, monotone=1.00, 83% of targets on string start/after NUL, targets $4EFC..$4F79; regular record stride between targets; verifier: truncated from 8 to 6 entries: entry 0 = 4EFC is where the table ends

Sample_PageUrlPtrs:: ; 7F:4EF0

	dw String_Sample_PageUrl0
	dw String_Sample_PageUrl1
	dw String_Sample_PageUrl2
	dw String_Sample_PageUrl3
	dw String_Sample_PageUrl4
	dw String_Sample_PageUrl5

; ---- text $4EFC-$4F15 (25 bytes) [PROBABLE] ASCII URL "http://www.nintendo.com/" + NUL = first target (4EFC) of the pointer table 7F:4EF0

PUSHC sjis
String_Sample_PageUrl0:: ; 7F:4EFC

	db "http://www.nintendo.com/", 0
POPC

; ---- text $4F15-$4FC3 (174 bytes) [PROBABLE] text: 8 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Sample_PageUrl1:: ; 7F:4F15

	db "http://www.pokemon.co.jp/", 0
String_Sample_PageUrl2:: ; 7F:4F2F

	db "http://www.gamefreek.net/", 0
String_Sample_PageUrl3:: ; 7F:4F49

	db "http://www.missinglink.co.jp/", 0
String_Sample_PageUrl4:: ; 7F:4F67

	db "http://sample.to/", 0
String_Sample_PageUrl5:: ; 7F:4F79

	db "http://sample2.to/", 0
	db "テストページ", 0
	db "htpp://work.dammy.co.jp/", 0
	db "鋼ポケモンに進化", 0
POPC

; ---- words $4FC3-$4FCF (12 bytes) [PROBABLE] 6 words = SRAM addresses A084,A184,A284,A384,A484,A584 (not text although the bytes 84 A0.. are valid Shift-JIS): read by 7 code sites as ld hl,$4FC3 ; ld a,[hli] ; ld e,a ; ld a,[hli] ; ld d,a ; ld a,[de] (7F:5386 ...) and by ld hl,$4FC5/$4FC7/... (entries)

PageListProto_UrlSlotTable:: ; 7F:4FC3

	dw $A084, $A184, $A284, $A384, $A484, $A584

; ---- words $4FCF-$4FDB (12 bytes) [PROBABLE] 6 words = SRAM addresses A000,A016,A02C,A042,A058,A06E (stride $16), read via ld hl,$4FCF at 7 code sites (7F:5709, 5731, 579A, 57C2, 5F2E, 5F87, 61B5)

PageListProto_TitleSlotTable:: ; 7F:4FCF

	dw $A000, $A016, $A02C, $A042, $A058, $A06E

PageListProto_Main:: ; 7F:4FDB

	; [PROBABLE] function head (push af ; ldh a,[$FF70] ; push af ; ld a,1 ; ... ld [$D724],a ; ld
	; a,0 ; ld [$D725],a ; pop af ... pop af) flowing into the validated far-call site at 4FF5 (call
	; 7F:7271, an executed function); starts right after the word table above; no caller found,
	; entry unproven
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

	; [PROBABLE] 221 insn(s) reached by static flow only; seeds: site x221; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Stat_EnableScrollSplit
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wBrowserPageUrl]
	cp a, $00
	jr nz, .initialize_screen
	xor a, a
	ld [wDialogOnlineSnapshot], a
.initialize_screen ; 7F:500C
	call PageListProto_InitScreen
	ld c, $00

PageListProto_Main_Loop:: ; 7F:5011

	push bc
	farcall Sprite_UpdateAll
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, .poll_input
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .check_timer_bit4
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.check_timer_bit4 ; 7F:503A
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .timer_bit4_clear_path
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .zero_a
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .restore_hl_test_a
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .zero_a
	jr nz, .check_warn_minute45
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .zero_a
.check_warn_minute45 ; 7F:5064
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .set_warn_bit0
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .zero_a
	set 1, [hl]
.set_warn_bit0 ; 7F:5074
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .restore_hl_test_a
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .restore_hl_test_a
.zero_a ; 7F:5088
	xor a, a
.restore_hl_test_a ; 7F:5089
	pop hl
	or a, a
	jp nz, .return_ff_zero_de_hl
	jp .poll_input
.timer_bit4_clear_path ; 7F:5091
	xor a, a
	ld [wBrowserFetchResult], a
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
	ld de, $0110
	farcall Dialog_Open
	farcall Dialog_WaitInputMonitored
	farcall Dialog_Close
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wBrowserPendingMessage], a
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call PageListProto_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	pop bc
	jp PageListProto_Main_Loop
.return_ff_zero_de_hl ; 7F:5115
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.poll_input ; 7F:5128
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .check_b_pressed
	push bc
	push de
	play_sfx $0031
	pop de
	pop bc
	push bc
	call PageListProto_GetActionAvailability
	call PageListProto_SetActionIcons
	pop bc
	call PageListProto_ActionMenu
	inc a
	ret z
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call PageListProto_SetActionIcons
	ld a, $03
	ld b, $00
	call PageListProto_ShowMessage
	pop bc
.check_b_pressed ; 7F:516A
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .check_up_repeat
	push bc
	push de
	play_sfx $0048
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.check_up_repeat ; 7F:5196
	ldh a, [hJoyPressedRepeat]
	and a, PADF_UP
	jr z, .check_down_repeat
	push bc
	push de
	play_sfx $0046
	pop de
	pop bc
	ld d, c
	dec c
	ld a, $FF
	cp a, c
	jr nz, .redraw_after_c_decrement
	ld c, $05
.redraw_after_c_decrement ; 7F:51B9
	ld a, d
	call PageListProto_RedrawSelection
	call PageListProto_UpdateRowSprites
.check_down_repeat ; 7F:51C0
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DOWN
	jr z, .repeat_main
	push bc
	push de
	play_sfx $0046
	pop de
	pop bc
	ld d, c
	inc c
	ld a, $06
	cp a, c
	jr nz, .redraw_after_c_increment
	ld c, $00
.redraw_after_c_increment ; 7F:51E3
	ld a, d
	call PageListProto_RedrawSelection
	call PageListProto_UpdateRowSprites
.repeat_main ; 7F:51EA
	jp PageListProto_Main_Loop

; ---- data $51ED-$51EE (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $C9 (ret) after the unconditional jp $5011 at 51EA and before the function 51EE; no branch/call to 51ED found; left unclassified

Data_PageListProto_CandidateRetOpcode_51ED:: ; 7F:51ED
	db $C9

PageListProto_InitScreen:: ; 7F:51EE

	; [PROBABLE] 1292 insn(s) reached by static flow only; seeds: site x1292; min discovery hops 0;
	; entered by call from 7F:500C (PROBABLE code)
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $1000
.clear_wram_bank2_loop ; 7F:51FB
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_wram_bank2_loop
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0780
.clear_wram_bank3_loop ; 7F:520E
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_wram_bank3_loop
	farcall Canvas_UploadToVram
	farcall LCDOff
	farcall Sprite_ResetAll
	ld de, $9001
	ld hl, PageListProto_Tiles_62B0
	ld a, BANK(PageListProto_Tiles_62B0)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, PageListProto_Tiles_66B0
	ld a, BANK(PageListProto_Tiles_66B0)
	ld b, $97
	ld c, $12
	farcall Gfx_StartHDMAWithService
	ld de, $8000
	ld hl, PageListProto_Tiles_6AE0
	ld a, BANK(PageListProto_Tiles_6AE0)
	ld b, $94
	ld c, $29
	farcall Gfx_StartHDMAWithService
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6000
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, PageListProto_Tilemap_67D0
	ld a, BANK(PageListProto_Tilemap_67D0)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	di
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, PageListProto_ObjPalette
	ld a, BANK(PageListProto_ObjPalette)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, PageListProto_BgPalette
	ld a, BANK(PageListProto_BgPalette)
	farcall Palette_LoadToBuffer
	ei
	farcall LCDOn
	call PageListProto_DrawAllTitles
	ld c, $00
	call PageListProto_UpdateRowSprites
	ld a, $03
	ld b, $00
	call PageListProto_ShowMessage
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $001A
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
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
	pop bc
	ret

PageListProto_UpdateRowSprites:: ; 7F:5306

	push bc
	call PageListProto_InitRowSprites
	call PageListProto_HighlightRowSprite
	pop bc
	ret

PageListProto_InitRowSprites:: ; 7F:530F

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
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry16
	ld a, BANK(PageListProto_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, PageListProto_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_slot2_byte
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.check_slot2_byte ; 7F:53A2
	ld hl, $4FC5
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_slot3_byte
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.check_slot3_byte ; 7F:53BE
	ld hl, $4FC7
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_slot4_byte
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.check_slot4_byte ; 7F:53DA
	ld hl, $4FC9
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_slot5_byte
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.check_slot5_byte ; 7F:53F6
	ld hl, $4FCB
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_slot6_byte
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.check_slot6_byte ; 7F:5412
	ld hl, $4FCD
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .set_slot_positions
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry12
	ld a, BANK(PageListProto_ObjTable_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
.set_slot_positions ; 7F:542E
	ld a, $16
	ld [wSpriteSlot1], a
	ld a, $22
	ld [wSpriteSlot2], a
	ld a, $2E
	ld [wSpriteSlot3], a
	ld a, $3A
	ld [wSpriteSlot4], a
	ld a, $46
	ld [wSpriteSlot5], a
	ld a, $52
	ld [wSpriteSlot6], a
	ld a, $05
	ld [wSpriteSlot1 + $01], a
	ld [wSpriteSlot2 + $01], a
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot4 + $01], a
	ld [wSpriteSlot5 + $01], a
	ld [wSpriteSlot6 + $01], a
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

PageListProto_HighlightRowSprite:: ; 7F:546A

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
	jr nz, .check_c_1
	ld hl, PageListProto_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot1_entry8
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $16
	ld [wSpriteSlot1], a
	ld a, $05
	ld [wSpriteSlot1 + $01], a
	jp .disable_sram_restore_bc
.init_slot1_entry8 ; 7F:54AE
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $16
	ld [wSpriteSlot1], a
	ld a, $05
	ld [wSpriteSlot1 + $01], a
	jp .disable_sram_restore_bc
.check_c_1 ; 7F:54CB
	inc a
	cp a, c
	jr nz, .check_c_2
	ld hl, $4FC5
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot2_entry8
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $22
	ld [wSpriteSlot2], a
	ld a, $05
	ld [wSpriteSlot2 + $01], a
	jp .disable_sram_restore_bc
.init_slot2_entry8 ; 7F:54F8
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $22
	ld [wSpriteSlot2], a
	ld a, $05
	ld [wSpriteSlot2 + $01], a
	jp .disable_sram_restore_bc
.check_c_2 ; 7F:5515
	inc a
	cp a, c
	jr nz, .check_c_3
	ld hl, $4FC7
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot3_entry8
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $2E
	ld [wSpriteSlot3], a
	ld a, $05
	ld [wSpriteSlot3 + $01], a
	jp .disable_sram_restore_bc
.init_slot3_entry8 ; 7F:5542
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $2E
	ld [wSpriteSlot3], a
	ld a, $05
	ld [wSpriteSlot3 + $01], a
	jp .disable_sram_restore_bc
.check_c_3 ; 7F:555F
	inc a
	cp a, c
	jr nz, .check_c_4
	ld hl, $4FC9
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot4_entry8
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $3A
	ld [wSpriteSlot4], a
	ld a, $05
	ld [wSpriteSlot4 + $01], a
	jp .disable_sram_restore_bc
.init_slot4_entry8 ; 7F:558C
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $3A
	ld [wSpriteSlot4], a
	ld a, $05
	ld [wSpriteSlot4 + $01], a
	jp .disable_sram_restore_bc
.check_c_4 ; 7F:55A9
	inc a
	cp a, c
	jr nz, .check_c_5
	ld hl, $4FCB
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot5_entry8
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $46
	ld [wSpriteSlot5], a
	ld a, $05
	ld [wSpriteSlot5 + $01], a
	jp .disable_sram_restore_bc
.init_slot5_entry8 ; 7F:55D6
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $46
	ld [wSpriteSlot5], a
	ld a, $05
	ld [wSpriteSlot5 + $01], a
	jp .disable_sram_restore_bc
.check_c_5 ; 7F:55F3
	inc a
	cp a, c
	jr nz, .disable_sram_restore_bc
	ld hl, $4FCD
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .init_slot6_entry8
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry4
	ld a, BANK(PageListProto_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $52
	ld [wSpriteSlot6], a
	ld a, $05
	ld [wSpriteSlot6 + $01], a
	jp .disable_sram_restore_bc
.init_slot6_entry8 ; 7F:5620
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry8
	ld a, BANK(PageListProto_ObjTable_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $52
	ld [wSpriteSlot6], a
	ld a, $05
	ld [wSpriteSlot6 + $01], a
	jp .disable_sram_restore_bc
.disable_sram_restore_bc ; 7F:563D
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

PageListProto_GetActionAvailability:: ; 7F:5647

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
	jr nz, .nonzero_slot_byte
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
	ld hl, wBrowserPageUrl
	ld a, [hl]
	cp a, $00
	jr z, .return_empty_slot_values
	ld a, $01
.return_empty_slot_values ; 7F:5686
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret
.nonzero_slot_byte ; 7F:568B
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
	ld hl, wBrowserPageUrl
	ld a, [hl]
	cp a, $00
	jr z, .return_nonzero_slot_values
	ld a, $01
	ld d, $01
.return_nonzero_slot_values ; 7F:56A9
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret

PageListProto_SetActionIcons:: ; 7F:56AE

	push bc
	di
	ld b, a
	ld a, $01
	ldh [rVBK], a
.wait_for_ly_90 ; 7F:56B5
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_for_ly_90
	ld a, $0B
	dec b
	jr z, .write_99a4_99c4
	ld a, $0C
.write_99a4_99c4 ; 7F:56C2
	ld hl, $99A4
	ld [hli], a
	ld [hl], a
	ld hl, $99C4
	ld [hli], a
	ld [hl], a
	ld a, $0B
	dec d
	jr z, .write_99a9_99c9
	ld a, $0C
.write_99a9_99c9 ; 7F:56D3
	ld hl, $99A9
	ld [hli], a
	ld [hl], a
	ld hl, $99C9
	ld [hli], a
	ld [hl], a
	ld a, $0B
	dec e
	jr z, .write_99ae_99ce
	ld a, $0C
.write_99ae_99ce ; 7F:56E4
	ld hl, $99AE
	ld [hli], a
	ld [hl], a
	ld hl, $99CE
	ld [hli], a
	ld [hl], a
	ei
	pop bc
	ret

PageListProto_RedrawSelection:: ; 7F:56F1

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
.old_index_scale_loop ; 7F:5719
	dec b
	jr z, .draw_old_index_line
	add a, $0C
	jr .old_index_scale_loop
.draw_old_index_line ; 7F:5720
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call PageListProto_DrawTextLine
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
.new_index_scale_loop ; 7F:5742
	dec b
	jr z, .draw_new_index_line
	add a, $0C
	jr .new_index_scale_loop
.draw_new_index_line ; 7F:5749
	add a, $10
	ld d, a
	ld b, $00
	ld c, $01
	call PageListProto_DrawTextLine
	pop hl
	pop bc
	push bc
	ld b, $03
	ld c, $00
	ld de, $0218
	ld hl, wBrowserPageTitle
	call PageListProto_DrawTextLine
	farcall PageListProto_UploadTextTiles
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
	call PageListProto_SetActionIcons
	pop bc
	ret

PageListProto_DrawAllTitles:: ; 7F:577D

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
.title_index_loop ; 7F:5791
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
.index_scale_loop ; 7F:57AA
	dec b
	jr z, .draw_index_line
	add a, $0C
	jr .index_scale_loop
.draw_index_line ; 7F:57B1
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call PageListProto_DrawTextLine
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .title_index_loop
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
	call PageListProto_DrawTextLine
	pop hl
	pop bc
	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $03
	ld c, $00
	ld de, $0218
	ld hl, wBrowserPageTitle
	call PageListProto_DrawTextLine
	farcall PageListProto_UploadTextTiles
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
	call PageListProto_SetActionIcons
	pop bc
	ret

PageListProto_DrawTextLine:: ; 7F:5805

	ld a, $14
	ld [wTextCellsLeft], a
.read_next_byte ; 7F:580A
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jr z, .load_space_glyph
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .load_ascii_byte
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, wGlyphBufLeft
	ld de, wGlyphBufRight
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call PageListProto_BlitGlyphAdvance
	push bc
	push de
	push hl
	ld hl, wGlyphBufRight
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
	jr z, .load_space_glyph
	cp a, $01
	jr z, .load_space_glyph
	jr .read_next_byte
.load_ascii_byte ; 7F:5860
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call PageListProto_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_space_glyph
	cp a, $01
	jr z, .load_space_glyph
	jr .read_next_byte
.load_space_glyph ; 7F:5885
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.fill_remaining_cells ; 7F:5896
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call PageListProto_BlitGlyphAdvance
	jr .fill_remaining_cells

PageListProto_BlitGlyphAdvance:: ; 7F:58A5

	push bc
	push de
	push hl
	ld hl, wGlyphBufLeft
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

PageListProto_UploadTextTiles:: ; 7F:58B9

	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	call PageListProto_StartHDMAAtVBlank
	call Sound_FrameService
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	call PageListProto_StartHDMAAtVBlank
	call Sound_FrameService
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $6F
	call PageListProto_StartHDMAAtVBlank
	call Sound_FrameService
	ret

PageListProto_StartHDMAAtVBlank:: ; 7F:58F9

	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, rLY
	di
.wait_ly8f ; 7F:5909
	ld a, [de]
	cp a, $8F
	jr nz, .wait_ly8f
	ld b, $91
.wait_ly91 ; 7F:5910
	ld a, [de]
	cp a, b
	jr nz, .wait_ly91
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	xor a, a
	ldh [rSCY], a
	ei
	ret

PageListProto_ShowMessage:: ; 7F:591E

	push bc
	push de
	push hl
	cp a, $00
	jr z, .load_52_4680
	cp a, $01
	jr z, .load_52_4380
	cp a, $02
	jr z, .load_52_4980
	cp a, $03
	jr z, .load_default_message_tiles
.load_default_message_tiles ; 7F:5931
	ld de, $9581
	ld hl, Gfx_PageListProto_Tiles9580Vb1
	ld a, BANK(Gfx_PageListProto_Tiles9580Vb1)
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMA
	jp .restore_hl_de_bc
.load_52_4680 ; 7F:5946
	ld de, $9581
	ld hl, $4680
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMA
	jp .restore_hl_de_bc
.load_52_4380 ; 7F:595B
	ld de, $9581
	ld hl, $4380
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMA
	jp .restore_hl_de_bc
.load_52_4980 ; 7F:5970
	ld de, $9581
	ld hl, $4980
	ld a, $52
	ld b, $95
	ld c, $28
	farcall Gfx_StartHDMA
	jp .restore_hl_de_bc
.restore_hl_de_bc ; 7F:5985
	pop hl
	pop de
	pop bc
	ret

PageListProto_ActionMenu:: ; 7F:5989

	call PageListProto_ActionMenuInit
	call PageListProto_ActionMenuPostInitReturnOnly
	ld b, $00
.service_action_menu ; 7F:5991
	push bc
	farcall Sprite_UpdateAll
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, .poll_input
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .check_timer_bit4
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.check_timer_bit4 ; 7F:59BA
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .timer_bit4_clear_path
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .zero_a
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .restore_hl_test_a
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .zero_a
	jr nz, .check_warn_minute45
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .zero_a
.check_warn_minute45 ; 7F:59E4
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .set_warn_bit0
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .zero_a
	set 1, [hl]
.set_warn_bit0 ; 7F:59F4
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .restore_hl_test_a
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .restore_hl_test_a
.zero_a ; 7F:5A08
	xor a, a
.restore_hl_test_a ; 7F:5A09
	pop hl
	or a, a
	jp nz, .pop_bc_af_return_ff
	jp .poll_input
.timer_bit4_clear_path ; 7F:5A11
	xor a, a
	ld [wBrowserFetchResult], a
	farcall Sprites_SaveSlotsToBank3
	ld hl, wSpriteSlot11
	call Sprite_ClearSlot
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
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	farcall Sprite_ResetAll
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_ShowSummary
	xor a, a
	ld [wBrowserPendingMessage], a
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call PageListProto_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	jp .service_action_menu
.pop_bc_af_return_ff ; 7F:5AC4
	pop bc
	pop af
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.poll_input ; 7F:5ACF
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	call nz, PageListProto_ActionMenuInputReturnOnly ; never taken: ldh sets no flags, Z is the one the farcall left (naming2_verify_fn4.md)
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .check_b_pressed
	push bc
	push de
	play_sfx $0031
	pop de
	pop bc
	ld a, b
	cp a, $01
	jr nz, .check_action_2
	call PageListProto_SaveCurrentPage
	jr .check_save_delete_result
.check_action_2 ; 7F:5B02
	cp a, $02
	jr nz, .call_go_to_slot
	call PageListProto_DeleteSlot
.check_save_delete_result ; 7F:5B09
	inc a
	jp nz, .service_action_menu
	call PageListProto_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret
.call_go_to_slot ; 7F:5B1A
	call PageListProto_GoToSlot
	inc a
	jp nz, .service_action_menu
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ret
.check_b_pressed ; 7F:5B2D
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .check_left_repeat
	push bc
	push de
	play_sfx $0048
	pop de
	pop bc
	call PageListProto_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret
.check_left_repeat ; 7F:5B54
	ldh a, [hJoyPressedRepeat]
	and a, PADF_LEFT
	jr z, .check_right_repeat
	push bc
	push de
	play_sfx $0046
	pop de
	pop bc
	ld d, b
	dec b
	ld a, $FF
	cp a, b
	jr nz, .move_after_b_decrement
	ld b, $02
.move_after_b_decrement ; 7F:5B77
	ld a, d
	call PageListProto_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageListProto_ShowMessage
	ld b, d
.check_right_repeat ; 7F:5B83
	ldh a, [hJoyPressedRepeat]
	and a, PADF_RIGHT
	jr z, .repeat_menu
	push bc
	push de
	play_sfx $0046
	pop de
	pop bc
	ld d, b
	inc b
	ld a, $03
	cp a, b
	jr nz, .move_after_b_increment
	ld b, $00
.move_after_b_increment ; 7F:5BA6
	ld a, d
	call PageListProto_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageListProto_ShowMessage
	ld b, d
.repeat_menu ; 7F:5BB2
	jp .service_action_menu

PageListProto_ActionMenuInit:: ; 7F:5BB5

	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wSpriteSlot8
	ld de, PageListProto_ObjTable_Entry20
	ld a, BANK(PageListProto_ObjTable_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $57
	ld [wSpriteSlot8], a
	ld a, $1F
	ld [wSpriteSlot8 + $01], a
	ld hl, wSpriteSlot7
	ld de, PageListProto_ObjTable
	ld a, BANK(PageListProto_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6000
	ld hl, wSpriteSlot7
	call Sprite_SetPosition
	ld a, $F2
	ld [wSpriteSlot7 + $01], a
	ld a, $66
	ld [wSpriteSlot7], a
.advance_slot7_x_by_four ; 7F:5BF9
	ld a, [wSpriteSlot7 + $01]
	inc a
	inc a
	inc a
	inc a
	cp a, $22
	jr z, .show_initial_message
	ld [wSpriteSlot7 + $01], a
	jr .advance_slot7_x_by_four
.show_initial_message ; 7F:5C09
	pop bc
	xor a, a
	ld d, b
	ld b, $00
	call PageListProto_ShowMessage
	ld b, d
	ret

PageListProto_HideActionCursor:: ; 7F:5C13

	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, $E8
	ld [wSpriteSlot8 + $01], a
	farcall Sprite_UpdateAll
	ld a, [wSpriteSlot7 + $01]
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
	ld [wSpriteSlot7 + $01], a
	pop bc
	ret

PageListProto_SetActionCursor:: ; 7F:5C39

	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	cp a, b
	jr nz, .check_b_1
	ld hl, wSpriteSlot8
	ld de, PageListProto_ObjTable_Entry20
	ld a, BANK(PageListProto_ObjTable_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $57
	ld [wSpriteSlot8], a
	ld a, $1F
	ld [wSpriteSlot8 + $01], a
	ld a, $1E
	ld [wSpriteSlot7 + $01], a
	pop bc
	ret
.check_b_1 ; 7F:5C66
	ld a, $01
	cp a, b
	jr nz, .check_b_2
	ld hl, wSpriteSlot8
	ld de, PageListProto_ObjTable_Entry24
	ld a, BANK(PageListProto_ObjTable_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $57
	ld [wSpriteSlot8], a
	ld a, $46
	ld [wSpriteSlot8 + $01], a
	ld a, $46
	ld [wSpriteSlot7 + $01], a
	pop bc
	ret
.check_b_2 ; 7F:5C8C
	ld a, $02
	cp a, b
	jr nz, .restore_bc_return
	ld hl, wSpriteSlot8
	ld de, PageListProto_ObjTable_Entry28
	ld a, BANK(PageListProto_ObjTable_Entry28)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $57
	ld [wSpriteSlot8], a
	ld a, $71
	ld [wSpriteSlot8 + $01], a
	ld a, $6E
	ld [wSpriteSlot7 + $01], a
	pop bc
	ret
.restore_bc_return ; 7F:5CB2
	pop bc
	ret

PageListProto_MoveActionCursor:: ; 7F:5CB4

	call PageListProto_SetActionCursor
	ret

	; [PROBABLE] first half of a function (cp a,b ; ret z ; push af ; ld a,$E8 ; ld [$DA81],a ... jr
	; c,$5CE7 ; ... call $5C39 (called from 7F:5CB4) ; push bc ; far call) that continues in the
	; PROBABLE site region 5CDC and, through the jr c target 5CE7, in the second half; all direct
	; targets land on instruction starts (5C39, 5CE7, 0464, 5CCA loop)
	cp a, b
	ret z
	push af
	ld a, $E8
	ld [wSpriteSlots + 129], a
	pop af
	push bc
	jr c, .add_slot_offset
	ld a, [wSpriteSlots + 113]
	sub a, $28
	ld d, a
.decrement_slot_byte_loop ; 7F:5CCA
	ld a, [wSpriteSlots + 113]
	dec a
	dec a
	dec a
	dec a
	ld [wSpriteSlots + 113], a
	cp a, d
	jr nz, .decrement_slot_byte_loop
	pop bc
	call PageListProto_SetActionCursor
	push bc

	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	ret

.add_slot_offset ; 7F:5CE7
	; [PROBABLE] second half (jr c target of 5CC2, 5CE7): add a,$28 ... loop ... pop bc ; call $5C39
	; ; push bc, flowing into the far-call site region at 5CFF; twin of the first half 5CB8-5CE7
	ld a, [wSpriteSlots + 113]
	add a, $28
	ld d, a
.increment_slot_byte_loop ; 7F:5CED
	ld a, [wSpriteSlots + 113]
	inc a
	inc a
	inc a
	inc a
	ld [wSpriteSlots + 113], a
	cp a, d
	jr nz, .increment_slot_byte_loop
	pop bc
	call PageListProto_SetActionCursor
	push bc

	; [PROBABLE] 626 insn(s) reached by static flow only; seeds: site x626; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	ret

PageListProto_SaveCurrentPage:: ; 7F:5D0A

	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wBrowserPageUrl
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
	call PageListProto_ShowMessage
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
	jp z, .update_rows_before_slot_effect
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlot5 + $01]
	ld c, a
	ld a, $C0
	ld [wSpriteSlot5 + $01], a
	ld [wSpriteSlot6 + $01], a
	ld a, [wSpriteSlot7]
	ld b, a
	ld a, $C0
	ld [wSpriteSlot7], a
	ld [wSpriteSlot8], a
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
	ld hl, wSpriteSlot7
	ld de, PageListProto_ObjTable
	ld a, BANK(PageListProto_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot8
	ld de, PageListProto_ObjTable_Entry24
	ld a, BANK(PageListProto_ObjTable_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
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
	call PageListProto_GetActionAvailability
	call PageListProto_SetActionIcons
	pop af
	dec a
	jr z, .update_rows_before_slot_effect
	call PageListProto_UpdateRowSprites
	pop de
	pop bc
	xor a, a
	ldh [hJoyPressed], a
	ret
.update_rows_before_slot_effect ; 7F:5DFC
	push bc
	push de
	call PageListProto_UpdateRowSprites
	pop de
	pop bc
	pop de
	pop bc
	push de
	push bc
	ld a, c
	cp a, $00
	jr nz, .check_c_1
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $16
	ld [wSpriteSlot1], a
	ld a, $05
	ld [wSpriteSlot1 + $01], a
	jp .begin_update_wait_loop
.check_c_1 ; 7F:5E2F
	cp a, $01
	jr nz, .check_c_2
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $22
	ld [wSpriteSlot2], a
	ld a, $05
	ld [wSpriteSlot2 + $01], a
	jp .begin_update_wait_loop
.check_c_2 ; 7F:5E56
	cp a, $02
	jr nz, .check_c_3
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2E
	ld [wSpriteSlot3], a
	ld a, $05
	ld [wSpriteSlot3 + $01], a
	jp .begin_update_wait_loop
.check_c_3 ; 7F:5E7D
	cp a, $03
	jr nz, .check_c_4
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3A
	ld [wSpriteSlot4], a
	ld a, $05
	ld [wSpriteSlot4 + $01], a
	jp .begin_update_wait_loop
.check_c_4 ; 7F:5EA4
	cp a, $04
	jr nz, .check_c_5
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $46
	ld [wSpriteSlot5], a
	ld a, $05
	ld [wSpriteSlot5 + $01], a
	jp .begin_update_wait_loop
.check_c_5 ; 7F:5ECB
	cp a, $05
	jr nz, .begin_update_wait_loop
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry32
	ld a, BANK(PageListProto_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $52
	ld [wSpriteSlot6], a
	ld a, $05
	ld [wSpriteSlot6 + $01], a
	jp .begin_update_wait_loop
.begin_update_wait_loop ; 7F:5EF2
	pop bc
	ld e, $32
.update_wait_loop ; 7F:5EF5
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop de
	pop bc
	dec e
	jr nz, .update_wait_loop
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
	ld hl, wBrowserPageUrl
	ld c, $00
.copy_url_256_bytes ; 7F:5F22
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_url_256_bytes
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
	ld hl, wBrowserPageTitle
	ld a, [hl]
	cp a, $00
	jr nz, .prepare_title_copy
	ld hl, wBrowserPageUrl
.prepare_title_copy ; 7F:5F42
	ld c, $16
.copy_title_22_bytes ; 7F:5F44
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_title_22_bytes
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, c
	call PageListProto_RedrawSelection
	call PageListProto_HighlightRowSprite
	ld a, $FF
	ret

PageListProto_GoToSlot:: ; 7F:5F5D

	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wBrowserPageUrl
	ld a, [hl]
	cp a, $00
	jr nz, .l5F6C
.l5F6C ; 7F:5F6C
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
	call PageListProto_ShowMessage
	ld b, d
	pop de
	ld a, $FF
	ret

PageListProto_DeleteSlot:: ; 7F:5FBC

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
	call PageListProto_ShowMessage
	ld b, d
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlot5 + $01]
	ld c, a
	ld a, $C0
	ld [wSpriteSlot5 + $01], a
	ld [wSpriteSlot6 + $01], a
	ld a, [wSpriteSlot7]
	ld b, a
	ld a, $C0
	ld [wSpriteSlot7], a
	ld [wSpriteSlot8], a
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
	ld hl, wSpriteSlot7
	ld de, PageListProto_ObjTable
	ld a, BANK(PageListProto_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $57
	ld [wSpriteSlot8], a
	ld a, $71
	ld [wSpriteSlot8 + $01], a
	ld a, $66
	ld [wSpriteSlot7], a
	ld a, $6E
	ld [wSpriteSlot7 + $01], a
	call PageListProto_UpdateRowSprites
	pop af
	pop de
	pop bc
	push af
	call PageListProto_GetActionAvailability
	call PageListProto_SetActionIcons
	pop af
	dec a
	jr z, .update_rows_before_slot_effect
	xor a, a
	ldh [hJoyPressed], a
	ret
.update_rows_before_slot_effect ; 7F:609A
	push bc
	push de
	call PageListProto_UpdateRowSprites
	pop de
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr nz, .check_c_1
	ld hl, wSpriteSlot1
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $16
	ld [wSpriteSlot1], a
	ld a, $05
	ld [wSpriteSlot1 + $01], a
	jp .begin_update_wait_loop
.check_c_1 ; 7F:60CA
	cp a, $01
	jr nz, .check_c_2
	ld hl, wSpriteSlot2
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $22
	ld [wSpriteSlot2], a
	ld a, $05
	ld [wSpriteSlot2 + $01], a
	jp .begin_update_wait_loop
.check_c_2 ; 7F:60F1
	cp a, $02
	jr nz, .check_c_3
	ld hl, wSpriteSlot3
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2E
	ld [wSpriteSlot3], a
	ld a, $05
	ld [wSpriteSlot3 + $01], a
	jp .begin_update_wait_loop
.check_c_3 ; 7F:6118
	cp a, $03
	jr nz, .check_c_4
	ld hl, wSpriteSlot4
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3A
	ld [wSpriteSlot4], a
	ld a, $05
	ld [wSpriteSlot4 + $01], a
	jp .begin_update_wait_loop
.check_c_4 ; 7F:613F
	cp a, $04
	jr nz, .check_c_5
	ld hl, wSpriteSlot5
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $46
	ld [wSpriteSlot5], a
	ld a, $05
	ld [wSpriteSlot5 + $01], a
	jp .begin_update_wait_loop
.check_c_5 ; 7F:6166
	cp a, $05
	jr nz, .begin_update_wait_loop
	ld hl, wSpriteSlot6
	ld de, PageListProto_ObjTable_Entry36
	ld a, BANK(PageListProto_ObjTable_Entry36)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $52
	ld [wSpriteSlot6], a
	ld a, $05
	ld [wSpriteSlot6 + $01], a
	jp .begin_update_wait_loop
.begin_update_wait_loop ; 7F:618D
	pop bc
	ld e, $32
.wait_delete_sprite_frames ; 7F:6190
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop de
	pop bc
	dec e
	jr nz, .wait_delete_sprite_frames
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
	call PageListProto_RedrawSelection
	call PageListProto_HighlightRowSprite
	ld a, $FF
	ret

PageListProto_ActionMenuInputReturnOnly:: ; 7F:61E6

	ret

PageListProto_ActionMenuPostInitReturnOnly:: ; 7F:61E7

	ret

	; [CONFIRMED] selects WRAM bank 7 and clears the four Timer A bytes. [PROBABLE] ret-delimited
	; body immediately before the executed function at 7F:61FC; [HYPOTHESIS] entry/reachability:
	; no caller or pointer is known.
PageListProto_SelectWramBank7AndClearTimerA:: ; 7F:61E8
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wTimerAFrames], a
	ld [wTimerASeconds], a
	ld [wTimerAMinutes], a
	ld [wTimerAExtra], a
	ret

; ---- text $7F9E-$7FCF (49 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/unreferenced/page_list_prototype/english/String_Canvas_SampleSentence_7F_4E6A", ROMX[$7F9E], BANK[$7F]
PUSHC sjis
String_Canvas_SampleSentence_7F_4E6A:: ; 7F:7F9E
	db "Ｔｈｉｓ　ｉｓ　ｊｕｓｔ　ｓａｍｐｌｅ　ｄａｔａ", 0
POPC

; ---- text $7FCF-$8000 (49 bytes) [CONFIRMED] referenced English interface string; NUL terminated.
SECTION "engine/unreferenced/page_list_prototype/english/String_Canvas_SampleSentence_7F_4DF2", ROMX[$7FCF], BANK[$7F]
PUSHC sjis
String_Canvas_SampleSentence_7F_4DF2:: ; 7F:7FCF
	db "Ｔｈｉｓ　ｉｓ　ｊｕｓｔ　ｓａｍｐｌｅ　ｄａｔａ", 0
POPC
