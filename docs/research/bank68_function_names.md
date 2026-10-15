# Bank 68: existing function names, alias retirement and unresolved contracts

## 1. Scope and confidence

This 2026-10-15 pass retires 54 inactive `Function_68_*` definitions across twelve maintained source
files. It corrects one overclaimed proper name at `4377`, preserves all instructions, operands,
local-label spellings, physical source rows and existing evidence comments except the specific
validity-check correction below, and introduces no new function entry.

This is a nominal/contract cohort, not a declaration that the original ROM is fully understood.
The snapshot had 39 CONFIRMED adjacent entry tags, nine HYPOTHESIS tags, one PROBABLE tag and five
entries with no adjacent tag. Those counts describe comments, not universal semantic proof.
All 54 have individual existing naming evidence; descriptive aliases alone were not used as proof.

Entry, mechanism and intended purpose are separate. In particular, the eight unproved sibling
entries keep HYPOTHESIS, the return-only entry at `5D2F` keeps unknown purpose, and operation names
can remain PROBABLE without implying a natural caller. Historical coverage counts may span later
labels and never define an entire function's reachable size or every branch's confidence.

The following five null-tag cases are not missing names/evidence:

| Address | Retained name | Existing evidence |
|---|---|---|
| `4101` | Comm_ClearSessionActive | PROBABLE zeroing operation; state role inferred from writers |
| `4282` | Stub_Nop_68_4282 | CONFIRMED single RET, called before password change |
| `4495` | Dial_SkipStringThenSetSelectedEntry | PROBABLE NUL scan plus persistent fall-through setter |
| `6762` | Account_ConfirmManualScreen_UploadTextTiles | PROBABLE five-rectangle upload role, recorded execution |
| `73DD` | Screen_FadeOutAndResetObjWindow | PROBABLE fade/sprite/OBJ-size/window mechanics |

The maintained-source census found zero active operands or qualified local references using the
54 retired aliases. Removing them changes the linked namespace of 50 local labels, listed below;
local branches retain their spelling and target positions. The one corrected proper name also
has no active operands. Frozen naming/mapper/config tables remain historical records and are not
rewritten by this pass.

## 2. Dated correction: decoded progress predicate at 68:4377

`Settings_IsRegistrationStarted` overstated the evidence. The independent verifier had already
lowered that name to HYPOTHESIS: only `[SRAM1:$B010] xor $A5 != 0` was shown, without an independent
entry or demonstrated intended caller. The retained proper name is now
**`Settings_IsDecodedProgressNonzero`**. Its operation is PROBABLE; entry and intended purpose stay
HYPOTHESIS. The historical alias/name map below preserves the correction's origin.

The field name is not invented: `ram/banked.asm` defines `sSettingsRegistrationProgress=$B010`
in SRAM bank 1 as CONFIRMED, with observed stores of decoded 1/2/3 and readers that handle the
marker. This helper's predicate differs from the normalized reader policy:

- It enables SRAM and selects **bank 1**, reads raw byte B010, computes decoded=raw xor A5, and
  returns A=1 for any nonzero decoded byte, including invalid values; otherwise A=0. A raw stored
  A5 is itself nonzero but decodes to zero and returns zero. No magic, checksum or range check
  occurs. This does not prove that registration has started or that a settings page is valid.
- B/C/DE/HL are untouched in the displayed routine. Both exits finish with F=$80; therefore Z is
  set even when A=1. A is the predicate result; flags are not a Boolean-return interface.
- One PUSH AF saves the incoming SRAM-bank shadow. The selected bank is restored from that saved
  shadow, but both exits explicitly set hSRAMEnable and RAMG to zero. They do not restore an
  arbitrary prior enable value. hScratchA retains the decoded byte, not the final Boolean result.
- With a valid non-overlapping stack and normal helper-free completion, RET reads word[S] and
  leaves SP=S+2; the local PUSH uses two additional bytes. Physical restoration requires coherent
  initial shadows and no interfering stack/scratch/mapper changes.

The earlier source phrase "SRAM validity check" is corrected in place to "decoded nonzero test".
This note preserves the old claim and why it changed; no instruction, caller or runtime result
was added to make the narrower name true.

## 3. Per-function contracts and evidence

The summaries below are conditional on each routine's actual callers, field domains, memory mapping
and callee contracts. Source locations and the actual maintained-source referrers are recorded in
the supporting inventory. Frozen symbol rows supply historical nominal provenance, while the
current source, later independent corrections and consumer roles decide. A source reference is
not evidence that every branch or arbitrary input naturally executed.

