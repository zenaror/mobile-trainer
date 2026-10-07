# Original JP bank 73 ticker strings

Only the original JP text extent 73:4009–4097 receives a CONFIRMED bounded header. Its four existing Shift-JIS string statements already represent the exact original bytes. Their sizes are 13/79/13/37 bytes including each NUL, for 142 bytes, 69 two-byte glyph codes and four terminators. No string content, charmap, alias, source instruction or asset changes.

The immutable bank byte 73 at 4000 precedes two physical title/body pointer pairs at 4001. The caller 73:62CB supplies A=73 and HL=4000 to Ticker_Start 48:42D4. ReadByteFar 00:1620 advances HL and restores the preceding ROM bank. Title and body pointers are stored separately, and the two-byte scans at 48:4309/4343 stop on zero. The original quoted strings have no CR, LF or single-byte ASCII token; all four NULs are included in the proof.

All 69 original natural trace files were read. Every original text byte is naturally read. The complete 142-byte unit has 19 union scenarios and eight whole-unit scenarios; the individual strings have 19/19/8/8 whole scenarios. Union counts describe scenarios reading any byte, while whole counts require every byte. These are per-byte interval calculations, not caller-count substitutions or forced evidence.

The two render calls at 48:43A3/43C5 reach TextTiles_RenderGridRows 48:415A. It preserves the source bank for byte reads and passes the glyph pair through 48:41CF to Font_BlitGlyph8x16 48:4748. The four farcall encodings were checked against the original ROM. Every glyph occurrence was resolved through the original 27-record glyph-run table; all records use ROM bank 48. The destination switches operate on WRAM and leave ROM bank 48 selected. Natural global font reads are separate support, not proof that every text occurrence executed or a promotion of font assets.

The normal renderer stages two glyph halves in WRAM bank 2, separated by 0400. Grid width is 64; the two six-glyph titles start at column 8, and the bodies start at 21. Their 39/18 glyphs fit within the remaining 43 columns. The ticker uploads 320-byte windows to VRAM 9400/9600 bank 0, rather than the whole staged grid at once. This confirms the bounded original content without guaranteeing arbitrary text dimensions.

The upstream cursor's lowest-set-bit selector and optional adjustments to indices 4/5/6 have no universal clamp to the two physical pointer pairs. Unknown or unentered paths and HYPOTHESIS getters at 6143 retain their status. All other 23 physical headers, the already published table, mixed map/attribute/sprite units, unread data and all assets remain unchanged.

This is original Japanese ROM evidence only. The English localized file has a different title layout and relocation; original whole-unit confidence must not be inherited as proof of translated bytes, padding or runtime. Future synchronization must preserve localized paths and annotate the actual translated representation separately. No English branch is changed by this pass.
