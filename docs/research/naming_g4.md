# reference g4: banks 2D, 2E, 2F, 48

## 1. Map of the four banks

| bank | what it is | entry points (far-called from) | main data |
|---|---|---|---|
| 48 | System library: scrolling-text ticker, 8x16 SJIS font blitter, text-to-tile renderers, SRAM checksum 3 and first-use tutorial gates, `WriteByteFar`, masked palette fades | `Ticker_*` (1D/1F/6C/73 menus), `TextTiles_RenderLine` (84 callers: dialogs 72:402A, help texts), `WriteByteFar` (27 callers), `Sram_*Checksum3` (bank 65 boot check), `Tutorial_Gate*` (7C, 4F) | `Font_GlyphRunTable` + 27 `Font_48_*` runs (303 glyphs, 1bpp 8x16) |
| 2D | Mail composition: address screen, body editor, draft/record storage, sample data installers | `MailCompose_Run` (7C:7C9C), `MailBody_Edit` (25:5540, 2B:4778, 2B:6D86), `MailAddr_Edit` (2B:475F), `MailDraft_*` (22/25/26/2B), `MailRecord_Delete` (25:42D6, 2B:6526), `MailRecord_GetFreeSlotPtr` (54:4DAF...), `TextTiles_ClearBuffers`/`Joypad_ClearAndResetRepeat`/`TextTiles_UploadBuffers` (many banks) | tiles/tilemaps/palettes of the two screens, 5 sample mails, 6 sample address-book slots |
| 2E | Mail-server tidy-up screen (メールサーバ: fetch each server mail, show date/fields, delete / load next / stop) | `MailServerMgr_Run` (22:4E79, 23:4C1D) | 6 tile blocks, 5 tilemaps, 2 palettes, 5 object tables, 6 message/help strings |
| 2F | Address book (アドレスちょう): list, view, new/edit (address entry then nickname entry), delete | `Abook_Run` (7C:7CD9) | 8 identical slot address tables, help strings, tilemaps |

### 1.2 Bank 2D (mail composition)

* **Body editor**: 8 rows x 12 double-byte cells in WRAM bank 1 `D400-D4BF` ($0D $0A = newline, NUL ends), cursor
  B=row C=col, goal column `C0D2`, scroll `C0D3` (applied by the STAT split IRQ 00:0E93, see `ram_g4.tsv`).  Cursor keys
  `MailBody_CursorLeft/Right/Up/Down` (hJoyPressedRepeat bits 5/4/6/7), `MailBody_GetRowPtr/GetCharPtr`,
  `MailBody_InsertChar/InsertNewline/Backspace`, dakuten/handakuten (`ApplyDakuten` scans the 40-kana list, +1 on the trail
  byte; `ApplyHandakuten` +2; `ApplyDakutenU` turns ウ into ヴ), `MailBody_DrawRow` (+ `_Glyph`/`_Pad`), row redraw helpers.
  `MailBody_KeyboardLoop` drives the on-screen keyboard widget of bank 55 (`55:5BA2` open, `55:5C8F` poll).  Its save path
  (icon menu, dialog $0202) pops its own return address so that the final `ret` leaves `MailBody_Edit` directly with A=1.
* **Address screen** `MailAddr_Edit`: 64 single-byte ASCII characters in `D4C0-D4FF` shown as 3 lines (20/24/20 columns),
  SELECT = address book (`67CB` far-calls `2C:56FE`, matching the footer text セレクト アドレスちょう), keyboard OK returns 0
  (dialog $0205 if empty).  `MailCompose_ConfirmDiscard` asks $0200 only if some staging buffer is non-empty.
* **Storage**: the draft lives in SRAM bank 0 `A000-A123` (address `A000`, body `A040`, title `A100`, name `A114`);
  `MailDraft_SaveToSram/LoadFromSram/Clear` copy to/from `D4C0/D400/D500/D514`.  Received mails are 12 records of $12D bytes
  at `A124+i*$12D` (`MailRecord_AddrTable`): `+0` in-use, `+1..+2` unknown, `+3..+8` BCD `yyyy mm dd hh mm`, `+9` body $C0,
  `+$C9` sender name $10, `+$D9` subject $14, `+$ED` address $40.  The BCD reading of the header is confirmed by the five
  sample records (2000-06-28 12:30 ... 2000-07-12 19:28, consistent with the July text in sample 3) and by bank 2E, which
  prints the same 6 bytes as `2001年01月27日10時00分`.  `MailRecord_GetFreeSlotPtr` (used by the receiver in bank 54) and
  `MailRecord_Delete` (run in `mail_inbox`, frame 10714 right after the delete confirmation) work on this array.
* **Sample data** (never executed, entry not located): `MailRecord_InstallSampleMails` (5 mails: Mario, King Koopa, a mail
  magazine, a GB centre notice, an untitled one), `Abook_InstallSampleEntries` (6 address-book slots, Missing Link staff
  names/addresses; slots 1 and 4 empty, slot 5 only an address), `SampleData_InstallNameAddressPair`
  (`スーパーマリオ` / `ninten88@gbaa.dion.ne.jp` to `AF40/AF50`, but it selects SRAM bank 1 while `2A:6257` reads them from
  bank 0), `Sram_ClearBank0Page0`, `Sram_ClearAllBanks`.  Their strings are labelled `MailSample*`, `AbookSample*`,
  `SampleData_*`.
