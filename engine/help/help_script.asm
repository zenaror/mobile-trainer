; engine/help/help_script.asm
; bank 6C, $5987-$61CB (2116 bytes); pinned by layout.link
; HelpMenu_Run and the help script player

SECTION "engine/help/help_script", ROMX

HelpMenu_Run:: ; 6C:5987
Function_6C_5987::
	; [CONFIRMED] 185 insn(s); 185 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $01
.loop ; 6C:5989
	farcall HelpMenu_ShowPage
	or a, a
	ret z
	cp a, $04
	jr z, .l59A8
	ld b, a
	ld a, $01
	ld hl, $A684
	farcall WriteByteFar
	push bc
	call HelpScript_Run
	pop bc
	jr .loop
.l59A8 ; 6C:59A8
	farcall MobileDict_Run
	ld b, $04
	jr .loop

HelpScript_Run:: ; 6C:59B2
	push bc
	xor a, a
	ld bc, $00FC
	ld hl, $C0D4
	call FillBytes
	farcall Function_48_48BB
	pop bc
	ld a, $01
	ld hl, $A684
	farcall WriteByteFar
	ld a, $09
	ld [wHelpScriptPtr], a
	ld [wHelpScriptRestartPtr], a
	ld a, $48
	ld [wHelpScriptPtr + 1], a
	ld [wHelpScriptRestartPtr + 1], a
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	ld de, $8000
	ld hl, Data_6A_69F0
	ld a, $6A
	ld b, $98
	ld c, $02
	farcall Gfx_StartHDMAWithService
	ld de, $8AF1
	ld hl, Data_6A_6A10
	ld a, $6A
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $8B01
	ld hl, Data_6A_6A20
	ld a, $6A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_6A_7220
	ld a, $6A
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, Data_6A_6716
	ld a, $6A
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, $D840
	ld hl, $7260
	ld a, $6A
	farcall Palette_LoadToBuffer
	ld a, $60
	ld bc, $020C
	ld de, $1700
	ld hl, $D004
	farcall Tilemap_FillRectSequential
	ld a, $80
	ld bc, $060C
	ld de, $1700
	ld hl, $D064
	farcall Tilemap_FillRectSequential
	ld a, $00
	ld bc, $0610
	ld de, $1700
	ld hl, $D122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	ld bc, $0400
	ld hl, $D000
	call FillBytes
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld de, $8800
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C00
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9000
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D000
	ld a, $03
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call VBlank_WaitStartDI
	ld hl, $D800
	farcall Palette_ReadHardwareToBuffer
	ei
	call Sound_FrameService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0017
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a

Label_6C_5B47:: ; 6C:5B47
	ld a, [wHelpScriptPtr]
	ld l, a
	ld a, [wHelpScriptPtr + 1]
	ld h, a
.loop ; 6C:5B4F
	ld a, [hli]
	ld [wRam_C1AC], a
	cp a, $01
	jr c, .l5B7E
	jp z, .l5C34
	cp a, $03
	jp c, .l5C35
	jp z, .l5C36
	cp a, $05
	jr c, .l5B81
	jr z, .l5B88
	cp a, $07
	jr c, .l5B8F
	cp a, $09
	jp c, .l5B9D
	cp a, $10
	jr z, .l5BAF
	cp a, $18
	jr z, .l5BC7

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 6C:5B77 (executed)
	cp a, $19
	jr z, .l5BDF
	ret

.l5B7E ; 6C:5B7E
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 12/18 scenarios)
	jp .l5C0B
.l5B81 ; 6C:5B81
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	add hl, bc
	jr .loop

