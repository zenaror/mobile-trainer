; engine/mail_server/delete_progress.asm
; bank 23, $55C3-$58C4 (769 bytes); pinned by layout.link
; transaction progress screen: init, progress text, number formatting

SECTION "engine/mail_server/delete_progress", ROMX

; ---- code $55C3-$571B (344 bytes) [CONFIRMED] 150 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 5 scenarios]

MailSrvDel_ProgressInit:: ; 23:55C3
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	farcall TextTiles_UploadBuffers
	farcall LCDOff
	xor a, a
	ldh [rSCX], a
	ld a, $F0
	ldh [rWY], a
	ld bc, $0040
	ld de, $D800
	ld hl, Palette_MailSrvDelProgress_Bg
	ld a, $23
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, Palette_MailSrvDelProgress_Obj
	ld a, $23
	farcall Palette_LoadToBuffer
	ld de, $9001
	ld hl, Gfx_MailSrvDelProgress_Tiles0
	ld a, $23
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, Gfx_MailSrvDelProgress_Tiles1
	ld a, $23
	ld b, $97
	ld c, $10
	farcall Function_00_0787
	ld de, $8000
	ld hl, Gfx_MailSrvDelProgress_Tiles2
	ld a, $23
	ld b, $96
	ld c, $16
	farcall Function_00_0787
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelProgress_Screen
	ld a, $23
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	farcall LCDOn
	call MailSrvDel_DrawElapsedTime
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
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $000C
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	ret

MailSrvDel_DrawProgressText:: ; 23:56A1
	push af
	push bc
	push de
	push hl
	push de
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D631
	ld a, [de]
	xor a, $FF
	ld c, a
	inc de
	ld a, [de]
	xor a, $FF
	ld b, a
	inc bc
	add hl, bc
	pop bc
	pop de
	push hl
	call MailSrvDel_NumberTileOffset
	pop hl
	push hl
	push bc
	call MailSrvDel_FormatNumber
	ld e, a
	ld d, $00
	swap e
	pop hl
	add hl, de
	ld b, h
	ld c, l
	pop hl
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, String_MailSrvDel_ProgressText
	farcall TextTiles_RenderLine
	di
	call MailSrvDel_UploadNumberTiles
	ei
	pop hl
	pop de
	pop bc
	pop af
	ret

MailSrvDel_FormatNumber:: ; 23:56F0
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_MailSrvDel_NumberTemplate
	ld de, $D524

Label_23_56FE:: ; 23:56FE
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_23_56FE
	pop bc
	pop hl
	push bc
	ld bc, $D525
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_23_5761

; ---- code $571B-$5761 (70 bytes) [PROBABLE] 46 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $05
	jp Label_23_5805

; ---- code $5761-$5773 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 5 scenarios]

Label_23_5761:: ; 23:5761
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_23_57A7

; ---- code $5773-$57A7 (52 bytes) [PROBABLE] 35 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $04
	jp Label_23_5805

; ---- code $57A7-$57B9 (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 5 scenarios]

Label_23_57A7:: ; 23:57A7
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_23_57DB

; ---- code $57B9-$57DB (34 bytes) [PROBABLE] 24 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $03
	jp Label_23_5805

; ---- code $57DB-$57ED (18 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 5 scenarios]

Label_23_57DB:: ; 23:57DB
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_23_57FD

; ---- code $57ED-$57FD (16 bytes) [PROBABLE] 13 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5424-581E by apply_coverage --split
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $02
	jp Label_23_5805

; ---- code $57FD-$581E (33 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 5424-581E by apply_coverage --split [executed in 5 scenarios]

Label_23_57FD:: ; 23:57FD
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01

Label_23_5805:: ; 23:5805
	pop bc
	push af
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop af
	ret

; ---- text $581E-$5829 (11 bytes) [PROBABLE] 5 x fullwidth zero (82 4F) + NUL, addressed by ld hl,$581E at 23:56F8; twin of 497B

String_MailSrvDel_NumberTemplate:: ; 23:581E
String_23_581E::
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00 ; "０００００"

; ---- code $5829-$5839 (16 bytes) [CONFIRMED] 56 insn(s) reached by static flow only; seeds: exec x56; min discovery hops 15; entered by call from 23:56BE (PROBABLE code) | 7 insn(s) executed; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split [executed in 5 scenarios]

MailSrvDel_NumberTileOffset:: ; 23:5829
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_23_583F

; ---- code $5839-$583F (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split
	ld bc, $D010
	jp Label_23_5886

; ---- code $583F-$584F (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split [executed in 5 scenarios]

Label_23_583F:: ; 23:583F
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_23_5855

; ---- code $584F-$5855 (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split
	ld bc, $D010
	jp Label_23_5886

; ---- code $5855-$5865 (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split [executed in 5 scenarios]

Label_23_5855:: ; 23:5855
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_23_586B

; ---- code $5865-$586B (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split
	ld bc, $D020
	jp Label_23_5886

; ---- code $586B-$587B (16 bytes) [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split [executed in 5 scenarios]

Label_23_586B:: ; 23:586B
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_23_5881

; ---- code $587B-$5881 (6 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split
	ld bc, $D030
	jp Label_23_5886

; ---- code $5881-$58A9 (40 bytes) [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 5829-58A9 by apply_coverage --split [executed in 5 scenarios]

Label_23_5881:: ; 23:5881
	ld bc, $D030
	ld a, $01

Label_23_5886:: ; 23:5886
	pop hl
	pop de
	ret

MailSrvDel_UploadNumberTiles:: ; 23:5889
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D000
	ld de, $9000
	ld c, $27
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

; ---- text $58A9-$58C4 (27 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDel_ProgressText:: ; 23:58A9
String_23_58A9::
	db $82, $C2, $82, $A4, $82, $DF, $82, $F0, $83, $60, $83, $46, $83, $62, $83, $4E, $82, $B5, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $00 ; "つうめをチェックしています"
