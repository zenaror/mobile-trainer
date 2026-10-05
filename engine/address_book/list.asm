; engine/address_book/list.asm
; bank 2F, $4000-$4D40 (3392 bytes); pinned by layout.link
; address book list screen, slot helpers, help strings

SECTION "engine/address_book/list", ROMX

AbookList_Run:: ; 2F:4000
Function_2F_4000::
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
	jr z, .l403F
	ld a, $02
	jr .l4041
.l403F ; 2F:403F
	ld a, $01
.l4041 ; 2F:4041
	call AbookList_SetHelpBoxAttr
	pop de
	pop bc
	jp Label_2F_4131

AbookList_Run_Loop:: ; 2F:4049
Label_2F_4049::
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_2F_4097
	push bc
	push de
	call Abook_ProbeSlot
	cp a, $00
	jr z, .l406D

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:4067 (executed) | upgraded by classifier 6: all 2 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $02
	jr .l406F

.l406D ; 2F:406D
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)
	ld a, $01
.l406F ; 2F:406F
	call AbookList_SetHelpBoxAttr
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, c
	ld [hl], a
	ld b, $00
	jp Label_2F_4131

; ---- data $4094-$4097 (3 bytes) [HYPOTHESIS] UNCLASSIFIED 3 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_2F_4094:: ; 2F:4094
	db $C3, $00, $40

Label_2F_4097:: ; 2F:4097
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l40D0

	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0;
	; fall-through of the jrcc at 2F:409B (executed) [executed in 2 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, c
	ld [hl], a
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

.l40D0 ; 2F:40D0
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, AbookList_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, AbookList_CursorDown
	jp AbookList_Run_Loop

AbookList_CursorDown:: ; 2F:40E1
	; [CONFIRMED] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by callcc from 2F:40DB (executed) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	inc c
	ld a, c
	cp a, $06
	jr nz, .skip
	ld c, $00
.skip ; 2F:40FE
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

AbookList_CursorUp:: ; 2F:4109
Function_2F_4109::
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, c
	dec c
	ld a, c
	cp a, $FF
	jr nz, .skip
	ld c, $05
.skip ; 2F:4126
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

Label_2F_4131:: ; 2F:4131
	push bc
	ld hl, $DA80
	ld de, AddrBookShared_ObjTable
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	pop bc
	call AbookList_PlaceButtonCursor
	push bc
	ld a, b
	cp a, $00
	jr z, .l4158

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2F:414A (executed) | 4 insn(s) executed; cut out of the PROBABLE
	; region 414C-4158 by apply_coverage --split [executed in 1 scenarios]
	cp a, $01
	jr z, .l4163
	cp a, $02
	jr z, .l416E

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 414C-4158 by apply_coverage --split
	cp a, $03
	jr z, .l4179

.l4158 ; 2F:4158
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)
	ld de, $7018
	ld hl, $DA80
	call Sprite_SetPosition
	jr .l4184

