; engine/startup/startup.asm
; bank 65, $4000-$4123 (291 bytes); pinned by layout.link
; Startup_Run and its status jump tables

SECTION "engine/startup/startup", ROMX

Startup_Run:: ; 65:4000
Function_65_4000::
	; [CONFIRMED] 27 insn(s); 27 executed (in up to 18/18 scenarios); entry proven: target of an
	; executed call/far call
	call Boot_ReinitRuntimeFar
	farcall Sram_SnapshotA9F0PairsAtBoot
	farcall Sram_ClearMenuCursorMemory
	farcall Settings_ClearVariableBlock
	xor a, a
	ld [wCommSessionActive], a
	ld hl, $C2D2
	ld [hli], a
	ld [hl], a
	ld hl, $C2D4
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wManualNumbersFlag], a
	farcall AdapterCheck_Run
	add a, a
	add a, $3C
	ld l, a
	ld a, $40
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- data $403C-$4042 (6 bytes) [CONFIRMED] read as data by executed code (in up to 12/18 scenarios); content class unknown

Startup_StatusJumpTable:: ; 65:403C
Data_65_403C::
	db $42, $40, $78, $40, $CF, $40

Startup_NoAdapter:: ; 65:4042
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 2/18 scenarios)
	farcall Settings_GetRegistrationProgress
	add a, a
	add a, $6E
	ld l, a
	ld a, $40
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

Startup_NoAdapter_Continue:: ; 65:4055
Label_65_4055::
	; [PROBABLE] code entries 4055 (jp $416C) and 4058 (ld a,$F0 ; ld hl,$0110, falls into the
	; far-call site 405D): both are words of Table_65_406E (word 4055 at 65:4076, 4058 at 65:4070);
	; clean decode
	jp Startup_VerifySaveData

Startup_NoAdapter_ShowInfoError:: ; 65:4058
Label_65_4058::
	ld a, $F0
	ld hl, $0110

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: site x1; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall CommErr_ShowScreen

Startup_NoAdapterScreen:: ; 65:4063
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)
	farcall NoAdapter_ShowScreen
	ld a, $11
	jp Entry

; ---- ptrtable $406E-$4078 (10 bytes) [PROBABLE] 5 code pointers (4063 4058 4063 4063 4055), index = A of the dispatcher at 4042-4055 (ends with jp hl; 406E-4070 read by the executed code, 4070-4078 not read in traces); jump table of the dispatcher just above (add a,a ; add a,LOW ; ld l,a ; ld a,HIGH ; adc a,0 ; ld h,a ; ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl); targets all decode cleanly

Startup_NoAdapterJumpTable:: ; 65:406E
Table_65_406E::
	dw Startup_NoAdapterScreen
	dw Startup_NoAdapter_ShowInfoError
	dw Startup_NoAdapterScreen
	dw Startup_NoAdapterScreen
	dw Startup_NoAdapter_Continue

Startup_ConfigValid:: ; 65:4078
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 12/18 scenarios)
	farcall Settings_GetRegistrationProgress
	add a, a
	add a, $C5
	ld l, a
	ld a, $40
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

Startup_ConfigValid_Continue:: ; 65:408B
	jp Startup_VerifySaveData

Startup_ConfigValid_ShowInfoError:: ; 65:408E
	; [PROBABLE] code entry 408E = word of Table_65_40C5 (dispatcher 4078-408B, jp hl); ld a,$F0 ;
	; ld hl,$0110 falls into the far-call site 4093
	ld a, $F0
	ld hl, $0110

	; [PROBABLE] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall CommErr_ShowScreen
	xor a, a
	ld [wRegistrationStage], a
	ld [wSettingsFieldMask], a
	call Registration_Run
	jp Startup_Return

