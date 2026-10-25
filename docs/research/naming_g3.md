# reference g3: banks 2A, 2B, 2C (the mail application UI)

### 1.1 What the three banks are

| bank | contents (screens) | main entry points |
|---|---|---|
| 2A | "save the sender's address" screen (pick an address-book slot for the sender of a received mail); the **profile** (nickname) editor with the kana keyboard; the address-book "save entry?" confirmation | `SaveSenderAddr_Menu` 2A:4000, `Profile_Edit` 2A:5495, `AddrBook_SaveConfirm` 2A:6F95 |
| 2B | the menu of the saved draft ("written mail": view / edit / delete); the two pages of the **received mail viewer** (page 1 sender/title/address/date, page 2 body text); an unused 12-cell 'もらったメール' (received mail) grid screen | `MailDraft_Menu` 2B:4000, `MailView_SenderPage` 2B:6482, `MailView_BodyPage` 2B:7B02 |
| 2C | the **mail title (subject) entry** with the kana keyboard; the **address picker** (choose one of the six address-book slots while writing a mail); shared address-book helpers (draw a slot name, upload the text tiles); palettes/tiles shared with bank 2F | `MailTitle_Entry` 2C:4000, `AddrPick_Menu` 2C:56FE, `AddrBook_DrawSlotName` 2C:614D, `AddrBook_UploadTextTiles` 2C:665F |

### 1.3 Screen flows (derived from the code; scenario and screenshot support in 1.2)

```
mail menu (7C) --"プロフィール"--------------> Profile_Edit (2A:5495)             [A=0; first-run tutorial (48) calls it with A=1]
               --"メールをかくにん"----------> MailDraft_Menu (2B:4000)
                                                 icon 0 -> farcall 28:4000 (view the draft)
                                                 icon 1 -> MailDraft_Edit (2B:4743): 2D:65B0 address -> 2C:4000 title -> 2D:4722 body
                                                 icon 2 -> yes/no (72:4015 DE=$0209) -> 2D:40DC clears the draft
mailbox list (25) --A on a mail--> MailView_SenderPage (2B:6482) --A--> MailView_BodyPage (2B:7B02) (A on the body page returns 0, B returns $FF; in both cases the caller 25:475C returns to the mailbox list: $FF -> list loop 25:411E, 0 -> reopens the list via 25:4000)
                                          |--SELECT--> SaveSenderAddr_Menu (2A:4000) --A--> SaveSenderAddr_SaveToSlot (2A:4312)
compose (2D:4000) --> 2D:65B0 (address) --SELECT--> AddrPick_Menu (2C:56FE) ; --> MailTitle_Entry (2C:4000) --> 2D:4722 (body)
address book (2F) --edit/add--> AddrBook_SaveConfirm (2A:6F95) --yes--> AddrBook_StoreEditBufferToSlot (2A:704B)
```

### 2.5 Input conventions

`hJoyPressed` bits: `$01` A, `$02` B, `$04` SELECT, `$08` START, `$10` Right, `$20` Left, `$40` Up, `$80` Down; `hJoyPressedRepeat` adds auto-repeat for the d-pad (used for all cursor movement).

### 2.6 Sound calls (observation, no name)

`00:20AC` is called with a constant `BC` at every user-visible event (stub into bank 04, sound driver per boot_and_home.md, unproven).  Values and contexts in these banks:
`$29` list cursor Up/Down and menu Left/Right, `$2C` A / confirm (menu selection, keyboard exit, slot chosen), `$2E` B / cancel, `$31` refusal (buffer full, empty slot, no kana match),
`$32` saved (address-book save), `$33` draft deleted, `$36` text-cursor Left/Right, `$38` kana inserted, `$39` kana deleted.  The `00:20E8` stub is called with `BC` = 4..$F once at the end of each screen set-up (di/ei around it).

## 3. Named symbols

Tables are generated from the three symbol files (status and evidence as in the TSVs).  Function-like names are `Prefix_Role`; helpers of the draw-string family end in `_BlitGlyphAdvance` / `_BlitBlankAdvance`.
Generic region labels (`Function_2A_5495`, `Table_2A_4214`, ...) still exist at the same addresses as aliases and can be dropped from `config/regions` by the orchestrator.

