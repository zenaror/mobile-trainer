; engine/browser/comm_disconnect.asm
; bank 4C, $46B8-$4840 (392 bytes); pinned by layout.link
; comm progress scene init/step and the disconnect sequences

SECTION "engine/browser/comm_disconnect", ROMX

; ---- code $46B8-$46C0 (8 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call (part of region $46A6-$46C0)

CommProgress_Init:: ; 4C:46B8
	ldh [hRam_FFB0], a
	ld a, [wCommSessionKind]
	call JumpTableInline

; ---- ptrtable $46C0-$46C4 (4 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 4C:46BD: 2 entries; end pinned by the executed instruction at 46C4; every byte read as data in a trace

Table_4C_46C0:: ; 4C:46C0
	dw Label_4C_46C4
	dw Label_4C_46CD

; ---- code $46C4-$46DE (26 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)

Label_4C_46C4:: ; 4C:46C4
	ldh a, [hRam_FFB0]
	farcall CommScene_Init
	ret

Label_4C_46CD:: ; 4C:46CD
	ldh a, [hRam_FFB0]
	farcall CommPanel_Init
	ret

CommProgress_Step:: ; 4C:46D6
	ldh [hRam_FFB0], a
	ld a, [wCommSessionKind]
	call JumpTableInline

; ---- ptrtable $46DE-$46E2 (4 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 4C:46DB: 2 entries; end pinned by the executed instruction at 46E2; every byte read as data in a trace

Table_4C_46DE:: ; 4C:46DE
	dw Label_4C_46E2
	dw Label_4C_46EB

; ---- code $46E2-$46F4 (18 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios)

Label_4C_46E2:: ; 4C:46E2
	ldh a, [hRam_FFB0]
	farcall CommScene_Step
	ret

Label_4C_46EB:: ; 4C:46EB
	ldh a, [hRam_FFB0]
	farcall CommPanel_Step
	ret

; ---- code $46F4-$472B (55 bytes) [CONFIRMED] 67 insn(s) reached by static flow only; seeds: exec x67; min discovery hops 2; entered by far from 4E:4F55 (PROBABLE code) | 16 insn(s) executed; cut out of the PROBABLE region 46F4-47C4 by apply_coverage --split [executed in 4 scenarios]

Comm_Disconnect:: ; 4C:46F4
	ld a, $FF
	ld [wConnIconGfxRequest], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_4757
	farcall Mobile_BeginDisconnect

Label_4C_4706:: ; 4C:4706
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, Label_4C_476D
	cp a, $FF
	jr z, Label_4C_472B
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	jp Label_4C_4706

; ---- code $472B-$476D (66 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 46F4-47C4 by apply_coverage --split

Label_4C_472B:: ; 4C:472B
	farcall Mobile_BeginCancel

Label_4C_4731:: ; 4C:4731
	farcall Mobile_CancelPoll
	or a, a
	jr z, Label_4C_476D
	cp a, $FF
	jp z, Label_4C_476D
	farcall Function_00_0956
	farcall ConnIcon_LoadGraphicsIfRequested
	call Function_00_044B
	farcall Joypad_UpdateIdleFrames
	jp Label_4C_4731

Label_4C_4757:: ; 4C:4757
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4C_4765
	farcall Mobile_FetchResult

Label_4C_4765:: ; 4C:4765
	ld a, $36
	farcall MobileAPI

; ---- code $476D-$477E (17 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 46F4-47C4 by apply_coverage --split [executed in 4 scenarios]

Label_4C_476D:: ; 4C:476D
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	xor a, a
	ld [wConnIconGfxRequest], a
	ld [wCommSessionActive], a
	ret

; ---- code $477E-$47C4 (70 bytes) [PROBABLE] 26 insn(s) never executed in the traced runs; cut out of the PROBABLE region 46F4-47C4 by apply_coverage --split

Comm_EndOffline:: ; 4C:477E
	ld a, $02
	farcall CommProgress_Init
	ld b, $96

Label_4C_4788:: ; 4C:4788
	push bc
	ld a, $00
	farcall CommProgress_Step
	pop bc
	dec b
	jr nz, Label_4C_4788

Label_4C_4795:: ; 4C:4795
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4795
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4C_47AE
	farcall Mobile_FetchResult

Label_4C_47AE:: ; 4C:47AE
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	xor a, a
	ld [wCommSessionActive], a
	ret

; ---- code $47C4-$47F2 (46 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

Comm_DisconnectWithProgress:: ; 4C:47C4
Function_4C_47C4::
	ld a, $02
	farcall CommProgress_Init
	ld a, $00
	farcall CommProgress_Step
	farcall Mobile_BeginDisconnect

Label_4C_47DA:: ; 4C:47DA
	farcall Mobile_DisconnectPoll
	or a, a
	jr z, Label_4C_4811
	cp a, $FF
	jr z, Label_4C_47F2
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_47DA

; ---- code $47F2-$4811 (31 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 4C:47E5 (executed)

Label_4C_47F2:: ; 4C:47F2
	farcall Mobile_BeginCancel

Label_4C_47F8:: ; 4C:47F8
	farcall Mobile_CancelPoll
	or a, a
	jr z, Label_4C_4811
	cp a, $FF
	jp z, Label_4C_4811
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_47F8

; ---- code $4811-$4824 (19 bytes) [CONFIRMED] 7 insn(s); 7 executed (in up to 1/18 scenarios)

Label_4C_4811:: ; 4C:4811
	ld a, $01
	farcall CommProgress_Step
	or a, a
	jr nz, Label_4C_4811
	ld a, [wTimerEnable]
	bit 1, a
	jp z, Label_4C_482A

; ---- code $4824-$482A (6 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jpcc at 4C:4821 (executed)
	farcall Mobile_FetchResult

; ---- code $482A-$4840 (22 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 1/18 scenarios) (part of region $482A-$48B6)

Label_4C_482A:: ; 4C:482A
	ld a, $36
	farcall MobileAPI
	ld a, $09
	ld [wRam_C26E], a
	xor a, a
	ld [wRam_C26F], a
	xor a, a
	ld [wCommSessionActive], a
	ret
