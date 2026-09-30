; gfx/mail_menu/mail_menu.asm
; bank 1D, $45C1-$63BA (7673 bytes); pinned by layout.link
; mail menu tilemaps, attribute maps, tiles, palettes, object records

SECTION "gfx/mail_menu/mail_menu", ROMX

; ---- data $45C1-$4891 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 1D:40CC: hl=$45C1 a=$1D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MailMenu_Screen:: ; 1D:45C1
Data_1D_45C1::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_screen.tilemap"
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_screen.attrmap"

; ---- data $4891-$4981 (240 bytes) [PROBABLE] 10 columns x 24 rows tile-id map (tiles half of a 240+240 byte pair). base $4891 is base loaded by 'ld hl,$4891' at 1D:42E1 (then + index, ld c,$0A); executed reads in mail_*/monkey traces walk it in 10-byte rows (e.g. 4963-49C7). Attribute half follows at 4981. Covers the former unresolved span 4945-4963 (3 map rows).

Tilemap_MailMenu_PlatesNormal:: ; 1D:4891
Tilemap_1D_4891::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_normal.tilemap"

; ---- data $4981-$4A71 (240 bytes) [PROBABLE] attribute half (10x24) paired with Tilemap_1D_4891: values 01/02/09/29 (CGB BG attributes: palette 1/2/1, xflip 0x20); executed reads begin exactly at 4981 in mail_/monkey traces

Attrmap_MailMenu_PlatesNormal:: ; 1D:4981
Attrmap_1D_4981::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_normal.attrmap"

; ---- data $4A71-$4B61 (240 bytes) [PROBABLE] 10x24 tile-id map (frame border 36 37.. 36 in first row); base loaded by 'ld hl,$4A71' at 1D:4357 (+ index, ld c,$0A); executed reads in 10-byte rows from 4A71. the former unresolved span 4A35-4A53 belongs to the preceding attr map, see Attrmap_1D_4981

Tilemap_MailMenu_PlatesSelected:: ; 1D:4A71
Tilemap_1D_4A71::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_selected.tilemap"

; ---- data $4B61-$4C51 (240 bytes) [PROBABLE] attribute half (10x24) paired with Tilemap_1D_4A71; executed reads begin at 4B61

Attrmap_MailMenu_PlatesSelected:: ; 1D:4B61
Attrmap_1D_4B61::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_plates_selected.attrmap"

; ---- data $4C51-$4CB1 (96 bytes) [PROBABLE] tile-id map half of a 96+96 byte pair loaded at 1D:43BC 'ld hl,$4C51' (with 'ld bc,$0608 ; ld de,$D0C1') then Function_00_16A2 (far); executed reads at 4C51-4D11 and second halves 4C81-4CB1 / 4CE1-4D11 (48 bytes each)

Tilemap_MailMenu_IconFrames:: ; 1D:4C51
Tilemap_1D_4C51::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_icon_frames.tilemap"

; ---- data $4CB1-$4D11 (96 bytes) [PROBABLE] attribute half (values 01/03/09) paired with Tilemap_1D_4C51; ends exactly at padding 4D11

Attrmap_MailMenu_IconFrames:: ; 1D:4CB1
Attrmap_1D_4CB1::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_icon_frames.attrmap"

; ---- zero $4D11-$4D20 (15 bytes) [PROBABLE] 15 bytes of $00 padding before the tile block loaded from 4D20
	ds $F, $00

