; engine/startup/registration.asm
; bank 65, $4123-$487C (1881 bytes); pinned by layout.link
; registration wizard and password comparison/save

SECTION "engine/startup/registration", ROMX

Registration_ReadStage:: ; 65:4123
Function_65_4123::
	; [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, sSettingsRegistrationProgress
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
	ld a, [hl]
	ld b, a
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
	xor a, $A5
	ld [wRegistrationStage], a
	cp a, $01
	ret z
	cp a, $02
	ret z

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the retcc at 65:4163 (executed)
	cp a, $03
	ret z
	xor a, a
	ld [wRegistrationStage], a
	ret

Startup_VerifySaveData:: ; 65:416C
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 12/18 scenarios)
	farcall SramCheck_Bank0Status
	cp a, $FF
	jr z, Startup_SaveDataError
	farcall Sram_VerifyChecksum3
	or a, a
	jr nz, Startup_SaveDataError
	farcall SaveCheck_Verify
	or a, a
	jr nz, Startup_SaveDataError
	jr Startup_VerifySaveData_Done

Startup_SaveDataError:: ; 65:418A
	; [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1;
	; entered by jrcc from 65:4174 (executed) [executed in 1 scenarios]
	ld a, $F0
	ld hl, $0111
	farcall CommErr_ShowScreen
	farcall SramCheck_VerifyAndRepairAll
	farcall Sram_ResetChecksum3Areas
	farcall SaveCheck_ResetBlock

Startup_VerifySaveData_Done:: ; 65:41A7
Label_65_41A7::
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 14/18 scenarios)
	jr Startup_Return

Startup_Return:: ; 65:41A9
	ret

Startup_VerifySaveDataSilent:: ; 65:41AA
Function_65_41AA::
	; [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall SramCheck_Bank0Status
	cp a, $FF
	jr nz, .l41BA
	farcall SramCheck_VerifyAndRepairAll
.l41BA ; 65:41BA
	farcall Sram_VerifyChecksum3
	or a, a
	jr z, .l41C9
	farcall Sram_ResetChecksum3Areas
.l41C9 ; 65:41C9
	farcall SaveCheck_Verify
	or a, a
	jr z, .l41D8
	farcall SaveCheck_ResetBlock
.l41D8 ; 65:41D8
	jr Startup_Return

Registration_Run:: ; 65:41DA
Function_65_41DA::
	; [CONFIRMED] 65 insn(s); 65 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Account_ClearWorkBuffers
	farcall Config_ClearSramMirror
	xor a, a
	ld [wHiddenModeFlag], a
	ld [wRam_C279], a
	ld [wRam_C27B], a
	ld a, $01
	ld [wSavePasswordFlag], a
	farcall SettingsPhone_ResetTopCursor
	farcall SettingsPhone_ResetSlotCursor
	farcall SettingsPhone_ResetMethodCursor
	ld a, [wRegistrationStage]
	cp a, $01
	jr z, .l421A
	cp a, $02
	jr z, .l421A
	farcall Settings_InitPage
	jr .l4226
.l421A ; 65:421A
	farcall Settings_ClearFieldsKeepProgress
	farcall Settings_LoadAccountToWram
.l4226 ; 65:4226
	ld hl, sSettingsFieldMask
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
	ld a, [hl]
	ld b, a
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
	xor a, $A5
	ld [wSettingsFieldMask], a
	farcall SramCheck_VerifyAndRepairAll
	farcall Sram_ResetChecksum3Areas
	farcall SaveCheck_ResetBlock
	ld a, $00
	ld [wCommNoticeMode], a
	ld a, $01
	ld [wCommNoticeGfxSet], a
	ld a, [wRegistrationStage]
	cp a, $02
	jr nz, Registration_IntroPage
	ld a, $17
	farcall Notice_ShowPage
	ld a, [wHiddenModeFlag]
	or a, a
	jp z, Registration_SummaryStep

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jpcc at 65:4290 (executed) | 3 insn(s) executed; cut out of the PROBABLE
	; region 4293-42A3 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wManualNumbersFlag]
	or a, a
	jp nz, Registration_SummaryStep_Hidden

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4293-42A3 by apply_coverage --split
	farcall SettingsPhone_ClearEntryBuffers
	jp Registration_SummaryStep