#### Save-the-sender-address screen (2A:4000)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:4000 | `SaveSenderAddr_Menu` | function | CONFIRMED |
| 2A:4027 | `SaveSenderAddr_Menu_Loop` | label | CONFIRMED |
| 2A:40BB | `SaveSenderAddr_CursorDown` | function | PROBABLE |
| 2A:40E0 | `SaveSenderAddr_CursorUp` | function | PROBABLE |
| 2A:4105 | `SaveSenderAddr_InitScreen` | function | CONFIRMED |
| 2A:4214 | `Table_SaveSenderAddr_MailRecAddrs_Init` | table | PROBABLE |
| 2A:422C | `SaveSenderAddr_DrawSlotNames` | function | CONFIRMED |
| 2A:4274 | `Table_SaveSenderAddr_SlotAddrs_DrawNames` | table | CONFIRMED |
| 2A:4280 | `SaveSenderAddr_MoveNameHighlight` | function | CONFIRMED |
| 2A:4306 | `Table_SaveSenderAddr_SlotAddrs_Highlight` | table | CONFIRMED |
| 2A:4312 | `SaveSenderAddr_SaveToSlot` | function | CONFIRMED |
| 2A:445F | `Table_SaveSenderAddr_SlotAddrs_Save` | table | CONFIRMED |
| 2A:446B | `Table_SaveSenderAddr_MailRecAddrs_Save` | table | PROBABLE |
| 2A:4483 | `SaveSenderAddr_DrawSenderName` | function | CONFIRMED |
| 2A:4547 | `SaveSenderAddr_DrawSenderName_BlitGlyphAdvance` | function | CONFIRMED |
| 2A:455B | `SaveSenderAddr_DrawSenderName_BlitBlankAdvance` | function | CONFIRMED |
| 2A:4573 | `SaveSenderAddr_RefreshSlotIcons` | function | CONFIRMED |
| 2A:480C | `SaveSenderAddr_IsSlotUsed` | function | CONFIRMED |
| 2A:483B | `Table_SaveSenderAddr_SlotAddrs_IsUsed` | table | CONFIRMED |
| 2A:4847 | `SaveSenderAddr_CursorMoveEffect` | function | PROBABLE |
| 2A:49C5 | `SaveSenderAddr_LoadCaption` | function | CONFIRMED |
| 2A:4A66 | `String_SaveSenderAddr_Caption` | string | PROBABLE |
| 2A:4AA0 | `Gfx_SaveSenderAddr_Tiles9300` | data | PROBABLE |
| 2A:4CD0 | `Data_SaveSenderAddr_TilemapAttr` | data | PROBABLE |
| 2A:4FA0 | `Palette_SaveSenderAddr_Bg` | data | PROBABLE |

#### Profile / nickname editor (2A:5495)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:5495 | `Profile_Edit` | function | CONFIRMED |
| 2A:54FD | `Profile_Edit_Loop` | label | CONFIRMED |
| 2A:5744 | `Profile_CursorLeft` | function | CONFIRMED |
| 2A:576B | `Profile_CursorRight` | function | CONFIRMED |
| 2A:577F | `Profile_MoveCursorRight` | function | CONFIRMED |
| 2A:57BD | `Profile_InitScreen` | function | CONFIRMED |
| 2A:590B | `Profile_PlaceTextCursor` | function | CONFIRMED |
| 2A:594B | `Profile_RedrawNickname` | function | CONFIRMED |
| 2A:5952 | `Profile_DrawNickname` | function | CONFIRMED |
| 2A:5A0F | `Profile_DrawNickname_BlitGlyphAdvance` | function | CONFIRMED |
| 2A:5A23 | `Profile_DrawNickname_BlitBlankAdvance` | function | CONFIRMED |
| 2A:5A3B | `Profile_DrawAddressLine1` | function | CONFIRMED |
| 2A:5AFB | `Profile_DrawAddressLine1_BlitGlyphAdvance` | function | CONFIRMED |
| 2A:5B0F | `Profile_DrawAddressLine1_BlitBlankAdvance` | function | CONFIRMED |
| 2A:5B27 | `Profile_DrawAddressLine2` | function | CONFIRMED |
| 2A:5BE7 | `Profile_DrawAddressLine2_BlitGlyphAdvance` | function | CONFIRMED |
| 2A:5BFB | `Profile_DrawAddressLine2_BlitBlankAdvance` | function | CONFIRMED |
| 2A:5C13 | `Profile_UploadTextTiles` | function | CONFIRMED |
| 2A:5C5B | `Profile_CharPtr` | function | CONFIRMED |
| 2A:5C8F | `Profile_FindLine` | function | CONFIRMED |
| 2A:5CD2 | `Profile_InsertChar` | function | CONFIRMED |
| 2A:5E23 | `Profile_DeleteChar` | function | CONFIRMED |
| 2A:5EF4 | `Profile_ApplyDakuten` | function | CONFIRMED |
| 2A:5F82 | `String_Profile_DakutenKana` | string | CONFIRMED |
| 2A:5FD4 | `Profile_ApplyVu` | function | PROBABLE |
| 2A:6087 | `Profile_ApplyHandakuten` | function | PROBABLE |
| 2A:6132 | `String_Profile_HandakutenKana` | string | PROBABLE |
| 2A:6148 | `Profile_KeyboardLoop` | function | CONFIRMED |
| 2A:617B | `Profile_KeyboardLoop_Poll` | label | CONFIRMED |
| 2A:6257 | `Profile_LoadAndDraw` | function | CONFIRMED |
| 2A:62C5 | `Profile_SaveToSram` | function | CONFIRMED |
| 2A:6300 | `Gfx_Profile_Tiles9300` | data | CONFIRMED |
| 2A:6700 | `Gfx_Profile_Tiles9700` | data | CONFIRMED |
| 2A:6800 | `Gfx_Profile_Tiles8800` | data | CONFIRMED |
| 2A:6B40 | `Data_Profile_TilemapAttr` | data | CONFIRMED |
| 2A:6E10 | `Palette_Profile_Bg` | data | PROBABLE |
| 2A:6E50 | `Table_Profile_Anims` | table | PROBABLE |

