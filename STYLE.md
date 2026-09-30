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

The game's text is **Shift-JIS**, NUL terminated (`docs/research/text_encoding.md`).  It is written as readable strings, not as bytes:

```asm
	db "メール", 0
	db "ホームページ", $FA, "みます", 0
	db "<A HREF=\"../di/address.htm\">メール</A>", $0D, $0A
```

The strings are turned into the original bytes by two multi-byte RGBDS charmaps in `constants/sjis_charmap.asm` (`charmap "メ", $83, $81`), so the ROM stays
identical (`make` prints `SHA-256 OK`).  The file is **generated** by `tools/gen_sjis_charmap.py` from the ROM's text regions (do not edit it; `python3 tools/gen_sjis_charmap.py --check`
tells whether it is current).

| charmap | contains | used by |
|---|---|---|
| `sjis` | ASCII `20`-`7E` (`5C` = `¥`, `7E` = `‾` as in the 6x12 Latin font) and every JIS X 0208 double-byte character that occurs in the ROM's text | all text under `data/` |
| `sjis_hw` | `sjis` + single bytes `A1`-`DF` as half-width katakana in JIS X 0201 order | `data/text/help_script.asm` (bank 6C, the "second convention"); the glyph a byte draws is unproven (`text_encoding.md` section 6), the charmap only names the bytes |

### Charmap discipline

* `includes.asm` includes the charmap file, which ends with `SETCHARMAP main`: the default charmap is empty and stays active in code, so a stray string in code is not re-encoded.
* A data file that has strings starts with `PUSHC sjis` (or `PUSHC sjis_hw`) right after its `SECTION` line and ends with `POPC`.  Never use `SETCHARMAP` in a source file; never define a charmap outside `constants/sjis_charmap.asm`.
* `rgbasm -Weverything` reports `-Wunmapped-char` for a character the active charmap lacks (the build is warning-free; keep it so).  A character that the ROM never uses is not in the file:
  a patch that needs one adds a `charmap "X", $hh, $ll` line by hand (the exact cp932 code) and then `--check` no longer applies.

### Writing strings

* **One string per line**, ending with its terminator (`db "…", 0`); a `$0D` (newline; CR LF in HTML) ends a line of a multi-line message: `db "…", $0D` / `db "…", 0`.  Label the start of a string that something refers to; keep the existing `String_BB_AAAA` names.
* **Bytes that are not a plain character stay explicit** between the quoted parts: control bytes (`$0D`, `$01, $20` in the keyboard rows, the `$86, $02, $01` record header), gaiji `F8`-`FF`, unknown singles, the bank 6C string header `$06, $xx, $yy, $03, $aa, $bb`.
  Do not give them a character or a name without evidence (`text_encoding.md` sections 4 and 6 list what is known).
