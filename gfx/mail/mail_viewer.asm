; gfx/mail/mail_viewer.asm
; bank 2B, $6DD0-$7B02 (3378 bytes); pinned by layout.link
; viewer tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/mail_viewer", ROMX

; ---- gfx $6DD0-$71D0 (1024 bytes) [CONFIRMED] 64 tiles: 'ld de,$9001 ; ld hl,$6DD0 ; ld a,$2B ; ld c,$40 ; call FarCall -> 00:0749 (HDMA rom->vram)' at 2B:6620-6631; merges the former zero-run / UNCLASSIFIED fragments (blank rows are tile content) [every byte read as data in 9 scenario(s)]

Gfx_MailView_Tiles9000:: ; 2B:6DD0
Tiles_2B_6DD0::
	db $00, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $FF, $FF, $FF, $C0, $1F, $CF, $27, $DF, $20, $C0, $20, $C0, $1F, $E0, $00
	db $00, $FF, $FF, $FF, $00, $FF, $FF, $FE, $FF, $00, $00, $00, $00, $FF, $00, $00
	db $00, $FF, $FF, $FF, $3F, $80, $3C, $43, $BB, $45, $3A, $46, $3B, $85, $38, $03
	db $00, $FF, $FF, $FF, $FF, $00, $00, $FF, $FF, $F5, $0A, $0A, $EA, $EA, $AB, $AB
	db $00, $FF, $FF, $FF, $FF, $00, $02, $F9, $F9, $56, $AF, $AF, $AF, $AF, $EF, $EF
	db $00, $FF, $FF, $FF, $FF, $00, $00, $FD, $FD, $FA, $07, $07, $F4, $F4, $F7, $F7
	db $00, $FF, $FF, $FF, $FF, $00, $10, $CE, $CE, $B5, $7B, $6B, $10, $10, $7B, $7B
	db $00, $FF, $FF, $FF, $FF, $00, $FE, $00, $1C, $C3, $CB, $A5, $66, $5A, $7F, $7F
	db $00, $FF, $FF, $FF, $FF, $00, $07, $F8, $F9, $74, $A9, $AC, $09, $0C, $D9, $DC
	db $00, $FF, $FF, $FF, $F0, $07, $E7, $0F, $C8, $1B, $D3, $37, $D4, $3F, $D4, $3F
	db $00, $FF, $FF, $FF, $0F, $E0, $C7, $10, $03, $C8, $C1, $E4, $61, $F4, $61, $F4
	db $00, $FF, $FF, $FF, $FF, $00, $FF, $00, $80, $7F, $7E, $BE, $41, $C1, $7E, $BE
	db $00, $FF, $FF, $FF, $FF, $00, $E0, $1F, $1F, $69, $76, $B6, $C2, $C2, $F7, $F7
	db $00, $FF, $FF, $FF, $FF, $00, $0F, $E0, $C7, $50, $A1, $BE, $BC, $BD, $F3, $F2
	db $00, $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7F, $80
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $C0, $3B, $91, $7F, $BD, $7F, $95, $7F, $D1, $3F, $DD, $3F, $C0, $3F, $E0, $00
	db $00, $BF, $1D, $BF, $15, $FF, $55, $FF, $45, $FF, $99, $FF, $00, $FB, $02, $00
	db $7E, $81, $7C, $83, $1B, $E5, $CA, $E6, $0B, $E5, $08, $83, $3C, $80, $3F, $00
	db $99, $99, $BA, $AA, $2B, $3B, $6A, $5B, $CE, $B5, $00, $CE, $10, $00, $FF, $00
	db $EE, $EE, $2E, $2E, $ED, $ED, $23, $E3, $3F, $5C, $80, $3F, $C0, $00, $FF, $00
	db $EE, $EE, $CD, $CD, $B5, $B5, $76, $76, $DF, $AB, $00, $DF, $20, $00, $FF, $00
	db $1A, $1A, $BB, $BB, $FB, $FB, $1C, $1C, $F7, $EB, $00, $F7, $00, $00, $FF, $00
	db $C3, $C3, $FF, $FF, $E7, $DB, $42, $66, $CB, $A5, $08, $C3, $1C, $00, $FF, $00
	db $D1, $D8, $D3, $D8, $B3, $B8, $63, $70, $C7, $E0, $0F, $C0, $1F, $00, $FF, $00
	db $D7, $2F, $D4, $2F, $C4, $2E, $C4, $2E, $C0, $16, $E0, $08, $F0, $07, $F8, $00
	db $E1, $F4, $61, $F4, $61, $F4, $61, $F4, $01, $E8, $03, $10, $07, $E0, $0F, $00
	db $1E, $7E, $DE, $3E, $BD, $5D, $A3, $62, $BE, $5D, $80, $3E, $C1, $00, $FF, $00
	db $C1, $C1, $FB, $FB, $DF, $5F, $63, $A2, $3E, $DD, $80, $3E, $C1, $00, $FF, $00
	db $ED, $E5, $DE, $CA, $F3, $FD, $61, $AA, $06, $71, $8F, $00, $FF, $00, $FF, $00
	db $BF, $40, $DF, $A0, $6F, $50, $A7, $B0, $E7, $50, $0F, $E0, $9F, $00, $FF, $00
	db $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08
	db $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38
	db $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $AC, $58
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $12, $3D
	db $FF, $00, $AA, $55, $FF, $00, $FF, $00, $F7, $0F, $FF, $08, $FC, $08, $FC, $08
	db $FF, $00, $AA, $55, $FF, $00, $FF, $00, $FF, $FF, $FF, $00, $00, $00, $00, $00
	db $FF, $00, $AA, $55, $FF, $00, $FF, $00, $EF, $F0, $9F, $70, $1F, $30, $1F, $30
	db $FC, $08, $FC, $08, $FC, $08, $FC, $08, $AC, $58, $FC, $08, $FC, $08, $FC, $08
	db $17, $38, $17, $38, $17, $38, $17, $38, $12, $3D, $17, $38, $17, $38, $17, $38
	db $AA, $55, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $81, $7E, $7E, $BD, $66, $FF, $66, $FF, $66, $FF, $66, $FF, $7E, $BD, $00, $00
	db $83, $7C, $BB, $7C, $9B, $7C, $DB, $3C, $DB, $3C, $DB, $3C, $DB, $3C, $00, $00
	db $01, $FE, $7E, $FD, $06, $FF, $7E, $BD, $71, $EE, $60, $FF, $7E, $FF, $00, $00
	db $01, $FE, $7E, $FD, $06, $FF, $BE, $7D, $86, $7F, $06, $FF, $7E, $FD, $00, $00
	db $C1, $3E, $9D, $7E, $3D, $EE, $6D, $FE, $6C, $FF, $7E, $FF, $0C, $FF, $00, $00
	db $00, $FF, $7E, $FF, $60, $FF, $7E, $FD, $06, $FF, $06, $FF, $7E, $FD, $00, $00
	db $81, $7E, $7D, $BE, $61, $FE, $7E, $FD, $66, $FF, $66, $FF, $7E, $BD, $00, $00
	db $00, $FF, $7E, $FF, $06, $FF, $CE, $3D, $DD, $3A, $DB, $3C, $DB, $3C, $00, $00
	db $81, $7E, $7E, $BD, $66, $FF, $7E, $BD, $66, $FF, $66, $FF, $7E, $BD, $00, $00
	db $81, $7E, $7E, $BD, $66, $FF, $66, $FF, $7E, $BF, $86, $7F, $BE, $7D, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $00
	db $80, $FF, $FE, $FF, $88, $FF, $7E, $FF, $48, $FF, $FE, $FF, $08, $FF, $00, $00
	db $00, $FF, $7E, $FF, $42, $FF, $7E, $FF, $42, $FF, $7E, $FF, $C2, $FF, $00, $00
	db $00, $FF, $7E, $FF, $42, $FF, $7E, $FF, $42, $FF, $42, $FF, $7E, $FF, $00, $00
	db $04, $FF, $EE, $FF, $BF, $FF, $E2, $FF, $BF, $FF, $AA, $FF, $E6, $FF, $00, $00

