; engine/mail_server/delete_messages.asm
; bank 23, $6D61-$6FD7 (630 bytes); pinned by layout.link
; result messages, message tile upload, elapsed-time drawing

SECTION "engine/mail_server/delete_messages", ROMX

; ---- code $6D61-$6D8C (43 bytes) [HYPOTHESIS] complete function (28 insn, push af/bc/de/hl ... pop ... ret): fills $D1E0.. with $14 words; starts after the ret at 6D60; no caller found (entry unproven) [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_23_6D61:: ; 23:6D61
	push af
	push bc
	push de
	push hl
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D1E0
	ld a, $14
	ld b, $14

Label_23_6D79:: ; 23:6D79
	ld [hli], a
	inc a
	dec b
	jr nz, Label_23_6D79
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- code $6D8C-$6DA7 (27 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 12; entered by call from 23:4E62 (PROBABLE code) [executed in 1 scenarios]

MailSrvDel_MsgNoMail:: ; 23:6D8C
	push bc
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld bc, $D000
	ld de, $D140
	ld hl, String_MailSrvDel_MsgNoMail
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadMessageTiles
	pop bc
	ret

; ---- text $6DA7-$6DD0 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDel_MsgNoMail:: ; 23:6DA7
String_23_6DA7::
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $CD, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $82, $F1, $82, $C5, $82, $B5, $82, $BD, $81, $40 ; "　　　　メールはありませんでした　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $6DD0-$6DEB (27 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 17; entered by call from 23:507A (PROBABLE code) [executed in 3 scenarios]

MailSrvDel_MsgAllDeleted:: ; 23:6DD0
	push bc
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld bc, $D000
	ld de, $D140
	ld hl, String_MailSrvDel_MsgAllDeleted
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadMessageTiles
	pop bc
	ret

; ---- text $6DEB-$6E14 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDel_MsgAllDeleted:: ; 23:6DEB
String_23_6DEB::
	db $81, $40, $81, $40, $81, $40, $82, $B7, $82, $D7, $82, $C4, $82, $CC, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $AF, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $40 ; "　　　すべてのメールをけしました　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $6E14-$6E2F (27 bytes) [PROBABLE] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 8; entered by call from 23:5578 (PROBABLE code)

MailSrvDel_MsgBlank:: ; 23:6E14
	push bc
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld bc, $D000
	ld de, $D140
	ld hl, String_MailSrvDel_MsgBlank
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadMessageTiles
	pop bc
	ret

; ---- text $6E2F-$6E58 (41 bytes) [PROBABLE] 20 ideographic spaces + NUL, addressed by ld hl,$6E2F at 23:6E21 (code region 6E14-6E2F)

String_MailSrvDel_MsgBlank:: ; 23:6E2F
String_23_6E2F::
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40 ; "　　　　　　　　　　　　　　　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $6E58-$6E68 (16 bytes) [HYPOTHESIS] first 16 bytes of the twin of the function 6E14-6E2F (push bc ; ld a,2 ; ldh [$B0],a ; ld a,$23 ; ld bc,$D000 ; ld de,$D140 ; ld hl,$6E73 ...) - falls into the CONFIRMED-flow tail at 6E68; its ld hl,$6E73 points at the next text string [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]

Function_23_6E58:: ; 23:6E58
	push bc
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld bc, $D000
	ld de, $D140
	ld hl, $6E73

; ---- code $6E68-$6E73 (11 bytes) [PROBABLE] 4 insn(s) reached by static flow only; seeds: site x4; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadMessageTiles
	pop bc
	ret

; ---- text $6E73-$6E9C (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDel_MsgCancelled:: ; 23:6E73
String_23_6E73::
	db $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $83, $4C, $83, $83, $83, $93, $83, $5A, $83, $8B, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $40, $81, $40, $81, $40 ; "　　　　　キャンセルしました　　　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $6E9C-$6EB7 (27 bytes) [CONFIRMED] 11 insn(s) reached by static flow only; seeds: exec x11; min discovery hops 7; entered by call from 23:4CEA (PROBABLE code) [executed in 3 scenarios]

MailSrvDel_MsgReading:: ; 23:6E9C
	push bc
	ld a, $02
	ldh [hRam_FFB0], a
	ld a, $23
	ld bc, $D000
	ld de, $D140
	ld hl, String_MailSrvDel_MsgReading
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadMessageTiles
	pop bc
	ret

; ---- text $6EB7-$6EE0 (41 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_MailSrvDel_MsgReading:: ; 23:6EB7
String_23_6EB7::
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $82, $F0, $82, $E6, $82, $DD, $82, $B1, $82, $F1, $82, $C5, $82, $A2, $82, $DC, $82, $B7, $81, $40 ; "　　　　メールをよみこんでいます　"
	db $81, $40, $81, $40, $81, $40, $00 ; "　　　"

; ---- code $6EE0-$6F22 (66 bytes) [CONFIRMED] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 7; entered by call from 23:6DA2 (PROBABLE code) [executed in 3 scenarios]

MailSrvDel_UploadMessageTiles:: ; 23:6EE0
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

MailSrvDel_DrawElapsedTime:: ; 23:6F00
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [rVBK], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerASeconds]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]
	cp a, b
	jr nz, Label_23_6F3C
	pop hl
	pop de
	pop bc
	pop af
	ret

; ---- code $6F22-$6F3C (26 bytes) [HYPOTHESIS] function prologue after the ret at 6F21 (push af/bc/de/hl ; xor a ; ldh [$4F],a ; ... ld a,[$D624]) falling into 6F3C [verifier: no entry proven (no caller, no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS]
	push af
	push bc
	push de
	push hl
	xor a, a
	ldh [rVBK], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wTimerASeconds]
	ld b, a
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wMailSessionBlock]

; ---- code $6F3C-$6F47 (11 bytes) [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 8; entered by jrcc from 23:6F1B (PROBABLE code) | 5 insn(s) executed; cut out of the PROBABLE region 6F3C-6F60 by apply_coverage --split [executed in 5 scenarios]

Label_23_6F3C:: ; 23:6F3C
	ld a, b
	ld [wMailSessionBlock], a
	ld a, [wTimerAMinutes]
	cp a, $3C
	jr c, Label_23_6F89

; ---- code $6F47-$6F60 (25 bytes) [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F3C-6F60 by apply_coverage --split

Label_23_6F47:: ; 23:6F47
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D221
	ld a, $45
	ld [hli], a
	ld a, $49
	ld [hli], a
	inc hl
	ld a, $45
	ld [hli], a
	ld a, $49
	ld [hl], a
	jp Label_23_6FCB

; ---- code $6F60-$6F6F (15 bytes) [HYPOTHESIS] ld a,[$C2D6] ; add a,$3C ; cp $64 ; jr nc ; ld l,a ; ld h,0 ; ld de,$000A then the far call at 6F6F: decodes exactly to the next region start (7 insn)
	ld a, [wTimerAMinutes]
	add a, $3C
	cp a, $64
	jr nc, Label_23_6F47
	ld l, a
	ld h, $00
	ld de, $000A

; ---- code $6F6F-$6F89 (26 bytes) [PROBABLE] 48 insn(s) reached by static flow only; seeds: exec x37, site x11; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region 6F6F-6FD7 by apply_coverage --split
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D221], a
	ld a, e
	add a, $40
	ld [wRam_D222], a
	jr Label_23_6FAA

; ---- code $6F89-$6FD7 (78 bytes) [CONFIRMED] 37 insn(s) executed; cut out of the PROBABLE region 6F6F-6FD7 by apply_coverage --split [executed in 5 scenarios]

Label_23_6F89:: ; 23:6F89
	ld a, [wTimerAMinutes]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D221], a
	ld a, e
	add a, $40
	ld [wRam_D222], a

Label_23_6FAA:: ; 23:6FAA
	ld a, [wTimerASeconds]
	ld l, a
	ld h, $00
	ld de, $000A
	farcall Divide16
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, l
	add a, $40
	ld [wRam_D224], a
	ld a, e
	add a, $40
	ld [wRam_D225], a

Label_23_6FCB:: ; 23:6FCB
	di
	ldh a, [rLCDC]
	call Function_00_085B
	ei
	pop hl
	pop de
	pop bc
	pop af
	ret
