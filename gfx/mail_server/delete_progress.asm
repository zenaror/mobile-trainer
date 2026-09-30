; gfx/mail_server/delete_progress.asm
; bank 23, $6FD7-$7F30 (3929 bytes); pinned by layout.link
; progress screen tiles, tilemap, palettes, sprite counter digit and object tables

SECTION "gfx/mail_server/delete_progress", ROMX

; ---- zero $6FD7-$6FE0 (9 bytes) [PROBABLE] 0x00 padding between the last function of the bank and the tile block at $6FE0
	ds $9, $00

; ---- gfx $6FE0-$73E0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:5616: hl=$6FE0 a=$23 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles0:: ; 23:6FE0
Data_23_6FE0::
	db $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $FF, $FF, $00, $FE, $01, $FC, $03, $F9, $06, $FA, $07, $FA, $07, $FA
	db $FF, $00, $FF, $FF, $FC, $01, $E2, $F8, $7D, $00, $FA, $F8, $FE, $8C, $FE, $8C
	db $FF, $00, $FF, $FF, $00, $FF, $03, $F8, $05, $7B, $86, $32, $8E, $26, $98, $28
	db $FF, $00, $FF, $FF, $00, $FF, $80, $3F, $41, $9E, $FE, $81, $EF, $FF, $37, $37
	db $FF, $00, $FF, $FF, $00, $FF, $03, $FC, $E5, $0B, $DA, $E6, $1C, $1C, $FE, $FE
	db $FF, $00, $FF, $FF, $00, $FF, $8F, $30, $75, $8F, $FA, $FA, $1A, $1A, $DA, $DA
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $00, $00
	db $05, $FA, $05, $FA, $05, $F8, $05, $F8, $02, $F8, $01, $FC, $00, $FE, $00, $FF
	db $FA, $F8, $FE, $8C, $FE, $8C, $FA, $F8, $FD, $00, $02, $00, $FC, $00, $00, $01
	db $9E, $2E, $98, $28, $8F, $27, $87, $31, $02, $3D, $01, $7C, $00, $FE, $00, $FF
	db $E1, $E1, $35, $35, $77, $77, $77, $55, $AA, $DD, $DD, $00, $00, $00, $00, $FF
	db $F6, $F6, $F6, $F6, $EA, $EE, $15, $1B, $EA, $F1, $F1, $00, $00, $06, $00, $FF
	db $FA, $FA, $FA, $FA, $FA, $FA, $16, $16, $E9, $FF, $FF, $00, $00, $00, $00, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $FE, $FE, $FC, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD
	db $00, $00, $FF, $FF, $24, $FF, $24, $FF, $24, $FF, $3F, $FF, $3F, $FF, $39, $FF
	db $00, $00, $FF, $FF, $92, $FF, $92, $FF, $9F, $FF, $80, $FF, $80, $FF, $1F, $FF
	db $00, $00, $FF, $FF, $41, $FF, $41, $FF, $FF, $FF, $81, $FF, $80, $FF, $FC, $FB
	db $00, $00, $FF, $FF, $01, $FF, $01, $FF, $C7, $FF, $8F, $FF, $95, $FA, $95, $FA
	db $00, $00, $7F, $FF, $92, $FD, $92, $FD, $00, $FF, $00, $FF, $93, $FF, $93, $FF
	db $03, $01, $FC, $F8, $A7, $7F, $A7, $7F, $A7, $FF, $E1, $FF, $E0, $FF, $E4, $FF
	db $F8, $F0, $07, $07, $FC, $FF, $FC, $FF, $FF, $FF, $FE, $FF, $FE, $FF, $F3, $FE
	db $00, $00, $FF, $FF, $56, $EB, $56, $EB, $FE, $FF, $7E, $FF, $7E, $BF, $26, $FF
	db $21, $00, $DE, $FE, $73, $FF, $41, $FF, $41, $FF, $73, $FF, $73, $FF, $73, $FF
	db $E1, $C0, $1E, $1E, $F3, $FF, $00, $FF, $00, $FF, $C3, $BF, $92, $FE, $92, $FE
	db $FF, $FF, $7F, $3F, $BF, $BF, $BF, $BF, $BF, $BF, $BF, $BF, $7F, $3F, $FF, $3F
	db $C3, $FC, $D1, $FE, $E2, $FD, $D0, $FF, $E8, $FF, $F5, $FF, $FA, $FF, $FF, $FF
	db $D2, $00, $7F, $80, $BF, $40, $0A, $F5, $00, $FF, $40, $FF, $AA, $FF, $55, $FF
	db $4B, $00, $FE, $01, $FD, $02, $50, $AF, $00, $FF, $01, $FF, $AA, $FF, $55, $FF
	db $CB, $3F, $97, $7F, $4B, $BF, $17, $FF, $2F, $FF, $5F, $FF, $BF, $FF, $7F, $FF
	db $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FD, $FE, $FC, $FF, $FE, $FF, $FF
	db $39, $FF, $39, $FF, $39, $FF, $01, $FF, $83, $FF, $FE, $FE, $00, $01, $FF, $00
	db $3F, $FF, $3F, $FF, $3F, $DF, $00, $FF, $80, $FF, $FF, $FF, $00, $00, $FF, $00
	db $FC, $FF, $FC, $FF, $F8, $FF, $C1, $FE, $C3, $FD, $FF, $FF, $00, $00, $FF, $00
	db $9F, $FF, $9F, $FF, $8F, $FF, $C3, $FF, $E3, $FF, $3E, $3E, $00, $C1, $FF, $00
	db $93, $FF, $9F, $FF, $9F, $EF, $81, $FF, $C1, $BF, $FF, $FF, $00, $00, $FF, $00
	db $E4, $FF, $E4, $FF, $E4, $FF, $E4, $FF, $E6, $FF, $3F, $3F, $00, $C0, $FF, $00
	db $93, $FF, $93, $FF, $93, $FF, $12, $FF, $32, $FF, $EF, $FF, $00, $00, $FF, $00
	db $26, $FF, $26, $FF, $26, $FF, $26, $FF, $67, $FF, $FD, $F9, $00, $02, $FF, $00
	db $73, $FF, $73, $FF, $73, $FF, $33, $FF, $33, $FF, $FE, $FC, $00, $01, $FF, $01
	db $82, $FE, $C2, $FE, $F2, $FE, $82, $FE, $84, $FD, $F9, $FA, $03, $05, $FF, $83
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $FF, $00, $FF, $00, $55, $AA, $00, $FF, $00, $FF, $AA, $FF, $55, $FF
	db $AA, $FF, $55, $FF, $AA, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $AA, $FF, $D5, $FF, $FA, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $AA, $FF, $55, $FF, $AF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF

