; home/text.asm
; bank 00, $0ED3-$10E9 (534 bytes); pinned by layout.link
; text byte-stream interpreter, control-code handlers, character output, glyph drawing

SECTION "home/text", ROM0

; ---- code $0ED3-$0EF0 (29 bytes) [CONFIRMED] byte-stream (text) interpreter: A=bank of string, HL=pointer. Bytes <$20 dispatch through Table_00_0EF0 (handler entered with the string pointer on the stack), bytes >=$20 are characters (see 0F30). FFB9=current bank, FFBF=call depth [reached via inferred links; raw refs 43] [executed in 26 scenarios]

Function_00_0ED3:: ; 00:0ED3
	ldh [hRam_FFB9], a
	xor a, a
	ldh [hRam_FFBF], a

Label_00_0ED8:: ; 00:0ED8
	ldh a, [hRam_FFB9]
	call BankSwitch_H

Label_00_0EDD:: ; 00:0EDD
	ld a, [hli]
	cp a, $20
	jr nc, Function_00_0F30
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

Table_00_0EF0:: ; 00:0EF0
	dw Function_00_0F9D, Function_00_0F83, Function_00_0FAC, Function_00_0FB3, Function_00_0FBA, Function_00_0FC6, Function_00_0FD2, Function_00_0FDE
	dw Function_00_0F9D, Function_00_1018, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F68, Function_00_0F9D, Function_00_0F9D
	dw Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D
	dw Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0F9D, Function_00_0FEA, Function_00_0FF4, Function_00_0FFB, Function_00_100D

; ---- code $0F30-$0F68 (56 bytes) [CONFIRMED] character output: C=byte; lead bytes $81-$9F,$E0-$EF,$F8-$F9 take a second byte and draw a double-byte glyph (1044), others a single glyph (10B1); then call 0392, wrap when x(FFBD) exceeds limit FFC4 (newline at 0F69)

Function_00_0F30:: ; 00:0F30
	ld c, a
	cp a, $81
	jr c, Label_00_0F49
	cp a, $A0
	jr c, Label_00_0F4A
	cp a, $E0
	jr c, Label_00_0F49
	cp a, $F0
	jr c, Label_00_0F4A
	cp a, $F8
	jr c, Label_00_0F49
	cp a, $FA
	jr c, Label_00_0F4A

Label_00_0F49:: ; 00:0F49
	or a, a

Label_00_0F4A:: ; 00:0F4A
	jr c, Label_00_0F53
	push hl
	call Function_00_10B1
	pop hl
	jr Label_00_0F5A

Label_00_0F53:: ; 00:0F53
	ld a, [hli]
	ld b, a
	push hl
	call Function_00_1044
	pop hl

Label_00_0F5A:: ; 00:0F5A
	call Function_00_0392
	ldh a, [hTextX]
	ld c, a
	ldh a, [hRam_FFC4]
	cp a, c
	jr c, Label_00_0F69
	jp Label_00_0ED8

; ---- code $0F68-$0F83 (27 bytes) [CONFIRMED] control byte $0D (newline): X(FFBD/E)=FFC1/FFC2; if FFC6==$FF return (end of text, 0F73-0F75); else Y(FFBC)+=FFC6 and continue only while Y<=FFC3 (0F7E cp, jp nc,$0ED8), otherwise return

Function_00_0F68:: ; 00:0F68
	pop hl

Label_00_0F69:: ; 00:0F69
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
	jp nc, Label_00_0ED8
	ret

; ---- code $0F83-$0F9D (26 bytes) [CONFIRMED] control byte $01: call sub-string: reads addr16 + bank, pushes return pointer and bank, depth++ (FFBF), continues in the new string

Function_00_0F83:: ; 00:0F83
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
	jp Label_00_0ED8

; ---- code $0F9D-$0FAC (15 bytes) [CONFIRMED] control byte $00/$08/$0A-$0C/$0E-$1B: end of string: at depth 0 return to caller, else pop the saved pointer/bank and continue

Function_00_0F9D:: ; 00:0F9D
	pop hl
	ldh a, [hRam_FFBF]
	or a, a
	ret z
	dec a
	ldh [hRam_FFBF], a
	pop hl
	pop af
	ldh [hRam_FFB9], a
	jp Label_00_0ED8

; ---- code $0FAC-$0FB3 (7 bytes) [CONFIRMED] control byte $02: FFBC = next byte

Function_00_0FAC:: ; 00:0FAC
	pop hl
	ld a, [hli]
	ldh [hTextY], a
	jp Label_00_0EDD

; ---- code $0FB3-$0FBA (7 bytes) [CONFIRMED] control byte $03: FFBD = next byte

Function_00_0FB3:: ; 00:0FB3
	pop hl
	ld a, [hli]
	ldh [hTextX], a
	jp Label_00_0EDD

; ---- code $0FBA-$0FC6 (12 bytes) [CONFIRMED] control byte $04: FFBC=3, FFBD=0

Function_00_0FBA:: ; 00:0FBA
	pop hl
	ld a, $03
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp Label_00_0EDD

; ---- code $0FC6-$0FD2 (12 bytes) [CONFIRMED] control byte $05: FFBC=1, FFBD=0

Function_00_0FC6:: ; 00:0FC6
	pop hl
	ld a, $01
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp Label_00_0EDD

; ---- code $0FD2-$0FDE (12 bytes) [CONFIRMED] control byte $06: FFBC=2, FFBD=0

