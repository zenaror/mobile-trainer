# Classifier 3/6: resolution of UNCLASSIFIED spans in banks 04 1A 1B 2D 41 58 5E 65 69 6B 6C 70 7C

Scope: `config/regions/bank<NN>.tsv` of exactly these 13 banks.  Input: the UNCLASSIFIED spans (381 spans, 19 712 bytes in these banks) of `analysis/mapper/unknown_spans.tsv`
(19 712 bytes in these banks).  Result: **0 bytes left UNCLASSIFIED** in these banks; every edit was verified with
`python3 tools/gen_asm.py verify --config <scratch copy>` (byte-identical rebuild) and `tools/conventions_check.py --strict`
before the bank file was copied into `config/regions/`.  `make regen` was not run (the orchestrator does it once).

Evidence vocabulary as everywhere: CONFIRMED (executed / byte-exact), PROBABLE (strong, usually an exact structural fit that
cannot be chance), HYPOTHESIS (coherent but unproven).  Nothing was named beyond generic role labels (`Tiles_`, `Tilemap_`,
`Palette_`, `Table_`, `String_`, `Data_`).

## 1. Bytes moved out of UNCLASSIFIED

| bank | span bytes | code | data | gfx | text | ptrtable | words | zero | left | HYPOTHESIS part |
|---|---|---|---|---|---|---|---|---|---|---|
| 04 | 2 358 | 428 | 1 856 | - | - | 66 | 8 | - | 0 | 6 |
| 1A | 155 | - | 24 | - | 73 | 58 | - | - | 0 | 0 |
| 1B | 42 | 10 | - | - | 32 | - | - | - | 0 | 10 |
| 2D | 1 037 | 887 | 49 | - | 49 | - | 48 | 4 | 0 | 62 |
| 41 | 7 547 | - | 2 127 | 5 420 | - | - | - | - | 0 | 0 |
| 58 | 3 116 | - | 60 | 3 056 | - | - | - | - | 0 | 0 |
| 5E | 16 | - | - | - | - | - | - | 16 | 0 | 0 |
| 65 | 263 | 122 | 75 | - | - | 36 | 30 | - | 0 | 64 |
| 69 | 897 | - | 877 | - | - | 20 | - | - | 0 | 0 |
| 6B | 5 | - | 5 | - | - | - | - | - | 0 | 0 |
| 6C | 559 | 24 | 174 | - | 361 | - | - | - | 0 | 0 |
| 70 | 3 705 | 217 | 3 281 | - | - | 194 | - | 13 | 0 | 217 |
| 7C | 12 | 12 | - | - | - | - | - | - | 0 | 5 |
| total | 19 712 | 1 700 | 10 528 | 8 476 | 515 | 374 | 86 | 33 | 0 | 364 |

The 364 HYPOTHESIS bytes (354 as delivered, +10 after the adversarial review: 1B:4040-404A was downgraded) are all `code` regions whose bytes decode cleanly to a terminator but for which no caller, table word,
far-call site or executed path was found (details in section 4).  Everything else is PROBABLE, or CONFIRMED where an
executed read or a CONFIRMED loader call already existed and only the kind changed.

Extra: 5 PROBABLE code regions of bank 2D (40DC-417D, 46E9-470A, 65FD-6603, 6973-69B3, 69DF-6A07; 92+15+2+29+17 instructions)
were upgraded to CONFIRMED because every instruction start is present in `analysis/coverage_union.tsv` (it contains scenarios
added after the mapper run: mail_inbox, mail_send, addressbook_full).  No other PROBABLE code region of these banks is fully
covered, and none decodes to an illegal opcode.

## 2. Methods that carried most of the volume

1. **Whole-bank structure (bank 41).**  Rendering the bank as 2bpp sheets and dumping 20-byte rows showed four screens; the
   record length `$D50 = $A00 (160 tiles) + $2D0 (20x18 tilemap + 20x18 attribute map) + $80 (16 CGB palettes)` tiles the bank
   exactly from 4000 to 7540 (start of the zero tail).  85 CONFIRMED `copy_tilemap_rect_pair` blocks elsewhere in the ROM
   have the same `$2D0` shape (`analysis/gfx_candidates.tsv`).  No code references bank 41 (never executed, no `ld a,$41`
   anywhere), so PROBABLE at best.
