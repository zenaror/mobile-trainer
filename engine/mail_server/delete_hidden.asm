; engine/mail_server/delete_hidden.asm
; bank 22, $4000-$4EF0 (3824 bytes); pinned by layout.link
; hidden variant of the mail-server delete menu (3 buttons) with its description strings and delete flows

SECTION "engine/mail_server/delete_hidden", ROMX

; ---- code $4000-$4064 (100 bytes) [CONFIRMED] 408 insn(s) reached by static flow only; seeds: exec x408; min discovery hops 1; entered by far from 7C:7D0C (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 3 scenarios]

MailSrvDelHidden_MenuRun:: ; 22:4000
	call Function_00_044B
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
	ld c, $01
	call MailSrvDelHidden_MenuInit
	ld de, $0227
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
	ld c, $01
	dec a
	jr z, MailSrvDelHidden_MenuLoop

; ---- code $4064-$4076 (18 bytes) [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $4076-$40B1 (59 bytes) [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 1 scenarios]

MailSrvDelHidden_MenuLoop:: ; 22:4076
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_22_40F4
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	jr z, Label_22_40AE
	dec c
	jr z, Label_22_40ED
	call MailSrvDelHidden_DeleteAll
	ld c, $00
	jr Label_22_40B3

Label_22_40AE:: ; 22:40AE
	call MailSrvDelHidden_CheckAndDelete

; ---- code $40B1-$40B3 (2 bytes) [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split
	ld c, $01

; ---- code $40B3-$40FA (71 bytes) [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 1 scenarios]

Label_22_40B3:: ; 22:40B3
	push bc
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
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	pop bc
	call MailSrvDelHidden_MenuInit
	pop bc
	jp MailSrvDelHidden_MenuLoop

Label_22_40ED:: ; 22:40ED
	call MailSrvDelHidden_DeleteCompletely
	ld c, $02
	jr Label_22_40B3

Label_22_40F4:: ; 22:40F4
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_22_4120

; ---- code $40FA-$4120 (38 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split
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
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $4120-$414E (46 bytes) [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 1 scenarios]

Label_22_4120:: ; 22:4120
	ldh a, [hJoyPressedRepeat]
	and a, $80
	jr z, Label_22_4148
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld a, c
	dec a
	ld c, a
	cp a, $FF
	jr nz, Label_22_4145
	ld c, $02

Label_22_4145:: ; 22:4145
	call MailSrvDelHidden_MenuSelect

Label_22_4148:: ; 22:4148
	ldh a, [hJoyPressedRepeat]
	and a, $40
	jr z, Label_22_4170

; ---- code $414E-$4170 (34 bytes) [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld a, c
	inc a
	ld c, a
	cp a, $03
	jr nz, Label_22_416D
	ld c, $00

Label_22_416D:: ; 22:416D
	call MailSrvDelHidden_MenuSelect

; ---- code $4170-$4178 (8 bytes) [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 3 scenarios]

Label_22_4170:: ; 22:4170
	jp MailSrvDelHidden_MenuLoop

MailSrvDelHidden_MenuSelect:: ; 22:4173
	ld a, c
	cp a, $01
	jr nz, Label_22_41B3

; ---- code $4178-$41B3 (59 bytes) [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split
	push bc
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button1
	ld a, $22
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_085B
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $F400
	ld hl, $DA10
	call Function_00_0A65
	farcall Function_00_0956
	call MailSrvDelHidden_ShowDescCheck
	pop bc
	ret

; ---- code $41B3-$43E0 (557 bytes) [CONFIRMED] 200 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage --split [executed in 1 scenarios]

Label_22_41B3:: ; 22:41B3
	cp a, $00
	jr nz, Label_22_41F2
	push bc
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button0
	ld a, $22
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_085B
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0800
	ld hl, $DA10
	call Function_00_0A65
	farcall Function_00_0956
	call MailSrvDelHidden_ShowDescDeleteAll
	pop bc
	ret

Label_22_41F2:: ; 22:41F2
	push bc
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button2
	ld a, $22
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_085B
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $1C00
	ld hl, $DA10
	call Function_00_0A65
	farcall Function_00_0956
	call MailSrvDelHidden_ShowDescDeleteCompletely
	pop bc
	ret

MailSrvDelHidden_MenuInit:: ; 22:422D
	push bc
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	call Function_00_0464
	ld bc, $0040
	ld de, $D800
	ld hl, MailServerDeleteMethod_BgPalette
	ld a, $28
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, $6E40
	ld a, $28
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld de, $9301
	ld hl, MailServerDeleteMethod_Tiles_5F20
	ld a, $28
	ld b, $95
	ld c, $23
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8800
	ld hl, MailServerDeleteMethod_Tiles_6150
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8C00
	ld hl, MailServerDeleteMethod_Tiles_6550
	ld a, $28
	ld b, $94
	ld c, $29
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8000
	ld hl, MailServerDeleteMethod_Tiles_67E0
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Function_00_0787
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button1
	ld a, $22
	farcall Function_00_08EA
	call Function_00_0464
	ldh a, [rLCDC]
	call Function_00_082C
	call Function_00_0464
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0F00

Label_22_42E7:: ; 22:42E7
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_42E7
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr z, Label_22_4317
	cp a, $02
	jr z, Label_22_434B
	call MailSrvDelHidden_ShowDescCheck
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $F400
	ld hl, $DA10
	call Function_00_0A65
	jr MailSrvDelHidden_MenuStart

Label_22_4317:: ; 22:4317
	call MailSrvDelHidden_ShowDescDeleteAll
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button0
	ld a, $22
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $0800
	ld hl, $DA10
	call Function_00_0A65
	jr MailSrvDelHidden_MenuStart

Label_22_434B:: ; 22:434B
	call MailSrvDelHidden_ShowDescDeleteCompletely
	ld bc, $1214
	ld de, $D000
	ld hl, Tilemap_MailSrvDelHidden_Button2
	ld a, $22
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA10
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $1C00
	ld hl, $DA10
	call Function_00_0A65

MailSrvDelHidden_MenuStart:: ; 22:437D
	call Function_00_0464
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	pop bc
	ret

MailSrvDelHidden_ShowDescDeleteAll:: ; 22:43C5
	ld hl, String_MailSrvDelHidden_DescDeleteAll
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D000
	ld de, $D360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $43E0-$444D (109 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDelHidden_DescDeleteAll:: ; 22:43E0
String_22_43E0::
	db $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $82, $C9, $82, $CC, $82, $B1, $82, $C1, $82, $C4, $82, $A2, $82, $E9, $82, $B7, $82, $D7, $82, $C4, $82, $CC ; "メールサーバにのこっているすべての"
	db $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $81, $41, $82, $B6, $82, $C7, $82, $A4, $82, $C5, $82, $BA, $82, $F1, $82, $D4, $82, $AF, $82, $B5, $82, $DC, $82, $B7 ; "　メールを、じどうでぜんぶけします"
	db $81, $40, $81, $40, $82, $B6, $82, $E5, $82, $A4, $82, $D9, $82, $A4, $82, $CD, $82, $BD, $82, $B5, $82, $A9, $82, $DF, $82, $E7, $82, $EA, $82, $DC, $82, $B9, $82, $F1 ; "　　じょうほうはたしかめられません"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $444D-$4468 (27 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 3; entered by call from 22:41AE (PROBABLE code) [executed in 1 scenarios]

MailSrvDelHidden_ShowDescCheck:: ; 22:444D
	ld hl, String_MailSrvDelHidden_DescCheck
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D000
	ld de, $D360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $4468-$448D (37 bytes) [HYPOTHESIS] Shift-JIS text: 18 x 81 40 (full-width space) + NUL; no reference found (no ld/dw of $4468 in the ROM); sits between a ret and the referenced string String_22_448D (ld hl,$448D at 22:444D) - probably a blank-line string

String_22_4468:: ; 22:4468
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "　　　　　　　　　　　　　　　　　"
	db $81, $40, $00 ; "　"

; ---- text $448D-$44FA (109 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDelHidden_DescCheck:: ; 22:448D
String_22_448D::
	db $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F, $82, $C9, $82, $CC, $82, $B1, $82, $C1, $82, $C4, $82, $A2, $82, $E9, $83, $81, $81, $5B, $83, $8B, $82, $CC ; "メールサーバにのこっているメールの"
	db $81, $40, $82, $B6, $82, $E5, $82, $A4, $82, $D9, $82, $A4, $82, $F0, $82, $BD, $82, $B5, $82, $A9, $82, $DF, $82, $C4, $81, $41, $82, $50, $82, $C2, $82, $A4, $82, $B8 ; "　じょうほうをたしかめて、１つうず"
	db $82, $C2, $81, $40, $82, $B6, $82, $D4, $82, $F1, $82, $C5, $82, $AF, $82, $B7, $82, $B1, $82, $C6, $82, $AA, $82, $C5, $82, $AB, $82, $DC, $82, $B7, $81, $40, $81, $40 ; "つ　じぶんでけすことができます　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $44FA-$4515 (27 bytes) [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 4; entered by call from 22:4228 (PROBABLE code) [executed in 1 scenarios]

MailSrvDelHidden_ShowDescDeleteCompletely:: ; 22:44FA
	ld hl, String_MailSrvDelHidden_DescDeleteCompletely
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D000
	ld de, $D360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $4515-$4582 (109 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDelHidden_DescDeleteCompletely:: ; 22:4515
String_22_4515::
	db $82, $E0, $82, $F1, $82, $BE, $82, $A2, $82, $CC, $82, $A0, $82, $E9, $83, $81, $81, $5B, $83, $8B, $82, $C6, $83, $81, $81, $5B, $83, $8B, $83, $54, $81, $5B, $83, $6F ; "もんだいのあるメールとメールサーバ"
	db $82, $C9, $82, $CC, $82, $B1, $82, $C1, $82, $C4, $82, $A2, $82, $E9, $82, $B7, $82, $D7, $82, $C4, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $B6, $82, $C7 ; "にのこっているすべてのメールをじど"
	db $82, $A4, $82, $C5, $82, $BA, $82, $F1, $82, $D4, $82, $AF, $82, $B5, $82, $DC, $82, $B7, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "うでぜんぶけします　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $4582-$4770 (494 bytes) [CONFIRMED] 242 insn(s) reached by static flow only; seeds: exec x242; min discovery hops 4; entered by call from 22:4B2F (PROBABLE code) | 184 insn(s) executed; cut out of the PROBABLE region 4582-47DD by apply_coverage --split [executed in 3 scenarios]

MailSrvDelHidden_Confirm:: ; 22:4582
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
	farcall Function_00_09B6
	farcall Function_00_0956
	farcall TextTiles_ClearBuffers
	call Function_00_0464
	ld bc, $0040
	ld de, $D800
	ld hl, MailServerDeleteAll_BgPalette
	ld a, $28
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld bc, $0040
	ld de, $D840
	ld hl, $5EE0
	ld a, $28
	farcall Palette_LoadToBuffer
	call Function_00_0464
	ld de, $9301
	ld hl, MailServerDeleteAll_Tiles_54B0
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	call Function_00_0464
	ld de, $9701
	ld hl, MailServerDeleteAll_Tiles_58B0
	ld a, $28
	ld b, $94
	ld c, $2A
	farcall Function_00_0787
	call Function_00_0464
	ld de, $8000
	ld hl, MailServerDeleteAll_Tiles_5B50
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Function_00_0787
	call Function_00_0464
	ld bc, $1214
	ld de, $D000
	ld hl, MailServerDeleteAll_Tilemap
	ld a, $28
	farcall Function_00_08EA
	call Function_00_0464
	ldh a, [rLCDC]
	call Function_00_082C
	call Function_00_0464
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0F00

Label_22_4646:: ; 22:4646
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_22_4646
	ld hl, $DA10
	ld de, Table_28_6E80
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $6858
	ld hl, $DA10
	call Function_00_0A65
	ld hl, String_MailSrvDelHidden_Confirm
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D000
	ld de, $D100
	farcall TextTiles_RenderLine
	call Function_00_0464
	ld hl, $483C
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D200
	ld de, $D300
	farcall TextTiles_RenderLine
	call Function_00_0464
	ld hl, $485D
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D400
	ld de, $D500
	farcall TextTiles_RenderLine
	call Function_00_0464
	ld hl, $487E
	ld a, $02
	ldh [rVBK], a
	ldh [hRam_FFB0], a
	ld a, $22
	ld bc, $D600
	ld de, $D700
	farcall TextTiles_RenderLine
	call Function_00_0464
	call MailSrvDelHidden_UploadTextTiles
	call Function_00_0464
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Function_00_20E8
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	farcall Stat_DisableScrollSplit
	call Function_00_044B
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wRam_D725], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld c, $01

Label_22_4719:: ; 22:4719
	push bc
	farcall Function_00_0956
	call Function_00_0464
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, Label_22_476A
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	jr z, Label_22_4758
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	xor a, a
	ret

Label_22_4758:: ; 22:4758
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

Label_22_476A:: ; 22:476A
	ldh a, [hJoyPressed]
	and a, $02
	jr z, Label_22_4796

; ---- code $4770-$4796 (38 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4582-47DD by apply_coverage --split
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
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

; ---- code $4796-$47BE (40 bytes) [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 4582-47DD by apply_coverage --split [executed in 3 scenarios]

Label_22_4796:: ; 22:4796
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, Label_22_47B8
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDelHidden_ConfirmSelect

Label_22_47B8:: ; 22:47B8
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, Label_22_47DA

; ---- code $47BE-$47DA (28 bytes) [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4582-47DD by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Function_00_20AC
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDelHidden_ConfirmSelect

; ---- code $47DA-$47DD (3 bytes) [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4582-47DD by apply_coverage --split [executed in 3 scenarios]

Label_22_47DA:: ; 22:47DA
	jp Label_22_4719

; ---- code $47DD-$47DE (1 bytes) [HYPOTHESIS] c9 ret directly after the unconditional 'jp $4719' at 22:47DA: unreachable by flow, no reference; kept as code because it is a whole instruction at a function boundary
	ret

; ---- code $47DE-$47FF (33 bytes) [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 7; entered by call from 22:47B5 (PROBABLE code) | 14 insn(s) executed; cut out of the PROBABLE region 47DE-481B by apply_coverage --split [executed in 3 scenarios]

MailSrvDelHidden_ConfirmSelect:: ; 22:47DE
	ld a, c
	cp a, $00
	jr nz, Label_22_47FF
	push bc
	ld hl, $DA10
	ld de, Table_28_6E80
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $6828
	ld hl, $DA10
	call Function_00_0A65
	pop bc
	ret

; ---- code $47FF-$481B (28 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 47DE-481B by apply_coverage --split

Label_22_47FF:: ; 22:47FF
	push bc
	ld hl, $DA10
	ld de, Table_28_6E80
	ld a, $28
	ld b, $81
	farcall Function_00_0A82
	ld de, $6858
	ld hl, $DA10
	call Function_00_0A65
	pop bc
	ret

; ---- text $481B-$489F (132 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDelHidden_Confirm:: ; 22:481B
String_22_481B::
	db $82, $B1, $82, $CC, $82, $B5, $82, $E5, $82, $E8, $82, $F0, $82, $A8, $82, $B1, $82, $C8, $82, $A4, $82, $C6, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "このしょりをおこなうと　　　　　"
	db $83, $54, $81, $5B, $83, $6F, $82, $C9, $82, $A0, $82, $E9, $81, $40, $82, $B7, $82, $D7, $82, $C4, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $AA, $81, $40, $00 ; "サーバにある　すべてのメールが　"
	db $82, $AB, $82, $A6, $82, $C4, $82, $B5, $82, $DC, $82, $A2, $82, $DC, $82, $B7, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "きえてしまいます　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $82, $E6, $82, $EB, $82, $B5, $82, $A2, $82, $C5, $82, $B7, $82, $A9, $81, $48, $81, $40, $81, $40, $81, $40, $81, $40, $00 ; "　　　　よろしいですか？　　　　"

; ---- code $489F-$48CD (46 bytes) [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 4; entered by call from 22:43DC (PROBABLE code) [executed in 1 scenarios]

MailSrvDelHidden_UploadTextTiles:: ; 22:489F
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
	farcall Gfx_StartHDMAAtVBlank
	ld hl, $D400
	ld de, $9400
	ld c, $3F
	farcall Gfx_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

; ---- code $48CD-$48FE (49 bytes) [PROBABLE] function prologue (push af/bc/de/hl ... ld de,$C2D7 ... call $4975 / $4A97 ...) that falls straight into the far-call site at 22:48FE (PROBABLE code); it follows a ret at 48CC. No caller/pointer to 48CD found in the ROM (words.py scan), so the entry is unproven; both direct call targets (4975, 4A97) are known code starts | forced execution: 31/31 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)

Function_22_48CD:: ; 22:48CD
	push af
	push bc
	push de
	push hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $C2D7
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call Function_22_4975
	pop hl
	push hl
	call Function_22_4A97
	ld hl, $D800
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524

; ---- code $48FE-$4A8C (398 bytes) [PROBABLE] 243 insn(s) reached by static flow only; seeds: site x243; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 125/243 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	farcall TextTiles_RenderLine
	pop hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $C2D6
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call Function_22_4975
	pop hl
	push hl
	call Function_22_4A97
	ld hl, $D830
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $C2D5
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call Function_22_4975
	pop hl
	push hl
	call Function_22_4A97
	ld hl, $D860
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	call Function_22_4AF7
	pop hl
	pop de
	pop bc
	pop af
	ret

Function_22_4975:: ; 22:4975
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_22_4A8C
	ld de, $D524

Label_22_4983:: ; 22:4983
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_22_4983
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
	jr z, Label_22_49E6
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
	jp Label_22_4A8A

Label_22_49E6:: ; 22:49E6
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_22_4A2C
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
	jp Label_22_4A8A

Label_22_4A2C:: ; 22:4A2C
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_22_4A60
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
	jp Label_22_4A8A

Label_22_4A60:: ; 22:4A60
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, Label_22_4A82
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
	jp Label_22_4A8A

Label_22_4A82:: ; 22:4A82
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01

Label_22_4A8A:: ; 22:4A8A
	pop bc
	ret

; ---- text $4A8C-$4A97 (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string 5 x 82 4F (full-width digit zero); copied byte-by-byte to $D524 until NUL by the loop at 22:4983 (ld hl,$4A8C at 22:497D)

String_22_4A8C:: ; 22:4A8C
	db $82, $4F, $82, $4F, $82, $4F, $82, $4F, $82, $4F, $00 ; "０００００"

; ---- code $4A97-$4B17 (128 bytes) [PROBABLE] 130 insn(s) reached by static flow only; seeds: exec x74, site x56; min discovery hops 0; entered by call from 22:491A (PROBABLE code) | 56 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4A97-4BB5 by apply_coverage --split | forced execution: 48/56 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)

Function_22_4A97:: ; 22:4A97
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_22_4AAD
	ld bc, $0000
	jp Label_22_4AF4

Label_22_4AAD:: ; 22:4AAD
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_22_4AC3
	ld bc, $0000
	jp Label_22_4AF4

Label_22_4AC3:: ; 22:4AC3
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_22_4AD9
	ld bc, $0000
	jp Label_22_4AF4

Label_22_4AD9:: ; 22:4AD9
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, Label_22_4AEF
	ld bc, $0000
	jp Label_22_4AF4

Label_22_4AEF:: ; 22:4AEF
	ld bc, $0010
	ld a, $01

Label_22_4AF4:: ; 22:4AF4
	pop hl
	pop de
	ret

Function_22_4AF7:: ; 22:4AF7
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, $D800
	ld de, $8800
	ld c, $27
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

; ---- code $4B17-$4B91 (122 bytes) [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 4A97-4BB5 by apply_coverage --split [executed in 2 scenarios]

MailSrvDelHidden_DeleteAll:: ; 22:4B17
	ld a, $01
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite

MailSrvDelHidden_DeleteAll_Confirm:: ; 22:4B2F
	call MailSrvDelHidden_Confirm
	inc a
	jr nz, Label_22_4B37
	dec a
	ret

Label_22_4B37:: ; 22:4B37
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_22_4C5B
	ld b, $07

Label_22_4B45:: ; 22:4B45
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_22_4B45
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDelHidden_DeleteAll_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, Label_22_4B91
	cp a, $20
	jr z, Label_22_4BD1
	cp a, $80
	jr nz, Label_22_4BED

; ---- code $4B91-$4BB5 (36 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4A97-4BB5 by apply_coverage --split

Label_22_4B91:: ; 22:4B91
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_22_4BB7
	cp a, $20
	jp z, Label_22_4BB7
	cp a, $21
	jp z, Label_22_4BB7
	cp a, $23
	jp z, Label_22_4BB7
	cp a, $24
	jp z, Label_22_4BB7
	cp a, $26
	jp z, Label_22_4BB7
	jp Label_22_4BD1

; ---- code $4BB5-$4BB7 (2 bytes) [HYPOTHESIS] jr $4C2B (18 74) after the unconditional 'jp $4BD1' at 22:4BB2: unreachable by flow and never referenced; target 4C2B is a code instruction start
	jr Label_22_4C2B

; ---- code $4BB7-$4BED (54 bytes) [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 5; entered by jpcc from 22:4B96 (PROBABLE code) | 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split

Label_22_4BB7:: ; 22:4BB7
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4BC9
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_22_4BD1

Label_22_4BC9:: ; 22:4BC9
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

Label_22_4BD1:: ; 22:4BD1
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_22_4BDE
	ld a, h
	or a, l
	jr z, Label_22_4BEC

Label_22_4BDE:: ; 22:4BDE
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4BEC:: ; 22:4BEC
	ret

; ---- code $4BED-$4C14 (39 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split [executed in 2 scenarios]

Label_22_4BED:: ; 22:4BED
	farcall MailSrvDel_DeleteAllRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4C14
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr Label_22_4C2B

; ---- code $4C14-$4C2B (23 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split

Label_22_4C14:: ; 22:4C14
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

; ---- code $4C2B-$4C35 (10 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split [executed in 2 scenarios]

Label_22_4C2B:: ; 22:4C2B
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, Label_22_4C39

; ---- code $4C35-$4C39 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split
	ld a, h
	or a, l
	jr z, Label_22_4C47

; ---- code $4C39-$4C5B (34 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split [executed in 1 scenarios]

Label_22_4C39:: ; 22:4C39
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4C47:: ; 22:4C47
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4C5B-$4C62 (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied by the loop 'ld hl,$D624 ; ld de,$4C5B ; ld b,$07' at 22:4B3D-4B4A

Data_22_4C5B:: ; 22:4C5B
	db $03, $00, $00, $01, $24, $D5, $00

; ---- code $4C62-$4CDC (122 bytes) [CONFIRMED] 74 insn(s) reached by static flow only; seeds: exec x74; min discovery hops 4; entered by call from 22:40ED (PROBABLE code) | 60 insn(s) executed; cut out of the PROBABLE region 4C62-4D00 by apply_coverage --split [executed in 1 scenarios]

MailSrvDelHidden_DeleteCompletely:: ; 22:4C62
	ld a, $01
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite

MailSrvDelHidden_DeleteCompletely_Confirm:: ; 22:4C7A
	call MailSrvDelHidden_Confirm
	inc a
	jr nz, Label_22_4C82
	dec a
	ret

Label_22_4C82:: ; 22:4C82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_22_4DA6
	ld b, $07

Label_22_4C90:: ; 22:4C90
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_22_4C90
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDelHidden_DeleteCompletely_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, Label_22_4CDC
	cp a, $20
	jr z, Label_22_4D1C
	cp a, $80
	jr nz, Label_22_4D38

; ---- code $4CDC-$4D00 (36 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4C62-4D00 by apply_coverage --split

Label_22_4CDC:: ; 22:4CDC
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_22_4D02
	cp a, $20
	jp z, Label_22_4D02
	cp a, $21
	jp z, Label_22_4D02
	cp a, $23
	jp z, Label_22_4D02
	cp a, $24
	jp z, Label_22_4D02
	cp a, $26
	jp z, Label_22_4D02
	jp Label_22_4D1C

; ---- code $4D00-$4D02 (2 bytes) [HYPOTHESIS] jr $4D76 (18 74) after the unconditional 'jp $4D1C' at 22:4CFD: unreachable, same pattern as 4BB5; target is a code instruction start
	jr Label_22_4D76

; ---- code $4D02-$4D38 (54 bytes) [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 6; entered by jpcc from 22:4CE1 (PROBABLE code) | 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split

Label_22_4D02:: ; 22:4D02
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4D14
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_22_4D1C

Label_22_4D14:: ; 22:4D14
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

Label_22_4D1C:: ; 22:4D1C
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_22_4D29
	ld a, h
	or a, l
	jr z, Label_22_4D37

Label_22_4D29:: ; 22:4D29
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4D37:: ; 22:4D37
	ret

; ---- code $4D38-$4D5F (39 bytes) [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split [executed in 1 scenarios]

Label_22_4D38:: ; 22:4D38
	farcall MailSrvDel_DeleteCompletelyRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4D5F
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr Label_22_4D76

; ---- code $4D5F-$4D76 (23 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split

Label_22_4D5F:: ; 22:4D5F
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

; ---- code $4D76-$4D80 (10 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split [executed in 1 scenarios]

Label_22_4D76:: ; 22:4D76
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, Label_22_4D84

; ---- code $4D80-$4D84 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split
	ld a, h
	or a, l
	jr z, Label_22_4D92

; ---- code $4D84-$4DA6 (34 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split [executed in 1 scenarios]

Label_22_4D84:: ; 22:4D84
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4D92:: ; 22:4D92
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4DA6-$4DAD (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied to $D624 by the 'ld de,$4DA6 ; ld b,$07' loop at 22:4C8B

Data_22_4DA6:: ; 22:4DA6
	db $03, $00, $00, $01, $24, $D5, $00

; ---- code $4DAD-$4E1D (112 bytes) [CONFIRMED] 69 insn(s) reached by static flow only; seeds: exec x69; min discovery hops 4; entered by call from 22:40AE (PROBABLE code) | 55 insn(s) executed; cut out of the PROBABLE region 4DAD-4E41 by apply_coverage --split [executed in 1 scenarios]

MailSrvDelHidden_CheckAndDelete:: ; 22:4DAD
	xor a, a
	ld [wRam_C1D0], a
	xor a, a
	ld [wRam_C1D1], a
	farcall Stat_DisableScrollSplit
	call Function_00_0464
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_22_4EE9
	ld b, $07

Label_22_4DD2:: ; 22:4DD2
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, Label_22_4DD2
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	ret z
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, Label_22_4E1D
	cp a, $20
	jr z, Label_22_4E5D
	cp a, $80
	jr nz, Label_22_4E79

; ---- code $4E1D-$4E41 (36 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4DAD-4E41 by apply_coverage --split

Label_22_4E1D:: ; 22:4E1D
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, Label_22_4E43
	cp a, $20
	jp z, Label_22_4E43
	cp a, $21
	jp z, Label_22_4E43
	cp a, $23
	jp z, Label_22_4E43
	cp a, $24
	jp z, Label_22_4E43
	cp a, $26
	jp z, Label_22_4E43
	jp Label_22_4E5D

; ---- code $4E41-$4E43 (2 bytes) [HYPOTHESIS] jr $4EB9 (18 76) after the unconditional 'jp $4E5D': unreachable, same pattern as 4BB5; target is a code instruction start
	jr Label_22_4EB9

; ---- code $4E43-$4E79 (54 bytes) [PROBABLE] 64 insn(s) reached by static flow only; seeds: exec x64; min discovery hops 5; entered by jpcc from 22:4E22 (PROBABLE code) | 19 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split

Label_22_4E43:: ; 22:4E43
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4E55
	ld b, $00
	farcall MailDisconnect_Screen
	jr Label_22_4E5D

Label_22_4E55:: ; 22:4E55
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer

Label_22_4E5D:: ; 22:4E5D
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, Label_22_4E6A
	ld a, h
	or a, l
	jr z, Label_22_4E78

Label_22_4E6A:: ; 22:4E6A
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4E78:: ; 22:4E78
	ret

; ---- code $4E79-$4EA2 (41 bytes) [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split [executed in 1 scenarios]

Label_22_4E79:: ; 22:4E79
	farcall MailServerMgr_Run
	cp a, $80
	ld a, [wTimerEnable]
	bit 4, a
	jp z, Label_22_4EA2
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr Label_22_4EB9

; ---- code $4EA2-$4EB9 (23 bytes) [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split

Label_22_4EA2:: ; 22:4EA2
	ld a, $00
	ld b, $02
	ld a, $01
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

; ---- code $4EB9-$4EC3 (10 bytes) [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split [executed in 1 scenarios]

Label_22_4EB9:: ; 22:4EB9
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, Label_22_4EC7

; ---- code $4EC3-$4EC7 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split
	ld a, h
	or a, l
	jr z, Label_22_4ED5

; ---- code $4EC7-$4EE9 (34 bytes) [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split [executed in 1 scenarios]

Label_22_4EC7:: ; 22:4EC7
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen

Label_22_4ED5:: ; 22:4ED5
	ld a, $02
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4EE9-$4EF0 (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied to $D624 by the 'ld de,$4EE9 ; ld b,$07' loop at 22:4DCD

Data_22_4EE9:: ; 22:4EE9
	db $03, $00, $00, $01, $24, $D5, $00
