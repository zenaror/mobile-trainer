; gfx/mail/connect_screen_bank29.asm
; bank 29, $5376-$5B10 (1946 bytes); pinned by layout.link
; palettes, tiles, tilemap loaded by bank 27 (5400/5800/5AD0)

SECTION "gfx/mail/connect_screen_bank29", ROMX

; ---- data $5376-$53F6 (128 bytes) [PROBABLE] palette-rgb555: heuristic: 64 RGB555 words as 16 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_29_5376:: ; 29:5376
	INCLUDE "gfx/mail/connect_screen_bank29/palette_5376.pal"

; ---- gfx $53F6-$5400 (10 bytes) [PROBABLE] tiles-2bpp: heuristic: 53 coherent tiles (hsim2=0.790 vsim2=0.794, 6 blank) parity 0; 928/944 bytes also covered by call-site blocks [clipped from 53F0-57A0 by higher-priority evidence]

Data_29_53F6:: ; 29:53F6
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $5400-$5800 (1024 bytes) [PROBABLE] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 27:4DCC: hl=$5400 a=$29 c=$40 de=$9001 (dest VRAM $9000, vbank=1) [verifier: call site never executed in a trace -> PROBABLE]

Data_29_5400:: ; 29:5400
	INCBIN "gfx/mail/connect_screen_bank29/tiles_5400.2bpp"

; ---- data $5800-$5AD0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 27:4DDD: hl=$5800 a=$29 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_29_5800:: ; 29:5800
	INCBIN "gfx/mail/connect_screen_bank29/tilemap_5800.tilemap"
	INCBIN "gfx/mail/connect_screen_bank29/tilemap_5800.attrmap"

; ---- data $5AD0-$5B10 (64 bytes) [PROBABLE] verifier: 64-byte palette upload (ld bc,$0040 ; ld hl,$5AD0 ; ld a,$29 ; far call 4F:4000, far-call site at 27:4DA9, found by a ROM scan): first group $0000,$294A,$56B5,$7FFF (bit15 clear, grey ramp; same group repeated in 29:5E30-5E50 and 2A:51F8-5220), the other 56 bytes are all-zero (black) palette entries loaded with it. Was: 8-byte palette + 56-byte zero region

Palette_29_5AD0:: ; 29:5AD0
	INCLUDE "gfx/mail/connect_screen_bank29/palette_5ad0.pal"
