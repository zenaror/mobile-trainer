# Address-book graphics resource paths

Bank 29 owner `gfx/address_book/entry_screen_bank29.asm` defines four resources:

| Original range | Current path stem |
| --- | --- |
| `29:5B10–5E10` | `abook_edit_tiles8000` |
| `29:5E10–5E50` | `abook_edit_obj_palette` |
| `29:5E50–6250` | `abook_view_tiles9300_vb1` |
| `29:6250–6290` | `abook_view_tiles9700_vb1` |

Bank 28 owner `gfx/address_book/shared_tiles_bank28.asm` defines two shared
tile resources and one list palette:

| Original range | Current path stem |
| --- | --- |
| `28:4BD0–4FD0` | `addr_book_shared_tiles8000` |
| `28:4FD0–51D0` | `addr_book_shared_tiles8400` |
| `28:51D0–5210` | `abook_list_bg_palette` |

The destination and consumer checks use the maintained setup routines and the
static transfer records in `gfx/previews/screen_ops.tsv`. They support the
resource paths, not claims about hardware behavior untraced screens. The
four Bank 29 tile extents have executed ROM reads recorded in the source
headers. The path names keep owner semantics and transfer destinations while
leaving unknown tile content unclassified.
