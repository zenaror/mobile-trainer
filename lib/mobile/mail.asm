; lib/mobile/mail.asm
; bank 0F, $4000-$5DAE (7598 bytes); pinned by layout.link
; SDK mail library (= Crystal bank 45 lib/mobile/mail.asm) with its header strings and selector tables

SECTION "lib/mobile/mail", ROMX

; ---- text $4000-$4004 (4 bytes) [PROBABLE] ASCII string "---" + NUL (mail-header/text helper strings of this bank; neighbour of the CONFIRMED-style string table entries)

PUSHC sjis
MailStr_Boundary:: ; 0F:4000

	db "---", 0
POPC

; ---- text $4004-$4010 (12 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_GameCodeAllowList:: ; 0F:4004

	db "CGB-AAAA-00", 0
POPC

; ---- zero $4010-$4011 (1 bytes) [PROBABLE] 1 x 00 pad byte between the string ending at 4010 (MailStr_GameCodeAllowList ends at its NUL 400F) and the table at 4011
	ds $1, $00

; ---- ptrtable $4011-$4033 (34 bytes) [PROBABLE] 17 x dw string pointers: 4033 "From: ", 403A "Sender: ", 4043 "Reply-To: ", 404E "To: ", 4053 "Cc: ", 4058 "Subject: ", ... 4164 "--", 4167 "."; every target is a NUL-terminated ASCII string start (mail header field names of the message composer/parser); table starts at an odd address

Mail_HeaderStringTable:: ; 0F:4011

	dw MailStr_HdrFrom
	dw MailStr_HdrSender
	dw MailStr_HdrReplyTo
	dw MailStr_HdrTo
	dw MailStr_HdrCc
	dw MailStr_HdrSubject
	dw MailStr_HdrMimeVersion
	dw MailStr_HdrXGameTitle
	dw MailStr_HdrXGameCode
	dw MailStr_HdrXGBmailType
	dw MailStr_HdrContentTypeText
	dw MailStr_HdrContentTypeMultipart
	dw MailStr_HdrContentTypeOctet
	dw MailStr_HdrTransferEncodingBase64
	dw MailStr_DashDash
	dw MailStr_DashDash
	dw MailStr_Dot

; ---- text $4033-$403A (7 bytes) [PROBABLE] ASCII string "From: " + NUL, entry 0 of the pointer table 0F:4011

PUSHC sjis
MailStr_HdrFrom:: ; 0F:4033

	db "From: ", 0
POPC

; ---- text $403A-$404E (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_HdrSender:: ; 0F:403A

	db "Sender: ", 0

MailStr_HdrReplyTo:: ; 0F:4043
	db "Reply-To: ", 0
POPC

; ---- text $404E-$4058 (10 bytes) [PROBABLE] ASCII strings "To: " and "Cc: " (entries 3 and 4 of the pointer table 0F:4011 = 404E, 4053)

PUSHC sjis
MailStr_HdrTo:: ; 0F:404E

	db "To: ", 0

MailStr_HdrCc:: ; 0F:4053
	db "Cc: ", 0
POPC

; ---- text $4058-$4164 (268 bytes) [PROBABLE] text: 9 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_HdrSubject:: ; 0F:4058

	db "Subject: ", 0

MailStr_HdrMimeVersion:: ; 0F:4062
	db "MIME-Version: 1.0", 0

MailStr_HdrXGameTitle:: ; 0F:4074
	db "X-Game-title: MOBILE TRAINER", 0

MailStr_HdrXGameCode:: ; 0F:4091
	db "X-Game-code: CGB-", 0

MailStr_HdrXGBmailType:: ; 0F:40A3
	db "X-GBmail-type: exclusive", 0

MailStr_HdrContentTypeText:: ; 0F:40BC
	db "Content-Type: text/plain; charset=iso-2022-jp", 0

MailStr_HdrContentTypeMultipart:: ; 0F:40EA
	db "Content-Type: multipart/mixed; boundary=\"", 0

MailStr_HdrContentTypeOctet:: ; 0F:4114
	db "Content-Type: Application/Octet-Stream; name=\"", 0

MailStr_HdrTransferEncodingBase64:: ; 0F:4143
	db "Content-Transfer-Encoding:Base64", 0
POPC

; ---- text $4164-$4167 (3 bytes) [PROBABLE] ASCII string "--" + NUL (entry 14/15 of the pointer table 0F:4011 = 4164)

PUSHC sjis
MailStr_DashDash:: ; 0F:4164

	db "--", 0
POPC

; ---- text $4167-$4169 (2 bytes) [PROBABLE] ASCII string "." + NUL (entry 16 of the pointer table 0F:4011 = 4167)

PUSHC sjis
MailStr_Dot:: ; 0F:4167

	db ".", 0
POPC

; ---- words $4169-$4183 (26 bytes) [PROBABLE] 13-entry jump table: the dispatcher at 0F:4250-425F reads [D002]*2 + $4169 (ld hl,$4169 ; add hl,de ; ld a,[hli] ; ld h,[hl] ; ld l,a ; ... jp hl); all 13 targets (426C 426D 4340 43BB 44D5 4B59 4BC0 4CDD 4E66 52BC 54D8 56E1 5A10) are instruction starts of the PROBABLE code regions of this bank

Mail_SelectorTable:: ; 0F:4169

	dw Mail_SelectorNop, Mail_ScanHeaders, Mail_CheckGameMail, Mail_LocateHeader, Mail_ParseBody, Mail_IndexHeaders, Mail_GetDecodedHeader, Mail_GetAddressList
	dw Mail_ComposeNext, Mail_ComposeHeaderBlock, Mail_ComposeMimeBody, Mail_Base64EncodeStream, Mail_Base64DecodeStream

; ---- ptrtable $4183-$419D (26 bytes) [PROBABLE] 13 x dw pointers to the ASCII header-name strings 419D "FROM:", 41A3 "SENDER:", 41AB "REPLY-TO:", 41B5 "TO:", 41B9 "CC:", 41BD "SUBJECT:", 41C6 "DATE:", 41CC "CONTENT-TYPE:", ... 420D "X-GBMAIL-TYPE:" (independent of the 13-entry selector table 0F:4169; B indexes these keywords in Mail_FindHeader_Scan 0F:4416; every target is a string start)

Mail_HeaderKeywordTable:: ; 0F:4183

	dw MailStr_KwFrom
	dw MailStr_KwSender
	dw MailStr_KwReplyTo
	dw MailStr_KwTo
	dw MailStr_KwCc
	dw MailStr_KwSubject
	dw MailStr_KwDate
	dw MailStr_KwContentType
	dw MailStr_KwMimeVersion
	dw MailStr_KwXMailer
	dw MailStr_KwXGameTitle
	dw MailStr_KwXGameCode
	dw MailStr_KwXGBmailType

; ---- text $419D-$41AB (14 bytes) [PROBABLE] ASCII strings "FROM:" and "SENDER:" + NULs (entries 0-1 of the pointer table 0F:4183)

PUSHC sjis
MailStr_KwFrom:: ; 0F:419D

	db "FROM:", 0

MailStr_KwSender:: ; 0F:41A3
	db "SENDER:", 0
POPC

; ---- text $41AB-$41B5 (10 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwReplyTo:: ; 0F:41AB

	db "REPLY-TO:", 0
POPC

; ---- text $41B5-$41BD (8 bytes) [PROBABLE] ASCII strings "TO:" and "CC:" (entries of the pointer table 0F:4183)

PUSHC sjis
MailStr_KwTo:: ; 0F:41B5

	db "TO:", 0

MailStr_KwCc:: ; 0F:41B9
	db "CC:", 0
POPC

; ---- text $41BD-$41C6 (9 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwSubject:: ; 0F:41BD

	db "SUBJECT:", 0
POPC

; ---- text $41C6-$41CC (6 bytes) [PROBABLE] ASCII string "DATE:" + NUL (entry 6 of the pointer table 0F:4183)

PUSHC sjis
MailStr_KwDate:: ; 0F:41C6

	db "DATE:", 0
POPC

; ---- text $41CC-$421C (80 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwContentType:: ; 0F:41CC

	db "CONTENT-TYPE:", 0

MailStr_KwMimeVersion:: ; 0F:41DA
	db "MIME-VERSION:", 0

MailStr_KwXMailer:: ; 0F:41E8
	db "X-MAILER:", 0

MailStr_KwXGameTitle:: ; 0F:41F2
	db "X-GAME-TITLE:", 0

MailStr_KwXGameCode:: ; 0F:4200
	db "X-GAME-CODE:", 0

MailStr_KwXGBmailType:: ; 0F:420D
	db "X-GBMAIL-TYPE:", 0
POPC

; ---- text $421C-$4222 (6 bytes) [PROBABLE] ASCII string "NAME=" + NUL (MIME parameter, referenced by ld hl in the parser)

PUSHC sjis
MailStr_KwName:: ; 0F:421C

	db "NAME=", 0
POPC

; ---- text $4222-$4236 (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwMultipart:: ; 0F:4222

	db "MULTIPART", 0

MailStr_KwBoundary:: ; 0F:422C
	db "BOUNDARY=", 0
POPC

; ---- text $4236-$4247 (17 bytes) [PROBABLE] ASCII string "=?ISO-2022-JP?B?" + NUL (MIME encoded-word prefix), copied by 0F:5104 (ld hl,$4236 ; ld a,[hli] ; and a ; jr z ; ld [de],a)

PUSHC sjis
MailStr_EncodedWordPrefix:: ; 0F:4236

	db "=?ISO-2022-JP?B?", 0
POPC

Mail_Dispatch:: ; 0F:4247
	; [CONFIRMED] 795 insn(s) reached by static flow only; seeds: exec x16, mobile x779; min
	; discovery hops 0; entered by call from 00:0262 (PROBABLE code) | 22 insn(s) executed; cut out
	; of the PROBABLE region 4247-47A5 by apply_coverage --split [executed in 18 scenarios]
	ld a, $0A
	ld [rRAMG], a
	ldh a, [hSRAMBank]
	push af
	push de
	ld a, [wMail_Selector]
	add a, a
	ld e, a
	ld d, $00
	ld hl, Mail_SelectorTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop de
	jp hl

Mail_Return:: ; 0F:4260
	ld [wMail_Selector], a
	pop af
	ldh [hSRAMBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ret

Mail_SelectorNop:: ; 0F:426C
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ret

Mail_ScanHeaders:: ; 0F:426D
	; [CONFIRMED] 37 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	ld h, d
	ld l, e
	xor a, a
	ld [wMail_Selector], a
	ld [wMail_Work + $03], a
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
.scan_header_byte ; 0F:4286
	ld a, [de]
	and a, a
	jr z, .l42A8
	ld h, a
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .check_cr_and_clear_selector
	ld a, h
	cp a, $80
	jr nc, .l42B2
.check_cr_and_clear_selector ; 0F:4296
	ld a, h
	cp a, $0D
	jr z, .advance_past_cr
	xor a, a
	ld [wMail_Selector], a
.advance_header_cursor ; 0F:429F
	inc e
	call z, Mail_ScanHeaders_NextPage
	dec bc
	ld a, b
	or a, c
	jr nz, .scan_header_byte

.l42A8 ; 0F:42A8
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .l4307
	ld b, $80
	jr .l42B4

.l42B2 ; 0F:42B2
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 1 scenarios]
	ld b, $81
.l42B4 ; 0F:42B4
	ld a, [wMail_InputBank]
	ld c, a
	ld a, $01
	ld h, d
	ld l, e
	jp Mail_Return
.advance_past_cr ; 0F:42BF
	and a, a
	jr z, .l42A8
	inc e
	call z, Mail_ScanHeaders_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, .l42A8
	ld a, [de]
	ld h, a
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .check_lf_and_header_continuation
	ld a, h
	cp a, $80
	jr nc, .l42B2
.check_lf_and_header_continuation ; 0F:42D8
	ld a, h
	cp a, $0A
	jr nz, .l42B2
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .enter_body_and_check_dot
	ld a, [wMail_Selector]
	and a, a
	jr nz, .clear_header_selector
	ld a, $01
	ld [wMail_Selector], a
	inc e
	call z, Mail_ScanHeaders_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, .l42A8
	ld a, [de]
	cp a, $20
	jr z, .advance_header_cursor
	cp a, $09
	jr z, .advance_header_cursor
	jr .scan_header_byte
.l4302 ; 0F:4302
	xor a, a
	ld b, a
	jp Mail_Return

.l4307 ; 0F:4307
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	xor a, a
	ld b, $01
	jp Mail_Return

.clear_header_selector ; 0F:430D
	; [CONFIRMED] 44 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	xor a, a
	ld [wMail_Selector], a
.enter_body_and_check_dot ; 0F:4311
	ld a, [wMail_Selector]
	and a, a
	jr nz, .l4302
	ld a, $01
	ld [wMail_Work + $03], a
	inc e
	call z, Mail_ScanHeaders_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, .l42A8
	ld a, [de]
	and a, a
	jp z, .l42A8
	cp a, $2E
	jp nz, .scan_header_byte
	ld a, $01
	ld [wMail_Selector], a
	jp .advance_header_cursor

Mail_ScanHeaders_NextPage:: ; 0F:4337
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_CheckGameMail:: ; 0F:4340
	push de
	ld h, d
	ld l, e
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, $0B
	call Mail_FindHeader
	cp a, $02
	jr z, .l435C
	and a, a
	jr z, .find_game_code_header
	pop hl
.l4355 ; 0F:4355
	xor a, a
	ld b, $03
	jp Mail_Return

.l435B ; 0F:435B
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	pop hl
.l435C ; 0F:435C
	pop hl
	ld a, $01
	ld b, $82
	jp Mail_Return

.find_game_code_header ; 0F:4364
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 14 scenarios]
	ld a, h
	ld [wMail_Work + $03], a
	pop hl
	push bc
	push de
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld b, $0C
	call Mail_FindHeader
	cp a, $02
	jr z, .l435B
	and a, a
	jr z, .unfold_game_code_header

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	xor a, a
	ld b, $02
	pop hl
	pop hl
	jp Mail_Return

.unfold_game_code_header ; 0F:4385
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 1 scenarios]
	pop de
	pop bc
	ld a, [wMail_Work + $03]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Mail_UnfoldHeader
	ld hl, MailStr_GameCodeAllowList
.restart_allowed_code_comparison ; 0F:4398
	ld de, wMail_TextBuf1
.compare_allowed_code_bytes ; 0F:439B
	ld a, [hli]
	and a, a
	jr z, .check_code_ends_at_allowed_terminator
	ld b, a
	ld a, [de]
	inc de
	cp a, b
	jr z, .compare_allowed_code_bytes
.skip_unmatched_allowed_code ; 0F:43A5
	ld a, [hli]
	and a, a
	jr nz, .skip_unmatched_allowed_code
	ld a, [hl]
	and a, a
	jr nz, .restart_allowed_code_comparison
	ld b, a
	jp Mail_Return
.check_code_ends_at_allowed_terminator ; 0F:43B1
	ld a, [de]
	and a, a
	jr nz, .l4355
	xor a, a
	ld b, $01
	jp Mail_Return

Mail_LocateHeader:: ; 0F:43BB
	; [PROBABLE] 44 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, [de]
	ld b, a
	inc de
	ld a, [de]
	ld c, a
	inc de
	ld a, [de]
	ld h, a
	inc de
	ld a, [de]
	inc de
	push de
	ld d, a
	ld e, h
	call Mail_FindHeader
	cp a, $02
	jr z, .l43EF
	and a, a
	jr nz, .l43F1
	ld a, h
	pop hl
	push af
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	pop af
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	jp Mail_Return
.l43EF ; 0F:43EF
	ld b, $82
.l43F1 ; 0F:43F1
	ld a, $01
	pop hl
	jp Mail_Return

Mail_FindHeader:: ; 0F:43F7
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	call Mail_FindHeader_Scan
	and a, a
	jr nz, .l4411
	ld a, $04
	cp a, b
	jr c, .l440B
	jr z, .l4406
.loop ; 0F:4404
	xor a, a
	ret

.l4406 ; 0F:4406
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, $00
	cp a, c
	jr nc, .loop
.l440B ; 0F:440B
	ld bc, $0400
	ld a, $02
	ret

.l4411 ; 0F:4411
	; [CONFIRMED] 65 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 14 scenarios]
	ld a, $01
	ld b, $84
	ret

Mail_FindHeader_Scan:: ; 0F:4416

	ld a, c
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, Mail_HeaderKeywordTable
	ld a, b
	add a, a
	ld c, a
	ld b, $00
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld c, $00
	jr .read_and_uppercase_header_byte
.scan_to_next_header_line ; 0F:442F
	ld a, [de]
	and a, a
	jp z, .zero_current_byte_and_return_one
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0D
	jr nz, .scan_to_next_header_line
	ld a, [de]
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0A
	jr nz, .scan_to_next_header_line
	ld a, [de]
	cp a, $2E
	jr z, .check_cr_after_dot
	cp a, $0D
	jr z, .check_lf_after_cr
.read_and_uppercase_header_byte ; 0F:444E
	ld a, [wMail_InputBank]
	ld [wMail_Selector], a
	ld a, [de]
	and a, a
	jr z, .zero_current_byte_and_return_one
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $61
	jr c, .compare_header_name_character
	cp a, $7B
	jr nc, .compare_header_name_character
	sub a, $20
.compare_header_name_character ; 0F:4466
	ld b, a
	ld a, [hl]
	and a, a
	jr z, .skip_header_separator_if_space_or_lf
	cp a, b
	jr nz, .rewind_header_name_on_mismatch
	inc c
	inc hl
	jr .read_and_uppercase_header_byte
.rewind_header_name_on_mismatch ; 0F:4472
	ld a, c
	and a, a
	jr z, .scan_to_next_header_line
	dec c
	dec hl
	jr .rewind_header_name_on_mismatch
.skip_header_separator_if_space_or_lf ; 0F:447A
	ld a, $20
	cp a, b
	jr z, .save_value_start_and_zero_length

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, $0A
	cp a, b
	jr z, .save_value_start_and_zero_length
	dec de

.save_value_start_and_zero_length ; 0F:4485
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	ld h, d
	ld l, e
	ld bc, $0000
.measure_header_value_with_continuations ; 0F:448A
	ld a, [de]
	and a, a
	jr z, .zero_current_byte_and_return_one
	inc bc
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0D
	jr nz, .measure_header_value_with_continuations
	ld a, [de]
	inc bc
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0A
	jr nz, .measure_header_value_with_continuations
	ld a, [de]
	cp a, $20
	jr z, .measure_header_value_with_continuations
	cp a, $09
	jr z, .measure_header_value_with_continuations
	ld d, h
	ld e, l
	ld a, [wMail_Selector]
	ld h, a
	xor a, a
	ret

.check_cr_after_dot ; 0F:44B2
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	inc e
	call z, Mail_FindHeader_NextPage
	ld a, [de]
	cp a, $0D
	jp nz, .scan_to_next_header_line

.check_lf_after_cr ; 0F:44BC
	; [CONFIRMED] 74 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	inc e
	call z, Mail_FindHeader_NextPage
	ld a, [de]
	cp a, $0A
	jp nz, .scan_to_next_header_line
.zero_current_byte_and_return_one ; 0F:44C6
	ld a, $00
	ld [hl], a
	ld a, $01
	ret

Mail_FindHeader_NextPage:: ; 0F:44CC
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_ParseBody:: ; 0F:44D5
	call Mail_LoadArgs
	dec de
	dec de
	push de
	inc de
	inc de
	inc de
	inc hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc hl
	ld a, [de]
	ld [hld], a
	dec de
	ld a, [de]
	ld [hl], a
	xor a, a
	ld [wMail_Work + $16], a
	ld [wMail_ErrorFlag], a
	ld a, $02
	ld [wMail_Work + $0E], a
	ld hl, wMail_InputPos
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Mail_ParseContentType
	cp a, $02
	jr z, .l455F
	and a, a
	jr z, .parse_single_part_and_mark_type2
	ld a, $01
	ld [wMail_Work + $0D], a
	call Mail_ParseMultipart
	and a, a
	jr nz, .l455F
	jr .write_body_result_to_output
.parse_single_part_and_mark_type2 ; 0F:4515
	call Mail_ParseSinglePart
	and a, a
	jr nz, .l455F
	ld a, $02
	ld [wMail_Work + $0D], a
.write_body_result_to_output ; 0F:4520
	pop hl
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wMail_Work + $0D]
	ld [de], a
	ld b, $00
	ld a, [wMail_Work + $16]
	and a, a
	jr z, .skip

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $01

.skip ; 0F:453B
	; [CONFIRMED] 20 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hl]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wMail_OutputStream + $03
	ld e, [hl]
	inc hl
	ld d, [hl]
	dec de
	ld a, d
	or a, e
	jr z, .l455D
	ld hl, wMail_OutputStream + $01
	ld e, [hl]
	inc hl
	ld d, [hl]
	xor a, a
	ld [de], a
	jp Mail_Return

.l455D ; 0F:455D
	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $83
.l455F ; 0F:455F
	pop hl
	ld a, $01
	jp Mail_Return

Mail_LoadArgs:: ; 0F:4565
	; [CONFIRMED] 53 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_InputPos
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	ret

Mail_ParseContentType:: ; 0F:457A
	xor a, a
	ld [wMail_Work + $0F], a
	ld b, $07
	call Mail_FindHeader
	cp a, $02
	jr z, .l45BA
	and a, a
	jr nz, .l45B8
	ld a, h
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	push hl
	push de
	push bc
	ld hl, wMail_TextBuf1
	call Mail_CopyFromSram
	call Mail_ParseMultipartBoundary
	pop bc
	pop de
	pop hl
	and a, a
	jr z, .set_multipart_type_flag
	ld a, b
	and a, a
	jr nz, .l45BE
	ld a, h
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, MailStr_KwName
	call Mail_FindKeywordValue
.l45B8 ; 0F:45B8
	xor a, a
	ret

.l45BA ; 0F:45BA
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $82
	jr .l45C0
.l45BE ; 0F:45BE
	ld b, $81
.l45C0 ; 0F:45C0
	ld a, $02
	ret

.set_multipart_type_flag ; 0F:45C3
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $01
	ld [wMail_Work + $0F], a
	ret

Mail_ParseMultipartBoundary:: ; 0F:45C9
	ld hl, wMail_TextBuf1
	ld de, MailStr_KwMultipart
	ld c, $00
.scan_boundary_keyword_byte ; 0F:45D1
	ld a, [hli]
	and a, a
	jr z, .l45F3
	cp a, $20
	jr z, .scan_boundary_keyword_byte
	cp a, $0D
	jr z, .check_folded_boundary_line
	cp a, $61
	jr c, .compare_boundary_keyword_character
	cp a, $7B
	jr nc, .compare_boundary_keyword_character
	sub a, $20
.compare_boundary_keyword_character ; 0F:45E7
	ld b, a
	ld a, [de]
	and a, a
	jr z, .l4612
	inc de
	cp a, b
	jr z, .scan_boundary_keyword_byte
	dec de
	jr .scan_boundary_keyword_byte

.l45F3 ; 0F:45F3
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $00
	jr .l45F9

.l45F7 ; 0F:45F7
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 1 scenarios]
	ld b, $81
