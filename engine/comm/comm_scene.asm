; engine/comm/comm_scene.asm
; bank 70, $4000-$4822 (2082 bytes); pinned by layout.link
; scrolling panorama scene shown during homepage communication

SECTION "engine/comm/comm_scene", ROMX

CommScene_Init:: ; 70:4000
Function_70_4000::
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wCommScene_Kind], a
	xor a, a
	ld [wCommScene_State], a
	ld [wCommScene_StepArg], a
	ld [wCommScene_Result], a
	ld a, [wCommScene_Kind]
	or a, a
	jr z, .l401F
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, .l401D

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 70:4018 (executed)
	xor a, a
	jr .l401F

.l401D ; 70:401D
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)
	ld a, $01
.l401F ; 70:401F
	ld [wCommScene_TimerAFlag], a
	ret

CommScene_Step:: ; 70:4023
	ld [wCommScene_StepArg], a
	ld a, $01
	ld [wCommScene_Result], a
	farcall Joypad_Update
	call CommScene_RunState
	call CommScene_ApplyScrollFrame
	ld a, [wCommScene_Kind]
	or a, a
	jr z, .l407B
	ld a, [wCommScene_TimerAFlag]
	or a, a
	jr nz, .l406A

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the jrcc at 70:4041 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 4043-406A by apply_coverage --split [executed in 5 scenarios]
	ld a, [wTimerEnable]
	bit 4, a
	jr z, .l407B

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4043-406A by apply_coverage --split
	ld hl, $DA30
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $83
	farcall Sprite_InitSlot
	ld de, $7000
	ld hl, $DA30
	call Sprite_SetPosition
	ld a, $01
	ld [wCommScene_TimerAFlag], a
	jr .l407B

.l406A ; 70:406A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, .l407B

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 70:406F (executed) [executed in 4 scenarios]
	ld hl, $DA30
	call Sprite_ClearSlot
	xor a, a
	ld [wCommScene_TimerAFlag], a

.l407B ; 70:407B
	; [CONFIRMED] 31 insn(s); 31 executed (in up to 1/18 scenarios)
	ld a, [wCommScene_Result]
	ret

CommScene_ApplyScrollFrame:: ; 70:407F
	call Sprite_UpdateAll
	call VBlank_Wait
	ld hl, $C2A8
	ld a, [hli]
	ldh [rSCX], a
	call Sound_FrameService
	ret

CommScene_RunState:: ; 70:408F
	ld a, [wCommScene_Kind]
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
	ld a, [wCommScene_State]
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

Label_70_40E3:: ; 70:40E3
	; [CONFIRMED] 64 insn(s); 64 executed (in up to 1/18 scenarios)
	call CommScene_LoadGraphics
	xor a, a
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wCommScene_State], a
	xor a, a
	ld [wCommScene_SpritePairX], a
	ld a, $00
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ret

Label_70_411B:: ; 70:411B
	ld a, $02
	ld [wCommScene_State], a
	ret

Label_70_4121:: ; 70:4121
	ld a, [wCommScene_SpritePairX]
	inc a
	ld [wCommScene_SpritePairX], a
	cp a, $48
	jr nz, .skip
	ld a, $03
	ld [wCommScene_State], a
.skip ; 70:4131
	call CommScene_PlaceTextSprites
	ret

Label_70_4135:: ; 70:4135
	ld a, [wCommScene_StepArg]
	cp a, $01
	jr z, .l4144
	ldh a, [hJoyPressed]
	bit 1, a
	jr nz, .l417E
	jr .l41BB
.l4144 ; 70:4144
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $14
	ld [wCommScene_Timer], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, $DA60
	call Sprite_SetPosition
	ld a, $01
	call CommScene_ShowTextBox
	ld a, $04
	ld [wCommScene_State], a
	jr .l41BB

.l417E ; 70:417E
	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1;
	; entered by jrcc from 70:4140 (executed) [executed in 2 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wCommScene_Result], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, $DA60
	call Sprite_SetPosition
	ld a, $06
	call CommScene_ShowTextBox
	ld a, $14
	ld [wCommScene_Timer], a
	ld a, $07
	ld [wCommScene_State], a

.l41BB ; 70:41BB
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios)
	call CommScene_ScrollIncrement
	ret

Label_70_41BF:: ; 70:41BF
	ld a, [wCommScene_Timer]
	dec a
	ld [wCommScene_Timer], a
	or a, a
	jr nz, .l41E4
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DA60
	call Sprite_ClearSlot
	ld a, $05
	ld [wCommScene_State], a
.l41E4 ; 70:41E4
	call CommScene_ScrollIncrement
	ret

Label_70_41E8:: ; 70:41E8
	ld a, [wCommScene_SpritePairX]
	add a, $02
	ld [wCommScene_SpritePairX], a
	cp a, $A0
	jr nz, .l41FB
	ld a, $06
	ld [wCommScene_State], a
	jr .l41FB
