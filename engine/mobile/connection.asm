; engine/mobile/connection.asm
; bank 54, $4000-$4288 (648 bytes); pinned by layout.link
; Mobile session start/poll pairs: connect, disconnect, cancel, result fetch, guest login string

SECTION "engine/mobile/connection", ROMX

Mobile_ResetCommandTimer:: ; 54:4000
Function_54_4000::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $05
	ld [wCommTimeoutMinutes], a
	ld hl, wTimerBFrames
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wMobileTimeoutIssued], a
	ret

Mobile_FetchResult:: ; 54:4011
	; [CONFIRMED] 24 insn(s) reached by static flow only; seeds: exec x24; min discovery hops 1;
	; entered by far from 26:50B9 (PROBABLE code) [executed in 4 scenarios]
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

Mobile_SessionInit:: ; 54:403D
Function_54_403D::
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld hl, hROMBankLo
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMobileAdapterType
	ld a, $02
	farcall MobileAPI
	ret

Mobile_ConnectPoll:: ; 54:405D
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l406B
	bit 0, a
	jr z, .l4071
	ld a, $01
	ret

.l406B ; 54:406B
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 54:4062 (executed)
	call Mobile_FetchResult
	ld a, $FF
	ret

.l4071 ; 54:4071
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 5/18 scenarios)
	ld hl, wMobileTaskStep
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .l4086
	dec a
	jr z, .l4094
	dec a
	jr z, .l40B7
	dec a
	jp z, .l4135

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jpcc at 54:4080 (executed)
	ld a, $FF
	ret

.l4086 ; 54:4086
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 5/18 scenarios)
	ld de, wMobileLoginId
	ld a, $0E
	farcall MobileAPI
	ld a, $01
	ret
.l4094 ; 54:4094
	ld de, wMobileEmailAddr
	ld a, $10
	farcall MobileAPI
	ld hl, wMobileTaskKind
	res 0, [hl]
	xor a, a
	bit 1, [hl]
	ret z

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the retcc at 54:40A7 (executed)
	ld hl, wMobileTaskStep
	inc [hl]
	ld de, wRam_C480
	ld a, $0C
	farcall MobileAPI

.l40B7 ; 54:40B7
	; [CONFIRMED] 53 insn(s); 53 executed (in up to 4/18 scenarios)
	ld a, [wMobileTaskArgs]
	or a, a
	jr nz, .l4102
	ld hl, wRam_C240
	ld b, $00
.l40C2 ; 54:40C2
	inc b
	ld a, [hli]
	or a, a
	jr nz, .l40C2
	dec hl
	push hl
	ld de, $0008
	add hl, de
	ld e, l
	ld d, h
	pop hl
	push de
.l40D1 ; 54:40D1
	ld a, [hld]
	ld [de], a
	dec de
	dec b
	jr nz, .l40D1
	ld de, wRam_C240
	farcall Net_CopyDefaultDnsPair
	pop de
	inc de
	ld hl, String_Mobile_GuestLogin
	farcall CopyString
	ld hl, String_Mobile_GuestLogin
	farcall CopyString
	ld a, $3E
	ld hl, wRam_C240
	farcall MobileAPI
	ld a, $01
	ret
.l4102 ; 54:4102
	dec a
	ld hl, wRam_C480
	farcall Dial_SelectEntryFromList
	ld de, wRam_C240
	farcall CopyString
	ld hl, wMobileLoginId
	farcall CopyString
	ld hl, wMobilePassword
	farcall CopyString
	ld a, $06
	ld hl, wRam_C240
	farcall MobileAPI
	ld a, $01
	ret
.l4135 ; 54:4135
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret

