; engine/settings/adapter_check.asm
; bank 67, $6369-$6536 (461 bytes); pinned by layout.link
; Mobile Adapter check screen at boot

SECTION "engine/settings/adapter_check", ROMX

AdapterCheck_DrawScreen:: ; 67:6369
Function_67_6369::
	; [CONFIRMED] 126 insn(s); 126 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	ld de, $8000
	ld hl, Data_4A_5F80
	ld a, $4A
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Data_4A_6080
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Data_4A_6480
	ld a, $4A
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
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
	farcall Tilemap_CopyRectAndAttr
	ld hl, $DA00
	ld de, Data_4A_68D0
	ld a, $4A
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2838
	ld hl, $DA00
	call Sprite_SetPosition
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ret

AdapterCheck_Run:: ; 67:6401
	call AdapterCheck_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0018
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	call AdapterCheck_Poll
	farcall Palette_FadeOutToWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_PauseMusic
	pop af
	ldh [rSVBK], a
	call VBlank_WaitAndService
	ld a, [wRam_C27C]
	ret

AdapterCheck_Setup:: ; 67:6437
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	farcall AdapterCheck_DrawScreen
	ret

AdapterCheck_Poll:: ; 67:644E
	xor a, a
	ld [wRam_C286], a

AdapterCheck_Poll_Loop:: ; 67:6452
Label_67_6452::
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
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
	jr z, .l649A
	cp a, $02
	jr nz, .l649E
	ld a, [wRam_C286]
	or a, a
	jr nz, .l649E
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $01
	ld [wRam_C286], a
	jr .l649E
.l649A ; 67:649A
	xor a, a
	ld [wRam_C286], a
.l649E ; 67:649E
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

AdapterCheck_State_Init:: ; 67:64B4
	; [CONFIRMED] 114 insn(s); 114 executed (in up to 18/18 scenarios) (part of region $64B4-$65F2)
	ld de, $C271
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wRam_C27D], a
	jp AdapterCheck_Poll_Loop

AdapterCheck_State_ReadConfig:: ; 67:64C7
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, AdapterCheck_Abort
	bit 0, a
	jp nz, AdapterCheck_Poll_Loop
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
	jp AdapterCheck_Poll_Loop

AdapterCheck_State_Finish:: ; 67:64F5
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, AdapterCheck_Abort
	bit 0, a
	jp nz, AdapterCheck_Poll_Loop
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
	farcall Config_MirrorIsRegistered
	or a, a
	jr z, .l651A
	ld a, $01
	jr .l651C
.l651A ; 67:651A
	ld a, $02
.l651C ; 67:651C
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
