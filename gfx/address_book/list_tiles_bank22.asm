; gfx/address_book/list_tiles_bank22.asm
; bank 22, $5CD0-$66D0 (2560 bytes); pinned by layout.link
; address-book tiles loaded by bank 2F (AbookList/AbookAddr setup)

SECTION "gfx/address_book/list_tiles_bank22", ROMX

; ---- gfx $5CD0-$66D0 (2560 bytes) [CONFIRMED] aligned 160-tile address-book family; four natural Bank2F HDMA source chunks are documented in docs/research/typing_22_address_book_tiles.md; the original 5CEA source boundary is inside tile 1 and is not a standalone sheet

Gfx_AddrBook_TilesBank22:: ; 22:5CD0
	INCBIN "gfx/address_book/list_tiles_bank22/addr_book_tiles_bank22.2bpp"
