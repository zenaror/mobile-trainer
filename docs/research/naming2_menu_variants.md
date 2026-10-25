# Names for menu and confirmation-map variants (ROM unchanged)

## Selection conditions and conservative names

Settings entry calls Settings_GetHiddenModeFlag, which selects SRAM1:B012, XORs $A5 and normalizes zero/nonzero to 0/1 before writing C28C (`wHiddenModeFlag`). DrawItems selects 4A:51D0 for zero and 4A:54A0 for nonzero; cursor origin and highlight offset follow the same branch. The menu has four entries (0..3) with flag zero and five (0..4) with flag one. FlagSet/FlagClear state this condition only. The originally considered HiddenMode/NormalMode wording would inherit a PROBABLE interpretation: `wHiddenModeFlag` and `sSettingsHiddenMode` retain their PROBABLE status, rather than gaining certainty from the naturally executed tilemap copy.

Account_ActionConfirmPage stores input A unchanged. Setup chooses 5E:7300 for zero and the shared 5E:75D0 for any nonzero value. Callers pass zero in Registration_Communicate, one in PasswordChange_Run, and manualNumbersFlag+2 (two or three) in PasswordPrompt_Ask. NonzeroVariant therefore describes a shared choice, not one specific alternate variant; Variant0 does not invent button meanings.
