# Consolidated Japanese name and path census — 2026-10-22

### Broader generic-looking symbol and path census at `99334912`

It found zero address-only definitions in the requested `Function/Func/Sub/Unknown/Unk/ Code/Label/Font/Tiles/Tilemap/Attrmap/Palette/String/Table/SpriteFrame/ SpriteScript` families, ten remaining `Data_BB_AAAA` definitions, zero exact `bankNN` path components, and zero strictly address-only or type-plus-address path stems.

The same scan counted 245 definitions containing an uncertainty token
(`Candidate`, `UnknownContent`, or `Unresolved`): 91 frame-design labels
and 154 other qualified labels. This is not 245 generic-name defects. Three
non-address patterns warrant explicit limits: `Settings_ReadData_UnknownContent_7271`
has confirmed read bytes but unknown content class; `SpriteScriptCandidate_2A_545C`
is an unreferenced three-byte script-shaped span; and `WramClearCandidate_28_4BA6`
is a possible instruction sequence without a demonstrated entry. Likewise,
`ReturnOnly_68_5D2F` names a confirmed RET byte without claiming a function,
while `SpriteSlotAnimationEntryTable_2A_5220` describes a probable table
layout. Their uncertainty or limited claims are intentional; they are not
evidence of missed function names. The inventory and per-label dispositions
are recorded here so future passes can compare against a fixed baseline.

## Source changes from this pass

Each text block has an associated wrapper; each wrapper passes its corresponding block to `TextTiles_RenderLine` three times and uploads the staged question-mark tiles.

| Source slice | Covered request | Derived destination for the slice | Important limit |
|---|---|---|---|
| `24:55D0–5800` (560 bytes) | `24:5400–5800` to VRAM1 `9300–9700` | VRAM1 `94D0–9700` | 16-byte aligned within the transfer; static inclusion does not establish display. |
| `24:5EF1–62D1` (992 bytes) | `24:5EE0–62E0` to VRAM0 `8000–8400` | VRAM0 `8011–83F1` | Starts at byte phase +1; name does not assert aligned tiles or PNG appearance. |
| `25:6BD1–6CE1` (272 bytes) | `25:69F0–6CF0` to VRAM0 `8000–8300` | VRAM0 `81E1–82F1` | Starts at byte phase +1; no arrow/label visual identity or natural display claim. |

## Names intentionally left unresolved

All 13 original `Data_BB_AAAA` spans were reviewed together. Three now use correspondence-only labels based on two exact byte matches and one unique masked code match; none is claimed as a Trainer function or active resource. Ten remain address-neutral because each is an isolated byte span or unclassified block whose entry, reader, or content type lacks positive proof. Their exact evidence and limits are documented in [`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md). Opcode-like bytes remain data labels until an entry or resource boundary is shown; adjacency and opcode resemblance do not justify function names.

The follow-up lexical review found 245 labels containing one of `Candidate`, `UnknownContent`, or `Unresolved`: 91 frame-design candidates and 154 other qualified names. These tokens alone do not mean a symbol is address-only or badly named. Four labels begin with `Candidate`: `CandidateTiles_51_5EE1`, `CandidatePalette_29_5376`, `CandidatePalette_26_73E0`, and `CandidateMapData_23_7C03`; other occurrences qualify otherwise descriptive owner/resource names. `UnresolvedTiles_7F_7830` has a visual 2bpp-sized backing but no located reader. The additional unreferenced/candidate cases are listed below with evidence limits rather than treated as automatic rename targets.

- `ReturnOnly_68_5D2F` identifies a single observed `RET`; entry and purpose remain HYPOTHESIS, so no surrounding password routine is attributed to it. - `Settings_ReadData_UnknownContent_7271` spans confirmed read bytes whose content class and consumer are unresolved; the name preserves those limits. - `SpriteScriptCandidate_2A_545C` is a three-byte script-shaped candidate outside the known animation table; no consumer is established. - `WramClearCandidate_28_4BA6` is a possible instruction sequence, but no entry is established. - `BrowserMenu_PlaceholderText` and `CommErr_Msg_GenericCommError` describe the known placeholder and generic-error roles. - The 3,872 `.lAAAA` names are local branch labels, not a count of unidentified functions.

## Remaining closure work

Four natural-entry questions remain unresolved in the existing bounded report: `2B:6CF5`, `2D:4E42`, `2D:4E54`, and `29:511E`.

`python3 tools/png_rules.py mk-check` passes for 977 rules and `python3 tools/png_check.py` passes for 408 tile sheets, four raw byte views, 37 font sheets and 95 screen PNGs.
