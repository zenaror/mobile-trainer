; gfx/mail/mail_title_entry.asm
; bank 2C, $4A30-$56F2 (3266 bytes); pinned by layout.link
; title entry tiles, tilemap, palettes

SECTION "gfx/mail/mail_title_entry", ROMX

; ---- data $4A30-$4E30 (1024 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); kind tiles from the label name [clipped from 4A30-56B0 by higher-priority evidence]

Gfx_MailTitle_Tiles9300Vb1:: ; 2C:4A30
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles9300.2bpp"

; ---- data $4E30-$5100 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:41CE: hl=$4E30 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000

Data_MailTitle_TilemapAttr:: ; 2C:4E30
	INCBIN "gfx/mail/mail_title_entry/data_mail_title_tilemap_attr.tilemap"
	INCBIN "gfx/mail/mail_title_entry/data_mail_title_tilemap_attr.attrmap"

; ---- data $5100-$5150 (80 bytes) [PROBABLE] palette-rgb555: heuristic: 40 RGB555 words as 10 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailTitle_Bg:: ; 2C:5100
	INCLUDE "gfx/mail/mail_title_entry/mail_title_bg.pal"

Gfx_MailTitle_Tiles8000:: ; 2C:5140
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles8000.2bpp"

; ---- gfx $5150-$5410 (704 bytes) [CONFIRMED] continuation of the HDMA load beginning at Gfx_MailTitle_Tiles8000 ($5140); loaded to VRAM bank 0 at $8010-$82CF

Gfx_MailTitle_Tiles8000Continuation:: ; 2C:5150
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles8000_continuation.2bpp"

Gfx_MailTitle_Tiles8800:: ; 2C:5410
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/mail_title_entry/mail_title_tiles8800.2bpp"
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- zero $566C-$5670 (4 bytes) [PROBABLE] 4 zero bytes before the palette block 5670
	ds $4, $00

; ---- data $5670-$56B0 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2C:41AC (ld hl,$5670 ; a=$2C)

Palette_MailTitle_Obj:: ; 2C:5670
	INCLUDE "gfx/mail/mail_title_entry/mail_title_obj.pal"

; ---- ptrtable $56B0-$56C0 (16 bytes) [PROBABLE] 8 words, all inside $56C0-$56F2 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: Sprite_LoadObjectEntry (00:0AB8) selects DE + 4*(B&$3F); bit 7 of the original id separately controls repeat behavior); each 16-byte table = 4 identical-pair entries; caller not located

MailTitle_ProbableObjAnimFrameTable:: ; 2C:56B0
	dw MailTitle_ProbableObjAnimFrameData
	dw $56EF
	dw MailTitle_ProbableObjAnimFrameData
	dw $56EF
	dw MailTitle_ProbableObjAnimFrameData
	dw $56EF
	dw MailTitle_ProbableObjAnimFrameData
	dw $56EF

; ---- data $56C0-$56F2 (50 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; 56C2 = count $0B + 11 entries, 56EF = 01 00 04 terminator group; targets of the 56B0 table (56C0, 56EF)

MailTitle_ProbableObjAnimFrameData:: ; 2C:56C0
	db $C2, $56, $0B, $00, $08, $00, $02, $00, $10, $01, $02, $00, $18, $02, $02, $08
	db $00, $03, $02, $08, $08, $04, $02, $08, $10, $05, $02, $08, $18, $06, $02, $10
	db $00, $07, $02, $10, $08, $2A, $02, $10, $10, $2B, $02, $10, $18, $2C, $02, $01
	db $00, $04
