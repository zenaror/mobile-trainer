# Classifier 6/6: banks 1C 25 27 2C 2F 44 54 57 60 73 75

Evidence vocabulary as everywhere (`CONFIRMED` / `PROBABLE` / `HYPOTHESIS`); addresses are `bank:addr` CPU addresses.
Owned files: `config/regions/bank{1C,25,27,2C,2F,44,54,57,60,73,75}.tsv` (1C unchanged) and this document.
Every edit was verified with `python3 tools/gen_asm.py verify --config <dir>` (IDENTICAL, 2 097 152 bytes, sha256 `6d802e66...`) and
`python3 tools/conventions_check.py --regions <dir>/regions --strict` (0 ERROR, 0 far-pointer targets outside code) on a scratch copy,
then again on the real `config/` after copying the ten changed bank files.  `src/` was not touched (the orchestrator regenerates).

## 1. Result in numbers

Before: 19 711 bytes in 169 UNCLASSIFIED spans in the eleven banks.  After: **101 bytes in 32 spans** (19 610 bytes resolved).
Bytes that left UNCLASSIFIED, by new kind (status in brackets is the region status; "other data" = frame/attribute/packet/table bytes typed `data`):

| new kind | bytes | notes |
|---|---:|---|
| gfx (2bpp tiles) | 14 594 | 1 975 CONFIRMED (2F:61F0-69F0, executed `00:0749` loads) + 12 299 PROBABLE (bank 44 scenes, bank 60, 25:5F10-6410 loads, 2C:6FD0) + 320 HYPOTHESIS (five short bank-60 pieces) |
| other data | 2 404 | object-animation frame records, BG attribute rows/maps, MD5 constants, Mobile Adapter packets, blobs copied by `CopyBytes` |
| tilemap | 777 | 44 (4 scenes x 360) and 73 (two rectangles) |
| code | 735 | 657 PROBABLE + 78 HYPOTHESIS (chains, see 3.4; the 78 B are the entry-less stubs downgraded by the verifier, see section 6) |
| ptrtable | 396 | object tables (27/2C/2F) and string-pointer tables |
| words | 254 | SRAM record-address tables (25, 2F) |
| text | 258 | 54, 75, 2C:4878, 2F:6040 |
| palette (`data`, `Palette_` label) | 126 | 2C, 2F, 44 |
| zero | 66 | padding |
| still UNCLASSIFIED | 101 | see section 4 |

Per bank (bytes UNCLASSIFIED before -> after):

| bank | before | after | main result |
|---|---:|---:|---|
| 1C | 4 | 4 | nothing provable (table stub bytes) |
| 25 | 1498 | 11 | 8 SRAM address tables, 2 x tile loads (1280 B), string-pointer table, attribute rows |
| 27 | 418 | 9 | 14 object tables + frame data, 5 code chains, one tilemap row |
| 2C | 1506 | 26 | 5 palettes, object tables, frame data, 512 B tiles, 3 SRAM-code routines |
| 2F | 2670 | 45 | tile blocks 61F0-69F0 (1975 B), tables, palettes, strings, code chains |
| 44 | 5706 | 0 | whole bank re-laid out as 4 scenes (tiles + tilemap + attributes + palettes) |
| 54 | 233 | 5 | month/BCD tables, strings, game ID, code chain |
| 57 | 77 | 0 | 2 functions, padding |
| 60 | 6590 | 0 | tile sheet |
| 73 | 156 | 0 | tilemap rectangles, string-pointer table, tiny functions |
| 75 | 853 | 1 | MD5 constants, URL/command/header strings, Mobile Adapter packets, 2 routines |

