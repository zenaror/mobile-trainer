# reference 5 (labels): independent reference of the five packages (425 rows)

## 2. Label package A (core, account, settings; 42 labels): executor report

Dispatcher `00:056A`, bytes `F0 A7 6F AF E0 A7 F0 A5 B5 CB 47 C2 9B 05 ...`: A = FFA5 | FFA7 (FFA7 is cleared), tests bit 0, 1, 2, 3 in that order, passes word index 0, 1, 2, 3, else 4 to `JumpTableInline`.

Button bits: FFA5/FFA4 are computed at `7D:7BC1` as newly-pressed = (FFA4 xor new) and new, held = new; `7D:7B7C` reads rP1 twice (writing `$20` selects the directions: `and $0F ; swap`, bits 4-7 = Right, Left, Up, Down; writing `$10` selects the buttons: `and $0F ; or b ; xor $FF`, active-high bits 0-3 = A, B, Select, Start); this agrees with `dynamic_tracing` 9.3 item 1 (the B+Select+Right combo `and $16` confirmed by execution).

Table bytes spot-checked on five screens (Notice `65:494E` `5B 49 74 49 99 49 9B 49 58 49`; TopMenu `1F:41E9` `17 42 5A 42 8E 42 8B 42 F3 41`; `Dialog_WaitInput` `72:4596` `EA 45 06 46 00 46 03 46 A0 45`; HelpMenu `6C:41CB` `E5 41 5A 42 9C 42 9C 42 D5 41`; MobileDictView `4C:4FF5` `1E 50 9A 50 E0 50 DD 50 FF 4F`): in every case A = SFX `$2C/$2D` and accept or return, B = SFX `$2E` and cancel, Select and Start a lone `jp`/`jr` to the loop or a real handler (OnSelect), Idle is word 4.

FFA7: its writers store 0, except `51:41D3`, which stores the A returned by a farcall (this does not change the bit-to-word rule).

Suggestion: the comment in `home/jump_table.asm` still says "(PROBABLE)"; it can be raised to CONFIRMED with these facts.

`Dialog_WaitInputMonitored_Exit*`: the words 3/4/5 of the four 6-word tables (`4E:4A37`, `4CDF`, `4F1A`, `4FB7`) are `Browser_Menu_LinkLost` (never ran), `Browser_ConnectionNotice` (3 hits) and `Browser_Menu_AdapterError` (never ran); the four callers at `4E:4A26`, `4CC4`, `4EFF` and `4F9C` dispatch `hDialogResult` through them with `call JumpTableInline`; the fifth caller, `4E:5181`, is inside `Browser_Menu_LinkLost` and ignores the result; `ExitConnectionNotice` is CONFIRMED correctly (exit 4 ran once, in browser_pages, and `Browser_ConnectionNotice` also ran once there); `ExitLinkLost` and `ExitAdapterError` are honest PROBABLE.

Registration names are honest: the digit is the `Notice_ShowPage` argument, with text `NoticeText_AgreeToTerms`, `ReadTerms` and `UsageFeeWarning` for record 2, 3 and 7; the `_Hidden` blocks are instruction-for-instruction copies.

The two HYPOTHESIS rows (new name = old name, "idea:" evidence) are `Label_4C_4016` and `Label_4E_58AB`: lone-`ret` table slots that no shipped data can select; idea name for both: `Stub_Nop_<bank>_<addr>`; kept neutral under the dead-code rule (a selected slot at `4C:4016` would end `Browser_LoadPage` itself, because `JumpTableInline` has already popped its return address, so a plain no-op name would mislead).

Corrected rows * Row 1 `Label_2F_6D5E`: "8 or 0 after `Kbd_Hide`, 9 without" is wrong: `AbookAddr_KeyboardLoop` returns 7 (15 times, `2F:75F7`), 0 after `Kbd_Hide` (`2F:7634`, `xor a` at `763B`, ret `7645`: 8 times) and never 8 or 9 (`ret z` at `75F0`: 0 of 195); 23 hits = 15 + 8.

Template family: `_AfterKeyboard` (rows 1, 9, 21): same job in all three (A = loop return, `cp 7`, 7 closes the editor and returns 0, else the B test); the joypad refresh after `Kbd_Hide` sits in the keyboard loop in the name/title copies and after the return (`.l6DF1`) in the address copy.

