; gfx/mail/server_status.asm
; bank 25, $6F30-$7FA0 (4208 bytes); pinned by layout.link
; mail-server status screen tiles and tilemaps (loaded by bank 29)

SECTION "gfx/mail/server_status", ROMX

; ---- gfx $6F30-$7330 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4662: hl=$6F30 a=$25 c=$40 de=$8800 (dest VRAM $8800, vbank=0)

MailServerStatus_Tiles_6F30:: ; 25:6F30
Data_25_6F30::
	INCBIN "gfx/mail/server_status/mail_server_status_tiles_6f30.2bpp"

; ---- gfx $7330-$7730 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 29:4674: hl=$7330 a=$25 c=$40 de=$8C00 (dest VRAM $8C00, vbank=0)

MailServerStatus_Tiles_7330:: ; 25:7330
Data_25_7330::
	INCBIN "gfx/mail/server_status/mail_server_status_tiles_7330.2bpp"

; ---- data $7730-$7A00 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 29:46B0: hl=$7730 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

MailServerStatus_Tilemap_Received:: ; 25:7730
Data_25_7730::
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_received.tilemap"
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_received.attrmap"

; ---- data $7A00-$7CD0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 29:46C4: hl=$7A00 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000

MailServerStatus_Tilemap_NoneReceived:: ; 25:7A00
Data_25_7A00::
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_none_received.tilemap"
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_none_received.attrmap"

; ---- data $7CD0-$7FA0 (720 bytes) [CONFIRMED] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 29:46D8: hl=$7CD0 a=$25 b=18 rows c=20 cols (tiles then attrs) de=$D000

MailServerStatus_Tilemap_ServerMgmt:: ; 25:7CD0
Data_25_7CD0::
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_server_mgmt.tilemap"
	INCBIN "gfx/mail/server_status/mail_server_status_tilemap_server_mgmt.attrmap"
