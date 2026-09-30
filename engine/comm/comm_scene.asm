; engine/comm/comm_scene.asm
; bank 70, $4000-$4822 (2082 bytes); pinned by layout.link
; scrolling panorama scene shown during homepage communication

SECTION "engine/comm/comm_scene", ROMX

; ---- code $4000-$401A (26 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_Init:: ; 70:4000
Function_70_4000::
	ld [wRam_C27D], a
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27E], a
	ld [wRam_C27F], a
	ld a, [wRam_C27D]
	or a, a
	jr z, Label_70_401F
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_70_401D

; ---- code $401A-$401D (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 70:4018 (executed)
	xor a, a
	jr Label_70_401F

; ---- code $401D-$4043 (38 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)

Label_70_401D:: ; 70:401D
	ld a, $01

Label_70_401F:: ; 70:401F
	ld [wRam_C283], a
	ret

CommScene_Step:: ; 70:4023
	ld [wRam_C27E], a
	ld a, $01
	ld [wRam_C27F], a
	farcall Joypad_Update
	call CommScene_RunState
	call CommScene_ApplyScrollFrame
	ld a, [wRam_C27D]
	or a, a
	jr z, Label_70_407B
	ld a, [wRam_C283]
	or a, a
	jr nz, Label_70_406A

; ---- code $4043-$404A (7 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 70:4041 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 4043-406A by apply_coverage --split [executed in 5 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_70_407B

; ---- code $404A-$406A (32 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4043-406A by apply_coverage --split
	ld hl, $DA30
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $83
	farcall Function_00_0A82
	ld de, $7000
	ld hl, $DA30
	call Function_00_0A65
	ld a, $01
	ld [wRam_C283], a
	jr Label_70_407B

; ---- code $406A-$4071 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_70_406A:: ; 70:406A
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_70_407B

; ---- code $4071-$407B (10 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 70:406F (executed) [executed in 4 scenarios]
	ld hl, $DA30
	call Function_00_09E6
	xor a, a
	ld [wRam_C283], a

; ---- code $407B-$40AD (50 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 1/18 scenarios)

Label_70_407B:: ; 70:407B
	ld a, [wRam_C27F]
	ret

CommScene_ApplyScrollFrame:: ; 70:407F
	call Function_00_0956
	call Function_00_0464
	ld hl, $C2A8
	ld a, [hli]
	ldh [rSCX], a
	call Function_00_0392
	ret

CommScene_RunState:: ; 70:408F
	ld a, [wRam_C27D]
	ld hl, CommScene_KindTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wRam_C27C]
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $40AD-$40B3 (6 bytes) [PROBABLE] little-endian word table, 27 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $40B3..$449D; referenced by ld r16,$40AD at 70:4092 [clipped from 40AD-40E3 by higher-priority evidence]

CommScene_KindTable:: ; 70:40AD
Table_70_40AD::
	dw Table_70_40B3
	dw Table_70_40C7
	dw $40D9

; ---- ptrtable $40B3-$40C1 (14 bytes) [CONFIRMED] code-pointer table, 7 entries: 7/7 words hit own-bank code starts (dense run of code pointers); 7/7 targets executed; every byte read as data in a trace

Table_70_40B3:: ; 70:40B3
	dw Label_70_40E3
	dw Label_70_411B
	dw Label_70_4121
	dw Label_70_4135
	dw Label_70_41BF
	dw Label_70_41E8
	dw Label_70_4202

; ---- ptrtable $40C1-$40C7 (6 bytes) [PROBABLE] little-endian word table, 27 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $40B3..$449D; referenced by ld r16,$40AD at 70:4092 [clipped from 40AD-40E3 by higher-priority evidence]

Table_70_40C1:: ; 70:40C1
	dw Label_70_4215
	dw Label_70_4235
	dw Label_70_425C

; ---- ptrtable $40C7-$40D3 (12 bytes) [CONFIRMED] code-pointer table, 6 entries: 6/6 words hit own-bank code starts (dense run of code pointers); 6/6 targets executed; every byte read as data in a trace

Table_70_40C7:: ; 70:40C7
	dw Label_70_428D
	dw Label_70_42C7
	dw Label_70_42CD
	dw Label_70_4357
	dw Label_70_4380
	dw Label_70_439A

; ---- ptrtable $40D3-$40E3 (16 bytes) [PROBABLE] little-endian word table, 27 entries, monotone=1.00, 0% of targets on string start/after NUL, targets $40B3..$449D; referenced by ld r16,$40AD at 70:4092 [clipped from 40AD-40E3 by higher-priority evidence]

Table_70_40D3:: ; 70:40D3
	dw Label_70_43AD
	dw Label_70_43D0
	dw Label_70_43FF
	dw Label_70_4418
	dw Label_70_4452
	dw Label_70_4458
	dw Label_70_4484
	dw Label_70_449D

; ---- code $40E3-$417E (155 bytes) [CONFIRMED] 64 insn(s); 64 executed (in up to 1/18 scenarios)

Label_70_40E3:: ; 70:40E3
	call CommScene_LoadGraphics
	xor a, a
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wRam_C27C], a
	xor a, a
	ld [wRam_C280], a
	ld a, $00
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ret

Label_70_411B:: ; 70:411B
	ld a, $02
	ld [wRam_C27C], a
	ret

Label_70_4121:: ; 70:4121
	ld a, [wRam_C280]
	inc a
	ld [wRam_C280], a
	cp a, $48
	jr nz, Label_70_4131
	ld a, $03
	ld [wRam_C27C], a

Label_70_4131:: ; 70:4131
	call CommScene_PlaceTextSprites
	ret

Label_70_4135:: ; 70:4135
	ld a, [wRam_C27E]
	cp a, $01
	jr z, Label_70_4144
	ldh a, [hJoyPressed]
	bit 1, a
	jr nz, Label_70_417E
	jr Label_70_41BB

Label_70_4144:: ; 70:4144
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $14
	ld [wRam_C282], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA60
	call Function_00_0A65
	ld a, $01
	call CommScene_ShowTextBox
	ld a, $04
	ld [wRam_C27C], a
	jr Label_70_41BB

; ---- code $417E-$41BB (61 bytes) [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1; entered by jrcc from 70:4140 (executed) [executed in 2 scenarios]

Label_70_417E:: ; 70:417E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wRam_C27F], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA60
	call Function_00_0A65
	ld a, $06
	call CommScene_ShowTextBox
	ld a, $14
	ld [wRam_C282], a
	ld a, $07
	ld [wRam_C27C], a

; ---- code $41BB-$4215 (90 bytes) [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios)

Label_70_41BB:: ; 70:41BB
	call CommScene_ScrollIncrement
	ret

Label_70_41BF:: ; 70:41BF
	ld a, [wRam_C282]
	dec a
	ld [wRam_C282], a
	or a, a
	jr nz, Label_70_41E4
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DA60
	call Function_00_09E6
	ld a, $05
	ld [wRam_C27C], a

Label_70_41E4:: ; 70:41E4
	call CommScene_ScrollIncrement
	ret

Label_70_41E8:: ; 70:41E8
	ld a, [wRam_C280]
	add a, $02
	ld [wRam_C280], a
	cp a, $A0
	jr nz, Label_70_41FB
	ld a, $06
	ld [wRam_C27C], a
	jr Label_70_41FB

Label_70_41FB:: ; 70:41FB
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_4202:: ; 70:4202
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wRam_C27C], a
	xor a, a
	ld [wRam_C27F], a
	ret

; ---- code $4215-$423F (42 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: table x44; min discovery hops 0; run starts at an entry of the code-pointer table at 70:40B3 | 19 insn(s) executed; cut out of the PROBABLE region 4215-4275 by apply_coverage --split [executed in 5 scenarios]

Label_70_4215:: ; 70:4215
	ld a, [wRam_C282]
	dec a
	ld [wRam_C282], a
	or a, a
	jr nz, Label_70_4231
	ld hl, $DA60
	call Function_00_09E6
	ld a, $01
	call CommScene_SetTextSprites
	ld a, $08
	ld [wRam_C27C], a
	jr Label_70_4231

Label_70_4231:: ; 70:4231
	call CommScene_PlaceTextSprites
	ret

Label_70_4235:: ; 70:4235
	ld a, [wRam_C27E]
	or a, a
	jr z, Label_70_4258
	cp a, $01
	jr z, Label_70_4241

; ---- code $423F-$4241 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4215-4275 by apply_coverage --split
	jr Label_70_4258

; ---- code $4241-$4275 (52 bytes) [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 4215-4275 by apply_coverage --split [executed in 4 scenarios]

Label_70_4241:: ; 70:4241
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $09
	ld [wRam_C27C], a
	jr Label_70_4258

Label_70_4258:: ; 70:4258
	call CommScene_ScrollDecrement
	ret

Label_70_425C:: ; 70:425C
	ld a, [wRam_C280]
	dec a
	ld [wRam_C280], a
	cp a, $E0
	jr nz, Label_70_426E
	ld a, $06
	ld [wRam_C27C], a
	jr Label_70_426E

Label_70_426E:: ; 70:426E
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

; ---- code $4275-$4285 (16 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_ResetScroll:: ; 70:4275
Function_70_4275::
	xor a, a
	ld [wRam_C2A8], a
	ld [wRam_C2A9], a
	ret

CommScene_ScrollIncrement:: ; 70:427D
	ld a, [wRam_C2A8]
	inc a
	ld [wRam_C2A8], a
	ret

; ---- code $4285-$428D (8 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: table x4; min discovery hops 2; entered by call from 70:4258 (PROBABLE code) [executed in 3 scenarios]

CommScene_ScrollDecrement:: ; 70:4285
	ld a, [wRam_C2A8]
	dec a
	ld [wRam_C2A8], a
	ret

; ---- code $428D-$4316 (137 bytes) [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios)

Label_70_428D:: ; 70:428D
	call CommScene_LoadGraphics
	ld a, $02
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wRam_C27C], a
	ld a, $48
	ld [wRam_C280], a
	ld a, $00
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ret

Label_70_42C7:: ; 70:42C7
	ld a, $02
	ld [wRam_C27C], a
	ret

Label_70_42CD:: ; 70:42CD
	ld a, [wRam_C27E]
	cp a, $01
	jr z, Label_70_42DC
	ldh a, [hJoyPressed]
	bit 1, a
	jr nz, Label_70_4316
	jr Label_70_4353

Label_70_42DC:: ; 70:42DC
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $14
	ld [wRam_C282], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA60
	call Function_00_0A65
	ld a, $03
	call CommScene_ShowTextBox
	ld a, $03
	ld [wRam_C27C], a
	jr Label_70_4353

; ---- code $4316-$4353 (61 bytes) [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1; entered by jrcc from 70:42D8 (executed) [executed in 2 scenarios]

Label_70_4316:: ; 70:4316
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wRam_C27F], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Function_00_0A82
	ld de, $3048
	ld hl, $DA60
	call Function_00_0A65
	ld a, $06
	call CommScene_ShowTextBox
	ld a, $14
	ld [wRam_C282], a
	ld a, $06
	ld [wRam_C27C], a

; ---- code $4353-$43AD (90 bytes) [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios)

Label_70_4353:: ; 70:4353
	call CommScene_ScrollIncrement
	ret

Label_70_4357:: ; 70:4357
	ld a, [wRam_C282]
	dec a
	ld [wRam_C282], a
	or a, a
	jr nz, Label_70_437C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld hl, $DA60
	call Function_00_09E6
	ld a, $04
	ld [wRam_C27C], a

Label_70_437C:: ; 70:437C
	call CommScene_ScrollIncrement
	ret

Label_70_4380:: ; 70:4380
	ld a, [wRam_C280]
	add a, $02
	ld [wRam_C280], a
	cp a, $A0
	jr nz, Label_70_4393
	ld a, $05
	ld [wRam_C27C], a
	jr Label_70_4393

Label_70_4393:: ; 70:4393
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_439A:: ; 70:439A
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wRam_C27C], a
	xor a, a
	ld [wRam_C27F], a
	ret

; ---- code $43AD-$43DA (45 bytes) [CONFIRMED] 112 insn(s) reached by static flow only; seeds: site x18, table x94; min discovery hops 0; run starts at an entry of the code-pointer table at 70:40B3 | 20 insn(s) executed; cut out of the PROBABLE region 43AD-44B0 by apply_coverage --split [executed in 2 scenarios]

Label_70_43AD:: ; 70:43AD
	ld a, [wRam_C282]
	dec a
	ld [wRam_C282], a
	or a, a
	jr nz, Label_70_43C9
	ld hl, $DA60
	call Function_00_09E6
	ld a, $01
	call CommScene_SetTextSprites
	ld a, $07
	ld [wRam_C27C], a
	jr Label_70_43C9

Label_70_43C9:: ; 70:43C9
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_43D0:: ; 70:43D0
	ld a, [wRam_C27E]
	or a, a
	jr z, Label_70_43F8
	cp a, $01
	jr z, Label_70_43DC

; ---- code $43DA-$43DC (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 43AD-44B0 by apply_coverage --split
	jr Label_70_43F8

; ---- code $43DC-$4462 (134 bytes) [CONFIRMED] 57 insn(s) executed; cut out of the PROBABLE region 43AD-44B0 by apply_coverage --split [executed in 2 scenarios]

Label_70_43DC:: ; 70:43DC
	ld a, $01
	call CommScene_SetTextSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $08
	ld [wRam_C27C], a
	jr Label_70_43F8

Label_70_43F8:: ; 70:43F8
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_43FF:: ; 70:43FF
	ld a, [wRam_C280]
	dec a
	ld [wRam_C280], a
	cp a, $E0
	jr nz, Label_70_4411
	ld a, $05
	ld [wRam_C27C], a
	jr Label_70_4411

Label_70_4411:: ; 70:4411
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_4418:: ; 70:4418
	call CommScene_LoadGraphics
	ld a, $04
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wRam_C27C], a
	ld a, $48
	ld [wRam_C280], a
	ld a, $01
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ret

Label_70_4452:: ; 70:4452
	ld a, $02
	ld [wRam_C27C], a
	ret

Label_70_4458:: ; 70:4458
	ld a, [wRam_C27E]
	or a, a
	jr z, Label_70_4480
	cp a, $01
	jr z, Label_70_4464

; ---- code $4462-$4464 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 43AD-44B0 by apply_coverage --split
	jr Label_70_4480

; ---- code $4464-$44B0 (76 bytes) [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 43AD-44B0 by apply_coverage --split [executed in 5 scenarios]

Label_70_4464:: ; 70:4464
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $03
	ld [wRam_C27C], a
	ld a, $05
	call CommScene_ShowTextBox
	jr Label_70_4480

Label_70_4480:: ; 70:4480
	call CommScene_ScrollDecrement
	ret

Label_70_4484:: ; 70:4484
	ld a, [wRam_C280]
	dec a
	ld [wRam_C280], a
	cp a, $E0
	jr nz, Label_70_4496
	ld a, $04
	ld [wRam_C27C], a
	jr Label_70_4496

Label_70_4496:: ; 70:4496
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_449D:: ; 70:449D
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wRam_C27C], a
	xor a, a
	ld [wRam_C27F], a
	ret

; ---- code $44B0-$46A6 (502 bytes) [CONFIRMED] 203 insn(s); 203 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_LoadGraphics:: ; 70:44B0
Function_70_44B0::
	farcall Function_00_09B6
	ld hl, $C2A8
	xor a, a
	ld [hli], a
	ld [hl], a
	ld hl, $FF40
	ld a, [hl]
	and a, $9F
	ld b, a
	and a, $08
	xor a, $08
	rlca
	rlca
	rlca
	or a, b
	or a, $04
	ld [hl], a
	ld a, $07
	ldh [rWX], a
	ld a, $70
	ldh [rWY], a
	ld de, $8000
	ld hl, Data_70_5490
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8400
	ld hl, Data_70_5890
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, Data_70_5C90
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, Data_70_6090
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9000
	ld hl, Data_70_6490
	ld a, $70
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld de, $8001
	ld hl, Data_70_6490
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8401
	ld hl, Data_70_6890
	ld a, $70
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_70_6690
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Tiles_70_6A90
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_70_6C90
	ld a, $70
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_70_6CD0
	ld a, $70
	farcall Palette_LoadToBuffer
	ld bc, $0E20
	ld de, $D000
	ld hl, Tilemap_70_6D10
	ld a, $70
	farcall Function_00_08EA
	call CommScene_UploadBackgroundMap
	ld hl, $DA10
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $01
	farcall Function_00_0A82
	ld de, $1800
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $02
	farcall Function_00_0A82
	ld de, $1888
	ld hl, $DA20
	call Function_00_0A65
	ld a, [wRam_C27D]
	or a, a
	jr z, Label_70_45EC
	ld a, [wRam_C283]
	or a, a
	jr z, Label_70_4605

Label_70_45EC:: ; 70:45EC
	ld hl, $DA30
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $83
	farcall Function_00_0A82
	ld de, $7000
	ld hl, $DA30
	call Function_00_0A65

Label_70_4605:: ; 70:4605
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ret

CommScene_Teardown:: ; 70:4613
	farcall Function_00_09B6
	call Function_00_044B
	ld hl, $FF40
	ld a, [hl]
	and a, $FB
	ld [hl], a
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	xor a, a
	ld [wRam_C2A8], a
	ld [wRam_C2A9], a
	ret

CommScene_UploadBackgroundMap:: ; 70:4638
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $9800
	di
	ld b, $92
	ld c, $40
	ld hl, $D000
	xor a, a
	call Function_00_0787
	inc e
	ld b, $92
	ld c, $40
	ld hl, $D400
	xor a, a
	call Function_00_0787
	ei
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

CommScene_UploadTextBox:: ; 70:466B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [rLCDC]
	and a, $40
	swap a
	add a, $98
	ld d, a
	ld e, $00
	di
	ld b, $95
	ld c, $24
	ld hl, $D000
	xor a, a
	call Function_00_0787
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Function_00_0787
	ei
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $46A6-$4704 (94 bytes) [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D, select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends exactly at the executed Function_70_477F; no caller, table word or far-call site references it anywhere in the ROM (raw scan), so entry unproven

Function_70_46A6:: ; 70:46A6
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [sSram_A9ED]
	bit 6, a
	jr z, Label_70_472A
	and a, $30
	or a, a
	jr z, Label_70_472A
	ld a, [sSram_A9EE]
	or a, a
	jr nz, Label_70_472A
	ld a, [sSram_A9ED]
	bit 7, a
	jr nz, Label_70_4704
	call Random16
	call Random16
	ld de, $0003
	call Divide16
	ld a, $02
	add a, e
	ld [sSram_A9EE], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, $02
	ret

; ---- code $4704-$472A (38 bytes) [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D, select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends exactly at the executed Function_70_477F; no caller, table word or far-call site references it anywhere in the ROM (raw scan), so entry unproven

Label_70_4704:: ; 70:4704
	call Random16
	ld de, $0006
	call Divide16
	ld a, $0A
	add a, e
	ld [sSram_A9EE], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, $01
	ret

; ---- code $472A-$4740 (22 bytes) [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D, select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends exactly at the executed Function_70_477F; no caller, table word or far-call site references it anywhere in the ROM (raw scan), so entry unproven

Label_70_472A:: ; 70:472A
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	xor a, a
	ret

; ---- code $4740-$4767 (39 bytes) [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D, select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends exactly at the executed Function_70_477F; no caller, table word or far-call site references it anywhere in the ROM (raw scan), so entry unproven
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [sSram_A9ED]
	bit 7, a
	jr nz, Label_70_4767
	ld b, $00
	jr Label_70_4769

; ---- code $4767-$477F (24 bytes) [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D, select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends exactly at the executed Function_70_477F; no caller, table word or far-call site references it anywhere in the ROM (raw scan), so entry unproven

Label_70_4767:: ; 70:4767
	ld b, $01

Label_70_4769:: ; 70:4769
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	ret

; ---- code $477F-$47A0 (33 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_PlaceTextSprites:: ; 70:477F
Function_70_477F::
	ld a, [wRam_C281]
	or a, a
	jr nz, Label_70_47A0
	ld d, $30
	ld a, [wRam_C280]
	ld e, a
	ld hl, $DA40
	call Function_00_0A65
	ld d, $30
	ld a, [wRam_C280]
	sub a, $10
	ld e, a
	ld hl, $DA50
	call Function_00_0A65
	ret

; ---- code $47A0-$47BB (27 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by jrcc from 70:4783 (executed) [executed in 3 scenarios]

Label_70_47A0:: ; 70:47A0
	ld d, $30
	ld a, [wRam_C280]
	ld e, a
	ld hl, $DA40
	call Function_00_0A65
	ld d, $30
	ld a, [wRam_C280]
	add a, $10
	ld e, a
	ld hl, $DA50
	call Function_00_0A65
	ret

; ---- code $47BB-$47E2 (39 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_SetTextSprites:: ; 70:47BB
Function_70_47BB::
	ld [wRam_C281], a
	or a, a
	jr nz, Label_70_47E2
	ld hl, $DA40
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA50
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $83
	farcall Function_00_0A82
	ret

; ---- code $47E2-$4803 (33 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1; entered by jrcc from 70:47BF (executed) [executed in 3 scenarios]

Label_70_47E2:: ; 70:47E2
	ld hl, $DA40
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $82
	farcall Function_00_0A82
	ld hl, $DA50
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $84
	farcall Function_00_0A82
	ret

; ---- code $4803-$4822 (31 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

CommScene_ShowTextBox:: ; 70:4803
Function_70_4803::
	ld hl, CommScene_TextBoxMaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0414
	ld de, $D000
	ld a, $70
	farcall Function_00_08EA
	call CommScene_UploadTextBox
	ret
