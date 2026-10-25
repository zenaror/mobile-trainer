# reference 2, group 2: libraries and leftover neutral names (banks 7F, 0F, 75, 74, 73, 65, 67)

## Result

| bank | rows | CONFIRMED | PROBABLE | HYPOTHESIS (kept neutral) | what it is |
|---|---|---|---|---|---|
| 0F | 29 | 0 | 28 | 1 | SDK mail library (`lib/mobile/mail.asm`) |
| 75 | 21 | 2 | 8 | 11 | Mobile Adapter SDK (`lib/mobile/main.asm`) |
| 74 | 7 | 0 | 5 | 2 | HTML layout |
| 73 | 19 | 2 | 5 | 12 | browser start-choice screen |
| 65 | 7 | 1 | 3 | 3 | startup / registration |
| 67 | 24 | 1 | 23 | 0 | settings / password change / adapter check |
| 7F | 78 | 16 | 56 | 6 | text canvas, glyphs, scroll split, comm hooks, unreferenced page-list prototype |
| **all** | **185** | **22** | **128** | **35** | 99 function, 45 label, 26 data, 12 string, 3 table rows |

## Bank 0F - mail library (`lib/mobile/mail.asm`)

| selector / group | names | basis |
|---|---|---|
| parser core | `Mail_FindHeader_Scan` (4416) | raw keyword scanner behind `Mail_FindHeader` (case-insensitive compare against `Mail_HeaderKeywordTable[B]`, folded lines); its page wrapper is already `Mail_FindHeader_NextPage`; 16 scenarios |
| part records of `Mail_ParseBody` | `Mail_PartRec_EmitHeaderBlock` (486B), `_EmitLengthAndPart` (48C6), `_EmitPart` (4951), `_EmitLength` (49D0) + the four `_NextPage` wrappers (48BD, 4948, 49C7, 4A13) | they append `{2,1,ptr}`, `{len,type,[name4],ptr}`, `{type,[name4],ptr}` and a 2-byte length to the output stream D006/D007-8 and reserve space in D009/A; called by `Mail_ParseSinglePart` / `Mail_ParseMultipart` around `Mail_SkipHeaderBlock`/`FindBoundary`/`FindMessageEnd`; executed in 4-6 scenarios; wrappers have the exact shape of the other `*_NextPage` (BC=D001) |
| 9 | `Mail_ComposeHeaderBlock` (52BC) + `_LoadArgs` (5381), `_FetchItem` (53B9), `_BuildAddressList` (53D6) | emits header indices 0-9 (From ... X-GBmail-type) with the **same** `Mail_EmitHeaderField`/`Mail_EmitCrLf` that selector 8 (`Mail_ComposeNext`) uses; address lists joined by `,` and passed through `Mail_ExtractAddresses` |
| 10 | `Mail_ComposeMimeBody` (54D8) + `_LoadArgs` (55C4), `_NextPart` (55E6), `_CopyData` (561F) | header indices $0A-$10 of `Mail_HeaderStringTable` (Content-Type text/multipart/octet-stream, base64 encoding, `--` boundaries, final `.`) plus chunked copy of each part |
| 11 | `Mail_Base64EncodeStream` (56E1), `_ClampChunk` (57E5), `_Step` (5833), `Mail_CalcBase64EncodedSize` (5771) | incremental encoder around `Mail_Base64Encode`; state machine on D023 (`wMail_ComposeState`); size = ceil(n/3)*4 plus CR LF per 64 characters (arithmetic read from the two shift-subtract loops) |
| 12 | `Mail_Base64DecodeStream` (5A10), `_ClampChunk` (5AC5), `_Step` (5B15), `Mail_CalcBase64DecodedSize` (5A74), `Mail_CopyBase64StripLineBreaks` (5BDD) + `_NextPage` (5C52) | mirror of 11 around `Mail_Base64Decode`; decoded size = (n - 2*floor(n/66))/4*3; the copy helper drops the CR LF after 4-character groups; `Mail_Base64Stream_LoadArgs` (5747) is shared by 11 and 12 |

Corrections to earlier notes: `config/symbols/bank0F.tsv` says `Function_0F_561F` copies in chunks of `$3DB` bytes; the code clamps to **`$0E00`** (`ld bc,$0E00` at 0F:56CB).
The record layout written by the body parser (`{2,1,ptr}` first record, name 4 bytes only for type 3) is read from the emitters, not observed on a real message: "part record" is the
working term, the meaning of the first record's two constants is not proven.

## Bank 75 - Mobile Adapter SDK (`lib/mobile/main.asm`)

Neutral (11 HYPOTHESIS rows with ideas): `Function_75_5E31` (return-address continuation stub), `5F96` (checksum step), `673A` (2-instruction prefix of `MobileSDK_ResetRxWindow`, 8 callers),
`7E89` (unreferenced near-copy of `MobileSDK_ResendPacket`), `Data_75_6D62` (a lone `$C9`), and the labels `51CF`, `5404`, `5405`, `5789`, `656C`, `73BE` (sub-steps or stack-unwind stubs).
The other 26 mid-function global `Label_75_*` jump targets are not listed (branch tails of state handlers, see `naming_sdk.md` section 5).

## Bank 74 - HTML layout (`engine/html/`)

