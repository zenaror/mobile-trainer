# Bank 70 communication-scene graphics path audit (2026-10-22)

## Scope and result

This read-only audit covers `gfx/comm/comm_scene/` and its Japanese source
consumers. The owner and its section already have semantic names; the remaining
address-only paths are 28 ROM payloads plus nine PNG views. The payloads occupy
one contiguous original-ROM interval, `70:5490–7590`, totaling 8,448 bytes.
Every emitted payload was compared with its physical-bank slice in the original
ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
The eight tile PNGs were decoded in memory and their pixel indices reconstructed
the matching `.2bpp` files. No PNG or source file was written by the audits.

Two independent read-only reviews agreed on the ROM extents, transfer
boundaries, map/table identities, and asset hashes. Palette text files were
emitted according to the RGB555 macro before comparing their 64-byte payloads.
The audit did not build a renamed tree or prove behavior from runtime/hardware.

## Conservative basename plan

The table gives proposed basenames within `gfx/comm/comm_scene/`; extensions
remain unchanged and each `.png` follows its `.2bpp` source.

| Current basename | Proposed basename | Static evidence and limit |
|---|---|---|
| `tiles_5490` | `tiles_vram0_8000` | **CONFIRMED**: `70:5490`, 1,024 bytes transferred to VRAM bank 0 `$8000–$83FF`. |
| `tiles_5890` | `tiles_vram0_8400` | **CONFIRMED**: `70:5890`, 1,024 bytes to VBK0 `$8400–$87FF`. |
| `tiles_5c90` | `tiles_vram0_8800` | **CONFIRMED**: `70:5C90`, 1,024 bytes to VBK0 `$8800–$8BFF`. |
| `tiles_6090` | `tiles_vram0_8c00` | **CONFIRMED**: `70:6090`, 1,024 bytes to VBK0 `$8C00–$8FFF`. |
| `tiles_6490` | `tiles_shared_source0` | **CONFIRMED**: the 512-byte source slice participates in VBK0 `$9000–$91FF` and VBK1 `$8000–$81FF` windows. A single destination name would be misleading. |
| `tiles_6690` | `tiles_shared_source1` | **CONFIRMED**: 512-byte slice used for VBK1 `$8200–$83FF` and `$9000–$91FF`. |
| `tiles_6890` | `tiles_shared_source2` | **CONFIRMED**: 512-byte slice used for VBK1 `$8400–$85FF` and `$9200–$93FF`. |
| `tiles_6a90` | `tiles_vram1_9400_prefix` | **CONFIRMED**: the file contains only the first 512 bytes of a transfer beginning at VBK1 `$9400`. The 1,024-byte DMA continues through both palettes and the first `$180` bytes of the background map; do not extend this tiles file to the DMA length. |
| `palette_6c90` | `bg_palettes` | **CONFIRMED**: 64 emitted RGB555 bytes copied to `wPaletteBufBg`; no visual interpretation implied. |
| `palette_6cd0` | `obj_palettes` | **CONFIRMED**: 64 emitted RGB555 bytes copied to `wPaletteBufObj`. |
| `tilemap_6d10` | `background` | **CONFIRMED**: 32×14 tile IDs at `70:6D10`, paired with 32×14 attributes at `70:6ED0`; copied through the work buffers to BG maps. The associated `.screen.png` remains a derived preview, with signed/unsigned interpretation **HYPOTHESIS**. |
| `tilemap_7090` | `text_box_table_entry_0` | **CONFIRMED**: pointer-table entry 0 at `70:4822`, tile IDs at `7090`, attributes at `70E0`; 20×4 cells. Kind/phase description remains **PROBABLE**. |
| `tilemap_7130` | `text_box_table_entry_1` | **CONFIRMED**: entry 1, IDs at `7130`, attributes at `7180`; 20×4. Kind/phase description remains **PROBABLE**. |
| `tilemap_71d0` | `text_box_table_entry_2` | **CONFIRMED**: entry 2, IDs at `71D0`, attributes at `7220`; 20×4. Kind/phase description remains **PROBABLE**. |
| `tilemap_7270` | `text_box_table_entry_3` | **CONFIRMED**: entry 3, IDs at `7270`, attributes at `72C0`; 20×4. Kind/phase description remains **PROBABLE**. |
| `tilemap_7310` | `text_box_table_entry_4` | **CONFIRMED**: entry 4, IDs at `7310`, attributes at `7360`; 20×4. Kind/phase description remains **PROBABLE**. |
| `tilemap_73b0` | `text_box_table_entry_5` | **CONFIRMED**: entry 5, IDs at `73B0`, attributes at `7400`; 20×4. Kind/phase description remains **PROBABLE**. |
| `tilemap_7450` | `text_box_table_entry_6` | **CONFIRMED**: entry 6, IDs at `7450`, attributes at `74A0`; observed by two cancel/branch callers. |
| `tilemap_74f0` | `text_box_table_entry_7` | **CONFIRMED** only as entry 7 in the eight-pointer table, IDs at `74F0`, attributes at `7540`; no selecting caller with A=7 was found. The name describes table position, not use. |

All eight attribute maps are 80 bytes containing `$08` and have identical
SHA-256 `c0532654c2b6c5caa434dce2023fc6dda7f091f8e45d5b8c0ab5cd656b6e93f7`.
This equality alone does not justify deduplicating files.

## Source references and verification boundary

Static transfer arguments are in `engine/comm/comm_scene.asm:652–720`;
the text-box pointer table is `gfx/comm/comm_scene.asm:9–18`, and the loader is
`engine/comm/comm_scene.asm:1055–1074`. `home/gfx_upload.asm:52–85` establishes
VRAM-bank selection and block length; its rectangle-pair copier at `300–340`
explains the second `$400`-offset attribute pass. The fixed owner section remains
at `layout.link:727–731`; basename-only changes need no section or caller change.

If these basenames are migrated later, update all six Japanese references:
`gfx/comm/comm_scene.asm`, `gfx/assets.tsv`, `gfx/png_rules.tsv`, `gfx/png.mk`,
`gfx/screens.tsv`, and the generated catalog in `gfx/README.md`. The PNG build
rules are generated from `tools/png_rules.py`; preserve that ownership. Do not
rewrite the stale line references in `gfx/previews/screen_ops.tsv` as loader
evidence.

The translation tree was excluded from both audit copies and was not inspected.
Therefore Japanese-only ownership of these paths is **UNKNOWN**. No path was
renamed in this checkpoint. Keep the translation paused and verify any shared
references before a future path migration; this report does not authorize
changing the language patch. Main sources and asset paths are unchanged.
