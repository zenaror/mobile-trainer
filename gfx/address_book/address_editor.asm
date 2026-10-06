; gfx/address_book/address_editor.asm
; bank 2F, $77D0-$7EBF (1775 bytes); pinned by layout.link
; address editor tilemap, palette, tables

SECTION "gfx/address_book/address_editor", ROMX

; ---- data $77D0-$7AC0 (752 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); kind tiles from the label name [clipped from 77D0-7DD0 by higher-priority evidence]

Gfx_AbookAddr_Tiles8800:: ; 2F:77D0
Data_2F_77D0::
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/address_book/address_editor/abook_addr_tiles8800.2bpp"

; ---- data $7AC0-$7D90 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:7020: hl=$7AC0 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_AbookAddr:: ; 2F:7AC0
Data_2F_7AC0::
	INCBIN "gfx/address_book/address_editor/abook_addr.tilemap"
	INCBIN "gfx/address_book/address_editor/abook_addr.attrmap"

; ---- data $7D90-$7DD0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/address_book/address_editor.asm:446, call 2F:700F executed 22 hits in 9 scenarios (analysis/coverage_union.tsv))

Palette_AbookAddr_Bg:: ; 2F:7D90
Data_2F_7D90::
	INCLUDE "gfx/address_book/address_editor/abook_addr_bg.pal"

; ---- ptrtable $7DD0-$7E20 (80 bytes) [PROBABLE] 40 words, all inside 7E20-7EBF (frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; no direct ld de,imm found (caller not located)

Table_2F_7DD0:: ; 2F:7DD0
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw Data_2F_7E20
	dw $7E46
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E4B
	dw $7E71
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E76
	dw $7E8C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7E91
	dw $7E9C
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC
	dw $7EA1
	dw $7EBC

; ---- data $7E20-$7EBF (159 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; ends with the group 01 00 04 right before the code at 7EBF

Data_2F_7E20:: ; 2F:7E20
	db $24, $7E, $35, $7E, $04, $00, $00, $08, $01, $00, $08, $09, $01, $00, $18, $0A
	db $01, $00, $20, $0B, $01, $04, $FF, $00, $08, $01, $FF, $08, $09, $01, $00, $18
	db $0A, $01, $00, $20, $0B, $01, $02, $00, $2E, $01, $08, $4F, $7E, $60, $7E, $04
	db $00, $18, $08, $01, $00, $20, $09, $01, $00, $00, $0A, $01, $00, $08, $0B, $01
	db $04, $00, $18, $08, $01, $00, $20, $09, $01, $FF, $00, $0A, $01, $FF, $08, $0B
	db $01, $02, $00, $2E, $01, $08, $7A, $7E, $83, $7E, $02, $00, $00, $0A, $01, $00
	db $08, $0B, $01, $02, $FF, $00, $0A, $01, $FF, $08, $0B, $01, $02, $00, $2E, $01
	db $08, $93, $7E, $02, $00, $00, $0A, $01, $00, $08, $0B, $01, $02, $00, $2E, $01
	db $08, $A3, $7E, $06, $FF, $02, $2B, $01, $FF, $0A, $2C, $01, $07, $02, $2D, $01
	db $07, $0A, $2E, $01, $0F, $02, $29, $01, $0F, $0A, $2A, $01, $01, $00, $04
