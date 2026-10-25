# Independent reference of the second ROM pointer pass (romop2)

## 1. Verdicts on the 77 rows of the first version

| verdict | rows |
|---|---|
| UPHELD | 71 |
| UPHELD with a caveat | 5: rows 10 and 12 (the two new `Palette_` labels contradicted the headers and asset types around them), rows 13, 14, 15 (the anchor `Data_22_5CEA` cuts a tile) |
| WRONG LABEL (soft) | 1: row 21 `Data_72_7206 + $0A` (6 of its 8 bytes in the label, an offset off the 8-byte grid; the natural anchor is `Palette_BrowserMenu_Bg6 + $10`) |
| WRONG FORM / UNPROVEN | 0 |

## 3. The reader's attacks on the tool

Refused, rightly: a length register changed by a call, a loop, `ld c, a`, `inc`, `dec`, a shift, `ld bc, wCount`, a macro that clobbers BC (`play_sfx`), a conditional skip, a register set before a local label that another path joins; rowscols with B = 0 or C = 0 and c16 with C = 0 (hardware reads 256 or switches HDMA to HBlank mode); `xor a` with a pointer `>= $4000`; an INCBIN with offset / length arguments and an odd-sized INCLUDE past their end.
False refusals (notes, conservative): `push bc / pop bc` or `ld [x], c` between the constant and the call.  The false accepts of the first version (the zero count, the bank limit, lines without a label inside a read, an exact start without a kind check, a palette read crossing into an unlabelled tile INCBIN, the Ptr read across the half, the HDMA source off the tile grid) are the F1 to F4 above; none had a real instance in the tree except row 12.

## 4. Other tools

Identical results in the changed copy and in the original: `make png-check`, `gfx_export check`, `sprite_chain_check` (0 hard mismatches), `apply_ram_operands --check`, `tree_check`, `tidy_comments`, `sym_check`, `conventions_check`, `progress`, `ptr_labels`, `localize_labels`, `apply_banked_names`, `apply_overlay_aliases`, `invariants_check`, `line_addresses.py`, `render_screens.py render` (29 scenes identical).
The one degradation was `render_screens.py ops` (F6).
