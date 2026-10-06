; engine/mail_server/delete_menu.asm
; bank 23, $4000-$4A06 (2566 bytes); pinned by layout.link
; mail-server delete menu (2 buttons): run/select/init, descriptions, confirm dialog, text tiles

SECTION "engine/mail_server/delete_menu", ROMX

MailSrvDel_MenuRun:: ; 23:4000
Function_23_4000::
	; [CONFIRMED] 50 insn(s); 50 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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
	call MailSrvDel_MenuInit
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
	jr z, MailSrvDel_MenuLoop

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 23:4062 (executed) [executed in 4 scenarios]
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

MailSrvDel_MenuLoop:: ; 23:4076
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l40EA
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	dec c
	jr z, .l40AB

	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 0;
	; fall-through of the jrcc at 23:40A2 (executed) [executed in 6 scenarios]
	call MailSrvDel_DeleteAll
	ld c, $00
	jr .l40B0

.l40AB ; 23:40AB
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios)
	call MailSrvDel_CheckAndDelete

	; [CONFIRMED] 30 insn(s) reached by static flow only; seeds: exec x30; min discovery hops 0;
	; fall-through of the call at 23:40AB (executed) [executed in 5 scenarios]
	ld c, $01
.l40B0 ; 23:40B0
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
	call MailSrvDel_MenuInit
	pop bc
	jp MailSrvDel_MenuLoop

.l40EA ; 23:40EA
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4116

	; [CONFIRMED] 17 insn(s) reached by static flow only; seeds: exec x17; min discovery hops 0;
	; fall-through of the jrcc at 23:40EE (executed) [executed in 5 scenarios]
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret

.l4116 ; 23:4116
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $40
	jr z, .l413A

	; [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 0;
	; fall-through of the jrcc at 23:411A (executed) [executed in 5 scenarios]
	push bc
	push de
	di
	play_sfx SFX_CURSOR_MOVE
	ei
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDel_MenuSelect

.l413A ; 23:413A
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios)
	ldh a, [hJoyPressedRepeat]
	and a, $80
	jr z, .l415E

	; [CONFIRMED] 19 insn(s) reached by static flow only; seeds: exec x19; min discovery hops 0;
	; fall-through of the jrcc at 23:413E (executed) [executed in 6 scenarios]
	push bc
	push de
	di
	play_sfx SFX_CURSOR_MOVE
	ei
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDel_MenuSelect

.l415E ; 23:415E
	; [CONFIRMED] 1 insn(s); 1 executed (in up to 1/18 scenarios)
	jp MailSrvDel_MenuLoop

