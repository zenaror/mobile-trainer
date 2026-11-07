# Development reference

Build outputs, validation commands and source layout.
For installation, see [INSTALL.md](../INSTALL.md); for the reverse-engineering
status, see [REVERSE_ENGINEERING.md](../REVERSE_ENGINEERING.md).

The `.asm` tree is **hand-maintained source**: it was produced once by a bootstrap generator from the analysis tables in `config/`
(that *pipeline* is frozen, see "History" below), and from now on the `.asm` files are edited directly.  Assembly sources are not regenerated at build time and the
original ROM is **not** needed to build; it is only used, if you have it, to compare.  Graphics are files (`.2bpp`, `.tilemap`, `.pal`, ... with PNGs next to them)
that the `.asm` files `INCBIN`; Shift-JIS text is written as readable strings (`db "メール", 0`) through a charmap; jump targets inside a function are local labels (`.loop`, `.l04E1`);
every function has a `[CONFIRMED]`/`[PROBABLE]`/`[HYPOTHESIS]` note under its label.  The conventions are in [STYLE.md](../STYLE.md).

## Building

Requirements: [RGBDS](https://rgbds.gbdev.io/) **1.0.3** (`rgbasm`, `rgblink`, `rgbgfx`), GNU make and Python 3. Graphics binaries are generated from PNG sources during the build; `.2bpp` files are not versioned. Details: [INSTALL.md](../INSTALL.md).

```
make                 # assemble every file, link, check the SHA-256 (+ byte-compare if the original ROM is present)
make -j8             # the same, in parallel
```

The result is `mobile_trainer.gbc` (repository root), with `build/mobile_trainer.map` and `build/mobile_trainer.sym` (global labels, local labels and exported constants).  A successful build prints

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
| `make png-check` | verify every editable PNG and report problems |
| `make palette-check` | check that every loaded palette is represented by one palette block |
| `make png-bins` | rebuild graphics binaries from their PNGs |
| `make png-export` | regenerate PNGs from binaries (maintainers) |
| `make test` | tests of the analysis tools (SM83 decoder, config loader, legacy generator self test; needs the original ROM as `baserom.gbc`) |
| `make clean` / `make tidy` | delete `mobile_trainer.gbc` and `build/` (the original ROM is never touched) |
| `make regen` (and `verify`, `tree*`) | refuse to run: the generator must not be run over the maintained source, see "History" |
| `make legacy-check` | run the frozen bootstrap generator in a temp dir and confirm it still reproduces the ROM (needs the original ROM; touches nothing in the source) |

## How to verify

* **Hash only** (no original ROM needed): `make` prints `SHA-256 OK`; the expected hash is the first field of `roms.sha256`.
* **Byte compare** (with the original): put the ROM next to the Makefile as `Mobile Trainer (Japan).gbc` (or `baserom.gbc`), run `make`.
  It ends with `RESULT: IDENTICAL`.  The ROM is git-ignored and is never modified by any target.
* **Symbols**: `make sym-check` (labels vs the linker's `.sym`).
* **Layout coverage** (analysis of the pin table, needs the original ROM): `python3 tools/check_layout.py`.
* **Form of the source** (Python, no ROM needed): `python3 tools/tidy_comments.py --check`, `python3 tools/localize_labels.py --check`, `python3 tools/gen_sjis_charmap.py --check`
  (the charmap is generated from the ROM's text regions or from `mobile_trainer.gbc`), `python3 tools/gfx_export.py check` (PNGs vs generated `.2bpp`, needs `rgbgfx`).
* **ROM pointer operands** (needs a built tree and rgbasm): `python3 tools/apply_rom_operands.py --check` lists the `ld hl|de|bc, $XXXX` ROM pointers that a consumer rule proves and that are still numeric; `python3 tools/test_rom_operands.py` tests the tool.
* **Palette loads** (needs a built tree): `python3 tools/palette_reads_check.py` (`make palette-check`) fails when a palette that the code loads is cut into fragments, typed as tiles or typed as unknown; `python3 tools/test_palette_reads.py` tests the tool.
* **Joypad masks** (no build needed): `python3 tools/apply_pad_masks.py --check` lists a test of hJoyHeld, hJoyPressed or hJoyPressedRepeat that is still a bare number; `python3 tools/test_pad_masks.py` tests the tool.
* **Sound calls** (no build needed): `python3 tools/apply_play_sfx.py --check` lists a user-interface sound call that is still spelled out instead of `play_sfx ID`; `python3 tools/test_play_sfx.py` tests the tool.
* **Invariants of the naming passes** (needs a built tree): `python3 tools/invariants_check.py` re-derives the two statements that rows of `analysis/naming2/` rest on: the mail library (bank 0F) runs only under WRAM bank 5 and the sound driver (bank 04) only under bank 1.

## Directory layout

| path | content |
|---|---|
| `home/` | all of ROM0 (bank 00): vectors, boot, VBlank, copy/fill, far-call and bank switching, sprite engine, text interpreter, string helpers |
| `engine/<subsystem>/` | application code by subsystem (`account/`, `address_book/`, `browser/`, `comm/`, `html/`, `keyboard/`, `mail/`, `mobile/`, `settings/`, `startup/`, ...); data used only by a routine stays in its file |
| `lib/mobile/` | `main.asm` (bank 75, Mobile Adapter GB SDK), `mail.asm` (bank 0F, mail library) |
| `data/` | Shift-JIS text as readable strings (`text/`), the built-in HTML store (`html/`), fonts (`fonts/`, assets `.bin`/`.1bpp`), keyboard tables, default adapter images |
| `gfx/` | tiles, tilemaps, palettes and object tables organized under screen, art and resource owners; `gfx/<area>/<file>.asm` holds labels, headers and `INCBIN` lines, with bytes under the matching resource directory (`.2bpp` + `.png`, `.tilemap`, `.attrmap`, `.pal`). Bank/address suffixes remain provenance; unresolved labels retain neutral names. Index: [`gfx/README.md`](../gfx/README.md), `gfx/assets.tsv` |
| `audio/` | sound driver (`engine.asm`), note/instrument tables, song headers and one file per song (`music/`), sound effects |
| `ram.asm`, `ram/` | RAM names: `sram.asm`, `wram.asm`, `hram.asm`, `banked.asm` (equates only) |
| `consts.asm` | numeric constants (record offsets, counts) |
| `zero_labels.asm` | labels that point into all-zero padding (tiny pinned sections) |
| `includes.asm` | pre-included into every file: hardware names, RAM names, macros |
| `layout.link` | rgblink script: pins every section to its original bank and address |
| `constants/` | `hardware.inc` (register names), `macros.inc` (`farcall`), `sjis_charmap.asm` (the two Shift-JIS charmaps `sjis` and `sjis_hw` used by the readable strings in `data/` and in code files, generated by `tools/gen_sjis_charmap.py`), `gfx_macros.inc` (`RGB` palette macro), `charmap.asm` (analysis output of `tools/survey.py`, not used by the build) |
| `tools/` | analysis scripts, ROM comparison, `sym_check.py`, source-form tools (`tidy_comments.py`, `localize_labels.py`, `text_to_strings.py`, `gen_sjis_charmap.py`, `gfx_export.py`) and the frozen generator |
| `config/`, `analysis/` | frozen bootstrap tables and analysis tools from the initial source-generation process |
| `docs/` | public build instructions and technical ROM references, indexed in [`docs/README.md`](../docs/README.md) |

Every source file starts with its path, its bank and address range, and a one-line purpose:

```
; home/copy.asm
; bank 00, $04D8-$0540 (104 bytes); pinned by layout.link
; FillBytes/FillWords/CopyBytes/CopyBytesBackward

SECTION "home/copy", ROM0
```

**Sections float and layout.link pins them.**  To keep the ROM identical, every section has an `org` line in `layout.link`.  A new section
that is not listed there floats (rgblink places it in free space) and changes nothing else; a file that is removed or renamed needs its line in
`layout.link` removed or renamed.  See [STYLE.md](../STYLE.md) "Adding, moving and removing code".

## Source conventions

Evidence levels are `CONFIRMED` (demonstrated by disassembly, a trace or byte identity), `PROBABLE` (strong evidence, not conclusive) and
`HYPOTHESIS` (unverified).  A name without evidence stays neutral: `Function_BB_AAAA`, `Label_BB_AAAA`, `Data_BB_AAAA`, `Table_BB_AAAA`, `String_BB_AAAA`, `Tiles_BB_AAAA`, ..., `wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`
(bank and address of the original ROM).  Names supported by evidence describe their subsystem and operation. Historical aliases may have been retired; use the current source and symbol map.

Use `CONFIRMED`, `PROBABLE` or `HYPOTHESIS` comments to distinguish the strength
of an interpretation. Keep names neutral when evidence does not establish a
function or data structure. See [STYLE.md](../STYLE.md) for assembly conventions.

The frozen `config/` tables and generator describe the bootstrap process; they
do not replace the maintained assembly source or report its current semantic
coverage. The current project status is summarized in
[REVERSE_ENGINEERING.md](../REVERSE_ENGINEERING.md).

## Frozen bootstrap tooling

`tools/gen_asm.py` and the tables in `config/` describe the one-time bootstrap
pipeline. Normal builds use the maintained assembly source directly; `make
regen` refuses to regenerate it. `make legacy-check` runs the frozen generator
in a temporary directory.

## Reference ROM

`docs/ROM_INFO.md` identifies the original: 2 MiB, MBC5+RAM+BATTERY, CGB only, 128 banks, Japan, header and global checksums valid.
It is a commercial ROM and is **not** in the repository; see [INSTALL.md](../INSTALL.md) for how it is used.

## Editing images

Graphics are built from their PNGs: edit the PNG (tile sheets `gfx/**/*.png`, font sheets `data/fonts/*.png`, or a whole screen through its `*.screen.png` and `tools/screen_png.py import`) and run `make`; it prints `EDITED GRAPHICS` with the list of changed files instead of failing the SHA-256 gate. Generated `.2bpp` files are not versioned. See `docs/EDITING_IMAGES.md`.

## Translation

See `docs/TRANSLATION.md` (text, images, fonts, limits) and `gfx/previews/README.md` (what each screen/sprite preview shows and how it was checked against the emulator).

`make english` builds the existing English overlay separately under `build/en`,
using explicit file overrides in `languages/en/` and pinned Japanese files
where no override is selected. The default `make` reconstructs the Japanese
ROM. Overrides can include text, source, sprites, tiles, box layouts, tilemaps,
attributes, palettes and editable PNGs. Run `make english-check` for the locale
checks. See [LANGUAGE_BUILDS.md](LANGUAGE_BUILDS.md) and [TRANSLATION.md](TRANSLATION.md)
for the build interface and editing constraints. A successful build does not
establish complete translation or runtime compatibility.

## Optional analysis dependencies

Optional analysis tools use explicit settings or project-local defaults:

| Setting | Purpose | Default |
|---|---|---|
| `MGBA_SRC` | Matching mGBA fork sources and headers | `.cache/mgba-src` under the repository |
| `MGBA_BUILD` | Existing mGBA build for analysis/probes | `.cache/trace/mgba` |
| `GHIDRA_INSTALL_DIR` | Ghidra installation | Required for Ghidra tools |
| `CRYSTAL_REFERENCE_ROOT` / `--gb-root` | External reference builds for `tools/crystal_match.py` | `.cache/crystal-references` |

The Crystal reference directory has `eng/pokecrystal.gbc`, `eng/pokecrystal.sym`,
`eng/source/`, `ptbr/pokecrystal.gbc`, `ptbr/pokecrystal.sym` and the `ptbr/`
source tree. The optional Japanese reference is `jp/baserom-jp.gb`, overridable
with `--jp`. External ROMs and dependency checkouts are not bundled.

### ROM reference notes

`REVERSE_ENGINEERING.md` summarizes source coverage and interpretation limits.
The reference notes describe ROM behavior and public source definitions.
Build, tooling and table-format instructions are kept in the development guides.
