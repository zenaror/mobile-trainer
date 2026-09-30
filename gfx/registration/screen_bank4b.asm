; gfx/registration/screen_bank4b.asm
; bank 4B, $4000-$42D0 (720 bytes); pinned by layout.link
; tilemap loaded by bank 65

SECTION "gfx/registration/screen_bank4b", ROMX

; ---- data $4000-$42D0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 65:4913: hl=$4000 a=$4B b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_Notice_4B_4000:: ; 4B:4000
Data_4B_4000::
	INCBIN "gfx/registration/screen_bank4b/tilemap_4000.tilemap"
	INCBIN "gfx/registration/screen_bank4b/tilemap_4000.attrmap"
