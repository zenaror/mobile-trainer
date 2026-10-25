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

At this checkpoint `Palette_7F_4D50` was deliberately retained because it
anchored `.loop` at `7F:4D5E`; that decision preserved the then-current qualified
symbol and was correct for that snapshot. A later owner review removed the
alias after checking the full local scope: `.loop` now resolves as
`Palette_Canvas_Bg.loop` at the same address. The global map and local-symbol
count are recorded in `analysis/naming2/retired_coincident_label_aliases.tsv`;
the full local mapping is in `docs/research/generic_data_name_audit_20261020.md`.
This symbol cleanup still does not claim that the following code belongs to the
eight-byte palette.
`Data_7F_51ED` also remains because no descriptive same-address alias was
demonstrated.

The static reviewer accepted the 15-label subset, confirmed zero other
references in the 347 in-scope ASM/INC files and 142 tools, and verified the
local-scope exception above. The receipt is retained at
`REVIEW_PAGE_LIST.md` (review artifact).

After the change, `make` reported `RESULT: IDENTICAL` against original ROM
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` reported 12,921 labels and 51 constants with all addresses
valid; `make palette-check` reported 162 loads, 116 arrays, two documented
over-reads and zero errors; `make png-check` checked 408 tile sheets, four raw
byte views, 37 font sheets and 95 screen PNGs successfully. No code, resource
bytes, natural-reachability claims or runtime semantics changed.
