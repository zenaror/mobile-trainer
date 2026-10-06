; engine/mail_server/delete_hidden.asm
; bank 22, $4000-$4EF0 (3824 bytes); pinned by layout.link
; hidden variant of the mail-server delete menu (3 buttons) with its description strings and delete flows

SECTION "engine/mail_server/delete_hidden", ROMX

MailSrvDelHidden_MenuRun:: ; 22:4000
	; [CONFIRMED] 408 insn(s) reached by static flow only; seeds: exec x408; min discovery hops 1;
	; entered by far from 7C:7D0C (PROBABLE code) | 50 insn(s) executed; cut out of the PROBABLE
	; region 4000-43E0 by apply_coverage --split [executed in 3 scenarios]
	call VBlank_WaitAndService
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	call VBlank_Wait
	ld c, $01
	call MailSrvDelHidden_MenuInit
	ld de, $0227
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	push de
	pop de
	farcall Dialog_Show
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $01
	ld [wStatIrqServiceFlag], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	ld c, $01
	dec a
	jr z, MailSrvDelHidden_MenuLoop

	; [PROBABLE] 5 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-43E0 by apply_coverage --split
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

MailSrvDelHidden_MenuLoop:: ; 22:4076
	; [CONFIRMED] 28 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l40F4
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	jr z, .l40AE
	dec c
	jr z, .l40ED
	call MailSrvDelHidden_DeleteAll
	ld c, $00
	jr .l40B3
.l40AE ; 22:40AE
	call MailSrvDelHidden_CheckAndDelete

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-43E0 by apply_coverage --split
	ld c, $01

.l40B3 ; 22:40B3
	; [CONFIRMED] 35 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage
	; --split [executed in 1 scenarios]
	push bc
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	push bc
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	pop bc
	call MailSrvDelHidden_MenuInit
	pop bc
	jp MailSrvDelHidden_MenuLoop
.l40ED ; 22:40ED
	call MailSrvDelHidden_DeleteCompletely
	ld c, $02
	jr .l40B3
.l40F4 ; 22:40F4
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4120

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-43E0 by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l4120 ; 22:4120
	; [CONFIRMED] 27 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage
	; --split [executed in 1 scenarios]
	ldh a, [hJoyPressedRepeat]
	and a, $80
	jr z, .l4148
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld a, c
	dec a
	ld c, a
	cp a, $FF
	jr nz, .l4145
	ld c, $02
.l4145 ; 22:4145
	call MailSrvDelHidden_MenuSelect
.l4148 ; 22:4148
	ldh a, [hJoyPressedRepeat]
	and a, $40
	jr z, .l4170

	; [PROBABLE] 21 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-43E0 by apply_coverage --split
	push bc
	push de
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	ei
	pop de
	pop bc
	ld a, c
	inc a
	ld c, a
	cp a, $03
	jr nz, .l416D
	ld c, $00
.l416D ; 22:416D
	call MailSrvDelHidden_MenuSelect

.l4170 ; 22:4170
	; [CONFIRMED] 4 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage
	; --split [executed in 3 scenarios]
	jp MailSrvDelHidden_MenuLoop

MailSrvDelHidden_MenuSelect:: ; 22:4173
	ld a, c
	cp a, $01
	jr nz, .l41B3

	; [PROBABLE] 20 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4000-43E0 by apply_coverage --split
	push bc
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button1
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersNoService
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $F400
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call MailSrvDelHidden_ShowDescCheck
	pop bc
	ret

.l41B3 ; 22:41B3
	; [CONFIRMED] 200 insn(s) executed; cut out of the PROBABLE region 4000-43E0 by apply_coverage
	; --split [executed in 1 scenarios]
	cp a, $00
	jr nz, .l41F2
	push bc
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button0
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersNoService
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0800
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call MailSrvDelHidden_ShowDescDeleteAll
	pop bc
	ret
