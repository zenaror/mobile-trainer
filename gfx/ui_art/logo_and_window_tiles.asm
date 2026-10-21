; gfx/ui_art/logo_and_window_tiles.asm
; bank 5B, $4000-$56E0 (5856 bytes); pinned by layout.link
; help-script picture tiles and palettes; static picture IDs 27-31 load the first 5 tile blocks and palette slices (engine/help/help_script.asm)

SECTION "gfx/ui_art/logo_and_window_tiles", ROMX

; ---- gfx $4000-$5200 (4608 bytes) [PROBABLE] 288 x 2bpp tiles (0x1200 bytes): rendered as a 16-wide tile sheet the whole span is coherent tile art (logo lettering, window frames, katakana/kana glyph tiles); tiles are 16-aligned from 4000 and the run 4000-5680 is an exact multiple of 16; the $FF runs at 42F0/44F0/48FE are solid-colour tiles inside the art; HelpScript_PictureTable IDs 27-30 each load $480 bytes from this span

Gfx_HelpScript_Pictures27To30Tiles:: ; 5B:4000
	INCBIN "gfx/ui_art/logo_and_window_tiles/logo_and_window_tiles.2bpp"

; ---- gfx $5200-$5680 (1152 bytes) [PROBABLE] 72 x 2bpp tiles (0x480 bytes) continuing the tile sheet above; HelpScript_PictureTable ID 31 loads this exact $480-byte tile span; its natural selection is not established

Gfx_HelpScript_Picture31Tiles:: ; 5B:5200
	INCBIN "gfx/ui_art/logo_and_window_tiles/mail_server_box_tiles.2bpp"

; ---- data $5680-$56E0 (96 bytes) [PROBABLE] 12 CGB palettes x 4 RGB555 words; HelpScript_PictureTable IDs 27-31 load 5680-56A8, while the remaining 56 bytes have no demonstrated consumer

Palette_HelpScript_CandidateBlock_5680:: ; 5B:5680
	INCLUDE "gfx/ui_art/logo_and_window_tiles/art_palettes.pal"
