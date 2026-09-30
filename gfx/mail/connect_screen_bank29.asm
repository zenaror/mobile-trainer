; gfx/mail/connect_screen_bank29.asm
; bank 29, $5376-$5B10 (1946 bytes); pinned by layout.link
; palettes, tiles, tilemap loaded by bank 27 (5400/5800/5AD0)

SECTION "gfx/mail/connect_screen_bank29", ROMX

; ---- data $5376-$53F6 (128 bytes) [PROBABLE] palette-rgb555: heuristic: 64 RGB555 words as 16 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_29_5376:: ; 29:5376
	db $FF, $7F, $6C, $7F, $E0, $6C, $00, $00, $9F, $02, $FF, $7F, $F7, $00, $00, $00
	db $FF, $7F, $27, $7E, $00, $34, $00, $00, $DB, $01, $FF, $7F, $F7, $00, $48, $00
	db $9F, $02, $FF, $7F, $F7, $00, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $E0, $7F, $FF, $7F, $EF, $57, $00, $00, $E0, $7F, $FF, $7F, $F7, $00, $00, $00
	db $FF, $7F, $BA, $01, $CF, $72, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- gfx $53F6-$5400 (10 bytes) [PROBABLE] tiles-2bpp: heuristic: 53 coherent tiles (hsim2=0.790 vsim2=0.794, 6 blank) parity 0; 928/944 bytes also covered by call-site blocks [clipped from 53F0-57A0 by higher-priority evidence]

