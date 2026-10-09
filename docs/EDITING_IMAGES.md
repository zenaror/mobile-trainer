# Editing the game's images (PNG -> ROM)

PNG is the **editable source** of the graphics.  `make` rebuilds the binaries that the assembly `INCBIN`s from their PNGs, so an edited PNG ends up in
the ROM.  Nothing else has to be run by hand.  Unedited PNGs give back the committed bytes: a fresh checkout still builds the byte-identical ROM
(`SHA-256 OK`).  The full reference (formats, constraints, why some things stay binary) is the "Editing images" section of `gfx/README.md`.

Needs only what building needs: RGBDS (`rgbgfx` is part of it; tested with 1.0.3) and, for fonts and the checks, `python3`.

## 1. Workflow

```
edit a PNG   ->   make            ->   open mobile_trainer.gbc
                  make png-check       (explains every problem in plain words)
```

* `make` converts every PNG that is newer than its binary (tile sheets with `rgbgfx`, font sheets with `tools/font_png.py`), checks the size of the
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
| tile blocks (2bpp art: screens, text baked into tiles, buttons, logos) | `gfx/**/name.png` next to `name.2bpp` | exact `rgbgfx` source: 4 greys in a fixed order (index 0 white ... 3 black); 16 tiles per row (8-15 when 16 does not divide the count; the last row padded, padding tiles are ignored) | 405 |
| JIS 12x12 font banks, 8x16 font runs, 6x12 Latin font | `data/fonts/name.png` next to `name.bin` / `name.1bpp` | glyph sheet, see section 4; `tools/font_png.py` | 37 sheets (38 binaries) |
| whole screens (tilemap + attributes + tiles + palettes composed, in real colours) | `gfx/**/name.screen.png` next to `name.tilemap` | see section 3; an *editing view*: import writes the edit back into the tile sheets | 92 screens |
| palettes | `gfx/**/name.pal` | text, one `RGB r, g, b` line per colour (0-31 per channel), four colours per palette; hand-editable; screen PNGs can write colours back (`--palette`) | 143 files |

Stay binary: `.tilemap` / `.attrmap` (which tile sits in which cell, flips, palette numbers; 180 + 180 files; the layout of a screen is fixed, see
section 3 for what you can change), the Shift-JIS validity bitmap (`data/fonts/sjis_valid_bitmap.bin`, data rather than an image; a view-only picture
`sjis_valid_bitmap_view.png` exists), and every graphics block that is still `db` in the `.asm` (sprite frame tables, animation scripts, unclassified data).

## 3. Screens

`gfx/screens.tsv` lists the 92 screens whose composition could be derived (the tile blocks, palettes and VRAM addressing come from the loader routine
of the screen or an explicit layout hypothesis, `evidence` column; 20 PROBABLE screens have every cell resolved,
and 72 HYPOTHESIS screens are partly resolved, ambiguous in addressing, or layout-only).  The other 88 tilemaps
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
* Unedited screen PNG -> import = no change, for all 92 screens (`make png-check` proves it on every run).

The bank41–46 record views are conditional compositions. Eleven of their tilemaps lack an editing view: eight resolve less than half of the cells under the assumed160-tile layout, and three bank42 records have fragmented tile sources that the current derivation does not combine. Two other bank47 maps also lack editing views. Their original bytes are present; this is a limitation of editing-view derivation, not proof of missing ROM art. See [catalogue/layout audit](research/assets_original_catalogue_and_layout_audit.md) and [frame/name limits](research/assets_pokemon_frames_and_name_limits.md).

## 4. Font sheets

Indexed PNG with four colours: white = paper, black = ink, grey = grid line, pink = "this pixel is not stored in the ROM" (ignored).  Draw only pure
black and pure white inside glyph cells.  Cell = glyph + 1 pixel grid.

| font | cell | per sheet row | notes |
|---|---|---|---|
| `jis12x12_rows_*` (banks 76-7E) | 12x12 | 94 | sheet row = glyph slot row of the bank, column = JIS column 1-94; 7E: JIS rows 1-8, 13; 7D: 16-24; 7C: 25-33; 7B: 34-42; 7A: 43-51; 79: 52-60; 78: 61-69; 77: 70-78; 76: 79-84.  Bank 7C is two files sharing one sheet; the two glyphs cut by the gap show pink pixels |
| `font_8x16_*` (bank 48, 27 runs) | 8x16 | 16 | one PNG per run |
| `ascii_6x12` (76:67A8) | 6x12 | 16 | 96 glyphs, ASCII 20-7F |

## 5. Maintainers

`gfx/png_rules.tsv` (generated: `python3 tools/png_rules.py rules`) is the manifest of every PNG -> binary rule with per-asset parameters (`rgbgfx -x`
padding, font type, glyph counts) and the hash of each binary in the original ROM state; `gfx/png.mk` is generated from it and included by the
`Makefile`.  Without `rgbgfx` or `python3` the rules are skipped and the committed binaries are used.  Tests: `python3 tools/test_png.py`.
