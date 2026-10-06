# Graphics retyping (retype1): palettes, tilemap pairs and tile sheets typed from their consumers (ROM unchanged)

> Status: **reference (current)**.  The graphics blocks had been typed by heuristics and by the ranges of the HDMA requests, not by what the code reads.  Eleven blobs had HDMA windows that mixed tiles, palettes and/or tilemap bytes (an HDMA request copies the whole 768 or 1,024 bytes into VRAM, so the blob looked like tiles), palette arrays were cut into fragments or typed as tiles, and a 20 x 2 tilemap pair was typed as five tiles.  The reviewed immediate palette loads now lie in single palette blocks (with two explicit over-read exceptions), and the eleven blobs and three special cases have the boundaries shown below. This is not a claim that all graphics in the ROM have a proven type: computed tilemap pointers and mixed blocks remain (section 5).  Every statement of a header about a load (the bytes the call takes, the buffer, the address of the call, whether it ran in a natural scenario) is **generated from the code**, not typed.  `make palette-check` guards the extracted immediate-load boundary contract; coverage and semantics still require review.
> Records: the blocks of `gfx/**/*.asm`, `gfx/assets.tsv`; independent verification: [`naming2_verify_retype1.md`](naming2_verify_retype1.md).

## 1. Result

| item | count |
|---|---|
| tile blobs split into tiles, palettes, gap and tilemap pair | **11** (table in section 2) |
| other retypings | **3**: `4B:5420`/`4B:5870` (the 8 bytes behind the sheet and a 32-byte "tile" block were the 40-byte palette `Palette_Account_ResultPage_Bg`), `71:6680` (a palette array that four heuristic blocks cut in 8 + 24 + 33 + 7 bytes: `Palette_Registration_Delete_Bg` 64 bytes and `_Obj` 8 bytes), `56:526A` (a 20 x 2 tilemap pair, 40 + 40 bytes, typed as 5 tiles + 6 bytes: now a pair and 6 bytes of padding) |
| palette arrays made ONE block each (section 3) | **23**: 21 CONFIRMED, 2 PROBABLE; they replace 53 header regions (a region that two arrays touch counts twice): 2 of the arrays were typed as tiles and 4 sat under a "content class unknown" header |
| assets (before -> after) | tile sheets 409 -> **406** (5 removed: they were not tiles; 2 new: `abook_addr_tiles8800`, `profile_tiles8000`), palettes (`.pal`) 133 -> **144**, tilemap pairs 169 -> **180** (11 new), whole-screen PNGs 83 -> **92** |
| names | 27 new names (18 `Palette_<Screen>_Bg|Obj...`, 9 `Tilemap_<Screen>_<BB>_<AAAA>`), 5 new neutral labels at the starts of what is left over, 43 neutral labels gone (they were inside an array; no named label was lost and no label moved: the symbol table of the build is the same at every address) |
| operands | 25 `ld hl, X` / `ld a, BANK(X)` pairs: 23 are now exact labels (`tools/apply_rom_operands.py`), 1 is the new name of `Palette_71_66C0`, 1 was `Data_6A_62D8 + $18` (now `Palette_HelpMenu_Obj`) |
| tools | `tools/palette_reads_check.py` (`make palette-check`, 18 checker tests and 6 kept-fragment tests), `gfx_export headers` + a `check` rule, `png_rules rules --rebaseline`, a README whose counts are computed |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `png-check`, `palette-check`, `gfx_export check` and 36 of the 37 `checks_all` entries pass; `ramop7` retains its known rc=2 obsolete-format exception) |

## 2. The eleven tile blobs

Before = one `INCBIN` typed `tiles-vram` over the whole length of the HDMA window; after = tiles + the blocks below.  Palettes are 8 bytes per palette (4 colours of 2 bytes); a pair is 18 x 20 tile bytes + 18 x 20 attribute bytes (`Tilemap_CopyRectAndAttr`: the tile half first, then the next 360 bytes).

