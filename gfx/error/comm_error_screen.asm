; gfx/error/comm_error_screen.asm
; bank 5C, $5516-$642F (3865 bytes); pinned by layout.link
; error screen tilemaps, tiles, palettes, object tables

SECTION "gfx/error/comm_error_screen", ROMX

; ---- data $5516-$57E6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 5C:52A2: hl=$5516 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_Comm:: ; 5C:5516
Data_5C_5516::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm.attrmap"

; ---- data $57E6-$5AB6 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 5C:52B7: hl=$57E6 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_CommTimer:: ; 5C:57E6
Data_5C_57E6::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm_timer.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_comm_timer.attrmap"

; ---- data $5AB6-$5D86 (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (5C:52FB 5C:53AC); first: copy_tilemap_rect_pair at 5C:52FB: hl=$5AB6 a=$5C b=18 rows c=20 cols (tiles then attrs) de=$D000

CommErr_Tilemap_Plain:: ; 5C:5AB6
Data_5C_5AB6::
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_plain.tilemap"
	INCBIN "gfx/error/comm_error_screen/comm_err_tilemap_plain.attrmap"

; ---- zero $5D86-$5D90 (10 bytes) [PROBABLE] 10 x 00 between the 09-filled block ending at 5D86 and the tile block at 5D90
	ds $A, $00

; ---- gfx $5D90-$5DB0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:5194: hl=$5D90 a=$5C c=$02 de=$8001 (dest VRAM $8000, vbank=1)

CommErr_Gfx_Obj8000:: ; 5C:5D90
Data_5C_5D90::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_obj8000.2bpp"

; ---- gfx $5DB0-$5DD0 (32 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51A6: hl=$5DB0 a=$5C c=$02 de=$8101 (dest VRAM $8100, vbank=1)

CommErr_Gfx_Obj8100:: ; 5C:5DB0
Data_5C_5DB0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_obj8100.2bpp"

; ---- gfx $5DD0-$61D0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51B8: hl=$5DD0 a=$5C c=$40 de=$9001 (dest VRAM $9000, vbank=1)

CommErr_Gfx_Bg9000:: ; 5C:5DD0
Data_5C_5DD0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_bg9000.2bpp"

; ---- gfx $61D0-$6350 (384 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 5C:51CA: hl=$61D0 a=$5C c=$18 de=$9401 (dest VRAM $9400, vbank=1)

CommErr_Gfx_Bg9400:: ; 5C:61D0
Data_5C_61D0::
	INCBIN "gfx/error/comm_error_screen/comm_err_gfx_bg9400.2bpp"

; ---- gfx $6350-$6390 (64 bytes) [CONFIRMED] 32 RGB555 words for the timer BG palette
; Palette_LoadToBuffer at 5C:52E1 copies all 64 bytes; naturally read in 14/69 scenarios.

CommErr_Palette_BgTimer:: ; 5C:6350
Data_5C_6350::
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_bg_timer.pal"

; ---- gfx $6390-$63D0 (64 bytes) [CONFIRMED] 32 RGB555 words for the BG palette
; Palette_LoadToBuffer at 5C:51DB copies all 64 bytes; naturally read in 23/69 scenarios.

CommErr_Palette_Bg:: ; 5C:6390
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_bg.pal"

; ---- gfx $63D0-$6410 (64 bytes) [CONFIRMED] 32 RGB555 words for the OBJ palette
; Palette_LoadToBuffer at 5C:51EC copies all 64 bytes; naturally read in 23/69 scenarios.

CommErr_Palette_Obj:: ; 5C:63D0
	INCLUDE "gfx/error/comm_error_screen/comm_err_palette_obj.pal"

; One OAM piece has a label on its attribute byte. Emit its prefix, then that byte separately.
; This helper consumes one piece of sprite_frame's counter; its sole use supplies the fourth byte.
MACRO commerr_sprite_oam_prefix
	ASSERT _NARG == 3, "commerr_sprite_oam_prefix takes y, x, tile"
	ASSERT _sprite_oam_left > 0, "commerr_sprite_oam_prefix requires an OAM piece"
	DEF _sprite_oam_left -= 1
	db (\1), (\2), (\3)
ENDM

; ---- ptrtable $6410-$6414 (4 bytes) [CONFIRMED] two frame pointers for CommErr_ObjTable
; The two-step script selects frames 0 and 1; all four bytes naturally read in 14/69 scenarios.

CommErr_ObjAnim:: ; 5C:6410
	sprite_frame_table SpriteFrame_5C_6414, SpriteFrame_5C_6425

; ---- data $6414-$6425 (17 bytes) [CONFIRMED] count 4 followed by four OAM pieces
; Sprite_StepAndDrawSlot at 00:0AE8 consumes this frame; all 17 bytes read in 14/69 scenarios.

SpriteFrame_5C_6414:: ; 5C:6414
	sprite_frame 4
	sprite_oam $00, $00, $00, $08
	sprite_oam $00, $08, $01, $08
	commerr_sprite_oam_prefix $08, $00, $10
Data_5C_6420:: ; 5C:6420
	db $08 ; attribute of the third OAM piece, consumed by the same frame
	sprite_oam $08, $08, $11, $08
	ASSERT _sprite_oam_left == 0, "communication-error frame must contain four OAM pieces"
	ASSERT Data_5C_6420 - SpriteFrame_5C_6414 == 12, "attribute label must keep its byte offset"
PURGE commerr_sprite_oam_prefix

; ---- data $6425-$6426 (1 bytes) [CONFIRMED] empty second frame, count 0
; Frame index 1 selects this count byte; naturally read in 14/69 scenarios.

SpriteFrame_5C_6425:: ; 5C:6425
	sprite_frame 0

; ---- data $6426-$642B (5 bytes) [CONFIRMED] two frame-index/delay steps: (0,12), (1,12)
; Sprite_StepAndDrawSlot at 00:0AE8 consumes both steps; all five bytes read in 14/69 scenarios.

SpriteScript_5C_6426:: ; 5C:6426
	sprite_anim 2
	sprite_anim_step 0, 12
	sprite_anim_step 1, 12

; ---- data $642B-$642F (4 bytes) [CONFIRMED] one frame-table/script-pointer object entry
; Sprite_InitSlot at 5C:52C7 selects entry 0 with B=$80; all four bytes read in 14/69 scenarios.

CommErr_ObjTable:: ; 5C:642B
	sprite_object_entry CommErr_ObjAnim, SpriteScript_5C_6426 ; entry 0
