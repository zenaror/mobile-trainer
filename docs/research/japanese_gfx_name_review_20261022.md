# Japanese GFX names and paths review (2026-10-22)

## Scope and method

Read-only review of the Japanese tree at `c3484478a6cf5599da59e1f779319bedbfaf2ca3`, covering all tracked files and graphics owners under `gfx/`, the seven TSV catalogs, and the code/source references needed to check cited names. The review deliberately excluded the English overlay, Operator ZIP, protected `engine/mail/sample_data.asm`, and runtime claims. It was a lexical/static naming review, not a visual scan of every PNG or proof of natural asset use.

The inventory contained 1,859 tracked GFX files, 87 GFX ASM owners and 2,283 global definitions in those owners, plus 14 external catalog owners containing 104 definitions. Six frame-design owners (`*_41.asm` through `*_46.asm`) contained 95 globals; 91 names were already explicitly `FrameDesignCandidate_*`. The browser frame owners contained 19 definitions, four already candidate-qualified. These are descriptive family/path names, not generic `bankNN` owners.

## Generic-name findings

- No directory component named exactly `bankNN` and no basename exactly `bankNN.*` exists in the reviewed GFX tree. Descriptive paths ending in `_bankNN` are bank provenance, not generic directory names; old `gfx/bankNN/...` strings in the migration map are historical source paths.
- In the strict global `Type_BB_AAAA` pattern at this review's snapshot, the only GFX definitions were `Data_24_6520` in `gfx/browser/page_list.asm` and `Data_5F_6980` in `gfx/keyboard/panels_bank5f.asm`. The former is now named `ByteMatch_PageListProto_ObjTableFirstRow_24_6520` because its 16 bytes exactly match the first prototype row in bank 7F; this does not establish bank-24 table use. The latter remains neutral: the apparent reader selects bank 71 rather than 5F, and its type is unproven.
- No additional strict `Function_*`, `Font_*`, `Tiles_*`, `Tilemap_*`, `Attrmap_*`, `Palette_*`, or other surveyed type/address definitions or physical stems were found. The expanded review also checked optional separators/bank markers and hex suffixes to distinguish type/address-only names from descriptive names that happen to end in an address.
- `Font_GlyphRun_824F` is not an address label: `824F` is the SJIS code key, while the glyph bytes are stored at `48:4ADB`. The `GlyphFont_Jis12x12_*` family encodes font format, bank and physical fragment.
- The frame-design owners use 91 `FrameDesignCandidate_*` names with descriptive family/context. Their candidate qualifier and comments correctly preserve the fact that a general loader has not been established. Four other names are already descriptive `Attrmap_*` labels. The browser frame descriptors point into named bank-47 resources; this does not prove roles for unselected candidate packages.
- Catalog validation found 978 `assets.tsv` records with paths/owners present and nonempty labels defined in their owners; 95 `screens.tsv` records with existing image/map paths; and 133 preview screen rows (104 loader, five descriptor, 24 hypothesis). Four empty labels are intentional backing-only rows. No catalog defect requiring a generic-path rename was found.

## Corrected Profile transfer slice

The separate 624-byte resource previously called `CandidateTiles_26_7840` is included in a static Profile_InitScreen HDMA request beginning at `26:7820`. It is now `Gfx_Profile_InitScreen_Tiles8020Slice`; static transfer coverage and destination are CONFIRMED, while tilemap selection and display remain unproved. The precise interval, original-ROM opcode cross-check, two independent reviews and preserved hashes are in [the slice audit](japanese_profile_init_screen_tile_slice_20261022.md). This corrects the earlier search result that looked only for a transfer beginning exactly at `26:7840`.

## Remaining limits

This review found no additional graphics folder/path cases like a directory literally named `bank41` or `bank42`, and no generic GFX symbol families beyond the two neutral `Data_*` labels above. It does not close the 13 neutral `Data_BB_AAAA` definitions across all maintained roots, prove that graphics are selected/displayed, establish that candidate assets are unused, or claim semantic understanding of every function. Those broader name and behavior limits are tracked in the [Japanese generic-name census](japanese_generic_name_census_20261023.md) and top-level status.