.l5B88 ; 6C:5B88
	; [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1;
	; entered by jrcc from 6C:5B66 (executed)
	ld a, [hli]
	dec a
	ld [wRam_C0E6], a
	jr .loop

.l5B8F ; 6C:5B8F
	; [CONFIRMED] 49 insn(s); 49 executed (in up to 12/18 scenarios)
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [wRam_C1AB]
	cp a, $02
	jr nz, .loop
	add hl, bc
	jr .loop
.l5B9D ; 6C:5B9D
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	push hl
	add hl, bc
	ld a, l
	ld [wRam_C1B0], a
	ld a, h
	ld [wRam_C1B1], a
	pop hl
	jp .loop
.l5BAF ; 6C:5BAF
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	ld b, [hl]
	inc hl
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	farcall WriteByteFar
	pop hl
	jr .loop
.l5BC7 ; 6C:5BC7
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	call ReadByteFar
	pop hl
	ld b, [hl]
	inc hl
	cp a, b
	jr nz, .l5C06
	jr .l5B81

.l5BDF ; 6C:5BDF
	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 1;
	; entered by jrcc from 6C:5B7B (PROBABLE code)
	ld a, [hli]
	and a, $0F
	ld e, a
	ld d, $00
	ld a, [hli]
	and a, $0F
	ld c, a
	ld b, $00
	push hl
	ld hl, $A684
	add hl, de
	ld a, $01
	call ReadByteFar
	ld d, a
	ld hl, $A684
	add hl, bc
	ld a, $01
	call ReadByteFar
	pop hl
	cp a, d
	jr nz, .l5C06
	jp .l5B81

.l5C06 ; 6C:5C06
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 12/18 scenarios)
	inc hl
	inc hl
	jp .loop
.l5C0B ; 6C:5C0B
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, .l5C1B
	farcall Palette_FadeOutToWhite
	ld b, $00
	ret
.l5C1B ; 6C:5C1B
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	farcall Palette_FadeOutToWhite
	ld b, $FF
	ret

.l5C34 ; 6C:5C34
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jpcc from 6C:5B57 (executed)
	ret
.l5C35 ; 6C:5C35
	ret

.l5C36 ; 6C:5C36
	; [CONFIRMED] 86 insn(s); 86 executed (in up to 12/18 scenarios)
	ld a, $01
	ld [wRam_C179], a
	ld [wRam_C0E2], a
	ld a, $06
	ld [wRam_C178], a
	xor a, a
	ld [wRam_C1A8], a
	ld [wRam_C1AB], a
	ld a, [wRam_C0D9]
	or a, a
	jr z, .l5C66
	push hl
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0041
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop hl
	xor a, a
	ld [wRam_C0D9], a
.l5C66 ; 6C:5C66
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	push hl
	ld a, $00
	ld [wRam_C1AA], a
	ld a, $00
	ld [wRam_C1A9], a
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0600
	ld hl, $D000
	call FillBytes
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	pop hl
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [hli]
	or a, a
	ld a, [hli]
	or a, a
	call nz, HelpScript_ShowPicture
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a

Label_6C_5CC5:: ; 6C:5CC5
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wRam_C0E2]
	or a, a
	jr z, .l5CEE
	call HelpScript_StepText
	or a, a
	jp nz, Label_6C_5D9F
	ld a, [wRam_C1AB]
	cp a, $01
	jr nz, .l5CEE
	ldh a, [hJoyHeld]
	bit 0, a
	jr nz, .l5CEE
	xor a, a
	ld [wRam_C1AB], a
	jr .l5CEE
.l5CEE ; 6C:5CEE
	farcall Joypad_UpdateIdleFrames
	farcall Joypad_UpdateUnsaved
	call JoypadDispatch

; ---- ptrtable $5CFD-$5D07 (10 bytes) [CONFIRMED] inline table of `call $056A` (JoypadDispatch) at 6C:5CFA: 5 entries; fixed length (5 words) by the routine; every byte read as data in a trace

HelpScript_InputTable:: ; 6C:5CFD
Table_6C_5CFD::
	dw Label_6C_5D09
	dw Label_6C_5D30
	dw Label_6C_5D5A
	dw Label_6C_5D9C
	dw Label_6C_5D07

Label_6C_5D07:: ; 6C:5D07
	; [CONFIRMED] 264 insn(s); 264 executed (in up to 12/18 scenarios)
	jr Label_6C_5CC5

Label_6C_5D09:: ; 6C:5D09
	ld a, $01
	ld [wRam_C1AB], a
	ld a, [wRam_C0E2]
	or a, a
	jr nz, Label_6C_5CC5
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $00AA
	ld hl, $DA20
	call Sprite_SetPosition
	jp Label_6C_5E03

