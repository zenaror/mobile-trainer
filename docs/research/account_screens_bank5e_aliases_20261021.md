# Redundant aliases in account-screen bank 5E

At the `fae0a378f04213b657f659447907803ff29d12e3` snapshot, the 128-line
owner `gfx/account/screens_bank5e.asm` contained 16 generic `Data_5E_*`
labels at exact addresses already held by named graphics, palette, and
tilemap labels. The independent review confirmed the owner hash
`e902e804258c59c21903586eeeb1d7d6dd9da7df37952f3e2d94950562e3b008` before
editing and accepted all 16 declaration-only removals. Source references,
tools, and local scopes were checked; only the alias lines changed.

| Address | Retired label | Retained label |
|---|---|---|
| `5E:4800` | `Data_5E_4800` | `Gfx_Account_LoginIdEntry_Tiles9000Vb1` |
| `5E:4C00` | `Data_5E_4C00` | `Gfx_Account_LoginIdEntry_Tiles9400Vb1` |
| `5E:4D00` | `Data_5E_4D00` | `Palette_SharedEntryUi_Bg` |
| `5E:4D40` | `Data_5E_4D40` | `Tilemap_Account_LoginIdEntry` |
| `5E:4E10` | `Data_5E_4E10` | `Gfx_Account_LoginIdIntro_Tiles9000Vb1` |
| `5E:5210` | `Data_5E_5210` | `Gfx_Account_LoginIdIntro_Tiles9400Vb1` |
| `5E:57E0` | `Data_5E_57E0` | `Gfx_Kbd_T1_Tiles8800` |
| `5E:5800` | `Data_5E_5800` | `Gfx_Account_MailAddressEntry_Tiles9000Vb1` |
| `5E:5C00` | `Data_5E_5C00` | `Gfx_Account_MailAddressEntry_Tiles9400Vb1` |
| `5E:6000` | `Data_5E_6000` | `Tilemap_Account_MailAddressEntry` |
| `5E:60D0` | `Data_5E_60D0` | `Gfx_Account_MailIntro_Tiles9000Vb1` |
| `5E:64D0` | `Data_5E_64D0` | `Gfx_Account_MailIntro_Tiles9400Vb1` |
| `5E:68D0` | `Data_5E_68D0` | `Tilemap_Account_MailIntro` |
| `5E:6BA0` | `Data_5E_6BA0` | `Gfx_Account_ActionConfirmPage_Tiles9000Vb1` |
| `5E:6FA0` | `Data_5E_6FA0` | `Gfx_Account_ActionConfirmPage_Tiles9400Vb1` |
| `5E:75D0` | `Data_5E_75D0` | `Tilemap_Account_ActionConfirmPage_NonzeroVariant` |

The reviewer also reconstructed the owner's `INCBIN`, palette and padding
emission for `5E:4800–78A0` (12,448 bytes) and matched the original ROM. The
final review confirmed that the actual diff is restricted to the 16 approved
declarations; its receipt is retained at
`.tmp/generic-coalias-post-fae0a378-20261021/REVIEW_ACCOUNT_5E.md`.

Post-edit validation: `make` produced `RESULT: IDENTICAL` against the original
2 MiB ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`);
`make sym-check` passed with 12,877 labels and 51 constants;
`make palette-check` passed with 162 loads in 116 arrays, 2 documented
over-reads, and 0 errors; `make png-check` passed with 408 tile sheets,
4 raw byte views, 37 font sheets, and 95 screen PNGs. The audit makes no new
claim about which screens are naturally reached or about application semantics
beyond the existing labels.
