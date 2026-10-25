# RAM reference 2 (ram2): WRAM0 and HRAM variables

## 1. Result

Self-checks done before applying: every `old_name` is defined exactly once (`DEF Old EQU` in `ram/*.asm`), the 49 new names are unique, legal, and do not collide with any
definition (three of them, `wMobileErrorDetail`, `wRegistrationStage`, `wSavePasswordFlag`, appear only inside the old `naming ideas in conflict` *comments* of `ram/wram.asm`,
which is what they were the unadopted ideas for).

Ranking by number of distinct **named** functions touching the byte: `hRam_FFB0` 122,    `wRam_C27D` 104, `wRam_C27C` 96, `wRam_C0E5` 52, `hRam_FFB1` 42, `wRam_C27E` 42, `hRam_FFBA` 38 ... 2.

## 3. Names adopted (49)

| addr | old | new | status |
| --- | --- | --- | --- |
| `C26E` | `wRam_C26E` | `wTimerAWarnMinute` | PROBABLE |
| `C26F` | `wRam_C26F` | `wTimerAWarnFlags` | PROBABLE |
| `C273` | `wRam_C273` | `wMobileErrorDetail` | CONFIRMED |
| `C274` | `wRam_C274` | `wMobileErrorDetailHi` | CONFIRMED |
| `C277` | `wRam_C277` | `wRegistrationStage` | PROBABLE |
| `C27A` | `wRam_C27A` | `wSavePasswordFlag` | PROBABLE |
| `C1D0` | `wRam_C1D0` | `wCommNoticeMode` | PROBABLE |
| `C1D1` | `wRam_C1D1` | `wCommNoticeGfxSet` | PROBABLE |
| `C1CD` | `wRam_C1CD` | `wCommNoticeScreen` | PROBABLE |
| `C14E` | `wRam_C14E` | `wCommNoticeFrames` | PROBABLE |
| `C14F` | `wRam_C14F` | `wCommNoticeSeconds` | PROBABLE |
| `C12E` | `wRam_C12E` | `wFarAccessTemp` | CONFIRMED |
| `C2E3` | `wRam_C2E3` | `wJoySavedRepeatDelay` | CONFIRMED |
| `C2E4` | `wRam_C2E4` | `wJoySavedRepeatInterval` | CONFIRMED |
| `C2A8` | `wRam_C2A8` | `wCommSceneScrollX` | CONFIRMED |
| `C2D7` | `wRam_C2D7` | `wTimerAExtra` | PROBABLE |
| `C2B3` | `wRam_C2B3` | `wKbdRunArgB` | CONFIRMED |
| `C2B4` | `wRam_C2B4` | `wKbdRunArgC` | CONFIRMED |
| `C2B6` | `wRam_C2B6` | `wKbdNeighbourCell` | PROBABLE |
| `C2B7` | `wRam_C2B7` | `wKbdNeighbourFlagsA` | PROBABLE |
| `C2B8` | `wRam_C2B8` | `wKbdNeighbourFlagsB` | PROBABLE |
| `C179` | `wRam_C179` | `wHelpScriptDelayCounter` | PROBABLE |
| `C178` | `wRam_C178` | `wHelpScriptGlyphDelay` | PROBABLE |
| `C177` | `wRam_C177` | `wHelpScriptPictureId` | CONFIRMED |
| `C1A8` | `wRam_C1A8` | `wHelpScriptColumn` | PROBABLE |
| `C1A9` | `wRam_C1A9` | `wHelpScriptLineTile` | PROBABLE |
| `C1AB` | `wRam_C1AB` | `wHelpScriptAdvanceMode` | PROBABLE |
| `C1B0` | `wRam_C1B0` | `wHelpScriptAltPtr` | PROBABLE |
| `C1B1` | `wRam_C1B1` | `wHelpScriptAltPtrHi` | PROBABLE |
| `C0DB` | `wRam_C0DB` | `wTopMenuCursorTargetX` | CONFIRMED |
| `C0DC` | `wRam_C0DC` | `wTopMenuCursorTargetY` | CONFIRMED |
| `C0D5` | `wRam_C0D5` | `wTopMenuCursorXFrac` | PROBABLE |
| `C0D7` | `wRam_C0D7` | `wTopMenuCursorYFrac` | PROBABLE |
| `C0DD` | `wRam_C0DD` | `wTopMenuCursorStepXHi` | PROBABLE |
| `C0DE` | `wRam_C0DE` | `wTopMenuCursorStepXLo` | PROBABLE |
| `C0E0` | `wRam_C0E0` | `wTopMenuCursorStepYLo` | PROBABLE |
| `C0E1` | `wRam_C0E1` | `wTopMenuCursorStepsLeft` | CONFIRMED |
| `C1DC` | `wRam_C1DC` | `wBrowserPendingMessage` | PROBABLE |
| `C2C4` | `wRam_C2C4` | `wBrowserDialSlotPlus1` | PROBABLE |
| `C25E` | `wRam_C25E` | `wPop3SavedSramBank` | CONFIRMED |
| `C2F3` | `wRam_C2F3` | `wShadowOAMNextOffset` | CONFIRMED |
| `FFF0` | `hRam_FFF0` | `hSpriteSlideOffsetX` | PROBABLE |
| `FFF1` | `hRam_FFF1` | `hSpriteSlideOffsetY` | PROBABLE |
| `FFD9` | `hRam_FFD9` | `hHtmlListIndent` | PROBABLE |
| `FFD8` | `hRam_FFD8` | `hHtmlLineIndent` | PROBABLE |
| `FFDA` | `hRam_FFDA` | `hHtmlAlignAdjust` | PROBABLE |
| `FFDB` | `hRam_FFDB` | `hHtmlAlignAdjustHi` | PROBABLE |
| `FFDC` | `hRam_FFDC` | `hHtmlLinkTextStart` | PROBABLE |
| `FFDD` | `hRam_FFDD` | `hHtmlLinkTextStartHi` | PROBABLE |

