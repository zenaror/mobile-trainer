; gfx/mail_server/delete_menu_hidden.asm
; bank 22, $5110-$5980 (2160 bytes); pinned by layout.link
; tilemaps of the three delete buttons (hidden variant)

SECTION "gfx/mail_server/delete_menu_hidden", ROMX

; ---- data $5110-$53E0 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (22:4184 22:42CA); first: copy_tilemap_rect_pair at 22:4184: hl=$5110 a=$22 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailSrvDelHidden_Button1:: ; 22:5110
Data_22_5110::
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button1.tilemap"
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button1.attrmap"

; ---- data $53E0-$56B0 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (22:41C3 22:4325); first: copy_tilemap_rect_pair at 22:41C3: hl=$53E0 a=$22 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailSrvDelHidden_Button0:: ; 22:53E0
Data_22_53E0::
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button0.tilemap"
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button0.attrmap"

; ---- data $56B0-$5980 (720 bytes) [PROBABLE] tilemap+attr: 2 call site(s) (22:41FE 22:4359); first: copy_tilemap_rect_pair at 22:41FE: hl=$56B0 a=$22 b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Tilemap_MailSrvDelHidden_Button2:: ; 22:56B0
Data_22_56B0::
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button2.tilemap"
	INCBIN "gfx/mail_server/delete_menu_hidden/mail_srv_del_hidden_button2.attrmap"
