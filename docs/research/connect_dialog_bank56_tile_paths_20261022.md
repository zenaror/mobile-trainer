# Connect-dialog Bank 56 tile paths (2026-10-22)

This Japan-only asset-path pass replaces 11 address-only tile basenames and their paired PNG source paths in Bank 56. The new names describe the existing ConnectDialog consumer family and the static VRAM destination. All 22 files retain their original bytes, sizes, and SHA-256 values; no tile pixels, transfer lengths, labels, or ROM bytes changed.

| Old stem | New stem | Static evidence |
| --- | --- | --- |
| `tiles_52c0` | `connect_dialog_connect_confirm_tiles_9000_vb1` | CONFIRMED: Bank 57 `$47DD` loads Bank 56 `$52C0`, 1,024 bytes, to VRAM bank 1 `$9000–$93FF`. |
| `tiles_56c0` | `connect_dialog_connect_confirm_tiles_9400_vb1` | CONFIRMED: `$47EF` loads `$56C0`, 1,024 bytes, to VRAM bank 1 `$9400–$97FF`. |
| `tiles_5ac0` | `connect_dialog_password_entry_and_save_confirm_tiles_8800_vb0` | CONFIRMED: `$496A` and `$4ADB` load `$5AC0`, 768 bytes, to VRAM bank 0 `$8800–$8AFF`. |
| `tiles_5dc0` | `connect_dialog_password_entry_and_save_confirm_tiles_9100_vb1` | CONFIRMED: `$498E` and `$4AFF` load `$5DC0`, 768 bytes, to VRAM bank 1 `$9100–$93FF`. |
| `tiles_60c0` | `connect_dialog_password_entry_and_save_confirm_tiles_9400_vb1` | CONFIRMED: `$49A0` and `$4B11` load `$60C0`, 1,024 bytes, to VRAM bank 1 `$9400–$97FF`. |
| `tiles_64c0` | `connect_dialog_stored_password_tiles_shared_source` | CONFIRMED: `$4E58` loads 1,024 bytes from `$64C0` to VRAM bank 0 `$8800–$8BFF`; the final 256 bytes also feed the following transfer. |
| `tiles_68c0` | `connect_dialog_stored_password_tiles_9200_vb1_continuation` | CONFIRMED: this 512-byte source slice completes the HDMA started at `$67C0`; it supplies VRAM bank 1 `$9200–$93FF`, not `$9100`. |
| `tiles_6ac0` | `connect_dialog_stored_password_tiles_9400_vb1` | CONFIRMED: `$4E7C` loads `$6AC0`, 1,024 bytes, to VRAM bank 1 `$9400–$97FF`. |
| `tiles_6ec0` | `connect_dialog_password_saved_tiles_9100_vb1` | CONFIRMED: `$4D4C` loads `$6EC0`, 768 bytes, to VRAM bank 1 `$9100–$93FF`. |
| `tiles_71c0` | `connect_dialog_password_saved_tiles_9400_vb1` | CONFIRMED: `$4D5E` loads `$71C0`, 1,024 bytes, to VRAM bank 1 `$9400–$97FF`. |
| `tiles_75c0` | `connect_dialog_common_finish_tiles_8000_vb0` | CONFIRMED: `$5083` and `$50E4` load `$75C0`, 512 bytes, to VRAM bank 0 `$8000–$81FF`; “common finish” names the shared drawing tail only. |

The destination/VBK decoding is supported by the loader at ROM0 `$0787`: E bit 0 selects VRAM bank, E masked with `$F0` supplies the destination, and C encodes the transfer length. These names do not claim natural execution, rendered appearance, or behavior on hardware. In particular, the split `64C0/68C0` source and its transfer overlap are preserved exactly; do not merge or reorder these slices.

The independent review used a curated 34-file snapshot of base `0f57cd8fbe581c9b66a7c723ee3309045c847c8b`; every file matched its manifest. It independently checked the ROM hash, all 11 physical ROM slices and asset-manifest hashes, and decoded each PNG in memory to confirm its pixels reconstruct the paired `.2bpp`. The original ROM SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

The durable pre-change inventory is `.tmp/jp-connect-dialog-tile-paths-20261022/BASELINE.json`. `docs/research/gfx_resource_path_map.tsv` records all 22 old-to-new paths. The maintenance owner and generated graphics catalogs were synchronized; validation results are recorded in the current Git checkpoint and OMM handoff. No English or ZIP-derived material was inspected or changed.
