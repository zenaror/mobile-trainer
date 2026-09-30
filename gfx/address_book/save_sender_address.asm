; gfx/address_book/save_sender_address.asm
; bank 2A, $4AA0-$5495 (2549 bytes); pinned by layout.link
; tiles, tilemap, palette, animation blocks of that screen

SECTION "gfx/address_book/save_sender_address", ROMX

; ---- gfx $4AA0-$4CD0 (560 bytes) [CONFIRMED] 35 tiles (560 bytes) 2bpp: 'ld de,$9301 ; ld hl,$4AA0 ; ld a,$2A ; ld c,$23 ; call FarCall -> 00:0749 (HDMA rom->vram)' at 2A:413A-4149 (c = tile count $23 = 35; ends exactly where the tilemap+attr at 4CD0 begins; blank/$FF stretches inside are tile content). Merges the former zero/$FF/UNCLASSIFIED fragments [every byte read as data in 6 scenario(s)]

Gfx_SaveSenderAddr_Tiles9300:: ; 2A:4AA0
Tiles_2A_4AA0::
	db $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51
	db $00, $00, $00, $00, $00, $00, $0F, $1F, $10, $1F, $10, $38, $20, $3F, $20, $7F
	db $00, $00, $00, $00, $00, $00, $F8, $FC, $04, $FC, $0E, $0E, $02, $FE, $07, $FF
	db $40, $7F, $7F, $7F, $20, $20, $7F, $7F, $00, $00, $00, $00, $00, $00, $0F, $1F
	db $01, $FF, $FF, $FF, $07, $01, $FF, $FF, $00, $00, $00, $00, $00, $00, $F8, $FC
	db $10, $1F, $10, $38, $20, $3F, $20, $7F, $40, $7F, $7F, $7F, $20, $20, $7F, $7F
	db $04, $FC, $0E, $0E, $02, $FE, $07, $FF, $01, $FF, $FF, $FF, $07, $01, $FF, $FF
	db $FF, $FF, $E7, $FF, $E7, $FF, $FF, $FF, $FF, $FF, $E7, $FF, $E7, $FF, $FF, $FF
	db $17, $1A, $7F, $7F, $80, $80, $3F, $00, $FF, $7F, $F3, $9E, $F3, $1E, $F3, $1E
	db $00, $00, $80, $C0, $78, $70, $28, $38, $F0, $28, $E8, $F0, $F0, $00, $E0, $00
	db $3F, $C0, $3F, $C0, $3F, $C0, $BF, $C0, $7F, $40, $3F, $21, $1F, $12, $17, $1A
	db $FF, $0F, $F8, $10, $F0, $20, $E0, $40, $C0, $80, $80, $00, $00, $00, $00, $00
	db $00, $FF, $00, $FF, $00, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $FF, $FF, $00
	db $17, $1A, $17, $1A, $17, $1A, $17, $1A, $17, $1A, $17, $1A, $17, $1A, $17, $1A
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $3E, $51, $1E, $69
	db $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0
	db $FF, $FF, $FF, $FF, $00, $FF, $00, $FF, $FF, $00, $FF, $00, $FF, $00, $FF, $00
	db $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $3F, $C0, $80, $E0, $D0, $FF, $F0, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FF, $00, $00, $00, $00, $00, $FF, $00, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $FF, $FF, $FF, $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $FF, $FF, $FF
	db $FF, $01, $FF, $01, $FF, $01, $FF, $01, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $FB, $01, $FB, $01, $FB, $01, $FB, $01, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9
	db $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9
	db $FB, $F9, $FB, $F9, $FB, $01, $FB, $01, $FB, $01, $FB, $01, $FB, $F9, $FB, $F9
	db $00, $00, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9, $FB, $F9
	db $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0, $3F, $C0
	db $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $4CD0-$4FA0 (720 bytes) [PROBABLE] tilemap+attr: 1 call site(s); first: copy_tilemap_rect_pair at 2A:417B: hl=$4CD0 a=$2A b=18 rows c=20 cols (tiles then attrs) de=$D000 [verifier: call site never executed in a trace -> PROBABLE]

