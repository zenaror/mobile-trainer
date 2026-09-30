# Naming pass 6/8: banks 57, 5C, 63, 65, 67

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`.

Scope: `config/symbols/bank57.tsv`, `bank5C.tsv`, `bank63.tsv`, `bank65.tsv`, `bank67.tsv` (407 rows), the RAM proposals in
`analysis/naming/ram_g6.tsv` (26 rows) and this document.  Every row keeps the evidence vocabulary of `docs/FORMATS.md`
(CONFIRMED = executed in a trace and tied to a screen / string / documented routine, PROBABLE = static or structural evidence
only, HYPOTHESIS = idea recorded under the generic name).  `python3 tools/gen_asm.py verify --config <dir>` prints
`RESULT: IDENTICAL` with all five files, `check --strict` passes.

Evidence sources used (all reproducible from the repository):

* the **screenshots** of the 41 trace scenarios (`.cache/trace/shots/<scenario>/*.png`, frame numbers in the file names) matched
  against the first executed frame of an address (`traces/coverage_<scenario>.tsv`);
* **rendered screens**: the tile/tilemap loads of the code (HDMA calls `00:0787`, tilemap copies `00:08EA`) were replayed
  with a small script (tiles into a fake VRAM, 20x18 tilemap, grayscale) to read the header text of screens that no scenario
  screenshot shows (e.g. the phone-number screens, `57` dialog modes 5-10);
* the decoded Shift-JIS strings (`analysis/strings.tsv`, re-decoded with cp932 for the tables) and the ROM0 library semantics of
  `docs/research/boot_and_home.md`;
* the SDK/API tables of `docs/research/mobile_trainer_serial.md` for the `call $0150` (MobileAPI) argument values.

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

`Registration_Run` (65:41DA) is the wizard.  Steps with the first frame at which they run in the `register` scenario (shot names in
`.cache/trace/shots/register`):

| step | code | frame | shot |
|---|---|---|---|
| intro page 0 (`NoticeText_RegistrationStart`); B+Select+Right held here selects the hidden variant (`C28C`) | `65:42A3` | 333 | - |
| pages 1, 2, 3, 7 (manual, terms, fee warning) | `65:42E3..4312` | 415.. | - |
| login-ID keypad, mail address, password intro, password keyboards | `68:55E1`, `68:5296/5BC4/571D`, `68:60BB`, `68:5D00` | 837, 929-1464, 1879, 1971/2832 | `login_id_keypad`, `mail_intro`, `password_intro`, `password_confirm` |
| password mismatch check (`Password_CompareEntries`), error F0/00/10 | `65:473F` | 3278 | `register_errors_f72418_mismatch_message` |
| **password save confirm** | `67:6536` (`PwSaveConfirm_Run`) | 3278 | `password_save_confirm` |
| summary, connect confirm, communication, result | `68:6AE0`, `68:6E1A`, `68:7019`, `68:766E` | 4226, 4545, 4849, 5482 | `register_summary`, `connect_confirm`, `registration_result` |
| welcome pages 5, 6 | `65:46B6` | 5892 | `welcome_1/2` |

### 1.2 Settings flows (bank 67)

The settings dispatcher `7C:7D5D` (`Table_7C_7D60`) calls: 1 `PasswordChange_Run`, 2 `UsageTime_Run`, 3 `UsageFee_Run`, 4 `68:7951` (delete
registration, not in these banks), 5 (hidden, B+Select+Right) `SettingsPhone_Run`.  Each starts with a `Notice_ShowPage` page
($0F/$10, $13, $15, $0C) and ends with a result page ($11/$12, $14, $16, $0D/$0E).  The three network flows use kind ids 1/2/3
for the bank-68 helpers `68:7401`/`68:766E`.

* **PasswordChange_Communicate** (`67:5A3E`): state machine on `C27D` (`PasswordChange_StateTable`): 0 `MobileAPI $02` init; 1 `$0E`
  export login ID to SRAM3:A200; 2 `$3E` connect with the DNS pair `192.168.40.2` x2 (`Net_DefaultDnsPair`) and the ISP login built
  at `$A100` (login ID from `00:1586`, "guest" twice); 3 build the CGI URL (`Net_PwdChgCgiUrl`) and the body
  `PPP_ID=<id>&PASSWD=<old>&NEWPASSWD=<new>` (`PasswordChange_BuildRequestBody`), `MobileAPI $2C`; 4 wait, check the 5-minute
  communication budget (`C26D`=5, error 26-000) and the communication-time limit `C26E` (starts at 9, +10 per step up to `$45`, then dialog `50:4000`), parse the answer
  (`OK` -> disconnect `$0A`; anything else -> category `$40` with the 4 ASCII digits as code); 5 reset `$36`.  HTTP errors
  arrive as category `$32` (status 301/302 are followed via `HttpRedirect_ResolveUrl` + `MobileAPI $2A`).  The title_settings shots show
  the resulting `32-404` screen (frame 7167).
* **UsageTime_Request / UsageFee_Request** (`67:6171`, `67:62D5`): clear SRAM3:A000.., copy the CGI URL, call the HTTP helper
  `4E:488D`; URLs `daa_gb_jikan.cgi` (DION, body from `Net_BuildLoginPostBody` = `PPP_ID=<id>&PASSWD=<pw>`) and
  `http://gameboy.datacenter.ne.jp/cgb/utility?request=summary`.
* **SettingsPhone_Run** (`67:4000`): edits the three dial slots stored in the adapter configuration image (SRAM bank 2 `A000`,
  slot stride `$18`: number at `A076/A08E/A0A6`, comment at `A07E/A096/A0AE`): `SettingsPhone_ReadAdapterConfig` (API `$38`),
  `SettingsPhone_ChoiceMenu` (2 items: change / select default; auto / manual), `SettingsPhone_SlotMenu` (3 tabs 登録場所1-3 with
  インターネット用 / セルフページ用 / コメント), `PhoneKeypad_Run` x2 and `PhoneComment_KeyboardRun`, `SettingsPhone_ConfirmScreen`,
  `SettingsPhone_WriteAdapterConfig` (`SettingsPhone_PatchConfigImage` rewrites the image and recomputes the 16-bit sum at
  `A0BE/A0BF`, API `$04`), `SettingsPhone_ContinuePrompt`.  The self-page number is also mirrored (xor `$A5`) in SRAM bank 1
  `B014/B025/B036`.

### 1.3 Common screen skeleton of bank 67

Every screen module follows the same pattern, which made the helper functions nameable by pattern (`<Screen>_Setup`, `_Loop`,
`_PlaceCursor`, `_BuildTextMap`, `_PrintText/_PrintPrompt/_PrintFields`, `_UploadTextTiles`, `_LoadTilemap`):

* result in `C27C` (0 = B / cancel, n = choice, 1 = ok), cursor or state in `C27D`, variant argument in `C27E` (all three are
  reused with other meanings by the other screens and by `65:487C`, so they are not proposed as RAM names);
* setup: `7D:7C00 (b=$15,c=3)`, sprite reset `00:09B6`, HDMA tile loads (`00:0787`), palettes into the staging buffers `D800/D840`
  (`4F:4000`), tilemap copy `00:08EA`, text in three steps: `4F:45C6` (tilemap indices of the text rectangle), `4F:4604` (clear
  the rectangle in the text tile buffer) + text engine registers `FFBA..FFC7` + `00:0ED3`, `4F:4572` (HDMA of the rendered tiles);
  then `4F:42B4` (fade in), loop, `4F:4370` (fade out);
* the loop: sprites `00:0956`, VBlank `00:044B`, pad `7D:7BB7`, sound requests through the bank-4 stub `00:20AC`
  (`bc=$2C` A button, `$2E` B button, `$29` cursor move, `$31` refused, `$38`/`$39` character typed/erased).

### 1.4 Text entry buffer ("TextBuf", 67:6731..6842)

Object in WRAM bank 3, used by both keypads (`DE80`, capacity `$11`) and by bank 68:

```
+0 capacity (B given to TextBuf_Init)     +2 number of characters
+1 free slots (capacity-1 after init)     +3.. NUL-terminated text (DE83 for the buffer at DE80)
```

`TextBuf_AppendChar` inserts at the cursor `+2` (tail shifted), `TextBuf_DeleteLast` removes the character before it (the shifting loop
is only correct with the cursor at the end, which the UI guarantees), `TextBuf_GetCount/GetFree/GetLength` return `+2`, `+1`,
`capacity-free-1` in `B` and `A`.

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

| mode | screen (`ConnectDialog_DrawScreen`) | input handler | notes |
|---|---|---|---|
| 0 | - | - | cancel (`B=$FF`) |
| 1-4 | "つうしんせつぞくします" + "通話料と接続料がかかります。よろしいですか?" [はい][いいえ] (`56:4000`) | 1: `412A`, 2: `4189`, 3/4: `41CA` | Yes -> 9 if a password is stored (SRAM1:A880 !=0) else 5; mode 4 shows the mail count; modes 1/2 never used |
| 5 | "パスワードをにゅうりょくしてください" (`56:4047`) | `4237` | A -> 6 |
| 6 | same screen + on-screen keyboard (`55:5C8F`, raster split via the `00:16DC` STAT handler) | `426B` | 8 chars max, validation `4-8` chars with digit+letter |
| 7 | "パスワードをほぞんします" + attention text (`56:406A`) [する][しない] | `43BC` | する -> 8 |
| 8 | "パスワードをほぞんしました" (`56:40BF`) | `4421` | entering stores to SRAM (`SavedPassword_Store`) |
| 9 | "パスワードがほぞんされています" (`56:410A`), Select: パスワードのほぞんをやめる | `4443` | entering loads it (xor `$5A`); A accepts |
| 10 | "パスワードの ほぞんをやめます。よろしいですか?" (`56:4159`) | `4481` | leaving to any mode but 9 clears the stored password |
| `$10` | - | - | accept |

Screenshots: `mail_send_f02696_send_receive_2` (mode 3/4 confirm), `mail_send_f02801_password_saved` (mode 9), coverage frames 2096/2696/2801.

### 1.7 Font validity bitmap and no-adapter screen (bank 63)

`Font_ValidateSjisCode` is called by the double-byte glyph routine (`00:1044` -> `7F:405F`) with HL = Shift-JIS code; the 8 KiB
bitmap at `63:407A` has 7332 bits set (lead bytes 81-84, 87-9F, E0-EA; trail 40-7E/80-FC) and an invalid code becomes `$81A1` ("■").
`NoAdapter_ShowScreen` is the screen of scenario `noadapter` ("モバイルアダプタGBがささっていません / でんげんスイッチをOFFにして ... もういちど
ONにしてください"), it waits for A/Start and `Startup_NoAdapterScreen` then soft-resets.


## 2. Named symbols by subsystem

Full evidence per row: `config/symbols/bank<NN>.tsv`.  Status C = CONFIRMED, P = PROBABLE, H = HYPOTHESIS.

### Bank 65 (startup, registration wizard, notice pages)

**Startup (boot paths)**

| addr | name | | summary |
|---|---|---|---|
| `4000` | `Startup_Run` | C | First program run by the main loop (1C:4000 far-calls it once): inits (00:1711, 4E:4658, 48:4AAB, 68:4A0F), clears comm timers C2D1-C2D7, runs Adap... |
| `403C` | `Startup_StatusJumpTable` | C | 3 code pointers 4042/4078/40CF indexed by the AdapterCheck_Run result (0 no adapter or error, 1 adapter config valid, 2 config invalid/blank); read... |
| `4042` | `Startup_NoAdapter` | C | AdapterCheck result 0: 68:4870 classifies the SRAM state (0-4) and jumps through Startup_NoAdapterJumpTable (0,2,3 -> no-adapter screen 4063; 1 ->... |
| `4063` | `Startup_NoAdapterScreen` | C | far-calls NoAdapter_ShowScreen (63:732F), then A=$11 and jp Entry (00:0100 soft reset); noadapter scenario f68 |
| `406E` | `Startup_NoAdapterJumpTable` | P | 5 code pointers 4063,4058,4063,4063,4055 indexed by the SRAM state class returned by 68:4870; first word read in traces |
| `4078` | `Startup_ConfigValid` | C | AdapterCheck result 1 (adapter configuration valid): 68:4870 state -> Startup_ConfigValidJumpTable; executed in 32 scenarios at frame 324 after the... |
| `408B` | `Startup_ConfigValid_Continue` | P | state 4 of the valid-config table: jp 416C (verify save data, then return to the main program) |
| `408E` | `Startup_ConfigValid_ShowInfoError` | P | state 1: error screen F0/01/10 (5C) then start registration path; not executed |
| `40A6` | `Startup_ConfigValid_Fresh` | P | state 0: C277=C278=0 then Registration_Run and return; not executed (adapter valid but cartridge never registered) |
| `40B3` | `Startup_ConfigValid_Resume` | P | state 2: Registration_ReadStage then Registration_Run (resume) and return; not executed |
| `40BC` | `Startup_ConfigValid_ResumeCopy` | P | state 3: identical to 40B3; not executed |
| `40C5` | `Startup_ConfigValidJumpTable` | P | 5 code pointers 40A6,408E,40B3,40BC,408B indexed by 68:4870; last word read in traces |
| `40CF` | `Startup_ConfigBlank` | C | AdapterCheck result 2 (config invalid/blank): 68:4870 state -> Startup_ConfigBlankJumpTable; executed in register*, monkey_blank, resume_registrati... |
| `40E2` | `Startup_ConfigBlank_ShowInfoError` | C | states 1 and 4: error F0/01/00 (adapter registration info error, data initialized) via 5C:5150, then C277=C278=0 and Registration_Run; executed in... |
| `40FA` | `Startup_ConfigBlank_Fresh` | C | state 0: C277=C278=0, Registration_Run, return; the normal first-run path of the register scenarios (8 scenarios) |
| `4107` | `Startup_ConfigBlank_Resume` | C | state 2: Registration_ReadStage then Registration_Run (resume); executed in monkey_camp_blank, boot_states |
| `4110` | `Startup_ConfigBlank_ResumeCopy` | C | state 3: identical to 4107; executed once |
| `4119` | `Startup_ConfigBlankJumpTable` | P | 5 code pointers 40FA,40E2,4107,4110,40E2 indexed by 68:4870 |
| `416C` | `Startup_VerifySaveData` | C | checks the three SRAM areas (22:4FF6, 48:4899, 4E:46CF); any failure -> 418A; otherwise falls to the return; executed in 32 scenarios |
| `418A` | `Startup_SaveDataError` | C | error F0/01/11 ('cartridge save data error, data will be initialized') via 5C:5150, then reinitialises the areas (22:4FA9, 48:4920, 4E:4749); execu... |
| `41A9` | `Startup_Return` | C | common ret of the startup paths (back to the main program in 1C:4000) |

**Registration wizard**

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

**Notice pages**

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

**Notice page texts**

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

**Prompt texts**

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

**Adapter check**

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

**Settings: phone number change (hidden entry)**

| addr | name | | summary |
|---|---|---|---|
| `4000` | `SettingsPhone_Run` | C | Hidden settings entry 5 (電話番号の変更, 7C:7D5D state 5): read adapter config (53DC), choice menu, slot menu, number keypads + comment keyboard, confirm... |
| `4156` | `SettingsPhone_ResetTopCursor` | C | writes 0 to SRAM1:BF02 (remembered cursor of the top choice menu, saved by SettingsPhone_ChoiceMenu a=0) with SRAM enable/bank saved and restored |
| `418E` | `SettingsPhone_ResetSlotCursor` | C | writes 0 to SRAM1:BF03 (remembered cursor of the slot menu, saved by SettingsPhone_SlotMenu) |
| `41C6` | `SettingsPhone_ResetMethodCursor` | C | writes 0 to SRAM1:BF04 (remembered cursor of the input-method choice menu, saved by SettingsPhone_ChoiceMenu a=1) |
| `41FE` | `SettingsPhone_ClearEntryBuffers` | P | WRAM bank 3: zero-fills the $33 bytes DEDD.. (internet number, self-page number, comment: 3x17 bytes) and clears bits 3 and 5 of C278; also called... |
| `422B` | `PhoneKeypad_Run` | C | A=0 internet phone number, 1 self-page number: numeric keypad screen editing a TextBuf at DE80 (17 slots), result copied to DEDD/DEEE; returns C27C... |
| `424A` | `Function_67_424A` | H | unreferenced: decodes SRAM1:B08B/B09C (xor $A5) and compares with DEDD/DEEE, clearing bit3/bit4 of C278 when they differ (idea: 'phone number chang... |
| `431F` | `PhoneKeypad_Setup` | C | sets up the keypad screen: TextBuf_Init(DE80,$11), loads the current number from DEDD/DEEE (68:4127), tiles from banks 5E/4A, tilemap 4A:7120/71E8,... |
| `443C` | `PhoneKeypad_Loop` | C | polls the keyboard (55:5C8F, C=[C27E]): 1 append digit (TextBuf_AppendChar, sfx $38; $31 if full), 2 delete (sfx $39; cancels if empty), 7 accept i... |
| `4559` | `PhoneKeypad_StoreResult` | C | copies the TextBuf text at DE80 into DEDD (C27D=0) or DEEE (C27D=1) with 68:417F |
| `4571` | `Function_67_4571` | H | unreferenced: C27E := 1 when bit3 (C27D=0) or bit4 (C27D=1) of C278 is set, else 0; idea: 'number field is set' flag for the keypad |
| `4593` | `PhoneKeypad_UpdateFullFlag` | P | C27E := 1 when TextBuf_GetFree(DE80) is 0 (buffer full) else 0; argument C of the keyboard poll |
| `45AB` | `PhoneKeypad_UpdateNonEmptyFlag` | P | C27E := 1 when TextBuf_GetLength(DE80)>=1 else 0 |
| `45C4` | `PhoneKeypad_BuildTextMap` | P | 4F:45C6 with HL=D044, DE=0, BC=$020C: writes ascending tile numbers for the 2x12 text field into the tile map buffer |
| `45D4` | `PhoneKeypad_PrintText` | P | clears the 2x12 text field (4F:4604 DE=$FFFF), sets the text engine box (x=$20,y=$15) and prints the NUL-terminated string at HL (WRAM bank 3, DE83... |
| `4621` | `PhoneKeypad_UploadTextTiles` | P | 4F:4572: uploads the rendered 2x12 text tiles to VRAM $9000 |
| `4631` | `SettingsPhone_ChoiceMenu` | C | A=0: menu 電話番号変更内容選択 (change phone number / select the normally used number); A=1: menu 電話番号入力方法選択 (auto / manual). Returns C27C: 0 = B, n = choice... |
| `4688` | `SettingsPhone_ChoiceMenu_Setup` | C | restores the cursor from SRAM1:BF02/BF04, loads tiles/tilemap of bank 4D for the variant in C27E, prompt text, cursor sprite |
| `47DC` | `SettingsPhone_ChoiceMenu_Loop` | C | frame loop: A -> C27C=cursor+1 (sfx $2C), B -> 0 (sfx $2E), up/down toggles the cursor (sfx $29) and redraws |
| `4855` | `SettingsPhone_ChoiceMenu_PlaceCursor` | C | cursor sprite slot DA00 := SettingsPhone_ChoiceMenu_CursorPos[C27D] (00:0A65) |
| `486D` | `SettingsPhone_ChoiceMenu_CursorPos` | P | 2 (X,Y) pairs of the cursor sprite for the two choices ($10,$17 / $10,$2F) |
| `4871` | `SettingsPhone_ChoiceMenu_BuildTextMap` | P | 4F:45C6: tile numbers of the 6x18 prompt area (HL=D121) |
| `4881` | `SettingsPhone_ChoiceMenu_PrintPrompt` | C | clears the prompt box and prints PromptText 8 ('select from the menu', C27E=0) or 9 ('choose the phone number entry method', C27E=1) copied by 00:153D |
| `48E0` | `SettingsPhone_ChoiceMenu_UploadTextTiles` | P | 4F:4572: uploads the prompt text tiles to VRAM $9000 |
| `48F0` | `SettingsPhone_ChoiceMenu_LoadTilemap` | C | copies the 14x5 selection tilemap (bank 4D, pointer from SettingsPhone_ChoiceMenu_TilemapTable[2*C27E + C27D]) to D063 with 00:08EA |
| `491C` | `SettingsPhone_ChoiceMenu_TilemapTable` | P | 4 pointers ($5AE0,$5B6C,$5BF8,$5C84) into bank 4D: the four 14x5 highlighted-choice tilemaps; kept numeric |
| `4924` | `PhoneComment_KeyboardRun` | C | text keyboard for the comment field (max 16 chars, TextBuf at DE80 size $11), result in DEFF; callers 67:40F4 and 65:4563. Executed in settings_pho... |
| `4940` | `Function_67_4940` | H | unreferenced sibling of 424A: decodes SRAM1:B0AD and compares with DEFF, clearing bit5 of C278 when different |
| `49A8` | `PhoneComment_KeyboardSetup` | P | sets up the comment keyboard screen: TextBuf_Init(DE80,$11), current comment DEFF, tilemap 4A:72B0, keyboard mode 3 (55:5BA2) |
| `4A98` | `PhoneComment_KeyboardLoop` | P | same polling loop as PhoneKeypad_Loop for the comment keyboard (55:5C8F with C=[C27D]) |
| `4BB5` | `PhoneComment_StoreResult` | P | copies the TextBuf text at DE80 into DEFF (68:417F) |
| `4BC2` | `Function_67_4BC2` | H | unreferenced: C27D := 1 when bit5 of C278 is set, else 0 (comment keyboard flag) |
| `4BD5` | `PhoneComment_UpdateFullFlag` | P | C27D := 1 when the TextBuf at DE80 has no free slot (argument C of the keyboard poll), else 0 |
| `4BED` | `PhoneComment_UpdateNonEmptyFlag` | P | C27D := 1 when the TextBuf at DE80 holds >=1 char, else 0 |
| `4C06` | `PhoneComment_BuildTextMap` | P | 4F:45C6 (HL=D044, BC=$020C): tile numbers of the text field |
| `4C16` | `PhoneComment_PrintText` | P | clears the text field and prints the TextBuf string at HL with 00:0ED3 (box x=$20,y=$15) |
| `4C63` | `PhoneComment_UploadTextTiles` | P | 4F:4572: uploads the text tiles to VRAM $9000 |
| `4C73` | `SettingsPhone_SlotMenu` | C | A=0: 変更用電話番号選択 (slot to change), A=1: 通常使用電話番号選択 (default slot): 3 tabs 登録場所1-3 showing internet number / self-page number / comment (DF10..); curs... |
| `4CCB` | `SettingsPhone_SlotMenu_Setup` | C | restores the cursor from SRAM1:BF03, loads bank-4D tiles for the variant, tilemap 4D:75A0, slot field texts, cursor sprite |
| `4E20` | `SettingsPhone_SlotMenu_Loop` | C | frame loop: A picks the slot (checks via 68:4568 that it holds data in variant 1), B cancels, left/right cycles the tabs (sfx $29) |
| `4F50` | `SettingsPhone_SlotMenu_PlaceCursor` | C | sprite slot DA00 := SettingsPhone_SlotMenu_CursorPos[C27D] (00:0A65) |
| `4F68` | `SettingsPhone_SlotMenu_CursorPos` | P | 3 (X,Y) pairs of the tab cursor ($18,$2F / $47,$2F / $77,$2F) |
| `4F6E` | `SettingsPhone_SlotMenu_BuildTextMap` | P | 3x 4F:45C6: tile numbers of the three 2x12 field text rows (D127,D167,D1A6) |
| `4F9C` | `SettingsPhone_SlotMenu_PrintSlotFields` | C | prints the three fields (internet number, self-page number, comment) of the slot C27D from SettingsPhone_SlotMenu_FieldTable with 00:0ED3 |
| `50A5` | `SettingsPhone_SlotMenu_FieldTable` | P | 9 WRAM pointers: internet number DF10/DF43/DF76, self-page DF21/DF54/DF87, comment DF32/DF65/DF98 (3 slots x $33 bytes at DF10..) |
| `50B7` | `SettingsPhone_SlotMenu_UploadTextTiles` | P | 3x 4F:4572: uploads the three field text rows to VRAM $9000/$9200/$9400 |
| `50E5` | `SettingsPhone_SlotMenu_LoadTabTilemap` | C | copies the 20x2 tab tilemap of the selected slot (bank 4D, pointer from SettingsPhone_SlotMenu_TabTilemapTable[C27D]) to D0E0 |
| `5104` | `SettingsPhone_SlotMenu_TabTilemapTable` | P | 3 pointers ($7870,$78C0,$7910) into bank 4D (20x2 tilemaps of tab 1-3); kept numeric |
| `510A` | `SettingsPhone_ConfirmScreen` | C | C27E=slot: screen 次のように電話番号を変更します / よろしいですか？ [はい][いいえ] listing the new numbers (DEDD,DEEE,DEFF); returns C27C: 0 = B, 1 = yes, 2 = no. Executed in... |
| `5129` | `SettingsPhone_ConfirmScreen_Setup` | C | loads bank 4B/5F tiles and tilemap 4B:73F0, palettes, field texts, slot tab and cursor sprite |
| `51E2` | `SettingsPhone_ConfirmScreen_Loop` | C | frame loop: A -> C27C=1 (Yes) or 2 (No, cursor 1), B -> 0, left/right toggles Yes/No (sfx $29) |
| `525D` | `SettingsPhone_ConfirmScreen_PlaceCursor` | C | sprite slot DA00 := SettingsPhone_ConfirmScreen_CursorPos[C27D] |
| `5275` | `SettingsPhone_ConfirmScreen_CursorPos` | P | 2 (X,Y) pairs of the Yes/No cursor ($28,$68 / $58,$68) |
| `5279` | `SettingsPhone_ConfirmScreen_BuildTextMap` | P | 3x 4F:45C6: tile numbers of the three field rows (D0A7,D0E7,D126) |
| `52A7` | `SettingsPhone_ConfirmScreen_PrintFields` | C | prints DEDD (internet number), DEEE (self-page number) and DEFF (comment) into three text boxes with 00:0ED3 |
| `5389` | `SettingsPhone_ConfirmScreen_UploadTextTiles` | P | 3x 4F:4572: uploads the field text rows to VRAM $9000/$9200/$9400 |
| `53B7` | `SettingsPhone_ConfirmScreen_LoadSlotTilemap` | C | copies the 2x1 slot-number tilemap (bank 4B, pointer from SettingsPhone_ConfirmScreen_SlotTilemapTable[C27E]) to D066 |
| `53D6` | `SettingsPhone_ConfirmScreen_SlotTilemapTable` | P | 3 pointers ($76C0,$76C4,$76C8) into bank 4B (slot number 1/2/3 tiles); kept numeric |
| `53DC` | `SettingsPhone_ReadAdapterConfig` | C | checking screen + sound, then the API state machine: MobileAPI $02 init, $38 read $C0 config bytes to SRAM2:$A000, $36 reset, validation 68:459A/43... |
| `5402` | `SettingsPhone_ReadAdapterConfig_Setup` | C | C27C=C27D=0 and AdapterCheck_DrawScreen |
| `5410` | `SettingsPhone_ReadAdapterConfig_Poll` | C | per-frame poll (sprites, VBlank, sound $46 latch C286) then jp [Table_67_546C+2*C27D]: states init (5472), read config (5484), reset+validate (54B9... |
| `546C` | `SettingsPhone_ReadAdapterConfig_StateTable` | P | 3 state handlers 5472/5484/54B9 indexed by C27D |
| `5535` | `SettingsPhone_WriteAdapterConfig` | C | A=slot index (C27E): API sequence that writes the modified configuration image (PatchConfigImage, MobileAPI $04 write $C0 bytes from SRAM2:$A000) a... |
| `5554` | `SettingsPhone_WriteAdapterConfig_Setup` | C | C27C=C27D=0 |
| `555C` | `SettingsPhone_WriteAdapterConfig_Poll` | C | per-frame poll and jp [Table_67_55B8+2*C27D]: init (55BE), patch image + write (55D0, API $04), finish (560A, API $36, 68:49B6) |
| `55B8` | `SettingsPhone_WriteAdapterConfig_StateTable` | P | 3 state handlers 55BE/55D0/560A indexed by C27D |
| `5664` | `SettingsPhone_PatchConfigImage` | C | copies the edited number/comment of slot C27E into the adapter config image SRAM2:A000 (68:409A, CopyStringMax), stores the self-page number xor $A... |
| `56FA` | `SettingsPhone_ConfigNumberAddrs` | P | 3 addresses $A076,$A08E,$A0A6: number field of slot 0-2 in the adapter config image (stride $18) |
| `5700` | `SettingsPhone_SramSelfPageAddrs` | P | 3 addresses $B014,$B025,$B036 (SRAM bank 1 XOR-$A5 strings, stride $11) written by PatchConfigImage; same table as Table_00_161A |
| `5706` | `SettingsPhone_ConfigCommentAddrs` | P | 3 addresses $A07E,$A096,$A0AE: comment field (16 bytes) of slot 0-2 in the config image |
| `570C` | `SettingsPhone_ContinuePrompt` | C | screen 電話番号変更終了 / 続けて登録をしますか？ [はい][いいえ]; returns C27C: 1 yes (settings_phone restarts at 4000), else done. Executed in settings_phone f5155 |
| `5728` | `SettingsPhone_ContinuePrompt_Setup` | C | loads bank 4B/5F tiles and tilemap 4B:7D10, prints PromptText 10 (phone number change finished), cursor sprite |
| `57CC` | `SettingsPhone_ContinuePrompt_Loop` | C | frame loop: A -> Yes (1) / No (2), left/right toggles (sfx $29) |
| `5842` | `SettingsPhone_ContinuePrompt_PlaceCursor` | C | sprite slot DA00 := SettingsPhone_ContinuePrompt_CursorPos[C27D] |
| `585A` | `SettingsPhone_ContinuePrompt_CursorPos` | P | 2 (X,Y) pairs of the Yes/No cursor ($28,$30 / $58,$30) |
| `585E` | `SettingsPhone_ContinuePrompt_BuildTextMap` | P | 4F:45C6: tile numbers of the prompt area |
| `586E` | `SettingsPhone_ContinuePrompt_PrintPrompt` | C | clears the prompt box and prints PromptText 10 (00:153D A=10) |
| `58BD` | `SettingsPhone_ContinuePrompt_UploadTextTiles` | P | 4F:4572: uploads the prompt text tiles to VRAM $9000 |
| `5ED1` | `Function_67_5ED1` | H | unreferenced start of the 5ED1-5F54 routine: C27C=C27D=0, AdapterCheck_DrawScreen, fade in, poll 5EF1 (init API $02, reset API $36), fade out, retu... |
| `5EF1` | `Function_67_5EF1` | H | tiny 2-state poll (init API $02, then reset API $36) behind the unreferenced entry 5ED1/5ED8 (draws the checking screen); no caller found, idea: 'r... |

**Settings: password change / password prompt / save confirm**

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

**Settings: usage time / usage fee**

| addr | name | | summary |
|---|---|---|---|
| `60BA` | `UsageTime_Run` | C | Settings menu entry 2 (ご利用時間の確認, 7C:7D79): page $13 (explanation), UsageTime_Request, result screens (68:766E a=2) and page $14 (cancelled). Execut... |
| `6171` | `UsageTime_Request` | C | clears SRAM3:$A000.., copies the jikan CGI URL to $A100, login ID (00:1586) to C28F, 68:7401(2), HTTP request 4E:488D; returns A=1 ok, 0 error, 2 c... |
| `626F` | `UsageFee_Run` | C | Settings menu entry 3 (ご利用額の確認, 7C:7D82): page $15 (explanation), UsageFee_Request, result screens (68:766E a=3) and page $16 (cancelled). Executed... |
| `62D5` | `UsageFee_Request` | C | like UsageTime_Request but with the fee summary URL (Net_UsageFeeUrl, copied at 67:62F9; a GET per docs/research/dynamic_tracing.md), 68:7401(3), 4... |

**Network helpers (URLs, DNS, request bodies)**

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

**TextBuf library**

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

**Error screen code**

| addr | name | | summary |
|---|---|---|---|
| `4F53` | `CommErr_RecordTable` | C | 21 records [id, mode, dw triple list] ended by $FF, searched at 5C:527D against C196 (id = error category); mode 1 = normal 'comm error' screen, mo... |
| `5104` | `CommErr_MessagePointers` | P | 32 word pointers (index 0 null) to the message strings 4000-4DCF, indexed by the triple's message index at 5C:5320; indices 32-37 continue in 5144/... |
| `5146` | `CommErr_MessagePointers_Boot` | P | 5 word pointers = message indices 33-37 (4E21,4E51,4E96,4ED5,4F14) used by the boot-check record $F0 (list 50F5 selects indices $21-$25) |
| `5150` | `CommErr_ShowScreen` | C | Error screen: A=category (C196), H:L=code (C197:C198); wipes C0D4.., loads gfx/palettes, draws 'No.CC-DDD' and the message found by the tables, wai... |
| `5219` | `CommErr_ShowScreen_FrameLoop` | C | per-frame loop: sprites, VBlank wait, pad read (7D:7BA4/7BC1) and JoypadDispatch (A -> 524C, idle -> 523B) |
| `5231` | `CommErr_JoypadTable` | C | inline table of the call to JoypadDispatch at 5C:522E: A -> 524C, B/Select/Start -> 5264 (ignored), none -> 523B |
| `523B` | `CommErr_ShowScreen_Idle` | C | no new button: if C0D8!=0 run UpdateCommFooter (546F), then jp FrameLoop |
| `524C` | `CommErr_ShowScreen_ButtonA` | C | A pressed: sound effect $2C, fade out (4F:4370), return A=0 to the caller |
| `5267` | `CommErr_DrawMessage` | C | clears the text box, finds the record of C196 in CommErr_RecordTable, picks the tilemap (mode 1: plain or timer variant, else boot variant), finds... |
| `527D` | `CommErr_FindRecord` | C | loop over the 4-byte records of 4F53 comparing the id with C196; $FF terminator -> 53A1 (plain tilemap only) |
| `52AB` | `CommErr_DrawMessage_TimerVariant` | C | wTimerEnable bit4 set (communication timer running): tilemap 57E6 with the 'communicating' footer, animated icon object DA10 (table 642B), palette... |
| `52EF` | `CommErr_DrawMessage_PlainVariant` | C | records with mode !=1 (boot checks): tilemap 5AB6 (plain 'error No.' header) |
| `5302` | `CommErr_LookupTriple` | C | HL=triple list of the record; scans [d,e,msg] for d=C197,e=C198 (or the $FF,$FF default) and returns the message index at 531E |
| `531E` | `CommErr_PrintMessage` | C | message index -> pointer via CommErr_MessagePointers, sets the text engine box (x=8,y=$18, width $98) and prints with 00:0ED3, then uploads the tex... |
| `53B3` | `CommErr_DrawErrorNumber` | C | draws the digits of 'No.CC-DDD' from C196/C197/C198 into the tile map at D00C.. (2 tiles per digit) and uploads the row; C197's high nibble is draw... |
| `5441` | `CommErr_DrawDigit` | C | A=digit 0-9, HL=map position: writes the two tiles of the digit (CommErr_DigitTilePairs) to HL and HL+$20 |
| `545B` | `CommErr_DigitTilePairs` | P | 10 pairs (top,bottom) of tile numbers for the digits 0-9: $27/$37 .. $2F/$3F, $40/$50; read by 5C:5441 |
| `546F` | `CommErr_UpdateCommFooter` | P | per frame while C0D8!=0: comm timer stopped (wTimerEnable bit4 clear) -> swaps the 'communicating' footer for the plain rows (5656/57BE), hides obj... |
| `5504` | `CommErr_DrawFCategoryGlyph` | P | for category $F0 overwrites the first digit cells (D00C/D00D, D02C/D02D) with tiles $40,$41/$50,$51 (a 2x2 glyph instead of digits) |

**Message texts**

| addr | name | | summary |
|---|---|---|---|
| `4000` | `CommErr_Msg_AdapterNotPlugged` | C | message 1 of the error table (Shift-JIS, NUL-terminated): Mobile Adapter is not plugged in correctly; read the manual and plug it in firmly |
| `4069` | `CommErr_Msg_DialFailedOrBusy` | C | message 2 of the error table (Shift-JIS, NUL-terminated): phone could not dial or the line is busy, cannot communicate; wait and retry |
| `40FD` | `CommErr_Msg_LineBusy` | C | message 3 of the error table (Shift-JIS, NUL-terminated): line is busy, cannot communicate; wait and retry |
| `4146` | `CommErr_Msg_AdapterError` | C | message 4 of the error table (Shift-JIS, NUL-terminated): Mobile Adapter error; wait and retry, otherwise consult the manual / Mobile Support Center |
| `41E3` | `CommErr_Msg_GenericCommError` | C | message 5 of the error table (Shift-JIS, NUL-terminated): generic communication error; wait and retry, otherwise Mobile Support Center |
| `427A` | `CommErr_Msg_BadPasswordOrLoginId` | C | message 6 of the error table (Shift-JIS, NUL-terminated): password or login ID is wrong; check the password and retry later |
| `4315` | `CommErr_Msg_Disconnected` | C | message 7 of the error table (Shift-JIS, NUL-terminated): the connection was cut; see the manual and retry later |
| `436B` | `CommErr_Msg_ServerCommError` | C | message 8 of the error table (Shift-JIS, NUL-terminated): server-side communication error; wait and reconnect |
| `43CD` | `CommErr_Msg_AdapterRegistrationInvalid` | C | message 9 of the error table (Shift-JIS, NUL-terminated): info registered in the Mobile Adapter is wrong; do the initial registration with the Mobi... |
| `442F` | `CommErr_Msg_ServerBusy` | C | message 10 of the error table (Shift-JIS, NUL-terminated): server is busy, cannot connect; wait and reconnect |
| `44AA` | `CommErr_Msg_BadDestinationAddress` | C | message 11 of the error table (Shift-JIS, NUL-terminated): destination mail address is wrong; enter a correct mail address |
| `44FE` | `CommErr_Msg_BadOwnMailAddress` | C | message 12 of the error table (Shift-JIS, NUL-terminated): own mail address is wrong; register again with the Mobile Trainer |
| `4575` | `CommErr_Msg_BadPasswordOrServerError` | C | message 13 of the error table (Shift-JIS, NUL-terminated): entered password is wrong or server error; check the password, retry later |
| `45F7` | `CommErr_Msg_ContentDownloadRetry` | C | message 14 of the error table (Shift-JIS, NUL-terminated): content download not possible; wait and retry, otherwise Support Center |
| `469A` | `CommErr_Msg_Timeout` | C | message 15 of the error table (Shift-JIS, NUL-terminated): connection cut by timeout; communicate again |
| `46FE` | `CommErr_Msg_FeePaymentOverdue` | C | message 16 of the error table (Shift-JIS, NUL-terminated): if payment of the usage fee is late the service becomes unusable |
| `4767` | `CommErr_Msg_UnavailableCustomerReason` | C | message 17 of the error table (Shift-JIS, NUL-terminated): cannot be used because of the customer's circumstances |
| `47B2` | `CommErr_Msg_LineBusyOrServerError` | C | message 18 of the error table (Shift-JIS, NUL-terminated): line busy or server error, cannot communicate; wait and retry |
| `4838` | `CommErr_Msg_FeeLimitExceeded` | C | message 19 of the error table (Shift-JIS, NUL-terminated): usage fee exceeds the upper limit, unusable this month |
| `489A` | `CommErr_Msg_Maintenance` | C | message 20 of the error table (Shift-JIS, NUL-terminated): service under maintenance; call again later |
| `490B` | `CommErr_Msg_ContentDownloadFailed` | C | message 21 of the error table (Shift-JIS, NUL-terminated): content download not possible; see the manual |
| `4956` | `CommErr_Msg_BadLoginId` | C | message 22 of the error table (Shift-JIS, NUL-terminated): login ID is wrong; register the login ID again |
| `49B6` | `CommErr_Msg_LoginIdSuspended` | C | message 23 of the error table (Shift-JIS, NUL-terminated): this login ID has a suspension procedure on file, unusable; contact the DDI customer ser... |
| `4A51` | `CommErr_Msg_LoginIdCancelled` | C | message 24 of the error table (Shift-JIS, NUL-terminated): this login ID was cancelled, unusable; contact the DDI customer service center |
| `4AD9` | `CommErr_Msg_LoginIdUnavailable` | C | message 25 of the error table (Shift-JIS, NUL-terminated): this login ID is currently unusable; contact the DDI customer service center |
| `4B52` | `CommErr_Msg_NewPasswordEmpty` | C | message 26 of the error table (Shift-JIS, NUL-terminated): no new password entered; enter 4-8 characters mixing letters and digits |
| `4BC5` | `CommErr_Msg_NewPasswordLength` | C | message 27 of the error table (Shift-JIS, NUL-terminated): new password is too long or too short (4-8 characters) |
| `4C38` | `CommErr_Msg_NewPasswordBadChars` | C | message 28 of the error table (Shift-JIS, NUL-terminated): new password contains unusable characters |
| `4CB3` | `CommErr_Msg_NewPasswordNeedsMix` | C | message 29 of the error table (Shift-JIS, NUL-terminated): new password is letters only or digits only |
| `4D3F` | `CommErr_Msg_NewPasswordSameAsOld` | C | message 30 of the error table (Shift-JIS, NUL-terminated): new password is the same as the old one; choose another |
| `4DCF` | `CommErr_Msg_RegistrationPending` | C | message 31 of the error table (Shift-JIS, NUL-terminated): registration form processing seems unfinished; wait until it completes |
| `4E21` | `CommErr_Boot_AdapterNotPlugged` | C | message 33 of the error table (Shift-JIS, NUL-terminated): boot check: Mobile Adapter is not plugged in correctly |
| `4E51` | `CommErr_Boot_WrongPassword` | C | message 34 of the error table (Shift-JIS, NUL-terminated): boot check: password is wrong; enter the correct password |
| `4E96` | `CommErr_Boot_AdapterConfigError` | C | message 35 of the error table (Shift-JIS, NUL-terminated): boot check: adapter registration info error, data will be initialized |
| `4ED5` | `CommErr_Boot_SaveDataErrorA` | C | message 36 of the error table (Shift-JIS, NUL-terminated): boot check: cartridge save data error, data will be initialized (record F0/01/10) |
| `4F14` | `CommErr_Boot_SaveDataErrorB` | C | message 37 of the error table (Shift-JIS, NUL-terminated): boot check: cartridge save data error, data will be initialized (record F0/01/11; same t... |

**Tables, tilemaps, graphics**

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

## 3. Classification corrections found on the way (for the orchestrator; `config/regions` was not touched)

| where | current class | finding | evidence |
|---|---|---|---|
| `63:407A-607A` | `gfx` "199 coherent tiles" | an **8192-byte bitmap** indexed by a 16-bit Shift-JIS code (`Font_SjisValidBitmap`), 937 non-zero bytes / 7332 bits, only lead bytes 81-84, 87-9F, E0-EA with trail 40-7E/80-FC; `607A-6080` are 6 zero pad bytes | `63:4000` reads `[407A + HL>>3]`, bit `L&7` |
| `63:6FC0-7290` | tilemap starts in the middle of `6CC0-70C0` `gfx` | the `$9400` HDMA loads `$400` bytes from `6CC0` that overlap the first `$100` bytes of the tilemap (`63:73DB ld hl,$6FC0`); likewise the `$8800` block `60C0-64C0` overlaps the `$8000` block `6080-6480` | `63:7342` loads |
| `5C:6350-6410` | `gfx` "40 coherent tiles" | **three 64-byte RGB555 palettes** at `6350` (BG, comm-timer variant), `6390` (BG), `63D0` (OBJ), copied to the staging buffers `D800/D840` with `4F:4000` (`bc=$40`) | `5C:52E1`, `5C:51DB/51EC` |
| `5C:6410-642F` | tail of that `gfx` + `data` "content class unknown" | one object animation record (frame table words `6414/6425`, frames, script `6426`), entry `642B = {6410, 6426}` given to `00:0A82` | `5C:52C7` |
| `67:5E43`, `5E77`, `5EB4`, `61D2`, `6246`, `632D` | `data` "content class unknown" | ASCII strings: CGI/URL strings, `guest`, `PPP_ID=` | read by `CopyString`/`00:14F3` in the CONFIRMED flows |
| `65:4BC6-4BDE`, `4BDE-4C6E` | `data` | 24-byte per-page sound table + 24 six-byte page records (the region split at `4BE2` cuts record 0) | `65:4BA8`, `65:487C` |
| `65:4A81-4AD7` | `data` "repeating groups of a flag byte + 16-bit address" | 24 far pointers `[addr16 LE, bank]` (bytes 0-1 address, byte 2 bank: 58, 4B, 71) + a 7-word table at `4AC9` | `65:4A37` reads `l,h,bank` |

Dead code with stale targets (kept HYPOTHESIS): `65:481A` (`call $21A0` into ROM0 padding), `65:41AA`, `65:46FF/471F`, `67:424A`, `4571`, `4940`,
`4BC2`, `67DB`, `5ED1`.

### 3.1 Cross-checks with the other namers (files present when this pass finished)

* `config/symbols/bank7C.tsv` (`Nav_MobileSettings_*`) maps the settings entries 1-5 to `67:58CD`, `67:60BA`, `67:626F`, `68:7951`, `67:4000`, the same
  mapping used here; `bank27.tsv` (`MailSendRecv_Main`) calls `57:4000` with the request template `04 00 00 01 24 D5 04` of the connect dialog.
* `analysis/naming/ram_g2.tsv` / `ram_g7.tsv` propose names with the same semantics for the same addresses (`C272-C274` mobile error code/info,
  `C277` registration progress, `C27A` save-password flag, `C28C` hidden-mode flag, `DE80` edit buffer, `DEDD/DEEE/DEFF/DF10` phone numbers and dial
  entries, `B010` registration progress); `ram_g6.tsv` lists them with the extra evidence of these banks and the other names in the evidence column, the
  orchestrator should keep one name per address (the broader name of the bank-68 pass is better for `C28C`).
* `bank74.tsv` has `HtmlUrl_Resolve`/`HtmlUrl_NormalizePath` for the browser (this pass first met the names `Url_Resolve`/`Url_NormalizePath` there); bank 67 contains a second, smaller implementation for HTTP redirects, named
  `HttpRedirect_*` to avoid the collision.

## 4. Hypotheses and open questions

1. **`57:4237`/`43BC` transitions.** (Review fix: in modes 5 and 9, B returns to the caller's initial mode `arg[0]` when it is >= 3, otherwise to mode 2; the first version of the rows had the condition reversed.) In mode 7 ("save password? する/しない") `しない`/B goes back to the keyboard (mode 6) according to the code; the exit
   without saving seems to be keyboard result 7 (`$07 -> $10`), whose key is unknown (`55:5C8F` result codes 7/8/9/`$0A` are only named by their
   effect).  The modes 1 and 2 (`412A`, `4189`) are dead code (no caller starts there).
2. **`Function_67_5CF4`** loops on `68:7413(A=1)` until 0 after every transaction. Reviewed: `68:7413` is the bank-68 `CommPanel_Step` (`C289=A`, one state of the
   communication panel, returns `C28A`: 0 finished, 2 cancelled), so this is "step the communication panel to its end", not an SDK-idle wait as first guessed
   (HYPOTHESIS row kept under the generic name; what `A=1` selects is unknown).
3. **Meaning of `68:4870` classes** (0-4) and of the SRAM bytes `B010`/`B0BE`: the startup jump tables are named by role only (`Startup_NoAdapter`,
   `_ConfigValid`, `_ConfigBlank`); which class corresponds to "never registered" versus "registered by another cartridge" is not proven.  Reviewed: the
   bank-68 namer (`Settings_GetRegistrationProgress`, `68:4870`) reads the classes as 0 blank/no progress, 1 damaged page, 2/3/4 = SRAM `B010` 1/2/3
   (started / fields entered / complete); this fits the roles used here (state 4 = complete = "continue offline") but is still only PROBABLE there.
4. **`HttpRedirect_ResolveUrl` (`67:5F66`)** is static-only PROBABLE: the source pointer `C275/C276` is never written in bank 67; the writer is `68:4F71`, which stores the
   `BC` result of `MobileAPI $00` into `C275/C276` (with `C272` = A, `C273` = L, `C274` = H) and is called at `67:5D26` right before the status test, so the
   pointer is what the SDK reports for the failed request; it is used for HTTP 301/302 redirects (`PasswordChange_HandleHttpStatus`), no scenario produced a redirect for the settings flows.
5. **The register `C27A`** (save the password?) is also written to SRAM1 `B088` by `68:4B48`; the exact SRAM meaning of `B088/B089/B08A` (save flag /
   hidden variant / phone method) is proposed only through the RAM names of the WRAM sources.
6. **`ConnectDialog_RenderTypedChars`** (`57:5444`): the meaning of the 2 bytes per character returned by `55:6CC6` is not resolved; `bc=8` is the number of
   characters of the field (8 glyph cells x 2 tiles = the 16 blocks uploaded to `$9701`).
7. **`SavedPassword_Store` bug**: `57:541C` with `A=0` jumps to `5437` and executes `pop bc` without the matching `push af` (stack imbalance); callers
   always pass 1-8 (`Registration_SavePassword` uses `StringLength`, the dialog only stores after validation), so it is latent.
8. **Sound requests**: `00:20AC` / `00:20E8` / `00:20C4` are bank-4 stubs whose exact role (sound effect vs BGM) is not established; the names used
   here (`..._RequestPageSound`, `..._PlayButtonSfx`) avoid claiming more than "request with id in BC".
9. **`C27C/C27D/C27E`** are the screen frame variables of bank 67 (result, cursor/state, variant) but bank 65/68 reuse them differently: no RAM proposal.
10. The mode-2 boot record `$F0` of the error table has 5 triples without `$FF` terminator; `5C:5144` (`$0020`, slot 32 of the message index space) is
    not selected by any list (kept as generic data).

## 5. Verification performed

* `python3 tools/gen_asm.py verify --config <copy of config with the 5 files>` -> `RESULT: IDENTICAL` (names never change bytes); `check --strict` OK;
  name uniqueness against `config/ram`, `config/symbols` and the region labels was checked with a script (0 collisions except the intended generic aliases).
* Frames and scenarios quoted in evidence come from `traces/coverage_*.tsv` (first frame per address) and the screenshot file names; the rendered
  screens were produced from the ROM bytes with the tile/tilemap loads of the code.
* Every string label was placed on the pointer targets of the pointer tables (`5C:5104/5146`, `65:4BDE` page records, `65:567F`), and the Shift-JIS text
  decoded with cp932 (translations are mine).

## 6. Adversarial review (verifier pass)

A second pass re-derived the claims from the ROM bytes (`tools/sm83.py` listings), `analysis/coverage_union.tsv` and `traces/coverage_*.tsv`, the
screenshots and `analysis/farcall_targets.tsv`.  About 45 rows were re-read in full (all of the `57` dialog input/entry/leave handlers,
`57:5369/541C`, the `5C` tables, messages and error-number drawing, `63:4000/732F`, the bank-65 startup/wizard/notice code and tables, and in bank 67 the
adapter check, TextBuf, password-change, HTTP status/redirect/URL code, the phone-number screens and the password-save confirm).  Mechanical checks
over all 407 rows: identifiers legal and unique across `config/ram`, `config/symbols` and region labels (the only repeats are the intended generic
aliases), no tab/newline and <= 240 characters in any evidence cell, HYPOTHESIS rows keep generic names, every CONFIRMED function/label has executed
instructions in the coverage files, and every scenario name/frame quoted in an evidence cell matches the coverage or screenshot data.  All CommErr
message translations, all 24 notice texts and 20 prompts, the notice page table, the header/footer graphics tables, the URL/CGI strings and the DNS pair
were re-decoded from the ROM and agree.  No name was refuted; no status was downgraded.  Corrections:

| row / file | problem found | fix |
|---|---|---|
| `57:4237`, `57:4443` | the B-button target was described as "initial mode if arg[0]<3, else 2"; the code (`cp 3 / jr nc`) keeps `arg[0]` when it is >= 3 and uses mode 2 otherwise | text corrected |
| `57:541C` | "0 skips chars" was wrong: `A=0` takes `jr z,5437` and pops a value that was never pushed | text says A=0 unbalances the stack |
| `57:546C`, `57:5369` | execution counts (6 scenarios, 242x) did not match the coverage (20 scenarios; 1019x in 4 monkey campaigns) | counts corrected |
| `63:4072` | "reached once (noadapter)": the only execution is `browser_pages` f38342 | scenario corrected |
| `67:6369`, `67:64AE`, `65:403C` | "18/18 scenarios" / "up to 12": the boot check runs in all 41 scenarios | counts corrected |
| `67:5FB5` | relative URLs are appended at the END of the base (a `/` inserted when missing), not after its last `/` | text corrected |
| `67:5F66` | `C275/C276` writer not known; cross-reference named `Url_Resolve` | writer `68:4F71` recorded, reference changed to `HtmlUrl_Resolve` |
| `67:5CF4`, `5CC2`, `5D99`, `5DFE` | the "SDK idle wait" guess is wrong: the callee `68:7413` is `CommPanel_Step` | evidence rewritten, row stays HYPOTHESIS/generic |
| `67:6257` | `Net_DebugLoginBody` rested on a single clue | second clue added (`itoh` = login id of the developer test image `68:4EA7`), stays PROBABLE |
| `5C:500B/503E/5080` | "DION server codes", "mail account codes" were guesses | replaced by what the data shows (SMTP reply-code shaped codes, the message indices) |
| `ram_g6.tsv` `C1BA` | size 16 ends one byte short (the terminator at +16 is written at `57:42FF`) | size 17 |
| `ram_g6.tsv` `C277` | wrong address `65:4234` for the `C277 == 2` test | `65:427D` |
| `ram_g6.tsv` `C28C` | `wRegHiddenPhoneStep` is narrower than the use (also the hidden mode of the settings menu, see g7) | renamed `wHiddenModeFlag` (same as g7) |
| `ram_g6.tsv` `DEEE` | the buffer is also the login-ID scratch of `67:5B27` | note added; name kept for the phone flows |

