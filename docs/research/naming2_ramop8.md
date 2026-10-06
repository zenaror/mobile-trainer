# The two screen buffers of WRAM bank 7 (ramop8): wScreenTileMap and wScreenAttrMap written as names

> Status: **reference (current)** for the operands it rewrites.  Follows [`naming2_ramop7.md`](naming2_ramop7.md) (sprite slots and palette buffer of bank 7; the bank proof, the rule file and the effect table are described there).
> Records: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv), [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv); tool: `tools/apply_ram_operands.py --areas wramx`;
> independent verification: [`naming2_verify_ramop8.md`](naming2_verify_ramop8.md).

## 1. Result

| item | count |
|---|---|
| banked WRAM pointer operands written as the name of a screen buffer | **303** in 69 files: 272 `wScreenTileMap` and 31 `wScreenAttrMap`, 150 of them with an offset (`ld de, wScreenTileMap + $121`, `ld hl, wScreenAttrMap + $E0`) |
| by consumer | `Tilemap_CopyRectAndAttr` 163, `Tilemap_FillAscendingWithAttr` 43, `Tilemap_FillRectSequential` 19, `Tilemap_CopyRectAndAttrPtr` 17, `Tilemap_ApplyMaskRect` 5, `Gfx_StartHDMA*` 18, `CopyBytes` 25, `CopyBytesBackward` 8, `FillBytes` 5 |
| new names in `ram/banked.asm` | 2: `wScreenTileMap` (W7, `$D000`, 1,024 bytes), `wScreenAttrMap` (W7, `$D400`, 1,024 bytes) |
| banked WRAM operands left numeric | 1,490 of 3,328: 1,281 without a consumer rule, 175 whose bank is not shown to be 7, 20 with bank 7 shown but no name (`$D880`, `$D900`, `$DC00`), 14 values |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, the audits and the 36 tool tests pass; every changed line is an operand replaced by an expression of the same value) |

## 2. What the two buffers are

Bank 7 `$D000-$D7FF` is the screen buffer pair of the UI engine:

* `wScreenTileMap` (`$D000-$D3FF`): the tile numbers of a 32 x 32 map, row stride `$20` (`Tilemap_CopyRect` 00:0904, the `and $1F` stride); the 20 x 18 visible tiles are its top left corner (an offset is `$20 * row + column`).
* `wScreenAttrMap` (`$D400-$D7FF`): the attributes of the same map, always `$0400` above: the second pass of `Tilemap_CopyRectAndAttr` (00:08EA) and `Tilemap_CopyRectAndAttrPtr` (00:16A2) works at DE + `$0400`, `Tilemap_FillAscendingWithAttr` (4F:45C6) stores the attribute at H + 4,
  `Tilemap_FillRectSequential` (48:4679) fills HL + `$0400` through `Tilemap_ApplyMaskRect`.
* They are sent to VRAM by `Gfx_UploadBgMapBuffers`, `...Di`, `...NoService` and `Gfx_UploadWinMapBuffers` (00:082C, 00:07CB, 00:085B, 00:0887): two transfers started with `HDMA5` bit 7 = 0 (general-purpose DMA, which the project calls HDMA) of `C = $24` blocks of 16 bytes, `$D000` to the map of VRAM
  bank 0 and `$D400` to the map of VRAM bank 1 (`E` bit 0 goes to `rVBK`), at `$9800` or `$9C00` (`D = $98` or `$9C` from LCDC bit 3 or 6).  That is `$240` bytes, 18 rows, not the 1 KiB the old comments said (they are corrected); only `CommScene_UploadBackgroundMap` (70:4638, `C = $40`) sends all `$400` of each.
