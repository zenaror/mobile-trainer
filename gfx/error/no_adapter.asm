; gfx/error/no_adapter.asm
; bank 63, $6080-$732F (4783 bytes); pinned by layout.link
; no-adapter screen tiles, tilemap, palettes, object table and animation

SECTION "gfx/error/no_adapter", ROMX

; ---- gfx $6080-$6480 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7365: hl=$6080 a=$63 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

NoAdapter_Gfx_8000:: ; 63:6080
Data_63_6080::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8000.2bpp"

NoAdapter_Gfx_8800:: ; 63:60C0
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8800.2bpp"

; ---- gfx $6480-$64C0 (64 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7377: hl=$60C0 a=$63 c=$40 de=$8801 (dest VRAM $8800, vbank=1) [clipped from 60C0-64C0 by higher-priority evidence]

Data_63_6480:: ; 63:6480
	INCBIN "gfx/error/no_adapter/tiles_6480.2bpp"

; ---- gfx $64C0-$68C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:7389: hl=$64C0 a=$63 c=$40 de=$8C01 (dest VRAM $8C00, vbank=1)

NoAdapter_Gfx_8C00:: ; 63:64C0
Data_63_64C0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_8c00.2bpp"

; ---- gfx $68C0-$6CC0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:739B: hl=$68C0 a=$63 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

NoAdapter_Gfx_9000:: ; 63:68C0
Data_63_68C0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_9000.2bpp"

; ---- gfx $6CC0-$6FC0 (768 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 63:73AD: hl=$6CC0 a=$63 c=$40 de=$9401 (dest VRAM $9400, vbank=1); the last $100 bytes of the old blob hold the head of a tilemap pair; the blocks below type them by what the code reads, and the HDMA request that copies the tiles copies them into VRAM as well

NoAdapter_Gfx_9400:: ; 63:6CC0
Data_63_6CC0::
	INCBIN "gfx/error/no_adapter/no_adapter_gfx_9400.2bpp"

; ---- data $6FC0-$7290 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 63:73E0: hl=$6FC0 a=$63 b=18 rows c=20 cols (tiles then attrs) de=$D000

NoAdapter_Tilemap:: ; 63:6FC0
	INCBIN "gfx/error/no_adapter/no_adapter_tilemap.tilemap"
	INCBIN "gfx/error/no_adapter/no_adapter_tilemap.attrmap"

; ---- data $7290-$72D0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/error/no_adapter.asm:59, call 63:73BE executed 7 hits in 2 scenarios (analysis/coverage_union.tsv))

NoAdapter_Palette_Bg:: ; 63:7290
Data_63_7290::
	INCLUDE "gfx/error/no_adapter/no_adapter_palette_bg.pal"

; ---- data $72D0-$7310 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/error/no_adapter.asm:64, call 63:73CF executed 7 hits in 2 scenarios (analysis/coverage_union.tsv))

NoAdapter_Palette_Obj:: ; 63:72D0
	INCLUDE "gfx/error/no_adapter/no_adapter_palette_obj.pal"

; ---- words $7310-$7318 (8 bytes) [PROBABLE] 2 object-table entries of 4 bytes (ptr to frame table, ptr to script; 0000 = unused); de=$7310 a=$63 at 63:73F5 (entry 0 unused, entry 1 = 7318/732A); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 7314-7318 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

NoAdapter_ObjTable:: ; 63:7310
Table_63_7310::
	sprite_object_entry 0, 0 ; entry 0
	sprite_object_entry NoAdapter_ObjAnim, SpriteScript_63_732A ; entry 1

; ---- data $7318-$732F (23 bytes) [PROBABLE] 1 object record(s): 1 frame tables, 2 frames, 1 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 63:7318-732F [v4: bytes 7318-732F were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

NoAdapter_ObjAnim:: ; 63:7318
Data_63_7318::
	sprite_frame_table SpriteFrame_63_731C, SpriteFrame_63_7325
SpriteFrame_63_731C:: ; 63:731C
	sprite_frame 2
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
SpriteFrame_63_7325:: ; 63:7325
	sprite_frame 1
	sprite_oam 8, 8, $02, 0
SpriteScript_63_732A:: ; 63:732A
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 30
