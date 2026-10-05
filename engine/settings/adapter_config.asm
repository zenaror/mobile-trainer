; engine/settings/adapter_config.asm
; bank 67, $53DC-$570C (816 bytes); pinned by layout.link
; adapter config read/write state machines, config image patching, address tables

SECTION "engine/settings/adapter_config", ROMX

SettingsPhone_ReadAdapterConfig:: ; 67:53DC
	; [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 3;
	; entered by far from 67:4019 (PROBABLE code) [executed in 2 scenarios]
	call SettingsPhone_ReadAdapterConfig_Setup
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0018
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	call SettingsPhone_ReadAdapterConfig_Poll
	farcall Palette_FadeOutToWhite
	ld a, [wAdapterConfig_Result]
	ret

SettingsPhone_ReadAdapterConfig_Setup:: ; 67:5402
	xor a, a
	ld [wAdapterConfig_Result], a
	ld [wAdapterConfig_State], a
	farcall AdapterCheck_DrawScreen
	ret

SettingsPhone_ReadAdapterConfig_Poll:: ; 67:5410
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
	jr z, .l5458
	cp a, $02
	jr nz, .l545C
	ld a, [wAdapterConfig_SfxFlag]
	or a, a
	jr nz, .l545C
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $01
	ld [wAdapterConfig_SfxFlag], a
	jr .l545C
.l5458 ; 67:5458
	xor a, a
	ld [wAdapterConfig_SfxFlag], a
.l545C ; 67:545C
	ld a, [wAdapterConfig_State]
	add a, a
	add a, $6C
	ld l, a
	ld a, $54
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $546C-$5472 (6 bytes) [PROBABLE] jump table of 3 words right after the 'jp hl' dispatcher (ld a,[$C27D]; add a,a; add a,$6C; ... ld a,[hli]; ld h,[hl]; ld l,a; jp hl) at 67:54:545C-546B; extent = first target (5472); targets $5472, $5484, $54B9 are instruction starts of the code that follows

SettingsPhone_ReadAdapterConfig_StateTable:: ; 67:546C
Table_67_546C::
	dw SettingsPhone_ReadAdapterConfig_State_Init
	dw SettingsPhone_ReadAdapterConfig_State_ReadConfig
	dw SettingsPhone_ReadAdapterConfig_State_Finish

SettingsPhone_ReadAdapterConfig_State_Init:: ; 67:5472
Label_67_5472::
	; [CONFIRMED] entered through Table_67_546C (state handlers indexed by [$C27D]); decode chain
	; legal, all 3 table targets are instruction starts, ends in known code region at 54DB; not
	; executed in traces [executed in 2 scenarios]
	ld de, wMobileAdapterType
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wAdapterConfig_State], a
	jr SettingsPhone_ReadAdapterConfig_Poll

SettingsPhone_ReadAdapterConfig_State_ReadConfig:: ; 67:5484
Label_67_5484::
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, SettingsPhone_ReadAdapterConfig_Abort
	bit 0, a
	jp nz, SettingsPhone_ReadAdapterConfig_Poll
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld bc, $00C0
	ld de, sConfigImage
	ld a, $38
	call MobileAPI
	ld a, $02
	ld [wAdapterConfig_State], a
	jp SettingsPhone_ReadAdapterConfig_Poll

SettingsPhone_ReadAdapterConfig_State_Finish:: ; 67:54B9
Label_67_54B9::
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, SettingsPhone_ReadAdapterConfig_Abort
	bit 0, a
	jp nz, SettingsPhone_ReadAdapterConfig_Poll
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI

	; [CONFIRMED] 92 insn(s) reached by static flow only; seeds: exec x60, site x32; min discovery
	; hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with
	; decoded code | 6 insn(s) executed; cut out of the PROBABLE region 54DB-55B8 by apply_coverage
	; --split [executed in 2 scenarios]
	farcall Config_MirrorChecksumOk
	or a, a
	jr z, .l54ED
	farcall Config_MirrorIsRegistered
	or a, a
	jr nz, .l5503

.l54ED ; 67:54ED
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 54DB-55B8 by apply_coverage --split
	farcall Palette_FadeOutToWhite
	ld a, $F0
	ld hl, $0100
	farcall CommErr_ShowScreen
	xor a, a
	ld [wAdapterConfig_Result], a
	ret

.l5503 ; 67:5503
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 54DB-55B8 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	ld [wAdapterConfig_Result], a
	ret

SettingsPhone_ReadAdapterConfig_Abort:: ; 67:5509
Label_67_5509::
	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 54DB-55B8 by apply_coverage --split
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $36
	call MobileAPI
	farcall Mobile_ShowLastError
	xor a, a
	ld [wAdapterConfig_Result], a
	ret

