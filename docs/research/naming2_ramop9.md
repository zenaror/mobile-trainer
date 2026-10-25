# Tile staging windows, account work area, dialog tile stage and palette fade buffers (ramop9): 20 names, 941 pointer operands

## 1. Result

| item | count |
|---|---|
| banked WRAM pointer operands (`ld hl\|de\|bc, $Dxxx`) written as names | **941** in 76 files: 841 by the tool (594 + 247 in two parts), 100 by hand with a recorded proof (78 + 22) |
| by name | `wTileStage2` 315, `wTileStage3` 92, `wMailSessionBlock` 72, `wEditAddressBuf` 70, `wTextEntryBuf` 69, `wEditNameBuf` 31, `wDialogTileStage` 24, the account password fields 61, the other account fields 99, `wScreenAttrMap` 22, `wMail_OutputBankVar` 17, `wPaletteFade*` 35, `wEditSubjectBuf` 11, ... (36 names in all) |
| uses of the neutral banked names `wRam_Dxxx` written as names | 104 in 9 files (`wScreenTileMap + $1A6`, `wScreenAttrMap + $1A6`, `wPaletteBufBg + $01`): 60 by the tool with the replays as proof, 44 by hand |
| words of address tables | 12 `dw` words (`dw wDialEntries + $33`): `Dial_EntryNumberBuffers`, `SettingsPhone_SlotMenu_FieldTable` |
| new names in `ram/banked.asm` | 20 (180 in all, `apply_banked_names --check`: 0 errors, 98 overlapping pairs): `wTileStage2`, `wTileStage3`, `wKbdGlyphPreviewTiles`, `wTextEntryBuf`, `wTextEntryBuf2`, `wAcctMailLocalPart`, `wAcctMailSubdomain`, `wAcctPassword`, `wAcctPasswordNew`, `wAcctPasswordConfirm`, `wAcctPasswordEntry`, `wAcctNumberInternet`, `wAcctNumberSelfPage`, `wAcctNumberComment`, `wDialEntries`, `wAcctHostScratch`, `wDialogTileStage`, `wPaletteFadeFrom`, `wPaletteFadeTo`, `wPaletteFadeLevels` |
| rules | `wramx_consumers.tsv` 106 rows (85 new, 7 widened), `wramx_calls.tsv` 81 rows (43 new), the record of by-hand rows `ramop9_manual.tsv` 170 rows (156 written, 14 that stay numeric with the reason) |
| left numeric | **549** of the 1,490 banked WRAM pointer operands that were numeric before: 336 without a consumer rule (221 with no call in the straight line), 103 whose bank is shown but has no name, 65 whose bank is not shown, 20 marked `; raw` with the reason, 14 values (the number -10000), 10 of another family, 1 refused by a `CAVEAT`; and 176 + 63 uses of `wRam_Dxxx` |
| ROM | byte-identical (`make compare`: `RESULT: IDENTICAL`; `sym-check`, all audits and the 58 + 5 tool tests pass; every changed line is an operand replaced by an expression of the same value, or a comment) |

### 2.2 The account work area of bank 3 (`$DE80-$DFFF`)

| name | address | size | role | status |
|---|---|---|---|---|
| `wTextEntryBuf` | `$DE80` | 20 | the entry buffer of the screens (capacity 9, 10 or 17 characters + header); text at `$DE83` | CONFIRMED |
| `wTextEntryBuf2` | `$DE94` | 8 | the second buffer of the mail address screen (sub-domain) | CONFIRMED |
| `wAcctLoginId` (older name) | `$DEA0` | 11 | login id | |
| `wAcctMailLocalPart` | `$DEAB` | 9 | local part of the mail address, 8 characters + NUL | CONFIRMED |
| `wAcctMailSubdomain` | `$DEB4` | 5 | sub-domain, 4 characters + NUL | CONFIRMED |
| `wAcctPassword` | `$DEB9` | 9 | account password, 8 characters + NUL (stored to `sSettingsPassword`) | CONFIRMED |
| `wAcctPasswordNew`, `wAcctPasswordConfirm`, `wAcctPasswordEntry` | `$DEC2`, `$DECB`, `$DED4` | 9 each | the new password of the change flow, the second typed password, the transfer buffer of the entry screen | PROBABLE |
| `wAcctNumberInternet`, `wAcctNumberSelfPage` | `$DEDD`, `$DEEE` | 17 each | the two manual phone numbers (16 digits + NUL); `$DEEE` is also the scratch for the number to dial in the password change | PROBABLE |
| `wAcctNumberComment` | `$DEFF` | 17 | the comment text of a phone entry | CONFIRMED |
| `wDialEntries` | `$DF10` | 153 | three dial entries of `$33` bytes: number, the SRAM string, the entry text (`Config_LoadMirrorToWram` 68:4608) | CONFIRMED |
| `wAcctMailAddress` (older name) | `$DFAA` | | the full mail address | |
| `wAcctHostScratch` | `$DFC3` | 21 | `"pop."` or `"mail."` + sub-domain + `".dion.ne.jp"` (`Config_BuildImageFromAccount`) | PROBABLE |

