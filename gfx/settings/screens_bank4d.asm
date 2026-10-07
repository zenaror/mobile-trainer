; gfx/settings/screens_bank4d.asm
; bank 4D, $4000-$7983 (14723 bytes); pinned by layout.link
; tiles, tilemaps, object tables loaded by bank 67

SECTION "gfx/settings/screens_bank4d", ROMX

; ---- gfx $4000-$4200 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4789: hl=$4000 a=$4D c=$20 de=$8001 (dest VRAM $8000, vbank=1) [first call site executed: 46 hits in 6 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1:: ; 4D:4000
Data_4D_4000::
	INCBIN "gfx/settings/screens_bank4d/tiles_4000.2bpp"

; ---- gfx $4200-$4510 (784 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46D5: hl=$4110 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)] [clipped from 4110-4510 by higher-priority evidence]

Data_4D_4200:: ; 4D:4200
	INCBIN "gfx/settings/screens_bank4d/tiles_4200.2bpp"

; ---- gfx $4510-$4610 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46E7: hl=$4510 a=$4D c=$10 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_4510:: ; 4D:4510
Data_4D_4510::
	INCBIN "gfx/settings/screens_bank4d/tiles_4510.2bpp"

; ---- gfx $4610-$4A10 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:46F9: hl=$4610 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_4610:: ; 4D:4610
Data_4D_4610::
	INCBIN "gfx/settings/screens_bank4d/tiles_4610.2bpp"

; ---- gfx $4A10-$4D10 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:470B: hl=$4A10 a=$4D c=$30 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles9400Vb1:: ; 4D:4A10
Data_4D_4A10::
	INCBIN "gfx/settings/screens_bank4d/tiles_4a10.2bpp"

; ---- gfx $4D10-$5010 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4730: hl=$4C10 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 33 hits in 5 scenarios (analysis/coverage_union.tsv)] [clipped from 4C10-5010 by higher-priority evidence]

Data_4D_4D10:: ; 4D:4D10
	INCBIN "gfx/settings/screens_bank4d/tiles_4d10.2bpp"

; ---- gfx $5010-$5110 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4742: hl=$5010 a=$4D c=$10 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 33 hits in 5 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_5010:: ; 4D:5010
Data_4D_5010::
	INCBIN "gfx/settings/screens_bank4d/tiles_5010.2bpp"

; ---- gfx $5110-$5510 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4754: hl=$5110 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 33 hits in 5 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_5110:: ; 4D:5110
Data_4D_5110::
	INCBIN "gfx/settings/screens_bank4d/tiles_5110.2bpp"

; ---- data $5510-$5538 (40 bytes) [PROBABLE] palette-rgb555: 20 colours (5 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/choice_menu.asm:147, call 67:479A executed 46 hits in 6 scenarios (analysis/coverage_union.tsv)); the call takes 24 bytes past the end of this block (the palette at $5538 and the first 16 bytes of the tilemap pair at $5540 are copied into the buffer behind it); the length of 40 bytes is by adjacency, not by the call

Palette_SettingsPhone_ChoiceMenu_Bg:: ; 4D:5510
Data_4D_5510::
	INCLUDE "gfx/settings/screens_bank4d/settings_phone_choice_menu_bg.pal"

; ---- data $5538-$5540 (8 bytes) [CONFIRMED] palette-rgb555: 4 colours (1 palettes) read by Palette_LoadToBuffer: +$00 bc=$08 into wPaletteBufObj (engine/settings/choice_menu.asm:152, call 67:47AB executed 46 hits in 6 scenarios (analysis/coverage_union.tsv))

Palette_SettingsPhone_ChoiceMenu_Obj:: ; 4D:5538
	INCLUDE "gfx/settings/screens_bank4d/settings_phone_choice_menu_obj.pal"

