; engine/browser/menus.asm
; bank 72, $63D8-$6C10 (2104 bytes); pinned by layout.link
; browser menus (two-item and three-item) with their records and texts

SECTION "engine/browser/menus", ROMX

; ---- code $63D8-$6476 (158 bytes) [CONFIRMED] 142 insn(s) reached by static flow only; seeds: exec x142; min discovery hops 1; entered by far from 4E:4D16 (PROBABLE code) | 55 insn(s) executed; cut out of the PROBABLE region 63D8-6556 by apply_coverage --split [executed in 1 scenarios]

BrowserMenu_OpenTwoItem:: ; 72:63D8
	ldh [hDialogResult], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	farcall Dialog_SaveBackground
	farcall Dialog_InitWindowRegs
	ld de, $8F01
	ld hl, BrowserMenu2_Tiles1
	ld a, $72
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $8801
	ld hl, BrowserMenu2_Tiles0
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0010
	ld de, $D830
	ld hl, BrowserMenu2_Palette
	ld a, $72
	farcall Palette_LoadToBuffer
	ld bc, $0614
	ld de, $D180
	ld hl, BrowserMenu2_Map
	ld a, $72
	farcall Function_00_08EA
	ld bc, $0008
	ld de, $D860
	ld hl, $7820
	ld a, $72
	farcall Palette_LoadToBuffer
	call Function_00_0392
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_72_6476
	ld a, $A2
	ld [wRam_D1A6], a
	inc a
	ld [wRam_D1A7], a
	ld a, $B2
	ld [wRam_D1C6], a
	inc a
	ld [wRam_D1C7], a
	ld a, $0F
	ld [wRam_D5A6], a
	ld [wRam_D5A7], a
	ld [wRam_D5C6], a
	ld [wRam_D5C7], a
	jr Label_72_6495

