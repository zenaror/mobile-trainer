# Classification pass g5: banks 1D, 22, 29, 2A, 2B, 43, 48, 50, 67, 74

## 1. Bytes resolved (old UNCLASSIFIED byte -> kind of the region that now covers it)

| bank | bytes | code | text | gfx | tilemap | attrmap | palette | words/ptrtable | other data | zero | status of these bytes |
|---|---|---|---|---|---|---|---|---|---|---|---|
| 1D | 84 | 0 | 0 | 0 | 30 | 30 | 0 | 6 | 3 | 15 | PROBABLE 84 |
| 22 | 175 | 101 | 48 | 0 | 0 | 0 | 0 | 0 | 21 | 5 | PROBABLE 86, HYPOTHESIS 89 |
| 29 | 1 415 | 742 | 44 | 0 | 0 | 0 | 8 | 260 | 344 | 17 | PROBABLE 588, HYPOTHESIS 827 |
| 2A | 1 910 | 101 | 5 | 960 | 0 | 0 | 56 | 178 | 582 | 28 | PROBABLE 1 740, HYPOTHESIS 170 |
| 2B | 2 797 | 228 | 13 | 1 661 | 0 | 0 | 40 | 300 | 531 | 24 | PROBABLE 2 523, HYPOTHESIS 274 |
| 43 | 6 615 | 0 | 0 | 4 821 | 646 | 1 044 | 104 | 0 | 0 | 0 | PROBABLE 6 615 |
| 48 | 112 | 68 | 0 | 0 | 0 | 0 | 0 | 0 | 44 | 0 | CONFIRMED 44, HYPOTHESIS 68 |
| 50 | 5 365 | 0 | 0 | 0 | 2 735 | 2 520 | 0 | 32 | 78 | 0 | CONFIRMED 720, PROBABLE 4 635, HYPOTHESIS 10 |
| 67 | 833 | 739 | 0 | 0 | 0 | 0 | 0 | 74 | 20 | 0 | CONFIRMED 2, PROBABLE 389, HYPOTHESIS 442 |
| 74 | 406 | 28 | 8 | 0 | 0 | 0 | 0 | 126 | 244 | 0 | CONFIRMED 16, PROBABLE 388, HYPOTHESIS 2 |
| **sum** | **19 712** | | | | | | | | | | remaining UNCLASSIFIED: 0 in every bank |

### 3.6 Bank 43 (6 615 bytes)

No code and no ROM reference to bank 43 exists (no far call, no `ld hl` with `ld a,$43`).

Content decides: the bank is **4 identical packages of $0D50 bytes** at `4000, 4D50, 5AA0, 67F0` (the last ends exactly at 7540 where the trailing zero padding starts): 160 tiles ($A00) + 20x18 tile map (360) + 20x18 attribute map (360) + 64 RGB555 words ($80).

### 3.7 Bank 48 (112 bytes) - a font, not 2bpp tiles

`4810-4899` is a table of 27 five-byte records (key16 = SJIS code where a glyph run starts, bank byte $48, run pointer16), descending keys, terminated by $FFFF; it is read by the executed glyph fetcher `Function_48_4748` (loop at 48:4777).
The pointers ($4ADB=$824F digits, $4B7B=$8260 Latin caps, $4D1B=$8281 Latin lowercase, $4EBB=$829F hiragana, $53EB=$8340 katakana, $593B=$8140 symbols, ..., $5D7B=$83BF) differ by exactly 16 bytes per code
(e.g. $A0 = 10 digits).  The block `4ADB-5DCB` is therefore 303 **8x16 1bpp glyphs** (the fetcher at 48:47D6/47EE doubles each byte into 2bpp): the old `gfx` region (2bpp heuristic) was split into 27 `Font_48_XXXX` runs.  The two remaining spans
are unreferenced functions (`48BC`, and `4A8C` = byte-identical copy of ROM0 `00:091C`), HYPOTHESIS.

### 3.8 Bank 50 (5 365 bytes)

* `438A-5A1A`: `Table_50_4244` (8 words, indexed by `wRam_C1CD-1` at 50:4254) selects one of **8 screen maps of $2D0 bytes**: a 20x18 tile map and a 20x18 attribute map, copied by `Function_00_08EA` (`bc=$1214`, dest stride 32) to $D000 and $D400.
  `438A` is the 8-word table of WRAM addresses used at 50:4352.  The old `gfx` region 5821-5A20 was really the 8th map pair (+6 zero bytes).
* `6BC0-6CC0` palettes (loaded `$40` bytes from `$6BC0` and `$6C40` via 4F:4000), `6CC0-6D1E` = 2 sprite animations + `Table_50_6D16` (used as DE of 00:0A82, 50:414F).  Same animation format as 3.3.

