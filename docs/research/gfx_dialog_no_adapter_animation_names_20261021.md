# Dialog cursor and no-adapter animation names (2026-10-21)

This bounded naming change replaces eight generic sprite labels in two GFX
owners. It changes no bytes, animation structure, confidence annotation, asset
path, or claim about rendered appearance or natural runtime reachability.

## Accepted symbols

| Old label | Current label | Bank:address | Evidence |
|---|---|---|---|
| `Data_72_4E44` | `Dialog_CursorObjTable_Entry1` | `72:4E44` | The second four-byte entry at the dialog cursor object-table root; both direct dialog initializers select index 1. |
| `SpriteFrameTable_72_4E48` | `Dialog_Cursor_Anim0Frames` | `72:4E48` | Two frame pointers shared by entries 0 and 1; `Anim0` names the lowest sharing entry. |
| `SpriteFrame_72_4E4C` | `Dialog_Cursor_Anim0Frame0` | `72:4E4C` | First complete four-OAM frame in that shared frame table. |
| `SpriteFrame_72_4E5D` | `Dialog_Cursor_Anim0Frame1` | `72:4E5D` | Second complete four-OAM frame in that shared frame table. |
| `SpriteScript_72_4E6E` | `Dialog_Cursor_Anim0Script` | `72:4E6E` | Two-step animation script shared by entries 0 and 1. |
| `SpriteFrame_63_731C` | `NoAdapter_Anim1Frame0` | `63:731C` | First complete frame selected by no-adapter object-table entry 1. |
| `SpriteFrame_63_7325` | `NoAdapter_Anim1Frame1` | `63:7325` | Second complete frame selected by no-adapter object-table entry 1. |
| `SpriteScript_63_732A` | `NoAdapter_Anim1Script` | `63:732A` | Complete two-step script selected by no-adapter object-table entry 1. |

The three direct initializers are at `72:40C8`, `72:424F` and `63:73EB`; the
original instructions supply the corresponding ROM bank, table root and index
`$81` (entry 1). The cursor frame/script data totals 51 bytes and the no-adapter
frame/script data totals 31 bytes. An independent bounded emitter compared all
82 bytes with the immutable Japanese ROM and found exact equality. The dialog
animation is shared by entries 0 and 1; the names do not imply exclusivity.

The independent reviewer accepted all eight labels, found no collision in its
1,792-file source scan, and confirmed the direct consumers and emitted bytes.
The review report is retained in the ignored `.tmp/agent-gfx-candidate-review-20261021/`
evidence directory (report SHA-256
`6cbe179d8d3e0c838cb15a6df263d89f062065f721af166a47c6d8af8aa96947`, result
SHA-256 `aa4d4b04a06dde5b291505409baa3375cbd922fa049112f2a8cb0d862a6d6c05`).

The retired `Data_72_4E44` spelling remains in frozen `config/` and historical
`analysis/mapper/` metadata as provenance. It is no longer an assembler symbol
or active source reference. Build gates after integration report:

- `make`: `RESULT: IDENTICAL`, 2,097,152 bytes, SHA-256
  `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
- `make sym-check`: 334 source files, 13,394 labels, 51 constants; pass.
- `make palette-check`: 162 loads, 116 arrays, two documented over-reads,
  zero errors.
- The rebuilt SYM contains all eight new labels at the reviewed addresses,
  none of the eight retired labels, and the unchanged 13,394-label total.

These findings are static ownership, structure and byte-identity evidence. They
do not identify the depicted subject of the no-adapter object or prove a natural
runtime path, visual rendering, hardware behavior, or whole-ROM GFX naming
closure.
