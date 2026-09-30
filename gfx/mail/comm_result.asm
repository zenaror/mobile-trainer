; gfx/mail/comm_result.asm
; bank 24, $6BF0-$7D48 (4440 bytes); pinned by layout.link
; tiles/tilemap/palettes/objects of the communication result and server status screens (loaded by bank 29)

SECTION "gfx/mail/comm_result", ROMX

; ---- gfx $6BF0-$6FF0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40D3: hl=$6BF0 a=$24 c=$40 de=$8801 (dest VRAM $8800, vbank=1)

MailResult_Tiles_6BF0:: ; 24:6BF0
Data_24_6BF0::
	db $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $3F, $00, $3F, $80
	db $FF, $00, $FF, $00, $FE, $01, $FD, $03, $FA, $06, $FA, $06, $FA, $06, $FA, $06
	db $FF, $00, $FF, $00, $03, $FC, $FC, $FF, $03, $03, $05, $F9, $01, $FD, $00, $0C
	db $FF, $00, $FF, $00, $03, $FC, $FD, $FE, $02, $03, $03, $7B, $02, $7A, $02, $02
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $1E, $E1, $ED, $F3, $12, $1E, $12, $DE
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $1F, $E0, $EE, $F1, $15, $1B, $15, $DB
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $FF, $FF, $00, $00, $00, $66
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7F, $80, $BE, $C1, $BD, $C3
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $E1, $1F, $1E, $FE, $E2, $E2
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $10, $EF, $EF, $FF, $10, $10, $10, $D6
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $7D, $83, $BA, $C6, $BA, $C6
	db $FF, $00, $FF, $00, $FF, $00, $F0, $0F, $0F, $FF, $F0, $F0, $00, $07, $00, $F5
	db $FF, $00, $FF, $00, $FF, $00, $7F, $80, $BF, $C0, $5F, $60, $50, $6F, $4E, $7F
	db $FF, $00, $C0, $3F, $BF, $7F, $40, $C0, $40, $DE, $40, $DE, $80, $80, $81, $BE
	db $03, $FD, $03, $FC, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $FF, $FF, $FF, $01, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD
	db $3F, $80, $3F, $80, $3F, $80, $3F, $80, $3F, $80, $3F, $80, $00, $80, $00, $FF
	db $FD, $03, $FE, $01, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $3D, $03, $3D, $83
	db $E0, $EC, $20, $EC, $A0, $6C, $A1, $6D, $21, $ED, $E1, $ED, $01, $0D, $01, $7D
	db $04, $F8, $00, $FC, $00, $0C, $E0, $EC, $20, $EC, $E0, $EC, $00, $0C, $00, $7C
	db $12, $DE, $12, $DE, $12, $DE, $1E, $DE, $00, $C0, $00, $CC, $00, $CC, $00, $FC
	db $11, $DF, $1F, $DF, $00, $C0, $00, $F6, $00, $F6, $00, $D6, $00, $D6, $00, $DE
	db $00, $66, $00, $6F, $00, $6F, $00, $66, $00, $66, $00, $66, $00, $66, $00, $6E
	db $42, $7E, $7E, $7E, $00, $01, $00, $01, $04, $78, $00, $7C, $00, $0C, $00, $3C
	db $00, $0C, $00, $CC, $00, $F6, $00, $F6, $00, $D8, $00, $D8, $00, $D8, $00, $D8
	db $00, $C6, $00, $DF, $00, $DF, $00, $C6, $00, $C6, $00, $DF, $00, $D7, $00, $DE
	db $42, $7E, $7E, $7E, $01, $01, $02, $3C, $00, $3E, $80, $06, $00, $86, $00, $9E
	db $00, $F7, $00, $30, $00, $67, $00, $67, $00, $66, $00, $66, $00, $66, $00, $7E
	db $51, $71, $30, $34, $30, $B7, $30, $B7, $30, $34, $C0, $C4, $C1, $DE, $C0, $D7
	db $80, $BF, $00, $03, $78, $7B, $48, $7B, $48, $7B, $B8, $FB, $40, $43, $40, $5F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF
	db $03, $FD, $03, $FC, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $FF
	db $FF, $FF, $FF, $01, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $03, $FD, $FF, $FF
	db $3D, $83, $3D, $83, $3E, $81, $3F, $80, $3F, $80, $00, $80, $00, $FF, $FF, $FF
	db $05, $79, $03, $03, $FC, $FF, $01, $FE, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $04, $78, $03, $03, $FC, $FF, $01, $FE, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $84, $78, $02, $02, $FD, $FF, $00, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $00, $DE, $00, $00, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $02, $6C, $01, $01, $FE, $FF, $00, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $84, $B8, $82, $82, $7D, $FF, $80, $7F, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $00, $D8, $02, $02, $FD, $FF, $02, $FD, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $00, $DE, $00, $00, $FF, $FF, $00, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $02, $1C, $C1, $C1, $3E, $FF, $40, $BF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $00, $3C, $81, $81, $7E, $FF, $80, $7F, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $C0, $DD, $40, $C0, $3F, $FF, $C0, $3F, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $41, $5E, $40, $40, $BF, $FF, $00, $FF, $FF, $00, $00, $00, $00, $FF, $FF, $FF
	db $FF, $00, $FF, $00, $7F, $80, $BF, $C0, $BF, $C0, $BF, $C0, $BF, $C0, $5F, $60
	db $5F, $60, $5F, $60, $5F, $60, $5F, $60, $5F, $60, $5F, $60, $5C, $60, $5C, $61
	db $5C, $61, $9C, $E1, $3C, $C1, $7C, $81, $FC, $01, $00, $01, $00, $FF, $FF, $FF
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FC, $03, $F8, $06, $F8, $04
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $00, $00
	db $F8, $04, $F8, $04, $F8, $04, $F8, $04, $F8, $04, $F8, $04, $F8, $04, $F8, $04
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $3F, $C0, $1F, $20, $1F, $00
	db $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00, $1F, $00
	db $00, $07, $07, $18, $18, $20, $23, $54, $27, $48, $4F, $90, $5F, $80, $5F, $8E
	db $59, $88, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80
	db $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $80
	db $5F, $80, $5F, $80, $5F, $80, $5F, $80, $5F, $8E, $59, $88, $5F, $80, $5F, $80
	db $0F, $70, $27, $58, $1F, $20, $0F, $17, $00, $07, $00, $00, $00, $00, $00, $00
	db $00, $E0, $E0, $18, $08, $14, $E4, $1A, $F4, $0A, $FE, $01, $FE, $03, $FE, $73
	db $CE, $43, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03
	db $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $03

