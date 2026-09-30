; gfx/help/help_screens_b.asm
; bank 6A, $6716-$72BF (2985 bytes); pinned by layout.link
; help screen tilemap, tiles, palettes, object tables loaded by bank 6C

SECTION "gfx/help/help_screens_b", ROMX

; ---- data $6716-$69E6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 6C:5A45: hl=$6716 a=$6A b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_6A_6716:: ; 6A:6716
	db $B0, $B1, $B2, $B3, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB
	db $B3, $B2, $B1, $B0, $B4, $B5, $AF, $C5, $CB, $CB, $CB, $CB, $CB, $CB, $CB, $CB
	db $CB, $CB, $CB, $CB, $C5, $AF, $B5, $B4, $B6, $B7, $AF, $C6, $C7, $C7, $C7, $C7
	db $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C6, $AF, $B7, $B6, $B8, $B9, $BA, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $BA, $C3, $B8
	db $CA, $BB, $BC, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $BC, $BB, $CA, $CA, $BD, $BC, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $BC, $BD, $CA, $CA, $BD, $BC, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $BC, $BD, $CA, $CA, $BE, $BC, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $BC, $BE, $CA
	db $B8, $BF, $BA, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $BA, $C4, $B8, $B4, $B7, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $B7, $B4, $B4, $B5, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $B5, $B4, $B4, $B5, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $B5, $B4
	db $B4, $B5, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $B5, $B4, $B4, $B5, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $B5, $B4, $B4, $B5, $AF, $AF, $AF, $AF, $AF, $AF
	db $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $AF, $B5, $B4, $C0, $C1, $C2, $C2
	db $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C2, $C1, $C0
	db $C8, $CC, $CD, $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $DC
	db $DD, $DE, $DF, $C8, $CA, $CE, $CF, $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7, $E8
	db $E9, $EA, $EB, $EC, $ED, $EE, $EF, $CA, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $29, $29, $29, $29, $09, $09, $08, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $08, $29, $29
	db $09, $09, $08, $09, $09, $09, $09, $09, $09, $29, $29, $29, $29, $29, $29, $29
	db $29, $08, $29, $29, $09, $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $29, $09, $29, $09, $09, $09, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $29, $29, $09, $09, $09, $09, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $29, $29, $09
	db $09, $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $29, $29, $09, $09, $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $29, $29, $09, $49, $09, $49, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $69, $09, $69, $09, $49, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $69, $29
	db $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $29, $29, $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $29, $29, $09, $09, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $29, $29, $09, $09, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $29, $29
	db $09, $09, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $29, $29, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $29, $29
	db $29, $29, $29, $29, $29, $29, $29, $29, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- gfx $69E6-$69F0 (10 bytes) [PROBABLE] tiles-2bpp: heuristic: 47 coherent tiles (hsim2=0.680 vsim2=0.789, 1 blank) parity 1; 854/864 bytes also covered by call-site blocks [clipped from 68C1-6C21 by higher-priority evidence]

Data_6A_69E6:: ; 6A:69E6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $69F0-$6A10 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:59FF: hl=$69F0 a=$6A c=$02 de=$8000 (dest VRAM $8000, vbank=0)

Data_6A_69F0:: ; 6A:69F0
	db $7F, $00, $7F, $3F, $70, $2F, $38, $17, $1C, $0B, $0F, $04, $07, $03, $03, $00
	db $FE, $00, $FE, $FC, $06, $FC, $0C, $F8, $18, $F0, $F0, $20, $E0, $C0, $C0, $00

; ---- gfx $6A10-$6A20 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A11: hl=$6A10 a=$6A c=$01 de=$8AF1 (dest VRAM $8AF0, vbank=1)

Data_6A_6A10:: ; 6A:6A10
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $6A20-$6E20 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 6C:5A23: hl=$6A20 a=$6A c=$40 de=$8B01 (dest VRAM $8B00, vbank=1)