.l45F9 ; 0F:45F9
	ld a, $01
	ret
.check_folded_boundary_line ; 0F:45FC
	ld a, [hli]
	and a, a
	jr z, .l45F7
	cp a, $0A
	jr nz, .l45F7
	ld a, [hli]
	and a, a
	jr z, .l45F7
	cp a, $20
	jr z, .scan_boundary_keyword_byte

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	cp a, $09
	jr z, .scan_boundary_keyword_byte
	jr .l45F7

.l4612 ; 0F:4612
	; [CONFIRMED] 73 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, c
	and a, a
	jr nz, .skip_opening_boundary_quote
	ld c, $01
	ld de, $422C
	jr .scan_boundary_keyword_byte
.skip_opening_boundary_quote ; 0F:461D
	dec hl
	ld a, [hl]
	cp a, $22
	jr nz, .skip
	inc hl
.skip ; 0F:4624
	ld de, wMail_TextBuf2 + $01
	ld b, $00
	ld c, $40
.copy_boundary_until_quote_or_cr ; 0F:462B
	ld a, [hli]
	cp a, $22
	jr z, .store_boundary_length
	cp a, $0D
	jr z, .store_boundary_length
	ld [de], a
	inc de
	inc b
	dec c
	jr nz, .copy_boundary_until_quote_or_cr
.store_boundary_length ; 0F:463A
	ld a, b
	ld [wMail_TextBuf2], a
	xor a, a
	ret

Mail_MatchBoundary:: ; 0F:4640
	ld a, [wMail_InputBank]
	push af
	push de
	ld hl, wMail_TextBuf2 + $01
	ld a, [wMail_TextBuf2]
	ld b, a
.compare_boundary_bytes ; 0F:464C
	ld a, [de]
	ld c, a
	ld a, [hli]
	cp a, c
	jr nz, .restore_input_bank_after_mismatch
	inc e
	call z, Mail_MatchBoundary_NextPage
	dec b
	jr nz, .compare_boundary_bytes
	ld a, [de]
	cp a, $2D
	jr z, .check_closing_double_dash
	cp a, $0D
	jr nz, .restore_input_bank_after_mismatch
	xor a, a
	ld [wMail_Work + $10], a
.require_lf_after_boundary_cr ; 0F:4666
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .restore_input_bank_after_mismatch
	inc e
	call z, Mail_MatchBoundary_NextPage
	xor a, a
	pop hl
	pop hl
	ret
.check_closing_double_dash ; 0F:4677
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, [de]
	cp a, $2D
	jr nz, .restore_input_bank_after_mismatch
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, $01
	ld [wMail_Work + $10], a
	ld a, [de]
	cp a, $0D
	jr z, .require_lf_after_boundary_cr

.restore_input_bank_after_mismatch ; 0F:468E
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	pop de
	pop af
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld [wMail_Work + $10], a
	ld a, $01
	ret

Mail_MatchBoundary_NextPage:: ; 0F:469F
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_ParseSinglePart:: ; 0F:46A8
	call Mail_PartRec_EmitHeaderBlock
	and a, a
	jr nz, .l46E8
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Mail_SkipHeaderBlock
	and a, a
	jr nz, .propagate_mail_error_flag
	call Mail_PartRec_EmitLengthAndPart
	and a, a
	jr nz, .l46E8
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Mail_FindMessageEnd
	and a, a
	jr nz, .propagate_mail_error_flag
.loop ; 0F:46DE
	dec bc
	dec bc
	call Mail_PartRec_EmitLength
	and a, a
	jr nz, .l46E8
	xor a, a
	ret

.l46E8 ; 0F:46E8
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $83
	jr .l46FB
