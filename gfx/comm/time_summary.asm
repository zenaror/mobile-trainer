; gfx/comm/time_summary.asm
; bank 51, $42A0-$70E0 (11840 bytes); pinned by layout.link
; summary screen tilemaps, tiles, palettes

SECTION "gfx/comm/time_summary", ROMX

; ---- gfx $42A0-$46A0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 51:40CB: hl=$42A0 a=$51 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

Gfx_CommTime_SummaryA_Tiles9000Vb1:: ; 51:42A0
Data_51_42A0::
	INCBIN "gfx/comm/time_summary/tiles_42a0.2bpp"

; ---- gfx $46A0-$4AA0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 51:40DD: hl=$46A0 a=$51 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

Gfx_CommTime_SummaryA_Tiles9400Vb1:: ; 51:46A0
Data_51_46A0::
	INCBIN "gfx/comm/time_summary/tiles_46a0.2bpp"

; ---- data $4AA0-$4D70 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 51:40FF: hl=$4AA0 a=$51 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 1 hits in 1 scenarios (analysis/coverage_union.tsv)]

Tilemap_CommTime_SummaryA:: ; 51:4AA0
Data_51_4AA0::
	INCBIN "gfx/comm/time_summary/comm_time_summary_a.tilemap"
	INCBIN "gfx/comm/time_summary/comm_time_summary_a.attrmap"

; ---- data $4D70-$4DB0 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_CommTime_SummaryA:: ; 51:4D70
Data_51_4D70::
	INCLUDE "gfx/comm/time_summary/palette_4d70.pal"

; ---- gfx $4DB0-$51B0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (27:4F1D 51:4083); first: hdma_rom_to_vram at 27:4F1D: hl=$4DB0 a=$51 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [call site 51:4083 executed: 104 hits in 26 scenarios (analysis/coverage_union.tsv); the first listed site was not executed]

Gfx_CommTime_SummaryB_Tiles9000Vb1:: ; 51:4DB0
Data_51_4DB0::
	INCBIN "gfx/comm/time_summary/tiles_4db0.2bpp"

; ---- gfx $51B0-$55B0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (27:4F2F 51:4095); first: hdma_rom_to_vram at 27:4F2F: hl=$51B0 a=$51 c=$40 de=$9401 (dest VRAM $9400, vbank=1) [call site 51:4095 executed: 104 hits in 26 scenarios (analysis/coverage_union.tsv); the first listed site was not executed]

Gfx_CommTime_SummaryB_Tiles9400Vb1:: ; 51:51B0
Data_51_51B0::
	INCBIN "gfx/comm/time_summary/tiles_51b0.2bpp"

; ---- data $55B0-$5880 (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (27:4F51 51:40B7); first: copy_tilemap_rect_pair at 27:4F51: hl=$55B0 a=$51 b=18 rows c=20 cols (tiles then attrs) de=$D000 [call site 51:40B7 executed: 104 hits in 26 scenarios (analysis/coverage_union.tsv); the first listed site was not executed]

Tilemap_CommTime_SummaryB:: ; 51:55B0
Data_51_55B0::
	INCBIN "gfx/comm/time_summary/comm_time_summary_b.tilemap"
	INCBIN "gfx/comm/time_summary/comm_time_summary_b.attrmap"

; ---- data $5880-$58C0 (64 bytes) [PROBABLE] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/comm/time_summary.asm:82, call 51:40A6 executed 104 hits in 26 scenarios (analysis/coverage_union.tsv)); +$00 bc=$40 into wPaletteBufBg (engine/mail/send_receive.asm:1856, call 27:4F40 not executed in the traced runs (analysis/coverage_union.tsv))

Palette_CommTime_SummaryB:: ; 51:5880
Data_51_5880::
	INCLUDE "gfx/comm/time_summary/comm_time_summary_b.pal"

; ---- gfx $58C0-$5CC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:40EC: hl=$58C0 a=$51 c=$40 de=$8200 (dest VRAM $8200, vbank=0) [first call site executed: 2 hits in 1 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnIcon_Request2_Tiles8200:: ; 51:58C0
Data_51_58C0::
	INCBIN "gfx/comm/time_summary/tiles_58c0.2bpp"

; ---- gfx $5CC0-$5EC0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 69:40FE: hl=$5CC0 a=$51 c=$20 de=$8600 (dest VRAM $8600, vbank=0) [first call site executed: 2 hits in 1 scenarios (analysis/coverage_union.tsv)]

Gfx_ConnIcon_Request2_Tiles8600:: ; 51:5CC0
Data_51_5CC0::
	INCBIN "gfx/comm/time_summary/tiles_5cc0.2bpp"

; ---- data $5EC0-$5EE0 (32 bytes) [PROBABLE] palette-rgb555: heuristic: 16 RGB555 words as 4 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Palette_ConnIcon_Request2_Obj4:: ; 51:5EC0
Data_51_5EC0::
	INCLUDE "gfx/comm/time_summary/palette_5ec0.pal"

; ---- zero $5EE0-$5EE1 (1 bytes) [HYPOTHESIS] single $00 byte right after the palette-like block ending at 5EE0 and before the tile data (5EE1); purpose unknown (padding?)
	ds $1, $00

; ---- gfx $5EE1-$70E0 (4607 bytes) [PROBABLE] tile data: heuristic: 175 coherent tiles (hsim2=0.751 vsim2=0.738, 102 blank) parity 1 [boundary trimmed 5EE1-70E1 -> 5EE1-70E0 against proven code]

Data_51_5EE1:: ; 51:5EE1
	INCBIN "gfx/comm/time_summary/tiles_5ee1.2bpp"
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