* Corroboration: `frame_style_chooser.asm` restores a snapshot cell by cell (`$D000 + bc` from `sBrowserFramePreview`, `$D400 + bc` from `+ $400`); `frame_graphics.asm` saves `$0800` bytes from `$D000`; `Dialog_SaveBackground` uses rows 23-31 (`$D2E0 + $120 = $D400`) as a save area; the keyboard uses rows 18-30;
  109 of the 242 `Tilemap_*` sites copy the full 18 x 20 rectangle at offset 0; all 242 rectangles fit in 32 x 32 and no attribute pass leaves `$D400-$D7FF`.  Nothing else uses bank 7 `$D000-$D7FF`: the bank 7 text tile staging is `$DC00-$DFFF`.
* Execution: `00:082C` ran in 63 of the 64 scenarios of `analysis/coverage_union.tsv` and under bank 7 only (from 00:0833) in all 41 bank-observed replays; `00:08EA` and `00:0904` in 63, `00:16A2` in 46, `48:4679` in 49, `4F:45C6` in 53, all under bank 7 only inside.  Never executed and without a caller in the tree:
  `Tilemap_ClearBuffers` (00:093B), `Tilemap_CopyRectAndAttrSplitSrc` (00:08CA), `Gfx_UploadWinMapBuffersDi` (00:07FB).

## 3. Rules and proofs

