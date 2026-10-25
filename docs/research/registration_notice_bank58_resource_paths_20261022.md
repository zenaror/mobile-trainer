# Registration notice Bank 58 asset path names (2026-10-22)

This Japanese-only path pass replaces address-only filenames inside `gfx/registration/registration_notice_art_bank58/` with names supported by the existing owner labels and Bank 65 readers. It changes paths and catalog references only; it does not change any ROM payload, source label, extent, layout address or confidence level. The English translation directory was not opened or edited. Its old path references, if any, remain UNKNOWN until the Operator authorizes resuming that work.

`Notice_ShowPage` statically loads the 58:4000 tile prefix through `Gfx_StartHDMAWithService` to VRAM bank 1 at the `$9000` area. The same routine loads the 20×18 map at 58:7B78 for non-type-4 records, copies the 40-byte palette set at 58:7B50, and dispatches to the header reader. `Notice_LoadHeaderGfx` selects 3-byte source/bank entries from the table at 65:4A81 and loads 640-byte windows to VRAM bank 1; the footer table starts at 65:4AC9. Existing asset headers mark the respective tile groups and palette PROBABLE, so the new candidate names retain that limit and do not claim natural selection or display.

| Previous basename(s) | New basename(s) | Evidence level |
| --- | --- | --- |
| `tiles_4000.2bpp` / `tiles_4000.png` | `notice_scene_vram9000_vb1_tiles.2bpp` / `notice_scene_vram9000_vb1_tiles.png` | CONFIRMED transfer destination |
| `tiles_41d0.2bpp` / `tiles_41d0.png` | `notice_header_candidate_tiles_41d0.2bpp` / `notice_header_candidate_tiles_41d0.png` | PROBABLE candidate family; display not established |
| `tiles_4450.2bpp` / `tiles_4450.png` | `notice_header_candidate_tiles_4450.2bpp` / `notice_header_candidate_tiles_4450.png` | PROBABLE candidate family; display not established |
| `tiles_46d0.2bpp` / `tiles_46d0.png` | `notice_header_candidate_tiles_46d0.2bpp` / `notice_header_candidate_tiles_46d0.png` | PROBABLE candidate family; display not established |
| `tiles_4e50.2bpp` / `tiles_4e50.png` | `notice_header_candidate_tiles_4e50.2bpp` / `notice_header_candidate_tiles_4e50.png` | PROBABLE candidate family; display not established |
| `tiles_5350.2bpp` / `tiles_5350.png` | `notice_header_candidate_tiles_5350.2bpp` / `notice_header_candidate_tiles_5350.png` | PROBABLE candidate family; display not established |
| `tiles_5850.2bpp` / `tiles_5850.png` | `notice_header_candidate_tiles_5850.2bpp` / `notice_header_candidate_tiles_5850.png` | PROBABLE candidate family; display not established |
| `tiles_5ad0.2bpp` / `tiles_5ad0.png` | `notice_header_footer_candidate_tiles_5ad0.2bpp` / `notice_header_footer_candidate_tiles_5ad0.png` | PROBABLE candidate family; display not established |
| `tiles_6d40.2bpp` / `tiles_6d40.png` | `notice_footer_candidate_tiles_6d40.2bpp` / `notice_footer_candidate_tiles_6d40.png` | PROBABLE candidate family; display not established |
| `tiles_7460.2bpp` / `tiles_7460.png` | `notice_footer_candidate_tiles_7460.2bpp` / `notice_footer_candidate_tiles_7460.png` | PROBABLE candidate family; display not established |
| `tiles_7650.2bpp` / `tiles_7650.png` | `notice_footer_candidate_tiles_7650.2bpp` / `notice_footer_candidate_tiles_7650.png` | PROBABLE candidate family; display not established |
| `tiles_7790.2bpp` / `tiles_7790.png` | `notice_footer_candidate_tiles_7790.2bpp` / `notice_footer_candidate_tiles_7790.png` | PROBABLE candidate family; display not established |
| `palette_7b50.pal` | `notice_page_bg_palettes.pal` | PROBABLE palette set |
| `tilemap_7b78.tilemap` | `notice_page_58_tilemap_20x18.tilemap` | CONFIRMED static map load; 20×18 |
| `tilemap_7b78.attrmap` | `notice_page_58_attrmap_20x18.attrmap` | CONFIRMED static paired attribute load; 20×18 |

