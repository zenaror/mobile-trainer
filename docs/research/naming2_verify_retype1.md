# Independent verification of the graphics retyping (retype1)

> Status: **reference (current); the verification is incomplete.**  One reader with a fresh context (T7) reviewed the first version of the pass (the nine tile blobs) in round 1 and found no
> wrong tile, pair or palette boundary in them, but several false texts, stale artifacts and missed members of the family; everything it found is integrated, and the pass was widened to the whole
> family (`naming2_retype1.md`).  **Round 2 (the widened pass: two more blobs, three special cases, the 23 palette arrays, the new tools) was started and stopped before it reported** (the session ran
> out of quota): its brief is kept outside the repository; a new reader should do it.  What protects the widened part meanwhile: the ROM is byte-identical, `make palette-check` passes (it fails on
> the commit before the pass), the build symbol table has no moved label and no lost named label, and the 36 checks of the suite pass.

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

## 3. Limits

The reader of round 1 had no emulator output for the new screens (replay of the routines only).  Round 2 did not report: the 23 palette arrays, the two new blobs, the three special cases and the
tools `retype_lib.py`, `retype_blobs.py`, `retype_palettes.py`, `palette_reads_check.py` have no independent verification yet; their checks are mechanical (build, symbol table, palette check).