2. **Animation/OAM records (banks 69 and 70).**  `00:0A82` (init_object_from_table) and `00:0AB8` read a table of 4-byte entries at
   DE (word 0 -> slot+2/3, word 1 -> slot+8/9 and then bytes at +1..).  Following the pointers gives a fixed grammar:
   entry = (list-of-frame-pointers, count-prefixed 2-byte pairs); list = words; frame = `count` then `count` x 4 bytes.  A small
   parser (`parse_anim` in the scratch tooling) tiles 4778-4C46 of bank 69 and 4832-5483 of bank 70 **exactly** (every pointer
   lands on a record start, the records end where the next begins; only 1 + 3 stray bytes needed a note).  Two executed
   callers in bank 70 (`ld de,$534C` at 70:45B1, `ld de,$53EB` at 70:415C, a=$70, then `call 00:0A82`) make those two tables CONFIRMED.
3. **Tables the traces only partly read (banks 04, 65, 6C, 58).**  The mapper turned every unread byte of a table into a 1-8 byte
   UNCLASSIFIED hole.  Periodicity of the holes (stride 6 or 8) plus the table content identified the tables (bank 04 sound tables,
   bank 65 6-byte string-pointer records, bank 6C 5-byte records), and the holes were merged into their tables.
4. **Jump tables.**  `jp hl` dispatchers (`add a,a ; add a,LOW ; ld l,a ; ld a,HIGH ; adc a,0 ; ld h,a ; ld a,[hli] ; ld h,[hl] ; ld l,a ; jp hl`)
   in banks 04/65 with validated word tables; every table word was walked with a restricted recursive descent (illegal opcode
   or crossing a region edge = rejected) before its target hole was typed as code.
5. **Mutual validation code <-> strings.**  Bank 2D 4195/44FB/4635 (profile-default initialisers) load 30+ pointers with
   `ld hl,imm`; every one lands exactly on a record/string start of the independently detected text runs, so the routines are
   real code even though nobody calls them (no raw scan hit).

## 3. Per bank

### 04 (sound driver; 2 358 bytes, 0 left)
* **Code (428 B, PROBABLE):** 42C0-42D6, 444B-445C, 445C-449B, 44B1-44B7, 44CF-453A, 4819-483A, 4840-484E, 4908-4925, 4947-4955,
  4962-4970, 4991-4997, 49C3-4A24.  Entries: the ROM0 stubs `20B8/20D0/20D6/20DC/20E2` (`call 2116 ; jp 04:xxxx`, targets 42C0 444B 44B1 452C 445C; **none of these five stubs has a `call`/`jp` site anywhere in the ROM** - see section 5),
  the 7-word table at 44A3 (4819 4840 4947 4962 4991 4908 49CD, base loaded by `ld bc,$44A3` at 44C9 then `jp 45CD`) and the
  31+12 word jump table 46E8-473E (dispatcher 45CD = `sla a ; add a,c ... jp hl`, bases `ld bc,$46E8` at 45CA and `ld bc,$4726` at
  4750).  44CF is the target of four `jp $44CF` (4912 496D 4952 4994).  Restricted descent from these seeds covers every
  one of these spans exactly with no illegal opcode.
* **Tables:** 46E8-4726 (31 pointers) and 4726-473E (12) `ptrtable`; 44A3 (7) `ptrtable`; 449B-44A3 `words` (WRAM records D040 D07C D0B8 D0F4,
  stride $3C).  The mapper's 46F0/4706/4712/4724 holes and its partial tables were pieces of the 46E8 jump table.