| Address | Retired alias | Retained proper name | Prior entry tag | Prior nominal status / current limit | Bounded contract | Evidence |
|---|---|---|---|---|---|---|
|68:4010|Function_68_4010|Session_ResetCounters|CONFIRMED|PROBABLE|Zeroes C2D1 plus C2D2/C2D3 display state and four bytes C2D4-C2D7; no general session-object reset or direct timer-enable change.|engine/account/helpers.asm:13; config/symbols/bank68.tsv:4; docs/research/naming_g7.md:25-113,155-183|
|68:40D8|Function_68_40D8|TextEntry_UpdateCursorSprite|CONFIRMED|PROBABLE|HL=edit buffer, D=X origin, E=Y: sprite slot DA00 <- Y=E, X=D+6*count (TextBuf_GetCount = [buf+2], text is appended at the end; 6 px per narrow glyph) via Function_00_0A65; called by every entry screen|engine/account/helpers.asm:173; config/symbols/bank68.tsv:10; docs/research/naming_g7.md:25-113,155-183|
|68:4101|Function_68_4101|Comm_ClearSessionActive|None|PROBABLE|A=0; [C2D1]=0; RET. The active-session interpretation of that write-only byte is PROBABLE from its writers, not a demonstrated read-side role.|engine/account/helpers.asm:206; config/symbols/bank68.tsv:12; analysis/naming2/g4_apps_b_renames.tsv:45; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:4152|Function_68_4152|TextEntry_InsertMaskedString|HYPOTHESIS|PROBABLE|If entered, selects WRAM3 and requests insertion of ASCII '*' ($2A) for each non-NUL source byte; TextBuf_AppendChar can reject insertion when full and its result is ignored. Entry remains HYPOTHESIS; no unbounded string safety or caller inferred.|engine/account/helpers.asm:261; config/symbols/bank68.tsv:15; analysis/naming2/g4_apps_b_renames.tsv:46; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:417F|Function_68_417F|TextEntry_CopyText|CONFIRMED|PROBABLE|HL=edit buffer: skips its 3-byte header (cap,free,count; text starts at +3, cf. DE83) and CopyString to DE in WRAM bank 3; commits typed text (68:554C, 5AD6, 5FA2)|engine/account/helpers.asm:300; config/symbols/bank68.tsv:16; docs/research/naming_g7.md:25-113,155-183|
|68:41E9|Function_68_41E9|Account_CopyMailAddressToFar|CONFIRMED|PROBABLE|A=bank, HL=dest: decodes the registered mail address SRAM bank1 B047 (XOR $A5) to C27F and CopyString to [HL] in the region/bank of A (local bank switch 68:4239); caller 2A:54C4|engine/account/helpers.asm:365; config/symbols/bank68.tsv:20; docs/research/naming_g7.md:25-113,155-183|
|68:4252|Function_68_4252|Config_ClearSramMirror|CONFIRMED|PROBABLE|enables SRAM, bank 2, zeroes A000-A0FF ($100) = adapter-config mirror image (sram_layout.md bank 2), restores the saved bank and disables SRAM; callers 65:41E0 (wizard start), 67:4013, 67:5DDE, 67:5E22, 68:73C0, 68:7C71 (delete flow)|engine/account/helpers.asm:431; config/symbols/bank68.tsv:22; docs/research/naming_g7.md:25-113,155-183|
|68:4282|Function_68_4282|Stub_Nop_68_4282|None|CONFIRMED|Exactly one RET, farcalled from PasswordChange_Run at67:58CD. Known no-op operation; original hook/patch purpose unknown. It does not flow into4283.|engine/account/helpers.asm:459; config/symbols/bank68.tsv:23; analysis/naming2/fn4_renames.tsv:4; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44; docs/research/naming2_verify_fn4.md:58-60|
|68:4283|Function_68_4283|Sram_WipeBanks2And3|HYPOTHESIS|PROBABLE|If entered, enables SRAM, selects banks2 then3 and clears A000-AFFF and B000-BFFF in each, servicing frames between; entry HYPOTHESIS. Restores the saved SRAM-bank shadow but disables SRAM, without restoring an arbitrary prior enable state. Physical results require coherent shadows and a bank-invariant stack.|engine/account/helpers.asm:463; config/symbols/bank68.tsv:24; analysis/naming2/g4_apps_b_renames.tsv:47; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:42E4|Function_68_42E4|Sram_WipeAllBanks|CONFIRMED|CONFIRMED|enables SRAM, for bank d=0..3 zeroes A000-AFFF and B000-BFFF ($1000 each) with Function_00_0392 between; callers 68:4DBA (Dev_InstallTestConfig) and 68:7CDF (delete-registration state 3)|engine/account/helpers.asm:512; config/symbols/bank68.tsv:25; docs/research/naming_g7.md:25-113,155-183|
|68:4377|Function_68_4377|Settings_IsDecodedProgressNonzero|HYPOTHESIS|HYPOTHESIS historical IsRegistrationStarted name; current predicate operation PROBABLE|Observable predicate: return A=1 iff (SRAM1[B010] xor A5)!=0, else0. No checksum/magic/range validation. B/C/DE/HL preserved by visible code; restores saved SRAM-bank shadow but disables SRAM on both exits. Entry/purpose HYPOTHESIS; operation PROBABLE. Proposed name Settings_IsDecodedProgressNonzero.|engine/account/helpers.asm:591; config/symbols/bank68.tsv:27; analysis/naming2/g4_apps_b_renames.tsv:48; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44; docs/research/naming2_verify_g4_apps_b.md:76-79|
|68:43B9|Function_68_43B9|Settings_SetProgressState3|CONFIRMED|PROBABLE|writes B010 = 3 xor $A5 (SRAM bank1): registration complete; callers 65:4699 (after the online verify succeeded) and 68:4E11 (Dev_InstallTestConfig); read back by Settings_GetRegistrationProgress|engine/account/helpers.asm:633; config/symbols/bank68.tsv:28; docs/research/naming_g7.md:25-113,155-183|
|68:4430|Function_68_4430|Settings_GetAdapterType|HYPOTHESIS|PROBABLE|unreferenced getter twin of Settings_StoreAdapterType (68:43F4 stores wMobileAdapterType xor $A5 at SRAM bank 1 B011): returns A = [B011] xor $A5 (and B = raw byte) with the SRAM enable/bank save-restore|engine/account/helpers.asm:702; config/symbols/bank68.tsv:30; analysis/naming2/g4_apps_b_renames.tsv:49; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:4469|Function_68_4469|Dial_SelectEntryFromList|CONFIRMED|PROBABLE|A=entry number, HL=list of NUL-terminated strings (2 per entry): skips strings with 4495 (falls into Settings_SetSelectedDialEntry, stores B), entry 0 if that string is empty; caller 54:4106 (then MobileAPI $06)|engine/account/helpers.asm:739; config/symbols/bank68.tsv:31; docs/research/naming_g7.md:25-113,155-183|
|68:4495|Function_68_4495|Dial_SkipStringThenSetSelectedEntry|None|PROBABLE|Advance HL past one NUL-terminated string, then fall into4499: store B xorA5 at SRAM1:B013. Not a pure skip or an independent immediate RET; calls from4469 share this persistent side effect.|engine/account/helpers.asm:779; config/symbols/bank68.tsv:32; analysis/naming2/fn4_renames.tsv:24; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44; docs/research/naming2_verify_fn4.md:110-112|
|68:4499|Function_68_4499|Settings_SetSelectedDialEntry|CONFIRMED|PROBABLE|B013 = B xor $A5 (SRAM bank1, RAM enable saved/restored): selected dial entry 0..2; callers 65:4687 (b=0 after registration), 67:4138, 68:448F, 68:4E08; read by 00:15E7 and 68:44D0|engine/account/helpers.asm:785; config/symbols/bank68.tsv:33; docs/research/naming_g7.md:25-113,155-183|
|68:44FC|Function_68_44FC|Settings_GetHiddenModeFlag|CONFIRMED|PROBABLE|returns A=B=1 if [B012] xor $A5 != 0 else 0; read at settings-menu start 68:4FD6 (-> C28C = 5th menu entry) and by 00:1587 to choose stored vs built-in dial string|engine/account/helpers.asm:847; config/symbols/bank68.tsv:35; docs/research/naming_g7.md:25-113,155-183|
|68:459A|Function_68_459A|Config_MirrorChecksumOk|CONFIRMED|CONFIRMED|Select SRAM2, sum A000-A0BD modulo16bit and compare to big-endian A0BE/A0BF. Return A1/A0; restore saved SRAM-bank shadow and disable SRAM on both exits, rather than restore arbitrary original enable state.|engine/account/helpers.asm:957; config/symbols/bank68.tsv:39; docs/research/naming_g7.md:25-113,155-183|
|68:45F1|Function_68_45F1|Config_MirrorUpdateChecksum|CONFIRMED|CONFIRMED|With SRAM2 enabled/selected by caller, sum A000-A0BD modulo16bit and write high/low checksum bytes at A0BE/A0BF; does not select/enable SRAM itself.|engine/account/helpers.asm:1017; config/symbols/bank68.tsv:40; docs/research/naming_g7.md:25-113,155-183|
|68:4735|Function_68_4735|Settings_StoreMailAddress|CONFIRMED|PROBABLE|EncodeXorA5 of WRAM3 DFAA (mail address built by Account_BuildMailAddress) into SRAM bank1 B047; read back by Account_CopyMailAddressToFar; crossed SRAM unwind is specified in section10|engine/account/helpers.asm:1180; config/symbols/bank68.tsv:43; docs/research/naming_g7.md:25-113,155-183|
|68:48DE|Function_68_48DE|Settings_VerifyAndRepair|CONFIRMED|CONFIRMED|verify page B000 (Function_68_4950): 0 ok (refresh backup), 1 restored from B100, 2 no valid page but at least one magic ok, 3 both magics bad; sram_layout.md fifth scheme; callers 65:481A (unreached), 68:4870; state-dependent SRAM bank/enable unwind is specified in section10|engine/account/settings_page.asm:221; config/symbols/bank68.tsv:48; docs/research/naming_g7.md:25-113,155-183|
|68:4F71|Function_68_4F71|Mobile_SaveLastResult|CONFIRMED|PROBABLE|MobileAPI $00 (get last result): A->C272, L->C273, H->C274, C->C275, B->C276, returns A=1; callers 67:5509/5638/5D26/5D93/5F38/6520 and the error paths 68:4F67, 6C5D, 7375, 7CF8|engine/account/dev_test_config.asm:183; config/symbols/bank68.tsv:64; docs/research/naming_g7.md:25-113,155-183|
|68:5296|Function_68_5296|Account_LoginIdEntryScreen|CONFIRMED|PROBABLE|keyboard screen for the login id (buffer DE80 cap $0A, OK needs 9 chars); 55:5BA2/5C8F keyboard, result C27C 1=OK 0=back; callers 65:432D/4498 (wizard; executed in register* scenarios only)|engine/account/login_id_entry.asm:7; config/symbols/bank68.tsv:77; docs/research/naming_g7.md:25-113,155-183|
|68:52B2|Function_68_52B2|Account_LoginId_ClearFlagIfChanged|HYPOTHESIS|PROBABLE|unreferenced: DecodeXorA5 of SRAM bank 1 B066 (login id) to $C28F, CompareString with the edit buffer $DEA0 and, when different, clears bit 0 of wSettingsFieldMask (bit0 = login id per the RAM note); twin of Account_MailAddress_ClearFlagIfChanged|engine/account/login_id_entry.asm:19; config/symbols/bank68.tsv:78; analysis/naming2/g4_apps_b_renames.tsv:50; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:531A|Function_68_531A|Account_LoginIdEntry_Setup|CONFIRMED|PROBABLE|draws the login-id screen: keyboard gfx (bank 5E), edit buffer DE80 (67:6731 b=$0A) preloaded from DEA1 (TextEntry_InsertString), cursor sprite, text box via Account_LoginId_PrintField|engine/account/login_id_entry.asm:78; config/symbols/bank68.tsv:79; docs/research/naming_g7.md:25-113,155-183|
|68:5404|Function_68_5404|Account_LoginIdEntry_OkStateFromMask|HYPOTHESIS|PROBABLE|unreferenced: wRam_C27D := bit 0 of wSettingsFieldMask (0/1); sibling of Account_LoginIdEntry_UpdateOkState, which sets the same wRam_C27D from TextBuf_GetFree|engine/account/login_id_entry.asm:158; config/symbols/bank68.tsv:80; analysis/naming2/g4_apps_b_renames.tsv:51; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:5417|Function_68_5417|Account_LoginIdEntry_UpdateOkState|CONFIRMED|PROBABLE|C27D = 1 when the edit buffer is full (67:6828 free slots == 0, i.e. login id complete) else 0; passed as C to the keyboard poll 55:5C8F (keyboard OK-cursor argument, passed in C to Kbd_Run)|engine/account/login_id_entry.asm:174; config/symbols/bank68.tsv:81; docs/research/naming_g7.md:25-113,155-183|
|68:5739|Function_68_5739|Account_MailAddress_ClearFlagIfChanged|HYPOTHESIS|PROBABLE|unreferenced: compares the decoded SRAM bank 1 B071 and B07A (mail local part and domain) with the edit buffers $DEAB/$DEB4 and, when either differs, clears bit 1 of wSettingsFieldMask; twin of Account_LoginId_ClearFlagIfChanged|engine/account/mail_address_entry.asm:17; config/symbols/bank68.tsv:91; analysis/naming2/g4_apps_b_renames.tsv:52; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:57B6|Function_68_57B6|Account_MailAddressEntry_Setup|CONFIRMED|PROBABLE|draws the mail-address screen: buffers DE80/DE94 (67:6731 b=9/5) preloaded from DEAB/DEB4, keyboard gfx (bank 5E), two print fields, OK state|engine/account/mail_address_entry.asm:86; config/symbols/bank68.tsv:92; docs/research/naming_g7.md:25-113,155-183|
|68:58E8|Function_68_58E8|Account_MailAddressEntry_OkStateFromMask|HYPOTHESIS|PROBABLE|unreferenced: wRam_C27E := bit 1 of wSettingsFieldMask (0/1); sibling of Account_MailAddressEntry_UpdateOkState|engine/account/mail_address_entry.asm:193; config/symbols/bank68.tsv:93; analysis/naming2/g4_apps_b_renames.tsv:53; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:58FB|Function_68_58FB|Account_MailAddressEntry_UpdateOkState|CONFIRMED|PROBABLE|C27E = 1 when the sub-domain buffer DE94 is full (67:6828 == 0) else 0: keyboard OK-cursor argument, passed in C to Kbd_Run for the mail address screen (twin of Account_LoginIdEntry_UpdateOkState)|engine/account/mail_address_entry.asm:209; config/symbols/bank68.tsv:94; docs/research/naming_g7.md:25-113,155-183|
|68:5D2F|Function_68_5D2F|ReturnOnly_68_5D2F|PROBABLE|PROBABLE RET operation; HYPOTHESIS entry/purpose|One RET at5D2F, not the108-byte password comparison candidate beginning5D30. Operation PROBABLE; independent entry/purpose HYPOTHESIS. RET has no sequential edge to5D30.|engine/account/password_entry.asm:25; config/symbols/bank68.tsv:107; docs/research/naming_g7.md:25-113,155-183; docs/research/naming_68_5d2f_ret_boundary.md:1-30; docs/research/naming_68_verify_5d2f_ret_boundary.md:51-65|
|68:5D9C|Function_68_5D9C|Account_PasswordEntry_Setup|CONFIRMED|PROBABLE|draws the password screen: buffer DE80 (67:6731 b=9, 8 chars) preloaded from DED4, gfx banks 5D/5E, map from Account_PasswordEntryMaps[C27D]|engine/account/password_entry.asm:87; config/symbols/bank68.tsv:108; docs/research/naming_g7.md:25-113,155-183|
|68:5E9A|Function_68_5E9A|Account_PasswordEntry_OkStateFromMask|HYPOTHESIS|PROBABLE|unreferenced: wRam_C27E := 0 unless bit 2 of wSettingsFieldMask is set, else the result of Account_PasswordIsValid; sibling of Account_PasswordEntry_UpdateOkState (5EAE)|engine/account/password_entry.asm:186; config/symbols/bank68.tsv:110; analysis/naming2/g4_apps_b_renames.tsv:54; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:5EAE|Function_68_5EAE|Account_PasswordEntry_UpdateOkState|CONFIRMED|PROBABLE|C27E = Account_PasswordIsValid when the edit buffer is full (67:6828 == 0) else 0: keyboard OK-cursor argument, passed in C to Kbd_Run for the password screen (twin of the login-id/mail updaters)|engine/account/password_entry.asm:203; config/symbols/bank68.tsv:111; docs/research/naming_g7.md:25-113,155-183|
|68:6344|Function_68_6344|Account_ConfirmScreen_UpdateCursor|CONFIRMED|PROBABLE|sprite slot DA00 position (Y,X) = Account_ConfirmCursorPositions[C27D] via Function_00_0A65|engine/account/confirm_screens.asm:123; config/symbols/bank68.tsv:123; docs/research/naming_g7.md:25-113,155-183|
|68:6360|Function_68_6360|Account_ConfirmScreen_BuildTextMap|CONFIRMED|PROBABLE|two 4F:45C6 calls: hl=$D0A6 bc=$0208 and hl=$D121 de=$0010 bc=$0212: tile-number maps of the login-id and mail-address fields|engine/account/confirm_screens.asm:149; config/symbols/bank68.tsv:125; docs/research/naming_g7.md:25-113,155-183|
|68:659E|Function_68_659E|Account_ConfirmManualScreen_BuildTextMap|CONFIRMED|PROBABLE|executed in 2 scenarios; single caller Account_ConfirmManualScreen_Setup: five Tilemap_FillAscendingWithAttr calls into the $D000 map buffer; same role and shape as Account_ConfirmScreen_BuildTextMap (68:6360, two calls) of the sibling screen|engine/account/confirm_screens.asm:380; analysis/naming2/g4_apps_b_renames.tsv:55; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:6762|Function_68_6762|Account_ConfirmManualScreen_UploadTextTiles|None|PROBABLE|Five TileCanvas_UploadRect calls to VRAM9000/9100/9400/9600/8800 with the source-defined rectangles, thenRET; consumer is manual-confirm setup. Existing role PROBABLE, recorded execution does not imply every arbitrary rectangle/input.|engine/account/confirm_screens.asm:574; analysis/naming2/g4_apps_b_renames.tsv:56; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:6AE0|Function_68_6AE0|Registration_WriteConfigToAdapter|CONFIRMED|PROBABLE|screen 'アダプタ登録中 / 設定情報を登録中です' + 'do not unplug' box (rendered 5D:7048), states Table_68_6BF4: API $02, Config_BuildImageFromAccount + API $04, $36; C27C 1 ok/0 error; caller 65:4661|engine/account/register_config.asm:7; config/symbols/bank68.tsv:144; docs/research/naming_g7.md:25-113,155-183|
|68:6C7F|Function_68_6C7F|Registration_DoNotUnplugMessage|CONFIRMED|PROBABLE|Function_00_153D(a=3) = message 3 of PromptText_Table ('do not unplug the Mobile Adapter GB or phone, do not switch off the GB'), printed in a 18-column by 6-row tile box (BC=$0612)|engine/account/register_config.asm:186; config/symbols/bank68.tsv:151; docs/research/naming_g7.md:25-113,155-183|
|68:6E1A|Function_68_6E1A|Account_ActionConfirmPage|CONFIRMED|PROBABLE|A=0..3 picks message Account_ActionMessageIds[A] (4 verify registration, 11 change password, 12 usage time, 13 usage fee); two buttons, B allowed only for A!=0; returns C27C 1/2/0; callers 65:4672, 67:5982, 67:6121|engine/account/action_confirm.asm:7; config/symbols/bank68.tsv:155; docs/research/naming_g7.md:25-113,155-183|
|68:6F9B|Function_68_6F9B|Account_ActionConfirmPage_BuildTextMap|CONFIRMED|PROBABLE|4F:45C6(hl=$D121, de=0, bc=$0612): tile-number map of the 6x18 message area|engine/account/action_confirm.asm:157; config/symbols/bank68.tsv:160; docs/research/naming_g7.md:25-113,155-183|
|68:7009|Function_68_7009|Account_ActionConfirmPage_UploadTextTiles|CONFIRMED|PROBABLE|4F:4572(de=$9000, hl=$0901, bc=$0612): uploads the rendered message tiles|engine/account/action_confirm.asm:216; config/symbols/bank68.tsv:163; docs/research/naming_g7.md:25-113,155-183|
|68:73DD|Function_68_73DD|Screen_FadeOutAndResetObjWindow|None|PROBABLE|Fade to white, reset sprites, wait, clear LCDC bits2 (OBJ size) and5 (window), service sound andRET. Does not clear LCDC bit7 or prove LCDOff; role describes mechanics.|engine/account/comm_panel.asm:89; config/symbols/bank68.tsv:183; analysis/naming2/g4_apps_b_renames.tsv:57; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_verify_g4_apps_b.md:44|
|68:75A4|Function_68_75A4|CommPanel_PrintWarningText|CONFIRMED|PROBABLE|Function_00_153D(a=3): message 3 ('do not unplug the adapter/phone or switch off') printed in the 18-column by 6-row lower tile box (BC=$0612); then uploads the box tiles|engine/account/comm_panel.asm:302; config/symbols/bank68.tsv:193; docs/research/naming_g7.md:25-113,155-183|
|68:766E|Function_68_766E|Account_ResultPage|CONFIRMED|PROBABLE|A=kind (C27C), B=failure (1 error, 2 interrupted): window page with banner from Data_68_7831 and message Data_68_77D0[...]; wait on JoypadDispatch (A closes); callers 65:46B0/46D7, 67:599E/59D8/5A06/60D6/60EA/6115/628F/62A3/62CE|engine/account/result_page.asm:7; config/symbols/bank68.tsv:197; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_neutral_account.md:9-13|
|68:7745|Function_68_7745|Account_ResultPage_PrintMessage|CONFIRMED|PROBABLE|picks message Data_68_77D0[C27C] (or index 4/5 when C27D=1/2) and prints it via Function_00_153D in the 18-column by 6-row tile box (BC=$0612)|engine/account/result_page.asm:115; config/symbols/bank68.tsv:198; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_neutral_account.md:9-13|
|68:77D6|Function_68_77D6|Account_ResultPage_LoadBanner|CONFIRMED|PROBABLE|Select two source16/bank8 banner descriptors by kind/variant and issue640-byte HDMA requests to VRAM1:9000/9280. Known caller domain kinds0..4, variants0..2; no arbitrary-input clamp. Seven of29 aggregate bytes remain unread/PROBABLE.|engine/account/result_page.asm:192; config/symbols/bank68.tsv:200; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_neutral_account.md:9-13|
|68:784E|Function_68_784E|Account_ResultPage_DrawTimeDigits|CONFIRMED|PROBABLE|draws two 2-digit values (C2D6/C2D5, or C2D8-DA from Function_51_425F for kinds 2/3) as tiles via Function_68_792A and the digit table; time used shown on the result page|engine/account/result_page.asm:275; config/symbols/bank68.tsv:201; docs/research/naming_g7.md:25-113,155-183; docs/research/naming2_neutral_account.md:9-13|
|68:7951|Function_68_7951|Registration_DeleteFlow|CONFIRMED|PROBABLE|delete-registration flow: pages 8,9 (65:487C; 65:4BDE records 8-11 -> strings 65:505A/50EE/5157/5179), confirm pages 0/1, Registration_DeleteExecute, page 11 done or 10 cancelled; caller 7C:7DFF|engine/account/delete_registration.asm:7; config/symbols/bank68.tsv:204; docs/research/naming_g7.md:25-113,155-183|
|68:799A|Function_68_799A|Registration_DeleteConfirmPage|CONFIRMED|PROBABLE|A=0/1 picks message 6 or 7 ('deleted info cannot be restored' / 'redo initial registration after deleting'); two buttons, returns 1/2/0; called from 68:7968 and 68:7974|engine/account/delete_registration.asm:54; config/symbols/bank68.tsv:205; docs/research/naming_g7.md:25-113,155-183|
|68:7B1D|Function_68_7B1D|Registration_DeleteConfirm_PrintMessage|CONFIRMED|PROBABLE|Function_00_153D(a=6 if C27C==0 else 7): messages 6/7 of PromptText_Table printed in the 18-column by 6-row tile box (BC=$0612)|engine/account/delete_registration.asm:209; config/symbols/bank68.tsv:210; docs/research/naming_g7.md:25-113,155-183|
|68:7D1C|Function_68_7D1C|Registration_DeleteExecute_PrintMessage|CONFIRMED|PROBABLE|Function_00_153D(a=3) printed in the 18-column by 6-row tile box (BC=$0612): message 3 (do not unplug)|engine/account/delete_registration.asm:423; config/symbols/bank68.tsv:215; docs/research/naming_g7.md:25-113,155-183|

