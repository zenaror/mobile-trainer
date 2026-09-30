# Naming pass g5: banks 4C, 4E, 4F, 50, 51, 54, 55

Scope: the browser ("ホームページ") stack and its shared services.  Outputs: `config/symbols/bank{4C,4E,4F,50,51,54,55}.tsv`
(303 rows: functions, tables, strings, data labels, code labels, and HYPOTHESIS rows that keep the generic name) and
`analysis/naming/ram_g5.tsv` (40 RAM proposals after the verifier pass, not loaded by the generator).  `python3 tools/gen_asm.py verify` and `check --strict` on a copy of
`config/` with these files: IDENTICAL / OK (symbol names never change bytes).

Evidence vocabulary as everywhere: CONFIRMED (bytes / trace / rendered screen cited), PROBABLE (>= 2 independent pieces), HYPOTHESIS (an idea kept under
the generic name, nothing asserted).  Status counts of the rows: CONFIRMED 47, PROBABLE 240, HYPOTHESIS 16.
Dynamic evidence = `traces/coverage_*.tsv` (which of the 41 scenarios executed an address; queried with a small script over the coverage files);
"N scenarios" in the evidence columns always means that count.  Screens were rendered from the ROM (tiles + tilemap + attribute map, both VRAM banks,
grey shades) to read their text: bank 50 (8 screens) and bank 51 (2 screens), see sections 5 and 6.

Names used here by the other groups (checked for consistency, not duplicated): `Html_ParsePage/Html_ScanPage/HtmlUrl_*` (74), `Charset_*` (7E),
`Dialog_ShowMonitored/Dialog_Show`, `BrowserMenu_*`, `ConnIcon_*` (69/72), `PageList_*` (24), `MobileDict_*` (1A), `Timer_ResetClockB`, `Stat_*Split`,
`Joypad_*` (7D/7F), `MailRecord_*` (2D), `CommErr_*`, `Startup_*` (65).

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

## 2. Bank 4F

### 2.1 Palette buffers and fades (WRAM bank 7)

All fade/upload routines select WRAM bank 7 (`ldh [hWRAMBank],a ; ldh [rSVBK],a`) first.  The four buffers are 128 bytes = 64 CGB colours (8 BG palettes then 8 OBJ palettes):

| address (bank 7) | role | evidence |
|---|---|---|
| `$D800` | palette staging buffer (BG `$D800-$D83F`, OBJ `$D840-$D87F`) | `Palette_LoadToBuffer` (173 far-call sites: every DE in `$D800-$D87F`), `Palette_UploadBuffer` |
| `$D880` | copy of `$D800` made at the start of every fade = colours the fade starts from / returns to | `ld de,$D880 ; ld hl,$D800 ; CopyBytes` in each fade |
| `$D900` | 64 words filled with the fade target colour by `PalFade_Start` (`4F:41CA`) | `PalFade_BlendColor` reads `[$D900+DE]` |
| `$D980` | 64 words = per-colour copy of the fade progress refilled by `PalFade_Step` (0 = unchanged, high byte set = equals target) | `4F:4083` |

Control variables (WRAM 0): `C2ED` range mode (0/4-7 all colours, 1 BG only, 2 OBJ only, 3 one OBJ palette; always 0 in executed code), `C2EE/C2EF` target
colour, `C2F0/C2F1` progress 0..`$0100`, `C2F2` signed step.  `PalFade_Step` moves the progress by the step (negative step = run from the target back to the
palette: `PalFade_Start` then presets the progress to `$0100`), `PalFade_BlendColor` interpolates per RGB555 channel:
`out = src - ((src - target) * progress / 256)` (signed, via `PalFade_ScaledDelta` / `PalFade_Mul8x8`).  The four callable fades are

| function | step | direction | LCDOn first | far-call sites |
|---|---|---|---|---|
| `Palette_FadeInFromWhite` 4F:42B4 | -$20 | white -> buffer (8 frames) | yes | 82 |
| `Palette_FadeInFromWhiteSlow` 4F:42FF | -$10 | white -> buffer (16 frames) | yes | 1 (bank 0E) |
| `Palette_FadeOutToWhite` 4F:4370 | +$20 | buffer -> white | no | 218 |
| `Palette_FadeOutToWhiteSlow` 4F:43B8 | +$10 | buffer -> white | no | 1 (bank 0E) |

Eight further entry points (4F:428E, 434A, 4400, 4426, 4471, 4497, 44DF, 452A) have no caller: "capture the live palette (`Palette_ReadHardwareToBuffer`) and fall through into
the fade above", black fades (target `$0000`) and single-OBJ-palette fades (mode 3); kept as HYPOTHESIS rows.  Mode 3 looks inconsistent in the original (setup writes `$D9F0`, the step
blends from offset `$60`), harmless because nothing calls it.

### 2.2 Tile canvas and map helpers

The browser text body is drawn into an off-screen **tile canvas**: 20 tiles wide, 16 bytes per tile, rows 0-11 in WRAM bank 2 `$D000`, rows 12-23 in WRAM bank 3 (row `r`, column `c`
= `$D000 + (20*r + c)*16`; `TileCanvas_FillRect` address arithmetic `4F:4619-4632`).  `TileCanvas_UploadRect` HDMA-copies rectangles of it to VRAM one canvas row at a time
(`00:0787` with LY limit `$99 - (cols+9)/10`), `Tilemap_FillAscendingWithAttr` writes ascending tile ids and a constant attribute into the `$D000/$D400` map buffers.
Typical use (4E:612B): body map = 5 x 18 cells with ids `$20..` and 7 x 18 cells with ids `$80..`, matching the uploads of rows 0-4 to `$9200` and rows 5-11 to `$8800`.

### 2.3 Boot and the browser entry

`Boot_ClearAndInit` (4F:4717, called by `Boot` at 00:0314) and `Boot_ReinitRuntime` (4F:47A5, through ROM0 wrapper 00:1711, called by 65:4000) clear RAM and reinstall the vector stubs.
`Browser_Entry` (4F:4668, from the top menu entry 7C:7BA3; executed only in the homepage/browser/monkey scenarios): verify the save block (`4E:46CF`, reset `4E:4749`), then `Browser_StartMenuLoop`:
73:5F17 draws the start choice (strings ホームページ / ページリスト) and returns 0 (back), 1 (`Browser_StartHomePage`: `Browser_BeginSession`, `Browser_LoadHomePage`) or 2
(`Browser_StartPageListEntry`: page-list UI 24:4018, the chosen URL slot -> `$C380`, `Browser_LoadStagedUrl`); 3-5 fall into `Boot_ClearAndInit` (never observed).

## 3. Bank 4E

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

Menu results (72:689F `BrowserMenu_RunThreeItem`, dispatched by `Table_4E_4D6D`): 0 back, 1 `Browser_Menu_PageList` (title of the page to `$D3C0`, page list 24:4018, chosen entry to `$C380`, `Browser_LoadPage`),
2 `Browser_Menu_DisconnectPrompt` -> `Browser_Menu_DisconnectDo` (`Comm_Disconnect`, `CommTime_ShowSummary`, stay on the page), 3 `Browser_Menu_EndPrompt` -> `Browser_Menu_EndDo`
(disconnect, summary, leave), 4 `Browser_Menu_LinkLost`, 5 `Browser_ConnectionNotice` (`CommNotice_ShowDialog`), 6 `Browser_Menu_AdapterError` (the dialog wrapper `Dialog_ShowMonitored` reports the same three events as 3, 4, 5 through `Table_4E_4A37`/`4F1A`/`4FB7`/`4CDF`).  Executed: page list in browser_bookmarks,
hang up in settings_cgi, end and connection notice in browser_pages; 4 and 6 were never seen.  The connection-time check is an **inlined fragment of about 26 instructions** copied 29 times in 11 banks (4C 8, 23 3, 24 2, 26 3, 2E 2, 4E 2, 5C 1, 67 1, 68 2, 72 3, 7F 2)
(`C26E` threshold 9, +10 per notice up to `$45`; minutes `C2D6` >= threshold and seconds `C2D5` >= `$1E`; flag bits in `C26F`); its 'notice due' outcome branches to `Browser_ConnectionNotice` / a caller-specific handler.

### 3.2 Page layout structure (WRAM bank 4 `$D000`, pointer `hRam_FFED/EE`, bank `FFEF`; built by `Html_ParsePage`)

| offset | size | field |
|---|---|---|
| +0 | up to `$15` | page title (Shift-JIS, NUL-terminated); `Browser_DrawTitleBar` copies `$16` bytes; `Browser_Menu_PageList` copies `$14` bytes of it |
| +`$15` | 2 | number of elements (little endian) |
| +`$20` + 16*i | 16 | element i |

Element (16 bytes): `+0` x0 (word), `+2` y0 (word), `+4` x1 (word), `+6` y1 (word) (rectangle `[x0,x1) x [y0,y1)`, pixels of the page), `+8` type (0 none, **1 text run**, **4/5 bitmap**, others draw nothing;
`Table_Browser_ElementDrawHandlers`), `+9` flags (bits 0-1: 0 plain, 1 selectable link, 2 other link style; bits 2-3 and 4-5 alignment), `+10` link id, `+11..13` far pointer to the content
(text or SRAM bank 3 bitmap), `+14/15` link index into the URL pointer table `$D600` (WRAM bank 6).  Viewport variables (`hRam_FFE1..FFEC`, proposed names by group 8: `hViewX/Y/Right/Bottom/ScrollMax`):
`Browser_SetViewport(bc=$90, de=$60)` = the 144 x 96 window; `FFEB` = max(page height - 96, 0) written at the end of `Html_ParseSource` (74:43C4).  `hRam_FFDE` = id of the selected link
(0 none), `FFDF` previous.  Scrolling moves the canvas by 12 pixel rows (`Browser_ShiftCanvasUp/Down`, `$148 = one tile row + 4 px rows` source offset) and redraws only the new strip.

### 3.3 Frame descriptors (`Table_Browser_FrameDescriptors` 4E:654B, index `wRam_C2C2 & $7F`)

27 word pointers to 5 distinct descriptor addresses (the 31 bytes at 4E:65DE are identical to those at 4E:65BF): 5 far pointers (BG tiles, palette, tilemap, sprite tiles, OBJ palette - inside the bank-47 tile packages `Tiles_47_4100/4E50/5BA0`; the 4th package `68F0` is not referenced by any descriptor) + positions
(`+$F` body map, `+$11` title map, `+$13/+$15` scroll arrows, `+$17` timer sprites, `+$19` mascot/connection icon, `+$1B/+$1D` scroll bar).  Executed styles: 0 (settings/CGI pages), 1 (home / ordinary
pages), 2 (mobile-dictionary pages, set by 4C:4F56); descriptors for styles 3-26 (`Data_Browser_FrameDesc3`, `Data_Browser_FrameDesc23`) are never selected.  SRAM `$A9EF` (1..26, bit 7 = flag) stores a chosen style; the only code that writes it is the
unreferenced style chooser at 4E:4000/4002 (with the diagonal wipe list `Data_4E_41E0`, applied through `Function_4E_45FE` and `Function_4E_6291`), so the 26-style feature looks unreachable in this ROM (no caller, jump-table word or far-call site to 4E:4000/4002 was found; not proven for every indirect path).

### 3.4 Save block checksum (`SaveCheck_*`, SRAM bank 1)

`SaveCheck_Verify` (46CF, 32 scenarios, from 4F:4668 and 65:xxxx), `SaveCheck_ResetBlock` (4749, boot_states/registration), `SaveCheck_Update` (4795), `SaveCheck_Sum16` (4739).  Matches scheme 4 of `sram_layout.md`:
`A9E8..A9EB` = [~lo,~hi,lo,hi] of the 16-bit sum of `A9E8..A9F7`, `A9E4..A9E7` = the same for `A000..A683` plus `A9E4..A9E7`, `A9EC` validity flag, `A9EF&$7F` in 1..`$1A`.
`Function_4E_4658` (boot, 41/41 scenarios) copies `A9F0..A9F3` to `A9F4..A9F7`, clears `A9E3` and `A9F8..A9FB` and refreshes the sums; the meaning of the `A9F0..A9F7` counters is unknown
(the unreferenced `Function_4E_47EB` builds a 20-byte record from them).

## 4. Bank 4C

### 4.1 `Browser_LoadPage` (4C:4000)

URL in `$C380` -> `HtmlUrl_GetSchemeId` (74:5969: 1 http, `$FF` other schemes -> `Browser_LoadPage_Fail`) -> `Browser_LoadPage_Http` (4C:4291): URL copied to `$D400`, previous page pushed
(`Browser_HistoryPush`, `PageCache_Push`) when `C334` is set, then

* connected (`[C69F]` bit 4): progress screen, straight to `Browser_LoadPage_Request` (4C:43CD);
* not connected: `Browser_LoadPage_Connect` (4C:4330): progress screen (`CommProgress_Init/Step`, bank 70 for `C2C3=0`, bank 68 for `C2C3=1`), `Mobile_SessionInit` + `Mobile_ConnectPoll` (login id, e-mail address), then
  `Mobile_BeginConnect` + `Mobile_ConnectPoll` (dial + ISP login), `C2D1=1`;
* `Browser_LoadPage_Request`: SRAM bank 3 `$B000` cleared, `Url_StripFragment`, `C26D=5` + timer B reset, `Http_StartGet` (or `Http_StartPost` when the caller's BC is non-zero: body `$A000` bank 3 built by
  67:6205 `Net_BuildLoginPostBody`), `Browser_LoadPage_WaitReply` polls `Http_Poll`;
* page received: `Browser_WrapImageInHtml` (a `.bmp` URL becomes a synthetic HTML page), `Charset_ConvertPage` (7E:7D19), `Html_ScanPage` (74:4254), `Browser_FetchInlineImages` (4C:4840) when `C2C1` bit 0 (`<html>` seen), and
  `Html_ParsePage` at the end (Label_4C_460D); the result class is left in `C2CA` (0 show page, 1-2 leave, 3-6 error classes from `Browser_MapErrorToResult`);
* errors: `Browser_LoadPage_Fail` copies the SDK code `C1DD..DF` to `C272..C274`, maps it (`Table_Browser_ErrorResult`: `$24/$30-$33` -> 3, `$26` = timeout -> 5, everything else `$84`) and hangs up for `$84`.

### 4.2 Back-stack

| structure | location | operations |
|---|---|---|
| URL history | SRAM bank 1 `$AA00..$AFFF` = 6 entries of `$100` bytes, head `A9FE` (0-5), count `A9FF` (0-6) | `Browser_HistoryPush` (from WRAM bank 6 `$D500`), `Browser_HistoryPop`, `Browser_HistoryReset` |
| page cache | 3 slots of `$1000` bytes at SRAM bank 2 `$A000`, bank 2 `$B000`, bank 3 `$A000` (`Table_PageCache_Slots` has a 4th, unused, entry), head `A9FC` (0-2), count `A9FD` (0-3) | `PageCache_Push` (current page `$B000` bank 3 -> slot), `PageCache_Pop`, `Function_4C_4D6F` (drop), `Sram_CopyLongBlock` |

`Browser_ClearCaches` (first call of every session) wipes **all of SRAM banks 2 and 3** (`$2000` bytes each, including the adapter-configuration mirror `A000-A0BF` of bank 2) and clears `A9FC/A9FD`.  This resolves the
"A9F4-AFFF written by the homepage scenario" open item of `sram_layout.md`: it is the history ring plus these indexes.

### 4.3 Progress, disconnect, dictionary viewer

`CommProgress_Init/Step` are thin dispatchers on `C2C3`.  `Comm_Disconnect` (4C:46F4: `Mobile_BeginDisconnect`/`Mobile_DisconnectPoll` or `Mobile_BeginCancel`/`Mobile_CancelPoll`, else API `$36`),
`Comm_DisconnectWithProgress` (4C:47C4) and `Comm_EndOffline` (4C:477E) all end with `C26E=9, C26F=0, C2D1=0`.  `MobileDictView_Show` (4C:4F56, called from the mobile-dictionary index `MobileDict_OnA` in bank 1A with A=2 and
BC = entry id) shows a dictionary (じてん) page from ROM: `MobileDictView_LoadEntry` (name via `00:131A`/`00:1354` lookup in the bank-3F tables, banks 3D/3E hold the HTML), frame style 2, its own 6-entry history in WRAM bank 6
`$DA00` (`wRam_C2DD/C2DE`).

## 5. Bank 50: connection-time notice (decoded)

Tile set A (`$5A20..`, `$5E20..`, `$5FC0..`, `$5FD0..`) + maps `Tilemap_50_439A..` rendered from the ROM (tile ids from the maps, attribute bit 3 = VRAM bank; screens 1-8):

| screen | `C1CD` | set | mode | condition | text (translated) |
|---|---|---|---|---|---|
| 1 `50:439A` | 1 | A | alert | `C26E>=60` and `C2D6>=60` | "connected continuously for N minutes or more, so the line will be cut" |
| 2 `466A` | 2 | A | yes/no | same | "... for N minutes or more. Continue as it is?  [はい] [いいえ]" |
| 3 `493A` | 3 | A | alert | otherwise | "the communication time will soon reach N minutes, so the line will be cut" |
| 4 `4C0A` | 4 | A | yes/no | otherwise | "the communication time will soon reach N minutes. Continue as it is?  [はい] [いいえ]" (executed in browser_pages) |
| 5-8 | 5-8 | B | as 1-4 | | same texts on the second frame graphics (tile set `$62F0..`, used when `C1D1` = 1) |

`CommNotice_DrawMinuteDigit` draws the tens digit of (`C26E`+1) (first notice `C26E=9` = 10 minutes: no extra digit tile); `CommNotice_ShowDialog` returns 1 when the line was cut (answer no / alert / 10 s timeout, after messages 72:`$010F/$0110` and
`Comm_Disconnect`) and 0 when the user chose to continue.  `C1D0` = choice mode (`C2C3^1` in the browser: choice, in the settings/CGI flows 0: alert only), `C1D1` = tile set.

## 6. Bank 51

### 6.1 Connection-time summary

Timer A (`C2D4` frames, `C2D5` seconds, `C2D6` minutes, `C2D7`) counts while the SDK reports a call (`[C69F]` bit 4).  `CommTime_DrawSummaryScreen` renders (two packs by `C2C3`):
"通信が終了しました。今回の通信時間は  ふん  びょうでした。" ("communication has ended; this communication took N min N sec"), minutes/seconds as digit tile pairs (`CommTime_DrawNumber`, `CommTime_PutDigit`, `Table_CommTime_DigitTiles`) with a bottom
"A" hint; `CommTime_ShowSummary` then adds timer A to the running total `C2D8..C2DB` (`CommTime_AddTimerA`, carry at 60, clamp 59:59) and stores it in SRAM bank 1 `A9F8..A9FB`; `Browser_DrawCommTimer` shows the total as "MM:SS" digit sprites.  Executed in 18 scenarios
(mail_send/receive, browser_*, monkeys).

### 6.2 BMP loader and blitter

`Bmp_Validate` (70E0) = `Bmp_ParseHeader` + `Bmp_CheckSize` (width <= 144, height 1..96; see `mobile_trainer_product_notes.md` 'BMP header validator'); `Bmp_ConvertToTiles` (7177, from `Html_LoadPageImages` 74:53B9) compares the colour-table sums
(`Bmp_ColorSum`), re-packs the rows and rounds sizes to whole 12-pixel text rows (`Bmp_RoundUpToTextRow`); `Table_Bmp_RowEndMask` (`$FF,$7F,..,$00`) is a bit-mask table (previously labelled "palette").  `Image_BlitToTileCanvas` (740D, from `Browser_DrawElement_Bitmap`) blits a 1-bit image
into the tile canvas with the shift dispatcher (`Image_MakeEdgeMasks`, `Image_BlitEdgeStrip`, `Image_BlitStripShift0..7` chosen by `[FFD5]` bits, style bits of `[FFD0]` choosing the two bitplane bytes); only shift 0 was executed (browser_pages).

## 7. Bank 54: Mobile Adapter session layer

Every operation is a **Start / Poll pair**: the Start routine (`Mobile_Begin*`, `Http_Start*`, `Smtp_Start*`, `Pop3_Start*`) resets the task state (`C1DB=3` retries, `C1D8` kind, `C1D9=0` step), stores its arguments
(`C1D2..C1D7` = BC, DE, HL) and issues one `MobileAPI` call (`00:0150`, A = API offset); the caller loops on the Poll routine, which returns **1 = busy, `$FF` = error (result fetched with `Mobile_FetchResult` into `C1DD..DF`), 0 = done**.
Polls of long operations call `Mobile_CheckTimeout` first.  `[C69F]` (`wTimerEnable`) is the SDK flag byte: bit 0 command busy (timer B runs), bit 1 result/error pending, bit 4 call active (timer A runs).

| API | used by (bank 54) | SDK label (`analysis/mobile_candidates.json`) | independent evidence in bank 54 |
|---|---|---|---|
| `$00` | `Mobile_FetchResult` | GetLastResult | result A/HL saved to `C1DD..DF` |
| `$02` | `Mobile_SessionInit` | Init | DE=`$C271`, HL=ROM bank |
| `$06` | `Mobile_ConnectPoll` step 3 | ConnectDialAndIspLogin | block = dial string + login id (`C1E0`) + password (`C220`) |
| `$3E` | `Mobile_ConnectPoll` step 3 (C1D2=0) | ConnectWithDnsOverride | 8-byte DNS prefix + `guest`/`guest` (`String_Mobile_GuestLogin`) |
| `$0A` | `Mobile_BeginDisconnect` | Disconnect | followed by API `$36` |
| `$0C/$0E/$10` | `Mobile_ConnectPoll` | dial slots / login id / e-mail | buffers `C480`, `C1E0`, `C201` |
| `$14` | `Smtp_StartHelo` | Smtp_Helo | HL = own e-mail address |
| `$16` | `Smtp_StartMailFrom` | Smtp_MailFrom | envelope at SRAM bank 3 `$A000` (own address, recipient) |
| `$18` | `Smtp_DataPoll` | Smtp_Data | header block, body, `String_Smtp_EndOfData` |
| `$1A` | `Smtp_StartQuit` | MobileAPI_SmtpQuit (bank 75; `mobile_candidates.json` said TcpApi1A) | run after DATA in both the success and failure branch of the sender (26:42D6, 4308); mail_send adapter.log shows `QUIT` on tcp:587 right after the message |
| `$1E/$20` | `Pop3_StartLogin`, `Pop3_LoginStatPoll` | Pop3_UserPass / Pop3_Stat | `account\0password\0` block; STAT count read from `C240` |
| `$28/$24/$26` | `Pop3_StartTop/Retr/Dele` | Pop3_Top / Retr / Dele | TOP and RETR fill SRAM bank 3 `$A000` (limit `$0FFF`), DELE takes a message number |
| `$2A/$2C` | `Http_StartGet/Post` | HttpRequestA/B | request block `C240` (URL ptr, login id, password) |
| `$34/$36/$3C` | `Mobile_BeginCancel`, resets in the polls, `Mobile_BeginStop` / timeout | CancelOrAbort / ResetSdk / Api3C | see `Mobile_CheckTimeout` |

* **Timeout**: `Mobile_ResetCommandTimer` sets `C26D=5` and clears timer B (`C266..C268`); when the minutes `C268` reach the limit `Mobile_CheckTimeout` issues API `$3C`, then reports code `$26` (`C1DD=$26`) = the "26-000" 5-minute timeout of `mail_timeout` (CONFIRMED).
* **HTTP**: `Url_EnsurePath` appends `/` to a bare host, `Http_Poll` re-issues the request while the SDK flag bit 2 (more reply data) is set and retries up to 3 times on SDK code `$32` with H=3, L=1/2 (301/302?, executed in browser_errors), `Url_ResolveLocation` builds the new URL (POST becomes GET, `C1D8=7`).
* **Mail send** (bank 26 sequence `44FE, 4575, 4772, 4538`): `Smtp_StartMailFrom` builds the header block through `Mail_BuildHeaderField` (header indexes 6,0,3,5,7,8,10 = MIME-Version, From, To, Subject, X-Game-title, X-Game-code, Content-Type: the order of a real sent mail) and appends " (nickname)" (`String_Mail_CloseParen`).
* **Mail receive**: `Pop3_TopPoll` reads header fields with mail-library selector 6 (field 0 From, 5 Subject, 6 Date, 10 X-Game-title, 11 X-Game-code) into a record at SRAM bank 3 `$B400` (date 6 bytes, `$B410` subject <= `$1A`, `$B430` source label, `$B450/$B470` addresses, `$B4FF` flag); a game mail carries
  `X-Game-code: CGB-BXTJ-00` (`String_Mail_GameCodeCrystal`; BXTJ is the Japanese Pokemon Crystal code) and the title of its game, otherwise the label is `String_Mail_DefaultSource` ("メール").  `Pop3_RetrPoll` stores date/body/names in the free mail slot
  and deletes the message on the server (API `$26`).
* **Dates**: `Mail_ParseDate` turns an RFC-822 date into BCD `year-hi, year-lo, month, day, hour, minute` at `C580..C585` (month abbreviations `String_Mail_Months`, days per month `Table_Mail_DaysPerMonth`, time zone applied with carries).
  `Pop3_RetrPoll` copies these six bytes to **mail record `+3..+8`** (`MAILREC_*`): this answers the open question of `sram_layout.md` (record `+1/+2` = C25F status bytes written at the end of the RETR poll, and the default records `... 20 00 06 28 12 30` fit year-hi, year-lo, month, day, hour, minute = 2000-06-28 12:30).

## 8. Bank 55: on-screen keyboard

### 8.1 Keyboard types (`wRam_C2AB`) and pages

Decoded by hand from `Table_Kbd_PagePointers` (55:4014) and the cell bytes (cell = 2 bytes (kind, value): kind 0 ASCII, 1 control, `$FF` special key `$80..$83`, otherwise a Shift-JIS lead byte; 18 columns x 5 rows = 90 cells per page):

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

Cursor: cell index `C2B5 = row*18 + col`; `Table_Kbd_NeighbourRecords` (55:4A42) gives per type 6-byte records (left, right, up, down neighbour cell + two wrap-flag bytes), `Table_Kbd_StartCell` (`4000`) and `Table_Kbd_OkCell` (`400A`) the start and OK cells.
The type-6 panel was rendered from the ROM (bank 66 tiles `$4000/$4400/$4800` + map `66:7210`, 11 rows x 20): hiragana grid, dakuten/handakuten keys, a dotted-box space key, a return-arrow key, and in the bottom-right corner an icon key (`$83`) and an "OK" key (`$82`).
D-pad bits map to directions 0 left (bit 5), 1 right (bit 4), 2 up (bit 6), 3 down (bit 7).  `Kbd_Run` returns 1 character (`C2AE/C2AD`), 2 B, 3 newline key, 7/8 special keys `$82/$83`, `$0A` Select on type 5; 55:6E94-6F2E are per-type property tables
(pages, OK-key behaviour, whether the waits use the frame service).  The window slides in from WY=`$90` to `$28/$38` (8 pixels per frame; sound-request ids `$34/$35` sent through the bank-4 stub `00:20AC`); the per-type slide steps are in bank 7F (`KbdSlide_*`).

### 8.2 Text width conversion

`Table_Text_HalfToFullWidth` (55:6CD4) is a 224-entry Shift-JIS table indexed by `byte-$20` (ASCII and half-width katakana to full-width; verified by decoding every pair); `Text_HalfToFullWidth` (55:6CC6) is used by the keyboard glyph preview and by bank 54 to widen ASCII names.

## 9. RAM notes

WRAM/HRAM proposals are in `analysis/naming/ram_g5.tsv` (40 rows: mobile task state `C1D2-C1DB`, credentials `C1E0/C201/C220`, `C25D`, comm session flags `C2D1/C2D8`, browser state `C2C0/C2C2/C2CA/C2CB/C334/C2C7/C2C9`,
palette fade `C2ED/C2F0/C2F2`, keyboard `C2AB..C2BE/C284/C285`, browser HRAM `FFDE/FFE9`; `FFD6/FFD7` were retracted, see section 14).  Not repeated there because another group already proposed them: `C1DD/C1DE` (ram_g2), timers `C267/C268/C26D/C26E/C26F/C2D5/C2D6` (g2/g7),
`C2C1` (`wHtmlFlags`, g8), `C2C3` (`wCommSessionKind`, g7), `C2CC` (g7), `C2AD/C2AE` (`wKeyboardCharLo/Hi`, g3/g4), `FFE1-FFEF` (g8).  `C2EE/C2EF` is shared: palette fade target (4F) and `wTextCellsLeft` (banks 24-2F draw-string loops), never both at once.

Not proposed as global names because the addresses are banked (documented here instead):

* WRAM bank 7 palette buffers `$D800/$D880/$D900/$D980` (section 2.1);
* SRAM bank 1: `A9E4-A9E7` / `A9E8-A9EB` checksum bytes, `A9EC` valid flag, `A9EF` saved frame style, `A9F8-A9FB` accumulated connection time (`sCommTimeTotal`, frames/seconds/minutes/+1), `A9FC/A9FD` page-cache head/count, `A9FE/A9FF` history head/count,
  `AA00-AFFF` history ring, `BF05` keyboard input mode;
* SRAM bank 3: `B000` page buffer (`[len16]` then resource records, `Html_NextResourceRecord`), `A000` POST body / received mail (TOP/RETR buffer `$0FFF`), `A100` staged URL (`Browser_LoadUrlFromSramBank3`) / outgoing header block, `B400-B4FF` received-mail header record;
* SRAM banks 2/3: the page-cache slots (section 4.2).

## 10. Findings that update earlier documents

* `sram_layout.md`: mail record `+3..+8` = BCD year-hi, year-lo, month, day, hour, minute (54:5168 + 54:4E67); `A9FC-AFFF` of bank 1 = back-stack (4.2); bank 2/3 contents are also the page cache; `A9F8-A9FB` = accumulated connection time;
  `Table_Bmp_RowEndMask` at 51:73D1 is not a palette (region note says CGB palette).
* `mobile_trainer_serial.md`: API `$3C` is the request-abandon call (timeout path and page-load abort), `$1A` is issued after SMTP DATA, `$28/$24/$26` are used by the mail POP3 tasks with `$0FFF`-byte buffers in SRAM bank 3, `$2C` carries the CGI POST body.
* `mobile_trainer_product_notes.md` 'browser' facts: the `.bmp` wrapper is `Browser_WrapImageInHtml`; the link to `Bmp_Validate` is direct (4C:4E56).
* The `wTimerEnable` name of `C69F` covers the SDK flag byte (bit 0 busy, bit 1 error pending, bit 4 call active); timer B/A gating in `Int_VBlank` uses bits 0 and 4.

## 11. Named functions and data by subsystem

Statuses and full evidence are also in the `config/symbols/bankNN.tsv` files.

### Bank 4F: palette engine, tile canvas, boot, browser entry

| addr | name | status | evidence |
|---|---|---|---|
| `4F:4000` | `Palette_LoadToBuffer` | CONFIRMED | A=src bank HL=src DE=dst BC=count: selects WRAM bank 7 then far CopyBytes (00:06BC -> 00:050C); 173 far-call sites, every DE lies in $D800-$D87F, the palette staging buffer that 4F:404B uploads; runs in 41/41 scenarios |
| `4F:400E` | `Palette_ReadHardwareToBuffer` | CONFIRMED | HL=dst: copies the 32 BG colours (rBCPS/rBCPD) then the 32 OBJ colours (rOCPS/rOCPD) of CGB palette RAM to [HL] and [HL+$40] via 4F:4021; callers: the unreferenced wrappers 4F:428E..4471 and 6C |
| `4F:4021` | `Palette_ReadHardwareBlock` | CONFIRMED | HL=dst B=colour count C=first palette-RAM byte index (bit7 set = OBJ palette RAM): reads each byte through rBCPS/rBCPD or rOCPS/rOCPD; callers 4F:400E only |
| `4F:404B` | `Palette_UploadBuffer` | CONFIRMED | HL=WRAM palette buffer (normally $D800): writes 64 bytes to BG palette RAM then the next 64 to OBJ palette RAM via 4F:405E; 32 far-call sites plus the fade loops, always after a VBlank wait (00:047A) |
| `4F:405E` | `Palette_UploadBlock` | CONFIRMED | HL=src B=number of 8-byte blocks C=start byte index (bit7 = OBJ): writes C\|$80 to rBCPS/rOCPS (auto-increment) and streams 8 bytes per block to rBCPD/rOCPD; BG call bc=$0800, OBJ call bc=$0880 |
| `4F:4083` | `PalFade_BlendColor` | PROBABLE | DE=byte offset of one colour: mixes source [$D880+DE] toward target [$D900+DE] by progress word [$D980+DE] (0 = source, high byte set = target, else per-channel RGB555 lerp) and stores the result at [$D800+DE] |
| `4F:4146` | `PalFade_ScaledDelta` | PROBABLE | A=start B=end C=fraction/256: returns H = signed (A-B)*C/256 using 4F:4153 (negates around the multiply when A<B); called once per 5-bit channel by PalFade_BlendColor |
| `4F:4153` | `PalFade_Mul8x8` | PROBABLE | HL = A * C by 8 shift-and-add iterations; callers: PalFade_ScaledDelta only |
| `4F:4166` | `PalFade_Start` | PROBABLE | A=step (bit7 = run from the target back to the palette), BC=target colour RGB555, [C2ED]=range mode: stores target/progress ($0000, or $0100 when bit7)/step in C2EE..C2F2 and fills the $D900/$D980 arrays; 8 internal + 1 bank-48 caller |
| `4F:41E0` | `PalFade_Step` | PROBABLE | Advances the 16-bit progress [C2F0/1] by step [C2F2] (clamps at $0000/$0100 and clears the step when done), refills $D980 for the range and blends every colour; Z = no fade running, NZ = a step was done |
| `4F:428E` | `Function_4F_428E` | HYPOTHESIS | unreferenced: WRAM bank 7, VBlank wait, Palette_ReadHardwareToBuffer(HL=$D800), restore, then FALLS THROUGH into Palette_FadeInFromWhite (4F:42B4): capture the live palette, then fade in |
| `4F:42B4` | `Palette_FadeInFromWhite` | PROBABLE | Copies $D800->$D880, PalFade_Start(step $E0, target $7FFF), LCDOn, then per frame: VBlank wait + Palette_UploadBuffer + PalFade_Step until done; 82 far-call sites after a screen was built; 41/41 scenarios |
| `4F:42FF` | `Palette_FadeInFromWhiteSlow` | PROBABLE | Same as 4F:42B4 with step $F0 (twice as many frames); one caller (bank 0E), executed in 35 scenarios |
| `4F:434A` | `Function_4F_434A` | HYPOTHESIS | unreferenced: same capture prologue as 4F:428E, falls through into Palette_FadeOutToWhite (4F:4370) |
| `4F:4370` | `Palette_FadeOutToWhite` | PROBABLE | Copies $D800->$D880, PalFade_Start(step $20, target $7FFF) then per frame upload + PalFade_Step until done (no LCDOn); 218 far-call sites, typically before a screen change (then 00:09B6); 41/41 scenarios |
| `4F:43B8` | `Palette_FadeOutToWhiteSlow` | PROBABLE | Same as 4F:4370 with step $10; one caller (bank 0E), executed in 7 scenarios |
| `4F:4400` | `Function_4F_4400` | HYPOTHESIS | unreferenced: same capture prologue as 4F:428E, falls through into 4F:4426 (fade in from black, step $F0) |
| `4F:4426` | `Function_4F_4426` | HYPOTHESIS | unreferenced (only reached by fall-through from 4F:4400): copy $D800->$D880, PalFade_Start(step $F0, target $0000), LCDOn, upload+step loop: slow fade in from black |
| `4F:4471` | `Function_4F_4471` | HYPOTHESIS | unreferenced: same capture prologue as 4F:428E, falls through into 4F:4497 (fade out to black, step $10) |
| `4F:4497` | `Function_4F_4497` | HYPOTHESIS | unreferenced (only reached by fall-through from 4F:4471): PalFade_Start(step $10, target $0000) upload+step loop: slow fade out to black, no LCDOn |
| `4F:44DF` | `Function_4F_44DF` | HYPOTHESIS | unreferenced: range mode 3 (OBJ colours 56-59 only), step $F0, target $7FFF, LCDOn: fade in from white for one OBJ palette |
| `4F:452A` | `Function_4F_452A` | HYPOTHESIS | unreferenced: range mode 3, step $10, target $7FFF: fade one OBJ palette to white; mode 3 uses offset $60 in the step but $D9F0 in the setup (possible original inconsistency) |
| `4F:4572` | `TileCanvas_UploadRect` | PROBABLE | DE=VRAM dst, HL=(H row, L col) in the WRAM tile canvas, BC=(B rows, C cols): HDMA-copies each canvas row (00:0787) to consecutive VRAM tiles; canvas = 20 tiles x 16 B per row, rows 0-11 in WRAM bank 2, rows 12-23 in bank 3; 42 callers |
| `4F:45C6` | `Tilemap_FillAscendingWithAttr` | PROBABLE | HL=dst in the $D000 map buffer, BC=(B rows, C cols), DE=(D attr, E first tile): writes ascending tile ids to [HL] and D to [HL+$400] (attr plane), stride $20; tile 256 sets attr bit3 (VRAM bank 1); 59 callers, WRAM bank 7 |
| `4F:4604` | `TileCanvas_FillRect` | PROBABLE | HL=(H row, L col), BC=(B rows, C cols), DE=16-bit pattern: fills that rectangle of the 20-tile-wide tile canvas (WRAM banks 2/3, 16 B per tile) with DE repeated (0000 = blank, FFFF = solid); 37 callers, mostly bank 4E/67/68 |
| `4F:4668` | `Browser_Entry` | CONFIRMED | Called from the title menu (7C:7BA3); verifies the save block (4E:46CF / reset 4E:4749), then the Browser_StartMenuLoop; executed only in homepage/browser_* and monkey scenarios (10 of 41) |
| `4F:4680` | `Browser_StartMenuLoop` | PROBABLE | Loop head: re-checks the save block, calls 73:5F17 (start menu: strings homepage / page list) and dispatches its result through Table_4F_4698: 0 return, 1 home page, 2 page list, 3-5 -> Function_4F_4717 |
| `4F:46A5` | `Browser_StartHomePage` | CONFIRMED | Menu result 1: 4E:46A3, snapshot of flags [C69F] to [C2CC], 4E:48CB (loads the home URL) then back to the start menu; executed in 7 scenarios (browser_*, homepage, monkey_camp_*) |
| `4F:46BA` | `Browser_StartPageListEntry` | PROBABLE | Menu result 2: 4E:46A3, page-list UI 24:4018 (returns HL = chosen SRAM entry or 0), copies the $100-byte URL to $C380, SRAM off, then 4E:493B loads it; executed in 4 scenarios incl. browser_bookmarks |
| `4F:4717` | `Boot_ClearAndInit` | CONFIRMED | Boot stage 2 (called from Boot at 00:0314): SCX/SCY=0, WY=$90, WX=$A7, palettes $E4, clears C000-CAEF, FFA4-FFFD, VRAM bank 1/0 and WRAM banks 2-7, APU on, 00:0684/04A0/059F, 7D:7BF0, LCDC=$83, IE=1; 41/41 scenarios |
| `4F:47A5` | `Boot_ReinitRuntime` | CONFIRMED | Warm re-init reached through the ROM0 wrapper 00:1711 (called by 65:4000): LCDC=$83, white palettes, clears HRAM FFA4-FFFD, C000-CAEF and WRAM banks 2-7, reinstalls vectors (00:0684/04A0/059F), 7D:7BF0; 41/41 scenarios |

### Bank 4E: browser UI

