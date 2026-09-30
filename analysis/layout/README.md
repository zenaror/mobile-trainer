# Source-tree layout (`analysis/layout/`)

This directory designs the file tree that the second generator mode (`tools/gen_asm.py`, tree mode) emits instead of
one `src/bankNN.asm` per 16 KiB bank.  The tree follows [pokecrystal-mobile-eng](https://github.com/gb-mobile/pokecrystal-mobile-eng)
(`home/ engine/ data/ gfx/ audio/ lib/mobile/`), every file is a floating section and `layout.link` pins the sections to
their banks and addresses.  Nothing here changes a byte of the ROM: the table only says **which file owns which bytes**.

| file | content |
|---|---|
| `layout.tsv` | the layout table (input of the generator): `bank start end path note`, one row per source file |
| `section_order.tsv` | generated plan: per bank the rows in address order (= section order), gaps and the rows that need an `org` pin |
| `layout.link.draft` | generated draft of the rgblink linker script that realises the plan (`ROM0` / `ROMX $nn`, sections in order, `org` pins) |
| `README.md` | this note |
| `../../tools/check_layout.py` | checker, section-order/`layout.link` writer, table statistics |

Regenerate / verify (needs `baserom.gbc`; reads `config/regions`, `config/symbols`, `config/conventions.tsv`, `config/xrefs.tsv`,
`config/text_charsets.tsv`, nothing is modified):

```
python3 tools/check_layout.py                 # 0 errors expected; exit status 1 on any error
python3 tools/check_layout.py --selftest      # mutates the table in memory: each defect class must be reported
python3 tools/check_layout.py --plan analysis/layout/section_order.tsv --link analysis/layout/layout.link.draft
python3 tools/check_layout.py --report /tmp/files.md      # the per-file tables of section 7
```

Current result: **332 rows = 332 files (each file is one contiguous range), in 54 directories (6 top-level: `home lib engine data gfx audio`), 85 banks with rows,
791,540 of 791,540 non-zero ROM bytes covered exactly once, 0 errors, 2 warnings** (the ROM0 gap that needs a pin and one fall-through boundary, both in section 3).  The rows own 969,407 bytes, 177,867 of them
zero bytes (padding folded into rows, zero tails of tile/table blocks); the remaining 1,127,745 bytes of the 2 MiB are uncovered all-zero space left to the linker.

## 1. Table format and rules (all checked by `tools/check_layout.py`)

`layout.tsv` is TAB separated, `#` starts a comment line.  Columns: `bank` (2 upper-case hex digits), `start`, `end` (hex CPU addresses,
`end` exclusive), `path` (relative to `src/`, `[a-z0-9_/]`, ending `.asm`), `note` (free text, copied into the file header comment by the
generator).  Rows are listed in bank order and address order inside a bank.

1. **Coverage.**  Rows must not overlap; every non-zero ROM byte is covered by exactly one row; a range left uncovered must be entirely
   `0x00` (the linker pads it: `rgblink -p 0x00`).  43 banks (`01-03 06-0D 10-18 20-21 30-3C 40 49 59 5A 64 6D-6F`) are all zero and have no rows.
2. **Boundaries.**  A row boundary inside a `code` region must be an instruction start that is not inside inline far-call data
   (`tools/lib/conv.py`, the scanner the generator uses) and must be a label start justified by a symbol (`config/symbols`), a region
   label, or, weaker, a call/farcall target.  All 136 code boundaries of the table are symbols (118) or region labels (18), none rests on a call
   target alone.  Execution falls through exactly one boundary, `68:733C` (state 9 of the registration verify machine ends in `call $0150` and runs on into
   `CommPanel_WaitClose`); the checker lists every such boundary as a warning because the two sections must stay adjacent, which the plan guarantees.
   A boundary inside a `text` region must be at a string start (byte before is `0x00`), inside `layout=html` regions at a record
   start, inside `words`/`ptrtable` on a word boundary.  Cuts inside `data`/`gfx` regions are allowed (the generator splits the region there).
   No boundary cuts the `ramcode` region (00:05AC OAM DMA image).  No `jr`/`jr cc` leaves its file (0 of the code rows' relative jumps cross a boundary), so no function
   body is cut; `jp`/`call` targets may of course be in other files.
3. **Contiguity.**  The rows of one file inside one bank are adjacent (no other file between them); a file may span banks only when
   marked `[multibank]` (no file needs it: every file is one contiguous range of one bank; each of the 9 font banks 76-7E is its own file(s)).
4. **Padding.**  All-zero gaps of at most 255 bytes between two rows of a bank (or before the first row) are folded into the *preceding*
   row (its end moves to the next row's start, always a region boundary), so the sections of a bank simply follow each other.  Larger gaps stay
   uncovered and the following row is marked `org` in `section_order.tsv`.  Only one such gap exists: `00:1770-20A0` (2,352 zero bytes before the bank 04 gateway).
   The tail of every bank (from the last non-zero byte to `$8000`) is uncovered.  A 32-byte all-zero "data" island `48:69AB-69CB`
   (region `Data_48_69AB`, "read as data by executed code") lies in the zero padding and is left to the padding, no file owns it.
5. **Paths.**  Top directory in `home lib engine data gfx audio`, lowercase names, no case-insensitive duplicates, no file that is also a
   directory, none of the names the tree reserves (`main.asm home.asm audio.asm ram.asm ram.inc layout.link includes.asm charmap.asm
   constants.asm macros.asm hardware.inc`, the directories `constants macros tools build config docs analysis traces ram`, device names).
6. **Size.**  Warnings above about 2,600 estimated source lines (code bytes / 2.1, data 16 bytes per line, text 22 bytes per line).  The two
   SDK banks are deliberately single files like in the reference repository (`lib/mobile/main.asm` about 7,100 lines, `lib/mobile/mail.asm`
   about 3,400); every other file is below 2,600 lines, most below 1,000.

## 2. Directory scheme and rationale

| directory | content | evidence used |
|---|---|---|
| `home/` | all of ROM0 (28 files, address order): header/vectors, mobile shims, boot, VBlank/frame service, copy/fill, jump tables, LCD/OAM DMA, CPU speed, bank switching, far calls, HDMA/tilemap upload, sprite engine, arithmetic, random, glyph data, STAT handler, text interpreter, keyword scan, HTML store lookups, string helpers, far reads, alternative interrupt handlers, bank 04 gateway | `docs/research/boot_and_home.md` section 2/11, `config/regions/bank00.tsv` labels |
| `lib/mobile/` | `main.asm` = bank 75 Mobile Adapter SDK, `mail.asm` = bank 0F mail library, exactly the reference repository's split | `naming_sdk.md`, `mobile_trainer_serial.md` (byte identity with Crystal banks 44/45) |
| `audio/` | `engine.asm` (bank 04 sound driver), `notes.asm`, `instruments.asm`, `wave_samples.asm`, `music_pointers.asm` (70 song headers), `music/music_NN.asm` (one file per song id 01-1D, hex ids as in the code), `sfx.asm` (effects 29-46) | `naming_g1.md` section 7: header table `04:551D`, ids 1-0D in bank 4, 0E-1D in bank 5, 29-46 effects; block boundaries = the song header ends (each song block is `tracks..., header`, verified to tile banks 04 and 05 exactly); ids 1E-28 have no data (headers copy song 1) |
| `engine/<subsystem>/` | application code, one directory per subsystem documented in `naming_g1..g8`, `naming_sdk`; data right behind a routine that only it uses (strings, jump/address tables, animation tables) stays in the routine's file because that is how the bank is laid out | function-name prefixes in `config/symbols`, subsystem maps of the naming notes |
| `data/text/` | Shift-JIS strings that form a block of their own (tickers, notices, prompts, error messages, dialog records, help script, connect dialog, Pokemon names of bank 53) grouped by subsystem | `text_encoding.md`, text regions, ticker tables read by `48:4223` |
| `data/html/` | the built-in HTML store: `index.asm` = bank 3F, pages of banks 3D/3E cut at record starts (name range in the file name); `keywords.asm` = HTML parser keyword tables | `bank_survey.md` finding 4 |
| `data/fonts/` | one file per font bank (JIS X 0208 12x12 rows; `ascii_6x12.asm`; `font_8x16.asm`; `sjis_valid_bitmap.asm`) | `naming_g8.md` 6.1 (row/bank tables at `7F:40F9/4150`) |
| `data/keyboard/`, `data/account/` | keyboard page tables (bank 55), the four default adapter images (bank 68) | `naming_g5.md`, `naming_g7.md` |
| `gfx/<screen or subsystem>/` | tile, tilemap, palette and object-table blocks, named after the screen; blocks stored in a different bank than the code that loads them follow their **consumer** (`_bankNN` = bank that holds the bytes) | `analysis/gfx_candidates.tsv` load sites (`hdma_rom_to_vram`, `copy_tilemap_rect_pair`, `init_object_from_table`), `config/xrefs.tsv` `imm` rows, region notes, `classify_g*.md` |
| `gfx/bankNN.asm` | banks whose blocks have no known consumer (41-46, 52, 5B, 60, 61), named by bank as the task prescribes | `classify_g3/g5/g6.md` (no loader found) |
| `engine/unreferenced/`, `gfx/unreferenced/` | code and art with no caller/no loader (the `7F:4C78-61FC` prototype, bank 7F art) | `naming_g8.md` 6.2 (HYPOTHESIS: never executed, no reference) |

Data follows its consumer: the consumer of a data range is the bank that contains the `hdma_rom_to_vram` / `copy_tilemap_rect_pair` /
`init_object_from_table` call or `ld hl,imm` that loads it (a byte-weighted vote over `analysis/gfx_candidates.tsv` load sites and `config/xrefs.tsv` `imm` rows, done with a scratch script that is not committed); where that
bank is the file's own bank the art sits in `gfx/<screen>/` next to the engine file of the same name.  Where both a routine and a
table right behind it exist and only the routine uses the table, they share one file (as in pokecrystal).

### Subsystem to bank map

| subsystem (directory) | banks | files |
|---|---|---|
| ROM0 `home/` | 00 | `home/*` |
| sound: `audio/` | 04, 05 | engine, tables, 29 songs, sfx |
| title screen `engine/title`, `gfx/title` | 0E | `title_screen`, `logo` |
| main loop `engine/main` | 1C (program), 7C (`navigation`) | |
| top menu `engine/menus`, `gfx/top_menu`, `data/text/top_menu_ticker` | 1F, 1E | |
| mail menu `engine/menus`, `gfx/mail_menu` | 1D | |
| help `engine/help`, `gfx/help`, `data/text/help_*` | 6C, 6A, 1A (dictionary), 4C:4F56 (dictionary viewer), 73/1E/6A tickers | |
| debug `engine/debug` | 19, 1B | never executed, no caller |
| mail `engine/mail`, `gfx/mail`, `gfx/mailbox` | 25 (mailbox), 26, 27 (transfer), 28 (body view + shared art), 29 (results), 2B (draft menu, viewer, unused grid), 2C (title entry), 2D (compose/editors), 24 (result art) | |
| mail server `engine/mail_server`, `gfx/mail_server` | 22, 23 (delete menus/flows), 2E (tidy-up), 28 (art) | |
| address book / profile `engine/address_book`, `engine/profile` | 2F, 2A, 2C (picker) | |
| browser `engine/browser`, `gfx/browser`, `engine/html`, `data/html` | 4C, 4E, 4F:4668, 24 (page list), 72 (menus), 73 (start choice), 47 (frames), 51 (image blit), 74, 3D/3E/3F | |
| Mobile Adapter session layer `engine/mobile` | 54 | over the bank 75 SDK API |
| connection UI `engine/comm`, `gfx/comm` | 50 (time notice), 51 (time summary), 57 (connect dialog), 69 (icon), 70 (scene), 7F:61FC (hooks) | |
| dialogs `engine/dialog`, `gfx/dialog`, `data/text/dialog_messages` | 72 | |
| keyboard `engine/keyboard`, `data/keyboard`, `gfx/keyboard` | 55, 7F:70FD (slide helpers), 5F/62/66/5D (panels) | |
| startup/registration `engine/startup`, `gfx/registration` | 65, 4F:4717 (boot stage 2), 4B/58 (art) | |
| settings `engine/settings`, `gfx/settings` | 67, 4A/4B/4D/5D/5E/71 (art) | |
| account library `engine/account`, `gfx/account`, `data/account` | 68, 4A/4B/5D/5E/71 (art) | |
| errors `engine/error`, `gfx/error`, `data/text/comm_error_messages` | 5C, 63 (no adapter), 6B (non-CGB) | |
| SRAM integrity `engine/sram` | 22 (bank 0 pages), 48 (checksum 3, write helpers), 4E (bank 1 block), 2D (clear), 48 (cursor memory) | |
| text/graphics services `engine/text`, `engine/gfx` | 7F (glyph, canvas, scroll split), 7E (charset conversion), 48 (text tiles, ticker, fades), 4F (palette, tile canvas), 55 (half/full width), 63 | |
| input `engine/input` | 7D (joypad) | |
| fonts `data/fonts` | 76-7E (JIS rows 1-84, ASCII 6x12), 48 (8x16), 63 (validity bitmap) | |
| screen packages `gfx/bank41..46`, `gfx/browser/frames_*` | 41-47 | 47 is referenced by the frame descriptors of bank 4E |

## 3. Section-order plan

`section_order.tsv` has one row per layout row: `bank order start end size path section gap_before pin kinds note`.  `order` is the position in the
bank (ascending address).  A generated `main.asm` can mirror pokecrystal in either of two ways, both realise exactly this table:

* **per-file sections** (recommended): `SECTION "<path stem>", ROMX, BANK[$nn]` (ROM0: `ROM0`) at the top of each file, `main.asm` `INCLUDE`s
  the files in plan order, `layout.link` (draft: `layout.link.draft`) lists the sections per bank in the same order.
* **per-bank sections**: `SECTION "bankNN", ROMX[$4000], BANK[$nn]` followed by the `INCLUDE`s of that bank's rows in plan order (the
  generated `bankNN.asm` with the per-file text moved into included files).

Pins: the plan marks a row `org` when a gap of zero bytes precedes it.  There is exactly one: `home/audio.asm` (`00:20A0`), in the draft as `org $20a0`.
`home/header.asm` covers `00:0000-0150` (rst slots, vectors, entry, cartridge header, mostly `ds`); the generator should emit the fixed slots
(`rst`, interrupt vectors, `Entry`, header) as fixed-address sections like pokecrystal's `layout.link` does (`org $0000/$0040/...`), the row only fixes
which file owns them.  Every other first row starts at the bank window start.  The ROM is 2 MiB because bank 7F has rows; empty banks are
produced by `rgblink -p 0x00`.  The `ramcode` OAM DMA image inside `home/lcd.asm` stays a `LOAD` block inside that file.

Contents per bank in section order (from `section_order.tsv`): see that file; row counts per bank: `00` 28, `04` 18, `05` 17, `67` 14, `68` 15, `48` 11, `7F` 9,
`4E` 9, `2F` 8, `2D` 8, `54` 8, `2A/2B` 7, `74` 7, `22` 5 ... single-file banks: `0F 1B 1C 1F 41-46 4D 52 53 58 5B 5F 60 61 62 66 75 77-7B`.

## 4. Verification performed

* `python3 tools/check_layout.py` on the current `config/`: 0 errors.  Non-zero ROM bytes: 791,540, all covered exactly once (no overlap between rows; every uncovered
  range checked to be all `0x00`).  136 code boundaries (52 strictly inside a code region), all at instruction starts outside inline far-call data (the checker reuses `lib/conv.py`'s scanner and the
  `branch` xref rows) and all at a symbol or region label.
* `python3 tools/check_layout.py --selftest` mutates the table in memory (mid-instruction cut, cut inside `call $06D1` inline data, unlabelled instruction start, missing row,
  overlap, a `jr` crossing a boundary, cut inside a string, cut inside an html record, bad/reserved path, non-adjacent rows of one file, multi-bank file without marker) and checks that each is reported.
* The layout does not depend on generator internals: every row is a plain range; the tool needs only `baserom.gbc` and `config/`.
* Not verified (needs the tree-mode generator): that each file assembles on its own and that the generated `layout.link` reproduces the ROM; the plan is the input for that step.

## 5. Uncertain assignments and judgement calls

Evidence grades follow the project vocabulary.  Everything not listed here is backed by symbol prefixes, xrefs or executed load sites in the
same bank.  None of these choices can change a byte: they only decide which file a range lands in.

**Names that state a hypothesis** (the file name repeats the wording of the naming notes; HYPOTHESIS/PROBABLE there):
* `engine/unreferenced/page_list_prototype.asm` (`7F:4C78-61FC`), `gfx/unreferenced/page_list_prototype.asm` (`7F:62B0-70FD`),
  `gfx/unreferenced/page_list_prototype_objects.asm` (`7F:7830-7CC5`): never executed, no reference; "prototype of the page list" is `naming_g8.md` 6.2 (HYPOTHESIS).
  Prototype art ranges follow the load sites `7F:522A-52A4`, the sprite tables `6DB0/7B40` and `4FC3/4FCF` reads; the ends (`70FD`, `7830`) are region boundaries.
* `engine/address_book/unreferenced_confirm_screen.asm` + `gfx/.../unreferenced_confirm_screen.asm` (`2C:741C-7FD0`): code without caller (HYPOTHESIS, `naming_g3.md`);
  the art part `7C80/7F50` is also described there as entry-screen art of bank 2F, so the second file mixes two hypotheses.
* `engine/browser/frame_style_chooser.asm` (`4E:4000-4658`): `naming_g5.md` 3.3 (PROBABLE, no caller); it includes the wipe list `41E0` and helper `45FE`.
* `engine/mail/received_mail_grid.asm`, `engine/gfx/unreferenced_palette_library.asm` (`29:5090`), `engine/mail_server/delete_sprite_counters.asm`
  (`23:58C4-6D61`, entries replaced by `ret`), `engine/debug/*`: unreferenced or patched-out code, named after what the naming notes say it is.
* `home/keyword_scan.asm` (`10E9-131A`) and `home/html_store.asm` (`131A-1408`): the HTML use is HYPOTHESIS for `1119` (`boot_and_home.md` 9) but the keyword
  tables walked by `10E9/1119` are the `Html_*` tables of bank 74 (`naming_g8.md` 7.5) and `131A/1354` read the bank 3F index (`bank_survey.md`).

**Consumer decided by adjacency or by a minority of load sites**
* `4B:5B90-7FE0` assigned to `gfx/settings/` (consumer 67): only `6A90-7FE0` has load sites from 67; `5B90-6A90` (text-glyph tiles "電話番号入力説明 ...") is between banks 68's and 67's ranges.
* `4A:4000-4040` (object table loaded by 67) sits in the account file (68), `5E:57E0-5800` (read by bank 55) in `gfx/account/screens_bank5e.asm`; one file per bank/consumer keeps every file contiguous.
* `28:4BD0-54B0` (loaded by 2C, a little by 2A/2F), `28:6E80-6F20` (object tables of 22/23) inside `delete_method_screen`, `28:6F20-7A5D` (26/27),
  `29:5376-5B10` (27), `29:5B10-6290` (2F), `29:6290-64F4` (2D reads `6350`, the first 12 entries have no reader), `26:7420-7AB0` (29), `26:7AB0-7D41` (25; one palette read by 2A).
* `22:5980-5CD0` belongs to the bank 26 scene, `22:5CD0-66D0` to bank 2F (`naming_g1.md` section 9, retraction of the first reading).
* Banks 41-46 have **no loader** (`classify_g3/g5/g6.md`); they share the exact package format of bank 47 (`$D50` = 160 tiles + tilemap + attribute map + palettes, palette
  signature `ff7f 1c01 027e 0000`), which is referenced by the bank 4E frame descriptors, so they may be frame styles 3-26, but nothing proves it; hence `gfx/bank4N.asm`.
* Bank 53 is a table + 25 katakana names (Pokemon names); no reader was found (`data/text/pokemon_names_bank53.asm`).  Bank 56 `4000-418A` (6 strings) is
  assigned to the connect dialog (57) as the only bank whose art it sits with.  Banks `52 5B 60 61` only have unproven readers.

**Function grouping inside a bank (no symbol says where a subsystem ends)**
* `home/`: `0BBD-0BD4` (map offset to pixel) kept with the sprite engine, `0D34` (odd routine, `boot_and_home.md` C20) with the 32-bit multiply/divide, `0247` (wrapper into `0F:4247`) with the
  mobile shims, `16A2` (tilemap copy twin of `08CA`) as its own file, `0DB9-0E93` (glyph data converters called from bank 7F) as `glyph_data`.
* `48`: `Divide8` with `text_tiles`, `Bcd_FromBinary8` with `font_8x16`; `4A8C` (copy of `00:091C`) with the tutorial gates.  `4E:4658-488D` groups the boot
  counters, `Browser_BeginSession`, `SaveCheck_*`, the error counter and the unreferenced record builder as "save block"; `4C:46B8-4840` puts `CommProgress_*` with the disconnect code.
* `68:4000-4785` is `helpers` (session counters, phone-number BCD, text-entry, mail address, config mirror, dial entries): no better name is supported.
  Directory names `account` (68, prefix `Account_`), `settings` (67, `SettingsPhone_ ...`), `startup` (65, `Startup_`, `Registration_`, `Notice_`) follow the prefixes; `naming_g6/g7` describe 65/67/68 as
  one registration/settings family, so the split is by bank prefix, not a proven module border.
* `7F:61FC-624F` is `engine/comm/time_hooks.asm` (placeholder hook, clock reset, unexecuted wrappers of the time-notice dialog); `7F:624F-62B0` sprite slot backup.
* `22:4EF0-5110` `engine/sram/integrity_check.asm` sits in a bank of the hidden delete menu because of how bank 22 is laid out.
* Songs: ids and the music/effect split come from the sound-id call sites (`naming_g1.md` section 7); the per-id file names are hex ids, not titles.  `audio/sfx.asm` keeps all 30 effects
  together (blocks of 16-121 bytes).  Two one-track songs (`18`, `1B`) are 16-byte files.
* `3D:48D1-518D` `pages_cdmaone_to_www` holds two records named `website.htm` and `www.htm` that also appear earlier in the same bank; page-range file names are the first and last record name.
* `lib/mobile/main.asm` (bank 75, 16 KiB) and `lib/mobile/mail.asm` (bank 0F) stay single files as in the reference repository, above the usual size guideline.

## 6. Findings for the owner of `config/regions` (nothing was edited here)

* `7C:57C3-57CD` is a 10-byte `code` region inside the font `4000-7B7C` (`naming_g8.md` section 9 already asks to merge it); the layout row `7C:4000-7B7C` contains it
  (region kinds inside a row are the generator's business).
* `63:407A-70C0` is typed `gfx`, but `Font_SjisValidBitmap` is `407A-6080` and the no-adapter art starts at `6080`: the layout cuts at `6080` inside the region (allowed).
* `48:69AB-69CB` is a 32-byte `data` region whose bytes are all `0x00`, isolated by 3 KiB of padding on both sides: left uncovered (rule 4).
* Region kinds may change without breaking the table: every check that depends on them is re-run by `tools/check_layout.py`, so re-run it after any region edit
  (a boundary that becomes mid-instruction, or a text cut that stops being at a string start, is reported).

## 7. Files per directory (generated: `python3 tools/check_layout.py --report ...`)

"bytes" = ROM bytes owned (including folded padding), "est. lines" = rough source lines (code /2.1, data /16, text /22).

<!-- generated by tools/check_layout.py --report; do not edit by hand -->

| directory | files | bytes |
|---|---:|---:|
| `audio/` | 6 | 7414 |
| `audio/music/` | 29 | 19033 |
| `data/account/` | 1 | 768 |
| `data/fonts/` | 12 | 146174 |
| `data/html/` | 8 | 18894 |
| `data/keyboard/` | 1 | 7074 |
| `data/text/` | 10 | 19304 |
| `engine/account/` | 14 | 14989 |
| `engine/address_book/` | 9 | 20066 |
| `engine/browser/` | 18 | 23580 |
| `engine/comm/` | 7 | 9794 |
| `engine/debug/` | 3 | 4612 |
| `engine/dialog/` | 1 | 2240 |
| `engine/error/` | 3 | 1382 |
| `engine/gfx/` | 7 | 4338 |
| `engine/help/` | 4 | 7051 |
| `engine/html/` | 6 | 6908 |
| `engine/input/` | 1 | 150 |
| `engine/keyboard/` | 3 | 5254 |
| `engine/mail/` | 17 | 41989 |
| `engine/mail_server/` | 8 | 21927 |
| `engine/main/` | 2 | 712 |
| `engine/menus/` | 3 | 3813 |
| `engine/mobile/` | 8 | 5097 |
| `engine/profile/` | 1 | 3691 |
| `engine/settings/` | 14 | 10335 |
| `engine/sprites/` | 1 | 97 |
| `engine/sram/` | 6 | 1608 |
| `engine/startup/` | 4 | 3412 |
| `engine/text/` | 7 | 5515 |
| `engine/title/` | 1 | 960 |
| `engine/tutorial/` | 1 | 287 |
| `engine/unreferenced/` | 1 | 5508 |
| `gfx/account/` | 5 | 50052 |
| `gfx/address_book/` | 11 | 22536 |
| `gfx/` | 10 | 120880 |
| `gfx/browser/` | 5 | 31423 |
| `gfx/comm/` | 5 | 51308 |
| `gfx/dialog/` | 1 | 1899 |
| `gfx/error/` | 3 | 11848 |
| `gfx/help/` | 3 | 15999 |
| `gfx/keyboard/` | 4 | 38024 |
| `gfx/mail/` | 16 | 55528 |
| `gfx/mail_menu/` | 1 | 7673 |
| `gfx/mail_server/` | 5 | 21690 |
| `gfx/mailbox/` | 2 | 6065 |
| `gfx/profile/` | 1 | 3221 |
| `gfx/registration/` | 2 | 16752 |
| `gfx/settings/` | 6 | 36055 |
| `gfx/title/` | 2 | 10224 |
| `gfx/top_menu/` | 1 | 9396 |
| `gfx/unreferenced/` | 2 | 4834 |
| `home/` | 28 | 6227 |
| `lib/mobile/` | 2 | 23796 |

#### `audio/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `audio/engine.asm` | 04 | 4164 | 1938 | code 4056, ptrtable 100, words 8 |
| `audio/instruments.asm` | 04 | 672 | 42 | data 672 |
| `audio/music_pointers.asm` | 04 | 560 | 35 | data 560 |
| `audio/notes.asm` | 04 | 409 | 25 | data 409 |
| `audio/sfx.asm` | 05 | 1449 | 90 | data 1363, words 86 |
| `audio/wave_samples.asm` | 04 | 160 | 10 | data 160 |

#### `audio/music/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `audio/music/music_01.asm` | 04 | 377 | 23 | data 377 |
| `audio/music/music_02.asm` | 04 | 1043 | 65 | data 1043 |
| `audio/music/music_03.asm` | 04 | 565 | 35 | data 565 |
| `audio/music/music_04.asm` | 04 | 500 | 31 | data 500 |
| `audio/music/music_05.asm` | 04 | 1850 | 115 | data 1850 |
| `audio/music/music_06.asm` | 04 | 792 | 49 | data 792 |
| `audio/music/music_07.asm` | 04 | 1343 | 83 | data 1343 |
| `audio/music/music_08.asm` | 04 | 972 | 60 | data 972 |
| `audio/music/music_09.asm` | 04 | 906 | 56 | data 906 |
| `audio/music/music_0a.asm` | 04 | 443 | 27 | data 443 |
| `audio/music/music_0b.asm` | 04 | 591 | 36 | data 591 |
| `audio/music/music_0c.asm` | 04 | 457 | 28 | data 457 |
| `audio/music/music_0d.asm` | 04 | 208 | 13 | data 208 |
| `audio/music/music_0e.asm` | 05 | 562 | 35 | data 538, words 24 |
| `audio/music/music_0f.asm` | 05 | 808 | 50 | data 784, words 24 |
| `audio/music/music_10.asm` | 05 | 422 | 26 | data 398, words 24 |
| `audio/music/music_11.asm` | 05 | 815 | 50 | data 791, words 24 |
| `audio/music/music_12.asm` | 05 | 626 | 39 | data 602, words 24 |
| `audio/music/music_13.asm` | 05 | 223 | 13 | data 215, words 8 |
| `audio/music/music_14.asm` | 05 | 828 | 51 | data 804, words 24 |
| `audio/music/music_15.asm` | 05 | 184 | 11 | data 176, words 8 |
| `audio/music/music_16.asm` | 05 | 879 | 54 | data 855, words 24 |
| `audio/music/music_17.asm` | 05 | 1555 | 97 | data 1531, words 24 |
| `audio/music/music_18.asm` | 05 | 16 | 1 | data 14, words 2 |
| `audio/music/music_19.asm` | 05 | 713 | 44 | data 689, words 24 |
| `audio/music/music_1a.asm` | 05 | 794 | 49 | data 770, words 24 |
| `audio/music/music_1b.asm` | 05 | 16 | 1 | data 14, words 2 |
| `audio/music/music_1c.asm` | 05 | 471 | 29 | data 453, words 18 |
| `audio/music/music_1d.asm` | 05 | 74 | 4 | data 68, words 6 |

#### `data/account/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `data/account/default_config_images.asm` | 68 | 768 | 48 | data 768 |

#### `data/fonts/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `data/fonts/ascii_6x12.asm` | 76 | 1152 | 72 | gfx 1152 |
| `data/fonts/font_8x16.asm` | 48 | 4848 | 303 | gfx 4848 |
| `data/fonts/jis12x12_rows_01_08_13.asm` | 7E | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_16_24.asm` | 7D | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_25_33.asm` | 7C | 15228 | 955 | gfx 15218, code 10 |
| `data/fonts/jis12x12_rows_34_42.asm` | 7B | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_43_51.asm` | 7A | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_52_60.asm` | 79 | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_61_69.asm` | 78 | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_70_78.asm` | 77 | 15228 | 951 | gfx 15228 |
| `data/fonts/jis12x12_rows_79_84.asm` | 76 | 10152 | 634 | gfx 10152 |
| `data/fonts/sjis_valid_bitmap.asm` | 63 | 8198 | 512 | gfx 8198 |

#### `data/html/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `data/html/index.asm` | 3F | 268 | 17 | data 255, text 11, zero 2 |
| `data/html/keywords.asm` | 74 | 357 | 22 | data 245, ptrtable 112 |
| `data/html/pages_a_mark_to_download.asm` | 3E | 3367 | 153 | text 3367 |
| `data/html/pages_cdmaone_to_www.asm` | 3D | 2236 | 101 | text 2236 |
| `data/html/pages_email_to_m_home.asm` | 3E | 3704 | 168 | text 3704 |
| `data/html/pages_m_sys_to_offline.asm` | 3E | 4272 | 194 | text 4272 |
| `data/html/pages_online_to_receive.asm` | 3E | 2433 | 110 | text 2433 |
| `data/html/pages_saport_to_tu_error.asm` | 3D | 2257 | 102 | text 2257 |

#### `data/keyboard/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `data/keyboard/pages.asm` | 55 | 7074 | 419 | data 5664, text 1340, ptrtable 50, words 20 |

#### `data/text/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `data/text/browser_start_ticker.asm` | 73 | 151 | 7 | text 142, ptrtable 8, data 1 |
| `data/text/comm_error_messages.asm` | 5C | 4432 | 210 | text 3923, data 433, ptrtable 74, words 2 |
| `data/text/connect_dialog.asm` | 56 | 394 | 17 | text 394 |
| `data/text/dialog_messages.asm` | 72 | 5037 | 232 | text 4854, ptrtable 146, data 37 |
| `data/text/help_menu_ticker.asm` | 6A | 613 | 29 | text 539, ptrtable 34, words 32, data 8 |
| `data/text/help_script.asm` | 6C | 4478 | 219 | text 3537, data 941 |
| `data/text/pokemon_names_bank53.asm` | 53 | 369 | 17 | text 319, ptrtable 50 |
| `data/text/registration_notices.asm` | 65 | 2577 | 117 | text 2577 |
| `data/text/registration_prompts.asm` | 65 | 1038 | 47 | text 998, ptrtable 40 |
| `data/text/top_menu_ticker.asm` | 1E | 215 | 10 | text 188, data 15, ptrtable 12 |

#### `engine/account/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/account/action_confirm.asm` | 68 | 511 | 240 | code 503, data 8 |
| `engine/account/comm_panel.asm` | 68 | 818 | 371 | code 774, words 22, data 12, ptrtable 10 |
| `engine/account/confirm_screens.asm` | 68 | 1513 | 695 | code 1455, text 34, words 24 |
| `engine/account/delete_registration.asm` | 68 | 1084 | 512 | code 1074, words 6, data 4 |
| `engine/account/dev_test_config.asm` | 68 | 490 | 139 | code 272, zero 92, text 80, data 46 |
| `engine/account/helpers.asm` | 68 | 1925 | 896 | code 1877, text 24, data 18, words 6 |
| `engine/account/login_id_entry.asm` | 68 | 1159 | 551 | code 1159 |
| `engine/account/mail_address_entry.asm` | 68 | 1507 | 717 | code 1507 |
| `engine/account/password_entry.asm` | 68 | 1271 | 601 | code 1263, words 8 |
| `engine/account/register_config.asm` | 68 | 826 | 381 | code 797, text 12, data 11, words 6 |
| `engine/account/registration_verify.asm` | 68 | 803 | 374 | code 783, ptrtable 20 |
| `engine/account/result_page.asm` | 68 | 739 | 325 | code 674, data 35, ptrtable 30 |
| `engine/account/settings_menu.asm` | 68 | 760 | 354 | code 742, words 10, ptrtable 8 |
| `engine/account/settings_page.asm` | 68 | 1583 | 750 | code 1575, words 8 |

#### `engine/address_book/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/address_book/address_book.asm` | 2F | 237 | 107 | code 223, words 12, data 2 |
| `engine/address_book/address_editor.asm` | 2F | 2768 | 1310 | code 2748, data 10, zero 10 |
| `engine/address_book/address_picker.asm` | 2C | 4158 | 1951 | code 4088, text 41, words 24, zero 3, data 2 |
| `engine/address_book/list.asm` | 2F | 3392 | 1474 | code 3059, text 205, data 63, words 48, ptrtable 16, zero 1 |
| `engine/address_book/name_editor.asm` | 2F | 2558 | 1157 | code 2415, text 107, data 30, zero 6 |
| `engine/address_book/save_confirm.asm` | 2A | 1547 | 716 | code 1498, words 36, zero 13 |
| `engine/address_book/save_sender_address.asm` | 2A | 2720 | 1213 | code 2525, words 96, text 80, zero 13, ptrtable 6 |
| `engine/address_book/unreferenced_confirm_screen.asm` | 2C | 804 | 378 | code 792, zero 12 |
| `engine/address_book/view.asm` | 2F | 1882 | 849 | code 1769, data 50, words 36, ptrtable 16, zero 11 |

#### `engine/browser/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/browser/canvas.asm` | 4E | 240 | 114 | code 240 |
| `engine/browser/comm_disconnect.asm` | 4C | 392 | 183 | code 384, ptrtable 8 |
| `engine/browser/entry.asm` | 4F | 175 | 78 | code 163, ptrtable 12 |
| `engine/browser/frame_graphics.asm` | 4E | 1158 | 461 | code 941, data 163, ptrtable 54 |
| `engine/browser/frame_style_chooser.asm` | 4E | 1624 | 333 | words 1054, code 560, ptrtable 10 |
| `engine/browser/history_cache.asm` | 4C | 606 | 283 | code 594, data 12 |
| `engine/browser/inline_image_blit.asm` | 51 | 2080 | 986 | code 2070, data 10 |
| `engine/browser/inline_images.asm` | 4C | 788 | 375 | code 788 |
| `engine/browser/menus.asm` | 72 | 2104 | 848 | code 1742, text 246, data 82, ptrtable 30, zero 4 |
| `engine/browser/page_list.asm` | 24 | 5120 | 2333 | code 4874, text 211, words 24, ptrtable 8, zero 2, data 1 |
| `engine/browser/page_loader.asm` | 4C | 1720 | 805 | code 1688, ptrtable 24, data 8 |
| `engine/browser/page_render.asm` | 4E | 2405 | 1138 | code 2388, ptrtable 16, data 1 |
| `engine/browser/page_results.asm` | 4C | 420 | 154 | code 314, text 69, data 37 |
| `engine/browser/page_view.asm` | 4E | 2147 | 975 | code 2033, ptrtable 114 |
| `engine/browser/scrollbar.asm` | 4E | 1104 | 525 | code 1104 |
| `engine/browser/session_start.asm` | 4E | 276 | 102 | code 207, data 55, ptrtable 14 |
| `engine/browser/start_choice.asm` | 73 | 984 | 464 | code 974, ptrtable 10 |
| `engine/browser/status_sprites.asm` | 4E | 237 | 112 | code 237 |

#### `engine/comm/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/comm/comm_scene.asm` | 70 | 2082 | 969 | code 2028, ptrtable 54 |
| `engine/comm/connect_dialog.asm` | 57 | 1958 | 932 | code 1958 |
| `engine/comm/connect_dialog_screen.asm` | 57 | 3739 | 1771 | code 3715, gfx 16, zero 8 |
| `engine/comm/connection_icon.asm` | 69 | 338 | 153 | code 320, ptrtable 18 |
| `engine/comm/notice_dialog.asm` | 50 | 922 | 421 | code 880, ptrtable 26, words 16 |
| `engine/comm/time_hooks.asm` | 7F | 83 | 39 | code 83 |
| `engine/comm/time_summary.asm` | 51 | 672 | 305 | code 636, data 20, ptrtable 10, zero 6 |

#### `engine/debug/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/debug/debug_flags.asm` | 19 | 2432 | 995 | code 2049, text 276, data 80, zero 13, ptrtable 10, words 4 |
| `engine/debug/error_screen_test.asm` | 19 | 1049 | 445 | code 922, text 85, data 32, ptrtable 10 |
| `engine/debug/sound_test.asm` | 1B | 1131 | 454 | code 932, text 125, data 64, ptrtable 10 |

#### `engine/dialog/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/dialog/dialog.asm` | 72 | 2240 | 1048 | code 2196, ptrtable 32, data 12 |

#### `engine/error/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/error/comm_error_screen.asm` | 5C | 966 | 447 | code 936, data 20, ptrtable 10 |
| `engine/error/no_adapter.asm` | 63 | 256 | 121 | code 256 |
| `engine/error/non_cgb_screen.asm` | 6B | 160 | 74 | code 156, data 4 |

#### `engine/gfx/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/gfx/palette.asm` | 4F | 1394 | 650 | code 1362, ptrtable 32 |
| `engine/gfx/palette_fade_masked.asm` | 48 | 310 | 147 | code 310 |
| `engine/gfx/palette_fade_ticker.asm` | 48 | 98 | 46 | code 98 |
| `engine/gfx/scroll_split.asm` | 7F | 1471 | 288 | data 907, code 476, ptrtable 72, words 16 |
| `engine/gfx/tile_canvas.asm` | 4F | 246 | 117 | code 246 |
| `engine/gfx/tilemap_fill.asm` | 48 | 77 | 36 | code 77 |
| `engine/gfx/unreferenced_palette_library.asm` | 29 | 742 | 353 | code 742 |

#### `engine/help/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/help/help_menu.asm` | 6C | 2057 | 953 | code 1995, data 52, ptrtable 10 |
| `engine/help/help_script.asm` | 6C | 2116 | 939 | code 1951, data 155, ptrtable 10 |
| `engine/help/mobile_dictionary.asm` | 1A | 1973 | 544 | code 1049, text 737, ptrtable 150, data 37 |
| `engine/help/mobile_dictionary_view.asm` | 4C | 905 | 426 | code 895, ptrtable 10 |

#### `engine/html/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/html/count_pass.asm` | 74 | 771 | 352 | code 735, ptrtable 36 |
| `engine/html/layout.asm` | 74 | 1715 | 816 | code 1715 |
| `engine/html/link_tables.asm` | 74 | 459 | 218 | code 459 |
| `engine/html/parser.asm` | 74 | 827 | 393 | code 827 |
| `engine/html/tags.asm` | 74 | 2735 | 1283 | code 2689, ptrtable 44, data 2 |
| `engine/html/url.asm` | 74 | 401 | 146 | code 293, data 76, ptrtable 24, text 8 |

#### `engine/input/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/input/joypad.asm` | 7D | 150 | 71 | code 150 |

#### `engine/keyboard/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/keyboard/keyboard.asm` | 55 | 4388 | 2003 | code 4180, data 126, ptrtable 58, words 24 |
| `engine/keyboard/slide_helpers.asm` | 7F | 372 | 177 | code 372 |
| `engine/keyboard/type_helpers.asm` | 55 | 494 | 186 | code 376, data 118 |

#### `engine/mail/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/mail/address_editor.asm` | 2D | 2928 | 1394 | code 2927, zero 1 |
| `engine/mail/body_editor.asm` | 2D | 5022 | 2344 | code 4912, text 102, data 5, zero 3 |
| `engine/mail/body_view.asm` | 28 | 704 | 331 | code 695, zero 9 |
| `engine/mail/compose.asm` | 2D | 405 | 182 | code 381, words 24 |
| `engine/mail/draft_menu.asm` | 2B | 2176 | 961 | code 2000, text 164, ptrtable 8, zero 4 |
| `engine/mail/mail_session.asm` | 26 | 4199 | 1997 | code 4194, data 5 |
| `engine/mail/mail_session_screen.asm` | 26 | 2417 | 964 | code 1981, text 339, data 97 |
| `engine/mail/mail_title_entry.asm` | 2C | 2608 | 1178 | code 2460, text 107, data 26, zero 15 |
| `engine/mail/mail_viewer_body.asm` | 2B | 1090 | 509 | code 1066, words 24 |
| `engine/mail/mail_viewer_sender.asm` | 2B | 2382 | 1101 | code 2302, words 72, zero 8 |
| `engine/mail/mailbox.asm` | 25 | 2829 | 1322 | code 2770, words 48, data 11 |
| `engine/mail/mailbox_screen.asm` | 25 | 3843 | 1555 | code 3187, data 288, text 205, words 144, ptrtable 16, zero 3 |
| `engine/mail/received_mail_grid.asm` | 2B | 1533 | 680 | code 1414, words 72, text 35, zero 12 |
| `engine/mail/result_screens.asm` | 29 | 4240 | 1879 | code 3911, text 258, gfx 48, data 22, zero 1 |
| `engine/mail/sample_data.asm` | 2D | 1265 | 272 | text 723, code 497, data 45 |
| `engine/mail/send_receive.asm` | 27 | 4192 | 1976 | code 4142, data 36, ptrtable 10, zero 4 |
| `engine/mail/staging.asm` | 2D | 156 | 64 | code 132, words 24 |

#### `engine/mail_server/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/mail_server/delete_flows.asm` | 23 | 3005 | 1425 | code 2991, data 14 |
| `engine/mail_server/delete_hidden.asm` | 22 | 3824 | 1593 | code 3296, text 507, data 21 |
| `engine/mail_server/delete_menu.asm` | 23 | 2566 | 1050 | code 2167, text 398, data 1 |
| `engine/mail_server/delete_messages.asm` | 23 | 630 | 211 | code 425, text 205 |
| `engine/mail_server/delete_progress.asm` | 23 | 769 | 349 | code 731, text 38 |
| `engine/mail_server/delete_sprite_counters.asm` | 23 | 5277 | 2512 | code 5277 |
| `engine/mail_server/tidy.asm` | 2E | 2862 | 1362 | code 2862 |
| `engine/mail_server/tidy_screen.asm` | 2E | 2994 | 1244 | code 2571, text 396, zero 15, ptrtable 12 |

#### `engine/main/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/main/main_program.asm` | 1C | 51 | 20 | code 41, ptrtable 6, data 4 |
| `engine/main/navigation.asm` | 7C | 661 | 300 | code 627, ptrtable 34 |

#### `engine/menus/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/menus/mail_menu.asm` | 1D | 1473 | 481 | code 960, text 430, ptrtable 34, words 32, data 17 |
| `engine/menus/ticker.asm` | 48 | 701 | 333 | code 701 |
| `engine/menus/top_menu.asm` | 1F | 1639 | 773 | code 1623, ptrtable 10, data 6 |

#### `engine/mobile/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/mobile/connection.asm` | 54 | 648 | 306 | code 642, data 6 |
| `engine/mobile/http.asm` | 54 | 630 | 299 | code 630 |
| `engine/mobile/mail_date.asm` | 54 | 542 | 229 | code 475, text 37, data 30 |
| `engine/mobile/pop3_dele.asm` | 54 | 99 | 47 | code 99 |
| `engine/mobile/pop3_retr.asm` | 54 | 1208 | 568 | code 1191, data 17 |
| `engine/mobile/pop3_top.asm` | 54 | 1003 | 434 | code 902, text 83, data 18 |
| `engine/mobile/smtp.asm` | 54 | 862 | 397 | code 832, data 22, text 8 |
| `engine/mobile/text_truncate.asm` | 54 | 105 | 48 | code 102, data 3 |

#### `engine/profile/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/profile/profile_editor.asm` | 2A | 3691 | 1711 | code 3582, text 107, zero 2 |

#### `engine/settings/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/settings/adapter_check.asm` | 67 | 461 | 217 | code 455, data 6 |
| `engine/settings/adapter_config.asm` | 67 | 816 | 376 | code 786, words 18, ptrtable 12 |
| `engine/settings/choice_menu.asm` | 67 | 755 | 354 | code 743, words 8, data 4 |
| `engine/settings/confirm_screen.asm` | 67 | 722 | 339 | code 712, words 6, data 4 |
| `engine/settings/continue_prompt.asm` | 67 | 449 | 212 | code 445, data 4 |
| `engine/settings/http_redirect.asm` | 67 | 340 | 161 | code 340 |
| `engine/settings/password_change.asm` | 67 | 1689 | 758 | code 1578, data 74, text 21, ptrtable 16 |
| `engine/settings/password_save_confirm.asm` | 67 | 507 | 239 | code 503, data 4 |
| `engine/settings/phone_comment_entry.asm` | 67 | 847 | 403 | code 847 |
| `engine/settings/phone_number_entry.asm` | 67 | 1585 | 754 | code 1585 |
| `engine/settings/slot_menu.asm` | 67 | 1175 | 547 | code 1145, words 24, data 6 |
| `engine/settings/text_buffer.asm` | 67 | 302 | 143 | code 302 |
| `engine/settings/usage_fee.asm` | 67 | 250 | 94 | code 190, data 60 |
| `engine/settings/usage_time.asm` | 67 | 437 | 169 | code 345, data 59, text 33 |

#### `engine/sprites/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/sprites/slot_backup.asm` | 7F | 97 | 43 | code 90, zero 7 |

#### `engine/sram/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/sram/checksum3.asm` | 48 | 243 | 115 | code 243 |
| `engine/sram/clear_all_banks.asm` | 2D | 109 | 51 | code 109 |
| `engine/sram/integrity_check.asm` | 22 | 544 | 257 | code 539, zero 5 |
| `engine/sram/menu_cursor_memory.asm` | 48 | 48 | 22 | code 48 |
| `engine/sram/save_block_check.asm` | 4E | 565 | 269 | code 565 |
| `engine/sram/write_byte_far.asm` | 48 | 99 | 47 | code 99 |

#### `engine/startup/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/startup/boot_stage2.asm` | 4F | 230 | 109 | code 230 |
| `engine/startup/notice_pages.asm` | 65 | 1010 | 351 | code 698, data 254, words 48, ptrtable 10 |
| `engine/startup/registration.asm` | 65 | 1881 | 895 | code 1881 |
| `engine/startup/startup.asm` | 65 | 291 | 123 | code 255, ptrtable 30, data 6 |

#### `engine/text/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/text/canvas.asm` | 7F | 2702 | 1252 | code 2619, data 51, ptrtable 32 |
| `engine/text/charset_convert.asm` | 7E | 823 | 387 | code 813, words 10 |
| `engine/text/font_8x16.asm` | 48 | 369 | 119 | code 232, data 137 |
| `engine/text/glyph.asm` | 7F | 490 | 161 | code 316, data 174 |
| `engine/text/half_to_full_width.asm` | 55 | 462 | 27 | text 448, code 14 |
| `engine/text/sjis_validity.asm` | 63 | 122 | 51 | code 106, ptrtable 16 |
| `engine/text/text_tiles.asm` | 48 | 547 | 260 | code 547 |

#### `engine/title/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/title/title_screen.asm` | 0E | 960 | 441 | code 923, zero 15, ptrtable 14, data 8 |

#### `engine/tutorial/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/tutorial/gates.asm` | 48 | 287 | 136 | code 287 |

#### `engine/unreferenced/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `engine/unreferenced/page_list_prototype.asm` | 7F | 5508 | 2445 | code 5094, text 357, ptrtable 24, words 24, data 9 |

#### `gfx/account/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/account/screens_bank4a.asm` | 4A | 8064 | 504 | gfx 5712, data 2331, zero 13, words 8 |
| `gfx/account/screens_bank4b.asm` | 4B | 6336 | 396 | gfx 4088, data 2248 |
| `gfx/account/screens_bank5d.asm` | 5D | 11104 | 695 | gfx 8512, data 2585, zero 7 |
| `gfx/account/screens_bank5e.asm` | 5E | 12448 | 779 | gfx 9504, data 2928, zero 16 |
| `gfx/account/screens_bank71.asm` | 71 | 12100 | 756 | gfx 8151, data 3923, words 26 |

#### `gfx/address_book/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/address_book/address_editor.asm` | 2F | 1775 | 110 | data 1695, ptrtable 80 |
| `gfx/address_book/address_picker.asm` | 2C | 3308 | 206 | gfx 1936, data 1292, ptrtable 80 |
| `gfx/address_book/entry_screen_bank29.asm` | 29 | 1920 | 120 | gfx 1856, data 64 |
| `gfx/address_book/entry_screen_bank2a.asm` | 2A | 400 | 25 | gfx 400 |
| `gfx/address_book/list.asm` | 2F | 856 | 53 | data 792, ptrtable 64 |
| `gfx/address_book/list_tiles_bank22.asm` | 22 | 2560 | 160 | data 2560 |
| `gfx/address_book/name_editor.asm` | 2F | 2832 | 177 | gfx 2048, data 784 |
| `gfx/address_book/save_confirm.asm` | 2A | 1872 | 117 | gfx 1088, data 784 |
| `gfx/address_book/save_sender_address.asm` | 2A | 2549 | 159 | data 1327, gfx 1072, words 150 |
| `gfx/address_book/shared_tiles_bank28.asm` | 28 | 2272 | 142 | gfx 1536, data 624, words 112 |
| `gfx/address_book/unreferenced_confirm_screen.asm` | 2C | 2192 | 137 | data 1744, gfx 432, ptrtable 16 |

#### `gfx/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/bank41.asm` | 41 | 13632 | 852 | gfx 10240, data 3392 |
| `gfx/bank42.asm` | 42 | 13632 | 712 | gfx 7815, data 3408, zero 2409 |
| `gfx/bank43.asm` | 43 | 13632 | 852 | gfx 10240, data 3392 |
| `gfx/bank44.asm` | 44 | 13632 | 852 | gfx 10240, data 3392 |
| `gfx/bank45.asm` | 45 | 13632 | 852 | gfx 10240, data 3392 |
| `gfx/bank46.asm` | 46 | 13632 | 852 | gfx 10240, data 3392 |
| `gfx/bank52.asm` | 52 | 3072 | 185 | gfx 2944, zero 128 |
| `gfx/bank5b.asm` | 5B | 5856 | 366 | gfx 5760, data 96 |
| `gfx/bank60.asm` | 60 | 15080 | 942 | gfx 12336, data 2744 |
| `gfx/bank61.asm` | 61 | 15080 | 942 | data 12280, gfx 2800 |

#### `gfx/browser/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/browser/frames_0_1.asm` | 47 | 7072 | 442 | gfx 5376, data 1696 |
| `gfx/browser/frames_2_3.asm` | 47 | 6816 | 426 | gfx 5120, data 1696 |
| `gfx/browser/menus.asm` | 72 | 3599 | 225 | gfx 2560, data 963, words 68, zero 8 |
| `gfx/browser/page_list.asm` | 24 | 6128 | 383 | data 3055, gfx 2720, words 238, zero 115 |
| `gfx/browser/start_choice.asm` | 73 | 7808 | 488 | gfx 6320, data 1488 |

#### `gfx/comm/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/comm/comm_scene.asm` | 70 | 11630 | 727 | gfx 6144, data 5223, ptrtable 250, zero 13 |
| `gfx/comm/connect_dialog_bank56.asm` | 56 | 14406 | 900 | gfx 9558, data 4824, words 24 |
| `gfx/comm/connection_icon.asm` | 69 | 2804 | 175 | gfx 1550, data 1174, ptrtable 80 |
| `gfx/comm/notice_dialog.asm` | 50 | 10628 | 664 | data 6094, gfx 4512, words 16, zero 6 |
| `gfx/comm/time_summary.asm` | 51 | 11840 | 740 | gfx 10239, data 1600, zero 1 |

#### `gfx/dialog/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/dialog/dialog_window.asm` | 72 | 1899 | 118 | gfx 1024, data 871, words 4 |

#### `gfx/error/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/error/comm_error_screen.asm` | 5C | 3865 | 241 | data 2175, gfx 1680, zero 10 |
| `gfx/error/no_adapter.asm` | 63 | 4783 | 298 | gfx 4160, data 615, words 8 |
| `gfx/error/non_cgb_screen.asm` | 6B | 3200 | 191 | gfx 3024, zero 176 |

#### `gfx/help/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/help/help_screens_a.asm` | 6A | 9393 | 587 | gfx 5152, data 4233, zero 8 |
| `gfx/help/help_screens_b.asm` | 6A | 2985 | 186 | gfx 2106, data 875, words 4 |
| `gfx/help/mobile_dictionary.asm` | 1A | 3621 | 226 | gfx 2315, data 1306 |

#### `gfx/keyboard/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/keyboard/panels_bank5d.asm` | 5D | 2048 | 128 | gfx 2048 |
| `gfx/keyboard/panels_bank5f.asm` | 5F | 11216 | 582 | gfx 5149, data 4025, zero 1928, words 114 |
| `gfx/keyboard/tiles_bank62.asm` | 62 | 11264 | 704 | gfx 11264 |
| `gfx/keyboard/tiles_bank66.asm` | 66 | 13496 | 843 | gfx 12688, data 808 |

#### `gfx/mail/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/mail/address_editor.asm` | 2D | 3392 | 212 | data 2864, gfx 528 |
| `gfx/mail/body_editor.asm` | 2D | 2800 | 175 | gfx 1632, data 1168 |
| `gfx/mail/body_view.asm` | 28 | 2320 | 145 | data 1634, gfx 656, words 16, zero 14 |
| `gfx/mail/comm_progress_scene.asm` | 22 | 848 | 53 | data 848 |
| `gfx/mail/comm_result.asm` | 24 | 4440 | 277 | gfx 2976, data 1212, words 252 |
| `gfx/mail/compose_objects.asm` | 29 | 612 | 38 | data 344, words 260, zero 8 |
| `gfx/mail/connect_screen.asm` | 27 | 11396 | 712 | gfx 8192, data 2980, ptrtable 224 |
| `gfx/mail/connect_screen_bank29.asm` | 29 | 1946 | 121 | gfx 1034, data 912 |
| `gfx/mail/draft_menu.asm` | 2B | 2883 | 180 | gfx 1536, data 1207, words 140 |
| `gfx/mail/mail_title_entry.asm` | 2C | 3266 | 204 | data 3246, ptrtable 16, zero 4 |
| `gfx/mail/mail_viewer.asm` | 2B | 3378 | 211 | gfx 1920, data 1298, words 160 |
| `gfx/mail/received_mail_grid.asm` | 2B | 2754 | 172 | gfx 1824, data 912, words 18 |
| `gfx/mail/server_status.asm` | 25 | 4208 | 263 | data 2160, gfx 2048 |
| `gfx/mail/server_status_bank26.asm` | 26 | 1680 | 105 | gfx 1648, data 32 |
| `gfx/mail/session_objects.asm` | 28 | 2877 | 179 | data 1933, words 944 |
| `gfx/mail/session_scenery.asm` | 26 | 6728 | 420 | gfx 6664, data 64 |

#### `gfx/mail_menu/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/mail_menu/mail_menu.asm` | 1D | 7673 | 479 | gfx 5392, data 2266, zero 15 |

#### `gfx/mail_server/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/mail_server/delete_all_screen.asm` | 28 | 2672 | 167 | gfx 1824, data 848 |
| `gfx/mail_server/delete_menu_hidden.asm` | 22 | 2160 | 135 | data 2160 |
| `gfx/mail_server/delete_method_screen.asm` | 28 | 4096 | 256 | gfx 2368, data 1696, words 32 |
| `gfx/mail_server/delete_progress.asm` | 23 | 3929 | 246 | data 1908, gfx 1632, words 380, zero 9 |
| `gfx/mail_server/tidy_screen.asm` | 2E | 8833 | 552 | gfx 4736, data 4017, words 80 |

#### `gfx/mailbox/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/mailbox/mailbox.asm` | 25 | 5408 | 338 | gfx 3232, data 2176 |
| `gfx/mailbox/objects.asm` | 26 | 657 | 41 | data 429, words 224, zero 4 |

#### `gfx/profile/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/profile/profile_editor.asm` | 2A | 3221 | 201 | data 3121, words 100 |

#### `gfx/registration/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/registration/screen_bank4b.asm` | 4B | 720 | 45 | data 720 |
| `gfx/registration/screens_bank58.asm` | 58 | 16032 | 1002 | gfx 15184, data 848 |

#### `gfx/settings/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/settings/screens_bank4a.asm` | 4A | 5112 | 319 | gfx 4432, data 680 |
| `gfx/settings/screens_bank4b.asm` | 4B | 9296 | 581 | gfx 6912, data 2384 |
| `gfx/settings/screens_bank4d.asm` | 4D | 14723 | 920 | gfx 13104, data 1603, words 16 |
| `gfx/settings/screens_bank5d.asm` | 5D | 2832 | 177 | gfx 2048, data 784 |
| `gfx/settings/screens_bank5e.asm` | 5E | 2048 | 128 | gfx 2048 |
| `gfx/settings/screens_bank71.asm` | 71 | 2044 | 127 | data 1994, gfx 50 |

#### `gfx/title/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/title/logo.asm` | 0E | 2832 | 177 | gfx 2048, data 784 |
| `gfx/title/title_screen.asm` | 0E | 7392 | 462 | gfx 6304, data 1088 |

#### `gfx/top_menu/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/top_menu/top_menu.asm` | 1E | 9396 | 587 | gfx 6400, data 2901, words 88, zero 7 |

#### `gfx/unreferenced/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `gfx/unreferenced/page_list_prototype.asm` | 7F | 3661 | 228 | gfx 1968, data 1533, words 160 |
| `gfx/unreferenced/page_list_prototype_objects.asm` | 7F | 1173 | 73 | gfx 720, data 373, words 80 |

#### `home/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `home/audio.asm` | 00 | 227 | 108 | code 227 |
| `home/bank_switch.asm` | 00 | 149 | 70 | code 149 |
| `home/copy.asm` | 00 | 104 | 49 | code 104 |
| `home/double_speed.asm` | 00 | 32 | 15 | code 32 |
| `home/far_helpers.asm` | 00 | 95 | 45 | code 95 |
| `home/far_read.asm` | 00 | 130 | 61 | code 130 |
| `home/far_string.asm` | 00 | 227 | 105 | code 221, words 6 |
| `home/farcall.asm` | 00 | 146 | 69 | code 146 |
| `home/gfx_upload.asm` | 00 | 525 | 250 | code 525 |
| `home/glyph_data.asm` | 00 | 218 | 103 | code 218 |
| `home/header.asm` | 00 | 336 | 32 | zero 228, data 76, code 32 |
| `home/html_store.asm` | 00 | 238 | 113 | code 238 |
| `home/init.asm` | 00 | 282 | 107 | code 218, data 64 |
| `home/interrupt_handlers.asm` | 00 | 77 | 36 | code 77 |
| `home/jump_table.asm` | 00 | 95 | 45 | code 95 |
| `home/keyword_scan.asm` | 00 | 561 | 267 | code 561 |
| `home/lcd.asm` | 00 | 99 | 47 | code 89, ramcode 10 |
| `home/mobile.asm` | 00 | 296 | 140 | code 296 |
| `home/multiply.asm` | 00 | 58 | 27 | code 58 |
| `home/multiply_divide.asm` | 00 | 133 | 63 | code 133 |
| `home/random.asm` | 00 | 294 | 34 | data 256, code 38 |
| `home/sprites.asm` | 00 | 638 | 303 | code 638 |
| `home/stat_handler.asm` | 00 | 64 | 30 | code 64 |
| `home/string.asm` | 00 | 126 | 59 | code 126 |
| `home/text.asm` | 00 | 534 | 227 | code 470, words 64 |
| `home/text_measure.asm` | 00 | 183 | 87 | code 183 |
| `home/tilemap_copy.asm` | 00 | 34 | 16 | code 34 |
| `home/vblank.asm` | 00 | 326 | 155 | code 326 |

#### `lib/mobile/`

| file | banks | bytes | est. lines | kinds |
|---|---|---:|---:|---|
| `lib/mobile/mail.asm` | 0F | 7598 | 3369 | code 7015, text 496, ptrtable 60, words 26, zero 1 |
| `lib/mobile/main.asm` | 75 | 16198 | 7151 | code 14861, data 712, text 483, ptrtable 142 |

