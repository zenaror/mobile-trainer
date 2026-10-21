# Redundant labels in the page-list prototype

The `engine/unreferenced/page_list_prototype.asm` owner contains 15 generic
labels that are exact-address aliases of existing descriptive labels. The
independent audit checked the owner at SHA-256
`f7228bd140ca10dff8868c7159a0d17e684511554776b92ac52c13c0af6c3db1`, source
references, tool references, and local-label scope. Only the 15 alias
declarations below were retired; the 2,788-line owner, data, code, comments,
confidence annotations, and local labels remain unchanged.

| Address | Retired label | Retained label |
|---|---|---|
| `7F:4D88` | `String_7F_4D88` | `String_Canvas_SampleAscii` |
| `7F:4DF2` | `String_7F_4DF2` | `String_Canvas_SampleSentence_7F_4DF2` |
| `7F:4E6A` | `String_7F_4E6A` | `String_Canvas_SampleSentence_7F_4E6A` |
| `7F:4E89` | `Table_7F_4E89` | `Sample_PageNamePtrs` |
| `7F:4E95` | `String_7F_4E95` | `String_Sample_PageNames_0_2` |
| `7F:4ED0` | `String_7F_4ED0` | `String_Sample_PageNames_3_5` |
| `7F:4EF0` | `Table_7F_4EF0` | `Sample_PageUrlPtrs` |
| `7F:4EFC` | `String_7F_4EFC` | `String_Sample_PageUrl0` |
| `7F:4F15` | `String_7F_4F15` | `String_Sample_PageUrl1` |
| `7F:4F2F` | `String_7F_4F2F` | `String_Sample_PageUrl2` |
| `7F:4F49` | `String_7F_4F49` | `String_Sample_PageUrl3` |
| `7F:4F67` | `String_7F_4F67` | `String_Sample_PageUrl4` |
| `7F:4F79` | `String_7F_4F79` | `String_Sample_PageUrl5` |
| `7F:4FC3` | `Table_7F_4FC3` | `PageListProto_UrlSlotTable` |
| `7F:4FCF` | `Table_7F_4FCF` | `PageListProto_TitleSlotTable` |

`Palette_7F_4D50` is deliberately retained. Although it shares address
`7F:4D50` with `Palette_Canvas_Bg`, it anchors the following local label
`Palette_7F_4D50.loop` at `7F:4D5E`, which is the target of `jr nz, .loop`.
Removing that alias would change the qualified local symbol. `Data_7F_51ED`
also remains because no descriptive same-address alias was demonstrated.

The static reviewer accepted the 15-label subset, confirmed zero other
references in the 347 in-scope ASM/INC files and 142 tools, and verified the
local-scope exception above. The receipt is retained at
`.tmp/generic-coalias-post-3019597c-20261021/REVIEW_PAGE_LIST.md`.

After the change, `make` reported `RESULT: IDENTICAL` against original ROM
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` reported 12,921 labels and 51 constants with all addresses
valid; `make palette-check` reported 162 loads, 116 arrays, two documented
over-reads and zero errors; `make png-check` checked 408 tile sheets, four raw
byte views, 37 font sheets and 95 screen PNGs successfully. No code, resource
bytes, natural-reachability claims or runtime semantics changed.