Label_6C_5D30:: ; 6C:5D30
	ld a, $02
	ld [wRam_C1AB], a
	ld a, [wRam_C0E2]
	or a, a
	jr nz, .l5D57
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $00AA
	ld hl, $DA20
	call Sprite_SetPosition
	jp Label_6C_5E03
.l5D57 ; 6C:5D57
	jp Label_6C_5CC5

Label_6C_5D5A:: ; 6C:5D5A
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	push hl
	ld a, $01
	ld hl, $A684
	call ReadByteFar
	pop hl
	bit 7, a
	jr nz, .l5D8D
	ld a, [wHelpScriptRestartPtr]
	ld [wHelpScriptPtr], a
	ld a, [wHelpScriptRestartPtr + 1]
	ld [wHelpScriptPtr + 1], a
	farcall Palette_FadeOutToWhite
	ld b, $00
	ret
.l5D8D ; 6C:5D8D
	ld a, [wRam_C1B0]
	ld [wHelpScriptPtr], a
	ld a, [wRam_C1B1]
	ld [wHelpScriptPtr + 1], a
	jp Label_6C_5B47

Label_6C_5D9C:: ; 6C:5D9C
	jp Label_6C_5CC5

Label_6C_5D9F:: ; 6C:5D9F
	xor a, a
	ld [wRam_C0E2], a
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, .l5DC6
	ld hl, $DA20
	ld de, Table_6A_72BB
	ld a, $6A
	ld b, $80
	farcall Sprite_InitSlot
	ld de, $7880
	ld hl, $DA20
	call Sprite_SetPosition
	jp Label_6C_5CC5
.l5DC6 ; 6C:5DC6
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $9000
	ld hl, $D000
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, $D400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jp Label_6C_5D30

Label_6C_5E03:: ; 6C:5E03
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, .l5E1D
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0040
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	jp Label_6C_5B47
.l5E1D ; 6C:5E1D
	ld a, $01
	ld [wRam_C0D9], a
	jp Label_6C_5B47

HelpScript_RenderCaption:: ; 6C:5E25
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push hl
	xor a, a
	ld bc, $0180
	ld hl, $D000
	call FillBytes
	pop hl
	ld bc, $D000
	ld de, $D0C0
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $6C
	farcall TextTiles_RenderLine
	push hl
	ld de, $9600
	ld hl, $D000
	ld a, $00
	ld b, $96
	ld c, $18
	farcall Gfx_StartHDMAWithService
	pop hl
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

HelpScript_ShowPicture:: ; 6C:5E6E
	ld b, a
	ld a, [wRam_C177]
	cp a, b
	ret z
	ld c, a
	ld a, l
	ld [wRam_C10E], a
	ld a, h
	ld [wRam_C10F], a
	xor a, a
	or a, c
	jr z, .l5E8B
	push bc
	ld a, $40
	farcall Palette_FadeOutMasked
	pop bc
.l5E8B ; 6C:5E8B
	ld a, b
	ld [wRam_C177], a
	dec a
	ld b, a
	sla a
	sla a
	add a, b
	ld hl, $5F6E
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0900
	ld hl, $D000
	call FillBytes
	ld de, $8C80
	ld hl, $D480
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9080
	ld hl, $D880
	ld a, $00
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	ld a, [hli]
	ld [wRam_C110], a
	push hl
	inc hl
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wRam_C110]
	ld de, $D830
	ld bc, $0008
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D464
	ld bc, $060C
	ld de, $F806
	xor a, a
	farcall Tilemap_ApplyMaskRect
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	pop hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ldh a, [rLCDC]
	bit 7, a
	jr z, .l5F39
.loop ; 6C:5F33
	ldh a, [rLY]
	cp a, $8E
	jr nz, .loop
.l5F39 ; 6C:5F39
	ld de, $8800
	ld b, $92
	ld c, $40
	ld a, [wRam_C110]
	farcall Gfx_StartHDMAWithService
	ld bc, $0400
	add hl, bc
	ld de, $8C00
	ld b, $98
	ld c, $08
	ld a, [wRam_C110]
	farcall Gfx_StartHDMAWithService
	ld a, $40
	farcall Palette_FadeInMasked
	ld a, [wRam_C10E]
	ld l, a
	ld a, [wRam_C10F]
	ld h, a
	ret

