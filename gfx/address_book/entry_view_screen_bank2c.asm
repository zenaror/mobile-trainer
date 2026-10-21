; gfx/address_book/entry_view_screen_bank2c.asm
; bank 2C, $7C80-$7FD0 (848 bytes); pinned by layout.link.
; CONFIRMED address-book entry-view tilemap/attributes and palettes read by AbookView_SetupScreen.

SECTION "gfx/address_book/entry_view_screen_bank2c", ROMX

; ---- data $7C80-$7F50 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:524F: hl=$7C80 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

Data_AddrBookEntry_TilemapAttr:: ; 2C:7C80
	INCBIN "gfx/address_book/entry_view_screen_bank2c/data_addr_book_entry_tilemap_attr.tilemap"
	INCBIN "gfx/address_book/entry_view_screen_bank2c/data_addr_book_entry_tilemap_attr.attrmap"

; ---- data $7F50-$7F90 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D800 at 2F:51F6 (ld hl,$7F50 a=$2C) | verifier: upgraded to CONFIRMED, the load site 2F:51EE-51F6 (ld bc,$40 ; ld de,$D800 ; ld hl,$7F50 ; ld a,$2C ; FarCall 4F:4000) is executed (coverage_union)

Palette_AddrBookEntry_Bg:: ; 2C:7F50
	INCLUDE "gfx/address_book/entry_view_screen_bank2c/addr_book_entry_bg.pal"

; ---- data $7F90-$7FD0 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2F:51E5 (ld hl,$7F90 a=$2C) | verifier: upgraded to CONFIRMED, the load site 2F:51DA-51E5 (ld bc,$40 ; ld de,$D840 ; ld hl,$7F90 ; ld a,$2C ; FarCall 4F:4000) is executed (coverage_union)

Palette_AddrBookEntry_Obj:: ; 2C:7F90
	INCLUDE "gfx/address_book/entry_view_screen_bank2c/addr_book_entry_obj.pal"