Registration_IntroPage:: ; 65:42A3
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios)
	ld a, $00
	ld b, $00
	farcall Notice_ShowPage
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $16
	cp a, $16
	jr nz, Registration_NoticePages

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0;
	; fall-through of the jrcc at 65:42B9 (executed) | 11 insn(s) executed; cut out of the PROBABLE
	; region 42BB-42E3 by apply_coverage --split [executed in 2 scenarios]
	ld a, $01
	ld [wHiddenModeFlag], a
	jp Registration_NoticePages_Hidden

Registration_IntroPage_Back:: ; 65:42C3
Label_65_42C3::
	ld a, $00
	ld b, $01
	farcall Notice_ShowPage
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $16
	cp a, $16
	jr nz, Registration_NoticePages

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 42BB-42E3 by apply_coverage --split
	ld a, $01
	ld [wHiddenModeFlag], a
	jp Registration_NoticePages_Hidden

Registration_NoticePages:: ; 65:42E3
	; [CONFIRMED] 50 insn(s); 50 executed (in up to 4/18 scenarios)
	ld hl, sSettingsHiddenAtRegistration
	ld a, [wHiddenModeFlag]
	ld b, $00
	farcall Settings_StoreByteField
	ld a, $01
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_IntroPage_Back

Registration_NoticePage2:: ; 65:42FC
Label_65_42FC::
	ld a, $02
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePages

Registration_NoticePage3:: ; 65:4307
Label_65_4307::
	ld a, $03
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePage2

Registration_NoticePage7:: ; 65:4312
Label_65_4312::
	ld a, $07
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePage3

Registration_LoginIdIntro:: ; 65:431D
Label_65_431D::
	ld a, [wHiddenModeFlag]
	or a, a
	jp nz, Registration_LoginIdIntro_Hidden
	farcall Account_LoginIdIntroPage
	or a, a
	jr z, Registration_NoticePage7

Registration_LoginIdEntry:: ; 65:432D
	farcall Account_LoginIdEntryScreen
	or a, a
	jr z, Registration_LoginIdIntro
	ld hl, wAcctLoginId
	ld de, sSettingsLoginId
	ld b, $01
	farcall Settings_StoreStringField

Registration_MailIntro:: ; 65:4344
	farcall Account_MailIntroPage
	or a, a
	jr z, Registration_LoginIdEntry

Registration_MailAddressEntry:: ; 65:434D
	farcall Account_MailAddressEntryScreen
	or a, a
	jr z, Registration_MailIntro
	ld hl, wAcctMailLocalPart
	ld de, sSettingsMailLocalPart
	ld b, $02
	farcall Settings_StoreStringField
	ld hl, wAcctMailSubdomain
	ld de, sSettingsMailSubdomain
	ld b, $02
	farcall Settings_StoreStringField

Registration_PasswordStep:: ; 65:4372
Label_65_4372::
	ld a, [wHiddenModeFlag]
	or a, a
	jr z, Registration_PasswordIntro

	; [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0;
	; fall-through of the jrcc at 65:4376 (executed) [executed in 1 scenarios]
	farcall Account_PasswordIntroPage
	or a, a
	jp z, Registration_PhoneMethodMenu
	jr Registration_PasswordEntry

Registration_PasswordIntro:: ; 65:4384
	; [CONFIRMED] 52 insn(s); 52 executed (in up to 3/18 scenarios)
	farcall Account_PasswordIntroPage
	or a, a
	jr z, Registration_MailAddressEntry

Registration_PasswordEntry:: ; 65:438D
	ld hl, wAcctPassword
	ld de, wAcctPasswordEntry
	farcall Wram3_CopyString
	xor a, a
	farcall Account_PasswordEntryScreen
	push af
	call Password_ClearConfirmIfEdited
	ld hl, wAcctPasswordEntry
	ld de, wAcctPassword
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Registration_PasswordStep
	ld hl, wAcctPasswordConfirm
	ld de, wAcctPasswordEntry
	farcall Wram3_CopyString
	ld a, $01
	farcall Account_PasswordEntryScreen
	push af
	ld hl, wAcctPasswordEntry
	ld de, wAcctPasswordConfirm
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Registration_PasswordEntry
	farcall Password_CompareEntries
	ld a, b
	or a, a
	jr z, Registration_PasswordAccepted
	ld a, $F0
	ld hl, $0010
	farcall CommErr_ShowScreen
	ld hl, wAcctPassword
	farcall Wram3_ClearByte
	ld hl, wAcctPasswordConfirm
	farcall Wram3_ClearByte
	jr Registration_PasswordEntry

Registration_PasswordAccepted:: ; 65:4402
	ld hl, wAcctPassword
	ld de, sSettingsPassword
	ld b, $04
	farcall Settings_StoreStringField

Registration_PwSaveConfirm:: ; 65:4410
Label_65_4410::
	xor a, a
	farcall PwSaveConfirm_Run
	or a, a
	jp z, Registration_PasswordEntry
	cp a, $02
	jr z, .l4423
	ld a, $01
	jr .l4424

.l4423 ; 65:4423
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 65:441D (executed)
	xor a, a

.l4424 ; 65:4424
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 3/18 scenarios)
	ld [wSavePasswordFlag], a
	ld hl, sSettingsSavePasswordFlag
	ld a, [wSavePasswordFlag]
	ld b, $00
	farcall Settings_StoreByteField

