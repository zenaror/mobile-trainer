; lib/mobile/mail.asm
; bank 0F, $4000-$5DAE (7598 bytes); pinned by layout.link
; SDK mail library (= Crystal bank 45 lib/mobile/mail.asm) with its header strings and selector tables

SECTION "lib/mobile/mail", ROMX

; ---- text $4000-$4004 (4 bytes) [PROBABLE] ASCII string "---" + NUL (mail-header/text helper strings of this bank; neighbour of the CONFIRMED-style string table entries)

PUSHC sjis
MailStr_Boundary:: ; 0F:4000
String_0F_4000::
	db "---", 0
POPC

; ---- text $4004-$4010 (12 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_GameCodeAllowList:: ; 0F:4004
String_0F_4004::
	db "CGB-AAAA-00", 0
POPC

; ---- zero $4010-$4011 (1 bytes) [PROBABLE] 1 x 00 pad byte between the string ending at 4010 (String_0F_4004 ends at its NUL 400F) and the table at 4011
	ds $1, $00

; ---- ptrtable $4011-$4033 (34 bytes) [PROBABLE] 17 x dw string pointers: 4033 "From: ", 403A "Sender: ", 4043 "Reply-To: ", 404E "To: ", 4053 "Cc: ", 4058 "Subject: ", ... 4164 "--", 4167 "."; every target is a NUL-terminated ASCII string start (mail header field names of the message composer/parser); table starts at an odd address

Mail_HeaderStringTable:: ; 0F:4011
Table_0F_4011::
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
String_0F_4033::
	db "From: ", 0
POPC

; ---- text $403A-$404E (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_HdrSender:: ; 0F:403A
String_0F_403A::
	db "Sender: ", 0

MailStr_HdrReplyTo:: ; 0F:4043
	db "Reply-To: ", 0
POPC

; ---- text $404E-$4058 (10 bytes) [PROBABLE] ASCII strings "To: " and "Cc: " (entries 3 and 4 of the pointer table 0F:4011 = 404E, 4053)

PUSHC sjis
MailStr_HdrTo:: ; 0F:404E
String_0F_404E::
	db "To: ", 0

MailStr_HdrCc:: ; 0F:4053
	db "Cc: ", 0
POPC

; ---- text $4058-$4164 (268 bytes) [PROBABLE] text: 9 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_HdrSubject:: ; 0F:4058
String_0F_4058::
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
String_0F_4164::
	db "--", 0
POPC

; ---- text $4167-$4169 (2 bytes) [PROBABLE] ASCII string "." + NUL (entry 16 of the pointer table 0F:4011 = 4167)

PUSHC sjis
MailStr_Dot:: ; 0F:4167
String_0F_4167::
	db ".", 0
POPC

; ---- words $4169-$4183 (26 bytes) [PROBABLE] 13-entry jump table: the dispatcher at 0F:4250-425F reads [D002]*2 + $4169 (ld hl,$4169 ; add hl,de ; ld a,[hli] ; ld h,[hl] ; ld l,a ; ... jp hl); all 13 targets (426C 426D 4340 43BB 44D5 4B59 4BC0 4CDD 4E66 52BC 54D8 56E1 5A10) are instruction starts of the PROBABLE code regions of this bank

Mail_SelectorTable:: ; 0F:4169
Table_0F_4169::
	dw Mail_SelectorNop, Mail_ScanHeaders, Mail_CheckGameMail, Mail_LocateHeader, Mail_ParseBody, Mail_IndexHeaders, Mail_GetDecodedHeader, Mail_GetAddressList
	dw Mail_ComposeNext, Mail_ComposeHeaderBlock, Mail_ComposeMimeBody, Mail_Base64EncodeStream, Mail_Base64DecodeStream

; ---- ptrtable $4183-$419D (26 bytes) [PROBABLE] 13 x dw pointers to the ASCII header-name strings 419D "FROM:", 41A3 "SENDER:", 41AB "REPLY-TO:", 41B5 "TO:", 41B9 "CC:", 41BD "SUBJECT:", 41C6 "DATE:", 41CC "CONTENT-TYPE:", ... 420D "X-GBMAIL-TYPE:" (parallel to the 13-entry jump table 0F:4169; every target is a string start)

Mail_HeaderKeywordTable:: ; 0F:4183
Table_0F_4183::
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
String_0F_419D::
	db "FROM:", 0

MailStr_KwSender:: ; 0F:41A3
	db "SENDER:", 0
POPC

; ---- text $41AB-$41B5 (10 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwReplyTo:: ; 0F:41AB
String_0F_41AB::
	db "REPLY-TO:", 0
POPC

; ---- text $41B5-$41BD (8 bytes) [PROBABLE] ASCII strings "TO:" and "CC:" (entries of the pointer table 0F:4183)

PUSHC sjis
MailStr_KwTo:: ; 0F:41B5
String_0F_41B5::
	db "TO:", 0

MailStr_KwCc:: ; 0F:41B9
	db "CC:", 0
POPC

; ---- text $41BD-$41C6 (9 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwSubject:: ; 0F:41BD
String_0F_41BD::
	db "SUBJECT:", 0
POPC

; ---- text $41C6-$41CC (6 bytes) [PROBABLE] ASCII string "DATE:" + NUL (entry 6 of the pointer table 0F:4183)

PUSHC sjis
MailStr_KwDate:: ; 0F:41C6
String_0F_41C6::
	db "DATE:", 0
POPC

; ---- text $41CC-$421C (80 bytes) [PROBABLE] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwContentType:: ; 0F:41CC
String_0F_41CC::
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
String_0F_421C::
	db "NAME=", 0
POPC

; ---- text $4222-$4236 (20 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
MailStr_KwMultipart:: ; 0F:4222
String_0F_4222::
	db "MULTIPART", 0

MailStr_KwBoundary:: ; 0F:422C
	db "BOUNDARY=", 0
POPC

; ---- text $4236-$4247 (17 bytes) [PROBABLE] ASCII string "=?ISO-2022-JP?B?" + NUL (MIME encoded-word prefix), copied by 0F:5104 (ld hl,$4236 ; ld a,[hli] ; and a ; jr z ; ld [de],a)

PUSHC sjis
MailStr_EncodedWordPrefix:: ; 0F:4236
String_0F_4236::
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
.l4286 ; 0F:4286
	ld a, [de]
	and a, a
	jr z, .l42A8
	ld h, a
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .l4296
	ld a, h
	cp a, $80
	jr nc, .l42B2
.l4296 ; 0F:4296
	ld a, h
	cp a, $0D
	jr z, .l42BF
	xor a, a
	ld [wMail_Selector], a
.l429F ; 0F:429F
	inc e
	call z, Mail_ScanHeaders_NextPage
	dec bc
	ld a, b
	or a, c
	jr nz, .l4286

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
.l42BF ; 0F:42BF
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
	jr nz, .l42D8
	ld a, h
	cp a, $80
	jr nc, .l42B2
.l42D8 ; 0F:42D8
	ld a, h
	cp a, $0A
	jr nz, .l42B2
	ld a, [wMail_Work + $03]
	and a, a
	jr nz, .l4311
	ld a, [wMail_Selector]
	and a, a
	jr nz, .l430D
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
	jr z, .l429F
	cp a, $09
	jr z, .l429F
	jr .l4286
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

.l430D ; 0F:430D
	; [CONFIRMED] 44 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	xor a, a
	ld [wMail_Selector], a
.l4311 ; 0F:4311
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
	jp nz, .l4286
	ld a, $01
	ld [wMail_Selector], a
	jp .l429F

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
	jr z, .l4364
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

.l4364 ; 0F:4364
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
	jr z, .l4385

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	xor a, a
	ld b, $02
	pop hl
	pop hl
	jp Mail_Return

.l4385 ; 0F:4385
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
.l4398 ; 0F:4398
	ld de, wMail_TextBuf1
.l439B ; 0F:439B
	ld a, [hli]
	and a, a
	jr z, .l43B1
	ld b, a
	ld a, [de]
	inc de
	cp a, b
	jr z, .l439B
.l43A5 ; 0F:43A5
	ld a, [hli]
	and a, a
	jr nz, .l43A5
	ld a, [hl]
	and a, a
	jr nz, .l4398
	ld b, a
	jp Mail_Return
.l43B1 ; 0F:43B1
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
Function_0F_4416::
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
	jr .l444E
.l442F ; 0F:442F
	ld a, [de]
	and a, a
	jp z, .l44C6
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0D
	jr nz, .l442F
	ld a, [de]
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0A
	jr nz, .l442F
	ld a, [de]
	cp a, $2E
	jr z, .l44B2
	cp a, $0D
	jr z, .l44BC
.l444E ; 0F:444E
	ld a, [wMail_InputBank]
	ld [wMail_Selector], a
	ld a, [de]
	and a, a
	jr z, .l44C6
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $61
	jr c, .l4466
	cp a, $7B
	jr nc, .l4466
	sub a, $20
.l4466 ; 0F:4466
	ld b, a
	ld a, [hl]
	and a, a
	jr z, .l447A
	cp a, b
	jr nz, .l4472
	inc c
	inc hl
	jr .l444E
.l4472 ; 0F:4472
	ld a, c
	and a, a
	jr z, .l442F
	dec c
	dec hl
	jr .l4472
.l447A ; 0F:447A
	ld a, $20
	cp a, b
	jr z, .l4485

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, $0A
	cp a, b
	jr z, .l4485
	dec de

.l4485 ; 0F:4485
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 16 scenarios]
	ld h, d
	ld l, e
	ld bc, $0000
.l448A ; 0F:448A
	ld a, [de]
	and a, a
	jr z, .l44C6
	inc bc
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0D
	jr nz, .l448A
	ld a, [de]
	inc bc
	inc e
	call z, Mail_FindHeader_NextPage
	cp a, $0A
	jr nz, .l448A
	ld a, [de]
	cp a, $20
	jr z, .l448A
	cp a, $09
	jr z, .l448A
	ld d, h
	ld e, l
	ld a, [wMail_Selector]
	ld h, a
	xor a, a
	ret

.l44B2 ; 0F:44B2
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	inc e
	call z, Mail_FindHeader_NextPage
	ld a, [de]
	cp a, $0D
	jp nz, .l442F

.l44BC ; 0F:44BC
	; [CONFIRMED] 74 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	inc e
	call z, Mail_FindHeader_NextPage
	ld a, [de]
	cp a, $0A
	jp nz, .l442F
.l44C6 ; 0F:44C6
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
	jr z, .l4515
	ld a, $01
	ld [wMail_Work + $0D], a
	call Mail_ParseMultipart
	and a, a
	jr nz, .l455F
	jr .l4520
.l4515 ; 0F:4515
	call Mail_ParseSinglePart
	and a, a
	jr nz, .l455F
	ld a, $02
	ld [wMail_Work + $0D], a
.l4520 ; 0F:4520
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
	ld [wRam_D00F], a
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
	jr z, .l45C3
	ld a, b
	and a, a
	jr nz, .l45BE
	ld a, h
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, $421C
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

.l45C3 ; 0F:45C3
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, $01
	ld [wRam_D00F], a
	ret

Mail_ParseMultipartBoundary:: ; 0F:45C9
	ld hl, wMail_TextBuf1
	ld de, MailStr_KwMultipart
	ld c, $00
.l45D1 ; 0F:45D1
	ld a, [hli]
	and a, a
	jr z, .l45F3
	cp a, $20
	jr z, .l45D1
	cp a, $0D
	jr z, .l45FC
	cp a, $61
	jr c, .l45E7
	cp a, $7B
	jr nc, .l45E7
	sub a, $20
.l45E7 ; 0F:45E7
	ld b, a
	ld a, [de]
	and a, a
	jr z, .l4612
	inc de
	cp a, b
	jr z, .l45D1
	dec de
	jr .l45D1

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
.l45FC ; 0F:45FC
	ld a, [hli]
	and a, a
	jr z, .l45F7
	cp a, $0A
	jr nz, .l45F7
	ld a, [hli]
	and a, a
	jr z, .l45F7
	cp a, $20
	jr z, .l45D1

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	cp a, $09
	jr z, .l45D1
	jr .l45F7

.l4612 ; 0F:4612
	; [CONFIRMED] 73 insn(s) executed; cut out of the PROBABLE region 4247-47A5 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, c
	and a, a
	jr nz, .l461D
	ld c, $01
	ld de, $422C
	jr .l45D1
.l461D ; 0F:461D
	dec hl
	ld a, [hl]
	cp a, $22
	jr nz, .skip
	inc hl
.skip ; 0F:4624
	ld de, wMail_TextBuf2 + $01
	ld b, $00
	ld c, $40
.l462B ; 0F:462B
	ld a, [hli]
	cp a, $22
	jr z, .l463A
	cp a, $0D
	jr z, .l463A
	ld [de], a
	inc de
	inc b
	dec c
	jr nz, .l462B
.l463A ; 0F:463A
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
.l464C ; 0F:464C
	ld a, [de]
	ld c, a
	ld a, [hli]
	cp a, c
	jr nz, .l468E
	inc e
	call z, Mail_MatchBoundary_NextPage
	dec b
	jr nz, .l464C
	ld a, [de]
	cp a, $2D
	jr z, .l4677
	cp a, $0D
	jr nz, .l468E
	xor a, a
	ld [wRam_D010], a
.l4666 ; 0F:4666
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .l468E
	inc e
	call z, Mail_MatchBoundary_NextPage
	xor a, a
	pop hl
	pop hl
	ret
.l4677 ; 0F:4677
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, [de]
	cp a, $2D
	jr nz, .l468E
	inc e
	call z, Mail_MatchBoundary_NextPage
	ld a, $01
	ld [wRam_D010], a
	ld a, [de]
	cp a, $0D
	jr z, .l4666

.l468E ; 0F:468E
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	pop de
	pop af
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld [wRam_D010], a
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
	jr nz, .l46EC
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
	jr nz, .l46EC
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
.l46EC ; 0F:46EC
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l46F9
	ld a, $01
	ld [wRam_D016], a
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
	jp nz, .l4792
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
	jp nz, .l47BB
.loop ; 0F:473B
	call Mail_FindPartName
	cp a, $01
	jr nz, .l474D

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4247-47A5 by apply_coverage --split
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l4798
	ld a, $01
	ld [wRam_D016], a

.l474D ; 0F:474D
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
	jr nz, .l47BB
	ld a, [wMail_Work + $0E]
	cp a, $03
	jr nz, .l4777
	dec bc
	dec bc
.l4777 ; 0F:4777
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
.l4792 ; 0F:4792
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
	ld a, [wRam_D010]
	and a, a
	jr z, .loop
	jr .l47CF

	; [HYPOTHESIS] 10 insn (ld hl,$D003 ; ld a,[hli] ; ld [$D000],a ; ldh [$FF8C],a ; ld [$4000],a ;
	; call $4A7E ; and a ; jr z,$47CF ; xor a ; ld [$D016],a) flowing straight into the PROBABLE
	; code at 47BB; call target 4A7E is called elsewhere (0F:46D8) and the jr target is a valid
	; start; it directly follows the unconditional jr $47CF at 47A3, so it must be a
	; branch/jump-table target that was not found; entry unproven
	ld hl, wMail_Work + $03
	ld a, [hli]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call Mail_FindMessageEnd
	and a, a
	jr z, .l47CF
	xor a, a
	ld [wRam_D016], a

.l47BB ; 0F:47BB
	; [PROBABLE] 722 insn(s) reached by static flow only; seeds: mobile x722; min discovery hops 0;
	; entered by jpcc from 0F:4738 (PROBABLE code) | 9 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 47BB-4C59 by apply_coverage --split
	ld a, [wMail_ErrorFlag]
	and a, a
	jr z, .l4798
	ld a, $01
	ld [wRam_D016], a
	ld a, [wMail_Work + $0D]
	cp a, $01
	jr nz, .l4777
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
	jr nz, .l4810
.l47DA ; 0F:47DA
	ld a, [de]
	and a, a
	jr z, .l4833
	inc e
	call z, Mail_FindBoundary_NextPage
	inc bc
	cp a, $0D
	jr nz, .l47DA
	ld a, [de]
	cp a, $0A
	jr nz, .l4833
.l47EC ; 0F:47EC
	inc bc
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $20
	jr z, .l482B
	cp a, $09
	jr z, .l482B
	cp a, $0D
	jr nz, .l482F
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .l4833
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, h
	and a, a
	jr z, .l4810

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	dec bc

.l4810 ; 0F:4810
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	ld a, [de]
	cp a, $2D
	jr nz, .l47DA
	inc e
	call z, Mail_FindBoundary_NextPage
	ld a, [de]
	cp a, $2D
	jr nz, .l47DA
	inc e
	call z, Mail_FindBoundary_NextPage
	push bc
	call Mail_MatchBoundary
	pop bc
	and a, a
	jr nz, .l47DA
	ret

.l482B ; 0F:482B
	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld h, $01
	jr .l47EC

.l482F ; 0F:482F
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 4 scenarios]
	ld h, $00
	jr .l4810

.l4833 ; 0F:4833
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
	jr nz, .l4863
	pop de
	pop af
	ld [wMail_InputBank], a
	ld hl, $421C
	call Mail_FindKeywordValue
	ret

.l4863 ; 0F:4863
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	pop de
	pop af
	ld [wMail_InputBank], a
	ld a, $01
	ret

Mail_PartRec_EmitHeaderBlock:: ; 0F:486B
Function_0F_486B::
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
Function_0F_48BD::
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitLengthAndPart:: ; 0F:48C6
Function_0F_48C6::
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
	jr nz, .l4908

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

.l4908 ; 0F:4908
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
	jr z, .l4936
	ld d, $06
	jr .l4938

.l4936 ; 0F:4936
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	ld d, $0A

.l4938 ; 0F:4938
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 6 scenarios]
	dec bc
	ld a, b
	or a, c
	jr z, .l4945
	dec d
	jr nz, .l4938
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
Function_0F_4948::
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitPart:: ; 0F:4951
Function_0F_4951::
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
	jr nz, .l4987
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
.l4987 ; 0F:4987
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
	jr z, .l49B5
	ld d, $04
	jr .l49B7
.l49B5 ; 0F:49B5
	ld d, $08
.l49B7 ; 0F:49B7
	dec bc
	ld a, b
	or a, c
	jr z, .l49C4
	dec d
	jr nz, .l49B7
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
Function_0F_49C7::
	push bc
	ld bc, wMail_OutputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_PartRec_EmitLength:: ; 0F:49D0
Function_0F_49D0::
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
Function_0F_4A13::
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
.l4A20 ; 0F:4A20
	inc bc
	ld a, [de]
	and a, a
	jr z, .l4A6A
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	cp a, $0D
	jr nz, .l4A20
	ld a, [de]
	cp a, $0A
	jr nz, .l4A6A
.l4A32 ; 0F:4A32
	inc bc
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, [de]
	cp a, $20
	jr z, .l4A62
	cp a, $09
	jr z, .l4A62
	cp a, $0D
	jr nz, .l4A66
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, [de]
	cp a, $0A
	jr nz, .l4A6A
	inc e
	call z, Mail_SkipHeaderBlock_NextPage
	ld a, h
	and a, a
	jr z, .l4A56

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	dec bc

.l4A56 ; 0F:4A56
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
.l4A62 ; 0F:4A62
	ld h, $01
	jr .l4A32
.l4A66 ; 0F:4A66
	ld h, $00
	jr .l4A20

.l4A6A ; 0F:4A6A
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
	jr z, .l4ABF
	inc e
	call z, Mail_FindMessageEnd_NextPage
	cp a, $0D
	jr nz, .loop
	ld a, [de]
	cp a, $0A
	jr nz, .l4ABF
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
	jr nz, .l4ABF
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

.l4ABF ; 0F:4ABF
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
.l4AD5 ; 0F:4AD5
	ld a, [hl]
	ld b, a
	ld a, [de]
	inc e
	call z, Mail_FindKeywordValue_NextPage
	cp a, $61
	jr c, .l4AE6
	cp a, $7B
	jr nc, .l4AE6
	sub a, $20
.l4AE6 ; 0F:4AE6
	cp a, b
	jr z, .l4AF8
	pop bc
	dec bc
	push bc
	ld a, b
	or a, c
	jr nz, .l4AD5
.l4AF0 ; 0F:4AF0
	ld a, $02
	ld [wMail_Work + $0E], a
	pop bc
	pop hl
	ret
.l4AF8 ; 0F:4AF8
	inc hl
.l4AF9 ; 0F:4AF9
	ld a, [hli]
	and a, a
	jr z, .l4B1D
	ld b, a
	ld a, [de]
	inc e
	call z, Mail_FindKeywordValue_NextPage
	cp a, $61
	jr c, .l4B0D
	cp a, $7B
	jr nc, .l4B0D
	sub a, $20
.l4B0D ; 0F:4B0D
	cp a, b
	jr nz, .l4B19
	pop bc
	dec bc
	push bc
	ld a, b
	or a, c
	jr nz, .l4AF9

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	jr .l4AF0

.l4B19 ; 0F:4B19
	; [CONFIRMED] 39 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 2 scenarios]
	pop bc
	pop hl
	jr Mail_FindKeywordValue
.l4B1D ; 0F:4B1D
	ld b, $00
	ld c, $40
	ld a, [de]
	cp a, $22
	jr nz, .l4B2A
	inc e
	call z, Mail_FindKeywordValue_NextPage
.l4B2A ; 0F:4B2A
	ld hl, wMail_KeywordValue
	ld a, [wMail_InputBank]
	ld [hli], a
	ld [hl], e
	inc hl
	ld [hl], d
	inc hl
.l4B35 ; 0F:4B35
	ld a, [de]
	cp a, $22
	jr z, .l4B46
	cp a, $0D
	jr z, .l4B46
	inc e
	call z, Mail_FindKeywordValue_NextPage
	inc b
	dec c
	jr nz, .l4B35
.l4B46 ; 0F:4B46
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
.l4B69 ; 0F:4B69
	push de
	push bc
	push hl
	call Mail_FindHeader
	cp a, $02
	jr z, .l4BB6
	and a, a
	jr nz, .l4B90
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
.l4B86 ; 0F:4B86
	pop bc
	pop de
	inc b
	ld a, b
	cp a, $0D
	jr z, .l4B9A
	jr .l4B69
.l4B90 ; 0F:4B90
	pop hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	jr .l4B86
.l4B9A ; 0F:4B9A
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
.l4C1C ; 0F:4C1C
	ld a, [hli]
	cp a, $0D
	jr z, .l4C38
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .l4C1C
.l4C28 ; 0F:4C28
	xor a, a
	ld [de], a
	ld hl, wMail_TextBuf1
	ld bc, $0000
.l4C30 ; 0F:4C30
	ld a, [hli]
	inc bc
	and a, a
	jr nz, .l4C30
	dec bc
	xor a, a
	ret
.l4C38 ; 0F:4C38
	dec bc
	ld a, b
	or a, c
	jr z, .l4C28
	ld a, [hli]
	cp a, $0A
	jr nz, .l4C1C
	dec bc
	ld a, b
	or a, c
	jr z, .l4C28
	ld a, [hli]
	cp a, $20
	jr z, .l4C52
	cp a, $09
	jr z, .l4C52

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47BB-4C59 by apply_coverage --split
	jr .l4C28

.l4C52 ; 0F:4C52
	; [CONFIRMED] 5 insn(s) executed; cut out of the PROBABLE region 47BB-4C59 by apply_coverage
	; --split [executed in 1 scenarios]
	dec bc
	ld a, b
	or a, c
	jr z, .l4C28
	jr .l4C1C

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
.l4C66 ; 0F:4C66
	ld a, [hli]
	ld [de], a
	inc de
	and a, a
	jr z, .l4CCA
	cp a, $3D
	jr nz, .l4C66
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $3F
	jr nz, .l4C66
	dec de
	dec de
.l4C79 ; 0F:4C79
	ld a, [hli]
	cp a, $3F
	jr nz, .l4C79
	ld a, [hli]
	cp a, $42
	jr nz, .l4CBC
	inc hl
	ld bc, $0000
	push hl
.l4C88 ; 0F:4C88
	inc bc
	ld a, [hli]
	cp a, $3F
	jr nz, .l4C88
	inc bc
	ld a, [hli]
	cp a, $3D
	jr nz, .l4C88
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
.l4CAA ; 0F:4CAA
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .l4CAA
	ld a, [wMail_Work + $03]
	ld l, a
	ld a, [wMail_Work + $04]
	ld h, a
	jr .l4C66
.l4CBC ; 0F:4CBC
	ld a, $3D
	ld [de], a
	inc de
	ld a, $3F
	ld [de], a
	inc de
.l4CC4 ; 0F:4CC4
	ld a, [hli]
	ld [de], a
	inc de
	and a, a
	jr nz, .l4CC4
.l4CCA ; 0F:4CCA
	ld [de], a
	pop hl
	ld de, wMail_TextBuf2
	ld bc, $0000
.l4CD2 ; 0F:4CD2
	inc bc
	ld a, [de]
	ld [hli], a
	inc de
	and a, a
	jr z, .l4CDB
	jr .l4CD2
.l4CDB ; 0F:4CDB
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
	jr nz, .l4D4E
	ld a, [de]
	cp a, $28
	jr z, .l4D59
	cp a, $22
	jr z, .l4D59
	jr .l4D83
.l4D4E ; 0F:4D4E
	ld a, [de]
	cp a, $29
	jr z, .l4D63
	cp a, $22
	jr z, .l4D73
	jr .l4D88
.l4D59 ; 0F:4D59
	ld [wMail_Work + $03], a
	ld a, $01
	ld [wMail_Work + $04], a
	jr .l4D88
.l4D63 ; 0F:4D63
	ld a, [wMail_Work + $03]
	cp a, $28
	jr nz, .l4D88
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	jr .l4D88
.l4D73 ; 0F:4D73
	ld a, [wMail_Work + $03]
	cp a, $22
	jr nz, .l4D88
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	jr .l4D88
.l4D83 ; 0F:4D83
	cp a, $20
	jr z, .l4D88
	ld [hli], a
.l4D88 ; 0F:4D88
	dec bc
	ld a, b
	or a, c
	jr z, .l4D9A
	inc e
	jr nz, Mail_StripCommentsAndSpaces
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	jr Mail_StripCommentsAndSpaces
.l4D9A ; 0F:4D9A
	xor a, a
	ld [hli], a
	ret

Mail_ExtractAddresses:: ; 0F:4D9D
	ld de, wMail_TextBuf2
	xor a, a
	ld [de], a
.l4DA2 ; 0F:4DA2
	ld a, [hli]
	call Mail_SkipJisEscape
	and a, a
	jr z, .l4DE2
	cp a, $40
	jr nz, .l4DA2
	dec hl
.l4DAE ; 0F:4DAE
	dec hl
	ld a, [hl]
	call Mail_ClassifyAddressChar
	and a, a
	jr z, .l4DAE
	inc hl
	push hl
	ld b, $00
.l4DBA ; 0F:4DBA
	ld a, [hli]
	cp a, $40
	jr z, .l4DC5
	call Mail_ClassifyAddressChar
	and a, a
	jr nz, .l4DC8
.l4DC5 ; 0F:4DC5
	inc b
	jr .l4DBA
.l4DC8 ; 0F:4DC8
	pop hl
	ld a, [wRam_D624]
	and a, a
	jr z, .l4DD6
	ld a, $2C
	inc de
	ld [de], a
	ld a, [wRam_D624]
.l4DD6 ; 0F:4DD6
	inc a
	ld [wRam_D624], a
.l4DDA ; 0F:4DDA
	inc de
	ld a, [hli]
	ld [de], a
	dec b
	jr nz, .l4DDA
	jr .l4DA2
.l4DE2 ; 0F:4DE2
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
	jr z, .l4E2F
	cp a, $24
	jr nz, .l4E0D
	ld a, [hli]
	and a, a
	jr z, .l4E2F
	cp a, $42
	jr z, .l4E0F
	cp a, $40
	jr z, .l4E0F
	dec hl
.l4E0D ; 0F:4E0D
	dec hl
	ret
.l4E0F ; 0F:4E0F
	ld a, [hli]
	and a, a
	jr z, .l4E2F
	cp a, $1B
	jr nz, .l4E0F
	ld a, [hli]
	and a, a
	jr z, .l4E2F
	cp a, $28
	jr nz, .l4E0F
	ld a, [hli]
	and a, a
	jr z, .l4E2F
	cp a, $42
	jr z, .l4E2D
	cp a, $4A
	jr z, .l4E2D
	jr .l4E0F
.l4E2D ; 0F:4E2D
	ld a, [hli]
	ret
.l4E2F ; 0F:4E2F
	xor a, a
	ret

Mail_ClassifyAddressChar:: ; 0F:4E31
	cp a, $30
	jr c, .l4E49
	cp a, $40
	jr c, .l4E5C
	cp a, $41
	jr c, .l4E49
	cp a, $5B
	jr c, .l4E5C
	cp a, $61
	jr c, .l4E49
	cp a, $7B
	jr c, .l4E5C
.l4E49 ; 0F:4E49
	cp a, $20
	jr z, .l4E5C
	cp a, $2D
	jr z, .l4E5C
	cp a, $2E
	jr z, .l4E5C
	cp a, $5F
	jr z, .l4E5C
.loop ; 0F:4E59
	ld a, $01
	ret
.l4E5C ; 0F:4E5C
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
	jr nz, .l4E73

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, [wMail_ComposeState]
	and a, a
	jp z, Mail_Return
	jr .l4E7A

.l4E73 ; 0F:4E73
	; [CONFIRMED] 25 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	xor a, a
	ld [wMail_ComposeState], a
	call Mail_ComposeInit
.l4E7A ; 0F:4E7A
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
	jr nz, .l4F2A
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

.l4F2A ; 0F:4F2A
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
	jr nz, .l4F80
	ld a, [wMail_Work + $03]
	cp a, $11
	jr z, .l4FAB
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
.l4F80 ; 0F:4F80
	ld a, [wMail_Work + $03]
	cp a, $05
	jr c, .l4FCD
	jr z, .l4FF0
	cp a, $08
	jr c, .l4FA9
	jr z, .l4FF8
	cp a, $0B
	jr c, .l4FA9

	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	jr z, .l5000
	cp a, $0C
	jr z, .l500B
	cp a, $0D
	jr z, .l4FA9
	cp a, $10
	jr c, .l5019
	jr z, .l4FA9
	cp a, $12
	jr c, .l4FA9
	jr .l4FEB

.l4FA9 ; 0F:4FA9
	; [CONFIRMED] 2 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	xor a, a
	ret

.l4FAB ; 0F:4FAB
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

.l4FCD ; 0F:4FCD
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_EmitAddressListItem
	and a, a
	jr nz, .l4FEB
	ld a, [wMail_Work + $04]
	dec a
	ld [wMail_Work + $04], a
	and a, a
	jr z, .l4FE3

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	call Mail_FetchComposeItem
	and a, a
	jr nz, .l4FCD

.l4FE3 ; 0F:4FE3
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, [wRam_D005]
	ld [wMail_Work + $04], a
	jr .l5022

.l4FEB ; 0F:4FEB
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ld b, $83
	ret

.l4FF0 ; 0F:4FF0
	; [CONFIRMED] 8 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_EmitAddressListItem
	and a, a
	jr nz, .l4FEB
	jr .l5022
.l4FF8 ; 0F:4FF8
	call Mail_EmitGameCodeValue
	and a, a
	jr nz, .l4FEB
	jr .l5022

.l5000 ; 0F:5000
	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld hl, $4000
	call Mail_EmitStringAndSuffix
	and a, a
	jr nz, .l4FEB
	jr .l5022
.l500B ; 0F:500B
	call Mail_CopyItemToBuffer
	ld hl, wMail_TextBuf1
	call Mail_EmitStringAndSuffix
	and a, a
	jr nz, .l4FEB
	jr .l5022
.l5019 ; 0F:5019
	ld hl, $4000
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
	jr z, .l504A
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l505A
	inc e
	call z, Mail_EmitString_NextPage
	jr .loop
.l504A ; 0F:504A
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
	jr z, .l50B2
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
	jr z, .l509F

	; [PROBABLE] 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $02
	jr z, .l509C
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
	jr .l509F
.l509C ; 0F:509C
	ld a, $2C
	ld [hli], a

.l509F ; 0F:509F
	; [CONFIRMED] 7 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	call Mail_CopyFromSram
	call Mail_EncodeHeaderWords
	call Mail_EmitBufferToOutput
	ld a, [wMail_ComposeState]
	inc a
	cp a, $04
	jr nz, .l50B2

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $02

.l50B2 ; 0F:50B2
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
.l50BF ; 0F:50BF
	ld c, $00
	ld a, [hli]
	cp a, $1B
	jr z, .l50CD
	ld [de], a
	inc de
	and a, a
	jr z, .l5137
	jr .l50BF
.l50CD ; 0F:50CD
	inc c
	ld a, [hl]
	cp a, $24
	jr nz, .l50BF
	inc hl
	inc c
	ld a, [hl]
	cp a, $42
	jr z, .l50E0

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $40
	jr z, .l50E0
	jr .l50BF

.l50E0 ; 0F:50E0
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	push hl
.l50E1 ; 0F:50E1
	inc c
	ld a, [hli]
	and a, a
	jr z, .l5137
	cp a, $1B
	jr nz, .l50E1
	inc c
	ld a, [hli]
	cp a, $28
	jr nz, .l50E1
	inc c
	ld a, [hli]
	cp a, $42
	jr z, .l50FC

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $4A
	jr z, .l50FC
	jr .l50E1

.l50FC ; 0F:50FC
	; [CONFIRMED] 81 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 6 scenarios]
	ld a, l
	ld [wMail_Work + $13], a
	ld a, h
	ld [wMail_Work + $14], a
	ld hl, MailStr_EncodedWordPrefix