| blob | tiles kept | palettes (names) | palettes (extent in bytes) | pair |
|---|---:|---|---|---|
| `71:4890` | 960 | `Palette_CommPanel_Bg` | BG `$4C50` 64 | - |
| `5E:6FA0` | 800 | `Palette_Account_ActionConfirmPage_Bg` | BG `$72C0` 64 | `Tilemap_Account_ActionConfirmPage_5E_7300` `$7300` |
| `5E:5210` | 768 | - | - | `Tilemap_Account_LoginIdIntro_5E_5510` `$5510` |
| `5D:6E00` | 512 | `Palette_Registration_WriteConfig_Bg / _Obj` | BG `$7000` 64, OBJ `$7040` 8 | `Tilemap_Registration_WriteConfig_5D_7048` `$7048` |
| `4A:6480` | 256 | `Palette_AdapterCheck_Bg / _Obj` | BG `$6580` 64, OBJ `$65C0` 64 | `Tilemap_AdapterCheck_4A_6600` `$6600` |
| `4B:70B0` | 768 | `Palette_SettingsPhone_ConfirmScreen_Bg` | BG `$73B0` 64 | `Tilemap_SettingsPhone_ConfirmScreen_4B_73F0` `$73F0` |
| `4B:7AD0` | 512 | `Palette_SettingsPhone_ContinuePrompt_Bg` | BG `$7CD0` 64 | `Tilemap_SettingsPhone_ContinuePrompt_4B_7D10` `$7D10` |
| `4A:4E40` | 832 | `Palette_SettingsMenu_Bg / _Obj` | BG `$5180` 40, OBJ `$51A8` 8, gap `Data_4A_51B0` 32 | `Tilemap_SettingsMenu_4A_51D0` `$51D0` |
| `4D:7470` | 256 | `Palette_SettingsPhone_SlotMenu_Bg / _Obj` | BG `$7570` 40 (the call takes 64), OBJ `$7598` 8 | `Tilemap_SettingsPhone_SlotMenu_4D_75A0` `$75A0` |
| `4D:5510` | 0 | `Palette_SettingsPhone_ChoiceMenu_Bg / _Obj` | BG `$5510` 40 (the call takes 64), OBJ `$5538` 8 | `Tilemap_SettingsPhone_ChoiceMenu_4D_5540` `$5540` |
| `63:6CC0` | 768 | - | - | `NoAdapter_Tilemap` `$6FC0` (the pair was formerly split into 256 + 464 bytes) |

Two of the BG palettes are over-read by their call: `slot_menu.asm` and `choice_menu.asm` load the BG palette with `bc = $40` although the array is shorter; the call takes 24 bytes past the end of the block (the OBJ palette at `$7598` / `$5538` and the first 16 bytes of the tilemap pair land in BG palettes 5-7).  The 40-byte length is therefore **by adjacency** (the OBJ palette is read at the next 8 bytes, the pair after it; the words behind are not RGB555), not by the call: PROBABLE, and the header of the block says so (`the call takes 24 bytes past the end of this block`); `palette-check` allows exactly this exception.
At `4D:5510` the same label `Data_4D_5510` is the source of an HDMA request of `$300` bytes **and** of the BG palette load: the request copies the palette array and the tilemap into VRAM as tiles (the original does that; the first bytes are blank tiles), so the old label stays as an alias of the palette block and the code is unchanged.
The 32-byte block `Data_4A_51B0` is four copies of the colours `0000 294A 56B5 7FFF` (a grey ramp that occurs 55 times by non-overlapping `bytes.count` in the ROM as a default palette block): HYPOTHESIS that it is the unread OBJ palettes 1-4; no code read was found.
The names say the screen (the routine that loads them) and `Bg` or `Obj` (the buffer the call loads: `wPaletteBufBg` / `wPaletteBufObj`); a tilemap is named by its bank and address.  The plain names `Tilemap_SettingsMenu` (4A:54A0, the hidden-mode pair) and `Tilemap_Account_ActionConfirmPage` (5E:75D0, the pair of the variant that is not 0) belong to the **non-default** variants; the pairs of the default variants carry the address suffix.  Both names are true; a later naming pass may swap them.

## 3. The 23 palette arrays of part 2

