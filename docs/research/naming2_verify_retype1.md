# Independent verification of the graphics retyping (retype1)

> Status: **reference (current)**. Round 1 reviewed the first nine blobs; its findings were integrated before `5b9ffc2`. Round 2, resumed on 2026-10-06 by two readers with fresh contexts and separate private copies of `5b9ffc2`, reviewed the widened data/operand scope and the tools/artifacts scope. No introduced palette, pair or tile boundary was refuted. Two false fragment notes, two checker defects and stale artifacts/text were found and corrected below. Inherited mixed graphics outside the pass remain explicitly open; this review is not a claim that every graphics block in the ROM is correctly typed.

## 1. Round 1 verdicts (first version: nine blobs)

| item | verdict |
|---|---|
| tile ends of the nine blobs | **UPHELD 9/9** (the first palette or tilemap read; the highest tile number that the pairs use is below each cut) |
| new tilemap pairs | **UPHELD 8/8** (360 + 360 bytes; replayed buffers equal the ROM) |
| palette extents | 11/12 equal the bytes of their call; the 12th, `4D:7570`, is 40 bytes although the call takes `$40`: PROBABLE by adjacency, not by the call |
| Bg / Obj roles | **UPHELD 12/12** (each label is loaded into the buffer its name says) |
| the 20 operands of the first version | **UPHELD 20/20** (start, bank, length; replay with `analysis/rom0_trace.py`) |
| assets | all 955 assets of the tree equal the ROM bytes; every rebuilt PNG round-trips |

## 2. Round 1 defects and what was done

| defect | done |
|---|---|
| the header of `4D:7570` said `bc=$28` (the call takes `$40`): the script wrote the size of the block as the `bc` of the call | every header about a load is now generated from the code (`tools/retype_lib.py`: the bytes the call takes, the buffer, the address of the call, whether it ran); over-reads are said in the header and are PROBABLE |
| the pair header of `4D:75A0` gave the address of the `ld hl` (67:4DEA), not of the call (67:4DEF), and no execution clause | generated from the call site: `67:4DEF executed: 12 hits in 3 scenarios` |
| tails described as "a palette and a tilemap" where only one of them was there (`71:4890`, `5E:5210`); "content unresolved" for `Data_4A_51B0` | tail text computed per blob; the gap is four grey ramps that occur 55 times in the ROM (HYPOTHESIS: unread OBJ palettes) |
| `gfx/png_rules.tsv` kept the old baseline hashes of the cut sheets (`make` listed them as edited on an untouched tree) | `python3 tools/png_rules.py rules --rebaseline`; `png_rules.py edited` is empty |
| six headers said "content class unknown" above `.pal` assets (and 10 older ones existed) | `gfx_export export` rewrites them, `gfx_export headers` does it alone, `gfx_export check` fails while one is left |
| three inherited palette fragments converted with a wrong cut (`browser_menu_bg6`, `help_menu_bg`, `registration_delete_bg`) | retyped as the arrays of their loads (`tools/retype_palettes.py`, special case `71:6680`) |
| missed members of the family: `4D:5510`, `5D:65F0`, `4A:5C70`, `56:526A`, `63:6CC0`, `Palette_4B_5870` | all retyped |
| counts and old statements in nine files (gfx/README, EDITING_IMAGES, TRANSLATION, STYLE, the image inventory, sprite_format, data2b, romop1, romop2) | rewritten; the README counts are computed now |
| names: the plain `Tilemap_SettingsMenu` and `Tilemap_Account_ActionConfirmPage` belong to the non-default variants | noted in `naming2_retype1.md` section 2; not renamed |

## 3. Round 2: data and operands

The data reader checked all 23 palette arrays and all 37 load sites against source compiled in a marked private copy, the ROM and `analysis/coverage_union.tsv`: **23/23 boundaries and 21 CONFIRMED / 2 PROBABLE upheld**. The two PROBABLE arrays (`2E:7590`, `51:5880`) each have a load not reached naturally. All 11 blobs and three special cases were checked. The two over-read BG blocks remain 40 bytes, PROBABLE; their calls read 64 bytes, including the adjacent OBJ palette and 16 tilemap bytes.

All **25/25 operand pairs** were replayed with the repository's CPU interpreter: the four load instructions immediately before each consumer, then the real `CopyBytes` or `Tilemap_CopyRectAndAttr` code (bank-switch infrastructure hooked). Bank, source, length, destination and read addresses matched. These replays do not constitute new natural execution, PPU validation or hardware tests.

Symbols versus a built `d77dd95`: **43 removed**, all neutral `Data_BB_AAAA`; **32 added** (27 semantic + 5 neutral); **no shared symbol moved**. The 24 removed assets have no live source reference. The 33 common PNGs that changed are the expected nine truncated sheets and 24 previews (nine metadata-only, 15 pixel changes after palette repair).

The complete family of seven kept fragments was checked:

| fragment | finding / correction |
|---|---|
| `25:69F0-$6AC8` | 216 bytes, `.2bpp` asset 208 + raw 8; inherited 116-word / 29-palette text was false. The generator now states kept tile data and unclassified raw bytes without palette counts. |
| `25:6E71-$6EF0` | 127 bytes, odd length and words above `$7FFF`; inherited RGB555 class was false. Now generic executed-read data with unknown content class. CONFIRMED preserves the containing region's historical data-read evidence, not a palette role or every byte's use. |
| `1A:53D0-$55A0`, `1D:62B0-$6320`, `2E:75D0-$76C0`, `6A:6330-$6448`, `73:5E60-$5EC0` | all valid RGB555; counts 232/56/120/140/48 words respectively, PROBABLE. The generator validates the actual fragment before emitting a heuristic. |