.l5107 ; 0F:5107
	ld a, [hli]
	and a, a
	jr z, .l510F
	ld [de], a
	inc de
	jr .l5107
.l510F ; 0F:510F
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
.l511D ; 0F:511D
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, .l511D
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
	jr .l50BF
.l5137 ; 0F:5137
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
	jr z, .l5161
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5171
	inc e
	call z, Mail_EmitBufferToOutput_NextPage
	jr .loop
.l5161 ; 0F:5161
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
	jr nc, .l51DC
	add a, $30
	jr .l51DE

.l51DC ; 0F:51DC
	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	add a, $37

.l51DE ; 0F:51DE
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
	jr nc, .l51F6
	add a, $30
	jr .l51F8

.l51F3 ; 0F:51F3
	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $01
	ret
.l51F6 ; 0F:51F6
	add a, $37

.l51F8 ; 0F:51F8
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
.l5231 ; 0F:5231
	ld a, [hli]
	and a, a
	jr z, .l5241
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	jr .l5231
.l5241 ; 0F:5241
	ld a, [wMail_Work + $03]
	cp a, $0B
	jr z, .l527C
	cp a, $0C
	jr z, .l527C
	cp a, $0E
	jr z, .l5256
	cp a, $0F
	jr z, .l5269
	jr .l5266
