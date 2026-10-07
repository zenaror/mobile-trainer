; engine/browser/canvas.asm
; bank 4E, $60A6-$6196 (240 bytes); pinned by layout.link
; title/body canvas upload and clear

SECTION "engine/browser/canvas", ROMX

Browser_UploadTitleCanvas:: ; 4E:60A6
Function_4E_60A6::
	; [CONFIRMED] 82 insn(s); 82 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	ld de, $9000
	ld hl, $1002
	ld bc, $010F
	farcall TileCanvas_UploadRect
	ld de, $90F0
	ld hl, $1102
	ld bc, $010F
	farcall TileCanvas_UploadRect
	ret

Browser_UploadBodyCanvas:: ; 4E:60C5
	ld de, $9200
	ld hl, $0001
	ld bc, $0512
	farcall TileCanvas_UploadRect
	ld de, $8800
	ld hl, $0501
	ld bc, $0712
	farcall TileCanvas_UploadRect
	ret

Browser_ClearTitleArea:: ; 4E:60E4
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
	ld de, $0100
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $0020
	add hl, bc
	ld bc, $010F
	ld de, $010F
	farcall Tilemap_FillAscendingWithAttr
	ld de, $0000
	ld hl, $1000
	ld bc, $0214
	farcall TileCanvas_FillRect
	ret

Browser_ClearBodyArea:: ; 4E:612B
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
	ld de, $0020
	farcall Tilemap_FillAscendingWithAttr
	pop hl
	ld bc, $00A0
	add hl, bc
	ld bc, $0712
	ld de, $0080
	farcall Tilemap_FillAscendingWithAttr
	ld de, $0000
	ld hl, $0000
	ld bc, $0C14
	farcall TileCanvas_FillRect
	ret

Function_4E_6172:: ; 4E:6172
	; [HYPOTHESIS] function: cp a,1 ; ret nz ; SRAM enable, reads [A9ED] bit 7, returns b=$19/$1A in
	; a, SRAM disable, ret; 18 insn, ends exactly where the executed function 4E:6196 starts; no
	; caller/pointer found, entry unproven
	cp a, $01
	ret nz
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld b, $1A
	ld a, [sSaveCheckStateBlock + $05]
	bit 7, a
	jr z, .skip
	ld b, $19
.skip ; 4E:618E
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, b
	ret
