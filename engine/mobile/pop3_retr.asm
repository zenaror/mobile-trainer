; engine/mobile/pop3_retr.asm
; bank 54, $4CB0-$5168 (1208 bytes); pinned by layout.link
; POP3 RETR start and poll

SECTION "engine/mobile/pop3_retr", ROMX

; ---- code $4CB0-$4D0F (95 bytes) [CONFIRMED] 366 insn(s) reached by static flow only; seeds: exec x366; min discovery hops 9; entered by far from 26:48CC (PROBABLE code) | 42 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 1 scenarios]

Pop3_StartRetr:: ; 54:4CB0
	push hl
	call Mobile_ResetCommandTimer
	pop hl
	ld a, l
	ld [wMobileTaskArgs + 4], a
	ld a, h
	ld [wMobileTaskArgs + 5], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld [wRam_C240], a
	ldh a, [hSRAMBank]
	ld [wRam_C25E], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [wMailFetchStatus], a
	ld de, $A000
	ld bc, $0FFF
	ld a, $24
	farcall MobileAPI
	ret

Pop3_RetrPoll:: ; 54:4CF4
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_4D09
	bit 2, a
	jr nz, Label_54_4D0F
	bit 0, a
	jr z, Label_54_4D20
	ld a, $01
	ret

Label_54_4D09:: ; 54:4D09
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $4D0F-$4D20 (17 bytes) [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split

Label_54_4D0F:: ; 54:4D0F
	ld de, $C480
	ld bc, $0000
	ld a, $24
	farcall MobileAPI
	ld a, $01
	ret

; ---- code $4D20-$4D2B (11 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 5 scenarios]

Label_54_4D20:: ; 54:4D20
	ld hl, $C1D9
	inc [hl]
	ld a, [hl]
	dec a
	jr z, Label_54_4D38
	dec a
	jr z, Label_54_4D2E

; ---- code $4D2B-$4D2E (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	ld a, $FF
	ret

; ---- code $4D2E-$4D93 (101 bytes) [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 5 scenarios]

Label_54_4D2E:: ; 54:4D2E
	ld a, [wMailFetchStatus]
	ld b, a
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

Label_54_4D38:: ; 54:4D38
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_54_511D
	or a, a
	jp nz, Label_54_4FA4
	ld de, $C240
	ld hl, Data_54_4FC3
	ld bc, $0008
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $04
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jp nz, Label_54_4FA4
	ld de, $C240
	ld hl, Data_54_4FCB
	ld bc, $0007
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr z, Label_54_4D9A

; ---- code $4D93-$4D9A (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr Label_54_4DD5

; ---- code $4D9A-$4DEE (84 bytes) [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 6 scenarios]

Label_54_4D9A:: ; 54:4D9A
	ld de, $C480
	add hl, de
	xor a, a
	ld [hl], a
	ld de, $C580
	ld hl, $C480
	ld bc, $0200
	farcall Charset_Iso2022JpToSjis
	farcall MailRecord_GetFreeSlotPtr
	ld bc, $00C9
	push hl
	add hl, bc
	ld e, l
	ld d, h
	pop hl
	ld bc, $00ED
	add hl, bc
	call Function_54_4FD2
	ld hl, $C252
	ld a, [hli]
	ld h, [hl]
	ld l, a

Label_54_4DCA:: ; 54:4DCA
	ld a, [hli]
	or a, a
	jr z, Label_54_4DD5
	cp a, $20
	jr nz, Label_54_4DCA
	dec hl
	xor a, a
	ld [hl], a

Label_54_4DD5:: ; 54:4DD5
	ld a, $05
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr z, Label_54_4DF5

; ---- code $4DEE-$4DF5 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr Label_54_4E47

; ---- code $4DF5-$4E60 (107 bytes) [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 4 scenarios]

Label_54_4DF5:: ; 54:4DF5
	ld de, $C480
	add hl, de
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $00D9
	add hl, de
	ld e, l
	ld d, h
	push hl
	ld hl, $C480
	ld bc, $0014
	farcall Charset_Iso2022JpToSjis
	ld hl, $C580
	ld b, $1A
	xor a, a

Label_54_4E1A:: ; 54:4E1A
	ld [hli], a
	dec b
	jr nz, Label_54_4E1A
	ld hl, $C480
	ld de, $C580
	ld bc, $0018
	farcall Charset_Iso2022JpToSjis
	ld hl, $C580
	ld b, $FF

Label_54_4E32:: ; 54:4E32
	inc b
	ld a, [hli]
	or a, a
	jr nz, Label_54_4E32
	pop hl
	ld a, b
	cp a, $15
	jr c, Label_54_4E47
	ld a, $02
	ld [wMailFetchStatus], a
	ld b, $12
	call Text_TruncateSjis

Label_54_4E47:: ; 54:4E47
	ld a, $06
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr z, Label_54_4E67

; ---- code $4E60-$4E67 (7 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr Label_54_4DF5

; ---- code $4E67-$4EBD (86 bytes) [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 6 scenarios]

Label_54_4E67:: ; 54:4E67
	call Mail_ParseDate
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0003
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C580
	ld bc, $0006
	farcall CopyBytes
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $B00C
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld l, [hl]
	ld h, a
	push hl
	add hl, bc

Label_54_4E95:: ; 54:4E95
	xor a, a
	ld [hld], a
	ld a, [hl]
	cp a, $0A
	jr z, Label_54_4E95
	cp a, $0D
	jr z, Label_54_4E95
	pop hl
	ld bc, $00C1
	ld de, $C480
	farcall Charset_Iso2022JpToSjis
	ld hl, $C480
	ld b, $C0

Label_54_4EB2:: ; 54:4EB2
	dec b
	jr z, Label_54_4EC3
	ld a, [hli]
	or a, a
	jr z, Label_54_4EC3
	cp a, $09
	jr nz, Label_54_4EB2

; ---- code $4EBD-$4EC3 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	dec hl
	ld a, $20
	ld [hli], a
	jr Label_54_4EB2

; ---- code $4EC3-$4F35 (114 bytes) [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 4 scenarios]

Label_54_4EC3:: ; 54:4EC3
	ld b, $00
	ld hl, $C480
	ld a, $C0
	cp a, c
	jr c, Label_54_4F24
	jr z, Label_54_4F24
	add hl, bc
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C480
	farcall CopyString

Label_54_4EE7:: ; 54:4EE7
	farcall MailRecord_GetFreeSlotPtr
	ld a, $01
	ld [hli], a
	ld a, [wRam_C25F]
	ld [hli], a
	ld [hl], a
	xor a, a
	farcall SramCheck_Bank0Commit
	ld a, [wRam_C25E]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $C1D6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $26
	farcall MobileAPI
	ld a, $01
	ret

Label_54_4F24:: ; 54:4F24
	ld b, $00
	ld hl, $C480

Label_54_4F29:: ; 54:4F29
	ld e, l
	ld d, h
	ld a, [hli]
	inc b
	cp a, $81
	jr c, Label_54_4F45
	cp a, $A0
	jr c, Label_54_4F46

; ---- code $4F35-$4F45 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	cp a, $E0
	jr c, Label_54_4F45
	cp a, $F0
	jr c, Label_54_4F46
	cp a, $F8
	jr c, Label_54_4F45
	cp a, $FA
	jr c, Label_54_4F46

; ---- code $4F45-$4F58 (19 bytes) [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 1 scenarios]

Label_54_4F45:: ; 54:4F45
	or a, a

Label_54_4F46:: ; 54:4F46
	jr nc, Label_54_4F4A
	inc b
	inc hl

Label_54_4F4A:: ; 54:4F4A
	ld a, $C0
	cp a, b
	jr z, Label_54_4F70
	dec a
	cp a, b
	jr nz, Label_54_4F29
	ld a, [hl]
	cp a, $81
	jr c, Label_54_4F6C

; ---- code $4F58-$4F6C (20 bytes) [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	cp a, $A0
	jr c, Label_54_4F6D
	cp a, $E0
	jr c, Label_54_4F6C
	cp a, $F0
	jr c, Label_54_4F6D
	cp a, $F8
	jr c, Label_54_4F6C
	cp a, $FA
	jr c, Label_54_4F6D

; ---- code $4F6C-$4F6F (3 bytes) [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 1 scenarios]

Label_54_4F6C:: ; 54:4F6C
	or a, a

Label_54_4F6D:: ; 54:4F6D
	jr nc, Label_54_4F70

; ---- code $4F6F-$4F70 (1 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split
	inc b

; ---- code $4F70-$4FA4 (52 bytes) [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split [executed in 4 scenarios]

Label_54_4F70:: ; 54:4F70
	ld a, c
	ld c, b
	ld b, $00
	push bc
	cp a, $C1
	jr nz, Label_54_4F8B
	ld a, $01
	ld [wRam_C25F], a
	pop bc
	ld bc, $00C0
	push bc
	ld l, e
	ld h, d
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a

Label_54_4F8B:: ; 54:4F8B
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, $C480
	pop bc
	farcall CopyBytes
	jp Label_54_4EE7

; ---- code $4FA4-$4FC3 (31 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage --split

Label_54_4FA4:: ; 54:4FA4
	ld a, $01
	ld [wMailFetchStatus], a
	ld a, [wRam_C25E]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	jp Label_54_4D2E

; ---- data $4FC3-$4FCB (8 bytes) [PROBABLE] 8-byte blob copied to WRAM $C240 by CopyBytes 00:050C (bc=$0008) at 54:4D4F (ld hl,$4FC3 ; ld de,$C240)

Data_54_4FC3:: ; 54:4FC3
	db $03, $02, $A0, $03, $00, $B0, $00, $08

; ---- data $4FCB-$4FD2 (7 bytes) [PROBABLE] 7-byte blob copied to WRAM $C240 by CopyBytes 00:050C (bc=$0007) at 54:4D73 (ld hl,$4FCB)

Data_54_4FCB:: ; 54:4FCB
	db $00, $03, $02, $A0, $03, $80, $C4

; ---- code $4FD2-$501B (73 bytes) [CONFIRMED] 203 insn(s) reached by static flow only; seeds: exec x203; min discovery hops 14; entered by call from 54:4A7F (PROBABLE code) | 36 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split [executed in 6 scenarios]

Function_54_4FD2:: ; 54:4FD2
	ld a, e
	ld [wRam_C250], a
	ld a, d
	ld [wRam_C251], a
	ld a, l
	ld [wRam_C252], a
	ld a, h
	ld [wRam_C253], a
	ld hl, $C580
	ld bc, $FFFF

Label_54_4FE8:: ; 54:4FE8
	inc bc
	ld a, [hli]
	cp a, $3C
	jr z, Label_54_501B
	cp a, $28
	jr z, Label_54_504F
	or a, a
	jr nz, Label_54_4FE8
	ld a, [wRam_C252]
	ld e, a
	ld a, [wRam_C253]
	ld d, a
	ld hl, $C580
	ld b, $40
	call Function_54_50FC
	ld hl, $C250
	ld a, [wMobileTaskStep]
	or a, a
	jr nz, Label_54_5081
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, $C580
	ld b, $10
	call Function_54_50FC
	jr Label_54_5081

; ---- code $501B-$504F (52 bytes) [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split

Label_54_501B:: ; 54:501B
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wRam_C250]
	ld e, a
	ld a, [wRam_C251]
	ld d, a
	ld hl, $C580
	ld b, $10
	call Function_54_50FC
	pop hl
	push hl
	ld bc, $FFFF

Label_54_5035:: ; 54:5035
	inc bc
	ld a, [hli]
	cp a, $3E
	jr nz, Label_54_5035
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wRam_C252]
	ld e, a
	ld a, [wRam_C253]
	ld d, a
	pop hl
	ld b, $40
	call Function_54_50FC
	jr Label_54_5081

; ---- code $504F-$50A0 (81 bytes) [CONFIRMED] 52 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split [executed in 12 scenarios]

Label_54_504F:: ; 54:504F
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wRam_C252]
	ld e, a
	ld a, [wRam_C253]
	ld d, a
	ld hl, $C580
	ld b, $40
	call Function_54_50FC
	pop hl
	push hl
	ld bc, $FFFF

Label_54_5069:: ; 54:5069
	inc bc
	ld a, [hli]
	cp a, $29
	jr nz, Label_54_5069
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wRam_C250]
	ld e, a
	ld a, [wRam_C251]
	ld d, a
	pop hl
	ld b, $10
	call Function_54_50FC

Label_54_5081:: ; 54:5081
	ld hl, $C250
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld de, $000D
	add hl, de
	ld e, l
	ld d, h
	pop hl
	push hl
	ld b, $10

Label_54_5092:: ; 54:5092
	dec b
	jr z, Label_54_50A2
	ld a, [hli]
	or a, a
	jr nz, Label_54_5092
	dec hl
	dec hl
	ld a, [hl]
	cp a, $20
	jr nz, Label_54_50A2

; ---- code $50A0-$50A2 (2 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split
	xor a, a
	ld [hl], a

; ---- code $50A2-$50B0 (14 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split [executed in 12 scenarios]

Label_54_50A2:: ; 54:50A2
	pop hl
	ld b, $07

Label_54_50A5:: ; 54:50A5
	ld a, [hl]
	or a, a
	ret z
	cp a, $81
	jr c, Label_54_50C0
	cp a, $A0
	jr c, Label_54_50C1

; ---- code $50B0-$50C0 (16 bytes) [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split
	cp a, $E0
	jr c, Label_54_50C0
	cp a, $F0
	jr c, Label_54_50C1
	cp a, $F8
	jr c, Label_54_50C0
	cp a, $FA
	jr c, Label_54_50C1

; ---- code $50C0-$511B (91 bytes) [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage --split [executed in 6 scenarios]

Label_54_50C0:: ; 54:50C0
	or a, a

Label_54_50C1:: ; 54:50C1
	jr c, Label_54_50F6
	push hl
	push de
	ld a, $01
	cp a, b
	jr nz, Label_54_50D5
	inc hl
	ld a, [hli]
	or a, a
	jr z, Label_54_50D5
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a

Label_54_50D5:: ; 54:50D5
	ld c, b
	dec c
	ld a, b
	add a, c
	ld c, a
	ld l, e
	ld h, d
	dec hl

Label_54_50DD:: ; 54:50DD
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, Label_54_50DD
	pop de
	pop hl
	ld a, [hl]
	push bc
	push hl
	push de
	farcall Text_HalfToFullWidth
	pop de
	pop hl
	ld a, b
	ld [hli], a
	ld a, c
	ld [hld], a
	pop bc

Label_54_50F6:: ; 54:50F6
	inc hl
	inc hl
	dec b
	jr nz, Label_54_50A5
	ret

Function_54_50FC:: ; 54:50FC
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	ret z
	dec b
	jr nz, Function_54_50FC
	ld a, [hl]
	or a, a
	ret z
	dec de
	dec de
	ld hl, Data_Text_Ellipsis2
	ld bc, $0002
	farcall CopyBytes
	ld a, $02
	ld [wMailFetchStatus], a
	ret

; ---- data $511B-$511D (2 bytes) [CONFIRMED] UNCLASSIFIED 2 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) [every byte read as data in 6 scenario(s)]

Data_Text_Ellipsis2:: ; 54:511B
Data_54_511B::
	db $81, $63

; ---- code $511D-$5168 (75 bytes) [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 12; entered by call from 54:49A2 (PROBABLE code) | 79 insn(s) executed; cut out of the PROBABLE region 511D-5343 by apply_coverage --split [executed in 3 scenarios] (part of region $511D-$51B9)

Function_54_511D:: ; 54:511D
	xor a, a
	ld [sSram_AFFF], a
	ld de, $C240
	ld hl, Data_54_4C44
	ld bc, $0003
	farcall CopyBytes
	ld hl, $A000
	ld a, [hli]
	ld [wRam_C243], a
	ld a, [hl]
	ld [wRam_C244], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld de, $C240
	farcall Function_00_0247
	ld e, $00
	or a, a
	ret nz
	ld a, b
	ld [wRam_C25F], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ld de, $C240
	farcall Function_00_0247
	ld e, $01
	ret
