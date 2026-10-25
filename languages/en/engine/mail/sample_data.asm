; engine/mail/sample_data.asm
; bank 2D, $4195-$4686 (1265 bytes); pinned by layout.link
; sample mail / address-book installers with the sample strings

SECTION "engine/mail/sample_data", ROMX

; [CONFIRMED static contract] Five fixed Bank2D records: 9-byte headers and
; NUL-terminated body/name/subject/address copies into SRAM0, stride $12D.
; No dynamic ROM source selector. Natural entry remains unproved.
; Sample 2 name copies 16 nonzero bytes plus NUL into a 16-byte field;
; the following subject copy overwrites that NUL. Original bytes preserved.
; Mailbox_DrawSenderName / MailView_DrawTextLine16 use 16-cell limits; this
; sample (seven wide + two narrow glyphs) exhausts the limit before byte 17.
MailRecord_InstallSampleMails:: ; 2D:4195
	; [PROBABLE] profile-defaults initialiser: SRAM bank 0 select (ld [$4000]), enable ($0A ->
	; [$0000]), then strcpy-style copies of 9-byte records and NUL strings into SRAM ($A124...) via
	; the helper at 42AA (20 calls); every `ld hl,imm` source lands exactly on a record/string start
	; (42B2 42BB 42D0 42D7 42E6 42F8 4301 ... 44F1) of the data below, which independently mapped as
	; text; ends by falling into the far-call site 42A3; entry not located (no caller/table found) |
	; forced execution: 109/109 instruction starts ran in forced_screens (traces/forced/, not
	; natural evidence; status unchanged)
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, MailSample0_Header
	ld de, sSram_MailRecords
	ld b, $09
.l41AB ; 2D:41AB
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l41AB
	ld hl, MailSample0_Body
	ld de, sSram_MailRecords + $09
	call SampleData_CopyString
	ld hl, MailSample0_Name
	ld de, sSram_MailRecords + $C9
	call SampleData_CopyString
	ld hl, MailSample0_Subject
	ld de, sSram_MailRecords + $D9
	call SampleData_CopyString
	ld hl, MailSample0_Address
	ld de, sSram_MailRecords + $ED
	call SampleData_CopyString
	ld hl, MailSample1_Header
	ld de, sMailRecord1
	ld b, $09
.l41DD ; 2D:41DD
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l41DD
	ld hl, MailSample1_Body
	ld de, sMailRecord1 + $09
	call SampleData_CopyString
	ld hl, MailSample1_Name
	ld de, sMailRecord1 + $C9
	call SampleData_CopyString
	ld hl, MailSample1_Subject
	ld de, sMailRecord1 + $D9
	call SampleData_CopyString
	ld hl, MailSample1_Address
	ld de, sMailRecord1 + $ED
	call SampleData_CopyString
	ld hl, MailSample2_Header
	ld de, sMailRecord2
	ld b, $09
.l420F ; 2D:420F
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l420F
	ld hl, MailSample2_Body
	ld de, sMailRecord2 + $09
	call SampleData_CopyString
	ld hl, MailSample2_Name
	ld de, sMailRecord2 + $C9
	call SampleData_CopyString
	ld hl, MailSample2_Subject
	ld de, sMailRecord2 + $D9
	call SampleData_CopyString
	ld hl, MailSample2_Address
	ld de, sMailRecord2 + $ED
	call SampleData_CopyString
	ld hl, MailSample3_Header
	ld de, sMailRecord3
	ld b, $09
.l4241 ; 2D:4241
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l4241
	ld hl, MailSample3_Body
	ld de, sMailRecord3 + $09
	call SampleData_CopyString
	ld hl, MailSample3_Name
	ld de, sMailRecord3 + $C9
	call SampleData_CopyString
	ld hl, MailSample3_Subject
	ld de, sMailRecord3 + $D9
	call SampleData_CopyString
	ld hl, MailSample3_Address
	ld de, sMailRecord3 + $ED
	call SampleData_CopyString
	ld hl, MailSample4_Header
	ld de, sMailRecord4
	ld b, $09