Data_29_53F6:: ; 29:53F6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5400-$5800 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4DCC: hl=$5400 a=$29 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_29_5400:: ; 29:5400
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $FD, $FD
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $EF, $EF, $EF, $EF, $DF, $DF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $DF, $DF, $DB, $DB, $0D, $0D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $7B, $7B, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $C7, $C7, $AB, $AB
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $03, $03
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $87, $87, $FF, $FF, $83, $83
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $BF, $BF, $BF, $BF, $BF, $BF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $F5, $F5, $B5, $B5, $BF, $BF, $BF, $BF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $DF, $DF, $DB, $DB, $0D, $0D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FB, $FB, $7B, $7B, $41, $41
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $CF, $CF, $F7, $F7, $F7, $F7
	db $FF, $FF, $FF, $FF, $FF, $FF, $F5, $F5, $F5, $F5, $FF, $FF, $0F, $0F, $DB, $DB
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $F7, $F7
	db $FF, $FF, $FF, $FF, $FF, $FF, $F5, $F5, $F5, $F5, $FF, $FF, $01, $01, $EF, $EF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $DF, $DF, $DF, $DF, $03, $03
	db $FB, $FB, $FF, $FF, $FF, $FF, $BF, $BF, $BF, $BF, $C1, $C1, $FF, $FF, $FF, $FF
	db $DF, $DF, $9F, $9F, $AD, $AD, $AD, $AD, $6D, $6D, $73, $73, $FF, $FF, $FF, $FF
	db $B5, $B5, $B7, $B7, $77, $77, $77, $77, $F7, $F7, $CF, $CF, $FF, $FF, $FF, $FF
	db $7D, $7D, $7D, $7D, $7D, $7D, $7D, $7D, $6F, $6F, $9F, $9F, $FF, $FF, $FF, $FF
	db $6D, $6D, $6D, $6D, $6D, $6D, $6D, $6D, $6D, $6D, $9B, $9B, $FF, $FF, $FF, $FF
	db $FD, $FD, $FD, $FD, $FD, $FD, $FB, $FB, $F7, $F7, $CF, $CF, $FF, $FF, $FF, $FF
	db $7D, $7D, $FD, $FD, $FD, $FD, $FD, $FD, $FB, $FB, $C7, $C7, $FF, $FF, $FF, $FF
	db $BF, $BF, $BF, $BF, $BD, $BD, $BD, $BD, $BB, $BB, $C7, $C7, $FF, $FF, $FF, $FF
	db $BF, $BF, $BF, $BF, $BD, $BD, $BD, $BD, $BB, $BB, $C7, $C7, $FF, $FF, $FF, $FF
	db $B5, $B5, $B7, $B7, $77, $77, $77, $77, $F7, $F7, $CF, $CF, $FF, $FF, $FF, $FF
	db $7B, $7B, $7B, $7B, $63, $63, $59, $59, $5B, $5B, $67, $67, $FF, $FF, $FF, $FF
	db $EF, $EF, $AF, $AF, $B5, $B5, $75, $75, $75, $75, $CF, $CF, $FF, $FF, $FF, $FF
	db $B9, $B9, $7B, $7B, $7B, $7B, $7B, $7B, $77, $77, $8F, $8F, $FF, $FF, $FF, $FF
	db $F7, $F7, $F1, $F1, $F7, $F7, $87, $87, $73, $73, $8D, $8D, $FF, $FF, $FF, $FF
	db $DF, $DF, $DF, $DF, $DF, $DF, $DF, $DF, $EF, $EF, $F3, $F3, $FF, $FF, $FF, $FF
	db $BF, $BF, $B1, $B1, $BF, $BF, $7F, $7F, $6F, $6F, $71, $71, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $7D, $7D, $79, $79
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $CF, $CF, $EF, $EF, $EF, $EF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $7D, $7D, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $7D, $7D, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $F3, $F3, $EB, $EB, $DB, $DB
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $01, $01, $7F, $7F, $7F, $7F
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $E3, $E3, $DF, $DF, $BF, $BF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $01, $01, $7D, $7D, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $7D, $7D, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $83, $83, $7D, $7D, $7D, $7D
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $75, $75, $6D, $6D, $5D, $5D, $3D, $3D, $7D, $7D, $83, $83, $FF, $FF, $FF, $FF
	db $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $EF, $FF, $FF, $FF, $FF
	db $FD, $FD, $E3, $E3, $9F, $9F, $7F, $7F, $7F, $7F, $01, $01, $FF, $FF, $FF, $FF
	db $FD, $FD, $C3, $C3, $FD, $FD, $7D, $7D, $7D, $7D, $83, $83, $FF, $FF, $FF, $FF
	db $BB, $BB, $BB, $BB, $7B, $7B, $7B, $7B, $01, $01, $FB, $FB, $FF, $FF, $FF, $FF
	db $7F, $7F, $03, $03, $FD, $FD, $FD, $FD, $7D, $7D, $83, $83, $FF, $FF, $FF, $FF
	db $7F, $7F, $03, $03, $7D, $7D, $7D, $7D, $7D, $7D, $83, $83, $FF, $FF, $FF, $FF
	db $FD, $FD, $FB, $FB, $F7, $F7, $EF, $EF, $EF, $EF, $EF, $EF, $FF, $FF, $FF, $FF
	db $7D, $7D, $83, $83, $7D, $7D, $7D, $7D, $7D, $7D, $83, $83, $FF, $FF, $FF, $FF
	db $7D, $7D, $81, $81, $FD, $FD, $FD, $FD, $FB, $FB, $87, $87, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $5800-$5AD0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4DDD: hl=$5800 a=$29 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_29_5800:: ; 29:5800
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $00, $01, $02, $03, $04, $05
	db $06, $07, $01, $08, $09, $01, $0A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $10, $11
	db $12, $13, $14, $15, $16, $17, $11, $18, $19, $11, $1A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $00, $00, $08, $09, $01, $2A, $2A, $0B, $01, $2A, $2A, $0C, $0D, $06
	db $0E, $07, $0F, $2A, $2A, $2A, $00, $00, $18, $19, $11, $2A, $2A, $1B, $11, $2A
	db $2A, $1C, $1D, $16, $1E, $17, $1F, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $10, $10, $08, $08, $08, $00
	db $00, $08, $08, $00, $00, $08, $08, $08, $08, $08, $08, $08, $08, $08, $10, $10
	db $08, $08, $08, $00, $00, $08, $08, $00, $00, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

; ---- data $5AD0-$5B10 (64 bytes) [PROBABLE] verifier: 64-byte palette upload (ld bc,$0040 ; ld hl,$5AD0 ; ld a,$29 ; far call 4F:4000, far-call site at 27:4DA9, found by a ROM scan): first group $0000,$294A,$56B5,$7FFF (bit15 clear, grey ramp; same group repeated in 29:5E30-5E50 and 2A:51F8-5220), the other 56 bytes are all-zero (black) palette entries loaded with it. Was: 8-byte palette + 56-byte zero region

Palette_29_5AD0:: ; 29:5AD0
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