All 27 moved files preserve their original byte lengths and SHA-256 hashes. `gfx/assets.tsv`, `gfx/png_rules.tsv`, generated `gfx/png.mk` and `gfx/README.md`, the owner INCBIN/INCLUDE paths and `docs/research/gfx_resource_path_map.tsv` were synchronized. There is no screen preview PNG in this owner.

| Old path | New path | Bytes | SHA-256 |
| --- | --- | ---: | --- |
| `tiles_4000.2bpp` | `notice_scene_vram9000_vb1_tiles.2bpp` | 464 | `28720d3f5476d92f81ce9b36a4efbdfb6227dd3dadcece09d6ab82328381f7ed` |
| `tiles_4000.png` | `notice_scene_vram9000_vb1_tiles.png` | 403 | `68739a1b0325ca8d200b673c44bda1e1ef5b8bedc3facaf509671f0665ba9151` |
| `tiles_41d0.2bpp` | `notice_header_candidate_tiles_41d0.2bpp` | 640 | `7f00a8ce6208c3b4d9ee1b942169e8a1223d8fb7b1846579d1a767a4f764538a` |
| `tiles_41d0.png` | `notice_header_candidate_tiles_41d0.png` | 488 | `980645b6fdd0fb70bcbe5c727d6ad95f49314169a62be29a459cfa6839868e67` |
| `tiles_4450.2bpp` | `notice_header_candidate_tiles_4450.2bpp` | 640 | `02c22654b7a81ef293307c05727c86d5d45363ad4b2532dfe51ea1155714e0fd` |
| `tiles_4450.png` | `notice_header_candidate_tiles_4450.png` | 625 | `7668db3dde2a3c2dd53130886b33c02fba00808bdafdcc0417d54e11d15b700a` |
| `tiles_46d0.2bpp` | `notice_header_candidate_tiles_46d0.2bpp` | 1920 | `2c3648f5ce2eaa59dae7d638a5441f99efb56594add4d462a0f210ecdb47e4b0` |
| `tiles_46d0.png` | `notice_header_candidate_tiles_46d0.png` | 1302 | `2f190771328045cd53dd6076396589cbbdfccbcfb8a9934303671d1c683954de` |
| `tiles_4e50.2bpp` | `notice_header_candidate_tiles_4e50.2bpp` | 1280 | `48a762e835bd2e44036a6956b7078788f07d1bca932b5181ea1e6def730eac6d` |
| `tiles_4e50.png` | `notice_header_candidate_tiles_4e50.png` | 980 | `18d32a5e4fe0cfb101e249d2a9ed9f35ac274bcdd5704d2ccc04a158467160a5` |
| `tiles_5350.2bpp` | `notice_header_candidate_tiles_5350.2bpp` | 1280 | `c18d76d91c50856847fb7398c6e32d0eb8de13fa66627a8189aff5957300dbf1` |
| `tiles_5350.png` | `notice_header_candidate_tiles_5350.png` | 1043 | `eebc793223d319244a90468bd6f6f9176fd2f357c0c0f1a022bb40191dacd36f` |
| `tiles_5850.2bpp` | `notice_header_candidate_tiles_5850.2bpp` | 640 | `d59d9e95abb694f538d34c7c6a82b683b19832744ae3182e8020cc8d0fa33301` |
| `tiles_5850.png` | `notice_header_candidate_tiles_5850.png` | 595 | `699920c6d2b41998d1306a9552e79a16bf40505b92c150f55acc1297ae94b357` |
| `tiles_5ad0.2bpp` | `notice_header_footer_candidate_tiles_5ad0.2bpp` | 4720 | `697df7ac3c327b4d106378278c3b0e12502b13363000c8cda5a67acb85d6e708` |
| `tiles_5ad0.png` | `notice_header_footer_candidate_tiles_5ad0.png` | 2334 | `8f4f25efaf3ff403d9b492bd438f50addb1576ad6f58169258ac4fbc38311f5e` |
| `tiles_6d40.2bpp` | `notice_footer_candidate_tiles_6d40.2bpp` | 1824 | `ff4f45faf463251c33a6740f744cec90e067a291df43c4f71b5f89cd3cd38b28` |
| `tiles_6d40.png` | `notice_footer_candidate_tiles_6d40.png` | 494 | `6536d8ea75ef162e60bc44ca0c876909118cbf43960a1193abb44783e5d4dfe0` |
| `tiles_7460.2bpp` | `notice_footer_candidate_tiles_7460.2bpp` | 496 | `3709d49a7d7453fb9227392ce1e3f05c2d23ce1c75c2ed36d404ab87621212ed` |
| `tiles_7460.png` | `notice_footer_candidate_tiles_7460.png` | 275 | `790108c0eadb4202897c4bdd4889e2e82178b85a5db7e51e6aea7122838e2399` |
| `tiles_7650.2bpp` | `notice_footer_candidate_tiles_7650.2bpp` | 320 | `2db2c48803a46765801b951d390abd83faab5fa4a6317e388ad30776be6582ce` |
| `tiles_7650.png` | `notice_footer_candidate_tiles_7650.png` | 223 | `6d35a023b83d28efe1c58baccfa475cf23edcbc01bd6d37f022eb873e8aa5bc7` |
| `tiles_7790.2bpp` | `notice_footer_candidate_tiles_7790.2bpp` | 960 | `117380a37303baf2ba1d79fa5de3349a294885072907303f47d6cafe7f277d35` |
| `tiles_7790.png` | `notice_footer_candidate_tiles_7790.png` | 573 | `b96f246c7c7fcf9c36a9f00bb2e5a5dd47919045c3e6a62a164342a1b068b4d9` |
| `palette_7b50.pal` | `notice_page_bg_palettes.pal` | 324 | `8c01539fd764cd4489b28145e23801f4d0504f6bf3feaa6912a6a56e87051882` |
| `tilemap_7b78.tilemap` | `notice_page_58_tilemap_20x18.tilemap` | 360 | `caf0f87edb0ac733acdd9847bb2dc21de1111e24f1906e30479d6c1e9b0a5363` |
| `tilemap_7b78.attrmap` | `notice_page_58_attrmap_20x18.attrmap` | 360 | `f1bae3f093125bb665e4cbdf80aa2043599b2054ac3a5e367007ea2075c4cea5` |

Pre-change manifest: `BASELINE.json` (review artifact) (SHA-256 `f8eb87631cf1b6321b9ee6d481937da38f30b6b57e7a32e754cb81bcdb5ccd87`).

## Validation

- `make`: `SHA-256 OK`, 2,097,152-byte Japanese ROM, `RESULT: IDENTICAL` to the original (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
- `make sym-check`: 335 sources, 12,177 labels and 51 constants; passed.
- `make palette-check`: 162 loads, 116 arrays, two documented over-reads and zero errors; passed.
- `make png-check`, `python3 tools/gfx_export.py check`, `python3 tools/png_rules.py mk-check` and `git diff --check`: passed.
- A source/path audit verified all 27 moved files against the pre-change hashes, found no old operational paths in the Japanese owner/catalog/build metadata, and found a historical mapping for every old/new pair.

These checks validate this static source/path migration; they do not prove natural notice-page selection, display, hardware behavior English-path parity.