.l41F2 ; 22:41F2
	push bc
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button2
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersNoService
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1C00
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call MailSrvDelHidden_ShowDescDeleteCompletely
	pop bc
	ret

MailSrvDelHidden_MenuInit:: ; 22:422D
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailServerDeleteMethod_BgPalette
	ld a, $28
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, $6E40
	ld a, $28
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $9301
	ld hl, MailServerDeleteMethod_Tiles_5F20
	ld a, $28
	ld b, $95
	ld c, $23
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8800
	ld hl, MailServerDeleteMethod_Tiles_6150
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8C00
	ld hl, MailServerDeleteMethod_Tiles_6550
	ld a, $28
	ld b, $94
	ld c, $29
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8000
	ld hl, MailServerDeleteMethod_Tiles_67E0
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button1
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $0F00
.loop ; 22:42E7
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .loop
	pop bc
	push bc
	ld a, c
	cp a, $00
	jr z, .l4317
	cp a, $02
	jr z, .l434B
	call MailSrvDelHidden_ShowDescCheck
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $F400
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	jr MailSrvDelHidden_MenuStart
.l4317 ; 22:4317
	call MailSrvDelHidden_ShowDescDeleteAll
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button0
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $0800
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	jr MailSrvDelHidden_MenuStart
.l434B ; 22:434B
	call MailSrvDelHidden_ShowDescDeleteCompletely
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, Tilemap_MailSrvDelHidden_Button2
	ld a, $22
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot1
	ld de, $6E90
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1C00
	ld hl, wSpriteSlot1
	call Sprite_SetPosition

MailSrvDelHidden_MenuStart:: ; 22:437D
	call VBlank_Wait
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	pop bc
	ret

