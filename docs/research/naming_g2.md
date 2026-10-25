# reference G2: banks 24-29 (page list, mailbox, mail send/receive, mail body view, result screens)

## 2. Subsystem map

| bank | subsystem | entry points | main data |
| --- | --- | --- | --- |
| 24 | **Browser page list** ('ページリスト'): 6 saved pages, go / save / delete | `24:4018` `PageList_Main` (from 4E:4DB1, 4F:46D3) | SRAM bank 1 `A000+n*$16` titles, `A084+n*$100` URLs; WRAM6 `D500` current URL, `D3C0` current title; 4 hint messages `4B10` |
| 24 (data) | graphics/palettes/objects of the **communication result screen** (bank 29 loads them) | via `29:407A` | tiles `6BF0-7490`, tilemap `7790`, palettes `7A60/7AA0/7AE0`, objects `7B20` |
| 25 | **Mailbox** ('メールボックス': 12 records, 4 visible rows, read / reply / delete icons; C264=$FF = 'けすメールをえらんでね' delete-selection mode) | `25:4000` `Mailbox_Main`, `25:4A90` `Mailbox_CountRecords`, `25:4B0D` `Mailbox_LoadScreen`, `25:538A` `Gfx_StartHDMAAtVBlank` | SRAM bank 0 records `A124+n*$12D`, 12-word address tables (8 copies), attribute rows `58ED`, hints `53D0` |
| 25 (data) | tilemaps/tiles of the **mail server status screen** (bank 29 loads them) | via `29:4608` | `6F30`, `7330`, tilemaps `7730/7A00/7CD0` |
| 26 | **Mail transfer screen** (banner 'メールを そうしんしています' / 'じゅしんしています', MM:SS clock, B=cancel) driving the bank-54 SMTP/POP3 steps | `26:4000` `MailSession_Run` (from 27:40D7) | 26:59E0-6FE0 tiles (scenery), message strings `56B2..`, mail counts D624.. |
| 26 (data) | object rows of the **mailbox** (`7B00-7D41`), tiles `7420` for the status screen | via 25 | cursor brackets, arrows, digits 1-4, envelopes |
| 27 | **Mail send/receive flow**: connect screen (scrolling world panorama, 'せつぞくしています'), hang-up screen ('しゅうりょうしています'), orchestration | `27:4000` `MailSendRecv_Main` (from 7C:7C6A), `27:41E3` `MailConnect_Screen`, `27:4768` `MailDisconnect_Screen` (also called by mail server 22/23) | tiles `5060-6C60`, panorama tilemap `7060` (32x18), window strips `7560-7948`, objects `7A10` |
| 28 | **Mail text view screen** (letter paper, 8 lines) + a **shared asset bank** for the mail-server screens (22/23), the transfer-screen sprites (26/27) and screens of 2A/2C/2F | `28:4000` `MailBody_ViewScreen` (from 2B:4075, 2D:4856, 2D:5981) | tiles `42C0/44D0`, tilemap `4820`; mail-server tilemaps `5BD0/6860/6B30`; object tables `6E80-7A5D` |
| 29 | **Communication result screen** ('つうしんけっかはっぴょう') and **mail server status screen** ('メールサーバじょうきょう') | `29:4000` (from 27:4156), `29:44F6` (from 27:4160, 22:*, 23:*) | 8 result strings `421E-4374`, number formatters (3 copies), palette-fade library `5090` (dead) |

## 3. Named symbols (from `config/symbols/bank24..29.tsv`)

Function rows only, statuses as written in the TSV; data, table and string rows are in the files.  HYPOTHESIS rows keep the generic name.

### Bank 24 (PageList)