.propagate_mail_error_flag ; 0F:46EC
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l46F9
	ld a, $01
	ld [wMail_Work + $16], a
	jr .loop
.l46F9 ; 0F:46F9
	ld b, $81
.l46FB ; 0F:46FB
	ld a, $01
	ret

Mail_ParseMultipart:: ; 0F:46FE
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	call Mail_PartRec_EmitHeaderBlock
	and a, a
	jp nz, .l478E
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Mail_SkipHeaderBlock
	and a, a
	jp nz, .test_mail_error_flag
	call Mail_PartRec_EmitLength
	and a, a
	jp nz, .l478E
	ld a, $01
	ld [wMail_Work + $0E], a
	ld a, [wMail_InputBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $01
	ld [wMail_Work + $15], a
	call Mail_FindBoundary
	and a, a
	jp nz, .mark_boundary_error_and_check_part_count
.loop ; 0F:473B
	call Mail_FindPartName
	cp a, $01
	jr nz, .emit_part_and_find_next_boundary

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l4798
	ld a, $01
	ld [wMail_Work + $16], a

.emit_part_and_find_next_boundary ; 0F:474D
	; [CONFIRMED] 31 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	call Mail_PartRec_EmitPart
	and a, a
	jr nz, .l478E
	ld a, [wMail_Work + $16]
	and a, a
	jr nz, .l478A
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	call Mail_FindBoundary
	and a, a
	jr nz, .mark_boundary_error_and_check_part_count
	ld a, [wMail_Work + $0E]
	cp a, $03
	jr nz, .emit_part_length_and_increment_count
	dec bc
	dec bc
.emit_part_length_and_increment_count ; 0F:4777
	call Mail_PartRec_EmitLength
	and a, a
	jr nz, .l478E
	ld a, [wMail_Work + $0D]
	inc a
	ld [wMail_Work + $0D], a
	ld a, [wMail_Work + $16]
	and a, a
	jr z, .l479D

.l478A ; 0F:478A
	; [PROBABLE] 10 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld b, $01
	jr .l47CF
.l478E ; 0F:478E
	ld b, $83
	jr .l479A
.test_mail_error_flag ; 0F:4792
	ld a, [wMail_ErrorFlag]
	and a, a
	jr nz, .l479A
.l4798 ; 0F:4798
	ld b, $81
.l479A ; 0F:479A
	ld a, $01
	ret

.l479D ; 0F:479D
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [wMail_Work + $10]
	and a, a
	jr z, .loop
	jr .l47CF

	; [HYPOTHESIS] 10 insn (ld hl,$D003 ; ld a,[hli] ; ld [$D000],a ; ldh [$FF8C],a ; ld [$4000],a ;
	; call $4A7E ; and a ; jr z,$47CF ; xor a ; ld [$D016],a) flowing straight into the PROBABLE
	; code at 47BB; call target 4A7E is called elsewhere (0F:46D8) and the jr target is a valid
	; start; JR47A3->47CF bypasses47A5 sequentially; independent entry remains unproved;
	; preceding termination alone does not imply a missing branch/jump-table caller
	ld hl, wMail_Work + $03
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Mail_FindMessageEnd
	and a, a
	jr z, .l47CF
	xor a, a
	ld [wMail_Work + $16], a

.mark_boundary_error_and_check_part_count ; 0F:47BB
	; [PROBABLE] 722 insn(s) reached by static flow only; seeds: mobile x722; min discovery hops 0;
	; entered by jpcc from 0F:4738 (PROBABLE code) | 9 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 47BB-4C59 by apply_coverage --split
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l4798
	ld a, $01
	ld [wMail_Work + $16], a
	ld a, [wMail_Work + $0D]
	cp a, $01
	jr nz, .emit_part_length_and_increment_count
	ld b, $01

.l47CF ; 0F:47CF
	; [CONFIRMED] 37 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 1 scenarios]
	xor a, a
	ret

Mail_FindBoundary:: ; 0F:47D1
	ld bc, $0000
	ld a, [wMail_Work + $15]
	and a, a
	jr nz, .check_double_dash_and_match_boundary
.scan_to_boundary_line_end ; 0F:47DA
	ld a, [de]
	and a, a
	jr z, .mark_error_on_nul
	inc e
	call z, Mail_FindBoundary_NextPage
	inc bc
	cp a, $0D
	jr nz, .scan_to_boundary_line_end
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
.classify_line_continuation ; 0F:47EC
	inc bc
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $20
	jr z, .set_continuation_marker
	cp a, $09
	jr z, .set_continuation_marker
	cp a, $0D
	jr nz, .clear_continuation_marker
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, h
	and a, a
	jr z, .check_double_dash_and_match_boundary

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	dec bc

.check_double_dash_and_match_boundary ; 0F:4810
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [de]
	cp a, $2D
	jr nz, .scan_to_boundary_line_end
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $2D
	jr nz, .scan_to_boundary_line_end
	inc e
	call z, Mail_FindBoundary_NextPage
	push bc
	call Mail_MatchBoundary
	pop bc
	and a, a
	jr nz, .scan_to_boundary_line_end
	ret

.set_continuation_marker ; 0F:482B
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld h, $01
	jr .classify_line_continuation

.clear_continuation_marker ; 0F:482F
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, $00
	jr .check_double_dash_and_match_boundary

.mark_error_on_nul ; 0F:4833
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	and a, a
	jr nz, .skip
	ld a, $01
	ld [wMail_ErrorFlag], a
.skip ; 0F:483B
	ld a, $01
	ret

Mail_FindBoundary_NextPage:: ; 0F:483E
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 3 scenarios]
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_FindPartName:: ; 0F:4847
	ld a, [wMail_InputBank]
	push af
	push de
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Mail_SkipHeaderBlock
	and a, a
	jr nz, .restore_input_bank_variable_and_return_one
	pop de
	pop af
	ld [wMail_InputBank], a
	ld hl, MailStr_KwName
	call Mail_FindKeywordValue
	ret

.restore_input_bank_variable_and_return_one ; 0F:4863
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	pop de
	pop af
	ld [wMail_InputBank], a
	ld a, $01
	ret

Mail_PartRec_EmitHeaderBlock:: ; 0F:486B

	; [CONFIRMED] 51 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, $02
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitHeaderBlock_NextPage
	ld a, $01
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitHeaderBlock_NextPage
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitHeaderBlock_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitHeaderBlock_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitHeaderBlock_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld d, $05
.loop ; 0F:48AD
	dec bc
	ld a, b
	or a, c
	jr z, .l48BA
	dec d
	jr nz, .loop
	ld [hl], b
	dec hl
	ld [hl], c
	xor a, a
	ret

.l48BA ; 0F:48BA
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld a, $01
	ret

Mail_PartRec_EmitHeaderBlock_NextPage:: ; 0F:48BD

	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitLengthAndPart:: ; 0F:48C6

	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, c
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, b
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [wMail_Work + $0E]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	cp a, $03
	jr nz, .emit_input_position_and_choose_record_size

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld hl, wMail_KeywordValue
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage

.emit_input_position_and_choose_record_size ; 0F:4908
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLengthAndPart_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wMail_Work + $0E]
	cp a, $03
	jr z, .select_ten_byte_record_charge
	ld d, $06
	jr .subtract_record_size_from_capacity

.select_ten_byte_record_charge ; 0F:4936
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld d, $0A

.subtract_record_size_from_capacity ; 0F:4938
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	dec bc
	ld a, b
	or a, c
	jr z, .l4945
	dec d
	jr nz, .subtract_record_size_from_capacity
	ld [hl], b
	dec hl
	ld [hl], c
	xor a, a
	ret

.l4945 ; 0F:4945
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld a, $01
	ret

Mail_PartRec_EmitLengthAndPart_NextPage:: ; 0F:4948

	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitPart:: ; 0F:4951

	; [CONFIRMED] 71 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [wMail_Work + $0E]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	cp a, $03
	jr nz, .emit_input_position_and_choose_record_size
	ld hl, wMail_KeywordValue
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
.emit_input_position_and_choose_record_size ; 0F:4987
	ld hl, wMail_InputPos
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitPart_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wMail_Work + $0E]
	cp a, $03
	jr z, .select_eight_byte_record_charge
	ld d, $04
	jr .subtract_record_size_from_capacity
.select_eight_byte_record_charge ; 0F:49B5
	ld d, $08
.subtract_record_size_from_capacity ; 0F:49B7
	dec bc
	ld a, b
	or a, c
	jr z, .l49C4
	dec d
	jr nz, .subtract_record_size_from_capacity
	ld [hl], b
	dec hl
	ld [hl], c
	xor a, a
	ret

.l49C4 ; 0F:49C4
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld a, $01
	ret

Mail_PartRec_EmitPart_NextPage:: ; 0F:49C7

	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitLength:: ; 0F:49D0

	; [CONFIRMED] 42 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hl]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	push de
	ld hl, wMail_OutputStream + $03
	ld e, [hl]
	inc hl
	ld d, [hl]
	dec de
	ld a, d
	or a, e
	jr z, .l4A0F
	dec de
	ld a, d
	or a, e
	jr z, .l4A0F
	ld [hl], d
	dec hl
	ld [hl], e
	ld hl, wMail_OutputStream + $01
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, c
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLength_NextPage
	ld a, b
	ld [de], a
	inc e
	call z, Mail_PartRec_EmitLength_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	pop de
	xor a, a
	ret

.l4A0F ; 0F:4A0F
	; [PROBABLE] 8 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	pop de
	ld a, $01
	ret

Mail_PartRec_EmitLength_NextPage:: ; 0F:4A13

	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_SkipHeaderBlock:: ; 0F:4A1C
	; [CONFIRMED] 33 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	ld bc, $0000
	ld h, b
.scan_header_line_to_cr ; 0F:4A20
	inc bc
	ld a, [de]
	and a, a
	jr z, .mark_error_on_nul
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	cp a, $0D
	jr nz, .scan_header_line_to_cr
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
.check_folded_line_or_header_end ; 0F:4A32
	inc bc
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, [de]
	cp a, $20
	jr z, .set_continuation_marker
	cp a, $09
	jr z, .set_continuation_marker
	cp a, $0D
	jr nz, .clear_continuation_marker
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, h
	and a, a
	jr z, .save_input_position_after_headers

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	dec bc

.save_input_position_after_headers ; 0F:4A56
	; [CONFIRMED] 12 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 1 scenarios]
	ld hl, wMail_InputPos
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	xor a, a
	ret
.set_continuation_marker ; 0F:4A62
	ld h, $01
	jr .check_folded_line_or_header_end
.clear_continuation_marker ; 0F:4A66
	ld h, $00
	jr .scan_header_line_to_cr

.mark_error_on_nul ; 0F:4A6A
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	and a, a
	jr nz, .l4A72
	ld a, $01
	ld [wMail_ErrorFlag], a
.l4A72 ; 0F:4A72
	ld a, $01
	ret

Mail_SkipHeaderBlock_NextPage:: ; 0F:4A75
	; [CONFIRMED] 43 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_FindMessageEnd:: ; 0F:4A7E
	ld bc, $0000
.loop ; 0F:4A81
	inc bc
	ld a, [de]
	and a, a
	jr z, .mark_error_on_nul
	inc e
	call z, Mail_FindMessageEnd_NextPage
	cp a, $0D
	jr nz, .loop
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
	inc e
	call z, Mail_FindMessageEnd_NextPage
	inc bc
	ld a, [de]
	cp a, $2E
	jr nz, .loop
	inc e
	call z, Mail_FindMessageEnd_NextPage
	ld a, [de]
	cp a, $0D
	jr nz, .loop
	inc e
	call z, Mail_FindMessageEnd_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .mark_error_on_nul
	inc e
	call z, Mail_FindMessageEnd_NextPage
	ld hl, wMail_InputPos
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	xor a, a
	ret

.mark_error_on_nul ; 0F:4ABF
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	and a, a
	jr nz, .skip
	ld a, $01
	ld [wMail_ErrorFlag], a
.skip ; 0F:4AC7
	ld a, $01
	ret

Mail_FindMessageEnd_NextPage:: ; 0F:4ACA
	; [CONFIRMED] 51 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_FindKeywordValue:: ; 0F:4AD3
	push hl
	push bc
.read_and_uppercase_keyword_byte ; 0F:4AD5
	ld a, [hl]
	ld b, a
	ld a, [de]
	inc e
	call z, Mail_FindKeywordValue_NextPage
	cp a, $61
	jr c, .compare_keyword_start
	cp a, $7B
	jr nc, .compare_keyword_start
	sub a, $20
.compare_keyword_start ; 0F:4AE6
	cp a, b
	jr z, .advance_past_matched_first_character
	pop bc
	dec bc
	push bc
	ld a, b
	or a, c
	jr nz, .read_and_uppercase_keyword_byte
.mark_value_type2_and_return ; 0F:4AF0
	ld a, $02
	ld [wMail_Work + $0E], a
	pop bc
	pop hl
	ret
.advance_past_matched_first_character ; 0F:4AF8
	inc hl
.compare_remaining_keyword ; 0F:4AF9
	ld a, [hli]
	and a, a
	jr z, .skip_opening_value_quote
	ld b, a
	ld a, [de]
	inc e
	call z, Mail_FindKeywordValue_NextPage
	cp a, $61
	jr c, .compare_folded_keyword_character
	cp a, $7B
	jr nc, .compare_folded_keyword_character
	sub a, $20
