; engine/mail/compose.asm
; bank 2D, $4000-$4195 (405 bytes); pinned by layout.link
; MailCompose_Run, draft save/load/clear, mail record delete, record address table

SECTION "engine/mail/compose", ROMX

; ---- code $4000-$4017 (23 bytes) [CONFIRMED] 9 insn(s); 9 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailCompose_Run:: ; 2D:4000
Function_2D_4000::
	call MailStaging_Clear
	farcall MailBody_ClearBuffer
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wMailComposeMode], a
	xor a, a
	jr Label_2D_4019

; ---- code $4017-$4019 (2 bytes) [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1; entered by jrcc from 2D:402F (executed) [executed in 1 scenarios]

Label_2D_4017:: ; 2D:4017
	ld a, $01

; ---- code $4019-$40DC (195 bytes) [CONFIRMED] 98 insn(s); 98 executed (in up to 2/18 scenarios)

Label_2D_4019:: ; 2D:4019
	farcall MailAddr_Edit
	cp a, $FF
	ret z
	xor a, a
	jr Label_2D_4027

Label_2D_4025:: ; 2D:4025
	ld a, $01

Label_2D_4027:: ; 2D:4027
	farcall MailTitle_Entry
	cp a, $FF
	jr z, Label_2D_4017
	farcall MailBody_Edit
	cp a, $FF
	jr z, Label_2D_4025
	ret

MailDraft_SaveToSram:: ; 2D:403C
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $D400
	ld de, $A040
	ld b, $C0

Label_2D_4058:: ; 2D:4058
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4058
	ld hl, $D4C0
	ld de, $A000
	ld b, $40

Label_2D_4066:: ; 2D:4066
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4066
	ld hl, $D500
	ld de, $A100
	ld b, $14

Label_2D_4074:: ; 2D:4074
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4074
	ld hl, $D514
	ld de, $A114
	ld b, $10

Label_2D_4082:: ; 2D:4082
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4082
	farcall SramCheck_Bank0Commit
	ret

MailDraft_LoadFromSram:: ; 2D:408F
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $D400
	ld hl, $A040
	ld b, $C0

Label_2D_40AB:: ; 2D:40AB
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_40AB
	ld de, $D4C0
	ld hl, $A000
	ld b, $40

Label_2D_40B9:: ; 2D:40B9
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_40B9
	ld de, $D500
	ld hl, $A100
	ld b, $14

Label_2D_40C7:: ; 2D:40C7
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_40C7
	ld de, $D514
	ld hl, $A114
	ld b, $10

Label_2D_40D5:: ; 2D:40D5
	ld a, [hli]
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_40D5
	ret

; ---- code $40DC-$417D (161 bytes) [CONFIRMED] 94 insn(s) reached by static flow only; seeds: exec x94; min discovery hops 1; entered by far from 26:433B (PROBABLE code); upgraded by classifier g3: all 94 instruction starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the mapper run, e.g. mail_inbox/mail_send/mail_compose)

MailDraft_Clear:: ; 2D:40DC
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld de, $D400
	ld hl, $A040
	ld b, $C0

Label_2D_40F8:: ; 2D:40F8
	xor a, a
	ld [hli], a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_40F8
	ld de, $D4C0
	ld hl, $A000
	ld b, $40

Label_2D_4107:: ; 2D:4107
	xor a, a
	ld [hli], a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4107
	ld de, $D500
	ld hl, $A100
	ld b, $14

Label_2D_4116:: ; 2D:4116
	xor a, a
	ld [hli], a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4116
	ld de, $D514
	ld hl, $A114
	ld b, $10

Label_2D_4125:: ; 2D:4125
	xor a, a
	ld [hli], a
	ld [de], a
	inc de
	dec b
	jr nz, Label_2D_4125
	farcall SramCheck_Bank0Commit
	ret

MailRecord_Delete:: ; 2D:4133
	push bc

Label_2D_4134:: ; 2D:4134
	push bc
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld c, b
	ld b, $00
	sla c
	ld hl, MailRecord_AddrTable
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hl]
	ld h, a
	ld l, e
	ld bc, $012D
	push hl
	add hl, bc
	pop de

Label_2D_4159:: ; 2D:4159
	ld a, [hli]
	ld [de], a
	inc de
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2D_4159
	pop bc
	inc b
	ld a, b
	cp a, $0C
	jr nz, Label_2D_4134
	ld hl, $AE13
	ld bc, $012D

Label_2D_416E:: ; 2D:416E
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2D_416E
	pop bc
	farcall SramCheck_Bank0Commit
	ret

; ---- words $417D-$4195 (24 bytes) [PROBABLE] 12 little-endian SRAM addresses A124 A251 A37E A4AB A5D8 A705 A832 A95F AA8C ABB9 ACE6 AE13 (stride $12D = one profile record); indexed by b (0..11) in the copy loop `ld hl,imm ; ld c,b ; sla c ; add hl,bc ; ld a,[hli]...` (loop ends at b=$0C); base loaded by ld hl,$417D at 2D:4149 (PROBABLE code, executed neighbourhood)

MailRecord_AddrTable:: ; 2D:417D
Table_2D_417D::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13
