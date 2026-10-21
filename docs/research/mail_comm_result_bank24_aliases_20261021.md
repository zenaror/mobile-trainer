# Mail-result bank 24 duplicate aliases (2026-10-21)

Removed 18 generic palette/table exports in `gfx/mail/comm_result.asm`; every
address retains an existing descriptive label. The census and owner review
found no uses of the old spellings outside the declarations, no references in
other permitted sources/tools, and no dependent local labels. Each declaration
is now a blank line; resource bytes, comments, confidence levels, assembled
addresses, and physical line positions remain unchanged. This is an export
cleanup only, without new sprite semantics or runtime claims.

| address | retired generic label | retained label |
|---|---|---|
| `24:7A60` | `Palette_24_7A60` | `MailResult_BgPalette` |
| `24:7AA0` | `Palette_24_7AA0` | `MailResult_ObjPalette` |
| `24:7AE0` | `Palette_24_7AE0` | `MailServerStatus_BgPalette` |
| `24:7B20` | `Table_24_7B20` | `MailResult_ObjTable` |
| `24:7C00` | `Table_24_7C00` | `MailResult_Anim0Frames` |
| `24:7C36` | `Table_24_7C36` | `MailResult_Anim4Frames` |
| `24:7C88` | `Table_24_7C88` | `MailResult_Anim8Frames` |
| `24:7C96` | `Table_24_7C96` | `MailResult_Anim12Frames` |
| `24:7CA4` | `Table_24_7CA4` | `MailResult_Anim16Frames` |
| `24:7CB2` | `Table_24_7CB2` | `MailResult_Anim20Frames` |
| `24:7CC0` | `Table_24_7CC0` | `MailResult_Anim24Frames` |
| `24:7CCE` | `Table_24_7CCE` | `MailResult_Anim28Frames` |
| `24:7CDC` | `Table_24_7CDC` | `MailResult_Anim32Frames` |
| `24:7CEA` | `Table_24_7CEA` | `MailResult_Anim36Frames` |
| `24:7CF8` | `Table_24_7CF8` | `MailResult_Anim40Frames` |
| `24:7D06` | `Table_24_7D06` | `MailResult_Anim44Frames` |
| `24:7D1C` | `Table_24_7D1C` | `MailResult_Anim48Frames` |
| `24:7D32` | `Table_24_7D32` | `MailResult_Anim52Frames` |

The refreshed census is pinned to `3e520609c05181da7cf221b61507fcfb8cc5fc3f`;
source-set SHA-256
`aa40ee486db93c618b885df581a3ea63b7799f207b2a1b417429256173775b6b`, over 347
tracked ASM/INC files excluding `languages/` and
`engine/mail/sample_data.asm`. Census and review receipts are retained under
ignored `.tmp/generic-coalias-post-3e520609-20261021/`
(`RESULT.json`, `REVIEW_COMM_RESULT.md`).