.l41FB ; 70:41FB
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_4202:: ; 70:4202
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wCommScene_State], a
	xor a, a
	ld [wCommScene_Result], a
	ret

Label_70_4215:: ; 70:4215
	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: table x44; min discovery hops 0;
	; run starts at an entry of the code-pointer table at 70:40B3 | 19 insn(s) executed; cut out of
	; the PROBABLE region 4215-4275 by apply_coverage --split [executed in 5 scenarios]
	ld a, [wCommScene_Timer]
	dec a
	ld [wCommScene_Timer], a
	or a, a
	jr nz, .l4231
	ld hl, $DA60
	call Sprite_ClearSlot
	ld a, $01
	call CommScene_SetTextSprites
	ld a, $08
	ld [wCommScene_State], a
	jr .l4231
.l4231 ; 70:4231
	call CommScene_PlaceTextSprites
	ret

Label_70_4235:: ; 70:4235
	ld a, [wCommScene_StepArg]
	or a, a
	jr z, .l4258
	cp a, $01
	jr z, .l4241

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4215-4275 by apply_coverage --split
	jr .l4258

.l4241 ; 70:4241
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 4215-4275 by apply_coverage
	; --split [executed in 4 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $09
	ld [wCommScene_State], a
	jr .l4258
.l4258 ; 70:4258
	call CommScene_ScrollDecrement
	ret

Label_70_425C:: ; 70:425C
	ld a, [wCommScene_SpritePairX]
	dec a
	ld [wCommScene_SpritePairX], a
	cp a, $E0
	jr nz, .l426E
	ld a, $06
	ld [wCommScene_State], a
	jr .l426E
.l426E ; 70:426E
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

CommScene_ResetScroll:: ; 70:4275
Function_70_4275::
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	xor a, a
	ld [wCommSceneScrollX], a
	ld [wRam_C2A9], a
	ret

CommScene_ScrollIncrement:: ; 70:427D
	ld a, [wCommSceneScrollX]
	inc a
	ld [wCommSceneScrollX], a
	ret

CommScene_ScrollDecrement:: ; 70:4285
	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: table x4; min discovery hops 2;
	; entered by call from 70:4258 (PROBABLE code) [executed in 3 scenarios]
	ld a, [wCommSceneScrollX]
	dec a
	ld [wCommSceneScrollX], a
	ret

Label_70_428D:: ; 70:428D
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios)
	call CommScene_LoadGraphics
	ld a, $02
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wCommScene_State], a
	ld a, $48
	ld [wCommScene_SpritePairX], a
	ld a, $00
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ret

Label_70_42C7:: ; 70:42C7
	ld a, $02
	ld [wCommScene_State], a
	ret

Label_70_42CD:: ; 70:42CD
	ld a, [wCommScene_StepArg]
	cp a, $01
	jr z, .l42DC
	ldh a, [hJoyPressed]
	bit 1, a
	jr nz, .l4316
	jr .l4353
.l42DC ; 70:42DC
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $14
	ld [wCommScene_Timer], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, $DA60
	call Sprite_SetPosition
	ld a, $03
	call CommScene_ShowTextBox
	ld a, $03
	ld [wCommScene_State], a
	jr .l4353

.l4316 ; 70:4316
	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1;
	; entered by jrcc from 70:42D8 (executed) [executed in 2 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002F
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wCommScene_Result], a
	ld hl, $DA60
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $3048
	ld hl, $DA60
	call Sprite_SetPosition
	ld a, $06
	call CommScene_ShowTextBox
	ld a, $14
	ld [wCommScene_Timer], a
	ld a, $06
	ld [wCommScene_State], a

.l4353 ; 70:4353
	; [CONFIRMED] 39 insn(s); 39 executed (in up to 1/18 scenarios)
	call CommScene_ScrollIncrement
	ret

Label_70_4357:: ; 70:4357
	ld a, [wCommScene_Timer]
	dec a
	ld [wCommScene_Timer], a
	or a, a
	jr nz, .l437C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0044
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld hl, $DA60
	call Sprite_ClearSlot
	ld a, $04
	ld [wCommScene_State], a
.l437C ; 70:437C
	call CommScene_ScrollIncrement
	ret

Label_70_4380:: ; 70:4380
	ld a, [wCommScene_SpritePairX]
	add a, $02
	ld [wCommScene_SpritePairX], a
	cp a, $A0
	jr nz, .l4393
	ld a, $05
	ld [wCommScene_State], a
	jr .l4393
.l4393 ; 70:4393
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_439A:: ; 70:439A
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wCommScene_State], a
	xor a, a
	ld [wCommScene_Result], a
	ret

