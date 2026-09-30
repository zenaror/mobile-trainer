; engine/html/parser.asm
; bank 74, $4165-$44A0 (827 bytes); pinned by layout.link
; Html_ParsePage/ScanPage/ParseSource

SECTION "engine/html/parser", ROMX

; ---- code $4165-$417F (26 bytes) [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_MetaResultToError:: ; 74:4165
Function_74_4165::
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D340
	ld bc, Html_ResultCodePtrs
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	call Function_00_10E9
	cp a, $00
	jp z, Label_74_41EF

; ---- code $417F-$41EF (112 bytes) [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 0; fall-through of the jpcc at 74:417C (executed)
	cp a, $02
	jp z, Label_74_41EF
	ld hl, $D380
	xor a, a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	ldh [hRam_FFB2], a
	ldh [hRam_FFB3], a

Html_MetaResultToError_HexLoop:: ; 74:4190
	ld a, [hli]
	or a, a
	jp z, Label_74_41F2
	cp a, $30
	jr c, Html_MetaResultToError_HexLoop
	cp a, $3A
	jr c, Label_74_41B5
	cp a, $41
	jr c, Html_MetaResultToError_HexLoop
	cp a, $47
	jr c, Label_74_41B1
	cp a, $61
	jr c, Html_MetaResultToError_HexLoop
	cp a, $67
	jr nc, Html_MetaResultToError_HexLoop
	sub a, $61
	jr Label_74_41B7

Label_74_41B1:: ; 74:41B1
	sub a, $41
	jr Label_74_41B7

Label_74_41B5:: ; 74:41B5
	sub a, $30

Label_74_41B7:: ; 74:41B7
	ld c, a
	ldh a, [hRam_FFB0]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hRam_FFB0], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hRam_FFB1]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hRam_FFB1], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hRam_FFB2]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hRam_FFB2], a
	ld a, b
	and a, $0F
	ld c, a
	ldh a, [hRam_FFB3]
	swap a
	ld b, a
	and a, $F0
	or a, c
	ldh [hRam_FFB3], a
	jp Html_MetaResultToError_HexLoop

; ---- code $41EF-$41F2 (3 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)

Label_74_41EF:: ; 74:41EF
	ld a, $00
	ret

