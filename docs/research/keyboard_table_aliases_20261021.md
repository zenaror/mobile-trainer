# Keyboard table aliases (2026-10-21)

Retired nine generic `Table_55_AAAA` globals from `engine/keyboard/keyboard.asm`.
Each was an unreferenced same-address alias of an existing `Kbd_*` or
`Table_Kbd_*` symbol. The aliases cover three direction/dispatch tables, the
cursor-sprite offset pointer list, the page-graphics type table, and the
type-specific keyboard-page loader lists. The retained names already present
in source are the only descriptions adopted; no new behavior or caller contract
is inferred. Table contents, target addresses, confidence and ROM bytes remain
unchanged.
