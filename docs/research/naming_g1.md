# Naming pass g1: banks 04, 0E, 19, 1A, 1B, 1C, 1D, 1F, 22, 23

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Namer 1/8.  Owned files: `config/symbols/bank{04,0E,19,1A,1B,1C,1D,1F,22,23}.tsv` (413 rows), `analysis/naming/ram_g1.tsv` (RAM proposals, not merged
into `config/ram`) and this note.  Every symbol file was verified on a copy of `config/` with
`python3 tools/gen_asm.py verify --config <copy>` (IDENTICAL, also `check --strict`), and once more on a copy of the *current* real `config/` plus these ten
files (the banks of the other namers present at that time: 0F, 24-2F, 48, 57, 5C, 63, 65, 67, 74, 75, 7C-7F; no name collision, checked against `config/symbols`, `config/ram`, `analysis/naming/*.tsv` and the region labels).  `src/` was not touched.

Status vocabulary as everywhere: **CONFIRMED** (executed in a trace and the role is shown by an observed screen, a hardware-register write or a
byte-exact structure), **PROBABLE** (>= 2 independent clues), **HYPOTHESIS** (generic name kept, the idea is only in the evidence column).
Rows whose entry was never executed are never CONFIRMED (the table builder downgraded them automatically: the address must be an executed
instruction start in `analysis/coverage_union.tsv`).  Result (after the adversarial review of section 14): 225 CONFIRMED, 166 PROBABLE, 22 HYPOTHESIS rows (170 functions, 107 labels, 73 data,
42 tables, 21 strings).

Prefixes chosen to stay clear of the other namers: `Main_`, `Title_`, `TopMenu_`, `MailMenu_`, `MobileDict_`, `MailSrvDel_` / `MailSrvDelHidden_`
(mail-server delete menus), `SramCheck_`, `DebugFlags_`, `DebugErrorTest_`, `SoundTest_`, `SoundDrv_` (bank 04 sound engine), `SpriteCounter_`,
`Gfx_/Tilemap_/Palette_<Screen>_` for data.

## 1. Subsystem map

| bank | what it is | entry point | how it is reached | executed in |
|---|---|---|---|---|
| 04 | **Sound engine** (music + effects, 8 sequencer tracks, 4 APU channels) | `SoundDrv_*`; entered only through the 13 ROM0 stubs `00:20A0-20E8` | Boot (`00:0300`), frame service `00:0392`, UI code (`call 20AC/20B2/20E8`) | every scenario |
| 0E | **Title screen**: 'Mobile System GB' logo, then the title menu (スタート / モバイルせってい) | `Title_Run` (0E:4000) | `1C:4007` | 35 of 41 scenarios (not the 6 that stop in the registration wizard / error screens) |
| 1C | **Main program** (8 instructions + inline dispatch table) | `Main_Run` (1C:4000) | `00:0328` (`farcall 1C:4000 ; jp $0328` forever) | every scenario |
| 1F | **Top menu** (3 icons: mail / homepage / help) | `TopMenu_Run` (1F:4000) | `7C:7B85` | 28 scenarios |
| 1D | **Mail menu** (6 plates: send/receive, write mail, mailbox, address book, profile, mail server) | `MailMenu_Run` (1D:4000) | `7C:7BC0` | 22 scenarios |
| 1A | **Mobile dictionary index** (モバイルじてん: 11 kana-row tabs, 5 entries per page) | `MobileDict_Run` (1A:4000) | `6C:59A8` (help menu entry 4) | 5 monkey scenarios only |
| 23 | **Mail-server delete menu** (メールのけしかたをえらんでね: 2 buttons) and the delete transactions | `MailSrvDel_MenuRun` (23:4000) | `7C:7D15` (mail menu item 6) | 8 scenarios (mail_server*, monkey_camp_*) |
| 22 | **Hidden variant** of that menu (3rd button 'かんぜんにけす') + the **SRAM integrity library** (bank-0 mirror pages, bank-1 checksum) | `MailSrvDelHidden_MenuRun` (22:4000); `SramCheck_*` (22:4EF0-50FC) | `7C:7D0C` when SELECT+LEFT is held; library: banks 25 2A 2B 2D 48 54 65 68 | hidden: mail_server_hidden only; library: boot of every scenario |
| 19 | Unreferenced **debug screens**: 'DEBUG MODE' flag editor (19:4000) and an error-screen tester (19:4980) | `DebugFlags_Run`, `Debug_ErrorScreenTest` | no caller anywhere | never |
| 1B | Unreferenced **sound test** screen | `SoundTest_Run` (1B:4040) | no caller anywhere | never |

Graphics of the menus are not in these banks: 1F loads its tiles/tilemaps/objects from **bank 1E** (`a=$1E`), 22/23 load the menu art from **bank 28**
(palettes `$6E00/$6E40`, tiles `$5F20/$6150/$6550/$67E0`, objects `$6E80/$6E90`, tilemaps `$6860/$6B30`).  Bank 22 stores the tilemap and two palettes of the
communication-progress scene used by bank 26 (`22:5980`, `22:5C50/5C90`).

## 2. Program flow around these banks (CONFIRMED unless marked)

```
Boot 00:0328  farcall 1C:4000                      Main_Run
  65:4000 Startup_Run (once)                       inits, adapter check, boot-mode dispatch (SRAM checks 22:4FF6/4FA9 are called from bank 65)
  loop Main_TitleLoop:  farcall 0E:4000            Title_Run: A=0 first call (logo states), A=1 afterwards
     A = 1 + selected item  -> JumpTableInline (Table_Main_TitleChoices)
       1 Start     -> 7C:7B7C Nav_TitleStart    48:4A4E gate, loop Nav_TopMenuLoop { 1F:4000 TopMenu_Run -> table 7C:7B8E }
                        0 back (ret)   1 mail: 7C:7BB7 Nav_MailMenu -> loop { 1D:4000 MailMenu_Run -> table 7C:7BC9 }
                        2 homepage: 4F:4668          3 help: 6C:5987 (help menu; entry 4 'モバイルじてん' -> 1A:4000)
       2 Settings  -> 7C:7D1F Nav_TitleMobileSettings   SRAM 1:$BF01:=0, then loop 68:4F9E (mobile settings, per g7)
  MailMenu result (7C:7BC9, Nav_MailMenu_*):  1 send/receive (27:41BC/25:4A90 ... 27:4000)   2 write mail (2D:4000 if SRAM0 $A000 == 0 else 2B:4000)
     3 mailbox 25:4000   4 address book 2F:7EBF   5 profile 2A:5495   6 mail server: 23:4000, or 22:4000 when hJoyHeld == SELECT+LEFT ($24)
```

The `A` value returned by `TopMenu_Run` / `MailMenu_Run` is the selection (1-3 / 1-6) or 0 for B; both menus remember the last selection in SRAM bank 1
(`$A8B9` top menu, `$A8B8` mail menu, `$BF00` title menu) and re-select it when they are entered again.

All screens of this group share the same skeleton (seen in 0E, 1A, 1D, 1F, 19, 1B, 22, 23, 57:4000, 5C:5150 ...): clear the screen-local variable block
`C0D4-C1CF` (`FillBytes hl=$C0D4 bc=$00FC`), `farcall 48:48BB` (a bare `ret` in this build: patched-out hook), LCDC window off, load tiles with HDMA
(`00:0787`: a=bank, hl=src, de=VRAM dest (bit0 of E = VRAM bank), c=blocks of 16 bytes), palettes to `$D800/$D840` (`4F:4000`, 64 bytes each), a
20x18 tile + attribute map to `$D000` (`00:08EA`, bc=$1214 -> 720 bytes), sprites (`00:0A82` object from a table, `00:0A65` position), palette fade
(`4F:42B4` etc.), then a per-frame loop that ends in `call JoypadDispatch` with an inline 5-word table {A, B, Select, Start, no button}.
`7D:7C00` (`Joypad_SetRepeatTiming`, b=$15, c=3) sets the key-repeat delay/interval used by `hJoyPressedRepeat` (`7D:7BB7` `Joypad_Update` is the per-frame poll).

## 3. Title screen and main program (banks 1C, 0E)

`Title_Run` keeps a state byte `wRam_C27C` (states 0-6 in `Table_Title_States`): 0 load logo (`Title_LoadLogoScreen`, tiles 60A0/64A0, map 68A0,
palette 6B70; the 'MOBILE SYSTEM GB' logo is on screen at frames 327-476 of the 35 traces that reach the title), 1 wait 180 frames or A/Start, 2 fade out, 3 load the title
(`Title_LoadTitleScreen`: 7 tile blocks, map 5BC0, palettes 5F30/5F70, objects 5FB0; selection restored from SRAM 1:$BF00), 4 menu (Up/Down toggles
`wRam_C27D`, sound $29; A/Start sound $2C; idle timeout 10800 frames = 3 min unless `wRam_C280 != 0`), 5 exit, 6 timeout restart (never executed).  The
result is `C27D+1`.  Title screen art: screenshot `title_settings_f01094` (title 'モバイルトレーナー', items スタート / モバイルせってい).

## 4. Top menu and mail menu (banks 1F, 1D)

Both are 'select a plate/icon, A = enter' screens: the current item is `wRam_C0E5` (1-based), the previous one `wRam_C0E6`, `wRam_C0E7/C0E8` animate the
selected icon every 30 frames; a description ticker (`48:42D4`, string index at `$43FA` in 1D / bank 1E `$4000` in 1F) scrolls under the menu.  Differences:

* `TopMenu` (1F): 3 icons at fixed positions (`Table_TopMenu_CursorTargets`), a cursor sprite that flies between them with fixed-point interpolation
  (`TopMenu_StartCursorMove` computes step count and 8.8 deltas with `48:4000` + `Divide16`, `TopMenu_UpdateCursorMove` applies them per frame; A presses during
  the move are queued in `wRam_C0E3`).  Right -> homepage (ホームページ), Left -> mail, Down -> help, Up (from help) -> the previous item.  Sounds: $2A/$2B move, $2C confirm, $2E cancel.
* `MailMenu` (1D): 6 plates in a vertical list, drawn by copying 10-column tile rectangles (`00:16A2`) from `Tilemap_MailMenu_PlatesNormal/Selected`;
  item 2 shows 'メールをかく' or 'メールをかくにん' depending on `[SRAM0 $A000] == 0` (a saved draft exists); an animated envelope icon
  (`MailMenu_AnimateIcon`, two 6x8 frames).  Up/Down wrap 1 <-> 6.

## 5. Mobile dictionary (bank 1A)

`6C:5987` (help menu) calls `1A:4000` for its 4th entry (モバイルじてん; the menu screenshot `help_f02426` shows the four buttons; `dynamic_tracing.md`
section 9 says the built-in dictionary is reached from ヘルプ -> モバイルじてん).  The screen has 11 category tabs (kana rows a ka sa ta na ha ma ya ra wa +
'other'; tab marker sprite x = 8+12*index from `Table_MobileDict_TabPositions`), a list of 5 entry names per page rendered with `48:415A`, Up/Down
cursor and scrolling, Left/Right change category.  Each category header is `count byte + count string pointers` (`Data_MobileDict_CatNNCount` /
`Table_MobileDict_CatNNStrings`, 11 headers, all validated against the strings).  A opens the entry page: the page index byte comes from a per-category
list in **bank 3F** (table at `$40B9`) and `4C:4F56` (a=2) shows it (the built-in `di/*.htm` pages of banks 3D/3E).  Only the monkey scenarios reach it, so the
page-view call is inferred from the call arguments, not from a screenshot.

## 6. Mail-server delete menus and the SRAM library (banks 23, 22)

Screens (`mail_server_full`, `mail_server_hidden` screenshots): title 'メールのけしかたをえらんでね', buttons 'かくにんしてからけす' (check then delete),
'じどうでぜんぶけす' (delete all automatically) and, only in bank 22, 'かんぜんにけす' (delete completely).  Both banks contain the same menu code
(bank 22 is a copy plus one extra button); the button index is kept in register C (1 = check then delete is the default, 0 = delete all, 2 = hidden).

| button | 23 (normal) | 22 (hidden variant) | what it does |
|---|---|---|---|
| check then delete (C=1) | `MailSrvDel_CheckAndDelete` 23:4B51 | `MailSrvDelHidden_CheckAndDelete` 22:4DAD | cost dialog `57:4000` `ConnectDialog_Run` ('つうしんせつぞくします ... よろしいですか？'), timer reset `51:4245`, `MailConnect_Screen` (27:41E3), then `2E:4000` (per-mail check/delete UI), `MailServerStatus_Screen` (29:44F6, C264=2) |
| delete all (C=0) | `MailSrvDel_DeleteAll` 23:4A06 | `MailSrvDelHidden_DeleteAll` 22:4B17 | confirmation dialog (`MailSrvDel_Confirm`, default 'いいえ'), cost dialog, connect, `MailSrvDel_DeleteAllRun` (23:4C94): login, pass 1 counts 'problem' mails with a TOP request each, pass 2 re-checks each mail and skips the problem ones, DELE for the rest, C264=1 result screen |
| delete completely (C=2) | - | `MailSrvDelHidden_DeleteCompletely` 22:4C62 | same, but `MailSrvDel_DeleteCompletelyRun` (23:51C7) sends DELE for every mail without any TOP check (executed in `mail_server_hidden`) |