| addr | name | status | evidence |
|---|---|---|---|
| `4E:4000` | `Function_4E_4000` | HYPOTHESIS | unreferenced 2-byte head (ldh [$FFD2],a) of the code at 4E:4002: screen-frame style chooser, A=style index; wipe animation Data_4E_41E0, A saves FFD2\|$80 to SRAM $A9EF, B restores it; no caller found |
| `4E:45FE` | `Function_4E_45FE` | PROBABLE | HL=cursor in Data_4E_41E0 (only caller: unreferenced 4E:4002 code): copies tile id / attr bytes at the listed offsets from SRAM bank3 $B000/$B400 to $D000/$D400, adds the group delay to wSpriteSlots+129, returns HL=next group or 0 |
| `4E:4658` | `Function_4E_4658` | CONFIRMED | Boot-time call from 65:4003 (41/41 scenarios): copies SRAM bank1 A9F0..A9F3 to A9F4..A9F7, forces (A9EF&$7F)>=1, clears A9E3 and A9F8..A9FB, then SaveCheck_Update; purpose of the counters unknown |
| `4E:46A3` | `Browser_BeginSession` | PROBABLE | Callers: the browser start paths 4F:46A5/46BA and bank-67 CGI fetches (67:6171/62D5): A9EF&$7F (default 1) -> A9EF and [C2C2], then CommTime_Reset (51:4245), then SaveCheck_Update; 13 scenarios |
| `4E:46CF` | `SaveCheck_Verify` | CONFIRMED | A=0 if SRAM bank1 block is valid else $FF: sum(A9E8..A9F7)=word A9EA, sum(A000..A683 + A9E4..A9E7)=word A9E6, (A9EF&$7F) in 1..$1A and A9EC!=0 (sram_layout scheme 4); 32 scenarios |
| `4E:4739` | `SaveCheck_Sum16` | CONFIRMED | HL=ptr BC=count DE=running sum: adds BC bytes to DE (16-bit additive checksum, frame service first); 6 internal callers (SaveCheck_*) |
| `4E:4749` | `SaveCheck_ResetBlock` | CONFIRMED | Re-initialises the bank1 block: A9E8..A9F7 cleared with valid check bytes, A9EC=A9EF=1, A000..A683 ($684 bytes) zeroed, A9E4..A9E7 = FF FF 00 00, falls into SaveCheck_Update; run by registration/boot_states scenarios (9) |
| `4E:4795` | `SaveCheck_Update` | CONFIRMED | Recomputes the two bank1 checksums: sum(A9E8..A9F7) stored as [~lo,~hi,lo,hi] at A9E8, sum(A000..A683 + A9E4..A9E7) at A9E4; 41/41 scenarios, called after every change of that block |
| `4E:47EB` | `Function_4E_47EB` | HYPOTHESIS | unreferenced: HL=dst, builds a 20-byte record from SRAM bank1 A9F0..A9FB, A9E3, A9EC, differences A9F2-A9F6 / A9F0-A9F4, [C2C2]&$80, [C69F]&$10 (statistics of the last session?) |
| `4E:4866` | `Function_4E_4866` | PROBABLE | Enables SRAM bank 1; if the last error code [C272] is $12 or $26 increments A9E3 (persistent counter cleared by 4E:4658/4687); called after a failed fetch (4C:40FE) and by 4E:51DC; 6 scenarios |
| `4E:488D` | `Browser_LoadUrlFromSramBank3` | PROBABLE | BC,D = caller parameters (C2C5/C2C6/C2C4), sets mode C2C3=1, style C2C2=0; copies the string at SRAM bank3 $A100 to $C380 then joins Browser_LoadAndDispatch; callers: bank 67 CGI fetch (67:61BA/6315), 9 scenarios |
| `4E:48CB` | `Browser_LoadHomePage` | CONFIRMED | Mode C2C3=0, style C2C2=1; copies the home URL String_Browser_HomeUrl (4E:4904) to $C380 and continues into Browser_LoadAndDispatch; caller 4F:46A5 (browser start menu, item 1); 7 browser scenarios |
| `4E:4904` | `String_Browser_HomeUrl` | CONFIRMED | ASCII "http://gameboy.datacenter.ne.jp/01/CGB-B9AJ/index.html" NUL, read as data by Browser_LoadHomePage (docs/research/mobile_trainer_product_notes.md section 2) |
| `4E:493B` | `Browser_LoadStagedUrl` | PROBABLE | Like 4E:48CB but without copying a URL: the URL is already in $C380 (chosen page-list entry from 4F:46BA); C2C3=0, C2C2=1, jumps to Browser_LoadAndDispatch; 1 caller, executed in browser_bookmarks |
| `4E:4962` | `Browser_LoadAndDispatch` | PROBABLE | Wipes page cache (4C:4C4E) and history (4C:4B54), C2CA=0, C2CB=1, runs Browser_LoadPage (4C:4000), then jumps through Table_4E_4993 on the result C2CA: 0 show page, 1-2 leave, 3-6 error: disconnect and leave |
| `4E:49A1` | `Browser_PageView_Enter` | PROBABLE | Builds the page screen: sprite reset, Browser_LoadFrameGraphics, scroll to 0/0, Browser_RenderPage, fade in (4F:42B4), then falls into the input loop; reached from Browser_LoadAndDispatch result 0 and after menu actions |
| `4E:4A58` | `Browser_PageView_Loop` | PROBABLE | Per-frame loop of the page screen: connection-time notice check (inlined), sprites, Browser_DrawCommTimer, VBlank, joypad; JoypadDispatch table 4E:4AE2: A follow link, B back, Select none, Start menu, D-pad scroll/select link |
| `4E:4B0E` | `Browser_PageView_FollowLink` | PROBABLE | A pressed: link id hRam_FFDE -> Browser_FindLinkElement -> element+14 -> URL pointer in the $D600 table (WRAM bank 6) -> HtmlUrl_Resolve/NormalizePath (74:5981/5BA0), C334=1, Browser_LoadPage again; scenarios browser_pages, browser_errors |
| `4E:4BAD` | `Browser_PageView_GoBack` | PROBABLE | B pressed: pops the previous URL (4C:4BC1) and its cached page (4C:4CF6); with a cached page re-lays it out (74:4207) and shows it, else fetches again; empty history shows message 72:$0113; executed in 3 scenarios |
| `4E:4CEB` | `Browser_PageView_OpenMenu` | PROBABLE | Start pressed: BrowserMenu_OpenTwoItem/RunTwoItem (72:63D8/6563, C2C3=1) or OpenThreeItem/RunThreeItem (72:6712/689F, C2C3=0), then the result FFF6 through Table_4E_4D6D; run in browser_pages/bookmarks/homepage/settings_cgi |
| `4E:4D7B` | `Browser_Menu_PageList` | CONFIRMED | Menu item 1 'ページリスト' (result 1 of BrowserMenu_RunThreeItem 72:689F): fade out, copies the 20-byte page title (WRAM bank 4 $D000) to $D3C0, opens the page list 24:4018; chosen entry -> $C380, Browser_LoadPage; run in browser_bookmarks |
| `4E:4EED` | `Browser_Menu_DisconnectPrompt` | CONFIRMED | Menu item 2 'でんわをきります' (hang up): prompt via Dialog_ShowMonitored (72:4000, message $0101), answer FFF6 through Table_4E_4F1A: 1 = Browser_Menu_DisconnectDo, else back to the menu; executed in settings_cgi |
| `4E:4F39` | `Browser_Menu_DisconnectDo` | CONFIRMED | Answer yes: messages 72:$010F/$0110 around Comm_Disconnect (4C:46F4), fade out, CommTime_ShowSummary (51:4000), C1DC=$0B, back to Browser_PageView_Enter (page stays readable offline); executed in settings_cgi |
| `4E:4F81` | `Browser_Menu_EndPrompt` | CONFIRMED | Menu item 3 'ホームページをしゅうりょうします' (2-item menu: 'トップメニューにもどります'): prompt via Dialog_ShowMonitored (message $0105, or $0114 offline), answer through Table_4E_4FB7: 1 = Browser_Menu_EndDo; run in browser_pages |
| `4E:4FD6` | `Browser_Menu_EndDo` | CONFIRMED | Leaves the browser: C2CA=0, fade out, sprite reset, Comm_DisconnectWithProgress (connected) or Comm_EndOffline, CommTime_ShowSummary unless C2C3=1, returns FFF6 to the caller (5009); executed in browser_pages |
| `4E:4FFC` | `Browser_Leave_Summary` | PROBABLE | Exit part: unless C2C3=1 shows CommTime_ShowSummary (51:4000), then Browser_Leave_Return; reached from Browser_Menu_EndDo, Browser_Leave_OnError and the disconnect paths |
| `4E:5009` | `Browser_Leave_Return` | PROBABLE | Common end of a browser session: sprite reset (00:09B6), C334=0, hRam_FFA7=0, returns A=hRam_FFF6 to the caller; target of results 1-2 of Table_4E_4993; executed in 9 scenarios (monkeys, settings_cgi, title_settings) |
| `4E:5018` | `Browser_Leave_OnError` | PROBABLE | Results 3-6 of Table_4E_4993: connected -> Comm_DisconnectWithProgress (4C:47C4), else Mobile_FetchResult if [C69F] bit1, API $36, C26E=9, C26F=0; then Browser_Leave_Summary; executed in 4 scenarios |
| `4E:50BE` | `Browser_ConnectionNotice` | CONFIRMED | Connection-time warning (menu result 5, dialog result 4; also the jp nz target of the inlined check): fade out, C1D0=C2C3^1, C1D1=C2C3, res 0,[C26F], CommNotice_ShowDialog (50:4000), CommTime_ShowSummary if the line was cut |
| `4E:5162` | `Browser_Menu_LinkLost` | PROBABLE | Link lost (menu result 4, dialog result 3, from BrowserMenu_Run*/Dialog_WaitInputMonitored when the call dropped): C26E=9, C26F=0, C2CA=0, message 72:$0110 'the call was cut', fade out, CommTime_ShowSummary, C1DC=0; not executed |
| `4E:51A6` | `Browser_Menu_AdapterError` | PROBABLE | Adapter error (menu result 6, dialog result 5; bit1 of [C69F] seen by BrowserMenu_Run*/Dialog_WaitInputMonitored): Mobile_FetchResult, C1DD..DF -> C272..C274, C2CA=0, 4E:4866, error screen 68:4F8C, C26E=9, CommTime_ShowSummary; not executed |
| `4E:5204` | `Browser_DrawTitleBar` | PROBABLE | Takes the page title (page structure at FFED/FFEF, first $16 bytes) or a shortened URL from $D500 (Browser_MakeShortTitle), draws it with 00:0ED3 at pixel (16,$82) and uploads it (Browser_UploadTitleCanvas); 10 scenarios |
| `4E:5274` | `Browser_MakeShortTitle` | PROBABLE | HL=string: copies to $C340 keeping at most 19 display columns (Shift-JIS lead bytes $81-$9F/$E0-$EF/$F8-$F9 count 2), appending the full-width ellipsis $81 $63 when cut; only caller 4E:5204 |
| `4E:52E7` | `Browser_RenderPage` | PROBABLE | Draws title bar (5204) and body frame (612B), scrolls to a '#' anchor of the URL at $D500 (Browser_FindAnchor over $D600), sets the viewport, draws all visible elements (574D), uploads canvas and maps, then Browser_DrawScrollIndicators |
| `4E:534B` | `Browser_FindAnchor` | PROBABLE | HL=needle (URL fragment copied to $C380), BC=pointer table ($D600, zero-word terminated): case-insensitive compare (A-Z +$20) with each entry; A=1 and DE=index on a match, A=0 at the end of the table; executed in browser_pages |
| `4E:53A1` | `Browser_ScrollUpLine` | PROBABLE | If scroll Y (FFE3/4) is non-zero subtracts $0C (one text row), redraws the new top strip after Browser_ShiftCanvasDown (5C10); called from Browser_SelectPrevLink; 5 scenarios |
| `4E:53D1` | `Browser_ScrollDownLine` | PROBABLE | Unless scroll Y is beyond the maximum scroll (FFEB/C) adds one text row ($0C) via a temporary +$60 viewport strip and Browser_ShiftCanvasUp (5B69), then redraws the bottom strip; called from Browser_SelectNextLink; 6 scenarios |
| `4E:5423` | `Browser_SetScroll` | PROBABLE | BC=scroll X, DE=scroll Y: stores them in FFE1/2 and FFE3/4 and clears the draw offset FFE9/A; callers 4E (49A1 with 0,0), 4C:4F9B, 74:4207/4254 |
| `4E:5435` | `Browser_SetViewport` | PROBABLE | BC=width DE=height (callers use $90 x $60 = the 144x96 image limit or a $0C strip): FFE5/6 = FFE1/2 + BC (right edge), FFE7/8 = FFE3/4 + DE (bottom edge) |
| `4E:544A` | `Browser_RedrawLinkById` | PROBABLE | A=link id: walks the element list (FFED/EE, bank FFEF; count at +$15, elements from +$20, 16 B each) and redraws (57DC) every visible element with flags&3=1 and id (+10) = A; used to (un)highlight a link |
| `4E:5512` | `Browser_FindLinkElement` | PROBABLE | A=link id (0 = first visible link, $FF = last): searches visible link elements (flags&3=1) and returns A=id and HL=element pointer; callers 4E:4B0E and 4C:5029 (follow link) |
| `4E:55E8` | `Browser_FindVisibleLink` | PROBABLE | A=wanted link id (0 first visible, $FF last visible): returns A = that id if a link element with it lies inside the viewport, else 0; used by Browser_SelectPrevLink/SelectNextLink to decide between selecting and scrolling |
| `4E:56DB` | `Browser_SelectPrevLink` | PROBABLE | D-pad Up (hJoyPressedRepeat bit6): selects the previous link id if visible, else scrolls up one line (53A1) and retries; then Browser_UploadBodyCanvas and Browser_DrawScrollIndicators; callers 4E:4AF9 and 4C:500C |
| `4E:5716` | `Browser_SelectNextLink` | PROBABLE | D-pad Down (bit7): selects the next link id (FFDE+1) if visible, else scrolls down one line (53D1) and retries; then upload + scroll indicators; callers 4E:4B02 and 4C:5015; 9 scenarios |
| `4E:574D` | `Browser_DrawVisibleElements` | PROBABLE | Walks the element list of the current page (FFED/EE, bank FFEF) and calls Browser_DrawElement for each element whose rectangle [x0,x1) x [y0,y1) intersects the viewport FFE1..FFE8; 10 scenarios |
| `4E:57DC` | `Browser_DrawElement` | PROBABLE | HL=16-byte element: clips it to the viewport (results FFC8..FFCF), then dispatches on its type byte (+8) through Table_Browser_ElementDrawHandlers: 1 = text run, 4/5 = bitmap, others nothing |
| `4E:589B` | `Table_Browser_ElementDrawHandlers` | PROBABLE | 8 code pointers indexed by element type (+8): 0,2,3,6,7 = ret, 1 = 4E:58AC (text via 00:1408/0ED3), 4 and 5 = 4E:5A6D (bitmap, far call 51:740D); dispatch idiom at 4E:589A |
| `4E:58AC` | `Browser_DrawElement_Text` | PROBABLE | Type-1 handler of Table_Browser_ElementDrawHandlers: flags (+9) pick the text style (link highlighted when id +10 == hBrowserSelectedLink), alignment from bits 2-5; measures with 00:1408 and draws the run with 00:0ED3 into the tile canvas |
| `4E:5A6D` | `Browser_DrawElement_Bitmap` | PROBABLE | Type-4/5 handler: same style/offset set-up, SRAM on, HL = content pointer (+11..13, bank 3), clips the image to the viewport into FFD6/FFD7 and calls Image_BlitToTileCanvas (51:740D); only executed in browser_pages |
| `4E:5B69` | `Browser_ShiftCanvasUp` | PROBABLE | Moves the 20x12-tile canvas in WRAM bank 2 up by 12 pixel rows (source offset $148 = one tile row + 4 px rows) and clears the freed bottom strip; used by Browser_ScrollDownLine; 4 scenarios |
| `4E:5C10` | `Browser_ShiftCanvasDown` | PROBABLE | Mirror of 4E:5B69: moves the canvas down by 12 pixel rows (copies backwards from $DC87/$DDCF) and clears the top strip; used by Browser_ScrollUpLine; 2 scenarios |
| `4E:5CB6` | `Browser_LoadScrollbarGfx` | PROBABLE | Loads two small tile blocks from bank 47 (4000/4010, 4080/4090 or 40C0/40D0 by C2C3 / C2C2==2) to VRAM $8FF0 (1 tile) and $97D0 (3 tiles) and starts sprite slot DA90, the scroll thumb of Browser_UpdateScrollThumb, from 72:7858; 10 scenarios |
| `4E:5D70` | `Function_4E_5D70` | HYPOTHESIS | unreferenced function head (with 4E:5D93): reloads the frame tilemap through the descriptor (+6 -> 00:08EA, +$0F/+$11 -> Tilemap_FillAscendingWithAttr), positions sprite DA90; looks like an older copy of parts of Browser_LoadFrameGraphics |
| `4E:5E11` | `Browser_DrawScrollbarTrack` | PROBABLE | If C2C0!=0: writes a 12-row vertical bar (tiles $7D, 10 x $7E, $7F; attr $05) into the map buffers at the position stored in the frame descriptor (+$1B); falls into Browser_UpdateScrollThumb |
| `4E:5E5B` | `Browser_UpdateScrollThumb` | PROBABLE | Thumb sprite (slot DA90): Y = descriptor base + scrollY*$58/(max scroll FFEB+12) via 00:0D4D and 00:0D92, or $C0 (hidden) when the page cannot scroll; entered by fall-through from 5E11 and via far call |
| `4E:5EC0` | `Browser_DrawScrollIndicators` | PROBABLE | Resets sprites DA90/DAA0/DAB0, updates the thumb, shows the up arrow (5F58) when scroll Y!=0 and the down arrow (anim 72:7828 variant $86/$89/$8B) when the page is scrollable (FFEB!=0); 8 internal callers, 10 scenarios |
| `4E:5F58` | `Browser_ShowUpArrow` | PROBABLE | Starts the up-arrow sprite in slot DAA0 (anim 72:7828, variant $85/$88/$8A by C2C3 and C2C2) at the position in frame descriptor +$13; called by Browser_DrawScrollIndicators |
| `4E:5FB9` | `Browser_DrawCommTimer` | PROBABLE | Adds the running connection timer to the stored total (51:425F) and draws "MM:SS" as digit sprites at descriptor +$17 into the shadow OAM at C000+[C2F3]; toggles C2D3 on each second change; every frame of the page view; 6 scenarios |
| `4E:6024` | `Browser_OamPutNumber` | PROBABLE | A=0..99, C=first tile base, HL=OAM ptr, D/E=y/x, B=attr: splits A into tens/ones by repeated -10 and emits two digits with Browser_OamPutDigit; callers: Browser_DrawCommTimer |
| `4E:6034` | `Browser_OamPutDigit` | PROBABLE | Emits two OAM entries at HL for one digit: tile C at (D,E) and tile C+$10 at (D+8,E) (8x16 built from two 8x8 sprites), attr B, then E += 8 |
| `4E:604C` | `ConnIcon_StartSprite` | PROBABLE | A -> [C2CE] (connection-icon state); starts sprite slot DA80 from ConnIcon_ObjTable (69:4778) with hook ConnIcon_UpdateState (69:4034) at the position in frame descriptor +$19; 6 callers, all in bank 69 (ConnIcon_* state setters) |
| `4E:6087` | `Function_4E_6087` | HYPOTHESIS | unreferenced 31-byte getter: DE = word at descriptor(C2C2&$7F)+$19 (mascot sprite position), preserving BC/HL |
| `4E:60A6` | `Browser_UploadTitleCanvas` | PROBABLE | Two TileCanvas_UploadRect calls: canvas rows $10 and $11 (col 2, 15 tiles) to VRAM $9000 and $90F0 = the title text tiles; called from 5204 and the frame loader |
| `4E:60C5` | `Browser_UploadBodyCanvas` | PROBABLE | Two TileCanvas_UploadRect calls: canvas rows 0-4 (18 cols) to VRAM $9200 and rows 5-11 to $8800 = the 12x18 text body of the page; called after every scroll or link change |
| `4E:60E4` | `Browser_ClearTitleArea` | PROBABLE | Fills the two title-bar rows of the map buffer (descriptor +$11) with tile ids $00-$1D (palette 1) via Tilemap_FillAscendingWithAttr and blanks canvas rows $10-$11 (TileCanvas_FillRect); the ids match the $9000 upload of 4E:60A6 |
| `4E:612B` | `Browser_ClearBodyArea` | PROBABLE | Fills the body map area (descriptor +$0F): 5x18 cells with ids $20.. and 7x18 with ids $80.. (matching the $9200/$8800 uploads of 4E:60C5), then blanks all 12 canvas rows (bc=$0C14); called before a page is drawn |
| `4E:6172` | `Function_4E_6172` | HYPOTHESIS | unreferenced: if A==1 returns A = $1A or $19 depending on bit7 of SRAM bank1 $A9ED, else returns at once; no caller or pointer found |
| `4E:6196` | `Browser_LoadFrameGraphics` | PROBABLE | LCD off, sprites reset, LCD on; loads tiles ($8801 from 72:6C10), then the frame descriptor Table_Browser_FrameDescriptors[C2C2&$7F]: tiles to $9001/$9401, palette to $D800, tilemap to $D000, then clears title/body areas; 10 scenarios |
| `4E:6291` | `Function_4E_6291` | HYPOTHESIS | unreferenced twin of Browser_LoadFrameGraphics using hRam_FFD2 as style index; additionally copies $800 bytes of the $D000 map to SRAM bank3 $B000 and OR-s $80 into the tile ids (snapshot for the wipe effect); only caller: 4E:4002 code |
| `4E:654B` | `Table_Browser_FrameDescriptors` | PROBABLE | 27 word pointers indexed by (wRam_C2C2 & $7F): styles 0,1,2 own descriptors 6581/65A0/65BF, 3-22 share 65DE, 23-26 share 65FD; used at 21 sites (e.g. 4E:4026, 5DA2, 612B) to fetch tiles, palette, tilemaps, sprite positions |
| `4E:6581` | `Data_Browser_FrameDesc0` | PROBABLE | 31-byte frame descriptor, style 0: far pointers +0 BG tiles 47:4100, +3 palette 47:4DD0, +6 tilemap 47:4B00, +9 sprite tiles 47:4900, +$C OBJ palette 47:4E10; then positions +$F body +$11 title +$13/15 arrows +$17 timer +$19 mascot +$1B bar |
| `4E:65A0` | `Data_Browser_FrameDesc1` | PROBABLE | frame descriptor of style 1 (the style set by Browser_LoadHomePage): far pointers into bank 47 ($4E50, $5B20, $5850, $5650, $5B60), same parameter layout as style 0 |
| `4E:65BF` | `Data_Browser_FrameDesc2` | PROBABLE | frame descriptor of style 2 (the mobile-dictionary (じてん) page style set by 4C:4F56 and tested at 4E:5CB6/5EC0): far pointers into bank 47 ($5BA0, $6870, $65A0, $63A0, $68B0) |
| `4E:65DE` | `Data_Browser_FrameDesc3` | PROBABLE | frame descriptor shared by styles 3-22 (all 31 bytes identical to style 2 at 4E:65BF); never selected by executed code (only styles 0-2 occur) |
| `4E:65FD` | `Data_Browser_FrameDesc23` | PROBABLE | frame descriptor shared by styles 23-26 (same pointers as style 1, other sprite positions); never selected by executed code |

