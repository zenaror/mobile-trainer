# Natural first Help-menu entry: HelpScript $01

## Finding

The first item on Help page 1 naturally enters HelpScript ID `$01`.

`HelpMenu_Run` writes the returned item value to script variable 0 (`$A684`); the bank-6C dispatch at `6C:4809` routes ID `$01` to the initial Mobile Trainer topic.

The seed has script bytes `$A684–$A68B = 89 01 01 00 00 00 00 00`; both final saves have `01 01 01 00 00 00 00 00`. The `$A684` selector therefore records ID `$01`. `$A685` remains 1 (already 1 in the seed), so these runs do not demonstrate a flag transition. Dynamic data access records the write span bank 1 `$A684–$A686`; the source tail at `6C:4BBC` stores script variable 1, mapped to `$A685`, before the jump to terminal `6C:58C6`. The top-menu visit also advances its separate natural gate counter `$A89B` from 1 to 2; Mail counter `$A89A` remains 1.

The observed natural path completes the ID `$01` topic on this save and returns to Help page 1. It does not establish all alternate branches, every glyph/text interpretation, other gate values, or hardware behavior. The older tracked `help` macro is an interrupted path through this same entry because it presses `B` before the terminal; the 18-page count here comes from the separate bounded ordinary-input runs.
