# Classification pass G2 (banks 1E, 23, 24, 3F, 42, 4B, 4C, 55, 5F, 68, 71)

Status vocabulary as everywhere: **CONFIRMED** (executed / cited bytes), **PROBABLE** (strong structural evidence),
**HYPOTHESIS**.  Addresses are `bank:addr` CPU addresses.  Owned files: `config/regions/bank{1E,23,24,3F,42,4B,4C,55,5F,68,71}.tsv`
and this note.  Every edit was verified with `python3 tools/gen_asm.py verify` (IDENTICAL) and
`python3 tools/conventions_check.py --strict` (clean); `src/` was not touched (the orchestrator regenerates).

**Adversarial verification pass (section 6)**: several statements below were re-derived from ROM bytes and corrected; corrections are marked *Retracted* / *Corrected* in place and listed in section 6.  Net effect: all new code without a proven entry is now HYPOTHESIS, two cross-bank pointer tables were un-labelled, the 71:6F38 sprite data that the first pass described but had not applied is applied, and two statements about entries/evidence were retracted.

## 1. Result

326 UNCLASSIFIED spans / 19 712 bytes in these banks (`analysis/mapper/unknown_spans.tsv`).  After the pass **2 bytes in 2 spans remain**
(23:46CC and 24:4BCC, one stray `$C9` each).

| bank | spans | bytes | resolved | left | moved to (bytes) |
|---|---|---|---|---|---|
| 1E | 5 | 426 | 426 | 0 | data/PROBABLE 396, data/HYPOTHESIS 19, zero 7, words 4 |
| 23 | 20 | 864 | 863 | 1 | code/HYPOTHESIS 283, data/PROBABLE 252, data/HYPOTHESIS 176, text 100, words 44, zero 9 |
| 24 | 19 | 2 976 | 2 975 | 1 | data/PROBABLE 1 616, gfx/PROBABLE 1 100, text 103, words 78, code/HYPOTHESIS 34, data/HYPOTHESIS 30, ptrtable 8, zero 7 |
| 3F | 1 | 2 | 2 | 0 | zero 2 |
| 42 | 18 | 7 647 | 7 647 | 0 | gfx/PROBABLE 3 562, data/PROBABLE 2 186 (4 tilemaps + 4 palettes), gfx/HYPOTHESIS 1 899 |
| 4B | 4 | 2 604 | 2 604 | 0 | gfx/PROBABLE 2 560, data/PROBABLE 44 |
| 4C | 6 | 118 | 118 | 0 | text 69, data/PROBABLE 49 |
| 55 | 201 | 3 622 | 3 622 | 0 | data/PROBABLE 2 801, text 634, code/HYPOTHESIS 116, code/PROBABLE 35, ptrtable 18, data/HYPOTHESIS 12, words 6 |
| 5F | 3 | 86 | 86 | 0 | data/HYPOTHESIS 48, data/PROBABLE 28, zero 8, words 2 |
| 68 | 45 | 971 | 971 | 0 | code/HYPOTHESIS 633, data/PROBABLE 213, text 86, words 36, code/PROBABLE 3 |
| 71 | 4 | 396 | 396 | 0 | data/PROBABLE 392, words 4 |
| **all** | 326 | **19 712** | **19 710** | **2** | data/PROBABLE 7 977, gfx/PROBABLE 7 222, gfx/HYPOTHESIS 1 899, code/HYPOTHESIS 1 066, text 992, data/HYPOTHESIS 285, words 174, code/PROBABLE 38, zero 33, ptrtable 26 |

(Table recomputed by the verifier after its corrections.  Only 38 code bytes remain PROBABLE: 55:691C, 55:6A2F, 68:48D1 and 55:6EEC, see 2.3.)

Nothing became CONFIRMED (all new evidence is structural: no trace executes these bytes, except that 24:7AE0-7B20 is read as data and the loader calls 1F:40D7/4109 and 29:40B0/40C1/463E are in the current coverage union, see 6.5-6; two spans are inside CONFIRMED executed-read
data and were merged, see 2.5).  Where a mapper guess was wrong the region was corrected (section 3).

