; engine/browser/page_results.asm
; bank 4C, $4DB2-$4F56 (420 bytes); pinned by layout.link
; error-to-result mapping and the image-in-HTML wrapper with its template strings

SECTION "engine/browser/page_results", ROMX

Browser_MapErrorToResult:: ; 4C:4DB2
Function_4C_4DB2::
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	cp a, $10
	jr c, .l4DD3
	cp a, $34
	jr nc, .l4DD3
	cp a, $26
	jr nz, .l4DC7

	; [PROBABLE] 5 insn(s) reached by static flow only; seeds: exec x5; min discovery hops 0;
	; fall-through of the jrcc at 4C:4DBC (executed)
	ld l, a
	ld a, [wCommSessionKind]
	cp a, $01
	jr z, .l4DD3
	ld a, l

.l4DC7 ; 4C:4DC7
	; [CONFIRMED] 8 insn(s); 8 executed (in up to 1/18 scenarios)
	sub a, $10
	add a, $D6
	ld l, a
	ld a, $00
	adc a, $4D
	ld h, a
	ld a, [hl]
	ret

.l4DD3 ; 4C:4DD3
	; [PROBABLE] 2 insn(s) reached by static flow only; seeds: exec x2; min discovery hops 1;
	; entered by jrcc from 4C:4DB4 (executed)
	ld a, $84
	ret

; ---- data $4DD6-$4DFB (37 bytes) [PROBABLE] 37-byte lookup table indexed by (a - $10): the routine at 4DC7 does sub $10 / add $D6 / adc $4D and ld a,[hl] (base $4DD6); values $84/$03/$05...; last bytes read by executed code at 4DF8

Table_Browser_ErrorResult:: ; 4C:4DD6
Table_4C_4DD6::
	db $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84, $84
	db $84, $84, $84, $84, $03, $84, $05, $84, $84, $84, $84, $84, $84, $84, $84, $84
	db $03, $03, $03, $03, $84

Browser_WrapImageInHtml:: ; 4C:4DFB
Function_4C_4DFB::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 2/18 scenarios); entry proven: target of an
	; executed call/far call
	call Sound_FrameService
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, $D500
	ld bc, $FFFF
.l4E0A ; 4C:4E0A
	inc bc
	ld a, [hli]
	or a, a
	jp z, .l4F06
	cp a, $2E
	jr nz, .l4E0A
	inc bc
	ld a, [hli]
	cp a, $42
	jr z, .l4E1E
	cp a, $62
	jr nz, .l4E0A

.l4E1E ; 4C:4E1E
	; [CONFIRMED] 124 insn(s) reached by static flow only; seeds: exec x124; min discovery hops 0;
	; entered by jrcc from 4C:4E18 (executed) | 22 insn(s) executed; cut out of the PROBABLE region
	; 4E1E-4F06 by apply_coverage --split [executed in 1 scenarios]
	inc bc
	ld a, [hli]
	cp a, $4D
	jr z, .l4E28
	cp a, $6D
	jr nz, .l4E0A
.l4E28 ; 4C:4E28
	inc bc
	ld a, [hli]
	cp a, $50
	jr z, .l4E32
	cp a, $70
	jr nz, .l4E0A
.l4E32 ; 4C:4E32
	ld a, [hld]
	or a, a
	jr nz, .l4E0A
.l4E36 ; 4C:4E36
	ld a, [hld]
	cp a, $2F
	jr z, .l4E42
	dec bc
	ld a, c
	or a, b
	jr nz, .l4E36

	; [PROBABLE] 1 insn(s) never executed in the traced runs; cut out of the PROBABLE region
	; 4E1E-4F06 by apply_coverage --split
	jr .l4E44

.l4E42 ; 4C:4E42
	; [CONFIRMED] 101 insn(s) executed; cut out of the PROBABLE region 4E1E-4F06 by apply_coverage
	; --split [executed in 1 scenarios]
	inc hl
	inc hl
.l4E44 ; 4C:4E44
	push hl
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sBrowserPageBuf + $02
	farcall Bmp_Validate
	or a, a
	jp z, .l4F05
	ld de, $C382
	ld hl, String_Html_PageHead
	farcall CopyString
	dec de
	pop hl
	farcall CopyString
	dec de
	ld hl, String_Html_TitleToImg
	farcall CopyString
	dec de
	ld hl, $D500
	farcall CopyString
	dec de
	ld hl, String_Html_ImgTail
	farcall CopyString
	dec de
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld [de], a
	inc de
	ld hl, $D500
	farcall CopyString
	dec de
	ld bc, $0001
	ld hl, $C382
.l4EAC ; 4C:4EAC
	inc bc
	ld a, [hli]
	or a, a
	jr nz, .l4EAC
	ld a, c
	ld [wAttrUrlBuf], a
	ld a, b
	ld [wAttrUrlBuf + 1], a
	inc bc
	inc bc
	inc bc
	inc bc
	inc hl
	inc hl
	inc hl
	inc hl
.l4EC1 ; 4C:4EC1
	inc bc
	ld a, [hli]
	or a, a
	jr nz, .l4EC1
	inc bc
	call Sound_FrameService
	ld a, [sBrowserPageBuf]
	ld l, a
	ld a, [sBrowserPageBuf + $01]
	ld h, a
	inc hl
	inc hl
	ld e, l
	ld d, h
	add hl, bc
	ld a, h
	cp a, $10
	jr nc, .l4F06
	push bc
	ld c, e
	ld b, d
	pop de
	push de
	ld hl, $AFFF
	add hl, bc
	add hl, de
	ld e, l
	ld d, h
	ld hl, $AFFF
	add hl, bc
	call CopyBytesBackward
	pop bc
	ld hl, $C380
	ld de, sBrowserPageBuf
	call CopyBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Sound_FrameService
	ld a, $01
	ret
.l4F05 ; 4C:4F05
	pop hl

.l4F06 ; 4C:4F06
	; [CONFIRMED] 6 insn(s); 6 executed (in up to 2/18 scenarios)
	call Sound_FrameService
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

; ---- text $4F11-$4F25 (20 bytes) [PROBABLE] ASCII "<html><head><title>" NUL, loaded by ld hl,$4F11 at 4C:4E63 (HTML page template pieces)

PUSHC sjis
String_Html_PageHead:: ; 4C:4F11
String_4C_4F11::
	db "<html><head><title>", 0
POPC

; ---- text $4F25-$4F45 (32 bytes) [PROBABLE] ASCII "</title></head><body><img src=\"" NUL, loaded by ld hl,$4F25 at 4C:4E75

PUSHC sjis
String_Html_TitleToImg:: ; 4C:4F25
String_4C_4F25::
	db "</title></head><body><img src=\"", 0
POPC

; ---- text $4F45-$4F56 (17 bytes) [PROBABLE] ASCII "\"></body></html>" NUL, loaded by ld hl,$4F45 at 4C:4E89

PUSHC sjis
String_Html_ImgTail:: ; 4C:4F45
String_4C_4F45::
	db "\"></body></html>", 0
POPC
