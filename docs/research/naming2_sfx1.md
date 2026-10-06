# Sound effect calls (sfx1): the macro `play_sfx` and 20 named sound ids (ROM unchanged)

> Status: **reference (current)**.  The user interface plays its sound effects with one fixed eight-line idiom (367 sites in 62 files, 30 ids); it is now the macro `play_sfx ID`, and the ids whose role is the same at
> every live site have a name `SFX_...` (all PROBABLE: the role of the call is read from the code around it; nobody has identified which sound is which).
> Records: `constants/macros.inc` (`play_sfx`), `consts.asm` (`SFX_*`), tool `tools/apply_play_sfx.py` (11 tests in `tools/test_play_sfx.py`), `tools/invariants_check.py` (reads the macro); independent verification:
> [`naming2_verify_sfx1.md`](naming2_verify_sfx1.md).

## 1. Result

| item | count |
|---|---|
| call sites written as `play_sfx ID` | **367** in 62 files (8 lines each became 1: 2,569 lines fewer); the 368th `call Sound_PlaySfx` (`engine/debug/sound_test.asm:202`, the id comes from memory) is not the idiom and stays |
| with a name | **343**, with 20 constants in `consts.asm` (`DEF SFX_X EQU $00NN ; PROBABLE <role and evidence>` + `EXPORT`); 24 keep the number |
| ids that stay numbers | 10: `$002F`, `$003A`, `$003B`, `$003C`, `$003D`, `$0040`, `$0041`, `$0042`, `$0043`, `$0048` (section 3); the 8 sites of the dead page-list prototype (`engine/unreferenced/`: ids `$31`, `$46`, `$48`, an older table) and the one site in a `[HYPOTHESIS]` stub (`settings/continue_prompt.asm`) stay numbers whatever the id |
| executed | 317 of the 367 sites ran in the natural traces (`analysis/coverage_union.tsv`) |
| ROM | byte-identical (`make compare`: `RESULT: IDENTICAL`; `sym-check`, the form checks, `tools/invariants_check.py` (S1 now reads the macro: 452 stub calls, ALL PASS) and every other audit pass) |

The macro (`constants/macros.inc`) expands to exactly the eight instructions that the sites wrote:

```
	ldh a, [hWRAMBank]
	push af
	ld a, $01
	ldh [rSVBK], a
	ld bc, ID
	call Sound_PlaySfx          ; 00:20AC: call Bank4_GateEnter / jp SoundDrv_PlaySfx (bank 04)
	pop af
	ldh [rSVBK], a
```

## 2. The constants

