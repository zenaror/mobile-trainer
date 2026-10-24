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

## Phase-aligned tiles recovered from static HDMA windows

The earlier residual-only review was incomplete: a tile can cross an `INCBIN`/`db` boundary even when neither source fragment is itself a complete tile. The current pass checked the full, statically specified transfer windows against the immutable Japanese ROM, not only the short rows emitted by `gfx_export.py plan`. All physical-bank offsets use `bank * 0x4000 + (CPU address - 0x4000)`. The original ROM SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

### Bank 24 Page List

`PageList_InitScreen` at `engine/browser/page_list.asm:423-437` submits two static HDMAs:

| Source window | Destination | 16-byte partitions now represented |
|---|---|---|
| `24:5EE0..62E0` (1,024 bytes, 64 tiles) | VRAM0 `$8000..$8400` | `5EE0..5F00` 2 tiles; `5F00..62D0` 61 tiles; `62D0..62E0` one all-zero tile |
| `24:62E0..64E0` (512 bytes, 32 tiles) | VRAM0 `$8400..$8600` | `62E0..6310` 3 tiles; `6310..63C0` 11; `63C0..63D0` 1; `63D0..63E0` one all-zero tile; `63E0..64E0` 16 |

Both source windows compare byte for byte with the original ROM. Their SHA-256 values are `f763bef6f1a76263a14ba55d860632a52f4bb6d50a5821e8ae1765b43ceee492` and `e6ceb0a7afd4016348e6cfdd7b39c084e24b5a428ed4ea7941643eb6dd4a9b6f`, respectively. Each active PNG round-trips through `rgbgfx -c embedded` (the 61-tile sheet uses `-x 3`) to its exact `.2bpp` bytes. This replaces the earlier phase-1 assets and incorporates the complete tiles at `5EF0`, `62D0`, `6300`, `63C0` and `63D0`. The two all-zero blocks are confirmed source bytes and transfer positions; their purpose or visual use is not asserted.

### Bank 2C mail-title transfer

`engine/mail/mail_title_entry.asm:227-232` sets `HL=5410`, `DE=8800`, bank `$2C` and `C=$26`, giving the static 608-byte source window `2C:5410..5670` to VRAM0 `$8800..$8A60`. The `mail_title_tiles8800.2bpp` source now includes all 38 tiles, including the all-zero tile at `5660..5670`; the palette begins at `5670`, immediately after the transfer. Its SHA-256 is `0b7f772e5787d64bea4a5758cc635d3913d16a6fec46b3bdde6ef6e2d3b14701`; the indexed PNG round-trips exactly with ten row-padding tiles excluded by `rgbgfx -x 10`.

### Bank 25 mailbox transfers

`engine/mail/mailbox_screen.asm:45-64,103-122` statically specifies a 768-byte transfer `25:69F0..6CF0` to VRAM0 `$8000..$8300`, a second overlapping 256-byte transfer `6A00..6B00` to `$8700..$8800`, and a 512-byte transfer `6CF0..6EF0` to `$8D00..$8F00`. The source starts and destinations are all 16-byte aligned; the transfer counts specify complete 16-byte blocks. Therefore each partition below has a positive static transfer contract even where the old source representation crossed labels or used raw `db`.

| Source interval | Tile count | Old source boundary crossed / source shape | VRAM0 destination in first or third transfer |
|---|---:|---|---|
| `69F0..6CF0` | 48 | full first DMA window; includes the overlay reload at `6A00..6B00` | `$8000..$8300` |
| `6AC0..6AD0` | 1 | 8 trailing bytes of the old `69F0` asset + 8 bytes of the `6AC8` fragment | `$80D0..$80E0`; overlay destination `$87C0..$87D0` |
| `6BD0..6BE0` | 1 | final byte of the `6AC8` fragment + first 15 bytes of the former `6BD1` binary | `$81E0..$81F0` |
| `6CE0..6CF0` | 1 | final byte of the former `6BD1` binary + 15 zero bytes | `$82F0..$8300` |
| `6CF0..6EF0` | 32 | full third DMA window, including `6E70..6E80` across the former `6E71` boundary | `$8D00..$8F00` |
| `6E70..6E80` | 1 | one preceding zero byte + first 15 bytes of the former `6E71` fragment | `$8E80..$8E90` |

