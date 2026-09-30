; engine/mail/staging.asm
; bank 2D, $4686-$4722 (156 bytes); pinned by layout.link
; SRAM page clear, mail staging clear, free record slot lookup

SECTION "engine/mail/staging", ROMX

; ---- code $4686-$46A1 (27 bytes) [PROBABLE] SRAM erase routine: bank 0 select/enable, clears $A000-$AFFF (ld bc,$1000 ; xor a ; ld [hli],a loop), falls into the far-call site 46A1 (call 22:501D, same tail as 2D:4195/40DC) then ret; entry not located

Sram_ClearBank0Page0:: ; 2D:4686
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, $A000
	ld bc, $1000

Label_2D_469A:: ; 2D:469A
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, Label_2D_469A

; ---- code $46A1-$46A8 (7 bytes) [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall SramCheck_Bank0Commit
	ret

; ---- code $46A8-$46E9 (65 bytes) [CONFIRMED] 37 insn(s); 37 executed (in up to 2/18 scenarios); entry proven: target of an executed call/far call

MailStaging_Clear:: ; 2D:46A8
Function_2D_46A8::
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D400
	ld b, $C0

Label_2D_46B3:: ; 2D:46B3
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2D_46B3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D4C0
	ld b, $40

Label_2D_46C3:: ; 2D:46C3
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2D_46C3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld b, $14

Label_2D_46D3:: ; 2D:46D3
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2D_46D3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D514
	ld b, $10

Label_2D_46E3:: ; 2D:46E3
	xor a, a
	ld [hli], a
	dec b
	jr nz, Label_2D_46E3
	ret

; ---- code $46E9-$470A (33 bytes) [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 15; entered by far from 54:4DAF (PROBABLE code); upgraded by classifier g3: all 16 instruction starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the mapper run, e.g. mail_inbox/mail_send/mail_compose)

MailRecord_GetFreeSlotPtr:: ; 2D:46E9
	farcall Mailbox_CountRecords
	sla d
	ld e, d
	ld d, $00
	ld hl, MailRecord_AddrTable2
	add hl, de
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- words $470A-$4722 (24 bytes) [PROBABLE] 12 little-endian SRAM addresses A124 A251 A37E A4AB A5D8 A705 A832 A95F AA8C ABB9 ACE6 AE13 (stride $12D = one profile record); indexed by b (0..11) in the copy loop `ld hl,imm ; ld c,b ; sla c ; add hl,bc ; ld a,[hli]...` (loop ends at b=$0C); second copy of the table of 2D:417D, base loaded by ld hl,$470A at 2D:46F4 (PROBABLE code)

MailRecord_AddrTable2:: ; 2D:470A
Table_2D_470A::
	dw $A124, $A251, $A37E, $A4AB, $A5D8, $A705, $A832, $A95F
	dw $AA8C, $ABB9, $ACE6, $AE13