### 3.10 Bank 74 (406 bytes)

`4000-4165` is the **HTML tag/attribute/entity lookup** of the homepage renderer: pointer lists (`dw ...,0`) each followed by `[ASCII name][NUL][value byte]` items ("ng"/"ok", entities `lt gt amp quot nbsp` -> `< > & " space`,
attributes `ppp_id r_code d_code clear width align href name src left right all top center middle bottom`, tags `html title head body center div br hr img a b ul ol li ! meta pre` = ids 1..$11).  All pointer targets are item starts and the items tile up to the code at 4165 exactly.
`44A0` = 18-word tag-id jump table (`push bc; ret` dispatcher at 74:449E, executed; 18/18 targets are code starts, CONFIRMED); `511A` = the same idiom (PROBABLE) whose last target `51E4` becomes code;
`5905` = URL scheme list (`http` -> 1, `https file mailto ftp gopher news nntp telnet wais prospero` -> $FF); `59D8` = `http://`; 2 dead single-instruction fragments (HYPOTHESIS).

## 4. What is HYPOTHESIS and why

* Code without an entry (1 635 bytes across 22, 29, 2A, 2B, 48, 67, 74): each was accepted only if the linear decode is legal to the boundary, every direct target is a known instruction start, it starts after a `ret`/unconditional jump
  and ends in a terminator falls into proven code, and nothing in the ROM (branch scan of all code regions, word scan, far-pointer scan, `ld r16` scan) targets it.  Typical case: the compiler-emitted dead `jr`/`ret` after an unconditional jump and
  unreferenced sibling functions.  Revert to `data` if a later stage finds them to be data; bytes are unchanged either way.
* `29:5090-5376`: see 3.3.  * Animation scripts (byte meaning unverified).  * `22:4468`, `2B:5807` blank strings (no reference).

## 5. Not done / open

With all 24 `traces/coverage_*.tsv` files, 20 non-CONFIRMED code regions of these banks are fully executed (22:5077-5093, 22:50FC-510B, 29:46A1-46B9, 2A:422C-4274, 2A:722D-7287, 2B:6482-64F1, 2B:7B02-7D7A, 2B:7D92-7F44, 48:49B6-49C3, 50:4254-42AC, and ten small ones in bank 74) and 31 more are partly executed; promotion is left to `tools/apply_coverage.py` (no executed start lies in a non-code region, none is misaligned).

* Bank 29:5090 library: entry/consumer unknown.

Upheld: bank 43 layout (four $0D50 packages: rendered all four as coherent 20x18 screens), bank 48 font (27-record table read by 48:4748, run sizes = pointer spacing, 303 glyphs rendered, SJIS keys decode to the expected characters, 48:4A8C = copy of 00:091C), bank 74 HTML tables (all pointer lists tile the items, 44A0/511A targets are code starts, dispatcher `push bc ; ret` at 74:449E/5119), bank 50 screens (Table_50_4244 entries = 439A + n*$2D0, 00:08EA copies b rows x c columns twice, second copy at dest+$400, browser_pages reads exactly screen 4), bank 1D maps (`ld c,$0A`, attr pointer = tile pointer + $F0), bank 22 templates/strings, bank 2A/2B HDMA tile counts (c x 16 bytes, checked at 2A:4146, 2B:6603/662C/6641 and 2A:4158..), palettes (2A 4FA0/6E10/75A0, 2B 63F0/76A0/7860 = exact $40 loads), bank 67 jump tables and the 6th state entry, SRAM address tables, the animation format (00:0A82/0AB8/0AE8 read: entry = 4 bytes, script = count + 2 x count, frame table of pointers, frame = count + 4 x count), HYPOTHESIS code (each decodes to its end, follows a terminator, no referrer).

Corrected here: bank 43 'symmetric rows' remark (false); orphan animation objects 29:63F0-6406 and 2A:545C (not referenced by any entry, note and status fixed); 29:5B10/5E10 tile/palette boundaries (4 bytes early), 29:5AD0 palette length (64 bytes); 74:511A 'not executed' (its dispatcher is executed in the browser scenarios); 50:4C0A/4D72 raised to CONFIRMED (executed read of exactly that pair); bank 50 palette load sites (four, not two); 29:5090 (extra evidence it is not live code: `ld [$0C0E],a` PRNG state in ROM space); 67:424A (two ROM0 trampolines jump to its instruction starts but nothing calls them).
Judgement call kept: 22:48CD-48FE stays PROBABLE code although its entry is unknown (the function it falls into, 48FE-4A8C, is PROBABLE for the same reason and the two decode as one coherent function).
