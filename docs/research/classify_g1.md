# Classifier 1/6: UNCLASSIFIED spans of banks 0F 2E 46 47 4A 4E 51 5C 5D 72 7E 7F

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Scope: `config/regions/bank{0F,2E,46,47,4A,4E,51,5C,5D,72,7E,7F}.tsv` (the only files edited).  Every edit was made on a private copy
of `config/`, proven with `tools/gen_asm.py verify` (RESULT: IDENTICAL) and `tools/conventions_check.py` (0 ERROR, 5274 far-pointer
targets all inside code regions), then copied back.  `src/` was not regenerated.  Evidence vocabulary as in `docs/FORMATS.md`;
addresses are `bank:cpu-address`.

## Result

| bank | UNCLASSIFIED before | resolved | remaining | resolved into (bytes) |
|---|---:|---:|---:|---|
| 0F | 197 | 197 | 0 | text 77, ptrtable 60, words 26, code 33, zero 1 |
| 2E | 835 | 835 | 0 | data 548 (palette/anim block), text 198, code 62, ptrtable 12, zero 15 |
| 46 | 8267 | 8267 | 0 | gfx 6513, data 1754 (tilemap+attr, palettes) |
| 47 | 2934 | 2934 | 0 | gfx 1446, data 1488 |
| 4A | 61 | 61 | 0 | data 40, zero 13, words 8 |
| 4E | 1441 | 1432 | 9 | words 1054, code 227, data 101, ptrtable 50 |
| 51 | 8 | 8 | 0 | zero 7, data 1 |
| 5C | 407 | 407 | 0 | data 393, zero 10, ptrtable 2, words 2 (5144, added by the verifier) |
| 5D | 7 | 7 | 0 | zero 7 |
| 72 | 2182 | 2180 | 2 | text 1836, data 328, zero 12, words 4 |
| 7E | 143 | 143 | 0 | code 135 (6 of them HYPOTHESIS after verification), words 8 |
| 7F | 3230 | 3228 | 2 | data 1556, code 757, gfx 606, words 198, text 70, ptrtable 34, zero 7 |
| **total** | **19712** | **19699** | **13** | gfx 8565, data 6209, text 2181, code 1214, words 1300, ptrtable 158, zero 72 |

Status of the 19699 resolved bytes after the verification pass: PROBABLE 19342, HYPOTHESIS 302 (unreferenced code fragments and single bytes; 39 more than the classifier reported, see *Verification*), CONFIRMED 55.
The 13 bytes still UNCLASSIFIED are 6 tiny spans (list at the end).  Additionally five existing PROBABLE code regions became CONFIRMED
because all their instruction starts are in `analysis/coverage_union.tsv` (7E:7D62-7D66, 7E:7DAA-7DB0, 7E:7E3D-7E4C, 7F:7157-715F,
7F:7186-718E).  A scan of all code regions of the 12 banks (`decode` chain, inline far-call bytes skipped) found no illegal opcode and
no branch into the middle of an instruction, so no code region had to be demoted.

## Policy used for code

* CONFIRMED only when every instruction start is executed (coverage).
* PROBABLE code needs an entry or structure that ties it to proven code: a jump-table entry, a validated far-call site inside the
  function (the region continues into a mapper PROBABLE site region whose arguments it sets up), or a complete function
  (prologue ... ret, all direct targets on instruction starts, decode ends exactly where proven code begins) that calls proven code
  or is the twin of an executed sibling.
* HYPOTHESIS: complete-looking function or fragment whose entry could not be found (whole-ROM search of far calls, `ld r16`, words).
* Lone bytes without evidence stay UNCLASSIFIED.

## Findings that matter beyond single spans

1. **Screen blocks of banks 41-47** (banks 46 and 47 here).  Banks 41-46 hold four identical-layout blocks of 0xD50 bytes at
   `4000 / 4D50 / 5AA0 / 67F0`: 0xA00 bytes of 2bpp tiles (160 tiles, blank tiles included), 0x2D0 bytes tilemap+attribute map
   (0x168 tile bytes + 0x168 attr bytes, 20 columns x 18 rows, rows of 20 visible in the byte pattern, attr bytes 09/0A/0B/0C...), 0x80
   bytes of palettes.  Evidence: the palette signature `ff7f 1c01 027e 0000` sits at block+0xCD0 in banks 41-46 (24 hits, found by a
   whole-ROM search); every attr half ends exactly there; the mapper's "palette" heuristics (60 words at 4CD8, 5A28, 6778; 56 at 74D0)
   were the tails of these palette blocks.  Bank 47 has the same blocks shifted by +0x100 at `4100 / 4E50 / 5BA0 / 68F0` (palettes at
   4DD0, 5B20, 6870, 75C0), confirmed independently by the screen descriptors in bank 4E (below) and by executed whole-block data reads
   of 47:4E50-5BA0 (homepage trace) and 47:5BA0-68F0 (monkey_1 trace).  Banks 41-45 are owned by other classifiers; the layout above
   applies to them too (same offsets).