## 4. Cross-cutting ABI and consumer limits

The relevant bank/register/shadow state is part of these contracts. A banked CPU address does not
identify the original bytes without its ROM/SRAM/WRAM context. Each entry screen uses transient
WRAM0 overlays, and text buffers live in WRAM bank 3 under explicit wrappers. Field masks and
per-screen OK flags must be interpreted in the owning screen's scope.

The login/mail changed-field candidates compare decoded NUL-terminated SRAM fields with WRAM3
buffers and conditionally clear only their corresponding bits. Their names describe operations,
not proven live entries or general Boolean outputs. NUL termination, readable/writable extents,
helper completion, non-overlapping stacks and stable scratch remain prerequisites; field-size
annotations do not prove them for arbitrary bytes. Saved HRAM shadows are the values later written
back; they do not independently prove physical hardware state was restored.

`Account_PasswordEntry_OkStateFromMask` at `5E9A` is not a simple Boolean(mask & 4). A clear bit2
writes OK=0; a set bit2 calls `Account_PasswordIsValid` and stores that result. Login/mail mask
siblings write their own overlay flags; their source HYPOTHESIS entries remain distinct from the
executed `UpdateOkState` siblings. The latter use buffer fullness and, for password, validation;
the mail screen has a separate domain-length check. No confidence transfers merely from twins.

