; gfx/frame_designs/ice_spike_curve_and_gold_borders_45.asm
; bank 45, $4000-$7540 (13632 bytes); pinned by layout.link
; four candidate frame-design packages; no loader was demonstrated in the reviewed source

SECTION "gfx/frame_designs/ice_spike_curve_and_gold_borders_45", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] picture 0: 160 x 2bpp tiles (0xA00 bytes); bank 45 = 4 identical-layout full-screen pictures at stride 0xD50 = tiles 0xA00 + tilemap/attr 0x2D0 + 16 palettes 0x80 (tile art visually coherent, blank tiles = zero runs); no executed reader in traces (bank 45 never read)

FrameDesignCandidate_IceCrystalBorder_Tiles_4000:: ; 45:4000
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/ice_crystal_border_45_4000_tiles.2bpp"

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] picture 0: 20x18 tile indices (0x168) + 20x18 attributes (0x168) (layout of copy_tilemap_rect_pair, cf. 28:4550); bytes match: index runs then attr bytes 0x09/0x0C/..

FrameDesignCandidate_IceCrystalBorder_Tilemap_4A00:: ; 45:4A00
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/ice_crystal_border_45_4000_tilemap.tilemap"
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/ice_crystal_border_45_4000_attributes.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] picture 0: 16 CGB palettes x 4 RGB555 words, bit15 clear in all 64 words, first palette 7FFF 011C 7E02 0000 identical in all 4 pictures

FrameDesignCandidate_IceCrystalBorder_Palettes_4CD0:: ; 45:4CD0
	INCLUDE "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/ice_crystal_border_45_4000_palettes.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] picture 1: 160 x 2bpp tiles (0xA00 bytes); bank 45 = 4 identical-layout full-screen pictures at stride 0xD50 = tiles 0xA00 + tilemap/attr 0x2D0 + 16 palettes 0x80 (tile art visually coherent, blank tiles = zero runs); no executed reader in traces (bank 45 never read)

FrameDesignCandidate_VioletSpikeBorder_Tiles_4D50:: ; 45:4D50
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/violet_spike_border_45_4d50_tiles.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] picture 1: 20x18 tile indices (0x168) + 20x18 attributes (0x168) (layout of copy_tilemap_rect_pair, cf. 28:4550); bytes match: index runs then attr bytes 0x09/0x0C/..

FrameDesignCandidate_VioletSpikeBorder_Tilemap_5750:: ; 45:5750
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/violet_spike_border_45_4d50_tilemap.tilemap"
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/violet_spike_border_45_4d50_attributes.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] picture 1: 16 CGB palettes x 4 RGB555 words, bit15 clear in all 64 words, first palette 7FFF 011C 7E02 0000 identical in all 4 pictures

FrameDesignCandidate_VioletSpikeBorder_Palettes_5A20:: ; 45:5A20
	INCLUDE "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/violet_spike_border_45_4d50_palettes.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] picture 2: 160 x 2bpp tiles (0xA00 bytes); bank 45 = 4 identical-layout full-screen pictures at stride 0xD50 = tiles 0xA00 + tilemap/attr 0x2D0 + 16 palettes 0x80 (tile art visually coherent, blank tiles = zero runs); no executed reader in traces (bank 45 never read)

FrameDesignCandidate_RedCurvedBorder_Tiles_5AA0:: ; 45:5AA0
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/red_curved_border_45_5aa0_tiles.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] picture 2: 20x18 tile indices (0x168) + 20x18 attributes (0x168) (layout of copy_tilemap_rect_pair, cf. 28:4550); bytes match: index runs then attr bytes 0x09/0x0C/..

FrameDesignCandidate_RedCurvedBorder_Tilemap_64A0:: ; 45:64A0
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/red_curved_border_45_5aa0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/red_curved_border_45_5aa0_attributes.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] picture 2: 16 CGB palettes x 4 RGB555 words, bit15 clear in all 64 words, first palette 7FFF 011C 7E02 0000 identical in all 4 pictures

FrameDesignCandidate_RedCurvedBorder_Palettes_6770:: ; 45:6770
	INCLUDE "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/red_curved_border_45_5aa0_palettes.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] picture 3: 160 x 2bpp tiles (0xA00 bytes); bank 45 = 4 identical-layout full-screen pictures at stride 0xD50 = tiles 0xA00 + tilemap/attr 0x2D0 + 16 palettes 0x80 (tile art visually coherent, blank tiles = zero runs); no executed reader in traces (bank 45 never read)

FrameDesignCandidate_GoldGeometricBorder_Tiles_67F0:: ; 45:67F0
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/gold_geometric_border_45_67f0_tiles.2bpp"

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] picture 3: 20x18 tile indices (0x168) + 20x18 attributes (0x168) (layout of copy_tilemap_rect_pair, cf. 28:4550); bytes match: index runs then attr bytes 0x09/0x0C/..

FrameDesignCandidate_GoldGeometricBorder_Tilemap_71F0:: ; 45:71F0
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/gold_geometric_border_45_67f0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/gold_geometric_border_45_67f0_attributes.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] picture 3: 16 CGB palettes x 4 RGB555 words, bit15 clear in all 64 words, first palette 7FFF 011C 7E02 0000 identical in all 4 pictures

FrameDesignCandidate_GoldGeometricBorder_Palettes_74C0:: ; 45:74C0
	INCLUDE "gfx/frame_designs/ice_spike_curve_and_gold_borders_45/gold_geometric_border_45_67f0_palettes.pal"
