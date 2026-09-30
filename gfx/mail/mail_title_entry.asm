; gfx/mail/mail_title_entry.asm
; bank 2C, $4A30-$56F2 (3266 bytes); pinned by layout.link
; title entry tiles, tilemap, palettes

SECTION "gfx/mail/mail_title_entry", ROMX

; ---- data $4A30-$4E30 (1024 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 4A30-56B0 by higher-priority evidence]

Gfx_MailTitle_Tiles9300:: ; 2C:4A30
Data_2C_4A30::
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles9300.2bpp"

; ---- data $4E30-$5100 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:41CE: hl=$4E30 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_MailTitle_TilemapAttr:: ; 2C:4E30
Data_2C_4E30::
	INCBIN "gfx/mail/mail_title_entry/data_mail_title_tilemap_attr.tilemap"
	INCBIN "gfx/mail/mail_title_entry/data_mail_title_tilemap_attr.attrmap"

; ---- data $5100-$5150 (80 bytes) [PROBABLE] palette-rgb555: heuristic: 40 RGB555 words as 10 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailTitle_Bg:: ; 2C:5100
Data_2C_5100::
	INCLUDE "gfx/mail/mail_title_entry/mail_title_bg.pal"

Gfx_MailTitle_Tiles8000:: ; 2C:5140
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles8000.2bpp"

; ---- data $5150-$566C (1308 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 4A30-56B0 by higher-priority evidence]

Data_2C_5150:: ; 2C:5150
	db $00, $00, $00, $00, $00, $00, $FF, $FF, $02, $02, $05, $54, $07, $AC, $0F, $08
	db $00, $00, $3E, $3E, $C1, $C1, $3F, $01, $7F, $3E, $FC, $08, $FC, $F8, $EC, $68
	db $00, $00, $00, $00, $00, $00, $01, $00, $06, $00, $08, $00, $0F, $00, $04, $00
	db $06, $02, $1A, $02, $62, $02, $82, $02, $02, $02, $02, $02, $02, $02, $FE, $02
	db $0F, $0B, $1C, $14, $F8, $F8, $00, $00, $00, $FF, $00, $00, $00, $FF, $00, $00
	db $8C, $88, $0C, $08, $0C, $08, $0C, $08, $0C, $E8, $0C, $08, $0C, $E8, $0C, $08
	db $06, $00, $02, $00, $03, $00, $01, $00, $01, $00, $00, $00, $00, $00, $00, $00
	db $00, $FC, $78, $8F, $1E, $EB, $1E, $6B, $3E, $81, $7E, $AB, $2E, $8B, $00, $FF
	db $00, $FE, $7C, $86, $30, $DE, $7C, $87, $C6, $7B, $76, $9B, $7C, $87, $00, $FE
	db $00, $7F, $33, $DD, $7D, $86, $36, $D3, $36, $5B, $36, $5B, $36, $53, $00, $7F
	db $00, $9F, $0E, $F3, $98, $EF, $F0, $5C, $30, $DC, $18, $6F, $0E, $33, $00, $1F
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $07, $04, $0C, $0B
	db $00, $00, $00, $00, $00, $00, $00, $00, $F8, $F8, $C4, $3C, $04, $FC, $F8, $F8
	db $18, $17, $1B, $17, $31, $2F, $2E, $3E, $50, $70, $60, $60, $C0, $C0, $80, $80
	db $20, $E0, $C0, $C0, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02, $06, $05, $0C, $0B
	db $00, $00, $00, $00, $00, $00, $78, $78, $C4, $BC, $84, $7C, $38, $F8, $E0, $E0
	db $18, $17, $1B, $17, $32, $2E, $2C, $3E, $50, $70, $60, $60, $C0, $C0, $80, $80
	db $40, $C0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $01, $01, $03, $02, $06, $05, $0C, $0B
	db $00, $00, $00, $00, $00, $00, $78, $FC, $C4, $BC, $88, $7C, $30, $F8, $E0, $E0
	db $18, $17, $1B, $17, $32, $2E, $2C, $3C, $50, $70, $60, $60, $C0, $C0, $80, $80
	db $40, $C0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $3C, $3C, $E2, $DE
	db $01, $01, $03, $02, $06, $05, $0C, $0B, $10, $1F, $2F, $3F, $70, $70, $C0, $C0
	db $C1, $3F, $39, $FF, $06, $FE, $F8, $F8, $40, $C0, $80, $80, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $02, $02, $06, $06, $0C, $0C, $14, $1C
	db $00, $00, $01, $01, $07, $07, $0E, $09, $3E, $3F, $7C, $43, $61, $5F, $3E, $3E
	db $E8, $F8, $C8, $38, $90, $F0, $10, $F0, $20, $E0, $40, $C0, $80, $80, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0C, $0C, $1C, $1C, $38, $38, $50, $70
	db $01, $01, $06, $07, $09, $0E, $12, $1D, $14, $1B, $29, $37, $26, $3E, $38, $38
	db $A0, $E0, $40, $C0, $40, $C0, $80, $80, $80, $80, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $03, $03, $06, $05, $0C, $0B
	db $00, $00, $00, $00, $00, $00, $1C, $1C, $F8, $F8, $A0, $60, $60, $E0, $40, $C0
	db $19, $17, $19, $17, $35, $2F, $35, $2F, $36, $2E, $24, $3C, $24, $3C, $18, $18
	db $40, $C0, $80, $80, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $02, $02, $20, $20, $00, $00, $00, $00, $88, $88
	db $00, $00, $08, $08, $00, $00, $20, $20, $00, $00, $08, $08, $00, $00, $80, $80
	db $00, $00, $00, $00, $00, $00, $00, $00, $80, $80, $80, $80, $80, $80, $80, $80
	db $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80, $80
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $12, $02, $22, $02, $42, $02, $42, $02, $8E, $02, $BF, $03, $FB, $00, $60, $00
	db $00, $FF, $00, $00, $00, $FF, $00, $00, $00, $00, $FF, $FF, $FF, $00, $00, $00
	db $0C, $E8, $0C, $08, $0C, $E8, $0C, $08, $0C, $08, $FC, $F8, $FC, $00, $00, $00

