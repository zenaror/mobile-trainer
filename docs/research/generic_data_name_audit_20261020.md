# Generic data-label reference: 82 retained `Data_*` labels

## Descriptive names adopted in maintained sources

| Address | Descriptive name |
| --- | --- |
| `6A:65A1` | `String_HelpMenu_MailTitle` |
| `72:5645` | `String_Dialog_Msg0113_Line2` |
| `55:62C8` | `Table_Kbd_CursorSpriteCharOffsets` |
| `65:4BE2` | `Notice_PageTable_RegistrationStartTextPointer` |
| `65:4C6C` | `Notice_PageTable_ResumeRegistrationTextPointer` |
| `68:4F35` | `Dev_TestConfigImage_DialSlot1Bcd` |
| `68:4F4D` | `Dev_TestConfigImage_DialSlot2Bcd` |

## Song 14 and Song 1A track continuations

| Former label | New label | Interior bytes | Final jump | Next `AfterJump` |
|---|---|---:|---|---|
| `Data_05_4E22` | `SoundSong14_Track0_Continuation` | 56 | `05:4E57` to loop `05:4DA3` | `05:4E5A` |
| `Data_05_4F6A` | `SoundSong14_Track1_Continuation` | 28 | `05:4F83` to loop `05:4EAA` | `05:4F86` |
| `Data_05_4FD5` | `SoundSong14_Track2_Continuation` | 46 | `05:5000` to loop `05:4F9A` | `05:5003` |
| `Data_05_5085` | `SoundSong14_Track3_Continuation` | 28 | `05:509E` to loop `05:5031` | `05:50A1` |
| `Data_05_5E23` | `SoundSong1A_Track0_Continuation` | 19 | `05:5E33` to loop `05:5DD3` | `05:5E36` |
| `Data_05_609A` | `SoundSong1A_Track3_Continuation` | 52 | `05:60CB` to loop `05:602E` | `05:60CE` |

## Bank 05 song 10 stream aliases

| Address | Retained label |
|---|---|
| `05:455A` | `SoundSong10_Track0` |
| `05:455E` | `SoundSong10_Track0_Loop` |
| `05:45A4` | `SoundSong10_Track0_AfterJump` |
| `05:45A5` | `SoundSong10_Track1` |
| `05:45A9` | `SoundSong10_Track1_Loop` |
| `05:461A` | `SoundSong10_Track1_AfterJump` |
| `05:461B` | `SoundSong10_Track2` |
| `05:461F` | `SoundSong10_Track2_Loop` |
| `05:466C` | `SoundSong10_Track2_AfterJump` |
| `05:466D` | `SoundSong10_Track3` |
| `05:4671` | `SoundSong10_Track3_Loop` |
| `05:46E5` | `SoundSong10_Track3_AfterJump` |
| `05:46E6` | `SoundSong10_Header` |

## Bank 05 song 1A stream aliases

| Address | Retained label |
|---|---|
| `05:5DCF` | `SoundSong1A_Track0` |
| `05:5DD3` | `SoundSong1A_Track0_Loop` |
| `05:5E36` | `SoundSong1A_Track0_AfterJump` |
| `05:5E37` | `SoundSong1A_Track1` |
| `05:5E3B` | `SoundSong1A_Track1_Loop` |
| `05:5F66` | `SoundSong1A_Track1_AfterJump` |
| `05:5F67` | `SoundSong1A_Track2` |
| `05:5F6B` | `SoundSong1A_Track2_Loop` |
| `05:6029` | `SoundSong1A_Track2_AfterJump` |
| `05:602A` | `SoundSong1A_Track3` |
| `05:602E` | `SoundSong1A_Track3_Loop` |
| `05:605D` | `SoundSong1A_Track3_Sub1` |
| `05:60CE` | `SoundSong1A_Track3_AfterJump` |
| `05:60CF` | `SoundSong1A_Header` |

## Bank 05 song 1C stream aliases

| Address | Retained label |
|---|---|
| `05:60F9` | `SoundSong1C_Track0` |
| `05:60FD` | `SoundSong1C_Track0_Loop` |
| `05:6174` | `SoundSong1C_Track0_AfterJump` |
| `05:6175` | `SoundSong1C_Track1` |
| `05:6179` | `SoundSong1C_Track1_Loop` |
| `05:625E` | `SoundSong1C_Track1_AfterJump` |
| `05:625F` | `SoundSong1C_Track2` |
| `05:6263` | `SoundSong1C_Track2_Loop` |
| `05:628B` | `SoundSong1C_Track2_Sub1` |
| `05:62BB` | `SoundSong1C_Track2_AfterJump` |
| `05:62BC` | `SoundSong1C_Header` |

## Bank 70 communication-scene object animation records

| Entry | Frame records (`old address` -> `new frame index`) | Frame-pointer list | Candidate script |
|---|---|---|---|
| 1 | `4852->0, 4857->1, 4868->2, 4881->3, 48B2->4, 4903->5` | `Table_70_4846` -> `CommScene_ObjAnimEntry1_FramePointers` | `Data_70_4904` -> `CommScene_ObjAnimEntry1_Script` |
| 2 | `4919->0, 497E->1, 49E3->2, 4A50->3` | `Table_70_4911` -> `CommScene_ObjAnimEntry2_FramePointers` | `Data_70_4AB9` -> `CommScene_ObjAnimEntry2_Script` |
| 3 | `4ACE->0, 4B1F->1, 4B48->2, 4B61->3, 4B72->4, 4B7B->5` | `Table_70_4AC2` -> `CommScene_ObjAnimEntry3_FramePointers` | `Data_70_4B84` -> `CommScene_ObjAnimEntry3_Script` |
| 4 | `4B9D->0, 4BEE->1, 4C17->2, 4C30->3, 4C41->4, 4C4A->5` | `Table_70_4B91` -> `CommScene_ObjAnimEntry4_FramePointers` | `Data_70_4C4F` -> `CommScene_ObjAnimEntry4_Script` |

## Bank 70 third and fourth communication-scene object-animation groups

| Table entry | Frame-pointer list | Frame-record addresses in pointer order | Candidate script |
|---|---|---|---|
| `ObjAnimTable3` entry 1 | `4DCF` -> `CommScene_ObjAnimTable3_Entry1_FramePointers` | `4DD7, 4DE8, 4DFD, 4E1A` | `4E47` -> `CommScene_ObjAnimTable3_Entry1_Script` |
| `ObjAnimTable3` entry 2 | `4E50` -> `CommScene_ObjAnimTable3_Entry2_FramePointers` | `4E58, 4EB5, 4F16, 4F7B` | `4FE4` -> `CommScene_ObjAnimTable3_Entry2_Script` |
| `ObjAnimTable3` entry 3 | `4FED` -> `CommScene_ObjAnimTable3_Entry3_FramePointers` | `4FF7, 5050, 50A9, 50F6, 513B` | `517C` -> `CommScene_ObjAnimTable3_Entry3_Script` |
| `ObjAnimTable3` entry 4 | `5187` -> `CommScene_ObjAnimTable3_Entry4_FramePointers` | `5193, 51B4, 51CD, 51DE, 5203, 5240` | `5265` -> `CommScene_ObjAnimTable3_Entry4_Script` |
| `ObjAnimTable4` entry 1 | `527A` -> `CommScene_ObjAnimTable4_Entry1_FramePointers` | `5280, 52C1, 5302` | `5343` -> `CommScene_ObjAnimTable4_Entry1_Script` |

## Exact data/engine co-aliases retired

| Old qualified symbol | Current qualified symbol | Address |
|---|---|---|
| `Table_7E_7D8F.l7DAA` | `Charset_Iso2022JpStates.l7DAA` | `7E:7DAA` |
| `Table_7E_7D8F.l7DF7` | `Charset_Iso2022JpStates.l7DF7` | `7E:7DF7` |
| `Table_7E_7D8F.l7DFE` | `Charset_Iso2022JpStates.l7DFE` | `7E:7DFE` |
| `Table_7E_7D8F.l7E17` | `Charset_Iso2022JpStates.l7E17` | `7E:7E17` |
| `Table_7E_7D8F.l7E30` | `Charset_Iso2022JpStates.l7E30` | `7E:7E30` |
| `Palette_7F_4D50.loop` | `Palette_Canvas_Bg.loop` | `7F:4D5E` |

# Browser page-list message fragments

## Fresh neutral-data inventory at Japanese main 7c596ead

The Japanese assembly owner already defined `BrowserStart_CandidateTiles_49E0`
for the PROBABLE tile-like span, while `gfx/assets.tsv` still named that row
`Data_73_49E0`. The catalog now points to the existing source label, and its
backing/PNG paths are `gfx/browser/start_choice/browser_start_candidate_tiles`
with `.2bpp` and `.png` extensions. No source label, extent, confidence or
bytes changed; this corrects catalogue metadata and removes an address-only
resource basename without asserting natural use or a complete screen.

## Keyboard graphics semantic path migration

The Bank 62 owner is now `gfx/keyboard/type7_8_page_graphics_bank62.asm`; the Bank 66 owner is `gfx/keyboard/type6_pages_type10_picker_and_shared_tail_bank66.asm`.

