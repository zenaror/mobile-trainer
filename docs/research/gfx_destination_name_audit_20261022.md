# Audited graphics destination names

The reviewed set contains 16 stems, 20 payloads and 33 physical files
(22,494 bytes). Each payload matches its original ROM extent. All 11 tile
PNG files invert to their `.2bpp` payloads. Static call arguments and the
HDMA helper were checked to distinguish source bank, destination VRAM
address and VRAM bank. The source edits change only `INCBIN` paths and one
stale comment; no label, caller, layout or binary payload changed.

| Old stem | Current stem | Static role |
|---|---|---|
| HelpScript `tiles_69f0` | `help_script_vram8000_vb0_tiles` | VRAM `$8000`, VBK 0, 32 bytes |
| HelpScript `tiles_6a10` | `help_script_vram8af0_vb1_tiles` | VRAM `$8AF0`, VBK 1, 16 bytes |
| HelpScript `tiles_6a20` | `help_script_vram8b00_vb1_tiles` | VRAM `$8B00`, VBK 1, 1,024 bytes |
| HelpScript `tilemap_6716` | `help_script_background` | 20×18 tile and attribute maps |
| HelpScript `palette_7220` | `help_script_bg_obj_palettes` | 128-byte RGB555 block loaded as 64-byte BG then 64-byte OBJ palettes |
| ResultPage `tiles_42d0` | `result_page_vram8800_vb1_tiles` | VRAM `$8800`, VBK 1, 1,024 bytes |
| ResultPage `tiles_46d0` | `result_page_vram8c00_vb1_tiles` | VRAM `$8C00`, VBK 1, 1,024 bytes |
| ResultPage `tilemap_5898` | `result_page_background` | 20×18 tile and attribute maps |
| SettingsMenu `tiles_4040` | `settings_menu_vram8000_vb1_tiles` | VRAM `$8000`, VBK 1, 512 bytes |
| SettingsMenu `tiles_4240` | `settings_menu_vram8800_vb1_tiles` | VRAM `$8800`, VBK 1, 1,024 bytes |
| SettingsMenu `tiles_4640` | `settings_menu_vram8c00_vb1_tiles` | VRAM `$8C00`, VBK 1, 1,024 bytes |
| SettingsMenu `tiles_4a40` | `settings_menu_vram9000_vb1_tiles` | VRAM `$9000`, VBK 1, 1,024 bytes |
| SettingsMenu `tiles_4e40` | `settings_menu_vram9400_vb1_tile_prefix` | 832-byte source prefix of a 1,024-byte HDMA read to VRAM `$9400`, VBK 1 |
| ManualConfirm `tiles_5870` | `manual_confirm_vram9000_vb1_tiles` | VRAM `$9000`, VBK 1, 1,024 bytes |
| FlagSet `tilemap_54a0` | `settings_menu_flag_set_background` | 20×18 tile and attribute maps, selected when `wHiddenModeFlag != 0` |
| ManualConfirm `tilemap_5cb0` | `manual_confirm_background` | 20×18 tile and attribute maps |

The `$4A:4E40` source is 832 bytes, while the HDMA request reads 1,024 bytes.
Its 192-byte tail consists of 40 bytes of BG palette data, 8 bytes of OBJ
palette data, 32 bytes of candidate OBJ ramp palette data and the first 112
bytes of the FlagClear tilemap. The prior region comment incorrectly called
the 32-byte candidate block a gap unread by code. The corrected comment says
that the HDMA read includes it and that no dedicated palette reader has been
identified. Its palette-slot association and visible use remain HYPOTHESIS.

The change also corrected a stale inventory locator for
`help_script_candidate_tiles_6e20`. Its existing candidate status is
unchanged. Generated graphics manifests and the two screen rows were updated;
screen composition confidence levels were preserved. The old-to-new paths
are recorded in `gfx_resource_path_map.tsv`.