; ---- data $5540-$5810 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:471C: hl=$5540 a=$4D b=18 rows c=20 cols (tiles then attrs) de=$D000 [call site 67:471C executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsPhone_ChoiceMenu_4D_5540:: ; 4D:5540
	INCBIN "gfx/settings/screens_bank4d/settings_phone_choice_menu_4d_5540.tilemap"
	INCBIN "gfx/settings/screens_bank4d/settings_phone_choice_menu_4d_5540.attrmap"

; ---- data $5810-$5AE0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:4777: hl=$5810 a=$4D b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 33 hits in 5 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsPhone_ChoiceMenu:: ; 4D:5810
Data_4D_5810::
	INCBIN "gfx/settings/screens_bank4d/tilemap_5810.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5810.attrmap"

; ---- data $5AE0-$5B6C (140 bytes) [CONFIRMED] 14x5 tilemap/attribute pair
; Bank67 table $491C selects this bank4D source; Tilemap_CopyRectAndAttr at 67:4915
; copies 70 tile indices then 70 attribute bytes (BC=$050E; 5 rows x 14 columns).
; All 140 bytes are naturally read in 3/69 scenarios (traces/detail/*/dataaccess.tsv).
; See docs/research/typing_4d_choice_maps.md; no arbitrary cursor-range safety is inferred.

Tilemap_SettingsPhone_ChoiceMenu_Entry0:: ; 4D:5AE0
Tilemap_4D_5AE0::
	INCBIN "gfx/settings/screens_bank4d/tilemap_5ae0.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5ae0.attrmap"

; ---- data $5B6C-$5BF8 (140 bytes) [CONFIRMED] 14x5 tilemap/attribute pair
; Bank67 table $491C selects this bank4D source; Tilemap_CopyRectAndAttr at 67:4915
; copies 70 tile indices then 70 attribute bytes (BC=$050E; 5 rows x 14 columns).
; All 140 bytes are naturally read in 2/69 scenarios (traces/detail/*/dataaccess.tsv).
; See docs/research/typing_4d_choice_maps.md; no arbitrary cursor-range safety is inferred.

Tilemap_SettingsPhone_ChoiceMenu_Entry1:: ; 4D:5B6C
Tilemap_4D_5B6C::
	INCBIN "gfx/settings/screens_bank4d/tilemap_5b6c.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5b6c.attrmap"

; ---- data $5BF8-$5C84 (140 bytes) [CONFIRMED] 14x5 tilemap/attribute pair
; Bank67 table $491C selects this bank4D source; Tilemap_CopyRectAndAttr at 67:4915
; copies 70 tile indices then 70 attribute bytes (BC=$050E; 5 rows x 14 columns).
; All 140 bytes are naturally read in 5/69 scenarios (traces/detail/*/dataaccess.tsv).
; See docs/research/typing_4d_choice_maps.md; no arbitrary cursor-range safety is inferred.

Tilemap_SettingsPhone_ChoiceMenu_Entry2:: ; 4D:5BF8
Tilemap_4D_5BF8::
	INCBIN "gfx/settings/screens_bank4d/tilemap_5bf8.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5bf8.attrmap"

; ---- data $5C84-$5D10 (140 bytes) [CONFIRMED] 14x5 tilemap/attribute pair
; Bank67 table $491C selects this bank4D source; Tilemap_CopyRectAndAttr at 67:4915
; copies 70 tile indices then 70 attribute bytes (BC=$050E; 5 rows x 14 columns).
; All 140 bytes are naturally read in 3/69 scenarios (traces/detail/*/dataaccess.tsv).
; See docs/research/typing_4d_choice_maps.md; no arbitrary cursor-range safety is inferred.

Tilemap_SettingsPhone_ChoiceMenu_Entry3:: ; 4D:5C84
Tilemap_4D_5C84::
	INCBIN "gfx/settings/screens_bank4d/tilemap_5c84.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_5c84.attrmap"

; ---- words $5D10-$5D18 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$5D10 a=$4D at 67:47C6 (entry 0 unused, entry 1 = 5D18/5D3E); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

SettingsPhone_ChoiceMenu_ObjTable:: ; 4D:5D10
Table_4D_5D10::
	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry SettingsPhone_ChoiceMenu_ObjAnimData, SpriteScript_4D_5D3E ; entry 1

; ---- data $5D18-$5D50 (56 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 4D:5D18-5D50 (ends with zero padding to the tile block)

SettingsPhone_ChoiceMenu_ObjAnimData:: ; 4D:5D18
Data_4D_5D18::
	sprite_frame_table SpriteFrame_4D_5D1C, SpriteFrame_4D_5D2D
SpriteFrame_4D_5D1C:: ; 4D:5D1C
	sprite_frame 4
	sprite_oam 0, 0, $00, OAMF_BANK1
	sprite_oam 8, 0, $10, OAMF_BANK1
	sprite_oam 0, 120, $00, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 8, 120, $10, OAMF_XFLIP | OAMF_BANK1
SpriteFrame_4D_5D2D:: ; 4D:5D2D
	sprite_frame 4
	sprite_oam 0, -1, $00, OAMF_BANK1
	sprite_oam 8, -1, $10, OAMF_BANK1
	sprite_oam 0, 121, $00, OAMF_XFLIP | OAMF_BANK1
	sprite_oam 8, 121, $10, OAMF_XFLIP | OAMF_BANK1
SpriteScript_4D_5D3E:: ; 4D:5D3E
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 5
	ds $D, $00

; ---- gfx $5D50-$5D70 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4DBC: hl=$5D50 a=$4D c=$02 de=$8001 (dest VRAM $8000, vbank=1) [first call site executed: 12 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_SlotMenu_Tiles8000Vb1:: ; 4D:5D50
Data_4D_5D50::
	INCBIN "gfx/settings/screens_bank4d/tiles_5d50.2bpp"

; ---- gfx $5D70-$6170 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D2A: hl=$5D70 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 5 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_SlotMenu_Tiles8800Vb1:: ; 4D:5D70
Data_4D_5D70::
	INCBIN "gfx/settings/screens_bank4d/tiles_5d70.2bpp"

; ---- gfx $6170-$6570 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D3C: hl=$6170 a=$4D c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 5 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6170:: ; 4D:6170
Data_4D_6170::
	INCBIN "gfx/settings/screens_bank4d/tiles_6170.2bpp"

; ---- gfx $6570-$6870 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D4E: hl=$6470 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 5 hits in 2 scenarios (analysis/coverage_union.tsv)] [clipped from 6470-6870 by higher-priority evidence]

Data_4D_6570:: ; 4D:6570
	INCBIN "gfx/settings/screens_bank4d/tiles_6570.2bpp"

; ---- gfx $6870-$6C70 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D60: hl=$6870 a=$4D c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 5 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_6870:: ; 4D:6870
Data_4D_6870::
	INCBIN "gfx/settings/screens_bank4d/tiles_6870.2bpp"

; ---- gfx $6C70-$6D70 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D74: hl=$6970 a=$4D c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 7 hits in 2 scenarios (analysis/coverage_union.tsv)] [clipped from 6970-6D70 by higher-priority evidence]

Data_4D_6C70:: ; 4D:6C70
	INCBIN "gfx/settings/screens_bank4d/tiles_6c70.2bpp"

; ---- gfx $6D70-$7170 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D86: hl=$6D70 a=$4D c=$40 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 7 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_SlotMenu_Tiles8C00Vb1_4D_6D70:: ; 4D:6D70
Data_4D_6D70::
	INCBIN "gfx/settings/screens_bank4d/tiles_6d70.2bpp"

; ---- gfx $7170-$7470 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4D98: hl=$7070 a=$4D c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 7 hits in 2 scenarios (analysis/coverage_union.tsv)] [clipped from 7070-7470 by higher-priority evidence]

