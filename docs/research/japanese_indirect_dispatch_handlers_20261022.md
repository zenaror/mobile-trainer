# Japanese indirect-dispatch handlers

## Table and handler map

The first five tables use local labels in their own global scope. The progress
handlers occur under `Settings_GetRegistrationProgress`, while the table is a
later global symbol, so its entries use fully qualified local references. This
preserves existing local-label ownership and does not export 23 new global
symbols.

## Original table bytes

The following slices were read directly from `Mobile Trainer (Japan).gbc` using
the banked ROM offset `bank * $4000 + (address - $4000)`:
