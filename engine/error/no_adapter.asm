; engine/error/no_adapter.asm
; bank 63, $732F-$742F (256 bytes); pinned by layout.link
; no-adapter screen

SECTION "engine/error/no_adapter", ROMX

NoAdapter_ShowScreen:: ; 63:732F
Function_63_732F::
	; [CONFIRMED] 83 insn(s); 83 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call NoAdapter_DrawScreen
	farcall Palette_FadeInFromWhite
	call NoAdapter_WaitButton
	farcall Palette_FadeOutToWhite
	ret

NoAdapter_DrawScreen:: ; 63:7342
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wRam_C27C], a
	ld [wRam_C27D], a
	ld de, $8000
	ld hl, NoAdapter_Gfx_8000
	ld a, BANK(NoAdapter_Gfx_8000)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8801
	ld hl, NoAdapter_Gfx_8800
	ld a, BANK(NoAdapter_Gfx_8800)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, NoAdapter_Gfx_8C00
	ld a, BANK(NoAdapter_Gfx_8C00)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, NoAdapter_Gfx_9000
	ld a, BANK(NoAdapter_Gfx_9000)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, NoAdapter_Gfx_9400
	ld a, BANK(NoAdapter_Gfx_9400)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, NoAdapter_Palette_Bg
	ld a, BANK(NoAdapter_Palette_Bg)
	farcall Palette_LoadToBuffer
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, NoAdapter_Palette_Obj
	ld a, BANK(NoAdapter_Palette_Obj)
	farcall Palette_LoadToBuffer
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, NoAdapter_Tilemap
	ld a, BANK(NoAdapter_Tilemap)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot0
	ld de, NoAdapter_ObjTable
	ld a, BANK(NoAdapter_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $2040
	ld hl, wSpriteSlot0
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	xor a, a
	ldh [rSCX], a
	ldh [rSCY], a
	ret

NoAdapter_WaitButton:: ; 63:7413
	farcall Joypad_Update
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ldh a, [hJoyPressedRepeat]
	bit 0, a
	jr nz, .done
	bit 3, a
	jr nz, .done
	jr NoAdapter_WaitButton
.done ; 63:742E
	ret