In addition **41 PROBABLE code regions were upgraded to CONFIRMED** because every instruction start is in `analysis/coverage_union.tsv`
(region starts: 25:4CED 4E43 4F40 5581 5889; 27:41DB 427C 4812; 2F:4069 41AE 4455 44F8 451F 469C 46C8 46F4 4720 474C 4778 47C3 47D7 48AE 492E 497A 4997 4A83 4AEF 5098 713F 714B 722A 7311 733D 7399 73E9 765F 7F4E; 75:6404 6622 6809 6992; each note carries the sentence "upgraded by classifier 6").  No executed instruction lies in a non-code region of these banks, and no
PROBABLE code region of these banks has an illegal opcode or a direct branch/call target that is not an instruction start (checked with a
convention-aware sweep: bytes after `call $06D1` / `call $06BC` are inline data).

## 2. Findings that changed the picture

* **`00:0749` is a second HDMA loader.**  `tools/extract_gfx.py` only knew `00:0787`.  `00:0749` (boot_and_home.md, `Function_00_0749`) has the
  same register interface (A = source bank, HL = source, DE = dest, C = blocks of 16 bytes) and is called through `FarCall` (`cd d1 06 49 07 00`).
  Recovering the register immediates of the 700 `0749/0787/08EA` call sites (extract_gfx `recover_args`) gave the exact extents of the tile blocks
  25:5A10-6410 (four loads, the first two executed), 2F:61F0-69F0 (three contiguous loads, `$400+$100+$300`) and confirmed 25:5F10-6410 as tiles.
* **Palettes are loaded with `FarCall 4F:4000`** (a wrapper that calls `CopyBytes` 00:050C with WRAM bank 7), always `bc = $0040`, `de = $D800/$D840`
  (the WRAM palette staging buffers).  The sources are 64-byte blocks (8 groups of 4 RGB555 words): 2C:5670, 71D0, 7C00, 7F50, 7F90; 2F:6CC0; also 25:69B0/6EF0,
  27:74E0/7520, 2C:5100/6F90/7B30, 2F:7D90, 73:5DE0/5E20 (already classified data).  Three of the "code-like" hints in 2C/2F were really the first/last words of such blocks
  (`ff 7f` decoded as `rst $38 ; ld a,a` at 2F:6CFE) and the mapper's palette heuristic overlapped an object table at 2C:71EA.
* **SRAM record-address tables.**  Six words `$A69D,$A6ED,$A73D,$A78D,$A7DD,$A82D` (stride `$50`) and twelve words `$A124 ... $AE13` (stride `$12D`) are indexed with
  `sla c ; ld hl,TABLE ; add hl,bc ; ld a,[hli] ; ld h,[hl] ; ld l,a`.  They were decoded as junk instructions or left unclassified: 25:4A15 4AF5 4E2B 4F28 50AA 5228 5569 5871,
  2F:44E6 4B42 51B5 5383 53E9 7FA0 (now `words`) and 2C:56F2 64D4, 2F:4936 4B9E (already CONFIRMED-read data, now `words`).
  **The same byte patterns exist in banks not owned here** (`9da6eda63da78da7dda72da8` at 2A:4274 4306 445F 483B 709F 7221 7287; `24a151a2...ac13ae` at 2A:4214 446B, 2B:5643 5814 6863 69AD 6DB0 7D7A, 2D:417D 470A):
  their classifier can turn them into `words` the same way.
