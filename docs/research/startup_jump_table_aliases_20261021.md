# Bank 65 startup jump-table aliases — 2026-10-21

This pass retires four exact address aliases in `engine/startup/startup.asm`:

| retired spelling | retained spelling | address | basis |
|---|---|---:|---|
| `Data_65_403C` | `Startup_StatusJumpTable` | `65:403C` | same label address; the existing data header identifies the six bytes as the startup status jump table |
| `Table_65_406E` | `Startup_NoAdapterJumpTable` | `65:406E` | same address; dispatcher at `65:4042` indexes five words, whose targets are documented in the existing probable table header |
| `Table_65_40C5` | `Startup_ConfigValidJumpTable` | `65:40C5` | same address; dispatcher at `65:4078` indexes five words, documented in the existing probable table header |
| `Table_65_4119` | `Startup_ConfigBlankJumpTable` | `65:4119` | same address; dispatcher at `65:40CF` indexes five words, documented in the existing probable table header |

All source comments that referred to the retired spellings now use the retained labels. No table contents, section boundaries, evidence grades or code behavior changed. This is an alias cleanup only; it does not close other bank-65 identification questions or the Japanese-ROM audit.

Verification on the resulting tree: `make` reports SHA-256 OK and `RESULT: IDENTICAL`; `make sym-check` reports 12,329 source labels and 51 constants with all source label addresses matching `.sym`; `make palette-check` reports 162 loads in 116 arrays, two documented over-reads and zero errors. `make -n` was checked before the build and does not assemble the protected `engine/mail/sample_data.asm`.
