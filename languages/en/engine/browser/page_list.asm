; engine/browser/page_list.asm
; bank 24, $4000-$5400 (5120 bytes); pinned by layout.link
; page list (6 saved pages): main loop, draw, action menu, save/go/delete

SECTION "engine/browser/page_list", ROMX

; ---- words $4000-$4018 (24 bytes) [PROBABLE] 12 words = SRAM addresses: $A084,$A184..$A584 (stride $100) and $A000,$A016,$A02C,$A042,$A058,$A06E (stride $16); entries 4000/4002/4004/4006/4008/400A are loaded by ld hl,$400x at 24:44C9,44E5,4501,451D,4539,4555 (analysis of ld imm16 operands); meaning of the slots not decoded

PageList_UrlSlotTable:: ; 24:4000
	dw $A084, $A184, $A284, $A384, $A484, $A584

PageList_TitleSlotTable:: ; 24:400C
	dw $A000, $A016, $A02C, $A042, $A058, $A06E

PageList_Main:: ; 24:4018
	; [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 2;
	; entered by far from 4E:4DB1 (PROBABLE code) | 59 insn(s) executed; cut out of the PROBABLE
	; region 4018-42AF by apply_coverage --split [executed in 3 scenarios]
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
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wBrowserPageUrl]
	cp a, $00
	jr nz, .select_wram6
	xor a, a
	ld [wDialogOnlineSnapshot], a
.select_wram6 ; 24:4053
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wBrowserPageUrl]
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
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	ld c, $00

PageList_Main_Loop:: ; 24:4083
	push bc
	farcall Sprite_UpdateAll
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, .handle_input
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .check_timer_warning

	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4018-42AF by apply_coverage --split
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

