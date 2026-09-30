; engine/browser/frame_graphics.asm
; bank 4E, $6196-$661C (1158 bytes); pinned by layout.link
; frame graphics loader and the 27 frame descriptors

SECTION "engine/browser/frame_graphics", ROMX

Browser_LoadFrameGraphics:: ; 4E:6196
Function_4E_6196::
	; [CONFIRMED] 118 insn(s); 118 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call LCDOff
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	call LCDOn
	ld de, $8801
	ld hl, BrowserMenu3_Tiles0
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0000
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	push hl
	ld de, $9001
	ld b, $92
	ld c, $40
	ldh [hRam_FFB0], a
	farcall Gfx_StartHDMAWithService
	pop hl
	ld bc, $0400
	add hl, bc
	ld de, $9401
	ld b, $92
	ld c, $40
	ldh a, [hRam_FFB0]
	farcall Gfx_StartHDMAWithService
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $0040
	ld de, $D800
	farcall Palette_LoadToBuffer
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $1214
	ld de, $D000
	farcall Tilemap_CopyRectAndAttr
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld de, $8000
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $0040
	ld de, $D840
	farcall Palette_LoadToBuffer
	pop hl
	farcall Browser_ClearBodyArea
	farcall Browser_ClearTitleArea
	farcall Browser_DrawScrollbarTrack
	farcall Browser_UploadBodyCanvas
	farcall Browser_UploadTitleCanvas
	farcall Browser_LoadScrollbarGfx
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	xor a, a
	ld [wBrowserTimerSecToggle], a
	dec a
	ld [wBrowserTimerLastSec], a
	ret

Browser_FrameStylePreview_LoadGraphics:: ; 4E:6291
Function_4E_6291::
	; [PROBABLE] 346 insn(s) reached by static flow only; seeds: site x346; min discovery hops 0;
	; entered by far from 4E:4002 (PROBABLE code) | forced execution: 346/346 instruction starts ran
	; in forced_screens (traces/forced/, not natural evidence; status unchanged)
	call LCDOff
	ldh a, [rLCDC]
	and a, $9F
	ldh [rLCDC], a
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ld a, $07
	ldh [rWX], a
	ld a, $90
	ldh [rWY], a
	farcall Sprite_ResetAll
	call LCDOn
	ld de, $8801
	ld hl, BrowserMenu3_Tiles0
	ld a, $72
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh a, [hRam_FFD2]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0000
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	push hl
	ld de, $9001
	ld b, $92
	ld c, $40
	ldh [hRam_FFB0], a
	farcall Gfx_StartHDMAWithService
	pop hl
	ld bc, $0400
	add hl, bc
	ld de, $9401
	ld b, $92
	ld c, $40
	ldh a, [hRam_FFB0]
	farcall Gfx_StartHDMAWithService
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $0008
	add hl, bc
	ld bc, $0020
	ld de, $D808
	farcall Palette_LoadToBuffer
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $1214
	ld de, $D000
	farcall Tilemap_CopyRectAndAttr
	pop hl
	ldh a, [hRam_FFD2]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $000F
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $0512
	ld de, $0420
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $00A0
	add hl, bc
	ld bc, $0712
	ld de, $0480
	farcall Tilemap_FillAscendingWithAttr
	ldh a, [hRam_FFD2]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0011
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $010F
	ld de, $0100
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $0020
	add hl, bc
	ld bc, $010F
	ld de, $010F
	farcall Tilemap_FillAscendingWithAttr
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld de, $B000
	ld bc, $0800
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	call CopyBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0000
	add hl, bc
	pop bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	push hl
	ld de, $8801
	ld b, $92
	ld c, $40
	ldh [hRam_FFB0], a
	farcall Gfx_StartHDMAWithService
	pop hl
	ld bc, $0400
	add hl, bc
	ld de, $8C01
	ld b, $92
	ld c, $40
	ldh a, [hRam_FFB0]
	farcall Gfx_StartHDMAWithService
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	push af
	ld bc, $0008
	add hl, bc
	ld de, $D800
	farcall Palette_LoadToBuffer
	pop af
	ld bc, $0018
	ld de, $D828
	farcall Palette_LoadToBuffer
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $1214
	ld de, $D000
	farcall Tilemap_CopyRectAndAttr
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld de, $8000
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	push hl
	ld h, b
	ld l, c
	ld bc, $0040
	ld de, $D840
	farcall Palette_LoadToBuffer
	pop hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D000
	ld bc, $0400
