# Japanese residual graphics path reference

### Bank 71 account, registration delete, and password-save confirmation

| Previous stem | Current stem | Status |
| --- | --- | --- |
| `tiles_4000` | `comm_panel_tiles8000_vb0_shared_source_4000` | CONFIRMED |
| `tiles_4300` | `comm_panel_shared_vram_source_4300` | CONFIRMED |
| `tiles_4500` | `comm_panel_tiles9070_vb1_slice_4500` | CONFIRMED |
| `tiles_4890` | `comm_panel_tiles9400_vb1_slice_4890` | CONFIRMED |
| `tilemap_4c98` | `comm_panel_bgmap_20x18_4c98` | CONFIRMED |
| `tilemap_4f68` | `comm_panel_bgmap_rows16_17_4f68` | CONFIRMED |
| `tiles_5340` | `registration_delete_confirm_variant0_tiles9000_vb1_5340` | CONFIRMED |
| `tiles_5740` | `registration_delete_confirm_shared_vram_source_5740` | CONFIRMED |
| `tiles_5b40` | `registration_delete_confirm_variant_nonzero_tiles9180_vb1_slice_5b40` | CONFIRMED |
| `tiles_5dc0` | `registration_delete_tiles9400_vb1_shared_source_5dc0` | CONFIRMED |
| `tiles_61c0` | `registration_delete_execute_tiles8080_vb0_and_8840_vb1_slice_61c0` | CONFIRMED |
| `tiles_6440` | `registration_delete_execute_tiles8ac0_vb1_slice_6440` | CONFIRMED |
| `tiles_6580` | `registration_delete_execute_tiles9000_vb1_6580` | CONFIRMED |
| `tilemap_66c8` | `registration_delete_confirm_variant0_bgmap_66c8` | CONFIRMED |
| `tilemap_6998` | `registration_delete_confirm_variant_nonzero_bgmap_6998` | CONFIRMED |
| `tilemap_6c68` | `registration_delete_execute_bgmap_6c68` | CONFIRMED |
| `tilemap_6f6f` | `password_save_confirm_variant_nonzero_bgmap_6f6f` | PROBABLE |

The Bank 71 resources include overlapping/shared sources, so names use `shared_source` or `slice` where needed.

`tiles_4500` is 57 tiles/912 bytes with seven display-sheet padding slots; `tiles_4890` is 0x3C0 bytes while its transfer continues for 0x400 bytes into the adjacent palette.

`tilemap_6f6f` is selected in the nonzero password-save-confirm branch but remains PROBABLE because natural execution is unobserved.

### CommNotice / Bank 50

| Previous stem | Current stem | Status |
| --- | --- | --- |
| `attrmap_4502` | `comm_notice_a_cut_over60` | PROBABLE |
| `attrmap_47d2` | `comm_notice_a_ask_over60` | PROBABLE |
| `attrmap_4aa2` | `comm_notice_a_cut_soon` | PROBABLE |
| `attrmap_4d72` | `comm_notice_a_ask_soon` | CONFIRMED |
| `attrmap_5042` | `comm_notice_b_cut_over60` | PROBABLE |
| `attrmap_5312` | `comm_notice_b_ask_over60` | PROBABLE |
| `attrmap_55e2` | `comm_notice_b_cut_soon` | PROBABLE |
| `attrmap_58b2` | `comm_notice_b_ask_soon` | PROBABLE |
| `palette_6bc0` | `comm_notice_bg_obj_palettes` | PROBABLE |
| `tiles_5a20` | `comm_notice_a_tiles_vram0_9000` | CONFIRMED |
| `tiles_5e20` | `comm_notice_a_tiles_vram0_9400` | CONFIRMED |
| `tiles_5fc0` | `comm_notice_a_tiles_vram1_8000` | CONFIRMED |
| `tiles_5fd0` | `comm_notice_a_tiles_vram1_9000` | CONFIRMED |
| `tiles_62f0` | `comm_notice_b_tiles_vram0_9000` | PROBABLE |
| `tiles_66f0` | `comm_notice_b_tiles_vram0_9400` | PROBABLE |
| `tiles_6890` | `comm_notice_b_tiles_vram1_8000` | PROBABLE |
| `tiles_68a0` | `comm_notice_b_tiles_vram1_9000` | PROBABLE |

The eight maps and attribute maps form paired 20×18 blocks copied into WRAM buffers; their paths distinguish screen family A/B and the cut/ask and over-60/soon records where supported by the existing selector table. The shared 256-byte palette set contains four 64-byte BG-A/B and OBJ-A/B windows; it is kept as one file. No overread was found in these 17 payloads. Three A/B tile pairs are byte-identical at distinct ROM origins and remain separate to preserve address provenance. The eight A tile blocks and `attrmap_4d72` retain CONFIRMED classifications; the remaining 12 rows retain PROBABLE classifications. None establishes a complete final screen.

### Keyboard panel graphics / Bank 5F

| Previous stem | Current stem | Status |
| --- | --- | --- |
| `palette_4cd0` | `shared_panel_bg6_7_obj5_7_palettes` | CONFIRMED |
| `palette_6bb8` | `keyboard_type5_bg1_bg6_7_palettes` | PROBABLE |
| `tilemap_4810` | `keyboard_type9_panel` | CONFIRMED |
| `tilemap_4ecb` | `keyboard_type0_panel` | CONFIRMED |
| `tilemap_50d3` | `keyboard_type1_panel` | CONFIRMED |
| `tilemap_52db` | `keyboard_type4_panel` | CONFIRMED |
| `tilemap_54e3` | `keyboard_type2_panel` | CONFIRMED |
| `tilemap_56eb` | `keyboard_type3_panel` | CONFIRMED |
| `tilemap_69b0` | `keyboard_type5_panel` | CONFIRMED |

The seven tilemap/attribute pairs are named by keyboard type and keep paired formats under one stem. Tilemaps stage 20 columns per row in WRAM7; loaders transfer wider rows using the selected `LCDC` map base, so the filenames intentionally do not claim a fixed VRAM map address. The first palette is shared across nine consumers; the other palette supplies BG1 and BG6–7, not BG1 alone. `palette_6bb8` remains PROBABLE; the other eight paths remain CONFIRMED static associations. Attribute maps for types 3 and 4 have equal bytes but distinct ROM locations and remain separate.

### Bank 4A retained byte-view

It is a 16-byte byte-view of two OAM frames, a two-step animation script, and five trailing zero bytes at `4A:5860–5870`; it is not tile art and remains outside the active asset catalogue.