Label_70_43AD:: ; 70:43AD
	; [CONFIRMED] 112 insn(s) reached by static flow only; seeds: site x18, table x94; min discovery
	; hops 0; run starts at an entry of the code-pointer table at 70:40B3 | 20 insn(s) executed; cut
	; out of the PROBABLE region 43AD-44B0 by apply_coverage --split [executed in 2 scenarios]
	ld a, [wCommScene_Timer]
	dec a
	ld [wCommScene_Timer], a
	or a, a
	jr nz, .l43C9
	ld hl, $DA60
	call Sprite_ClearSlot
	ld a, $01
	call CommScene_SetTextSprites
	ld a, $07
	ld [wCommScene_State], a
	jr .l43C9
.l43C9 ; 70:43C9
	call CommScene_PlaceTextSprites
	call CommScene_ScrollIncrement
	ret

Label_70_43D0:: ; 70:43D0
	ld a, [wCommScene_StepArg]
	or a, a
	jr z, .l43F8
	cp a, $01
	jr z, .l43DC

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 43AD-44B0 by apply_coverage --split
	jr .l43F8

.l43DC ; 70:43DC
	; [CONFIRMED] 57 insn(s) executed; cut out of the PROBABLE region 43AD-44B0 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	call CommScene_SetTextSprites
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $08
	ld [wCommScene_State], a
	jr .l43F8
.l43F8 ; 70:43F8
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_43FF:: ; 70:43FF
	ld a, [wCommScene_SpritePairX]
	dec a
	ld [wCommScene_SpritePairX], a
	cp a, $E0
	jr nz, .l4411
	ld a, $05
	ld [wCommScene_State], a
	jr .l4411
.l4411 ; 70:4411
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_4418:: ; 70:4418
	call CommScene_LoadGraphics
	ld a, $04
	call CommScene_ShowTextBox
	call CommScene_ResetScroll
	ld a, $01
	ld [wCommScene_State], a
	ld a, $48
	ld [wCommScene_SpritePairX], a
	ld a, $01
	call CommScene_SetTextSprites
	call CommScene_PlaceTextSprites
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000B
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ret

Label_70_4452:: ; 70:4452
	ld a, $02
	ld [wCommScene_State], a
	ret

Label_70_4458:: ; 70:4458
	ld a, [wCommScene_StepArg]
	or a, a
	jr z, .l4480
	cp a, $01
	jr z, .l4464

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 43AD-44B0 by apply_coverage --split
	jr .l4480

