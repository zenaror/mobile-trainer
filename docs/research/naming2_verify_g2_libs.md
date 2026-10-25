# reference 2, group 2 (libraries): adversarial reference

## 2. What was checked

Random PROBABLE sample (seed 20260930) - `PageListProto_Tiles_66B0`, `PageListProto_GoToSlot`, `TextBuf_DecCount`, `Canvas_BlitGlyphLoopedClipY`, `String_Canvas_SampleSentence_7F_4DF2`,
`Mail_PartRec_EmitPart`, `Mail_ComposeHeaderBlock_BuildAddressList`, `Password_CopyConfirmToPassword`, `PageListProto_Tilemap_67D0`, `String_Sample_PageNames_3_5` - all upheld (rows 1, 14, 16, 35,
36, 40, 41).

The other CONFIRMED rows (`Canvas_Remap_B1C0/B2C0/B3C0/B0C1/B0C2/B0C3`, `MobileSDK_Base64DecodeChar`, `MobileStr_HdrDate`, `Data_BrowserStart_StringIndexBank`, `BrowserStart_Idle`, `PasswordChange_Communicate_Dispatch`, `Password_ClearConfirmIfEdited`) are executed and their role is visible: upheld.

`MobilePacket_TransferData_Tail`: "the template is copied with B=$0B by the TransferData builders" is false (copies use B=5/6; the tail is never read).

`PageListProto_ShowMessage`: "opcode/operand-shape match 0.35" is correct, but the routine is a tile-image loader, not a text renderer like the twin (row 2). 5.

## 5. Notes that are not naming errors

* `ram/*.asm` still names `$D023` as `wRam_D023` inside the selector 12 routines but `wMail_ComposeState` in selector 11 (alias of the same byte); `wBank4DeferredCall` is used as the header index in
  `Mail_ComposeHeaderBlock`/`Mail_ComposeMimeBody` and `wMail_ItemListPointer+1` as the part type in `Mail_PartRec_*`: RAM names from another pass that read oddly next to the new routine names.
* The docs statement "22 routines match a named `PageList_*` routine (similarity 0.38-1.0)" is reproduced (22 pairs); with operands masked the range is 0.22 (ShowMessage) to 1.0.
* `Mail_SelectorTable` ordering and the state numbers `$28/$29/$2A` (Cancel/Timeout/Abort) were re-derived from the tables and agree with the new names.
