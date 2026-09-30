; engine/settings/adapter_check.asm
; bank 67, $6369-$6536 (461 bytes); pinned by layout.link
; Mobile Adapter check screen at boot

SECTION "engine/settings/adapter_check", ROMX

; ---- code $6369-$64AE (325 bytes) [CONFIRMED] 126 insn(s); 126 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

AdapterCheck_DrawScreen:: ; 67:6369
Function_67_6369::
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	ld de, $8000
	ld hl, Data_4A_5F80
	ld a, $4A
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $9001
	ld hl, Data_4A_6080
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Data_4A_6480
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, $6580
	ld a, $4A
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $65C0
	ld a, $4A
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, $6600
	ld a, $4A
	farcall Function_00_08EA
	ld hl, $DA00
	ld de, Data_4A_68D0
	ld a, $4A
	ld b, $81
	farcall Function_00_0A82
	ld de, $2838
	ld hl, $DA00
	call Function_00_0A65
	ldh a, [rLCDC]
	call Function_00_082C
	ret

AdapterCheck_Run:: ; 67:6401
	call AdapterCheck_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0018
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	call AdapterCheck_Poll
	farcall Palette_FadeOutToWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20C4
	pop af
	ldh [rSVBK], a
	call Function_00_044B
	ld a, [wRam_C27C]
	ret

AdapterCheck_Setup:: ; 67:6437
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	farcall AdapterCheck_DrawScreen
	ret

AdapterCheck_Poll:: ; 67:644E
	xor a, a
	ld [wRam_C286], a

Label_67_6452:: ; 67:6452
	farcall Function_00_0956
	call Function_00_044B
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wSpriteSlots + 4]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	jr z, Label_67_649A
	cp a, $02
	jr nz, Label_67_649E
	ld a, [wRam_C286]
	or a, a
	jr nz, Label_67_649E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ld a, $01
	ld [wRam_C286], a
	jr Label_67_649E

Label_67_649A:: ; 67:649A
	xor a, a
	ld [wRam_C286], a

Label_67_649E:: ; 67:649E
	ld a, [wRam_C27D]
	add a, a
	add a, $AE
	ld l, a
	ld a, $64
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- data $64AE-$64B4 (6 bytes) [CONFIRMED] read as data by executed code (in up to 18/18 scenarios); content class unknown

AdapterCheck_StateTable:: ; 67:64AE
Data_67_64AE::
	db $B4, $64, $C7, $64, $F5, $64

; ---- code $64B4-$6536 (130 bytes) [CONFIRMED] 114 insn(s); 114 executed (in up to 18/18 scenarios) (part of region $64B4-$65F2)

AdapterCheck_State_Init:: ; 67:64B4
	ld de, $C271
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRam_C27D], a
	jp Label_67_6452

AdapterCheck_State_ReadConfig:: ; 67:64C7
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, AdapterCheck_Abort
	bit 0, a
	jp nz, Label_67_6452
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld bc, $00C0
	ld de, $A000
	ld a, $38
	call MobileAPI
	ld a, $02
	ld [wRam_C27D], a
	jp Label_67_6452

AdapterCheck_State_Finish:: ; 67:64F5
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, AdapterCheck_Abort
	bit 0, a
	jp nz, Label_67_6452
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
	farcall Config_MirrorIsRegistered
	or a, a
	jr z, Label_67_651A
	ld a, $01
	jr Label_67_651C

Label_67_651A:: ; 67:651A
	ld a, $02

Label_67_651C:: ; 67:651C
	ld [wRam_C27C], a
	ret

AdapterCheck_Abort:: ; 67:6520
	farcall Mobile_SaveLastResult
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
	xor a, a
	ld [wRam_C27C], a
	ret