Data_SaveSenderAddr_TilemapAttr:: ; 2A:4CD0
Data_2A_4CD0::
	db $3C, $3C, $3C, $30, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
	db $30, $3C, $3C, $3C, $41, $42, $42, $40, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
	db $20, $21, $22, $23, $40, $42, $42, $42, $3A, $3B, $43, $44, $45, $46, $46, $46
	db $46, $46, $46, $46, $46, $46, $46, $46, $44, $43, $43, $4D, $3D, $47, $48, $48
	db $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $48, $4C
	db $38, $39, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47
	db $47, $47, $47, $4B, $3D, $47, $47, $31, $32, $37, $2D, $2E, $2F, $30, $31, $32
	db $33, $34, $35, $36, $37, $38, $47, $4B, $38, $39, $47, $33, $34, $37, $41, $42
	db $43, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $47, $4B, $3D, $47, $47, $35
	db $36, $37, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60, $47, $4B
	db $38, $39, $47, $31, $32, $37, $69, $6A, $6B, $6C, $6D, $6E, $6F, $70, $71, $72
	db $73, $74, $47, $4B, $3D, $47, $47, $33, $34, $37, $7D, $7E, $7F, $80, $81, $82
	db $83, $84, $85, $86, $87, $88, $47, $4B, $38, $39, $47, $35, $36, $37, $91, $92
	db $93, $94, $95, $96, $97, $98, $99, $9A, $9B, $9C, $47, $4B, $3D, $47, $47, $31
	db $32, $37, $A5, $A6, $A7, $A8, $A9, $AA, $AB, $AC, $AD, $AE, $AF, $B0, $47, $4B
	db $38, $39, $47, $33, $34, $37, $B9, $BA, $BB, $BC, $BD, $BE, $BF, $C0, $C1, $C2
	db $C3, $C4, $47, $4B, $3D, $47, $47, $35, $36, $37, $CD, $CE, $CF, $D0, $D1, $D2
	db $D3, $D4, $D5, $D6, $D7, $D8, $47, $4B, $38, $39, $47, $47, $47, $47, $47, $47
	db $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $47, $4B, $3D, $47, $49, $49
	db $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $49, $4A
	db $28, $29, $2A, $2B, $50, $51, $52, $53, $78, $79, $7A, $7B, $A0, $A1, $A2, $A3
	db $C8, $C9, $CA, $CB, $3C, $3D, $3E, $3F, $64, $65, $66, $67, $8C, $8D, $8E, $8F
	db $B4, $B5, $B6, $B7, $DC, $DD, $DE, $DF, $09, $09, $09, $09, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $29, $29, $29, $29, $0A, $0A, $0A, $09
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $29, $0A, $0A, $0A
	db $0A, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $29, $0A, $0A, $09, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $0A, $0A, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $09, $0A, $0A, $08, $0B
	db $0B, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $09
	db $0A, $0A, $08, $0B, $0B, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $0A, $09, $0A, $0A, $08, $0B, $0B, $09, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $0A, $09, $0A, $0A, $08, $0B, $0B, $09, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $09, $0A, $0A, $08, $0B
	db $0B, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $09
	db $0A, $0A, $08, $0B, $0B, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $0A, $09, $0A, $0A, $08, $0B, $0B, $09, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $0A, $09, $0A, $0A, $08, $0B, $0B, $09, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $09, $0A, $0A, $08, $0B
	db $0B, $09, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $0A, $09
	db $0A, $0A, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08, $08
	db $08, $08, $08, $09, $0A, $0A, $09, $09, $09, $09, $09, $09, $09, $09, $09, $09
	db $09, $09, $09, $09, $09, $09, $09, $09, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01
	db $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01

; ---- data $4FA0-$4FE0 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear), 8 palette groups: loaded by 'ld bc,$0040 ; ld de,$D800 ; ld hl,$4FA0 ; ld a,$2A ; far call 4F:4000' at 2A:4129-4139

Palette_SaveSenderAddr_Bg:: ; 2A:4FA0
Palette_2A_4FA0::
	db $FF, $7F, $6C, $7F, $FF, $7F, $00, $00, $00, $00, $5F, $02, $D5, $00, $FF, $7F
	db $FF, $7F, $EA, $23, $05, $05, $00, $00, $FF, $7F, $6E, $7E, $AC, $7B, $00, $00
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- gfx $4FE0-$51E0 (512 bytes) [PROBABLE] 32 tiles (512 bytes) 2bpp: rendered as coherent sprite/tile art; no HDMA call site found (the block sits between the palette 4FA0-4FE0 that is loaded via 4F:4000 and the palette 51E0-5220); bounds fixed by the neighbouring palettes

