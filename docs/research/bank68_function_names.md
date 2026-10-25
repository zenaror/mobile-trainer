# Bank 68: existing function names, alias retirement and unresolved contracts

| Address | Retained name |
| --- | --- |
| `4101` | Comm_ClearSessionActive |
| `4282` | Stub_Nop_68_4282 |
| `4495` | Dial_SkipStringThenSetSelectedEntry |
| `6762` | Account_ConfirmManualScreen_UploadTextTiles |
| `73DD` | Screen_FadeOutAndResetObjWindow |

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

A clear bit2 writes OK=0; a set bit2 calls `Account_PasswordIsValid` and stores that result.

`Dial_SkipStringThenSetSelectedEntry` at `4495` has no RET before `4499`: it scans one NUL and
falls into the persistent setter, storing B xor A5 at SRAM1:B013. Its four CALL sites in
Dial_SelectEntryFromList therefore share that side effect and return through the setter's RET.
This is not a pure skip routine. The input must terminate in readable storage, and the routine
has no general clamp for arbitrary B. The selector can persist a candidate before later choice
logic returns or resets it; no safe arbitrary-index API is asserted.

That state's connection-active interpretation remains PROBABLE from the writers; `ram/wram.asm` records no known read-side consumer.

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

One local label in that candidate was lexically scoped to Function_68_5D2F; after alias retirement
it scopes to ReturnOnly_68_5D2F. That namespace change does not make the candidate part of a callable
RET function. Its mask update can produce A=0 on unequal strings and is not a general Boolean
changed result. Its decoded-NUL, mapping, shadows and stack conditions remain explicit in
naming_68_5d2f_ret_boundary.md. This cohort does not close that candidate.

## 6. Local namespace changes

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

4. 68:4469; 68:4495; 68:4499: SkipString has a persistent SRAM side effect and no standalone RET at4499 boundary. Pointer termination and arbitrary B/id values are not bounded by the name. Next: Document shared return frame and B013 write; keep PROBABLE mechanism/known-caller domain separate from a general safe string-selector ABI.

5. 68:4101; 68:4010; 68:77D6: Two kinds of remaining semantic limits: C2D1 role is inferred from writers with no read-side consumer; result-banner names describe consumers while7/29 storage bytes remain unread.

Kbd_Run55:5C8F stores C into wKbdRunArgC and uses it at5CE9..5D05 to choose the initial OK cursor cell.

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

Final shadow tuple **(hWRAMBank,hSRAMBank,hSRAMEnable)=(W,E,R)**, with final raw writes **(SVBK,RAMB,RAMG)=(W,E,R)**.

This is a crossed SRAM unwind, not an ordinary restore to(W,R,E).

### Local backup-copy path 68:48FE in Settings_VerifyAndRepair

| Saved item | Read/PUSH | POP | Destination writes |
|---|---|---|---|
| R |4900 /4902|4932|hSRAMEnable4933, RAMG4935|
| E |490E /4910|4928|hSRAMBank4929, RAMB492B|

The path selects SRAM1/enables it and copies $100 bytes B100→B000 at4923.

Consequently, under the same normal-completion assumptions, **the complete48DE routine** performs
X twice when it returns0 (primary check, then checksum/backup refresh), X twice when it returns2
or3 (primary+backup checks), and X three times when it returns1 (primary+backup checks, then copy
path). Thus the final SRAM shadow/raw-write tuple is(R,E) on returns0/2/3 and(E,R) on return1.
No claim about arbitrary mapper decoding, malformed settings pages, aliases of the stack, or
hardware is implied by this static composition. No code repair is authorized or implemented.
