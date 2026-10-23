; gfx/settings/notice_headers_and_phone_confirm_continue_bank4b.asm
; bank 4B, $5B90-$7FE0 (9296 bytes); pinned by layout.link
; Notice header graphics sources and settings phone confirm/continue resources

SECTION "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b", ROMX

; ---- gfx $5B90-$6590 (2560 bytes) [PROBABLE] Four 640-byte sources selected by Notice_LoadHeaderGfx indices $10-$13 through the table at 65:4A81; static copy contract targets VRAM bank 1 at $9300. The prior rendered Japanese text reading is visual analysis; selection in natural execution is not established.

Notice_HeaderGfxSources10To13:: ; 4B:5B90
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/notice_page_headers_4b_5b90.2bpp"

; ---- gfx $6590-$6810 (640 bytes) [CONFIRMED] 2bpp tiles: descriptor $14 at 65:4A81 selects
; 4B:$6590; Notice_LoadHeaderGfx requests $28 blocks to VRAM bank 1 at $9300. Decoded 10x4
; tiles form Japanese notice-header artwork; natural selection remains unestablished.

Notice_HeaderGfxSourceDescriptor14_6590:: ; 4B:6590
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/notice_header_gfx_source_descriptor14_6590.2bpp"

; ---- gfx $6810-$6A90 (640 bytes) [CONFIRMED] 2bpp tiles: descriptor $15 at 65:4A81 selects
; 4B:$6810; Notice_LoadHeaderGfx requests $28 blocks to VRAM bank 1 at $9300. Decoded 10x4
; tiles form Japanese notice-header artwork; natural selection remains unestablished.

Notice_HeaderGfxSourceDescriptor15_6810:: ; 4B:6810
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/notice_header_gfx_source_descriptor15_6810.2bpp"

; ---- gfx $6A90-$6E90 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:514E: hl=$6A90 a=$4B c=$40 de=$8801 (dest VRAM $8800, vbank=1) [first call site executed: 4 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ConfirmScreen_Tiles8800Vb1:: ; 4B:6A90

	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/phone_confirm_vram8800_vb1.2bpp"

; ---- gfx $6E90-$70B0 (544 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:5160: hl=$6E90 a=$4B c=$22 de=$8C01 (dest VRAM $8C00, vbank=1) [first call site executed: 4 hits in 2 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ConfirmScreen_Tiles8C00Vb1:: ; 4B:6E90

	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/phone_confirm_vram8c00_vb1.2bpp"

; ---- gfx $70B0-$73B0 (768 bytes) [CONFIRMED] tile slice at source offset +$20 within the $400-byte HDMA request from 4B:$7090 to VRAM bank 1:$9000; this slice maps to VRAM $9020-$9320. The encompassing request also crosses following palette/tilemap data; no exclusive-asset claim.

Gfx_SettingsPhone_ConfirmScreen_TileSlice9020Vb1:: ; 4B:70B0
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/phone_confirm_vram9020_vb1_tile_slice_768.2bpp"

; ---- data $73B0-$73F0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/confirm_screen.asm:57, call 67:5195 executed 4 hits in 2 scenarios (analysis/coverage_union.tsv))

Palette_SettingsPhone_ConfirmScreen_Bg:: ; 4B:73B0
	INCLUDE "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_confirm_screen_bg.pal"

; ---- data $73F0-$76C0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:51B7: hl=$73F0 a=$4B b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 4 hits in 2 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsPhone_ConfirmScreen_4B_73F0:: ; 4B:73F0
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_confirm_screen_4b_73f0.tilemap"
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_confirm_screen_4b_73f0.attrmap"

; ---- data $76C0-$76D0 (16 bytes) [PROBABLE] 3 selected 4-byte slot-cell records ($26/$2F, $27/$30, $28/$31 with attributes $09 $09) followed by a 4-byte all-zero record; the table at 67:53D6 selects the first three, which are copied with BC=$0201. No use or purpose is established for the zero record.

SettingsPhone_ConfirmScreen_SlotCellRecords:: ; 4B:76C0
	db $26, $2F, $09, $09
SettingsPhone_ConfirmScreen_SlotCellRecord1:: ; 4B:76C4
	db $27, $30, $09, $09
SettingsPhone_ConfirmScreen_SlotCellRecord2:: ; 4B:76C8
	db $28, $31, $09, $09
SettingsPhone_ConfirmScreen_ZeroSlotCellRecord:: ; 4B:76CC
	db $00, $00, $00, $00

; ---- gfx $76D0-$7AD0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:574D: hl=$76D0 a=$4B c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 2 hits in 1 scenarios (analysis/coverage_union.tsv)]

Gfx_SettingsPhone_ContinuePrompt_Tiles9000Vb1:: ; 4B:76D0

	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/phone_continue_prompt_vram9000_vb1.2bpp"

; ---- gfx $7AD0-$7CD0 (512 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:575F: hl=$7AD0 a=$4B c=$30 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 2 hits in 1 scenarios (analysis/coverage_union.tsv)]; the last $100 bytes of the old blob hold a palette and the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_SettingsPhone_ContinuePrompt_Tiles9400Vb1:: ; 4B:7AD0
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/phone_continue_prompt_vram9400_vb1_tile_prefix_512.2bpp"

; ---- data $7CD0-$7D10 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/continue_prompt.asm:50, call 67:5782 executed 2 hits in 1 scenarios (analysis/coverage_union.tsv))

Palette_SettingsPhone_ContinuePrompt_Bg:: ; 4B:7CD0
	INCLUDE "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_continue_prompt_bg.pal"

; ---- data $7D10-$7FE0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:57A4: hl=$7D10 a=$4B b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 2 hits in 1 scenarios (analysis/coverage_union.tsv)]

Tilemap_SettingsPhone_ContinuePrompt_4B_7D10:: ; 4B:7D10
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_continue_prompt_4b_7d10.tilemap"
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/settings_phone_continue_prompt_4b_7d10.attrmap"