`Dial_SkipStringThenSetSelectedEntry` at `4495` has no RET before `4499`: it scans one NUL and
falls into the persistent setter, storing B xor A5 at SRAM1:B013. Its four CALL sites in
Dial_SelectEntryFromList therefore share that side effect and return through the setter's RET.
This is not a pure skip routine. The input must terminate in readable storage, and the routine
has no general clamp for arbitrary B. The selector can persist a candidate before later choice
logic returns or resets it; no safe arbitrary-index API is asserted.

`Comm_ClearSessionActive` only zeroes C2D1. That state's connection-active interpretation remains
PROBABLE from the writers; `ram/wram.asm` records no known read-side consumer. The current source
has three named call sites (including the adapter-error path), so old two-caller wording is not a
fresh complete census. This operational name does not close the unknown read-side purpose.

`Screen_FadeOutAndResetObjWindow` clears LCDC bits 2 and 5: OBJ size and window enable. It does not
clear LCDC bit7 and must not be described as LCDOff. The five manual-confirm upload calls identify
rectangles and VRAM destinations, not a new runtime/visual proof for arbitrary input state.

`Config_MirrorChecksumOk` restores the saved SRAM-bank shadow and disables SRAM, whereas
`Config_MirrorUpdateChecksum` requires its caller to have enabled/selected SRAM2. These are not
interchangeable ownership contracts. The four-bank/banks2-and3 wipe names describe their visible
zero stores; unknown entries, frame-service interference and saved-shadow prerequisites remain.
No wipe, adapter command or hardware experiment was executed by this naming work.

