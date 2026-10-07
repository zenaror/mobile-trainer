; engine/browser/history_cache.asm
; bank 4C, $4B54-$4DB2 (606 bytes); pinned by layout.link
; back-stack, page cache, long SRAM block copy

SECTION "engine/browser/history_cache", ROMX

Browser_HistoryReset:: ; 4C:4B54
Function_4C_4B54::
	; [CONFIRMED] 36 insn(s); 36 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, sBrowserHistory
	ld bc, $0600
	xor a, a
	ld [sBrowserHistoryCount], a
	ld [sBrowserHistoryWriteSlot], a
	call FillBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Sound_FrameService
	ret

Browser_HistoryPush:: ; 4C:4B7C
	ld hl, wBrowserPageUrl
	ld a, $06

Browser_HistoryPushFrom:: ; 4C:4B81
Function_4C_4B81::
	call BankSwitch_H
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sBrowserHistoryWriteSlot]
	add a, $AA
	ld d, a
	ld e, $00
	ld bc, $0100
	call CopyBytes
	ld a, [sBrowserHistoryWriteSlot]
	inc a
	cp a, $06
	jr c, .l4BA9

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4BA6 (executed)
	xor a, a

.l4BA9 ; 4C:4BA9
	; [CONFIRMED] 30 insn(s); 30 executed (in up to 1/18 scenarios)
	ld [sBrowserHistoryWriteSlot], a
	ld a, [sBrowserHistoryCount]
	cp a, $06
	jr nc, .l4BB7
	inc a
	ld [sBrowserHistoryCount], a
.l4BB7 ; 4C:4BB7
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Sound_FrameService
	ret

Browser_HistoryPop:: ; 4C:4BC1
	push de
	call BankSwitch_D
	xor a, a
	ld [de], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sBrowserHistoryCount]
	or a, a
	jr z, .l4BF7
	dec a
	ld [sBrowserHistoryCount], a
	ld a, [sBrowserHistoryWriteSlot]
	dec a
	cp a, $06
	jr c, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4BE5 (executed)
	ld a, $05

.skip ; 4C:4BE9
	; [CONFIRMED] 55 insn(s); 55 executed (in up to 1/18 scenarios)
	ld [sBrowserHistoryWriteSlot], a
	add a, $AA
	ld h, a
	ld l, $00
	ld bc, $0100
	call CopyBytes
.l4BF7 ; 4C:4BF7
	pop de
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Sound_FrameService
	ld a, [de]
	ret

Sram_CopyLongBlock:: ; 4C:4C03
	call Sound_FrameService
	push bc
	ld a, b
	cp a, $02
	jr c, .skip
	ld bc, $0200
.skip ; 4C:4C0F
	ldh a, [hPageCache_SourceBank]
	call BankSwitch_H
	push bc
	push de
	ld de, wAttrUrlBuf
	call CopyBytes
	pop de
	pop bc
	ldh a, [hPageCache_DestBank]
	call BankSwitch_D
	push hl
	ld hl, wAttrUrlBuf
	call CopyBytes
	pop hl
	ld a, h
	sub a, $C0
	jr c, .l4C38
	add a, $A0
	ld h, a
	ldh a, [hPageCache_SourceBank]
	inc a
	ldh [hPageCache_SourceBank], a
.l4C38 ; 4C:4C38
	ld a, d
	sub a, $C0
	jr c, .l4C45
	add a, $A0
	ld d, a
	ldh a, [hPageCache_DestBank]
	inc a
	ldh [hPageCache_DestBank], a
.l4C45 ; 4C:4C45
	pop bc
	ld a, b
	sub a, $02
	ld b, a
	ret z
	jr nc, Sram_CopyLongBlock

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4C4B (executed)
	ret

Browser_ClearCaches:: ; 4C:4C4E
Function_4C_4C4E::
	; [CONFIRMED] 63 insn(s); 63 executed (in up to 4/18 scenarios); entry proven: target of an
	; executed call/far call
	call Sound_FrameService
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	xor a, a
	ld [sPageCacheCount], a
	ld [sPageCacheWriteSlot], a
	ld a, $02
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, _SRAM
	ld bc, $2000
	xor a, a
	call FillBytes
	call Sound_FrameService
	ld a, $03
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld hl, _SRAM
	ld bc, $2000
	xor a, a
	call FillBytes
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	call Sound_FrameService
	ret

PageCache_Push:: ; 4C:4C95
	ld bc, $1000
	ld hl, sBrowserPageBuf
	ld a, $03
	ldh [hPageCache_SourceBank], a
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sPageCacheWriteSlot]
	ld e, a
	ld d, $00
	push hl
	ld hl, Table_PageCache_Slots
	add hl, de
	add hl, de
	add hl, de
	ld a, [hli]
	ld e, a
	ld a, [hli]
	ld d, a
	ld a, [hli]
	ldh [hPageCache_DestBank], a
	pop hl
	call Sram_CopyLongBlock
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sPageCacheWriteSlot]
	inc a
	cp a, $03
	jr c, .l4CD5

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4CD2 (executed)
	xor a, a

