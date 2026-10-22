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
| tile blocks (2bpp art: screens, text baked into tiles, buttons, logos) | `gfx/**/name.png` next to `name.2bpp` | exact `rgbgfx` source: 4 greys in a fixed order (index 0 white ... 3 black); 16 tiles per row (8-15 when 16 does not divide the count; the last row padded, padding tiles are ignored) | 409 |
| explicit RAW byte views | `gfx/frame_designs/metal_flame_and_creature_borders_42/raw_*.png` | reversible raw2bpp byte codec; purpose UNKNOWN/HYPOTHESIS, not a tile classification | 4 files /80B |
| JIS 12x12 font banks, 8x16 font runs, 6x12 Latin font | `data/fonts/name.png` or `data/fonts/glyph_runs_8x16/sjis_key.png` next to its binary | glyph sheet, see section 4; `tools/font_png.py` | 37 sheets (39 binaries) |
| whole screens (tilemap + attributes + tiles + palettes composed, in real colours) | `gfx/**/name.screen.png` next to `name.tilemap` | see section 3; an *editing view*: import writes the edit back into the tile sheets | 95 screens |
| palettes | `gfx/**/name.pal` | text, one `RGB r, g, b` line per colour (0-31 per channel), four colours per palette; hand-editable; screen PNGs can write colours back (`--palette`) | 167 files |

Stay binary: `.tilemap` / `.attrmap` (which tile sits in which cell, flips, palette numbers; 180 + 180 files; the layout of a screen is fixed, see
section 3 for what you can change), the Shift-JIS validity bitmap (`data/fonts/sjis_valid_bitmap.bin`, data rather than an image; a view-only picture
`sjis_valid_bitmap_view.png` exists), and every graphics block that is still `db` in the `.asm` (sprite frame tables, animation scripts, unclassified data).

## 3. Screens

`gfx/screens.tsv` lists the 95 current screens whose composition could be derived (the tile blocks, palettes and VRAM addressing come from the loader routine
of the screen or an explicit layout hypothesis, `evidence` column; 20 PROBABLE screens have every cell resolved,
and 75 HYPOTHESIS screens are partly resolved, ambiguous in addressing, or layout-only).  The other 85 tilemaps
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
`Makefile`.  Without `rgbgfx` or `python3` the rules are skipped and the committed binaries are used.  Tests: `python3 tools/test_png.py`.

## 6. Bank42 fragmented conditional composition (historical93-row stage)

The additional `frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tilemap` catalogue entry combines four existing tile sheets: 27 tiles at42:4D50,60 at42:4F00,2 at42:52C0 and71 at42:52E0. Its editing-view path is `gfx/frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tilemap.screen.png`. The composition uses unsigned tile numbers, VRAM bank1 and the first32 words of `palette_5a20.pal`; all360 map cells resolve under those assumptions. Its status remains HYPOTHESIS: this layout supplies no original loader, LCDC.bit4 or species/name association.

This entry updates the earlier catalogue counts to93 rows:20 PROBABLE and73 HYPOTHESIS. All92 earlier rows and their PNGs are retained. It addresses one of the eleven bank41–46 omissions described above; ten remain, and87 of the180 tilemaps still have no catalogue entry. Import uses the existing four sheets and preserves the map, attributes and physical asset sizes. The last sheet contains71 physical tiles; its nine padding tiles cannot become source tiles. Export or import only this view with `python3 tools/screen_png.py export frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tilemap` or `python3 tools/screen_png.py import --dry-run --palette frame_designs/metal_flame_and_creature_borders_42/flame_jagged_border_42_4d50_tilemap`.

## 7. Current original-asset catalogue

The current catalogue has979 assets/622434 logical ROM bytes and978 active PNG rules. Its11 JIS12x12 binaries total131976B; all font formats together have39 binaries in37 sheets. The409 tile-sheet PNGs,4 RAW byte-view PNGs (80B) and37 font sheets are450 unique editable source PNG paths. The validity bitmap is a separate view-only picture. The RAW files preserve HYPOTHESIS/UNKNOWN purpose and use an explicit reversible byte codec; a byte-view is not a new tile classification.

The current95 screen rows are20 PROBABLE and75 HYPOTHESIS;85 of180 tilemaps have no screen row. The preceding92/93 counts describe earlier stages, not current omissions. Among the25 finite candidate physical windows,17 editing compositions and24 legacy previews exist: every window has some existing PNG representation. Eight editing views remain KEEP; this is not missing ROM art or proof of natural loading. The completed bank7C sheet shares three contiguous spans6083+10+9135B without a new PNG path. No species/name-to-image association or ALL asset-completeness claim follows.


### AdapterCheck object-data legacy view (2026-10-18)

`gfx/settings/screens_bank4a/tiles_68d0.2bpp` and its unchanged40x8PNG are retained as legacy evidence, outside the active asset/rule catalogue. They no longer feed4A:68D0 through INCBIN: edit the PROBABLE object table/frame list/frames/script in ASM/macros instead. The final11zero bytes have UNKNOWN purpose; neither tile art nor unused/padding follows from their old byte view. Paths/hashes and the original80B layout are recorded in [the typing/provenance note](research/adapter_check_object_data_80b.md). Removing one false active tile interpretation changes catalogue counters, not the ROM bytes or the number of preserved physical files.


### Localização dos legados AdapterCheck após a migração 4A (2026-10-18)

Os arquivos legados atuais são `gfx/settings/adapter_check_and_phone_entry_bank4a/legacy_byteviews/adapter_check_object_data_4a_68d0.2bpp` (80 B) e `gfx/settings/adapter_check_and_phone_entry_bank4a/legacy_byteviews/adapter_check_object_data_4a_68d0.png` (PNG 40×8, 184 B). Os bytes, pixels e hashes são os mesmos dos caminhos históricos `gfx/settings/screens_bank4a/tiles_68d0.2bpp` e `gfx/settings/screens_bank4a/tiles_68d0.png`. Eles ficam fora do catálogo e das regras ativas; a região PROBABLE em 4A:68D0 é editada em ASM/macros, e seus 11 zeros finais continuam UNKNOWN. O parágrafo datado anterior registra a localização no passe de tipagem, antes desta migração. O mapa [antigo→atual](research/gfx_resource_path_map.tsv) preserva essa proveniência; consulte [a unidade de caminhos](research/adapter_check_and_phone_entry_4a_resource_paths.md). Para os 15 componentes ativos, edite os PNGs/paletas/mapas da nova coleção; nenhum PNG novo é criado.

O byte-view `gfx/account/settings_menu_and_manual_confirm_bank4a/tiles_5860.2bpp` (16 B, SHA-256 `68801625e95363bd79c1370472e8ccad7f9b93e2e929930f78610232787fbd91`) e sua visualização PNG (SHA-256 `5680705a91e0e2fb90a25f993d78cf21be4cda9ef69dee7d95492cb10c716716`) continuam nos caminhos originais, mas fora do catálogo/regras ativas. A faixa foi reclassificada em `gfx/account/settings_menu_and_manual_confirm_bank4a.asm`: dois frames, script e cinco zeros. Use as macros ASM para editar a estrutura; a posição do antigo byte-view não implica pixels usados pelo jogo.

## 8. HelpScript picture objects

The26 table-backed HelpScript pictures use12×6-tile (96×48-pixel) editable grayscale PNGs, each backed by1152 bytes and an individual four-colour `.pal`. Their IDs and original-bank bounds come from the static picture table, not a natural-display claim. See [the resource contracts and range migration](research/help_script_picture_assets.md). Do not crop, resize or add tiles.
