; engine/account/settings_menu.asm
; bank 68, $4F9E-$5296 (760 bytes); pinned by layout.link
; settings menu (Mobile Settings) run loop, cursor, item drawing

SECTION "engine/account/settings_menu", ROMX

SettingsMenu_Run:: ; 68:4F9E
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call (part of region $4F71-$4FC8)
	xor a, a
	ld [wRam_C279], a
	ld [wRam_C27B], a
	ld a, $01
	ld [wSavePasswordFlag], a
	xor a, a
	ld [wCommSessionActive], a
	ld hl, wBrowserTimerLastSec
	ld [hli], a
	ld [hl], a
	ld hl, wTimerAFrames
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hl], a
	farcall Joypad_Update
	; Hidden-mode switch at the entry of the Mobile Settings menu: B, Select and Right all held in hJoyHeld (every other button is ignored) store the flag in SRAM
	; (Settings_SetHiddenModeFlag) before the menu reads it back (executed in settings_phone and fuzz_register; docs/research/naming2_pad1.md)
	ldh a, [hJoyHeld]
	and a, PADF_B | PADF_SELECT | PADF_RIGHT
	cp a, PADF_B | PADF_SELECT | PADF_RIGHT
	jr nz, .l4FD6

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 68:4FC6 (executed) [executed in 1 scenarios]
	ld a, $01
	farcall Settings_SetHiddenModeFlag
	farcall Settings_UpdateChecksumAndBackup

.l4FD6 ; 68:4FD6
	; [CONFIRMED] 64 insn(s); 64 executed (in up to 4/18 scenarios)
	farcall Settings_GetHiddenModeFlag
	ld [wHiddenModeFlag], a
	xor a, a
	ld [wSettingsMenu_State], a
	ld a, $00
	ld [wCommNoticeMode], a
	ld a, $01
	ld [wCommNoticeGfxSet], a
	call SettingsMenu_RunLoop
	ld a, [wSettingsMenu_Cursor]
	ld hl, sVarSettingsMenuCursor
	ld b, a
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ld [hl], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, [wSettingsMenu_CancelFlag]
	dec a
	ret z
	ld a, [wSettingsMenu_Cursor]
	inc a
	ret

SettingsMenu_RunLoop:: ; 68:5033
	farcall Joypad_Update
	call SettingsMenu_Dispatch
	farcall Sprite_UpdateAll
	call VBlank_WaitAndService
	ld a, [wSettingsMenu_State]
	cp a, $FF
	jr nz, SettingsMenu_RunLoop
	ret

SettingsMenu_Dispatch:: ; 68:504D
	ld a, [wSettingsMenu_State]
	ld hl, SettingsMenu_StateTable
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- ptrtable $505E-$5066 (8 bytes) [CONFIRMED] code-pointer table, 4 entries: 4/4 words hit own-bank code starts (start is the operand of ld r16); 4/4 targets executed; every byte read as data in a trace

SettingsMenu_StateTable:: ; 68:505E
Table_68_505E::
	dw SettingsMenu_StateInit
	dw SettingsMenu_StateFadeIn
	dw SettingsMenu_StateInput
	dw SettingsMenu_StateExit

