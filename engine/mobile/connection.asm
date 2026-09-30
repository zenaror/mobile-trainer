; engine/mobile/connection.asm
; bank 54, $4000-$4288 (648 bytes); pinned by layout.link
; Mobile session start/poll pairs: connect, disconnect, cancel, result fetch, guest login string

SECTION "engine/mobile/connection", ROMX

; ---- code $4000-$4011 (17 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Mobile_ResetCommandTimer:: ; 54:4000
Function_54_4000::
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, $C266
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wMobileTimeoutIssued], a
	ret

; ---- code $4011-$403D (44 bytes) [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1; entered by far from 26:50B9 (PROBABLE code) [executed in 4 scenarios]

Mobile_FetchResult:: ; 54:4011
	ld a, $00
	farcall MobileAPI
	ld b, a
	ld [wMobileResultCode], a
	ld a, l
	ld [wMobileResultDetail], a
	ld a, h
	ld [wMobileResultDetail + 1], a
	ld a, b
	and a, $F0
	cp a, $30
	ret z
	ld a, b
	cp a, $20
	ret z
	cp a, $21
	ret z
	cp a, $24
	ret z
	cp a, $26
	ret z
	xor a, a
	ld [wCommSessionActive], a
	ret

; ---- code $403D-$406B (46 bytes) [CONFIRMED] 21 insn(s); 21 executed (in up to 6/18 scenarios); entry proven: target of an executed call/far call

Mobile_SessionInit:: ; 54:403D
Function_54_403D::
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld hl, $FF8A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $C271
	ld a, $02
	farcall MobileAPI
	ret

Mobile_ConnectPoll:: ; 54:405D
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_406B
	bit 0, a
	jr z, Label_54_4071
	ld a, $01
	ret

; ---- code $406B-$4071 (6 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 54:4062 (executed)

Label_54_406B:: ; 54:406B
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $4071-$4083 (18 bytes) [CONFIRMED] 11 insn(s); 11 executed (in up to 5/18 scenarios)

Label_54_4071:: ; 54:4071
	ld hl, $C1D9
	inc [hl]
	ld a, [hl]
	dec a
	jr z, Label_54_4086
	dec a
	jr z, Label_54_4094
	dec a
	jr z, Label_54_40B7
	dec a
	jp z, Label_54_4135

; ---- code $4083-$4086 (3 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jpcc at 54:4080 (executed)
	ld a, $FF
	ret

; ---- code $4086-$40A8 (34 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 5/18 scenarios)

Label_54_4086:: ; 54:4086
	ld de, $C1E0
	ld a, $0E
	farcall MobileAPI
	ld a, $01
	ret

Label_54_4094:: ; 54:4094
	ld de, $C201
	ld a, $10
	farcall MobileAPI
	ld hl, $C1D8
	res 0, [hl]
	xor a, a
	bit 1, [hl]
	ret z

; ---- code $40A8-$40B7 (15 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the retcc at 54:40A7 (executed)
	ld hl, $C1D9
	inc [hl]
	ld de, $C480
	ld a, $0C
	farcall MobileAPI

; ---- code $40B7-$413B (132 bytes) [CONFIRMED] 53 insn(s); 53 executed (in up to 4/18 scenarios)

Label_54_40B7:: ; 54:40B7
	ld a, [wMobileTaskArgs]
	or a, a
	jr nz, Label_54_4102
	ld hl, $C240
	ld b, $00

Label_54_40C2:: ; 54:40C2
	inc b
	ld a, [hli]
	or a, a
	jr nz, Label_54_40C2
	dec hl
	push hl
	ld de, $0008
	add hl, de
	ld e, l
	ld d, h
	pop hl
	push de

Label_54_40D1:: ; 54:40D1
	ld a, [hld]
	ld [de], a
	dec de
	dec b
	jr nz, Label_54_40D1
	ld de, $C240
	farcall Net_CopyDefaultDnsPair
	pop de
	inc de
	ld hl, String_Mobile_GuestLogin
	farcall CopyString
	ld hl, String_Mobile_GuestLogin
	farcall CopyString
	ld a, $3E
	ld hl, $C240
	farcall MobileAPI
	ld a, $01
	ret

Label_54_4102:: ; 54:4102
	dec a
	ld hl, $C480
	farcall Dial_SelectEntryFromList
	ld de, $C240
	farcall CopyString
	ld hl, $C1E0
	farcall CopyString
	ld hl, $C220
	farcall CopyString
	ld a, $06
	ld hl, $C240
	farcall MobileAPI
	ld a, $01
	ret

Label_54_4135:: ; 54:4135
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

; ---- data $413B-$4141 (6 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

String_Mobile_GuestLogin:: ; 54:413B
Data_54_413B::
	db $67, $75, $65, $73, $74, $00

; ---- code $4141-$415A (25 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Mobile_BeginConnect:: ; 54:4141
Function_54_4141::
	ld a, c
	ld [wMobileTaskArgs], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld de, $C220
	farcall CopyString
	ld a, [wMobileSDK_State]
	cp a, $01
	jr z, Label_54_4176

; ---- code $415A-$4176 (28 bytes) [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0; fall-through of the jrcc at 54:4158 (executed)
	ld a, $03
	ld [wMobileTaskKind], a
	ld a, $00
	ld [wMobileTaskStep], a
	ld hl, $FF8A
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $C271
	ld a, $02
	farcall MobileAPI
	ret

; ---- code $4176-$41B1 (59 bytes) [CONFIRMED] 24 insn(s); 24 executed (in up to 4/18 scenarios)

Label_54_4176:: ; 54:4176
	ld a, $03
	ld [wMobileTaskKind], a
	ld a, $02
	ld [wMobileTaskStep], a
	ld de, $C480
	ld a, $0C
	farcall MobileAPI
	ret

Mobile_BeginDisconnect:: ; 54:418C
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld a, $0A
	farcall MobileAPI
	ret

Mobile_DisconnectPoll:: ; 54:41A3
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_41B1
	bit 0, a
	jr z, Label_54_41B7
	ld a, $01
	ret

; ---- code $41B1-$41B7 (6 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 54:41A8 (executed) [executed in 5 scenarios]

Label_54_41B1:: ; 54:41B1
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $41B7-$41C5 (14 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 3/18 scenarios)

Label_54_41B7:: ; 54:41B7
	ld a, $36
	farcall MobileAPI
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

; ---- code $41C5-$41FB (54 bytes) [PROBABLE] 25 insn(s): start of the function that ends in the FarCall sites at 54:41FB-4274 (writes WRAM $C1D8/$C1D9/$C1DB, tests bits of $C69F, register setup ld de,$C480 ; ld bc,0 ; ld a,$28 for the FarCall at 41FB); contains the branches to 4204/4215/422E classified below; follows the ret at 41C4; well-formed instruction chain (clean decode, all direct targets land on instruction starts, lands exactly on the next code region); no direct caller/table entry found: entry HYPOTHESIS

Function_54_41C5:: ; 54:41C5
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ret

	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_41E6
	bit 2, a
	jr nz, Label_54_41EC
	bit 0, a
	jr z, Label_54_4215
	ld a, $01
	ret

Label_54_41E6:: ; 54:41E6
	call Mobile_FetchResult
	ld a, $FF
	ret

Label_54_41EC:: ; 54:41EC
	ld a, [wMobileSDK_State]
	cp a, $1A
	jr z, Label_54_4204
	ld de, $C480
	ld bc, $0000
	ld a, $28

; ---- code $41FB-$4204 (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

; ---- code $4204-$420C (8 bytes) [PROBABLE] 3 insn(s) (ld de,$C480 ; ld bc,0 ; ld a,$24) register setup for the FarCall at 420C; entered by jr z from 54:41F1 (this classification)

Label_54_4204:: ; 54:4204
	ld de, $C480
	ld bc, $0000
	ld a, $24

; ---- code $420C-$4215 (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

; ---- code $4215-$4225 (16 bytes) [PROBABLE] 10 insn(s) (ld hl,$C1D9 ; inc [hl] ; ld a,[hl] ; dec a ; jr z ... ret) ; entered by jr z from 54:41E1 (this classification)

Label_54_4215:: ; 54:4215
	ld hl, $C1D9
	inc [hl]
	ld a, [hl]
	dec a
	jr z, Label_54_4223
	dec a
	jr z, Label_54_422E
	ld a, $FF
	ret

Label_54_4223:: ; 54:4223
	ld a, $0A

; ---- code $4225-$422E (9 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

; ---- code $422E-$4230 (2 bytes) [PROBABLE] 1 insn (ld a,$36) ; entered by jr z from 54:421E (this classification)

Label_54_422E:: ; 54:422E
	ld a, $36

; ---- code $4230-$423C (12 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: site x5; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

; ---- code $423C-$4274 (56 bytes) [CONFIRMED] 25 insn(s); 25 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

Mobile_BeginCancel:: ; 54:423C
Function_54_423C::
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld a, [wTimerEnable]
	bit 0, a
	jr z, Label_54_425A

Label_54_4251:: ; 54:4251
	ld a, $34
	farcall MobileAPI
	ret

Label_54_425A:: ; 54:425A
	ld a, [wMobileSDK_State]
	cp a, $02
	jr nc, Label_54_4251
	xor a, a
	ld [wTimerEnable], a
	ret

Mobile_CancelPoll:: ; 54:4266
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_4274
	bit 0, a
	jr z, Label_54_427A
	ld a, $01
	ret

; ---- code $4274-$427A (6 bytes) [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 54:426B (executed)

Label_54_4274:: ; 54:4274
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $427A-$4288 (14 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios) (part of region $427A-$42F5)

Label_54_427A:: ; 54:427A
	ld a, $36
	farcall MobileAPI
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret
