# reference g5: banks 4C, 4E, 4F, 50, 51, 54, 55

## 1. Subsystem map

| bank | what it is | entry points (callers) | main data |
|---|---|---|---|
| 4F | **CGB palette engine** (palette staging buffer, hardware upload/dump, timed fades to/from white), **tile canvas / map helpers** used by every text screen, **boot stage 2**, and `Browser_Entry` | fades: 300+ far-call sites in 40 banks; canvas helpers: 4E, 5C, 65, 67, 68, 72; `Browser_Entry` 4F:4668 from the top menu (7C:7BA3) | WRAM bank 7 palette buffers `$D800..$D9FF`, WRAM banks 2/3 tile canvas |
| 4E | **browser UI**: session start (home page / page-list entry / CGI fetch), page-view state machine, page layout walker (link selection, scrolling, element drawing), scroll bar and connection timer, frame graphics, **save-block checksum** (SRAM bank 1) | `Browser_Entry` -> `Browser_LoadHomePage`/`Browser_LoadStagedUrl`; bank 67 CGI flows -> `Browser_LoadUrlFromSramBank3`; boot: `SaveCheck_*` | page structure in WRAM bank 4 `$D000`, 27 frame descriptors `4E:654B` |
| 4C | **page loader**: URL -> connect -> HTTP GET -> scan/layout -> inline images, error mapping; **back-stack** (6 URLs in SRAM bank 1 `$AA00`, 3 cached pages in SRAM banks 2/3); progress screens; disconnect sequences; `.bmp` wrapper; **mobile-dictionary page viewer** | `Browser_LoadPage` 4C:4000 (from 4E), `MobileDictView_Show` 4C:4F56 (from 1A) | SRAM bank 3 `$B000` page buffer, history ring, HTML template strings |
| 50 | **connection-time notice dialog** ("the communication time will soon reach N minutes, continue?", yes/no or alert) | `CommNotice_ShowDialog` 50:4000 (4E, 5C, 67, 68, 7F) | 8 screens (2 tile sets x alert/choice x under/over 60 min), palettes, cursor sprites |
| 51 | **connection-time summary screen** ("communication has ended, this time N min N sec") + timer helpers; **1-bit BMP validator / converter / tile blitter** for inline images | `CommTime_ShowSummary` 51:4000 (4E, 24, 7F), `CommTime_DrawSummaryScreen` 51:404A (mail 22/23/27), `Bmp_Validate` 51:70E0 (4C, 74), `Image_BlitToTileCanvas` 51:740D (4E) | 2 summary packs (tiles + map), digit tables, bit masks |
| 54 | **Mobile Adapter session layer**: Start/Poll task pairs over the SDK API (connect, disconnect, cancel, HTTP GET/POST, SMTP send, POP3 login/STAT/TOP/RETR/DELE), 5-minute command timeout, mail header/date parsing | 4C (browser), 4E, 23/26/27/2E (mail), 4C:439E | task state in `$C1D2-$C1E0`, request block `$C240`, mail buffers in SRAM bank 3 |
| 55 | **on-screen keyboard** (11 keyboard types, 4 pages for the Japanese ones, cursor grid 18 columns, slide-in window) and the ASCII -> full-width converter | `Kbd_Open` 55:5BA2 / `Kbd_Run` 55:5C8F (banks 2A-2F, 57, 67, 68), `Text_HalfToFullWidth` 55:6CC6 (54, 55, 57) | 25-word page table, 6-byte neighbour records per type, 224-entry width table |

### 2.1 Palette buffers and fades (WRAM bank 7)

| address (bank 7) | role |
| --- | --- |
| `$D800` | palette staging buffer (BG `$D800-$D83F`, OBJ `$D840-$D87F`) |
| `$D880` | copy of `$D800` made at the start of every fade = colours the fade starts from / returns to |
| `$D900` | 64 words filled with the fade target colour by `PalFade_Start` (`4F:41CA`) |
| `$D980` | 64 words = per-colour copy of the fade progress refilled by `PalFade_Step` (0 = unchanged, high byte set = equals target) |

