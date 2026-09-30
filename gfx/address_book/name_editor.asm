; gfx/address_book/name_editor.asm
; bank 2F, $61F0-$6D00 (2832 bytes); pinned by layout.link
; name editor tiles and tilemap

SECTION "gfx/address_book/name_editor", ROMX

; ---- gfx $61F0-$65F0 (1024 bytes) [CONFIRMED] 64 tiles: 00:0749 HDMA load at 2F:5966 (hl=$61F0 a=$2F c=$40 de=$9301, VRAM bank 1 $9300); site executed in coverage_union (verifier re-check); the three loads 61F0/65F0/66F0 are contiguous ($400+$100+$300 = $800 bytes) and end where the map load at 69F0 starts. Absorbs the mapper zero/unclassified pieces inside (blank tiles are tile data) | verifier: upgraded to CONFIRMED, the three load sites 2F:5966/5978/598A and their register setup are instruction starts of analysis/coverage_union.tsv

Gfx_AbookName_Tiles9300:: ; 2F:61F0
Tiles_2F_61F0::
	INCBIN "gfx/address_book/name_editor/tiles_61f0.2bpp"

; ---- gfx $65F0-$66F0 (256 bytes) [CONFIRMED] 16 tiles: 00:0749 HDMA load at 2F:5978 (hl=$65F0 a=$2F c=$10 de=$9701, VRAM bank 1 $9700); site executed in coverage_union (verifier re-check) | verifier: upgraded to CONFIRMED, the three load sites 2F:5966/5978/598A and their register setup are instruction starts of analysis/coverage_union.tsv

Gfx_AbookName_Tiles9700:: ; 2F:65F0
Tiles_2F_65F0::
	INCBIN "gfx/address_book/name_editor/tiles_65f0.2bpp"

; ---- gfx $66F0-$69F0 (768 bytes) [CONFIRMED] 48 tiles: 00:0749 HDMA load at 2F:598A (hl=$66F0 a=$2F c=$30 de=$8800); site executed in coverage_union (verifier re-check); ends where the tilemap load 69F0 starts | verifier: upgraded to CONFIRMED, the three load sites 2F:5966/5978/598A and their register setup are instruction starts of analysis/coverage_union.tsv

Gfx_AbookName_Tiles8800:: ; 2F:66F0
Tiles_2F_66F0::
	INCBIN "gfx/address_book/name_editor/tiles_66f0.2bpp"

; ---- data $69F0-$6CC0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:59CF: hl=$69F0 a=$2F b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_AbookName:: ; 2F:69F0
Data_2F_69F0::
	INCBIN "gfx/address_book/name_editor/abook_name.tilemap"
	INCBIN "gfx/address_book/name_editor/abook_name.attrmap"

; ---- data $6CC0-$6D00 (64 bytes) [CONFIRMED] 64-byte CGB palette block (8 x 4 RGB555 words): FarCall 4F:4000 (bc=$40) to WRAM $D800 at 2F:59BE (ld hl,$6CC0 a=$2F); the tail word 7FFF was mistaken by the mapper for code (rst $38 ; ld a,a) | verifier: upgraded to CONFIRMED, 2F:59B3-59BE (ld bc,$40 ; ld de,$D800 ; ld hl,$6CC0 ; ld a,$2F ; FarCall 4F:4000) is executed (coverage_union)

Palette_AbookName_Bg:: ; 2F:6CC0
Palette_2F_6CC0::
	INCLUDE "gfx/address_book/name_editor/palette_6cc0.pal"
