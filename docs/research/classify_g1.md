# Classifier 1/6: UNCLASSIFIED spans of banks 0F 2E 46 47 4A 4E 51 5C 5D 72 7E 7F

### 4E (1441 bytes; 9 remain)

41E0-45F8 (1048 bytes) = 41 cursor groups: BG-map offsets through `$FFFF`, then one slot-byte increment word; the reader at 45FE copies tile/attribute pairs and advances the cursor (static layout CONFIRMED, preview purpose HYPOTHESIS; see `japanese_frame_wipe_cursor_contract_20261023.md`). The six bytes 45F8-45FE are post-terminator words with unknown purpose. Also: descriptor table 654B (finding 2); code 4000 (1 insn, HYPOTHESIS), 47EB (SRAM record copy, HYPOTHESIS), 5D70 (head
of the copy_tilemap_rect_pair call site 5D93: `ld bc,$1214 ; ld de,$D000`, PROBABLE), 6087 and 6172 (HYPOTHESIS).
Remaining: 5390 (1 byte `pop bc`), 6543-654B (8 bytes `08 08 0D 0E 0F 08 08 08`).

### 51 (8 bytes), 5D (7 bytes)

Zero runs (padding before tile blocks / inside data), one `$FF` byte between `ret` and a function (51:740C, HYPOTHESIS).

### 5C (407 bytes; 2 remain)

See finding 4: record table (CONFIRMED structure: executed search loop), 20 triple lists, `5C:50F5` mode-2 list, message table 5104 (32 entries, entry 0 null), digit tile-pair table 545B, zero padding 5D86.

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

Corrections made: * 2E:4EB2, 2E:4F9A, 7F:4000 (and the 6-byte block 7E:7DDF) had status PROBABLE without any caller, table entry or code flowing into/out of them;   downgraded to HYPOTHESIS (bytes that only decode are not code).

* 4E:4E40 (code) had been named as an object table; the table is 72:4E40 (docs, 4A:4000 note).

* 5C:5144 (`$0020`) reclassified: slot 32 of the index space whose slots 33-37 are 5C:5146; the mode-2 list selects those 5 slots.

* Statuses of former CONFIRMED read-data fragments that were merged into larger PROBABLE structures (e.g. 47:4E50-5850 gfx, 5C:504D lists,   7F:7385 rows) went from CONFIRMED to PROBABLE (the classification is PROBABLE; the fact that executed code read the bytes is kept in the   region notes only where the classifier wrote it).