| function | step | direction | LCDOn first | far-call sites |
|---|---|---|---|---|
| `Palette_FadeInFromWhite` 4F:42B4 | -$20 | white -> buffer (8 frames) | yes | 82 |
| `Palette_FadeInFromWhiteSlow` 4F:42FF | -$10 | white -> buffer (16 frames) | yes | 1 (bank 0E) |
| `Palette_FadeOutToWhite` 4F:4370 | +$20 | buffer -> white | no | 218 |
| `Palette_FadeOutToWhiteSlow` 4F:43B8 | +$10 | buffer -> white | no | 1 (bank 0E) |

### 3.1 Session flow

```
Browser_Entry (4F)                                 bank 67 CGI flows (title_settings, settings_cgi)
  -> Browser_StartHomePage / Browser_StartPageListEntry          -> Browser_BeginSession, Browser_LoadUrlFromSramBank3
       Browser_BeginSession (4E:46A3): C2C2 := A9EF&$7F (default 1), CommTime_Reset, SaveCheck_Update
       Browser_LoadHomePage (4E:48CB): C2C3=0, C2C2=1, URL := String_Browser_HomeUrl -> $C380
  -> Browser_LoadAndDispatch (4E:4962)
       Browser_ClearCaches, Browser_HistoryReset, C2CA=0, C2CB=1
       Browser_LoadPage (4C:4000)  ... result in C2CA ...   (Table_4E_4993: 0 show, 1-2 leave, 3-6 error: disconnect, leave)
  -> Browser_PageView_Enter (4E:49A1): frame graphics, Browser_RenderPage, fade in
  -> Browser_PageView_Loop (4E:4A58), JoypadDispatch (Table_4E_4AE2):
       A      Browser_PageView_FollowLink   link id hRam_FFDE -> element+14 -> URL table $D600 -> HtmlUrl_Resolve -> Browser_LoadPage (C334=1)
       B      Browser_PageView_GoBack       Browser_HistoryPop + PageCache_Pop; re-layout the cached page or fetch again
       Start  Browser_PageView_OpenMenu     BrowserMenu_* (bank 72): 1 page list, 2 hang up, 3 end; 4 link lost, 5 time warning, 6 adapter error
       Up/Down Browser_SelectPrevLink / Browser_SelectNextLink (or scroll one line)
```

### 3.2 Page layout structure (WRAM bank 4 `$D000`, pointer `hRam_FFED/EE`, bank `FFEF`; built by `Html_ParsePage`)

| offset | size | field |
|---|---|---|
| +0 | up to `$15` | page title (Shift-JIS, NUL-terminated); `Browser_DrawTitleBar` copies `$16` bytes; `Browser_Menu_PageList` copies `$14` bytes of it |
| +`$15` | 2 | number of elements (little endian) |
| +`$20` + 16*i | 16 | element i |

### 4.2 Back-stack

| structure | location | operations |
|---|---|---|
| URL history | SRAM bank 1 `$AA00..$AFFF` = 6 entries of `$100` bytes, head `A9FE` (0-5), count `A9FF` (0-6) | `Browser_HistoryPush` (from WRAM bank 6 `$D500`), `Browser_HistoryPop`, `Browser_HistoryReset` |
| page cache | 3 slots of `$1000` bytes at SRAM bank 2 `$A000`, bank 2 `$B000`, bank 3 `$A000` (`Table_PageCache_Slots` has a 4th, unused, entry), head `A9FC` (0-2), count `A9FD` (0-3) | `PageCache_Push` (current page `$B000` bank 3 -> slot), `PageCache_Pop`, `Function_4C_4D6F` (drop), `Sram_CopyLongBlock` |

## 5. Bank 50: connection-time notice (decoded)

