# Names for menu and confirmation-map variants (ROM unchanged)

> Status: **reference (current)**. Four existing labels renamed to state their proved selection conditions. No data, layout, asset path or RAM evidence level changes.

| address | old label | new label | natural demonstrating call |
|---|---|---|---|
| 4A:54A0 | `Tilemap_SettingsMenu` | `Tilemap_SettingsMenu_FlagSet` | 68:5250, 96 hits / 3 scenarios |
| 4A:51D0 | `Tilemap_SettingsMenu_4A_51D0` | `Tilemap_SettingsMenu_FlagClear` | 68:523D, 765 / 13 |
| 5E:75D0 | `Tilemap_Account_ActionConfirmPage` | `Tilemap_Account_ActionConfirmPage_NonzeroVariant` | 68:6EBB, 192 / 12 |
| 5E:7300 | `Tilemap_Account_ActionConfirmPage_5E_7300` | `Tilemap_Account_ActionConfirmPage_Variant0` | 68:6ECE, 21 / 7 |

All four roles are CONFIRMED by the existing natural demonstrating calls, the conditional control flow and all use sites. Each consumer copies 18x20 tiles followed by 18x20 attributes: 720 original-ROM bytes without offset or overread. The source pointer/bank sequence and compiled symbols establish the selected ROM bank; no new emulation or PPU evidence was added.

## Selection conditions and conservative names

Settings entry calls Settings_GetHiddenModeFlag, which selects SRAM1:B012, XORs $A5 and normalizes zero/nonzero to 0/1 before writing C28C (`wHiddenModeFlag`). DrawItems selects 4A:51D0 for zero and 4A:54A0 for nonzero; cursor origin and highlight offset follow the same branch. The menu has four entries (0..3) with flag zero and five (0..4) with flag one. FlagSet/FlagClear state this condition only. The originally considered HiddenMode/NormalMode wording would inherit a PROBABLE interpretation: `wHiddenModeFlag` and `sSettingsHiddenMode` retain their PROBABLE status, rather than gaining certainty from the naturally executed tilemap copy.

Account_ActionConfirmPage stores input A unchanged. Setup chooses 5E:7300 for zero and the shared 5E:75D0 for any nonzero value. Callers pass zero in Registration_Communicate, one in PasswordChange_Run, and manualNumbersFlag+2 (two or three) in PasswordPrompt_Ask. NonzeroVariant therefore describes a shared choice, not one specific alternate variant; Variant0 does not invent button meanings.

## Integration

The fresh reviewer audited all 35 exact-token occurrences (7/8/12/8 per label), including historical records. Active integration changes exactly 24: 12 definitions/instruction operands, four asset-label fields, four preview-operation label fields and four alias-evidence names (two in each active alias record/source). Existing neutral Data aliases, paths, binaries, historical manifests/research and the frozen generator/config remain unchanged. Broad-map asset rows already using neutral aliases remain valid; only the four asset rows with the old counterpart labels are rewritten. No source line was inserted or removed.

`analysis/naming2/menu_variant_renames.tsv` records the four reviewed names. The strict rename tool builds and checks the original SHA and symbols; the coordinator also proves that the complete working diff is exactly the 24 reviewed token substitutions. A pattern scan of immediate consumers does not prove the absence of computed pointers; the full source/preview census supplies the bounded use inventory.