The mechanism is that of `naming2_ramop7.md`; this pass adds (details in the tool's docstring and in the rule and effect files):

* **Rules.** `Tilemap_CopyRectAndAttr`, `...Ptr` (and `...SplitSrc`, which has no site) with `de`, `Tilemap_FillRectSequential` and `Tilemap_FillAscendingWithAttr` with `hl`: each selects bank 7 itself (`needs = -`), and the family is `wScreenTileMap` **only**: they write a second rectangle at `+ $0400`, so a pointer
  inside `wScreenAttrMap` would write into the palette buffer.  `Tilemap_CopyRectAndAttr*` take the region from D (`BankSwitch_D`: below `$80` a ROM bank, `$80-$BF` an SRAM bank, `$C0` and up a WRAM bank): all 189 call sites pass a DE in `$D000-$DFFF`.
* **`needs = a`** for `Gfx_StartHDMA`, `Gfx_StartHDMAWithService` and `Tilemap_ApplyMaskRect` with `hl`: the routine calls `BankSwitch_H` with A = the bank of the pointer in the region of HL (for `$Dxxx` a WRAM bank), and `A = 0` leaves the bank in force.  The tool reads A from the nearest `ld a, $NN` or
  `xor a` before the call (any other write of A, a label, a jump or a call on the way gives up) and, for 0, shows the bank by the idiom.
* **Effect `keeps if A=0`** for the same three routines (with A = 0 every `BankSwitch_H` returns at once, on every path including the wait loops), `keeps` for `Tilemap_FillRectSequential`, `Tilemap_FillAscendingWithAttr`, `Gfx_WaitForFrameTop`, `CopyBytesBackward`, and `sets W7` for `Tilemap_ClearBuffers`,
  `Gfx_UploadBgMapBuffersNoService`, `Gfx_UploadWinMapBuffersDi`, `Gfx_UploadWinMapBuffers`.
* **Generic rules**: `FillBytes hl`, `CopyBytes hl|de`, `CopyBytesBackward hl|de` with `needs = switch`, families `wScreen(Tile|Attr)Map|wPaletteBuf(Bg|Obj)`.

## 4. What the independent reader changed

Verdicts: 5 of the 10 consumer rows upheld and 5 corrected (the family of the five `Tilemap_*` rows: `wScreen(Tile|Attr)Map` -> `wScreenTileMap`, 0 operands change), the 8 effect rows upheld, all 276 operands of the first run upheld (the reader re-derived every one).
Corrections made: the family of the five rows; the missing effect row `Gfx_WaitForFrameTop keeps` (the idiom sits 8-12 lines above ten HDMA starts in `home/gfx_upload.asm` and four in `engine/dialog/dialog.asm`, with one call to it between: +14 operands, 7 + 7); the optional package that the reader
validated (`CopyBytesBackward`: 8 operands in `dialog.asm`; `Tilemap_ApplyMaskRect`: 5 operands, the sixth `Tilemap_*` consumer, which takes its bank in A: +13); the `DEF` comments of the two names ("send it by HDMA" was stronger than the code: 576 of 1,024 bytes; the count "37 scenarios" was the bank-observed count of one
uploader; three routines cited as evidence never ran); the comments of the five uploaders in `home/gfx_upload.asm` (`C = $24` blocks are 576 bytes, not 1 KiB); a comment at `frame_graphics.asm` (`$0800` bytes read through the first name); a latent flaw of the tool (a one-operand `add $01` or `add b` writes A but was not
seen as a write of A in `a_before`: no such line in the tree, 3 tests added that kill the mutants of the new logic); the stale statements of the previous notes ("all select bank 7 themselves", the counts of rows and tests).

## 5. Left numeric: 1,490 operands

| family | sites | what is needed |
|---|---|---|
| no consumer found in the straight line (a register used directly, a loop or a branch comes first) | 608 | per-site reading; about 57 direct uses and base-register patterns have bank 7 evidence (`address_picker.asm` 16, `help_menu.asm` and `mail_menu.asm` `ld de, $D000 / add hl, de`, `frame_graphics.asm`, `connect_dialog_screen.asm`) |
| `TextTiles_*` (`RenderLine` 145, `RenderGrid` 23) | 175 | the bank is the value stored in `hTextTiles_DestBank` just before; the staging buffers of banks 2 and 3 are unnamed |
| mail, address book, text entry, account (`Mail*`, `Text*`, `Abook*`, `Wram3_*`, `Settings_*`) | 279 | banks 1, 3 and 5 hold named objects already; many sites would take a name once the bank is shown |
| generic memory routines, other routines, `PageList*` and `Gfx_*` (`Gfx_GdmaAtVBlankNoDi` 14, ...) | 219 | the bank in force; names |
| 175 sites whose bank is not 7 (`Gfx_StartHDMAWithService` 117, `FillBytes` 42, `CopyBytes` 15, `Tilemap_ApplyMaskRect` 1) | 175 | banks 2 and 3 (explicit A or the idiom), a few banks 1, 4, 6: the tile staging windows |
| bank 7 shown but no name: `$D880` x14 and `$D900` x2 (the fade buffers of `PalFade_*`), `$DC00` x4 (another 1 KiB buffer, the bank 7 text tile staging) | 20 | names |

Other spellings of the same buffers (found by the reader, not rewritten): 100 uses of the neutral names `wRam_D000`..`wRam_D7FF` in bank 7 in five files (`tidy_screen.asm` 36, `menus.asm` 32, `connect_dialog_screen.asm` 20, `mail_session_screen.asm` 6, `delete_messages.asm` 6; a tile cell
`wRam_D1A6` pairs with the attribute cell `wRam_D5A6`; evidence: observed bank 7 only or the idiom earlier in the function); the table `Table_CommNotice_DigitCells` (`engine/comm/notice_dialog.asm:480`, eight words `$D0A3`...); eight HDMA sites in `connect_dialog_screen.asm` whose bank comes back through
`pop af / ldh [hWRAMBank], a / ldh [rSVBK], a` or a label with several predecessors (a push/pop-pair or dominator extension of the scan); `Kbd_TypeWaitsWithService` (4 sites in `keyboard.asm`: a table lookup that preserves HL, so the tool takes it as the consumer instead of the HDMA start that follows).  The bank-wide
wipes of banks 2-7 (`home/init.asm:51`, `boot_stage2.asm:43,112`) stay numeric on purpose.

## 6. Reproduce

`python3 tools/apply_ram_operands.py --areas wramx --dry-run` lists what the rules would rewrite and, by consumer, what has no rule; without `--dry-run` it rewrites, builds, checks the SHA-256 and `sym_check`, and restores every file on failure; `--check` lists the operands a rule proves that are still numeric.
`python3 tools/test_ram_operands.py` runs the tool tests (36).
