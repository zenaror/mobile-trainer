# Japanese address-only local-label census follow-up (2026-10-23)

## Result

This checkpoint reconciles the local-label backlog in three exhaustive, disjoint partitions. It starts from the 3,325 `.lAAAA` labels left after the 2026-10-22 batch at `e97026b86acc37e8157aa38fe10f9ec098c00350`; the English overlay and Operator ZIP were not accessed or changed.

| Owner partition | Reviewed | Renamed after independent review | Retained with explicit disposition |
|---|---:|---:|---:|
| Remaining symbol-census owners | 2,024 | 110 | 1,914 |
| Engine path-review owners | 1,157 | 44 | 1,113 |
| HOME/audio/mobile library residual owners | 144 | 42 | 102 |
| **Total** | **3,325** | **196** | **3,129** |

The 196 replacements are local operation labels, not new function boundaries or claims of natural reachability. Reviewers checked each proposal against its owner, exact bank/address, instructions and in-owner references; the independent reviews accepted all 196 without corrections or collisions. The complete applied map is [`japanese_local_label_batch_mapping_20261023.tsv`](japanese_local_label_batch_mapping_20261023.tsv), SHA-256 `f12919c4eb2ef7fdd37dae4a063f91eb83ac30af8c59dc7baab5b8a72017b7ea`.

## Coverage and remaining names

A fresh census of the six maintained Japanese source roots counted exactly 333 `.asm`/`.inc` files and 3,129 address-only `.lAAAA` definitions (3,027 engine, 67 lib, 28 audio and 7 home; none in data or gfx). The total reconciles exactly with the three partition ledgers above. Each remaining label has an owner-level disposition; “retained” means the review found no safe semantic improvement under current evidence, not that every label is self-documenting or the ROM is semantically complete. The partition reports distinguish cosmetic anchors from unresolved flow, data-boundary and phase questions. Natural entry and runtime reachability are not implied by a local label.

The same fresh definition scan found ten strict `Data_BB_AAAA` labels, matching the existing ten-span evidence table, and zero strict address-form definitions in the searched Function/Func/Sub/Unknown/Code/Label/Font/Tiles/Tile/Tilemap/Attrmap/Palette families. A GFX path scan found no `bankNN` directories. The ten data names remain neutral because no stronger type/entry role is supported; do not rename them from opcode appearance or negative literal-reference scans alone. This strict-pattern census complements, but does not replace, the broader qualified-name and path reviews in [`japanese_generic_name_census_followup_20261023.md`](japanese_generic_name_census_followup_20261023.md).

The source of each partition’s counts, per-row rationale, pre-change ledger digest and independent review is retained in the ignored task evidence directory `.tmp/jp-generic-name-batch-20261022-evidence/`:

- `retained-2024-symbol-census-ledger.tsv` (2,024 rows; SHA-256 `31193a38e9175abc242709847c1283c430cbd0bc17e2ba3ca52c32cb71c6bff1`) and its 110-row proposal and cross-review reports;
- `retained-engine-owner-review/owner_ledger.tsv` (1,157 rows; SHA-256 `e57026ebf95cf7bf37078de31874c60c122ed1058bde8406b9e9249e99f83ae9`) and its 44-row proposal and review;
- `home_audio_lib_144_cross_review.tsv` (144 rows; SHA-256 `b4ec53b06c16d9d79fa3c0d08b2083a4d53a38fd0b9953dc6c9f0e1fa52f44d7`) and its 42-row proposal and review.

These three partitions have been reconciled; this replaces further ad hoc searches for the same `.lAAAA` population. New names found by future scans must be shown to fall outside the 333-file scope or be a different identifier family, and must be reconciled against this inventory before a new change is proposed.

## Validation and limits

After all 196 token-only renames, the Japanese checks passed:

- `make`: original ROM SHA-256 OK; built ROM is 2,097,152 bytes and byte-identical (`RESULT: IDENTICAL`, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`);
- `make sym-check`: 335 source files, 12,185 labels and 51 constants; OK;
- `make palette-check`: 162 loads, 116 arrays, two documented over-reads and zero errors;
- `make png-check`: 408 tile sheets, four raw views, 37 font sheets and 95 screen PNGs; OK;
- `git diff --check`: OK.

These checks establish source/map consistency, resource-rule consistency and byte identity for this Japanese build. They do not establish complete semantic identification, runtime behavior, or that the retained 3,129 labels can never be improved with new evidence. The separate Bank 53 audit closes the bounded file-presence/extraction inventory, but all 25 species-name/frame associations and natural/unused frame status remain open; see [`bank53_names_frames_assets_audit_20261023.md`](bank53_names_frames_assets_audit_20261023.md).
