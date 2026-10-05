# RAM and operand pass 3 (ram3)

> Status: **reference (current)** for the names and symbolized operands it lists.  Follows [`naming2_ram2.md`](naming2_ram2.md) (bank-independent WRAM0 / HRAM names) and closes two of
> its open items: the banked variable `wRam_D725` (section 6 of that note, idea `wStatSplitParam2`) and the bank-1 SRAM variable page.  Record of the operand decisions:
> [`analysis/naming2/rawptr1_sites.tsv`](../../analysis/naming2/rawptr1_sites.tsv).  The screen-local aliases of the overlay variables are a separate step (section 5).

## 1. Result

| item | count |
|---|---|
| bank-qualified names added to `ram/banked.asm` | 5 (`wKbdSlideDeltaRow` in WRAM bank 1; `sVarPage`, `sTitleMenuCursor`, `sPhoneSlotMenuCursor`, `sKbdInputMode` in SRAM bank 1) |
| code references renamed to them | 83 (`wRam_D725`) + 16 raw SRAM operands |
| raw pointer operands replaced by the label at that address | 34 sites, 26 rules, 9 files |
| coincidences that stay numeric (the number is not a pointer) | 9 sites |
| ROM | byte-identical (`make`: `RESULT: IDENTICAL`; `sym-check`, `tidy_comments --check`, `localize_labels --check`, `tree_check` pass) |

The neutral names `wRam_D725` and `sSram_BF00` / `BF03` / `BF05` stay defined in `ram/wram.asm` / `ram/sram.asm` (a neutral name never claims a bank); their comments now point at the
adopted bank-qualified name.

## 2. `wKbdSlideDeltaRow` ($D725, WRAM bank 1, PROBABLE)

Row index (register D) of the per-step delta tables used by the keyboard slide of types 8 and 9.

* **Readers.**  `KbdSlide_InPrepMode8` / `OutPrepMode8` / `InPrepMode9` / `OutPrepMode9` (`7F:7149`, `7178`, `71A7`, `71D6`; the "Mode" in their names is `wKbdType`) load `D` from it when it is non-zero and
  otherwise use a constant row (4 for type 8, 5 for type 9); `E` = 0.  `ScrollSplit_StepUp4` / `StepDown4` (`7F:7425`, `76C4`) then index `ScrollSplit_Step{Up,Down}4Ptrs[2*D]` and walk the row with `E`,
  adding each value to `wSplitScrollY` and subtracting it from the sprite slots.  Both branches of all four readers ran in natural scenarios (non-zero 11-23 hits each, zero 50-72).
* **The rows** (computed from the ROM, same in the Up and Down tables): totals 0, 0, 12, 24, 36, 40, 60, 60, 11, 18, 57, 66 pixels for rows 0-11, eleven steps each (row 9: eighteen).  Rows 2-4 and 6-7 are
  12 * (row - 1); the default rows 4 and 5 slide 36 and 40 px; rows 10 and 11 slide 57 and 66 px.
* **Writers.**  75 stores, all in WRAM bank 1 (63 CONFIRMED + 20 PROBABLE bank contexts in `config/ram_context.tsv`), always right next to `wStatSplitLine` before `Stat_EnableScrollSplit`: 62 store `0` (use the
  default), 5 store `$0A` (address editor, address picker, list) and 8 store `$0B` (name editor, view, save-confirm screens).
