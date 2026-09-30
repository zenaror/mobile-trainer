# Naming pass 2, group 3 (apps A): adversarial verification

Scope: the applied names of `analysis/naming2/g3_apps_a_renames.tsv` (101 applied rows, banks 04 22 23 24 26 27 29 2A 2B 2C 2D 2E 2F).  Method: read the code at each label in the tree, re-derive
every claim of the evidence column (callers, callees, RAM names in `ram/*.asm`, strings through the charmap, `analysis/coverage_union.tsv`,
`traces/detail/*/callgraph.tsv`, `traces/scenarios.tsv`), and re-run every "instruction-identical twin" claim with a private script (instruction list per global block, symbol names and local
labels wildcarded, **16-bit immediates kept** so that a changed constant is a difference; the group's own fingerprint wildcarded them, which is how the errors below slipped through).
Private copy: `scratchpad/verify_g3_apps_a/`; the real tree was not touched.

Result: 9 renames proposed (`analysis/naming2/verify_g3_apps_a_fixes.tsv`), 0 status lowerings, 3 statuses that are understated (raising is possible, not done), about 60 names upheld.
`python3 tools/apply_renames.py --manifest analysis/naming2/verify_g3_apps_a_fixes.tsv --strict` in the private copy: 9 applied, 0 refused, `SHA-256 OK`, `sym_check OK`.
Mechanical check of all 142 manifest rows: every new name and its `Function_/Label_/...` alias sit at the address encoded in the old name (`build/mobile_trainer.sym`), the `; BB:AAAA`
comment agrees, the alias is adjacent; no misplaced label.

## Errors found (most important first)

1. **`NumberTileOffset` twin claim is false** (`23:4986`, `22:4A97`).  The evidence says "byte-identical (41 insn) to executed `MailSrvDel_NumberTileOffset` (23:5829)".  They are not: the executed routine returns
   `BC=$D010/$D020/$D030` (buffer addresses), the dead ones `BC=$0000/$0010`.  Both dead copies *are* byte-identical (constants included) to the executed family
   `MailServerStatus_NumberOffset_M0/M1/M2`.  The suffix form `MailSrvDel_NumberTileOffset_23_4986` announced a copy of a routine it differs from.  Renamed to `*_NumberOffset`.
2. **`AddrPick_IsSlotUsed_2C_5CA3` has inverted polarity** (inherited from the pre-existing `AddrPick_IsSlotUsed` 2C:64A5).  The code returns `A=$FF` when `[slot+$10]==0` (empty) and `A=0` when used; callers
   do `inc a / jr z` to *skip* the used-slot icon for empty slots.  The third twin in the tree, `Abook_TestSlotEmpty`, names it correctly.  Renamed `AddrPick_TestSlotEmpty_2C_5CA3`.
   Out of scope but the same defect: live `AddrPick_IsSlotUsed` (2C:64A5) and `SaveSenderAddr_IsSlotUsed` (2A) should get the same treatment.
3. **`AddrPick_MoveNameHighlight_2C_5FB1` is not instruction-identical** to `AddrPick_MoveNameHighlight` (2C:6032): both `AddrBook_DrawSlotName` calls use `E=$28` (x px) instead of `$30`, and the highlight-off branch calls
   `Function_2C_5CD2` instead of `AddrPick_InitListAttrs`.  The "Corrections to earlier notes" paragraph of `naming2_g3_apps_a.md` ("the difference is in the data it is given, not in the code") is therefore wrong and the
   old note in `config/symbols/bank2C.tsv` ("drawing names at x=$28") was right.  Renamed `..._X28_2C_5FB1`.
4. **`SaveSenderAddr_RefreshSlotIcons_2C_5A12`**: presented as a "dead copy of the save-sender screen inside bank 2C".  It lives in `address_picker.asm`, calls the bank-2C `AddrPick_IsSlotUsed_2C_5CA3`, and differs from
   both `SaveSenderAddr_RefreshSlotIcons` (2A:4573) and the live `AddrPick_RefreshSlotIcons` (2C:620D): other object bank/table (`$2C:7220/7230` vs `$28:5220/5230`), other y values (`$30,$3C..` vs `$28,$34..`), other tile
   value (`$0D` vs `$10`), no `inc c`, no trailing `hJoyPressed & $C0` test.  The 2A prefix asserted a membership the evidence does not show.  Renamed `AddrPick_RefreshSlotIcons_2C_5A12`.
5. **`Table_MailBody_CursorObjects`**: the only consumer is the compare chain *after the `ret`* of `MailBody_PlaceCursorSprites` (2D:4D04.., "entry of the chain not located", never executed); it initialises slot
   `$DA40`, whereas the live part of `MailBody_PlaceCursorSprites` positions slots `DA10/DA20`.  The evidence text ("`MailBody_PlaceCursorSprites` loads rows") attributes dead code to the live function and "cursor" is not
   established.  Renamed `Table_MailBody_ObjectEntries`.
6. **`Gfx_AbookName_Tiles8000` / `Palette_AbookName_Obj`** are loaded by `AbookName_SetupScreen` *and* by `AbookAddr_SetupScreen` (2F:6FE4/6FF9, executed in 9 scenarios, same arguments): shared by the address
   and name editors.  Renamed `Gfx_AbookEdit_Tiles8000`, `Palette_AbookEdit_Obj` (status stays CONFIRMED, the load is executed).
7. **`MailServerMgr_TimeWarningPopupChoice`**: the suffix "Choice" has no support; the evidence only shows that it is the same popup body as `MailServerMgr_TimeWarningPopup` with a different redraw call.  Renamed
   `MailServerMgr_TimeWarningPopupRedraw` (status stays CONFIRMED: executed once, `time_warnings`, `2E:44C7 -> 2E:4A7D`, stop path returns `$80`).
8. Factually wrong evidence, name fine: `Gfx_AbookView_Tiles9300/9700` say "the call site was not executed in a trace"; `AbookView_SetupScreen` 2F:51FC-521A is executed 6 times in 3 scenarios
   (`coverage_union.tsv`), so the status is understated (see below).

## Status corrections (name upheld, manifest row left untouched)

| name | manifest | should be | reason |
|---|---|---|---|
| `Gfx_AbookView_Tiles9300` | PROBABLE | CONFIRMED | load at 2F:51FF-5208 executed (6 times, 3 scenarios) |
| `Gfx_AbookView_Tiles9700` | PROBABLE | CONFIRMED | load at 2F:5211-521A executed (same) |
| `String_MailServerStatus_NumberTemplate_M1` | PROBABLE | CONFIRMED | its reader `MailServerStatus_FormatNumber_M1` (29:4B7F) runs 15 times in 4 scenarios (the M0/M2 twins are CONFIRMED on the same basis) |

No CONFIRMED row had to be lowered: the CONFIRMED rows are executed (HDMA copies 16/6 scenarios, `Abook_Run_*` 1-10 scenarios, the `AbookName` loaders, the M0/M2 number templates) or byte-identical to
executed code (verified).

## What was checked

Verdicts: upheld = name and status stand; renamed = name replaced in `verify_g3_apps_a_fixes.tsv`; status-raise = name stands, status understated.

| name(s) | verdict | reason |
|---|---|---|
| `Gfx_StartHDMAAtVBlank_2D_6C8C`, `_2F_7365` | upheld | identical text to `Gfx_StartHDMAAtVBlank` (25:538A, constants included); both executed (16/6 scenarios); callers are the two editors' tile loaders |
| `Abook_Run_List/EditAddress/EditName/View/BackToList` | upheld | executed (10/9/6/3/7 scenarios); farcalls `AbookList_Run`, `AbookAddr_Edit`, `AbookName_Edit`, `AbookView_Run`, `AddrBook_SaveConfirm`; result dispatch 0/2 edit, 1 view, 3 list, `$FF` ret re-read in the source |
| `Abook_Run_EditAddressA1`, `_EditNameA1` | upheld | `ld a,1` then fall into the same call; suffix honestly says the argument is not decoded |
| `AbookList_Run_Loop`, `AbookAddr_Edit_Loop` | upheld | loop heads: `Sprite_UpdateAll`, `VBlank_Wait`, `Joypad_Update`, then A test; `jp`/`jr` back-edges from 4 and 5 sites; 4434/8791 executions |
| `Gfx_AbookName_Tiles9300/9700/8800`, `Palette_AbookName_Bg` | upheld | HDMA loads in `AbookName_SetupScreen` (executed) with the stated VRAM targets; bg palette to `$D800` |
| `Gfx_AbookName_Tiles8000`, `Palette_AbookName_Obj` | renamed | shared with the address editor (error 6) |
| `Gfx_AbookView_Tiles9300/9700` | status-raise | see error 8 |
| `Gfx_CommTimeHMS_Tiles9000`, `Tilemap_CommTimeHMS_Screen`, `Palette_CommTimeHMS_Bg` | upheld | load sites in `CommTime_DrawHMSScreen` read; the screen is never executed (27:4D81.. absent in coverage), PROBABLE is right |
| `MailServerStatus_NumberTemplate_M0/M1/M2` | upheld | `$82 $4F` x5 + 0 (full-width zeros) copied to `$D524` by the executed formatters; M1 status-raise |
| `MailServerStatus_Txt_Unknown_M1/M2` | upheld | `？？？？？` passed to `TextTiles_RenderLine` three times by `Label_29_4A7D` (never executed) and `Label_29_4D39`; twin of `MailServerStatus_Txt_Unknown` |
| `MailServerMgr_TimeWarningPopup` | upheld | body read; `call nz` after the `C26E/C26F` timer test at `tidy.asm:157`; not executed |
| `MailServerMgr_TimeWarningPopupChoice` | renamed | error 7 |
| `MailSrvDel_DeleteAllRun_TimeWarningPopup`, `..._Reading`, `MailSrvDel_DeleteCompletelyRun_TimeWarningPopup` | upheld | callers `delete_flows.asm:761/510/1417`; the first and third are identical in their 48 instructions, the `_Reading` one adds `MailSrvDel_MsgReading` (and one extra `pop de` on the stop path); never executed (absent in coverage) |
| `MailSrvDel_MsgCancelled` | upheld | 12-insn shape of the executed `MsgReading/NoMail/Blank`, only the string differs (`キャンセルしました`); its `ld hl,$6E73` is a raw immediate although `String_MailSrvDel_MsgCancelled` exists |
| `MailSrvDelHidden_DrawTimerNumbers`, `MailSrvDel_DrawTimerNumbers` | upheld | the two 97-line bodies are identical (constants included); read `$C2D7/$C2D6/$C2D5` = hour?/`wTimerAMinutes`/`wTimerASeconds`; dead |
| `*_FormatDecimalStr` (22, 23) | upheld | 183-line bodies identical to executed `MailServerStatus_FormatNumber_M0` (constants included) |
| `*_UploadDecimalTiles` (22, 23) | upheld | identical to executed `MailSrvDel_UploadNumberTiles` (23:5889), not only "same shape" |
| `*_NumberTileOffset` (22, 23) | renamed | error 1 |
| `String_MailSrvDelHidden_NumberTemplate`, `String_MailSrvDel_NumberTemplate_23_497B` | upheld | full-width zeros, read by the dead formatter copies |
| `SpriteCounter_A/B/C_DrawNumber` and 15 `_DrawDigit*` | upheld | callers of the `ret` stubs load `HL`=count and `A`; body: 4 `Divide16` (10000..10), one digit routine per place; A/B/C digit routines differ only by slot (`DA10-50`, `DA60-A0`, `DA10-50`) and position pointer (`$5A2F..`, `$642F..`); stack balanced from 58C5, so the label is a real entry.  Dead (ret-patched), PROBABLE right.  Minor: "B resets its five slots" is really `Sprite_SetPosition` to `$D048` |
| `MailSession_SetReceivedCountSprite`, `SetNextReceivedCountSprite` | upheld | executed (7 scenarios); 12-way selection of object rows by `[D625]` / `[D625]+1`; "received count" rests on `D625` still being a HYPOTHESIS RAM name plus the caller context, hence PROBABLE (not higher) |
| `MailSession_ShowMsgSent`, `ShowMsgReceiveDone` | upheld | identical to `ShowMsgSending` except the string (`メールをそうしんしました` / `メールじゅしんかんりょう`) |
| `CommTime_DrawNumber_27_4FFB` | upheld | identical to executed `CommTime_DrawNumber` (51:41D8); callers inside the dead 27:4EC0 tail |
| `CommTime_PutDigit_27_5021`, `Table_CommTime_DigitTiles_27_5048` | upheld | `PutDigit` differs from 51:41FE only in the table base (`$5048` vs `$4225`), table bytes identical |
| `PalLibUnused_*` (8) | upheld | hardware semantics re-read: LY=$90 wait, `rIF/rIE` bit 0, BG+OBJ palette read/write through `rBCPS/rBCPD/rOCPS/rOCPD` to `$DBD0` (64 words), fade step `+1`/`-1` on the 5-bit components (toward white/black is the right way round), `FillBufferFromBlock` copies 64 bytes twice; unreferenced |
| `AddrBook_SaveConfirm_DrawTextLine17/25` and 4 `Blit*Advance` | upheld | differ from `DrawTextLine16` only in `wTextCellsLeft` ($11/$19 vs $10); identical to `AbookView_DrawAddrLine1/2`; helpers byte-identical; no callers |
| `AddrScreenUnused_DrawTextLine21/25` and 4 helpers | upheld | identical to `MailDraft_DrawTextLine21/25` (same caveat: they differ from the SaveConfirm drawers in `ld b,$3C`) |
| `AddrScreenUnused_Run`, `_InitScreen` and the 6 graphics/tables | upheld | flow re-read (60-frame wait, `Dialog_Show`, three lines from `D4C0/D4D4/D4EC`, all inside the `$40`-byte mail-address buffer); load arguments match the stated VRAM/WRAM targets; no reference to 2C:741C |
| `SaveSenderAddr_RefreshSlotIcons_2C_5A12`, `AddrPick_IsSlotUsed_2C_5CA3`, `AddrPick_MoveNameHighlight_2C_5FB1` | renamed | errors 4, 2, 3 |
| `Table_MailBody_CursorObjects` | renamed | error 5 |
| `SoundDrv_SelectAllTracks` | upheld | `ld de,$D040 ; ld a,8` into `SoundDrv_SetTrackIterator`; extra independent support: sfx tracks start at `$D040`, music at `$D130` = `$D040 + 4*$3C` (track stride `$3C`), so 8 tracks from `$D040` are exactly both groups.  Unreferenced, PROBABLE is the ceiling (the tree itself still says HYPOTHESIS for the entry) |

## Observations outside the verified rows

* `AbookView_DrawAddrLine1/2` (executed) are byte-identical to the generic 17/25-cell text-line drawers that exist in `MailDraft_*` and `AddrBook_SaveConfirm_*`; their "Addr" names are subsystem-local, not wrong.
* Several sources still load a label through a raw immediate (`ld hl, $573A`, `ld hl, $6E73`, `ld hl, $7220`) although a named label exists; cosmetic, no naming consequence.
* `Data_MailServerStatus_NumberTemplate_M0/M2` use the `Data_` prefix and `_M1` the `String_` prefix for the same kind of content (header classes differ); cosmetic.