`Account_ResultPage_LoadBanner` has a known finite caller domain (kinds 0..4 and variants 0..2),
not an arbitrary-input clamp. Its two HDMA requests are $280 bytes each (640 decimal), to VRAM bank1.
The source aggregate has 29 bytes, 22 naturally read; seven remain PROBABLE/unread. Consumer names
do not promote those bytes or classify every pointed resource. See naming2_neutral_account.md.

## 5. RET 5D2F and the unlabelled candidate

ReturnOnly_68_5D2F denotes only C9 at5D2F. With a valid stack it RETs, preserving A/F/BC/DE/HL and
using the entry return word; there is no sequential edge to5D30. The following108-byte candidate
at5D30-5D9C performs a conditional password-field comparison under SRAM1/WRAM3, but has no proven
independent entry or intended caller. It is not the behavior of entering the RET.

One local label in that candidate was lexically scoped to Function_68_5D2F; after alias retirement
it scopes to ReturnOnly_68_5D2F. That namespace change does not make the candidate part of a callable
RET function. Its mask update can produce A=0 on unequal strings and is not a general Boolean
changed result. Its decoded-NUL, mapping, shadows and stack conditions remain explicit in
naming_68_5d2f_ret_boundary.md. This cohort does not close that candidate.

## 6. Local namespace changes

