; gfx/settings/adapter_check_and_phone_entry_bank4a.asm
; bank 4A, $5F80-$7378 (5112 bytes); pinned by layout.link
; settings screen art (loaded by bank 67)

SECTION "gfx/settings/adapter_check_and_phone_entry_bank4a", ROMX

; ---- gfx $5F80-$6080 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:6385: hl=$5F80 a=$4A c=$10 de=$8000 (dest VRAM $8000, vbank=0)

Gfx_AdapterCheck_Tiles8000:: ; 4A:5F80

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_vram8000_vb0.2bpp"

; ---- gfx $6080-$6480 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:6397: hl=$6080 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1)

Gfx_AdapterCheck_Tiles9000Vb1:: ; 4A:6080

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_vram9000_vb1.2bpp"

; ---- gfx $6480-$6580 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 67:63A9: hl=$6480 a=$4A c=$40 de=$9401 (dest VRAM $9400, vbank=1); the last $300 bytes of the old blob hold 2 palettes and the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

Gfx_AdapterCheck_Tiles9400Vb1:: ; 4A:6480

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_vram9400_vb1_tile_prefix_256.2bpp"

; ---- data $6580-$65C0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/settings/adapter_check.asm:37, call 67:63BA executed 680 hits in 68 scenarios (analysis/coverage_union.tsv))

Palette_AdapterCheck_Bg:: ; 4A:6580
	INCLUDE "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_bg.pal"

; ---- data $65C0-$6600 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/settings/adapter_check.asm:42, call 67:63CB executed 680 hits in 68 scenarios (analysis/coverage_union.tsv))

Palette_AdapterCheck_Obj:: ; 4A:65C0
	INCLUDE "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_obj.pal"

; ---- data $6600-$68D0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:63DC: hl=$6600 a=$4A b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_AdapterCheck_4A_6600:: ; 4A:6600
	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_4a_6600.tilemap"
	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/adapter_check_4a_6600.attrmap"

; ---- data $68D0-$6920 (80 bytes) [PROBABLE] sprite-object container: null entry0; B=$81 selects entry1 (frame list $68D8, script $690C) at 67:63EC; 4 frame pointers, records count 2/2/6/0, 4 script steps; 11 final zero bytes at $6915-$6920 have UNKNOWN purpose (see docs/research/adapter_check_object_data_80b.md)

AdapterCheck_ObjTable:: ; 4A:68D0

	sprite_object_entry 0, 0 ; null entry 0; not a positive caller
	sprite_object_entry AdapterCheck_Anim1Frames, AdapterCheck_Anim1Script ; entry 1, B=$81

AdapterCheck_Anim1Frames:: ; 4A:68D8
	sprite_frame_table AdapterCheck_Anim1Frame0, AdapterCheck_Anim1Frame1, AdapterCheck_Anim1Frame2, AdapterCheck_Anim1Frame3

AdapterCheck_Anim1Frame0:: ; 4A:68E0
	sprite_frame 2
	sprite_oam 5, 12, $00, $00
	sprite_oam 6, 30, $01, $00

AdapterCheck_Anim1Frame1:: ; 4A:68E9
	sprite_frame 2
	sprite_oam 5, 5, $02, $00
	sprite_oam 6, 30, $03, $00

AdapterCheck_Anim1Frame2:: ; 4A:68F2
	sprite_frame 6
	sprite_oam 19, 5, $04, $40
	sprite_oam 19, 13, $05, $40
	sprite_oam 6, 30, $09, $00
	sprite_oam 11, 5, $06, $40
	sprite_oam 11, 13, $07, $40
	sprite_oam 3, 5, $08, $40

AdapterCheck_Anim1Frame3:: ; 4A:690B
	sprite_frame 0

AdapterCheck_Anim1Script:: ; 4A:690C
	sprite_anim 4
	sprite_anim_step 0, 20
	sprite_anim_step 1, 20
	sprite_anim_step 2, 20
	sprite_anim_step 3, 20

	; $6915-$6920: 11 original zero bytes, purpose UNKNOWN; not padding/unused proof.
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $6920-$6D20 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (67:4394 67:4A09); first: hdma_rom_to_vram at 67:4394: hl=$6920 a=$4A c=$40 de=$9001 (dest VRAM $9000, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_PhoneKeypadAndComment_Tiles9000Vb1:: ; 4A:6920

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_and_comment_vram9000_vb1.2bpp"

; ---- gfx $6D20-$7120 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (67:43A6 67:4A1B); first: hdma_rom_to_vram at 67:43A6: hl=$6D20 a=$4A c=$40 de=$9401 (dest VRAM $9400, vbank=1) [first call site executed: 63 hits in 3 scenarios (analysis/coverage_union.tsv)]

Gfx_PhoneKeypadAndComment_Tiles9400Vb1:: ; 4A:6D20

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_and_comment_vram9400_vb1.2bpp"

; ---- data $7120-$71E8 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:43CE: hl=$7120 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 38 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneKeypad_4A_7120:: ; 4A:7120

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_kind0.tilemap"
	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_kind0.attrmap"

; ---- data $71E8-$72B0 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:43E1: hl=$71E8 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 25 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneKeypad_4A_71E8:: ; 4A:71E8

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_kind_nonzero.tilemap"
	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_keypad_kind_nonzero.attrmap"

; ---- data $72B0-$7378 (200 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:4A3D: hl=$72B0 a=$4A b=5 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 13 hits in 3 scenarios (analysis/coverage_union.tsv)]

Tilemap_PhoneComment:: ; 4A:72B0

	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_comment_entry.tilemap"
	INCBIN "gfx/settings/adapter_check_and_phone_entry_bank4a/phone_comment_entry.attrmap"
