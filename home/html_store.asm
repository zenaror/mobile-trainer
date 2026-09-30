; home/html_store.asm
; bank 00, $131A-$1408 (238 bytes); pinned by layout.link
; lookups in the bank 3F index of the built-in HTML store

SECTION "home/html_store", ROM0

; ---- code $131A-$1354 (58 bytes) [CONFIRMED] two-level string lookup in bank 3F: pointer table at 3F:4000 indexed by B -> copy string to HL; then 3-byte entries (addr,bank) indexed by BC -> copy second string [reached via inferred links; raw refs 43] [executed in 5 scenarios]

Function_00_131A:: ; 00:131A
	call BankSwitch_H
	push hl
	ld hl, Data_3F_4000
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a
	ld e, b
	ld b, $00
	ld d, $00
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	pop hl

Label_00_1334:: ; 00:1334
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, Label_00_1334
	inc de
	dec hl
	push hl
	ld h, b
	ld l, c
	add hl, hl
	add hl, bc
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ldh [hROMBankLo], a
	ld [$2100], a
	pop hl

Label_00_134D:: ; 00:134D
	ld a, [de]
	ld [hli], a
	inc de
	or a, a
	jr nz, Label_00_134D
	ret

; ---- code $1354-$138C (56 bytes) [CONFIRMED] keyword search in bank 3F: walks the word-pointer list at 3F:4000 comparing each string with the text at HL; on a match stores the byte after it in C2DC, walks the entry list (addr16 + bank byte) and copies the matching payload with CopyBytes (limited by BC); writes the length words at [HL]; writes zeros when nothing matches [reached via inferred links; raw refs 23] | 40 insn(s) executed; cut out of the PROBABLE region 1354-1408 by apply_coverage --split [executed in 8 scenarios]

Function_00_1354:: ; 00:1354
	dec bc
	dec bc
	ld a, b
	cp a, $FF
	ret z
	push de
	ld a, [wBrowserRxBank]
	call BankSwitch_D
	xor a, a
	ld [de], a
	inc de
	ld [de], a
	inc de
	push bc
	push de
	ld bc, Data_3F_4000
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a

Label_00_1372:: ; 00:1372
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	or a, e
	jp z, Label_00_13FD
	push bc
	push hl

Label_00_137E:: ; 00:137E
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, Label_00_1388
	cp a, c
	jr z, Label_00_137E

Label_00_1388:: ; 00:1388
	ld a, c
	or a, a
	jr z, Label_00_1390

; ---- code $138C-$1390 (4 bytes) [PROBABLE] 3 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1354-1408 by apply_coverage --split
	pop hl
	pop bc
	jr Label_00_1372

; ---- code $1390-$13DD (77 bytes) [CONFIRMED] 57 insn(s) executed; cut out of the PROBABLE region 1354-1408 by apply_coverage --split [executed in 8 scenarios]

Label_00_1390:: ; 00:1390
	ld a, [de]
	ld [wRam_C2DC], a
	inc de
	dec hl
	pop bc
	pop bc
	ld b, d
	ld c, e

Label_00_139A:: ; 00:139A
	ld a, [bc]
	ld e, a
	inc bc
	ld a, [bc]
	ld d, a
	inc bc
	or a, e
	jp z, Label_00_13FD
	ld a, [bc]
	ldh [hROMBankLo], a
	ld [$2100], a
	inc bc
	push bc
	push hl

Label_00_13AD:: ; 00:13AD
	ld a, [de]
	inc de
	ld c, a
	ld a, [hli]
	or a, a
	jr z, Label_00_13B7
	cp a, c
	jr z, Label_00_13AD

Label_00_13B7:: ; 00:13B7
	ld a, c
	or a, a
	jr z, Label_00_13C6
	pop hl
	pop bc
	ld a, $3F
	ldh [hROMBankLo], a
	ld [$2100], a
	jr Label_00_139A

Label_00_13C6:: ; 00:13C6
	pop hl
	pop bc
	ld a, [de]
	ldh [hRam_FFB0], a
	inc de
	ld a, [de]
	ldh [hRam_FFB1], a
	inc de
	pop hl
	pop bc
	push de
	push hl
	ldh a, [hRam_FFB0]
	sub a, c
	ld e, a
	ldh a, [hRam_FFB1]
	sbc a, b
	jr c, Label_00_13E0

; ---- code $13DD-$13E0 (3 bytes) [PROBABLE] 2 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1354-1408 by apply_coverage --split
	or a, e
	jr nz, Label_00_13E6

; ---- code $13E0-$13FD (29 bytes) [CONFIRMED] 22 insn(s) executed; cut out of the PROBABLE region 1354-1408 by apply_coverage --split [executed in 8 scenarios]

Label_00_13E0:: ; 00:13E0
	ldh a, [hRam_FFB0]
	ld c, a
	ldh a, [hRam_FFB1]
	ld b, a

Label_00_13E6:: ; 00:13E6
	pop de
	pop hl
	push bc
	ld a, b
	or a, c
	jr z, Label_00_13F0
	call CopyBytes

Label_00_13F0:: ; 00:13F0
	pop bc
	dec bc
	dec bc
	pop hl
	ld a, c
	ld [hli], a
	ldh [hRam_FFB1], a
	ld a, b
	ld [hli], a
	ldh [hRam_FFB0], a
	ret

; ---- code $13FD-$1408 (11 bytes) [PROBABLE] 9 insn(s) never executed in the traced runs; cut out of the PROBABLE region 1354-1408 by apply_coverage --split

Label_00_13FD:: ; 00:13FD
	pop de
	pop bc
	pop hl
	xor a, a
	ld [hli], a
	ld [hli], a
	ldh [hRam_FFB0], a
	ldh [hRam_FFB1], a
	ret
