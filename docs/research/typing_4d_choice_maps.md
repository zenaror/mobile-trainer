# Bank4D choice-map confidence refinement

Four existing 140-byte units in `gfx/settings/screens_bank4d.asm` receive CONFIRMED headers and eight matching `gfx/assets.tsv` status cells. Each unit already consists of two 70-byte INCBIN assets. There is no new typing, name, alias, instruction, asset encoding or object boundary.

| Bank4D range (exclusive end) | Existing map label | Natural scenarios | Read / unread |
|---|---|---:|---:|
|5AE0–5B6C|Tilemap_SettingsPhone_ChoiceMenu_Entry0|3/69|140/0|
|5B6C–5BF8|Tilemap_SettingsPhone_ChoiceMenu_Entry1|2/69|140/0|
|5BF8–5C84|Tilemap_SettingsPhone_ChoiceMenu_Entry2|5/69|140/0|
|5C84–5D10|Tilemap_SettingsPhone_ChoiceMenu_Entry3|3/69|140/0|

`SettingsPhone_ChoiceMenu_LoadTilemap` selects a little-endian pointer from bank 67 table $491C. Its original four words are $5AE0, $5B6C, $5BF8 and $5C84. A zero/nonzero variant selects an offset of 0 or 2, then the cursor contributes to that index. The caller loads A=$4D and BC=$050E and farcalls `Tilemap_CopyRectAndAttr` at 67:4915. ROM0 routine 00:08EA selects ROM 4D and WRAM 7, copies 5 rows × 14 columns of tile indices and then the same 70 attribute bytes. Its destinations are $D063 and $D463, with row stride 32. This establishes exactly 140 bytes for each selected map pair. The existing four table words, RAM names and caller instructions remain unchanged. There is no proof of safety for arbitrary corrupt cursor values, and no new input-range claim.

All 140 bytes of each unit occur in original bank 4D ROM-read spans in the existing 69 detailed natural traces. Aggregate loader coverage is 73 hits in 6 scenarios; this count does not substitute for the four independent byte profiles. The full per-byte reads give the 3/2/5/3 scenario unions above. Both 70-byte fixed assets per unit match their exact original-ROM slices. HDMA alone, visual appearance and a sibling map were not used to establish these units.

The integral bank 4D review preceded this scoped change: 35 maintained units, 41 assets, 114 identifier rows, 29 unique immediate/computed call sites and 34 expanded source windows. The correct immediate census is 18 HDMA + 3 large-map + 4 palette + 2 sprite-root sites = 27. A 265-row bank-wide metadata union includes the original 165-row owner/context subset; the extra 100 rows are contextual candidate/PNG/historical matches. The frozen generator and mapper classifications remain historical inputs.

The other 31 unit headers retain their exact text/status. In particular, BG5510/7570 remain PROBABLE: their consumers copy 64 bytes across BG 40, adjacent OBJ 8 and map 16, so complete reads and RGB555 emission alone do not independently prove the 40-byte semantic boundary. HDMA overlaps remain explicit. Unread zero sprite entries, 13 bytes of padding, the unread third slot map $7910 and the 1661-byte zero tail are not promoted. The eligible slot maps and sprite chain are outside this four-map scope. Existing object/table-header editorial debts remain separate.

Only the four scoped source headers and eight existing asset status cells change outside documentation. Header wrapping adds 16 comment lines; all noncomment source lines remain identical. The maintained 289 TSV scan finds no active physical owner-file locators requiring updates. The 649 generic active records retain their exact source line and content; 25 bank 67 screen-operation consumer locators are unchanged. Completed historical narratives retain their old coordinates. See [verification](typing_4d_choice_maps_verify.md) for private build gates and integration limits.
