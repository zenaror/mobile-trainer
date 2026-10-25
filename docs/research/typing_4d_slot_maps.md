# Bank4D slot-map confidence refinement

Two existing 80-byte units in `gfx/settings/screens_bank4d.asm` receive CONFIRMED headers and four matching `gfx/assets.tsv` status cells. Each already consists of two 40-byte INCBIN assets. Names, aliases, instructions, geometry and all original bytes are unchanged.

| Original bank 4D range (exclusive end) | Existing label | Natural read / unread |
| --- | --- | ---: |
| 7870–78C0 | Tilemap_SettingsPhone_SlotMenu_Tab0 | 80/0 |
| 78C0–7910 | Tilemap_SettingsPhone_SlotMenu_Tab1 | 80/0 |
| 7910–7960 | Tilemap_SettingsPhone_SlotMenu_Tab2 | 0/80 |

`SettingsPhone_SlotMenu_LoadTabTilemap` at 67:50E5 reads fixed-WRAM C27D through the existing wSlotMenu_Cursor alias. Bank 67 table $5104 has three original words: $7870, $78C0 and $7910. The caller loads DE=$D0E0 and BC=$0214, fetches a source pointer, loads A=$4D and farcalls `Tilemap_CopyRectAndAttr` at 67:50FD. The ROM0 routine 00:08EA selects ROM 4D and WRAM 7, copies two rows of 20 tile bytes, then continues the source pointer for 40 attribute bytes at destination+$400. Tile row starts are $D0E0/D100; attribute row starts $D4E0/D500; stride 32. This proves the 80-byte map/attribute format and extent, without an HDMA or visual inference.

The selector doubles the cursor in 8-bit A before adding it to the pointer-table base. Setup restores SRAM 1 $BF03 into C27D without validating it before the map read. Movement handlers have conditional two-choice XOR and three-choice wrap paths; physical three-word storage and initialized cursor behavior do not establish a universal bound for arbitrary SRAM bytes. Values 128..255 may alias wrapped offsets. Existing RAM names and contracts are preserved; no generic index-safety claim is added.

The preceding $75A0 map and HDMA $7470 window end exactly $7870; no immediate bank 4D request overlaps these three slot-map units.

Existing mixed HDMA windows and BG palette overread contracts remain intact elsewhere.

The later $7968 chain is a separate step before bank 4E.