.l5256 ; 0F:5256
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
.l5269 ; 0F:5269
	ld h, $02
.l526B ; 0F:526B
	ld a, $2D
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	dec h
	jr nz, .l526B
	jr .l5256
.l527C ; 0F:527C
	ld a, $22
	ld [de], a
	dec bc
	ld a, b
	or a, c
	jr z, .l5266
	inc e
	call z, Mail_EmitStringAndSuffix_NextPage
	jr .l5256

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
Function_0F_52BC::
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
.l52CE ; 0F:52CE
	ld hl, wMail_ItemListPointer
	ld e, [hl]
	inc hl
	ld d, [hl]
.l52D4 ; 0F:52D4
	ld a, [wMail_Work + $03]
	cp a, $03
	jr nz, .skip
	push de
.skip ; 0F:52DC
	cp a, $05
	jr nz, .l52EB
	pop hl
	ld a, [hli]
	ld b, a
	ld c, $03
	call Mail_ComposeHeaderBlock_BuildAddressList
	and a, a
	jr nz, .l52FD
.l52EB ; 0F:52EB
	ld a, [de]
	inc de
	and a, a
	jr nz, .l5305
	ld a, [wMail_Work + $03]
	cp a, $06
	jr z, .l5339
	inc a
	ld [wMail_Work + $03], a
	jr .l52D4