| screen | `C1CD` | set | mode | condition | text (translated) |
|---|---|---|---|---|---|
| 1 `50:439A` | 1 | A | alert | `C26E>=60` and `C2D6>=60` | "connected continuously for N minutes or more, so the line will be cut" |
| 2 `466A` | 2 | A | yes/no | same | "... for N minutes or more. Continue as it is?  [はい] [いいえ]" |
| 3 `493A` | 3 | A | alert | otherwise | "the communication time will soon reach N minutes, so the line will be cut" |
| 4 `4C0A` | 4 | A | yes/no | otherwise | "the communication time will soon reach N minutes. Continue as it is?  [はい] [いいえ]" (executed in browser_pages) |
| 5-8 | 5-8 | B | as 1-4 | | same texts on the second frame graphics (tile set `$62F0..`, used when `C1D1` = 1) |

### 8.1 Keyboard types (`wRam_C2AB`) and pages

| type | page(s) | content | opened by |
|---|---|---|---|
| 0 | 1 (`4046`) | digits 1-5 / 6-9,0 | 68 |
| 1 | 1 (`40B2`) | lower-case letters, digits, `. @ - _ +` (the five symbols are swallowed by `Kbd_RejectSymbol`) | 68 |
| 2 | 1 (`4142`) | telephone keypad `1-9 * 0 #` | 67 |
| 3 / 4 / 5 | 1 each (`41D2/4286/433A`) | A-Z a-z 0-9 (type 3 with a space key) | 67 / 68 / 57 |
| 6 | 4 (`43EE 44A2 4556 460A`) | hiragana, katakana, full-width alphanumerics, full-width symbols | 2D |
| 7, 8 | 4 (`46BE 4772 4826 48DA`, shared) | same four pages with a different neighbour table | 2A / 2C, 2F |
| 9 | 1 (`498E`) | ASCII `A-Z a-z 0-9 . @ - _ +` (`00 xx` cells) | 2D, 2F |
| 10 | picker | three-way choice (C2BC 0-2) that `Kbd_Run` maps to keyboard type 4/5/6 (9 = cancel); remembered in SRAM bank 1 `BF05` | 2D |

## 10. Findings that update earlier documents

* `sram_layout.md`: mail record `+3..+8` = BCD year-hi, year-lo, month, day, hour, minute (54:5168 + 54:4E67); `A9FC-AFFF` of bank 1 = back-stack (4.2); bank 2/3 contents are also the page cache; `A9F8-A9FB` = accumulated connection time;
  `Table_Bmp_RowEndMask` at 51:73D1 is not a palette (region note says CGB palette).
* `mobile_trainer_serial.md`: API `$3C` is the request-abandon call (timeout path and page-load abort), `$1A` is issued after SMTP DATA, `$28/$24/$26` are used by the mail POP3 tasks with `$0FFF`-byte buffers in SRAM bank 3, `$2C` carries the CGI POST body.
* `mobile_trainer_product_notes.md` 'browser' facts: the `.bmp` wrapper is `Browser_WrapImageInHtml`; the link to `Bmp_Validate` is direct (4C:4E56).
* The `wTimerEnable` name of `C69F` covers the SDK flag byte (bit 0 busy, bit 1 error pending, bit 4 call active); timer B/A gating in `Int_VBlank` uses bits 0 and 4.

### Bank 50: connection-time notice

| addr | name | status |
| --- | --- | --- |
| `50:4000` | `CommNotice_ShowDialog` | CONFIRMED |
| `50:4061` | `CommNotice_RunDialog` | CONFIRMED |
| `50:4244` | `Table_CommNotice_Screens` | PROBABLE |
| `50:4254` | `CommNotice_DrawScreenAndLoop` | PROBABLE |
| `50:430C` | `CommNotice_HandleLeftRight` | PROBABLE |
| `50:4338` | `CommNotice_DrawChoiceCursor` | PROBABLE |
| `50:4352` | `CommNotice_DrawMinuteDigit` | PROBABLE |
| `50:438A` | `Table_CommNotice_DigitCells` | PROBABLE |
| `50:439A` | `Tilemap_CommNotice_A_CutOver60` | PROBABLE |
| `50:466A` | `Tilemap_CommNotice_A_AskOver60` | PROBABLE |
| `50:493A` | `Tilemap_CommNotice_A_CutSoon` | PROBABLE |
| `50:4C0A` | `Tilemap_CommNotice_A_AskSoon` | CONFIRMED |
| `50:4EDA` | `Tilemap_CommNotice_B_CutOver60` | PROBABLE |
| `50:51AA` | `Tilemap_CommNotice_B_AskOver60` | PROBABLE |
| `50:547A` | `Tilemap_CommNotice_B_CutSoon` | PROBABLE |
| `50:574A` | `Tilemap_CommNotice_B_AskSoon` | PROBABLE |

