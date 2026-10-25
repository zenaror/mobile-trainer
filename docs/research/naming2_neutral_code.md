# Neutral labels referenced by instructions: bounded reference (ROM unchanged)

## Applied names

| Existing neutral name | Semantic name |
| --- | --- |
| String_2A_4A6F | String_SaveSenderAddr_CaptionPart2 |
| String_2A_4A78 | String_SaveSenderAddr_CaptionPart3 |
| String_2A_4A81 | String_SaveSenderAddr_CaptionPart4 |
| String_2A_4A8A | String_SaveSenderAddr_CaptionPart5 |
| Data_3F_4000 | Table_HtmlStore_KeywordPointers |
| Data_51_740C | ImageBlit_AllBitsMask |
| String_56_4047 | String_ConnectDialog_PasswordEntryPrompt |
| String_56_406A | String_ConnectDialog_SavePasswordConfirm |
| String_56_40BF | String_ConnectDialog_PasswordSavedNotice |
| String_56_410A | String_ConnectDialog_StoredPasswordNotice |
| String_56_4159 | String_ConnectDialog_CancelPasswordStorageConfirm |
| Data_55_65D7 | Table_Kbd_InputModeReturnCodes |
| String_22_483C | String_MailSrvDelHidden_DeleteAllWarningPart2 |
| String_22_485D | String_MailSrvDelHidden_DeleteAllWarningPart3 |
| String_22_487E | String_MailSrvDelHidden_DeleteAllWarningPart4 |
| String_23_472B | String_MailSrvDel_DeleteAllWarningPart2 |
| String_23_474C | String_MailSrvDel_DeleteAllWarningPart3 |
| String_23_476D | String_MailSrvDel_DeleteAllWarningPart4 |

## Remaining labelled local operations and fragment boundaries

Ten further PROBABLE local-operation aliases preserve the original neutral labels and instruction locators:

|Address|Operation alias|
|---|---|
|23:6D61|`Wram7_Write14To27AtD1E0`|
|24:42B0|`Wram6_CopyGooUrlAndTitleToPageBuffers`|
|2B:57CB|`Fill99E1Pattern46_Draw5807TwiceAndUpload`|
|2B:64F1|`Show0206_CallDeleteRecordIf1_Else64A7`|
|2B:687C|`Sprite_SetSlots1And2Y68XByC_InitSlot2`|
|2B:6CF5|`CopyRecordBFields_Edit_Pop4IfBodyNot0OrFF`|
|68:5D2F|`ReturnOnly_68_5D2F`|
|6C:61AC|`DecC0DA_OnZeroReload23ToggleC0D9AndSetDA20`|
|70:46A6|`TrySetA9EEFromRandom16_ByA9EDFlags`|
|7C:7D8D|`InitStep70_EntryAThen1Then2_Jump7D82`|

The [mail operations](naming2_neutral_mail.md) distinguish current-VBK pattern stores, two fixed-string draws and an upload from a result-dependent dialog/delete/loop transfer. The post-dialog DA10/DA20 stores use the then-selected WRAM bank; they are not a guaranteed sprite restoration. The [sprite operation](typing_2b_687c_residual_localcase_bounds.md) includes the complete default suffix and only the documented slot/helper effects. The mail field-edit path discards four stack words only on its nonzero/non-FF body-result path; no caller or fourth-word unwind ABI is established. Its corrected complete partition is187 bytes/100 CPU starts, with68 prefix starts and69 existing forced observations; body farcall6D86 and copy counts0x40(64)/0x10(16) are explicit. Forced observations remain diagnostic, with no terminal POP/RET or natural-entry proof.

The [WRAM operations](typing_23_24_27_1a_header_facts.md) separate twenty ascending byte stores with shadow-based restoration and scratch28 from constant URL/title copies that leave WRAM6 selected. The copied22/9-byte strings include their NUL terminators; the page-field roles have consumer support without a caller of this entry. The literal ascending-byte name does not infer tile IDs.

The [return-only entry](naming_68_5d2f_ret_boundary.md) covers only C9 at68:5D2F; the following108-byte decode/compare fragment remains separate and unlabelled.

The [counter operation](naming_6c_61ac.md) expires only from old1, reloads23 and toggles bit0 of an otherwise unproved byte domain.

The [random-range operation](naming_70_46a6_sram_boundaries.md) names the tested fields and conditional store, without a game purpose or uniformity claim; the following63-byte bit-reader remains unlabelled.

The derivation groups global ROM symbols by bank/address, excludes local symbols and RAM domains, and keeps only groups whose global names are exclusively Function_BB_AAAA/Label_BB_AAAA before adding these names.

Of47 adjacent hypothesis headers,45 already describe the local mechanism and two retain external-stack/continuation limits (2B:6CF5 and2D:4E42/4E54).

The positive source defects are corrected without changing instruction operands or adding aliases: bank7C font10 bytes represented as data;54:4CAD consumed ellipsis classified as text;24:4BCC stale byte count; and comments distinguishing sequential bypass, matching POPs, relative-branch variants and eight profile calls.

## Additional shortlist mechanisms and next original audit

Their [contracts](classify_g2.md) account for156 bytes/98 CPU starts: old counter1 selects the long OBJ palette update (old0 wraps toFF), while the six-record wrapper has a77-byte sibling differing only in the E28/E30 immediate.
