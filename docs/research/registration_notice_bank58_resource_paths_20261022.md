# Registration notice Bank 58 asset path names

This Japanese-only path pass replaces address-only filenames inside `gfx/registration/registration_notice_art_bank58/` with names supported by the existing owner labels and Bank 65 readers.

`Notice_ShowPage` statically loads the 58:4000 tile prefix through `Gfx_StartHDMAWithService` to VRAM bank 1 at the `$9000` area. The same routine loads the 20×18 map at 58:7B78 for non-type-4 records, copies the 40-byte palette set at 58:7B50, and dispatches to the header reader. `Notice_LoadHeaderGfx` selects 3-byte source/bank entries from the table at 65:4A81 and loads 640-byte windows to VRAM bank 1; the footer table starts at 65:4AC9. Existing asset headers mark the respective tile groups and palette PROBABLE, so the new candidate names retain that limit and do not claim natural selection or display.

| Previous basename(s) | New basename(s) |
| --- | --- |
| `tiles_4000.2bpp` / `tiles_4000.png` | `notice_scene_vram9000_vb1_tiles.2bpp` / `notice_scene_vram9000_vb1_tiles.png` |
| `tiles_41d0.2bpp` / `tiles_41d0.png` | `notice_header_candidate_tiles_41d0.2bpp` / `notice_header_candidate_tiles_41d0.png` |
| `tiles_4450.2bpp` / `tiles_4450.png` | `notice_header_candidate_tiles_4450.2bpp` / `notice_header_candidate_tiles_4450.png` |
| `tiles_46d0.2bpp` / `tiles_46d0.png` | `notice_header_candidate_tiles_46d0.2bpp` / `notice_header_candidate_tiles_46d0.png` |
| `tiles_4e50.2bpp` / `tiles_4e50.png` | `notice_header_candidate_tiles_4e50.2bpp` / `notice_header_candidate_tiles_4e50.png` |
| `tiles_5350.2bpp` / `tiles_5350.png` | `notice_header_candidate_tiles_5350.2bpp` / `notice_header_candidate_tiles_5350.png` |
| `tiles_5850.2bpp` / `tiles_5850.png` | `notice_header_candidate_tiles_5850.2bpp` / `notice_header_candidate_tiles_5850.png` |
| `tiles_5ad0.2bpp` / `tiles_5ad0.png` | `notice_header_footer_candidate_tiles_5ad0.2bpp` / `notice_header_footer_candidate_tiles_5ad0.png` |
| `tiles_6d40.2bpp` / `tiles_6d40.png` | `notice_footer_candidate_tiles_6d40.2bpp` / `notice_footer_candidate_tiles_6d40.png` |
| `tiles_7460.2bpp` / `tiles_7460.png` | `notice_footer_candidate_tiles_7460.2bpp` / `notice_footer_candidate_tiles_7460.png` |
| `tiles_7650.2bpp` / `tiles_7650.png` | `notice_footer_candidate_tiles_7650.2bpp` / `notice_footer_candidate_tiles_7650.png` |
| `tiles_7790.2bpp` / `tiles_7790.png` | `notice_footer_candidate_tiles_7790.2bpp` / `notice_footer_candidate_tiles_7790.png` |
| `palette_7b50.pal` | `notice_page_bg_palettes.pal` |
| `tilemap_7b78.tilemap` | `notice_page_58_tilemap_20x18.tilemap` |
| `tilemap_7b78.attrmap` | `notice_page_58_attrmap_20x18.attrmap` |
