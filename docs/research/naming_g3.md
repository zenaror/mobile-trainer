# Naming pass g3: banks 2A, 2B, 2C (the mail application UI)

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Scope: `config/symbols/bank2A.tsv`, `bank2B.tsv`, `bank2C.tsv` (259 rows: 155 CONFIRMED, 74 PROBABLE, 30 HYPOTHESIS) and the RAM proposals
`analysis/naming/ram_g3.tsv` (10 rows).  Everything here rebuilds byte-identically (`python3 tools/gen_asm.py verify`, checked with the three symbol
files and the ten RAM renames applied).  Evidence vocabulary as in `docs/FORMATS.md`.  A name in this document is either semantic (CONFIRMED or
PROBABLE, at least two independent pieces of evidence) or the generic name kept with a HYPOTHESIS row (section 4).

Evidence sources used besides the disassembly (`src/bank2a.asm` ... regenerated from the current `config/`):

* trace coverage of all 41 scenarios (`traces/coverage_*.tsv`, `analysis/coverage_union.tsv`), function level matrix in section 1.2;
* the screenshots of the scenarios in `.cache/trace/shots/<scenario>/` (e.g. `mail_inbox_f03303_m1_sender.png`), which tie functions to screens;
* the decoded Shift-JIS strings (`analysis/strings.tsv`) and the far-call graph (`analysis/farcall_targets.tsv`);
* `docs/research/sram_layout.md` for the SRAM areas, `docs/research/boot_and_home.md` for the ROM0 library.

## 1. Subsystem map

### 1.1 What the three banks are

All three banks belong to the **mail application** ("メール" menu of the title screen, driven from bank 7C, mailbox list in bank 25, compose flow in
bank 2D, address book in bank 2F).  The banks are not screens of one state machine; each holds the code and art of a few self-contained screens that
are entered by far call from those banks:

| bank | contents (screens) | main entry points |
|---|---|---|
| 2A | "save the sender's address" screen (pick an address-book slot for the sender of a received mail); the **profile** (nickname) editor with the kana keyboard; the address-book "save entry?" confirmation | `SaveSenderAddr_Menu` 2A:4000, `Profile_Edit` 2A:5495, `AddrBook_SaveConfirm` 2A:6F95 |
| 2B | the menu of the saved draft ("written mail": view / edit / delete); the two pages of the **received mail viewer** (page 1 sender/title/address/date, page 2 body text); an unused 12-cell 'もらったメール' (received mail) grid screen | `MailDraft_Menu` 2B:4000, `MailView_SenderPage` 2B:6482, `MailView_BodyPage` 2B:7B02 |
| 2C | the **mail title (subject) entry** with the kana keyboard; the **address picker** (choose one of the six address-book slots while writing a mail); shared address-book helpers (draw a slot name, upload the text tiles); palettes/tiles shared with bank 2F | `MailTitle_Entry` 2C:4000, `AddrPick_Menu` 2C:56FE, `AddrBook_DrawSlotName` 2C:614D, `AddrBook_UploadTextTiles` 2C:665F |

### 1.2 Entry points, callers, scenarios (function-entry hit = executed in that scenario; `monkey*` = random button campaigns)

| entry | caller(s) (far call unless noted) | scenarios that execute it | screenshot that shows the screen |
|---|---|---|---|
| 2A:4000 `SaveSenderAddr_Menu` | 2B:659F (SELECT on the mail sender page) | mail_inbox | `mail_inbox_f03441_m1_save_place`, `..._m1_saved_1..3` ("セーブするばしょを えらんでください") |
| 2A:5495 `Profile_Edit` | 7C:7CED (mail menu, A=0), 48:4A0B (first-run tutorial, A=1) | mail_profile, tutorial_profile, monkey_camp_* | `mail_profile_f03796..f07040`, `tutorial_profile_f15694_nickname_keyboard` |
| 2A:6F95 `AddrBook_SaveConfirm` | 2F:7F2A | addressbook_full | `addressbook_full_f06023_edit_confirm` ("メールアドレスを セーブします。よろしいですか？") |
| 2A:7293 `AddrBook_UploadEntryTextTiles` | 2A:7187/722D, 2F:537B, 2F:53E1 | addressbook_full | (same screens) |
| 2B:4000 `MailDraft_Menu` | 7C:7CA7 | mail_compose, monkey_1, monkey_camp_rich/tut/hid | `mail_compose_f10120_s3` ("かいたメールを みることができます") |
| 2B:6482 `MailView_SenderPage` | 25:475C (A on a mail in the mailbox list) | mail_inbox, monkey_camp_reg2 | `mail_inbox_f03303_m1_sender` |
| 2B:7B02 `MailView_BodyPage` | 2B:64E4 (A on the sender page) | mail_inbox, monkey_camp_reg2 | `mail_inbox_f04026_m1_body` |
| 2C:4000 `MailTitle_Entry` | 2D:4027 (compose), 25:5536 (reply), 2B:476E (edit draft), 2B:6D7C (dead) | mail_compose, mail_inbox (reply), monkey_camp_*, monkey_1 | `mail_compose_f05988_subj_typed`, `mail_inbox_f12901_reply_title` |
| 2C:56FE `AddrPick_Menu` | 2D:67DA (SELECT on the compose address screen) | monkey_camp_reg/tut, monkey_1 | none captured (bar text "アドレスを せんたくしてください", String_AddrPick_Caption) |
| 2C:614D `AddrBook_DrawSlotName` | 2A:422C/4280, 2C:6032/5FB1, 2F (3 call sites) | addressbook_full, mail_addressbook, mail_inbox, monkeys | `mail_addressbook_*`, `addressbook_full_f02648_list` |
| 2C:665F `AddrBook_UploadTextTiles` | 2A:4027/4105/42F6, 2C:58AC/6025/60A6, 2F (5+) | as above | as above |

Not covered by any scenario: the Up/Down handlers of the save-slot list (2A:40BB/40E0), `Profile_ApplyHandakuten`/`MailTitle_ApplyHandakuten`, the
`AddrBook_SaveConfirm_DrawSlot` alternative (B=$FF), and the whole unused 12-cell grid cluster in 2B (section 4).

### 1.3 Screen flows (derived from the code; scenario and screenshot support in 1.2)

```
mail menu (7C) --"プロフィール"--------------> Profile_Edit (2A:5495)             [A=0; first-run tutorial (48) calls it with A=1]
               --"メールをかくにん"----------> MailDraft_Menu (2B:4000)
                                                 icon 0 -> farcall 28:4000 (view the draft)
                                                 icon 1 -> MailDraft_Edit (2B:4743): 2D:65B0 address -> 2C:4000 title -> 2D:4722 body
                                                 icon 2 -> yes/no (72:4015 DE=$0209) -> 2D:40DC clears the draft
mailbox list (25) --A on a mail--> MailView_SenderPage (2B:6482) --A--> MailView_BodyPage (2B:7B02) (A on the body page returns 0, B returns $FF; in both cases the caller 25:475C returns to the mailbox list: $FF -> list loop 25:411E, 0 -> reopens the list via 25:4000)
                                          |--SELECT--> SaveSenderAddr_Menu (2A:4000) --A--> SaveSenderAddr_SaveToSlot (2A:4312)
compose (2D:4000) --> 2D:65B0 (address) --SELECT--> AddrPick_Menu (2C:56FE) ; --> MailTitle_Entry (2C:4000) --> 2D:4722 (body)
address book (2F) --edit/add--> AddrBook_SaveConfirm (2A:6F95) --yes--> AddrBook_StoreEditBufferToSlot (2A:704B)
```

## 2. Data structures and idioms

### 2.1 SRAM areas seen from these banks (bank = SRAM bank; see `sram_layout.md` for the rest)

* **Mail record** (SRAM bank 0, 12 records at `$A124 + i*$12D`, in-use flag = first byte non-zero):
  `+00` flag (1 or 2; `MailView_BodyPage_InitScreen` writes 2 when the body is shown, `MailView_DrawDateTime` accepts 1 or 2), `+01..02` unknown,
  `+03..08` date/time as 6 BCD bytes (year 2 bytes, month, day, hour, minute; drawn as `2001年01月27日10時00分`, screenshot m1_sender),
  `+09..C8` body ($C0 bytes, Shift-JIS, `$0D` = newline), `+C9..D8` sender name (16 B), `+D9..EC` title (20 B), `+ED..12C` sender address (64 B ASCII).
  Evidence: 2B:65AB/691A/7B9B/7EE0, 2A:4312 (copies +C9 and +ED into an address slot).
* **Draft ("written mail")** (SRAM bank 0 `$A000-$A123`): address `A000` (64), body `A040` (192), title `A100` (20), name `A114` (16); staged to WRAM
  `D4C0/D400/D500/D514` by `2D:408F` (load) and `2D:403C` (store), cleared by `2D:40DC`; shown by `MailDraft_Menu_InitScreen`.
* **Address-book slot** (SRAM bank 1, 6 slots at `$A69D + i*$50`): `+00` name (16 B, Shift-JIS), `+10` address (64 B ASCII); a slot is used iff `+10 != 0`
  (`SaveSenderAddr_IsSlotUsed` 2A:480C, `AddrPick_IsSlotUsed` 2C:64A5).  Writers: 2A:4312 and 2A:704B; readers: 2C:57F1, 2C:614D, 2A:7187.
  The slot base tables appear as ten identical 12-byte copies (2A:4274, 4306, 445F, 483B, 709F, 7221, 7287; 2C:56F2, 64D4; 2F:51B5), one per function that indexes them.
* **Profile** (SRAM bank 0): nickname `$AF40` (16 B) and own mail address `$AF50` (64 B); `Profile_LoadAndDraw` / `Profile_SaveToSram` (2A:6257/62C5); after a bank-0 write `22:501D` recomputes the page checksum and refreshes the mirror page (`22:4EF0/4F24/4F7B`), after an address-book write `22:50FC` recomputes the bank-1 checksum stored at `A8D7` (`22:5035/5077`).

### 2.2 WRAM edit buffers and the text buffer format

