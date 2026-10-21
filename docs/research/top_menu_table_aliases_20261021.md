# Top-menu table aliases — 2026-10-21

Two redundant bank-1F labels were retired from `engine/menus/top_menu.asm`:

| retired spelling | retained spelling | address | evidence |
|---|---|---:|---|
| `Table_1F_41E9` | `Table_TopMenu_Buttons` | `1F:41E9` | the five-entry inline `JoypadDispatch` table at `1F:41E6`; all bytes were read in traces |
| `Data_1F_434B` | `Table_TopMenu_CursorTargets` | `1F:434B` | the three `(y,x)` pairs are loaded by the cursor-target reader and stored in its target coordinates; existing source evidence remains `CONFIRMED` |

The cursor-target block's existing header calls its content class unknown; this pass retains that qualification and only adopts the existing label already used by the reader. No bytes, extents or behavior changed.