Gfx_MailTitle_Tiles8800:: ; 2C:5410
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles8800.2bpp"
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- zero $566C-$5670 (4 bytes) [PROBABLE] 4 zero bytes before the palette block 5670
	ds $4, $00

; ---- data $5670-$56B0 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2C:41AC (ld hl,$5670 ; a=$2C)

Palette_MailTitle_Obj:: ; 2C:5670
Palette_2C_5670::
	INCLUDE "gfx/mail/mail_title_entry/mail_title_obj.pal"

; ---- ptrtable $56B0-$56C0 (16 bytes) [PROBABLE] 8 words, all inside $56C0-$56F2 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; caller not located

Table_2C_56B0:: ; 2C:56B0
	dw Data_2C_56C0
	dw $56EF
	dw Data_2C_56C0
	dw $56EF
	dw Data_2C_56C0
	dw $56EF
	dw Data_2C_56C0
	dw $56EF

; ---- data $56C0-$56F2 (50 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; 56C2 = count $0B + 11 entries, 56EF = 01 00 04 terminator group; targets of the 56B0 table (56C0, 56EF)

Data_2C_56C0:: ; 2C:56C0
	db $C2, $56, $0B, $00, $08, $00, $02, $00, $10, $01, $02, $00, $18, $02, $02, $08
	db $00, $03, $02, $08, $08, $04, $02, $08, $10, $05, $02, $08, $18, $06, $02, $10
	db $00, $07, $02, $10, $08, $2A, $02, $10, $10, $2B, $02, $10, $18, $2C, $02, $01
	db $00, $04
