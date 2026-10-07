; gfx/mail_server/delete_all_screen.asm
; bank 28, $54B0-$5F20 (2672 bytes); pinned by layout.link
; delete-all screen tiles, tilemap, palettes (loaded by banks 22/23)

SECTION "gfx/mail_server/delete_all_screen", ROMX

; ---- gfx $54B0-$58B0 (1024 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (22:45EB 23:44DA); first: hdma_rom_to_vram at 22:45EB: hl=$54B0 a=$28 c=$40 de=$9301 (dest VRAM $9300, vbank=1) [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

MailServerDeleteAll_Tiles_54B0:: ; 28:54B0
Data_28_54B0::
	INCBIN "gfx/mail_server/delete_all_screen/mail_server_delete_all_tiles_54b0.2bpp"

; ---- gfx $58B0-$5B50 (672 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (22:4600 23:44EF); first: hdma_rom_to_vram at 22:4600: hl=$58B0 a=$28 c=$2A de=$9701 (dest VRAM $9700, vbank=1) [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

MailServerDeleteAll_Tiles_58B0:: ; 28:58B0
Data_28_58B0::
	INCBIN "gfx/mail_server/delete_all_screen/mail_server_delete_all_tiles_58b0.2bpp"

; ---- gfx $5B50-$5BD0 (128 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (22:4615 23:4504); first: hdma_rom_to_vram at 22:4615: hl=$5B50 a=$28 c=$08 de=$8000 (dest VRAM $8000, vbank=0) [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

MailServerDeleteAll_Tiles_5B50:: ; 28:5B50
Data_28_5B50::
	INCBIN "gfx/mail_server/delete_all_screen/mail_server_delete_all_tiles_5b50.2bpp"

; ---- data $5BD0-$5EA0 (720 bytes) [CONFIRMED] tilemap+attr: 2 call site(s) (22:4629 23:4518); first: copy_tilemap_rect_pair at 22:4629: hl=$5BD0 a=$28 b=18 rows c=20 cols (tiles then attrs) de=$D000 [first call site executed: 6 hits in 3 scenarios (analysis/coverage_union.tsv)]

MailServerDeleteAll_Tilemap:: ; 28:5BD0
Data_28_5BD0::
	INCBIN "gfx/mail_server/delete_all_screen/mail_server_delete_all_tilemap.tilemap"
	INCBIN "gfx/mail_server/delete_all_screen/mail_server_delete_all_tilemap.attrmap"

; ---- data $5EA0-$5EE0 (64 bytes) [CONFIRMED] BG palette: 8 x 4 RGB555 words (all bit15 clear), original-exact; 2 literal loader site(s) (22:45C2 23:44B1) pass bank $28, BC=$0040 and DE=$D800 to 4F:4000 Palette_LoadToBuffer, selecting WRAM bank 7 and copying through 00:050C; all 64 bytes read in each of 11/69 existing original-ROM scenarios, with all five loader instruction starts observed; no new visual or hardware observation

MailServerDeleteAll_BgPalette:: ; 28:5EA0
Palette_28_5EA0::
	INCLUDE "gfx/mail_server/delete_all_screen/mail_server_delete_all_bg_palette.pal"
; ---- data $5EE0-$5F20 (64 bytes) [CONFIRMED] OBJ palette: 8 x 4 RGB555 words (all bit15 clear), original-exact; 2 literal loader site(s) (22:45D6 23:44C5) pass bank $28, BC=$0040 and DE=$D840 to 4F:4000 Palette_LoadToBuffer, selecting WRAM bank 7 and copying through 00:050C; all 64 bytes read in each of 11/69 existing original-ROM scenarios, with all five loader instruction starts observed; no new visual or hardware observation
MailServerDeleteAll_ObjPalette:: ; 28:5EE0
	INCLUDE "gfx/mail_server/delete_all_screen/mail_server_delete_all_obj_palette.pal"
