# Keyboard panel tile paths by type and VRAM destination

This Japanese-only path pass renames nine address-only 2bpp tile basenames and their nine exact PNG sources in keyboard owners Bank 5D and Bank 5F. Each destination and keyboard type is already stated by a named owner label and confirmed static HDMA loader; shared Bank 5F tiles remain marked as shared. The files are path-only changes; their byte lengths, hashes, ROM extents, labels and CONFIRMED statuses are preserved. The English tree was not opened or edited.

| Old basename | New basename |
| --- | --- |
| `5D/tiles_4000` | `5D/keyboard_type4_vram8800_vb1_tiles` |
| `5D/tiles_4400` | `5D/keyboard_type4_vram8c00_vb1_tiles` |
| `5F/tiles_4000` | `5F/keyboard_type9_vram8800_vb1_tiles` |
| `5F/tiles_4400` | `5F/keyboard_type9_vram8c00_vb1_tiles` |
| `5F/tiles_4800` | `5F/keyboard_type9_vram9000_vb1_tiles` |
| `5F/tiles_49d0` | `5F/shared_keyboard_panel_vram8000_vb1_tiles` |
| `5F/tiles_5900` | `5F/keyboard_type5_vram8800_vb1_tiles` |
| `5F/tiles_5d00` | `5F/keyboard_type5_vram8c00_vb1_tiles` |
| `5F/tiles_6100` | `5F/keyboard_type5_vram9000_vb1_tiles` |