Tiles_2A_4FE0:: ; 2A:4FE0
	db $F8, $F8, $88, $F8, $B0, $F0, $A0, $E0, $C0, $C0, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $1F, $0F, $1F, $10, $38, $10, $3F, $20, $7F, $20
	db $00, $00, $00, $00, $00, $00, $FC, $F8, $FC, $04, $0E, $0E, $FE, $02, $FF, $07
	db $7F, $40, $7F, $7F, $60, $20, $7F, $7F, $00, $00, $00, $00, $00, $00, $00, $00
	db $FF, $01, $FF, $FF, $07, $01, $FF, $FF, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $03, $03, $03, $02, $06, $02, $07, $02, $07, $04, $0F, $04
	db $00, $00, $00, $00, $E0, $E0, $E0, $20, $B0, $20, $70, $20, $F0, $10, $F8, $10
	db $0F, $08, $0F, $0F, $0C, $04, $0F, $0F, $00, $00, $00, $00, $00, $00, $00, $00
	db $F8, $08, $F8, $F8, $18, $08, $F8, $F8, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $01, $01, $03, $02, $07, $04, $07, $04, $0B, $0A, $09, $09
	db $00, $00, $C0, $C0, $C0, $40, $E0, $20, $E0, $20, $F0, $10, $F8, $08, $F8, $08
	db $11, $11, $30, $30, $7C, $48, $7F, $7E, $0F, $03, $03, $00, $00, $00, $00, $00
	db $FC, $04, $FC, $84, $7C, $44, $3C, $24, $9C, $1C, $E4, $C4, $FC, $38, $00, $00
	db $00, $00, $00, $00, $00, $00, $0F, $1F, $10, $1F, $10, $38, $20, $3F, $20, $7F
	db $00, $00, $00, $00, $00, $00, $F8, $FC, $04, $FC, $0E, $0E, $02, $FE, $07, $FF
	db $08, $0F, $0F, $0F, $04, $0C, $0F, $0F, $00, $00, $00, $00, $00, $00, $00, $00
	db $00, $00, $00, $00, $00, $01, $01, $1F, $1F, $3F, $27, $3B, $27, $39, $3D, $23
	db $00, $00, $7C, $FE, $C6, $BB, $03, $FD, $03, $FD, $83, $7D, $83, $7D, $FF, $81
	db $00, $00, $00, $00, $00, $00, $00, $70, $70, $F8, $98, $EC, $98, $EC, $78, $8C
	db $1C, $3F, $02, $1F, $01, $07, $00, $03, $0F, $0F, $1C, $0B, $1F, $17, $38, $17
	db $FE, $83, $7F, $80, $0F, $F3, $9E, $E3, $FF, $83, $FE, $45, $7D, $C7, $7C, $C7
	db $70, $F8, $80, $F8, $00, $C0, $00, $80, $E0, $E0, $70, $A0, $F0, $D0, $38, $D0
	db $3F, $2F, $70, $2F, $7F, $CF, $FF, $70, $FF, $0F, $FF, $70, $FF, $00, $00, $00
	db $39, $FF, $54, $FF, $FF, $D7, $FF, $38, $FF, $C7, $FF, $38, $FF, $00, $00, $00
	db $F8, $E8, $1C, $E8, $FC, $E4, $FE, $1C, $FE, $E0, $FE, $1C, $FE, $00, $00, $00
	db $00, $00, $00, $00, $00, $00, $00, $00, $0F, $00, $0F, $0F, $18, $0F, $18, $17
	db $00, $00, $00, $00, $00, $00, $00, $00, $FF, $00, $EF, $D7, $38, $FF, $54, $FF
	db $00, $00, $00, $00, $00, $00, $00, $00, $E0, $00, $E0, $E0, $70, $A0, $30, $D0
	db $38, $17, $30, $2F, $70, $2F, $7F, $CF, $FF, $70, $FF, $0F, $FF, $70, $FF, $00
	db $54, $FF, $38, $FF, $54, $FF, $FF, $D7, $FF, $38, $FF, $C7, $FF, $38, $FF, $00
	db $38, $D0, $18, $E8, $1C, $E8, $FC, $E6, $FE, $1C, $FE, $E0, $FE, $1C, $FE, $00
	db $08, $F8, $F8, $F8, $08, $18, $F8, $F8, $00, $00, $00, $00, $00, $00, $00, $00