.l52FD ; 0F:52FD
	pop hl
	ld a, $01
	ld b, $83
	jp Mail_Return
.l5305 ; 0F:5305
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
.l530B ; 0F:530B
	ld [wRam_D005], a
	ld a, $01
	ld [wMail_Work + $04], a
	call Mail_ComposeHeaderBlock_FetchItem
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l52FD
	ld a, [wRam_D005]
	dec a
	jr nz, .l530B
	ld a, [wMail_Work + $03]
	inc a
	ld [wMail_Work + $03], a
	call Mail_EmitCrLf
	and a, a
	jr nz, .l52FD
	ld [wRam_D023], a
	ld a, [wMail_Work + $03]
	cp a, $06
	jr nz, .l52CE
.l5339 ; 0F:5339
	call Mail_ComposeHeaderBlock_FetchItem
	xor a, a
	ld [wRam_D023], a
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
	jr nz, .l5339
	pop bc
	ld a, b
	and a, a
	jr z, .l536F
	call Mail_ComposeHeaderBlock_FetchItem
	xor a, a
	ld [wRam_D023], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l52FD
	call Mail_EmitCrLf
	and a, a
	jr nz, .l52FD
.l536F ; 0F:536F
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
Function_0F_5381::
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
	ld [wRam_D023], a
	ret

