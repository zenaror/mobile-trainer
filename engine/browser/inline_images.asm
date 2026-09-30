; engine/browser/inline_images.asm
; bank 4C, $4840-$4B54 (788 bytes); pinned by layout.link
; Browser_FetchInlineImages

SECTION "engine/browser/inline_images", ROMX

; ---- code $4840-$48B6 (118 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 1/18 scenarios) (part of region $482A-$48B6)

Browser_FetchInlineImages:: ; 4C:4840
	ld a, $00
	ldh [hRam_FFD2], a
	ld a, $DE
	ldh [hRam_FFD3], a
	ld a, $04
	ldh [hRam_FFD4], a
	ld de, $C380
	ld hl, $D500
	ld bc, $0100
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	call Function_00_0392
	ld de, $DD00
	ld hl, $C380
	ld bc, $0100
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call CopyBytes
	ld a, $00
	ld [wBrowserFetchResult], a

Label_4C_4878:: ; 4C:4878
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wBrowserRxPtr]
	ld l, a
	ld a, [wBrowserRxPtr + 1]
	ld h, a
	ld a, [wBrowserRxBank]
	farcall Html_NextResourceRecord
	inc de
	inc de
	ld a, e
	ldh [hRam_FFD0], a
	ld a, d
	ldh [hRam_FFD1], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Function_00_0392
	ldh a, [hRam_FFD2]
	ld l, a
	ldh a, [hRam_FFD3]
	ld h, a
	ldh a, [hRam_FFD4]
	call BankSwitch_H
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	or a, e
	ret z

; ---- code $48B6-$497A (196 bytes) [CONFIRMED] 314 insn(s) reached by static flow only; seeds: exec x314; min discovery hops 0; fall-through of the retcc at 4C:48B5 (executed) | 90 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 3 scenarios]
	ld a, l
	ldh [hRam_FFD2], a
	ld a, h
	ldh [hRam_FFD3], a
	inc de
	push de
	ldh a, [hRam_FFD0]
	ld l, a
	ldh a, [hRam_FFD1]
	ld h, a
	ld a, $FC
	sub a, l
	ld a, $BF
	sbc a, h
	jp z, Label_4C_4AD5
	bit 7, a
	jp nz, Label_4C_4AD5
	ld a, [wBrowserRxBank]
	call BankSwitch_H
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a