.l4273 ; 2D:4273
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, .l4273
	ld hl, MailSample4_Body
	ld de, sMailRecord4 + $09
	call SampleData_CopyString
	ld hl, MailSample4_Name
	ld de, sMailRecord4 + $C9
	call SampleData_CopyString
	ld hl, MailSample4_Subject
	ld de, sMailRecord4 + $D9
	call SampleData_CopyString
	ld hl, MailSample4_Address
	ld de, sMailRecord4 + $ED
	call SampleData_CopyString
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 2/2 instruction starts ran in forced_screens (traces/forced/, not natural
	; evidence; status unchanged)
	farcall SramCheck_Bank0Commit
	ret

SampleData_CopyString:: ; 2D:42AA
	; [PROBABLE] strcpy helper: ld a,[hli] ; ld [de],a ; inc de ; cp a,$00 ; jr nz ; ret - 20
	; callers inside 4195-42A3 (call $42AA) | forced execution: 6/6 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, SampleData_CopyString
	ret

; ---- data $42B2-$42BB (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 06 28 12 30, copied by `ld hl,$42B2 ; ld de,$A124 ; ld b,$09` loop (ld hl at 2D:41A3); field meaning unknown

MailSample0_Header:: ; 2D:42B2
	db $01, $00, $00, $20, $00, $06, $28, $12, $30

; ---- text $42BB-$42D0 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
; Unused original storage; MailSample0_Body is at 2D:7FE5.

	db "こんど、またあそぼう", 0
POPC

; ---- text $42D0-$42D7 (7 bytes) [PROBABLE] Shift-JIS text "マリオ" NUL-terminated (83 7D 83 8A 83 49 00); source of a strcpy (ld hl,$42D0 at 2D:41BA)

PUSHC sjis

PUSHC sjis
MailSample0_Name:: ; 2D:42D0
	db "Mario", 0
; Retained original storage bytes; outside the selected live string extents.
	db $00
POPC
POPC

; ---- text $42D7-$42F8 (33 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
; Unused original storage; MailSample0_Subject is at 2D:7FD4.

	db "またあそぼうね", 0

MailSample0_Address:: ; 2D:42E6
	db "mario@mario.ne.jp", 0
POPC

; ---- data $42F8-$4301 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 06 29 20 46, copied by the ld b,9 loop after ld hl,$42F8 at 2D:41D5

MailSample1_Header:: ; 2D:42F8
	db $01, $00, $00, $20, $00, $06, $29, $20, $46

; ---- text $4301-$436A (105 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
; Retained original storage bytes; outside the selected live string extents.
	db $82, $56, $82, $AA, $82, $C2, $82, $CC, $82, $B3, $82, $A2, $82, $B5, $82, $E5
	db $82, $CC, $82, $C9, $82, $BF, $82, $E6, $82, $A4, $82, $D1, $82, $C9, $81, $41
	db $82, $E2, $82, $AB, $82, $E3, $82, $A4, $82, $F0, $82, $B7, $82, $E9, $82, $A9
	db $82, $E7, $82, $B1, $82, $A2, $82, $E6, $00
MailSample1_Name:: ; 2D:433A
	db "King Bowser", 0
; Retained original storage bytes; outside the selected live string extents.
	db $82, $A4, $00, $82, $E2, $82, $AB, $82, $E3, $82, $A4, $82, $E2, $82, $E9, $82
	db $BC, $00
MailSample1_Address:: ; 2D:4358
	db "kuppa@mario.ne.jp", 0
POPC



POPC

; ---- data $436A-$4373 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 10 17 50, copied by the ld b,9 loop after ld hl,$436A at 2D:4207

MailSample2_Header:: ; 2D:436A
	db $01, $00, $00, $20, $00, $07, $10, $17, $50

; ---- text $4373-$441B (168 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
MailSample2_Body:: ; 2D:4373
	db "The new Pokemon game is finally coming out! Look for Pokemon Moss on the Nintendo Home P"
	db "age!", 0
; Retained original storage bytes; outside the selected live string extents.
	db $A4, $82, $CC, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $82
	db $D6, $82, $66, $82, $6E, $81, $49, $00
MailSample2_Name:: ; 2D:43E8
	db "Email Magazine G", 0
MailSample2_Subject:: ; 2D:43F9
	db "GAMER's Life", 0
MailSample2_Address:: ; 2D:4406
	db "grave01@natird.ad.jp", 0
POPC



POPC

; ---- data $441B-$4424 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 11 00 44 (the 9th byte $44 was counted as the first character of the following text run by the mapper), copied by the ld b,9 loop after ld hl,$441B at 2D:4239

MailSample3_Header:: ; 2D:441B
	db $01, $00, $00, $20, $00, $07, $11, $00, $44

; ---- text $4424-$44D3 (175 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
; Retained original storage bytes; outside the selected live string extents.
	db $83, $81, $81, $5B, $83, $8B, $83, $5A, $83, $93, $83, $5E, $81, $5B, $82, $CC
	db $83, $81, $83, $93, $83, $65, $83, $69, $83, $93, $83, $58, $82, $CC, $82, $BD
	db $82, $DF, $81, $41, $37, $2F, $31, $34, $81, $60, $37, $2F, $32, $30, $82, $DC
	db $82, $C5, $82, $CC, $82, $AB, $82, $A9, $82, $F1, $81, $41, $83, $81, $81, $5B
	db $83, $8B, $82, $F0, $83, $60, $83, $46, $83, $62, $83, $4E, $82, $C5, $82, $AB
	db $82, $C8, $82, $AD, $82, $C8, $82, $E8, $82, $DC, $82, $B7, $0D, $0A, $82, $A0
	db $82, $E7, $82, $A9, $82, $B6, $82, $DF, $82, $B2, $82, $E8, $82, $E5, $82, $A4
	db $82, $B5, $82, $E5, $82, $A4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $00
MailSample3_Name:: ; 2D:44A3
	db "GB Center", 0
; Retained original storage bytes; outside the selected live string extents.
	db $81, $5B, $00
MailSample3_Subject:: ; 2D:44B0
	db "Important News", 0
; Retained original storage bytes; outside the selected live string extents.
	db $B9, $00
MailSample3_Address:: ; 2D:44C1
	db "ieve@makopi.ne.jp", 0
POPC



POPC

; ---- data $44D3-$44DC (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 12 19 28, copied by the ld b,9 loop after ld hl,$44D3 at 2D:426B

MailSample4_Header:: ; 2D:44D3
	db $01, $00, $00, $20, $00, $07, $12, $19, $28

; ---- text $44DC-$44FB (31 bytes) [PROBABLE] 4 NUL-terminated strings: 44DC "くくく・・・", 44E9 "" (empty), 44EA "むだい", 44F1 "p@p.ne.jp"; sources of strcpy calls (ld hl,$44DC ...)

PUSHC sjis

PUSHC sjis
MailSample4_Body:: ; 2D:44DC
	db "Kukuku...", 0
; Retained original storage bytes; outside the selected live string extents.
	db $81, $45, $00
MailSample4_Name:: ; 2D:44E9
	db 0
; Retained original storage bytes; outside the selected live string extents.
	db $82, $DE, $82, $BE, $82, $A2, $00
MailSample4_Address:: ; 2D:44F1
	db "p@p.ne.jp", 0
POPC



POPC

; [CONFIRMED static contract] Six fixed Bank2D name/address pairs into SRAM1,
; stride $50 (name $10, address $40). Entries 0 and 3 copy a 17-byte name
; including NUL; the following address copy overwrites that extra NUL.
; Both names are eight wide glyphs. AddrBook_DrawSlotName / AbookView_DrawName
; stop at 16 cells, and Abook_LoadSlotToBuffers copies exactly 16 name bytes.
; No caller or natural execution is established by this source contract.
Abook_InstallSampleEntries:: ; 2D:44FB
	; [PROBABLE] second profile-defaults routine: SRAM bank 1 select/enable, 12 strcpy calls (`ld
	; hl,imm ; ld de,imm ; ld a,[hli] ; ld [de],a ; inc de ; cp 0 ; jr nz`) whose sources (45A6 45DA
	; 45B7 45F6 45B8 45F7 45C7 4611 45D8 462A 45D9 462B) are the strings of the text runs below;
	; ends with ret at 45A5; entry not located | forced execution: 91/91 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, AbookSample0_Name
	ld de, sAbookSlots
.l450F ; 2D:450F
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l450F
	ld hl, AbookSample0_Address
	ld de, sAbookSlots + $10
.l451C ; 2D:451C
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l451C
	ld hl, AbookSample1_Name
	ld de, sAbookSlots + $50
.l4529 ; 2D:4529
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4529
	ld hl, AbookSample1_Address
	ld de, sAbookSlots + $60
.l4536 ; 2D:4536
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4536
	ld hl, AbookSample2_Name
	ld de, sAbookSlots + $A0
.l4543 ; 2D:4543
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4543
	ld hl, AbookSample2_Address
	ld de, sAbookSlots + $B0
.l4550 ; 2D:4550
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4550
	ld hl, AbookSample3_Name
	ld de, sAbookSlots + $F0
.l455D ; 2D:455D
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l455D
	ld hl, AbookSample3_Address
	ld de, sAbookSlots + $100
.l456A ; 2D:456A
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l456A
	ld hl, AbookSample4_Name
	ld de, sAbookSlots + $140
.l4577 ; 2D:4577
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4577
	ld hl, AbookSample4_Address
	ld de, sAbookSlots + $150
.l4584 ; 2D:4584
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4584
	ld hl, AbookSample5_Name
	ld de, sAbookSlots + $190
.l4591 ; 2D:4591
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4591
	ld hl, AbookSample5_Address
	ld de, sAbookSlots + $1A0
.l459E ; 2D:459E
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l459E
	ret

; ---- text $45A6-$45B7 (17 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
AbookSample0_Name:: ; 2D:45A6
	db "Yuuichi", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $86, $83, $45, $83, $43, $83, $60, $00
POPC
POPC

; ---- text $45B7-$462A (115 bytes) [PROBABLE] text block: 6 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 45A6-462A by higher-priority evidence]

PUSHC sjis

PUSHC sjis
AbookSample1_Name:: ; 2D:45B7
	db 0
AbookSample2_Name:: ; 2D:45B8
	db "Shougo", 0
; Retained original storage bytes; outside the selected live string extents.
	db $56, $83, $87, $83, $45, $83, $53, $00
AbookSample3_Name:: ; 2D:45C7
	db "Mish Co., Ltd.", 0
; Retained original storage bytes; outside the selected live string extents.
	db $63, $00
AbookSample4_Name:: ; 2D:45D8
	db 0
AbookSample5_Name:: ; 2D:45D9
	db 0
AbookSample0_Address:: ; 2D:45DA
	db "fujishige@missinglink.co.jp", 0
AbookSample1_Address:: ; 2D:45F6
	db 0
AbookSample2_Address:: ; 2D:45F7
	db "hayashi@missinglink.co.jp", 0
AbookSample3_Address:: ; 2D:4611
	db "master@missinglink.co.jp", 0
POPC








POPC

; ---- text $462A-$4635 (11 bytes) [PROBABLE] strings: 462A "" (empty, second NUL) and 462B "abc@a.b.c"; the mapper counted them as unclassified bytes between two text runs

PUSHC sjis
AbookSample4_Address:: ; 2D:462A

	db 0

AbookSample5_Address:: ; 2D:462B
	db "abc@a.b.c", 0
POPC

; [CONFIRMED static contract] Both source strings are fixed Bank2D addresses;
; all 15/25 bytes including their terminators fit the $10/$40 field extents.
; Destination bank remains SRAM1, not the similarly addressed SRAM0 profile.
SampleData_InstallNameAddressPair:: ; 2D:4635
	; [PROBABLE] third profile-defaults routine: SRAM bank select/enable + 2 strcpy calls (ld
	; hl,$465E ; de $AF40 / ld hl,$466D ; de $AF50) whose sources are the strings at 465E/466D; ends
	; with ret; entry not located
	; sic: bank 1 is selected here, so AF40/AF50 are entry 5 of the browser history (sBrowserHistory + $540 / $550), although the strings are the profile name and address
	; of bank 0 (sProfileName, sProfileAddress); no caller, never executed (not even by the forced runs)
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, SampleData_Name
	ld de, sBrowserHistory + $540
.l4649 ; 2D:4649
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4649
	ld hl, SampleData_Address
	ld de, sBrowserHistory + $550
.l4656 ; 2D:4656
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .l4656
	ret

; ---- text $465E-$4686 (40 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis

PUSHC sjis
SampleData_Name:: ; 2D:465E
	db "Super Mario", 0
; Retained original storage bytes; outside the selected live string extents.
	db $83, $49, $00
SampleData_Address:: ; 2D:466D
	db "ninten88@gbaa.dion.ne.jp", 0
POPC

POPC
