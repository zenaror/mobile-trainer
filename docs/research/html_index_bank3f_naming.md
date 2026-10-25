# Bank 3F HTML and mobile-dictionary index names

| Address | Name | Static contract |
|---|---|---|
| `3F:4006` | `String_HtmlStore_UrlPrefix` | The 10 ASCII bytes `file://di/` plus NUL, 11 bytes total. The two initial little-endian 16-bit pointers at `4000` target it; `BuildPageUrl` copies it and `LoadPage` compares it after selecting bank 3F. |
| `3F:4012` | `Table_HtmlStore_PageFarPointers` | 55 three-byte address/bank pointers. `BuildPageUrl` indexes by `3 * page`; `LoadPage` walks the same records. Destinations correspond to the 55 filename/NUL records in banks 3D/3E. |
| `3F:40B9` | `Table_MobileDict_CategoryPageLists` | Eleven pointers, indexed by category in `MobileDict_OnA` at `1A:4192`. The reader reads from bank 3F through `ReadByteFar` while reading each pointer and selected page index. |
| `3F:40CF` | `Data_MobileDict_CategoryPageIndices` | 61 category-selected page indexes. `MobileDict_OnA` selects an index and `MobileDictView_Show` passes it through to page URL construction. The eleven list lengths match the category counts in bank 1A. |

`Data_HtmlStore_ByteAfterUrlPrefix` names the byte by its confirmed structural
position. `LoadPage` reads `$02` there into `wRam_C2DC`, but no direct assembly
reader establishing the field's purpose was identified. `BuildPageUrl` advances
past it to `4012`; indirect uses of the stored WRAM value have not been excluded.
The name does not claim that `$02` is a type, mode, category, size, or count.

The two zero bytes at `3F:40B7..40B9` are the address-zero terminator tested by `LoadPage` before it reads a bank byte.