2. **Screen-descriptor table `4E:654B`.**  27 words indexed by `wRam_C2C2 & $7F` (used at 4E:4026, 4E:40D0, 4E:5DA2 ...) point to
   five 31-byte descriptors (4E:6581, 65A0, 65BF, 65DE, 65FD): five far pointers `dw addr ; db bank` (tiles, palettes, tilemap, tile
   piece, OBJ palettes = palettes + $40) followed by 16 parameter bytes (layout not decoded).
3. **Object animation data family.**  `init_object_from_table` (00:0A82, 4-byte entries = 2 words) is fed by tables whose words point
   into blocks of sprite lists (`count, count x (y,x,tile,attr)`) and animation descriptors (`01 00 04 dw`, `02 00 .. dw dw`):
   72:7828 + 72:786C-7A1F, 2E:76C0-7710 + 2E:7710-7961, 72:4E40 (the first version of this text said 4E:4E40, which is code; corrected by the verifier), 4A:4000/5838, 7F:6DB0 + 6E50-70FD, 7F:7B40 + 7B90-7CC5.  In bank 72
   the table words tile the block exactly at descriptor starts.  The mapper's palette heuristics that ran over such tables
   (72:7816-786E, 2E:75C0-7720, 7F:7B10-7BA0) were cut back.
4. **Message pointer/record structures:** 5C:4F53 (21 records `[id][mode][dw list]`, searched by executed code at 5C:527A) with 20
   triple lists that tile 4FA8-50F5 exactly, and the 32-entry message table 5C:5104; 72:502B record area (`86 aa bb` + 2-3 lines);
   0F header-name tables (jump table 0F:4169 with 13 validated code entries, string table 0F:4183, 0F:4011).
5. **Scroll-step tables in bank 7F** (four executed functions 7F:733A, 7425, 7578, 76C4, each with a row-pointer table; the rows tile
   exactly up to the next function).
6. **Not text although valid Shift-JIS:** `7F:4FC3` and `7F:4FCF` are word tables of SRAM addresses (A084..A584 and A000..A06E),
   read as `ld hl,$4FC3 ; ld a,[hli] ; ld e,a ...` at 14 code sites.

## Per bank

### 0F (197 bytes, all resolved)
Mail header/MIME helper strings and tables.  4000 `---`, 4033 `From: `, 404E `To: `/`Cc: `, 4164/4167, 41B5, 41C6, 421C `NAME=`, 4236
`=?ISO-2022-JP?B?` (copied by 0F:5104) as ASCII text; `0F:4011` = 17-word string pointer table (odd start, 4010 is a pad zero);
`0F:4169` = 13-word jump table read by the dispatcher 0F:4250-425F (all 13 targets are instruction starts of the PROBABLE code);
`0F:4183` = 13-word pointer table to the header-name strings 419D..420D.  Code: 47A5 (10 insn), 4C59 (small function), 4D35 (`ld b,$82`)
as HYPOTHESIS (they follow unconditional jumps, so they must be branch targets that were not found).

### 2E (835 bytes, all resolved)
Blank second lines of the message records (`81 40 x12 + 00`) 53C1/5410/545F and the 6-entry pointer table `2E:54F8` (index 2*(a+1), 5504-55D1,
41-byte strings) with its blank strings; message-function heads 53DA (PROBABLE, twin of the executed 5429), 565A (twin of the executed
5683 block), 4EB2 (wait 60 x 00:0464), 4F9A (counted loop around 4FA9); 488A prologue (HYPOTHESIS); 56D1 zero; object tables
`2E:76C0-7710` (5 tables) and the sprite/animation block 7710-7961 (the old 75C0-7720 palette region was shortened to 75C0-76C0).