; ---- gfx $6FF0-$73F0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40E5: hl=$6FF0 a=$24 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

MailResult_Tiles_6FF0:: ; 24:6FF0
Data_24_6FF0::
	db $FE, $03, $FE, $03, $FE, $03, $FE, $03, $FE, $73, $CE, $43, $FE, $03, $FE, $03
	db $FE, $04, $FC, $06, $F8, $1C, $F0, $E8, $00, $E0, $00, $00, $00, $00, $00, $00
	db $00, $FF, $FF, $00, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FC, $02, $F9, $05
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $FF
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7F, $80, $3F, $40
	db $F9, $04, $FC, $02, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $00, $00, $00
	db $FF, $00, $00, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $00, $00, $00
	db $3F, $40, $7F, $80, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $00, $00, $00, $00
	db $FA, $02, $FA, $02, $FA, $02, $FA, $02, $FA, $02, $FA, $02, $FA, $02, $FA, $02
	db $BF, $00, $BF, $00, $BF, $00, $BF, $00, $BF, $00, $BF, $00, $BF, $00, $BF, $00
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $3F, $3F
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $FF, $FF
	db $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $FE, $FE
	db $20, $20, $2E, $2E, $6A, $6A, $AA, $EA, $AE, $EE, $A0, $E0, $A0, $E0, $A0, $E0
	db $00, $00, $00, $00, $00, $00, $3B, $3B, $00, $00, $00, $00, $35, $35, $00, $00
	db $02, $02, $02, $02, $03, $03, $F2, $F3, $02, $03, $03, $03, $A2, $A3, $02, $03
	db $00, $00, $00, $00, $FE, $FE, $79, $FF, $FD, $FF, $FD, $FF, $85, $87, $85, $87
	db $A7, $E7, $A8, $E8, $B0, $F0, $B0, $F0, $B0, $F0, $B0, $F0, $90, $F0, $88, $E8
	db $80, $80, $40, $40, $20, $20, $20, $20, $26, $26, $39, $39, $29, $39, $52, $73
	db $02, $03, $02, $03, $02, $03, $03, $03, $02, $02, $FF, $FF, $0D, $FF, $01, $FF
	db $85, $87, $49, $CF, $85, $87, $15, $17, $AD, $AF, $D5, $D7, $25, $27, $C5, $C7
	db $B4, $F4, $D0, $D0, $88, $88, $F8, $F8, $88, $88, $FF, $7F, $00, $00, $FF, $FF
	db $A7, $A7, $08, $08, $30, $30, $3F, $3F, $20, $20, $FF, $FF, $00, $00, $FF, $FF
	db $FF, $FF, $00, $00, $00, $00, $FF, $FF, $00, $00, $FF, $FF, $00, $00, $FF, $FF
	db $FF, $FF, $01, $01, $03, $03, $FD, $FD, $05, $05, $FF, $FE, $00, $00, $FF, $FF
	db $FF, $00, $00, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $07, $07, $04, $04
	db $FF, $00, $00, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $FF, $FF, $00, $00
	db $FF, $00, $00, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $00, $C0, $C0, $40, $40
	db $05, $05, $05, $05, $7D, $7D, $85, $FD, $84, $FC, $84, $FC, $84, $FC, $84, $FC
	db $C0, $C0, $40, $40, $47, $47, $C0, $C0, $00, $00, $06, $06, $00, $00, $00, $00
	db $00, $00, $00, $00, $7E, $7E, $00, $00, $00, $00, $B4, $B4, $00, $00, $00, $00
	db $40, $40, $40, $40, $7E, $7E, $41, $7F, $41, $7F, $41, $7F, $41, $7F, $41, $7F
	db $84, $FC, $9C, $FC, $A4, $E4, $A4, $E4, $A7, $E7, $A0, $E0, $9C, $FC, $83, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $90, $F0, $50, $70, $30, $30
	db $00, $00, $00, $00, $00, $00, $00, $00, $FF, $FF, $12, $1E, $14, $1C, $19, $19
	db $41, $7F, $71, $7F, $49, $4F, $49, $4F, $C9, $CF, $09, $0F, $71, $7F, $81, $FF
	db $80, $FF, $80, $FF, $80, $FF, $80, $FF, $80, $FF, $FF, $7F, $00, $00, $FF, $FF
	db $D8, $D8, $28, $E8, $14, $F4, $08, $F8, $08, $F8, $FF, $FF, $00, $00, $FF, $FF
	db $36, $37, $28, $2F, $50, $5F, $20, $3F, $20, $3F, $FF, $FF, $00, $00, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $06, $06, $1F, $1F, $1F, $1F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $70, $70, $78, $39, $39
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $E0, $E0, $C0, $C0
	db $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $03, $03, $1F, $1F, $1F, $1F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $87, $87
	db $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $60, $60, $60, $60, $60, $E0
	db $00, $00, $00, $00, $00, $00, $00, $00, $06, $06, $06, $06, $06, $06, $06, $06
	db $00, $00, $00, $00, $00, $00, $00, $00, $C0, $C0, $C0, $C0, $C0, $C0, $C0, $C0
	db $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $18, $18, $1F, $1F
	db $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $18, $18, $9F, $9F
	db $00, $00, $00, $00, $00, $00, $00, $00, $AC, $AC, $AC, $AC, $AC, $AC, $0C, $0C
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $60, $60, $77, $77, $37, $77
	db $00, $00, $00, $00, $00, $00, $00, $00, $C0, $C0, $C0, $C0, $E0, $E0, $E1, $E1
	db $00, $00, $00, $00, $00, $00, $00, $00, $18, $18, $18, $18, $18, $18, $D8, $F8
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $01, $01, $01, $01, $01, $01
	db $00, $00, $00, $00, $00, $00, $00, $00, $B0, $B0, $B0, $B0, $B0, $B0, $B0, $B0
	db $06, $C6, $CF, $0F, $1F, $1F, $BE, $3E, $B6, $36, $BE, $3E, $9C, $1E, $C0, $00
	db $1B, $1B, $C7, $C7, $E7, $E7, $63, $63, $69, $61, $EC, $E0, $CE, $E0, $1F, $00
	db $80, $80, $2F, $0F, $0F, $0F, $80, $80, $C0, $C0, $E7, $E7, $67, $67, $00, $00
	db $06, $06, $86, $CE, $CE, $CE, $CC, $CE, $CD, $CD, $CD, $CD, $8C, $CC, $20, $00
	db $07, $07, $F1, $F1, $F4, $F0, $04, $01, $81, $C1, $F7, $F7, $F7, $F7, $00, $00
	db $E3, $E3, $F3, $FB, $F8, $F8, $DB, $D8, $C3, $C0, $9F, $C0, $3F, $80, $7F, $00
	db $E6, $E6, $E6, $E6, $06, $0E, $EE, $0E, $CC, $1E, $DC, $1C, $D8, $1C, $C2, $00
	db $C0, $DF, $DF, $C0, $C0, $C0, $DB, $D8, $DB, $D8, $FB, $F8, $F3, $F8, $07, $00