### Notes on individual names

* **Timer-A warning pair (`wTimerAWarnMinute/Flags`).**  The test that uses them is copy-pasted 29 times (27 outside the unreferenced page-list prototype) in 13 files (registration verify, browser page list/view/inline   images/loader/menus, mail sessions, mail-server delete flows, password change, comm error screen, dialog): `bit 4,[wTimerEnable]` (timer A), `bit 0,[C26F]`, `cp` against `wTimerAMinutes`, `wTimerASeconds >= $1E`, then `bit 1` / `+$0A` / cap `$45`   and `A=$FF`.

CONFIRMED because both ends are visible: stored from HL of `MobileAPI($00)` and   reloaded into HL for `CommErr_ShowScreen` together with the error code.

* **Help-script interpreter (bank 6C).**  All nine bytes are used only by `engine/help/help_script.asm` (single subsystem, no overlay): text stepper `HelpScript_StepText` 6C:6009, reader   `Label_6C_5B47` 6C:5B47, input table `HelpScript_InputTable`.

Not named from the same code: `C176`, `C17B`, `C17C` (written by the opcode class $5x, never read), `C17A` (glyph plane-clear flag   toggled by opcodes $20/$21: the effect is visible, the purpose is not), `C1AA` (+2 per line, never read), `C1AC` (last opcode, never read), `C0D9/C0DA` (waiting-arrow blink, in the overlay window).

* **Keyboard (bank 55).**  `wKbdRunArgB/C` are CONFIRMED as arguments (first instruction of `Kbd_Run` stores C, B is stored only for type 5).

`wKbdNeighbourFlagsA/B` take the record layout (bytes 0-3 neighbours L/R/U/D, bytes 4-5 flag bytes) from `naming_g5.md`; the code reads them as four   bit tests each (bits 7-4), `A` when a move is computed, `B` when the sticky column/row is updated.

* **Top-menu cursor slide (bank 1F).**  Eight bytes of the `C0D4-C0E1` window are used only by `TopMenu_*`; they form a consistent fixed-point animation: position `C0D4:C0D5` (x, 8.8) and   `C0D6:C0D7` (y, 8.8), per-frame step `C0DD:C0DE` / `C0DF:C0E0` (signed 8.8), frames left `C0E1`, target `C0DB` (x) / `C0DC` (y) loaded from `Table_TopMenu_CursorTargets`, direction bits in   `C10E`.

Read as the dialog message id by `Browser_PageView_Enter` (`Dialog_ShowMonitored`,   D=1, E=[C1DC]) and as a stop flag by `Browser_FetchInlineImages`.

* **`wJoySaved*` and a quirk of the original.**  Four screens save `wJoyRepeatDelay/Interval` before switching to ($14,$04) and three restore them (B=delay, C=interval).

`BrowserMenu_Close`   (72:6A6B) loads `B := [C2E4]`, `C := [C2E3]`, i.e. it restores the two values **swapped**.

* **HTML parser HRAM.**  `hHtmlListIndent/LineIndent/AlignAdjust/LinkTextStart` are used only by `engine/html/{tags,layout,count_pass}.asm` (bank 74), initialised by `Html_InitParser`.

`hHtmlAlignAdjust` is the only one whose unit/sign is inferred: `Html_Tag_Hr` stores the two's complement of a width   (`dec hl ; cpl ; cpl`) and the layout adds it to the free width before halving (centre) or using it whole (right).

