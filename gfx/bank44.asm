; gfx/bank44.asm
; bank 44, $4000-$7540 (13632 bytes); pinned by layout.link
; four screen packages; no loader found

SECTION "gfx/bank44", ROMX

; ---- gfx $4000-$4A00 (2560 bytes) [PROBABLE] scene 1: 160 tiles ($A00 bytes); block layout (tiles $A00, tilemap $168, attribute map $168, 16 palette groups $80 = $D50) repeats at 4000/4D50/5AA0/67F0 and the palette signature is identical in all four; tile art coherent; no loader call found. Replaces mapper heuristic gfx/zero/unclassified pieces (blank tiles kept as tile data)

Tiles_44_4000:: ; 44:4000
	INCBIN "gfx/bank44/tiles_4000.2bpp"

; ---- data $4A00-$4B68 (360 bytes) [PROBABLE] scene 1 tilemap 20 x 18 tile indices (all < $80, row width 20): 00:08EA copy_tilemap_rect_pair geometry (b=18 rows, c=20 cols, tiles then attributes = $2D0 bytes); no call site found

Tilemap_44_4A00:: ; 44:4A00
	INCBIN "gfx/bank44/tilemap_4a00.tilemap"

; ---- data $4B68-$4CD0 (360 bytes) [PROBABLE] scene 1 attribute map 20 x 18 (BG attribute bytes $08-$0C measured in this scene: bits 0-2 palette, bit 3 VRAM bank 1, bit 5 x flip; the earlier claim "only $08-$0F/$28-$2F" was wrong for scene 2, which also uses $00/$01); second half of the $2D0 tilemap+attr block, ends exactly at the palette block 4CD0

Data_44_4B68:: ; 44:4B68
	INCBIN "gfx/bank44/attrmap_4b68.attrmap"

; ---- data $4CD0-$4D50 (128 bytes) [PROBABLE] scene 1: 16 CGB palette groups (8 BG + 8 OBJ x 4 RGB555 words, $80 bytes); first group ff7f 011c 7e02 0000 identical in the four scenes

Palette_44_4CD0:: ; 44:4CD0
	INCLUDE "gfx/bank44/palette_4cd0.pal"

; ---- gfx $4D50-$5750 (2560 bytes) [PROBABLE] scene 2: 160 tiles ($A00 bytes); block layout (tiles $A00, tilemap $168, attribute map $168, 16 palette groups $80 = $D50) repeats at 4000/4D50/5AA0/67F0 and the palette signature is identical in all four; tile art coherent; no loader call found. Replaces mapper heuristic gfx/zero/unclassified pieces (blank tiles kept as tile data)

Tiles_44_4D50:: ; 44:4D50
	INCBIN "gfx/bank44/tiles_4d50.2bpp"

; ---- data $5750-$58B8 (360 bytes) [PROBABLE] scene 2 tilemap 20 x 18 tile indices (all < $80, row width 20): 00:08EA copy_tilemap_rect_pair geometry (b=18 rows, c=20 cols, tiles then attributes = $2D0 bytes); no call site found

Tilemap_44_5750:: ; 44:5750
	INCBIN "gfx/bank44/tilemap_5750.tilemap"

; ---- data $58B8-$5A20 (360 bytes) [PROBABLE] scene 2 attribute map 20 x 18 (BG attribute bytes $00,$01,$09-$0C,$29,$2A measured in this scene: bits 0-2 palette, bit 3 VRAM bank 1, bit 5 x flip; the earlier claim "only $08-$0F/$28-$2F" was wrong for scene 2, which also uses $00/$01); second half of the $2D0 tilemap+attr block, ends exactly at the palette block 5A20

Data_44_58B8:: ; 44:58B8
	INCBIN "gfx/bank44/attrmap_58b8.attrmap"

; ---- data $5A20-$5AA0 (128 bytes) [PROBABLE] scene 2: 16 CGB palette groups (8 BG + 8 OBJ x 4 RGB555 words, $80 bytes); first group ff7f 011c 7e02 0000 identical in the four scenes

