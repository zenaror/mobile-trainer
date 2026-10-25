# Mail-menu bank 1D duplicate aliases (2026-10-21)

Removed 19 generic exports in `engine/menus/mail_menu.asm`; each was an
immediately adjacent alias at the same bank/address as an existing
`MailMenu_*` symbol. The token census and independent owner inspection found
each old token only at its declaration, with no references in the 347 permitted
ASM/INC files or tools and no local labels depending on the generic scope.
Declarations were replaced by blank lines, retaining all 540 physical lines,
bytes, table entries, comments, and assembled addresses. No new interpretation
of the mail-menu data or behavior is implied.

| address | retired generic label | retained label |
|---|---|---|
| `1D:41A0` | `Table_1D_41A0` | `Table_MailMenu_Buttons` |
| `1D:430D` | `Table_1D_430D` | `Table_MailMenu_PlateBufferOffsets` |
| `1D:431D` | `Data_1D_431D` | `Data_MailMenu_PlateOffsets` |
| `1D:4383` | `Table_1D_4383` | `Table_MailMenu_SelectedBufferOffsets` |
| `1D:4393` | `Data_1D_4393` | `Data_MailMenu_SelectedPlateOffsets` |
| `1D:43FA` | `Data_1D_43FA` | `Data_MailMenu_StringIndexBank` |
| `1D:43FB` | `Table_1D_43FB` | `Table_MailMenu_Strings` |
| `1D:4413` | `String_1D_4413` | `Table_MailMenu_StringsTail` |
| `1D:4428` | `String_1D_4428` | `String_MailMenu_Text0` |
| `1D:4467` | `String_1D_4467` | `String_MailMenu_Title1` |
| `1D:4474` | `String_1D_4474` | `String_MailMenu_Text1` |
| `1D:4491` | `String_1D_4491` | `String_MailMenu_Title2` |
| `1D:44A0` | `String_1D_44A0` | `String_MailMenu_Text2` |
| `1D:44C5` | `String_1D_44C5` | `String_MailMenu_Title3` |
| `1D:44D4` | `String_1D_44D4` | `String_MailMenu_Text3` |
| `1D:44FF` | `String_1D_44FF` | `String_MailMenu_Title4` |
| `1D:450C` | `String_1D_450C` | `String_MailMenu_Text4` |
| `1D:4549` | `String_1D_4549` | `String_MailMenu_Title5` |
| `1D:4556` | `String_1D_4556` | `String_MailMenu_Text5` |

The refreshed census is pinned to `d4deefda5c97026f08688f0f642d3121d90aa1be`;
source-set SHA-256
`1e249e6dcc960fa8bba6c13533e80f7d5d2b0059fa8a3c6e65f0cf4bfcf32f2c`, over 347
tracked ASM/INC files excluding `languages/` and
`engine/mail/sample_data.asm`. Census and review artifacts are retained under
ignored `generic-coalias-post-d4deefda-20261021` (review artifact)
(`RESULT.json`, `REVIEW_MAIL_MENU.md`).
