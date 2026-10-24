# Bank 53 names and browser-frame asset audit (2026-10-23)

## Result and scope

This audit rechecked the Japanese Bank 53 name table, the finite frame windows and the maintained GFX inventory in a private snapshot of `0fa24aa195311a3f84106f816ffae896ad6f8d83`. An independent reviewer reproduced the core counts. It did not inspect the paused English overlay or Operator ZIP, and it did not establish natural runtime access to any frame.

The result closes the requested **asset-presence and extraction check** for the audited files: all 25 name strings and pointers re-emit 369 bytes exactly; all 25 candidate windows re-emit 85,200 bytes exactly; the 137 bank 41–47 assets (93,264 emitted bytes), 53 PNG-to-binary inversions (69,520 bytes), 17 editable views (391,680 tile-pixel indices), and 24 preview PNGs were present and passed their stated finite checks. The eight resource directories contain exactly 208 files (137 assets + 71 PNGs), with no missing referenced files or orphan asset/PNG files in this scope.

This does **not** prove that every candidate window is used, that any frame is unused, or that the 25 Japanese names map to the 25 windows. Those associations remain **HYPOTHESIS**. The 27-entry selector table points to five 31-byte descriptors at 4E:6581/65A0/65BF/65DE/65FD. Across those descriptors, the 25 far-pointer fields select bank 47 resources at 4100, 4E50 or 5BA0; this inspected finite chain contains no pointer to Bank 53, banks 41–46, or 47:68F0. Computed or unobserved access outside this chain remains possible.

## Evidence and limits

- The 25 pointers at 53:4000–4032 (50 bytes) and Shift-JIS/NUL strings at 53:4032–4171 (319 bytes) match the ROM exactly. The complete contiguous block is 53:4000–4171 (369 bytes). No image assignment follows from table order.
- The 25 candidate windows are each `$D50` bytes. Their source fragments re-emit exactly; the 2,416 bytes outside currently active tile/raw leaves remain represented in source and are not missing ROM bytes.
- All 137 inventoried Bank 41–47 assets exist and match emitted sizes/hashes. The 53 inverse conversions and 17 views match the documented models. The 24 preview files decode as valid 160×144 PNGs with valid CRCs. These checks establish file and declared-model consistency, not natural loader behavior or LCD output.
- Eight `KEEP` maps retain uncovered cells under the conditional U160 model; these are not evidence of unused graphics. The distinct 47:68F0 candidate has its own existing editable screen PNG and lies outside the 25-window stride set.
- The 18 screen-catalog rows include a separate partial 47:5850 row (357/360 cells). It is not a 26th `$D50` window and is not one of the 17 fully modeled views.
- A bounded lexical scan found Bank 53 name-table symbols only at their owner definitions/pointers, and did not find external uses of the extracted candidate asset labels. The negative scan does not cover arbitrary computed pointers, runtime copies, or every bank-selection path.

An earlier file-header comment called these “27 frame descriptors.” Inspection of `Table_Browser_FrameDescriptors` shows 27 indexed words that select five physical descriptors. The comment now states those counts separately; no instructions, data, symbols, or layout changed.

## Reproduction