* **Shared helpers living here**: `TextTiles_ClearBuffers` (4E06, 26 callers), `TextTiles_UploadBuffers` (5016),
  `TextTiles_UploadBuffersShort` (6C64), `Joypad_ClearAndResetRepeat` (70F4).

### 1.3 Bank 2E (mail-server tidy-up)

`MailServerMgr_Run` (2E:4000; `mail_server`, `mail_server_full`, `mail_server_hidden`, monkeys): sets up the screen
(`MailServerMgr_SetupScreen`), shows "メールをよみこんでいます" (`ShowLoadingMsg`), polls the POP3 layer (`54:485C/489B`,
`23:6699/58C4/5FA2` far calls), then for each mail draws the number (`DrawMailNumber`, "N通目"), the BCD date
(`DrawMailDate`) and the three header fields (`DrawMailFields`), and offers 3 choices with help lines from
`Table_MailServerMgr_HelpStrings` (delete this mail / load the next mail / stop tidying the server).  The elapsed
communication time MM:SS is redrawn each frame (`UpdateTimerDisplay`/`DrawTimer`, from C2D5/C2D6).  Dialogs used: $0228
(no mail on the server, hang up), $0229 (check finished, hang up), $022A (stop deleting server mail?).  The twin
routines `2E:48F8`/`2E:4A7D` (popup + rebuild, entered when the C26E/C26F warning threshold fires) were never executed.

### 1.4 Bank 2F (address book)

`Abook_Run` (7EBF) loops over `AbookList_Run` (4000, the list of 6 slots with 4 buttons: new / view / edit / delete, help
texts in `Table_Abook_HelpStrings`).  New and edit run `AbookAddr_Edit` (6D00, 64-byte address `D4C0`, lines 16/24/24)
then `AbookName_Edit` (57F2, 8-char nickname `D514`) then `2A:6F95` (confirm and save, dialog $020B); view runs
`AbookView_Run` (5098); delete asks $020D inside the list and calls `Abook_ClearSlot`.  Slot layout in SRAM bank 1:
`A69D+i*$50`: name $10 at +0, address $40 at +$10 (eight identical address tables `Abook_SlotAddrTable0..7` exist, one
per reader).  State between screens: `D726` slot, `D727` return flag, `D728` button.  The address and name editors are
compiled copies of the mail editors of bank 2D (same cursor/insert/backspace/dakuten/keyboard code with different buffers).

## 2. Cross-bank conventions found while reading

* Joypad (`hJoyPressed`, `hJoyPressedRepeat`): low nibble A=1, B=2, SELECT=4, START=8; high nibble Right=$10, Left=$20,   Up=$40, Down=$80.

* Bank-04 service calls `00:20AC` with BC=id are used as UI feedback (only the call pattern is proven, not that they are   sound effects): `$36` text-cursor move, `$29` list cursor, `$2C` accept, `$2E` cancel (B), `$31` refuse/error, `$38`   character typed, `$39` backspace, `$3B` newline, `$32` mail saved, `$33` address deleted.

* Keyboard widget (bank 55): `55:5BA2(A=layout, B, C)` opens it (A=6 body, 8 name, 9 address), `55:5C8F` polls it: 0 nothing,   2 backspace (B), 3 newline, 7 OK, 8 close, 9 return; otherwise a key was chosen and its SJIS code is in `C2AD/C2AE`   (codes inferred from what the callers do with them; the widget itself is not in these banks).

* WRAM bank 1 `D400-D52F` is a shared staging area: mail body/address/title/name in 2D/2F, mail-header fields and date tiles   in 2E (`D400` date BCD, `D406`, `D41B`, `D4C0`, `D524` digits).

These overlays are why `ram_g4.tsv` states the bank in every row.

## 3. Dialog messages referenced (bank 72 table, `72:4015(D=2,E=id)`, decoded)

| id | text | used by |
|---|---|---|
| $0200 | かきかけのメールはきえてしまいます。よろしいですか？ (unfinished mail will disappear) | compose leave, D524=1 |
| $0202 | かいたメールをセーブします。よろしいですか？ | body save |
| $0205 | メールアドレスはかならずかいてください。 | address empty |
| $0206 | もらったメールをけします。よろしいですか？ | (delete received mail, other bank) |
| $020B | メールアドレスをセーブします。よろしいですか？ | address-book save (dead path 2F:50D3, 2A:6F95) |
| $020D | メールアドレスをけします。よろしいですか？ | address-book delete |
| $020F | かきかけのへんじはきえてしまいます。 | reply leave (D524=3) |
| $0211 | メールのしゅうせいをやめます。 | revise leave (D524=2) |
| $0217 | かきかけのデータはきえてしまいます。 | address entry leave (new) |
| $0218 | アドレスのしゅうせいをやめます。 | address entry leave (edit) |
| $0228 / $0229 / $022A | サーバにメールはありません／チェックをしゅうりょうしました／サーバメールのさくじょをやめます | 2E |