Data_6A_6A20:: ; 6A:6A20
	db $05, $FC, $0A, $F8, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $00, $00, $00, $00, $00, $00, $3F, $00, $40, $3F, $9F, $7F, $BF, $7F, $BF, $7F
	db $00, $00, $00, $00, $00, $00, $FF, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $C0, $00, $20, $C0, $A0, $C0, $A0, $C0, $A0, $C0
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $80, $7F
	db $0B, $F8, $04, $FC, $03, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $00, $00, $00, $FE, $FE, $01, $FF, $01, $C7, $15, $87, $3D, $87, $15, $87
	db $7F, $FF, $BF, $7F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F
	db $39, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF
	db $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F
	db $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF
	db $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $C7
	db $15, $87, $3D, $87, $15, $87, $39, $FF, $01, $FF, $FE, $FE, $00, $00, $FF, $00
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $13, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $40, $3F, $3F, $00, $00, $00, $FF, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $00, $00, $7F, $7F, $80, $FF, $80, $E3, $8A, $C3, $9E, $C3, $8A, $C3
	db $8A, $C3, $9E, $C3, $8A, $C3, $9C, $FF, $80, $FF, $7F, $7F, $00, $00, $FF, $00
	db $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0
	db $9F, $E0, $C0, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $08, $F8, $07, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $FF, $FF, $03, $F8, $07, $F3, $0D, $E4, $19, $EB, $1F, $EA, $1F, $EA
	db $00, $00, $FF, $FF, $F0, $07, $88, $E3, $E4, $01, $F2, $E0, $FA, $30, $FA, $30
	db $17, $EB, $17, $EA, $17, $E2, $17, $E2, $0B, $E0, $04, $F0, $03, $F8, $00, $FC
	db $FA, $F0, $FA, $30, $7A, $30, $7A, $30, $74, $00, $08, $01, $F0, $03, $00, $07
	db $00, $00, $FF, $FF, $00, $FF, $03, $F8, $3D, $83, $5E, $BE, $60, $A0, $5A, $BA
	db $00, $00, $FF, $FF, $00, $FF, $87, $38, $7A, $87, $FD, $FD, $40, $40, $F5, $F5
	db $00, $00, $FF, $FF, $00, $FF, $1F, $60, $EF, $1F, $F6, $F6, $C3, $C3, $E7, $E7
	db $00, $00, $FF, $FF, $00, $FF, $80, $3F, $40, $9F, $A0, $CF, $60, $4F, $A0, $CF
	db $00, $00, $FF, $FF, $07, $F0, $0F, $E7, $1B, $C8, $37, $D7, $3F, $D4, $3F, $D4
	db $00, $00, $FF, $FF, $E0, $0F, $10, $C7, $E8, $03, $D4, $C1, $F4, $61, $F4, $61
	db $00, $00, $FF, $FF, $00, $FF, $18, $C3, $36, $99, $6D, $AE, $C3, $43, $AF, $6F
	db $00, $00, $FF, $FF, $00, $FF, $7F, $80, $A5, $7F, $DA, $5A, $DA, $DA, $C7, $C7
	db $00, $00, $FF, $FF, $00, $FF, $FE, $00, $3D, $FE, $C3, $C2, $EF, $EE, $C2, $C3
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $7F, $00, $7F, $00, $7F, $80, $3F
	db $00, $00, $FF, $FF, $1F, $C0, $27, $CF, $20, $DF, $20, $C0, $1F, $C0, $00, $E0
	db $00, $00, $FF, $FF, $FF, $00, $FC, $FE, $00, $FF, $00, $00, $FF, $00, $00, $00
	db $00, $00, $FF, $FF, $00, $7F, $81, $3C, $82, $39, $87, $33, $0C, $34, $0B, $77
	db $00, $00, $FF, $FF, $00, $FF, $F3, $04, $ED, $F3, $5E, $5E, $2C, $2C, $7E, $7E
	db $00, $00, $FF, $FF, $00, $FF, $87, $38, $4B, $97, $BC, $C4, $7E, $7E, $9C, $9C
	db $00, $00, $FF, $FF, $00, $FF, $E0, $0F, $D0, $E7, $30, $27, $F0, $E7, $28, $33
	db $3A, $8A, $18, $CC, $1E, $EE, $18, $E9, $17, $EF, $0F, $E0, $00, $F0, $00, $FF
	db $F5, $F5, $F1, $F9, $FD, $FD, $F1, $F3, $6E, $9F, $9F, $00, $00, $60, $00, $FF
	db $D7, $D7, $D6, $D6, $C6, $E6, $F1, $F9, $EE, $1F, $1F, $00, $00, $60, $00, $FF
	db $C0, $8F, $C0, $9F, $C0, $9F, $40, $9F, $80, $1F, $00, $3F, $00, $7F, $00, $FF
	db $2F, $D7, $2F, $D4, $2F, $C4, $2F, $C7, $17, $C0, $08, $E0, $07, $F0, $00, $F8
	db $D4, $C1, $F4, $61, $F4, $61, $D4, $C1, $E8, $01, $10, $03, $E0, $07, $00, $0F
	db $C3, $43, $AE, $6E, $6E, $2E, $51, $B1, $2E, $9F, $1F, $C0, $00, $E0, $00, $FF
	db $9F, $BF, $BF, $BF, $BF, $BF, $43, $C3, $BD, $7E, $7E, $00, $00, $00, $00, $FF
	db $BD, $BD, $C5, $ED, $D5, $D5, $C2, $E3, $BD, $7E, $7E, $00, $00, $00, $00, $FF
	db $80, $3F, $80, $3F, $80, $3F, $80, $3F, $00, $3F, $00, $7F, $00, $FF, $00, $FF
	db $77, $88, $FF, $22, $FF, $7A, $FF, $2A, $7F, $22, $7F, $9B, $3F, $80, $00, $C0
	db $7F, $80, $7F, $3A, $7F, $2A, $FF, $2B, $FF, $8A, $FF, $32, $FF, $00, $00, $01
	db $0A, $F6, $0D, $75, $CD, $35, $CA, $96, $C3, $19, $01, $1C, $00, $7C, $00, $FF
	db $1E, $1E, $6C, $6C, $6C, $6C, $52, $5E, $ED, $F3, $F3, $00, $00, $04, $00, $FF
	db $6B, $6B, $EC, $EE, $ED, $ED, $DC, $DE, $3B, $F7, $F7, $00, $00, $00, $00, $FF
	db $D8, $D3, $58, $D3, $58, $53, $28, $33, $D0, $E3, $E0, $07, $00, $0F, $00, $FF

