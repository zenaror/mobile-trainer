; home/text.asm
; bank 00, $0ED3-$10E9 (534 bytes); pinned by layout.link
; text byte-stream interpreter, control-code handlers, character output, glyph drawing

SECTION "home/text", ROM0

TextEngine_Run:: ; 00:0ED3
Function_00_0ED3::
	; [CONFIRMED] byte-stream (text) interpreter: A=bank of string, HL=pointer. Bytes <$20 dispatch
	; through Table_00_0EF0 (handler entered with the string pointer on the stack), bytes >=$20 are
	; characters (see 0F30). FFB9=current bank, FFBF=call depth [reached via inferred links; raw
	; refs 43] [executed in 26 scenarios]
	ldh [hRam_FFB9], a
	xor a, a
	ldh [hRam_FFBF], a

TextEngine_ReloadBank:: ; 00:0ED8
Label_00_0ED8::
	ldh a, [hRam_FFB9]
	call BankSwitch_H

TextEngine_NextByte:: ; 00:0EDD
Label_00_0EDD::
	ld a, [hli]
	cp a, $20
	jr nc, TextEngine_PutChar
	push hl
	add a, a
	add a, $F0
	ld l, a
	ld a, $00
	adc a, $0E
	ld h, a
	ld a, [hli]
	ld h, [hl]
	ld l, a
	jp hl

; ---- words $0EF0-$0F30 (64 bytes) [CONFIRMED] 32 handler pointers for control bytes $00-$1F (indexed at 0EE3-0EEF)

Table_TextEngine_CmdHandlers:: ; 00:0EF0
Table_00_0EF0::
	dw TextEngine_Cmd00_End, TextEngine_Cmd01_CallString, TextEngine_Cmd02_SetY, TextEngine_Cmd03_SetX, TextEngine_Cmd04_SetPos, TextEngine_Cmd05_SetPos, TextEngine_Cmd06_SetPos, TextEngine_Cmd07_SetPos
	dw TextEngine_Cmd00_End, TextEngine_Cmd09_Tab, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd0D_NewLine, TextEngine_Cmd00_End, TextEngine_Cmd00_End
	dw TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End
	dw TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd00_End, TextEngine_Cmd1C_SetX16, TextEngine_Cmd1D_SetY, TextEngine_Cmd1E_AddX16, TextEngine_Cmd1F_AddY

TextEngine_PutChar:: ; 00:0F30
Function_00_0F30::
	; [CONFIRMED] character output: C=byte; lead bytes $81-$9F,$E0-$EF,$F8-$F9 take a second byte
	; and draw a double-byte glyph (1044), others a single glyph (10B1); then call 0392, wrap when
	; x(FFBD) exceeds limit FFC4 (newline at 0F69)
	ld c, a
	cp a, $81
	jr c, .l0F49
	cp a, $A0
	jr c, .l0F4A
	cp a, $E0
	jr c, .l0F49
	cp a, $F0
	jr c, .l0F4A
	cp a, $F8
	jr c, .l0F49
	cp a, $FA
	jr c, .l0F4A
.l0F49 ; 00:0F49
	or a, a
.l0F4A ; 00:0F4A
	jr c, .l0F53
	push hl
	call TextEngine_DrawNarrowGlyph
	pop hl
	jr TextEngine_AfterChar
.l0F53 ; 00:0F53
	ld a, [hli]
	ld b, a
	push hl
	call TextEngine_DrawWideGlyph
	pop hl

TextEngine_AfterChar:: ; 00:0F5A
Label_00_0F5A::
	call Sound_FrameService
	ldh a, [hTextX]
	ld c, a
	ldh a, [hRam_FFC4]
	cp a, c
	jr c, TextEngine_LineWrap
	jp TextEngine_ReloadBank

TextEngine_Cmd0D_NewLine:: ; 00:0F68
Function_00_0F68::
	; [CONFIRMED] control byte $0D (newline): X(FFBD/E)=FFC1/FFC2; if FFC6==$FF return (end of text,
	; 0F73-0F75); else Y(FFBC)+=FFC6 and continue only while Y<=FFC3 (0F7E cp, jp nc,$0ED8),
	; otherwise return
	pop hl

