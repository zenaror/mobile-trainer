; engine/sram/clear_all_banks.asm
; bank 2D, $7E60-$7ECD (109 bytes); pinned by layout.link
; Sram_ClearAllBanks

SECTION "engine/sram/clear_all_banks", ROMX

Sram_ClearAllBanks:: ; 2D:7E60
	; [PROBABLE] SRAM erase routine: for banks 0,1,2,3 select the bank ($4000), enable ($0A ->
	; [$0000]) and clear $A000-$BFFF (ld bc,$2000 ; xor a ; ld [hli],a ; dec bc ; ld a,b ; or c ; jr
	; nz), ends with ret exactly at the zero padding (7ECD); complete coherent function, entry not
	; located | forced execution: 57/57 instruction starts ran in forced_screens (traces/forced/,
	; not natural evidence; status unchanged)
	ld a, $00
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, _SRAM
	ld bc, $2000
.l7E74 ; 2D:7E74
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l7E74
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, _SRAM
	ld bc, $2000
.l7E8F ; 2D:7E8F
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l7E8F
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, _SRAM
	ld bc, $2000
.l7EAA ; 2D:7EAA
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l7EAA
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld hl, _SRAM
	ld bc, $2000
.l7EC5 ; 2D:7EC5
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l7EC5
	ret