## 2. Method and evidence classes

Scripts lived in the scratchpad (not in the repo); the evidence of each decision is written into the `note` column of the region.

1. **Loader call sites with immediates** (`ld hl,X ; ld a,BANK ; ld c,N ; call FarCall dw loader`).  `analysis/gfx_candidates.tsv`
   only knew `00:0787` (HDMA), `00:08EA` (tilemap) and `00:0A82` (object table).  This pass also resolved every call of
   `00:0749` (general HDMA start, C x 16 bytes; verified in `docs/research/boot_and_home.md`) and of `4F:4000` (`00:050C` copy,
   BC bytes to the WRAM7 palette buffers `$D800/$D840`): 4 tile uploads and 20+ palette blocks in these banks.  Palette
   blocks found this way replace the mapper "palette-rgb555" guesses (which had wrong start/extent).
2. **Sprite object data** (the biggest structural win, banks 24, 23, 1E, 5F, 71).  The sprite engine (`00:0A82/0AB8/0AE8`,
   `docs/research/boot_and_home.md`) reads a 4-byte object-table entry `{frame-table ptr, animation-script ptr}` (index `b & $7F`).
   Following those pointers gives three fixed layouts, and *the pointer chains tile the data area byte for byte* (only single `$00`
   alignment bytes between a script and the next even-aligned frame table), which is the evidence:
   * frame table = words, one per frame, extent = (first record - table)/2;
   * frame record = count byte + count x (y, x, tile, attribute) (00:0B9D adds y+16, x+8 and copies 4 bytes to shadow OAM);
   * script = count byte + count x (frame index, delay) (00:0B02-0B23; slot+4/+5).
   Object rows are 16 bytes = the same entry four times (banks 24, 23) or a 4-byte-entry table whose entry 0 is zero (1E:656F, 5F:4CF8,
   71:4FB8, 71:6F38).  `Table_BB_xxxx` (words) / `Data_BB_xxxx` (records, scripts) regions with symbolic `dw` are generated for
   24:6530-6BE2, 24:7B20-7D48, 23:7990-7C03, 1E:6320-658B, 5F:4CF8-4ECB, 71:4FB8-5038, 71:6F38-6F6F (*Corrected*: the first pass listed 71:6F38-6F6F but left it as the mapper's `gfx` guess; the verifier applied it: 8-byte object table, 2-word frame table, 37-byte and 1-byte records, 5-byte script, ending exactly at the tilemap 6F6F).  Records/scripts that
   executed reads touch (existing CONFIRMED read regions) keep CONFIRMED; the rest are PROBABLE; scripts that no known object
   row references but that fill a gap exactly (24:6986, 24:6A4F, 24:6B11, 1E:6551, 1E:6554) are HYPOTHESIS.
3. **Code** (23, 55, 68, 24): a span between proven code is classified as code only if the decode chain from its first byte is
   clean (no illegal opcode, all same-bank branch targets on instruction starts, no branch into the middle of it) *and* it ends with
   `ret/jp/jr` or lands exactly on the start of the next code region.  **Corrected by the verifier**: a clean decode chain that lands on
   proven code is *not* an entry (the proven code follows the span, it does not lead into it), and the rule of this project is that bytes
   that merely decode are not code; so every new code span without a caller, a valid table word or an executed address is
   **HYPOTHESIS** (1 026 bytes), including 55:5DF5/5F29, 23:47BC/5028/540D..., 68:4283/4377/4430/52B2/5739/... and 24:42AF.  PROBABLE was kept
   for only four spans with a real entry: 55:691C and 55:6A2F (4th word of the 4-entry dispatch tables at 55:686F/6982, indexed by [$C2AC]; the other
   three targets of each table are executed and the entries are `$39` bytes apart), 68:48D1 (word 2 of the table at 68:48D6, whose words 0 and 3 are
   read by executed code and point at executed code), and 55:6EEC (fixed-stride sibling: the executed routines 6ED6 and 6F02 lie exactly `$16`
   bytes either side, identical code bytes except the base operand, identical 11-byte table shape).  *Retracted*: "68:5739 is entered by the words
   5770/5798 of the ptrtable at 528C" - that table holds pointers into bank 4A (see section 6).  Text/ASCII that decodes as code was excluded by a Shift-JIS/ASCII check and by the `ld hl,imm`
   references that point exactly at the strings.
4. **Text**: NUL-terminated Shift-JIS or ASCII that cp932-decodes cleanly, tied to an `ld hl,imm` reference or to neighbouring
   confirmed rows: 24:42D1/42E7 (URL string, referenced by the routine at 42B0), 24:4B10 message table + lines, 23:43DF/497B/581E/6E2F,
   68:408E ("0123456789#*" dial keys), 68:4E37/4E46, 68:67B6-67D8 (dial strings pointed to by the word table 67AE), 4C:4F11/4F25/4F45
   (HTML page template pieces), the bank-55 keyboard rows.
5. **Executed-read merge**: an UNCLASSIFIED data gap directly between (or next to) CONFIRMED "read as data by executed code" ranges,
   with no other region kind in between, was merged into one `data` PROBABLE region (the reads prove the neighbours are data of one
   table indexed by the code; the gaps were merely never indexed in the traces).  Content class stays "not decoded".  Used in
   1E:4357-48C1, 4C:430A-4312, 71:5098-5340, 68:77D0/7831 tables, 55 tables.  In the bank-55 keyboard region the merged runs are
   split again into clean-cp932 text rows and the "00 00 ff 83 00 00 00 00 ff 82 00 00" page trailers.
6. **Tile/tilemap/palette structure** for bank 42 (see below), 4B, 24, 5F.  Tilemap blocks are recognised as 20x18 indices (360 B) +
   attribute bytes (360 B, values < $10) = the `copy_tilemap_rect_pair` layout of the CONFIRMED screens, and tiles by 2bpp coherence
   (mean adjacent-pixel similarity, random data ~0.25-0.35; PROBABLE needs >= 16 non-blank tiles with h >= 0.55, v >= 0.5 or a loader
   call / visible glyphs), plus rendering to PNG and looking at them.

## 3. Per bank

### Bank 42 (7 647 bytes -> 0 left) - four CGB screens, no direct reference
No `ld hl,X ; ld a,$42` or far pointer names bank 42 (checked by raw scan), so everything is structural.  The bank is
`tiles ... | tilemap+attr (720 B) | palette (128 B) | tiles ...` four times: tilemap+attr `4A00`, `5750`, `64A0`, `71F0`
(each 20x18 indices then 20x18 attributes; *Corrected*: the attribute bytes are all < $10 for screens 1, 2, 4 ($08-$0C) but screen 3 (64A0) also holds $01, $2A and $2B, still valid CGB attribute bytes (palette, tile bank 1, X-flip); first bytes `3A 3B 4F ...`), followed by palette blocks at
`4CD0`, `5A20`, `6770`, `74C0`, all starting `FF7F 011C 7E02 0000`.  The mapper's palette regions (4CCA, 5A1A, 6778, 74BA) were 2-6 bytes
off and swallowed attribute bytes; they and the "tiles-2bpp" regions that overlapped the tilemaps (52E0-5760, 63B0-6740) were trimmed
(`Tilemap_42_*`, `Palette_42_*` PROBABLE).  The remaining spans are 2bpp tile blocks (`Tiles_42_*` PROBABLE for >= 16 coherent tiles, e.g.
4000-4540 shows "START / MENU / B / BACK" glyphs, 4900 the large digits 0-9 and ':', 5F92, 5AA0; HYPOTHESIS for the small ones).
Left: none.  Open: which code loads these screens (probably a table of (bank, addr) records not recognised by the raw scan).

### Bank 24 (2 976 -> 1 left)
* Tile blocks 5400-58B0, 5EE0-64E0 are uploaded by `00:0749` calls at 24:432C/4341/4356/436B; palette 5EA0-5EE0 and 64E0-6520 by
  `4F:4000` calls at 24:4393/437F; palettes 7A60/7AA0/7AE0 (3 x 64 B) by 29:40B0/40C1/463E.  Mapper palette guesses 5EC6, 64DC (136
  words) and 7A60-7C38 were corrected.
* Sprite data 6530-6BE2 and 7B20-7D48 as in 2.2 (about 120 regions).  The 6520 row (`$6E50/$6E76` x4) does not follow the layout
  (targets are tile data): HYPOTHESIS data.
* `4000-4018`: 12 SRAM addresses (`$A084..$A584`, `$A000,$A016,...`) loaded by `ld hl,$400x` at 24:44C9...; `42AF-42F0`: code + the two strings
  it copies; `4B10`: 4-pointer message table (loaded by `ld hl,$4B10`) + the four 45-byte multi-line messages.
* Left: `4BCC` (a lone `$C9` between the message text and code).

### Bank 23 (864 -> 1 left)
Twelve spans were function prologues/bodies that fall into proven code (47BC, 5028/540D twins, 58C5, 5FA3, 6D61, 6E58, 6F22, ...): code; five
NUL-terminated blank/zero strings (fullwidth spaces, "０００００") referenced by `ld hl,imm`; `4B4A` 7 bytes copied to `$D624` by the
loop at 23:4A2F; palettes `7910/7950` (the `4F:4000` loads) and the object table/records/scripts 7990-7C03 (11+10 rows).  The
mapper's "tiles-2bpp" region 7C01-7E81 plus span 7E81-7F30 hold 20-byte rows of runs ($11/$2F/$08/$10) and small ascending indices:
retyped to one `data` HYPOTHESIS 7C03-7F30 (tilemap/attribute-like, no loader references it).  Left: `46CC` (`$C9`).

### Bank 55 (3 622 -> 0 left) - on-screen keyboard
* `4014` 25-word table (read by executed code; the header 4000-4014 was restored to PROBABLE by the verifier, its read ranges are trace-proven data) and 4046-43EE: six keyboard character-page blocks whose starts are the table words
  (`4046, 40B2, 4142, 41D2, 4286, 433A`, then every $B4 up to `498E`).  The mapper's "tiles-2bpp" verdict for 4040-43E0 (and for
  4A51-4F61) was wrong: the bytes are character codes (`00 00 00 31 ...`) resp. 6-byte records.
