# Bank 4B confirm-screen slot-cell record names (2026-10-23)

## Later refinement (2026-10-24)

The source and original-ROM checks remain valid for the three selected records and their pointer values. A follow-up noted that the four zero bytes at `4B:76CC–76D0` end exactly where the next 16-byte-aligned graphics source begins at `4B:76D0`. Together with the project's finite census of 289 explicitly located Gfx labels, all 16-byte aligned, this makes alignment padding **PROBABLE**; the reserved fourth slot-cell record interpretation is now **HYPOTHESIS**. The selector still does not reach the zero bytes, and their global use remains unknown. The source uses `Padding_SettingsPhone_ContinuePromptTiles_Alignment`; see [the consolidated residual matrix](japanese_remaining_semantics_batch_20261024.md#four-zero-bytes-before-aligned-tiles-at-4b76d0) for the exact evidence and limits.

## Result

The 16-byte block at `4B:76C0–76D0` is represented as four consecutive four-byte records. `SettingsPhone_ConfirmScreen_LoadSlotTilemap` at `67:53B7` loads `wConfirmScreen_Slot`, indexes the three-word table at `67:53D6`, reads a pointer, selects source bank `$4B`, and calls `Tilemap_CopyRectAndAttr` with `BC=$0201`. The helper at `00:08EA` copies the same source pointer twice, with the destination advanced by `$04` for its second pass; `BC=$0201` means two rows of one byte. This establishes each selected record's four-byte layout: two tile bytes followed by two attribute bytes. The table entries are `$76C0`, `$76C4`, and `$76C8`; each selected source therefore begins at one of the first three records. The final record begins at `$76CC` and consists of four zero bytes; it is not in this table. Its four-byte record identity is **PROBABLE** from the repeated stride and position; no purpose or use by another path is inferred.

The source now names the two later selected records `SettingsPhone_ConfirmScreen_SlotCellRecord1` and `SettingsPhone_ConfirmScreen_SlotCellRecord2`, and names the final bytes `SettingsPhone_ConfirmScreen_ZeroSlotCellRecord`. The existing aggregate label remains at `$76C0`. The pointer table uses these symbols instead of numeric words. The emitted bytes, pointer values, and extents are preserved.

## Out-of-range slot index

The lookup has no local bounds check. If `wConfirmScreen_Slot` were `$03`, its word address would be `$53DC`, immediately after the three-entry table; the original bytes there are `CD 02`, so the computed source pointer is `$02CD`, not the zero record at bank `$4B:$76CC`. The ordinary caller passes the selected phone slot, whose established domain is 0–2. This calculation rules out index 3 selecting the adjacent record through this lookup; it does not establish global non-use of `$76CC`, nor behavior for other corrupted values.

## Evidence and validation

- `engine/settings/confirm_screen.asm` and `home/gfx_upload.asm`: the reader loads the slot into a two-byte table offset and copies from bank `$4B`; the table has exactly three entries. `Tilemap_CopyRectAndAttr` copies B rows by C bytes twice, offsetting the destination by `$04` for attributes.
- At source index 3, the same arithmetic reads the adjacent original-ROM bytes `67:53DC–53DD = CD 02` and forms `$02CD`; this is not a pointer to the four-zero record. No new runtime or corrupted-state behavior is claimed.
- `gfx/settings/notice_headers_and_phone_confirm_continue_bank4b.asm`: the four records decode as `26 2F 09 09`, `27 30 09 09`, `28 31 09 09`, and `00 00 00 00`.
- Bank-to-file conversion used `bank * $4000 + (address - $4000)`: `4B:76C0` is file offset `$12F6C0`; `67:53D6` is `$19D3D6`. Direct reads from `baserom.gbc` and `mobile_trainer.gbc` matched the expected 16 record bytes and six pointer bytes (`C0 76 C4 76 C8 76`). The two complete 2,097,152-byte ROMs have SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
- `make`: `SHA-256 OK`, `RESULT: IDENTICAL`.
- `make sym-check`: 335 source files, 12,215 source/linker labels, 51 constants; OK. The four record labels resolve to `4B:76C0`, `4B:76C4`, `4B:76C8`, and `4B:76CC`; the pointer table remains at `67:53D6`.
- `git diff --check`: clean after the source and documentation edits.

These are static source and original-ROM facts. The earlier 70-scenario corpus check found no read interval over the zero record; that result remains bounded to that corpus and does not prove global non-use. No emulator or hardware behavior was tested in this pass.
