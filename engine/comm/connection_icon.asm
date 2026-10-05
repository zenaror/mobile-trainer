; engine/comm/connection_icon.asm
; bank 69, $4000-$4152 (338 bytes); pinned by layout.link
; connection icon sprite animation and tile set choice

SECTION "engine/comm/connection_icon", ROMX

ConnIcon_Init:: ; 69:4000
Function_69_4000::
	; [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, .l4013

	; [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jpcc at 69:4005 (executed) [executed in 1 scenarios]
	ld a, $03
	ld [wConnIconState], a
	xor a, a
	ld [wConnIconGfxRequest], a
	jr ConnIcon_Refresh

.l4013 ; 69:4013
	; [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)
	xor a, a
	ld [wConnIconState], a
	ld [wConnIconGfxRequest], a

ConnIcon_Refresh:: ; 69:401A
	xor a, a
	ld [wRam_C2D0], a
	ld a, $07
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	xor a, a
	ld [wSpriteSlot8 + $0F], a
	ld hl, wSpriteSlot8
	farcall ConnIcon_UpdateState
	jp ConnIcon_LoadGraphicsIfRequested

ConnIcon_UpdateState:: ; 69:4034
	ld bc, $000F
	add hl, bc
	ld a, [hl]
	cp a, $FF
	jr z, .l403F
	or a, a
	ret nz
.l403F ; 69:403F
	ld a, [wConnIconState]
	call JumpTableInline

; ---- ptrtable $4045-$4051 (12 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 69:4042: 6 entries; end pinned by the executed instruction at 4051; all 6 handlers ran (142 + 2,912 + 233 + 2 + 284 + 143 hits = the 3,716 dispatches, 11 scenarios)

ConnIcon_StateTable:: ; 69:4045
Table_69_4045::
	dw ConnIcon_State0_RequestGfx1
	dw ConnIcon_State1
	dw ConnIcon_State2
	dw ConnIcon_State3_RequestGfx2
	dw ConnIcon_State4
	dw ConnIcon_State5

ConnIcon_State0_RequestGfx1:: ; 69:4051
Label_69_4051::
	; [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)
	ld a, [wConnIconGfxRequest]
	inc a
	ret z
	ld a, $01
	ld [wConnIconGfxRequest], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, ConnIcon_EnterState2_Anim6

ConnIcon_EnterState1_Anim1:: ; 69:4062
Label_69_4062::
	ld a, $01
	ld b, $01
	farcall ConnIcon_StartSprite
	ret

ConnIcon_State1:: ; 69:406D
Label_69_406D::
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, ConnIcon_EnterState1_Anim1

	; [CONFIRMED] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0;
	; fall-through of the jrcc at 69:4072 (executed) [executed in 1 scenarios]
	ld a, $02
	ld b, $02
	farcall ConnIcon_StartSprite
	ret

ConnIcon_State2:: ; 69:407F
Label_69_407F::
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, ConnIcon_EnterState1_Anim1

ConnIcon_EnterState2_Anim6:: ; 69:4086
Label_69_4086::
	ld a, $02
	ld b, $06
	farcall ConnIcon_StartSprite
	ret

ConnIcon_State3_RequestGfx2:: ; 69:4091
Label_69_4091::
	ld a, [wConnIconGfxRequest]
	inc a
	ret z
	ld a, $02
	ld [wConnIconGfxRequest], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, ConnIcon_EnterState5_Anim5

ConnIcon_EnterState4_Anim4:: ; 69:40A2
Label_69_40A2::
	ld a, $04
	ld b, $04
	farcall ConnIcon_StartSprite
	ret

ConnIcon_State4:: ; 69:40AD
Label_69_40AD::
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, ConnIcon_EnterState4_Anim4
	ld a, $05
	ld b, $05
	farcall ConnIcon_StartSprite
	ret

ConnIcon_State5:: ; 69:40BF
Label_69_40BF::
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, ConnIcon_EnterState4_Anim4

ConnIcon_EnterState5_Anim5:: ; 69:40C6
Label_69_40C6::
	ld a, $05
	ld b, $05
	farcall ConnIcon_StartSprite
	ret

ConnIcon_LoadGraphicsIfRequested:: ; 69:40D1
Function_69_40D1::
	; [CONFIRMED] 4 insn(s); 4 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, [wConnIconGfxRequest]
	cp a, $FF
	ret z
	call JumpTableInline

; ---- ptrtable $40DA-$40E0 (6 bytes) [CONFIRMED] inline table of `call $0545` (JumpTableInline) at 69:40D7: 3 entries; end = first entry target; all 3 handlers ran (184,262 + 142 + 2 = the 184,406 dispatches, 34 scenarios; the tail of the first handler is shared by the other two)

ConnIcon_GfxTable:: ; 69:40DA
Table_69_40DA::
	dw ConnIcon_LoadGraphics_ClearRequest
	dw ConnIcon_LoadGraphics_Request1
	dw ConnIcon_LoadGraphics_Request2

ConnIcon_LoadGraphics_Request2:: ; 69:40E0
Label_69_40E0::
	; [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1;
	; entered by table from 69:40D7 (executed) [executed in 1 scenarios]
	ld de, $8200
	ld hl, Gfx_ConnIcon_Request2_Tiles8200
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8600
	ld hl, Gfx_ConnIcon_Request2_Tiles8600
	ld a, $51
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0020
	ld de, wPaletteBufObj + $20
	ld hl, Palette_ConnIcon_Request2_Obj4
	ld a, $51
	farcall Palette_LoadToBuffer
	jp ConnIcon_LoadGraphics_ClearRequest

ConnIcon_LoadGraphics_Request1:: ; 69:4118
Label_69_4118::
	; [CONFIRMED] 20 insn(s); 20 executed (in up to 4/18 scenarios)
	ld de, $8200
	ld hl, ConnIcon_Tiles0
	ld a, $69
	ld b, $92
	ld c, $40
	farcall Gfx_StartHDMAWithService
	ld de, $8600
	ld hl, ConnIcon_Tiles1
	ld a, $69
	ld b, $95
	ld c, $20
	farcall Gfx_StartHDMAWithService
	ld bc, $0018
	ld de, wPaletteBufObj + $20
	ld hl, ConnIcon_Palettes
	ld a, $69
	farcall Palette_LoadToBuffer

ConnIcon_LoadGraphics_ClearRequest:: ; 69:414D
Label_69_414D::
	xor a, a
	ld [wConnIconGfxRequest], a
	ret
