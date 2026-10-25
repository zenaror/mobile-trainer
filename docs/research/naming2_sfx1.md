# Sound effect calls (sfx1): the macro `play_sfx` and 20 named sound ids (ROM unchanged)

## 1. Result

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

The names are about the *call*, not the sound.  The streams of `audio/sfx.asm` corroborate the pairs (`$32` rises and `$33` falls, `$3E` / `$3F`, `$44` a chromatic run up and `$45` down, `$2C` and `$2D` identical) and name no role.

## 3. Ids that stay numbers

* `$002F`: plays when a communication wait ends, for a completed step at three sites (`comm_scene.asm:223, :459`, `send_receive.asm:568`) and for a cancel at four (`comm_scene.asm:250, :486`, `send_receive.asm:679`, `comm_panel.asm:275`): no name is true at all seven.
* `$003A` (Select cycles the on-screen keyboard page), `$003B` (a newline is accepted in the mail body), `$003C` (a mail is about to be retrieved), `$0043` (the send phase starts: `$3C` and `$43` share one stream), `$003D`
  (`MailSession_Finish` entry), `$0040` and `$0041` (the two cues of one help-script page turn), `$0042` (no mail / cannot receive): one site each, roles verified, and a name that cannot be tested against a second site documents
  little; they become constants when a second site appears.  `$0048` has two sites, both in the dead prototype, and is outside the song table (silent).
* The dead prototype `engine/unreferenced/page_list_prototype.asm` plays A = `$31`, B = `$48`, cursor = `$46`, where the live page list plays `$2C`, `$2E`, `$29`: its ids follow an older numbering (HYPOTHESIS), so its sites keep numbers.

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

```
python3 tools/apply_play_sfx.py --check        # exit 0: no site of the idiom is left
python3 tools/apply_play_sfx.py --dry-run      # what a run would write (needs nothing built)
python3 tools/test_play_sfx.py                 # 11 tests
python3 tools/invariants_check.py              # S1 reads the macro
```