; ---- data $51E0-$5220 (64 bytes) [PROBABLE] 64 bytes = 32 RGB555 words (bit15 clear) starting at the first valid palette word (4FED,09BF,7BAC,0000...), ends where the animation entry table 5220 begins; replaces the clipped 51F8 heuristic palette

Palette_2A_51E0:: ; 2A:51E0
	db $ED, $4F, $BF, $09, $AC, $7B, $00, $00, $ED, $4F, $10, $42, $D6, $5A, $07, $56
	db $ED, $4F, $BF, $02, $FF, $7F, $00, $00, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F
	db $00, $00, $4A, $29, $B5, $56, $FF, $7F, $00, $00, $4A, $29, $B5, $56, $FF, $7F

; ---- words $5220-$5290 (112 bytes) [PROBABLE] animation entry table: 28 entries of 4 bytes (frame-table pointer, script pointer), each animation repeated 4x; format of the sprite-slot initialiser 00:0A82/0AB8 (entry at DE+4*(A&$7F) -> slot[2..3] frame table, slot[6..7] script)

Table_2A_5220:: ; 2A:5220
	dw Table_2A_5290, Data_2A_52BE, Table_2A_5290, Data_2A_52BE, Table_2A_5290, Data_2A_52BE, Table_2A_5290, Data_2A_52BE
	dw Table_2A_52C1, Data_2A_52E7, Table_2A_52C1, Data_2A_52E7, Table_2A_52C1, Data_2A_52E7, Table_2A_52C1, Data_2A_52E7
	dw Table_2A_52EA, Data_2A_52FD, Table_2A_52EA, Data_2A_52FD, Table_2A_52EA, Data_2A_52FD, Table_2A_52EA, Data_2A_52FD
	dw Table_2A_5300, Data_2A_5397, Table_2A_5300, Data_2A_5397, Table_2A_5300, Data_2A_5397, Table_2A_5300, Data_2A_5397
	dw Table_2A_53A2, Data_2A_5451, Table_2A_53A2, Data_2A_5451, Table_2A_53A2, Data_2A_5451, Table_2A_53A2, Data_2A_5451
	dw Table_2A_545F, Data_2A_5475, Table_2A_545F, Data_2A_5475, Table_2A_545F, Data_2A_5475, Table_2A_545F, Data_2A_5475
	dw Table_2A_547A, Data_2A_5490, Table_2A_547A, Data_2A_5490, Table_2A_547A, Data_2A_5490, Table_2A_547A, Data_2A_5490

; ---- words $5290-$5294 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5294, $52A9 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_5290:: ; 2A:5290
	dw Data_2A_5294, Data_2A_52A9