## 4. Overlay windows: why most of the heavily used bytes stay neutral

| window | left neutral |
| --- | --- |
| `C27C-C286` ("screen locals") | yes (3 HYPOTHESIS rows, ideas `wScreenVar0..2`) |
| `C0D4-C0FF` ("menu locals") | yes, except the 8 TopMenu-only bytes |
| `C10E-C11D` | yes (idea `wTilemapAttrSrc`) |
| `C580-C592` | yes (idea `wMailDateYearHi`...) |
| `C711-C713` (SDK) | yes |
| `C823-C825` | yes |
| `FFB0-FFE0` (HRAM scratch) | yes (HYPOTHESIS ideas for the text-engine roles; bytes exclusive to bank 74 were named) |

Likewise `hRam_FFDF` is the parser's link counter in bank 74 and "previous selected link" in `Browser_SelectPrevLink/NextLink` (g5 named `hBrowserSelectedLink` = `FFDE`); `hRam_FFA7` has no writer that stores a non-zero value, so the "injected button" idea in `ram/hram.asm` remains unsupported (recorded as a HYPOTHESIS row with that warning).

## 5. Unresolved / not named (with reason)

| addr | old | idea |
|---|---|---|
| `C27C` | `wRam_C27C` | `wScreenVar0` |
| `C27D` | `wRam_C27D` | `wScreenVar1` |
| `C27E` | `wRam_C27E` | `wScreenVar2` |
| `C0E5` | `wRam_C0E5` | `wMenuVar_Current` |
| `C0E6` | `wRam_C0E6` | `wMenuVar_Previous` |
| `C0E7` | `wRam_C0E7` | `wDebugHoldFrames` |
| `C0E8` | `wRam_C0E8` | `wDebugHeldButtons` |
| `C0D4` | `wRam_C0D4` | `wTopMenuCursorX` |
| `C0D6` | `wRam_C0D6` | `wTopMenuCursorY` |
| `C0DF` | `wRam_C0DF` | `wTopMenuCursorStepYHi` |
| `C10E` | `wRam_C10E` | `wTilemapAttrSrc` |
| `C10F` | `wRam_C10F` | `wTilemapAttrSrcHi` |
| `C0F6` | `wRam_C0F6` | `wTickerVramColumn` |
| `C580` | `wRam_C580` | `wMailDateYearHi` |
| `C711` | `wRam_C711` | `wMobileSDK_ParseTemp0` |
| `C823` | `wRam_C823` | `wMobileAPISavedHL` |
| `C28E` | `wRam_C28E` | `wScreenStateIndex` |
| `FFB9` | `hRam_FFB9` | `hTextEngineBank` |
| `FFBF` | `hRam_FFBF` | `hTextEngineDepth` |
| `FFC1` | `hRam_FFC1` | `hTextLineStartX` |
| `FFC3` | `hRam_FFC3` | `hTextBottomY` |
| `FFC4` | `hRam_FFC4` | `hTextRightX` |
| `FFC6` | `hRam_FFC6` | `hTextLineAdvance` |
| `FFBA` | `hRam_FFBA` | `hTextGlyphColorB` |
| `FFBB` | `hRam_FFBB` | `hTextGlyphColorC` |
| `FFDF` | `hRam_FFDF` | `hHtmlLinkCount` |
| `FFE0` | `hRam_FFE0` | `hHtmlLinkHeapOffset` |
| `FFD6` | `hRam_FFD6` | `hBmpWidth` |
| `FFA7` | `hRam_FFA7` | `hJoyInjectedButtons` |
| `D725` | `wRam_D725` | `wStatSplitParam2` |

`wRam_D725` (section 6, idea `wStatSplitParam2`) was named in [`naming2_ram3.md`](naming2_ram3.md): it is `wKbdSlideDeltaRow` in `ram/banked.asm` (WRAM bank 1, PROBABLE), the row index of the keyboard-slide delta tables.

The rule of section 4 stands (the neutral name is the only global name of the address); the table of section 4 is a first reading and some of its rows are **corrected** by the aliases (and the idea row `FFE0 hHtmlLinkHeapOffset` of section 5 is wrong: `FFE0` is an index into the link pointer table): `C27C-C286` (`C27E:C27F` is a big-endian frame counter in the title screen, a little-endian record pointer in the notice pages; `C286` is a one-shot sound latch, not an API poll counter), `C0D4-C0FF` (`C0E5/C0E6` are current/previous item in the top menu only; in the help and mail menus `C0E6` is the item to draw as normal; the browser start page has `C0E5` only) and `C10E-C11D` (the "counter" in `Tilemap_FillRectSequential` is a constant `$07` and a start tile; the counter is in `Palette_FadeOutWithTicker`).