### Bank 4C: page loader, back-stack, dictionary viewer

| addr | name | status | evidence |
|---|---|---|---|
| `4C:4000` | `Browser_LoadPage` | PROBABLE | URL in $C380 (HtmlUrl_GetSchemeId 74:5969), connect if needed (54:403D/4141), Http_StartGet into SRAM bank3 $B000, Html_ScanPage (74:4254), inline images (4C:4840), later Html_ParsePage (74:4207); result C2CA; 4 callers in 4E, 13 scenarios |
| `4C:404D` | `Browser_LoadPage_Fail` | CONFIRMED | Error exit: C1DD..DF -> C272..C274, class via Browser_MapErrorToResult; classes with bit7 first hang up (54:418C/41A3, else cancel 54:423C/4266), then 68:73DD, 68:4F8C, 4E:4866 and C2CA = class&$7F; executed in 6 scenarios |
| `4C:4291` | `Browser_LoadPage_Http` | PROBABLE | Http path (HtmlUrl_GetSchemeId result 1): copies the URL $C380 to $D400, when C334!=0 pushes the previous page into history (4B7C) and cache (4C95), then the connected / not-connected branches; executed in 13 scenarios |
| `4C:4330` | `Browser_LoadPage_Connect` | PROBABLE | Not connected: progress screen 46B8/46D6, session timers cleared, C26E=9, Mobile_SessionInit (54:403D) polled via 54:405D, then Mobile_BeginConnect (54:4141) polled again; success sets C2D1=1 and continues at Browser_LoadPage_Request |
| `4C:43CD` | `Browser_LoadPage_Request` | PROBABLE | Connected: clears SRAM bank3 $B000 ($1000 bytes), strips a URL fragment (4C:46A6), C26D=5 / timer B reset, C2C7..C2C9 = $B000 bank 3, bc=$0FFC and Http_StartGet (54:4288); then Browser_LoadPage_WaitReply |
| `4C:44BA` | `Browser_LoadPage_WaitReply` | PROBABLE | Polls Http_Poll (54:4357): 0 = page received (continues at 4537: bitmap wrap 4C:4DFB, layout 74:4254, images), $FF = error (404D), else one progress step (46D6) with the 5-minute timeout / connection-time notice logic |
| `4C:46A6` | `Url_StripFragment` | CONFIRMED | Frame service, then scans $C380 for '#' ($23) or NUL and writes a NUL there: cuts the URL fragment before the request; 3 internal callers, 11 scenarios |
| `4C:46B8` | `CommProgress_Init` | PROBABLE | A=progress kind: stores it in hRam_FFB0 and jumps by wRam_C2C3 (0 -> 70:4000, 1 -> 68:7405) which store the kind and clear the step state; 4 callers here, 11 scenarios |
| `4C:46D6` | `CommProgress_Step` | PROBABLE | A=0: run one frame of the communication progress screen, A=1: run its finish step (loops until it returns 0); dispatches by wRam_C2C3 (0 -> 70:4023, 1 -> 68:7413); returns the state byte; 24 internal callers |
| `4C:46F4` | `Comm_Disconnect` | PROBABLE | C2CF=$FF; if connected ([C69F] bit4) 54:418C then polls 54:41A3 / 54:423C+4266 keeping the page sprites animated, else API $36 (54:4765); finally C26E=9, C26F=0, C2D1=0; callers 4E:4F55 (menu item) and 50:4000; 1 scenario (settings_cgi) |
| `4C:477E` | `Comm_EndOffline` | PROBABLE | Progress kind 2, waits $96 (150) frames on the progress screen, finishes it (46D6 a=1), then API $36 (SDK reset, after 54:4011 if an error is pending) and clears C26E/C26F/C2D1; used by 4E:4FD6 when [C69F] bit4 is clear; not executed |
| `4C:47C4` | `Comm_DisconnectWithProgress` | PROBABLE | Progress kind 2, one step, Mobile_BeginDisconnect (54:418C) polled through 54:41A3 (or 54:423C/4266 after an error), finish steps, API $36, C26E=9, C26F=0, C2D1=0; used by 4E:4FF6 when connected; 5 scenarios |
| `4C:4840` | `Browser_FetchInlineImages` | PROBABLE | Walks the image URL list left by Html_ScanPage (WRAM bank 4 $DE00), resolves each URL (HtmlUrl_Resolve/NormalizePath), appends each reply to the resource list at SRAM bank3 $B000 (cursor C2C7..C9) via Http_StartGet/Poll; 5 scenarios |
| `4C:4B54` | `Browser_HistoryReset` | CONFIRMED | SRAM bank1: A9FE=A9FF=0 and $AA00..$AFFF ($600 bytes) zeroed = empty 6-entry URL history; called by Browser_LoadAndDispatch (13 scenarios) |
| `4C:4B7C` | `Browser_HistoryPush` | CONFIRMED | Stores the URL at $D500 (WRAM bank 6, $100 bytes) in the history ring: dest $AA00+$100*[A9FE] (SRAM bank1), A9FE=(A9FE+1) mod 6, A9FF=min(A9FF+1,6); 4B81 is the entry with HL/A given (5 scenarios) |
| `4C:4BC1` | `Browser_HistoryPop` | CONFIRMED | DE=dest (bank A): zeroes [DE]; if A9FF!=0: A9FF--, A9FE=(A9FE-1) mod 6 and copies that $100-byte entry to DE; returns A=[DE] (0 = history empty); 7 callers in 4E:4B8C..4E:4E6E (3 scenarios) |
| `4C:4C03` | `Sram_CopyLongBlock` | PROBABLE | HL=src (bank hRam_FFB0), DE=dst (bank hRam_FFB1), BC=length, copied in chunks of up to $200 bytes staged through $C380; an address that passes $C000 wraps to $A000 and its bank number is incremented; used by PageCache_Push/Pop |
| `4C:4C4E` | `Browser_ClearCaches` | CONFIRMED | Frame service; SRAM bank1 A9FC=A9FD=0; SRAM banks 2 and 3 wiped ($2000 bytes each): empties the 3-slot page cache; first call of Browser_LoadAndDispatch, 13 scenarios |
| `4C:4C95` | `PageCache_Push` | CONFIRMED | Copies the current page ($1000 bytes at SRAM bank3 $B000) to the slot given by Table_4C_4CEA[A9FC] (bank 2/3, $A000/$B000), A9FC=(A9FC+1) mod 3, A9FD=min(A9FD+1,3); 5 scenarios |
| `4C:4CEA` | `Table_PageCache_Slots` | PROBABLE | 4 triples (address lo, hi, SRAM bank) = $A000/2, $B000/2, $A000/3, $B000/3; only the first 3 are used (index A9FC counts mod 3); read by PageCache_Push/Pop |
| `4C:4CF6` | `PageCache_Pop` | CONFIRMED | BC=size DE=dst A=bank: if A9FD!=0: A9FD--, A9FC=(A9FC-1) mod 3, clears the destination and copies that slot back (4C:4C03), also copies $C380 to $D500; returns A=$FF when a page was restored, 0 when empty; 6 callers in 4E, 3 scenarios |
| `4C:4D6F` | `Function_4C_4D6F` | PROBABLE | Discards the newest page-cache slot and the newest history entry without copying (A9FD--, A9FC-- mod 3; A9FF--, A9FE-- mod 6); one caller (4E:4C78); not executed |
| `4C:4DB2` | `Browser_MapErrorToResult` | CONFIRMED | A=SDK error code: codes below $10 or from $34 up -> $84; $26 with C2C3=1 -> $84; otherwise Table_4C_4DD6[code-$10] ($03 for $24 and $30-$33, $05 for $26); the caller stores result&$7F in C2CA; executed in 6 scenarios |
| `4C:4DD6` | `Table_Browser_ErrorResult` | PROBABLE | 37 result classes for SDK error codes $10..$34: $84 default, $03 at codes $24 and $30-$33, $05 at $26 (5-minute timeout); read by Browser_MapErrorToResult (4C:4DC7) |
| `4C:4DFB` | `Browser_WrapImageInHtml` | PROBABLE | Scans the URL at $D500 for a case-insensitive .bmp ending, checks the reply at SRAM bank3 $B002 with Bmp_Validate (51:70E0) and prepends a synthetic <html>..<img src=URL>..</html> page (Strings 4F11/4F25/4F45) to $B000; A=1 if done, else 0 |
| `4C:4F11` | `String_Html_PageHead` | PROBABLE | ASCII "<html><head><title>" NUL: first piece of the synthetic image page built by Browser_WrapImageInHtml (loaded with ld hl,$4F11 at 4C:4E63) |
| `4C:4F25` | `String_Html_TitleToImg` | PROBABLE | ASCII "</title></head><body><img src=\"" NUL: second piece of the synthetic image page (4C:4E75) |
| `4C:4F45` | `String_Html_ImgTail` | PROBABLE | ASCII "\"></body></html>" NUL: last piece of the synthetic image page (4C:4E89) |
| `4C:4F56` | `MobileDictView_Show` | PROBABLE | A=2 (-> C2DC), BC=dictionary entry (00:131A builds the page name from the bank-3F tables): shows a ROM mobile-dictionary (じてん) page in the browser viewer, frame style 2, scroll/links/history; caller 1A:4198; 5 monkey scenarios |
| `4C:5111` | `Sprite_WaitFrames` | PROBABLE | BC=frames: loops BC times over the sprite-object pass (00:0956) and the VBlank+frame-service wait (00:044B); only caller is the exit path of MobileDictView_Show (BC=$0F), an offline screen, so not a communication routine |
| `4C:5122` | `MobileDictView_LoadEntry` | PROBABLE | ROM page load for MobileDictView_Show: wipes SRAM bank3 $B000, optional history push (5274), name $C380 -> $D500, 00:1354 finds the page, bitmap wrap 4C:4DFB, layout 74:4254/4207, images 4C:51A1; 5 scenarios |
| `4C:51A1` | `MobileDictView_LoadImages` | PROBABLE | ROM twin of Browser_FetchInlineImages: same loop over the image list (Html_NextResourceRecord 74:5B4F, HtmlUrl_Resolve 74:5981), but each image is looked up with 00:1354 instead of an HTTP request; one caller (4C:5122 path) |
| `4C:5274` | `MobileDictView_HistoryPush` | PROBABLE | Copies $80 bytes of the current name (WRAM bank 6 $D500) to $DA00+$80*[C2DE] (6 entries), C2DE=(C2DE+1) mod 6, C2DD=min(C2DD+1,6); 5 monkey scenarios |
| `4C:52A8` | `MobileDictView_HistoryPop` | PROBABLE | DE=dest: zeroes [DE]; if C2DD!=0: C2DD--, C2DE=(C2DE-1) mod 6, copies that $80-byte entry to $D500; returns A=[DE] (0 = empty); one caller (4C:509A) |

### Bank 50: connection-time notice

| addr | name | status | evidence |
|---|---|---|---|
| `50:4000` | `CommNotice_ShowDialog` | CONFIRMED | Connection-time notice ("communication time will soon reach N minutes, continue?"): runs CommNotice_RunDialog; on answer 0 (no/alert/timeout) shows 72:$010F/$0110 around Comm_Disconnect, returns 1, else 0; callers 4E,5C,67,68,7F |
| `50:4061` | `CommNotice_RunDialog` | CONFIRMED | C0D6=[C1D1], C0D8=[C1D0] (choice mode); loads tile set (C0D6=0: 5A20.., else 62F0..), picks screen C1CD 1-8 from C0D8, [C26E]>=$3C, [C2D6]>=$3C, loops: A returns C0D4^1 (1 = yes; 0 in alert mode), 10 s timeout returns 0 |
| `50:4244` | `Table_CommNotice_Screens` | PROBABLE | 8 word pointers to the 20x18 tile maps Tilemap_50_* (attribute map follows each at +$168), indexed by (C1CD-1)*2 at 50:4254; 8 screens = 2 tile sets x choice/no choice x under/over one hour |
| `50:4254` | `CommNotice_DrawScreenAndLoop` | PROBABLE | Copies map+attr pair Table_50_4244[C1CD-1] (20x18) to $D000/$D400 via 00:08EA, draws the choice cursor and minute digit, fades in (4F:42B4) and loops on JoypadDispatch (Table_50_42AC) |
| `50:430C` | `CommNotice_HandleLeftRight` | PROBABLE | In choice mode (C0D8!=0) D-pad Left/Right toggles C0D4, redraws the cursor and plays sound $29 (00:20AC); called from the loop's no-button branch (50:42B6); not executed |
| `50:4338` | `CommNotice_DrawChoiceCursor` | PROBABLE | Places sprite slot DA10 at (Y=$67, X=$27) or (Y=$67, X=$57) by C0D4: under the buttons yes (はい, left) and no (いいえ, right) of the choice screens; 2 callers here |
| `50:4352` | `CommNotice_DrawMinuteDigit` | PROBABLE | Tens of ([C26E]+1) minutes (48:4000 divide by 10) minus 2: draws digit tile $26+n and $2C+n into the map cell chosen by Table_50_438A[C1CD-1]; nothing for 10 minutes (first notice at C26E=9) |
| `50:438A` | `Table_CommNotice_DigitCells` | PROBABLE | 8 WRAM map-buffer addresses ($D0A3,$D083,$D0E4,$D0C4 twice) where CommNotice_DrawMinuteDigit writes its digit tile pair, indexed by (C1CD-1)*2 |
| `50:439A` | `Tilemap_CommNotice_A_CutOver60` | PROBABLE | Screen 1 (tile set A, no choice, C26E>=60 and C2D6>=60), text rendered from the tiles: "N minutes or more of continuous communication, so the line will be cut" (0ぷんいじょう れんぞくで つうしんしていますので せつだんをおこないます); attr map follows at +$168 |
| `50:466A` | `Tilemap_CommNotice_A_AskOver60` | PROBABLE | Screen 2 (set A, choice, over 60): "connected continuously for N minutes or more. Continue as it is? [はい][いいえ]" |
| `50:493A` | `Tilemap_CommNotice_A_CutSoon` | PROBABLE | Screen 3 (set A, no choice, under 60): "the communication time will soon reach N minutes, so the line will be cut" (つうしんじかんがまもなく 0ぷんに なりますので せつだんをおこないます) |
| `50:4C0A` | `Tilemap_CommNotice_A_AskSoon` | CONFIRMED | Screen 4 (set A, choice, under 60; the one executed in browser_pages): "the communication time will soon reach N minutes. Continue as it is? [はい][いいえ]" (このまま つづけますか?); left button = yes at x=$27 |
| `50:4EDA` | `Tilemap_CommNotice_B_CutOver60` | PROBABLE | Screen 5 (tile set B used when C1D1=1, no choice, over 60): same text as screen 1 with the other frame graphics |
| `50:51AA` | `Tilemap_CommNotice_B_AskOver60` | PROBABLE | Screen 6 (set B, choice, over 60): same text as screen 2 |
| `50:547A` | `Tilemap_CommNotice_B_CutSoon` | PROBABLE | Screen 7 (set B, no choice, under 60): same text as screen 3 |
| `50:574A` | `Tilemap_CommNotice_B_AskSoon` | PROBABLE | Screen 8 (set B, choice, under 60): same text as screen 4 |

