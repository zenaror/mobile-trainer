; engine/mail/sample_data.asm
; bank 2D, $4195-$4686 (1265 bytes); pinned by layout.link
; sample mail / address-book installers with the sample strings

SECTION "engine/mail/sample_data", ROMX

; ---- code $4195-$42A3 (270 bytes) [PROBABLE] profile-defaults initialiser: SRAM bank 0 select (ld [$4000]), enable ($0A -> [$0000]), then strcpy-style copies of 9-byte records and NUL strings into SRAM ($A124...) via the helper at 42AA (20 calls); every `ld hl,imm` source lands exactly on a record/string start (42B2 42BB 42D0 42D7 42E6 42F8 4301 ... 44F1) of the data below, which independently mapped as text; ends by falling into the far-call site 42A3; entry not located (no caller/table found) | forced execution: 109/109 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

MailRecord_InstallSampleMails:: ; 2D:4195
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, MailSample0_Header
	ld de, $A124
	ld b, $09

Label_2D_41AB:: ; 2D:41AB
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_41AB
	ld hl, MailSample0_Body
	ld de, $A12D
	call SampleData_CopyString
	ld hl, MailSample0_Name
	ld de, $A1ED
	call SampleData_CopyString
	ld hl, MailSample0_Subject
	ld de, $A1FD
	call SampleData_CopyString
	ld hl, $42E6
	ld de, $A211
	call SampleData_CopyString
	ld hl, MailSample1_Header
	ld de, $A251
	ld b, $09

Label_2D_41DD:: ; 2D:41DD
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_41DD
	ld hl, MailSample1_Body
	ld de, $A25A
	call SampleData_CopyString
	ld hl, $433A
	ld de, $A31A
	call SampleData_CopyString
	ld hl, $4349
	ld de, $A32A
	call SampleData_CopyString
	ld hl, $4358
	ld de, $A33E
	call SampleData_CopyString
	ld hl, MailSample2_Header
	ld de, $A37E
	ld b, $09

Label_2D_420F:: ; 2D:420F
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_420F
	ld hl, MailSample2_Body
	ld de, $A387
	call SampleData_CopyString
	ld hl, $43E8
	ld de, $A447
	call SampleData_CopyString
	ld hl, $43F9
	ld de, $A457
	call SampleData_CopyString
	ld hl, $4406
	ld de, $A46B
	call SampleData_CopyString
	ld hl, MailSample3_Header
	ld de, $A4AB
	ld b, $09

Label_2D_4241:: ; 2D:4241
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4241
	ld hl, MailSample3_Body
	ld de, $A4B4
	call SampleData_CopyString
	ld hl, $44A3
	ld de, $A574
	call SampleData_CopyString
	ld hl, $44B0
	ld de, $A584
	call SampleData_CopyString
	ld hl, $44C1
	ld de, $A598
	call SampleData_CopyString
	ld hl, MailSample4_Header
	ld de, $A5D8
	ld b, $09

Label_2D_4273:: ; 2D:4273
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4273
	ld hl, MailSample4_Body
	ld de, $A5E1
	call SampleData_CopyString
	ld hl, $44E9
	ld de, $A6A1
	call SampleData_CopyString
	ld hl, $44EA
	ld de, $A6B1
	call SampleData_CopyString
	ld hl, $44F1
	ld de, $A6C5
	call SampleData_CopyString
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a

; ---- code $42A3-$42AA (7 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code | forced execution: 2/2 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)
	farcall SramCheck_Bank0Commit
	ret

; ---- code $42AA-$42B2 (8 bytes) [PROBABLE] strcpy helper: ld a,[hli] ; ld [de],a ; inc de ; cp a,$00 ; jr nz ; ret - 20 callers inside 4195-42A3 (call $42AA) | forced execution: 6/6 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

SampleData_CopyString:: ; 2D:42AA
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, SampleData_CopyString
	ret