Only the global scope prefix changes; local definitions, relative operands and addresses remain.
No active qualified old-local operand required rewriting in the pinned source inventory.

| Address | Before | After |
|---|---|---|
|68:4161|Function_68_4152.loop|TextEntry_InsertMaskedString.loop|
|68:4175|Function_68_4152.l4175|TextEntry_InsertMaskedString.l4175|
|68:42ED|Function_68_42E4.loop|Sram_WipeAllBanks.loop|
|68:43A7|Function_68_4377.l43A7|Settings_IsDecodedProgressNonzero.l43A7|
|68:447E|Function_68_4469.l447E|Dial_SelectEntryFromList.l447E|
|68:4484|Function_68_4469.l4484|Dial_SelectEntryFromList.l4484|
|68:448A|Function_68_4469.l448A|Dial_SelectEntryFromList.l448A|
|68:4539|Function_68_44FC.skip|Settings_GetHiddenModeFlag.skip|
|68:45B7|Function_68_459A.loop|Config_MirrorChecksumOk.loop|
|68:45DF|Function_68_459A.l45DF|Config_MirrorChecksumOk.l45DF|
|68:45F9|Function_68_45F1.loop|Config_MirrorUpdateChecksum.loop|
|68:48ED|Function_68_48DE.l48ED|Settings_VerifyAndRepair.l48ED|
|68:48F3|Function_68_48DE.l48F3|Settings_VerifyAndRepair.l48F3|
|68:48FE|Function_68_48DE.l48FE|Settings_VerifyAndRepair.l48FE|
|68:493D|Function_68_48DE.l493D|Settings_VerifyAndRepair.l493D|
|68:4940|Function_68_48DE.l4940|Settings_VerifyAndRepair.l4940|
|68:52FC|Function_68_52B2.l52FC|Account_LoginId_ClearFlagIfChanged.l52FC|
|68:53F7|Function_68_531A.l53F7|Account_LoginIdEntry_Setup.l53F7|
|68:5411|Function_68_5404.l5411|Account_LoginIdEntry_OkStateFromMask.l5411|
|68:5429|Function_68_5417.l5429|Account_LoginIdEntry_UpdateOkState.l5429|
|68:578C|Function_68_5739.l578C|Account_MailAddress_ClearFlagIfChanged.l578C|
|68:5798|Function_68_5739.l5798|Account_MailAddress_ClearFlagIfChanged.l5798|
|68:58BB|Function_68_57B6.l58BB|Account_MailAddressEntry_Setup.l58BB|
|68:58C7|Function_68_57B6.l58C7|Account_MailAddressEntry_Setup.l58C7|
|68:58DB|Function_68_57B6.l58DB|Account_MailAddressEntry_Setup.l58DB|
|68:58F5|Function_68_58E8.l58F5|Account_MailAddressEntry_OkStateFromMask.l58F5|
|68:590D|Function_68_58FB.l590D|Account_MailAddressEntry_UpdateOkState.l590D|
|68:5D7E|Function_68_5D2F.l5D7E|ReturnOnly_68_5D2F.l5D7E|
|68:5DCD|Function_68_5D9C.l5DCD|Account_PasswordEntry_Setup.l5DCD|
|68:5E85|Function_68_5D9C.l5E85|Account_PasswordEntry_Setup.l5E85|
|68:5EA7|Function_68_5E9A.l5EA7|Account_PasswordEntry_OkStateFromMask.l5EA7|
|68:5EC0|Function_68_5EAE.l5EC0|Account_PasswordEntry_UpdateOkState.l5EC0|
|68:7798|Function_68_7745.l7798|Account_ResultPage_PrintMessage.l7798|
|68:779C|Function_68_7745.l779C|Account_ResultPage_PrintMessage.l779C|
|68:779E|Function_68_7745.l779E|Account_ResultPage_PrintMessage.l779E|
|68:780E|Function_68_77D6.l780E|Account_ResultPage_LoadBanner.l780E|
|68:7810|Function_68_77D6.l7810|Account_ResultPage_LoadBanner.l7810|
|68:786E|Function_68_784E.l786E|Account_ResultPage_DrawTimeDigits.l786E|
|68:7873|Function_68_784E.l7873|Account_ResultPage_DrawTimeDigits.l7873|
|68:7884|Function_68_784E.l7884|Account_ResultPage_DrawTimeDigits.l7884|
|68:78D1|Function_68_784E.l78D1|Account_ResultPage_DrawTimeDigits.l78D1|
|68:78D6|Function_68_784E.l78D6|Account_ResultPage_DrawTimeDigits.l78D6|
|68:78E7|Function_68_784E.l78E7|Account_ResultPage_DrawTimeDigits.l78E7|
|68:795C|Function_68_7951.l795C|Registration_DeleteFlow.l795C|
|68:7967|Function_68_7951.l7967|Registration_DeleteFlow.l7967|
|68:798F|Function_68_7951.l798F|Registration_DeleteFlow.l798F|
|68:7990|Function_68_7951.l7990|Registration_DeleteFlow.l7990|
|68:7999|Function_68_7951.l7999|Registration_DeleteFlow.l7999|
|68:7B70|Function_68_7B1D.l7B70|Registration_DeleteConfirm_PrintMessage.l7B70|
|68:7B78|Function_68_7B1D.l7B78|Registration_DeleteConfirm_PrintMessage.l7B78|

