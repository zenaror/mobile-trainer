# Bank 53 names and browser-frame asset audit (2026-10-23)

## Result and scope

This audit rechecked the Japanese Bank 53 name table, the finite frame windows and the maintained GFX inventory in a private snapshot of `0fa24aa195311a3f84106f816ffae896ad6f8d83`. An independent reviewer reproduced the core counts. It did not inspect the paused English overlay or Operator ZIP, and it did not establish natural runtime access to any frame.

The result closes the requested **asset-presence and extraction check** for the audited files: all 25 name strings and pointers re-emit 369 bytes exactly; all 25 candidate windows re-emit 85,200 bytes exactly; the 137 bank 41–47 assets (93,264 emitted bytes), 53 PNG-to-binary inversions (69,520 bytes), 17 editable views (391,680 tile-pixel indices), and 24 preview PNGs were present and passed their stated finite checks. The eight resource directories contain exactly 208 files (137 assets + 71 PNGs), with no missing referenced files or orphan asset/PNG files in this scope.

This does **not** prove that every candidate window is used, that any frame is unused, or that the 25 Japanese names map to the 25 windows. Those associations remain **HYPOTHESIS**. The 27-entry selector table points to five 31-byte descriptors at 4E:6581/65A0/65BF/65DE/65FD. Across those descriptors, the 25 far-pointer fields select bank 47 resources at 4100, 4E50 or 5BA0; this inspected finite chain contains no pointer to Bank 53, banks 41–46, or 47:68F0. Computed or unobserved access outside this chain remains possible.

## Evidence and limits

- The 25 pointers and Shift-JIS/NUL strings at 53:4032–4171 match the ROM exactly (50 pointer bytes + 319 string bytes = 369). No image assignment follows from table order.
- The 25 candidate windows are each `$D50` bytes. Their source fragments re-emit exactly; the 2,416 bytes outside currently active tile/raw leaves remain represented in source and are not missing ROM bytes.
- All 137 inventoried Bank 41–47 assets exist and match emitted sizes/hashes. The 53 inverse conversions and 17 views match the documented models. The 24 preview files decode as valid 160×144 PNGs with valid CRCs. These checks establish file and declared-model consistency, not natural loader behavior or LCD output.
- Eight `KEEP` maps retain uncovered cells under the conditional U160 model; these are not evidence of unused graphics. The distinct 47:68F0 candidate has its own existing editable screen PNG and lies outside the 25-window stride set.
- The 18 screen-catalog rows include a separate partial 47:5850 row (357/360 cells). It is not a 26th `$D50` window and is not one of the 17 fully modeled views.
- A bounded lexical scan found Bank 53 name-table symbols only at their owner definitions/pointers, and did not find external uses of the extracted candidate asset labels. The negative scan does not cover arbitrary computed pointers, runtime copies, or every bank-selection path.

An earlier file-header comment called these “27 frame descriptors.” Inspection of `Table_Browser_FrameDescriptors` shows 27 indexed words that select five physical descriptors. The comment now states those counts separately; no instructions, data, symbols, or layout changed.

## Reproduction

The audit used the private snapshot manifest `BASELINE.json` (SHA-256 `31ffff013ae9ee82ba2e8425be5674ba58fea28b0bb9d9964126226f7d5dc60b`) and the original ROM (2,097,152 bytes; SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`). The independent reviewer checked the manifest's 595 files, reproduced the 369-byte name block, 25 windows/85,200 bytes, 137 assets, 53 inversions, 17 views, 24 previews and 208-file inventory. Selector conclusion is limited to the stated 27 words/five descriptors.

For the detailed per-window/resource matrix, KEEP-cell accounting, selectors, addresses, and block hashes, see [`assets_pokemon_frames_and_name_limits.md`](assets_pokemon_frames_and_name_limits.md). This audit adds no new species-to-image mapping.
