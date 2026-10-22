# Bank 2C candidate address-screen graphics paths

The Japanese Bank 2C graphics owner now uses descriptive filenames based on the static transfer roles visible in `AddrScreenCandidate_InitScreen`. The `candidate` qualifier is retained: the routine is present in static flow, while the existing natural-scenario evidence does not establish its entry or screen role.

| ROM range | New path stem | Static evidence |
|---|---|---|
| `2C:7740–7860` | `address_screen_candidate_vram9300_vb1_tiles` | 288 bytes passed to the Bank 2C tile transfer at `2C:7499`, destination VRAM `$9300`, bank 1. |
| `2C:7860–79C8` | `address_screen_candidate_tilemap_20x18` | 360-byte tile map copied as 20 columns × 18 rows at `2C:74CD`. |
| `2C:79C8–7B30` | `address_screen_candidate_attrmap_20x18` | 360-byte attribute map paired with the tile map by the same copy routine. |
| `2C:7B30–7B70` | `address_screen_candidate_bg_palette` | 64 bytes loaded into the background palette buffer at `2C:749F`. |
| `2C:7B70–7C00` | `address_screen_candidate_vram8000_tiles` | 144 bytes passed to the Bank 2C tile transfer at `2C:74AB`, destination VRAM `$8000`. |
| `2C:7C00–7C40` | `address_screen_candidate_obj_palette` | 64 bytes loaded into the object palette buffer at `2C:74DE`. |

The tile sheets expose the candidate text fragments `みる`, `START`, and `かく`; this content does not prove that the candidate routine is naturally reached. No object/frame paths or code labels changed. The `.screen.png` view is regenerated from the existing static loader record and remains a derived view, not execution evidence.

The 8 renamed source/PNG files retain their original hashes. The direct old-to-new paths, including the generated screen view path, are recorded in `gfx_resource_path_map.tsv`.