.l6477 ; 4E:6477
	ld a, [hl]
	or a, $80
	ld [hli], a
	dec bc
	ld a, c
	or a, b
	jr nz, .l6477
	ld hl, $D400
	ld bc, $0400
.l6486 ; 4E:6486
	ld a, [hl]
	and a, $07
	add a, $43
	ld e, a
	ld a, $00
	adc a, $65
	ld d, a
	ld a, [de]
	ld e, a
	ld a, [hl]
	and a, $E0
	or a, e
	ld [hli], a
	dec bc
	ld a, c
	or a, b
	jr nz, .l6486
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $000F
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $0512
	ld de, $0720
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $00A0
	add hl, bc
	ld bc, $0712
	ld de, $0780
	farcall Tilemap_FillAscendingWithAttr
	ld de, $FFFF
	ld hl, $0000
	ld bc, $0C14
	farcall TileCanvas_FillRect
	ld a, [wBrowserFrameStyle]
	push bc
	and a, $7F
	ld c, a
	ld b, $00
	ld hl, Table_Browser_FrameDescriptors
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld bc, $0011
	add hl, bc
	pop bc
	ld a, [hli]
	ld h, [hl]
	ld l, a
	push hl
	ld bc, $010F
	ld de, $0000
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $0020
	add hl, bc
	ld bc, $010F
	ld de, $000F
	farcall Tilemap_FillAscendingWithAttr
	ld de, $0000
	ld hl, $1000
	ld bc, $0214
	farcall TileCanvas_FillRect
	farcall Browser_UploadBodyCanvas
	farcall Browser_UploadTitleCanvas
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersDi
	xor a, a
	ld [wBrowserTimerSecToggle], a
	dec a
	ld [wBrowserTimerLastSec], a
	ret

; ---- data $6543-$654B (8 bytes) [HYPOTHESIS] UNCLASSIFIED 10 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint) | observed: 8 bytes 08 08 0D 0E 0F 08 08 08 right before the descriptor pointer table 4E:654B and after the ret at 6542; no code word/immediate references them; left unclassified

Data_4E_6543:: ; 4E:6543
	db $08, $08, $0D, $0E, $0F, $08, $08, $08

; ---- ptrtable $654B-$6581 (54 bytes) [PROBABLE] 27 x dw screen-descriptor pointers indexed by (wRam_C2C2 & $7F)*2 (ld hl,$654B ; add hl,bc twice ; ld a,[hli] ; ld h,[hl] ; ld l,a at 4E:4026/4E:40D0/4E:5DA2/...; entries 1-2 are CONFIRMED read data, 654D-6551); the targets are the five descriptors 6581/65A0/65BF/65DE/65FD (31 bytes apart), extent 27 entries = up to 4E:6581 where the first descriptor starts [verifier: some of the 21 sites read the index from hD2 instead of wRam_C2C2 (e.g. 4E:40D0: ldh a,[$FFD2]), the table walk (ld bc = 2*(a&$7F)) is the same]

Table_Browser_FrameDescriptors:: ; 4E:654B
Table_4E_654B::
	dw Data_Browser_FrameDesc0
	dw Data_Browser_FrameDesc1
	dw Data_Browser_FrameDesc2
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc3
	dw Data_Browser_FrameDesc23
	dw Data_Browser_FrameDesc23
	dw Data_Browser_FrameDesc23
	dw Data_Browser_FrameDesc23

; ---- data $6581-$65A0 (31 bytes) [PROBABLE] screen descriptor of the table 4E:654B (31 bytes = 5 far pointers `dw addr ; db bank` (15 bytes) + 16 bytes of parameters): the far pointers name tile block, palette, tilemap, tile piece and OBJ palette inside bank 47 blocks (e.g. 47:4100 tiles, 47:4DD0 palettes, 47:4B00 tilemap, 47:4E10 = 4DD0+$40) exactly as laid out in config/regions/bank47.tsv

