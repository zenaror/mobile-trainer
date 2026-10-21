# Bank 7C navigation jump-table aliases — 2026-10-21

Three exact numeric aliases were retired from `engine/main/navigation.asm`:

| retired spelling | retained spelling | address | evidence/limit |
|---|---|---:|---|
| `Table_7C_7B8E` | `Nav_TopMenuJumpTable` | `7C:7B8E` | Four inline results after `JumpTableInline`; the existing header leaves the end heuristic/probable |
| `Table_7C_7BC9` | `Nav_MailMenuJumpTable` | `7C:7BC9` | Seven inline results after `JumpTableInline`; the existing header leaves the end heuristic/probable |
| `Table_7C_7D60` | `Nav_MobileSettingsJumpTable` | `7C:7D60` | Six inline results after `JumpTableInline`; the corrected six-word boundary is documented in `naming_g8.md`, but the helper has no general index bound |

No maintained assembly consumer used the retired spellings. Two current research notes were updated; the frozen `config/` and generated `analysis/` snapshots are historical and remain untouched. Table contents, existing confidence grades and code behavior are unchanged.