Mail_ComposeHeaderBlock_FetchItem:: ; 0F:53B9
Function_0F_53B9::
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
	ld [wRam_D00F], a
	inc de
	ld hl, wMail_ItemListPointer
	ld [hl], e
	inc hl
	ld [hl], d
	ret

Mail_ComposeHeaderBlock_BuildAddressList:: ; 0F:53D6
Function_0F_53D6::
	ld a, [wMail_Work + $03]
	ld d, a
	ld a, [wMail_Work + $04]
	ld e, a
	push de
	xor a, a
	ld [wMail_Work + $03], a
	ld [wMail_Work + $04], a
	ld a, $24
	ld [wRam_D013], a
	ld a, $D0
	ld [wRam_D014], a
	push bc
	jr .l53F8
.l53F3 ; 0F:53F3
	ld a, [hli]
	and a, a
	jr z, .l542A
	ld b, a
.l53F8 ; 0F:53F8
	push bc
.l53F9 ; 0F:53F9
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
	ld a, [wRam_D013]
	ld l, a
	ld a, [wRam_D014]
	ld h, a
	push bc
	ld b, $00
	call Mail_CopyFromSram
	inc hl
	ld [hl], a
	pop bc
	ld a, l
	ld e, a
	ld [wRam_D013], a
	ld a, h
	ld d, a
	ld [wRam_D014], a
	dec b
	jr z, .l542F
	pop hl
	jr .l53F9