; ---- gfx $73E0-$74E0 (256 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:5628: hl=$73E0 a=$23 c=$10 de=$9401 (dest VRAM $9400, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles1:: ; 23:73E0
Data_23_73E0::
	db $3C, $3C, $7E, $66, $77, $66, $77, $66, $77, $66, $77, $66, $3F, $3C, $1E, $00
	db $18, $18, $7C, $78, $3C, $18, $1C, $18, $1C, $18, $1C, $18, $1C, $18, $0C, $00
	db $3C, $3C, $7E, $66, $77, $66, $3F, $0C, $1E, $18, $3C, $30, $7F, $7E, $3F, $00
	db $3C, $3C, $7E, $66, $77, $66, $3F, $0C, $6E, $66, $77, $66, $3F, $3C, $1E, $00
	db $0C, $0C, $1E, $1C, $3E, $2C, $7E, $6C, $7F, $6C, $7F, $7E, $3E, $0C, $06, $00
	db $7E, $7E, $7F, $60, $70, $60, $7C, $7C, $3E, $06, $67, $66, $3F, $3C, $1E, $00
	db $3C, $3C, $7E, $66, $73, $60, $7C, $7C, $7E, $66, $77, $66, $3F, $3C, $1E, $00
	db $7E, $7E, $7F, $66, $77, $66, $37, $04, $0E, $08, $1C, $18, $1C, $18, $0C, $00
	db $3C, $3C, $7E, $66, $77, $66, $3F, $3C, $7F, $66, $77, $66, $3F, $3C, $1E, $00
	db $3C, $3C, $7E, $66, $77, $66, $3F, $3E, $1F, $06, $67, $66, $3F, $3C, $1E, $00
	db $00, $00, $18, $18, $1C, $18, $0C, $00, $18, $18, $1C, $18, $0C, $00, $00, $00
	db $FF, $00, $00, $FF, $FF, $FF, $00, $00, $FF, $00, $00, $FF, $00, $00, $00, $00
	db $FF, $00, $2F, $CF, $08, $E7, $A4, $F3, $54, $79, $6A, $39, $0A, $99, $2A, $99
	db $32, $99, $32, $99, $32, $99, $32, $99, $32, $99, $32, $99, $32, $99, $32, $99
	db $FF, $00, $FF, $FF, $00, $FF, $80, $3F, $40, $9F, $C0, $9F, $E0, $8F, $D0, $E7
	db $B0, $A7, $B0, $A7, $B0, $A7, $50, $67, $A0, $C7, $C0, $0F, $00, $1F, $00, $FF

; ---- gfx $74E0-$7640 (352 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 23:563A: hl=$74E0 a=$23 c=$16 de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_MailSrvDelProgress_Tiles2:: ; 23:74E0
Data_23_74E0::
	db $1C, $22, $36, $00, $36, $00, $36, $00, $36, $00, $36, $00, $1C, $22, $00, $00
	db $1C, $00, $0C, $10, $0C, $00, $0C, $00, $0C, $00, $0C, $00, $0C, $00, $00, $00
	db $3C, $02, $02, $00, $1C, $22, $30, $08, $30, $08, $30, $00, $3E, $00, $00, $00
	db $3C, $02, $06, $00, $1C, $02, $06, $00, $06, $00, $06, $08, $3C, $02, $00, $00
	db $0E, $00, $16, $08, $36, $00, $36, $00, $36, $00, $3F, $00, $06, $00, $00, $00
	db $3E, $00, $30, $00, $3C, $02, $06, $00, $06, $00, $06, $08, $3C, $02, $00, $00
	db $1C, $20, $30, $00, $3C, $02, $36, $00, $36, $00, $36, $00, $1C, $22, $00, $00
	db $3E, $00, $06, $38, $0C, $02, $18, $04, $18, $04, $18, $00, $18, $00, $00, $00
	db $1C, $22, $36, $08, $1C, $22, $36, $08, $36, $00, $36, $08, $1C, $22, $00, $00
	db $1C, $22, $36, $00, $36, $00, $1E, $20, $06, $00, $06, $08, $1C, $02, $00, $00
	db $00, $00, $63, $63, $F7, $94, $FF, $98, $FF, $98, $BF, $C8, $5B, $6C, $2C, $37
	db $00, $00, $C6, $C6, $EF, $29, $FF, $19, $DF, $39, $DD, $33, $9A, $76, $34, $EC
	db $12, $1F, $0B, $0C, $07, $04, $07, $04, $07, $04, $07, $04, $05, $06, $04, $07
	db $48, $F8, $D0, $30, $E0, $20, $E0, $20, $E0, $20, $E0, $20, $A0, $60, $20, $E0
	db $04, $07, $0F, $05, $0B, $0D, $1F, $09, $36, $3A, $5E, $62, $42, $7E, $3C, $3C
	db $20, $E0, $F0, $A0, $D0, $B0, $F8, $90, $6C, $5C, $7A, $46, $42, $7E, $3C, $3C
	db $00, $00, $00, $00, $FF, $FF, $80, $FF, $B6, $CF, $B0, $CF, $B5, $CF, $80, $FF
	db $00, $00, $00, $00, $FF, $FF, $01, $FF, $D5, $FF, $01, $FF, $51, $FF, $01, $FF
	db $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00
	db $01, $FF, $01, $FF, $F1, $FF, $01, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $08, $00, $18, $10, $30, $20, $00, $00, $00, $00
	db $00, $00, $20, $20, $30, $10, $18, $00, $08, $00, $00, $00, $00, $00, $F0, $60

; ---- data $7640-$7910 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 23:564B: hl=$7640 a=$23 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailSrvDelProgress_Screen:: ; 23:7640
Data_23_7640::
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $20, $21, $22, $23
	db $24, $25, $26, $27, $28, $29, $2A, $2B, $01, $01, $01, $01, $01, $01, $01, $01
	db $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $2C, $2D, $3C, $3C, $3C, $3C, $3C, $3C, $3C
	db $3C, $3C, $3C, $2E, $2F, $01, $01, $01, $01, $01, $01, $01, $3E, $3D, $3D, $3D
	db $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3F, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $18, $1A, $1B, $1C, $1D, $1E, $1F, $3B, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $19, $09, $0A, $0B, $0C
	db $0D, $0E, $0F, $01, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $00, $01, $02, $03, $04, $05, $06, $07
	db $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $10, $11, $12, $13, $14, $15, $16, $17
	db $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $20, $21, $22, $23, $24, $25, $26, $27
	db $4C, $4B, $4B, $4B, $4B, $4B, $4C, $00, $00, $00, $00, $00, $00, $02, $03, $04
	db $05, $06, $07, $4E, $4D, $40, $40, $4A, $40, $40, $4D, $10, $10, $10, $10, $10
	db $10, $12, $13, $14, $15, $16, $17, $4F, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $09, $09, $09, $09, $09, $09, $09, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09, $09, $09
	db $09, $09, $09, $09, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $29, $29, $29, $29, $29, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- data $7910-$7950 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7910 a=$23 bc=$0040 de=$D800) at 23:55F3; call site never executed; replaces the mapper palette guess 7910-7A3F which swallowed the object tables

Palette_MailSrvDelProgress_Bg:: ; 23:7910
Palette_23_7910::
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $2C, $21, $00, $00, $5F, $03, $FF, $7F
	db $00, $00, $61, $1D, $22, $47, $FF, $7F, $00, $00, $A5, $02, $EC, $7E, $FF, $7F
	db $00, $00, $5F, $02, $F7, $00, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $7950-$7990 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7950 a=$23 bc=$0040 de=$D840) at 23:5604; call site never executed

Palette_MailSrvDelProgress_Obj:: ; 23:7950
Palette_23_7950::
	db $8B, $6F, $00, $00, $B5, $56, $FF, $7F, $8B, $6F, $7F, $02, $B7, $01, $00, $00
	db $8B, $6F, $40, $02, $FF, $4F, $00, $00, $8B, $6F, $4A, $29, $B5, $56, $FF, $7F
	db $8B, $6F, $4A, $29, $B5, $56, $FF, $7F, $8B, $6F, $4A, $29, $B5, $56, $FF, $7F
	db $8B, $6F, $4A, $29, $B5, $56, $FF, $7F, $8B, $6F, $4A, $29, $B5, $56, $FF, $7F

; ---- words $7990-$7AE0 (336 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $7990 is passed as de with a=$23 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 7AE0/7AE7 7AE0/7AE7 7AE0/7AE7 7AE0/7AE7

Table_SpriteCounter_Digits:: ; 23:7990
Table_23_7990::
	dw Table_23_7AE0, Data_23_7AE7, Table_23_7AE0, Data_23_7AE7, Table_23_7AE0, Data_23_7AE7, Table_23_7AE0, Data_23_7AE7
	dw Table_23_7AEA, Data_23_7AF1, Table_23_7AEA, Data_23_7AF1, Table_23_7AEA, Data_23_7AF1, Table_23_7AEA, Data_23_7AF1
	dw Table_23_7AF4, Data_23_7AFB, Table_23_7AF4, Data_23_7AFB, Table_23_7AF4, Data_23_7AFB, Table_23_7AF4, Data_23_7AFB
	dw Table_23_7AFE, Data_23_7B05, Table_23_7AFE, Data_23_7B05, Table_23_7AFE, Data_23_7B05, Table_23_7AFE, Data_23_7B05
	dw Table_23_7B08, Data_23_7B0F, Table_23_7B08, Data_23_7B0F, Table_23_7B08, Data_23_7B0F, Table_23_7B08, Data_23_7B0F
	dw Table_23_7B12, Data_23_7B19, Table_23_7B12, Data_23_7B19, Table_23_7B12, Data_23_7B19, Table_23_7B12, Data_23_7B19
	dw Table_23_7B1C, Data_23_7B23, Table_23_7B1C, Data_23_7B23, Table_23_7B1C, Data_23_7B23, Table_23_7B1C, Data_23_7B23
	dw Table_23_7B26, Data_23_7B2D, Table_23_7B26, Data_23_7B2D, Table_23_7B26, Data_23_7B2D, Table_23_7B26, Data_23_7B2D
	dw Table_23_7B30, Data_23_7B37, Table_23_7B30, Data_23_7B37, Table_23_7B30, Data_23_7B37, Table_23_7B30, Data_23_7B37
	dw Table_23_7B3A, Data_23_7B41, Table_23_7B3A, Data_23_7B41, Table_23_7B3A, Data_23_7B41, Table_23_7B3A, Data_23_7B41
	dw Table_23_7B44, Data_23_7B4B, Table_23_7B44, Data_23_7B4B, Table_23_7B44, Data_23_7B4B, Table_23_7B44, Data_23_7B4B
	dw Table_23_7B4E, Data_23_7B55, Table_23_7B4E, Data_23_7B55, Table_23_7B4E, Data_23_7B55, Table_23_7B4E, Data_23_7B55
	dw Table_23_7B58, Data_23_7B5F, Table_23_7B58, Data_23_7B5F, Table_23_7B58, Data_23_7B5F, Table_23_7B58, Data_23_7B5F
	dw Table_23_7B62, Data_23_7B69, Table_23_7B62, Data_23_7B69, Table_23_7B62, Data_23_7B69, Table_23_7B62, Data_23_7B69
	dw Table_23_7B6C, Data_23_7B73, Table_23_7B6C, Data_23_7B73, Table_23_7B6C, Data_23_7B73, Table_23_7B6C, Data_23_7B73
	dw Table_23_7B76, Data_23_7B7D, Table_23_7B76, Data_23_7B7D, Table_23_7B76, Data_23_7B7D, Table_23_7B76, Data_23_7B7D
	dw Table_23_7B80, Data_23_7B87, Table_23_7B80, Data_23_7B87, Table_23_7B80, Data_23_7B87, Table_23_7B80, Data_23_7B87
	dw Table_23_7B8A, Data_23_7B91, Table_23_7B8A, Data_23_7B91, Table_23_7B8A, Data_23_7B91, Table_23_7B8A, Data_23_7B91
	dw Table_23_7B94, Data_23_7B9B, Table_23_7B94, Data_23_7B9B, Table_23_7B94, Data_23_7B9B, Table_23_7B94, Data_23_7B9B
	dw Table_23_7B9E, Data_23_7BA5, Table_23_7B9E, Data_23_7BA5, Table_23_7B9E, Data_23_7BA5, Table_23_7B9E, Data_23_7BA5

Table_MailSrvDel_ProgressObject:: ; 23:7AD0
	dw Table_23_7BA8, Data_23_7BFE, Table_23_7BA8, Data_23_7BFE, Table_23_7BA8, Data_23_7BFE, Table_23_7BA8, Data_23_7BFE

; ---- words $7AE0-$7AE2 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7AE0:: ; 23:7AE0
	dw Data_23_7AE2

; ---- data $7AE2-$7AE7 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7AE2:: ; 23:7AE2
	db $01, $FD, $0D, $00, $00

; ---- data $7AE7-$7AEA (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7AE7:: ; 23:7AE7
	db $01, $00, $04

; ---- words $7AEA-$7AEC (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7AEA:: ; 23:7AEA
	dw Data_23_7AEC

; ---- data $7AEC-$7AF1 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7AEC:: ; 23:7AEC
	db $01, $FD, $0D, $01, $00

; ---- data $7AF1-$7AF4 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7AF1:: ; 23:7AF1
	db $01, $00, $04

; ---- words $7AF4-$7AF6 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7AF4:: ; 23:7AF4
	dw Data_23_7AF6

; ---- data $7AF6-$7AFB (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7AF6:: ; 23:7AF6
	db $01, $FD, $0D, $02, $00

; ---- data $7AFB-$7AFE (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7AFB:: ; 23:7AFB
	db $01, $00, $04

; ---- words $7AFE-$7B00 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7AFE:: ; 23:7AFE
	dw Data_23_7B00

; ---- data $7B00-$7B05 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B00:: ; 23:7B00
	db $01, $FD, $0D, $03, $00

; ---- data $7B05-$7B08 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B05:: ; 23:7B05
	db $01, $00, $04

; ---- words $7B08-$7B0A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B08:: ; 23:7B08
	dw Data_23_7B0A

; ---- data $7B0A-$7B0F (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B0A:: ; 23:7B0A
	db $01, $FD, $0D, $04, $00

; ---- data $7B0F-$7B12 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B0F:: ; 23:7B0F
	db $01, $00, $04

; ---- words $7B12-$7B14 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B12:: ; 23:7B12
	dw Data_23_7B14

; ---- data $7B14-$7B19 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B14:: ; 23:7B14
	db $01, $FD, $0D, $05, $00

; ---- data $7B19-$7B1C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B19:: ; 23:7B19
	db $01, $00, $04

; ---- words $7B1C-$7B1E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B1C:: ; 23:7B1C
	dw Data_23_7B1E

; ---- data $7B1E-$7B23 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B1E:: ; 23:7B1E
	db $01, $FD, $0D, $06, $00

; ---- data $7B23-$7B26 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B23:: ; 23:7B23
	db $01, $00, $04

; ---- words $7B26-$7B28 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B26:: ; 23:7B26
	dw Data_23_7B28

; ---- data $7B28-$7B2D (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B28:: ; 23:7B28
	db $01, $FD, $0D, $07, $00

; ---- data $7B2D-$7B30 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B2D:: ; 23:7B2D
	db $01, $00, $04

; ---- words $7B30-$7B32 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B30:: ; 23:7B30
	dw Data_23_7B32

; ---- data $7B32-$7B37 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B32:: ; 23:7B32
	db $01, $FD, $0D, $08, $00

; ---- data $7B37-$7B3A (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B37:: ; 23:7B37
	db $01, $00, $04

; ---- words $7B3A-$7B3C (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B3A:: ; 23:7B3A
	dw Data_23_7B3C

; ---- data $7B3C-$7B41 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B3C:: ; 23:7B3C
	db $01, $FD, $0D, $09, $00

; ---- data $7B41-$7B44 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B41:: ; 23:7B41
	db $01, $00, $04

; ---- words $7B44-$7B46 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B44:: ; 23:7B44
	dw Data_23_7B46

; ---- data $7B46-$7B4B (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B46:: ; 23:7B46
	db $01, $05, $0D, $00, $00

; ---- data $7B4B-$7B4E (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B4B:: ; 23:7B4B
	db $01, $00, $04

; ---- words $7B4E-$7B50 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B4E:: ; 23:7B4E
	dw Data_23_7B50

; ---- data $7B50-$7B55 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B50:: ; 23:7B50
	db $01, $05, $0D, $01, $00

; ---- data $7B55-$7B58 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B55:: ; 23:7B55
	db $01, $00, $04

; ---- words $7B58-$7B5A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B58:: ; 23:7B58
	dw Data_23_7B5A

; ---- data $7B5A-$7B5F (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B5A:: ; 23:7B5A
	db $01, $05, $0D, $02, $00

; ---- data $7B5F-$7B62 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B5F:: ; 23:7B5F
	db $01, $00, $04

; ---- words $7B62-$7B64 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B62:: ; 23:7B62
	dw Data_23_7B64

; ---- data $7B64-$7B69 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B64:: ; 23:7B64
	db $01, $05, $0D, $03, $00

; ---- data $7B69-$7B6C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B69:: ; 23:7B69
	db $01, $00, $04

; ---- words $7B6C-$7B6E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B6C:: ; 23:7B6C
	dw Data_23_7B6E

; ---- data $7B6E-$7B73 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B6E:: ; 23:7B6E
	db $01, $05, $0D, $04, $00

; ---- data $7B73-$7B76 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B73:: ; 23:7B73
	db $01, $00, $04

; ---- words $7B76-$7B78 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B76:: ; 23:7B76
	dw Data_23_7B78

; ---- data $7B78-$7B7D (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B78:: ; 23:7B78
	db $01, $05, $0D, $05, $00

; ---- data $7B7D-$7B80 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B7D:: ; 23:7B7D
	db $01, $00, $04

; ---- words $7B80-$7B82 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B80:: ; 23:7B80
	dw Data_23_7B82

; ---- data $7B82-$7B87 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B82:: ; 23:7B82
	db $01, $05, $0D, $06, $00

; ---- data $7B87-$7B8A (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B87:: ; 23:7B87
	db $01, $00, $04

; ---- words $7B8A-$7B8C (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B8A:: ; 23:7B8A
	dw Data_23_7B8C

; ---- data $7B8C-$7B91 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B8C:: ; 23:7B8C
	db $01, $05, $0D, $07, $00

; ---- data $7B91-$7B94 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B91:: ; 23:7B91
	db $01, $00, $04

; ---- words $7B94-$7B96 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B94:: ; 23:7B94
	dw Data_23_7B96

; ---- data $7B96-$7B9B (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7B96:: ; 23:7B96
	db $01, $05, $0D, $08, $00

; ---- data $7B9B-$7B9E (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7B9B:: ; 23:7B9B
	db $01, $00, $04

; ---- words $7B9E-$7BA0 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7B9E:: ; 23:7B9E
	dw Data_23_7BA0

; ---- data $7BA0-$7BA5 (5 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 1 piece(s); length tiles exactly against the frame-table pointers

Data_23_7BA0:: ; 23:7BA0
	db $01, $05, $0D, $09, $00

; ---- data $7BA5-$7BA8 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_23_7BA5:: ; 23:7BA5
	db $01, $00, $04

; ---- words $7BA8-$7BAC (4 bytes) [PROBABLE] sprite frame table: 2 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_23_7BA8:: ; 23:7BA8
	dw Data_23_7BAC, Data_23_7BD5

; ---- data $7BAC-$7BD5 (41 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 10 piece(s); length tiles exactly against the frame-table pointers

Data_23_7BAC:: ; 23:7BAC
	db $0A, $32, $48, $0A, $01, $32, $50, $0B, $01, $3A, $48, $0C, $01, $3A, $50, $0D
	db $01, $42, $48, $0E, $01, $42, $50, $0F, $01, $26, $48, $10, $02, $26, $50, $11
	db $02, $2E, $48, $12, $02, $2E, $50, $13, $02

; ---- data $7BD5-$7BFE (41 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 10 piece(s); length tiles exactly against the frame-table pointers

Data_23_7BD5:: ; 23:7BD5
	db $0A, $32, $48, $0A, $01, $32, $50, $0B, $01, $3A, $48, $0C, $01, $3A, $50, $0D
	db $01, $42, $48, $0E, $01, $42, $50, $0F, $01, $2D, $43, $14, $02, $25, $43, $15
	db $02, $2D, $54, $14, $22, $25, $54, $15, $22

; ---- data $7BFE-$7C03 (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:20 1:29

Data_23_7BFE:: ; 23:7BFE
	db $02, $00, $14, $01, $1D

; ---- data $7C03-$7F30 (813 bytes) [HYPOTHESIS] tilemap/attribute-like index data (all bytes < $40, 20-byte rows of runs of $11/$2F/$08/$10 and small ascending index runs 08-0F/18-1F/02-07/12-17); the mapper called 7C01-7E81 "tiles-2bpp" (coherence 0.66/0.88) but repeated-byte runs give that score to tilemaps as well and no loader references these bytes; extent 7E81-7F30 (previously unclassified) continues the same pattern (the $08 fill is an attribute-map pattern) - purpose unknown

Data_23_7C03:: ; 23:7C03
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $2F, $2F, $2F, $2F, $2F, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F, $20, $21
	db $22, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $18, $19, $1A, $1B, $1C, $1D
	db $1E, $1F, $30, $31, $32, $2F, $2F, $2F, $2F, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $02, $03, $04, $05, $06, $07, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $12, $13, $14, $15, $16
	db $17, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $2F, $2F, $2F, $2F, $2F, $08, $09
	db $0A, $0B, $0C, $0D, $23, $21, $25, $27, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F
	db $2F, $2F, $18, $19, $1A, $1B, $1C, $1D, $24, $31, $26, $28, $2F, $2F, $2F, $2F
	db $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
	db $03, $04, $05, $06, $07, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $12, $13, $14, $15, $16, $17, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $2F, $2F, $2F, $2F, $2F, $08, $09, $0A, $0B, $29, $2B, $2D, $0E, $0F, $20
	db $21, $22, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $2F, $18, $19, $1A, $1B, $2A, $2C
	db $2E, $1E, $1F, $30, $31, $32, $2F, $2F, $2F, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $02, $03, $04, $05, $06, $07, $10, $10, $10
	db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $12, $13, $14, $15, $16
	db $17, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
	db $11, $11, $11, $11, $11, $11, $11, $11, $11, $2F, $2F, $2F, $2F, $2F, $08, $09
	db $0A, $0B, $29, $2B, $2D, $23, $21, $25, $27, $2F, $2F, $2F, $2F, $2F, $2F, $2F
	db $2F, $2F, $18, $19, $1A, $1B, $2A, $2C, $2E, $24, $31, $26, $28, $2F, $2F, $2F
	db $2F, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $02
	db $03, $04, $05, $06, $07, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
	db $10, $10, $10, $12, $13, $14, $15, $16, $17, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