`Html_Layout_FlushListItem` (4F97), `Html_Layout_ListBlockBreak` (4FBE), `Html_Layout_AppendImageRecord` (532A), `Html_Layout_SkipPastFloats` (5348), `Html_Layout_CloseRunRecord` (5528): each is tied
to named callers (`Html_Tag_Ul/Ol/Li/Br`, `Html_Layout_PlaceImage`, `Html_Layout_WrapRun`) and to RAM fields they share with named layout routines; PROBABLE.  `Function_74_55BE`
and `57AD` stay neutral: executed in 16 scenarios, but the record fields they move (flag bit 7, alignment offsets, margins) are not decoded.  36 mid-function `Label_74_*` (and 28 `Label_65_*`) are untouched.

## Bank 73 - browser start choice (`engine/browser/start_choice.asm`, `gfx/browser/start_choice.asm`)

`Data_BrowserStart_StringIndexBank` (CONFIRMED, byte read by `Ticker_Start`, twin of `Data_MailMenu_StringIndexBank`) and the six joypad dispatch labels `BrowserStart_OnA/OnB/IgnoreSelect/IgnoreStart/Idle/InputLoop`
named after the twin bank-1D menu (`Idle` CONFIRMED by `JoypadDispatch` index 4; the A/B/Select/Start order is PROBABLE).  Neutral: `Function_73_6143` and `62D2/62DA/62E2` (getters and description-index
adjusters for flags C0F8/C0F9 that nothing writes; look like template residue), and the `Data_73_*` fragments that are interior pieces of the palette block / object animation records or tile-like blocks with no consumer.

## Bank 65 - startup / registration

`Password_ClearConfirmIfEdited` (4761, CONFIRMED: executed 148x in 8 scenarios after `Account_PasswordEntryScreen`), `Password_CopyConfirmToPassword` / `Password_CopyConfirmToNew` (46FF/471F, unreferenced siblings of
`Password_CompareEntries`), `Startup_VerifySaveDataSilent` (41AA, same callees as `Startup_VerifySaveData` without the error screen; only a raw far-call site).  Neutral: `Function_65_481A` (dead variant with a stale
`call $21A0`); `Notice_PageTable_RegistrationStartTextPointer`/`Notice_PageTable_ResumeRegistrationTextPointer` name the first and last text-pointer fields inside `Notice_PageTable`; the two fields are selected at `table + 4 + 6 * page id`, while the intervening bytes hold the other records' metadata.
**Correction:** the `config/symbols/bank65.tsv` row for `Function_65_4761` ("no caller") is stale; it is called at 65:43A1 and 65:4598.

## Bank 67 - settings / password change / adapter check

`PasswordChange_WaitCommPanelClose` (5CF4, identical to bank-68 `CommPanel_WaitClose` minus one store); the unreferenced dead-code twins `PhoneKeypad_ClearStoredBitsIfEdited`, `PhoneComment_ClearStoredBitIfEdited`,
`PhoneKeypad_UpdateStoredFlag`, `PhoneComment_UpdateStoredFlag`, `TextBuf_DecCount` (mirror executed or named siblings, PROBABLE at most); the unreferenced init-only clone `AdapterCheck_RunInitOnly` /
`AdapterCheck_InitOnly_*` (API $02 + $36 without the config read); and 15 state-handler / dispatch labels of `SettingsPhone_Read/WriteAdapterConfig`, `PasswordChange_*` and `AdapterCheck_Poll_Loop`
(table or dispatcher targets, executed in 1-3 scenarios).  Bank 68 has the same twin of `Function_68_52B2`; a later pass should use the matching name.

## Bank 7F - text canvas, glyphs, scroll split, comm hooks

* **Unreferenced "page-list prototype" (7F:4C78-61FC) is an earlier build of the released page list (bank 24).**  22 routines match a named `PageList_*` routine (similarity 0.38-1.0, five near-identical), the call order   of Main, Main_Loop and the action-menu loop is the same, the slot tables are the same six SRAM addresses.

`B3C3` (16, CONFIRMED): the jump targets of `Canvas_RemapTable`, index = B+4*C (`Canvas_RemapGlyphColors`), each simulated on a glyph row; two handlers do not do what   their index suggests (B=2,C=1 gives colours (2,3); B=1,C=2 gives (1,0)), recorded in the evidence.

* Canvas/glyph variants `Canvas_BlitGlyphLooped(ClipY)`, `Glyph_LoadAsciiSinglePlane`, `Glyph_LoadWideSinglePlane` (unreferenced twins), demo `Canvas_RunSampleDemo` / `Canvas_DrawSampleRows(Inverted)` and their strings and palette.

* `Palette_TextCursor_Obj`, `Table_TextCursor_ObjTables`, `Data_TextCursor_ObjAnimData` live in `gfx/unreferenced/page_list_prototype_objects.asm` but are **not** prototype resources: the address/profile/name editors load them for the   text-cursor sprites (consumer-based names).

Current source path (2026-10-21): `gfx/text_cursor/objects.asm`; the adjacent unresolved tile bytes were split to `gfx/unresolved/tiles_7f_7830.asm`.

On 2026-10-22 the remaining address-only owner/backing path became `gfx/unresolved/tile_graphics_candidate.asm` and `gfx/unresolved/tile_graphics_candidate/tiles_candidate.2bpp`.

* Neutral: `Function_7F_4E85` (`call Canvas_UploadToVram ; ret`), `61E6`/`61E7` (single `ret`), `Data_7F_4C77`/`51ED` (lone `$C9`), `UnresolvedTiles_7F_7830` (720-byte HYPOTHESIS tile candidate; no symbolic source reference or load address in reviewed code, no global unused claim).

## Open items

* Semantics still unproven: the two constants of the first body-parser record (0F), what the `Mode0/Mode1` parameter of the comm dialog selects (7F), the layout record fields moved by `Function_74_55BE/57AD`.
