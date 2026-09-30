; engine/mobile/http.asm
; bank 54, $4288-$44FE (630 bytes); pinned by layout.link
; HTTP GET/POST start and poll, URL path/location helpers, stop and command-timeout checks

SECTION "engine/mobile/http", ROMX

Http_StartGet:: ; 54:4288
	; [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios) (part of region $427A-$42F5)
	ld a, l
	ld [wMobileTaskArgs + 4], a
	ld a, h
	ld [wMobileTaskArgs + 5], a
	ld a, e
	ld [wMobileTaskArgs + 2], a
	ld a, d
	ld [wMobileTaskArgs + 3], a
	ld a, c
	ld [wMobileTaskArgs], a
	ld a, b
	ld [wMobileTaskArgs + 1], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld [wBrowserPendingMessage], a
	push de
	push hl
	call Url_EnsurePath
	pop hl
	ld de, $C240
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld hl, $C1E0
	farcall CopyString
	ld hl, $C220
	farcall CopyString
	pop de
	ld hl, $C240
	ld a, $2A
	farcall MobileAPI
	ret

Url_EnsurePath:: ; 54:42E4
	ld e, $00
.loop ; 54:42E6
	ld a, [hli]
	or a, a
	jr z, .l42F1
	cp a, $2F
	jr nz, .loop
	inc e
	jr .loop
.l42F1 ; 54:42F1
	ld a, e
	cp a, $03
	ret nc

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the retcc at 54:42F4 (executed)
	xor a, a
	ld [hld], a
	ld a, $2F
	ld [hl], a
	ret

Http_StartPost:: ; 54:42FB
Function_54_42FB::
	; [CONFIRMED] 60 insn(s); 60 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, l
	ld [wMobileTaskArgs + 4], a
	ld a, h
	ld [wMobileTaskArgs + 5], a
	ld a, e
	ld [wMobileTaskArgs + 2], a
	ld a, d
	ld [wMobileTaskArgs + 3], a
	ld a, c
	ld [wMobileTaskArgs], a
	ld a, b
	ld [wMobileTaskArgs + 1], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $03
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld [wBrowserPendingMessage], a
	push de
	push hl
	call Url_EnsurePath
	pop hl
	ld de, $C244
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	inc de
	ld hl, $C1E0
	farcall CopyString
	ld hl, $C220
	farcall CopyString
	pop de
	ld hl, $C240
	ld a, $2C
	farcall MobileAPI
	ret

Http_Poll:: ; 54:4357
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l436B
	bit 2, a
	jp nz, .l43F1
	bit 0, a
	jp z, .l43EE
	ld a, $01
	ret
.l436B ; 54:436B
	ld a, $00
	farcall MobileAPI
	cp a, $32
	jr nz, .l4385
	ld a, $03
	cp a, h
	jr nz, .l4383

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 54:437A (executed) [executed in 1 scenarios]
	ld a, l
	dec a
	jr z, .l4393
	dec a
	jr z, .l4393

.l4383 ; 54:4383
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	ld a, $32
.l4385 ; 54:4385
	ld [wMobileResultCode], a
	ld a, l
	ld [wMobileResultDetail], a
	ld a, h
	ld [wMobileResultDetail + 1], a
	ld a, $FF
	ret

.l4393 ; 54:4393
	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1;
	; entered by jrcc from 54:437E (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE
	; region 4393-43EE by apply_coverage --split [executed in 2 scenarios]
	ld a, [wMobileRetriesLeft]
	or a, a
	jr z, .l4383
	ld hl, $C1DB
	dec [hl]
	ld a, [wCommSessionKind]
	or a, a
	jr z, .skip

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4393-43EE by apply_coverage --split
	ld a, $07
	ld [wMobileTaskKind], a

.skip ; 54:43A8
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4393-43EE by apply_coverage
	; --split [executed in 2 scenarios]
	call Url_ResolveLocation
	ld hl, $C1D2
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, $C240
	ld a, [wMobileTaskKind]
	cp a, $03
	jr z, .l43CF
	cp a, $07
	jr z, .l43DA
	ld a, $2A
	farcall MobileAPI
	ld a, $01
	ret

.l43CF ; 54:43CF
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4393-43EE by apply_coverage --split
	ld a, $2C
	farcall MobileAPI
	ld a, $01
	ret
.l43DA ; 54:43DA
	ld a, $01
	ld [wMobileTaskKind], a
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, $2A
	farcall MobileAPI
	ld a, $01
	ret

.l43EE ; 54:43EE
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)
	ld a, $00
	ret