; ---- data $5294-$52A9 (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_5294:: ; 2A:5294
	db $05, $FE, $01, $00, $00, $FE, $09, $01, $00, $FE, $11, $02, $00, $06, $06, $03
	db $00, $06, $0E, $04, $00

; ---- data $52A9-$52BE (21 bytes) [PROBABLE] OAM frame: count=5 then 5 x (y,x,tile,attr) = 21 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_52A9:: ; 2A:52A9
	db $05, $FE, $01, $00, $00, $FE, $09, $01, $00, $FE, $11, $02, $00, $06, $06, $03
	db $00, $06, $0E, $04, $00

; ---- data $52BE-$52C1 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_52BE:: ; 2A:52BE
	db $01, $00, $04

; ---- words $52C1-$52C5 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $52C5, $52D6 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_52C1:: ; 2A:52C1
	dw Data_2A_52C5, Data_2A_52D6

; ---- data $52C5-$52D6 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_52C5:: ; 2A:52C5
	db $04, $00, $08, $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00, $08, $10, $2F
	db $00

; ---- data $52D6-$52E7 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_52D6:: ; 2A:52D6
	db $04, $00, $08, $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00, $08, $10, $2F
	db $00

; ---- data $52E7-$52EA (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_52E7:: ; 2A:52E7
	db $01, $00, $04

; ---- words $52EA-$52EC (2 bytes) [PROBABLE] frame table: 1 pointer(s) $52EC to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_52EA:: ; 2A:52EA
	dw Data_2A_52EC

; ---- data $52EC-$52FD (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_52EC:: ; 2A:52EC
	db $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03, $00, $08, $10, $04
	db $00

; ---- data $52FD-$5300 (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_52FD:: ; 2A:52FD
	db $01, $00, $04

; ---- words $5300-$530A (10 bytes) [PROBABLE] frame table: 5 pointer(s) $530A, $531B, $533C, $535D, $537E to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_5300:: ; 2A:5300
	dw Data_2A_530A, Data_2A_531B, Data_2A_533C, Data_2A_535D, Data_2A_537E

; ---- data $530A-$531B (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_530A:: ; 2A:530A
	db $04, $00, $08, $0D, $00, $00, $10, $0E, $00, $08, $08, $2E, $00, $08, $10, $2F
	db $00

; ---- data $531B-$533C (33 bytes) [PROBABLE] OAM frame: count=8 then 8 x (y,x,tile,attr) = 33 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_531B:: ; 2A:531B
	db $08, $01, $08, $22, $00, $01, $10, $23, $00, $09, $10, $1F, $00, $09, $08, $0F
	db $00, $03, $08, $42, $02, $03, $10, $42, $02, $0B, $08, $43, $02, $0B, $10, $43
	db $02

; ---- data $533C-$535D (33 bytes) [PROBABLE] OAM frame: count=8 then 8 x (y,x,tile,attr) = 33 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_533C:: ; 2A:533C
	db $08, $F9, $09, $24, $02, $F9, $11, $25, $02, $01, $09, $26, $02, $01, $11, $27
	db $02, $03, $09, $42, $02, $03, $11, $42, $02, $04, $09, $42, $02, $04, $11, $42
	db $02

; ---- data $535D-$537E (33 bytes) [PROBABLE] OAM frame: count=8 then 8 x (y,x,tile,attr) = 33 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_535D:: ; 2A:535D
	db $08, $FB, $05, $28, $02, $FB, $0D, $29, $02, $FB, $15, $2A, $02, $03, $05, $2B
	db $02, $03, $0D, $2C, $02, $03, $15, $2D, $02, $04, $08, $42, $02, $04, $10, $42
	db $02

; ---- data $537E-$5397 (25 bytes) [PROBABLE] OAM frame: count=6 then 6 x (y,x,tile,attr) = 25 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_537E:: ; 2A:537E
	db $06, $FD, $05, $19, $02, $FD, $0D, $1A, $02, $FD, $15, $1B, $02, $05, $05, $1C
	db $02, $05, $0D, $1D, $02, $05, $15, $1E, $02

; ---- data $5397-$53A2 (11 bytes) [HYPOTHESIS] animation script: count=5 then 5 x 2 bytes (00 05 01 05 02 05 03 03 04 12), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_5397:: ; 2A:5397
	db $05, $00, $05, $01, $05, $02, $05, $03, $03, $04, $12

; ---- words $53A2-$53AC (10 bytes) [PROBABLE] frame table: 5 pointer(s) $53AC, $53BD, $53DE, $53FF, $542C to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_53A2:: ; 2A:53A2
	dw Data_2A_53AC, Data_2A_53BD, Data_2A_53DE, Data_2A_53FF, Data_2A_542C

; ---- data $53AC-$53BD (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_53AC:: ; 2A:53AC
	db $04, $00, $08, $01, $00, $00, $10, $02, $00, $08, $08, $03, $00, $08, $10, $04
	db $00

; ---- data $53BD-$53DE (33 bytes) [PROBABLE] OAM frame: count=8 then 8 x (y,x,tile,attr) = 33 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_53BD:: ; 2A:53BD
	db $08, $01, $08, $05, $00, $01, $10, $06, $00, $09, $08, $07, $00, $09, $10, $08
	db $00, $03, $08, $42, $02, $03, $10, $42, $02, $0B, $08, $43, $02, $0B, $10, $43
	db $02

; ---- data $53DE-$53FF (33 bytes) [PROBABLE] OAM frame: count=8 then 8 x (y,x,tile,attr) = 33 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_53DE:: ; 2A:53DE
	db $08, $01, $09, $26, $02, $01, $11, $27, $02, $F9, $09, $20, $02, $F9, $11, $21
	db $02, $03, $09, $42, $02, $03, $11, $42, $02, $04, $09, $42, $02, $04, $11, $42
	db $02

; ---- data $53FF-$542C (45 bytes) [PROBABLE] OAM frame: count=11 then 11 x (y,x,tile,attr) = 45 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_53FF:: ; 2A:53FF
	db $0B, $03, $05, $2B, $02, $03, $0D, $2C, $02, $03, $15, $2D, $02, $FB, $05, $30
	db $02, $FB, $0D, $31, $02, $FB, $15, $32, $02, $F3, $05, $33, $02, $F3, $0D, $34
	db $02, $F3, $15, $35, $02, $04, $08, $42, $02, $04, $10, $42, $02

; ---- data $542C-$5451 (37 bytes) [PROBABLE] OAM frame: count=9 then 9 x (y,x,tile,attr) = 37 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_542C:: ; 2A:542C
	db $09, $F6, $05, $10, $02, $F6, $0D, $11, $02, $F6, $15, $12, $02, $FE, $05, $13
	db $02, $FE, $0D, $14, $02, $FE, $15, $15, $02, $06, $05, $16, $02, $06, $0D, $17
	db $02, $06, $15, $18, $02

; ---- data $5451-$545C (11 bytes) [HYPOTHESIS] animation script: count=5 then 5 x 2 bytes (00 05 01 05 02 05 03 03 04 12), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_5451:: ; 2A:5451
	db $05, $00, $05, $01, $05, $02, $05, $03, $03, $04, $12

; ---- data $545C-$545F (3 bytes) [HYPOTHESIS] animation script: count=1 then 1 x 2 bytes (00 04), NOT referenced by any entry of the entry table 5220 (verifier: unreferenced orphan script, structurally identical to its siblings) (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_545C:: ; 2A:545C
	db $01, $00, $04

; ---- words $545F-$5463 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $5463, $546C to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_545F:: ; 2A:545F
	dw Data_2A_5463, Data_2A_546C

; ---- data $5463-$546C (9 bytes) [PROBABLE] OAM frame: count=2 then 2 x (y,x,tile,attr) = 9 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_5463:: ; 2A:5463
	db $02, $06, $00, $0D, $43, $06, $08, $0E, $43

; ---- data $546C-$5475 (9 bytes) [PROBABLE] OAM frame: count=2 then 2 x (y,x,tile,attr) = 9 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_546C:: ; 2A:546C
	db $02, $07, $00, $0D, $43, $07, $08, $0E, $43

; ---- data $5475-$547A (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 0f 01 14), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_5475:: ; 2A:5475
	db $02, $00, $0F, $01, $14

; ---- words $547A-$547E (4 bytes) [PROBABLE] frame table: 2 pointer(s) $547E, $5487 to OAM frames (extent = lowest target); referenced by an animation entry

Table_2A_547A:: ; 2A:547A
	dw Data_2A_547E, Data_2A_5487

; ---- data $547E-$5487 (9 bytes) [PROBABLE] OAM frame: count=2 then 2 x (y,x,tile,attr) = 9 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_547E:: ; 2A:547E
	db $02, $07, $00, $0D, $03, $07, $08, $0E, $03

; ---- data $5487-$5490 (9 bytes) [PROBABLE] OAM frame: count=2 then 2 x (y,x,tile,attr) = 9 bytes (tuples emitted by the 00:0AE8 sprite engine; layout as bank 50:6CC4); referenced by a frame table

Data_2A_5487:: ; 2A:5487
	db $02, $06, $00, $0D, $03, $06, $08, $0E, $03

; ---- data $5490-$5495 (5 bytes) [HYPOTHESIS] animation script: count=2 then 2 x 2 bytes (00 0f 01 14), referenced as the 2nd word of an animation entry (slot[6..7], read by 00:0AB8); byte meaning (frame index, duration) not verified

Data_2A_5490:: ; 2A:5490
	db $02, $00, $0F, $01, $14
