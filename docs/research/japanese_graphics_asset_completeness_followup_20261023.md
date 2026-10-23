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

## Additional complete tiles and current residual spans

Three of the 16 additional rows in the pre-extraction plan contained complete tiles that were
recoverable as standalone indexed PNG sources without absorbing adjacent non-tile bytes:

- `4B:5400..5420` (32 bytes, two tiles) maps inside the static second-banner DMA to VRAM1 `$9310..$9330`.
- `24:5EE0..5EF0` (16 bytes, one tile) is the first tile of the 1,024-byte Page List DMA to VRAM0 `$8000`; the following byte `$BE` at `5EF0` remains separate because it begins the next tile.
- `24:62E0..6300` (32 bytes, two tiles) is the first two tiles of the 512-byte Page List DMA to VRAM0 `$8400`; the following byte `$50` at `6300` remains separate as the next tile begins.

Each range now has an exact `.2bpp` backing and indexed PNG; `rgbgfx -c embedded` round-tripped all three binaries exactly. These are static transfer relationships only; they do not establish natural screen composition or usage.

The current `python3 tools/gfx_export.py plan` reports 13 residual `gfx` spans, each shorter than one 16-byte tile: `24:62D1` (15 bytes), `24:63C1` (15), `51:70D1` (15), `42:48A2` (9), `42:5E50` (14), `42:6132` (14), `42:6340` (10), `42:7092` (12), `42:7190` (12), `1A:4A85` (11), `2C:5660` (12), `25:6CE1` (15), and `25:6E70` (1). They remain in their existing source representations and confidence grades; this does not assert they are unused or assign them a higher-level image identity.

A byte-length reconciliation against the owner ASM explains the 13 residual rows without promoting their meanings: `24:62D1` is the 15-byte zero tail after the 992-byte `5EF1` slice; `24:63C1` is the 15-byte tail after the 192-byte `6301` slice; `51:70D1` follows the 4,592-byte tile source at `51:5EE1`; and the six Bank 42 residues follow tile sources at `42:4802` (160 bytes), `5AA0` (+`$3B0`, 944 bytes), `5F92` (416 bytes), `62A0` (160 bytes), `6FF2` (160 bytes), and `70F0` (160 bytes). These are incomplete tile-phase tails, not complete standalone image sources. `1A:4A85` contains 11 zero bytes before the confirmed transfer source at `4A90`; `25:6CE1` is a 15-zero tail before the asset at `6CF0`, and `25:6E70` is a one-zero byte after the 384-byte tile asset at `6CF0`; their padding purpose remains unpromoted. The 12 bytes at `2C:5660` follow the 592-byte source beginning at `5410`, before the four-zero run and palette at `5670`; no separate image identity or reader was established. Thus the bounded plan has no further complete-tile candidate, while the byte fragments retain their current confidence and ownership.

A separate Bank 4B residual review found no further missing PNG within the examined ranges. The
`4B:7090..7490` request crosses existing typed sources (32-byte tail, 768-byte tile slice, 64-byte
palette, and 160-byte tilemap/attribute prefix); `4B:7AD0..7DD0` crosses a 512-byte tile source,
64-byte palette, and 192-byte tilemap prefix. The four zero bytes at `4B:76CC..76D0` are outside
the three table pointers; the confirmed slot argument is 0–2. Their purpose remains unknown, so
they are not relabeled as padding.

## Sprite animation script contracts

The earlier `gfx/README.md` row “HYPOTHESIS data (mostly runs of `$FF` / `$00` padding candidates)” was misleading: its 24 groups included referenced animation scripts and a tilemap-like candidate, not only padding. `tools/gfx_export.py` now describes that category neutrally as data whose content type or purpose is not established.

Static review of `home/sprites.asm` establishes the script mechanics directly. `Sprite_LoadObjectEntry` stores the script pointer from the second word of an object-table entry in slot bytes 6–7 and initializes the first frame/countdown pair. `Sprite_StepAndDrawSlot` reads byte 0 as the pair count, advances the slot's pair index, reads the selected two-byte pair, writes its first byte as the frame-table index and its second as the countdown reload. The countdown is decremented on each slot update; `00:0B71` uses the frame-table index to select the OAM frame pointer. This confirms the binary record contract, not that a particular candidate table has a natural caller or is displayed.

That contract resolves ten source spans as **CONFIRMED sprite-animation script layouts**: seven entries in `gfx/address_book/save_sender_address.asm` (`2A:52BE`, `52E7`, `52FD`, `5397`, `5451`, `5475`, `5490`) referenced by `SpriteSlotAnimationEntryTable_2A_5220`, and three in `gfx/mail/compose_objects.asm` (`29:62EF`, `6318`, `6343`) referenced by `MailBodyCandidate_AnimEntries` at `29:6290`. All frame indices in these scripts fit their associated pointer-list extents. The callers and natural display of those candidate tables remain unproved. The adjacent orphan at `2A:545C`, the unreferenced scripts in the browser/top-menu owners, and other unknown data retain their existing confidence; no broad use/unused claim follows.