; ---- gfx $4D20-$4EB0 (400 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4050: hl=$4D20 a=$1D c=$19 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_MailMenu_Tiles0:: ; 1D:4D20
Data_1D_4D20::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles0.2bpp"

; ---- gfx $4EB0-$52B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4062: hl=$4EB0 a=$1D c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_MailMenu_Tiles1:: ; 1D:4EB0
Data_1D_4EB0::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles1.2bpp"

; ---- gfx $52B0-$56B0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4074: hl=$52B0 a=$1D c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

Gfx_MailMenu_Tiles2:: ; 1D:52B0
Data_1D_52B0::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles2.2bpp"

; ---- gfx $56B0-$5AB0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4086: hl=$56B0 a=$1D c=$40 de=$9000 (dest VRAM $9000, vbank=0)

Gfx_MailMenu_Tiles3:: ; 1D:56B0
Data_1D_56B0::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles3.2bpp"

; ---- gfx $5AB0-$5E30 (896 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:4098: hl=$5A30 a=$1D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [clipped from 5A30-5E30 by higher-priority evidence]

Gfx_MailMenu_Tiles4:: ; 1D:5AB0
Data_1D_5AB0::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles4.2bpp"

; ---- gfx $5E30-$6230 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 1D:40AA: hl=$5E30 a=$1D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_MailMenu_Tiles5:: ; 1D:5E30
Data_1D_5E30::
	INCBIN "gfx/mail_menu/mail_menu/mail_menu_tiles5.2bpp"

; ---- data $6230-$6238 (8 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 4D20-63BA by higher-priority evidence]

Palette_MailMenu_Bg:: ; 1D:6230
Data_1D_6230::
	INCLUDE "gfx/mail_menu/mail_menu/mail_menu_bg.pal"

; ---- data $6238-$6250 (24 bytes) [PROBABLE] palette-rgb555: heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_1D_6238:: ; 1D:6238
	INCLUDE "gfx/mail_menu/mail_menu/palette_6238.pal"

; ---- data $6250-$6258 (8 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 4D20-63BA by higher-priority evidence]

Data_1D_6250:: ; 1D:6250
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $6258-$6278 (32 bytes) [PROBABLE] palette-rgb555: heuristic: 16 RGB555 words as 4 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_1D_6258:: ; 1D:6258
	INCLUDE "gfx/mail_menu/mail_menu/palette_6258.pal"

Palette_MailMenu_Obj:: ; 1D:6270
	INCLUDE "gfx/mail_menu/mail_menu/mail_menu_obj.pal"

; ---- data $6278-$6280 (8 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 4D20-63BA by higher-priority evidence]

Data_1D_6278:: ; 1D:6278
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $6280-$62AC (44 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 80 RGB555 words as 20 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 6280-6320 by higher-priority proposals]

Data_1D_6280:: ; 1D:6280
	INCLUDE "gfx/mail_menu/mail_menu/palette_6280.pal"

; ---- data $62AC-$6320 (116 bytes) [PROBABLE] palette-rgb555: heuristic: 80 RGB555 words as 20 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 6280-6320 by higher-priority evidence]

Data_1D_62AC:: ; 1D:62AC
	INCLUDE "gfx/mail_menu/mail_menu/palette_62ac.pal"

; ---- data $6320-$63BA (154 bytes) [CONFIRMED] read as data by executed code (in up to 9/18 scenarios); content class unknown [clipped from 4D20-63BA by higher-priority evidence]

Data_MailMenu_ObjectRecords:: ; 1D:6320
Data_1D_6320::
	db $11, $00, $F8, $20, $12, $00, $06, $F2, $14, $03, $00, $F2, $1C, $04, $00, $F2
	db $24, $05, $00, $FA, $14, $13, $00, $FA, $1C, $14, $00, $FA, $24, $15, $00, $06
	db $F0, $18, $06, $00, $F0, $20, $07, $00, $F0, $28, $08, $00, $F8, $18, $16, $00
	db $F8, $20, $17, $00, $F8, $28, $18, $00, $06, $F2, $1C, $00, $00, $F2, $24, $01
	db $00, $F2, $2C, $02, $00, $FA, $1C, $10, $00, $FA, $24, $11, $00, $FA, $2C, $12
	db $00, $06, $F0, $20, $03, $00, $F0, $28, $04, $00, $F0, $30, $05, $00, $F8, $20
	db $13, $00, $F8, $28, $14, $00, $F8, $30, $15, $00, $06, $F2, $24, $06, $00, $F2
	db $2C, $07, $00, $F2, $34, $08, $00, $FA, $24, $16, $00, $FA, $2C, $17, $00, $FA
	db $34, $18, $00, $09, $00, $08, $01, $08, $02, $08, $03, $08, $04, $08, $05, $08
	db $06, $08, $07, $08, $08, $08

Table_MailMenu_Objects:: ; 1D:63B6
	db $B0, $62, $A3, $63
