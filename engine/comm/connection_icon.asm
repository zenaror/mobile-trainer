; engine/comm/connection_icon.asm
; bank 69, $4000-$4152 (338 bytes); pinned by layout.link
; connection icon sprite animation and tile set choice

SECTION "engine/comm/connection_icon", ROMX

; ---- code $4000-$4008 (8 bytes) [CONFIRMED] 3 insn(s); 3 executed (in up to 1/18 scenarios); entry proven: target of an executed call/far call

ConnIcon_Init:: ; 69:4000
Function_69_4000::
	ld a, [wCommSessionKind]
	cp a, $01
	jp nz, Label_69_4013

; ---- code $4008-$4013 (11 bytes) [CONFIRMED] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0; fall-through of the jpcc at 69:4005 (executed) [executed in 1 scenarios]
	ld a, $03
	ld [wConnIconState], a
	xor a, a
	ld [wConnIconGfxRequest], a
	jr ConnIcon_Refresh

; ---- code $4013-$4045 (50 bytes) [CONFIRMED] 22 insn(s); 22 executed (in up to 1/18 scenarios)

Label_69_4013:: ; 69:4013
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
	ld [wSpriteSlots + 143], a
	ld hl, $DA80
	farcall ConnIcon_UpdateState
	jp ConnIcon_LoadGraphicsIfRequested

ConnIcon_UpdateState:: ; 69:4034
	ld bc, $000F
	add hl, bc
	ld a, [hl]
	cp a, $FF
	jr z, Label_69_403F
	or a, a
	ret nz

Label_69_403F:: ; 69:403F
	ld a, [wConnIconState]
	call JumpTableInline

; ---- ptrtable $4045-$4051 (12 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 69:4042: 6 entries; end pinned by the executed instruction at 4051

ConnIcon_StateTable:: ; 69:4045
Table_69_4045::
	dw Label_69_4051
	dw Label_69_406D
	dw Label_69_407F
	dw Label_69_4091
	dw Label_69_40AD
	dw Label_69_40BF

; ---- code $4051-$4074 (35 bytes) [CONFIRMED] 15 insn(s); 15 executed (in up to 1/18 scenarios)

Label_69_4051:: ; 69:4051
	ld a, [wConnIconGfxRequest]
	inc a
	ret z
	ld a, $01
	ld [wConnIconGfxRequest], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_69_4086

Label_69_4062:: ; 69:4062
	ld a, $01
	ld b, $01
	farcall ConnIcon_StartSprite
	ret

Label_69_406D:: ; 69:406D
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_69_4062

; ---- code $4074-$40D1 (93 bytes) [CONFIRMED] 37 insn(s) reached by static flow only; seeds: exec x37; min discovery hops 0; fall-through of the jrcc at 69:4072 (executed) [executed in 1 scenarios]
	ld a, $02
	ld b, $02
	farcall ConnIcon_StartSprite
	ret

Label_69_407F:: ; 69:407F
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_69_4062

Label_69_4086:: ; 69:4086
	ld a, $02
	ld b, $06
	farcall ConnIcon_StartSprite
	ret

Label_69_4091:: ; 69:4091
	ld a, [wConnIconGfxRequest]
	inc a
	ret z
	ld a, $02
	ld [wConnIconGfxRequest], a
	ld a, [wTimerEnable]
	bit 4, a
	jr z, Label_69_40C6

Label_69_40A2:: ; 69:40A2
	ld a, $04
	ld b, $04
	farcall ConnIcon_StartSprite
	ret

Label_69_40AD:: ; 69:40AD
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_69_40A2
	ld a, $05
	ld b, $05
	farcall ConnIcon_StartSprite
	ret

Label_69_40BF:: ; 69:40BF
	ld a, [wTimerEnable]
	bit 4, a
	jr nz, Label_69_40A2

Label_69_40C6:: ; 69:40C6
	ld a, $05
	ld b, $05
	farcall ConnIcon_StartSprite
	ret

; ---- code $40D1-$40DA (9 bytes) [CONFIRMED] 4 insn(s); 4 executed (in up to 4/18 scenarios); entry proven: target of an executed call/far call

ConnIcon_LoadGraphicsIfRequested:: ; 69:40D1
Function_69_40D1::
	ld a, [wConnIconGfxRequest]
	cp a, $FF
	ret z
	call JumpTableInline

; ---- ptrtable $40DA-$40E0 (6 bytes) [PROBABLE] inline table of `call $0545` (JumpTableInline) at 69:40D7: 3 entries; end = first entry target

ConnIcon_GfxTable:: ; 69:40DA
Table_69_40DA::
	dw Label_69_414D
	dw Label_69_4118
	dw Label_69_40E0

; ---- code $40E0-$4118 (56 bytes) [CONFIRMED] 18 insn(s) reached by static flow only; seeds: exec x18; min discovery hops 1; entered by table from 69:40D7 (executed) [executed in 1 scenarios]

Label_69_40E0:: ; 69:40E0
	ld de, $8200
	ld hl, Data_51_58C0
	ld a, $51
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8600
	ld hl, Data_51_5CC0
	ld a, $51
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld bc, $0020
	ld de, $D860
	ld hl, Data_51_5EC0
	ld a, $51
	farcall Palette_LoadToBuffer
	jp Label_69_414D

; ---- code $4118-$4152 (58 bytes) [CONFIRMED] 20 insn(s); 20 executed (in up to 4/18 scenarios)

Label_69_4118:: ; 69:4118
	ld de, $8200
	ld hl, ConnIcon_Tiles0
	ld a, $69
	ld b, $92
	ld c, $40
	farcall Function_00_0787
	ld de, $8600
	ld hl, ConnIcon_Tiles1
	ld a, $69
	ld b, $95
	ld c, $20
	farcall Function_00_0787
	ld bc, $0018
	ld de, $D860
	ld hl, ConnIcon_Palettes
	ld a, $69
	farcall Palette_LoadToBuffer

Label_69_414D:: ; 69:414D
	xor a, a
	ld [wConnIconGfxRequest], a
	ret
