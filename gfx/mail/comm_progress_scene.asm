; gfx/mail/comm_progress_scene.asm
; bank 22, $5980-$5CD0 (848 bytes); pinned by layout.link
; tilemap and two palettes of the communication-progress scene (loaded by bank 26)

SECTION "gfx/mail/comm_progress_scene", ROMX

; ---- data $5980-$5C50 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 26:529A: hl=$5980 a=$22 b=18 rows c=20 cols (tiles then attrs) de=$D000

Tilemap_CommProgress_Screen:: ; 22:5980
Data_22_5980::
	INCBIN "gfx/mail/comm_progress_scene/comm_progress_screen.tilemap"
	INCBIN "gfx/mail/comm_progress_scene/comm_progress_screen.attrmap"

; ---- data $5C50-$5C52 (2 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 5980-66D0 by higher-priority evidence]

Palette_CommProgress_Bg:: ; 22:5C50
Data_22_5C50::
	INCLUDE "gfx/mail/comm_progress_scene/comm_progress_bg.pal"

; ---- data $5C52-$5CD0 (126 bytes) [PROBABLE] palette-rgb555: heuristic: 76 RGB555 words as 19 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance) (part of region $5C52-$5CEA)

Data_22_5C52:: ; 22:5C52
	INCLUDE "gfx/mail/comm_progress_scene/palette_5c52.pal"

Palette_CommProgress_Obj:: ; 22:5C90
	INCLUDE "gfx/mail/comm_progress_scene/comm_progress_obj.pal"
