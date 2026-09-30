; engine/browser/page_list.asm
; bank 24, $4000-$5400 (5120 bytes); pinned by layout.link
; page list (6 saved pages): main loop, draw, action menu, save/go/delete

SECTION "engine/browser/page_list", ROMX

; ---- words $4000-$4018 (24 bytes) [PROBABLE] 12 words = SRAM addresses: $A084,$A184..$A584 (stride $100) and $A000,$A016,$A02C,$A042,$A058,$A06E (stride $16); entries 4000/4002/4004/4006/4008/400A are loaded by ld hl,$400x at 24:44C9,44E5,4501,451D,4539,4555 (analysis of ld imm16 operands); meaning of the slots not decoded

PageList_UrlSlotTable:: ; 24:4000
Table_24_4000::
	dw $A084, $A184, $A284, $A384, $A484, $A584

PageList_TitleSlotTable:: ; 24:400C
	dw $A000, $A016, $A02C, $A042, $A058, $A06E

; ---- code $4018-$4099 (129 bytes) [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 2; entered by far from 4E:4DB1 (PROBABLE code) | 59 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage --split [executed in 3 scenarios]

PageList_Main:: ; 24:4018
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0A
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D500]
	cp a, $00
	jr nz, Label_24_4053
	xor a, a
	ld [wDialogOnlineSnapshot], a

Label_24_4053:: ; 24:4053
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_D500]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, b
	ld [wMailComposeMode], a
	ld bc, $0000
	call PageList_InitScreen
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld c, $00

PageList_Main_Loop:: ; 24:4083
	push bc
	farcall Function_00_0956
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, Label_24_41D7
	ld a, [wTimerEnable]
	bit 1, a
	jr z, Label_24_40AC