; ---- gfx $73F0-$7490 (160 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:40F7: hl=$73F0 a=$24 c=$0A de=$9001 (dest VRAM $9000, vbank=1)

MailResult_Tiles_73F0:: ; 24:73F0
Data_24_73F0::
	db $1F, $BF, $B8, $3C, $33, $30, $B7, $30, $B0, $30, $BF, $3F, $9F, $3F, $C0, $00
	db $9F, $BF, $38, $3C, $B0, $30, $B7, $30, $30, $30, $BF, $BF, $9F, $BF, $00, $00
	db $0C, $6D, $6D, $0C, $0C, $0C, $EC, $0C, $2D, $0D, $AF, $8F, $A6, $87, $30, $00
	db $31, $B1, $B1, $33, $33, $33, $33, $33, $33, $33, $33, $33, $03, $03, $F8, $00
	db $81, $81, $BC, $BC, $BC, $BC, $01, $80, $60, $70, $7D, $7D, $3D, $3D, $00, $00
	db $F8, $F8, $7C, $7E, $3E, $3E, $36, $76, $70, $70, $E7, $F0, $CF, $E0, $1F, $00
	db $F9, $F9, $F9, $F9, $01, $03, $FB, $03, $F3, $07, $F7, $07, $F6, $07, $F0, $00
	db $B0, $B7, $B7, $B0, $B0, $B0, $B6, $B6, $36, $B6, $3E, $3E, $3C, $3E, $81, $00
	db $FF, $FF, $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $7490-$7790 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4109: hl=$7490 a=$24 c=$30 de=$8000 (dest VRAM $8000, vbank=0)

MailResult_Tiles_7490:: ; 24:7490
Data_24_7490::
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C
	db $00, $00, $00, $00, $38, $38, $38, $38, $18, $18, $18, $18, $18, $18, $18, $18
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $0C, $0C, $0C, $1C
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $08, $0C, $38, $38
	db $00, $00, $00, $00, $60, $60, $60, $60, $60, $60, $6C, $6C, $6C, $6C, $6C, $6C
	db $00, $00, $00, $00, $7C, $7C, $7C, $7C, $60, $60, $60, $60, $60, $60, $70, $78
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $60, $60, $78, $78
	db $00, $00, $00, $00, $7C, $7C, $7C, $7C, $6C, $6C, $6C, $6C, $6C, $6C, $0C, $0C
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $28, $6C, $38, $38
	db $00, $00, $00, $00, $10, $38, $38, $7C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C
	db $00, $00, $00, $00, $0F, $1F, $1E, $30, $37, $6F, $67, $50, $7A, $57, $7F, $57
	db $00, $00, $00, $00, $C0, $E0, $20, $70, $D0, $F9, $A9, $7D, $E9, $3D, $E9, $3D
	db $00, $00, $00, $00, $00, $00, $0E, $1F, $F5, $F1, $7B, $04, $81, $7E, $6B, $14
	db $00, $00, $00, $00, $00, $00, $1C, $1E, $EB, $E3, $F7, $08, $03, $FC, $D7, $28
	db $00, $00, $00, $00, $00, $00, $7E, $7F, $BD, $81, $DA, $24, $0D, $F2, $9E, $60
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $C0, $80, $C0, $80, $C0
	db $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $18, $00, $00
	db $18, $38, $30, $70, $60, $60, $60, $60, $60, $60, $7C, $7C, $7C, $7C, $00, $00
	db $38, $3C, $0C, $0C, $0C, $0C, $6C, $6C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $6C, $6C, $6C, $6C, $7E, $7E, $7E, $7E, $0C, $0C, $0C, $0C, $0C, $0C, $00, $00
	db $78, $7C, $6C, $6C, $0C, $0C, $6C, $6C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $7C, $7C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $00, $00
	db $38, $7C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $3C, $7C, $1C, $3C, $0C, $0C, $0C, $0C, $6C, $6C, $38, $7C, $10, $38, $00, $00
	db $5F, $50, $5F, $57, $5F, $77, $5D, $77, $2D, $7F, $10, $3F, $0F, $1F, $00, $0F
	db $E8, $3D, $E8, $3C, $E8, $3C, $E8, $3C, $D0, $FC, $20, $F8, $C0, $F0, $00, $E0
	db $EB, $D4, $63, $CC, $7B, $44, $63, $58, $5F, $41, $3E, $7F, $00, $3E, $00, $00
	db $D7, $28, $C7, $18, $F7, $08, $C7, $30, $BB, $83, $7C, $FF, $00, $7E, $00, $00
	db $5F, $A1, $5B, $A5, $1B, $65, $C5, $19, $BA, $83, $7C, $FF, $00, $7E, $00, $00
	db $00, $C0, $00, $80, $00, $80, $00, $80, $00, $80, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $04, $00, $04, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $04, $00, $00, $00, $00, $00, $0A, $00, $00, $00
	db $04, $00, $04, $00, $04, $00, $04, $00, $04, $00, $04, $00, $44, $00, $04, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $78, $78, $40, $78
	db $00, $00, $04, $07, $08, $0F, $08, $0F, $08, $0F, $08, $0F, $0C, $0F, $17, $17
	db $00, $00, $00, $80, $0F, $C0, $00, $C0, $19, $C0, $00, $C6, $42, $C6, $84, $8C
	db $04, $00, $04, $00, $44, $00, $04, $00, $FC, $01, $00, $00, $00, $00, $00, $00
	db $40, $78, $30, $30, $00, $78, $20, $E8, $40, $50, $08, $28, $18, $D8, $20, $38
	db $0B, $0B, $0F, $0F, $06, $07, $04, $07, $04, $07, $00, $00, $00, $00, $00, $00
	db $48, $58, $F0, $F0, $40, $C0, $40, $C0, $40, $C0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $18, $0B, $18, $08, $18, $1F, $1F, $03, $03
	db $00, $00, $00, $00, $2F, $00, $00, $00, $FF, $00, $00, $00, $0F, $0F, $0C, $8F
	db $00, $00, $00, $00, $74, $00, $00, $00, $FF, $00, $00, $00, $E1, $E1, $21, $E3
	db $80, $00, $80, $00, $80, $00, $A0, $30, $A0, $30, $20, $30, $F0, $F0, $80, $80
	db $8C, $CF, $2C, $2F, $16, $17, $0B, $0B, $07, $07, $06, $07, $00, $00, $00, $00
	db $22, $E6, $20, $E8, $40, $D0, $80, $A0, $C0, $C0, $40, $C0, $00, $00, $00, $00

; ---- data $7790-$7A60 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 29:411A: hl=$7790 a=$24 b=18 rows c=20 cols (tiles then attrs) de=$D000

MailResult_Tilemap:: ; 24:7790
Data_24_7790::
	db $80, $92, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $8B, $8C, $8D, $8E, $8F
	db $B0, $82, $92, $80, $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B
	db $9C, $9D, $9E, $9F, $B1, $92, $91, $90, $A0, $A1, $A2, $A3, $A4, $A5, $A6, $A7
	db $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B2, $A2, $A1, $A0, $B3, $B4, $B4, $B4
	db $B4, $B4, $B4, $B4, $B4, $B4, $B4, $B4, $CB, $CC, $CD, $B4, $B4, $B4, $B4, $B6
	db $B5, $09, $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF, $09, $09, $CE, $CF, $D0, $D1
	db $09, $09, $09, $B7, $B5, $B8, $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF, $C2, $C2
	db $D2, $D3, $D4, $D5, $C2, $C2, $BD, $B7, $B5, $B9, $C3, $C4, $C4, $C4, $C4, $C4
	db $C4, $C4, $C4, $C4, $D6, $D7, $D8, $D9, $C4, $C5, $BE, $B7, $B5, $BA, $C9, $00
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $CA, $BF, $B7
	db $B5, $BB, $C9, $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C
	db $1D, $CA, $C0, $B7, $B5, $BC, $C6, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7
	db $DA, $DB, $DB, $DC, $C7, $C8, $C1, $B7, $B5, $09, $F0, $F1, $F2, $F3, $F4, $F5
	db $F6, $F7, $09, $09, $DD, $DE, $DF, $E0, $09, $09, $09, $B7, $B5, $B8, $00, $01
	db $02, $03, $04, $05, $06, $07, $C2, $C2, $E1, $E2, $E3, $E4, $C2, $C2, $BD, $B7
	db $B5, $B9, $C3, $C4, $C4, $C4, $C4, $C4, $C4, $C4, $C4, $C4, $E5, $E6, $E7, $E5
	db $C4, $C5, $BE, $B7, $B5, $BA, $C9, $20, $21, $22, $23, $24, $25, $26, $27, $28
	db $29, $2A, $2B, $2C, $2D, $CA, $BF, $B7, $B5, $BB, $C9, $30, $31, $32, $33, $34
	db $35, $36, $37, $38, $39, $3A, $3B, $3C, $3D, $CA, $C0, $B7, $B5, $BC, $C6, $C7
	db $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C7, $C8, $C1, $B7
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81, $81
	db $81, $81, $81, $81, $81, $81, $81, $81, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $28, $28, $28, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $28, $28, $28
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $28, $28, $28, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $08, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09, $09, $0B, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09
	db $09, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $09, $09, $0B, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $0B, $0B, $09, $09, $0B, $0B, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $0B, $0B, $09, $09, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09
	db $09, $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $09, $09, $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09, $09, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $2B, $0B, $0B, $0B, $09, $09, $0B, $0B, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0B, $0B, $09
	db $09, $0B, $0B, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $0B, $0B, $09, $09, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0B, $0B, $0B, $09, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08

; ---- data $7A60-$7AA0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7A60 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed; earlier 'never executed' used the old 18-scenario union) - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailResult_BgPalette:: ; 24:7A60
Palette_24_7A60::
	db $FF, $7F, $9F, $02, $F7, $00, $00, $00, $FF, $7F, $F2, $2F, $44, $42, $00, $00
	db $FF, $7F, $44, $42, $EF, $7F, $17, $00, $FF, $7F, $44, $42, $EF, $7F, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $7AA0-$7AE0 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7AA0 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed; earlier 'never executed' used the old 18-scenario union) - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailResult_ObjPalette:: ; 24:7AA0
