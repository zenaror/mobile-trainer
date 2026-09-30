; engine/sram/menu_cursor_memory.asm
; bank 48, $4AAB-$4ADB (48 bytes); pinned by layout.link
; Sram_ClearMenuCursorMemory

SECTION "engine/sram/menu_cursor_memory", ROMX

; ---- code $4AAB-$4ADB (48 bytes) [CONFIRMED] 25 insn(s); 25 executed (in up to 18/18 scenarios); entry proven: target of an executed call/far call

Sram_ClearMenuCursorMemory:: ; 48:4AAB
Function_48_4AAB::
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
	ld hl, $A8B7
	ld c, $20
	xor a, a

Label_48_4AC6:: ; 48:4AC6
	ld [hli], a
	dec c
	jr nz, Label_48_4AC6
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ret