## 7. Five largest remaining gaps

1. 68:4377: Current IsRegistrationStarted meaning was independently downgraded; only stored XOR-decoded nonzero predicate is supported. Next: Use Settings_IsDecodedProgressNonzero with HYPOTHESIS entry/purpose and PROBABLE operation; preserve bank/enable and non-Boolean flags contract.

2. 68:5D2F; 68:5D30-5D9C: RET identity and following108-byte candidate must remain separate; neither an independent natural entry nor candidate purpose is proven. Next: Keep ReturnOnly operation limited toC9; bound the candidate comparison and its unbounded NUL/stack/shadow prerequisites separately.

3. 68:4152; 68:4283; 68:4430; 68:52B2; 68:5739; 68:5404; 68:58E8; 68:5E9A: Operational sibling names do not supply the missing independent entries/callers or intended use. The three changed/OK twins must not inherit executed sibling coverage. Next: Keep source HYPOTHESIS entry and conditional operation contracts; no new functions from clean decode or matching RAM offsets.

4. 68:4469; 68:4495; 68:4499: SkipString has a persistent SRAM side effect and no standalone RET at4499 boundary. Pointer termination and arbitrary B/id values are not bounded by the name. Next: Document shared return frame and B013 write; keep PROBABLE mechanism/known-caller domain separate from a general safe string-selector ABI.

5. 68:4101; 68:4010; 68:77D6: Two kinds of remaining semantic limits: C2D1 role is inferred from writers with no read-side consumer; result-banner names describe consumers while7/29 storage bytes remain unread. Neither is completed by removing Function aliases. Next: Retain PROBABLE state/storage interpretation and known input vectors; no account-data samples, arbitrary-input guarantee or complete semantic coverage claim.

The name correction in section2 resolves the overclaim in wording, not the missing entry or
purpose. The other limits likewise remain after alias retirement. Reducing a label count cannot
stand in for original-ROM function discovery, complete call-frame mapping or natural execution.

## 8. Provenance and integration limits

