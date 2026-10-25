# Classification pass G2 (banks 1E, 23, 24, 3F, 42, 4B, 4C, 55, 5F, 68, 71)

## 1. Result

| bank | spans | bytes | resolved | left | moved to (bytes) |
|---|---|---|---|---|---|
| 1E | 5 | 426 | 426 | 0 | data/PROBABLE 396, data/HYPOTHESIS 19, zero 7, words 4 |
| 23 | 20 | 864 | 863 | 1 | code/HYPOTHESIS 283, data/PROBABLE 252, data/HYPOTHESIS 176, text 100, words 44, zero 9 |
| 24 | 19 | 2 976 | 2 975 | 1 | data/PROBABLE 1 616, gfx/PROBABLE 1 100, text 103, words 78, code/HYPOTHESIS 34, data/HYPOTHESIS 30, ptrtable 8, zero 7 |
| 3F | 1 | 2 | 2 | 0 | zero 2 |
| 42 | 18 | 7 647 | 7 647 | 0 | gfx/PROBABLE 3 562, data/PROBABLE 2 186 (4 tilemaps + 4 palettes), gfx/HYPOTHESIS 1 899 |
| 4B | 4 | 2 604 | 2 604 | 0 | gfx/PROBABLE 2 560, data/PROBABLE 44 |
| 4C | 6 | 118 | 118 | 0 | text 69, data/PROBABLE 49 |
| 55 | 201 | 3 622 | 3 622 | 0 | data/PROBABLE 2 801, text 634, code/HYPOTHESIS 116, code/PROBABLE 35, ptrtable 18, data/HYPOTHESIS 12, words 6 |
| 5F | 3 | 86 | 86 | 0 | data/HYPOTHESIS 48, data/PROBABLE 28, zero 8, words 2 |
| 68 | 45 | 971 | 971 | 0 | code/HYPOTHESIS 633, data/PROBABLE 213, text 86, words 36, code/PROBABLE 3 |
| 71 | 4 | 396 | 396 | 0 | data/PROBABLE 392, words 4 |
| **all** | 326 | **19 712** | **19 710** | **2** | data/PROBABLE 7 977, gfx/PROBABLE 7 222, gfx/HYPOTHESIS 1 899, code/HYPOTHESIS 1 066, text 992, data/HYPOTHESIS 285, words 174, code/PROBABLE 38, zero 33, ptrtable 26 |

## 4. Code-region audit (task d)

Corrections made (all region-file edits verified with `gen_asm.py verify` = IDENTICAL and `conventions_check --strict` = 0):

Every other new    code span without a caller/table word is lowered from PROBABLE to HYPOTHESIS (23:47BC, 5028, 540D, 58C5, 5FA3, 6D61, 6E58, 6F22; 24:42AF; 55:5DF5, 5F29, 6F46; 68:4152, 4283, 4377, 4430, 52B2, 5404, 5739, 58E8,    5D2F, 5E9A); the 55:6F95 12-byte block that only that routine reads is lowered too.

Kept PROBABLE: 55:691C, 6A2F, 68:48D1 (table words) and 55:6EEC (fixed-stride sibling).

**Applied what the first pass claimed but did not do:** the 71:6F38-6F6F sprite data (`Table_71_6F38`, `Table_71_6F40`, `Data_71_6F44`, `Data_71_6F69`, `Data_71_6F6A`) instead of the mapper's `gfx` guess. 4.

**Regression fixed:** the executed-read header 55:4000-4013 had dropped from CONFIRMED to HYPOTHESIS; restored to PROBABLE (merged run). 5.

Not changed, but recorded: palette blocks 24:7AE0-7B20 are also proven data by an executed read (dataaccess `rom_read 24 7AE0 7B20`); the mapper region 24:5EF1-6301 (`parity 1`) straddles the loader-proven    block boundary 62E0 (both sides gfx, harmless).

## Two conditional unlabelled mechanisms and OBJ palette ports

The maintained source comments for55:6F46 and its12-byte table6F95 incorrectly called the palette data port BCPD.

It writes indexB2/two data bytes toOCPS/OCPD, executesEI/CALL0392, then selectsWRAM7 viaFF8D/FF70 and copies the selected word toD872/D873 (`wPaletteBufObj+$32`).

The other bounded interval2C:[6100,614D) is77 bytes/51 CPU starts, separated byRET60FF from the earlier sibling and endingRET614C before the named614D helper. It savesBC, selectsSRAM1/enable0A and makes six loop iterations: i0..5 reads one of56F2's six record wordsA69D/A6ED/A73D/A78D/A7DD/A82D and calls614D with HL=that record,D=0C*i,E30,B3,C0. The call parameters are literal evidence, not a visual result or a new caller. The16-cell614D body and its glyph/canvas callees retain their own memory/progress/bank requirements.

The existing naming2_verify_fn4 section22 documents the sibling:2C:[60B3,6100),also77B/51starts, differs by exactly one byte at offset28hex:28->30 in LD DE0028/0030.

A 2026-10-23 follow-up later names the two bounded operations `Kbd_Candidate_DecrementC2B1OrAdvanceC2B0AndWriteOcpd` and `AddrPick_DrawSixSlotNamesAtX30`; their entry and caller remain HYPOTHESIS.

The apparent four-word/four-delay use remains HYPOTHESIS because the routine at `55:6F46` still has no proven entry; no semantic role or confidence was promoted.
