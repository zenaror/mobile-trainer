; data/text/help_script.asm
; bank 6C, $4809-$5987 (4478 bytes); pinned by layout.link
; help/tutorial script bytecode and single-byte kana text

SECTION "data/text/help_script", ROMX

; ---- data $4809-$4845 (60 bytes) [PROBABLE] table of 5-byte-like records (18 00 01 30 00 / 18 00 09 AF 03 / 18 00 0A 92 09 ...) ending 03 03 01 01 30 right before the text at 4845; read in up to 12 scenarios; the 1-8 byte mapper holes inside this run are bytes not read in the traces; they sit between executed-read pieces of the same block and are not code (no branch enters them, bytes do not decode as a coherent routine)

HelpScript_EntryBlock:: ; 6C:4809
Data_6C_4809::
	db $18, $00, $01, $30, $00, $18, $00, $09, $AF, $03, $18, $00, $0A, $92, $09, $18
	db $00, $11, $16, $0C, $18, $00, $12, $D2, $0E, $18, $00, $81, $17, $00, $18, $00
	db $89, $96, $03, $18, $00, $8A, $79, $09, $18, $00, $91, $FD, $0B, $18, $00, $92
	db $B9, $0E, $04, $88, $10, $08, $7B, $03, $03, $01, $01, $30

