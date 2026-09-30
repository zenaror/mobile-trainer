; gfx/browser/start_choice.asm
; bank 73, $4097-$5F17 (7808 bytes); pinned by layout.link
; browser start choice screen maps, tiles, palettes, object table

SECTION "gfx/browser/start_choice", ROMX

; ---- data $4097-$4367 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 73:5FC8: hl=$4097 a=$73 b=18 rows c=20 cols (tiles then attrs) de=$D000

BrowserStart_Map:: ; 73:4097
Data_73_4097::
	INCBIN "gfx/browser/start_choice/browser_start_map.tilemap"
	INCBIN "gfx/browser/start_choice/browser_start_map.attrmap"

; ---- data $4367-$438F (40 bytes) [PROBABLE] tile-index rectangle 4 rows x 10 columns (40 bytes): 73:6230 ld bc,$040A ; ld de,$D089 ; ld hl,$4367 ; ld a,$73 ; FarCall 00:16A2 (rect copy from ROM bank a to WRAM)

BrowserStart_TopMapNormal:: ; 73:4367
Tilemap_73_4367::
	INCBIN "gfx/browser/start_choice/browser_start_top_map_normal.tilemap"

; ---- data $438F-$43AD (30 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserStart_BottomMapNormal:: ; 73:438F
Data_73_438F::
	db $0A, $30, $31, $31, $31, $31, $31, $31, $30, $0A, $0A, $2F, $35, $36, $37, $38
	db $39, $3A, $34, $0A, $0A, $33, $32, $32, $32, $32, $32, $32, $33, $0A

; ---- data $43AD-$43D5 (40 bytes) [PROBABLE] 40 bytes of BG attribute values (all $09): same 4 x 10 geometry as the tilemap at 4367; attribute source pointer: 73:6220 (ld a,$AD ; ld [$C10E],a ; ld a,$43 ; ld [$C10F],a) sets $C10E/$C10F = $43AD right before the FarCall 00:16A2 rect copy of the tilemap at 4367 (00:16A2 reads [$C10E/$C10F] as the source of its second copy, dest +$0400); the site is static-reached, not executed (verifier: earlier note said "no direct reference")

BrowserStart_TopAttrNormal:: ; 73:43AD
Data_73_43AD::
	INCBIN "gfx/browser/start_choice/browser_start_top_attr_normal.attrmap"

; ---- data $43D5-$441B (70 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserStart_BottomAttrNormal:: ; 73:43D5
Data_73_43D5::
	db $09, $09, $09, $09, $09, $09, $09, $09, $29, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $29, $09, $09, $09, $09, $09, $09, $09, $09

BrowserStart_TopMapSelected:: ; 73:43F3
	db $0D, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0D, $1D, $5B, $5C, $5D, $5E, $5F
	db $60, $61, $62, $1D, $2D, $63, $64, $65, $66, $67, $68, $69, $6A, $2D, $0F, $1E
	db $1E, $1E, $1E, $1E, $1E, $1E, $1E, $0F

; ---- data $441B-$4439 (30 bytes) [PROBABLE] tile-index rectangle 3 rows x 10 columns (30 bytes): 73:624B ld bc,$030A ; ld de,$D129 ; ld hl,$441B ; ld a,$73 ; FarCall 00:16A2

BrowserStart_BottomMapSelected:: ; 73:441B
Tilemap_73_441B::
	INCBIN "gfx/browser/start_choice/browser_start_bottom_map_selected.tilemap"

; ---- data $4439-$4461 (40 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown

BrowserStart_TopAttrSelected:: ; 73:4439
Data_73_4439::
	db $09, $09, $09, $09, $09, $09, $09, $09, $09, $29, $09, $0A, $0A, $0A, $0A, $0A
	db $0A, $0A, $0A, $29, $09, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $29, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $29

; ---- data $4461-$447F (30 bytes) [PROBABLE] 30 bytes of BG attribute values ($09/$0A/$29): same 3 x 10 geometry as the tilemap at 441B; attribute source pointer: 73:623B (ld a,$61 ; ld [$C10E],a ; ld a,$44 ; ld [$C10F],a) sets $C10E/$C10F = $4461 before the rect copy of 441B at 73:6250 (static-reached, not executed; verifier: earlier note said "no direct reference")

BrowserStart_BottomAttrSelected:: ; 73:4461
Data_73_4461::
	INCBIN "gfx/browser/start_choice/browser_start_bottom_attr_selected.attrmap"

; ---- data $447F-$4530 (177 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 447F-45DD by higher-priority evidence]

BrowserStart_AnimFrames:: ; 73:447F
Data_73_447F::
	db $80, $81, $82, $83, $84, $E1, $E2, $85, $86, $87, $88, $89, $E3, $E4, $8A, $8B
	db $8C, $8D, $8E, $0A, $0A, $8F, $90, $91, $92, $93, $0A, $0A, $94, $95, $96, $97
	db $98, $0A, $0A, $99, $9A, $9B, $9C, $84, $E5, $E2, $85, $9D, $9E, $9F, $A0, $E6
	db $E7, $A1, $A2, $A3, $A4, $A5, $0A, $0A, $A6, $A7, $A8, $A9, $AA, $0A, $0A, $AB
	db $AC, $AD, $AE, $98, $0A, $0A, $99, $9A, $AF, $B0, $84, $E8, $E2, $85, $B1, $B2
	db $B3, $B4, $E9, $EA, $B5, $B6, $B7, $B8, $B9, $0A, $0A, $A6, $BA, $BB, $BC, $BD
	db $0A, $0A, $BE, $BF, $C0, $AE, $98, $0A, $0A, $80, $81, $C1, $C2, $84, $E8, $E2
	db $85, $C3, $C4, $C5, $C6, $E9, $EA, $8A, $C8, $C9, $CA, $CB, $0A, $0A, $8F, $CC
	db $CD, $CE, $CF, $0A, $0A, $94, $D1, $AD, $AE, $98, $0A, $0A, $99, $9A, $D2, $D3
	db $84, $E5, $E2, $85, $D4, $D5, $D6, $D7, $E6, $E7, $D8, $D9, $DA, $DB, $DC, $0A
	db $0A, $A6, $DD, $DE, $DF, $E0, $0A, $0A, $D0, $AC, $AD, $AE, $98, $0A, $0A, $03
	db $03

; ---- gfx $4530-$45E0 (176 bytes) [PROBABLE] tile data: heuristic: 61 coherent tiles (hsim2=0.744 vsim2=0.679, 107 blank) parity 0; 1536/2736 bytes also covered by call-site blocks [clipped from 4530-4FE0 by higher-priority proposals]

Data_73_4530:: ; 73:4530
	INCBIN "gfx/browser/start_choice/tiles_4530.2bpp"

; ---- gfx $45E0-$49E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 73:5F5E: hl=$45E0 a=$73 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

BrowserStart_Tiles0:: ; 73:45E0
Data_73_45E0::
	INCBIN "gfx/browser/start_choice/browser_start_tiles0.2bpp"

; ---- gfx $49E0-$4DE0 (1024 bytes) [PROBABLE] tiles-2bpp: heuristic: 61 coherent tiles (hsim2=0.744 vsim2=0.679, 107 blank) parity 0; 1536/2736 bytes also covered by call-site blocks [clipped from 4530-4FE0 by higher-priority evidence]

Data_73_49E0:: ; 73:49E0
	INCBIN "gfx/browser/start_choice/tiles_49e0.2bpp"

; ---- gfx $4DE0-$51E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 73:5F70: hl=$4DE0 a=$73 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

BrowserStart_Tiles1:: ; 73:4DE0
Data_73_4DE0::
	INCBIN "gfx/browser/start_choice/browser_start_tiles1.2bpp"

; ---- gfx $51E0-$55E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 73:5F82: hl=$51E0 a=$73 c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

BrowserStart_Tiles2:: ; 73:51E0
Data_73_51E0::
	INCBIN "gfx/browser/start_choice/browser_start_tiles2.2bpp"

; ---- gfx $55E0-$59E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 73:5F94: hl=$55E0 a=$73 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

BrowserStart_Tiles3:: ; 73:55E0
Data_73_55E0::
	INCBIN "gfx/browser/start_choice/browser_start_tiles3.2bpp"

; ---- gfx $59E0-$5DE0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 73:5FA6: hl=$59E0 a=$73 c=$40 de=$9401 (dest VRAM $9400, vbank=1)

BrowserStart_Tiles4:: ; 73:59E0
Data_73_59E0::
	INCBIN "gfx/browser/start_choice/browser_start_tiles4.2bpp"

; ---- data $5DE0-$5DE8 (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 4DE0-5F17 by higher-priority evidence]

BrowserStart_Palettes:: ; 73:5DE0
Data_73_5DE0::
	INCLUDE "gfx/browser/start_choice/browser_start_palettes.pal"

; ---- data $5DE8-$5E00 (24 bytes) [PROBABLE] palette-rgb555: heuristic: 12 RGB555 words as 3 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_73_5DE8:: ; 73:5DE8
	INCLUDE "gfx/browser/start_choice/palette_5de8.pal"

; ---- data $5E00-$5E08 (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 4DE0-5F17 by higher-priority evidence]

Data_73_5E00:: ; 73:5E00
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $5E08-$5E30 (40 bytes) [PROBABLE] palette-rgb555: heuristic: 20 RGB555 words as 5 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_73_5E08:: ; 73:5E08
	INCLUDE "gfx/browser/start_choice/palette_5e08.pal"

BrowserStart_ObjPalettes:: ; 73:5E20
	INCLUDE "gfx/browser/start_choice/browser_start_obj_palettes.pal"

; ---- data $5E30-$5E38 (8 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 4DE0-5F17 by higher-priority evidence]

Data_73_5E30:: ; 73:5E30
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $5E38-$5EC0 (136 bytes) [PROBABLE] palette-rgb555: heuristic: 68 RGB555 words as 17 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_73_5E38:: ; 73:5E38
	INCLUDE "gfx/browser/start_choice/palette_5e38.pal"

; ---- data $5EC0-$5F17 (87 bytes) [CONFIRMED] read as data by executed code (in up to 1/18 scenarios); content class unknown [clipped from 4DE0-5F17 by higher-priority evidence]

Data_73_5EC0:: ; 73:5EC0
	db $14, $01, $14 ; not reached by any walked sprite chain
SpriteFrameTable_73_5EC3:: ; 73:5EC3
	sprite_frame_table SpriteFrame_73_5ED1, SpriteFrame_73_5EDA, SpriteFrame_73_5EE3, SpriteFrame_73_5EE8
	sprite_frame_table SpriteFrame_73_5EF5, SpriteFrame_73_5EFA, SpriteFrame_73_5EFF
SpriteFrame_73_5ED1:: ; 73:5ED1
	sprite_frame 2
	sprite_oam 0, 0, $0B, 1
	sprite_oam 0, 8, $0C, 1
SpriteFrame_73_5EDA:: ; 73:5EDA
	sprite_frame 2
	sprite_oam 0, -8, $0D, 1
	sprite_oam 0, 0, $0E, 1
SpriteFrame_73_5EE3:: ; 73:5EE3
	sprite_frame 1
	sprite_oam 0, -8, $0F, 1
SpriteFrame_73_5EE8:: ; 73:5EE8
	sprite_frame 3
	sprite_oam -8, -16, $10, 1
	sprite_oam -8, -8, $11, 1
	sprite_oam 0, -16, $12, 1
SpriteFrame_73_5EF5:: ; 73:5EF5
	sprite_frame 1
	sprite_oam -8, -23, $13, 1
SpriteFrame_73_5EFA:: ; 73:5EFA
	sprite_frame 1
	sprite_oam -13, -23, $14, 1
SpriteFrame_73_5EFF:: ; 73:5EFF
	sprite_frame 0
SpriteScript_73_5F00:: ; 73:5F00
	sprite_anim 7
	sprite_anim_step 0, 6
	sprite_anim_step 1, 6
	sprite_anim_step 2, 6
	sprite_anim_step 3, 6
	sprite_anim_step 4, 6
	sprite_anim_step 5, 6
	sprite_anim_step 6, 30
BrowserStart_ObjTable:: ; 73:5F0F
	db $60, $5E, $BE, $5E ; sprite object-table entry kept as db: pointer target 73:5E60 has no label
	sprite_object_entry SpriteFrameTable_73_5EC3, SpriteScript_73_5F00 ; entry 1