; ---- code $4099-$40AC (19 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4018-42AF by apply_coverage --split
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

; ---- code $40AC-$40CD (33 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage --split [executed in 3 scenarios]

Label_24_40AC:: ; 24:40AC
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_24_4103
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_24_40FA
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_24_40FB
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_24_40FA

; ---- code $40CD-$40FA (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4018-42AF by apply_coverage --split
	jr nz, Label_24_40D6
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_24_40FA

Label_24_40D6:: ; 24:40D6
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_24_40E6
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_24_40FA
	set 1, [hl]

Label_24_40E6:: ; 24:40E6
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_24_40FB
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_24_40FB

; ---- code $40FA-$4103 (9 bytes) [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage --split [executed in 3 scenarios]

Label_24_40FA:: ; 24:40FA
	xor a, a

Label_24_40FB:: ; 24:40FB
	pop hl
	or a, a
	jp nz, Label_24_41C4
	jp Label_24_41D7

; ---- code $4103-$41D7 (212 bytes) [PROBABLE] 86 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4018-42AF by apply_coverage --split

Label_24_4103:: ; 24:4103
	xor a, a
	ld [wBrowserFetchResult], a
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
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call PageList_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	jp PageList_Main_Loop

Label_24_41C4:: ; 24:41C4
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

; ---- code $41D7-$42AF (216 bytes) [CONFIRMED] 113 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage --split [executed in 2 scenarios]

Label_24_41D7:: ; 24:41D7
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_24_422A
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
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	pop bc
	call PageList_ActionMenu
	inc a
	jr nz, Label_24_4219
	push bc
	push de
	push hl
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	pop hl
	pop de
	pop bc
	ret

Label_24_4219:: ; 24:4219
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call PageList_SetActionIcons
	ld a, $03
	ld b, $00
	call PageList_ShowMessage
	pop bc

Label_24_422A:: ; 24:422A
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_24_4256
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
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_24_4256:: ; 24:4256
	ldh a, [hJoyPressedRepeat]
	and a, $40
	jp z, Label_24_4281
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
	ld d, c
	dec c
	ld a, $FF
	cp a, c
	jr nz, Label_24_427A
	ld c, $05

Label_24_427A:: ; 24:427A
	ld a, d
	call PageList_RedrawSelection
	call PageList_UpdateRowSprites

Label_24_4281:: ; 24:4281
	ldh a, [hJoyPressedRepeat]
	and a, $80
	jp z, Label_24_42AC
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
	ld d, c
	inc c
	ld a, $06
	cp a, c
	jr nz, Label_24_42A5
	ld c, $00

Label_24_42A5:: ; 24:42A5
	ld a, d
	call PageList_RedrawSelection
	call PageList_UpdateRowSprites

Label_24_42AC:: ; 24:42AC
	jp PageList_Main_Loop

; ---- code $42AF-$42D1 (34 bytes) [HYPOTHESIS] ret + routine 42B0: copies the NUL-terminated string at $42D1 to $D500 and the one at $42E7 to $D3C0 (WRAM bank 6); the two ld hl immediates point exactly at the strings below, which is why code and text are classified together; entry not proven (no caller found) [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	ret

Function_24_42B0:: ; 24:42B0
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D500
	ld hl, Url_GooNeJp

Label_24_42BC:: ; 24:42BC
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_24_42BC
	ld de, $D3C0
	ld hl, String_24_42E7

Label_24_42C9:: ; 24:42C9
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_24_42C9
	ret

; ---- text $42D1-$42E7 (22 bytes) [PROBABLE] ASCII "http://www.goo.ne.jp/" NUL-terminated, addressed by ld hl,$42D1 at 24:42B9

Url_GooNeJp:: ; 24:42D1
String_24_42D1::
	db $68, $74, $74, $70, $3A, $2F, $2F, $77, $77, $77, $2E, $67, $6F, $6F, $2E, $6E, $65, $2E, $6A, $70, $2F, $00 ; "http://www.goo.ne.jp/"

; ---- text $42E7-$42F0 (9 bytes) [PROBABLE] Shift-JIS NUL-terminated string (ぐーぐー), addressed by ld hl,$42E7 at 24:42C6

String_24_42E7:: ; 24:42E7
	db $82, $AD, $81, $5B, $82, $AD, $81, $5B, $00 ; "くーくー"

; ---- code $42F0-$4517 (551 bytes) [CONFIRMED] 989 insn(s) reached by static flow only; seeds: exec x989; min discovery hops 3; entered by call from 24:406A (PROBABLE code) | 219 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 1 scenarios]

PageList_InitScreen:: ; 24:42F0
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $1000

Label_24_42FD:: ; 24:42FD
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_24_42FD
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0780

Label_24_4310:: ; 24:4310
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_24_4310
	farcall Function_00_09B6
	call Function_00_0464
	ld de, $9301
	ld hl, PageList_Tiles_5400
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	call Function_00_0464
	ld de, $9701
	ld hl, $5800
	ld a, $24
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8000
	ld hl, PageList_Tiles_5EE0
	ld a, $24
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	call Function_00_0464
	ld de, $8400
	ld hl, $62E0
	ld a, $24
	ld b, $95
	ld c, $20
	farcall Function_00_0749
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, PageList_ObjPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D800
	ld hl, PageList_BgPalette
	ld a, $24
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, PageList_Tilemap_5900
	ld a, $24
	farcall Function_00_08EA
	call Function_00_0464
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	jr z, Label_24_43D2
	ld bc, $1214
	ld de, $D000
	ld hl, PageList_Tilemap_5BD0
	ld a, $24
	farcall Function_00_08EA
	call Function_00_0464

Label_24_43D2:: ; 24:43D2
	ldh a, [rLCDC]
	call Function_00_082C
	call Function_00_0464
	call PageList_DrawAllTitles
	call Function_00_0464
	pop bc
	push bc
	ld a, $00
	call PageList_RedrawSelection
	call Function_00_0464
	ld c, $00
	call PageList_UpdateRowSprites
	call Function_00_0464
	ld a, $03
	ld b, $00
	call PageList_ShowMessage
	call Function_00_0464
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0A
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop bc
	ret

PageList_UpdateRowSprites:: ; 24:4453
	push bc
	call PageList_InitRowSprites
	call PageList_HighlightRowSprite
	pop bc
	ret

PageList_InitRowSprites:: ; 24:445C
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
	ld hl, $DA60
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, $DA50
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, $DA40
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, $DA30
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, $DA10
	ld de, $6560
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld hl, PageList_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_44EF
	ld hl, $DA60
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

Label_24_44EF:: ; 24:44EF
	ld hl, $4002
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_450B
	ld hl, $DA50
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

Label_24_450B:: ; 24:450B
	ld hl, $4004
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_4527

; ---- code $4517-$4527 (16 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA40
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

; ---- code $4527-$454F (40 bytes) [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 1 scenarios]

Label_24_4527:: ; 24:4527
	ld hl, $4006
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_4543
	ld hl, $DA30
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

Label_24_4543:: ; 24:4543
	ld hl, $4008
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_455F

; ---- code $454F-$455F (16 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA20
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

; ---- code $455F-$456B (12 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 9 scenarios]

Label_24_455F:: ; 24:455F
	ld hl, $400A
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_457B

; ---- code $456B-$457B (16 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA10
	ld de, $6550
	ld a, $24
	ld b, $01
	farcall Function_00_0A82

; ---- code $457B-$4672 (247 bytes) [CONFIRMED] 111 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 1 scenarios]

Label_24_457B:: ; 24:457B
	ld a, $23
	ld [wSpriteSlots + 96], a
	ld a, $2F
	ld [wSpriteSlots + 80], a
	ld a, $3B
	ld [wSpriteSlots + 64], a
	ld a, $47
	ld [wSpriteSlots + 48], a
	ld a, $53
	ld [wSpriteSlots + 32], a
	ld a, $5F
	ld [wSpriteSlots + 16], a
	ld a, $06
	ld [wSpriteSlots + 97], a
	ld [wSpriteSlots + 81], a
	ld [wSpriteSlots + 65], a
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 17], a
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

PageList_HighlightRowSprite:: ; 24:45B7
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
	jr nz, Label_24_4618
	ld hl, PageList_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_45FB
	ld hl, $DA60
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $23
	ld [wSpriteSlots + 96], a
	ld a, $06
	ld [wSpriteSlots + 97], a
	jp Label_24_478A

Label_24_45FB:: ; 24:45FB
	ld hl, $DA60
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $23
	ld [wSpriteSlots + 96], a
	ld a, $06
	ld [wSpriteSlots + 97], a
	jp Label_24_478A

Label_24_4618:: ; 24:4618
	inc a
	cp a, c
	jr nz, Label_24_4662
	ld hl, $4002
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_4645
	ld hl, $DA50
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $2F
	ld [wSpriteSlots + 80], a
	ld a, $06
	ld [wSpriteSlots + 81], a
	jp Label_24_478A

Label_24_4645:: ; 24:4645
	ld hl, $DA50
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $2F
	ld [wSpriteSlots + 80], a
	ld a, $06
	ld [wSpriteSlots + 81], a
	jp Label_24_478A

Label_24_4662:: ; 24:4662
	inc a
	cp a, c
	jr nz, Label_24_46AC
	ld hl, $4004
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_468F

; ---- code $4672-$468F (29 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA40
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $3B
	ld [wSpriteSlots + 64], a
	ld a, $06
	ld [wSpriteSlots + 65], a
	jp Label_24_478A

; ---- code $468F-$46BC (45 bytes) [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 2 scenarios]

Label_24_468F:: ; 24:468F
	ld hl, $DA40
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $3B
	ld [wSpriteSlots + 64], a
	ld a, $06
	ld [wSpriteSlots + 65], a
	jp Label_24_478A

Label_24_46AC:: ; 24:46AC
	inc a
	cp a, c
	jr nz, Label_24_46F6
	ld hl, $4006
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_46D9

; ---- code $46BC-$46D9 (29 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA30
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $47
	ld [wSpriteSlots + 48], a
	ld a, $06
	ld [wSpriteSlots + 49], a
	jp Label_24_478A

; ---- code $46D9-$4706 (45 bytes) [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 2 scenarios]

Label_24_46D9:: ; 24:46D9
	ld hl, $DA30
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $47
	ld [wSpriteSlots + 48], a
	ld a, $06
	ld [wSpriteSlots + 49], a
	jp Label_24_478A

Label_24_46F6:: ; 24:46F6
	inc a
	cp a, c
	jr nz, Label_24_4740
	ld hl, $4008
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_4723

; ---- code $4706-$4723 (29 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA20
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $53
	ld [wSpriteSlots + 32], a
	ld a, $06
	ld [wSpriteSlots + 33], a
	jp Label_24_478A

; ---- code $4723-$4750 (45 bytes) [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 4 scenarios]

Label_24_4723:: ; 24:4723
	ld hl, $DA20
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $53
	ld [wSpriteSlots + 32], a
	ld a, $06
	ld [wSpriteSlots + 33], a
	jp Label_24_478A

Label_24_4740:: ; 24:4740
	inc a
	cp a, c
	jr nz, Label_24_478A
	ld hl, $400A
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, Label_24_476D

; ---- code $4750-$476D (29 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split
	ld hl, $DA10
	ld de, PageList_ObjTable
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $5F
	ld [wSpriteSlots + 16], a
	ld a, $06
	ld [wSpriteSlots + 17], a
	jp Label_24_478A

; ---- code $476D-$49A7 (570 bytes) [CONFIRMED] 334 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 2 scenarios]

Label_24_476D:: ; 24:476D
	ld hl, $DA10
	ld de, $6540
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $5F
	ld [wSpriteSlots + 16], a
	ld a, $06
	ld [wSpriteSlots + 17], a
	jp Label_24_478A

Label_24_478A:: ; 24:478A
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	pop bc
	ret

PageList_GetActionAvailability:: ; 24:4794
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
	ld hl, PageList_UrlSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr nz, Label_24_47D8
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
	jr z, Label_24_47D3
	ld a, $01

Label_24_47D3:: ; 24:47D3
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret

Label_24_47D8:: ; 24:47D8
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
	jr z, Label_24_47F6
	ld a, $01
	ld d, $01

Label_24_47F6:: ; 24:47F6
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret

PageList_SetActionIcons:: ; 24:47FB
	push bc
	di
	ld b, a
	ld a, $01
	ldh [rVBK], a

Label_24_4802:: ; 24:4802
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_24_4802
	ld a, $0C
	dec b
	jr z, Label_24_480F
	ld a, $0B

Label_24_480F:: ; 24:480F
	ld hl, $99C3
	ld [hli], a
	ld [hl], a
	ld hl, $99E3
	ld [hli], a
	ld [hl], a
	ld a, $0C
	dec d
	jr z, Label_24_4820
	ld a, $0B

Label_24_4820:: ; 24:4820
	ld hl, $99C9
	ld [hli], a
	ld [hl], a
	ld hl, $99E9
	ld [hli], a
	ld [hl], a
	ld a, $0C
	dec e
	jr z, Label_24_4831
	ld a, $0B

Label_24_4831:: ; 24:4831
	ld hl, $99CF
	ld [hli], a
	ld [hl], a
	ld hl, $99EF
	ld [hli], a
	ld [hl], a
	ei
	pop bc
	ret

PageList_RedrawSelection:: ; 24:483E
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
	ld hl, $400C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0020
	ld b, a
	xor a, a
	inc b

Label_24_4866:: ; 24:4866
	dec b
	jr z, Label_24_486D
	add a, $0C
	jr Label_24_4866

Label_24_486D:: ; 24:486D
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call PageList_DrawTextLine
	pop bc
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, $400C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
	push hl
	ld de, $0020
	ld b, c
	xor a, a
	inc b

Label_24_488F:: ; 24:488F
	dec b
	jr z, Label_24_4896
	add a, $0C
	jr Label_24_488F

Label_24_4896:: ; 24:4896
	add a, $10
	ld d, a
	ld b, $00
	ld c, $01
	call PageList_DrawTextLine
	pop hl
	pop bc
	push bc
	ld b, $03
	ld c, $00
	ld de, $0220
	ld hl, $D3C0
	call PageList_DrawTextLine
	call PageList_UploadTextTiles
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
	call PageList_SetActionIcons
	pop bc
	ret

PageList_DrawAllTitles:: ; 24:48C7
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

Label_24_48DB:: ; 24:48DB
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, $400C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0020
	ld b, a
	xor a, a
	inc b

Label_24_48F4:: ; 24:48F4
	dec b
	jr z, Label_24_48FB
	add a, $0C
	jr Label_24_48F4

Label_24_48FB:: ; 24:48FB
	add a, $10
	ld d, a
	ld b, $03
	ld c, $00
	call PageList_DrawTextLine
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, Label_24_48DB
	ld hl, $400C
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	push hl
	ld de, $1020
	ld b, $00
	ld c, $01
	call PageList_DrawTextLine
	pop hl
	pop bc
	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $03
	ld c, $00
	ld de, $0220
	ld hl, $D3C0
	call PageList_DrawTextLine
	call PageList_UploadTextTiles
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
	call PageList_SetActionIcons
	pop bc
	ret

PageList_DrawTextLine:: ; 24:494C
	ld a, $14
	ld [wTextCellsLeft], a

Label_24_4951:: ; 24:4951
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jr z, Label_24_49CC
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_24_49A7
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
	call PageList_BlitGlyphAdvance
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
	jr z, Label_24_49CC
	cp a, $01
	jr z, Label_24_49CC
	jr Label_24_4951

; ---- code $49A7-$49CC (37 bytes) [PROBABLE] 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split

Label_24_49A7:: ; 24:49A7
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
	call PageList_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_24_49CC
	cp a, $01
	jr z, Label_24_49CC
	jr Label_24_4951

; ---- code $49CC-$4B10 (324 bytes) [CONFIRMED] 159 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage --split [executed in 9 scenarios]

Label_24_49CC:: ; 24:49CC
	push bc
	push de
	push hl
	ld b, $20
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc

Label_24_49DD:: ; 24:49DD
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call PageList_BlitGlyphAdvance
	jr Label_24_49DD

PageList_BlitGlyphAdvance:: ; 24:49EC
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

PageList_UploadTextTiles:: ; 24:4A00
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Function_00_0392
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Function_00_0392
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D800
	ld de, $8800
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Function_00_0392
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DC00
	ld de, $8C00
	ld c, $2F
	call PageList_StartHDMAAtVBlank
	call Function_00_0392
	ret

PageList_StartHDMAAtVBlank:: ; 24:4A54
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_24_4A63:: ; 24:4A63
	ld a, [de]
	cp a, $5D
	jr nz, Label_24_4A63
	di
	ld b, $91

Label_24_4A6B:: ; 24:4A6B
	ld a, [de]
	cp a, b
	jr nz, Label_24_4A6B
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	xor a, a
	ldh [rSCY], a
	ei
	ret

PageList_ShowMessage:: ; 24:4A79
	push af
	push bc
	push de
	push hl
	ld d, a
	ld e, d
	ld d, $00
	sla e
	ld hl, PageList_MessageTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $24
	ld bc, $D000
	ld de, $D140
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0009
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $24
	ld bc, $D280
	ld de, $D3C0
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0012
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $24
	ld bc, $D500
	ld de, $D640
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $001B
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $24
	ld bc, $D780
	ld de, $D8C0
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0024
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $24
	ld bc, $DA00
	ld de, $DB40
	farcall TextTiles_RenderLine
	pop hl
	call PageList_UploadTextTiles
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- ptrtable $4B10-$4B18 (8 bytes) [PROBABLE] 4 words $4B18,$4B45,$4B72,$4B9F = starts of four 45-byte (multi-line, NUL separated) Shift-JIS messages at 4B18-4BCC; the table is loaded by ld hl,$4B10 at 24:4A83 (a=$24 nearby)

PageList_MessageTable:: ; 24:4B10
Table_24_4B10::
	dw PageList_Msg_GoToPage
	dw PageList_Msg_SavePage
	dw PageList_Msg_DeletePage
	dw PageList_Msg_SelectPage

; ---- text $4B18-$4B21 (9 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PageList_Msg_GoToPage:: ; 24:4B18
String_24_4B18::
	db $81, $40, $81, $40, $81, $40, $82, $B1, $00 ; "　　　こ"

; ---- text $4B21-$4B3C (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_24_4B21:: ; 24:4B21
	db $82, $CC, $83, $79, $81, $5B, $83, $57, $00 ; "のページ"
	db $82, $C9, $81, $40, $82, $A2, $82, $C7, $00 ; "に　いど"
	db $82, $A4, $82, $B5, $82, $DC, $82, $B7, $00 ; "うします"

; ---- text $4B3C-$4B4E (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

String_24_4B3C:: ; 24:4B3C
	db $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　"

PageList_Msg_SavePage:: ; 24:4B45
	db $81, $40, $81, $40, $81, $40, $82, $A2, $00 ; "　　　い"

; ---- text $4B4E-$4B69 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_24_4B4E:: ; 24:4B4E
	db $82, $DC, $82, $CC, $83, $79, $81, $5B, $00 ; "まのペー"
	db $83, $57, $82, $F0, $81, $40, $83, $5A, $00 ; "ジを　セ"
	db $81, $5B, $83, $75, $82, $B5, $82, $DC, $00 ; "ーブしま"

; ---- text $4B69-$4B7B (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

String_24_4B69:: ; 24:4B69
	db $82, $B7, $81, $40, $81, $40, $81, $40, $00 ; "す　　　"

PageList_Msg_DeletePage:: ; 24:4B72
	db $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　"

; ---- text $4B7B-$4B96 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_24_4B7B:: ; 24:4B7B
	db $82, $B1, $82, $CC, $83, $79, $81, $5B, $00 ; "このペー"
	db $83, $57, $82, $F0, $81, $40, $82, $AF, $00 ; "ジを　け"
	db $82, $B5, $82, $DC, $82, $B7, $81, $40, $00 ; "します　"

; ---- text $4B96-$4BA8 (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

String_24_4B96:: ; 24:4B96
	db $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　"

PageList_Msg_SelectPage:: ; 24:4B9F
	db $81, $40, $81, $40, $83, $79, $81, $5B, $00 ; "　　ペー"

; ---- text $4BA8-$4BC3 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_24_4BA8:: ; 24:4BA8
	db $83, $57, $82, $F0, $81, $40, $82, $B9, $00 ; "ジを　せ"
	db $82, $F1, $82, $BD, $82, $AD, $82, $B5, $00 ; "んたくし"
	db $82, $C4, $82, $AD, $82, $BE, $82, $B3, $00 ; "てくださ"

; ---- text $4BC3-$4BCC (9 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

String_24_4BC3:: ; 24:4BC3
	db $82, $A2, $81, $40, $81, $40, $81, $40, $00 ; "い　　　"

; ---- data $4BCC-$4BCD (1 bytes) [HYPOTHESIS] UNCLASSIFIED 10 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) [range trimmed from 4BC3-4BCD by classify_g2]

Data_24_4BCC:: ; 24:4BCC
	db $C9

; ---- code $4BCD-$4BEB (30 bytes) [CONFIRMED] 1021 insn(s) reached by static flow only; seeds: exec x1021; min discovery hops 4; entered by call from 24:4203 (PROBABLE code) | 11 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 3 scenarios]

PageList_ActionMenu:: ; 24:4BCD
	call PageList_ActionMenuInit
	call Function_24_53FD
	ld b, $00

PageList_ActionMenu_Loop:: ; 24:4BD5
	push bc
	farcall Function_00_0956
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, Label_24_4D39
	ld a, [wTimerEnable]
	bit 1, a
	jr z, Label_24_4BFE

; ---- code $4BEB-$4BFE (19 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

; ---- code $4BFE-$4C2F (49 bytes) [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

Label_24_4BFE:: ; 24:4BFE
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_24_4C55
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_24_4C4C
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_24_4C4D
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_24_4C4C
	jr nz, Label_24_4C28
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_24_4C4C

Label_24_4C28:: ; 24:4C28
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_24_4C38

; ---- code $4C2F-$4C38 (9 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_24_4C4C
	set 1, [hl]

; ---- code $4C38-$4C55 (29 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

Label_24_4C38:: ; 24:4C38
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_24_4C4D
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_24_4C4D

Label_24_4C4C:: ; 24:4C4C
	xor a, a

Label_24_4C4D:: ; 24:4C4D
	pop hl
	or a, a
	jp nz, Label_24_4D25
	jp Label_24_4D39

; ---- code $4C55-$4D25 (208 bytes) [PROBABLE] 85 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Label_24_4C55:: ; 24:4C55
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
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call PageList_InitScreen
	call Function_00_0464
	pop bc
	push bc
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	farcall Sprites_RestoreSlotsFromBank3
	farcall Function_00_0956
	pop bc
	jp PageList_ActionMenu_Loop

; ---- code $4D25-$4EEF (458 bytes) [CONFIRMED] 225 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

Label_24_4D25:: ; 24:4D25
	pop bc
	pop af
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

Label_24_4D39:: ; 24:4D39
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	call nz, Function_24_53FC
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_24_4DBA
	ld a, b
	cp a, $01
	jr nz, Label_24_4D5E
	call PageList_SaveCurrentPage
	farcall SramCheck_Bank1Commit
	jr Label_24_4D6B

Label_24_4D5E:: ; 24:4D5E
	cp a, $02
	jr nz, Label_24_4D97
	call PageList_DeleteSlot
	farcall SramCheck_Bank1Commit

Label_24_4D6B:: ; 24:4D6B
	inc a
	jp z, Label_24_4D8A
	inc a
	jp z, PageList_ActionMenu_Loop
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
	jp PageList_ActionMenu_Loop

Label_24_4D8A:: ; 24:4D8A
	call PageList_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret

Label_24_4D97:: ; 24:4D97
	call PageList_GoToSlot
	inc a
	jp z, Label_24_4DB7
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
	ld a, $FF
	jp PageList_ActionMenu_Loop

Label_24_4DB7:: ; 24:4DB7
	ld a, $FF
	ret

Label_24_4DBA:: ; 24:4DBA
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_24_4DE1
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
	call PageList_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret

Label_24_4DE1:: ; 24:4DE1
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, Label_24_4E12
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld d, b
	dec b
	ld a, $FF
	cp a, b
	jr nz, Label_24_4E06
	ld b, $02

Label_24_4E06:: ; 24:4E06
	ld a, d
	call PageList_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d

Label_24_4E12:: ; 24:4E12
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, Label_24_4E43
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld d, b
	inc b
	ld a, $03
	cp a, b
	jr nz, Label_24_4E37
	ld b, $00

Label_24_4E37:: ; 24:4E37
	ld a, d
	call PageList_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d

Label_24_4E43:: ; 24:4E43
	jp PageList_ActionMenu_Loop

PageList_ActionMenuInit:: ; 24:4E46
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA00
	ld de, $6570
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $16
	ld [wSpriteSlots + 1], a
	pop bc
	xor a, a
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d
	ret

PageList_HideActionCursor:: ; 24:4E71
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	ld a, $E8
	ld [wSpriteSlots + 1], a
	farcall Function_00_0956
	pop bc
	ret

PageList_SetActionCursor:: ; 24:4E85
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	cp a, b
	jr nz, Label_24_4EAD
	ld hl, $DA00
	ld de, $6570
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $16
	ld [wSpriteSlots + 1], a
	pop bc
	ret

Label_24_4EAD:: ; 24:4EAD
	ld a, $01
	cp a, b
	jr nz, Label_24_4ECE
	ld hl, $DA00
	ld de, $6580
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $46
	ld [wSpriteSlots + 1], a
	pop bc
	ret

Label_24_4ECE:: ; 24:4ECE
	ld a, $02
	cp a, b
	jr nz, Label_24_4EEF
	ld hl, $DA00
	ld de, $6590
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $76
	ld [wSpriteSlots + 1], a
	pop bc
	ret

; ---- code $4EEF-$4EF1 (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Label_24_4EEF:: ; 24:4EEF
	pop bc
	ret

; ---- code $4EF1-$4F04 (19 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 8 scenarios]

PageList_MoveActionCursor:: ; 24:4EF1
	push bc
	jr c, Label_24_4F04
	pop bc
	call PageList_SetActionCursor
	push bc
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	ret

; ---- code $4F04-$4F14 (16 bytes) [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Label_24_4F04:: ; 24:4F04
	pop bc
	call PageList_SetActionCursor
	push bc
	farcall Function_00_0956
	call Function_00_0464
	pop bc
	ret

; ---- code $4F14-$5064 (336 bytes) [CONFIRMED] 171 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

PageList_SaveCurrentPage:: ; 24:4F14
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	ret z
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
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
	ld hl, PageList_UrlSlotTable
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push bc
	push de
	ld a, [de]
	cp a, $00
	jp z, Label_24_4FF6
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 33]
	ld c, a
	ld a, $C0
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 17], a
	ld a, [wSpriteSlots]
	ld b, a
	ld a, $C0
	ld [wSpriteSlots], a
	push bc
	ld de, $0109
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
	pop bc
	push af
	ld a, c
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 17], a
	ld a, b
	ld [wSpriteSlots], a
	pop af
	pop de
	pop bc
	push af
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	pop af
	dec a
	jr z, Label_24_4FF6
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA00
	ld de, $6580
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $46
	ld [wSpriteSlots + 1], a
	pop bc
	push bc
	call PageList_UpdateRowSprites
	pop bc
	pop de
	pop bc
	xor a, a
	ldh [hJoyPressed], a
	ld a, $FE
	ret

Label_24_4FF6:: ; 24:4FF6
	push bc
	push de
	call PageList_UpdateRowSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0032
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	pop de
	pop bc
	push de
	push bc
	ld a, c
	cp a, $00
	jr nz, Label_24_5039
	ld hl, $DA60
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [wSpriteSlots + 96], a
	ld a, $06
	ld [wSpriteSlots + 97], a
	jp Label_24_50FC

Label_24_5039:: ; 24:5039
	cp a, $01
	jr nz, Label_24_5060
	ld hl, $DA50
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [wSpriteSlots + 80], a
	ld a, $06
	ld [wSpriteSlots + 81], a
	jp Label_24_50FC

Label_24_5060:: ; 24:5060
	cp a, $02
	jr nz, Label_24_5087

; ---- code $5064-$5087 (35 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split
	ld hl, $DA40
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3B
	ld [wSpriteSlots + 64], a
	ld a, $06
	ld [wSpriteSlots + 65], a
	jp Label_24_50FC

; ---- code $5087-$50AE (39 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

Label_24_5087:: ; 24:5087
	cp a, $03
	jr nz, Label_24_50AE
	ld hl, $DA30
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $47
	ld [wSpriteSlots + 48], a
	ld a, $06
	ld [wSpriteSlots + 49], a
	jp Label_24_50FC

; ---- code $50AE-$50FC (78 bytes) [PROBABLE] 30 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Label_24_50AE:: ; 24:50AE
	cp a, $04
	jr nz, Label_24_50D5
	ld hl, $DA20
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $53
	ld [wSpriteSlots + 32], a
	ld a, $06
	ld [wSpriteSlots + 33], a
	jp Label_24_50FC

Label_24_50D5:: ; 24:50D5
	cp a, $05
	jr nz, Label_24_50FC
	ld hl, $DA10
	ld de, $65A0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $5F
	ld [wSpriteSlots + 16], a
	ld a, $06
	ld [wSpriteSlots + 17], a
	jp Label_24_50FC

; ---- code $50FC-$5149 (77 bytes) [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 2 scenarios]

Label_24_50FC:: ; 24:50FC
	pop bc
	ld e, $32

Label_24_50FF:: ; 24:50FF
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	pop de
	pop bc
	dec e
	jr nz, Label_24_50FF
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

Label_24_512C:: ; 24:512C
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_24_512C
	pop bc
	ld e, c
	ld d, $00
	sla e
	ld hl, $400C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	push bc
	ld hl, $D3C0
	ld a, [hl]
	cp a, $00
	jr nz, Label_24_514C

; ---- code $5149-$514C (3 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split
	ld hl, $D500

; ---- code $514C-$530A (446 bytes) [CONFIRMED] 242 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 1 scenarios]

Label_24_514C:: ; 24:514C
	ld c, $16

Label_24_514E:: ; 24:514E
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_24_514E
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld a, c
	call PageList_RedrawSelection
	ld a, $FF
	ret

PageList_GoToSlot:: ; 24:5164
	push bc
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld a, [hl]
	cp a, $00
	jr nz, Label_24_5173

Label_24_5173:: ; 24:5173
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
	ld hl, $400C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, PageList_UrlSlotTable
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
	push de
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d
	pop de
	push bc
	push de
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop hl
	pop de
	pop bc
	ld a, $FF
	ret

PageList_DeleteSlot:: ; 24:51CB
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
	ld hl, PageList_UrlSlotTable
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
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 33]
	ld c, a
	ld a, $C0
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 17], a
	ld a, [wSpriteSlots]
	ld b, a
	ld a, $C0
	ld [wSpriteSlots], a
	push bc
	ld de, $0108
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
	pop bc
	push af
	ld a, c
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
	ld [wSpriteSlots + 17], a
	ld a, b
	ld [wSpriteSlots], a
	pop af
	pop de
	pop bc
	push af
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	pop af
	dec a
	jr z, Label_24_52A3
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DA00
	ld de, $6590
	ld a, $24
	ld b, $81
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $6F
	ld [wSpriteSlots], a
	ld a, $76
	ld [wSpriteSlots + 1], a
	pop bc
	push bc
	call PageList_UpdateRowSprites
	pop bc
	xor a, a
	ldh [hJoyPressed], a
	ld a, $FE
	ret

Label_24_52A3:: ; 24:52A3
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
	call PageList_UpdateRowSprites
	pop de
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr nz, Label_24_52E3
	ld hl, $DA60
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [wSpriteSlots + 96], a
	ld a, $06
	ld [wSpriteSlots + 97], a
	jp Label_24_53A6

Label_24_52E3:: ; 24:52E3
	cp a, $01
	jr nz, Label_24_530A
	ld hl, $DA50
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [wSpriteSlots + 80], a
	ld a, $06
	ld [wSpriteSlots + 81], a
	jp Label_24_53A6

; ---- code $530A-$53A6 (156 bytes) [PROBABLE] 60 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Label_24_530A:: ; 24:530A
	cp a, $02
	jr nz, Label_24_5331
	ld hl, $DA40
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3B
	ld [wSpriteSlots + 64], a
	ld a, $06
	ld [wSpriteSlots + 65], a
	jp Label_24_53A6

Label_24_5331:: ; 24:5331
	cp a, $03
	jr nz, Label_24_5358
	ld hl, $DA30
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $47
	ld [wSpriteSlots + 48], a
	ld a, $06
	ld [wSpriteSlots + 49], a
	jp Label_24_53A6

Label_24_5358:: ; 24:5358
	cp a, $04
	jr nz, Label_24_537F
	ld hl, $DA20
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $53
	ld [wSpriteSlots + 32], a
	ld a, $06
	ld [wSpriteSlots + 33], a
	jp Label_24_53A6

Label_24_537F:: ; 24:537F
	cp a, $05
	jr nz, Label_24_53A6
	ld hl, $DA10
	ld de, $65B0
	ld a, $24
	ld b, $01
	farcall Function_00_0A82
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $5F
	ld [wSpriteSlots + 16], a
	ld a, $06
	ld [wSpriteSlots + 17], a
	jp Label_24_53A6

; ---- code $53A6-$53FC (86 bytes) [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 3 scenarios]

Label_24_53A6:: ; 24:53A6
	pop bc
	ld e, $32

Label_24_53A9:: ; 24:53A9
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	pop de
	pop bc
	dec e
	jr nz, Label_24_53A9
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
	ld hl, $400C
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
	ld hl, PageList_UrlSlotTable
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
	call PageList_RedrawSelection
	ld a, $FF
	ret

; ---- code $53FC-$53FD (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split

Function_24_53FC:: ; 24:53FC
	ret

; ---- code $53FD-$53FE (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage --split [executed in 8 scenarios]

Function_24_53FD:: ; 24:53FD
	ret

; ---- zero $53FE-$5400 (2 bytes) [PROBABLE] 0x00 padding between code and the tile block at $5400
	ds $2, $00
