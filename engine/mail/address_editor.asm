; engine/mail/address_editor.asm
; bank 2D, $65B0-$7120 (2928 bytes); pinned by layout.link
; mail address editor, joypad repeat reset

SECTION "engine/mail/address_editor", ROMX

; ---- code $65B0-$65FD (77 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailAddr_Edit:: ; 2D:65B0
Function_2D_65B0::
	push af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call Function_00_0464
	pop af
	push af
	call MailAddr_SetupScreen
	ld d, $40

Label_2D_65F0:: ; 2D:65F0
	push de
	call MailAddr_CursorRightStep
	pop de
	dec d
	jr nz, Label_2D_65F0
	pop af
	cp a, $01
	jr nz, Label_2D_6603

; ---- code $65FD-$6603 (6 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2D:65FB (executed); upgraded by classifier g3: all 2 instruction starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the mapper run, e.g. mail_inbox/mail_send/mail_compose)
	call MailAddr_KeyboardLoop
	jp Label_2D_6621

; ---- code $6603-$6634 (49 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 2/18 scenarios)

Label_2D_6603:: ; 2D:6603
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	call MailAddr_PlaceCursorSprites
	ldh a, [hJoyPressed]
	and a, $01
	jp z, Label_2D_669B
	call MailAddr_OpenKeyboard

Label_2D_6621:: ; 2D:6621
	cp a, $07
	jr nz, Label_2D_6693
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld a, [hl]
	cp a, $00
	jr nz, Label_2D_666B

; ---- code $6634-$666B (55 bytes) [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 0; fall-through of the jrcc at 2D:6632 (executed) [executed in 3 scenarios]
	ld de, $0205
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	jr Label_2D_6603

; ---- code $666B-$6693 (40 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2D_666B:: ; 2D:666B
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	pop bc
	xor a, a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	ld a, $90
	ldh [rWY], a
	farcall Function_00_09B6
	farcall Function_00_0956
	xor a, a
	ret

; ---- code $6693-$669B (8 bytes) [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1; entered by jrcc from 2D:6623 (executed) [executed in 4 scenarios]

Label_2D_6693:: ; 2D:6693
	push bc
	farcall Joypad_Update
	pop bc

; ---- code $669B-$66A2 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2D_669B:: ; 2D:669B
	ldh a, [hJoyPressed]
	and a, $02
	jp z, Label_2D_6784

; ---- code $66A2-$6726 (132 bytes) [CONFIRMED] 108 insn(s) reached by static flow only; seeds: exec x108; min discovery hops 0; fall-through of the jpcc at 2D:669F (executed) | 65 insn(s) executed; cut out of the PROBABLE region 66A2-6784 by apply_coverage --split [executed in 1 scenarios]
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	cp a, $14
	jr c, Label_2D_66CD
	ld de, $D000
	ld hl, $DA10
	call Function_00_0A65
	ld de, $D000
	ld hl, $DA20
	call Function_00_0A65

Label_2D_66CD:: ; 2D:66CD
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	dec a
	jp z, Label_2D_676F
	dec a
	jr nz, Label_2D_6726
	push bc
	ld de, $0211
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jp nz, Label_2D_6603
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $6726-$676F (73 bytes) [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region 66A2-6784 by apply_coverage --split

Label_2D_6726:: ; 2D:6726
	push bc
	ld de, $020F
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc
	dec a
	jp nz, Label_2D_6603
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $676F-$6784 (21 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 66A2-6784 by apply_coverage --split [executed in 5 scenarios]

Label_2D_676F:: ; 2D:676F
	call MailCompose_ConfirmDiscard
	inc a
	jr z, Label_2D_6784
	farcall Stat_DisableScrollSplit
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $6784-$67AB (39 bytes) [CONFIRMED] 16 insn(s); 16 executed (in up to 2/18 scenarios)

Label_2D_6784:: ; 2D:6784
	ldh a, [hJoyPressedRepeat]
	and a, $04
	jr z, Label_2D_67B8
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailComposeMode]
	push af
	farcall Function_00_09B6
	farcall Function_00_0956
	call MailAddr_OpenAddressBook
	inc a
	jr nz, Label_2D_67AB
	pop af
	xor a, a
	jp MailAddr_Edit

; ---- code $67AB-$67B8 (13 bytes) [CONFIRMED] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 1; entered by jrcc from 2D:67A4 (executed) [executed in 3 scenarios]

Label_2D_67AB:: ; 2D:67AB
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld [wMailComposeMode], a
	jp MailAddr_Edit

; ---- code $67B8-$67E1 (41 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios)

Label_2D_67B8:: ; 2D:67B8
	ldh a, [hJoyPressedRepeat]
	and a, $20
	call nz, MailAddr_CursorLeft
	ldh a, [hJoyPressedRepeat]
	and a, $10
	call nz, MailAddr_CursorRight
	ld d, $10
	jp Label_2D_6603

MailAddr_OpenAddressBook:: ; 2D:67CB
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	farcall AddrPick_Menu
	ret

; ---- code $67E1-$67FC (27 bytes) [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 1; entered by callcc from 2D:67BC (executed) | 18 insn(s) executed; cut out of the PROBABLE region 67E1-6808 by apply_coverage --split [executed in 6 scenarios]

MailAddr_CursorLeft:: ; 2D:67E1
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	inc c
	dec c
	jr nz, Label_2D_6802
	inc b
	dec b
	ret z

; ---- code $67FC-$6802 (6 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 67E1-6808 by apply_coverage --split
	dec b
	call MailAddr_GetCharPtr
	ld c, e
	ret

; ---- code $6802-$6808 (6 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 67E1-6808 by apply_coverage --split [executed in 2 scenarios]

Label_2D_6802:: ; 2D:6802
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a
	ret

; ---- code $6808-$681E (22 bytes) [CONFIRMED] 13 insn(s); 13 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailAddr_CursorRight:: ; 2D:6808
Function_2D_6808::
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0036
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc

MailAddr_CursorRightStep:: ; 2D:681C
	jr Label_2D_6827

; ---- code $681E-$6827 (9 bytes) [HYPOTHESIS] ld a,b ; cp $07 ; jr nz,$6827 ; ld a,c ; cp $0B ; ret z - unreached block the previous region jumps over (jr $6827); no reference found
	ld a, b
	cp a, $07
	jr nz, Label_2D_6827
	ld a, c
	cp a, $0B
	ret z

; ---- code $6827-$6838 (17 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios)

Label_2D_6827:: ; 2D:6827
	inc c
	dec c
	jr nz, Label_2D_6838
	call MailAddr_GetCharPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hl]
	cp a, $00
	ret z

; ---- code $6838-$6847 (15 bytes) [CONFIRMED] 62 insn(s) reached by static flow only; seeds: exec x62; min discovery hops 0; entered by jrcc from 2D:6829 (executed) | 9 insn(s) executed; cut out of the PROBABLE region 6838-68A9 by apply_coverage --split [executed in 8 scenarios]

Label_2D_6838:: ; 2D:6838
	call MailAddr_GetCharPtr
	cp a, $FF
	ret z
	inc c
	ld a, c
	ld [wTextEditGoalColumn], a
	ld a, $41
	cp a, c
	ret nz

; ---- code $6847-$684F (8 bytes) [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6838-68A9 by apply_coverage --split
	ld c, $40
	ld a, $40
	ld [wTextEditGoalColumn], a
	ret

; ---- code $684F-$688D (62 bytes) [CONFIRMED] 32 insn(s) executed; cut out of the PROBABLE region 6838-68A9 by apply_coverage --split [executed in 1 scenarios]

MailCompose_ConfirmDiscard:: ; 2D:684F
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wEditBodyBuf]
	cp a, $00
	jr nz, Label_2D_686E
	ld a, [wEditAddressBuf]
	cp a, $00
	jr nz, Label_2D_686E
	ld a, [wEditSubjectBuf]
	cp a, $00
	jr nz, Label_2D_686E

Label_2D_686B:: ; 2D:686B
	pop bc
	xor a, a
	ret

Label_2D_686E:: ; 2D:686E
	ld de, $0200
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show

; ---- code $688D-$68A9 (28 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6838-68A9 by apply_coverage --split
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	dec a
	jr z, Label_2D_686B
	pop bc
	ld a, $FF
	ret

; ---- code $68A9-$6973 (202 bytes) [CONFIRMED] 67 insn(s); 67 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailAddr_SetupScreen:: ; 2D:68A9
Function_2D_68A9::
	push af
	xor a, a
	ld [wTextEditGoalColumn], a
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	call TextTiles_UploadBuffersShort
	ld de, $9301
	ld hl, Gfx_MailAddr_Tiles
	ld a, $2D
	ld b, $92
	ld c, $40
	farcall Function_00_0749
	ld de, $9701
	ld hl, $7520
	ld a, $2D
	ld b, $97
	ld c, $0B
	farcall Function_00_0749
	ld de, $8800
	ld hl, $75D0
	ld a, $2D
	ld b, $94
	ld c, $2B
	farcall Function_00_0749
	ld de, $8000
	ld hl, $7880
	ld a, $2D
	ld b, $94
	ld c, $2D
	farcall Function_00_0749
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailAddr
	ld a, $2D
	farcall Function_00_08EA
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ld hl, $DA20
	ld de, $7B50
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	ldh a, [rLCDC]
	call Function_00_082C
	ld bc, $0000
	call MailAddr_PlaceCursorSprites
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20
	call TextTiles_UploadBuffersShort
	pop af
	push af
	dec a
	jr nz, Label_2D_69B3

; ---- code $6973-$69B3 (64 bytes) [CONFIRMED] 31 insn(s) reached by static flow only; seeds: exec x31; min discovery hops 0; fall-through of the jrcc at 2D:6971 (executed); upgraded by classifier g3: all 31 instruction starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the mapper run, e.g. mail_inbox/mail_send/mail_compose)
	farcall LCDOff
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $09
	ld b, $02
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $28
	ld [wSplitScrollY], a
	jr Label_2D_69B3

; ---- code $69B3-$69DF (44 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)

Label_2D_69B3:: ; 2D:69B3
	ld bc, $0028
	ld de, $D840
	ld hl, Palette_7F_7B00
	ld a, $7F
	farcall Palette_LoadToBuffer
	ld bc, $0030
	ld de, $D800
	ld hl, Palette_MailAddr_Bg
	ld a, $2D
	farcall Palette_LoadToBuffer
	farcall LCDOn
	pop af
	dec a
	jr nz, Label_2D_6A07

; ---- code $69DF-$6A07 (40 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 0; fall-through of the jrcc at 2D:69DD (executed); upgraded by classifier g3: all 18 instruction starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the mapper run, e.g. mail_inbox/mail_send/mail_compose)
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_00_047A
	ld hl, $D800
	farcall Palette_UploadBuffer
	ei
	call Function_00_0392
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	jr Label_2D_6A36

; ---- code $6A07-$6A5E (87 bytes) [CONFIRMED] 41 insn(s); 41 executed (in up to 2/18 scenarios)

Label_2D_6A07:: ; 2D:6A07
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit

Label_2D_6A36:: ; 2D:6A36
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0004
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	ld bc, $0000
	ret

MailAddr_PlaceCursorSprites:: ; 2D:6A4C
	push bc
	ld b, $00
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, c
	add a, $04
	ld c, a
	ld a, c
	cp a, $30
	jr c, Label_2D_6A63

; ---- code $6A5E-$6A63 (5 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2D:6A5C (executed) [executed in 1 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

; ---- code $6A63-$6A68 (5 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2D_6A63:: ; 2D:6A63
	ld a, c
	cp a, $18
	jr c, Label_2D_6A6D

; ---- code $6A68-$6A6D (5 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2D:6A66 (executed) [executed in 1 scenarios]
	inc b
	ld a, c
	sub a, $18
	ld c, a

; ---- code $6A6D-$6A74 (7 bytes) [CONFIRMED] 5 insn(s); 5 executed (in up to 2/18 scenarios)

Label_2D_6A6D:: ; 2D:6A6D
	inc b
	inc c
	ld a, $38

Label_2D_6A71:: ; 2D:6A71
	dec b
	jr z, Label_2D_6A78

; ---- code $6A74-$6A78 (4 bytes) [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0; fall-through of the jrcc at 2D:6A72 (executed) [executed in 1 scenarios]
	add a, $0C
	jr Label_2D_6A71

; ---- code $6A78-$6AB5 (61 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 2/18 scenarios)

Label_2D_6A78:: ; 2D:6A78
	ld d, a
	ld a, [wSplitScrollY]
	ld e, a
	ld a, d
	sub a, e
	ld [wSpriteSlots + 16], a
	ld [wSpriteSlots + 32], a
	ld a, $08

Label_2D_6A87:: ; 2D:6A87
	dec c
	jr z, Label_2D_6A8E
	add a, $06
	jr Label_2D_6A87

Label_2D_6A8E:: ; 2D:6A8E
	ld [wSpriteSlots + 17], a
	ld [wSpriteSlots + 33], a
	pop bc
	ret

MailAddr_DrawLine20:: ; 2D:6A96
	ld a, $15
	ld [wTextCellsLeft], a

Label_2D_6A9B:: ; 2D:6A9B
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2D_6B36
	cp a, $0D
	jr z, Label_2D_6B1B
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2D_6AF6

; ---- code $6AB5-$6AF6 (65 bytes) [PROBABLE] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0; fall-through of the jrcc at 2D:6AB3 (executed)
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailAddr_DrawLine20_Glyph
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2D_6B36
	cp a, $01
	jr z, Label_2D_6B36
	jr Label_2D_6A9B

; ---- code $6AF6-$6B1B (37 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios)

Label_2D_6AF6:: ; 2D:6AF6
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailAddr_DrawLine20_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2D_6B36
	cp a, $01
	jr z, Label_2D_6B36
	jr Label_2D_6A9B

; ---- code $6B1B-$6B36 (27 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 1; entered by jrcc from 2D:6AA9 (executed)

Label_2D_6B1B:: ; 2D:6B1B
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine20_Pad

; ---- code $6B36-$6B8E (88 bytes) [CONFIRMED] 48 insn(s); 48 executed (in up to 2/18 scenarios)

Label_2D_6B36:: ; 2D:6B36
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2D_6B42:: ; 2D:6B42
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine20_Pad
	jr Label_2D_6B42

MailAddr_DrawLine20_Glyph:: ; 2D:6B51
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailAddr_DrawLine20_Pad:: ; 2D:6B65
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

MailAddr_DrawLine24:: ; 2D:6B7D
	ld a, $19
	ld [wTextCellsLeft], a

Label_2D_6B82:: ; 2D:6B82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [hli]
	cp a, $00
	jp z, Label_2D_6C1D

; ---- code $6B8E-$6B9C (14 bytes) [CONFIRMED] 75 insn(s) reached by static flow only; seeds: exec x75; min discovery hops 0; fall-through of the jpcc at 2D:6B8B (executed) | 6 insn(s) executed; cut out of the PROBABLE region 6B8E-6C1D by apply_coverage --split [executed in 5 scenarios]
	cp a, $0D
	jr z, Label_2D_6C02
	push af
	farcall Glyph_IsSjisLeadByte
	dec a
	jr nz, Label_2D_6BDD

; ---- code $6B9C-$6BDD (65 bytes) [PROBABLE] 37 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6B8E-6C1D by apply_coverage --split
	pop af
	push bc
	push de
	push hl
	push af
	ld a, [hli]
	ld l, a
	pop af
	ld h, a
	ld bc, $C0A0
	ld de, $C0B8
	farcall Glyph_LoadWide
	pop hl
	pop de
	pop bc
	inc hl
	call MailAddr_DrawLine24_Glyph
	push bc
	push de
	push hl
	ld hl, $C0B8
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ld a, [wTextCellsLeft]
	dec a
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2D_6C1D
	cp a, $01
	jr z, Label_2D_6C1D
	jr Label_2D_6B82

; ---- code $6BDD-$6C02 (37 bytes) [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 6B8E-6C1D by apply_coverage --split [executed in 5 scenarios]

Label_2D_6BDD:: ; 2D:6BDD
	pop af
	push bc
	push de
	push hl
	ld b, a
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	call MailAddr_DrawLine24_Glyph
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	cp a, $00
	jr z, Label_2D_6C1D
	cp a, $01
	jr z, Label_2D_6C1D
	jr Label_2D_6B82

; ---- code $6C02-$6C1D (27 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6B8E-6C1D by apply_coverage --split

Label_2D_6C02:: ; 2D:6C02
	push bc
	push de
	push hl
	ld b, $3C
	ld de, $C0A0
	farcall Glyph_LoadAscii
	pop hl
	pop de
	pop bc
	ld a, [wTextCellsLeft]
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine24_Pad

; ---- code $6C1D-$6C38 (27 bytes) [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)

Label_2D_6C1D:: ; 2D:6C1D
	push bc
	push de
	push hl
	farcall Glyph_LoadDottedLine
	pop hl
	pop de
	pop bc

Label_2D_6C29:: ; 2D:6C29
	ld a, [wTextCellsLeft]
	cp a, $00
	ret z
	dec a
	ld [wTextCellsLeft], a
	call MailAddr_DrawLine24_Pad
	jr Label_2D_6C29

; ---- code $6C38-$6C4C (20 bytes) [CONFIRMED] 12 insn(s) reached by static flow only; seeds: exec x12; min discovery hops 1; entered by call from 2D:6BB5 (PROBABLE code) [executed in 1 scenarios]

MailAddr_DrawLine24_Glyph:: ; 2D:6C38
	push bc
	push de
	push hl
	ld hl, $C0A0
	farcall Canvas_BlitGlyph
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

; ---- code $6C4C-$6CCD (129 bytes) [CONFIRMED] 73 insn(s); 73 executed (in up to 3/18 scenarios); entry proven: target of an executed call/far call

MailAddr_DrawLine24_Pad:: ; 2D:6C4C
Function_2D_6C4C::
	push bc
	push de
	push hl
	ld b, $02
	ld c, $00
	ld hl, $C0A0
	farcall Canvas_BlitGlyphNoRemap
	pop hl
	pop de
	pop bc
	ld a, $06
	add a, e
	ld e, a
	ret

TextTiles_UploadBuffersShort:: ; 2D:6C64
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $3F
	call Function_2D_6C8C
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	call Function_2D_6C8C
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

Function_2D_6C8C:: ; 2D:6C8C
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	ldh [rHDMA4], a
	ld de, $FF44

Label_2D_6C9B:: ; 2D:6C9B
	ld a, [de]
	cp a, $8F
	jr nz, Label_2D_6C9B
	ld b, $91

Label_2D_6CA2:: ; 2D:6CA2
	ld a, [de]
	cp a, b
	jr nz, Label_2D_6CA2
	ld a, c
	and a, $7F
	ldh [rHDMA5], a
	ret

MailAddr_GetCharPtr:: ; 2D:6CAC
	push bc
	call MailAddr_GetRowPtr
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $FF
	cp a, d
	jr z, Label_2D_6CD3
	inc c
	ld a, [hl]

Label_2D_6CBD:: ; 2D:6CBD
	dec c
	jr z, Label_2D_6CD1
	inc hl
	ld a, [hl]
	cp a, $00
	jr z, Label_2D_6CD3
	ld a, [hl]
	cp a, $0D
	jr z, Label_2D_6CD9
	jr Label_2D_6CBD

; ---- code $6CCD-$6CD1 (4 bytes) [HYPOTHESIS] inc c ; dec c ; jr nz,$6CD3 - unreached tail before the executed pop bc ; ret at 6CD1 (same pattern as 4EAE)
	inc c
	dec c
	jr nz, Label_2D_6CD3

; ---- code $6CD1-$6CD9 (8 bytes) [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)

Label_2D_6CD1:: ; 2D:6CD1
	pop bc
	ret

Label_2D_6CD3:: ; 2D:6CD3
	ld a, $FF
	ld d, $FF
	pop bc
	ret

; ---- code $6CD9-$6CDF (6 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 1; entered by jrcc from 2D:6CC9 (executed)

Label_2D_6CD9:: ; 2D:6CD9
	ld a, $0D
	ld d, $FF
	pop bc
	ret

; ---- code $6CDF-$6D00 (33 bytes) [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailAddr_GetRowPtr:: ; 2D:6CDF
Function_2D_6CDF::
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	inc b

Label_2D_6CEA:: ; 2D:6CEA
	ld d, $00
	ld e, $18
	dec b
	jr z, Label_2D_6D02

Label_2D_6CF1:: ; 2D:6CF1
	ld d, $FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2D_6D02
	inc hl
	cp a, $0D
	jr z, Label_2D_6CEA
	dec e
	jr nz, Label_2D_6CF1

; ---- code $6D00-$6D02 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2D:6CFE (executed) [executed in 4 scenarios]
	jr Label_2D_6CEA

; ---- code $6D02-$6D2F (45 bytes) [CONFIRMED] 27 insn(s); 27 executed (in up to 2/18 scenarios)

Label_2D_6D02:: ; 2D:6D02
	ld a, $FF
	cp a, d
	jr z, Label_2D_6D1B
	ld e, $00
	push hl

Label_2D_6D0A:: ; 2D:6D0A
	ld a, [hli]
	inc hl
	cp a, $00
	jr z, Label_2D_6D1A
	cp a, $0D
	jr z, Label_2D_6D1A
	inc e
	ld a, $17
	cp a, e
	jr nz, Label_2D_6D0A

Label_2D_6D1A:: ; 2D:6D1A
	pop hl

Label_2D_6D1B:: ; 2D:6D1B
	xor a, a
	ld [rRAMG], a
	pop bc
	ret

MailAddr_InsertChar:: ; 2D:6D21
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4FF
	ld a, [hl]
	cp a, $00
	jr z, Label_2D_6D44

; ---- code $6D2F-$6D44 (21 bytes) [PROBABLE] 13 insn(s) reached by static flow only; seeds: exec x13; min discovery hops 0; fall-through of the jrcc at 2D:6D2D (executed)
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0031
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ret

; ---- code $6D44-$6DF5 (177 bytes) [CONFIRMED] 89 insn(s); 89 executed (in up to 2/18 scenarios)

Label_2D_6D44:: ; 2D:6D44
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0038
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B70
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call MailAddr_PlaceCursorSprites
	ld d, $14
	xor a, a
	ldh [hJoyPressed], a

Label_2D_6D74:: ; 2D:6D74
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $01
	cp a, $00
	jr nz, Label_2D_6D98
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2D_6D98
	dec d
	jr nz, Label_2D_6D74

Label_2D_6D98:: ; 2D:6D98
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	call MailAddr_PlaceCursorSprites
	farcall Function_00_0956
	pop bc
	pop de
	push de
	call MailAddr_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	ld de, $D4FF
	ld bc, $D4FE

Label_2D_6DCF:: ; 2D:6DCF
	ld a, d
	cp a, h
	jr nz, Label_2D_6DD7
	ld a, e
	cp a, l
	jr z, Label_2D_6DDD

Label_2D_6DD7:: ; 2D:6DD7
	ld a, [bc]
	ld [de], a
	dec bc
	dec de
	jr Label_2D_6DCF

Label_2D_6DDD:: ; 2D:6DDD
	pop hl
	pop de
	pop bc
	ld a, e
	ld [hl], a
	call MailAddr_RedrawAfterInsert
	ld a, c
	cp a, $40
	jr z, Label_2D_6E02
	call MailAddr_GetCharPtr
	cp a, $FF
	jr z, Label_2D_6E02
	cp a, $0D
	jr nz, Label_2D_6DFE

; ---- code $6DF5-$6DFE (9 bytes) [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jrcc at 2D:6DF3 (executed)
	ld c, $00
	inc b
	ld a, c
	ld [wTextEditGoalColumn], a
	jr Label_2D_6E02

; ---- code $6DFE-$6E38 (58 bytes) [CONFIRMED] 33 insn(s); 33 executed (in up to 2/18 scenarios)

Label_2D_6DFE:: ; 2D:6DFE
	inc c
	ld [wTextEditGoalColumn], a

Label_2D_6E02:: ; 2D:6E02
	ret

MailAddr_Backspace:: ; 2D:6E03
	push de
	push bc
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0039
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	push bc
	ld hl, $DA10
	ld de, $7B80
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	push bc
	dec b
	ld c, $0B
	call MailAddr_GetCharPtr
	pop bc
	push bc
	inc c
	dec c
	jr nz, Label_2D_6E40

; ---- code $6E38-$6E40 (8 bytes) [PROBABLE] 6 insn(s) reached by static flow only; seeds: exec x6; min discovery hops 0; fall-through of the jrcc at 2D:6E36 (executed)
	ld a, b
	cp a, $00
	jr z, Label_2D_6E41
	dec b
	ld c, e
	inc c

; ---- code $6E40-$6E89 (73 bytes) [CONFIRMED] 31 insn(s); 31 executed (in up to 1/18 scenarios)

Label_2D_6E40:: ; 2D:6E40
	dec c

Label_2D_6E41:: ; 2D:6E41
	call MailAddr_PlaceCursorSprites
	pop bc
	ld d, $14

Label_2D_6E47:: ; 2D:6E47
	push bc
	push de
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop de
	pop bc
	ldh a, [hJoyPressedRepeat]
	and a, $02
	cp a, $00
	jr nz, Label_2D_6E6B
	ldh a, [hJoyHeld]
	and a, $F0
	jr nz, Label_2D_6E6B
	dec d
	jr nz, Label_2D_6E47

Label_2D_6E6B:: ; 2D:6E6B
	farcall Joypad_ClearAndResetRepeat
	ld hl, $DA10
	ld de, $7B60
	ld a, $7F
	ld b, $81
	farcall Function_00_0A82
	pop bc
	call MailAddr_PlaceCursorSprites
	inc c
	dec c
	jr nz, Label_2D_6E94

; ---- code $6E89-$6E94 (11 bytes) [PROBABLE] 7 insn(s) reached by static flow only; seeds: exec x7; min discovery hops 0; fall-through of the jrcc at 2D:6E87 (executed)
	inc b
	dec b
	jr z, Label_2D_6E99
	dec b
	call MailAddr_GetCharPtr
	ld c, e
	jr Label_2D_6E99

; ---- code $6E94-$6EB0 (28 bytes) [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios)

Label_2D_6E94:: ; 2D:6E94
	dec c
	ld a, c
	ld [wTextEditGoalColumn], a

Label_2D_6E99:: ; 2D:6E99
	call MailAddr_GetCharPtr
	pop de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	push bc
	push de
	push hl
	pop bc
	push hl
	inc bc
	ld e, $00
	ld a, [hl]
	cp a, $0D
	jr nz, Label_2D_6EB2

; ---- code $6EB0-$6EB2 (2 bytes) [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0; fall-through of the jrcc at 2D:6EAE (executed)
	ld e, $01

; ---- code $6EB2-$6F31 (127 bytes) [CONFIRMED] 70 insn(s); 70 executed (in up to 2/18 scenarios)

Label_2D_6EB2:: ; 2D:6EB2
	ld a, $FF
	cp a, l
	jr nz, Label_2D_6EBC
	ld a, $D4
	cp a, h
	jr z, Label_2D_6EC1

Label_2D_6EBC:: ; 2D:6EBC
	ld a, [bc]
	ld [hli], a
	inc bc
	jr Label_2D_6EB2

Label_2D_6EC1:: ; 2D:6EC1
	xor a, a
	ld [hli], a
	ld a, e
	pop hl
	pop de
	pop bc
	ld e, a
	push de
	call MailAddr_RedrawAfterBackspace
	pop de
	ret

MailAddr_OpenKeyboard:: ; 2D:6ECE
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld a, $09
	farcall Kbd_Open
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	pop bc

MailAddr_KeyboardLoop:: ; 2D:6F01
	push bc
	call MailAddr_PlaceCursorSprites
	ld d, $70
	farcall Function_00_0956
	ld b, $01
	ld c, $00
	farcall Kbd_Run
	pop bc
	cp a, $00
	jr z, MailAddr_KeyboardLoop
	cp a, $09
	ret z
	cp a, $02
	jr z, Label_2D_6F57
	cp a, $07
	ret z
	cp a, $08
	jr z, Label_2D_6F62
	ld a, [wKeyboardCharLo]
	cp a, $4A
	jr nz, Label_2D_6F3A

; ---- code $6F31-$6F3A (9 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2D:6F2F (executed)
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2D_6F3A
	jr MailAddr_KeyboardLoop

; ---- code $6F3A-$6F41 (7 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 2/18 scenarios)

Label_2D_6F3A:: ; 2D:6F3A
	ld a, [wKeyboardCharLo]
	cp a, $4B
	jr nz, Label_2D_6F4A

; ---- code $6F41-$6F48 (7 bytes) [CONFIRMED] 4 insn(s) reached by static flow only; seeds: exec x4; min discovery hops 0; fall-through of the jrcc at 2D:6F3F (executed) | 3 insn(s) executed; cut out of the PROBABLE region 6F41-6F4A by apply_coverage --split [executed in 2 scenarios]
	ld a, [wKeyboardCharHi]
	cp a, $81
	jr nz, Label_2D_6F4A

; ---- code $6F48-$6F4A (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F41-6F4A by apply_coverage --split
	jr MailAddr_KeyboardLoop

; ---- code $6F4A-$6F5B (17 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios)

Label_2D_6F4A:: ; 2D:6F4A
	ld a, [wKeyboardCharLo]
	ld e, a
	ld a, [wKeyboardCharHi]
	ld d, a
	call MailAddr_InsertChar
	jr MailAddr_KeyboardLoop

Label_2D_6F57:: ; 2D:6F57
	ld a, c
	or a, b
	jr nz, Label_2D_6F74

; ---- code $6F5B-$6F74 (25 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 0; fall-through of the jrcc at 2D:6F59 (executed) [executed in 4 scenarios]
	call MailAddr_GetLength
	cp a, $00
	jr nz, Label_2D_6F74

Label_2D_6F62:: ; 2D:6F62
	push bc
	farcall Kbd_Hide
	xor a, a
	ld [wTextEditGoalColumn], a
	ldh [rSCY], a
	ld [wSplitScrollY], a
	pop bc
	ret

; ---- code $6F74-$6F7A (6 bytes) [CONFIRMED] 2 insn(s); 2 executed (in up to 1/18 scenarios)

Label_2D_6F74:: ; 2D:6F74
	call MailAddr_Backspace
	jp MailAddr_KeyboardLoop

; ---- code $6F7A-$6F7B (1 bytes) [HYPOTHESIS] single ret after a jp; no reference found
	ret

; ---- code $6F7B-$6F93 (24 bytes) [CONFIRMED] 10 insn(s); 10 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailAddr_RedrawAfterInsert:: ; 2D:6F7B
Function_2D_6F7B::
	push bc
	inc c
	call MailAddr_GetLength
	cp a, $14
	jr nc, Label_2D_6F93
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	jp Label_2D_7025

; ---- code $6F93-$7001 (110 bytes) [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1; entered by jrcc from 2D:6F82 (executed) | 43 insn(s) executed; cut out of the PROBABLE region 6F93-7025 by apply_coverage --split [executed in 1 scenarios]

Label_2D_6F93:: ; 2D:6F93
	ld a, c
	cp a, $2D
	jr c, Label_2D_6FA7
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20
	jp Label_2D_7025

Label_2D_6FA7:: ; 2D:6FA7
	ld a, c
	cp a, $15
	jr c, Label_2D_6FC1
	call MailAddr_GetLength
	cp a, $2C
	jr nc, Label_2D_6FC1
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	jr Label_2D_7025

Label_2D_6FC1:: ; 2D:6FC1
	ld a, c
	cp a, $15
	jr c, Label_2D_6FE0
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20
	jr Label_2D_7025

Label_2D_6FE0:: ; 2D:6FE0
	call MailAddr_GetLength
	cp a, $2C
	jr nc, Label_2D_7001
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	jr Label_2D_7025

; ---- code $7001-$7025 (36 bytes) [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F93-7025 by apply_coverage --split

Label_2D_7001:: ; 2D:7001
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20

; ---- code $7025-$705D (56 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 2/18 scenarios)

Label_2D_7025:: ; 2D:7025
	call TextTiles_UploadBuffersShort
	pop bc
	ret

MailAddr_GetLength:: ; 2D:702A
	push hl
	push de
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld d, $00

Label_2D_7037:: ; 2D:7037
	ld a, [hli]
	cp a, $00
	jr z, Label_2D_7042
	inc d
	ld a, $40
	cp a, d
	jr nz, Label_2D_7037

Label_2D_7042:: ; 2D:7042
	ld a, d
	pop de
	pop hl
	ret

MailAddr_RedrawAfterBackspace:: ; 2D:7046
	push bc
	call MailAddr_GetLength
	cp a, $14
	jr nc, Label_2D_705D
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	jp Label_2D_70EF

; ---- code $705D-$7062 (5 bytes) [CONFIRMED] 55 insn(s) reached by static flow only; seeds: exec x55; min discovery hops 1; entered by jrcc from 2D:704C (executed) | 3 insn(s) executed; cut out of the PROBABLE region 705D-70EF by apply_coverage --split [executed in 4 scenarios]

Label_2D_705D:: ; 2D:705D
	ld a, c
	cp a, $2D
	jr c, Label_2D_7071

; ---- code $7062-$7071 (15 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 705D-70EF by apply_coverage --split
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20
	jp Label_2D_70EF

; ---- code $7071-$7090 (31 bytes) [CONFIRMED] 14 insn(s) executed; cut out of the PROBABLE region 705D-70EF by apply_coverage --split [executed in 2 scenarios]

Label_2D_7071:: ; 2D:7071
	ld a, c
	cp a, $15
	jr c, Label_2D_708B
	call MailAddr_GetLength
	cp a, $2C
	jr nc, Label_2D_708B
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	jr Label_2D_70EF

Label_2D_708B:: ; 2D:708B
	ld a, c
	cp a, $15
	jr c, Label_2D_70AA

; ---- code $7090-$70AA (26 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 705D-70EF by apply_coverage --split
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20
	jr Label_2D_70EF

; ---- code $70AA-$70CB (33 bytes) [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 705D-70EF by apply_coverage --split [executed in 2 scenarios]

Label_2D_70AA:: ; 2D:70AA
	call MailAddr_GetLength
	cp a, $2C
	jr nc, Label_2D_70CB
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	jr Label_2D_70EF

; ---- code $70CB-$70EF (36 bytes) [PROBABLE] 12 insn(s) never executed in the traced runs; cut out of the PROBABLE region 705D-70EF by apply_coverage --split

Label_2D_70CB:: ; 2D:70CB
	ld bc, $0300
	ld de, $0420
	ld hl, $D4C0
	call MailAddr_DrawLine20
	ld bc, $0300
	ld de, $1008
	ld hl, $D4D4
	call MailAddr_DrawLine24
	ld bc, $0300
	ld de, $1C08
	ld hl, $D4EC
	call MailAddr_DrawLine20

; ---- code $70EF-$711F (48 bytes) [CONFIRMED] 30 insn(s); 30 executed (in up to 4/18 scenarios)

Label_2D_70EF:: ; 2D:70EF
	call TextTiles_UploadBuffersShort
	pop bc
	ret

Joypad_ClearAndResetRepeat:: ; 2D:70F4
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [hJoyHeld], a
	ldh [hJoyPressed], a
	ldh [hRam_FFA7], a
	ldh [hJoyPressedRepeat], a
	ld [wJoyIdleFrames], a
	ld b, $14
	ld c, $02
	ld a, c
	ld [wJoyRepeatInterval], a
	ld a, b
	ld [wJoyRepeatDelay], a
	ld hl, $C2E5
	ld b, $04

Label_2D_7115:: ; 2D:7115
	ld [hli], a
	dec b
	jr nz, Label_2D_7115
	pop hl
	pop de
	pop bc
	pop af
	dec a
	ret

; ---- zero $711F-$7120 (1 bytes) [PROBABLE] 1 byte $00 padding between the last code and the data at 7120
	ds $1, $00
