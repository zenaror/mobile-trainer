; engine/comm/connect_dialog_screen.asm
; bank 57, $47A6-$5641 (3739 bytes); pinned by layout.link
; connect dialog screen drawing, password field, caret sprites, saved password store

SECTION "engine/comm/connect_dialog_screen", ROMX

ConnectDialog_DrawScreen:: ; 57:47A6

	; [CONFIRMED] 15 insn(s); 15 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wConnectDialog_Mode]
	cp a, $02
	jr c, ConnectDialog_Draw_ConnectConfirm
	jp z, ConnectDialog_Draw_ConnectConfirm
	cp a, $04
	jp c, ConnectDialog_Draw_ConnectConfirm
	jp z, ConnectDialog_Draw_ConnectConfirm
	cp a, $06
	jp c, ConnectDialog_Draw_PasswordEntry
	jp z, ConnectDialog_Draw_PasswordEntry
	cp a, $08
	jp c, ConnectDialog_Draw_SavePasswordConfirm
	jp z, ConnectDialog_Draw_PasswordSaved
	cp a, $0A
	jp c, ConnectDialog_Draw_StoredPassword

	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 0;
	; fall-through of the jpcc at 57:47CA (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 47CD-47D1 by apply_coverage --split [executed in 6 scenarios]
	jp z, ConnectDialog_Draw_ForgetConfirm

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47CD-47D1 by apply_coverage --split
	ret

ConnectDialog_Draw_ConnectConfirm:: ; 57:47D1
	; [CONFIRMED] 144 insn(s); 144 executed (in up to 6/18 scenarios)
	ld de, $9001
	ld hl, Gfx_ConnectDialog_ConnectConfirm_Tiles9000Vb1
	ld a, BANK(Gfx_ConnectDialog_ConnectConfirm_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_ConnectDialog_ConnectConfirm_Tiles9400Vb1
	ld a, BANK(Gfx_ConnectDialog_ConnectConfirm_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_ConnectConfirm_56_4F9A
	ld a, BANK(Tilemap_ConnectDialog_ConnectConfirm_56_4F9A)
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ld hl, wSpriteSlot4
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $85
	farcall Sprite_InitSlot
	ld de, $6828
	ld hl, wSpriteSlot4
	call Sprite_SetPosition
	ld a, $00
	ld bc, $0410
	ld de, $0000
	ld hl, wScreenTileMap + $A2
	farcall Tilemap_FillRectSequential
	ld a, $40
	ld bc, $0210
	ld de, $0000
	ld hl, wScreenTileMap + $142
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_Messages
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_Messages)
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, [wConnectDialog_Mode]
	cp a, $04
	jr z, .draw_argument_byte6_digits
	ld a, $92
	ld [wConnectDialog_AttrSrc], a
	ld a, $52
	ld [wConnectDialog_AttrSrcHi], a
	ld bc, $0214
	ld de, wScreenTileMap + $200
	ld hl, Tilemap_ConnectDialog_ConnectConfirm_56_526A
	ld a, BANK(Tilemap_ConnectDialog_ConnectConfirm_56_526A)
	farcall Tilemap_CopyRectAndAttrPtr
	jp ConnectDialog_Draw_Finish
.draw_argument_byte6_digits ; 57:4914
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wConnectDialogArgPtr]
	ld l, a
	ld a, [wConnectDialogArgPtr + 1]
	ld h, a
	ld a, [wConnectDialogArgBank]
	ld de, $0006
	add hl, de
	call ReadByteFar
	farcall Bcd_FromBinary8
	ld d, a
	and a, $0F
	add a, a
	add a, $5A
	ld [wScreenTileMap + $20D], a
	inc a
	ld [wScreenTileMap + $22D], a
	ld a, d
	swap a
	and a, $0F
	add a, a
	add a, $5A
	ld [wScreenTileMap + $20C], a
	inc a
	ld [wScreenTileMap + $22C], a
	jp ConnectDialog_Draw_Finish

ConnectDialog_Draw_PasswordEntry:: ; 57:4951
	; [CONFIRMED] 360 insn(s) reached by static flow only; seeds: exec x360; min discovery hops 1;
	; entered by jpcc from 57:47BA (executed) [executed in 1 scenarios]
	ld a, [wConnectDialog_PrevMode]
	cp a, $05
	jp z, .reinit_caret_sprites
	cp a, $06
	jp z, .reinit_caret_sprites
	ld de, $8800
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $8C10
	ld hl, ConnectDialog_BlankTile
	ld a, BANK(ConnectDialog_BlankTile)
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $9101
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call ConnectDialog_RenderTypedChars
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_418A
	ld a, BANK(Tilemap_ConnectDialog_56_418A)
	farcall Tilemap_CopyRectAndAttr
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg + $40 ; 56:7800
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_PasswordEntryPrompt
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_PasswordEntryPrompt)
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $1F
	ld [wScreenTileMap + $122], a
	ld a, $2F
	ld [wScreenTileMap + $142], a
	ld a, $08
	ld [wScreenAttrMap + $122], a
	ld [wScreenAttrMap + $142], a
	ld hl, wSpriteSlot3
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $80
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call ConnectDialog_PlaceCaretSprites
	jp ConnectDialog_Draw_Finish