.l4CD5 ; 4C:4CD5
	; [CONFIRMED] 10 insn(s); 10 executed (in up to 1/18 scenarios)
	ld [sPageCacheWriteSlot], a
	ld a, [sPageCacheCount]
	cp a, $03
	jr nc, .l4CE3
	inc a
	ld [sPageCacheCount], a
.l4CE3 ; 4C:4CE3
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret

; ---- data $4CEA-$4CF6 (12 bytes) [PROBABLE] bounded page-cache record storage
; Push and Pop read address lo/hi, then SRAM bank, after adding slot*3 to this base.
; The reset-maintained ring uses slots 0..2; the fourth physical triple is outside that ring.
; Natural reads: +0..2 in 14/69 scenarios, +3..5 in 2/69; +6..11 remain unread.

Table_PageCache_Slots:: ; 4C:4CEA
Table_4C_4CEA::
	dw $A000 ; first demonstrated destination/source address
	db $02 ; SRAM bank for the first record
	dw $B000 ; second demonstrated destination/source address
	db $02 ; SRAM bank for the second record
	db $00, $A0, $03 ; slot 2 is statically selectable; these three bytes remain unread
	db $00, $B0, $03 ; fourth physical triple, outside the normal ring; unread

PageCache_Pop:: ; 4C:4CF6
Function_4C_4CF6::
	; [CONFIRMED] 18 insn(s); 18 executed (in up to 1/18 scenarios); entry proven: target of an
	; executed call/far call
	ldh [hPageCache_DestBank], a
	call Sound_FrameService
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	push bc
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sPageCacheCount]
	or a, a
	jr z, .l4D66
	dec a
	ld [sPageCacheCount], a
	ld a, [sPageCacheWriteSlot]
	dec a
	cp a, $03
	jr c, .skip

	; [PROBABLE] 1 insn(s) reached by static flow only; seeds: exec x1; min discovery hops 0;
	; fall-through of the jrcc at 4C:4D1A (executed)
	ld a, $02

.skip ; 4C:4D1E
	; [CONFIRMED] 40 insn(s); 40 executed (in up to 1/18 scenarios)
	ld [sPageCacheWriteSlot], a
	ldh [hRam_FFB0], a
	ldh a, [hPageCache_DestBank]
	ld h, d
	ld l, e
	call BankSwitch_H
	xor a, a
	call FillBytes
	call Sound_FrameService
	push de
	ld a, $06
	ldh [hWRAMBank], a
	ldh [rSVBK], a
	ld hl, wAttrUrlBuf
	ld de, wBrowserPageUrl
	ld bc, $0100
	call CopyBytes
	pop de
	ldh a, [hRam_FFB0]
	ld c, a
	ld b, $00
	ld hl, Table_PageCache_Slots
	add hl, bc
	add hl, bc
	add hl, bc
	ld a, [hli]
	ld c, a
	ld a, [hli]
	ld b, a
	ld a, [hli]
	ldh [hRam_FFB0], a
	ld h, b
	ld l, c
	pop bc
	call Sram_CopyLongBlock
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $FF
	ret

.l4D66 ; 4C:4D66
	; [PROBABLE] 38 insn(s) reached by static flow only; seeds: exec x38; min discovery hops 1;
	; entered by jrcc from 4C:4D0E (executed)
	pop bc
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	xor a, a
	ret

Browser_HistoryUndoPush:: ; 4C:4D6F
Function_4C_4D6F::
	ld a, $0A
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ld a, $01
	ldh [hSRAMBank], a
	ld [rRAMB], a
	ld a, [sPageCacheCount]
	or a, a
	jr z, .l4D94
	dec a
	ld [sPageCacheCount], a
	ld a, [sPageCacheWriteSlot]
	dec a
	cp a, $03
	jr c, .l4D91
	ld a, $02
.l4D91 ; 4C:4D91
	ld [sPageCacheWriteSlot], a
.l4D94 ; 4C:4D94
	ld a, [sBrowserHistoryCount]
	or a, a
	jr z, .l4DAB
	dec a
	ld [sBrowserHistoryCount], a
	ld a, [sBrowserHistoryWriteSlot]
	dec a
	cp a, $06
	jr c, .l4DA8
	ld a, $05
.l4DA8 ; 4C:4DA8
	ld [sBrowserHistoryWriteSlot], a
.l4DAB ; 4C:4DAB
	xor a, a
	ldh [hSRAMEnable], a
	ld [rRAMG], a
	ret
