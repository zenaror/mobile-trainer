# Japanese graphics asset completeness follow-up

### Bank 24 Page List

| Source window | Destination | 16-byte partitions now represented |
|---|---|---|
| `24:5EE0..62E0` (1,024 bytes, 64 tiles) | VRAM0 `$8000..$8400` | `5EE0..5F00` 2 tiles; `5F00..62D0` 61 tiles; `62D0..62E0` one all-zero tile |
| `24:62E0..64E0` (512 bytes, 32 tiles) | VRAM0 `$8400..$8600` | `62E0..6310` 3 tiles; `6310..63C0` 11; `63C0..63D0` 1; `63D0..63E0` one all-zero tile; `63E0..64E0` 16 |

### Bank 25 mailbox transfers

| Source interval | Tile count | Old source boundary crossed / source shape | VRAM0 destination in first or third transfer |
|---|---:|---|---|
| `69F0..6CF0` | 48 | full first DMA window; includes the overlay reload at `6A00..6B00` | `$8000..$8300` |
| `6AC0..6AD0` | 1 | 8 trailing bytes of the old `69F0` asset + 8 bytes of the `6AC8` fragment | `$80D0..$80E0`; overlay destination `$87C0..$87D0` |
| `6BD0..6BE0` | 1 | final byte of the `6AC8` fragment + first 15 bytes of the former `6BD1` binary | `$81E0..$81F0` |
| `6CE0..6CF0` | 1 | final byte of the former `6BD1` binary + 15 zero bytes | `$82F0..$8300` |
| `6CF0..6EF0` | 32 | full third DMA window, including `6E70..6E80` across the former `6E71` boundary | `$8D00..$8F00` |
| `6E70..6E80` | 1 | one preceding zero byte + first 15 bytes of the former `6E71` fragment | `$8E80..$8E90` |

### Residual short spans

The earlier list of 13 short spans is reconciled: the Page List, mail-title and mailbox cases above are now represented by complete tile sources. The remaining six Bank 42 fragments (`48A2`, `5E50`, `6132`, `6340`, `7092`, `7190`) and `1A:4A85` (11 bytes) still lack complete tile-PNG candidates in this bounded plan. Bank 42's descriptor-selected bank is 47, while its other layouts remain conditional models. `1A:4A85` ends before the confirmed transfer beginning at `4A90` and its enclosing block also intersects the preceding attribute-map bytes. These remain in their current source forms and confidence levels. The bounded search does not assert that no other ROM asset or reader exists.

### Bank 51 tail split at the `Bmp_Validate` code boundary

The former `51:70D1` 15-byte residual is now separated from the candidate tile source. `time_summary_candidate_tiles_5ee1.2bpp` is 4,592 bytes (287 complete 16-byte tiles), covering `51:5EE1..70D1`; the following `51:70D1..70E0` bytes are fifteen `$00` bytes in the original ROM. The next source begins confirmed code `Bmp_Validate` at the 16-byte-aligned `51:70E0`. The zero run's alignment-padding role is **PROBABLE**, so it is named `Padding_BmpValidateEntryAlignment_51_70D1`; exact reader/use and global non-use are not established. This is a source-boundary clarification, not a missing PNG or a natural-loader claim.

A separate Bank 4B residual review found no further missing PNG within the examined ranges. The `4B:7090..7490` request crosses existing typed sources (32-byte tail, 768-byte tile slice, 64-byte palette, and 160-byte tilemap/attribute prefix); `4B:7AD0..7DD0` crosses a 512-byte tile source, 64-byte palette, and 192-byte tilemap prefix. The four zero bytes at `4B:76CC..76D0` are outside the three table pointers; the confirmed slot argument is 0–2. Their purpose remains unknown, so they are not relabeled as padding.

The maintained 4,592-byte candidate is now `[51:5EE0,51:70D0)`, and the following 16 zero bytes `[51:70D0,51:70E0)` remain a **PROBABLE** alignment gap before `Bmp_Validate`.

## Sprite animation script contracts

The earlier `gfx/README.md` row “HYPOTHESIS data (mostly runs of `$FF` / `$00` padding candidates)” was misleading: its 24 groups included referenced animation scripts and a tilemap-like candidate, not only padding. `tools/gfx_export.py` now describes that category neutrally as data whose content type or purpose is not established.

Static review of `home/sprites.asm` establishes the script mechanics directly. `Sprite_LoadObjectEntry` stores the script pointer from the second word of an object-table entry in slot bytes 6–7 and initializes the first frame/countdown pair. `Sprite_StepAndDrawSlot` reads byte 0 as the pair count, advances the slot's pair index, reads the selected two-byte pair, writes its first byte as the frame-table index and its second as the countdown reload. The countdown is decremented on each slot update; `00:0B71` uses the frame-table index to select the OAM frame pointer. This confirms the binary record contract, not that a particular candidate table has a natural caller or is displayed.

That contract resolves ten source spans as **CONFIRMED sprite-animation script layouts**: seven entries in `gfx/address_book/save_sender_address.asm` (`2A:52BE`, `52E7`, `52FD`, `5397`, `5451`, `5475`, `5490`) referenced by `SpriteSlotAnimationEntryTable_2A_5220`, and three in `gfx/mail/compose_objects.asm` (`29:62EF`, `6318`, `6343`) referenced by `MailBodyCandidate_AnimEntries` at `29:6290`. All frame indices in these scripts fit their associated pointer-list extents. The callers and natural display of those candidate tables remain unproved. The adjacent orphan at `2A:545C`, the unreferenced scripts in the browser/top-menu owners, and other unknown data retain their existing confidence; no broad use/unused claim follows.

The same reader contract bounds the referenced one-pair `MailBody_ObjScript` at `28:4BA3` to three bytes, ending at `28:4BA6`. At this 2026-10-23 review, the adjacent `WramClearCandidate_28_4BA6` began after the script record and its code/data classification was still HYPOTHESIS; the boundary did not make it a callable function. Later instruction evidence supports PROBABLE code named `ClearWram0AndFillWram7WithFF`; entry and purpose remain unresolved. See the current [Japanese residual matrix](japanese_remaining_semantics_batch_20261024.md).
