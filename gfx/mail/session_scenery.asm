; gfx/mail/session_scenery.asm
; bank 26, $59D8-$7420 (6728 bytes); pinned by layout.link
; transfer screen tiles and palette

SECTION "gfx/mail/session_scenery", ROMX

; ---- gfx $59D8-$59E0 (8 bytes) [PROBABLE] tiles-2bpp: heuristic: 37 coherent tiles (hsim2=0.706 vsim2=0.784, 1 blank) parity 0; 592/608 bytes also covered by call-site blocks [clipped from 59D0-5C30 by higher-priority evidence]

Data_26_59D8:: ; 26:59D8
	db $00, $00, $00, $00, $00, $00, $00, $00

; ---- gfx $59E0-$5DE0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:51FA: hl=$59E0 a=$26 c=$40 de=$8001 (dest VRAM $8000, vbank=1)

MailSession_Tiles_59E0:: ; 26:59E0
Data_26_59E0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_59e0.2bpp"

; ---- gfx $5DE0-$61E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:520C: hl=$5DE0 a=$26 c=$40 de=$8401 (dest VRAM $8400, vbank=1)

MailSession_Tiles_5DE0:: ; 26:5DE0
Data_26_5DE0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_5de0.2bpp"

; ---- gfx $61E0-$62E0 (256 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:521E: hl=$61E0 a=$26 c=$10 de=$8801 (dest VRAM $8800, vbank=1)

MailSession_Tiles_61E0:: ; 26:61E0
Data_26_61E0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_61e0.2bpp"

; ---- gfx $62E0-$66E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5230: hl=$62E0 a=$26 c=$40 de=$9001 (dest VRAM $9000, vbank=1)

MailSession_Tiles_62E0:: ; 26:62E0
Data_26_62E0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_62e0.2bpp"

; ---- gfx $66E0-$66F0 (16 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5919: hl=$66E0 a=$26 c=$01 de=$9401 (dest VRAM $9400, vbank=1)

MailSession_Tiles_66E0:: ; 26:66E0
Data_26_66E0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_66e0.2bpp"

; ---- gfx $66F0-$67E0 (240 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5242: hl=$66E0 a=$26 c=$10 de=$9401 (dest VRAM $9400, vbank=1) [clipped from 66E0-67E0 by higher-priority evidence]

Data_26_66F0:: ; 26:66F0
	INCBIN "gfx/mail/session_scenery/tiles_66f0.2bpp"

; ---- gfx $67E0-$6BE0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5254: hl=$67E0 a=$26 c=$40 de=$8000 (dest VRAM $8000, vbank=0)

MailSession_Tiles_67E0:: ; 26:67E0
Data_26_67E0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_67e0.2bpp"

; ---- gfx $6BE0-$6FE0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5266: hl=$6BE0 a=$26 c=$40 de=$8400 (dest VRAM $8400, vbank=0)

MailSession_Tiles_6BE0:: ; 26:6BE0
Data_26_6BE0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_6be0.2bpp"

; ---- gfx $6FE0-$73E0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 26:5278: hl=$6FE0 a=$26 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

MailSession_Tiles_6FE0:: ; 26:6FE0
Data_26_6FE0::
	INCBIN "gfx/mail/session_scenery/mail_session_tiles_6fe0.2bpp"

; ---- data $73E0-$7420 (64 bytes) [PROBABLE] palette-rgb555: heuristic: 32 RGB555 words as 8 palette group(s) of 4 (bit15 clear, contains $7FFF, monotone luminance)

Data_26_73E0:: ; 26:73E0
	INCLUDE "gfx/mail/session_scenery/palette_73e0.pal"