Registration_SummaryStep:: ; 65:4435
	farcall Account_ConfirmScreen
	or a, a
	jp z, Registration_PwSaveConfirm
	cp a, $02
	jp z, Registration_LoginIdIntro
	xor a, a
	ld [wManualNumbersFlag], a
	jp Registration_Communicate

Registration_IntroPage_Back_Hidden:: ; 65:444B
Label_65_444B::
	; [PROBABLE] 164 insn(s) reached by static flow only; seeds: exec x164; min discovery hops 1;
	; entered by jrcc from 65:446C (PROBABLE code) | 3 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 444B-4642 by apply_coverage --split
	ld a, $00
	ld b, $01
	farcall Notice_ShowPage

Registration_NoticePages_Hidden:: ; 65:4455
	; [CONFIRMED] 147 insn(s) executed; cut out of the PROBABLE region 444B-4642 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, sSettingsHiddenAtRegistration
	ld a, [wHiddenModeFlag]
	ld b, $00
	farcall Settings_StoreByteField
	ld a, $01
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_IntroPage_Back_Hidden

Registration_NoticePage2_Hidden:: ; 65:446E
Label_65_446E::
	ld a, $02
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePages_Hidden

Registration_NoticePage3_Hidden:: ; 65:4479
Label_65_4479::
	ld a, $03
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePage2_Hidden

Registration_NoticePage7_Hidden:: ; 65:4484
Label_65_4484::
	ld a, $07
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePage3_Hidden

Registration_LoginIdIntro_Hidden:: ; 65:448F
Label_65_448F::
	farcall Account_LoginIdIntroPage
	or a, a
	jr z, Registration_NoticePage7_Hidden

Registration_LoginIdEntry_Hidden:: ; 65:4498
Label_65_4498::
	farcall Account_LoginIdEntryScreen
	or a, a
	jr z, Registration_LoginIdIntro_Hidden
	ld hl, wAcctLoginId
	ld de, sSettingsLoginId
	ld b, $01
	farcall Settings_StoreStringField

Registration_MailIntro_Hidden:: ; 65:44AF
Label_65_44AF::
	farcall Account_MailIntroPage
	or a, a
	jr z, Registration_LoginIdEntry_Hidden

Registration_MailAddressEntry_Hidden:: ; 65:44B8
Label_65_44B8::
	farcall Account_MailAddressEntryScreen
	or a, a
	jr z, Registration_MailIntro_Hidden
	ld hl, wAcctMailLocalPart
	ld de, sSettingsMailLocalPart
	ld b, $02
	farcall Settings_StoreStringField
	ld hl, wAcctMailSubdomain
	ld de, sSettingsMailSubdomain
	ld b, $02
	farcall Settings_StoreStringField

Registration_PhoneMethodMenu:: ; 65:44DD
	ld a, $01
	farcall SettingsPhone_ChoiceMenu
	or a, a
	jr z, .l44FC
	cp a, $01
	jp z, .l4511
	ld hl, sSettingsManualNumbersFlag
	ld a, $01
	ld b, $00
	farcall Settings_StoreByteField
	jr Registration_ManualPhoneEntry
.l44FC ; 65:44FC
	ld hl, sSettingsManualNumbersFlag
	ld a, $01
	ld b, $00
	farcall Settings_StoreByteField
	farcall SettingsPhone_ClearEntryBuffers
	jr Registration_MailAddressEntry_Hidden
.l4511 ; 65:4511
	ld hl, sSettingsManualNumbersFlag
	xor a, a
	ld b, $00
	farcall Settings_StoreByteField
	farcall SettingsPhone_ClearEntryBuffers
	jp Registration_PasswordStep

Registration_ManualPhoneEntry:: ; 65:4526
	ld a, $0C
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_PhoneMethodMenu

Registration_PhoneKeypad0:: ; 65:4531
Label_65_4531::
	ld a, $00
	farcall PhoneKeypad_Run
	or a, a
	jr z, Registration_ManualPhoneEntry
	ld hl, wAcctNumberInternet
	ld de, sSettingsNumberInternet
	ld b, $08
	farcall Settings_StoreStringField

Registration_PhoneKeypad1:: ; 65:454A
Label_65_454A::
	ld a, $01
	farcall PhoneKeypad_Run
	or a, a
	jr z, Registration_PhoneKeypad0
	ld hl, wAcctNumberSelfPage
	ld de, sSettingsNumberSelfPage
	ld b, $10
	farcall Settings_StoreStringField

Registration_PhoneComment:: ; 65:4563
Label_65_4563::
	farcall PhoneComment_KeyboardRun
	or a, a
	jr z, Registration_PhoneKeypad1
	ld hl, wAcctNumberComment
	ld de, sSettingsNumberComment
	ld b, $20
	farcall Settings_StoreStringField

Registration_PasswordIntro_Hidden:: ; 65:457A
Label_65_457A::
	xor a, a
	farcall Account_PasswordIntroPage
	or a, a
	jr z, Registration_PhoneComment

Registration_PasswordEntry_Hidden:: ; 65:4584
Label_65_4584::
	ld hl, wAcctPassword
	ld de, wAcctPasswordEntry
	farcall Wram3_CopyString
	xor a, a
	farcall Account_PasswordEntryScreen
	push af
	call Password_ClearConfirmIfEdited
	ld hl, wAcctPasswordEntry
	ld de, wAcctPassword
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Registration_PasswordIntro_Hidden
	ld hl, wAcctPasswordConfirm
	ld de, wAcctPasswordEntry
	farcall Wram3_CopyString
	ld a, $01
	farcall Account_PasswordEntryScreen
	push af
	ld hl, wAcctPasswordEntry
	ld de, wAcctPasswordConfirm
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Registration_PasswordEntry_Hidden
	farcall Password_CompareEntries
	ld a, b
	or a, a
	jr z, .l45F9
	ld a, $F0
	ld hl, $0010
	farcall CommErr_ShowScreen
	ld hl, wAcctPassword
	farcall Wram3_ClearByte
	ld hl, wAcctPasswordConfirm
	farcall Wram3_ClearByte
	jr Registration_PasswordEntry_Hidden
.l45F9 ; 65:45F9
	ld hl, wAcctPassword
	ld de, sSettingsPassword
	ld b, $04
	farcall Settings_StoreStringField

Registration_PwSaveConfirm_Hidden:: ; 65:4607
Label_65_4607::
	xor a, a
	farcall PwSaveConfirm_Run
	or a, a
	jp z, Registration_PasswordEntry_Hidden
	cp a, $02
	jr z, .l461A
	ld a, $01
	jr .l461B

.l461A ; 65:461A
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 444B-4642 by apply_coverage --split
	xor a, a

.l461B ; 65:461B
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 444B-4642 by apply_coverage
	; --split [executed in 2 scenarios]
	ld [wSavePasswordFlag], a
	ld hl, sSettingsSavePasswordFlag
	ld a, [wSavePasswordFlag]
	ld b, $00
	farcall Settings_StoreByteField

Registration_SummaryStep_Hidden:: ; 65:462C
Label_65_462C::
	farcall Account_ConfirmManualScreen
	or a, a
	jp z, Registration_PwSaveConfirm_Hidden
	cp a, $02
	jp z, Registration_LoginIdIntro_Hidden
	ld a, $01
	ld [wManualNumbersFlag], a
	jr Registration_Communicate

Registration_Communicate:: ; 65:4642
	; [CONFIRMED] 46 insn(s); 46 executed (in up to 3/18 scenarios)
	farcall Settings_SetProgressState2
	ld b, $00
	ld a, $01
	ld hl, sSavedPasswordLen
	farcall WriteByteFar
	ld a, [wSavePasswordFlag]
	or a, a
	jr z, .l4661
	farcall Registration_SavePassword
