; engine/mobile/pop3_top.asm
; bank 54, $485C-$4C47 (1003 bytes); pinned by layout.link
; POP3 login/STAT/TOP start and poll with the mail status strings

SECTION "engine/mobile/pop3_top", ROMX

Pop3_StartLogin:: ; 54:485C
Function_54_485C::
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call Mobile_ResetCommandTimer
	ld a, $03
	ld [wMobileRetriesLeft], a
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld hl, $C201
	ld de, $C480
	farcall CopyString
	ld hl, $C220
	farcall CopyString
	ld a, [wMobileFlags]
	bit 0, a
	jr nz, .l4895
	ld hl, $C480
	ld a, $1E
	farcall MobileAPI
	ret

.l4895 ; 54:4895
	; [PROBABLE] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 54:4887 (executed)
	ld a, $02
	ld [wMobileTaskStep], a
	ret

Pop3_LoginStatPoll:: ; 54:489B
Function_54_489B::
	; [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call Mobile_CheckTimeout
	farcall MailSession_UpdateTimerDisplay
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l48B2
	bit 0, a
	jr z, .l48B8
	ld a, $01
	ret

.l48B2 ; 54:48B2
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 54:48A9 (executed) [executed in 2 scenarios]
	call Mobile_FetchResult
	ld a, $FF
	ret

.l48B8 ; 54:48B8
	; [CONFIRMED] 7 insn(s); 7 executed (in up to 2/18 scenarios)
	ld hl, $C1D9
	inc [hl]
	ld a, [hl]
	dec a
	jr z, .l48F9
	dec a
	jr z, .l4907

	; [PROBABLE] 22 insn(s) reached by static flow only; seeds: exec x22; min discovery hops 0;
	; fall-through of the jrcc at 54:48C1 (executed)
	dec a
	jr z, .l48C9
	ld a, $FF
	ret
.l48C9 ; 54:48C9
	ld a, [wMobileFlags]
	bit 0, a
	jr nz, .l48F5
	xor a, a
	ld [hl], a
	ld hl, $C201
	ld de, $C480
	farcall CopyString
	ld hl, $C220
	farcall CopyString
	ld hl, $C480
	ld a, $1E
	farcall MobileAPI
	ld a, $01
	ret
.l48F5 ; 54:48F5
	dec [hl]
	ld a, $01
	ret

.l48F9 ; 54:48F9
	; [CONFIRMED] 14 insn(s); 14 executed (in up to 2/18 scenarios)
	ld a, $20
	ld de, $C240
	farcall MobileAPI
	ld a, $01
	ret
.l4907 ; 54:4907
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ld hl, $C240
	ld a, [hli]
	ld h, [hl]
	ld l, a
	xor a, a
	ret

Pop3_StartTop:: ; 54:4914
	; [CONFIRMED] 87 insn(s) reached by static flow only; seeds: exec x87; min discovery hops 9;
	; entered by far from 23:4D97 (PROBABLE code) | 54 insn(s) executed; cut out of the PROBABLE
	; region 4914-49E0 by apply_coverage --split [executed in 2 scenarios]
	push hl
	push bc
	call Mobile_ResetCommandTimer
	pop bc
	pop hl
	ld a, l
	ld [wMobileTaskArgs + 4], a
	ld a, h
	ld [wMobileTaskArgs + 5], a
	ld a, c
	ld [wMobileTaskArgs], a
	ld a, $03
	ld [wMobileRetriesLeft], a
	push hl
	ld hl, $C480
	ld bc, $0200
.loop ; 54:4933
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	pop hl
	ld a, $01
	ld [wMobileTaskKind], a
	xor a, a
	ld [wMobileTaskStep], a
	ld [wRam_C240], a
	ldh a, [hSRAMBank]
	ld [wRam_C25E], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $A000
	ld bc, $0FFF
	ld a, $28
	farcall MobileAPI
	ret

Pop3_TopPoll:: ; 54:4969
	call Mobile_CheckTimeout
	ld a, [wTimerEnable]
	bit 1, a
	jr nz, .l497E
	bit 2, a
	jr nz, .l4984
	bit 0, a
	jr z, .l4995
	ld a, $01
	ret
.l497E ; 54:497E
	call Mobile_FetchResult
	ld a, $FF
	ret

.l4984 ; 54:4984
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4914-49E0 by apply_coverage --split
	ld de, $C480
	ld bc, $0000
	ld a, $28
	farcall MobileAPI
	ld a, $01
	ret

.l4995 ; 54:4995
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4914-49E0 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	call Function_54_511D
	or a, a
	jr z, Label_54_4A12
	ld a, [wMobileTaskArgs]
	cp a, $01
	jp nz, Label_54_4BE8

	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4914-49E0 by apply_coverage --split
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_Mail_DataCorrupt
	ld de, $D406
	ld bc, $0010
	farcall CopyBytes
	ld hl, $4A01
	ld de, $D41B
	farcall CopyString
	ld hl, $49F0
	ld de, $D4C0
	farcall CopyString
	jp Label_54_4BE8

; ---- text $49E0-$4A12 (50 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Mail_DataCorrupt:: ; 54:49E0
String_54_49E0::
	db $83, $81, $81, $5B, $83, $8B, $82, $CC, $83, $66, $81, $5B, $83, $5E, $82, $AA, $82, $B1, $82, $ED, $82, $EA, $82, $C4, $82, $A2, $82, $DC, $82, $B7, $81, $42, $00 ; "メールのデータがこわれています。"

String_Mail_PleaseDelete:: ; 54:4A01
	db $82, $AF, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "けしてください。"

Label_54_4A12:: ; 54:4A12
	; [CONFIRMED] 78 insn(s) reached by static flow only; seeds: exec x78; min discovery hops 12;
	; entered by jrcc from 54:49A6 (PROBABLE code) | 74 insn(s) executed; cut out of the PROBABLE
	; region 4A12-4AD0 by apply_coverage --split [executed in 5 scenarios]
	ld a, [wMobileTaskArgs]
	cp a, $01
	jp z, .l4A24
	ld a, b
	or a, a
	jp z, Label_54_4BEC
	ld b, $00
	jp Label_54_4BC6
.l4A24 ; 54:4A24
	ld a, b
	ld [sSram_B4FF], a
	ld hl, $B400
	ld b, $FA
	xor a, a
.l4A2E ; 54:4A2E
	ld [hli], a
	dec b
	jr nz, .l4A2E
	ld de, $C240
	ld hl, Data_54_4C35
	ld bc, $0008
	farcall CopyBytes
	ld de, $C240
	ld hl, Data_54_4C3D
	ld bc, $0007
	farcall CopyBytes
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr nz, .l4A8A
	ld de, $C480
	add hl, de
	xor a, a
	ld [hl], a
	ld de, $C580
	ld hl, $C480
	ld bc, $0200
	farcall Charset_Iso2022JpToSjis
	ld de, $B450
	ld hl, $B470
	call Function_54_4FD2
	ld b, $13
	ld hl, $B470
	call Text_TruncateSjis
.l4A8A ; 54:4A8A
	ld a, $0A
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr nz, Label_54_4AE6
	ld c, l
	ld b, h
	ld hl, $C480
	add hl, bc
	xor a, a
	ld [hl], a
	ld b, $13
	ld hl, $C480
	call Text_TruncateSjis
	ld hl, $C480
	ld de, String_Mail_GameTitle
.l4AB9 ; 54:4AB9
	ld a, [de]
	inc de
	or a, a
	jr z, Label_54_4AE6
	cp a, [hl]
	inc hl
	jr z, .l4AB9

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4A12-4AD0 by apply_coverage --split
	ld de, $B430
	ld hl, $C480
	farcall CopyString
	jr Label_54_4AF2

; ---- text $4AD0-$4AD7 (7 bytes) [PROBABLE] NUL-terminated Shift-JIS string "メール" (mail); passed in HL to CopyString 00:14BF (FarCall bf 14 00) at 54:4AE9

String_Mail_DefaultSource:: ; 54:4AD0
String_54_4AD0::
	db $83, $81, $81, $5B, $83, $8B, $00 ; "メール"

; ---- text $4AD7-$4AE6 (15 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_Mail_GameTitle:: ; 54:4AD7
String_54_4AD7::
	db $4D, $4F, $42, $49, $4C, $45, $20, $54, $52, $41, $49, $4E, $45, $52, $00 ; "MOBILE TRAINER"

Label_54_4AE6:: ; 54:4AE6
	; [CONFIRMED] 133 insn(s) reached by static flow only; seeds: exec x133; min discovery hops 12;
	; entered by jrcc from 54:4AA1 (PROBABLE code) | 76 insn(s) executed; cut out of the PROBABLE
	; region 4AE6-4C2A by apply_coverage --split [executed in 2 scenarios]
	ld de, $B430
	ld hl, String_Mail_DefaultSource
	farcall CopyString

Label_54_4AF2:: ; 54:4AF2
	ld a, $06
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr nz, .l4B1D
	call Mail_ParseDate
	ld de, $B400
	ld hl, $C580
	ld bc, $0006
	farcall CopyBytes
.l4B1D ; 54:4B1D
	ld a, $05
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jr nz, .l4B6F
	ld de, $C480
	add hl, de
	xor a, a
	ld [hl], a
	ld hl, $B410
	ld b, $1A
	xor a, a
.l4B42 ; 54:4B42
	ld [hli], a
	dec b
	jr nz, .l4B42
	ld de, $B410
	ld hl, $C480
	ld bc, $0018
	farcall Charset_Iso2022JpToSjis
	ld hl, $B410
	ld hl, $B410
	ld b, $FF
.l4B5D ; 54:4B5D
	inc b
	ld a, [hli]
	or a, a
	jr nz, .l4B5D
	ld a, b
	cp a, $15
	jr c, .l4B6F
	ld b, $12
	ld hl, $B410
	call Text_TruncateSjis
.l4B6F ; 54:4B6F
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $B400
	ld de, $D400
	ld bc, $0006
	farcall CopyBytes
	ld hl, $B430
	ld de, $D406
	farcall CopyString
	ld hl, $B410
	ld de, $D41B
	farcall CopyString
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, $D4C0
	ld hl, $B450
	ld a, [hl]
	or a, a
	jr nz, .l4BAF

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4AE6-4C2A by apply_coverage --split
	ld hl, $B470

.l4BAF ; 54:4BAF
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 4AE6-4C2A by apply_coverage
	; --split [executed in 7 scenarios]
	farcall CopyString
	ld c, $00
	ld a, [sSram_B450]
	or a, a
	jr nz, .l4BBE

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4AE6-4C2A by apply_coverage --split
	inc c

.l4BBE ; 54:4BBE
	; [CONFIRMED] 48 insn(s) executed; cut out of the PROBABLE region 4AE6-4C2A by apply_coverage
	; --split [executed in 7 scenarios]
	ld a, [sSram_B4FF]
	or a, a
	jr z, Label_54_4BEC
	ld b, $00

Label_54_4BC6:: ; 54:4BC6
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ld a, [wRam_C25E]
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
	ld hl, $C1D8
	xor a, a
	ld [hl], a
	ret

Label_54_4BE8:: ; 54:4BE8
	ld b, $01
	jr Label_54_4BC6

Label_54_4BEC:: ; 54:4BEC
	ld de, $C240
	ld hl, Data_54_4C3D
	ld bc, $0007
	farcall CopyBytes
	ld a, $0B
	ld [wRam_C240], a
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $06
	ld de, $C240
	farcall Function_00_0247
	or a, a
	jp nz, Label_54_4BE8
	ld b, $0B
	ld hl, $C480
	ld de, String_Mail_GameCodeCrystal
.loop ; 54:4C1D
	ld a, [de]
	cp a, [hl]
	jr nz, Label_54_4BE8
	inc hl
	inc de
	dec b
	jr nz, .loop

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4AE6-4C2A by apply_coverage --split
	ld b, $02
	jr Label_54_4BC6

; ---- text $4C2A-$4C35 (11 bytes) [PROBABLE] 11 ASCII bytes "CGB-BXTJ-00" (no terminator; the game ID string): compared byte by byte with [$C480..] for b=$0B by 54:4C1A (ld de,$4C2A)

String_Mail_GameCodeCrystal:: ; 54:4C2A
String_54_4C2A::
	db $43, $47, $42, $2D, $42, $58, $54, $4A, $2D, $30, $30 ; "CGB-BXTJ-00"

; ---- data $4C35-$4C3D (8 bytes) [PROBABLE] 8-byte blob (03 02 a0 03 00 b0 00 08, same bytes as 54:4FC3) read via ld hl,$4C35 at 54:4A35

Data_54_4C35:: ; 54:4C35
	db $03, $02, $A0, $03, $00, $B0, $00, $08

; ---- data $4C3D-$4C44 (7 bytes) [PROBABLE] 7-byte blob (same bytes as 54:4FCB) read via ld hl,$4C3D at 54:4A44 and 54:4BEF

Data_54_4C3D:: ; 54:4C3D
	db $00, $03, $02, $A0, $03, $80, $C4

; ---- data $4C44-$4C47 (3 bytes) [PROBABLE] 3-byte blob (03 02 a0) read via ld hl,$4C44 at 54:5124

Data_54_4C44:: ; 54:4C44
	db $03, $02, $A0
