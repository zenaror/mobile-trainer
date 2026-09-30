; engine/startup/registration.asm
; bank 65, $4123-$487C (1881 bytes); pinned by layout.link
; registration wizard and password comparison/save

SECTION "engine/startup/registration", ROMX

; ---- code $4123-$4164 (65 bytes) [CONFIRMED] 34 insn(s); 34 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Registration_ReadStage:: ; 65:4123
Function_65_4123::
	ld hl, $B010
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
	ld [wRam_C277], a
	cp a, $01
	ret z
	cp a, $02
	ret z

; ---- code $4164-$416C (8 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the retcc at 65:4163 (executed)
	cp a, $03
	ret z
	xor a, a
	ld [wRam_C277], a
	ret

; ---- code $416C-$418A (30 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 12/18 scenarios)

Startup_VerifySaveData:: ; 65:416C
	farcall SramCheck_Bank0Status
	cp a, $FF
	jr z, Startup_SaveDataError
	farcall Sram_VerifyChecksum3
	or a, a
	jr nz, Startup_SaveDataError
	farcall SaveCheck_Verify
	or a, a
	jr nz, Startup_SaveDataError
	jr Label_65_41A7

; ---- code $418A-$41A7 (29 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1; entered by jrcc from 65:4174 (executed) [executed in 1 scenarios]

Startup_SaveDataError:: ; 65:418A
	ld a, $F0
	ld hl, $0111
	farcall CommErr_ShowScreen
	farcall SramCheck_VerifyAndRepairAll
	farcall Sram_ResetChecksum3Areas
	farcall SaveCheck_ResetBlock

; ---- code $41A7-$41AA (3 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 14/18 scenarios)

Label_65_41A7:: ; 65:41A7
	jr Startup_Return

Startup_Return:: ; 65:41A9
	ret

; ---- code $41AA-$41DA (48 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: site x13; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code

Function_65_41AA:: ; 65:41AA
	farcall SramCheck_Bank0Status
	cp a, $FF
	jr nz, Label_65_41BA
	farcall SramCheck_VerifyAndRepairAll

Label_65_41BA:: ; 65:41BA
	farcall Sram_VerifyChecksum3
	or a, a
	jr z, Label_65_41C9
	farcall Sram_ResetChecksum3Areas

Label_65_41C9:: ; 65:41C9
	farcall SaveCheck_Verify
	or a, a
	jr z, Label_65_41D8
	farcall SaveCheck_ResetBlock

Label_65_41D8:: ; 65:41D8
	jr Startup_Return

; ---- code $41DA-$4293 (185 bytes) [CONFIRMED] 65 insn(s); 65 executed (in up to 5/18 scenarios); entry proven: target of an executed call/far call

Registration_Run:: ; 65:41DA
Function_65_41DA::
	farcall Account_ClearWorkBuffers
	farcall Config_ClearSramMirror
	xor a, a
	ld [wHiddenModeFlag], a
	ld [wRam_C279], a
	ld [wRam_C27B], a
	ld a, $01
	ld [wRam_C27A], a
	farcall SettingsPhone_ResetTopCursor
	farcall SettingsPhone_ResetSlotCursor
	farcall SettingsPhone_ResetMethodCursor
	ld a, [wRam_C277]
	cp a, $01
	jr z, Label_65_421A
	cp a, $02
	jr z, Label_65_421A
	farcall Settings_InitPage
	jr Label_65_4226

Label_65_421A:: ; 65:421A
	farcall Settings_ClearFieldsKeepProgress
	farcall Settings_LoadAccountToWram

Label_65_4226:: ; 65:4226
	ld hl, $B0BE
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
	ld [wRam_C1D0], a
	ld a, $01
	ld [wRam_C1D1], a
	ld a, [wRam_C277]
	cp a, $02
	jr nz, Registration_IntroPage
	ld a, $17
	farcall Notice_ShowPage
	ld a, [wHiddenModeFlag]
	or a, a
	jp z, Registration_SummaryStep

; ---- code $4293-$429A (7 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jpcc at 65:4290 (executed) | 3 insn(s) executed; cut out of the PROBABLE region 4293-42A3 by apply_coverage --split [executed in 1 scenarios]
	ld a, [wManualNumbersFlag]
	or a, a
	jp nz, Label_65_462C

; ---- code $429A-$42A3 (9 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4293-42A3 by apply_coverage --split
	farcall SettingsPhone_ClearEntryBuffers
	jp Registration_SummaryStep

; ---- code $42A3-$42BB (24 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios)

Registration_IntroPage:: ; 65:42A3
	ld a, $00
	ld b, $00
	farcall Notice_ShowPage
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $16
	cp a, $16
	jr nz, Registration_NoticePages

; ---- code $42BB-$42DB (32 bytes) [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 0; fall-through of the jrcc at 65:42B9 (executed) | 11 insn(s) executed; cut out of the PROBABLE region 42BB-42E3 by apply_coverage --split [executed in 2 scenarios]
	ld a, $01
	ld [wHiddenModeFlag], a
	jp Registration_NoticePages_Hidden

Label_65_42C3:: ; 65:42C3
	ld a, $00
	ld b, $01
	farcall Notice_ShowPage
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	and a, $16
	cp a, $16
	jr nz, Registration_NoticePages

; ---- code $42DB-$42E3 (8 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 42BB-42E3 by apply_coverage --split
	ld a, $01
	ld [wHiddenModeFlag], a
	jp Registration_NoticePages_Hidden

; ---- code $42E3-$4378 (149 bytes) [CONFIRMED] 50 insn(s); 50 executed (in up to 4/18 scenarios)

Registration_NoticePages:: ; 65:42E3
	ld hl, $B089
	ld a, [wHiddenModeFlag]
	ld b, $00
	farcall Settings_StoreByteField
	ld a, $01
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_42C3

Label_65_42FC:: ; 65:42FC
	ld a, $02
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePages

Label_65_4307:: ; 65:4307
	ld a, $03
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_42FC

Label_65_4312:: ; 65:4312
	ld a, $07
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_4307

Label_65_431D:: ; 65:431D
	ld a, [wHiddenModeFlag]
	or a, a
	jp nz, Label_65_448F
	farcall Account_LoginIdIntroPage
	or a, a
	jr z, Label_65_4312

Registration_LoginIdEntry:: ; 65:432D
	farcall Account_LoginIdEntryScreen
	or a, a
	jr z, Label_65_431D
	ld hl, $DEA0
	ld de, $B066
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
	ld hl, $DEAB
	ld de, $B071
	ld b, $02
	farcall Settings_StoreStringField
	ld hl, $DEB4
	ld de, $B07A
	ld b, $02
	farcall Settings_StoreStringField

Label_65_4372:: ; 65:4372
	ld a, [wHiddenModeFlag]
	or a, a
	jr z, Registration_PasswordIntro

; ---- code $4378-$4384 (12 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 65:4376 (executed) [executed in 1 scenarios]
	farcall Account_PasswordIntroPage
	or a, a
	jp z, Registration_PhoneMethodMenu
	jr Registration_PasswordEntry

; ---- code $4384-$4423 (159 bytes) [CONFIRMED] 52 insn(s); 52 executed (in up to 3/18 scenarios)

Registration_PasswordIntro:: ; 65:4384
	farcall Account_PasswordIntroPage
	or a, a
	jr z, Registration_MailAddressEntry

Registration_PasswordEntry:: ; 65:438D
	ld hl, $DEB9
	ld de, $DED4
	farcall Wram3_CopyString
	xor a, a
	farcall Account_PasswordEntryScreen
	push af
	call Function_65_4761
	ld hl, $DED4
	ld de, $DEB9
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Label_65_4372
	ld hl, $DECB
	ld de, $DED4
	farcall Wram3_CopyString
	ld a, $01
	farcall Account_PasswordEntryScreen
	push af
	ld hl, $DED4
	ld de, $DECB
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
	ld hl, $DEB9
	farcall Wram3_ClearByte
	ld hl, $DECB
	farcall Wram3_ClearByte
	jr Registration_PasswordEntry

Registration_PasswordAccepted:: ; 65:4402
	ld hl, $DEB9
	ld de, $B07F
	ld b, $04
	farcall Settings_StoreStringField

Label_65_4410:: ; 65:4410
	xor a, a
	farcall PwSaveConfirm_Run
	or a, a
	jp z, Registration_PasswordEntry
	cp a, $02
	jr z, Label_65_4423
	ld a, $01
	jr Label_65_4424

; ---- code $4423-$4424 (1 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 65:441D (executed)

Label_65_4423:: ; 65:4423
	xor a, a

; ---- code $4424-$444B (39 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 3/18 scenarios)

Label_65_4424:: ; 65:4424
	ld [wRam_C27A], a
	ld hl, $B088
	ld a, [wRam_C27A]
	ld b, $00
	farcall Settings_StoreByteField

Registration_SummaryStep:: ; 65:4435
	farcall Account_ConfirmScreen
	or a, a
	jp z, Label_65_4410
	cp a, $02
	jp z, Label_65_431D
	xor a, a
	ld [wManualNumbersFlag], a
	jp Registration_Communicate

; ---- code $444B-$4455 (10 bytes) [PROBABLE] 164 insn(s) reached by static flow only; seeds: exec x164; min discovery hops 1; entered by jrcc from 65:446C (PROBABLE code) | 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 444B-4642 by apply_coverage --split

Label_65_444B:: ; 65:444B
	ld a, $00
	ld b, $01
	farcall Notice_ShowPage

; ---- code $4455-$461A (453 bytes) [CONFIRMED] 147 insn(s) executed; cut out of the PROBABLE region 444B-4642 by apply_coverage --split [executed in 1 scenarios]

Registration_NoticePages_Hidden:: ; 65:4455
	ld hl, $B089
	ld a, [wHiddenModeFlag]
	ld b, $00
	farcall Settings_StoreByteField
	ld a, $01
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_444B

Label_65_446E:: ; 65:446E
	ld a, $02
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_NoticePages_Hidden

Label_65_4479:: ; 65:4479
	ld a, $03
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_446E

Label_65_4484:: ; 65:4484
	ld a, $07
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_4479

Label_65_448F:: ; 65:448F
	farcall Account_LoginIdIntroPage
	or a, a
	jr z, Label_65_4484

Label_65_4498:: ; 65:4498
	farcall Account_LoginIdEntryScreen
	or a, a
	jr z, Label_65_448F
	ld hl, $DEA0
	ld de, $B066
	ld b, $01
	farcall Settings_StoreStringField

Label_65_44AF:: ; 65:44AF
	farcall Account_MailIntroPage
	or a, a
	jr z, Label_65_4498

Label_65_44B8:: ; 65:44B8
	farcall Account_MailAddressEntryScreen
	or a, a
	jr z, Label_65_44AF
	ld hl, $DEAB
	ld de, $B071
	ld b, $02
	farcall Settings_StoreStringField
	ld hl, $DEB4
	ld de, $B07A
	ld b, $02
	farcall Settings_StoreStringField

Registration_PhoneMethodMenu:: ; 65:44DD
	ld a, $01
	farcall SettingsPhone_ChoiceMenu
	or a, a
	jr z, Label_65_44FC
	cp a, $01
	jp z, Label_65_4511
	ld hl, $B08A
	ld a, $01
	ld b, $00
	farcall Settings_StoreByteField
	jr Registration_ManualPhoneEntry

Label_65_44FC:: ; 65:44FC
	ld hl, $B08A
	ld a, $01
	ld b, $00
	farcall Settings_StoreByteField
	farcall SettingsPhone_ClearEntryBuffers
	jr Label_65_44B8

Label_65_4511:: ; 65:4511
	ld hl, $B08A
	xor a, a
	ld b, $00
	farcall Settings_StoreByteField
	farcall SettingsPhone_ClearEntryBuffers
	jp Label_65_4372

Registration_ManualPhoneEntry:: ; 65:4526
	ld a, $0C
	farcall Notice_ShowPage
	or a, a
	jr z, Registration_PhoneMethodMenu

Label_65_4531:: ; 65:4531
	ld a, $00
	farcall PhoneKeypad_Run
	or a, a
	jr z, Registration_ManualPhoneEntry
	ld hl, $DEDD
	ld de, $B08B
	ld b, $08
	farcall Settings_StoreStringField

Label_65_454A:: ; 65:454A
	ld a, $01
	farcall PhoneKeypad_Run
	or a, a
	jr z, Label_65_4531
	ld hl, $DEEE
	ld de, $B09C
	ld b, $10
	farcall Settings_StoreStringField

Label_65_4563:: ; 65:4563
	farcall PhoneComment_KeyboardRun
	or a, a
	jr z, Label_65_454A
	ld hl, $DEFF
	ld de, $B0AD
	ld b, $20
	farcall Settings_StoreStringField

Label_65_457A:: ; 65:457A
	xor a, a
	farcall Account_PasswordIntroPage
	or a, a
	jr z, Label_65_4563

Label_65_4584:: ; 65:4584
	ld hl, $DEB9
	ld de, $DED4
	farcall Wram3_CopyString
	xor a, a
	farcall Account_PasswordEntryScreen
	push af
	call Function_65_4761
	ld hl, $DED4
	ld de, $DEB9
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Label_65_457A
	ld hl, $DECB
	ld de, $DED4
	farcall Wram3_CopyString
	ld a, $01
	farcall Account_PasswordEntryScreen
	push af
	ld hl, $DED4
	ld de, $DECB
	farcall Wram3_CopyString
	pop af
	or a, a
	jr z, Label_65_4584
	farcall Password_CompareEntries
	ld a, b
	or a, a
	jr z, Label_65_45F9
	ld a, $F0
	ld hl, $0010
	farcall CommErr_ShowScreen
	ld hl, $DEB9
	farcall Wram3_ClearByte
	ld hl, $DECB
	farcall Wram3_ClearByte
	jr Label_65_4584

Label_65_45F9:: ; 65:45F9
	ld hl, $DEB9
	ld de, $B07F
	ld b, $04
	farcall Settings_StoreStringField

Label_65_4607:: ; 65:4607
	xor a, a
	farcall PwSaveConfirm_Run
	or a, a
	jp z, Label_65_4584
	cp a, $02
	jr z, Label_65_461A
	ld a, $01
	jr Label_65_461B

; ---- code $461A-$461B (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 444B-4642 by apply_coverage --split

Label_65_461A:: ; 65:461A
	xor a, a

; ---- code $461B-$4642 (39 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 444B-4642 by apply_coverage --split [executed in 2 scenarios]

Label_65_461B:: ; 65:461B
	ld [wRam_C27A], a
	ld hl, $B088
	ld a, [wRam_C27A]
	ld b, $00
	farcall Settings_StoreByteField

Label_65_462C:: ; 65:462C
	farcall Account_ConfirmManualScreen
	or a, a
	jp z, Label_65_4607
	cp a, $02
	jp z, Label_65_448F
	ld a, $01
	ld [wManualNumbersFlag], a
	jr Registration_Communicate

; ---- code $4642-$46E5 (163 bytes) [CONFIRMED] 46 insn(s); 46 executed (in up to 3/18 scenarios)

Registration_Communicate:: ; 65:4642
	farcall Settings_SetProgressState2
	ld b, $00
	ld a, $01
	ld hl, $A880
	farcall WriteByteFar
	ld a, [wRam_C27A]
	or a, a
	jr z, Label_65_4661
	farcall Registration_SavePassword

Label_65_4661:: ; 65:4661
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
	jr z, Label_65_46DD
	ld a, $04
	ld b, $01
	farcall Account_ResultPage

Label_65_46DD:: ; 65:46DD
	ld a, $04
	farcall Notice_ShowPage

; ---- code $46E5-$46FF (26 bytes) [PROBABLE] 8 insn(s) reached by static flow only; seeds: exec x8; min discovery hops 0; entry not recorded
	farcall Dev_InstallTestConfig

Label_65_46EB:: ; 65:46EB
	ld a, $05
	farcall Notice_ShowPage
	ld a, $06
	farcall Notice_ShowPage
	or a, a
	jr z, Label_65_46EB
	ret

; ---- code $46FF-$471F (32 bytes) [HYPOTHESIS] sibling of the executed Function_65_473F (same 32-byte shape: save FFF2/FF8D, switch WRAM bank 3, call $14BF with hl=$DECB de=$DEB9, restore); clean decode to ret; no caller or table entry found in the ROM (raw far-call/call/word scan), so entry unproven

Function_65_46FF:: ; 65:46FF
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DECB
	ld de, $DEB9
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $471F-$473F (32 bytes) [HYPOTHESIS] sibling of the executed Function_65_473F (same shape, de=$DEC2); clean decode to ret; no caller or table entry found, entry unproven

Function_65_471F:: ; 65:471F
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DECB
	ld de, $DEC2
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

; ---- code $473F-$481A (219 bytes) [CONFIRMED] 108 insn(s); 108 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

Password_CompareEntries:: ; 65:473F
Function_65_473F::
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DEB9
	ld de, $DECB
	call CompareString
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	ret

Function_65_4761:: ; 65:4761
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DEB9
	ld de, $DED4
	call CompareString
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, b
	or a, a
	jr z, Label_65_47C7
	ld hl, $DECB
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

Label_65_47C7:: ; 65:47C7
	ret

Password_CompareNewAndConfirm:: ; 65:47C8
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $DECB
	ld de, $DEC2
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
	ld hl, $DEB9
	ld de, $C28F
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $C28F
	call StringLength
	ld a, c
	ld de, $C28F
	farcall SavedPassword_Store
	ret

; ---- code $481A-$487C (98 bytes) [PROBABLE] 37 insn(s) reached by static flow only; seeds: site x37; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code

Function_65_481A:: ; 65:481A
	farcall Settings_VerifyAndRepair
	cp a, $02
	jr z, Label_65_4852
	cp a, $03
	jr z, Label_65_485D
	farcall Sram_VerifyChecksum3
	or a, a
	jr nz, Label_65_4852
	farcall SaveCheck_Verify
	or a, a
	jr nz, Label_65_4852
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
	jr nz, Label_65_4852
	ret

Label_65_4852:: ; 65:4852
	ld a, $F0
	ld hl, $0111
	farcall CommErr_ShowScreen

Label_65_485D:: ; 65:485D
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