; ---- data $413B-$4141 (6 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

String_Mobile_GuestLogin:: ; 54:413B
Data_54_413B::
	db $67, $75, $65, $73, $74, $00

Mobile_BeginConnect:: ; 54:4141
Function_54_4141::
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, c
	ld [wMobileTaskArgs], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld de, wMobilePassword
	farcall CopyString
	ld a, [wMobileSDK_State]
	cp a, $01
	jr z, .l4176

	; [PROBABLE] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 0;
	; fall-through of the jrcc at 54:4158 (executed)
	ld a, $03
	ld [wMobileTaskKind], a
	ld a, $00
	ld [wMobileTaskStep], a
	ld hl, hROMBankLo
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, wMobileAdapterType
	ld a, $02
	farcall MobileAPI
	ret

.l4176 ; 54:4176
	; [CONFIRMED] 24 insn(s); 24 executed (in up to 4/18 scenarios)
	ld a, $03
	ld [wMobileTaskKind], a
	ld a, $02
	ld [wMobileTaskStep], a
	ld de, wRam_C480
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
	jr nz, .l41B1
	bit 0, a
	jr z, .l41B7
	ld a, $01
	ret

.l41B1 ; 54:41B1
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 54:41A8 (executed) [executed in 5 scenarios]
	call Mobile_FetchResult
	ld a, $FF
	ret

.l41B7 ; 54:41B7
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 3/18 scenarios)
	ld a, $36
	farcall MobileAPI
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret

Function_54_41C5:: ; 54:41C5
	; [PROBABLE] 25 insn(s): start of the function that ends in the FarCall sites at 54:41FB-4274
	; (writes WRAM $C1D8/$C1D9/$C1DB, tests bits of $C69F, register setup ld de,$C480 ; ld bc,0 ; ld
	; a,$28 for the FarCall at 41FB); contains the branches to 4204/4215/422E classified below;
	; follows the ret at 41C4; well-formed instruction chain (clean decode, all direct targets land
	; on instruction starts, lands exactly on the next code region); no direct caller/table entry
	; found: entry HYPOTHESIS
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ret

	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l41E6
	bit 2, a
	jr nz, .l41EC
	bit 0, a
	jr z, .l4215
	ld a, $01
	ret
.l41E6 ; 54:41E6
	call Mobile_FetchResult
	ld a, $FF
	ret
.l41EC ; 54:41EC
	ld a, [wMobileSDK_State]
	cp a, $1A
	jr z, .l4204
	ld de, wRam_C480
	ld bc, $0000
	ld a, $28

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

.l4204 ; 54:4204
	; [PROBABLE] 3 insn(s) (ld de,$C480 ; ld bc,0 ; ld a,$24) register setup for the FarCall at
	; 420C; entered by jr z from 54:41F1 (this classification)
	ld de, wRam_C480
	ld bc, $0000
	ld a, $24

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

.l4215 ; 54:4215
	; [PROBABLE] 10 insn(s) (ld hl,$C1D9 ; inc [hl] ; ld a,[hl] ; dec a ; jr z ... ret) ; entered by
	; jr z from 54:41E1 (this classification)
	ld hl, wMobileTaskStep
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .l4223
	dec a
	jr z, .l422E
	ld a, $FF
	ret
.l4223 ; 54:4223
	ld a, $0A

	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: site x3; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld a, $01
	ret

.l422E ; 54:422E
	; [PROBABLE] 1 insn (ld a,$36) ; entered by jr z from 54:421E (this classification)
	ld a, $36

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: site x5; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall MobileAPI
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret

Mobile_BeginCancel:: ; 54:423C
Function_54_423C::
	; [CONFIRMED] 25 insn(s); 25 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld a, [wTimerEnable]
	bit 0, a
	jr z, .l425A
.loop ; 54:4251
	ld a, $34
	farcall MobileAPI
	ret
.l425A ; 54:425A
	ld a, [wMobileSDK_State]
	cp a, $02
	jr nc, .loop
	xor a, a
	ld [wTimerEnable], a
	ret

Mobile_CancelPoll:: ; 54:4266
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l4274
	bit 0, a
	jr z, .l427A
	ld a, $01
	ret

.l4274 ; 54:4274
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 54:426B (executed)
	call Mobile_FetchResult
	ld a, $FF
	ret

.l427A ; 54:427A
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios) (part of region $427A-$42F5)
	ld a, $36
	farcall MobileAPI
	ld hl, wMobileTaskKind
	xor a, a
	ld [hl], a
	ret
