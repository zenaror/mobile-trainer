; gfx/error/comm_error_screen.asm
; bank 5C, $5516-$642F (3865 bytes); pinned by layout.link
; error screen tilemaps, tiles, palettes, object tables

SECTION "gfx/error/comm_error_screen", ROMX

; ---- data $5516-$57E6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 5C:52A2: hl=$5516 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_Comm:: ; 5C:5516
Data_5C_5516::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm.attrmap"

; ---- data $57E6-$5AB6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 5C:52B7: hl=$57E6 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_CommTimer:: ; 5C:57E6
Data_5C_57E6::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm_timer.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm_timer.attrmap"

; ---- data $5AB6-$5D86 (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (5C:52FB 5C:53AC); first: copy_tilemap_rect_pair at 5C:52FB: hl=$5AB6 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_Plain:: ; 5C:5AB6
Data_5C_5AB6::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_plain.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_plain.attrmap"

; ---- zero $5D86-$5D90 (10 bytes) [PROBABLE] 10 x 00 between the 09-filled block ending at 5D86 and the tile block at 5D90
	ds $A, $00

; ---- gfx $5D90-$5DB0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:5194: hl=$5D90 a=$5C c=$02 de=$8001 (dest VRAM $8000, vbank=1)

CommErr_Gfx_Obj8000:: ; 5C:5D90
Data_5C_5D90::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_obj8000.2bpp"

; ---- gfx $5DB0-$5DD0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51A6: hl=$5DB0 a=$5C c=$02 de=$8101 (dest VRAM $8100, vbank=1)

CommErr_Gfx_Obj8100:: ; 5C:5DB0
Data_5C_5DB0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_obj8100.2bpp"

; ---- gfx $5DD0-$61D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51B8: hl=$5DD0 a=$5C c=$40 de=$9001 (dest VRAM $9000, vbank=1)

CommErr_Gfx_Bg9000:: ; 5C:5DD0
Data_5C_5DD0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_bg9000.2bpp"

; ---- gfx $61D0-$6350 (384 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51CA: hl=$61D0 a=$5C c=$18 de=$9401 (dest VRAM $9400, vbank=1)

CommErr_Gfx_Bg9400:: ; 5C:61D0
Data_5C_61D0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_bg9400.2bpp"

; ---- gfx $6350-$6420 (208 bytes) [PROBABLE] tiles-2bpp: heuristic: 40 coherent tiles (hsim2=0.719 vsim2=0.738, 8 blank) parity 0; 576/784 bytes also covered by call-site blocks [clipped from 6110-6420 by higher-priority evidence]

CommErr_Palette_BgTimer:: ; 5C:6350
Data_5C_6350::
	; kind (palette) from the label name / config/symbols note; the region header above describes the block differently
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_bg_timer.pal"

CommErr_Palette_Bg:: ; 5C:6390
	; kind (palette) from the label name / config/symbols note; the region header above describes the block differently
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_bg.pal"

CommErr_Palette_Obj:: ; 5C:63D0
	; kind (palette) from the label name / config/symbols note; the region header above describes the block differently
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_obj.pal"

CommErr_ObjAnim:: ; 5C:6410
	db $14, $64, $25, $64, $04, $00, $00, $00, $08, $00, $08, $01, $08, $08, $00, $10

; ---- data $6420-$642F (15 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [clipped from 5D90-642F by higher-priority evidence]

Data_5C_6420:: ; 5C:6420
	db $08, $08, $08, $11, $08, $00, $02, $00, $0C, $01, $0C

CommErr_ObjTable:: ; 5C:642B
	db $10, $64, $26, $64
