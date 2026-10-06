; engine/mobile/pop3_retr.asm
; bank 54, $4CB0-$5168 (1208 bytes); pinned by layout.link
; POP3 RETR start and poll

SECTION "engine/mobile/pop3_retr", ROMX

Pop3_StartRetr:: ; 54:4CB0
	; [CONFIRMED] 366 insn(s) reached by static flow only; seeds: exec x366; min discovery hops 9;
	; entered by far from 26:48CC (PROBABLE code) | 42 insn(s) executed; cut out of the PROBABLE
	; region 4CB0-4FC3 by apply_coverage --split [executed in 1 scenarios]
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
	ld [wPop3SavedSramBank], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ld [wMailFetchStatus], a
	ld de, sNetWorkPage
	ld bc, $0FFF
	ld a, $24
	farcall MobileAPI
	ret

Pop3_RetrPoll:: ; 54:4CF4
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l4D09
	bit 2, a
	jr nz, .l4D0F
	bit 0, a
	jr z, .l4D20
	ld a, $01
	ret
.l4D09 ; 54:4D09
	call Mobile_FetchResult
	ld a, $FF
	ret

.l4D0F ; 54:4D0F
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld de, wRam_C480
	ld bc, $0000
	ld a, $24
	farcall MobileAPI
	ld a, $01
	ret

.l4D20 ; 54:4D20
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 5 scenarios]
	ld hl, wMobileTaskStep
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .l4D38
	dec a
	jr z, .l4D2E

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $FF
	ret

.l4D2E ; 54:4D2E
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, [wMailFetchStatus]
	ld b, a
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret
.l4D38 ; 54:4D38
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Mail_ScanAndCheckGameMail
	or a, a
	jp nz, .l4FA4
	ld de, wRam_C240
	ld hl, Data_54_4FC3
	ld bc, $0008
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $04
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jp nz, .l4FA4
	ld de, wRam_C240
	ld hl, Data_54_4FCB
	ld bc, $0007
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .l4D9A

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .l4DD5

.l4D9A ; 54:4D9A
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 6 scenarios]
	ld de, wRam_C480
	add hl, de
	xor a, a
	ld [hl], a
	ld de, wRam_C580
	ld hl, wRam_C480
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
	call Mail_SplitFromHeader
	ld hl, wMailFrom_AddressDest
	ld a, [hli]
	ld h, [hl]
	ld l, a
.l4DCA ; 54:4DCA
	ld a, [hli]
	or a, a
	jr z, .l4DD5
	cp a, $20
	jr nz, .l4DCA
	dec hl
	xor a, a
	ld [hl], a
.l4DD5 ; 54:4DD5
	ld a, $05
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .l4DF5

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .l4E47

.l4DF5 ; 54:4DF5
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld de, wRam_C480
	add hl, de
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $00D9
	add hl, de
	ld e, l
	ld d, h
	push hl
	ld hl, wRam_C480
	ld bc, $0014
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C580
	ld b, $1A
	xor a, a
.l4E1A ; 54:4E1A
	ld [hli], a
	dec b
	jr nz, .l4E1A
	ld hl, wRam_C480
	ld de, wRam_C580
	ld bc, $0018
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C580
	ld b, $FF
.l4E32 ; 54:4E32
	inc b
	ld a, [hli]
	or a, a
	jr nz, .l4E32
	pop hl
	ld a, b
	cp a, $15
	jr c, .l4E47
	ld a, $02
	ld [wMailFetchStatus], a
	ld b, $12
	call Text_TruncateSjis
.l4E47 ; 54:4E47
	ld a, $06
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, wRam_C240
	farcall Mail_DispatchFar
	or a, a
	jr z, .l4E67

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $02
	ld [wMailFetchStatus], a
	jr .l4DF5

.l4E67 ; 54:4E67
	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_ParseDate
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0003
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C580
	ld bc, $0006
	farcall CopyBytes
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sPop3RetrBodyPtrLen + $03
	ld a, [hld]
	ld b, a
	ld a, [hld]
	ld c, a
	ld a, [hld]
	ld l, [hl]
	ld h, a
	push hl
	add hl, bc
.l4E95 ; 54:4E95
	xor a, a
	ld [hld], a
	ld a, [hl]
	cp a, $0A
	jr z, .l4E95
	cp a, $0D
	jr z, .l4E95
	pop hl
	ld bc, $00C1
	ld de, wRam_C480
	farcall Charset_Iso2022JpToSjis
	ld hl, wRam_C480
	ld b, $C0
.l4EB2 ; 54:4EB2
	dec b
	jr z, .l4EC3
	ld a, [hli]
	or a, a
	jr z, .l4EC3
	cp a, $09
	jr nz, .l4EB2

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	dec hl
	ld a, $20
	ld [hli], a
	jr .l4EB2

