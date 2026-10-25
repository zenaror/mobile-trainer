; engine/address_book/list.asm
; bank 2F, $4000-$4D40 (3392 bytes); pinned by layout.link
; address book list screen, slot helpers, help strings

SECTION "engine/address_book/list", ROMX

AbookList_Run:: ; 2F:4000

	; [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	call VBlank_WaitAndService
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0A
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call VBlank_Wait
	call AbookList_SetupScreen
	pop bc
	pop af
	cp a, $00
	jp z, AbookList_Run_Loop

	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jpcc at 2F:402F (executed) [executed in 1 scenarios]
	push bc
	push de
	call Abook_ProbeSlot
	cp a, $00
	jr z, .empty_slot_help_attr
	ld a, $02
	jr .apply_help_attr
.empty_slot_help_attr ; 2F:403F
	ld a, $01
.apply_help_attr ; 2F:4041
	call AbookList_SetHelpBoxAttr
	pop de
	pop bc
	jp AbookList_Run_ButtonRow

AbookList_Run_Loop:: ; 2F:4049
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_A
	jr z, AbookList_Run_CheckButtonB
	push bc
	push de
	call Abook_ProbeSlot
	cp a, $00
	jr z, .empty_slot_help_attr

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:4067 (executed) | upgraded by classifier 6: all 2 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $02
	jr .apply_help_attr

.empty_slot_help_attr ; 2F:406D
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)
	ld a, $01
.apply_help_attr ; 2F:406F
	call AbookList_SetHelpBoxAttr
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, c
	ld [hl], a
	ld b, $00
	jp AbookList_Run_ButtonRow

; ---- data $4094-$4097 (3 bytes) [HYPOTHESIS] $C3,$00,$40 decodes as JP AbookList_Run ($4000), but the preceding path already jumps to AbookList_Run_ButtonRow and no direct entry to $4094 is known; code versus stub remains unresolved

Data_AbookList_CandidateJpRun_4094:: ; 2F:4094
	db $C3, $00, $40

AbookList_Run_CheckButtonB:: ; 2F:4097
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressed]
	and a, PADF_B
	jr z, .check_vertical_input

	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0;
	; fall-through of the jrcc at 2F:409B (executed) [executed in 2 scenarios]
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, c
	ld [hl], a
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

.check_vertical_input ; 2F:40D0
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, PADF_UP
	call nz, AbookList_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, PADF_DOWN
	call nz, AbookList_CursorDown
	jp AbookList_Run_Loop