.check_timer_warning ; 24:40AC
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage
	; --split [executed in 3 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .handle_timer_inactive
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .no_warning
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .test_warning_result
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .no_warning

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4018-42AF by apply_coverage --split
	jr nz, .check_warning_45
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .no_warning
.check_warning_45 ; 24:40D6
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .set_warning_pending
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .no_warning
	set 1, [hl]
.set_warning_pending ; 24:40E6
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .test_warning_result
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .test_warning_result

.no_warning ; 24:40FA
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage
	; --split [executed in 3 scenarios]
	xor a, a
.test_warning_result ; 24:40FB
	pop hl
	or a, a
	jp nz, .return_abort
	jp .handle_input

.handle_timer_inactive ; 24:4103
	; [PROBABLE] 86 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4018-42AF by apply_coverage --split
	xor a, a
	ld [wBrowserFetchResult], a
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
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0006
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call PageList_InitScreen
	farcall Sprites_RestoreSlotsFromBank3
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	jp PageList_Main_Loop
.return_abort ; 24:41C4
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

.handle_input ; 24:41D7
	; [CONFIRMED] 113 insn(s) executed; cut out of the PROBABLE region 4018-42AF by apply_coverage
	; --split [executed in 2 scenarios]
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .check_b_button
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	push bc
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	pop bc
	call PageList_ActionMenu
	inc a
	jr nz, .restore_list_message
	push bc
	push de
	push hl
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	pop hl
	pop de
	pop bc
	ret
.restore_list_message ; 24:4219
	push bc
	xor a, a
	ld d, $00
	ld e, $00
	call PageList_SetActionIcons
	ld a, $03
	ld b, $00
	call PageList_ShowMessage
	pop bc
.check_b_button ; 24:422A
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .check_up_button
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.check_up_button ; 24:4256
	ldh a, [hJoyPressedRepeat]
	and a, PADF_UP
	jp z, .check_down_button
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	dec c
	ld a, $FF
	cp a, c
	jr nz, .redraw_after_up
	ld c, $05
.redraw_after_up ; 24:427A
	ld a, d
	call PageList_RedrawSelection
	call PageList_UpdateRowSprites
.check_down_button ; 24:4281
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DOWN
	jp z, .next_frame
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	inc c
	ld a, $06
	cp a, c
	jr nz, .redraw_after_down
	ld c, $00
.redraw_after_down ; 24:42A5
	ld a, d
	call PageList_RedrawSelection
	call PageList_UpdateRowSprites
.next_frame ; 24:42AC
	jp PageList_Main_Loop

	; [HYPOTHESIS] ret + routine 42B0: copies the NUL-terminated string at $42D1 to $D500 and the
	; one at $42E7 to $D3C0 (WRAM bank 6); the two ld hl immediates point exactly at the strings
	; below, which is why code and text are classified together; entry not proven (no caller found)
	; [verifier: no entry proven (no caller, no valid table word, never executed): decode chain
	; alone is not proof -> HYPOTHESIS]
	ret
Wram6_CopyGooUrlAndTitleToPageBuffers:: ; 24:42B0 [PROBABLE] operation; entry/purpose unproved

	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wBrowserPageUrl
	ld hl, Url_GooNeJp
.copy_url ; 24:42BC
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .copy_url
	ld de, wBrowserPageTitle
	ld hl, String_Browser_CandidateGooPageTitle
.copy_title ; 24:42C9
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .copy_title
	ret

; ---- text $42D1-$42E7 (22 bytes) [PROBABLE] ASCII "http://www.goo.ne.jp/" NUL-terminated, addressed by ld hl,$42D1 at 24:42B9

PUSHC sjis
Url_GooNeJp:: ; 24:42D1
	db "http://www.goo.ne.jp/", 0
POPC

; ---- text $42E7-$42F0 (9 bytes) [PROBABLE] Shift-JIS NUL-terminated candidate page-title text (くーくー), copied to wBrowserPageTitle by 24:42B0; routine entry/natural use unproved

PUSHC sjis
String_Browser_CandidateGooPageTitle:: ; 24:42E7
	db "くーくー", 0
POPC

PageList_InitScreen:: ; 24:42F0
	; [CONFIRMED] 989 insn(s) reached by static flow only; seeds: exec x989; min discovery hops 3;
	; entered by call from 24:406A (PROBABLE code) | 219 insn(s) executed; cut out of the PROBABLE
	; region 42F0-4B10 by apply_coverage --split [executed in 1 scenarios]
	push bc
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $1000
.clear_tile_stage2 ; 24:42FD
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_tile_stage2
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage3
	ld bc, $0780
.clear_tile_stage3 ; 24:4310
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .clear_tile_stage3
	farcall Sprite_ResetAll
	call VBlank_Wait
	ld de, $9301
	ld hl, PageList_Tiles_5400
	ld a, BANK(PageList_Tiles_5400)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $9701
	ld hl, PageList_Tiles_5800
	ld a, BANK(PageList_Tiles_5800)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $8000
	ld hl, PageList_Tiles_5EE0
	ld a, BANK(PageList_Tiles_5EE0)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld de, $8400
	ld hl, PageList_Tiles_62E0
	ld a, BANK(PageList_Tiles_62E0)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, PageList_ObjPalette
	ld a, BANK(PageList_ObjPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, PageList_BgPalette
	ld a, BANK(PageList_BgPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, PageList_Tilemap_5900
	ld a, BANK(PageList_Tilemap_5900)
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wBrowserPageUrl
	ld a, [hl]
	cp a, $00
	jr z, .upload_maps_and_titles
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, PageList_Tilemap_5BD0
	ld a, BANK(PageList_Tilemap_5BD0)
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
.upload_maps_and_titles ; 24:43D2
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	call PageList_DrawAllTitles
	call VBlank_Wait
	pop bc
	push bc
	ld a, $00
	call PageList_RedrawSelection
	call VBlank_Wait
	ld c, $00
	call PageList_UpdateRowSprites
	call VBlank_Wait
	ld a, $03
	ld b, $00
	call PageList_ShowMessage
	call VBlank_Wait
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
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
	ld [wKbdSlideDeltaRow], a
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
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
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
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable_Entry12
	ld a, BANK(PageList_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld hl, PageList_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_row_1
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.check_row_1 ; 24:44EF
	ld hl, $4002
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_row_2
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.check_row_2 ; 24:450B
	ld hl, $4004
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_row_3

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.check_row_3 ; 24:4527
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, $4006
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_row_4
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot
.check_row_4 ; 24:4543
	ld hl, $4008
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .check_row_5

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.check_row_5 ; 24:455F
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 9 scenarios]
	ld hl, $400A
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .set_row_positions

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable_Entry8
	ld a, BANK(PageList_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.set_row_positions ; 24:457B
	; [CONFIRMED] 111 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $23
	ld [wSpriteSlot6], a
	ld a, $2F
	ld [wSpriteSlot5], a
	ld a, $3B
	ld [wSpriteSlot4], a
	ld a, $47
	ld [wSpriteSlot3], a
	ld a, $53
	ld [wSpriteSlot2], a
	ld a, $5F
	ld [wSpriteSlot1], a
	ld a, $06
	ld [wSpriteSlot6 + $01], a
	ld [wSpriteSlot5 + $01], a
	ld [wSpriteSlot4 + $01], a
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot2 + $01], a
	ld [wSpriteSlot1 + $01], a
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
	jr nz, .check_row_1
	ld hl, PageList_UrlSlotTable
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_0
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $23
	ld [wSpriteSlot6], a
	ld a, $06
	ld [wSpriteSlot6 + $01], a
	jp .close_sram
.highlight_empty_row_0 ; 24:45FB
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $23
	ld [wSpriteSlot6], a
	ld a, $06
	ld [wSpriteSlot6 + $01], a
	jp .close_sram
.check_row_1 ; 24:4618
	inc a
	cp a, c
	jr nz, .check_row_2
	ld hl, $4002
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_1
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $2F
	ld [wSpriteSlot5], a
	ld a, $06
	ld [wSpriteSlot5 + $01], a
	jp .close_sram
.highlight_empty_row_1 ; 24:4645
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $2F
	ld [wSpriteSlot5], a
	ld a, $06
	ld [wSpriteSlot5 + $01], a
	jp .close_sram
.check_row_2 ; 24:4662
	inc a
	cp a, c
	jr nz, .check_row_3
	ld hl, $4004
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_2

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $3B
	ld [wSpriteSlot4], a
	ld a, $06
	ld [wSpriteSlot4 + $01], a
	jp .close_sram

.highlight_empty_row_2 ; 24:468F
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $3B
	ld [wSpriteSlot4], a
	ld a, $06
	ld [wSpriteSlot4 + $01], a
	jp .close_sram
.check_row_3 ; 24:46AC
	inc a
	cp a, c
	jr nz, .check_row_4
	ld hl, $4006
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_3

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $47
	ld [wSpriteSlot3], a
	ld a, $06
	ld [wSpriteSlot3 + $01], a
	jp .close_sram

.highlight_empty_row_3 ; 24:46D9
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $47
	ld [wSpriteSlot3], a
	ld a, $06
	ld [wSpriteSlot3 + $01], a
	jp .close_sram
.check_row_4 ; 24:46F6
	inc a
	cp a, c
	jr nz, .check_row_5
	ld hl, $4008
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_4

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $53
	ld [wSpriteSlot2], a
	ld a, $06
	ld [wSpriteSlot2 + $01], a
	jp .close_sram

.highlight_empty_row_4 ; 24:4723
	; [CONFIRMED] 21 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 4 scenarios]
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $53
	ld [wSpriteSlot2], a
	ld a, $06
	ld [wSpriteSlot2 + $01], a
	jp .close_sram
.check_row_5 ; 24:4740
	inc a
	cp a, c
	jr nz, .close_sram
	ld hl, $400A
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [de]
	cp a, $00
	jr z, .highlight_empty_row_5

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable
	ld a, BANK(PageList_ObjTable)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $5F
	ld [wSpriteSlot1], a
	ld a, $06
	ld [wSpriteSlot1 + $01], a
	jp .close_sram

.highlight_empty_row_5 ; 24:476D
	; [CONFIRMED] 334 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 2 scenarios]
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable_Entry4
	ld a, BANK(PageList_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $5F
	ld [wSpriteSlot1], a
	ld a, $06
	ld [wSpriteSlot1 + $01], a
	jp .close_sram
.close_sram ; 24:478A
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
	jr nz, .slot_has_url
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
	jr z, .return_empty_slot_flags
	ld a, $01
.return_empty_slot_flags ; 24:47D3
	ld c, a
	ld a, d
	ld d, c
	pop bc
	ret
.slot_has_url ; 24:47D8
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
	jr z, .return_filled_slot_flags
	ld a, $01
	ld d, $01
.return_filled_slot_flags ; 24:47F6
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
.wait_for_ly_90 ; 24:4802
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_for_ly_90
	ld a, $0C
	dec b
	jr z, .write_go_attributes
	ld a, $0B
.write_go_attributes ; 24:480F
	ld hl, $99C3
	ld [hli], a
	ld [hl], a
	ld hl, $99E3
	ld [hli], a
	ld [hl], a
	ld a, $0C
	dec d
	jr z, .write_save_attributes
	ld a, $0B
.write_save_attributes ; 24:4820
	ld hl, $99C9
	ld [hli], a
	ld [hl], a
	ld hl, $99E9
	ld [hli], a
	ld [hl], a
	ld a, $0C
	dec e
	jr z, .write_delete_attributes
	ld a, $0B
.write_delete_attributes ; 24:4831
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
.old_row_y_loop ; 24:4866
	dec b
	jr z, .draw_old_row_title
	add a, $0C
	jr .old_row_y_loop
.draw_old_row_title ; 24:486D
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
.selected_row_y_loop ; 24:488F
	dec b
	jr z, .draw_selected_row_title
	add a, $0C
	jr .selected_row_y_loop
.draw_selected_row_title ; 24:4896
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
	ld hl, wBrowserPageTitle
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
.draw_next_title ; 24:48DB
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
.row_y_loop ; 24:48F4
	dec b
	jr z, .draw_row_title
	add a, $0C
	jr .row_y_loop
.draw_row_title ; 24:48FB
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
	jr nz, .draw_next_title
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
	ld hl, wBrowserPageTitle
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
.read_next_char ; 24:4951
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jr z, .load_padding_space
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, .draw_single_byte_char
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
	call PageList_BlitGlyphAdvance
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
	jr z, .load_padding_space
	cp a, $01
	jr z, .load_padding_space
	jr .read_next_char

.draw_single_byte_char ; 24:49A7
	; [PROBABLE] 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42F0-4B10 by apply_coverage --split
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
	call PageList_BlitGlyphAdvance
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, .load_padding_space
	cp a, $01
	jr z, .load_padding_space
	jr .read_next_char

.load_padding_space ; 24:49CC
	; [CONFIRMED] 159 insn(s) executed; cut out of the PROBABLE region 42F0-4B10 by apply_coverage
	; --split [executed in 9 scenarios]
	push bc
	push de
	push hl
	ld b, $20
	ld de, wGlyphBufLeft
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
.pad_remaining_cells ; 24:49DD
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call PageList_BlitGlyphAdvance
	jr .pad_remaining_cells

PageList_BlitGlyphAdvance:: ; 24:49EC
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

PageList_UploadTextTiles:: ; 24:4A00
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Sound_FrameService
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Sound_FrameService
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $3F
	call PageList_StartHDMAAtVBlank
	call Sound_FrameService
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2 + $C00
	ld de, $8C00
	ld c, $2F
	call PageList_StartHDMAAtVBlank
	call Sound_FrameService
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
	ld de, rLY
.wait_ly_5d ; 24:4A63
	ld a, [de]
	cp a, $5D
	jr nz, .wait_ly_5d
	di
	ld b, $91
.wait_ly_91 ; 24:4A6B
	ld a, [de]
	cp a, b
	jr nz, .wait_ly_91
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
	ldh [hTextTiles_DestBank], a
	ld a, $24
	ld bc, wTileStage2
	ld de, wTileStage2 + $140
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0009
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $24
	ld bc, wTileStage2 + $280
	ld de, wTileStage2 + $3C0
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0012
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $24
	ld bc, wTileStage2 + $500
	ld de, wTileStage2 + $640
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $001B
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $24
	ld bc, wTileStage2 + $780
	ld de, wTileStage2 + $8C0
	farcall TextTiles_RenderLine
	pop hl
	push hl
	ld de, $0024
	add hl, de
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $24
	ld bc, wTileStage2 + $A00
	ld de, wTileStage2 + $B40
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
	dw PageList_Msg_GoToPage
	dw PageList_Msg_SavePage
	dw PageList_Msg_DeletePage
	dw PageList_Msg_SelectPage

; ---- text $4B18-$4B21 (9 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PUSHC sjis
PUSHC sjis
PageList_Msg_GoToPage:: ; 24:4B18
	db "　　　　", 0
POPC
POPC

; ---- text $4B21-$4B3C (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_PageList_Msg_GoToPage_Lines2to4:: ; 24:4B21
	db "のページ", 0
	db "に　いど", 0
	db "うします", 0
POPC

; ---- text $4B3C-$4B4E (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PUSHC sjis
PUSHC sjis
String_PageList_Msg_GoToPage_TrailingLine:: ; 24:4B3C
; Retained original storage bytes; outside the selected live string extents.
	db $81, $40, $81, $40, $81, $40, $81, $40, $00
PageList_Msg_SavePage:: ; 24:4B45
	db "　　　　", 0
POPC

POPC

; ---- text $4B4E-$4B69 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_PageList_Msg_SavePage_Lines2to4:: ; 24:4B4E
	db "まのペー", 0
	db "ジを　セ", 0
	db "ーブしま", 0
POPC

; ---- text $4B69-$4B7B (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PUSHC sjis
String_PageList_Msg_SavePage_TrailingLine:: ; 24:4B69
	db "す　　　", 0

PageList_Msg_DeletePage:: ; 24:4B72
	db "　　　　", 0
POPC

; ---- text $4B7B-$4B96 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_PageList_Msg_DeletePage_Lines2to4:: ; 24:4B7B
	db "このペー", 0
	db "ジを　け", 0
	db "します　", 0
POPC

; ---- text $4B96-$4BA8 (18 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PUSHC sjis
PUSHC sjis
String_PageList_Msg_DeletePage_TrailingLine:: ; 24:4B96
; Retained original storage bytes; outside the selected live string extents.
	db $81, $40, $81, $40, $81, $40, $81, $40, $00
PageList_Msg_SelectPage:: ; 24:4B9F
	db "　　　Ｌ", 0
POPC

POPC

; ---- text $4BA8-$4BC3 (27 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_PageList_Msg_SelectPage_Lines2to4:: ; 24:4BA8
	db "ジを　せ", 0
	db "んたくし", 0
	db "てくださ", 0
POPC

; ---- text $4BC3-$4BCC (9 bytes) [PROBABLE] Shift-JIS NUL-terminated line(s) of the message table at 24:4B10 (decodes cleanly with cp932; continues the neighbouring text regions of the same 45-byte messages)

PUSHC sjis
String_PageList_Msg_SelectPage_TrailingLine:: ; 24:4BC3
	db "い　　　", 0
POPC

; ---- data $4BCC-$4BCD (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 byte: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) [range trimmed from 4BC3-4BCD by classify_g2]

Data_PageList_CandidateRetOpcode_4BCC:: ; 24:4BCC
	db $C9

PageList_ActionMenu:: ; 24:4BCD
	; [CONFIRMED] 1021 insn(s) reached by static flow only; seeds: exec x1021; min discovery hops 4;
	; entered by call from 24:4203 (PROBABLE code) | 11 insn(s) executed; cut out of the PROBABLE
	; region 4BCD-53FE by apply_coverage --split [executed in 3 scenarios]
	call PageList_ActionMenuInit
	call PageList_ActionMenuPostInitReturnOnly
	ld b, $00

PageList_ActionMenu_Loop:: ; 24:4BD5
	push bc
	farcall Sprite_UpdateAll
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jp z, .handle_input
	ld a, [wTimerEnable]
	bit 1, a
	jr z, .check_timer_warning

	; [CONFIRMED] Error exit observed in the 2026-10-25 adapter-removal replay:
	; SDK 75:592A writes $02 to wTimerEnable; RET 4BFD returns before 4C55.
	; This is distinct from a connection-bit clear with error bit 1 still zero.
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret

.check_timer_warning ; 24:4BFE
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .handle_timer_inactive
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .no_warning
	ld hl, wTimerAWarnFlags
	bit 0, [hl]
	jr nz, .test_warning_result
	ld a, [wTimerAWarnMinute]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, .no_warning
	jr nz, .check_warning_45
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, .no_warning
.check_warning_45 ; 24:4C28
	ld a, [wTimerAWarnMinute]
	cp a, $45
	jr nz, .set_warning_pending

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	ld hl, wTimerAWarnFlags
	bit 1, [hl]
	jr nz, .no_warning
	set 1, [hl]

.set_warning_pending ; 24:4C38
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, wTimerAWarnFlags
	set 0, [hl]
	ld hl, wTimerAWarnMinute
	ld a, [hl]
	cp a, $45
	jr z, .test_warning_result
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr .test_warning_result
.no_warning ; 24:4C4C
	xor a, a
.test_warning_result ; 24:4C4D
	pop hl
	or a, a
	jp nz, .return_abort
	jp .handle_input

.handle_timer_inactive ; 24:4C55
	; [CONFIRMED, controlled serial fault] A sustained adapter-wait $D2 stream
	; reaches 4C55 after the second response timeout (2026-10-25 replay).
	; This is not an observation with an unmodified adapter or on hardware.
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
	; [CONFIRMED conditional] 4CD1/4CD2 save BC twice. With balanced callees
	; and a stable nonaliasing stack, the path back to 4BD5 retains one copy.
	; An ordinary later exit consumes it as PC; a later abort discards it.
	; For ordinary action B=0..2, row C=0..5, that first PC is in ROM0.
	; Controlled $D2 replay observed 4DB9 -> ROM0:0000 -> 24:4206 for BC=0.
	; Other BC values remain conditional; this run is outside the natural union.
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
	ld [wKbdSlideDeltaRow], a
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
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	call PageList_InitScreen
	call VBlank_Wait
	pop bc
	push bc
	call PageList_GetActionAvailability
	call PageList_SetActionIcons
	farcall Sprites_RestoreSlotsFromBank3
	farcall Sprite_UpdateAll
	pop bc
	jp PageList_ActionMenu_Loop

.return_abort ; 24:4D25
	; With no retained inactive-path word, POP AF discards the CALL4203 return
	; (4206): RET exits PageList_Main too. browser_pagelist records 4D38->06FF.
	; After one inactive path, POP AF instead discards its extra BC and RET
	; returns to 4206, conditional on balanced callees and stable stack state.
	; [CONFIRMED] 225 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	pop bc
	pop af
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	ld a, $FF
	ld de, $0000
	ld hl, $0000
	ret
.handle_input ; 24:4D39
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyHeld]
	call nz, PageList_ActionMenuInputReturnOnly ; never taken: ldh sets no flags, Z is the one the farcall left (naming2_verify_fn4.md)
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, .check_b_button
	ld a, b
	cp a, $01
	jr nz, .check_delete_action
	call PageList_SaveCurrentPage
	farcall SramCheck_Bank1Commit
	jr .check_write_result
.check_delete_action ; 24:4D5E
	cp a, $02
	jr nz, .go_to_slot
	call PageList_DeleteSlot
	farcall SramCheck_Bank1Commit
.check_write_result ; 24:4D6B
	inc a
	jp z, .return_to_list
	inc a
	jp z, PageList_ActionMenu_Loop
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	jp PageList_ActionMenu_Loop
.return_to_list ; 24:4D8A
	call PageList_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret
.go_to_slot ; 24:4D97
	call PageList_GoToSlot
	inc a
	jp z, .return_go_success
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	ld a, $FF
	jp PageList_ActionMenu_Loop
.return_go_success ; 24:4DB7
	ld a, $FF
	ret
.check_b_button ; 24:4DBA
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .check_left_button
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	call PageList_HideActionCursor
	push bc
	farcall Joypad_Update
	pop bc
	xor a, a
	ret
.check_left_button ; 24:4DE1
	ldh a, [hJoyPressedRepeat]
	and a, PADF_LEFT
	jr z, .check_right_button
	push bc
	push de
	di
	play_sfx SFX_CURSOR_MOVE
	ei
	pop de
	pop bc
	ld d, b
	dec b
	ld a, $FF
	cp a, b
	jr nz, .redraw_after_left
	ld b, $02
.redraw_after_left ; 24:4E06
	ld a, d
	call PageList_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d
.check_right_button ; 24:4E12
	ldh a, [hJoyPressedRepeat]
	and a, PADF_RIGHT
	jr z, .next_frame
	push bc
	push de
	di
	play_sfx SFX_CURSOR_MOVE
	ei
	pop de
	pop bc
	ld d, b
	inc b
	ld a, $03
	cp a, b
	jr nz, .redraw_after_right
	ld b, $00
.redraw_after_right ; 24:4E37
	ld a, d
	call PageList_MoveActionCursor
	ld a, b
	ld d, b
	ld b, $00
	call PageList_ShowMessage
	ld b, d
.next_frame ; 24:4E43
	jp PageList_ActionMenu_Loop

PageList_ActionMenuInit:: ; 24:4E46
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry16
	ld a, BANK(PageList_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $16
	ld [wSpriteSlot0 + $01], a
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
	ld [wSpriteSlot0 + $01], a
	farcall Sprite_UpdateAll
	pop bc
	ret

PageList_SetActionCursor:: ; 24:4E85
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	cp a, b
	jr nz, .check_save_action
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry16
	ld a, BANK(PageList_ObjTable_Entry16)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $16
	ld [wSpriteSlot0 + $01], a
	pop bc
	ret
.check_save_action ; 24:4EAD
	ld a, $01
	cp a, b
	jr nz, .check_delete_action
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry20
	ld a, BANK(PageList_ObjTable_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $46
	ld [wSpriteSlot0 + $01], a
	pop bc
	ret
.check_delete_action ; 24:4ECE
	ld a, $02
	cp a, b
	jr nz, .return_invalid_action
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry24
	ld a, BANK(PageList_ObjTable_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $76
	ld [wSpriteSlot0 + $01], a
	pop bc
	ret

.return_invalid_action ; 24:4EEF
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	pop bc
	ret

PageList_MoveActionCursor:: ; 24:4EF1
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 8 scenarios]
	push bc
	jr c, .l4F04
	pop bc
	call PageList_SetActionCursor
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	ret

.l4F04 ; 24:4F04
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	pop bc
	call PageList_SetActionCursor
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop bc
	ret

PageList_SaveCurrentPage:: ; 24:4F14
	; [CONFIRMED] 171 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wBrowserPageUrl
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
	jp z, .start_save
	push bc
	push de
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlot2 + $01]
	ld c, a
	ld a, $C0
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot2 + $01], a
	ld [wSpriteSlot1 + $01], a
	ld a, [wSpriteSlot0]
	ld b, a
	ld a, $C0
	ld [wSpriteSlot0], a
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
	jr z, .start_save
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry20
	ld a, BANK(PageList_ObjTable_Entry20)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $46
	ld [wSpriteSlot0 + $01], a
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
.start_save ; 24:4FF6
	push bc
	push de
	call PageList_UpdateRowSprites
	play_sfx SFX_SAVE
	pop de
	pop bc
	pop de
	pop bc
	push de
	push bc
	ld a, c
	cp a, $00
	jr nz, .check_row_1
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [wSpriteSlot6], a
	ld a, $06
	ld [wSpriteSlot6 + $01], a
	jp .wait_save_animation
.check_row_1 ; 24:5039
	cp a, $01
	jr nz, .check_row_2
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [wSpriteSlot5], a
	ld a, $06
	ld [wSpriteSlot5 + $01], a
	jp .wait_save_animation
.check_row_2 ; 24:5060
	cp a, $02
	jr nz, .check_row_3

	; [CONFIRMED] Ordinary-input synthetic mGBA replay jp_browser_fixed_replay_e138
	; executes this row-index-2 save-animation setup at 24:5064-5084.
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3B
	ld [wSpriteSlot4], a
	ld a, $06
	ld [wSpriteSlot4 + $01], a
	jp .wait_save_animation

.check_row_3 ; 24:5087
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $03
	jr nz, .check_row_4
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $47
	ld [wSpriteSlot3], a
	ld a, $06
	ld [wSpriteSlot3 + $01], a
	jp .wait_save_animation

.check_row_4 ; 24:50AE
	; [PROBABLE] 30 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	cp a, $04
	jr nz, .check_row_5
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $53
	ld [wSpriteSlot2], a
	ld a, $06
	ld [wSpriteSlot2 + $01], a
	jp .wait_save_animation
.check_row_5 ; 24:50D5
	cp a, $05
	jr nz, .wait_save_animation
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable_Entry28
	ld a, BANK(PageList_ObjTable_Entry28)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $5F
	ld [wSpriteSlot1], a
	ld a, $06
	ld [wSpriteSlot1 + $01], a
	jp .wait_save_animation

.wait_save_animation ; 24:50FC
	; [CONFIRMED] 45 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 2 scenarios]
	pop bc
	ld e, $32
.save_animation_frame ; 24:50FF
	push bc
	push de
	farcall Sprite_UpdateAll
	call VBlank_Wait
	pop de
	pop bc
	dec e
	jr nz, .save_animation_frame
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
.copy_url_slot ; 24:512C
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_url_slot
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
	ld hl, wBrowserPageTitle
	ld a, [hl]
	cp a, $00
	jr nz, .prepare_title_copy

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	ld hl, wBrowserPageUrl

.prepare_title_copy ; 24:514C
	; [CONFIRMED] 242 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 1 scenarios]
	ld c, $16
.copy_title_slot ; 24:514E
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_title_slot
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
	ld hl, wBrowserPageUrl
	ld a, [hl]
	cp a, $00
	jr nz, .enable_sram
.enable_sram ; 24:5173
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
	play_sfx SFX_CONFIRM
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
	ld a, [wSpriteSlot2 + $01]
	ld c, a
	ld a, $C0
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot2 + $01], a
	ld [wSpriteSlot1 + $01], a
	ld a, [wSpriteSlot0]
	ld b, a
	ld a, $C0
	ld [wSpriteSlot0], a
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
	jr z, .start_delete
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wSpriteSlot0
	ld de, PageList_ObjTable_Entry24
	ld a, BANK(PageList_ObjTable_Entry24)
	ld b, $81
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $6F
	ld [wSpriteSlot0], a
	ld a, $76
	ld [wSpriteSlot0 + $01], a
	pop bc
	push bc
	call PageList_UpdateRowSprites
	pop bc
	xor a, a
	ldh [hJoyPressed], a
	ld a, $FE
	ret
.start_delete ; 24:52A3
	push bc
	push de
	play_sfx SFX_DELETE
	call PageList_UpdateRowSprites
	pop de
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr nz, .check_row_1
	ld hl, wSpriteSlot6
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $23
	ld [wSpriteSlot6], a
	ld a, $06
	ld [wSpriteSlot6 + $01], a
	jp .wait_delete_animation
.check_row_1 ; 24:52E3
	cp a, $01
	jr nz, .check_row_2
	ld hl, wSpriteSlot5
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $2F
	ld [wSpriteSlot5], a
	ld a, $06
	ld [wSpriteSlot5 + $01], a
	jp .wait_delete_animation

.check_row_2 ; 24:530A
	; [PROBABLE] 60 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	cp a, $02
	jr nz, .check_row_3
	ld hl, wSpriteSlot4
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $3B
	ld [wSpriteSlot4], a
	ld a, $06
	ld [wSpriteSlot4 + $01], a
	jp .wait_delete_animation
.check_row_3 ; 24:5331
	cp a, $03
	jr nz, .check_row_4
	ld hl, wSpriteSlot3
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $47
	ld [wSpriteSlot3], a
	ld a, $06
	ld [wSpriteSlot3 + $01], a
	jp .wait_delete_animation
.check_row_4 ; 24:5358
	cp a, $04
	jr nz, .check_row_5
	ld hl, wSpriteSlot2
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $53
	ld [wSpriteSlot2], a
	ld a, $06
	ld [wSpriteSlot2 + $01], a
	jp .wait_delete_animation
.check_row_5 ; 24:537F
	cp a, $05
	jr nz, .wait_delete_animation
	ld hl, wSpriteSlot1
	ld de, PageList_ObjTable_Entry32
	ld a, BANK(PageList_ObjTable_Entry32)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $5F
	ld [wSpriteSlot1], a
	ld a, $06
	ld [wSpriteSlot1 + $01], a
	jp .wait_delete_animation

.wait_delete_animation ; 24:53A6
	; [CONFIRMED] 55 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 3 scenarios]
	pop bc
	ld e, $32
.wait_delete_sprite_frames ; 24:53A9
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

PageList_ActionMenuInputReturnOnly:: ; 24:53FC

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BCD-53FE by apply_coverage --split
	ret

PageList_ActionMenuPostInitReturnOnly:: ; 24:53FD

	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4BCD-53FE by apply_coverage
	; --split [executed in 8 scenarios]
	ret

; ---- zero $53FE-$5400 (2 bytes) [PROBABLE] 0x00 padding between code and the tile block at $5400
	ds $2, $00