.compare_folded_keyword_character ; 0F:4B0D
	cp a, b
	jr nz, .retry_keyword_from_saved_arguments
	pop bc
	dec bc
	push bc
	ld a, b
	or a, c
	jr nz, .compare_remaining_keyword

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	jr .mark_value_type2_and_return

.retry_keyword_from_saved_arguments ; 0F:4B19
	; [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 2 scenarios]
	pop bc
	pop hl
	jr Mail_FindKeywordValue
.skip_opening_value_quote ; 0F:4B1D
	ld b, $00
	ld c, $40
	ld a, [de]
	cp a, $22
	jr nz, .save_keyword_value_position
	inc e
	call z, Mail_FindKeywordValue_NextPage
.save_keyword_value_position ; 0F:4B2A
	ld hl, wMail_KeywordValue
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
.measure_value_until_quote_or_cr ; 0F:4B35
	ld a, [de]
	cp a, $22
	jr z, .save_value_length_and_type3
	cp a, $0D
	jr z, .save_value_length_and_type3
	inc e
	call z, Mail_FindKeywordValue_NextPage
	inc b
	dec c
	jr nz, .measure_value_until_quote_or_cr
.save_value_length_and_type3 ; 0F:4B46
	ld [hl], b
	pop bc
	pop hl
	ld a, $03
	ld [wMail_Work + $0E], a
	xor a, a
	ret

Mail_FindKeywordValue_NextPage:: ; 0F:4B50
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_IndexHeaders:: ; 0F:4B59
	; [PROBABLE] 67 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	call Mail_LoadArgs
	ld b, $00
	ld hl, wMail_InputPos
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1
.find_and_record_header ; 0F:4B69
	push de
	push bc
	push hl
	call Mail_FindHeader
	cp a, $02
	jr z, .l4BB6
	and a, a
	jr nz, .zero_missing_header_record
	ld a, h
	pop hl
	inc hl
	ld [hld], a
	ld a, $01
	ld [hli], a
	inc hl
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
	ld [hl], c
	inc hl
	ld [hl], b
	inc hl
.advance_header_index ; 0F:4B86
	pop bc
	pop de
	inc b
	ld a, b
	cp a, $0D
	jr z, .copy_header_index_to_sram
	jr .find_and_record_header
.zero_missing_header_record ; 0F:4B90
	pop hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	jr .advance_header_index
.copy_header_index_to_sram ; 0F:4B9A
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld bc, $004E
	ld hl, wMail_TextBuf1
	call Mail_CopyToSram
	jp Mail_Return
.l4BB6 ; 0F:4BB6
	ld a, $01
	pop bc
	pop bc
	pop bc
	ld b, $82
	jp Mail_Return

Mail_GetDecodedHeader:: ; 0F:4BC0
	; [CONFIRMED] 41 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 7 scenarios]
	ld h, d
	ld l, e
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	inc hl
	push hl
	call Mail_FindHeader
	cp a, $02
	jr z, .l4C07
	and a, a
	jr nz, .l4C03
	ld a, h
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Mail_UnfoldHeader
	ld hl, wMail_TextBuf1
	call Mail_DecodeEncodedWords
	ld a, b
	or a, c
	jr z, .l4C03
	pop hl
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, wMail_TextBuf1
	push bc
	call Mail_CopyToSram
	pop hl
	jp Mail_Return
.l4C03 ; 0F:4C03
	ld b, $84
	jr .l4C09

.l4C07 ; 0F:4C07
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld b, $82

.l4C09 ; 0F:4C09
	; [CONFIRMED] 46 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $01
	pop hl
	jp Mail_Return

Mail_UnfoldHeader:: ; 0F:4C0F
	ld hl, wMail_TextBuf1
	push bc
	call Mail_CopyFromSram
	pop bc
	ld hl, wMail_TextBuf1
	ld d, h
	ld e, l
.copy_header_byte ; 0F:4C1C
	ld a, [hli]
	cp a, $0D
	jr z, .check_crlf_continuation
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .copy_header_byte
.terminate_and_measure ; 0F:4C28
	xor a, a
	ld [de], a
	ld hl, wMail_TextBuf1
	ld bc, $0000
.measure_header_loop ; 0F:4C30
	ld a, [hli]
	inc bc
	and a, a
	jr nz, .measure_header_loop
	dec bc
	xor a, a
	ret
.check_crlf_continuation ; 0F:4C38
	dec bc
	ld a, b
	or a, c
	jr z, .terminate_and_measure
	ld a, [hli]
	cp a, $0A
	jr nz, .copy_header_byte
	dec bc
	ld a, b
	or a, c
	jr z, .terminate_and_measure
	ld a, [hli]
	cp a, $20
	jr z, .consume_continuation_whitespace
	cp a, $09
	jr z, .consume_continuation_whitespace

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	jr .terminate_and_measure

.consume_continuation_whitespace ; 0F:4C52
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 1 scenarios]
	dec bc
	ld a, b
	or a, c
	jr z, .terminate_and_measure
	jr .copy_header_byte

	; [HYPOTHESIS] complete small function (push bc ; ld bc,$D000 ; call $5D95 ; pop bc ; ret)
	; between the code regions 4C57 and 4C62; call target 5D95 is a code start of this bank; no
	; caller/pointer found, entry unproven
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_DecodeEncodedWords:: ; 0F:4C62
	; [CONFIRMED] 137 insn(s) reached by static flow only; seeds: mobile x137; min discovery hops 0;
	; entered by call from 0F:4BE4 (PROBABLE code) | 85 insn(s) executed; cut out of the PROBABLE
	; region 4C62-4D35 by apply_coverage --split [executed in 1 scenarios]
	ld de, wMail_TextBuf2
	push hl
.copy_and_check_encoded_word_prefix ; 0F:4C66
	ld a, [hli]
	ld [de], a
	inc de
	and a, a
	jr z, .prepare_copy_back
	cp a, $3D
	jr nz, .copy_and_check_encoded_word_prefix
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $3F
	jr nz, .copy_and_check_encoded_word_prefix
	dec de
	dec de
.scan_charset_separator ; 0F:4C79
	ld a, [hli]
	cp a, $3F
	jr nz, .scan_charset_separator
	ld a, [hli]
	cp a, $42
	jr nz, .write_literal_prefix
	inc hl
	ld bc, $0000
	push hl
.count_encoded_payload ; 0F:4C88
	inc bc
	ld a, [hli]
	cp a, $3F
	jr nz, .count_encoded_payload
	inc bc
	ld a, [hli]
	cp a, $3D
	jr nz, .count_encoded_payload
	dec bc
	dec bc
	ld a, l
	ld [wMail_Work + $03], a
	ld a, h
	ld [wMail_Work + $04], a
	pop hl
	push de
	call Mail_Base64Decode
	pop de
	ld h, d
	ld l, e
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
.copy_decoded_bytes ; 0F:4CAA
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .copy_decoded_bytes
	ld a, [wMail_Work + $03]
	ld l, a
	ld a, [wMail_Work + $04]
	ld h, a
	jr .copy_and_check_encoded_word_prefix
.write_literal_prefix ; 0F:4CBC
	ld a, $3D
	ld [de], a
	inc de
	ld a, $3F
	ld [de], a
	inc de
.copy_remaining_bytes ; 0F:4CC4
	ld a, [hli]
	ld [de], a
	inc de
	and a, a
	jr nz, .copy_remaining_bytes
.prepare_copy_back ; 0F:4CCA
	ld [de], a
	pop hl
	ld de, wMail_TextBuf2
	ld bc, $0000
.copy_back_loop ; 0F:4CD2
	inc bc
	ld a, [de]
	ld [hli], a
	inc de
	and a, a
	jr z, .return_output_length
	jr .copy_back_loop
.return_output_length ; 0F:4CDB
	dec bc
	ret

Mail_GetAddressList:: ; 0F:4CDD
	; [PROBABLE] 52 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C62-4D35 by apply_coverage --split
	ld h, d
	ld l, e
	ld b, [hl]
	inc hl
	ld c, [hl]
	inc hl
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	push hl
	call Mail_FindHeader
	and a, a
	jr nz, .l4D37
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	ld a, h
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wMail_TextBuf1
	call Mail_StripCommentsAndSpaces
	ld hl, wMail_TextBuf1
	call Mail_ExtractAddresses
	pop hl
	push hl
	inc hl
	inc hl
	inc hl
	inc hl
	ld a, [hld]
	cp a, b
	jr c, .l4D31
	jr z, .l4D2D
.loop ; 0F:4D15
	pop hl
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, wMail_TextBuf2
	call Mail_CopyToSram
	xor a, a
	jp Mail_Return
.l4D2D ; 0F:4D2D
	ld a, [hli]
	cp a, c
	jr nc, .loop
.l4D31 ; 0F:4D31
	ld b, $83
	jr .l4D37

	; [HYPOTHESIS] ld b,$82 : third variant of the result setter at 0F:4D31 (ld b,$83 ; jr $4D37)
	; falling into 4D37 (pop hl ; ld a,1 ; jp $4260); the branch that targets 4D35 was not found in
	; the decoded code
	ld b, $82

.l4D37 ; 0F:4D37
	; [PROBABLE] 2592 insn(s) reached by static flow only; seeds: mobile x2592; min discovery hops
	; 0; entered by jrcc from 0F:4CEC (PROBABLE code) | 179 insn(s) never executed in the traced
	; runs; cut out of the PROBABLE region 4D37-5DAE by apply_coverage --split
	pop hl
	ld a, $01
	jp Mail_Return

Mail_StripCommentsAndSpaces:: ; 0F:4D3D
	ld a, [wMail_Work + $04]
	and a, a
	jr nz, .check_closing_delimiter
	ld a, [de]
	cp a, $28
	jr z, .begin_skipped_span
	cp a, $22
	jr z, .begin_skipped_span
	jr .copy_unless_space
.check_closing_delimiter ; 0F:4D4E
	ld a, [de]
	cp a, $29
	jr z, .check_saved_paren_opener
	cp a, $22
	jr z, .check_saved_quote_opener
	jr .advance_input
.begin_skipped_span ; 0F:4D59
	ld [wMail_Work + $03], a
	ld a, $01
	ld [wMail_Work + $04], a
	jr .advance_input
.check_saved_paren_opener ; 0F:4D63
	ld a, [wMail_Work + $03]
	cp a, $28
	jr nz, .advance_input
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	jr .advance_input
.check_saved_quote_opener ; 0F:4D73
	ld a, [wMail_Work + $03]
	cp a, $22
	jr nz, .advance_input
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	jr .advance_input
.copy_unless_space ; 0F:4D83
	cp a, $20
	jr z, .advance_input
	ld [hli], a
.advance_input ; 0F:4D88
	dec bc
	ld a, b
	or a, c
	jr z, .terminate_output
	inc e
	jr nz, Mail_StripCommentsAndSpaces
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	jr Mail_StripCommentsAndSpaces
.terminate_output ; 0F:4D9A
	xor a, a
	ld [hli], a
	ret

Mail_ExtractAddresses:: ; 0F:4D9D
	ld de, wMail_TextBuf2
	xor a, a
	ld [de], a
.scan_for_at_sign ; 0F:4DA2
	ld a, [hli]
	call Mail_SkipJisEscape
	and a, a
	jr z, .terminate_address_list_and_measure_size
	cp a, $40
	jr nz, .scan_for_at_sign
	dec hl
.scan_back_to_address_start ; 0F:4DAE
	dec hl
	ld a, [hl]
	call Mail_ClassifyAddressChar
	and a, a
	jr z, .scan_back_to_address_start
	inc hl
	push hl
	ld b, $00
.count_address_characters ; 0F:4DBA
	ld a, [hli]
	cp a, $40
	jr z, .count_at_sign_and_continue
	call Mail_ClassifyAddressChar
	and a, a
	jr nz, .insert_comma_before_next_address
.count_at_sign_and_continue ; 0F:4DC5
	inc b
	jr .count_address_characters
.insert_comma_before_next_address ; 0F:4DC8
	pop hl
	ld a, [wMail_TextBuf2]
	and a, a
	jr z, .increment_address_count
	ld a, $2C
	inc de
	ld [de], a
	ld a, [wMail_TextBuf2]
.increment_address_count ; 0F:4DD6
	inc a
	ld [wMail_TextBuf2], a
.copy_counted_address ; 0F:4DDA
	inc de
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .copy_counted_address
	jr .scan_for_at_sign
.terminate_address_list_and_measure_size ; 0F:4DE2
	inc de
	xor a, a
	ld [de], a
	ld a, $D6
	cpl
	ld h, a
	ld a, $25
	cpl
	ld l, a
	inc hl
	add hl, de
	ld b, h
	ld c, l
	inc bc
	inc bc
	xor a, a
	ret

Mail_SkipJisEscape:: ; 0F:4DF5
	cp a, $1B
	ret nz
	ld a, [hli]
	and a, a
	jr z, .return_zero
	cp a, $24
	jr nz, .rewind_input_and_return
	ld a, [hli]
	and a, a
	jr z, .return_zero
	cp a, $42
	jr z, .scan_jis_exit_escape
	cp a, $40
	jr z, .scan_jis_exit_escape
	dec hl
.rewind_input_and_return ; 0F:4E0D
	dec hl
	ret
.scan_jis_exit_escape ; 0F:4E0F
	ld a, [hli]
	and a, a
	jr z, .return_zero
	cp a, $1B
	jr nz, .scan_jis_exit_escape
	ld a, [hli]
	and a, a
	jr z, .return_zero
	cp a, $28
	jr nz, .scan_jis_exit_escape
	ld a, [hli]
	and a, a
	jr z, .return_zero
	cp a, $42
	jr z, .read_byte_after_exit_escape
	cp a, $4A
	jr z, .read_byte_after_exit_escape
	jr .scan_jis_exit_escape