Palette_24_7AA0::
	db $E0, $7F, $FF, $7F, $52, $74, $2B, $44, $E0, $7F, $FF, $7F, $F7, $00, $00, $00
	db $E0, $7F, $0E, $5E, $FF, $06, $57, $01, $E0, $7F, $0E, $5E, $5F, $0D, $B1, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- data $7AE0-$7B20 (64 bytes) [PROBABLE] 64-byte RGB555 palette block copied by Function_4F_4000 (hl=$7AE0 a=$24 bc=$0040) from 29:40B0 / 29:40C1 / 29:463E; the call sites 29:40B0/29:40C1/29:463E ARE in analysis/coverage_union.tsv (executed) and traces/detail dataaccess records rom_read 24:7AE0-7B20 (this block read as data by executed code); earlier 'never executed' was stale - status kept PROBABLE; the mapper palette guess 7A60-7C38 wrongly extended over the object tables

MailServerStatus_BgPalette:: ; 24:7AE0
Palette_24_7AE0::
	db $FF, $7F, $9F, $02, $F7, $00, $00, $00, $FF, $7F, $90, $7E, $8B, $7D, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- words $7B20-$7C00 (224 bytes) [PROBABLE] sprite object table: 4-byte entries (frame-table ptr, animation-script ptr) indexed by B&7F, the layout read by init_object_from_table 00:0A82/00:0AB8; rows of 16 bytes = the same entry repeated 4 times; base $7B20 is passed as de with a=$24 at call sites listed in analysis/gfx_candidates.tsv (object-table); entries 7C00/7C33 7C00/7C33 7C00/7C33 7C00/7C33