AbookList_CursorDown:: ; 2F:40E1
	; [CONFIRMED] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by callcc from 2F:40DB (executed) [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	inc c
	ld a, c
	cp a, $06
	jr nz, .refresh_down_highlight
	ld c, $00
.refresh_down_highlight ; 2F:40FE
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

AbookList_CursorUp:: ; 2F:4109

	; [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld d, c
	dec c
	ld a, c
	cp a, $FF
	jr nz, .refresh_up_highlight
	ld c, $05
.refresh_up_highlight ; 2F:4126
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

AbookList_Run_ButtonRow:: ; 2F:4131
	push bc
	ld hl, wSpriteSlot8
	ld de, AddrBookShared_ObjTable
	ld a, BANK(AddrBookShared_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call AbookList_PlaceButtonCursor
	push bc
	ld a, b
	cp a, $00
	jr z, .position_button0_sprite

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2F:414A (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 414C-4158 by apply_coverage --split [executed in 1 scenarios]
	cp a, $01
	jr z, .position_button1_sprite
	cp a, $02
	jr z, .position_button2_sprite

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 414C-4158 by apply_coverage --split
	cp a, $03
	jr z, .position_button3_sprite

.position_button0_sprite ; 2F:4158
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	ld de, $7018
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	jr .draw_button_help

.position_button1_sprite ; 2F:4163
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 2F:414E (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE
	; region 4163-4184 by apply_coverage --split [executed in 1 scenarios]
	ld de, $7038
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	jr .draw_button_help
.position_button2_sprite ; 2F:416E
	ld de, $7058
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	jr .draw_button_help

.position_button3_sprite ; 2F:4179
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4163-4184 by apply_coverage --split
	ld de, $7078
	ld hl, wSpriteSlot8
	call Sprite_SetPosition
	jr .draw_button_help

.draw_button_help ; 2F:4184
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	pop bc
	push bc
	pop bc
	call AbookList_PlaceButtonCursor
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
.service_button_row_input ; 2F:4196
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_B
	jp z, .check_confirm_input

	; [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 0;
	; fall-through of the jpcc at 2F:41AB (executed) | upgraded by classifier 6: all 26 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlot8], a
	ld [wSpriteSlot0], a
	push bc
	push bc
	push de
	xor a, a
	call AbookList_SetHelpBoxAttr
	play_sfx SFX_CANCEL
	pop de
	pop bc
	ld d, $FF
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	jp AbookList_Run_Loop

.check_confirm_input ; 2F:41E4
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressed]
	and a, PADF_A
	jp z, .check_left_input
	ld a, b
	cp a, $03
	jp nz, .check_edit_button

	; [CONFIRMED] 121 insn(s) reached by static flow only; seeds: exec x121; min discovery hops 0;
	; fall-through of the jpcc at 2F:41EE (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .show_delete_dialog
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	jr .service_button_row_input
.show_delete_dialog ; 2F:420E
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlot0], a
	ld [wSpriteSlot8], a
	ld hl, wSpriteSlot4
	call Sprite_ClearSlot
	ld [wSpriteSlot4 + $01], a
	ld [wSpriteSlot3 + $01], a
	ld [wSpriteSlot2 + $01], a
	ld de, $020D
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
	push bc
	push af
	dec a
	jr z, .check_delete_result
	ld a, $80
	ldh [hJoyPressed], a
	call AbookList_UpdateRowMarkers
	ld b, $03
	call AbookList_PlaceButtonCursor
.check_delete_result ; 2F:4286
	pop af
	pop bc
	dec a
	jp nz, .service_button_row_input
	push bc
	call Abook_ClearSlot
	push bc
	push de
	play_sfx SFX_DELETE
	pop de
	pop bc
	xor a, a
	call AbookList_SetHelpBoxAttr
	pop bc
	push bc
	call AbookList_DrawNames
	pop bc
	push bc
	ld d, $FF
	call AbookList_DrawHelpText
	pop bc
	push bc
	ld a, $00
	call AbookList_UpdateRowHighlight
	farcall AddrBook_UploadTextTiles
	pop bc
	ld a, $80
	ldh [hJoyPressed], a
	call AbookList_UpdateRowMarkers
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlot8], a
	ld [wSpriteSlot0], a
	jp AbookList_Run_Loop

.check_edit_button ; 2F:42DA
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	cp a, $02
	jr nz, .check_new_button

	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0;
	; fall-through of the jrcc at 2F:42DC (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .prepare_edit_return
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	jp .service_button_row_input
.prepare_edit_return ; 2F:42FC
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wMailSessionBlock], a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hl], a
	jp .fade_out_and_return_button

.check_new_button ; 2F:432E
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	cp a, $00
	jr nz, .check_view_slot
	call Abook_ProbeSlot
	cp a, $00
	jr z, .prepare_new_entry

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2F:4337 (executed) [executed in 2 scenarios]
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	jp .service_button_row_input

.prepare_new_entry ; 2F:4350
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	call Abook_Clear16AtHlAndEditAddressBuf
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wMailSessionBlock], a
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hl], a
	jr .fade_out_and_return_button

.check_view_slot ; 2F:4383
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by jrcc from 2F:4330 (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .prepare_view_return
	push bc
	push de
	play_sfx SFX_REJECT
	pop de
	pop bc
	jp .service_button_row_input
.prepare_view_return ; 2F:43A1
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAbookListState
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hli], a
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc

.fade_out_and_return_button ; 2F:43C5
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, b
	ret