.read_byte_after_exit_escape ; 0F:4E2D
	ld a, [hli]
	ret
.return_zero ; 0F:4E2F
	xor a, a
	ret

Mail_ClassifyAddressChar:: ; 0F:4E31
	cp a, $30
	jr c, .check_space_dash_dot_underscore
	cp a, $40
	jr c, .check_angle_brackets
	cp a, $41
	jr c, .check_space_dash_dot_underscore
	cp a, $5B
	jr c, .check_angle_brackets
	cp a, $61
	jr c, .check_space_dash_dot_underscore
	cp a, $7B
	jr c, .check_angle_brackets
.check_space_dash_dot_underscore ; 0F:4E49
	cp a, $20
	jr z, .check_angle_brackets
	cp a, $2D
	jr z, .check_angle_brackets
	cp a, $2E
	jr z, .check_angle_brackets
	cp a, $5F
	jr z, .check_angle_brackets
.loop ; 0F:4E59
	ld a, $01
	ret
.check_angle_brackets ; 0F:4E5C
	cp a, $3C
	jr z, .loop
	cp a, $3E
	jr z, .loop
	xor a, a
	ret

Mail_ComposeNext:: ; 0F:4E66
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, c
	and a, a
	jr nz, .reset_compose_state_and_initialize

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, [wMail_ComposeState]
	and a, a
	jp z, Mail_Return
	jr .compose_step_and_append_crlf

.reset_compose_state_and_initialize ; 0F:4E73
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	xor a, a
	ld [wMail_ComposeState], a
	call Mail_ComposeInit
.compose_step_and_append_crlf ; 0F:4E7A
	call Mail_ComposeStep
	cp a, $FF
	jp z, Mail_Return
	and a, a
	jr nz, .l4E9D
	call Mail_EmitCrLf
	and a, a
	jr nz, .l4E9D
	ld hl, wMail_OutputStream + $03
	ld a, [hli]
	cpl
	ld e, a
	ld a, [hli]
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	xor a, a
	jp Mail_Return

.l4E9D ; 0F:4E9D
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ld b, $83
	jp Mail_Return

Mail_EmitCrLf:: ; 0F:4EA4
	; [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, $0D
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l4EDF
	inc e
	call z, Mail_EmitCrLf_NextPage
	ld a, $0A
	ld [de], a
	dec bc
	inc e
	call z, Mail_EmitCrLf_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	ld [wMail_ComposeState], a
	ret

.l4EDF ; 0F:4EDF
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ld b, $83
	ret

Mail_EmitCrLf_NextPage:: ; 0F:4EE4
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_ComposeInit:: ; 0F:4EED
	ld hl, wMail_Work + $03
	ld a, b
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hli], a
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld c, a
	ld [hli], a
	inc de
	ld a, [de]
	ld b, a
	ld [hli], a
	inc de
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	ret

Mail_ComposeStep:: ; 0F:4F0E
	call Mail_FetchComposeItem
	and a, a
	jr nz, .emit_header_and_check_next_item
	ld a, [wMail_Work + $03]
	cp a, $06
	jr c, .l4F25
	cp a, $0C
	jr z, .l4F27
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l4F27
.l4F25 ; 0F:4F25
	xor a, a
	ret

.l4F27 ; 0F:4F27
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ret

.emit_header_and_check_next_item ; 0F:4F2A
	; [CONFIRMED] 10 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l4F27
	ld hl, wMail_ItemListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld a, [de]
	and a, a
	jr z, .l4F25

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $FF
	ret

Mail_FetchComposeItem:: ; 0F:4F3D
	; [CONFIRMED] 54 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_ItemListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld a, [de]
	and a, a
	jr z, .done
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, $01
	ret
.done ; 0F:4F5C
	ret

Mail_EmitHeaderField:: ; 0F:4F5D
	ld a, [wMail_ComposeState]
	and a, a
	jr nz, .dispatch_header_field_type
	ld a, [wMail_Work + $03]
	cp a, $11
	jr z, .copy_item_from_sram_and_emit_string
	add a, a
	ld e, a
	ld d, $00
	ld hl, Mail_HeaderStringTable
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call Mail_EmitString
	and a, a
	jr nz, .l4FEB
	ld a, $01
	ld [wMail_ComposeState], a
.dispatch_header_field_type ; 0F:4F80
	ld a, [wMail_Work + $03]
	cp a, $05
	jr c, .emit_address_list_items
	jr z, .emit_single_address_item
	cp a, $08
	jr c, .l4FA9
	jr z, .emit_game_code_value
	cp a, $0B
	jr c, .l4FA9

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	jr z, .emit_boundary_string_and_suffix
	cp a, $0C
	jr z, .emit_buffered_item_and_suffix
	cp a, $0D
	jr z, .l4FA9
	cp a, $10
	jr c, .emit_boundary_for_type0e_or0f
	jr z, .l4FA9
	cp a, $12
	jr c, .l4FA9
	jr .l4FEB

.l4FA9 ; 0F:4FA9
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	xor a, a
	ret

.copy_item_from_sram_and_emit_string ; 0F:4FAB
	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld hl, wMail_ComposeItem
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1
	call Mail_CopyFromSram
	ld hl, wMail_TextBuf1
	call Mail_EmitString
	and a, a
	jr nz, .l4FEB
	jr .l5022

.emit_address_list_items ; 0F:4FCD
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_EmitAddressListItem
	and a, a
	jr nz, .l4FEB
	ld a, [wMail_Work + $04]
	dec a
	ld [wMail_Work + $04], a
	and a, a
	jr z, .restore_item_count

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	call Mail_FetchComposeItem
	and a, a
	jr nz, .emit_address_list_items

.restore_item_count ; 0F:4FE3
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [wMail_Work + $05]
	ld [wMail_Work + $04], a
	jr .l5022

.l4FEB ; 0F:4FEB
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ld b, $83
	ret

.emit_single_address_item ; 0F:4FF0
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_EmitAddressListItem
	and a, a
	jr nz, .l4FEB
	jr .l5022
.emit_game_code_value ; 0F:4FF8
	call Mail_EmitGameCodeValue
	and a, a
	jr nz, .l4FEB
	jr .l5022

.emit_boundary_string_and_suffix ; 0F:5000
	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld hl, MailStr_Boundary
	call Mail_EmitStringAndSuffix
	and a, a
	jr nz, .l4FEB
	jr .l5022
.emit_buffered_item_and_suffix ; 0F:500B
	call Mail_CopyItemToBuffer
	ld hl, wMail_TextBuf1
	call Mail_EmitStringAndSuffix
	and a, a
	jr nz, .l4FEB
	jr .l5022
.emit_boundary_for_type0e_or0f ; 0F:5019
	ld hl, MailStr_Boundary
	call Mail_EmitStringAndSuffix
	and a, a
	jr nz, .l4FEB

.l5022 ; 0F:5022
	; [CONFIRMED] 40 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	xor a, a
	ret

Mail_EmitString:: ; 0F:5024
	push hl
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
.loop ; 0F:503A
	ld a, [hli]
	and a, a
	jr z, .save_output_cursor_and_capacity
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l505A
	inc e
	call z, Mail_EmitString_NextPage
	jr .loop
.save_output_cursor_and_capacity ; 0F:504A
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	ret

.l505A ; 0F:505A
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ret

Mail_EmitString_NextPage:: ; 0F:505D
	; [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 4 scenarios]
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_EmitAddressListItem:: ; 0F:5066
	ld hl, wMail_ComposeItem
	ld a, [hli]
	and a, a
	jr z, .store_compose_state
	ld c, a
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld b, $00
	ld hl, wMail_TextBuf1
	ld a, [wMail_ComposeState]
	cp a, $01
	jr z, .encode_and_emit_address_item

	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $02
	jr z, .append_comma
	cp a, $03
	jr nz, .done
	ld a, $2C
	ld [hli], a
	ld a, $0D
	ld [hli], a
	ld a, $0A
	ld [hli], a
	ld a, $09
	ld [hli], a
	jr .encode_and_emit_address_item
.append_comma ; 0F:509C
	ld a, $2C
	ld [hli], a

.encode_and_emit_address_item ; 0F:509F
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_CopyFromSram
	call Mail_EncodeHeaderWords
	call Mail_EmitBufferToOutput
	ld a, [wMail_ComposeState]
	inc a
	cp a, $04
	jr nz, .store_compose_state

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $02

.store_compose_state ; 0F:50B2
	; [CONFIRMED] 24 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld [wMail_ComposeState], a
	xor a, a
.done ; 0F:50B6
	ret

Mail_EncodeHeaderWords:: ; 0F:50B7
	ld hl, wMail_TextBuf1
	ld de, wMail_TextBuf2
	ld b, $00
.copy_until_jis_escape ; 0F:50BF
	ld c, $00
	ld a, [hli]
	cp a, $1B
	jr z, .check_jis_double_byte_escape
	ld [de], a
	inc de
	and a, a
	jr z, .terminate_encoded_header
	jr .copy_until_jis_escape
.check_jis_double_byte_escape ; 0F:50CD
	inc c
	ld a, [hl]
	cp a, $24
	jr nz, .copy_until_jis_escape
	inc hl
	inc c
	ld a, [hl]
	cp a, $42
	jr z, .l50E0

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $40
	jr z, .l50E0
	jr .copy_until_jis_escape

.l50E0 ; 0F:50E0
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	push hl
.scan_to_jis_single_byte_escape ; 0F:50E1
	inc c
	ld a, [hli]
	and a, a
	jr z, .terminate_encoded_header
	cp a, $1B
	jr nz, .scan_to_jis_single_byte_escape
	inc c
	ld a, [hli]
	cp a, $28
	jr nz, .scan_to_jis_single_byte_escape
	inc c
	ld a, [hli]
	cp a, $42
	jr z, .save_resume_pointer_and_select_encoded_prefix

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $4A
	jr z, .save_resume_pointer_and_select_encoded_prefix
	jr .scan_to_jis_single_byte_escape

