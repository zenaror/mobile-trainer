# Structural local-label pass: arithmetic and HDMA loops (2026-10-22)

This Japanese-source pass replaces seven numeric local branch labels with
operation names in `home/multiply_divide.asm` and `home/gfx_upload.asm`, and
names the previously unlabelled conditional block at `55:5DF5` in
`engine/keyboard/keyboard.asm`. The changes are symbols/comments only; no
instruction or data bytes were changed.

| Address | Previous label | Current local label | Evidence |
|---|---|---|---|
| `00:0D62` | `.l0D62` | `.NextBit` in `Multiply16x16to32` | Both optional-add paths converge here; the carry path increments BC before the shared 16-iteration loop tail. |
| `00:0D86` | `.l0D86` | `.SetQuotientBit` in `Divide16` | The non-borrow path increments DE after its low bit was shifted clear; this sets the quotient bit. |
| `00:0D87` | `.l0D87` | `.NextBit` in `Divide16` | The restored/subtracted paths converge, restore the loop counter and select the next quotient bit. |
| `00:0773` | `.l0773` | `.StartTransfer` in `Gfx_StartHDMA` | Writes the block count to `rHDMA5`, restores C and the saved ROM bank, then returns. |
| `00:077A` | `.l077A` | `.WaitForLyBelow91` in `Gfx_StartHDMA` | Loops while `LY >= $91`, restores the bank and retries the frame-window check. `$91` is hexadecimal. |
| `00:07B1` | `.l07B1` | `.StartTransfer` in `Gfx_StartHDMAWithService` | Starts the transfer, services audio, restores C and the saved bank, then returns. |
| `00:07BB` | `.l07BB` | `.WaitForLyBelow91` in `Gfx_StartHDMAWithService` | Same strict `LY < $91` exit, with audio service before bank restoration and retry. |
| `55:5DF5` | unlabelled block | `.CheckTypeThenContinueOrHide` | The block calls the type-6-to-10 flag lookup, then continues the keyboard loop for zero or branches to the hide/return-9 path for nonzero. Its natural entry remains unproved. |

The operation names describe local instruction flow only. They do not imply
product-level purpose or prove a caller. Independent static reviewers accepted
the multiply/divide and HDMA names. A separate entry-root review found no new
natural root at `2B:6CF5`, `2D:4E42/4E54`, `29:511E` or `55:5DF5`; keep those
entry conclusions UNKNOWN as documented in
[`original_closure_followup_20261021.md`](original_closure_followup_20261021.md#natural-entry-trace-interval-census-2026-10-22).

The broad source scan covers 349 maintained Japanese ASM/INC files, excluding
the paused `languages/` tree and protected `engine/mail/sample_data.asm`. At
the `cbedacbd` base it found 4,942 local `.lAAAA` address labels in 163 files;
after this pass, 4,935 remain. These are internal labels, not a count of
unidentified functions, but they are a substantial naming backlog and must be
reviewed from their own control-flow evidence. The same scan found no exact
`Function_BB_AAAA` or `Font_BB_AAAA` definitions and no `gfx/bankNN` directory.
The 14 remaining `Data_BB_AAAA` labels are separately reviewed and remain
neutral where the evidence does not identify code entry or data content; see
[`japanese_sprite_data_followup_20261022.md`](japanese_sprite_data_followup_20261022.md).

Validation on the Japanese tree: `make` returned `RESULT: IDENTICAL` with ROM
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passed with 12,185 labels and 51 constants; `make
palette-check` passed with 162 loads, 116 arrays, two documented over-reads
and zero errors. `make png-check` passed with 408 tile sheets, four raw views,
37 font sheets and 95 screen PNGs. These checks establish build identity,
symbol address consistency and the respective asset-reader inventories, not
natural execution or hardware behavior.
