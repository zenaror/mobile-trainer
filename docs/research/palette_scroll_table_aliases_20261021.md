# Palette fade and scroll pointer aliases — 2026-10-21

Six exact generic aliases were retired under existing labels in `engine/gfx/palette.asm` and `engine/gfx/scroll_split.asm`:

| retired label | retained label | address | evidence in maintained source |
|---|---|---:|---|
| `Table_4F_4194` | `PalFade_Start_ModeTable` | `4F:4194` | inline table selected by `JumpTableInline` at `4F:4191`; eight handler pointers |
| `Table_4F_4233` | `PalFade_Step_ModeTable` | `4F:4233` | inline table selected by `JumpTableInline` at `4F:4230`; eight handler pointers |
| `Table_7F_7375` | `ScrollSplit_StepUp3Ptrs` | `7F:7375` | row-pointer table read by the step-up-3 routine at `7F:733A` |
| `Table_7F_7467` | `ScrollSplit_StepUp4Ptrs` | `7F:7467` | 12 row pointers read by the step-up-4 routine at `7F:7425` |
| `Table_7F_75B3` | `ScrollSplit_StepDown3Ptrs` | `7F:75B3` | row-pointer table read by the step-down-3 routine at `7F:7578` |
| `Table_7F_7706` | `ScrollSplit_StepDown4Ptrs` | `7F:7706` | 12 row pointers read by the step-down-4 routine at `7F:76C4` |

The paired row-span comments now cite the retained pointer-table names. Existing boundaries, probable grades and bytes are unchanged. This retires duplicate labels only; it does not claim every associated mode or row has been exercised naturally.

Verification: `make` reports SHA-256 OK and `RESULT: IDENTICAL`; `make sym-check` verifies all maintained source labels against `.sym`; `make palette-check` passes. Before compiling, `make -n` was inspected and does not invoke RGBASM on the protected mail sample.