A palette load takes `bc` bytes from `hl`.  Each array below is the union of the loads that overlap; it was cut in fragments by an old heuristic (a block "read as data" of 8 bytes, a heuristic block of 24, ...), typed as tiles (`4A:5C70`, `5D:65F0`), or sat in one block under a header that said "content class unknown" (`51:5880`, `5D:7B60`, `5E:4D00`, `71:4C90`).  The parts of the touched regions that lie outside an array stay as they were (labels, assets) under shortened headers; a label with a meaningful name is never dropped (the tool refuses the array instead).

| array | bytes | loaded by (offset, bytes into buffer) | blocks merged | status |
|---|---:|---|---:|---|
| `1A:5390` `Palette_MobileDict_Bg` | 64 | bc=$40 into wPaletteBufBg | 2 | CONFIRMED |
| `1D:6230` `Palette_MailMenu_Bg` | 64 | bc=$40 into wPaletteBufBg | 4 | CONFIRMED |
| `1D:6270` `Palette_MailMenu_Obj` | 64 | bc=$40 into wPaletteBufObj | 4 | CONFIRMED |
| `22:5C50` `Palette_CommProgress_Bg` | 64 | bc=$40 into wPaletteBufBg | 2 | CONFIRMED |
| `25:69B0` `Mailbox_BgPalette` | 64 | bc=$40 into wPaletteBufBg; bc=$40 into wPaletteBufBg; bc=$40 into wPaletteBufBg | 2 | CONFIRMED |
| `25:6EF0` `Mailbox_ObjPalette` | 64 | bc=$40 into wPaletteBufObj; bc=$40 into wPaletteBufObj; bc=$40 into wPaletteBufObj | 3 | CONFIRMED |
| `27:74E0` `MailConnect_BgPalette` | 64 | bc=$40 into wPaletteBufBg | 2 | CONFIRMED |
| `2C:6F90` `Palette_AddrPick_Bg` | 64 | bc=$40 into wPaletteBufBg | 3 | CONFIRMED |
| `2E:7590` `Palette_MailServerMgr_Bg` | 64 | bc=$40 into wPaletteBufBg; bc=$40 into wPaletteBufBg | 2 | PROBABLE |
| `2F:7D90` `Palette_AbookAddr_Bg` | 64 | bc=$40 into wPaletteBufBg | 3 | CONFIRMED |
| `4A:5C70` `Palette_Account_ConfirmManualScreen_Bg` | 64 | bc=$40 into wPaletteBufBg | 1 | CONFIRMED |
| `51:5880` `Palette_CommTime_SummaryB` | 64 | bc=$40 into wPaletteBufBg; bc=$40 into wPaletteBufBg | 1 | PROBABLE |
| `5D:65F0` `Palette_Account_ConfirmScreen_Bg` | 64 | bc=$40 into wPaletteBufBg | 1 | CONFIRMED |
| `5D:7B60` `Palette_PwSaveConfirm_Bg` | 64 | bc=$40 into wPaletteBufBg | 1 | CONFIRMED |
| `5E:4D00` `Data_5E_4D00` | 64 | 8 loads of bc=$40 into wPaletteBufBg; keyboard load at +$28, bc=$18 into wPaletteBufBg + $28 | 1 | CONFIRMED |
| `63:7290` `NoAdapter_Palette_Bg` | 64 | bc=$40 into wPaletteBufBg | 2 | CONFIRMED |
| `6A:62B0` `Palette_HelpMenu_Bg` | 64 | bc=$40 into wPaletteBufBg | 4 | CONFIRMED |
| `6A:62F0` `Palette_HelpMenu_Obj` | 64 | bc=$40 into wPaletteBufObj | 3 | CONFIRMED |
| `71:4C90` `Palette_CommPanel_Obj` | 8 | bc=$08 into wPaletteBufObj | 1 | CONFIRMED |
| `72:7200` `Palette_BrowserMenu_Bg6` | 16 | bc=$10 into wPaletteBufBg + $30 | 2 | CONFIRMED |
| `72:7210` `Palette_BrowserMenu_Obj4` | 8 | bc=$08 into wPaletteBufObj + $20 | 2 | CONFIRMED |
| `73:5DE0` `BrowserStart_Palettes` | 64 | bc=$40 into wPaletteBufBg | 4 | CONFIRMED |
| `73:5E20` `BrowserStart_ObjPalettes` | 64 | bc=$40 into wPaletteBufObj | 3 | CONFIRMED |