; ---- gfx $71D0-$73D0 (512 bytes) [PROBABLE] 32 tiles: 'ld de,$9401 ; ld hl,$71D0 ; ld a,$2B ; ld c,$20 ; HDMA' at 2B:6635-6646; ends where the tilemap+attr block at 73D0 begins

Gfx_MailView_Tiles9400:: ; 2B:71D0
Tiles_2B_71D0::
	db $29, $FE, $44, $FF, $FE, $FF, $24, $FF, $A5, $7E, $25, $FE, $6D, $DE, $00, $00
	db $00, $00, $00, $00, $01, $01, $03, $03, $07, $07, $0E, $0E, $07, $07, $03, $03
	db $70, $70, $E1, $E1, $C3, $C3, $87, $87, $0F, $0F, $1F, $1F, $37, $37, $EE, $EE
	db $FD, $FD, $FB, $FB, $F7, $F7, $EE, $EE, $DD, $DD, $BB, $BB, $7F, $7F, $FF, $FF
	db $FC, $08, $FC, $08, $AC, $58, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08
	db $17, $38, $17, $38, $12, $3D, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $F0, $0F, $F7, $0F, $F0, $08, $F0, $08, $F0, $08, $F1, $08, $F1, $09
	db $FF, $00, $00, $FF, $FF, $FF, $00, $00, $7C, $38, $C6, $82, $BB, $10, $49, $09
	db $FF, $00, $0F, $F0, $EF, $F0, $0F, $10, $0F, $10, $0F, $10, $0F, $10, $0F, $10
	db $81, $42, $81, $7E, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $3F, $3F, $3F, $21, $3F, $3D, $1F, $13, $1D, $17, $3D, $27, $39, $3F, $00, $3D
	db $D4, $FF, $3E, $FF, $C8, $FF, $7E, $FF, $48, $FF, $56, $FF, $FE, $FF, $00, $00
	db $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $DD, $DD, $FB, $FB, $77, $77, $3E, $3E, $1D, $1D, $0F, $0F, $07, $07, $03, $03
	db $DD, $DD, $BB, $BB, $77, $77, $EE, $EE, $DD, $DD, $BB, $BB, $7F, $7F, $FF, $FF
	db $AC, $58, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FC, $08, $FF, $FF, $FF, $00
	db $12, $3D, $17, $38, $17, $38, $17, $38, $17, $38, $17, $38, $FF, $FF, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $F1, $09, $F1, $09, $F1, $08, $F0, $08, $F0, $08, $F0, $08, $F0, $0F, $FF, $00
	db $49, $49, $4B, $08, $BE, $1C, $C0, $80, $7F, $3C, $00, $00, $00, $C3, $81, $42
	db $0F, $10, $0F, $10, $0F, $10, $0F, $10, $0F, $10, $0F, $10, $0F, $F0, $FF, $00
	db $FE, $FE, $FE, $4A, $FE, $7A, $FF, $1B, $FF, $7A, $CF, $79, $CE, $FF, $00, $CF
	db $FC, $FC, $FC, $84, $7C, $74, $B8, $A8, $FC, $D4, $FC, $B4, $DC, $FC, $00, $DC

