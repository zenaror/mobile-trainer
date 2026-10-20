; data/html/index.asm
; bank 3F, $4000-$410C (268 bytes); pinned by layout.link
; built-in HTML page pointers and URL prefix; Mobile Dictionary category-to-page lists

SECTION "data/html/index", ROMX

PUSHC sjis

; ---- data $4000-$4006 (6 bytes) [CONFIRMED] two word pointers to the built-in URL keyword at
; 3F:4006, followed by a zero-word terminator. HtmlStore_BuildPageUrl indexes the list by B * 2;
; HtmlStore_LoadPage walks and compares the pointed-to strings. Both consumers ran naturally.

Table_HtmlStore_KeywordPointers:: ; 3F:4000
	db $06, $40, $06, $40, $00, $00

; ---- text $4006-$4011 (11 bytes) [CONFIRMED] NUL-terminated URL prefix pointed to twice by
; Table_HtmlStore_KeywordPointers. HtmlStore_BuildPageUrl at 00:1334 copies it; HtmlStore_LoadPage
; at 00:137E compares it, both with ROM bank $3F selected. Static bytes and consumers verified.

String_HtmlStore_UrlPrefix:: ; 3F:4006
	db "file://di/", 0

; ---- data $4011-$4012 (1 bytes) [CONFIRMED] HtmlStore_LoadPage at 00:1390 reads this byte
; after the matched prefix and stores it in wRam_C2DC, then advances to the page-pointer list.
; The value is $02; no reader of wRam_C2DC is identified. Field meaning remains unknown.

Data_3F_4011:: ; 3F:4011
	db $02

; ---- data $4012-$40B7 (165 bytes) [CONFIRMED] 55 page-record far pointers (addr16, bank).
; HtmlStore_BuildPageUrl at 00:1334 advances past the prefix NUL and one byte, then indexes by
; 3 * C; HtmlStore_LoadPage at 00:139A walks the same triples, selecting each record bank.
; All 55 targets are unique filename/NUL/length/HTML records in banks $3D/$3E. Static proof.

Table_HtmlStore_PageFarPointers:: ; 3F:4012
	db $A4, $48, $3E, $CC, $40, $3E, $3B, $44, $3E, $F2, $42, $3E, $C6, $49, $3E, $D3
	db $45, $3E, $00, $40, $3E, $E8, $6D, $3E, $A7, $46, $3E, $42, $4B, $3E, $A3, $47
	db $3E, $26, $50, $3E, $4D, $4C, $3E, $27, $4D, $3E, $EC, $53, $3E, $4F, $4E, $3E
	db $BE, $51, $3E, $5F, $57, $3E, $C9, $52, $3E, $FB, $59, $3E, $9F, $5B, $3E, $6B
	db $5D, $3E, $7E, $5E, $3E, $49, $55, $3E, $02, $56, $3E, $5D, $5F, $3E, $85, $63
	db $3E, $3D, $59, $3E, $C1, $60, $3E, $38, $62, $3E, $1A, $65, $3E, $4D, $71, $3E
	db $E7, $65, $3E, $E9, $66, $3E, $5A, $68, $3E, $76, $69, $3E, $02, $6B, $3E, $4F
	db $6C, $3E, $15, $6F, $3E, $52, $70, $3E, $4B, $72, $3E, $95, $74, $3E, $1F, $43
	db $3D, $F8, $43, $3D, $A3, $47, $3D, $00, $40, $3D, $41, $41, $3D, $67, $45, $3D
	db $7F, $46, $3D, $D1, $48, $3D, $E8, $49, $3D, $BE, $4A, $3D, $38, $4C, $3D, $25
	db $4E, $3D, $9F, $4F, $3D

; ---- zero $40B7-$40B9 (2 bytes) [CONFIRMED] zero-word terminator of the preceding page list:
; HtmlStore_LoadPage at 00:139A tests the address word before reading the bank byte. Static proof;
; no execution of this no-match terminator path is claimed.
	ds $2, $00

; ---- data $40B9-$40CF (22 bytes) [CONFIRMED] 11 little-endian pointers to category page-index
; lists in this bank. MobileDict_OnA at 1A:4192 indexes by 2 * (wMobileDict_Category - 1),
; reads both bytes with ReadByteFar (bank $3F), then indexes the chosen list by scroll + row - 1.

Table_MobileDict_CategoryPageLists:: ; 3F:40B9
	db $CF, $40, $D8, $40, $DA, $40, $E2, $40, $E5, $40, $E9, $40, $F0, $40, $FE, $40
	db $FF, $40, $01, $41, $02, $41

; ---- data $40CF-$410C (61 bytes) [CONFIRMED] concatenated category page indices. The 11 list
; lengths are 9,2,8,3,4,7,14,1,2,1,10, matching the counts at Table_MobileDict_Categories in bank
; $1A. MobileDict_OnA reads one byte (bank $3F) into C and calls MobileDictView_Show with B=0;
; the viewer passes B/C to HtmlStore_BuildPageUrl. Every index is in $00..$36. Static proof.

Data_MobileDict_CategoryPageIndices:: ; 3F:40CF
	db $01, $05, $02, $03, $0E, $36, $35, $24, $25, $0F, $00, $2E, $35, $17, $29, $2B
	db $2A, $0A, $30, $2F, $0C, $2C, $22, $23, $20, $21, $26, $0F, $08, $28, $07, $10
	db $12, $1C, $1B, $0D, $02, $19, $1C, $1A, $1E, $16, $2D, $14, $04, $15, $13, $32
	db $18, $11, $36, $31, $09, $0B, $28, $1F, $27, $36, $36, $06, $1D

POPC