* `4A42` 10-word table (executed reads); its targets tile the bytes to the code at `5BA2` exactly (block sizes `$144,$1B0,$1B0,$21C x5`
  = 54/72/90 records of 6 bytes): 9 record blocks (`Data_55_4A56` ...); field meaning (cursor neighbour grid?) not decoded (HYPOTHESIS
  for the semantics, PROBABLE for the extents).
* Keyboard rows: 634 bytes of clean Shift-JIS rows (`String_55_*`), 14-byte page trailers `00 00 00 00 ff 83 00 00 00 00 ff 82 00 00`
  (the `ff 83/ff 82` words are read by executed code).  6CD4-6E94: fullwidth-symbol table read by index, no NULs (*Corrected*: kept as `text` PROBABLE in the region file, not `data`; six ranges of it are executed reads).
* Code: `5DF5` (calls the lookup routine `6EEC`) and `5F29` (its `jp` target): HYPOTHESIS (no entry); `691C/6A2F` (entries of dispatch tables): PROBABLE; the lookup
  routine `6EEC` (fixed-stride sibling of the executed routines 6ED6/6F02, each followed by an 11-byte table): PROBABLE; `6F46` (+ the 12-byte block 6F95: 4 RGB555 colours,
  then 4 delay bytes at 6F9D): HYPOTHESIS; `6184` HYPOTHESIS.