; ---- data $73D0-$76A0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:6655: hl=$73D0 a=$2B b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_MailView_TilemapAttr:: ; 2B:73D0
Data_2B_73D0::
	db $3A, $3B, $3B, $3B, $3B, $3C, $3B, $3B, $3D, $3B, $3B, $3E, $3B, $3B, $3F, $3B
	db $3B, $40, $50, $3A, $49, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E
	db $0F, $49, $49, $49, $49, $41, $42, $43, $49, $18, $19, $1A, $1B, $1C, $1D, $1E
	db $1F, $20, $21, $22, $23, $49, $49, $49, $49, $51, $52, $53, $2A, $2A, $2A, $2A
	db $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A, $2A
	db $2B, $2B, $2B, $2B, $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37
	db $38, $39, $3A, $2B, $2B, $2B, $2B, $2B, $40, $41, $42, $43, $44, $45, $46, $47
	db $48, $49, $4A, $4B, $4C, $4D, $4E, $2B, $25, $26, $26, $26, $26, $26, $26, $26
	db $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $27, $28, $4B, $4C, $4D
	db $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $29
	db $22, $5B, $5C, $5D, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F
	db $60, $61, $62, $24, $20, $4F, $5E, $5F, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F
	db $70, $71, $72, $73, $74, $75, $76, $21, $44, $79, $7A, $7B, $7C, $7D, $7E, $7F
	db $80, $81, $82, $83, $84, $85, $86, $87, $88, $89, $8A, $45, $44, $8D, $8E, $8F
	db $90, $91, $92, $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $45
	db $22, $A1, $A2, $A3, $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $23
	db $23, $23, $23, $24, $20, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23
	db $23, $23, $23, $23, $23, $23, $23, $21, $44, $23, $23, $23, $23, $23, $23, $23
	db $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $45, $44, $23, $23, $23
	db $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $23, $45
	db $00, $00, $00, $00, $00, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B
	db $0C, $0D, $0E, $0F, $10, $10, $10, $10, $10, $11, $12, $13, $14, $15, $16, $17
	db $18, $19, $1A, $1B, $1C, $1D, $1E, $1F, $2C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0B, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $0B, $0B, $0B, $0B, $0B, $0B, $0B
	db $0B, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $0B, $0B, $0B
	db $0B, $0B, $0B, $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0D, $0D, $0D, $0D, $05, $05, $05, $05
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0D, $0D, $0D, $0D, $0D
	db $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $0D
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $0A, $0A, $0A, $0A, $0A
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $0A
	db $0A, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $0A, $4A, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $4A, $0A, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $4A, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09

