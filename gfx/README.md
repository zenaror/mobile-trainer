# Graphics assets

Every graphics block of the ROM that the analysis identified is a file here, next to the PNG you can open; the `.asm` files under `gfx/`
(and `data/fonts/`, and the two graphics blocks inside `engine/` code files) `INCBIN` the binary instead of spelling it out as `db` rows.  The ROM is unchanged (`make` still prints the same SHA-256).

```
gfx/title/title_screen.asm                     the labels, the region headers (status + evidence), the INCBIN lines
gfx/title/title_screen/title_tiles0.2bpp       the bytes the ROM contains (2bpp tiles)
gfx/title/title_screen/title_tiles0.png        the same tiles as a picture, 16 per row  (exact rgbgfx source of the .2bpp)
gfx/title/title_screen/title_screen.tilemap    20x18 tile indices          (INCBIN)
gfx/title/title_screen/title_screen.attrmap    20x18 CGB attribute bytes   (INCBIN)
gfx/title/title_screen/title_bg.pal            `RGB r, g, b` lines         (INCLUDE; macro in constants/gfx_macros.inc)
data/fonts/jis12x12_rows_01_08_13.bin          font bytes;  ..._view.png = glyph sheet for reading only
gfx/assets.tsv                                 one line per asset: kind, size, bank:addr, status, PNG mode  (machine readable)
```

* **Directory**: `gfx/<area>/<file>/` holds the assets of `gfx/<area>/<file>.asm` (`gfx/bank41.asm` -> `gfx/bank41/`); fonts are directly in `data/fonts/`.
* **Names**: a block with a semantic label is named after it in `snake_case` (`Gfx_Title_Tiles0` -> `title_tiles0`, `Palette_Title_Bg` -> `title_bg.pal`);
  a block with only a generic label is `<kind>_<addr>` with the address in the bank (`tiles_4000.2bpp`, `tilemap_5bc0.tilemap`).
  Names say what the label / header note says and no more: `tiles_...` means "the analysis typed this block as 2bpp tile data", see status below.
* **Kinds**: `.2bpp` 2bpp tiles; `.tilemap` / `.attrmap` tile-index / CGB attribute bytes (a `tilemap+attr` pair that `copy_tilemap_rect_pair` loads is
  stored as two files, tile bytes then attribute bytes, INCBINed back to back); `.pal` `RGB` macro lines (four colours per block); `.1bpp` 8x16 glyph
  runs (`data/fonts/font_8x16_*.1bpp`, 16 bytes per glyph); `.bin` JIS 12x12 glyph bits, the 6x12 Latin font and the Shift-JIS validity bitmap.