* **Data 5044-7E8C (all PROBABLE):** 5044-5075 byte lookup table (49 bytes); 5075-51DD **note table**: 120 x (11-bit GB frequency
  word + 1 byte), frequencies non-decreasing 002C .. 07FE (002C = 65.4 Hz = C2, 12 per octave; strictly increasing up to entry 88, then 07F4-07FE repeat because the 11-bit period saturates); 51DD-547D **instrument table** 112 x 6
  bytes (last byte `3C`, the unread hole of every record); 547D-551D **10 wave-RAM patterns** x 16 bytes; 551D-574D **song table**
  70 x 8 bytes (word address, word ROM bank 4 or 5 = the 9-bit bank read via 00:215E, `FFC8`, word 1-4; the 24 bank-4 songs point into 574D-7E8C, the 46 bank-5 songs into bank 05, which is outside this task); 574D-7E8C sound
  bytecode streams (song-table addresses land in it).  The mapper's word tables at 5068, 78C8, 797C were false positives.
  Each boundary matches the next table exactly (5075+3x120 = 51DD, 51DD+6x112 = 547D, 547D+160 = 551D, 551D+8x70 = 574D).
* 415A-415F (`ld de,$D040 ; ld a,$08`, sibling of the executed 414C/4153, lands on the executed tail 415F) and 4D53 (`dec hl`
  before the executed 4D54): code HYPOTHESIS, no entry found.

### 1A (155 B)
The two-level string index is now fully typed: `Table_1A_4439` (11 pointers) -> 11 groups `count byte + count word pointers +
NUL strings`.  Validation: for all 11 groups the end of the header equals the first pointer target, and all targets are string
starts (one exception is a mapper text run that swallowed the header, see below).  Resolved: 437B-4391 (11 index/value pairs),
the 4439 table, headers of groups 44E0 453F 45A8 4608 4705 4736, strings 449D 44F1 4637 470A 477E-47A4.  The headers of
groups 456B, 46F9, 471E had been swallowed by the following text runs; they were carved out (text runs now start at 4574,
46FC, 4721).

### 1B (42 B)
4040-404A code (function head `xor a ; ld bc,$00FC ; ld hl,$C0D4 ; call $04D8` that falls exactly into the raw far-call site at 404A);
4430-4450 = 16 fullwidth SJIS hex digits `０..９Ａ..Ｆ` referenced by `ld hl,$4430` at 1B:43A2, 43B5, 43CD, 43E0.

### 2D (1 037 B; profile defaults in SRAM, SRAM erase, text)
* 417D and 470A: **two copies of a 12-word SRAM address table** (A124 A251 ... AE13, stride $12D = one profile record) used by
  `ld hl,$417D` at 4149 / `ld hl,$470A` at 46F4.
* 4195-42B2, 44FB-45A6, 4635-465E, 4686-46A1: the routines that copy the default profile ("マリオ", mario@mario.ne.jp,
  abc@a.b.c, nintendo88@..., missinglink.co.jp addresses) into SRAM through the strcpy helper 42AA (20 callers).  The 9-byte
  default records (42B2 42F8 436A 441B 44D3), the short strings (42D0 44DC-44FB 462A) and the text-run start of 4424 were
  re-cut.  All PROBABLE (entry not located for the four routines).
* 4CDA-4E42: an 8-way compare chain (`cp 0 ; jp z,4D04 ; cp 1 ; jp z,4D24 ...`) whose targets are exactly the ten-byte holes in
  front of eight raw far-call sites (00:0A82).
* 4E42-4E8C two small routines with an internal call target, 7E60-7ECD complete SRAM-erase routine (4 banks x $2000).  Small unreached fragments (1-9 bytes: single `ret`, `pop bc ; ret`, SRAM-disable epilogues, `jp` tails) are
  HYPOTHESIS code (62 bytes).  55DA-55DF is a 2-byte-entry list read by Function_2D_553D; 5ABD/711F are zero padding.

### 41 (7 547 B, gfx bank; never executed)
Four screen records (see section 2): `Tiles_41_{4000,4D50,5AA0,67F0}` (gfx), `Tilemap_41_{4A00,5750,64A0,71F0}` ($2D0 each),
`Palette_41_{4CD0,5A20,6770,74C0}` ($80 each).  Rendered sheets confirm tile art (frames, digits, glyphs).  PROBABLE.