The `5E:4D00` table understated nine loads as three. Corrected to eight BG64 loads and the keyboard BG24 load at offset `$28`; all nine call addresses have natural coverage. Both manually added OBJ names point to the claimed buffer (HelpMenu: `$D840`; BrowserMenu Obj4: `$D860`). The grey-ramp occurrence count is 55 with non-overlapping `bytes.count` (129 if overlapping matches are counted).

## 4. Round 2: tools and artifacts

The tool reader reproduced two checker false accepts on `71:4C50-$4C90`: splitting the palette into 8+56 bytes and adding a false excess sentence; or leaving a stale first header that contains the second fragment. The original tool accepted both.

Corrections in `tools/palette_reads_check.py`:

* An ordinary read intersects exactly one palette region; an enclosing stale header cannot hide an overlapping region.
* Only **two independently reviewed exceptions** qualify: BG loads `4D:5510-$5550` and `4D:7570-$75B0` in `REVIEWED_OVERREADS`. Each begins at the palette start, has the exact numeric excess, spans contiguous non-overlapping regions and includes non-palette tail data. A comment cannot register a new exception.
* **18 checker tests** (11 original fixtures (one completed) plus seven added regressions) cover wrong excess, all-palette tails, stale/overlapping headers, gaps, wrong starts and an unreviewed exception with a plausible sentence. **Six fragment-generator tests** cover odd/high-bit bytes, local counts/status, kept tiles and a removed palette asset outside the fragment, and preservation of the historical read evidence. Both scripts run in `make test`.

The reviewed current tree still reports **162 loads / 116 arrays / 2 documented over-reads / 0 errors**. The same load addresses against pre-pass headers produce 38 errors. The checker proves this structural contract over the extracted immediate loads; it does not prove status, semantics or completeness of the extractor.

The artifacts/text corrections are:

| artifact | correction / verification |
|---|---|
| `gfx/README.md` | regenerated after final screen derivation: 92 screens, 88 tilemaps without screen PNG (old 83/97). |
| `gfx/previews/screen_ops.tsv` | regenerated: 23 operand spellings now use current labels; 818 resolved / 99 unresolved operations, lengths/banks/destinations unchanged. |
| `naming2_retype1.md` | completed `63:6CC0` cell, corrected nine `5E:4D00` loads, bounded global claims and test/check counts. |
| `REVERSE_ENGINEERING.md` | 23 palette arrays (old 0), current asset/symbol totals, known `FFA7` writers separated from unproven injection role. |
| `STYLE.md` | structural checker contract and two explicitly approved exceptions. |

Assets counted independently: **919 -> 949**, tiles **409 -> 406**, palettes **133 -> 144**, maps/attributes **169 -> 180** each. All 23 arrays' 53 touched original regions match the table. The inventory's 406 live tile counts match the assets; five removed rows have zero tiles. `screen_png derive` reproduced `screens.tsv`; export found all 92 screens byte-identical. Unknown headers above assets are rejected by `gfx_export check`; the `headers` repair is idempotent. `png_rules edited` is empty and `mk-check` passes.

The complete repository suite on the reviewed baseline has **37 checks: 36 rc=0; `apply_manual_sites --dry-run ramop7` rc=2**, the known obsolete record-format exception. This is not an all-zero suite. The corrected private copy also completed all 37 checks with the same sole `ramop7` rc=2 exception. The final real-tree run completed the same 37 checks: 36 rc=0 and only the known `ramop7` rc=2; the last generator/test refinement was additionally checked with all 18 + 6 focused tests. `make`, `sym-check` and `palette-check` remain clean and the ROM is byte-identical.

## 5. Limits and inherited typing work

No new emulator screenshots or hardware execution were produced. CPU replays validate byte consumption, and natural execution status comes from the existing coverage. The image inventory's linguistic/visual interpretation was not re-reviewed.

The readers found inherited typing issues outside retype1:

* `5C:6350-$6420`: three correct `.pal` assets of 64 bytes each, then a 16-byte object record under an old tile header.
* Browser start-choice explicit sources: map `73:438F-$43AD` / attrs `$43D5-$43F3`, map `$43F3-$441B` / attrs `$4439-$4461`. These are not contiguous pairs.
* Browser start-choice animation: five 5 x 7 maps `$447F-$452E` and attributes `$452E-$45DD`; old headers split the attributes and classify part as tiles. Proof is the computed pointer in `BrowserStart_AnimateFrame` (`73:6265`).
* `22:5CD0-$66D0` tile windows under palette/unknown headers, and `25:6AC8-$6BD1` unknown data inside tile windows. An HDMA read alone does not prove exclusive tile content: `26:7AB0-$7ABC` includes a sprite object over-read and must not be retagged mechanically.

The direct scan found 109 unknown regions, rather than the brief's old 119. All extracted immediate operations were compared, but computed/table-driven reads were not exhaustively resolved. These issues need a separate pass and independent review. They do not change the byte-identity result of this pass.