* **Exact PNG** (`name.png`): 4-shade indexed PNG (index 0 white ... 3 black; these are tile *indices*, not the game's colours), 16 tiles per row
  (fewer when the block is smaller; a divisor of the tile count between 8 and 15 when 16 does not divide it, else the last row is padded and
  `pad` in `assets.tsv` blank tiles are trimmed).  `rgbgfx -c embedded [-x pad] -o name.2bpp name.png` gives back the `.2bpp` byte for byte
  (`python3 tools/gfx_export.py check` runs that for every PNG).  Edit the PNG, run `python3 tools/gfx_export.py bin`, then `make`.
* **View-only PNG** (`name_view.png`): fonts and the bitmap; their bytes are not tile data (JIS glyphs are 12-bit rows packed 3 bytes per 2 rows), so the
  PNG is a picture (JIS: one JIS row per line, 94 glyphs; 8x16 / 6x12: glyph grid; bitmap: 256x256, row = high byte, column = low byte).
  The `.bin` / `.1bpp` is the source; `check` decodes each sheet back to the bytes to prove the picture is faithful.
* **Status** is the status word of the region header in the `.asm` (`CONFIRMED` / `PROBABLE` / `HYPOTHESIS`, see STYLE.md).  A `tiles-2bpp: heuristic` block is a
  *guess* by pixel coherence: it may contain tilemap or other bytes; the file is still exactly the ROM bytes of that region.
* **Regenerate everything** from the sources: `python3 tools/gfx_export.py png` (binary -> PNG), `bin` (exact PNG -> binary through rgbgfx), `check`, `readme`.
  The ROM build needs none of it: rgbgfx is only for editing PNGs.  `INCBIN` / `INCLUDE` paths are relative to the repository root (`rgbasm -I .`).

## Totals

| kind | files | bytes |
|---|---:|---:|
| attribute map (`.attrmap`) | 169 | 47978 |
| JIS 12x12 glyph bits (`.bin`) | 10 | 131966 |
| 6x12 glyph rows (`.bin`) | 1 | 1152 |
| 1bpp 8x16 glyphs (`.1bpp`) | 27 | 4848 |
| RGB palette (`.pal`) | 133 | 10466 |
| validity bitmap (`.bin`) | 1 | 8198 |
| tile-index map (`.tilemap`) | 169 | 47978 |
| 2bpp tiles (`.2bpp`) | 409 | 350336 |
| **all** | **919** | **602922** |

PNGs: 409 exact round-trip sources (`.png`), 39 view-only sheets (`_view.png`).

## Still `db`

Blocks of the graphics regions that are not converted (the note / label does not say they are palettes, maps or tile data, or they are too small to be tiles):

| what | blocks | bytes |
|---|---:|---:|
| bytes read as data by executed code, content class unknown | 68 | 27605 |
| sprite / OAM frame records, animation scripts, object tables (not tile art) | 437 | 15025 |
| tilemap+attr blocks clipped by the analysis (size differs from 2 x rows x cols) and 4-byte tile/attr record lists | 12 | 3728 |
| HYPOTHESIS data (mostly runs of $FF / $00 padding candidates) | 64 | 1739 |
| object / animation tables (by label name) | 8 | 530 |
| label says tilemap but no size evidence | 1 | 256 |
| tail (less than 16 bytes) after a converted tile block | 19 | 198 |
| gfx fragments of fewer than 4 whole tiles | 10 | 173 |
| label says tiles, note says palette | 1 | 26 |
| data without graphics evidence in the note | 1 | 2 |

## Assets by directory

Columns: `bank:addr` is the original ROM position of the first byte; `status` is the evidence status of the region header in the `.asm`; `png` is `exact` (rgbgfx source), `view` (reading only) or `-`.  `dims` = width x height in tiles where a note states it.

### `data/fonts/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `ascii_6x12.bin` | 6x12 glyph rows | 1152 | 76:67A8 | PROBABLE | view | - | `data/fonts/ascii_6x12.asm` |
| `font_8x16_4adb.1bpp` | 1bpp 8x16 glyphs | 160 | 48:4ADB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_4b7b.1bpp` | 1bpp 8x16 glyphs | 416 | 48:4B7B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_4d1b.1bpp` | 1bpp 8x16 glyphs | 416 | 48:4D1B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_4ebb.1bpp` | 1bpp 8x16 glyphs | 1328 | 48:4EBB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_53eb.1bpp` | 1bpp 8x16 glyphs | 1360 | 48:53EB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_593b.1bpp` | 1bpp 8x16 glyphs | 192 | 48:593B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_59fb.1bpp` | 1bpp 8x16 glyphs | 48 | 48:59FB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a2b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5A2B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a3b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5A3B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a4b.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5A4B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a6b.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5A6B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a8b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5A8B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5a9b.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5A9B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5abb.1bpp` | 1bpp 8x16 glyphs | 64 | 48:5ABB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5afb.1bpp` | 1bpp 8x16 glyphs | 128 | 48:5AFB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5b7b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5B7B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5b8b.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5B8B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5bab.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5BAB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5bcb.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5BCB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5beb.1bpp` | 1bpp 8x16 glyphs | 32 | 48:5BEB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5c0b.1bpp` | 1bpp 8x16 glyphs | 80 | 48:5C0B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5c5b.1bpp` | 1bpp 8x16 glyphs | 64 | 48:5C5B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5c9b.1bpp` | 1bpp 8x16 glyphs | 96 | 48:5C9B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5cfb.1bpp` | 1bpp 8x16 glyphs | 96 | 48:5CFB | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5d5b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5D5B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5d6b.1bpp` | 1bpp 8x16 glyphs | 16 | 48:5D6B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `font_8x16_5d7b.1bpp` | 1bpp 8x16 glyphs | 80 | 48:5D7B | PROBABLE | view | - | `data/fonts/font_8x16.asm` |
| `jis12x12_rows_01_08_13.bin` | JIS 12x12 glyph bits | 15228 | 7E:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_01_08_13.asm` |
| `jis12x12_rows_16_24.bin` | JIS 12x12 glyph bits | 15228 | 7D:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_16_24.asm` |
| `jis12x12_rows_25_33_4000.bin` | JIS 12x12 glyph bits | 6083 | 7C:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_25_33.asm` |
| `jis12x12_rows_25_33_57cd.bin` | JIS 12x12 glyph bits | 9135 | 7C:57CD | PROBABLE | view | - | `data/fonts/jis12x12_rows_25_33.asm` |
| `jis12x12_rows_34_42.bin` | JIS 12x12 glyph bits | 15228 | 7B:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_34_42.asm` |
| `jis12x12_rows_43_51.bin` | JIS 12x12 glyph bits | 15228 | 7A:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_43_51.asm` |
| `jis12x12_rows_52_60.bin` | JIS 12x12 glyph bits | 15228 | 79:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_52_60.asm` |
| `jis12x12_rows_61_69.bin` | JIS 12x12 glyph bits | 15228 | 78:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_61_69.asm` |
| `jis12x12_rows_70_78.bin` | JIS 12x12 glyph bits | 15228 | 77:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_70_78.asm` |
| `jis12x12_rows_79_84.bin` | JIS 12x12 glyph bits | 10152 | 76:4000 | PROBABLE | view | - | `data/fonts/jis12x12_rows_79_84.asm` |
| `sjis_valid_bitmap.bin` | validity bitmap | 8198 | 63:407A | PROBABLE | view | - | `data/fonts/sjis_valid_bitmap.asm` |

### `gfx/account/screens_bank4a/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4040.2bpp` | 2bpp tiles | 512 | 4A:4040 | CONFIRMED | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_4240.2bpp` | 2bpp tiles | 1024 | 4A:4240 | CONFIRMED | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_4640.2bpp` | 2bpp tiles | 1024 | 4A:4640 | CONFIRMED | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_4a40.2bpp` | 2bpp tiles | 1024 | 4A:4A40 | CONFIRMED | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_4e40.2bpp` | 2bpp tiles | 1024 | 4A:4E40 | CONFIRMED | exact | - | `gfx/account/screens_bank4a.asm` |
| `tilemap_54a0.tilemap` | tile-index map | 360 | 4A:54A0 | PROBABLE | - | 20x18 | `gfx/account/screens_bank4a.asm` |
| `tilemap_54a0.attrmap` | attribute map | 360 | 4A:5608 | PROBABLE | - | 20x18 | `gfx/account/screens_bank4a.asm` |
| `tiles_5860.2bpp` | 2bpp tiles | 16 | 4A:5860 | PROBABLE | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_5870.2bpp` | 2bpp tiles | 1024 | 4A:5870 | PROBABLE | exact | - | `gfx/account/screens_bank4a.asm` |
| `tiles_5c70.2bpp` | 2bpp tiles | 64 | 4A:5C70 | PROBABLE | exact | - | `gfx/account/screens_bank4a.asm` |
| `tilemap_5cb0.tilemap` | tile-index map | 360 | 4A:5CB0 | PROBABLE | - | 20x18 | `gfx/account/screens_bank4a.asm` |
| `tilemap_5cb0.attrmap` | attribute map | 360 | 4A:5E18 | PROBABLE | - | 20x18 | `gfx/account/screens_bank4a.asm` |

### `gfx/account/screens_bank4b/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_42d0.2bpp` | 2bpp tiles | 1024 | 4B:42D0 | CONFIRMED | exact | - | `gfx/account/screens_bank4b.asm` |
| `tiles_46d0.2bpp` | 2bpp tiles | 1024 | 4B:46D0 | CONFIRMED | exact | - | `gfx/account/screens_bank4b.asm` |
| `tiles_5080.2bpp` | 2bpp tiles | 896 | 4B:5080 | PROBABLE | exact | - | `gfx/account/screens_bank4b.asm` |
| `tiles_5420.2bpp` | 2bpp tiles | 1104 | 4B:5420 | PROBABLE | exact | - | `gfx/account/screens_bank4b.asm` |
| `tiles_5878.2bpp` | 2bpp tiles | 32 | 4B:5878 | PROBABLE | exact | - | `gfx/account/screens_bank4b.asm` |
| `tilemap_5898.tilemap` | tile-index map | 360 | 4B:5898 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank4b.asm` |
| `tilemap_5898.attrmap` | attribute map | 360 | 4B:5A00 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank4b.asm` |

### `gfx/account/screens_bank5d/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4800.2bpp` | 2bpp tiles | 1024 | 5D:4800 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_4c00.2bpp` | 2bpp tiles | 1024 | 5D:4C00 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_5320.2bpp` | 2bpp tiles | 1024 | 5D:5320 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_5720.2bpp` | 2bpp tiles | 1024 | 5D:5720 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tilemap_5b20.tilemap` | tile-index map | 360 | 5D:5B20 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5d.asm` |
| `tilemap_5b20.attrmap` | attribute map | 360 | 5D:5C88 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5d.asm` |
| `tiles_5df0.2bpp` | 2bpp tiles | 1024 | 5D:5DF0 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_61f0.2bpp` | 2bpp tiles | 512 | 5D:61F0 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_63f0.2bpp` | 2bpp tiles | 512 | 5D:63F0 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_65f0.2bpp` | 2bpp tiles | 64 | 5D:65F0 | PROBABLE | exact | - | `gfx/account/screens_bank5d.asm` |
| `tilemap_6630.tilemap` | tile-index map | 360 | 5D:6630 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5d.asm` |
| `tilemap_6630.attrmap` | attribute map | 360 | 5D:6798 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5d.asm` |
| `tiles_6900.2bpp` | 2bpp tiles | 768 | 5D:6900 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_6c00.2bpp` | 2bpp tiles | 512 | 5D:6C00 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |
| `tiles_6e00.2bpp` | 2bpp tiles | 1024 | 5D:6E00 | CONFIRMED | exact | - | `gfx/account/screens_bank5d.asm` |

### `gfx/account/screens_bank5e/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4800.2bpp` | 2bpp tiles | 1024 | 5E:4800 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_4c00.2bpp` | 2bpp tiles | 256 | 5E:4C00 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tilemap_4d40.tilemap` | tile-index map | 100 | 5E:4D40 | CONFIRMED | - | 20x5 | `gfx/account/screens_bank5e.asm` |
| `tilemap_4d40.attrmap` | attribute map | 100 | 5E:4DA4 | CONFIRMED | - | 20x5 | `gfx/account/screens_bank5e.asm` |
| `tiles_4e10.2bpp` | 2bpp tiles | 1024 | 5E:4E10 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_5210.2bpp` | 2bpp tiles | 1024 | 5E:5210 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_57e0.2bpp` | 2bpp tiles | 32 | 5E:57E0 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_5800.2bpp` | 2bpp tiles | 1024 | 5E:5800 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_5c00.2bpp` | 2bpp tiles | 1024 | 5E:5C00 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tilemap_6000.tilemap` | tile-index map | 100 | 5E:6000 | CONFIRMED | - | 20x5 | `gfx/account/screens_bank5e.asm` |
| `tilemap_6000.attrmap` | attribute map | 100 | 5E:6064 | CONFIRMED | - | 20x5 | `gfx/account/screens_bank5e.asm` |
| `tiles_60d0.2bpp` | 2bpp tiles | 1024 | 5E:60D0 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_64d0.2bpp` | 2bpp tiles | 1024 | 5E:64D0 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tilemap_68d0.tilemap` | tile-index map | 360 | 5E:68D0 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5e.asm` |
| `tilemap_68d0.attrmap` | attribute map | 360 | 5E:6A38 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5e.asm` |
| `tiles_6ba0.2bpp` | 2bpp tiles | 1024 | 5E:6BA0 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tiles_6fa0.2bpp` | 2bpp tiles | 1024 | 5E:6FA0 | CONFIRMED | exact | - | `gfx/account/screens_bank5e.asm` |
| `tilemap_75d0.tilemap` | tile-index map | 360 | 5E:75D0 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5e.asm` |
| `tilemap_75d0.attrmap` | attribute map | 360 | 5E:7738 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank5e.asm` |

### `gfx/account/screens_bank71/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 768 | 71:4000 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_4300.2bpp` | 2bpp tiles | 512 | 71:4300 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_4500.2bpp` | 2bpp tiles | 912 | 71:4500 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_4890.2bpp` | 2bpp tiles | 1024 | 71:4890 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tilemap_4c98.tilemap` | tile-index map | 360 | 71:4C98 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_4c98.attrmap` | attribute map | 360 | 71:4E00 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_4f68.tilemap` | tile-index map | 40 | 71:4F68 | CONFIRMED | - | 20x2 | `gfx/account/screens_bank71.asm` |
| `tilemap_4f68.attrmap` | attribute map | 40 | 71:4F90 | CONFIRMED | - | 20x2 | `gfx/account/screens_bank71.asm` |
| `tiles_5340.2bpp` | 2bpp tiles | 1024 | 71:5340 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_5740.2bpp` | 2bpp tiles | 1024 | 71:5740 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_5b40.2bpp` | 2bpp tiles | 640 | 71:5B40 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_5dc0.2bpp` | 2bpp tiles | 1024 | 71:5DC0 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_61c0.2bpp` | 2bpp tiles | 640 | 71:61C0 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_6440.2bpp` | 2bpp tiles | 320 | 71:6440 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `tiles_6580.2bpp` | 2bpp tiles | 256 | 71:6580 | CONFIRMED | exact | - | `gfx/account/screens_bank71.asm` |
| `palette_6688.pal` | RGB palette | 24 | 71:6688 | PROBABLE | - | - | `gfx/account/screens_bank71.asm` |
| `tilemap_66c8.tilemap` | tile-index map | 360 | 71:66C8 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_66c8.attrmap` | attribute map | 360 | 71:6830 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_6998.tilemap` | tile-index map | 360 | 71:6998 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_6998.attrmap` | attribute map | 360 | 71:6B00 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_6c68.tilemap` | tile-index map | 360 | 71:6C68 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |
| `tilemap_6c68.attrmap` | attribute map | 360 | 71:6DD0 | CONFIRMED | - | 20x18 | `gfx/account/screens_bank71.asm` |

### `gfx/address_book/address_editor/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `abook_addr.tilemap` | tile-index map | 360 | 2F:7AC0 | CONFIRMED | - | 20x18 | `gfx/address_book/address_editor.asm` |
| `abook_addr.attrmap` | attribute map | 360 | 2F:7C28 | CONFIRMED | - | 20x18 | `gfx/address_book/address_editor.asm` |
| `abook_addr_bg.pal` | RGB palette | 14 | 2F:7D90 | CONFIRMED | - | - | `gfx/address_book/address_editor.asm` |
| `palette_7d9e.pal` | RGB palette | 32 | 2F:7D9E | PROBABLE | - | - | `gfx/address_book/address_editor.asm` |

### `gfx/address_book/address_picker/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `addr_pick_tiles9300.2bpp` | 2bpp tiles | 1024 | 2C:6730 | CONFIRMED | exact | - | `gfx/address_book/address_picker.asm` |
| `addr_pick_tiles9700.2bpp` | 2bpp tiles | 256 | 2C:6B30 | CONFIRMED | exact | - | `gfx/address_book/address_picker.asm` |
| `addr_book_tiles8f00.2bpp` | 2bpp tiles | 144 | 2C:6C30 | CONFIRMED | exact | - | `gfx/address_book/address_picker.asm` |
| `data_addr_pick_tilemap_attr.tilemap` | tile-index map | 360 | 2C:6CC0 | CONFIRMED | - | 20x18 | `gfx/address_book/address_picker.asm` |
| `data_addr_pick_tilemap_attr.attrmap` | attribute map | 360 | 2C:6E28 | CONFIRMED | - | 20x18 | `gfx/address_book/address_picker.asm` |
| `addr_pick_bg.pal` | RGB palette | 14 | 2C:6F90 | CONFIRMED | - | - | `gfx/address_book/address_picker.asm` |
| `palette_6f9e.pal` | RGB palette | 48 | 2C:6F9E | PROBABLE | - | - | `gfx/address_book/address_picker.asm` |
| `tiles_6fd0.2bpp` | 2bpp tiles | 512 | 2C:6FD0 | PROBABLE | exact | - | `gfx/address_book/address_picker.asm` |
| `addr_book_obj.pal` | RGB palette | 64 | 2C:71D0 | CONFIRMED | - | - | `gfx/address_book/address_picker.asm` |

### `gfx/address_book/entry_screen_bank29/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_5b10.2bpp` | 2bpp tiles | 768 | 29:5B10 | CONFIRMED | exact | - | `gfx/address_book/entry_screen_bank29.asm` |
| `palette_5e10.pal` | RGB palette | 64 | 29:5E10 | CONFIRMED | - | - | `gfx/address_book/entry_screen_bank29.asm` |
| `tiles_5e50.2bpp` | 2bpp tiles | 1024 | 29:5E50 | PROBABLE | exact | - | `gfx/address_book/entry_screen_bank29.asm` |
| `tiles_6250.2bpp` | 2bpp tiles | 64 | 29:6250 | PROBABLE | exact | - | `gfx/address_book/entry_screen_bank29.asm` |

### `gfx/address_book/entry_screen_bank2a/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `addr_book_entry_tiles8f00.2bpp` | 2bpp tiles | 224 | 2A:7CF0 | PROBABLE | exact | - | `gfx/address_book/entry_screen_bank2a.asm` |
| `addr_book_entry_tiles8000.2bpp` | 2bpp tiles | 176 | 2A:7DD0 | PROBABLE | exact | - | `gfx/address_book/entry_screen_bank2a.asm` |

### `gfx/address_book/list/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `abook_list.tilemap` | tile-index map | 360 | 2F:4D40 | CONFIRMED | - | 20x18 | `gfx/address_book/list.asm` |
| `abook_list.attrmap` | attribute map | 360 | 2F:4EA8 | CONFIRMED | - | 20x18 | `gfx/address_book/list.asm` |

### `gfx/address_book/name_editor/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_61f0.2bpp` | 2bpp tiles | 1024 | 2F:61F0 | CONFIRMED | exact | - | `gfx/address_book/name_editor.asm` |
| `tiles_65f0.2bpp` | 2bpp tiles | 256 | 2F:65F0 | CONFIRMED | exact | - | `gfx/address_book/name_editor.asm` |
| `tiles_66f0.2bpp` | 2bpp tiles | 768 | 2F:66F0 | CONFIRMED | exact | - | `gfx/address_book/name_editor.asm` |
| `abook_name.tilemap` | tile-index map | 360 | 2F:69F0 | PROBABLE | - | 20x18 | `gfx/address_book/name_editor.asm` |
| `abook_name.attrmap` | attribute map | 360 | 2F:6B58 | PROBABLE | - | 20x18 | `gfx/address_book/name_editor.asm` |
| `palette_6cc0.pal` | RGB palette | 64 | 2F:6CC0 | CONFIRMED | - | - | `gfx/address_book/name_editor.asm` |

### `gfx/address_book/save_confirm/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `addr_save_confirm_bg.pal` | RGB palette | 64 | 2A:75A0 | PROBABLE | - | - | `gfx/address_book/save_confirm.asm` |
| `addr_save_confirm_tiles9300.2bpp` | 2bpp tiles | 1024 | 2A:75E0 | PROBABLE | exact | - | `gfx/address_book/save_confirm.asm` |
| `addr_save_confirm_tiles9700.2bpp` | 2bpp tiles | 64 | 2A:79E0 | PROBABLE | exact | - | `gfx/address_book/save_confirm.asm` |
| `data_addr_save_confirm_tilemap_attr.tilemap` | tile-index map | 360 | 2A:7A20 | PROBABLE | - | 20x18 | `gfx/address_book/save_confirm.asm` |
| `data_addr_save_confirm_tilemap_attr.attrmap` | attribute map | 360 | 2A:7B88 | PROBABLE | - | 20x18 | `gfx/address_book/save_confirm.asm` |

### `gfx/address_book/save_sender_address/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `save_sender_addr_tiles9300.2bpp` | 2bpp tiles | 560 | 2A:4AA0 | CONFIRMED | exact | - | `gfx/address_book/save_sender_address.asm` |
| `data_save_sender_addr_tilemap_attr.tilemap` | tile-index map | 360 | 2A:4CD0 | PROBABLE | - | 20x18 | `gfx/address_book/save_sender_address.asm` |
| `data_save_sender_addr_tilemap_attr.attrmap` | attribute map | 360 | 2A:4E38 | PROBABLE | - | 20x18 | `gfx/address_book/save_sender_address.asm` |
| `save_sender_addr_bg.pal` | RGB palette | 64 | 2A:4FA0 | PROBABLE | - | - | `gfx/address_book/save_sender_address.asm` |
| `tiles_4fe0.2bpp` | 2bpp tiles | 512 | 2A:4FE0 | PROBABLE | exact | - | `gfx/address_book/save_sender_address.asm` |
| `palette_51e0.pal` | RGB palette | 64 | 2A:51E0 | PROBABLE | - | - | `gfx/address_book/save_sender_address.asm` |

### `gfx/address_book/shared_tiles_bank28/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4bd0.2bpp` | 2bpp tiles | 1024 | 28:4BD0 | CONFIRMED | exact | - | `gfx/address_book/shared_tiles_bank28.asm` |
| `tiles_4fd0.2bpp` | 2bpp tiles | 512 | 28:4FD0 | CONFIRMED | exact | - | `gfx/address_book/shared_tiles_bank28.asm` |
| `palette_51d0.pal` | RGB palette | 64 | 28:51D0 | PROBABLE | - | - | `gfx/address_book/shared_tiles_bank28.asm` |

### `gfx/address_book/unreferenced_confirm_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_7740.2bpp` | 2bpp tiles | 288 | 2C:7740 | PROBABLE | exact | - | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `tilemap_7860.tilemap` | tile-index map | 360 | 2C:7860 | PROBABLE | - | 20x18 | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `tilemap_7860.attrmap` | attribute map | 360 | 2C:79C8 | PROBABLE | - | 20x18 | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `palette_7b30.pal` | RGB palette | 64 | 2C:7B30 | PROBABLE | - | - | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `tiles_7b70.2bpp` | 2bpp tiles | 144 | 2C:7B70 | PROBABLE | exact | - | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `palette_7c00.pal` | RGB palette | 64 | 2C:7C00 | PROBABLE | - | - | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `data_addr_book_entry_tilemap_attr.tilemap` | tile-index map | 360 | 2C:7C80 | PROBABLE | - | 20x18 | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `data_addr_book_entry_tilemap_attr.attrmap` | attribute map | 360 | 2C:7DE8 | PROBABLE | - | 20x18 | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `addr_book_entry_bg.pal` | RGB palette | 64 | 2C:7F50 | CONFIRMED | - | - | `gfx/address_book/unreferenced_confirm_screen.asm` |
| `addr_book_entry_obj.pal` | RGB palette | 64 | 2C:7F90 | CONFIRMED | - | - | `gfx/address_book/unreferenced_confirm_screen.asm` |

### `gfx/bank41/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 2560 | 41:4000 | PROBABLE | exact | - | `gfx/bank41.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 41:4A00 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `tilemap_4a00.attrmap` | attribute map | 360 | 41:4B68 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 41:4CD0 | PROBABLE | - | - | `gfx/bank41.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 2560 | 41:4D50 | PROBABLE | exact | - | `gfx/bank41.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 41:5750 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `tilemap_5750.attrmap` | attribute map | 360 | 41:58B8 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 41:5A20 | PROBABLE | - | - | `gfx/bank41.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 2560 | 41:5AA0 | PROBABLE | exact | - | `gfx/bank41.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 41:64A0 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `tilemap_64a0.attrmap` | attribute map | 360 | 41:6608 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `palette_6770.pal` | RGB palette | 128 | 41:6770 | PROBABLE | - | - | `gfx/bank41.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 2560 | 41:67F0 | PROBABLE | exact | - | `gfx/bank41.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 41:71F0 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `tilemap_71f0.attrmap` | attribute map | 360 | 41:7358 | PROBABLE | - | 20x18 | `gfx/bank41.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 41:74C0 | PROBABLE | - | - | `gfx/bank41.asm` |

### `gfx/bank42/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1344 | 42:4000 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_4802.2bpp` | 2bpp tiles | 160 | 42:4802 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_4900.2bpp` | 2bpp tiles | 176 | 42:4900 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 42:4A00 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `tilemap_4a00.attrmap` | attribute map | 360 | 42:4B68 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 42:4CD0 | PROBABLE | - | - | `gfx/bank42.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 432 | 42:4D50 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_4f00.2bpp` | 2bpp tiles | 960 | 42:4F00 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_52c0.2bpp` | 2bpp tiles | 32 | 42:52C0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_52e0.2bpp` | 2bpp tiles | 1136 | 42:52E0 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 42:5750 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `tilemap_5750.attrmap` | attribute map | 360 | 42:58B8 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 42:5A20 | PROBABLE | - | - | `gfx/bank42.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 944 | 42:5AA0 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_5e90.2bpp` | 2bpp tiles | 208 | 42:5E90 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_5f92.2bpp` | 2bpp tiles | 416 | 42:5F92 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_62a0.2bpp` | 2bpp tiles | 160 | 42:62A0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_63a0.2bpp` | 2bpp tiles | 16 | 42:63A0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_63b0.2bpp` | 2bpp tiles | 240 | 42:63B0 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 42:64A0 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `tilemap_64a0.attrmap` | attribute map | 360 | 42:6608 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `palette_6770.pal` | RGB palette | 128 | 42:6770 | PROBABLE | - | - | `gfx/bank42.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 16 | 42:67F0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_6810.2bpp` | 2bpp tiles | 400 | 42:6810 | PROBABLE | exact | - | `gfx/bank42.asm` |
| `tiles_69b0.2bpp` | 2bpp tiles | 784 | 42:69B0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_6ff2.2bpp` | 2bpp tiles | 160 | 42:6FF2 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tiles_70f0.2bpp` | 2bpp tiles | 160 | 42:70F0 | HYPOTHESIS | exact | - | `gfx/bank42.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 42:71F0 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `tilemap_71f0.attrmap` | attribute map | 360 | 42:7358 | PROBABLE | - | 20x18 | `gfx/bank42.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 42:74C0 | PROBABLE | - | - | `gfx/bank42.asm` |

### `gfx/bank43/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 2560 | 43:4000 | PROBABLE | exact | - | `gfx/bank43.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 43:4A00 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `attrmap_4b68.attrmap` | attribute map | 360 | 43:4B68 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 43:4CD0 | PROBABLE | - | - | `gfx/bank43.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 2560 | 43:4D50 | PROBABLE | exact | - | `gfx/bank43.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 43:5750 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `attrmap_58b8.attrmap` | attribute map | 360 | 43:58B8 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 43:5A20 | PROBABLE | - | - | `gfx/bank43.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 2560 | 43:5AA0 | PROBABLE | exact | - | `gfx/bank43.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 43:64A0 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `attrmap_6608.attrmap` | attribute map | 360 | 43:6608 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `palette_6770.pal` | RGB palette | 128 | 43:6770 | PROBABLE | - | - | `gfx/bank43.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 2560 | 43:67F0 | PROBABLE | exact | - | `gfx/bank43.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 43:71F0 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `attrmap_7358.attrmap` | attribute map | 360 | 43:7358 | PROBABLE | - | 20x18 | `gfx/bank43.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 43:74C0 | PROBABLE | - | - | `gfx/bank43.asm` |

### `gfx/bank44/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 2560 | 44:4000 | PROBABLE | exact | - | `gfx/bank44.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 44:4A00 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `attrmap_4b68.attrmap` | attribute map | 360 | 44:4B68 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 44:4CD0 | PROBABLE | - | - | `gfx/bank44.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 2560 | 44:4D50 | PROBABLE | exact | - | `gfx/bank44.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 44:5750 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `attrmap_58b8.attrmap` | attribute map | 360 | 44:58B8 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 44:5A20 | PROBABLE | - | - | `gfx/bank44.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 2560 | 44:5AA0 | PROBABLE | exact | - | `gfx/bank44.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 44:64A0 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `attrmap_6608.attrmap` | attribute map | 360 | 44:6608 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `palette_6770.pal` | RGB palette | 128 | 44:6770 | PROBABLE | - | - | `gfx/bank44.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 2560 | 44:67F0 | PROBABLE | exact | - | `gfx/bank44.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 44:71F0 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `attrmap_7358.attrmap` | attribute map | 360 | 44:7358 | PROBABLE | - | 20x18 | `gfx/bank44.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 44:74C0 | PROBABLE | - | - | `gfx/bank44.asm` |

### `gfx/bank45/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 2560 | 45:4000 | PROBABLE | exact | - | `gfx/bank45.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 45:4A00 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `tilemap_4a00.attrmap` | attribute map | 360 | 45:4B68 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 45:4CD0 | PROBABLE | - | - | `gfx/bank45.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 2560 | 45:4D50 | PROBABLE | exact | - | `gfx/bank45.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 45:5750 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `tilemap_5750.attrmap` | attribute map | 360 | 45:58B8 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 45:5A20 | PROBABLE | - | - | `gfx/bank45.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 2560 | 45:5AA0 | PROBABLE | exact | - | `gfx/bank45.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 45:64A0 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `tilemap_64a0.attrmap` | attribute map | 360 | 45:6608 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `palette_6770.pal` | RGB palette | 128 | 45:6770 | PROBABLE | - | - | `gfx/bank45.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 2560 | 45:67F0 | PROBABLE | exact | - | `gfx/bank45.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 45:71F0 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `tilemap_71f0.attrmap` | attribute map | 360 | 45:7358 | PROBABLE | - | 20x18 | `gfx/bank45.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 45:74C0 | PROBABLE | - | - | `gfx/bank45.asm` |

### `gfx/bank46/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 2560 | 46:4000 | PROBABLE | exact | - | `gfx/bank46.asm` |
| `tilemap_4a00.tilemap` | tile-index map | 360 | 46:4A00 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `tilemap_4a00.attrmap` | attribute map | 360 | 46:4B68 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `palette_4cd0.pal` | RGB palette | 128 | 46:4CD0 | PROBABLE | - | - | `gfx/bank46.asm` |
| `tiles_4d50.2bpp` | 2bpp tiles | 2560 | 46:4D50 | PROBABLE | exact | - | `gfx/bank46.asm` |
| `tilemap_5750.tilemap` | tile-index map | 360 | 46:5750 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `tilemap_5750.attrmap` | attribute map | 360 | 46:58B8 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `palette_5a20.pal` | RGB palette | 128 | 46:5A20 | PROBABLE | - | - | `gfx/bank46.asm` |
| `tiles_5aa0.2bpp` | 2bpp tiles | 2560 | 46:5AA0 | PROBABLE | exact | - | `gfx/bank46.asm` |
| `tilemap_64a0.tilemap` | tile-index map | 360 | 46:64A0 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `tilemap_64a0.attrmap` | attribute map | 360 | 46:6608 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `palette_6770.pal` | RGB palette | 128 | 46:6770 | PROBABLE | - | - | `gfx/bank46.asm` |
| `tiles_67f0.2bpp` | 2bpp tiles | 2560 | 46:67F0 | PROBABLE | exact | - | `gfx/bank46.asm` |
| `tilemap_71f0.tilemap` | tile-index map | 360 | 46:71F0 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `tilemap_71f0.attrmap` | attribute map | 360 | 46:7358 | PROBABLE | - | 20x18 | `gfx/bank46.asm` |
| `palette_74c0.pal` | RGB palette | 128 | 46:74C0 | PROBABLE | - | - | `gfx/bank46.asm` |

### `gfx/bank52/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4080.2bpp` | 2bpp tiles | 2944 | 52:4080 | PROBABLE | exact | - | `gfx/bank52.asm` |

### `gfx/bank5b/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 4608 | 5B:4000 | PROBABLE | exact | - | `gfx/bank5b.asm` |
| `tiles_5200.2bpp` | 2bpp tiles | 1152 | 5B:5200 | PROBABLE | exact | - | `gfx/bank5b.asm` |
| `palette_5680.pal` | RGB palette | 96 | 5B:5680 | PROBABLE | - | - | `gfx/bank5b.asm` |

### `gfx/bank60/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4360.2bpp` | 2bpp tiles | 240 | 60:4360 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_4455.2bpp` | 2bpp tiles | 1136 | 60:4455 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_4b50.2bpp` | 2bpp tiles | 560 | 60:4B50 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_4dd0.2bpp` | 2bpp tiles | 1184 | 60:4DD0 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_52c0.2bpp` | 2bpp tiles | 16 | 60:52C0 | HYPOTHESIS | exact | - | `gfx/bank60.asm` |
| `tiles_52d0.2bpp` | 2bpp tiles | 880 | 60:52D0 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_5640.2bpp` | 2bpp tiles | 176 | 60:5640 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_5740.2bpp` | 2bpp tiles | 112 | 60:5740 | HYPOTHESIS | exact | - | `gfx/bank60.asm` |
| `tiles_5800.2bpp` | 2bpp tiles | 768 | 60:5800 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_5d50.2bpp` | 2bpp tiles | 704 | 60:5D50 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_6010.2bpp` | 2bpp tiles | 80 | 60:6010 | HYPOTHESIS | exact | - | `gfx/bank60.asm` |
| `tiles_6060.2bpp` | 2bpp tiles | 592 | 60:6060 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_62b0.2bpp` | 2bpp tiles | 448 | 60:62B0 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_64c0.2bpp` | 2bpp tiles | 112 | 60:64C0 | HYPOTHESIS | exact | - | `gfx/bank60.asm` |
| `tiles_6580.2bpp` | 2bpp tiles | 128 | 60:6580 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_6640.2bpp` | 2bpp tiles | 2656 | 60:6640 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_70a0.2bpp` | 2bpp tiles | 1616 | 60:70A0 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `tiles_76f0.2bpp` | 2bpp tiles | 912 | 60:76F0 | PROBABLE | exact | - | `gfx/bank60.asm` |
| `palette_7a80.pal` | RGB palette | 104 | 60:7A80 | PROBABLE | - | - | `gfx/bank60.asm` |

### `gfx/bank61/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4cc0.2bpp` | 2bpp tiles | 672 | 61:4CC0 | PROBABLE | exact | - | `gfx/bank61.asm` |
| `tiles_4f63.2bpp` | 2bpp tiles | 656 | 61:4F63 | PROBABLE | exact | - | `gfx/bank61.asm` |
| `tiles_58b0.2bpp` | 2bpp tiles | 656 | 61:58B0 | PROBABLE | exact | - | `gfx/bank61.asm` |
| `tiles_65c0.2bpp` | 2bpp tiles | 800 | 61:65C0 | PROBABLE | exact | - | `gfx/bank61.asm` |
| `palette_7a80.pal` | RGB palette | 104 | 61:7A80 | PROBABLE | - | - | `gfx/bank61.asm` |

### `gfx/browser/frames_0_1/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 16 | 47:4000 | PROBABLE | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4010.2bpp` | 2bpp tiles | 48 | 47:4010 | PROBABLE | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4040.2bpp` | 2bpp tiles | 64 | 47:4040 | PROBABLE | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4080.2bpp` | 2bpp tiles | 16 | 47:4080 | CONFIRMED | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4090.2bpp` | 2bpp tiles | 48 | 47:4090 | CONFIRMED | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_40c0.2bpp` | 2bpp tiles | 16 | 47:40C0 | CONFIRMED | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_40d0.2bpp` | 2bpp tiles | 48 | 47:40D0 | CONFIRMED | exact | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4100.2bpp` | 2bpp tiles | 2560 | 47:4100 | PROBABLE | exact | - | `gfx/browser/frames_0_1.asm` |
| `tilemap_4b00.tilemap` | tile-index map | 360 | 47:4B00 | PROBABLE | - | 20x18 | `gfx/browser/frames_0_1.asm` |
| `tilemap_4b00.attrmap` | attribute map | 360 | 47:4C68 | PROBABLE | - | 20x18 | `gfx/browser/frames_0_1.asm` |
| `palette_4dd0.pal` | RGB palette | 128 | 47:4DD0 | PROBABLE | - | - | `gfx/browser/frames_0_1.asm` |
| `tiles_4e50.2bpp` | 2bpp tiles | 2560 | 47:4E50 | PROBABLE | exact | - | `gfx/browser/frames_0_1.asm` |
| `tilemap_5850.tilemap` | tile-index map | 360 | 47:5850 | PROBABLE | - | 20x18 | `gfx/browser/frames_0_1.asm` |
| `tilemap_5850.attrmap` | attribute map | 360 | 47:59B8 | PROBABLE | - | 20x18 | `gfx/browser/frames_0_1.asm` |
| `palette_5b20.pal` | RGB palette | 128 | 47:5B20 | PROBABLE | - | - | `gfx/browser/frames_0_1.asm` |

### `gfx/browser/frames_2_3/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_5ba0.2bpp` | 2bpp tiles | 2560 | 47:5BA0 | PROBABLE | exact | - | `gfx/browser/frames_2_3.asm` |
| `tilemap_65a0.tilemap` | tile-index map | 360 | 47:65A0 | PROBABLE | - | 20x18 | `gfx/browser/frames_2_3.asm` |
| `tilemap_65a0.attrmap` | attribute map | 360 | 47:6708 | PROBABLE | - | 20x18 | `gfx/browser/frames_2_3.asm` |
| `palette_6870.pal` | RGB palette | 128 | 47:6870 | PROBABLE | - | - | `gfx/browser/frames_2_3.asm` |
| `tiles_68f0.2bpp` | 2bpp tiles | 2560 | 47:68F0 | PROBABLE | exact | - | `gfx/browser/frames_2_3.asm` |
| `tilemap_72f0.tilemap` | tile-index map | 360 | 47:72F0 | PROBABLE | - | 20x18 | `gfx/browser/frames_2_3.asm` |
| `tilemap_72f0.attrmap` | attribute map | 360 | 47:7458 | PROBABLE | - | 20x18 | `gfx/browser/frames_2_3.asm` |
| `palette_75c0.pal` | RGB palette | 128 | 47:75C0 | PROBABLE | - | - | `gfx/browser/frames_2_3.asm` |

### `gfx/browser/menus/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `browser_menu3_tiles0.2bpp` | 2bpp tiles | 1024 | 72:6C10 | CONFIRMED | exact | - | `gfx/browser/menus.asm` |
| `browser_menu3_tiles1.2bpp` | 2bpp tiles | 256 | 72:7010 | CONFIRMED | exact | - | `gfx/browser/menus.asm` |
| `browser_menu3_map.tilemap` | tile-index map | 120 | 72:7110 | CONFIRMED | - | 20x6 | `gfx/browser/menus.asm` |
| `browser_menu3_map.attrmap` | attribute map | 120 | 72:7188 | CONFIRMED | - | 20x6 | `gfx/browser/menus.asm` |
| `palette_7206.pal` | RGB palette | 16 | 72:7206 | PROBABLE | - | - | `gfx/browser/menus.asm` |
| `browser_menu2_tiles0.2bpp` | 2bpp tiles | 1024 | 72:7220 | PROBABLE | exact | - | `gfx/browser/menus.asm` |
| `browser_menu2_tiles1.2bpp` | 2bpp tiles | 256 | 72:7620 | PROBABLE | exact | - | `gfx/browser/menus.asm` |
| `browser_menu2_map.tilemap` | tile-index map | 120 | 72:7720 | PROBABLE | - | 20x6 | `gfx/browser/menus.asm` |
| `browser_menu2_map.attrmap` | attribute map | 120 | 72:7798 | PROBABLE | - | 20x6 | `gfx/browser/menus.asm` |
| `browser_menu2_palette.pal` | RGB palette | 24 | 72:7810 | PROBABLE | - | - | `gfx/browser/menus.asm` |

### `gfx/browser/page_list/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `page_list_tiles_5400.2bpp` | 2bpp tiles | 464 | 24:5400 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `tiles_55d0.2bpp` | 2bpp tiles | 560 | 24:55D0 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `page_list_tiles_5800.2bpp` | 2bpp tiles | 16 | 24:5800 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `tiles_5810.2bpp` | 2bpp tiles | 160 | 24:5810 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `page_list_tilemap_5900.tilemap` | tile-index map | 360 | 24:5900 | PROBABLE | - | 20x18 | `gfx/browser/page_list.asm` |
| `page_list_tilemap_5900.attrmap` | attribute map | 360 | 24:5A68 | PROBABLE | - | 20x18 | `gfx/browser/page_list.asm` |
| `page_list_tilemap_5bd0.tilemap` | tile-index map | 360 | 24:5BD0 | PROBABLE | - | 20x18 | `gfx/browser/page_list.asm` |
| `page_list_tilemap_5bd0.attrmap` | attribute map | 360 | 24:5D38 | PROBABLE | - | 20x18 | `gfx/browser/page_list.asm` |
| `page_list_bg_palette.pal` | RGB palette | 64 | 24:5EA0 | PROBABLE | - | - | `gfx/browser/page_list.asm` |
| `tiles_5ef1.2bpp` | 2bpp tiles | 992 | 24:5EF1 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `tiles_6301.2bpp` | 2bpp tiles | 192 | 24:6301 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `tiles_63e0.2bpp` | 2bpp tiles | 256 | 24:63E0 | PROBABLE | exact | - | `gfx/browser/page_list.asm` |
| `page_list_obj_palette.pal` | RGB palette | 64 | 24:64E0 | PROBABLE | - | - | `gfx/browser/page_list.asm` |

### `gfx/browser/start_choice/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `browser_start_map.tilemap` | tile-index map | 360 | 73:4097 | CONFIRMED | - | 20x18 | `gfx/browser/start_choice.asm` |
| `browser_start_map.attrmap` | attribute map | 360 | 73:41FF | CONFIRMED | - | 20x18 | `gfx/browser/start_choice.asm` |
| `browser_start_top_map_normal.tilemap` | tile-index map | 40 | 73:4367 | PROBABLE | - | 10x4 | `gfx/browser/start_choice.asm` |
| `browser_start_top_attr_normal.attrmap` | attribute map | 40 | 73:43AD | PROBABLE | - | - | `gfx/browser/start_choice.asm` |
| `browser_start_bottom_map_selected.tilemap` | tile-index map | 30 | 73:441B | PROBABLE | - | 10x3 | `gfx/browser/start_choice.asm` |
| `browser_start_bottom_attr_selected.attrmap` | attribute map | 30 | 73:4461 | PROBABLE | - | - | `gfx/browser/start_choice.asm` |
| `tiles_4530.2bpp` | 2bpp tiles | 176 | 73:4530 | PROBABLE | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_tiles0.2bpp` | 2bpp tiles | 1024 | 73:45E0 | CONFIRMED | exact | - | `gfx/browser/start_choice.asm` |
| `tiles_49e0.2bpp` | 2bpp tiles | 1024 | 73:49E0 | PROBABLE | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_tiles1.2bpp` | 2bpp tiles | 1024 | 73:4DE0 | CONFIRMED | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_tiles2.2bpp` | 2bpp tiles | 1024 | 73:51E0 | CONFIRMED | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_tiles3.2bpp` | 2bpp tiles | 1024 | 73:55E0 | CONFIRMED | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_tiles4.2bpp` | 2bpp tiles | 1024 | 73:59E0 | CONFIRMED | exact | - | `gfx/browser/start_choice.asm` |
| `browser_start_palettes.pal` | RGB palette | 8 | 73:5DE0 | CONFIRMED | - | - | `gfx/browser/start_choice.asm` |
| `palette_5de8.pal` | RGB palette | 24 | 73:5DE8 | PROBABLE | - | - | `gfx/browser/start_choice.asm` |
| `palette_5e08.pal` | RGB palette | 24 | 73:5E08 | PROBABLE | - | - | `gfx/browser/start_choice.asm` |
| `browser_start_obj_palettes.pal` | RGB palette | 16 | 73:5E20 | PROBABLE | - | - | `gfx/browser/start_choice.asm` |
| `palette_5e38.pal` | RGB palette | 136 | 73:5E38 | PROBABLE | - | - | `gfx/browser/start_choice.asm` |

### `gfx/comm/comm_scene/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_5490.2bpp` | 2bpp tiles | 1024 | 70:5490 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_5890.2bpp` | 2bpp tiles | 1024 | 70:5890 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_5c90.2bpp` | 2bpp tiles | 1024 | 70:5C90 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_6090.2bpp` | 2bpp tiles | 1024 | 70:6090 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_6490.2bpp` | 2bpp tiles | 512 | 70:6490 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_6690.2bpp` | 2bpp tiles | 512 | 70:6690 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_6890.2bpp` | 2bpp tiles | 512 | 70:6890 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `tiles_6a90.2bpp` | 2bpp tiles | 512 | 70:6A90 | CONFIRMED | exact | - | `gfx/comm/comm_scene.asm` |
| `palette_6c90.pal` | RGB palette | 64 | 70:6C90 | PROBABLE | - | - | `gfx/comm/comm_scene.asm` |
| `palette_6cd0.pal` | RGB palette | 64 | 70:6CD0 | PROBABLE | - | - | `gfx/comm/comm_scene.asm` |
| `tilemap_6d10.tilemap` | tile-index map | 448 | 70:6D10 | CONFIRMED | - | 32x14 | `gfx/comm/comm_scene.asm` |
| `tilemap_6d10.attrmap` | attribute map | 448 | 70:6ED0 | CONFIRMED | - | 32x14 | `gfx/comm/comm_scene.asm` |
| `tilemap_7090.tilemap` | tile-index map | 80 | 70:7090 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7090.attrmap` | attribute map | 80 | 70:70E0 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7130.tilemap` | tile-index map | 80 | 70:7130 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7130.attrmap` | attribute map | 80 | 70:7180 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_71d0.tilemap` | tile-index map | 80 | 70:71D0 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_71d0.attrmap` | attribute map | 80 | 70:7220 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7270.tilemap` | tile-index map | 80 | 70:7270 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7270.attrmap` | attribute map | 80 | 70:72C0 | CONFIRMED | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7310.tilemap` | tile-index map | 80 | 70:7310 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7310.attrmap` | attribute map | 80 | 70:7360 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_73b0.tilemap` | tile-index map | 80 | 70:73B0 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_73b0.attrmap` | attribute map | 80 | 70:7400 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7450.tilemap` | tile-index map | 80 | 70:7450 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_7450.attrmap` | attribute map | 80 | 70:74A0 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_74f0.tilemap` | tile-index map | 80 | 70:74F0 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |
| `tilemap_74f0.attrmap` | attribute map | 80 | 70:7540 | PROBABLE | - | 20x4 | `gfx/comm/comm_scene.asm` |

### `gfx/comm/connect_dialog_bank56/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_418a.tilemap` | tile-index map | 360 | 56:418A | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_418a.attrmap` | attribute map | 360 | 56:42F2 | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_445a.tilemap` | tile-index map | 360 | 56:445A | CONFIRMED | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_445a.attrmap` | attribute map | 360 | 56:45C2 | CONFIRMED | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_472a.tilemap` | tile-index map | 360 | 56:472A | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_472a.attrmap` | attribute map | 360 | 56:4892 | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_49fa.tilemap` | tile-index map | 360 | 56:49FA | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_49fa.attrmap` | attribute map | 360 | 56:4B62 | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_4cca.tilemap` | tile-index map | 360 | 56:4CCA | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_4cca.attrmap` | attribute map | 360 | 56:4E32 | PROBABLE | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_4f9a.tilemap` | tile-index map | 360 | 56:4F9A | CONFIRMED | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tilemap_4f9a.attrmap` | attribute map | 360 | 56:5102 | CONFIRMED | - | 20x18 | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_526a.2bpp` | 2bpp tiles | 80 | 56:526A | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_52c0.2bpp` | 2bpp tiles | 1024 | 56:52C0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_56c0.2bpp` | 2bpp tiles | 1024 | 56:56C0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_5ac0.2bpp` | 2bpp tiles | 768 | 56:5AC0 | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_5dc0.2bpp` | 2bpp tiles | 768 | 56:5DC0 | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_60c0.2bpp` | 2bpp tiles | 1024 | 56:60C0 | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_64c0.2bpp` | 2bpp tiles | 1024 | 56:64C0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_68c0.2bpp` | 2bpp tiles | 512 | 56:68C0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_6ac0.2bpp` | 2bpp tiles | 1024 | 56:6AC0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_6ec0.2bpp` | 2bpp tiles | 768 | 56:6EC0 | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_71c0.2bpp` | 2bpp tiles | 1024 | 56:71C0 | PROBABLE | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `tiles_75c0.2bpp` | 2bpp tiles | 512 | 56:75C0 | CONFIRMED | exact | - | `gfx/comm/connect_dialog_bank56.asm` |
| `palette_77c0.pal` | RGB palette | 192 | 56:77C0 | PROBABLE | - | - | `gfx/comm/connect_dialog_bank56.asm` |

### `gfx/comm/connect_dialog_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `connect_dialog_blank_tile.2bpp` | 2bpp tiles | 16 | 57:4D30 | PROBABLE | exact | - | `engine/comm/connect_dialog_screen.asm` |

### `gfx/comm/connection_icon/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `conn_icon_tiles0.2bpp` | 2bpp tiles | 1024 | 69:4160 | CONFIRMED | exact | - | `gfx/comm/connection_icon.asm` |
| `conn_icon_tiles1.2bpp` | 2bpp tiles | 512 | 69:4560 | CONFIRMED | exact | - | `gfx/comm/connection_icon.asm` |
| `conn_icon_palettes.pal` | RGB palette | 24 | 69:4760 | PROBABLE | - | - | `gfx/comm/connection_icon.asm` |

### `gfx/comm/notice_dialog/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `comm_notice_a_cut_over60.tilemap` | tile-index map | 360 | 50:439A | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_4502.attrmap` | attribute map | 360 | 50:4502 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_a_ask_over60.tilemap` | tile-index map | 360 | 50:466A | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_47d2.attrmap` | attribute map | 360 | 50:47D2 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_a_cut_soon.tilemap` | tile-index map | 360 | 50:493A | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_4aa2.attrmap` | attribute map | 360 | 50:4AA2 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_a_ask_soon.tilemap` | tile-index map | 360 | 50:4C0A | CONFIRMED | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_4d72.attrmap` | attribute map | 360 | 50:4D72 | CONFIRMED | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_b_cut_over60.tilemap` | tile-index map | 360 | 50:4EDA | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_5042.attrmap` | attribute map | 360 | 50:5042 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_b_ask_over60.tilemap` | tile-index map | 360 | 50:51AA | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_5312.attrmap` | attribute map | 360 | 50:5312 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_b_cut_soon.tilemap` | tile-index map | 360 | 50:547A | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_55e2.attrmap` | attribute map | 360 | 50:55E2 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `comm_notice_b_ask_soon.tilemap` | tile-index map | 360 | 50:574A | PROBABLE | - | 20x18 | `gfx/comm/notice_dialog.asm` |
| `attrmap_58b2.attrmap` | attribute map | 360 | 50:58B2 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |
| `tiles_5a20.2bpp` | 2bpp tiles | 1024 | 50:5A20 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_5e20.2bpp` | 2bpp tiles | 416 | 50:5E20 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_5fc0.2bpp` | 2bpp tiles | 16 | 50:5FC0 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_5fd0.2bpp` | 2bpp tiles | 800 | 50:5FD0 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_62f0.2bpp` | 2bpp tiles | 1024 | 50:62F0 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_66f0.2bpp` | 2bpp tiles | 416 | 50:66F0 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_6890.2bpp` | 2bpp tiles | 16 | 50:6890 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `tiles_68a0.2bpp` | 2bpp tiles | 800 | 50:68A0 | PROBABLE | exact | - | `gfx/comm/notice_dialog.asm` |
| `palette_6bc0.pal` | RGB palette | 256 | 50:6BC0 | PROBABLE | - | - | `gfx/comm/notice_dialog.asm` |

### `gfx/comm/time_summary/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_42a0.2bpp` | 2bpp tiles | 1024 | 51:42A0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `tiles_46a0.2bpp` | 2bpp tiles | 1024 | 51:46A0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `comm_time_summary_a.tilemap` | tile-index map | 360 | 51:4AA0 | PROBABLE | - | 20x18 | `gfx/comm/time_summary.asm` |
| `comm_time_summary_a.attrmap` | attribute map | 360 | 51:4C08 | PROBABLE | - | 20x18 | `gfx/comm/time_summary.asm` |
| `palette_4d70.pal` | RGB palette | 64 | 51:4D70 | PROBABLE | - | - | `gfx/comm/time_summary.asm` |
| `tiles_4db0.2bpp` | 2bpp tiles | 1024 | 51:4DB0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `tiles_51b0.2bpp` | 2bpp tiles | 1024 | 51:51B0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `comm_time_summary_b.tilemap` | tile-index map | 360 | 51:55B0 | PROBABLE | - | 20x18 | `gfx/comm/time_summary.asm` |
| `comm_time_summary_b.attrmap` | attribute map | 360 | 51:5718 | PROBABLE | - | 20x18 | `gfx/comm/time_summary.asm` |
| `tiles_58c0.2bpp` | 2bpp tiles | 1024 | 51:58C0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `tiles_5cc0.2bpp` | 2bpp tiles | 512 | 51:5CC0 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |
| `palette_5ec0.pal` | RGB palette | 32 | 51:5EC0 | PROBABLE | - | - | `gfx/comm/time_summary.asm` |
| `tiles_5ee1.2bpp` | 2bpp tiles | 4592 | 51:5EE1 | PROBABLE | exact | - | `gfx/comm/time_summary.asm` |

### `gfx/dialog/dialog_window/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `dialog_window_tiles.2bpp` | 2bpp tiles | 1024 | 72:48C0 | CONFIRMED | exact | - | `gfx/dialog/dialog_window.asm` |
| `dialog_window_map.tilemap` | tile-index map | 180 | 72:4CC0 | CONFIRMED | - | 20x9 | `gfx/dialog/dialog_window.asm` |
| `dialog_window_map.attrmap` | attribute map | 180 | 72:4D74 | CONFIRMED | - | 20x9 | `gfx/dialog/dialog_window.asm` |
| `dialog_palette.pal` | RGB palette | 16 | 72:4E28 | CONFIRMED | - | - | `gfx/dialog/dialog_window.asm` |
| `dialog_obj_palette.pal` | RGB palette | 8 | 72:4E38 | CONFIRMED | - | - | `gfx/dialog/dialog_window.asm` |
| `dialog_window_map_tall.tilemap` | tile-index map | 220 | 72:4E73 | CONFIRMED | - | 20x11 | `gfx/dialog/dialog_window.asm` |
| `dialog_window_map_tall.attrmap` | attribute map | 220 | 72:4F4F | CONFIRMED | - | 20x11 | `gfx/dialog/dialog_window.asm` |

### `gfx/error/comm_error_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `comm_err_tilemap_comm.tilemap` | tile-index map | 360 | 5C:5516 | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_tilemap_comm.attrmap` | attribute map | 360 | 5C:567E | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_tilemap_comm_timer.tilemap` | tile-index map | 360 | 5C:57E6 | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_tilemap_comm_timer.attrmap` | attribute map | 360 | 5C:594E | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_tilemap_plain.tilemap` | tile-index map | 360 | 5C:5AB6 | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_tilemap_plain.attrmap` | attribute map | 360 | 5C:5C1E | CONFIRMED | - | 20x18 | `gfx/error/comm_error_screen.asm` |
| `comm_err_gfx_obj8000.2bpp` | 2bpp tiles | 32 | 5C:5D90 | CONFIRMED | exact | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_gfx_obj8100.2bpp` | 2bpp tiles | 32 | 5C:5DB0 | CONFIRMED | exact | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_gfx_bg9000.2bpp` | 2bpp tiles | 1024 | 5C:5DD0 | CONFIRMED | exact | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_gfx_bg9400.2bpp` | 2bpp tiles | 384 | 5C:61D0 | CONFIRMED | exact | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_palette_bg_timer.pal` | RGB palette | 64 | 5C:6350 | PROBABLE | - | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_palette_bg.pal` | RGB palette | 64 | 5C:6390 | PROBABLE | - | - | `gfx/error/comm_error_screen.asm` |
| `comm_err_palette_obj.pal` | RGB palette | 64 | 5C:63D0 | PROBABLE | - | - | `gfx/error/comm_error_screen.asm` |

### `gfx/error/no_adapter/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `no_adapter_gfx_8000.2bpp` | 2bpp tiles | 64 | 63:6080 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `no_adapter_gfx_8800.2bpp` | 2bpp tiles | 960 | 63:60C0 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `tiles_6480.2bpp` | 2bpp tiles | 64 | 63:6480 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `no_adapter_gfx_8c00.2bpp` | 2bpp tiles | 1024 | 63:64C0 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `no_adapter_gfx_9000.2bpp` | 2bpp tiles | 1024 | 63:68C0 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `no_adapter_gfx_9400.2bpp` | 2bpp tiles | 768 | 63:6CC0 | CONFIRMED | exact | - | `gfx/error/no_adapter.asm` |
| `no_adapter_palette_bg.pal` | RGB palette | 40 | 63:7290 | PROBABLE | - | - | `gfx/error/no_adapter.asm` |
| `no_adapter_palette_obj.pal` | RGB palette | 64 | 63:72D0 | CONFIRMED | - | - | `gfx/error/no_adapter.asm` |

### `gfx/error/non_cgb_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4060.2bpp` | 2bpp tiles | 1056 | 6B:4060 | PROBABLE | exact | - | `gfx/error/non_cgb_screen.asm` |
| `non_cgb_tiles.2bpp` | 2bpp tiles | 1968 | 6B:4480 | PROBABLE | exact | - | `gfx/error/non_cgb_screen.asm` |

### `gfx/help/help_screens_a/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_4000.tilemap` | tile-index map | 360 | 6A:4000 | CONFIRMED | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_4000.attrmap` | attribute map | 360 | 6A:4168 | CONFIRMED | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_42d0.tilemap` | tile-index map | 360 | 6A:42D0 | CONFIRMED | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_42d0.attrmap` | attribute map | 360 | 6A:4438 | CONFIRMED | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_45a0.tilemap` | tile-index map | 360 | 6A:45A0 | PROBABLE | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_45a0.attrmap` | attribute map | 360 | 6A:4708 | PROBABLE | - | 20x18 | `gfx/help/help_screens_a.asm` |
| `tilemap_4870.tilemap` | tile-index map | 210 | 6A:4870 | PROBABLE | - | 10x21 | `gfx/help/help_screens_a.asm` |
| `tilemap_4870.attrmap` | attribute map | 210 | 6A:4942 | PROBABLE | - | 10x21 | `gfx/help/help_screens_a.asm` |
| `tilemap_4a14.tilemap` | tile-index map | 90 | 6A:4A14 | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4a14.attrmap` | attribute map | 90 | 6A:4A6E | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4ac8.tilemap` | tile-index map | 90 | 6A:4AC8 | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4ac8.attrmap` | attribute map | 90 | 6A:4B22 | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4b7c.tilemap` | tile-index map | 210 | 6A:4B7C | PROBABLE | - | 10x21 | `gfx/help/help_screens_a.asm` |
| `tilemap_4b7c.attrmap` | attribute map | 210 | 6A:4C4E | PROBABLE | - | 10x21 | `gfx/help/help_screens_a.asm` |
| `tilemap_4d20.tilemap` | tile-index map | 90 | 6A:4D20 | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4d20.attrmap` | attribute map | 90 | 6A:4D7A | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4dd4.tilemap` | tile-index map | 90 | 6A:4DD4 | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tilemap_4dd4.attrmap` | attribute map | 90 | 6A:4E2E | PROBABLE | - | 10x9 | `gfx/help/help_screens_a.asm` |
| `tiles_4e90.2bpp` | 2bpp tiles | 1024 | 6A:4E90 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `tiles_5290.2bpp` | 2bpp tiles | 1024 | 6A:5290 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `tiles_5690.2bpp` | 2bpp tiles | 1024 | 6A:5690 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `tiles_5a90.2bpp` | 2bpp tiles | 32 | 6A:5A90 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `tiles_5ab0.2bpp` | 2bpp tiles | 1024 | 6A:5AB0 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `tiles_5eb0.2bpp` | 2bpp tiles | 1024 | 6A:5EB0 | CONFIRMED | exact | - | `gfx/help/help_screens_a.asm` |
| `palette_62b8.pal` | RGB palette | 24 | 6A:62B8 | PROBABLE | - | - | `gfx/help/help_screens_a.asm` |
| `palette_62d8.pal` | RGB palette | 32 | 6A:62D8 | PROBABLE | - | - | `gfx/help/help_screens_a.asm` |
| `palette_6300.pal` | RGB palette | 328 | 6A:6300 | PROBABLE | - | - | `gfx/help/help_screens_a.asm` |

### `gfx/help/help_screens_b/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_6716.tilemap` | tile-index map | 360 | 6A:6716 | CONFIRMED | - | 20x18 | `gfx/help/help_screens_b.asm` |
| `tilemap_6716.attrmap` | attribute map | 360 | 6A:687E | CONFIRMED | - | 20x18 | `gfx/help/help_screens_b.asm` |
| `tiles_69f0.2bpp` | 2bpp tiles | 32 | 6A:69F0 | CONFIRMED | exact | - | `gfx/help/help_screens_b.asm` |
| `tiles_6a10.2bpp` | 2bpp tiles | 16 | 6A:6A10 | CONFIRMED | exact | - | `gfx/help/help_screens_b.asm` |
| `tiles_6a20.2bpp` | 2bpp tiles | 1024 | 6A:6A20 | CONFIRMED | exact | - | `gfx/help/help_screens_b.asm` |
| `tiles_6e20.2bpp` | 2bpp tiles | 1024 | 6A:6E20 | PROBABLE | exact | - | `gfx/help/help_screens_b.asm` |
| `palette_7220.pal` | RGB palette | 128 | 6A:7220 | PROBABLE | - | - | `gfx/help/help_screens_b.asm` |

### `gfx/help/mobile_dictionary/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mobile_dict_screen.tilemap` | tile-index map | 360 | 1A:47B5 | CONFIRMED | - | 20x18 | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_screen.attrmap` | attribute map | 360 | 1A:491D | CONFIRMED | - | 20x18 | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_tiles0.2bpp` | 2bpp tiles | 512 | 1A:4A90 | CONFIRMED | exact | - | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_tiles1.2bpp` | 2bpp tiles | 1024 | 1A:4C90 | CONFIRMED | exact | - | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_tiles2.2bpp` | 2bpp tiles | 768 | 1A:5090 | CONFIRMED | exact | - | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_bg.pal` | RGB palette | 10 | 1A:5390 | CONFIRMED | - | - | `gfx/help/mobile_dictionary.asm` |
| `palette_539a.pal` | RGB palette | 54 | 1A:539A | PROBABLE | - | - | `gfx/help/mobile_dictionary.asm` |
| `mobile_dict_obj.pal` | RGB palette | 464 | 1A:53D0 | PROBABLE | - | - | `gfx/help/mobile_dictionary.asm` |

### `gfx/keyboard/panels_bank5d/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1024 | 5D:4000 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5d.asm` |
| `tiles_4400.2bpp` | 2bpp tiles | 1024 | 5D:4400 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5d.asm` |

### `gfx/keyboard/panels_bank5f/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1024 | 5F:4000 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_4400.2bpp` | 2bpp tiles | 1024 | 5F:4400 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_4800.2bpp` | 2bpp tiles | 16 | 5F:4800 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_4810.tilemap` | tile-index map | 220 | 5F:4810 | CONFIRMED | - | 20x11 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_4810.attrmap` | attribute map | 220 | 5F:48EC | CONFIRMED | - | 20x11 | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_49d0.2bpp` | 2bpp tiles | 768 | 5F:49D0 | CONFIRMED | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `palette_4cd0.pal` | RGB palette | 40 | 5F:4CD0 | PROBABLE | - | - | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_4ecb.tilemap` | tile-index map | 260 | 5F:4ECB | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_4ecb.attrmap` | attribute map | 260 | 5F:4FCF | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_50d3.tilemap` | tile-index map | 260 | 5F:50D3 | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_50d3.attrmap` | attribute map | 260 | 5F:51D7 | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_52db.tilemap` | tile-index map | 260 | 5F:52DB | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_52db.attrmap` | attribute map | 260 | 5F:53DF | CONFIRMED | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_54e3.tilemap` | tile-index map | 260 | 5F:54E3 | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_54e3.attrmap` | attribute map | 260 | 5F:55E7 | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_56eb.tilemap` | tile-index map | 260 | 5F:56EB | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_56eb.attrmap` | attribute map | 260 | 5F:57EF | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_5900.2bpp` | 2bpp tiles | 1024 | 5F:5900 | PROBABLE | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_5d00.2bpp` | 2bpp tiles | 1024 | 5F:5D00 | PROBABLE | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tiles_6100.2bpp` | 2bpp tiles | 256 | 5F:6100 | PROBABLE | exact | - | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_69b0.tilemap` | tile-index map | 260 | 5F:69B0 | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `tilemap_69b0.attrmap` | attribute map | 260 | 5F:6AB4 | PROBABLE | - | 20x13 | `gfx/keyboard/panels_bank5f.asm` |
| `palette_6bb8.pal` | RGB palette | 24 | 5F:6BB8 | PROBABLE | - | - | `gfx/keyboard/panels_bank5f.asm` |

### `gfx/keyboard/tiles_bank62/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1024 | 62:4000 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_4400.2bpp` | 2bpp tiles | 1024 | 62:4400 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_4800.2bpp` | 2bpp tiles | 576 | 62:4800 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_4a40.2bpp` | 2bpp tiles | 192 | 62:4A40 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_4b00.2bpp` | 2bpp tiles | 1024 | 62:4B00 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_4f00.2bpp` | 2bpp tiles | 1024 | 62:4F00 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_5300.2bpp` | 2bpp tiles | 576 | 62:5300 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_5540.2bpp` | 2bpp tiles | 192 | 62:5540 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_5600.2bpp` | 2bpp tiles | 1024 | 62:5600 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_5a00.2bpp` | 2bpp tiles | 1024 | 62:5A00 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_5e00.2bpp` | 2bpp tiles | 576 | 62:5E00 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_6040.2bpp` | 2bpp tiles | 192 | 62:6040 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_6100.2bpp` | 2bpp tiles | 1024 | 62:6100 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_6500.2bpp` | 2bpp tiles | 1024 | 62:6500 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_6900.2bpp` | 2bpp tiles | 576 | 62:6900 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |
| `tiles_6b40.2bpp` | 2bpp tiles | 192 | 62:6B40 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank62.asm` |

### `gfx/keyboard/tiles_bank66/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1024 | 66:4000 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_4400.2bpp` | 2bpp tiles | 1024 | 66:4400 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_4800.2bpp` | 2bpp tiles | 576 | 66:4800 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_4a40.2bpp` | 2bpp tiles | 1024 | 66:4A40 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_4e40.2bpp` | 2bpp tiles | 1024 | 66:4E40 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_5240.2bpp` | 2bpp tiles | 576 | 66:5240 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_5480.2bpp` | 2bpp tiles | 1024 | 66:5480 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_5880.2bpp` | 2bpp tiles | 1024 | 66:5880 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_5c80.2bpp` | 2bpp tiles | 576 | 66:5C80 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_5ec0.2bpp` | 2bpp tiles | 1024 | 66:5EC0 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_62c0.2bpp` | 2bpp tiles | 1024 | 66:62C0 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_66c0.2bpp` | 2bpp tiles | 576 | 66:66C0 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_6900.2bpp` | 2bpp tiles | 400 | 66:6900 | CONFIRMED | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tiles_6a90.2bpp` | 2bpp tiles | 1792 | 66:6A90 | PROBABLE | exact | - | `gfx/keyboard/tiles_bank66.asm` |
| `tilemap_7210.tilemap` | tile-index map | 220 | 66:7210 | CONFIRMED | - | 20x11 | `gfx/keyboard/tiles_bank66.asm` |
| `tilemap_7210.attrmap` | attribute map | 220 | 66:72EC | CONFIRMED | - | 20x11 | `gfx/keyboard/tiles_bank66.asm` |
| `tilemap_73c8.tilemap` | tile-index map | 120 | 66:73C8 | CONFIRMED | - | 20x6 | `gfx/keyboard/tiles_bank66.asm` |
| `tilemap_73c8.attrmap` | attribute map | 120 | 66:7440 | CONFIRMED | - | 20x6 | `gfx/keyboard/tiles_bank66.asm` |

### `gfx/mail/address_editor/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_addr_tiles.2bpp` | 2bpp tiles | 1024 | 2D:7120 | CONFIRMED | exact | - | `gfx/mail/address_editor.asm` |
| `mail_addr_tiles2.2bpp` | 2bpp tiles | 176 | 2D:7520 | CONFIRMED | exact | - | `gfx/mail/address_editor.asm` |
| `mail_addr_tiles3.2bpp` | 2bpp tiles | 688 | 2D:75D0 | CONFIRMED | exact | - | `gfx/mail/address_editor.asm` |
| `mail_addr_obj_tiles.2bpp` | 2bpp tiles | 192 | 2D:7880 | CONFIRMED | exact | - | `gfx/mail/address_editor.asm` |
| `tiles_7940.2bpp` | 2bpp tiles | 528 | 2D:7940 | PROBABLE | exact | - | `gfx/mail/address_editor.asm` |
| `mail_addr.tilemap` | tile-index map | 360 | 2D:7B50 | CONFIRMED | - | 20x18 | `gfx/mail/address_editor.asm` |
| `mail_addr.attrmap` | attribute map | 360 | 2D:7CB8 | CONFIRMED | - | 20x18 | `gfx/mail/address_editor.asm` |
| `mail_addr_bg.pal` | RGB palette | 64 | 2D:7E20 | PROBABLE | - | - | `gfx/mail/address_editor.asm` |

### `gfx/mail/body_editor/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_body_tiles.2bpp` | 2bpp tiles | 960 | 2D:5AC0 | PROBABLE | exact | - | `gfx/mail/body_editor.asm` |
| `mail_body_tiles2.2bpp` | 2bpp tiles | 256 | 2D:5EC0 | CONFIRMED | exact | - | `gfx/mail/body_editor.asm` |
| `mail_body.tilemap` | tile-index map | 360 | 2D:5FC0 | CONFIRMED | - | 20x18 | `gfx/mail/body_editor.asm` |
| `mail_body.attrmap` | attribute map | 360 | 2D:6128 | CONFIRMED | - | 20x18 | `gfx/mail/body_editor.asm` |
| `mail_body_bg.pal` | RGB palette | 64 | 2D:6290 | PROBABLE | - | - | `gfx/mail/body_editor.asm` |
| `mail_body_obj_tiles.2bpp` | 2bpp tiles | 672 | 2D:62D0 | PROBABLE | exact | - | `gfx/mail/body_editor.asm` |
| `mail_body_obj.pal` | RGB palette | 64 | 2D:6570 | CONFIRMED | - | - | `gfx/mail/body_editor.asm` |

### `gfx/mail/body_view/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_body_tiles_42c0.2bpp` | 2bpp tiles | 528 | 28:42C0 | CONFIRMED | exact | - | `gfx/mail/body_view.asm` |
| `mail_body_tiles_44d0.2bpp` | 2bpp tiles | 128 | 28:44D0 | CONFIRMED | exact | - | `gfx/mail/body_view.asm` |
| `tilemap_4550.tilemap` | tile-index map | 360 | 28:4550 | PROBABLE | - | 20x18 | `gfx/mail/body_view.asm` |
| `tilemap_4550.attrmap` | attribute map | 360 | 28:46B8 | PROBABLE | - | 20x18 | `gfx/mail/body_view.asm` |
| `mail_body_tilemap.tilemap` | tile-index map | 360 | 28:4820 | CONFIRMED | - | 20x18 | `gfx/mail/body_view.asm` |
| `mail_body_tilemap.attrmap` | attribute map | 360 | 28:4988 | CONFIRMED | - | 20x18 | `gfx/mail/body_view.asm` |
| `mail_body_bg_palette.pal` | RGB palette | 64 | 28:4AF0 | PROBABLE | - | - | `gfx/mail/body_view.asm` |
| `mail_body_obj_palette.pal` | RGB palette | 64 | 28:4B30 | PROBABLE | - | - | `gfx/mail/body_view.asm` |

### `gfx/mail/comm_progress_scene/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `comm_progress_screen.tilemap` | tile-index map | 360 | 22:5980 | CONFIRMED | - | 20x18 | `gfx/mail/comm_progress_scene.asm` |
| `comm_progress_screen.attrmap` | attribute map | 360 | 22:5AE8 | CONFIRMED | - | 20x18 | `gfx/mail/comm_progress_scene.asm` |
| `comm_progress_bg.pal` | RGB palette | 2 | 22:5C50 | CONFIRMED | - | - | `gfx/mail/comm_progress_scene.asm` |
| `palette_5c52.pal` | RGB palette | 62 | 22:5C52 | PROBABLE | - | - | `gfx/mail/comm_progress_scene.asm` |
| `comm_progress_obj.pal` | RGB palette | 64 | 22:5C90 | PROBABLE | - | - | `gfx/mail/comm_progress_scene.asm` |

### `gfx/mail/comm_result/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_result_tiles_6bf0.2bpp` | 2bpp tiles | 1024 | 24:6BF0 | CONFIRMED | exact | - | `gfx/mail/comm_result.asm` |
| `mail_result_tiles_6ff0.2bpp` | 2bpp tiles | 1024 | 24:6FF0 | CONFIRMED | exact | - | `gfx/mail/comm_result.asm` |
| `mail_result_tiles_73f0.2bpp` | 2bpp tiles | 160 | 24:73F0 | CONFIRMED | exact | - | `gfx/mail/comm_result.asm` |
| `mail_result_tiles_7490.2bpp` | 2bpp tiles | 768 | 24:7490 | CONFIRMED | exact | - | `gfx/mail/comm_result.asm` |
| `mail_result_tilemap.tilemap` | tile-index map | 360 | 24:7790 | CONFIRMED | - | 20x18 | `gfx/mail/comm_result.asm` |
| `mail_result_tilemap.attrmap` | attribute map | 360 | 24:78F8 | CONFIRMED | - | 20x18 | `gfx/mail/comm_result.asm` |
| `mail_result_bg_palette.pal` | RGB palette | 64 | 24:7A60 | PROBABLE | - | - | `gfx/mail/comm_result.asm` |
| `mail_result_obj_palette.pal` | RGB palette | 64 | 24:7AA0 | PROBABLE | - | - | `gfx/mail/comm_result.asm` |
| `mail_server_status_bg_palette.pal` | RGB palette | 64 | 24:7AE0 | PROBABLE | - | - | `gfx/mail/comm_result.asm` |

### `gfx/mail/connect_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_connect_tiles_5060.2bpp` | 2bpp tiles | 1024 | 27:5060 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_5460.2bpp` | 2bpp tiles | 1024 | 27:5460 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_5860.2bpp` | 2bpp tiles | 1024 | 27:5860 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_5c60.2bpp` | 2bpp tiles | 512 | 27:5C60 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_5e60.2bpp` | 2bpp tiles | 1024 | 27:5E60 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_6260.2bpp` | 2bpp tiles | 1024 | 27:6260 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_6660.2bpp` | 2bpp tiles | 512 | 27:6660 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_6860.2bpp` | 2bpp tiles | 1024 | 27:6860 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tiles_6c60.2bpp` | 2bpp tiles | 1024 | 27:6C60 | CONFIRMED | exact | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_tilemap.tilemap` | tile-index map | 576 | 27:7060 | CONFIRMED | - | 32x18 | `gfx/mail/connect_screen.asm` |
| `mail_connect_tilemap.attrmap` | attribute map | 576 | 27:72A0 | CONFIRMED | - | 32x18 | `gfx/mail/connect_screen.asm` |
| `mail_connect_bg_palette.pal` | RGB palette | 56 | 27:74E0 | PROBABLE | - | - | `gfx/mail/connect_screen.asm` |
| `mail_screens_obj_palette_7520.pal` | RGB palette | 64 | 27:7520 | CONFIRMED | - | - | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_cancelling.tilemap` | tile-index map | 100 | 27:7560 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_cancelling.attrmap` | attribute map | 100 | 27:75C4 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_cancelled.tilemap` | tile-index map | 100 | 27:7628 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_cancelled.attrmap` | attribute map | 100 | 27:768C | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_disconnect_win_msg_ending.tilemap` | tile-index map | 100 | 27:76F0 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_disconnect_win_msg_ending.attrmap` | attribute map | 100 | 27:7754 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_disconnect_win_msg_ended.tilemap` | tile-index map | 100 | 27:77B8 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_disconnect_win_msg_ended.attrmap` | attribute map | 100 | 27:781C | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_connecting.tilemap` | tile-index map | 100 | 27:7880 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_connecting.attrmap` | attribute map | 100 | 27:78E4 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_connected.tilemap` | tile-index map | 100 | 27:7948 | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |
| `mail_connect_win_msg_connected.attrmap` | attribute map | 100 | 27:79AC | CONFIRMED | - | 20x5 | `gfx/mail/connect_screen.asm` |

### `gfx/mail/connect_screen_bank29/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `palette_5376.pal` | RGB palette | 128 | 29:5376 | PROBABLE | - | - | `gfx/mail/connect_screen_bank29.asm` |
| `tiles_5400.2bpp` | 2bpp tiles | 1024 | 29:5400 | PROBABLE | exact | - | `gfx/mail/connect_screen_bank29.asm` |
| `tilemap_5800.tilemap` | tile-index map | 360 | 29:5800 | PROBABLE | - | 20x18 | `gfx/mail/connect_screen_bank29.asm` |
| `tilemap_5800.attrmap` | attribute map | 360 | 29:5968 | PROBABLE | - | 20x18 | `gfx/mail/connect_screen_bank29.asm` |
| `palette_5ad0.pal` | RGB palette | 64 | 29:5AD0 | PROBABLE | - | - | `gfx/mail/connect_screen_bank29.asm` |

### `gfx/mail/draft_menu/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_draft_menu_tiles9300.2bpp` | 2bpp tiles | 720 | 2B:4880 | CONFIRMED | exact | - | `gfx/mail/draft_menu.asm` |
| `data_mail_draft_menu_tilemap_attr.tilemap` | tile-index map | 360 | 2B:4B50 | CONFIRMED | - | 20x18 | `gfx/mail/draft_menu.asm` |
| `data_mail_draft_menu_tilemap_attr.attrmap` | attribute map | 360 | 2B:4CB8 | CONFIRMED | - | 20x18 | `gfx/mail/draft_menu.asm` |
| `mail_draft_menu_bg.pal` | RGB palette | 64 | 2B:4E20 | PROBABLE | - | - | `gfx/mail/draft_menu.asm` |
| `mail_draft_menu_tiles8000.2bpp` | 2bpp tiles | 816 | 2B:4E60 | CONFIRMED | exact | - | `gfx/mail/draft_menu.asm` |
| `mail_draft_menu_obj.pal` | RGB palette | 64 | 2B:5190 | CONFIRMED | - | - | `gfx/mail/draft_menu.asm` |

### `gfx/mail/mail_title_entry/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_title_tiles9300.2bpp` | 2bpp tiles | 1024 | 2C:4A30 | CONFIRMED | exact | - | `gfx/mail/mail_title_entry.asm` |
| `data_mail_title_tilemap_attr.tilemap` | tile-index map | 360 | 2C:4E30 | CONFIRMED | - | 20x18 | `gfx/mail/mail_title_entry.asm` |
| `data_mail_title_tilemap_attr.attrmap` | attribute map | 360 | 2C:4F98 | CONFIRMED | - | 20x18 | `gfx/mail/mail_title_entry.asm` |
| `mail_title_bg.pal` | RGB palette | 64 | 2C:5100 | PROBABLE | - | - | `gfx/mail/mail_title_entry.asm` |
| `mail_title_tiles8000.2bpp` | 2bpp tiles | 16 | 2C:5140 | PROBABLE | exact | - | `gfx/mail/mail_title_entry.asm` |
| `mail_title_tiles8800.2bpp` | 2bpp tiles | 592 | 2C:5410 | CONFIRMED | exact | - | `gfx/mail/mail_title_entry.asm` |
| `mail_title_obj.pal` | RGB palette | 64 | 2C:5670 | CONFIRMED | - | - | `gfx/mail/mail_title_entry.asm` |

### `gfx/mail/mail_viewer/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_view_tiles9000.2bpp` | 2bpp tiles | 1024 | 2B:6DD0 | CONFIRMED | exact | - | `gfx/mail/mail_viewer.asm` |
| `mail_view_tiles9400.2bpp` | 2bpp tiles | 512 | 2B:71D0 | PROBABLE | exact | - | `gfx/mail/mail_viewer.asm` |
| `data_mail_view_tilemap_attr.tilemap` | tile-index map | 360 | 2B:73D0 | PROBABLE | - | 20x18 | `gfx/mail/mail_viewer.asm` |
| `data_mail_view_tilemap_attr.attrmap` | attribute map | 360 | 2B:7538 | PROBABLE | - | 20x18 | `gfx/mail/mail_viewer.asm` |
| `mail_view_bg.pal` | RGB palette | 64 | 2B:76A0 | PROBABLE | - | - | `gfx/mail/mail_viewer.asm` |
| `mail_view_tiles8000.2bpp` | 2bpp tiles | 384 | 2B:76E0 | PROBABLE | exact | - | `gfx/mail/mail_viewer.asm` |
| `mail_view_obj.pal` | RGB palette | 64 | 2B:7860 | PROBABLE | - | - | `gfx/mail/mail_viewer.asm` |

### `gfx/mail/received_mail_grid/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_grid_tiles9000.2bpp` | 2bpp tiles | 1024 | 2B:59C0 | PROBABLE | exact | - | `gfx/mail/received_mail_grid.asm` |
| `mail_grid_tiles9400.2bpp` | 2bpp tiles | 560 | 2B:5DC0 | PROBABLE | exact | - | `gfx/mail/received_mail_grid.asm` |
| `data_mail_grid_tilemap_attr.tilemap` | tile-index map | 360 | 2B:5FF0 | PROBABLE | - | 20x18 | `gfx/mail/received_mail_grid.asm` |
| `data_mail_grid_tilemap_attr.attrmap` | attribute map | 360 | 2B:6158 | PROBABLE | - | 20x18 | `gfx/mail/received_mail_grid.asm` |
| `mail_grid_bg.pal` | RGB palette | 64 | 2B:62C0 | PROBABLE | - | - | `gfx/mail/received_mail_grid.asm` |
| `mail_grid_tiles8000.2bpp` | 2bpp tiles | 240 | 2B:6300 | PROBABLE | exact | - | `gfx/mail/received_mail_grid.asm` |
| `mail_grid_obj.pal` | RGB palette | 64 | 2B:63F0 | PROBABLE | - | - | `gfx/mail/received_mail_grid.asm` |

### `gfx/mail/result_screens/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_status_tiles_5060.2bpp` | 2bpp tiles | 48 | 29:5060 | CONFIRMED | exact | - | `engine/mail/result_screens.asm` |

### `gfx/mail/server_status/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_status_tiles_6f30.2bpp` | 2bpp tiles | 1024 | 25:6F30 | CONFIRMED | exact | - | `gfx/mail/server_status.asm` |
| `mail_server_status_tiles_7330.2bpp` | 2bpp tiles | 1024 | 25:7330 | CONFIRMED | exact | - | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_received.tilemap` | tile-index map | 360 | 25:7730 | PROBABLE | - | 20x18 | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_received.attrmap` | attribute map | 360 | 25:7898 | PROBABLE | - | 20x18 | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_none_received.tilemap` | tile-index map | 360 | 25:7A00 | CONFIRMED | - | 20x18 | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_none_received.attrmap` | attribute map | 360 | 25:7B68 | CONFIRMED | - | 20x18 | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_server_mgmt.tilemap` | tile-index map | 360 | 25:7CD0 | CONFIRMED | - | 20x18 | `gfx/mail/server_status.asm` |
| `mail_server_status_tilemap_server_mgmt.attrmap` | attribute map | 360 | 25:7E38 | CONFIRMED | - | 20x18 | `gfx/mail/server_status.asm` |

### `gfx/mail/server_status_bank26/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_status_tiles_7420.2bpp` | 2bpp tiles | 1024 | 26:7420 | CONFIRMED | exact | - | `gfx/mail/server_status_bank26.asm` |
| `tiles_7840.2bpp` | 2bpp tiles | 624 | 26:7840 | PROBABLE | exact | - | `gfx/mail/server_status_bank26.asm` |

### `gfx/mail/session_scenery/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_session_tiles_59e0.2bpp` | 2bpp tiles | 1024 | 26:59E0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_5de0.2bpp` | 2bpp tiles | 1024 | 26:5DE0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_61e0.2bpp` | 2bpp tiles | 256 | 26:61E0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_62e0.2bpp` | 2bpp tiles | 1024 | 26:62E0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_66e0.2bpp` | 2bpp tiles | 16 | 26:66E0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `tiles_66f0.2bpp` | 2bpp tiles | 240 | 26:66F0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_67e0.2bpp` | 2bpp tiles | 1024 | 26:67E0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_6be0.2bpp` | 2bpp tiles | 1024 | 26:6BE0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `mail_session_tiles_6fe0.2bpp` | 2bpp tiles | 1024 | 26:6FE0 | CONFIRMED | exact | - | `gfx/mail/session_scenery.asm` |
| `palette_73e0.pal` | RGB palette | 64 | 26:73E0 | PROBABLE | - | - | `gfx/mail/session_scenery.asm` |

### `gfx/mail_menu/mail_menu/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_menu_screen.tilemap` | tile-index map | 360 | 1D:45C1 | CONFIRMED | - | 20x18 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_screen.attrmap` | attribute map | 360 | 1D:4729 | CONFIRMED | - | 20x18 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_plates_normal.tilemap` | tile-index map | 240 | 1D:4891 | PROBABLE | - | 10x24 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_plates_normal.attrmap` | attribute map | 240 | 1D:4981 | PROBABLE | - | 10x24 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_plates_selected.tilemap` | tile-index map | 240 | 1D:4A71 | PROBABLE | - | 10x24 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_plates_selected.attrmap` | attribute map | 240 | 1D:4B61 | PROBABLE | - | 10x24 | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_icon_frames.tilemap` | tile-index map | 96 | 1D:4C51 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_icon_frames.attrmap` | attribute map | 96 | 1D:4CB1 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles0.2bpp` | 2bpp tiles | 400 | 1D:4D20 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles1.2bpp` | 2bpp tiles | 1024 | 1D:4EB0 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles2.2bpp` | 2bpp tiles | 1024 | 1D:52B0 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles3.2bpp` | 2bpp tiles | 1024 | 1D:56B0 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles4.2bpp` | 2bpp tiles | 896 | 1D:5AB0 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_tiles5.2bpp` | 2bpp tiles | 1024 | 1D:5E30 | CONFIRMED | exact | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_bg.pal` | RGB palette | 8 | 1D:6230 | CONFIRMED | - | - | `gfx/mail_menu/mail_menu.asm` |
| `palette_6238.pal` | RGB palette | 24 | 1D:6238 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `palette_6258.pal` | RGB palette | 24 | 1D:6258 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `mail_menu_obj.pal` | RGB palette | 8 | 1D:6270 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `palette_6280.pal` | RGB palette | 44 | 1D:6280 | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |
| `palette_62ac.pal` | RGB palette | 116 | 1D:62AC | PROBABLE | - | - | `gfx/mail_menu/mail_menu.asm` |

### `gfx/mail_server/delete_all_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_delete_all_tiles_54b0.2bpp` | 2bpp tiles | 1024 | 28:54B0 | PROBABLE | exact | - | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_tiles_58b0.2bpp` | 2bpp tiles | 672 | 28:58B0 | PROBABLE | exact | - | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_tiles_5b50.2bpp` | 2bpp tiles | 128 | 28:5B50 | PROBABLE | exact | - | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_tilemap.tilemap` | tile-index map | 360 | 28:5BD0 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_tilemap.attrmap` | attribute map | 360 | 28:5D38 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_bg_palette.pal` | RGB palette | 64 | 28:5EA0 | PROBABLE | - | - | `gfx/mail_server/delete_all_screen.asm` |
| `mail_server_delete_all_obj_palette.pal` | RGB palette | 64 | 28:5EE0 | PROBABLE | - | - | `gfx/mail_server/delete_all_screen.asm` |

### `gfx/mail_server/delete_menu_hidden/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_srv_del_hidden_button1.tilemap` | tile-index map | 360 | 22:5110 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |
| `mail_srv_del_hidden_button1.attrmap` | attribute map | 360 | 22:5278 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |
| `mail_srv_del_hidden_button0.tilemap` | tile-index map | 360 | 22:53E0 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |
| `mail_srv_del_hidden_button0.attrmap` | attribute map | 360 | 22:5548 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |
| `mail_srv_del_hidden_button2.tilemap` | tile-index map | 360 | 22:56B0 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |
| `mail_srv_del_hidden_button2.attrmap` | attribute map | 360 | 22:5818 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_menu_hidden.asm` |

### `gfx/mail_server/delete_method_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_delete_method_tiles_5f20.2bpp` | 2bpp tiles | 560 | 28:5F20 | PROBABLE | exact | - | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tiles_6150.2bpp` | 2bpp tiles | 1024 | 28:6150 | PROBABLE | exact | - | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tiles_6550.2bpp` | 2bpp tiles | 656 | 28:6550 | PROBABLE | exact | - | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tiles_67e0.2bpp` | 2bpp tiles | 128 | 28:67E0 | PROBABLE | exact | - | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tilemap_first.tilemap` | tile-index map | 360 | 28:6860 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tilemap_first.attrmap` | attribute map | 360 | 28:69C8 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tilemap_second.tilemap` | tile-index map | 360 | 28:6B30 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_tilemap_second.attrmap` | attribute map | 360 | 28:6C98 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_bg_palette.pal` | RGB palette | 64 | 28:6E00 | PROBABLE | - | - | `gfx/mail_server/delete_method_screen.asm` |
| `mail_server_delete_method_obj_palette.pal` | RGB palette | 64 | 28:6E40 | PROBABLE | - | - | `gfx/mail_server/delete_method_screen.asm` |

### `gfx/mail_server/delete_progress/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_srv_del_progress_tiles0.2bpp` | 2bpp tiles | 1024 | 23:6FE0 | PROBABLE | exact | - | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_tiles1.2bpp` | 2bpp tiles | 256 | 23:73E0 | PROBABLE | exact | - | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_tiles2.2bpp` | 2bpp tiles | 352 | 23:74E0 | PROBABLE | exact | - | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_screen.tilemap` | tile-index map | 360 | 23:7640 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_screen.attrmap` | attribute map | 360 | 23:77A8 | PROBABLE | - | 20x18 | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_bg.pal` | RGB palette | 64 | 23:7910 | PROBABLE | - | - | `gfx/mail_server/delete_progress.asm` |
| `mail_srv_del_progress_obj.pal` | RGB palette | 64 | 23:7950 | PROBABLE | - | - | `gfx/mail_server/delete_progress.asm` |

### `gfx/mail_server/tidy_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mail_server_mgr_tiles0.2bpp` | 2bpp tiles | 1024 | 2E:56E0 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_tiles1.2bpp` | 2bpp tiles | 16 | 2E:5AE0 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `tiles_5af0.2bpp` | 2bpp tiles | 1008 | 2E:5AF0 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_tiles2.2bpp` | 2bpp tiles | 288 | 2E:5EE0 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_tiles3.2bpp` | 2bpp tiles | 1024 | 2E:6000 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_tiles4.2bpp` | 2bpp tiles | 352 | 2E:6400 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_tiles5.2bpp` | 2bpp tiles | 1024 | 2E:6560 | CONFIRMED | exact | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_main.tilemap` | tile-index map | 360 | 2E:6960 | CONFIRMED | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_main.attrmap` | attribute map | 360 | 2E:6AC8 | CONFIRMED | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_footer.tilemap` | tile-index map | 120 | 2E:6C30 | PROBABLE | - | 20x6 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_footer.attrmap` | attribute map | 120 | 2E:6CA8 | PROBABLE | - | 20x6 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_b.tilemap` | tile-index map | 360 | 2E:6D20 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_b.attrmap` | attribute map | 360 | 2E:6E88 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_c.tilemap` | tile-index map | 360 | 2E:6FF0 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_c.attrmap` | attribute map | 360 | 2E:7158 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_d.tilemap` | tile-index map | 360 | 2E:72C0 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_info_d.attrmap` | attribute map | 360 | 2E:7428 | PROBABLE | - | 20x18 | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_bg.pal` | RGB palette | 48 | 2E:7590 | CONFIRMED | - | - | `gfx/mail_server/tidy_screen.asm` |
| `palette_75c0.pal` | RGB palette | 16 | 2E:75C0 | PROBABLE | - | - | `gfx/mail_server/tidy_screen.asm` |
| `mail_server_mgr_obj.pal` | RGB palette | 240 | 2E:75D0 | PROBABLE | - | - | `gfx/mail_server/tidy_screen.asm` |

### `gfx/mailbox/mailbox/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `mailbox_tiles_5a10.2bpp` | 2bpp tiles | 1024 | 25:5A10 | CONFIRMED | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tiles_5e10.2bpp` | 2bpp tiles | 256 | 25:5E10 | CONFIRMED | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tiles_5f10.2bpp` | 2bpp tiles | 1024 | 25:5F10 | PROBABLE | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tiles_6310.2bpp` | 2bpp tiles | 256 | 25:6310 | PROBABLE | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tilemap_normal.tilemap` | tile-index map | 360 | 25:6410 | CONFIRMED | - | 20x18 | `gfx/mailbox/mailbox.asm` |
| `mailbox_tilemap_normal.attrmap` | attribute map | 360 | 25:6578 | CONFIRMED | - | 20x18 | `gfx/mailbox/mailbox.asm` |
| `mailbox_tilemap_delete_select.tilemap` | tile-index map | 360 | 25:66E0 | PROBABLE | - | 20x18 | `gfx/mailbox/mailbox.asm` |
| `mailbox_tilemap_delete_select.attrmap` | attribute map | 360 | 25:6848 | PROBABLE | - | 20x18 | `gfx/mailbox/mailbox.asm` |
| `mailbox_bg_palette.pal` | RGB palette | 48 | 25:69B0 | CONFIRMED | - | - | `gfx/mailbox/mailbox.asm` |
| `palette_69e0.pal` | RGB palette | 16 | 25:69E0 | PROBABLE | - | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tiles_69f0.2bpp` | 2bpp tiles | 208 | 25:69F0 | PROBABLE | exact | - | `gfx/mailbox/mailbox.asm` |
| `tiles_6bd1.2bpp` | 2bpp tiles | 272 | 25:6BD1 | PROBABLE | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_tiles_6cf0.2bpp` | 2bpp tiles | 384 | 25:6CF0 | PROBABLE | exact | - | `gfx/mailbox/mailbox.asm` |
| `mailbox_obj_palette.pal` | RGB palette | 6 | 25:6EF0 | CONFIRMED | - | - | `gfx/mailbox/mailbox.asm` |
| `palette_6ef6.pal` | RGB palette | 56 | 25:6EF6 | PROBABLE | - | - | `gfx/mailbox/mailbox.asm` |

### `gfx/mailbox/objects/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `palette_7ac0.pal` | RGB palette | 64 | 26:7AC0 | PROBABLE | - | - | `gfx/mailbox/objects.asm` |

### `gfx/profile/profile_editor/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `profile_tiles9300.2bpp` | 2bpp tiles | 1024 | 2A:6300 | CONFIRMED | exact | - | `gfx/profile/profile_editor.asm` |
| `profile_tiles9700.2bpp` | 2bpp tiles | 256 | 2A:6700 | CONFIRMED | exact | - | `gfx/profile/profile_editor.asm` |
| `profile_tiles8800.2bpp` | 2bpp tiles | 832 | 2A:6800 | CONFIRMED | exact | - | `gfx/profile/profile_editor.asm` |
| `data_profile_tilemap_attr.tilemap` | tile-index map | 360 | 2A:6B40 | CONFIRMED | - | 20x18 | `gfx/profile/profile_editor.asm` |
| `data_profile_tilemap_attr.attrmap` | attribute map | 360 | 2A:6CA8 | CONFIRMED | - | 20x18 | `gfx/profile/profile_editor.asm` |
| `profile_bg.pal` | RGB palette | 64 | 2A:6E10 | PROBABLE | - | - | `gfx/profile/profile_editor.asm` |

### `gfx/registration/screen_bank4b/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_4000.tilemap` | tile-index map | 360 | 4B:4000 | CONFIRMED | - | 20x18 | `gfx/registration/screen_bank4b.asm` |
| `tilemap_4000.attrmap` | attribute map | 360 | 4B:4168 | CONFIRMED | - | 20x18 | `gfx/registration/screen_bank4b.asm` |

### `gfx/registration/screens_bank58/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 464 | 58:4000 | CONFIRMED | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_41d0.2bpp` | 2bpp tiles | 640 | 58:41D0 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_4450.2bpp` | 2bpp tiles | 640 | 58:4450 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_46d0.2bpp` | 2bpp tiles | 1920 | 58:46D0 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_4e50.2bpp` | 2bpp tiles | 1280 | 58:4E50 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_5350.2bpp` | 2bpp tiles | 1280 | 58:5350 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_5850.2bpp` | 2bpp tiles | 640 | 58:5850 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_5ad0.2bpp` | 2bpp tiles | 4720 | 58:5AD0 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_6d40.2bpp` | 2bpp tiles | 1824 | 58:6D40 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_7460.2bpp` | 2bpp tiles | 496 | 58:7460 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_7650.2bpp` | 2bpp tiles | 320 | 58:7650 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `tiles_7790.2bpp` | 2bpp tiles | 960 | 58:7790 | PROBABLE | exact | - | `gfx/registration/screens_bank58.asm` |
| `palette_7b50.pal` | RGB palette | 40 | 58:7B50 | PROBABLE | - | - | `gfx/registration/screens_bank58.asm` |
| `tilemap_7b78.tilemap` | tile-index map | 360 | 58:7B78 | CONFIRMED | - | 20x18 | `gfx/registration/screens_bank58.asm` |
| `tilemap_7b78.attrmap` | attribute map | 360 | 58:7CE0 | CONFIRMED | - | 20x18 | `gfx/registration/screens_bank58.asm` |

### `gfx/settings/screens_bank4a/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_5f80.2bpp` | 2bpp tiles | 256 | 4A:5F80 | CONFIRMED | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tiles_6080.2bpp` | 2bpp tiles | 1024 | 4A:6080 | CONFIRMED | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tiles_6480.2bpp` | 2bpp tiles | 1024 | 4A:6480 | CONFIRMED | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tiles_68d0.2bpp` | 2bpp tiles | 80 | 4A:68D0 | PROBABLE | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tiles_6920.2bpp` | 2bpp tiles | 1024 | 4A:6920 | PROBABLE | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tiles_6d20.2bpp` | 2bpp tiles | 1024 | 4A:6D20 | PROBABLE | exact | - | `gfx/settings/screens_bank4a.asm` |
| `tilemap_7120.tilemap` | tile-index map | 100 | 4A:7120 | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |
| `tilemap_7120.attrmap` | attribute map | 100 | 4A:7184 | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |
| `tilemap_71e8.tilemap` | tile-index map | 100 | 4A:71E8 | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |
| `tilemap_71e8.attrmap` | attribute map | 100 | 4A:724C | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |
| `tilemap_72b0.tilemap` | tile-index map | 100 | 4A:72B0 | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |
| `tilemap_72b0.attrmap` | attribute map | 100 | 4A:7314 | PROBABLE | - | 20x5 | `gfx/settings/screens_bank4a.asm` |

### `gfx/settings/screens_bank4b/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_5b90.2bpp` | 2bpp tiles | 2560 | 4B:5B90 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |
| `tiles_6a90.2bpp` | 2bpp tiles | 1024 | 4B:6A90 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |
| `tiles_6e90.2bpp` | 2bpp tiles | 544 | 4B:6E90 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |
| `tiles_70b0.2bpp` | 2bpp tiles | 992 | 4B:70B0 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |
| `tiles_76d0.2bpp` | 2bpp tiles | 1024 | 4B:76D0 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |
| `tiles_7ad0.2bpp` | 2bpp tiles | 768 | 4B:7AD0 | PROBABLE | exact | - | `gfx/settings/screens_bank4b.asm` |

### `gfx/settings/screens_bank4d/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 512 | 4D:4000 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_4200.2bpp` | 2bpp tiles | 784 | 4D:4200 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_4510.2bpp` | 2bpp tiles | 256 | 4D:4510 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_4610.2bpp` | 2bpp tiles | 1024 | 4D:4610 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_4a10.2bpp` | 2bpp tiles | 768 | 4D:4A10 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_4d10.2bpp` | 2bpp tiles | 768 | 4D:4D10 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_5010.2bpp` | 2bpp tiles | 256 | 4D:5010 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_5110.2bpp` | 2bpp tiles | 1024 | 4D:5110 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_5510.2bpp` | 2bpp tiles | 768 | 4D:5510 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5810.tilemap` | tile-index map | 360 | 4D:5810 | PROBABLE | - | 20x18 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5810.attrmap` | attribute map | 360 | 4D:5978 | PROBABLE | - | 20x18 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5ae0.tilemap` | tile-index map | 70 | 4D:5AE0 | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5ae0.attrmap` | attribute map | 70 | 4D:5B26 | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5b6c.tilemap` | tile-index map | 70 | 4D:5B6C | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5b6c.attrmap` | attribute map | 70 | 4D:5BB2 | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5bf8.tilemap` | tile-index map | 70 | 4D:5BF8 | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5bf8.attrmap` | attribute map | 70 | 4D:5C3E | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5c84.tilemap` | tile-index map | 70 | 4D:5C84 | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_5c84.attrmap` | attribute map | 70 | 4D:5CCA | PROBABLE | - | 14x5 | `gfx/settings/screens_bank4d.asm` |
| `tiles_5d50.2bpp` | 2bpp tiles | 32 | 4D:5D50 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_5d70.2bpp` | 2bpp tiles | 1024 | 4D:5D70 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_6170.2bpp` | 2bpp tiles | 1024 | 4D:6170 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_6570.2bpp` | 2bpp tiles | 768 | 4D:6570 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_6870.2bpp` | 2bpp tiles | 1024 | 4D:6870 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_6c70.2bpp` | 2bpp tiles | 256 | 4D:6C70 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_6d70.2bpp` | 2bpp tiles | 1024 | 4D:6D70 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_7170.2bpp` | 2bpp tiles | 768 | 4D:7170 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tiles_7470.2bpp` | 2bpp tiles | 1024 | 4D:7470 | PROBABLE | exact | - | `gfx/settings/screens_bank4d.asm` |
| `tilemap_7870.tilemap` | tile-index map | 40 | 4D:7870 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_7870.attrmap` | attribute map | 40 | 4D:7898 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_78c0.tilemap` | tile-index map | 40 | 4D:78C0 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_78c0.attrmap` | attribute map | 40 | 4D:78E8 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_7910.tilemap` | tile-index map | 40 | 4D:7910 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |
| `tilemap_7910.attrmap` | attribute map | 40 | 4D:7938 | PROBABLE | - | 20x2 | `gfx/settings/screens_bank4d.asm` |

### `gfx/settings/screens_bank5d/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_7360.2bpp` | 2bpp tiles | 1024 | 5D:7360 | CONFIRMED | exact | - | `gfx/settings/screens_bank5d.asm` |
| `tiles_7760.2bpp` | 2bpp tiles | 1024 | 5D:7760 | CONFIRMED | exact | - | `gfx/settings/screens_bank5d.asm` |
| `tilemap_7ba0.tilemap` | tile-index map | 360 | 5D:7BA0 | CONFIRMED | - | 20x18 | `gfx/settings/screens_bank5d.asm` |
| `tilemap_7ba0.attrmap` | attribute map | 360 | 5D:7D08 | CONFIRMED | - | 20x18 | `gfx/settings/screens_bank5d.asm` |

### `gfx/settings/screens_bank5e/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_4000.2bpp` | 2bpp tiles | 1024 | 5E:4000 | PROBABLE | exact | - | `gfx/settings/screens_bank5e.asm` |
| `tiles_4400.2bpp` | 2bpp tiles | 1024 | 5E:4400 | PROBABLE | exact | - | `gfx/settings/screens_bank5e.asm` |

### `gfx/settings/screens_bank71/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_6f6f.tilemap` | tile-index map | 360 | 71:6F6F | PROBABLE | - | 20x18 | `gfx/settings/screens_bank71.asm` |
| `tilemap_6f6f.attrmap` | attribute map | 360 | 71:70D7 | PROBABLE | - | 20x18 | `gfx/settings/screens_bank71.asm` |

### `gfx/title/logo/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `title_logo_tiles0.2bpp` | 2bpp tiles | 1024 | 0E:60A0 | CONFIRMED | exact | - | `gfx/title/logo.asm` |
| `title_logo_tiles1.2bpp` | 2bpp tiles | 1024 | 0E:64A0 | CONFIRMED | exact | - | `gfx/title/logo.asm` |
| `title_logo_screen.tilemap` | tile-index map | 360 | 0E:68A0 | CONFIRMED | - | 20x18 | `gfx/title/logo.asm` |
| `title_logo_screen.attrmap` | attribute map | 360 | 0E:6A08 | CONFIRMED | - | 20x18 | `gfx/title/logo.asm` |
| `title_logo.pal` | RGB palette | 64 | 0E:6B70 | PROBABLE | - | - | `gfx/title/logo.asm` |

### `gfx/title/title_screen/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `title_tiles0.2bpp` | 2bpp tiles | 1024 | 0E:43C0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles1.2bpp` | 2bpp tiles | 1024 | 0E:47C0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles2.2bpp` | 2bpp tiles | 512 | 0E:4BC0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles3.2bpp` | 2bpp tiles | 512 | 0E:4DC0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles4.2bpp` | 2bpp tiles | 1024 | 0E:4FC0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles5.2bpp` | 2bpp tiles | 1024 | 0E:53C0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_tiles6.2bpp` | 2bpp tiles | 1024 | 0E:57C0 | CONFIRMED | exact | - | `gfx/title/title_screen.asm` |
| `title_screen.tilemap` | tile-index map | 360 | 0E:5BC0 | CONFIRMED | - | 20x18 | `gfx/title/title_screen.asm` |
| `title_screen.attrmap` | attribute map | 360 | 0E:5D28 | CONFIRMED | - | 20x18 | `gfx/title/title_screen.asm` |
| `title_highlight_start.tilemap` | tile-index map | 40 | 0E:5E90 | PROBABLE | - | - | `gfx/title/title_screen.asm` |
| `title_highlight_start.attrmap` | attribute map | 40 | 0E:5EB8 | PROBABLE | - | - | `gfx/title/title_screen.asm` |
| `title_highlight_settings.tilemap` | tile-index map | 40 | 0E:5EE0 | PROBABLE | - | - | `gfx/title/title_screen.asm` |
| `title_highlight_settings.attrmap` | attribute map | 40 | 0E:5F08 | PROBABLE | - | - | `gfx/title/title_screen.asm` |
| `title_bg.pal` | RGB palette | 64 | 0E:5F30 | PROBABLE | - | - | `gfx/title/title_screen.asm` |
| `title_obj.pal` | RGB palette | 64 | 0E:5F70 | PROBABLE | - | - | `gfx/title/title_screen.asm` |

### `gfx/top_menu/top_menu/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tilemap_40d7.tilemap` | tile-index map | 320 | 1E:40D7 | CONFIRMED | - | 20x16 | `gfx/top_menu/top_menu.asm` |
| `tilemap_40d7.attrmap` | attribute map | 320 | 1E:4217 | CONFIRMED | - | 20x16 | `gfx/top_menu/top_menu.asm` |
| `tilemap_48c1.tilemap` | tile-index map | 108 | 1E:48C1 | CONFIRMED | - | 12x9 | `gfx/top_menu/top_menu.asm` |
| `tilemap_48c1.attrmap` | attribute map | 108 | 1E:492D | CONFIRMED | - | 12x9 | `gfx/top_menu/top_menu.asm` |
| `tiles_49a0.2bpp` | 2bpp tiles | 1024 | 1E:49A0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_4da0.2bpp` | 2bpp tiles | 1024 | 1E:4DA0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_51a0.2bpp` | 2bpp tiles | 1024 | 1E:51A0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_55a0.2bpp` | 2bpp tiles | 1024 | 1E:55A0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_59a0.2bpp` | 2bpp tiles | 512 | 1E:59A0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_5ba0.2bpp` | 2bpp tiles | 1024 | 1E:5BA0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `tiles_5fa0.2bpp` | 2bpp tiles | 768 | 1E:5FA0 | CONFIRMED | exact | - | `gfx/top_menu/top_menu.asm` |
| `palette_62a0.pal` | RGB palette | 64 | 1E:62A0 | PROBABLE | - | - | `gfx/top_menu/top_menu.asm` |
| `palette_62e0.pal` | RGB palette | 64 | 1E:62E0 | PROBABLE | - | - | `gfx/top_menu/top_menu.asm` |

### `gfx/unreferenced/page_list_prototype/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_62b0.2bpp` | 2bpp tiles | 1024 | 7F:62B0 | PROBABLE | exact | - | `gfx/unreferenced/page_list_prototype.asm` |
| `tiles_66b0.2bpp` | 2bpp tiles | 288 | 7F:66B0 | PROBABLE | exact | - | `gfx/unreferenced/page_list_prototype.asm` |
| `tilemap_67d0.tilemap` | tile-index map | 360 | 7F:67D0 | PROBABLE | - | 20x18 | `gfx/unreferenced/page_list_prototype.asm` |
| `tilemap_67d0.attrmap` | attribute map | 360 | 7F:6938 | PROBABLE | - | 20x18 | `gfx/unreferenced/page_list_prototype.asm` |
| `palette_6aa0.pal` | RGB palette | 64 | 7F:6AA0 | PROBABLE | - | - | `gfx/unreferenced/page_list_prototype.asm` |
| `tiles_6ae0.2bpp` | 2bpp tiles | 656 | 7F:6AE0 | PROBABLE | exact | - | `gfx/unreferenced/page_list_prototype.asm` |
| `palette_6d70.pal` | RGB palette | 64 | 7F:6D70 | PROBABLE | - | - | `gfx/unreferenced/page_list_prototype.asm` |

### `gfx/unreferenced/page_list_prototype_objects/`

| asset | kind | bytes | bank:addr | status | png | dims | source |
|---|---|---:|---|---|---|---|---|
| `tiles_7830.2bpp` | 2bpp tiles | 720 | 7F:7830 | PROBABLE | exact | - | `gfx/unreferenced/page_list_prototype_objects.asm` |
| `palette_7b00.pal` | RGB palette | 64 | 7F:7B00 | PROBABLE | - | - | `gfx/unreferenced/page_list_prototype_objects.asm` |

## Editing images

PNG is the editable source of the graphics: `make` rebuilds the binary that the `.asm` INCBINs from its PNG (short form: `docs/EDITING_IMAGES.md`).
(Font sheets and screen PNGs, described here, supersede the "view-only PNG" wording above: the font rows marked `view` in the tables are now editable
`name.png` sheets; only `sjis_valid_bitmap_view.png` is still a picture.)

### Workflow

```
edit the PNG (indexed mode, same size, same palette)   ->   make   ->   mobile_trainer.gbc has the new image
make png-check        every editable PNG checked, errors explained in plain words
make png-bins         rebuild only the graphics binaries (no ROM)
make png-export       (maintainers) PNGs regenerated from the binaries; never over a PNG with edits not built yet (FORCE=1 overrides)
```

* `make` runs `rgbgfx` (tile sheets) and `tools/font_png.py` (font sheets) for every PNG newer than its binary, checks that the result has exactly
  the size of the binary (the ROM layout is pinned by `layout.link`), then assembles and links.  The rules are generated from `gfx/png_rules.tsv`
  into `gfx/png.mk` (one line per binary: PNG, kind, rgbgfx padding, glyph counts, size, hash in the original state; `python3 tools/png_rules.py rules`).
  A fresh git checkout has arbitrary file times, so the rules may rebuild every binary; they are deterministic and reproduce the committed bytes
  (an unedited checkout still prints `SHA-256 OK`).  Without `rgbgfx` or `python3` the rules are skipped and the committed binaries are used.
* With edited graphics the ROM is meant to differ from the original: `make` then prints `EDITED GRAPHICS` and the list of changed files instead of
  `SHA-256 MISMATCH` (a difference that no edited graphics file explains is still a mismatch).  `python3 tools/compare_rom.py "Mobile Trainer (Japan).gbc" mobile_trainer.gbc`
  shows the changed bytes (an edit to one tile changes only that tile's 16 bytes, at that tile's offset in its `.2bpp`).
* **Constraints**: do not resize or crop an image; do not add or remove tiles or glyphs (every binary keeps its size); save as indexed PNG and keep the
  palette / its order (the tile sheets use the palette position as the colour number); draw with hard pixels (no anti-aliasing).

### Which assets are editable PNGs

| kind | PNG source | files | notes |
|---|---|---:|---|
| 2bpp tile blocks | `name.png` (exact `rgbgfx` source of `name.2bpp`) | 409 | 100% of the `.2bpp` files; shades 0-3 are grey indices, not the game's colours (the game colours come from palettes and tile attributes; see screens) |
| JIS 12x12 glyphs (10 binaries) | `data/fonts/jis12x12_rows_*.png`, 94 glyphs per sheet row | 9 sheets | bank 7C's two binaries share one sheet |
| 8x16 font runs | `data/fonts/font_8x16_*.png`, 16 glyphs per row | 27 sheets | |
| 6x12 Latin font | `data/fonts/ascii_6x12.png` | 1 sheet | 6 pixel wide cells (the two unused bits of each byte stay 0) |
| whole screens | `name.screen.png` next to `name.tilemap` (`gfx/screens.tsv`) | 83 | edit view: tilemap + attribute map + tiles + palettes composed in real colours; import writes the edit into the tile sheets, see below |
| palettes | `name.pal` (text, `RGB r, g, b`) | 133 | already an editable text form; a screen PNG can write colours back (`screen_png.py import --palette`). No separate swatch PNG |

Not PNG-editable (binary only): the 169 `.tilemap` and 169 `.attrmap` files (the layout of a screen: which tile in which cell, flips, palette
numbers), the Shift-JIS validity bitmap (data, not an image; `sjis_valid_bitmap_view.png` is a picture of it), and the graphics blocks that are still `db`
in the `.asm` (see "Still `db`" above).  The 86 tilemaps without a screen PNG are unlisted because their screen cannot be composed from the code: 38 are
loaded through a pointer / table or as sub-rectangles (no immediate address at the call), 37 have a loader call whose routine loads too few of their tiles
(tiles arrive by another routine), 11 belong to the bank 41-46 scene records whose layout assumption resolves less than half of the cells.  Their tiles are
still editable through the tile sheets.

### Font sheets (`tools/font_png.py`)

Indexed PNG, 4 colours: white = paper, black = ink (draw only pure black / white inside glyph cells), light grey = the 1 px grid between cells, pink = a pixel
whose byte is not stored in this file (only around the two glyphs cut by the gap of bank 7C; ignored).  Sheet cell = glyph + 1 px grid line; sheet row r of a
JIS sheet is glyph-slot row r of the bank (JIS rows: 7E 1-8 and 13, 7D 16-24, 7C 25-33, 7B 34-42, 7A 43-51, 79 52-60, 78 61-69, 77 70-78, 76 79-84), column c is
JIS column c+1.  The packing (12x12: two 12-bit rows in 3 bytes; 8x16 / 6x12: one byte per row, MSB left) is in the docstring of `tools/font_png.py` and in
`docs/research/text_encoding.md`; `check` proves for every sheet that the pixels decode to exactly the binary bytes.

### Screen PNGs (`tools/screen_png.py`, `gfx/screens.tsv`)

A screen = a tilemap + attribute map and the tile blocks and palettes that the *same loader routine* puts into VRAM (found statically from the far calls
to the HDMA, tilemap-copy and palette-buffer routines; `evidence` column).  The tile-number addressing mode (LCDC bit 4) is chosen by which mode resolves
more cells.  Status: PROBABLE = every cell resolves and the mode does not matter or is decided by coverage (18 screens); HYPOTHESIS = part of the cells
resolve (the rest are drawn pink) or the mode is a tie or the screen is one of the bank 41-46 scene records (layout-only assumption: tile k = record tile k,
VRAM bank 1) (65 screens).  Visual check (2 x zoom contact sheet, title, mail menu, top menu, logo, keyboard, scenery screens): the composed images read as the
real screens.  `export` writes the PNGs, `import` reads them back:

```
python3 tools/screen_png.py export [NAME]                       # from the current tile sheets and palettes (only needed when stale)
python3 tools/screen_png.py import [--dry-run] [--palette] [NAME]   # screen PNG -> edits of the TILE SHEET PNGs (+ .pal files with --palette)
python3 tools/screen_png.py check                                # render -> import must be the identity (make png-check runs it)
```

Pixel value = `4 * palette + shade` (palette = the cell's attribute bits 0-2, shade 0-3), PLTE = the eight palettes of the screen in their real colours (greys
tinted per palette where the palette load is not known: 25 screens), entry 32 (pink) = a cell whose tile the routine does not load.  Import **keeps the
tilemap and attribute map**: each cell is written back into the tile it shows (flips undone), and the result lands in the tile sheet PNG (the source), then
`make`.  Errors in plain words: a cell may use only the colours of its own palette; a tile shown by several cells must look the same in all of them (editing
one of them alone is refused, because the tilemap cannot give it another tile); other screens showing an edited tile change too (import lists them).  Re-laying out
a screen needs the tilemap / attribute bytes, which stay binary.  The unedited screen PNG imports to "no change" for every screen, and the tile bytes
reached through every cell are exactly the `.2bpp` bytes (proved by `make png-check`).

### Tools

`tools/png_rules.py` (rules manifest / png.mk / export / edited-asset detection), `tools/png_check.py` (guard rails), `tools/font_png.py`, `tools/screen_png.py`,
`tools/pnglib.py` (PNG reader for 1-16 bit indexed / gray / RGB files, writer), `tools/gfx_export.py` (asset extraction and manifest, unchanged role),
`tools/test_png.py` (tests, run by `make test`).
