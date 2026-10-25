# Bank 53, Pokémon frame and PNG revalidation

### Current candidate-window and source accounting (2026-10-24; Japanese HEAD `244cf2ae`)

| Physical windows | Editable composition | Legacy preview |
|---|---:|---:|
| `41:4000`, `41:4D50` | 1 each | 1 each |
| `41:5AA0`, `41:67F0` | none (`KEEP`) | 1 each |
| `42:4000`, `42:4D50`, `42:67F0` | 1 each | 1 each |
| `42:5AA0` | none (`KEEP`) | 1 |
| `43:4000`, `43:5AA0` | 1 each | 1 each |
| `43:4D50`, `43:67F0` | none (`KEEP`) | 1 each |
| `44:4000`, `44:5AA0`, `44:67F0` | 1 each | 1 each |
| `44:4D50` | none (`KEEP`) | 1 |
| `45:4000`, `45:5AA0`, `45:67F0` | 1 each | 1 each |
| `45:4D50` | none (`KEEP`) | 1 |
| `46:4000`, `46:4D50`, `46:5AA0` | 1 each | 1 each |
| `46:67F0` | none (`KEEP`) | 1 |
| `47:68F0` | composition at `47:72F0` | none |

### Direct visual species-to-window crosswalk

| Name entry | Decoded name | Visually matching window | Level |
|---|---|---|---|
| `PokemonName02` | Togepi | `46:4000` | PROBABLE |
| `PokemonName03` | Meowth | `46:4D50` | PROBABLE |
| `PokemonName04` | Lugia | `46:5AA0` | PROBABLE |
| `PokemonName05` | Jigglypuff | `46:67F0` | PROBABLE |
| `PokemonName06` | Totodile | `45:4000` | PROBABLE |
| `PokemonName07` | Entei | `45:4D50` | PROBABLE |
| `PokemonName08` | Scizor | `45:5AA0` | PROBABLE |
| `PokemonName09` | Psyduck | `45:67F0` | PROBABLE |
| `PokemonName10` | Umbreon | `44:4000` | PROBABLE |
| `PokemonName11` | Marill | `44:4D50` | PROBABLE |
| `PokemonName12` | Tyranitar | `44:5AA0` | PROBABLE |
| `PokemonName13` | Dragonair | `44:67F0` | PROBABLE |
| `PokemonName14` | Sudowoodo | `43:4000` | PROBABLE |
| `PokemonName16` | Ledyba | `43:5AA0` | PROBABLE |
| `PokemonName17` | Bellossom | `43:67F0` | PROBABLE |
| `PokemonName18` | Mewtwo | `42:4000` | PROBABLE |
| `PokemonName19` | Ho-Oh | `42:4D50` | PROBABLE |
| `PokemonName20` | Wobbuffet | `42:5AA0` | PROBABLE |
| `PokemonName21` | Diglett | `42:67F0` | PROBABLE |
| `PokemonName22` | Venusaur | `41:4000` | PROBABLE |
| `PokemonName23` | Espeon | `41:4D50` | PROBABLE |

#### Ordered name-to-window crosswalk

Sorting the 25 candidate tile windows by physical bank descending and address ascending, then excluding only the two independently identified UI-only panels (`41:5AA0`, `41:67F0`), leaves exactly 23 species-art windows.

That sequence matches `PokemonName01..PokemonName23` one-for-one: `01` maps to `47:68F0`, `02..05` to the four windows in bank 46, `06..09` to bank 45, `10..13` to bank 44, `14..17` to bank 43, `18..21` to bank 42, and `22..23` to `41:4000` and `41:4D50`.

#### Reinspection of the two rodent-like tile sources

The generated `BrowserFrameCandidate_43_1.png` is a synthetic composition, not an emulator screenshot: `tools/render_screens.py::frame_scenes` applies the Bank-47 descriptor layout as an explicit HYPOTHESIS to the Bank-43 package.

### Window-local visual identifications

