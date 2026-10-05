; gfx/address_book/save_confirm.asm
; bank 2A, $75A0-$7CF0 (1872 bytes); pinned by layout.link
; confirmation screen palette, tiles, tilemap

SECTION "gfx/address_book/save_confirm", ROMX

; ---- data $75A0-$75E0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear): loaded by 'ld bc,$0040 ; ld de,$D800 ; ld hl,$75A0 ; ld a,$2A ; far call 4F:4000' at 2A:70C7-70D7; ends where the tiles at 75E0 begin

Palette_AddrSaveConfirm_Bg:: ; 2A:75A0
Palette_2A_75A0::
	INCLUDE "gfx/address_book/save_confirm/addr_save_confirm_bg.pal"

; ---- gfx $75E0-$79E0 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2A:70E4: hl=$75E0 a=$2A c=$40 de=$9301 (dest VRAM $9300, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrSaveConfirm_Tiles9300Vb1:: ; 2A:75E0
Data_2A_75E0::
	INCBIN "gfx/address_book/save_confirm/addr_save_confirm_tiles9300.2bpp"

; ---- gfx $79E0-$7A20 (64 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2A:70F6: hl=$79E0 a=$2A c=$04 de=$9701 (dest VRAM $9700, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Gfx_AddrSaveConfirm_Tiles9700Vb1:: ; 2A:79E0
Data_2A_79E0::
	INCBIN "gfx/address_book/save_confirm/addr_save_confirm_tiles9700.2bpp"

; ---- data $7A20-$7CF0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2A:7107: hl=$7A20 a=$2A b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_AddrSaveConfirm_TilemapAttr:: ; 2A:7A20
Data_2A_7A20::
	INCBIN "gfx/address_book/save_confirm/data_addr_save_confirm_tilemap_attr.tilemap"
	INCBIN "gfx/address_book/save_confirm/data_addr_save_confirm_tilemap_attr.attrmap"
