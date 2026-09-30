; gfx/address_book/entry_screen_bank2a.asm
; bank 2A, $7CF0-$7E80 (400 bytes); pinned by layout.link
; address-book entry screen tiles stored in bank 2A

SECTION "gfx/address_book/entry_screen_bank2a", ROMX

; ---- gfx $7CF0-$7DD0 (224 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:522C: hl=$7CF0 a=$2A c=$0E de=$8F00 (dest VRAM $8F00, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrBookEntry_Tiles8F00:: ; 2A:7CF0
Data_2A_7CF0::
	INCBIN "gfx/address_book/entry_screen_bank2a/addr_book_entry_tiles8f00.2bpp"

; ---- gfx $7DD0-$7E80 (176 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:523E: hl=$7DD0 a=$2A c=$0B de=$8000 (dest VRAM $8000, vbank=0) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrBookEntry_Tiles8000:: ; 2A:7DD0
Data_2A_7DD0::
	INCBIN "gfx/address_book/entry_screen_bank2a/addr_book_entry_tiles8000.2bpp"