* Why PROBABLE: the status is the weaker of the name and the bank contexts (`ram/banked.asm` convention); the reader semantics are demonstrated.  `naming_g8.md` had the lead ("0 or the row index of the keyboard scroll
  tables"); `naming2_ram2.md` kept `wStatSplitParam2` as an idea because the address is banked.

## 3. The SRAM variable page `$BF00-$BFFF` (bank 1)

`Settings_ClearVariableBlock` (`68:4A0F`) zero-fills the page (`ld hl, $BF00 ; ld bc, $0100 ; call FillBytes` with bank 1 selected; 663 hits in 63 scenarios).  Only `BF00-BF05` are used, one byte each, always through the
inline bank-1 access wrapper (`ld a, $01 ; ldh [hSRAMBank], a ; ld [rRAMB], a` in the same block, so the bank of each address is S1):

| name | address | status | evidence |
|---|---|---|---|
| `sVarPage` | `$BF00` | CONFIRMED | the 256-byte block that `Settings_ClearVariableBlock` zero-fills |
| `sTitleMenuCursor` | `$BF00` | PROBABLE | remembered cursor of the title menu: stored from `wRam_C27D` at the exit of `Function_0E_4000` (which returns C27D + 1) and loaded back by `Title_StateLoadTitle` (53+ scenarios); replaces the g1 idea `sSram_TitleLastSelection` |
| `sVarSettingsMenuCursor` | `$BF01` | PROBABLE (already named) | settings-menu cursor |
| `sPhoneTopMenuCursor` | `$BF02` | PROBABLE (already named) | phone-number top-menu cursor |
| `sPhoneSlotMenuCursor` | `$BF03` | PROBABLE | remembered cursor of the dial-slot menu: `SettingsPhone_SlotMenu` stores `wSlotMenu_Cursor` (`wRam_C27D`) at exit and `SettingsPhone_SlotMenu_Setup` loads it; `67:404D` stores the selected dial entry in it and `SettingsPhone_ResetSlotCursor` clears it; adopts the g6 idea |
| `sPhoneMethodMenuCursor` | `$BF04` | PROBABLE (already named) | input-method menu cursor |
| `sKbdInputMode` | `$BF05` | CONFIRMED | persisted keyboard input mode: `Kbd_LoadInputMode` copies it into `wKbdInputMode` (1,473 hits in 31 scenarios; a call with A = 0 sets mode 0 without reading SRAM), `Kbd_SaveInputMode` writes it back (49 hits in 9) |

The 16 raw operands `ld hl, $BF0n` / `$B0BE` of these wrappers now use the names (`sSettingsFieldMask` at `$B0BE` was named already but still written as a number at three sites).

## 4. Raw pointer operands

An immediate `ld hl|de|bc, $XXXX` in the ROM pointer range (`$0150-$7FFF`) is a pointer only when something dereferences it or hands it to a routine that does.  A census over `home/`, `engine/`, `lib/` found 9,787 such
loads, 2,286 of them in the ROM range, and 43 whose number equals the address of a global label *in the same bank* (the 2,200-odd others point into unlabeled data or are constants).  Each of the 43 was read with its
consumer:

* **34 symbolized** (the consumer takes a pointer and the label is in the bank it reads): the attribute keyword tables of the HTML tags (`BC` for `Html_ScanAttributes`: `Html_NoKeywords`, `Html_MetaAttrPtrs`,
  `Html_AnchorAttrPtrs`, `Html_BrAttrPtrs`, `Html_HrAttrPtrs`), the three mail result texts, the mail object palette (`$7520`, bank 27), two settings word tables and one 3-byte table indexed by a screen variable, a page-list tile
  block, and 17 Mobile SDK packet templates and strings (`MobilePacket_*`, `MobileStr_*`, `Data_75_6063`).
* **9 kept numeric** because the number only coincides with the label: `ld de, $7828` (a position pair for `Sprite_SetPosition`, two sites, equal to `BrowserShared_ObjTable`), `ld hl, $4000` in
  `connect_dialog_screen.asm` (a pointer into bank `$56`, given in A for `TextTiles_RenderGrid`, not the file bank), `ld bc, $0684` (the byte count of the checksummed block `A000-A683`, five sites, equal to
  `Bank_InitState`) and `ld de, $1018` (a coordinate pair).

Raw SRAM operands (`ld hl, $A000` ... 376 of them, 121 distinct addresses, only 7 SRAM variables named) are a separate, larger front and are not part of this pass.

## 5. Screen-local aliases of the overlay variables

Not part of this commit: they follow in a separate step (`tools/apply_overlay_aliases.py`, `ram/overlays.asm`); this note is extended when it is applied.

## 6. Reproduce

The edits are text rewrites checked by the build; the decisions of section 4 are in `analysis/naming2/rawptr1_sites.tsv` (one row per rule, with the consumer as evidence and the nine coincidences marked `kept raw`).
`make` must print `RESULT: IDENTICAL` and `make sym-check` must pass after each of them.