| addr | name | status |
| --- | --- | --- |
| `24:4018` | `PageList_Main` | CONFIRMED |
| `24:4083` | `PageList_Main_Loop` | CONFIRMED |
| `24:42B0` | `Function_24_42B0` | HYPOTHESIS |
| `24:42F0` | `PageList_InitScreen` | CONFIRMED |
| `24:4453` | `PageList_UpdateRowSprites` | CONFIRMED |
| `24:445C` | `PageList_InitRowSprites` | CONFIRMED |
| `24:45B7` | `PageList_HighlightRowSprite` | CONFIRMED |
| `24:4794` | `PageList_GetActionAvailability` | CONFIRMED |
| `24:47FB` | `PageList_SetActionIcons` | CONFIRMED |
| `24:483E` | `PageList_RedrawSelection` | CONFIRMED |
| `24:48C7` | `PageList_DrawAllTitles` | CONFIRMED |
| `24:494C` | `PageList_DrawTextLine` | PROBABLE |
| `24:49EC` | `PageList_BlitGlyphAdvance` | PROBABLE |
| `24:4A00` | `PageList_UploadTextTiles` | CONFIRMED |
| `24:4A54` | `PageList_StartHDMAAtVBlank` | CONFIRMED |
| `24:4A79` | `PageList_ShowMessage` | CONFIRMED |
| `24:4BCD` | `PageList_ActionMenu` | CONFIRMED |
| `24:4BD5` | `PageList_ActionMenu_Loop` | CONFIRMED |
| `24:4E46` | `PageList_ActionMenuInit` | CONFIRMED |
| `24:4E71` | `PageList_HideActionCursor` | CONFIRMED |
| `24:4E85` | `PageList_SetActionCursor` | CONFIRMED |
| `24:4EF1` | `PageList_MoveActionCursor` | CONFIRMED |
| `24:4F14` | `PageList_SaveCurrentPage` | CONFIRMED |
| `24:5164` | `PageList_GoToSlot` | CONFIRMED |
| `24:51CB` | `PageList_DeleteSlot` | CONFIRMED |
| `24:53FC` | `Function_24_53FC` | HYPOTHESIS |
| `24:53FD` | `Function_24_53FD` | HYPOTHESIS |

### Bank 25 (Mailbox)

| addr | name | status |
| --- | --- | --- |
| `25:4000` | `Mailbox_Main` | CONFIRMED |
| `25:4043` | `Mailbox_Main_Loop` | CONFIRMED |
| `25:415C` | `Mailbox_IconMenu_Loop` | CONFIRMED |
| `25:420A` | `Mailbox_IconMenu_PressA` | CONFIRMED |
| `25:446E` | `Mailbox_IconMenu_ReplyOrRead` | CONFIRMED |
| `25:4564` | `Mailbox_ReplyStart` | CONFIRMED |
| `25:465C` | `Mailbox_ReadMail` | CONFIRMED |
| `25:4804` | `Mailbox_SetActionCursor` | CONFIRMED |
| `25:4885` | `Mailbox_CursorUp` | CONFIRMED |
| `25:4907` | `Mailbox_CursorDown` | CONFIRMED |
| `25:4987` | `Mailbox_UpdateScrollArrows` | CONFIRMED |
| `25:49EB` | `Mailbox_NextRecordUsed` | CONFIRMED |
| `25:4A2D` | `Mailbox_RedrawAfterDelete` | CONFIRMED |
| `25:4A68` | `Mailbox_ShowEmptyList` | PROBABLE |
| `25:4A90` | `Mailbox_CountRecords` | CONFIRMED |
| `25:4B0D` | `Mailbox_LoadScreen` | CONFIRMED |
| `25:4D99` | `Mailbox_UpdateScrollArrows_B` | PROBABLE |
| `25:4DFD` | `Mailbox_DrawSenderName` | CONFIRMED |
| `25:4E43` | `Mailbox_DrawRowTitles` | CONFIRMED |
| `25:4F40` | `Mailbox_DrawTimestamp` | CONFIRMED |
| `25:50C2` | `Mailbox_ClearTimestamp` | CONFIRMED |
| `25:5240` | `Mailbox_DrawTextLine` | CONFIRMED |
| `25:52EA` | `Mailbox_BlitGlyphAdvance` | CONFIRMED |
| `25:52FE` | `Mailbox_DrawMailCount` | CONFIRMED |
| `25:534C` | `Mailbox_UploadTextTiles` | CONFIRMED |
| `25:538A` | `Gfx_StartHDMAAtVBlank` | CONFIRMED |
| `25:53AA` | `Mailbox_ShowHint` | CONFIRMED |
| `25:54A7` | `Mailbox_ReplyToRecord` | PROBABLE |
| `25:5581` | `Mailbox_ShowRowNumbers` | CONFIRMED |
| `25:5641` | `Mailbox_ShowRowStatusIcons` | CONFIRMED |
| `25:5848` | `Function_25_5848` | HYPOTHESIS |
| `25:5889` | `Mailbox_SetIconBarAttrs` | PROBABLE |

