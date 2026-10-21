# Canvas remap and glyph-data aliases — 2026-10-21

Four exact aliases were retired from `engine/text/canvas.asm`:

| retired spelling | retained spelling | address | basis |
|---|---|---:|---|
| `Table_7F_42A3` | `Canvas_RemapTable` | `7F:42A3` | 16-word table used by `Canvas_RemapGlyphColors`; existing table header records the probable boundary |
| `Table_7F_499C` | `Canvas_BlitMaskCur` | `7F:499C` | nine-byte current-tile mask indexed by the glyph blitter, with reads recorded in traces |
| `Table_7F_49A5` | `Canvas_BlitMaskNext` | `7F:49A5` | nine-byte next-tile mask paired with the preceding mask table |
| `Data_7F_4C57` | `Glyph_DottedLineData` | `7F:4C57` | confirmed 32-byte source copied by `Glyph_LoadDottedLine`; its exact visual/content-class qualification remains in the existing header |

The semantic labels were already used by consumers and current research. No bytes, extents, handlers or evidence grades changed. The names do not promote the unobserved remap handlers or glyph display contexts to naturally observed behavior.
