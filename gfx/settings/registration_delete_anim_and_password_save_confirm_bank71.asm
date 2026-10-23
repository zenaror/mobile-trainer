; gfx/settings/registration_delete_anim_and_password_save_confirm_bank71.asm
; bank 71, $6F44-$7740 (2044 bytes); pinned by layout.link
; settings screen art loaded by bank 67, plus notice-header tile sources selected by bank 65

SECTION "gfx/settings/registration_delete_anim_and_password_save_confirm_bank71", ROMX

; ---- data $6F44-$6F69 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Registration_DeleteExecute_Anim1Frame0:: ; 71:6F44
	sprite_frame 9
	sprite_oam 0, 0, $00, 0
	sprite_oam 0, 8, $01, 0
	sprite_oam 8, 0, $02, 0
	sprite_oam 8, 8, $03, 0
	sprite_oam 0, 16, $00, OAMF_XFLIP
	sprite_oam 8, 16, $02, OAMF_XFLIP
	sprite_oam 16, 0, $00, OAMF_YFLIP
	sprite_oam 16, 8, $01, OAMF_YFLIP
	sprite_oam 16, 16, $00, OAMF_YFLIP | OAMF_XFLIP

; ---- data $6F69-$6F6A (1 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces; 0 piece(s) = an empty frame (1 byte); length tiles exactly against the frame-table pointers

Registration_DeleteExecute_Anim1Frame1:: ; 71:6F69
	sprite_frame 0

; ---- data $6F6A-$6F6F (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:30 1:30; ends exactly at the tilemap block 6F6F

Registration_DeleteExecute_Anim1Script:: ; 71:6F6A
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 30

; ---- data $6F6F-$723F (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:65FD: hl=$6F6F a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000 [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

Tilemap_PwSaveConfirm_71_6F6F:: ; 71:6F6F

	INCBIN "gfx/settings/registration_delete_anim_and_password_save_confirm_bank71/password_save_confirm_variant_nonzero_bgmap_6f6f.tilemap"
	INCBIN "gfx/settings/registration_delete_anim_and_password_save_confirm_bank71/password_save_confirm_variant_nonzero_bgmap_6f6f.attrmap"

; ---- data $723F-$7240 (1 byte) [CONFIRMED] $00 byte immediately before the indexed header-graphics sources; no role established

Settings_UnclassifiedByte_723F:: ; 71:723F
	db $00

; ---- gfx $7240-$74C0 (640 bytes) [CONFIRMED] tiles-2bpp: Notice_LoadHeaderGfx reads descriptor index $16 from 65:4A81 and requests $28 blocks from bank 71:$7240 to VRAM1:$9300; static selection/load contract, not natural-use proof

Notice_HeaderGfxSourceDescriptor16_7240:: ; 71:7240

	INCBIN "gfx/settings/registration_delete_anim_and_password_save_confirm_bank71/notice_header_gfx_source_descriptor16_7240.2bpp"

; ---- gfx $74C0-$7740 (640 bytes) [CONFIRMED] tiles-2bpp: Notice_LoadHeaderGfx reads descriptor index $17 from 65:4A81 and requests $28 blocks from bank 71:$74C0 to VRAM1:$9300; static selection/load contract, not natural-use proof

Notice_HeaderGfxSourceDescriptor17_74C0:: ; 71:74C0

	INCBIN "gfx/settings/registration_delete_anim_and_password_save_confirm_bank71/notice_header_gfx_source_descriptor17_74c0.2bpp"