Data_4D_7170:: ; 4D:7170
	INCBIN "gfx/settings/screens_bank4d/tiles_7170.2bpp"

; ---- gfx $7470-$7570 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:4DAA: hl=$7470 a=$4D c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 7 hits in 2 scenarios (analysis/coverage_union.tsv)]; the last $300 bytes of the old blob hold 2 palettes and a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_SettingsPhone_SlotMenu_Tiles9400Vb1_4D_7470:: ; 4D:7470
Data_4D_7470::
	INCBIN "gfx/settings/screens_bank4d/tiles_7470.2bpp"

; ---- data $7570-$7598 (40 bytes) [PROBABLE] palette-rgb555: 20 colours (5 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/slot_menu.asm:150, call 67:4DCD executed 12 hits in 3 scenarios (analysis/coverage_union.tsv)); the call takes 24 bytes past the end of this block (the palette at $7598 and the first 16 bytes of the tilemap pair at $75A0 are copied into the buffer behind it); the length of 40 bytes is by adjacency, not by the call

Palette_SettingsPhone_SlotMenu_Bg:: ; 4D:7570
	INCLUDE "gfx/settings/screens_bank4d/settings_phone_slot_menu_bg.pal"

; ---- data $7598-$75A0 (8 bytes) [CONFIRMED] palette-rgb555: 4 colours (1 palettes) read by Palette_LoadToBuffer: +$00 bc=$08 into wPaletteBufObj (engine/settings/slot_menu.asm:155, call 67:4DDE executed 12 hits in 3 scenarios (analysis/coverage_union.tsv))