### 46 and 47 (8267 + 2934 bytes, all resolved)
Four screen blocks each (see finding 1): gfx + tilemap+attr + palettes; the old ptrtable claim at 46:4B5B (6 words) was a tilemap
fragment and is gone.  The evidence is structural (no loader passes the block addresses as immediates; the descriptors of 4E:654B
supply the bank-47 addresses).  Status PROBABLE for all.  The verifier additionally rendered tiles + tilemap of blocks 46:4000, 46:5AA0, 46:67F0,
47:4100, 47:4E50, 47:5BA0 and 47:68F0 (tilemap = the 360 bytes at block+0xA00, 20 x 18): every one gives a coherent screen (frames, labels
such as the start/menu/back captions, artwork), which confirms the tile/tilemap boundary at +0xA00 (the palette split at +0xCD0 rests on the palette signature).

### 4A (61 bytes)
4000 = entry 0 (zero) of the object table read at 67:51D8 (`de=$4000 a=$4A b=$81`); 5838 = entry 0 of the table used at 68:513A;
5810-5838 = tail of the 10-row x 20-column tile-number block 5770-5838; 4033 zero padding.

### 4E (1441 bytes; 9 remain)
41E0-45FE (1054 bytes) = 43 word groups separated by `$FFFF` of BG-map offsets (row*32+col) along anti-diagonals (`words`, PROBABLE:
consumer not found); descriptor table 654B (finding 2); code 4000 (1 insn, HYPOTHESIS), 47EB (SRAM record copy, HYPOTHESIS), 5D70 (head
of the copy_tilemap_rect_pair call site 5D93: `ld bc,$1214 ; ld de,$D000`, PROBABLE), 6087 and 6172 (HYPOTHESIS).
Remaining: 5390 (1 byte `pop bc`), 6543-654B (8 bytes `08 08 0D 0E 0F 08 08 08`).

### 51 (8 bytes), 5D (7 bytes)
Zero runs (padding before tile blocks / inside data), one `$FF` byte between `ret` and a function (51:740C, HYPOTHESIS).

### 5C (407 bytes; 2 remain)
See finding 4: record table (CONFIRMED structure: executed search loop), 20 triple lists, `5C:50F5` mode-2 list, message table 5104
(32 entries, entry 0 null), digit tile-pair table 545B, zero padding 5D86.  The word `$0020` at 5144 (originally left unclassified) is slot 32 of the message-index space: 5146 = 5104 + 2*33 and the mode-2 list 50F5 selects indices $21-$25, i.e. exactly the 5 words of the table 5C:5146 (verified by the verifier); it is now a PROBABLE `words` region; the value itself is unexplained.

### 72 (2182 bytes; 2 remain)
23 message-record spans made `text` (they decode as cp932 with the documented `86 aa bb` headers and are table targets of 72:502B);
6BE3 text + 4 zero bytes; script bytes 6556 (12 x `04` + `80`, read through the reader at 72:4824); 7-byte record tables
6AEC and 6B4C (indexed `7*a`, at 72:669F and 72:69F3); the 72:7810 palettes, the 72:7828 object table and the animation block.
Remaining: single `AF` bytes at 63D7 and 6711.

### 7E (143 bytes)
`7E:7D8F` = 5-entry jump table of the executed dispatcher at 7D7B; the four handlers 7DB0/7DE5/7E05/7E1E are PROBABLE code
(each starts with `pop hl`, 19 direct targets valid); the 6-byte block 7DDF-7DE5 is not reached from any branch or table word and is now its own HYPOTHESIS region.

### 7F (3230 bytes; 2 remain)
Tables and data: masks 499C/49A5, palettes 4D50/6AA0/6D70/7B00, string/pointer tables 4E89/4EF0-region strings, SRAM address tables
4FC3/4FCF, object tables 6DB0/7B40, scroll-step tables and rows (7375/7385, 7467/747F, 75B3/75CB, 7706/771E), sprite tile block
7830-7B00 (45 tiles, rendered), animation blocks 6E50-70FD and 7B90-7CC5.  Code: 49AE-4BBC (two glyph-blit functions), 7235/7253
pairs, 72E2/730E step functions, 4D58 (prints "Sample DATA."), 5CB8/5CE7, function heads at 4042/4FDB, table entry 4202, and
HYPOTHESIS functions 61E8/620C.  Remaining: single `C9` bytes at 4C77 and 51ED.

## Still UNCLASSIFIED (13 bytes, 6 spans)
`4E:5390` (1), `4E:6543-654B` (8), `72:63D7` (1), `72:6711` (1), `7F:4C77` (1), `7F:51ED` (1); each region note records what
was observed and why it was not classified.