* (bank 68, not 55) `68:5E92` "ptrtable" corrected: the last two bytes were the operand of `ld a,[$C278]` (code starts at 5E9A).
* `5FC8`, `6087`, `60F1` executed-read data regions retyped `words` (every word is a code entry: dispatch tables, task e).

### Bank 68 (971 -> 0 left)
Ret-terminated functions (SRAM clear/validity/read at 4283, 4377, 4430 with the enable/bank save-restore sequence; twins 52B2/5739; 5404/58E8;
5D2F; 4152), ASCII dial strings and phone numbers, word tables (`4594`, `635C`, `659A`, `67AE`, `67D8`, `764C`, `765E`), the mobile-adapter
default record: 192-byte ($00C0) blocks starting `4D 41 01 00 D2 C4 03 B7 D2 8D 70 A3` ("MA" header) at 67E0/68A0/6960/6A20 (word table
67D8) and 4EA7-4F67 (*Corrected*: this one starts `4D 41 81 00 AC 10 13 BA`, only the "MA" signature is shared; copied to `$D000` by the
code at 68:4E6A `ld hl,$4EA7 ; ld de,$D000 ; ld bc,$00C0 ; call $050C`, inside the region 4E51-4EA7, and ending exactly where the code 4F67 starts).  `48D6`
table word `$48D1` (word 2; words 0 and 3 are read by executed code and point at executed code) proves that stub as code (PROBABLE); `5E9A` code (HYPOTHESIS).
*Retracted*: the words of the ptrtables at `528C` and `5E92` are NOT code pointers of this bank: both are used as HL of far calls with `a=$4A` resp. `a=$5D`
(copy_tilemap_rect_pair), i.e. pointers into banks 4A / 5D; they are now `words` (as ptrtables the generator emitted false labels such as `dw Label_68_5798`).  Left: none.

