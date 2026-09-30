# Classification pass g5: banks 1D, 22, 29, 2A, 2B, 43, 48, 50, 67, 74

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Scope: the 215 UNCLASSIFIED spans (19 712 bytes) that `analysis/mapper/unknown_spans.tsv` listed for these 10 banks.
Owner files: `config/regions/bank{1D,22,29,2A,2B,43,48,50,67,74}.tsv` (only these were edited).  Every edit was verified with the safe
protocol (copy of `config/`, `python3 tools/gen_asm.py verify --config <copy>` = IDENTICAL, `tools/conventions_check.py --regions`
= 0 ERROR) and then copied back; after the copy `verify --config config` is IDENTICAL again.  `src/` was not touched (needs `make regen`).

Evidence vocabulary as everywhere: CONFIRMED / PROBABLE / HYPOTHESIS.  **Result: 0 UNCLASSIFIED spans remain in these banks.**
That does *not* mean everything is established: 1 635 of the 19 712 bytes ended as HYPOTHESIS code (unreferenced functions and dead
compiler fragments, see 4) and 247 bytes as HYPOTHESIS data (animation scripts, blank strings, one orphan animation object), and the byte-exact tile/tilemap bounds of bank 43 are PROBABLE only (no loader was found).

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

(Per-bank byte counts are those of `unknown_spans.tsv`; the remaining UNCLASSIFIED count is 0 for all 10 banks.  Verifier: the status column was recomputed from the final config by script; the kind columns are the author's and were not re-tallied, banks 29 (zero 17 -> 9 after the 5AD0 palette merge) and 50 differ slightly.)  Bytes that were *not* UNCLASSIFIED but whose kind changed because the old heuristic regions were wrong or fragmented:
bank 43 (whole bank re-tiled, see 3.6: 1 690 old `zero` bytes -> tiles, 361+360 old `gfx` bytes -> tilemap/attrmap, 408 palette bytes re-bounded),
bank 50 (old `gfx` 5821-5A20 -> the 8th tilemap/attrmap pair + 6 zero bytes; old palette 6BC0-6CC0 re-bounded), bank 2A (200 palette bytes
re-bounded, 204 bytes of SRAM-address tables, 112 zero/blank bytes inside tile data), bank 2B (152 palette bytes re-bounded, 243 blank tile
bytes typed `zero` -> gfx), bank 48 (font block, see 3.7), bank 74 (72 bytes of pointer tables), bank 1D (1 092 bytes re-typed tilemap/attrmap).

## 2. Method

For each span: (a) references (`ld hl/de/bc,imm`, far-call operands `CD D1 06 dw bank`, table words, raw word scans of the ROM, executed reads
`traces/detail/*/dataaccess.tsv`), (b) the caller's use of the address (which loader / helper receives it: 00:08EA tilemap loader, 00:0749
HDMA, 4F:4000 palette upload, 00:0A65/0A82/0AB8 sprite-slot init, 00:0ED3 text interpreter, `jp hl` and `push bc; ret` dispatchers), (c) the bytes
(rendered as 2bpp tiles / 1bpp glyphs and looked at, RGB555 validity, 20-column row structure, cp932 decoding, linear decode with junk/bad-target
statistics), (d) tiling checks: every table target must be an item start, extents must end exactly where the next proven region starts.
Code was accepted only with an entry (caller, validated table entry, fall-through into/out of proven code); otherwise HYPOTHESIS (see 4).

## 3. Findings by bank

### 3.1 Bank 1D (84 bytes, all resolved)
* `4891-4D11` is a run of screen-part maps, not opaque data: `ld hl,$4891` (1D:42E1) and `ld hl,$4A71` (1D:4357) with `ld c,$0A` (10 columns);
  executed reads walk 10-byte rows.  Two 10x24 tile+attr pairs (`4891/4981`, `4A71/4B61`) and one 96+96 pair (`4C51/4CB1`, `ld bc,$0608 ; ld de,$D0C1` at 1D:43BC)
  that ends exactly at the padding 4D11; the previously unresolved 4945-4963 and 4A35-4A53 were map rows.  (PROBABLE, executed reads support the row layout.)
* `430D/4383` = 8-word tables (row*32+9 offsets added to $D000) + 8-byte index table each; `4D11-4D20` zero padding.

### 3.2 Bank 22 (175 bytes)
* Data: `4C5B/4DA6/4EE9` are one 7-byte template copied by a `ld b,7` loop to $D624 (PROBABLE); `4A8C` is a NUL-terminated Shift-JIS string (5 x `82 4F`) copied to $D524 by the loop at 22:4983;
  `4468` is a string of 18 full-width spaces (HYPOTHESIS, no reference); `510B` zero padding.