.l542A ; 0F:542A
	dec c
	jr nz, .l53F3
	jr .l5434
.l542F ; 0F:542F
	pop hl
	pop bc
	dec c
	jr nz, .l53F3
.l5434 ; 0F:5434
	ld a, l
	ld [wRam_D013], a
	ld a, h
	ld [wRam_D014], a
	xor a, a
	ld [de], a
	ld hl, wMail_TextBuf1
.l5441 ; 0F:5441
	ld a, [hli]
	and a, a
	jr nz, .l5441
	ld a, [hl]
	and a, a
	jr z, .l545B
	dec hl
	ld a, $2C
	ld [hli], a
	jr .l5441
.l544F ; 0F:544F
	pop hl
	ld a, h
	ld [wMail_Work + $03], a
	ld a, l
	ld [wMail_Work + $04], a
	ld a, $01
	ret
.l545B ; 0F:545B
	ld hl, wMail_TextBuf1
	call Mail_ExtractAddresses
	ld hl, wMail_TextBuf2 + $01
.l5464 ; 0F:5464
	ld a, [hli]
	and a, a
	jr z, .l5471
	cp a, $2C
	jr nz, .l5464
	dec hl
	xor a, a
	ld [hli], a
	jr .l5464
.l5471 ; 0F:5471
	pop de
	ld a, e
	cp a, $01
	jr z, .l547B
	xor a, a
	ld [hli], a
	jr .l547C
.l547B ; 0F:547B
	dec bc
.l547C ; 0F:547C
	ld hl, wMail_Work + $18
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, b
	cp a, h
	jr c, .l5490
	jr nz, .l544F
	ld a, c
	cp a, l
	jr c, .l5490
	jr z, .l5490
	jr .l544F
.l5490 ; 0F:5490
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
	ld a, [wRam_D013]
	ld e, a
	ld a, [wRam_D014]
	ld d, a
	pop hl
	ld a, h
	ld [wMail_Work + $03], a
	ld a, l
	ld [wMail_Work + $04], a
	xor a, a
	ret

Mail_ComposeMimeBody:: ; 0F:54D8
Function_0F_54D8::
	xor a, a
	ld [wRam_D023], a
	call Mail_ComposeMimeBody_LoadArgs
	call Mail_ComposeMimeBody_CopyData
	and a, a
	jr nz, .l5541
	call Mail_ComposeMimeBody_NextPart
	ld a, [wRam_D015]
	dec a
	ld [wRam_D015], a
	and a, a
	jp z, .l558C
	cp a, $01
	jr nz, .l5546
	xor a, a
	ld [wRam_D01C], a
.l54FB ; 0F:54FB
	ld a, [wRam_D016]
	cp a, $02
	jr z, .l5506
	cp a, $03
	jr z, .l5513
.l5506 ; 0F:5506
	ld a, $0A
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr z, .l552F
	jr .l5541
.l5513 ; 0F:5513
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
.l552F ; 0F:552F
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	call Mail_ComposeMimeBody_CopyData
	and a, a
	jr z, .l55B5
.l5541 ; 0F:5541
	ld a, $01
	jp Mail_Return
.l5546 ; 0F:5546
	ld a, $01
	ld [wRam_D01C], a
	ld a, $0B
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
.l555C ; 0F:555C
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
	jr .l54FB
.l5575 ; 0F:5575
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
	ld a, [wRam_D01C]
	and a, a
	jr z, .l5592
	ld a, $0F
	ld [wMail_Work + $03], a
	call Mail_EmitHeaderField
	and a, a
	jr nz, .l5541
.l558C ; 0F:558C
	call Mail_EmitCrLf
	and a, a
	jr nz, .l5541
.l5592 ; 0F:5592
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
.l55B5 ; 0F:55B5
	ld a, [wRam_D015]
	dec a
	ld [wRam_D015], a
	and a, a
	jr z, .l5575
	call Mail_ComposeMimeBody_NextPart
	jr .l555C

Mail_ComposeMimeBody_LoadArgs:: ; 0F:55C4
Function_0F_55C4::
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
	ld [wRam_D015], a
	inc de
	ld a, e
	ld [hli], a
	ld [hl], d
	call Mail_ComposeMimeBody_NextPart
	ret

Mail_ComposeMimeBody_NextPart:: ; 0F:55E6
Function_0F_55E6::
	ld a, [wRam_D00D]
	ld l, a
	ld a, [wRam_D00E]
	ld h, a
	ld a, [hli]
	ld [wRam_D016], a
	cp a, $03
	jr nz, .l5605
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
	ld [wRam_D00F], a
.l5605 ; 0F:5605
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
	ld [wRam_D00D], a
	ld a, h
	ld [wRam_D00E], a
	ret

Mail_ComposeMimeBody_CopyData:: ; 0F:561F
Function_0F_561F::
	ld a, [wRam_D006]
	ld [wMail_OutputBank], a
	ld a, [wRam_D017]
	ld [wMail_InputBank], a
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, wMail_Work + $1A
	ld c, [hl]
	inc hl
	ld b, [hl]
	ld a, [wRam_D00A]
	cp a, b
	jp c, .l56C6
	jr nz, .l5646
	ld a, [wRam_D009]
	cp a, c
	jp c, .l56C6
.l5646 ; 0F:5646
	ld a, b
	or a, c
	jr z, .l56BE
	ld a, [wRam_D009]
	ld l, a
	ld a, [wRam_D00A]
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
	ld [wRam_D009], a
	ld a, h
	ld [wRam_D00A], a
.loop ; 0F:5662
	ld a, $0E
	cp a, b
	jr c, .l56CB
	jr nz, .l566E
	ld a, $00
	cp a, c
	jr c, .l56CB
.l566E ; 0F:566E
	ld a, [wRam_D01A]
	ld e, a
	ld a, [wRam_D01B]
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
	ld [wRam_D01A], a
	ld a, h
	ld [wRam_D01B], a
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
.l56BE ; 0F:56BE
	ld a, [wMail_OutputBank]
	ld [wRam_D006], a
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
	jr .l566E

