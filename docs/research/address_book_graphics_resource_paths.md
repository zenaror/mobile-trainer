# Address-book graphics resource paths

This 2026-10-22 path pass replaces address-only filenames for seven resources in
Banks 28 and 29. It changes file paths and references only; source labels,
section extents, layouts, confidence values and asset payloads are unchanged.
The direct historical-to-current paths are recorded in
[`gfx_resource_path_map.tsv`](gfx_resource_path_map.tsv).

## Evidence and names

Bank 29 owner `gfx/address_book/entry_screen_bank29.asm` defines four resources:

| Original range | Current path stem | Evidence |
|---|---|---|
| `29:5B10–5E10` | `abook_edit_tiles8000` | 768 bytes loaded to VRAM `$8000`, bank 0, by `AbookAddr_SetupScreen` and `AbookName_SetupScreen`; owner label is `Gfx_AbookEdit_Tiles8000`. |
| `29:5E10–5E50` | `abook_edit_obj_palette` | 64-byte OBJ palette loaded to `$D840` by those two setup routines; owner label is `Palette_AbookEdit_Obj`. |
| `29:5E50–6250` | `abook_view_tiles9300_vb1` | 1,024 bytes loaded to VRAM `$9300`, bank 1, by `AbookView_SetupScreen`; owner label is `Gfx_AbookView_Tiles9300Vb1`. |
| `29:6250–6290` | `abook_view_tiles9700_vb1` | 64 bytes loaded to VRAM `$9700`, bank 1, by `AbookView_SetupScreen`; owner label is `Gfx_AbookView_Tiles9700Vb1`. |

Bank 28 owner `gfx/address_book/shared_tiles_bank28.asm` defines two shared
tile resources and one list palette:

| Original range | Current path stem | Evidence |
|---|---|---|
| `28:4BD0–4FD0` | `addr_book_shared_tiles8000` | 1,024 bytes loaded to VRAM `$8000`, bank 0, by the list, address picker and save-sender setup routines. |
| `28:4FD0–51D0` | `addr_book_shared_tiles8400` | 512 bytes loaded to VRAM `$8400`, bank 0, by the same three routines. |
| `28:51D0–5210` | `abook_list_bg_palette` | 64-byte BG palette loaded to `$D800` by `AbookList_SetupScreen`; this owner label's list-specific scope is retained. Its RGB555 structure and bytes are confirmed; a wider palette role is not claimed. |

The destination and consumer checks use the maintained setup routines and the
static transfer records in `gfx/previews/screen_ops.tsv`. They support the
resource paths, not claims about hardware behavior or untraced screens. The
four Bank 29 tile extents have executed ROM reads recorded in the source
headers. The path names keep owner semantics and transfer destinations while
leaving unknown tile content unclassified.

All 12 renamed files (seven binary assets and five PNGs) retain their original
SHA-256 hashes. The `.pal` files are text-encoded RGB555 and were also renamed
without changing their contents. `make` and the graphics checks verify the
rebuilt ROM and the editable PNG-to-binary relationships.
