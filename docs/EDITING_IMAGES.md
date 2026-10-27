# Editing the game's images (PNG -> ROM)

PNG is the **editable source** of the graphics.  `make` generates the binaries that assembly `INCBIN`s from versioned PNG sources, so edited PNGs end up in the ROM. Nothing else has to be run by hand. A fresh checkout builds the byte-identical ROM (`SHA-256 OK`). Generated `.2bpp` files are not versioned. The full reference (formats, constraints, why some resources stay binary) is the "Editing images" section of `gfx/README.md`.

Build requirements: RGBDS (`rgbgfx` is part of it; tested with 1.0.3) and Python 3.

## 1. Workflow

```
edit a PNG   ->   make            ->   open mobile_trainer.gbc
                  make png-check       (explains every problem in plain words)
```

* `make` converts every PNG whose binary is missing or older (tile sheets with `rgbgfx`, font sheets with `tools/font_png.py`), checks the size of the
  result, assembles and links.  With edited graphics the ROM differs from the original on purpose: `make` then prints `EDITED GRAPHICS` and the list of
  changed files instead of failing the SHA-256 gate, and `tools/compare_rom.py` shows where the ROM differs.  Any other difference is still a
  `SHA-256 MISMATCH`.
* `make png-bins` rebuilds only the graphics binaries (no ROM); `make png-check` checks every PNG (size, colours, palette order, glyph cells, screens).
* `make png-export` (maintainers) regenerates the PNGs from the binaries; it never overwrites a PNG that holds edits not built yet (`FORCE=1` does).
* **Do not resize or crop any image, and do not add or delete tiles or glyphs.**  The ROM layout is pinned (`layout.link`); every binary must keep
  its exact size.  You can redraw everything inside the existing tiles / glyph cells.
* Save as an **indexed (palette) PNG** and keep the palette: use the pencil tool (no anti-aliasing, no dithering).

## 2. What is an editable PNG

| what | file | how | count |
|---|---|---|---:|
| tile blocks (2bpp art: screens, text baked into tiles, buttons, logos) | `gfx/**/name.png` next to `name.2bpp` | exact `rgbgfx` source: 4 greys in a fixed order (index 0 white ... 3 black); 16 tiles per row (8-15 when 16 does not divide the count; the last row padded, padding tiles are ignored) | 424 catalogued tile binaries |
| explicit RAW byte views | `gfx/frame_designs/metal_flame_and_creature_borders_42/raw_*.png` | reversible raw2bpp byte codec; purpose UNKNOWN/HYPOTHESIS, not a tile classification | 4 files /80B |
| JIS 12x12 font banks, 8x16 font runs, 6x12 Latin font | `data/fonts/name.png` or `data/fonts/glyph_runs_8x16/sjis_key.png` next to its binary | glyph sheet, see section 4; `tools/font_png.py` | 37 sheets (39 binaries) |
| whole screens (tilemap + attributes + tiles + palettes composed, in real colours) | `gfx/**/name.screen.png` next to `name.tilemap` | see section 3; an *editing view*: import writes the edit back into the tile sheets | 95 screens |
| palettes | `gfx/**/name.pal` | text, one `RGB r, g, b` line per colour (0-31 per channel), four colours per palette; hand-editable; screen PNGs can write colours back (`--palette`) | 165 catalogued palette resources |

Stay binary: `.tilemap` / `.attrmap` (which tile sits in which cell, flips, palette numbers; 181 + 180 files; the layout of a screen is fixed, see
section 3 for what you can change), the Shift-JIS validity bitmap (`data/fonts/sjis_valid_bitmap.bin`, data rather than an image; a view-only picture
`sjis_valid_bitmap_view.png` exists), and every graphics block that is still `db` in the `.asm` (sprite frame tables, animation scripts, unclassified data).

## 3. Screens

`gfx/screens.tsv` lists the 95 current screens whose composition could be derived (the tile blocks, palettes and VRAM addressing come from the loader routine
of the screen or an explicit layout hypothesis, `evidence` column; 20 PROBABLE screens have every cell resolved,
and 75 HYPOTHESIS screens are partly resolved, ambiguous in addressing, or layout-only).  The other 86 tilemaps
have no screen PNG because the code that draws them is table-driven or loads their tiles elsewhere (reasons in `gfx/README.md`); edit their tile
sheets directly.