#### General-DMA helper copies

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:5C3B | `Gfx_StartHDMAAtVBlank_2A_5C3B` | function | CONFIRMED |

#### Address book helpers (2A save confirmation, 2C shared)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:6F95 | `AddrBook_SaveConfirm` | function | CONFIRMED |
| 2A:704B | `AddrBook_StoreEditBufferToSlot` | function | CONFIRMED |
| 2A:709F | `Table_AddrBook_SlotAddrs_Store` | table | CONFIRMED |
| 2A:70AB | `AddrBook_SaveConfirm_InitScreen` | function | CONFIRMED |
| 2A:7187 | `AddrBook_SaveConfirm_DrawSlot` | function | PROBABLE |
| 2A:7221 | `Table_AddrBook_SlotAddrs_SaveConfirm` | table | PROBABLE |
| 2A:722D | `AddrBook_SaveConfirm_DrawEditBuffer` | function | CONFIRMED |
| 2A:7293 | `AddrBook_UploadEntryTextTiles` | function | CONFIRMED |
| 2A:72CF | `AddrBook_SaveConfirm_DrawTextLine16` | function | CONFIRMED |
| 2A:738F | `AddrBook_SaveConfirm_DrawTextLine16_BlitGlyphAdvance` | function | CONFIRMED |
| 2A:73A3 | `AddrBook_SaveConfirm_DrawTextLine16_BlitBlankAdvance` | function | CONFIRMED |

#### Address-book save confirmation art (2A)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:75A0 | `Palette_AddrSaveConfirm_Bg` | data | PROBABLE |
| 2A:75E0 | `Gfx_AddrSaveConfirm_Tiles9300` | data | PROBABLE |
| 2A:79E0 | `Gfx_AddrSaveConfirm_Tiles9700` | data | PROBABLE |
| 2A:7A20 | `Data_AddrSaveConfirm_TilemapAttr` | data | PROBABLE |

#### Address-book entry screen art of bank 2F stored in 2A/2C

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:7CF0 | `Gfx_AddrBookEntry_Tiles8F00` | data | PROBABLE |
| 2A:7DD0 | `Gfx_AddrBookEntry_Tiles8000` | data | PROBABLE |

#### Hypotheses (generic names kept)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2A:4A3D | `String_2A_4A3D` | string | HYPOTHESIS |
| 2A:4FE0 | `Tiles_2A_4FE0` | data | HYPOTHESIS |
| 2A:6081 | `String_2A_6081` | string | HYPOTHESIS |
| 2A:7287 | `Table_2A_7287` | table | HYPOTHESIS |
| 2A:73BB | `Function_2A_73BB` | function | HYPOTHESIS |
| 2A:747B | `Function_2A_747B` | function | HYPOTHESIS |
| 2A:748F | `Function_2A_748F` | function | HYPOTHESIS |
| 2A:74A7 | `Function_2A_74A7` | function | HYPOTHESIS |
| 2A:7567 | `Function_2A_7567` | function | HYPOTHESIS |
| 2A:757B | `Function_2A_757B` | function | HYPOTHESIS |

