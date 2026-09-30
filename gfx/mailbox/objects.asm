; gfx/mailbox/objects.asm
; bank 26, $7AB0-$7D41 (657 bytes); pinned by layout.link
; palettes and object tables (cursor, arrows, digits, envelopes) of the mailbox

SECTION "gfx/mailbox/objects", ROMX

; ---- data $7AB0-$7ABC (12 bytes) [CONFIRMED] read as data by executed code (in up to 2/18 scenarios); content class unknown [clipped from 7420-7B00 by higher-priority evidence]

Data_26_7AB0:: ; 26:7AB0
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- zero $7ABC-$7AC0 (4 bytes) [PROBABLE] 4 zero bytes (two blank palette words) before the palette block
	ds $4, $00

; ---- data $7AC0-$7B00 (64 bytes) [PROBABLE] 8 palettes x 4 RGB555 words (all 32 words have bit15 clear; contains 7FFF); the mapper heuristic that extended this palette to 7BE4 swallowed pointer words (0x7Cxx have bit15 clear too)

Palette_26_7AC0:: ; 26:7AC0
	INCLUDE "gfx/mailbox/objects/palette_7ac0.pal"

; ---- words $7B00-$7BE0 (224 bytes) [PROBABLE] 14 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 7B00-7D41 (26:7B00-7D41 (ends at the zero padding)); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs

Mailbox_ObjTable:: ; 26:7B00
Table_26_7B00::
	dw Data_26_7BE0, $7C06, Data_26_7BE0, $7C06, Data_26_7BE0, $7C06, Data_26_7BE0, $7C06
	dw $7C0B, $7C1A, $7C0B, $7C1A, $7C0B, $7C1A, $7C0B, $7C1A
	dw $7C1D, $7C2C, $7C1D, $7C2C, $7C1D, $7C2C, $7C1D, $7C2C
	dw $7C2F, $7C3E, $7C2F, $7C3E, $7C2F, $7C3E, $7C2F, $7C3E
	dw $7C41, $7C67, $7C41, $7C67, $7C41, $7C67, $7C41, $7C67
	dw $7C6C, $7C92, $7C6C, $7C92, $7C6C, $7C92, $7C6C, $7C92
	dw $7C97, $7C9E, $7C97, $7C9E, $7C97, $7C9E, $7C97, $7C9E
	dw $7CA1, $7CA8, $7CA1, $7CA8, $7CA1, $7CA8, $7CA1, $7CA8
	dw $7CAB, $7CB2, $7CAB, $7CB2, $7CAB, $7CB2, $7CAB, $7CB2
	dw $7CB5, $7CBC, $7CB5, $7CBC, $7CB5, $7CBC, $7CB5, $7CBC
	dw $7CBF, $7CD2, $7CBF, $7CD2, $7CBF, $7CD2, $7CBF, $7CD2
	dw $7CD5, $7CE8, $7CD5, $7CE8, $7CD5, $7CE8, $7CD5, $7CE8
	dw $7CEB, $7D11, $7CEB, $7D11, $7CEB, $7D11, $7CEB, $7D11
	dw $7D16, $7D3C, $7D16, $7D3C, $7D16, $7D3C, $7D16, $7D3C

; ---- data $7BE0-$7D41 (353 bytes) [PROBABLE] 14 object record(s): 14 frame tables, 19 frames, 14 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 26:7B00-7D41 (ends at the zero padding)

Data_26_7BE0:: ; 26:7BE0
	db $E4, $7B, $F5, $7B, $04, $FE, $FE, $00, $00, $FE, $0A, $00, $20, $0A, $FE, $00
	db $40, $0A, $0A, $00, $60, $04, $FD, $FD, $00, $00, $FD, $0B, $00, $20, $0B, $FD
	db $00, $40, $0B, $0B, $00, $60, $02, $00, $2E, $01, $08, $0D, $7C, $03, $F5, $FC
	db $18, $00, $F5, $04, $19, $00, $F5, $0C, $0D, $00, $01, $00, $40, $1F, $7C, $03
	db $F5, $FC, $1A, $00, $F5, $04, $1B, $00, $F5, $0C, $1C, $00, $01, $00, $40, $31
	db $7C, $03, $F5, $FC, $1D, $00, $F5, $04, $1E, $00, $F5, $0C, $1F, $00, $01, $00
	db $40, $45, $7C, $56, $7C, $04, $00, $00, $22, $00, $00, $08, $23, $00, $00, $00
	db $20, $03, $00, $08, $21, $03, $04, $FF, $00, $22, $00, $FF, $08, $23, $00, $FF
	db $00, $20, $03, $FF, $08, $21, $03, $02, $00, $14, $01, $14, $70, $7C, $81, $7C
	db $04, $00, $00, $22, $40, $00, $08, $23, $40, $00, $00, $20, $43, $00, $08, $21
	db $43, $04, $01, $00, $22, $40, $01, $08, $23, $40, $01, $00, $20, $43, $01, $08
	db $21, $43, $02, $00, $14, $01, $14, $99, $7C, $01, $02, $10, $01, $01, $01, $00
	db $04, $A3, $7C, $01, $02, $10, $02, $01, $01, $00, $04, $AD, $7C, $01, $02, $10
	db $03, $01, $01, $00, $04, $B7, $7C, $01, $02, $10, $04, $01, $01, $00, $04, $C1
	db $7C, $04, $00, $00, $11, $02, $00, $08, $12, $02, $08, $00, $13, $02, $08, $07
	db $13, $22, $01, $00, $04, $D7, $7C, $04, $00, $00, $14, $02, $00, $08, $15, $02
	db $08, $00, $16, $02, $08, $08, $17, $02, $01, $00, $04, $EF, $7C, $00, $7D, $04
	db $00, $00, $11, $02, $00, $08, $12, $02, $08, $00, $13, $02, $08, $07, $13, $22
	db $04, $00, $00, $28, $02, $00, $08, $29, $02, $08, $00, $2A, $02, $08, $08, $2B
	db $02, $02, $00, $1D, $01, $13, $1A, $7D, $2B, $7D, $04, $00, $00, $14, $02, $00
	db $08, $15, $02, $08, $00, $16, $02, $08, $08, $17, $02, $04, $00, $00, $24, $02
	db $00, $08, $25, $02, $08, $00, $26, $02, $08, $08, $27, $02, $02, $00, $1D, $01
	db $13
