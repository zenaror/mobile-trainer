# Japanese Profile initial-screen tile slice at 26:7840

## Finding

The 624-byte interval at ROM bank 26 address 7840 is not an isolated asset with no located reader. It is an interior slice of a statically requested Profile_InitScreen HDMA transfer. The earlier no-transfer statement searched for a transfer beginning exactly at 26:7840 and missed the larger request beginning at 26:7820. This correction supersedes that negative conclusion.

## Exact interval mapping

All intervals are half-open. The request at `engine/profile/profile_editor.asm:508–513` sets `DE=$8000`, `HL=Gfx_Profile_Tiles8000` at `26:7820`, source bank 26, `B=$94` and `C=$2A`, then calls `Gfx_StartHDMA`. The callsite instruction bytes at original ROM `2A:580E` match the maintained register setup. `home/gfx_upload.asm:7–40` establishes that `C` counts 16-byte units and `E.bit0` selects the VRAM bank; the request selects VRAM bank 0.

- **CONFIRMED, static:** the request starts at `26:7820`, contains the whole slice, uses 42 16-byte units, and targets VRAM bank 0 `$8000-$82A0`.
