; gfx/title/title_screen.asm
; bank 0E, $43C0-$60A0 (7392 bytes); pinned by layout.link
; title tiles, tilemap, highlight maps, palettes, objects

SECTION "gfx/title/title_screen", ROMX

; ---- gfx $43C0-$47C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4231: hl=$43C0 a=$0E c=$40 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_Title_Tiles0:: ; 0E:43C0
Data_0E_43C0::
	INCBIN "gfx/title/title_screen/title_tiles0.2bpp"

; ---- gfx $47C0-$4BC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4243: hl=$47C0 a=$0E c=$40 de=$8800 (dest VRAM $8800, vbank=0)

Gfx_Title_Tiles1:: ; 0E:47C0
Data_0E_47C0::
	INCBIN "gfx/title/title_screen/title_tiles1.2bpp"

; ---- gfx $4BC0-$4DC0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4255: hl=$49C0 a=$0E c=$40 de=$8001 (dest VRAM $8000, vbank=1) [clipped from 49C0-4DC0 by higher-priority evidence]

Gfx_Title_Tiles2:: ; 0E:4BC0
Data_0E_4BC0::
	INCBIN "gfx/title/title_screen/title_tiles2.2bpp"

; ---- gfx $4DC0-$4FC0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4267: hl=$4BC0 a=$0E c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 4BC0-4FC0 by higher-priority evidence]

Gfx_Title_Tiles3:: ; 0E:4DC0
Data_0E_4DC0::
	INCBIN "gfx/title/title_screen/title_tiles3.2bpp"

; ---- gfx $4FC0-$53C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4279: hl=$4FC0 a=$0E c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

Gfx_Title_Tiles4:: ; 0E:4FC0
Data_0E_4FC0::
	INCBIN "gfx/title/title_screen/title_tiles4.2bpp"

; ---- gfx $53C0-$57C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:428B: hl=$53C0 a=$0E c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_Title_Tiles5:: ; 0E:53C0
Data_0E_53C0::
	INCBIN "gfx/title/title_screen/title_tiles5.2bpp"

; ---- gfx $57C0-$5BC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:429D: hl=$57C0 a=$0E c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_Title_Tiles6:: ; 0E:57C0
Data_0E_57C0::
	INCBIN "gfx/title/title_screen/title_tiles6.2bpp"

; ---- data $5BC0-$5E90 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 0E:42D0: hl=$5BC0 a=$0E b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Title_Screen:: ; 0E:5BC0
Data_0E_5BC0::
	INCBIN "gfx/title/title_screen/title_screen.tilemap"
	INCBIN "gfx/title/title_screen/title_screen.attrmap"

; ---- gfx $5E90-$5F30 (160 bytes) [PROBABLE] tiles-2bpp: heuristic: 33 coherent tiles (hsim2=0.616 vsim2=0.870, 0 blank) parity 0; 368/528 bytes also covered by call-site blocks [clipped from 5D20-5F30 by higher-priority evidence]

Tilemap_Title_HighlightStart:: ; 0E:5E90
Data_0E_5E90::
	; kind (pair) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/title/title_screen/title_highlight_start.tilemap"
	INCBIN "gfx/title/title_screen/title_highlight_start.attrmap"

Tilemap_Title_HighlightSettings:: ; 0E:5EE0
	; kind (pair) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/title/title_screen/title_highlight_settings.tilemap"
	INCBIN "gfx/title/title_screen/title_highlight_settings.attrmap"

; ---- data $5F30-$60A0 (368 bytes) [PROBABLE] palette-rgb555: heuristic: 184 RGB555 words as 46 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_Title_Bg:: ; 0E:5F30
Data_0E_5F30::
	INCLUDE "gfx/title/title_screen/title_bg.pal"

Palette_Title_Obj:: ; 0E:5F70
	INCLUDE "gfx/title/title_screen/title_obj.pal"

Objects_Title:: ; 0E:5FB0
	db $00, $00, $00, $00, $BC, $5F, $08, $60, $19, $60, $98, $60, $C4, $5F, $D5, $5F
	db $E6, $5F, $F7, $5F, $04, $00, $00, $00, $08, $00, $08, $02, $08, $00, $68, $00
	db $28, $00, $60, $02, $28, $04, $00, $00, $04, $08, $00, $08, $06, $08, $00, $68
	db $04, $28, $00, $60, $06, $28, $04, $00, $00, $08, $08, $00, $08, $0A, $08, $00
	db $68, $08, $28, $00, $60, $0A, $28, $04, $00, $00, $0C, $08, $00, $08, $0E, $08
	db $00, $68, $0C, $28, $00, $60, $0E, $28, $08, $00, $04, $01, $04, $02, $04, $03
	db $04, $03, $04, $02, $04, $01, $04, $00, $04, $1B, $60, $1F, $20, $50, $08, $01
	db $38, $48, $14, $01, $38, $50, $16, $01, $38, $58, $18, $01, $38, $60, $1A, $06
	db $40, $68, $1C, $06, $38, $70, $1E, $06, $20, $40, $0C, $02, $20, $38, $0A, $02
	db $30, $38, $10, $02, $18, $48, $04, $02, $18, $50, $06, $02, $48, $38, $24, $03
	db $48, $40, $26, $03, $48, $48, $28, $03, $48, $50, $2A, $03, $48, $58, $2C, $03
	db $48, $60, $2E, $03, $48, $68, $30, $03, $10, $20, $00, $04, $10, $28, $02, $04
	db $20, $20, $20, $04, $30, $20, $3A, $04, $20, $28, $22, $04, $38, $38, $32, $05
	db $20, $28, $34, $05, $20, $30, $36, $05, $30, $30, $38, $05, $28, $48, $3E, $07
	db $28, $48, $0E, $01, $30, $40, $12, $02, $01, $00, $04, $00, $00, $00, $00, $00
