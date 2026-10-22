# Address-book name-editor graphics paths

This 2026-10-22 pass gives four address-only Bank 2F payload filenames names
based on the owner and the static VRAM/palette transfers. The matching three
editable tile PNG paths follow their payloads. The direct old-to-current mapping
is in [`gfx_resource_path_map.tsv`](gfx_resource_path_map.tsv).

| Original range | Current path stem | Static evidence |
|---|---|---|
| `2F:61F0–65F0` | `abook_name_tiles9300_vb1` | 1,024 bytes loaded by `AbookName_SetupScreen` at `2F:5966` to VRAM `$9300`, bank 1; owner label `Gfx_AbookName_Tiles9300Vb1`. |
| `2F:65F0–66F0` | `abook_name_tiles9700_vb1` | 256 bytes loaded at `2F:5978` to VRAM `$9700`, bank 1; owner label `Gfx_AbookName_Tiles9700Vb1`. The tile fragments remain unclassified. |
| `2F:66F0–69F0` | `abook_name_tiles8800` | 768 bytes loaded at `2F:598A` to VRAM `$8800`, bank 0; owner label `Gfx_AbookName_Tiles8800`. |
| `2F:6CC0–6D00` | `abook_name_bg_palette` | 64-byte CGB palette block loaded at `2F:59B3–59BE` to `$D800`; owner label `Palette_AbookName_Bg`. |

The transfer sites and destinations are statically decoded and recorded in the
owner comments and `gfx/previews/screen_ops.tsv`; their instruction starts are
also confirmed as executed in the existing coverage evidence. The path names do
not add a visual classification for the unreadable tile fragments or claims
about hardware behavior.

All seven renamed payload/PNG files retain their original SHA-256 hashes. No
asset bytes, labels, extents or layout addresses change. The Japanese build and
asset checks confirm the result.
