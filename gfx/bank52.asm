; gfx/bank52.asm
; bank 52, $4000-$4C00 (3072 bytes); pinned by layout.link
; 184 text-image tiles (only reference: bank 7F unreferenced prototype)

SECTION "gfx/bank52", ROMX

; ---- zero $4000-$4080 (128 bytes) [PROBABLE] 0x80 bytes of zero (8 blank tiles / padding) before the tile block
	ds $80, $00

; ---- gfx $4080-$4C00 (2944 bytes) [PROBABLE] 184 x 2bpp tiles at 16-byte alignment (4080-4C00 ends exactly where the zero padding starts): rows are (ff,xx) byte pairs = 2bpp text-image tiles; rendered, they show Japanese UI text (e.g. ボールをえらんでください, メモリーボール); the mapper heuristic used parity 1 (4071) which splits every row pair; no reference to this block found

Gfx_PageListProto_Tiles9580Vb1:: ; 52:4080
Tiles_52_4080::
	INCBIN "gfx/bank52/tiles_4080.2bpp"
