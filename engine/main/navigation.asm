; engine/main/navigation.asm
; bank 7C, $7B7C-$7E11 (661 bytes); pinned by layout.link
; Nav_* main loop state handlers

SECTION "engine/main/navigation", ROMX

Nav_TitleStart:: ; 7C:7B7C
Function_7C_7B7C::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 12/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall Tutorial_GateTopMenu
	xor a, a
	or a, b
	ret nz

Nav_TopMenuLoop:: ; 7C:7B85
	farcall TopMenu_Run
	call JumpTableInline

; ---- ptrtable $7B8E-$7B96 (8 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 7C:7B8B: 4 entries; end is a heuristic guess (words stay plausible code pointers); every byte read as data in a trace

Nav_TopMenuJumpTable:: ; 7C:7B8E
Table_7C_7B8E::
	dw Nav_TopMenu_Back
	dw Nav_TopMenu_Mail
	dw Nav_TopMenu_Homepage
	dw Nav_TopMenu_Help

	; [PROBABLE] jp back to the head of the dispatch loop (call JumpTableInline ; inline table ; jp
	; head) placed right after the inline table, same shape after the inline tables at 7B8E, 7BC9
	; and 7D60 (call $0545 never returns, so the jp is reached only as default/after-table code): jp
	; $7B85 (loop head)
	jp Nav_TopMenuLoop

Nav_TopMenu_Back:: ; 7C:7B99
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 9/18 scenarios)
	ret

Nav_TopMenu_Mail:: ; 7C:7B9A
	farcall Nav_MailMenu
	jp Nav_TopMenuLoop

Nav_TopMenu_Homepage:: ; 7C:7BA3
	farcall Browser_Entry
	jp Nav_TopMenuLoop

Nav_TopMenu_Help:: ; 7C:7BAC
	ld b, $00
	farcall HelpMenu_Run
	jp Nav_TopMenuLoop

Nav_MailMenu:: ; 7C:7BB7
	farcall Tutorial_GateMailMenu
	xor a, a
	or a, b
	ret nz

Nav_MailMenuLoop:: ; 7C:7BC0
	farcall MailMenu_Run
	call JumpTableInline

; ---- ptrtable $7BC9-$7BD7 (14 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 7C:7BC6: 7 entries; end is a heuristic guess (words stay plausible code pointers); every byte read as data in a trace

Nav_MailMenuJumpTable:: ; 7C:7BC9
Table_7C_7BC9::
	dw Nav_MailMenu_Back
	dw Nav_MailMenu_SendReceive
	dw Nav_MailMenu_WriteMail
	dw Nav_MailMenu_Mailbox
	dw Nav_MailMenu_AddressBook
	dw Nav_MailMenu_Profile
	dw Nav_MailMenu_MailServer

	; [PROBABLE] jp back to the head of the dispatch loop (call JumpTableInline ; inline table ; jp
	; head) placed right after the inline table, same shape after the inline tables at 7B8E, 7BC9
	; and 7D60 (call $0545 never returns, so the jp is reached only as default/after-table code): jp
	; $7BC0 (loop head)
	jp Nav_MailMenuLoop

Nav_MailMenu_SendReceive:: ; 7C:7BDA
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 4/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Mail_OutboxIsEmpty
	inc a
	jp nz, .l7C6A
	farcall Mailbox_CountRecords
	ld a, d
	cp a, $0C
	jp nz, .l7C6A

	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0;
	; fall-through of the jpcc at 7C:7BF7 (executed) [executed in 2 scenarios]
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0007
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	ld a, $FF
	ld [wMailScreenMode], a
	ld d, $FF
	ld bc, $0000
	farcall Mailbox_LoadScreen
	farcall Stat_DisableScrollSplit
	farcall Sprite_ResetAll
	ld de, $021F
	push de
	pop de
	farcall Dialog_Show
	dec a
	jp nz, .l7C73
	ld a, $FF
	ld [wMailScreenMode], a
	ld bc, $0000
	ld h, $00
	farcall Mailbox_Main
	jp Nav_MailMenuLoop

.l7C6A ; 7C:7C6A
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 4/18 scenarios)
	farcall MailSendRecv_Main
	jp Nav_MailMenuLoop

.l7C73 ; 7C:7C73
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jpcc from 7C:7C54 (PROBABLE code) [executed in 2 scenarios]
	farcall Palette_FadeOutToWhite
	jp Nav_MailMenuLoop

