# reference g1: banks 04, 0E, 19, 1A, 1B, 1C, 1D, 1F, 22, 23

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

## 6. Mail-server delete menus and the SRAM library (banks 23, 22)

| button | 23 (normal) | 22 (hidden variant) | what it does |
|---|---|---|---|
| check then delete (C=1) | `MailSrvDel_CheckAndDelete` 23:4B51 | `MailSrvDelHidden_CheckAndDelete` 22:4DAD | cost dialog `57:4000` `ConnectDialog_Run` ('つうしんせつぞくします ... よろしいですか？'), timer reset `51:4245`, `MailConnect_Screen` (27:41E3), then `2E:4000` (per-mail check/delete UI), `MailServerStatus_Screen` (29:44F6, C264=2) |
| delete all (C=0) | `MailSrvDel_DeleteAll` 23:4A06 | `MailSrvDelHidden_DeleteAll` 22:4B17 | confirmation dialog (`MailSrvDel_Confirm`, default 'いいえ'), cost dialog, connect, `MailSrvDel_DeleteAllRun` (23:4C94): login, pass 1 counts 'problem' mails with a TOP request each, pass 2 re-checks each mail and skips the problem ones, DELE for the rest, C264=1 result screen |
| delete completely (C=2) | - | `MailSrvDelHidden_DeleteCompletely` 22:4C62 | same, but `MailSrvDel_DeleteCompletelyRun` (23:51C7) sends DELE for every mail without any TOP check (executed in `mail_server_hidden`) |

| routine | function |
|---|---|
| `SramCheck_Bank0PageSum` 4EF0 | sum of the first $FFE bytes of SRAM bank 0 page A0/B0, DE = sum, HL = stored word at page+$FFE |
| `SramCheck_Bank0StorePageSum` 4F24, `_ClearPage` 4F53, `_CopyPage` 4F7B | store checksum, zero a page, copy a page to its mirror (dest = src xor $10) |
| `SramCheck_CompareDEHL` 4F46 / `2` 5093 | A=0 equal, $FF different |
| `SramCheck_VerifyAndRepairAll` 4FA9 | page 0 ok -> copy to page 1; else page 1 ok -> restore page 0; else clear both; then the bank-1 block check (clear on mismatch); callers 65:418A/41A9/4226, 48:49F8, 68:4DB4 |
| `SramCheck_Bank0Status` 4FF6 | A=1 page 0 ok, 0 only page 1 ok, $FF both bad (no repair) |
| `SramCheck_Bank0Commit` 501D | re-sum page 0, store, mirror to page 1; called after every save from banks 25/2A/2B/2D/54 (10 sites) |
| `SramCheck_Bank1BlockSum` 5035 / `StoreSum` 5077 / `ClearBlock` 50A0 / `Bank1Commit` 50FC | scheme-1 checksum of SRAM bank 1 $A000-$A683 + $A69D-$A87C, word at $A8D7 |

## 7. Sound engine (bank 04)

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

### Bank 1C - main program

| addr | name | status | summary |
|---|---|---|---|
| `1C:4000` | `Main_Run` | C | Endless main program: farcall Startup_Run (65:4000) once, then loops the title screen 0E:4000 and dispatches its result; entered by Boot at 00:0328 ... |
| `1C:4007` | `Main_TitleLoop` | C | Loop head after Startup_Run (65:4000): farcall 0E:4000 (title screen, returns A = 1 + chosen item) then call JumpTableInline with ... |
| `1C:4019` | `Main_TitleChoiceNone` | P | Result 0 of the title dispatch: jp Main_TitleLoop; 0E:4000 returns C27D+1 >= 1 so this entry looks unused (table word only, not executed) |
| `1C:401D` | `Main_TitleChoiceStart` | C | Title item 1 (Start): farcall Nav_TitleStart (7C:7B7C) (top menu flow: 1F:4000 top menu, mail menu 1D..., browser, help), then A=1 and back to ... |
| `1C:4028` | `Main_TitleChoiceSettings` | C | Title item 2 (mobile settings screen): farcall Nav_TitleMobileSettings (7C:7D1F) then A=1 and back to Main_TitleLoop; executed in title_settings, ... |

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

Data: `Table_SoundDrv_SfxTrackPtrs` (449B), `Table_SoundDrv_ParamHandlers` (44A3), `Table_SoundDrv_Commands` (46E8), `Table_SoundDrv_ExtCommands` (4726), `Table_SoundDrv_Durations` (5044), `Table_SoundDrv_NoteFreq` (5075), `Table_SoundDrv_Instruments` (51DD), `Table_SoundDrv_WavePatterns` (547D), `Table_SoundDrv_Songs` (551D), `Data_SoundDrv_Streams` (574D)

No debug-screen entry (`19:4000`, `19:4980`, `1B:4040`) has a call, jp, far pointer or table reference; the only `00 40 19` byte matches are `ld hl,$4000 ; add hl,de`.

* Evidence of `Tilemap_CommProgress_Screen`, `Palette_CommProgress_Bg/Obj` cited `26:51C4`, which is only a fill-loop label; the loader is `MailSession_InitScreen` (26:5168).

Still not proven (unchanged, stated for the record): that `MobileDict_*` shows a dictionary (no screenshot of the screen exists; the help button label, the glossary strings and the bank-3F id lists are the evidence), the debug screens' entry
conditions, the meaning of sound commands `$BD`, `$C1`-`$C5`, `B==2` = problem mail, and everything in the HYPOTHESIS rows.