; ---- data $5F6E-$6009 (155 bytes) [PROBABLE] 31 records x 5 bytes (61 00 40 80 7A / 61 80 44 88 7A / 61 00 49 90 7A ...; pattern flag, x, y, 7A 61-style pointer tail), read in up to 8 scenarios; 155 bytes = 31 records; the 15 and 50 byte holes are unread records of the same table

HelpScript_PictureTable:: ; 6C:5F6E
Data_6C_5F6E::
	db $61, $00, $40, $80, $7A, $61, $80, $44, $88, $7A, $61, $00, $49, $90, $7A, $61
	db $80, $4D, $98, $7A, $61, $00, $52, $A0, $7A, $61, $80, $56, $A8, $7A, $61, $00
	db $5B, $B0, $7A, $61, $80, $5F, $B8, $7A, $61, $00, $64, $C0, $7A, $61, $80, $68
	db $C8, $7A, $61, $00, $6D, $D0, $7A, $61, $80, $71, $D8, $7A, $61, $00, $76, $E0
	db $7A, $60, $00, $40, $80, $7A, $60, $80, $44, $88, $7A, $60, $00, $49, $90, $7A
	db $60, $80, $4D, $98, $7A, $60, $00, $52, $A0, $7A, $60, $80, $56, $A8, $7A, $60
	db $00, $5B, $B0, $7A, $60, $80, $5F, $B8, $7A, $60, $00, $64, $C0, $7A, $60, $80
	db $68, $C8, $7A, $60, $00, $6D, $D0, $7A, $60, $80, $71, $D8, $7A, $60, $00, $76
	db $E0, $7A, $5B, $00, $40, $80, $56, $5B, $80, $44, $88, $56, $5B, $00, $49, $90
	db $56, $5B, $80, $4D, $98, $56, $5B, $00, $52, $A0, $56

HelpScript_StepText:: ; 6C:6009
Function_6C_6009::
	; [CONFIRMED] 23 insn(s); 23 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wRam_C179]
	dec a
	ld [wRam_C179], a
	ld a, $00
	ret nz
	ld a, [wHelpScriptPtr]
	ld l, a
	ld a, [wHelpScriptPtr + 1]
	ld h, a
.l601B ; 6C:601B
	ld a, [hli]
	ld b, a
	bit 7, a
	jp nz, .l60AF
	swap a
	and a, $07
	cp a, $01
	jr c, .l603A
	jr z, .l6045
	cp a, $03
	jr c, .l605B
	jr z, .l6075
	cp a, $05
	jr c, .l607A

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 6C:6034 (executed)
	jr z, .l6090
	xor a, a
	ret

.l603A ; 6C:603A
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 11/18 scenarios)
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a
	ld a, $FF
	ret
.l6045 ; 6C:6045
	xor a, a
	ld [wRam_C1A8], a
	ld a, [wRam_C1A9]
	add a, $20
	ld [wRam_C1A9], a
	ld a, [wRam_C1AA]
	inc a
	inc a
	ld [wRam_C1AA], a
	jr .l601B
.l605B ; 6C:605B
	ld a, b
	cp a, $21
	jr c, .l6068
	jr z, .l606E

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 6C:6060 (executed)
	ld a, [hli]
	ld [wRam_C178], a
	jr .l601B

.l6068 ; 6C:6068
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 12/18 scenarios)
	xor a, a
	ld [wRam_C17A], a
	jr .l601B
.l606E ; 6C:606E
	ld a, $01
	ld [wRam_C17A], a
	jr .l601B
.l6075 ; 6C:6075
	call HelpScript_RenderCaption
	jr .l601B
.l607A ; 6C:607A
	ld a, [wRam_C1AB]
	or a, a
	jr nz, .l608C
	ld a, [wRam_C179]
	ld b, a
	ld a, [hli]
	add a, b
	ld [wRam_C179], a
	jp .l618E
.l608C ; 6C:608C
	inc hl
	jp .l601B