.save_resume_pointer_and_select_encoded_prefix ; 0F:50FC
	; [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, l
	ld [wMail_Work + $13], a
	ld a, h
	ld [wMail_Work + $14], a
	ld hl, MailStr_EncodedWordPrefix
.copy_encoded_word_prefix ; 0F:5107
	ld a, [hli]
	and a, a
	jr z, .encode_jis_span_as_base64
	ld [de], a
	inc de
	jr .copy_encoded_word_prefix
.encode_jis_span_as_base64 ; 0F:510F
	pop hl
	dec hl
	dec hl
	push de
	call Mail_Base64Encode
	pop de
	ld h, d
	ld l, e
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
.copy_encoded_bytes_and_append_suffix ; 0F:511D
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .copy_encoded_bytes_and_append_suffix
	ld a, $3F
	ld [de], a
	inc de
	ld a, $3D
	ld [de], a
	inc de
	ld a, [wMail_Work + $13]
	ld l, a
	ld a, [wMail_Work + $14]
	ld h, a
	jr .copy_until_jis_escape
.terminate_encoded_header ; 0F:5137
	xor a, a
	ld [de], a
	ret

Mail_EmitBufferToOutput:: ; 0F:513A
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld hl, wMail_TextBuf2
.loop ; 0F:5151
	ld a, [hli]
	and a, a
	jr z, .save_output_cursor_and_capacity
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5171
	inc e
	call z, Mail_EmitBufferToOutput_NextPage
	jr .loop
.save_output_cursor_and_capacity ; 0F:5161
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	ret

.l5171 ; 0F:5171
	; [PROBABLE] 7 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ret

Mail_EmitBufferToOutput_NextPage:: ; 0F:5174
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_EmitGameCodeValue:: ; 0F:517D
	; [CONFIRMED] 62 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld hl, $013F
	ld a, [hli]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, [hli]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, [hli]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, [hli]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, $2D
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, [$014C]
	ld h, a
	and a, $F0
	swap a
	cp a, $0A
	jr nc, .convert_high_hex_letter
	add a, $30
	jr .emit_high_hex_digit

.convert_high_hex_letter ; 0F:51DC
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	add a, $37

.emit_high_hex_digit ; 0F:51DE
	; [CONFIRMED] 13 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld a, h
	and a, $0F
	cp a, $0A
	jr nc, .convert_low_hex_letter
	add a, $30
	jr .emit_low_hex_digit_and_save_cursor

.l51F3 ; 0F:51F3
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ret
.convert_low_hex_letter ; 0F:51F6
	add a, $37

.emit_low_hex_digit_and_save_cursor ; 0F:51F8
	; [CONFIRMED] 19 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l51F3
	inc e
	call z, Mail_EmitGameCodeValue_NextPage
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	ret

Mail_EmitGameCodeValue_NextPage:: ; 0F:5212
	; [PROBABLE] 1043 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_EmitStringAndSuffix:: ; 0F:521B
	push hl
	ld hl, wMail_OutputBankVar
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	pop hl
.emit_string_bytes ; 0F:5231
	ld a, [hli]
	and a, a
	jr z, .dispatch_suffix_by_field_type
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	jr .emit_string_bytes
.dispatch_suffix_by_field_type ; 0F:5241
	ld a, [wMail_Work + $03]
	cp a, $0B
	jr z, .emit_closing_quote
	cp a, $0C
	jr z, .emit_closing_quote
	cp a, $0E
	jr z, .save_output_cursor_and_capacity
	cp a, $0F
	jr z, .select_two_dash_suffix
	jr .l5266
.save_output_cursor_and_capacity ; 0F:5256
	ld hl, wMail_OutputBankVar
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, d
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	xor a, a
	ret
.l5266 ; 0F:5266
	ld a, $01
	ret
.select_two_dash_suffix ; 0F:5269
	ld h, $02
.emit_dash_suffix ; 0F:526B
	ld a, $2D
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	dec h
	jr nz, .emit_dash_suffix
	jr .save_output_cursor_and_capacity
.emit_closing_quote ; 0F:527C
	ld a, $22
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	jr .save_output_cursor_and_capacity

Mail_EmitStringAndSuffix_NextPage:: ; 0F:528A
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_CopyItemToBuffer:: ; 0F:5293
	ld hl, wMail_ComposeItem
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld hl, wMail_TextBuf1
.loop ; 0F:52A8
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyItemToBuffer_NextPage
	dec c
	jr nz, .loop
	ld [hl], c
	ret

Mail_CopyItemToBuffer_NextPage:: ; 0F:52B3
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_ComposeHeaderBlock:: ; 0F:52BC

	push bc
	call Mail_ComposeHeaderBlock_LoadArgs
	push de
	ld h, d
	ld l, e
	ld a, [hli]
	ld b, a
	ld c, $01
	call Mail_ComposeHeaderBlock_BuildAddressList
	pop de
	and a, a
	jr nz, .l52FD
.load_compose_item_pointer ; 0F:52CE
	ld hl, wMail_ItemListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
.check_header_type3 ; 0F:52D4
	ld a, [wMail_Work + $03]
	cp a, $03
	jr nz, .skip
	push de
.skip ; 0F:52DC
	cp a, $05
	jr nz, .advance_empty_header_groups
	pop hl
	ld a, [hli]
	ld b, a
	ld c, $03
	call Mail_ComposeHeaderBlock_BuildAddressList
	and a, a
	jr nz, .l52FD
.advance_empty_header_groups ; 0F:52EB
	ld a, [de]
	inc de
	and a, a
	jr nz, .save_next_item_pointer
	ld a, [wMail_Work + $03]
	cp a, $06
	jr z, .emit_header_types6_to8
	inc a
	ld [wMail_Work + $03], a
	jr .check_header_type3
.l52FD ; 0F:52FD
	pop hl
	ld a, $01
	ld b, $83
	jp Mail_Return
.save_next_item_pointer ; 0F:5305
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
.emit_counted_header_items ; 0F:530B
	ld [wMail_Work + $05], a
	ld a, $01
	ld [wMail_Work + $04], a
	call Mail_ComposeHeaderBlock_FetchItem
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l52FD
	ld a, [wMail_Work + $05]
	dec a
	jr nz, .emit_counted_header_items
	ld a, [wMail_Work + $03]
	inc a
	ld [wMail_Work + $03], a
	call Mail_EmitCrLf
	and a, a
	jr nz, .l52FD
	ld [wMail_ComposeState], a
	ld a, [wMail_Work + $03]
	cp a, $06
	jr nz, .load_compose_item_pointer
.emit_header_types6_to8 ; 0F:5339
	call Mail_ComposeHeaderBlock_FetchItem
	xor a, a
	ld [wMail_ComposeState], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l52FD
	call Mail_EmitCrLf
	and a, a
	jr nz, .l52FD
	ld a, [wMail_Work + $03]
	inc a
	ld [wMail_Work + $03], a
	cp a, $09
	jr nz, .emit_header_types6_to8
	pop bc
	ld a, b
	and a, a
	jr z, .return_emitted_length
	call Mail_ComposeHeaderBlock_FetchItem
	xor a, a
	ld [wMail_ComposeState], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l52FD
	call Mail_EmitCrLf
	and a, a
	jr nz, .l52FD
.return_emitted_length ; 0F:536F
	ld hl, wMail_OutputStream + $03
	ld a, [hli]
	cpl
	ld e, a
	ld a, [hli]
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	xor a, a
	jp Mail_Return

Mail_ComposeHeaderBlock_LoadArgs:: ; 0F:5381

	ld hl, wMail_OutputBankVar
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	ld b, a
	inc de
	ld a, [de]
	ld [hli], a
	inc hl
	ld a, [de]
	ld [hld], a
	ld a, b
	ld [hli], a
	inc de
	ld hl, wMail_Work + $15
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_ComposeState], a
	ret

Mail_ComposeHeaderBlock_FetchItem:: ; 0F:53B9

	ld hl, wMail_ItemListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	inc hl
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hl], a
	inc de
	ld a, [de]
	ld [wMail_ComposeItem], a
	inc de
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Mail_ComposeHeaderBlock_BuildAddressList:: ; 0F:53D6

	ld a, [wMail_Work + $03]
	ld d, a
	ld a, [wMail_Work + $04]
	ld e, a
	push de
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	ld a, $24
	ld [wMail_Work + $13], a
	ld a, $D0
	ld [wMail_Work + $14], a
	push bc
	jr .l53F8
.read_address_group_count ; 0F:53F3
	ld a, [hli]
	and a, a
	jr z, .advance_empty_address_group
	ld b, a
.l53F8 ; 0F:53F8
	push bc
.copy_address_group_records ; 0F:53F9
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc hl
	ld c, [hl]
	inc hl
	push hl
	ld a, [wMail_Work + $13]
	ld l, a
	ld a, [wMail_Work + $14]
	ld h, a
	push bc
	ld b, $00
	call Mail_CopyFromSram
	inc hl
	ld [hl], a
	pop bc
	ld a, l
	ld e, a
	ld [wMail_Work + $13], a
	ld a, h
	ld d, a
	ld [wMail_Work + $14], a
	dec b
	jr z, .restore_and_advance_address_group
	pop hl
	jr .copy_address_group_records
.advance_empty_address_group ; 0F:542A
	dec c
	jr nz, .read_address_group_count
	jr .save_resume_pointer_and_terminate_buffer
.restore_and_advance_address_group ; 0F:542F
	pop hl
	pop bc
	dec c
	jr nz, .read_address_group_count
.save_resume_pointer_and_terminate_buffer ; 0F:5434
	ld a, l
	ld [wMail_Work + $13], a
	ld a, h
	ld [wMail_Work + $14], a
	xor a, a
	ld [de], a
	ld hl, wMail_TextBuf1
.join_address_strings_with_commas ; 0F:5441
	ld a, [hli]
	and a, a
	jr nz, .join_address_strings_with_commas
	ld a, [hl]
	and a, a
	jr z, .extract_buffered_addresses
	dec hl
	ld a, $2C
	ld [hli], a
	jr .join_address_strings_with_commas
.restore_work_fields_after_failure ; 0F:544F
	pop hl
	ld a, h
	ld [wMail_Work + $03], a
	ld a, l
	ld [wMail_Work + $04], a
	ld a, $01
	ret
.extract_buffered_addresses ; 0F:545B
	ld hl, wMail_TextBuf1
	call Mail_ExtractAddresses
	ld hl, wMail_TextBuf2 + $01
.replace_commas_with_nuls ; 0F:5464
	ld a, [hli]
	and a, a
	jr z, .adjust_output_terminator_by_mode
	cp a, $2C
	jr nz, .replace_commas_with_nuls
	dec hl
	xor a, a
	ld [hli], a
	jr .replace_commas_with_nuls
.adjust_output_terminator_by_mode ; 0F:5471
	pop de
	ld a, e
	cp a, $01
	jr z, .exclude_extra_terminator_from_count
	xor a, a
	ld [hli], a
	jr .check_address_output_capacity
.exclude_extra_terminator_from_count ; 0F:547B
	dec bc
.check_address_output_capacity ; 0F:547C
	ld hl, wMail_Work + $18
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	cp a, h
	jr c, .subtract_capacity_and_copy_addresses_to_sram
	jr nz, .restore_work_fields_after_failure
	ld a, c
	cp a, l
	jr c, .subtract_capacity_and_copy_addresses_to_sram
	jr z, .subtract_capacity_and_copy_addresses_to_sram
	jr .restore_work_fields_after_failure
.subtract_capacity_and_copy_addresses_to_sram ; 0F:5490
	ld hl, wMail_Work + $18
	ld a, c
	cpl
	ld e, a
	ld a, b
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	ld de, wMail_Work + $18
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld hl, wMail_Work + $15
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf2 + $01
	call Mail_CopyToSram
	ld hl, wMail_Work + $15
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	ld a, [wMail_Work + $13]
	ld e, a
	ld a, [wMail_Work + $14]
	ld d, a
	pop hl
	ld a, h
	ld [wMail_Work + $03], a
	ld a, l
	ld [wMail_Work + $04], a
	xor a, a
	ret

Mail_ComposeMimeBody:: ; 0F:54D8

	xor a, a
	ld [wMail_ComposeState], a
	call Mail_ComposeMimeBody_LoadArgs
	call Mail_ComposeMimeBody_CopyData
	and a, a
	jr nz, .l5541
	call Mail_ComposeMimeBody_NextPart
	ld a, [wMail_Work + $15]
	dec a
	ld [wMail_Work + $15], a
	and a, a
	jp z, .emit_final_crlf
	cp a, $01
	jr nz, .mark_multipart_and_emit_field0b
	xor a, a
	ld [wMail_Work + $1C], a
.dispatch_mime_part_type ; 0F:54FB
	ld a, [wMail_Work + $16]
	cp a, $02
	jr z, .emit_field_type0a
	cp a, $03
	jr z, .emit_field_types0c_and0d
.emit_field_type0a ; 0F:5506
	ld a, $0A
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr z, .emit_header_separator_and_copy_body
	jr .l5541
.emit_field_types0c_and0d ; 0F:5513
	ld a, $0C
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	ld a, $0D
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
.emit_header_separator_and_copy_body ; 0F:552F
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	call Mail_ComposeMimeBody_CopyData
	and a, a
	jr z, .advance_remaining_mime_parts
.l5541 ; 0F:5541
	ld a, $01
	jp Mail_Return
.mark_multipart_and_emit_field0b ; 0F:5546
	ld a, $01
	ld [wMail_Work + $1C], a
	ld a, $0B
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
.emit_part_boundary_line ; 0F:555C
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	ld a, $0E
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	jr .dispatch_mime_part_type
.emit_closing_boundary_if_multipart ; 0F:5575
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	ld a, [wMail_Work + $1C]
	and a, a
	jr z, .emit_field10_and_return_length
	ld a, $0F
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
.emit_final_crlf ; 0F:558C
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
.emit_field10_and_return_length ; 0F:5592
	ld a, $10
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	ld hl, wMail_OutputStream + $03
	ld a, [hli]
	cpl
	ld e, a
	ld a, [hli]
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	xor a, a
	jp Mail_Return
.advance_remaining_mime_parts ; 0F:55B5
	ld a, [wMail_Work + $15]
	dec a
	ld [wMail_Work + $15], a
	and a, a
	jr z, .emit_closing_boundary_if_multipart
	call Mail_ComposeMimeBody_NextPart
	jr .emit_part_boundary_line

Mail_ComposeMimeBody_LoadArgs:: ; 0F:55C4

	ld hl, wMail_OutputBankVar
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	ld b, a
	inc de
	ld a, [de]
	ld [hli], a
	ld [hl], b
	inc hl
	ld [hli], a
	inc de
	ld a, [de]
	ld [wMail_Work + $15], a
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	call Mail_ComposeMimeBody_NextPart
	ret

Mail_ComposeMimeBody_NextPart:: ; 0F:55E6

	ld a, [wMail_ItemListPointer]
	ld l, a
	ld a, [wMail_ItemListPointer + $01]
	ld h, a
	ld a, [hli]
	ld [wMail_Work + $16], a
	cp a, $03
	jr nz, .copy_next_part_descriptor
	ld de, wMail_ComposeItem + $01
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, [hli]
	ld [wMail_ComposeItem], a
.copy_next_part_descriptor ; 0F:5605
	ld de, wMail_Work + $17
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	inc de
	ld a, [hli]
	ld [de], a
	ld a, l
	ld [wMail_ItemListPointer], a
	ld a, h
	ld [wMail_ItemListPointer + $01], a
	ret

Mail_ComposeMimeBody_CopyData:: ; 0F:561F

	ld a, [wMail_OutputBankVar]
	ld [wMail_OutputBank], a
	ld a, [wMail_Work + $17]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wMail_Work + $1A
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wMail_OutputStream + $04]
	cp a, b
	jp c, .l56C6
	jr nz, .charge_output_capacity_for_chunk
	ld a, [wMail_OutputStream + $03]
	cp a, c
	jp c, .l56C6
.charge_output_capacity_for_chunk ; 0F:5646
	ld a, b
	or a, c
	jr z, .save_final_output_bank
	ld a, [wMail_OutputStream + $03]
	ld l, a
	ld a, [wMail_OutputStream + $04]
	ld h, a
	ld a, c
	cpl
	ld e, a
	ld a, b
	cpl
	ld d, a
	inc de
	add hl, de
	ld a, l
	ld [wMail_OutputStream + $03], a
	ld a, h
	ld [wMail_OutputStream + $04], a
.loop ; 0F:5662
	ld a, $0E
	cp a, b
	jr c, .l56CB
	jr nz, .copy_body_chunk_through_wram
	ld a, $00
	cp a, c
	jr c, .l56CB
