; engine/mobile/http.asm
; bank 54, $4288-$44FE (630 bytes); pinned by layout.link
; HTTP GET/POST start and poll, URL path/location helpers, stop and command-timeout checks

SECTION "engine/mobile/http", ROMX

; ---- code $4288-$42F5 (109 bytes) [CONFIRMED] 61 insn(s); 61 executed (in up to 4/18 scenarios) (part of region $427A-$42F5)

Http_StartGet:: ; 54:4288
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
	ld [wRam_C1DC], a
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

Label_54_42E6:: ; 54:42E6
	ld a, [hli]
	or a, a
	jr z, Label_54_42F1
	cp a, $2F
	jr nz, Label_54_42E6
	inc e
	jr Label_54_42E6

Label_54_42F1:: ; 54:42F1
	ld a, e
	cp a, $03
	ret nc

; ---- code $42F5-$42FB (6 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the retcc at 54:42F4 (executed)
	xor a, a
	ld [hld], a
	ld a, $2F
	ld [hl], a
	ret

; ---- code $42FB-$437C (129 bytes) [CONFIRMED] 60 insn(s); 60 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Http_StartPost:: ; 54:42FB
Function_54_42FB::
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
	ld [wRam_C1DC], a
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
	jr nz, Label_54_436B
	bit 2, a
	jp nz, Label_54_43F1
	bit 0, a
	jp z, Label_54_43EE
	ld a, $01
	ret

Label_54_436B:: ; 54:436B
	ld a, $00
	farcall MobileAPI
	cp a, $32
	jr nz, Label_54_4385
	ld a, $03
	cp a, h
	jr nz, Label_54_4383

; ---- code $437C-$4383 (7 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 54:437A (executed) [executed in 1 scenarios]
	ld a, l
	dec a
	jr z, Label_54_4393
	dec a
	jr z, Label_54_4393

; ---- code $4383-$4393 (16 bytes) [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)

Label_54_4383:: ; 54:4383
	ld a, $32

Label_54_4385:: ; 54:4385
	ld [wMobileResultCode], a
	ld a, l
	ld [wMobileResultDetail], a
	ld a, h
	ld [wMobileResultDetail + 1], a
	ld a, $FF
	ret

; ---- code $4393-$43A3 (16 bytes) [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 1; entered by jrcc from 54:437E (PROBABLE code) | 8 insn(s) executed; cut out of the PROBABLE region 4393-43EE by apply_coverage --split [executed in 2 scenarios]

Label_54_4393:: ; 54:4393
	ld a, [wMobileRetriesLeft]
	or a, a
	jr z, Label_54_4383
	ld hl, $C1DB
	dec [hl]
	ld a, [wCommSessionKind]
	or a, a
	jr z, Label_54_43A8

; ---- code $43A3-$43A8 (5 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4393-43EE by apply_coverage --split
	ld a, $07
	ld [wMobileTaskKind], a

; ---- code $43A8-$43CF (39 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4393-43EE by apply_coverage --split [executed in 2 scenarios]

Label_54_43A8:: ; 54:43A8
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
	jr z, Label_54_43CF
	cp a, $07
	jr z, Label_54_43DA
	ld a, $2A
	farcall MobileAPI
	ld a, $01
	ret

; ---- code $43CF-$43EE (31 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4393-43EE by apply_coverage --split

Label_54_43CF:: ; 54:43CF
	ld a, $2C
	farcall MobileAPI
	ld a, $01
	ret

Label_54_43DA:: ; 54:43DA
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

; ---- code $43EE-$43F1 (3 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_54_43EE:: ; 54:43EE
	ld a, $00
	ret

; ---- code $43F1-$4409 (24 bytes) [CONFIRMED] 102 insn(s) reached by static flow only; seeds: exec x102; min discovery hops 1; entered by jpcc from 54:4360 (executed) | 9 insn(s) executed; cut out of the PROBABLE region 43F1-44AC by apply_coverage --split [executed in 2 scenarios]

Label_54_43F1:: ; 54:43F1
	ld bc, $0000
	ld a, [wMobileTaskKind]
	cp a, $03
	jr z, Label_54_4409
	ld a, $2A
	farcall MobileAPI
	ld a, $01
	ld [wRam_C1DC], a
	ret

; ---- code $4409-$4417 (14 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 43F1-44AC by apply_coverage --split

Label_54_4409:: ; 54:4409
	ld a, $2C
	farcall MobileAPI
	ld a, $01
	ld [wRam_C1DC], a
	ret

; ---- code $4417-$44A0 (137 bytes) [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 43F1-44AC by apply_coverage --split [executed in 1 scenarios]

Url_ResolveLocation:: ; 54:4417
	ld l, c
	ld h, b
	ld a, [hli]
	cp a, $68
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $74
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $74
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $70
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $3A
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $2F
	jr nz, Label_54_444B
	ld a, [hli]
	cp a, $2F
	jr nz, Label_54_444B
	ld hl, $C1D6
	ld a, [hli]
	ld d, [hl]
	ld e, a
	ld l, c
	ld h, b
	farcall CopyString
	ret

Label_54_444B:: ; 54:444B
	ld l, c
	ld h, b
	ld a, [hl]
	cp a, $2F
	jr z, Label_54_446F
	ld hl, $C1D6
	ld a, [hli]
	ld h, [hl]
	ld l, a

Label_54_4458:: ; 54:4458
	ld a, [hli]
	or a, a
	jr nz, Label_54_4458
	dec hl

Label_54_445D:: ; 54:445D
	ld a, [hld]
	cp a, $2F
	jr nz, Label_54_445D
	inc hl
	inc hl
	ld e, l
	ld d, h

Label_54_4466:: ; 54:4466
	ld l, c
	ld h, b
	farcall CopyString
	ret

Label_54_446F:: ; 54:446F
	ld hl, $C1D6
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $0007
	add hl, de

Label_54_4479:: ; 54:4479
	ld a, [hli]
	cp a, $2F
	jr nz, Label_54_4479
	dec hl
	ld e, l
	ld d, h
	jr Label_54_4466

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
	jr nz, Label_54_44A0
	bit 0, a
	jr z, Label_54_44A6
	ld a, $01
	ret

; ---- code $44A0-$44A6 (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 43F1-44AC by apply_coverage --split

Label_54_44A0:: ; 54:44A0
	call Mobile_FetchResult
	ld a, $FF
	ret

; ---- code $44A6-$44AC (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 43F1-44AC by apply_coverage --split [executed in 4 scenarios]

Label_54_44A6:: ; 54:44A6
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

; ---- code $44AC-$44BF (19 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Mobile_CheckTimeout:: ; 54:44AC
Function_54_44AC::
	ld a, [wMobileTimeoutIssued]
	or a, a
	jr nz, Label_54_44D7
	ld a, [wCommTimeoutMinutes]
	ld b, a
	ld a, [wTimerBMinutes]
	cp a, b
	jr z, Label_54_44BF
	xor a, a
	jr Label_54_44C1

; ---- code $44BF-$44C1 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 54:44BA (executed) [executed in 1 scenarios]

Label_54_44BF:: ; 54:44BF
	ld a, $FF

; ---- code $44C1-$44C3 (2 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)

Label_54_44C1:: ; 54:44C1
	or a, a
	ret z

; ---- code $44C3-$44F8 (53 bytes) [CONFIRMED] 306 insn(s) reached by static flow only; seeds: exec x306; min discovery hops 0; fall-through of the retcc at 54:44C2 (executed) | 27 insn(s) executed; cut out of the PROBABLE region 44C3-475A by apply_coverage --split [executed in 1 scenarios]
	pop hl
	xor a, a
	ld [wMobileTaskStep], a
	inc a
	ld [wMobileTimeoutIssued], a
	ld a, $3C
	farcall MobileAPI
	ld a, $01
	ret

Label_54_44D7:: ; 54:44D7
	pop hl
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, Label_54_44F8
	bit 0, a
	jr z, Label_54_44E6
	ld a, $01
	ret

Label_54_44E6:: ; 54:44E6
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

; ---- code $44F8-$44FE (6 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 44C3-475A by apply_coverage --split

Label_54_44F8:: ; 54:44F8
	call Mobile_FetchResult
	ld a, $FF
	ret