* **Bank 44 is four identical-layout scenes** of `$D50` bytes each (4000, 4D50, 5AA0, 67F0): 160 tiles (`$A00`), tilemap 20x18 (`$168`), BG attribute map 20x18 (`$168`), 16 palette groups (`$80`).
  Checks (asserted by the generator): palette signature `ff7f 011c 7e02 0000` at 4CD0/5A20/6770/74C0; tilemap bytes all `< $80`; attribute bytes (verifier-measured sets: scene 1 `$08-$0C`, scene 2 `$00 $01 $09-$0C $29 $2A`, scene 3 `$08-$0C`, scene 4 `$09-$0C $29-$2B`; the generator's earlier claim "only `$08-$0F/$28-$2F`" was wrong for scene 2; bits 0-2 palette, bit 3 VRAM bank 1, bit 5 x flip); tilemap+attribute = `2*18*20 = $2D0` bytes = the geometry of `00:08EA copy_tilemap_rect_pair`.  The mapper's "vertical stripe tile" regions
  (64A0-65FC, 6608-6780, 71F1-74BA, 56F0-5A10, ...) were these maps.  No call site loads bank 44 (no immediate reference exists), so all of it is PROBABLE.
* **Bank 75 contains MD5.**  75:7B50-7C50 equals `floor(2^32 * abs(sin(i)))` for i = 1..64 as little-endian dwords (byte-exact, computed with Python), 75:7B40 is the MD5 initial state
  `67452301 EFCDAB89 98BADCFE 10325476`, and 75:7A32-7B32 cycles the RFC 1321 shift amounts 7,12,17,22 / 5,9,14,20 / 4,11,16,23 / 6,10,15,21.  The strings around it
  (`Authorization: GB00 name="`, POP3 `USER/PASS/STAT/LIST/RETR/DELE/TOP`, SMTP `HELO/MAIL FROM:</RCPT TO:</DATA`, `GET  HTTP/1.0`, `Content-Type: application/x-cgb`, ...) are the
  network protocol side.  75:6063/606D are Mobile Adapter packet templates (magic `99 66`, command, length, payload, additive checksum verified by hand, `80 00`); only the 6-byte head of the second one (606D-6073) is read in traces, so 6063-606D and 6073-6078 are PROBABLE.
* **Object (sprite) animation data.**  `FarCall 00:0A82` (`init_object_from_table`) is called with `ld de,TABLE ; ld a,BANK ; ld b,$81`.  In banks 27, 2C and 2F the tables are 16-byte groups of four
  identical 4-byte entries (two words each) pointing into records `[count][count x (y,x,tile,attr)]` chained by `01 00 04/08`.  Tables are `ptrtable`, records `data`; the record format is
  not fully decoded (marked PROBABLE only for type and extent, not for field semantics).

## 3. Per bank details

### 3.1 Bank 25
* `words` (PROBABLE): eight SRAM tables listed above (progression verified; loads at 25:4687/4A0B, 4E13, 4E67/4EA0/4ED9/4F12, 4F48, 54E2, 585C are the indexed reads; 4AF5 has no located reader, 5228 is the executed first entry).
* `ptrtable` 25:53D0-53DA (5 words = the five string starts of `String_25_53DA`, asserted), 25:58E7-58ED (3 words to 48-byte attribute blocks; reader 25:5891).
* `data` 25:58ED-5A0D: 12 rows of 24 bytes (20 attribute bytes + 4 zeros; values `$09/$0B/$0C/$29`); this replaces the mapper's heuristic `gfx` 58F0-5C40 (the real tiles start at 5A10).
* `gfx` 25:5A10-5E10 and 5E10-5F10 **CONFIRMED** (executed `00:0749` loads at 25:4B5C and 25:4B71, VRAM bank 1 `$9300` and `$9700`); 25:5F10-6310 and 6310-6410 PROBABLE (same layout, loads at 25:4C04/4C19 in static-reached code).
* Remaining: 25:446B `jp $4043`, 25:4659 `jp $411E`, 25:47F8 `ld h,1 ; jp $4000` (11 bytes): jp stubs between functions, no caller/table word anywhere (ROM-wide word and far-pointer search).

### 3.2 Bank 27
* 27:7A10-7AF0 `ptrtable` (14 object tables of 16 bytes = 112 words = 56 four-byte entries, every target inside 7AF0-7CE4; readers 26:4064, 27:4247, 27:4CCB ... via `00:0A82`).  Frame data 27:7BA5, 7BCF, 7CB9 spans start at table targets: `data` PROBABLE.
* Code chains PROBABLE: 27:4D06 and 4EC0 (function prologues with the `$FFF2/$FF8D/$FF70` bank save, `call $047A`), 27:4D4E + 4D81 (`call $4D81`), 27:4EF5 (LCD/scroll register setup).
* 27:5048-505C: 20 bytes of tile-index pairs (HYPOTHESIS, probably a tilemap row; no reference) + 4 zero pad bytes.  Remaining: 27:409F `jr $40FF`, 27:46A0 `ret`, 27:46DF `call $4747 ; jp z,$46E5` (9 bytes).

### 3.3 Bank 2C
* Palettes 2C:5670, 71D0, 7C00, 7F50, 7F90 (`Palette_2C_*`; CONFIRMED where the loading `FarCall` site is executed code: 5670, 71D0, and after the verifier re-check 7F50 and 7F90 (sites 2F:51F6/51E5); 7C00 stays PROBABLE, its site 2C:74D9 is never executed).
* Object tables 56B0 (+frames 56C0), 7210 (+frames 7260-7355, 7357-741C), 7C40 (+frames 7C50).  2C:7F50/7F90 blocks end at 7FD0; 7FD0-8000 is trailing zero.
* `gfx` 2C:6FD0-71D0 (512 B, PROBABLE: rendered and inspected, sits between palette blocks).
* Code PROBABLE: 5A12 (register setup for a FarCall), 5FB1-6032 and 60B3-614D (two complete SRAM-access routines: `ld [$4000],a ; ... xor a ; ldh [$FFF5],a ; ld [$0000],a ; pop af ; ret`), 741C, 7450/745E/746D (button-test chain, entries are the `jr z` targets), three SRAM-disable epilogues (4760/483F/48F0, HYPOTHESIS after the verifier review).
* Text: 2C:4878 (`82 A4 82 A4 00`, read by 2C:47E2).  Remaining (26 B): 4463 `inc c ; dec c ; jr nz` (dead idiom skipped by an executed `jr z`), 44DB, 456D (odd `cp $0D ; cp $00`), 47CA, 487D, 493E, 49E8 (lone `ret`/`ret nz`), 4A01 `jp $4972 ; ret`.

### 3.4 Bank 2F
* `gfx` 2F:61F0-65F0, 65F0-66F0, 66F0-69F0 (CONFIRMED after the verifier re-check: the three contiguous `00:0749` loads at 2F:5966/5978/598A are executed in `analysis/coverage_union.tsv`; the generator had marked them static-reached).  This absorbs 73 zero bytes and the unclassified pieces that were "code-like" hints.
* Tables: `words` (6 SRAM tables), `ptrtable` 4BD0 (5 string pointers, asserted), 4CFD (3 attribute-block pointers, reader 2F:4CAF), 5010, 57B0, 7DD0 (object tables); attribute rows 4D03-4D3F, frame data 5050-5098, 57C0-57F2, 7E20-7EBF; palette 6CC0; strings 6040.
* Code PROBABLE: 50D3 (16 insn, supplies `ld de,$020B` for the FarCall at 50ED).  Code HYPOTHESIS (downgraded by the verifier): 590B and 6F44 (identical 6-insn tails that the `jr $5914`/`jr $6F4D` before them jumps over), three SRAM epilogues 5F28/6007/60B8.
* Remaining (45 B): 4094 `jp $4000`, 582D and 6D3B (`pop af ; cp $01 ; jr z`, fragment starts), 5C30 and 73A6 (`inc c ; dec c ; jr nz`), 5CC5 (odd double `cp`), lone `ret` bytes 5F92 6106 764C 7F3A 7F4D, 61C9 `ret ; jp $613A ; ret`, and the `ret` after each of the two strings (2C:487D, 2F:6045).

### 3.5 Bank 44 and 60 (graphics banks)
* Bank 44: 4 scenes as described; 3 244 already-classified bytes changed type (gfx heuristic regions that were maps/attributes, zero runs that are blank tiles).
* Bank 60: no maps, one tile sheet 4000-7A80 + palette 7A80 (rendered in full: UI frames, Japanese glyphs such as "Aジャンプ", "もどる", sprites).  Every unclassified span sits between PROBABLE tile blocks; the spans were snapped to 16-byte tile boundaries where the neighbour was a 00/FF pad (e.g. tiles start at 60:4DD0, the pad's two `ff ff` bytes are the first bytes of the tile).  Spans of >= 8 tiles are PROBABLE, five short ones HYPOTHESIS.  There is no loader call (only 60:4000-4360 and 5B00-5D50 appear as executed reads).

### 3.6 Banks 54, 57, 73, 75
* 54: month names `jan..dec` + NUL, BCD month list `01..09,10,11,12`, BCD days table (indexed from base `$5373`, bytes verified), `CGB-BXTJ-00` game ID (compared for `b=$0B` by 54:4C1A), strings `\r\n.\r\n`, `メール`, `)` (all passed to `CopyString 00:14BF`), byte blobs copied to `$C240`; code chain 54:41C5-4230 (entries: three `jr z` inside it).  Remaining: 54:4CAD `81 63 00` and 54:511B `81 63` (after `ret`, before a function).
* 57: two routines and zero padding.  73: `ptrtable` 73:4001 (4 string starts, asserted), two tilemap rectangles (readers 73:6230/624B via `00:16A2`, `bc=$040A/$030A`), two attribute rectangles 43AD/4461 (PROBABLE after the verifier re-check: their addresses are stored to `$C10E/$C10F` by 73:6220 and 73:623B right before the `00:16A2` rect copies; static-reached, not executed), 73:6143 two tiny functions.
* 75: URLs (`http://gameboy.datacenter.ne.jp/cgb/download|upload|utility|ranking`, no terminators), command/header strings, packets, MD5 (CONFIRMED for the constants), 75:5118 and 75:7E89 routines, 75:6084 21-byte table.  Remaining: 75:6D62 (`ret`).

## 4. What stays UNCLASSIFIED and why (101 bytes, 32 spans)
Bytes that decode as one or a few instructions (`ret`, `jp`, `jr`, `inc c ; dec c ; jr nz`, `pop af ; cp ; jr z`, `81 63 00`) between two functions or between a string and a function, with **no** caller, table word, far pointer, or fall-through from proven code.
Classifying them as code would only rest on "the bytes decode".  Two identical stubs recurring in several banks suggest dead code of the original build, but that is not evidence for a specific claim.

Note on how code chains were judged: a chain is PROBABLE code when it decodes without illegal opcodes, every direct branch target is an instruction start of the union of code and chains, it lands exactly on a validated code region (or ends in `ret/jp`), its shape is a complete unit (function head, epilogue, register setup of the following far call), and it has >= 5 instructions or an entry inside the chains; no direct caller was found for most of them.  Entry is therefore HYPOTHESIS in each note.

## 5. Reproducing
The analysis scripts lived in the session scratchpad (`.../scratchpad/g6/`: `gen_edits.py` builds `edits.tsv` from the ROM with asserts for every byte-level claim, `apply.py` applies it to a copy of `config/`); they are not part of the repository.  The claims can be re-checked with
`python3 tools/gen_asm.py verify --config config`, `python3 tools/conventions_check.py --strict`, and by rendering tile spans with `tools/extract_gfx.py` / any 2bpp viewer.

## 6. Adversarial verification (independent second pass)

Re-derived from ROM bytes / traces (not from the notes) and found correct: the 25:5A10/5E10 HDMA loads (`ld hl,$5A10 ; c=$40`, sites 25:4B5C/4B71 executed, dec-c block count `$40` x 16 = `$400`); the MD5 sine table (Python `int(abs(sin(i+1))*2**32)` equals the 256 bytes at 75:7B50 exactly), the IV bytes, the RFC 1321 shift column and message-word offsets of 75:7A32 (`i*4`, `(1+5i)%16*4`, ...), and the `ld hl` readers 75:76EE/78E5/77D0; bank 44 rendered as four scenes (tilemap indices index the 160 tiles, all four images are coherent screens with "START MENU / B BACK" labels), bank 60 rendered in full (real glyph and frame art up to 7A80, padding after), 25:5A10-6410, 2F:61F0-69F0 and 2C:6FD0 rendered; the SRAM address tables (progressions and `sla c ; ld hl,TABLE ; add hl,bc` readers, e.g. 25:4687 and 50CA, 2F:7F63); the object tables (all words inside the frame data, groups of four identical entries, `ld de,TABLE ; ld a,BANK ; ld b,$81 ; FarCall 00:0A82` callers, many executed); the attribute-row readers 25:5891 and 2F:4CAF (executed); the palette load sites; the text regions decoded with cp932; the month/BCD tables and their readers in bank 54; the 41 CONFIRMED code upgrades (all instruction starts are in `coverage_union.tsv`, convention-aware sweep).  Structural checks over the real config: no gap or overlap in the eleven banks, no executed instruction start in a non-code region, no illegal opcode, no direct branch/call/far-call target of any code region in these banks lands in a non-code region or mid-instruction, `gen_asm verify` IDENTICAL and `conventions_check --strict` 0 ERROR.

Corrections made by the verifier (bank files 2C 2F 44 73 75 and this document):

* **Retracted: the ptrtable `Table_2C_47AF`.**  2C:47AF-47BD ("code-pointer table, 7 entries, 7/7 words hit code starts") is the middle of the Shift-JIS kana string that starts at 2C:4779 (`83 58 83 5A 83 5C ...` = スセソタチツテ); the pointer heuristic read katakana bytes as little-endian words.  2C:4779-47CA is now one `text` region (identical bytes exist at 2F:5F41, which was already one string).
* **Retracted: "attribute bytes only $08-$0F/$28-$2F" in bank 44** (scene 2 uses `$00`/`$01`); the four attribute-map notes now list the measured sets.  The layout claim itself (tiles, tilemap, attribute map, palettes) stands.
* **Downgraded to HYPOTHESIS (code kept as code, no entry evidence):** 2C:4760, 483F, 48F0 and 2F:5F28, 6007, 60B8 (5-instruction SRAM-disable epilogues), 2F:590B and 6F44 (6-instruction tails that an unconditional `jr` jumps over), 73:6143 (two tiny getters).  An all-bank search finds no branch, far call, `ld r16,imm` or table word naming any of these addresses.  The other entry-less chains stay PROBABLE because each is either a function head / call-argument setup that falls into code seeded by far-call sites (27:4D06 4EC0 4EF5, 2C:5A12, 2F:50D3, 54:41C5), a sibling of executed functions and a caller of proven ones (2C:5FB1, 60B3 call 2C:614D/5E51/5CD2/665F), or reached by branches from another chain (2C:7450 group, 27:4D4E/4D81).  57:52D8 and 57:531E have a real entry: `ld de,$52D8/$531E ; ld a,$57 ; call $0A45` (00:0A45 stores a far pointer, here into object slot `$DA2B`) at 57:42C3, 5304 (and 43A9/4554 for 531E), so their "no entry" notes are stale (status stays PROBABLE, the sites are not executed).
* **Downgraded:** 75:6063-606D from CONFIRMED to PROBABLE (no trace reads any of its bytes; only the structure and checksum are verified); 75:606D-6078 split into the CONFIRMED-read 6-byte head (606D-6073) and a PROBABLE tail (6073-6078).
* **Upgraded with evidence:** 2F:61F0/65F0/66F0 gfx to CONFIRMED (the three loads and their register setup at 2F:595A-598A are executed); palettes 2C:7F50, 2C:7F90, 2F:6CC0 to CONFIRMED (load sites 2F:51DA-51F6 and 2F:59B3-59BE are executed); 73:43AD and 73:4461 from HYPOTHESIS to PROBABLE (their addresses are stored to `$C10E/$C10F`, the attribute source read by `00:16A2`, at 73:6220/623B; static-reached).
* Wording fixes: 27:7A10 holds 112 words (14 tables x 4 entries x 2 words), not 56.
* Not re-verified: the loader of bank 44/60 (searched for `ld a,$44/$60` sites, `00 40 44` byte patterns and far-call sites of `00:0749/0787/08EA` with those banks: none, consistent with the "no loader" claim; the four scenes stay PROBABLE on structure); the 5 short bank-60 HYPOTHESIS gfx pieces; frame-record field semantics; the 32 leftover stubs (checked: no reference to any of them, unchanged).
