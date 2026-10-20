; gfx/help/script_illustrations_01_13.asm
; bank 61, $4000-$7AE8 (15080 bytes); pinned by layout.link
; HelpScript picture IDs 01-13: table-backed tile windows and BG palettes

SECTION "gfx/help/script_illustrations_01_13", ROMX

; ---- gfx $4000-$4480 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 1; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture01Tiles:: ; 61:4000
	INCBIN "gfx/help/script_illustrations_01_13/picture_01_tiles.2bpp"

; ---- gfx $4480-$4900 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 2; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture02Tiles:: ; 61:4480
	INCBIN "gfx/help/script_illustrations_01_13/picture_02_tiles.2bpp"

; ---- gfx $4900-$4D80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 3; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture03Tiles:: ; 61:4900
	INCBIN "gfx/help/script_illustrations_01_13/picture_03_tiles.2bpp"

; ---- gfx $4D80-$5200 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 4; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture04Tiles:: ; 61:4D80
	INCBIN "gfx/help/script_illustrations_01_13/picture_04_tiles.2bpp"

; ---- gfx $5200-$5680 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 5; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture05Tiles:: ; 61:5200
	INCBIN "gfx/help/script_illustrations_01_13/picture_05_tiles.2bpp"

; ---- gfx $5680-$5B00 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 6; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture06Tiles:: ; 61:5680
	INCBIN "gfx/help/script_illustrations_01_13/picture_06_tiles.2bpp"

; ---- gfx $5B00-$5F80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 7; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture07Tiles:: ; 61:5B00
	INCBIN "gfx/help/script_illustrations_01_13/picture_07_tiles.2bpp"

; ---- gfx $5F80-$6400 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 8; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture08Tiles:: ; 61:5F80
	INCBIN "gfx/help/script_illustrations_01_13/picture_08_tiles.2bpp"

; ---- gfx $6400-$6880 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 9; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture09Tiles:: ; 61:6400
	INCBIN "gfx/help/script_illustrations_01_13/picture_09_tiles.2bpp"

; ---- gfx $6880-$6D00 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 10; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture10Tiles:: ; 61:6880
	INCBIN "gfx/help/script_illustrations_01_13/picture_10_tiles.2bpp"

; ---- gfx $6D00-$7180 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 11; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture11Tiles:: ; 61:6D00
	INCBIN "gfx/help/script_illustrations_01_13/picture_11_tiles.2bpp"

; ---- gfx $7180-$7600 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 12; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture12Tiles:: ; 61:7180
	INCBIN "gfx/help/script_illustrations_01_13/picture_12_tiles.2bpp"

; ---- gfx $7600-$7A80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 13; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture13Tiles:: ; 61:7600
	INCBIN "gfx/help/script_illustrations_01_13/picture_13_tiles.2bpp"

; ---- data $7A80-$7A88 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 1 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture01:: ; 61:7A80
	INCLUDE "gfx/help/script_illustrations_01_13/picture_01_palette.pal"

; ---- data $7A88-$7A90 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 2 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture02:: ; 61:7A88
	INCLUDE "gfx/help/script_illustrations_01_13/picture_02_palette.pal"

; ---- data $7A90-$7A98 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 3 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture03:: ; 61:7A90
	INCLUDE "gfx/help/script_illustrations_01_13/picture_03_palette.pal"

; ---- data $7A98-$7AA0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 4 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture04:: ; 61:7A98
	INCLUDE "gfx/help/script_illustrations_01_13/picture_04_palette.pal"

; ---- data $7AA0-$7AA8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 5 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture05:: ; 61:7AA0
	INCLUDE "gfx/help/script_illustrations_01_13/picture_05_palette.pal"

; ---- data $7AA8-$7AB0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 6 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture06:: ; 61:7AA8
	INCLUDE "gfx/help/script_illustrations_01_13/picture_06_palette.pal"

; ---- data $7AB0-$7AB8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 7 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture07:: ; 61:7AB0
	INCLUDE "gfx/help/script_illustrations_01_13/picture_07_palette.pal"

; ---- data $7AB8-$7AC0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 8 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture08:: ; 61:7AB8
	INCLUDE "gfx/help/script_illustrations_01_13/picture_08_palette.pal"

; ---- data $7AC0-$7AC8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 9 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture09:: ; 61:7AC0
	INCLUDE "gfx/help/script_illustrations_01_13/picture_09_palette.pal"

; ---- data $7AC8-$7AD0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 10 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture10:: ; 61:7AC8
	INCLUDE "gfx/help/script_illustrations_01_13/picture_10_palette.pal"

; ---- data $7AD0-$7AD8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 11 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture11:: ; 61:7AD0
	INCLUDE "gfx/help/script_illustrations_01_13/picture_11_palette.pal"

; ---- data $7AD8-$7AE0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 12 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture12:: ; 61:7AD8
	INCLUDE "gfx/help/script_illustrations_01_13/picture_12_palette.pal"

; ---- data $7AE0-$7AE8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 13 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture13:: ; 61:7AE0
	INCLUDE "gfx/help/script_illustrations_01_13/picture_13_palette.pal"