### Bank 26 (MailSession)

| addr | name | status |
| --- | --- | --- |
| `26:4000` | `MailSession_Run` | CONFIRMED |
| `26:412C` | `MailSession_SendPhase` | PROBABLE |
| `26:44F5` | `MailSession_ReceivePhase` | PROBABLE |
| `26:45BC` | `MailSession_ScanMailsLoop` | PROBABLE |
| `26:471B` | `MailSession_ReceiveMailsLoop` | PROBABLE |
| `26:4A8A` | `MailSession_NoMailOrFull` | PROBABLE |
| `26:4B54` | `MailSession_Finish` | PROBABLE |
| `26:4C94` | `Function_26_4C94` | HYPOTHESIS |
| `26:4DAB` | `Function_26_4DAB` | HYPOTHESIS |
| `26:4EC3` | `MailSession_CheckTimeWarning` | PROBABLE |
| `26:4F7B` | `MailSession_CheckTimeWarningRecv` | PROBABLE |
| `26:503C` | `MailSession_Cancel` | CONFIRMED |
| `26:5067` | `MailSession_ShowCommError` | CONFIRMED |
| `26:50AC` | `MailSession_PollAdapterError` | PROBABLE |
| `26:50C6` | `MailSession_ShowCommErrorNoWindow` | PROBABLE |
| `26:5106` | `Function_26_5106` | HYPOTHESIS |
| `26:5168` | `MailSession_InitScreen` | CONFIRMED |
| `26:5343` | `Function_26_5343` | HYPOTHESIS |
| `26:537C` | `MailSession_DrawMailCounts` | CONFIRMED |
| `26:5447` | `MailSession_DrawNumber` | PROBABLE |
| `26:5580` | `MailSession_TotalNumberBuffer` | PROBABLE |
| `26:55E0` | `MailSession_CurrentNumberBuffer` | PROBABLE |
| `26:5640` | `MailSession_UploadNumberTiles` | PROBABLE |
| `26:5697` | `MailSession_ShowMsgSending` | CONFIRMED |
| `26:56DB` | `MailSession_ShowMsgReceiving` | CONFIRMED |
| `26:571F` | `Function_26_571F` | HYPOTHESIS |
| `26:5763` | `Function_26_5763` | HYPOTHESIS |
| `26:57A7` | `MailSession_ShowMsgNoMail` | CONFIRMED |
| `26:57EB` | `MailSession_ShowMsgCannotReceive` | PROBABLE |
| `26:582F` | `MailSession_ShowMsgReceived` | CONFIRMED |
| `26:5873` | `MailSession_ClearMsg` | CONFIRMED |
| `26:58B7` | `MailSession_UploadMsgTiles` | CONFIRMED |
| `26:58DC` | `MailSession_UpdateTimerDisplay` | CONFIRMED |
| `26:59B6` | `MailSession_StartHDMAAtVBlank` | CONFIRMED |

### Bank 27 (MailSendRecv / MailConnect / MailDisconnect)

