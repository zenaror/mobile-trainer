# Notice-page table aliases — 2026-10-21

Four exact bank-65 aliases were retired from `engine/startup/notice_pages.asm`:

| retired spelling | maintained spelling | address | evidence |
|---|---|---:|---|
| `Table_65_494E` | `Notice_JoypadTable` | `65:494E` | five-entry inline `JoypadDispatch` table; all bytes are read in an existing trace |
| `Table_65_4B78` | `Notice_DigitRecordLists` | `65:4B78` | two pointers read by `Notice_DrawPageCounter` |
| `Table_65_4B7C` | `Notice_DigitRecords_Normal` | `65:4B7C` | 11 pointers to bank-58 digit-glyph records, as documented in the source header |
| `Table_65_4B92` | `Notice_DigitRecords_Variant` | `65:4B92` | 11 pointers to the alternate bank-58 records, as documented in the source header |

No active maintained source consumer uses the retired spellings. Frozen `config/` tables and generated `analysis/` snapshots intentionally retain their historical symbol names; they are not inputs to the maintained source and are not rewritten here. The alias map in this note preserves that migration history. Data, extents and evidence grades are unchanged.
