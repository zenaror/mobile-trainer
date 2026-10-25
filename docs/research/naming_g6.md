# reference 6/8: banks 57, 5C, 63, 65, 67

## 1. What these banks are

| bank | role | entry points (callers) | main data |
|---|---|---|---|
| **65** | *startup* program run once by the main loop (`1C:4000` far-calls `65:4000`), the **initial-registration wizard** (`Registration_Run`) and the full-screen **notice pages** (`Notice_ShowPage`) shared by registration, settings, delete-registration | `65:4000`, `65:487C` (from 67 and 68), `65:473F/47C8/47EA` | 24 page records (`Notice_PageTable`) + 24 page texts, 20 prompt texts (`PromptText_Table`) |
| **67** | Mobile Adapter **check screen** (boot), the **settings** flows of *モバイルせってい* (password change, usage time, usage fee, hidden phone-number change), the **password-save confirm** screen, URL helpers, the **TextBuf** (text entry buffer) library | `67:6401` (from 65), `67:58CD/60BA/626F/4000` (settings dispatcher `7C:7D5D`), `67:6536`, `67:611C`, `67:67xx` TextBuf functions (67 + 68) | phone slots in WRAM `DF10..`, adapter config image in SRAM bank 2, CGI URL strings |
| **5C** | the **communication error screen** ("通信エラー No.CC-DDD" and the boot-check "エラー No.") | `5C:5150` (callers 19, 65, 67, 68) | record table `4F53`, 21 triple lists, 36 message strings, tilemaps and palettes |
| **63** | the **"Mobile Adapter GB not plugged in" screen** and an 8 KiB **Shift-JIS validity bitmap** used by the glyph drawing code | `63:732F` (from `65:4063`), `63:4000` (from `7F:404C/405F`) | screen tiles, palettes, sprite |
| **57** | the modal **connect dialog** shown before every mail communication: fee confirmation, password entry with on-screen keyboard, "save the password?" and "stop saving?" | `57:4000` (callers 22, 23, 27, 4C) | 7-byte argument struct, saved password in SRAM1 `A880`/`A88D` |

### 1.1 Startup flow (bank 65 + 67 + 63)

```
1C:4000 -> 65:4000 Startup_Run
   inits, clear comm timers C2D1-C2D7
   67:6401 AdapterCheck_Run          "モバイルアダプタGBをチェックしています" screen (67:6369), API $02 init, $38 read config ($C0 bytes -> SRAM2:A000),
                                     $36 reset, 68:431A validates the image;  A = 0 failure/no adapter, 1 config valid, 2 config invalid/blank
   jp [Startup_StatusJumpTable + 2*A]
     0 Startup_NoAdapter    68:4870 classifies the SRAM state -> mostly NoAdapter screen (63:732F) + soft reset (Entry, A=$11);
                            state 4 continues offline (Startup_VerifySaveData)
     1 Startup_ConfigValid  68:4870 state -> Startup_ConfigValidJumpTable (fresh / info error / resume / continue)
     2 Startup_ConfigBlank  68:4870 state -> Startup_ConfigBlankJumpTable -> Registration_Run (fresh or resume)
   Startup_VerifySaveData: 22:4FF6, 48:4899, 4E:46CF; failure -> error F0/01/11 (5C) + reinitialise (22:4FA9, 48:4920, 4E:4749)
```

| step | code | frame | shot |
|---|---|---|---|
| intro page 0 (`NoticeText_RegistrationStart`); B+Select+Right held here selects the hidden variant (`C28C`) | `65:42A3` | 333 | - |
| pages 1, 2, 3, 7 (manual, terms, fee warning) | `65:42E3..4312` | 415.. | - |
| login-ID keypad, mail address, password intro, password keyboards | `68:55E1`, `68:5296/5BC4/571D`, `68:60BB`, `68:5D00` | 837, 929-1464, 1879, 1971/2832 | `login_id_keypad`, `mail_intro`, `password_intro`, `password_confirm` |
| password mismatch check (`Password_CompareEntries`), error F0/00/10 | `65:473F` | 3278 | `register_errors_f72418_mismatch_message` |
| **password save confirm** | `67:6536` (`PwSaveConfirm_Run`) | 3278 | `password_save_confirm` |
| summary, connect confirm, communication, result | `68:6AE0`, `68:6E1A`, `68:7019`, `68:766E` | 4226, 4545, 4849, 5482 | `register_summary`, `connect_confirm`, `registration_result` |
| welcome pages 5, 6 | `65:46B6` | 5892 | `welcome_1/2` |

### 1.5 Communication error screen (bank 5C)

`CommErr_ShowScreen(A=category, H=hi, L=lo)` stores the three bytes in `C196/C197/C198`, draws "No.CC-DDD" (`CommErr_DrawErrorNumber`)
and looks the message up in two steps: `CommErr_RecordTable` (`4F53`, 21 records `[id, mode, list]`, searched by category), then the triple
list of the record (`[d, e, message index]`, default `$FF,$FF`), then `CommErr_MessagePointers` (`5104`, indices 33-37 continue in
`5146`).  Callers pass the last error of the SDK layer (`68:4F8C` passes `C272/C274:C273`, bank 65 passes `$F0` + code for the boot
checks).  Categories seen (shots): `24-000` (line busy or server error, register_neterr), `26-000` (timeout, mail_timeout), `32-404`
(HTTP status, title_settings), boot-check `F0` records (mode 2, plain "エラー" header): `00/00` adapter not plugged, `00/10` wrong
password, `01/00` adapter registration info error, `01/10` and `01/11` save data error.  Category `$40` carries the four digits of
the server CGI answer (login ID errors `00 20-50`, new password rules `10 01-05`, maintenance `80 00`).  While the communication timer
runs (`wTimerEnable` bit 4) the screen uses the tilemap with the "つうしんちゅう" footer and `CommErr_UpdateCommFooter` swaps it back when
the timer stops.

### 1.6 Connect dialog (bank 57)

`ConnectDialog_Run(BC=struct, D=bank)`; struct = `[initial mode, -, -, dest bank, dest ptr lo, dest ptr hi, receivable mail count]`
(callers: `22:4B50/4C9B/4DDD` and `23:4A3F/4B81` mode 3 with dest WRAM1 `D524`; `4C:42FC` mode 3 with dest `F0:C220`; `27:4032` mode 4
with count 4).  Return `B=$FF` when cancelled, `B=0` after writing the password (NUL-terminated) to the destination.
State `C0D8` (previous `C0E6`, requested `C0D6`):

### 1.7 Font validity bitmap and no-adapter screen (bank 63)

`Font_ValidateSjisCode` is called by the double-byte glyph routine (`00:1044` -> `7F:405F`) with HL = Shift-JIS code; the 8 KiB bitmap at `63:407A` has 7332 bits set (lead bytes 81-84, 87-9F, E0-EA; trail 40-7E/80-FC) and an invalid code becomes `$81A1` ("■").

## 2. Named symbols by subsystem

Full evidence per row: `config/symbols/bank<NN>.tsv`.  Status C = CONFIRMED, P = PROBABLE, H = HYPOTHESIS.

### Bank 65 (startup, registration wizard, notice pages)

