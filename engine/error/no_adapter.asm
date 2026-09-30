; engine/error/no_adapter.asm
; bank 63, $732F-$742F (256 bytes); pinned by layout.link
; no-adapter screen

SECTION "engine/error/no_adapter", ROMX

NoAdapter_ShowScreen:: ; 63:732F
Function_63_732F::
	; [CONFIRMED] 83 insn(s); 83 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call NoAdapter_DrawScreen
	farcall Palette_FadeInFromWhite
	call NoAdapter_WaitButton
	farcall Palette_FadeOutToWhite
	ret

NoAdapter_DrawScreen:: ; 63:7342
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Function_00_09B6
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
	ld de, $8000
	ld hl, NoAdapter_Gfx_8000
	ld a, $63
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8801
	ld hl, $60C0
	ld a, $63
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8C01
	ld hl, NoAdapter_Gfx_8C00
	ld a, $63
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9001
	ld hl, NoAdapter_Gfx_9000
	ld a, $63
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $9401
	ld hl, NoAdapter_Gfx_9400
	ld a, $63
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld bc, $0040
	ld de, $D800
	ld hl, NoAdapter_Palette_Bg
	ld a, $63
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, $D840
	ld hl, $72D0
	ld a, $63
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, $D000
	ld hl, $6FC0
	ld a, $63
	farcall Function_00_08EA
	ldh a, [rLCDC]
	call Function_00_082C
	ld hl, $DA00
	ld de, NoAdapter_ObjTable
	ld a, $63
	ld b, $81
	farcall Function_00_0A82
	ld de, $2040
	ld hl, $DA00
	call Function_00_0A65
	farcall Function_00_0956
	call Function_00_044B
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ret

NoAdapter_WaitButton:: ; 63:7413
	farcall Joypad_Update
	farcall Function_00_0956
	call Function_00_044B
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .done
	bit 3, a
	jr nz, .done
	jr NoAdapter_WaitButton
.done ; 63:742E
	ret