#### Mail draft ("written mail") menu (2B:4000)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2B:4000 | `MailDraft_Menu` | function | CONFIRMED |
| 2B:402B | `MailDraft_Menu_Loop` | label | CONFIRMED |
| 2B:420C | `MailDraft_Menu_InitScreen` | function | CONFIRMED |
| 2B:43A5 | `MailDraft_Menu_MoveCursorSprites` | function | CONFIRMED |
| 2B:4421 | `MailDraft_DrawTextLine21` | function | CONFIRMED |
| 2B:44E1 | `MailDraft_DrawTextLine21_BlitGlyphAdvance` | function | CONFIRMED |
| 2B:44F5 | `MailDraft_DrawTextLine21_BlitBlankAdvance` | function | CONFIRMED |
| 2B:450D | `MailDraft_DrawTextLine25` | function | CONFIRMED |
| 2B:45CD | `MailDraft_DrawTextLine25_BlitGlyphAdvance` | function | PROBABLE |
| 2B:45E1 | `MailDraft_DrawTextLine25_BlitBlankAdvance` | function | CONFIRMED |
| 2B:45F9 | `MailDraft_DrawTextLine17` | function | CONFIRMED |
| 2B:46B9 | `MailDraft_DrawTextLine17_BlitGlyphAdvance` | function | CONFIRMED |
| 2B:46CD | `MailDraft_DrawTextLine17_BlitBlankAdvance` | function | CONFIRMED |
| 2B:46E5 | `MailDraft_UploadTextTiles` | function | CONFIRMED |
| 2B:4743 | `MailDraft_Edit` | function | PROBABLE |
| 2B:478B | `MailDraft_Menu_SetCaption` | function | CONFIRMED |

#### General-DMA helper copies

| addr | name | type | status |
| --- | --- | --- | --- |
| 2B:4723 | `Gfx_StartHDMAAtVBlank_2B_4723` | function | CONFIRMED |
| 2B:5994 | `Gfx_StartHDMAAtVBlank_2B_5994` | function | PROBABLE |
| 2B:6CD5 | `Gfx_StartHDMAAtVBlank_2B_6CD5` | function | CONFIRMED |
| 2B:7DD0 | `Gfx_StartHDMAAtVBlank_2B_7DD0` | function | CONFIRMED |

#### Draft menu strings and art

| addr | name | type | status |
| --- | --- | --- | --- |
| 2B:47D0 | `Table_MailDraftMenu_Captions` | table | CONFIRMED |
| 2B:47D8 | `String_MailDraftMenu_CaptionConfirm` | string | PROBABLE |
| 2B:4801 | `String_MailDraftMenu_CaptionView` | string | CONFIRMED |
| 2B:482A | `String_MailDraftMenu_CaptionEdit` | string | CONFIRMED |
| 2B:4853 | `String_MailDraftMenu_CaptionDelete` | string | CONFIRMED |
| 2B:4880 | `Gfx_MailDraftMenu_Tiles9300` | data | CONFIRMED |
| 2B:4B50 | `Data_MailDraftMenu_TilemapAttr` | data | CONFIRMED |
| 2B:4E20 | `Palette_MailDraftMenu_Bg` | data | PROBABLE |
| 2B:4E60 | `Gfx_MailDraftMenu_Tiles8000` | data | CONFIRMED |
| 2B:5190 | `Palette_MailDraftMenu_Obj` | data | CONFIRMED |
| 2B:51D0 | `Table_MailDraftMenu_Anims` | table | PROBABLE |