Palette_44_5A20:: ; 44:5A20
	INCLUDE "gfx/bank44/palette_5a20.pal"

; ---- gfx $5AA0-$64A0 (2560 bytes) [PROBABLE] scene 3: 160 tiles ($A00 bytes); block layout (tiles $A00, tilemap $168, attribute map $168, 16 palette groups $80 = $D50) repeats at 4000/4D50/5AA0/67F0 and the palette signature is identical in all four; tile art coherent; no loader call found. Replaces mapper heuristic gfx/zero/unclassified pieces (blank tiles kept as tile data)

Tiles_44_5AA0:: ; 44:5AA0
	INCBIN "gfx/bank44/tiles_5aa0.2bpp"

; ---- data $64A0-$6608 (360 bytes) [PROBABLE] scene 3 tilemap 20 x 18 tile indices (all < $80, row width 20): 00:08EA copy_tilemap_rect_pair geometry (b=18 rows, c=20 cols, tiles then attributes = $2D0 bytes); no call site found

Tilemap_44_64A0:: ; 44:64A0
	INCBIN "gfx/bank44/tilemap_64a0.tilemap"

; ---- data $6608-$6770 (360 bytes) [PROBABLE] scene 3 attribute map 20 x 18 (BG attribute bytes $08-$0C measured in this scene: bits 0-2 palette, bit 3 VRAM bank 1, bit 5 x flip; the earlier claim "only $08-$0F/$28-$2F" was wrong for scene 2, which also uses $00/$01); second half of the $2D0 tilemap+attr block, ends exactly at the palette block 6770

Data_44_6608:: ; 44:6608
	INCBIN "gfx/bank44/attrmap_6608.attrmap"

; ---- data $6770-$67F0 (128 bytes) [PROBABLE] scene 3: 16 CGB palette groups (8 BG + 8 OBJ x 4 RGB555 words, $80 bytes); first group ff7f 011c 7e02 0000 identical in the four scenes

Palette_44_6770:: ; 44:6770
	INCLUDE "gfx/bank44/palette_6770.pal"

; ---- gfx $67F0-$71F0 (2560 bytes) [PROBABLE] scene 4: 160 tiles ($A00 bytes); block layout (tiles $A00, tilemap $168, attribute map $168, 16 palette groups $80 = $D50) repeats at 4000/4D50/5AA0/67F0 and the palette signature is identical in all four; tile art coherent; no loader call found. Replaces mapper heuristic gfx/zero/unclassified pieces (blank tiles kept as tile data)

Tiles_44_67F0:: ; 44:67F0
	INCBIN "gfx/bank44/tiles_67f0.2bpp"

; ---- data $71F0-$7358 (360 bytes) [PROBABLE] scene 4 tilemap 20 x 18 tile indices (all < $80, row width 20): 00:08EA copy_tilemap_rect_pair geometry (b=18 rows, c=20 cols, tiles then attributes = $2D0 bytes); no call site found

Tilemap_44_71F0:: ; 44:71F0
	INCBIN "gfx/bank44/tilemap_71f0.tilemap"

; ---- data $7358-$74C0 (360 bytes) [PROBABLE] scene 4 attribute map 20 x 18 (BG attribute bytes $09-$0C,$29-$2B measured in this scene: bits 0-2 palette, bit 3 VRAM bank 1, bit 5 x flip; the earlier claim "only $08-$0F/$28-$2F" was wrong for scene 2, which also uses $00/$01); second half of the $2D0 tilemap+attr block, ends exactly at the palette block 74C0

Data_44_7358:: ; 44:7358
	INCBIN "gfx/bank44/attrmap_7358.attrmap"

; ---- data $74C0-$7540 (128 bytes) [PROBABLE] scene 4: 16 CGB palette groups (8 BG + 8 OBJ x 4 RGB555 words, $80 bytes); first group ff7f 011c 7e02 0000 identical in the four scenes

Palette_44_74C0:: ; 44:74C0
	INCLUDE "gfx/bank44/palette_74c0.pal"
