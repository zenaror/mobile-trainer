# reference 2, group g4_apps_b: adversarial reference

### (c) Inline jump tables (32 names)

All 31 call-fed tables: placement on the ROM bytes (table label = call address + 3), owner function by nearest primary label, selector by the instruction before the call, length by the words until the first handler (or
`JoypadDispatch`'s fixed 5).  Samples read in full: `Browser_PageView_GoBack_DialogResultTable` (message `$0113`, 6 words), `Browser_Menu_DisconnectPrompt_DialogResultTable` (message `$0101`: result 1 = yes), `PalFade_Step_ModeTable`,
`BrowserMenu_RunTwoItem_DialogResultTable` (`hDialogResult` doubles as the 2-item cursor), `Browser_StartMenuLoop_ResultTable`, `CommNotice_InputTable`, `Dialog_SetupCursorByType_TypeTable` (`wDialogType` = byte 1 of the `$86 aa bb` record header; types 0-5 occur in the records; type >= 3 goes to `Dialog_OpenTall`).  The `JoypadDispatch` order (A, B, Select, Start, none) is in `home/jump_table.asm`.  No table is misplaced; owners are right.

### (d) Graphics

| names | verdict | reason |
|---|---|---|
| 8 `Attrmap_CommNotice_*` | upheld | each label = tilemap label + `$168` (20x18) exactly; `Tilemap_CopyRectAndAttr` (00:08EA) continues with the same source pointer for the second pass at `dest+$0400` |
| `Gfx_CommNotice_A/B_Tiles*`, `Palette_CommNotice` | upheld | variant A = `wRam_C0D6==0` (`ld a,[wRam_C0D6] ; or a ; jp nz,.l4173` at 50:409B); tile counts (`c=$40/$1A/$01/$32`) and block sizes agree with the label distances (`$400/$1A0/$10/$320`); `Palette_CommNotice` = 4 x `$40` at `6BC0/6C00/6C40/6C80` by the four load sites.  The evidence says the A call sites never ran: wrong, they ran in 4 scenarios (section 3); the B branch did not |
| `Gfx_CommTime_SummaryA/B_*`, `Palette_CommTime_SummaryA/B` | upheld | `wCommSessionKind==1` selects A (`cp $01 ; jr z,.l40BF`); sizes `$400` per tile block, palette `$40`; B is also loaded by `send_receive.asm:1880-1898` (second site confirmed) |
| `ConnIcon_Anim1..6Frames`, `CommNotice_Anim0/1Frames`, `CommNotice_ObjTable` | upheld | `ConnIcon_ObjTable` words are `4794,48AC / 4794,48AC / 48B5,... / 49DE / 4A73 / 4BAB / 4A05`; entry N = B value passed to `ConnIcon_StartSprite` (B=1,2,6,4,5 seen, B=3 never); first target of each list = its end (8, 8, 1, 4, 2, 3 pointers; notice 2, 2).  For bank 50 the B path uses `ld de,$6D1A` (= entry 1) so `Anim1Frames` is the variant-B list |

Rows whose PROBABLE rests on unreferenced code whose source header still says HYPOTHESIS ("no entry proven"): `Sram_VerifyChecksum3ResetOnMismatch`, `Tilemap_ApplyMaskRect_48_4A8C`, `Sram_BuildA9F0DeltaBlock`,
`ConnIcon_GetBrowserFramePos`, `TextEntry_InsertMaskedString`, `Sram_WipeBanks2And3`, `Settings_GetAdapterType`, six `Account_*`, `Browser_FrameStylePreview_Run`.  PROBABLE is tolerable only because the decoded bodies are
coherent and three of them are byte-exact copies or twins of executed routines; none of them is executed.

* `Mail_ApplyTimezoneOffset`: the evidence omits that after normalising a numeric `+/-hhmm` offset to UTC the code adds a fixed 9 hours (`add a,$09 ; daa` at 54:5287, Japan time); a header without `+`/`-` returns before that.

* `Browser_LoadPage_SessionKindTable`: the table sits inside `Browser_LoadPage_Http` (nearest primary label), fine under the `Browser_LoadPage_` prefix.

* `Sram_SnapshotBootCounters` note "meaning of A9F0-A9F7 unknown, the name states only the copy-and-clear" contradicted the name; fixed by the rename.

* `String_Dialog_Msg0000`: list 3 entry 0 (`$0300`) points to the same record; the name covers `$0000` only.

## 4. Mechanical observations

* `Data_Browser_FrameWipeGroups` prints numbers such as `$0020`, `$0040`, `$0100` as `Rst_20`, `Vector_VBlank`, `Entry` (already noted by the group); the build is identical, but the label values would move if a ROM0 symbol moved.
* `Table_6A_64B1` is off by one byte as the group reported (bytes checked above); no other off-by-one was found (every dialog label starts on `$86` after a NUL, every dictionary entry on a string start, every frame list ends where its first frame starts, every
  attribute map starts exactly `$168` after its tilemap).
* Two names of the pass were found to carry a different meaning of "Frame" (`ConnIcon_GetFramePos` vs `ConnIcon_Anim*Frames`); fixed by the rename.