The input is the accepted private original-Japanese source corresponding to revision
245961f64363a27e57c99b3fbad906bf8d400ca2. This proposal has no dependency on unrelated audio or
English source changes. All twelve owner-file baselines match the source census pins. The inventory
is mt-jp-bank68-naming-inventory-20261015/DATA/INVENTORY.json, SHA-256
3283431edd34f99fc1259e8d11d1f2a2e42c08f3970208d234cb6ee251b92664. It records individual evidence, real source referrers and scope maps for all54 rows.
No sampled account/email/password/name contents are included here.

The private proposal preserves BEFORE owner files, source after hashes, the exact text patch and
an instruction/local-label text invariant. These are not assembled-ROM comparisons. Integration,
independent review, make, sym-check and original-ROM byte comparison remain ROOT checks; this
proposal ran no build, test, replay, emulation, hardware, Git mutation, OMM write or English work.
Historical reference tables remain untouched. No claim of complete original analysis follows.


## 9. Corrections from the original consumers (2026-10-15)

The earlier `naming_g7.md:67` called C27D/C27E an OK-enabled flag. That stronger historical
wording is not adopted here; the earlier note stays preserved. Kbd_Run55:5C8F stores C into
wKbdRunArgC and uses it at5CE9..5D05 to choose the initial OK cursor cell. For types0/1/4,
wKbdRunArgB is initialized to1. Key82 acceptance at5EB9 tests ArgB, not ArgC, before returning7
at5F23. Login54DE independently tests length>=9, mail5A42 tests subdomain length>=3, and
password5F7C calls PasswordIsValid. The UpdateOkState names remain PROBABLE general cursor-state
roles, not enable/disable operations. No new keyboard execution is attributed to these readings.

The five message-box rows use18 columns by6 tile rows: B=6,C=12h in the actual fill/upload
consumers. The text-line step0Ch is a pixel advance, not12 tile rows. The masked insertion
helper requests one asterisk per non-NUL source byte, but its callee can reject requests when
capacity is exhausted; a one-cell-capacity buffer with two source bytes retains only one
asterisk. These static branch counterexamples correct the proposed prose without changing code.


## 10. Original-code crossed SRAM unwind

Let W=entry hWRAMBank, R=entry hSRAMBank, E=entry hSRAMEnable. Formulas below describe final
HRAM shadows and the **raw values written** to SVBK/RAMB/RAMG, not a claim that arbitrary mapper
values select distinct physical memory banks. They assume normal completion, stable scratch,
non-interfering memory, valid balanced helper frames and a stack whose physical storage is
invariant across all selected banks. Code and source stay unchanged.

### Settings_StoreMailAddress 68:4735

| Saved item | Read/PUSH | POP | Destination writes |
|---|---|---|---|
| W |4737 /4739|477D|hWRAMBank477E, SVBK4780|
| R |4744 /4746|4773|hSRAMEnable4774, RAMG4776|
| E |4752 /4754|4769|hSRAMBank476A, RAMB476C|

The source selects WRAM3 and SRAM1, enables SRAM, then EncodeXorA5 at4764 copies DFAA toB047.
It unwinds E into the bank shadow/register, R into enable shadow/register, and W into WRAM.
Final shadow tuple **(hWRAMBank,hSRAMBank,hSRAMEnable)=(W,E,R)**, with final raw writes
**(SVBK,RAMB,RAMG)=(W,E,R)**. This is a crossed SRAM unwind, not an ordinary restore to(W,R,E).
Original80-byte span4735..4785 SHA256
`385e661e537f1e2cc005081c36fcfbdf58a65abba6e9131e50636f7f9f8ae68c`.
The role “store encoded mail address” remains true; its mapper side effect must be documented.

### Local backup-copy path 68:48FE in Settings_VerifyAndRepair

Here R/E refer specifically to the shadows on entering48FE, after the preceding page checks.

| Saved item | Read/PUSH | POP | Destination writes |
|---|---|---|---|
| R |4900 /4902|4932|hSRAMEnable4933, RAMG4935|
| E |490E /4910|4928|hSRAMBank4929, RAMB492B|

The path selects SRAM1/enables it and copies $100 bytes B100→B000 at4923.
Final local shadow/register-write tuple **(bank,enable)=(E,R)**; it returns A=1 at493A/493C.
Original63-byte span48FE..493D SHA256
`0287d949e7db8706f77d90d938bc2bdb81006cf390feb99f54ad316e268940ed`.

Do not substitute this local formula for the whole48DE entry contract. Its two helper wrappers
also implement the same swap X(R,E)=(E,R):

- CheckPageMagicAndSum4950: PUSH4954(R),4962(E); POP49A2→49A3/49A5(bank=E),
  POP49AC→49AD/49AF(enable=R). All exits use this unwind. Original102-byte span4950..49B6 SHA256
  `c6eef25b8cb43d91bebd9e86fd9994a540c176b19d148c086add4186d49af724`.
- UpdateChecksumAndBackup49B6: PUSH49BA(R),49C8(E); POP49EC→49ED/49EF(bank=E),
  POP49F6→49F7/49F9(enable=R). Original73-byte span49B6..49FF SHA256
  `898091d9ddccc3d1523d1da840a2df2aa2e672ac02df22dc0ce2519aded61f51`.

Consequently, under the same normal-completion assumptions, **the complete48DE routine** performs
X twice when it returns0 (primary check, then checksum/backup refresh), X twice when it returns2
or3 (primary+backup checks), and X three times when it returns1 (primary+backup checks, then copy
path). Thus the final SRAM shadow/raw-write tuple is(R,E) on returns0/2/3 and(E,R) on return1.
No claim about arbitrary mapper decoding, malformed settings pages, aliases of the stack, or
hardware is implied by this static composition. No code repair is authorized or implemented.


This V2 contract records original instructions; it proposes no repair, new runtime result or
hardware claim. Independent correction spans and their SHA-256 values are retained in
CORRECTION_RAW.json (9bb222f3274479fea5d515890b0d6935bb42cb261a012c6c16a000d7c54b005e).