.l4464 ; 70:4464
	; [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 43AD-44B0 by apply_coverage
	; --split [executed in 5 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0045
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $03
	ld [wCommScene_State], a
	ld a, $05
	call CommScene_ShowTextBox
	jr .l4480
.l4480 ; 70:4480
	call CommScene_ScrollDecrement
	ret

Label_70_4484:: ; 70:4484
	ld a, [wCommScene_SpritePairX]
	dec a
	ld [wCommScene_SpritePairX], a
	cp a, $E0
	jr nz, .l4496
	ld a, $04
	ld [wCommScene_State], a
	jr .l4496
.l4496 ; 70:4496
	call CommScene_PlaceTextSprites
	call CommScene_ScrollDecrement
	ret

Label_70_449D:: ; 70:449D
	farcall Palette_FadeOutToWhite
	call CommScene_Teardown
	ld a, $FF
	ld [wCommScene_State], a
	xor a, a
	ld [wCommScene_Result], a
	ret

CommScene_LoadGraphics:: ; 70:44B0
Function_70_44B0::
	; [CONFIRMED] 203 insn(s); 203 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Sprite_ResetAll
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
	ld hl, Gfx_CommScene_Tiles8000
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8400
	ld hl, Gfx_CommScene_Tiles8400
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, Gfx_CommScene_Tiles8800
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, Gfx_CommScene_Tiles8C00
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, Data_70_6490
	ld a, $70
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Data_70_6490
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8401
	ld hl, Data_70_6890
	ld a, $70
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Data_70_6690
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_CommScene_Tiles9400Vb1
	ld a, $70
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_CommScene_Bg
	ld a, $70
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_CommScene_Obj
	ld a, $70
	farcall Palette_LoadToBuffer
	ld bc, $0E20
	ld de, $D000
	ld hl, Tilemap_CommScene
	ld a, $70
	farcall Tilemap_CopyRectAndAttr
	call CommScene_UploadBackgroundMap
	ld hl, $DA10
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $01
	farcall Sprite_InitSlot
	ld de, $1800
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $02
	farcall Sprite_InitSlot
	ld de, $1888
	ld hl, $DA20
	call Sprite_SetPosition
	ld a, [wCommScene_Kind]
	or a, a
	jr z, .l45EC
	ld a, [wCommScene_TimerAFlag]
	or a, a
	jr z, .l4605
.l45EC ; 70:45EC
	ld hl, $DA30
	ld de, CommScene_ObjTable
	ld a, $70
	ld b, $83
	farcall Sprite_InitSlot
	ld de, $7000
	ld hl, $DA30
	call Sprite_SetPosition
.l4605 ; 70:4605
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	or a, $20
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	ret

CommScene_Teardown:: ; 70:4613
	farcall Sprite_ResetAll
	call VBlank_WaitAndService
	ld hl, $FF40
	ld a, [hl]
	and a, $FB
	ld [hl], a
	call VBlank_WaitStartDI
	ldh a, [rLCDC]
	and a, $DF
	ldh [rLCDC], a
	ei
	call Sound_FrameService
	xor a, a
	ld [wCommSceneScrollX], a
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
	call Gfx_StartHDMAWithService
	inc e
	ld b, $92
	ld c, $40
	ld hl, $D400
	xor a, a
	call Gfx_StartHDMAWithService
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
	call Gfx_StartHDMAWithService
	inc e
	ld b, $95
	ld c, $24
	ld hl, $D400
	xor a, a
	call Gfx_StartHDMAWithService
	ei
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Function_70_46A6:: ; 70:46A6
	; [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D,
	; select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at
	; 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends
	; exactly at the executed Function_70_477F; no caller, table word or far-call site references it
	; anywhere in the ROM (raw scan), so entry unproven
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
	jr z, .l472A
	and a, $30
	or a, a
	jr z, .l472A
	ld a, [sSram_A9EE]
	or a, a
	jr nz, .l472A
	ld a, [sSram_A9ED]
	bit 7, a
	jr nz, .l4704
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

.l4704 ; 70:4704
	; [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D,
	; select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at
	; 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends
	; exactly at the executed Function_70_477F; no caller, table word or far-call site references it
	; anywhere in the ROM (raw scan), so entry unproven
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

.l472A ; 70:472A
	; [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D,
	; select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at
	; 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends
	; exactly at the executed Function_70_477F; no caller, table word or far-call site references it
	; anywhere in the ROM (raw scan), so entry unproven
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

	; [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D,
	; select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at
	; 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends
	; exactly at the executed Function_70_477F; no caller, table word or far-call site references it
	; anywhere in the ROM (raw scan), so entry unproven
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
	jr nz, .l4767
	ld b, $00
	jr .l4769

.l4767 ; 70:4767
	; [HYPOTHESIS] SRAM-access helper of the shape shared by many executed routines (save FFF2/FF8D,
	; select SRAM bank via [$4000], enable via $0A -> [$0000], the first 20 bytes also occur at
	; 00:15BE, 0E:4028, 55:7011, 65:4126, 67:4051, 68:43C1 ...); clean linear decode to ret, ends
	; exactly at the executed Function_70_477F; no caller, table word or far-call site references it
	; anywhere in the ROM (raw scan), so entry unproven
	ld b, $01
.l4769 ; 70:4769
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

CommScene_PlaceTextSprites:: ; 70:477F
Function_70_477F::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wCommScene_SpritePairVariant]
	or a, a
	jr nz, .l47A0
	ld d, $30
	ld a, [wCommScene_SpritePairX]
	ld e, a
	ld hl, $DA40
	call Sprite_SetPosition
	ld d, $30
	ld a, [wCommScene_SpritePairX]
	sub a, $10
	ld e, a
	ld hl, $DA50
	call Sprite_SetPosition
	ret

.l47A0 ; 70:47A0
	; [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1;
	; entered by jrcc from 70:4783 (executed) [executed in 3 scenarios]
	ld d, $30
	ld a, [wCommScene_SpritePairX]
	ld e, a
	ld hl, $DA40
	call Sprite_SetPosition
	ld d, $30
	ld a, [wCommScene_SpritePairX]
	add a, $10
	ld e, a
	ld hl, $DA50
	call Sprite_SetPosition
	ret

CommScene_SetTextSprites:: ; 70:47BB
Function_70_47BB::
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld [wCommScene_SpritePairVariant], a
	or a, a
	jr nz, .l47E2
	ld hl, $DA40
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $81
	farcall Sprite_InitSlot
	ld hl, $DA50
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $83
	farcall Sprite_InitSlot
	ret

.l47E2 ; 70:47E2
	; [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 1;
	; entered by jrcc from 70:47BF (executed) [executed in 3 scenarios]
	ld hl, $DA40
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $82
	farcall Sprite_InitSlot
	ld hl, $DA50
	ld de, CommScene_TextObjTable
	ld a, $70
	ld b, $84
	farcall Sprite_InitSlot
	ret

CommScene_ShowTextBox:: ; 70:4803
Function_70_4803::
	; [CONFIRMED] 16 insn(s); 16 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	farcall Tilemap_CopyRectAndAttr
	call CommScene_UploadTextBox
	ret
