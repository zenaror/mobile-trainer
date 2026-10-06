# Independent verification of the sound effect names and the macro (sfx1)

> Status: **reference (current)**.  An executor read the 367 sites and proposed names (17 constants, 4 optional); two readers with a fresh context checked them, S1 the ids `$29 $2A $2B $2C $2D $2E $30 $31` (261 sites), S2 the other
> 22 ids (106 sites) and the claims about the idiom.  Both read **every** site (not a sample), mapped all 367 lines to their ROM addresses (`tools/line_addresses.py`: every address holds `CD AC 20` preceded by `01 NN 00`
> with the right id) and joined them to `analysis/coverage_union.tsv`.  S2 also converted the 367 sites to `play_sfx` in a scratch copy (ROM identical).  What the tree contains is the result after their corrections:
> [`naming2_sfx1.md`](naming2_sfx1.md).

## 1. Verdicts

| reader | ids | verdicts |
|---|---|---|
| S1 | `$29 $2A $2B $2C $2D $2E $30 $31` | 8 upheld, 0 renamed, 0 dropped; the 2 `$31` sites of the dead prototype stay numeric, and so does the `$2E` stub of `settings/continue_prompt.asm` (a `[HYPOTHESIS]` function with no entry); branch direction and "the action is not carried out" checked at all 52 live `$31` sites; executed 218 of 261 |
| S2 | `$32 $33 $34 $35 $36 $38 $39 $3E $3F $44 $45 $46`, the single-site ids, `$2F $3D $40 $41 $42 $48` | 9 upheld (`$32 $33 $34 $35 $36 $38 $39 $3E $3F`), 2 renamed (`$44` -> `SFX_COMM_CLOSE_DONE`, `$45` -> `SFX_COMM_CLOSE_ENDED`), 6 dropped (`$2F $3D $40 $41 $42 $48`), `$46` split (the 4 live sites may take `SFX_ADAPTER_ANIM`, the 4 dead ones stay numeric), 4 single-site ids (`$3A $3B $3C $43`) recommended numeric; executed 99 of 106 |

## 2. What the readers corrected in the executor's report

| finding | evidence | integration |
|---|---|---|
| `$44` / `$45` had no decoded texts; `$45` "end message shown" is false at `comm_scene.asm:364` and `:603` (the text still reads "Cancelling...") | S2 rendered the 8 text boxes of `CommScene_*` (signed tile addressing: Connecting / Connected / Downloading / Downloaded / Ending / Ended / Cancelling / Cancelled; box 7 is never shown) and the 6 `MailConnect` / `MailDisconnect` strips | renamed `SFX_COMM_CLOSE_DONE` (after "Connected" / "Downloaded", the sprites slide right) and `SFX_COMM_CLOSE_ENDED` (after a cancel or an end finished, slide left): "close" is true at all 9 sites |
| `$32` / `$33` "carried out" is wrong: the sound comes before the write at 4 of the 5 save sites (`save_confirm.asm:86`, `save_sender_address.asm:546`, `page_list.asm:2337`, `connect_dialog.asm:792`) and before the slot is zeroed at `page_list.asm:2577` | S2: the dialog texts decoded via `Dialog_ListTable` (`$020B` save the address, `$0208` overwrite it, `$0202` save the written mail, `$0109` overwrite saved data, `$020D` / `$0206` / `$0209` / `$0108` erase ...) | names mean "confirmed" and the constant comments say so |
| `$39` is "the erase key was handled", not "a character was erased" (it plays on an empty name at `profile_editor.asm:1506` and before `TextBuf_DeleteLast` at `mail_address_entry.asm:336`; the executor's "6 after DeleteLast" is 5 of 6) | S2 | name kept (`SFX_CHAR_ERASED`), the comment lists the two sites |
| Idiom note: "BC = $00NN" after the macro is false: the driver loads BC, DE and HL; the counts around the idiom were 190 / 156 / 6 / 15 (not 127 / 44) | S2: `SoundDrv_LoadSongHeader` `ld bc, $5515` (04:4325), `ld b, a` (04:41CF); register-liveness walk over all 367 sites | the macro comment says "clobbers B, C, D, E, H, L" |
| "A on No plays `$2C`, not `$2E`" is wrong for the connect dialog: in modes 0/1, 2, 7 and 10 an A on "No" plays `$2C` and then `$2E` (the A branch falls into the B handler); `ConnectDialog_PlayButtonSfx` has 10 handler cases for 11 modes (0 and 1 share one) and its mode 6 cases are unreachable | S1 | the `$2E` comment says "after `$2C`" and the note section 4 lists it |
| `profile/profile_editor.asm:2117` plays `$2C` also for key 8 and only when the name is not empty; `comm/notice_dialog.asm:364` also for a 10 s timer (never executed); the `$2E` count "45 B" includes the dead stub (44 live) | S1 | the `$2C` comment names the cases |
| `mail/mailbox.asm:1413` and `settings/slot_menu.asm:244` play `$29` without a press that moves the cursor (a re-placed row after a delete; a press at the edge) | S1 | name kept (a cursor-move cue); the comment lists them |
| the hints of `triggers.tsv` were wrong at 9 sites of `$29` (a D-pad press shown as A), 12 of `$2E` (B shown as A), `$43` and 4 sites of `$2F` | S1, S2 | the scratch table is not part of the repository |
| the macro leaves A = the `hWRAMBank` shadow and one site reads it (`top_menu.asm`, stores 7 in `wTopMenu_PrevCursor`); the macro assumes `hWRAMBank == rSVBK` on entry (four sites differ in the replays); `Stat_ScrollSplitHandler` can leave `hWRAMBank = 1` | S2 (the observed bank at `1F:42FB-4300` is 7 only), S1 | macro comment, note section 4, a comment at the top menu site; the shadow / register difference is an open question |
| Single-site ids: a name that cannot be tested against a second site is vacuous | S2 | `$3A $3B $3C $43 $3D $40 $41 $42` stay numbers with the roles in the comment of `consts.asm` |

## 3. Decisions of the coordinator

* Prototype sites (`engine/unreferenced/`) and `[HYPOTHESIS]` stubs keep their numbers whatever the id (the tool does it: `NUMERIC_DIRS`, `hypothesis_above`); `SFX_DELETE` stays at the unreachable site of `connect_dialog_screen.asm` with a comment.
* Both readers accept a name that is true only at some sites of an id when the other sites are provably unreachable and say why (the mixed ones: `$2C` for Select / Start / the 10 s timer are the same outcome reached by another trigger).
* The constants are UPPER_CASE words (STYLE.md section 4), defined in `consts.asm` with `EXPORT`; the header of that file no longer says "never substituted into operands" for the sound ids.

## 4. Limits

Static reading, ROM decode, coverage unions (no per-execution data) and builds in private copies; nothing was listened to and no emulator was run for the idiom claims.  Which sound is which was not checked: the names rest on the role of the call only.  The
text decode of the communication boxes is the readers' own reading of rendered tiles.  The observed-bank differences of the four sites are unions over scenarios and do not identify the cause.