### Bank 55: on-screen keyboard

| addr | name | status |
| --- | --- | --- |
| `55:4000` | `Table_Kbd_StartCell` | PROBABLE |
| `55:400A` | `Table_Kbd_OkCell` | PROBABLE |
| `55:4014` | `Table_Kbd_PagePointers` | PROBABLE |
| `55:4046` | `Data_Kbd_Page_Digits` | PROBABLE |
| `55:40B2` | `Data_Kbd_Page_IdChars` | PROBABLE |
| `55:4142` | `Data_Kbd_Page_PhoneKeypad` | PROBABLE |
| `55:41D2` | `Data_Kbd_Page_Ascii3` | PROBABLE |
| `55:4286` | `Data_Kbd_Page_Ascii4` | PROBABLE |
| `55:433A` | `Data_Kbd_Page_Ascii5` | PROBABLE |
| `55:43EE` | `Data_Kbd_Page_T6_Hiragana` | PROBABLE |
| `55:44A2` | `Data_Kbd_Page_T6_Katakana` | PROBABLE |
| `55:4556` | `Data_Kbd_Page_T6_FullWidthAlnum` | PROBABLE |
| `55:460A` | `Data_Kbd_Page_T6_Symbols` | PROBABLE |
| `55:46BE` | `Data_Kbd_Page_T78_Hiragana` | PROBABLE |
| `55:4772` | `Data_Kbd_Page_T78_Katakana` | PROBABLE |
| `55:4826` | `Data_Kbd_Page_T78_FullWidthAlnum` | PROBABLE |
| `55:48DA` | `Data_Kbd_Page_T78_Symbols` | PROBABLE |
| `55:498E` | `Data_Kbd_Page_T9_Ascii` | PROBABLE |
| `55:4A42` | `Table_Kbd_NeighbourRecords` | PROBABLE |
| `55:5BA2` | `Kbd_Open` | CONFIRMED |
| `55:5C8F` | `Kbd_Run` | CONFIRMED |
| `55:5D49` | `Kbd_Run_Loop` | PROBABLE |
| `55:5E5D` | `Kbd_Run_ButtonA` | PROBABLE |
| `55:5F35` | `Kbd_FetchCell` | PROBABLE |
| `55:5F66` | `Kbd_MoveCursor` | PROBABLE |
| `55:6068` | `Function_55_6068` | PROBABLE |
| `55:6149` | `Kbd_SplitCursorIndex` | PROBABLE |
| `55:615F` | `Kbd_IndexToColRow` | PROBABLE |
| `55:616D` | `Kbd_ColRowToIndex` | PROBABLE |
| `55:6190` | `Kbd_UpdateCursorSprite` | PROBABLE |
| `55:6318` | `Kbd_SlideIn` | PROBABLE |
| `55:63E7` | `Kbd_ShowInstant` | PROBABLE |
| `55:640E` | `Kbd_GetSlideTargetY` | PROBABLE |
| `55:6427` | `Kbd_SlideOut` | PROBABLE |
| `55:651C` | `Kbd_HideInstant` | PROBABLE |
| `55:6559` | `Kbd_Hide` | PROBABLE |
| `55:65DA` | `Kbd_TypePickerLoop` | PROBABLE |
| `55:667B` | `Kbd_UpdatePickerSprites` | PROBABLE |
| `55:66C6` | `Kbd_LoadPageGraphics` | PROBABLE |
| `55:6AF0` | `Kbd_UploadPanelMap11Rows` | PROBABLE |
| `55:6B51` | `Kbd_UploadPanelMap13Rows` | PROBABLE |
| `55:6BB2` | `Kbd_ShowPageIndicator` | PROBABLE |
| `55:6BD7` | `Kbd_LoadPickerTabTiles` | PROBABLE |
| `55:6C10` | `Kbd_RequestGlyphRedraw` | PROBABLE |
| `55:6C16` | `Kbd_DrawGlyphPreview` | PROBABLE |
| `55:6CC6` | `Text_HalfToFullWidth` | CONFIRMED |
| `55:6CD4` | `Table_Text_HalfToFullWidth` | CONFIRMED |
| `55:6E94` | `Kbd_TypeHasPages` | PROBABLE |
| `55:6EAA` | `Function_55_6EAA` | PROBABLE |
| `55:6EC0` | `Function_55_6EC0` | PROBABLE |
| `55:6ED6` | `Function_55_6ED6` | PROBABLE |
| `55:6EEC` | `Function_55_6EEC` | HYPOTHESIS |
| `55:6F02` | `Function_55_6F02` | PROBABLE |
| `55:6F18` | `Function_55_6F18` | PROBABLE |
| `55:6F2E` | `Kbd_TypeWaitsWithService` | PROBABLE |
| `55:6FA1` | `Kbd_RejectSymbol` | PROBABLE |
| `55:6FCD` | `Kbd_ShowMarkerSprite` | PROBABLE |
| `55:7000` | `Kbd_HideMarkerSprite` | PROBABLE |
| `55:7007` | `Kbd_LoadInputMode` | PROBABLE |
| `55:7048` | `Kbd_SaveInputMode` | PROBABLE |

