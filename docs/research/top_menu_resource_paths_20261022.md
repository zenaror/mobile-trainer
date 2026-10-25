# Top Menu graphics path migration

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

The English translation tree remains paused and was not accessed or edited.
Whether it shares these old paths is UNKNOWN; reconcile it only after explicit
authorization to resume that work.