#### Received mail viewer (2B:6482 sender page, 2B:7B02 body page)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2B:6482 | `MailView_SenderPage` | function | CONFIRMED |
| 2B:64A7 | `MailView_SenderPage_Loop` | label | CONFIRMED |
| 2B:65AB | `MailView_SenderPage_InitScreen` | function | CONFIRMED |
| 2B:6863 | `Table_MailView_RecAddrs` | table | CONFIRMED |
| 2B:691A | `MailView_DrawDateTime` | function | CONFIRMED |
| 2B:69AD | `Table_MailView_RecAddrs_DateTime` | table | CONFIRMED |
| 2B:69C5 | `MailView_DrawTextLine20` | function | CONFIRMED |
| 2B:6A89 | `MailView_DrawTextLine20_BlitGlyphAdvance` | function | CONFIRMED |
| 2B:6A9D | `MailView_DrawTextLine20_BlitBlankAdvance` | function | CONFIRMED |
| 2B:6AB5 | `MailView_DrawTextLine24` | function | CONFIRMED |
| 2B:6B7A | `MailView_DrawTextLine24_BlitGlyphAdvance` | function | PROBABLE |
| 2B:6B8E | `MailView_DrawTextLine24_BlitBlankAdvance` | function | CONFIRMED |
| 2B:6BA6 | `MailView_DrawTextLine16` | function | CONFIRMED |
| 2B:6C6B | `MailView_DrawTextLine16_BlitGlyphAdvance` | function | CONFIRMED |
| 2B:6C7F | `MailView_DrawTextLine16_BlitBlankAdvance` | function | CONFIRMED |
| 2B:6C97 | `MailView_UploadTextTiles` | function | CONFIRMED |
| 2B:6DD0 | `Gfx_MailView_Tiles9000` | data | PROBABLE |
| 2B:71D0 | `Gfx_MailView_Tiles9400` | data | PROBABLE |
| 2B:73D0 | `Data_MailView_TilemapAttr` | data | PROBABLE |
| 2B:76A0 | `Palette_MailView_Bg` | data | PROBABLE |
| 2B:76E0 | `Gfx_MailView_Tiles8000` | data | PROBABLE |
| 2B:7860 | `Palette_MailView_Obj` | data | PROBABLE |
| 2B:78A0 | `Table_MailView_Anims` | table | PROBABLE |
| 2B:7B02 | `MailView_BodyPage` | function | CONFIRMED |
| 2B:7B2A | `MailView_BodyPage_Loop` | label | CONFIRMED |
| 2B:7B9B | `MailView_BodyPage_InitScreen` | function | CONFIRMED |
| 2B:7D7A | `Table_MailView_BodyPage_RecAddrs` | table | CONFIRMED |
| 2B:7D92 | `MailView_BodyPage_UploadTextTiles` | function | CONFIRMED |
| 2B:7DF2 | `MailView_BodyPage_DrawTextLine24` | function | CONFIRMED |
| 2B:7EB4 | `MailView_BodyPage_DrawTextLine24_BlitGlyphAdvance` | function | CONFIRMED |
| 2B:7EC8 | `MailView_BodyPage_DrawTextLine24_BlitBlankAdvance` | function | CONFIRMED |
| 2B:7EE0 | `MailView_BodyPage_FindLine` | function | CONFIRMED |

#### Hypotheses (generic names kept)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2B:57B5 | `String_2B_57B5` | string | HYPOTHESIS |
| 2B:64F1 | `Function_2B_64F1` | function | HYPOTHESIS |
| 2B:687C | `Function_2B_687C` | function | HYPOTHESIS |
| 2B:6CF5 | `Function_2B_6CF5` | function | HYPOTHESIS |
| 2B:6DB0 | `Table_2B_6DB0` | table | HYPOTHESIS |

#### Mail title entry (2C:4000)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:4000 | `MailTitle_Entry` | function | CONFIRMED |
| 2C:4042 | `MailTitle_Entry_Loop` | label | CONFIRMED |
| 2C:40D4 | `MailTitle_CursorLeft` | function | CONFIRMED |
| 2C:40FB | `MailTitle_CursorRight` | function | CONFIRMED |
| 2C:410F | `MailTitle_MoveCursorRight` | function | CONFIRMED |
| 2C:414C | `MailTitle_InitScreen` | function | CONFIRMED |
| 2C:42EB | `MailTitle_PlaceTextCursor` | function | CONFIRMED |
| 2C:431D | `MailTitle_DrawTextLine` | function | CONFIRMED |
| 2C:43D8 | `MailTitle_DrawTextLine_BlitGlyphAdvance` | function | CONFIRMED |
| 2C:43EC | `MailTitle_DrawTextLine_BlitBlankAdvance` | function | CONFIRMED |
| 2C:4404 | `MailTitle_UploadTextTiles` | function | CONFIRMED |
| 2C:4441 | `MailTitle_CharPtr` | function | CONFIRMED |
| 2C:4475 | `MailTitle_FindLine` | function | CONFIRMED |
| 2C:44B8 | `MailTitle_InsertChar` | function | CONFIRMED |
| 2C:4612 | `MailTitle_DeleteChar` | function | CONFIRMED |
| 2C:46EB | `MailTitle_ApplyDakuten` | function | PROBABLE |
| 2C:4779 | `String_MailTitle_DakutenKana` | string | PROBABLE |
| 2C:47CB | `MailTitle_ApplyVu` | function | PROBABLE |
| 2C:487E | `MailTitle_ApplyHandakuten` | function | PROBABLE |
| 2C:4929 | `String_MailTitle_HandakutenKana` | string | PROBABLE |
| 2C:493F | `MailTitle_OpenKeyboard` | function | CONFIRMED |
| 2C:4972 | `MailTitle_KeyboardLoop` | function | CONFIRMED |
| 2C:4A05 | `MailTitle_GetLength` | function | CONFIRMED |
| 2C:4A30 | `Gfx_MailTitle_Tiles9300` | data | CONFIRMED |
| 2C:4E30 | `Data_MailTitle_TilemapAttr` | data | CONFIRMED |
| 2C:5100 | `Palette_MailTitle_Bg` | data | PROBABLE |
| 2C:5140 | `Gfx_MailTitle_Tiles8000` | data | CONFIRMED |
| 2C:5410 | `Gfx_MailTitle_Tiles8800` | data | CONFIRMED |
| 2C:5670 | `Palette_MailTitle_Obj` | data | CONFIRMED |