### Bank 51: connection-time summary, BMP loader, image blitter

| addr | name | status | evidence |
|---|---|---|---|
| `51:4000` | `CommTime_ShowSummary` | CONFIRMED | Shows this session's connection-time summary (404A, only if timer A ran), adds timer A to the stored total (425F -> C2D8..DA), clears timer A (C2D4..D7), saves the 4 total bytes to SRAM bank1 A9F8..A9FB; callers 24, 4E (7), 7F; 5 scenarios |
| `51:404A` | `CommTime_DrawSummaryScreen` | CONFIRMED | LCD off, loads tiles/palette/map (2 packs by C2C3), prints session minutes (C2D6) and seconds (C2D5), clamped at 59:59, as digit tile pairs at $D162/$D167, waits for A; returns at once if timer A never ran (4239); 18 scenarios |
| `51:41D8` | `CommTime_DrawNumber` | PROBABLE | HL=value BC=-divisor DE=map ptr: counts how many times the divisor fits (add hl,bc loop), draws that digit with CommTime_PutDigit (suppressing leading zeros via hRam_FFB4) and returns the remainder in HL; used with -100 and -10 |
| `51:41FE` | `CommTime_PutDigit` | PROBABLE | A=0..9, DE=map cell: writes the top tile at [DE] and bottom tile at [DE+$20] from Table_CommTime_DigitTiles (pairs at $4225+2*A) and attr $08 at +$400 / +$420 |
| `51:4225` | `Table_CommTime_DigitTiles` | PROBABLE | 10 (top, bottom) tile-id pairs for digits 0-9 ($67/$77, $68/$78, ... $6E/$7F) read by CommTime_PutDigit with de = $4225 + 2*a |
| `51:4239` | `CommTime_TimerAIsNonZero` | PROBABLE | Returns A!=0 if any of C2D4..C2D7 (timer A frames/seconds/minutes/+1) is non-zero, i.e. a connection was timed since the last reset; callers: mail screens 22/23/27 and CommTime_DrawSummaryScreen |
| `51:4245` | `CommTime_Reset` | PROBABLE | Zeroes the stored total C2D8..C2DB and timer A C2D4..C2D7; called at session start by Browser_BeginSession (4E:46A3) and from the mail screens (22/23/27) |
| `51:425F` | `CommTime_AddTimerA` | PROBABLE | Adds timer A (C2D4 frames, C2D5 seconds, C2D6 minutes) to the total (C2D8..C2DA), carrying at 60 (binary, not BCD); results hRam_FFB0..B2 = frames, seconds, minutes, clamped to 59:59; callers 51:4000, 4E:5FB9, 68 |
| `51:4AA0` | `Tilemap_CommTime_SummaryA` | PROBABLE | Map + attr (20x18 each) of the summary screen with tiles $42A0/$46A0 (C2C3=1): "つうしんがしゅうりょうしました。こんかいのつうしんじかんは  ふん  びょうでした。" (communication ended; this time N min N sec) and a bottom bar "A 次へ" |
| `51:55B0` | `Tilemap_CommTime_SummaryB` | PROBABLE | Map + attr of the summary screen with tiles $4DB0/$51B0 (C2C3=0, mail/browser variant): the same sentence as Tilemap_CommTime_SummaryA, button hint "A すすむ" instead of "A 次へ" |
| `51:70E0` | `Bmp_Validate` | PROBABLE | HL=file data in SRAM bank 3: Bmp_ParseHeader then Bmp_CheckSize; A=1 when the 1-bit BMP is acceptable (docs/research/mobile_trainer_product_notes.md 'BMP header validator'); callers 4C:4E56 (image URL wrapper) and 74; 1 scenario |
| `51:70F4` | `Bmp_ParseHeader` | PROBABLE | Requires 'B' 'M', reads the data offset (BC), width byte -> hRam_FFD6, height byte -> hRam_FFD7, top-down flag -> C33F, planes=1, bpp=1, compression 0, colours-used 0; returns HL = data start + BC and A=1 or A=0 on any mismatch |
| `51:7161` | `Bmp_CheckSize` | PROBABLE | Accepts width <= $90 (144) and height 1..$60 (96) taken from hRam_FFD6/FFD7; A=1 if the image fits the 144x96 viewport of the page renderer |
| `51:7177` | `Bmp_ConvertToTiles` | PROBABLE | HL=BMP in SRAM bank 3: validates, compares the two colour-table sums (Bmp_ColorSum) for the invert flag (C331 bit7), pads rows to 32 bits, re-packs them into 8-pixel strips (WRAM bank 3 $D000), fixes type-4 element pointers; caller 74:53B9 |
| `51:73D1` | `Table_Bmp_RowEndMask` | PROBABLE | 9 bit masks $FF,$7F,$3F,$1F,$0F,$07,$03,$01,$00 (not a palette): OR-ed into the last byte of a bitmap row for width%8 = 1..7 at 51:7276-7286 to set the unused pixel bits |
| `51:73DA` | `Bmp_ColorSum` | PROBABLE | HL=colour-table entry (B,G,R,pad): returns DE = 2*(B+G+R) and HL advanced by 4; called twice by Bmp_ConvertToTiles to order the two palette entries by brightness |
| `51:73F2` | `Bmp_RoundUpToTextRow` | PROBABLE | A=pixel count: returns A = 12 * ceil(A/12) (Divide32by15 by 12, remainder test, then *12); 2 callers in Bmp_ConvertToTiles for width and height, so images cover whole 12-px text rows |
| `51:740D` | `Image_BlitToTileCanvas` | PROBABLE | A=style (FFC2 -> FFD0), HL=1-bit image rows in SRAM bank 3, BC/DE clip offsets from Browser_DrawElement: shifts each row by the x offset (74E6 masks, 7517, unrolled 76AB..78B7) into the WRAM tile canvas (banks 2/3 at $D000); caller 4E:5B5C |
| `51:74E6` | `Image_MakeEdgeMasks` | PROBABLE | D = image x position, [FFD6] = width: hRam_FFD1 = left-edge pixel mask ($FF when aligned, else (1<<(8-(D&7)))-1), hRam_FFD2 = right-edge mask from (D+width)&7; used by Image_BlitToTileCanvas |
| `51:7517` | `Image_BlitEdgeStrip` | PROBABLE | One tile column of a partial (edge) strip: shifts the source left by [FFD5] bits, masks with FFD1/FFD2 and writes two bitplane bytes per pixel row as chosen by the style [FFD0] (bits 0/4 and 1/5: zero, data, inverted data or ones) |
| `51:76AB` | `Image_BlitStripShift0` | PROBABLE | Inner loop for a full tile column, shift 0 (chosen by [FFD5] at 51:75F8): C pixel rows, two bitplane bytes each per style [FFD0], destination +$0E after each pair (next pixel row of the tile); run in browser_pages |
| `51:76EF` | `Image_BlitStripShift1` | PROBABLE | Same as Image_BlitStripShift0 with the source pair shifted left by 1 bit (rla / rl b once); dispatched by [FFD5] = 1; not executed |
| `51:7737` | `Image_BlitStripShift2` | PROBABLE | Same with a 2-bit shift (two rla/rl b); dispatched by [FFD5] = 2; not executed |
| `51:7782` | `Image_BlitStripShift3` | PROBABLE | Same with a 3-bit shift; dispatched by [FFD5] = 3; not executed |
| `51:77D0` | `Image_BlitStripShift4` | PROBABLE | Same for shift 4 (merges the nibbles of the byte pair with swap); chosen by [FFD5] = 4 (bit2 set, bits1/0 clear); not executed |
| `51:781D` | `Image_BlitStripShift5` | PROBABLE | Same for shift amount 5; dispatched by [FFD5] = 5; not executed |
| `51:786B` | `Image_BlitStripShift6` | PROBABLE | Same for shift amount 6; dispatched by [FFD5] = 6; not executed |
| `51:78B7` | `Image_BlitStripShift7` | PROBABLE | Same for shift 7 (rr b / rra of the byte pair); chosen by [FFD5] = 7; not executed |

### Bank 54: Mobile Adapter session layer