.reinit_caret_sprites ; 57:4AA3
	ld hl, wSpriteSlot3
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $80
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call ConnectDialog_PlaceCaretSprites
	ret

ConnectDialog_Draw_SavePasswordConfirm:: ; 57:4AC7
	ld a, [wConnectDialog_PrevMode]
	cp a, $08
	jp nz, .load_save_confirm_map
	ld de, $8800
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $8C10
	ld hl, ConnectDialog_BlankTile
	ld a, BANK(ConnectDialog_BlankTile)
	ld b, $98
	ld c, $01
	farcall Gfx_StartHDMAWithService
	ld de, $9101
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call ConnectDialog_RenderTypedChars
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_418A
	ld a, BANK(Tilemap_ConnectDialog_56_418A)
	farcall Tilemap_CopyRectAndAttr
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, wScreenTileMap + $122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_PasswordEntryPrompt
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_PasswordEntryPrompt)
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $1F
	ld [wScreenTileMap + $122], a
	ld a, $2F
	ld [wScreenTileMap + $142], a
	ld a, $08
	ld [wScreenAttrMap + $122], a
	ld [wScreenAttrMap + $142], a
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call ConnectDialog_DrawPasswordField
.load_save_confirm_map ; 57:4BF3
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_49FA
	ld a, BANK(Tilemap_ConnectDialog_56_49FA)
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg + $40 ; 56:7800
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ld a, [wConnectDialog_PrevMode]
	cp a, $06
	jr nz, .render_save_confirm_prompt
	call VBlank_WaitStartDI
	ld hl, wPaletteBufBg
	farcall Palette_UploadBuffer
	ei
	call Sound_FrameService
.render_save_confirm_prompt ; 57:4C2C
	ld a, $80
	ld bc, $0610
	ld de, $F00E
	ld hl, wScreenTileMap + $102
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $8801
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_SavePasswordConfirm
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_SavePasswordConfirm)
	farcall TextTiles_RenderGrid
	ld de, $8801
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, wScreenTileMap
	ld de, $9800
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, wScreenTileMap + $20
	ld de, $9820
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, wScreenTileMap + $40
	ld de, $9840
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld de, $9C00
	ld hl, wScreenTileMap + $E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Gfx_StartHDMAWithService
	ld de, $9C01
	ld hl, wScreenAttrMap + $E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Gfx_StartHDMAWithService
	jp ConnectDialog_Draw_SaveForgetConfirm_Tail

; ---- zero $4D28-$4D30 (8 bytes) [PROBABLE] 8 zero bytes of padding before the tile block 4D30
	ds $8, $00

; ---- gfx $4D30-$4D40 (16 bytes) [CONFIRMED] tiles-vram: 2 call site(s) (57:497C 57:4AED); first: hdma_rom_to_vram at 57:497C: hl=$4D30 a=$57 c=$01 de=$8C10 (dest VRAM $8C10, vbank=0) [first call site executed: 99 hits in 4 scenarios (analysis/coverage_union.tsv)]

ConnectDialog_BlankTile:: ; 57:4D30
	INCBIN "gfx/comm/connect_dialog_screen/connect_dialog_blank_tile.2bpp"

