; engine/settings/continue_prompt.asm
; bank 67, $570C-$58CD (449 bytes); pinned by layout.link
; continue prompt

SECTION "engine/settings/continue_prompt", ROMX

; ---- code $570C-$5807 (251 bytes) [CONFIRMED] 88 insn(s) reached by static flow only; seeds: exec x88; min discovery hops 5; entered by far from 67:411E (PROBABLE code) | 85 insn(s) executed; cut out of the PROBABLE region 570C-580C by apply_coverage --split [executed in 1 scenarios]

SettingsPhone_ContinuePrompt:: ; 67:570C
	call SettingsPhone_ContinuePrompt_Setup
	farcall Palette_FadeInFromWhite
	call SettingsPhone_ContinuePrompt_Loop
	farcall Palette_FadeOutToWhite
	farcall Kbd_HideInstant
	ld a, [wRam_C27C]
	ret

SettingsPhone_ContinuePrompt_Setup:: ; 67:5728
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld a, $00
	ld [wRam_C27D], a
	ld de, $9001
	ld hl, Data_4B_76D0
	ld a, $4B
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_4B_7AD0
	ld a, $4B
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld de, $8001
	ld hl, Data_5F_49D0
	ld a, $5F
	ld b, $94
	ld c, $30
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, $7CD0
	ld a, $4B
	farcall Palette_LoadToBuffer
	ld bc, $0018
	ld de, $D868
	ld hl, $4CE0
	ld a, $5F
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, $7D10
	ld a, $4B
	farcall Function_00_08EA
	call SettingsPhone_ContinuePrompt_PrintPrompt
	call SettingsPhone_ContinuePrompt_UploadTextTiles
	call SettingsPhone_ContinuePrompt_BuildTextMap
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, Table_4A_4000
	ld a, $4A
	ld b, $81
	farcall Function_00_0A82
	call SettingsPhone_ContinuePrompt_PlaceCursor
	ret

SettingsPhone_ContinuePrompt_Loop:: ; 67:57CC
	farcall Function_00_0956
	call Function_00_044B
	farcall Joypad_Update
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, Label_67_57EB
	bit 5, a
	jr nz, Label_67_5821
	bit 4, a
	jr nz, Label_67_5821
	jr SettingsPhone_ContinuePrompt_Loop

Label_67_57EB:: ; 67:57EB
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	or a, a
	jr nz, Label_67_5807
	ld a, $01
	ld [wRam_C27C], a
	ret

; ---- code $5807-$580C (5 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 570C-580C by apply_coverage --split

Label_67_5807:: ; 67:5807
	xor a, a
	ld [wRam_C27C], a
	ret

; ---- code $580C-$5821 (21 bytes) [HYPOTHESIS] function with no found entry (no call/jp/table word/far pointer/ld r16 to $580C anywhere in the ROM); linear decode is legal ($580C-$5821), all direct targets are known code starts, saves rSVBK, bank 1, call $20AC (bc=$002E), restores; clears [$C27C]; ends with ret. Sits after a ret between PROBABLE/CONFIRMED functions of the same style
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	xor a, a
	ld [wRam_C27C], a
	ret

; ---- code $5821-$5842 (33 bytes) [PROBABLE] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 7; entered by jrcc from 67:57E3 (PROBABLE code) | 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5821-585A by apply_coverage --split

Label_67_5821:: ; 67:5821
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, [wRam_C27D]
	ld b, $01
	xor a, b
	ld [wRam_C27D], a
	call SettingsPhone_ContinuePrompt_PlaceCursor
	jr Label_67_583F

Label_67_583F:: ; 67:583F
	jp SettingsPhone_ContinuePrompt_Loop

; ---- code $5842-$585A (24 bytes) [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 5821-585A by apply_coverage --split [executed in 1 scenarios]

SettingsPhone_ContinuePrompt_PlaceCursor:: ; 67:5842
	ld a, [wRam_C27D]
	add a, a
	ld hl, SettingsPhone_ContinuePrompt_CursorPos
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld d, a
	ld hl, $DA00
	call Function_00_0A65
	ret

; ---- data $585A-$585E (4 bytes) [PROBABLE] 2 entries x 2 bytes (28 30 / 58 30), indexed by [$C27D]*2 (ld hl,$585A at 67:5846), stored into sprite slot $DA00 by call $0A65 (coordinates)

SettingsPhone_ContinuePrompt_CursorPos:: ; 67:585A
Data_67_585A::
	db $28, $30, $58, $30

; ---- code $585E-$58CD (111 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 7; entered by call from 67:57B0 (PROBABLE code) [executed in 1 scenarios]

SettingsPhone_ContinuePrompt_BuildTextMap:: ; 67:585E
	ld hl, $D121
	ld de, $0000
	ld bc, $0612
	farcall Tilemap_FillAscendingWithAttr
	ret

SettingsPhone_ContinuePrompt_PrintPrompt:: ; 67:586E
	ld de, $FFFF
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_FillRect
	ld a, $00
	ldh [hRam_FFBA], a
	ld a, $03
	ldh [hRam_FFBB], a
	ld a, $48
	ldh [hTextY], a
	ld a, $08
	ldh [hTextX], a
	ld a, $00
	ldh [hTextX + 1], a
	ld a, $48
	ldh [hRam_FFC0], a
	ld a, $08
	ldh [hRam_FFC1], a
	ld a, $00
	ldh [hRam_FFC2], a
	ld a, $78
	ldh [hRam_FFC3], a
	ld a, $C8
	ldh [hRam_FFC4], a
	ld a, $00
	ldh [hRam_FFC5], a
	ld a, $0C
	ldh [hRam_FFC6], a
	ld a, $0C
	ldh [hRam_FFC7], a
	ld a, $0A
	farcall Function_00_153D
	call Function_00_0ED3
	ret

SettingsPhone_ContinuePrompt_UploadTextTiles:: ; 67:58BD
	ld de, $9000
	ld hl, $0901
	ld bc, $0612
	farcall TileCanvas_UploadRect
	ret