; ---- text $4845-$485A (21 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4845:: ; 6C:4845
	db $81, $40, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C, $81, $5B, $83, $69, $81, $5B, $00 ; "　モバイルトレーナー"

; ---- data $485A-$4899 (63 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_485A:: ; 6C:485A
	db $83, $82, $83, $6F, $83, $43, $FA, $83, $67, $83, $8C, $B0, $83, $69, $B0, $CD
	db $D6, $B3, $BA, $BF, $A1, $40, $3C, $10, $BA, $DA, $ED, $83, $4C, $83, $7E, $D3
	db $A4, $83, $82, $83, $6F, $83, $43, $FA, $83, $56, $FD, $83, $65, $83, $80, $82
	db $66, $10, $82, $61, $A6, $C0, $C9, $BC, $D2, $D9, $DD, $EA, $81, $49, $00

; ---- text $4899-$493B (162 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4899:: ; 6C:4899
	db $06, $1D, $03, $03, $01, $01, $BA, $C9, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $A6, $C0, $C9, $BC, $D1, $C0, $D2, $C6, $10, $BA, $DA, $B6, $D7, $CA, $E6, $CF ; "<$06><$1D><$03><$03><$01><$01>ｺﾉカｰトリ<$FE>ジｦﾀﾉｼﾑﾀﾒﾆ<$10>ｺﾚｶﾗﾊ<$E6>ﾏ"
	db $D9, $BE, $C2, $D2, $B2, $A6, $A4, $BC, $AF, $10, $B6, $D8, $C4, $D0, $C3, $B6, $D7, $B1, $BF, $DD, $ED, $C8, $A1, $00 ; "ﾙｾﾂﾒｲｦ､ｼｯ<$10>ｶﾘﾄﾐﾃｶﾗｱｿﾝ<$ED>ﾈ｡"
	db $06, $6B, $FF, $03, $01, $01, $CF, $E7, $CA, $E6, $D2, $C6, $A4, $BA, $C9, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $C9, $10, $BE, $C2, $D2, $B2, $A6, $BD, $D9 ; "<$06>k<$FF><$03><$01><$01>ﾏ<$E7>ﾊ<$E6>ﾒﾆ､ｺﾉカｰトリ<$FE>ジﾉ<$10>ｾﾂﾒｲｦｽﾙ"
	db $D6, $A1, $00 ; "ﾖ｡"
	db $06, $A1, $FF, $03, $02, $02, $BA, $C9, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $ED, $CA, $A4, $83, $82, $83, $6F, $83, $43, $FA, $83, $56, $10, $FD, $83, $65 ; "<$06>｡<$FF><$03><$02><$02>ｺﾉカｰトリ<$FE>ジ<$ED>ﾊ､モバイ<$FA>シ<$10><$FD>テ"
	db $83, $80, $82, $66, $82, $61, $ED, $B1, $BF, $F1, $C0, $D2, $C6, $CB, $C2, $D6, $B3, $10, $C5, $A4, $BE, $AF, $C3, $B2, $B7, $C9, $B3, $C9, $CE, $B6, $C6, $A4, $00 ; "ムＧＢ<$ED>ｱｿ<$F1>ﾀﾒﾆﾋﾂﾖｳ<$10>ﾅ､ｾｯﾃｲｷﾉｳﾉﾎｶﾆ､"

; ---- data $493B-$4964 (41 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_493B:: ; 6C:493B
	db $06, $98, $FF, $03, $02, $02, $21, $F9, $B0, $FA, $20, $C4, $21, $83, $7A, $B0
	db $83, $80, $83, $79, $B0, $83, $57, $20, $ED, $B1, $BF, $F1, $BA, $C4, $10, $E0
	db $ED, $B7, $D9, $DD, $EA, $D6, $A1, $10, $00

; ---- text $4964-$499B (55 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4964:: ; 6C:4964
	db $06, $94, $FF, $03, $03, $03, $F9, $B0, $FA, $ED, $CA, $A4, $83, $51, $B0, $83, $80, $83, $7B, $B0, $83, $43, $83, $4A, $83, $89, $B0, $A6, $10, $C2, $B6, $AF, $C3, $A4 ; "<$06><$94><$FF><$03><$03><$03><$F9>ｰ<$FA><$ED>ﾊ､ゲｰムボｰイカラｰｦ<$10>ﾂｶｯﾃ､"
	db $21, $C3, $E0, $D0, $C9, $D4, $D8, $C4, $D8, $E0, $C0, $C9, $10, $BC, $D2, $D9, $20, $DD, $EA, $A1, $00 ; "!ﾃ<$E0>ﾐﾉﾔﾘﾄﾘ<$E0>ﾀﾉ<$10>ｼﾒﾙ ﾝ<$EA>｡"

; ---- data $499B-$4A09 (110 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_499B:: ; 6C:499B
	db $06, $A0, $FF, $03, $03, $03, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57
	db $CA, $83, $51, $B0, $83, $80, $83, $7B, $B0, $83, $43, $83, $4A, $83, $89, $B0
	db $10, $ED, $A4, $83, $51, $B0, $83, $80, $83, $5C, $83, $74, $83, $67, $C9, $FB
	db $83, $85, $B0, $FD, $D4, $A4, $C6, $10, $DD, $C3, $DD, $EE, $B3, $83, $82, $83
	db $6F, $83, $43, $FA, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $00
	db $06, $79, $FF, $03, $03, $03, $21, $B2, $C2, $ED, $D3, $EE, $BA, $ED, $D3, $D0
	db $D9, $BA, $C4, $E0, $ED, $B7, $D9, $20, $10, $DD, $EA, $D6, $A1, $00

; ---- text $4A09-$4A78 (111 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4A09:: ; 6C:4A09
	db $06, $92, $FF, $03, $02, $04, $C2, $E1, $C6, $BF, $B3, $BB, $C9, $BE, $C2, $D2, $B2, $A6, $BD, $D9, $D6, $A1, $10, $00 ; "<$06><$92><$FF><$03><$02><$04>ﾂ<$E1>ﾆｿｳｻﾉｾﾂﾒｲｦｽﾙﾖ｡<$10>"
	db $06, $CA, $FF, $03, $02, $04, $BF, $B3, $BB, $C9, $B7, $CE, $DD, $CA, $A4, $10, $83, $C3, $ED, $83, $4A, $B0, $83, $5C, $FA, $C9, $B2, $EE, $B3, $D4, $BE, $DD, $C0, $B8 ; "<$06>ﾊ<$FF><$03><$02><$04>ｿｳｻﾉｷﾎﾝﾊ､<$10>ε<$ED>カｰソ<$FA>ﾉｲ<$EE>ｳﾔｾﾝﾀｸ"
	db $A4, $10, $83, $C1, $ED, $B9, $AF, $C3, $B2, $EA, $D6, $A1, $00 ; "､<$10>γ<$ED>ｹｯﾃｲ<$EA>ﾖ｡"
	db $06, $B9, $FF, $03, $03, $04, $83, $C2, $ED, $83, $4C, $FC, $FF, $83, $5A, $FA, $D4, $A4, $CF, $B4, $C9, $E0, $D2, $DD, $C6, $10, $D3, $EE, $D9, $BA, $C4, $E0, $ED, $B7 ; "<$06>ｹ<$FF><$03><$03><$04>δ<$ED>キ<$FC><$FF>セ<$FA>ﾔ､ﾏｴﾉ<$E0>ﾒﾝﾆ<$10>ﾓ<$EE>ﾙｺﾄ<$E0><$ED>ｷ"
	db $D9, $DD, $EA, $D6, $A1, $00 ; "ﾙﾝ<$EA>ﾖ｡"

; ---- data $4A78-$4AA0 (40 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4A78:: ; 6C:4A78
	db $06, $A9, $FF, $03, $02, $04, $FD, $83, $5E, $B0, $83, $67, $83, $7B, $83, $5E
	db $FF, $A6, $B5, $BD, $C4, $A4, $F9, $FB, $83, $85, $B0, $10, $A6, $EA, $BD, $BA
	db $C4, $E0, $ED, $B7, $D9, $D6, $A1, $00

; ---- text $4AA0-$4B2C (140 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4AA0:: ; 6C:4AA0
	db $06, $B0, $FF, $03, $02, $05, $BA, $C9, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $C9, $BA, $C4, $A4, $BD, $BA, $BC, $CA, $10, $DC, $B6, $AF, $C3, $D3, $D7, $B4 ; "<$06>ｰ<$FF><$03><$02><$05>ｺﾉカｰトリ<$FE>ジﾉｺﾄ､ｽｺｼﾊ<$10>ﾜｶｯﾃﾓﾗｴ"
	db $C0, $B6, $C5, $81, $48, $00 ; "ﾀｶﾅ？"
	db $06, $B0, $FF, $03, $02, $05, $CF, $EA, $DC, $B6, $D7, $C5, $B2, $BA, $C4, $E0, $A4, $C0, $B8, $BB, $DD, $B1, $10, $D9, $C4, $B5, $D3, $B3, $B9, $EE, $A4, $CF, $C0, $B1 ; "<$06>ｰ<$FF><$03><$02><$05>ﾏ<$EA>ﾜｶﾗﾅｲｺﾄ<$E0>､ﾀｸｻﾝｱ<$10>ﾙﾄｵﾓｳｹ<$EE>､ﾏﾀｱ"
	db $C4, $ED, $BE, $C2, $D2, $10, $B2, $BD, $D9, $B6, $D7, $A4, $B1, $DD, $BC, $DD, $BC, $C3, $C8, $A1, $00 ; "ﾄ<$ED>ｾﾂﾒ<$10>ｲｽﾙｶﾗ､ｱﾝｼﾝｼﾃﾈ｡"
	db $06, $A1, $FF, $03, $02, $05, $BF, $DA, $C4, $A4, $BA, $C9, $BE, $C2, $D2, $B2, $CA, $21, $81, $79, $83, $77, $FA, $83, $76, $81, $7A, $20, $10, $ED, $B2, $C2, $ED, $D3 ; "<$06>｡<$FF><$03><$02><$05>ｿﾚﾄ､ｺﾉｾﾂﾒｲﾊ!【ヘ<$FA>プ】 <$10><$ED>ｲﾂ<$ED>ﾓ"
	db $D0, $D9, $BA, $C4, $E0, $ED, $B7, $D9, $D6, $A1, $00 ; "ﾐﾙｺﾄ<$E0><$ED>ｷﾙﾖ｡"

; ---- data $4B2C-$4B68 (60 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4B2C:: ; 6C:4B2C
	db $06, $9C, $FF, $03, $02, $05, $DC, $B6, $D7, $C5, $B2, $BA, $C4, $EF, $E0, $ED
	db $C3, $B7, $C0, $C4, $B7, $CA, $10, $21, $81, $79, $83, $77, $FA, $83, $76, $81
	db $7A, $C9, $81, $79, $83, $82, $83, $6F, $83, $43, $FA, $E6, $C3, $DD, $81, $7A
	db $20, $ED, $10, $BC, $D7, $F2, $D7, $DA, $D9, $D6, $A1, $00

; ---- text $4B68-$4B92 (42 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4B68:: ; 6C:4B68
	db $06, $97, $FF, $03, $02, $05, $C5, $C6, $B6, $DC, $B6, $D7, $C5, $B2, $BA, $C4, $E0, $B1, $AF, $C0, $D7, $A4, $10, $B2, $C2, $ED, $D3, $81, $79, $83, $77, $FA, $83, $76 ; "<$06><$97><$FF><$03><$02><$05>ﾅﾆｶﾜｶﾗﾅｲｺﾄ<$E0>ｱｯﾀﾗ､<$10>ｲﾂ<$ED>ﾓ【ヘ<$FA>プ"
	db $81, $7A, $A6, $D0, $C3, $C8, $A1, $00 ; "】ｦﾐﾃﾈ｡"

; ---- data $4B92-$4BC9 (55 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4B92:: ; 6C:4B92
	db $06, $9A, $FF, $03, $03, $05, $BF, $DA, $ED, $CA, $A4, $83, $82, $83, $6F, $83
	db $43, $FA, $83, $67, $83, $8C, $B0, $83, $69, $B0, $A6, $C0, $10, $C9, $BC, $DD
	db $ED, $C8, $A1, $00, $06, $B2, $FF, $06, $0A, $0D, $10, $01, $01, $04, $04, $0D
	db $08, $DF, $05, $03, $01, $06, $30

; ---- text $4BC9-$4C5F (150 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4BC9:: ; 6C:4BC9
	db $81, $40, $81, $40, $81, $40, $81, $40, $83, $81, $81, $5B, $83, $8B, $00 ; "　　　　メール"
	db $F9, $B0, $FA, $A6, $CA, $E6, $D2, $D9, $CF, $B4, $C6, $A4, $F9, $B0, $FA, $AF, $10, $C3, $C5, $DD, $C5, $C9, $B6, $A4, $BE, $C2, $D2, $B2, $BD, $D9, $D6, $A1, $00 ; "<$F9>ｰ<$FA>ｦﾊ<$E6>ﾒﾙﾏｴﾆ､<$F9>ｰ<$FA>ｯ<$10>ﾃﾅﾝﾅﾉｶ､ｾﾂﾒｲｽﾙﾖ｡"
	db $06, $A5, $05, $03, $04, $06, $F9, $B0, $FA, $C4, $B2, $B3, $C9, $CA, $A4, $C3, $E0, $D0, $C9, $D6, $B3, $C5, $10, $D3, $C9, $ED, $A4, $F9, $B0, $FA, $83, $41, $83, $68 ; "<$06>･<$05><$03><$04><$06><$F9>ｰ<$FA>ﾄｲｳﾉﾊ､ﾃ<$E0>ﾐﾉﾖｳﾅ<$10>ﾓﾉ<$ED>､<$F9>ｰ<$FA>アド"
	db $83, $8C, $FD, $A6, $D3, $AF, $C3, $B2, $10, $D9, $C4, $D3, $EA, $C1, $C6, $B5, $B8, $DA, $D9, $DD, $EA, $D6, $A1, $00 ; "レ<$FD>ｦﾓｯﾃｲ<$10>ﾙﾄﾓ<$EA>ﾁﾆｵｸﾚﾙﾝ<$EA>ﾖ｡"
	db $06, $8F, $FF, $03, $02, $06, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $CA, $A4, $F9, $B0, $FA, $C9, $BE, $B6, $B2, $10, $ED, $C9, $21, $E6, $AD, $B3, $BC, $AE ; "<$06><$8F><$FF><$03><$02><$06><$F9>ｰ<$FA>アドレ<$FD>ﾊ､<$F9>ｰ<$FA>ﾉｾｶｲ<$10><$ED>ﾉ!<$E6>ｭｳｼｮ"
	db $20, $C9, $BA, $C4, $C5, $DD, $EA, $D6, $A1, $00 ; " ﾉｺﾄﾅﾝ<$EA>ﾖ｡"

; ---- data $4C5F-$4C9D (62 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4C5F:: ; 6C:4C5F
	db $06, $9A, $FF, $03, $03, $06, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD
	db $E0, $B1, $DA, $EF, $A4, $C4, $D3, $EA, $C1, $10, $C9, $83, $51, $B0, $83, $80
	db $83, $7B, $B0, $83, $43, $83, $4A, $83, $89, $B0, $D4, $A4, $B5, $B3, $C1, $C9
	db $10, $CB, $C4, $C9, $83, $70, $83, $5C, $83, $52, $FF, $C6, $A4, $00

; ---- text $4C9D-$4CDE (65 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4C9D:: ; 6C:4C9D
	db $06, $96, $FF, $03, $05, $06, $B5, $C5, $E6, $D6, $B3, $C6, $A4, $F9, $B0, $FA, $A6, $B5, $B8, $D9, $BA, $C4, $10, $E0, $ED, $B7, $D9, $DD, $EA, $81, $49, $00 ; "<$06><$96><$FF><$03><$05><$06>ｵﾅ<$E6>ﾖｳﾆ､<$F9>ｰ<$FA>ｦｵｸﾙｺﾄ<$10><$E0><$ED>ｷﾙﾝ<$EA>！"
	db $06, $A2, $FF, $03, $05, $06, $BF, $DA, $E6, $AC, $B1, $A4, $F9, $B0, $FA, $C9, $B6, $B7, $B6, $C0, $A6, $BE, $10, $C2, $D2, $B2, $BC, $C3, $B2, $B8, $D6, $A1, $00 ; "<$06>｢<$FF><$03><$05><$06>ｿﾚ<$E6>ｬｱ､<$F9>ｰ<$FA>ﾉｶｷｶﾀｦｾ<$10>ﾂﾒｲｼﾃｲｸﾖ｡"

; ---- data $4CDE-$4D2E (80 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4CDE:: ; 6C:4CDE
	db $06, $BF, $FF, $03, $05, $07, $CF, $E7, $CA, $21, $81, $79, $F9, $B0, $FA, $A6
	db $B6, $B8, $81, $7A, $20, $A6, $B5, $BD, $DD, $EA, $10, $D6, $A1, $00, $06, $C1
	db $FF, $03, $02, $08, $CA, $E6, $D2, $C6, $F9, $B0, $FA, $A6, $B5, $B8, $D9, $C4
	db $D3, $EA, $C1, $C9, $10, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $C4
	db $A4, $83, $5E, $83, $43, $83, $67, $FA, $A6, $B6, $B8, $10, $DD, $EA, $A1, $00

; ---- text $4D2E-$4DDC (174 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4D2E:: ; 6C:4D2E
	db $06, $B0, $FF, $03, $03, $08, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $C6, $10, $83, $5A, $B0, $83, $75 ; "<$06>ｰ<$FF><$03><$03><$08><$F9>ｰ<$FA>アドレ<$FD>ｦアドレ<$FD>ﾁｮｳﾆ<$10>セｰブ"
	db $BC, $C3, $B5, $B8, $C4, $A4, $F9, $B0, $FA, $A6, $B6, $B8, $C4, $10, $B7, $C6, $A4, $C4, $AF, $C3, $D3, $F2, $DD, $D8, $EA, $D6, $A1, $00 ; "ｼﾃｵｸﾄ､<$F9>ｰ<$FA>ｦｶｸﾄ<$10>ｷﾆ､ﾄｯﾃﾓ<$F2>ﾝﾘ<$EA>ﾖ｡"
	db $06, $90, $FF, $03, $02, $09, $83, $5E, $83, $43, $83, $67, $FA, $A6, $B6, $B2, $C0, $B1, $C4, $CA, $A4, $F9, $B0, $FA, $C9, $10, $CE, $DD, $F1, $DD, $A6, $B6, $BA, $B3 ; "<$06><$90><$FF><$03><$02><$09>タイト<$FA>ｦｶｲﾀｱﾄﾊ､<$F9>ｰ<$FA>ﾉ<$10>ﾎﾝ<$F1>ﾝｦｶｺｳ"
	db $A1, $00 ; "｡"
	db $06, $9E, $FF, $03, $03, $09, $CE, $DD, $F1, $DD, $E0, $B6, $B9, $C0, $D7, $A4, $CF, $C1, $E0, $AF, $C3, $B2, $10, $C5, $B2, $B6, $D3, $B3, $B2, $C1, $EE, $D0, $C5, $B5 ; "<$06><$9E><$FF><$03><$03><$09>ﾎﾝ<$F1>ﾝ<$E0>ｶｹﾀﾗ､ﾏﾁ<$E0>ｯﾃｲ<$10>ﾅｲｶﾓｳｲﾁ<$EE>ﾐﾅｵ"
	db $BF, $B3, $A1, $00 ; "ｿｳ｡"
	db $06, $B6, $FF, $03, $03, $09, $C5, $B2, $D6, $B3, $E0, $CF, $C1, $E0, $AF, $C3, $B2, $D9, $C4, $A4, $C2, $C0, $10, $B4, $C0, $B2, $BA, $C4, $D3, $C2, $C0, $DC, $D7, $C5 ; "<$06>ｶ<$FF><$03><$03><$09>ﾅｲﾖｳ<$E0>ﾏﾁ<$E0>ｯﾃｲﾙﾄ､ﾂﾀ<$10>ｴﾀｲｺﾄﾓﾂﾀﾜﾗﾅ"
	db $B2, $D6, $A1, $00 ; "ｲﾖ｡"

; ---- data $4DDC-$4E03 (39 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4DDC:: ; 6C:4DDC
	db $06, $B4, $FF, $03, $02, $0A, $F9, $B0, $FA, $E0, $B6, $B9, $C0, $D7, $A4, $81
	db $79, $82, $6E, $82, $6A, $81, $7A, $C9, $83, $41, $83, $43, $10, $83, $52, $FF
	db $A6, $B5, $BC, $C3, $C8, $A1, $00

; ---- text $4E03-$4F12 (271 bytes) [PROBABLE] text: 5 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4E03:: ; 6C:4E03
	db $06, $B3, $FF, $03, $03, $0A, $B2, $CF, $B6, $B2, $C0, $F9, $B0, $FA, $A6, $A4, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $10, $C6, $83, $5A, $B0, $83, $75, $BC ; "<$06>ｳ<$FF><$03><$03><$0A>ｲﾏｶｲﾀ<$F9>ｰ<$FA>ｦ､カｰトリ<$FE>ジ<$10>ﾆセｰブｼ"
	db $C3, $A4, $F9, $B0, $FA, $A6, $B5, $B8, $D9, $E6, $AD, $10, $DD, $F0, $A6, $BD, $D9, $D6, $A1, $00 ; "ﾃ､<$F9>ｰ<$FA>ｦｵｸﾙ<$E6>ｭ<$10>ﾝ<$F0>ｦｽﾙﾖ｡"
	db $06, $A3, $FF, $03, $05, $0B, $F9, $B0, $FA, $A6, $83, $5A, $B0, $83, $75, $BC, $C0, $D7, $A4, $C4, $D3, $EA, $C1, $C6, $10, $B5, $B8, $DB, $B3, $81, $49, $40, $1E, $21 ; "<$06>｣<$FF><$03><$05><$0B><$F9>ｰ<$FA>ｦセｰブｼﾀﾗ､ﾄﾓ<$EA>ﾁﾆ<$10>ｵｸﾛｳ！@<$1E>!"
	db $81, $79, $B5, $B8, $D9, $81, $5E, $B3, $B9, $C4, $D9, $81, $7A, $A6, $10, $B5, $BD, $C4, $A4, $F9, $B0, $FA, $A6, $B5, $B8, $DA, $D9, $20, $DD, $EA, $D6, $A1, $00 ; "【ｵｸﾙ／ｳｹﾄﾙ】ｦ<$10>ｵｽﾄ､<$F9>ｰ<$FA>ｦｵｸﾚﾙ ﾝ<$EA>ﾖ｡"
	db $06, $87, $FF, $03, $02, $0C, $F9, $B0, $FA, $A6, $B5, $B8, $D9, $C4, $B2, $AF, $BC, $AE, $C6, $A4, $83, $4C, $83, $7E, $10, $C6, $C4, $EE, $B2, $C0, $F9, $B0, $FA, $D3 ; "<$06><$87><$FF><$03><$02><$0C><$F9>ｰ<$FA>ｦｵｸﾙﾄｲｯｼｮﾆ､キミ<$10>ﾆﾄ<$EE>ｲﾀ<$F9>ｰ<$FA>ﾓ"
	db $B3, $B9, $C4, $AF, $C3, $B8, $D9, $10, $D6, $A1, $00 ; "ｳｹﾄｯﾃｸﾙ<$10>ﾖ｡"
	db $06, $90, $FF, $03, $05, $0C, $F9, $B0, $FA, $E0, $C4, $EE, $B2, $C3, $B2, $D9, $B6, $83, $60, $83, $46, $FE, $83, $4E, $BD, $10, $D9, $EA, $B9, $C9, $C4, $B7, $D3, $A4 ; "<$06><$90><$FF><$03><$05><$0C><$F9>ｰ<$FA><$E0>ﾄ<$EE>ｲﾃｲﾙｶチェ<$FE>クｽ<$10>ﾙ<$EA>ｹﾉﾄｷﾓ､"
	db $81, $79, $B5, $B8, $D9, $81, $5E, $B3, $B9, $C4, $10, $D9, $81, $7A, $A6, $B5, $BE, $EF, $B2, $B2, $DD, $EA, $D6, $A1, $00 ; "【ｵｸﾙ／ｳｹﾄ<$10>ﾙ】ｦｵｾ<$EF>ｲｲﾝ<$EA>ﾖ｡"
	db $06, $98, $FF, $03, $03, $0C, $BF, $DA, $B6, $D7, $81, $79, $B5, $B8, $D9, $81, $5E, $B3, $B9, $C4, $D9, $81, $7A, $C6, $CA, $10, $21, $B5, $B6, $C8, $E0, $B6, $B6, $D9 ; "<$06><$98><$FF><$03><$03><$0C>ｿﾚｶﾗ【ｵｸﾙ／ｳｹﾄﾙ】ﾆﾊ<$10>!ｵｶﾈ<$E0>ｶｶﾙ"
	db $20, $B6, $D7, $B7, $A6, $C2, $B9, $C3, $C8, $A1, $10, $00 ; " ｶﾗｷｦﾂｹﾃﾈ｡<$10>"

; ---- data $4F12-$4F4C (58 bytes) [CONFIRMED] read as data by executed code (in up to 5/18 scenarios); content class unknown [clipped from 483E-5175 by higher-priority evidence]

Data_6C_4F12:: ; 6C:4F12
	db $06, $97, $FF, $03, $05, $0D, $83, $4C, $83, $7E, $B1, $C3, $C6, $C4, $EE, $B2
	db $C0, $F9, $B0, $FA, $CA, $81, $79, $F9, $B0, $10, $FA, $83, $7B, $FE, $83, $4E
	db $FD, $81, $7A, $ED, $D0, $D9, $DD, $EA, $D6, $A1, $10, $D6, $D0, $C0, $B2, $F9
	db $B0, $FA, $A6, $B4, $D7, $DD, $ED, $C8, $A1, $00

; ---- text $4F4C-$516F (547 bytes) [PROBABLE] text: 12 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_4F4C:: ; 6C:4F4C
	db $06, $98, $FF, $03, $02, $0E, $C0, $EA, $BC, $A4, $C4, $EE, $B2, $C0, $F9, $B0, $FA, $A6, $C9, $BA, $BC, $C3, $10, $B5, $B9, $D9, $C9, $CA, $A4, $21, $82, $50, $82, $51 ; "<$06><$98><$FF><$03><$02><$0E>ﾀ<$EA>ｼ､ﾄ<$EE>ｲﾀ<$F9>ｰ<$FA>ｦﾉｺｼﾃ<$10>ｵｹﾙﾉﾊ､!１２"
	db $C2, $B3, $CF, $ED, $20, $EA, $D6, $A1, $00 ; "ﾂｳﾏ<$ED> <$EA>ﾖ｡"
	db $06, $9B, $FF, $03, $03, $0E, $82, $50, $82, $51, $C2, $B3, $F9, $B0, $FA, $E0, $C9, $BA, $AF, $C3, $B2, $D9, $C4, $B7, $10, $CA, $A4, $F9, $B0, $FA, $A6, $B3, $B9, $C4 ; "<$06><$9B><$FF><$03><$03><$0E>１２ﾂｳ<$F9>ｰ<$FA><$E0>ﾉｺｯﾃｲﾙﾄｷ<$10>ﾊ､<$F9>ｰ<$FA>ｦｳｹﾄ"
	db $D9, $BA, $C4, $E0, $ED, $B7, $C5, $10, $B2, $DD, $EA, $A1, $00 ; "ﾙｺﾄ<$E0><$ED>ｷﾅ<$10>ｲﾝ<$EA>｡"
	db $06, $A6, $FF, $03, $02, $0E, $EA, $B6, $D7, $A4, $21, $D6, $D0, $B5, $DC, $AF, $C0, $F9, $B0, $FA, $CA, $A4, $BA, $10, $CF, $D2, $C6, $BD, $C3, $C0, $CE, $B3, $E0, $B2 ; "<$06>ｦ<$FF><$03><$02><$0E><$EA>ｶﾗ､!ﾖﾐｵﾜｯﾀ<$F9>ｰ<$FA>ﾊ､ｺ<$10>ﾏﾒﾆｽﾃﾀﾎｳ<$E0>ｲ"
	db $B2, $20, $DD, $EA, $D6, $A1, $00 ; "ｲ ﾝ<$EA>ﾖ｡"
	db $06, $A8, $FF, $03, $05, $0E, $BA, $DA, $CA, $C0, $B2, $BE, $C2, $C5, $BA, $C4, $EA, $B6, $D7, $A4, $BC, $AF, $10, $B6, $D8, $B5, $F3, $B4, $C3, $B5, $B2, $C3, $C8 ; "<$06>ｨ<$FF><$03><$05><$0E>ｺﾚﾊﾀｲｾﾂﾅｺﾄ<$EA>ｶﾗ､ｼｯ<$10>ｶﾘｵ<$F3>ｴﾃｵｲﾃﾈ"
	db $81, $49, $00 ; "！"
	db $06, $B3, $FF, $03, $02, $1F, $BF, $DA, $B6, $D7, $A4, $BA, $C9, $83, $4A, $B0, $83, $67, $83, $8A, $FE, $83, $57, $ED, $CA, $A4, $10, $F9, $B0, $FA, $83, $54, $B0 ; "<$06>ｳ<$FF><$03><$02><$1F>ｿﾚｶﾗ､ｺﾉカｰトリ<$FE>ジ<$ED>ﾊ､<$10><$F9>ｰ<$FA>サｰ"
	db $83, $6F, $C9, $BE, $B2, $D8, $E0, $ED, $B7, $D9, $DD, $EA, $10, $D6, $A1, $00 ; "バﾉｾｲﾘ<$E0><$ED>ｷﾙﾝ<$EA><$10>ﾖ｡"
	db $06, $AB, $FF, $03, $02, $1F, $F9, $FB, $83, $85, $B0, $B6, $D7, $A4, $81, $79, $F9, $B0, $FA, $83, $54, $B0, $83, $6F, $81, $7A, $A6, $10, $B4, $D7, $F1, $C4, $A4 ; "<$06>ｫ<$FF><$03><$02><$1F><$F9><$FB>ュｰｶﾗ､【<$F9>ｰ<$FA>サｰバ】ｦ<$10>ｴﾗ<$F1>ﾄ､"
	db $83, $54, $B0, $83, $6F, $C9, $F9, $B0, $FA, $A6, $B9, $BC, $C3, $10, $BE, $B2, $D8, $ED, $B7, $D9, $DD, $EA, $D6, $A1, $00 ; "サｰバﾉ<$F9>ｰ<$FA>ｦｹｼﾃ<$10>ｾｲﾘ<$ED>ｷﾙﾝ<$EA>ﾖ｡"
	db $06, $95, $FF, $03, $02, $1F, $F9, $B0, $FA, $83, $54, $B0, $83, $6F, $C9, $BE, $B2, $D8, $A6, $BC, $C5, $B2, $C4, $A4, $10, $21, $C2, $B3, $BC, $DD, $E6, $B6, $DD, $E0 ; "<$06><$95><$FF><$03><$02><$1F><$F9>ｰ<$FA>サｰバﾉｾｲﾘｦｼﾅｲﾄ､<$10>!ﾂｳｼﾝ<$E6>ｶﾝ<$E0>"
	db $C5, $E0, $B8, $C5, $AF, $C3, $BC, $CF, $10, $B3, $BA, $C4, $E0, $B1, $D9, $20, $DD, $EA, $A1, $00 ; "ﾅ<$E0>ｸﾅｯﾃｼﾏ<$10>ｳｺﾄ<$E0>ｱﾙ ﾝ<$EA>｡"
	db $06, $90, $FF, $03, $02, $1F, $C0, $EA, $BC, $A4, $21, $B7, $B4, $C3, $BC, $CF, $AF, $C0, $F9, $B0, $FA, $CA, $A4, $10, $D3, $C4, $C6, $D3, $EE, $D7, $C5, $B2, $20, $B6 ; "<$06><$90><$FF><$03><$02><$1F>ﾀ<$EA>ｼ､!ｷｴﾃｼﾏｯﾀ<$F9>ｰ<$FA>ﾊ､<$10>ﾓﾄﾆﾓ<$EE>ﾗﾅｲ ｶ"
	db $D7, $A4, $B7, $A6, $C2, $B9, $C3, $10, $C8, $A1, $00 ; "ﾗ､ｷｦﾂｹﾃ<$10>ﾈ｡"
	db $06, $9D, $FF, $03, $03, $0F, $F9, $B0, $FA, $A6, $C2, $B6, $B3, $C4, $A4, $C4, $D3, $EA, $C1, $C4, $C9, $DA, $10, $DD, $D7, $B8, $D4, $A4, $E6, $AE, $B3, $CE, $B3, $BA ; "<$06><$9D><$FF><$03><$03><$0F><$F9>ｰ<$FA>ｦﾂｶｳﾄ､ﾄﾓ<$EA>ﾁﾄﾉﾚ<$10>ﾝﾗｸﾔ､<$E6>ｮｳﾎｳｺ"
	db $B3, $B6, $DD, $A6, $BD, $10, $D9, $BA, $C4, $D3, $ED, $B7, $D9, $DD, $EA, $A1, $00 ; "ｳｶﾝｦｽ<$10>ﾙｺﾄﾓ<$ED>ｷﾙﾝ<$EA>｡"
	db $06, $A0, $FF, $03, $02, $0F, $83, $43, $FF, $83, $5E, $B0, $83, $6C, $FE, $83, $67, $C9, $BE, $B6, $B2, $ED, $A4, $B1, $C0, $D7, $10, $BC, $B2, $C4, $D3, $EA, $C1, $C4 ; "<$06><$A0><$FF><$03><$02><$0F>イ<$FF>タｰネ<$FE>トﾉｾｶｲ<$ED>､ｱﾀﾗ<$10>ｼｲﾄﾓ<$EA>ﾁﾄ"
	db $ED, $B1, $B4, $D9, $B6, $D3, $BC, $DA, $C5, $10, $B2, $D6, $A1, $00 ; "<$ED>ｱｴﾙｶﾓｼﾚﾅ<$10>ｲﾖ｡"
	db $06, $9D, $FF, $03, $03, $0F, $C1, $C5, $D0, $C6, $F9, $B0, $FA, $A6, $B5, $B8, $D8, $B1, $B3, $C4, $D3, $EA, $10, $C1, $C9, $BA, $C4, $A6, $A2, $F9, $FA, $C4, $D3, $A3 ; "<$06><$9D><$FF><$03><$03><$0F>ﾁﾅﾐﾆ<$F9>ｰ<$FA>ｦｵｸﾘｱｳﾄﾓ<$EA><$10>ﾁﾉｺﾄｦ｢<$F9><$FA>ﾄﾓ｣"
	db $C4, $B2, $B3, $DD, $EA, $10, $D6, $A1, $00 ; "ﾄｲｳﾝ<$EA><$10>ﾖ｡"
	db $06, $A5, $FF, $03, $02, $0F, $B2, $AF, $F4, $B2, $B1, $BF, $DD, $ED, $A4, $F9, $FA, $C4, $D3, $A6, $C0, $B8, $10, $BB, $DD, $C2, $B8, $AF, $C3, $C8, $A1, $00 ; "<$06>･<$FF><$03><$02><$0F>ｲｯ<$F4>ｲｱｿﾝ<$ED>､<$F9><$FA>ﾄﾓｦﾀｸ<$10>ｻﾝﾂｸｯﾃﾈ｡"

; ---- data $516F-$5177 (8 bytes) [PROBABLE] message-record header 06 B5 FF 18 00 09 2A 00 (06 xx FF = record header as in the other bank-6C script records) preceding the string at 5177; first 6 bytes read in up to 5 scenarios, the 2-byte hole 5175 is its tail

Data_6C_516F:: ; 6C:516F
	db $06, $B5, $FF, $18, $00, $09, $2A, $00

; ---- text $5177-$519E (39 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_5177:: ; 6C:5177
	db $03, $04, $0F, $BB, $B2, $E4, $C6, $A4, $F9, $B0, $FA, $C6, $B6, $B6, $DA, $D9, $83, $4C, $83, $7E, $C9, $10, $FB, $FE, $83, $4E, $83, $6C, $B0, $83, $80, $A6, $B5, $BC ; "<$03><$04><$0F>ｻｲ<$E4>ﾆ､<$F9>ｰ<$FA>ﾆｶｶﾚﾙキミﾉ<$10><$FB><$FE>クネｰムｦｵｼ"
	db $B4, $C3, $C8, $A1, $00 ; "ｴﾃﾈ｡"

; ---- data $519E-$51B1 (19 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 5177-5216 by higher-priority evidence]

Data_6C_519E:: ; 6C:519E
	db $06, $B1, $FF, $06, $22, $07, $10, $02, $01, $04, $1C, $07, $08, $80, $02, $03
	db $01, $10, $30

; ---- text $51B1-$5213 (98 bytes) [PROBABLE] text: 3 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_51B1:: ; 6C:51B1
	db $81, $40, $81, $40, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $BF, $82, $E5, $82, $A4, $00 ; "　　アドレスちょう"
	db $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $C6, $C2, $B2, $C3, $A4, $BE, $C2, $D2, $B2, $10, $BD, $D9, $D6, $A1, $00 ; "アドレ<$FD>ﾁｮｳﾆﾂｲﾃ､ｾﾂﾒｲ<$10>ｽﾙﾖ｡"
	db $06, $4A, $02, $03, $02, $10, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $E0, $A4, $C4, $D3, $EA, $C1, $C9, $E6, $AD, $10, $B3, $BC, $AE, $C9, $D6, $B3, $C5, $D3 ; "<$06>J<$02><$03><$02><$10><$F9>ｰ<$FA>アドレ<$FD><$E0>､ﾄﾓ<$EA>ﾁﾉ<$E6>ｭ<$10>ｳｼｮﾉﾖｳﾅﾓ"
	db $C9, $EA, $C4, $B2, $B3, $BA, $C4, $CA, $10, $CF, $B4, $C6, $CA, $C5, $BC, $C0, $D6, $C8, $A1, $00 ; "ﾉ<$EA>ﾄｲｳｺﾄﾊ<$10>ﾏｴﾆﾊﾅｼﾀﾖﾈ｡"

; ---- data $5213-$5216 (3 bytes) [CONFIRMED] read as data by executed code (in up to 8/18 scenarios); content class unknown [clipped from 5177-5216 by higher-priority evidence]

Data_6C_5213:: ; 6C:5213
	db $06, $97, $FF

; ---- text $5216-$5236 (32 bytes) [PROBABLE] body of the record whose header 06 97 FF was read at 5213-5216 (executed); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_5216:: ; 6C:5216
	db $03, $03, $10, $ED, $D3, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $B5, $F3, $B4, $D9, $C9, $CA, $10, $C0, $B2, $CD, $DD, $EA, $D6, $C8, $A1, $00 ; "<$03><$03><$10><$ED>ﾓ<$F9>ｰ<$FA>アドレ<$FD>ｦｵ<$F3>ｴﾙﾉﾊ<$10>ﾀｲﾍﾝ<$EA>ﾖﾈ｡"

; ---- text $5236-$52B2 (124 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_5236:: ; 6C:5236
	db $06, $A7, $FF, $03, $04, $10, $BF, $DD, $C5, $C4, $B7, $C6, $CA, $A4, $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $C6, $21, $10, $F9, $B0, $FA, $83, $41, $83, $68 ; "<$06>ｧ<$FF><$03><$04><$10>ｿﾝﾅﾄｷﾆﾊ､アドレ<$FD>ﾁｮｳﾆ!<$10><$F9>ｰ<$FA>アド"
	db $83, $8C, $FD, $A6, $83, $5A, $B0, $83, $75, $20, $BC, $C3, $B5, $B8, $C4, $10, $B2, $B2, $DD, $EA, $D6, $A1, $00 ; "レ<$FD>ｦセｰブ ｼﾃｵｸﾄ<$10>ｲｲﾝ<$EA>ﾖ｡"
	db $06, $A4, $FF, $03, $02, $11, $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $E0, $D2, $DD, $ED, $A4, $83, $5A, $B0, $83, $75, $BD, $10, $D9, $EF, $BC, $AE, $A6, $B4 ; "<$06>､<$FF><$03><$02><$11>アドレ<$FD>ﾁｮｳ<$E0>ﾒﾝ<$ED>､セｰブｽ<$10>ﾙ<$EF>ｼｮｦｴ"
	db $D7, $DD, $EA, $B1, $C4, $C6, $A4, $21, $81, $79, $B6, $B7, $10, $BA, $D1, $81, $7A, $20, $C9, $83, $41, $83, $43, $83, $52, $FF, $A6, $B5, $BC, $C3, $C8, $A1, $00 ; "ﾗﾝ<$EA>ｱﾄﾆ､!【ｶｷ<$10>ｺﾑ】 ﾉアイコ<$FF>ｦｵｼﾃﾈ｡"

; ---- text $52B2-$52E3 (49 bytes) [PROBABLE] one record (06 84 FF 03 03 11 ... 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_52B2:: ; 6C:52B2
	db $06, $84, $FF, $03, $03, $11, $C6, $AD, $B3, $D8, $AE, $B8, $E0, $D2, $DD, $E0, $ED, $C0, $D7, $A4, $FB, $FE, $10, $83, $4E, $83, $6C, $B0, $83, $80, $C4, $F9, $B0, $FA ; "<$06><$84><$FF><$03><$03><$11>ﾆｭｳﾘｮｸ<$E0>ﾒﾝ<$E0><$ED>ﾀﾗ､<$FB><$FE><$10>クネｰムﾄ<$F9>ｰ<$FA>"
	db $83, $41, $83, $68, $83, $8C, $FD, $A6, $B6, $B2, $C3, $10, $C8, $A1, $00 ; "アドレ<$FD>ｦｶｲﾃ<$10>ﾈ｡"

; ---- text $52E3-$533A (87 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_52E3:: ; 6C:52E3
	db $06, $8C, $FF, $03, $03, $12, $B6, $B7, $B5, $DC, $AF, $C0, $D7, $A4, $81, $79, $82, $6E, $82, $6A, $81, $7A, $A6, $B5, $BC, $C3, $10, $83, $5A, $B0, $83, $75, $BC, $D6 ; "<$06><$8C><$FF><$03><$03><$12>ｶｷｵﾜｯﾀﾗ､【ＯＫ】ｦｵｼﾃ<$10>セｰブｼﾖ"
	db $B3, $A1, $00 ; "ｳ｡"
	db $06, $AA, $FF, $03, $05, $12, $CF, $B4, $C6, $B6, $B2, $C0, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $CD, $DD, $10, $BA, $B3, $BC, $C0, $D8, $A4, $B9, $BC ; "<$06>ｪ<$FF><$03><$05><$12>ﾏｴﾆｶｲﾀ<$F9>ｰ<$FA>アドレ<$FD>ｦﾍﾝ<$10>ｺｳｼﾀﾘ､ｹｼ"
	db $C0, $D8, $BD, $D9, $BA, $C4, $D3, $ED, $10, $B7, $D9, $DD, $EA, $D6, $A1, $00 ; "ﾀﾘｽﾙｺﾄﾓ<$ED><$10>ｷﾙﾝ<$EA>ﾖ｡"

; ---- text $533A-$53F7 (189 bytes) [PROBABLE] 5 consecutive records (06 A9 FF / 06 9E FF / 06 AF FF / 06 9A FF ...) each ending with 00; second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_533A:: ; 6C:533A
	db $06, $A9, $FF, $03, $02, $13, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $E0, $83, $5A, $B0, $83, $75, $ED, $B7, $C0, $D7, $A4, $10, $83, $41, $83, $68, $83, $8C ; "<$06>ｩ<$FF><$03><$02><$13><$F9>ｰ<$FA>アドレ<$FD><$E0>セｰブ<$ED>ｷﾀﾗ､<$10>アドレ"
	db $FD, $C1, $AE, $B3, $B6, $D7, $B4, $D7, $F1, $EA, $B9, $ED, $A4, $00 ; "<$FD>ﾁｮｳｶﾗｴﾗ<$F1><$EA>ｹ<$ED>､"
	db $06, $9E, $FF, $03, $02, $13, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $A4, $B6, $B8, $BA, $C4, $E0, $ED, $B7, $10, $C1, $AC, $B3, $DD, $EA, $A1, $00 ; "<$06><$9E><$FF><$03><$02><$13><$F9>ｰ<$FA>アドレ<$FD>ｦ､ｶｸｺﾄ<$E0><$ED>ｷ<$10>ﾁｬｳﾝ<$EA>｡"
	db $06, $AF, $FF, $03, $03, $13, $C4, $D3, $EA, $C1, $C9, $F9, $B0, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $B6, $B8, $E0, $10, $D2, $DD, $ED, $A4, $21, $83, $5A ; "<$06>ｯ<$FF><$03><$03><$13>ﾄﾓ<$EA>ﾁﾉ<$F9>ｰ<$FA>アドレ<$FD>ｦｶｸ<$E0><$10>ﾒﾝ<$ED>､!セ"
	db $83, $8C, $83, $4E, $83, $67, $83, $7B, $83, $5E, $FF, $20, $A6, $B5, $BD, $C4, $A4, $10, $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $E0, $ED, $C3, $B8, $D9, $D6 ; "レクトボタ<$FF> ｦｵｽﾄ､<$10>アドレ<$FD>ﾁｮｳ<$E0><$ED>ﾃｸﾙﾖ"
	db $A1, $00 ; "｡"
	db $06, $9A, $FF, $03, $03, $13, $F9, $B0, $FA, $A6, $EA, $BC, $C0, $B2, $C4, $D3, $EA, $C1, $C9, $A4, $F9, $B0, $10, $FA, $83, $41, $83, $68, $83, $8C, $FD, $A6, $B4, $D7 ; "<$06><$9A><$FF><$03><$03><$13><$F9>ｰ<$FA>ｦ<$EA>ｼﾀｲﾄﾓ<$EA>ﾁﾉ､<$F9>ｰ<$10><$FA>アドレ<$FD>ｦｴﾗ"
	db $DD, $ED, $C8, $A1, $00 ; "ﾝ<$ED>ﾈ｡"

; ---- text $53F7-$5427 (48 bytes) [PROBABLE] text: 1 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_53F7:: ; 6C:53F7
	db $06, $94, $FF, $03, $03, $13, $83, $41, $83, $68, $83, $8C, $FD, $C1, $AE, $B3, $A6, $C2, $B6, $B2, $BA, $C5, $BC, $C3, $A4, $10, $F9, $B0, $FA, $BA, $B3, $B6, $DD, $A6 ; "<$06><$94><$FF><$03><$03><$13>アドレ<$FD>ﾁｮｳｦﾂｶｲｺﾅｼﾃ､<$10><$F9>ｰ<$FA>ｺｳｶﾝｦ"
	db $B6, $B2, $C3, $B7, $C6, $C0, $C9, $BC, $10, $DD, $ED, $C8, $A1, $00 ; "ｶｲﾃｷﾆﾀﾉｼ<$10>ﾝ<$ED>ﾈ｡"

; ---- data $5427-$543A (19 bytes) [PROBABLE] control record (not text): 06 A9 FF 06 99 04 10 03 01 04 93 04 08 B8 02 03 01 14 30 = header + command parameters; bytes 542A-543A were read in up to 8 scenarios, the 3 header bytes were the hole

Data_6C_5427:: ; 6C:5427
	db $06, $A9, $FF, $06, $99, $04, $10, $03, $01, $04, $93, $04, $08, $B8, $02, $03
	db $01, $14, $30

; ---- text $543A-$54D3 (153 bytes) [PROBABLE] text: 4 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_543A:: ; 6C:543A
	db $81, $40, $81, $40, $81, $40, $83, $7A, $81, $5B, $83, $80, $83, $79, $81, $5B, $83, $57, $00 ; "　　　ホームページ"
	db $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $ED, $B1, $BF, $F1, $CF, $B4, $C6, $A4, $BD, $BA, $10, $BC, $EA, $B9, $A4, $BE, $C2, $D2, $B2, $BD, $D9, $D6, $A1, $00 ; "ホｰムペｰジ<$ED>ｱｿ<$F1>ﾏｴﾆ､ｽｺ<$10>ｼ<$EA>ｹ､ｾﾂﾒｲｽﾙﾖ｡"
	db $06, $79, $02, $03, $01, $15, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $CA, $A4, $B4, $D4, $D3, $E6, $A6, $C2, $B6, $AF, $10, $C0, $B2, $DB, $DD, $C5, $E6, $AE ; "<$06>y<$02><$03><$01><$15>ホｰムペｰジﾊ､ｴﾔﾓ<$E6>ｦﾂｶｯ<$10>ﾀｲﾛﾝﾅ<$E6>ｮ"
	db $B3, $CE, $B3, $A6, $D0, $D9, $BA, $C4, $E0, $10, $ED, $B7, $D9, $DD, $EA, $A1, $00 ; "ｳﾎｳｦﾐﾙｺﾄ<$E0><$10><$ED>ｷﾙﾝ<$EA>｡"
	db $06, $91, $FF, $03, $03, $15, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $CA, $BE, $B6, $B2, $E6, $AD, $B3, $C6, $C0, $B8, $10, $BB, $DD, $B1, $AF, $C3, $A4, $D0 ; "<$06><$91><$FF><$03><$03><$15>ホｰムペｰジﾊｾｶｲ<$E6>ｭｳﾆﾀｸ<$10>ｻﾝｱｯﾃ､ﾐ"
	db $DD, $C5, $C2, $C5, $E0, $AF, $C3, $B2, $D9, $10, $DD, $EA, $D6, $A1, $00 ; "ﾝﾅﾂﾅ<$E0>ｯﾃｲﾙ<$10>ﾝ<$EA>ﾖ｡"

; ---- text $54D3-$5505 (50 bytes) [PROBABLE] one record (06 9C FF 03 05 16 ... 81 49 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_54D3:: ; 6C:54D3
	db $06, $9C, $FF, $03, $05, $16, $E6, $AC, $B1, $21, $81, $79, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $81, $7A, $20, $A6, $B5, $BC, $C3, $A4, $10, $83, $7A, $B0 ; "<$06><$9C><$FF><$03><$05><$16><$E6>ｬｱ!【ホｰムペｰジ】 ｦｵｼﾃ､<$10>ホｰ"
	db $83, $80, $83, $79, $B0, $83, $57, $A6, $D0, $C3, $D0, $D6, $B3, $81, $49, $00 ; "ムペｰジｦﾐﾃﾐﾖｳ！"

; ---- text $5505-$556B (102 bytes) [PROBABLE] text: 2 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_5505:: ; 6C:5505
	db $06, $9D, $FF, $03, $05, $17, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $D0, $C3, $B2, $C3, $A4, $21, $B1, $B5, $B2, $D3, $10, $E6, $E0, $B1, $AF, $C0, $D7 ; "<$06><$9D><$FF><$03><$05><$17>ホｰムペｰジｦﾐﾃｲﾃ､!ｱｵｲﾓ<$10><$E6><$E0>ｱｯﾀﾗ"
	db $A4, $82, $60, $83, $7B, $83, $5E, $FF, $20, $A6, $B5, $BC, $C3, $D0, $10, $D6, $B3, $A1, $00 ; "､Ａボタ<$FF> ｦｵｼﾃﾐ<$10>ﾖｳ｡"
	db $06, $99, $FF, $03, $05, $17, $BF, $C9, $83, $79, $B0, $83, $57, $C4, $C2, $C5, $E0, $AF, $C3, $B2, $D9, $83, $79, $B0, $83, $57, $10, $C6, $A4, $83, $57, $FC, $FF ; "<$06><$99><$FF><$03><$05><$17>ｿﾉペｰジﾄﾂﾅ<$E0>ｯﾃｲﾙペｰジ<$10>ﾆ､ジ<$FC><$FF>"
	db $83, $76, $BD, $D9, $BA, $C4, $E0, $ED, $B7, $D9, $DD, $EA, $10, $D6, $A1, $00 ; "プｽﾙｺﾄ<$E0><$ED>ｷﾙﾝ<$EA><$10>ﾖ｡"

; ---- text $556B-$5594 (41 bytes) [PROBABLE] one record (06 9A FF 03 05 17 ... 00); second-convention message record (bank 6C script): header 06 xx FF 03 aa bb, text bytes A1-DF/E0-FF singles and SJIS katakana pairs with 10 = line/page code, ends with 00; the record header bytes were not anchored by the mapper text scan, so the record was left unresolved by the mapper; it sits between text runs of the same format (docs/research/text_encoding.md section on the second convention)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_556B:: ; 6C:556B
	db $06, $9A, $FF, $03, $05, $17, $BA, $DA, $A6, $A4, $21, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $E0, $83, $8A, $FF, $83, $4E, $BC, $C3, $10, $B2, $D9, $20, $C4 ; "<$06><$9A><$FF><$03><$05><$17>ｺﾚｦ､!ホｰムペｰジ<$E0>リ<$FF>クｼﾃ<$10>ｲﾙ ﾄ"
	db $B2, $B3, $DD, $EA, $D6, $A1, $00 ; "ｲｳﾝ<$EA>ﾖ｡"

; ---- text $5594-$56E8 (340 bytes) [PROBABLE] text: 7 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_5594:: ; 6C:5594
	db $06, $A6, $FF, $03, $02, $18, $82, $61, $83, $7B, $83, $5E, $FF, $A6, $B5, $BD, $C4, $A4, $CF, $B4, $C9, $83, $79, $B0, $83, $57, $C6, $10, $D3, $EE, $D9, $BA, $C4, $D3 ; "<$06>ｦ<$FF><$03><$02><$18>Ｂボタ<$FF>ｦｵｽﾄ､ﾏｴﾉペｰジﾆ<$10>ﾓ<$EE>ﾙｺﾄﾓ"
	db $ED, $B7, $D9, $DD, $EA, $D6, $A1, $00 ; "<$ED>ｷﾙﾝ<$EA>ﾖ｡"
	db $06, $AD, $FF, $03, $02, $19, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $D0, $C3, $B2, $D9, $C4, $B7, $C6, $CA, $A4, $10, $21, $B5, $B6, $C8, $E0, $B6, $B6 ; "<$06>ｭ<$FF><$03><$02><$19>ホｰムペｰジｦﾐﾃｲﾙﾄｷﾆﾊ､<$10>!ｵｶﾈ<$E0>ｶｶ"
	db $D9, $DD, $EA, $A1, $20, $00 ; "ﾙﾝ<$EA>｡ "
	db $06, $AE, $FF, $03, $02, $19, $B1, $CF, $D8, $21, $C5, $E0, $B2, $E6, $B6, $DD, $BE, $C2, $E9, $B8, $BD, $D9, $C9, $CA, $D4, $D2, $D6, $B3, $20, $C8, $A1, $00 ; "<$06>ｮ<$FF><$03><$02><$19>ｱﾏﾘ!ﾅ<$E0>ｲ<$E6>ｶﾝｾﾂ<$E9>ｸｽﾙﾉﾊﾔﾒﾖｳ ﾈ｡"
	db $06, $B8, $FF, $03, $03, $1A, $83, $51, $B0, $83, $80, $83, $5C, $83, $74, $83, $67, $C9, $FB, $83, $85, $B0, $FD, $D4, $A4, $B5, $D3, $BC, $10, $DB, $B2, $E6, $AE, $B3 ; "<$06>ｸ<$FF><$03><$03><$1A>ゲｰムソフトﾉ<$FB>ュｰ<$FD>ﾔ､ｵﾓｼ<$10>ﾛｲ<$E6>ｮｳ"
	db $CE, $B3, $A6, $A4, $B2, $C2, $ED, $D3, $EE, $BA, $ED, $10, $D3, $D0, $D9, $BA, $C4, $E0, $ED, $B7, $D9, $DD, $EA, $D6, $A1, $00 ; "ﾎｳｦ､ｲﾂ<$ED>ﾓ<$EE>ｺ<$ED><$10>ﾓﾐﾙｺﾄ<$E0><$ED>ｷﾙﾝ<$EA>ﾖ｡"
	db $06, $A4, $FF, $03, $03, $1A, $BF, $DA, $C4, $A4, $C6, $DD, $C3, $DD, $EE, $B3, $83, $82, $83, $6F, $83, $43, $FA, $83, $7A, $B0, $10, $83, $80, $83, $79, $B0, $83, $57 ; "<$06>､<$FF><$03><$03><$1A>ｿﾚﾄ､ﾆﾝﾃﾝ<$EE>ｳモバイ<$FA>ホｰ<$10>ムペｰジ"
	db $C6, $CA, $A4, $C0, $B2, $BE, $C2, $C5, $B5, $BC, $D7, $BE, $10, $E0, $B1, $D9, $C9, $ED, $A4, $D0, $C6, $B7, $C3, $C8, $A1, $00 ; "ﾆﾊ､ﾀｲｾﾂﾅｵｼﾗｾ<$10><$E0>ｱﾙﾉ<$ED>､ﾐﾆｷﾃﾈ｡"
	db $06, $88, $FF, $03, $03, $1A, $83, $4C, $83, $7E, $CA, $EE, $DD, $C5, $E6, $AE, $B3, $CE, $B3, $E0, $D0, $C0, $B2, $C9, $10, $B6, $C5, $81, $48, $83, $7A, $B0, $83, $80 ; "<$06><$88><$FF><$03><$03><$1A>キミﾊ<$EE>ﾝﾅ<$E6>ｮｳﾎｳ<$E0>ﾐﾀｲﾉ<$10>ｶﾅ？ホｰム"
	db $83, $79, $B0, $83, $57, $C6, $CA, $A4, $B7, $D0, $C9, $BC, $10, $D7, $C5, $B2, $E6, $AE, $B3, $CE, $B3, $E0, $B2, $AF, $F4, $B2, $EA, $D6, $A1, $00 ; "ペｰジﾆﾊ､ｷﾐﾉｼ<$10>ﾗﾅｲ<$E6>ｮｳﾎｳ<$E0>ｲｯ<$F4>ｲ<$EA>ﾖ｡"
	db $06, $84, $FF, $03, $03, $1A, $BB, $B2, $BC, $DD, $C9, $FB, $83, $85, $B0, $FD, $A6, $D0, $C2, $B9, $C0, $D7, $A4, $10, $C4, $D3, $EA, $C1, $C6, $E6, $CF, $DD, $BC, $C1 ; "<$06><$84><$FF><$03><$03><$1A>ｻｲｼﾝﾉ<$FB>ュｰ<$FD>ｦﾐﾂｹﾀﾗ､<$10>ﾄﾓ<$EA>ﾁﾆ<$E6>ﾏﾝｼﾁ"
	db $AC, $B5, $B3, $81, $49, $81, $49, $00 ; "ｬｵｳ！！"

; ---- data $56E8-$56FB (19 bytes) [PROBABLE] control record (not text): 06 96 FF 06 D8 01 10 04 01 04 D2 01 08 C9 01 03 01 1B 30 (header + parameters), mid part read in 1 scenario

Data_6C_56E8:: ; 6C:56E8
	db $06, $96, $FF, $06, $D8, $01, $10, $04, $01, $04, $D2, $01, $08, $C9, $01, $03
	db $01, $1B, $30

; ---- text $56FB-$58BA (447 bytes) [PROBABLE] text: 9 string(s) of analysis/strings.tsv (bank 6C uses the second, only PROBABLE text convention of docs/research/text_encoding.md, NUL terminated)
; text comments (halfwidth): display only, A1-DF shown as half-width katakana, glyphs unproven (text_encoding.md section 6)

String_6C_56FB:: ; 6C:56FB
	db $81, $40, $81, $40, $81, $40, $83, $79, $81, $5B, $83, $57, $83, $8A, $83, $58, $83, $67, $00 ; "　　　ページリスト"
	db $83, $79, $B0, $83, $57, $83, $8A, $FD, $83, $67, $C6, $C2, $B2, $C3, $A4, $BE, $C2, $D2, $B2, $BD, $10, $D9, $D6, $A1, $00 ; "ペｰジリ<$FD>トﾆﾂｲﾃ､ｾﾂﾒｲｽ<$10>ﾙﾖ｡"
	db $06, $93, $01, $03, $01, $1B, $B5, $B7, $C6, $B2, $D8, $C9, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $A4, $D0, $D9, $10, $C4, $B7, $C6, $A4, $C0, $B8, $BB ; "<$06><$93><$01><$03><$01><$1B>ｵｷﾆｲﾘﾉホｰムペｰジｦ､ﾐﾙ<$10>ﾄｷﾆ､ﾀｸｻ"
	db $DD, $83, $8A, $FF, $83, $4E, $A6, $83, $57, $FC, $FF, $83, $76, $10, $BD, $D9, $C9, $CA, $D2, $DD, $EE, $B3, $EA, $D6, $C8, $A1, $00 ; "ﾝリ<$FF>クｦジ<$FC><$FF>プ<$10>ｽﾙﾉﾊﾒﾝ<$EE>ｳ<$EA>ﾖﾈ｡"
	db $06, $90, $FF, $03, $03, $1B, $BF, $DD, $C5, $C4, $B7, $CA, $A4, $21, $83, $79, $B0, $83, $57, $83, $8A, $FD, $83, $67, $C6, $83, $5A, $B0, $10, $83, $75, $BC, $C3, $B5 ; "<$06><$90><$FF><$03><$03><$1B>ｿﾝﾅﾄｷﾊ､!ペｰジリ<$FD>トﾆセｰ<$10>ブｼﾃｵ"
	db $B8, $C4, $F2, $DD, $D8, $20, $C5, $DD, $EA, $A1, $00 ; "ｸﾄ<$F2>ﾝﾘ ﾅﾝ<$EA>｡"
	db $06, $96, $FF, $03, $03, $1C, $B5, $B7, $C6, $B2, $D8, $C9, $83, $79, $B0, $83, $57, $A6, $D0, $C2, $B9, $C0, $D7, $A4, $10, $83, $79, $B0, $83, $57, $83, $8A, $FD ; "<$06><$96><$FF><$03><$03><$1C>ｵｷﾆｲﾘﾉペｰジｦﾐﾂｹﾀﾗ､<$10>ペｰジリ<$FD>"
	db $83, $67, $C9, $E0, $D2, $DD, $C6, $BD, $BD, $DD, $ED, $A4, $10, $83, $5A, $B0, $83, $75, $BC, $C0, $B2, $EF, $BC, $AE, $A6, $B4, $D7, $DD, $ED, $C8, $A1, $00 ; "トﾉ<$E0>ﾒﾝﾆｽｽﾝ<$ED>､<$10>セｰブｼﾀｲ<$EF>ｼｮｦｴﾗﾝ<$ED>ﾈ｡"
	db $06, $92, $FF, $03, $02, $1C, $BF, $C9, $B1, $C4, $C6, $A4, $21, $81, $79, $83, $5A, $B0, $83, $75, $81, $7A, $20, $A6, $B4, $D7, $F1, $C4, $10, $BF, $C9, $83, $7A, $B0 ; "<$06><$92><$FF><$03><$02><$1C>ｿﾉｱﾄﾆ､!【セｰブ】 ｦｴﾗ<$F1>ﾄ<$10>ｿﾉホｰ"
	db $83, $80, $83, $79, $B0, $83, $57, $C9, $EF, $BC, $AE, $A6, $83, $5A, $B0, $83, $75, $10, $ED, $B7, $D9, $DD, $EA, $D6, $A1, $00 ; "ムペｰジﾉ<$EF>ｼｮｦセｰブ<$10><$ED>ｷﾙﾝ<$EA>ﾖ｡"
	db $06, $83, $FF, $03, $02, $1D, $83, $5A, $B0, $83, $75, $BC, $C0, $83, $7A, $B0, $83, $80, $83, $79, $B0, $83, $57, $A6, $D0, $D9, $C6, $CA, $10, $D0, $C0, $B2, $83, $79 ; "<$06><$83><$FF><$03><$02><$1D>セｰブｼﾀホｰムペｰジｦﾐﾙﾆﾊ<$10>ﾐﾀｲペ"
	db $B0, $83, $57, $A6, $B4, $D7, $DD, $ED, $B6, $D7, $21, $81, $79, $83, $57, $FC, $10, $FF, $83, $76, $81, $7A, $20, $A6, $B5, $BD, $DD, $EA, $D6, $A1, $00 ; "ｰジｦｴﾗﾝ<$ED>ｶﾗ!【ジ<$FC><$10><$FF>プ】 ｦｵｽﾝ<$EA>ﾖ｡"
	db $06, $83, $FF, $03, $02, $1D, $C0, $B8, $BB, $DD, $83, $57, $FC, $FF, $83, $76, $BC, $C5, $B2, $C4, $D0, $D7, $DA, $C5, $10, $B2, $83, $79, $B0, $83, $57, $D3, $A4, $BD ; "<$06><$83><$FF><$03><$02><$1D>ﾀｸｻﾝジ<$FC><$FF>プｼﾅｲﾄﾐﾗﾚﾅ<$10>ｲペｰジﾓ､ｽ"
	db $E2, $C6, $D0, $D9, $BA, $C4, $E0, $ED, $B7, $10, $C3, $A4, $21, $E6, $B6, $DD, $C9, $BE, $C2, $D4, $B8, $C6, $C5, $D9, $DD, $EA, $A1, $20, $00 ; "<$E2>ﾆﾐﾙｺﾄ<$E0><$ED>ｷ<$10>ﾃ､!<$E6>ｶﾝﾉｾﾂﾔｸﾆﾅﾙﾝ<$EA>｡ "
	db $06, $80, $FF, $03, $05, $1E, $83, $79, $B0, $83, $57, $83, $8A, $FD, $83, $67, $A6, $B3, $CF, $B8, $C2, $B6, $AF, $C3, $83, $7A, $B0, $10, $83, $80, $83, $79, $B0 ; "<$06><$80><$FF><$03><$05><$1E>ペｰジリ<$FD>トｦｳﾏｸﾂｶｯﾃホｰ<$10>ムペｰ"
	db $83, $57, $A6, $C0, $C9, $BC, $DD, $ED, $C8, $A1, $00 ; "ジｦﾀﾉｼﾝ<$ED>ﾈ｡"

; ---- data $58BA-$5987 (205 bytes) [PROBABLE] control header 06 95 FF 06 06 00 10 05 01 04 followed by Shift-JIS kana character tables (81 42 81 75 ..., hiragana 82 F0 82 9F ..., dakuten set, katakana 83 81 83 8B ...) = the character grid of the text-entry screen; mostly read in up to 12 scenarios, holes are unread bytes of the same tables

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