| addr | name | status |
| --- | --- | --- |
| `27:4000` | `MailSendRecv_Main` | CONFIRMED |
| `27:41BC` | `Mail_OutboxIsEmpty` | CONFIRMED |
| `27:41E3` | `MailConnect_Screen` | CONFIRMED |
| `27:4305` | `MailConnect_Screen_Loop` | PROBABLE |
| `27:46E5` | `MailConnect_ShowError` | PROBABLE |
| `27:4747` | `MailConnect_PollAdapterError` | PROBABLE |
| `27:4768` | `MailDisconnect_Screen` | CONFIRMED |
| `27:49B0` | `MailDisconnect_ScreenNoTimer` | PROBABLE |
| `27:4B95` | `MailConnect_InitScreen` | CONFIRMED |
| `27:4D81` | `CommTime_DrawHMSScreen` | PROBABLE |
| `27:4EC0` | `Function_27_4EC0` | HYPOTHESIS |
| `27:4FFB` | `Function_27_4FFB` | HYPOTHESIS |
| `27:5021` | `Function_27_5021` | HYPOTHESIS |

### Bank 28 (MailBody)

| addr | name | status |
| --- | --- | --- |
| `28:4000` | `MailBody_ViewScreen` | CONFIRMED |
| `28:4009` | `MailBody_ViewScreen_Loop` | CONFIRMED |
| `28:404E` | `MailBody_InitScreen` | CONFIRMED |
| `28:41CB` | `MailBody_DrawTextLine` | CONFIRMED |
| `28:428B` | `MailBody_BlitGlyphAdvance` | CONFIRMED |
| `28:429F` | `Function_28_429F` | HYPOTHESIS |

### Bank 29 (MailResult / MailServerStatus)

| addr | name | status |
| --- | --- | --- |
| `29:4000` | `MailResult_Screen` | CONFIRMED |
| `29:407A` | `MailResult_InitScreen` | CONFIRMED |
| `29:41AD` | `MailResult_ShowSentMessage` | CONFIRMED |
| `29:4286` | `MailResult_ShowReceivedMessage` | CONFIRMED |
| `29:4374` | `MailResult_SetReceivedSprite` | PROBABLE |
| `29:44F6` | `MailServerStatus_Screen` | CONFIRMED |
| `29:4608` | `MailServerStatus_InitScreen` | CONFIRMED |
| `29:4745` | `MailServerStatus_DrawCounts_Mode0` | CONFIRMED |
| `29:48C3` | `MailServerStatus_FormatNumber_M0` | PROBABLE |
| `29:49E5` | `MailServerStatus_NumberOffset_M0` | PROBABLE |
| `29:4A45` | `MailServerStatus_UploadNumberTiles_M0` | PROBABLE |
| `29:4A65` | `MailServerStatus_DrawCounts_Mode1` | CONFIRMED |
| `29:4B7F` | `MailServerStatus_FormatNumber_M1` | PROBABLE |
| `29:4CA1` | `MailServerStatus_NumberOffset_M1` | PROBABLE |
| `29:4D01` | `MailServerStatus_UploadNumberTiles_M1` | PROBABLE |
| `29:4D21` | `MailServerStatus_DrawCounts_Mode2` | CONFIRMED |
| `29:4E55` | `MailServerStatus_FormatNumber_M2` | PROBABLE |
| `29:4F77` | `MailServerStatus_NumberOffset_M2` | PROBABLE |
| `29:4FD7` | `MailServerStatus_UploadNumberTiles_M2` | PROBABLE |
| `29:4FF7` | `MailServerStatus_UploadNumberTiles_Blank` | PROBABLE |
| `29:5017` | `MailResult_UploadTextTiles` | CONFIRMED |
| `29:503F` | `MailResult_StartHDMAAtVBlank` | CONFIRMED |
| `29:5090` | `Function_29_5090` | HYPOTHESIS |
| `29:5117` | `Function_29_5117` | HYPOTHESIS |
| `29:511E` | `Function_29_511E` | HYPOTHESIS |
| `29:5145` | `Function_29_5145` | HYPOTHESIS |
| `29:514F` | `Function_29_514F` | HYPOTHESIS |
| `29:520D` | `Function_29_520D` | HYPOTHESIS |
| `29:523F` | `Function_29_523F` | HYPOTHESIS |
| `29:529F` | `Function_29_529F` | HYPOTHESIS |
| `29:52ED` | `Function_29_52ED` | HYPOTHESIS |
| `29:5335` | `Function_29_5335` | HYPOTHESIS |

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

