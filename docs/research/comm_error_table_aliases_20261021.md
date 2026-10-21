# Communication-error table aliases — 2026-10-21

Three exact aliases were retired from `data/text/comm_error_messages.asm`:

| retired spelling | retained spelling | address | source evidence/limit |
|---|---|---:|---|
| `Table_5C_4F53` | `CommErr_RecordTable` | `5C:4F53` | 21 `[id, mode, list]` records, searched by the executed error-screen code; existing CONFIRMED header |
| `Table_5C_5104` | `CommErr_MessagePointers` | `5C:5104` | 32 string pointers indexed by message number; existing PROBABLE header records slot 32 and continuation limits |
| `Table_5C_5146` | `CommErr_MessagePointers_Boot` | `5C:5146` | five-pointer boot continuation for slots 33–37; existing PROBABLE header retains its bounded selector evidence |

Maintained consumers and current research already use the retained labels; no other active source or metadata references to the old spellings were found. Frozen mapping/configuration snapshots retain historical spellings. Table bytes, boundaries and evidence grades are unchanged.
