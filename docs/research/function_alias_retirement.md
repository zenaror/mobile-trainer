# Retirement of colocated Function aliases

This pass retires 483 generic aliases already colocated with descriptive names in the
original-ROM source. The position proof is CONFIRMED by the baseline symbol map and
the exact adjacent label runs. It is not a claim that 483 previously unknown functions
have been identified, that all entries execute naturally, or that every existing name
expresses a complete ABI. Names and addresses are recorded below for historical lookup.

The source baseline is `e958ff4f39018412c7a2716dc92029f5d93e27d8`.
The maintained source supplies the operation/evidence comments. Historical rename and
coverage records remain evidence of the earlier analysis, not current entry guarantees.
No historical manifest or frozen generator was rewritten. Existing source lines are
preserved physically; each retired alias line becomes a blank line. Current operands,
source comments and RAM replay scopes use current identities. The 1,391 qualified local
symbols inherit the retained preceding global name; the exact old/current/address map is
recorded in the private proposal's DATA/LOCAL_SCOPE_MAP.json for ROOT's linked-symbol gate.

## Two bounded name corrections

`Function_7F_4000` / `Glyph_LoadAsciiSinglePlane` becomes
`Glyph_LoadContiguous12Bytes`. Entry remains HYPOTHESIS: the prior whole-ROM caller,
pointer and far-call search found no entry evidence. The 3-instruction entry calls
`Glyph_AsciiAddr` (7F:400E), `Glyph_CopyAsciiRowsSingle` (00:0DCE), then returns.
The copy operation is PROBABLE under the mapper, window, destination and stack
prerequisites, with no new natural execution claimed. The address helper selects
effective B in $20..$7F, otherwise $3F, and computes source
ROM76:$67A8 + 12 * (effectiveB - $20). It transfers input DE into destination HL.
The home helper copies 12 consecutive bytes, advances both pointers by 12 and selects
low ROM bank $7F after selecting $76; it updates hROMBankLo and $2100, without proving
all other mapping state or interrupt ownership. The output is not an interleaved
24-byte two-buffer layout. The old ASCII/plane wording did not establish such a layout
or a character-set contract. Sibling 7F:4007 and callee coverage does not prove 7F:4000.

`Function_7F_61FC` / `Stub_Nop_7F_61FC` becomes
`Stack_PushPopAFAndReturn`. The exact entry consists of PUSH AF / POP AF / RET at
7F:61FC..61FE. Historical entry execution remains CONFIRMED, while the old comment's
10-instruction extent included the neighboring Timer_ResetClockB at 7F:61FF and must
not be attributed solely to this 3-instruction entry. PUSH writes at entry SP-1 and
SP-2; matching AF restoration requires those writes and reads to address coherent,
visible writable memory. RET still consumes the return address. No unconditional AF,
stack visibility, interrupt-state or write-free-nop contract is asserted. Both maintained
call operands now use the operation name.

## Retained limitations

The other 7F holds are retained. 7F:4042 has BC-code/DE-base setup distinct from
7F:405F's HL-code/BC-left/DE-right setup. Coordinate remap and buffer ownership at
7F:42C3/49AE remain bounded; 7F:4AAF's F0..F4 top clipping can schedule wrapped or
zero counters, and early bottom return prevents an all-rows or safe-clipping promise.
The demo/prototype family does not establish chronology, natural root entries or all
paths; 7F:5CB4 returns before its legacy body and the known CALL NZ at 7F:61E6 has a
dead flag condition. Bank29 family entry/live-bank mapping remains unproved.

7F:70FD's repeated subtraction terminates only for Y congruent to $0D modulo 4;
the resulting D must also fit the eight-row Up3 table. Scroll tables use unchecked D/E.
7F:7271 leaves IME disabled and waits for LY=$64; step helpers EI explicitly rather
than restoring caller IME. The 7F:624F save copies 256 bytes, beyond 14*16=224 slot
bytes; sampled SVBK/shadow restoration requires coherence and continued stack visibility.
Mode1 zero-result behavior and Mode0 business meaning remain limited by existing
evidence. Mapper, stack, IRQ and input domains stay conditional. Mail-library Base64
size quirks remain unchanged; a calculation name is not an ideal-formula guarantee.

## Current replay identity and historical erratum

The two RAM scope endpoints and the ramop10/ramop11 manual proof/context references
track the current name. The old audit classified 334 generic metadata occurrences as
HISTORICAL_RENAME_OR_PROOF_RECORD. One is operational by identity:
analysis/naming2/ram12_residual_overlays.tsv line 6, column 5 says which function the
scope excludes, and must follow the line's column-3 endpoint. Thus 333 historical
occurrences remain literal and this one operational proof reference changes. This
corrects the classification; it does not erase the old audit or rewrite historical
rename manifests. Existing long comments retain their lines. The scope parser needs
the complete endpoint on ram/overlays.asm line 620 (105 columns), an explicit exception
to new-comment wrapping. New contract comments fit 100 columns with tabs counted as 4.

Two earlier stale source comments in engine/mail/body_editor.asm (lines 2213 and 2323)
also now use MailBody_ApplyDakutenU. They were outside the 483-alias cohort: no extra
alias is retired here. The maintained definition, baseline linked position 2D:553D and
config/symbols/bank2D.tsv's position/name row prove the identity; the frozen table and
historical research records remain unchanged.

The private proposal performs deterministic static checks only. ROOT must run the
native build, sym-check, original-ROM comparison and expected-symbol comparison before
claiming byte identity. Static success is not natural execution or hardware evidence.

## Old-to-current position map

Status below is the inherited adjacent source status; ABSENT means no adjacent tag,
not a newly assigned confidence. Existing qualified hypotheses remain in the source.