; ---- gfx $6E20-$7220 (1024 bytes) [PROBABLE] 64 x 2bpp tiles (0x400, continues the 0x400 HDMA block 6A20-6E20; rendered: button glyphs "A すすむ B もどる"); no call site with hl=$6E20 found; the mapper heuristic cut it at 70A1 (parity 1) which is wrong

Tiles_6A_6E20:: ; 6A:6E20
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $05, $FC, $0A, $F8, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $00, $00, $00, $00, $00, $00, $3F, $00, $40, $3F, $9F, $7F, $BF, $7F, $BF, $7F
	db $00, $00, $00, $00, $00, $00, $FF, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $C0, $00, $20, $C0, $A0, $C0, $A0, $C0, $A0, $C0
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $80, $7F
	db $0B, $F8, $04, $FC, $03, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $00, $00, $00, $FE, $FE, $01, $FF, $01, $C7, $15, $87, $3D, $87, $15, $87
	db $7F, $FF, $BF, $7F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F
	db $39, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF
	db $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F, $5F, $3F
	db $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF
	db $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $C7
	db $15, $87, $3D, $87, $15, $87, $39, $FF, $01, $FF, $FE, $FE, $00, $00, $FF, $00
	db $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $14, $F0, $13, $F0
	db $BF, $7F, $BF, $7F, $BF, $7F, $BF, $7F, $40, $3F, $3F, $00, $00, $00, $FF, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $FF, $00
	db $FF, $00, $00, $00, $7F, $7F, $80, $FF, $80, $E3, $8A, $C3, $9E, $C3, $8A, $C3
	db $8A, $C3, $9E, $C3, $8A, $C3, $9C, $FF, $80, $FF, $7F, $7F, $00, $00, $FF, $00
	db $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0, $A0, $C0
	db $9F, $E0, $C0, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $08, $F8, $07, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $FE, $01, $FE, $01, $FE
	db $00, $00, $FF, $FF, $3F, $80, $78, $3E, $DE, $40, $9F, $BE, $FF, $A3, $FF, $A3
	db $00, $00, $FF, $FF, $00, $7F, $80, $3F, $43, $18, $25, $0B, $A6, $0A, $A5, $0B
	db $00, $00, $FF, $FF, $00, $FF, $38, $83, $D7, $38, $EF, $EF, $04, $04, $AF, $AF
	db $00, $00, $FF, $FF, $00, $FF, $71, $86, $AE, $71, $DF, $DF, $0C, $0C, $5E, $5E
	db $00, $00, $FF, $FF, $00, $FF, $F8, $03, $F4, $F9, $6A, $6C, $36, $34, $7A, $7C
	db $00, $00, $FF, $FF, $00, $FF, $00, $FE, $01, $FC, $03, $FD, $03, $FD, $03, $FD
	db $00, $00, $FF, $FF, $7E, $00, $F1, $7C, $BE, $80, $7D, $7C, $FF, $46, $FF, $46
	db $00, $00, $FF, $FF, $00, $FF, $01, $7C, $83, $39, $46, $1A, $4C, $14, $4A, $16
	db $00, $00, $FF, $FF, $00, $FF, $87, $38, $6A, $97, $DD, $E5, $3D, $3D, $FC, $FC
	db $00, $00, $FF, $FF, $00, $FF, $FF, $00, $53, $FF, $AC, $AC, $AE, $AE, $7C, $7C
	db $00, $00, $FF, $FF, $00, $FF, $E0, $0F, $D0, $E7, $30, $27, $F0, $E7, $28, $33
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $01, $FE, $01, $FE, $01, $FE, $01, $FE, $00, $FE, $00, $FF, $00, $FF, $00, $FF
	db $7F, $BF, $7F, $A3, $77, $23, $77, $23, $B7, $00, $40, $00, $3F, $80, $00, $C0
	db $A3, $08, $A1, $0C, $A1, $0E, $A1, $0E, $41, $0E, $80, $1E, $00, $3F, $00, $7F
	db $AF, $AF, $8F, $CF, $EF, $EF, $8F, $9F, $76, $F9, $F9, $00, $00, $06, $00, $FF
	db $5D, $5D, $1D, $9D, $DC, $DE, $1F, $3F, $EE, $F1, $F1, $00, $00, $06, $00, $FF
	db $7C, $78, $6C, $69, $6C, $69, $14, $99, $E8, $F1, $F0, $03, $00, $07, $00, $FF
	db $02, $FD, $02, $FD, $02, $FC, $02, $FC, $01, $FC, $00, $FE, $00, $FF, $00, $FF
	db $FD, $7C, $FF, $46, $FF, $46, $FD, $7C, $7E, $00, $81, $00, $7E, $00, $00, $80
	db $4C, $14, $4A, $16, $46, $12, $45, $1B, $82, $19, $01, $3C, $00, $7E, $00, $FF
	db $39, $3B, $EB, $EB, $EB, $EB, $14, $1C, $EB, $F7, $F7, $00, $00, $00, $00, $FF
	db $FB, $FB, $FC, $FE, $FD, $FD, $3C, $3E, $DB, $E7, $E7, $00, $00, $00, $00, $FF

; ---- data $7220-$72A0 (128 bytes) [PROBABLE] 16 palettes x 4 RGB555 words (0x80, all bit15 clear); 6C:5A2F loads hl=$7220 bc=$0040 de=$D800 then calls far 4F:4000; first 0x10 bytes read in 12/18 scenarios

Palette_6A_7220:: ; 6A:7220
	db $FF, $7F, $1F, $00, $4A, $29, $00, $00, $E0, $01, $00, $00, $2A, $03, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $FF, $7F, $FF, $7F, $FF, $7F, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $E0, $7F, $FF, $7F, $1F, $00, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $72A0-$72BB (27 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 6A:72A0-72BB [v4: bytes 72B8-72BB were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Data_6A_72A0:: ; 6A:72A0
	db $A4, $72, $AD, $72, $02, $00, $00, $00, $00, $00, $08, $01, $00, $02, $01, $00
	db $00, $00, $01, $08, $01, $00, $02, $00, $2E, $01, $08

; ---- words $72BB-$72BF (4 bytes) [PROBABLE] 1 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$72BB a=$6A at 6C:5D1E (1 entry: 72A0/72B6); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 72BB-72BF were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

Table_6A_72BB:: ; 6A:72BB
	dw Data_6A_72A0, $72B6