### 58 (3 116 B; title/registration text banners)
4000-7B50 is one tile area (rendered: Japanese banner text, digits, frames); executed HDMA source ranges (`traces/detail/*/dataaccess.tsv`) are
16-byte aligned to it, so the unread gaps 4450-46D0, 4E50-5350, 5850-5AD0, 7460-7650 are tiles; the "read as data, class
unknown" regions were re-typed `gfx`.  7B50-7B78 five CGB palettes (read together with the tilemap: 7B50-7E48 in one read),
7E48-7EA0 = 22 four-byte digit-glyph records (top tile, bottom tile, attr, attr) which bank 65's table at 65:4B78 addresses exactly
(7E48 + 4k).

### 5E (16 B)
Two 8-byte zero paddings between a 5x20 tilemap+attr block (200 bytes) and the following tile block.

### 65 (263 B)
* 4055-4123: the three `jp hl` dispatchers at the head of the bank and their word tables (406E, 40C5, 4119; 5 words each), their
  targets (4055 4058 408E 40A6 40B3 40BC 40E2 4107) typed as code.
* 46FF-473F: two 32-byte siblings of the executed Function_65_473F, code HYPOTHESIS (64 B).
* 4A81-4AD7 descriptor table; 4B78-4BA8 `Table_65_4B78/4B7C/4B92` (two lists of eleven bank-58 addresses 7E48-7E9C); 4BC6, 4BE2 records: 24 pointers,
  every one on a string start of `analysis/strings.tsv`; 567F-56A7 20-pointer string table (all targets are string starts).
  The mapper text run at 4C6C began two bytes early (`24 56` is the 24th record pointer): now 4C6C data + text from 4C6E.

### 69 (897 B)
Object/animation structure of section 2 (`Table_69_4778` etc., 37 records, 4778-4C46); 4760-4778 three RGB555 palettes.  The mapper's
"168-word palette" claim for 4760-48B0 was wrong beyond 4778 (that is the table + frame data).  PROBABLE (the table start is the
`de=$4778` of the executed-code call at 4E:6057, index and record grammar as read by 00:0AB8).

### 6B (5 B)
4D1B-4D20 BGP fade table `00 40 90 E4 D9` (loaded by `ld hl,$4D1B` at 4D00, used with `cp 4`, i.e. entries 0-3).

### 6C (559 B; script text in the "second convention")
Message records `06 xx FF 03 aa bb <text> 00`: holes 5216 52B2 533A 54D3 556B were unanchored records -> `text`; 5427, 56E8, 58BA-5987
are control records / the kana grid; the small holes between read pieces of 4525, 4747, 4809, 516F, 5F6E were merged into their
data blocks (tables of 5-byte records); 61AC-61C4 coherent routine falling into the far-call site at 61C4 (`call 00:0A65`).

### 70 (3 705 B)
* 4832-5483: six animation tables (4832, 4C5C, 4DBB, 5272, 534C, 53EB) with their lists and 88 frame records, tiling exactly; 534C and 53EB are
  CONFIRMED by executed callers, the others share the format (no executed caller found).
* 4822 table (8 pointers) -> 7090-7590: eight 20x4 tilemap+attr blocks (`bc=$0414`, Function_70_4803 -> 00:08EA), CONFIRMED for the four read in traces.
* 6A90-7090: the mapper's tiles-vram block 6A90-6E90 (HDMA length $400) overlaps palettes (6C90-6D10, copied by 4F:4000 calls with bc=$0040)
  and the 32x14 tilemap+attr at 6D10 (00:08EA, CONFIRMED); by content only 6A90-6C90 are tiles, the rest was re-typed
  (`Palette_70_6C90/6CD0`, `Tilemap_70_6D10`).  The HDMA over-read is noted in the region.
* 46A6-477F: five SRAM-helper functions, code HYPOTHESIS (217 B): clean decode to `ret`, shape shared with many executed routines,
  but no caller anywhere (raw scan of the whole ROM).

### 7C (12 B)
`jp head` after the inline `call $0545` tables at 7B8E, 7BC9, 7D60 (same shape every time); the mapper counted 7D60 with 7 entries by reading the
operand of that jp as a word - corrected to 6 entries + `jp $7D57`.  7D8B and 7DFC HYPOTHESIS.

## 4. What is weaker than it looks (read before relying on it)

