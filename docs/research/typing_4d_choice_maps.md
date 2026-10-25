# Bank4D choice-map confidence refinement

Four existing 140-byte units in `gfx/settings/screens_bank4d.asm` receive CONFIRMED headers and eight matching `gfx/assets.tsv` status cells.

| Bank4D range (exclusive end) | Existing map label | Read / unread |
| --- | --- | ---: |
| 5AE0–5B6C | Tilemap_SettingsPhone_ChoiceMenu_Entry0 | 140/0 |
| 5B6C–5BF8 | Tilemap_SettingsPhone_ChoiceMenu_Entry1 | 140/0 |
| 5BF8–5C84 | Tilemap_SettingsPhone_ChoiceMenu_Entry2 | 140/0 |
| 5C84–5D10 | Tilemap_SettingsPhone_ChoiceMenu_Entry3 | 140/0 |

`SettingsPhone_ChoiceMenu_LoadTilemap` selects a little-endian pointer from bank 67 table $491C.

The caller loads A=$4D and BC=$050E and farcalls `Tilemap_CopyRectAndAttr` at 67:4915.

ROM0 routine 00:08EA selects ROM 4D and WRAM 7, copies 5 rows × 14 columns of tile indices and then the same 70 attribute bytes.

Its destinations are $D063 and $D463, with row stride 32.

The other 31 unit headers retain their exact text/status. In particular, BG5510/7570 remain PROBABLE: their consumers copy 64 bytes across BG 40, adjacent OBJ 8 and map 16, so complete reads and RGB555 emission alone do not independently prove the 40-byte semantic boundary. HDMA overlaps remain explicit. Unread zero sprite entries, 13 bytes of padding, the unread third slot map $7910 and the 1661-byte zero tail are not promoted. The eligible slot maps and sprite chain are outside this four-map scope. Existing object/table-header editorial debts remain separate.
