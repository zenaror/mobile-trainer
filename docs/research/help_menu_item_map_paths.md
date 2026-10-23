# HelpMenu item-map resource paths

This unit moves the twelve original tilemap/attribute binaries for the six
HelpMenu item-rectangle objects to paths matching their existing semantic source
names. The owner remains `gfx/help/help_menu_bank6a.asm` in bank6A; it also holds
other help resources, so this unit does not rename the owner.

| Base | Basename (both `.tilemap` and `.attrmap`) | Pair bytes | Existing confidence |
|---|---|---:|---|
| `6A:4870` | `help_menu_page1_normal_items` | 420 | CONFIRMED |
| `6A:4A14` | `help_menu_page2_normal_items` | 180 | CONFIRMED |
| `6A:4AC8` | `help_menu_page3_normal_items` | 180 | CONFIRMED |
| `6A:4B7C` | `help_menu_page1_selected_items` | 420 | PROBABLE |
| `6A:4D20` | `help_menu_page2_selected_items` | 180 | CONFIRMED |
| `6A:4DD4` | `help_menu_page3_selected_items` | 180 | CONFIRMED |

The complete old/current paths are in
[`gfx_resource_path_map.tsv`](gfx_resource_path_map.tsv). The pair sizes total
1,560 bytes. Each file retains its original SHA-256, physical address, size,
packed dimensions and source/catalogue confidence. Ten stale `gfx/README.md`
inventory cells are corrected to the CONFIRMED status already present in the
source and `gfx/assets.tsv`; this is documentation reconciliation, not a new
semantic promotion. Page1-selected retains its PROBABLE classification.

## Positive consumers and limits

`engine/help/help_menu.asm` selects these existing source labels for the normal
and selected item rectangles on pages1–3. Its calls to
`Tilemap_CopyRectAndAttrPtr` copy a packed tile-index rectangle and its matching
attribute rectangle into `wScreenTileMap` and `wScreenAttrMap`. The page1 pairs
hold 21 rows x 10 columns per half; pages2/3 hold 9 rows x 10 columns per half. The
attribute source starts at pair base+$D2 or +$5A, respectively.

The normal page1 and page2/3 pairs have complete existing natural data-union
reads. The selected page1 pair retains the inherited360/420-byte read limit:
`6A:4C08–4C26` and `6A:4CDA–4CF8` belong to the locked item2 variant, whose
call was not observed naturally. Its name follows the demonstrated selector
structure, without claiming that the whole selected object was displayed.
Selected pages2/3 retain their existing complete180/180-byte read evidence.

These are packed item rectangles, not whole20x18 screens. No current
`gfx/screens.tsv` row selects these source paths, and no screen PNG or new
composition belongs to this unit. The source semantics and inherited evidence
are documented in [`naming2_neutral_help.md`](naming2_neutral_help.md).

## Integration and verification

`INCBIN` paths, `gfx/assets.tsv`, generated `gfx/png_rules.tsv` and
`gfx/png.mk`, the current inventory and the path map follow the migration.
The six existing semantic labels remain; the six redundant `Tilemap_6A_*`
source aliases are retired after active-root reference checks found only their
definitions. The owner contains no local labels, so retirement does not change
local-label qualification. Frozen `config/`, historical `analysis/`, and prior
research keep their original locators. No English sources, payloads
or build targets are changed.

The source migration requires `make` with the Japanese reference comparison,
`make sym-check`, `make palette-check`, `make png-check` and independent review
before publication. A matching ROM proves byte preservation for the build; it
does not add selector-domain, rendering, runtime or hardware evidence.