MailSrvDelHidden_ShowDescDeleteAll:: ; 22:43C5
	ld hl, String_MailSrvDelHidden_DescDeleteAll
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2
	ld de, wTileStage2 + $360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $43E0-$444D (109 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDelHidden_DescDeleteAll:: ; 22:43E0
String_22_43E0::
	db "メールサーバにのこっているすべての　メールを、じどうでぜんぶけします　　じょうほうはたしかめられません　　　", 0
POPC

MailSrvDelHidden_ShowDescCheck:: ; 22:444D
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 3;
	; entered by call from 22:41AE (PROBABLE code) [executed in 1 scenarios]
	ld hl, String_MailSrvDelHidden_DescCheck
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2
	ld de, wTileStage2 + $360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $4468-$448D (37 bytes) [HYPOTHESIS] Shift-JIS text: 18 x 81 40 (full-width space) + NUL; no reference found (no ld/dw of $4468 in the ROM); sits between a ret and the referenced string String_22_448D (ld hl,$448D at 22:444D) - probably a blank-line string

PUSHC sjis
String_22_4468:: ; 22:4468
	db "　　　　　　　　　　　　　　　　　　", 0
POPC

; ---- text $448D-$44FA (109 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDelHidden_DescCheck:: ; 22:448D
String_22_448D::
	db "メールサーバにのこっているメールの　じょうほうをたしかめて、１つうずつ　じぶんでけすことができます　　　　　", 0
POPC

MailSrvDelHidden_ShowDescDeleteCompletely:: ; 22:44FA
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 4;
	; entered by call from 22:4228 (PROBABLE code) [executed in 1 scenarios]
	ld hl, String_MailSrvDelHidden_DescDeleteCompletely
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2
	ld de, wTileStage2 + $360
	farcall TextTiles_RenderLine
	call MailSrvDelHidden_UploadTextTiles
	ret

; ---- text $4515-$4582 (109 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDelHidden_DescDeleteCompletely:: ; 22:4515
String_22_4515::
	db "もんだいのあるメールとメールサーバにのこっているすべてのメールをじどうでぜんぶけします　　　　　　　　　　　", 0
POPC

MailSrvDelHidden_Confirm:: ; 22:4582
	; [CONFIRMED] 242 insn(s) reached by static flow only; seeds: exec x242; min discovery hops 4;
	; entered by call from 22:4B2F (PROBABLE code) | 184 insn(s) executed; cut out of the PROBABLE
	; region 4582-47DD by apply_coverage --split [executed in 3 scenarios]
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $0B
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailServerDeleteAll_BgPalette
	ld a, $28
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, $5EE0
	ld a, $28
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $9301
	ld hl, MailServerDeleteAll_Tiles_54B0
	ld a, $28
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $9701
	ld hl, MailServerDeleteAll_Tiles_58B0
	ld a, $28
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8000
	ld hl, MailServerDeleteAll_Tiles_5B50
	ld a, $28
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteAll_Tilemap
	ld a, $28
	farcall Tilemap_CopyRectAndAttr
	call VBlank_Wait
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	call VBlank_Wait
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wTileStage2
	ld bc, $0F00
.l4646 ; 22:4646
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l4646
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6858
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, String_MailSrvDelHidden_Confirm
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2
	ld de, wTileStage2 + $100
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $483C
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2 + $200
	ld de, wTileStage2 + $300
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $485D
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2 + $400
	ld de, wTileStage2 + $500
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $487E
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $22
	ld bc, wTileStage2 + $600
	ld de, wTileStage2 + $700
	farcall TextTiles_RenderLine
	call VBlank_Wait
	call MailSrvDelHidden_UploadTextTiles
	call VBlank_Wait
	push bc
	di
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0010
	call Sound_PlayMusicOrResume
	pop af
	ldh [rSVBK], a
	ei
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_WaitAndService
	farcall Palette_FadeInFromWhite
	push af
	ldh a, [rSVBK]
	push af
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld a, $15
	ld [wStatSplitLine], a
	ld a, $00
	ld [wKbdSlideDeltaRow], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	pop af
	farcall Stat_EnableScrollSplit
	ld c, $01
.l4719 ; 22:4719
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l476A
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002C
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	dec c
	jr z, .l4758
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4758 ; 22:4758
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l476A ; 22:476A
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4796

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4582-47DD by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $002E
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l4796 ; 22:4796
	; [CONFIRMED] 23 insn(s) executed; cut out of the PROBABLE region 4582-47DD by apply_coverage
	; --split [executed in 3 scenarios]
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, .l47B8
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDelHidden_ConfirmSelect
.l47B8 ; 22:47B8
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, .l47DA

	; [PROBABLE] 17 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4582-47DD by apply_coverage --split
	push bc
	push de
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, $0029
	call Sound_PlaySfx
	pop af
	ldh [rSVBK], a
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDelHidden_ConfirmSelect

.l47DA ; 22:47DA
	; [CONFIRMED] 1 insn(s) executed; cut out of the PROBABLE region 4582-47DD by apply_coverage
	; --split [executed in 3 scenarios]
	jp .l4719

	; [HYPOTHESIS] c9 ret directly after the unconditional 'jp $4719' at 22:47DA: unreachable by
	; flow, no reference; kept as code because it is a whole instruction at a function boundary
	ret

MailSrvDelHidden_ConfirmSelect:: ; 22:47DE
	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 7;
	; entered by call from 22:47B5 (PROBABLE code) | 14 insn(s) executed; cut out of the PROBABLE
	; region 47DE-481B by apply_coverage --split [executed in 3 scenarios]
	ld a, c
	cp a, $00
	jr nz, .l47FF
	push bc
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6828
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret

.l47FF ; 22:47FF
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 47DE-481B by apply_coverage --split
	push bc
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, $28
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6858
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret

; ---- text $481B-$489F (132 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDelHidden_Confirm:: ; 22:481B
String_22_481B::
	db "このしょりをおこなうと　　　　　", 0
	db "サーバにある　すべてのメールが　", 0
	db "きえてしまいます　　　　　　　　", 0
	db "　　　　よろしいですか？　　　　", 0
POPC

MailSrvDelHidden_UploadTextTiles:: ; 22:489F
	; [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 4;
	; entered by call from 22:43DC (PROBABLE code) [executed in 1 scenarios]
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2
	ld de, $9000
	ld c, $3F
	farcall Gfx_StartHDMAAtVBlank
	ld hl, wTileStage2 + $400
	ld de, $9400
	ld c, $3F
	farcall Gfx_StartHDMAAtVBlank
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailSrvDelHidden_DrawTimerNumbers:: ; 22:48CD
Function_22_48CD::
	; [PROBABLE] function prologue (push af/bc/de/hl ... ld de,$C2D7 ... call $4975 / $4A97 ...)
	; that falls straight into the far-call site at 22:48FE (PROBABLE code); it follows a ret at
	; 48CC. No caller/pointer to 48CD found in the ROM (words.py scan), so the entry is unproven;
	; both direct call targets (4975, 4A97) are known code starts | forced execution: 31/31
	; instruction starts ran in forced_dead (traces/forced/, not natural evidence; status unchanged)
	push af
	push bc
	push de
	push hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wTimerAExtra
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call MailSrvDelHidden_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDelHidden_NumberOffset
	ld hl, wTileStage2 + $800
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524

	; [PROBABLE] 243 insn(s) reached by static flow only; seeds: site x243; min discovery hops 0;
	; run starts at a raw `CD D1 06` (far-call) pattern site whose target agrees with decoded code |
	; forced execution: 125/243 instruction starts ran in forced_dead (traces/forced/, not natural
	; evidence; status unchanged)
	farcall TextTiles_RenderLine
	pop hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wTimerAMinutes
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call MailSrvDelHidden_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDelHidden_NumberOffset
	ld hl, wTileStage2 + $830
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld de, wTimerASeconds
	ld a, [de]
	ld l, a
	inc de
	ld a, [de]
	xor a, a
	ld h, a
	push hl
	call MailSrvDelHidden_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDelHidden_NumberOffset
	ld hl, wTileStage2 + $860
	add hl, bc
	ld b, h
	ld c, l
	ld a, $02
	ldh [hTextTiles_DestBank], a
	ld a, $01
	ld hl, $0140
	add hl, bc
	ld d, h
	ld e, l
	ld hl, $D524
	farcall TextTiles_RenderLine
	pop hl
	call MailSrvDelHidden_UploadDecimalTiles
	pop hl
	pop de
	pop bc
	pop af
	ret

MailSrvDelHidden_FormatDecimalStr:: ; 22:4975
Function_22_4975::
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_MailSrvDelHidden_NumberTemplate
	ld de, $D524
.loop ; 22:4983
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .loop
	pop bc
	pop hl
	push bc
	ld bc, $D525
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l49E6
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $05
	jp .l4A8A
.l49E6 ; 22:49E6
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4A2C
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $04
	jp .l4A8A
.l4A2C ; 22:4A2C
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4A60
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $03
	jp .l4A8A
.l4A60 ; 22:4A60
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4A82
	ld a, [bc]
	add a, l
	ld [bc], a
	inc bc
	inc bc
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $02
	jp .l4A8A
.l4A82 ; 22:4A82
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l4A8A ; 22:4A8A
	pop bc
	ret

; ---- text $4A8C-$4A97 (11 bytes) [PROBABLE] Shift-JIS NUL-terminated string 5 x 82 4F (full-width digit zero); copied byte-by-byte to $D524 until NUL by the loop at 22:4983 (ld hl,$4A8C at 22:497D)

PUSHC sjis
String_MailSrvDelHidden_NumberTemplate:: ; 22:4A8C
String_22_4A8C::
	db "０００００", 0
POPC

MailSrvDelHidden_NumberOffset:: ; 22:4A97
Function_22_4A97::
	; [PROBABLE] 130 insn(s) reached by static flow only; seeds: exec x74, site x56; min discovery
	; hops 0; entered by call from 22:491A (PROBABLE code) | 56 insn(s) never executed in the traced
	; runs; cut out of the PROBABLE region 4A97-4BB5 by apply_coverage --split | forced execution:
	; 48/56 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status
	; unchanged)
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4AAD
	ld bc, $0000
	jp .l4AF4
.l4AAD ; 22:4AAD
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4AC3
	ld bc, $0000
	jp .l4AF4
.l4AC3 ; 22:4AC3
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4AD9
	ld bc, $0000
	jp .l4AF4
.l4AD9 ; 22:4AD9
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l4AEF
	ld bc, $0000
	jp .l4AF4
.l4AEF ; 22:4AEF
	ld bc, $0010
	ld a, $01
.l4AF4 ; 22:4AF4
	pop hl
	pop de
	ret

MailSrvDelHidden_UploadDecimalTiles:: ; 22:4AF7
Function_22_4AF7::
	ldh a, [rSVBK]
	push af
	ld a, $02
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ldh [rVBK], a
	ld hl, wTileStage2 + $800
	ld de, $8800
	ld c, $27
	farcall Gfx_GdmaAtVBlankNoDi
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ret

MailSrvDelHidden_DeleteAll:: ; 22:4B17
	; [CONFIRMED] 60 insn(s) executed; cut out of the PROBABLE region 4A97-4BB5 by apply_coverage
	; --split [executed in 2 scenarios]
	ld a, $01
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite

MailSrvDelHidden_DeleteAll_Confirm:: ; 22:4B2F
	call MailSrvDelHidden_Confirm
	inc a
	jr nz, .l4B37
	dec a
	ret
.l4B37 ; 22:4B37
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_MailSrvDelHidden_DeleteAll_Confirm_SessionBlockTemplate
	ld b, $07
.loop ; 22:4B45
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDelHidden_DeleteAll_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, .l4B91
	cp a, $20
	jr z, .l4BD1
	cp a, $80
	jr nz, .l4BED

.l4B91 ; 22:4B91
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4A97-4BB5 by apply_coverage --split
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, .l4BB7
	cp a, $20
	jp z, .l4BB7
	cp a, $21
	jp z, .l4BB7
	cp a, $23
	jp z, .l4BB7
	cp a, $24
	jp z, .l4BB7
	cp a, $26
	jp z, .l4BB7
	jp .l4BD1

	; [HYPOTHESIS] jr $4C2B (18 74) after the unconditional 'jp $4BD1' at 22:4BB2: unreachable by
	; flow and never referenced; target 4C2B is a code instruction start
	jr .l4C2B

.l4BB7 ; 22:4BB7
	; [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 5;
	; entered by jpcc from 22:4B96 (PROBABLE code) | 19 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4BC9
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l4BD1
.l4BC9 ; 22:4BC9
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer
.l4BD1 ; 22:4BD1
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4BDE
	ld a, h
	or a, l
	jr z, .done
.l4BDE ; 22:4BDE
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 22:4BEC
	ret

.l4BED ; 22:4BED
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage
	; --split [executed in 2 scenarios]
	farcall MailSrvDel_DeleteAllRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4C14
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr .l4C2B

.l4C14 ; 22:4C14
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BB7-4C5B by apply_coverage --split
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

.l4C2B ; 22:4C2B
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage
	; --split [executed in 2 scenarios]
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, .l4C39

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4BB7-4C5B by apply_coverage --split
	ld a, h
	or a, l
	jr z, .l4C47

.l4C39 ; 22:4C39
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4BB7-4C5B by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l4C47 ; 22:4C47
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4C5B-$4C62 (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied by the loop 'ld hl,$D624 ; ld de,$4C5B ; ld b,$07' at 22:4B3D-4B4A

Data_MailSrvDelHidden_DeleteAll_Confirm_SessionBlockTemplate:: ; 22:4C5B
Data_22_4C5B::
	db $03, $00, $00, $01, $24, $D5, $00

MailSrvDelHidden_DeleteCompletely:: ; 22:4C62
	; [CONFIRMED] 74 insn(s) reached by static flow only; seeds: exec x74; min discovery hops 4;
	; entered by call from 22:40ED (PROBABLE code) | 60 insn(s) executed; cut out of the PROBABLE
	; region 4C62-4D00 by apply_coverage --split [executed in 1 scenarios]
	ld a, $01
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite

MailSrvDelHidden_DeleteCompletely_Confirm:: ; 22:4C7A
	call MailSrvDelHidden_Confirm
	inc a
	jr nz, .l4C82
	dec a
	ret
.l4C82 ; 22:4C82
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_MailSrvDelHidden_DeleteCompletely_Confirm_SessionBlockTemplate
	ld b, $07
.loop ; 22:4C90
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	jr z, MailSrvDelHidden_DeleteCompletely_Confirm
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, .l4CDC
	cp a, $20
	jr z, .l4D1C
	cp a, $80
	jr nz, .l4D38

.l4CDC ; 22:4CDC
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4C62-4D00 by apply_coverage --split
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, .l4D02
	cp a, $20
	jp z, .l4D02
	cp a, $21
	jp z, .l4D02
	cp a, $23
	jp z, .l4D02
	cp a, $24
	jp z, .l4D02
	cp a, $26
	jp z, .l4D02
	jp .l4D1C

	; [HYPOTHESIS] jr $4D76 (18 74) after the unconditional 'jp $4D1C' at 22:4CFD: unreachable, same
	; pattern as 4BB5; target is a code instruction start
	jr .l4D76

.l4D02 ; 22:4D02
	; [PROBABLE] 63 insn(s) reached by static flow only; seeds: exec x63; min discovery hops 6;
	; entered by jpcc from 22:4CE1 (PROBABLE code) | 19 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4D14
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l4D1C
.l4D14 ; 22:4D14
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer
.l4D1C ; 22:4D1C
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4D29
	ld a, h
	or a, l
	jr z, .done
.l4D29 ; 22:4D29
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 22:4D37
	ret

.l4D38 ; 22:4D38
	; [CONFIRMED] 16 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall MailSrvDel_DeleteCompletelyRun
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4D5F
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr .l4D76

.l4D5F ; 22:4D5F
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D02-4DA6 by apply_coverage --split
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

.l4D76 ; 22:4D76
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, .l4D84

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4D02-4DA6 by apply_coverage --split
	ld a, h
	or a, l
	jr z, .l4D92

.l4D84 ; 22:4D84
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4D02-4DA6 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l4D92 ; 22:4D92
	ld a, $01
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4DA6-$4DAD (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied to $D624 by the 'ld de,$4DA6 ; ld b,$07' loop at 22:4C8B

Data_MailSrvDelHidden_DeleteCompletely_Confirm_SessionBlockTemplate:: ; 22:4DA6
Data_22_4DA6::
	db $03, $00, $00, $01, $24, $D5, $00

MailSrvDelHidden_CheckAndDelete:: ; 22:4DAD
	; [CONFIRMED] 69 insn(s) reached by static flow only; seeds: exec x69; min discovery hops 4;
	; entered by call from 22:40AE (PROBABLE code) | 55 insn(s) executed; cut out of the PROBABLE
	; region 4DAD-4E41 by apply_coverage --split [executed in 1 scenarios]
	xor a, a
	ld [wCommNoticeMode], a
	xor a, a
	ld [wCommNoticeGfxSet], a
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D624
	ld de, Data_MailSrvDelHidden_CheckAndDelete_SessionBlockTemplate
	ld b, $07
.loop ; 22:4DD2
	ld a, [de]
	ld [hli], a
	inc de
	dec b
	jr nz, .loop
	ld d, $01
	ld bc, $D624
	farcall ConnectDialog_Run
	inc b
	ret z
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wMailSessionBlock
	xor a, a
	ld [hli], a
	ld a, $FF
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	inc hl
	inc hl
	inc hl
	inc hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	ld [hli], a
	farcall CommTime_Reset
	ld b, $02
	ld a, $00
	farcall MailConnect_Screen
	cp a, $FF
	jr z, .l4E1D
	cp a, $20
	jr z, .l4E5D
	cp a, $80
	jr nz, .l4E79

.l4E1D ; 22:4E1D
	; [PROBABLE] 14 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4DAD-4E41 by apply_coverage --split
	ld a, [wMobileErrorCode]
	cp a, $17
	jp z, .l4E43
	cp a, $20
	jp z, .l4E43
	cp a, $21
	jp z, .l4E43
	cp a, $23
	jp z, .l4E43
	cp a, $24
	jp z, .l4E43
	cp a, $26
	jp z, .l4E43
	jp .l4E5D

	; [HYPOTHESIS] jr $4EB9 (18 76) after the unconditional 'jp $4E5D': unreachable, same pattern as
	; 4BB5; target is a code instruction start
	jr .l4EB9

.l4E43 ; 22:4E43
	; [PROBABLE] 64 insn(s) reached by static flow only; seeds: exec x64; min discovery hops 5;
	; entered by jpcc from 22:4E22 (PROBABLE code) | 19 insn(s) never executed in the traced runs;
	; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage --split
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4E55
	ld b, $00
	farcall MailDisconnect_Screen
	jr .l4E5D
.l4E55 ; 22:4E55
	ld b, $00
	farcall MailDisconnect_ScreenNoTimer
.l4E5D ; 22:4E5D
	farcall CommTime_TimerAIsNonZero
	or a, a
	jr nz, .l4E6A
	ld a, h
	or a, l
	jr z, .done
.l4E6A ; 22:4E6A
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.done ; 22:4E78
	ret

.l4E79 ; 22:4E79
	; [CONFIRMED] 17 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall MailServerMgr_Run
	cp a, $80
	ld a, [wTimerEnable]
	bit 4, a
	jp z, .l4EA2
	ld a, $00
	ld a, $01
	ld b, $02
	farcall MailDisconnect_Screen
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei
	jr .l4EB9

.l4EA2 ; 22:4EA2
	; [PROBABLE] 11 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4E43-4EE9 by apply_coverage --split
	ld a, $00
	ld b, $02
	ld a, $01
	farcall MailDisconnect_ScreenNoTimer
	di
	xor a, a
	ldh [rIF], a
	ldh a, [rIE]
	and a, $F3
	ldh [rIE], a
	ei

.l4EB9 ; 22:4EB9
	; [CONFIRMED] 3 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage
	; --split [executed in 1 scenarios]
	farcall CommTime_TimerAIsNonZero
	cp a, $00
	jr nz, .l4EC7

	; [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4E43-4EE9 by apply_coverage --split
	ld a, h
	or a, l
	jr z, .l4ED5

.l4EC7 ; 22:4EC7
	; [CONFIRMED] 11 insn(s) executed; cut out of the PROBABLE region 4E43-4EE9 by apply_coverage
	; --split [executed in 1 scenarios]
	ld a, $00
	ld [wBrowserScrollbarEnable], a
	ld [wCommSessionKind], a
	farcall CommTime_DrawSummaryScreen
.l4ED5 ; 22:4ED5
	ld a, $02
	ld [wMailScreenMode], a
	farcall MailServerStatus_Screen
	xor a, a
	pop af
	farcall Palette_FadeOutToWhite
	ret

; ---- data $4EE9-$4EF0 (7 bytes) [PROBABLE] 7-byte template (03 00 00 01 24 d5 00) copied to $D624 by the 'ld de,$4EE9 ; ld b,$07' loop at 22:4DCD

Data_MailSrvDelHidden_CheckAndDelete_SessionBlockTemplate:: ; 22:4EE9
Data_22_4EE9::
	db $03, $00, $00, $01, $24, $D5, $00
