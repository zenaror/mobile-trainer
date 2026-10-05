; gfx/address_book/entry_screen_bank29.asm
; bank 29, $5B10-$6290 (1920 bytes); pinned by layout.link
; tiles and palette loaded by bank 2F (5B10/5E10/5E50/6250)

SECTION "gfx/address_book/entry_screen_bank29", ROMX

; ---- gfx $5B10-$5E10 (768 bytes) [CONFIRMED] 48 tiles (768 bytes): HDMA 'ld de,$8000 ; ld hl,$5B10 ; ld a,$29 ; ld c,$30 ; call FarCall -> 00:0749' at 2F:5990-59A1 (executed reads cover 5B10-5E50 in traces); verifier: was clipped at 5E0C, 4 bytes short of the loaded block

Gfx_AbookEdit_Tiles8000:: ; 29:5B10
Data_29_5B10::
	INCBIN "gfx/address_book/entry_screen_bank29/tiles_5b10.2bpp"

; ---- data $5E10-$5E50 (64 bytes) [CONFIRMED] 64 bytes = 32 RGB555 words (bit15 clear): loaded by 'ld bc,$0040 ; ld de,$D840 ; ld hl,$5E10 ; ld a,$29 ; far call 4F:4000' at 2F:59A2-59B2; executed reads of 5E10-5E50 in traces (dataaccess rom_read 29 5B10-5E50); verifier: the old split 5E0C-5E4C/5E4C-5E50 was 4 bytes early

Palette_AbookEdit_Obj:: ; 29:5E10
Palette_29_5E10::
	INCLUDE "gfx/address_book/entry_screen_bank29/palette_5e10.pal"

; ---- gfx $5E50-$6250 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:5208: hl=$5E50 a=$29 c=$40 de=$9301 (dest VRAM $9300, vbank=1) [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_AbookView_Tiles9300Vb1:: ; 29:5E50
Data_29_5E50::
	INCBIN "gfx/address_book/entry_screen_bank29/tiles_5e50.2bpp"

; ---- gfx $6250-$6290 (64 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2F:521A: hl=$6250 a=$29 c=$04 de=$9701 (dest VRAM $9700, vbank=1) [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_AbookView_Tiles9700Vb1:: ; 29:6250
Data_29_6250::
	INCBIN "gfx/address_book/entry_screen_bank29/tiles_6250.2bpp"