#### General-DMA helper copies

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:4421 | `Gfx_StartHDMAAtVBlank_2C_4421` | function | CONFIRMED |
| 2C:669D | `Gfx_StartHDMAAtVBlank_2C_669D` | function | CONFIRMED |

#### Address picker (2C:56FE)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:56F2 | `Table_AddrPick_SlotAddrs` | table | CONFIRMED |
| 2C:56FE | `AddrPick_Menu` | function | CONFIRMED |
| 2C:5721 | `AddrPick_Menu_Loop` | label | CONFIRMED |
| 2C:57A7 | `AddrPick_CursorDown` | function | CONFIRMED |
| 2C:57CC | `AddrPick_CursorUp` | function | PROBABLE |
| 2C:57F1 | `AddrPick_LoadSelection` | function | CONFIRMED |
| 2C:58AC | `AddrPick_InitScreen` | function | CONFIRMED |
| 2C:5E51 | `AddrPick_InitListAttrs` | function | PROBABLE |
| 2C:6032 | `AddrPick_MoveNameHighlight` | function | CONFIRMED |
| 2C:620D | `AddrPick_RefreshSlotIcons` | function | CONFIRMED |
| 2C:64A5 | `AddrPick_IsSlotUsed` | function | CONFIRMED |
| 2C:64D4 | `Table_AddrPick_SlotAddrs_Icons` | table | CONFIRMED |
| 2C:64E0 | `AddrPick_CursorMoveEffect` | function | PROBABLE |
| 2C:66BD | `AddrPick_LoadCaption` | function | CONFIRMED |
| 2C:6702 | `Table_AddrPick_Captions` | table | CONFIRMED |
| 2C:6704 | `String_AddrPick_Caption` | string | PROBABLE |
| 2C:6730 | `Gfx_AddrPick_Tiles9300` | data | CONFIRMED |
| 2C:6B30 | `Gfx_AddrPick_Tiles9700` | data | CONFIRMED |
| 2C:6CC0 | `Data_AddrPick_TilemapAttr` | data | CONFIRMED |
| 2C:6F90 | `Palette_AddrPick_Bg` | data | CONFIRMED |

#### Address book helpers (2A save confirmation, 2C shared)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:614D | `AddrBook_DrawSlotName` | function | CONFIRMED |
| 2C:61F9 | `AddrBook_DrawSlotName_BlitGlyphAdvance` | function | CONFIRMED |
| 2C:665F | `AddrBook_UploadTextTiles` | function | CONFIRMED |
| 2C:6C30 | `Gfx_AddrBook_Tiles8F00` | data | CONFIRMED |
| 2C:71D0 | `Palette_AddrBook_Obj` | data | CONFIRMED |

#### Address slot icons

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:7210 | `Table_AddrSlotIcon_Anims` | table | PROBABLE |

#### Address-book entry screen art of bank 2F stored in 2A/2C

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:7C80 | `Data_AddrBookEntry_TilemapAttr` | data | PROBABLE |
| 2C:7F50 | `Palette_AddrBookEntry_Bg` | data | CONFIRMED |
| 2C:7F90 | `Palette_AddrBookEntry_Obj` | data | CONFIRMED |

#### Hypotheses (generic names kept)

