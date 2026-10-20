# Bank 3F HTML and mobile-dictionary index names

This note records the static evidence for the four semantic aliases added to
the Japanese source at bank 3F. The byte layout remains expressed with the
existing `db`/`ds` directives. The names describe the consumers that calculate
through these spans; they do not assert that every entry was executed.

## Evidence and boundaries

| Address | Name | Static contract |
|---|---|---|
| `3F:4006` | `String_HtmlStore_UrlPrefix` | The 10 ASCII bytes `file://di/` plus NUL, 11 bytes total. The two initial little-endian 16-bit pointers at `4000` target it; `BuildPageUrl` copies it and `LoadPage` compares it after selecting bank 3F. |
| `3F:4012` | `Table_HtmlStore_PageFarPointers` | 55 three-byte address/bank pointers. `BuildPageUrl` indexes by `3 * page`; `LoadPage` walks the same records. Destinations correspond to the 55 filename/NUL records in banks 3D/3E. |
| `3F:40B9` | `Table_MobileDict_CategoryPageLists` | Eleven pointers, indexed by category in `MobileDict_OnA` at `1A:4192`. The reader reads from bank 3F through `ReadByteFar` while reading each pointer and selected page index. |
| `3F:40CF` | `Data_MobileDict_CategoryPageIndices` | 61 category-selected page indexes. `MobileDict_OnA` selects an index and `MobileDictView_Show` passes it through to page URL construction. The eleven list lengths match the category counts in bank 1A. |

These roles are CONFIRMED as static source/consumer contracts. They do not
prove all entries execute under natural gameplay or that every HTML page was
rendered. An independent bounded parser reserialized the 268 emitted bytes for
`3F:4000..410C`; they match the original ROM slice with SHA-256
`2f47129765928f465b6b66de77156324eca38f1291223a28833f36650bfd6c2f`.

`Data_3F_4011` remains neutral. `LoadPage` reads `$02` there into
`wRam_C2DC`, but no direct assembly reader establishing the field's purpose was
identified. `BuildPageUrl` advances past it to `4012`; indirect uses of the
stored WRAM value have not been excluded.

The two zero bytes at `3F:40B7..40B9` are the address-zero terminator tested by
`LoadPage` before it reads a bank byte. They are not a three-byte far pointer
and are not padding. This is a static interpretation of the routine; no new
execution of the no-match branch is claimed. The source retains the existing
zero-fill directive.

## Validation scope

The five generic data/string aliases at `3F:4000`, `4006`, `4012`, `40B9`, and
`40CF` were retired after checking maintained source references. Their old
addresses and new names are recorded in `analysis/naming2/html_index_renames.tsv`
and this note. Historical analysis/config tables keep their original spellings
as snapshots. The only consumer instruction change
replaces immediate `$40B9` with `Table_MobileDict_CategoryPageLists`; the ROM
instruction remains `21 B9 40`. Full ROM reconstruction equivalence is
established only by the parent build gate, not by the 268-byte span check above.