; ---- data $42B2-$42BB (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 06 28 12 30, copied by `ld hl,$42B2 ; ld de,$A124 ; ld b,$09` loop (ld hl at 2D:41A3); field meaning unknown

MailSample0_Header:: ; 2D:42B2
Data_2D_42B2::
	db $01, $00, $00, $20, $00, $06, $28, $12, $30

; ---- text $42BB-$42D0 (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailSample0_Body:: ; 2D:42BB
String_2D_42BB::
	db $82, $B1, $82, $F1, $82, $C7, $81, $41, $82, $DC, $82, $BD, $82, $A0, $82, $BB, $82, $DA, $82, $A4, $00 ; "こんど、またあそぼう"

; ---- text $42D0-$42D7 (7 bytes) [PROBABLE] Shift-JIS text "マリオ" NUL-terminated (83 7D 83 8A 83 49 00); source of a strcpy (ld hl,$42D0 at 2D:41BA)

MailSample0_Name:: ; 2D:42D0
String_2D_42D0::
	db $83, $7D, $83, $8A, $83, $49, $00 ; "マリオ"

; ---- text $42D7-$42F8 (33 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailSample0_Subject:: ; 2D:42D7
String_2D_42D7::
	db $82, $DC, $82, $BD, $82, $A0, $82, $BB, $82, $DA, $82, $A4, $82, $CB, $00 ; "またあそぼうね"

MailSample0_Address:: ; 2D:42E6
	db $6D, $61, $72, $69, $6F, $40, $6D, $61, $72, $69, $6F, $2E, $6E, $65, $2E, $6A, $70, $00 ; "mario@mario.ne.jp"

; ---- data $42F8-$4301 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 06 29 20 46, copied by the ld b,9 loop after ld hl,$42F8 at 2D:41D5

MailSample1_Header:: ; 2D:42F8
Data_2D_42F8::
	db $01, $00, $00, $20, $00, $06, $29, $20, $46

; ---- text $4301-$436A (105 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailSample1_Body:: ; 2D:4301
String_2D_4301::
	db $82, $56, $82, $AA, $82, $C2, $82, $CC, $82, $B3, $82, $A2, $82, $B5, $82, $E5, $82, $CC, $82, $C9, $82, $BF, $82, $E6, $82, $A4, $82, $D1, $82, $C9, $81, $41, $82, $E2 ; "７がつのさいしょのにちようびに、や"
	db $82, $AB, $82, $E3, $82, $A4, $82, $F0, $82, $B7, $82, $E9, $82, $A9, $82, $E7, $82, $B1, $82, $A2, $82, $E6, $00 ; "きゅうをするからこいよ"

MailSample1_Name:: ; 2D:433A
	db $83, $4E, $83, $62, $83, $70, $82, $BE, $82, $A2, $82, $A8, $82, $A4, $00 ; "クッパだいおう"

MailSample1_Subject:: ; 2D:4349
	db $82, $E2, $82, $AB, $82, $E3, $82, $A4, $82, $E2, $82, $E9, $82, $BC, $00 ; "やきゅうやるぞ"

MailSample1_Address:: ; 2D:4358
	db $6B, $75, $70, $70, $61, $40, $6D, $61, $72, $69, $6F, $2E, $6E, $65, $2E, $6A, $70, $00 ; "kuppa@mario.ne.jp"

; ---- data $436A-$4373 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 10 17 50, copied by the ld b,9 loop after ld hl,$436A at 2D:4207

MailSample2_Header:: ; 2D:436A
Data_2D_436A::
	db $01, $00, $00, $20, $00, $07, $10, $17, $50

; ---- text $4373-$441B (168 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailSample2_Body:: ; 2D:4373
String_2D_4373::
	db $82, $C2, $82, $A2, $82, $C9, $83, $7C, $83, $50, $83, $82, $83, $93, $82, $CC, $82, $B3, $82, $A2, $82, $B5, $82, $F1, $82, $B3, $82, $AD, $82, $AA, $82, $C6, $82, $A4 ; "ついにポケモンのさいしんさくがとう"
	db $82, $B6, $82, $E5, $82, $A4, $82, $B7, $82, $E9, $82, $BC, $81, $49, $81, $75, $83, $7C, $83, $50, $83, $62, $83, $67, $83, $82, $83, $93, $83, $58, $83, $5E, $81, $5B ; "じょうするぞ！「ポケットモンスター"
	db $91, $DB, $81, $76, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $82, $C9, $82, $F1, $82, $C4, $82, $F1, $82, $C7, $82, $A4, $82, $CC, $83, $7A, $81, $5B, $83, $80 ; "苔」くわしくはにんてんどうのホーム"
	db $83, $79, $81, $5B, $83, $57, $82, $D6, $82, $66, $82, $6E, $81, $49, $00 ; "ページへＧＯ！"

MailSample2_Name:: ; 2D:43E8
	db $83, $81, $81, $5B, $83, $8B, $83, $7D, $83, $4B, $83, $57, $83, $93, $47, $42, $00 ; "メールマガジンGB"

MailSample2_Subject:: ; 2D:43F9
	db $47, $41, $4D, $45, $52, $27, $73, $20, $4C, $69, $66, $65, $00 ; "GAMER's Life"

MailSample2_Address:: ; 2D:4406
	db $67, $72, $61, $76, $65, $30, $31, $40, $6E, $61, $74, $69, $72, $64, $2E, $61, $64, $2E, $6A, $70, $00 ; "grave01@natird.ad.jp"

; ---- data $441B-$4424 (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 11 00 44 (the 9th byte $44 was counted as the first character of the following text run by the mapper), copied by the ld b,9 loop after ld hl,$441B at 2D:4239

MailSample3_Header:: ; 2D:441B
Data_2D_441B::
	db $01, $00, $00, $20, $00, $07, $11, $00, $44

; ---- text $4424-$44D3 (175 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

MailSample3_Body:: ; 2D:4424
String_2D_4424::
	db $83, $81, $81, $5B, $83, $8B, $83, $5A, $83, $93, $83, $5E, $81, $5B, $82, $CC, $83, $81, $83, $93, $83, $65, $83, $69, $83, $93, $83, $58, $82, $CC, $82, $BD, $82, $DF ; "メールセンターのメンテナンスのため"
	db $81, $41, $37, $2F, $31, $34, $81, $60, $37, $2F, $32, $30, $82, $DC, $82, $C5, $82, $CC, $82, $AB, $82, $A9, $82, $F1, $81, $41, $83, $81, $81, $5B, $83, $8B, $82, $F0 ; "、7/14～7/20までのきかん、メールを"
	db $83, $60, $83, $46, $83, $62, $83, $4E, $82, $C5, $82, $AB, $82, $C8, $82, $AD, $82, $C8, $82, $E8, $82, $DC, $82, $B7, $0D, $0A, $82, $A0, $82, $E7, $82, $A9, $82, $B6 ; "チェックできなくなります<$0D><$0A>あらかじ"
	db $82, $DF, $82, $B2, $82, $E8, $82, $E5, $82, $A4, $82, $B5, $82, $E5, $82, $A4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $00 ; "めごりょうしょうください"

MailSample3_Name:: ; 2D:44A3
	db $82, $66, $82, $61, $83, $5A, $83, $93, $83, $5E, $81, $5B, $00 ; "ＧＢセンター"

MailSample3_Subject:: ; 2D:44B0
	db $82, $BE, $82, $A2, $82, $B6, $82, $C8, $82, $A8, $82, $B5, $82, $E7, $82, $B9, $00 ; "だいじなおしらせ"

MailSample3_Address:: ; 2D:44C1
	db $69, $65, $76, $65, $40, $6D, $61, $6B, $6F, $70, $69, $2E, $6E, $65, $2E, $6A, $70, $00 ; "ieve@makopi.ne.jp"

; ---- data $44D3-$44DC (9 bytes) [PROBABLE] 9-byte default record 01 00 00 20 00 07 12 19 28, copied by the ld b,9 loop after ld hl,$44D3 at 2D:426B

MailSample4_Header:: ; 2D:44D3
Data_2D_44D3::
	db $01, $00, $00, $20, $00, $07, $12, $19, $28

; ---- text $44DC-$44FB (31 bytes) [PROBABLE] 4 NUL-terminated strings: 44DC "くくく・・・", 44E9 "" (empty), 44EA "むだい", 44F1 "p@p.ne.jp"; sources of strcpy calls (ld hl,$44DC ...)

MailSample4_Body:: ; 2D:44DC
String_2D_44DC::
	db $82, $AD, $82, $AD, $82, $AD, $81, $45, $81, $45, $81, $45, $00 ; "くくく・・・"

MailSample4_Name:: ; 2D:44E9
	db $00 ; ""

MailSample4_Subject:: ; 2D:44EA
	db $82, $DE, $82, $BE, $82, $A2, $00 ; "むだい"

MailSample4_Address:: ; 2D:44F1
	db $70, $40, $70, $2E, $6E, $65, $2E, $6A, $70, $00 ; "p@p.ne.jp"

; ---- code $44FB-$45A6 (171 bytes) [PROBABLE] second profile-defaults routine: SRAM bank 1 select/enable, 12 strcpy calls (`ld hl,imm ; ld de,imm ; ld a,[hli] ; ld [de],a ; inc de ; cp 0 ; jr nz`) whose sources (45A6 45DA 45B7 45F6 45B8 45F7 45C7 4611 45D8 462A 45D9 462B) are the strings of the text runs below; ends with ret at 45A5; entry not located | forced execution: 91/91 instruction starts ran in forced_screens (traces/forced/, not natural evidence; status unchanged)

Abook_InstallSampleEntries:: ; 2D:44FB
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, AbookSample0_Name
	ld de, $A69D

Label_2D_450F:: ; 2D:450F
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_450F
	ld hl, $45DA
	ld de, $A6AD

Label_2D_451C:: ; 2D:451C
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_451C
	ld hl, AbookSample1_Name
	ld de, $A6ED

Label_2D_4529:: ; 2D:4529
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4529
	ld hl, $45F6
	ld de, $A6FD

Label_2D_4536:: ; 2D:4536
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4536
	ld hl, $45B8
	ld de, $A73D

Label_2D_4543:: ; 2D:4543
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4543
	ld hl, $45F7
	ld de, $A74D

Label_2D_4550:: ; 2D:4550
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4550
	ld hl, $45C7
	ld de, $A78D

Label_2D_455D:: ; 2D:455D
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_455D
	ld hl, $4611
	ld de, $A79D

Label_2D_456A:: ; 2D:456A
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_456A
	ld hl, $45D8
	ld de, $A7DD

Label_2D_4577:: ; 2D:4577
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4577
	ld hl, AbookSample4_Address
	ld de, $A7ED

Label_2D_4584:: ; 2D:4584
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4584
	ld hl, $45D9
	ld de, $A82D

Label_2D_4591:: ; 2D:4591
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4591
	ld hl, $462B
	ld de, $A83D

Label_2D_459E:: ; 2D:459E
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_459E
	ret

; ---- text $45A6-$45B7 (17 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

AbookSample0_Name:: ; 2D:45A6
String_2D_45A6::
	db $83, $74, $83, $57, $83, $56, $83, $51, $83, $86, $83, $45, $83, $43, $83, $60, $00 ; "フジシゲユウイチ"

; ---- text $45B7-$462A (115 bytes) [PROBABLE] text block: 6 string(s) (analysis/strings.tsv, per-string NUL termination noted there); Shift-JIS/ASCII [clipped from 45A6-462A by higher-priority evidence]

AbookSample1_Name:: ; 2D:45B7
String_2D_45B7::
	db $00 ; ""

AbookSample2_Name:: ; 2D:45B8
	db $83, $6E, $83, $84, $83, $56, $83, $56, $83, $87, $83, $45, $83, $53, $00 ; "ハヤシショウゴ"

AbookSample3_Name:: ; 2D:45C7
	db $8A, $94, $8E, $AE, $89, $EF, $8E, $D0, $83, $7E, $83, $62, $83, $56, $81, $63, $00 ; "株式会社ミッシ…"

AbookSample4_Name:: ; 2D:45D8
	db $00 ; ""

AbookSample5_Name:: ; 2D:45D9
	db $00 ; ""

AbookSample0_Address:: ; 2D:45DA
	db $66, $75, $6A, $69, $73, $68, $69, $67, $65, $40, $6D, $69, $73, $73, $69, $6E, $67, $6C, $69, $6E, $6B, $2E, $63, $6F, $2E, $6A, $70, $00 ; "fujishige@missinglink.co.jp"

AbookSample1_Address:: ; 2D:45F6
	db $00 ; ""

AbookSample2_Address:: ; 2D:45F7
	db $68, $61, $79, $61, $73, $68, $69, $40, $6D, $69, $73, $73, $69, $6E, $67, $6C, $69, $6E, $6B, $2E, $63, $6F, $2E, $6A, $70, $00 ; "hayashi@missinglink.co.jp"

AbookSample3_Address:: ; 2D:4611
	db $6D, $61, $73, $74, $65, $72, $40, $6D, $69, $73, $73, $69, $6E, $67, $6C, $69, $6E, $6B, $2E, $63, $6F, $2E, $6A, $70, $00 ; "master@missinglink.co.jp"

; ---- text $462A-$4635 (11 bytes) [PROBABLE] strings: 462A "" (empty, second NUL) and 462B "abc@a.b.c"; the mapper counted them as unclassified bytes between two text runs

AbookSample4_Address:: ; 2D:462A
String_2D_462A::
	db $00 ; ""

AbookSample5_Address:: ; 2D:462B
	db $61, $62, $63, $40, $61, $2E, $62, $2E, $63, $00 ; "abc@a.b.c"

; ---- code $4635-$465E (41 bytes) [PROBABLE] third profile-defaults routine: SRAM bank select/enable + 2 strcpy calls (ld hl,$465E ; de $AF40 / ld hl,$466D ; de $AF50) whose sources are the strings at 465E/466D; ends with ret; entry not located

SampleData_InstallNameAddressPair:: ; 2D:4635
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, SampleData_Name
	ld de, $AF40

Label_2D_4649:: ; 2D:4649
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4649
	ld hl, $466D
	ld de, $AF50

Label_2D_4656:: ; 2D:4656
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, Label_2D_4656
	ret

; ---- text $465E-$4686 (40 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

SampleData_Name:: ; 2D:465E
String_2D_465E::
	db $83, $58, $81, $5B, $83, $70, $81, $5B, $83, $7D, $83, $8A, $83, $49, $00 ; "スーパーマリオ"

SampleData_Address:: ; 2D:466D
	db $6E, $69, $6E, $74, $65, $6E, $38, $38, $40, $67, $62, $61, $61, $2E, $64, $69, $6F, $6E, $2E, $6E, $65, $2E, $6A, $70, $00 ; "ninten88@gbaa.dion.ne.jp"
