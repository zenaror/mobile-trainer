# Bank53 names and Pokémon frame assets: current reference

Re-exporting represented tiles cannot fill missing reaching-VRAM state.

## Bank53 name block

`53:4000..4171` re-emits exactly 369 original bytes: 25 little-endian local pointers (50 bytes) followed by 25 Shift-JIS/NUL strings (319 bytes). Original spacing and the full-width final digit are preserved. The current source calls the pointer table `Table_PokemonNamePointers`; its 25 targets remain `PokemonName00` through `PokemonName24`. These names identify string order and content only. No reader of the table or bank53 name-to-frame association was established.

## Names and limits

The generic table label `Table_53_4000` is now `Table_PokemonNamePointers`. The redundant co-located `String_53_4032` alias was removed; `PokemonName00` already marks the first string. The source search found no operands using either old name. The existing PROBABLE storage classifications remain. No bytes, frame assignments, runtime claims or hardware claims changed.

`python3 tools/gfx_export.py check` passes for 978 catalog assets (408 exact tile PNG sources, 4 raw byte-view sources, 39 font sheets, 1 view-only PNG and 526 assets without PNG sources).

The table contains 25 name ordinals and all 25 strings; no proven name-to-frame reader/producer association links them to a Pokémon image. This leaves the association question open, not a proven set of missing name PNGs. Seventeen windows have conditional editing views; eight remain KEEP because their complete VRAM placement is not justified, although their original bytes, component assets and legacy previews exist. No additional PNG is warranted by this reconciliation, and no window is proven globally unused.

The current full catalogue passes `python3 tools/gfx_export.py check` (978
assets). `make png-check` checks 408 tile sheets, four raw byte views, 37 font
sheets and 95 screen PNGs. It initially exposed stale generated
`gfx/png_rules.tsv` and `gfx/png.mk` after the graphics catalogue/path
reorganization. Regenerating those two derived manifests with
`python3 tools/png_rules.py rules` restored the check; both now pass
`python3 tools/png_rules.py mk-check` and `make png-check`. This confirms the
declared current image sources and rules exist and satisfy their validators;
it does not establish a Pokémon-name-to-frame association or prove that any
candidate frame is unused.