* Code: `48CD-48FE` is the prologue of the function that runs into the far-call site at 48FE (PROBABLE, entry unknown); `50CF-50FC` are two unreferenced functions (HYPOTHESIS);
  `47DD` (`ret`), `4BB5/4D00/4E41` (`jr` after an unconditional `jp`) are dead compiler fragments (HYPOTHESIS).

### 3.3 Bank 29 (1 415 bytes)
* `6290-64F4` (612 bytes) is a **sprite-animation resource block** in the format of the slot initialiser 00:0A82/0AB8 (entry = 4 bytes: frame-table pointer, script pointer; frame table = word list;
  frame = count + count x (y,x,tile,attr); script = count + count x 2 bytes).  Every pointer lands on an object start and the objects tile the block exactly (2 entry tables of 12 and 40 entries,
  frame tables, frames, scripts, 8 zero bytes; verifier: one exception, the object `63F0-6406` (frame table + frame + script) is referenced by no entry and is kept as an orphan, HYPOTHESIS).  See also bank 50:6CC0 (same format, hand decoded).  PROBABLE (frames/tables), HYPOTHESIS (script byte meaning).
* `5090-5376` (742 bytes) decodes as a coherent library (LCDC bit toggles, OAM clear, PRNG `hl=hl*5+$3711`, wait LY=$90, ROM bank write at 510F, CGB palette fade with the $DBD0 buffer) with a consistent internal call graph,
  but has no caller in the ROM, and its `call $7BB7` lands in this bank's zero padding: kept as **code, HYPOTHESIS**; it may be dead code or an image meant to run elsewhere (RAM/another bank).
* Small: four 11-byte strings (`81 48` x5 / `82 4F` x5 + NUL, loaded by `ld hl`), palette `5AD0-5B10` (64-byte upload, the 56 zero bytes are part of it), two zero paddings.
* Verifier fix: the tile block loaded by the HDMA at 2F:5990 is `5B10-5E10` (48 tiles, $30 blocks) and the palette loaded at 2F:59A2 is `5E10-5E50`; the old split (`5B10-5E0C` / `5E0C-5E4C` / `5E4C-5E50`) was 4 bytes early.

### 3.4 Bank 2A (1 910 bytes) and 3.5 Bank 2B (2 797 bytes)
Both banks are "screen packages": tiles (HDMA call sites in the code), tilemap+attr pair(s) (00:08EA / `copy_tilemap_rect_pair`), palettes loaded with `ld bc,$0040 ; ld hl,X ; ld a,bank ; far 4F:4000`, and an
animation block (same format as 3.3).  What was resolved: the palettes that the old heuristic clipped (2A 4FA0/51E0/6E10/75A0, 2B 63F0/76A0/7860) now have their `$40`-byte bounds from the load sites;
the tile blocks that had been split by `zero`/`$FF` runs are merged (2A 4AA0-4CD0 = `ld c,$23`, 2A 4FE0-51E0, 2B 6DD0-71D0 `c=$40`, 71D0-73D0 `c=$20`, 76E0-7860 `c=$18`);
the animation blocks are 2A 5220-5495 and 6E50-6F95, 2B 51D0-53C3, 6430-6482 and 78A0-7B02 (tilings exact, the old "palette" 7888-7988 in 2B was really anim entries);
the SRAM record-base tables ($A124..$AE13 step $12D, and $A69D..$A82D step $50) that the compiler emits after each function are `words` regions (referenced by `ld hl,table ; add hl,bc`);
2B 562B (VRAM tilemap addresses `$9861..`) and 47D0 (4 string pointers).  Code: dead fragments/unreferenced prologues are HYPOTHESIS (14 fragments in 2A, 9 regions in 2B, incl. the switch-like function 2B:687C-6909 whose inner blocks are reached by in-span `jr nz`).

### 3.6 Bank 43 (6 615 bytes)
No code and no ROM reference to bank 43 exists (no far call, no `ld hl` with `ld a,$43`).  Content decides: the bank is **4 identical packages of $0D50 bytes** at `4000, 4D50, 5AA0, 67F0`
(the last ends exactly at 7540 where the trailing zero padding starts): 160 tiles ($A00) + 20x18 tile map (360) + 20x18 attribute map (360) + 64 RGB555 words ($80).  Checks: all four palettes start
`$7FFF,$011C,$7E02,$0000` and have bit15 clear; rendered with its own tilemap, attribute map and palette each package is a complete, legible 20x18 screen (verifier, rendered with the tile index taken directly from the tilemap and the palette from the package: package 1 = green tree frame with `START メニュー` / `B もどる`; package 2 = yellow frame with two small animal characters and `START MENU` / `B BACK`; package 3 = green bush frame with one character and `スタート メニュー` / `B もどる`; package 4 = yellow-green leaf/flower frame with `START MENU` / `B BACK`; the wide inner areas of packages 2-4 are a repeating fill pattern), which validates the tile/tilemap/attrmap/palette split.  The earlier remark 'tilemap rows are left/right symmetric frames (corner tiles 00/01/02)' is RETRACTED (0 of 18 rows are symmetric in packages 1, 3 and 4).  The old heuristic (`gfx 4990-4CD0` covered a tilemap; palettes were clipped; hundreds of "zero runs" were tile or tilemap rows) was replaced.  PROBABLE, because the loader that
selects a package is unknown; the 18-byte zero + 2-byte pattern in the old listing is the sparse tilemap of package 2.