| Candidate window | Assessment |
| --- | --- |
| `41:4000` | Venusaur-like, PROBABLE |
| `41:4D50` | Espeon-like, PROBABLE |
| `41:5AA0` | No Pokémon identity supported |
| `41:67F0` | No Pokémon identity supported |
| `42:4000` | Mewtwo-like, PROBABLE |
| `42:4D50` | Ho-Oh-like, PROBABLE |
| `42:5AA0` | Wobbuffet-like, PROBABLE |
| `42:67F0` | Diglett-like, PROBABLE |
| `43:4000` | Sudowoodo-like, PROBABLE |
| `43:4D50` | Pikachu/Pichu-like; the two-window distinction remains uncertain |
| `43:5AA0` | Ledyba-like, PROBABLE |
| `43:67F0` | Bellossom-like, PROBABLE |
| `44:4000` | Umbreon-like, PROBABLE |
| `44:4D50` | Marill-like, PROBABLE |
| `44:5AA0` | Tyranitar-like, PROBABLE |
| `44:67F0` | Dragonair-like, PROBABLE |
| `45:4000` | Totodile-like, PROBABLE |
| `45:4D50` | Entei-like, PROBABLE |
| `45:5AA0` | Scizor-like, PROBABLE |
| `45:67F0` | Psyduck-like, PROBABLE |
| `46:4000` | Togepi-like, PROBABLE |
| `46:4D50` | Meowth-like, PROBABLE |
| `46:5AA0` | Lugia-like, PROBABLE |
| `46:67F0` | Jigglypuff-like, PROBABLE |
| `47:68F0` | Pikachu/Pichu-like; the two-window distinction remains uncertain |

The two geometric windows were checked against their exact tile sheets in
`gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/`: the `41:5AA0`
sheet contains a green beveled UI panel with controls/digits, and `41:67F0`
contains an orange beveled UI panel with controls/digits. Neither sheet shows
a Pokémon silhouette. This confirms what those extracted PNGs represent; it
does not prove whether another, unidentified resource is used for either
Porygon name.

### Current direct-symbol consumer matrix

It does not exclude raw byte pointers, computed/indexed addresses, generic descriptors in RAM/SRAM, copied data, or code/data readers with no symbol reference.

### Retained scenario reads of the name and frame extents

A single interval-intersection pass over all 72 retained `traces/detail/*/dataaccess.tsv` reports checked 83,242 recorded `rom_read` ranges against the 25 physical candidate extents: four `$D50` windows in each bank 41–46, plus `47:68F0–7640`.

It also checked the Bank 53 names and strings at `53:4000–4171`.

The same review establishes that OAM DMA reads bypass this hook through a direct `GBLoad8` call.

### Whole-ROM Bank 53 far-pointer-shaped byte scan

A new scan of every byte offset in the protected 2 MiB Japanese ROM checked both adjacent three-byte forms that could encode an address and physical bank: little-endian address then bank, and bank then little-endian address. It found 30 raw shapes pointing into `53:4000–4170`. Each was reconciled against the linked section, nearest symbol, and byte context. The matches are explained by adjacent 16-bit words in `Mail_HeaderStringTable` and `Html_TagPtrs`, graphic/font/text payload bytes, or ordinary instructions (including near-CALL operands and `LD D,E / LD E,B / LD B,C` sequences); none is an identified far-pointer record or consumer of the Bank 53 name block. A separate whole-ROM byte-pattern check found zero occurrences of `LD BC/DE/HL,imm16` adjacent to `LD A,$53`, the reverse ordering, or the inline `CALL FarCall; addr16; bank=$53` form when the target address lies in `53:4000–4170`.

Across 86,789 merged ROM/SRAM intervals (85,013 `rom_read`, 843 `sram_read`, 933 `sram_write`), none of the 85,013 ROM data-read ranges intersects physical Bank 53 `$4000–$4170`.

`make png-check` passes 424 tile sheets, four raw-byte views, 37 font sheets, and 95 screen PNGs; `gfx_export.py check` accepts 994 assets; `png_rules.py mk-check` passes 993 rules.
