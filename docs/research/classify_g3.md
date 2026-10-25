# Classifier 3/6: resolution of UNCLASSIFIED spans in banks 04 1A 1B 2D 41 58 5E 65 69 6B 6C 70 7C

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

* **Structure claims without loader evidence:** all of bank 41 (never executed), the bank 04 table field meanings, the OAM field order   (`y,x,tile,attr` is only the usual shape of a 4-byte OAM entry), the bank 65 descriptor table 4A81, bank 6C control records.

* `ptrtable`/`words` regions with bank-58 or SRAM addresses are typed `words`, not `ptrtable`, to keep the generator from substituting   labels of the wrong bank.

A second pass re-derived the claims from the ROM bytes (own scripts, not the classifier's tooling) and reran `tools/gen_asm.py verify`
(IDENTICAL) and `tools/conventions_check.py --strict` (0 errors) on the real config and on the corrected copy before writing back.

The same holds for 20D0, 20D6, 20DC, 20E2: none has a `call`/`jp` site anywhere; only 20BE (1B:4222/4258, itself PROBABLE code)   and 20C4 (executed) are called.

* **bank 1B 4040-404A**: PROBABLE -> HYPOTHESIS (10 bytes; no entry, only leads into a far-call site; same class as 04:415A and 7C:7D8B which were already HYPOTHESIS).

* **bank 41 tilemaps**: the note "attribute values $08-$0C" was true only for records 0 and 1; record 2 also holds $10 and record 3 holds $00 and $2A.

**Still weak (unchanged, honest status kept)**: bank 41 intended roles and paths beyond the finite fact that the 27 frame descriptors for styles 0..26 do not select the four candidate windows in that bank; field semantics of every table, the PROBABLE
whole-function code without callers (2D 4195/44FB/4635/4686/4CDA/4E42/7E60, 6C:61AC), the `jp head` after inline `call $0545` tables (a `jp hl` dispatcher never returns to it),
unreferenced trailing bytes noted in 69 (4A04 = `00`; 4BA8-4BAB = `01 00 04`, which also parses as a count=1 pair block).