.l4EC3 ; 54:4EC3
	; [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld b, $00
	ld hl, wRam_C480
	ld a, $C0
	cp a, c
	jr c, .l4F24
	jr z, .l4F24
	add hl, bc
	xor a, a
	ld [hl], a
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C480
	farcall CopyString
.l4EE7 ; 54:4EE7
	farcall MailRecord_GetFreeSlotPtr
	ld a, $01
	ld [hli], a
	ld a, [wPop3_BodyIncomplete]
	ld [hli], a
	ld [hl], a
	xor a, a
	farcall SramCheck_Bank0Commit
	ld a, [wPop3SavedSramBank]
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
	ld hl, wMobileTaskArgs + $04
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $26
	farcall MobileAPI
	ld a, $01
	ret
.l4F24 ; 54:4F24
	ld b, $00
	ld hl, wRam_C480
.l4F29 ; 54:4F29
	ld e, l
	ld d, h
	ld a, [hli]
	inc b
	cp a, $81
	jr c, .l4F45
	cp a, $A0
	jr c, .l4F46

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	cp a, $E0
	jr c, .l4F45
	cp a, $F0
	jr c, .l4F46
	cp a, $F8
	jr c, .l4F45
	cp a, $FA
	jr c, .l4F46

.l4F45 ; 54:4F45
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 1 scenarios]
	or a, a
.l4F46 ; 54:4F46
	jr nc, .skip
	inc b
	inc hl
.skip ; 54:4F4A
	ld a, $C0
	cp a, b
	jr z, .l4F70
	dec a
	cp a, b
	jr nz, .l4F29
	ld a, [hl]
	cp a, $81
	jr c, .l4F6C

	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	cp a, $A0
	jr c, .l4F6D
	cp a, $E0
	jr c, .l4F6C
	cp a, $F0
	jr c, .l4F6D
	cp a, $F8
	jr c, .l4F6C
	cp a, $FA
	jr c, .l4F6D

.l4F6C ; 54:4F6C
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 1 scenarios]
	or a, a
.l4F6D ; 54:4F6D
	jr nc, .l4F70

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	inc b

.l4F70 ; 54:4F70
	; [CONFIRMED] 26 insn(s) executed; cut out of the PROBABLE region 4CB0-4FC3 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, c
	ld c, b
	ld b, $00
	push bc
	cp a, $C1
	jr nz, .l4F8B
	ld a, $01
	ld [wPop3_BodyIncomplete], a
	pop bc
	ld bc, $00C0
	push bc
	ld l, e
	ld h, d
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a
.l4F8B ; 54:4F8B
	farcall MailRecord_GetFreeSlotPtr
	ld de, $0009
	add hl, de
	ld e, l
	ld d, h
	ld hl, wRam_C480
	pop bc
	farcall CopyBytes
	jp .l4EE7

.l4FA4 ; 54:4FA4
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4CB0-4FC3 by apply_coverage --split
	ld a, $01
	ld [wMailFetchStatus], a
	ld a, [wPop3SavedSramBank]
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
	jp .l4D2E

; ---- data $4FC3-$4FCB (8 bytes) [PROBABLE] 8-byte blob copied to WRAM $C240 by CopyBytes 00:050C (bc=$0008) at 54:4D4F (ld hl,$4FC3 ; ld de,$C240)

Data_54_4FC3:: ; 54:4FC3
	db $03, $02, $A0, $03, $00, $B0, $00, $08

; ---- data $4FCB-$4FD2 (7 bytes) [PROBABLE] 7-byte blob copied to WRAM $C240 by CopyBytes 00:050C (bc=$0007) at 54:4D73 (ld hl,$4FCB)

Data_54_4FCB:: ; 54:4FCB
	db $00, $03, $02, $A0, $03, $80, $C4

Mail_SplitFromHeader:: ; 54:4FD2
Function_54_4FD2::
	; [CONFIRMED] 203 insn(s) reached by static flow only; seeds: exec x203; min discovery hops 14;
	; entered by call from 54:4A7F (PROBABLE code) | 36 insn(s) executed; cut out of the PROBABLE
	; region 4FD2-511B by apply_coverage --split [executed in 6 scenarios]
	ld a, e
	ld [wMailFrom_NameDest], a
	ld a, d
	ld [wMailFrom_NameDestHi], a
	ld a, l
	ld [wMailFrom_AddressDest], a
	ld a, h
	ld [wMailFrom_AddressDestHi], a
	ld hl, wRam_C580
	ld bc, $FFFF
