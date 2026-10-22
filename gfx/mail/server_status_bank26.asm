; gfx/mail/server_status_bank26.asm
; bank 26, $7420-$7AB0 (1680 bytes); pinned by layout.link
; server status screen tiles stored in bank 26 (loaded by bank 29)

SECTION "gfx/mail/server_status_bank26", ROMX

; ---- gfx $7420-$7820 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4650: hl=$7420 a=$26 c=$40 de=$9400 (dest VRAM $9400, vbank=0)

MailServerStatus_Tiles_7420:: ; 26:7420
	INCBIN "gfx/mail/server_status_bank26/mail_server_status_tiles_7420.2bpp"

; ---- gfx $7820-$7840 (32 bytes) [CONFIRMED] Profile_InitScreen HDMA source to VRAM0 $8000-$8020; full request continues through $82A0

Gfx_Profile_Tiles8000:: ; 26:7820
	; Static request at engine/profile/profile_editor.asm:508 transfers 42 16-byte units from here to VRAM0 $8000.
	INCBIN "gfx/mail/server_status_bank26/profile_tiles8000.2bpp"

; ---- gfx $7840-$7AB0 (624 bytes) [CONFIRMED] interior 39-unit slice of Profile_InitScreen HDMA: VRAM0 $8020-$8290; tilemap selection and display are unproved

Gfx_Profile_InitScreen_Tiles8020Slice:: ; 26:7840
	INCBIN "gfx/mail/server_status_bank26/profile_init_screen_tiles8020_slice.2bpp"
