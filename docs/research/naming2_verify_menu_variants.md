# Independent verification of menu variant names (ROM unchanged)

> Status: **reference (current)**. A fresh-context skeptic read all four map definitions, every symbolic use, selector/caller chain, indirect consumers and active metadata.

Four final rows are CONFIRMED. Original source proposals HiddenMode/NormalMode were conservatively changed to FlagSet/FlagClear: the branch is demonstrated, while the SRAM/RAM hidden-mode interpretation remains PROBABLE. The account nonzero map is shared by values 1, 2 and 3; the zero map has its own natural demonstrating call. No guessed UI meaning is encoded in the new names.

The reviewer independently checked each 720-byte asset pair against the immutable ROM, unique immediate pointer/bank sequences, consumer geometry, selected banks, full natural counts/scenarios and namespace collisions. All 35 exact-token uses were accounted for; 24 active substitutions are required, while historical records, neutral aliases and asset paths stay intact. The strict tool accepted all four rows; the coordinator's complete diff audit confirmed exactly those 24 substitutions with unchanged source line counts, values, data and paths. Status evidence in existing RAM fields is unchanged.

No new natural scenario, forced replay, renderer capture, PPU or hardware evidence. Coordinator build and complete suite are the final original-byte/symbol gates after integration.

Integrated validation: `make` reports SHA-256 OK and RESULT: IDENTICAL; `make sym-check`, `make palette-check` and the complete checkpoint suite pass. The suite has 37 entries: 36 return zero, and the sole nonzero result is the documented obsolete ramop7 record schema (exit 2), unchanged by this pass.
