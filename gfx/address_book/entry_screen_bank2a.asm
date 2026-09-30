; gfx/address_book/entry_screen_bank2a.asm
; bank 2A, $7CF0-$7E80 (400 bytes); pinned by layout.link
; address-book entry screen tiles stored in bank 2A

SECTION "gfx/address_book/entry_screen_bank2a", ROMX

; ---- gfx $7CF0-$7DD0 (224 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:522C: hl=$7CF0 a=$2A c=$0E de=$8F00 (dest VRAM $8F00, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrBookEntry_Tiles8F00:: ; 2A:7CF0
Data_2A_7CF0::
	db $FF, $FF, $FF, $00, $00, $01, $01, $03, $03, $06, $06, $05, $07, $05, $07, $05
	db $FF, $FF, $FF, $00, $FC, $FE, $E2, $07, $7D, $FF, $FA, $07, $FE, $73, $FE, $73
	db $FF, $FF, $FF, $00, $00, $00, $03, $07, $06, $8C, $8D, $CA, $98, $D7, $95, $D2
	db $FF, $FF, $FF, $00, $00, $00, $0F, $8F, $D4, $D0, $BB, $34, $7B, $84, $F8, $07
	db $FF, $FF, $FF, $00, $00, $00, $FF, $FF, $A7, $00, $58, $A7, $5D, $A2, $F8, $07
	db $FF, $FF, $FF, $00, $00, $00, $C0, $E0, $A0, $30, $60, $B0, $E0, $30, $50, $98
	db $05, $05, $05, $05, $05, $07, $05, $07, $02, $07, $01, $03, $00, $01, $00, $00
	db $FA, $07, $FE, $73, $FE, $73, $FA, $07, $FD, $FF, $02, $FF, $FC, $FF, $00, $FE
	db $98, $D7, $95, $D2, $8D, $DA, $8A, $C9, $05, $CC, $03, $87, $00, $03, $00, $00
	db $73, $88, $D7, $28, $D7, $28, $28, $C7, $D7, $10, $EF, $FF, $00, $FF, $00, $00
	db $F7, $08, $F8, $02, $FA, $05, $78, $93, $D7, $10, $EF, $FF, $00, $FF, $00, $00
	db $B0, $58, $B0, $58, $B0, $58, $50, $98, $A0, $38, $C0, $F0, $00, $E0, $00, $00
	db $00, $00, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00

; ---- gfx $7DD0-$7E80 (176 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:523E: hl=$7DD0 a=$2A c=$0B de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrBookEntry_Tiles8000:: ; 2A:7DD0
Data_2A_7DD0::
	db $80, $7F, $70, $E0, $4F, $C7, $5C, $98, $3B, $93, $37, $B3, $37, $B7, $37, $B6
	db $04, $F8, $78, $3C, $98, $9C, $D8, $4C, $68, $6C, $40, $40, $40, $40, $40, $40
	db $32, $92, $58, $98, $4F, $C7, $70, $E0, $7F, $FF, $03, $FF, $03, $07, $23, $1F
	db $40, $00, $B0, $90, $F0, $F0, $00, $00, $C0, $C0, $00, $C0, $00, $80, $00, $C0
	db $1F, $3F, $00, $3F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $E0, $E0, $00, $E0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $70, $70, $C8, $B8, $88, $F8, $88, $F8, $98, $E8, $F8, $88
	db $07, $03, $0C, $07, $1C, $0F, $74, $3F, $F7, $6C, $FF, $A2, $DF, $B1, $FF, $4F
	db $F8, $88, $78, $C8, $60, $C0, $C0, $40, $C0, $40, $C0, $80, $60, $80, $20, $E0
	db $7F, $7C, $1F, $10, $0F, $08, $07, $07, $00, $00, $00, $00, $00, $00, $00, $00
	db $C0, $C0, $E0, $80, $C0, $00, $C0, $C0, $00, $00, $00, $00, $00, $00, $00, $00
