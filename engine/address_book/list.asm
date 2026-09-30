; engine/address_book/list.asm
; bank 2F, $4000-$4D40 (3392 bytes); pinned by layout.link
; address book list screen, slot helpers, help strings

SECTION "engine/address_book/list", ROMX

; ---- code $4000-$4032 (50 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

AbookList_Run:: ; 2F:4000
Function_2F_4000::
	push af
	push bc
	call Function_00_044B
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $10
	ld [wStatSplitLine], a
	ld a, $0A
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call Function_00_0464
	call AbookList_SetupScreen
	pop bc
	pop af
	cp a, $00
	jp z, Label_2F_4049

; ---- code $4032-$4049 (23 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jpcc at 2F:402F (executed) [executed in 1 scenarios]
	push bc
	push de
	call Abook_ProbeSlot
	cp a, $00
	jr z, Label_2F_403F
	ld a, $02
	jr Label_2F_4041

Label_2F_403F:: ; 2F:403F
	ld a, $01

Label_2F_4041:: ; 2F:4041
	call AbookList_SetHelpBoxAttr
	pop de
	pop bc
	jp Label_2F_4131

; ---- code $4049-$4069 (32 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_4049:: ; 2F:4049
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_2F_4097
	push bc
	push de
	call Abook_ProbeSlot
	cp a, $00
	jr z, Label_2F_406D

; ---- code $4069-$406D (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2F:4067 (executed) | upgraded by classifier 6: all 2 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $02
	jr Label_2F_406F

; ---- code $406D-$4094 (39 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 1/18 scenarios)

Label_2F_406D:: ; 2F:406D
	ld a, $01

Label_2F_406F:: ; 2F:406F
	call AbookList_SetHelpBoxAttr
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

; ---- code $4097-$409D (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2F_4097:: ; 2F:4097
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_2F_40D0

; ---- code $409D-$40D0 (51 bytes) [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 0; fall-through of the jrcc at 2F:409B (executed) [executed in 2 scenarios]
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
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D726
	ld a, c
	ld [hl], a
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, $FF
	ret

; ---- code $40D0-$40E1 (17 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)

Label_2F_40D0:: ; 2F:40D0
	ldh a, [hJoyPressedRepeat]
	and a, $40
	call nz, AbookList_CursorUp
	ldh a, [hJoyPressedRepeat]
	and a, $80
	call nz, AbookList_CursorDown
	jp Label_2F_4049

; ---- code $40E1-$4109 (40 bytes) [CONFIRMED] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1; entered by callcc from 2F:40DB (executed) [executed in 1 scenarios]

AbookList_CursorDown:: ; 2F:40E1
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
	ld a, c
	cp a, $06
	jr nz, Label_2F_40FE
	ld c, $00

Label_2F_40FE:: ; 2F:40FE
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

; ---- code $4109-$414C (67 bytes) [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookList_CursorUp:: ; 2F:4109
Function_2F_4109::
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
	ld a, c
	cp a, $FF
	jr nz, Label_2F_4126
	ld c, $05

Label_2F_4126:: ; 2F:4126
	ld a, d
	farcall AbookList_UpdateRowHighlight
	call AbookList_UpdateRowMarkers
	ret

Label_2F_4131:: ; 2F:4131
	push bc
	ld hl, $DA80
	ld de, Table_28_5210
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call AbookList_PlaceButtonCursor
	push bc
	ld a, b
	cp a, $00
	jr z, Label_2F_4158

; ---- code $414C-$4154 (8 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2F:414A (executed) | 4 insn(s) executed; cut out of the PROBABLE region 414C-4158 by apply_coverage --split [executed in 1 scenarios]
	cp a, $01
	jr z, Label_2F_4163
	cp a, $02
	jr z, Label_2F_416E

; ---- code $4154-$4158 (4 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 414C-4158 by apply_coverage --split
	cp a, $03
	jr z, Label_2F_4179

; ---- code $4158-$4163 (11 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios)

Label_2F_4158:: ; 2F:4158
	ld de, $7018
	ld hl, $DA80
	call Function_00_0A65
	jr Label_2F_4184

; ---- code $4163-$4179 (22 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by jrcc from 2F:414E (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE region 4163-4184 by apply_coverage --split [executed in 1 scenarios]

Label_2F_4163:: ; 2F:4163
	ld de, $7038
	ld hl, $DA80
	call Function_00_0A65
	jr Label_2F_4184

Label_2F_416E:: ; 2F:416E
	ld de, $7058
	ld hl, $DA80
	call Function_00_0A65
	jr Label_2F_4184

; ---- code $4179-$4184 (11 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4163-4184 by apply_coverage --split

Label_2F_4179:: ; 2F:4179
	ld de, $7078
	ld hl, $DA80
	call Function_00_0A65
	jr Label_2F_4184

; ---- code $4184-$41AE (42 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)

Label_2F_4184:: ; 2F:4184
	pop bc
	push bc
	pop bc
	call AbookList_PlaceButtonCursor
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc

Label_2F_4196:: ; 2F:4196
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $02
	jp z, Label_2F_41E4

; ---- code $41AE-$41E4 (54 bytes) [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 0; fall-through of the jpcc at 2F:41AB (executed) | upgraded by classifier 6: all 26 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
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
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld d, $FF
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	jp Label_2F_4049

; ---- code $41E4-$41F1 (13 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_2F_41E4:: ; 2F:41E4
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2F_43D8
	ld a, b
	cp a, $03
	jp nz, Label_2F_42DA

; ---- code $41F1-$42DA (233 bytes) [CONFIRMED] 121 insn(s) reached by static flow only; seeds: exec x121; min discovery hops 0; fall-through of the jpcc at 2F:41EE (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, Label_2F_420E
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
	jr Label_2F_4196

Label_2F_420E:: ; 2F:420E
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
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $D0
	ld [wSpriteSlots], a
	ld [wSpriteSlots + 128], a
	ld hl, $DA40
	call Function_00_09E6
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
	jr z, Label_2F_4286
	ld a, $80
	ldh [hJoyPressed], a
	call AbookList_UpdateRowMarkers
	ld b, $03
	call AbookList_PlaceButtonCursor

Label_2F_4286:: ; 2F:4286
	pop af
	pop bc
	dec a
	jp nz, Label_2F_4196
	push bc
	call Abook_ClearSlot
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
	jp Label_2F_4049

; ---- code $42DA-$42DE (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2F_42DA:: ; 2F:42DA
	cp a, $02
	jr nz, Label_2F_432E

; ---- code $42DE-$432E (80 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0; fall-through of the jrcc at 2F:42DC (executed) [executed in 1 scenarios]
	call Abook_ProbeSlot
	cp a, $00
	jr nz, Label_2F_42FC
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
	jp Label_2F_4196

Label_2F_42FC:: ; 2F:42FC
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
	jp Label_2F_43C5

; ---- code $432E-$4339 (11 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)

Label_2F_432E:: ; 2F:432E
	cp a, $00
	jr nz, Label_2F_4383
	call Abook_ProbeSlot
	cp a, $00
	jr z, Label_2F_4350

; ---- code $4339-$4350 (23 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 2F:4337 (executed) [executed in 2 scenarios]
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
	jp Label_2F_4196

; ---- code $4350-$4383 (51 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 1/18 scenarios)

Label_2F_4350:: ; 2F:4350
	call Function_2F_4496
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
	call Function_00_20AC
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
	jr Label_2F_43C5

; ---- code $4383-$43C5 (66 bytes) [CONFIRMED] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1; entered by jrcc from 2F:4330 (executed) [executed in 1 scenarios]

Label_2F_4383:: ; 2F:4383
	call Abook_ProbeSlot
	cp a, $00
	jr nz, Label_2F_43A1
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
	jp Label_2F_4196

Label_2F_43A1:: ; 2F:43A1
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
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

; ---- code $43C5-$43DF (26 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_2F_43C5:: ; 2F:43C5
	push bc
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	ld a, b
	ret

Label_2F_43D8:: ; 2F:43D8
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jp z, Label_2F_440A

; ---- code $43DF-$440A (43 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0; fall-through of the jpcc at 2F:43DC (executed) [executed in 1 scenarios]
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
	dec b
	ld a, b
	cp a, $FF
	jr nz, Label_2F_43FB
	ld b, $03

Label_2F_43FB:: ; 2F:43FB
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

; ---- code $440A-$4411 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_2F_440A:: ; 2F:440A
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jp z, Label_2F_443C

; ---- code $4411-$443C (43 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 0; fall-through of the jpcc at 2F:440E (executed) [executed in 1 scenarios]
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
	inc b
	ld a, b
	cp a, $04
	jr nz, Label_2F_442D
	ld b, $00

Label_2F_442D:: ; 2F:442D
	push bc
	ld d, b
	call AbookList_DrawHelpText
	farcall AddrBook_UploadTextTiles
	pop bc
	call AbookList_PlaceButtonCursor

; ---- code $443C-$4455 (25 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_2F_443C:: ; 2F:443C
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
	jp Label_2F_4196

; ---- code $4455-$4496 (65 bytes) [CONFIRMED] 40 insn(s) reached by static flow only; seeds: exec x40; min discovery hops 2; entered by call from 2F:428D (PROBABLE code) | upgraded by classifier 6: all 40 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Abook_ClearSlot:: ; 2F:4455
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

Label_2F_447F:: ; 2F:447F
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2F_447F
	pop hl
	ld de, $0010
	add hl, de
	ld b, $40
	ld de, $D4C0

Label_2F_448E:: ; 2F:448E
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2F_448E
	pop bc
	pop af
	ret

; ---- code $4496-$44E6 (80 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Function_2F_4496:: ; 2F:4496
	push af
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld b, $10
	ld de, $D514

Label_2F_44A3:: ; 2F:44A3
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2F_44A3
	ld b, $40
	ld hl, $D4C0

Label_2F_44AD:: ; 2F:44AD
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2F_44AD
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

; ---- code $44F2-$44F8 (6 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookList_PlaceButtonCursor:: ; 2F:44F2
Function_2F_44F2::
	push bc
	ld a, b
	cp a, $00
	jr z, Label_2F_4504

; ---- code $44F8-$4504 (12 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2F:44F6 (executed) | upgraded by classifier 6: all 6 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	cp a, $01
	jr z, Label_2F_451F
	cp a, $02
	jr z, Label_2F_453A
	cp a, $03
	jr z, Label_2F_4555

; ---- code $4504-$451F (27 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_2F_4504:: ; 2F:4504
	ld hl, $DA00
	ld de, Table_Abook_ButtonCursorAnims
	ld a, $2F
	ld b, $81
	farcall Function_00_0A82
	ld de, $7018
	ld hl, $DA00
	call Function_00_0A65
	jr Label_2F_4570

; ---- code $451F-$4570 (81 bytes) [CONFIRMED] 27 insn(s) reached by static flow only; seeds: exec x27; min discovery hops 1; entered by jrcc from 2F:44FA (PROBABLE code) | upgraded by classifier 6: all 27 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_2F_451F:: ; 2F:451F
	ld hl, $DA00
	ld de, $5020
	ld a, $2F
	ld b, $81
	farcall Function_00_0A82
	ld de, $7038
	ld hl, $DA00
	call Function_00_0A65
	jr Label_2F_4570

Label_2F_453A:: ; 2F:453A
	ld hl, $DA00
	ld de, $5030
	ld a, $2F
	ld b, $81
	farcall Function_00_0A82
	ld de, $7058
	ld hl, $DA00
	call Function_00_0A65
	jr Label_2F_4570

Label_2F_4555:: ; 2F:4555
	ld hl, $DA00
	ld de, $5040
	ld a, $2F
	ld b, $81
	farcall Function_00_0A82
	ld de, $7078
	ld hl, $DA00
	call Function_00_0A65
	jr Label_2F_4570

; ---- code $4570-$469C (300 bytes) [CONFIRMED] 115 insn(s); 115 executed (in up to 2/18 scenarios)

Label_2F_4570:: ; 2F:4570
	pop bc
	ret

AbookList_SetupScreen:: ; 2F:4572
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	ld de, $8F00
	ld hl, Gfx_AddrBook_Tiles8F00
	ld a, $2C
	ld b, $98
	ld c, $09
	farcall Function_00_0749
	ld de, $9301
	ld hl, $5CD0
	ld a, $22
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $9701
	ld hl, $60D0
	ld a, $22
	ld b, $97
	ld c, $10
	farcall Function_00_0749
	ld de, $8000
	ld hl, Data_28_4BD0
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $8400
	ld hl, Data_28_4FD0
	ld a, $28
	ld b, $95
	ld c, $20
	farcall Function_00_0749
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_Abook_List
	ld a, $2F
	farcall Function_00_08EA
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_AddrBook_Obj
	ld a, $2C
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_28_51D0
	ld a, $28
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Function_00_082C
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
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
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
	call Function_00_20E8
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
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_46AC

; ---- code $469C-$46AC (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:469A (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $46AC-$46C8 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_46AC:: ; 2F:46AC
	pop bc
	push bc
	ld hl, $DA60
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_46D8

; ---- code $46C8-$46D8 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:46C6 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA60
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $46D8-$46F4 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_46D8:: ; 2F:46D8
	pop bc
	push bc
	ld hl, $DA50
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4704

; ---- code $46F4-$4704 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:46F2 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA50
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $4704-$4720 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_4704:: ; 2F:4704
	pop bc
	push bc
	ld hl, $DA40
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4730

; ---- code $4720-$4730 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:471E (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA40
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $4730-$474C (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_4730:: ; 2F:4730
	pop bc
	push bc
	ld hl, $DA30
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_475C

; ---- code $474C-$475C (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:474A (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA30
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $475C-$4778 (28 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2F_475C:: ; 2F:475C
	pop bc
	push bc
	ld hl, $DA20
	ld de, $5220
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4788

; ---- code $4778-$4788 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:4776 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $5230
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $4788-$47C3 (59 bytes) [CONFIRMED] 29 insn(s); 29 executed (in up to 2/18 scenarios)

Label_2F_4788:: ; 2F:4788
	pop bc
	pop bc
	ld a, c
	cp a, $00
	jp z, Label_2F_48C2
	dec a
	jp z, Label_2F_47A8
	dec a
	jp z, Label_2F_47D7
	dec a
	jp z, Label_2F_4806
	dec a
	jp z, Label_2F_4835
	dec a
	jp z, Label_2F_4864
	dec a
	jp z, Label_2F_4893

Label_2F_47A8:: ; 2F:47A8
	push bc
	ld hl, $DA70
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_47D3

; ---- code $47C3-$47D3 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:47C1 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

; ---- code $47D3-$47D7 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)

Label_2F_47D3:: ; 2F:47D3
	pop bc
	jp Label_2F_48C2

; ---- code $47D7-$4893 (188 bytes) [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1; entered by jpcc from 2F:4795 (executed) | upgraded by classifier 6: all 76 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_2F_47D7:: ; 2F:47D7
	push bc
	ld hl, $DA60
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4802
	ld hl, $DA60
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2F_4802:: ; 2F:4802
	pop bc
	jp Label_2F_48C2

Label_2F_4806:: ; 2F:4806
	push bc
	ld hl, $DA50
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4831
	ld hl, $DA50
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2F_4831:: ; 2F:4831
	pop bc
	jp Label_2F_48C2

Label_2F_4835:: ; 2F:4835
	push bc
	ld hl, $DA40
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4860
	ld hl, $DA40
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2F_4860:: ; 2F:4860
	pop bc
	jp Label_2F_48C2

Label_2F_4864:: ; 2F:4864
	push bc
	ld hl, $DA30
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_488F
	ld hl, $DA30
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

Label_2F_488F:: ; 2F:488F
	pop bc
	jp Label_2F_48C2

; ---- code $4893-$48AE (27 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 1/18 scenarios)

Label_2F_4893:: ; 2F:4893
	push bc
	ld hl, $DA20
	ld de, $7240
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82
	pop bc
	push bc
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_48BE

; ---- code $48AE-$48BE (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:48AC (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $7250
	ld a, $2C
	ld b, $01
	farcall Function_00_0A82

; ---- code $48BE-$492E (112 bytes) [CONFIRMED] 54 insn(s); 54 executed (in up to 2/18 scenarios)

Label_2F_48BE:: ; 2F:48BE
	pop bc
	jp Label_2F_48C2

Label_2F_48C2:: ; 2F:48C2
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
	jr z, Label_2F_4932

; ---- code $492E-$4932 (4 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0; fall-through of the jrcc at 2F:492C (executed) | upgraded by classifier 6: all 3 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld a, $00
	pop bc
	ret

; ---- code $4932-$4936 (4 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2F_4932:: ; 2F:4932
	ld a, $FF
	pop bc
	ret

; ---- words $4936-$4942 (12 bytes) [CONFIRMED] 6 SRAM record addresses $A69D..$A82D, stride $50 (verified arithmetic progression); byte-identical to the tables of 2F:51B5 etc.; the region was already CONFIRMED as read by executed code

Abook_SlotAddrTable1:: ; 2F:4936
Table_2F_4936::
	dw $A69D, $A6ED, $A73D, $A78D, $A7DD, $A82D

; ---- code $4942-$497A (56 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

AbookList_FlashSelectedMarker:: ; 2F:4942
Function_2F_4942::
	push bc
	ld a, c
	cp a, $00
	jp z, Label_2F_4962
	cp a, $01
	jp z, Label_2F_4997
	cp a, $02
	jp z, Label_2F_49CC
	cp a, $03
	jp z, Label_2F_4A01
	cp a, $04
	jp z, Label_2F_4A36
	cp a, $05
	jp z, Label_2F_4A6B

Label_2F_4962:: ; 2F:4962
	ld hl, $DA70
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $00
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_498A

; ---- code $497A-$498A (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:4978 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA70
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $498A-$4997 (13 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)

Label_2F_498A:: ; 2F:498A
	ld a, $20
	ld [wSpriteSlots + 112], a
	ld a, $10
	ld [wSpriteSlots + 113], a
	jp Label_2F_4AA0

; ---- code $4997-$4A6B (212 bytes) [CONFIRMED] 76 insn(s) reached by static flow only; seeds: exec x76; min discovery hops 1; entered by jpcc from 2F:494B (executed) | upgraded by classifier 6: all 76 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)

Label_2F_4997:: ; 2F:4997
	ld hl, $DA60
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $01
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_49BF
	ld hl, $DA60
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2F_49BF:: ; 2F:49BF
	ld a, $2C
	ld [wSpriteSlots + 96], a
	ld a, $10
	ld [wSpriteSlots + 97], a
	jp Label_2F_4AA0

Label_2F_49CC:: ; 2F:49CC
	ld hl, $DA50
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $02
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_49F4
	ld hl, $DA50
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2F_49F4:: ; 2F:49F4
	ld a, $38
	ld [wSpriteSlots + 80], a
	ld a, $10
	ld [wSpriteSlots + 81], a
	jp Label_2F_4AA0

Label_2F_4A01:: ; 2F:4A01
	ld hl, $DA40
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $03
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4A29
	ld hl, $DA40
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2F_4A29:: ; 2F:4A29
	ld a, $44
	ld [wSpriteSlots + 64], a
	ld a, $10
	ld [wSpriteSlots + 65], a
	jp Label_2F_4AA0

Label_2F_4A36:: ; 2F:4A36
	ld hl, $DA30
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $04
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4A5E
	ld hl, $DA30
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

Label_2F_4A5E:: ; 2F:4A5E
	ld a, $50
	ld [wSpriteSlots + 48], a
	ld a, $10
	ld [wSpriteSlots + 49], a
	jp Label_2F_4AA0

; ---- code $4A6B-$4A83 (24 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 1/18 scenarios)

Label_2F_4A6B:: ; 2F:4A6B
	ld hl, $DA20
	ld de, $5240
	ld a, $28
	ld b, $01
	farcall Function_00_0A82
	ld a, $05
	call Abook_TestSlotEmpty
	inc a
	jr z, Label_2F_4A93

; ---- code $4A83-$4A93 (16 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2F:4A81 (executed) | upgraded by classifier 6: all 5 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	ld hl, $DA20
	ld de, $5250
	ld a, $28
	ld b, $01
	farcall Function_00_0A82

; ---- code $4A93-$4AEF (92 bytes) [CONFIRMED] 49 insn(s); 49 executed (in up to 2/18 scenarios)

Label_2F_4A93:: ; 2F:4A93
	ld a, $5C
	ld [wSpriteSlots + 32], a
	ld a, $10
	ld [wSpriteSlots + 33], a
	jp Label_2F_4AA0

Label_2F_4AA0:: ; 2F:4AA0
	ld b, $1E
	ld b, $01

Label_2F_4AA4:: ; 2F:4AA4
	push bc
	farcall Function_00_0956
	farcall Joypad_Update
	call Function_00_0464
	pop bc
	ldh a, [hJoyHeld]
	and a, $C0
	jr nz, Label_2F_4ABE
	dec b
	jr nz, Label_2F_4AA4

Label_2F_4ABE:: ; 2F:4ABE
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
	jr z, Label_2F_4B01
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

Label_2F_4AEC:: ; 2F:4AEC
	dec b
	jr z, Label_2F_4AF3

; ---- code $4AEF-$4AF3 (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2F:4AED (executed) | upgraded by classifier 6: all 2 instruction starts of the region are in analysis/coverage_union.tsv (executed in a trace)
	add a, $0C
	jr Label_2F_4AEC

; ---- code $4AF3-$4B42 (79 bytes) [CONFIRMED] 44 insn(s); 44 executed (in up to 2/18 scenarios)

Label_2F_4AF3:: ; 2F:4AF3
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	jr Label_2F_4B01

Label_2F_4B01:: ; 2F:4B01
	ld a, c
	cp a, $FF
	jr z, Label_2F_4B32
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

Label_2F_4B1D:: ; 2F:4B1D
	dec b
	jr z, Label_2F_4B24
	add a, $0C
	jr Label_2F_4B1D

Label_2F_4B24:: ; 2F:4B24
	ld d, a
	ld b, $00
	ld c, $01
	farcall AddrBook_DrawSlotName
	pop hl
	jr Label_2F_4B32

Label_2F_4B32:: ; 2F:4B32
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

; ---- code $4B4E-$4B9E (80 bytes) [CONFIRMED] 51 insn(s); 51 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

AbookList_DrawNames:: ; 2F:4B4E
Function_2F_4B4E::
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

Label_2F_4B62:: ; 2F:4B62
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

Label_2F_4B7B:: ; 2F:4B7B
	dec b
	jr z, Label_2F_4B82
	add a, $0C
	jr Label_2F_4B7B

Label_2F_4B82:: ; 2F:4B82
	ld d, a
	ld b, $03
	ld c, $00
	farcall AddrBook_DrawSlotName
	pop bc
	pop de
	pop af
	inc a
	dec d
	jr nz, Label_2F_4B62
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

; ---- code $4BAA-$4BD0 (38 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

AbookList_DrawHelpText:: ; 2F:4BAA
Function_2F_4BAA::
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
	ldh [hRam_FFB0], a
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

String_Abook_HelpSelect:: ; 2F:4BDA
String_2F_4BDA::
	db $81, $40, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $B9, $82, $F1, $82, $BD, $82, $AD, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3 ; "　　アドレスを　せんたくしてくださ"
	db $82, $A2, $81, $40, $81, $40, $00 ; "い　　"

String_Abook_HelpNew:: ; 2F:4C03
	db $81, $40, $82, $A0, $82, $BD, $82, $E7, $82, $B5, $82, $AD, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $82, $A9, $82, $AB, $82, $B1, $82, $DD, $82, $DC ; "　あたらしく　アドレスをかきこみま"
	db $82, $B7, $81, $40, $81, $40, $00 ; "す　　"

String_Abook_HelpView:: ; 2F:4C2C
	db $81, $40, $82, $B1, $82, $CC, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $DD, $82, $E9, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC ; "　このアドレスを　みることができま"
	db $82, $B7, $81, $40, $81, $40, $00 ; "す　　"

String_Abook_HelpEdit:: ; 2F:4C55
	db $81, $40, $81, $40, $81, $40, $82, $B1, $82, $CC, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $C8, $82, $A8, $82, $B5, $82, $DC, $82, $B7, $81, $40 ; "　　　このアドレスを　なおします　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

String_Abook_HelpDelete:: ; 2F:4C7E
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $B1, $82, $CC, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0, $81, $40, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $40 ; "　　　　このアドレスを　けします　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $4CA7-$4CFD (86 bytes) [CONFIRMED] 58 insn(s); 58 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

AbookList_SetHelpBoxAttr:: ; 2F:4CA7
Function_2F_4CA7::
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

Label_2F_4CC1:: ; 2F:4CC1
	ldh a, [rLY]
	cp a, $90
	jr nz, Label_2F_4CC1

Label_2F_4CC7:: ; 2F:4CC7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_2F_4CC7
	pop hl
	push hl
	ld de, $99E0
	ld c, $14

Label_2F_4CD4:: ; 2F:4CD4
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_2F_4CD4
	pop hl
	push hl
	ld de, $D5C0
	ld c, $14
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a

Label_2F_4CE7:: ; 2F:4CE7
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_2F_4CE7
	pop hl
	ld de, $D5E0
	ld c, $14

Label_2F_4CF3:: ; 2F:4CF3
	ld a, [hli]
	ld [de], a
	inc de
	dec c
	jr nz, Label_2F_4CF3
	pop hl
	pop de
	pop bc
	ret

; ---- ptrtable $4CFD-$4D03 (6 bytes) [PROBABLE] 3 pointers to the 20-byte attribute blocks 4D03/4D17/4D2B; read by 2F:4CAF (sla a; ld c,a; ld hl,$4CFD; add hl,bc; ld a,[hli]; ld c,a; ld h,[hl])

Table_Abook_HelpBoxAttrs:: ; 2F:4CFD
Table_2F_4CFD::
	dw Data_2F_4D03
	dw $4D17
	dw $4D2B

; ---- data $4D03-$4D3F (60 bytes) [PROBABLE] 3 blocks of 20 BG attribute bytes ($09/$0B/$0C/$29) copied 20 bytes per row by the loader at 2F:4CAF; blocks addressed through Table_2F_4CFD

Data_2F_4D03:: ; 2F:4D03
	db $09, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $29, $09, $09, $09, $0C, $0C, $09, $09, $0B, $0B, $09, $09, $0B
	db $0B, $09, $09, $0B, $0B, $09, $09, $29, $09, $09, $09, $0B, $0B, $09, $09, $0C
	db $0C, $09, $09, $0C, $0C, $09, $09, $0C, $0C, $09, $09, $29

; ---- zero $4D3F-$4D40 (1 bytes) [PROBABLE] 1 zero byte of padding before the map block at 2F:4D40
	ds $1, $00