| addr | name | type | status |
| --- | --- | --- | --- |
| 2C:4878 | `String_2C_4878` | string | HYPOTHESIS |
| 2C:5A12 | `Function_2C_5A12` | function | HYPOTHESIS |
| 2C:5CA3 | `Function_2C_5CA3` | function | HYPOTHESIS |
| 2C:5CD2 | `Function_2C_5CD2` | function | HYPOTHESIS |
| 2C:5FB1 | `Function_2C_5FB1` | function | HYPOTHESIS |
| 2C:60B3 | `Function_2C_60B3` | function | HYPOTHESIS |
| 2C:741C | `Function_2C_741C` | function | HYPOTHESIS |
| 2C:746F | `Function_2C_746F` | function | HYPOTHESIS |
| 2C:755C | `Function_2C_755C` | function | HYPOTHESIS |
| 2C:761C | `Function_2C_761C` | function | HYPOTHESIS |
| 2C:7630 | `Function_2C_7630` | function | HYPOTHESIS |
| 2C:7648 | `Function_2C_7648` | function | HYPOTHESIS |
| 2C:7708 | `Function_2C_7708` | function | HYPOTHESIS |
| 2C:771C | `Function_2C_771C` | function | HYPOTHESIS |
| 2C:7740 | `Data_2C_7740` | data | HYPOTHESIS |

* **Unused 'もらったメール' (received mail) grid, 2B:53C3-5994 (`MailGrid_*`, PROBABLE names)**: rendering the tilemap 2B:5FF0 with the tiles/palettes loaded by `MailGrid_InitScreen` gives the title banner   'もらったメール' (received mail), a 4 x 3 grid of cells and a bar with the date labels 年 月 日 時 分; the code draws a 3x3 icon per record according to its flag (1 or 2), the date, name and title of the selected cell,   the d-pad moves the cell (4 columns), A far-calls `MailView_SenderPage` and then jumps to `MailDraft_Menu`, B returns $FF.

* **Delete-mail flow 2B:64F1** (yes/no `72:4015 DE=$0206`, then `2D:4133` = delete record and shift the rest): unreachable copy of what bank 25 does from its list.

* **Reply compose twin 2B:6CF5** of `Mailbox_ReplyToRecord` 25:54A7 (which clears $124 bytes of D400, this copy only $24; copies record+$ED / +$C9 to D4C0/D514, sets D524=3, runs address -> title -> body) and cursor-sprite switch 2B:687C: unreachable.

* **Twins in 2C**: 5A12 (icon refresh at table 7220-7250), 5CA3, 5FB1, 60B3 (slot-name drawing at x=$28) belong to a copy of the 2A save-slot list; 741C/746F/755C/7648 draw a 3-line address confirmation   (`72:4015 DE=$0204`, tiles 7740/7B70, tilemap 7860, palettes 7B30/7C00, anims 7C40) that no code calls.

* **Dummy tables** 2A:6081 and 2C:4878 (`82A4 82A4 00`) only give the iteration count of the U -> VU loop; the strings 2A:4A3D and 2B:57B5 have no reference at all, 2B:5807 (six full-width blanks) is only used by the dead grid code (2B:57CB).

* **`String_2A_4A3D`** carries the same caption as `String_AddrPick_Caption`; no code loads it.

* The code of the entire 2A animation block 5220-5495 is not referenced from bank 2A (2A:4573 loads its icon animations from **bank 28** table 5220, and 2C:7220-7250); it may be a leftover copy or used by a bank not scanned (no `ld de,$5220` with `a=$2A` exists in the ROM).

## 5. Observations for the other stages

* **Region mistypes** (not fixed here, `config/regions` belongs to another stage): `2A:4A66-4A6C` is a `ptrtable` but the bytes are the first strings of the five 9-byte caption chunks 4A66-4A93 (loaded by
  `ld hl,$4A66/$4A6F/$4A78/$4A81/$4A8A` in 2A:49C5); a `text` region 4A66-4A93 would be correct.  `2C:5100-5150` is a palette followed by the first tile of the block at 5140 (a symbol splits it, bytes unchanged);
  `2C:6F90-6FD0` is one 64-byte palette (three regions); `2C:6702` is a 1-word pointer table to 6704 (`Table_AddrPick_Captions`), typed `data`.
* **Original bug**: `Profile_CursorLeft` (2A:5744) calls `$4441` (the address of `MailTitle_CharPtr` in bank 2C, i.e. an unlinked copy of the routine); in bank 2A that address is the middle of
  `ld a,$00` in `SaveSenderAddr_SaveToSlot` (code_map.md records it as an instruction-skipping entry).  It only runs when the cursor is at column 0 of a line >0, which the 8-kana nickname presumably never reaches.