; ---- code $6476-$6495 (31 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 63D8-6556 by apply_coverage --split

Label_72_6476:: ; 72:6476
	ld a, $F0
	ld [wRam_D1A6], a
	inc a
	ld [wRam_D1A7], a
	inc a
	ld [wRam_D1C6], a
	inc a
	ld [wRam_D1C7], a
	ld a, $0E
	ld [wRam_D5A6], a
	ld [wRam_D5A7], a
	ld [wRam_D5C6], a
	ld [wRam_D5C7], a

; ---- code $6495-$6556 (193 bytes) [CONFIRMED] 74 insn(s) executed; cut out of the PROBABLE region 63D8-6556 by apply_coverage --split [executed in 1 scenarios]

Label_72_6495:: ; 72:6495
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
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMap
	ld hl, $DAC0
	ld de, BrowserMenu_CursorObjTable
	ld a, $72
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	ldh a, [hDialogResult]
	farcall BrowserMenu_DrawItemTwo
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $98
	ld [wSpriteSlots + 192], a
	ld hl, $DAD0
	call Function_00_09E6
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld c, $02
	ldh a, [rWY]
	cp a, $60
	jr z, Label_72_6515
	ld hl, Data_72_6556
	farcall Dialog_SlideIn

Label_72_6515:: ; 72:6515
	ld hl, $D200
	ld bc, $0214
	ld de, $0EC0
	farcall Tilemap_FillAscendingWithAttr
	ldh a, [rLCDC]
	call Function_00_07CB
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld a, [wJoyRepeatInterval]
	ld [wRam_C2E4], a
	ld a, [wJoyRepeatDelay]
	ld [wRam_C2E3], a
	ld b, $14
	ld c, $04
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $6556-$6563 (13 bytes) [PROBABLE] 13-byte script: 12 x $04 then terminator $80; read via ld hl,$6556 at 72:650C followed by the far call to the script reader at 72:4824 (same reader/format as the CONFIRMED read script at 72:6ADF: bytes until $80)

Data_72_6556:: ; 72:6556
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $80

; ---- code $6563-$659A (55 bytes) [CONFIRMED] 54 insn(s) reached by static flow only; seeds: exec x54; min discovery hops 1; entered by far from 4E:4D1C (PROBABLE code) | 23 insn(s) executed; cut out of the PROBABLE region 6563-65EB by apply_coverage --split [executed in 1 scenarios]

BrowserMenu_RunTwoItem:: ; 72:6563
	ldh a, [hDialogResult]

Label_72_6565:: ; 72:6565
	ldh [hDialogResult], a
	farcall BrowserMenu_DrawItemTwo

Label_72_656D:: ; 72:656D
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_72_65CD
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_72_669A
	bit 4, a
	jp z, Label_72_6690
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_72_65C7
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_72_65C8
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_72_65C7

; ---- code $659A-$65C7 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6563-65EB by apply_coverage --split
	jr nz, Label_72_65A3
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_72_65C7

Label_72_65A3:: ; 72:65A3
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_72_65B3
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_72_65C7
	set 1, [hl]

Label_72_65B3:: ; 72:65B3
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_72_65C8
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_72_65C8

; ---- code $65C7-$65EB (36 bytes) [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 6563-65EB by apply_coverage --split [executed in 1 scenarios]

Label_72_65C7:: ; 72:65C7
	xor a, a

Label_72_65C8:: ; 72:65C8
	pop hl
	or a, a
	jp nz, Label_72_6695

Label_72_65CD:: ; 72:65CD
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $65EB-$65F5 (10 bytes) [PROBABLE] inline table of `call $056A` (JoypadDispatch) at 72:65E8: 5 entries; fixed length (5 words) by the routine

Table_72_65EB:: ; 72:65EB
	dw Label_72_663E
	dw Label_72_6677
	dw Label_72_663B
	dw Label_72_6677
	dw Label_72_65F5

; ---- code $65F5-$6602 (13 bytes) [CONFIRMED] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 3; entered by table from 72:65E8 (PROBABLE code) | 6 insn(s) executed; cut out of the PROBABLE region 65F5-6643 by apply_coverage --split [executed in 1 scenarios]

Label_72_65F5:: ; 72:65F5
	ldh a, [hJoyPressedRepeat]
	bit 4, a
	jr nz, Label_72_6602
	bit 5, a
	jr nz, Label_72_661E
	jp Label_72_656D

; ---- code $6602-$663E (60 bytes) [PROBABLE] 29 insn(s) never executed in the traced runs; cut out of the PROBABLE region 65F5-6643 by apply_coverage --split

Label_72_6602:: ; 72:6602
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	inc a
	cp a, $02
	jp nz, Label_72_6565
	xor a, a
	jp Label_72_6565

Label_72_661E:: ; 72:661E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	dec a
	bit 7, a
	jp z, Label_72_6565
	ld a, $01
	jp Label_72_6565

Label_72_663B:: ; 72:663B
	jp Label_72_656D

; ---- code $663E-$6643 (5 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 65F5-6643 by apply_coverage --split [executed in 1 scenarios]

Label_72_663E:: ; 72:663E
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $6643-$6647 (4 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 72:6640: 2 entries; end is a heuristic guess (words stay plausible code pointers)

Table_72_6643:: ; 72:6643
	dw Label_72_665A
	dw Label_72_667B

; ---- code $6647-$665A (19 bytes) [PROBABLE] 104 insn(s) reached by static flow only; seeds: exec x104; min discovery hops 2; entered by jpcc from 72:665F (PROBABLE code) | 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6647-6711 by apply_coverage --split

Label_72_6647:: ; 72:6647
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_72_656D

; ---- code $665A-$6677 (29 bytes) [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 6647-6711 by apply_coverage --split [executed in 1 scenarios]

Label_72_665A:: ; 72:665A
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_72_6647
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $02
	ldh [hDialogResult], a
	ret

; ---- code $6677-$669F (40 bytes) [PROBABLE] 23 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6647-6711 by apply_coverage --split

Label_72_6677:: ; 72:6677
	xor a, a
	ldh [hDialogResult], a
	ret

Label_72_667B:: ; 72:667B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $03
	ldh [hDialogResult], a
	ret

Label_72_6690:: ; 72:6690
	ld a, $04
	ldh [hDialogResult], a
	ret

Label_72_6695:: ; 72:6695
	ld a, $05
	ldh [hDialogResult], a
	ret

Label_72_669A:: ; 72:669A
	ld a, $06
	ldh [hDialogResult], a
	ret

; ---- code $669F-$6711 (114 bytes) [CONFIRMED] 58 insn(s) executed; cut out of the PROBABLE region 6647-6711 by apply_coverage --split [executed in 1 scenarios]

BrowserMenu_DrawItemTwo:: ; 72:669F
	ld e, a
	ld l, a
	ld d, $00
	ld h, d
	add hl, hl
	add hl, de
	add hl, hl
	add hl, de
	ld de, $6AEC
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, $DAC0
	call Function_00_0A65
	pop hl
	ld a, [hli]
	ld b, a
	push hl
	ld hl, $DAD0
	ld de, BrowserMenu_CursorObjTable
	ld a, $72
	farcall Function_00_0A82
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, $DAD0
	call Function_00_0A65
	call Function_00_0392
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DC00
	ld bc, $0400
	xor a, a
	call FillBytes
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $DC00
	ld de, $DD40
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	ld de, $8C01
	ld hl, $DC00
	ld a, $00
	ld b, $95
	ld c, $28
	farcall Function_00_0787
	ret

; ---- data $6711-$6712 (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: single $AF (xor a) after the ret at 6710 and directly before the executed function 72:6712; no entry at 6711 found; left unclassified

Data_72_6711:: ; 72:6711
	db $AF

; ---- code $6712-$67B2 (160 bytes) [CONFIRMED] 56 insn(s); 56 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

BrowserMenu_OpenThreeItem:: ; 72:6712
Function_72_6712::
	ldh [hDialogResult], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	farcall Dialog_SaveBackground
	farcall Dialog_InitWindowRegs
	ld de, $8801
	ld hl, BrowserMenu3_Tiles0
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8F01
	ld hl, BrowserMenu3_Tiles1
	ld a, $72
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld bc, $0010
	ld de, $D830
	ld hl, Data_72_7200
	ld a, $72
	farcall Palette_LoadToBuffer
	ld bc, $0614
	ld de, $D180
	ld hl, BrowserMenu3_Map
	ld a, $72
	farcall Function_00_08EA
	ld bc, $0008
	ld de, $D860
	ld hl, $7210
	ld a, $72
	farcall Palette_LoadToBuffer
	call Function_00_0392
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_72_67B2
	ld a, $0F
	ld a, $A2
	ld [wRam_D1A9], a
	inc a
	ld [wRam_D1AA], a
	ld a, $B2
	ld [wRam_D1C9], a
	inc a
	ld [wRam_D1CA], a
	ld a, $0F
	ld [wRam_D5A9], a
	ld [wRam_D5AA], a
	ld [wRam_D5C9], a
	ld [wRam_D5CA], a
	jr Label_72_67D1

; ---- code $67B2-$67D1 (31 bytes) [CONFIRMED] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 72:678C (executed) [executed in 1 scenarios]

Label_72_67B2:: ; 72:67B2
	ld a, $F0
	ld [wRam_D1A9], a
	inc a
	ld [wRam_D1AA], a
	inc a
	ld [wRam_D1C9], a
	inc a
	ld [wRam_D1CA], a
	ld a, $0E
	ld [wRam_D5A9], a
	ld [wRam_D5AA], a
	ld [wRam_D5C9], a
	ld [wRam_D5CA], a

; ---- code $67D1-$6892 (193 bytes) [CONFIRMED] 74 insn(s); 74 executed (in up to 1/18 scenarios)

Label_72_67D1:: ; 72:67D1
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
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMap
	ld hl, $DAC0
	ld de, BrowserMenu_CursorObjTable
	ld a, $72
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	ldh a, [hDialogResult]
	farcall BrowserMenu_DrawItemThree
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $98
	ld [wSpriteSlots + 192], a
	ld hl, $DAD0
	call Function_00_09E6
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld c, $02
	ldh a, [rWY]
	cp a, $60
	jr z, Label_72_6851
	ld hl, Data_72_6892
	farcall Dialog_SlideIn

Label_72_6851:: ; 72:6851
	ld hl, $D200
	ld bc, $0214
	ld de, $0EC0
	farcall Tilemap_FillAscendingWithAttr
	ldh a, [rLCDC]
	call Function_00_07CB
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld a, [wJoyRepeatInterval]
	ld [wRam_C2E4], a
	ld a, [wJoyRepeatDelay]
	ld [wRam_C2E3], a
	ld b, $14
	ld c, $04
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $6892-$689F (13 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_6892:: ; 72:6892
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $80

; ---- code $689F-$68D6 (55 bytes) [CONFIRMED] 23 insn(s); 23 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

BrowserMenu_RunThreeItem:: ; 72:689F
Function_72_689F::
	ldh a, [hDialogResult]

Label_72_68A1:: ; 72:68A1
	ldh [hDialogResult], a
	farcall BrowserMenu_DrawItemThree

Label_72_68A9:: ; 72:68A9
	ld a, [wDialogOnlineSnapshot]
	bit 4, a
	jr z, Label_72_6909
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, Label_72_69EE
	bit 4, a
	jp z, Label_72_69E4
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_72_6903
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_72_6904
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_72_6903

; ---- code $68D6-$6903 (45 bytes) [PROBABLE] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 0; fall-through of the jrcc at 72:68D4 (executed)
	jr nz, Label_72_68DF
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_72_6903

Label_72_68DF:: ; 72:68DF
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_72_68EF
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_72_6903
	set 1, [hl]

Label_72_68EF:: ; 72:68EF
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_72_6904
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_72_6904

; ---- code $6903-$6927 (36 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)

Label_72_6903:: ; 72:6903
	xor a, a

Label_72_6904:: ; 72:6904
	pop hl
	or a, a
	jp nz, Label_72_69E9

Label_72_6909:: ; 72:6909
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $6927-$6931 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 72:6924: 5 entries; fixed length (5 words) by the routine

Table_72_6927:: ; 72:6927
	dw Label_72_697A
	dw Label_72_69CA
	dw Label_72_6977
	dw Label_72_69CA
	dw Label_72_6931

; ---- code $6931-$693E (13 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_72_6931:: ; 72:6931
	ldh a, [hJoyPressedRepeat]
	bit 4, a
	jr nz, Label_72_693E
	bit 5, a
	jr nz, Label_72_695A
	jp Label_72_68A9

; ---- code $693E-$697F (65 bytes) [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 1; entered by jrcc from 72:6935 (executed) [executed in 1 scenarios]

Label_72_693E:: ; 72:693E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	inc a
	cp a, $03
	jp nz, Label_72_68A1
	xor a, a
	jp Label_72_68A1

Label_72_695A:: ; 72:695A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	dec a
	bit 7, a
	jp z, Label_72_68A1
	ld a, $02
	jp Label_72_68A1

Label_72_6977:: ; 72:6977
	jp Label_72_68A9

Label_72_697A:: ; 72:697A
	ldh a, [hDialogResult]
	call JumpTableInline

; ---- ptrtable $697F-$6985 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 72:697C: 3 entries; end is a heuristic guess (words stay plausible code pointers)

Table_72_697F:: ; 72:697F
	dw Label_72_6998
	dw Label_72_69AD
	dw Label_72_69CE

; ---- code $6985-$6998 (19 bytes) [PROBABLE] 34 insn(s) reached by static flow only; seeds: exec x34; min discovery hops 2; entered by jpcc from 72:69B2 (PROBABLE code) | 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6985-69CA by apply_coverage --split

Label_72_6985:: ; 72:6985
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	jp Label_72_68A9

; ---- code $6998-$69CA (50 bytes) [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 6985-69CA by apply_coverage --split [executed in 2 scenarios]

Label_72_6998:: ; 72:6998
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $01
	ldh [hDialogResult], a
	ret

Label_72_69AD:: ; 72:69AD
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_72_6985
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $02
	ldh [hDialogResult], a
	ret

; ---- code $69CA-$69CE (4 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_72_69CA:: ; 72:69CA
	xor a, a
	ldh [hDialogResult], a
	ret

; ---- code $69CE-$69E4 (22 bytes) [CONFIRMED] 21 insn(s) reached by static flow only; seeds: exec x21; min discovery hops 1; entered by table from 72:697C (PROBABLE code) | 12 insn(s) executed; cut out of the PROBABLE region 69CE-69F3 by apply_coverage --split [executed in 1 scenarios]

Label_72_69CE:: ; 72:69CE
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ldh a, [hDialogResult]
	inc a
	ldh [hDialogResult], a
	ret

; ---- code $69E4-$69F3 (15 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 69CE-69F3 by apply_coverage --split

Label_72_69E4:: ; 72:69E4
	ld a, $04
	ldh [hDialogResult], a
	ret

Label_72_69E9:: ; 72:69E9
	ld a, $05
	ldh [hDialogResult], a
	ret

Label_72_69EE:: ; 72:69EE
	ld a, $06
	ldh [hDialogResult], a
	ret

; ---- code $69F3-$6ADF (236 bytes) [CONFIRMED] 106 insn(s); 106 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

BrowserMenu_DrawItemThree:: ; 72:69F3
Function_72_69F3::
	ld e, a
	ld l, a
	ld d, $00
	ld h, d
	add hl, hl
	add hl, de
	add hl, hl
	add hl, de
	ld de, $6B4C
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, $DAC0
	call Function_00_0A65
	pop hl
	ld a, [hli]
	ld b, a
	push hl
	ld hl, $DAD0
	ld de, BrowserMenu_CursorObjTable
	ld a, $72
	farcall Function_00_0A82
	pop hl
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	push hl
	ld hl, $DAD0
	call Function_00_0A65
	call Function_00_0392
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DC00
	ld bc, $0400
	xor a, a
	call FillBytes
	pop hl
	call Function_00_0392
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $DC00
	ld de, $DD40
	ld a, $07
	ldh [hRam_FFB0], a
	ld a, $72
	farcall TextTiles_RenderLine
	call Function_00_0392
	ld de, $8C01
	ld hl, $DC00
	ld a, $00
	ld b, $95
	ld c, $28
	farcall Function_00_0787
	ret

BrowserMenu_Close:: ; 72:6A6B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	farcall Dialog_UploadWindowMap
	ld hl, $DAD0
	call Function_00_09E6
	ld hl, $DACB
	ld de, $0A1A
	ld a, $00
	call Function_00_0A45
	call Function_00_047A
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Function_00_0392
	farcall Dialog_RestoreBackground
	ldh a, [rLCDC]
	call Function_00_07CB
	ld c, $02
	ldh a, [rWY]
	cp a, $90
	jr z, Label_72_6AB4
	ld hl, Data_72_6ADF
	farcall Dialog_SlideOut

Label_72_6AB4:: ; 72:6AB4
	call Function_00_047A
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Function_00_0392
	ld hl, $DAC0
	call Function_00_09E6
	ld a, [wRam_C2E4]
	ld b, a
	ld a, [wRam_C2E3]
	ld c, a
	farcall Joypad_SetRepeatTiming
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- data $6ADF-$6AEC (13 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

Data_72_6ADF:: ; 72:6ADF
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $80

; ---- data $6AEC-$6AFA (14 bytes) [PROBABLE] 2 records of 7 bytes (dw, db, dw, dw): indexed with hl=7*a+$6AEC at 72:669F-66AB (ld de,$6AEC); word1 -> call 00:0A65, byte -> b for init_object_from_table (00:0A82), word2 = pointer; last word of each record points at the strings 72:6AFA / 72:6B23

BrowserMenu_TwoItemRecords:: ; 72:6AEC
Table_72_6AEC::
	db $30, $68, $83, $30, $68, $FA, $6A, $60, $68, $84, $60, $68, $23, $6B

; ---- text $6AFA-$6B4C (82 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

BrowserMenu_TwoItemTexts:: ; 72:6AFA
String_72_6AFA::
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $81, $40, $82, $AB, $82, $E8, $82, $DC, $82, $B7, $81, $40, $81, $40, $81, $40 ; "　　　　　でんわを　きります　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"
	db $81, $40, $81, $40, $81, $40, $83, $67, $83, $62, $83, $76, $83, $81, $83, $6A, $83, $85, $81, $5B, $82, $C9, $81, $40, $82, $E0, $82, $C7, $82, $E8, $82, $DC, $82, $B7 ; "　　　トップメニューに　もどります"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- data $6B4C-$6B68 (28 bytes) [PROBABLE] 4 records of 7 bytes (dw, db, dw, dw): indexed with hl=7*a+$6B4C at 72:69F3-69FF (ld de,$6B4C); record 0 (6B4C-6B53) is CONFIRMED read by executed code; last word of every record points into the strings at 72:6B68.. (6B68, 6B91, 6BBA, 6BE3 = record starts); extent = 4 records up to the String region at 72:6B68

BrowserMenu_ThreeItemRecords:: ; 72:6B4C
Table_72_6B4C::
	db $20, $68, $82, $20, $68, $68, $6B, $48, $68, $83, $48, $68, $91, $6B, $70, $68
	db $84, $70, $68, $BA, $6B, $20, $68, $87, $20, $68, $E3, $6B

; ---- text $6B68-$6BE3 (123 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

BrowserMenu_ThreeItemTexts:: ; 72:6B68
String_72_6B68::
	db $81, $40, $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $82, $D6, $82, $CC, $81, $40, $82, $A9, $82, $AB, $82, $B1, $82, $DD, $82, $AA, $82, $C5, $82, $AB ; "　ページリストへの　かきこみができ"
	db $82, $DC, $82, $B7, $81, $40, $00 ; "ます　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $82, $C5, $82, $F1, $82, $ED, $82, $F0, $81, $40, $82, $AB, $82, $E8, $82, $DC, $82, $B7, $81, $40, $81, $40, $81, $40 ; "　　　　　でんわを　きります　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"
	db $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82, $F0, $81, $40, $82, $B5, $82, $E3, $82, $A4, $82, $E8, $82, $E5, $82, $A4, $82, $B5, $82, $DC ; "　ホームページを　しゅうりょうしま"
	db $82, $B7, $81, $40, $81, $40, $00 ; "す　　"

; ---- text $6BE3-$6C0C (41 bytes) [PROBABLE] text: 20 full-width characters line (blanks and ？ placeholders) + NUL, same 32-byte-line record style as 72:6B68 (String region right before, decodes as cp932); no table pointer found

BrowserMenu_PlaceholderText:: ; 72:6BE3
String_72_6BE3::
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $48, $81, $40, $81, $40, $81, $40 ; "　　　　　　？？？？？？？？　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- zero $6C0C-$6C10 (4 bytes) [PROBABLE] 4 x 00 padding before the tile block at 72:6C10
	ds $4, $00