## 4. Named functions by subsystem

* Ticker/UI library (48): `Ticker_Start/Update/Stop/InstallRasterIrq`, `TextTiles_RenderLine/RenderGrid/RenderGridRows`,
  `Font_BlitGlyph8x16`, `Font_GlyphRunTable`, `Palette_FadeInMasked/FadeOutMasked/SetFadeTargetMasked/FadeOutWithTicker`,
  `Tilemap_FillRectSequential`, `Bcd_FromBinary8`, `Divide8`.
* Save data (48): `WriteByteFar`, `Sram_ComputeChecksum3/UpdateChecksum3/VerifyChecksum3/ResetChecksum3Areas`,
  `Sram_ClearMenuCursorMemory`, `Tutorial_GateTopMenu/GateMailMenu/GateHomepage`.
* Layout constants (2D, `const` rows): `MAILREC_COUNT/SIZE/OFS_TIME/OFS_BODY/OFS_NAME/OFS_SUBJECT/OFS_ADDRESS`, `MAIL_BODY_SIZE/ADDRESS_SIZE/SUBJECT_SIZE/NAME_SIZE`, `ABOOK_SLOT_COUNT/SIZE/OFS_ADDRESS`, `TICKER_PAUSE_FRAMES` (documentation only: the generator never substitutes consts into operands).
* Mail (2D): `MailCompose_Run`, `MailAddr_*` (address screen, 22 rows), `MailBody_*` (editor, 30 rows), `MailDraft_*`,
  `MailRecord_*`, `MailStaging_Clear`, sample data (`MailSample0..4_*`, `AbookSample*`, `SampleData_*`), graphics
  (`Gfx_MailBody_*`, `Gfx_MailAddr_*`, `Tilemap_*`, `Palette_*`), shared `TextTiles_*` and `Joypad_ClearAndResetRepeat`.
* Mail server (2E): `MailServerMgr_*` (run, screens, drawers, messages, timer) and its strings/tables/graphics.
* Address book (2F): `Abook_Run`, `AbookList_*`, `AbookView_*`, `AbookName_*`, `AbookAddr_*`, `Abook_*` slot helpers,
  `Abook_SlotAddrTable0..7`, strings and tilemaps.

## 5. Hypotheses and open questions

* `2D:4635` writes the sample name/address to SRAM bank 1 `AF40/AF50` while `2A:6257` reads bank 0: dead code or wrong   bank; the sram_layout.md note that these belong to bank 0 is unchanged.

* Names of neighbouring routines that were only identified by behaviour: `2C:4000` (title entry), `2C:56FE` (address-book   picker), `2A:6F95` (address save confirm), `28:4000` (mail preview?), `55:5BA2/5C8F` (keyboard widget), `7F:624F/6218/627C`   (popup), `25:4A90` (first free mail record, returns D).

* Not analysed: the internals of `MailServerMgr_Run` after the first fetch (D625-D638 usage, `54:4914/4969`, `23:6699`),   the object animation frame tables (`Table_2E_76C0` targets, `Data_2F_5050`), tile contents (only their loaders were traced).

* The 12 words at `2D:417D/470A` and the 9-byte defaults at `2D:42B2...` are **mail records** and their sample data, not
  "profile records" (region notes in `config/regions/bank2D.tsv` still say profile-defaults); the 6-slot tables in 2F
  are the address book (sram_layout.md already says so).
* `sram_layout.md`: record `+3..+8` is a BCD timestamp (year 4 digits, month, day, hour, minute), not "BCD year/unknown".

## 7. Counts

| bank | rows | CONFIRMED | PROBABLE | HYPOTHESIS |
|---|---|---|---|---|
| 2D | 142 (incl. 15 `const` layout equates) | 85 | 54 | 3 |
| 2E | 45 | 27 | 13 | 5 |
| 2F | 101 | 73 | 27 | 1 |
| 48 | 28 | 16 | 9 | 3 |

* `SampleData_CopyString`: all 20 callers are in `MailRecord_InstallSampleMails`; `Abook_InstallSampleEntries` inlines its   copy loops (the row said both installers).

`MailAddr_OpenAddressBook`: target 2C:56FE is `AddrPick_Menu` (bank 2C row).

`MailRecord_GetFreeSlotPtr`: 25:4A90 returns a count of consecutive used records (12 = full), the caller must check it.

`MailServerMgr_Run` is the per-mail *check-and-delete* UI reached from `MailSrvDel_CheckAndDelete` (23:4B51) and the hidden   variant (22:4E79), not the delete-all path (bank 23 `MailSrvDel_DeleteAll*`); the `MailServerMgr_` prefix covers only that UI.

* Not changed but worth knowing: `TextTiles_ClearBuffers` also clears WRAM bank 3 `D000-D77F` (purpose unproven); 2D:4F03 and   2F:4496 were executed in scenarios (their HYPOTHESIS status is about purpose, not reachability); ram_g2 and ram_g7 use different   names for C26E/C26F (`wConnWarn*` vs `wOnlineWarn*`), not a g4 matter.
