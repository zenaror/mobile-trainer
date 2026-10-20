; gfx/help/script_illustrations_14_26.asm
; bank 60, $4000-$7AE8 (15080 bytes); pinned by layout.link
; HelpScript picture IDs 14-26: table-backed tile windows and BG palettes

SECTION "gfx/help/script_illustrations_14_26", ROMX

; ---- gfx $4000-$4480 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 14; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture14Tiles:: ; 60:4000
	INCBIN "gfx/help/script_illustrations_14_26/picture_14_tiles.2bpp"

; ---- gfx $4480-$4900 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 15; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture15Tiles:: ; 60:4480
	INCBIN "gfx/help/script_illustrations_14_26/picture_15_tiles.2bpp"

; ---- gfx $4900-$4D80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 16; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture16Tiles:: ; 60:4900
	INCBIN "gfx/help/script_illustrations_14_26/picture_16_tiles.2bpp"

; ---- gfx $4D80-$5200 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 17; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture17Tiles:: ; 60:4D80
	INCBIN "gfx/help/script_illustrations_14_26/picture_17_tiles.2bpp"

; ---- gfx $5200-$5680 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 18; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture18Tiles:: ; 60:5200
	INCBIN "gfx/help/script_illustrations_14_26/picture_18_tiles.2bpp"

; ---- gfx $5680-$5B00 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 19; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture19Tiles:: ; 60:5680
	INCBIN "gfx/help/script_illustrations_14_26/picture_19_tiles.2bpp"

; ---- gfx $5B00-$5F80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 20; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture20Tiles:: ; 60:5B00
	INCBIN "gfx/help/script_illustrations_14_26/picture_20_tiles.2bpp"

; ---- gfx $5F80-$6400 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 21; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture21Tiles:: ; 60:5F80
	INCBIN "gfx/help/script_illustrations_14_26/picture_21_tiles.2bpp"

; ---- gfx $6400-$6880 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 22; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture22Tiles:: ; 60:6400
	INCBIN "gfx/help/script_illustrations_14_26/picture_22_tiles.2bpp"

; ---- gfx $6880-$6D00 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 23; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture23Tiles:: ; 60:6880
	INCBIN "gfx/help/script_illustrations_14_26/picture_23_tiles.2bpp"

; ---- gfx $6D00-$7180 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 24; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture24Tiles:: ; 60:6D00
	INCBIN "gfx/help/script_illustrations_14_26/picture_24_tiles.2bpp"

; ---- gfx $7180-$7600 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 25; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture25Tiles:: ; 60:7180
	INCBIN "gfx/help/script_illustrations_14_26/picture_25_tiles.2bpp"

; ---- gfx $7600-$7A80 (1152 bytes) [PROBABLE] HelpScript_PictureTable ID 26; static reader selects this complete 12x6 tile window for VRAM0:$8800-$8C7F, not a natural-display claim

Gfx_HelpScript_Picture26Tiles:: ; 60:7600
	INCBIN "gfx/help/script_illustrations_14_26/picture_26_tiles.2bpp"

; ---- data $7A80-$7A88 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 14 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture14:: ; 60:7A80
	INCLUDE "gfx/help/script_illustrations_14_26/picture_14_palette.pal"

; ---- data $7A88-$7A90 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 15 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture15:: ; 60:7A88
	INCLUDE "gfx/help/script_illustrations_14_26/picture_15_palette.pal"

; ---- data $7A90-$7A98 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 16 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture16:: ; 60:7A90
	INCLUDE "gfx/help/script_illustrations_14_26/picture_16_palette.pal"

; ---- data $7A98-$7AA0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 17 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture17:: ; 60:7A98
	INCLUDE "gfx/help/script_illustrations_14_26/picture_17_palette.pal"

; ---- data $7AA0-$7AA8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 18 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture18:: ; 60:7AA0
	INCLUDE "gfx/help/script_illustrations_14_26/picture_18_palette.pal"

; ---- data $7AA8-$7AB0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 19 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture19:: ; 60:7AA8
	INCLUDE "gfx/help/script_illustrations_14_26/picture_19_palette.pal"

; ---- data $7AB0-$7AB8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 20 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture20:: ; 60:7AB0
	INCLUDE "gfx/help/script_illustrations_14_26/picture_20_palette.pal"

; ---- data $7AB8-$7AC0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 21 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture21:: ; 60:7AB8
	INCLUDE "gfx/help/script_illustrations_14_26/picture_21_palette.pal"

; ---- data $7AC0-$7AC8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 22 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture22:: ; 60:7AC0
	INCLUDE "gfx/help/script_illustrations_14_26/picture_22_palette.pal"

; ---- data $7AC8-$7AD0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 23 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture23:: ; 60:7AC8
	INCLUDE "gfx/help/script_illustrations_14_26/picture_23_palette.pal"

; ---- data $7AD0-$7AD8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 24 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture24:: ; 60:7AD0
	INCLUDE "gfx/help/script_illustrations_14_26/picture_24_palette.pal"

; ---- data $7AD8-$7AE0 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 25 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture25:: ; 60:7AD8
	INCLUDE "gfx/help/script_illustrations_14_26/picture_25_palette.pal"

; ---- data $7AE0-$7AE8 (8 bytes) [PROBABLE] HelpScript_PictureTable ID 26 palette source; the static reader copies four RGB555 colours into BG palette 6

Palette_HelpScript_Picture26:: ; 60:7AE0
	INCLUDE "gfx/help/script_illustrations_14_26/picture_26_palette.pal"
