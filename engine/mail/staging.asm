; engine/mail/staging.asm
; bank 2D, $4686-$4722 (156 bytes); pinned by layout.link
; SRAM page clear, mail staging clear, free record slot lookup

SECTION "engine/mail/staging", ROMX

Sram_ClearBank0Page0:: ; 2D:4686
	; [PROBABLE] SRAM erase routine: bank 0 select/enable, clears $A000-$AFFF (ld bc,$1000 ; xor a ;
	; ld [hli],a loop), falls into the far-call site 46A1 (call 22:501D, same tail as 2D:4195/40DC)
	; then ret; entry not located
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, sSaveBank0Page0
	ld bc, $1000
.loop ; 2D:469A
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop

	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: site x2; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	farcall SramCheck_Bank0Commit
	ret

MailStaging_Clear:: ; 2D:46A8
Function_2D_46A8::
	; [CONFIRMED] 37 insn(s); 37 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditBodyBuf
	ld b, $C0
.l46B3 ; 2D:46B3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l46B3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditAddressBuf
	ld b, $40
.l46C3 ; 2D:46C3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l46C3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditSubjectBuf
	ld b, $14
.l46D3 ; 2D:46D3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l46D3
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wEditNameBuf
	ld b, $10
.l46E3 ; 2D:46E3
	xor a, a
	ld [hli], a
	dec b
	jr nz, .l46E3
	ret

MailRecord_GetFreeSlotPtr:: ; 2D:46E9
	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 15;
	; entered by far from 54:4DAF (PROBABLE code); upgraded by classifier g3: all 16 instruction
	; starts of this region are executed in analysis/coverage_union.tsv (scenarios added after the
	; mapper run, e.g. mail_inbox/mail_send/mail_compose)
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
