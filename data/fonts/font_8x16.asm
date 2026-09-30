; data/fonts/font_8x16.asm
; bank 48, $4ADB-$5DCB (4848 bytes); pinned by layout.link
; 303 glyphs of the 8x16 1bpp font (27 runs)

SECTION "data/fonts/font_8x16", ROMX

; ---- gfx $4ADB-$4B7B (160 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $824F (record of Table_48_4810; 10 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_824F:: ; 48:4ADB
Font_48_4ADB::
	INCBIN "data/fonts/font_8x16_4adb.1bpp"

; ---- gfx $4B7B-$4D1B (416 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8260 (record of Table_48_4810; 26 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8260:: ; 48:4B7B
Font_48_4B7B::
	INCBIN "data/fonts/font_8x16_4b7b.1bpp"

; ---- gfx $4D1B-$4EBB (416 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8281 (record of Table_48_4810; 26 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8281:: ; 48:4D1B
Font_48_4D1B::
	INCBIN "data/fonts/font_8x16_4d1b.1bpp"

; ---- gfx $4EBB-$53EB (1328 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $829F (record of Table_48_4810; 83 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_829F:: ; 48:4EBB
Font_48_4EBB::
	INCBIN "data/fonts/font_8x16_4ebb.1bpp"

; ---- gfx $53EB-$593B (1360 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8340 (record of Table_48_4810; 85 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8340:: ; 48:53EB
Font_48_53EB::
	INCBIN "data/fonts/font_8x16_53eb.1bpp"

; ---- gfx $593B-$59FB (192 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8140 (record of Table_48_4810; 12 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8140:: ; 48:593B
Font_48_593B::
	INCBIN "data/fonts/font_8x16_593b.1bpp"

; ---- gfx $59FB-$5A2B (48 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $814F (record of Table_48_4810; 3 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_814F:: ; 48:59FB
Font_48_59FB::
	INCBIN "data/fonts/font_8x16_59fb.1bpp"

; ---- gfx $5A2B-$5A3B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $815E (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_815E:: ; 48:5A2B
Font_48_5A2B::
	INCBIN "data/fonts/font_8x16_5a2b.1bpp"

; ---- gfx $5A3B-$5A4B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8160 (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8160:: ; 48:5A3B
Font_48_5A3B::
	INCBIN "data/fonts/font_8x16_5a3b.1bpp"

; ---- gfx $5A4B-$5A6B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8162 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8162:: ; 48:5A4B
Font_48_5A4B::
	INCBIN "data/fonts/font_8x16_5a4b.1bpp"

; ---- gfx $5A6B-$5A8B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8165 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8165:: ; 48:5A6B
Font_48_5A6B::
	INCBIN "data/fonts/font_8x16_5a6b.1bpp"

; ---- gfx $5A8B-$5A9B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8168 (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8168:: ; 48:5A8B
Font_48_5A8B::
	INCBIN "data/fonts/font_8x16_5a8b.1bpp"

; ---- gfx $5A9B-$5ABB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8169 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8169:: ; 48:5A9B
Font_48_5A9B::
	INCBIN "data/fonts/font_8x16_5a9b.1bpp"

; ---- gfx $5ABB-$5AFB (64 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $816D (record of Table_48_4810; 4 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_816D:: ; 48:5ABB
Font_48_5ABB::
	INCBIN "data/fonts/font_8x16_5abb.1bpp"

; ---- gfx $5AFB-$5B7B (128 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8175 (record of Table_48_4810; 8 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8175:: ; 48:5AFB
Font_48_5AFB::
	INCBIN "data/fonts/font_8x16_5afb.1bpp"

; ---- gfx $5B7B-$5B8B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $817E (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_817E:: ; 48:5B7B
Font_48_5B7B::
	INCBIN "data/fonts/font_8x16_5b7b.1bpp"

; ---- gfx $5B8B-$5BAB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8180 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8180:: ; 48:5B8B
Font_48_5B8B::
	INCBIN "data/fonts/font_8x16_5b8b.1bpp"

; ---- gfx $5BAB-$5BCB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8183 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8183:: ; 48:5BAB
Font_48_5BAB::
	INCBIN "data/fonts/font_8x16_5bab.1bpp"

; ---- gfx $5BCB-$5BEB (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8189 (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8189:: ; 48:5BCB
Font_48_5BCB::
	INCBIN "data/fonts/font_8x16_5bcb.1bpp"

; ---- gfx $5BEB-$5C0B (32 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $818F (record of Table_48_4810; 2 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_818F:: ; 48:5BEB
Font_48_5BEB::
	INCBIN "data/fonts/font_8x16_5beb.1bpp"

; ---- gfx $5C0B-$5C5B (80 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8193 (record of Table_48_4810; 5 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8193:: ; 48:5C0B
Font_48_5C0B::
	INCBIN "data/fonts/font_8x16_5c0b.1bpp"

; ---- gfx $5C5B-$5C9B (64 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $8199 (record of Table_48_4810; 4 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_8199:: ; 48:5C5B
Font_48_5C5B::
	INCBIN "data/fonts/font_8x16_5c5b.1bpp"

; ---- gfx $5C9B-$5CFB (96 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $819E (record of Table_48_4810; 6 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_819E:: ; 48:5C9B
Font_48_5C9B::
	INCBIN "data/fonts/font_8x16_5c9b.1bpp"

; ---- gfx $5CFB-$5D5B (96 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $81A6 (record of Table_48_4810; 6 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_81A6:: ; 48:5CFB
Font_48_5CFB::
	INCBIN "data/fonts/font_8x16_5cfb.1bpp"

; ---- gfx $5D5B-$5D6B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $81F4 (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_81F4:: ; 48:5D5B
Font_48_5D5B::
	INCBIN "data/fonts/font_8x16_5d5b.1bpp"

; ---- gfx $5D6B-$5D7B (16 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $815B (record of Table_48_4810; 1 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_815B:: ; 48:5D6B
Font_48_5D6B::
	INCBIN "data/fonts/font_8x16_5d6b.1bpp"

; ---- gfx $5D7B-$5DCB (80 bytes) [PROBABLE] 8x16 1bpp glyph run for SJIS codes from $83BF (record of Table_48_4810; 5 glyphs x 16 bytes). 48:47D6/47EE copy 8 bytes twice per glyph doubling each byte (1bpp -> 2bpp), so glyph = 16 rows of 1bpp; rendering the whole block shows digits, Latin, hiragana, katakana, symbols. Run length matches the SJIS range (e.g. $824F..$8258 = 10 glyphs = $A0 = 4B7B-4ADB)

Font_GlyphRun_83BF:: ; 48:5D7B
Font_48_5D7B::
	INCBIN "data/fonts/font_8x16_5d7b.1bpp"
