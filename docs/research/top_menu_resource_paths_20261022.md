# Top Menu graphics path migration (2026-10-22)

The address-only basenames under `gfx/top_menu/top_menu/` now describe the
static role already established by the maintained owner and consumers. Seven
tile sources are named for their confirmed VRAM bank and destination; two maps
are named for their confirmed dimensions; the palette paths reflect the
existing `Palette_TopMenu_Bg` / `Palette_TopMenu_Obj` labels, while their
role classification remains PROBABLE. The screen preview is named for its
20×16 source map, without asserting the HYPOTHESIS signed-index rendering.

The transfer calls in `engine/menus/top_menu.asm` select seven source labels
and destinations: VBK0 `$8000`, `$8400`, `$8800`, `$8C00`, `$9000`, then VBK1
`$9000` and `$9400`. The owner `gfx/top_menu/top_menu.asm` bounds these payloads
and names them `Gfx_TopMenu_Tiles*`; `gfx/assets.tsv` records the map extents
as 20×16 and 12×9. The palette source labels and confidence remain
unchanged. These are static source/loader conclusions, not a runtime claim.

Renamed 21 paths (seven `.2bpp`/PNG pairs, two tilemap/attribute pairs, two
palettes and one screen preview). Every renamed file matches its old Git blob
byte-for-byte. Owner references, asset catalogue, screen metadata, generated
PNG rules/Makefile and generated GFX README were updated. The historical path
map gained 21 direct mappings. No bank layout, symbol, source bytes, image
pixels or ROM bytes changed.

The English translation tree remains paused and was not accessed or edited.
Whether it shares these old paths is UNKNOWN; reconcile it only after explicit
authorization to resume that work.

Validation at Japanese main before this documentation append:

- `make`: SHA-256 OK; rebuilt ROM `RESULT: IDENTICAL` to the 2,097,152-byte
  original (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
- `make sym-check`: 335 source files, 12,177 labels, 51 constants; OK.
- `make palette-check`: 162 loads / 116 arrays, two documented over-reads,
  zero errors.
- `make png-check`: 408 tile sheets, four raw views, 37 font sheets and 95
  screen PNGs; OK.
- `python3 tools/gfx_export.py check` and `python3 tools/png_rules.py mk-check`:
  OK.
- `git diff --check`: OK.

Independent read-only review in a separate private copy passed all six criteria:
static transfer destinations, map dimensions, palette naming/confidence,
21-file hashes, catalogue agreement/stale operational references, and semantic
claim limits. The reviewer did not access the English tree or rerun build gates.