Data_Browser_FrameDesc0:: ; 4E:6581
Data_4E_6581::
	db $00, $41, $47, $D0, $4D, $47, $00, $4B, $47, $00, $49, $47, $10, $4E, $47, $61
	db $D0, $04, $D0, $48, $10, $48, $78, $70, $80, $08, $00, $73, $D0, $98, $18

; ---- data $65A0-$65BF (31 bytes) [PROBABLE] screen descriptor of the table 4E:654B (31 bytes = 5 far pointers `dw addr ; db bank` (15 bytes) + 16 bytes of parameters): the far pointers name tile block, palette, tilemap, tile piece and OBJ palette inside bank 47 blocks (e.g. 47:4100 tiles, 47:4DD0 palettes, 47:4B00 tilemap, 47:4E10 = 4DD0+$40) exactly as laid out in config/regions/bank47.tsv

Data_Browser_FrameDesc1:: ; 4E:65A0
Data_4E_65A0::
	db $50, $4E, $47, $20, $5B, $47, $50, $58, $47, $50, $56, $47, $60, $5B, $47, $61
	db $D0, $04, $D0, $48, $10, $48, $78, $70, $80, $08, $00, $73, $D0, $98, $18

; ---- data $65BF-$65DE (31 bytes) [PROBABLE] screen descriptor of the table 4E:654B (31 bytes = 5 far pointers `dw addr ; db bank` (15 bytes) + 16 bytes of parameters): the far pointers name tile block, palette, tilemap, tile piece and OBJ palette inside bank 47 blocks (e.g. 47:4100 tiles, 47:4DD0 palettes, 47:4B00 tilemap, 47:4E10 = 4DD0+$40) exactly as laid out in config/regions/bank47.tsv

Data_Browser_FrameDesc2:: ; 4E:65BF
Data_4E_65BF::
	db $A0, $5B, $47, $70, $68, $47, $A0, $65, $47, $A0, $63, $47, $B0, $68, $47, $61
	db $D0, $02, $D0, $48, $10, $48, $78, $71, $7A, $84, $00, $73, $D0, $98, $18

; ---- data $65DE-$65FD (31 bytes) [PROBABLE] screen descriptor of the table 4E:654B (31 bytes = 5 far pointers `dw addr ; db bank` (15 bytes) + 16 bytes of parameters): the far pointers name tile block, palette, tilemap, tile piece and OBJ palette inside bank 47 blocks (e.g. 47:4100 tiles, 47:4DD0 palettes, 47:4B00 tilemap, 47:4E10 = 4DD0+$40) exactly as laid out in config/regions/bank47.tsv

Data_Browser_FrameDesc3:: ; 4E:65DE
Data_4E_65DE::
	db $A0, $5B, $47, $70, $68, $47, $A0, $65, $47, $A0, $63, $47, $B0, $68, $47, $61
	db $D0, $02, $D0, $48, $10, $48, $78, $71, $7A, $84, $00, $73, $D0, $98, $18

; ---- data $65FD-$661C (31 bytes) [PROBABLE] screen descriptor of the table 4E:654B (31 bytes = 5 far pointers `dw addr ; db bank` (15 bytes) + 16 bytes of parameters): the far pointers name tile block, palette, tilemap, tile piece and OBJ palette inside bank 47 blocks (e.g. 47:4100 tiles, 47:4DD0 palettes, 47:4B00 tilemap, 47:4E10 = 4DD0+$40) exactly as laid out in config/regions/bank47.tsv

Data_Browser_FrameDesc23:: ; 4E:65FD
Data_4E_65FD::
	db $50, $4E, $47, $20, $5B, $47, $50, $58, $47, $50, $56, $47, $60, $5B, $47, $61
	db $D0, $04, $D0, $48, $10, $48, $78, $70, $7E, $00, $00, $73, $D0, $98, $18
