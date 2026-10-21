; gfx/frame_designs/foliage_ribbon_and_beveled_panels_41.asm
; bank 41, $4000-$7540 (13632 bytes); pinned by layout.link
; four candidate frame-design packages (160 tiles + 20x18 tilemap/attr map + palettes); no loader was demonstrated in the reviewed source

SECTION "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 0; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

FrameDesignCandidate_LeafVineBorder_Tiles_4000:: ; 41:4000
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/leaf_vine_border_41_4000_tiles.2bpp"

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $09-$0C; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 0; row stride 20 verified by the repeating column pattern

FrameDesignCandidate_LeafVineBorder_Tilemap_4A00:: ; 41:4A00
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/leaf_vine_border_41_4000_tilemap.tilemap"
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/leaf_vine_border_41_4000_attributes.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 0

FrameDesignCandidate_LeafVineBorder_Palettes_4CD0:: ; 41:4CD0
	INCLUDE "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/leaf_vine_border_41_4000_palettes.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 1; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

FrameDesignCandidate_LavenderRibbonBorder_Tiles_4D50:: ; 41:4D50
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/lavender_ribbon_border_41_4d50_tiles.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $08-$0C; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 1; row stride 20 verified by the repeating column pattern

FrameDesignCandidate_LavenderRibbonBorder_Tilemap_5750:: ; 41:5750
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/lavender_ribbon_border_41_4d50_tilemap.tilemap"
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/lavender_ribbon_border_41_4d50_attributes.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 1

FrameDesignCandidate_LavenderRibbonBorder_Palettes_5A20:: ; 41:5A20
	INCLUDE "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/lavender_ribbon_border_41_4d50_palettes.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 2; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

FrameDesignCandidate_GreenBeveledPanel_Tiles_5AA0:: ; 41:5AA0
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/green_beveled_panel_41_5aa0_tiles.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $09,$0A,$0B,$10; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 2; row stride 20 verified by the repeating column pattern

FrameDesignCandidate_GreenBeveledPanel_Tilemap_64A0:: ; 41:64A0
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/green_beveled_panel_41_5aa0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/green_beveled_panel_41_5aa0_attributes.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 2

FrameDesignCandidate_GreenBeveledPanel_Palettes_6770:: ; 41:6770
	INCLUDE "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/green_beveled_panel_41_5aa0_palettes.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] 160 x 2bpp tiles of screen record 3; visually verified as tile art (rendered 2bpp sheet: frames, digits, glyphs); blank ($00) and solid ($FF) tiles are part of the set. bank 41 = 4 identical-layout screen records of $D50 bytes each (4000+4*$D50 = 7540 = start of the zero tail): 160 tiles ($A00) + 20x18 tilemap + 20x18 attribute map ($2D0 total, same shape as the 85 CONFIRMED copy_tilemap_rect_pair blocks elsewhere, e.g. 1A:47B5) + 16 CGB palettes ($80). No code references bank 41 (never executed in the 18 traces), so the kind rests on content and exact tiling

FrameDesignCandidate_OrangeBeveledPanel_Tiles_67F0:: ; 41:67F0
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/orange_beveled_panel_41_67f0_tiles.2bpp"

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] 20x18 tile-index map ($168) followed by the 20x18 attribute map ($168; values actually present: $00,$09,$0A,$0B,$2A; a CGB BG-attribute-like layout is assumed, not verified since nothing loads this bank) of screen record 3; row stride 20 verified by the repeating column pattern

FrameDesignCandidate_OrangeBeveledPanel_Tilemap_71F0:: ; 41:71F0
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/orange_beveled_panel_41_67f0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/orange_beveled_panel_41_67f0_attributes.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] 16 CGB palettes x 4 RGB555 words (bit15 clear, palettes like 0000 294A 56B5 7FFF) of screen record 3

FrameDesignCandidate_OrangeBeveledPanel_Palettes_74C0:: ; 41:74C0
	INCLUDE "gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/orange_beveled_panel_41_67f0_palettes.pal"