| addr | name | | summary |
|---|---|---|---|
| `4055` | `Label_65_4055` | H | index 4 of the no-adapter table: jp 416C (verify the save data and continue without adapter); never executed |
| `4123` | `Registration_ReadStage` | C | reads SRAM1:B010 (registration stage, XOR $A5), keeps only 1,2,3 (else 0) in C277 (preserving the SRAM enable/bank); C277==2 makes Registration_Run... |
| `41AA` | `Function_65_41AA` | H | silent variant of Startup_VerifySaveData/SaveDataError: 22:4FF6==$FF -> 22:4FA9; 48:4899!=0 -> 48:4920; 4E:46CF!=0 -> 4E:4749 (re-initialise each b... |
| `41DA` | `Registration_Run` | C | Initial-registration wizard: notice pages 0-3/7 (Notice_ShowPage), login ID / mail / password entry screens (bank 68), password-save confirm (67:65... |
| `42A3` | `Registration_IntroPage` | C | shows page 0 (intro); if B+Select+Right ($16 in hJoyHeld) are held C28C:=1 selects the hidden variant with the phone-number-method page ($0C); exec... |
| `42E3` | `Registration_NoticePages` | C | stores C28C in SRAM1:B089 (68:4B48), then notice pages 1, 2, 3, 7 in order (B goes back one page, page 1 back to the intro); executed at register f415 |
| `432D` | `Registration_LoginIdEntry` | P | login ID screen 68:5296 (first frame 929, shot login_id_keypad f1138); B goes back (431D), then DEA0 is stored to SRAM1:B066 (68:4A4A b=1) |
| `4344` | `Registration_MailIntro` | P | screen 68:5BC4 (first frame 1372, shot mail_intro f1449) before the mail address keyboard |
| `434D` | `Registration_MailAddressEntry` | P | mail address screen 68:571D (frame 1464); DEAB/DEB4 are stored to SRAM1:B071/B07A (68:4A4A b=2) |
| `4384` | `Registration_PasswordIntro` | P | screen 68:60BB (first frame 1879, shot password_intro f1956); falls into the password entry |
| `438D` | `Registration_PasswordEntry` | P | copies DEB9->DED4, keyboard 68:5D00 (A=0 password, A=1 confirmation), Password_CompareEntries mismatch -> error F0/00/10 (5C) and both buffers clea... |
| `4402` | `Registration_PasswordAccepted` | C | password stored to SRAM1:B07F (68:4A4A b=4), then PwSaveConfirm_Run(A=0) (67:6536) decides C27A and SRAM1:B088; executed at register f3278 |
| `4435` | `Registration_SummaryStep` | P | 68:61F7 summary/confirm screen (first frame 3601, shot register_summary f4208): 0 (B) back to the save-password question (4410), 2 back to the logi... |
| `4455` | `Registration_NoticePages_Hidden` | P | hidden-variant copy of Registration_NoticePages (C28C=1) that continues at 448F; executed at register_hidden f415 |
| `44DD` | `Registration_PhoneMethodMenu` | C | hidden variant only: SettingsPhone_ChoiceMenu(A=1) auto/manual (67:4631); auto stores B08A:=0 and goes on, manual stores B08A:=1 and continues at 4... |
| `4526` | `Registration_ManualPhoneEntry` | P | manual phone entry: page $0C, PhoneKeypad_Run(A=0) -> SRAM1:B08B, PhoneKeypad_Run(A=1) -> B09C, PhoneComment_KeyboardRun -> B0AD (68:4A4A); not exe... |
| `4642` | `Registration_Communicate` | P | after the summary: 68:4C2B, clears the saved password (SRAM1:A880:=0), Registration_SavePassword if C27A, 68:6AE0, 68:6E1A (connect confirm, shot f... |
| `46B6` | `Registration_WelcomePages` | C | notice pages 5 and 6 (welcome, mail the registration form); B on page 6 repeats page 5; executed at register f5892 (shots welcome_1/2) |
| `46CA` | `Registration_Aborted` | C | registration failed or cancelled: 68:766E result screen then the locked page 4 ('registration cancelled, turn the power OFF'); executed in register... |
| `46FF` | `Function_65_46FF` | H | unreferenced: WRAM bank 3, CopyString DECB -> DEB9 (confirm buffer copied over the first entry) |
| `471F` | `Function_65_471F` | H | unreferenced: WRAM bank 3, CopyString DECB -> DEC2 |
| `473F` | `Password_CompareEntries` | C | WRAM bank 3: CompareString(DEB9, DECB) -> A=B=difference (0 equal); registration: password vs confirmation (mismatch -> error F0/00/10); password c... |
| `4761` | `Function_65_4761` | H | compares DEB9 with the edited copy DED4; when different clears the confirm buffer (68:403B on DECB), C279:=0 and clears bit2 of C278 (SRAM enabled... |
| `47C8` | `Password_CompareNewAndConfirm` | C | WRAM bank 3: CompareString(DECB, DEC2) -> A (0 equal); used by the password-change flow 67:58CD (new password vs its confirmation) |
| `47EA` | `Registration_SavePassword` | C | copies the password DEB9 to C28F, StringLength, then SavedPassword_Store (57:541C): stores it in SRAM1:A880/A88D for the connect dialog; executed a... |
| `481A` | `Function_65_481A` | H | dead variant of Startup_VerifySaveData: 68:48DE state 2/3 -> 4852/485D, else 48:4899/4E:46CF checks; its 'call $21A0' targets ROM0 padding (stale),... |

| addr | name | | summary |
|---|---|---|---|
| `487C` | `Notice_ShowPage` | C | A=page id 0-23: draws a full-screen notice page (header gfx, page n/m counter, body text from Notice_PageTable, footer, sound) and waits: A -> retu... |
| `493C` | `Notice_ShowPage_InputLoop` | C | frame loop of the notice page: VBlank wait, pad read, JoypadDispatch (A -> 495B, B -> 4974, others ignored) |
| `494E` | `Notice_JoypadTable` | C | inline table of the JoypadDispatch call at 65:494B: A 495B, B 4974, Select 4999, Start 499B, none 4958 |
| `495B` | `Notice_ShowPage_ButtonA` | C | A: sound $2C, fade out, return A=1 |
| `4974` | `Notice_ShowPage_ButtonB` | C | B: only when C280 (record byte 1) is 1 or 5: sound $2E, fade out, return A=0; other page modes ignore B |
| `499D` | `Notice_ShowPage_Locked` | C | record mode 2 (pages 4 'registration cancelled, power OFF' and 11 'registration deleted, power OFF'): endless VBlank loop, no way out |
| `49A2` | `Notice_DrawBodyText` | C | clears the text box and prints the page text (pointer at record+4) with 00:0ED3, then uploads the text tiles (4F:4572/45C6) |
| `4A37` | `Notice_LoadHeaderGfx` | C | copies the page header tiles (far pointer from Notice_HeaderGfxTable[record byte 0], 40 blocks to $9301) and the footer tiles (Notice_FooterGfxTabl... |
| `4A81` | `Notice_HeaderGfxTable` | P | 24 far pointers (addr16 LE + bank) to the header tile sets (banks 58, 4B, 71), indexed by record byte 0; read by 65:4A37 |
| `4AC9` | `Notice_FooterGfxTable` | P | 7 word pointers to footer tile sets in bank 58 ($69D0,$6C50,$6ED0,$7150,$73D0,$7650,$78D0), indexed by record byte 1; read by 65:4A37 |
| `4AD7` | `Notice_DrawPageCounter` | C | if record byte 2 (page number) !=0 writes the tiles of 'n / m' (digit records of Table_65_4B7C/4B92, slash = index 10) into the tile map at D210-D212 |
| `4B78` | `Notice_DigitRecordLists` | P | 2 pointers to the digit record lists 4B7C (normal) and 4B92 (variant used when record byte 0 == 4) |
| `4B7C` | `Notice_DigitRecords_Normal` | P | 11 words = addresses of the 4-byte digit glyph records 58:7E48..7E70 (digits 0-9 and slash) |
| `4B92` | `Notice_DigitRecords_Variant` | P | 11 words = addresses of the digit records 58:7E74..7E9C (attribute variant) |
| `4BA8` | `Notice_RequestPageSound` | C | reads Notice_PageSoundTable[C27C] and passes it as BC to the bank-4 audio stub 00:20E8 (WRAM bank 1 selected) |
| `4BC6` | `Notice_PageSoundTable` | P | 24 bytes indexed by the page id: $09 for most pages, $19 for pages 5/6 (welcome), $13 for page 11; argument of 00:20E8 |
| `4BDE` | `Notice_PageTable` | P | 24 six-byte records per page id: [header gfx index, footer/button mode (0-6; 2=locked, 1/5=B allowed), page n, page count m, text pointer] |

| addr | name | | summary |
|---|---|---|---|
| `4C6E` | `NoticeText_RegistrationStart` | C | notice page 0 text (Shift-JIS, NUL-terminated, word 1 of record 0 of Notice_PageTable): starting the initial registration to DION; young children s... |
| `4CFA` | `NoticeText_HaveManualReady` | C | notice page 1 text (Shift-JIS, NUL-terminated, word 1 of record 1 of Notice_PageTable): have the manual and registration form from the Mobile Adapt... |
| `4D50` | `NoticeText_AgreeToTerms` | C | notice page 2 text (Shift-JIS, NUL-terminated, word 1 of record 2 of Notice_PageTable): to use Mobile System GB please agree to the KDDI service te... |
| `4E0D` | `NoticeText_ReadTerms` | C | notice page 3 text (Shift-JIS, NUL-terminated, word 1 of record 3 of Notice_PageTable): the terms are written in the DION Mobile GB course registra... |
| `4E88` | `NoticeText_RegistrationCancelled` | C | notice page 4 text (Shift-JIS, NUL-terminated, word 1 of record 4 of Notice_PageTable): initial registration cancelled; turn the Game Boy power swi... |
| `4ED4` | `NoticeText_Welcome` | C | notice page 5 text (Shift-JIS, NUL-terminated, word 1 of record 5 of Notice_PageTable): welcome to Mobile System GB; from today mail and the Ninten... |
| `4F3E` | `NoticeText_MailRegistrationForm` | C | notice page 6 text (Shift-JIS, NUL-terminated, word 1 of record 6 of Notice_PageTable): fill in the registration form from the box and mail it to K... |
| `4FC1` | `NoticeText_UsageFeeWarning` | C | notice page 7 text (Shift-JIS, NUL-terminated, word 1 of record 7 of Notice_PageTable): using Mobile System GB may cost usage fees besides call cha... |
| `505A` | `NoticeText_DeleteRegistrationWarning` | C | notice page 8 text (Shift-JIS, NUL-terminated, word 1 of record 8 of Notice_PageTable): all information saved in the adapter and Mobile Trainer wil... |
| `50EE` | `NoticeText_DeleteBeforeDisposal` | C | notice page 9 text (Shift-JIS, NUL-terminated, word 1 of record 9 of Notice_PageTable): when passing on, lending or disposing of the adapter, be su... |
| `5157` | `NoticeText_DeleteCancelled` | C | notice page 10 text (Shift-JIS, NUL-terminated, word 1 of record 10 of Notice_PageTable): deletion of the registration info was cancelled |
| `5179` | `NoticeText_DeleteDone` | C | notice page 11 text (Shift-JIS, NUL-terminated, word 1 of record 11 of Notice_PageTable): registration info completely deleted; register again to u... |
| `5202` | `NoticeText_ManualPhoneEntry` | C | notice page 12 text (Shift-JIS, NUL-terminated, word 1 of record 12 of Notice_PageTable): enter phone numbers manually: internet number, self-page... |
| `52A8` | `NoticeText_PhoneChangeDone` | C | notice page 13 text (Shift-JIS, NUL-terminated, word 1 of record 13 of Notice_PageTable): the phone number change finished correctly |
| `52CE` | `NoticeText_PhoneChangeCancelled` | C | notice page 14 text (Shift-JIS, NUL-terminated, word 1 of record 14 of Notice_PageTable): the phone number change was cancelled |
| `52EE` | `NoticeText_PasswordChangeIntro` | C | notice page 15 text (Shift-JIS, NUL-terminated, word 1 of record 15 of Notice_PageTable): changing the password; read the Mobile Trainer manual fir... |
| `5389` | `NoticeText_PasswordRules` | C | notice page 16 text (Shift-JIS, NUL-terminated, word 1 of record 16 of Notice_PageTable): password = letters and digits mixed, 4-8 characters, uppe... |
| `5424` | `NoticeText_PasswordChangeCancelled` | C | notice page 17 text (Shift-JIS, NUL-terminated, word 1 of record 17 of Notice_PageTable): the password change was cancelled |
| `5446` | `NoticeText_PasswordChangeDone` | C | notice page 18 text (Shift-JIS, NUL-terminated, word 1 of record 18 of Notice_PageTable): the new password is usable in about 5 minutes; write it d... |
| `54BA` | `NoticeText_UsageTimeIntro` | C | notice page 19 text (Shift-JIS, NUL-terminated, word 1 of record 19 of Notice_PageTable): you can view the usage time of the DION Mobile GB course;... |
| `5534` | `NoticeText_UsageTimeCancelled` | C | notice page 20 text (Shift-JIS, NUL-terminated, word 1 of record 20 of Notice_PageTable): the usage time check was cancelled |
| `5558` | `NoticeText_UsageFeeIntro` | C | notice page 21 text (Shift-JIS, NUL-terminated, word 1 of record 21 of Notice_PageTable): you can view the monthly total and details of the Nintend... |
| `5602` | `NoticeText_UsageFeeCancelled` | C | notice page 22 text (Shift-JIS, NUL-terminated, word 1 of record 22 of Notice_PageTable): the usage fee check was cancelled |
| `5624` | `NoticeText_ResumeRegistration` | C | notice page 23 text (Shift-JIS, NUL-terminated, word 1 of record 23 of Notice_PageTable): the previous initial registration did not finish; press A... |

| addr | name | | summary |
|---|---|---|---|
| `567F` | `PromptText_Table` | P | 20 word pointers to the prompt strings 56A7-5A49; 00:153D copies string [A] of this table to D000; callers 67:4887 (A=8/9), 67:5732 (A=10), 68 (inp... |
| `56A7` | `PromptText_EnterLoginId` | C | prompt string 0 of PromptText_Table (Shift-JIS, NUL-terminated): enter the login ID written on the DION Mobile GB course registration form |
| `56FB` | `PromptText_EnterMailAddress` | C | prompt string 1 of PromptText_Table (Shift-JIS, NUL-terminated): enter the mail address written on the DION Mobile GB course registration form |
| `5751` | `PromptText_EnterPassword` | C | prompt string 2 of PromptText_Table (Shift-JIS, NUL-terminated): enter a password; take care that other people do not learn it |
| `57A7` | `PromptText_DoNotUnplug` | C | prompt string 3 of PromptText_Table (Shift-JIS, NUL-terminated): do not unplug the adapter or phone or turn the Game Boy power switch OFF |
| `5809` | `PromptText_CheckingRegistration` | C | prompt string 4 of PromptText_Table (Shift-JIS, NUL-terminated): checking the information registered in the Mobile Adapter GB |
| `583C` | `PromptText_RegistrationVerified` | C | prompt string 5 of PromptText_Table (Shift-JIS, NUL-terminated): confirmed that the registration info is correct; initial registration ends |
| `5879` | `PromptText_DeleteWarning` | C | prompt string 6 of PromptText_Table (Shift-JIS, NUL-terminated): deleted info cannot be restored; be careful |
| `58B6` | `PromptText_ReRegisterAfterDelete` | C | prompt string 7 of PromptText_Table (Shift-JIS, NUL-terminated): to use the service again after deleting, register again |
| `5906` | `PromptText_SelectMenu` | C | prompt string 8 of PromptText_Table (Shift-JIS, NUL-terminated): please select from the menu |
| `5920` | `PromptText_SelectPhoneEntryMethod` | C | prompt string 9 of PromptText_Table (Shift-JIS, NUL-terminated): choose how to enter the phone number |
| `5946` | `PromptText_PhoneChangeDone` | C | prompt string 10 of PromptText_Table (Shift-JIS, NUL-terminated): the phone number change finished correctly |
| `596C` | `PromptText_ChangePassword` | C | prompt string 11 of PromptText_Table (Shift-JIS, NUL-terminated): changing the password |
| `5985` | `PromptText_ViewUsageTime` | C | prompt string 12 of PromptText_Table (Shift-JIS, NUL-terminated): viewing the usage time |
| `5998` | `PromptText_ViewUsageFee` | C | prompt string 13 of PromptText_Table (Shift-JIS, NUL-terminated): viewing the usage fee |
| `59A9` | `PromptText_PasswordChangeDone` | C | prompt string 14 of PromptText_Table (Shift-JIS, NUL-terminated): the password change finished correctly |
| `59CF` | `PromptText_UsageTimeDone` | C | prompt string 15 of PromptText_Table (Shift-JIS, NUL-terminated): the usage time check ended |
| `59F1` | `PromptText_UsageFeeDone` | C | prompt string 16 of PromptText_Table (Shift-JIS, NUL-terminated): the usage fee check ended |
| `5A11` | `PromptText_CommFailed` | C | prompt string 17 of PromptText_Table (Shift-JIS, NUL-terminated): communication failed because of an error |
| `5A33` | `PromptText_CommInterrupted` | C | prompt string 18 of PromptText_Table (Shift-JIS, NUL-terminated): communication was interrupted |
| `5A49` | `PromptText_PasswordSaveNote` | C | prompt string 19 of PromptText_Table (Shift-JIS, NUL-terminated): see the manual for the notes about saving the password |

### Bank 67 (adapter check, settings, text buffer)

| addr | name | | summary |
|---|---|---|---|
| `6369` | `AdapterCheck_DrawScreen` | C | draws the 'checking Mobile Adapter GB' screen (モバイルアダプタGBをチェックしています): bank-4A tiles/tilemap/palettes, animated adapter sprite, LCD on; executed in... |
| `6401` | `AdapterCheck_Run` | C | called by Startup_Run: check screen + sound request (00:20E8 bc=$18), runs the API state machine (644E) and returns A=[C27C]: 0 comm failure/no ada... |
| `6437` | `AdapterCheck_Setup` | C | 7D:7C00 (b=$15,c=3), sprite reset, then AdapterCheck_DrawScreen |
| `644E` | `AdapterCheck_Poll` | C | per-frame loop of the adapter check: sprites, VBlank wait, sound request $46 once when the adapter sprite reaches frame 2 (latch C286), then jp [Ad... |
| `64AE` | `AdapterCheck_StateTable` | C | 3 code pointers 64B4/64C7/64F5 indexed by C27D; read in all 41 scenarios (boot check) |
| `64B4` | `AdapterCheck_State_Init` | C | state 0: MobileAPI $02 (Init, DE=$C271, HL=$0067 caller bank), C27D:=1 |
| `64C7` | `AdapterCheck_State_ReadConfig` | C | state 1: when idle (wTimerEnable bits 0/1 clear) MobileAPI $38 reads the $C0-byte adapter configuration into SRAM bank 2 $A000, C27D:=2; bit1 set -... |
| `64F5` | `AdapterCheck_State_Finish` | C | state 2: SRAM off, MobileAPI $36 (reset SDK), 68:431A validates the configuration image: C27C:=1 valid, 2 invalid |
| `6520` | `AdapterCheck_Abort` | C | API failure (wTimerEnable bit1): 68:4F71, SRAM off, MobileAPI $36, C27C:=0 |

| addr | name | | summary |
|---|---|---|---|
| `58CD` | `PasswordChange_Run` | C | Settings menu entry 1 (パスワードの変更, 7C:7D70): pages $0F/$10, keyboards for current/new/confirm password (68:5D00 a=2,3,1), checks 65:473F/47C8 (error... |
| `5A0E` | `PasswordChange_SaveNewPassword` | P | copies the new password DEC2 to C28F, StringLength, SavedPassword_Store: refreshes the saved connect password after a successful change when the us... |
| `5A3E` | `PasswordChange_Communicate` | C | draws the communicating screen and runs the network state machine that POSTs the password change to the DION CGI; returns C27C (1 ok, 0 fail, 2 can... |
| `5A4E` | `PasswordChange_Communicate_Setup` | C | 7D:7C00, sprite reset, C27C=C27D=0, then bank-68 screen helpers 68:7401(A=1) and 68:7405(A=0); kind 1/2/3 = password change/usage time/usage fee (c... |
| `5A75` | `PasswordChange_Communicate_Poll` | C | clears comm counters, C26E:=9, C26F:=0, then jp [PasswordChange_StateTable+2*C27D] |
| `5A9E` | `PasswordChange_StateTable` | C | 6 state handlers 5AAA/5ACA/5B0E/5B5B/5BD8/5CC2 indexed by C27D (state 5 is set at 67:5CB2) |
| `5AAA` | `PasswordChange_State_Init` | C | state 0: 68:7413(0) poll (result 2 -> abort 5DFE), MobileAPI $02 (init), C27D:=1 |
| `5ACA` | `PasswordChange_State_ReadLoginId` | C | state 1: when idle MobileAPI $0E (export the login ID) into SRAM3:$A200, C27D:=2; polled 864x in settings_cgi |
| `5B0E` | `PasswordChange_State_Connect` | C | state 2: builds the connect argument (default DNS pair, login ID from 00:1586, 'guest' twice) at $A100 and calls MobileAPI $3E (connect with DNS),... |
| `5B5B` | `PasswordChange_State_SendRequest` | C | state 3: clears SRAM3:$B000.., copies the CGI URL to $A463 (67:5B7E), builds the POST body (PasswordChange_BuildRequestBody), request descriptor at... |
| `5BD8` | `PasswordChange_State_WaitResponse` | C | state 4: polls; comm-time limit (C26E += 10 up to $45, then 50:4000); parses the answer at D340/D380: 'OK' -> disconnect (5CAD), else category $40... |
| `5CC2` | `PasswordChange_State_Finish` | P | state 5 (after disconnect): MobileAPI $36 reset, steps the comm panel to its end (Function_67_5CF4), C27C:=1 |
| `5CF4` | `Function_67_5CF4` | H | loops 68:7413 (CommPanel_Step, A=1: C289=1) until it returns 0 (bank-68 namer: 0 finished, 2 cancelled), i.e. steps the communication panel to its... |
| `5D26` | `PasswordChange_HandleHttpStatus` | C | API error: if C272==$32 (HTTP status class) and C274==3 (3xx) and C273 is 1 or 2 (301/302) a redirect is followed from 5D45, else the error is repo... |
| `5D45` | `PasswordChange_FollowRedirect` | P | 3xx redirect: resolves the Location URL with HttpRedirect_ResolveUrl, rebuilds the request descriptor and calls MobileAPI $2A (HTTP) |
| `5D99` | `PasswordChange_Cleanup` | C | error/abort path: stops the API ($34 when running else $0A), waits until it stops, steps the comm panel to its end, fade out, 68:4F8C shows the err... |
| `5DFE` | `PasswordChange_Abort` | P | user cancel (68:7413 returned 2): MobileAPI $34 abort, wait until it stops, comm panel to its end (5CF4), reset ($36), C27C:=2 |
| `5E7D` | `PasswordChange_BuildRequestBody` | C | concatenates 'PPP_ID=' + login ID ($A200) + '&PASSWD=' + current password (DEB9) + '&NEWPASSWD=' + new password (DEC2) at SRAM3:$A363 with CopyStri... |
| `611C` | `PasswordPrompt_Ask` | C | asks for the DION password (68:6E1A confirm dialog, keyboard 68:5D00 a=0 into DED4), copies it to DECB and C220 and returns A=1, or A=0 on B/failur... |
| `6536` | `PwSaveConfirm_Run` | C | A=variant C27E (0 registration wizard, 1 password change): screen パスワード保存の確認 / パスワードを保存します よろしいですか？ [はい][いいえ]; returns C27C: 0 = B (variant 0 only)... |
| `6565` | `PwSaveConfirm_Setup` | C | loads bank 5D tiles, tilemap 5D:7BA0 (variant 0) or 71:6F6F (variant 1), default cursor = C27A xor 1, prompt text, cursor sprite |
| `6625` | `PwSaveConfirm_Loop` | C | frame loop: A -> 1 (Yes) or 2 (No), B -> 0 in variant 0, left/right toggles (sfx $29) |
| `66A6` | `PwSaveConfirm_PlaceCursor` | C | sprite slot DA00 := PwSaveConfirm_CursorPos[C27D] |
| `66BE` | `PwSaveConfirm_CursorPos` | P | 2 (X,Y) pairs of the Yes/No cursor ($28,$30 / $58,$30) |
| `66C2` | `PwSaveConfirm_BuildTextMap` | P | 4F:45C6: tile numbers of the prompt area |
| `66D2` | `PwSaveConfirm_PrintPrompt` | C | clears the prompt box and prints a prompt text via 00:153D (PromptText_Table) |
| `6721` | `PwSaveConfirm_UploadTextTiles` | P | 4F:4572: uploads the prompt text tiles to VRAM $9000 |

| addr | name | | summary |
|---|---|---|---|
| `60BA` | `UsageTime_Run` | C | Settings menu entry 2 (ご利用時間の確認, 7C:7D79): page $13 (explanation), UsageTime_Request, result screens (68:766E a=2) and page $14 (cancelled). Execut... |
| `6171` | `UsageTime_Request` | C | clears SRAM3:$A000.., copies the jikan CGI URL to $A100, login ID (00:1586) to C28F, 68:7401(2), HTTP request 4E:488D; returns A=1 ok, 0 error, 2 c... |
| `626F` | `UsageFee_Run` | C | Settings menu entry 3 (ご利用額の確認, 7C:7D82): page $15 (explanation), UsageFee_Request, result screens (68:766E a=3) and page $16 (cancelled). Executed... |
| `62D5` | `UsageFee_Request` | C | like UsageTime_Request but with the fee summary URL (Net_UsageFeeUrl, copied at 67:62F9; a GET per docs/research/dynamic_tracing.md), 68:7401(3), 4... |

| addr | name | | summary |
|---|---|---|---|
| `5E43` | `Net_PwdChgCgiUrl` | C | ASCII 'http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_pwdchg.cgi' (DION password-change CGI), copied to SRAM3:$A463 at 67:5B7E (state 3 of PasswordChange) |
| `5E77` | `Net_GuestString` | C | ASCII 'guest', copied twice after the login ID into the connect argument at $A100 in state 2 of PasswordChange (67:5B30-5B50) |
| `5EB4` | `Net_PppIdKey` | C | ASCII 'PPP_ID=' (POST parameter name), first piece of the request body built by 67:5E7D |
| `5EBC` | `Net_PasswdKey` | C | ASCII '&PASSWD=' (POST parameter name) |
| `5EC5` | `Net_NewPasswdKey` | C | ASCII '&NEWPASSWD=' (POST parameter name) |
| `5F54` | `Net_CopyDefaultDnsPair` | C | copies the 8 bytes at Net_DefaultDnsPair to DE (CopyBytes): the DNS pair prefix of the connect argument |
| `5F5E` | `Net_DefaultDnsPair` | C | C0 A8 28 02 C0 A8 28 02 = 192.168.40.2 twice (primary/secondary DNS) used as the prefix of MobileAPI $3E (docs/research/mobile_trainer_serial.md) |
| `5F66` | `HttpRedirect_ResolveUrl` | P | URL at [C275/C276] (written from BC of API $00 by 68:4F71, called at 67:5D26): 'http://...' is copied to $A463, else joined to the base there (Join... |
| `5FB5` | `HttpRedirect_JoinRelative` | P | HL=base URL, DE=relative part: if it starts with '/' keeps scheme+host of the base and replaces the path, else appends it at the end of the base (i... |
| `5FF9` | `HttpRedirect_NormalizePath` | P | HL=URL: in place, turns '\' into '/', removes './' and '../' segments, stops at '?' or '#' (compares $2F,$2E,$5C,$3F,$23) |
| `61D2` | `Net_UsageTimeCgiUrl` | C | ASCII 'http://mgb.dion.ne.jp/cgi-bin/mgb/daa_gb_jikan.cgi' (jikan = time): the usage-time CGI, copied to SRAM3:$A100 by 67:6171 |
| `6205` | `Net_BuildLoginPostBody` | C | builds 'PPP_ID=' + C1E0 (login ID) + '&PASSWD=' + DECB at SRAM3:$A000 (WRAM bank 3 selected) and returns the length; called from 4C:43CD, executed... |
| `6246` | `Net_PppIdKeyDup` | C | ASCII 'PPP_ID=' (second copy used by 67:6205) |
| `624E` | `Net_PasswdKeyDup` | C | ASCII '&PASSWD=' (second copy used by 67:6205) |
| `6257` | `Net_DebugLoginBody` | P | ASCII 'PPP_ID=1002&PASSWD=itoh': test parameters after the CGI strings, no reference found in the ROM; 'itoh' is the login id of the developer test... |
| `632D` | `Net_UsageFeeUrl` | C | ASCII 'http://gameboy.datacenter.ne.jp/cgb/utility?request=summary' (usage fee summary), copied to SRAM3:$A100 by 67:62D5 |

| addr | name | | summary |
|---|---|---|---|
| `6731` | `TextBuf_Init` | C | HL=buffer (WRAM bank 3), B=capacity: [+0]=B, [+1]=B-1 (free slots), [+2]=0 (count), [+3]=0 (empty NUL-terminated text). Used by both keypads (DE80,... |
| `674F` | `TextBuf_AppendChar` | C | HL=TextBuf, D=char: A=1 if no free slot, else inserts D at the cursor position [+2] (tail shifted up, NUL kept), free--, count++ and returns A=0 |
| `6799` | `TextBuf_DeleteLast` | C | HL=TextBuf: A=1 if count==0, else removes the character before the cursor (the loop only works with the cursor at the end, which is always the case... |
| `67DB` | `Function_67_67DB` | H | unreferenced sibling of the TextBuf functions: decrements the count byte [HL+2] when non-zero, returns A=0/1 |
| `6807` | `TextBuf_GetCount` | C | B=A=[HL+2] (number of characters) with WRAM bank 3 selected; executed in 17 scenarios |
| `6828` | `TextBuf_GetFree` | C | B=A=[HL+1] (free character slots) with WRAM bank 3 selected |
| `6842` | `TextBuf_GetLength` | C | B=A=capacity-free-1 = [HL]-[HL+1]-1 (length of the text) with WRAM bank 3 selected |

### Bank 5C (communication error screen)

| addr | name | | summary |
|---|---|---|---|
| `4FA8` | `CommErr_Triples_10` | P | triples [C197,C198,message index] of record $10 (adapter not plugged (10)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FAE` | `CommErr_Triples_11` | P | triples [C197,C198,message index] of record $11 (dial failed/busy (11)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FB4` | `CommErr_Triples_12` | P | triples [C197,C198,message index] of record $12 (line busy (12)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FBA` | `CommErr_Triples_13` | P | triples [C197,C198,message index] of record $13 (dial failed/busy (13)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FC0` | `CommErr_Triples_14` | P | triples [C197,C198,message index] of record $14 (adapter registration invalid (14)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FC6` | `CommErr_Triples_15` | P | triples [C197,C198,message index] of record $15 (adapter errors 15-00..03), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FD5` | `CommErr_Triples_16` | P | triples [C197,C198,message index] of record $16 (comm error (16)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FDB` | `CommErr_Triples_17` | P | triples [C197,C198,message index] of record $17 (comm error (17)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FE1` | `CommErr_Triples_20` | P | triples [C197,C198,message index] of record $20 (comm error (20)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FE7` | `CommErr_Triples_21` | P | triples [C197,C198,message index] of record $21 (comm error (21)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FED` | `CommErr_Triples_22` | P | triples [C197,C198,message index] of record $22 (bad password/login id (22)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FF3` | `CommErr_Triples_23` | P | triples [C197,C198,message index] of record $23 (disconnected (23)), searched at 5C:530D, last triple $FF,$FF is the default |
| `4FF9` | `CommErr_Triples_24` | P | triples [C197,C198,message index] of record $24 (line busy or server error (24; screenshot 24-000)), searched at 5C:530D, last triple $FF,$FF is th... |
| `4FFF` | `CommErr_Triples_25` | P | triples [C197,C198,message index] of record $25 (adapter registration invalid (25)), searched at 5C:530D, last triple $FF,$FF is the default |
| `5005` | `CommErr_Triples_26` | P | triples [C197,C198,message index] of record $26 (timeout (26; screenshot 26-000)), searched at 5C:530D, last triple $FF,$FF is the default |
| `500B` | `CommErr_Triples_30` | P | triples [C197,C198,message index] of record $30 (SMTP reply-code shaped: 221, 421, 450-452, 500-504, 550-554 as d=hundreds, e=BCD; 550-553 -> desti... |
| `503E` | `CommErr_Triples_31` | P | triples [C197,C198,message index] of record $31 (codes 00 02..04 -> messages 12 'mail address wrong', 13 'password wrong or server error', 5 generi... |
| `504D` | `CommErr_Triples_32` | P | triples [C197,C198,message index] of record $32 (HTTP status errors 32-3xx/4xx/5xx (screenshot 32-404)), searched at 5C:530D, last triple $FF,$FF i... |
| `5080` | `CommErr_Triples_33` | P | triples [C197,C198,message index] of record $33 (codes 01 01-06, 02 01-06/99, 03 01, 04 01-04 -> fee/customer/maintenance/registration messages), s... |
| `50B9` | `CommErr_Triples_40` | P | triples [C197,C198,message index] of record $40 (server CGI error codes (login id, password, new-password rules, maintenance)), searched at 5C:530D... |
| `50F5` | `CommErr_Triples_F0` | P | triples [C197,C198,message index] of record $F0 (boot-time checks (mode 2 record, 5 triples, no $FF terminator)), searched at 5C:530D, last triple... |
| `53A1` | `Label_5C_53A1` | H | record id not found in the table: only the plain tilemap 5AB6 is loaded; not executed |
| `5516` | `CommErr_Tilemap_Comm` | C | 18x20 tilemap+attr (720 bytes) of the 'comm error' screen with the plain footer (header 通信エラー No.); loaded at 5C:52A2 with 00:08EA |
| `57E6` | `CommErr_Tilemap_CommTimer` | C | 18x20 tilemap+attr of the 'comm error' screen with the 'つうしんちゅう' (communicating) footer, used when the comm timer runs (5C:52B7) |
| `5AB6` | `CommErr_Tilemap_Plain` | C | 18x20 tilemap+attr of the plain 'エラー No.' screen used by boot-check records and as default (5C:52FB, 53AC) |
| `5D90` | `CommErr_Gfx_Obj8000` | C | 2 tiles HDMA'd to VRAM bank 1 $8000 by 5C:5194 (object tiles) |
| `5DB0` | `CommErr_Gfx_Obj8100` | C | 2 tiles HDMA'd to VRAM bank 1 $8100 by 5C:51A6 |
| `5DD0` | `CommErr_Gfx_Bg9000` | C | 64 tiles (header, frame, digits) HDMA'd to VRAM bank 1 $9000 by 5C:51B8 |
| `61D0` | `CommErr_Gfx_Bg9400` | C | 24 tiles HDMA'd to VRAM bank 1 $9400 by 5C:51CA |
| `6350` | `CommErr_Palette_BgTimer` | P | 64 bytes copied to the BG palette staging buffer D800 (4F:4000, bc=$40) when the comm timer is running (5C:52E1); mapper class 'tiles-2bpp' is wron... |
| `6390` | `CommErr_Palette_Bg` | P | 64 bytes copied to D800 (BG palette staging) by 5C:5150 (bc=$40 at 5C:51DB) |
| `63D0` | `CommErr_Palette_Obj` | P | 64 bytes copied to D840 (OBJ palette staging) by 5C:5150 (bc=$40 at 5C:51EC) |
| `6410` | `CommErr_ObjAnim` | P | object animation data (frame table words 6414/6425, frames and script) for the footer icon; the entry point 642B = {frame table 6410?, script 6426}... |
| `642B` | `CommErr_ObjTable` | P | one 4-byte object-table entry (ptr $6410, ptr $6426) loaded with DE=$642B, A=$5C, B=$80 into sprite slot DA10 (5C:52C7) |

### Bank 63 (no-adapter screen, font validity bitmap)

| addr | name | | summary |
|---|---|---|---|
| `4000` | `Font_ValidateSjisCode` | P | HL=Shift-JIS code (lead in H, trail in L, built by 00:1044): tests bit L&7 of [Font_SjisValidBitmap+HL>>3] via a jump table; valid -> HL unchanged,... |
| `402D` | `Font_SjisBitJumpTable` | C | 8 code pointers indexed by the bit number L&7 (bit 0..7 of C); every target executed; entered through the ld l/jp hl dispatcher at 63:4000-402C |
| `406D` | `Font_ValidateSjisCode_Valid` | C | bit set: pop hl/de/bc/af and return with HL = the original code |
| `4072` | `Font_ValidateSjisCode_Invalid` | C | bit clear: restores registers and returns HL=$81A1 (SJIS black square, the substitute glyph); reached once in the traces (browser_pages f38342) |
| `407A` | `Font_SjisValidBitmap` | P | 8 KiB bitmap (65536 bits) indexed by a 16-bit Shift-JIS code: 7332 bits set, only lead bytes 81-84/87-9F/E0-EA with trail 40-7E/80-FC; mapper class... |
| `6080` | `NoAdapter_Gfx_8000` | C | 64 tiles HDMA'd to VRAM bank 0 $8000 by 63:7365 (screen 'Mobile Adapter GB not plugged in') |
| `60C0` | `NoAdapter_Gfx_8800` | C | 64 tiles (60C0-64C0, overlapping the $8000 block) HDMA'd to VRAM bank 1 $8800 by 63:7377 |
| `64C0` | `NoAdapter_Gfx_8C00` | C | 64 tiles HDMA'd to VRAM bank 1 $8C00 by 63:7389 |
| `68C0` | `NoAdapter_Gfx_9000` | C | 64 tiles HDMA'd to VRAM bank 1 $9000 by 63:739B |
| `6CC0` | `NoAdapter_Gfx_9400` | C | 64 tiles HDMA'd to VRAM bank 1 $9400 by 63:73AD |
| `6FC0` | `NoAdapter_Tilemap` | C | 18x20 tilemap+attr (720 bytes) loaded to D000 by 63:73E0 (00:08EA); overlaps the tail of the 9400 tile block |
| `7290` | `NoAdapter_Palette_Bg` | P | 64 bytes RGB555 copied to the BG palette staging buffer D800 by 63:73BE (4F:4000 bc=$40) |
| `72D0` | `NoAdapter_Palette_Obj` | P | 64 bytes RGB555 copied to the OBJ palette staging buffer D840 by 63:73CF (4F:4000 bc=$40) |
| `7310` | `NoAdapter_ObjTable` | P | 2 object-table entries (entry 1 = frame table 7318 / script 732A) used by the object init in 63:7342 (DE=$7310, A=$63, B=$81 -> 00:0A82) to create... |
| `7318` | `NoAdapter_ObjAnim` | P | frame table, 2 frames and script of the one animated sprite of the screen |
| `732F` | `NoAdapter_ShowScreen` | C | 'Mobile Adapter GB is not plugged in' screen: draws it (7342), fades in, waits for A or Start (7413), fades out. Executed in noadapter (6x) and hot... |
| `7342` | `NoAdapter_DrawScreen` | C | loads the tiles, palettes, tilemap and the sprite of the screen, turns the LCD on and shows the first frame; clears SCX/SCY |
| `7413` | `NoAdapter_WaitButton` | C | loop: sprites, VBlank wait, pad read (7D:7BB7); returns when hJoyPressedRepeat bit0 (A) or bit3 (Start) is set |

### Bank 57 (connect dialog)

| addr | name | | summary |
|---|---|---|---|
| `4000` | `ConnectDialog_Run` | C | Modal connect dialog: BC=arg struct in bank D [mode,-,-,dest bank,dest ptr,mail count]; mode C0D8 picks the screen (fee confirm, password entry, sa... |
| `4029` | `ConnectDialog_Run_LoadMode` | P | re-entry after a mode change (jp from 4068 when the new mode is <5): resets LCDC/scroll/window regs and sprites, then redraws the screen of the new... |
| `4044` | `ConnectDialog_Run_EnterMode` | P | C0E5=1 (cursor on Yes), DrawScreen (47A6), EnterMode (44E4), one sound request (00:20E8 bc=$12), then the frame loop |
| `405F` | `ConnectDialog_Run_FrameLoop` | C | loop: call HandleFrame (40E0) until it returns A!=0 (mode change requested) |
| `4068` | `ConnectDialog_Run_ModeChanged` | C | after HandleFrame!=0: LeaveMode (45E6) commits C0D6 into C0D8; new mode 0 -> cancel (408D), $10 -> accept (4096), <5 -> full reload (4029), >=5 ->... |
| `408D` | `ConnectDialog_Run_Cancel` | C | fade out (4F:4370) and return B=$FF (dialog cancelled); reached in 7 scenarios when No/B is chosen |
| `4096` | `ConnectDialog_Run_Accept` | C | fade out; copies the entered/stored password (C1B2, C1CB chars) NUL-terminated to the far pointer arg[3..5] with 48:4616, returns B=0; executed in... |
| `40E0` | `ConnectDialog_HandleFrame` | C | one frame: sprites (00:0956), wait VBlank (00:044B), read pad (7D:7BA4/7BC1), dispatch on mode C0D8 to the per-mode input handler (mode 6 -> keyboa... |
| `412A` | `Label_57_412A` | H | input handler of mode 1 (Yes/No fee confirm variant): left/right toggles C0E5, A on Yes -> C0D6=2, else -> C0D6=0; never executed, no caller starts... |
| `4189` | `Label_57_4189` | H | input handler of mode 2: like 41CA (A on Yes -> mode 9 if SRAM1:A880 !=0 else 5) but No/B -> mode 1; never executed, no caller starts in mode 2 |
| `41CA` | `ConnectDialog_Input_ConnectConfirm` | C | input of modes 3/4 (screen 'connect? Yes/No'): left/right toggles Yes/No (C0E5 xor 3, sfx $29); A on Yes -> mode 9 if saved password length SRAM1:A... |
| `4237` | `ConnectDialog_Input_PasswordPrompt` | P | input of mode 5 (password entry screen before the keyboard is active): A -> mode 6; B -> the caller's initial mode arg[0] when arg[0]>=3, else mode... |
| `426B` | `ConnectDialog_Input_Keyboard` | C | input of mode 6: polls the on-screen keyboard (55:5C8F): 1 append char, 2 erase, $0A validate then mode 7 if ok, 7 -> exit ok ($10), 8/9 -> mode 5;... |
| `4299` | `ConnectDialog_Keyboard_AppendChar` | C | keyboard result 1: if C1CB==8 buzz (sfx $31) else sfx $38, store char C2AD into C1B2[len], its glyph bytes (55:6CC6) into C1BA[2*len], len++, redraw |
| `433F` | `ConnectDialog_Keyboard_EraseChar` | C | keyboard result 2: if len==0 go back to mode 5 (438E) else sfx $39, len--, terminate C1B2/C1BA, redraw the field |
| `43BC` | `ConnectDialog_Input_SaveConfirm` | P | input of mode 7 (screen 'save password? する/しない'): left/right toggles C0E5; A on する -> mode 8, しない/B -> mode 6; executed only in monkey campaigns |
| `4421` | `ConnectDialog_Input_PasswordSaved` | P | input of mode 8 (screen 'password saved'): A -> accept ($10), B -> back to mode 7; executed only in monkey campaigns |
| `4443` | `ConnectDialog_Input_StoredPassword` | C | input of mode 9 (screen 'password is saved, A starts communication'): A -> accept ($10); B -> arg[0] if >=3 else mode 2 (57:4463-4477); Select -> m... |
| `4481` | `ConnectDialog_Input_ForgetConfirm` | P | input of mode 10 (text 'stop saving the password?' Yes/No): A on Yes -> mode 5 (LeaveMode clears SRAM1:A880), No/B -> mode 9 |
| `44E4` | `ConnectDialog_EnterMode` | C | per-mode entry action after the screen is drawn: 5 redraw password field; 6 raster split + keyboard init (55:5BA2); 8 store password to SRAM (Saved... |
| `4517` | `ConnectDialog_Enter_Keyboard` | C | mode 6 entry: C0F6=9, STAT=$44/LYC=$1A, installs 00:16DC raster handler in the RAM STAT vector (saved to C130-C132), enables STAT IRQ, keyboard ini... |
| `4590` | `ConnectDialog_Enter_PasswordSaved` | P | mode 8 entry: SavedPassword_Store(de=C1B2, a=C1CB) writes the typed password to SRAM |
| `459A` | `ConnectDialog_Enter_StoredPassword` | C | mode 9 entry: C1CB=SRAM1:A880, C1B2[i]=SRAM1:A88D[i] xor $5A (decodes the saved password), redraws the field (510F) |
| `45E6` | `ConnectDialog_LeaveMode` | C | mode change: C0E6=old mode, C0D8=C0D6 (new), then per old-mode cleanup: fade out, restore STAT vector after the keyboard (46E0), clear saved passwo... |
| `46E0` | `ConnectDialog_Leave_Keyboard` | C | leaving mode 6: 55:651C, restores the STAT vector CBF4 from C130-C132, clears IE bit1/IF/SCY, moves sprite slots DA20/DA30/DA40 off screen (Y=0,X=$... |
| `474F` | `ConnectDialog_Leave_PasswordSaved` | P | leaving mode 8: if the new mode is 7 the saved password is removed again (SRAM1:A880:=0 via 48:4616) |
| `477E` | `ConnectDialog_Leave_ForgetConfirm` | C | leaving mode 10: unless the new mode is 9 (No), clears C1CB and writes 0 to SRAM1:A880 (saved password forgotten), fade out |
| `47A6` | `ConnectDialog_DrawScreen` | C | draws the screen of mode C0D8: modes 1-4 -> 47D1, 5/6 -> 4951, 7 -> 4AC7, 8 -> 4D40, 9 -> 4E4C, 10 -> 4F59 (tiles/tilemaps in bank 56, text rendere... |
| `47D1` | `ConnectDialog_Draw_ConnectConfirm` | C | screen of modes 1-4: title 'connect' + fee text 56:4000 (call/connection charges apply, OK?) + Yes/No; mode 4 also shows the receivable mail count... |
| `4951` | `ConnectDialog_Draw_PasswordEntry` | C | screen of modes 5/6: 'enter the password' + masked 8-char field + keyboard window (text 56:4047); executed in 4 monkey scenarios |
| `4AC7` | `ConnectDialog_Draw_SavePasswordConfirm` | P | screen of mode 7: 'save the password?' with Attention text 56:406A and する/しない buttons |
| `4D30` | `ConnectDialog_BlankTile` | P | one blank (all $00) 2bpp tile copied to VRAM $8C10 by 4951 and 4AC7 (spacer tile) |
| `4D40` | `ConnectDialog_Draw_PasswordSaved` | C | screen of mode 8: 'password saved' (text 56:40BF, B: back); executed in 3 monkey scenarios |
| `4E4C` | `ConnectDialog_Draw_StoredPassword` | C | screen of mode 9: 'password is saved' (text 56:410A, A starts communication, Select stops saving); executed at mail_send f2801 |
| `4F59` | `ConnectDialog_Draw_ForgetConfirm` | C | screen of mode 10: 'stop saving the password? Yes/No' (text 56:4159); executed in 4 scenarios |
| `5077` | `ConnectDialog_Draw_Finish` | C | common tail of the draw routines: HDMA of 56:75C0 tiles to $8000, palettes 56:7840, upload BG (00:082C), sprites (00:0956) and fade in (4F:42B4) |
| `510F` | `ConnectDialog_DrawPasswordField` | C | redraws the mode's tilemap and the password field: modes 5-7 pad the empty cells ($22/$10 tiles, 520D), modes 8-10 draw C1CB masked cells ($11/$12,... |
| `527D` | `ConnectDialog_PlaceCaretSprites` | C | positions sprite slots DA20/DA30 (00:0A65): Y=C1CC+$1E (-8 if WY=$28), X=8*C1CB+$32/$30 i.e. the caret after the last typed char |
| `52D8` | `ConnectDialog_ObjHook_Caret` | P | per-frame object hook (registered in slot DA20+$0B via 00:0A45; engine calls slot hooks in 00:0AE8): when the caret animation ended ([slot+$F] 0/$F... |
| `531E` | `ConnectDialog_ObjHook_FollowRaster` | P | per-frame object hook (registered via 00:0A45 in DA2B): sets the Y of slots DA20/DA30 (wSpriteSlots+32/+48) to C0F6+$15 |
| `5340` | `ConnectDialog_ShowLowerWindow` | P | LCDC/=$60, WY=$38, C0F7=1: shows the lower window (mode 7 attention box); does nothing if C0F7 is already set |
| `5355` | `ConnectDialog_HideLowerWindow` | P | inverse of 5340: LCDC/=$60, WY=$90 (window off screen), C0F7=0 |
| `5369` | `ConnectDialog_ValidatePassword` | C | checks C1B2[0..C1CB): needs length>=4, at least one digit and one letter; B=1 valid else 0, C=1 if length==8. Matches the DION rule '4-8 alphanumer... |
| `53B9` | `ConnectDialog_RefreshFieldIfDirty` | P | called via farcall from 55:1013 (keyboard code): if C0E8!=0 redraws the password field (510F) and clears C0E8 |
| `53C6` | `ConnectDialog_UploadMapRow` | P | HDMA copy of one 2-block BG-map row from HL (tiles, VRAM bank 0) and HL+$400 (attrs, bank 1) to DE; waits for LY>=$91 like 00:0749; used for the 3... |
| `541C` | `SavedPassword_Store` | C | A=length (1-8), DE=chars: writes chars xor $5A to SRAM1:A88D.. and the length to SRAM1:A880 (48:4616 far write). A=0 would unbalance the stack (jr... |
| `5444` | `ConnectDialog_RenderTypedChars` | P | converts the 2-byte glyph codes C1BA (8 bytes, 48:40A9 with FFB0=2) into tile data in D000 and HDMAs 16 blocks to VRAM bank 1 $9701 (typed-characte... |
| `546C` | `ConnectDialog_PlayButtonSfx` | C | B=A: A-button sound (bc=$2C; mode 8 Yes $32, mode 10 $33) or B-button sound ($2E) via 00:20AC; per-mode jump table on C0D8; executed in 20 scenarios |

| where | current class | finding |
| --- | --- | --- |
| `63:407A-607A` | `gfx` "199 coherent tiles" | an **8192-byte bitmap** indexed by a 16-bit Shift-JIS code (`Font_SjisValidBitmap`), 937 non-zero bytes / 7332 bits, only lead bytes 81-84, 87-9F, E0-EA with trail 40-7E/80-FC; `607A-6080` are 6 zero pad bytes |
| `63:6FC0-7290` | tilemap starts in the middle of `6CC0-70C0` `gfx` | the `$9400` HDMA loads `$400` bytes from `6CC0` that overlap the first `$100` bytes of the tilemap (`63:73DB ld hl,$6FC0`); likewise the `$8800` block `60C0-64C0` overlaps the `$8000` block `6080-6480` |
| `5C:6350-6410` | `gfx` "40 coherent tiles" | **three 64-byte RGB555 palettes** at `6350` (BG, comm-timer variant), `6390` (BG), `63D0` (OBJ), copied to the staging buffers `D800/D840` with `4F:4000` (`bc=$40`) |
| `5C:6410-642F` | tail of that `gfx` + `data` "content class unknown" | one object animation record (frame table words `6414/6425`, frames, script `6426`), entry `642B = {6410, 6426}` given to `00:0A82` |
| `67:5E43`, `5E77`, `5EB4`, `61D2`, `6246`, `632D` | `data` "content class unknown" | ASCII strings: CGI/URL strings, `guest`, `PPP_ID=` |
| `65:4BC6-4BDE`, `4BDE-4C6E` | `data` | 24-byte per-page sound table + 24 six-byte page records (the region split at `4BE2` cuts record 0) |
| `65:4A81-4AD7` | `data` "repeating groups of a flag byte + 16-bit address" | 24 far pointers `[addr16 LE, bank]` (bytes 0-1 address, byte 2 bank: 58, 4B, 71) + a 7-word table at `4AC9` |

Dead code with stale targets (kept HYPOTHESIS): `65:481A` (`call $21A0` into ROM0 padding), `65:41AA`, `65:46FF/471F`, `67:424A`, `4571`, `4940`,
`4BC2`, `67DB`, `5ED1`.

## 4. Hypotheses and open questions

**`57:4237`/`43BC` transitions.** (Review fix: in modes 5 and 9, B returns to the caller's initial mode `arg[0]` when it is >= 3, otherwise to mode 2; the first version of the rows had the condition reversed.) In mode 7 ("save password? する/しない") `しない`/B goes back to the keyboard (mode 6) according to the code; the exit    without saving seems to be keyboard result 7 (`$07 -> $10`), whose key is unknown (`55:5C8F` result codes 7/8/9/`$0A` are only named by their    effect).

Reviewed: `68:7413` is the bank-68 `CommPanel_Step` (`C289=A`, one state of the    communication panel, returns `C28A`: 0 finished, 2 cancelled), so this is "step the communication panel to its end", not an SDK-idle wait as first guessed    (HYPOTHESIS row kept under the generic name; what `A=1` selects is unknown). 3.

Reviewed: the    bank-68 namer (`Settings_GetRegistrationProgress`, `68:4870`) reads the classes as 0 blank/no progress, 1 damaged page, 2/3/4 = SRAM `B010` 1/2/3    (started / fields entered / complete); this fits the roles used here (state 4 = complete = "continue offline") but is still only PROBABLE there. 4.

**`ConnectDialog_RenderTypedChars`** (`57:5444`): the meaning of the 2 bytes per character returned by `55:6CC6` is not resolved; `bc=8` is the number of    characters of the field (8 glyph cells x 2 tiles = the 16 blocks uploaded to `$9701`). 7.

**Sound requests**: `00:20AC` / `00:20E8` / `00:20C4` are bank-4 stubs whose exact role (sound effect vs BGM) is not established; the names used    here (`..._RequestPageSound`, `..._PlayButtonSfx`) avoid claiming more than "request with id in BC". 9.

The mode-2 boot record `$F0` of the error table has 5 triples without `$FF` terminator; `5C:5144` (`$0020`, slot 32 of the message index space) is     not selected by any list (kept as generic data).

* `python3 tools/gen_asm.py verify --config <copy of config with the 5 files>` -> `RESULT: IDENTICAL` (names never change bytes); `check --strict` OK;
  name uniqueness against `config/ram`, `config/symbols` and the region labels was checked with a script (0 collisions except the intended generic aliases).
* Frames and scenarios quoted in evidence come from `traces/coverage_*.tsv` (first frame per address) and the screenshot file names; the rendered
  screens were produced from the ROM bytes with the tile/tilemap loads of the code.
* Every string label was placed on the pointer targets of the pointer tables (`5C:5104/5146`, `65:4BDE` page records, `65:567F`), and the Shift-JIS text
  decoded with cp932 (translations are mine).

About 45 rows were re-read in full (all of the `57` dialog input/entry/leave handlers, `57:5369/541C`, the `5C` tables, messages and error-number drawing, `63:4000/732F`, the bank-65 startup/wizard/notice code and tables, and in bank 67 the adapter check, TextBuf, password-change, HTTP status/redirect/URL code, the phone-number screens and the password-save confirm).