```
python3 tools/screen_png.py export [NAME]            # (re)write screen PNGs from the current tile sheets and palettes (only needed when stale)
   ... edit gfx/.../name.screen.png ...
python3 tools/screen_png.py import [--dry-run] [--palette] [NAME]   # write the edits into the tile sheet PNGs (and with --palette the .pal files)
make
```

* Pixel value = `4 * palette + shade` (palette 0-7 = the cell's attribute, shade 0-3).  Keep every cell in the colours of its own palette.  Pink
  (index 32) = a cell whose tile this screen's routine does not load (for example text drawn at run time); it is ignored.
* Import keeps the tilemap and the attribute map: an edit of a cell is written into the tile that cell shows (flips undone).  A tile that several cells
  show must look the same in all of them: editing one of them alone is refused ("tile N is shared ...") because the tilemap cannot give it another
  tile.  Edit a cell that uses its tile once, or all sharing cells identically.  Other screens that show the same tile change too (import tells you).
* Unedited screen PNG -> import is required to preserve bytes; `make png-check` checks this contract for the current catalogue.

The bank41–46 record views are conditional compositions. Eight of their tilemaps currently lack an editing view (KEEP); all eight have existing legacy previews and original bytes. The earlier eleven omissions were reduced by42:4D50,42:4000 and42:67F0. Two selected bank47 maps,47:4B00 and47:65A0, also lack editing rows but have descriptor previews;47:5850 has a partial357/360 view. Their original bytes are present; this is a limitation of editing-view derivation, not proof of missing ROM art. See [catalogue/layout audit](research/assets_original_catalogue_and_layout_audit.md) and [frame/name limits](research/assets_pokemon_frames_and_name_limits.md).

## 4. Font sheets

Indexed PNG with four colours: white = paper, black = ink, grey = grid line, pink = "this pixel is outside the supplied spans" (ignored on span import).  Draw only pure
black and pure white inside glyph cells.  Cell = glyph + 1 pixel grid.

| font | cell | per sheet row | notes |
|---|---|---|---|
| `jis12x12_rows_*` (banks 76-7E) | 12x12 | 94 | sheet row = glyph slot row of the bank, column = JIS column 1-94; 7E: JIS rows 1-8, 13; 7D: 16-24; 7C: 25-33; 7B: 34-42; 7A: 43-51; 79: 52-60; 78: 61-69; 77: 70-78; 76: 79-84.  Bank 7C is three contiguous files (6083 +10 +9135 bytes) sharing one complete sheet; all846 glyph cells have their original bits |
| `glyph_runs_8x16/sjis_*` (bank 48, 27 runs) | 8x16 | 16 | one PNG per run; filename key is SJIS, not the physical codec start address |
| `ascii_6x12` (76:67A8) | 6x12 | 16 | 96 glyphs, ASCII 20-7F |

## 5. Maintainers

`gfx/png_rules.tsv` (generated: `python3 tools/png_rules.py rules`) is the manifest of every PNG -> binary rule with per-asset parameters (`rgbgfx -x`
padding, font type, glyph counts) and the hash of each binary in the original ROM state; `gfx/png.mk` is generated from it and included by the
`Makefile`. `rgbgfx` and Python 3 are required to build; generated `.2bpp` files are ignored by Git and created from the PNG sources. Tests: `python3 tools/test_png.py`.

## 6. Resources with special formats

### Conditional frame compositions

Some frame previews combine several tile sources under an assumed addressing,
VRAM-bank and palette context. Their PROBABLE/HYPOTHESIS status applies to that
composition. A fully resolved preview does not establish an original loader or
a Pokémon-name association. Eight compositions retain incomplete placement or
consumer contracts; keep their original backing bytes.

The Bank42 jagged/flame view combines sources at `42:4D50`, `4F00`, `52C0` and
`52E0` under an unsigned/VRAM1 model. Use its declared entry in `gfx/screens.tsv`
when exporting or importing, and retain the physical source extents.

### Object records and byte views

A legacy byte-view PNG can show bytes that are actually object/frame/script
records. The AdapterCheck span at `4A:68D0` and the settings cursor span at
`4A:5860` are represented by Assembly/macros. Edit those structures in their
`.asm` owners rather than treating their legacy byte views as active tile art.
Zero bytes following a record do not by themselves prove padding or unused data.

### HelpScript pictures

The table-backed HelpScript pictures use 12×6 tiles (96×48 pixels), 1,152-byte
backings and four-colour palettes. Their IDs and source ranges are defined by
the picture table. Preserve dimensions and glyph/tile order. See
[HelpScript picture resources](research/help_script_picture_assets.md).
