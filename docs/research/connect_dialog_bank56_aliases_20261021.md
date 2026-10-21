# Connect-dialog bank 56 duplicate aliases (2026-10-21)

Removed 20 generic global aliases in `gfx/comm/connect_dialog_bank56.asm`.
Each address already has a descriptive resource label. Every old token occurred
only on its own declaration; the independent owner review found no use in code
or comments. Nineteen candidates had no references in other permitted sources
or tools. `Data_56_526A` was the one tool reference: the historical output
transformation in `tools/retype_blobs.py` now emits an empty line there, so a
future retyping pass does not recreate the redundant export. The resource
bytes, included files, comments, assembled addresses, and 268 physical source
lines are preserved. No new semantic or runtime claim is made.

| address | retired label | retained label |
|---|---|---|
| `56:418A` | `Data_56_418A` | `Tilemap_ConnectDialog_56_418A` |
| `56:445A` | `Data_56_445A` | `Tilemap_ConnectDialog_56_445A` |
| `56:472A` | `Data_56_472A` | `Tilemap_ConnectDialog_56_472A` |
| `56:49FA` | `Data_56_49FA` | `Tilemap_ConnectDialog_56_49FA` |
| `56:4CCA` | `Data_56_4CCA` | `Tilemap_ConnectDialog_56_4CCA` |
| `56:4F9A` | `Data_56_4F9A` | `Tilemap_ConnectDialog_ConnectConfirm_56_4F9A` |
| `56:526A` | `Data_56_526A` | `Tilemap_ConnectDialog_ConnectConfirm_56_526A` |
| `56:52C0` | `Data_56_52C0` | `Gfx_ConnectDialog_ConnectConfirm_Tiles9000Vb1` |
| `56:56C0` | `Data_56_56C0` | `Gfx_ConnectDialog_ConnectConfirm_Tiles9400Vb1` |
| `56:5AC0` | `Data_56_5AC0` | `Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles8800` |
| `56:5DC0` | `Data_56_5DC0` | `Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9100Vb1` |
| `56:60C0` | `Data_56_60C0` | `Gfx_ConnectDialog_PasswordEntryAndSaveConfirm_Tiles9400Vb1` |
| `56:64C0` | `Data_56_64C0` | `Gfx_ConnectDialog_StoredPassword_Tiles8800` |
| `56:6AC0` | `Data_56_6AC0` | `Gfx_ConnectDialog_StoredPassword_Tiles9400Vb1` |
| `56:6EC0` | `Data_56_6EC0` | `Gfx_ConnectDialog_PasswordSaved_Tiles9100Vb1` |
| `56:71C0` | `Data_56_71C0` | `Gfx_ConnectDialog_PasswordSaved_Tiles9400Vb1` |
| `56:75C0` | `Data_56_75C0` | `Gfx_ConnectDialog_Finish_Tiles8000` |
| `56:77C0` | `Palette_56_77C0` | `Palette_ConnectDialog_Bg` |
| `56:7880` | `Data_56_7880` | `ConnectDialog_ObjAnimData` |
| `56:79B8` | `Table_56_79B8` | `ConnectDialog_ObjTable` |

The scan is based on HEAD `f4716767cd2d03a820fe23068271d233d4d7dcca`, 347
tracked non-language ASM/INC files excluding `engine/mail/sample_data.asm`,
with source-set SHA-256
`e8f5a54fd029b70ded630da26b7a1a96f87d2fb3832a2e7385f1f0e282303de2`.
The census and independent review are retained under ignored
`.tmp/generic-coalias-post-f4716767-20261021/` (`REVIEW_CONNECT_DIALOG.md`).
