# Japanese maintained-tree generic-name sweep (2026-10-23; SRAM follow-up 2026-10-24)

### Banked SRAM structured-offset correlation

| Closed family | Live rows | Disposition | Reopen condition |
|---|---:|---|---|
| Broad `_AAAA` / `_BB_AAAA` global-label inventory | 439 | 109 existing detailed rows plus 330 additional rows in the consolidated ledger | New source row or positive evidence for a better identity |
| Labels containing `Candidate` | 269 | Every row has a qualified disposition; 163 also occur in the suffix inventory | New source row or positive evidence that the uncertainty qualifier can be removed |

### Structural RET-only re-scan and batch disposition (2026-10-23; HEAD `196f5ea7` plus this working change)

| Bank/address range | Name | Supported operation | Remaining limit |
|---|---|---|---|
| `70:[4740,477F)` | `SaveCheck_GetStateBlockBit7` | Reads bit 7 of `sSaveCheckStateBlock + 5`, restores saved SRAM mapping state, and returns the bit as A=0/1. | Entry/caller unknown; SRAM shadow/register consistency remains a precondition. |
| `22:[50CF,50E6)` | `SramCheck_VerifyBank1_ClearOnMismatch` | Sums and compares the Bank1 page-list/address-book data; clears both regions on mismatch and restores AF/BC/DE/HL. | No caller/pointer; entry and reachability HYPOTHESIS. |
| `22:[50E6,50FC)` | `SramCheck_VerifyBank1_ReturnStatus` | Returns `$01` for a matching checksum and `$FF` for a mismatch; restores BC/DE/HL. | No caller/pointer; entry and reachability HYPOTHESIS. |
| `7F:[620C,6218)` | `TimerB_IsAtLeast30Minutes` | Reads `wTimerBMinutes`; returns `$00` below 30 and `$FF` at or above 30. | No caller/pointer; entry and reachability HYPOTHESIS. |

### Complete `Mail_NextSramPage` caller-shape inventory

| Bank variable | Address and global label |
|---|---|
| Input | `4337 Mail_ScanHeaders_NextPage`; `44CC Mail_FindHeader_NextPage`; `469F Mail_MatchBoundary_NextPage`; `483E Mail_FindBoundary_NextPage`; `4A75 Mail_SkipHeaderBlock_NextPage`; `4ACA Mail_FindMessageEnd_NextPage`; `4B50 Mail_FindKeywordValue_NextPage`; `4C59 Mail_AdvanceInputSramPage`; `52B3 Mail_CopyItemToBuffer_NextPage`; `5C52 Mail_CopyBase64StripLineBreaks_NextPage`; `5D76 Mail_CopyFromSram_NextPage` |
| Output | `48BD Mail_PartRec_EmitHeaderBlock_NextPage`; `4948 Mail_PartRec_EmitLengthAndPart_NextPage`; `49C7 Mail_PartRec_EmitPart_NextPage`; `4A13 Mail_PartRec_EmitLength_NextPage`; `4EE4 Mail_EmitCrLf_NextPage`; `505D Mail_EmitString_NextPage`; `5174 Mail_EmitBufferToOutput_NextPage`; `5212 Mail_EmitGameCodeValue_NextPage`; `528A Mail_EmitStringAndSuffix_NextPage`; `5D8C Mail_CopyToSram_NextPage` |

### Repeatable audit boundary

```regex
generic_address_global = ^(?:Function|Func|Sub|Routine|Unknown|Unk|Code|Label|Font|Tiles?|Tilemap|Attrmap|Palette|String|Table|SpriteFrame|SpriteScript)_([0-9A-F]{2})_([0-9A-F]{4})$
neutral_data_global    = ^Data_([0-9A-F]{2})_([0-9A-F]{4})$
numeric_local_anchor   = ^\.l[0-9A-F]{4}$
neutral_ram_equate     = ^(?:wRam|hRam|sSram)_([0-9A-F]{4})$
short_local_review     = ^\.(?:loop|skip|done)$
typed_tile_ordinal     = _Tiles?_*[0-9]{1,3}$
```

