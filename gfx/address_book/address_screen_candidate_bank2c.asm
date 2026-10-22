; gfx/address_book/address_screen_candidate_bank2c.asm
; bank 2C, $7740-$7C80 (1344 bytes); pinned by layout.link
; candidate address-screen resources; role remains HYPOTHESIS.

SECTION "gfx/address_book/address_screen_candidate_bank2c", ROMX

; ---- gfx $7740-$7860 (288 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:7499: hl=$7740 a=$2C c=$12 de=$9301 (dest VRAM $9300, vbank=1) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Gfx_AddrScreenCandidate_Tiles9300Vb1:: ; 2C:7740
	INCBIN "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_vram9300_vb1_tiles.2bpp"

; ---- data $7860-$7B30 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2C:74CD: hl=$7860 a=$2C b=18 rows c=20 cols (tiles then attrs) de=$D000 [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Tilemap_AddrScreenCandidate_Screen:: ; 2C:7860
	INCBIN "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_tilemap_20x18.tilemap"
	INCBIN "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_attrmap_20x18.attrmap"

; ---- data $7B30-$7B70 (64 bytes) [PROBABLE] CGB palette data (RGB555 words): heuristic: 40 RGB555 words as 10 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) [clipped from 7B30-7B80 by higher-priority proposals]

Palette_AddrScreenCandidate_Bg:: ; 2C:7B30
	INCLUDE "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_bg_palette.pal"

; ---- gfx $7B70-$7C00 (144 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 2C:74AB: hl=$7B70 a=$2C c=$09 de=$8000 (dest VRAM $8000, vbank=0) [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv); executed only by the forced run forced_dead (traces/forced/, not natural evidence)]

Gfx_AddrScreenCandidate_Tiles8000:: ; 2C:7B70
	INCBIN "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_vram8000_tiles.2bpp"

; ---- data $7C00-$7C40 (64 bytes) [PROBABLE] 64-byte CGB palette block (8 x 4 RGB555 words): FarCall 4F:4000 (bc=$40) to WRAM $D840 at 2C:74DE

Palette_AddrScreenCandidate_Obj:: ; 2C:7C00
	INCLUDE "gfx/address_book/address_screen_candidate_bank2c/address_screen_candidate_obj_palette.pal"

; ---- ptrtable $7C40-$7C50 (16 bytes) [PROBABLE] 8 words, all inside $7C50-$7C80 of the same bank (animation/OAM frame data); tables of 4-byte entries (2 words) addressed by ld de,imm before FarCall 00:0A82 (Sprite_LoadObjectEntry (00:0AB8) selects DE + 4*(B&$3F); bit 7 of the original id separately controls repeat behavior); each 16-byte table = 4 identical-pair entries; caller 2C:74E7 ld de,$7C40 (a=$2C b=$81)

Table_AddrScreenCandidate_Objects:: ; 2C:7C40
	sprite_object_entry AddrScreenCandidate_ObjAnimData, SpriteScript_AddrScreenCandidate_ObjectEntry00 ; entry 0
	sprite_object_entry AddrScreenCandidate_ObjAnimData, SpriteScript_AddrScreenCandidate_ObjectEntry00 ; entry 1
	sprite_object_entry AddrScreenCandidate_ObjAnimData, SpriteScript_AddrScreenCandidate_ObjectEntry00 ; entry 2
	sprite_object_entry AddrScreenCandidate_ObjAnimData, SpriteScript_AddrScreenCandidate_ObjectEntry00 ; entry 3

; ---- data $7C50-$7C80 (48 bytes) [PROBABLE] object animation frame records: [count][count x 4 bytes (y,x,tile,attr)] ... chained by pointer lists and terminated by 01 00 04/08 groups; format not fully decoded; reached through the pointer tables; target of the 7C40 table (7C50, 7C77)

AddrScreenCandidate_ObjAnimData:: ; 2C:7C50
	sprite_frame_table SpriteFrame_AddrScreenCandidate_ObjectEntry00_Frame00
SpriteFrame_AddrScreenCandidate_ObjectEntry00_Frame00:: ; 2C:7C52
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
SpriteScript_AddrScreenCandidate_ObjectEntry00:: ; 2C:7C77
	sprite_anim 1
	sprite_anim_step 0, 4
	db $00, $00, $00, $00, $00, $00