`_GetCharPtr_*` / `_CharPtr_*`: the three copies and `MailBody_GetCharPtr` (`2D:4E8C`) are byte-identical apart from the cell stride and the row routine.

`_InsertChar_*`: CheckRow, NextRow and Reject are the same in both copies; `_Insert` differs in position: in the name copy the capacity test precedes `5CF4`; in the title copy `44DC` does sfx `$38` + the sprite wait first and tests capacity (FindLine) afterwards, so a rejected key would beep `$38` then `$31`; the title's real counterpart of the name's `_Insert` is `_ShiftAndStore` (`459C`); both names kept (the first instructions at both labels are the same); one sentence recommended in row 26.

Line drawers (part B): AbookAddr's are local (`.l7174`, `.l71CF`, `.l71F4`, `.l720F`) with the same four roles; the fillers differ: Newline loads glyph `$3C` versus `$20` in Profile; PadLine loads `Glyph_LoadDottedLine` versus a space glyph in Profile. 2.

Dead-code rule and statuses: the 9 PROBABLE rows (5, 13, 14, 15, 16, 25, 27, 28, 29) are honest: the labels never ran, are statically reachable from live code, and have an executed twin or an executed identical beep (Newline exit `2D:4EBA` 23/5; buffer-full beep 3/1 and 50/4); none can be raised.

`Label_2B_57CB` HYPOTHESIS is upheld: 0 natural hits in `2B:53C3-59C0`; `MailGrid_Screen` is referenced nowhere in the ROM (no call, jp, ld, dw, far pointer or farcall pattern; the only `C3 53` word is at `41:5B3F`, unrelated); the tile-`$46` fill idiom and `ld hl, $99E1` occur only there; forced-only hits 8 and 6 as stated.

`Label_27_4EEB` (other half): the "same ending as `MailConnect_InitScreen`" is loose, since the byte string occurs only at `27:4EEB`; consistent with leaving it neutral. 3.

`MailSendRecv_Main`: the claim holds: `27:406F` ran 123 times, `jr z` 0 taken; `4075` taken 64; `4079` taken 53; `.l407B` 6/2; every live ret of `MailConnect_Screen` returns 0 (`27:44E0`), `$20` (`469F`, `ld a, $FF ; ld a, $20 ; ret`) or `$80` (`4746`); unexecuted but reachable: `ld a, $80 ; ret` at `4392/43FE`; the only `ld a, $FF ; ret` is at `46DC` in a dead A/B wait loop (`46A1-46DE`, no reference; `46A0` is a stray ret); so `.l407B` is entered only with A = `$80`, and the `cp $FF` is vestigial; the function has 6 callers (178 calls); the 78 `xor a` returns count all of them; names built on the dispatch: numbers check (70 = 64 + 6; 53); `EndNoSession` and `RunSession` are fine; `ErrorDisconnect` is honestly PROBABLE. 4.

The three neutral labels, confirmed: `SaveSenderAddr_LoadCaption` runs `ld hl, String_SaveSenderAddr_Caption` (`2A:49C7`, 19/6); the bytes `81 40 83 5A 81 5B 83 75 00` are "　セーブ"; `4A6F..4A8A` are the following four strings; the "ptrtable" is its first 6 bytes; no instruction references `2A:4081` (mid B-handler, 10/3), `2A:5A83` or `2A:5B81` (mid wide-glyph paths of `Profile_DrawAddressLine1/2`); those wide paths are byte-identical to the executed `Profile_DrawNickname` path (`2A:5971-59B0`, 1442/11); retype `4A66-4A92` as text and delete the three labels, as `cde3e95` did for `Label_68_5B6C..5B8C`; `Label_2A_40A8` is global only because of 4081. 5.

`CountDeleted`: OK: `23:503F` ran 13/4; the poll loop ran 6227 = 6214 polls + 13 completions; the code counts `$D627++` and `$D629--` when `Pop3_DelePoll` (`54:53BB`) returns neither 1 nor `$FF`, i.e. 0; the name claims only counting.

Twin: `27:4FC0-4FFA` equals `51:4199-41D2` byte for byte except 5 table words, 4 jp operands and the last byte; the JoypadDispatch mapping is verified at `00:056A`: A = 0, B = 1, Select = 2, Start = 3, none = 4 = loop head.