Loader-to-destination names are supported by the maintained `engine/keyboard/keyboard.asm` transfer routines and the corresponding `CONFIRMED` owner ranges.

The scan found zero definitions named `Function_BB_AAAA`, `Label_BB_AAAA`, `Font_BB_AAAA`, or the alternate address-form prefixes `Func_`, `Routine_`, `Sub_`, `Unknown_`, `Unk_`, and `Code_`. It found 15 exact `Data_BB_AAAA` definitions in the safe source scope. The fresh build MAP contains 20 such address-form entries: five additional aliases at `2D:42B2`, `42F8`, `436A`, `441B`, and `44D3` belong to the protected `MailSample0_Header`–`MailSample4_Header` section. This distinction was verified from MAP/SYM output only; it is not a claim that the protected source was audited.

Two stale RAM comments that still named `Function_48_415A` and `Function_4E_604C` now use the confirmed code labels `TextTiles_RenderGridRows` (`engine/text/text_tiles.asm:247`) and `ConnIcon_StartSprite` (`engine/browser/status_sprites.asm:101`). The 15 safe-scope `Data_*` labels remain neutral wherever their bounded reviews do not establish a stronger meaning. These findings are static source/MAP/SYM evidence only; they add no runtime, hardware, translation, or ZIP-derived evidence.

## Full active-tree and resource-metadata sweep

The ten active `Data_BB_AAAA` definitions were reviewed individually with their adjacent byte ranges and consumers.

Eight identify one-byte spans that remain explicitly unclassified in the source; `Data_2F_4094` is a three-byte `$C3,$00,$40` sequence that decodes as `JP AbookList_Run` if executed, and `Data_5F_6980` is a 48-byte run of `$06` with no established bank-5F reader.

A targeted scan of the immutable ROM found two little-endian `$4094` word occurrences: one is the address operand of `ld hl, Table_Title_States` in physical bank 0E, where `$4094` denotes the bank-0E table; the other is at physical `63:631D`.

Neither occurrence demonstrates a bank-2F entry to the candidate at `2F:4094`; a computed or runtime bank-qualified pointer is not excluded.

The remaining address-shaped prefixes in active labels were also classified: the ten `OtherType_BB_AAAA` cases have a structural or uncertainty qualifier (`ReturnOnly`, `ZeroByteSpan`, `SpriteSlotAnimationEntryTable`, `SpriteScriptCandidate`, `CandidateTiles`, `WramClearCandidate`, `CandidatePalette`, `CandidateMapData`, `UnresolvedTiles`); none is a bare function/font/data placeholder. The scan is lexical and does not prove that every semantic name is correct. The ten neutral data labels and any unresolved candidate roles remain reviewable only when new positive evidence appears.

## Consolidated generic-name recheck and batch disposition

It matched exact `PREFIX_BB_AAAA::` definitions across `Function`, `Func`, `Routine`, `Sub`, `Unknown`, `Unk`, `Code`, `Label`, `Data`, `Table`, `String`, `Tiles`, `Tilemap`, `Attrmap`, `Palette` and `Font`.

| Previous label | Current label | Limit retained |
| --- | --- | --- |
| `Data_1C_401C` | `Data_Main_CandidateRetOpcode_401C` | Entry and code/data role unresolved |
| `Data_23_46CC` | `Data_MailSrvDel_CandidateRetOpcode_46CC` | Entry and code/data role unresolved |
| `Data_24_4BCC` | `Data_PageList_CandidateRetOpcode_4BCC` | Entry and code/data role unresolved |
| `Data_2F_4094` | `Data_AbookList_CandidateJpRun_4094` | No entry established; may be an unentered stub or data |
| `Data_4E_5390` | `Data_BrowserAnchor_CandidatePopBcOpcode_5390` | No stack-flow or entry claim |
| `Data_5F_6980` | `Data_Kbd_Byte06Run_6980` | Content pattern only; resource purpose and reader unknown |
| `Data_72_63D7` | `Data_BrowserMenu_CandidateXorAOpcode_63D7` | Entry and code/data role unresolved |
| `Data_72_6711` | `Data_BrowserMenu_CandidateXorAOpcode_6711` | Entry and code/data role unresolved |
| `Data_7F_4C77` | `Data_Canvas_CandidateRetOpcode_4C77` | No caller or entry established |
| `Data_7F_51ED` | `Data_PageListProto_CandidateRetOpcode_51ED` | Entry unresolved; prototype reachability not claimed |

A separate raw `$4094` scan likewise did not establish a bank-2F entry and cannot exclude computed bank-qualified access.