; ---- code $41F2-$4207 (21 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jpcc from 74:4192 (PROBABLE code)

Label_74_41F2:: ; 74:41F2
	ld a, $04
	ld [wBrowserFetchResult], a
	ld a, $40
	ld [wMobileResultCode], a
	ldh a, [hRam_FFB0]
	ld [wMobileResultDetail], a
	ldh a, [hRam_FFB1]
	ld [wMobileResultDetail + 1], a
	ret

; ---- code $4207-$4326 (287 bytes) [CONFIRMED] 114 insn(s); 114 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

Html_ParsePage:: ; 74:4207
Function_74_4207::
	ld bc, $0000
	ld de, $0000
	farcall Browser_SetScroll
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	xor a, a
	ld [wHtmlScanOnly], a
	ld a, $00
	ldh [hPageHeaderPtr], a
	ldh [hRam_FFB8], a
	ld a, $D0
	ldh [hPageHeaderPtr + 1], a
	ldh [hRam_FFB9], a
	ld a, $04
	ldh [hPageHeaderPtr + 2], a
	ldh [hRam_FFBA], a
	ld de, $D000
	ld a, $05
	ldh [hTextX], a
	ld hl, $B000
	ld a, $03
	farcall Html_ParseSource
	farcall Html_LoadPageImages
	farcall Html_MetaResultToError
	ret

Html_ScanPage:: ; 74:4254
	ld bc, $0000
	ld de, $0000
	farcall Browser_SetScroll
	ld bc, $0090
	ld de, $0060
	farcall Browser_SetViewport
	ld a, $FF
	ld [wHtmlScanOnly], a
	ld a, $00
	ldh [hPageHeaderPtr], a
	ldh [hRam_FFB8], a
	ld a, $D0
	ldh [hPageHeaderPtr + 1], a
	ldh [hRam_FFB9], a
	ld a, $04
	ldh [hPageHeaderPtr + 2], a
	ldh [hRam_FFBA], a
	ld de, $D000
	ld a, $05
	ldh [hTextX], a
	ld hl, $B000
	ld a, $03
	farcall Html_ParseSource
	ret

Html_ParseSource:: ; 74:4296
	ldh [hRam_FFB5], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push hl
	ld a, $06
	ld hl, $D300
	ld bc, $0100
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	call FillBytes
	call Function_00_0392
	ldh a, [hRam_FFB8]
	ld l, a
	ldh a, [hRam_FFB9]
	ld h, a
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	ld bc, $1000
	xor a, a
	call FillBytes
	call Function_00_0392
	pop hl
	ld a, e
	ldh [hRam_FFBB], a
	ld a, d
	ldh [hTextY], a
	ldh a, [hTextX]
	call BankSwitch_D
	push hl
	ld h, d
	ld l, e
	ld bc, $1000
	xor a, a
	call FillBytes
	call Function_00_0392
	farcall Html_InitParser
	farcall Html_LinkTable_Init
	farcall Html_Layout_Init
	pop hl
	push de
	ldh a, [hRam_FFB5]
	farcall Html_NextResourceRecord
	pop de
	ldh a, [hTextX]
	call BankSwitch_D
	ld a, $20
	ldh [hRam_FFB3], a

Html_ParseSource_Loop:: ; 74:4307
	call Function_00_0392
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $21
	jr c, Label_74_4359
	cp a, $3C
	jp z, Html_ParseSource_Tag
	cp a, $26
	jr z, Html_ParseSource_Entity
	ldh [hRam_FFB3], a
	cp a, $81
	jr c, Label_74_4336
	cp a, $A0
	jr c, Label_74_4337

; ---- code $4326-$4336 (16 bytes) [PROBABLE] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 74:4324 (executed) | 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4326-4337 by apply_coverage --split
	cp a, $E0
	jr c, Label_74_4336
	cp a, $F0
	jr c, Label_74_4337
	cp a, $F8
	jr c, Label_74_4336
	cp a, $FA
	jr c, Label_74_4337

; ---- code $4336-$4337 (1 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4326-4337 by apply_coverage --split [executed in 9 scenarios]

Label_74_4336:: ; 74:4336
	or a, a

; ---- code $4337-$434C (21 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 2/18 scenarios)

Label_74_4337:: ; 74:4337
	jr nc, Label_74_434C
	inc de
	inc de
	ld a, $E0
	cp a, d
	dec de
	dec de
	jp z, Html_ParseSource_End
	ldh a, [hRam_FFB3]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	jr Html_ParseSource_Loop

; ---- code $434C-$4359 (13 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1; entered by jrcc from 74:4337 (executed) [executed in 4 scenarios]

Label_74_434C:: ; 74:434C
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ldh a, [hRam_FFB3]
	ld [de], a
	inc de
	jr Html_ParseSource_Loop

; ---- code $4359-$4361 (8 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 2/18 scenarios)

Label_74_4359:: ; 74:4359
	ld c, a
	ld a, [wHtmlFlags]
	and a, $08
	jr z, Label_74_4374

; ---- code $4361-$4374 (19 bytes) [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 0; fall-through of the jrcc at 74:435F (executed) [executed in 1 scenarios]
	ld a, c
	cp a, $0D
	jp z, Html_ParseSource_PreCR
	cp a, $0A
	jp z, Label_74_4C71
	cp a, $09
	jr z, Label_74_4385
	ld c, $20
	jr Label_74_4385

; ---- code $4374-$4392 (30 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)

Label_74_4374:: ; 74:4374
	ld a, [hli]
	or a, a
	jr z, Html_ParseSource_End
	cp a, $21
	jr c, Label_74_4374
	dec hl
	ldh a, [hRam_FFB3]
	cp a, $20
	jr z, Html_ParseSource_Loop
	ld c, $20

Label_74_4385:: ; 74:4385
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ld a, c
	ld [de], a
	inc de
	jp Html_ParseSource_Loop

; ---- code $4392-$43C3 (49 bytes) [CONFIRMED] 29 insn(s) reached by static flow only; seeds: exec x29; min discovery hops 1; entered by jrcc from 74:431A (executed) [executed in 1 scenarios]

Html_ParseSource_Entity:: ; 74:4392
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	ld bc, Html_EntityPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr z, Label_74_43BA
	ldh [hRam_FFB3], a
	inc de
	ld a, $E0
	cp a, d
	dec de
	jr z, Html_ParseSource_End
	ldh a, [hRam_FFB3]
	ld [de], a
	inc de
	ld a, [hli]
	cp a, $3B
	jp z, Html_ParseSource_Loop
	dec hl
	jp Html_ParseSource_Loop

Label_74_43BA:: ; 74:43BA
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a
	jp Html_ParseSource_Loop

; ---- code $43C3-$43C4 (1 bytes) [HYPOTHESIS] single 'pop hl' (e1) after the unconditional 'jp $4307' at 74:43C0; no branch/pointer targets 43C3 (tgt scan of all code regions + word scan), so unreachable; falls into the executed 43C4 (target of 13 jz/jp)
	pop hl

; ---- code $43C4-$445B (151 bytes) [CONFIRMED] 81 insn(s); 81 executed (in up to 2/18 scenarios)

Html_ParseSource_End:: ; 74:43C4
	call Function_00_0392
	farcall Html_Layout_WrapRun
	farcall Html_Layout_ClearAllFloats
	ldh a, [hRam_FFB8]
	ld l, a
	ldh a, [hRam_FFB9]
	ld h, a
	ld bc, $0015
	add hl, bc
	ldh a, [hRam_FFBA]
	call BankSwitch_H
	ldh a, [hTextX + 1]
	ld [hli], a
	ldh a, [hRam_FFBF]
	ld [hli], a
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hRam_FFC8]
	ld c, a
	ldh a, [hRam_FFC9]
	ld b, a
	ld hl, $FFA0
	add hl, bc
	bit 7, h
	jr z, Label_74_43FF
	ld hl, $0000

Label_74_43FF:: ; 74:43FF
	ld a, l
	ldh [hViewScrollMax], a
	ld a, h
	ldh [hViewScrollMax + 1], a
	ret

Html_ParseSource_Tag:: ; 74:4406
	dec de
	ld a, [de]
	cp a, $20
	jr z, Label_74_440D
	inc de

Label_74_440D:: ; 74:440D
	ld a, [hl]
	ldh [hRam_FFB4], a
	cp a, $2F
	jr nz, Label_74_4415
	inc hl

Label_74_4415:: ; 74:4415
	ld a, l
	ldh [hRam_FFB0], a
	ld a, h
	ldh [hRam_FFB1], a
	inc de
	ld a, $E0
	cp a, d
	dec de
	jp z, Html_ParseSource_End
	xor a, a
	ld [de], a
	ldh a, [hRam_FFB6]
	ld c, a
	ldh a, [hRam_FFB7]
	or a, c
	jp nz, Html_ParseSource_TitleTag
	ld bc, Html_TagPtrs
	push de
	call Function_00_10E9
	pop de
	or a, a
	jr nz, Html_DispatchTag

Label_74_4439:: ; 74:4439
	ldh a, [hRam_FFB0]
	ld l, a
	ldh a, [hRam_FFB1]
	ld h, a

Label_74_443F:: ; 74:443F
	ldh a, [hRam_FFB5]
	call BankSwitch_H
	ldh a, [hTextX]
	call BankSwitch_D

Label_74_4449:: ; 74:4449
	ld a, $20
	ldh [hRam_FFB3], a

Label_74_444D:: ; 74:444D
	ld a, [hli]
	or a, a
	jp z, Html_ParseSource_End
	cp a, $3E
	jp z, Html_ParseSource_Loop
	cp a, $81
	jr c, Label_74_446F

; ---- code $445B-$446F (20 bytes) [PROBABLE] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 0; fall-through of the jrcc at 74:4459 (executed)
	cp a, $A0
	jr c, Label_74_4470
	cp a, $E0
	jr c, Label_74_446F
	cp a, $F0
	jr c, Label_74_4470
	cp a, $F8
	jr c, Label_74_446F
	cp a, $FA
	jr c, Label_74_4470

; ---- code $446F-$4473 (4 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 2/18 scenarios)

Label_74_446F:: ; 74:446F
	or a, a

Label_74_4470:: ; 74:4470
	jp nc, Label_74_4477

; ---- code $4473-$4477 (4 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jpcc at 74:4470 (executed)
	ld a, [hli]
	jp Label_74_444D

; ---- code $4477-$44A0 (41 bytes) [CONFIRMED] 26 insn(s); 26 executed (in up to 2/18 scenarios)

Label_74_4477:: ; 74:4477
	dec hl
	ld bc, $4110
	call Function_00_1119
	jp Label_74_444D

Html_DispatchTag:: ; 74:4481
	cp a, $0F
	jr z, Label_74_4490
	ld b, a
	ld a, [hl]
	cp a, $3E
	jr z, Label_74_448F
	cp a, $21
	jr nc, Label_74_4449

Label_74_448F:: ; 74:448F
	ld a, b

Label_74_4490:: ; 74:4490
	add a, a
	push hl
	add a, $A0
	ld l, a
	ld a, $00
	adc a, $44
	ld h, a
	ld a, [hli]
	ld b, [hl]
	ld c, a
	pop hl
	push bc
	ret