.check_left_input ; 2F:43D8
	ldh a, [hJoyPressedRepeat]
	and a, PADF_LEFT
	jp z, .check_right_input

	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0;
	; fall-through of the jpcc at 2F:43DC (executed) [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	dec b
	ld a, b
	cp a, $FF
	jr nz, .redraw_after_left
	ld b, $03
.redraw_after_left ; 2F:43FB
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

.check_right_input ; 2F:440A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, PADF_RIGHT
	jp z, .position_button_row_sprite

	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0;
	; fall-through of the jpcc at 2F:440E (executed) [executed in 1 scenarios]
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	inc b
	ld a, b
	cp a, $04
	jr nz, .redraw_after_right
	ld b, $00
.redraw_after_right ; 2F:442D
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

.position_button_row_sprite ; 2F:443C
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld e, b
	swap e
	sla e
	ld a, $18
	add a, e
	ld [wSpriteSlot8 + $01], a
	ld a, $70
	ld [wSpriteSlot8], a
	jp .service_button_row_input

Abook_ClearSlot:: ; 2F:4455
	; [CONFIRMED] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 2;
	; entered by call from 2F:428D (PROBABLE code) | upgraded by classifier 6: all 40 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	push af
	push bc
	ld b, $00
	sla c
	ld hl, Abook_SlotAddrTable0
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, $10
	ld de, $D514 ; raw: dead load, nothing dereferences DE here and `ld de, $0010` overwrites it
.clear_slot_first16 ; 2F:447F
	xor a, a
	ld [hli], a
	dec b
	jr nz, .clear_slot_first16
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0 ; raw: dead load, nothing dereferences DE here
.clear_slot_next64 ; 2F:448E
	xor a, a
	ld [hli], a
	dec b
	jr nz, .clear_slot_next64
	pop bc
	pop af
	ret

Abook_Clear16AtHlAndEditAddressBuf:: ; 2F:4496

	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $10
	ld de, $D514 ; raw: dead load, nothing dereferences DE here
.clear_16_at_hl ; 2F:44A3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .clear_16_at_hl
	ld b, $40
	ld hl, wEditAddressBuf
.clear_edit_address ; 2F:44AD
	xor a, a
	ld [hli], a
	dec b
	jr nz, .clear_edit_address
	pop bc
	pop af
	ret

Abook_ProbeSlot:: ; 2F:44B5
	push bc
	ld b, $00
	sla c
	ld hl, Abook_SlotAddrTable0
	add hl, bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld h, d
	ld l, e
	push hl
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0 ; raw: dead load, nothing dereferences DE here
	ld a, [hl]
	pop bc
	ret

; ---- words $44E6-$44F2 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with no ld hl,imm found; first entry read by executed code

Abook_SlotAddrTable0:: ; 2F:44E6
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_PlaceButtonCursor:: ; 2F:44F2

	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, b
	cp a, $00
	jr z, .place_button0_cursor

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2F:44F6 (executed) | upgraded by classifier 6: all 6 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $01
	jr z, .place_button1_cursor
	cp a, $02
	jr z, .place_button2_cursor
	cp a, $03
	jr z, .place_button3_cursor

.place_button0_cursor ; 2F:4504
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld hl, wSpriteSlot0
	ld de, Table_Abook_ButtonCursorAnims
	ld a, BANK(Table_Abook_ButtonCursorAnims)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7018
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	jr .restore_bc_and_return

.place_button1_cursor ; 2F:451F
	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 1;
	; entered by jrcc from 2F:44FA (PROBABLE code) | upgraded by classifier 6: all 27 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot0
	ld de, Table_Abook_ButtonCursorAnims_Entry4
	ld a, BANK(Table_Abook_ButtonCursorAnims_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7038
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	jr .restore_bc_and_return
.place_button2_cursor ; 2F:453A
	ld hl, wSpriteSlot0
	ld de, Table_Abook_ButtonCursorAnims_Entry8
	ld a, BANK(Table_Abook_ButtonCursorAnims_Entry8)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7058
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	jr .restore_bc_and_return
.place_button3_cursor ; 2F:4555
	ld hl, wSpriteSlot0
	ld de, Table_Abook_ButtonCursorAnims_Entry12
	ld a, BANK(Table_Abook_ButtonCursorAnims_Entry12)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7078
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	jr .restore_bc_and_return

.restore_bc_and_return ; 2F:4570
	; [CONFIRMED] 115 insn(s); 115 executed (in up to 2/18 scenarios)
	pop bc
	ret

AbookList_SetupScreen:: ; 2F:4572
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	ld de, $8F00
	ld hl, Gfx_AddrBook_Tiles8F00
	ld a, BANK(Gfx_AddrBook_Tiles8F00)
	ld b, $98
	ld c, $09
	farcall Gfx_StartHDMA
	ld de, $9301
	ld hl, Gfx_AddrBook_TilesBank22
	ld a, BANK(Gfx_AddrBook_TilesBank22)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, Gfx_AddrBook_TilesBank22 + $400 ; 22:60D0
	ld a, BANK(Gfx_AddrBook_TilesBank22)
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_AddrBookShared_Tiles8000
	ld a, BANK(Gfx_AddrBookShared_Tiles8000)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $8400
	ld hl, Gfx_AddrBookShared_Tiles8400
	ld a, BANK(Gfx_AddrBookShared_Tiles8400)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_Abook_List
	ld a, BANK(Tilemap_Abook_List)
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_AddrBook_Obj
	ld a, BANK(Palette_AddrBook_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_AbookList_Bg
	ld a, BANK(Palette_AbookList_Bg)
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call AbookList_DrawNames
	ld d, $FF
	call AbookList_DrawHelpText
	pop bc
	push bc
	ld a, $00
	call AbookList_UpdateRowHighlight
	ld bc, $0000
	pop bc
	ld a, $80
	ldh [hJoyPressed], a
	call AbookList_UpdateRowMarkers
	push bc
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
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
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
	ret

AbookList_UpdateRowMarkers:: ; 2F:4678
	push bc
	inc c
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push bc
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .base_marker0_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:469A (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.base_marker0_ready ; 2F:46AC
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .base_marker1_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:46C6 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.base_marker1_ready ; 2F:46D8
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .base_marker2_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:46F2 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.base_marker2_ready ; 2F:4704
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .base_marker3_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:471E (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.base_marker3_ready ; 2F:4730
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .base_marker4_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:474A (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.base_marker4_ready ; 2F:475C
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry4
	ld a, BANK(AddrBookShared_ObjTable_Entry4)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .dispatch_selected_marker

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4776 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry8
	ld a, BANK(AddrBookShared_ObjTable_Entry8)
	ld b, $01
	farcall Sprite_InitSlot

.dispatch_selected_marker ; 2F:4788
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios)
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, .position_row_markers
	dec a
	jp z, .select_slot0_marker
	dec a
	jp z, .select_slot1_marker
	dec a
	jp z, .select_slot2_marker
	dec a
	jp z, .select_slot3_marker
	dec a
	jp z, .select_slot4_marker
	dec a
	jp z, .select_slot5_marker
.select_slot0_marker ; 2F:47A8
	push bc
	ld hl, wSpriteSlot7
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker0_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:47C1 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot7
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot

.selected_marker0_ready ; 2F:47D3
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	pop bc
	jp .position_row_markers

.select_slot1_marker ; 2F:47D7
	; [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1;
	; entered by jpcc from 2F:4795 (executed) | upgraded by classifier 6: all 76 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	push bc
	ld hl, wSpriteSlot6
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker1_ready
	ld hl, wSpriteSlot6
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.selected_marker1_ready ; 2F:4802
	pop bc
	jp .position_row_markers
.select_slot2_marker ; 2F:4806
	push bc
	ld hl, wSpriteSlot5
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker2_ready
	ld hl, wSpriteSlot5
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.selected_marker2_ready ; 2F:4831
	pop bc
	jp .position_row_markers
.select_slot3_marker ; 2F:4835
	push bc
	ld hl, wSpriteSlot4
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker3_ready
	ld hl, wSpriteSlot4
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.selected_marker3_ready ; 2F:4860
	pop bc
	jp .position_row_markers
.select_slot4_marker ; 2F:4864
	push bc
	ld hl, wSpriteSlot3
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker4_ready
	ld hl, wSpriteSlot3
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.selected_marker4_ready ; 2F:488F
	pop bc
	jp .position_row_markers

.select_slot5_marker ; 2F:4893
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	push bc
	ld hl, wSpriteSlot2
	ld de, Table_AddrSlotIcon_Anims_Entry12
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .selected_marker5_ready

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:48AC (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot2
	ld de, Table_AddrSlotIcon_Anims_Entry16
	ld a, BANK(Table_AddrSlotIcon_Anims_Entry16)
	ld b, $01
	farcall Sprite_InitSlot

.selected_marker5_ready ; 2F:48BE
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)
	pop bc
	jp .position_row_markers
.position_row_markers ; 2F:48C2
	ld a, $20
	ld [wSpriteSlot7], a
	ld a, $10
	ld [wSpriteSlot7 + $01], a
	ld a, $2C
	ld [wSpriteSlot6], a
	ld a, $10
	ld [wSpriteSlot6 + $01], a
	ld a, $38
	ld [wSpriteSlot5], a
	ld a, $10
	ld [wSpriteSlot5 + $01], a
	ld a, $44
	ld [wSpriteSlot4], a
	ld a, $10
	ld [wSpriteSlot4 + $01], a
	ld a, $50
	ld [wSpriteSlot3], a
	ld a, $10
	ld [wSpriteSlot3 + $01], a
	ld a, $5C
	ld [wSpriteSlot2], a
	ld a, $10
	ld [wSpriteSlot2 + $01], a
	pop bc
	ldh a, [hJoyPressed]
	and a, PADF_UP | PADF_DOWN
	call nz, AbookList_FlashSelectedMarker
	ret

Abook_TestSlotEmpty:: ; 2F:4907
	push bc
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ld e, a
	sla e
	ld d, $00
	ld hl, Abook_SlotAddrTable1
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $0010
	add hl, de
	ld a, [hl]
	cp a, $00
	jr z, .return_empty

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2F:492C (executed) | upgraded by classifier 6: all 3 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $00
	pop bc
	ret

.return_empty ; 2F:4932
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, $FF
	pop bc
	ret

; ---- words $4936-$4942 (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Abook_SlotAddrTable1:: ; 2F:4936
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_FlashSelectedMarker:: ; 2F:4942

	; [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, c
	cp a, $00
	jp z, .init_slot0_flash
	cp a, $01
	jp z, .init_slot1_flash
	cp a, $02
	jp z, .init_slot2_flash
	cp a, $03
	jp z, .init_slot3_flash
	cp a, $04
	jp z, .init_slot4_flash
	cp a, $05
	jp z, .init_slot5_flash
.init_slot0_flash ; 2F:4962
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot0_marker

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4978 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot7
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot

.position_slot0_marker ; 2F:498A
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	ld a, $20
	ld [wSpriteSlot7], a
	ld a, $10
	ld [wSpriteSlot7 + $01], a
	jp .begin_frame_wait

.init_slot1_flash ; 2F:4997
	; [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1;
	; entered by jpcc from 2F:494B (executed) | upgraded by classifier 6: all 76 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot1_marker
	ld hl, wSpriteSlot6
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.position_slot1_marker ; 2F:49BF
	ld a, $2C
	ld [wSpriteSlot6], a
	ld a, $10
	ld [wSpriteSlot6 + $01], a
	jp .begin_frame_wait
.init_slot2_flash ; 2F:49CC
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot2_marker
	ld hl, wSpriteSlot5
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.position_slot2_marker ; 2F:49F4
	ld a, $38
	ld [wSpriteSlot5], a
	ld a, $10
	ld [wSpriteSlot5 + $01], a
	jp .begin_frame_wait
.init_slot3_flash ; 2F:4A01
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot3_marker
	ld hl, wSpriteSlot4
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.position_slot3_marker ; 2F:4A29
	ld a, $44
	ld [wSpriteSlot4], a
	ld a, $10
	ld [wSpriteSlot4 + $01], a
	jp .begin_frame_wait
.init_slot4_flash ; 2F:4A36
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot4_marker
	ld hl, wSpriteSlot3
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot
.position_slot4_marker ; 2F:4A5E
	ld a, $50
	ld [wSpriteSlot3], a
	ld a, $10
	ld [wSpriteSlot3 + $01], a
	jp .begin_frame_wait

.init_slot5_flash ; 2F:4A6B
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry12
	ld a, BANK(AddrBookShared_ObjTable_Entry12)
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .position_slot5_marker

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4A81 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, wSpriteSlot2
	ld de, AddrBookShared_ObjTable_Entry16
	ld a, BANK(AddrBookShared_ObjTable_Entry16)
	ld b, $01
	farcall Sprite_InitSlot

.position_slot5_marker ; 2F:4A93
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)
	ld a, $5C
	ld [wSpriteSlot2], a
	ld a, $10
	ld [wSpriteSlot2 + $01], a
	jp .begin_frame_wait
.begin_frame_wait ; 2F:4AA0
	ld b, $1E
	ld b, $01
.update_sprites_and_poll_direction ; 2F:4AA4
	push bc
	farcall Sprite_UpdateAll
	farcall Joypad_Update
	call VBlank_Wait
	pop bc
	ldh a, [hJoyHeld]
	and a, PADF_UP | PADF_DOWN
	jr nz, .restore_bc_and_return
	dec b
	jr nz, .update_sprites_and_poll_direction
.restore_bc_and_return ; 2F:4ABE
	pop bc
	ret

AbookList_UpdateRowHighlight:: ; 2F:4AC0
	push af
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	push bc
	cp a, $FF
	jr z, .check_current_slot
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Abook_SlotAddrTable2
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0030
	ld b, a
	xor a, a
	inc b
.previous_slot_offset_loop ; 2F:4AEC
	dec b
	jr z, .draw_previous_slot_name

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:4AED (executed) | upgraded by classifier 6: all 2 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	add a, $0C
	jr .previous_slot_offset_loop

.draw_previous_slot_name ; 2F:4AF3
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios)
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	jr .check_current_slot
.check_current_slot ; 2F:4B01
	ld a, c
	cp a, $FF
	jr z, .upload_name_tiles
	push bc
	ld e, c
	sla e
	ld d, $00
	ld hl, Abook_SlotAddrTable2
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop bc
	push hl
	ld de, $0030
	ld b, c
	xor a, a
	inc b
.current_slot_offset_loop ; 2F:4B1D
	dec b
	jr z, .draw_current_slot_name
	add a, $0C
	jr .current_slot_offset_loop
.draw_current_slot_name ; 2F:4B24
	ld d, a
	ld b, $00
	ld c, $01
	farcall AddrBook_DrawSlotName
	pop hl
	jr .upload_name_tiles
.upload_name_tiles ; 2F:4B32
	farcall AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- words $4B42-$4B4E (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with first/last entries read by executed code (address label at 2F:4B42/4B4C CONFIRMED)

Abook_SlotAddrTable2:: ; 2F:4B42
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_DrawNames:: ; 2F:4B4E

	; [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
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
.slot_loop ; 2F:4B62
	push af
	push de
	push bc
	push af
	ld e, a
	sla e
	ld d, $00
	ld hl, Abook_SlotAddrTable3
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	pop af
	ld de, $0030
	ld b, a
	xor a, a
	inc b
.slot_offset_loop ; 2F:4B7B
	dec b
	jr z, .draw_slot_name
	add a, $0C
	jr .slot_offset_loop
.draw_slot_name ; 2F:4B82
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .slot_loop
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- words $4B9E-$4BAA (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Abook_SlotAddrTable3:: ; 2F:4B9E
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_DrawHelpText:: ; 2F:4BAA

	; [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	inc d
	ld e, d
	ld d, $00
	sla e
	ld hl, Table_Abook_HelpStrings
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $2F
	ld bc, wTileStage2 + $B40
	ld de, wTileStage2 + $C80
	farcall TextTiles_RenderLine
	pop de
	pop bc
	ret

; ---- ptrtable $4BD0-$4BDA (10 bytes) [PROBABLE] 5 pointers, every target is the first byte of one of the 5 NUL-terminated Shift-JIS strings beginning at String_Abook_HelpSelect; first four bytes were read as data by executed code (address label at 2F:4BD0 CONFIRMED); no ld hl,imm found

Table_Abook_HelpStrings:: ; 2F:4BD0
	dw String_Abook_HelpSelect
	dw String_Abook_HelpNew
	dw String_Abook_HelpView
	dw String_Abook_HelpEdit
	dw String_Abook_HelpDelete

; ---- text $4BDA-$4CA7 (205 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
PUSHC sjis
String_Abook_HelpSelect:: ; 2F:4BDA
	db "　　Ｃｈｏｏｓｅ　ａ　ｃｏｎｔａｃｔ　　", 0
String_Abook_HelpNew:: ; 2F:4C03
	db "　Ｃｒｅａｔｅ　ｎｅｗ　ｃｏｎｔａｃｔ　", 0
String_Abook_HelpView:: ; 2F:4C2C
	db "　Ｖｉｅｗ　ｔｈｉｓ　ｃｏｎｔａｃｔ　　", 0
String_Abook_HelpEdit:: ; 2F:4C55
	db "　Ｅｄｉｔ　ｔｈｉｓ　ｃｏｎｔａｃｔ　　", 0
String_Abook_HelpDelete:: ; 2F:4C7E
	db "Ｄｅｌｅｔｅ　ｔｈｉｓ　ｃｏｎｔａｃｔ　", 0
POPC




POPC

AbookList_SetHelpBoxAttr:: ; 2F:4CA7

	; [CONFIRMED] 58 insn(s); 58 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	push hl
	sla a
	ld c, a
	ld b, $00
	ld hl, Table_Abook_HelpBoxAttrs
	add hl, bc
	ld a, [hli]
	ld c, a
	ld h, [hl]
	ld l, c
	push hl
	ld de, $99C0
	ld c, $14
	ld a, $01
	ldh [rVBK], a
.wait_ly_90 ; 2F:4CC1
	ldh a, [rLY]
	cp a, $90
	jr nz, .wait_ly_90
.copy_vram_help_row0 ; 2F:4CC7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_vram_help_row0
	pop hl
	push hl
	ld de, $99E0
	ld c, $14
.copy_vram_help_row1 ; 2F:4CD4
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_vram_help_row1
	pop hl
	push hl
	ld de, wScreenAttrMap + $1C0
	ld c, $14
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.copy_wram_help_row0 ; 2F:4CE7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_wram_help_row0
	pop hl
	ld de, wScreenAttrMap + $1E0
	ld c, $14
.copy_wram_help_row1 ; 2F:4CF3
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .copy_wram_help_row1
	pop hl
	pop de
	pop bc
	ret

; ---- ptrtable $4CFD-$4D03 (6 bytes) [PROBABLE] 3 pointers to the 20-byte attribute blocks 4D03/4D17/4D2B; read by 2F:4CAF (sla a; ld c,a; ld hl,$4CFD; add hl,bc; ld a,[hli]; ld c,a; ld h,[hl])

Table_Abook_HelpBoxAttrs:: ; 2F:4CFD
	dw Data_Abook_HelpBoxAttrBlocks
	dw $4D17
	dw $4D2B

; ---- data $4D03-$4D3F (60 bytes) [PROBABLE] 3 blocks of 20 BG attribute bytes ($09/$0B/$0C/$29) copied 20 bytes per row by the loader at 2F:4CAF; blocks addressed through Table_Abook_HelpBoxAttrs

Data_Abook_HelpBoxAttrBlocks:: ; 2F:4D03
	db $09, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $29, $09, $09, $09, $0C, $0C, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $0B, $0B, $09, $09, $29, $09, $09, $09, $0B, $0B, $09, $09, $0C
	db $0C, $09, $09, $0C, $0C, $09, $09, $0C, $0C, $09, $09, $29

; ---- zero $4D3F-$4D40 (1 bytes) [PROBABLE] 1 zero byte of padding before the map block at 2F:4D40
	ds $1, $00