.copy_body_chunk_through_wram ; 0F:566E
	ld a, [wMail_Work + $1A]
	ld e, a
	ld a, [wMail_Work + $1B]
	ld d, a
	ld a, c
	cpl
	ld l, a
	ld a, b
	cpl
	ld h, a
	inc hl
	add hl, de
	ld a, l
	ld [wMail_Work + $1A], a
	ld a, h
	ld [wMail_Work + $1B], a
	push bc
	ld hl, wMail_Work + $18
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1
	call Mail_CopyFromSram
	ld hl, wMail_Work + $18
	ld [hl], e
	inc hl
	ld [hl], d
	pop bc
	ld a, [wMail_OutputBank]
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wMail_OutputStream + $01
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1
	call Mail_CopyToSram
	ld hl, wMail_OutputStream + $01
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wMail_Work + $1A
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, b
	or a, c
	jr nz, .loop
.save_final_output_bank ; 0F:56BE
	ld a, [wMail_OutputBank]
	ld [wMail_OutputBankVar], a
	xor a, a
	ret
.l56C6 ; 0F:56C6
	ld a, $01
	ld b, $83
	ret
.l56CB ; 0F:56CB
	ld a, $0E
	cpl
	ld h, a
	ld a, $00
	cpl
	ld l, a
	add hl, bc
	ld de, wMail_Work + $1A
	ld a, l
	ld [de], a
	inc de
	ld a, h
	ld [de], a
	ld bc, $0E00
	jr .copy_body_chunk_through_wram

Mail_Base64EncodeStream:: ; 0F:56E1

	ld a, [wMail_ComposeState]
	and a, a
	jp z, Mail_Return
	cp a, $02
	jr z, .clamp_encode_chunk
	cp a, $03
	jr z, .encode_step_and_check_completion
	cp a, $04
	jr z, .encode_step_and_check_completion
	cp a, $05
	jr z, .return_total_encoded_size_and_reset_state
	cp a, $FF
	jr z, .l5740
	cp a, $01
	jp nz, Mail_Return
	call Mail_Base64Stream_LoadArgs
	call Mail_CalcBase64EncodedSize
	ld a, h
	ld [wMail_Work + $12], a
	ld a, l
	ld [wMail_Work + $11], a
.clamp_encode_chunk ; 0F:570F
	call Mail_Base64EncodeStream_ClampChunk
.encode_step_and_check_completion ; 0F:5712
	call Mail_Base64EncodeStream_Step
	and a, a
	jr nz, .l5740
	ld a, [wMail_ComposeState]
	cp a, $05
	jr z, .return_total_encoded_size_and_reset_state
	ld a, [wMail_Work + $12]
	ld h, a
	ld a, [wMail_Work + $11]
	ld l, a
	xor a, a
	jp Mail_Return
.return_total_encoded_size_and_reset_state ; 0F:572B
	ld hl, wMail_Work + $0A
	ld a, [hli]
	cpl
	ld e, a
	ld a, [hli]
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	xor a, a
	ld [wMail_ComposeState], a
	jp Mail_Return
.l5740 ; 0F:5740
	ld a, $01
	ld b, $83
	jp Mail_Return

Mail_Base64Stream_LoadArgs:: ; 0F:5747

	ld hl, wMail_Work + $02
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	dec de
	ld a, [de]
	ld [hli], a
	inc de
	ld a, [de]
	ld [hli], a
	ld a, c
	ld [hli], a
	ld [hl], b
	ret

Mail_CalcBase64EncodedSize:: ; 0F:5771

	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, $10
	ld b, $00
	ld c, b
	ld d, b
	ld a, $03
.shift_input_and_compare_three ; 0F:577F
	rl l
	rl h
	rl d
	cp a, d
	jr c, .subtract_three_and_set_quotient_bit
	rl c
	rl b
	dec e
	jr nz, .shift_input_and_compare_three
	jr .round_up_nonzero_remainder
.subtract_three_and_set_quotient_bit ; 0F:5791
	ld a, d
	sub a, $03
	ld d, a
	ld a, $03
	scf
	rl c
	rl b
	dec e
	jr nz, .shift_input_and_compare_three
.round_up_nonzero_remainder ; 0F:579F
	ld a, d
	and a, a
	jr z, .skip
	inc bc
.skip ; 0F:57A4
	sla c
	rl b
	sla c
	rl b
	ld h, b
	ld l, c
	push hl
	ld e, $10
	ld b, $00
	ld c, b
	ld d, b
	ld a, $40
.shift_input_and_compare_40 ; 0F:57B7
	rl l
	rl h
	rl d
	cp a, d
	jr c, .subtract_40_and_set_quotient_bit
	rl c
	rl b
	dec e
	jr nz, .shift_input_and_compare_40
	jr .add_twice_bc_and_set_state2
.subtract_40_and_set_quotient_bit ; 0F:57C9
	ld a, d
	sub a, $40
	ld d, a
	ld a, $40
	scf
	rl c
	rl b
	dec e
	jr nz, .shift_input_and_compare_40
	inc bc
.add_twice_bc_and_set_state2 ; 0F:57D8
	and a, a
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, $02
	ld [wMail_ComposeState], a
	ret

Mail_Base64EncodeStream_ClampChunk:: ; 0F:57E5

	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMail_Work + $0E]
	ld c, a
	ld a, [wMail_Work + $0F]
	ld b, a
	cp a, h
	jr c, .subtract_chunk_and_test_final
	jr nz, .clamp_chunk_to_remaining_count
	ld a, c
	cp a, l
	jr c, .subtract_chunk_and_test_final
	jr z, .subtract_chunk_and_test_final
.clamp_chunk_to_remaining_count ; 0F:57FE
	ld b, h
	ld c, l
.subtract_chunk_and_test_final ; 0F:5800
	push bc
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	ld a, l
	ld [wMail_Work + $05], a
	ld a, h
	ld [wMail_Work + $06], a
	ld a, h
	or a, l
	jr nz, .save_nonfinal_chunk_and_state3
	pop bc
	ld a, c
	ld [wMail_Work + $0E], a
	ld a, b
	ld [wMail_Work + $0F], a
	ld a, $04
	ld [wMail_ComposeState], a
	ret
.save_nonfinal_chunk_and_state3 ; 0F:5824
	pop bc
	ld a, c
	ld [wMail_Work + $0E], a
	ld a, b
	ld [wMail_Work + $0F], a
	ld a, $03
	ld [wMail_ComposeState], a
	ret

Mail_Base64EncodeStream_Step:: ; 0F:5833

	ld a, [wMail_ComposeState]
	and a, a
	ret z
	ld a, [wMail_Work + $0E]
	ld c, a
	ld a, [wMail_Work + $0F]
	ld b, a
	ld hl, wMail_Work + $02
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1
	push bc
	call Mail_CopyFromSram
	pop bc
	ld hl, wMail_Work + $02
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wMail_TextBuf1
	ld de, wMail_TextBuf2
	call Mail_Base64Encode
	ld hl, wMail_TextBuf2
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push hl
	ld a, [wMail_Work + $0A]
	ld l, a
	ld a, [wMail_Work + $0B]
	ld h, a
	cp a, b
	jr c, .l58D0
	jr nz, .charge_capacity_and_write_encoded_chunk
	ld a, l
	cp a, c
	jr c, .l58D0
.charge_capacity_and_write_encoded_chunk ; 0F:5883
	push bc
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	ld a, l
	ld [wMail_Work + $0A], a
	ld a, h
	ld [wMail_Work + $0B], a
	pop bc
	pop hl
	ld hl, wMail_Work + $07
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf2 + $02
	call Mail_CopyToSram
	ld hl, wMail_Work + $07
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, [wMail_ComposeState]
	cp a, $03
	jr z, .set_compose_state2
	cp a, $04
	jr z, .set_compose_state5
	jr .set_compose_state_ff
.set_compose_state5 ; 0F:58C2
	ld a, $05
	ld [wMail_ComposeState], a
	jr .l58CE
.set_compose_state2 ; 0F:58C9
	ld a, $02
	ld [wMail_ComposeState], a
.l58CE ; 0F:58CE
	xor a, a
	ret
.l58D0 ; 0F:58D0
	pop hl
.set_compose_state_ff ; 0F:58D1
	ld a, $FF
	ld [wMail_ComposeState], a
	ret

Mail_Base64Encode:: ; 0F:58D7
	; [CONFIRMED] 133 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 5 scenarios]
	ld a, e
	ld [wMail_Work + $20], a
	ld a, d
	ld [wMail_Work + $21], a
	xor a, a
	ld [wMail_Work + $22], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, c
	ld [wMail_Work + $19], a
	ld a, b
	ld [wMail_Work + $1A], a
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld l, c
	ld h, b
	xor a, a
	ld [wMail_Work + $1F], a
.prepare_three_byte_group ; 0F:58FA
	ld b, $03
	push hl
	ld hl, wMail_Work + $1B
.read_three_source_bytes ; 0F:5900
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .read_three_source_bytes
	ld a, [wMail_Work + $19]
	ld c, a
	ld a, [wMail_Work + $1A]
	ld b, a
	xor a, a
	or a, b
	jr nz, .encode_group_to_four_characters
	ld a, $02
	cp a, c
	jr c, .encode_group_to_four_characters
	push hl
	dec hl
	ld a, c
	ld [wMail_Work + $1F], a
.zero_pad_short_input_group ; 0F:591D
	xor a, a
	ld [hld], a
	inc c
	ld a, $03
	cp a, c
	jr nz, .zero_pad_short_input_group
	pop hl
	ld bc, $0003
.encode_group_to_four_characters ; 0F:5929
	dec bc
	dec bc
	dec bc
	ld a, c
	ld [wMail_Work + $19], a
	ld a, b
	ld [wMail_Work + $1A], a
	push de
	push hl
	ld hl, wMail_Work + $20
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop hl
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	ld d, a
	srl a
	srl a
	ld [hli], a
	ld a, $03
	and a, d
	ld d, a
	ld a, $F0
	and a, b
	or a, d
	swap a
	ld [hli], a
	ld a, $0F
	and a, b
	ld d, a
	ld a, c
	and a, $C0
	or a, d
	rlca
	rlca
	ld [hli], a
	ld a, $3F
	and a, c
	ld [hld], a
	dec hl
	dec hl
	pop de
	ld b, h
	ld c, l
	pop hl
	ld a, [bc]
	inc bc
	call Mail_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call Mail_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call Mail_Base64EncodeChar
	ld [hli], a
	ld a, [bc]
	inc bc
	call Mail_Base64EncodeChar
	ld [hli], a
	ld a, [wMail_Work + $22]
	inc a
	cp a, $10
	jr nz, .save_line_group_count_and_continue

	; [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	push af
	push bc
	ld a, [wMail_Work + $19]
	ld b, a
	ld a, [wMail_Work + $1A]
	or a, b
	jr nz, .append_crlf_and_count_two_bytes
	ld a, [wMail_Work + $05]
	ld b, a
	ld a, [wMail_Work + $06]
	or a, b
	jr nz, .append_crlf_and_count_two_bytes
	pop bc
	pop af
	jr .check_final_padding_count
.append_crlf_and_count_two_bytes ; 0F:59AD
	pop bc
	pop af
	ld a, $0D
	ld [hli], a
	ld a, $0A
	ld [hli], a
	push hl
	ld hl, wMail_Work + $20
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [hli]
	ld c, a
	ld b, [hl]
	inc bc
	inc bc
	ld a, b
	ld [hld], a
	ld [hl], c
	pop hl
	xor a, a

.save_line_group_count_and_continue ; 0F:59C6
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 2 scenarios]
	ld [wMail_Work + $22], a
	ld a, [wMail_Work + $19]
	cp a, $00
	jp nz, .prepare_three_byte_group
	ld a, [wMail_Work + $1A]
	cp a, $00
	jp nz, .prepare_three_byte_group
.check_final_padding_count ; 0F:59D9
	ld a, [wMail_Work + $1F]
	cp a, $00
	jr z, .terminate_base64_output
	push hl
	dec hl
	ld b, a
.replace_tail_with_equals_padding ; 0F:59E3
	ld a, $3D
	ld [hld], a
	inc b
	ld a, $03
	cp a, b
	jr nz, .replace_tail_with_equals_padding
	pop hl
.terminate_base64_output ; 0F:59ED
	ld a, $00
	ld [hl], a
	ret

Mail_Base64EncodeChar:: ; 0F:59F1
	cp a, $1A
	jr c, .encode_uppercase
	cp a, $34
	jr c, .encode_lowercase
	cp a, $3E
	jr c, .encode_digit

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $3E
	jr z, .encode_plus
	ld a, $2F
	ret

.encode_uppercase ; 0F:5A04
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 2 scenarios]
	add a, $41
	ret
.encode_lowercase ; 0F:5A07
	add a, $47
	ret
.encode_digit ; 0F:5A0A
	sub a, $04
	ret

.encode_plus ; 0F:5A0D
	; [PROBABLE] 356 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $2B
	ret

Mail_Base64DecodeStream:: ; 0F:5A10

	ld a, [wMail_Work + $23]
	and a, a
	jp z, Mail_Return
	cp a, $02
	jr z, .clamp_decode_chunk
	cp a, $03
	jr z, .decode_step_and_check_completion
	cp a, $04
	jr z, .decode_step_and_check_completion
	cp a, $05
	jr z, .return_decoded_size_and_reset_state
	cp a, $FF
	jr z, .l5A6F
	cp a, $01
	jp nz, Mail_Return
	call Mail_Base64Stream_LoadArgs
	call Mail_CalcBase64DecodedSize
	ld a, h
	ld [wMail_Work + $11], a
	ld a, l
	ld [wMail_Work + $12], a