Nav_MailMenu_WriteMail:: ; 7C:7C7C
	; [CONFIRMED] 32 insn(s); 32 executed (in up to 2/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sMailDraft_ToAddress
	ld a, [hl]
	cp a, $00
	jr nz, .l7CA5
	farcall MailCompose_Run
	jp Nav_MailMenuLoop
.l7CA5 ; 7C:7CA5
	ld c, $00
	farcall MailDraft_Menu
	jp Nav_MailMenuLoop

Nav_MailMenu_Mailbox:: ; 7C:7CB0
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	ld d, $FF
	ld bc, $0000
	ld a, $00
	ld [wMailScreenMode], a
	farcall Mailbox_Main
	jp Nav_MailMenuLoop

Nav_MailMenu_AddressBook:: ; 7C:7CCD
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	ld a, $00
	farcall Abook_Run

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; entry
	; not recorded [executed in 2 scenarios]
	jp Nav_MailMenuLoop

Nav_MailMenu_Profile:: ; 7C:7CE2
	; [CONFIRMED] 5 insn(s); 5 executed (in up to 1/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	xor a, a
	farcall Profile_Edit

	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; entry
	; not recorded [executed in 5 scenarios]
	jp Nav_MailMenuLoop

Nav_MailMenu_MailServer:: ; 7C:7CF6
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Joypad_Update
	ldh a, [hJoyHeld]
	xor a, PADF_SELECT | PADF_LEFT
	jr nz, .l7D15

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jrcc at 7C:7D0A (executed) [executed in 1 scenarios]
	farcall MailSrvDelHidden_MenuRun
	jp Nav_MailMenuLoop

.l7D15 ; 7C:7D15
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 4/18 scenarios)
	farcall MailSrvDel_MenuRun
	jp Nav_MailMenuLoop

Nav_MailMenu_Back:: ; 7C:7D1E
	ret

Nav_TitleMobileSettings:: ; 7C:7D1F
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [sVarSettingsMenuCursor], a
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
	ld [wHiddenModeFlag], a

Nav_MobileSettingsLoop:: ; 7C:7D57
	farcall SettingsMenu_Run
	call JumpTableInline

; ---- ptrtable $7D60-$7D6C (12 bytes) [PROBABLE] inline table of `call $0545` at 7C:7D5D: 6 entries (7D6F 7D70 7D79 7D82 7DFF 7E08); the mapper counted 7 by reading the operand of the following jp (C3 57 7D) as a word 57C3, hence 7D6E was left as a 1-byte hole

Nav_MobileSettingsJumpTable:: ; 7C:7D60
Table_7C_7D60::
	dw Nav_MobileSettings_Back
	dw Nav_MobileSettings_ChangePassword
	dw Nav_MobileSettings_UsageTime
	dw Nav_MobileSettings_UsageFee
	dw Nav_MobileSettings_DeleteRegistration
	dw Nav_MobileSettings_PhoneNumber

	; [PROBABLE] jp back to the head of the dispatch loop (call JumpTableInline ; inline table ; jp
	; head) placed right after the inline table, same shape after the inline tables at 7B8E, 7BC9
	; and 7D60 (call $0545 never returns, so the jp is reached only as default/after-table code): jp
	; $7D57 (loop head); its operand high byte 7D at 7D6E was the 1-byte hole
	jp Nav_MobileSettingsLoop

Nav_MobileSettings_Back:: ; 7C:7D6F
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 4/18 scenarios)
	ret

Nav_MobileSettings_ChangePassword:: ; 7C:7D70
	farcall PasswordChange_Run
	jp Nav_MobileSettingsLoop

Nav_MobileSettings_UsageTime:: ; 7C:7D79
	farcall UsageTime_Run
	jp Nav_MobileSettingsLoop

Nav_MobileSettings_UsageFee:: ; 7C:7D82
	farcall UsageFee_Run
	jp Nav_MobileSettingsLoop

	; [HYPOTHESIS] ld a,$00 falling into the raw far-call site at 7D8D (PROBABLE); the previous
	; region ends with jp $7D57 so no path enters here; no reference found
	ld a, $00

Function_7C_7D8D:: ; 7C:7D8D
	; [PROBABLE] 39 insn(s) reached by static flow only; seeds: site x39; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall CommScene_Init
.l7D93 ; 7C:7D93
	ld a, $00
	farcall CommScene_Step
	cp a, $02
	jr z, .l7DB0
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr z, .l7D93
.l7DA5 ; 7C:7DA5
	ld a, $01
	farcall CommScene_Step
	or a, a
	jr nz, .l7DA5
.l7DB0 ; 7C:7DB0
	ld a, $01
	farcall CommScene_Init
.l7DB8 ; 7C:7DB8
	ld a, $00
	farcall CommScene_Step
	cp a, $02
	jr z, .l7DD5
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr z, .l7DB8
.l7DCA ; 7C:7DCA
	ld a, $01
	farcall CommScene_Step
	or a, a
	jr nz, .l7DCA
.l7DD5 ; 7C:7DD5
	ld a, $02
	farcall CommScene_Init
.l7DDD ; 7C:7DDD
	ld a, $00
	farcall CommScene_Step
	cp a, $02
	jr z, .l7DFA
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr z, .l7DDD
.l7DEF ; 7C:7DEF
	ld a, $01
	farcall CommScene_Step
	or a, a
	jr nz, .l7DEF
.l7DFA ; 7C:7DFA
	jr Nav_MobileSettings_UsageFee

	; [HYPOTHESIS] jp $7D57 after an unconditional jr; no reference found
	jp Nav_MobileSettingsLoop

Nav_MobileSettings_DeleteRegistration:: ; 7C:7DFF
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	farcall Registration_DeleteFlow
	jp Nav_MobileSettingsLoop

Nav_MobileSettings_PhoneNumber:: ; 7C:7E08
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by table from 7C:7D5D (executed) [executed in 2 scenarios]
	farcall SettingsPhone_Run
	jp Nav_MobileSettingsLoop
