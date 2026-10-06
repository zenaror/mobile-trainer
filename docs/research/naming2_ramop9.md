# Tile staging windows, account work area, dialog tile stage and palette fade buffers (ramop9): 20 names, 941 pointer operands

> Status: **reference (current)** for the operands it rewrites.  Follows [`naming2_ramop8.md`](naming2_ramop8.md) (the bank proof, the rule file and the effect table are described in [`naming2_ramop7.md`](naming2_ramop7.md)).
> Records: [`analysis/naming2/wramx_consumers.tsv`](../../analysis/naming2/wramx_consumers.tsv), [`analysis/naming2/wramx_calls.tsv`](../../analysis/naming2/wramx_calls.tsv), [`analysis/naming2/ramop9_manual.tsv`](../../analysis/naming2/ramop9_manual.tsv);
> tools: `tools/apply_ram_operands.py --areas wramx`, `tools/apply_manual_sites.py`; independent verification: [`naming2_verify_ramop9.md`](naming2_verify_ramop9.md).

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

The pass was done in two parts that were verified by two independent readers in parallel.  Part A (17 names, 675 operands) came from an executor that read the staging windows of banks 2 and 3;
part B (3 names, the new proof mechanisms, 266 operands, 60 neutral uses, 44 more by hand and 12 words) is the work of the coordinator.

## 2. What the new objects are

### 2.1 The tile staging windows of banks 2 and 3 (`$D000-$DFFF`)

Banks 2 and 3 hold the tiles of the text that the screens draw.  Text is rendered into WRAM and then sent to VRAM tile memory by HDMA (general-purpose DMA, which the project calls HDMA):

* `TextTiles_RenderLine`, `TextTiles_RenderGrid` and `TextTiles_RenderGridRows` (48:403E, 48:40A9, 48:415A) take the destination bank from `hTextTiles_DestBank`, which the callers store just before the call (bank 2, 3 or 7: 123, 10 and 14 of the 147 destination operands), and write 8x16 glyph tiles through `Font_BlitGlyph8x16` (48:4748), whose store loops run only
  under banks 2, 3 and 7.  The destinations are `bc` and `de` of the call (for example `ld bc, wTileStage2 + $780 / ld de, wTileStage2 + $8C0`: lines are `$280` bytes apart, 20 tiles of 16 bytes for each of the two rows of a text line).
* The pixel canvas of the browser and the mail screens (`Canvas_BlitGlyphNoRemap` 7F:42CA, `TileCanvas_FillRect` 4F:4604) has rows of 20 tiles = `$140` bytes: rows 0-11 are `$D000-$DEFF` of bank 2 and the next rows continue in bank 3 (the blitter changes bank when H >= `$DF`).
* The uploaders send `$D000`, `$D400`, `$D800` and `$DC00` of bank 2 to VRAM bank 0 `$9000`, `$9400`, `$8800`, `$8C00` (`Mailbox_UploadTextTiles` 25:534C, `MailDraft_UploadTextTiles` 2B:46E5, `MailView_BodyPage_UploadTextTiles` 2B:7D92, `PageList_UploadTextTiles` 24:4A00, ...) with `Gfx_StartHDMAWithService` or one of 17 local starters (15 of them ever ran, all with bank 2 selected).
* `TextTiles_ClearBuffers` (2D:4E06) clears `$1000` bytes of bank 2 and `$0780` of bank 3.

**`wTileStage2`** (W2 `$D000`, 4,096 bytes) is the whole bank 2 window and **`wTileStage3`** (W3 `$D000`, 2,304 bytes) the part of bank 3 that the executed code uses: six canvas rows to `$D77F`, the 1bpp raster of inline images (`Bmp_ConvertToTiles` 51:7177) and the zeroes that the help screens send to VRAM (`HelpScript_ShowPicture` zero-fills `$0900` bytes so that the live
`wSpriteSlotBackup` at `$D900` survives).  Each screen lays its own rows out inside the window (20 tiles per row, `$280` per text line, 16 tiles per row, 32-tile strips, decimal fields at `$D800`), so an offset means something only per screen: the names are those of the windows, with the offsets in the code.
Only the unreferenced `debug_flags.asm` (never executed) reaches `$DBFF` of bank 3, and the debug screens build Shift-JIS strings at `$D000` of bank 2 before they render them: those pointers are string scratch, not tile staging, and stay numeric with `; raw`.
**`wKbdGlyphPreviewTiles`** (W3 `$DE00`, 32 bytes) is the one 8x16 glyph (two 8x8 tiles) that the on-screen keyboard previews: `Kbd_DrawGlyphPreview` (55:6C16) renders it and sends the 32 bytes by HDMA to VRAM bank 1 `$8240`.

### 2.2 The account work area of bank 3 (`$DE80-$DFFF`)

The registration and settings screens keep their text in bank 3 behind the `TextBuf` library (`TextBuf_Init` 67:6731 ... `TextBuf_GetLength` 67:6842: each routine selects bank 3 and restores the bank): a `TextBuf` is a 3-byte header (capacity, free slots, cursor) followed by the characters.

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

The sizes are contiguous from `$DEAB` to `$DF0F` and equal the `TextBuf_Init` capacities and the SRAM field sizes.  The two tables of addresses `Dial_EntryNumberBuffers` (68:4594) and `SettingsPhone_SlotMenu_FieldTable` (67:50A5) hold `wDialEntries + $00/$33/$66/$11/...` (12 words, now written so);
their old header said "WRAM1 addresses", which is wrong: both are dereferenced under bank 3.

### 2.3 The dialog tile stage of bank 7 (`$DC00-$DFFF`)