### 3.7 Bank 48 (112 bytes) - a font, not 2bpp tiles
`4810-4899` is a table of 27 five-byte records (key16 = SJIS code where a glyph run starts, bank byte $48, run pointer16), descending keys, terminated by $FFFF; it is read by the executed glyph fetcher `Function_48_4748` (loop at 48:4777).
The pointers ($4ADB=$824F digits, $4B7B=$8260 Latin caps, $4D1B=$8281 Latin lowercase, $4EBB=$829F hiragana, $53EB=$8340 katakana, $593B=$8140 symbols, ..., $5D7B=$83BF) differ by exactly 16 bytes per code
(e.g. $A0 = 10 digits).  The block `4ADB-5DCB` is therefore 303 **8x16 1bpp glyphs** (the fetcher at 48:47D6/47EE doubles each byte into 2bpp): the old `gfx` region (2bpp heuristic) was split into 27 `Font_48_XXXX` runs.  The two remaining spans
are unreferenced functions (`48BC`, and `4A8C` = byte-identical copy of ROM0 `00:091C`), HYPOTHESIS.

### 3.8 Bank 50 (5 365 bytes)
* `438A-5A1A`: `Table_50_4244` (8 words, indexed by `wRam_C1CD-1` at 50:4254) selects one of **8 screen maps of $2D0 bytes**: a 20x18 tile map and a 20x18 attribute map, copied by `Function_00_08EA` (`bc=$1214`, dest stride 32) to $D000 and $D400.
  `438A` is the 8-word table of WRAM addresses used at 50:4352.  The old `gfx` region 5821-5A20 was really the 8th map pair (+6 zero bytes).
* `6BC0-6CC0` palettes (loaded `$40` bytes from `$6BC0` and `$6C40` via 4F:4000), `6CC0-6D1E` = 2 sprite animations + `Table_50_6D16` (used as DE of 00:0A82, 50:414F).  Same animation format as 3.3.

### 3.9 Bank 67 (833 bytes)
Bank 67 is a chain of state-handler functions dispatched by `[$C27D]`: the "code-prefix" spans were (i) **jump tables inlined after `jp hl` dispatchers** (`546C`, `55B8`, `5F0A`: 3/3/2 words, extent = first target, targets validated) followed by the code they enter (PROBABLE);
(ii) per-function coordinate tables (2-byte entries stored into the sprite slot by 00:0A65), text-buffer WRAM pointers (`50A5`), SRAM address tables (`56FA` three 3-word tables), tilemap source tables for banks 4D/4B (`491C`, `5104`, `53D6`; cross-bank hint: 4D:5AE0/5B6C/5BF8/5C84, 4D:7870/78C0/7910, 4B:76C0/76C4/76C8 are tilemap sources for 00:08EA);
(iii) `5A9E` state table has a 6th entry ($5CC2, state 5 is set at 67:5CB2) - the 2 UNCLASSIFIED bytes; (iv) 6 unreferenced whole functions (424A, 4571, 4940, 4BC2, 580C, 67DB) and 5ED1: HYPOTHESIS; 5664 is called from the table-entered code (PROBABLE).

### 3.10 Bank 74 (406 bytes)
`4000-4165` is the **HTML tag/attribute/entity lookup** of the homepage renderer: pointer lists (`dw ...,0`) each followed by `[ASCII name][NUL][value byte]` items ("ng"/"ok", entities `lt gt amp quot nbsp` -> `< > & " space`,
attributes `ppp_id r_code d_code clear width align href name src left right all top center middle bottom`, tags `html title head body center div br hr img a b ul ol li ! meta pre` = ids 1..$11).  All pointer targets are item starts and the items tile up to the code at 4165 exactly.
`44A0` = 18-word tag-id jump table (`push bc; ret` dispatcher at 74:449E, executed; 18/18 targets are code starts, CONFIRMED); `511A` = the same idiom (PROBABLE) whose last target `51E4` becomes code;
`5905` = URL scheme list (`http` -> 1, `https file mailto ftp gopher news nntp telnet wais prospero` -> $FF); `59D8` = `http://`; 2 dead single-instruction fragments (HYPOTHESIS).