; ---- data $76A0-$76E0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear): 'ld bc,$0040 ; ld de,$D800 ; ld hl,$76A0 ; ld a,$2B ; far call 4F:4000' at 2B:65E3-65F3; the old heuristic region ran into tile data

Palette_MailView_Bg:: ; 2B:76A0
Palette_2B_76A0::
	db $FF, $7F, $6C, $7F, $E0, $6C, $00, $00, $15, $00, $DF, $01, $00, $00, $FF, $7F
	db $BF, $02, $FF, $7F, $18, $02, $00, $00, $1F, $00, $BF, $02, $00, $00, $FF, $7F
	db $00, $00, $DF, $01, $0F, $00, $FF, $7F, $FF, $7F, $1F, $00, $18, $02, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- gfx $76E0-$7860 (384 bytes) [PROBABLE] 24 tiles: 'ld de,$8000 ; ld hl,$76E0 ; ld a,$2B ; ld c,$18 ; HDMA' at 2B:65F7-6608; includes the zero run at 7840-7860 (blank tiles)

Gfx_MailView_Tiles8000:: ; 2B:76E0
Tiles_2B_76E0::
	db $00, $00, $00, $00, $0F, $0F, $0F, $08, $0F, $08, $08, $08, $0B, $0B, $08, $08
	db $00, $00, $00, $00, $FF, $FF, $FF, $00, $FF, $00, $00, $00, $D5, $D5, $00, $00
	db $00, $00, $00, $00, $F0, $F0, $10, $10, $F0, $10, $10, $10, $D0, $D0, $10, $10
	db $0B, $0B, $08, $08, $0A, $0A, $18, $18, $14, $14, $12, $16, $11, $17, $10, $17
	db $F7, $F7, $00, $00, $AB, $AB, $00, $00, $00, $00, $00, $00, $00, $00, $81, $81
	db $D0, $D0, $10, $10, $D0, $D0, $18, $18, $28, $38, $48, $78, $88, $F8, $08, $F8
	db $10, $17, $10, $17, $10, $17, $10, $17, $1F, $1F, $00, $00, $00, $00, $00, $00
	db $42, $C3, $3C, $FF, $00, $FF, $00, $FF, $FF, $FF, $00, $00, $00, $00, $00, $00
	db $08, $F8, $08, $F8, $08, $F8, $08, $F8, $F8, $F8, $00, $00, $00, $00, $00, $00
	db $1F, $1F, $3F, $31, $3F, $2D, $3F, $31, $1F, $1B, $1E, $17, $1C, $1E, $00, $1C
	db $3E, $7F, $7E, $EB, $FF, $DB, $FF, $18, $FF, $DB, $7F, $DB, $7E, $FF, $00, $7F
	db $F8, $F8, $F8, $A8, $F8, $A8, $F8, $A8, $FC, $AC, $FC, $64, $DC, $FC, $00, $DC
	db $3F, $3F, $3F, $21, $3F, $3D, $1F, $13, $1D, $17, $3D, $27, $3D, $3F, $00, $3D
	db $FE, $FE, $FE, $4A, $FE, $7A, $FF, $1B, $FF, $7A, $CF, $79, $CF, $FF, $00, $CF
	db $FC, $FC, $FC, $84, $FC, $F4, $F8, $28, $FC, $D4, $FC, $B4, $DC, $FC, $00, $DC
	db $FF, $8B, $FF, $DD, $FF, $DF, $FF, $AF, $FF, $9D, $FD, $C3, $7E, $FF, $00, $FE
	db $00, $00, $01, $03, $03, $07, $02, $06, $06, $06, $06, $06, $06, $0E, $1E, $1E
	db $00, $00, $83, $C7, $D7, $EF, $79, $79, $79, $79, $19, $19, $19, $19, $78, $78
	db $00, $00, $C0, $E0, $F0, $F0, $90, $98, $98, $98, $98, $98, $98, $98, $98, $98
	db $10, $38, $30, $30, $32, $32, $30, $30, $10, $39, $1F, $1F, $07, $0F, $00, $00
	db $78, $78, $7F, $7F, $3F, $3F, $1C, $1C, $9C, $9C, $FF, $FF, $E3, $F7, $00, $00
	db $98, $98, $98, $98, $18, $18, $10, $38, $30, $70, $E0, $E0, $80, $C0, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $7860-$78A0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear): 'ld bc,$0040 ; ld de,$D840 ; ld hl,$7860 ; ld a,$2B ; far call 4F:4000' at 2B:660C-661C

