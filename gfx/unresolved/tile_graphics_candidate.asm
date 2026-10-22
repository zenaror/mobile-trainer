; gfx/unresolved/tile_graphics_candidate.asm
; bank 7F, $7830-$7B00 (720 bytes); extent is fixed by layout.link.
; No symbolic reference or load address for $7830 was found in the reviewed source.
; The image alone does not establish its intended consumer or role.

SECTION "gfx/unresolved/tile_graphics_candidate", ROMX

; 45 tiles, 2bpp. Preserve the address-bearing label; the role remains unresolved.
UnresolvedTiles_7F_7830:: ; 7F:7830
	INCBIN "gfx/unresolved/tile_graphics_candidate/tiles_candidate.2bpp"
