# Naming pass G2: banks 24-29 (page list, mailbox, mail send/receive, mail body view, result screens)

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Namer 2/8.  Owned files: `config/symbols/bank24.tsv` ... `bank29.tsv`, `analysis/naming/ram_g2.tsv`, this note.  Everything was verified with
`python3 tools/gen_asm.py verify --config <copy>` (IDENTICAL, symbol names never change bytes); `src/` was not touched.
Status vocabulary as everywhere: CONFIRMED (executed in a trace and role shown by rendered UI / strings), PROBABLE (>= 2 independent clues), HYPOTHESIS
(generic name kept, idea only in the evidence column).

## 1. Method and new tooling (scratchpad only)

* **Call graph**: far-call sites are `farcall` macro lines in `src/`; static edges were parsed from them, callers per target listed with
  `analysis/farcall_targets.tsv`; `traces/detail/*/callgraph.tsv` only holds same-bank edges (far calls go through the HRAM trampoline), so per-function
  execution was taken from `traces/coverage_*.tsv` (41 scenarios) instead.
* **Rendering screens from ROM bytes**: a small renderer (not committed) replays the loader calls found in the code (`00:0749/0787` HDMA tile loads with
  their VRAM bank/destination, `4F:4000` palette copies, `00:08EA` tilemap+attribute copies, signed tile addressing as the game uses) and draws the 20x18
  (or 32x18) map; sprite objects were drawn the same way from the object rows (`00:0A82` format).  This turned tile/tilemap blocks that only had
  "looks like tiles" evidence into identified screens (title text is baked into the tiles).  All screen identities below come from such renders.
* Text was decoded with cp932 (Shift-JIS) from `analysis/strings.tsv` and the ROM bytes.

## 2. Subsystem map

The mail menu is the 7-entry `call $0545` dispatcher at `7C:7BC6` (table `7C:7BC9`): entry 1 = send/receive (`27:41BC`, `25:4A90`, then `27:4000`; when
the mailbox is full a dialog `72:4015` id `$021F` leads to `25:4000` with `C264=$FF`), entry 2 = `2D:4000` if `[A000]` of SRAM bank 0 is 0 else `2B:4000` (mail compose/edit, not analysed here),
entry 3 = mailbox (`25:4000`, `C264=0`), entries 4-6 = `2F:7EBF`, `2A:5495`, `22:4000`/`23:4000` (mail server; the hidden third button is SELECT+LEFT, see
`dynamic_tracing.md` 9.3).  Bank 24 is reached from the browser (`4E:4DB1`, `4F:46D3`).

| bank | subsystem | entry points | scenarios that execute it | main data |
|---|---|---|---|---|
| 24 | **Browser page list** ('ページリスト'): 6 saved pages, go / save / delete | `24:4018` `PageList_Main` (from 4E:4DB1, 4F:46D3) | browser_bookmarks, monkey_camp_rich/hid/tut | SRAM bank 1 `A000+n*$16` titles, `A084+n*$100` URLs; WRAM6 `D500` current URL, `D3C0` current title; 4 hint messages `4B10` |
| 24 (data) | graphics/palettes/objects of the **communication result screen** (bank 29 loads them) | via `29:407A` | mail_send, mail_receive, tutorial_profile | tiles `6BF0-7490`, tilemap `7790`, palettes `7A60/7AA0/7AE0`, objects `7B20` |
| 25 | **Mailbox** ('メールボックス': 12 records, 4 visible rows, read / reply / delete icons; C264=$FF = 'けすメールをえらんでね' delete-selection mode) | `25:4000` `Mailbox_Main`, `25:4A90` `Mailbox_CountRecords`, `25:4B0D` `Mailbox_LoadScreen`, `25:538A` `Gfx_StartHDMAAtVBlank` | mail_inbox, mail_mailbox, monkey_camp_reg/reg2/tut | SRAM bank 0 records `A124+n*$12D`, 12-word address tables (8 copies), attribute rows `58ED`, hints `53D0` |
| 25 (data) | tilemaps/tiles of the **mail server status screen** (bank 29 loads them) | via `29:4608` | mail_receive, mail_send, mail_server* | `6F30`, `7330`, tilemaps `7730/7A00/7CD0` |
| 26 | **Mail transfer screen** (banner 'メールを そうしんしています' / 'じゅしんしています', MM:SS clock, B=cancel) driving the bank-54 SMTP/POP3 steps | `26:4000` `MailSession_Run` (from 27:40D7) | mail_send, mail_receive, mail_errors, mail_timeout, monkey campaigns | 26:59E0-6FE0 tiles (scenery), message strings `56B2..`, mail counts D624.. |
| 26 (data) | object rows of the **mailbox** (`7B00-7D41`), tiles `7420` for the status screen | via 25 | mail_inbox | cursor brackets, arrows, digits 1-4, envelopes |
| 27 | **Mail send/receive flow**: connect screen (scrolling world panorama, 'せつぞくしています'), hang-up screen ('しゅうりょうしています'), orchestration | `27:4000` `MailSendRecv_Main` (from 7C:7C6A), `27:41E3` `MailConnect_Screen`, `27:4768` `MailDisconnect_Screen` (also called by mail server 22/23) | mail_send/receive/errors/timeout, mail_server*, tutorial_profile | tiles `5060-6C60`, panorama tilemap `7060` (32x18), window strips `7560-7948`, objects `7A10` |
| 28 | **Mail text view screen** (letter paper, 8 lines) + a **shared asset bank** for the mail-server screens (22/23), the transfer-screen sprites (26/27) and screens of 2A/2C/2F | `28:4000` `MailBody_ViewScreen` (from 2B:4075, 2D:4856, 2D:5981) | mail_compose (+ monkey campaigns) | tiles `42C0/44D0`, tilemap `4820`; mail-server tilemaps `5BD0/6860/6B30`; object tables `6E80-7A5D` |
| 29 | **Communication result screen** ('つうしんけっかはっぴょう') and **mail server status screen** ('メールサーバじょうきょう') | `29:4000` (from 27:4156), `29:44F6` (from 27:4160, 22:*, 23:*) | mail_send/receive, tutorial_profile, mail_server* | 8 result strings `421E-4374`, number formatters (3 copies), palette-fade library `5090` (dead) |

### 2.1 Banks 24: page list

`PageList_Main` loops per frame (sprites `00:0956`, abort test `wTimerEnable` bit1, time-warning test bit4), UP/DOWN (repeat) move the row cursor C (0-5) and redraw
(`PageList_RedrawSelection`, `PageList_UpdateRowSprites`), A opens `PageList_ActionMenu` (`24:4BCD`) with three icons (LEFT/RIGHT: go `24:5164`, save `24:4F14`,
delete `24:51CB`; the hint text of each is one of the four 45-byte messages `24:4B10`), B returns `$FF`.  Text is drawn by `PageList_DrawTextLine` (`24:494C`,
siblings `25:5240` and `28:41CB` run the same loop but are not byte-identical (24 reads the text via WRAM bank 6; 25 via SRAM bank 0 with the width in A; 28 also handles `$0D`): per char `7F:41A7` 2-byte test, `7F:405F`/`7F:4007` glyph, `7F:42C3` blit, x+=6) into WRAM bank 2 tile buffers uploaded by
`PageList_UploadTextTiles` with HDMA (`24:4A54`, waits LY=$5D then $91).  A slot is 'used' when the first byte of its URL slot is non-zero; saving copies the 256-byte URL
in WRAM6 `$D500` and the title (`$D3C0`, or the URL if the title is empty) into the slot; delete zeroes the first two bytes of URL and title; every destructive
action asks a `72:4015` dialog (id `$0109` overwrite, `$0108` delete).  Go returns `A=$FF`, `HL`=URL slot address, `DE`=title slot address to the browser.
`24:42B0` (unreached) would copy the strings `http://www.goo.ne.jp/` (`Url_GooNeJp`) / 'くーくー' (`String_24_42E7`, generic name) to `$D500`/`$D3C0` (HYPOTHESIS: default home page).

