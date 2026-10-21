# Title-screen table aliases — 2026-10-21

Three exact bank-0E numeric aliases were retired from `engine/title/title_screen.asm`:

| retired spelling | retained spelling | address | basis |
|---|---|---:|---|
| `Table_0E_4094` | `Table_Title_States` | `0E:4094` | seven state-handler pointers selected by the title dispatcher; existing header remains PROBABLE because the table extent is a survey |
| `Data_0E_4330` | `Table_Title_HighlightTilemaps` | `0E:4330` | two tilemap pointers read by the confirmed highlight routine |
| `Data_0E_434B` | `Table_Title_CursorPositions` | `0E:434B` | two `(y,x)` coordinate pairs read by the confirmed cursor-placement routine |

The maintained source already uses the semantic labels at the call sites, and the address-only labels had no other maintained-source consumers. The two four-byte data blocks retain their existing header wording about unknown content class; their supported reader roles and CONFIRMED read grades are unchanged. Frozen mapping snapshots are not rewritten.
