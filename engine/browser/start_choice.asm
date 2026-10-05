; engine/browser/start_choice.asm
; bank 73, $5F17-$62EF (984 bytes); pinned by layout.link
; browser start choice screen (home page / page list)

SECTION "engine/browser/start_choice", ROMX

Browser_StartChoiceScreen:: ; 73:5F17
Function_73_5F17::
	; [CONFIRMED] 133 insn(s); 133 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	farcall Sprite_ResetAll
	call VBlank_WaitAndService
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	ld a, $01
	ld hl, $A8B7
	call ReadByteFar
	or a, a
	jr nz, .skip
	ld a, $01
.skip ; 73:5F4A
	ld [wRam_C0E5], a
	ld a, $01
	ld [wRam_C0E7], a
	ld de, $8000
	ld hl, BrowserStart_Tiles0
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8800
	ld hl, BrowserStart_Tiles1
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, BrowserStart_Tiles2
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, BrowserStart_Tiles3
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, BrowserStart_Tiles4
	ld a, $73
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, BrowserStart_Palettes
	ld a, $73
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, BrowserStart_Map
	ld a, $73
	farcall Tilemap_CopyRectAndAttr
	call BrowserStart_DrawButtons
	ld hl, $DA10
	ld de, $5F0F
	ld a, $73
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $3D2C
	ld hl, $DA10
	call Sprite_SetPosition
	ld hl, $DA20
	ld de, $5F0F
	ld a, $73
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $4122
	ld hl, $DA20
	call Sprite_SetPosition
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
	call VBlank_WaitAndService
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
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	call BrowserStart_ShowDescription
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0011
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

BrowserStart_InputLoop:: ; 73:607E
Label_73_607E::
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $6096-$60A0 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 73:6093: 5 entries; fixed length (5 words) by the routine

BrowserStart_InputTable:: ; 73:6096
Table_73_6096::
	dw BrowserStart_OnA
	dw BrowserStart_OnB
	dw BrowserStart_IgnoreSelect
	dw BrowserStart_IgnoreStart
	dw BrowserStart_Idle

BrowserStart_Idle:: ; 73:60A0
Label_73_60A0::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ld a, [wRam_C0E4]
	or a, a
	jr z, .l60D7

	; [PROBABLE] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 0;
	; fall-through of the jrcc at 73:60A4 (executed)
	ld hl, $C0E4
	ld a, [hl]
	dec a
	ld [hl], a
	jr nz, .l60D7
	inc a
	ld [hl], a
	ld a, [wSpriteSlots + 47]
	or a, a
	jr nz, .l60D7
	ld a, [wRam_C0E5]
	cp a, $01
	jr z, .l60EA
	farcall Palette_FadeOutWithTicker
	farcall Ticker_Stop
	ld a, [wRam_C0E5]
	ld b, $00
	or a, a
	ret z
.loop ; 73:60D0
	inc b
	srl a
	jr nc, .loop
	ld a, b
	ret

.l60D7 ; 73:60D7
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)
	farcall Ticker_Update
	ldh a, [hJoyPressedRepeat]
	and a, $F0
	call nz, BrowserStart_HandleDpad
	call BrowserStart_AnimateFrame
	jp BrowserStart_InputLoop

.l60EA ; 73:60EA
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 73:60BB (PROBABLE code)
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

BrowserStart_OnA:: ; 73:6114
Label_73_6114::
	; [CONFIRMED] 17 insn(s); 17 executed (in up to 1/18 scenarios)
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
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

Function_73_6143:: ; 73:6143
	; [HYPOTHESIS] 6 insn(s): two consecutive tiny functions (ld a,[$C0F8] ; xor $01 ; ret) and (ld
	; a,[$C0F9] ; xor $01 ; ret) falling into the code at 614F; well-formed instruction chain (clean
	; decode, all direct targets land on instruction starts, lands exactly on the next code region);
	; no direct caller/table entry found: entry HYPOTHESIS | verifier: downgraded to HYPOTHESIS, no
	; direct/far/table reference to this address exists anywhere in the ROM (all-bank search for the
	; address word) and it is not a fall-through of proven code, so it is only bytes that decode
	; cleanly
	ld a, [wRam_C0F8]
	xor a, $01
	ret

	ld a, [wRam_C0F9]
	xor a, $01
	ret

BrowserStart_OnB:: ; 73:614F
Label_73_614F::
	; [CONFIRMED] 61 insn(s) reached by static flow only; seeds: exec x61; min discovery hops 1;
	; entered by table from 73:6093 (executed) [executed in 3 scenarios]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
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