Startup_ConfigValid_Fresh:: ; 65:40A6
	; [PROBABLE] entry 40A6 = word of Table_65_40C5 (dispatcher 4078-408B); xor a ; ld [$C277],a ;
	; ld [$C278],a ; call $41DA ; jp $41A9 | forced execution: 4/5 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	xor a, a
	ld [wRegistrationStage], a
	ld [wSettingsFieldMask], a
	call Registration_Run
	jp Startup_Return

Startup_ConfigValid_Resume:: ; 65:40B3
	; [PROBABLE] entry 40B3 = word of Table_65_40C5; call $4123 ; call $41DA ; jp $41A9
	call Registration_ReadStage
	call Registration_Run
	jp Startup_Return

Startup_ConfigValid_ResumeCopy:: ; 65:40BC
	; [PROBABLE] entry 40BC = word of Table_65_40C5; call $4123 ; call $41DA ; jp $41A9
	call Registration_ReadStage
	call Registration_Run
	jp Startup_Return

; ---- ptrtable $40C5-$40CF (10 bytes) [PROBABLE] 5 code pointers (40A6 408E 40B3 40BC 408B) indexed by the dispatcher 4078-408B (add a,a ; add a,$C5 ; ... jp hl); 40CD-40CF read in traces; all targets decode cleanly

Startup_ConfigValidJumpTable:: ; 65:40C5
Table_65_40C5::
	dw Startup_ConfigValid_Fresh
	dw Startup_ConfigValid_ShowInfoError
	dw Startup_ConfigValid_Resume
	dw Startup_ConfigValid_ResumeCopy
	dw Startup_ConfigValid_Continue

Startup_ConfigBlank:: ; 65:40CF
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 5/18 scenarios)
	farcall Settings_GetRegistrationProgress
	add a, a
	add a, $19
	ld l, a
	ld a, $41
	adc a, $00
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

Startup_ConfigBlank_ShowInfoError:: ; 65:40E2
	; [CONFIRMED] code entry 40E2 = word of Table_65_4119 (dispatcher 40CF-40E2, jp hl); ld a,$F0 ;
	; ld hl,$0100 falls into the far-call site 40E7 [executed in 1 scenarios]
	ld a, $F0
	ld hl, $0100

	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: site x6; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 5
	; insn(s) executed; cut out of the PROBABLE region 40E7-40FA by apply_coverage --split [executed
	; in 1 scenarios]
	farcall CommErr_ShowScreen
	xor a, a
	ld [wRegistrationStage], a
	ld [wSettingsFieldMask], a
	call Registration_Run

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 40E7-40FA by apply_coverage --split
	jp Startup_Return

Startup_ConfigBlank_Fresh:: ; 65:40FA
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 4/18 scenarios)
	xor a, a
	ld [wRegistrationStage], a
	ld [wSettingsFieldMask], a
	call Registration_Run
	jp Startup_Return

Startup_ConfigBlank_Resume:: ; 65:4107
	; [CONFIRMED] code entry 4107 = word of Table_65_4119; call $4123 ; call $41DA ; jp $41A9 | 2
	; insn(s) executed; cut out of the PROBABLE region 4107-4110 by apply_coverage --split [executed
	; in 3 scenarios]
	call Registration_ReadStage
	call Registration_Run

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4107-4110 by apply_coverage --split
	jp Startup_Return

Startup_ConfigBlank_ResumeCopy:: ; 65:4110
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	call Registration_ReadStage
	call Registration_Run
	jp Startup_Return

; ---- ptrtable $4119-$4123 (10 bytes) [PROBABLE] 5 code pointers (40FA 40E2 4107 4110 40E2) indexed by the dispatcher 40CF-40E2 (add a,a ; add a,$19 ; ... jp hl); 4119-411B and 411F-4121 read in traces; targets decode cleanly

Startup_ConfigBlankJumpTable:: ; 65:4119
Table_65_4119::
	dw Startup_ConfigBlank_Fresh
	dw Startup_ConfigBlank_ShowInfoError
	dw Startup_ConfigBlank_Resume
	dw Startup_ConfigBlank_ResumeCopy
	dw Startup_ConfigBlank_ShowInfoError