TextEngine_LineWrap:: ; 00:0F69
Label_00_0F69::
	ldh a, [hRam_FFC1]
	ldh [hTextX], a
	ldh a, [hRam_FFC2]
	ldh [hTextX + 1], a
	ldh a, [hRam_FFC6]
	ld b, a
	inc a
	ret z
	ldh a, [hTextY]
	add a, b
	ldh [hTextY], a
	ld c, a
	ldh a, [hRam_FFC3]
	cp a, c
	jp nc, TextEngine_ReloadBank
	ret

TextEngine_Cmd01_CallString:: ; 00:0F83
Function_00_0F83::
	; [CONFIRMED] control byte $01: call sub-string: reads addr16 + bank, pushes return pointer and
	; bank, depth++ (FFBF), continues in the new string
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	push hl
	ldh a, [hRam_FFB9]
	push af
	ldh a, [hRam_FFB0]
	ldh [hRam_FFB9], a
	ld h, b
	ld l, c
	ldh a, [hRam_FFBF]
	inc a
	ldh [hRam_FFBF], a
	jp TextEngine_ReloadBank

TextEngine_Cmd00_End:: ; 00:0F9D
Function_00_0F9D::
	; [CONFIRMED] control byte $00/$08/$0A-$0C/$0E-$1B: end of string: at depth 0 return to caller,
	; else pop the saved pointer/bank and continue
	pop hl
	ldh a, [hRam_FFBF]
	or a, a
	ret z
	dec a
	ldh [hRam_FFBF], a
	pop hl
	pop af
	ldh [hRam_FFB9], a
	jp TextEngine_ReloadBank

TextEngine_Cmd02_SetY:: ; 00:0FAC
Function_00_0FAC::
	; [CONFIRMED] control byte $02: FFBC = next byte
	pop hl
	ld a, [hli]
	ldh [hTextY], a
	jp TextEngine_NextByte

TextEngine_Cmd03_SetX:: ; 00:0FB3
Function_00_0FB3::
	; [CONFIRMED] control byte $03: FFBD = next byte
	pop hl
	ld a, [hli]
	ldh [hTextX], a
	jp TextEngine_NextByte

TextEngine_Cmd04_SetPos:: ; 00:0FBA
Function_00_0FBA::
	; [CONFIRMED] control byte $04: FFBC=3, FFBD=0
	pop hl
	ld a, $03
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp TextEngine_NextByte

TextEngine_Cmd05_SetPos:: ; 00:0FC6
Function_00_0FC6::
	; [CONFIRMED] control byte $05: FFBC=1, FFBD=0
	pop hl
	ld a, $01
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp TextEngine_NextByte

TextEngine_Cmd06_SetPos:: ; 00:0FD2
Function_00_0FD2::
	; [CONFIRMED] control byte $06: FFBC=2, FFBD=0
	pop hl
	ld a, $02
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp TextEngine_NextByte

TextEngine_Cmd07_SetPos:: ; 00:0FDE
Function_00_0FDE::
	; [CONFIRMED] control byte $07: FFBC=0, FFBD=2
	pop hl
	ld a, $00
	ldh [hTextY], a
	ld a, $02
	ldh [hTextX], a
	jp TextEngine_NextByte

TextEngine_Cmd1C_SetX16:: ; 00:0FEA
Function_00_0FEA::
	; [CONFIRMED] control byte $1C: FFBD/FFBE = next word
	pop hl
	ld a, [hli]
	ldh [hTextX], a
	ld a, [hli]
	ldh [hTextX + 1], a
	jp TextEngine_AfterChar

TextEngine_Cmd1D_SetY:: ; 00:0FF4
Function_00_0FF4::
	; [CONFIRMED] control byte $1D: FFBC = next byte
	pop hl
	ld a, [hli]
	ldh [hTextY], a
	jp TextEngine_AfterChar

TextEngine_Cmd1E_AddX16:: ; 00:0FFB
Function_00_0FFB::
	; [CONFIRMED] control byte $1E: FFBD/FFBE += next word
	pop hl
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ldh a, [hTextX]
	add a, c
	ldh [hTextX], a
	ldh a, [hTextX + 1]
	adc a, b
	ldh [hTextX + 1], a
	jp TextEngine_AfterChar

TextEngine_Cmd1F_AddY:: ; 00:100D
Function_00_100D::
	; [CONFIRMED] control byte $1F: FFBC += next byte
	pop hl
	ld a, [hli]
	ld c, a
	ldh a, [hTextY]
	add a, c
	ldh [hTextY], a
	jp TextEngine_AfterChar