| constant | id | sites (executed) | role (what the call is for) |
|---|---|---|---|
| `SFX_CURSOR_MOVE` | `$0029` | 67 (58) | a selection cursor moved: Up/Down/Left/Right on menus, lists, Yes/No pairs, tabs and keyboard cells; also when nothing can move (`settings/slot_menu.asm:244`), Start jumping to the OK key, the list re-placed after a mail delete |
| `SFX_TOP_MENU_LEFT_RIGHT`, `SFX_TOP_MENU_UP_DOWN` | `$002A`, `$002B` | 2 (2), 2 (2) | the top menu cursor: Left to item 1 / Right to item 2, Down to item 3 / Up from item 3 back; only when it changes; used nowhere else |
| `SFX_CONFIRM` | `$002C` | 67 (62) | the accept cue: A on a menu entry, list row or Yes/No screen (before the cursor is tested, so also on "No"), A on intro and notice pages, OK key after validation, Start on the title menu, Select on the mail sender page |
| `SFX_DIALOG_CONFIRM` | `$002D` | 2 (2) | A in the message dialog service (`Dialog_*`), Yes or No alike; the stream is byte-identical to `$2C`'s, which every other screen uses |
| `SFX_CANCEL` | `$002E` | 63 (55) | back / cancel: B on menus, lists, Yes/No pages and dialogs; the keyboard cancel key or erase on an empty field; "No" of the connect dialog (after `$2C`); Select in the help script and the dictionary view |
| `SFX_DIALOG_OPEN` | `$0030` | 4 (4) | a dialog or prompt appeared (after `Dialog_SlideIn`; entering the connect-dialog Yes/No prompts) |
| `SFX_REJECT` | `$0031` | 52 live (33) | input refused, nothing done: field full, kana mark not applicable, OK key with a too short or invalid entry, disabled key, empty / occupied / locked slot or item (the 2 sites of the dead prototype play it on A: numeric) |
| `SFX_SAVE`, `SFX_DELETE` | `$0032`, `$0033` | 5 (5), 5 (4) | a save / an erase is confirmed (Yes of the dialog: the text of each dialog was decoded); at 4 of the 5 save sites the sound comes before the write; `connect_dialog_screen.asm:1762` is unreachable |
| `SFX_POPUP_OPEN`, `SFX_POPUP_CLOSE` | `$0034`, `$0035` | 4 (4), 2 (2) | an overlay panel (browser page menu, on-screen keyboard, type picker) starts to slide in / out; dialogs use `$30` after their slide |
| `SFX_TEXT_CURSOR_MOVE` | `$0036` | 14 (14) | the d-pad on the text cursor of a text editor, played at entry before the edge test; selection cursors use `$29` |
| `SFX_CHAR_ENTERED`, `SFX_CHAR_ERASED` | `$0038`, `$0039` | 25 (25), 13 (13) | a typed character or kana mark is accepted (13 inserts, 12 marks that rewrite the previous character); the erase key was handled (it plays with nothing to erase in 2 places) |
| `SFX_LINK_FOLLOW`, `SFX_HISTORY_BACK` | `$003E`, `$003F` | 2 (2), 2 (2) | A on the selected hyperlink; B goes back in the page history (an empty history plays `$2E`) |
| `SFX_COMM_CLOSE_DONE`, `SFX_COMM_CLOSE_ENDED` | `$0044`, `$0045` | 3 (3), 6 (6) | the communication scene closes after "Connected" / "Downloaded", the sprites leaving to the right; after "Cancelled" / "Ended" (or the cancel / end finishing), leaving to the left; the texts of the 8 text boxes and of the mail strips were decoded |
| `SFX_ADAPTER_ANIM` | `$0046` | 4 live (4) | plays once per animation cycle when the frame index of sprite slot 0 is 2 (a latch flag) on the adapter screens; the 4 prototype sites use it as a cursor sound: numeric |

The names are about the *call*, not the sound.  The streams of `audio/sfx.asm` corroborate the pairs (`$32` rises and `$33` falls, `$3E` / `$3F`, `$44` a chromatic run up and `$45` down, `$2C` and `$2D` identical) and name no role.

## 3. Ids that stay numbers

* `$002F`: plays when a communication wait ends, for a completed step at three sites (`comm_scene.asm:223, :459`, `send_receive.asm:568`) and for a cancel at four (`comm_scene.asm:250, :486`, `send_receive.asm:679`, `comm_panel.asm:275`): no name is true at all seven.
* `$003A` (Select cycles the on-screen keyboard page), `$003B` (a newline is accepted in the mail body), `$003C` (a mail is about to be retrieved), `$0043` (the send phase starts: `$3C` and `$43` share one stream), `$003D`
  (`MailSession_Finish` entry), `$0040` and `$0041` (the two cues of one help-script page turn), `$0042` (no mail / cannot receive): one site each, roles verified, and a name that cannot be tested against a second site documents
  little; they become constants when a second site appears.  `$0048` has two sites, both in the dead prototype, and is outside the song table (silent).
* The dead prototype `engine/unreferenced/page_list_prototype.asm` plays A = `$31`, B = `$48`, cursor = `$46`, where the live page list plays `$2C`, `$2E`, `$29`: its ids follow an older numbering (HYPOTHESIS), so its sites keep numbers.

## 4. What the idiom does (verified by readers S2 and S1)