.clamp_decode_chunk ; 0F:5A3E
	call Mail_Base64DecodeStream_ClampChunk
.decode_step_and_check_completion ; 0F:5A41
	call Mail_Base64DecodeStream_Step
	and a, a
	jr nz, .l5A6F
	ld a, [wMail_Work + $23]
	cp a, $05
	jr z, .return_decoded_size_and_reset_state
	ld a, [wMail_Work + $12]
	ld h, a
	ld a, [wMail_Work + $11]
	ld l, a
	xor a, a
	jp Mail_Return
.return_decoded_size_and_reset_state ; 0F:5A5A
	ld hl, wMail_Work + $0A
	ld a, [hli]
	cpl
	ld e, a
	ld a, [hli]
	cpl
	ld d, a
	inc de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, de
	xor a, a
	ld [wMail_Work + $23], a
	jp Mail_Return
.l5A6F ; 0F:5A6F
	ld a, $01
	jp Mail_Return

Mail_CalcBase64DecodedSize:: ; 0F:5A74

	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld e, $10
	ld b, $00
	ld c, b
	ld d, b
	ld a, $42
.loop ; 0F:5A83
	rl l
	rl h
	rl d
	cp a, d
	jr c, .subtract_42_and_set_quotient_bit
	rl c
	rl b
	dec e
	jr nz, .loop
	jr .subtract_twice_bc_and_scale_three_quarters
.subtract_42_and_set_quotient_bit ; 0F:5A95
	ld a, d
	sub a, $42
	ld d, a
	ld a, $42
	scf
	rl c
	rl b
	dec e
	jr nz, .loop
.subtract_twice_bc_and_scale_three_quarters ; 0F:5AA3
	sla c
	rl b
	pop hl
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	srl h
	rr l
	srl h
	rr l
	ld b, h
	ld c, l
	sla c
	rl b
	add hl, bc
	ld a, $02
	ld [wMail_Work + $23], a
	ret

Mail_Base64DecodeStream_ClampChunk:: ; 0F:5AC5

	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wMail_Work + $0E]
	ld c, a
	ld a, [wMail_Work + $0F]
	ld b, a
	cp a, h
	jr c, .subtract_chunk_and_test_final
	jr nz, .clamp_chunk_to_remaining_count
	ld a, c
	cp a, l
	jr c, .subtract_chunk_and_test_final
	jr z, .subtract_chunk_and_test_final
.clamp_chunk_to_remaining_count ; 0F:5ADE
	ld b, h
	ld c, l
.subtract_chunk_and_test_final ; 0F:5AE0
	push bc
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	ld a, l
	ld [wMail_Work + $05], a
	ld a, h
	ld [wMail_Work + $06], a
	ld a, h
	or a, l
	jr nz, .save_nonfinal_chunk_and_state3
	pop bc
	ld a, c
	ld [wMail_Work + $0E], a
	ld a, b
	ld [wMail_Work + $0F], a
	ld a, $04
	ld [wMail_Work + $23], a
	xor a, a
	ret
.save_nonfinal_chunk_and_state3 ; 0F:5B05
	pop bc
	ld a, c
	ld [wMail_Work + $0E], a
	ld a, b
	ld [wMail_Work + $0F], a
	ld a, $03
	ld [wMail_Work + $23], a
	xor a, a
	ret

Mail_Base64DecodeStream_Step:: ; 0F:5B15

	ld a, [wMail_Work + $23]
	and a, a
	ret z
	ld a, [wMail_Work + $0E]
	ld c, a
	ld a, [wMail_Work + $0F]
	ld b, a
	ld hl, wMail_Work + $02
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf2
	push bc
	call Mail_CopyBase64StripLineBreaks
	pop hl
	and a, a
	jr z, .decode_buffer_and_check_output_capacity
	cp a, $02
	jr z, .l5B50
	ld a, [wMail_Work + $23]
	cp a, $04
	jr z, .decode_buffer_and_check_output_capacity
	inc hl
	inc hl
	jr .decode_buffer_and_check_output_capacity
.loop ; 0F:5B4B
	pop hl
	ld b, $83
	jr .set_decode_state_ff
.l5B50 ; 0F:5B50
	ld b, $81
.set_decode_state_ff ; 0F:5B52
	ld a, $FF
	ld [wMail_Work + $23], a
	ret
.decode_buffer_and_check_output_capacity ; 0F:5B58
	ld a, [wMail_Work + $10]
	add a, a
	cpl
	ld c, a
	ld b, $FF
	inc bc
	add hl, bc
	ld b, h
	ld c, l
	ld hl, wMail_Work + $02
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	ld hl, wMail_TextBuf2
	ld de, wMail_TextBuf1
	call Mail_Base64Decode
	ld hl, wMail_TextBuf1
	ld c, [hl]
	inc hl
	ld b, [hl]
	inc hl
	push hl
	ld a, [wMail_Work + $0A]
	ld l, a
	ld a, [wMail_Work + $0B]
	ld h, a
	cp a, b
	jr c, .loop
	jr nz, .charge_capacity_and_write_decoded_chunk
	ld a, l
	cp a, c
	jr c, .loop
.charge_capacity_and_write_decoded_chunk ; 0F:5B90
	push bc
	ld a, b
	cpl
	ld b, a
	ld a, c
	cpl
	ld c, a
	inc bc
	add hl, bc
	ld a, l
	ld [wMail_Work + $0A], a
	ld a, h
	ld [wMail_Work + $0B], a
	pop bc
	pop hl
	ld hl, wMail_Work + $07
	ld a, [hli]
	ld [wMail_OutputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld e, [hl]
	inc hl
	ld d, [hl]
	ld hl, wMail_TextBuf1 + $02
	call Mail_CopyToSram
	ld hl, wMail_Work + $07
	ld a, [wMail_OutputBank]
	ld [hli], a
	ld a, e
	ld [hli], a
	ld [hl], d
	ld a, [wMail_Work + $23]
	cp a, $03
	jr z, .set_decode_state2
	cp a, $04
	jr z, .set_decode_state5
	jr .l5B50
.set_decode_state5 ; 0F:5BCF
	ld a, $05
	ld [wMail_Work + $23], a
	jr .l5BDB
.set_decode_state2 ; 0F:5BD6
	ld a, $02
	ld [wMail_Work + $23], a
.l5BDB ; 0F:5BDB
	xor a, a
	ret

Mail_CopyBase64StripLineBreaks:: ; 0F:5BDD

	xor a, a
	ld [wMail_Work + $10], a
.loop ; 0F:5BE1
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, Mail_CopyBase64StripLineBreaks_ErrorExit
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, .retain_two_trailing_bytes_unless_final
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, Mail_CopyBase64StripLineBreaks_ErrorExit
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, .terminate_stripped_buffer
	ld a, [de]
	cp a, $0D
	jr nz, .loop
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, Mail_CopyBase64StripLineBreaks_ErrorExit
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	dec bc
	ld a, b
	or a, c
	jr z, Mail_CopyBase64StripLineBreaks_ErrorExit
	ld a, [wMail_Work + $10]
	inc a
	ld [wMail_Work + $10], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
.retain_two_trailing_bytes_unless_final ; 0F:5C30
	ld a, [wMail_Work + $23]
	cp a, $04
	jr z, .remove_two_final_bytes_and_terminate
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyBase64StripLineBreaks_NextPage
	xor a, a
	ld [hl], a
	ld a, $01
	ret
.remove_two_final_bytes_and_terminate ; 0F:5C48
	dec hl
	dec hl
	xor a, a
	ld [hl], a
	ld a, $01
	ret
.terminate_stripped_buffer ; 0F:5C4F
	xor a, a
	ld [hl], a
	ret

Mail_CopyBase64StripLineBreaks_NextPage:: ; 0F:5C52

	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_CopyBase64StripLineBreaks_ErrorExit:: ; 0F:5C5B
	ld a, $02
	ret

Mail_Base64Decode:: ; 0F:5C5E
	; [CONFIRMED] 47 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, e
	ld [wMail_Work + $1F], a
	ld a, d
	ld [wMail_Work + $20], a
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld a, c
	ld [wMail_Work + $19], a
	ld a, b
	ld [wMail_Work + $1A], a
	ld c, e
	ld b, d
	ld e, l
	ld d, h
	ld l, c
	ld h, b
.check_remaining_quartet ; 0F:5C79
	ld a, [wMail_Work + $1A]
	or a, a
	jr nz, .prepare_four_byte_group
	ld a, [wMail_Work + $19]
	cp a, $04
	jr c, .incomplete_quartet
.prepare_four_byte_group ; 0F:5C86
	ld b, $04
	push hl
	ld hl, wMail_Work + $1B
.decode_quartet_chars ; 0F:5C8C
	ld a, [de]
	inc de
	call Mail_Base64DecodeChar
	ld [hli], a
	dec b
	jr nz, .decode_quartet_chars
	ld a, [wMail_Work + $19]
	ld c, a
	ld a, [wMail_Work + $1A]
	ld b, a
	dec bc
	dec bc
	dec bc
	dec bc
.skip_crlf_before_next_quartet ; 0F:5CA1
	ld a, [de]
	cp a, $0D
	jr z, .consume_line_break
	cp a, $0A
	jr nz, .pack_quartet_into_three_bytes

.consume_line_break ; 0F:5CAA
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	inc de
	dec bc
	jr .skip_crlf_before_next_quartet
.incomplete_quartet ; 0F:5CAE
	ld a, $FF
	ld [wMail_Work + $23], a
	ret

.pack_quartet_into_three_bytes ; 0F:5CB4
	; [CONFIRMED] 91 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 12 scenarios]
	ld a, c
	ld [wMail_Work + $19], a
	ld a, b
	ld [wMail_Work + $1A], a
	push de
	push hl
	ld hl, wMail_Work + $1F
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	inc de
	inc de
	inc de
	ld [hl], d
	dec hl
	ld [hl], e
	pop hl
	dec hl
	ld d, [hl]
	dec hl
	ld c, [hl]
	dec hl
	ld b, [hl]
	dec hl
	ld a, [hl]
	sla b
	sla b
	sla b
	rla
	sla b
	rla
	ld [hli], a
	ld [hl], b
	inc hl
	rrc c
	rrc c
	ld [hl], c
	dec hl
	ld a, $0F
	and a, c
	or a, [hl]
	ld [hli], a
	ld a, [hli]
	and a, $C0
	or a, [hl]
	dec hl
	ld [hld], a
	dec hl
	pop de
	ld b, h
	ld c, l
	pop hl
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	inc bc
	ld a, [bc]
	ld [hli], a
	ld a, [wMail_Work + $19]
	cp a, $00
	jp nz, .check_remaining_quartet
	ld a, [wMail_Work + $1A]
	cp a, $00
	jp nz, .check_remaining_quartet
	ret

Mail_Base64DecodeChar:: ; 0F:5D12
	cp a, $2B
	jr c, .invalid_char
	jr z, .decode_plus
	cp a, $2F
	jr c, .invalid_char
	jr z, .decode_slash
	cp a, $30
	jr c, .invalid_char
	cp a, $3A
	jr c, .decode_digit
	cp a, $3D
	jr c, .invalid_char
	jr z, .decode_padding
	cp a, $41
	jr c, .invalid_char
	cp a, $5B
	jr c, .decode_uppercase
	cp a, $61
	jr c, .invalid_char
	cp a, $7B
	jr c, .decode_lowercase

.invalid_char ; 0F:5D3C
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	pop hl
	pop hl
	ld a, $FF
	ld [wMail_Work + $23], a
	ret
.decode_plus ; 0F:5D44
	ld a, $3E
	ret
.decode_slash ; 0F:5D47
	ld a, $3F
	ret

.decode_digit ; 0F:5D4A
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 10 scenarios]
	add a, $04
	ret
.decode_padding ; 0F:5D4D
	push de
	push hl
	ld a, [wMail_Work + $1F]
	ld l, a
	ld a, [wMail_Work + $20]
	ld h, a
	ld e, [hl]
	inc hl
	ld d, [hl]
	dec de
	ld [hl], d
	dec hl
	ld [hl], e
	pop hl
	pop de
	xor a, a
	ret
.decode_uppercase ; 0F:5D62
	sub a, $41
	ret
.decode_lowercase ; 0F:5D65
	sub a, $47
	ret

Mail_CopyFromSram:: ; 0F:5D68
	ld a, [de]
	ld [hli], a
	inc e
	call z, Mail_CopyFromSram_NextPage
	dec bc
	ld a, b
	or a, c
	jr nz, Mail_CopyFromSram
	xor a, a
	ld [hl], a
	ret

Mail_CopyFromSram_NextPage:: ; 0F:5D76
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_CopyToSram:: ; 0F:5D7F
	ld a, [hli]
	ld [de], a
	inc e
	call z, Mail_CopyToSram_NextPage
	dec bc
	ld a, b
	or a, c
	jr nz, Mail_CopyToSram
	xor a, a
	ret

Mail_CopyToSram_NextPage:: ; 0F:5D8C
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_NextSramPage:: ; 0F:5D95
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 17 scenarios]
	ld e, a
	ld a, d
	cp a, $BF
	jr z, .advance_sram_bank
	inc d
	ld a, e
	ld e, $00
	ret

.advance_sram_bank ; 0F:5DA0
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, [bc]
	inc a
	ld [bc], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, e
	ld d, $A0
	ld e, $00
	ret