The ASM now has exact 768-byte and 512-byte `.2bpp` sources with indexed PNGs for the two complete windows; `6AC0` also belongs to the existing overlapping transfer. The full-window hashes are `987ad19aa5db3c983125bf25fea96fa08256739a669def53030ef3cb4c3f8db8` (`69F0..6CF0`) and `f75a4dcbafb9d2089f1ecb2428a6edd33ad6aa9034e0d606ce0f9dc090b8b7b0` (`6CF0..6EF0`). Both PNGs round-trip exactly with `rgbgfx -c embedded`. This establishes the byte windows, 2bpp transfer representation and VRAM destinations, not natural execution, final screen composition or a higher-level image identity.

### Residual short spans

The earlier list of 13 short spans is reconciled: the Page List, mail-title and mailbox cases above are now represented by complete tile sources. The remaining six Bank 42 fragments (`48A2`, `5E50`, `6132`, `6340`, `7092`, `7190`) and `1A:4A85` (11 bytes) still lack complete tile-PNG candidates in this bounded plan. Bank 42's descriptor-selected bank is 47, while its other layouts remain conditional models. `1A:4A85` ends before the confirmed transfer beginning at `4A90` and its enclosing block also intersects the preceding attribute-map bytes. These remain in their current source forms and confidence levels. The bounded search does not assert that no other ROM asset or reader exists.

### Bank 51 tail split at the `Bmp_Validate` code boundary (2026-10-24)

The former `51:70D1` 15-byte residual is now separated from the candidate tile source. `time_summary_candidate_tiles_5ee1.2bpp` is 4,592 bytes (287 complete 16-byte tiles), covering `51:5EE1..70D1`; the following `51:70D1..70E0` bytes are fifteen `$00` bytes in the original ROM. The next source begins confirmed code `Bmp_Validate` at the 16-byte-aligned `51:70E0`. The zero run's alignment-padding role is **PROBABLE**, so it is named `Padding_BmpValidateEntryAlignment_51_70D1`; exact reader/use and global non-use are not established. This is a source-boundary clarification, not a missing PNG or a natural-loader claim.

A separate Bank 4B residual review found no further missing PNG within the examined ranges. The `4B:7090..7490` request crosses existing typed sources (32-byte tail, 768-byte tile slice, 64-byte palette, and 160-byte tilemap/attribute prefix); `4B:7AD0..7DD0` crosses a 512-byte tile source, 64-byte palette, and 192-byte tilemap prefix. The four zero bytes at `4B:76CC..76D0` are outside the three table pointers; the confirmed slot argument is 0–2. Their purpose remains unknown, so they are not relabeled as padding.

## Sprite animation script contracts

The earlier `gfx/README.md` row “HYPOTHESIS data (mostly runs of `$FF` / `$00` padding candidates)” was misleading: its 24 groups included referenced animation scripts and a tilemap-like candidate, not only padding. `tools/gfx_export.py` now describes that category neutrally as data whose content type or purpose is not established.

Static review of `home/sprites.asm` establishes the script mechanics directly. `Sprite_LoadObjectEntry` stores the script pointer from the second word of an object-table entry in slot bytes 6–7 and initializes the first frame/countdown pair. `Sprite_StepAndDrawSlot` reads byte 0 as the pair count, advances the slot's pair index, reads the selected two-byte pair, writes its first byte as the frame-table index and its second as the countdown reload. The countdown is decremented on each slot update; `00:0B71` uses the frame-table index to select the OAM frame pointer. This confirms the binary record contract, not that a particular candidate table has a natural caller or is displayed.

That contract resolves ten source spans as **CONFIRMED sprite-animation script layouts**: seven entries in `gfx/address_book/save_sender_address.asm` (`2A:52BE`, `52E7`, `52FD`, `5397`, `5451`, `5475`, `5490`) referenced by `SpriteSlotAnimationEntryTable_2A_5220`, and three in `gfx/mail/compose_objects.asm` (`29:62EF`, `6318`, `6343`) referenced by `MailBodyCandidate_AnimEntries` at `29:6290`. All frame indices in these scripts fit their associated pointer-list extents. The callers and natural display of those candidate tables remain unproved. The adjacent orphan at `2A:545C`, the unreferenced scripts in the browser/top-menu owners, and other unknown data retain their existing confidence; no broad use/unused claim follows.

The same reader contract bounds the referenced one-pair `MailBody_ObjScript` at `28:4BA3` to three bytes, ending at `28:4BA6`. This narrows the adjacent `WramClearCandidate_28_4BA6` boundary: the 28-byte candidate begins after the script record. Its code/data classification, entry and purpose remain HYPOTHESIS; the boundary does not make it a callable function.