The audit used the private snapshot manifest `BASELINE.json` (SHA-256 `31ffff013ae9ee82ba2e8425be5674ba58fea28b0bb9d9964126226f7d5dc60b`) and the original ROM (2,097,152 bytes; SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`). The independent reviewer checked the manifest's 595 files, reproduced the 369-byte name block, 25 windows/85,200 bytes, 137 assets, 53 inversions, 17 views, 24 previews and 208-file inventory. Selector conclusion is limited to the stated 27 words/five descriptors.

For the detailed per-window/resource matrix, KEEP-cell accounting, selectors, addresses, and block hashes, see [`assets_pokemon_frames_and_name_limits.md`](assets_pokemon_frames_and_name_limits.md). This audit adds no new species-to-image mapping.

## Recheck at Japanese HEAD `ae6b9ccef65207421f832ff856afe1659ece9865` (2026-10-23)

The name block, 25 candidate windows, 137 catalogued assets, 208 files, 53
inversions, 17 editable views, and 24 preview files were rechecked against the
original ROM. Their bytes and finite inventory counts remain unchanged. A
separate owner-42 accounting found **2,416 inline bytes outside the asset
catalog**: 71 bytes in six partial `db` tails and 2,345 bytes in `ds $00`
padding. This is not a PNG gap: the exporter deliberately keeps partial tiles
as inline bytes, while zero-fill and HYPOTHESIS spans are not auto-exported.
The complete owner slice `42:4000–7540` re-emits 13,632 original bytes
(`fd41119f44de05e6fef0f5c8c916331343b29f6e7ff75442f242f70b9931f7a1`).

The 25 names remain unassigned to candidate frames, and no natural selector
for Bank 53 was established. In the audited finite selector chain, styles
`0`, `1`, `2–22`, and `23–26` resolve only to Bank 47 resources
`4100`, `4E50`, `5BA0`, and `4E50`, respectively. The absence of a
Bank 53 pointer in this chain is not proof against computed or unobserved
access. These results close file-presence/extraction review only; runtime
selection, used/unused classification, and species-to-image mapping remain
open.

## Independent recheck at Japanese HEAD `e97026b86acc37e8157aa38fe10f9ec098c00350` (2026-10-23)

The bounded recheck examined 349 Japanese source files (including the 333 maintained files in the six primary source roots) and 149 exported symbols. It reproduced the 25 name entries and 369-byte block, all 25 candidate windows (85,200 bytes), 137 assets (93,264 emitted bytes), 53 PNG inversions (69,520 bytes), 18 catalogued screen rows (17 complete views), 24 candidate previews plus five descriptor previews, 27 selector words and five descriptors. The eight resource directories contain exactly 208 tracked files (137 assets and 71 PNGs); the inventory reports no missing, orphaned or expected-but-untracked files. All 29 preview images matched the declared pixel model after the audit renderer included the unloaded-cell hatch. The initial reviewer ledger had 13 preview mismatches because it omitted that hatch; this was an audit-model error and is preserved with its correction in the ignored evidence directory.

The recheck does not close any of the 25 name-to-window associations or prove natural/unused status for a frame. The exact selector chain still points only to the previously identified Bank 47 resource families. Full report and reproduction hashes are retained under `.tmp/jp-generic-name-batch-20261022-evidence/bank53-e97026b8-independent-v2/`.

## Reconciliation at Japanese main 8bb48e53

The published main has advanced through the graphics-path naming checkpoint. A path-safe Git comparison
from the audit's authenticated e97026b8 source confirms that data/text/pokemon_names_bank53.asm and
gfx/frame_designs/ have no content or path changes at 8bb48e53. The 25-name block, 25 physical frame
windows, eight KEEP editing-view gaps and their existing previews therefore remain the exact audited
inventory; no Bank53 name-to-window association was added.

The intervening GFX changes updated the shared asset and screen catalogues and renamed other owners'
tile paths. A current make png-check passes: 408 tile sheets, 4 raw byte views, 37 font sheets and 95
screen PNGs. This is a manifest/path reconciliation at current main, not a rerun of the full 208-file,
137-asset Bank41-47 extraction receipt. It found no new missing Bank53-frame PNG report or evidence
linking any name ordinal to an image. Global unused status and natural selection remain unproved.

## Reconciliation at Japanese main `d37251a6c491ab601de4fd5ef4d01872cd874048`

The published changes after `8bb48e53` do not modify the Bank 53 name source, frame owners, asset
catalogue, PNG/screen manifests, or frame directories. This confirms that the finite inventory above
still describes the current Japanese source. A fresh `make png-check` at this revision passes for
408 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs.

The eight KEEP omissions were separately reviewed against their source bytes, component backing,
legacy previews, and provenance in
[`pokemon_names_bank53_asset_followup_20261020.md`](pokemon_names_bank53_asset_followup_20261020.md)
and the row-level matrix in [`assets_pokemon_frames_and_name_limits.md`](assets_pokemon_frames_and_name_limits.md).
Each window has its maintained ROM bytes and legacy preview; the declared conditional U160 model
still has unprovided VRAM keys, so no complete reversible composition is justified. The model is
HYPOTHESIS and its hypothetical clear/upload operation is not an observed original procedure. These
are eight missing editable compositions, not missing ROM assets or missing PNG files. No new asset
or frame view is supported by the current evidence, so all eight remain KEEP.

This closes the finite current-main inventory and KEEP-composition review. The 25 name-to-window
associations, computed readers, natural selection, and global used/unused status remain unresolved;
the absence of an association in the audited selector chain does not prove that none exists.

## Current-main refresh at `60204c03e8637ee62577a90d68c58affea11761c` (2026-10-23)

The scoped presence/export check was rerun against the current published Japanese main. Both `Mobile Trainer (Japan).gbc` and `baserom.gbc` are 2,097,152 bytes and have SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The bank-53 slice at file offset `0x53 * 0x4000` contains the same 369-byte name block: SHA-256 `20a909ec6fcf6726d2b2b3cc2540bc4d897916a18cab24d5892d09600b18d629`, 25 little-endian pointers from `$4032` through `$4164`, and 25 distinct NUL-terminated strings. The ROM build is byte-identical, so the maintained source reproduces this block.

The eight relevant resource directories are the six `gfx/frame_designs/*` owners plus `gfx/browser/frames_0_1/` and `gfx/browser/frames_2_3/`. At this revision they contain 208 tracked assets and PNGs: all 137 non-PNG files have matching `gfx/assets.tsv` rows, and all 71 PNGs are referenced by the PNG rules, screen catalog, or asset catalog. Six owner ASM files are additional tracked files and are excluded from the 208-item asset/PNG count. The current path comparison found zero uncatalogued assets, orphan PNGs, or missing referenced paths. `make png-check` passed (410 tile sheets, four raw byte views, 37 font sheets, 95 screen PNGs); `python3 tools/gfx_export.py check` passed (980 catalog rows); `python3 tools/png_rules.py mk-check` passed (979 rules).

The Japanese build gates also passed at this checkout: `make` reported `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check` reported 335 source files, 12,196 labels and 51 constants; `make palette-check` reported 162 loads in 116 arrays, two documented over-reads and zero errors. This refresh establishes current byte identity and finite asset/PNG presence only. It does not prove natural selection of any frame, a Bank-53 name-to-window mapping, or whether any frame is unused.

## Current-main reconciliation at `c37e1454fe2ee1f3d64d48e66e0ac24c31635413` (2026-10-23)

A path-scoped Git comparison from the prior current-main checkpoint `60204c03e8637ee62577a90d68c58affea11761c` confirms that `data/text/pokemon_names_bank53.asm`, both browser-frame owner directories, and all six `gfx/frame_designs/` directories are unchanged. The 137 Bank 41–47 rows in `gfx/assets.tsv` are byte-for-byte identical to that checkpoint. The current manifest diffs are confined to the separately reviewed 7F MailAddr byte-copy path and the 2D HDMA-tail confidence correction; they do not change this frame inventory.

The current Japanese gates also pass: `make` reports `RESULT: IDENTICAL` against ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passes at 335 source files/12,196 labels/51 constants; `make palette-check` passes at 162 loads/116 arrays/two documented over-reads/zero errors; `make png-check` passes at 410 tile, four raw-view, 37 font and 95 screen PNGs; the GFX catalog has 980 rows and PNG rules have 979 rows. These results keep the finite extraction/presence matrix current. The 25 ordinal-to-window links, any computed reader outside the inspected selector chain, natural selection and global used/unused status remain unresolved; no negative result is promoted to universal absence.

## Reconciliation at current Japanese checkpoint `7b5e23762a74b4330b9238ef058b97a3c7f6c0d1` (2026-10-23)

A path-scoped Git comparison from `60204c03e8637ee62577a90d68c58affea11761c` to this checkpoint finds no changes to `data/text/pokemon_names_bank53.asm`, `gfx/frame_designs/`, `gfx/browser/frames_0_1/`, or `gfx/browser/frames_2_3/`. The intervening `gfx/assets.tsv` and `gfx/png_rules.tsv` edits concern other owners; they add or refine Mail and Notice-header rows and do not change the eight Bank 41–47 resource directories or the Bank 53 source. Thus the audited 369-byte name block, 25 candidate windows, 137 scoped assets, 71 scoped PNGs, and eight KEEP editing-view gaps remain the latest verified finite inventory.

Current-checkout gates were rerun: `make png-check` passes for 416 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs; `python3 tools/gfx_export.py check` passes for 986 catalog rows; `python3 tools/png_rules.py mk-check` passes for 985 rules. The broader repository totals changed as other assets were added. This confirms catalog/rule integrity and scoped source stability, not that the eight KEEP views should be synthesized. No newly missing/orphan Bank 53/frame file, name-to-window mapping, natural selection, or global used/unused proof was found. The Japanese build/symbol/palette gates at the same source state are recorded in the immediately preceding checkpoint; the two later commits changed only agent instructions and census wording.

## Existing natural-trace bank-53 cross-check at `823bc731` (2026-10-23)

The current checkout contains 69 per-scenario `traces/coverage_*.tsv` files. Re-reading their declared first column (`bank = ROM bank actually mapped`) found zero instruction-start rows for physical bank `53` across all 69 files. This is a reconciliation of the retained corpus, not a new emulator run, a complete execution census, or proof that Bank 53 is globally unused. It does not change the 25 name-to-window associations, the two unresolved Porygon entries, or any frame's UNKNOWN/HYPOTHESIS status. The finite inventory remains closed for the audited 137 assets and 71 PNGs; computed readers, scenarios outside the corpus, natural selection and universal used/unused status remain open.

## Scenario data-read corpus recheck at `5e6d275` (2026-10-23)

The current checkout has 70 paired per-scenario `traces/coverage_*.tsv` and `traces/detail/*/dataaccess.tsv` files. Re-reading the data-access reports found 81,995 `rom_read`, 762 `sram_read` and 896 `sram_write` merged ranges, with zero `rom_read` ranges intersecting the Bank 53 name/pointer interval `53:4000–4171` (end-exclusive). The report writer records data loads through `hookLoad8` after mapping the address to a ROM bank; instruction fetches are explicitly excluded. The input set is pinned by aggregate SHA-256 `b9ebe5fbf81b30d7782425f645df7f0c503436e1f972e5045b9669b74bd3dc27`; reproducible counts and limits are in `.tmp/jp-bank53-dataaccess-20261023/RESULT.json`.

This is a re-read of the committed scenario corpus, not a new emulator execution. It establishes only that these 70 recorded scenarios contain no data-load range intersecting the table interval. It does not prove that the names are globally unread, that frames are unused, or that no computed/unobserved reader or scenario exists. The finite PNG/asset inventory remains closed; the name-to-window mapping and natural selection remain unresolved.


## Direct Bank 53 immediate-selector census at `7393820d` (2026-10-23)

A path-scoped scan covered 333 tracked `.asm`/`.inc` files in `home/`, `engine/`, `data/`, `gfx/`, `audio/` and `lib/`, excluding `engine/mail/sample_data.asm` before reading and excluding `languages/`. It enumerated `ld a, immediate` values written in hexadecimal, decimal, or binary whose value is `$53`. The six matches are bounded assignments in `engine/account/confirm_screens.asm` (to `hTextY`) and `engine/browser/page_list.asm` (to `wSpriteSlot2` fields); none writes a ROM-bank selector. The scan also found no external symbolic references to `Table_PokemonNamePointers` or `PokemonName00..24` in that source set.

Reproduction artifacts are in `.tmp/jp-bank53-literal-selector-census-20261023/`: `audit.py` SHA-256 `d6381934766db6b69a3da868a222732ac776871a59dd58940674cfc779405f3a`, `INPUTS.json` SHA-256 `8f4edb32cf2f6e38b91441cd5f026a03b69e68676b8711b763b0743af3e94afb`, and `RESULT.json` SHA-256 `2b8e2a2bc5d9bebc542c1f841c99fab2025b8cbe8424ef816ae87177ccd1bc92`. The immutable original ROM SHA-256 remains `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

This closes only the direct immediate-`A` selector check for the declared source set. It does not exclude values computed at runtime, other instruction forms, pointers or tables, or accesses outside this set. It does not link any Pokémon name to a candidate frame, identify natural Bank 53 selection, or establish used/unused status. No Japanese source, asset, or ROM bytes changed.


## Inline far-call/dispatch byte-pattern census at `ac751d20` (2026-10-23)

A second bounded check inspected the immutable 2 MiB original ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`) for the documented inline conventions `call $06D1 ; dw target ; db bank` (`CD D1 06`) and `call $072E ; dw target ; db bank` (`CD 2E 07`), plus direct helper-call opcodes for `FarJumpTable` (`CD 51 05`) and `JumpTableBank` (`CD 40 05`). The whole-file scan found 5,274 raw FarCall opcode-pattern matches and zero whose following inline bank byte is `$53`; it found zero patterns for the other three helper entries. It also found no FarCall-pattern target word equal to ROM0 jump-table helpers `$0540`, `$0545`, `$0551`, or `$056A`. The 5,274 are raw byte matches, not all individually verified instruction starts.

Reproduction: `.tmp/jp-bank53-inline-farptr-census-20261023/audit.py` SHA-256 `c75c816d613aa77f53b33e8626b28bf3fa35b5ea463b0376e3bcc58105f9eda6`; `RESULT.json` SHA-256 `3e4c9cd8d30d065c6f14f05f1bca499ff36e41367c43bea6fe0504542c77d287`. This excludes only direct inline FarCall/FarJump and direct calls to these table helpers in their documented encodings. Computed bank values, indirect tables, other readers, and natural access remain open; no name-to-frame mapping or used/unused classification follows.

## Whole-ROM raw far-pointer-shaped byte scan at `8d8f024c` (2026-10-24)

A distinct static check scanned every byte offset of the immutable Japanese ROM
for both literal triple layouts that could encode a Bank 53 far pointer to the
name block: `[addr16 little-endian, bank=$53]` and
`[bank=$53, addr16 little-endian]`, with the candidate address restricted to
`53:[4000,4171)`. The reference ROM is 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The scan found 17 and 13 raw byte coincidences respectively. All 30 physical
offsets map to linked sections and are individually classified in the private
reproducibility result; none is an aligned far-pointer field targeting this
interval.

The coincidences resolve to two adjacent same-bank word-table boundaries
(Mail header pointers and the HTML tag-pointer list), five graphics assets,
five font-data locations, six ASCII HTTP strings, three Japanese dialogue
strings, four instruction-opcode sequences, and five opcode/operand overlaps.
The repeated code bytes are ordinary SM83 instructions such as `LD D,E; LD
E,B; LD B,C`; the overlaps include same-bank `CALL` operands and `LD HL,d16`
/`LDH A,[a8]` immediates. These classifications explain the raw triples; they
do not establish that computed or indirect reads of Bank 53 never occur.

This is a bounded negative result for literal inline encodings only. It does
not cover computed bank/address values, registers or stack-derived targets,
indirect tables that do not contain the bank byte inline, runtime copies, or
other encodings. It therefore does not establish natural selection, global
reachability, or used/unused status for the names or frame assets. No Japanese
ASM, graphics, or ROM bytes changed. After rebuilding the current checkout,
`make` reports `RESULT: IDENTICAL` at the pinned ROM hash and `make sym-check`
passes (335 source files, 12,214 labels, 51 constants).

Reproduction: `.tmp/jp-bank53-farptr-scan-20261024/scan.py` SHA-256
`78b723fd9d754abc1386ae58cc720ad83df22f99b03174f8477781d6f5f20734`;
`RESULT.json` SHA-256
`32f857573f244ad65a3efc8f89da0580417f1473b0afbd8f38aa63bde4aca24b`.
The scan pins the rebuilt map and symbol inputs in that result. The private
`.tmp/` artifacts remain retained under the project cleanup policy.
