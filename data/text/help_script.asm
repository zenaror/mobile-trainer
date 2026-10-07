; data/text/help_script.asm
; bank 6C, $4809-$5987 (4478 bytes); pinned by layout.link
; help/tutorial script bytecode and single-byte kana text

SECTION "data/text/help_script", ROMX

PUSHC sjis_hw

; ---- data $4809-$4845 (60 bytes) [PROBABLE] table of 5-byte-like records (18 00 01 30 00 / 18 00 09 AF 03 / 18 00 0A 92 09 ...) ending 03 03 01 01 30 right before the text at 4845; read in up to 12 scenarios; the 1-8 byte mapper holes inside this run are bytes not read in the traces; they sit between executed-read pieces of the same block and are not code (no branch enters them, bytes do not decode as a coherent routine)

HelpScript_EntryBlock:: ; 6C:4809
Data_6C_4809::
	db $18, $00, $01, $30, $00, $18, $00, $09, $AF, $03, $18, $00, $0A, $92, $09, $18
	db $00, $11, $16, $0C, $18, $00, $12, $D2, $0E, $18, $00, $81, $17, $00, $18, $00
	db $89, $96, $03, $18, $00, $8A, $79, $09, $18, $00, $91, $FD, $0B, $18, $00, $92
	db $B9, $0E, $04, $88, $10, $08, $7B, $03, $03, $01, $01, $30