Palette_MailView_Obj:: ; 2B:7860
Palette_2B_7860::
	db $E0, $7F, $1F, $00, $00, $00, $FF, $7F, $E0, $7F, $FF, $7F, $CE, $39, $00, $00
	db $E0, $7F, $FF, $7F, $9F, $02, $00, $00, $E0, $7F, $BF, $5C, $5F, $66, $FF, $7F
	db $E0, $7F, $1F, $00, $DF, $01, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- words $78A0-$7920 (128 bytes) [PROBABLE] animation entry table: 32 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailView_Anims:: ; 2B:78A0
Table_2B_78A0::
	dw Table_2B_7920, Data_2B_7986, Table_2B_7920, Data_2B_7986, Table_2B_7920, Data_2B_7986, Table_2B_7920, Data_2B_7986
	dw Table_2B_7989, Data_2B_79A7, Table_2B_7989, Data_2B_79A7, Table_2B_7989, Data_2B_79A7, Table_2B_7989, Data_2B_79A7
	dw Table_2B_7A4B, Data_2B_7A71, Table_2B_7A4B, Data_2B_7A71, Table_2B_7A4B, Data_2B_7A71, Table_2B_7A4B, Data_2B_7A71
	dw Table_2B_79AA, Data_2B_79D0, Table_2B_79AA, Data_2B_79D0, Table_2B_79AA, Data_2B_79D0, Table_2B_79AA, Data_2B_79D0
	dw Table_2B_79D5, Data_2B_7A0B, Table_2B_79D5, Data_2B_7A0B, Table_2B_79D5, Data_2B_7A0B, Table_2B_79D5, Data_2B_7A0B
	dw Table_2B_7A10, Data_2B_7A46, Table_2B_7A10, Data_2B_7A46, Table_2B_7A10, Data_2B_7A46, Table_2B_7A10, Data_2B_7A46
	dw Table_2B_7A76, Data_2B_7A94, Table_2B_7A76, Data_2B_7A94, Table_2B_7A76, Data_2B_7A94, Table_2B_7A76, Data_2B_7A94
	dw Table_2B_7A97, Data_2B_7AFD, Table_2B_7A97, Data_2B_7AFD, Table_2B_7A97, Data_2B_7AFD, Table_2B_7A97, Data_2B_7AFD