* After the eight instructions **A = the `hWRAMBank` shadow at entry** (not `rSVBK`) and F = the flags at entry; the stub's own result (A = 0 started, A = `$FF` the bank-4 gate was busy and nothing played) is dropped by `pop af`.
  **BC does not keep the id**: for a valid id `SoundDrv_LoadSongHeader` loads BC itself (`ld bc, $5515`, 04:4325) and DE and HL are overwritten too; only the silent paths leave them.  Exactly one site reads the leftover A:
  `menus/top_menu.asm` (the Up handler) stores it in `wTopMenu_PrevCursor` (7, not the cursor 3: a quirk of the original, already noted in `ram/overlays.asm`; `TopMenu_LoadPanel` ignores it).  A register-liveness walk from the end of
  the idiom at all 367 sites found no other consumer of A, F, BC, DE or HL; none branches on a flag set before the idiom.
* The macro assumes `hWRAMBank == rSVBK` on entry: it sets `rSVBK` to 1 without writing the shadow and ends with `rSVBK := shadow`.  The replays show four sites where the bank in force differs before and after
  (`dialog/dialog.asm:354`, `browser/page_list.asm:2443`, `keyboard/keyboard.asm:1145`, `mail/mail_title_entry.asm:136`: unions of the scenarios, no per-execution data): the shadow and the register were not equal there.  One visible
  mechanism is `Stat_ScrollSplitHandler` (00:0E93), which rewrites `hWRAMBank` from `rSVBK` on return, so an STAT interrupt between the two writes can leave `hWRAMBank = 1`; the six sites of `mail_server/delete_*.asm` and
  `browser/page_list.asm` that put `di` / `ei` around the sound sit in screens that use that handler.  Not settled (open question).
* The sound is played *before* the outcome is tested at many sites (the 14 text-caret moves, the Backspace routines, `Kbd_MoveCursor`, every Yes/No screen: A on "No" plays `$2C`; in the connect dialog an A on "No" plays `$2C`
  and then `$2E` in modes 0/1, 2, 7 and 10); and after it at others (every `$31`, `$32` / `$33` after the Yes, the entry screens after `TextBuf_AppendChar` / `TextBuf_DeleteLast`).

## 5. Why only this idiom

`play_sfx` replaces one idiom that the sound driver's invariant S1 explains (bank 04 runs only under WRAM bank 1; the macro is where the bank is selected) and whose eight lines carry no information beyond the id.  The WRAM and SRAM
bank-switch idioms (`ld a, $0N / ldh [hWRAMBank], a / ldh [rSVBK], a`, about 3,000 lines) are **not** macros: the bank proofs of `tools/apply_ram_operands.py` and `tools/invariants_check.py` read exactly those lines, and a macro
would hide the bank at the place where it matters.  The tools treat a macro line as a barrier (it is not a plain instruction), so they lose a proof across `play_sfx` and never invent one; `tools/invariants_check.py` reads the
definition of the macro and checks the 452 calls of the sound stubs on its expansion.

## 6. Reproduce

```
python3 tools/apply_play_sfx.py --check        # exit 0: no site of the idiom is left
python3 tools/apply_play_sfx.py --dry-run      # what a run would write (needs nothing built)
python3 tools/test_play_sfx.py                 # 11 tests
python3 tools/invariants_check.py              # S1 reads the macro
```

On the tree of commit c743ce2 (before the pass): the macro, the constants, `python3 tools/apply_play_sfx.py` (it builds and compares the SHA-256, and restores the files when it differs) and `python3 tools/remap_record_lines.py c743ce2` (the records `ramop9_manual.tsv` and `ramop10_manual.tsv` name their rows by file and line: 166 rows moved, and `tools/apply_manual_sites.py --dry-run` is back to 0 skipped), and two comments (`SFX_DELETE` at the unreachable site of `connect_dialog_screen.asm`, the quirk of the leftover A in `top_menu.asm`).
