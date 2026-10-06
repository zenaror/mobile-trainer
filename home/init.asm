; home/init.asm
; bank 00, $0278-$0392 (282 bytes); pinned by layout.link
; Boot, white boot palette upload and its data

SECTION "home/init", ROM0

Boot:: ; 00:0278
	; [CONFIRMED] boot: see docs/research/boot_and_home.md. A(boot)->FFA3; LCD off (05BD); di; clear
	; TAC/IF/IE; sp=$FFFE; CGB: request double speed (0602); SRAM off+bank0; non-CGB: forever show
	; bank 6B:4C80; clear VRAM1, WRAM banks 2-7, WRAM0/1, VRAM0, HRAM FF80-FFFD; copy OAM DMA
	; routine (059F); call 04:4000 (via 20A0); call 4F:4717; ROM bank <- 1; main loop far-calls
	; 1C:4000 forever | inline far pointer: FarCall at 0328: dw $4000 ; db $1C -> 1C:4000
	nop
	ldh [hBootA], a
	call LCDOff
	di
	xor a, a
	ldh [rTAC], a
	ldh [rIF], a
	ldh [rIE], a
	ld [wVBlankFlag], a
	ld sp, $FFFE
	ldh a, [hBootA]
	cp a, $11
	ld a, $80
	call z, SwitchCPUSpeed
	xor a, a
	ld [rRAMG], a
	ld [rRAMB], a
	ldh a, [hBootA]
	cp a, $11
	jr z, .l02AE
.l02A2 ; 00:02A2
	ld a, $6B
	ldh [hROMBankLo], a
	ld [$2100], a
	call NonCgb_ErrorScreen
	jr .l02A2
.l02AE ; 00:02AE
	ld a, $01
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld d, $06
	ld e, $02
.l02C0 ; 00:02C0
	ld a, e
	ldh [rSVBK], a
	ld hl, $D000 ; raw: base of the wipe of every bank 2-7
	ld bc, $1000
	xor a, a
	call FillBytes
	inc e
	dec d
	jr nz, .l02C0
	xor a, a
	ldh [rSVBK], a
	ldh [rVBK], a
	ld hl, wShadowOAM
	ld bc, $2000
	xor a, a
	call FillBytes
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld sp, $CFFF
	ld hl, hOamDmaRoutine
	ld bc, $007E
	xor a, a
	call FillBytes
	call OAMDMA_CopyToHram
	xor a, a
	ldh [hFramesWithoutService], a
	ld [wFrameServiceRan], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Sound_Init
	pop af
	ldh [rSVBK], a
	ld a, $4F
	ldh [hROMBankLo], a
	ld [$2100], a
	call Boot_ClearAndInit
	ld bc, $0001
	di
	ld a, c
	ldh [hROMBankLo], a
	ld [$2100], a
	ld a, b
	ldh [hROMBankHi], a
	ld [rROMB1], a
	ei

Boot_MainLoop:: ; 00:0328
Label_00_0328::
	farcall Main_Run

Boot_MainLoop_Repeat:: ; 00:032E
Function_00_032E::
	; [CONFIRMED] continuation
	jp Boot_MainLoop

Palette_SetAllWhite:: ; 00:0331
Function_00_0331::
	; [CONFIRMED] writes 64 bytes of $7FFF x32 (Data_00_0352) into BG palette RAM (rBCPS=$80
	; auto-inc) and OBJ palette RAM (rOCPS=$80): all 16 palettes white [reached via inferred links;
	; raw refs 8] [executed in 41 scenarios]
	ld a, $80
	ldh [rBCPS], a
	ld hl, Palette_AllWhite
	ld c, $69
	call Palette_WritePort64
	ld a, $80
	ldh [rOCPS], a
	ld hl, Palette_AllWhite
	ld c, $6B
	call Palette_WritePort64
	ret

Palette_WritePort64:: ; 00:034A
Function_00_034A::
	; [CONFIRMED] copies 64 bytes from [HL] to the I/O port at $FF00+C (palette data port helper)
	; [reached via inferred links; raw refs 4] [executed in 41 scenarios]
	ld b, $40
.loop ; 00:034C
	ld a, [hli]
	ldh [c], a
	dec b
	jr nz, .loop
	ret

; ---- data $0352-$0392 (64 bytes) [CONFIRMED] 32 x $7FFF (white) = 64 bytes, source for Function_00_0331 (ld hl,$0352 at 0335/0341)

Palette_AllWhite:: ; 00:0352
Data_00_0352::
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