## 12. Hypotheses and open questions

* `Function_4E_4000/4002` (frame-style chooser with the wipe list `Data_4E_41E0`), `Function_4E_47EB` (20-byte statistics record), `Function_4E_6291`, `Function_4E_5D70/6087/6172`: unreferenced, likely leftovers; `A9EF` styles 3-26 never selectable.
* `Function_4E_4658` / `A9F0-A9F7` and `A9E3` (`Function_4E_4866` counts SDK errors `$12`/`$26`): counters with no consumer found.
* `Browser_Menu_LinkLost` (4) and `Browser_Menu_AdapterError` (6) were never executed; their roles rest on the bank-72 menu result table and on the code paths.
* API `$1A` is `MobileAPI_SmtpQuit` in the bank-75 naming (QUIT seen on the wire), hence `Smtp_StartQuit`/`Smtp_QuitPoll`.  `Http_Poll`'s "301/302" reading of `$32`/H=3/L=1|2 is consistent with browser_errors but the SDK constants are not decoded.
* Keyboard: the exact roles of the special keys `$82`/`$83` (return 7/8), of `C2B3`/`C2B4` (arguments of `Kbd_Run`), and of the property tables `6EAA/6EC0/6ED6/6F02/6F18` are only described by behaviour; why type 1 rejects `@.-_+`; type 6 vs 7/8 differences beyond the neighbour tables.
* `Browser_LoadUrlFromSramBank3` parameters `BC` (`C2C5/C2C6`, non-zero = POST) and `D` (`C2C4`, used at 4C:437D to decide whether the login id is fetched with 00:1586) are only partially decoded.
* `Image_BlitStripShift1..7` were never executed (only shift 0): decoded statically.
* `Function_4F_428E..452A` (fade variants with live-palette capture, black and single-OBJ-palette fades) have no caller.
* Names with status PROBABLE and a semantic prefix (`Browser_`, `Comm_`, `Kbd_`) describe the function's role as read from the code and scenarios; they may be refined when bank 72/70 dialogs and the mobile-dictionary strings are cross-checked.

Confirmed unchanged: all 173 `Palette_LoadToBuffer` sites use DE in `$D800-$D87F`; 32 / 82 / 218 call sites of upload / fade-in / fade-out; 42 / 37 / 59 callers of the canvas and map helpers; the 8 + 2 rendered screens read as documented; `Table_Text_HalfToFullWidth` (224 pairs, no undecodable pair); the keyboard page pointers, OK-cell, start-cell and per-type property tables; the mail header indexes (0 From, 3 To, 5 Subject, 6 MIME-Version, 7 X-Game-title, 8 X-Game-code, 10 Content-Type); the 29 inlined connection-time checks in 11 banks; `SaveCheck_*`; history and page-cache index arithmetic; the record `+3..+8` date layout.