| Old alias | Current name | Bank:address | Inherited status |
|---|---|---|---|
| `Function_2F_7EBF` | `Abook_Run` | `2F:7EBF` | CONFIRMED |
| `Function_2F_7F5D` | `Abook_LoadSlotToBuffers` | `2F:7F5D` | CONFIRMED |
| `Function_2F_6D00` | `AbookAddr_Edit` | `2F:6D00` | CONFIRMED |
| `Function_2F_6F42` | `AbookAddr_CursorRightStep` | `2F:6F42` | CONFIRMED |
| `Function_2F_6F8C` | `AbookAddr_SetupScreen` | `2F:6F8C` | CONFIRMED |
| `Function_2F_723E` | `AbookAddr_DrawLine1_Pad` | `2F:723E` | CONFIRMED |
| `Function_2F_7325` | `AbookAddr_DrawLine_Pad` | `2F:7325` | CONFIRMED |
| `Function_2F_7365` | `Gfx_StartHDMAAtVBlank_2F_7365` | `2F:7365` | ABSENT |
| `Function_2F_7385` | `AbookAddr_GetCharPtr` | `2F:7385` | CONFIRMED |
| `Function_2F_73B8` | `AbookAddr_GetRowPtr` | `2F:73B8` | CONFIRMED |
| `Function_2F_75A0` | `AbookAddr_OpenKeyboard` | `2F:75A0` | CONFIRMED |
| `Function_2F_764D` | `AbookAddr_GetLength` | `2F:764D` | CONFIRMED |
| `Function_2C_56FE` | `AddrPick_Menu` | `2C:56FE` | CONFIRMED |
| `Function_2C_58AC` | `AddrPick_InitScreen` | `2C:58AC` | CONFIRMED |
| `Function_2C_5A12` | `AddrPick_RefreshSlotIcons_2C_5A12` | `2C:5A12` | PROBABLE |
| `Function_2C_5CA3` | `AddrPick_TestSlotEmpty_2C_5CA3` | `2C:5CA3` | ABSENT |
| `Function_2C_5CD2` | `AddrPick_SetListAreaAttrs` | `2C:5CD2` | ABSENT |
| `Function_2C_5E51` | `AddrPick_InitListAttrs` | `2C:5E51` | CONFIRMED |
| `Function_2C_5FB1` | `AddrPick_MoveNameHighlight_X28_2C_5FB1` | `2C:5FB1` | PROBABLE |
| `Function_2C_6032` | `AddrPick_MoveNameHighlight` | `2C:6032` | CONFIRMED |
| `Function_2C_60B3` | `AddrPick_DrawSlotNames` | `2C:60B3` | PROBABLE |
| `Function_2C_614D` | `AddrBook_DrawSlotName` | `2C:614D` | CONFIRMED |
| `Function_2C_64E0` | `AddrPick_CursorMoveEffect` | `2C:64E0` | CONFIRMED |
| `Function_2F_4000` | `AbookList_Run` | `2F:4000` | CONFIRMED |
| `Function_2F_4109` | `AbookList_CursorUp` | `2F:4109` | CONFIRMED |
| `Function_2F_4496` | `Abook_Clear16AtHlAndEditAddressBuf` | `2F:4496` | CONFIRMED |
| `Function_2F_44F2` | `AbookList_PlaceButtonCursor` | `2F:44F2` | CONFIRMED |
| `Function_2F_4942` | `AbookList_FlashSelectedMarker` | `2F:4942` | CONFIRMED |
| `Function_2F_4B4E` | `AbookList_DrawNames` | `2F:4B4E` | CONFIRMED |
| `Function_2F_4BAA` | `AbookList_DrawHelpText` | `2F:4BAA` | CONFIRMED |
| `Function_2F_4CA7` | `AbookList_SetHelpBoxAttr` | `2F:4CA7` | CONFIRMED |
| `Function_2A_73BB` | `AddrBook_SaveConfirm_DrawTextLine17` | `2A:73BB` | HYPOTHESIS |
| `Function_2A_747B` | `AddrBook_SaveConfirm_DrawTextLine17_BlitGlyphAdvance` | `2A:747B` | ABSENT |
| `Function_2A_748F` | `AddrBook_SaveConfirm_DrawTextLine17_BlitBlankAdvance` | `2A:748F` | ABSENT |
| `Function_2A_74A7` | `AddrBook_SaveConfirm_DrawTextLine25` | `2A:74A7` | HYPOTHESIS |
| `Function_2A_7567` | `AddrBook_SaveConfirm_DrawTextLine25_BlitGlyphAdvance` | `2A:7567` | ABSENT |
| `Function_2A_757B` | `AddrBook_SaveConfirm_DrawTextLine25_BlitBlankAdvance` | `2A:757B` | ABSENT |
| `Function_2C_741C` | `AddrScreenUnused_Run` | `2C:741C` | PROBABLE |
| `Function_2C_746F` | `AddrScreenUnused_InitScreen` | `2C:746F` | PROBABLE |
| `Function_2C_755C` | `AddrScreenUnused_DrawTextLine21` | `2C:755C` | ABSENT |
| `Function_2C_761C` | `AddrScreenUnused_DrawTextLine21_BlitGlyphAdvance` | `2C:761C` | ABSENT |
| `Function_2C_7630` | `AddrScreenUnused_DrawTextLine21_BlitBlankAdvance` | `2C:7630` | ABSENT |
| `Function_2C_7648` | `AddrScreenUnused_DrawTextLine25` | `2C:7648` | ABSENT |
| `Function_2C_7708` | `AddrScreenUnused_DrawTextLine25_BlitGlyphAdvance` | `2C:7708` | ABSENT |
| `Function_2C_771C` | `AddrScreenUnused_DrawTextLine25_BlitBlankAdvance` | `2C:771C` | ABSENT |
| `Function_4E_60A6` | `Browser_UploadTitleCanvas` | `4E:60A6` | CONFIRMED |
| `Function_4E_6172` | `IfA1_MapSram1A9EDBit7To19Or1A_DisableRam` | `4E:6172` | HYPOTHESIS |
| `Function_4C_47C4` | `Comm_DisconnectWithProgress` | `4C:47C4` | CONFIRMED |
| `Function_4E_6196` | `Browser_LoadFrameGraphics` | `4E:6196` | CONFIRMED |
| `Function_4E_6291` | `Browser_FrameStylePreview_LoadGraphics` | `4E:6291` | PROBABLE |
| `Function_4E_4000` | `Browser_FrameStylePreview_Run` | `4E:4000` | HYPOTHESIS |
| `Function_4E_45FE` | `Browser_FrameStylePreview_RevealStep` | `4E:45FE` | PROBABLE |
| `Function_4C_4B54` | `Browser_HistoryReset` | `4C:4B54` | CONFIRMED |
| `Function_4C_4B81` | `Browser_HistoryPushFrom` | `4C:4B81` | ABSENT |
| `Function_4C_4C4E` | `Browser_ClearCaches` | `4C:4C4E` | CONFIRMED |
| `Function_4C_4CF6` | `PageCache_Pop` | `4C:4CF6` | CONFIRMED |
| `Function_4C_4D6F` | `Browser_HistoryUndoPush` | `4C:4D6F` | ABSENT |
| `Function_72_6712` | `BrowserMenu_OpenThreeItem` | `72:6712` | CONFIRMED |
| `Function_72_689F` | `BrowserMenu_RunThreeItem` | `72:689F` | CONFIRMED |
| `Function_72_69F3` | `BrowserMenu_DrawItemThree` | `72:69F3` | CONFIRMED |
| `Function_24_42B0` | `Wram6_CopyGooUrlAndTitleToPageBuffers` | `24:42B0` | ABSENT |
| `Function_24_53FC` | `Stub_Nop_24_53FC` | `24:53FC` | PROBABLE |
| `Function_24_53FD` | `Stub_Nop_24_53FD` | `24:53FD` | CONFIRMED |
| `Function_4C_4000` | `Browser_LoadPage` | `4C:4000` | CONFIRMED |
| `Function_4C_46A6` | `Url_StripFragment` | `4C:46A6` | CONFIRMED |
| `Function_4E_5204` | `Browser_DrawTitleBar` | `4E:5204` | CONFIRMED |
| `Function_4E_52E7` | `Browser_RenderPage` | `4E:52E7` | CONFIRMED |
| `Function_4E_53A1` | `Browser_ScrollUpLine` | `4E:53A1` | CONFIRMED |
| `Function_4E_5423` | `Browser_SetScroll` | `4E:5423` | CONFIRMED |
| `Function_4E_55E8` | `Browser_FindVisibleLink` | `4E:55E8` | CONFIRMED |
| `Function_4C_4DB2` | `Browser_MapErrorToResult` | `4C:4DB2` | CONFIRMED |
| `Function_4C_4DFB` | `Browser_WrapImageInHtml` | `4C:4DFB` | CONFIRMED |
| `Function_4E_5CB6` | `Browser_LoadScrollbarGfx` | `4E:5CB6` | CONFIRMED |
| `Function_4E_5D70` | `Browser_ReloadFrameTilemap` | `4E:5D70` | PROBABLE |
| `Function_4E_5E11` | `Browser_DrawScrollbarTrack` | `4E:5E11` | CONFIRMED |
| `Function_73_5F17` | `Browser_StartChoiceScreen` | `73:5F17` | CONFIRMED |
| `Function_73_6143` | `ReadC0F8_Xor1` | `73:6143` | HYPOTHESIS |
| `Function_73_61D5` | `BrowserStart_DrawButtons` | `73:61D5` | CONFIRMED |
| `Function_73_6265` | `BrowserStart_AnimateFrame` | `73:6265` | CONFIRMED |
| `Function_73_62D2` | `BrowserStart_DescIndex_AdjustItem1` | `73:62D2` | CONFIRMED |
| `Function_73_62DA` | `BrowserStart_DescIndex_AdjustItem2` | `73:62DA` | ABSENT |
| `Function_73_62E2` | `BrowserStart_DescIndex_AdjustItem3` | `73:62E2` | ABSENT |
| `Function_4E_5FB9` | `Browser_DrawCommTimer` | `4E:5FB9` | CONFIRMED |
| `Function_4E_6087` | `ConnIcon_GetBrowserFramePos` | `4E:6087` | HYPOTHESIS |
| `Function_70_4000` | `CommScene_Init` | `70:4000` | CONFIRMED |
| `Function_70_4275` | `CommScene_ResetScroll` | `70:4275` | CONFIRMED |
| `Function_70_44B0` | `CommScene_LoadGraphics` | `70:44B0` | CONFIRMED |
| `Function_70_46A6` | `TrySetA9EEFromRandom16_ByA9EDFlags` | `70:46A6` | HYPOTHESIS |
| `Function_70_477F` | `CommScene_PlaceSpritePair` | `70:477F` | CONFIRMED |
| `Function_70_47BB` | `CommScene_SetSpritePair` | `70:47BB` | CONFIRMED |
| `Function_70_4803` | `CommScene_ShowTextBox` | `70:4803` | CONFIRMED |
| `Function_57_4000` | `ConnectDialog_Run` | `57:4000` | CONFIRMED |
| `Function_57_44E4` | `ConnectDialog_EnterMode` | `57:44E4` | CONFIRMED |
| `Function_57_45E6` | `ConnectDialog_LeaveMode` | `57:45E6` | CONFIRMED |
| `Function_57_47A6` | `ConnectDialog_DrawScreen` | `57:47A6` | CONFIRMED |
| `Function_57_510F` | `ConnectDialog_DrawPasswordField` | `57:510F` | CONFIRMED |
| `Function_57_541C` | `SavedPassword_Store` | `57:541C` | CONFIRMED |
| `Function_57_546C` | `ConnectDialog_PlayButtonSfx` | `57:546C` | CONFIRMED |
| `Function_69_4000` | `ConnIcon_Init` | `69:4000` | CONFIRMED |
| `Function_69_40D1` | `ConnIcon_LoadGraphicsIfRequested` | `69:40D1` | CONFIRMED |
| `Function_7F_61FC` | `Stack_PushPopAFAndReturn` | `7F:61FC` | CONFIRMED |
| `Function_7F_6218` | `CommNotice_ShowDialogMode1` | `7F:6218` | CONFIRMED |
| `Function_7F_6235` | `CommNotice_ShowDialogMode0` | `7F:6235` | ABSENT |
| `Function_51_404A` | `CommTime_DrawSummaryScreen` | `51:404A` | CONFIRMED |
| `Function_51_4239` | `CommTime_TimerAIsNonZero` | `51:4239` | CONFIRMED |
| `Function_72_4000` | `Dialog_ShowMonitored` | `72:4000` | CONFIRMED |
| `Function_72_43A7` | `Dialog_SetupCursorByType` | `72:43A7` | CONFIRMED |
| `Function_72_4578` | `Dialog_WaitInput` | `72:4578` | CONFIRMED |
| `Function_72_472B` | `Dialog_SaveBackground` | `72:472B` | CONFIRMED |
| `Function_5C_5150` | `CommErr_ShowScreen` | `5C:5150` | CONFIRMED |
| `Function_5C_5266` | `Stub_Nop_5C_5266` | `5C:5266` | ABSENT |
| `Function_5C_53B3` | `CommErr_DrawErrorNumber` | `5C:53B3` | CONFIRMED |
| `Function_5C_546F` | `CommErr_UpdateCommFooter` | `5C:546F` | CONFIRMED |
| `Function_5C_5504` | `CommErr_DrawFCategoryGlyph` | `5C:5504` | CONFIRMED |
| `Function_63_732F` | `NoAdapter_ShowScreen` | `63:732F` | CONFIRMED |
| `Function_4F_4000` | `Palette_LoadToBuffer` | `4F:4000` | CONFIRMED |
| `Function_4F_428E` | `Palette_CaptureAndFadeInFromWhite` | `4F:428E` | PROBABLE |
| `Function_4F_42B4` | `Palette_FadeInFromWhite` | `4F:42B4` | CONFIRMED |
| `Function_4F_434A` | `Palette_CaptureAndFadeOutToWhite` | `4F:434A` | PROBABLE |
| `Function_4F_4370` | `Palette_FadeOutToWhite` | `4F:4370` | CONFIRMED |
| `Function_4F_4400` | `Palette_CaptureAndFadeInFromBlackSlow` | `4F:4400` | PROBABLE |
| `Function_4F_4426` | `Palette_FadeInFromBlackSlow` | `4F:4426` | ABSENT |
| `Function_4F_4471` | `Palette_CaptureAndFadeOutToBlackSlow` | `4F:4471` | PROBABLE |
| `Function_4F_4497` | `Palette_FadeOutToBlackSlow` | `4F:4497` | ABSENT |
| `Function_4F_44DF` | `Palette_FadeInFromWhiteObjPalSlow` | `4F:44DF` | PROBABLE |
| `Function_4F_452A` | `Palette_FadeOutToWhiteObjPalSlow` | `4F:452A` | PROBABLE |
| `Function_7F_7271` | `Stat_EnableScrollSplit` | `7F:7271` | CONFIRMED |
| `Function_7F_733A` | `ScrollSplit_StepUp3` | `7F:733A` | CONFIRMED |
| `Function_7F_7425` | `ScrollSplit_StepUp4` | `7F:7425` | CONFIRMED |
| `Function_7F_7578` | `ScrollSplit_StepDown3` | `7F:7578` | CONFIRMED |
| `Function_7F_76C4` | `ScrollSplit_StepDown4` | `7F:76C4` | CONFIRMED |
| `Function_7F_7817` | `ScrollSplit_SetCursorSpritesY` | `7F:7817` | PROBABLE |
| `Function_4F_4572` | `TileCanvas_UploadRect` | `4F:4572` | CONFIRMED |
| `Function_29_5090` | `ClearLcdcBit2` | `29:5090` | HYPOTHESIS |
| `Function_29_5117` | `PalLibUnused_WaitLY90` | `29:5117` | ABSENT |
| `Function_29_511E` | `CallSelected7BB7_IfReturnsPollLyByFFA4Bit0` | `29:511E` | ABSENT |
| `Function_29_5145` | `PalLibUnused_DisableVBlankIrq` | `29:5145` | ABSENT |
| `Function_29_514F` | `PalLibUnused_EnableVBlankIrq` | `29:514F` | ABSENT |
| `Function_29_520D` | `PalLibUnused_ReadPalettesToBuffer` | `29:520D` | ABSENT |
| `Function_29_523F` | `PalLibUnused_WriteBufferToPalettes` | `29:523F` | ABSENT |
| `Function_29_529F` | `PalLibUnused_FadeStepTowardWhite` | `29:529F` | ABSENT |
| `Function_29_52ED` | `PalLibUnused_FadeStepTowardBlack` | `29:52ED` | ABSENT |
| `Function_29_5335` | `PalLibUnused_FillBufferFromBlock` | `29:5335` | ABSENT |
| `Function_6C_4000` | `HelpMenu_ShowPage` | `6C:4000` | CONFIRMED |
| `Function_6C_453D` | `HelpMenu_DrawItemSelected` | `6C:453D` | CONFIRMED |
| `Function_6C_4763` | `HelpMenu_ShowItemText` | `6C:4763` | CONFIRMED |
| `Function_6C_5987` | `HelpMenu_Run` | `6C:5987` | CONFIRMED |
| `Function_6C_6009` | `HelpScript_StepText` | `6C:6009` | CONFIRMED |
| `Function_6C_61AC` | `DecC0DA_OnZeroReload23ToggleC0D9AndSetDA20` | `6C:61AC` | PROBABLE |
| `Function_1A_4000` | `MobileDict_Run` | `1A:4000` | CONFIRMED |
| `Function_1A_42DE` | `MobileDict_DrawRowHighlight` | `1A:42DE` | CONFIRMED |
| `Function_1A_4391` | `MobileDict_LoadPage` | `1A:4391` | CONFIRMED |
| `Function_4C_4F56` | `MobileDictView_Show` | `4C:4F56` | CONFIRMED |
| `Function_4C_5274` | `MobileDictView_HistoryPush` | `4C:5274` | CONFIRMED |
| `Function_74_4F4F` | `Html_InitParser` | `74:4F4F` | CONFIRMED |
| `Function_74_4F97` | `Html_Layout_FlushListItem` | `74:4F97` | ABSENT |
| `Function_74_4FBE` | `Html_Layout_ListBlockBreak` | `74:4FBE` | ABSENT |
| `Function_74_5252` | `Html_Layout_ClearAllFloats` | `74:5252` | CONFIRMED |
| `Function_74_532A` | `Html_Layout_AppendImageRecord` | `74:532A` | ABSENT |
| `Function_74_5348` | `Html_Layout_SkipPastFloats` | `74:5348` | PROBABLE |
| `Function_74_537D` | `Html_LoadPageImages` | `74:537D` | CONFIRMED |
| `Function_74_5528` | `Html_Layout_CloseRunRecord` | `74:5528` | ABSENT |
| `Function_74_55BE` | `Html_Layout_AddRecordToLine` | `74:55BE` | ABSENT |
| `Function_74_5663` | `Html_Layout_PlaceLine` | `74:5663` | CONFIRMED |
| `Function_74_57AD` | `Html_Layout_BeginLineAndPlaceFloats` | `74:57AD` | ABSENT |
| `Function_74_5A96` | `Html_LinkTable_Init` | `74:5A96` | CONFIRMED |
| `Function_74_5AF8` | `Html_StringTable_Find` | `74:5AF8` | CONFIRMED |
| `Function_74_5B4F` | `Html_NextResourceRecord` | `74:5B4F` | CONFIRMED |
| `Function_74_5BA0` | `HtmlUrl_NormalizePath` | `74:5BA0` | CONFIRMED |
| `Function_74_4165` | `Html_MetaResultToError` | `74:4165` | CONFIRMED |
| `Function_74_4207` | `Html_ParsePage` | `74:4207` | CONFIRMED |
| `Function_74_4530` | `Html_StoreTitle` | `74:4530` | CONFIRMED |
| `Function_74_5969` | `HtmlUrl_GetSchemeId` | `74:5969` | CONFIRMED |
| `Function_74_5A76` | `HtmlUrl_FindLastSegmentDelimiter` | `74:5A76` | CONFIRMED |
| `Function_7D_7B7C` | `Joypad_ReadRaw` | `7D:7B7C` | CONFIRMED |
| `Function_55_5BA2` | `Kbd_Open` | `55:5BA2` | CONFIRMED |
| `Function_55_5F35` | `Kbd_FetchCell` | `55:5F35` | CONFIRMED |
| `Function_55_6041` | `Kbd_AdjustColRowForSticky` | `55:6041` | ABSENT |
| `Function_55_6068` | `Kbd_UpdateSticky` | `55:6068` | CONFIRMED |
| `Function_55_60D3` | `Kbd_StoreStickyCol` | `55:60D3` | ABSENT |
| `Function_55_60DA` | `Kbd_StoreStickyRow` | `55:60DA` | ABSENT |
| `Function_55_613D` | `Kbd_ClearStickyCol` | `55:613D` | ABSENT |
| `Function_55_6143` | `Kbd_ClearStickyRow` | `55:6143` | ABSENT |
| `Function_55_617B` | `Kbd_ClearSticky` | `55:617B` | ABSENT |
| `Function_55_6190` | `Kbd_UpdateCursorSprite` | `55:6190` | CONFIRMED |
| `Function_55_6318` | `Kbd_SlideIn` | `55:6318` | CONFIRMED |
| `Function_55_6427` | `Kbd_SlideOut` | `55:6427` | CONFIRMED |
| `Function_55_65DA` | `Kbd_TypePickerLoop` | `55:65DA` | CONFIRMED |
| `Function_55_66C6` | `Kbd_LoadPageGraphics` | `55:66C6` | CONFIRMED |
| `Function_55_6C10` | `Kbd_RequestGlyphRedraw` | `55:6C10` | CONFIRMED |
| `Function_7F_70FD` | `KbdSlide_InPrepMode6` | `7F:70FD` | CONFIRMED |
| `Function_55_6E94` | `Kbd_TypeHasPages` | `55:6E94` | CONFIRMED |
| `Function_55_6EAA` | `Kbd_TypeMode2DefaultCursorFlag` | `55:6EAA` | CONFIRMED |
| `Function_55_6EC0` | `Kbd_TypeArgCDefaultCursorFlag` | `55:6EC0` | CONFIRMED |
| `Function_55_6ED6` | `Kbd_TypeNeedsExtraPalette` | `55:6ED6` | CONFIRMED |
| `Function_55_6EEC` | `Kbd_Type6To10Flag` | `55:6EEC` | PROBABLE |
| `Function_55_6F02` | `Kbd_TypeHidesOnKey82` | `55:6F02` | CONFIRMED |
| `Function_55_6F18` | `Kbd_TypeHidesOnKey83` | `55:6F18` | CONFIRMED |
| `Function_55_6F2E` | `Kbd_TypeWaitsWithService` | `55:6F2E` | CONFIRMED |
| `Function_55_6FA1` | `Kbd_RejectSymbol` | `55:6FA1` | CONFIRMED |
| `Function_55_6FCD` | `Kbd_ShowMarkerSprite` | `55:6FCD` | CONFIRMED |
| `Function_55_7000` | `Kbd_HideMarkerSprite` | `55:7000` | CONFIRMED |
| `Function_2D_65B0` | `MailAddr_Edit` | `2D:65B0` | CONFIRMED |
| `Function_2D_6808` | `MailAddr_CursorRight` | `2D:6808` | CONFIRMED |
| `Function_2D_68A9` | `MailAddr_SetupScreen` | `2D:68A9` | CONFIRMED |
| `Function_2D_6C4C` | `MailAddr_DrawLine24_Pad` | `2D:6C4C` | CONFIRMED |
| `Function_2D_6C8C` | `Gfx_StartHDMAAtVBlank_2D_6C8C` | `2D:6C8C` | ABSENT |
| `Function_2D_6CDF` | `MailAddr_GetRowPtr` | `2D:6CDF` | CONFIRMED |
| `Function_2D_6F7B` | `MailAddr_RedrawAfterInsert` | `2D:6F7B` | CONFIRMED |
| `Function_2D_4722` | `MailBody_Edit` | `2D:4722` | CONFIRMED |
| `Function_2D_48DA` | `MailBody_CursorRight` | `2D:48DA` | CONFIRMED |
| `Function_2D_4942` | `MailBody_CursorUp` | `2D:4942` | CONFIRMED |
| `Function_2D_4968` | `MailBody_CursorDown` | `2D:4968` | CONFIRMED |
| `Function_2D_499E` | `MailBody_SetupScreen` | `2D:499E` | CONFIRMED |
| `Function_2D_4CA5` | `MailBody_PlaceCursorSprites` | `2D:4CA5` | CONFIRMED |
| `Function_2D_4E06` | `TextTiles_ClearBuffers` | `2D:4E06` | CONFIRMED |
| `Function_2D_4E8C` | `MailBody_GetCharPtr` | `2D:4E8C` | CONFIRMED |
| `Function_2D_4EC0` | `MailBody_GetRowPtr` | `2D:4EC0` | CONFIRMED |
| `Function_2D_4F03` | `MailBody_ProbeLastRow` | `2D:4F03` | CONFIRMED |
| `Function_2D_4F2F` | `MailBody_DrawRow` | `2D:4F2F` | CONFIRMED |
| `Function_2D_50B8` | `MailBody_InsertChar` | `2D:50B8` | CONFIRMED |
| `Function_2D_535C` | `MailBody_Backspace` | `2D:535C` | CONFIRMED |
| `Function_2D_5691` | `MailBody_KeyboardLoop` | `2D:5691` | CONFIRMED |
| `Function_2D_5A7B` | `MailBody_GetLength` | `2D:5A7B` | CONFIRMED |
| `Function_2D_5A98` | `MailBody_ReloadTiles` | `2D:5A98` | CONFIRMED |
| `Function_28_4000` | `MailBody_ViewScreen` | `28:4000` | CONFIRMED |
| `Function_28_429F` | `MailBody_BlitBlankCellAdvance` | `28:429F` | ABSENT |
| `Function_2D_4000` | `MailCompose_Run` | `2D:4000` | CONFIRMED |
| `Function_2B_4000` | `MailDraft_Menu` | `2B:4000` | CONFIRMED |
| `Function_2B_4421` | `MailDraft_DrawTextLine21` | `2B:4421` | CONFIRMED |
| `Function_2B_45E1` | `MailDraft_DrawTextLine25_BlitBlankAdvance` | `2B:45E1` | CONFIRMED |
| `Function_2B_46CD` | `MailDraft_DrawTextLine17_BlitBlankAdvance` | `2B:46CD` | CONFIRMED |
| `Function_2B_478B` | `MailDraft_Menu_SetCaption` | `2B:478B` | CONFIRMED |
| `Function_26_4000` | `MailSession_Run` | `26:4000` | CONFIRMED |
| `Function_26_4C94` | `MailSession_SetReceivedCountSprite` | `26:4C94` | CONFIRMED |
| `Function_26_4DAB` | `MailSession_SetNextReceivedCountSprite` | `26:4DAB` | ABSENT |
| `Function_26_4EC3` | `MailSession_CheckTimeWarning` | `26:4EC3` | CONFIRMED |
| `Function_26_50AC` | `MailSession_PollAdapterError` | `26:50AC` | CONFIRMED |
| `Function_26_5106` | `MailSession_CompareWordDeltas` | `26:5106` | ABSENT |
| `Function_26_5168` | `MailSession_InitScreen` | `26:5168` | CONFIRMED |
| `Function_26_56DB` | `MailSession_ShowMsgReceiving` | `26:56DB` | CONFIRMED |
| `Function_26_571F` | `MailSession_ShowMsgSent` | `26:571F` | PROBABLE |
| `Function_26_5763` | `MailSession_ShowMsgReceiveDone` | `26:5763` | PROBABLE |
| `Function_26_57A7` | `MailSession_ShowMsgNoMail` | `26:57A7` | CONFIRMED |
| `Function_26_5873` | `MailSession_ClearMsg` | `26:5873` | CONFIRMED |
| `Function_26_58B7` | `MailSession_UploadMsgTiles` | `26:58B7` | CONFIRMED |
| `Function_2C_4000` | `MailTitle_Entry` | `2C:4000` | CONFIRMED |
| `Function_2C_410F` | `MailTitle_MoveCursorRight` | `2C:410F` | CONFIRMED |
| `Function_2C_414C` | `MailTitle_InitScreen` | `2C:414C` | CONFIRMED |
| `Function_2C_4475` | `MailTitle_FindLine` | `2C:4475` | CONFIRMED |
| `Function_2C_493F` | `MailTitle_OpenKeyboard` | `2C:493F` | CONFIRMED |
| `Function_2C_4A05` | `MailTitle_GetLength` | `2C:4A05` | CONFIRMED |
| `Function_2B_64F1` | `Show0206_CallDeleteRecordIf1_Else64A7` | `2B:64F1` | HYPOTHESIS |
| `Function_2B_687C` | `Sprite_SetSlots1And2Y68XByC_InitSlot2` | `2B:687C` | HYPOTHESIS |
| `Function_25_4000` | `Mailbox_Main` | `25:4000` | CONFIRMED |
| `Function_25_4A90` | `Mailbox_CountRecords` | `25:4A90` | CONFIRMED |
| `Function_25_4B0D` | `Mailbox_LoadScreen` | `25:4B0D` | CONFIRMED |
| `Function_25_50C2` | `Mailbox_ClearTimestamp` | `25:50C2` | CONFIRMED |
| `Function_25_534C` | `Mailbox_UploadTextTiles` | `25:534C` | CONFIRMED |
| `Function_25_5848` | `Mailbox_IsRecordClosedEnvelope` | `25:5848` | ABSENT |
| `Function_29_4000` | `MailResult_Screen` | `29:4000` | CONFIRMED |
| `Function_29_4286` | `MailResult_ShowReceivedMessage` | `29:4286` | CONFIRMED |
| `Function_29_44F6` | `MailServerStatus_Screen` | `29:44F6` | CONFIRMED |
| `Function_29_49E5` | `MailServerStatus_NumberOffset_M0` | `29:49E5` | CONFIRMED |
| `Function_29_4D21` | `MailServerStatus_DrawCounts_Mode2` | `29:4D21` | CONFIRMED |
| `Function_29_4F77` | `MailServerStatus_NumberOffset_M2` | `29:4F77` | CONFIRMED |
| `Function_29_5017` | `MailResult_UploadTextTiles` | `29:5017` | CONFIRMED |
| `Function_27_4000` | `MailSendRecv_Main` | `27:4000` | CONFIRMED |
| `Function_27_41BC` | `Mail_OutboxIsEmpty` | `27:41BC` | CONFIRMED |
| `Function_27_41E3` | `MailConnect_Screen` | `27:41E3` | CONFIRMED |
| `Function_27_4747` | `MailConnect_PollAdapterError` | `27:4747` | CONFIRMED |
| `Function_27_4768` | `MailDisconnect_Screen` | `27:4768` | CONFIRMED |
| `Function_27_4B95` | `MailConnect_InitScreen` | `27:4B95` | CONFIRMED |
| `Function_27_4EC0` | `Gfx_UploadPalettesAndBgMaps_EnableLCD` | `27:4EC0` | PROBABLE |
| `Function_27_4FFB` | `CommTime_DrawNumber_27_4FFB` | `27:4FFB` | ABSENT |
| `Function_27_5021` | `CommTime_PutDigit_27_5021` | `27:5021` | ABSENT |
| `Function_2D_46A8` | `MailStaging_Clear` | `2D:46A8` | CONFIRMED |
| `Function_23_4B51` | `MailSrvDel_CheckAndDelete` | `23:4B51` | CONFIRMED |
| `Function_23_50CC` | `MailSrvDel_DeleteAllRun_TimeWarningPopup` | `23:50CC` | PROBABLE |
| `Function_23_5137` | `MailSrvDel_DeleteAllRun_TimeWarningPopupReading` | `23:5137` | ABSENT |
| `Function_23_54B1` | `MailSrvDel_DeleteCompletelyRun_TimeWarningPopup` | `23:54B1` | PROBABLE |
| `Function_22_48CD` | `MailSrvDelHidden_DrawTimerNumbers` | `22:48CD` | PROBABLE |
| `Function_22_4975` | `MailSrvDelHidden_FormatDecimalStr` | `22:4975` | ABSENT |
| `Function_22_4A97` | `MailSrvDelHidden_NumberOffset` | `22:4A97` | PROBABLE |
| `Function_22_4AF7` | `MailSrvDelHidden_UploadDecimalTiles` | `22:4AF7` | ABSENT |
| `Function_23_4000` | `MailSrvDel_MenuRun` | `23:4000` | CONFIRMED |
| `Function_23_41DC` | `MailSrvDel_MenuInit` | `23:41DC` | CONFIRMED |
| `Function_23_43C4` | `MailSrvDel_ShowDescCheck` | `23:43C4` | CONFIRMED |
| `Function_23_478E` | `MailSrvDel_UploadTextTiles` | `23:478E` | CONFIRMED |
| `Function_23_47BC` | `MailSrvDel_DrawTimerNumbers` | `23:47BC` | HYPOTHESIS |
| `Function_23_4864` | `MailSrvDel_FormatDecimalStr` | `23:4864` | ABSENT |
| `Function_23_4986` | `MailSrvDel_NumberOffset_23_4986` | `23:4986` | PROBABLE |
| `Function_23_49E6` | `MailSrvDel_UploadDecimalTiles` | `23:49E6` | ABSENT |
| `Function_23_6D61` | `Wram7_Write14To27AtD1E0` | `23:6D61` | HYPOTHESIS |
| `Function_23_6E58` | `MailSrvDel_MsgCancelled` | `23:6E58` | HYPOTHESIS |
| `Function_23_58C4` | `SpriteCounter_StubA` | `23:58C4` | CONFIRMED |
| `Function_23_58C5` | `SpriteCounter_A_DrawNumber` | `23:58C5` | HYPOTHESIS |
| `Function_23_59DA` | `SpriteCounter_A_DrawDigit10000` | `23:59DA` | ABSENT |
| `Function_23_5B02` | `SpriteCounter_A_DrawDigit1000` | `23:5B02` | ABSENT |
| `Function_23_5C2A` | `SpriteCounter_A_DrawDigit100` | `23:5C2A` | ABSENT |
| `Function_23_5D52` | `SpriteCounter_A_DrawDigit10` | `23:5D52` | ABSENT |
| `Function_23_5E7A` | `SpriteCounter_A_DrawDigit1` | `23:5E7A` | ABSENT |
| `Function_23_5FA2` | `SpriteCounter_StubB` | `23:5FA2` | CONFIRMED |
| `Function_23_5FA3` | `SpriteCounter_B_DrawNumber` | `23:5FA3` | HYPOTHESIS |
| `Function_23_60D1` | `SpriteCounter_B_DrawDigit10000` | `23:60D1` | ABSENT |
| `Function_23_61F9` | `SpriteCounter_B_DrawDigit1000` | `23:61F9` | ABSENT |
| `Function_23_6321` | `SpriteCounter_B_DrawDigit100` | `23:6321` | ABSENT |
| `Function_23_6449` | `SpriteCounter_B_DrawDigit10` | `23:6449` | ABSENT |
| `Function_23_6571` | `SpriteCounter_B_DrawDigit1` | `23:6571` | ABSENT |
| `Function_23_669A` | `SpriteCounter_C_DrawNumber` | `23:669A` | HYPOTHESIS |
| `Function_23_6799` | `SpriteCounter_C_DrawDigit10000` | `23:6799` | ABSENT |
| `Function_23_68C1` | `SpriteCounter_C_DrawDigit1000` | `23:68C1` | ABSENT |
| `Function_23_69E9` | `SpriteCounter_C_DrawDigit100` | `23:69E9` | ABSENT |
| `Function_23_6B11` | `SpriteCounter_C_DrawDigit10` | `23:6B11` | ABSENT |
| `Function_23_6C39` | `SpriteCounter_C_DrawDigit1` | `23:6C39` | ABSENT |
| `Function_2E_4000` | `MailServerMgr_Run` | `2E:4000` | CONFIRMED |
| `Function_2E_48F8` | `MailServerMgr_TimeWarningPopup` | `2E:48F8` | ABSENT |
| `Function_2E_4A7D` | `MailServerMgr_TimeWarningPopupRedraw` | `2E:4A7D` | ABSENT |
| `Function_2E_4B2E` | `MailServerMgr_SetupScreen` | `2E:4B2E` | CONFIRMED |
| `Function_2E_4EB1` | `Stub_Nop_2E_4EB1` | `2E:4EB1` | CONFIRMED |
| `Function_2E_4EB2` | `CallVBlankWait60Times` | `2E:4EB2` | HYPOTHESIS |
| `Function_2E_4F9A` | `BlitOneGlyphIfCellsLeft_JumpToRet4F99` | `2E:4F9A` | HYPOTHESIS |
| `Function_2E_533C` | `MailServerMgr_ClearTextTiles` | `2E:533C` | CONFIRMED |
| `Function_2E_5478` | `MailServerMgr_UploadMessageTiles` | `2E:5478` | CONFIRMED |
| `Function_2E_55FA` | `MailServerMgr_UpdateTimerDisplay` | `2E:55FA` | CONFIRMED |
| `Function_1C_4000` | `Main_Run` | `1C:4000` | CONFIRMED |
| `Function_7C_7B7C` | `Nav_TitleStart` | `7C:7B7C` | CONFIRMED |
| `Function_7C_7D8D` | `InitStep70_EntryAThen1Then2_Jump7D82` | `7C:7D8D` | PROBABLE |
| `Function_1D_4000` | `MailMenu_Run` | `1D:4000` | CONFIRMED |
| `Function_1D_4325` | `MailMenu_DrawItemSelected` | `1D:4325` | CONFIRMED |
| `Function_1D_439B` | `MailMenu_AnimateIcon` | `1D:439B` | CONFIRMED |
| `Function_1F_4000` | `TopMenu_Run` | `1F:4000` | CONFIRMED |
| `Function_1F_4351` | `TopMenu_LoadPanel` | `1F:4351` | CONFIRMED |
| `Function_1F_4561` | `TopMenu_UpdateCursorMove` | `1F:4561` | CONFIRMED |
| `Function_54_4000` | `Mobile_ResetCommandTimer` | `54:4000` | CONFIRMED |
| `Function_54_403D` | `Mobile_SessionInit` | `54:403D` | CONFIRMED |
| `Function_54_4141` | `Mobile_BeginConnect` | `54:4141` | CONFIRMED |
| `Function_54_41C5` | `Mobile_InitTaskStateKind1` | `54:41C5` | PROBABLE |
| `Function_54_423C` | `Mobile_BeginCancel` | `54:423C` | CONFIRMED |
| `Function_54_42FB` | `Http_StartPost` | `54:42FB` | CONFIRMED |
| `Function_54_44AC` | `Mobile_CheckTimeout` | `54:44AC` | CONFIRMED |
| `Function_54_521F` | `Mail_SkipToDigit` | `54:521F` | ABSENT |
| `Function_54_522A` | `Mail_SkipSpaces` | `54:522A` | ABSENT |
| `Function_54_5231` | `Mail_CountDigits` | `54:5231` | ABSENT |
| `Function_54_5240` | `Mail_ApplyTimezoneOffset` | `54:5240` | ABSENT |
| `Function_54_4FD2` | `Mail_SplitFromHeader` | `54:4FD2` | CONFIRMED |
| `Function_54_50FC` | `Mail_CopyClampedEllipsis` | `54:50FC` | ABSENT |
| `Function_54_511D` | `Mail_ScanAndCheckGameMail` | `54:511D` | CONFIRMED |
| `Function_54_485C` | `Pop3_StartLogin` | `54:485C` | CONFIRMED |
| `Function_54_489B` | `Pop3_LoginStatPoll` | `54:489B` | CONFIRMED |
| `Function_54_4726` | `Smtp_MeasureField` | `54:4726` | ABSENT |
| `Function_54_4736` | `Smtp_CopyFieldToWork` | `54:4736` | ABSENT |
| `Function_54_4748` | `Smtp_CopyDisplayName` | `54:4748` | CONFIRMED |
| `Function_54_484A` | `Smtp_MeasureBody` | `54:484A` | CONFIRMED |
| `Function_2A_5495` | `Profile_Edit` | `2A:5495` | CONFIRMED |
| `Function_2A_577F` | `Profile_MoveCursorRight` | `2A:577F` | CONFIRMED |
| `Function_2A_57BD` | `Profile_InitScreen` | `2A:57BD` | CONFIRMED |
| `Function_2A_5C8F` | `Profile_FindLine` | `2A:5C8F` | CONFIRMED |
| `Function_2A_6148` | `Profile_KeyboardLoop` | `2A:6148` | CONFIRMED |
| `Function_2A_6257` | `Profile_LoadAndDraw` | `2A:6257` | CONFIRMED |
| `Function_67_6369` | `AdapterCheck_DrawScreen` | `67:6369` | CONFIRMED |
| `Function_67_58CD` | `PasswordChange_Run` | `67:58CD` | CONFIRMED |
| `Function_67_5A3E` | `PasswordChange_Communicate` | `67:5A3E` | CONFIRMED |
| `Function_67_5CF4` | `PasswordChange_WaitCommPanelClose` | `67:5CF4` | CONFIRMED |
| `Function_67_5E7D` | `PasswordChange_BuildRequestBody` | `67:5E7D` | CONFIRMED |
| `Function_67_5ED1` | `AdapterCheck_RunInitOnly` | `67:5ED1` | HYPOTHESIS |
| `Function_67_5EF1` | `AdapterCheck_InitOnly_Poll` | `67:5EF1` | ABSENT |
| `Function_67_5F54` | `Net_CopyDefaultDnsPair` | `67:5F54` | CONFIRMED |
| `Function_67_66A6` | `PwSaveConfirm_PlaceCursor` | `67:66A6` | CONFIRMED |
| `Function_67_66C2` | `PwSaveConfirm_BuildTextMap` | `67:66C2` | CONFIRMED |
| `Function_67_4940` | `PhoneComment_ClearStoredBitIfEdited` | `67:4940` | HYPOTHESIS |
| `Function_67_4BC2` | `PhoneComment_UpdateStoredFlag` | `67:4BC2` | HYPOTHESIS |
| `Function_67_4156` | `SettingsPhone_ResetTopCursor` | `67:4156` | CONFIRMED |
| `Function_67_424A` | `PhoneKeypad_ClearStoredBitsIfEdited` | `67:424A` | HYPOTHESIS |
| `Function_67_4571` | `PhoneKeypad_UpdateStoredFlag` | `67:4571` | HYPOTHESIS |
| `Function_67_67DB` | `TextBuf_DecCount` | `67:67DB` | HYPOTHESIS |
| `Function_67_6807` | `TextBuf_GetCount` | `67:6807` | CONFIRMED |
| `Function_67_626F` | `UsageFee_Run` | `67:626F` | CONFIRMED |
| `Function_67_62D5` | `UsageFee_Request` | `67:62D5` | CONFIRMED |
| `Function_67_60BA` | `UsageTime_Run` | `67:60BA` | CONFIRMED |
| `Function_67_611C` | `PasswordPrompt_Ask` | `67:611C` | CONFIRMED |
| `Function_67_6205` | `Net_BuildLoginPostBody` | `67:6205` | CONFIRMED |
| `Function_7F_624F` | `Sprites_SaveSlotsToBank3` | `7F:624F` | CONFIRMED |
| `Function_48_4899` | `Sram_VerifyChecksum3` | `48:4899` | CONFIRMED |
| `Function_48_48BB` | `Stub_Nop_48_48BB` | `48:48BB` | CONFIRMED |
| `Function_48_48BC` | `Sram_VerifyChecksum3ResetOnMismatch` | `48:48BC` | HYPOTHESIS |
| `Function_48_48E1` | `Sram_ComputeChecksum3` | `48:48E1` | CONFIRMED |
| `Function_22_4EF0` | `SramCheck_Bank0PageSum` | `22:4EF0` | CONFIRMED |
| `Function_22_5093` | `SramCheck_CompareDEHL2` | `22:5093` | CONFIRMED |
| `Function_48_4AAB` | `Sram_ClearMenuCursorMemory` | `48:4AAB` | CONFIRMED |
| `Function_4E_4658` | `Sram_SnapshotA9F0PairsAtBoot` | `4E:4658` | CONFIRMED |
| `Function_4E_4739` | `SaveCheck_Sum16` | `4E:4739` | CONFIRMED |
| `Function_4E_47EB` | `Sram_BuildA9F0DeltaBlock` | `4E:47EB` | HYPOTHESIS |
| `Function_4E_4866` | `Sram_CountMobileError12Or26` | `4E:4866` | CONFIRMED |
| `Function_48_4616` | `WriteByteFar` | `48:4616` | CONFIRMED |
| `Function_4F_4717` | `Boot_ClearAndInit` | `4F:4717` | CONFIRMED |
| `Function_65_487C` | `Notice_ShowPage` | `65:487C` | CONFIRMED |
| `Function_65_4AD7` | `Notice_DrawPageCounter` | `65:4AD7` | CONFIRMED |
| `Function_65_4BA8` | `Notice_RequestPageSound` | `65:4BA8` | CONFIRMED |
| `Function_65_4123` | `Registration_ReadStage` | `65:4123` | CONFIRMED |
| `Function_65_41AA` | `Startup_VerifySaveDataSilent` | `65:41AA` | PROBABLE |
| `Function_65_41DA` | `Registration_Run` | `65:41DA` | CONFIRMED |
| `Function_65_46FF` | `Password_CopyConfirmToPassword` | `65:46FF` | HYPOTHESIS |
| `Function_65_471F` | `Password_CopyConfirmToNew` | `65:471F` | HYPOTHESIS |
| `Function_65_473F` | `Password_CompareEntries` | `65:473F` | CONFIRMED |
| `Function_65_4761` | `Password_ClearConfirmIfEdited` | `65:4761` | ABSENT |
| `Function_65_481A` | `Startup_VerifySaveDataDeadVariant` | `65:481A` | PROBABLE |
| `Function_65_4000` | `Startup_Run` | `65:4000` | CONFIRMED |
| `Function_7F_42C3` | `Canvas_BlitGlyph` | `7F:42C3` | CONFIRMED |
| `Function_7F_49AE` | `Canvas_BlitGlyphLooped` | `7F:49AE` | PROBABLE |
| `Function_7F_4AAF` | `Canvas_BlitGlyphLoopedClipY` | `7F:4AAF` | ABSENT |
| `Function_7F_4C42` | `Glyph_LoadDottedLine` | `7F:4C42` | CONFIRMED |
| `Function_7E_7D19` | `Charset_ConvertPage` | `7E:7D19` | CONFIRMED |
| `Function_48_4748` | `Font_BlitGlyph8x16` | `48:4748` | CONFIRMED |
| `Function_7F_4000` | `Glyph_LoadContiguous12Bytes` | `7F:4000` | HYPOTHESIS |
| `Function_7F_4007` | `Glyph_LoadAscii` | `7F:4007` | CONFIRMED |
| `Function_7F_4042` | `Glyph_LoadWideSinglePlane` | `7F:4042` | PROBABLE |
| `Function_7F_405F` | `Glyph_LoadWide` | `7F:405F` | CONFIRMED |
| `Function_7F_41A7` | `Glyph_IsSjisLeadByte` | `7F:41A7` | CONFIRMED |
| `Function_63_4000` | `Font_ValidateSjisCode` | `63:4000` | CONFIRMED |
| `Function_48_4000` | `Divide8` | `48:4000` | CONFIRMED |
| `Function_0E_4000` | `Title_Run` | `0E:4000` | CONFIRMED |
| `Function_0E_4215` | `Title_LoadTitleScreen` | `0E:4215` | CONFIRMED |
| `Function_0E_4334` | `Title_PlaceCursor` | `0E:4334` | CONFIRMED |
| `Function_0E_434F` | `Title_LoadLogoScreen` | `0E:434F` | CONFIRMED |
| `Function_48_4A8C` | `Tilemap_ApplyMaskRect_48_4A8C` | `48:4A8C` | HYPOTHESIS |
| `Function_7F_4C78` | `Canvas_RunSampleDemo` | `7F:4C78` | PROBABLE |
| `Function_7F_4D95` | `Canvas_DrawSampleRows` | `7F:4D95` | PROBABLE |
| `Function_7F_4E0D` | `Canvas_DrawSampleRowsInverted` | `7F:4E0D` | PROBABLE |
| `Function_7F_4E85` | `Canvas_UploadToVramWrapper` | `7F:4E85` | PROBABLE |
| `Function_7F_4FDB` | `PageListProto_Main` | `7F:4FDB` | PROBABLE |
| `Function_7F_5011` | `PageListProto_Main_Loop` | `7F:5011` | ABSENT |
| `Function_7F_51EE` | `PageListProto_InitScreen` | `7F:51EE` | PROBABLE |
| `Function_7F_5306` | `PageListProto_UpdateRowSprites` | `7F:5306` | ABSENT |
| `Function_7F_530F` | `PageListProto_InitRowSprites` | `7F:530F` | ABSENT |
| `Function_7F_546A` | `PageListProto_HighlightRowSprite` | `7F:546A` | ABSENT |
| `Function_7F_5647` | `PageListProto_GetActionAvailability` | `7F:5647` | ABSENT |
| `Function_7F_56AE` | `PageListProto_SetActionIcons` | `7F:56AE` | ABSENT |
| `Function_7F_56F1` | `PageListProto_RedrawSelection` | `7F:56F1` | ABSENT |
| `Function_7F_577D` | `PageListProto_DrawAllTitles` | `7F:577D` | ABSENT |
| `Function_7F_5805` | `PageListProto_DrawTextLine` | `7F:5805` | ABSENT |
| `Function_7F_58A5` | `PageListProto_BlitGlyphAdvance` | `7F:58A5` | ABSENT |
| `Function_7F_58B9` | `PageListProto_UploadTextTiles` | `7F:58B9` | ABSENT |
| `Function_7F_58F9` | `PageListProto_StartHDMAAtVBlank` | `7F:58F9` | ABSENT |
| `Function_7F_591E` | `PageListProto_ShowMessage` | `7F:591E` | ABSENT |
| `Function_7F_5989` | `PageListProto_ActionMenu` | `7F:5989` | ABSENT |
| `Function_7F_5BB5` | `PageListProto_ActionMenuInit` | `7F:5BB5` | ABSENT |
| `Function_7F_5C13` | `PageListProto_HideActionCursor` | `7F:5C13` | ABSENT |
| `Function_7F_5C39` | `PageListProto_SetActionCursor` | `7F:5C39` | ABSENT |
| `Function_7F_5CB4` | `PageListProto_MoveActionCursor` | `7F:5CB4` | ABSENT |
| `Function_7F_5D0A` | `PageListProto_SaveCurrentPage` | `7F:5D0A` | ABSENT |
| `Function_7F_5F5D` | `PageListProto_GoToSlot` | `7F:5F5D` | ABSENT |
| `Function_7F_5FBC` | `PageListProto_DeleteSlot` | `7F:5FBC` | ABSENT |
| `Function_7F_61E6` | `Stub_Nop_7F_61E6` | `7F:61E6` | ABSENT |
| `Function_7F_61E7` | `Stub_Nop_7F_61E7` | `7F:61E7` | ABSENT |
| `Function_0F_4416` | `Mail_FindHeader_Scan` | `0F:4416` | ABSENT |
| `Function_0F_486B` | `Mail_PartRec_EmitHeaderBlock` | `0F:486B` | CONFIRMED |
| `Function_0F_48BD` | `Mail_PartRec_EmitHeaderBlock_NextPage` | `0F:48BD` | ABSENT |
| `Function_0F_48C6` | `Mail_PartRec_EmitLengthAndPart` | `0F:48C6` | CONFIRMED |
| `Function_0F_4948` | `Mail_PartRec_EmitLengthAndPart_NextPage` | `0F:4948` | ABSENT |
| `Function_0F_4951` | `Mail_PartRec_EmitPart` | `0F:4951` | CONFIRMED |
| `Function_0F_49C7` | `Mail_PartRec_EmitPart_NextPage` | `0F:49C7` | ABSENT |
| `Function_0F_49D0` | `Mail_PartRec_EmitLength` | `0F:49D0` | CONFIRMED |
| `Function_0F_4A13` | `Mail_PartRec_EmitLength_NextPage` | `0F:4A13` | ABSENT |
| `Function_0F_52BC` | `Mail_ComposeHeaderBlock` | `0F:52BC` | ABSENT |
| `Function_0F_5381` | `Mail_ComposeHeaderBlock_LoadArgs` | `0F:5381` | ABSENT |
| `Function_0F_53B9` | `Mail_ComposeHeaderBlock_FetchItem` | `0F:53B9` | ABSENT |
| `Function_0F_53D6` | `Mail_ComposeHeaderBlock_BuildAddressList` | `0F:53D6` | ABSENT |
| `Function_0F_54D8` | `Mail_ComposeMimeBody` | `0F:54D8` | ABSENT |
| `Function_0F_55C4` | `Mail_ComposeMimeBody_LoadArgs` | `0F:55C4` | ABSENT |
| `Function_0F_55E6` | `Mail_ComposeMimeBody_NextPart` | `0F:55E6` | ABSENT |
| `Function_0F_561F` | `Mail_ComposeMimeBody_CopyData` | `0F:561F` | ABSENT |
| `Function_0F_56E1` | `Mail_Base64EncodeStream` | `0F:56E1` | ABSENT |
| `Function_0F_5747` | `Mail_Base64Stream_LoadArgs` | `0F:5747` | ABSENT |
| `Function_0F_5771` | `Mail_CalcBase64EncodedSize` | `0F:5771` | ABSENT |
| `Function_0F_57E5` | `Mail_Base64EncodeStream_ClampChunk` | `0F:57E5` | ABSENT |
| `Function_0F_5833` | `Mail_Base64EncodeStream_Step` | `0F:5833` | ABSENT |
| `Function_0F_5A10` | `Mail_Base64DecodeStream` | `0F:5A10` | ABSENT |
| `Function_0F_5A74` | `Mail_CalcBase64DecodedSize` | `0F:5A74` | ABSENT |
| `Function_0F_5AC5` | `Mail_Base64DecodeStream_ClampChunk` | `0F:5AC5` | ABSENT |
| `Function_0F_5B15` | `Mail_Base64DecodeStream_Step` | `0F:5B15` | ABSENT |
| `Function_0F_5BDD` | `Mail_CopyBase64StripLineBreaks` | `0F:5BDD` | ABSENT |
| `Function_0F_5C52` | `Mail_CopyBase64StripLineBreaks_NextPage` | `0F:5C52` | ABSENT |