Corrected rows
* 43 `Label_27_40BB` (evidence): "(the connection timer counted)" is false for every traced run: `CommTime_TimerAIsNonZero` (`51:4239`) ORs `$C2D4-$C2D7` into A and leaves HL alone (FarCall returns the callee's A and HL); in all 70 runs A was 0: `27:40C2` `jr nz` ran 70 times and was never taken; the summary call at `27:40D0` (70 hits) ran only because HL was non-zero (`27:40C6` `jr z` never taken); `CommTime_DrawSummaryScreen` then returns at `51:406D` when timer A is 0 (193 calls; 105 pass `51:4070`).  Name and status kept.
* 45 `Label_27_4EEB`: the HYPOTHESIS record stays; only one phrase was wrong: "the same ending as the live `MailConnect_InitScreen`" is inexact: the live tail has `or $64` into rLCDC, `VBlank_Wait` and `Palette_FadeInFromWhite` between `farcall LCDOn` (`27:4D35`) and `ld bc, 0 ; ret` (`27:4D4A`); everything else holds; a ROM scan finds only `jp` at `27:4EBD` as a reference; `CommTime_DrawHMSScreen` has one caller, at `27:4D4E`, which nothing references.
* 46 `Label_27_4FC0` (evidence): the twin range "51:4199-41D1" ends inside the farcall at `41CD-41D2`; the 59 equal-length bytes are `51:4199-41D3`; the byte diff is exactly as claimed: 5 table words (10 bytes), 4 `jp` operands (8 bytes), last byte `c9` against `e0`.
* 47-50 (names): `ButtonA/ButtonB/Select/Start` mixes two patterns: the tree convention for JoypadDispatch handlers is `<Screen>_OnA/_OnB/_OnSelect/_OnStart/_Idle` (TopMenu, SoundTest, MobileDict, MailMenu, BrowserStart, DebugFlags, DebugErrorTest); mapping re-read at `00:056A`: `hJoyPressed` bit 0 A is word 0, bit 1 B, bit 2 Select, bit 3 Start, none is word 4; the 5-word table at `27:4FD8` follows that order.  46 and 51 (names): see "Mirroring".  Roles and PROBABLE status are fine.
* 52 `Label_23_4FD8` (evidence): "the same 22 bytes" is 24 bytes (17 instructions, `23:4FD8-4FEF` against `23:53BD-53D4`, byte-compared equal); the B test is three instructions, `ldh` `4FD2`, `and` `4FD4`, `jr z` `4FD6` (twin `53B7/53B9/53BB`); the cited ranges omit the `ldh`.
* 55 `Label_2E_4298` (evidence): "the mail counters redrawn (`SpriteCounter_StubC/StubB`)" is wrong: both are a single `ret` (`23:6699` and `23:5FA2`; 71 and 96 hits), so nothing is redrawn.  Minor, not corrected: row 57 omits the dead `jp .l4F88` at `2E:4F27` from the loop exits; row 59's "27 runs" at `2E:54E0` counts executions, not takes (3 taken).

Mirroring (point 3): honest yes, consistent no.  Roles hold: loop head, table words 0-3 = A/B/Select/Start, exit; the 59 bytes equal the live loop, and each label sits at the same offset (+0, +22, +25, +28, +2B, +2E from `51:4199`).  The names do not mirror, for two reasons: two patterns are mixed (ButtonA/ButtonB against Select/Start), and the file's own dead copies use the live name plus bank_addr (`CommTime_DrawNumber_27_4FFB`, `CommTime_PutDigit_27_5021`, `Gfx_StartHDMAAtVBlank_2F_7365`; STYLE.md section 4 says the same): `CommTime_Summary27_*` was an invention.  The corrections derive the dead names from package B's current live names, with the On* fix:

| dead | live | proposed name for both (dead adds the suffix) |
|---|---|---|
| 27:4FC0 | 51:4199 | `CommTime_Summary_FrameLoop` (dead: `..._27_4FC0`) |
| 27:4FE2 | 51:41BB | `CommTime_SummaryInput_OnA` (dead: `..._27_4FE2`) |
| 27:4FE5 | 51:41BE | `CommTime_SummaryInput_OnB` (dead: `..._27_4FE5`) |
| 27:4FE8 | 51:41C1 | `CommTime_SummaryInput_OnSelect` (dead: `..._27_4FE8`) |
| 27:4FEB | 51:41C4 | `CommTime_SummaryInput_OnStart` (dead: `..._27_4FEB`) |
| 27:4FEE | 51:41C7 | `CommTime_Summary_Close` (dead: `..._27_4FEE`) |

Package B's live rows (`Label_51_41BB`..`41C4`) currently use `CommTime_SummaryInput_ButtonA/ButtonB/Select/Start` and need the same On* change; if package B keeps other words, the six dead rows are derived mechanically as live name + `_27_<addr>`.

InsertChar: the 64-byte capacity block (name `2F:5CB4`, title `2C:455C`) is byte-identical except the `call` operand; CheckRow, NextRow and Reject do the same job in both, and in the profile copy; `_Insert` marks the block starting with sfx `$38` in both name (`2F:5CF4`) and title (`2C:44DC`); the capacity probe comes before it in the name copy and after it in the title, profile and address copies, which is why only title has `_ShiftAndStore`; the body copy is not "the same code" (rows 14 and 27 say it is): it has an extra `.l50D5` (`ld a, 7 ; cp b ; jr nz, reject ; jr insert`) and `cp $0D ; jr z, reject` at `.l50DC`; only the `ld a, 8 ; cp b ...` tail is identical, as row 15's wording says.

Stray fragments: all five are true dead code: `0C 0D 20 02` (`inc c ; dec c ; jr nz, NoChar`) at `2F:73A6`, `2F:5C30`, `2C:4463`; the 13-byte `3e 01 e0 8d e0 70 7e fe 0d fe 00 28 22` (`jr z, Insert/ShiftAndStore`) at `2F:5CC5`, `2C:456D`; each follows an unconditional `jr`/`jp`, nothing references it (ROM scan), none ran, and the targets are as claimed; the same bytes exist unlabeled in the body copy (`2D:4EAE`; its exits are local `.l4EB2/.l4EB4/.l4EBA`) and the profile copy (`2A:5C7D`, `2A:5D7E`).

Retyping the mistyped "ptrtable" at `2A:4A66` and deleting the three labels (confirmed: the bytes are the text "　セーブ", `81 40 83 5A 81 5B 83 75 00`) also turns all 8 of rows 63-70, and `Label_2A_40A8` (part A), into locals; the localizer output does not assemble unchanged: `.loop` is defined twice per function.

Part A, outside the reader's rows: row 20 `MailTitle_Entry_ClampColumn` is CONFIRMED, but its clamp store `ld c, $0A` (`2C:4040`) never ran (`jr nz` 3776/3776): the role rests on one never-run instruction, so PROBABLE is honest; the name stays; the same holds for `2F:5837` and `2A:5502`, whose labels are named `_Loop` and so are unaffected; the clamp job is the same in all three editors: the column is limited to the buffer's cell count. 2.

Dead-code rule: both HYPOTHESIS records are honest (`2B:56CB-5805` for `Label_2B_57CB`: 12 BG cells of `$46`, `String_2B_5807` = six `81 40`, forced-only 6 of 8; and the `27:4EEB` chain).

Part B's 11 PROBABLE rows are honest: 38, 42, 46-52, 65, 69; each has an entry from live or executed code, or an identical executed twin; rows 46-51 follow the `naming2_verify_fn4.md` row 22 precedent (a dead twin of live code is PROBABLE); read literally, brief rule 5 would keep them neutral.

Send/receive and mail server: `MailConnect_Screen` returns `$80` at `27:4392`, `43FE` and `4746`, 0 at `44E0`, and `$20` at `469F`; the `ld a, $FF` at `469B` is dead; the only `ld a, $FF ; ret` is in the unreferenced fragment `27:46A1-46DC`, which references only itself; so `cp $FF ; jr z, .l407B` (`27:4071`) can never be taken; `.l407B` has 6 hits, equal to the 6 fall-throughs of `27:4079`.

`23:503F` `CountDeleted` is honest: `Pop3_DelePoll` returns only 1, `$FF` or 0; the caller does `cp 1 ; jr z, poll ; cp $FF ; jr nz, 503F`, so any other result counts the mail: W627 += 1, W629 -= 1; the server's +OK/-ERR line is not read here; `SendDele` `23:4F9C` 13 hits equal `503F` 13 hits; the status screen label "けしおわったメール" matches.

Other part B names are honest and consistent within the package: `DrawCounts_ModeN_{Unknown,Numbers}`, `MailSendRecv_Main_*`, `MailSrvDel_DeleteAllRun_*`, `MailServerMgr_*`, `Profile_Edit_*`, `Profile_DrawAddressLineN_*`; the two line drawers are byte-identical except `$0A` against `$10` and the internal addresses. 4.