Evidence for the 'problem mail' reading: the hidden button's description reads 'もんだいのあるメールとメールサーバにのこっているすべてのメールをじどうでぜんぶけします'
(problem mail *and* all mail on the server are deleted), the normal one 'すべてのメールを ... じどうでぜんぶけします', and the code difference is exactly the missing TOP
pass.  What the API results mean (B==2 = problem mail) is the SDK/bank-54 namers' business (API `$28` = POP3 TOP, `$26` = POP3 DELE per `mobile_candidates.json`, both HYPOTHESIS there).

Progress display: `MailSrvDel_ProgressInit` (bank 23 art) builds the transaction screen; `MailSrvDel_DrawElapsedTime` (23:6F00, called every frame: 594 times in `mail_server_full`, 372 in `mail_server_hidden`, 919 in `monkey_camp_rich`
(`traces/coverage_*.tsv`), also from `54:5391`) writes the 'MM:SS' timer from `wRam_C2D6`/`C2D5` into the tile buffer; `MailSrvDel_DrawProgressText` prints
'N通目をチェックしています' (checking mail number N; 'つうめ' = 通目 counter).  Messages: reading (`6E9C`), all deleted (`6DD0`), no mail (`6D8C`), blank (`6E14`).

**Removed code.**  `23:58C4`, `23:5FA2` and `23:6699` are functions whose first byte was replaced by `ret` (`$C9`): the bytes after them (58C5-5FA2,
5FA3-6699, 669A-6D61) are complete 5-digit *sprite counter* routines (`Divide16` by 10000/1000/100/10, one digit sprite per place from the object table
`Table_SpriteCounter_Digits` at 23:7990) that can never run.  The callers (this bank and bank 2E) still call the stubs; they are named `SpriteCounter_StubA/B/C`.  Similarly `48:48BB`
(called at the start of every screen) is a bare `ret`, and 22/23 each contain a dead 'print three numbers from C2D7/C2D6/C2D5' routine after a `ret`
(22:48CD, 23:47BC; `51:4245` clears `C2D4-C2D7` and `C2D8-C2DB`, so the numbers are probably the timer A hours/minutes/seconds).

**SRAM integrity library (22:4EF0-50FC, CONFIRMED)** - documents `sram_layout.md` section 2:

| routine | function |
|---|---|
| `SramCheck_Bank0PageSum` 4EF0 | sum of the first $FFE bytes of SRAM bank 0 page A0/B0, DE = sum, HL = stored word at page+$FFE |
| `SramCheck_Bank0StorePageSum` 4F24, `_ClearPage` 4F53, `_CopyPage` 4F7B | store checksum, zero a page, copy a page to its mirror (dest = src xor $10) |
| `SramCheck_CompareDEHL` 4F46 / `2` 5093 | A=0 equal, $FF different |
| `SramCheck_VerifyAndRepairAll` 4FA9 | page 0 ok -> copy to page 1; else page 1 ok -> restore page 0; else clear both; then the bank-1 block check (clear on mismatch); callers 65:418A/41A9/4226, 48:49F8, 68:4DB4 |
| `SramCheck_Bank0Status` 4FF6 | A=1 page 0 ok, 0 only page 1 ok, $FF both bad (no repair) |
| `SramCheck_Bank0Commit` 501D | re-sum page 0, store, mirror to page 1; called after every save from banks 25/2A/2B/2D/54 (10 sites) |
| `SramCheck_Bank1BlockSum` 5035 / `StoreSum` 5077 / `ClearBlock` 50A0 / `Bank1Commit` 50FC | scheme-1 checksum of SRAM bank 1 $A000-$A683 + $A69D-$A87C, word at $A8D7 |

`SramCheck_Bank0PageSum` and `_Bank0Status` run at frame ~324 at boot (`22:4EF0` in 40 of 41 scenarios, all but `noadapter`; `22:4FF6` in 32 of 41); the repair paths run in `boot_states` (damaged save RAM) and the
blank-cartridge scenarios.

## 7. Sound engine (bank 04)

Bank 04 holds a complete 4-channel sequencer.  It is entered through 13 ROM0 stubs that share a re-entrancy guard (`00:2116`: D000 bit7) and switch to ROM bank 4
(`00:20EE`), and it returns through `00:2141`.  **All its state is in WRAM bank 1** (the stubs are always called with rSVBK=1).

| stub | target | name | notes |
|---|---|---|---|
| 00:20A0 | 04:4000 | `SoundDrv_Init` | Boot only |
| 00:20A6 | 04:4082 | `SoundDrv_FrameTick` | from the frame service `00:0392` (guard: once per frame) |
| 00:20AC | 04:41C0 | `SoundDrv_PlaySfx` | BC = effect id (0 = stop all); UI sounds $29-$2E |
| 00:20B2 | 04:4287 | `SoundDrv_PlayMusic` | BC = music id (0 = pause) |
| 00:20B8 | 04:42C0 | `SoundDrv_PlayMusicIfNotPlaying` | no caller |
| 00:20BE | 04:43DC | `SoundDrv_StopSfxById` | BC = id, 0 = all |
| 00:20C4 | 04:4429 | `SoundDrv_PauseMusic` | |
| 00:20CA | 04:42EC | `SoundDrv_ResumeMusic` | no caller |
| 00:20D0 | 04:444B | `SoundDrv_GetActiveMasks` | no caller |
| 00:20D6 | 04:44B1 | `SoundDrv_SetTrackParam` | no caller (its core is used by the fade) |
| 00:20DC | 04:452C | `SoundDrv_StartFadeOut` | no caller |
| 00:20E2 | 04:445C | `SoundDrv_GetPlayingId` | no caller |
| 00:20E8 | 04:42D6 | `SoundDrv_PlayMusicOrResume` | music ids of most screens |

The identification of the stubs is independent of the code reading: the **sound test screen (bank 1B)** documents them in its own text: 'A: MUSIC' calls
`00:20B2`, 'B: SOUND' calls `00:20AC`, 'Sta: STOP' calls `00:20C4` and `00:20BE` with bc=0 and 'Sel: END' ticks `00:20A6`.

**Structure.**  8 track records of $3C bytes at D040 (tracks 0-3 = effects, group A, tempo D005-D009; tracks 4-7 = music, group B, tempo D00A-D00E) and 4 hardware
channel records of $18 bytes at D220 (`ldh [c]` register base $12/$17/$1C/$21 = NR12/22/32/42).  Each tick (`SoundDrv_FrameTick`) runs the effect group, then the music
group, then updates the channels; a group's tempo accumulator gets `tempo*scale>>6` per frame and one sequencer tick (`SoundDrv_StepTrack`) runs (repeatedly)
while it is >= $4A (74).  An effect that owns a channel (owner byte bit7) overrides music on the same channel; priorities live in the header (`D03E`) and track+8.
Register writers (CONFIRMED by the APU register writes): `SoundDrv_WriteChannelParams` (duty/length/sweep, wave pattern -> $FF30, noise width),
`SoundDrv_WriteChannelPitch` (NRx3/NRx4), `SoundDrv_WriteChannelPan` (NR51 masks $EE11/$DD22/$BB44/$7788), `SoundDrv_WriteChannelVolume` (NRx2 + trigger),
`SoundDrv_SilenceChannel`.

**Data.**  `Table_SoundDrv_Songs` (551D): 70 headers of 8 bytes for ids 1-70 (base `$5515 + 8*id`): stream word, ROM-bank word (4 or 5), priority ($C8; effects $30/$31 = $D2, $35 = $C9),
flags ($FF in all 70), track count (1-4), spare.  Ids 1-$0D live in bank 4, $0E-$1D (16 songs) and $29-$46 (30 effects) in bank 5, $1E-$28 are eleven copies of the entry of song 1.  A stream header is `dw ?` (2 bytes) + one stream pointer per track.  `Table_SoundDrv_Durations` (5044),
`Table_SoundDrv_NoteFreq` (5075, 120 x period word + 1 byte), `Table_SoundDrv_Instruments` (51DD, 112 x 6), `Table_SoundDrv_WavePatterns` (547D, 10 x 16).

**Stream format (validated).**  A scratch decoder (not committed) implementing exactly the byte classes of `SoundDrv_ReadNextCommand` (linear decode, calls/returns not followed)
decodes **all 152 tracks of the 59 distinct headers (ids `$1E-$28` are copies of song 1; banks 4 and 5) to a clean `$B1` end (66 tracks) or `$B2` loop (86 tracks) with no unknown byte
and no desynchronisation**; 29 of the 59 headers have exactly equal track lengths in this linear decode (song 6: 384 x 4; song 1: 200/200/200/198 ticks); in the others a track repeats a shorter
pattern or uses `$B3` sub-routines that a linear decode counts differently.  Byte classes: `$81-$B0` = wait (duration from the table, `SoundDrv_CmdRest`), `$D0-$FF` = note
with length code (`byte-$CF`, `SoundDrv_CmdNote`) followed by optional pitch (`$24-$7F`), modifier (`<$20`) and adjust (`$20-$23`) bytes, data bytes (bit7 clear) after a
note/command repeat the last opcode >= $BE (running status), commands `$B1` end, `$B2` jump, `$B3` call, `$B4` return (a no-op on an empty stack),
`$B5` counted loop (never used), `$BC` tempo, `$BE` instrument, `$BF` volume (the songs use `$BD`, `$C1`-`$C5` as well; their targets are in `Table_SoundDrv_Commands`, fields
partly identified below).  Usage counts over the 152 tracks: wait 4868, note 4324, `$BE` 1109, `$C1` 550, `$B3` 276, `$BF` 152, `$BD` 152, `$B4` 113, `$B2` 86, `$B1` 66, `$BC` 59, `$C2` 19,
`$C5` 18, `$C3` 17, `$C4` 14, never `$B5`.  Every track starts `BF vv BD 00 ...` (volume, `$BD` = a track byte at +$12); drum tracks use instrument `$64` (per-note instrument mode) and
`$C1 xx` before each hit (a signed value stored at track+$19, probably a pitch offset).

**Track fields identified so far** (track = D040 + n*$3C): +0 flags (bit7 active, bit6 initialised, bit5 fresh = cold start pending, bit4 per-note instrument mode, bits 0-2 dirty flags pan/volume/pitch; `D019` is the working copy), +1 length counter, +2/3 stream pointer, +4/5 ROM bank, +6/7
sound id, +8 priority, +$0B note length, +$0C..$11 instrument record (copy of the 6 bytes from the instrument table; +$11 also holds the last opcode >= $BE), +$15 volume base
(command $BF), +$16 volume scale (fade / SetTrackParam 2), +$26 call depth, +$29 loop counter, output fields +$2C/$2D pitch, +$2E pan bits (NR51), +$2F volume.  Channel record fields: +0 flags (bit7
active), +1 priority, +2 owner marker (bit7 = effect), +4/5 owner track pointer, +6..$0C copy of the instrument bytes (+8 duty, +9 length, +A sweep), +$0C envelope counter, +$11 envelope/volume.  Everything
else is unexplained; the rest of the command handlers keep their generic names.

**Sound ids seen at call sites** (bc immediate before the stub call; `analysis` scan of all banks): effects (stub 20AC) $29 cursor move (0E 1A 1D 22 23 and 18 more banks), $2A/$2B (1F only:
move between top-menu icons), $2C confirm, $2E cancel, $2F-$48 various (2A 2C 2D 2F 4C 4E 55 57 67 68 6C 72 73 7F ...); music (stubs 20B2/20E8): 1 title, 2 top menu, 3 mail menu, 4-6 (2C 2D 2F 24 2A),
7 (25 28 2B 7C mailbox/compose), 8-$0A (67 68), $0B (27 70), $0C (23 26 2E), $0D (51), $0E (29), $0F (2A), $10 (22 23 mail-server menus), $11 (73), $12 (57), $13 (68), $14 (4E), $15 (5C error screen),
$16/$17 (6C), $18 (67), $1A (1A dictionary, 7F), $1B (0E logo), $1C (4E), $1D (50).  `SoundDrv_LoadSongHeader` accepts ids 1-$46 only.

## 8. Debug screens (banks 19, 1B) - never executed, no caller

* `19:4000` **DEBUG MODE** editor.  Its help text (`String_DebugFlags_Help`) reads '＝＝ DEBUG MODE ＝＝ / ↑↓:えらぶ ←→:カーソル A:へんこう / Sta:BIT←→DEC Sel/B:しゅうりょう'.  One entry: '【サインアップデバッグフラグ】' at SRAM 1:$B0BF (display modes BIT / DEC / hex, digit cursor, A toggles a bit or adds a
  place value).  Exit slides the window out and calls `4E:4795` and `68:49B6` (the SRAM checksum refresh routines of banks 4E/68, see `sram_layout.md`).
