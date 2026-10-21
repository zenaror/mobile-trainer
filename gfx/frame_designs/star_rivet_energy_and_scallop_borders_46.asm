; gfx/frame_designs/star_rivet_energy_and_scallop_borders_46.asm
; bank 46, $4000-$7540 (13632 bytes); pinned by layout.link
; four candidate frame-design packages; no loader was demonstrated in the reviewed source

SECTION "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 1/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found in the reviewed source; no consumer is demonstrated

FrameDesignCandidate_StarTriangleBorder_Tiles_4000:: ; 46:4000
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/star_triangle_border_46_4000_tiles.2bpp"

; ---- data $4A00-$4CD0 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 1/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_StarTriangleBorder_Tilemap_4A00:: ; 46:4A00
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/star_triangle_border_46_4000_tilemap.tilemap"
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/star_triangle_border_46_4000_attributes.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 1/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_StarTriangleBorder_Palettes_4CD0:: ; 46:4CD0
	INCLUDE "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/star_triangle_border_46_4000_palettes.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 2/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found in the reviewed source; no consumer is demonstrated

FrameDesignCandidate_OrangeRivetPanel_Tiles_4D50:: ; 46:4D50
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/orange_rivet_panel_46_4d50_tiles.2bpp"

; ---- data $5750-$5A20 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 2/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_OrangeRivetPanel_Tilemap_5750:: ; 46:5750
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/orange_rivet_panel_46_4d50_tilemap.tilemap"
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/orange_rivet_panel_46_4d50_attributes.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 2/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_OrangeRivetPanel_Palettes_5A20:: ; 46:5A20
	INCLUDE "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/orange_rivet_panel_46_4d50_palettes.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 3/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found in the reviewed source; no consumer is demonstrated

FrameDesignCandidate_BlueEnergyBorder_Tiles_5AA0:: ; 46:5AA0
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/blue_energy_border_46_5aa0_tiles.2bpp"

; ---- data $64A0-$6770 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 3/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_BlueEnergyBorder_Tilemap_64A0:: ; 46:64A0
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/blue_energy_border_46_5aa0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/blue_energy_border_46_5aa0_attributes.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 3/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_BlueEnergyBorder_Palettes_6770:: ; 46:6770
	INCLUDE "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/blue_energy_border_46_5aa0_palettes.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] 2bpp tile data (160 tiles, incl. blank tiles), screen block 4/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50; visually coherent pixel art in a rendered sheet; no direct loader reference found in the reviewed source; no consumer is demonstrated

FrameDesignCandidate_PinkScallopBorder_Tiles_67F0:: ; 46:67F0
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/pink_scallop_border_46_67f0_tiles.2bpp"

; ---- data $71F0-$74C0 (720 bytes) [PROBABLE] tilemap+attribute map, 20x18 (0x168 tile bytes then 0x168 attr bytes; attr bytes are bank/palette/flip bits, bit 4 (unused on CGB) set in a few bytes), rows of 20 verified in the byte pattern; layout as 00:08EA copy_tilemap_rect_pair screen block 4/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_PinkScallopBorder_Tilemap_71F0:: ; 46:71F0
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/pink_scallop_border_46_67f0_tilemap.tilemap"
	INCBIN "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/pink_scallop_border_46_67f0_attributes.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] 16 RGB555 palettes of 4 colours, first palette ff7f 1c01 027e 0000 as in banks 41-46; screen block 4/4 of bank 46: same layout in banks 41-46, bank 47 shifted by +0x100 (palette signature ff7f 1c01 027e 0000 at block+0xCD0 in every bank); block = 0xA00 tile bytes + 0x2D0 tilemap/attr + 0x80 palettes = 0xD50

FrameDesignCandidate_PinkScallopBorder_Palettes_74C0:: ; 46:74C0
	INCLUDE "gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/pink_scallop_border_46_67f0_palettes.pal"