`wEditBodyBuf D400 ($C0)`, `wEditAddressBuf D4C0 ($40)`, `wEditSubjectBuf D500 ($14)`, `wEditNameBuf D514 ($10)` (WRAM bank 1; proposals in `analysis/naming/ram_g3.tsv`, identical names were proposed independently in `ram_g4.tsv`).
The kana editors (`Profile_*`, `MailTitle_*`) treat their buffer as **2 bytes per character** (double-byte kana only), 12 columns per line, `$0D` as line break, `$00`
terminator; capacity 8 chars (name, last cell D522) and 10 chars (title, last cell D512).  The keyboard of **bank 55** returns the Shift-JIS char in
`wRam_C2AE` = `wKeyboardCharHi` (lead) / `wRam_C2AD` = `wKeyboardCharLo` (trail); the editors special-case `814A` (dakuten: +1 on the previous kana's trail byte if it is in the 40-kana table), `814B` (handakuten: +2, 10-kana table)
and the fallback U (`8345`) -> VU (`8394`).  The tables are byte-identical in 2A (5F82, 6132), 2C (4779, 4929) and 2F.

### 2.3 Text drawing pipeline (the big duplicated family)

Every text field is drawn by a **draw-string routine**: `HL` = NUL-terminated Shift-JIS, `D`,`E` = pixel y,x, `B`,`C` = glyph style for `7F:41EA`, `wRam_C2EE` = width in
six-pixel cells.  Per character: `7F:41A7` tells lead bytes; ASCII glyphs come from `7F:4007`, double-byte glyphs from `7F:405F` (which first far-calls `63:4000`); every glyph half (6 px) is blitted
into the tile buffer in WRAM banks 2/3 (`D000..`, 20 tiles per row) by `7F:42C3` (with the style transform) or `7F:42CA` (without); `E += 6` after each half; the tail pads with blanks.
Afterwards an **upload** routine copies the tile buffer to VRAM with general DMA (`rHDMA1-5`, started at LY $8F..$91): `D000->$9000`, `D400->$9400`, `D800->$8800`, `DC00->$8C00` (variants copy fewer blocks).
The text therefore lives in BG tiles that the tilemap of each screen points at (`Data_*_TilemapAttr`).

The compiler duplicated this code per use: 19 draw-string variants (14 executed, 5 dead) with widths 10, 12, 16, 17, 20, 21, 24, 25 cells (each with a BlitGlyphAdvance and a BlitBlankAdvance helper) and 7 copies of the
GDMA helper (`Gfx_StartHDMAAtVBlank_<bank>_<addr>`).  Named after the field they draw in the executed code; the never-called variants keep generic names (section 4).

### 2.4 Screen set-up idiom (identical in all screens of these banks)

`00:09B6` (reset sprite objects) -> `2D:4E06` (clear the tile buffers) -> palettes staged into WRAM `D800` (BG) / `D840` (OBJ) with `4F:4000` -> tiles by HDMA `00:0749`/`00:0787` -> tilemap+attribute
rectangle `00:08EA` (`bc=$1214`, 20x18) -> sprites by `00:0A82` (animation-table entry) + `00:0A65` (x,y) -> text drawn -> upload -> `4F:42B4` (palette ramp, screen start); the LCD split (`wRam_D724/D725` then `7F:7271`,
removed by `7F:72B0`, handler `00:0E93`) and `4F:4370` (palette ramp, screen end) bracket every screen.  Dialogs (yes/no) are `72:4015` with `DE` = dialog id, A=1 for yes.

### 2.5 Input conventions

`hJoyPressed` bits: `$01` A, `$02` B, `$04` SELECT, `$08` START, `$10` Right, `$20` Left, `$40` Up, `$80` Down; `hJoyPressedRepeat` adds auto-repeat for the d-pad (used for all cursor movement).
The bit order follows the rP1 layout read by 7D:7B7C (see boot_and_home.md); direct evidence in these banks: `Profile_CursorLeft`/`Profile_CursorRight` (`&$20`/`&$10`) are executed in the monkey campaigns, the Up/Down handlers of the save-slot list (`&$40`/`&$80`) never run in a trace.

### 2.6 Sound calls (observation, no name)

`00:20AC` is called with a constant `BC` at every user-visible event (stub into bank 04, sound driver per boot_and_home.md, unproven).  Values and contexts in these banks:
`$29` list cursor Up/Down and menu Left/Right, `$2C` A / confirm (menu selection, keyboard exit, slot chosen), `$2E` B / cancel, `$31` refusal (buffer full, empty slot, no kana match),
`$32` saved (address-book save), `$33` draft deleted, `$36` text-cursor Left/Right, `$38` kana inserted, `$39` kana deleted.  The `00:20E8` stub is called with `BC` = 4..$F once at the end of each screen set-up (di/ei around it).

## 3. Named symbols

Tables are generated from the three symbol files (status and evidence as in the TSVs).  Function-like names are `Prefix_Role`; helpers of the draw-string family end in `_BlitGlyphAdvance` / `_BlitBlankAdvance`.
Generic region labels (`Function_2A_5495`, `Table_2A_4214`, ...) still exist at the same addresses as aliases and can be dropped from `config/regions` by the orchestrator.

### Bank 2A

#### Save-the-sender-address screen (2A:4000)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:4000 | `SaveSenderAddr_Menu` | function | CONFIRMED | Screen 'save sender address to address book': 6 slots + cursor; BC=(mail idx,slot). Far-called by 2B:659F (SELECT on mail sender page). A=4312 save, B=ret $FF. Exec mail_inbox; screenshot m1_save_place |
| 2A:4027 | `SaveSenderAddr_Menu_Loop` | label | CONFIRMED | per-frame loop of SaveSenderAddr_Menu: sprite tick (00:0956), VBlank wait, 7D:7BB7, then A(4312)/B(exit)/Up-Down (hJoyPressedRepeat &$40/$80 at 40A8) dispatch; executed in mail_inbox |
| 2A:40BB | `SaveSenderAddr_CursorDown` | function | PROBABLE | Down handler (hJoyPressedRepeat&$80 at 40A8): snd bc=$29 via 00:20AC, c=(c+1) wraps 6->0, redraws names (4280) and icons (4573); no Up/Down press in traces so never executed |
| 2A:40E0 | `SaveSenderAddr_CursorUp` | function | PROBABLE | Up handler (hJoyPressedRepeat&$40 at 40A8): snd bc=$29, c=(c-1) wraps 0->5, then 4280 + 4573; mirror of SaveSenderAddr_CursorDown; never executed in traces |
| 2A:4105 | `SaveSenderAddr_InitScreen` | function | CONFIRMED | Screen setup: sprite reset, palettes 2C:71D0->D840 and 4FA0->D800, tiles 4AA0->$9300 + bank28 icon tiles, tilemap 4CD0, caption 49C5, sender name 4483, slot names 422C, fade-in; exec mail_inbox |
| 2A:4214 | `Table_SaveSenderAddr_MailRecAddrs_Init` | table | PROBABLE | 12 words $A124+i*$12D = SRAM bank0 mail record bases; 4105 indexes by B=mail idx and adds $C9 (sender name field) for the name shown at the top of the screen |
| 2A:422C | `SaveSenderAddr_DrawSlotNames` | function | CONFIRMED | Loop over 6 address-book slots: hl=Table_SaveSenderAddr_SlotAddrs_DrawNames[i], D=$10+12*i, E=$28, B=3,C=0 -> 2C:614D draws each 16-cell name (normal style); called by 4105 and the menu loop; exec mail_inbox |
| 2A:4274 | `Table_SaveSenderAddr_SlotAddrs_DrawNames` | table | CONFIRMED | 6 words $A69D..$A82D step $50 = address-book slot bases in SRAM bank 1 (stride $50 = name[16] + address[64]); indexed by 2*i in 422C (ld hl,$4274 at 4247); identical copies at 4306/445F/483B/709F/7221 |
| 2A:4280 | `SaveSenderAddr_MoveNameHighlight` | function | CONFIRMED | A=old slot ($FF none), C=new slot ($FF none): old name redrawn normal (B=3,C=0), new name highlighted (B=0,C=1) via 2C:614D, then 2C:665F uploads tiles; enables SRAM bank1 around it; exec mail_inbox |
| 2A:4306 | `Table_SaveSenderAddr_SlotAddrs_Highlight` | table | CONFIRMED | 6 words $A69D..$A82D step $50: slot bases used by SaveSenderAddr_MoveNameHighlight (ld hl,$4306 at 429C/42CE) |
| 2A:4312 | `SaveSenderAddr_SaveToSlot` | function | CONFIRMED | B=mail idx, C=slot: if slot used (byte +$10!=0) asks yes/no (72:4015 DE=$0208, A=1=yes) else copies record+$C9[16] (sender name)->slot+0 and record+$ED[64] (address)->slot+$10, checksum 22:50FC; A=0 saved/$FF no |
| 2A:445F | `Table_SaveSenderAddr_SlotAddrs_Save` | table | CONFIRMED | 6 words $A69D..$A82D step $50: destination slot bases read by SaveSenderAddr_SaveToSlot (ld hl,$445F at 4325/43D3/4426) |
| 2A:446B | `Table_SaveSenderAddr_MailRecAddrs_Save` | table | PROBABLE | 12 words $A124+i*$12D = mail record bases (SRAM bank 0); SaveSenderAddr_SaveToSlot adds $C9 (name) and $ED (address) (ld hl,$446B at 43BF/4412) |
| 2A:4483 | `SaveSenderAddr_DrawSenderName` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL in <=16 six-pixel cells at pixel (D=y,E=x) into the WRAM-bank2 tile buffer (7F:4007/405F/42C3); 4105 passes mail record+$C9, DE=$0220: sender name at top of screen |
| 2A:4547 | `SaveSenderAddr_DrawSenderName_BlitGlyphAdvance` | function | CONFIRMED | Helper of the draw-string routine: blit glyph buffer C0A0 (7F:42C3, style B/C) at (D,E) then E+=6; same body as every draw-string helper in banks 2A/2B/2C |
| 2A:455B | `SaveSenderAddr_DrawSenderName_BlitBlankAdvance` | function | CONFIRMED | Helper: blit the blank glyph in C0A0 with fixed style B=2,C=0 (7F:42C3) and E+=6; used for newline/end padding of the draw-string routine |
| 2A:4573 | `SaveSenderAddr_RefreshSlotIcons` | function | CONFIRMED | For each of the 6 slots sets sprite slot DA70..DA20 to the empty-icon anim (bank28 table 5220) or used-icon anim (5230, per 480C), the cursor slot C uses 2C:7240/7250; sets icon y/x; on Up/Down calls 4847 |
| 2A:480C | `SaveSenderAddr_IsSlotUsed` | function | CONFIRMED | A=slot 0..5: enables SRAM bank1, hl=Table_SaveSenderAddr_SlotAddrs_IsUsed[A]+$10 (address field); returns A=0 if that byte !=0 (slot used) else $FF; twins 2C:5CA3/64A5 |
| 2A:483B | `Table_SaveSenderAddr_SlotAddrs_IsUsed` | table | CONFIRMED | 6 words $A69D..$A82D step $50 read by SaveSenderAddr_IsSlotUsed (ld hl,$483B at 4822) |
| 2A:4847 | `SaveSenderAddr_CursorMoveEffect` | function | PROBABLE | Called at the end of SaveSenderAddr_RefreshSlotIcons when hJoyPressed&$C0 (Up/Down): re-inits the cursor slot icon with anim entry bank28 5240/5250, sets its y/x, waits until Up/Down released. Executed in mail_inbox only via SaveSenderAddr_InitScreen, which forces hJoyPressed=$40 at 2A:4189 |
| 2A:49C5 | `SaveSenderAddr_LoadCaption` | function | CONFIRMED | Renders the 5 caption chunks at String_SaveSenderAddr_Caption (4A66/4A6F/4A78/4A81/4A8A) with 48:403E into WRAM buffers (BC=D280/D500/D780/DA00, DE=+$140): bottom-bar text 'select where to save' |
| 2A:4A66 | `String_SaveSenderAddr_Caption` | string | PROBABLE | 5 NUL-terminated chunks of 9 bytes (4A66,4A6F,4A78,4A81,4A8A): 'セーブ\|するばし\|ょを え\|らんでく\|ださい' = 'Please choose where to save' (screenshot m1_save_place bottom bar); loaded by 49C5. Region 4A66-4A6C is mis-typed ptrtable |
| 2A:4AA0 | `Gfx_SaveSenderAddr_Tiles9300` | data | PROBABLE | 35 tiles loaded by SaveSenderAddr_InitScreen: HDMA hl=$4AA0 -> VRAM bank1 $9300 c=$23 (2A:4105-4119) |
| 2A:4CD0 | `Data_SaveSenderAddr_TilemapAttr` | data | PROBABLE | 20x18 tilemap + attribute map ($2D0 bytes) copied by 00:08EA to WRAM7 D000/D400 in SaveSenderAddr_InitScreen (ld hl,$4CD0 bc=$1214) |
| 2A:4FA0 | `Palette_SaveSenderAddr_Bg` | data | PROBABLE | 64 bytes = 8 BG palettes: 4F:4000 copies to WRAM D800 (bc=$40) in SaveSenderAddr_InitScreen; D840 gets Palette_AddrBook_Obj (2C:71D0) |

#### Profile / nickname editor (2A:5495)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:5495 | `Profile_Edit` | function | CONFIRMED | Profile (nickname) screen; A stored in wRam_C264 and passed as C to the bank-55 keyboard poll: 1 from 48:4A0B (first-run tutorial; screenshot tutorial_profile_f15694 keyboard shows no back key), 0 from 7C:7CED (mail menu; mail_profile_f05064 has it). Edits D514, shows own address; exec mail_profile |
| 2A:54FD | `Profile_Edit_Loop` | label | CONFIRMED | main loop of Profile_Edit: frame, sprite tick, 7D:7BB7, cursor sprites (590B); A opens keyboard input (6148), B leaves (56EC), Left/Right (5731) move the text cursor; executed |
| 2A:5744 | `Profile_CursorLeft` | function | CONFIRMED | Left handler (hJoyPressedRepeat&$20 at 5731): snd bc=$36, c-1 (mirrored to wRam_C0D2); at column 0 of a later line it calls $4441, the middle of the ld a,$00 at 2A:4440 (stale copy of the 2C:4441 call, never reached: the nickname has one line). Exec monkey_camp_reg/tut |
| 2A:576B | `Profile_CursorRight` | function | CONFIRMED | Right handler (hJoyPressedRepeat&$10 at 5731): snd bc=$36 then falls into Profile_MoveCursorRight; executed in monkey campaigns |
| 2A:577F | `Profile_MoveCursorRight` | function | CONFIRMED | Advance the text cursor one char: col 0 needs a non-empty line, via Profile_CharPtr; $0D -> next line col 0; else col++ clamped at 8 (c==9 -> 8), mirrored in wRam_C0D2; called 8x by Profile_Edit to reach the text end |
| 2A:57BD | `Profile_InitScreen` | function | CONFIRMED | Screen setup: tiles 2A:6300->$9300(0x40), 6700->$9700, 6800->$8800, bank26 7820->$8000, palettes 6E10 (BG) and 26:7AC0 (OBJ), tilemap 6B40, cursor sprites; then Profile_LoadAndDraw; fade-in; exec profile scenarios |
| 2A:590B | `Profile_PlaceTextCursor` | function | CONFIRMED | B=line,C=col: cursor sprites (slots +16/+32): y=$2C+12*B-[C0D3], x=$38+12*C; second sprite hidden ($D0) while the view is scrolled; called after every cursor move |
| 2A:594B | `Profile_RedrawNickname` | function | CONFIRMED | Wrapper `ld a,1 ; call Profile_DrawNickname ; xor a ; ret`; used after each edit (insert/delete/dakuten) together with Profile_UploadTextTiles |
| 2A:5952 | `Profile_DrawNickname` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL (D514 nickname; called with DE=$0000) in <=16 six-pixel cells into the tile buffer (7F glyph routines; $0D drawn as '<'), pads, ends with 7F:4C42; exec profile scenarios |
| 2A:5A0F | `Profile_DrawNickname_BlitGlyphAdvance` | function | CONFIRMED | Helper of Profile_DrawNickname: blit C0A0 glyph via 7F:42C3 (style B/C), E+=6 |
| 2A:5A23 | `Profile_DrawNickname_BlitBlankAdvance` | function | CONFIRMED | Helper of Profile_DrawNickname: pad cell with blank glyph, B=2,C=0, via 7F:42CA (no style transform), E+=6 |
| 2A:5A3B | `Profile_DrawAddressLine1` | function | CONFIRMED | Draw string at HL (D4C0 own address) in <=10 cells; Profile_LoadAndDraw calls it with DE=$1000 -> screen shows the first 9 chars '11111111@' (screenshot profile_1); exec profile scenarios |
| 2A:5AFB | `Profile_DrawAddressLine1_BlitGlyphAdvance` | function | CONFIRMED | Helper of Profile_DrawAddressLine1: blit glyph via 7F:42C3, E+=6 |
| 2A:5B0F | `Profile_DrawAddressLine1_BlitBlankAdvance` | function | CONFIRMED | Helper of Profile_DrawAddressLine1: blank pad cell (B=2,C=0) via 7F:42C3, E+=6 |
| 2A:5B27 | `Profile_DrawAddressLine2` | function | CONFIRMED | Draw string at HL (D4C9 = rest of own address) in <=16 cells; Profile_LoadAndDraw uses DE=$1C00 -> second address line '1111.dion.ne.jp' (screenshot profile_1) |
| 2A:5BE7 | `Profile_DrawAddressLine2_BlitGlyphAdvance` | function | CONFIRMED | Helper of Profile_DrawAddressLine2: blit glyph via 7F:42C3, E+=6 |
| 2A:5BFB | `Profile_DrawAddressLine2_BlitBlankAdvance` | function | CONFIRMED | Helper of Profile_DrawAddressLine2: blank pad cell via 7F:42C3, E+=6 |
| 2A:5C13 | `Profile_UploadTextTiles` | function | CONFIRMED | Copies the WRAM bank2 tile buffer to VRAM: D000->$9000 (0x40 tiles) and D400->$9400 (0x38 tiles) with Gfx_StartHDMAAtVBlank_2A_5C3B; called after every text redraw of the profile screen |
| 2A:5C5B | `Profile_CharPtr` | function | CONFIRMED | B=line,C=col: HL=pointer to the 2-byte char at that position of the D514 buffer via Profile_FindLine (then 2 bytes per column), A=char byte, $0D at newline, $FF/D=$FF beyond the text; 11 callers in the profile editor |
| 2A:5C8F | `Profile_FindLine` | function | CONFIRMED | B=line: HL=start of line B in D514 (lines end at $0D or 12 chars, 2 bytes/char), D=$FF if the text ends earlier, E=line length (<=11); ends with RAM disable ([rRAMG]=0) |
| 2A:5CD2 | `Profile_InsertChar` | function | CONFIRMED | DE=char (D=lead,E=trail; from wRam_C2AE/C2AD): if last cell D522 used -> snd bc=$31 and return; else key-press animation, shift words up from D520, store D,E at the cursor, redraw + upload, cursor right (col wraps at 12) |
| 2A:5E23 | `Profile_DeleteChar` | function | CONFIRMED | Backspace: snd bc=$39, key animation, cursor left (to end of previous line when col 0), shift the following words down until D522, zero-terminate, redraw + upload; called for keyboard code 2 in 6148 |
| 2A:5EF4 | `Profile_ApplyDakuten` | function | CONFIRMED | Keyboard char 814A (dakuten): looks up the char before the cursor in String_Profile_DakutenKana, adds 1 to its trail byte (e.g. 82A9 -> 82AA), clears wRam_C2AD on success, redraws; executed in monkey_camp_tut |
| 2A:5F82 | `String_Profile_DakutenKana` | string | CONFIRMED | 40 kana that take dakuten: hiragana か..ほ then katakana カ..ホ (Shift-JIS, NUL); scanned pairwise by Profile_ApplyDakuten; identical to 2C:4779 and 2F:5F41 |
| 2A:5FD4 | `Profile_ApplyVu` | function | PROBABLE | Dakuten fallback: if the previous char is katakana U (8345) it becomes VU (8394) and the text is redrawn; loops over the dummy table 6081 but compares constants; called when 5EF4 found no kana (wRam_C2AD still $4A) |
| 2A:6087 | `Profile_ApplyHandakuten` | function | PROBABLE | Keyboard char 814B (handakuten): looks up the previous char in String_Profile_HandakutenKana and adds 2 to its trail byte (ha -> pa); twin of Profile_ApplyDakuten; never executed in traces |
| 2A:6132 | `String_Profile_HandakutenKana` | string | PROBABLE | 10 kana that take handakuten (ha hi fu he ho, katakana HA..HO), Shift-JIS NUL; scanned by Profile_ApplyHandakuten; identical to 2C:4929 |
| 2A:6148 | `Profile_KeyboardLoop` | function | CONFIRMED | Runs the kana keyboard of bank 55 (55:5BA2 init, 55:5C8F poll): 0 none, 2 delete (5E23), 7/8 save profile (62C5)+close (55:6559), 9 return, chars: 814A/814B dakuten, else insert (5CD2); exec profile scenarios |
| 2A:617B | `Profile_KeyboardLoop_Poll` | label | CONFIRMED | loop head of Profile_KeyboardLoop: place cursor (590B), sprite tick, poll 55:5C8F with B=1,C=[wRam_C264], dispatch on A |
| 2A:6257 | `Profile_LoadAndDraw` | function | CONFIRMED | Loads nickname (SRAM bank0 $AF40, 16 B) -> D514 and own address ($AF50, 64 B) -> D4C0, draws nickname (5952 at DE=0), address line1 (5A3B, DE=$1000) and line2 (5B27 from D4C9, DE=$1C00), uploads tiles |
| 2A:62C5 | `Profile_SaveToSram` | function | CONFIRMED | Writes D514 (16 B) -> SRAM bank0 $AF40 and D4C0 (64 B) -> $AF50, then 22:501D (bank-0 checksum update); inverse of Profile_LoadAndDraw's loads; called on keyboard exit codes 7/8 |
| 2A:6300 | `Gfx_Profile_Tiles9300` | data | CONFIRMED | 0x40 tiles ($400 B) HDMA'd by Profile_InitScreen (hl=$6300 -> VRAM bank1 $9300); Data_2A_6300 region also holds the next two sets |
| 2A:6700 | `Gfx_Profile_Tiles9700` | data | CONFIRMED | 0x10 tiles ($100 B): Profile_InitScreen HDMA hl=$6700 -> VRAM bank1 $9700 (c=$10) |
| 2A:6800 | `Gfx_Profile_Tiles8800` | data | CONFIRMED | 0x34 tiles ($340 B): Profile_InitScreen HDMA hl=$6800 -> VRAM $8800 (c=$34) |
| 2A:6B40 | `Data_Profile_TilemapAttr` | data | CONFIRMED | 20x18 tilemap + attribute map for the profile screen (00:08EA in Profile_InitScreen, hl=$6B40; screenshot profile_1) |
| 2A:6E10 | `Palette_Profile_Bg` | data | PROBABLE | 64 bytes = 8 BG palettes copied to WRAM D800 by Profile_InitScreen (4F:4000, hl=$6E10); OBJ palettes come from bank 26:7AC0 |
| 2A:6E50 | `Table_Profile_Anims` | table | PROBABLE | Animation entry table (20 entries = 5 anims x4): Profile_InitScreen and 6223 init sprite slots DA30/DA60 from entries at $6E70/$6E80 (00:0A82, bank $2A) |

#### General-DMA helper copies

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:5C3B | `Gfx_StartHDMAAtVBlank_2A_5C3B` | function | CONFIRMED | HL=src DE=dest C=blocks-1: writes rHDMA1-4, waits LY==$8F then $91, starts general DMA (rHDMA5=C&$7F, bit7=0); duplicated per bank (2B:4723/5994/6CD5/7DD0, 2C:4421/669D); also far-called by 2A:7293 |

#### Address book helpers (2A save confirmation, 2C shared)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:6F95 | `AddrBook_SaveConfirm` | function | CONFIRMED | Address-book entry 'save?' confirmation: shows name+address from D514/D4C0 (screen 70AB), waits 15 frames, yes/no 72:4015 DE=$020B; yes -> AddrBook_StoreEditBufferToSlot, A=0; no A=$FF. Far-called by 2F:7F2A; exec addressbook_full |
| 2A:704B | `AddrBook_StoreEditBufferToSlot` | function | CONFIRMED | Slot=[wRam_D726] via Table_AddrBook_SlotAddrs_Store: writes D514 (16 B name) -> slot+0 and D4C0 (64 B address) -> slot+$10 (SRAM bank1), checksum 22:50FC; exec addressbook_full |
| 2A:709F | `Table_AddrBook_SlotAddrs_Store` | table | CONFIRMED | 6 words $A69D..$A82D step $50 = address-book slot bases; indexed by [wRam_D726] in AddrBook_StoreEditBufferToSlot (ld hl,$709F at 705C) |
| 2A:70AB | `AddrBook_SaveConfirm_InitScreen` | function | CONFIRMED | LCD off, palette 75A0->D800, tiles 75E0->$9300 (0x40) and 79E0->$9700 (0x04) with 00:0787, tilemap 7A20, LCD on; B=$FF -> DrawSlot (7187) else DrawEditBuffer (722D); fade-in; exec addressbook_full |
| 2A:7187 | `AddrBook_SaveConfirm_DrawSlot` | function | PROBABLE | B=$FF path of 70AB: slot C (Table_AddrBook_SlotAddrs_SaveConfirm) name/address copied to D514/D4C0 and drawn; never executed in traces (twin of DrawEditBuffer) |
| 2A:7221 | `Table_AddrBook_SlotAddrs_SaveConfirm` | table | PROBABLE | 6 words $A69D..$A82D step $50 read by AddrBook_SaveConfirm_DrawSlot (ld hl,$7221 at 718C) |
| 2A:722D | `AddrBook_SaveConfirm_DrawEditBuffer` | function | CONFIRMED | Draws the entry being saved from the edit buffers: name D514 at (y=4,x=$38) with 72CF, address lines via 2F:54E1/55CD/56B9 (hl=D4C0/D4D0/D4E8), then upload 7293; exec addressbook_full |
| 2A:7293 | `AddrBook_UploadEntryTextTiles` | function | CONFIRMED | Upload of the entry-screen text: D000->$9000 (0x40 tiles), D400->$9400 (0x40), D800->$8800 (0x10) via 2A:5C3B; also far-called by 2F:537B/53E1; exec addressbook_full |
| 2A:72CF | `AddrBook_SaveConfirm_DrawTextLine16` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL in <=16 cells (same body as the other draw-string routines); the name D514 is drawn with DE=$0438 by 722D |
| 2A:738F | `AddrBook_SaveConfirm_DrawTextLine16_BlitGlyphAdvance` | function | CONFIRMED | Helper of 72CF: blit glyph C0A0 via 7F:42C3 and E+=6 |
| 2A:73A3 | `AddrBook_SaveConfirm_DrawTextLine16_BlitBlankAdvance` | function | CONFIRMED | Helper of 72CF: blank pad cell (B=2,C=0) via 7F:42C3, E+=6 |

#### Address-book save confirmation art (2A)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:75A0 | `Palette_AddrSaveConfirm_Bg` | data | PROBABLE | 64 bytes: 70AB copies to WRAM D800 (4F:4000, hl=$75A0, a=$2A) |
| 2A:75E0 | `Gfx_AddrSaveConfirm_Tiles9300` | data | PROBABLE | 0x40 tiles: 70AB HDMA (00:0787) hl=$75E0 -> VRAM bank1 $9300 |
| 2A:79E0 | `Gfx_AddrSaveConfirm_Tiles9700` | data | PROBABLE | 4 tiles: 70AB HDMA hl=$79E0 -> VRAM bank1 $9700 (c=$04) |
| 2A:7A20 | `Data_AddrSaveConfirm_TilemapAttr` | data | PROBABLE | 20x18 tilemap + attribute map: 70AB (00:08EA hl=$7A20); screenshot addressbook_full edit_confirm |

#### Address-book entry screen art of bank 2F stored in 2A/2C

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:7CF0 | `Gfx_AddrBookEntry_Tiles8F00` | data | PROBABLE | 0x0E tiles loaded to VRAM $8F00 by 2F:51C1 (hl=$7CF0, c=$0E): art of the address-book entry view screen (rendered with 2C:7C80: 'アドレスちょう', 'B もどる') |
| 2A:7DD0 | `Gfx_AddrBookEntry_Tiles8000` | data | PROBABLE | 0x0B tiles loaded to VRAM $8000 by 2F:51C1 (hl=$7DD0, c=$0B) |

#### Hypotheses (generic names kept)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2A:4A3D | `String_2A_4A3D` | string | HYPOTHESIS | idea: address-list caption 'アドレスを せんたくしてください' (Please select an address), same text as String_AddrPick_Caption (2C:6704); no reference found in ROM (dead copy?) |
| 2A:4FE0 | `Tiles_2A_4FE0` | data | HYPOTHESIS | idea: 32 tiles byte-identical to the first 512 bytes of 28:4BD0 (shared icon tiles, which SaveSenderAddr_InitScreen loads from bank 28 to $8000); no reference to this copy |
| 2A:6081 | `String_2A_6081` | string | HYPOTHESIS | idea: dummy iteration table (82A4 82A4 00 = 2 pairs) of Profile_ApplyVu: the loop counts its pairs but compares constants 8345/8394; 2F:6040 has identical bytes |
| 2A:7287 | `Table_2A_7287` | table | HYPOTHESIS | idea: 6 SRAM slot bases $A69D..; identical to the referenced sibling tables, no reference found (unused compiler copy) |
| 2A:73BB | `Function_2A_73BB` | function | HYPOTHESIS | idea: unreachable twin of the draw-string routines (prologue ld a,$11 ; ld [C2EE],a = 17 cells) falling into 73C0; no caller (gen. by inlining/dead code) |
| 2A:747B | `Function_2A_747B` | function | HYPOTHESIS | idea: BlitGlyphAdvance helper (blit C0A0 via 7F:42C3, E+=6) of the unreachable 17-cell draw-string twin at 73BB; caller only inside that dead twin |
| 2A:748F | `Function_2A_748F` | function | HYPOTHESIS | idea: BlitBlankAdvance helper (B=2,C=0, 7F:42C3, E+=6) of the unreachable 17-cell twin at 73BB |
| 2A:74A7 | `Function_2A_74A7` | function | HYPOTHESIS | idea: unreachable twin of the draw-string routines (prologue: 25 cells, ld a,$19 ; ld [C2EE],a) falling into 74AC; no caller |
| 2A:7567 | `Function_2A_7567` | function | HYPOTHESIS | idea: BlitGlyphAdvance helper of the unreachable 25-cell draw-string twin at 74A7 |
| 2A:757B | `Function_2A_757B` | function | HYPOTHESIS | idea: BlitBlankAdvance helper of the unreachable 25-cell draw-string twin at 74A7 |

### Bank 2B

#### Mail draft ("written mail") menu (2B:4000)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:4000 | `MailDraft_Menu` | function | CONFIRMED | Menu of the saved draft ('written mail'): 3 icons, caption via 478B. A: c=0 farcall 28:4000 (view), c=1 MailDraft_Edit, c=2 yes/no (72:4015 DE=$0209) then 2D:40DC clears it; B ret $FF. Far-called by 7C:7CA7; exec mail_compose |
| 2B:402B | `MailDraft_Menu_Loop` | label | CONFIRMED | per-frame loop of MailDraft_Menu: sprite tick, VBlank wait, 7D:7BB7, MailDraft_Menu_MoveCursorSprites, then A/B/Left/Right dispatch; executed in mail_compose |
| 2B:420C | `MailDraft_Menu_InitScreen` | function | CONFIRMED | Screen setup: palettes 4E20->D800, 5190->D840, tiles 4E60->$8000 (0x33) and 4880->$9300 (0x2D), tilemap 4B50, icon sprites DA10-DA40 (anims 51D0..), 2D:408F loads draft SRAM->D400.., draws title/name/address, upload, fade-in |
| 2B:43A5 | `MailDraft_Menu_MoveCursorSprites` | function | CONFIRMED | c=0..2: sprite DA10/DA20 positioned at y=$68, x=$10/$40/$70 with anim 2B:5200/5210/5220: the selection frame follows the chosen icon; called every frame from the menu loop |
| 2B:4421 | `MailDraft_DrawTextLine21` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL in <=21 six-pixel cells at pixel (D=y,E=x) into the WRAM-bank2 tile buffer; 420C uses it for title D500 (DE=$1420), address line1 D4C0 ($2420) and line3 D4EC ($3C08) |
| 2B:44E1 | `MailDraft_DrawTextLine21_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailDraft_DrawTextLine21: blit glyph C0A0 via 7F:42C3, E+=6 |
| 2B:44F5 | `MailDraft_DrawTextLine21_BlitBlankAdvance` | function | CONFIRMED | Helper of MailDraft_DrawTextLine21: blank pad cell (B=2,C=0) via 7F:42C3, E+=6 |
| 2B:450D | `MailDraft_DrawTextLine25` | function | CONFIRMED | Same routine with 25 cells; 420C draws the middle address line D4D4 (=D4C0+$14, 24 bytes) at DE=$3008; the 64-byte address is shown as 20/24/20 chars |
| 2B:45CD | `MailDraft_DrawTextLine25_BlitGlyphAdvance` | function | PROBABLE | Helper of MailDraft_DrawTextLine25: blit glyph via 7F:42C3, E+=6 (never executed: the ASCII glyph path calls it too, but the test addresses have <=20 chars so the D4D4 line is empty) |
| 2B:45E1 | `MailDraft_DrawTextLine25_BlitBlankAdvance` | function | CONFIRMED | Helper of MailDraft_DrawTextLine25: blank pad cell via 7F:42C3, E+=6 |
| 2B:45F9 | `MailDraft_DrawTextLine17` | function | CONFIRMED | Same routine with 17 cells; 420C draws the name D514 (16 bytes) at DE=$0208, the banner at the top of the screen |
| 2B:46B9 | `MailDraft_DrawTextLine17_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailDraft_DrawTextLine17: blit glyph via 7F:42C3, E+=6 |
| 2B:46CD | `MailDraft_DrawTextLine17_BlitBlankAdvance` | function | CONFIRMED | Helper of MailDraft_DrawTextLine17: blank pad cell via 7F:42C3, E+=6 |
| 2B:46E5 | `MailDraft_UploadTextTiles` | function | CONFIRMED | Copies the WRAM bank2 tile buffer to VRAM with 4 general DMAs: D000->$9000, D400->$9400, D800->$8800, DC00->$8C00 (0x40 tiles each) via Gfx_StartHDMAAtVBlank_2B_4723 |
| 2B:4743 | `MailDraft_Edit` | function | PROBABLE | Edit flow of the draft: wRam_D524=2, then 2D:65B0 (address entry) -> 2C:4000 (title) -> 2D:4722 (body); $FF from a step returns to the previous step; A=0 done else $FF; called by MailDraft_Menu c=1; exec monkey_camp_rich/tut |
| 2B:478B | `MailDraft_Menu_SetCaption` | function | CONFIRMED | A=icon 0..2: caption string Table_MailDraftMenu_Captions[A+1] rendered with 48:403E into DB40/DC80 and 0x27 tiles copied to VRAM $8B40 (25:538A): bottom bar text |

#### General-DMA helper copies

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:4723 | `Gfx_StartHDMAAtVBlank_2B_4723` | function | CONFIRMED | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F then $91, rHDMA5=C&$7F (general DMA); same body as 2A:5C3B |
| 2B:5994 | `Gfx_StartHDMAAtVBlank_2B_5994` | function | PROBABLE | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F then $91, rHDMA5=C&$7F; same body as 2A:5C3B; only caller is the unused grid screen |
| 2B:6CD5 | `Gfx_StartHDMAAtVBlank_2B_6CD5` | function | CONFIRMED | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F then $91, rHDMA5=C&$7F; same body as 2A:5C3B |
| 2B:7DD0 | `Gfx_StartHDMAAtVBlank_2B_7DD0` | function | CONFIRMED | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F, di, wait LY==$91, rHDMA5=C&$7F, ei; variant of 2A:5C3B |

#### Draft menu strings and art

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:47D0 | `Table_MailDraftMenu_Captions` | table | CONFIRMED | 4 pointers to the caption strings of the draft menu (index A+1 read by MailDraft_Menu_SetCaption; each string 41 bytes, spacing $29) |
| 2B:47D8 | `String_MailDraftMenu_CaptionConfirm` | string | PROBABLE | 'かいたメールを かくにんします' = 'Confirm the written mail'; table index 0 (used only for A=$FF; no caller passes $FF) |
| 2B:4801 | `String_MailDraftMenu_CaptionView` | string | CONFIRMED | 'かいたメールを みることができます' = 'You can view the written mail'; shown for the first icon (screenshot mail_compose s3) |
| 2B:482A | `String_MailDraftMenu_CaptionEdit` | string | CONFIRMED | 'かいたメールを なおします' = 'Edit the written mail'; second icon |
| 2B:4853 | `String_MailDraftMenu_CaptionDelete` | string | CONFIRMED | 'かいたメールを けします' = 'Delete the written mail'; third icon |
| 2B:4880 | `Gfx_MailDraftMenu_Tiles9300` | data | CONFIRMED | 0x2D tiles: MailDraft_Menu_InitScreen HDMA (00:0787) hl=$4880 -> VRAM bank1 $9300 (c=$2D) |
| 2B:4B50 | `Data_MailDraftMenu_TilemapAttr` | data | CONFIRMED | 20x18 tilemap + attribute map: 00:08EA hl=$4B50 in MailDraft_Menu_InitScreen |
| 2B:4E20 | `Palette_MailDraftMenu_Bg` | data | PROBABLE | 64 bytes = 8 BG palettes: 4F:4000 copies to WRAM D800 (bc=$40) in MailDraft_Menu_InitScreen |
| 2B:4E60 | `Gfx_MailDraftMenu_Tiles8000` | data | CONFIRMED | 0x33 tiles: HDMA hl=$4E60 -> VRAM $8000 (c=$33) in MailDraft_Menu_InitScreen |
| 2B:5190 | `Palette_MailDraftMenu_Obj` | data | CONFIRMED | 64 bytes: 4F:4000 copies to WRAM D840 (OBJ palettes) in MailDraft_Menu_InitScreen (hl=$5190) |
| 2B:51D0 | `Table_MailDraftMenu_Anims` | table | PROBABLE | Animation entry table (28 entries = 7 anims x4) used with 00:0A82 by MailDraft_Menu_InitScreen (de=$51D0/$51E0/$51F0/$5200/$5230) and MoveCursorSprites ($5200/$5210/$5220) |

#### Unused received-mail 12-cell grid screen (2B:53C3)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:53C3 | `MailGrid_Screen` | function | PROBABLE | Entry of an unused 'もらったメール' (received mail) 12-cell grid screen: 5448 setup, loop 53C6: A -> far-call MailView_SenderPage then jp MailDraft_Menu, B ret $FF, d-pad 5420-543D; screen rendered from 5FF0; no caller, no trace hit |
| 2B:5420 | `MailGrid_CursorLeft` | function | PROBABLE | Grid cursor Left: c-1 stopped at 0, then MailGrid_ShowCellDetails; d-pad handler of the unused grid screen (hJoyPressedRepeat&$20 at 5402) |
| 2B:5429 | `MailGrid_CursorRight` | function | PROBABLE | Grid cursor Right: c+1 stopped at 11, then MailGrid_ShowCellDetails (hJoyPressedRepeat&$10) |
| 2B:5432 | `MailGrid_CursorUp` | function | PROBABLE | Grid cursor Up: c-4 when c>=4 (4 columns x 3 rows), then MailGrid_ShowCellDetails (hJoyPressedRepeat&$40) |
| 2B:543D | `MailGrid_CursorDown` | function | PROBABLE | Grid cursor Down: c+4 when c<8, then MailGrid_ShowCellDetails (hJoyPressedRepeat&$80) |
| 2B:5448 | `MailGrid_InitScreen` | function | PROBABLE | Setup of the unused grid screen: tiles 59C0/5DC0/6300, palettes 62C0/63F0, tilemap 5FF0, cursor anim 6430 at (y=$14,x=$04), MailGrid_DrawCellIcons, then MailGrid_ShowCellDetails for cell 0; never executed |
| 2B:5523 | `MailGrid_PlaceCursorSprite` | function | PROBABLE | Places cursor sprite DA10 for cell c=0..11 at y=$14/$34/$54, x=$04/$2C/$54/$7C (3 rows x 4 columns); part of the unused grid screen |
| 2B:55E1 | `MailGrid_DrawCellIcons` | function | PROBABLE | For the 12 cells: record flag (SRAM bank0 $A124+i*$12D, +0) 1 -> icon tiles $47.. (MailGrid_DrawCellIcon_Flag1), 2 -> $50.. (Flag2) at the VRAM tilemap address of Table_MailGrid_CellTilemapAddrs; never executed |
| 2B:562B | `Table_MailGrid_CellTilemapAddrs` | table | PROBABLE | 12 words $9861,$9866,$986B,$9870,$98E1,..,$9970 = BG tilemap address of the top-left tile of each grid cell (3x3 icon); indexed by 2*c in MailGrid_DrawCellIcons |
| 2B:5643 | `Table_MailGrid_RecAddrs_Cells` | table | PROBABLE | 12 words $A124+i*$12D = mail record bases; MailGrid_DrawCellIcons reads the flag byte (ld hl,$5643 at 5600) |
| 2B:565B | `MailGrid_DrawCellIcon_Flag1` | function | PROBABLE | Writes tiles $47..$4F as a 3x3 block at HL (VRAM bank0) with attribute $0B in bank1: icon of a cell whose record flag is 1; called by MailGrid_DrawCellIcons |
| 2B:5693 | `MailGrid_DrawCellIcon_Flag2` | function | PROBABLE | Writes tiles $50..$58 as a 3x3 block at HL with attribute $0B: icon of a cell whose record flag is 2; called by MailGrid_DrawCellIcons |
| 2B:56CB | `MailGrid_ShowCellDetails` | function | PROBABLE | For cell c with record flag 1 or 2: date (record+3, 6 BCD bytes -> digit tiles $59+nibble at $99E1..) and name/title (+$C9/+$D9, 12 cells at DE=$0408/$0458); else blanks; uploads tiles; never executed |
| 2B:5814 | `Table_MailGrid_RecAddrs_Details` | table | PROBABLE | 12 words $A124+i*$12D = mail record bases; MailGrid_ShowCellDetails reads flag, date (+3), name (+$C9), title (+$D9) (ld hl,$5814 at 56DE/56F7/5766/5791) |
| 2B:582C | `MailGrid_CopyTextEllipsis` | function | PROBABLE | Copies a string of <=13 bytes from HL to DE; a longer text is cut (2-byte aware) at 8/9/10 chars and ends with SJIS 8163 (ellipsis) + NUL; used by MailGrid_ShowCellDetails before drawing |
| 2B:588B | `MailGrid_DrawTextLine12` | function | PROBABLE | Draw-string routine with 12 cells (name/title of the selected cell) at DE=$0408/$0458 from MailGrid_ShowCellDetails; same body as the other draw-string routines; never executed |
| 2B:594B | `MailGrid_DrawTextLine12_BlitGlyphAdvance` | function | PROBABLE | Helper of MailGrid_DrawTextLine12: blit glyph C0A0 via 7F:42C3, E+=6 |
| 2B:595F | `MailGrid_DrawTextLine12_BlitBlankAdvance` | function | PROBABLE | Helper of MailGrid_DrawTextLine12: blank pad cell (B=2,C=0) via 7F:42C3, E+=6 |
| 2B:5977 | `MailGrid_UploadTextTiles` | function | PROBABLE | Uploads the tile buffer D000 -> VRAM $9000 (0x28 tiles) via Gfx_StartHDMAAtVBlank_2B_5994; called at the end of MailGrid_ShowCellDetails; never executed |
| 2B:59C0 | `Gfx_MailGrid_Tiles9000` | data | PROBABLE | 0x40 tiles: MailGrid_InitScreen HDMA hl=$59C0 -> VRAM bank1 $9000; renders with 5DC0/6300/5FF0 as the 'もらったメール' 4x3 grid |
| 2B:5DC0 | `Gfx_MailGrid_Tiles9400` | data | PROBABLE | 0x23 tiles: MailGrid_InitScreen HDMA hl=$5DC0 -> VRAM bank1 $9400 |
| 2B:5FF0 | `Data_MailGrid_TilemapAttr` | data | PROBABLE | 20x18 tilemap + attribute map of the unused grid screen (00:08EA hl=$5FF0 in MailGrid_InitScreen); rendered: title 'もらったメール', 4x3 cell grid, date labels 年 月 日 時 分 in the bottom bar |
| 2B:62C0 | `Palette_MailGrid_Bg` | data | PROBABLE | 64 bytes: 4F:4000 -> WRAM D800 in MailGrid_InitScreen (hl=$62C0) |
| 2B:6300 | `Gfx_MailGrid_Tiles8000` | data | PROBABLE | 0x0F tiles: MailGrid_InitScreen HDMA hl=$6300 -> VRAM $8000 (c=$0F) |
| 2B:63F0 | `Palette_MailGrid_Obj` | data | PROBABLE | 64 bytes: 4F:4000 -> WRAM D840 (OBJ) in MailGrid_InitScreen (hl=$63F0) |
| 2B:6430 | `Table_MailGrid_Anims` | table | PROBABLE | Animation entry table (4 entries) for the grid cursor sprite: MailGrid_InitScreen 00:0A82 de=$6430 -> slot DA10 |

#### Received mail viewer (2B:6482 sender page, 2B:7B02 body page)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:6482 | `MailView_SenderPage` | function | CONFIRMED | Mail viewer page 1 (sender name, title, address, date), C=mail idx: far-called by 25:475C (mailbox list). A: far-calls page 2 (2B:7B02; $FF back = redisplay page 1, else ret 0); B ret $FF; SELECT far-calls 2A:4000. Exec mail_inbox; screenshot m1_sender |
| 2B:64A7 | `MailView_SenderPage_Loop` | label | CONFIRMED | per-frame loop of the sender page: sprite tick, VBlank, 7D:7BB7, A (body page), B (ret $FF), SELECT (save sender address) dispatch; executed in mail_inbox |
| 2B:65AB | `MailView_SenderPage_InitScreen` | function | CONFIRMED | Loads tiles 6DD0->$9000, 71D0->$9400, 76E0->$8000, palettes 76A0/7860, tilemap 73D0, anims 78A0; draws date (691A), title (record+$D9), name (+$C9), address (+$ED, 3 lines) and uploads the tiles; returns B=mail idx |
| 2B:6863 | `Table_MailView_RecAddrs` | table | CONFIRMED | 12 words $A124+i*$12D = SRAM bank0 mail record bases; 65AB indexes by mail idx and adds $C9 (name), $D9 (title), $ED (address) at 66CD/6717/6756/678C |
| 2B:691A | `MailView_DrawDateTime` | function | CONFIRMED | If record flag (+0) is 1 or 2: 6 BCD bytes at record+3 -> 12 digit tiles ($30+nibble) written to $9801 in VBlank as 4+1+2+1+2+1+2+1+2 cells (YYYY年MM月DD日hh時mm分); screenshot m1_sender '2001年01月27日10時00分' |
| 2B:69AD | `Table_MailView_RecAddrs_DateTime` | table | CONFIRMED | 12 mail record bases read by MailView_DrawDateTime (flag at +0, BCD date at +3; ld hl,$69AD at 692E/6947) |
| 2B:69C5 | `MailView_DrawTextLine20` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL in <=20 cells (a 2-byte glyph is not started on the last cell); used for the title (DE=$1420) and address line1 (DE=$2420) and line3 (DE=$3C08) |
| 2B:6A89 | `MailView_DrawTextLine20_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailView_DrawTextLine20: blit glyph via 7F:42C3, E+=6 |
| 2B:6A9D | `MailView_DrawTextLine20_BlitBlankAdvance` | function | CONFIRMED | Helper of MailView_DrawTextLine20: blank pad cell via 7F:42C3, E+=6 |
| 2B:6AB5 | `MailView_DrawTextLine24` | function | CONFIRMED | Same routine with 24 cells: address line 2 (record+$ED+$14.., DE=$3008), drawn only if byte 19 of the address (last cell of line 1) is non-zero |
| 2B:6B7A | `MailView_DrawTextLine24_BlitGlyphAdvance` | function | PROBABLE | Helper of MailView_DrawTextLine24: blit glyph via 7F:42C3, E+=6 (never executed) |
| 2B:6B8E | `MailView_DrawTextLine24_BlitBlankAdvance` | function | CONFIRMED | Helper of MailView_DrawTextLine24: blank pad cell via 7F:42C3, E+=6 |
| 2B:6BA6 | `MailView_DrawTextLine16` | function | CONFIRMED | Same routine with 16 cells: sender name (record+$C9) at DE=$0220 (red banner 'ともだち より' in screenshot m1_sender) |
| 2B:6C6B | `MailView_DrawTextLine16_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailView_DrawTextLine16: blit glyph via 7F:42C3, E+=6 |
| 2B:6C7F | `MailView_DrawTextLine16_BlitBlankAdvance` | function | CONFIRMED | Helper of MailView_DrawTextLine16: blank pad cell via 7F:42C3, E+=6 |
| 2B:6C97 | `MailView_UploadTextTiles` | function | CONFIRMED | 4 general DMAs D000->$9000, D400->$9400, D800->$8800, DC00->$8C00 (0x40 tiles each) via Gfx_StartHDMAAtVBlank_2B_6CD5 |
| 2B:6DD0 | `Gfx_MailView_Tiles9000` | data | PROBABLE | 0x40 tiles: MailView_SenderPage_InitScreen HDMA (00:0749) hl=$6DD0 -> VRAM bank1 $9000 |
| 2B:71D0 | `Gfx_MailView_Tiles9400` | data | PROBABLE | 0x20 tiles: HDMA hl=$71D0 -> VRAM bank1 $9400 in MailView_SenderPage_InitScreen |
| 2B:73D0 | `Data_MailView_TilemapAttr` | data | PROBABLE | 20x18 tilemap + attribute map: 00:08EA hl=$73D0 in MailView_SenderPage_InitScreen; screenshot m1_sender |
| 2B:76A0 | `Palette_MailView_Bg` | data | PROBABLE | 64 bytes: 4F:4000 -> WRAM D800 in MailView_SenderPage_InitScreen |
| 2B:76E0 | `Gfx_MailView_Tiles8000` | data | PROBABLE | 0x18 tiles: HDMA hl=$76E0 -> VRAM $8000 in MailView_SenderPage_InitScreen |
| 2B:7860 | `Palette_MailView_Obj` | data | PROBABLE | 64 bytes: 4F:4000 -> WRAM D840 in MailView_SenderPage_InitScreen |
| 2B:78A0 | `Table_MailView_Anims` | table | PROBABLE | Animation entry table (32 entries) used with 00:0A82 by MailView_SenderPage_InitScreen (de=$78A0 -> slot DA30, $78C0 -> DA10) |
| 2B:7B02 | `MailView_BodyPage` | function | CONFIRMED | Mail viewer page 2 (body text, 8 lines x 24 cells), B=mail idx: called from MailView_SenderPage (far call 2B:64E4); A -> ret 0, B -> ret $FF (both end up back at the mailbox list in the caller 25:475C); exec mail_inbox; screenshot m1_body |
| 2B:7B2A | `MailView_BodyPage_Loop` | label | CONFIRMED | per-frame loop of the body page: sprite tick, VBlank, 7D:7BB7, A (ret 0) / B (ret $FF); executed in mail_inbox |
| 2B:7B9B | `MailView_BodyPage_InitScreen` | function | CONFIRMED | Uses bank-28 art (tiles 28:42C0/44D0, tilemap 28:4550, palettes 28:4AF0/4B30); sets record flag +0 := 2 (SRAM bank0, then 22:501D checksum), copies record+9 ($C0 B body) to D400, draws 8 lines (7EE0 + 7DF2), upload |
| 2B:7D7A | `Table_MailView_BodyPage_RecAddrs` | table | CONFIRMED | 12 words $A124+i*$12D = mail record bases read by MailView_BodyPage_InitScreen (ld hl,$7D7A at 7C45/7C76): flag at +0, body at +9 |
| 2B:7D92 | `MailView_BodyPage_UploadTextTiles` | function | CONFIRMED | 4 general DMAs D000->$9000, D400->$9400, D800->$8800, DC00->$8C00 (0x40 tiles each) via Gfx_StartHDMAAtVBlank_2B_7DD0 |
| 2B:7DF2 | `MailView_BodyPage_DrawTextLine24` | function | CONFIRMED | Draw NUL/$0D-terminated Shift-JIS at HL in <=24 cells (one line of the body; stops before a 2-byte glyph on the last cell); called per line at y=0,12,..,84 x=8 |
| 2B:7EB4 | `MailView_BodyPage_DrawTextLine24_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailView_BodyPage_DrawTextLine24: blit glyph via 7F:42C3, E+=6 |
| 2B:7EC8 | `MailView_BodyPage_DrawTextLine24_BlitBlankAdvance` | function | CONFIRMED | Helper of MailView_BodyPage_DrawTextLine24: blank pad cell via 7F:42C3, E+=6 |
| 2B:7EE0 | `MailView_BodyPage_FindLine` | function | CONFIRMED | B=line index: HL=start of line B in the D400 body buffer (a line ends at $0D or after 24 cells; 7F:41A7 tells 2-byte chars), D=$FF if the text ends earlier; 7B9B calls it for lines 0..7 |

#### Hypotheses (generic names kept)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2B:57B5 | `String_2B_57B5` | string | HYPOTHESIS | idea: 'そうしんしゃ' (sender) then 'あそぼう' (Let's play): no reference found; text of the unexecuted grid screen? |
| 2B:64F1 | `Function_2B_64F1` | function | HYPOTHESIS | idea: 'delete this mail?' prologue+flow: yes/no 72:4015 DE=$0206 then 2D:4133 (record delete/shift); falls into the far-call site at 6500; no caller found (unreachable) |
| 2B:687C | `Function_2B_687C` | function | HYPOTHESIS | idea: cursor-sprite switch for c=0..3: DA10/DA20 at y=$68, x=$10/$30/$50/$70 with anims $78D0/$7910/$78E0/$78F0 of Table_MailView_Anims; twin of MailDraft_Menu_MoveCursorSprites; no caller found |
| 2B:6CF5 | `Function_2B_6CF5` | function | HYPOTHESIS | idea: unreachable twin of Mailbox_ReplyToRecord (25:54A7): D400 cleared ($24 B here, $124 B there), record+$ED[64]->D4C0, +$C9[16]->D514, wRam_D524=3 (2B:6D5D), then 2D:65B0/2C:4000/2D:4722; no caller found |
| 2B:6DB0 | `Table_2B_6DB0` | table | HYPOTHESIS | idea: 12 mail record bases read by Function_2B_6CF5 (record+$ED address, +$C9 name copied to D4C0/D514); unexecuted |

### Bank 2C

#### Mail title entry (2C:4000)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:4000 | `MailTitle_Entry` | function | CONFIRMED | Mail title entry, A=0 (A opens keyboard) or 1 (keyboard open at once): edits D500 (20 B = 10 kana) with the bank-55 keyboard; ret A=0 on OK, $FF on B. Far-called by 2D:4027, 25:5536, 2B:476E/6D7C; exec mail_compose; shot subj_typed |
| 2C:4042 | `MailTitle_Entry_Loop` | label | CONFIRMED | per-frame loop of MailTitle_Entry (keyboard closed): sprite tick, VBlank, 7D:7BB7, cursor sprites (42EB); A opens the keyboard (493F), B leaves, Left/Right (40C1) move the text cursor; executed |
| 2C:40D4 | `MailTitle_CursorLeft` | function | CONFIRMED | Left handler (hJoyPressedRepeat&$20 at 40C1): snd bc=$36, c-1 (mirrored to wRam_C0D2); at column 0 of a later line jumps to the end of the previous line (MailTitle_CharPtr); exec monkey_camp_reg2/rich |
| 2C:40FB | `MailTitle_CursorRight` | function | CONFIRMED | Right handler (hJoyPressedRepeat&$10 at 40C1): snd bc=$36 then falls into MailTitle_MoveCursorRight; exec monkey_camp_reg2 |
| 2C:410F | `MailTitle_MoveCursorRight` | function | CONFIRMED | Advance the text cursor one char: not past line 7/col 11, col 0 needs a non-empty line, $0D -> next line col 0, else col++ wrapping at 12 (mirrored in wRam_C0D2); MailTitle_Entry calls it 10x to reach the text end |
| 2C:414C | `MailTitle_InitScreen` | function | CONFIRMED | Setup (A=1 also opens the keyboard: 55:5BA2 A=8,B=2): tiles 4A30->$9300 (0x40), 5410->$8800 (0x26), 5140->$8000 (0x2D), palettes 5100 (BG) 5670 (OBJ), tilemap 4E30, cursor sprites, draws title D500 at DE=$0420; exec mail_compose |
| 2C:42EB | `MailTitle_PlaceTextCursor` | function | CONFIRMED | B=line,C=col: cursor sprites (slots +16/+32): y=$38+12*B-[C0D3], x=$20+12*C; called after every cursor move |
| 2C:431D | `MailTitle_DrawTextLine` | function | CONFIRMED | Draw NUL-terminated Shift-JIS at HL (D500 title, DE=$0420) in <=20 six-pixel cells at pixel (D=y,E=x) into the WRAM-bank2 tile buffer (7F:4007/405F/42C3), pads, 7F:4C42; exec mail_compose |
| 2C:43D8 | `MailTitle_DrawTextLine_BlitGlyphAdvance` | function | CONFIRMED | Helper of MailTitle_DrawTextLine: blit glyph C0A0 via 7F:42C3, E+=6 |
| 2C:43EC | `MailTitle_DrawTextLine_BlitBlankAdvance` | function | CONFIRMED | Helper of MailTitle_DrawTextLine: blank pad cell (B=2,C=0) via 7F:42CA (no style transform), E+=6 |
| 2C:4404 | `MailTitle_UploadTextTiles` | function | CONFIRMED | Copies the tile buffer D000 (WRAM bank2) -> VRAM $9000, 0x28 tiles, via Gfx_StartHDMAAtVBlank_2C_4421; called after each redraw of the title |
| 2C:4441 | `MailTitle_CharPtr` | function | CONFIRMED | B=line,C=col: HL=pointer to the 2-byte char at that position of the D500 buffer via MailTitle_FindLine, A=char byte, $0D at newline, $FF/D=$FF beyond the text (twin of Profile_CharPtr) |
| 2C:4475 | `MailTitle_FindLine` | function | CONFIRMED | B=line: HL=start of line B in D500 (lines end at $0D or 12 chars, 2 bytes/char), D=$FF if the text ends earlier, E=line length; ends with [rRAMG]=0 (twin of Profile_FindLine) |
| 2C:44B8 | `MailTitle_InsertChar` | function | CONFIRMED | DE=char (D=lead,E=trail; from wRam_C2AE/C2AD): if the last cell D512 is used -> snd bc=$31, return; else key animation, shift words up from D510, store D,E at the cursor, redraw + upload, cursor right; exec mail_compose |
| 2C:4612 | `MailTitle_DeleteChar` | function | CONFIRMED | Backspace: snd bc=$39, key animation, cursor left, shift the following words down until D512, zero-terminate, redraw + upload; executed in several scenarios |
| 2C:46EB | `MailTitle_ApplyDakuten` | function | PROBABLE | Keyboard char 814A (dakuten): previous char looked up in String_MailTitle_DakutenKana (2C:4779), +1 on its trail byte; byte-identical twin of Profile_ApplyDakuten; never executed here |
| 2C:4779 | `String_MailTitle_DakutenKana` | string | PROBABLE | 40 kana that take dakuten (hiragana ka..ho, katakana KA..HO), Shift-JIS NUL; scanned by MailTitle_ApplyDakuten; identical to 2A:5F82 and 2F:5F41 |
| 2C:47CB | `MailTitle_ApplyVu` | function | PROBABLE | Dakuten fallback: previous char katakana U (8345) -> VU (8394); twin of Profile_ApplyVu; never executed here |
| 2C:487E | `MailTitle_ApplyHandakuten` | function | PROBABLE | Keyboard char 814B (handakuten): previous char looked up in String_MailTitle_HandakutenKana, +2 on its trail byte; twin of Profile_ApplyHandakuten; never executed here |
| 2C:4929 | `String_MailTitle_HandakutenKana` | string | PROBABLE | 10 kana that take handakuten (ha hi fu he ho, katakana HA..HO), Shift-JIS NUL; identical to 2A:6132 |
| 2C:493F | `MailTitle_OpenKeyboard` | function | CONFIRMED | Opens the kana keyboard (55:5BA2 with A=8; D824 cleared/set around it) and falls into MailTitle_KeyboardLoop; called when A is pressed in MailTitle_Entry; exec mail_compose |
| 2C:4972 | `MailTitle_KeyboardLoop` | function | CONFIRMED | Polls 55:5C8F: 0 again, 9 return, 7 return (OK), 2 backspace (4A05 length; empty text at (0,0) closes the keyboard via 49E9), 8 close, chars 814A/814B dakuten, else insert (44B8); exec mail_compose |
| 2C:4A05 | `MailTitle_GetLength` | function | CONFIRMED | Counts the non-zero bytes of D500 up to $14: A = length of the title buffer; used by the backspace key to decide whether to close the keyboard |
| 2C:4A30 | `Gfx_MailTitle_Tiles9300` | data | CONFIRMED | 0x40 tiles: MailTitle_InitScreen HDMA (00:0749) hl=$4A30 -> VRAM bank1 $9300 (c=$40) |
| 2C:4E30 | `Data_MailTitle_TilemapAttr` | data | CONFIRMED | 20x18 tilemap + attribute map: 00:08EA hl=$4E30 in MailTitle_InitScreen (2C:41CE) |
| 2C:5100 | `Palette_MailTitle_Bg` | data | PROBABLE | 64 bytes: 4F:4000 -> WRAM D800 (bc=$40) in MailTitle_InitScreen (the region's last 16 bytes 5140.. are the first tile) |
| 2C:5140 | `Gfx_MailTitle_Tiles8000` | data | CONFIRMED | 0x2D tiles: MailTitle_InitScreen HDMA hl=$5140 -> VRAM $8000 (c=$2D) |
| 2C:5410 | `Gfx_MailTitle_Tiles8800` | data | CONFIRMED | 0x26 tiles: MailTitle_InitScreen HDMA hl=$5410 -> VRAM $8800 (c=$26) |
| 2C:5670 | `Palette_MailTitle_Obj` | data | CONFIRMED | 64 bytes: 4F:4000 -> WRAM D840 (OBJ palettes) in MailTitle_InitScreen (2C:41AC) |

#### General-DMA helper copies

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:4421 | `Gfx_StartHDMAAtVBlank_2C_4421` | function | CONFIRMED | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F then $91, rHDMA5=C&$7F; same body as 2A:5C3B |
| 2C:669D | `Gfx_StartHDMAAtVBlank_2C_669D` | function | CONFIRMED | HL=src DE=dest C=blocks-1: rHDMA1-4, wait LY==$8F then $91, rHDMA5=C&$7F; same body as 2A:5C3B |

#### Address picker (2C:56FE)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:56F2 | `Table_AddrPick_SlotAddrs` | table | CONFIRMED | 6 words $A69D..$A82D step $50 = address-book slot bases (SRAM bank1): name[16] at +0, address[64] at +$10; read by 57F1 (ld hl,$56F2 at 5823/5868) and 6032 (6050/6080); dead twins 5CA3/5FB1/60B3 too |
| 2C:56FE | `AddrPick_Menu` | function | CONFIRMED | List of the 6 address-book slots ('アドレスを せんたくしてください'): Up/Down (c=1..6), A copies the slot (name -> D514, address -> D4C0) via 57F1 and returns A=1, B returns $FF. Far-called by 2D:67DA; exec monkey/tutorial |
| 2C:5721 | `AddrPick_Menu_Loop` | label | CONFIRMED | per-frame loop of AddrPick_Menu: sprite tick, VBlank, 7D:7BB7, A (57F1 load slot) / B (ret $FF) / Up-Down (hJoyPressedRepeat &$40/$80 at 5794) dispatch |
| 2C:57A7 | `AddrPick_CursorDown` | function | CONFIRMED | Down handler (hJoyPressedRepeat&$80): snd bc=$29, c=(c+1), 7->1; old slot name/highlight redrawn by 6032 and icons by 620D; executed in monkey/tutorial scenarios |
| 2C:57CC | `AddrPick_CursorUp` | function | PROBABLE | Up handler (hJoyPressedRepeat&$40): snd bc=$29, c-1, 0->6, then 6032 + 620D; mirror of AddrPick_CursorDown; never executed in traces |
| 2C:57F1 | `AddrPick_LoadSelection` | function | CONFIRMED | Slot C (1-based): SRAM bank1 slot base from Table_AddrPick_SlotAddrs, empty (+$10==0) -> snd bc=$31, A=0; else address (+$10,64 B) -> D4C0, name (+0,16 B) -> D514, snd $2C, A=1; C=0 clears both (dead path) |
| 2C:58AC | `AddrPick_InitScreen` | function | CONFIRMED | Setup: palettes 2C:71D0->D840 and 6F90->D800, tiles 6C30->$8F00, 6730->$9300, 6B30->$9700, bank28 4BD0->$8000 and 4FD0->$8400, tilemap 6CC0, caption 66BD, upload 665F, list attrs 5E51, slot icons/names |
| 2C:5E51 | `AddrPick_InitListAttrs` | function | PROBABLE | Writes BG attribute bytes of the list area (VRAM bank1 $9866.. and the WRAM7 copy D466..): 13-tile rows $9866/$9886 = $0C, rows $98C6..$99C6 = $00; called by AddrPick_InitScreen (and by 6032 only for old slot index 0, never) |
| 2C:6032 | `AddrPick_MoveNameHighlight` | function | CONFIRMED | A=old slot, C=new slot (1-based): old name redrawn normal (B=3,C=0) and new highlighted (B=0,C=1) via AddrBook_DrawSlotName at x=$30, y=12*slot, then upload 665F; twin of SaveSenderAddr_MoveNameHighlight |
| 2C:620D | `AddrPick_RefreshSlotIcons` | function | CONFIRMED | For the 6 slots sets sprite slots DA70..DA20 to the empty-icon anim (bank28 table 5220) or used-icon anim (5230, per 64A5), the cursor slot uses 2C:7240/7250; sets y/x, on Up/Down calls 64E0; twin of 2A:4573 |
| 2C:64A5 | `AddrPick_IsSlotUsed` | function | CONFIRMED | A=slot 0..5: SRAM bank1, hl=Table_AddrPick_SlotAddrs_Icons[A]+$10; returns A=0 if that byte !=0 (used) else $FF; twin of SaveSenderAddr_IsSlotUsed |
| 2C:64D4 | `Table_AddrPick_SlotAddrs_Icons` | table | CONFIRMED | 6 words $A69D..$A82D step $50 read by AddrPick_IsSlotUsed (ld hl,$64D4 at 64BB) |
| 2C:64E0 | `AddrPick_CursorMoveEffect` | function | PROBABLE | Called at the end of AddrPick_RefreshSlotIcons when hJoyPressed&$C0 (Up/Down): re-inits the cursor slot icon with anim bank28 5240/5250, sets its y/x, waits until Up/Down released; twin of SaveSenderAddr_CursorMoveEffect. Executed via AddrPick_InitScreen, which forces hJoyPressed=$80 before its first refresh |
| 2C:66BD | `AddrPick_LoadCaption` | function | CONFIRMED | Renders the caption string Table_AddrPick_Captions[0] with 48:403E into DB40/DC80 and copies 0x27 tiles to VRAM $8B40 (25:538A): bottom-bar text 'Please select an address' |
| 2C:6702 | `Table_AddrPick_Captions` | table | CONFIRMED | 1 pointer ($6704) to the caption string; read by AddrPick_LoadCaption (ld hl,$6702 at 66C5) |
| 2C:6704 | `String_AddrPick_Caption` | string | PROBABLE | '　　アドレスを　せんたくしてください　　' = 'Please select an address' (28 chars); caption of the address picker; loaded by AddrPick_LoadCaption |
| 2C:6730 | `Gfx_AddrPick_Tiles9300` | data | CONFIRMED | 0x40 tiles: AddrPick_InitScreen HDMA (00:0787) hl=$6730 -> VRAM bank1 $9300 |
| 2C:6B30 | `Gfx_AddrPick_Tiles9700` | data | CONFIRMED | 0x10 tiles: AddrPick_InitScreen HDMA hl=$6B30 -> VRAM bank1 $9700 (c=$10) |
| 2C:6CC0 | `Data_AddrPick_TilemapAttr` | data | CONFIRMED | 20x18 tilemap + attribute map: 00:08EA hl=$6CC0 in AddrPick_InitScreen (2C:595A) |
| 2C:6F90 | `Palette_AddrPick_Bg` | data | CONFIRMED | 64 bytes (regions 6F90/6F9E/6FCE): AddrPick_InitScreen 4F:4000 -> WRAM D800 (hl=$6F90) |

#### Address book helpers (2A save confirmation, 2C shared)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:614D | `AddrBook_DrawSlotName` | function | CONFIRMED | HL=slot base (SRAM bank1, name[16] at +0), D=y, E=x px, B/C passed on to 7F:42C3 as style (3,0 normal / 0,1 highlighted): draws the name in <=16 cells (7F:4007/405F/42C3); used by 2A:422C/4280 and 2F screens |
| 2C:61F9 | `AddrBook_DrawSlotName_BlitGlyphAdvance` | function | CONFIRMED | Helper of AddrBook_DrawSlotName: blit glyph C0A0 via 7F:42C3, E+=6 |
| 2C:665F | `AddrBook_UploadTextTiles` | function | CONFIRMED | Copies the WRAM bank2 tile buffer to VRAM (D000->$9000, D400->$9400, D800->$8800 0x40 tiles each, DC00->$8C00 0x30) via Gfx_StartHDMAAtVBlank_2C_669D; far-called by 2A:4027/4105/42F6 and 2F address-book screens |
| 2C:6C30 | `Gfx_AddrBook_Tiles8F00` | data | CONFIRMED | 9 tiles loaded to VRAM $8F00 by AddrPick_InitScreen (c=$09) and by 2F:4572 (another address-book screen): shared by both |
| 2C:71D0 | `Palette_AddrBook_Obj` | data | CONFIRMED | 64-byte OBJ palette block copied to WRAM D840 by SaveSenderAddr_InitScreen (2A:4105), AddrPick_InitScreen and several 2F address-book screens |

#### Address slot icons

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:7210 | `Table_AddrSlotIcon_Anims` | table | PROBABLE | Animation entry table of the slot icons (00:0A82): groups $7240 (cursor slot, empty) and $7250 (cursor slot, used) used by 2C:620D and 2A:4573; $7220/$7230 only by the dead twin 5A12 (live code takes empty/used icons from bank 28 5220/5230) |

#### Address-book entry screen art of bank 2F stored in 2A/2C

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:7C80 | `Data_AddrBookEntry_TilemapAttr` | data | PROBABLE | 20x18 tilemap + attribute map read by 00:08EA in 2F:51C1 (hl=$7C80, a=$2C); rendered: 'アドレスちょう', labels ニックネーム/アドレス, 'B もどる' = the address-book entry view screen |
| 2C:7F50 | `Palette_AddrBookEntry_Bg` | data | CONFIRMED | 64-byte BG palette block copied to D800 by 2F:51C1 (hl=$7F50, a=$2C) |
| 2C:7F90 | `Palette_AddrBookEntry_Obj` | data | CONFIRMED | 64-byte OBJ palette block copied to D840 by 2F:51C1 (hl=$7F90, a=$2C) |

#### Hypotheses (generic names kept)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 2C:4878 | `String_2C_4878` | string | HYPOTHESIS | idea: dummy iteration table (82A4 82A4 00 = 2 pairs) of MailTitle_ApplyVu: the loop counts its pairs but compares constants 8345/8394; identical bytes at 2F:6040 |
| 2C:5A12 | `Function_2C_5A12` | function | HYPOTHESIS | idea: dead twin of AddrPick_RefreshSlotIcons using table 7220-7250 and 5CA3 for the used test; falls into the far-call site at 5A25; no caller found |
| 2C:5CA3 | `Function_2C_5CA3` | function | HYPOTHESIS | idea: IsSlotUsed twin (Table_AddrPick_SlotAddrs) called only by the dead twin at 5A25; A=0 used, $FF empty |
| 2C:5CD2 | `Function_2C_5CD2` | function | HYPOTHESIS | idea: alternate list-attribute writer ($08 rows $9866/$9886, $04 rows $98C6..$99C6 in VRAM bank1 and the WRAM7 copy): only reached for cursor index 0, but the picker cursor is 1-based, so unreached |
| 2C:5FB1 | `Function_2C_5FB1` | function | HYPOTHESIS | idea: dead twin of AddrPick_MoveNameHighlight drawing names at x=$28 (used by the 2A-style list); no caller found |
| 2C:60B3 | `Function_2C_60B3` | function | HYPOTHESIS | idea: dead twin of SaveSenderAddr_DrawSlotNames: draws the 6 slot names at x=$28 with 614D; no caller found |
| 2C:741C | `Function_2C_741C` | function | HYPOTHESIS | idea: entry (call 746F) of an unused screen: draws 3 address lines (D4C0/D4D4/D4EC) under a rendered header 'みる < START > かく', waits 60 frames, yes/no 72:4015 DE=$0204, A=0 yes/$FF; no caller |
| 2C:746F | `Function_2C_746F` | function | HYPOTHESIS | idea: screen setup of the unused address screen (rendered: header みる/START/かく over 3 text boxes): tiles 7740/7B70, tilemap 7860, palettes 7B30/7C00, anims 7C40, text via 755C/7648 |
| 2C:755C | `Function_2C_755C` | function | HYPOTHESIS | idea: draw-string routine with 21 cells for the D4C0 address line of the unexecuted confirmation screen 746F (DE=$0420); helpers 761C/7630 |
| 2C:761C | `Function_2C_761C` | function | HYPOTHESIS | idea: BlitGlyphAdvance helper of Function_2C_755C (blit via 7F:42C3, E+=6) |
| 2C:7630 | `Function_2C_7630` | function | HYPOTHESIS | idea: BlitBlankAdvance helper of Function_2C_755C |
| 2C:7648 | `Function_2C_7648` | function | HYPOTHESIS | idea: draw-string routine with 25 cells for the D4D4 address line of the unexecuted confirmation screen (DE=$1008); helpers 7708/771C |
| 2C:7708 | `Function_2C_7708` | function | HYPOTHESIS | idea: BlitGlyphAdvance helper of Function_2C_7648 |
| 2C:771C | `Function_2C_771C` | function | HYPOTHESIS | idea: BlitBlankAdvance helper of Function_2C_7648 |
| 2C:7740 | `Data_2C_7740` | data | HYPOTHESIS | idea: 0x12 tiles of the unexecuted confirmation screen: 746F HDMA hl=$7740 -> VRAM bank1 $9300; 7B70 (9 tiles -> $8000), tilemap 7860, palettes 7B30/7C00 |


## 4. Hypotheses and dead code (generic names kept, idea in the evidence column)

* **Unused 'もらったメール' (received mail) grid, 2B:53C3-5994 (`MailGrid_*`, PROBABLE names)**: rendering the tilemap 2B:5FF0 with the tiles/palettes loaded by `MailGrid_InitScreen` gives the title banner
  'もらったメール' (received mail), a 4 x 3 grid of cells and a bar with the date labels 年 月 日 時 分; the code draws a 3x3 icon per record according to its flag (1 or 2), the date, name and title of the selected cell,
  the d-pad moves the cell (4 columns), A far-calls `MailView_SenderPage` and then jumps to `MailDraft_Menu`, B returns $FF.  No caller and no trace hit: an abandoned earlier mailbox UI (the real list is bank 25).
* **Delete-mail flow 2B:64F1** (yes/no `72:4015 DE=$0206`, then `2D:4133` = delete record and shift the rest): unreachable copy of what bank 25 does from its list.
* **Reply compose twin 2B:6CF5** of `Mailbox_ReplyToRecord` 25:54A7 (which clears $124 bytes of D400, this copy only $24; copies record+$ED / +$C9 to D4C0/D514, sets D524=3, runs address -> title -> body) and cursor-sprite switch 2B:687C: unreachable.
* **Twins in 2C**: 5A12 (icon refresh at table 7220-7250), 5CA3, 5FB1, 60B3 (slot-name drawing at x=$28) belong to a copy of the 2A save-slot list; 741C/746F/755C/7648 draw a 3-line address confirmation
  (`72:4015 DE=$0204`, tiles 7740/7B70, tilemap 7860, palettes 7B30/7C00, anims 7C40) that no code calls.
* **Dead draw-string variants in 2A** (73BB 17 cells, 74A7 25 cells, with helpers) and in 2B (588B, 12 cells).
* **Dummy tables** 2A:6081 and 2C:4878 (`82A4 82A4 00`) only give the iteration count of the U -> VU loop; the strings 2A:4A3D and 2B:57B5 have no reference at all, 2B:5807 (six full-width blanks) is only used by the dead grid code (2B:57CB).
* **`String_2A_4A3D`** carries the same caption as `String_AddrPick_Caption`; no code loads it.
* The code of the entire 2A animation block 5220-5495 is not referenced from bank 2A (2A:4573 loads its icon animations from **bank 28** table 5220, and 2C:7220-7250); it may be a leftover copy or used by a bank not scanned (no `ld de,$5220` with `a=$2A` exists in the ROM).

## 5. Observations for the other stages

* **Region mistypes** (not fixed here, `config/regions` belongs to another stage): `2A:4A66-4A6C` is a `ptrtable` but the bytes are the first strings of the five 9-byte caption chunks 4A66-4A93 (loaded by
  `ld hl,$4A66/$4A6F/$4A78/$4A81/$4A8A` in 2A:49C5); a `text` region 4A66-4A93 would be correct.  `2C:5100-5150` is a palette followed by the first tile of the block at 5140 (a symbol splits it, bytes unchanged);
  `2C:6F90-6FD0` is one 64-byte palette (three regions); `2C:6702` is a 1-word pointer table to 6704 (`Table_AddrPick_Captions`), typed `data`.
* **Original bug**: `Profile_CursorLeft` (2A:5744) calls `$4441` (the address of `MailTitle_CharPtr` in bank 2C, i.e. an unlinked copy of the routine); in bank 2A that address is the middle of
  `ld a,$00` in `SaveSenderAddr_SaveToSlot` (code_map.md records it as an instruction-skipping entry).  It only runs when the cursor is at column 0 of a line >0, which the 8-kana nickname presumably never reaches.
* `Profile_MoveCursorRight` clamps at column 8 (nickname of 8 kana) while `Profile_InsertChar` advances with the 12-column wrap of the multi-line editors: the profile code is the multi-line
  editor code with a single-line limit patched into some places only.
* `AddrBook_DrawSlotName` and `AddrBook_UploadTextTiles` are library routines shared by banks 2A, 2C and 2F; 2F's own screens also use `2A:7293`, `2A:5C3B`, and the palettes/tiles listed as `Gfx_AddrBookEntry_*`, `Palette_AddrBookEntry_*`, `Palette_AddrBook_Obj`, `Gfx_AddrBook_Tiles8F00`.
* Text-field widths of the received mail viewer: title 20 cells, sender name 16, address 20+24+20 (64 bytes split at bytes 20 and 44, the 2nd/3rd line only if the previous line is full).

### Hand-off notes for the passes that own the neighbouring banks

* `28:4550` is the tilemap of the **received-mail body page** ('A つぎへ', rendered) loaded by `MailView_BodyPage_InitScreen`; bank 28's own draft-body screen uses `28:4820` ('B もどる'); `28:4550` has no symbol yet (palettes `28:4AF0/4B30` and tiles `28:42C0/44D0` are shared by both).
* `2F:51C1` is the **address-book entry view screen** (rendered from `2C:7C80` + `29:5E50/6250` + `2A:7CF0/7DD0`: 'アドレスちょう', ニックネーム, アドレス, 'B もどる'); `2A:7293` and `2A:5C3B` are also called from 2F.
* `2D:65B0` is the mail **address entry** screen (SELECT far-calls `AddrPick_Menu`, then re-enters itself), `2D:4722` the **body entry**, `2D:408F/403C/40DC` load/store/clear the draft (SRAM `A000-A123`).
* `22:501D` = recompute + store the bank-0 page checksum and refresh the mirror page; `22:50FC` = recompute + store the bank-1 checksum (`A8D7`); both are called after every SRAM write of these banks.
* `4F:4000` copies BC bytes ROM->WRAM (palette staging D800/D840), `4F:404B` uploads D800 to BCPS/OCPS, `4F:4370` / `4F:42B4` are the palette ramps around each screen.
* `7F:41EA` is a 16-entry handler table indexed by the glyph style (B,C), `7F:7271` installs the STAT split (`00:0E93`, LYC=[D724]), `7F:72B0` removes it, `7F:624F/627C` copy the sprite table `DA00-DAFF` to/from `D900` (bank 3) around dialogs.

## 6. Open questions

* Meaning of record bytes `+01..02` and of the flag values (1 = new?, 2 = read is likely from `MailView_BodyPage_InitScreen` writing 2, not proven; no constant was defined).
* What the style parameters `B`/`C` of `7F:42C3` produce exactly (outline/shadow variants of the 12-row glyph, table `7F:42A3`); the code only shows (3,0) = normal and (0,1) = highlighted row in the address lists, (2,0) for padding.
* The sound-call constants (section 2.6) are contexts, not verified sound ids; `00:20E8` (`BC` = 4..$F at the end of each set-up) is unexplained.
* `Function_2D_65B0` / `2D:4722` (address and body entry) and `Function_28_4000` (view of the draft) are outside these banks; the roles used in the flow diagram come from the screenshots.
* Animation data (Table_*_Anims, OAM frame lists, scripts, ~150 generic labels such as `Data_2B_5244`) were not individually named: the sprite object format (`00:0AE8`) is still a HYPOTHESIS.

## 6b. Adversarial review (verifier pass)

Re-derived independently from the ROM bytes, `src/` listings, `traces/coverage_*.tsv` (function-level executed sets) and the screenshots; the screens of `MailGrid_*` (unused grid) and the profile/draft/viewer screens were re-rendered from tilemap + tiles + palette.  Result: all 30+ checked semantic names survive (callers 25:475C, 2B:64E4/659F, 7C:7CA7/7CED, 48:4A0B, 2F:7F2A, 2D:67DA, 2D:4027, 25:5536, 2B:476E re-scanned as `call $06D1` sites; record layout, slot tables, tile/palette loads, string decodes, twin/dummy-table byte equalities, status vs coverage all match).  Corrections made:

* Retracted: "A on the body page = next mail" (2B:6482/2B:7B02, doc flow): the caller 25:475C returns to the mailbox list for both results (0 -> `jp 25:4000`, $FF -> list loop); no "next mail" step exists.
* Retracted: "Verified by the screens" for the Up/Down (`&$40/&$80`) handlers in section 2.5: they never execute in a trace; the bit order comes from the rP1 layout.
* `SaveSenderAddr_CursorMoveEffect` / `AddrPick_CursorMoveEffect`: they ran in traces only because the InitScreen routines force `hJoyPressed` ($40 at 2A:4189, $80 in 2C `AddrPick_InitScreen`) before the first refresh, not because a d-pad press was seen; evidence text corrected (status stays PROBABLE).
* `Profile_CursorLeft` upgraded to CONFIRMED (executed in monkey_camp_reg/tut; the stale `call $4441` path is unreachable and documented).
* `Profile_Edit`: "keyboard back key greyed" replaced by the screenshot fact (tutorial keyboard shows no back key, mail_profile keyboard does).
* `MailDraft_DrawTextLine25_BlitGlyphAdvance`: the ASCII path calls it too; not run because the test address has <=20 chars.
* Wrong addresses fixed: reply twin is `25:54A7` (not 54B5), `wMailComposeMode`=3 is written at `25:5515`, C0D2 loads in 2D are at 495F/498A; "many 2F calls" of `AddrBook_DrawSlotName` = 3 call sites.

## 7. Reproduce

```
python3 tools/gen_asm.py verify            # IDENTICAL with config/symbols/bank2A|2B|2C.tsv in place
python3 tools/gen_asm.py regen --fast --out /tmp/x   # generated sources use the new names
```
Analysis helpers used (not committed): function-level coverage matrix from `traces/coverage_*.tsv`, call graph from the generated `src/bank2[abc].asm`, screenshots from `.cache/trace/shots`, and a small renderer that replays the tile/palette/tilemap loads of a set-up routine into two VRAM banks and draws the 20x18 map with the staged palettes (matches the emulator screenshots for executed screens: profile, save-slot list, draft menu, mail viewer, title entry; it identified the unused grid screen and the entry view screen of bank 2F).
