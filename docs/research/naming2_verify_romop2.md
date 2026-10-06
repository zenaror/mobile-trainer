# Independent verification of the second ROM pointer pass (romop2)

> Status: **reference (current)**.  One reader with a fresh context (R5) tried to break the first version of the pass (77 rows: 76 `ld hl` operands and one inline word) in private copies of the head: every row, the offsets, the 17 new labels, the inline word, the tool with synthetic cases and mutants, the other tools that read the operands, the execution and the style.
> It found no row that is wrong in form and several rules that were too lax and forms that mislead; the tool and the rows were hardened as below.  What the tree contains is the result after that: [`naming2_romop2.md`](naming2_romop2.md).

## 1. Verdicts on the 77 rows of the first version

| verdict | rows |
|---|---|
| UPHELD | 71 |
| UPHELD with a caveat | 5: rows 10 and 12 (the two new `Palette_` labels contradicted the headers and asset types around them), rows 13, 14, 15 (the anchor `Data_22_5CEA` cuts a tile) |
| WRONG LABEL (soft) | 1: row 21 `Data_72_7206 + $0A` (6 of its 8 bytes in the label, an offset off the 8-byte grid; the natural anchor is `Palette_BrowserMenu_Bg6 + $10`) |
| WRONG FORM / UNPROVEN | 0 |

The strongest evidence: the reader **replayed the real ROM code of all 76 `ld hl` sites** on the repository's SM83 interpreter (`tools/sm83.py`, `analysis/rom0_trace.py`, MBC5 and WRAM banks; `Sound_FrameService` and `Font_BlitGlyph8x16` stubbed as `ret`), from the first instruction of its straight line through the far call: in all 76 the consumer read `HL` = the old value with `A` = the label's bank
and read exactly what the rule says (BC bytes for a palette, C x 16 for an HDMA request with `HDMA5 = C - 1`, B x C tile bytes plus B x C bytes from `wRam_C10E/F` for the Ptr tilemap routine, the string up to its NUL); this includes the seven rows that never ran in a natural scenario.  The ROM bytes of every row are `21 lo hi` / `3E bank`.
Re-running the tool on a pristine tree reproduces the changed tree byte for byte, a second run finds nothing, the symbol table differs by exactly the new names.

## 2. Findings and what was done

