# Bank 4D choice/slot-menu graphics paths

## Tile source naming

Each new base is `choice_menu_` or `slot_menu_`, followed by the VRAM destination, VRAM bank (`vb1`), and the source address. The five entries marked `slice` begin inside larger uploads, so their destination includes the source-relative offset; the suffix preserves the start of the stored slice.

| Old basename | New basename | Source range | Upload destination |
|---|---|---:|---:|
| `tiles_4000` | `choice_menu_tiles8000_vb1_4000` | `4D:4000–4200` | `8000` |
| `tiles_4200` | `choice_menu_tiles88f0_vb1_slice_4200` | `4D:4200–4510` | `88F0` |
| `tiles_4510` | `choice_menu_tiles8c00_vb1_4510` | `4D:4510–4610` | `8C00` |
| `tiles_4610` | `choice_menu_tiles9000_vb1_4610` | `4D:4610–4A10` | `9000` |
| `tiles_4a10` | `choice_menu_tiles9400_vb1_4a10` | `4D:4A10–4D10` | `9400` |
| `tiles_4d10` | `choice_menu_tiles8900_vb1_slice_4d10` | `4D:4D10–5010` | `8900` |
| `tiles_5010` | `choice_menu_tiles8c00_vb1_5010` | `4D:5010–5110` | `8C00` |
| `tiles_5110` | `choice_menu_tiles9000_vb1_5110` | `4D:5110–5510` | `9000` |
| `tiles_5d50` | `slot_menu_tiles8000_vb1_5d50` | `4D:5D50–5D70` | `8000` |
| `tiles_5d70` | `slot_menu_tiles8800_vb1_5d70` | `4D:5D70–6170` | `8800` |
| `tiles_6170` | `slot_menu_tiles8c00_vb1_6170` | `4D:6170–6570` | `8C00` |
| `tiles_6570` | `slot_menu_tiles9100_vb1_slice_6570` | `4D:6570–6870` | `9100` |
| `tiles_6870` | `slot_menu_tiles9400_vb1_6870` | `4D:6870–6C70` | `9400` |
| `tiles_6c70` | `slot_menu_tiles8b00_vb1_slice_6c70` | `4D:6C70–6D70` | `8B00` |
| `tiles_6d70` | `slot_menu_tiles8c00_vb1_6d70` | `4D:6D70–7170` | `8C00` |
| `tiles_7170` | `slot_menu_tiles9100_vb1_slice_7170` | `4D:7170–7470` | `9100` |
| `tiles_7470` | `slot_menu_tiles9400_vb1_7470` | `4D:7470–7570` | `9400` |

The owners at `gfx/settings/phone_choice_and_slot_menus_bank4d.asm` retain their existing evidence status and labels. The names describe the statically identified ROM-to-VRAM copies and do not assert that every block appears in a naturally rendered frame. The five clipped-slice destinations account for the offset between each source start and the larger upload's start; `home/gfx_upload.asm:52–83` supplies the destination/VBK decoding, and `gfx/screens.tsv` records the corresponding source-relative runs.

## Map and preview paths

| Old basename | New basename | Original range |
| --- | --- | ---: |
| `tilemap_5810` | `settings_phone_choice_menu_4d_5810` | `4D:5810`, tilemap + attributes |
| `tilemap_7870` | `settings_phone_slot_menu_tab0_4d_7870` | `4D:7870`, tilemap + attributes |
| `tilemap_78c0` | `settings_phone_slot_menu_tab1_4d_78c0` | `4D:78C0`, tilemap + attributes |
| `tilemap_7910` | `settings_phone_slot_menu_tab2_4d_7910` | `4D:7910`, tilemap + attributes |
| `tilemap_5810.screen.png` | `settings_phone_choice_menu_4d_5810.screen.png` | derived preview |

## Byte and metadata invariants

Generated `gfx/png_rules.tsv`, `gfx/png.mk` and `gfx/README.md` preserve the existing sizes, hashes, padding (`tiles_4200` keeps 15 blank tiles), labels, banks, addresses, and confidence values.