Mail_Base64EncodeStream:: ; 0F:56E1
Function_0F_56E1::
	ld a, [wMail_ComposeState]
	and a, a
	jp z, Mail_Return
	cp a, $02
	jr z, .l570F
	cp a, $03
	jr z, .l5712
	cp a, $04
	jr z, .l5712
	cp a, $05
	jr z, .l572B
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
.l570F ; 0F:570F
	call Mail_Base64EncodeStream_ClampChunk
.l5712 ; 0F:5712
	call Mail_Base64EncodeStream_Step
	and a, a
	jr nz, .l5740
	ld a, [wMail_ComposeState]
	cp a, $05
	jr z, .l572B
	ld a, [wMail_Work + $12]
	ld h, a
	ld a, [wMail_Work + $11]
	ld l, a
	xor a, a
	jp Mail_Return
.l572B ; 0F:572B
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
Function_0F_5747::
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
Function_0F_5771::
	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld e, $10
	ld b, $00
	ld c, b
	ld d, b
	ld a, $03
.l577F ; 0F:577F
	rl l
	rl h
	rl d
	cp a, d
	jr c, .l5791
	rl c
	rl b
	dec e
	jr nz, .l577F
	jr .l579F
.l5791 ; 0F:5791
	ld a, d
	sub a, $03
	ld d, a
	ld a, $03
	scf
	rl c
	rl b
	dec e
	jr nz, .l577F
.l579F ; 0F:579F
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
.l57B7 ; 0F:57B7
	rl l
	rl h
	rl d
	cp a, d
	jr c, .l57C9
	rl c
	rl b
	dec e
	jr nz, .l57B7
	jr .l57D8
.l57C9 ; 0F:57C9
	ld a, d
	sub a, $40
	ld d, a
	ld a, $40
	scf
	rl c
	rl b
	dec e
	jr nz, .l57B7
	inc bc
.l57D8 ; 0F:57D8
	and a, a
	sla c
	rl b
	pop hl
	add hl, bc
	ld a, $02
	ld [wRam_D023], a
	ret

Mail_Base64EncodeStream_ClampChunk:: ; 0F:57E5
Function_0F_57E5::
	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wRam_D00E]
	ld c, a
	ld a, [wRam_D00F]
	ld b, a
	cp a, h
	jr c, .l5800
	jr nz, .l57FE
	ld a, c
	cp a, l
	jr c, .l5800
	jr z, .l5800
.l57FE ; 0F:57FE
	ld b, h
	ld c, l
.l5800 ; 0F:5800
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
	ld [wRam_D005], a
	ld a, h
	ld [wRam_D006], a
	ld a, h
	or a, l
	jr nz, .l5824
	pop bc
	ld a, c
	ld [wRam_D00E], a
	ld a, b
	ld [wRam_D00F], a
	ld a, $04
	ld [wRam_D023], a
	ret
.l5824 ; 0F:5824
	pop bc
	ld a, c
	ld [wRam_D00E], a
	ld a, b
	ld [wRam_D00F], a
	ld a, $03
	ld [wRam_D023], a
	ret

Mail_Base64EncodeStream_Step:: ; 0F:5833
Function_0F_5833::
	ld a, [wRam_D023]
	and a, a
	ret z
	ld a, [wRam_D00E]
	ld c, a
	ld a, [wRam_D00F]
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
	ld a, [wRam_D00A]
	ld l, a
	ld a, [wRam_D00B]
	ld h, a
	cp a, b
	jr c, .l58D0
	jr nz, .l5883
	ld a, l
	cp a, c
	jr c, .l58D0
.l5883 ; 0F:5883
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
	ld [wRam_D00A], a
	ld a, h
	ld [wRam_D00B], a
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
	ld a, [wRam_D023]
	cp a, $03
	jr z, .l58C9
	cp a, $04
	jr z, .l58C2
	jr .l58D1
.l58C2 ; 0F:58C2
	ld a, $05
	ld [wRam_D023], a
	jr .l58CE
.l58C9 ; 0F:58C9
	ld a, $02
	ld [wRam_D023], a
.l58CE ; 0F:58CE
	xor a, a
	ret
.l58D0 ; 0F:58D0
	pop hl
.l58D1 ; 0F:58D1
	ld a, $FF
	ld [wRam_D023], a
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
.l58FA ; 0F:58FA
	ld b, $03
	push hl
	ld hl, wMail_Work + $1B
.l5900 ; 0F:5900
	ld a, [de]
	inc de
	ld [hli], a
	dec b
	jr nz, .l5900
	ld a, [wMail_Work + $19]
	ld c, a
	ld a, [wMail_Work + $1A]
	ld b, a
	xor a, a
	or a, b
	jr nz, .l5929
	ld a, $02
	cp a, c
	jr c, .l5929
	push hl
	dec hl
	ld a, c
	ld [wMail_Work + $1F], a
.l591D ; 0F:591D
	xor a, a
	ld [hld], a
	inc c
	ld a, $03
	cp a, c
	jr nz, .l591D
	pop hl
	ld bc, $0003
.l5929 ; 0F:5929
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
	jr nz, .l59C6

	; [PROBABLE] 36 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	push af
	push bc
	ld a, [wRam_D019]
	ld b, a
	ld a, [wRam_D01A]
	or a, b
	jr nz, .l59AD
	ld a, [wRam_D005]
	ld b, a
	ld a, [wMail_Work + $06]
	or a, b
	jr nz, .l59AD
	pop bc
	pop af
	jr .l59D9
.l59AD ; 0F:59AD
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

.l59C6 ; 0F:59C6
	; [CONFIRMED] 29 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 2 scenarios]
	ld [wMail_Work + $22], a
	ld a, [wMail_Work + $19]
	cp a, $00
	jp nz, .l58FA
	ld a, [wMail_Work + $1A]
	cp a, $00
	jp nz, .l58FA
.l59D9 ; 0F:59D9
	ld a, [wMail_Work + $1F]
	cp a, $00
	jr z, .l59ED
	push hl
	dec hl
	ld b, a
.l59E3 ; 0F:59E3
	ld a, $3D
	ld [hld], a
	inc b
	ld a, $03
	cp a, b
	jr nz, .l59E3
	pop hl
.l59ED ; 0F:59ED
	ld a, $00
	ld [hl], a
	ret

Mail_Base64EncodeChar:: ; 0F:59F1
	cp a, $1A
	jr c, .l5A04
	cp a, $34
	jr c, .l5A07
	cp a, $3E
	jr c, .l5A0A

	; [PROBABLE] 4 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	cp a, $3E
	jr z, .l5A0D
	ld a, $2F
	ret

.l5A04 ; 0F:5A04
	; [CONFIRMED] 6 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 2 scenarios]
	add a, $41
	ret
.l5A07 ; 0F:5A07
	add a, $47
	ret
.l5A0A ; 0F:5A0A
	sub a, $04
	ret

.l5A0D ; 0F:5A0D
	; [PROBABLE] 356 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	ld a, $2B
	ret

Mail_Base64DecodeStream:: ; 0F:5A10
Function_0F_5A10::
	ld a, [wRam_D023]
	and a, a
	jp z, Mail_Return
	cp a, $02
	jr z, .l5A3E
	cp a, $03
	jr z, .l5A41
	cp a, $04
	jr z, .l5A41
	cp a, $05
	jr z, .l5A5A
	cp a, $FF
	jr z, .l5A6F
	cp a, $01
	jp nz, Mail_Return
	call Mail_Base64Stream_LoadArgs
	call Mail_CalcBase64DecodedSize
	ld a, h
	ld [wRam_D011], a
	ld a, l
	ld [wRam_D012], a