; ---- text $4845-$485A (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4845:: ; 6C:4845
	db "Ｍ．Ｔｒａｉｎｅｒ　", 0

; ---- data $485A-$4899 (63 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_485A:: ; 6C:485A
	db $83, $82, $83, $6F, $83, $43, $FA, $83, $67, $83, $8C, $B0, $83, $69, $B0, $CD
	db $D6, $B3, $BA, $BF, $A1, $40, $3C, $10, $BA, $DA, $ED, $83, $4C, $83, $7E, $D3
	db $A4, $83, $82, $83, $6F, $83, $43, $FA, $83, $56, $FD, $83, $65, $83, $80, $82
	db $66, $10, $82, $61, $A6, $C0, $C9, $BC, $D2, $D9, $DD, $EA, $81, $49, $00

; ---- text $4899-$493B (162 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4899:: ; 6C:4899
	db $06, $1D, $03, $03, $01, $01, "ｺﾉカｰトリ", $FE, "ジｦﾀﾉｼﾑﾀﾒﾆ", $10, "ｺﾚｶﾗﾊ", $E6, "ﾏﾙｾﾂﾒｲｦ､ｼｯ", $10, "ｶﾘﾄﾐﾃｶﾗｱｿﾝ", $ED, "ﾈ｡", 0
	db $06, $6B, $FF, $03, $01, $01, "ﾏ", $E7, "ﾊ", $E6, "ﾒﾆ､ｺﾉカｰトリ", $FE, "ジﾉ", $10, "ｾﾂﾒｲｦｽﾙﾖ｡", 0
	db $06, $A1, $FF, $03, $02, $02, "ｺﾉカｰトリ", $FE, "ジ", $ED, "ﾊ､モバイ", $FA, "シ", $10, $FD, "テムＧＢ", $ED, "ｱｿ", $F1, "ﾀﾒﾆﾋﾂﾖｳ", $10, "ﾅ､ｾｯﾃｲｷﾉｳﾉﾎｶﾆ､", 0

; ---- data $493B-$4964 (41 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_493B:: ; 6C:493B
	db $06, $98, $FF, $03, $02, $02, $21, $F9, $B0, $FA, $20, $C4, $21, $83, $7A, $B0
	db $83, $80, $83, $79, $B0, $83, $57, $20, $ED, $B1, $BF, $F1, $BA, $C4, $10, $E0
	db $ED, $B7, $D9, $DD, $EA, $D6, $A1, $10, $00

; ---- text $4964-$499B (55 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4964:: ; 6C:4964
	db $06, $94, $FF, $03, $03, $03, $F9, "ｰ", $FA, $ED, "ﾊ､ゲｰムボｰイカラｰｦ", $10, "ﾂｶｯﾃ､", $21, "ﾃ", $E0, "ﾐﾉﾔﾘﾄﾘ", $E0, "ﾀﾉ", $10, "ｼﾒﾙ", $20, "ﾝ", $EA, "｡", 0

; ---- data $499B-$4A09 (110 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_499B:: ; 6C:499B
	db $06, $A0, $FF, $03, $03, $03, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57
	db $CA, $83, $51, $B0, $83, $80, $83, $7B, $B0, $83, $43, $83, $4A, $83, $89, $B0
	db $10, $ED, $A4, $83, $51, $B0, $83, $80, $83, $5C, $83, $74, $83, $67, $C9, $FB
	db $83, $85, $B0, $FD, $D4, $A4, $C6, $10, $DD, $C3, $DD, $EE, $B3, $83, $82, $83
	db $6F, $83, $43, $FA, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $00
	db $06, $79, $FF, $03, $03, $03, $21, $B2, $C2, $ED, $D3, $EE, $BA, $ED, $D3, $D0
	db $D9, $BA, $C4, $E0, $ED, $B7, $D9, $20, $10, $DD, $EA, $D6, $A1, $00

; ---- text $4A09-$4A78 (111 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4A09:: ; 6C:4A09
	db $06, $92, $FF, $03, $02, $04, "ﾂ", $E1, "ﾆｿｳｻﾉｾﾂﾒｲｦｽﾙﾖ｡", $10, 0
	db $06, $CA, $FF, $03, $02, $04, "ｿｳｻﾉｷﾎﾝﾊ､", $10, "ε", $ED, "カｰソ", $FA, "ﾉｲ", $EE, "ｳﾔｾﾝﾀｸ､", $10, "γ", $ED, "ｹｯﾃｲ", $EA, "ﾖ｡", 0
	db $06, $B9, $FF, $03, $03, $04, "δ", $ED, "キ", $FC, $FF, "セ", $FA, "ﾔ､ﾏｴﾉ", $E0, "ﾒﾝﾆ", $10, "ﾓ", $EE, "ﾙｺﾄ", $E0, $ED, "ｷﾙﾝ", $EA, "ﾖ｡", 0

; ---- data $4A78-$4AA0 (40 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4A78:: ; 6C:4A78
	db $06, $A9, $FF, $03, $02, $04, $FD, $83, $5E, $B0, $83, $67, $83, $7B, $83, $5E
	db $FF, $A6, $B5, $BD, $C4, $A4, $F9, $FB, $83, $85, $B0, $10, $A6, $EA, $BD, $BA
	db $C4, $E0, $ED, $B7, $D9, $D6, $A1, $00

; ---- text $4AA0-$4B2C (140 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4AA0:: ; 6C:4AA0
	db $06, $B0, $FF, $03, $02, $05, "ｺﾉカｰトリ", $FE, "ジﾉｺﾄ､ｽｺｼﾊ", $10, "ﾜｶｯﾃﾓﾗｴﾀｶﾅ？", 0
	db $06, $B0, $FF, $03, $02, $05, "ﾏ", $EA, "ﾜｶﾗﾅｲｺﾄ", $E0, "､ﾀｸｻﾝｱ", $10, "ﾙﾄｵﾓｳｹ", $EE, "､ﾏﾀｱﾄ", $ED, "ｾﾂﾒ", $10, "ｲｽﾙｶﾗ､ｱﾝｼﾝｼﾃﾈ｡", 0
	db $06, $A1, $FF, $03, $02, $05, "ｿﾚﾄ､ｺﾉｾﾂﾒｲﾊ", $21, "【ヘ", $FA, "プ】", $20, $10, $ED, "ｲﾂ", $ED, "ﾓﾐﾙｺﾄ", $E0, $ED, "ｷﾙﾖ｡", 0

; ---- data $4B2C-$4B68 (60 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4B2C:: ; 6C:4B2C
	db $06, $9C, $FF, $03, $02, $05, $DC, $B6, $D7, $C5, $B2, $BA, $C4, $EF, $E0, $ED
	db $C3, $B7, $C0, $C4, $B7, $CA, $10, $21, $81, $79, $83, $77, $FA, $83, $76, $81
	db $7A, $C9, $81, $79, $83, $82, $83, $6F, $83, $43, $FA, $E6, $C3, $DD, $81, $7A
	db $20, $ED, $10, $BC, $D7, $F2, $D7, $DA, $D9, $D6, $A1, $00

; ---- text $4B68-$4B92 (42 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4B68:: ; 6C:4B68
	db $06, $97, $FF, $03, $02, $05, "ﾅﾆｶﾜｶﾗﾅｲｺﾄ", $E0, "ｱｯﾀﾗ､", $10, "ｲﾂ", $ED, "ﾓ【ヘ", $FA, "プ】ｦﾐﾃﾈ｡", 0

; ---- data $4B92-$4BC9 (55 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4B92:: ; 6C:4B92
	db $06, $9A, $FF, $03, $03, $05, $BF, $DA, $ED, $CA, $A4, $83, $82, $83, $6F, $83
	db $43, $FA, $83, $67, $83, $8C, $B0, $83, $69, $B0, $A6, $C0, $10, $C9, $BC, $DD
	db $ED, $C8, $A1, $00, $06, $B2, $FF, $06, $0A, $0D, $10, $01, $01, $04, $04, $0D
	db $08, $DF, $05, $03, $01, $06, $30

; ---- text $4BC9-$4C5F (150 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4BC9:: ; 6C:4BC9
	db "　Ｅｍａｉｌ　", 0
	db $F9, "ｰ", $FA, "ｦﾊ", $E6, "ﾒﾙﾏｴﾆ､", $F9, "ｰ", $FA, "ｯ", $10, "ﾃﾅﾝﾅﾉｶ､ｾﾂﾒｲｽﾙﾖ｡", 0
	db $06, $A5, $05, $03, $04, $06, $F9, "ｰ", $FA, "ﾄｲｳﾉﾊ､ﾃ", $E0, "ﾐﾉﾖｳﾅ", $10, "ﾓﾉ", $ED, "､", $F9, "ｰ", $FA, "アドレ", $FD, "ｦﾓｯﾃｲ", $10, "ﾙﾄﾓ", $EA, "ﾁﾆｵｸﾚﾙﾝ", $EA, "ﾖ｡", 0
	db $06, $8F, $FF, $03, $02, $06, $F9, "ｰ", $FA, "アドレ", $FD, "ﾊ､", $F9, "ｰ", $FA, "ﾉｾｶｲ", $10, $ED, "ﾉ", $21, $E6, "ｭｳｼｮ", $20, "ﾉｺﾄﾅﾝ", $EA, "ﾖ｡", 0

; ---- data $4C5F-$4C9D (62 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4C5F:: ; 6C:4C5F
	db $06, $9A, $FF, $03, $03, $06, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD
	db $E0, $B1, $DA, $EF, $A4, $C4, $D3, $EA, $C1, $10, $C9, $83, $51, $B0, $83, $80
	db $83, $7B, $B0, $83, $43, $83, $4A, $83, $89, $B0, $D4, $A4, $B5, $B3, $C1, $C9
	db $10, $CB, $C4, $C9, $83, $70, $83, $5C, $83, $52, $FF, $C6, $A4, $00

; ---- text $4C9D-$4CDE (65 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4C9D:: ; 6C:4C9D
	db $06, $96, $FF, $03, $05, $06, "ｵﾅ", $E6, "ﾖｳﾆ､", $F9, "ｰ", $FA, "ｦｵｸﾙｺﾄ", $10, $E0, $ED, "ｷﾙﾝ", $EA, "！", 0
	db $06, $A2, $FF, $03, $05, $06, "ｿﾚ", $E6, "ｬｱ､", $F9, "ｰ", $FA, "ﾉｶｷｶﾀｦｾ", $10, "ﾂﾒｲｼﾃｲｸﾖ｡", 0

; ---- data $4CDE-$4D2E (80 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4CDE:: ; 6C:4CDE
	db $06, $BF, $FF, $03, $05, $07, $CF, $E7, $CA, $21, $81, $79, $F9, $B0, $FA, $A6
	db $B6, $B8, $81, $7A, $20, $A6, $B5, $BD, $DD, $EA, $10, $D6, $A1, $00, $06, $C1
	db $FF, $03, $02, $08, $CA, $E6, $D2, $C6, $F9, $B0, $FA, $A6, $B5, $B8, $D9, $C4
	db $D3, $EA, $C1, $C9, $10, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $C4
	db $A4, $83, $5E, $83, $43, $83, $67, $FA, $A6, $B6, $B8, $10, $DD, $EA, $A1, $00

; ---- text $4D2E-$4DDC (174 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4D2E:: ; 6C:4D2E
	db $06, $B0, $FF, $03, $03, $08, $F9, "ｰ", $FA, "アドレ", $FD, "ｦアドレ", $FD, "ﾁｮｳﾆ", $10, "セｰブｼﾃｵｸﾄ､", $F9, "ｰ", $FA, "ｦｶｸﾄ", $10, "ｷﾆ､ﾄｯﾃﾓ", $F2, "ﾝﾘ", $EA, "ﾖ｡", 0
	db $06, $90, $FF, $03, $02, $09, "タイト", $FA, "ｦｶｲﾀｱﾄﾊ､", $F9, "ｰ", $FA, "ﾉ", $10, "ﾎﾝ", $F1, "ﾝｦｶｺｳ｡", 0
	db $06, $9E, $FF, $03, $03, $09, "ﾎﾝ", $F1, "ﾝ", $E0, "ｶｹﾀﾗ､ﾏﾁ", $E0, "ｯﾃｲ", $10, "ﾅｲｶﾓｳｲﾁ", $EE, "ﾐﾅｵｿｳ｡", 0
	db $06, $B6, $FF, $03, $03, $09, "ﾅｲﾖｳ", $E0, "ﾏﾁ", $E0, "ｯﾃｲﾙﾄ､ﾂﾀ", $10, "ｴﾀｲｺﾄﾓﾂﾀﾜﾗﾅｲﾖ｡", 0

; ---- data $4DDC-$4E03 (39 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4DDC:: ; 6C:4DDC
	db $06, $B4, $FF, $03, $02, $0A, $F9, $B0, $FA, $E0, $B6, $B9, $C0, $D7, $A4, $81
	db $79, $82, $6E, $82, $6A, $81, $7A, $C9, $83, $41, $83, $43, $10, $83, $52, $FF
	db $A6, $B5, $BC, $C3, $C8, $A1, $00

; ---- text $4E03-$4F12 (271 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4E03:: ; 6C:4E03
	db $06, $B3, $FF, $03, $03, $0A, "ｲﾏｶｲﾀ", $F9, "ｰ", $FA, "ｦ､カｰトリ", $FE, "ジ", $10, "ﾆセｰブｼﾃ､", $F9, "ｰ", $FA, "ｦｵｸﾙ", $E6, "ｭ", $10, "ﾝ", $F0, "ｦｽﾙﾖ｡", 0
	db $06, $A3, $FF, $03, $05, $0B, $F9, "ｰ", $FA, "ｦセｰブｼﾀﾗ､ﾄﾓ", $EA, "ﾁﾆ", $10, "ｵｸﾛｳ！", $40, $1E, $21, "【ｵｸﾙ／ｳｹﾄﾙ】ｦ", $10, "ｵｽﾄ､", $F9, "ｰ", $FA, "ｦｵｸﾚﾙ", $20, "ﾝ", $EA, "ﾖ｡", 0
	db $06, $87, $FF, $03, $02, $0C, $F9, "ｰ", $FA, "ｦｵｸﾙﾄｲｯｼｮﾆ､キミ", $10, "ﾆﾄ", $EE, "ｲﾀ", $F9, "ｰ", $FA, "ﾓｳｹﾄｯﾃｸﾙ", $10, "ﾖ｡", 0
	db $06, $90, $FF, $03, $05, $0C, $F9, "ｰ", $FA, $E0, "ﾄ", $EE, "ｲﾃｲﾙｶチェ", $FE, "クｽ", $10, "ﾙ", $EA, "ｹﾉﾄｷﾓ､【ｵｸﾙ／ｳｹﾄ", $10, "ﾙ】ｦｵｾ", $EF, "ｲｲﾝ", $EA, "ﾖ｡", 0
	db $06, $98, $FF, $03, $03, $0C, "ｿﾚｶﾗ【ｵｸﾙ／ｳｹﾄﾙ】ﾆﾊ", $10, $21, "ｵｶﾈ", $E0, "ｶｶﾙ", $20, "ｶﾗｷｦﾂｹﾃﾈ｡", $10, 0

; ---- data $4F12-$4F4C (58 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_4F12:: ; 6C:4F12
	db $06, $97, $FF, $03, $05, $0D, $83, $4C, $83, $7E, $B1, $C3, $C6, $C4, $EE, $B2
	db $C0, $F9, $B0, $FA, $CA, $81, $79, $F9, $B0, $10, $FA, $83, $7B, $FE, $83, $4E
	db $FD, $81, $7A, $ED, $D0, $D9, $DD, $EA, $D6, $A1, $10, $D6, $D0, $C0, $B2, $F9
	db $B0, $FA, $A6, $B4, $D7, $DD, $ED, $C8, $A1, $00

; ---- text $4F4C-$516F (547 bytes) [PROBABLE] text: 12 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_4F4C:: ; 6C:4F4C
	db $06, $98, $FF, $03, $02, $0E, "ﾀ", $EA, "ｼ､ﾄ", $EE, "ｲﾀ", $F9, "ｰ", $FA, "ｦﾉｺｼﾃ", $10, "ｵｹﾙﾉﾊ､", $21, "１２ﾂｳﾏ", $ED, $20, $EA, "ﾖ｡", 0
	db $06, $9B, $FF, $03, $03, $0E, "１２ﾂｳ", $F9, "ｰ", $FA, $E0, "ﾉｺｯﾃｲﾙﾄｷ", $10, "ﾊ､", $F9, "ｰ", $FA, "ｦｳｹﾄﾙｺﾄ", $E0, $ED, "ｷﾅ", $10, "ｲﾝ", $EA, "｡", 0
	db $06, $A6, $FF, $03, $02, $0E, $EA, "ｶﾗ､", $21, "ﾖﾐｵﾜｯﾀ", $F9, "ｰ", $FA, "ﾊ､ｺ", $10, "ﾏﾒﾆｽﾃﾀﾎｳ", $E0, "ｲｲ", $20, "ﾝ", $EA, "ﾖ｡", 0
	db $06, $A8, $FF, $03, $05, $0E, "ｺﾚﾊﾀｲｾﾂﾅｺﾄ", $EA, "ｶﾗ､ｼｯ", $10, "ｶﾘｵ", $F3, "ｴﾃｵｲﾃﾈ！", 0
	db $06, $B3, $FF, $03, $02, $1F, "ｿﾚｶﾗ､ｺﾉカｰトリ", $FE, "ジ", $ED, "ﾊ､", $10, $F9, "ｰ", $FA, "サｰバﾉｾｲﾘ", $E0, $ED, "ｷﾙﾝ", $EA, $10, "ﾖ｡", 0
	db $06, $AB, $FF, $03, $02, $1F, $F9, $FB, "ュｰｶﾗ､【", $F9, "ｰ", $FA, "サｰバ】ｦ", $10, "ｴﾗ", $F1, "ﾄ､サｰバﾉ", $F9, "ｰ", $FA, "ｦｹｼﾃ", $10, "ｾｲﾘ", $ED, "ｷﾙﾝ", $EA, "ﾖ｡", 0
	db $06, $95, $FF, $03, $02, $1F, $F9, "ｰ", $FA, "サｰバﾉｾｲﾘｦｼﾅｲﾄ､", $10, $21, "ﾂｳｼﾝ", $E6, "ｶﾝ", $E0, "ﾅ", $E0, "ｸﾅｯﾃｼﾏ", $10, "ｳｺﾄ", $E0, "ｱﾙ", $20, "ﾝ", $EA, "｡", 0
	db $06, $90, $FF, $03, $02, $1F, "ﾀ", $EA, "ｼ､", $21, "ｷｴﾃｼﾏｯﾀ", $F9, "ｰ", $FA, "ﾊ､", $10, "ﾓﾄﾆﾓ", $EE, "ﾗﾅｲ", $20, "ｶﾗ､ｷｦﾂｹﾃ", $10, "ﾈ｡", 0
	db $06, $9D, $FF, $03, $03, $0F, $F9, "ｰ", $FA, "ｦﾂｶｳﾄ､ﾄﾓ", $EA, "ﾁﾄﾉﾚ", $10, "ﾝﾗｸﾔ､", $E6, "ｮｳﾎｳｺｳｶﾝｦｽ", $10, "ﾙｺﾄﾓ", $ED, "ｷﾙﾝ", $EA, "｡", 0
	db $06, $A0, $FF, $03, $02, $0F, "イ", $FF, "タｰネ", $FE, "トﾉｾｶｲ", $ED, "､ｱﾀﾗ", $10, "ｼｲﾄﾓ", $EA, "ﾁﾄ", $ED, "ｱｴﾙｶﾓｼﾚﾅ", $10, "ｲﾖ｡", 0
	db $06, $9D, $FF, $03, $03, $0F, "ﾁﾅﾐﾆ", $F9, "ｰ", $FA, "ｦｵｸﾘｱｳﾄﾓ", $EA, $10, "ﾁﾉｺﾄｦ｢", $F9, $FA, "ﾄﾓ｣ﾄｲｳﾝ", $EA, $10, "ﾖ｡", 0
	db $06, $A5, $FF, $03, $02, $0F, "ｲｯ", $F4, "ｲｱｿﾝ", $ED, "､", $F9, $FA, "ﾄﾓｦﾀｸ", $10, "ｻﾝﾂｸｯﾃﾈ｡", 0

; ---- data $516F-$5177 (8 bytes) [PROBABLE] message-record header 06 B5 FF 18 00 09 2A 00 (06 xx FF = record header as in the other bank-6C script records) preceding the string at 5177; first 6 bytes read in up to 5 scenarios, the 2-byte hole 5175 is its tail

Data_6C_516F:: ; 6C:516F
	db $06, $B5, $FF, $18, $00, $09, $2A, $00

; ---- text $5177-$519E (39 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_5177:: ; 6C:5177
	db $03, $04, $0F, "ｻｲ", $E4, "ﾆ､", $F9, "ｰ", $FA, "ﾆｶｶﾚﾙキミﾉ", $10, $FB, $FE, "クネｰムｦｵｼｴﾃﾈ｡", 0

; ---- data $519E-$51B1 (19 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 5177-5216 by higher-priority evidence]

Data_6C_519E:: ; 6C:519E
	db $06, $B1, $FF, $06, $22, $07, $10, $02, $01, $04, $1C, $07, $08, $80, $02, $03
	db $01, $10, $30

; ---- text $51B1-$5213 (98 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_51B1:: ; 6C:51B1
	db "Ａｄｄｒ．Ｂｏｏｋ", 0
	db "アドレ", $FD, "ﾁｮｳﾆﾂｲﾃ､ｾﾂﾒｲ", $10, "ｽﾙﾖ｡", 0
	db $06, $4A, $02, $03, $02, $10, $F9, "ｰ", $FA, "アドレ", $FD, $E0, "､ﾄﾓ", $EA, "ﾁﾉ", $E6, "ｭ", $10, "ｳｼｮﾉﾖｳﾅﾓﾉ", $EA, "ﾄｲｳｺﾄﾊ", $10, "ﾏｴﾆﾊﾅｼﾀﾖﾈ｡", 0

; ---- data $5213-$5216 (3 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 5177-5216 by higher-priority evidence]

Data_6C_5213:: ; 6C:5213
	db $06, $97, $FF

; ---- text $5216-$5236 (32 bytes) [PROBABLE] body of the record whose header 06 97 FF was read at 5213-5216 (executed); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_5216:: ; 6C:5216
	db $03, $03, $10, $ED, "ﾓ", $F9, "ｰ", $FA, "アドレ", $FD, "ｦｵ", $F3, "ｴﾙﾉﾊ", $10, "ﾀｲﾍﾝ", $EA, "ﾖﾈ｡", 0

; ---- text $5236-$52B2 (124 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_5236:: ; 6C:5236
	db $06, $A7, $FF, $03, $04, $10, "ｿﾝﾅﾄｷﾆﾊ､アドレ", $FD, "ﾁｮｳﾆ", $21, $10, $F9, "ｰ", $FA, "アドレ", $FD, "ｦセｰブ", $20, "ｼﾃｵｸﾄ", $10, "ｲｲﾝ", $EA, "ﾖ｡", 0
	db $06, $A4, $FF, $03, $02, $11, "アドレ", $FD, "ﾁｮｳ", $E0, "ﾒﾝ", $ED, "､セｰブｽ", $10, "ﾙ", $EF, "ｼｮｦｴﾗﾝ", $EA, "ｱﾄﾆ､", $21, "【ｶｷ", $10, "ｺﾑ】", $20, "ﾉアイコ", $FF, "ｦｵｼﾃﾈ｡", 0

; ---- text $52B2-$52E3 (49 bytes) [PROBABLE] one record (06 84 FF 03 03 11 ... 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_52B2:: ; 6C:52B2
	db $06, $84, $FF, $03, $03, $11, "ﾆｭｳﾘｮｸ", $E0, "ﾒﾝ", $E0, $ED, "ﾀﾗ､", $FB, $FE, $10, "クネｰムﾄ", $F9, "ｰ", $FA, "アドレ", $FD, "ｦｶｲﾃ", $10, "ﾈ｡", 0

; ---- text $52E3-$533A (87 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_52E3:: ; 6C:52E3
	db $06, $8C, $FF, $03, $03, $12, "ｶｷｵﾜｯﾀﾗ､【ＯＫ】ｦｵｼﾃ", $10, "セｰブｼﾖｳ｡", 0
	db $06, $AA, $FF, $03, $05, $12, "ﾏｴﾆｶｲﾀ", $F9, "ｰ", $FA, "アドレ", $FD, "ｦﾍﾝ", $10, "ｺｳｼﾀﾘ､ｹｼﾀﾘｽﾙｺﾄﾓ", $ED, $10, "ｷﾙﾝ", $EA, "ﾖ｡", 0

; ---- text $533A-$53F7 (189 bytes) [PROBABLE] 5 consecutive records (06 A9 FF / 06 9E FF / 06 AF FF / 06 9A FF ...) each ending with 00; second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_533A:: ; 6C:533A
	db $06, $A9, $FF, $03, $02, $13, $F9, "ｰ", $FA, "アドレ", $FD, $E0, "セｰブ", $ED, "ｷﾀﾗ､", $10, "アドレ", $FD, "ﾁｮｳｶﾗｴﾗ", $F1, $EA, "ｹ", $ED, "､", 0
	db $06, $9E, $FF, $03, $02, $13, $F9, "ｰ", $FA, "アドレ", $FD, "ｦ､ｶｸｺﾄ", $E0, $ED, "ｷ", $10, "ﾁｬｳﾝ", $EA, "｡", 0
	db $06, $AF, $FF, $03, $03, $13, "ﾄﾓ", $EA, "ﾁﾉ", $F9, "ｰ", $FA, "アドレ", $FD, "ｦｶｸ", $E0, $10, "ﾒﾝ", $ED, "､", $21, "セレクトボタ", $FF, $20, "ｦｵｽﾄ､", $10, "アドレ", $FD, "ﾁｮｳ", $E0, $ED, "ﾃｸﾙﾖ｡", 0
	db $06, $9A, $FF, $03, $03, $13, $F9, "ｰ", $FA, "ｦ", $EA, "ｼﾀｲﾄﾓ", $EA, "ﾁﾉ､", $F9, "ｰ", $10, $FA, "アドレ", $FD, "ｦｴﾗﾝ", $ED, "ﾈ｡", 0

; ---- text $53F7-$5427 (48 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_53F7:: ; 6C:53F7
	db $06, $94, $FF, $03, $03, $13, "アドレ", $FD, "ﾁｮｳｦﾂｶｲｺﾅｼﾃ､", $10, $F9, "ｰ", $FA, "ｺｳｶﾝｦｶｲﾃｷﾆﾀﾉｼ", $10, "ﾝ", $ED, "ﾈ｡", 0

; ---- data $5427-$543A (19 bytes) [PROBABLE] control record (not text): 06 A9 FF 06 99 04 10 03 01 04 93 04 08 B8 02 03 01 14 30 = header + command parameters; bytes 542A-543A were read in up to 8 scenarios, the 3 header bytes were the hole

Data_6C_5427:: ; 6C:5427
	db $06, $A9, $FF, $06, $99, $04, $10, $03, $01, $04, $93, $04, $08, $B8, $02, $03
	db $01, $14, $30

; ---- text $543A-$54D3 (153 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_543A:: ; 6C:543A
	db "Ｈｏｍｅ　Ｐａｇｅ", 0
	db "ホｰムペｰジ", $ED, "ｱｿ", $F1, "ﾏｴﾆ､ｽｺ", $10, "ｼ", $EA, "ｹ､ｾﾂﾒｲｽﾙﾖ｡", 0
	db $06, $79, $02, $03, $01, $15, "ホｰムペｰジﾊ､ｴﾔﾓ", $E6, "ｦﾂｶｯ", $10, "ﾀｲﾛﾝﾅ", $E6, "ｮｳﾎｳｦﾐﾙｺﾄ", $E0, $10, $ED, "ｷﾙﾝ", $EA, "｡", 0
	db $06, $91, $FF, $03, $03, $15, "ホｰムペｰジﾊｾｶｲ", $E6, "ｭｳﾆﾀｸ", $10, "ｻﾝｱｯﾃ､ﾐﾝﾅﾂﾅ", $E0, "ｯﾃｲﾙ", $10, "ﾝ", $EA, "ﾖ｡", 0

; ---- text $54D3-$5505 (50 bytes) [PROBABLE] one record (06 9C FF 03 05 16 ... 81 49 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_54D3:: ; 6C:54D3
	db $06, $9C, $FF, $03, $05, $16, $E6, "ｬｱ", $21, "【ホｰムペｰジ】", $20, "ｦｵｼﾃ､", $10, "ホｰムペｰジｦﾐﾃﾐﾖｳ！", 0

; ---- text $5505-$556B (102 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_5505:: ; 6C:5505
	db $06, $9D, $FF, $03, $05, $17, "ホｰムペｰジｦﾐﾃｲﾃ､", $21, "ｱｵｲﾓ", $10, $E6, $E0, "ｱｯﾀﾗ､Ａボタ", $FF, $20, "ｦｵｼﾃﾐ", $10, "ﾖｳ｡", 0
	db $06, $99, $FF, $03, $05, $17, "ｿﾉペｰジﾄﾂﾅ", $E0, "ｯﾃｲﾙペｰジ", $10, "ﾆ､ジ", $FC, $FF, "プｽﾙｺﾄ", $E0, $ED, "ｷﾙﾝ", $EA, $10, "ﾖ｡", 0

; ---- text $556B-$5594 (41 bytes) [PROBABLE] one record (06 9A FF 03 05 17 ... 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_556B:: ; 6C:556B
	db $06, $9A, $FF, $03, $05, $17, "ｺﾚｦ､", $21, "ホｰムペｰジ", $E0, "リ", $FF, "クｼﾃ", $10, "ｲﾙ", $20, "ﾄｲｳﾝ", $EA, "ﾖ｡", 0

; ---- text $5594-$56E8 (340 bytes) [PROBABLE] text: 7 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_5594:: ; 6C:5594
	db $06, $A6, $FF, $03, $02, $18, "Ｂボタ", $FF, "ｦｵｽﾄ､ﾏｴﾉペｰジﾆ", $10, "ﾓ", $EE, "ﾙｺﾄﾓ", $ED, "ｷﾙﾝ", $EA, "ﾖ｡", 0
	db $06, $AD, $FF, $03, $02, $19, "ホｰムペｰジｦﾐﾃｲﾙﾄｷﾆﾊ､", $10, $21, "ｵｶﾈ", $E0, "ｶｶﾙﾝ", $EA, "｡", $20, 0
	db $06, $AE, $FF, $03, $02, $19, "ｱﾏﾘ", $21, "ﾅ", $E0, "ｲ", $E6, "ｶﾝｾﾂ", $E9, "ｸｽﾙﾉﾊﾔﾒﾖｳ", $20, "ﾈ｡", 0
	db $06, $B8, $FF, $03, $03, $1A, "ゲｰムソフトﾉ", $FB, "ュｰ", $FD, "ﾔ､ｵﾓｼ", $10, "ﾛｲ", $E6, "ｮｳﾎｳｦ､ｲﾂ", $ED, "ﾓ", $EE, "ｺ", $ED, $10, "ﾓﾐﾙｺﾄ", $E0, $ED, "ｷﾙﾝ", $EA, "ﾖ｡", 0
	db $06, $A4, $FF, $03, $03, $1A, "ｿﾚﾄ､ﾆﾝﾃﾝ", $EE, "ｳモバイ", $FA, "ホｰ", $10, "ムペｰジﾆﾊ､ﾀｲｾﾂﾅｵｼﾗｾ", $10, $E0, "ｱﾙﾉ", $ED, "､ﾐﾆｷﾃﾈ｡", 0
	db $06, $88, $FF, $03, $03, $1A, "キミﾊ", $EE, "ﾝﾅ", $E6, "ｮｳﾎｳ", $E0, "ﾐﾀｲﾉ", $10, "ｶﾅ？ホｰムペｰジﾆﾊ､ｷﾐﾉｼ", $10, "ﾗﾅｲ", $E6, "ｮｳﾎｳ", $E0, "ｲｯ", $F4, "ｲ", $EA, "ﾖ｡", 0
	db $06, $84, $FF, $03, $03, $1A, "ｻｲｼﾝﾉ", $FB, "ュｰ", $FD, "ｦﾐﾂｹﾀﾗ､", $10, "ﾄﾓ", $EA, "ﾁﾆ", $E6, "ﾏﾝｼﾁｬｵｳ！！", 0

; ---- data $56E8-$56FB (19 bytes) [PROBABLE] control record (not text): 06 96 FF 06 D8 01 10 04 01 04 D2 01 08 C9 01 03 01 1B 30 (header + parameters), mid part read in 1 scenario

Data_6C_56E8:: ; 6C:56E8
	db $06, $96, $FF, $06, $D8, $01, $10, $04, $01, $04, $D2, $01, $08, $C9, $01, $03
	db $01, $1B, $30

; ---- text $56FB-$58BA (447 bytes) [PROBABLE] text: 9 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; written with the sjis_hw charmap: single bytes A1-DF appear as half-width katakana (JIS X 0201 order), other single bytes as $xx; glyphs unproven (text_encoding.md section 6)

String_6C_56FB:: ; 6C:56FB
	db "Ｂｏｏｋｍａｒｋｓ", 0
	db "ペｰジリ", $FD, "トﾆﾂｲﾃ､ｾﾂﾒｲｽ", $10, "ﾙﾖ｡", 0
	db $06, $93, $01, $03, $01, $1B, "ｵｷﾆｲﾘﾉホｰムペｰジｦ､ﾐﾙ", $10, "ﾄｷﾆ､ﾀｸｻﾝリ", $FF, "クｦジ", $FC, $FF, "プ", $10, "ｽﾙﾉﾊﾒﾝ", $EE, "ｳ", $EA, "ﾖﾈ｡", 0
	db $06, $90, $FF, $03, $03, $1B, "ｿﾝﾅﾄｷﾊ､", $21, "ペｰジリ", $FD, "トﾆセｰ", $10, "ブｼﾃｵｸﾄ", $F2, "ﾝﾘ", $20, "ﾅﾝ", $EA, "｡", 0
	db $06, $96, $FF, $03, $03, $1C, "ｵｷﾆｲﾘﾉペｰジｦﾐﾂｹﾀﾗ､", $10, "ペｰジリ", $FD, "トﾉ", $E0, "ﾒﾝﾆｽｽﾝ", $ED, "､", $10, "セｰブｼﾀｲ", $EF, "ｼｮｦｴﾗﾝ", $ED, "ﾈ｡", 0
	db $06, $92, $FF, $03, $02, $1C, "ｿﾉｱﾄﾆ､", $21, "【セｰブ】", $20, "ｦｴﾗ", $F1, "ﾄ", $10, "ｿﾉホｰムペｰジﾉ", $EF, "ｼｮｦセｰブ", $10, $ED, "ｷﾙﾝ", $EA, "ﾖ｡", 0
	db $06, $83, $FF, $03, $02, $1D, "セｰブｼﾀホｰムペｰジｦﾐﾙﾆﾊ", $10, "ﾐﾀｲペｰジｦｴﾗﾝ", $ED, "ｶﾗ", $21, "【ジ", $FC, $10, $FF, "プ】", $20, "ｦｵｽﾝ", $EA, "ﾖ｡", 0
	db $06, $83, $FF, $03, $02, $1D, "ﾀｸｻﾝジ", $FC, $FF, "プｼﾅｲﾄﾐﾗﾚﾅ", $10, "ｲペｰジﾓ､ｽ", $E2, "ﾆﾐﾙｺﾄ", $E0, $ED, "ｷ", $10, "ﾃ､", $21, $E6, "ｶﾝﾉｾﾂﾔｸﾆﾅﾙﾝ", $EA, "｡", $20, 0
	db $06, $80, $FF, $03, $05, $1E, "ペｰジリ", $FD, "トｦｳﾏｸﾂｶｯﾃホｰ", $10, "ムペｰジｦﾀﾉｼﾝ", $ED, "ﾈ｡", 0

; ---- data $58BA-$5987 (205 bytes) [PROBABLE] control header 06 95 FF 06 06 00 10 05 01 04 followed by Shift-JIS kana character tables (81 42 81 75 ..., hiragana 82 F0 82 9F ..., dakuten set, katakana 83 81 83 8B ...) = the character grid of the text-entry screen; mostly read in up to 12 scenarios, holes are unread bytes of the same tables
; kept as raw bytes: text-like bytes mixed with header/control bytes, executed-read data of unknown content class, so not provably a string

Data_6C_58BA:: ; 6C:58BA
	db $06, $95, $FF, $06, $06, $00, $10, $05, $01, $04, $00, $00, $00

HelpScript_SingleByteToSjis:: ; 6C:58C7
	db $00, $00, $81, $42, $81, $75, $81, $76, $81, $41, $00, $00, $82, $F0, $82, $9F
	db $82, $A1, $82, $A3, $82, $A5, $82, $A7, $82, $E1, $82, $E3, $82, $E5, $82, $C1
	db $81, $5B, $82, $A0, $82, $A2, $82, $A4, $82, $A6, $82, $A8, $82, $A9, $82, $AB
	db $82, $AD, $82, $AF, $82, $B1, $82, $B3, $82, $B5, $82, $B7, $82, $B9, $82, $BB
	db $82, $BD, $82, $BF, $82, $C2, $82, $C4, $82, $C6, $82, $C8, $82, $C9, $82, $CA
	db $82, $CB, $82, $CC, $82, $CD, $82, $D0, $82, $D3, $82, $D6, $82, $D9, $82, $DC
	db $82, $DD, $82, $DE, $82, $DF, $82, $E0, $82, $E2, $82, $E4, $82, $E6, $82, $E7
	db $82, $E8, $82, $E9, $82, $EA, $82, $EB, $82, $ED, $82, $F1, $81, $4A, $81, $4B
	db $82, $AA, $82, $AC, $82, $AE, $82, $B0, $82, $B2, $82, $B4, $82, $B6, $82, $B8
	db $82, $BA, $82, $BC, $82, $BE, $82, $C0, $82, $C3, $82, $C5, $82, $C7, $82, $CE
	db $82, $D1, $82, $D4, $82, $D7, $82, $DA, $82, $CF, $82, $D2, $82, $D5, $82, $D8
	db $82, $DB, $83, $81, $83, $8B, $83, $6A, $83, $83, $83, $58, $83, $62, $83, $93

POPC
