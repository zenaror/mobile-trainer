; data/fonts/font_8x16.asm
; bank 48, $4ADB-$5DCB (4848 bytes); pinned by layout.link
; 303 glyphs of the 8x16 1bpp font (27 runs)

SECTION "data/fonts/font_8x16", ROMX

; ---- gfx $4ADB-$4B7B (160 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $824F (record of Font_GlyphRunTable; 10 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_824F:: ; 48:4ADB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_824f.1bpp"

; ---- gfx $4B7B-$4D1B (416 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8260 (record of Font_GlyphRunTable; 26 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8260:: ; 48:4B7B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8260.1bpp"

; ---- gfx $4D1B-$4EBB (416 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8281 (record of Font_GlyphRunTable; 26 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8281:: ; 48:4D1B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8281.1bpp"

; ---- gfx $4EBB-$53EB (1328 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $829F (record of Font_GlyphRunTable; 83 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_829F:: ; 48:4EBB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_829f.1bpp"

; ---- gfx $53EB-$593B (1360 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8340 (record of Font_GlyphRunTable; 85 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8340:: ; 48:53EB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8340.1bpp"

; ---- gfx $593B-$59FB (192 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8140 (record of Font_GlyphRunTable; 12 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8140:: ; 48:593B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8140.1bpp"

; ---- gfx $59FB-$5A2B (48 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $814F (record of Font_GlyphRunTable; 3 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_814F:: ; 48:59FB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_814f.1bpp"

; ---- gfx $5A2B-$5A3B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $815E (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_815E:: ; 48:5A2B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_815e.1bpp"

; ---- gfx $5A3B-$5A4B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8160 (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8160:: ; 48:5A3B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8160.1bpp"

; ---- gfx $5A4B-$5A6B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8162 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8162:: ; 48:5A4B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8162.1bpp"

; ---- gfx $5A6B-$5A8B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8165 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8165:: ; 48:5A6B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8165.1bpp"

; ---- gfx $5A8B-$5A9B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8168 (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8168:: ; 48:5A8B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8168.1bpp"

; ---- gfx $5A9B-$5ABB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8169 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8169:: ; 48:5A9B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8169.1bpp"

; ---- gfx $5ABB-$5AFB (64 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $816D (record of Font_GlyphRunTable; 4 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_816D:: ; 48:5ABB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_816d.1bpp"

; ---- gfx $5AFB-$5B7B (128 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8175 (record of Font_GlyphRunTable; 8 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8175:: ; 48:5AFB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8175.1bpp"

; ---- gfx $5B7B-$5B8B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $817E (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_817E:: ; 48:5B7B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_817e.1bpp"

; ---- gfx $5B8B-$5BAB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8180 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8180:: ; 48:5B8B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8180.1bpp"

; ---- gfx $5BAB-$5BCB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8183 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8183:: ; 48:5BAB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8183.1bpp"

; ---- gfx $5BCB-$5BEB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8189 (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8189:: ; 48:5BCB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8189.1bpp"

; ---- gfx $5BEB-$5C0B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $818F (record of Font_GlyphRunTable; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_818F:: ; 48:5BEB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_818f.1bpp"

; ---- gfx $5C0B-$5C5B (80 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8193 (record of Font_GlyphRunTable; 5 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8193:: ; 48:5C0B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8193.1bpp"

; ---- gfx $5C5B-$5C9B (64 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8199 (record of Font_GlyphRunTable; 4 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8199:: ; 48:5C5B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_8199.1bpp"

; ---- gfx $5C9B-$5CFB (96 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $819E (record of Font_GlyphRunTable; 6 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_819E:: ; 48:5C9B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_819e.1bpp"

; ---- gfx $5CFB-$5D5B (96 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $81A6 (record of Font_GlyphRunTable; 6 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_81A6:: ; 48:5CFB

	INCBIN "data/fonts/glyph_runs_8x16/sjis_81a6.1bpp"

; ---- gfx $5D5B-$5D6B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $81F4 (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_81F4:: ; 48:5D5B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_81f4.1bpp"

; ---- gfx $5D6B-$5D7B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $815B (record of Font_GlyphRunTable; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_815B:: ; 48:5D6B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_815b.1bpp"

; ---- gfx $5D7B-$5DCB (80 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $83BF (record of Font_GlyphRunTable; 5 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_83BF:: ; 48:5D7B

	INCBIN "data/fonts/glyph_runs_8x16/sjis_83bf.1bpp"