TextEngine_Cmd09_Tab:: ; 00:1018
Function_00_1018::
	; [CONFIRMED] control byte $09: FFBD/FFBE += $30
	pop hl
	ldh a, [hTextX]
	add a, $30
	ldh [hTextX], a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	jp TextEngine_AfterChar

TextEngine_DrawChar:: ; 00:1028
Function_00_1028::
	; [PROBABLE] draw character C: same lead-byte test as 0F30, then 10B1 (single) or 1044 (double:
	; far calls into bank 7F glyph routines; y limit $90, x limit $A0) [candidate; raw refs 50] |
	; inline far pointer: FarCall at 1053: dw $405F ; db $7F -> 7F:405F | 15 insn(s) never executed
	; in the traced runs; cut out of the PROBABLE region 1028-1059 by apply_coverage --split
	ld a, c
	cp a, $81
	jr c, .l1041
	cp a, $A0
	jr c, .l1042
	cp a, $E0
	jr c, .l1041
	cp a, $F0
	jr c, .l1042
	cp a, $F8
	jr c, .l1041
	cp a, $FA
	jr c, .l1042
.l1041 ; 00:1041
	or a, a
.l1042 ; 00:1042
	jr nc, TextEngine_DrawNarrowGlyph

TextEngine_DrawWideGlyph:: ; 00:1044
Function_00_1044::
	; [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 1028-1059 by apply_coverage
	; --split [executed in 37 scenarios]
	ld h, c
	ld l, b
	ldh a, [hTextY]
	cp a, $90
	jr nc, Function_00_1079
	ld de, $C0B8
	ld bc, $C0A0
	xor a, a
	farcall Glyph_LoadWide

Function_00_1059:: ; 00:1059
	; [CONFIRMED] continuation of Function_00_1028 | inline far pointer: FarCall at 1073: dw $42C3 ;
	; db $7F -> 7F:42C3
	ldh a, [hTextX + 1]
	or a, a
	jr nz, Function_00_1079
	ldh a, [hTextX]
	cp a, $A0
	jr nc, Function_00_1079
	ldh a, [hRam_FFBA]
	ld b, a
	ldh a, [hRam_FFBB]
	ld c, a
	ldh a, [hTextY]
	ld d, a
	ldh a, [hTextX]
	ld e, a
	ld hl, $C0A0
	farcall Canvas_BlitGlyph

Function_00_1079:: ; 00:1079
	; [CONFIRMED] continuation of Function_00_1028 | inline far pointer: FarCall at 109D: dw $42C3 ;
	; db $7F -> 7F:42C3
	ldh a, [hTextX]
	add a, $06
	ldh [hTextX], a
	ld e, a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	jr nz, Function_00_10A3
	ld a, e
	cp a, $A0
	jr nc, Function_00_10A3
	ldh a, [hTextY]
	cp a, $90
	jr nc, Function_00_10A3
	ld d, a
	ldh a, [hRam_FFBA]
	ld b, a
	ldh a, [hRam_FFBB]
	ld c, a
	ld hl, $C0B8
	farcall Canvas_BlitGlyph

Function_00_10A3:: ; 00:10A3
	; [CONFIRMED] continuation
	ldh a, [hTextX]
	add a, $06
	ldh [hTextX], a
	ld e, a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	ret

TextEngine_DrawNarrowGlyph:: ; 00:10B1
Function_00_10B1::
	; [CONFIRMED] draw single-byte glyph (far calls into bank 7F: 7F:4007, 7F:42C3) | inline far
	; pointer: FarCall at 10C0: dw $4007 ; db $7F -> 7F:4007
	ld b, c
	ldh a, [hTextX + 1]
	or a, a
	jr nz, Function_00_10DB
	ldh a, [hTextX]
	cp a, $A0
	jr nc, Function_00_10DB
	ld de, $C0A0
	farcall Glyph_LoadAscii

Function_00_10C6:: ; 00:10C6
	; [CONFIRMED] continuation of Function_00_10B1 | inline far pointer: FarCall at 10D5: dw $42C3 ;
	; db $7F -> 7F:42C3
	ldh a, [hRam_FFBA]
	ld b, a
	ldh a, [hRam_FFBB]
	ld c, a
	ldh a, [hTextY]
	ld d, a
	ldh a, [hTextX]
	ld e, a
	ld hl, $C0A0
	farcall Canvas_BlitGlyph

Function_00_10DB:: ; 00:10DB
	; [CONFIRMED] continuation
	ldh a, [hTextX]
	add a, $06
	ldh [hTextX], a
	ld e, a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	ret