MailSrvDel_MenuSelect:: ; 23:4161
	; [CONFIRMED] 43 insn(s) reached by static flow only; seeds: exec x43; min discovery hops 1;
	; entered by call from 23:4137 (PROBABLE code) [executed in 5 scenarios]
	ld a, c
	cp a, $01
	jr nz, .l41A1
	push bc
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteMethod_Tilemap_First
	ld a, BANK(MailServerDeleteMethod_Tilemap_First)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersNoService
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable_Entry4
	ld a, BANK(MailServerDeleteMethod_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $FC00
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call MailSrvDel_ShowDescCheck
	pop bc
	ret
.l41A1 ; 23:41A1
	push bc
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteMethod_Tilemap_Second
	ld a, BANK(MailServerDeleteMethod_Tilemap_Second)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffersNoService
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable_Entry4
	ld a, BANK(MailServerDeleteMethod_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1800
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	farcall Sprite_UpdateAll
	call MailSrvDel_ShowDescDeleteAll
	pop bc
	ret

MailSrvDel_MenuInit:: ; 23:41DC
Function_23_41DC::
	; [CONFIRMED] 80 insn(s); 80 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	push bc
	farcall Sprite_ResetAll
	farcall Sprite_UpdateAll
	farcall TextTiles_ClearBuffers
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufBg
	ld hl, MailServerDeleteMethod_BgPalette
	ld a, BANK(MailServerDeleteMethod_BgPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailServerDeleteMethod_ObjPalette
	ld a, BANK(MailServerDeleteMethod_ObjPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $9301
	ld hl, MailServerDeleteMethod_Tiles_5F20
	ld a, BANK(MailServerDeleteMethod_Tiles_5F20)
	ld b, $95
	ld c, $23
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8800
	ld hl, MailServerDeleteMethod_Tiles_6150
	ld a, BANK(MailServerDeleteMethod_Tiles_6150)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8C00
	ld hl, MailServerDeleteMethod_Tiles_6550
	ld a, BANK(MailServerDeleteMethod_Tiles_6550)
	ld b, $94
	ld c, $29
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8000
	ld hl, MailServerDeleteMethod_Tiles_67E0
	ld a, BANK(MailServerDeleteMethod_Tiles_67E0)
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteMethod_Tilemap_First
	ld a, BANK(MailServerDeleteMethod_Tilemap_First)
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
.loop ; 23:4296
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
	jr z, .l42C2
	call MailSrvDel_ShowDescCheck
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable_Entry4
	ld a, BANK(MailServerDeleteMethod_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $FC00
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	jr MailSrvDel_MenuStart

.l42C2 ; 23:42C2
	; [CONFIRMED] 16 insn(s) reached by static flow only; seeds: exec x16; min discovery hops 1;
	; entered by jrcc from 23:42A2 (executed) [executed in 6 scenarios]
	call MailSrvDel_ShowDescDeleteAll
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteMethod_Tilemap_Second
	ld a, BANK(MailServerDeleteMethod_Tilemap_Second)
	farcall Tilemap_CopyRectAndAttr
	ldh a, [rLCDC]
	call Gfx_UploadBgMapBuffers
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable_Entry4
	ld a, BANK(MailServerDeleteMethod_ObjTable_Entry4)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $1800
	ld hl, wSpriteSlot1
	call Sprite_SetPosition

MailSrvDel_MenuStart:: ; 23:42F4
	; [CONFIRMED] 33 insn(s); 33 executed (in up to 1/18 scenarios)
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

MailSrvDel_ShowDescDeleteAll:: ; 23:433C
	; [CONFIRMED] 10 insn(s) reached by static flow only; seeds: exec x10; min discovery hops 2;
	; entered by call from 23:41D7 (PROBABLE code) [executed in 6 scenarios]
	ld hl, String_MailSrvDel_DescDeleteAll
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_MailSrvDel_DescDeleteAll)
	ld bc, wTileStage2
	ld de, wTileStage2 + $360
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadTextTiles
	ret

; ---- text $4357-$43C4 (109 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDel_DescDeleteAll:: ; 23:4357
String_23_4357::
	db "メールサーバにのこっているすべての　メールを、じどうでぜんぶけします　　じょうほうはたしかめられません　　　", 0
POPC

MailSrvDel_ShowDescCheck:: ; 23:43C4
Function_23_43C4::
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, String_MailSrvDel_DescCheck
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_MailSrvDel_DescCheck)
	ld bc, wTileStage2
	ld de, wTileStage2 + $360
	farcall TextTiles_RenderLine
	call MailSrvDel_UploadTextTiles
	ret

; ---- text $43DF-$4404 (37 bytes) [PROBABLE] 18 ideographic spaces (81 40) + NUL: clean NUL-terminated Shift-JIS blank line placed right after a ret (23:43DE)

PUSHC sjis
String_23_43DF:: ; 23:43DF
	db "　　　　　　　　　　　　　　　　　　", 0
POPC

; ---- text $4404-$4471 (109 bytes) [CONFIRMED] text: 1 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDel_DescCheck:: ; 23:4404
String_23_4404::
	db "メールサーバにのこっているメールの　じょうほうをたしかめて、１つうずつ　じぶんでけすことができます　　　　　", 0
POPC

MailSrvDel_Confirm:: ; 23:4471
	; [CONFIRMED] 242 insn(s) reached by static flow only; seeds: exec x242; min discovery hops 2;
	; entered by call from 23:4A1E (PROBABLE code) [executed in 3 scenarios]
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
	ld a, BANK(MailServerDeleteAll_BgPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld bc, $0040
	ld de, wPaletteBufObj
	ld hl, MailServerDeleteAll_ObjPalette
	ld a, BANK(MailServerDeleteAll_ObjPalette)
	farcall Palette_LoadToBuffer
	call VBlank_Wait
	ld de, $9301
	ld hl, MailServerDeleteAll_Tiles_54B0
	ld a, BANK(MailServerDeleteAll_Tiles_54B0)
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $9701
	ld hl, MailServerDeleteAll_Tiles_58B0
	ld a, BANK(MailServerDeleteAll_Tiles_58B0)
	ld b, $94
	ld c, $2A
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld de, $8000
	ld hl, MailServerDeleteAll_Tiles_5B50
	ld a, BANK(MailServerDeleteAll_Tiles_5B50)
	ld b, $98
	ld c, $08
	farcall Gfx_StartHDMAWithService
	call VBlank_Wait
	ld bc, $1214
	ld de, wScreenTileMap
	ld hl, MailServerDeleteAll_Tilemap
	ld a, BANK(MailServerDeleteAll_Tilemap)
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
.l4535 ; 23:4535
	xor a, a
	ld [hli], a
	dec bc
	ld a, b
	or a, c
	jr nz, .l4535
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, BANK(MailServerDeleteMethod_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6858
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	ld hl, String_MailSrvDel_Confirm
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, BANK(String_MailSrvDel_Confirm)
	ld bc, wTileStage2
	ld de, wTileStage2 + $100
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $472B
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $23
	ld bc, wTileStage2 + $200
	ld de, wTileStage2 + $300
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $474C
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $23
	ld bc, wTileStage2 + $400
	ld de, wTileStage2 + $500
	farcall TextTiles_RenderLine
	call VBlank_Wait
	ld hl, $476D
	ld a, $02
	ldh [rVBK], a
	ldh [hTextTiles_DestBank], a
	ld a, $23
	ld bc, wTileStage2 + $600
	ld de, wTileStage2 + $700
	farcall TextTiles_RenderLine
	call VBlank_Wait
	call MailSrvDel_UploadTextTiles
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
.l4608 ; 23:4608
	push bc
	farcall Sprite_UpdateAll
	call VBlank_Wait
	farcall Joypad_Update
	pop bc
	ldh a, [hJoyPressed]
	and a, $01
	jr z, .l4659
	push bc
	push de
	play_sfx SFX_CONFIRM
	pop de
	pop bc
	dec c
	jr z, .l4647
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	xor a, a
	ret
.l4647 ; 23:4647
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l4659 ; 23:4659
	ldh a, [hJoyPressed]
	and a, $02
	jr z, .l4685
	push bc
	push de
	play_sfx SFX_CANCEL
	pop de
	pop bc
	farcall Stat_DisableScrollSplit
	call VBlank_Wait
	farcall Palette_FadeOutToWhite
	ld a, $FF
	ret
.l4685 ; 23:4685
	ldh a, [hJoyPressedRepeat]
	and a, $20
	jr z, .l46A7
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDel_ConfirmSelect
.l46A7 ; 23:46A7
	ldh a, [hJoyPressedRepeat]
	and a, $10
	jr z, .l46C9
	push bc
	push de
	play_sfx SFX_CURSOR_MOVE
	pop de
	pop bc
	ld a, c
	inc a
	and a, $01
	ld c, a
	call MailSrvDel_ConfirmSelect
.l46C9 ; 23:46C9
	jp .l4608

; ---- data $46CC-$46CD (1 bytes) [HYPOTHESIS] UNCLASSIFIED 1 bytes: no code/data evidence (see analysis/mapper/unknown_spans.tsv for the hint)

Data_23_46CC:: ; 23:46CC
	db $C9

MailSrvDel_ConfirmSelect:: ; 23:46CD
	; [CONFIRMED] 25 insn(s) reached by static flow only; seeds: exec x25; min discovery hops 5;
	; entered by call from 23:46A4 (PROBABLE code) [executed in 2 scenarios]
	ld a, c
	cp a, $00
	jr nz, .l46EE
	push bc
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, BANK(MailServerDeleteMethod_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6828
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret
.l46EE ; 23:46EE
	push bc
	ld hl, wSpriteSlot1
	ld de, MailServerDeleteMethod_ObjTable
	ld a, BANK(MailServerDeleteMethod_ObjTable)
	ld b, $81
	farcall Sprite_InitSlot
	ld de, $6858
	ld hl, wSpriteSlot1
	call Sprite_SetPosition
	pop bc
	ret

; ---- text $470A-$478E (132 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PUSHC sjis
String_MailSrvDel_Confirm:: ; 23:470A
String_23_470A::
	db "このしょりをおこなうと　　　　　", 0
	db "サーバにある　すべてのメールが　", 0
	db "きえてしまいます　　　　　　　　", 0
	db "　　　　よろしいですか？　　　　", 0
POPC

MailSrvDel_UploadTextTiles:: ; 23:478E
Function_23_478E::
	; [CONFIRMED] 19 insn(s); 19 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
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

MailSrvDel_DrawTimerNumbers:: ; 23:47BC
Function_23_47BC::
	; [HYPOTHESIS] function body (push af/bc/de/hl prologue) that starts right after the ret at 47BB
	; and falls through into the CONFIRMED far call at 47ED; 31 insn decode chain lands exactly on
	; the next region start; no caller found (entry unproven) [verifier: no entry proven (no caller,
	; no valid table word, never executed): decode chain alone is not proof -> HYPOTHESIS] | forced
	; execution: 31/31 instruction starts ran in forced_dead (traces/forced/, not natural evidence;
	; status unchanged)
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
	call MailSrvDel_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDel_NumberOffset_23_4986
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
	ld hl, wMailTextScratch

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
	call MailSrvDel_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDel_NumberOffset_23_4986
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
	ld hl, wMailTextScratch
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
	call MailSrvDel_FormatDecimalStr
	pop hl
	push hl
	call MailSrvDel_NumberOffset_23_4986
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
	ld hl, wMailTextScratch
	farcall TextTiles_RenderLine
	pop hl
	call MailSrvDel_UploadDecimalTiles
	pop hl
	pop de
	pop bc
	pop af
	ret

MailSrvDel_FormatDecimalStr:: ; 23:4864
Function_23_4864::
	push hl
	push bc
	ld a, $01
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, String_MailSrvDel_NumberTemplate_23_497B
	ld de, wMailTextScratch
.loop ; 23:4872
	ld a, [hli]
	ld [de], a
	inc de
	cp a, $00
	jr nz, .loop
	pop bc
	pop hl
	push bc
	ld bc, wMailTextScratch + $01
	ld de, $2710
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l48D5
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
	jp .l4979
.l48D5 ; 23:48D5
	ld h, d
	ld l, e
	ld de, $03E8
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l491B
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
	jp .l4979
.l491B ; 23:491B
	ld h, d
	ld l, e
	ld de, $0064
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l494F
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
	jp .l4979
.l494F ; 23:494F
	ld h, d
	ld l, e
	ld de, $000A
	push bc
	farcall Divide16
	pop bc
	ld a, l
	cp a, $00
	jr z, .l4971
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
	jp .l4979
.l4971 ; 23:4971
	ld a, [bc]
	add a, e
	ld [bc], a
	inc bc
	xor a, a
	ld [bc], a
	ld a, $01
.l4979 ; 23:4979
	pop bc
	ret

; ---- text $497B-$4986 (11 bytes) [PROBABLE] 5 x fullwidth zero (82 4F) + NUL, addressed by ld hl,$497B at 23:486C

PUSHC sjis
String_MailSrvDel_NumberTemplate_23_497B:: ; 23:497B
String_23_497B::
	db "０００００", 0
POPC

MailSrvDel_NumberOffset_23_4986:: ; 23:4986
Function_23_4986::
	; [PROBABLE] 130 insn(s) reached by static flow only; seeds: exec x74, site x56; min discovery
	; hops 0; entered by call from 23:4809 (PROBABLE code) | 56 insn(s) never executed in the traced
	; runs; cut out of the PROBABLE region 4986-4AA4 by apply_coverage --split | forced execution:
	; 48/56 instruction starts ran in forced_dead (traces/forced/, not natural evidence; status
	; unchanged)
	push de
	push hl
	ld de, $2710
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l499C
	ld bc, $0000
	jp .l49E3
.l499C ; 23:499C
	ld h, d
	ld l, e
	ld de, $03E8
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l49B2
	ld bc, $0000
	jp .l49E3
.l49B2 ; 23:49B2
	ld h, d
	ld l, e
	ld de, $0064
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l49C8
	ld bc, $0000
	jp .l49E3
.l49C8 ; 23:49C8
	ld h, d
	ld l, e
	ld de, $000A
	farcall Divide16
	ld a, l
	cp a, $00
	jr z, .l49DE
	ld bc, $0000
	jp .l49E3
.l49DE ; 23:49DE
	ld bc, $0010
	ld a, $01
.l49E3 ; 23:49E3
	pop hl
	pop de
	ret

MailSrvDel_UploadDecimalTiles:: ; 23:49E6
Function_23_49E6::
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
