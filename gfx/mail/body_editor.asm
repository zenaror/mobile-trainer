; gfx/mail/body_editor.asm
; bank 2D, $5AC0-$65B0 (2800 bytes); pinned by layout.link
; body editor tiles, tilemap, palettes

SECTION "gfx/mail/body_editor", ROMX

; ---- gfx $5AC0-$5E80 (960 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2D:4B58: hl=$5AC0 a=$2D c=$3C de=$9301 (dest VRAM $9300, vbank=1) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

Gfx_MailBody_Tiles:: ; 2D:5AC0
Data_2D_5AC0::
	INCBIN "gfx/mail/body_editor/mail_body_tiles.2bpp"

; ---- data $5E80-$5FC0 (320 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 5AC0-65B0 by higher-priority evidence]

Data_2D_5E80:: ; 2D:5E80
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

Gfx_MailBody_Tiles2:: ; 2D:5EC0
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/body_editor/mail_body_tiles2.2bpp"

; ---- data $5FC0-$6290 (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (2D:4A16 2D:4B9D); first: copy_tilemap_rect_pair at 2D:4A16: hl=$5FC0 a=$2D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_MailBody:: ; 2D:5FC0
Data_2D_5FC0::
	INCBIN "gfx/mail/body_editor/mail_body.tilemap"
	INCBIN "gfx/mail/body_editor/mail_body.attrmap"

; ---- data $6290-$62D0 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_MailBody_Bg:: ; 2D:6290
Data_2D_6290::
	INCLUDE "gfx/mail/body_editor/mail_body_bg.pal"

; ---- gfx $62D0-$6570 (672 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2D:4B6A: hl=$62D0 a=$2D c=$2A de=$8000 (dest VRAM $8000, vbank=0) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

Gfx_MailBody_ObjTiles:: ; 2D:62D0
Data_2D_62D0::
	INCBIN "gfx/mail/body_editor/mail_body_obj_tiles.2bpp"

; ---- data $6570-$65B0 (64 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 5AC0-65B0 by higher-priority evidence]

Palette_MailBody_Obj:: ; 2D:6570
Data_2D_6570::
	INCLUDE "gfx/mail/body_editor/mail_body_obj.pal"