* `19:4980` **error-screen tester**: three hex values (kind, number hi, number lo) and A calls the error screen `5C:5150` (used by bank 65's error handlers: `a=kind, hl=number`);
  text 'A: エラー B+↑↓: しゅるい Sel: END ↑↓(←→): Number'.
* `1B:4040` **sound test**: a 16-bit id edited as four hex digits; A music, B effect, Start stop, Select end (see section 7).

All three use the same skeleton as the real screens (same `C0D4` clear, `48:48BB`, `00:0787` tile loads, `JoypadDispatch` table), the same palette block (`19:4940` = `1B:4000`) and a
full-width hex-digit string; their entries were removed from the retail menu flow, not from the ROM.  Status PROBABLE only (unexecuted code, unproven entry).

## 9. Hypotheses and open questions

* **How are the debug screens started?**  No `call`/`jp`/table word/far pointer to `19:4000`, `19:4980` or `1B:4040` exists; the hooks were removed like `48:48BB`.  A `B+SELECT+RIGHT` style hidden
  input (cf. `wHiddenModeFlag`, `boot_combos` found nothing) is not evidenced.
* **Sound engine details**: the meaning of commands `$BD`, `$C1`-`$C5`, `$CD` sub-commands, the exact channel-steal rule in `SoundDrv_StartNote`, track fields not listed above, header byte 5 (flags: in all 70 headers $FF = 'start all tracks'; the single-track branch `<4` of
  `SoundDrv_PlaySfx` is never taken by the data) and `Table_SoundDrv_Instruments` byte meanings.  `SoundDrv_StopAllSfx` (04:4414), `PlayMusicIfNotPlaying`, `ResumeMusic`, `GetActiveMasks`,
  `SetTrackParam`, `StartFadeOut`, `GetPlayingId` and the `$B5` loop are never executed: PROBABLE by code shape only.
* **Delete flows**: the semantic of result `B==2` (problem mail) and of the counters `D625-D631` is inferred from the loop structure and the hidden-button text; `Function_23_50CC/5137/54B1` (unexecuted)
  are guessed to be the 10-minute online-time warning dialog (`dynamic_tracing.md`: '通信時間がまもなく 10ぶんに なります このまま つづけますか?').  `wRam_C1D0/C1D1` (C1D0 = 1 in the confirm flows, 0 in check-and-delete, C1D1 = 0) and `wRam_C264` (1/2 = result screen variant) are shared with other flows.
* **22:5CD0-66D0** (2560 bytes).  *Retracted:* the first version of this note said this block belongs to the communication-progress scene of bank 26 and that its loader was unknown.  Wrong: `dataaccess.tsv` shows it read only in `mail_addressbook` / `addressbook_full` (+ monkeys), and four bank-2F HDMA loads use it (`2F:459A` hl=$5CD0 and `2F:45AC` hl=$60D0 in `AbookList_SetupScreen`, `2F:6FAE` hl=$61D0 and `2F:6FC0` hl=$65D0 in `AbookAddr_SetupScreen`, all with a=$22).  It is now `Gfx_AddrBook_TilesBank22`; only 22:5980-5CD0 (tilemap + two palettes) belongs to the bank-26 scene (`MailSession_InitScreen` 26:5168).
* **1A**: the page-view call (`4C:4F56`, a=2) and the bank-3F list layout are not exercised by any named scenario (only the monkey ones run `1A:4000`).
* **TopMenu_HandleDpad** stores `A` (= `hWRAMBank` after the sound call) into `wRam_C0E6` when going 'Up' from item 3, which looks like a compiler/assembler quirk of the original;
  the visible behaviour (return to the previous item) is what the trace shows.
* Rows kept HYPOTHESIS: `Function_22_48CD/4975/4A97/4AF7`, `Function_23_47BC/4864/4986/49E6` (dead h/m/s print), `Function_23_58C5/59DA/5FA3/60D1/669A/6799` (dead sprite counters),
  `Function_23_6D61/6E58`, `Function_23_50CC/5137/54B1`, `Function_04_415A`, `Data_1C_4016/401C`.

## 10. Names of other namers used in the evidence text

`Mail_OutboxIsEmpty` (27:41BC), `MailConnect_Screen` (27:41E3), `MailDisconnect_Screen` (27:4768), `MailSession_ShowCommError` (26:5067), `MailServerStatus_Screen` (29:44F6),
`Gfx_StartHDMAAtVBlank` (25:538A), `Mailbox_CountRecords` (25:4A90) come from `config/symbols/bank2[5-9].tsv`; `Ticker_Start` (48:42D4) from `analysis/naming/ram_g4.tsv`; also `Startup_Run` (65:4000), `ConnectDialog_Run` (57:4000), `CommErr_ShowScreen` (5C:5150), `Nav_*` (bank 7C),
`Joypad_*` (bank 7D), `Stat_EnableScrollSplit/DisableScrollSplit` (7F:7271/72B0), `Gfx_GdmaAtVBlankNoDi` (7F:72C2), `Sprites_SaveSlotsToBank3` (7F:624F).
The ROM0 stubs `00:20A0-20E8` are left to the ROM0 namer; the `SoundDrv_` names above describe their targets.  My RAM proposals for the sound engine are WRAM-bank-1 specific and can collide with
`ram_sdk.tsv` / `ram_g7.tsv` rows for the same D0xx addresses in other WRAM banks (mail library = WRAM bank 5, tile buffers = banks 2/3/6/7); the orchestrator has to keep the banked-name
policy of `ram_names_reconciliation.md`.  `wTimerASeconds/Minutes` (C2D5/C2D6) were proposed identically by g2 and g7, so g1 does not repeat them.

## 11. RAM proposals (`analysis/naming/ram_g1.tsv`)

38 rows: the sound-engine variables D005-D03F (WRAM bank 1), the arrays `wSoundDrv_Tracks` (D040, 8 x $3C) and `wSoundDrv_Channels` (D220, 4 x $18), and four SRAM names
(`sSram_MailMenuLastItem` A8B8, `sSram_TopMenuLastItem` A8B9, `sSram_TitleLastSelection` BF00 (all SRAM bank 1), `sSram_Bank0Page0Checksum/Page1Checksum` AFFE/BFFE (bank 0),
`sSram_Bank1BlockChecksum` A8D7, and the HYPOTHESIS `sSram_SignupDebugFlag` B0BF).  The screen-local variable block `C0D4-C1CF` is deliberately **not** named: the same addresses mean different things in every screen
(`C0E5` = selected item in 1F/1D, scroll offset in 1A, entry index in 19, low id byte in 1B; `C27C-C280` are the title state in 0E but other variables in 63/67/70).

## 12. Function lists

### Bank 1C - main program

| addr | name | status | summary |
|---|---|---|---|
| `1C:4000` | `Main_Run` | C | Endless main program: farcall Startup_Run (65:4000) once, then loops the title screen 0E:4000 and dispatches its result; entered by Boot at 00:0328 ... |
| `1C:4007` | `Main_TitleLoop` | C | Loop head after Startup_Run (65:4000): farcall 0E:4000 (title screen, returns A = 1 + chosen item) then call JumpTableInline with ... |
| `1C:4019` | `Main_TitleChoiceNone` | P | Result 0 of the title dispatch: jp Main_TitleLoop; 0E:4000 returns C27D+1 >= 1 so this entry looks unused (table word only, not executed) |
| `1C:401D` | `Main_TitleChoiceStart` | C | Title item 1 (Start): farcall Nav_TitleStart (7C:7B7C) (top menu flow: 1F:4000 top menu, mail menu 1D..., browser, help), then A=1 and back to ... |
| `1C:4028` | `Main_TitleChoiceSettings` | C | Title item 2 (mobile settings screen): farcall Nav_TitleMobileSettings (7C:7D1F) then A=1 and back to Main_TitleLoop; executed in title_settings, ... |

### Bank 0E - title screen

| addr | name | status | summary |
|---|---|---|---|
| `0E:4000` | `Title_Run` | C | Title screen (Mobile System GB logo, then title menu Start / mobile settings): A=0 on the first call plays the logo states, A!=0 starts at the title; ... |
| `0E:405F` | `Title_StateLoop` | C | Per-frame loop: Joypad_Update (7D:7BB7) poll, Title_DispatchState, 00:0956 sprite update, 00:044B wait VBlank; ends when state byte wRam_C27C==$FF, ... |
| `0E:4083` | `Title_DispatchState` | C | Jump-table dispatch on state wRam_C27C through Table_Title_States (jp hl); states 0-6 |
| `0E:40A2` | `Title_StateLoadLogo` | C | State 0: Title_LoadLogoScreen (Mobile System GB logo), palette fade 4F:42FF, plays sound id $1B via stub 00:20E8, clears frame counter wRam_C27E/F, ... |
| `0E:40CA` | `Title_StateLogoWait` | C | State 1: counts wRam_C27E/F up to 180 frames ($00B4) then state++; A or Start (hJoyPressedRepeat bit0/bit3) fades 4F:4370 and skips to state 3 |
| `0E:410C` | `Title_StateLogoFadeOut` | C | State 2: palette fade via 4F:43B8, state++ |
| `0E:411A` | `Title_StateLoadTitle` | C | State 3: reads last selection from SRAM bank 1 $BF00 into wRam_C27D, Title_LoadTitleScreen, fade-in 4F:42B4, plays sound id 1 (title music) via ... |
| `0E:417B` | `Title_StateMenu` | C | State 4: title menu; unless wRam_C280!=0 the idle timer wRam_C27E/F counts to $2A30 (10800 frames) then state 6; Up/Down toggle selection, A/Start ... |
| `0E:419F` | `Title_MenuHandleButtons` | C | State 4 button test on hJoyPressedRepeat: A (bit0) or Start (bit3) -> Title_MenuConfirm, Up (bit6) or Down (bit7) -> Title_MenuToggleSelection, else ... |
| `0E:41B3` | `Title_MenuTimeout` | P | Idle timer reached $2A30: sets state 6 (Title_StateTimeoutRestart); not executed in any trace |
| `0E:41BA` | `Title_MenuToggleSelection` | C | Up/Down pressed: resets the idle timer wRam_C27E/F, plays sound id $29 (stub 00:20AC), toggles wRam_C27D (xor 1), redraws highlight ... |
| `0E:41E6` | `Title_MenuConfirm` | C | A/Start pressed: plays sound id $2C via stub 00:20AC, state++ (state 5) |
| `0E:41FE` | `Title_StateExit` | C | State 5: fade out 4F:4370 and sets state $FF, ending Title_StateLoop (Title_Run then stores/returns the selection) |
| `0E:420A` | `Title_StateTimeoutRestart` | P | State 6 (entered only by Title_MenuTimeout): fade out 4F:4370 and state:=0 so the logo sequence restarts; never executed |
| `0E:4215` | `Title_LoadTitleScreen` | C | Loads the title screen: HDMA of 7 tile blocks (Gfx_Title_*), palettes to $D800/$D840, tilemap 5BC0 to $D000, two sprite objects (5FB0), highlight ... |
| `0E:4311` | `Title_DrawMenuHighlight` | C | Copies the 4x10 highlight tilemap (bc=$040A) of the selected item from Table_Title_HighlightTilemaps[wRam_C27D] to the tile buffer at $D185 (00:08EA) |
| `0E:4334` | `Title_PlaceCursor` | C | Moves sprite slot $DA10 (00:0A65) to the position of the selected item taken from Table_Title_CursorPositions[wRam_C27D] |
| `0E:434F` | `Title_LoadLogoScreen` | C | Loads the Mobile System GB logo screen: HDMA tiles 60A0/64A0, palette 6B70, tilemap 68A0; called by the first title state (first at frame 327; 35 of 41 scenarios) |

Data: `Table_Title_States` (4094), `Table_Title_HighlightTilemaps` (4330), `Table_Title_CursorPositions` (434B), `Gfx_Title_Tiles0` (43C0), `Gfx_Title_Tiles1` (47C0), `Gfx_Title_Tiles2` (4BC0), `Gfx_Title_Tiles3` (4DC0), `Gfx_Title_Tiles4` (4FC0), `Gfx_Title_Tiles5` (53C0), `Gfx_Title_Tiles6` (57C0), `Tilemap_Title_Screen` (5BC0), `Tilemap_Title_HighlightStart` (5E90), `Tilemap_Title_HighlightSettings` (5EE0), `Palette_Title_Bg` (5F30), `Palette_Title_Obj` (5F70), `Objects_Title` (5FB0), `Gfx_TitleLogo_Tiles0` (60A0), `Gfx_TitleLogo_Tiles1` (64A0), `Tilemap_TitleLogo_Screen` (68A0), `Palette_TitleLogo` (6B70)

### Bank 1F - top menu

| addr | name | status | summary |
|---|---|---|---|
| `1F:4000` | `TopMenu_Run` | C | Top menu (3 icons: mail / homepage / help; screenshot at frame 1792 of 'help'): loads gfx from bank 1E, initial selection read from SRAM 1:$A8B9, ... |
| `1F:41D1` | `TopMenu_Loop` | C | Per-frame loop: 00:0956 sprites, 00:044B wait VBlank, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, then call JoypadDispatch with Table_TopMenu_Buttons (A, ... |
| `1F:41F3` | `TopMenu_Idle` | C | No A/B/Select/Start: Ticker_Update (48:4223), TopMenu_UpdateCursorMove, D-pad handling (TopMenu_HandleDpad), TopMenu_AnimatePanel; a pending A press ... |
| `1F:4217` | `TopMenu_OnA` | C | A pressed: if the cursor is still moving (wRam_C0E2) remember it in wRam_C0E3, else play sound id $2C (stub 00:20AC), fade out, write the selection ... |
| `1F:425A` | `TopMenu_OnB` | C | B pressed: play sound id $2E (stub 00:20AC), fade out, write 0 to SRAM bank 1 $A8B9 (WriteByteFar (48:4616)) and return A=0 (leave the top menu) |
| `1F:4291` | `TopMenu_HandleDpad` | C | D-pad: Right -> item 2, Left -> item 1, Down -> item 3, Up (from item 3) -> previous item wRam_C0E6; plays sound $2A/$2B (stub 00:20AC) and starts ... |
| `1F:4325` | `TopMenu_SelectItem` | C | Sets wRam_C0E5=A, loads the cursor target (y,x) from Table_TopMenu_CursorTargets, TopMenu_StartCursorMove, sets wRam_C0E2 (moving) and calls ... |
| `1F:4351` | `TopMenu_LoadPanel` | C | Reloads the tilemap rectangle (bc=$1014 from bank 1E $40D7) and the item sprites (slots $DA40 etc.) for the selected item wRam_C0E5/C0E6 |
| `1F:43F7` | `TopMenu_InitItemSprites` | C | Creates the icon sprites of the selected item (objects from bank 1E table $656F, slots $DA10-$DA50) and places the cursor sprite at the item's target ... |
| `1F:44D5` | `TopMenu_AnimatePanel` | C | Every $1E frames swaps the animated icon tilemap of the selected item (bank 1E: mail 2 frames, homepage 5 frames, size $C6 each) via 00:08EA and ... |
| `1F:4561` | `TopMenu_UpdateCursorMove` | C | Per-frame cursor interpolation: wRam_C0E1 steps left, adds the 8.8 deltas wRam_C0DD-C0E0 to the cursor position wRam_C0D4/C0D6 (sprite slot $DA50); ... |
| `1F:45CA` | `TopMenu_StartCursorMove` | C | Computes \|dx\|,\|dy\| and direction flags (wRam_C10E) from the current cursor to the target wRam_C0DB/C0DC, step count wRam_C0E1 = (dx+dy)/8 and the ... |

### Bank 1D - mail menu

| addr | name | status | summary |
|---|---|---|---|
| `1D:4000` | `MailMenu_Run` | C | Mail menu (6 plates: send/receive, write mail, mailbox, address book, profile, mail server; screenshot 'mail_menu' at frame 16224): loads gfx, ... |
| `1D:4188` | `MailMenu_Loop` | C | Per-frame loop: 00:0956 sprites, 00:044B wait VBlank, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, call JoypadDispatch with Table_MailMenu_Buttons |
| `1D:41AA` | `MailMenu_Idle` | C | No A/B/Select/Start: Ticker_Update (48:4223), D-pad with key repeat (hJoyPressedRepeat & $F0) -> MailMenu_HandleDpad, MailMenu_AnimateIcon, loop |
| `1D:41BD` | `MailMenu_OnA` | C | A pressed: sound id $2C (stub 00:20AC), fade out (Palette_FadeOutWithTicker (48:46C6)/4460), write item wRam_C0E5 to SRAM bank 1 $A8B8 (WriteByteFar ... |
| `1D:41EC` | `MailMenu_OnB` | C | B pressed: sound id $2E, fade out, write 0 to SRAM 1:$A8B8, return A=0 (back to top menu, jump table entry 0 = ret) |
| `1D:4217` | `MailMenu_Ignore` | C | Select and Start entries of the JoypadDispatch table: jp MailMenu_Loop |
| `1D:421A` | `MailMenu_GetLabelIndexA` | C | Returns A=1 if the byte at SRAM bank 0 $A000 is 0, else 6: picks the text pair of item 2 (write-mail vs 'メールをかくにん' when a draft exists) |
| `1D:4229` | `MailMenu_HandleDpad` | C | Up (bit6): previous item (item 1 wraps to 6), Down (bit7): next item (6 wraps to 1); redraws plates, plays cursor sound id $29 |
| `1D:427A` | `MailMenu_AfterMove` | C | Plays sound id $29 (stub 00:20AC) and restarts the scrolling description ticker of the item via Ticker_Start (48:42D4) (string index at $43FA, item ... |
| `1D:42A0` | `MailMenu_GetLabelIndexB` | C | Duplicate of MailMenu_GetLabelIndexA (A=1 if SRAM 0:$A000 == 0 else 6); used by MailMenu_AfterMove |
| `1D:42AF` | `MailMenu_DrawItemNormal` | C | Draws plate of item wRam_C0E6 (the previously selected one) in normal style: 10-column rectangle from Tilemap_MailMenu_PlatesNormal at offset ... |
| `1D:42FE` | `MailMenu_GetPlateIndexA` | C | Returns A=1 if SRAM 0:$A000 == 0 else 7: plate graphic index for item 2 (normal plates) |
| `1D:4325` | `MailMenu_DrawItemSelected` | C | Draws the selected item wRam_C0E5 in highlighted style from Tilemap_MailMenu_PlatesSelected (same scheme as MailMenu_DrawItemNormal); called on entry ... |
| `1D:4374` | `MailMenu_GetPlateIndexB` | C | Duplicate of MailMenu_GetPlateIndexA for the selected plates (A=1 or 7) |
| `1D:439B` | `MailMenu_AnimateIcon` | C | Every $1E frames toggles wRam_C0E8 and copies the 6x8 mail icon frame (Tilemap_MailMenu_IconFrames $4C51 or $4C81) to $D0C1 (00:16A2), then sprites + ... |

Data: `Table_MailMenu_Buttons` (41A0), `Table_MailMenu_PlateBufferOffsets` (430D), `Data_MailMenu_PlateOffsets` (431D), `Table_MailMenu_SelectedBufferOffsets` (4383), `Data_MailMenu_SelectedPlateOffsets` (4393), `Data_MailMenu_StringIndexBank` (43FA), `Table_MailMenu_Strings` (43FB), `Table_MailMenu_StringsTail` (4413), `String_MailMenu_Items` (4417), `Tilemap_MailMenu_Screen` (45C1), `Tilemap_MailMenu_PlatesNormal` (4891), `Attrmap_MailMenu_PlatesNormal` (4981), `Tilemap_MailMenu_PlatesSelected` (4A71), `Attrmap_MailMenu_PlatesSelected` (4B61), `Tilemap_MailMenu_IconFrames` (4C51), `Attrmap_MailMenu_IconFrames` (4CB1), `Gfx_MailMenu_Tiles0` (4D20), `Gfx_MailMenu_Tiles1` (4EB0), `Gfx_MailMenu_Tiles2` (52B0), `Gfx_MailMenu_Tiles3` (56B0), `Gfx_MailMenu_Tiles4` (5AB0), `Gfx_MailMenu_Tiles5` (5E30), `Palette_MailMenu_Bg` (6230), `Palette_MailMenu_Obj` (6270), `Data_MailMenu_ObjectRecords` (6320), `Table_MailMenu_Objects` (63B6)

### Bank 1A - mobile dictionary

| addr | name | status | summary |
|---|---|---|---|
| `1A:4000` | `MobileDict_Run` | C | Mobile dictionary (モバイルじてん) index: 11 kana-row tabs, 5 entries per page (Table_MobileDict_Categories); B returns 0, A opens the entry page (id from ... |
| `1A:4018` | `MobileDict_Redraw` | C | Re-entry point after an entry page was viewed (jp from MobileDict_OnA): re-initialises LCD/window and reloads tiles, palettes, tilemap and tab ... |
| `1A:414B` | `MobileDict_Loop` | C | Per-frame loop: 00:0956, 00:044B, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, call JoypadDispatch with Table_MobileDict_Buttons; plays sound id $1A via ... |
| `1A:416D` | `MobileDict_Idle` | C | No A/B/Select/Start: D-pad with repeat (hJoyPressedRepeat & $F0) handled by MobileDict_HandleDpad, then loop |
| `1A:4177` | `MobileDict_OnA` | C | A pressed: sound id $2C, fade out (4F:4370), reads the page id byte from the bank-3F list of category wRam_C0D4 at row wRam_C0D6 + scroll wRam_C0E5 ... |
| `1A:41CA` | `MobileDict_OnB` | C | B pressed: sound id $2E via stub 00:20AC, fade out, return A=0 (cancel) |
| `1A:41E5` | `MobileDict_HandleDpad` | C | Up/Down move the row cursor wRam_C0D6 (1-5) and scroll offset wRam_C0E5; Right/Left change category wRam_C0D4 (1-11, wraps); each move plays sound id ... |
| `1A:41F8` | `MobileDict_CursorUp` | C | Up: row cursor wRam_C0D6-1 with sound id $29 and MobileDict_DrawRowHighlight; at the top row falls to MobileDict_ScrollUp |
| `1A:4215` | `MobileDict_ScrollUp` | P | Cursor at row 1: scroll offset wRam_C0E5-1 (if > 0), sound $29, MobileDict_LoadPage + DrawRowHighlight + UpdateTabSprites; only the offset==0 early return ran in traces |
| `1A:4238` | `MobileDict_CursorDown` | C | Down: row cursor +1 up to 5 and up to the entry count wRam_C0D8, sound $29; at row 5 falls to MobileDict_ScrollDown; returns at the last entry |
| `1A:4263` | `MobileDict_ScrollDown` | P | Cursor at row 5: scroll offset wRam_C0E5+1, sound $29, reload page, highlight and tab sprites |
| `1A:4281` | `MobileDict_NextCategory` | C | Right: category wRam_C0D4+1 (11 wraps to 1), row 1, scroll 0, reload page, sound $29 |
| `1A:42B0` | `MobileDict_PrevCategory` | C | Left: category wRam_C0D4-1 (1 wraps to 11), row 1, scroll 0, reload page, sound $29 |
| `1A:42DE` | `MobileDict_DrawRowHighlight` | C | Copies the 5-row entry text buffer ($D4A1) to VRAM tiles and highlights the row wRam_C0D6 (00:091C, bc=$0A10 / $0210) |
| `1A:4317` | `MobileDict_UpdateTabSprites` | C | Places the category tab marker (slot $DA40, x from Table_MobileDict_TabPositions[wRam_C0D4]) and the up/down scroll arrows (slots $DA20/$DA30) ... |
| `1A:4391` | `MobileDict_LoadPage` | C | Clears the text tile buffer (WRAM bank 2) and renders up to 5 entry names of category wRam_C0D4 from offset wRam_C0E5 with TextTiles_RenderGridRows ... |

Data: `Table_MobileDict_Buttons` (4163), `Table_MobileDict_TabPositions` (437B), `Table_MobileDict_Categories` (4439), `Data_MobileDict_Cat01Count` (444F), `Table_MobileDict_Cat01Strings` (4450), `Data_MobileDict_Cat02Count` (44C7), `Table_MobileDict_Cat02Strings` (44C8), `Data_MobileDict_Cat03Count` (44E0), `Table_MobileDict_Cat03Strings` (44E1), `Data_MobileDict_Cat04Count` (453F), `Table_MobileDict_Cat04Strings` (4540), `Data_MobileDict_Cat05Count` (456B), `Table_MobileDict_Cat05Strings` (456C), `Data_MobileDict_Cat06Count` (45A8), `Table_MobileDict_Cat06Strings` (45A9), `Data_MobileDict_Cat07Count` (4608), `Table_MobileDict_Cat07Strings` (4609), `Data_MobileDict_Cat08Count` (46F9), `Table_MobileDict_Cat08Strings` (46FA), `Data_MobileDict_Cat09Count` (4705), `Table_MobileDict_Cat09Strings` (4706), `Data_MobileDict_Cat10Count` (471E), `Table_MobileDict_Cat10Strings` (471F), `Data_MobileDict_Cat11Count` (4736), `Table_MobileDict_Cat11Strings` (4737), `Tilemap_MobileDict_Screen` (47B5), `Gfx_MobileDict_Tiles0` (4A90), `Gfx_MobileDict_Tiles1` (4C90), `Gfx_MobileDict_Tiles2` (5090), `Palette_MobileDict_Bg` (5390), `Palette_MobileDict_Obj` (53D0), `Objects_MobileDict` (55A0)

### Bank 23 - mail-server delete menu and transactions

| addr | name | status | summary |
|---|---|---|---|
| `23:4000` | `MailSrvDel_MenuRun` | C | Mail-server delete menu (title 'メールのけしかたをえらんでね', 2 buttons: check then delete / delete all); sets split line D724=$0B, Stat_EnableScrollSplit; from ... |
| `23:4076` | `MailSrvDel_MenuLoop` | C | Menu loop: 00:0956, Joypad_Update (7D:7BB7), A (sound id $2C) -> button C=1: MailSrvDel_CheckAndDelete, C=0: MailSrvDel_DeleteAll; B (sound $2E) -> ... |
| `23:4161` | `MailSrvDel_MenuSelect` | C | Redraws the menu for button C (1: check then delete = tilemap bank 28 $6860, 0: delete all = $6B30), cursor sprite (bank 28 $6E90) and the button ... |
| `23:41DC` | `MailSrvDel_MenuInit` | C | Loads the menu screen (bank 28 gfx/palettes $6E00/$6E40, tile blocks $5F20/$6150/$6550/$67E0, objects $6E90), the tilemap and description text for ... |
| `23:42F4` | `MailSrvDel_MenuStart` | C | Second half of MailSrvDel_MenuInit: Stat_DisableScrollSplit (7F:72B0), palette fade 4F:42B4, split line D724=$15 + Stat_EnableScrollSplit (7F:7271), ... |
| `23:433C` | `MailSrvDel_ShowDescDeleteAll` | C | Renders String_MailSrvDel_DescDeleteAll with TextTiles_RenderLine (48:403E) and uploads text tiles (MailSrvDel_UploadTextTiles); description of the ... |
| `23:43C4` | `MailSrvDel_ShowDescCheck` | C | Renders String_MailSrvDel_DescCheck with TextTiles_RenderLine (48:403E) and uploads text tiles; description of the 'check then delete' button |
| `23:4471` | `MailSrvDel_Confirm` | C | Confirmation dialog (yes/no; default no) 'このしょりをおこなうと サーバにある すべてのメールが きえてしまいます よろしいですか？'; returns A=0 for yes, $FF for no/B; same routine as 22:4582 |
| `23:46CD` | `MailSrvDel_ConfirmSelect` | C | Moves the yes/no cursor sprite (objects $6E80 of bank 28) to the yes ($6828, C=0) or no ($6858, C=1) position |
| `23:478E` | `MailSrvDel_UploadTextTiles` | C | Copies the two text tile buffers of WRAM bank 2 ($D000, $D400; 63 tiles each) to VRAM $9000/$9400 through 25:538A (Gfx_StartHDMAAtVBlank) |
| `23:47BC` | `Function_23_47BC` | H | Dead routine after the ret at 23:47BB (entry unproven): prints wRam_C2D7/C2D6/C2D5 as decimal numbers via TextTiles_RenderLine (48:403E) and 23:49E6; ... |
| `23:4864` | `Function_23_4864` | H | Helper of Function_23_47BC: right-aligned decimal string of HL into $D524 (template '０００００' at 23:497B, Divide16 by 10000/1000/100/10), digit count ... |
| `23:4986` | `Function_23_4986` | H | Helper of Function_23_47BC: tests HL against 10000/1000/100/10; BC=0 when HL >= 10, BC=$10 and A=1 otherwise; twin of 22:4A97 |
| `23:49E6` | `Function_23_49E6` | H | Uploads the decimal text tiles $D800.. of WRAM bank 2 to VRAM $8800 through Gfx_GdmaAtVBlankNoDi (7F:72C2) (c=$27); tail of Function_23_47BC |
| `23:4A06` | `MailSrvDel_DeleteAll` | C | Button 0 action: MailSrvDel_Confirm, connection-cost dialog 57:4000 ('つうしんせつぞくします'), timer reset 51:4245, MailConnect_Screen 27:41E3 (A=0 ok, $20 ... |
| `23:4A1E` | `MailSrvDel_DeleteAll_Confirm` | C | Loop head: MailSrvDel_Confirm; A=$FF (no/B) returns $FF to the menu, A=0 (yes) continues with the connection sequence ConnectDialog_Run (57:4000) ... |
| `23:4B51` | `MailSrvDel_CheckAndDelete` | C | Button 1 action (no delete confirmation): cost dialog 57:4000, timer reset 51:4245, MailConnect_Screen 27:41E3, then 2E:4000 (per-mail check and ... |
| `23:4C94` | `MailSrvDel_DeleteAllRun` | C | Delete-all transaction: progress screen 55C3, login 54:485C (API $1E), pass 1 counts problem mails (54:4914/4969 = API $28, result B==2), pass 2: per ... |
| `23:4CF9` | `MailSrvDel_DeleteAllRun_WaitLogin` | C | Per-frame loop while the login request (54:485C) runs: sprites, Joypad_Update (7D:7BB7), MailSrvDel_DrawElapsedTime, B held -> MailSrvDel_Cancelled, ... |
| `23:4D2B` | `MailSrvDel_DeleteAllRun_GotMailCount` | C | Login finished: HL = number of mails on the server saved in DE; zero mails -> MailSrvDel_DeleteAllRun_CheckDone |
| `23:4D39` | `MailSrvDel_DeleteAllRun_CheckLoop` | C | Pass 1 loop head (bc = problem mails counted, hl = current mail number): connection-time check (wRam_C26E/C26F, dialog 23:50CC), progress display, ... |
| `23:4DA0` | `MailSrvDel_DeleteAllRun_CheckPoll` | C | Pass 1 poll loop of the request result (54:4969 until it is not 1); B held -> MailSrvDel_Cancelled; result B==2 increments the problem-mail count BC |
| `23:4DFB` | `MailSrvDel_DeleteAllRun_CheckDone` | C | Pass 1 finished: D62F = problem mails, D629 = mails left to delete (total - problems); nothing left -> message 6D8C ('no mail') shown for $78 frames ... |
| `23:4EB7` | `MailSrvDel_DeleteAllRun_DeleteLoop` | C | Pass 2 loop head (hl = mail number): connection-time check, progress text MailSrvDel_DrawProgressText (56A1), TOP request 54:4914 again for the mail |
| `23:4F4B` | `MailSrvDel_DeleteAllRun_TopPoll` | C | Pass 2 poll of the TOP result: result B==2 (problem mail) counts it in D631 and skips to the loop tail, otherwise falls to ... |
| `23:4F9C` | `MailSrvDel_DeleteAllRun_SendDele` | C | Waits $3C frames, then requests DELE of the mail with 54:5386 (API $26) |
| `23:4FBC` | `MailSrvDel_DeleteAllRun_DelePoll` | C | Polls the DELE result with 54:53BB; B held -> decrement D629 and MailSrvDel_Cancelled; 1 = busy; $FF = error (stores state, returns $80); done -> ... |
| `23:5002` | `MailSrvDel_DeleteAllRun_Error` | P | API error path: saves the current mail number into D627 and adjusts D629, calls MailSession_ShowCommError (26:5067) (error handling) and returns A=$80 |
| `23:5063` | `MailSrvDel_DeleteAllRun_NextMail` | C | Loop tail: DE (mails left) != 0 -> MailSrvDel_DeleteAllRun_DeleteLoop; else clears the counters, shows MailSrvDel_MsgAllDeleted, waits $78 frames (A ... |
| `23:50CC` | `Function_23_50CC` | H | Unexecuted: called when the connection-time check (wRam_C26E/C26F) fires: saves sprites (7F:624F), fade, dialog 50:4000 via 7F:6218 ($FF = stop -> ... |
| `23:5137` | `Function_23_5137` | H | Unexecuted twin of Function_23_50CC in the second pass of MailSrvDel_DeleteAllRun (also redraws MailSrvDel_MsgReading); probable online-time warning ... |
| `23:51C7` | `MailSrvDel_DeleteCompletelyRun` | C | Hidden 'delete completely' transaction: login, then DELE (54:5386/53BB) for every mail with no TOP/problem-mail check, so problem mail is deleted too ... |
| `23:522C` | `MailSrvDel_DeleteCompletelyRun_WaitLogin` | C | Same as MailSrvDel_DeleteAllRun_WaitLogin for the hidden transaction (polls the login result 54:489B) |
| `23:525E` | `MailSrvDel_DeleteCompletelyRun_GotMailCount` | C | Login finished: DE = mail count; sets the 'problem mails' count DE:=0 at 23:5261 (no check pass) and jumps into the shared counter setup |
| `23:5324` | `MailSrvDel_DeleteCompletelyRun_DeleteLoop` | C | Loop head of the hidden transaction: time-limit check, progress text (56A1), then DELE request 54:5386 directly (no TOP request) |
| `23:53A1` | `MailSrvDel_DeleteCompletelyRun_DelePoll` | C | Polls the DELE result (54:53BB); B held cancels (MailSrvDel_Cancelled), $FF = error, otherwise counters updated |
| `23:5424` | `MailSrvDel_DeleteCompletelyRun_NextMail` | C | Loop tail of the hidden transaction (twin of MailSrvDel_DeleteAllRun_NextMail) |
| `23:54B1` | `Function_23_54B1` | H | Unexecuted twin of Function_23_50CC used by MailSrvDel_DeleteCompletelyRun; probable online-time warning dialog |
| `23:553D` | `MailSrvDel_Cancelled` | P | B pressed during the delete transaction: restores screen state, shows the blank message (6E14), animates $B4 frames and returns A=$80; jumped to from ... |
| `23:55C3` | `MailSrvDel_ProgressInit` | C | Loads the progress screen of the delete transactions (bank 23 gfx $6FE0/$73E0/$74E0, palettes $7910/$7950, tilemap $7640), clears counters, fade in ... |
| `23:56A1` | `MailSrvDel_DrawProgressText` | C | Draws the current-mail counter (HL minus wRam D631) as decimal number plus String_MailSrvDel_ProgressText ('N通目をチェックしています' = checking mail number N) ... |
| `23:56F0` | `MailSrvDel_FormatNumber` | C | Builds the right-aligned full-width decimal string of HL in $D524 (template '００００００' at 23:581E) with successive Divide16 by 10000/1000/100/10; ... |
| `23:5829` | `MailSrvDel_NumberTileOffset` | C | Tests HL against 10000/1000/100/10 and returns BC = tile buffer offset ($D010/$D020/$D030) for the number's first digit; used by ... |
| `23:5889` | `MailSrvDel_UploadNumberTiles` | C | Copies the text tile buffer $D000.. of WRAM bank 2 to VRAM $9000 (Gfx_GdmaAtVBlankNoDi (7F:72C2), c=$27) |
| `23:58C4` | `SpriteCounter_StubA` | P | First byte is a $C9 (ret): the function was disabled by patching; callers in this bank and in bank 2E call it with A=0, HL=counter; the dead body at ... |
| `23:58C5` | `Function_23_58C5` | H | Dead body of SpriteCounter_StubA: HL := HL - word at $D631, Divide16 by 10000/1000/100/10 and one digit sprite per place (59DA/5B02/5C2A/5D52/5E7A); ... |
| `23:59DA` | `Function_23_59DA` | H | Dead: draws digit A (0-9) as sprite object (00:0A82, table $7990+16*A, slot $DA10) at position $5A2F; first of five digit-place routines of the ... |
| `23:5FA2` | `SpriteCounter_StubB` | P | First byte is a $C9 (ret): disabled twin of SpriteCounter_StubA called with A=$FF and HL=total; the dead body at 5FA3 places 5 digit sprites; also ... |
| `23:5FA3` | `Function_23_5FA3` | H | Dead body of SpriteCounter_StubB (5 x ld de,$D048 ; ld hl,$DAxx ; call 00:0A65 sprite slot writes, then Divide16 digit split); never reached |
| `23:60D1` | `Function_23_60D1` | H | Dead: digit-A sprite routine of the sprite counter B (object table $7990.., slot $DA20..) |
| `23:6699` | `SpriteCounter_StubC` | P | First byte is a $C9 (ret): disabled third counter routine, called only from bank 2E (2E:4298/43AF/4611/477E); dead body 669A starts push hl, push af, ... |
| `23:669A` | `Function_23_669A` | H | Dead body of SpriteCounter_StubC (twin of the longer 5FA3 body) |
| `23:6799` | `Function_23_6799` | H | Dead: digit-A sprite routine of the sprite counter C |
| `23:6D61` | `Function_23_6D61` | H | Dead routine (entry unproven): fills WRAM bank 7 $D1E0.. with ascending tile ids $14..$27 (20 bytes) |
| `23:6D8C` | `MailSrvDel_MsgNoMail` | P | Shows the message String_MailSrvDel_MsgNoMail ('メールはありませんでした' = there was no mail) via TextTiles_RenderLine (48:403E) and ... |
| `23:6DD0` | `MailSrvDel_MsgAllDeleted` | C | Shows String_MailSrvDel_MsgAllDeleted ('すべてのメールをけしました' = all mail was deleted) after the delete loop finished |
| `23:6E14` | `MailSrvDel_MsgBlank` | P | Shows a blank message line (20 ideographic spaces) to clear the message area; used by MailSrvDel_Cancelled |
| `23:6E58` | `Function_23_6E58` | H | Head of the twin of MailSrvDel_MsgBlank showing String_23_6E73 ('キャンセルしました' = cancelled); falls into 6E68; no caller |
| `23:6E9C` | `MailSrvDel_MsgReading` | C | Shows String_MailSrvDel_MsgReading ('メールをよみこんでいます' = reading mail) at the start of a transaction |
| `23:6EE0` | `MailSrvDel_UploadMessageTiles` | C | Copies the message text tiles $D000.. of WRAM bank 2 to VRAM $9000 (Gfx_GdmaAtVBlankNoDi (7F:72C2), c=$27); tail of the message routines |
| `23:6F00` | `MailSrvDel_DrawElapsedTime` | C | Per-frame 'MM:SS' communication timer display: if wRam_C2D5 (seconds) changed since the cached wRam D624, writes 4 digit tile ids ($40+digit) for ... |

Data: `String_MailSrvDel_DescDeleteAll` (4357), `String_MailSrvDel_DescCheck` (4404), `String_MailSrvDel_Confirm` (470A), `String_MailSrvDel_NumberTemplate` (581E), `String_MailSrvDel_ProgressText` (58A9), `String_MailSrvDel_MsgNoMail` (6DA7), `String_MailSrvDel_MsgAllDeleted` (6DEB), `String_MailSrvDel_MsgBlank` (6E2F), `String_MailSrvDel_MsgCancelled` (6E73), `String_MailSrvDel_MsgReading` (6EB7), `Gfx_MailSrvDelProgress_Tiles0` (6FE0), `Gfx_MailSrvDelProgress_Tiles1` (73E0), `Gfx_MailSrvDelProgress_Tiles2` (74E0), `Tilemap_MailSrvDelProgress_Screen` (7640), `Palette_MailSrvDelProgress_Bg` (7910), `Palette_MailSrvDelProgress_Obj` (7950), `Table_SpriteCounter_Digits` (7990), `Table_MailSrvDel_ProgressObject` (7AD0)

### Bank 22 - hidden delete menu and SRAM library

| addr | name | status | summary |
|---|---|---|---|
| `22:4000` | `MailSrvDelHidden_MenuRun` | C | Hidden variant of the mail-server delete menu (3 buttons: check then delete, delete all, delete completely); from 7C:7D0C when SELECT+LEFT is held in ... |
| `22:4076` | `MailSrvDelHidden_MenuLoop` | C | Menu loop: 00:0956, Joypad_Update (7D:7BB7); A (sound $2C) dispatches on button index C: 1 -> CheckAndDelete, 2 -> DeleteCompletely, 0 -> DeleteAll; ... |
| `22:4173` | `MailSrvDelHidden_MenuSelect` | C | Redraws the menu for selected button C (0/1/2): tilemap 5110 / 53E0 / 56B0 to $D000, cursor sprite from bank 28 objects ($6E90), then its description ... |
| `22:422D` | `MailSrvDelHidden_MenuInit` | C | Loads the menu screen (bank 28 gfx, palettes $6E00/$6E40, tile blocks, objects $6E90), the tilemap and description text for button C, then falls into ... |
| `22:437D` | `MailSrvDelHidden_MenuStart` | C | Second half of MailSrvDelHidden_MenuInit: Stat_DisableScrollSplit (7F:72B0), palette fade 4F:42B4, split line D724=$15 + Stat_EnableScrollSplit ... |
| `22:43C5` | `MailSrvDelHidden_ShowDescDeleteAll` | P | Renders String_22_43E0 ('メールサーバにのこっているすべてのメールを、じどうでぜんぶけします じょうほうはたしかめられません') with TextTiles_RenderLine (48:403E) and uploads text tiles (489F); ... |
| `22:444D` | `MailSrvDelHidden_ShowDescCheck` | C | Renders String_22_448D (description of button 1, check then delete) with TextTiles_RenderLine (48:403E) and uploads the text tiles (489F) |
| `22:44FA` | `MailSrvDelHidden_ShowDescDeleteCompletely` | C | Renders String_22_4515 (description of the hidden button 2) with TextTiles_RenderLine (48:403E) and uploads the text tiles (489F); executed in ... |
| `22:4582` | `MailSrvDelHidden_Confirm` | C | Confirmation dialog 'このしょりをおこなうと サーバにある すべてのメールが きえてしまいます よろしいですか？' with yes/no buttons; returns A=0 (yes, A pressed on yes) or $FF (no / B); ... |
| `22:47DE` | `MailSrvDelHidden_ConfirmSelect` | P | Moves the yes/no cursor sprite (slot $DA10, objects $6E80) to the yes position ($6828, C=0) or the no position ($6858, C=1; default selection) |
| `22:489F` | `MailSrvDelHidden_UploadTextTiles` | C | Copies the two text tile buffers of WRAM bank 2 ($D000, $D400; 63 tiles each) to VRAM $9000/$9400 through 25:538A (Gfx_StartHDMAAtVBlank) |
| `22:48CD` | `Function_22_48CD` | H | Unreferenced (entry unproven) routine that prints three numbers read from wRam_C2D7/C2D6/C2D5 as decimal text with 48:403E (hours/minutes/seconds of ... |
| `22:4975` | `Function_22_4975` | H | Helper of Function_22_48CD: builds a right-aligned decimal string of HL into $D524 (starting from '０００００' template 22:4A8C) with successive Divide16 ... |
| `22:4A97` | `Function_22_4A97` | H | Helper of Function_22_48CD: tests HL against 10000/1000/100/10 (repeated Divide16): BC=0 when HL >= 10, BC=$10 and A=1 otherwise; twin of 23:4986 |
| `22:4AF7` | `Function_22_4AF7` | H | Uploads the decimal text tiles D800.. of WRAM bank 2 to VRAM $8800 through Gfx_GdmaAtVBlankNoDi (7F:72C2) (c=$27); tail of Function_22_48CD |
| `22:4B17` | `MailSrvDelHidden_DeleteAll` | P | Button 0 action (delete all mail automatically): MailSrvDelHidden_Confirm, cost dialog ConnectDialog_Run (57:4000), MailConnect_Screen 27:41E3, then ... |
| `22:4B2F` | `MailSrvDelHidden_DeleteAll_Confirm` | P | Loop head of button 0: MailSrvDelHidden_Confirm, $FF (no/B) returns to the menu, otherwise cost dialog ConnectDialog_Run (57:4000) and the connection ... |
| `22:4C62` | `MailSrvDelHidden_DeleteCompletely` | C | Hidden button 2 action ('かんぜんにけす'): MailSrvDelHidden_Confirm, cost dialog ConnectDialog_Run (57:4000), MailConnect_Screen 27:41E3, then the unchecked ... |
| `22:4C7A` | `MailSrvDelHidden_DeleteCompletely_Confirm` | C | Loop head of hidden button 2: MailSrvDelHidden_Confirm, $FF returns to the menu, otherwise cost dialog ConnectDialog_Run (57:4000) (b=$FF cancel ... |
| `22:4DAD` | `MailSrvDelHidden_CheckAndDelete` | P | Button 1 action (check then delete): cost dialog ConnectDialog_Run (57:4000), MailConnect_Screen 27:41E3, then MailServerMgr_Run (2E:4000) (per-mail ... |
| `22:4EF0` | `SramCheck_Bank0PageSum` | C | A bit0 = page: sums the first $FFE bytes of SRAM bank 0 page $A000 or $B000 into DE (16-bit additive) and returns HL = stored checksum word at ... |
| `22:4F24` | `SramCheck_Bank0StorePageSum` | C | Stores DE at page+$FFE/$FFF (low byte first) of SRAM bank 0 page A bit0 ($AFFE/$BFFE) |
| `22:4F46` | `SramCheck_CompareDEHL` | C | Compares HL with DE: A=0 if equal, A=$FF if different (duplicate at 22:5093) |
| `22:4F53` | `SramCheck_Bank0ClearPage` | C | Zero-fills the $1000 bytes of SRAM bank 0 page A bit0 ($A000 or $B000) |
| `22:4F7B` | `SramCheck_Bank0CopyPage` | C | Copies the $1000-byte SRAM bank 0 page A bit0 to the other page (destination high byte = source xor $10): page 0 -> mirror page 1 or back |
| `22:4FA9` | `SramCheck_VerifyAndRepairAll` | C | Save check: page 0 ok -> mirror to page 1; else page 1 ok -> restore page 0; else clear both; then bank 1 block check (5035/5093, 50A0 clears if bad) ... |
| `22:4FCF` | `SramCheck_RestorePage0` | P | Page 0 bad but page 1 good: copy page 1 over page 0 (22:4F7B with A=1); not executed |
| `22:4FD6` | `SramCheck_MirrorPage0` | C | Page 0 good: copy page 0 over page 1 (22:4F7B with A=0) |
| `22:4FF6` | `SramCheck_Bank0Status` | C | Returns A=1 if SRAM bank 0 page 0 checksum is good, 0 if only page 1 is good, $FF if both are bad (no repair); called by Startup_VerifySaveData ... |
| `22:501D` | `SramCheck_Bank0Commit` | C | After bank 0 data was modified: sums page 0, stores the checksum at $AFFE and copies page 0 to the mirror page 1; called from banks 25/2A/2B/2D/54 ... |
| `22:5035` | `SramCheck_Bank1BlockSum` | C | Sums SRAM bank 1 $A000-$A683 and $A69D-$A87C into DE and returns HL = stored checksum word at $A8D7 (docs/research/sram_layout.md scheme 1) |
| `22:5077` | `SramCheck_Bank1StoreSum` | C | Stores DE as the SRAM bank 1 block checksum at $A8D7/$A8D8 |
| `22:5093` | `SramCheck_CompareDEHL2` | C | Duplicate of SramCheck_CompareDEHL (A=0 equal, $FF different) used for the bank 1 checksum |
| `22:50A0` | `SramCheck_Bank1ClearBlock` | C | Zero-fills SRAM bank 1 $A000-$A683 and $A69D-$A87C (invalid checksum reset) |
| `22:50FC` | `SramCheck_Bank1Commit` | C | SramCheck_Bank1BlockSum then SramCheck_Bank1StoreSum: refresh the bank 1 block checksum after edits; called from banks 24 and 2A |

Data: `String_MailSrvDelHidden_DescDeleteAll` (43E0), `String_MailSrvDelHidden_DescCheck` (448D), `String_MailSrvDelHidden_DescDeleteCompletely` (4515), `String_MailSrvDelHidden_Confirm` (481B), `Tilemap_MailSrvDelHidden_Button1` (5110), `Tilemap_MailSrvDelHidden_Button0` (53E0), `Tilemap_MailSrvDelHidden_Button2` (56B0), `Tilemap_CommProgress_Screen` (5980), `Palette_CommProgress_Bg` (5C50), `Palette_CommProgress_Obj` (5C90), `Gfx_AddrBook_TilesBank22` (5CD0)

### Bank 19 - debug screens

| addr | name | status | summary |
|---|---|---|---|
| `19:4000` | `DebugFlags_Run` | P | Unreferenced 'DEBUG MODE' screen (String_DebugFlags_Help: up/down choose, left/right cursor, A change, Start BIT<->DEC, Sel/B end): edits the sign-up ... |
| `19:4199` | `DebugFlags_Loop` | P | Per-frame loop: 00:0956, 00:044B, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, call JoypadDispatch with Table_DebugFlags_Buttons |
| `19:41BB` | `DebugFlags_Idle` | P | No button: DebugFlags_PlaceCursor, DebugFlags_UpdateHoldTimer, D-pad with repeat (hJoyPressedRepeat & $F0) -> DebugFlags_HandleDpad |
| `19:41CB` | `DebugFlags_OnA` | P | A pressed ('Change'): BIT mode xors the selected bit (mask $8000>>wRam_C0D4) into the 16-bit value; DEC mode adds the place value 10^k of the ... |
| `19:42A1` | `DebugFlags_Exit` | P | B/Select: slide window out (DebugFlags_SlideOut), fade out 4F:4370, then 4E:4795 and 68:49B6 (SRAM checksum refresh routines of banks 4E/68) and ... |
| `19:42B7` | `DebugFlags_OnStart` | P | Start pressed ('BIT<->DEC'): cycles display mode wRam_C0D8 (1 = BIT, 2 = DEC) and re-places the cursor sprite / digit index wRam_C0D4 |
| `19:4321` | `DebugFlags_EntryHasHighByte` | P | Returns NZ when the second address word of entry wRam_C0E5 in Table_DebugFlags_Entries is non-zero (value has a high byte); duplicated at 19:43D7 |
| `19:4333` | `DebugFlags_HandleDpad` | P | Up/Down change entry wRam_C0E5, Left/Right move the digit/bit cursor wRam_C0D4 (0-4 in DEC mode, 0-15 in BIT mode) |
| `19:43D7` | `DebugFlags_EntryHasHighByte2` | P | Duplicate of DebugFlags_EntryHasHighByte |
| `19:43E9` | `DebugFlags_LoadHelpText` | P | Renders String_DebugFlags_Help (TextTiles_RenderGrid (48:40A9), text to tiles in WRAM bank 3) and a cursor glyph to VRAM $8800/$8C00/$9000 and $8000 |
| `19:4532` | `DebugFlags_DrawEntryName` | P | Draws the title string of entry wRam_C0E5 (pointer table at $4912, e.g. '【サインアップデバッグフラグ】') into VRAM $9400 via TextTiles_RenderGrid (48:40A9), then ... |
| `19:458A` | `DebugFlags_DrawValue` | P | Renders the value of the entry as full-width characters from String_DebugFlags_Chars: BIT mode 8/16 x '０/１', DEC mode a 5-digit decimal, otherwise ... |
| `19:47ED` | `DebugFlags_PlaceCursor` | P | Moves the cursor sprite (WRAM bank 7, wSpriteSlots+17) to x = 8*cursor+$10 (BIT mode) or 8*cursor+$48 (DEC mode) |
| `19:482B` | `DebugFlags_SlideIn` | P | Slides the window layer in: wRam_C0E5 goes $99 down to 0 in steps that shrink from $10 to 1, written to rWY each frame |
| `19:4858` | `DebugFlags_SlideOut` | P | Slides the window layer out: wRam_C0E5 from 0 up to $99 written to rWY each frame (inverse of DebugFlags_SlideIn) |
| `19:4885` | `DebugFlags_UpdateHoldTimer` | P | If hJoyHeld changed resets wRam_C0E7, else increments it (saturating): auto-repeat timer (4/16-bit steps after $3C frames) |
| `19:48A0` | `DebugFlags_ReadValue` | P | Reads the 16-bit value of the entry through ReadByteFar (00:1620) from SRAM bank 1: B = byte at second pointer (0 if none), C = byte at first pointer ... |
| `19:48D5` | `DebugFlags_WriteValue` | P | Writes D to the second and E to the first pointer of the entry through WriteByteFar (48:4616) (SRAM bank 1); the inverse of DebugFlags_ReadValue |
| `19:4980` | `Debug_ErrorScreenTest` | P | Unreferenced debug screen: hex-edits three values (kind, number hi/lo) and on A calls the error screen 5C:5150 (used by bank 65 error handlers); text ... |
| `19:4AEB` | `DebugErrorTest_Loop` | P | Per-frame loop: 00:044B, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, call JoypadDispatch with Table_DebugErrorTest_Buttons |
| `19:4B07` | `DebugErrorTest_Idle` | P | DebugErrorTest_UpdateHoldTimer then D-pad handling DebugErrorTest_HandleDpad (hJoyPressedRepeat), loop |
| `19:4B12` | `DebugErrorTest_OnA` | P | A pressed: fade out (4F:4370), calls the error screen CommErr_ShowScreen (5C:5150) with A=wRam_C0D4 (kind), H=wRam_C0D6, L=wRam_C0E5 (number), ... |
| `19:4B3E` | `DebugErrorTest_Exit` | P | Select pressed: fade out 4F:4370 and return A=1 |
| `19:4B4A` | `DebugErrorTest_HandleDpad` | P | Up/Down change wRam_C0D6 (or wRam_C0D4 while B is held), Left/Right change wRam_C0E5 (by 4 after the hold timer passes $3C); redraws via ... |
| `19:4BCF` | `DebugErrorTest_LoadHelpText` | P | Renders String_DebugErrorTest_Help (TextTiles_RenderGrid (48:40A9)) into VRAM $8800/$8C00 |
| `19:4C74` | `DebugErrorTest_DrawValues` | P | Draws '【' + six full-width hex digits (wRam_C0D4, C0D6, C0E5) + '】' from Data_DebugErrorTest_HexChars and uploads to VRAM $8E00 |
| `19:4D7E` | `DebugErrorTest_UpdateHoldTimer` | P | Same auto-repeat hold timer as DebugFlags_UpdateHoldTimer (wRam_C0E7/C0E8 with hJoyHeld) |

Data: `Table_DebugFlags_Buttons` (41B1), `String_DebugFlags_Help` (447C), `String_DebugFlags_Chars` (47AE), `Table_DebugFlags_Objects` (481D), `Table_DebugFlags_Entries` (490E), `String_DebugFlags_Title` (4914), `Palette_DebugScreens` (4940), `Table_DebugErrorTest_Buttons` (4AFD), `String_DebugErrorTest_Help` (4C1F), `Data_DebugErrorTest_HexChars` (4D5E)

### Bank 1B - sound test

| addr | name | status | summary |
|---|---|---|---|
| `1B:4040` | `SoundTest_Run` | P | Unreferenced debug sound test screen: number = wRam_C0D6:C0E5 in hex; A plays it as music (stub 00:20B2), B as sound effect (00:20AC), Start stops ... |
| `1B:41B1` | `SoundTest_Loop` | P | Per-frame loop: 00:044B, Joypad_UpdateIdleFrames (7D:7BA4)/7BC1, call JoypadDispatch with Table_SoundTest_Buttons |
| `1B:41CD` | `SoundTest_Idle` | P | SoundTest_UpdateHoldTimer, then D-pad with repeat -> SoundTest_HandleDpad, loop |
| `1B:41D8` | `SoundTest_OnA` | P | A: C=wRam_C0E5, B=wRam_C0D6 (sound id), SVBK=1, call 00:20B2 (music start stub -> 04:4287 SoundDrv_PlayMusic) |
| `1B:41F0` | `SoundTest_OnB` | P | B: same id, call 00:20AC (sound effect stub -> 04:41C0 SoundDrv_PlaySfx) |
| `1B:4208` | `SoundTest_OnSelect` | P | Select: stops music (00:20C4, bc=0) and effects (00:20BE, bc=0), ticks 00:20A6, fades out 4F:4370, returns A=1 (leave test) |
| `1B:423E` | `SoundTest_OnStart` | P | Start ('STOP'): 00:20C4 and 00:20BE with bc=0 (stop music, stop all effects), stay in the test |
| `1B:4261` | `SoundTest_HandleDpad` | P | Up/Down change the high byte wRam_C0D6, Left/Right the low byte wRam_C0E5 (by 4 after the hold timer passes $3C); redraws SoundTest_DrawNumber |
| `1B:42C4` | `SoundTest_LoadHelpText` | P | Renders String_SoundTest_Help (TextTiles_RenderGrid (48:40A9)) into VRAM $8800/$8C00 |
| `1B:4371` | `SoundTest_DrawNumber` | P | Draws '【' + four full-width hex digits (wRam_C0D6 hi, wRam_C0E5 lo) + '】' from String_SoundTest_HexChars and uploads to VRAM $8E00 |
| `1B:4450` | `SoundTest_UpdateHoldTimer` | P | Auto-repeat timer: resets wRam_C0E7 when hJoyHeld changes (wRam_C0E8), else increments it (saturating) |

Data: `Palette_DebugScreens1B` (4000), `Table_SoundTest_Buttons` (41C3), `String_SoundTest_Help` (4314), `String_SoundTest_HexChars` (4430)

### Bank 04 - sound engine

| addr | name | status | summary |
|---|---|---|---|
| `04:4000` | `SoundDrv_Init` | C | Sound driver init, called only from Boot via stub 00:20A0: clears state D001-D03F (keeps saved ROM bank), tempos $4A/$40, 8 track records (D040, ... |
| `04:4082` | `SoundDrv_FrameTick` | C | Per-frame sound engine tick, entered through stub 00:20A6 from the frame service 00:0392 (once per frame, all scenarios): SFX group tempo/track ... |
| `04:40AC` | `SoundDrv_SfxTickLoop` | C | SFX (track group A) tempo accumulator D008/D009 reached the threshold $4A: SoundDrv_ServiceChannelSfx for all channels, SoundDrv_StepTrack for the 4 ... |
| `04:40D0` | `SoundDrv_MusicPhase` | C | End of the SFX phase (clears D000 bit5) and start of the music (track group B) phase: adds the music tempo step D00C to the accumulator D00D/D00E and ... |
| `04:40F5` | `SoundDrv_MusicTickLoop` | C | Music tempo accumulator reached $4A: SoundDrv_ServiceChannelMusic for all channels, SoundDrv_StepTrack for the 4 music tracks, repeat while >= $4A |
| `04:4119` | `SoundDrv_ChannelPhase` | C | Final phase of the tick: SoundDrv_UpdateChannel for the 4 channels, decrements the 16-step divider D01A, builds the active-track bit mask D024 from ... |
| `04:414C` | `SoundDrv_SelectSfxTracks` | C | Sets the track iterator to the 4 SFX tracks (count 4, first record D040); companion of SoundDrv_SelectMusicTracks |
| `04:4153` | `SoundDrv_SelectMusicTracks` | C | Sets the track iterator to the 4 music tracks (count 4, first record D130 = D040+4*$3C) |
| `04:415A` | `Function_04_415A` | H | Unreferenced sibling of 414C/4153 (ld de,$D040 ; ld a,8): would iterate all 8 tracks; lands on the executed tail 415F |
| `04:415F` | `SoundDrv_SetTrackIterator` | C | Shared tail: D00F = track count A, D010/D011 = first track record pointer DE |
| `04:4167` | `SoundDrv_NextTrack` | C | Decrements the track counter D00F, advances the track pointer D010/D011 by $3C; returns Z when all tracks were visited |
| `04:4177` | `SoundDrv_SelectChannel1` | C | Channel iterator = channel 1 only (record D220, count 1, register base NR12 $12) |
| `04:4180` | `SoundDrv_SelectChannel2` | C | Channel iterator = channel 2 only (record D238, register base NR22 $17) |
| `04:4189` | `SoundDrv_SelectChannel3` | C | Channel iterator = channel 3 (wave) only (record D250, register base NR32 $1C) |
| `04:4192` | `SoundDrv_SelectChannel4` | C | Channel iterator = channel 4 (noise) only (record D268, register base NR42 $21) |
| `04:419B` | `SoundDrv_SelectAllChannels` | C | Channel iterator over the 4 hardware channels (record D220, count 4, register base $12) |
| `04:41A2` | `SoundDrv_SetChannelIterator` | C | Shared tail: D012 = count, D013/D014 = channel record pointer, D015 = register base (NRx2 low address) |
| `04:41AC` | `SoundDrv_NextChannel` | C | Decrements D012, advances the channel record pointer by $18 and the register base by 5 ($12 -> $17 -> $1C -> $21); returns Z at the end |
| `04:41C0` | `SoundDrv_PlaySfx` | C | Start effect BC (0 = stop all): loads its header (430A), starts its tracks on the SFX tracks by priority; via stub 00:20AC; UI sounds $29-$2E; ... |
| `04:4219` | `SoundDrv_PlaySfxAllTracks` | C | Header flags bit7 set (all 70 headers have $FF, so this is the path every effect takes): starts every track of the effect on free SFX tracks and ... |
| `04:4287` | `SoundDrv_PlayMusic` | C | Start music BC (0 = pause): remembers the id in D01B/D01C, resets fade and pause flags, loads header 430A, starts its tracks on the 4 music tracks, ... |
| `04:42C0` | `SoundDrv_PlayMusicIfNotPlaying` | P | Like PlayMusic but returns at once when the same id is already playing (D01B/D01C match and D024 high nibble non-zero); entered via stub 00:20B8 ... |
| `04:42D6` | `SoundDrv_PlayMusicOrResume` | C | Same id and no music track active -> SoundDrv_ResumeMusic; same id still playing -> return; other id -> SoundDrv_PlayMusic; via stub 00:20E8 ... |
| `04:42EC` | `SoundDrv_ResumeMusic` | P | Clears D025 and re-activates every music track whose flags have bit5/6 set (sets bit7): resume after SoundDrv_PauseMusic; entered via stub 00:20CA ... |
| `04:430A` | `SoundDrv_LoadSongHeader` | C | Validates id BC (< $47) and loads the 8-byte entry at Table_SoundDrv_Songs+8*(id-1): stream ptr (D017/18), ROM bank word (wBank4ReadBank), priority ... |
| `04:434C` | `SoundDrv_StartTrack` | C | Initialises the track record at D010/D011 from the loaded header (flags $A0, stream ptr, bank, id D038/D039, priority) and continues with ... |
| `04:4374` | `SoundDrv_NextHeaderTrack` | C | Decrements the header track count D03C and advances the header stream pointer D017/D018 by 2; returns Z when done |
| `04:4386` | `SoundDrv_InitTrackRuntime` | C | First step of a started track: flags := $C0, reads the first stream word (00:216F), stores it and resets the runtime fields (counters, envelope, ... |
| `04:43DC` | `SoundDrv_StopSfxById` | P | Stops the SFX tracks playing id BC (matching D038/D039 at track+6/7), BC=0 stops all (SoundDrv_StopAllSfx); entered via stub 00:20BE ... |
| `04:4414` | `SoundDrv_StopAllSfx` | P | Clears the flags byte of the 4 SFX tracks (SoundDrv_SelectSfxTracks loop); target of BC=0 in PlaySfx and StopSfxById |
| `04:4429` | `SoundDrv_PauseMusic` | C | Stub target of 00:20C4 (also PlayMusic with BC=0, SoundTest_OnStart/OnSelect): SoundDrv_PauseMusicCore then return via 00:2141 |
| `04:442F` | `SoundDrv_FadeFinished` | P | Fade-out end (from SoundDrv_UpdateFade when the level underflows): clears D020, falls into PauseMusicCore |
| `04:4433` | `SoundDrv_PauseMusicCore` | C | Sets D025=$FF and clears bit7 (active) of the 4 music track flags; tracks keep bit6, so SoundDrv_ResumeMusic can restart them; channels are released ... |
| `04:444B` | `SoundDrv_GetActiveMasks` | P | Returns D = SFX active mask (D024 low nibble), E = music active mask (D024 high nibble); stub 00:20D0 has no caller |
| `04:445C` | `SoundDrv_GetPlayingId` | P | A=0: BC = current music id if a music track is active else 0; A=1-4: BC = id of the effect on SFX track A via Table_SoundDrv_SfxTrackPtrs (offset ... |
| `04:44B1` | `SoundDrv_SetTrackParam` | P | Set a parameter of selected tracks: A = parameter index (0-6), BC = value, D = SFX track mask, E = music track mask; via stub 00:20D6, no caller |
| `04:44B7` | `SoundDrv_SetTrackParamCore` | P | Stores BC/DE in D038-D03B and jumps through Table_SoundDrv_ParamHandlers[A] with SoundDrv_JumpTable; also called by SoundDrv_UpdateFade with A=2 |
| `04:44CF` | `SoundDrv_SetTrackFieldByte` | P | For each track selected by the mask: sets the update flag D03C and stores byte D039 at track+BC (mask built by SoundDrv_BuildTrackMask) |
| `04:44EC` | `SoundDrv_SetTrackFieldWord` | P | Same as SoundDrv_SetTrackFieldByte but stores the word D038/D039 at track+BC |
| `04:450D` | `SoundDrv_BuildTrackMask` | P | Combines D03B (SFX mask, low nibble) and D03A (music mask, moved to the high nibble) into the 8-bit track mask in D, E=8 tracks, HL=D040 |
| `04:4522` | `SoundDrv_NextTrackRecord` | P | HL += $3C, E -= 1 (used by the mask loops); Z when the 8 tracks were visited |
| `04:452C` | `SoundDrv_StartFadeOut` | P | A = speed: D020=D021=A, D022=$40 (fade level); stub 00:20DC has no caller; SoundDrv_UpdateFade then lowers the level by 4 every A ticks |
| `04:453A` | `SoundDrv_UpdateFade` | P | Per-tick fade-out step called from SoundDrv_FrameTick; only its D020==0 early return ever ran: every D021 ticks lowers D022 by 4 and applies it via SetTrackParam A=2; no trace starts a fade |
| `04:455A` | `SoundDrv_ApplyTrackUpdates` | C | For an active track (flags >= $C0): copies the update flags to D019 and applies pitch/pan/volume changes (SoundDrv_ComputeTrackOutput); used between ... |
| `04:456C` | `SoundDrv_StepTrack` | C | One sequencer tick of the track at D010/D011: cold-starts it (4386) if needed, counts down the length counter (track+1), then reads bytes from the ... |
| `04:459B` | `SoundDrv_ReadNextCommand` | C | Reads the next stream byte through 00:216F (bank-aware read via wBank4ReadBank) into D01F/A and dispatches: >= $D0 note, < $B1 rest/length, else ... |
| `04:45CD` | `SoundDrv_JumpTable` | C | Generic dispatcher used by the sequencer and by SetTrackParam: BC = table base, A = index; loads the word (sla a ; add a,c ...) and jp hl |
| `04:45DB` | `SoundDrv_CmdEnd` | C | Command $B1 (and default of unused commands): clears the track flags (track ends); ends 66 of the 152 tracks of the 59 distinct song/effect headers, ... |
| `04:4668` | `SoundDrv_ComputeTrackOutput` | C | Converts the dirty flags of the track (D019 bit2 pitch, bit0 pan, bit1 volume) into output fields: pitch word -> track+$2C/2D, pan -> +$2E, volume ... |
| `04:473E` | `SoundDrv_CmdExtended` | P | Command $CD: reads a sub-command byte (< $0C) and dispatches through Table_SoundDrv_ExtCommands; larger values end the track |
| `04:4756` | `SoundDrv_CmdRest` | C | Stream bytes $81-$B0 (below the command range): length counter (track+1) = Table_SoundDrv_Durations[byte-$80]-1, stream pointer saved, back to the ... |
| `04:4777` | `SoundDrv_CmdCall` | C | Command $B3: pushes the return stream pointer on the track call stack (depth byte track+$26, max 5 entries) and jumps to the address that follows; ... |
| `04:479B` | `SoundDrv_CmdJump` | C | Command $B2: reads a 16-bit address from the stream (00:216F) and continues there (86 uses = track loops); also the tail of Call and Repeat |
| `04:47A3` | `SoundDrv_CmdReturn` | C | Command $B4: pops the pointer pushed by Call (113 uses ending the song subroutines); with an empty call stack (track+$26 = 0) it is a no-op (jp 459B) |
| `04:47C5` | `SoundDrv_CmdRepeat` | P | Command $B5: counted loop: count byte (0 = forever), counter at track+$29; jumps to the address that follows until the count is reached, then skips ... |
| `04:47E3` | `SoundDrv_CmdSetTempo` | C | Command $BC: stores the tempo byte in D00A (music) or D005 (SFX while D000 bit5 is set) and recomputes the step (SoundDrv_UpdateTempoStep) |
| `04:47FB` | `SoundDrv_UpdateTempoStep` | C | Tempo step = tempo byte (HL) * scale byte (HL+1) via 5007, >> 6, capped at $FF and at least 1; stored at HL+2 (D007 for SFX, D00C for music) |
| `04:4819` | `SoundDrv_ParamTempoScale` | P | Table_SoundDrv_ParamHandlers[0]: stores D039 as tempo scale (D006 for the SFX group if D03B != 0, D00B for music if D03A != 0) and recomputes the ... |
| `04:484E` | `SoundDrv_CmdSetInstrument` | C | Command $BE: selects instrument A (from Table_SoundDrv_Instruments, 6 bytes each) and copies its record into track+$0C..$11; index $64 only clears ... |
| `04:4889` | `SoundDrv_GetInstrumentPtr` | C | HL = Table_SoundDrv_Instruments + 6*A |
| `04:492A` | `SoundDrv_CmdSetVolume` | C | Command $BF: track+$15 = stream byte*2 (rlca) and dirty bit1 (volume) in D019; SoundDrv_ComputeTrackOutput multiplies +$15 and +$16 into the output ... |
| `04:4947` | `SoundDrv_ParamVolumeScale` | P | Table_SoundDrv_ParamHandlers[2]: sets volume-dirty flag (D03C bit1) and stores D039 at track+$16 for the selected tracks (04:44CF); used with A=2 by ... |
| `04:4A2B` | `SoundDrv_CmdNote` | C | Stream bytes $D0-$FF: note with length code (byte-$CF): b = Table_SoundDrv_Durations[...], stored at track+$0B, followed by optional pitch/modifier ... |
| `04:4A81` | `SoundDrv_StartNote` | C | Starts the note: picks the hardware channel from the instrument type byte (<8 ch1, <$10 ch2, <$40 ch3, else ch4), arbitrates with the current channel ... |
| `04:4BC9` | `SoundDrv_ServiceChannelSfx` | C | Per-tick check of a channel owned by an SFX track (channel+2 bit7 = SFX owner; other channels return): frees and silences it when the owner track ... |
| `04:4BDB` | `SoundDrv_ServiceChannelMusic` | C | Same as SoundDrv_ServiceChannelSfx for channels owned by a music track (returns for SFX-owned channels) |
| `04:4BFC` | `SoundDrv_NoteGateExpired` | P | Channel timer (channel+7) reached 0: if the release flag (channel bit6) is already set the channel is freed and silenced (SoundDrv_SilenceChannel), ... |
| `04:4C14` | `SoundDrv_UpdateChannel` | C | Per-channel hardware update: releases and silences the channel when its owner track stopped (flags < $C0), else runs the envelope state machine and ... |
| `04:4E4B` | `SoundDrv_WriteChannelParams` | C | Note-start register setup of the channel D015: NRx1 duty/length + NR10 sweep for square, NR31/NR34 + wave pattern (4EA9) for channel 3, NR41/NR43 ... |
| `04:4ECA` | `SoundDrv_WriteChannelPitch` | C | Adds the track pitch offsets, converts the note to a period through SoundDrv_NoteToIndex/LookupFrequency and writes NRx3/NRx4 (noise channel: NR43 ... |
| `04:4F4F` | `SoundDrv_WriteChannelPan` | C | Updates NR51 for the channel: masks $EE11/$DD22/$BB44/$7788 for channels 1-4, left/right bits from track+$2E bits 7/6 |
| `04:4F97` | `SoundDrv_WriteChannelVolume` | C | Writes the channel envelope/volume (NRx2 from channel+$11; NR32 level for the wave channel) and sets the trigger bit (NRx4 bit7, NR30 for wave) |
| `04:4FD4` | `SoundDrv_SilenceChannel` | C | Silences channel D015: NRx2=$08, NRx4=$80 (wave: NR30=0) |
| `04:4FEA` | `SoundDrv_NoteToIndex` | C | A = note - $24 clamped to 0..$77 (index into Table_SoundDrv_NoteFreq), falls into SoundDrv_LookupFrequency |
| `04:4FF5` | `SoundDrv_LookupFrequency` | C | DE = 11-bit period word and A = extra byte from Table_SoundDrv_NoteFreq + 3*A |
| `04:5007` | `SoundDrv_Mul8x8` | C | HL = B * C (unsigned 8x8 -> 16 bit shift-and-add multiply); used for the tempo step, pitch and volume scaling |
| `04:502B` | `SoundDrv_MulNibbles` | C | A = (B >> 4) * (C >> 4): 4-bit x 4-bit shift-and-add product; callers add $0F and mask $F0 to scale a volume/pan byte |

Data: `Table_SoundDrv_SfxTrackPtrs` (449B), `Table_SoundDrv_ParamHandlers` (44A3), `Table_SoundDrv_Commands` (46E8), `Table_SoundDrv_ExtCommands` (4726), `Table_SoundDrv_Durations` (5044), `Table_SoundDrv_NoteFreq` (5075), `Table_SoundDrv_Instruments` (51DD), `Table_SoundDrv_WavePatterns` (547D), `Table_SoundDrv_Songs` (551D), `Data_SoundDrv_Streams` (574D)

## 13. Reproduce

```
cp -r config /tmp/g1cfg                      # scratch copy, then drop config/symbols/bank{04,0E,19,1A,1B,1C,1D,1F,22,23}.tsv into it (or use config/ once merged)
python3 tools/gen_asm.py verify --config /tmp/g1cfg          # RESULT: IDENTICAL
python3 tools/gen_asm.py check --strict --config /tmp/g1cfg
python3 tools/gen_asm.py regen --config /tmp/g1cfg --out /tmp/g1out   # look at the renamed sources
```

Method notes: far-call graph from the `farcall` macro lines of `src/*.asm` (`Function_BB_AAAA` targets), execution status from `analysis/coverage_union.tsv` /
`traces/coverage_*.tsv`, screens identified from `.cache/trace/shots/*/*.png` (frame numbers in the evidence), loaders (`00:0787`, `00:08EA`, `4F:4000`, `00:0A82`) parsed from the
call sites to attribute tile/tilemap/palette/object blocks, song streams decoded with a small scratch decoder.  Nothing outside the files listed at the top was written.

## 14. Adversarial review (verifier pass)

A second pass tried to refute the names.  Checked independently (ROM bytes, `src/` regenerated from the current `config/`, `analysis/coverage_union.tsv`, `traces/detail/*/{callgraph,dataaccess,adapter.log}.tsv`,
screenshots in `.cache/trace/shots`): every CONFIRMED function/label row is an executed instruction start and every CONFIRMED data row is read in some scenario; every `BB:AAAA` cited in an evidence
column is a label or executed instruction start and the `from BB:AAAA` caller claims decode to a call of the row; all decoded Shift-JIS strings match the quoted text; the 10 callers of
`SramCheck_Bank0Commit`, the 13 ROM0 stubs, the 70 song headers, the 11 dictionary categories (bank 1A tables and the bank-3F id lists agree), the `Table_SoundDrv_Durations` / `CmdNote` / `CmdRest` indexing, the
command dispatch indices ($B1 end, $B2 jump, $B3 call, $B4 return, $B5 repeat, $BC tempo, $BE instrument, $BF volume), the NR51 pan masks, `MulNibbles`, the SRAM page/checksum arithmetic, the
`hJoyHeld xor $24` test of 7C:7CF6 (SELECT+LEFT) and the help-menu button order (4th button 'モバイルじてん' -> `1A:4000`) were re-derived and hold.  `adapter.log` gives independent proof of the mail-server flows:
`mail_server_full` delete-all sends `TOP 1 0`..`TOP 3 0` (pass 1), then `TOP n 0` + `DELE n` per mail (pass 2), the hidden 'delete completely' button sends only `DELE 1`..`DELE 4` (no TOP), the check-then-delete flow sends TOP/DELE per mail.
No debug-screen entry (`19:4000`, `19:4980`, `1B:4040`) has a call, jp, far pointer or table reference; the only `00 40 19` byte matches are `ld hl,$4000 ; add hl,de`.

Changes made by this review

* **Retracted:** `Data_CommProgress_Tiles` (22:5CD0, 'communication-progress tiles read in send/receive') was wrong; the block is address-book tile data loaded by four bank-2F HDMA calls (see section 9).  Renamed `Gfx_AddrBook_TilesBank22`.
* Evidence of `Tilemap_CommProgress_Screen`, `Palette_CommProgress_Bg/Obj` cited `26:51C4`, which is only a fill-loop label; the loader is `MailSession_InitScreen` (26:5168).
* Downgraded CONFIRMED -> PROBABLE: `SoundDrv_UpdateFade` (only its `D020==0` early return ever ran, no trace starts a fade), `MobileDict_ScrollUp` (only the scroll-offset==0 early return ran),
  `SpriteCounter_StubA/B/C` (the stubs are bare `ret`; the sprite-counter role is inferred from the dead bodies only).
* Numbers corrected: `MailSrvDel_DrawElapsedTime` call counts (594 / 372 / 919, not 594-919 for all), `22:4EF0` runs in 40 of 41 scenarios and `22:4FF6` in 32 (not 'every scenario'), the title screen runs in 35 of 41.
* Wording: top-menu item 2 is labelled ホームページ (homepage) on screen, called 'homepage' now; `MailConnect_Screen` results in `MailSrvDel_DeleteAll` are `$FF/$80` error path, `$20` cancelled, anything else continues (it was 'A=0 ok');
  stale generic labels in three evidence strings replaced by the current names.
* The evidence of `MailSrvDel_DeleteAllRun` / `DeleteCompletelyRun` now says that POP3 TOP/DELE are visible in `adapter.log` but that the meaning of API result `B==2` ('problem mail') is still an inference from the hidden button text and the loop structure.
* `analysis/naming/ram_g1.tsv`: `D03A/D03B` (`wSoundDrv_ReqDE`) are also scratch bytes in `SoundDrv_StartNote` and `SoundDrv_PlaySfxAllTracks`; noted.  No proposal contradicts `config/ram` semantically (they all replace HYPOTHESIS `wRam_*` rows or the
  ROM0 `wBank4*` rows are untouched); the banked-WRAM caveat of section 10 stands, and the 2-byte rows `D008/D00D/D010/...` overlap separate one-byte `wRam_*` rows that the merge has to fold.

Still not proven (unchanged, stated for the record): that `MobileDict_*` shows a dictionary (no screenshot of the screen exists; the help button label, the glossary strings and the bank-3F id lists are the evidence), the debug screens' entry
conditions, the meaning of sound commands `$BD`, `$C1`-`$C5`, `B==2` = problem mail, and everything in the HYPOTHESIS rows.
