; data/text/pokemon_names_bank53.asm
; bank 53, $4000-$4171 (369 bytes); pinned by layout.link
; 25 katakana names (pointer table + strings); no reader found

SECTION "data/text/pokemon_names_bank53", ROMX

PUSHC sjis

; ---- ptrtable $4000-$4032 (50 bytes) [PROBABLE] little-endian word table, 25 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4032..$4164; regular record stride between targets; verifier: truncated from 28 to 25 entries: entry 0 = 4032 is where the table ends

Table_53_4000:: ; 53:4000
	dw String_53_4032
	dw $403F
	dw $404C
	dw $4059
	dw $4066
	dw $4071
	dw $407C
	dw $4089
	dw $4096
	dw $40A3
	dw $40B0
	dw $40BD
	dw $40C8
	dw $40D5
	dw $40E2
	dw $40EF
	dw $40FC
	dw $4109
	dw $4116
	dw $4123
	dw $4130
	dw $413D
	dw $414A
	dw $4157
	dw $4164

; ---- text $4032-$4171 (319 bytes) [PROBABLE] text: 25 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_53_4032:: ; 53:4032
	db "　　ポリゴン", 0
	db "　ピカチュウ", 0
	db "　　トゲピー", 0
	db "　　ニャース", 0
	db "　　ルギア", 0
	db "　　プリン", 0
	db "　　ワニノコ", 0
	db "　　エンテイ", 0
	db "　　ハッサム", 0
	db "　　コダック", 0
	db "　ブラッキー", 0
	db "　　マリル", 0
	db "　バンギラス", 0
	db "　ハクリュー", 0
	db "　ウソッキー", 0
	db "　　ピチュー", 0
	db "　　レディバ", 0
	db "　キレイハナ", 0
	db "　ミュウツー", 0
	db "　　ホウオウ", 0
	db "　ソーナンス", 0
	db "　　ディグダ", 0
	db "　フシギバナ", 0
	db "　　エーフィ", 0
	db "　ポリゴン２", 0

POPC