* Inside quotes write `\"` for `"`, `\\` for `\`, `\{` and `\}` for the braces (RGBDS escapes).  The ideographic space `81 40` is `"　"`.
* Long strings are not wrapped by hand: split at the game's own line breaks (`$0D`) only.  The decoded text is the source, so there is no trailing `; "…"` comment; a `db` line may still carry a hand-written comment (`; record header`).
* Records that contain text keep their structure: HTML store records (`data/html/pages_*.asm`) are `db "name.htm", 0` / `dw <body length> ; body length` / the body, one line per CR LF, ending `db "</HTML>", $0D, $0A, 0`.
  The length word stays a number (it is the byte length of the body including its final `0`).  `data/html/keywords.asm` items are `db "html", 0, $01` (name, NUL, value byte).
* **Only what is provably text is converted**: regions whose header says `text`, data regions of `data/text/` that are nothing but clean NUL-terminated strings, and the item tables of `keywords.asm`.
  Tables, cell data, images, record headers and executed-read data of unknown content class (`; ---- data ... content class unknown`) stay `db $xx`; where such a region contains text-like bytes a comment says why it was left
  (`; kept as raw bytes: ...`).  If evidence later shows that such bytes are a string, convert them by hand and change the region header.
* Adding a string changes the size of its section: the section has to be moved in `layout.link` (see "Adding, moving and removing code").

### Tools

```
python3 tools/gen_sjis_charmap.py            # regenerate constants/sjis_charmap.asm (reads the ROM, or mobile_trainer.gbc)
python3 tools/gen_sjis_charmap.py --check    # is it current?
python3 tools/text_to_strings.py --dry-run   # what would still be converted (nothing, once done)
python3 tools/text_to_strings.py             # convert numeric text blocks, then `make` and check the SHA-256 (restores the files if it differs)
```

`tools/text_to_strings.py` is idempotent and is the way to convert text that is added later as raw bytes; it never touches lines that already are strings.

* `String_BB_AAAA::` labels name string starts; text blocks are `text` regions, HTML-store pages (`data/html/`) are records `name NUL, dw body length, body`.
* The HTML store index (`data/html/index.asm`), the keyword tables and the ticker tables are `words`/`ptrtable`/`data` with the same header convention.
* `constants/charmap.asm` is analysis output (survey), not used by the build; `constants/sjis_charmap.asm` is the charmap that the build uses.

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

## Function comments and local labels

This section supersedes the region-header form for code (the `; ---- code $04D8-$04EE (22 bytes) [CONFIRMED] ...` line described under
"Evidence vocabulary") and the sentence "Local labels (`.foo`) are not used yet".  `tools/tidy_comments.py` and `tools/localize_labels.py` produced
the current form from the old one; both are idempotent and have `--check`.

### The comment of a function

The note of a block of code is a comment block directly under the label, after all alias labels and before the first instruction, indented with one tab
and wrapped at 100 columns (a tab counting 4):

```asm
FillBytes:: ; 00:04D8
	; [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear
	; VRAM/WRAM/HRAM in Boot
	inc b
```

* The comment starts with the **evidence status** of the block in brackets, `[CONFIRMED]`, `[PROBABLE]` or `[HYPOTHESIS]` (the vocabulary above), then the note.
  The tag is always written, also for `CONFIRMED`, so that a missing tag can never be mistaken for a status; it comes first so that it stays visible when the note wraps,
  and `grep -rn '\[PROBABLE\]'` / `'\[HYPOTHESIS\]'` lists what still needs evidence.
* The note keeps the wording and the evidence of the old header (executed in N scenarios, reached by static flow only, entered by a table/jrcc from X, ...).  It is only wrapped.
  Notes are never shortened to make them look tidy; a name or a claim without evidence is not added (a comment that says what a function does is written only when that is
  demonstrated, and then it says how).  When you learn more, extend the note and change the tag only with a cited fact.
* Dropped from the old header: the kind (`code`, `ramcode`), `$start-$end` and `(n bytes)`.  The address is on the label line (`; BB:AAAA`, checked by `tools/sym_check.py`)
  and in `build/mobile_trainer.sym`; the size is the distance to the next block.
* A piece of code that has no label (the fall-through part of a function cut into a separate block by the coverage analysis) has its note above its first instruction,
  after a blank line, indented like the code.  A note under a local label works the same way.
* `data`, `words`, `ptrtable`, `text`, `gfx` and `zero` blocks keep their `; ---- kind $start-$end (n bytes) [STATUS] note` header.

### Local labels

A branch target that is used only by `jr`/`jp` of its own function is a local label (`.name`, no colon, `; BB:AAAA` comment kept on the line), as in pokecrystal:

```asm
FillBytes:: ; 00:04D8
	inc b
	dec b
	jr nz, .l04E1
.loop ; 00:04DC
	ld [hli], a
	dec c
	jr nz, .loop
	ret
.l04E1 ; 00:04E1
```

* Scope: a local label belongs to the closest global label above it; the linker lists it as `Function.name` in the `.sym` file (`FillBytes.loop`).  `tools/sym_check.py` checks
  local labels like global ones.  No blank line in front of a local label.
* Names: `.lAAAA` is the default (`AAAA` = the address of the old generic name `Label_BB_AAAA`, so the historic position is kept; the bank is that of the file).  A role name is
  used only when the code itself shows the role **and** it is unique in its scope: `.loop` (every jump to it is backward), `.done` (every jump is forward and the label is directly
  followed by `ret`), `.skip` (one conditional forward jump over one to three plain instructions).  Anything else, and every case where the role is not obvious, keeps `.lAAAA`.
  Rename a local label to a meaningful name (`.next_char`) only with evidence, like any other name.
* Stay global (`Label_BB_AAAA::`): a label that is referenced by `call`, `farcall`, `ld`, `dw`/`db`, an expression, another function or another file (jump tables, callbacks, entry
  points), or that is not referenced at all.  A label that stays global also ends the scope of the labels above it, so a local label used on both sides of it stays global as well.
* A function can fall through into the next global label; that is fine.
* Local labels change nothing in the ROM: `make` must still print `SHA-256 OK`.  `python3 tools/localize_labels.py --check` and `python3 tools/tidy_comments.py --check` exit 0
  when the tree is in this form.

## Graphics assets (PNG and binary files)

This section supersedes the bullet "The build has no asset conversion step ... no `INCBIN`" of the "Graphics" section above: the graphics blocks are now
files, and the `.asm` files under `gfx/` and `data/fonts/` `INCBIN` them.  The layout, the file list (with sizes, `bank:addr` and evidence status) and the
PNG modes are in [`gfx/README.md`](gfx/README.md) and `gfx/assets.tsv`.

* **What is a file**: 2bpp tile blocks (`.2bpp` + `.png`), tile-index maps (`.tilemap`), CGB attribute maps (`.attrmap`), CGB palettes (`.pal`, `RGB r, g, b` lines),
  the 8x16 1bpp font runs (`.1bpp`), the JIS 12x12 / 6x12 fonts and the Shift-JIS validity bitmap (`.bin`, with a view-only `_view.png`).  A `tilemap+attr` block that
  `copy_tilemap_rect_pair` loads is two files (tile bytes, then attribute bytes) INCBINed back to back.  A block is converted only when its region header note, its label or
  `config/symbols` says what it is and the bytes fit (palette: even size and every word < $8000; map: size = the width x height the note states); everything else
  (sprite frame records, animation scripts, object tables, "read as data, class unknown", fragments shorter than four tiles, partial tiles at the end of a tile block) stays `db`.
* **In the `.asm`**: the region header comment, the labels and the pinning are unchanged; only the `db` rows are replaced, and the bytes must be exactly the ones the header counts
  (the section keeps its size, so `layout.link` and the SHA-256 do not change):

  ```asm
  ; ---- gfx $43C0-$47C0 (1024 bytes) [CONFIRMED] tiles-vram: ... hdma_rom_to_vram at 0E:4231: hl=$43C0 ... de=$8000
  Gfx_Title_Tiles0:: ; 0E:43C0
  	INCBIN "gfx/title/title_screen/title_tiles0.2bpp"
  ; ---- data $5BC0-$5E90 (720 bytes) [CONFIRMED] tilemap+attr: ... copy_tilemap_rect_pair at 0E:42D0 ... b=18 rows c=20 cols
  Tilemap_Title_Screen:: ; 0E:5BC0
  	INCBIN "gfx/title/title_screen/title_screen.tilemap"
  	INCBIN "gfx/title/title_screen/title_screen.attrmap"
  Palette_Title_Bg:: ; 0E:5F30
  	INCLUDE "gfx/title/title_screen/title_bg.pal"
  ```
* **Paths**: `INCBIN` / `INCLUDE` paths are written relative to the repository root, with `/`, and resolve because the Makefile runs `rgbasm` from the root with `-I .`
  (`RGBASMFLAGS := -Weverything -P includes.asm -I .`); nothing else has to be configured.  The `-M` dependency files list every asset, so editing a `.2bpp` / `.pal` re-assembles
  only the file that includes it.  `.pal` files use the `RGB` macro of `constants/gfx_macros.inc` (`dw (b << 10) | (g << 5) | r`, components 0-31), pre-included by `includes.asm`.
* **Names**: directory = the `.asm` path without `.asm` (`gfx/title/title_screen.asm` -> `gfx/title/title_screen/`; fonts are in `data/fonts/`); file = the semantic label in `snake_case`
  without a leading `Gfx_` (and without a leading `tilemap_` / `attrmap_` / `palette_` that the extension repeats), or `<kind>_<addr>` (address in the bank, lowercase hex) when the block only has a
  generic label.  A name says what the label or header says, not more: naming a screen needs evidence like any other name (rename the asset, its `INCBIN` line and the manifest together).
* **PNG <-> 2bpp**: the PNG is an indexed 4-shade image, 16 tiles per row (see `gfx/README.md`), and is the *exact source* of the `.2bpp` next to it:

  ```
  rgbgfx -c embedded -o gfx/title/title_screen/title_tiles0.2bpp gfx/title/title_screen/title_tiles0.png     # add -x <pad> when assets.tsv lists pad > 0
  python3 tools/gfx_export.py bin       # the same for every exact PNG (paths and pad from gfx/assets.tsv)
  python3 tools/gfx_export.py png       # the other way: every .2bpp/.1bpp/.bin -> PNG (also refreshes the view-only sheets)
  python3 tools/gfx_export.py check     # every PNG through rgbgfx == its .2bpp, every view sheet decodes back to its bytes, INCBIN sizes, manifest
  ```

  `rgbgfx` is only needed to edit PNGs (RGBDS 1.0.3 has it); the ROM build never runs it.  Flags that would change the bytes are not used: no `-u` / `-m` (no tile dedupe), no `-t`,
  no palette reordering (`-c embedded` keeps the PNG's index order).  A view-only `_view.png` is never converted back.
* **A changed asset changes the ROM**: an edited `.2bpp` gives a ROM with a different hash.  Keep the size (the section must not grow, see "Adding, moving and removing code").
* **New assets**: put the file under `gfx/<area>/<name>/`, add a row to `gfx/assets.tsv` (columns as in its header; `png` = `-` before the first `png` run), `INCBIN` it at the
  right place with the region header and evidence status kept, then run `python3 tools/gfx_export.py png` (PNG + `png`/`pad` columns), `check` and `readme`.
* `.gitattributes` in `gfx/` and `data/fonts/` mark the binaries as binary (an attribute map without a NUL byte would otherwise be text to git and be changed by line-ending conversion).