SettingsMenu_StateInit:: ; 68:5066
	; [CONFIRMED] 183 insn(s); 183 executed (in up to 4/18 scenarios)
	ld b, $15
	ld c, $03
	farcall Joypad_SetRepeatTiming
	farcall Sprite_ResetAll
	xor a, a
	ld [wSettingsMenu_CancelFlag], a
	ld hl, sVarSettingsMenuCursor
	ldh [hScratchA], a
	ldh a, [hSRAMEnable]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, [hl]
	ld b, a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh a, [hScratchA]
	ld a, b
	ld [wSettingsMenu_Cursor], a
	ld de, $8801
	ld hl, Gfx_SettingsMenu_Tiles8800Vb1
	ld a, BANK(Gfx_SettingsMenu_Tiles8800Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8C01
	ld hl, Gfx_SettingsMenu_Tiles8C00Vb1
	ld a, BANK(Gfx_SettingsMenu_Tiles8C00Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9001
	ld hl, Gfx_SettingsMenu_Tiles9000Vb1
	ld a, BANK(Gfx_SettingsMenu_Tiles9000Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $9401
	ld hl, Gfx_SettingsMenu_Tiles9400Vb1
	ld a, BANK(Gfx_SettingsMenu_Tiles9400Vb1)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8001
	ld hl, Gfx_SettingsMenu_Tiles8000Vb1
	ld a, BANK(Gfx_SettingsMenu_Tiles8000Vb1)
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0028
	ld de, wPaletteBufBg
	ld hl, $5180
	ld a, $4A
	farcall Palette_LoadToBuffer
	ld bc, $0008
	ld de, wPaletteBufObj
	ld hl, $51A8
	ld a, $4A
	farcall Palette_LoadToBuffer
	call SettingsMenu_DrawItems
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot1
	ld de, SettingsMenu_ObjTable
	ld a, BANK(SettingsMenu_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	call SettingsMenu_UpdateCursorSprite
	farcall Sprite_UpdateAll
	ld a, $01
	ld [wSettingsMenu_State], a
	ret

SettingsMenu_StateFadeIn:: ; 68:5156
	farcall Palette_FadeInFromWhite
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0008
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ld a, $02
	ld [wSettingsMenu_State], a
	ret

SettingsMenu_StateInput:: ; 68:5172
	ldh a, [hJoyPressedRepeat]
	bit PADB_A, a
	jr nz, .l5187
	bit PADB_B, a
	jr nz, .l519E
	bit PADB_UP, a
	jr nz, .l51BA
	bit PADB_DOWN, a
	jr nz, .l51CF
	jp .done
.l5187 ; 68:5187
	play_sfx SFX_CONFIRM
	ld a, $03
	ld [wSettingsMenu_State], a
	jr .done
.l519E ; 68:519E
	play_sfx SFX_CANCEL
	ld a, $03
	ld [wSettingsMenu_State], a
	ld a, $01
	ld [wSettingsMenu_CancelFlag], a
	jr .done
.l51BA ; 68:51BA
	ld a, [wSettingsMenu_Cursor]
	or a, a
	jr nz, .l51C9
	ld a, [wHiddenModeFlag]
	xor a, $01
	ld b, a
	ld a, $05
	sub a, b
.l51C9 ; 68:51C9
	dec a
	ld [wSettingsMenu_Cursor], a
	jr .l51E1
.l51CF ; 68:51CF
	ld a, [wHiddenModeFlag]
	add a, $03
	ld b, a
	ld a, [wSettingsMenu_Cursor]
	cp a, b
	jr nz, .skip
	ld a, $FF
.skip ; 68:51DD
	inc a
	ld [wSettingsMenu_Cursor], a
.l51E1 ; 68:51E1
	play_sfx SFX_CURSOR_MOVE
	call SettingsMenu_DrawItems
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call SettingsMenu_UpdateCursorSprite
.done ; 68:51FC
	ret

SettingsMenu_StateExit:: ; 68:51FD
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ld [wSettingsMenu_State], a
	ret

SettingsMenu_UpdateCursorSprite:: ; 68:5209
	ld a, [wSettingsMenu_Cursor]
	sla a
	sla a
	sla a
	sla a
	ld b, a
	ld a, [wHiddenModeFlag]
	or a, a
	jr nz, .l5220
	ld a, b
	add a, $30
	jr .l5223

.l5220 ; 68:5220
	; [CONFIRMED] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 68:5219 (executed) [executed in 2 scenarios]
	ld a, b
	add a, $28

.l5223 ; 68:5223
	; [CONFIRMED] 13 insn(s); 13 executed (in up to 4/18 scenarios)
	ld [wSpriteSlot1], a
	ld a, $20
	ld [wSpriteSlot1 + $01], a
	ret

SettingsMenu_DrawItems:: ; 68:522C
	ld a, [wHiddenModeFlag]
	or a, a
	jr nz, .l5245
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, $51D0
	ld a, $4A
	farcall Tilemap_CopyRectAndAttr
	jr .l5256

.l5245 ; 68:5245
	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 1;
	; entered by jrcc from 68:5230 (executed) [executed in 2 scenarios]
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_SettingsMenu
	ld a, BANK(Tilemap_SettingsMenu)
	farcall Tilemap_CopyRectAndAttr

.l5256 ; 68:5256
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 4/18 scenarios)
	ld a, [wSettingsMenu_Cursor]
	ld de, $0040
	call Multiply8x16
	ld a, [wHiddenModeFlag]
	or a, a
	jr nz, .l526A
	ld de, wScreenTileMap + $C5
	jr .l526D

.l526A ; 68:526A
	; [CONFIRMED] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jrcc from 68:5263 (executed) [executed in 2 scenarios]
	ld de, wScreenTileMap + $A5

.l526D ; 68:526D
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 4/18 scenarios)
	add hl, de
	ld d, h
	ld e, l
	ld bc, $020A
	ld a, [wSettingsMenu_Cursor]
	ld hl, SettingsMenu_ItemHighlightMaps
	add a, a
	add a, l
	ld l, a
	ld a, $00
	adc a, h
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	ld a, $4A
	farcall Tilemap_CopyRectAndAttr
	ret

; ---- words $528C-$5296 (10 bytes) [PROBABLE] 5 words $5770,$5798,$57C0,$57E8,$5810 (stride $28) read with `ld hl,$528C ; add a,a ; add a,l ... ld a,[hli] ; ld h,[hl] ; ld l,a` at 68:5276 and passed as HL to the far call `ld a,$4A ; farcall 00:08EA` (68:5283, copy_tilemap_rect_pair, bc=$050A): the words are therefore pointers into BANK 4A data, NOT into bank 68 code [verifier: retyped ptrtable->words; as a ptrtable the generator emitted `dw Label_68_5798`, a false symbolic reference to code of this bank]

SettingsMenu_ItemHighlightMaps:: ; 68:528C
Table_68_528C::
	dw $5770, $5798, $57C0, $57E8, $5810