ConnectDialog_Draw_PasswordSaved:: ; 57:4D40
	; [CONFIRMED] 99 insn(s) reached by static flow only; seeds: exec x99; min discovery hops 1;
	; entered by jpcc from 57:47C5 (executed) [executed in 3 scenarios]
	ld de, $9101
	ld hl, Gfx_ConnectDialog_PasswordSaved_Tiles9100Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordSaved_Tiles9100Vb1)
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_ConnectDialog_PasswordSaved_Tiles9400Vb1
	ld a, BANK(Gfx_ConnectDialog_PasswordSaved_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_4CCA
	ld a, BANK(Tilemap_ConnectDialog_56_4CCA)
	farcall Tilemap_CopyRectAndAttr
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg + $40 ; 56:7800
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, wScreenTileMap + $122
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_PasswordSavedNotice
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_PasswordSavedNotice)
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $19
	ld [wScreenTileMap + $1A2], a
	ld a, $29
	ld [wScreenTileMap + $1C2], a
	ld a, $08
	ld [wScreenAttrMap + $1A2], a
	ld [wScreenAttrMap + $1C2], a
	jp ConnectDialog_Draw_Finish

ConnectDialog_Draw_StoredPassword:: ; 57:4E4C
	; [CONFIRMED] 100 insn(s); 100 executed (in up to 5/18 scenarios)
	ld de, $8800
	ld hl, Gfx_ConnectDialog_StoredPassword_Tiles8800
	ld a, BANK(Gfx_ConnectDialog_StoredPassword_Tiles8800)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9101
	ld hl, $67C0
	ld a, $56
	ld b, $94
	ld c, $30
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_ConnectDialog_StoredPassword_Tiles9400Vb1
	ld a, BANK(Gfx_ConnectDialog_StoredPassword_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_445A
	ld a, BANK(Tilemap_ConnectDialog_56_445A)
	farcall Tilemap_CopyRectAndAttr
	call ConnectDialog_DrawPasswordField
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg + $40 ; 56:7800
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_StoredPasswordNotice
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_StoredPasswordNotice)
	farcall TextTiles_RenderGrid
	ld de, $9000
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9400
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld a, $19
	ld [wScreenTileMap + $1A2], a
	ld a, $29
	ld [wScreenTileMap + $1C2], a
	ld a, $08
	ld [wScreenAttrMap + $1A2], a
	ld [wScreenAttrMap + $1C2], a
	jp ConnectDialog_Draw_Finish

ConnectDialog_Draw_ForgetConfirm:: ; 57:4F59
	; [CONFIRMED] 106 insn(s) reached by static flow only; seeds: exec x106; min discovery hops 1;
	; entered by jpcc from 57:47CD (PROBABLE code) [executed in 4 scenarios]
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_472A
	ld a, BANK(Tilemap_ConnectDialog_56_472A)
	farcall Tilemap_CopyRectAndAttr
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, Palette_ConnectDialog_Bg + $40 ; 56:7800
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ld a, $80
	ld bc, $0610
	ld de, $F00E
	ld hl, wScreenTileMap + $102
	farcall Tilemap_FillRectSequential
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0A00
	ld hl, wTileStage2
	call FillBytes
	ld de, $8801
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, wTileStage2
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld bc, $0400
	ld hl, wTileStage2
	call FillBytes
	ld hl, String_ConnectDialog_CancelPasswordStorageConfirm
	ld bc, $0010
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_ConnectDialog_CancelPasswordStorageConfirm)
	farcall TextTiles_RenderGrid
	ld de, $8801
	ld hl, wTileStage2
	ld a, $00
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, wTileStage2 + $400
	ld a, $00
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ld hl, wScreenTileMap
	ld de, $9800
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, wScreenTileMap + $20
	ld de, $9820
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld hl, wScreenTileMap + $40
	ld de, $9840
	ld b, $98
	ld c, $02
	call ConnectDialog_UploadMapRow
	ld de, $9C00
	ld hl, wScreenTileMap + $E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Gfx_StartHDMAWithService
	ld de, $9C01
	ld hl, wScreenAttrMap + $E0
	ld a, $00
	ld b, $96
	ld c, $16
	farcall Gfx_StartHDMAWithService
	jp ConnectDialog_Draw_SaveForgetConfirm_Tail

ConnectDialog_Draw_Finish:: ; 57:5077
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 6/18 scenarios)
	ld de, $8000
	ld hl, Gfx_ConnectDialog_Finish_Tiles8000
	ld a, BANK(Gfx_ConnectDialog_Finish_Tiles8000)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_ConnectDialog_Bg + $80 ; 56:7840
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld a, [wConnectDialog_PrevMode]
	cp a, $05
	jr nc, .check_password_mode_transition
.fade_in_screen ; 57:50A6
	farcall Sprite_UpdateAll
	farcall Palette_FadeInFromWhite
	ret