MailResult_ObjTable:: ; 24:7B20
Table_24_7B20::
	dw Table_24_7C00, Data_24_7C33, Table_24_7C00, Data_24_7C33, Table_24_7C00, Data_24_7C33, Table_24_7C00, Data_24_7C33
	dw Table_24_7C36, Data_24_7C85, Table_24_7C36, Data_24_7C85, Table_24_7C36, Data_24_7C85, Table_24_7C36, Data_24_7C85
	dw Table_24_7C88, Data_24_7C93, Table_24_7C88, Data_24_7C93, Table_24_7C88, Data_24_7C93, Table_24_7C88, Data_24_7C93
	dw Table_24_7C96, Data_24_7CA1, Table_24_7C96, Data_24_7CA1, Table_24_7C96, Data_24_7CA1, Table_24_7C96, Data_24_7CA1
	dw Table_24_7CA4, Data_24_7CAF, Table_24_7CA4, Data_24_7CAF, Table_24_7CA4, Data_24_7CAF, Table_24_7CA4, Data_24_7CAF
	dw Table_24_7CB2, Data_24_7CBD, Table_24_7CB2, Data_24_7CBD, Table_24_7CB2, Data_24_7CBD, Table_24_7CB2, Data_24_7CBD
	dw Table_24_7CC0, Data_24_7CCB, Table_24_7CC0, Data_24_7CCB, Table_24_7CC0, Data_24_7CCB, Table_24_7CC0, Data_24_7CCB
	dw Table_24_7CCE, Data_24_7CD9, Table_24_7CCE, Data_24_7CD9, Table_24_7CCE, Data_24_7CD9, Table_24_7CCE, Data_24_7CD9
	dw Table_24_7CDC, Data_24_7CE7, Table_24_7CDC, Data_24_7CE7, Table_24_7CDC, Data_24_7CE7, Table_24_7CDC, Data_24_7CE7
	dw Table_24_7CEA, Data_24_7CF5, Table_24_7CEA, Data_24_7CF5, Table_24_7CEA, Data_24_7CF5, Table_24_7CEA, Data_24_7CF5
	dw Table_24_7CF8, Data_24_7D03, Table_24_7CF8, Data_24_7D03, Table_24_7CF8, Data_24_7D03, Table_24_7CF8, Data_24_7D03
	dw Table_24_7D06, Data_24_7D19, Table_24_7D06, Data_24_7D19, Table_24_7D06, Data_24_7D19, Table_24_7D06, Data_24_7D19
	dw Table_24_7D1C, Data_24_7D2F, Table_24_7D1C, Data_24_7D2F, Table_24_7D1C, Data_24_7D2F, Table_24_7D1C, Data_24_7D2F
	dw Table_24_7D32, Data_24_7D45, Table_24_7D32, Data_24_7D45, Table_24_7D32, Data_24_7D45, Table_24_7D32, Data_24_7D45

