; data/text/pokemon_names_bank53.asm
; bank 53, $4000-$4171 (369 bytes); pinned by layout.link
; 25 katakana names (pointer table + strings); no reader confirmed in the bounded reviews; visual/index mapping is PROBABLE for 01-23 and Porygon2 art at 51:5EE0 is PROBABLE; executable ordinal-to-frame link remains HYPOTHESIS

SECTION "data/text/pokemon_names_bank53", ROMX

PUSHC sjis

; ---- ptrtable $4000-$4032 (50 bytes) [PROBABLE] little-endian word table, 25 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4032..$4164; regular record stride between targets; verifier: truncated from 28 to 25 entries: entry 0 = 4032 is where the table ends

Table_PokemonNamePointers:: ; 53:4000
	dw PokemonName00
	dw PokemonName01
	dw PokemonName02
	dw PokemonName03
	dw PokemonName04
	dw PokemonName05
	dw PokemonName06
	dw PokemonName07
	dw PokemonName08
	dw PokemonName09
	dw PokemonName10
	dw PokemonName11
	dw PokemonName12
	dw PokemonName13
	dw PokemonName14
	dw PokemonName15
	dw PokemonName16
	dw PokemonName17
	dw PokemonName18
	dw PokemonName19
	dw PokemonName20
	dw PokemonName21
	dw PokemonName22
	dw PokemonName23
	dw PokemonName24

; ---- text $4032-$4171 (319 bytes) [PROBABLE] text: 25 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PokemonName00:: ; 53:4032
	db "　　ポリゴン", 0
PokemonName01:: ; 53:403F
	db "　ピカチュウ", 0
PokemonName02:: ; 53:404C
	db "　　トゲピー", 0
PokemonName03:: ; 53:4059
	db "　　ニャース", 0
PokemonName04:: ; 53:4066
	db "　　ルギア", 0
PokemonName05:: ; 53:4071
	db "　　プリン", 0
PokemonName06:: ; 53:407C
	db "　　ワニノコ", 0
PokemonName07:: ; 53:4089
	db "　　エンテイ", 0
PokemonName08:: ; 53:4096
	db "　　ハッサム", 0
PokemonName09:: ; 53:40A3
	db "　　コダック", 0
PokemonName10:: ; 53:40B0
	db "　ブラッキー", 0
PokemonName11:: ; 53:40BD
	db "　　マリル", 0
PokemonName12:: ; 53:40C8
	db "　バンギラス", 0
PokemonName13:: ; 53:40D5
	db "　ハクリュー", 0
PokemonName14:: ; 53:40E2
	db "　ウソッキー", 0
PokemonName15:: ; 53:40EF
	db "　　ピチュー", 0
PokemonName16:: ; 53:40FC
	db "　　レディバ", 0
PokemonName17:: ; 53:4109
	db "　キレイハナ", 0
PokemonName18:: ; 53:4116
	db "　ミュウツー", 0
PokemonName19:: ; 53:4123
	db "　　ホウオウ", 0
PokemonName20:: ; 53:4130
	db "　ソーナンス", 0
PokemonName21:: ; 53:413D
	db "　　ディグダ", 0
PokemonName22:: ; 53:414A
	db "　フシギバナ", 0
PokemonName23:: ; 53:4157
	db "　　エーフィ", 0
PokemonName24:: ; 53:4164
	db "　ポリゴン２", 0

POPC
