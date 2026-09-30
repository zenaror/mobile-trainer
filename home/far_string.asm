; home/far_string.asm
; bank 00, $153D-$1620 (227 bytes); pinned by layout.link
; far string getters (bank 65 prompt table, bank 68 default strings, SRAM strings)

SECTION "home/far_string", ROM0

PromptText_Load:: ; 00:153D
Function_00_153D::
	; [CONFIRMED] A=index: copies the string from 65:567F[A] (word table) to D000 (WRAM bank 5),
	; returns HL=$D000, A=5 [reached via inferred links; raw refs 11] [executed in 17 scenarios]
	ld b, a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $05
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh [hScratchA], a
	ldh a, [hROMBankLo]
	push af
	ldh a, [hScratchA]
	ld a, $65
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, b
	ld hl, PromptText_Table
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld de, $D000
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, $D000
	ld a, $05
	ret

Dial_CopySelectedNumber:: ; 00:1586
Function_00_1586::
	; [CONFIRMED] far-calls 68:44FC; if it returns 0 copies string 68:67AE[C271] to DE, else decodes
	; the SRAM string (bank 1, XOR $A5) selected by [B013] via Table_00_161A [reached via inferred
	; links; raw refs 0] [executed in 8 scenarios] | inline far pointer: FarCall at 1587: dw $44FC ;
	; db $68 -> 68:44FC
	push de
	farcall Settings_GetHiddenModeFlag

Function_00_158D:: ; 00:158D
	; [CONFIRMED] continuation [reached via inferred links; raw refs 11] [executed in 1 scenarios]
	or a, a
	jr nz, .l15BD
	pop de
	ldh [hScratchA], a
	ldh a, [hROMBankLo]
	push af
	ldh a, [hScratchA]
	ld a, $68
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, [wMobileAdapterType]
	ld hl, Dial_DefaultNumberTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call CopyString
	ldh [hScratchA], a
	pop af
	ldh [hROMBankLo], a
	ld [$2100], a
	ldh a, [hScratchA]
	ret
.l15BD ; 00:15BD
	pop de
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $03
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [sSettingsSelectedDialEntry]
	xor a, $A5
	ld hl, Table_Dial_SramEntryPtrs
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	call DecodeXorA5
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ret

; ---- words $161A-$1620 (6 bytes) [CONFIRMED] 3 pointers into SRAM bank 1 (B014, B025, B036) indexed by ([B013] xor $A5)

Table_Dial_SramEntryPtrs:: ; 00:161A
Table_00_161A::
	dw $B014, $B025, $B036
