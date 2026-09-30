; engine/browser/status_sprites.asm
; bank 4E, $5FB9-$60A6 (237 bytes); pinned by layout.link
; communication timer, OAM numbers, connection icon sprite

SECTION "engine/browser/status_sprites", ROMX

Browser_DrawCommTimer:: ; 4E:5FB9
Function_4E_5FB9::
	; [CONFIRMED] 111 insn(s); 111 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	farcall CommTime_AddTimerA
	ld a, [wBrowserTimerLastSec]
	ld c, a
	ldh a, [hRam_FFB1]
	cp a, c
	jr z, .l5FD5
	ld a, [wBrowserTimerSecToggle]
	xor a, $FF
	ld [wBrowserTimerSecToggle], a
	ldh a, [hRam_FFB1]
	ld [wBrowserTimerLastSec], a
.l5FD5 ; 4E:5FD5
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
	ld bc, $0017
	add hl, bc
	pop bc
	ld a, [hli]
	add a, $08
	ld e, a
	ld a, [hl]
	add a, $10
	ld d, a
	ld b, $00
	ld a, [wShadowOAMNextOffset]
	ld h, $C0
	ld l, a
	ld a, [wBrowserTimerSecToggle]
	or a, a
	jr nz, .l6014
	ldh a, [hRam_FFB2]
	ld c, $00
	call Browser_OamPutNumber
	ld c, $0A
	call Browser_OamPutDigit
	ldh a, [hRam_FFB1]
	ld c, $00
	jp Browser_OamPutNumber
.l6014 ; 4E:6014
	ldh a, [hRam_FFB2]
	ld c, $00
	call Browser_OamPutNumber
	ld c, $0A
	call Browser_OamPutDigit
	ldh a, [hRam_FFB1]
	ld c, $00

Browser_OamPutNumber:: ; 4E:6024
	inc c
	sub a, $0A
	jr nc, Browser_OamPutNumber
	add a, $0A
	dec c
	ldh [hRam_FFB0], a
	call Browser_OamPutDigit
	ldh a, [hRam_FFB0]
	ld c, a

Browser_OamPutDigit:: ; 4E:6034
	ld a, d
	ld [hli], a
	ld a, e
	ld [hli], a
	ld a, c
	ld [hli], a
	ld a, b
	ld [hli], a
	ld a, d
	add a, $08
	ld [hli], a
	ld a, e
	ld [hli], a
	add a, $08
	ld e, a
	ld a, c
	add a, $10
	ld [hli], a
	ld a, b
	ld [hli], a
	ret

ConnIcon_StartSprite:: ; 4E:604C
	ld [wConnIconState], a
	ld hl, $DA80
	ld de, ConnIcon_ObjTable
	ld a, $69
	farcall Sprite_InitSlot
	ld hl, $DA8B
	ld de, $4034
	ld a, $69
	call Sprite_SetHook
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
	ld bc, $0019
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld d, [hl]
	ld hl, $DA80
	jp Sprite_SetPosition

ConnIcon_GetBrowserFramePos:: ; 4E:6087
Function_4E_6087::
	; [HYPOTHESIS] complete small function (push bc/hl ... ret): a = [C2C2] & $7F -> word of the
	; screen-descriptor table 4E:654B -> hl+$19 -> de = word there; ret; same idiom as the executed
	; 4E:5E11 area and the getter before it (4E:6060-6087 ends with jp $0A65); no caller/pointer
	; found, entry unproven
	push bc
	push hl
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
	ld bc, $0019
	add hl, bc
	pop bc
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl
	pop bc
	ret
