; gfx/settings/screens_bank71.asm
; bank 71, $6F44-$7740 (2044 bytes); pinned by layout.link
; settings screen art loaded by bank 67

SECTION "gfx/settings/screens_bank71", ROMX

; ---- data $6F44-$6F69 (37 bytes) [PROBABLE] sprite frame record: count byte + count x (y offset, x offset, tile, attribute) OAM pieces (00:0B9D loop adds y+16 / x+8 and copies 4 bytes to shadow OAM); 9 piece(s); length tiles exactly against the frame-table pointers

Registration_DeleteExecute_Anim1Frame0:: ; 71:6F44
Data_71_6F44::
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
Data_71_6F69::
	sprite_frame 0

; ---- data $6F6A-$6F6F (5 bytes) [PROBABLE] sprite animation script: count byte + count x (frame index, delay) pairs (00:0B02-0B23 reads count, then idx*2+1 pairs into slot+4/+5); 2 step(s), (frame,delay) pairs: 0:30 1:30; ends exactly at the tilemap block 6F6F

Registration_DeleteExecute_Anim1Script:: ; 71:6F6A
Data_71_6F6A::
	sprite_anim 2
	sprite_anim_step 0, 30
	sprite_anim_step 1, 30

; ---- data $6F6F-$723F (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 67:65FD: hl=$6F6F a=$71 b=18 rows c=20 cols (tiles then attrs) de=$D000 [call sites not executed in the 64 natural scenarios (analysis/coverage_union.tsv)]

Tilemap_PwSaveConfirm_71_6F6F:: ; 71:6F6F
Data_71_6F6F::
	INCBIN "gfx/settings/screens_bank71/tilemap_6f6f.tilemap"
	INCBIN "gfx/settings/screens_bank71/tilemap_6f6f.attrmap"

; ---- gfx $723F-$7271 (50 bytes) [PROBABLE] tiles-2bpp: heuristic: 35 coherent tiles (hsim2=0.670 vsim2=0.903, 1 blank) parity 1; 558/608 bytes also covered by call-site blocks [clipped from 7011-7271 by higher-priority evidence]

Data_71_723F:: ; 71:723F
	db $00, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $18, $42, $5A, $42, $4A, $62
	db $62, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6
	db $82, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $10, $10
	db $10, $00

; ---- data $7271-$7740 (1231 bytes) [CONFIRMED] read as data by executed code (in up to 3/18 scenarios); content class unknown [clipped from 7240-7740 by higher-priority evidence]

Data_71_7271:: ; 71:7271
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $82, $38, $38, $7C, $44, $C6, $82, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3C, $3C, $7E, $42, $C2, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $C6, $10, $92, $38, $AA, $38, $28, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $03, $F8, $F9, $FC, $84, $86, $82, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $01, $7C, $7C, $FE, $82, $82, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $72
	db $52, $5A, $4A, $4E, $46, $46, $42, $42, $52, $42, $5A, $42, $18, $00, $18, $82
	db $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $01, $00, $83, $10
	db $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $C6, $00, $C6, $80
	db $80, $FC, $FD, $FC, $81, $80, $81, $80, $80, $FE, $FE, $FE, $00, $00, $00, $00
	db $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF, $82
	db $92, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82, $80
	db $81, $FC, $FD, $FC, $81, $80, $81, $80, $BF, $80, $BF, $80, $3F, $00, $3F, $00
	db $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FF, $00, $FF, $80
	db $98, $80, $BE, $80, $BE, $80, $98, $C2, $42, $7E, $3C, $3C, $00, $00, $80, $82
	db $82, $FE, $FE, $FE, $82, $82, $82, $82, $BA, $82, $BA, $82, $38, $00, $38, $6C
	db $44, $6C, $44, $C6, $82, $FE, $FE, $FE, $82, $82, $82, $82, $38, $00, $38, $82
	db $B2, $86, $84, $FC, $F8, $FC, $84, $86, $82, $82, $B2, $82, $38, $00, $38, $80
	db $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80, $80
	db $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00, $80
	db $80, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $01, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $08
	db $F1, $08, $F1, $08, $F1, $F8, $F1, $88, $81, $08, $F1, $08, $F1, $08, $F1, $10
	db $8F, $10, $8F, $10, $8F, $1F, $8F, $18, $88, $10, $8F, $10, $8F, $10, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $FE, $82, $82, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $BA, $82, $BA, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $92, $C6, $D6, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $F8, $F8, $FC, $84, $86, $82, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $01, $7C, $7C, $7C, $10, $10, $10, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $7C, $7C, $FE, $82, $82, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $10, $10, $10, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $FE, $FE, $FE, $80, $80, $80, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $03, $F8, $F9, $FC, $84, $86, $82, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $00, $7C, $7C, $7C, $10, $10, $10, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $38, $82, $BA, $82, $9A, $C2, $CA, $80
	db $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00, $80
	db $80, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $01, $82
	db $BA, $82, $BA, $82, $BA, $82, $92, $C6, $44, $7C, $38, $38, $00, $00, $82, $C6
	db $C6, $EE, $AA, $AA, $AA, $BA, $92, $92, $92, $92, $82, $82, $00, $00, $38, $80
	db $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00, $00
	db $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $00, $FE, $82
	db $B2, $86, $84, $FC, $F8, $FC, $84, $86, $82, $82, $B2, $82, $38, $00, $38, $80
	db $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00, $80
	db $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80, $10
	db $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $01, $80
	db $80, $FC, $7C, $7E, $02, $02, $02, $82, $82, $FE, $7C, $7C, $00, $00, $01, $10
	db $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $D6, $10, $C6, $00, $C6, $80
	db $80, $FC, $FC, $FC, $80, $80, $80, $80, $80, $FE, $FE, $FE, $00, $00, $00, $82
	db $B2, $86, $84, $FC, $F8, $FC, $84, $86, $82, $82, $82, $82, $38, $00, $38, $10
	db $D6, $10, $D6, $10, $D6, $10, $D6, $10, $10, $7C, $7C, $7C, $00, $00, $00, $E2
	db $A2, $B2, $92, $9A, $8A, $8E, $86, $86, $A2, $82, $B2, $82, $38, $00, $38, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $02, $78, $78, $7C, $44, $46, $42, $00
	db $FF, $00, $FF, $00, $FF, $00, $FF, $00, $80, $3E, $3E, $7E, $40, $C0, $80, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1, $90
	db $8F, $90, $8F, $90, $8F, $9F, $8F, $98, $88, $90, $8F, $90, $8F, $90, $8F, $42
	db $52, $46, $44, $7C, $78, $7C, $44, $46, $42, $42, $52, $42, $18, $00, $18, $80
	db $80, $9E, $9E, $9E, $82, $82, $82, $C2, $42, $7E, $3E, $3E, $00, $00, $80, $09
	db $F1, $09, $F1, $09, $F1, $F9, $F1, $89, $81, $09, $F1, $09, $F1, $09, $F1