.l4FE8 ; 54:4FE8
	inc bc
	ld a, [hli]
	cp a, $3C
	jr z, .l501B
	cp a, $28
	jr z, .l504F
	or a, a
	jr nz, .l4FE8
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $40
	call Mail_CopyClampedEllipsis
	ld hl, wMailFrom_NameDest
	ld a, [wMobileTaskStep]
	or a, a
	jr nz, .l5081
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld hl, wRam_C580
	ld b, $10
	call Mail_CopyClampedEllipsis
	jr .l5081

.l501B ; 54:501B
	; [PROBABLE] 31 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_NameDest]
	ld e, a
	ld a, [wMailFrom_NameDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $10
	call Mail_CopyClampedEllipsis
	pop hl
	push hl
	ld bc, $FFFF
.l5035 ; 54:5035
	inc bc
	ld a, [hli]
	cp a, $3E
	jr nz, .l5035
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	pop hl
	ld b, $40
	call Mail_CopyClampedEllipsis
	jr .l5081

.l504F ; 54:504F
	; [CONFIRMED] 52 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 12 scenarios]
	push hl
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_AddressDest]
	ld e, a
	ld a, [wMailFrom_AddressDestHi]
	ld d, a
	ld hl, wRam_C580
	ld b, $40
	call Mail_CopyClampedEllipsis
	pop hl
	push hl
	ld bc, $FFFF
.l5069 ; 54:5069
	inc bc
	ld a, [hli]
	cp a, $29
	jr nz, .l5069
	dec hl
	xor a, a
	ld [hl], a
	dec bc
	ld a, [wMailFrom_NameDest]
	ld e, a
	ld a, [wMailFrom_NameDestHi]
	ld d, a
	pop hl
	ld b, $10
	call Mail_CopyClampedEllipsis
.l5081 ; 54:5081
	ld hl, wMailFrom_NameDest
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
.l5092 ; 54:5092
	dec b
	jr z, .l50A2
	ld a, [hli]
	or a, a
	jr nz, .l5092
	dec hl
	dec hl
	ld a, [hl]
	cp a, $20
	jr nz, .l50A2

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	xor a, a
	ld [hl], a

.l50A2 ; 54:50A2
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 12 scenarios]
	pop hl
	ld b, $07
.l50A5 ; 54:50A5
	ld a, [hl]
	or a, a
	ret z
	cp a, $81
	jr c, .l50C0
	cp a, $A0
	jr c, .l50C1

	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4FD2-511B by apply_coverage --split
	cp a, $E0
	jr c, .l50C0
	cp a, $F0
	jr c, .l50C1
	cp a, $F8
	jr c, .l50C0
	cp a, $FA
	jr c, .l50C1

.l50C0 ; 54:50C0
	; [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 4FD2-511B by apply_coverage
	; --split [executed in 6 scenarios]
	or a, a
.l50C1 ; 54:50C1
	jr c, .l50F6
	push hl
	push de
	ld a, $01
	cp a, b
	jr nz, .l50D5
	inc hl
	ld a, [hli]
	or a, a
	jr z, .l50D5
	ld a, $81
	ld [hli], a
	ld a, $63
	ld [hl], a
.l50D5 ; 54:50D5
	ld c, b
	dec c
	ld a, b
	add a, c
	ld c, a
	ld l, e
	ld h, d
	dec hl
.l50DD ; 54:50DD
	ld a, [hld]
	ld [de], a
	dec de
	dec c
	jr nz, .l50DD
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
.l50F6 ; 54:50F6
	inc hl
	inc hl
	dec b
	jr nz, .l50A5
	ret

Mail_CopyClampedEllipsis:: ; 54:50FC
Function_54_50FC::
	ld a, [hli]
	ld [de], a
	inc de
	or a, a
	ret z
	dec b
	jr nz, Mail_CopyClampedEllipsis
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

Mail_ScanAndCheckGameMail:: ; 54:511D
Function_54_511D::
	; [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 12;
	; entered by call from 54:49A2 (PROBABLE code) | 79 insn(s) executed; cut out of the PROBABLE
	; region 511D-5343 by apply_coverage --split [executed in 3 scenarios] (part of region
	; $511D-$51B9)
	xor a, a
	ld [sSram_AFFF], a
	ld de, wRam_C240
	ld hl, Data_54_4C44
	ld bc, $0003
	farcall CopyBytes
	ld hl, sNetWorkPage
	ld a, [hli]
	ld [wRam_C243], a
	ld a, [hl]
	ld [wRam_C244], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld de, wRam_C240
	farcall Mail_DispatchFar
	ld e, $00
	or a, a
	ret nz
	ld a, b
	ld [wPop3_BodyIncomplete], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $02
	ld de, wRam_C240
	farcall Mail_DispatchFar
	ld e, $01
	ret