BrowserStart_IgnoreSelect:: ; 73:617A
Label_73_617A::
	jp BrowserStart_InputLoop

BrowserStart_IgnoreStart:: ; 73:617D
Label_73_617D::
	jp BrowserStart_InputLoop

BrowserStart_HandleDpad:: ; 73:6180
	ld b, a
	ld a, [wRam_C0E2]
	or a, a
	ret nz
	bit 4, b
	jr nz, .done
	bit 6, b
	jr nz, .l6193
	bit 7, b
	jr nz, .l61B4
.done ; 73:6192
	ret
.l6193 ; 73:6193
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ret
.l61B4 ; 73:61B4
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
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ret

BrowserStart_DrawButtons:: ; 73:61D5
Function_73_61D5::
	; [CONFIRMED] 26 insn(s); 26 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C0E5]
	dec a
	jr nz, .l6220
	ld a, $D5
	ld [wRam_C10E], a
	ld a, $43
	ld [wRam_C10F], a
	ld bc, $030A
	ld de, $D129
	ld hl, BrowserStart_BottomMapNormal
	ld a, $73
	farcall Tilemap_CopyRectAndAttrPtr
	ld a, $39
	ld [wRam_C10E], a
	ld a, $44
	ld [wRam_C10F], a
	ld bc, $040A
	ld de, $D089
	ld hl, $43F3
	ld a, $73
	farcall Tilemap_CopyRectAndAttrPtr
	farcall Sprite_UpdateAll
	call BrowserStart_AnimateFrame
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

.l6220 ; 73:6220
	; [CONFIRMED] 23 insn(s) reached by static flow only; seeds: exec x23; min discovery hops 1;
	; entered by jrcc from 73:61D9 (executed) [executed in 4 scenarios]
	ld a, $AD
	ld [wRam_C10E], a
	ld a, $43
	ld [wRam_C10F], a
	ld bc, $040A
	ld de, $D089
	ld hl, BrowserStart_TopMapNormal
	ld a, $73
	farcall Tilemap_CopyRectAndAttrPtr
	ld a, $61
	ld [wRam_C10E], a
	ld a, $44
	ld [wRam_C10F], a
	ld bc, $030A
	ld de, $D129
	ld hl, BrowserStart_BottomMapSelected
	ld a, $73
	farcall Tilemap_CopyRectAndAttrPtr
	farcall Sprite_UpdateAll
	call BrowserStart_AnimateFrame
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

BrowserStart_AnimateFrame:: ; 73:6265
Function_73_6265::
	; [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, $C0E7
	dec [hl]
	ret nz
	ld [hl], $19
	ld a, [wRam_C0E8]
	ld hl, $447F
	ld de, $0023
	or a, a
	jr z, .l627C
.loop ; 73:6278
	add hl, de
	dec a
	jr nz, .loop
.l627C ; 73:627C
	ld a, $AF
	add a, l
	ld [wRam_C10E], a
	ld a, h
	adc a, $00
	ld [wRam_C10F], a
	ld bc, $0507
	ld de, $D0C1
	ld a, $73
	farcall Tilemap_CopyRectAndAttrPtr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
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
.loop ; 73:62AF
	inc b
	srl a
	jr nc, .loop
	ld a, b
	cp a, $01
	call z, BrowserStart_DescIndex_AdjustItem1
	ld a, b
	cp a, $02
	call z, BrowserStart_DescIndex_AdjustItem2
	ld a, b
	cp a, $03
	call z, BrowserStart_DescIndex_AdjustItem3
	ld hl, Data_BrowserStart_StringIndexBank
	ld a, $73
	farcall Ticker_Start
	ret

BrowserStart_DescIndex_AdjustItem1:: ; 73:62D2
Function_73_62D2::
	; [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 1;
	; entered by callcc from 73:62B7 (executed) | 3 insn(s) executed; cut out of the PROBABLE region
	; 62D2-62EF by apply_coverage --split [executed in 8 scenarios]
	ld a, [wRam_C0F8]
	or a, a
	ret z

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 62D2-62EF by apply_coverage --split
	ld b, $05
	ret

BrowserStart_DescIndex_AdjustItem2:: ; 73:62DA
Function_73_62DA::
	ld a, [wRam_C0F9]
	or a, a
	ret z
	ld b, $06
	ret

BrowserStart_DescIndex_AdjustItem3:: ; 73:62E2
Function_73_62E2::
	ld a, $01
	ld hl, $A9ED
	call ReadByteFar
	bit 7, a
	ret z
	inc b
	ret
