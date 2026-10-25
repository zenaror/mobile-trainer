# Bank 4D asset-catalog label synchronization

This Japanese-source pass corrects eight stale `label` cells in
`gfx/assets.tsv` to symbols already defined at the corresponding data in
`gfx/settings/screens_bank4d.asm`. The evidence establishes catalog-to-owner
consistency, not new runtime behavior a new interpretation of the assets.

| Catalog address | Previous label | Current owner label | Asset |
|---|---|---|---|
| `4D:5978` | `Data_4D_5810` | `Tilemap_SettingsPhone_ChoiceMenu` | ChoiceMenu attribute map, sharing the map's base label |
| `4D:5810` | `Data_4D_5810` | `Tilemap_SettingsPhone_ChoiceMenu` | ChoiceMenu tilemap |
| `4D:4000` | `Data_4D_4000` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1` | ChoiceMenu tiles |
| `4D:4510` | `Data_4D_4510` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_4510` | ChoiceMenu tiles |
| `4D:4610` | `Data_4D_4610` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_4610` | ChoiceMenu tiles |
| `4D:4A10` | `Data_4D_4A10` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9400Vb1` | ChoiceMenu tiles |
| `4D:5010` | `Data_4D_5010` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_5010` | ChoiceMenu tiles |
| `4D:5110` | `Data_4D_5110` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_5110` | ChoiceMenu tiles |

The attribute map begins at `$5978`, after the 360-byte tilemap beginning at `$5810`, so its catalog row correctly retains its own address while naming the shared base symbol.

Running the documented generator on the byte-identical Japanese tree updated only ordering in `gfx/png_rules.tsv` and `gfx/png.mk`: all 950 records, asset paths, sizes, padding and original payload hashes are unchanged.
