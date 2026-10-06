# Mobile Trainer (Japan)

A disassembly of the *Mobile Trainer* (Japan) Game Boy Color cartridge (Mobile Adapter GB software, 2 MiB, MBC5+RAM+BATTERY, CGB only)
in RGBDS assembly.  It builds the **original ROM byte for byte**:

```
SHA-256  6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

The source is organised like [pokecrystal-mobile-eng](https://github.com/gb-mobile/pokecrystal-mobile-eng) (`home/`, `engine/`, `data/`,
`gfx/`, `audio/`, `lib/mobile/`, one `layout.link` that pins the sections).  Bank 75 is the Mobile Adapter GB SDK (the same code as
Pokémon Crystal's `lib/mobile/main.asm`, `lib/mobile/mail.asm`), the rest is the Trainer application.

The `.asm` tree is **hand-maintained source**: it was produced once by a bootstrap generator from the analysis tables in `config/`
(that *pipeline* is frozen, see "History" below), and from now on the `.asm` files are edited directly.  Nothing is generated at build time and the
original ROM is **not** needed to build; it is only used, if you have it, to compare.  Graphics are files (`.2bpp`, `.tilemap`, `.pal`, ... with PNGs next to them)
that the `.asm` files `INCBIN`; Shift-JIS text is written as readable strings (`db "メール", 0`) through a charmap; jump targets inside a function are local labels (`.loop`, `.l04E1`);
every function has a `[CONFIRMED]`/`[PROBABLE]`/`[HYPOTHESIS]` note under its label.  The conventions are in [STYLE.md](STYLE.md).

## Building

Requirements: [RGBDS](https://rgbds.gbdev.io/) **1.0.3** (`rgbasm`, `rgblink`) and GNU make.  Python 3 and `rgbgfx` (part of RGBDS) are **optional**: `rgbgfx` is only used to
turn edited PNGs back into `.2bpp` files, the build itself never runs it.  Details: [INSTALL.md](INSTALL.md).

```
make                 # assemble every file, link, check the SHA-256 (+ byte-compare if the original ROM is present)
make -j8             # the same, in parallel
```

The result is `mobile_trainer.gbc` (repository root), with `build/mobile_trainer.map` and `build/mobile_trainer.sym` (about 12,000 symbols: global labels, local labels `Function.name`, and the 31 exported constants).  A successful build prints

```
SHA-256 OK: 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

and, when `baserom.gbc` or `Mobile Trainer (Japan).gbc` is next to the Makefile, `RESULT: IDENTICAL`.  The build is incremental: every `.asm` file
is its own object (`rgbasm -P includes.asm`, dependency files `-M -MP`), so an edit re-assembles only that file, and a change to `includes.asm`,
`ram.asm`, `ram/` or `constants/` re-assembles everything.

| target | what it does |
|---|---|
| `make` | build `mobile_trainer.gbc`, SHA-256 check against `roms.sha256`, byte compare when the original ROM is present |
| `make compare` | byte-for-byte comparison with the original ROM (`tools/compare_rom.py`, reports the first differing regions) |
| `make sym-check` | every label of the source is in `build/mobile_trainer.sym`, at the bank:address its `; BB:AAAA` comment gives (`tools/sym_check.py --fix` refreshes stale comments) |
make png-check       # verify every editable PNG (graphics) and explain problems in plain words
make png-bins        # rebuild only the graphics binaries from their PNGs
make png-export      # regenerate PNGs from the binaries (maintainers)
| `make test` | tests of the analysis tools (SM83 decoder, config loader, legacy generator self test; needs the original ROM as `baserom.gbc`) |
| `make clean` / `make tidy` | delete `mobile_trainer.gbc` and `build/` (the original ROM is never touched) |
| `make regen` (and `verify`, `tree*`) | refuse to run: the generator must not be run over the maintained source, see "History" |
| `make legacy-check` | run the frozen bootstrap generator in a temp dir and confirm it still reproduces the ROM (needs the original ROM; touches nothing in the source) |
| `make progress`, `make conventions-check` | reports over the frozen `config/` tables (`progress` rewrites `docs/PROGRESS.md`); they do not follow edits made to the source; need the original ROM |

## How to verify

* **Hash only** (no original ROM needed): `make` prints `SHA-256 OK`; the expected hash is the first field of `roms.sha256`.
* **Byte compare** (with the original): put the ROM next to the Makefile as `Mobile Trainer (Japan).gbc` (or `baserom.gbc`), run `make`.
  It ends with `RESULT: IDENTICAL`.  The ROM is git-ignored and is never modified by any target.