* `Comm_WaitFrames` (4C:5111) is now `Sprite_WaitFrames`: its only caller is the exit path of the offline dictionary viewer, the body is a sprite pass plus VBlank wait, nothing communicates.

* `Function_54_4538` / `Function_54_4552` are now `Smtp_StartQuit` / `Smtp_QuitPoll`: API `$1A` is `MobileAPI_SmtpQuit` in the bank-75 naming (CONFIRMED there, QUIT on tcp:587 after the message in the adapter log); the earlier "TcpApi1A, role unknown" is withdrawn.

Banks 67/68 show sprite slot DAD0 while `TextBuf_GetLength` is below a threshold (1 or 9) and hide it once the text is long enough, i.e. the opposite; what the sprite means is not proven.

* `Browser_LoadScrollArrowGfx` is now `Browser_LoadScrollbarGfx`: the routine starts the thumb sprite (slot DA90, moved by `Browser_UpdateScrollThumb`); the arrows are slots DAA0/DAB0 from the 72:7828 table, so "arrow" was not supported.

`Http_Poll` also re-issues the request when SDK bit 2 (more data) is set (was undocumented).

* Menu numbering: the three link-state exits are results 4/5/6 of the bank-72 menu but 3/4/5 of `Dialog_ShowMonitored` (`Table_4E_4A37` and siblings); rows `Browser_Menu_LinkLost`, `Browser_ConnectionNotice`, `Browser_Menu_AdapterError` now say both.

* `Data_Browser_FrameDesc3` is byte-identical (31 bytes) to style 2, not only in the pointers.  "Dead in this ROM" for the frame-style chooser is softened to "no caller found".  "Settles the open question" (record date layout) is softened to "answers".

No status was upgraded.  The row counts are unchanged (47 CONFIRMED, 240 PROBABLE, 16 HYPOTHESIS; 303 rows); the RAM file has 40 rows.

| Old qualified symbol | Current qualified symbol | Address |
|---|---|---|
| `Data_55_6F3B.l6F51` | `Table_Kbd_TypeWaitsWithService_ByType.l6F51` | `55:6F51` |
| `Data_27_417A.loop` | `MailSendRecv_RequestTemplate.loop` | `27:4187` |
| `Data_27_417A.l4195` | `MailSendRecv_RequestTemplate.l4195` | `27:4195` |
| `Data_27_417A.l41A2` | `MailSendRecv_RequestTemplate.l41A2` | `27:41A2` |
| `Data_27_417A.l41B0` | `MailSendRecv_RequestTemplate.l41B0` | `27:41B0` |

CONFIRMED from original-ROM bytes and the maintained consumers: the first table has 11 flags (`01` for types 0..5, `00` for 6..10), loaded by `55:6F2E` as `table[A]` while preserving HL.

CONFIRMED `27:417A..4180` contains `04 00 00 01 24 D5 04`, copied by the loop
`27:4017` to WRAM1 `D624..D62A` before `ConnectDialog_Run` with D=1 / BC=D624.
The caller then overwrites +6 with `12-mail_count` and +7 with zero; this is a
seven-byte initial template, not a complete final argument block. The far text
pointer at +3..5 is `01:D524` (see the named bank-qualified `wMailSessionBlock`
and `wMailTextScratch` notes in `ram/banked.asm`). All seven ROM bytes are read
in 21 natural scenarios. `MailSendRecv_RequestTemplate` remains PROBABLE as an
application name; copied data and boundaries are CONFIRMED.

The former has 47 CPU starts and conditional palette-port/staging writes documented in `classify_g2.md`; the latter has 24 logical starts (four six-byte farcalls included), starts `Mobile_BeginCancel`, polls `Mobile_CancelPoll` while A=1, conditionally draws the timer summary and clears IE bits 2/3 before returning.