Palette_SettingsPhone_SlotMenu_Obj:: ; 4D:7598
	INCLUDE "gfx/settings/screens_bank4d/settings_phone_slot_menu_obj.pal"

; ---- data $75A0-$7870 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:4DEF: hl=$75A0 a=$4D b=18 rows c=20 cols (tiles then attrs) de=$D000 [call site 67:4DEF executed: 12 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsPhone_SlotMenu_4D_75A0:: ; 4D:75A0
	INCBIN "gfx/settings/screens_bank4d/settings_phone_slot_menu_4d_75a0.tilemap"
	INCBIN "gfx/settings/screens_bank4d/settings_phone_slot_menu_4d_75a0.attrmap"

; ---- data $7870-$78C0 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_SettingsPhone_SlotMenu_Tab0:: ; 4D:7870
Tilemap_4D_7870::
	INCBIN "gfx/settings/screens_bank4d/tilemap_7870.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_7870.attrmap"

; ---- data $78C0-$7910 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_SettingsPhone_SlotMenu_Tab1:: ; 4D:78C0
Tilemap_4D_78C0::
	INCBIN "gfx/settings/screens_bank4d/tilemap_78c0.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_78c0.attrmap"

; ---- data $7910-$7960 (80 bytes) [PROBABLE] 20x2 tilemap: 40 tile indices (2 rows of 20) then 40 attribute bytes (+0x28); dims from `ld bc,$0214` at 67:50E8, the table is indexed by [$C27D] at `ld hl,$5104` (67:50EE) (v4 correction: earlier text said 8x5 and table 67:510B); word of the pointer table at 67:5104 (70 78 c0 78 10 79)

Tilemap_SettingsPhone_SlotMenu_Tab2:: ; 4D:7910
Tilemap_4D_7910::
	INCBIN "gfx/settings/screens_bank4d/tilemap_7910.tilemap"
	INCBIN "gfx/settings/screens_bank4d/tilemap_7910.attrmap"

; ---- words $7960-$7968 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$7960 a=$4D at 67:4E0A (entry 0 unused, entry 1 = 7968/797E); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

SettingsPhone_SlotMenu_ObjTable:: ; 4D:7960
Table_4D_7960::
	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry SettingsPhone_SlotMenu_ObjAnimData, SpriteScript_4D_797E ; entry 1

; ---- data $7968-$7983 (27 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 4D:7968-7983

SettingsPhone_SlotMenu_ObjAnimData:: ; 4D:7968
Data_4D_7968::
	sprite_frame_table SpriteFrame_4D_796C, SpriteFrame_4D_7975
SpriteFrame_4D_796C:: ; 4D:796C
	sprite_frame 2
	sprite_oam 0, 0, $00, OAMF_BANK1
	sprite_oam 0, 8, $01, OAMF_BANK1
SpriteFrame_4D_7975:: ; 4D:7975
	sprite_frame 2
	sprite_oam -1, 0, $00, OAMF_BANK1
	sprite_oam -1, 8, $01, OAMF_BANK1
SpriteScript_4D_797E:: ; 4D:797E
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 5