.l43F1 ; 54:43F1
	; [CONFIRMED] 102 insn(s) reached by static flow only; seeds: exec x102; min discovery hops 1;
	; entered by jpcc from 54:4360 (executed) | 9 insn(s) executed; cut out of the PROBABLE region
	; 43F1-44AC by apply_coverage --split [executed in 2 scenarios]
	ld bc, $0000
	ld a, [wMobileTaskKind]
	cp a, $03
	jr z, .l4409
	ld a, $2A
	farcall MobileAPI
	ld a, $01
	ld [wBrowserPendingMessage], a
	ret

.l4409 ; 54:4409
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 43F1-44AC by apply_coverage --split
	ld a, $2C
	farcall MobileAPI
	ld a, $01
	ld [wBrowserPendingMessage], a
	ret

Url_ResolveLocation:: ; 54:4417
	; [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 43F1-44AC by apply_coverage
	; --split [executed in 1 scenarios]
	ld l, c
	ld h, b
	ld a, [hli]
	cp a, $68
	jr nz, .l444B
	ld a, [hli]
	cp a, $74
	jr nz, .l444B
	ld a, [hli]
	cp a, $74
	jr nz, .l444B
	ld a, [hli]
	cp a, $70
	jr nz, .l444B
	ld a, [hli]
	cp a, $3A
	jr nz, .l444B
	ld a, [hli]
	cp a, $2F
	jr nz, .l444B
	ld a, [hli]
	cp a, $2F
	jr nz, .l444B
	ld hl, $C1D6
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld l, c
	ld h, b
	farcall CopyString
	ret
.l444B ; 54:444B
	ld l, c
	ld h, b
	ld a, [hl]
	cp a, $2F
	jr z, .l446F
	ld hl, $C1D6
	ld a, [hli]
	ld h, [hl]
	ld l, a
.l4458 ; 54:4458
	ld a, [hli]
	or a, a
	jr nz, .l4458
	dec hl
.l445D ; 54:445D
	ld a, [hld]
	cp a, $2F
	jr nz, .l445D
	inc hl
	inc hl
	ld e, l
	ld d, h
.l4466 ; 54:4466
	ld l, c
	ld h, b
	farcall CopyString
	ret
.l446F ; 54:446F
	ld hl, $C1D6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0007
	add hl, de
.l4479 ; 54:4479
	ld a, [hli]
	cp a, $2F
	jr nz, .l4479
	dec hl
	ld e, l
	ld d, h
	jr .l4466

Mobile_BeginStop:: ; 54:4483
	ld a, [wMobileSDK_State]
	cp a, $02
	ret z
	ld a, $3C
	farcall MobileAPI
	ret

Mobile_StopPoll:: ; 54:4492
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l44A0
	bit 0, a
	jr z, .l44A6
	ld a, $01
	ret

.l44A0 ; 54:44A0
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 43F1-44AC by apply_coverage --split
	call Mobile_FetchResult
	ld a, $FF
	ret

.l44A6 ; 54:44A6
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 43F1-44AC by apply_coverage
	; --split [executed in 4 scenarios]
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

Mobile_CheckTimeout:: ; 54:44AC
Function_54_44AC::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wMobileTimeoutIssued]
	or a, a
	jr nz, .l44D7
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, .l44BF
	xor a, a
	jr .l44C1

.l44BF ; 54:44BF
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 54:44BA (executed) [executed in 1 scenarios]
	ld a, $FF

.l44C1 ; 54:44C1
	; [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)
	or a, a
	ret z

	; [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 0;
	; fall-through of the retcc at 54:44C2 (executed) | 27 insn(s) executed; cut out of the PROBABLE
	; region 44C3-475A by apply_coverage --split [executed in 1 scenarios]
	pop hl
	xor a, a
	ld [wMobileTaskStep], a
	inc a
	ld [wMobileTimeoutIssued], a
	ld a, $3C
	farcall MobileAPI
	ld a, $01
	ret
.l44D7 ; 54:44D7
	pop hl
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l44F8
	bit 0, a
	jr z, .l44E6
	ld a, $01
	ret
.l44E6 ; 54:44E6
	ld a, $26
	ld [wMobileResultCode], a
	xor a, a
	ld hl, $C1DE
	ld [hli], a
	ld [hl], a
	xor a, a
	ld [wMobileTaskKind], a
	ld a, $FF
	ret

.l44F8 ; 54:44F8
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 44C3-475A by apply_coverage --split
	call Mobile_FetchResult
	ld a, $FF
	ret
