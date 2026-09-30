; gfx/title/logo.asm
; bank 0E, $60A0-$6BB0 (2832 bytes); pinned by layout.link
; 'Mobile System GB' logo tiles, tilemap, palette

SECTION "gfx/title/logo", ROMX

; ---- gfx $60A0-$64A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:436B: hl=$60A0 a=$0E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_TitleLogo_Tiles0:: ; 0E:60A0
Data_0E_60A0::
	INCBIN "gfx/title/logo/title_logo_tiles0.2bpp"

; ---- gfx $64A0-$68A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:437D: hl=$64A0 a=$0E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_TitleLogo_Tiles1:: ; 0E:64A0
Data_0E_64A0::
	INCBIN "gfx/title/logo/title_logo_tiles1.2bpp"

; ---- data $68A0-$6B70 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 0E:439F: hl=$68A0 a=$0E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_TitleLogo_Screen:: ; 0E:68A0
Data_0E_68A0::
	INCBIN "gfx/title/logo/title_logo_screen.tilemap"
	INCBIN "gfx/title/logo/title_logo_screen.attrmap"

; ---- data $6B70-$6BB0 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_TitleLogo:: ; 0E:6B70
Data_0E_6B70::
	INCLUDE "gfx/title/logo/title_logo.pal"
