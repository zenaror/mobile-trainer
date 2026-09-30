# Style guide

The source was generated once and is now edited by hand.  This guide records the conventions the existing code follows, so that new code and
renames stay consistent with it.  The general assembly style follows [pokecrystal's STYLE.md](https://github.com/pret/pokecrystal/blob/master/STYLE.md)
(tabs for indentation, comments above the code, `PascalCase` labels).  Where old code disagrees, the surrounding code wins; when you meet an edge case that is not
covered here, add it.

## Evidence vocabulary

Everything the analysis claims has one of three statuses, written in capitals:

| status | meaning |
|---|---|
| `CONFIRMED` | demonstrated: executed in an emulator trace, a byte-identical library routine, an unambiguous disassembly fact.  Say how (address, trace, note). |
| `PROBABLE` | strong evidence that is not conclusive (static reach, a match with the Crystal SDK, a consistent usage pattern). |
| `HYPOTHESIS` | unverified; a guess that may guide the next test. |

Rules: never upgrade a status without a cited fact; a name that is not backed by evidence stays generic (below); never invent semantics
to make code look tidier.  Record the reasoning in `docs/research/*.md` and cite the note or the addresses in a comment at the code.

The existing forms:

```asm
; ---- code $04D8-$04EE (22 bytes) [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0)
DEF wGlyphBufLeft EQU $C0A0 ; size 24 array PROBABLE [g8] 24-byte glyph buffer ... (evidence)
DEF ABOOK_SLOT_COUNT EQU $0006 ; CONFIRMED Address-book slots: Abook_SlotAddrTable* have 6 words
```

* A region header `; ---- <kind> $start-$end (n bytes) [STATUS] note` opens each block of code, data, text, gfx, words, ptrtable or zero bytes and gives the status of the whole block.
* Kinds: `code`, `ramcode` (code copied to RAM, see below), `data`, `words` (table of 16-bit values), `ptrtable` (little-endian address table), `text`, `gfx`, `zero`.
* `[g1]`..`[g8]`, `[sdk]` inside the notes of RAM names name the analysis group whose note (`docs/research/naming_g1.md` .. `naming_g8.md`, `naming_sdk.md`) adopted the name.

## Files and sections

* One file = one floating section named after the path: `SECTION "engine/mail/compose", ROMX` (`ROM0` for bank 00).  Sections have no `[$addr]`/`BANK[]`; `layout.link` pins each of them.
* Every file starts with a three-line header: path, `bank BB, $start-$end (n bytes); pinned by layout.link`, one line of purpose.  Keep it correct when you move things.
* Files contain no `INCLUDE`: `includes.asm` (hardware names, RAM names, macros) is pre-included by the Makefile (`rgbasm -P includes.asm`).
* Directories: `home/` (ROM0), `lib/mobile/` (SDK banks 75 and 0F), `engine/<subsystem>/` (code), `data/` (text, HTML store, fonts, tables), `gfx/<screen>/` (tiles/tilemaps/palettes/object tables named after the consumer), `audio/`.
  Paths are lowercase, `[a-z0-9_]`, `.asm`.  A graphics block stored in a different bank than the code that loads it is named after the consumer and carries `_bankNN` (`gfx/mail/connect_screen_bank29.asm`).
* Data that only one routine uses stays in the routine's file, as in pokecrystal.

### Adding, moving and removing code

* Everything in the ROM is pinned by `layout.link` (`org $addr` followed by the section names, per bank).  Sections are packed back to back, so adding a byte to a routine
  makes its section run past the next `org` and the link fails with `Cannot decrease the current address (from $16a3 to $16a2) at layout.link(54)`
  (tested: one extra `nop` in `home/copy.asm`).  To grow a routine, move the following sections (edit their `org` lines) or free space first; to move a section, change its `org` line.
* A section that is not in `layout.link` floats: rgblink puts it into free space (tested: a new `SECTION "engine/new_thing", ROMX` went to `01:4000`, in an empty bank), which of course changes
  the ROM hash.  Use this for new code; a `farcall` to a floating label works (`BANK(Label)` is resolved by the linker).
* If you delete a file, delete its two lines (`org`, section name) from `layout.link`.  If you rename a section, rename it there too.
* `engine/account/comm_panel.asm` is reached by falling through from the end of `engine/account/registration_verify.asm` (`68:733C`); the two sections must stay adjacent.
  This is the only such fall-through between files.
* The all-zero space between and after the sections is not in any file; the linker pads it with `$00` (`rgblink -p 0x00`).  A label inside padding lives in `zero_labels.asm`.
* After a change run `make`: the SHA-256 tells you whether the ROM is still the original.  A *deliberate* change (a patch) of course changes it; work on a copy of the
  tree/branch for that and keep the reference hash for the unmodified build.

## Comments

```asm
; Use tabs for indentation, spaces for alignment.
; Comments go above the code they describe; short trailing comments after data lines are used
; (the decoded text of a string, the meaning of a word) and are fine there.

; Address comments  `Name:: ; BB:AAAA`  give the bank and address at the time of writing.  They are hints
; for navigation, the .sym file (build/mobile_trainer.sym) is authoritative: run `tools/sym_check.py --fix`
; after moving code to refresh them.  A ramcode label reads `; 00:05B2 (runs at $FF86)`.
```

## Labels and names

```asm
Name::               ; ROM label (all labels are global, the linker resolves cross-file references)
Account_ResultPage:: ; 68:766E     subsystem prefix, underscore, PascalCase
Function_68_6E1A::   ; generic: bank 68, address 6E1A, no evidence for a name yet
Label_00_04DC::      ; generic label inside a routine (jump target)
```

* **Semantic names** are `Subsystem_ThingDone` (`Title_Run`, `Account_ResultPage`, `MailStr_Boundary`, `CommPanel_WaitClose`, `SoundDrv_CmdSetTempo`).  Use one only with evidence.
* **Generic names** carry their original position and are never renamed by the tools: `Function_BB_AAAA` (routine entry), `Label_BB_AAAA` (jump target), `Data_BB_AAAA`
  (data), `Table_BB_AAAA` (word/pointer table), `String_BB_AAAA` (text), `Tiles_BB_AAAA`, `Tilemap_BB_AAAA`, `Attrmap_BB_AAAA`, `Palette_BB_AAAA`, `Font_BB_AAAA`.
  When code is moved, the position in the name does not follow; that is acceptable: it is the historic (original ROM) address, useful for cross-reference with `docs/research/`.
  Give a semantic name when you learn what it is (rename over the whole tree, then `make`).
* Local labels (`.foo`) are not used yet; all jump targets are global.  New code may use them.
* **RAM** (`ram/*.asm`): prefix by memory area as in pokecrystal: `w` WRAM (`wShadowOAM`), `s` SRAM (`sSram_MailRecords`), `h` HRAM/IO (`hROMBankLo`).  Neutral names
  are `wRam_XXXX`, `sSram_XXXX` (`XXXX` = CPU address).  WRAM `$D000-$DFFF` and SRAM `$A000-$BFFF` are banked: `ram/banked.asm` holds bank-qualified names; the same CPU address is a different variable in another bank.
* **Constants** are `UPPER_CASE` (`MAILREC_OFS_TIME`, `ABOOK_SLOT_COUNT`); hardware registers are `rNAME` and bit masks `NAMEF_*` / `NAMEB_*` (`constants/hardware.inc`).
* Numbers: hexadecimal with `$` and upper-case digits (`$04D8`, `$FF`), decimal only for counts.  Instructions are lowercase with the explicit operand form the generator used (`or a, a`, `ld a, $08`).
* Names must be unique across the ROM (labels, constants and RAM names share one namespace) and must not clash with an RGBDS keyword.

## Far calls and inline data

The Trainer calls code in other banks through the routine at `00:06D1` (`FarCall`), with the target address and bank stored right after the `call`:

```asm
	farcall CommPanel_Step        ; = call FarCall ; dw CommPanel_Step ; db BANK(CommPanel_Step)
```

* `farcall Label` is the form of all 5,274 far calls; the bank byte is `BANK(Label)`, so it follows the label if it moves.
* `farcall_raw $addr, $bank` (`constants/macros.inc`) spells the same three bytes for a target that has no label at exactly that address; no site needs it today.
* Other inline-data callees are documented in `config/conventions.tsv` (`call $06BC ; dw target` where the bank is taken from `hFFF3`, `jp` forms, jump tables read from the bytes after the call).  Their inline bytes are written as `dw`/`db`.
* Never put a section boundary between a `call` and its inline bytes.

## Code

* A `code` block is a linear disassembly.  If evidence shows that bytes inside it are data, split the block: end the code before, put `db`/`dw` after, and update the region header.
* `ramcode` (the OAM DMA routine, 10 bytes, copied to `$FF80`) is a `LOAD "RAM_00_05AC", HRAM[$FF80]` block; its ROM image stays in the section (`home/lcd.asm`).
* Unreachable or never-executed code stays, with its status.  Do not delete it to tidy up: the ROM must stay identical.
* Conditional branches use `jr` where the original does; do not change instruction forms (a `jr` vs a `jp` changes the size).
  The assembler options matter for identical bytes: the Makefile assembles with `-Weverything` and no other optimisation flags.

## Text

* Text is **Shift-JIS**, NUL terminated (`docs/research/text_encoding.md`).  It is written as bytes, never re-encoded:
  ```asm
  	db $63, $64, $6D, $61, $6F, $6E, $65, $2E, $68, $74, $6D, $00 ; "cdmaone.htm"
  ```
  one string (or one record) per line, the decoded text in a trailing comment (so the file can be read, searched and diffed).  The comment is informational.
* `String_BB_AAAA::` labels name string starts; text blocks are `text` regions, HTML-store pages (`data/html/`) are records `name NUL, dw body length, body`.
* The HTML store index (`data/html/index.asm`), the keyword tables and the ticker tables are `words`/`ptrtable`/`data` with the same header convention.
* `constants/charmap.asm` is analysis output (survey), not used by the build.

## Graphics

* Graphics are raw 2bpp tile data, tilemaps, attribute maps, palettes and object tables written as `db` rows of 16 bytes, under a `gfx` region header that states how the block is loaded
  (`tiles-vram: ... hdma_rom_to_vram at 0E:436B: hl=$60A0 ... dest VRAM $9000`).  No compression has been demonstrated: assets are stored raw.
* `Tiles_`, `Tilemap_`, `Attrmap_`, `Palette_` (generic) or `Gfx_<Screen>_<Kind>` (named) label the blocks.
* `zero` blocks are padding; the fonts (`data/fonts/`) are JIS X 0208 12x12 1bpp rows, one file per font bank.
* The build has no asset conversion step: there is no `INCBIN` of any file and no graphics tool is needed.  If assets are ever extracted to PNG/binary files, the rebuilt bytes must stay identical.

## Words, tables and pointers

* `words` = 16-bit values (`dw $0109 ; body length`), `ptrtable` = address tables (`dw String_6A_64D3`, targets that have a label are written as labels; numeric ones stay numeric until the target has a name).
* Inline jump tables (`JumpTableInline`, `FarJumpTable`, `home/jump_table.asm`) are `dw` lists behind the call that uses them.

## Git and commits

* Small commits, one topic each; `make` must print `SHA-256 OK` (unless the commit is a deliberate ROM change, which says so).
* Do not commit `mobile_trainer.gbc`, `build/`, or the original ROM (git-ignored).
