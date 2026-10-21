# Mail-server tidy-screen aliases

At the Japanese source snapshot `1e10c1b188a1a0dcf12bcc4213e9724eb7a1e780`,
`gfx/mail_server/tidy_screen.asm` had 16 address-only labels co-located with
existing descriptive graphics, tilemap, palette, object-table, or animation
data labels. The independent review checked the exact 294-line owner hash
`4f53a93ba4236fcf8e208ced18997e888d72dd3b2757fe554348b887789b2347`, symbol
addresses, source and tool references, local-label scopes, includes and macro
behavior before approving removal of all 16 declarations.

| Address | Retired label | Retained label |
|---|---|---|
| `2E:56E0` | `Data_2E_56E0` | `Gfx_MailServerMgr_Tiles0` |
| `2E:5AE0` | `Data_2E_5AE0` | `Gfx_MailServerMgr_Tiles1` |
| `2E:5EE0` | `Data_2E_5EE0` | `Gfx_MailServerMgr_Tiles2` |
| `2E:6000` | `Data_2E_6000` | `Gfx_MailServerMgr_Tiles3` |
| `2E:6400` | `Data_2E_6400` | `Gfx_MailServerMgr_Tiles4` |
| `2E:6560` | `Data_2E_6560` | `Gfx_MailServerMgr_Tiles5` |
| `2E:6960` | `Data_2E_6960` | `Tilemap_MailServerMgr_Main` |
| `2E:6C30` | `Data_2E_6C30` | `Tilemap_MailServerMgr_Footer` |
| `2E:6D20` | `Data_2E_6D20` | `Tilemap_MailServerMgr_InfoB` |
| `2E:6FF0` | `Data_2E_6FF0` | `Tilemap_MailServerMgr_InfoC` |
| `2E:72C0` | `Data_2E_72C0` | `Tilemap_MailServerMgr_InfoD` |
| `2E:7590` | `Data_2E_7590` | `Palette_MailServerMgr_Bg` |
| `2E:76C0` | `Table_2E_76C0` | `Table_MailServerMgr_ObjAnims` |
| `2E:7720` | `Data_2E_7720` | `MailServerMgr_ObjAnimData_2E_7720` |
| `2E:7921` | `Data_2E_7921` | `MailServerMgr_ObjAnimData_2E_7921` |
| `2E:793E` | `Data_2E_793E` | `MailServerMgr_ObjAnimData_2E_793E` |

The owner remains 294 lines; only the 16 declaration lines are blanked. The
review found no other source/tool references, local labels in this owner, or
macro/include dependence on the removed spellings. The existing neutral labels
at other addresses remain untouched where no descriptive co-label was proven.
This is an alias cleanup only; it makes no new claim about animation reach or
application behavior. The review receipt is retained in
`.tmp/agent-tidy-screen-alias-review-20261021/REVIEW.md`; the fresh source
census is `.tmp/generic-coalias-post-1e10c1b1-20261021/RESULT.json`.

Post-edit validation: `make` returned `RESULT: IDENTICAL` against the Japanese
ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passed with 12,861 labels and 51 constants;
`make palette-check` passed with 162 loads in 116 arrays, 2 documented
over-reads, and zero errors; `make png-check` passed with 408 tile sheets,
4 raw byte views, 37 font sheets, and 95 screen PNGs.