.check_password_mode_transition ; 57:50B3
	ld a, [wConnectDialog_Mode]
	cp a, $05
	jr c, .fade_in_screen

	; [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 0;
	; fall-through of the jrcc at 57:50B8 (executed) [executed in 1 scenarios]
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	jr z, .check_return_from_forget_confirm
	call ConnectDialog_HideLowerWindow
	ld a, [wConnectDialog_Mode]
	cp a, $08
	jr z, .fade_in_screen
.check_return_from_forget_confirm ; 57:50CA
	ld a, [wConnectDialog_PrevMode]
	cp a, $0A
	ret nz
	ld a, [wConnectDialog_Mode]
	cp a, $05
	jr z, .fade_in_screen
	ret

ConnectDialog_Draw_SaveForgetConfirm_Tail:: ; 57:50D8
	ld de, $8000
	ld hl, Gfx_ConnectDialog_Finish_Tiles8000
	ld a, BANK(Gfx_ConnectDialog_Finish_Tiles8000)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, Palette_ConnectDialog_Bg + $80 ; 56:7840
	ld a, BANK(Palette_ConnectDialog_Bg)
	farcall Palette_LoadToBuffer
	call ConnectDialog_DrawPasswordField
	ld a, [wConnectDialog_PrevMode]
	cp a, $08
	jr nz, .show_lower_window
	farcall Palette_FadeInFromWhite
.show_lower_window ; 57:510B
	call ConnectDialog_ShowLowerWindow
	ret

ConnectDialog_DrawPasswordField:: ; 57:510F

	; [CONFIRMED] 15 insn(s); 15 executed (in up to 5/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wConnectDialog_Mode]
	cp a, $02
	jr c, .done
	jp z, .done
	cp a, $04
	jp c, .done
	jp z, .done
	cp a, $06
	jp c, .load_entry_field_map
	jp z, .load_entry_field_map
	cp a, $08
	jp c, .load_save_confirm_field_map
	jp z, .load_password_saved_field_map
	cp a, $0A
	jp c, .load_stored_password_field_map

	; [CONFIRMED] 26 insn(s) reached by static flow only; seeds: exec x26; min discovery hops 0;
	; fall-through of the jpcc at 57:5133 (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 5136-5187 by apply_coverage --split [executed in 6 scenarios]
	jp z, .load_forget_confirm_field_map

	; [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5136-5187 by apply_coverage --split
	ret
.done ; 57:513A
	ret

.load_entry_field_map ; 57:513B
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 5136-5187 by apply_coverage
	; --split [executed in 3 scenarios]
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_418A
	ld a, BANK(Tilemap_ConnectDialog_56_418A)
	farcall Tilemap_CopyRectAndAttr
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, wScreenTileMap + $122
	farcall Tilemap_FillRectSequential
	jp .draw_remaining_field_cells
.load_save_confirm_field_map ; 57:5160
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_49FA
	ld a, BANK(Tilemap_ConnectDialog_56_49FA)
	farcall Tilemap_CopyRectAndAttr
	jp .draw_remaining_field_cells
.load_password_saved_field_map ; 57:5174
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_4CCA
	ld a, BANK(Tilemap_ConnectDialog_56_4CCA)
	farcall Tilemap_CopyRectAndAttr
	jr .draw_used_field_cells

.load_stored_password_field_map ; 57:5187
	; [CONFIRMED] 11 insn(s); 11 executed (in up to 5/18 scenarios)
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_445A
	ld a, BANK(Tilemap_ConnectDialog_56_445A)
	farcall Tilemap_CopyRectAndAttr
	ld a, $00
	ld bc, $0610
	ld de, $0000
	ld hl, wScreenTileMap + $122
	farcall Tilemap_FillRectSequential
	jr .draw_used_field_cells

.load_forget_confirm_field_map ; 57:51AB
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jpcc from 57:5136 (PROBABLE code) [executed in 4 scenarios]
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_ConnectDialog_56_472A
	ld a, BANK(Tilemap_ConnectDialog_56_472A)
	farcall Tilemap_CopyRectAndAttr

.draw_used_field_cells ; 57:51BC
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 5/18 scenarios)
	ld a, [wConnectDialogTextLen]
	or a, a
	jr z, .upload_used_field_rows
	ld c, a
	ld b, c
	ld hl, wScreenTileMap + $86
	ld a, $11
.fill_used_top_tiles ; 57:51C9
	ld [hli], a
	dec c
	jr nz, .fill_used_top_tiles
	ld c, b
	ld hl, wScreenTileMap + $A6
	inc a
.fill_used_bottom_tiles ; 57:51D2
	ld [hli], a
	dec c
	jr nz, .fill_used_bottom_tiles
	ld c, b
	ld hl, wScreenAttrMap + $86
	ld a, $08
.fill_used_top_attrs ; 57:51DC
	ld [hli], a
	dec c
	jr nz, .fill_used_top_attrs
	ld c, b
	ld hl, wScreenAttrMap + $A6
.fill_used_bottom_attrs ; 57:51E4
	ld [hli], a
	dec c
	jr nz, .fill_used_bottom_attrs
.upload_used_field_rows ; 57:51E8
	ld de, $9880
	ld hl, wScreenTileMap + $80
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ld de, $9881
	ld hl, wScreenAttrMap + $80
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ret

.draw_remaining_field_cells ; 57:520D
	; [CONFIRMED] 114 insn(s) reached by static flow only; seeds: exec x114; min discovery hops 2;
	; entered by jp from 57:515D (PROBABLE code) [executed in 4 scenarios]
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr z, .upload_remaining_field_rows
	ld c, a
	ld hl, wScreenTileMap + $86
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	push hl
	ld a, $08
	sub a, c
	ld c, a
	ld b, c
	ld a, $22
.fill_remaining_top_tiles ; 57:5226
	ld [hli], a
	dec c
	jr nz, .fill_remaining_top_tiles
	ld c, b
	pop hl
	push hl
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $10
.fill_remaining_bottom_tiles ; 57:5237
	ld [hli], a
	dec c
	jr nz, .fill_remaining_bottom_tiles
	ld c, b
	pop hl
	ld a, $04
	add a, h
	ld h, a
	push hl
	ld a, $08
.fill_remaining_top_attrs ; 57:5244
	ld [hli], a
	dec c
	jr nz, .fill_remaining_top_attrs
	ld c, b
	pop hl
	ld a, $20
	add a, l
	ld l, a
	ld a, h
	adc a, $00
	ld h, a
	ld a, $08
.fill_remaining_bottom_attrs ; 57:5254
	ld [hli], a
	dec c
	jr nz, .fill_remaining_bottom_attrs
.upload_remaining_field_rows ; 57:5258
	ld de, $9880
	ld hl, wScreenTileMap + $80
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ld de, $9881
	ld hl, wScreenAttrMap + $80
	ld a, $00
	ld b, $98
	ld c, $04
	farcall Gfx_StartHDMAWithService
	ret

ConnectDialog_PlaceCaretSprites:: ; 57:527D
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wSpriteSlot2
	ld a, [wRam_C1CC]
	add a, $1E
	ld d, a
	ldh a, [rWY]
	cp a, $28
	jr nz, .position_caret_slot2
	ld a, $F8
	add a, d
	ld d, a
.position_caret_slot2 ; 57:529D
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, a
	add a, a
	add a, $32
	ld e, a
	farcall Sprite_SetPosition
	ld hl, wSpriteSlot3
	ld a, [wRam_C1CC]
	add a, $1E
	ld d, a
	ldh a, [rWY]
	cp a, $28
	jr nz, .position_caret_slot3
	ld a, $F8
	add a, d
	ld d, a
.position_caret_slot3 ; 57:52BF
	ld a, [wConnectDialogTextLen]
	add a, a
	add a, a
	add a, a
	add a, $30
	ld e, a
	farcall Sprite_SetPosition
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

ConnectDialog_ObjHook_Caret:: ; 57:52D8
	; [CONFIRMED] 18 insn(s): function (ldh [$FFF2],a ; ldh a,[$FF8D] ; push af ; ... ld hl,$DA20 ;
	; ld de,$79B8 ; ld a,$56 ; ld b,$81) falling into the FarCall site at 57:52FB (00:0A82
	; init_object_from_table); well-formed instruction chain (clean decode, all direct targets land
	; on instruction starts, lands exactly on the next code region); entry evidence (verifier): a
	; far pointer to this address is registered with `ld de,$52D8 ; ld a,$57 ; call $0A45` (00:0A45
	; stores de/a as a 3-byte far pointer at [hl]) at 57:42C3 and 57:4372, all static-reached (not
	; executed); PROBABLE [executed in 4 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld bc, $000F
	add hl, bc
	ld a, [hl]
	cp a, $FF
	jr z, .reset_caret_slot2
	or a, a
	jr nz, .restore_wram_bank
.reset_caret_slot2 ; 57:52F1
	ld hl, wSpriteSlot2
	ld de, ConnectDialog_ObjTable
	ld a, BANK(ConnectDialog_ObjTable)
	ld b, $81

	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: site x14; min discovery hops 0; run
	; starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code
	; [executed in 4 scenarios]
	farcall Sprite_InitSlot
	ld hl, wSpriteSlot2 + $0B
	ld de, ConnectDialog_ObjHook_FollowRaster
	ld a, BANK(ConnectDialog_ObjHook_FollowRaster)
	call Sprite_SetHook
	call ConnectDialog_PlaceCaretSprites
	ld a, $01
	ld [wConnectDialog_FieldDirty], a
.restore_wram_bank ; 57:5314
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

ConnectDialog_ObjHook_FollowRaster:: ; 57:531E
	; [CONFIRMED] 17 insn(s): complete function ending in ret (same WRAM7 bank save/restore
	; prologue/epilogue as 57:52D8); well-formed instruction chain (clean decode, all direct targets
	; land on instruction starts, lands exactly on the next code region); entry evidence (verifier):
	; a far pointer to this address is registered with `ld de,$531E ; ld a,$57 ; call $0A45`
	; (00:0A45 stores de/a as a 3-byte far pointer at [hl]) at 57:5304, 57:43A8 and 57:4553, all
	; static-reached (not executed); PROBABLE [executed in 4 scenarios]
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, [wConnectDialog_RasterOffset]
	add a, $15
	ld [wSpriteSlot2], a
	ld [wSpriteSlot3], a
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

ConnectDialog_ShowLowerWindow:: ; 57:5340
	; [CONFIRMED] 122 insn(s) reached by static flow only; seeds: exec x122; min discovery hops 1;
	; entered by call from 57:510B (PROBABLE code) | 117 insn(s) executed; cut out of the PROBABLE
	; region 5340-541C by apply_coverage --split [executed in 2 scenarios]
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	ret nz
	ldh a, [rLCDC]
	or a, $60
	ldh [rLCDC], a
	ld a, $38
	ldh [rWY], a
	ld a, $01
	ld [wConnectDialogLowerWindowShown], a
	ret

ConnectDialog_HideLowerWindow:: ; 57:5355
	ld a, [wConnectDialogLowerWindowShown]
	or a, a
	ret z
	ldh a, [rLCDC]
	or a, $60
	ldh [rLCDC], a
	ld a, $90
	ldh [rWY], a
	xor a, a
	ld [wConnectDialogLowerWindowShown], a
	ret

ConnectDialog_ValidatePassword:: ; 57:5369
	ld b, $00
	ld c, $00
	ld a, [wConnectDialogTextLen]
	cp a, $04
	ret c
	ld e, a
	ld hl, wConnectDialogText
.digit_scan_loop ; 57:5377
	ld a, [hli]
	cp a, $30
	jr c, .next_digit_candidate
	cp a, $3A
	jr c, .begin_lowercase_scan
.next_digit_candidate ; 57:5380
	dec e
	jr nz, .digit_scan_loop
	ret
.begin_lowercase_scan ; 57:5384
	ld hl, wConnectDialogText
	ld a, [wConnectDialogTextLen]
	ld e, a
.lowercase_scan_loop ; 57:538B
	ld a, [hli]
	cp a, $61
	jr c, .next_lowercase_candidate
	cp a, $7B
	jr c, .set_valid_password_flags
.next_lowercase_candidate ; 57:5394
	dec e
	jr nz, .lowercase_scan_loop
	ld hl, wConnectDialogText
	ld a, [wConnectDialogTextLen]
	ld e, a
.uppercase_scan_loop ; 57:539E
	ld a, [hli]
	cp a, $41
	jr c, .next_uppercase_candidate
	cp a, $5B
	jr c, .set_valid_password_flags
.next_uppercase_candidate ; 57:53A7
	dec e
	jr nz, .uppercase_scan_loop
	ld c, $00
	ret
.set_valid_password_flags ; 57:53AD
	ld a, [wConnectDialogTextLen]
	cp a, $08
	jr nz, .mark_valid_password
	ld c, $01
.mark_valid_password ; 57:53B6
	ld b, $01
	ret

ConnectDialog_RefreshFieldIfDirty:: ; 57:53B9
	ld a, [wConnectDialog_FieldDirty]
	or a, a
	ret z
	call ConnectDialog_DrawPasswordField
	xor a, a
	ld [wConnectDialog_FieldDirty], a
	ret

ConnectDialog_UploadMapRow:: ; 57:53C6
	ld a, h
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, $00
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ldh a, [rLCDC]
	bit 7, a
	jr z, .upload_tile_and_attr_row
.wait_ly_at_least_91 ; 57:53E3
	ldh a, [rLY]
	cp a, $91
	jr c, .wait_ly_at_least_91
	cp a, b
	jr nc, .wait_ly_below_91
.upload_tile_and_attr_row ; 57:53EC
	ld a, c
	ldh [rHDMA5], a
	inc c
	ld a, h
	add a, $04
	ldh [rHDMA1], a
	ld a, l
	ldh [rHDMA2], a
	ld a, d
	ldh [rHDMA3], a
	ld a, e
	and a, $F0
	ldh [rHDMA4], a
	ld a, $01
	and a, $01
	ldh [hVRAMBank], a
	ldh [rVBK], a
	dec c
	ld a, c
	ldh [rHDMA5], a
	inc c
	call Sound_FrameService
	ret

.wait_ly_below_91 ; 57:5411
	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5340-541C by apply_coverage --split
	ldh a, [rLY]
	cp a, $91
	jr nc, .wait_ly_below_91
	call Sound_FrameService
	jr .wait_ly_at_least_91

SavedPassword_Store:: ; 57:541C

	; [CONFIRMED] 20 insn(s); 20 executed (in up to 3/18 scenarios); entry proven: target of an
	; executed call/far call
	or a, a
	jr z, .store_length_from_bc
	cp a, $09
	ret nc
	push af
	ld hl, sSavedPasswordText
	ld c, a
.store_next_encoded_byte ; 57:5427
	ld a, [de]
	xor a, $5A
	ld b, a
	inc de
	ld a, $01
	farcall WriteByteFar
	dec c
	jr nz, .store_next_encoded_byte
.store_length_from_bc ; 57:5437
	pop bc
	ld a, $01
	ld hl, sSavedPasswordLen
	farcall WriteByteFar
	ret

ConnectDialog_RenderTypedChars:: ; 57:5444
	; [CONFIRMED] 14 insn(s) reached by static flow only; seeds: exec x14; min discovery hops 3;
	; entered by call from 57:4308 (PROBABLE code) [executed in 4 scenarios]
	ld hl, wConnectDialogGlyphs
	ld bc, $0008
	ld de, wTileStage2
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $00
	farcall TextTiles_RenderGrid
	ld de, $9701
	ld hl, wTileStage2
	ld a, $02
	ld b, $97
	ld c, $10
	farcall Gfx_StartHDMAWithService
	ret

ConnectDialog_PlayButtonSfx:: ; 57:546C

	; [CONFIRMED] 16 insn(s); 16 executed (in up to 6/18 scenarios); entry proven: target of an
	; executed call/far call
	; Modes 0-10 select their button handlers; nonzero B plays cancel, zero plays confirm, except
	; mode 7/cursor 1 plays save. Mode 10 cannot reach SFX_DELETE from this entry.
	ld b, a
	ld a, [wConnectDialog_Mode]
	cp a, $02
	jr c, .modes_0_1_confirm_dispatch
	jp z, .mode_2_confirm_dispatch
	cp a, $04
	jp c, .connect_confirm_buttons
	jp z, .connect_confirm_with_count_buttons
	cp a, $06
	jp c, .password_prompt_buttons
	jp z, .keyboard_mode_buttons
	cp a, $08
	jp c, .save_confirm_buttons
	jp z, .password_saved_buttons
	cp a, $0A
	jp c, .stored_password_buttons

	; [CONFIRMED] 44 insn(s) reached by static flow only; seeds: exec x44; min discovery hops 0;
	; fall-through of the jpcc at 57:5491 (executed) | 1 insn(s) executed; cut out of the PROBABLE
	; region 5494-54E4 by apply_coverage --split [executed in 6 scenarios]
	jp z, .forget_confirm_buttons

	; [PROBABLE] 43 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5494-54E4 by apply_coverage --split
	ret
.modes_0_1_confirm_dispatch ; 57:5498
	xor a, a
	or a, b
	jr nz, .modes_0_1_cancel_sfx
	play_sfx SFX_CONFIRM
	ret
.modes_0_1_cancel_sfx ; 57:54AD
	play_sfx SFX_CANCEL
	ret
.mode_2_confirm_dispatch ; 57:54BE
	xor a, a
	or a, b
	jr nz, .mode_2_cancel_sfx
	play_sfx SFX_CONFIRM
	ret
.mode_2_cancel_sfx ; 57:54D3
	play_sfx SFX_CANCEL
	ret

.connect_confirm_buttons ; 57:54E4
	; [CONFIRMED] 12 insn(s); 12 executed (in up to 2/18 scenarios)
	xor a, a
	or a, b
	jr nz, .connect_confirm_cancel
	play_sfx SFX_CONFIRM
	ret

.connect_confirm_cancel ; 57:54F9
	; [CONFIRMED] 9 insn(s) reached by static flow only; seeds: exec x9; min discovery hops 1;
	; entered by jrcc from 57:54E6 (executed) [executed in 5 scenarios]
	play_sfx SFX_CANCEL
	ret

.connect_confirm_with_count_buttons ; 57:550A
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 4/18 scenarios)
	xor a, a
	or a, b
	jr nz, .connect_confirm_with_count_cancel
	play_sfx SFX_CONFIRM
	ret
.connect_confirm_with_count_cancel ; 57:551F
	play_sfx SFX_CANCEL
	ret

.password_prompt_buttons ; 57:5530
	; [CONFIRMED] 96 insn(s) reached by static flow only; seeds: exec x96; min discovery hops 1;
	; entered by jpcc from 57:5481 (executed) | 21 insn(s) executed; cut out of the PROBABLE region
	; 5530-55E0 by apply_coverage --split [executed in 4 scenarios]
	xor a, a
	or a, b
	jr nz, .password_prompt_cancel
	play_sfx SFX_CONFIRM
	ret
.password_prompt_cancel ; 57:5545
	play_sfx SFX_CANCEL
	ret

.keyboard_mode_buttons ; 57:5556
	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5530-55E0 by apply_coverage --split
	xor a, a
	or a, b
	jr nz, .keyboard_mode_cancel
	play_sfx SFX_CONFIRM
	ret
.keyboard_mode_cancel ; 57:556B
	play_sfx SFX_CANCEL
	ret

.save_confirm_buttons ; 57:557C
	; [CONFIRMED] 15 insn(s) executed; cut out of the PROBABLE region 5530-55E0 by apply_coverage
	; --split [executed in 3 scenarios]
	xor a, a
	or a, b
	jr nz, .save_confirm_cancel
	ld a, [wConnectDialog_Cursor]
	cp a, $01
	jr nz, .save_confirm_other_cursor
	play_sfx SFX_SAVE
	ret

.save_confirm_other_cursor ; 57:5598
	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5530-55E0 by apply_coverage --split
	play_sfx SFX_CONFIRM
	ret

.save_confirm_cancel ; 57:55A9
	; [CONFIRMED] 30 insn(s) executed; cut out of the PROBABLE region 5530-55E0 by apply_coverage
	; --split [executed in 1 scenarios]
	play_sfx SFX_CANCEL
	ret
.password_saved_buttons ; 57:55BA
	xor a, a
	or a, b
	jr nz, .password_saved_cancel
	play_sfx SFX_CONFIRM
	ret
.password_saved_cancel ; 57:55CF
	play_sfx SFX_CANCEL
	ret

.stored_password_buttons ; 57:55E0
	; [CONFIRMED] 21 insn(s); 21 executed (in up to 5/18 scenarios)
	xor a, a
	or a, b
	jr nz, .stored_password_cancel
	play_sfx SFX_CONFIRM
	ret
.stored_password_cancel ; 57:55F5
	play_sfx SFX_CANCEL
	ret

.forget_confirm_buttons ; 57:5606
	; [CONFIRMED] 32 insn(s) reached by static flow only; seeds: exec x32; min discovery hops 1;
	; entered by jpcc from 57:5494 (PROBABLE code) | 5 insn(s) executed; cut out of the PROBABLE
	; region 5606-5641 by apply_coverage --split [executed in 5 scenarios]
	xor a, a
	or a, b
	jr nz, .forget_confirm_cancel
	cp a, $01
	jr nz, .forget_confirm_a_button

	; [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 5606-5641 by apply_coverage --split
	play_sfx SFX_DELETE ; unreachable: A = B = 0 here, so the `jr nz` above is always taken (the forget prompt plays SFX_CONFIRM at .forget_confirm_a_button)
	ret

.forget_confirm_a_button ; 57:561F
	; [CONFIRMED] 18 insn(s) executed; cut out of the PROBABLE region 5606-5641 by apply_coverage
	; --split [executed in 4 scenarios]
	play_sfx SFX_CONFIRM
	ret
.forget_confirm_cancel ; 57:5630
	play_sfx SFX_CANCEL
	ret