* `57:4000` (first step of `MailSendRecv_Main`, gets BC=`$D624` and D=1) and the exact meaning of the block `D624`: `D627/D629/D62F/D631` are 16-bit counters kept as one's   complement (negated with `xor $FF ; inc`); they feed the three number boxes of the status screen ('checked', 'other software', 'on server') but the mapping per mode is not decoded.

* `26:4C94` / `26:4DAB` (sprite chosen by the received count), `26:5106` (equality of two counter differences), `wTimerEnable` bit1 (set when the adapter reports a problem?), the `72:4015` dialog ids   (`$0108` delete page, `$0109` overwrite page, `$0206` delete mail, `$0213` reply while the outbox is occupied, `$021E/$022B` after reading a mail whose record+1 flag is set, `$0221`, `$021F` mailbox full,   `$0224-$0226`): texts live in bank 72 (another namer).

* Record byte 0 == 1 selects the closed-envelope sprite (`Function_25_5848`): unread/new mail is likely but unproven.

* Unreachable or unreferenced code kept generic: `24:42B0` (goo.ne.jp bookmark copy), `24:53FC/53FD` (ret stubs), `26:571F/5763` (unused 'sent' / 'receive complete' banners), `26:5343`, `27:4D06-4FFB`   (time report screens: `27:4D81` PROBABLE, `27:4EC0` with digits `27:5021/5048` HYPOTHESIS), `28:429F`, the palette-fade library `29:5090-5376` (9 HYPOTHESIS rows).

* Assets in bank 28 not named (users in banks 2A/2C/2F, not analysed here): tiles `4BD0/4FD0`, palettes `51D0`, object rows `5210-54B0`; `26:7820-7AC0` (loaded by 2A); `26:73E0` palette (no reference);   `29:53F6-5AD0`, `29:5B10-64F4` (loaded by 27:4D81 / 2F / 2D).

* `25:6A00` is loaded twice into VRAM (`$8700` 256 B and, overlapping the 768-byte load from `69F0`, into `$8000`): the two source ranges overlap, so `Mailbox_Tiles_69F0` also contains the   number-tile source that `Mailbox_ShowRowNumbers` re-copies to `$8010`.

## Page-list action-menu stack paths

The branch-aware review distinguishes the ordinary warning abort from the
previously unobserved timer-inactive branch. With no retained extra word,
`24:4D25` pops the loop BC and then discards the `CALL 4203` return (`4206`);
`RET 4D38` exits `PageList_Main` as well. The existing `browser_pagelist`
callgraph records `ret_unmatched 24:4D38 -> 00:06FF` once at frame 37696,
corroborating that nested unwind; this is retained emulator evidence.

Both enter `PageList_ActionMenu` at frame 10008 and its loop at 10013.

The attached case keeps `wTimerEnable=$30`; removing the emulated adapter at frame 10080 makes `75:592A` store `$02` at 10123 and reaches the error-exit RET `24:4BFD` at 10125.

### Controlled serial-wait producer and return

A separate serial-peer fault demonstrates an executable producer of the inactive
branch: after frame 10060, the observer replaces incoming bytes with `$D2`
starting at the next response sync byte `$99` (activation at frame 10065).
It changes the emulated link's pending receive byte only, with no ROM, CPU
register or WRAM forcing. `$D2` clears the SDK sync-miss counter instead of
causing the twenty-invalid-byte error. The first response timeout occurs at
10709; the second at 11020 writes `wTimerEnable=$20` at `75:5A88`.
`MobileSDK_EnterErrorState` writes an error code/state but does not set flag
bit 1. The action menu therefore reaches `24:4C55` at frame 11021. Later
StopLink writes `$02` at 11219, after that branch has already been entered.

The duplicate BC pushes execute at 12515, the tail pop at `4D21` at 12586, and the return at 13505 is recorded as `24:4DB9 -> 00:0000 -> 24:4206`.