Function_00_0FD2:: ; 00:0FD2
	pop hl
	ld a, $02
	ldh [hTextY], a
	ld a, $00
	ldh [hTextX], a
	jp Label_00_0EDD

; ---- code $0FDE-$0FEA (12 bytes) [CONFIRMED] control byte $07: FFBC=0, FFBD=2

Function_00_0FDE:: ; 00:0FDE
	pop hl
	ld a, $00
	ldh [hTextY], a
	ld a, $02
	ldh [hTextX], a
	jp Label_00_0EDD

; ---- code $0FEA-$0FF4 (10 bytes) [CONFIRMED] control byte $1C: FFBD/FFBE = next word

Function_00_0FEA:: ; 00:0FEA
	pop hl
	ld a, [hli]
	ldh [hTextX], a
	ld a, [hli]
	ldh [hTextX + 1], a
	jp Label_00_0F5A

; ---- code $0FF4-$0FFB (7 bytes) [CONFIRMED] control byte $1D: FFBC = next byte

Function_00_0FF4:: ; 00:0FF4
	pop hl
	ld a, [hli]
	ldh [hTextY], a
	jp Label_00_0F5A

; ---- code $0FFB-$100D (18 bytes) [CONFIRMED] control byte $1E: FFBD/FFBE += next word

Function_00_0FFB:: ; 00:0FFB
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
	jp Label_00_0F5A

; ---- code $100D-$1018 (11 bytes) [CONFIRMED] control byte $1F: FFBC += next byte

Function_00_100D:: ; 00:100D
	pop hl
	ld a, [hli]
	ld c, a
	ldh a, [hTextY]
	add a, c
	ldh [hTextY], a
	jp Label_00_0F5A

; ---- code $1018-$1028 (16 bytes) [CONFIRMED] control byte $09: FFBD/FFBE += $30

Function_00_1018:: ; 00:1018
	pop hl
	ldh a, [hTextX]
	add a, $30
	ldh [hTextX], a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	jp Label_00_0F5A

; ---- code $1028-$1044 (28 bytes) [PROBABLE] draw character C: same lead-byte test as 0F30, then 10B1 (single) or 1044 (double: far calls into bank 7F glyph routines; y limit $90, x limit $A0) [candidate; raw refs 50] | inline far pointer: FarCall at 1053: dw $405F ; db $7F -> 7F:405F | 15 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1028-1059 by apply_coverage --split

Function_00_1028:: ; 00:1028
	ld a, c
	cp a, $81
	jr c, Label_00_1041
	cp a, $A0
	jr c, Label_00_1042
	cp a, $E0
	jr c, Label_00_1041
	cp a, $F0
	jr c, Label_00_1042
	cp a, $F8
	jr c, Label_00_1041
	cp a, $FA
	jr c, Label_00_1042

Label_00_1041:: ; 00:1041
	or a, a

Label_00_1042:: ; 00:1042
	jr nc, Function_00_10B1

; ---- code $1044-$1059 (21 bytes) [CONFIRMED] 9 insn(s) executed; cut out of the PROBABLE region 1028-1059 by apply_coverage --split [executed in 37 scenarios]

Function_00_1044:: ; 00:1044
	ld h, c
	ld l, b
	ldh a, [hTextY]
	cp a, $90
	jr nc, Function_00_1079
	ld de, $C0B8
	ld bc, $C0A0
	xor a, a
	farcall Glyph_LoadWide

; ---- code $1059-$1079 (32 bytes) [CONFIRMED] continuation of Function_00_1028 | inline far pointer: FarCall at 1073: dw $42C3 ; db $7F -> 7F:42C3

Function_00_1059:: ; 00:1059
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

; ---- code $1079-$10A3 (42 bytes) [CONFIRMED] continuation of Function_00_1028 | inline far pointer: FarCall at 109D: dw $42C3 ; db $7F -> 7F:42C3

Function_00_1079:: ; 00:1079
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

; ---- code $10A3-$10B1 (14 bytes) [CONFIRMED] continuation

Function_00_10A3:: ; 00:10A3
	ldh a, [hTextX]
	add a, $06
	ldh [hTextX], a
	ld e, a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	ret

; ---- code $10B1-$10C6 (21 bytes) [CONFIRMED] draw single-byte glyph (far calls into bank 7F: 7F:4007, 7F:42C3) | inline far pointer: FarCall at 10C0: dw $4007 ; db $7F -> 7F:4007

Function_00_10B1:: ; 00:10B1
	ld b, c
	ldh a, [hTextX + 1]
	or a, a
	jr nz, Function_00_10DB
	ldh a, [hTextX]
	cp a, $A0
	jr nc, Function_00_10DB
	ld de, $C0A0
	farcall Glyph_LoadAscii

; ---- code $10C6-$10DB (21 bytes) [CONFIRMED] continuation of Function_00_10B1 | inline far pointer: FarCall at 10D5: dw $42C3 ; db $7F -> 7F:42C3

Function_00_10C6:: ; 00:10C6
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

; ---- code $10DB-$10E9 (14 bytes) [CONFIRMED] continuation

Function_00_10DB:: ; 00:10DB
	ldh a, [hTextX]
	add a, $06
	ldh [hTextX], a
	ld e, a
	ldh a, [hTextX + 1]
	adc a, $00
	ldh [hTextX + 1], a
	ret