### 2.2 Bank 25: mailbox

Records (SRAM bank 0, 12 x $12D from `A124`, count = leading records with a non-zero first byte, `Mailbox_CountRecords`): `+0` in-use, `+1` flag (cleared when the
mail is read, see `Mailbox_ReadMail`), `+3..+8` six BCD bytes = date/time (default `20 00 06 28 12 30`; `Mailbox_DrawTimestamp` turns the nibbles into tiles `$D0+n`),
`+9..+C8` $C0 body, `+C9..+D8` 16-byte name ('ニックネーム' box, `Mailbox_DrawSenderName`), `+D9..+EC` 20-byte one-line text (row titles, `Mailbox_DrawRowTitles`),
`+ED..+12C` 64-byte ASCII address.  List = 4 visible rows (scroll offset B, cursor C, `Mailbox_CursorUp/Down`), row-number sprites 1-4 (`Mailbox_ShowRowNumbers`,
objects `26:7B60-7B90`), envelope sprites (`Mailbox_ShowRowStatusIcons`, `26:7BA0` closed / `7BB0` open), scroll arrows (`26:7B40/7B50`), NN/12 counter
(`Mailbox_DrawMailCount`, `$98CE`).  A on a mail enters the icon menu (`25:415C`): left/right move D (0 read, 1 reply, 2 delete), A executes (`25:420A`):
read = mail viewer `2B:6482`; reply = `Mailbox_ReplyToRecord` (copies name+address to WRAM1 `D514`/`D4C0`, then `2D:65B0`, `2C:4000`, `2D:4722`) if the outbox area
`[A000]` is empty (else dialog `$0213`); delete = dialog `$0206` then `2D:4133` (shift records, zero the last).  Mode `C264=$FF` is the 'choose the mail to delete'
variant entered from the mail menu when the box is full.  The 5 hint texts `25:53DA..547E` are shown in a 20-cell line (`Mailbox_ShowHint`).

### 2.3 Banks 26/27/29: send/receive session

`MailSendRecv_Main` (27:4000): copies a 7-byte request `27:417A` into the WRAM1 block `D624`, sets `D62A`=free slots (12 - `Mailbox_CountRecords`), calls `57:4000` (unanalysed),
initialises the counters, runs `MailConnect_Screen` (`27:41E3`: returns 0 connected / `$20` cancelled / `$80` failed) and then `MailSession_Run` (`26:4000`) or, on
failure, `MailDisconnect_Screen` (`27:4768`/`49B0`, chosen by `wTimerEnable` bit4) when the error code `C272` is one of `$17/$20/$21/$23/$24/$26`;
after the transfer `29:4000` shows the result and `29:44F6` the server status with mode C264=0; finally `25:4000` (`D=$FF`) opens the mailbox.  `MailSession_Run` uses
`Mail_OutboxIsEmpty` (`27:41BC`, `[A000]` of SRAM bank 0 == 0) to choose the 'receiving' vs 'sending' banner, checks `MailSession_PollAdapterError` and the
connection-time warning (`MailSession_CheckTimeWarning`) every frame, draws 'ぜんぶで N つう' / 'N つうめを チェックしています' (`MailSession_DrawMailCounts`) and stores the outcome in
`D624` (send: 0 none / 1 sent / 2 unsure / $FF failed) and `D625/D626` (received count, $FFFF failed).

Connection-time warning (repeated inline in `24:4083`, `24:4BD5` and as functions `26:4EC3/4F7B`): timer A = `C2D4` frames, `C2D5` seconds, `C2D6` minutes (`Int_VBlank`);
`C26E` (next warning minute, set to 9 at `27:42F3`, +$0A up to $45) and `C26F` bits (bit0 = warning pending, set when due and cleared by the dialog code `7F:6218/6235`; bit1 = final $45 warning given, cleared by `Int_VBlank` at 70 minutes): when minutes > C26E, or == with seconds >= 30, the dialog (`7F:624F/6218`) offers to end
the session; this is the '10-minute warning' of `dynamic_tracing.md` 9.3 item 7 (first at 9:30, then every 10 minutes).

Error path: `54:4011` (= MobileAPI 0 'get last result') stores A/HL in `C1DD/C1DE/C1DF`; `MailSession_ShowCommError` (`26:5067`) copies them to `C272-C274` and calls `68:4F8C` (error number
screen).  Codes are BCD-looking numbers (`$26` = the 5-minute timeout of scenario mail_timeout, `$30` SMTP refusals).

### 2.4 Bank 29: result screens

`MailResult_Screen` (`29:4000`): boxes 'おくったメール' (message from `MailResult_ShowSentMessage`: 4 strings by `D624`) and 'とどいたメール' (`MailResult_ShowReceivedMessage`: 'メールはとどいていません' /
'うけとりにしっぱいしました！' / 'N つうとどいています！！' + count sprite / 'メールはうけとれませんでした' when the box is full); messages are printed two characters at a time
(`29:41E0` loop truncates the string with a NUL and re-renders, then `MailResult_UploadTextTiles`).  `MailServerStatus_Screen` (`29:44F6`): three counters in number boxes
(three modes by `wMailScreenMode`: 0 after send/receive (tilemap 25:7730 with 'A とどいたメールをみる' when mails arrived, else 25:7A00 'A メニューにもどる'), 1 and 2 mail-server management
(tilemap 25:7CD0 'チェックしたメール / けしおわったメール / サーバにあるメール')); each mode has its own copy of the number formatter (`FormatNumber_M0/M1/M2`), offset chooser and tile uploader.
After A it may show count dialogs `72:4015` ids `$0224/$0225/$0226` (1-3, 4-10, more) depending on a counter difference (HYPOTHESIS: 'N mails are still on the server').
`29:5090-5376` is a self-contained palette-fade library (read all palettes into `$DBD0`, +1/-1 per RGB channel, write back) that nothing references (dead code).

## 3. Named symbols (from `config/symbols/bank24..29.tsv`)

Function rows only, statuses as written in the TSV; data, table and string rows are in the files.  HYPOTHESIS rows keep the generic name.

