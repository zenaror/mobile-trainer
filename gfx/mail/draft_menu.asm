; gfx/mail/draft_menu.asm
; bank 2B, $4880-$53C3 (2883 bytes); pinned by layout.link
; draft menu tiles, tilemap, palettes, animation tables

SECTION "gfx/mail/draft_menu", ROMX

; ---- gfx $4880-$4B50 (720 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:4265: hl=$4880 a=$2B c=$2D de=$9301 (dest VRAM $9300, vbank=1)

Gfx_MailDraftMenu_Tiles9300:: ; 2B:4880
Data_2B_4880::
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $54, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $01, $FE, $00, $FE, $01, $F1, $0A
	db $FF, $00, $FE, $01, $F8, $04, $F0, $08, $E0, $10, $60, $80, $40, $20, $40, $80
	db $07, $F8, $03, $04, $01, $02, $01, $02, $03, $04, $3F, $C0, $07, $08, $0F, $10
	db $80, $7F, $7F, $BF, $78, $C7, $77, $CF, $6F, $D8, $5F, $F2, $5F, $F4, $5F, $F4
	db $01, $FE, $FE, $FD, $7E, $81, $BE, $C1, $DE, $61, $EE, $31, $EE, $31, $EE, $31
	db $80, $7F, $7F, $BF, $7B, $C4, $7F, $C0, $7B, $C4, $5F, $E0, $7C, $C3, $7B, $C7
	db $01, $FE, $FE, $FD, $F8, $07, $F4, $0B, $8A, $75, $7A, $F5, $36, $C9, $F6, $C9
	db $80, $7F, $7F, $BF, $7F, $C0, $7F, $C0, $77, $C8, $7B, $C4, $7F, $C0, $7F, $C0
	db $01, $FE, $FE, $FD, $FE, $01, $7E, $81, $76, $89, $EE, $11, $FE, $01, $FE, $01
	db $00, $55, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $55, $00, $00, $00, $00, $07, $0F, $08, $08, $0B, $08, $0B, $08
	db $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $58, $0B, $08, $0B, $08, $0B, $08
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $F8, $05, $FF, $00, $E1, $12, $FF, $00, $FE, $01, $FE, $00, $FE, $00, $FF, $00
	db $80, $43, $80, $00, $00, $80, $0F, $10, $1F, $60, $7F, $00, $7F, $80, $FF, $00
	db $7F, $80, $3F, $40, $7F, $80, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $5F, $F0, $6F, $D8, $77, $CF, $78, $C7, $7F, $C0, $7F, $C0, $7F, $80, $80, $7F
	db $EE, $31, $DE, $61, $AE, $F1, $46, $B9, $E2, $1D, $F0, $0F, $F8, $07, $01, $FE
	db $60, $DF, $5F, $FF, $5F, $F0, $40, $FF, $7F, $FF, $75, $FF, $7F, $BF, $80, $7F
	db $E2, $1D, $D4, $3F, $36, $FF, $F0, $FF, $FE, $FF, $3E, $FF, $FE, $FD, $01, $FE
	db $67, $D8, $7F, $C0, $7F, $C0, $7B, $C4, $77, $C8, $7F, $C0, $7F, $80, $80, $7F
	db $F2, $0D, $FE, $01, $FE, $01, $EE, $11, $76, $89, $7E, $81, $FE, $01, $01, $FE
	db $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $58
	db $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08
	db $0B, $08, $0B, $08, $0B, $58, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08
	db $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $58, $0B, $08, $0B, $08
	db $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $58, $0B, $08, $FF, $FF, $00, $00
	db $00, $00, $00, $55, $00, $00, $00, $00, $E0, $F0, $10, $70, $D0, $30, $D0, $30
	db $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $3D
	db $D0, $38, $D0, $38, $D0, $3D, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38
	db $D0, $3D, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38
	db $0B, $58, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08, $0B, $08
	db $00, $00, $00, $55, $00, $00, $00, $00, $FF, $FF, $00, $00, $FF, $00, $FF, $00
	db $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $3D, $D0, $38, $D0, $38, $D0, $38
	db $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38
	db $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $3D, $D0, $38, $D0, $38
	db $D0, $38, $D0, $38, $D0, $38, $D0, $38, $D0, $3D, $D0, $38, $FF, $FF, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $4B50-$4E20 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2B:4276: hl=$4B50 a=$2B b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_MailDraftMenu_TilemapAttr:: ; 2B:4B50
Data_2B_4B50::
	db $42, $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $42, $42, $42
	db $42, $34, $35, $36, $42, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
	db $20, $42, $42, $42, $42, $44, $45, $46, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D
	db $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $3D, $41, $41, $41, $41
	db $2C, $2D, $2E, $2F, $30, $31, $32, $33, $34, $35, $36, $37, $38, $39, $3A, $41
	db $41, $41, $41, $41, $40, $41, $42, $43, $44, $45, $46, $47, $48, $49, $4A, $4B
	db $4C, $4D, $4E, $41, $3E, $57, $57, $57, $57, $57, $57, $57, $57, $57, $57, $57
	db $57, $57, $57, $57, $57, $57, $57, $52, $3F, $40, $40, $40, $40, $40, $40, $40
	db $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $58, $4D, $40, $40, $40
	db $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $61, $62, $53
	db $4E, $40, $40, $40, $68, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72, $73
	db $74, $75, $76, $59, $4F, $79, $7A, $7B, $7C, $7D, $7E, $7F, $80, $81, $82, $83
	db $84, $85, $86, $87, $88, $89, $8A, $54, $50, $8D, $8E, $8F, $90, $91, $92, $93
	db $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D, $9E, $5A, $4E, $A1, $A2, $A3
	db $A4, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $40, $40, $40, $59
	db $4F, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40, $40
	db $40, $40, $40, $58, $51, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30, $30
	db $30, $30, $30, $30, $30, $30, $30, $5B, $42, $42, $42, $37, $38, $42, $42, $42
	db $42, $39, $3A, $42, $42, $42, $42, $3B, $3C, $42, $42, $42, $42, $42, $42, $47
	db $48, $42, $42, $42, $42, $49, $4A, $42, $42, $42, $42, $4B, $4C, $42, $42, $42
	db $B4, $B5, $B6, $B7, $B8, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2, $C3
	db $C4, $C5, $C6, $C7, $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF, $D0, $D1, $D2, $D3
	db $D4, $D5, $D6, $D7, $D8, $D9, $DA, $DB, $0A, $02, $02, $02, $02, $02, $02, $02
	db $02, $02, $02, $02, $02, $0A, $0A, $0A, $0A, $0B, $0B, $0B, $0A, $02, $02, $02
	db $02, $02, $02, $02, $02, $02, $02, $02, $02, $0A, $0A, $0A, $0A, $0B, $0B, $0B
	db $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
	db $0D, $0D, $0D, $0D, $0C, $0C, $0C, $0C, $03, $03, $03, $03, $03, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $0C, $0C, $0C, $0C, $0C, $03, $03, $03, $03
	db $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $0C, $0D, $0D, $0D, $0D
	db $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
	db $0D, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0D, $0D, $0C, $0C, $0C, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $0D, $0D, $0C, $0C, $0C, $04, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $0D, $0D, $04, $04, $04
	db $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $0D
	db $0D, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $0D, $0D, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04, $04
	db $04, $04, $04, $04, $0C, $0C, $0C, $0D, $0D, $0C, $0C, $0C, $0C, $0C, $0C, $0C
	db $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0C, $0D, $0D, $0D, $0D, $0D
	db $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

; ---- data $4E20-$4E60 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailDraftMenu_Bg:: ; 2B:4E20
Data_2B_4E20::
	db $FF, $7F, $6C, $7F, $E0, $6C, $00, $00, $00, $00, $9F, $02, $F7, $00, $FF, $7F
	db $3E, $01, $E7, $1B, $00, $00, $FF, $7F, $FF, $7F, $3E, $01, $1F, $1E, $00, $00
	db $9F, $12, $FF, $7F, $1F, $00, $00, $00, $FF, $7F, $9F, $12, $18, $02, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- gfx $4E60-$5190 (816 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2B:4242: hl=$4E60 a=$2B c=$33 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MailDraftMenu_Tiles8000:: ; 2B:4E60
Data_2B_4E60::
	db $7E, $7E, $7E, $42, $FF, $F7, $FE, $81, $FF, $F7, $77, $6F, $6B, $5A, $73, $73
	db $00, $00, $00, $00, $FF, $FF, $FF, $0A, $FF, $BA, $FF, $BF, $FF, $08, $FF, $FF
	db $3F, $3F, $3F, $21, $BF, $AD, $FF, $ED, $FF, $BD, $FD, $BB, $FA, $76, $DC, $DC
	db $77, $77, $7F, $5D, $7F, $50, $7F, $5D, $77, $55, $7F, $5D, $7D, $5B, $7E, $7E
	db $00, $00, $80, $80, $80, $80, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00
	db $0E, $0E, $FF, $FB, $FF, $81, $FF, $EB, $3E, $22, $3E, $3A, $3A, $26, $3C, $3C
	db $00, $0B, $00, $08, $00, $1F, $03, $18, $03, $14, $05, $12, $06, $11, $07, $10
	db $00, $F7, $00, $00, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $7E, $81
	db $00, $D0, $00, $10, $00, $F8, $E0, $18, $D0, $28, $B0, $48, $70, $88, $F0, $08
	db $00, $1F, $0E, $3F, $12, $3F, $0E, $3F, $04, $1F, $09, $1E, $02, $1C, $1C, $00
	db $C1, $3E, $95, $7E, $24, $FF, $E7, $FF, $24, $FF, $A4, $7F, $81, $7E, $7F, $00
	db $00, $F8, $50, $F8, $50, $F8, $50, $F8, $50, $FC, $98, $FC, $20, $DC, $DC, $00
	db $00, $3F, $1E, $3F, $02, $3F, $0C, $1F, $0A, $1D, $1A, $3D, $06, $39, $3D, $00
	db $00, $FE, $B4, $FE, $84, $FE, $E4, $FF, $85, $FF, $B6, $CF, $31, $CE, $CF, $00
	db $00, $FC, $78, $FC, $08, $FC, $50, $B8, $28, $FC, $48, $FC, $20, $DC, $DC, $00
	db $F8, $F8, $F8, $88, $F0, $B0, $E0, $A0, $C0, $C0, $00, $00, $00, $00, $00, $00
	db $3F, $3F, $FF, $ED, $F7, $8A, $FF, $DB, $6F, $53, $7F, $69, $2F, $33, $1E, $1E
	db $3E, $3E, $FF, $EB, $FF, $C5, $FF, $EF, $BD, $C3, $FF, $AD, $AD, $DB, $FE, $FE
	db $1C, $1C, $FE, $F6, $FE, $02, $FE, $D6, $7C, $44, $7C, $74, $74, $4C, $78, $78
	db $00, $00, $00, $00, $00, $0F, $07, $08, $07, $08, $00, $08, $00, $0B, $00, $08
	db $00, $00, $00, $00, $00, $FF, $FF, $00, $FF, $00, $00, $00, $00, $D5, $00, $00
	db $00, $00, $00, $00, $00, $F0, $00, $10, $E0, $10, $00, $10, $00, $D0, $00, $10
	db $07, $10, $07, $10, $07, $10, $07, $10, $00, $1F, $00, $00, $00, $00, $00, $00
	db $81, $7E, $FF, $00, $FF, $00, $FF, $00, $00, $FF, $00, $00, $00, $00, $00, $00
	db $F0, $08, $F0, $08, $F0, $08, $F0, $08, $00, $F8, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $03, $01, $1F, $07, $3F, $1F, $30, $30, $30, $30, $3F, $3F, $3F, $1F
	db $00, $00, $F7, $E3, $3F, $3F, $3C, $3C, $0C, $0C, $0C, $0C, $9C, $9C, $CC, $8C
	db $00, $00, $C1, $80, $C3, $C1, $E3, $C3, $F7, $E3, $FE, $FE, $7E, $3E, $32, $12
	db $00, $00, $F0, $E0, $F8, $F0, $B8, $18, $1C, $18, $1C, $0C, $4E, $4C, $6E, $46
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $49, $49, $49, $49, $49, $49, $41, $41, $63, $63, $FE, $FE, $1C, $1C, $00, $00
	db $F3, $F3, $F1, $F1, $F9, $F9, $98, $98, $0C, $0C, $0F, $0F, $07, $07, $00, $00
	db $00, $00, $80, $80, $80, $80, $C0, $C0, $C0, $C0, $C0, $C0, $80, $80, $00, $00
	db $00, $00, $0F, $0F, $08, $08, $08, $0F, $08, $0F, $08, $0E, $09, $0E, $09, $0E
	db $00, $00, $FF, $FF, $00, $00, $00, $FF, $7C, $01, $82, $7C, $31, $86, $49, $B6
	db $00, $00, $F0, $F0, $10, $10, $10, $F0, $10, $F0, $10, $F0, $10, $F0, $10, $F0
	db $09, $0E, $09, $0E, $09, $0E, $08, $0E, $08, $0F, $08, $0F, $0F, $0F, $00, $00
	db $49, $B6, $4A, $B0, $3C, $81, $80, $7F, $7E, $00, $00, $FF, $C3, $FF, $42, $7E
	db $10, $F0, $10, $F0, $10, $F0, $10, $F0, $10, $F0, $10, $F0, $F0, $F0, $00, $00
	db $42, $7E, $42, $7E, $7E, $7E, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $19, $19, $19, $19, $1C, $18, $1C, $0C, $0F, $0E, $0F, $07, $07, $01, $00, $00
	db $CC, $CC, $FC, $FC, $FC, $FC, $1C, $1C, $1C, $1C, $FF, $FF, $F7, $E3, $00, $00
	db $93, $93, $93, $93, $93, $93, $C7, $83, $EF, $C6, $FE, $FE, $FC, $38, $00, $00
	db $E7, $E6, $F7, $E3, $73, $33, $3B, $31, $39, $19, $1F, $1F, $0F, $0F, $00, $00
	db $00, $00, $00, $00, $80, $00, $80, $80, $80, $80, $80, $80, $80, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $5190-$51D0 (64 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 4880-51D0 by higher-priority evidence]

Palette_MailDraftMenu_Obj:: ; 2B:5190
Data_2B_5190::
	db $E0, $7F, $FF, $7F, $1F, $00, $00, $00, $E0, $7F, $FF, $7F, $CE, $39, $00, $00
	db $E0, $7F, $18, $02, $00, $00, $FF, $7F, $E0, $7F, $DF, $01, $00, $00, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- words $51D0-$5240 (112 bytes) [PROBABLE] animation entry table: 28 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_MailDraftMenu_Anims:: ; 2B:51D0
Table_2B_51D0::
	dw Table_2B_5301, Data_2B_5367, Table_2B_5301, Data_2B_5367, Table_2B_5301, Data_2B_5367, Table_2B_5301, Data_2B_5367
	dw Table_2B_536A, Data_2B_53C0, Table_2B_536A, Data_2B_53C0, Table_2B_536A, Data_2B_53C0, Table_2B_536A, Data_2B_53C0
	dw Table_2B_526D, Data_2B_5293, Table_2B_526D, Data_2B_5293, Table_2B_526D, Data_2B_5293, Table_2B_526D, Data_2B_5293
	dw Table_2B_5298, Data_2B_52B6, Table_2B_5298, Data_2B_52B6, Table_2B_5298, Data_2B_52B6, Table_2B_5298, Data_2B_52B6
	dw Table_2B_52BB, Data_2B_52D9, Table_2B_52BB, Data_2B_52D9, Table_2B_52BB, Data_2B_52D9, Table_2B_52BB, Data_2B_52D9
	dw Table_2B_52DE, Data_2B_52FC, Table_2B_52DE, Data_2B_52FC, Table_2B_52DE, Data_2B_52FC, Table_2B_52DE, Data_2B_52FC
	dw Table_2B_5240, Data_2B_526A, Table_2B_5240, Data_2B_526A, Table_2B_5240, Data_2B_526A, Table_2B_5240, Data_2B_526A

; ---- words $5240-$5244 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5244, $5269 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_5240:: ; 2B:5240
	dw Data_2B_5244, Data_2B_5269

; ---- data $5244-$5269 (37 bytes) [PROBABLE] OAM frame: count=9 then 9 x (y,x,tile,attr) = 37 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5244:: ; 2B:5244
	db $09, $00, $00, $1A, $03, $00, $08, $1B, $03, $00, $10, $1C, $03, $00, $18, $1D
	db $03, $08, $00, $2A, $03, $08, $08, $2B, $03, $08, $10, $2C, $03, $08, $18, $2D
	db $03, $08, $20, $2E, $03

; ---- data $5269-$526A (1 bytes) [PROBABLE] OAM frame: count=0 then 0 x (y,x,tile,attr) = 1 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5269:: ; 2B:5269
	db $00

; ---- data $526A-$526D (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_526A:: ; 2B:526A
	db $01, $00, $2E

; ---- words $526D-$5271 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5271, $5282 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_526D:: ; 2B:526D
	dw Data_2B_5271, Data_2B_5282

; ---- data $5271-$5282 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5271:: ; 2B:5271
	db $04, $06, $06, $0F, $01, $06, $12, $0F, $21, $12, $06, $0F, $41, $12, $12, $0F
	db $61

; ---- data $5282-$5293 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5282:: ; 2B:5282
	db $04, $05, $05, $0F, $01, $05, $13, $0F, $21, $13, $05, $0F, $41, $13, $13, $0F
	db $61

; ---- data $5293-$5298 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_5293:: ; 2B:5293
	db $02, $00, $2E, $01, $08

; ---- words $5298-$529C (4 bytes) [PROBABLE] frame table: 2 pointer(s) $529C, $52A9 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_5298:: ; 2B:5298
	dw Data_2B_529C, Data_2B_52A9

; ---- data $529C-$52A9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_529C:: ; 2B:529C
	db $03, $FD, $04, $00, $01, $FD, $0C, $01, $01, $FD, $14, $02, $01

; ---- data $52A9-$52B6 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_52A9:: ; 2B:52A9
	db $03, $FD, $04, $00, $01, $FD, $0C, $01, $01, $FD, $14, $02, $01

; ---- data $52B6-$52BB (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_52B6:: ; 2B:52B6
	db $02, $00, $2E, $01, $08

; ---- words $52BB-$52BF (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52BF, $52CC to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_52BB:: ; 2B:52BB
	dw Data_2B_52BF, Data_2B_52CC

; ---- data $52BF-$52CC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_52BF:: ; 2B:52BF
	db $03, $FD, $04, $10, $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $52CC-$52D9 (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_52CC:: ; 2B:52CC
	db $03, $FD, $04, $10, $01, $FD, $0C, $11, $01, $FD, $14, $12, $01

; ---- data $52D9-$52DE (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_52D9:: ; 2B:52D9
	db $02, $00, $2E, $01, $08

; ---- words $52DE-$52E2 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52E2, $52EF to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_52DE:: ; 2B:52DE
	dw Data_2B_52E2, Data_2B_52EF

; ---- data $52E2-$52EF (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_52E2:: ; 2B:52E2
	db $03, $FD, $04, $03, $01, $FD, $0C, $04, $01, $FD, $14, $05, $01

; ---- data $52EF-$52FC (13 bytes) [PROBABLE] OAM frame: count=3 then 3 x (y,x,tile,attr) = 13 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_52EF:: ; 2B:52EF
	db $03, $FD, $04, $03, $01, $FD, $0C, $04, $01, $FD, $14, $05, $01

; ---- data $52FC-$5301 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 2e 01 08), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_52FC:: ; 2B:52FC
	db $02, $00, $2E, $01, $08

; ---- words $5301-$5305 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5305, $5336 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_5301:: ; 2B:5301
	dw Data_2B_5305, Data_2B_5336

; ---- data $5305-$5336 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5305:: ; 2B:5305
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $08, $00, $06
	db $03, $08, $08, $07, $03, $08, $10, $08, $03, $10, $00, $16, $03, $10, $08, $17
	db $03, $10, $10, $18, $03, $00, $00, $13, $03, $00, $08, $14, $03, $00, $10, $15
	db $03

; ---- data $5336-$5367 (49 bytes) [PROBABLE] OAM frame: count=12 then 12 x (y,x,tile,attr) = 49 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5336:: ; 2B:5336
	db $0C, $10, $00, $09, $02, $10, $08, $0A, $02, $10, $10, $0B, $02, $00, $00, $13
	db $04, $00, $08, $14, $04, $00, $10, $15, $04, $08, $00, $26, $04, $08, $08, $27
	db $04, $08, $10, $28, $04, $10, $00, $29, $04, $10, $08, $2A, $04, $10, $10, $2B
	db $04

; ---- data $5367-$536A (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_5367:: ; 2B:5367
	db $01, $00, $2E

; ---- words $536A-$536E (4 bytes) [PROBABLE] frame table: 2 pointer(s) $536E, $5397 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2B_536A:: ; 2B:536A
	dw Data_2B_536E, Data_2B_5397

; ---- data $536E-$5397 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_536E:: ; 2B:536E
	db $0A, $00, $00, $23, $00, $00, $08, $24, $00, $00, $10, $25, $00, $08, $00, $26
	db $00, $08, $08, $27, $00, $08, $10, $28, $00, $10, $00, $0C, $02, $10, $08, $0D
	db $02, $10, $10, $0E, $02, $10, $08, $29, $00

; ---- data $5397-$53C0 (41 bytes) [PROBABLE] OAM frame: count=10 then 10 x (y,x,tile,attr) = 41 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2B_5397:: ; 2B:5397
	db $0A, $10, $00, $0C, $02, $10, $08, $0D, $02, $10, $10, $0E, $02, $00, $00, $2C
	db $00, $00, $08, $2D, $00, $00, $10, $2E, $00, $08, $00, $30, $00, $08, $08, $31
	db $00, $08, $10, $32, $00, $10, $08, $2F, $00

; ---- data $53C0-$53C3 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 2e), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2B_53C0:: ; 2B:53C0
	db $01, $00, $2E