.l4163 ; 2F:4163
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 2F:414E (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE
	; region 4163-4184 by apply_coverage --split [executed in 1 scenarios]
	ld de, $7038
	ld hl, $DA80
	call Sprite_SetPosition
	jr .l4184
.l416E ; 2F:416E
	ld de, $7058
	ld hl, $DA80
	call Sprite_SetPosition
	jr .l4184

.l4179 ; 2F:4179
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4163-4184 by apply_coverage --split
	ld de, $7078
	ld hl, $DA80
	call Sprite_SetPosition
	jr .l4184

.l4184 ; 2F:4184
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
.loop ; 2F:4196
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jp z, .l41E4

	; [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 0;
	; fall-through of the jpcc at 2F:41AB (executed) | upgraded by classifier 6: all 26 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $E0
	ld [wSpriteSlots + 128], a
	ld [wSpriteSlots], a
	push bc
	push bc
	push de
	xor a, a
	call AbookList_SetHelpBoxAttr
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, $FF
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	jp AbookList_Run_Loop

.l41E4 ; 2F:41E4
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $01
	jp z, .l43D8
	ld a, b
	cp a, $03
	jp nz, .l42DA

	; [CONFIRMED] 121 insn(s) reached by static flow only; seeds: exec x121; min discovery hops 0;
	; fall-through of the jpcc at 2F:41EE (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .l420E
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	jr .loop
.l420E ; 2F:420E
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlots], a
	ld [wSpriteSlots + 128], a
	ld hl, $DA40
	call Sprite_ClearSlot
	ld [wSpriteSlots + 65], a
	ld [wSpriteSlots + 49], a
	ld [wSpriteSlots + 33], a
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
	jr z, .l4286
	ld a, $80
	ldh [hJoyPressed], a
	call AbookList_UpdateRowMarkers
	ld b, $03
	call AbookList_PlaceButtonCursor
.l4286 ; 2F:4286
	pop af
	pop bc
	dec a
	jp nz, .loop
	push bc
	call Abook_ClearSlot
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0033
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
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
	ld [wSpriteSlots + 128], a
	ld [wSpriteSlots], a
	jp AbookList_Run_Loop

.l42DA ; 2F:42DA
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	cp a, $02
	jr nz, .l432E

	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0;
	; fall-through of the jrcc at 2F:42DC (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .l42FC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	jp .loop
.l42FC ; 2F:42FC
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
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
	ld hl, $D726
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hl], a
	jp .l43C5

.l432E ; 2F:432E
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	cp a, $00
	jr nz, .l4383
	call Abook_ProbeSlot
	cp a, $00
	jr z, .l4350

	; [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0;
	; fall-through of the jrcc at 2F:4337 (executed) [executed in 2 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	jp .loop

.l4350 ; 2F:4350
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)
	call Abook_Clear16AtHlAndEditAddressBuf
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wMailSessionBlock], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hl], a
	jr .l43C5

.l4383 ; 2F:4383
	; [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by jrcc from 2F:4330 (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, .l43A1
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	jp .loop
.l43A1 ; 2F:43A1
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, c
	ld [hli], a
	ld a, $01
	ld [hli], a
	ld a, b
	ld [hli], a
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

.l43C5 ; 2F:43C5
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	push bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, b
	ret
.l43D8 ; 2F:43D8
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jp z, .l440A

	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0;
	; fall-through of the jpcc at 2F:43DC (executed) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec b
	ld a, b
	cp a, $FF
	jr nz, .l43FB
	ld b, $03
.l43FB ; 2F:43FB
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

.l440A ; 2F:440A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jp z, .l443C

	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0;
	; fall-through of the jpcc at 2F:440E (executed) [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc b
	ld a, b
	cp a, $04
	jr nz, .l442D
	ld b, $00
.l442D ; 2F:442D
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

.l443C ; 2F:443C
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld e, b
	swap e
	sla e
	ld a, $18
	add a, e
	ld [wSpriteSlots + 129], a
	ld a, $70
	ld [wSpriteSlots + 128], a
	jp .loop

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
	ld de, $D514
.l447F ; 2F:447F
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l447F
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0
.l448E ; 2F:448E
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l448E
	pop bc
	pop af
	ret

Abook_Clear16AtHlAndEditAddressBuf:: ; 2F:4496
Function_2F_4496::
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $10
	ld de, $D514
.l44A3 ; 2F:44A3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l44A3
	ld b, $40
	ld hl, $D4C0
.l44AD ; 2F:44AD
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l44AD
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
	ld de, $D4C0
	ld a, [hl]
	pop bc
	ret

; ---- words $44E6-$44F2 (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with no ld hl,imm found; first entry read by executed code

Abook_SlotAddrTable0:: ; 2F:44E6
Table_2F_44E6::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_PlaceButtonCursor:: ; 2F:44F2
Function_2F_44F2::
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, b
	cp a, $00
	jr z, .l4504

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0;
	; fall-through of the jrcc at 2F:44F6 (executed) | upgraded by classifier 6: all 6 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $01
	jr z, .l451F
	cp a, $02
	jr z, .l453A
	cp a, $03
	jr z, .l4555

.l4504 ; 2F:4504
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld hl, $DA00
	ld de, Table_Abook_ButtonCursorAnims
	ld a, $2F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7018
	ld hl, $DA00
	call Sprite_SetPosition
	jr .l4570

.l451F ; 2F:451F
	; [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 1;
	; entered by jrcc from 2F:44FA (PROBABLE code) | upgraded by classifier 6: all 27 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA00
	ld de, $5020
	ld a, $2F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7038
	ld hl, $DA00
	call Sprite_SetPosition
	jr .l4570
.l453A ; 2F:453A
	ld hl, $DA00
	ld de, $5030
	ld a, $2F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7058
	ld hl, $DA00
	call Sprite_SetPosition
	jr .l4570
.l4555 ; 2F:4555
	ld hl, $DA00
	ld de, $5040
	ld a, $2F
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $7078
	ld hl, $DA00
	call Sprite_SetPosition
	jr .l4570

.l4570 ; 2F:4570
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
	ld a, $2C
	ld b, $98
	ld c, $09
	farcall Gfx_StartHDMA
	ld de, $9301
	ld hl, $5CD0
	ld a, $22
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $9701
	ld hl, $60D0
	ld a, $22
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMA
	ld de, $8000
	ld hl, Gfx_AddrBookShared_Tiles8000
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMA
	ld de, $8400
	ld hl, Gfx_AddrBookShared_Tiles8400
	ld a, $28
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMA
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_Abook_List
	ld a, $2F
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBook_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_AbookList_Bg
	ld a, $28
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
	ld hl, $DA70
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .l46AC

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:469A (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l46AC ; 2F:46AC
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, $DA60
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .l46D8

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:46C6 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA60
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l46D8 ; 2F:46D8
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, $DA50
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4704

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:46F2 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA50
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l4704 ; 2F:4704
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, $DA40
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4730

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:471E (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA40
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l4730 ; 2F:4730
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, $DA30
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .l475C

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:474A (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA30
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l475C ; 2F:475C
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)
	pop bc
	push bc
	ld hl, $DA20
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4788

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4776 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l4788 ; 2F:4788
	; [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios)
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, .l48C2
	dec a
	jp z, .l47A8
	dec a
	jp z, .l47D7
	dec a
	jp z, .l4806
	dec a
	jp z, .l4835
	dec a
	jp z, .l4864
	dec a
	jp z, .l4893
.l47A8 ; 2F:47A8
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .l47D3

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:47C1 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot

.l47D3 ; 2F:47D3
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	pop bc
	jp .l48C2

.l47D7 ; 2F:47D7
	; [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1;
	; entered by jpcc from 2F:4795 (executed) | upgraded by classifier 6: all 76 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4802
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l4802 ; 2F:4802
	pop bc
	jp .l48C2
.l4806 ; 2F:4806
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4831
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l4831 ; 2F:4831
	pop bc
	jp .l48C2
.l4835 ; 2F:4835
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4860
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l4860 ; 2F:4860
	pop bc
	jp .l48C2
.l4864 ; 2F:4864
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .l488F
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
.l488F ; 2F:488F
	pop bc
	jp .l48C2

.l4893 ; 2F:4893
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .l48BE

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:48AC (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Sprite_InitSlot

.l48BE ; 2F:48BE
	; [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)
	pop bc
	jp .l48C2
.l48C2 ; 2F:48C2
	ld a, $20
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	ld a, $2C
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	ld a, $38
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	ld a, $44
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	ld a, $50
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	ld a, $5C
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	pop bc
	ldh a, [hJoyPressed]
	and a, $C0
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
	jr z, .l4932

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 2F:492C (executed) | upgraded by classifier 6: all 3 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $00
	pop bc
	ret

.l4932 ; 2F:4932
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	ld a, $FF
	pop bc
	ret

; ---- words $4936-$4942 (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Abook_SlotAddrTable1:: ; 2F:4936
Table_2F_4936::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_FlashSelectedMarker:: ; 2F:4942
Function_2F_4942::
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	ld a, c
	cp a, $00
	jp z, .l4962
	cp a, $01
	jp z, .l4997
	cp a, $02
	jp z, .l49CC
	cp a, $03
	jp z, .l4A01
	cp a, $04
	jp z, .l4A36
	cp a, $05
	jp z, .l4A6B
.l4962 ; 2F:4962
	ld hl, $DA70
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, .l498A

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4978 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l498A ; 2F:498A
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)
	ld a, $20
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	jp .l4AA0

.l4997 ; 2F:4997
	; [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1;
	; entered by jpcc from 2F:494B (executed) | upgraded by classifier 6: all 76 instruction starts
	; of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA60
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, .l49BF
	ld hl, $DA60
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l49BF ; 2F:49BF
	ld a, $2C
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	jp .l4AA0
.l49CC ; 2F:49CC
	ld hl, $DA50
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, .l49F4
	ld hl, $DA50
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l49F4 ; 2F:49F4
	ld a, $38
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	jp .l4AA0
.l4A01 ; 2F:4A01
	ld hl, $DA40
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4A29
	ld hl, $DA40
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l4A29 ; 2F:4A29
	ld a, $44
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	jp .l4AA0
.l4A36 ; 2F:4A36
	ld hl, $DA30
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4A5E
	ld hl, $DA30
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
.l4A5E ; 2F:4A5E
	ld a, $50
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	jp .l4AA0

.l4A6B ; 2F:4A6B
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)
	ld hl, $DA20
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, .l4A93

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 2F:4A81 (executed) | upgraded by classifier 6: all 5 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Sprite_InitSlot

.l4A93 ; 2F:4A93
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)
	ld a, $5C
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	jp .l4AA0
.l4AA0 ; 2F:4AA0
	ld b, $1E
	ld b, $01
.loop ; 2F:4AA4
	push bc
	farcall Sprite_UpdateAll
	farcall Joypad_Update
	call VBlank_Wait
	pop bc
	ldh a, [hJoyHeld]
	and a, $C0
	jr nz, .l4ABE
	dec b
	jr nz, .loop
.l4ABE ; 2F:4ABE
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
	jr z, .l4B01
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
.l4AEC ; 2F:4AEC
	dec b
	jr z, .l4AF3

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 2F:4AED (executed) | upgraded by classifier 6: all 2 instruction
	; starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	add a, $0C
	jr .l4AEC

.l4AF3 ; 2F:4AF3
	; [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios)
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	jr .l4B01
.l4B01 ; 2F:4B01
	ld a, c
	cp a, $FF
	jr z, .l4B32
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
.l4B1D ; 2F:4B1D
	dec b
	jr z, .l4B24
	add a, $0C
	jr .l4B1D
.l4B24 ; 2F:4B24
	ld d, a
	ld b, $00
	ld c, $01
	farcall AddrBook_DrawSlotName
	pop hl
	jr .l4B32
.l4B32 ; 2F:4B32
	farcall AddrBook_UploadTextTiles
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- words $4B42-$4B4E (12 bytes) [PROBABLE] 6 SRAM record addresses $A69D..$A82D, constant stride $50 (80), verified arithmetic progression; indexed table read with first/last entries read by executed code (Data_2F_4B42/4B4C CONFIRMED)

Abook_SlotAddrTable2:: ; 2F:4B42
Table_2F_4B42::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_DrawNames:: ; 2F:4B4E
Function_2F_4B4E::
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
.l4B62 ; 2F:4B62
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
.l4B7B ; 2F:4B7B
	dec b
	jr z, .l4B82
	add a, $0C
	jr .l4B7B
.l4B82 ; 2F:4B82
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, .l4B62
	pop bc
	push af
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop af
	ret

; ---- words $4B9E-$4BAA (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Abook_SlotAddrTable3:: ; 2F:4B9E
Table_2F_4B9E::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

AbookList_DrawHelpText:: ; 2F:4BAA
Function_2F_4BAA::
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
	ld bc, $DB40
	ld de, $DC80
	farcall TextTiles_RenderLine
	pop de
	pop bc
	ret

; ---- ptrtable $4BD0-$4BDA (10 bytes) [PROBABLE] 5 pointers, every target is the first byte of one of the 5 NUL-terminated Shift-JIS strings of String_2F_4BDA; first four bytes were read as data by executed code (Data_2F_4BD0 CONFIRMED); no ld hl,imm found

Table_Abook_HelpStrings:: ; 2F:4BD0
Table_2F_4BD0::
	dw String_Abook_HelpSelect
	dw String_Abook_HelpNew
	dw String_Abook_HelpView
	dw String_Abook_HelpEdit
	dw String_Abook_HelpDelete

; ---- text $4BDA-$4CA7 (205 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_Abook_HelpSelect:: ; 2F:4BDA
String_2F_4BDA::
	db "　　アドレスを　せんたくしてください　　", 0

String_Abook_HelpNew:: ; 2F:4C03
	db "　あたらしく　アドレスをかきこみます　　", 0

String_Abook_HelpView:: ; 2F:4C2C
	db "　このアドレスを　みることができます　　", 0

String_Abook_HelpEdit:: ; 2F:4C55
	db "　　　このアドレスを　なおします　　　　", 0

String_Abook_HelpDelete:: ; 2F:4C7E
	db "　　　　このアドレスを　けします　　　　", 0
POPC

AbookList_SetHelpBoxAttr:: ; 2F:4CA7
Function_2F_4CA7::
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
.l4CC1 ; 2F:4CC1
	ldh a, [rLY]
	cp a, $90
	jr nz, .l4CC1
.l4CC7 ; 2F:4CC7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l4CC7
	pop hl
	push hl
	ld de, $99E0
	ld c, $14
.l4CD4 ; 2F:4CD4
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l4CD4
	pop hl
	push hl
	ld de, $D5C0
	ld c, $14
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
.l4CE7 ; 2F:4CE7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l4CE7
	pop hl
	ld de, $D5E0
	ld c, $14
.l4CF3 ; 2F:4CF3
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, .l4CF3
	pop hl
	pop de
	pop bc
	ret

; ---- ptrtable $4CFD-$4D03 (6 bytes) [PROBABLE] 3 pointers to the 20-byte attribute blocks 4D03/4D17/4D2B; read by 2F:4CAF (sla a; ld c,a; ld hl,$4CFD; add hl,bc; ld a,[hli]; ld c,a; ld h,[hl])

Table_Abook_HelpBoxAttrs:: ; 2F:4CFD
Table_2F_4CFD::
	dw Data_Abook_HelpBoxAttrBlocks
	dw $4D17
	dw $4D2B

; ---- data $4D03-$4D3F (60 bytes) [PROBABLE] 3 blocks of 20 BG attribute bytes ($09/$0B/$0C/$29) copied 20 bytes per row by the loader at 2F:4CAF; blocks addressed through Table_2F_4CFD

Data_Abook_HelpBoxAttrBlocks:: ; 2F:4D03
Data_2F_4D03::
	db $09, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $29, $09, $09, $09, $0C, $0C, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $0B, $0B, $09, $09, $29, $09, $09, $09, $0B, $0B, $09, $09, $0C
	db $0C, $09, $09, $0C, $0C, $09, $09, $0C, $0C, $09, $09, $29

; ---- zero $4D3F-$4D40 (1 bytes) [PROBABLE] 1 zero byte of padding before the map block at 2F:4D40
	ds $1, $00
