; gfx/registration/screens_bank58.asm
; bank 58, $4000-$7EA0 (16032 bytes); pinned by layout.link
; registration screens art (loaded by bank 65)

SECTION "gfx/registration/screens_bank58", ROMX

; ---- gfx $4000-$41D0 (464 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 65:48D1: hl=$4000 a=$58 c=$1D de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Notice_Tiles9000Vb1:: ; 58:4000
Tiles_58_4000::
	INCBIN "gfx/registration/screens_bank58/tiles_4000.2bpp"

; ---- gfx $41D0-$4450 (640 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 41D0-4450 = 40 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_41D0:: ; 58:41D0
	INCBIN "gfx/registration/screens_bank58/tiles_41d0.2bpp"

; ---- gfx $4450-$46D0 (640 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 4450-46D0 = 40 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_4450:: ; 58:4450
	INCBIN "gfx/registration/screens_bank58/tiles_4450.2bpp"

; ---- gfx $46D0-$4E50 (1920 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 46D0-4E50 = 120 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_46D0:: ; 58:46D0
	INCBIN "gfx/registration/screens_bank58/tiles_46d0.2bpp"

; ---- gfx $4E50-$5350 (1280 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 4E50-5350 = 80 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_4E50:: ; 58:4E50
	INCBIN "gfx/registration/screens_bank58/tiles_4e50.2bpp"

; ---- gfx $5350-$5850 (1280 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 5350-5850 = 80 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_5350:: ; 58:5350
	INCBIN "gfx/registration/screens_bank58/tiles_5350.2bpp"

; ---- gfx $5850-$5AD0 (640 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 5850-5AD0 = 40 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_5850:: ; 58:5850
	INCBIN "gfx/registration/screens_bank58/tiles_5850.2bpp"

; ---- gfx $5AD0-$6D40 (4720 bytes) [PROBABLE] 2bpp tile data (rendered 2bpp sheet: Japanese title/registration text banners, digits, frame tiles); 5AD0-6D40 merged from regions with unaligned edges 6A81/6CE1 (heuristic parity noise); executed HDMA source reads on this range are 16-byte aligned to the 4xx0 grid (5AD0-69D0, 69D0-7150, 6C50-6ED0)

Tiles_58_5AD0:: ; 58:5AD0
	INCBIN "gfx/registration/screens_bank58/tiles_5ad0.2bpp"

; ---- gfx $6D40-$7460 (1824 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 6D40-7460 = 114 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_6D40:: ; 58:6D40
	INCBIN "gfx/registration/screens_bank58/tiles_6d40.2bpp"

; ---- gfx $7460-$7650 (496 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 7460-7650 = 31 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_7460:: ; 58:7460
	INCBIN "gfx/registration/screens_bank58/tiles_7460.2bpp"

; ---- gfx $7650-$7790 (320 bytes) [PROBABLE] 2bpp tile data of the bank-58 tile area 4000-7B50 (rendered 2bpp sheet shows Japanese title/registration text banners, digits and frame tiles); byte range 7650-7790 = 20 tiles; boundaries of executed HDMA source reads (traces/detail/*/dataaccess.tsv, e.g. 4000-4450, 46D0-4BD0, 5AD0-69D0, 69D0-7150) are 16-byte aligned to the 4000 grid; no direct loader call resolved for this range

Tiles_58_7650:: ; 58:7650
	INCBIN "gfx/registration/screens_bank58/tiles_7650.2bpp"

; ---- gfx $7790-$7B50 (960 bytes) [PROBABLE] 60 tiles of 2bpp (rendered: title/registration text banner art); 7790-7B50 ends exactly where the 5 palettes at 7B50 begin

Tiles_58_7790:: ; 58:7790
	INCBIN "gfx/registration/screens_bank58/tiles_7790.2bpp"

; ---- data $7B50-$7B78 (40 bytes) [PROBABLE] 5 CGB palettes (40 bytes) of 4 RGB555 words: 0000 0000 0000 7FFF / 0000 414A 4273 7FFF / 0000 28D3 01FF 7FFF / 2 x 0000; executed reads cover 7B50-7E48 contiguously = these palettes followed by the 18x20 tilemap+attr at 7B78 (loaded together)

Palette_Notice_Bg:: ; 58:7B50
Palette_58_7B50::
	INCLUDE "gfx/registration/screens_bank58/palette_7b50.pal"

; ---- data $7B78-$7E48 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 65:4900: hl=$7B78 a=$58 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Notice_58_7B78:: ; 58:7B78
Data_58_7B78::
	INCBIN "gfx/registration/screens_bank58/tilemap_7b78.tilemap"
	INCBIN "gfx/registration/screens_bank58/tilemap_7b78.attrmap"

; ---- data $7E48-$7EA0 (88 bytes) [PROBABLE] 22 records x 4 bytes (top tile, bottom tile, attr, attr): 00 10 09 09 / 01 11 09 09 ... 0A 1A 09 09 for attr 09 then the same 11 pairs with attr 0A 0A (8x16 digit glyphs 0-9 + one more, tile pairs n and n+$10); executed code reads single 4-byte records (7E4C-7E50, 7E70-7E74, 7E78-7E80, 7E9C-7EA0 in traces)

Data_58_7E48:: ; 58:7E48
	db $00, $10, $09, $09, $01, $11, $09, $09, $02, $12, $09, $09, $03, $13, $09, $09
	db $04, $14, $09, $09, $05, $15, $09, $09, $06, $16, $09, $09, $07, $17, $09, $09
	db $08, $18, $09, $09, $09, $19, $09, $09, $0A, $1A, $09, $09, $00, $10, $0A, $0A
	db $01, $11, $0A, $0A, $02, $12, $0A, $0A, $03, $13, $0A, $0A, $04, $14, $0A, $0A
	db $05, $15, $0A, $0A, $06, $16, $0A, $0A, $07, $17, $0A, $0A, $08, $18, $0A, $0A
	db $09, $19, $0A, $0A, $0A, $1A, $0A, $0A