| finding | what the reader showed | what was done |
|---|---|---|
| F1 rows 10 and 12 (the blocks around them are retyped by `naming2_retype1.md`) | the exact-start branch skipped the kind and the length check: `Palette_4B_5870` started a 40-byte read in a `db` line that runs into `tiles_5878.2bpp` (typed tiles, with an editable PNG, although the bytes are four palettes); `Palette_71_66C0` splits a block whose headers say "tiles-2bpp heuristic" | the exact start runs the same read check as an offset: row 12 is refused (`read crosses`) until the block is retyped; row 10 stays (its lines are untyped `db`, the 8 bytes are a valid palette) with a comment above the label |
| F2 a count of 0 | BC = 0 or B = 0 was read as 0 bytes, hardware and the copy loops do 256 | a zero count is not a proven length (`read not shown`) |
| F3 lines in the middle of a read | only the first line of each labelled block was examined; code, other-kind assets and holes between sections were accepted | `span_ok` examines every line of the read: only an asset of the kind or an untyped `db` / `ds` line may be crossed |
| F4 limits | no bound at `$8000`, no 16-byte alignment for an HDMA source, the Ptr read could cross from the tile half into the attribute half | all three are refused (`read crosses`, `unaligned`, and the Ptr read must stay in the `.tilemap` file) |
| F5 anchors | rows 13, 14, 15 and 21 (above) | the anchor is the nearest label on the 16-byte tile or 8-byte palette: `Gfx_AddrBook_TilesBank22 + $500 / $900 / $400` and `Palette_BrowserMenu_Bg6 + $10` |
| F6 `render_screens.py` | the `ops` table printed the bare label and dropped the offset (the in-memory values were identical) | the label column keeps `+ $offset`.  Testing it showed that the extractor had **lost the RAM names** long before: the RAM operand passes wrote `ld de, wPaletteBufBg` and the symbol file does not list `DEF ... EQU` names, so 549 of 917 operations were unresolved instead of 100 (the committed table is older than those passes).  Fixed (the RAM names are read from `ram/*.asm`, `constants/hardware.inc` and `consts.asm`, the overlay aliases too, and the attribute pointer is found by its address `$C10E/F`): 818 resolved, 99 unresolved; on the tree before the RAM passes (`e2221f5^`) the original tool renders the same pictures as the fixed tool renders on this tree (159 of 160 screens; the one that differs, `ConnectDialog_Draw_ConnectConfirm`, differs in its bottom two tile rows); the committed previews were already stale and are regenerated in a commit of their own |
| F7 documentation and style | the docstring, `STYLE.md` and `INSTALL.md` still described romop1; `STYLE.md` tells readers to find an address quoted in a note by grepping `; BB:AAAA` on label lines, which interior pointers do not have; in 12 of the 24 HDMA rows the anchor's `Tiles<addr>Vb<n>` suffix named another VRAM destination than the call loads to (`Gfx_Registration_Delete_Tiles9400Vb1 + $3C0` loads to `$8801`) | the docstring and `STYLE.md` describe the six columns and the offset form; every offset operand ends in a comment `; BB:AAAA`; a tile sheet label that states its destination is the anchor only when the call loads that destination (15 windows of the first version stay numeric) |
| F8 tests | a mutation run (42 mutants of the new functions) left 21 alive; one test asserted a hole crossing as "an untyped db run" | 15 tests added (zero counts, the bank limit, the unit of the data, the anchor and its destination, the Ptr half, the comment, the inline word guards, `read_assets`, the rules reader, the 40-line window, a read that ends exactly at the end of a block): 74 tests |

## 3. The reader's attacks on the tool

Refused, rightly: a length register changed by a call, a loop, `ld c, a`, `inc`, `dec`, a shift, `ld bc, wCount`, a macro that clobbers BC (`play_sfx`), a conditional skip, a register set before a local label that another path joins; rowscols with B = 0 or C = 0 and c16 with C = 0 (hardware reads 256 or switches HDMA to HBlank mode); `xor a` with a pointer `>= $4000`; an INCBIN with offset / length arguments and an odd-sized INCLUDE past their end.
False refusals (notes, conservative): `push bc / pop bc` or `ld [x], c` between the constant and the call.  The false accepts of the first version (the zero count, the bank limit, lines without a label inside a read, an exact start without a kind check, a palette read crossing into an unlabelled tile INCBIN, the Ptr read across the half, the HDMA source off the tile grid) are the F1 to F4 above; none had a real instance in the tree except row 12.

## 4. Other tools

Identical results in the changed copy and in the original: `make png-check`, `gfx_export check`, `sprite_chain_check` (0 hard mismatches), `apply_ram_operands --check`, `tree_check`, `tidy_comments`, `sym_check`, `conventions_check`, `progress`, `ptr_labels`, `localize_labels`, `apply_banked_names`, `apply_overlay_aliases`, `invariants_check`, `line_addresses.py`, `render_screens.py render` (29 scenes identical).
The one degradation was `render_screens.py ops` (F6).

## 5. Limits

The replay uses the repository's minimal interpreter (no interrupts, no timing; HDMA recorded at the `HDMA5` write, not performed; `LY` synthesised): that the interrupt handlers keep the ROM bank is the romop1 assumption, not shown here.  The natural scenarios were not rerun, only the committed coverage table was joined.  The 22 `block kind` and the 2 `no label` refusals were classified, not
re-proved one by one; the `mapped` and fixed-bank rules (`CopyString`, `MobileSDK_*`, the packet rules) have no applied row here.  The `tiles` blocks of the HDMA rows were themselves cut from these very HDMA calls (their headers say "clipped by higher-priority evidence"), so the kind rule cannot contradict them: the independent evidence there is the consumer, the destination and the replay.
