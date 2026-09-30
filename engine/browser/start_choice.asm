; engine/browser/start_choice.asm
; bank 73, $5F17-$62EF (984 bytes); pinned by layout.link
; browser start choice screen (home page / page list)

SECTION "engine/browser/start_choice", ROMX

; ---- code $5F17-$6096 (383 bytes) [CONFIRMED] 133 insn(s); 133 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Browser_StartChoiceScreen:: ; 73:5F17
Function_73_5F17::
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
	farcall Function_00_09B6
	call Function_00_044B
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	ld a, $01
	ld hl, $A8B7
	call ReadByteFar
	or a, a
	jr nz, Label_73_5F4A
	ld a, $01

Label_73_5F4A:: ; 73:5F4A
	ld [wRam_C0E5], a
	ld a, $01
	ld [wRam_C0E7], a
	ld de, $8000
	ld hl, BrowserStart_Tiles0
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8800
	ld hl, BrowserStart_Tiles1
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C00
	ld hl, BrowserStart_Tiles2
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, BrowserStart_Tiles3
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, BrowserStart_Tiles4
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, BrowserStart_Palettes
	ld a, $73
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, BrowserStart_Map
	ld a, $73
	farcall Function_00_08EA
	call BrowserStart_DrawButtons
	ld hl, $DA10
	ld de, $5F0F
	ld a, $73
	ld b, $80
	farcall Function_00_0A82
	ld de, $3D2C
	ld hl, $DA10
	call Function_00_0A65
	ld hl, $DA20
	ld de, $5F0F
	ld a, $73
	ld b, $81
	farcall Function_00_0A82
	ld de, $4122
	ld hl, $DA20
	call Function_00_0A65
	ld bc, $0040
	ld de, $D840
	ld hl, $5E20
	ld a, $73
	farcall Palette_LoadToBuffer
	ld a, $40
	ld bc, $0220
	ld de, $8000
	ld hl, $D200
	farcall Tilemap_FillRectSequential
	call Function_00_044B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	ld de, $9400
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Function_00_082C
	farcall Function_00_0956
	farcall Palette_FadeInFromWhite
	call BrowserStart_ShowDescription
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0011
	call Function_00_20E8
	pop af
	ldh [rSVBK], a

Label_73_607E:: ; 73:607E
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $6096-$60A0 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 73:6093: 5 entries; fixed length (5 words) by the routine

BrowserStart_InputTable:: ; 73:6096
Table_73_6096::
	dw Label_73_6114
	dw Label_73_614F
	dw Label_73_617A
	dw Label_73_617D
	dw Label_73_60A0

; ---- code $60A0-$60A6 (6 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)

Label_73_60A0:: ; 73:60A0
	ld a, [wRam_C0E4]
	or a, a
	jr z, Label_73_60D7

; ---- code $60A6-$60D7 (49 bytes) [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0; fall-through of the jrcc at 73:60A4 (executed)
	ld hl, $C0E4
	ld a, [hl]
	dec a
	ld [hl], a
	jr nz, Label_73_60D7
	inc a
	ld [hl], a
	ld a, [wSpriteSlots + 47]
	or a, a
	jr nz, Label_73_60D7
	ld a, [wRam_C0E5]
	cp a, $01
	jr z, Label_73_60EA
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0E5]
	ld b, $00
	or a, a
	ret z

Label_73_60D0:: ; 73:60D0
	inc b
	srl a
	jr nc, Label_73_60D0
	ld a, b
	ret

; ---- code $60D7-$60EA (19 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_73_60D7:: ; 73:60D7
	farcall Ticker_Update
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, BrowserStart_HandleDpad
	call BrowserStart_AnimateFrame
	jp Label_73_607E

; ---- code $60EA-$6114 (42 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 73:60BB (PROBABLE code)

Label_73_60EA:: ; 73:60EA
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld b, $01
	ld a, $01
	ld hl, $A8C1
	farcall WriteByteFar
	ld a, $01
	ld b, a
	ld a, $01
	ld hl, $A8B7
	farcall WriteByteFar
	ld a, $01
	ret

; ---- code $6114-$6143 (47 bytes) [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)

Label_73_6114:: ; 73:6114
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0E5]
	ld b, a
	ld a, $01
	ld hl, $A8B7
	farcall WriteByteFar
	ld a, [wRam_C0E5]
	ret

; ---- code $6143-$614F (12 bytes) [HYPOTHESIS] 6 insn(s): two consecutive tiny functions (ld a,[$C0F8] ; xor $01 ; ret) and (ld a,[$C0F9] ; xor $01 ; ret) falling into the code at 614F; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the address word) and it is not a fall-through of proven code, so it is only bytes that decode cleanly

Function_73_6143:: ; 73:6143
	ld a, [wRam_C0F8]
	xor a, $01
	ret

	ld a, [wRam_C0F9]
	xor a, $01
	ret

; ---- code $614F-$61D5 (134 bytes) [CONFIRMED] 61 insn(s) reached by static flow only; seeds: exec x61; min discovery hops 1; entered by table from 73:6093 (executed) [executed in 3 scenarios]