### 2.4 The palette fade buffers of bank 7 (`$D880-$D9FF`)

The fade routines (`PalFade_*`, `engine/gfx/palette.asm`) blend the live palette buffer `wPaletteBufBg` (64 colours of 2 bytes: BG palettes 0-7, then OBJ palettes 0-7) between two colours for every entry:

* **`wPaletteFadeFrom`** (`$D880`, 128 bytes): the colours at progress `$0000`.  Every driver copies `wPaletteBufBg` here before it starts (11 drivers: `Palette_FadeInFromWhite` 4F:42B4 and `Palette_FadeOutToWhite` 4F:4370 in 63 of the 64 scenarios, the Slow pair, `Palette_FadeOutWithTicker`, the masked pair, and four variants that never ran); after a fade-out it still holds the palette of before the fade, which the page screens copy back.
* **`wPaletteFadeTo`** (`$D900`, 128 bytes): the colours at progress `$0100`: `PalFade_Start` fills it with the colour in BC (`$7FFF` white in every executed driver); the masked fades copy the buffer first and `Palette_SetFadeTargetMasked` (48:459D) overwrites only the selected groups of 4 colours.
* **`wPaletteFadeLevels`** (`$D980`, 128 bytes): one progress word per colour (`$0000` to `$0100`, low byte = fraction in 1/256).  `PalFade_Step` moves `wPalFadeProgress` by the signed `wPalFadeStep`, `PalFade_Step_UpdateRange` (4F:4269, 213,287 executions in 63 scenarios) stores it in every word of the mode and calls `PalFade_BlendColor` (4F:4083) once for each colour: word 0 gives From, a non-zero high byte gives To, otherwise `From + (To - From) * progress / 256`
  (the reader ran the ROM's own routine on 4,000 random cases against this formula: 0 differences).  A negative step starts at `$0100`: the fades in from white start at To and walk back to From.

## 3. How the tool proves the bank (what is new in this pass)

The mechanism is that of `naming2_ramop7.md` and `naming2_ramop8.md`; the pass adds (details in the docstring of `tools/apply_ram_operands.py`, the headers of the two rule files and `STYLE.md`):

* **`needs = dest`** (`TextTiles_RenderLine bc|de`, `RenderGrid de`, `RenderGridRows de`): the bank is the constant stored in `hTextTiles_DestBank` by the nearest `ldh [hTextTiles_DestBank], a` with `ld a, $0N` before it, scanning back from the consumer call: the store may lie between the load of the pointer and the call (32 of the 147 operands).

The dereference is `Font_BlitGlyph8x16` (`call BankSwitch_H` at 48:47CD and 48:47E9 with the bank word that `RenderLine` pushes from the variable).

* **`CAVEAT` in a `DEF` line**: the tool never writes a name whose definition says that the address has other meanings elsewhere (`wMailComposeMode`: `$D524` is also the digit scratch of other screens; `wEditBodyBuf`: bank 2E reuses `$D400-$D4FF` as the POP3 header summary; `wMail_ItemListPointer`: the parse routines use `$D00D/$D00E` as bytes).

* **Every spelling of the bank register** ends a proof, including a store through `[c]`, the short numeric spellings `[$70]`, lower-case hex, and an instruction that names `rSVBK`, `hWRAMBank`, `$FF70` or `$FF8D` as an operand (a following `ld [de], a` could write it).

The source has only `ldh [rSVBK], a` (2,437 times) and `ldh [hWRAMBank], a` (1,522), and in the 41 bank-observed replays a write watch saw   1,734 writers of `rSVBK`, all `ldh [$FF70], a`.

## 4. What the independent readers changed

**Part A** (reader of the 17 names and the 675 operands): names 16 upheld and 1 corrected (`wDialogTileStage`: `BrowserMenu_Open*` sends 40 blocks, not 41), rules 65 of 67 upheld (the `FillBytes hl` family let `wAcctNumberInternet` through for a wipe of three fields; the proof of `TextTiles_HdmaBlock` said it writes no bank register, but it saves `rSVBK`, selects bank 1 to read `wStatSplitLine` and writes both registers back), effects 42 of 43 upheld (the same row), operands 674 of 675 upheld (`phone_number_entry.asm:292`, the wipe, went back to `$DEDD ; raw`).

Re-derived by the reader: the consumer of all 597 tool rows at ROM level, 0 contradictions between the scan and the replays, 78 manual rows, a property test of 21,000 random programs (0 false accepts), 12 mutants of the new logic (2 survived: tests added), 29 corrections in all (wording of four `DEF` lines, the headers of the rule files, `read_rules` crashed on a `(direct)` row that needs a bank: now refused, `LCDOn` is at 00:05B6 and not 00:05C4, the stale "29" of the count of `dest` operands that need the scan from the call: 32).

**Part B** (reader of the fade names, the `(direct)` mechanism and the 335 changed lines): names 3 upheld, 329 of 335 lines upheld, 6 went back to numeric: three `wEditBodyBuf`/`wEditAddressBuf` pointers in `tidy_screen.asm` (the data is the POP3 TOP summary that bank 54 stages: date, source label, subject, sender) and three `wTileStage2` pointers in the debug screens (string scratch); the row `MailServerMgr_DrawFieldText` and the `Body` alternative of the drawer family were dropped; the tool got the spellings of the bank register that a scan could miss (false accepts R1-R3 in synthetic programs, none in the tree) and the reader's tests; the reader proved 44 neutral uses by hand (`menus.asm`, `tidy_screen.asm`: a bank idiom that dominates the local labels); the `CAVEAT` convention was applied to `wEditBodyBuf` and `wMail_ItemListPointer`.

## 5. Findings and open points

* **The four-colour fade mode contradicts itself** (HYPOTHESIS: a typo in one immediate; the mode has no caller).  `PalFade_Start_FourColors` (4F:41A4) fills the end colours and the progress words at offset `$70` (colours 56-59), `PalFade_Step_FourColors` (4F:4243) writes the progress words at `$70` too but blends offset `$60` (colours 48-51, `DE = $0060`).  The two drivers that select the mode
  (4F:44DF, 4F:452A) have no caller, so it never matters; the alternative, that `$70` is the wrong one and the intended palette is OBJ 4, cannot be decided.  A comment sits above the routine.
* **An address with two meanings stays numeric where the site is the other meaning**: `$D524` (compose mode / digit scratch), `$D400-$D4FF` of bank 1 (mail body / POP3 header summary), `$D00D/$D00E` of bank 5 (item list pointer in the item-list routines, two bytes in the parse routines: the old sites that use `wMail_ItemListPointer + 1` as a byte stay as they are, now documented), `$DEEE` (self page number / number to dial),
  `$D000` of bank 2 (tile staging / debug string scratch), `$D624` of bank 1 (the session block of the mail flow; the address book stores 1 and 0 there as a mode flag in `list.asm` and tests it in `address_editor.asm`: documented in the `DEF`, the three older sites keep the name).
* **`keeps` is a statement about the shadow**: 5 executed call sites of the new effect rows return in a bank not seen before the call (`TextBuf_DeleteLast` at three account entry screens, `TextTiles_RenderLine` at `delete_hidden.asm:469` and `result_screens.asm:329`): the stale-shadow window of `naming2_verify_ramop7.md` section 4c.  No rewritten operand follows such a call with a bank-dependent consumer.
  `TextTiles_HdmaBlock` leaves `hWRAMBank` as the value it read back from `rSVBK` (for example `$FA`).
* **Replays prove the bank of the load, not of the dereference, for a routine that selects the bank itself**: the ten string pointers of the `*_DrawLine*` wrappers (`draft_menu.asm:373-388`, `address_editor.asm:533-538,1623`, ...) are loaded under bank 2 and dereferenced under bank 1 by the wrapper; the rows of the drawers (`needs = -`, bank W1) are what keeps them from being named `wTileStage2`.
* **Stale statements corrected**: `wPalFadeMode` "always 0 in executed code" (`Palette_FadeOutMasked` sets 1), the header of `Dial_EntryNumberBuffers` (WRAM1), the extent of `wTileStage3` (debug), the count of blocks of the browser menu.

## 6. Left numeric

| family | sites | what is needed |
|---|---|---|
| no consumer found in the straight line (a register used directly, a loop or a branch comes first) | 221 | per-site reading; most are bank 1 (mail, address book) |
| a consumer without a rule (`Mail_NextSramPage` 22, `TextTiles_RenderLine` 19 with an unproven destination bank, `Mail_CopyToSram` 7, `ConnectDialog_*` 12, `Html_StringTable_Add` 6, ...) | 115 | rules, or a proof of the bank by hand |
| the bank is shown but no name covers the address (`$D62F`, `$D631`, `$D633`, `$D635`, `$D637`, `$D726`, `$D727` of bank 1: the mail session block is used up to offset `$13` while it is declared 10 bytes; `$D003`..`$D020` of bank 5: the SDK mail library; `$D340`..`$DA00` of bank 6: the browser and HTML buffers) | 103 | names (a later note) |
| the bank is not shown (the first use is a dereference, but neither the idiom nor the replays prove the bank: dead code, or the idiom is more than 60 lines away) | 65 | per-site reading |
| `; raw` with the reason (dev code, debug string scratch, boot wipes, a dead load, the number -10000, scratch uses) | 20 | none: these are decisions |
| a value, another family, a `CAVEAT` | 25 | none |

Of the neutral names, 176 uses of `wRam_Dxxx` have no proof of the bank (115 in `lib/mobile/mail.asm`, 61 in `audio/engine.asm`) and 63 have no name in the proven bank.  Not rewritten: the ten wrapper pointers above, the `Kbd_TypeWaitsWithService` pattern (4 sites in `keyboard.asm`) and two in `dialog.asm`.

`python3 tools/apply_ram_operands.py --areas wramx --observed --dry-run [--report FILE]` lists what the rules prove and, by consumer, what has no rule (the report has the consumer and the proven bank of every operand); `--neutral --observed` does the same for the neutral names; `--check` audits what is still numeric although a rule proves it.
