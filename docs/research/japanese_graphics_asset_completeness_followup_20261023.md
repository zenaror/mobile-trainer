# Japanese graphics asset completeness follow-up

Date: 2026-10-23. Source: original Mobile Trainer (Japan), SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

## Bank 2C mail-title continuation

Before adopting this span, the read-only `python3 tools/gfx_export.py plan` inventory reported
187 unconverted source spans, of which 17 were tagged as `gfx`. At that point, only one graphic span
was large enough to form a standalone tile sheet: `2C:5150..5410`, 704 bytes (44 tiles). The source DB matched the original ROM
window byte for byte; its SHA-256 is
`4e206881ecf76156ee8b8f79c887788b36ebd3dda47d67aa15dfc4019bba4aba`.

`MailTitle_InitScreen` at `2C:414C` loads 45 contiguous tiles from `2C:5140` using `$2D` 16-byte
HDMA blocks to VRAM0 `$8000..$82CF`. The pre-existing source at `2C:5140` contributes one tile;
this continuation at `2C:5150` contributes the following 44 tiles at `$8010..$82CF`. This is a
static load contract. The continuation was converted into an exact `.2bpp` binary and an indexed
88×32 PNG (11 tiles per row, no padding); `rgbgfx -c embedded` rebuilt the binary from the PNG
byte for byte. The original 16-byte tile at `$5140` remains a separate exact source.

## Remaining small GFX-plan fragments

The other 16 `gfx` rows in that plan are all shorter than four 16-byte tiles: `4B:5400` (32 bytes),
`24:5EE0` (17), `24:62D1` (15), `24:62E0` (33), `24:63C1` (15), `51:70D1` (15), `42:48A2`
(9), `42:5E50` (14), `42:6132` (14), `42:6340` (10), `42:7092` (12), `42:7190` (12),
`1A:4A85` (11), `2C:5660` (12), `25:6CE1` (15), and `25:6E70` (1). These spans do not form
standalone complete-tile sheets. Their bytes and existing confidence/owner notes remain intact; the
triage does not assert they are unused or assign them a higher-level image identity.

A separate Bank 4B residual review found no further missing PNG within the examined ranges. The
`4B:7090..7490` request crosses existing typed sources (32-byte tail, 768-byte tile slice, 64-byte
palette, and 160-byte tilemap/attribute prefix); `4B:7AD0..7DD0` crosses a 512-byte tile source,
64-byte palette, and 192-byte tilemap prefix. The four zero bytes at `4B:76CC..76D0` are outside
the three table pointers; the confirmed slot argument is 0–2. Their purpose remains unknown, so
they are not relabeled as padding.