* **HYPOTHESIS code (364 B)** = 04:415A 04:4D53 (6 B), 1B:4040-404A (10 B), 2D single-instruction holes (62 B), 65:46FF-473F (64 B), 70:46A6-477F (217 B), 7C:7D8B/7DFC (5 B).
  They decode legally and end at a terminator, but no entry was found.  Change them back to data if a later stage proves they are not code.
* **Structure claims without loader evidence:** all of bank 41 (never executed), the bank 04 table field meanings, the OAM field order
  (`y,x,tile,attr` is only the usual shape of a 4-byte OAM entry), the bank 65 descriptor table 4A81, bank 6C control records.  The
  *extent* of each block is what is claimed, not its field semantics.
* `ptrtable`/`words` regions with bank-58 or SRAM addresses are typed `words`, not `ptrtable`, to keep the generator from substituting
  labels of the wrong bank.
* The mapper's `analysis/mapper/unknown_spans.tsv` is unchanged (the generator input is `config/regions`); re-running the mapper would
  regenerate the old proposals, which must not be merged over these banks.

## 5. Adversarial verification (independent re-derivation)

A second pass re-derived the claims from the ROM bytes (own scripts, not the classifier's tooling) and reran `tools/gen_asm.py verify`
(IDENTICAL) and `tools/conventions_check.py --strict` (0 errors) on the real config and on the corrected copy before writing back.

**Re-derived and upheld (21 checks over 13 banks)**

| # | check | result |
|---|---|---|
| 1 | 04 ROM0 stubs 20B8..20E2 decode to `call 2116 ; jp 04:xxxx` with the claimed targets; `ld bc,$44A3` at 04:44C9, `ld bc,$46E8` at 45CA, `ld bc,$4726` at 4750, all `jp $45CD` | yes |
| 2 | every word of Table_04_44A3 / 46E8 / 4726 is an instruction start of a `code` region of bank 04 | 7+31+12 of 50 |
| 3 | 04:449B WRAM record table used by `ld bc,$4499 ; sla a ...` (index 1-4, index 0 overlaps the operand of `jp $2141` at 4498) | yes |
| 4 | 04 note table 5075: 120 x 3 bytes, 002C = 65.4 Hz = C2, 12 per octave; instrument table 112 x 6 (byte 5 = $3C for 101 of 112); 10 wave patterns; song table 70 x 8 (bank word 4/5); 24 bank-4 songs start in 58BC-7E82 | yes (with the wording fix below) |
| 5 | 41: four records of $D50, tilemap indices < 160 in every record, rows of 20 visible, 4x record = 7540, tail 7540-8000 all zero; rendered tile sheets are real art | yes |
| 6 | 58: rendered 4E50-5350 and 7460-7B50 (Japanese banners and menu labels); 7E48 records `00 10 09 09 01 11 09 09 ...`; 65:4B78/4B7C/4B92 hold 7E48+4k, 7E74+4k | yes |
| 7 | 69/70 animation format: 00:0AB8 stores word0 to slot+2/3 and reads a count-prefixed list from word1 (00:0AE8 uses count + 2-byte pairs); frame records `1+4*count`; executed `ld de,$4778` at 4E:6052 (call at 4E:6057), `ld de,$53EB` at 70:415C, `ld de,$534C` at 70:45B1, all present in coverage_union; trace reads of 69:477C-4780 and 70:5350-5483 fall inside the tables | yes |
| 8 | 70:6D10 `ld hl,$6D10 ; ld bc,$0E20` at 70:45A0-45A5 (14 rows x 32 cols = $380 -> 7090); `ld hl,$6C90/$6CD0 ; bc=$0040 ; de=$D800/$D840` at 70:457E/458F; the two HDMA calls `c=$40` at 70:4560/4572 really cover $400 bytes (over-read is real, only noted) | yes |
| 9 | 70:4822 -> eight 20x4 blocks, stride $A0 = `ld bc,$0414` in Function_70_4803 | yes |
| 10 | 1A string index: all 11 groups, first pointer = end of header, every pointer on a string start | yes |
| 11 | 2D 4195-42B2: SRAM bank-0 select + `$0A -> [$0000]`, 9-byte copy, strcpy helper 42AA, tail far call 22:501D is the same tail as the executed 2D:40DC (22:5017 region is CONFIRMED code); tables 417D/470A = 12 words stride $12D | yes (one typo fixed) |
| 12 | 2D 4CDA 8-way `cp`/`jp z` chain (targets are the holes before the far-call sites), 4E42 (+internal 4E54/4E73), 7E60 4x $2000 SRAM erase | yes |
| 13 | 2D promoted regions 40DC-417D, 46E9-470A, 65FD-6603, 6973-69B3, 69DF-6A07: every instruction start is in coverage_union; the only uncovered "starts" are the 3 inline bytes after `call $06D1` | yes, CONFIRMED stands |
| 14 | 65 head: three `jp hl` dispatchers 4042/4078/40CF with tables 406E/40C5/4119, all 15 words land on code starts | yes |
| 15 | 65:4BE2: 23 six-byte records + lone word 5624 at 4C6C = 24 distinct pointers = the 24 strings of 4C6E-567F; second bytes are ids 02..17; 567F table 20/20 | yes |
| 16 | 6B:4D1B BGP table read by 4CF6 (`cp 4`), index [C0E8] | yes |
| 17 | 6C:5F6E 31 x 5-byte records (stride verified over all 155 bytes); records `06 xx FF 03 aa bb` + text ending in 00 | yes |
| 18 | 1B:4430 = "０１２３４５６７８９ＡＢＣＤＥＦ", loaded by `ld hl,$4430` at 1B:43A2 | yes |
| 19 | 5E zero paddings (generator-checked) sit between the 200-byte tilemap+attr blocks and 16-aligned tiles | yes |
| 20 | 7C 7B8E/7BC9/7D60 tables: 4/7/6 words, `jp head` (7B85 / 7BC0 / 7D57 = the `call $06D1` site right before each `call $0545`) follows each | yes |
| 21 | no coverage_union instruction start lies inside a non-code region of the 13 banks; no code region of these banks that was previously PROBABLE/CONFIRMED in the mapper was turned into data or lowered | yes |

**Corrections applied (files: bank04, bank1B, bank2D, bank41 region tables, this document)**

* **bank 04, stub claim retracted.**  The region notes said the ROM0 stub 20B8 had "14 raw call sites".  A scan for `CD B8 20` / `C3 B8 20`
  finds none (the 14 are bare word occurrences).  The same holds for 20D0, 20D6, 20DC, 20E2: none has a `call`/`jp` site anywhere; only 20BE (1B:4222/4258, itself PROBABLE code)
  and 20C4 (executed) are called.  The targets 42C0, 444B, 445C, 44B1 and 452C stay PROBABLE because the stub jump is a real instruction of a stub identical in shape to
  the executed one and each target exactly bridges CONFIRMED code, but their callers are unknown and the notes now say so.
* **bank 04 note table**: "monotone increasing over all 120 entries" was wrong: it is non-decreasing (07F4-07FE repeat from entry 88 on).  Note reworded.
* **bank 1B 4040-404A**: PROBABLE -> HYPOTHESIS (10 bytes; no entry, only leads into a far-call site; same class as 04:415A and 7C:7D8B which were already HYPOTHESIS).
* **bank 2D tables 417D/470A**: note said A706, bytes are `05 A7` = A705.
* **bank 41 tilemaps**: the note "attribute values $08-$0C" was true only for records 0 and 1; record 2 also holds $10 and record 3 holds $00 and $2A.  Notes now list the values present and say that the BG-attribute reading is assumed.

**Still weak (unchanged, honest status kept)**: all bank 41 kinds (nothing loads it; structure verified by content only), field semantics of every table, the PROBABLE
whole-function code without callers (2D 4195/44FB/4635/4686/4CDA/4E42/7E60, 6C:61AC), the `jp head` after inline `call $0545` tables (a `jp hl` dispatcher never returns to it),
unreferenced trailing bytes noted in 69 (4A04 = `00`; 4BA8-4BAB = `01 00 04`, which also parses as a count=1 pair block).