* `Profile_MoveCursorRight` clamps at column 8 (nickname of 8 kana) while `Profile_InsertChar` advances with the 12-column wrap of the multi-line editors: the profile code is the multi-line
  editor code with a single-line limit patched into some places only.
* `AddrBook_DrawSlotName` and `AddrBook_UploadTextTiles` are library routines shared by banks 2A, 2C and 2F; 2F's own screens also use `2A:7293`, `2A:5C3B`, and the palettes/tiles listed as `Gfx_AddrBookEntry_*`, `Palette_AddrBookEntry_*`, `Palette_AddrBook_Obj`, `Gfx_AddrBook_Tiles8F00`.
* Text-field widths of the received mail viewer: title 20 cells, sender name 16, address 20+24+20 (64 bytes split at bytes 20 and 44, the 2nd/3rd line only if the previous line is full).

### Hand-off notes for the passes that own the neighbouring banks

* `28:4550` is the tilemap of the **received-mail body page** ('A つぎへ', rendered) loaded by `MailView_BodyPage_InitScreen`; bank 28's own draft-body screen uses `28:4820` ('B もどる'); the later owner review named `28:4550` `Tilemap_MailView_BodyPage` and its files `mail_view_body_page.tilemap`/`.attrmap` (palettes `28:4AF0/4B30` and tiles `28:42C0/44D0` are shared by both).
* `2F:51C1` is the **address-book entry view screen** (rendered from `2C:7C80` + `29:5E50/6250` + `2A:7CF0/7DD0`: 'アドレスちょう', ニックネーム, アドレス, 'B もどる'); `2A:7293` and `2A:5C3B` are also called from 2F.
* `2D:65B0` is the mail **address entry** screen (SELECT far-calls `AddrPick_Menu`, then re-enters itself), `2D:4722` the **body entry**, `2D:408F/403C/40DC` load/store/clear the draft (SRAM `A000-A123`).
* `22:501D` = recompute + store the bank-0 page checksum and refresh the mirror page; `22:50FC` = recompute + store the bank-1 checksum (`A8D7`); both are called after every SRAM write of these banks.
* `4F:4000` copies BC bytes ROM->WRAM (palette staging D800/D840), `4F:404B` uploads D800 to BCPS/OCPS, `4F:4370` / `4F:42B4` are the palette ramps around each screen.
* `7F:41EA` is a 16-entry handler table indexed by the glyph style (B,C), `7F:7271` installs the STAT split (`00:0E93`, LYC=[D724]), `7F:72B0` removes it, `7F:624F/627C` copy the sprite table `DA00-DAFF` to/from `D900` (bank 3) around dialogs.

## 6. Open questions

* Meaning of record bytes `+01..02` and of the flag values (1 = new?, 2 = read is likely from `MailView_BodyPage_InitScreen` writing 2, not proven; no constant was defined).
* What the style parameters `B`/`C` of `7F:42C3` produce exactly (outline/shadow variants of the 12-row glyph, table `7F:42A3`); the code only shows (3,0) = normal and (0,1) = highlighted row in the address lists, (2,0) for padding.
* The sound-call constants (section 2.6) are contexts, not verified sound ids; `00:20E8` (`BC` = 4..$F at the end of each set-up) is unexplained.
* `Function_2D_65B0` / `2D:4722` (address and body entry) and `Function_28_4000` (view of the draft) are outside these banks; the roles used in the flow diagram come from the screenshots.
* Animation data (Table_*_Anims, OAM frame lists, scripts, ~150 generic labels such as `Data_2B_5244`) were not individually named: the sprite object format (`00:0AE8`) is still a HYPOTHESIS.

* `SaveSenderAddr_CursorMoveEffect` / `AddrPick_CursorMoveEffect`: they ran in traces only because the InitScreen routines force `hJoyPressed` ($40 at 2A:4189, $80 in 2C `AddrPick_InitScreen`) before the first refresh, not because a d-pad press was seen; evidence text corrected (status stays PROBABLE).

* Wrong addresses fixed: reply twin is `25:54A7` (not 54B5), `wMailComposeMode`=3 is written at `25:5515`, C0D2 loads in 2D are at 495F/498A; "many 2F calls" of `AddrBook_DrawSlotName` = 3 call sites.