Label_73_614F:: ; 73:614F
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld b, $00
	ld a, $01
	ld hl, $A8B7
	farcall WriteByteFar
	xor a, a
	ret

Label_73_617A:: ; 73:617A
	jp Label_73_607E

Label_73_617D:: ; 73:617D
	jp Label_73_607E

BrowserStart_HandleDpad:: ; 73:6180
	ld b, a
	ld a, [wRam_C0E2]
	or a, a
	ret nz
	bit 4, b
	jr nz, Label_73_6192
	bit 6, b
	jr nz, Label_73_6193
	bit 7, b
	jr nz, Label_73_61B4

Label_73_6192:: ; 73:6192
	ret

Label_73_6193:: ; 73:6193
	ld a, [wRam_C0E5]
	dec a
	xor a, $01
	inc a
	ld [wRam_C0E5], a
	call BrowserStart_DrawButtons
	call BrowserStart_ShowDescription
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

Label_73_61B4:: ; 73:61B4
	ld a, [wRam_C0E5]
	dec a
	xor a, $01
	inc a
	ld [wRam_C0E5], a
	call BrowserStart_DrawButtons
	call BrowserStart_ShowDescription
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ret

; ---- code $61D5-$6220 (75 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

BrowserStart_DrawButtons:: ; 73:61D5
Function_73_61D5::
	ld a, [wRam_C0E5]
	dec a
	jr nz, Label_73_6220
	ld a, $D5
	ld [wRam_C10E], a
	ld a, $43
	ld [wRam_C10F], a
	ld bc, $030A
	ld de, $D129
	ld hl, BrowserStart_BottomMapNormal
	ld a, $73
	farcall Function_00_16A2
	ld a, $39
	ld [wRam_C10E], a
	ld a, $44
	ld [wRam_C10F], a
	ld bc, $040A
	ld de, $D089
	ld hl, $43F3
	ld a, $73
	farcall Function_00_16A2
	farcall Function_00_0956
	call BrowserStart_AnimateFrame
	ldh a, [rLCDC]
	call Function_00_082C
	ret

; ---- code $6220-$6265 (69 bytes) [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1; entered by jrcc from 73:61D9 (executed) [executed in 4 scenarios]

Label_73_6220:: ; 73:6220
	ld a, $AD
	ld [wRam_C10E], a
	ld a, $43
	ld [wRam_C10F], a
	ld bc, $040A
	ld de, $D089
	ld hl, BrowserStart_TopMapNormal
	ld a, $73
	farcall Function_00_16A2
	ld a, $61
	ld [wRam_C10E], a
	ld a, $44
	ld [wRam_C10F], a
	ld bc, $030A
	ld de, $D129
	ld hl, BrowserStart_BottomMapSelected
	ld a, $73
	farcall Function_00_16A2
	farcall Function_00_0956
	call BrowserStart_AnimateFrame
	ldh a, [rLCDC]
	call Function_00_082C
	ret

; ---- code $6265-$62D2 (109 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

BrowserStart_AnimateFrame:: ; 73:6265
Function_73_6265::
	ld hl, $C0E7
	dec [hl]
	ret nz
	ld [hl], $19
	ld a, [wRam_C0E8]
	ld hl, $447F
	ld de, $0023
	or a, a
	jr z, Label_73_627C

Label_73_6278:: ; 73:6278
	add hl, de
	dec a
	jr nz, Label_73_6278

Label_73_627C:: ; 73:627C
	ld a, $AF
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld bc, $0507
	ld de, $D0C1
	ld a, $73
	farcall Function_00_16A2
	ldh a, [rLCDC]
	call Function_00_082C
	ld a, [wRam_C0E8]
	inc a
	ld [wRam_C0E8], a
	cp a, $05
	ret nz
	xor a, a
	ld [wRam_C0E8], a
	ret

BrowserStart_ShowDescription:: ; 73:62AA
	ld a, [wRam_C0E5]
	ld b, $FF

Label_73_62AF:: ; 73:62AF
	inc b
	srl a
	jr nc, Label_73_62AF
	ld a, b
	cp a, $01
	call z, Function_73_62D2
	ld a, b
	cp a, $02
	call z, Function_73_62DA
	ld a, b
	cp a, $03
	call z, Function_73_62E2
	ld hl, Data_73_4000
	ld a, $73
	farcall Ticker_Start
	ret

; ---- code $62D2-$62D7 (5 bytes) [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1; entered by callcc from 73:62B7 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 62D2-62EF by apply_coverage --split [executed in 8 scenarios]

Function_73_62D2:: ; 73:62D2
	ld a, [wRam_C0F8]
	or a, a
	ret z

; ---- code $62D7-$62EF (24 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 62D2-62EF by apply_coverage --split
	ld b, $05
	ret

Function_73_62DA:: ; 73:62DA
	ld a, [wRam_C0F9]
	or a, a
	ret z
	ld b, $06
	ret

Function_73_62E2:: ; 73:62E2
	ld a, $01
	ld hl, $A9ED
	call ReadByteFar
	bit 7, a
	ret z
	inc b
	ret
