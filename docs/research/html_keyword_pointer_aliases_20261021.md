# HTML keyword pointer-table aliases (2026-10-21)

Retired 12 generic `Table_74_AAAA` declarations from
`data/html/keywords.asm`. Each was a same-address alias of an existing
`Html_*Ptrs` label: the paired comment classifies the region as a pointer list
in the HTML tag/attribute lookup data. Exact-token searches across maintained
assembly found only the 12 declarations, with no operands or local scopes.
The HTML pointer words, targets, comments, extents, and confidence levels are
unchanged. These names identify the table structure; they do not claim a
stronger runtime contract than the adjacent comments.

Validation after these two bounded generic-alias cleanups:
`make` reports `RESULT: IDENTICAL` with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`,
`make sym-check` reports 334 source files and 13,446 labels, and
`make palette-check` reports 162 loads, 116 arrays, 2 documented over-reads,
and zero errors.