### Bank 24 (PageList)
| addr | name | status | evidence |
|---|---|---|---|
| `24:4018` | `PageList_Main` | CONFIRMED | Page list screen ('ページリスト', 6 rows, up/down cursor, A opens goto/save/delete menu 24:4BCD, B cancels); far-called by 4E:4DB1 and 4F:46D3; executed in browser_bookmarks; returns HL=chosen URL slot, or A=$FF |
| `24:4083` | `PageList_Main_Loop` | CONFIRMED | per-frame loop head of PageList_Main: sprite update 00:0956, connection-abort test (wTimerEnable bit1), time warning test (bit4), then joypad handling (hJoyPressed A/B, repeat up/down) |
| `24:42B0` | `Function_24_42B0` | HYPOTHESIS | idea: copies the strings at 24:42D1 (http://www.goo.ne.jp/) to WRAM6 $D500 and 24:42E7 to $D3C0 (current page URL/title buffers); no caller or pointer found, never executed |
| `24:42F0` | `PageList_InitScreen` | CONFIRMED | Builds the page list screen: clears WRAM2/3, HDMA tiles 24:5400/5800/5EE0/62E0, palettes 5EA0/64E0, tilemap 5900 (5BD0 if [D500]!=0), draws titles/cursor; executed in browser_bookmarks (called at 24:406A) |
| `24:4453` | `PageList_UpdateRowSprites` | CONFIRMED | C=cursor row: runs PageList_InitRowSprites (445C) then PageList_HighlightRowSprite (45B7); called after each cursor move (24:427D/42A8, 4BCD loop); executed in browser_bookmarks |
| `24:445C` | `PageList_InitRowSprites` | CONFIRMED | Puts the 6 row marker sprites (WRAM7 slots DA10-DA60, y=$23+$0C*n, x=6) on object 24:6560, or 24:6550 when the URL slot n is in use (first byte != 0); executed in browser_bookmarks |
| `24:45B7` | `PageList_HighlightRowSprite` | CONFIRMED | C=row 0-5: switches that row's marker sprite to object 24:6530 (slot in use) or 24:6540 (slot empty) at its y position; executed in browser_bookmarks |
| `24:4794` | `PageList_GetActionAvailability` | CONFIRMED | C=row: A=E=1 if URL slot C in use (first byte != 0) else 0; D=1 if the current page URL buffer WRAM6 $D500 is non-empty; feeds PageList_SetActionIcons (go / save / delete availability) |
| `24:47FB` | `PageList_SetActionIcons` | CONFIRMED | A,D,E = enable flags of the three icons (go/save/delete): writes BG attribute $0C (1) or $0B (else) in VRAM bank1 at $99C3/$99C9/$99CF (+$20 second row) after waiting LY=$90; executed in browser_bookmarks |
| `24:483E` | `PageList_RedrawSelection` | CONFIRMED | A=old row, C=new row: redraws title of row A normally and of row C highlighted (SRAM title slots), the current page title from WRAM6 $D3C0 in the header, uploads text tiles, disables icons; executed |
| `24:48C7` | `PageList_DrawAllTitles` | CONFIRMED | Draws the 6 title slots (SRAM bank1 $A000+n*$16, rows y=$10+$0C*n) with row 0 highlighted and the current page title $D3C0, then PageList_UploadTextTiles; called once by PageList_InitScreen; executed |
| `24:494C` | `PageList_DrawTextLine` | PROBABLE | HL=NUL-terminated Shift-JIS/ASCII text, D,E=y,x, wRam_C2EE=$14 cells: 7F:41A7 (2-byte test), 7F:405F/4007 (glyph), 7F:42C3 (blit), x+=6, blank padding; sibling of 25:5240/28:41CB (same loop, not byte-identical: reads via WRAM bank 6) |
| `24:49EC` | `PageList_BlitGlyphAdvance` | PROBABLE | Blits the glyph buffer $C0A0 through 7F:42C3 at the text position and advances E (x) by 6; used by PageList_DrawTextLine, also for the blank padding; same as 25:52EA and 28:428B |
| `24:4A00` | `PageList_UploadTextTiles` | CONFIRMED | Copies the 4 text tile buffers of WRAM bank2 (D000,D400,D800,DC00) to VRAM $9000/$9400/$8800/$8C00 with PageList_StartHDMAAtVBlank; called after every text redraw; executed in browser_bookmarks |
| `24:4A54` | `PageList_StartHDMAAtVBlank` | CONFIRMED | HL=source, DE=VRAM dest, C=blocks-1: writes rHDMA1-4, waits LY=$5D then LY=$91 with interrupts off, starts general HDMA (rHDMA5=C&$7F), clears SCY; NOT identical to 25:538A (which waits $8F, no di/ei, no SCY); executed |
| `24:4A79` | `PageList_ShowMessage` | CONFIRMED | A=message 0-3 (table 24:4B10): renders the five 9-byte lines of the selected 45-byte message through 48:403E into WRAM2 tile buffers and uploads them (goto/save/delete/select-a-page hints); executed |
| `24:4BCD` | `PageList_ActionMenu` | CONFIRMED | A pressed on a row: 3-choice menu (left/right, b=0 go 5164, 1 save 4F14, 2 delete 51CB), B backs out; has its own abort/time checks; returns A=$FF with HL=URL slot when a page was chosen; executed in browser_bookmarks |
| `24:4BD5` | `PageList_ActionMenu_Loop` | CONFIRMED | per-frame loop head of PageList_ActionMenu (action index in B, row in C) |
| `24:4E46` | `PageList_ActionMenuInit` | CONFIRMED | Creates the action cursor sprite (WRAM7 slot DA00, object 24:6570, y=$6F x=$16) and shows message 0 via PageList_ShowMessage; first call of PageList_ActionMenu; executed |
| `24:4E71` | `PageList_HideActionCursor` | CONFIRMED | Moves the action cursor sprite (slot DA00 y byte) to $E8 = off screen and updates sprites; called when leaving the action menu (24:4D8A, 4DDA); executed |
| `24:4E85` | `PageList_SetActionCursor` | CONFIRMED | B=action 0-2: object 24:6570/6580/6590 with x=$16/$46/$76 for slot DA00 (the cursor over the go/save/delete icon); executed in browser_bookmarks |
| `24:4EF1` | `PageList_MoveActionCursor` | CONFIRMED | Wrapper used on left/right presses (repeat $20/$10): PageList_SetActionCursor, sprite update 00:0956, frame wait; executed in browser_bookmarks |
| `24:4F14` | `PageList_SaveCurrentPage` | CONFIRMED | Save action: no-op (A=0) if $D500 empty; asks overwrite dialog 72:4015 id $0109 if the slot is used; copies the 256-byte URL $D500 to the URL slot and the title $D3C0 (or the URL if empty) to the 22-byte title slot; A=$FE if refused |
| `24:5164` | `PageList_GoToSlot` | CONFIRMED | Go action: returns A=0 if the URL slot is empty; else bank-04 request 00:20AC id $2C (A-press effect, sound driver is a HYPOTHESIS), A=$FF with HL=URL slot address and DE=title slot address for the caller (browser 4E:4DB1); executed |
| `24:51CB` | `PageList_DeleteSlot` | CONFIRMED | Delete action: returns if slot empty; confirmation dialog 72:4015 id $0108; on yes issues 00:20AC id $33, animates the row sprite and zeroes the first 2 bytes of the URL and title slots (A=$FE if refused); executed in browser_bookmarks |
| `24:53FC` | `Function_24_53FC` | HYPOTHESIS | single ret (empty stub), called at 24:4D48 when hJoyHeld != 0; idea: removed debug/no-op hook |
| `24:53FD` | `Function_24_53FD` | HYPOTHESIS | single ret (empty stub), called at the start of PageList_ActionMenu (24:4BD0); idea: no-op hook |

### Bank 25 (Mailbox)
| addr | name | status | evidence |
|---|---|---|---|
| `25:4000` | `Mailbox_Main` | CONFIRMED | Mailbox screen ('メールボックス', 12 records in SRAM bank0 A124+n*$12D): list of 4 rows, read/reply/delete icons; C264=0 normal, $FF = choose-mail-to-delete mode; far-called from 7C:7C61, 7C:7CC4, 27:4173; executed in mail_inbox/mail_mailbox |
| `25:4043` | `Mailbox_Main_Loop` | CONFIRMED | per-frame loop head of Mailbox_Main: sprites 00:0956, wait, joypad 7D:7BB7, then Mailbox_CountRecords; B leaves (returns A=$FF), A opens the icon menu, up/down move (Mailbox_CursorUp/Down) |
| `25:415C` | `Mailbox_IconMenu_Loop` | CONFIRMED | loop head after A on a mail: left/right ($20/$10) move the icon cursor D (0 read, 1 reply, 2 delete) via Mailbox_SetActionCursor, A executes (25:420A), B returns to the list |
| `25:420A` | `Mailbox_IconMenu_PressA` | CONFIRMED | A pressed on the icon cursor D: D==2 -> delete confirmation (dialog 72:4015 id $0206, then record delete 2D:4133 and Mailbox_RedrawAfterDelete), else jp 25:446E (reply/read); executed in mail_inbox |
| `25:446E` | `Mailbox_IconMenu_ReplyOrRead` | CONFIRMED | icon D==1 (reply, at 25:4490) or D==0 (read, jp 25:465C); in C264=$FF mode the icon menu is bypassed; executed in mail_inbox |
| `25:4564` | `Mailbox_ReplyStart` | CONFIRMED | reply when the outbox area ([A000] bank0) is empty: bank-04 request 00:20AC id $2C, hides sprites, Mailbox_ReplyToRecord (54A7) and restores the list; if [A000] != 0 a dialog id $0213 is shown instead (25:44AC); executed in mail_inbox |
| `25:465C` | `Mailbox_ReadMail` | CONFIRMED | icon D==0: if record+1 flag is set clears it and shows dialog $021E/$022B (22:501D), then opens the mail viewer 2B:6482 with the record index (B+C); returns to the list; executed in mail_inbox |
| `25:4804` | `Mailbox_SetActionCursor` | CONFIRMED | D=icon 0-2: object 26:7B10/7B20/7B30 in sprite slot DA20 at y=$70, x=$20/$48/$70 and hint text Mailbox_ShowHint(D) + upload; the read/reply/delete icon cursor; executed in mail_inbox |
| `25:4885` | `Mailbox_CursorUp` | CONFIRMED | Up pressed ($40 repeat): moves the list cursor C up (scrolls offset B when at the top of the 4 visible rows, wraps to the last mail), redraws sender/timestamp/rows/numbers/icons; executed in mail_inbox |
| `25:4907` | `Mailbox_CursorDown` | CONFIRMED | Down pressed ($80 repeat): moves the list cursor C down (scrolls B, stops at the last used record via Mailbox_NextRecordUsed), redraws like Mailbox_CursorUp; executed in mail_inbox |
| `25:4987` | `Mailbox_UpdateScrollArrows` | CONFIRMED | Shows the up/down scroll arrow sprites (objects 26:7B40/7B50, slots DA30/DA40) when more than 4 mails exist, else parks them off screen at x=$D0; twin of 25:4D99; executed in mail_inbox |
| `25:49EB` | `Mailbox_NextRecordUsed` | CONFIRMED | B=scroll,C=cursor: A = first byte (in-use flag) of record B+C+1 in SRAM bank0, or 0 if that index is 12; used by Mailbox_CursorDown; executed |
| `25:4A2D` | `Mailbox_RedrawAfterDelete` | CONFIRMED | After a mail was deleted (2D:4133): adjusts scroll B/cursor C and redraws sender name, row titles, tiles, numbers, icons, timestamp; single caller 25:42FF; executed in mail_inbox |
| `25:4A68` | `Mailbox_ShowEmptyList` | PROBABLE | Clears WRAM2 $D000 x$0D00 text tile buffer, redraws timestamp and tile upload and resets sprites: the display when no mail is left (25:4341 after count==0); not executed in traces |
| `25:4A90` | `Mailbox_CountRecords` | CONFIRMED | SRAM bank0: D = number of consecutive used records (first byte != 0) from A124, stride $12D, 0-12; leaves SRAM enabled; used by 25/26/27/29/7C (12 = mailbox full); executed in 15 scenarios |
| `25:4B0D` | `Mailbox_LoadScreen` | CONFIRMED | Loads the mailbox screen: sprite reset, 2D:4E06, palettes 69B0/6EF0, tiles 5A10/5E10/69F0/6A00/6CF0 (5F10/6310 + tilemap 66E0 in delete mode C264=$FF), tilemap 6410, count/row attributes; executed in mail_inbox |
| `25:4D99` | `Mailbox_UpdateScrollArrows_B` | PROBABLE | identical twin of Mailbox_UpdateScrollArrows (25:4987), called only from Mailbox_LoadScreen (25:4D27) |
| `25:4DFD` | `Mailbox_DrawSenderName` | CONFIRMED | B+C=record: draws the 16-byte name field (record+$C9, default 'マリオ') with Mailbox_DrawTextLine at y=$02,x=$30 (the 'ニックネーム' box of the rendered screen); executed in mail_inbox |
| `25:4E43` | `Mailbox_DrawRowTitles` | CONFIRMED | Draws the 20-byte text field (record+$D9, default 'またあそぼうね') of the 4 visible records at rows y=$10/$1C/$28/$34, x=$20 (highlights row C); executed in mail_inbox |
| `25:4F40` | `Mailbox_DrawTimestamp` | CONFIRMED | Record+3..+8 (6 BCD bytes 20 00 06 28 12 30 in the default records) -> 12 digit tiles ($D0+nibble) at VRAM $98A1.. with gaps for the 年 月 日 時 分 labels; also into WRAM7 map; executed in mail_inbox |
| `25:50C2` | `Mailbox_ClearTimestamp` | CONFIRMED | Same as Mailbox_DrawTimestamp but writes only blank tile $D0 for all 12 digit cells (used when no mail is selected / list empty); executed in 5 scenarios |
| `25:5240` | `Mailbox_DrawTextLine` | CONFIRMED | HL=NUL-terminated SJIS/ASCII text in SRAM bank0, A=max cells, DE=y,x: 7F:41A7 (2-byte test), 7F:405F/4007 (glyph), 7F:42C3 (blit), x+=6, blank padding; sibling of 24:494C and 28:41CB (same loop, not byte-identical); executed |
| `25:52EA` | `Mailbox_BlitGlyphAdvance` | CONFIRMED | Blits glyph buffer $C0A0 via 7F:42C3 at the text position and advances x by 6; helper of Mailbox_DrawTextLine; executed |
| `25:52FE` | `Mailbox_DrawMailCount` | CONFIRMED | Shows the number of mails (Mailbox_CountRecords, 0-12) as two digit tiles ($E0+digit) at VRAM $98CE and WRAM7 $D0CE (the 'NN/12' counter of the screen); executed in mail_inbox |
| `25:534C` | `Mailbox_UploadTextTiles` | CONFIRMED | Copies the text tile buffers of WRAM bank2 (D000,D400,D800,DC00) to VRAM $9000/$9400/$8800/$8C00 via Gfx_StartHDMAAtVBlank (25:538A); executed in 5 scenarios |
| `25:538A` | `Gfx_StartHDMAAtVBlank` | CONFIRMED | HL=source, DE=VRAM dest, C=blocks-1: rHDMA1-4 set, wait LY=$8F then LY=$91, rHDMA5=C&$7F (general purpose HDMA); library used by 22:48B3/48C1, 23:47A2/47B0, 2B:47C2, 2C:66F4 and this bank; executed in 12 scenarios |
| `25:53AA` | `Mailbox_ShowHint` | CONFIRMED | D=-1..3 (message D+1 of table 25:53D0): renders the 20-cell hint text into WRAM2 $DA00/$DB40 via 48:403E (select mail / read / reply / delete / no mail); executed in mail_inbox |
| `25:54A7` | `Mailbox_ReplyToRecord` | PROBABLE | Reply: clears WRAM1 $D400 x$124, copies record+$ED (40 B ASCII address) to $D4C0 and record+$C9 (16 B name) to $D514, sets $D524=3/index, then farcalls 2D:65B0, 2C:4000, 2D:4722; A=$FF if cancelled |
| `25:5581` | `Mailbox_ShowRowNumbers` | CONFIRMED | B=scroll: copies 4 number tiles VRAM $8700+16*B -> $8010, parks the 4 row-number sprites (DA50-DA80) then shows as many as there are mails (objects 26:7B60-7B90 = digits 1-4 at y=$38/$44/$50/$5C); executed in mail_inbox |
| `25:5641` | `Mailbox_ShowRowStatusIcons` | CONFIRMED | Shows one envelope sprite per visible mail (slots DA90-DAC0; object 26:7BB0 open envelope, or 26:7BA0 closed when Function_25_5848 returns $FF) and the cursor-row variants 26:7BC0/7BD0; executed in mail_inbox |
| `25:5848` | `Function_25_5848` | HYPOTHESIS | A+B=record index: returns $FF if record byte0 == 1 else 0; selects the closed-envelope object; idea: byte0==1 marks an unread/new mail (default records hold 01) |
| `25:5889` | `Mailbox_SetIconBarAttrs` | PROBABLE | A=0..2: copies two 20-byte BG attribute rows of 25:58ED/591D/594D to VRAM bank1 $99C0/$99E0 (and WRAM7 $D5C0/$D5E0), i.e. the palette/enable state of the three-icon bar; executed in mail_inbox |

### Bank 26 (MailSession)
| addr | name | status | evidence |
|---|---|---|---|
| `26:4000` | `MailSession_Run` | CONFIRMED | Mail send/receive transfer screen once connected: 'sending'/'receiving' banner, MM:SS timer, B=cancel, drives the bank-54 SMTP/POP3 steps, results in WRAM1 D624-D637; far-called by 27:40D7; executed in mail_send/mail_receive |
| `26:412C` | `MailSession_SendPhase` | PROBABLE | send phase, skipped (jp z,$44F5 at 26:4129) when Mail_OutboxIsEmpty; runs bank-54 wrappers 54:44FE/451B, 54:4575/4772, 54:4538/4552 (SMTP-range API $14-$1A), sets D624; executed in mail_send/mail_errors, not in mail_receive |
| `26:44F5` | `MailSession_ReceivePhase` | PROBABLE | receive phase: clears the message (5873), banner 'receiving' (56DB), bank-54 steps 54:485C/489B (API $1E), then the per-mail loops from 26:45BC; executed in mail_receive, mail_send (empty mailbox) and mail_errors |
| `26:45BC` | `MailSession_ScanMailsLoop` | PROBABLE | first per-mail loop of the receive phase: for each of the N mails (HL counter) 26:4F7B, 54:4914/4969 (a=$FF), counts the ones answering 2 in BC, stores counts at D625/D62F; executed only in mail_receive-type runs |
| `26:471B` | `MailSession_ReceiveMailsLoop` | PROBABLE | second per-mail loop: draws 'ぜんぶで N つう / N つうめ' (26:537C), bank-54 steps 54:4914/4969 and 54:4CB0/4CF4, updates the received count D625 and stops when D62E + count == 12; executed in mail_receive |
| `26:4A8A` | `MailSession_NoMailOrFull` | PROBABLE | nothing to store: if Mailbox_CountRecords == 12 shows 'メールは うけとれませんでした' (57EB) else 'メールは ありませんでした' (57A7), then the closing animation; executed in mail_send/tutorial_profile (empty POP3 box) |
| `26:4B54` | `MailSession_Finish` | PROBABLE | normal end: bank-04 request 00:20AC id $3D, final sprite animation, 7F:72B0 / 4F:4370 cleanup, returns A=0; reached from the message paths 26:4A61/4B02; executed in mail_send/mail_receive |
| `26:4C94` | `Function_26_4C94` | HYPOTHESIS | idea: sets sprite slot DA40 to one of 12 object rows 28:74CB.. chosen by the received-mail count [D625] (0-11, else 28:757B); called after each received mail; executed in mail_receive |
| `26:4DAB` | `Function_26_4DAB` | HYPOTHESIS | idea: like 26:4C94 but for slot DA60 with objects 28:73FB.. chosen by [D625]+1 ($FF -> first row); executed in mail_receive |
| `26:4EC3` | `MailSession_CheckTimeWarning` | PROBABLE | Connection-time check: if timer A (C2D6 min, C2D5 s) reaches the next warning point [C26E] min + 30 s (9,19,..,69) shows the warning dialog via 7F:624F/6218; A=$FF if the user ends the session else 0; executed in 7 scenarios |
| `26:4F7B` | `MailSession_CheckTimeWarningRecv` | PROBABLE | Same time-warning test as MailSession_CheckTimeWarning used in the receive loop: after the dialog it redraws the 'receiving' banner (26:56DB); A=$FF ends the session, else 0; executed in 6 scenarios |
| `26:503C` | `MailSession_Cancel` | CONFIRMED | B pressed (hJoyPressed/held bit1) during the transfer: 7F:72B0, 4F:4370, LCDC bit2 off, sets D637=1 (aborted) and returns A=$7F; executed in monkey_camp_reg/reg2/rich |
| `26:5067` | `MailSession_ShowCommError` | CONFIRMED | Copies the adapter result C1DD/C1DE/C1DF to C272/C273/C274, sets D629=$FFFF, WX=7, LCD window off, farcalls 68:4F8C (error number screen), returns A=$80; executed in mail_errors/mail_timeout |
| `26:50AC` | `MailSession_PollAdapterError` | PROBABLE | Returns NZ (A=1) unless bit1 of wTimerEnable is set; if set: 54:4011 (MobileAPI 0 = get last result into C1DD-C1DF) and returns Z so callers jump to MailSession_ShowCommError; executed in 6 scenarios |
| `26:50C6` | `MailSession_ShowCommErrorNoWindow` | PROBABLE | Variant of MailSession_ShowCommError (26:5067) that sets WX=0 instead of 7; called at 26:42EE after a failed bank-54 receive step, then C1DD ($26 timeout / $30) decides whether to continue; executed in mail_errors |
| `26:5106` | `Function_26_5106` | HYPOTHESIS | idea: compares (D629-D627) with (D62F-D631) (16-bit counters kept as one's complement) and returns A=1 with D631=D62F when equal, else 0; progress test of the receive loop; executed in mail_receive |
| `26:5168` | `MailSession_InitScreen` | CONFIRMED | Builds the transfer screen: sprite reset, 2D:4E06, LCD off, clears VRAM/WRAM2, palettes 22:5C50/5C90/27:7520, HDMA tiles 26:59E0-6FE0, tilemap 22:5980, window/LCD setup; executed in 9 scenarios |
| `26:5343` | `Function_26_5343` | HYPOTHESIS | single ret (empty stub) called at the start of MailSession_UpdateTimerDisplay (26:58DE) |
| `26:537C` | `MailSession_DrawMailCounts` | CONFIRMED | Renders 'ぜんぶで NNN つう' and 'NN つうめを チェックしています' (total mails / current mail) into WRAM2 tile buffers from the 16-bit counters at D631/D62F (one's complement); executed in mail_receive |
| `26:5447` | `MailSession_DrawNumber` | PROBABLE | HL=value (<=99999), BC=tile buffer offset: builds a full-width decimal string in WRAM1 $D524 from the '０００００' template 26:5575 using Divide16, renders it with 48:403E; A=digit count; executed in mail_receive |
| `26:5580` | `MailSession_TotalNumberBuffer` | PROBABLE | HL=value: BC = right-aligned tile buffer for the 'total' number by digit count (5 digits $D070, 4 $D080, 3 $D090, 2 $D0A0, 1 $D0B0 with A=1); executed in mail_receive |
| `26:55E0` | `MailSession_CurrentNumberBuffer` | PROBABLE | HL=value: BC = tile buffer for the 'current mail' number by digit count ($D420 for >=2 digits, $D430 for 1 digit with A=1); executed in mail_receive |
| `26:5640` | `MailSession_UploadNumberTiles` | PROBABLE | Copies WRAM2 $D000 and $D400 (63 blocks each) to VRAM $9000/$9400 through 7F:72C2; executed in mail_receive |
| `26:5697` | `MailSession_ShowMsgSending` | CONFIRMED | Renders 'メールを そうしんしています' (String 26:56B2, sending mail) into the WRAM2 tile buffers and uploads them (26:58B7); used when Mail_OutboxIsEmpty is false; executed in mail_send |
| `26:56DB` | `MailSession_ShowMsgReceiving` | CONFIRMED | Renders 'メールを じゅしんしています' (26:56F6, receiving mail) and uploads it; used when the outbox is empty and after time-warning redraws; executed in 8 scenarios |
| `26:571F` | `Function_26_571F` | HYPOTHESIS | idea: renders the string 26:573A 'メールを そうしんしました' (mail sent) like 26:5697; no caller found |
| `26:5763` | `Function_26_5763` | HYPOTHESIS | idea: renders 26:577E 'メール じゅしんかんりょう' (mail reception complete) like 26:5697; no caller found |
| `26:57A7` | `MailSession_ShowMsgNoMail` | CONFIRMED | Renders 'メールは ありませんでした' (26:57C2, there was no mail) and uploads it; executed in mail_send/tutorial_profile (empty POP3 mailbox) |
| `26:57EB` | `MailSession_ShowMsgCannotReceive` | PROBABLE | Renders 'メールは うけとれませんでした' (26:5806, could not receive the mail) shown when the mailbox is full (25:4A90 == 12, 26:4A8A path); not executed in traces |
| `26:582F` | `MailSession_ShowMsgReceived` | CONFIRMED | Renders 'メールを うけとりました' (26:584A, received mail) and uploads it after mails were stored (26:4A1E path); executed in mail_receive |
| `26:5873` | `MailSession_ClearMsg` | CONFIRMED | Renders the blank line 26:588E (20 full-width spaces) over the message area and uploads it; executed in 8 scenarios |
| `26:58B7` | `MailSession_UploadMsgTiles` | CONFIRMED | Copies the message tile buffer WRAM2 $D400 to VRAM $9400 with MailSession_StartHDMAAtVBlank (63 blocks); tail of every MailSession_ShowMsg*; executed in 9 scenarios |
| `26:58DC` | `MailSession_UpdateTimerDisplay` | CONFIRMED | Per-frame: when seconds C2D5 changed, re-HDMAs the tile 26:66E0 and rewrites the MM:SS digit tiles ($40+digit) in WRAM7 D221/D222 (minutes, clamped to 99) and D224/D225 (seconds) (the '12:34' clock of the screen); executed in 13 scenarios |
| `26:59B6` | `MailSession_StartHDMAAtVBlank` | CONFIRMED | HL=source, DE=VRAM dest, C=blocks-1: di, rHDMA1-4, wait LY=$8F then $91, rHDMA5, ei; same as Gfx_StartHDMAAtVBlank (25:538A) plus di/ei; executed in mail_send/mail_receive |

### Bank 27 (MailSendRecv / MailConnect / MailDisconnect)
| addr | name | status | evidence |
|---|---|---|---|
| `27:4000` | `MailSendRecv_Main` | CONFIRMED | Mail send/receive flow (mail menu entry 1): request block -> 57:4000, connect 27:41E3, session 26:4000, hang-up 27:4768/49B0, result screens 29:4000 + 29:44F6, mailbox 25:4000; from 7C:7C6A; executed in mail_send/mail_receive |
| `27:41BC` | `Mail_OutboxIsEmpty` | CONFIRMED | SRAM bank0: returns A=$FF when [$A000]==0 (no mail waiting in the outbox/compose area) else A=0; picks 'receiving' vs 'sending' banners in 26:4000 and the messages of 27:41E3/4768; executed in 13 scenarios |
| `27:41E3` | `MailConnect_Screen` | CONFIRMED | Connect screen (world panorama scrolls, window 'せつぞくしています' -> 'せつぞくしました', B cancels): A=0 connected, $20 cancelled, $80 failed; bank-54 dial steps 54:403D/405D/4141; also called by 22:4B7F, 23:4A6E; executed in 15 scenarios |
| `27:4305` | `MailConnect_Screen_Loop` | PROBABLE | per-frame loop head while dialing: sprite/scroll animation, joypad B check (hJoyPressed&2 -> cancel), MailConnect_PollAdapterError, then 54:405D |
| `27:46E5` | `MailConnect_ShowError` | PROBABLE | error path of MailConnect_Screen: copies C1DD/C1DE/C1DF to C272-C274, WX=7, bank-54 steps 54:418C/41A3/423C/4266, then 68:4F8C error screen, returns A=$80; executed in monkey_camp_reg/tut/hid |
| `27:4747` | `MailConnect_PollAdapterError` | PROBABLE | NZ (A=1) unless bit1 of wTimerEnable set; when set: WX=7, frame wait, 54:4011 (MobileAPI 0 result -> C1DD-C1DF), returns Z (twin of MailSession_PollAdapterError); executed in 15 scenarios |
| `27:4768` | `MailDisconnect_Screen` | CONFIRMED | Hang-up screen (bit4 of wTimerEnable set, else 27:49B0): init 27:4B95(A=1), window 'しゅうりょうしています' -> 'しゅうりょうしました', bank-54 steps 54:418C/41A3/423C/4266; B=mode (C264 0/1/2); also called by 22:4BC1, 23:4AB0; executed in 13 scenarios |
| `27:49B0` | `MailDisconnect_ScreenNoTimer` | PROBABLE | Same hang-up screen for the case bit4 of wTimerEnable (timer A, C2D4-C2D6) is clear; jumps to MailDisconnect_Screen when it is set (27:49B5); called from 27:40B3/40F5 (and 22/23); never executed in traces |
| `27:4B95` | `MailConnect_InitScreen` | CONFIRMED | Common init of the connect/hang-up screens: LCD off, palettes 27:74E0/7520, HDMA tiles 27:5060-6C60, 32x18 panorama tilemap 27:7060, window strip 7880 (A!=1) or 76F0 (A=1), sprites 27:7A10/7A20, WY=$70; executed |
| `27:4D81` | `CommTime_DrawHMSScreen` | PROBABLE | Loads 29:5AD0/27:7520 palettes, tiles 29:5400, tilemap 29:5800 ('こんかいのつうしんじかんは ＿じかん ＿ふん ＿びょうでした') and writes B, C, D as two 2-digit tile pairs at $9902/$9907/$990B; only reached from unexecuted code 27:4D4E |
| `27:4EC0` | `Function_27_4EC0` | HYPOTHESIS | idea: unreferenced variant of the communication-time report ('つうしんがしゅうりょうしました。 こんかいのつうしんじかんは ふん びょうでした' with tiles/tilemap of bank 51) built from timer C2D5/C2D6 with big digits (27:5021); waits for A |
| `27:4FFB` | `Function_27_4FFB` | HYPOTHESIS | idea: decimal digit extraction by repeated addition of BC (-100/-10) used by Function_27_4EC0; never executed |
| `27:5021` | `Function_27_5021` | HYPOTHESIS | idea: draws one 2-tile-high big digit (A=digit, DE=map position) from the pair table 27:5048; used by Function_27_4EC0; never executed |

### Bank 28 (MailBody)
| addr | name | status | evidence |
|---|---|---|---|
| `28:4000` | `MailBody_ViewScreen` | CONFIRMED | Mail text view screen (letter paper, airmail border, 'B もどる'): 8 lines of 12 chars from the WRAM1 $D400 text buffer (2 bytes/char, $0D newline) via 2D:4EC0; B returns A=$FF; from 2B:4075, 2D:4856, 2D:5981; executed in mail_compose |
| `28:4009` | `MailBody_ViewScreen_Loop` | CONFIRMED | per-frame loop head of MailBody_ViewScreen: sprites 00:0956, wait, 7D:7BB7 joypad, B press -> 00:20AC id $2E, wait LY $50-$59, leave |
| `28:404E` | `MailBody_InitScreen` | CONFIRMED | Builds the view screen: palettes 28:4AF0/4B30, HDMA tiles 28:42C0 (VRAM bank1 $9300) and 28:44D0 ($8000), tilemap 28:4820, object 28:4B70, then draws the 8 text lines with MailBody_DrawTextLine; executed in mail_compose |
| `28:41CB` | `MailBody_DrawTextLine` | CONFIRMED | HL=text line (2D:4EC0 output), DE=y,x, up to 12 chars: per char 7F:41A7/405F/4007/42C3 glyph blit, stops at NUL/$0D and pads blanks; sibling of 24:494C and 25:5240 (same loop, not byte-identical); executed in mail_compose |
| `28:428B` | `MailBody_BlitGlyphAdvance` | CONFIRMED | Blits the glyph buffer $C0A0 via 7F:42C3 and advances E (x) by 6; helper of MailBody_DrawTextLine (same as 24:49EC/25:52EA); executed |
| `28:429F` | `Function_28_429F` | HYPOTHESIS | idea: blits a blank cell with B=2,C=0 attributes and advances x by 6; used for the padding after a newline ($0D) in MailBody_DrawTextLine |

### Bank 29 (MailResult / MailServerStatus)
| addr | name | status | evidence |
|---|---|---|---|
| `29:4000` | `MailResult_Screen` | CONFIRMED | Communication result screen ('つうしんけっかはっぴょう': boxes 'おくったメール' / 'とどいたメール' with typed messages), waits for A (00:20AC id $2C) and returns A=0; far-called by 27:4156; executed in mail_send/mail_receive/tutorial_profile |
| `29:407A` | `MailResult_InitScreen` | CONFIRMED | Builds the result screen (LCD off, palettes 24:7A60/7AA0, HDMA tiles 24:6BF0/6FF0/73F0/7490, tilemap 24:7790, sprites 24:7B30) and prints the sent (D624) and received (D625/D626) messages; executed |
| `29:41AD` | `MailResult_ShowSentMessage` | CONFIRMED | DE=send result [D624]: 0 -> 'メールはおくっていません', $FFFF -> 'おくるのにしっぱいしました！', 2 -> 'おくれているかわかりません', 1 -> 'ちゃんとおくれました！'; typewriter-prints it into the upper box; executed |
| `29:4286` | `MailResult_ShowReceivedMessage` | CONFIRMED | DE=received count [D625/D626]: 0 -> 'メールはとどいていません' (or 'メールはうけとれませんでした' if the mailbox is full, 25:4A90==12), $FFFF -> 'うけとりにしっぱいしました！', N -> 'N つうとどいています！！' + count sprite; executed |
| `29:4374` | `MailResult_SetReceivedSprite` | PROBABLE | E-1 = received count 1..11 (else 12+): puts sprite slot DA30 on one of the 12 object rows 24:7B40..7BF0 at the number position; called by 29:42A9 for the count message; executed in mail_receive |
| `29:44F6` | `MailServerStatus_Screen` | CONFIRMED | Mail server status screen ('メールサーバじょうきょう': checked / other-software / on-server counts), C264=0 after send/receive, 1/2 in mail-server management; A returns; count dialogs 72:4015 $0224-$0226; from 27:4160, 22:4C4C, 23:4B3B; 11 scenarios |
| `29:4608` | `MailServerStatus_InitScreen` | CONFIRMED | Builds the status screen: palettes 24:7AE0, tiles 26:7420/25:6F30/25:7330/29:5060, tilemap 25:7730/7A00 (C264=0) or 25:7CD0 (C264!=0), then the counters via 4745 (mode 0), 4A65 (1) or 4D21 (2); executed |
| `29:4745` | `MailServerStatus_DrawCounts_Mode0` | CONFIRMED | C264=0: writes the three counters (WRAM1 D625/D627/D62F/D631, one's-complement 16-bit) into the number boxes, or '－－－－－' (29:47B2) when [D637]!=0 or [D627/8]==$FFFF, and uploads the tiles; executed in mail_send/mail_receive |
| `29:48C3` | `MailServerStatus_FormatNumber_M0` | PROBABLE | HL=value: fills WRAM1 $D524 with the full-width decimal string ('０００００' template 29:49DA plus digits by Divide16) and returns A=digit count; twin of 26:5447 (also 4B7F, 4E55) |
| `29:49E5` | `MailServerStatus_NumberOffset_M0` | PROBABLE | HL=value: BC = tile buffer offset ($00,$10,$20,$30,$40 for 5..1 digits) that right-aligns the number; twin of 26:5580 (also 4CA1, 4F77) |
| `29:4A45` | `MailServerStatus_UploadNumberTiles_M0` | PROBABLE | Copies WRAM2 $D000 (32 blocks) to VRAM $9000 through 7F:72C2; identical copies at 29:4D01 and 29:4FD7; executed |
| `29:4A65` | `MailServerStatus_DrawCounts_Mode1` | CONFIRMED | C264=1: same layout as mode 0 from the counters D625/D627/D629 (mail server delete flow); placeholders when [D627/8]==$FFFF; executed in mail_server_full/mail_server_hidden |
| `29:4B7F` | `MailServerStatus_FormatNumber_M1` | PROBABLE | identical copy of MailServerStatus_FormatNumber_M0 used by mode 1 |
| `29:4CA1` | `MailServerStatus_NumberOffset_M1` | PROBABLE | identical copy of MailServerStatus_NumberOffset_M0 used by mode 1 |
| `29:4D01` | `MailServerStatus_UploadNumberTiles_M1` | PROBABLE | identical copy of MailServerStatus_UploadNumberTiles_M0 used by mode 1 |
| `29:4D21` | `MailServerStatus_DrawCounts_Mode2` | CONFIRMED | C264>=2: same layout from the counters D625/D627/D629/D631 (mail server management); executed in mail_server, mail_server_full, mail_server_hidden |
| `29:4E55` | `MailServerStatus_FormatNumber_M2` | PROBABLE | identical copy of MailServerStatus_FormatNumber_M0 used by mode 2 |
| `29:4F77` | `MailServerStatus_NumberOffset_M2` | PROBABLE | identical copy of MailServerStatus_NumberOffset_M0 used by mode 2 |
| `29:4FD7` | `MailServerStatus_UploadNumberTiles_M2` | PROBABLE | identical copy of MailServerStatus_UploadNumberTiles_M0 used by mode 2 |
| `29:4FF7` | `MailServerStatus_UploadNumberTiles_Blank` | PROBABLE | Same upload (WRAM2 $D000, 32 blocks -> $9000 via 7F:72C2) used after the '－－－－－' placeholders were rendered; executed |
| `29:5017` | `MailResult_UploadTextTiles` | CONFIRMED | Copies WRAM2 $D000 and $D400 (63 blocks each) to VRAM $9000/$9400 with MailResult_StartHDMAAtVBlank after each typewriter step; executed in 8 scenarios |
| `29:503F` | `MailResult_StartHDMAAtVBlank` | CONFIRMED | HL=source, DE=VRAM dest, C=blocks-1: rHDMA1-4, wait LY=$8F then $91, rHDMA5; twin of Gfx_StartHDMAAtVBlank (25:538A); executed |
| `29:5090` | `Function_29_5090` | HYPOTHESIS | idea: start of a 742-byte unreferenced routine library (LCDC bit2 toggles, OAM copy/clear, PRNG hl=hl*5+$3711, wait LY=$90, ROM bank write, CGB palette fade via rBCPS with buffer $DBD0); no caller/pointer found, never executed |
| `29:5117` | `Function_29_5117` | HYPOTHESIS | idea: busy-wait until rLY == $90 (start of VBlank); helper of the unreferenced palette-fade library 29:5090-5376 |
| `29:511E` | `Function_29_511E` | HYPOTHESIS | idea: frame-pacing wait of the library: call $7BB7 (joypad read), then wait for LY $24/$48/$6C/$90 when A is held, else $48/$90 |
| `29:5145` | `Function_29_5145` | HYPOTHESIS | idea: rIF=0 and clears IE bit0 (VBlank interrupt off) around palette transfers |
| `29:514F` | `Function_29_514F` | HYPOTHESIS | idea: rIF=0 and sets IE bit0 (VBlank interrupt on again) |
| `29:520D` | `Function_29_520D` | HYPOTHESIS | idea: reads all 64 BG palette bytes (rBCPS/rBCPD) and 64 OBJ bytes (rOCPS/rOCPD) into the WRAM1 buffer $DBD0 (saves the current CGB palettes for a fade) |
| `29:523F` | `Function_29_523F` | HYPOTHESIS | idea: writes the 128 bytes at $DBD0 back to BG/OBJ palette RAM (rBCPD/rOCPD): restores/updates palettes after a fade step |
| `29:529F` | `Function_29_529F` | HYPOTHESIS | idea: fade step toward white: adds 1 to each 5-bit R/G/B channel of the 64 RGB555 colours at $DBD0 (clamped at $1F) |
| `29:52ED` | `Function_29_52ED` | HYPOTHESIS | idea: fade step toward black: subtracts 1 from each 5-bit R/G/B channel of the 64 RGB555 colours at $DBD0 (floor 0) |
| `29:5335` | `Function_29_5335` | HYPOTHESIS | idea: copies 64 bytes from HL twice into $DBD0 (fills the fade buffer with one palette block for BG and OBJ) |

## 4. Screens identified by rendering (tile/tilemap blocks)

| block | screen |
|---|---|
| `24:5900` (+ tiles `5400/5800/5EE0/62E0`, palette `5EA0`) | page list 'ページリスト' (six rows with tag icons; go / save / delete icons) |
| `24:5BD0` | same layout with a blank header (used when a current page exists) |
| `24:7790` (+ tiles `6BF0/6FF0/73F0/7490`, palette `7A60`) | 'つうしんけっかはっぴょう' (communication result) with boxes 'おくったメール' / 'とどいたメール' |
| `25:6410` (+ `5A10/5E10/69F0/6A00/6CF0`, palette `69B0`) | 'メールボックス' with 'ニックネーム', 年月日時分, counter 00/12 and three icons |
| `25:66E0` (+ `5F10/6310`) | delete-selection variant 'けすメールをえらんでね' |
| `25:7730 / 7A00 / 7CD0` (+ `26:7420`, `25:6F30/7330`, `29:5060`, palette `24:7AE0`) | 'メールサーバじょうきょう' status screens (see 2.4) |
| `27:7060` (+ tiles `5060-6C60`) | scrolling world panorama of the connect/hang-up screens (32 columns, rSCX moves) |
| `27:7560 7628 76F0 77B8 7880 7948` | 20x5 window strips 'キャンセルしています/しました', 'しゅうりょうしています/しました', 'せつぞくしています/しました' |
| `28:4820` | letter paper with airmail border and 'B もどる' (mail text view) |
| `28:5BD0` | 'サーバのメールをすべてけします' with はい / いいえ (mail server delete-all confirmation, loaded by 22/23) |
| `28:6860 / 6B30` | 'メールのけしかたをえらんでね' with 'かくにんしてからけす' / 'じどうでぜんぶけす' (two highlight states, loaded by 23) |
| `29:5800` (+ `29:5400`, palette `29:5AD0`) | 'こんかいのつうしんじかんは ＿じかん ＿ふん ＿びょうでした' (hours/minutes/seconds boxes; only drawn by unreachable `27:4D81`) |
| `51:55B0` (used by unreachable `27:4EC0`) | 'つうしんがしゅうりょうしました。 こんかいのつうしんじかんは ふん びょうでした。 A すすむ' |
| `26` transfer screen via `22:5980` | scenery (mountain, gate, skyline, pyramid), pipe, EXIT sign, '@' mail box, '12:34' clock, 'B キャンセル' |

## 5. Data structures and RAM (details in `analysis/naming/ram_g2.tsv`)

* `wMailScreenMode` (`C264`), `wConnWarnMinute` (`C26E`), `wConnWarnFlags` (`C26F`), `wTimerASeconds/Minutes` (`C2D5/C2D6`), `wTextCellsLeft` (`C2EE`), `wMobileResultCode/Detail`
  (`C1DD-C1DF`), `wMobileErrorCode/Detail` (`C272-C274`), `wMailSessionBlock` (`D624`, +0 send result, +1 received count, +$0A count at start, +$13 abort flag),
  `wMailCountAtStart` (`D62E`), `wMailSessionAborted` (`D637`).
* SRAM: the same CPU address holds different data per SRAM bank (`A000` = outbox flag in bank 0, first title slot in bank 1), so no single ram.inc name fits; proposals were
  not made for `A000`-`AFFF`.  Bank 1: `A000+n*$16` page titles, `A084+n*$100` page URLs (tables `24:400C`/`24:4000`).  Bank 0: `A000` outbox/compose area (first byte non-zero = mail queued:
  `27:41BC`, `25:40B0`, `7C:7C7C`), `A124+n*$12D` mail records (layout in 2.2).
* Text buffer `D400` (WRAM1) of the mail body view: 2 bytes per character (code + attribute), 12 characters per line, `$0D` newline, 8 lines (`2D:4EC0` line splitter).
* WRAM bank 2 `D000/D400/D800/DC00` = 4 text tile buffers uploaded to VRAM `$9000/$9400/$8800/$8C00` by the per-bank HDMA helpers.

## 6. Repeated code (copies, not shared routines)

`24:494C`, `25:5240`, `28:41CB` (text line) and their glyph helpers `24:49EC`, `25:52EA`, `28:428B`; `24:4A54`, `25:538A`, `26:59B6`, `29:503F` (HDMA at VBlank, only 25:538A is used across banks; 25:538A and 29:503F are byte-identical apart from their addresses, 26:59B6 adds `di`/`ei`, 24:4A54 waits LY=$5D and clears SCY, so they are variants, not byte-identical);
`26:4EC3` / `26:4F7B` and the inline blocks in `24:4083`/`24:4BD5` (time warning); `25:4987` / `25:4D99`; `26:50AC` / `27:4747`; number formatters `29:48C3`, `29:4B7F`, `29:4E55` (identical, only the template address differs) and the similar but not identical `26:5447`
(+ offset choosers `26:5580/55E0`, `29:49E5/4CA1/4F77` and tile uploaders `29:4A45/4D01/4FD7`).  The eight 12-word record address tables of bank 25 are identical.

## 7. Hypotheses and open questions

* `57:4000` (first step of `MailSendRecv_Main`, gets BC=`$D624` and D=1) and the exact meaning of the block `D624`: `D627/D629/D62F/D631` are 16-bit counters kept as one's
  complement (negated with `xor $FF ; inc`); they feed the three number boxes of the status screen ('checked', 'other software', 'on server') but the mapping per mode is not decoded.
* `26:4C94` / `26:4DAB` (sprite chosen by the received count), `26:5106` (equality of two counter differences), `wTimerEnable` bit1 (set when the adapter reports a problem?), the `72:4015` dialog ids
  (`$0108` delete page, `$0109` overwrite page, `$0206` delete mail, `$0213` reply while the outbox is occupied, `$021E/$022B` after reading a mail whose record+1 flag is set, `$0221`, `$021F` mailbox full,
  `$0224-$0226`): texts live in bank 72 (another namer).
* Record byte 0 == 1 selects the closed-envelope sprite (`Function_25_5848`): unread/new mail is likely but unproven.
* Unreachable or unreferenced code kept generic: `24:42B0` (goo.ne.jp bookmark copy), `24:53FC/53FD` (ret stubs), `26:571F/5763` (unused 'sent' / 'receive complete' banners), `26:5343`, `27:4D06-4FFB`
  (time report screens: `27:4D81` PROBABLE, `27:4EC0` with digits `27:5021/5048` HYPOTHESIS), `28:429F`, the palette-fade library `29:5090-5376` (9 HYPOTHESIS rows).
* Assets in bank 28 not named (users in banks 2A/2C/2F, not analysed here): tiles `4BD0/4FD0`, palettes `51D0`, object rows `5210-54B0`; `26:7820-7AC0` (loaded by 2A); `26:73E0` palette (no reference);
  `29:53F6-5AD0`, `29:5B10-64F4` (loaded by 27:4D81 / 2F / 2D).
* `25:6A00` is loaded twice into VRAM (`$8700` 256 B and, overlapping the 768-byte load from `69F0`, into `$8000`): the two source ranges overlap, so `Mailbox_Tiles_69F0` also contains the
  number-tile source that `Mailbox_ShowRowNumbers` re-copies to `$8010`.
* The region files still list 24:4018.. and several 25/26/29 blocks as PROBABLE although the 41-scenario coverage executes them (bank 24: all 1711 instructions; `apply_coverage` was not re-run
  for these banks); names here use the coverage-based status.

## 8. Files

* `config/symbols/bank24.tsv` .. `bank29.tsv` (277 rows), `analysis/naming/ram_g2.tsv` (13 rows), this note.
