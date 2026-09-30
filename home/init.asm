; home/init.asm
; bank 00, $0278-$0392 (282 bytes); pinned by layout.link
; Boot, white boot palette upload and its data

SECTION "home/init", ROM0

; ---- code $0278-$032E (182 bytes) [CONFIRMED] boot: see docs/research/boot_and_home.md. A(boot)->FFA3; LCD off (05BD); di; clear TAC/IF/IE; sp=$FFFE; CGB: request double speed (0602); SRAM off+bank0; non-CGB: forever show bank 6B:4C80; clear VRAM1, WRAM banks 2-7, WRAM0/1, VRAM0, HRAM FF80-FFFD; copy OAM DMA routine (059F); call 04:4000 (via 20A0); call 4F:4717; ROM bank <- 1; main loop far-calls 1C:4000 forever | inline far pointer: FarCall at 0328: dw $4000 ; db $1C -> 1C:4000

Boot:: ; 00:0278
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
	jr z, Label_00_02AE

Label_00_02A2:: ; 00:02A2
	ld a, $6B
	ldh [hROMBankLo], a
	ld [$2100], a
	call NonCgb_ErrorScreen
	jr Label_00_02A2

Label_00_02AE:: ; 00:02AE
	ld a, $01
	ldh [rVBK], a
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld d, $06
	ld e, $02

Label_00_02C0:: ; 00:02C0
	ld a, e
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $1000
	xor a, a
	call FillBytes
	inc e
	dec d
	jr nz, Label_00_02C0
	xor a, a
	ldh [rSVBK], a
	ldh [rVBK], a
	ld hl, $C000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld hl, $8000
	ld bc, $2000
	xor a, a
	call FillBytes
	ld sp, $CFFF
	ld hl, $FF80
	ld bc, $007E
	xor a, a
	call FillBytes
	call Function_00_059F
	xor a, a
	ldh [hFramesWithoutService], a
	ld [wFrameServiceRan], a
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	call Function_00_20A0
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

Label_00_0328:: ; 00:0328
	farcall Main_Run

; ---- code $032E-$0331 (3 bytes) [CONFIRMED] continuation

Function_00_032E:: ; 00:032E
	jp Label_00_0328

; ---- code $0331-$034A (25 bytes) [CONFIRMED] writes 64 bytes of $7FFF x32 (Data_00_0352) into BG palette RAM (rBCPS=$80 auto-inc) and OBJ palette RAM (rOCPS=$80): all 16 palettes white [reached via inferred links; raw refs 8] [executed in 41 scenarios]

Function_00_0331:: ; 00:0331
	ld a, $80
	ldh [rBCPS], a
	ld hl, Data_00_0352
	ld c, $69
	call Function_00_034A
	ld a, $80
	ldh [rOCPS], a
	ld hl, Data_00_0352
	ld c, $6B
	call Function_00_034A
	ret

; ---- code $034A-$0352 (8 bytes) [CONFIRMED] copies 64 bytes from [HL] to the I/O port at $FF00+C (palette data port helper) [reached via inferred links; raw refs 4] [executed in 41 scenarios]

Function_00_034A:: ; 00:034A
	ld b, $40

Label_00_034C:: ; 00:034C
	ld a, [hli]
	ldh [c], a
	dec b
	jr nz, Label_00_034C
	ret

; ---- data $0352-$0392 (64 bytes) [CONFIRMED] 32 x $7FFF (white) = 64 bytes, source for Function_00_0331 (ld hl,$0352 at 0335/0341)

Data_00_0352:: ; 00:0352
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F
