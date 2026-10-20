; gfx/settings/notice_headers_and_phone_confirm_continue_bank4b.asm
; bank 4B, $5B90-$7FE0 (9296 bytes); pinned by layout.link
; Notice header graphics sources and settings phone confirm/continue resources

SECTION "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b", ROMX

; ---- gfx $5B90-$6590 (2560 bytes) [PROBABLE] Four 640-byte sources selected by Notice_LoadHeaderGfx indices $10-$13 through the table at 65:4A81; static copy contract targets VRAM bank 1 at $9300. The prior rendered Japanese text reading is visual analysis; selection in natural execution is not established.

Notice_HeaderGfxSources10To13:: ; 4B:5B90
	INCBIN "gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/notice_page_headers_4b_5b90.2bpp"

; ---- data $6590-$6A90 (1280 bytes) [CONFIRMED] read as data by executed code (in up to 4/18 scenarios); content class unknown at the pixel/tile level: Notice_LoadHeaderGfx statically selects two contiguous 640-byte source windows for indices $14/$15 from 65:4A81 and requests copies to VRAM bank 1 at $9300; raw DB remains

Notice_HeaderGfxSources14To15:: ; 4B:6590
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $18, $42, $5A, $42, $4A, $62, $62
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3C, $3C, $7E, $42, $C2, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $C6, $10, $92, $38, $AA, $38, $28
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $7C, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80
	db $72, $52, $5A, $4A, $4E, $46, $46, $42, $42, $52, $42, $5A, $42, $18, $00, $18
	db $82, $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $01, $00, $83
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $C6, $00, $C6
	db $80, $81, $FC, $FD, $FC, $81, $80, $81, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $82, $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82
	db $E2, $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF
	db $80, $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80
	db $82, $82, $FE, $FE, $FE, $82, $82, $82, $82, $BA, $82, $BA, $82, $38, $00, $38
	db $6C, $44, $6C, $44, $C6, $82, $FE, $FE, $FE, $82, $82, $82, $82, $38, $00, $38
	db $E2, $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38
	db $80, $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $00
	db $E2, $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38
	db $80, $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FE, $00, $FE
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $F8, $F8, $FC, $84, $86, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $F8, $F8, $FC, $84, $86, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $81, $3C, $3C, $7E, $42, $C2, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $C6, $10, $92, $38, $AA, $38, $28
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $7C, $10, $10, $10
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6, $82
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $01, $7C, $7C, $FE, $82, $82, $80
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE
	db $82, $B2, $86, $84, $FC, $F8, $F8, $80, $80, $82, $80, $BE, $80, $3E, $00, $3E
	db $82, $B2, $86, $84, $FC, $F8, $FC, $84, $86, $82, $82, $B2, $82, $38, $00, $38
	db $80, $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00
	db $80, $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80
	db $6C, $44, $6C, $44, $C6, $82, $FE, $FE, $FE, $82, $82, $82, $82, $38, $00, $38
	db $82, $BA, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $01, $00, $83
	db $10, $D7, $10, $D7, $10, $D7, $10, $D7, $10, $D7, $10, $D7, $10, $C7, $00, $C7
	db $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $00
	db $82, $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82
	db $E2, $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38
	db $80, $80, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $01
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
	db $90, $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF
	db $09, $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1

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

; ---- data $76C0-$76D0 (16 bytes) [PROBABLE] 3 x 4-byte entries ($26/$2F, $27/$30, $28/$31 with attributes $09 $09) + a zero entry; the three selected slot-cell records are reached through pointers at 67:53D6 and copied with BC=$0201; the four-byte tail at $76CC-$76CF has no demonstrated consumer or purpose.

SettingsPhone_ConfirmScreen_SlotCellRecords:: ; 4B:76C0
	db $26, $2F, $09, $09, $27, $30, $09, $09, $28, $31, $09, $09, $00, $00, $00, $00

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
