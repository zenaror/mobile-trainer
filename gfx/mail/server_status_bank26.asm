; gfx/mail/server_status_bank26.asm
; bank 26, $7420-$7AB0 (1680 bytes); pinned by layout.link
; server status screen tiles stored in bank 26 (loaded by bank 29)

SECTION "gfx/mail/server_status_bank26", ROMX

; ---- gfx $7420-$7820 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4650: hl=$7420 a=$26 c=$40 de=$9400 (dest VRAM $9400, vbank=0)

MailServerStatus_Tiles_7420:: ; 26:7420
Data_26_7420::
	INCBIN "gfx/mail/server_status_bank26/mail_server_status_tiles_7420.2bpp"

; ---- data $7820-$7840 (32 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); kind tiles from the label name [clipped from 7420-7B00 by higher-priority evidence]

Gfx_Profile_Tiles8000:: ; 26:7820
Data_26_7820::
	; kind (tiles) from the label name / config/symbols note; the region header above describes the block differently
	INCBIN "gfx/mail/server_status_bank26/profile_tiles8000.2bpp"

; ---- gfx $7840-$7AB0 (624 bytes) [PROBABLE] tiles-2bpp: heuristic: 32 coherent tiles (hsim2=0.786 vsim2=0.762, 6 blank) parity 0

Data_26_7840:: ; 26:7840
	INCBIN "gfx/mail/server_status_bank26/tiles_7840.2bpp"