## 4. What is HYPOTHESIS and why

* Code without an entry (1 635 bytes across 22, 29, 2A, 2B, 48, 67, 74): each was accepted only if the linear decode is legal to the boundary, every direct target is a known instruction start, it starts after a `ret`/unconditional jump
  and ends in a terminator or falls into proven code, and nothing in the ROM (branch scan of all code regions, word scan, far-pointer scan, `ld r16` scan) targets it.  Typical case: the compiler-emitted dead `jr`/`ret` after an unconditional jump and
  unreferenced sibling functions.  Revert to `data` if a later stage finds them to be data; bytes are unchanged either way.
* `29:5090-5376`: see 3.3.  * Animation scripts (byte meaning unverified).  * `22:4468`, `2B:5807` blank strings (no reference).

## 5. Not done / open

* Retracted (verifier): 'no PROBABLE code region has an executed start' was true only for the union of the first scenarios.  With all 24 `traces/coverage_*.tsv` files, 20 non-CONFIRMED code regions of these banks are fully executed (22:5077-5093, 22:50FC-510B, 29:46A1-46B9, 2A:422C-4274, 2A:722D-7287, 2B:6482-64F1, 2B:7B02-7D7A, 2B:7D92-7F44, 48:49B6-49C3, 50:4254-42AC, and ten small ones in bank 74) and 31 more are partly executed; promotion is left to `tools/apply_coverage.py` (no executed start lies in a non-code region, none is misaligned).  Original statement: no upgrade to CONFIRMED was possible; no existing code region was demoted (the linear-decode `bad` flags left in a few regions are the inline far-call bytes).
* Bank 43: who loads the four packages (and which tile counts each loader sends) is unknown.
* Bank 29:5090 library: entry/consumer unknown.
* Animation script format `count + (?,?)` and the `3-byte 01 00 04` scripts are undecoded beyond structure.

## 6. Adversarial verification (independent re-derivation)

Re-derived from ROM bytes / traces, not from this document: 20 claims over all ten banks.  Tools: `git show HEAD:` old tables vs new (no code region became data, no tiling hole or overlap, no label rule broken), union of all 24 `traces/coverage_*.tsv` (0 executed starts in a non-code region, 0 misaligned), direct-target scan of every code region (only two targets are not instruction starts: 29:5120 `call $7BB7` into zero padding, and 2A:5760 `call $4441` inside older PROBABLE code, both outside this pass's decisions), table entries checked against instruction starts, `traces/detail/*/dataaccess.tsv` read ranges against every non-code region.

Upheld: bank 43 layout (four $0D50 packages: rendered all four as coherent 20x18 screens), bank 48 font (27-record table read by 48:4748, run sizes = pointer spacing, 303 glyphs rendered, SJIS keys decode to the expected characters, 48:4A8C = copy of 00:091C), bank 74 HTML tables (all pointer lists tile the items, 44A0/511A targets are code starts, dispatcher `push bc ; ret` at 74:449E/5119), bank 50 screens (Table_50_4244 entries = 439A + n*$2D0, 00:08EA copies b rows x c columns twice, second copy at dest+$400, browser_pages reads exactly screen 4), bank 1D maps (`ld c,$0A`, attr pointer = tile pointer + $F0), bank 22 templates/strings, bank 2A/2B HDMA tile counts (c x 16 bytes, checked at 2A:4146, 2B:6603/662C/6641 and 2A:4158..), palettes (2A 4FA0/6E10/75A0, 2B 63F0/76A0/7860 = exact $40 loads), bank 67 jump tables and the 6th state entry, SRAM address tables, the animation format (00:0A82/0AB8/0AE8 read: entry = 4 bytes, script = count + 2 x count, frame table of pointers, frame = count + 4 x count), HYPOTHESIS code (each decodes to its end, follows a terminator, no referrer).

Corrected here: bank 43 'symmetric rows' remark (false); orphan animation objects 29:63F0-6406 and 2A:545C (not referenced by any entry, note and status fixed); 29:5B10/5E10 tile/palette boundaries (4 bytes early), 29:5AD0 palette length (64 bytes); 74:511A 'not executed' (its dispatcher is executed in the browser scenarios); 50:4C0A/4D72 raised to CONFIRMED (executed read of exactly that pair); bank 50 palette load sites (four, not two); 29:5090 (extra evidence it is not live code: `ld [$0C0E],a` PRNG state in ROM space); 67:424A (two ROM0 trampolines jump to its instruction starts but nothing calls them).
Judgement call kept: 22:48CD-48FE stays PROBABLE code although its entry is unknown (the function it falls into, 48FE-4A8C, is PROBABLE for the same reason and the two decode as one coherent function).