Label_4C_48DF:: ; 4C:48DF
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, Label_4C_48DF
	ld a, l
	ld [wBrowserRxPtr], a
	ld a, h
	ld [wBrowserRxPtr + 1], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	pop hl
	ld de, $DD00
	ld a, $04
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	farcall HtmlUrl_Resolve
	ld hl, $C380
	farcall HtmlUrl_NormalizePath
	call Url_StripFragment
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $C380
	ld a, [wBrowserRxPtr]
	ld e, a
	ld a, [wBrowserRxPtr + 1]
	ld d, a
	ld a, $FC
	sub a, e
	ld c, a
	ld a, $BF
	sbc a, d
	jp z, Label_4C_4AD6
	bit 7, a
	jp nz, Label_4C_4AD6
	ld b, a
	ld a, [wBrowserRxBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	farcall Http_StartGet
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a

Label_4C_4952:: ; 4C:4952
	farcall Http_Poll
	or a, a
	jr z, Label_4C_49CF
	cp a, $FF
	jp z, Label_4C_4A58
	ld a, $00
	farcall CommProgress_Step
	cp a, $02
	jp z, Label_4C_4AE2
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, Label_4C_497A
	xor a, a
	jr Label_4C_497C

; ---- code $497A-$497C (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split

Label_4C_497A:: ; 4C:497A
	ld a, $FF

; ---- code $497C-$4999 (29 bytes) [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 3 scenarios]

Label_4C_497C:: ; 4C:497C
	or a, a
	jp nz, Label_4C_4A25

Label_4C_4980:: ; 4C:4980
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_49C6
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_49C7
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_49C6

; ---- code $4999-$49C6 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split
	jr nz, Label_4C_49A2
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_49C6

Label_4C_49A2:: ; 4C:49A2
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_49B2
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_49C6
	set 1, [hl]

Label_4C_49B2:: ; 4C:49B2
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_49C7
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_49C7

; ---- code $49C6-$49E8 (34 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 2 scenarios]

Label_4C_49C6:: ; 4C:49C6
	xor a, a

Label_4C_49C7:: ; 4C:49C7
	pop hl
	or a, a
	jp nz, Label_4C_4AE2
	jp Label_4C_4952

Label_4C_49CF:: ; 4C:49CF
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_4A15
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_4A16
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_4A15

; ---- code $49E8-$4A15 (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split
	jr nz, Label_4C_49F1
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_4A15

Label_4C_49F1:: ; 4C:49F1
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_4A01
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_4A15
	set 1, [hl]

Label_4C_4A01:: ; 4C:4A01
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_4A16
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_4A16

; ---- code $4A15-$4A25 (16 bytes) [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 2 scenarios]

Label_4C_4A15:: ; 4C:4A15
	xor a, a

Label_4C_4A16:: ; 4C:4A16
	pop hl
	or a, a
	jp nz, Label_4C_4B4E
	ld a, [wRam_C1DC]
	or a, a
	jp nz, Label_4C_4AD6
	jp Label_4C_4878

; ---- code $4A25-$4A58 (51 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split

Label_4C_4A25:: ; 4C:4A25
	ld a, [wTimerEnable]
	bit 0, a
	jp z, Label_4C_4980
	farcall Mobile_BeginStop

Label_4C_4A33:: ; 4C:4A33
	farcall Mobile_StopPoll
	or a, a
	jr z, Label_4C_4A4C
	cp a, $FF
	jp z, Label_4C_4A58
	ld a, $00
	farcall CommProgress_Step
	jp Label_4C_4A33

Label_4C_4A4C:: ; 4C:4A4C
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld [wMobileResultDetail], a
	ld [wMobileResultDetail + 1], a

; ---- code $4A58-$4A8E (54 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 1 scenarios]

Label_4C_4A58:: ; 4C:4A58
	ldh a, [hRam_FFD0]
	ld e, a
	ldh a, [hRam_FFD1]
	ld d, a
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_4ABB
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_4ABC
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_4ABB

; ---- code $4A8E-$4ABB (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split
	jr nz, Label_4C_4A97
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_4ABB

Label_4C_4A97:: ; 4C:4A97
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_4AA7
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_4ABB
	set 1, [hl]

Label_4C_4AA7:: ; 4C:4AA7
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_4ABC
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_4ABC

; ---- code $4ABB-$4ACE (19 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 1 scenarios]

Label_4C_4ABB:: ; 4C:4ABB
	xor a, a

Label_4C_4ABC:: ; 4C:4ABC
	pop hl
	or a, a
	jp nz, Label_4C_4B4E
	ld a, [wMobileResultCode]
	cp a, $24
	jp z, Label_4C_4878
	cp a, $32
	jp z, Label_4C_4878

; ---- code $4ACE-$4AE2 (20 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split
	ld a, $03
	ld [wBrowserFetchResult], a
	jr Label_4C_4AE7

Label_4C_4AD5:: ; 4C:4AD5
	pop de

Label_4C_4AD6:: ; 4C:4AD6
	ld a, $00
	ld [wBrowserFetchResult], a
	ld a, $01
	ld [wRam_C1DC], a
	jr Label_4C_4AE7

; ---- code $4AE2-$4B1D (59 bytes) [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 1 scenarios]

Label_4C_4AE2:: ; 4C:4AE2
	ld a, $02
	ld [wBrowserFetchResult], a

Label_4C_4AE7:: ; 4C:4AE7
	ldh a, [hRam_FFD0]
	ld e, a
	ldh a, [hRam_FFD1]
	ld d, a
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_4C_4B4A
	ld hl, $C26F
	bit 0, [hl]
	jr nz, Label_4C_4B4B
	ld a, [wRam_C26E]
	ld b, a
	ld a, [wTimerAMinutes]
	cp a, b
	jr c, Label_4C_4B4A

; ---- code $4B1D-$4B4A (45 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split
	jr nz, Label_4C_4B26
	ld a, [wTimerASeconds]
	cp a, $1E
	jr c, Label_4C_4B4A

Label_4C_4B26:: ; 4C:4B26
	ld a, [wRam_C26E]
	cp a, $45
	jr nz, Label_4C_4B36
	ld hl, $C26F
	bit 1, [hl]
	jr nz, Label_4C_4B4A
	set 1, [hl]

Label_4C_4B36:: ; 4C:4B36
	ld hl, $C26F
	set 0, [hl]
	ld hl, $C26E
	ld a, [hl]
	cp a, $45
	jr z, Label_4C_4B4B
	add a, $0A
	ld [hl], a
	ld a, $FF
	jr Label_4C_4B4B

; ---- code $4B4A-$4B4E (4 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split [executed in 1 scenarios]

Label_4C_4B4A:: ; 4C:4B4A
	xor a, a

Label_4C_4B4B:: ; 4C:4B4B
	pop hl
	or a, a
	ret z

; ---- code $4B4E-$4B54 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 48B6-4B54 by apply_coverage --split

Label_4C_4B4E:: ; 4C:4B4E
	ld a, $06
	ld [wRam_C1DC], a
	ret