.l4661 ; 65:4661
	farcall Registration_WriteConfigToAdapter
	or a, a
	jp z, Registration_Aborted
	farcall Settings_UpdateChecksumAndBackup
	xor a, a
	farcall Account_ActionConfirmPage
	cp a, $01
	jr nz, Registration_Aborted
	farcall Registration_VerifyAndFinalizeOnline
	or a, a
	jr z, Registration_Aborted
	ld b, $00
	farcall Settings_SetSelectedDialEntry
	farcall Settings_StoreAdapterType
	farcall Settings_StoreMailAddress
	farcall Settings_SetProgressState3
	ld a, [wHiddenModeFlag]
	farcall Settings_SetHiddenModeFlag
	farcall Settings_UpdateChecksumAndBackup
	xor a, a
	ld b, a
	farcall Account_ResultPage

Registration_WelcomePages:: ; 65:46B6
	ld a, $05
	farcall Notice_ShowPage
	ld a, $06
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_WelcomePages
	ret

Registration_Aborted:: ; 65:46CA
	farcall OnlineTimer_HasElapsed
	or a, a
	jr z, .l46DD
	ld a, $04
	ld b, $01
	farcall Account_ResultPage
.l46DD ; 65:46DD
	ld a, $04
	farcall Notice_ShowPage

	; [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; entry
	; not recorded
	farcall Dev_InstallTestConfig
.loop ; 65:46EB
	ld a, $05
	farcall Notice_ShowPage
	ld a, $06
	farcall Notice_ShowPage
	or a, a
	jr z, .loop
	ret

Password_CopyConfirmToPassword:: ; 65:46FF
Function_65_46FF::
	; [HYPOTHESIS] sibling of the executed Function_65_473F (same 32-byte shape: save FFF2/FF8D,
	; switch WRAM bank 3, call $14BF with hl=$DECB de=$DEB9, restore); clean decode to ret; no
	; caller or table entry found in the ROM (raw far-call/call/word scan), so entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPasswordConfirm
	ld de, wAcctPassword
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Password_CopyConfirmToNew:: ; 65:471F
Function_65_471F::
	; [HYPOTHESIS] sibling of the executed Function_65_473F (same shape, de=$DEC2); clean decode to
	; ret; no caller or table entry found, entry unproven
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPasswordConfirm
	ld de, wAcctPasswordNew
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

Password_CompareEntries:: ; 65:473F
Function_65_473F::
	; [CONFIRMED] 108 insn(s); 108 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPassword
	ld de, wAcctPasswordConfirm
	call CompareString
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret

Password_ClearConfirmIfEdited:: ; 65:4761
Function_65_4761::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPassword
	ld de, wAcctPasswordEntry
	call CompareString
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	jr z, .done
	ld hl, wAcctPasswordConfirm
	farcall Wram3_ClearByte
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	xor a, a
	ld [wRam_C279], a
	ld a, [wSettingsFieldMask]
	ld b, a
	ld a, $04
	xor a, $FF
	and a, b
	ld [wSettingsFieldMask], a
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
.done ; 65:47C7
	ret

Password_CompareNewAndConfirm:: ; 65:47C8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPasswordConfirm
	ld de, wAcctPasswordNew
	call CompareString
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret

Registration_SavePassword:: ; 65:47EA
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAcctPassword
	ld de, wRam_C28F
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, wRam_C28F
	call StringLength
	ld a, c
	ld de, wRam_C28F
	farcall SavedPassword_Store
	ret

Startup_VerifySaveDataDeadVariant:: ; 65:481A
Function_65_481A::
	; [PROBABLE] 37 insn(s) reached by static flow only; seeds: site x37; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall Settings_VerifyAndRepair
	cp a, $02
	jr z, .l4852
	cp a, $03
	jr z, .l485D
	farcall Sram_VerifyChecksum3
	or a, a
	jr nz, .l4852
	farcall SaveCheck_Verify
	or a, a
	jr nz, .l4852
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $04
	call $21A0
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	cp a, $00
	jr nz, .l4852
	ret
.l4852 ; 65:4852
	ld a, $F0
	ld hl, $0111
	farcall CommErr_ShowScreen
.l485D ; 65:485D
	farcall Sram_ResetChecksum3Areas
	farcall SaveCheck_ResetBlock
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	call $21A0
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