CONFIRMED means that every load of the array ran in a natural scenario (`analysis/coverage_union.tsv`) and that no call takes more bytes than the block holds; `2E:7590` and `51:5880` have a second load that no natural scenario reached.  The two over-read blocks of section 2 and the arrays that no load reaches through an immediate address (tables, computed pointers) are outside this rule.

## 4. Tools, checks and what changed in them

* `tools/retype_blobs.py`, `tools/retype_palettes.py`, `tools/retype_lib.py` (a one-shot pass: on the retyped tree `retype_palettes.py` finds nothing left and `retype_blobs.py` stops at an assertion): the headers are generated from `gfx/previews/screen_ops.tsv` (the loads), `tools/line_addresses.py` (the address of each call) and `analysis/coverage_union.tsv` (did it run).  An earlier version wrote the size of the block as the `bc` of the call; the reader found it false at `4D:7570`, which is why the generator now takes everything from the code.
* `tools/palette_reads_check.py` (`make palette-check`): every extracted immediate palette load reads exactly one palette block, except the two independently reviewed BG over-reads at `4D:5510` and `4D:7570`. Their headers must state the exact excess, their regions must be contiguous without overlaps, and their tails must include non-palette data; a comment cannot register another exception.  It fails on the commit before this one (38 arrays) and passes now (116 arrays, 2 documented over-reads).
* `tools/gfx_export.py`: a region header that says "content class unknown" above an exported asset now says the kind (`gfx_export headers`, run by `export`; `check` fails while one is left: 10 were left by earlier passes).  The counts of `gfx/README.md` (tile sheets, palettes, maps, screens) are computed, not typed.
* `tools/png_rules.py rules --rebaseline` after the pass: the baseline hashes of the truncated sheets were the old ones, so `png_rules.py edited` listed them and `make` printed "EDITED GRAPHICS" on an untouched tree (found by the reader).

## 5. What was not done

* The 14 HDMA windows whose sheet label states another VRAM destination stay numeric (`naming2_romop2.md`); one window (`engine/settings/confirm_screen.asm:42`) starts inside a neighbouring sheet and runs through the retyped blocks and stays numeric; 2 `CopyString` pointers have no label; 3 vectors.
* A tilemap or palette block that no code of a natural scenario reads keeps the status of its old header.
* The round-2 reader found inherited mixed blocks outside the pass: `5C:6350-$6420` contains three separate 64-byte palette assets and a 16-byte object record under an old tile header; the browser start-choice maps at `73:438F` / `$43F3` have explicit attribute sources at `$43D5` / `$4439`, and its five animated 5 x 7 maps at `$447F-$452E` have attributes at `$452E-$45DD`, partly inside a block exported as tiles. These are recorded for a separate consumer-driven retyping pass; this pass did not retype them.
* `25:69F0-$6AC8` contains a kept tile asset and eight raw bytes, not the old palette heuristic. `25:6E71-$6EF0` is a 127-byte generic data fragment that fails RGB555 validation. Round 2 corrected their generated notes and added regression tests; the inherited executed-data status is not proof of a palette role or of every byte in the fragment.
* The tile sheets `abook_addr_tiles8800` and `profile_tiles8000` were converted by the same `gfx_export export` run (their labels said tiles; the bytes round-trip); nobody had looked at what they show.

## 6. Reproduce

```
make                                      # a built tree (the scripts read build/mobile_trainer.sym)
python3 tools/retype_blobs.py ; python3 tools/retype_blobs.py special ; python3 tools/retype_palettes.py
python3 tools/gfx_export.py export ; python3 tools/gfx_export.py png ; python3 tools/gfx_export.py png ; python3 tools/png_rules.py rules --rebaseline
python3 tools/gfx_export.py check ; python3 tools/gfx_export.py readme ; make
python3 tools/screen_png.py derive ; python3 tools/screen_png.py export --force ; make baserom.gbc ; python3 tools/render_screens.py ops ; python3 tools/render_screens.py render
make png-check ; python3 tools/apply_rom_operands.py ; make ; make sym-check ; make palette-check
python3 tools/render_screens.py ops ; python3 tools/gfx_export.py readme # after final labels and screen derivation
```