| addr | name | status | evidence |
|---|---|---|---|
| `54:4000` | `Mobile_ResetCommandTimer` | PROBABLE | C26D=5 (timeout limit, minutes), timer B C266..C268=0, C1DA=0: arms the 5-minute command timeout checked by Mobile_CheckTimeout; called at the start of the SMTP/POP3 tasks (7 callers); 4C:417D and 4C:4467 set the same fields by hand |
| `54:4011` | `Mobile_FetchResult` | PROBABLE | MobileAPI $00 (get last result): stores A in C1DD, L/H in C1DE/C1DF; clears C2D1 (session active) unless the code is $3x, $20, $21, $24 or $26; 13 internal + 11 external callers (4C, 4E, 26, 27, 2E); 6 scenarios |
| `54:403D` | `Mobile_SessionInit` | PROBABLE | C1DB=3, C1D8=1, C1D9=0 then MobileAPI $02 (SDK Init: DE=$C271 result buffer, HL=current ROM bank from FF8A/8B); polled by Mobile_ConnectPoll which then reads the login id and e-mail address; 21 scenarios |
| `54:405D` | `Mobile_ConnectPoll` | PROBABLE | Poll (1 busy, $FF error via 54:4011, 0 done) on C1D9: 1 = API $0E login id -> C1E0, 2 = API $10 e-mail -> C201 (+ $0C dial slots -> C480 if C1D8 bit1), 3 = connect: API $3E with 'guest' login if C1D2=0 else API $06 (dial no., id, password) |
| `54:413B` | `String_Mobile_GuestLogin` | CONFIRMED | ASCII "guest" NUL: copied twice after the 8-byte DNS prefix (67:5F54) as login id and password of the API $3E connect in Mobile_ConnectPoll (54:40E0-40F5); read as data in 1 scenario |
| `54:4141` | `Mobile_BeginConnect` | PROBABLE | C=dial slot selector (C1D2, 0 = guest login), HL=string copied to C220: if [C709]==1 goes straight to API $0C (dial slot -> C480, step 2) else starts SDK Init like 54:403D with C1D8=3; polled by Mobile_ConnectPoll; callers 4C:439E, 27:43AC |
| `54:418C` | `Mobile_BeginDisconnect` | PROBABLE | C1DB=3, C1D8=1, C1D9=0, MobileAPI $0A (SDK disconnect: close TCP, ISP logout, hang up); polled by Mobile_DisconnectPoll; 6 callers in 4C/27, 16 scenarios |
| `54:41A3` | `Mobile_DisconnectPoll` | PROBABLE | Poll: bit0 of [C69F] busy -> 1, bit1 error -> 54:4011 and $FF, else MobileAPI $36 (SDK reset), C1D8=0 and return 0; 6 callers |
| `54:41C5` | `Function_54_41C5` | HYPOTHESIS | unreferenced: C1DB=3, C1D8=1, C1D9=0, ret, followed by an unreferenced poll that also tests [C69F] bit2 and issues MobileAPI $28/$24/$0A/$36 through the far-call sites at 41FB-4230 (entry unproven) |
| `54:423C` | `Mobile_BeginCancel` | PROBABLE | C1DB=3, C1D8=1, C1D9=0; if the SDK is busy ([C69F] bit0) or [C709]>=2 issues MobileAPI $34 (cancel/abort), else clears [C69F]; polled by Mobile_CancelPoll; 9 callers, 15 scenarios |
| `54:4266` | `Mobile_CancelPoll` | PROBABLE | Same poll pattern as 54:41A3 (busy 1 / error $FF via 54:4011 / done: MobileAPI $36 reset, C1D8=0, return 0); 9 callers after Mobile_BeginCancel |
| `54:4288` | `Http_StartGet` | PROBABLE | HL=URL, DE=receive buffer, BC=size (kept in C1D6/C1D4/C1D2), C1DB=3: Url_EnsurePath, request block at C240 (0,0, URL ptr, login id C1E0, password C220), MobileAPI $2A (SDK HttpRequestA); callers 4C:44AD (page), 4C:4945 (images) |
| `54:42E4` | `Url_EnsurePath` | PROBABLE | HL=URL string: counts '/' characters; when fewer than 3 ("http://host") replaces the terminator by '/' and re-terminates; callers Http_StartGet/Http_StartPost |
| `54:42FB` | `Http_StartPost` | PROBABLE | Like Http_StartGet with C1D8=3, block at C244 (C240..C243 come from the caller: body pointer, length) and MobileAPI $2C (SDK HttpRequestB); only caller 4C:4457 (body $A000 in SRAM bank 3, length from 67:6205) |
| `54:4357` | `Http_Poll` | PROBABLE | Poll for Http_StartGet/Post: busy 1; more-data bit2 re-issues API $2A/$2C; error code $32 with H=3, L=1/2 (redirect?) retried up to C1DB=3 times via Url_ResolveLocation (POST becomes GET), else $FF; 0 = reply complete |
| `54:4417` | `Url_ResolveLocation` | PROBABLE | BC=new location string (SDK result pointer): if it starts with "http://" it replaces the URL at [C1D6]; if it starts with '/' the old scheme+host is kept; else the old URL up to its last '/' is kept; the new text is appended (CopyString) |
| `54:4483` | `Mobile_BeginStop` | PROBABLE | Unless [C709]==2 issues MobileAPI $3C (SDK 'Api3C', the same call Mobile_CheckTimeout uses to stop a timed-out request); called by 4C:417D and 4C:458B when a page load is abandoned; polled by Mobile_StopPoll |
| `54:4492` | `Mobile_StopPoll` | PROBABLE | Poll after Mobile_BeginStop: busy -> 1, error -> 54:4011 and $FF, else C1D8=0 and 0 |
| `54:44AC` | `Mobile_CheckTimeout` | CONFIRMED | Called first by every poll: timer-B minutes C268 == limit C26D -> MobileAPI $3C (C1DA=1), poll returns 1; later polls wait, then set C1DD=$26 (C1DE/F=0) and the poll returns $FF = the 5-minute timeout 26-000 of mail_timeout; 13 scenarios |
| `54:44FE` | `Smtp_StartHelo` | PROBABLE | Mobile_ResetCommandTimer, C1DB=3, C1D8=1, C1D9=0, MobileAPI $14 (SDK Smtp_Helo) with HL=$C201 (own e-mail address); caller bank 26 (mail send, first step before 54:4575); 5 scenarios |
| `54:451B` | `Smtp_HeloPoll` | PROBABLE | Mobile_CheckTimeout, then busy 1 / error $FF via 54:4011 / done 0 (C1D8=0); paired with Smtp_StartHelo (26:4138 loop) |
| `54:4538` | `Smtp_StartQuit` | PROBABLE | Mobile_ResetCommandTimer, C1DB=3, C1D8=1, C1D9=0, MobileAPI $1A = SDK MobileAPI_SmtpQuit (adapter.log: QUIT on tcp:587 after the message); runs after Smtp_DataPoll in the bank-26 send phase; polled by Smtp_QuitPoll; 4 scenarios |
| `54:4552` | `Smtp_QuitPoll` | PROBABLE | Poll for Smtp_StartQuit: Mobile_CheckTimeout, UI clock tick MailSession_UpdateTimerDisplay (26:58DC), then busy 1 / error $FF via 54:4011 / done 0 (C1D8=0); 3 scenarios |
| `54:4575` | `Smtp_StartMailFrom` | PROBABLE | Outgoing mail: header block at SRAM bank3 $A100 built by Mail_BuildHeaderField (fields 6,0,3,5,7,8,10 = MIME-Version, From, To, Subject, X-Game-title, X-Game-code, Content-Type), envelope at $A000 (own address + recipient), MobileAPI $16 |
| `54:46E8` | `Mail_BuildHeaderField` | PROBABLE | B=outgoing header index (table 0F:4033: 0 From, 3 To, 5 Subject, 6 MIME-Version, 7 X-Game-title, 8 X-Game-code, 10 Content-Type), DE=arg block C240: mail library selector 8 (00:0247) until it stops returning $FF; advances C241/2 and C243/4 |
| `54:4726` | `Function_54_4726` | PROBABLE | HL=string C=limit: counts characters up to NUL or the limit and stores the count in [C245]; callers 54:4575 |
| `54:4736` | `Function_54_4736` | PROBABLE | HL=src C=limit: copies to $C580 (at most C bytes, NUL-terminated) with B = number copied; callers 54:4575 |
| `54:4748` | `Function_54_4748` | PROBABLE | HL=src DE=dst: copies at most 16 bytes of a string, NUL-terminated; callers 54:4575 |
| `54:4770` | `String_Mail_CloseParen` | PROBABLE | ASCII ")" NUL appended after a sender's nickname in the outgoing header (54:45D2 and 54:4644 CopyString; the " (" is written just before) |
| `54:4772` | `Smtp_DataPoll` | PROBABLE | Poll that sends the message (MobileAPI $18, SDK Smtp_Data): step 1 header block at SRAM bank3 $A100 (length C241/2, d=0), step 2 body from SRAM bank0 $A040 (max $C0) via Charset_SjisToIso2022Jp (7E:7C34) + String_Smtp_EndOfData; 4 scenarios |
| `54:484A` | `Function_54_484A` | PROBABLE | HL=string C=limit: B = length up to NUL or C; caller Smtp_DataPoll |
| `54:4856` | `String_Smtp_EndOfData` | PROBABLE | CR LF "." CR LF NUL: SMTP end-of-data marker appended to the body by Smtp_DataPoll (CopyString at 54:4809 and 54:483F) |
| `54:485C` | `Pop3_StartLogin` | PROBABLE | Mobile_ResetCommandTimer, builds "account\0password\0" at C480 from C201 and C220 and starts MobileAPI $1E (SDK Pop3_UserPass); skips it (C1D9=2) while [C6C1] bit0 is set; callers 23, 26, 2E; 12 scenarios |
| `54:489B` | `Pop3_LoginStatPoll` | PROBABLE | Poll: Mobile_CheckTimeout, UI tick 26:58DC, then step 1 starts MobileAPI $20 (SDK Pop3_Stat, DE=$C240), step 2 returns HL=[C240] (message count) with A=0; error $FF via 54:4011 |
| `54:4914` | `Pop3_StartTop` | PROBABLE | HL=message number, C=mode: zeroes C480..C67F, SRAM bank 3 on, MobileAPI $28 (SDK Pop3_Top, DE=$A000, BC=$0FFF) = fetch the header of one message; polled by Pop3_TopPoll; callers 23, 26, 2E; 8 scenarios |
| `54:4969` | `Pop3_TopPoll` | PROBABLE | Poll for Pop3_StartTop; when done reads header fields with mail library selector 6 (0 From, 5 Subject, 6 Date, 10 X-Game-title, 11 X-Game-code, Charset_Iso2022JpToSjis) into a record at SRAM bank3 $B400..; B=2 if X-Game-code = CGB-BXTJ-00 |
| `54:49E0` | `String_Mail_DataCorrupt` | PROBABLE | Shift-JIS "メールのデータがこわれています。" ('the mail data is broken'), split in the code at 54:49E0 (first 16 bytes) and 54:49F0; shown for an unparsable message; the second sentence is String_Mail_PleaseDelete |
| `54:4A01` | `String_Mail_PleaseDelete` | CONFIRMED | Shift-JIS "けしてください。" ('please delete it.'), copied to $D41B by Pop3_TopPoll when a mail cannot be parsed |
| `54:4AD0` | `String_Mail_DefaultSource` | PROBABLE | Shift-JIS "メール" ('mail'): copied to $B430 (54:4AE9) as the source label when the X-Game-title header equals "MOBILE TRAINER" or is missing; other games put their own title there |
| `54:4AD7` | `String_Mail_GameTitle` | PROBABLE | ASCII "MOBILE TRAINER" NUL: prefix compared with the X-Game-title header (mail library selector 6, field $0A) of a received mail (54:4AB9 loop); equal -> String_Mail_DefaultSource |
| `54:4C2A` | `String_Mail_GameCodeCrystal` | PROBABLE | ASCII "CGB-BXTJ-00" (11 bytes, no NUL): compared byte for byte with the X-Game-code header at 54:4C1A; a match makes Pop3_TopPoll return B=2 |
| `54:4C47` | `Text_TruncateSjis` | PROBABLE | HL=string B=max bytes: walks the Shift-JIS text (lead bytes $81-$9F/$E0-$EF/$F8-$F9 take 2 bytes), and where it would exceed B cuts it and appends the ellipsis $81 $63 (Data_54_4CAD); callers 54:4A87, 4B6C |
| `54:4CAD` | `String_Text_Ellipsis` | CONFIRMED | Shift-JIS $81 $63 (full-width ellipsis) NUL: loaded with ld hl,$4CAD by Text_TruncateSjis and appended where a name/subject is cut |
| `54:4CB0` | `Pop3_StartRetr` | PROBABLE | HL=message number: SRAM bank 3 on, MobileAPI $24 (SDK Pop3_Retr, DE=$A000, BC=$0FFF) = fetch the whole message; polled by Pop3_RetrPoll; callers 26; 4 scenarios |
| `54:4CF4` | `Pop3_RetrPoll` | PROBABLE | Poll for Pop3_StartRetr; when done: mail library selectors 1,2,4,6, Charset_Iso2022JpToSjis (7E:7D62), fills the free mail slot (2D:46E9): date +3..+8, body +9, name +$C9, subject +$D9, address +$ED; issues API $26 (delete), returns 1 |
| `54:4FD2` | `Function_54_4FD2` | PROBABLE | Splits a From header at C580 into display name (DE) and address (HL) around '<' '>' or '(' ')', ASCII parts converted to full-width via Text_HalfToFullWidth, length-limited with 54:50FC; callers: Pop3_TopPoll (54:4A7F) and Pop3_RetrPoll |
| `54:50FC` | `Function_54_50FC` | PROBABLE | HL=src DE=dst B=limit: copies a NUL-terminated string, and when the source is longer than B replaces the tail by the ellipsis $81 $63 and sets C25D=2; 7 internal callers |
| `54:511B` | `Data_Text_Ellipsis2` | CONFIRMED | 2 bytes $81 $63 (Shift-JIS ellipsis) copied over the end of a clamped string by Function_54_50FC (ld hl,$511B ; ld bc,2 ; CopyBytes) |
| `54:511D` | `Function_54_511D` | PROBABLE | Mail library selectors 1 and 2 on the 3-byte argument (blob $4C44 = bank 3, $A000): E=0 when selector 1 fails, else stores B in C25F, runs selector 2 and returns E=1; used to validate/measure the mail in SRAM bank3 A000 |
| `54:5168` | `Mail_ParseDate` | PROBABLE | Parses the RFC-822 date at C480 (day, month name via String_Mail_Months, year, hh:mm, zone) into BCD C580..C585 (year hi/lo, month, day, hour, minute); with a +/-hhmm zone it goes to UTC then +9 h, with carries |
| `54:521F` | `Function_54_521F` | PROBABLE | HL=text: skips characters until an ASCII digit; used by Mail_ParseDate (6 callers) |
| `54:522A` | `Function_54_522A` | PROBABLE | HL=text: skips spaces ($20); used by Mail_ParseDate |
| `54:5231` | `Function_54_5231` | PROBABLE | HL=text: returns B = number of consecutive ASCII digits; used by Mail_ParseDate |
| `54:5240` | `Function_54_5240` | PROBABLE | HL=text after the time: reads '+'/'-' hhmm zone into C590..C592 and adds/subtracts it (BCD with daa) from the parsed hour/minute, carrying into day/month/year |
| `54:5343` | `String_Mail_Months` | CONFIRMED | "janfebmaraprmayjunjulaugsepoctnovdec" NUL: 12 lowercase 3-letter month names, compared (with \|$20) against the header text at 54:51A6 to get a month index |
| `54:5368` | `Table_Mail_MonthBcd` | CONFIRMED | 12 BCD month numbers 01..09,10,11,12 (byte-exact), indexed by the month index found in String_Mail_Months (54:51C2) |
| `54:5374` | `Table_Mail_DaysPerMonth` | PROBABLE | Days per month in BCD 31 28 31 30 31 30 31 31 30, six zero bytes, 31 30 31, indexed by the BCD month from $5373 so that months 10-12 hit the last three bytes (54:52B1) |
| `54:5386` | `Pop3_StartDele` | PROBABLE | A=0: clock drawn by MailServerMgr_UpdateTimerDisplay (2E:55FA), else MailSrvDel_DrawElapsedTime (23:6F00); HL=message number, Mobile_ResetCommandTimer, MobileAPI $26 (SDK Pop3_Dele); polled by Pop3_DelePoll; callers 23, 2E |
| `54:53BB` | `Pop3_DelePoll` | PROBABLE | A selects the clock redraw as in Pop3_StartDele (0: 2E:55FA, else 23:6F00); Mobile_CheckTimeout, then busy 1 / error $FF via 54:4011 / done 0 (C1D8=0) |

### Bank 55: on-screen keyboard