SettingsPhone_WriteAdapterConfig:: ; 67:5535
	; [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 54DB-55B8 by apply_coverage
	; --split [executed in 1 scenarios]
	ld [wAdapterConfig_Slot], a
	farcall Registration_WriteConfig_Setup
	call SettingsPhone_WriteAdapterConfig_Setup
	farcall Palette_FadeInFromWhite
	call SettingsPhone_WriteAdapterConfig_Poll
	farcall Palette_FadeOutToWhite
	ld a, [wAdapterConfig_Result]
	ret

SettingsPhone_WriteAdapterConfig_Setup:: ; 67:5554
	xor a, a
	ld [wAdapterConfig_Result], a
	ld [wAdapterConfig_State], a
	ret

SettingsPhone_WriteAdapterConfig_Poll:: ; 67:555C
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
	jr z, .l55A4
	cp a, $02
	jr nz, .l55A8
	ld a, [wAdapterConfig_SfxFlag]
	or a, a
	jr nz, .l55A8
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0046
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ld a, $01
	ld [wAdapterConfig_SfxFlag], a
	jr .l55A8
.l55A4 ; 67:55A4
	xor a, a
	ld [wAdapterConfig_SfxFlag], a
.l55A8 ; 67:55A8
	ld a, [wAdapterConfig_State]
	add a, a
	add a, $B8
	ld l, a
	ld a, $55
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $55B8-$55BE (6 bytes) [PROBABLE] jump table of 3 words right after the 'jp hl' dispatcher (ld a,[$C27D]; add a,a; add a,$B8; ... ld a,[hli]; ld h,[hl]; ld l,a; jp hl) at 67:55:55A8-55B7; extent = first target (55BE); targets $55BE, $55D0, $560A are instruction starts of the code that follows

SettingsPhone_WriteAdapterConfig_StateTable:: ; 67:55B8
Table_67_55B8::
	dw SettingsPhone_WriteAdapterConfig_State_Init
	dw SettingsPhone_WriteAdapterConfig_State_PatchAndWrite
	dw SettingsPhone_WriteAdapterConfig_State_Finish

SettingsPhone_WriteAdapterConfig_State_Init:: ; 67:55BE
Label_67_55BE::
	; [CONFIRMED] entered through Table_67_55B8 (state handlers indexed by [$C27D]); decode chain
	; legal, all 3 table targets are instruction starts, ends in known code region at 562C; not
	; executed in traces [executed in 1 scenarios]
	ld de, wMobileAdapterType
	ld hl, $0067
	ld a, $02
	call MobileAPI
	ld a, $01
	ld [wAdapterConfig_State], a
	jr SettingsPhone_WriteAdapterConfig_Poll

SettingsPhone_WriteAdapterConfig_State_PatchAndWrite:: ; 67:55D0
Label_67_55D0::
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, SettingsPhone_WriteAdapterConfig_Abort
	bit 0, a
	jp nz, SettingsPhone_WriteAdapterConfig_Poll
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call SettingsPhone_PatchConfigImage
	ld c, $C0
	ld hl, sConfigImage
	ld de, $0000
	ld a, $04
	call MobileAPI
	ld a, $02
	ld [wAdapterConfig_State], a
	jp SettingsPhone_WriteAdapterConfig_Poll

SettingsPhone_WriteAdapterConfig_State_Finish:: ; 67:560A
Label_67_560A::
	ld a, [wTimerEnable]
	bit 1, a
	jp nz, SettingsPhone_WriteAdapterConfig_Abort
	bit 0, a
	jp nz, SettingsPhone_WriteAdapterConfig_Poll
	ld a, $36
	call MobileAPI
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a

	; [CONFIRMED] 20 insn(s) reached by static flow only; seeds: site x20; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 4
	; insn(s) executed; cut out of the PROBABLE region 562C-5664 by apply_coverage --split [executed
	; in 1 scenarios]
	farcall Settings_UpdateChecksumAndBackup
	ld a, $01
	ld [wAdapterConfig_Result], a
	ret

SettingsPhone_WriteAdapterConfig_Abort:: ; 67:5638
Label_67_5638::
	; [PROBABLE] 16 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 562C-5664 by apply_coverage --split
	farcall Mobile_SaveLastResult
	farcall Palette_FadeOutToWhite
	farcall Mobile_ShowLastError
	ld a, $36
	call MobileAPI
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [wAdapterConfig_Result], a
	ret

SettingsPhone_PatchConfigImage:: ; 67:5664
	; [CONFIRMED] function called by 'call $5664' at 67:55F2 (inside the table-entered PROBABLE code
	; of Table_67_55B8); reads Table_67_56FA (ld hl,$56FA, index [$C27E]) and falls into the
	; far-call site at 568C (PROBABLE code) [executed in 1 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wManualNumbersFlag]
	or a, a
	jr nz, .l5677
.l5677 ; 67:5677
	ld a, [wAdapterConfig_Slot]
	ld hl, SettingsPhone_ConfigNumberAddrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	ld hl, $DEDD

	; [CONFIRMED] 62 insn(s) reached by static flow only; seeds: site x62; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	; [executed in 1 scenarios]
	farcall PhoneNumber_PackBcd
	ld a, [wAdapterConfig_Slot]
	ld hl, SettingsPhone_ConfigCommentAddrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld d, h
	ld e, l
	ld hl, $DEFF
	ld bc, $0010
	call CopyStringMax
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [wAdapterConfig_Slot]
	ld hl, SettingsPhone_SramSelfPageAddrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $DEEE
	call EncodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ld hl, sConfigImage
	ld de, $0000
	ld b, $BE
.loop ; 67:56E3
	ld a, [hli]
	add a, e
	ld e, a
	ld a, $00
	adc a, d
	ld d, a
	dec b
	jr nz, .loop
	ld a, d
	ld [hli], a
	ld [hl], e
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- words $56FA-$570C (18 bytes) [PROBABLE] three 3-word tables of SRAM addresses at $56FA ($A076,$A08E,$A0A6), $5700 ($B014,$B025,$B036) and $5706 ($A07E,$A096,$A0AE): indexed via ld hl,$56FA / $5700 / $5706 with [$C27E]*2 (ld hl,$56FA at 67:567A, ld hl,$5706 at 67:5695, ld hl,$5700 at 67:56BE) by the function at 67:5664

SettingsPhone_ConfigNumberAddrs:: ; 67:56FA
Table_67_56FA::
	dw $A076, $A08E, $A0A6

SettingsPhone_SramSelfPageAddrs:: ; 67:5700
	dw sSettingsDialNumbers, sSettingsDialNumbers + $11, sSettingsDialNumbers + $22

SettingsPhone_ConfigCommentAddrs:: ; 67:5706
	dw $A07E, $A096, $A0AE