## Follow-ups worth doing
* Banks 41-45 should adopt the same block layout (finding 1); the four-block structure repeats in every one.
* Find the consumers of `4E:41E0` (diagonal transition table) and the loader that reads the `0xD50` blocks.
* HYPOTHESIS code (302 HYPOTHESIS bytes in total after verification, incl. single bytes) needs callers: candidates are indirect calls through RAM function pointers.

## Verification (adversarial pass)

Independently re-derived from ROM bytes / renderings / traces (not from the prose above):
palette signature census (28 hits: 24 in banks 41-46 at block+0xCD0, 4 in bank 47 shifted by 0x100); tile+tilemap rendering of 7 screen blocks
(see above); the 4E:654B table (27 words, 5 descriptors 31 bytes apart, far pointers resolved to bank 47 blocks 4100/4E50/5BA0 and their
tilemap/palette/OBJ-palette parts, 21 `ld hl,$654B` sites); the 72:7828 object table (17 entries, 2 words each, ranges) and the 786C
block structure; 4A:4000/5838 tables and the 4A:5770-5838 tile-number rows; 5C:4F53 records, all 20 triple lists (each ends with a `$FF,$FF`
default triple, tiling exact) and the pointer table 5C:5104 (all pointers are string starts); 72:502B record area (68 records parsed:
`86 aa bb` header, 32-byte lines each followed by NUL, every record start equals a table word; the first four words of 72:502B point
into the table itself, so it is an array of pointer lists, not a flat table); 72:6AEC/6B4C 7-byte records and 6BE3/6556 data; 7F:4FC3/4FCF
SRAM address tables (14 sites); the 4 scroll-step tables of 7F:733A/7425/7578/76C4 (rows tile exactly; the "9-byte gaps" are 9 trailing
zero bytes after row 9); 0F:4169 jump table (13 targets are instruction starts) with the dispatcher, and 0F:4011/4183 tables; 2E:54F8 table;
7E:7D8F jump table with the 4 handlers; 7F:4202 as entry 0 of the 16-word table 7F:42A3; 7F:6DB0/7B40 tables; the 7F sprite tile block
(rendered, coherent); 4E:41E0 groups (structure holds, consumer still unknown: no `ld r16` immediate in bank 4E or ROM0 has a value inside the block; the far-call words of bank 4E with such values target bank 4F).
Whole-config checks: no hole/overlap in the 12 banks; no executed instruction start inside a non-code region; no code region with an
illegal opcode or a decode that overruns its end; every CONFIRMED code region has all instruction starts in analysis/coverage_union.tsv (and
every fully covered code region of the 12 banks is CONFIRMED); every direct branch target of the 12 banks lands on an instruction start
(three calls at 2E:4A15/4A1B/4A2C target other banks that are mapped at run time, unchanged from before); no PROBABLE/CONFIRMED code was turned into data
(byte-level comparison against git HEAD).  `gen_asm.py verify` IDENTICAL, `conventions_check.py` 0 ERROR.

Corrections made:
* 2E:4EB2, 2E:4F9A, 7F:4000 (and the 6-byte block 7E:7DDF) had status PROBABLE without any caller, table entry or code flowing into/out of them;
  downgraded to HYPOTHESIS (bytes that only decode are not code).  The other "entry unproven" PROBABLE code either flows into a validated far-call
  site with matching arguments, is an entry of a validated table, or belongs to a regular family of executed functions (7F:7205/720C/721D/7224/7235/
  723C/7253/725A; 7F:49AE-4BBC is a clone of the executed reader 7F:430D-431E).  Note that the executed function 7F:4956 itself has no static
  caller, so "no caller found" is weak evidence in both directions.
* Table_7F_499C / 49A5 notes claimed the reader at 7F:49F3-49FB was executed; it is not (7F:4311/4319 is executed, 49FA/4A02/4B03/4B0B are clones).
* 4E:4E40 (code) had been named as an object table; the table is 72:4E40 (docs, 4A:4000 note).
* 5C:5144 (`$0020`) reclassified: slot 32 of the index space whose slots 33-37 are 5C:5146; the mode-2 list selects those 5 slots.
* 4E:654B note: some sites index with hD2 instead of wRam_C2C2.
* Statuses of former CONFIRMED read-data fragments that were merged into larger PROBABLE structures (e.g. 47:4E50-5850 gfx, 5C:504D lists,
  7F:7385 rows) went from CONFIRMED to PROBABLE (the classification is PROBABLE; the fact that executed code read the bytes is kept in the
  region notes only where the classifier wrote it).  This is a conservative loss of information, not an error.

