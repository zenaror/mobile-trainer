; gfx/mail/comm_progress_scene.asm
; bank 22, $5980-$5CD0 (848 bytes); pinned by layout.link
; tilemap and two palettes of the communication-progress scene (loaded by bank 26)

SECTION "gfx/mail/comm_progress_scene", ROMX

; ---- data $5980-$5C50 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 26:529A: hl=$5980 a=$22 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_CommProgress_Screen:: ; 22:5980
Data_22_5980::
	INCBIN "gfx/mail/comm_progress_scene/comm_progress_screen.tilemap"
	INCBIN "gfx/mail/comm_progress_scene/comm_progress_screen.attrmap"

; ---- data $5C50-$5C90 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufBg (engine/mail/mail_session_screen.asm:230, call 26:51D7 executed 57 hits in 16 scenarios (analysis/coverage_union.tsv))

Palette_CommProgress_Bg:: ; 22:5C50
Data_22_5C50::
	INCLUDE "gfx/mail/comm_progress_scene/comm_progress_bg.pal"

; ---- data $5C90-$5CD0 (64 bytes) [CONFIRMED] palette-rgb555: 32 colours (8 palettes) read by Palette_LoadToBuffer: +$00 bc=$40 into wPaletteBufObj (engine/mail/mail_session_screen.asm:235, call 26:51E8 executed 57 hits in 16 scenarios (analysis/coverage_union.tsv))

Palette_CommProgress_Obj:: ; 22:5C90
	INCLUDE "gfx/mail/comm_progress_scene/comm_progress_obj.pal"
