# Natural first Help-menu entry: HelpScript $01 (2026-10-23)

## Finding

The first item on Help page 1 naturally enters HelpScript ID `$01`. From the preserved `tutorial_profile` save, ordinary inputs pass the title and top menu, open Help, and accept its first item. `HelpMenu_Run` writes the returned item value to script variable 0 (`$A684`); the bank-6C dispatch at `6C:4809` routes ID `$01` to the initial Mobile Trainer topic.

The complete route shows 18 distinct tutorial pages. Two independent runs each captured the initial Help menu, all 18 distinct page images (`topic_00`–`topic_17`), and the Help page-1 menu after return: 20 captures per run, all 20 PNG hashes byte-identical across runs. A later input in the exploratory probe re-entered the same topic; that repeated partial pass is excluded. The bounded replays stop at the first menu return.

The seed has script bytes `$A684–$A68B = 89 01 01 00 00 00 00 00`; both final saves have `01 01 01 00 00 00 00 00`. The `$A684` selector therefore records ID `$01`. `$A685` remains 1 (already 1 in the seed), so these runs do not demonstrate a flag transition. Dynamic data access records the write span bank 1 `$A684–$A686`; the source tail at `6C:4BBC` stores script variable 1, mapped to `$A685`, before the jump to terminal `6C:58C6`. The top-menu visit also advances its separate natural gate counter `$A89B` from 1 to 2; Mail counter `$A89A` remains 1.

## Scope and reproduction evidence

The observed natural path completes the ID `$01` topic on this save and returns to Help page 1. It does not establish all alternate branches, every glyph/text interpretation, other gate values, or hardware behavior. The older tracked `help` macro is an interrupted path through this same entry because it presses `B` before the terminal; the 18-page count here comes from the separate bounded ordinary-input runs.

Original Japanese ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Tracer SHA-256: `c3a4ac33ea322822c3f1b0f44d8f1e4f7343ac4f39ec9f328f97d98c4ad48867`. Linked `libmgba.so.0.11.0` SHA-256: `4c221287ee524eeb8fcd21ae45c330a70fe10c162637b284e1f9d87fd7dc8923`. The exact macros, input recordings, config/save hashes, all screenshots, run outputs and artifact hashes are in `.tmp/jp-help-id01-natural-20261023/MANIFEST.json`.
