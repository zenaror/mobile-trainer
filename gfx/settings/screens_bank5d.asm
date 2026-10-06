; gfx/settings/screens_bank5d.asm
; bank 5D, $7360-$7E70 (2832 bytes); pinned by layout.link
; settings screens art loaded by bank 67

SECTION "gfx/settings/screens_bank5d", ROMX

; ---- gfx $7360-$7760 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:658D: hl=$7360 a=$5D c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_PwSaveConfirm_Tiles9000Vb1:: ; 5D:7360
Data_5D_7360::
	INCBIN "gfx/settings/screens_bank5d/tiles_7360.2bpp"

; ---- gfx $7760-$7B60 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:659F: hl=$7760 a=$5D c=$40 de=$9401 (dest VRAM $9400, vbank=1)

Gfx_PwSaveConfirm_Tiles9400Vb1:: ; 5D:7760
Data_5D_7760::
	INCBIN "gfx/settings/screens_bank5d/tiles_7760.2bpp"

; ---- data $7B60-$7BA0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/password_save_confirm.asm:58, call 67:65C2 executed 16 hits in 6 scenarios (analysis/coverage_union.tsv))

Palette_PwSaveConfirm_Bg:: ; 5D:7B60
Data_5D_7B60::
	INCLUDE "gfx/settings/screens_bank5d/pw_save_confirm_bg.pal"

; ---- data $7BA0-$7E70 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:65EA: hl=$7BA0 a=$5D b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_PwSaveConfirm_5D_7BA0:: ; 5D:7BA0
Data_5D_7BA0::
	INCBIN "gfx/settings/screens_bank5d/tilemap_7ba0.tilemap"
	INCBIN "gfx/settings/screens_bank5d/tilemap_7ba0.attrmap"
