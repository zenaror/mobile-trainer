# Japanese Profile initial-screen tile slice at 26:7840 (2026-10-22)

## Finding

The 624-byte interval at ROM bank 26 address 7840 is not an isolated asset with no located reader. It is an interior slice of a statically requested Profile_InitScreen HDMA transfer. The earlier no-transfer statement searched for a transfer beginning exactly at 26:7840 and missed the larger request beginning at 26:7820. This correction supersedes that negative conclusion.

Two independent reviews of source and original-ROM bytes reached the same result. The first traced the source-level register setup and transfer helper. The second independently matched the register-loading opcodes at original ROM 2A:580E against the maintained callsite. Neither review modified files or ran dynamic behavior tests.

## Exact interval mapping

All intervals are half-open. The request at `engine/profile/profile_editor.asm:508–513` sets `DE=$8000`, `HL=Gfx_Profile_Tiles8000` at `26:7820`, source bank 26, `B=$94` and `C=$2A`, then calls `Gfx_StartHDMA`. The callsite instruction bytes at original ROM `2A:580E` match the maintained register setup. `home/gfx_upload.asm:7–40` establishes that `C` counts 16-byte units and `E.bit0` selects the VRAM bank; the request selects VRAM bank 0.

| Portion | ROM source | Length | Offset in request | VRAM bank 0 destination |
|---|---|---:|---:|---|
| Full request | `[26:7820, 26:7AC0)` | 672 bytes (`$2A × 16`) | 0 | `[$8000, $82A0)` |
| Existing profile tiles | `[26:7820, 26:7840)` | 32 bytes | 0 | `[$8000, $8020)` |
| Renamed interior slice | `[26:7840, 26:7AB0)` | 624 bytes (`$270`, 39 units) | `$20` | `[$8020, $8290)` |
| Existing zero tail | `[26:7AB0, 26:7AC0)` | 16 bytes | `$290` | `[$8290, $82A0)` |

The maintained symbol is `Gfx_Profile_InitScreen_Tiles8020Slice`; the asset is `gfx/mail/server_status_bank26/profile_init_screen_tiles8020_slice.2bpp` with its corresponding PNG. The 624 original bytes are SHA-256 `bf73dd413d32616eb147b17ee05aa80cfebadd2e8f74a2a3b0c9e05accbbed07`; the PNG is SHA-256 `8b811dc88acd996405dd099cf17c4bd83b843188fc2242381340507a015bd6e9`. Both values match their pre-rename content.

## Evidence level and limits

- **CONFIRMED, static:** the request starts at `26:7820`, contains the whole slice, uses 42 16-byte units, and targets VRAM bank 0 `$8000-$82A0`. The 624-byte subrange therefore maps to `$8020-$8290`.
- **CONFIRMED, byte identity:** the moved binary and PNG retain their exact pre-rename hashes; the build and asset manifest verify the ROM bytes.
- **Not established here:** natural execution of this request, tilemap references to all 39 units, which visual tiles are selected, or the resulting displayed composition. No claim of unused status is made.

The original conclusion in `generic_data_name_audit_20261020.md` remains as historical provenance but is explicitly superseded. The lexical census `japanese_generic_name_census_20261023.md` has a dated addendum and distinguishes its earlier snapshot from this later evidence.