.l5A3E ; 0F:5A3E
	call Mail_Base64DecodeStream_ClampChunk
.l5A41 ; 0F:5A41
	call Mail_Base64DecodeStream_Step
	and a, a
	jr nz, .l5A6F
	ld a, [wRam_D023]
	cp a, $05
	jr z, .l5A5A
	ld a, [wRam_D012]
	ld h, a
	ld a, [wRam_D011]
	ld l, a
	xor a, a
	jp Mail_Return
.l5A5A ; 0F:5A5A
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
	ld [wRam_D023], a
	jp Mail_Return
.l5A6F ; 0F:5A6F
	ld a, $01
	jp Mail_Return

Mail_CalcBase64DecodedSize:: ; 0F:5A74
Function_0F_5A74::
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
	jr c, .l5A95
	rl c
	rl b
	dec e
	jr nz, .loop
	jr .l5AA3
.l5A95 ; 0F:5A95
	ld a, d
	sub a, $42
	ld d, a
	ld a, $42
	scf
	rl c
	rl b
	dec e
	jr nz, .loop
.l5AA3 ; 0F:5AA3
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
	ld [wRam_D023], a
	ret

Mail_Base64DecodeStream_ClampChunk:: ; 0F:5AC5
Function_0F_5AC5::
	ld hl, wMail_Work + $05
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, [wRam_D00E]
	ld c, a
	ld a, [wRam_D00F]
	ld b, a
	cp a, h
	jr c, .l5AE0
	jr nz, .l5ADE
	ld a, c
	cp a, l
	jr c, .l5AE0
	jr z, .l5AE0
.l5ADE ; 0F:5ADE
	ld b, h
	ld c, l
.l5AE0 ; 0F:5AE0
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
	ld [wRam_D005], a
	ld a, h
	ld [wRam_D006], a
	ld a, h
	or a, l
	jr nz, .l5B05
	pop bc
	ld a, c
	ld [wRam_D00E], a
	ld a, b
	ld [wRam_D00F], a
	ld a, $04
	ld [wRam_D023], a
	xor a, a
	ret
.l5B05 ; 0F:5B05
	pop bc
	ld a, c
	ld [wRam_D00E], a
	ld a, b
	ld [wRam_D00F], a
	ld a, $03
	ld [wRam_D023], a
	xor a, a
	ret

Mail_Base64DecodeStream_Step:: ; 0F:5B15
Function_0F_5B15::
	ld a, [wRam_D023]
	and a, a
	ret z
	ld a, [wRam_D00E]
	ld c, a
	ld a, [wRam_D00F]
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
	jr z, .l5B58
	cp a, $02
	jr z, .l5B50
	ld a, [wRam_D023]
	cp a, $04
	jr z, .l5B58
	inc hl
	inc hl
	jr .l5B58
.loop ; 0F:5B4B
	pop hl
	ld b, $83
	jr .l5B52
.l5B50 ; 0F:5B50
	ld b, $81
.l5B52 ; 0F:5B52
	ld a, $FF
	ld [wRam_D023], a
	ret
.l5B58 ; 0F:5B58
	ld a, [wRam_D010]
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
	ld a, [wRam_D00A]
	ld l, a
	ld a, [wRam_D00B]
	ld h, a
	cp a, b
	jr c, .loop
	jr nz, .l5B90
	ld a, l
	cp a, c
	jr c, .loop
.l5B90 ; 0F:5B90
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
	ld [wRam_D00A], a
	ld a, h
	ld [wRam_D00B], a
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
	ld a, [wRam_D023]
	cp a, $03
	jr z, .l5BD6
	cp a, $04
	jr z, .l5BCF
	jr .l5B50
.l5BCF ; 0F:5BCF
	ld a, $05
	ld [wRam_D023], a
	jr .l5BDB
.l5BD6 ; 0F:5BD6
	ld a, $02
	ld [wRam_D023], a
.l5BDB ; 0F:5BDB
	xor a, a
	ret

Mail_CopyBase64StripLineBreaks:: ; 0F:5BDD
Function_0F_5BDD::
	xor a, a
	ld [wRam_D010], a
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
	jr z, .l5C30
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
	jr z, .l5C4F
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
	ld a, [wRam_D010]
	inc a
	ld [wRam_D010], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
.l5C30 ; 0F:5C30
	ld a, [wRam_D023]
	cp a, $04
	jr z, .l5C48
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
.l5C48 ; 0F:5C48
	dec hl
	dec hl
	xor a, a
	ld [hl], a
	ld a, $01
	ret
.l5C4F ; 0F:5C4F
	xor a, a
	ld [hl], a
	ret

Mail_CopyBase64StripLineBreaks_NextPage:: ; 0F:5C52
Function_0F_5C52::
	push bc
	ld bc, wMail_InputBank
	call Mail_NextSramPage
	pop bc
	ret

Mail_CopyBase64StripLineBreaks_ErrorExit:: ; 0F:5C5B
Label_0F_5C5B::
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
.l5C79 ; 0F:5C79
	ld a, [wMail_Work + $1A]
	or a, a
	jr nz, .l5C86
	ld a, [wMail_Work + $19]
	cp a, $04
	jr c, .l5CAE
.l5C86 ; 0F:5C86
	ld b, $04
	push hl
	ld hl, wMail_Work + $1B
.l5C8C ; 0F:5C8C
	ld a, [de]
	inc de
	call Mail_Base64DecodeChar
	ld [hli], a
	dec b
	jr nz, .l5C8C
	ld a, [wMail_Work + $19]
	ld c, a
	ld a, [wMail_Work + $1A]
	ld b, a
	dec bc
	dec bc
	dec bc
	dec bc
.l5CA1 ; 0F:5CA1
	ld a, [de]
	cp a, $0D
	jr z, .l5CAA
	cp a, $0A
	jr nz, .l5CB4

.l5CAA ; 0F:5CAA
	; [PROBABLE] 6 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	inc de
	dec bc
	jr .l5CA1
.l5CAE ; 0F:5CAE
	ld a, $FF
	ld [wRam_D023], a
	ret

.l5CB4 ; 0F:5CB4
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
	jp nz, .l5C79
	ld a, [wMail_Work + $1A]
	cp a, $00
	jp nz, .l5C79
	ret

Mail_Base64DecodeChar:: ; 0F:5D12
	cp a, $2B
	jr c, .l5D3C
	jr z, .l5D44
	cp a, $2F
	jr c, .l5D3C
	jr z, .l5D47
	cp a, $30
	jr c, .l5D3C
	cp a, $3A
	jr c, .l5D4A
	cp a, $3D
	jr c, .l5D3C
	jr z, .l5D4D
	cp a, $41
	jr c, .l5D3C
	cp a, $5B
	jr c, .l5D62
	cp a, $61
	jr c, .l5D3C
	cp a, $7B
	jr c, .l5D65

.l5D3C ; 0F:5D3C
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D37-5DAE by apply_coverage --split
	pop hl
	pop hl
	ld a, $FF
	ld [wMail_ComposeState], a
	ret
.l5D44 ; 0F:5D44
	ld a, $3E
	ret
.l5D47 ; 0F:5D47
	ld a, $3F
	ret

.l5D4A ; 0F:5D4A
	; [CONFIRMED] 49 insn(s) executed; cut out of the PROBABLE region 4D37-5DAE by apply_coverage
	; --split [executed in 10 scenarios]
	add a, $04
	ret
.l5D4D ; 0F:5D4D
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
.l5D62 ; 0F:5D62
	sub a, $41
	ret
.l5D65 ; 0F:5D65
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
	jr z, .l5DA0
	inc d
	ld a, e
	ld e, $00
	ret

.l5DA0 ; 0F:5DA0
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