.l6090 ; 6C:6090
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1;
	; entered by jrcc from 6C:6036 (PROBABLE code)
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, .l608C
	ld a, [hli]
	or a, a
	jr z, .l60A9
	ld [wRam_C17B], a
	ld [wRam_C17C], a
	ld a, $01
	ld [wRam_C176], a
	jp .l601B
.l60A9 ; 6C:60A9
	ld [wRam_C176], a
	jp .l601B

.l60AF ; 6C:60AF
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 12/18 scenarios)
	ld a, b
	cp a, $A0
	jr c, .l60C6
	push hl
	ld hl, $58C7
	sub a, $A0
	add a, a
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld b, [hl]
	inc hl
	ld c, [hl]
	jr .l60C9
.l60C6 ; 6C:60C6
	ld c, [hl]
	inc hl
	push hl
.l60C9 ; 6C:60C9
	ld a, [wRam_C17A]
	push af
	ld a, [wRam_C1A8]
	cp a, $10
	jr nz, .l60EB

	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0;
	; fall-through of the jrcc at 6C:60D2 (executed) [executed in 2 scenarios]
	xor a, a
	ld [wRam_C1A8], a
	ld a, [wRam_C1A9]
	add a, $20
	ld [wRam_C1A9], a
	ld a, [wRam_C1AA]
	inc a
	inc a
	ld [wRam_C1AA], a
	ld a, [wRam_C1A8]

.l60EB ; 6C:60EB
	; [CONFIRMED] 107 insn(s); 107 executed (in up to 12/18 scenarios)
	ld e, a
	ld a, [wRam_C1A9]
	add a, e
	swap a
	ld d, a
	and a, $F0
	ld e, a
	ld a, d
	and a, $0F
	ld d, a
	push de
	ld a, d
	or a, $D0
	ld d, a
	push de
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $0003
	push hl
	ld hl, $0100
	add hl, de
	push hl
	ld hl, $0003
	push hl
	push de
	push bc
	farcall Font_BlitGlyph8x16
	add sp, 10
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	pop de
	pop af
	or a, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	jr z, .l6158
	ld c, $08
.l6142 ; 6C:6142
	ld a, [hli]
	xor a, a
	ld [hli], a
	dec c
	jr nz, .l6142
	ld bc, $00F0
	add hl, bc
	ld c, $08
.l614E ; 6C:614E
	ld a, [hli]
	xor a, a
	ld [hli], a
	dec c
	jr nz, .l614E
	ld bc, $FEF0
	add hl, bc
.l6158 ; 6C:6158
	ld a, [wRam_C1AB]
	cp a, $02
	jr z, .l6198
	ld a, $90
	add a, d
	ld d, a
	ld b, $97
	ld c, $11
	xor a, a
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C1AB]
	cp a, $01
	ld a, [wRam_C178]
	jr nz, .skip
	ld a, $01
.skip ; 6C:6183
	ld [wRam_C179], a
	ld a, [wRam_C1A8]
	inc a
	ld [wRam_C1A8], a
	pop hl
.l618E ; 6C:618E
	ld a, l
	ld [wHelpScriptPtr], a
	ld a, h
	ld [wHelpScriptPtr + 1], a
	xor a, a
	ret
.l6198 ; 6C:6198
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wRam_C1A8]
	inc a
	ld [wRam_C1A8], a
	pop hl
	jp .l601B

Function_6C_61AC:: ; 6C:61AC
	; [PROBABLE] coherent 24-byte routine (ld hl,$C0DA ; dec [hl] ; ret nz ; ld [hl],$23 ; toggle
	; [C0D9] ; ld d,$78 ; ... ld hl,$DA20) that falls exactly into the raw far-call site at 61C4
	; (call 00:0A65); previous region ends with jp; entry not located
	ld hl, $C0DA
	dec [hl]
	ret nz
	ld [hl], $23
	ld a, [wRam_C0D9]
	xor a, $01
	ld [wRam_C0D9], a
	ld d, $78
	add a, d
	ld d, a
	ld e, $80
	ld hl, $DA20

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Sprite_SetPosition
	ret