### Bank 4B (2 604 -> 0), 1E (426 -> 0), 5F (86 -> 0), 71 (396 -> 0), 4C (118 -> 0), 3F (2 -> 0)
4B: `5B90-6590` = 160 tiles of Japanese text glyphs (電話番号入力説明, 変更終了, 新しいパスワードのご注意; PROBABLE by rendering + score) and the two
tile-pair attribute tables `5B68`, `76C0` after the tilemap blocks.  1E: palettes 62A0/62E0, sprite tables, `4357-48C1` executed-read block.
5F: palette 4CD0-4CF8, sprite tables 4CF8-4ECB, zero pad, `6980` $06 fill (HYPOTHESIS).  71: sprite tables (4FB8 and, after the verifier's fix, 6F38), `5098-5340` tilemap fragments merged with
CONFIRMED reads.  4C: HTML template strings, `4DD6` 37-byte lookup table (base of `sub $10 / add $D6 / adc $4D` at 4DC7), SRAM (address, bank) triples
`4CEA`.  3F: 2 zero pad bytes after the 55-entry (addr, bank) HTML page table.

## 4. Code-region audit (task d)
No PROBABLE code region in these banks has all instruction starts in `analysis/coverage_union.tsv` (none to promote to CONFIRMED).  Checks run over
every code region of the 11 banks after the edits: no illegal opcode, no branch into the middle of an instruction, every `jp/jr/call`
target inside the bank on an instruction start (0 violations; the verifier re-ran this independently with the farcall inline bytes skipped, and also checked
that every executed instruction start of these banks in the current 22-scenario `coverage_union.tsv` is an instruction start of a code region: 0 violations).  The 6 code regions of bank 4C (4000, 4291, 452E, 46A6, 46C4, 4F56) and 1 of bank 68 (766E) that end without a
terminator are pre-existing (they end at the inline jump tables of `call $0545`/`call $056A`, which follow as ptrtable regions) and unchanged.

## 5. Open questions / follow-ups
* Which code loads bank 42's four screens and what the bank-55 6-byte record fields mean (candidates: cursor neighbour grid).
* Entries of the newly classified functions (23, 55, 68, 24:42AF) are unproven (now HYPOTHESIS): a caller search through indirect `call $0545` tables or other
  banks could raise them.  A raw scan of the whole ROM for their 16-bit addresses (any alignment) finds no reference.
* 23:7C03-7F30 and 24:6520 remain HYPOTHESIS data.
* 23:46CC and 24:4BCC (`$C9`) stay UNCLASSIFIED: a stray `ret` byte after an unconditional `jp` / after text.

## 6. Verifier corrections (adversarial pass)

Independently re-derived from ROM bytes (tools/sm83.py decode, own parsers): the bank-42 tilemap/palette layout (4 screens, 16 palettes of 4 colours each, rendered tiles show `START/MENU/B/BACK`
and the digits), the sprite pointer chains of banks 24/23/1E/5F/71 (frame-table words -> records tile exactly, record length = 1+4n, script length = 1+2n, 0 mismatches over 135 records, 72 scripts and 68 frame tables; object-table
anchors re-found as `ld de,BASE ; ld a,BANK ; farcall 00:0A82` byte patterns), the bank-55 keyboard tables (25 + 10 words, block sizes), the bank-68 192-byte records (sizes proven by the abutting code and the
`ld b,$BE` checksum loop at 68:4E76), the bank-4B glyph tiles (rendered), the loader call sites 24:432C-43A7 and 1F:40D7/4109 (arguments read by hand), 23:4B4A/497B/581E/6E2F, 24:4B10 (messages), 24:42B0,
4C:4DD6/4CEA, the code entries of every new code span, the dispatch tables 55:686F/6982/5FC8/6087/60F1 and 68:48D6/6BF4/7C6B, and the cp932 decode of every new text span (all clean).

Corrections made (all region-file edits verified with `gen_asm.py verify` = IDENTICAL and `conventions_check --strict` = 0):

1. **Retracted: entries for new code.**  68:5739's "entry" (words $5770/$5798 of 68:528C) was false (those words are bank-4A pointers, and $5770 is inside an operand of the decoded code).  Every other new
   code span without a caller/table word is lowered from PROBABLE to HYPOTHESIS (23:47BC, 5028, 540D, 58C5, 5FA3, 6D61, 6E58, 6F22; 24:42AF; 55:5DF5, 5F29, 6F46; 68:4152, 4283, 4377, 4430, 52B2, 5404, 5739, 58E8,
   5D2F, 5E9A); the 55:6F95 12-byte block that only that routine reads is lowered too.  Kept PROBABLE: 55:691C, 6A2F, 68:48D1 (table words) and 55:6EEC (fixed-stride sibling).  The decode chains themselves are clean.
2. **Retracted: cross-bank pointer tables typed as own-bank code pointers.**  68:528C (a=$4A) and 68:5E92 (a=$5D) are `words` now; the generator no longer emits `dw Label_68_5798` / `dw Label_68_5000`.
3. **Applied what the first pass claimed but did not do:** the 71:6F38-6F6F sprite data (`Table_71_6F38`, `Table_71_6F40`, `Data_71_6F44`, `Data_71_6F69`, `Data_71_6F6A`) instead of the mapper's `gfx` guess.
4. **Regression fixed:** the executed-read header 55:4000-4013 had dropped from CONFIRMED to HYPOTHESIS; restored to PROBABLE (merged run).
5. **Wrong facts corrected in notes:** "attribute bytes all < $10" (screen 3 has $2A/$2B); "the mobile-adapter records at 4EA7 start with `4D 41 01 00 D2 C4...`" (they start `4D 41 81 00 AC 10 ...`); "call site never executed" for
   1F:40D7/4109 and 29:40B0/40C1/463E (they are in the current coverage union; status left PROBABLE); "5E92 ptrtable in bank 55" (bank 68); "6CD4-6E94 kept data" (it is `text` in the file).
6. Not changed, but recorded: palette blocks 24:7AE0-7B20 are also proven data by an executed read (dataaccess `rom_read 24 7AE0 7B20`); the mapper region 24:5EF1-6301 (`parity 1`) straddles the loader-proven
   block boundary 62E0 (both sides gfx, harmless).
