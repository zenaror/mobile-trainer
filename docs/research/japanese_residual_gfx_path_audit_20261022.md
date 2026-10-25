# Japanese residual graphics path audit (2026-10-22)

This checkpoint resolves the final 44 exact address-only graphics filename stems found in the Japanese tree. Three static audits covered the disjoint Bank 71 account/registration owners, Bank 50 CommNotice owner, and Bank 5F keyboard panel owner. All proposed names are bounded to existing source labels, readers, transfer extents, destinations, and formats. They describe static associations; they do not prove natural execution or complete visual composition.

The audits used private exports of `zenaror/mobile-trainer` at `6340fbe61bc5a03512ad7e666acc95a343388be6` and checked the supplied immutable Japan ROM (2,097,152 bytes; SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`). The private exports excluded `.git`, build, and `.tmp`; the agents made no edits, ran no builds, and did not open the English tree or ZIP.

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

The 17 files had positive static owner/reader links; all 23 payloads exactly match their declared ROM slices and manifest lengths. The Bank 71 resources include overlapping/shared sources, so names use `shared_source` or `slice` where needed. `tiles_4500` is 57 tiles/912 bytes with seven display-sheet padding slots; `tiles_4890` is 0x3C0 bytes while its transfer continues for 0x400 bytes into the adjacent palette. `tiles_5dc0` also participates in execution uploads. `tilemap_6f6f` is selected in the nonzero password-save-confirm branch but remains PROBABLE because natural execution is unobserved. The other 16 payload/path associations remain CONFIRMED at the static owner/transfer level.

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

The remaining `tiles_5860` legacy pair was renamed `settings_menu_cursor_frames_anim_script_byteview_4a_5860` (`.2bpp` and `.png`). It is a 16-byte byte-view of two OAM frames, a two-step animation script, and five trailing zero bytes at `4A:5860–5870`; it is not tile art and remains outside the active asset catalogue. SHA-256 values are unchanged: raw bytes `68801625e95363bd79c1370472e8ccad7f9b93e2e929930f78610232787fbd91`, PNG `5680705a91e0e2fb90a25f993d78cf21be4cda9ef69dee7d95492cb10c716716`.

### Reproducibility and limits

The 43 stems in the three groups above moved 84 physical files (46,451 bytes). Every new path matches its PRE_MOVE size and SHA-256. The two Bank 4A byte-view files also retain their recorded hashes. `gfx/assets.tsv`, `gfx/screens.tsv`, `gfx/png_rules.tsv`, `gfx/png.mk`, generated `gfx/README.md`, four source owners, and the historical path map were synchronized. The strict maintained-tree filename scan now finds zero stems matching `tiles_XXXX`, `tilemap_XXXX`, `attrmap_XXXX`, or `palette_XXXX`.

Validation on the integrated tree: `make` returned SHA-256 OK and `RESULT: IDENTICAL` to the original ROM; `make sym-check` passed (335 source files, 12,177 labels, 51 constants); `make palette-check` passed (162 loads, 116 arrays, two documented overreads, zero errors); `make png-check` passed (408 tile sheets, four raw views, 37 font sheets, 95 screens); `python3 tools/gfx_export.py check`, `python3 tools/png_rules.py mk-check`, and `git diff --check` passed. The build output SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

The ordered migration manifest is `PRE_MOVE.json` (review artifact) (SHA-256 `6028dbc30ea9deefe3e3beae2a246591cf3091dea36132e45a67a09c762ecc71`) and its verified counterpart is `POST_MOVE.json` (SHA-256 `9f5bec1ebd222aa818d6a680a844144b89394972e7dc64241e1711e6c24c3486`). These static path checks do not establish natural runtime selection, sprite meaning beyond existing labels, or hardware behavior. No ROM source bytes or graphic payload bytes changed.