**`wDialogTileStage`** (W7 `$DC00`, 1,024 bytes): `Dialog_Open` (72:402A) clears it, renders two 8x16 text lines at `$DC00/$DD00` and `$DE00/$DF00` with `hTextTiles_DestBank` = 7 and sends it by HDMA to VRAM bank 1 `$8C00`; `BrowserMenu_Open*` does the same with one line (40 blocks).  Nothing else in the tree touches bank 7 `$DC00-$DFFF`.

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
* **Bank `*`** in a rule: the bank that the proof shows (any of W1-W7); refused with `needs = -`.
* **`--observed` for `switch` rows and for `a` rows with A = 0**: when the backward scan cannot show the bank, the replays can: every replayed execution of the instruction ran under one bank only, and the idiom (if any) agrees (part A: 26 operands rest on this alone and 192 have both; part B: 35 of the 138 direct uses).
* **The pseudo consumer `(direct)`** (needs `switch` only): a pointer that the first instruction using the register dereferences (`ld a, [hl]`, `ld [de], a`, `ld a, [hli]`): nothing between the load and that instruction may touch a bank register, so the bank is the one in force at the load (138 operands).
* **`CAVEAT` in a `DEF` line**: the tool never writes a name whose definition says that the address has other meanings elsewhere (`wMailComposeMode`: `$D524` is also the digit scratch of other screens; `wEditBodyBuf`: bank 2E reuses `$D400-$D4FF` as the POP3 header summary; `wMail_ItemListPointer`: the parse routines use `$D00D/$D00E` as bytes).
* **Every spelling of the bank register** ends a proof, including a store through `[c]`, the short numeric spellings `[$70]`, lower-case hex, and an instruction that names `rSVBK`, `hWRAMBank`, `$FF70` or `$FF8D` as an operand (a following `ld [de], a` could write it).  The source has only `ldh [rSVBK], a` (2,437 times) and `ldh [hWRAMBank], a` (1,522), and in the 41 bank-observed replays a write watch saw
  1,734 writers of `rSVBK`, all `ldh [$FF70], a`.
* **By-hand rows** (`analysis/naming2/ramop9_manual.tsv`, `tools/apply_manual_sites.py`): computed destinations, clear loops, far idioms, base registers, the base pointers of the fade buffers, the neutral name uses that a dominating bank idiom proves, address tables.  Each row has the proof and a context check (the previous, the own and the next line); the tool also evaluates the proposed name against the `DEF` lines (the name must exist, `name + offset` must be the operand and the bank must be the row's).
  A site that was looked at and stays numeric is a row too, with its reason, and the line carries `; raw: <reason>`.

## 4. What the independent readers changed

**Part A** (reader of the 17 names and the 675 operands): names 16 upheld and 1 corrected (`wDialogTileStage`: `BrowserMenu_Open*` sends 40 blocks, not 41), rules 65 of 67 upheld (the `FillBytes hl` family let `wAcctNumberInternet` through for a wipe of three fields; the proof of `TextTiles_HdmaBlock` said it writes no bank register, but it saves `rSVBK`, selects bank 1 to read `wStatSplitLine`
and writes both registers back), effects 42 of 43 upheld (the same row), operands 674 of 675 upheld (`phone_number_entry.asm:292`, the wipe, went back to `$DEDD ; raw`).  Re-derived by the reader: the consumer of all 597 tool rows at ROM level, 0 contradictions between the scan and the replays, 78 manual rows, a property test of 21,000 random programs (0 false accepts),
12 mutants of the new logic (2 survived: tests added), 29 corrections in all (wording of four `DEF` lines, the headers of the rule files, `read_rules` crashed on a `(direct)` row that needs a bank: now refused, `LCDOn` is at 00:05B6 and not 00:05C4, the stale "29" of the count of `dest` operands that need the scan from the call: 32).
**Part B** (reader of the fade names, the `(direct)` mechanism and the 335 changed lines): names 3 upheld, 329 of 335 lines upheld, 6 went back to numeric: three `wEditBodyBuf`/`wEditAddressBuf` pointers in `tidy_screen.asm` (the data is the POP3 TOP summary that bank 54 stages: date, source label, subject, sender) and three `wTileStage2` pointers in the debug screens (string scratch); the row `MailServerMgr_DrawFieldText` and
the `Body` alternative of the drawer family were dropped; the tool got the spellings of the bank register that a scan could miss (false accepts R1-R3 in synthetic programs, none in the tree) and the reader's tests; the reader proved 44 neutral uses by hand (`menus.asm`, `tidy_screen.asm`: a bank idiom that dominates the local labels); the `CAVEAT` convention was applied to `wEditBodyBuf` and `wMail_ItemListPointer`.
After both rounds the coordinator also marked 17 lines `; raw` (the 14 sites that stay numeric, the two uses of the number-to-dial scratch `wAcctNumberSelfPage` in `password_change.asm`, and the phone wipe) so that no later rule renames them, and wrote the 3 pointer loads of the library's item list and the 12 table words by hand with their proofs.

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

## 7. Reproduce

`python3 tools/apply_ram_operands.py --areas wramx --observed --dry-run [--report FILE]` lists what the rules prove and, by consumer, what has no rule (the report has the consumer and the proven bank of every operand); `--neutral --observed` does the same for the neutral names; `--check` audits what is still numeric although a rule proves it.
`python3 tools/apply_manual_sites.py [--dry-run]` writes (or checks, idempotently) the rows of `analysis/naming2/ramop9_manual.tsv`.  Tests: `python3 tools/test_ram_operands.py` (58) and `python3 tools/test_manual_sites.py` (5).