; ---- words $7C00-$7C02 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7C00:: ; 24:7C00
	dw Data_24_7C02

; ---- data $7C02-$7C33 (49 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 12 piece(s); length tiles exactly against the frame-table pointers

Data_24_7C02:: ; 24:7C02
	db $0C, $50, $38, $0A, $01, $50, $40, $0B, $01, $50, $48, $0C, $01, $50, $50, $0D
	db $01, $50, $58, $0E, $01, $50, $60, $0F, $01, $58, $38, $1A, $01, $58, $40, $1B
	db $01, $58, $48, $1C, $01, $58, $50, $1D, $01, $58, $58, $1E, $01, $58, $60, $1F
	db $01

; ---- data $7C33-$7C36 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7C33:: ; 24:7C33
	db $01, $00, $04

; ---- words $7C36-$7C38 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7C36:: ; 24:7C36
	dw Data_24_7C38

; ---- data $7C38-$7C85 (77 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 19 piece(s); length tiles exactly against the frame-table pointers

Data_24_7C38:: ; 24:7C38
	db $13, $F0, $28, $20, $02, $F0, $30, $21, $02, $F0, $38, $22, $03, $F0, $40, $23
	db $03, $F8, $28, $24, $02, $F8, $30, $25, $02, $F8, $38, $26, $03, $F8, $40, $27
	db $03, $00, $28, $28, $02, $00, $30, $29, $02, $27, $28, $2A, $02, $27, $30, $2B
	db $02, $27, $38, $2C, $02, $27, $40, $2D, $02, $2F, $30, $2E, $02, $2F, $38, $2F
	db $02, $1F, $2B, $20, $03, $1F, $33, $21, $03, $1F, $3B, $22, $03

; ---- data $7C85-$7C88 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7C85:: ; 24:7C85
	db $01, $00, $04

; ---- words $7C88-$7C8A (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7C88:: ; 24:7C88
	dw Data_24_7C8A

; ---- data $7C8A-$7C93 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7C8A:: ; 24:7C8A
	db $02, $38, $E8, $01, $00, $40, $E8, $11, $00

; ---- data $7C93-$7C96 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7C93:: ; 24:7C93
	db $01, $00, $04

; ---- words $7C96-$7C98 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7C96:: ; 24:7C96
	dw Data_24_7C98

; ---- data $7C98-$7CA1 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7C98:: ; 24:7C98
	db $02, $38, $E8, $02, $00, $40, $E8, $12, $00

; ---- data $7CA1-$7CA4 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CA1:: ; 24:7CA1
	db $01, $00, $04

; ---- words $7CA4-$7CA6 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CA4:: ; 24:7CA4
	dw Data_24_7CA6

; ---- data $7CA6-$7CAF (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CA6:: ; 24:7CA6
	db $02, $38, $E8, $03, $00, $40, $E8, $13, $00

; ---- data $7CAF-$7CB2 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CAF:: ; 24:7CAF
	db $01, $00, $04

; ---- words $7CB2-$7CB4 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CB2:: ; 24:7CB2
	dw Data_24_7CB4

; ---- data $7CB4-$7CBD (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CB4:: ; 24:7CB4
	db $02, $38, $E8, $04, $00, $40, $E8, $14, $00

; ---- data $7CBD-$7CC0 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CBD:: ; 24:7CBD
	db $01, $00, $04

; ---- words $7CC0-$7CC2 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CC0:: ; 24:7CC0
	dw Data_24_7CC2

; ---- data $7CC2-$7CCB (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CC2:: ; 24:7CC2
	db $02, $38, $E8, $05, $00, $40, $E8, $15, $00

; ---- data $7CCB-$7CCE (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CCB:: ; 24:7CCB
	db $01, $00, $04

; ---- words $7CCE-$7CD0 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CCE:: ; 24:7CCE
	dw Data_24_7CD0

; ---- data $7CD0-$7CD9 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CD0:: ; 24:7CD0
	db $02, $38, $E8, $06, $00, $40, $E8, $16, $00

; ---- data $7CD9-$7CDC (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CD9:: ; 24:7CD9
	db $01, $00, $04

; ---- words $7CDC-$7CDE (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CDC:: ; 24:7CDC
	dw Data_24_7CDE

; ---- data $7CDE-$7CE7 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CDE:: ; 24:7CDE
	db $02, $38, $E8, $07, $00, $40, $E8, $17, $00

; ---- data $7CE7-$7CEA (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CE7:: ; 24:7CE7
	db $01, $00, $04

; ---- words $7CEA-$7CEC (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CEA:: ; 24:7CEA
	dw Data_24_7CEC

; ---- data $7CEC-$7CF5 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CEC:: ; 24:7CEC
	db $02, $38, $E8, $08, $00, $40, $E8, $18, $00

; ---- data $7CF5-$7CF8 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7CF5:: ; 24:7CF5
	db $01, $00, $04

; ---- words $7CF8-$7CFA (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7CF8:: ; 24:7CF8
	dw Data_24_7CFA

; ---- data $7CFA-$7D03 (9 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 2 piece(s); length tiles exactly against the frame-table pointers

Data_24_7CFA:: ; 24:7CFA
	db $02, $38, $E8, $09, $00, $40, $E8, $19, $00

; ---- data $7D03-$7D06 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7D03:: ; 24:7D03
	db $01, $00, $04

; ---- words $7D06-$7D08 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7D06:: ; 24:7D06
	dw Data_24_7D08

; ---- data $7D08-$7D19 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_24_7D08:: ; 24:7D08
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $00, $00, $40, $E8, $10
	db $00

; ---- data $7D19-$7D1C (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7D19:: ; 24:7D19
	db $01, $00, $04

; ---- words $7D1C-$7D1E (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7D1C:: ; 24:7D1C
	dw Data_24_7D1E

; ---- data $7D1E-$7D2F (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_24_7D1E:: ; 24:7D1E
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $01, $00, $40, $E8, $11
	db $00

; ---- data $7D2F-$7D32 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7D2F:: ; 24:7D2F
	db $01, $00, $04

; ---- words $7D32-$7D34 (2 bytes) [PROBABLE] sprite frame table: 1 frame(s), word table indexed by the script frame number (00:0B23: hl=idx*2+base); each word points at a frame record; extent = (first record - table)/2

Table_24_7D32:: ; 24:7D32
	dw Data_24_7D34

; ---- data $7D34-$7D45 (17 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 4 piece(s); length tiles exactly against the frame-table pointers

Data_24_7D34:: ; 24:7D34
	db $04, $38, $E0, $01, $00, $40, $E0, $11, $00, $38, $E8, $02, $00, $40, $E8, $12
	db $00

; ---- data $7D45-$7D48 (3 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 1 step(s), (frame,delay) pairs: 0:4

Data_24_7D45:: ; 24:7D45
	db $01, $00, $04