| Label | Source | Bounded reason to retain neutral |
|---|---|---|
| `Data_2F_4094` | `engine/address_book/list.asm:94` | `C3 00 40` resembles a jump, but the prior path already jumps elsewhere and no entry at this byte is demonstrated. |
| `Data_23_46CC` | `engine/mail_server/delete_menu.asm:664` | `C9` follows a jump; the named routine starts at the next byte. |
| `Data_24_4BCC` | `engine/browser/page_list.asm:1574` | `C9` follows the final terminated message; the next named action starts at the next byte. |
| `Data_72_6711` | `engine/browser/menus.asm:406` | `AF` follows a return; the next named routine starts at the next byte. |
| `Data_4E_5390` | `engine/browser/page_render.asm:315` | `C1` is outside the paths shown by adjacent branches; no entry is demonstrated. |
| `Data_7F_4C77` | `engine/text/canvas.asm:2121` | The known copy interval ends before this `C9`; no other consumer is known. |
| `Data_7F_51ED` | `engine/unreferenced/page_list_prototype.asm:667` | `C9` is outside the preceding jump path; the next named entry starts at the next byte. |
| `Data_1C_401C` | `engine/main/main_program.asm:36` | `C9` follows a jump and is not addressed by the nearby pointer table. |
| `Data_72_63D7` | `data/text/dialog_messages.asm:620` | `AF` follows a text terminator; the known menu entry starts at the next byte. |
| `Data_5F_6980` | `gfx/keyboard/panels_bank5f.asm:469` | The 48-byte span of `$06` is outside the demonstrated tile/map copies. |

No candidate byte was an executed instruction start in its physical bank, and no natural `rom_read` interval overlapped a candidate span.

| Label | Natural ROM-read overlaps |
| --- | ---: |
| `Data_72_63D7` | 0 |
| `Data_2F_4094` | 0 |
| `Data_72_6711` | 0 |
| `Data_24_4BCC` | 0 |
| `Data_4E_5390` | 0 |
| `Data_23_46CC` | 0 |
| `Data_1C_401C` | 0 |
| `Data_7F_4C77` | 0 |
| `Data_7F_51ED` | 0 |
| `Data_5F_6980` | 0 |

Earlier ledgers retained those labels under the broader `PalLibCandidate_EnableVBlankIrq` owner, so a label-plus-owner join failed even though the byte locations were already inventoried.

The base matrix [`japanese_short_label_candidate_inventory_20261023.tsv`](japanese_short_label_candidate_inventory_20261023.tsv) contains all 500 definitions and references at `883d10f`.

All 27 were reconciled in one batch: stale code aliases now use current operation labels, the POP3 descriptor uses `Data_Pop3Retr_ParseBodyArgs`, and removed data-boundary names are rendered as explicit bank:address locations; the keyboard reference is explicitly scoped to `Kbd_Run`'s local `.handle_select` at `55:5E02`.

### 7F:7830 content identity update

A complete-byte comparison against the protected original ROM and both existing MailAddr source assets established that `7F:7830–7B00` (720 bytes) is exactly identical to the concatenation of `2D:7880–7940` (192 bytes) and `2D:7940–7B50` (528 bytes).

The formerly unresolved label/path are now `Gfx_MailAddr_ObjHDMABytesCopy_7F_7830` and `gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`; asset identity is CONFIRMED.

`Gfx_MailAddr_ObjHDMALoadTail` at `2D:7940` is also CONFIRMED as the bounded tail of the 720-byte upload: `MailAddr_SetupScreen` starts at `2D:7880` with 45 blocks of 16 bytes.

The latest staged-tree run of `python3 tools/japanese_name_census.py` reconciles 349 tracked Japanese ASM/INC inputs, 2,764 local-anchor rows, 786 numeric RAM equates and the reviewed address-suffix families. It reports zero strict address-only global definitions, zero active `Unknown`/`Unresolved` content labels, zero address-only GFX basenames, and zero generic bare `gfx/bankNN/` directory components. There are 28 *owner-qualified* resource directories with bank suffixes and 30 owner-qualified `*_bankNN.asm` source files; these are descriptive names, not generic `bankNN` placeholders. The 7F:7830 resource is now owned by `gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`; exact bytes match the 2D:7880–7B50 sequence, but its consumer/use remains unknown.

The source label is now `SoundDrv_CmdJumpToEnd`, describing its exact one-instruction `JP SoundDrv_CmdEnd` body; the interpretation that its table slots are unassigned remains PROBABLE.

Direct decoding and the complete sequence support PROBABLE code that clears WRAM0 `$C000–$C08F`, selects WRAM bank 7, fills `$DA00–$DAFF` with `$FF`, and returns; entry, caller, intended purpose, and natural use remain UNKNOWN.

This avoids treating the ordinary basename `ram/banked.asm` as a bank-ED placeholder.
