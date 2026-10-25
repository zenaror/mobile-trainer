# Keyboard panel tile paths by type and VRAM destination (2026-10-22)

This Japanese-only path pass renames nine address-only 2bpp tile basenames and their nine exact PNG sources in keyboard owners Bank 5D and Bank 5F. Each destination and keyboard type is already stated by a named owner label and confirmed static HDMA loader; shared Bank 5F tiles remain marked as shared. The files are path-only changes; their byte lengths, hashes, ROM extents, labels and CONFIRMED statuses are preserved. The English tree was not opened or edited.

| Old basename | New basename | Static evidence |
| --- | --- | --- |
| `5D/tiles_4000` | `5D/keyboard_type4_vram8800_vb1_tiles` | T4 loader, VBK1 `$8800`, 1,024 bytes |
| `5D/tiles_4400` | `5D/keyboard_type4_vram8c00_vb1_tiles` | T4 loader, VBK1 `$8C00`, 1,024 bytes |
| `5F/tiles_4000` | `5F/keyboard_type9_vram8800_vb1_tiles` | T9 loader, VBK1 `$8800`, 1,024 bytes |
| `5F/tiles_4400` | `5F/keyboard_type9_vram8c00_vb1_tiles` | T9 loader, VBK1 `$8C00`, 1,024 bytes |
| `5F/tiles_4800` | `5F/keyboard_type9_vram9000_vb1_tiles` | T9 loader, VBK1 `$9000`, 16 bytes |
| `5F/tiles_49d0` | `5F/shared_keyboard_panel_vram8000_vb1_tiles` | Shared-panel label and eight static call sites, VBK1 `$8000`, 768 bytes |
| `5F/tiles_5900` | `5F/keyboard_type5_vram8800_vb1_tiles` | T5 loader, VBK1 `$8800`, 1,024 bytes |
| `5F/tiles_5d00` | `5F/keyboard_type5_vram8c00_vb1_tiles` | T5 loader, VBK1 `$8C00`, 1,024 bytes |
| `5F/tiles_6100` | `5F/keyboard_type5_vram9000_vb1_tiles` | T5 loader, VBK1 `$9000`, 256 bytes |

Each row also includes the neighboring `.png` exact source. Owner INCBIN paths, `gfx/assets.tsv`, `gfx/screens.tsv`, generated PNG rules/Makefile and GFX README were synchronized. All 18 files match their pre-change SHA-256 and size. The historical path map records all 18 direct old-to-new paths.

Validation: `make` returned `SHA-256 OK` and `RESULT: IDENTICAL` for the 2,097,152-byte Japanese ROM (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check`, `make palette-check`, `make png-check`, `gfx_export check`, `png_rules mk-check`, and `git diff --check` passed. These results validate the path migration, not new runtime/hardware behavior English parity.

Pre-change manifest: `BASELINE.json` (review artifact) (SHA-256 `bd2f9fd7671c2b7d42374f0b7e8676992749416b90216dab13c3dcb8897d043e`).
