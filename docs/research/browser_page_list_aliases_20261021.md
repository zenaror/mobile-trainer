# Redundant aliases in the browser page-list graphics

At the `3c08da02be1abccfb820a223a97552fece335c56` checkpoint, an independent
review examined the 813-line owner `gfx/browser/page_list.asm`. The 14 generic
`Tiles_24_*`, `Palette_24_*`, and `Table_24_*` labels below were exact-address
aliases for existing `PageList_*` labels. Each old token appeared only in its
declaration among the 347 maintained ASM/INC files and 142 tools; no local
label depended on any alias. The patch removes declaration lines only.

| Address | Retired label | Retained label |
|---|---|---|
| `24:5400` | `Tiles_24_5400` | `PageList_Tiles_5400` |
| `24:5EA0` | `Palette_24_5EA0` | `PageList_BgPalette` |
| `24:5EE0` | `Tiles_24_5EE0` | `PageList_Tiles_5EE0` |
| `24:64E0` | `Palette_24_64E0` | `PageList_ObjPalette` |
| `24:6530` | `Table_24_6530` | `PageList_ObjTable` |
| `24:65C0` | `Table_24_65C0` | `PageList_Anim0Frames` |
| `24:6686` | `Table_24_6686` | `PageList_Anim8Frames` |
| `24:6698` | `Table_24_6698` | `PageList_Anim4Frames` |
| `24:675E` | `Table_24_675E` | `PageList_Anim12Frames` |
| `24:6770` | `Table_24_6770` | `PageList_Anim28Frames` |
| `24:686D` | `Table_24_686D` | `PageList_Anim32Frames` |
| `24:6B19` | `Table_24_6B19` | `PageList_Anim16Frames` |
| `24:6B5C` | `Table_24_6B5C` | `PageList_Anim20Frames` |
| `24:6B9F` | `Table_24_6B9F` | `PageList_Anim24Frames` |

The pre-edit owner SHA-256 was
`ecf0dae1439d2fee3e865a0d6cda56c200a85e1b7567cad8d5c4e30275cd5a39`; the
current source-set manifest was
`54ab3ef0ad73828b47a1219b76af49bdc9ea0492da217d4da389fb14981e5dc4`. The
review also checked the current SYM snapshot, aliases' semantic counterparts,
local-label spellings, palette includes, and graphics macros. Its full receipt
is `.tmp/generic-coalias-post-3c08da02-20261021/REVIEW_BROWSER_PAGE_LIST.md`.

The static review does not assert natural reachability or asset semantics
beyond the existing labels. Coordinator build, symbol, palette, and PNG gates
are recorded with this checkpoint after the edit.
