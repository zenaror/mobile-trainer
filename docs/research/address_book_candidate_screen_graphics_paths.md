# Bank 2C candidate address-screen graphics paths

The Japanese Bank 2C graphics owner now uses descriptive filenames based on the static transfer roles visible in `AddrScreenCandidate_InitScreen`.

| ROM range | New path stem |
| --- | --- |
| `2C:7740–7860` | `address_screen_candidate_vram9300_vb1_tiles` |
| `2C:7860–79C8` | `address_screen_candidate_tilemap_20x18` |
| `2C:79C8–7B30` | `address_screen_candidate_attrmap_20x18` |
| `2C:7B30–7B70` | `address_screen_candidate_bg_palette` |
| `2C:7B70–7C00` | `address_screen_candidate_vram8000_tiles` |
| `2C:7C00–7C40` | `address_screen_candidate_obj_palette` |

The tile sheets expose the candidate text fragments `みる`, `START`, and `かく`; this content does not prove that the candidate routine is naturally reached. No object/frame paths or code labels changed. The `.screen.png` view is regenerated from the existing static loader record and remains a derived view, not execution evidence.
