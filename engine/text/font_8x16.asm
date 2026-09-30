; engine/text/font_8x16.asm
; bank 48, $4728-$4899 (369 bytes); pinned by layout.link
; Bcd_FromBinary8, Font_BlitGlyph8x16, Font_GlyphRunTable

SECTION "engine/text/font_8x16", ROMX

Bcd_FromBinary8:: ; 48:4728
	; [CONFIRMED] 141 insn(s); 141 executed (in up to 14/18 scenarios) (part of region $462A-$4744)
	or a, a
	jr z, .l4744
	ld b, a
	ld c, $0A
	farcall Divide8
	ld e, c
	ld c, $0A
	farcall Divide8
	ld a, c
	swap a
	and a, $F0
	or a, e
	ret

.l4744 ; 48:4744
	; [CONFIRMED] 3 insn(s) reached by static flow only; seeds: exec x3; min discovery hops 1;
	; entered by jrcc from 48:4729 (executed) [executed in 1 scenarios]
	ld a, $00
	ld b, a
	ret

Font_BlitGlyph8x16:: ; 48:4748
Function_48_4748::
	; [CONFIRMED] 118 insn(s); 118 executed (in up to 15/18 scenarios); entry proven: target of an
	; executed call/far call
	ld hl, sp+6
	ld a, [hli]
	ld [wFontArgCodeLo], a
	ld a, [hli]
	ld [wFontArgCodeHi], a
	ld a, [hli]
	ld [wFontArgDest1Ptr], a
	ld a, [hli]
	ld [wFontArgDest1Ptr + 1], a
	ld a, [hli]
	ld [wFontArgDest1Bank], a
	inc hl
	ld a, [hli]
	ld [wFontArgDest2Ptr], a
	ld a, [hli]
	ld [wFontArgDest2Ptr + 1], a
	ld a, [hli]
	ld [wFontArgDest2Bank], a
	inc hl
	ld a, [wFontArgCodeLo]
	ld e, a
	ld a, [wFontArgCodeHi]
	ld d, a
	ld hl, Font_GlyphRunTable
.l4777 ; 48:4777
	ld c, [hl]
	inc hl
	ld a, [hli]
	ld b, a
	inc a
	jp z, .done
	ld a, d
	sub a, b
	jr z, .l478A
	jr nc, .l4793
	inc hl
	inc hl
	inc hl
	jr .l4777
.l478A ; 48:478A
	ld a, e
	sub a, c
	jr nc, .l4793
	inc hl
	inc hl
	inc hl
	jr .l4777
.l4793 ; 48:4793
	ld a, e
	sub a, c
	ld c, a
	ld b, $00
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	sla c
	rl b
	ld d, [hl]
	inc hl
	ld a, [hli]
	ld h, [hl]
	ld l, a
	add hl, bc
	ldh [hScratchA], a
	ldh a, [hWRAMBank]
	push af
	ldh a, [hScratchA]
	ldh [hScratchA], a
	ldh a, [hSRAMBank]
	push af
	ldh a, [hScratchA]
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld b, h
	ld c, l
	ld a, [wFontArgDest1Ptr]
	ld l, a
	ld a, [wFontArgDest1Ptr + 1]
	ld h, a
	ld a, [wFontArgDest1Bank]
	ld d, a
	call BankSwitch_H
	ld e, $08
.l47D6 ; 48:47D6
	ld a, [bc]
	inc bc
	ld [hli], a
	ld [hli], a
	dec e
	jr nz, .l47D6
	ld a, [wFontArgDest2Ptr]
	ld l, a
	ld a, [wFontArgDest2Ptr + 1]
	ld h, a
	ld a, [wFontArgDest2Bank]
	ld d, a
	call BankSwitch_H
	ld e, $08
.l47EE ; 48:47EE
	ld a, [bc]
	inc bc
	ld [hli], a
	ld [hli], a
	dec e
	jr nz, .l47EE
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ldh [hScratchA], a
	pop af
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ldh a, [hScratchA]
	ldh [hScratchA], a
	pop af
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ldh a, [hScratchA]
	ret

.done ; 48:480F
	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 1;
	; entered by jpcc from 48:477C (executed) | forced execution: 1/1 instruction starts ran in
	; forced_screens (traces/forced/, not natural evidence; status unchanged)
	ret

; ---- data $4810-$4899 (137 bytes) [CONFIRMED] 27 five-byte records (key16 little-endian = SJIS code where a glyph run starts, bank byte $48, glyph-run pointer16) sorted by descending key + $FFFF terminator (ends 4899). Read by the executed glyph fetcher Function_48_4748 (loop at 48:4777: ld c,[hl]; ld b,[hli]; inc a; jp z end; stride 5 via 3 x inc hl); entry keys $83BF,$8340,$829F,$8281,$8260,$824F,$81F4,... $8140; pointers $5D7B,$53EB,$4EBB,$4D1B,$4B7B,$4ADB,... Unread 3-byte gaps folded in.

Font_GlyphRunTable:: ; 48:4810
Table_48_4810::
	db $BF, $83, $48
	dw Font_GlyphRun_83BF
	db $40, $83, $48
	dw Font_GlyphRun_8340
	db $9F, $82, $48
	dw Font_GlyphRun_829F
	db $81, $82, $48
	dw Font_GlyphRun_8281
	db $60, $82, $48
	dw Font_GlyphRun_8260
	db $4F, $82, $48
	dw Font_GlyphRun_824F
	db $F4, $81, $48
	dw Font_GlyphRun_81F4
	db $A6, $81, $48
	dw Font_GlyphRun_81A6
	db $9E, $81, $48
	dw Font_GlyphRun_819E
	db $99, $81, $48
	dw Font_GlyphRun_8199
	db $93, $81, $48
	dw Font_GlyphRun_8193
	db $8F, $81, $48
	dw Font_GlyphRun_818F
	db $89, $81, $48
	dw Font_GlyphRun_8189
	db $83, $81, $48
	dw Font_GlyphRun_8183
	db $80, $81, $48
	dw Font_GlyphRun_8180
	db $7E, $81, $48
	dw Font_GlyphRun_817E
	db $75, $81, $48
	dw Font_GlyphRun_8175
	db $6D, $81, $48
	dw Font_GlyphRun_816D
	db $69, $81, $48
	dw Font_GlyphRun_8169
	db $68, $81, $48
	dw Font_GlyphRun_8168
	db $65, $81, $48
	dw Font_GlyphRun_8165
	db $62, $81, $48
	dw Font_GlyphRun_8162
	db $60, $81, $48
	dw Font_GlyphRun_8160
	db $5E, $81, $48
	dw Font_GlyphRun_815E
	db $5B, $81, $48
	dw Font_GlyphRun_815B
	db $4F, $81, $48
	dw Font_GlyphRun_814F
	db $40, $81, $48
	dw Font_GlyphRun_8140
	db $FF, $FF