| addr | name | status | evidence |
|---|---|---|---|
| `55:4000` | `Table_Kbd_StartCell` | PROBABLE | Per keyboard type 0-9 (index wRam_C2AB) the initial cursor cell ($14,0,3,0,0,0,0,0,0,0), read by Kbd_Open (ld hl,$4000 ; add a,l) into wRam_C2B5; cell index = row*18 + column |
| `55:400A` | `Table_Kbd_OkCell` | PROBABLE | Per keyboard type 0-9 the cell of the OK key ($34,$46,$46,$58 x7); Start jumps the cursor there (55:5DCC, ld hl,$400A ; add a,l), also used by Kbd_Run (55:5CBC, 55:5CE0) to start on the OK cell |
| `55:4014` | `Table_Kbd_PagePointers` | PROBABLE | Words 0-9 (index = keyboard type C2AB) point to page-pointer arrays stored in the same table: $4028 (type 0), $402A.. one page for types 1-5, $4034 (type 6, 4 pages), $403C (types 7, 8: 4 pages), $4044 (type 9); read by Kbd_FetchCell |
| `55:4046` | `Data_Kbd_Page_Digits` | PROBABLE | Type 0 page: 3 rows x 18 cells of 2 bytes (kind,value): digits 1-5 / 6-9,0 and the special keys FF83 and FF82; ASCII cells are 00 xx; decoded by hand from the bytes |
| `55:40B2` | `Data_Kbd_Page_IdChars` | PROBABLE | Type 1 page: 12345 67890 / abcde fghij / klmno pqrst / uvwxy z.@-_+ plus FF83/FF82 (lower-case letters, digits and . @ - _ +); Kbd_RejectSymbol filters the five symbols for type 1 |
| `55:4142` | `Data_Kbd_Page_PhoneKeypad` | PROBABLE | Type 2 page: telephone keypad 1 2 3 / 4 5 6 / 7 8 9 / * 0 # plus FF83/FF82 |
| `55:41D2` | `Data_Kbd_Page_Ascii3` | PROBABLE | Type 3 page: ABCDE abcde Z01234 / FGHIJ fghij z56789 / KLMNO klmno [space key 01 20] / ... FF83/FF82 (upper case, lower case, digits, with a space key) |
| `55:4286` | `Data_Kbd_Page_Ascii4` | PROBABLE | Type 4 page: same letters and digits as type 3 without the space key |
| `55:433A` | `Data_Kbd_Page_Ascii5` | PROBABLE | Type 5 page: same letters and digits as type 4 (type 5 is the keyboard opened from bank 57) |
| `55:43EE` | `Data_Kbd_Page_T6_Hiragana` | PROBABLE | Type 6 page 0 (page array at $4034): hiragana grid あいうえお..ん゛゜ plus space [01 20], newline [01 0D] and FF83/FF82; cells are (SJIS lead,trail) pairs, 5 rows x 18 |
| `55:44A2` | `Data_Kbd_Page_T6_Katakana` | PROBABLE | Type 6 page 1: katakana grid アイウエオ.. with the same layout as the hiragana page |
| `55:4556` | `Data_Kbd_Page_T6_FullWidthAlnum` | PROBABLE | Type 6 page 2: full-width Latin letters (upper and lower case), digits and .,!?:/@-_+ |
| `55:460A` | `Data_Kbd_Page_T6_Symbols` | PROBABLE | Type 6 page 3: full-width symbols (+-=#$ %&!? ... brackets, arrows, stars, squares) |
| `55:46BE` | `Data_Kbd_Page_T78_Hiragana` | PROBABLE | Types 7 and 8 page 0 (page array at $403C): same hiragana content as type 6 page 0 with a different neighbour table (Data_55_576A) |
| `55:4772` | `Data_Kbd_Page_T78_Katakana` | PROBABLE | Types 7/8 page 1: katakana |
| `55:4826` | `Data_Kbd_Page_T78_FullWidthAlnum` | PROBABLE | Types 7/8 page 2: full-width alphanumerics |
| `55:48DA` | `Data_Kbd_Page_T78_Symbols` | PROBABLE | Types 7/8 page 3: full-width symbols |
| `55:498E` | `Data_Kbd_Page_T9_Ascii` | PROBABLE | Type 9 page (single): ASCII cells 00 xx: A-Z a-z 0-9 and . @ - _ + plus FF83/FF82; used by the mail address keyboards (banks 2D/2F) |
| `55:4A42` | `Table_Kbd_NeighbourRecords` | PROBABLE | 10 word pointers (index = keyboard type) to blocks of 6-byte cell records: bytes 0-3 = neighbour cell for Left/Right/Up/Down, 4-5 = wrap flags (e.g. cell 0 of type 7: 11 01 48 12); read by Kbd_MoveCursor; types 7 and 8 share one block |
| `55:5BA2` | `Kbd_Open` | CONFIRMED | A=keyboard type (C2AB, 0-10), B=mode (C2AF: 0 = Kbd_Run slides the panel in, 2 = shown here at once), C!=0 loads the remembered input mode (Kbd_LoadInputMode): page 0, start cell, tiles, palettes, panel map, cursor; 19 callers, 23 scenarios |
| `55:5C8F` | `Kbd_Run` | CONFIRMED | Input loop (C -> C2B4, B -> C2B3 for type 5): D-pad moves, A picks the cell (C2AE/C2AD), B, Select = next page, Start = OK cell; returns A: 1 char, 2 B, 3 newline key, 7/8 keys $82/$83, $0A Select (type 5); type 10: 4/5/6 or 9; 23 scenarios |
| `55:5D49` | `Kbd_Run_Loop` | PROBABLE | Frame of the input loop: Kbd_DrawGlyphPreview, sprite engine, VBlank wait (00:044B or 00:0464 by Kbd_TypeWaitsWithService), joypad decode (hJoyPressedRepeat bit0 A, bit1 B, bit2 Select, bit3 Start, bit4 right, bit5 left, bit6 up, bit7 down) |
| `55:5E5D` | `Kbd_Run_ButtonA` | PROBABLE | A pressed: kind byte C2AE: 0 ASCII, 1 control ($0D newline, $20 space), $FF special key ($80 space, $81 newline, $82 = OK icon, $83 = back-arrow icon, as rendered from bank 66), else a Shift-JIS lead byte; sets the return code |
| `55:5F35` | `Kbd_FetchCell` | PROBABLE | Follows Table_Kbd_PagePointers[C2AB] -> page[C2AC] -> cell C2B5 (2 bytes each) and stores the pair in C2AE (first byte) and C2AD (second byte), then requests a glyph redraw; 6 internal callers |
| `55:5F66` | `Kbd_MoveCursor` | PROBABLE | A=direction 0 left, 1 right, 2 up, 3 down: sound $29 (00:20AC), reads the 6-byte record of Table_Kbd_NeighbourRecords for the cell (neighbour to C2B6, flag bytes to C2B7/C2B8), dispatches via Table_55_5FC8 and sets the new cell C2B5 |
| `55:6068` | `Function_55_6068` | PROBABLE | Second half of a cursor move: C2BD/C2BE := $FF, then per direction (Table_55_6087, or Table_55_60F1 on special-key cells) and the record flag byte C2B8 stores the current column/row into C2BD/C2BE (remembered position for wide keys) |
| `55:6149` | `Kbd_SplitCursorIndex` | PROBABLE | Splits the cursor cell C2B5 by repeated subtraction of 18 (the panel is 18 columns wide): C2BA = column, C2BB = row; callers Kbd_UpdateCursorSprite and the move handlers |
| `55:615F` | `Kbd_IndexToColRow` | PROBABLE | A=cell index: returns B=column (A mod 18), C=row (A div 18) |
| `55:616D` | `Kbd_ColRowToIndex` | PROBABLE | B=column, C=row: returns A = row*18 + column (00:0BE8 Multiply16) |
| `55:6190` | `Kbd_UpdateCursorSprite` | PROBABLE | Cursor pixel position x = col*8 + bx, y = row*16 + by (bases = word at $62A0 + 2*type) into C284/C285; selects the cursor anim (slot DAB0, 5F:4CF8: $81, or $82 on special keys with offsets from $62B4) and the DAA0 marker on cells FF82/FF83 |
| `55:6318` | `Kbd_SlideIn` | PROBABLE | Sound $34 (00:20AC), window on (LCDC bit5), WY lowered by 8 per frame from $90 to the type's target (Kbd_GetSlideTargetY) while per-type bank-7F routines animate the panel; then Kbd_ShowPageIndicator; caller Kbd_Run (C2AF=0) |
| `55:63E7` | `Kbd_ShowInstant` | PROBABLE | Waits one frame, sets WY to the target of Kbd_GetSlideTargetY and enables the window, then Kbd_ShowPageIndicator: shows the keyboard without the slide; called by Kbd_Open when C2AF==2 |
| `55:640E` | `Kbd_GetSlideTargetY` | PROBABLE | Returns A = [$641C + C2AB]: window Y after sliding in ($28 for types 0-5, $38 for types 6-10) |
| `55:6427` | `Kbd_SlideOut` | PROBABLE | Clears sprite slots DAA0..DAD0, sprite pass and VBlank wait, then raises WY by 8 per frame up to $90 (sound $35, per-type bank-7F step) and disables the window; 6 internal callers |
| `55:651C` | `Kbd_HideInstant` | PROBABLE | Clears sprite slots DAA0..DAD0, runs the sprite pass, waits for VBlank and clears LCDC bit5 (window off): hides the keyboard at once; 16 callers in banks 2A/57/67/68 |
| `55:6559` | `Kbd_Hide` | PROBABLE | Kbd_SlideOut then C2AF=0 (keyboard closed); callers 2A, 2C, 2D, 2F, 57 after input ends |
| `55:65DA` | `Kbd_TypePickerLoop` | PROBABLE | Keyboard type 10 (picker): Left/Right change the choice C2BC 0-2 (sound $29), A returns 1, B returns 0; Kbd_Run's type-10 path (55:6563) then returns Data_55_65D7[C2BC] = 4/5/6 or 9 for B; 7 scenarios |
| `55:667B` | `Kbd_UpdatePickerSprites` | PROBABLE | Positions the picker cursor sprite (x from Data_55_66C0[C2BC]) and the tab sprite (from Data_55_66C3), then Kbd_LoadPickerTabTiles; used by Kbd_TypePickerLoop |
| `55:66C6` | `Kbd_LoadPageGraphics` | PROBABLE | A=1 also rebuilds the panel map (FFB0): jumps through Table_55_66D9 by keyboard type and page C2AC to HDMA the tile pages ($8801/$8C01/$9001 from banks 5D/5E/5F/62/66) and the panel map, then Kbd_UploadPanelMap13Rows/11Rows; 23 scenarios |
| `55:6AF0` | `Kbd_UploadPanelMap11Rows` | PROBABLE | Uploads the panel map ($D240 tile ids, $D640 attributes, 11 rows of 32 = $16 blocks) to the window tile map ($9C00 or $9800 by LCDC bit6) through HDMA (00:0787 or 00:0749); used by the 11-row keyboards |
| `55:6B51` | `Kbd_UploadPanelMap13Rows` | PROBABLE | Same as 55:6AF0 for 13 rows ($1A blocks, panel maps loaded with bc=$0D14); 6 internal callers |
| `55:6BB2` | `Kbd_ShowPageIndicator` | PROBABLE | If Kbd_TypeHasPages: sprite slot DAC0 from anim 5F:4D04 (variant C2AC+1) at (Y=$88, X=8) = the page number marker; 3 internal callers |
| `55:6BD7` | `Kbd_LoadPickerTabTiles` | PROBABLE | Loads the tile block Data_55_6C0A[C2BC] ($6A90/$6D10/$6F90 in bank 66) to VRAM $8801 ($28 blocks) for the type-10 picker |
| `55:6C10` | `Kbd_RequestGlyphRedraw` | PROBABLE | Sets wRam_C2B2 = 1 (the highlighted character changed and its preview glyph must be redrawn); 2 internal callers |
| `55:6C16` | `Kbd_DrawGlyphPreview` | PROBABLE | If C2B2: turns the current cell (C2AE/C2AD) into a Shift-JIS pair (ASCII via Text_HalfToFullWidth; $0D/$20 -> $83C0/$83BF), fetches its glyph with 48:4748 and uploads it to VRAM $8241, positions sprite slot 11 from C284/C285; clears C2B2 |
| `55:6CC6` | `Text_HalfToFullWidth` | CONFIRMED | A=byte $20-$FF: returns BC = Shift-JIS pair from Table_Text_HalfToFullWidth[(A-$20)*2] (ASCII to full-width, half-width katakana to full-width katakana); callers 55:6C28, 54:50E5 (mail names), bank 57; 21 scenarios |
| `55:6CD4` | `Table_Text_HalfToFullWidth` | CONFIRMED | 224 Shift-JIS pairs for the bytes $20..$FF: $20 -> 8140, $21 -> 8149 ... $41-$5A -> Ａ-Ｚ, $61-$7A -> ａ-ｚ, $A1-$DF -> 。「」、・ヲァ.. half-width katakana to full-width, blanks elsewhere; verified by decoding all pairs with cp932 |
| `55:6E94` | `Kbd_TypeHasPages` | PROBABLE | A=keyboard type: returns the byte of Data_55_6E9F (1 for types 6,7,8): gates the Select page switch (handler 55:5E02) and Kbd_ShowPageIndicator; = the types that own 4 pages in Table_Kbd_PagePointers |
| `55:6EAA` | `Function_55_6EAA` | PROBABLE | A=keyboard type: returns Data_55_6EB5[A] (1 for types 6-10); when C2AF==2 Kbd_Run first places the cursor on the OK cell (Table_Kbd_OkCell) for those types (55:5CBC) |
| `55:6EC0` | `Function_55_6EC0` | PROBABLE | A=keyboard type: returns Data_55_6ECB[A] (1 for types 0-5); with C2B4!=0 Kbd_Run places the cursor on the OK cell (Table_Kbd_OkCell) first (55:5CE0) |
| `55:6ED6` | `Function_55_6ED6` | PROBABLE | A=keyboard type: returns Data_55_6EE1[A] (1 for types 5-10); when set Kbd_Open loads the extra palette 5F:4CD0 into $D830 and uploads it |
| `55:6EEC` | `Function_55_6EEC` | HYPOTHESIS | byte-exact sibling of the lookup routines (table Data_55_6EF7: 0 x6, 1 x5); only caller is the unreferenced 55:5DF5; not executed |
| `55:6F02` | `Function_55_6F02` | PROBABLE | A=keyboard type: returns Data_55_6F0D[A] (1 for types 5,6,8,9); when set special key $82 closes the keyboard and Kbd_Run returns 7 |
| `55:6F18` | `Function_55_6F18` | PROBABLE | A=keyboard type: returns Data_55_6F23[A] (1 for types 5-9); when set special key $83 closes the keyboard and Kbd_Run returns 8 |
| `55:6F2E` | `Kbd_TypeWaitsWithService` | PROBABLE | A=keyboard type: returns Data_55_6F3B[A] (1 for types 0-5); all 14 callers choose 00:044B (VBlank wait + frame service) when it is non-zero, else 00:0464 (VBlank only) |
| `55:6FA1` | `Kbd_RejectSymbol` | PROBABLE | Looks up C2AD in the list $6FC7 "@.-_+": on a hit plays sound $31 and returns 1 (Kbd_Run then ignores the key); called only for keyboard type 1 (55:5F09) |
| `55:6FCD` | `Kbd_ShowMarkerSprite` | PROBABLE | Starts sprite slot DAD0 (anim 5F:4D38) at Data_55_6FF4[type]; banks 67/68 call it while the entered text is shorter than a threshold (TextBuf_GetLength < 1 or < 9), Kbd_Run for type 5; what the marker means is unproven |
| `55:7000` | `Kbd_HideMarkerSprite` | PROBABLE | Clears sprite slot DAD0 (00:09E6), counterpart of Kbd_ShowMarkerSprite: banks 67/68 call it once the entered text reaches the threshold length (>= 1 or >= 9 characters), Kbd_Run for type 5 |
| `55:7007` | `Kbd_LoadInputMode` | PROBABLE | A=0: C2BC=0, else C2BC = SRAM bank1 $BF05 (SRAM enable/bank saved and restored around the read); read from Kbd_Open with C |
| `55:7048` | `Kbd_SaveInputMode` | PROBABLE | Stores C2BC into SRAM bank1 $BF05 (saving and restoring SRAM enable/bank); called after the type-10 picker closes |


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

## 13. How this was checked

```
python3 tools/gen_asm.py verify --config <copy of config/ with the 7 symbol files>     # IDENTICAL
python3 tools/gen_asm.py check --strict --config <same>                                 # OK
# scenario evidence: union over traces/coverage_<scenario>.tsv (bank, addr) -> scenarios that executed the instruction
# rendered screens: baserom.gbc bank 50 tile sets 5A20/62F0 + maps 439A.. (8), bank 51 packs 42A0/4AA0 and 4DB0/55B0 (2)
# keyboard pages and Table_Text_HalfToFullWidth decoded with cp932 from the ROM bytes
```

## 14. Adversarial verifier pass (corrections and retractions)

Method: for the 25 most-called or CONFIRMED names plus about 15 others the function code was re-read from the ROM and every cited caller, callee, string, table and RAM fact was
re-derived (call-site counts from the generated sources, scenario counts from `analysis/coverage_union.tsv`, tables decoded with cp932, the 8 notice screens and the 2 summary screens re-rendered,
the type-6 keyboard panel rendered, API numbers compared with the bank-75 `MobileAPI_*` names, header indexes compared with the bank-0F mail tables).  Confirmed unchanged: all 173 `Palette_LoadToBuffer` sites use
DE in `$D800-$D87F`; 32 / 82 / 218 call sites of upload / fade-in / fade-out; 42 / 37 / 59 callers of the canvas and map helpers; the 8 + 2 rendered screens read as documented; `Table_Text_HalfToFullWidth`
(224 pairs, no undecodable pair); the keyboard page pointers, OK-cell, start-cell and per-type property tables; the mail header indexes (0 From, 3 To, 5 Subject, 6 MIME-Version, 7 X-Game-title, 8 X-Game-code, 10 Content-Type);
the 29 inlined connection-time checks in 11 banks; `SaveCheck_*`; history and page-cache index arithmetic; the record `+3..+8` date layout.

Corrections made:

* `Comm_WaitFrames` (4C:5111) is now `Sprite_WaitFrames`: its only caller is the exit path of the offline dictionary viewer, the body is a sprite pass plus VBlank wait, nothing communicates.
* `Function_54_4538` / `Function_54_4552` are now `Smtp_StartQuit` / `Smtp_QuitPoll`: API `$1A` is `MobileAPI_SmtpQuit` in the bank-75 naming (CONFIRMED there, QUIT on tcp:587 after the message in the adapter log); the earlier "TcpApi1A, role unknown" is withdrawn.
* Retracted: "A selects the message source" in `Pop3_StartDele` / `Pop3_DelePoll`; A selects which clock-redraw routine runs (`MailServerMgr_UpdateTimerDisplay` 2E:55FA or `MailSrvDel_DrawElapsedTime` 23:6F00); HL is the message number.
* `Kbd_ShowConfirmMarker` / `Kbd_HideConfirmMarker` are now `Kbd_ShowMarkerSprite` / `Kbd_HideMarkerSprite`.  Retracted: "shown when the entered text is acceptable".  Banks 67/68 show sprite slot DAD0 while `TextBuf_GetLength` is below a threshold (1 or 9) and hide it once the text is long enough, i.e. the opposite; what the sprite means is not proven.
* `Browser_LoadScrollArrowGfx` is now `Browser_LoadScrollbarGfx`: the routine starts the thumb sprite (slot DA90, moved by `Browser_UpdateScrollThumb`); the arrows are slots DAA0/DAB0 from the 72:7828 table, so "arrow" was not supported.
* `Browser_LoadPage_Fail` was executed in 6 scenarios, not 1.  `Http_Poll` also re-issues the request when SDK bit 2 (more data) is set (was undocumented).  `Mail_ParseDate` shifts a zoned time to UTC+9 (JST) with day/month/year carries (was undocumented).
* Menu numbering: the three link-state exits are results 4/5/6 of the bank-72 menu but 3/4/5 of `Dialog_ShowMonitored` (`Table_4E_4A37` and siblings); rows `Browser_Menu_LinkLost`, `Browser_ConnectionNotice`, `Browser_Menu_AdapterError` now say both.
* `Data_Browser_FrameDesc3` is byte-identical (31 bytes) to style 2, not only in the pointers.  "Dead in this ROM" for the frame-style chooser is softened to "no caller found".  "Settles the open question" (record date layout) is softened to "answers".
* RAM proposals: `wBrowserUiActive` is now `wBrowserScrollbarEnable` (its only reader is the scrollbar code); `wBrowserTimerBlink` is now `wBrowserTimerSecToggle` (both branches after the toggle draw identical sprites);
  `hImageWidth` / `hImageHeight` (FFD6/FFD7) are retracted (bank 74 list and layout code use them as small scratch counters); notes added that `wCommSessionActive` (C2D1) has no reader in the disassembly and that `wBrowserNavigating` (C334) is reused as scratch by `Bmp_ConvertToTiles`.

No status was upgraded.  The row counts are unchanged (47 CONFIRMED, 240 PROBABLE, 16 HYPOTHESIS; 303 rows); the RAM file has 40 rows.
