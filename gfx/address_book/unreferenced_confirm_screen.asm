; gfx/address_book/unreferenced_confirm_screen.asm
; bank 2C, $7740-$7FD0 (2192 bytes); pinned by layout.link
; tiles, tilemap, palettes of that screen and the entry screen art stored in 2C

SECTION "gfx/address_book/unreferenced_confirm_screen", ROMX

; ---- gfx $7740-$7860 (288 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:7499: hl=$7740 a=$2C c=$12 de=$9301 (dest VRAM $9300, vbank=1) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Gfx_AddrScreenUnused_Tiles9300Vb1:: ; 2C:7740
Data_2C_7740::
	INCBIN "gfx/address_book/unreferenced_confirm_screen/tiles_7740.2bpp"

; ---- data $7860-$7B30 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:74CD: hl=$7860 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000 [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Tilemap_AddrScreenUnused_Screen:: ; 2C:7860
Data_2C_7860::
	INCBIN "gfx/address_book/unreferenced_confirm_screen/tilemap_7860.tilemap"
	INCBIN "gfx/address_book/unreferenced_confirm_screen/tilemap_7860.attrmap"

; ---- data $7B30-$7B70 (64 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 40 RGB555 words as 10 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 7B30-7B80 by higher-priority proposals]

Palette_AddrScreenUnused_Bg:: ; 2C:7B30
Data_2C_7B30::
	INCLUDE "gfx/address_book/unreferenced_confirm_screen/palette_7b30.pal"

; ---- gfx $7B70-$7C00 (144 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:74AB: hl=$7B70 a=$2C c=$09 de=$8000 (dest VRAM $8000, vbank=0) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Gfx_AddrScreenUnused_Tiles8000:: ; 2C:7B70
Data_2C_7B70::
	INCBIN "gfx/address_book/unreferenced_confirm_screen/tiles_7b70.2bpp"

; ---- data $7C00-$7C40 (64 bytes) [PROBABLE] 64-byte CGB palette block (8 x 4 RGB555 words): FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2C:74DE

Palette_AddrScreenUnused_Obj:: ; 2C:7C00
Palette_2C_7C00::
	INCLUDE "gfx/address_book/unreferenced_confirm_screen/palette_7c00.pal"

; ---- ptrtable $7C40-$7C50 (16 bytes) [PROBABLE] 8 words, all inside $7C50-$7C80 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (init_object_from_table: reads the 4-byte entry number B&$7F of the table at DE); each 16-byte table = 4 identical-pair entries; caller 2C:74E7 ld de,$7C40 (a=$2C b=$81)

Table_AddrScreenUnused_Objects:: ; 2C:7C40
Table_2C_7C40::
	sprite_object_entry AddrScreenUnused_ObjAnimData, SpriteScript_2C_7C77 ; entry 0
	sprite_object_entry AddrScreenUnused_ObjAnimData, SpriteScript_2C_7C77 ; entry 1
	sprite_object_entry AddrScreenUnused_ObjAnimData, SpriteScript_2C_7C77 ; entry 2
	sprite_object_entry AddrScreenUnused_ObjAnimData, SpriteScript_2C_7C77 ; entry 3

; ---- data $7C50-$7C80 (48 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; target of the 7C40 table (7C50, 7C77)

AddrScreenUnused_ObjAnimData:: ; 2C:7C50
Data_2C_7C50::
	sprite_frame_table SpriteFrame_2C_7C52
SpriteFrame_2C_7C52:: ; 2C:7C52
	sprite_frame 9
	sprite_oam 0, 0, $00, OAMF_BANK1 | 2
	sprite_oam 0, 8, $01, OAMF_BANK1 | 2
	sprite_oam 0, 16, $02, OAMF_BANK1 | 2
	sprite_oam 8, 0, $03, OAMF_BANK1 | 2
	sprite_oam 8, 8, $04, OAMF_BANK1 | 2
	sprite_oam 8, 16, $05, OAMF_BANK1 | 2
	sprite_oam 16, 0, $06, OAMF_BANK1 | 2
	sprite_oam 16, 8, $07, OAMF_BANK1 | 2
	sprite_oam 16, 16, $08, OAMF_BANK1 | 2
SpriteScript_2C_7C77:: ; 2C:7C77
	sprite_anim 1
	sprite_anim_step 0, 4
	db $00, $00, $00, $00, $00, $00

; ---- data $7C80-$7F50 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2F:524F: hl=$7C80 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

Data_AddrBookEntry_TilemapAttr:: ; 2C:7C80
Data_2C_7C80::
	INCBIN "gfx/address_book/unreferenced_confirm_screen/data_addr_book_entry_tilemap_attr.tilemap"
	INCBIN "gfx/address_book/unreferenced_confirm_screen/data_addr_book_entry_tilemap_attr.attrmap"

; ---- data $7F50-$7F90 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D800 at 2F:51F6 (ld hl,$7F50 a=$2C) | verifier: upgraded to CONFIRMED, the load site 2F:51EE-51F6 (ld bc,$40 ; ld de,$D800 ; ld hl,$7F50 ; ld a,$2C ; FarCall 4F:4000) is executed (coverage_union)

Palette_AddrBookEntry_Bg:: ; 2C:7F50
Palette_2C_7F50::
	INCLUDE "gfx/address_book/unreferenced_confirm_screen/addr_book_entry_bg.pal"

; ---- data $7F90-$7FD0 (64 bytes) [CONFIRMED] 64-byte CGB palette block: FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2F:51E5 (ld hl,$7F90 a=$2C) | verifier: upgraded to CONFIRMED, the load site 2F:51DA-51E5 (ld bc,$40 ; ld de,$D840 ; ld hl,$7F90 ; ld a,$2C ; FarCall 4F:4000) is executed (coverage_union)

Palette_AddrBookEntry_Obj:: ; 2C:7F90
Palette_2C_7F90::
	INCLUDE "gfx/address_book/unreferenced_confirm_screen/addr_book_entry_obj.pal"