* **Symbols**: `make sym-check` (labels vs the linker's `.sym`).
* **Layout coverage** (analysis of the pin table, needs the original ROM): `python3 tools/check_layout.py`.
* **Form of the source** (Python, no ROM needed): `python3 tools/tidy_comments.py --check`, `python3 tools/localize_labels.py --check`, `python3 tools/gen_sjis_charmap.py --check`
  (the charmap is generated from the ROM's text regions or from `mobile_trainer.gbc`), `python3 tools/gfx_export.py check` (PNGs vs `.2bpp`, needs `rgbgfx`).
* **ROM pointer operands** (needs a built tree and rgbasm): `python3 tools/apply_rom_operands.py --check` lists the `ld hl|de|bc, $XXXX` ROM pointers that a consumer rule proves and that are still numeric (none are); `python3 tools/test_rom_operands.py` tests the tool.
* **Sound calls** (no build needed): `python3 tools/apply_play_sfx.py --check` lists a user-interface sound call that is still spelled out instead of `play_sfx ID`; `python3 tools/test_play_sfx.py` tests the tool.
* **Invariants of the naming passes** (needs a built tree): `python3 tools/invariants_check.py` re-derives the two statements that rows of `analysis/naming2/` rest on: the mail library (bank 0F) runs only under WRAM bank 5 and the sound driver (bank 04) only under bank 1.

## Directory layout

| path | content |
|---|---|
| `home/` | all of ROM0 (bank 00): vectors, boot, VBlank, copy/fill, far-call and bank switching, sprite engine, text interpreter, string helpers |
| `engine/<subsystem>/` | application code by subsystem (`account/`, `address_book/`, `browser/`, `comm/`, `html/`, `keyboard/`, `mail/`, `mobile/`, `settings/`, `startup/`, ...); data used only by a routine stays in its file |
| `lib/mobile/` | `main.asm` (bank 75, Mobile Adapter GB SDK), `mail.asm` (bank 0F, mail library) |
| `data/` | Shift-JIS text as readable strings (`text/`), the built-in HTML store (`html/`), fonts (`fonts/`, assets `.bin`/`.1bpp`), keyboard tables, default adapter images |
| `gfx/` | tiles, tilemaps, palettes and object tables, named after the screen that loads them; `gfx/<area>/<file>.asm` holds the labels, headers and `INCBIN` lines, the bytes are in `gfx/<area>/<file>/` (`.2bpp` + `.png`, `.tilemap`, `.attrmap`, `.pal`); `gfx/bankNN.asm` = blocks with no known consumer; index: [`gfx/README.md`](gfx/README.md), `gfx/assets.tsv` |
| `audio/` | sound driver (`engine.asm`), note/instrument tables, song headers and one file per song (`music/`), sound effects |
| `ram.asm`, `ram/` | RAM names: `sram.asm`, `wram.asm`, `hram.asm`, `banked.asm` (equates only) |
| `consts.asm` | numeric constants (record offsets, counts) |
| `zero_labels.asm` | labels that point into all-zero padding (tiny pinned sections) |
| `includes.asm` | pre-included into every file: hardware names, RAM names, macros |
| `layout.link` | rgblink script: pins every section to its original bank and address |
| `constants/` | `hardware.inc` (register names), `macros.inc` (`farcall`), `sjis_charmap.asm` (the two Shift-JIS charmaps `sjis` and `sjis_hw` used by the readable strings in `data/` and in code files, generated by `tools/gen_sjis_charmap.py`), `gfx_macros.inc` (`RGB` palette macro), `charmap.asm` (analysis output of `tools/survey.py`, not used by the build) |
| `tools/` | analysis scripts, ROM comparison, `sym_check.py`, source-form tools (`tidy_comments.py`, `localize_labels.py`, `text_to_strings.py`, `gen_sjis_charmap.py`, `gfx_export.py`) and the frozen generator |
| `config/`, `analysis/` | frozen bootstrap tables and analysis evidence (history, see below) |
| `docs/` | index in [`docs/README.md`](docs/README.md): ROM identification, formats of the frozen tables, per-topic research notes (`docs/research/`), progress metrics of the frozen classification |
| `traces/` | emulator traces used as dynamic evidence |

The layout of the files themselves (why a file is where it is) is explained in [`analysis/layout/README.md`](analysis/layout/README.md).
Every source file starts with its path, its bank and address range, and a one-line purpose:

```
; home/copy.asm
; bank 00, $04D8-$0540 (104 bytes); pinned by layout.link
; FillBytes/FillWords/CopyBytes/CopyBytesBackward

SECTION "home/copy", ROM0
```

**Sections float and layout.link pins them.**  To keep the ROM identical, every section has an `org` line in `layout.link`.  A new section
that is not listed there floats (rgblink places it in free space) and changes nothing else; a file that is removed or renamed needs its line in
`layout.link` removed or renamed.  See [STYLE.md](STYLE.md) "Adding, moving and removing code".

## What is known, and how evidence is recorded

Evidence levels are `CONFIRMED` (demonstrated by disassembly, a trace or byte identity), `PROBABLE` (strong evidence, not conclusive) and
`HYPOTHESIS` (unverified).  A name without evidence stays neutral: `Function_BB_AAAA`, `Label_BB_AAAA`, `Data_BB_AAAA`, `Table_BB_AAAA`, `String_BB_AAAA`, `Tiles_BB_AAAA`, ..., `wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`
(bank and address of the original ROM).  A name with evidence is `Subsystem_ThingDone`; the neutral name then stays as an alias label on the next line.

* **In the source (last state of the analysis)**: a block of code has a `; [CONFIRMED|PROBABLE|HYPOTHESIS] note` comment right under its label; a block of `data`/`words`/`ptrtable`/`text`/`gfx`/`zero`
  begins with a header comment `; ---- data $4A00-$4B68 (360 bytes) [PROBABLE] why ...`; RAM names (`ram/*.asm`) and constants (`consts.asm`) carry the status word and the evidence after the value.
  `grep -rn '\[HYPOTHESIS\]'` lists what still needs evidence.
* **Frozen per-symbol tables**: `config/symbols/bankNN.tsv` (name, status, evidence text of every symbol), `config/regions/bankNN.tsv` (status and note of every region), `config/ram/`, `config/xrefs.tsv` hold the
  full evidence text (see [`config/README.md`](config/README.md)).
* **Research notes**: `docs/research/*.md` (boot flow, adapter protocol, SRAM layout, text encoding, per-group classification and naming notes, open questions; index in [`docs/README.md`](docs/README.md)); dynamic
  evidence in `analysis/` and `traces/`.
* **New work**: record findings in `docs/research/*.md` (what was shown, how, which addresses) **and** in the `[STATUS]` comment at the code,
  and rename a symbol only when you can state the evidence.  Rename with search-and-replace over the whole tree; the build and `make sym-check` prove nothing else changed.

Status, numbers and open questions: [REVERSE_ENGINEERING.md](REVERSE_ENGINEERING.md); metrics of the classification as it was at the freeze (generated from `config/`, not updated by edits to the source): [docs/PROGRESS.md](docs/PROGRESS.md).

## History: the frozen bootstrap pipeline

The first stages of the project were done by tools: an SM83 decoder and control-flow explorer (`tools/sm83.py`, `tools/cfg.py`), emulator traces
(`traces/`), tables `config/regions|symbols|ram|xrefs` classifying every byte, and a generator (`tools/gen_asm.py`, layout table `analysis/layout/layout.tsv`)
that wrote the `.asm` tree and proved it byte-identical.  That generated tree was then committed as the source, and refined by tools that are also kept (comments under labels,
local labels, readable Shift-JIS strings, extracted graphics assets: `tools/tidy_comments.py`, `localize_labels.py`, `text_to_strings.py`, `gfx_export.py`; STYLE.md).  **The generator is not
needed to build and must not be run over the source** (`make regen` refuses).  `config/`, `analysis/`, `docs/FORMATS.md` and the generator are kept unchanged as history and evidence
(see [`config/README.md`](config/README.md)); the generator still runs into a temp dir (`make legacy-check`).  Documents under `docs/research/` that were written while the source was one
`src/bankNN.asm` per bank carry a note at the top explaining how their names map to the current tree.

## Reference ROM

`docs/ROM_INFO.md` identifies the original: 2 MiB, MBC5+RAM+BATTERY, CGB only, 128 banks (85 hold data, 43 are entirely `$00`), Japan, header and global checksums valid.
It is a commercial ROM and is **not** in the repository; see [INSTALL.md](INSTALL.md) for how it is used.

## Editing images

Graphics are built from their PNGs: edit the PNG (tile sheets `gfx/**/*.png`, font sheets `data/fonts/*.png`, or a whole screen through its `*.screen.png` and `tools/screen_png.py import`) and run `make`; it prints `EDITED GRAPHICS` with the list of changed files instead of failing the SHA-256 gate. See `docs/EDITING_IMAGES.md`. Without `rgbgfx` or Python, `make` uses the committed binaries.

## Translation

See `docs/TRANSLATION.md` (text, images, fonts, limits) and `gfx/previews/README.md` (what each screen/sprite preview shows and how it was checked against the emulator).