; ---- words $7920-$7924 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7924, $7955 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7920:: ; 2B:7920
	dw Data_2B_7924, Data_2B_7955

; ---- data $7924-$7955 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7924:: ; 2B:7924
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $10, $00, $06
	db $04, $10, $08, $07, $04, $10, $10, $08, $04, $08, $00, $03, $04, $08, $08, $04
	db $04, $08, $10, $05, $04, $00, $00, $00, $04, $00, $08, $01, $04, $00, $10, $02
	db $04

; ---- data $7955-$7986 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7955:: ; 2B:7955
	db $0C, $10, $00, $06, $02, $10, $08, $07, $02, $10, $10, $08, $02, $00, $00, $29
	db $04, $00, $08, $2A, $04, $00, $10, $2B, $04, $08, $00, $00, $04, $08, $08, $01
	db $04, $08, $10, $02, $04, $10, $00, $26, $04, $10, $08, $27, $04, $10, $10, $28
	db $04

; ---- data $7986-$7989 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7986:: ; 2B:7986
	db $01, $00, $2E

; ---- words $7989-$798D (4 bytes) [PROBABLE] frame table: 2 pointer(s) $798D, $799A to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7989:: ; 2B:7989
	dw Data_2B_798D, Data_2B_799A

; ---- data $798D-$799A (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_798D:: ; 2B:798D
	db $03, $10, $00, $0C, $02, $10, $08, $0D, $02, $10, $10, $0E, $02

; ---- data $799A-$79A7 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_799A:: ; 2B:799A
	db $03, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02

; ---- data $79A7-$79AA (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_79A7:: ; 2B:79A7
	db $01, $00, $2E

; ---- words $79AA-$79AE (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79AE, $79BF to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_79AA:: ; 2B:79AA
	dw Data_2B_79AE, Data_2B_79BF

; ---- data $79AE-$79BF (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_79AE:: ; 2B:79AE
	db $04, $F5, $08, $0C, $01, $F5, $10, $0D, $01, $FD, $08, $0E, $01, $FD, $10, $0F
	db $01

; ---- data $79BF-$79D0 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_79BF:: ; 2B:79BF
	db $04, $F4, $08, $0C, $01, $F4, $10, $0D, $01, $FC, $08, $0E, $01, $FC, $10, $0F
	db $01

; ---- data $79D0-$79D5 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_79D0:: ; 2B:79D0
	db $02, $00, $2E, $01, $08

; ---- words $79D5-$79D9 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $79D9, $79F2 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_79D5:: ; 2B:79D5
	dw Data_2B_79D9, Data_2B_79F2

; ---- data $79D9-$79F2 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_79D9:: ; 2B:79D9
	db $06, $F5, $04, $00, $01, $F5, $0C, $01, $01, $F5, $14, $02, $01, $FD, $04, $10
	db $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $79F2-$7A0B (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_79F2:: ; 2B:79F2
	db $06, $F4, $04, $00, $01, $F4, $0C, $01, $01, $F4, $14, $02, $01, $FC, $04, $10
	db $01, $FC, $0C, $11, $01, $FC, $14, $12, $01

; ---- data $7A0B-$7A10 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7A0B:: ; 2B:7A0B
	db $02, $00, $2E, $01, $08

; ---- words $7A10-$7A14 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A14, $7A2D to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7A10:: ; 2B:7A10
	dw Data_2B_7A14, Data_2B_7A2D

; ---- data $7A14-$7A2D (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A14:: ; 2B:7A14
	db $06, $F5, $05, $03, $01, $F5, $0D, $04, $01, $F5, $15, $05, $01, $FD, $05, $13
	db $01, $FD, $0D, $14, $01, $FD, $15, $15, $01

; ---- data $7A2D-$7A46 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A2D:: ; 2B:7A2D
	db $06, $F4, $05, $03, $01, $F4, $0D, $04, $01, $F4, $15, $05, $01, $FC, $05, $13
	db $01, $FC, $0D, $14, $01, $FC, $15, $15, $01

; ---- data $7A46-$7A4B (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7A46:: ; 2B:7A46
	db $02, $00, $2E, $01, $08

; ---- words $7A4B-$7A4F (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A4F, $7A60 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7A4B:: ; 2B:7A4B
	dw Data_2B_7A4F, Data_2B_7A60

; ---- data $7A4F-$7A60 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A4F:: ; 2B:7A4F
	db $04, $05, $05, $16, $02, $05, $13, $16, $22, $13, $05, $16, $42, $13, $13, $16
	db $62

; ---- data $7A60-$7A71 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A60:: ; 2B:7A60
	db $04, $04, $04, $16, $02, $04, $14, $16, $22, $14, $04, $16, $42, $14, $14, $16
	db $62

; ---- data $7A71-$7A76 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7A71:: ; 2B:7A71
	db $02, $00, $2E, $01, $08

; ---- words $7A76-$7A7A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A7A, $7A93 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7A76:: ; 2B:7A76
	dw Data_2B_7A7A, Data_2B_7A93

; ---- data $7A7A-$7A93 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A7A:: ; 2B:7A7A
	db $06, $00, $00, $10, $03, $00, $08, $11, $03, $00, $10, $12, $03, $08, $00, $13
	db $03, $08, $08, $14, $03, $08, $10, $15, $03

; ---- data $7A93-$7A94 (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A93:: ; 2B:7A93
	db $00

; ---- data $7A94-$7A97 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7A94:: ; 2B:7A94
	db $01, $00, $2E

; ---- words $7A97-$7A9B (4 bytes) [PROBABLE] frame table: 2 pointer(s) $7A9B, $7ACC to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_7A97:: ; 2B:7A97
	dw Data_2B_7A9B, Data_2B_7ACC

; ---- data $7A9B-$7ACC (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7A9B:: ; 2B:7A9B
	db $0C, $F5, $0D, $2D, $01, $F5, $15, $2E, $01, $FD, $0D, $30, $01, $FD, $15, $31
	db $01, $F5, $05, $2C, $01, $FD, $05, $2F, $01, $F5, $05, $1D, $01, $F5, $0D, $1E
	db $01, $F5, $15, $1F, $01, $FD, $05, $20, $01, $FD, $0D, $21, $01, $FD, $15, $22
	db $01

; ---- data $7ACC-$7AFD (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_7ACC:: ; 2B:7ACC
	db $0C, $F4, $0D, $2D, $01, $F4, $15, $2E, $01, $FC, $0D, $30, $01, $FC, $15, $31
	db $01, $F4, $05, $2C, $01, $FC, $05, $2F, $01, $F4, $05, $1D, $01, $F4, $0D, $1E
	db $01, $F4, $15, $1F, $01, $FC, $05, $20, $01, $FC, $0D, $21, $01, $FC, $15, $22
	db $01

; ---- data $7AFD-$7B02 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_7AFD:: ; 2B:7AFD
	db $02, $00, $2E, $01, $08
