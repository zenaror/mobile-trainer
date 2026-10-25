# Bank 53, Pokémon frame and PNG revalidation (2026-10-24)

This finite Japanese-only recheck was first recorded at documentation HEAD `8dd8d59d0246b2c5c7f2f042cca7c26c33b9ac96` against maintained-source baseline `25501d4b80a8370ab2b7482dd8388f99ca4df417`. The original `Mobile Trainer (Japan).gbc` is 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The counts below describe that original finite-audit snapshot; the current six-asset delta is reconciled explicitly below.

## Bank 53 name block

A read-only decode of the original bank at physical bank `53` confirms the range `53:4000-4171` contains 25 little-endian pointers and 25 NUL-terminated Japanese strings: 50 pointer bytes plus 319 string bytes, 369 bytes total. All pointers are strictly increasing and target the string interval `53:4032-4171`. The remainder of bank 53 through `53:8000` is zero. The rebuilt `mobile_trainer.gbc` has the same whole-ROM SHA-256 as the protected original.

These facts confirm the complete encoded name table and its byte placement. They do not establish a reader, natural selection, or association between any name ordinal and a frame image.

### Exact Bank-53 far-pointer byte patterns (2026-10-24)

The preserved ROM was searched for literal three-byte pointer encodings to the
table address `$4000` and all 25 string starts `$4032-$4164`, in both
`address16 LE, bank $53` and `bank $53, address16 LE` order. It was also
searched for the text interpreter's nested-string record `[ $01, address16 LE,
$53 ]` at each target. Across 52 far-pointer patterns and 26 nested-text
records, the original ROM has zero matches. The scan revalidated the original
2 MiB ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; its
maintained Bank 53 source SHA-256 is
`ca00c038309628db8a948a5895071a4a2ae336f40f1d54e190c0f8dd6eeec2dd`.

This closes only those exact literal pointer forms. It does not detect
register/arithmetic-built addresses, split bank/address fields, computed bank
selection, copied records, or an external pointer passed to a generic text or
far-read API. Therefore it adds no confirmed Pokémon-name/frame association
and does not prove the table or any frame globally unused. Reproduction:
`audit.py` (review artifact) (SHA-256
`8c5e184743ee40c491a3bdb54beb37ddb7430f574178fc1c79583c7258bb2aa7`);
`RESULT.json` SHA-256
`101afdd5ba841392cc4071b28bddc645befee9ce22a7278bb492ebe8a34aef20`.

## Bank 41–47 assets and PNGs

At the original audit snapshot, `gfx/assets.tsv` had 137 rows across eight owner directories for physical banks `41–47`, totaling 93,264 bytes: 49 tile assets, 28 palettes, 28 tilemaps, 28 attribute maps, and four raw-byte views. Every file in that snapshot reconstructed the corresponding original-ROM slice. The audit interprets the catalog bank column as hexadecimal and uses file offset `bank * 0x4000 + address - 0x4000`; palette text is decoded with the project's `tools.gfx_export.palette_bytes` implementation.

At the original audit snapshot, the eight owner directories contained 71 PNGs: 53 source PNGs from the asset catalog and 18 screen compositions from `gfx/screens.tsv`. Their union matched the files present in scope, with zero missing or orphan PNGs. This is a bounded inventory; it does not claim every ROM graphic has been discovered or naturally displayed.

At that audit snapshot, `make png-check` accepted 418 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs; `python3 tools/gfx_export.py check` accepted 988 assets; `python3 tools/png_rules.py mk-check` accepted 987 rules. Those are historical snapshot counts; the current aggregate gates are recorded in `REVERSE_ENGINEERING.md`.

### Current Bank 41–47 delta (2026-10-24)

A row-level comparison of `gfx/assets.tsv` at the original baseline `25501d4b` and current source revision `b9a591ce` found exactly six added rows in physical Bank 42, with no removed or modified rows in the audited Bank 41–47 scope. Each row is a separate 16-byte `PROBABLE` tile candidate at `42:48A2`, `42:5E50`, `42:6132`, `42:6340`, `42:7092`, or `42:7190`. The six corresponding PNGs exist; together the source adds 96 bytes and six editable tile PNGs.

The current bounded totals are therefore 143 catalogued assets / 93,360 bytes (55 tile assets, 28 palettes, 28 tilemaps, 28 attribute maps, and four raw-byte views) and 77 PNG files across the same eight owner directories (59 asset-source PNGs plus 18 screen compositions). A direct manifest-to-files comparison found all 77 referenced PNGs present and zero orphan PNGs. The inherited byte/PNG checks for the original 137-row snapshot remain valid because none of those rows changed; current aggregate `png-check`, GFX catalog, and PNG-rule gate counts are stated in `REVERSE_ENGINEERING.md`. These six fragments complete candidate tile boundaries only; natural loading, consumption, and semantic ownership remain unconfirmed.

### Current candidate-window and source accounting (2026-10-24; Japanese HEAD `244cf2ae`)

An independent read-only reconciliation covers the 25 physical candidate windows. All have a PNG representation: 17 editable screen compositions plus 24 legacy previews, with eight views retained as `KEEP` because their full VRAM placement is not established. The grouped window coverage is:

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

The current inventory intersecting those windows contains 124 assets (45 tile, four raw-byte, 25 tilemap, 25 attribute-map and 25 palette rows), totaling 82,880 bytes. The seven owner sources re-emit all 85,200 bytes in the 25 windows. Outside the tile/raw rows, the remaining 2,320 bytes are zero-filled `ds` spans: 832 bytes in `42:4000`, 528 in `42:5AA0`, and 960 in `42:67F0`; these are not omitted graphics payloads. Across the eight Bank 41–47 owner directories, all 143 assets / 93,360 bytes match the ROM. All 77 PNGs referenced by the current asset and screen manifests exist in scope, with no missing or orphan PNG; all 77 pass PNG signature and chunk-CRC checks. This verifies file and manifest integrity, not rendered-pixel identity. Current inputs: `gfx/assets.tsv` SHA-256 `ab4e9d903187fc038213d17ae98923d7b99ec2be4949492ac0d4b2780a4991b5`; `gfx/screens.tsv` SHA-256 `99d6856d1ba7358332e09f8c2e21a68329a5fd876f963a4e701eb1f78d17359d`; Bank 53 ROM name block SHA-256 `20a909ec6fcf6726d2b2b3cc2540bc4d897916a18cab24d5892d09600b18d629`. None of this supplies a Pokémon-name/frame link or a natural frame-selection route.

## Independent frame-style descriptor lookup

A read-only cross-check of the maintained source and original-ROM bytes confirms that `Browser_LoadFrameGraphics` indexes the 27-word table at `4E:654B` with `wBrowserFrameStyle & $7F`; the chooser uses the same descriptor table. The table resolves to five descriptor records, whose tile payload roots are all in physical bank `47`:

| style index | descriptor | bank-47 tile root |
|---:|---:|---:|
| 0 | `4E:6581` (`Data_Browser_FrameDesc0`) | `47:4100` |
| 1 | `4E:65A0` (`Data_Browser_FrameDesc1`) | `47:4E50` |
| 2 | `4E:65BF` (`Data_Browser_FrameDesc2`) | `47:5BA0` |
| 3–22 | `4E:65DE` (`Data_Browser_FrameDesc3`) | `47:5BA0` |
| 23–26 | `4E:65FD` (`Data_Browser_FrameDesc23`) | `47:4E50` |

The descriptor records select bank-47 graphics, palette, and tilemap resources; they do not read `Table_PokemonNamePointers` at `53:4000` or the 25 candidate frame windows audited separately. The equal count of 25 names and 25 candidate windows therefore supplies no association evidence. The mask permits style values 27–127 to index beyond the 27 entries; this static audit does not establish whether such values occur naturally or what follows them. It also does not prove global frame usage, unused status, or an on-screen rendering. Sources: `engine/browser/frame_graphics.asm` (`4E:6196`, `4E:654B–661C`), `engine/browser/frame_style_chooser.asm`, `gfx/browser/frames_0_1.asm`, `gfx/browser/frames_2_3.asm`, and `data/text/pokemon_names_bank53.asm`. The original Japanese ROM hash is the one stated above; this is static source/byte analysis, not new runtime evidence.

## Current style producers and selector boundary (2026-10-24)

A grouped source pass at documentation commit `55e089ba497c71d790b87ceabb38e6a46bbf7f7f` traced all explicit writers and consumers of `wBrowserFrameStyle` (`$C2C2`), `sBrowserFrameStyle` (SRAM1:`$A9EF`), and the preview scratch `hFramePreview_Style` (`$FFD2`). It found eight explicit C2C2 writers: homepage and staged-URL startup set 1 (`engine/browser/session_start.asm:46–47,77–78`); URL-from-SRAM sets 0 (`:15–18`); dictionary view sets 2 before loading the frame (`engine/help/mobile_dictionary_view.asm:29–31`); `Browser_BeginSession` loads SRAM, masks `$7F`, and replaces 0 with 1 (`engine/sram/save_block_check.asm:54–65`); preview Run copies FFD2 (`engine/browser/frame_style_chooser.asm:154–155`); preview A stores FFD2 OR `$80` to RAM and SRAM (`:204–207`); preview B copies the persisted byte back (`:222–223`). Boot/init also wipes C2C2 to zero (`home/init.asm:61–64`; `engine/startup/boot_stage2.asm:24–27,90–93`). Four explicit SRAM writers normalize a prior value, reset to 1, or accept the external preview value with bit 7 set (`save_block_check.asm:25–35,54–64,151–163`; `frame_style_chooser.asm:204–207`).

The natural paths identified set home/page-list style 1, usage URL style 0, and dictionary style 2. The 27 declared table entries remain styles 0–26 and resolve only to the five bank-47 descriptors above. `SaveCheck_Verify` bounds the persisted low-seven-bit style to 1–26 (`save_block_check.asm:102–107`), but this does not constrain every input: the preview starts from an external A value copied to FFD2, and its natural caller/value remain unproved. The preview accepts A/B and ignores Select/Start; it contains no selector that walks the 25-name table or increments a Pokémon ordinal (`frame_style_chooser.asm:177–235`). No edge from `53:4000–4171` to the frame descriptor graph was found in this bounded explicit source graph.

### Out-of-range selector writer and copy-alias check (2026-10-24)

A targeted Japanese-source pass checked whether maintained memory-copy paths
can bypass the eight named writers and alter `wBrowserFrameStyle` at
`$C2C2`. It scanned 349 tracked ASM/INC files, excluding
`engine/mail/sample_data.asm` before reading and excluding the paused English
overlay. There are 30 lexical references to the style symbol (eight stores);
the only raw `$C2C2` operand is its WRAM declaration. The current linker map
has no second symbol at that address.

The existing 311-call generic-copy census was cross-checked for nearby direct
`DE` destinations in WRAM0. Only one site resolves into that window:
`Account_CopyMailAddressToFar` copies the NUL-terminated decoded settings
address to `$C27F`. Its source field is bounded to 25 bytes, so the copy ends
at `$C298`, 42 bytes before `$C2C2`. Of the `FillBytes` calls with a nearby
direct `HL` setup in WRAM0, all 13 target `$C0D4` for `$00FC` bytes and end
at `$C1D0`; none reaches the style byte. The separate 27-site
`WriteByteFar` census is recorded in
[`naming_70_46a6_sram_boundaries.md`](naming_70_46a6_sram_boundaries.md#writebytefar-caller-census-and-bounded-sram-write-routes-2026-10-24);
its listed maintained destinations likewise do not target `$C2C2`.

This closes the exact-symbol writers and these direct lexical copy/fill
destinations under their documented contracts. It does not bound register-
or stack-derived pointers, arbitrary external API callers, malformed state,
or unrecognized code. In particular, the preview's A input still has no
maintained natural caller/value, so the 16 out-of-ROM descriptor reads remain
conditional and cannot be promoted to natural behavior global non-use.
Reproduce the targeted checks with
`audit.py` (review artifact); receipt
`RESULT.json` pins the Japanese source manifest, linker symbols, and retained
generic-copy census.

A separate read-only decode enumerated all 128 masked selector indices. The 112 whose descriptor pointers lie in ROM yield 560 far fields; none names bank `$53`. Of the 85 out-of-range indices that still point to ROM, index 61 aliases descriptor `4E:65A0` and its bank-47 frame-1 resources. The other 16 indices point outside ROM into state-dependent regions: WRAM (`28,50,51,56,81,82,87`), VRAM (`41,54,70,72,103`), or SRAM (`62,73,76,79`). These are not established descriptors; their contents/accessibility are unknown and were not interpreted as frame records. FFD2 is also scratch for HTML images, URL lists, and blit masks, but no known executable path transports those uses into the preview input.

### Out-of-range selector fields versus candidate windows (2026-10-24)

A targeted decode checked the five far-pointer fields the frame loader would read for each out-of-range masked index `27..127`. The 85 indices whose selected descriptor address maps to ROM yield 425 readable fields; none points into any of the 24 candidate windows in physical banks `41..46`, and none points into the Bank 53 name block `53:4000–4170`. The other 16 indices select addresses outside ROM, so this pass does not interpret their state-dependent contents as descriptors. This closes only the candidate-window/name-block route through these out-of-range selector values when the selected descriptor bytes are in ROM. It does not show that an out-of-range style is or is not supplied naturally, and does not constrain another loader or computed reader.

Reproduction: `audit.py` (review artifact) (SHA-256 `d0de7c3650c309b1d5e8f68cbbdb64e1fea348dcb57b1526ca18405b7735c381`) and `RESULT.json` (SHA-256 `17c3233fad4d3d1783ecb4a090ab7bbaff8bd5d7e9770929d271762b8c2be1b6`). The script pins the original ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and hashes `engine/browser/frame_graphics.asm`; it maps CPU `$0000–$3FFF` to physical ROM0 and `$4000–$7FFF` to physical Bank `4E`.

The explicit producer graph therefore confirms no name-ordinal-to-frame chain and narrows ordinary natural paths, but it does **not** prove that the external preview input is unreachable, that RAM descriptors are globally unused, or that all 25 name-to-window links are absent. Keep all executable links **HYPOTHESIS** and all natural-selection/global-unused claims open until a producer or trace supplies the name ordinal and physical frame bank/address together.

### Correction: indirect preview targets from out-of-range tables (2026-10-25)

The earlier whole-ROM byte search established no direct call or literal far-pointer triple to `4E:4000`; it did not cover malformed `JumpTableInline` indices. A later reconciliation of the retained 49-table/7,022-case matrix found 18 out-of-declared-table entries that decode to `4E:4000`. Their maintained producers remain within valid fetch-result, dialog, or browser-menu domains. If an invalid index is forced, `JumpTableInline` loads the target word's low byte into A, so this entry receives `A=0` and selects descriptor 0. This corrects the earlier broad wording that implied no indirect pointer existed; it does not establish a natural preview entry or a Pokémon-name/frame link. See [the bounded indirect preview audit](japanese_semantic_roots_and_destinations_20261025.md#indirect-malformed-index-path-to-the-frame-preview-2026-10-25) and `jp-preview-indirect-overflow-20261025` (review artifact).

## Remaining frame questions

This paragraph records the **2026-10-24 visual baseline** and is superseded for the 23 species-art windows by the ordered crosswalk added on 2026-10-25 below: the bank/address ordering yields PROBABLE intended matches for PokemonName01..PokemonName23, resolving the Pikachu/Pichu visual ordering proposal. The two remaining geometric candidates (`41:5AA0`, `41:67F0`) are UI panels, not Porygon/Porygon2 frames. The 25 executable name-to-window associations, natural frame selection and global use status remain unresolved; do not assign Porygon entries by elimination, synthesize unresolved VRAM keys, or treat a missing editable composition as a missing ROM asset. Eight windows remain KEEP as editable compositions because their complete VRAM placement is not justified; their original bytes and backing assets exist.

### Direct visual species-to-window crosswalk (2026-10-24)

Joining the decoded Bank 53 strings to the existing window-local visual review
gives 21 **PROBABLE visual correspondences**. This is an image-identity
crosswalk, not proof that the program reads the name table or selects the
matching window by ordinal. The physical-window descriptions and PNG evidence
are listed below; the species names come from `PokemonName00..PokemonName24`
in `data/text/pokemon_names_bank53.asm`.

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

`PokemonName01` (Pikachu) and `PokemonName15` (Pichu) remain jointly
ambiguous between the rodent-like windows `43:4D50` and `47:68F0`; the current
visual review cannot choose either pairing. `PokemonName00` (Porygon) and
`PokemonName24` (Porygon2) remain unmatched in this 25-window review. The later
Bank 51 pixel comparison adds a separate **PROBABLE** visual association for
`PokemonName24`; it does not place Porygon2 in either panel or establish an
executable ordinal edge. The geometric/panel windows
`41:5AA0` and `41:67F0` have no supported Pokémon identity and are not assigned
to those names by elimination. Therefore 21 species identities are resolved
visually, while all 25 executable ordinal-to-window links, natural selection,
and global used/unused classifications remain open.

#### Ordered name-to-window crosswalk (2026-10-25)

A separate structural comparison resolves the two visually ambiguous entries
to a **PROBABLE intended ordinal/window mapping**. The 25 name pointers are in
ordinal order. Sorting the 25 candidate tile windows by physical bank descending
and address ascending, then excluding only the two independently identified
UI-only panels (`41:5AA0`, `41:67F0`), leaves exactly 23 species-art windows.
That sequence matches `PokemonName01..PokemonName23` one-for-one: `01` maps to
`47:68F0`, `02..05` to the four windows in bank 46, `06..09` to bank 45,
`10..13` to bank 44, `14..17` to bank 43, `18..21` to bank 42, and `22..23` to
`41:4000` and `41:4D50`. The prior visual crosswalk independently identifies
the entries `02..14`, `16..23`; the order resolves the remaining pair as
`PokemonName01` Pikachu → `47:68F0` and `PokemonName15` Pichu → `43:4D50`.

This alignment, combined with the visible species-like artwork, is strong
evidence for the intended asset ordering. It is still not an executable
association: the maintained source graph has no demonstrated reader that takes
an ordinal from `Table_PokemonNamePointers` and selects the corresponding
physical window. `PokemonName00` (Porygon) and `PokemonName24` (Porygon2) have
no corresponding species-art window in this 25-window set; the two panel
windows are not substituted for them. A later Bank 51 pixel comparison gives
separate **PROBABLE** visual evidence for Porygon2 art outside this set; see
“Bank 51 Pokémon-art candidate boundary correction” in the current semantic
research note. This still supplies no executable name reader or natural
selector. No candidate is thereby proven naturally loaded or globally
used/unused.

Reproduction: `audit.py` (review artifact) (SHA-256
`b8930ab085262d1e3528a3979844c424de24bfd46a98ef769d04a39a866a4037`), receipt
`RESULT.json` (SHA-256
`136e4aebe563cfb3f3aefb191f3d772f9c712d1b9c2414d7a0ca83202101dc69`). The
script pins the protected ROM and hashes the name source and asset manifest;
it verifies 25 candidate tile-window starts and the exact 23-to-23 ordering.
The two panel exclusions are inputs from the window-local visual review above.

The later BetaP2 pixel match adds a visual Porygon2 association outside this
25-window sequence. It does not change the 23-to-23 Bank41–47 crosswalk or
resolve the missing `PokemonName00` asset, natural selection, or an executable
name/frame association. The former one-byte-shifted Bank51 source is
superseded by `[51:5EE0,51:70D0)`; see the current correction and receipt in
[`japanese_semantic_roots_and_destinations_20261025.md`](japanese_semantic_roots_and_destinations_20261025.md#bank-51-pokemon-art-candidate-boundary-correction-2026-10-25).

#### Reinspection of the two rodent-like tile sources

The exact tile PNG for `43:4D50` (`blue_yellow_chevron_border_43_4d50_tiles.png`, SHA-256 `4c0bbca1753b80992588edfea5e1c6193f14a8805f51ae45fad289b512447aab`) contains two small animal faces flanking the “START MENU / B BACK” artwork. The separate `47:68F0` source is a profile-like yellow head in its candidate screen composition (PNG SHA-256 `101d974b982b4eeba83e7a83047948dc99dc6b0619330af76ffeeac21f469ffd`). These are positive visual observations only: they do not identify the individual faces as Pikachu or Pichu, nor associate either name ordinal with either source.

The generated `BrowserFrameCandidate_43_1.png` is a synthetic composition, not an emulator screenshot: `tools/render_screens.py::frame_scenes` applies the Bank-47 descriptor layout as an explicit HYPOTHESIS to the Bank-43 package. The retained preview metadata marks it `hypothesis` and `no capture`; it must not be cited as runtime evidence. The reproduced candidate image is `BrowserFrameCandidate_43_1.png` (review artifact) (SHA-256 `6c2b5c8dbfc0c49be11730ef0e28b98f845c0f5cb7c73efac94727f37750679b`), generated with `tools/render_screens.py` SHA-256 `6e481c771351587764cb1dd13d58504c0bd7d54c9a75d5f79f5121ba0f67cbe4`. This synthetic-pixel review alone leaves the two rodent identities and ordinal links unresolved; the separate ordered comparison below supplies a PROBABLE intended pairing, while executable selection remains unproved.

### Window-local visual identifications (2026-10-24)

A read-only reinspection of the existing candidate previews and component PNGs
supports the following **visual** identities. These describe artwork visible
in a candidate window; they do not establish a Bank 53 ordinal, executable
pointer, selector value, natural selection, or runtime use.

| Candidate window | Visual evidence | Assessment |
|---|---|---|
| `41:4000` | `gfx/previews/screens/BrowserFrameCandidate_41_0.png`: broad head, foliage and flower | Venusaur-like, PROBABLE |
| `41:4D50` | `gfx/previews/screens/BrowserFrameCandidate_41_1.png`: lilac feline, long ears and forehead gem | Espeon-like, PROBABLE |
| `41:5AA0` | `gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/green_beveled_panel_41_5aa0_tiles.png`: beveled panels, UI parts and digits | No Pokémon identity supported |
| `41:67F0` | `gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/orange_beveled_panel_41_67f0_tiles.png`: interface pieces, border and digits | No Pokémon identity supported |
| `42:4000` | `gfx/previews/screens/BrowserFrameCandidate_42_0.png`: pale humanoid, pointed head and curved arm | Mewtwo-like, PROBABLE |
| `42:4D50` | `gfx/previews/screens/BrowserFrameCandidate_42_1.png`: red bird head, yellow crest and beak | Ho-Oh-like, PROBABLE |
| `42:5AA0` | `gfx/previews/screens/BrowserFrameCandidate_42_2.png`: elongated blue figures with raised arms | Wobbuffet-like, PROBABLE |
| `42:67F0` | `gfx/previews/screens/BrowserFrameCandidate_42_3.png`: rounded brown heads with oval noses | Diglett-like, PROBABLE |
| `43:4000` | `gfx/previews/screens/BrowserFrameCandidate_43_0.png`: brown trunk and arms with green balls | Sudowoodo-like, PROBABLE |
| `43:4D50` | `gfx/frame_designs/plant_chevron_and_heart_borders_43/blue_yellow_chevron_border_43_4d50_tiles.png`: frontal yellow rodent faces, dark pointed ears and cheeks | Pikachu/Pichu-like; the two-window distinction remains uncertain |
| `43:5AA0` | `gfx/previews/screens/BrowserFrameCandidate_43_2.png`: red insect, large eyes and antennae | Ledyba-like, PROBABLE |
| `43:67F0` | `gfx/frame_designs/plant_chevron_and_heart_borders_43/heart_and_flower_border_43_67f0_tiles.png`: paired head flowers and leaf skirt | Bellossom-like, PROBABLE |
| `44:4000` | `gfx/previews/screens/BrowserFrameCandidate_44_0.png`: dark body, yellow rings and red eye | Umbreon-like, PROBABLE |
| `44:4D50` | `gfx/frame_designs/arc_bubble_rock_and_scroll_borders_44/blue_bubble_border_44_4d50_tiles.png`: round ears and pale belly | Marill-like, PROBABLE |
| `44:5AA0` | `gfx/previews/screens/BrowserFrameCandidate_44_2.png`: green creature with spikes | Tyranitar-like, PROBABLE |
| `44:67F0` | `gfx/previews/screens/BrowserFrameCandidate_44_3.png`: blue serpent, small horn and pale appendages | Dragonair-like, PROBABLE |
| `45:4000` | `gfx/previews/screens/BrowserFrameCandidate_45_0.png`: blue crocodile with toothed mouth | Totodile-like, PROBABLE |
| `45:4D50` | `gfx/frame_designs/ice_spike_curve_and_gold_borders_45/violet_spike_border_45_4d50_tiles.png`: crown/mask and angular mane | Entei-like, PROBABLE |
| `45:5AA0` | `gfx/previews/screens/BrowserFrameCandidate_45_2.png`: red creature and marked pincer | Scizor-like, PROBABLE |
| `45:67F0` | `gfx/previews/screens/BrowserFrameCandidate_45_3.png`: yellow head, large eyes and broad bill | Psyduck-like, PROBABLE |
| `46:4000` | `gfx/previews/screens/BrowserFrameCandidate_46_0.png`: spiked egg body with triangular marks | Togepi-like, PROBABLE |
| `46:4D50` | `gfx/previews/screens/BrowserFrameCandidate_46_1.png`: frontal coin and whiskers | Meowth-like, PROBABLE |
| `46:5AA0` | `gfx/previews/screens/BrowserFrameCandidate_46_2.png`: pale elongated head and dark eye marking | Lugia-like, PROBABLE |
| `46:67F0` | `gfx/frame_designs/star_rivet_energy_and_scallop_borders_46/pink_scallop_border_46_67f0_tiles.png`: round face, large eyes and forelock | Jigglypuff-like, PROBABLE |
| `47:68F0` | `gfx/browser/frames_2_3/browser_frame_candidate_72f0.screen.png`: yellow head in profile, dark ear and cheek | Pikachu/Pichu-like; the two-window distinction remains uncertain |

The two geometric windows were checked against their exact tile sheets in
`gfx/frame_designs/foliage_ribbon_and_beveled_panels_41/`: the `41:5AA0`
sheet contains a green beveled UI panel with controls/digits, and `41:67F0`
contains an orange beveled UI panel with controls/digits. Neither sheet shows
a Pokémon silhouette. This confirms what those extracted PNGs represent; it
does not prove whether another, unidentified resource is used for either
Porygon name.

The review supports 21 distinctive visual identities and two rodent-like
windows. The rendered pixels alone do not decide which rodent depiction is
Pikachu and which is Pichu; the separate sequence alignment above supplies a
PROBABLE intended pairing. It finds no Porygon-like silhouette in `41:5AA0` or
`41:67F0`; their “geometric Porygon” interpretation remains unsupported. The four
decisive component PNG hashes are, respectively, `203402ee8432d32eea02cfeee20d58f50caceb2180d876016c106cf23317d7b6`,
`79d6224cb981cf021a12ce84e1164c60098599f7b286f10eeaf172c29ebaa7b5`,
`4c0bbca1753b80992588edfea5e1c6193f14a8805f51ae45fad289b512447aab`, and
`101d974b982b4eeba83e7a83047948dc99dc6b0619330af76ffeeac21f469ffd`.

### Current extracted-visual corpus review for the Porygon entry (2026-10-25)

The earlier window-local inspection found no Porygon-like figure in the two
geometric Bank 41 windows. I expanded that question to the current extracted
visual corpus: all 425 exact tile PNGs named by `gfx/assets.tsv`, all 48
derived sprite-table preview sheets, and all 160 composed screen previews.
The contact sheets were regenerated from the current asset manifest, and the
screen source and contact-sheet hashes from the earlier local census were
rechecked; all 160 source files and six contact sheets still match. The new
current tile/sprite receipt records `gfx/assets.tsv` SHA-256
`a7a24320a22cd7f9eb2ed88ff544dfde17ed41c47bf4841ab5133e54857d6729` and is
`RESULT.json` (review artifact) (SHA-256
`edd7cd953def65d98cca702f7a1caa5b8bdc9d2ebfba73b49a8fdd103fd7a513`). The
screen inventory and hashes are in `SCREEN_RESULT.json` (SHA-256
`f67b9cc3bca44e104e8d36444124c7ccf84ed6602173ea352d9e9a0b029138f4`); the
manual visual disposition is `VISUAL_REVIEW.json` (SHA-256
`e274f5479715a97d99e42d934b2a4f5b9e7c8d990410691ea1a669f40538914d`).

I did not recognize a Porygon-like image elsewhere in those extracted tiles,
sprite sheets, or composed screens. The separate Bank 51 comparison remains
**PROBABLE** for `PokemonName24` (Porygon2), but does not identify art for
`PokemonName00` (Porygon). This is a visual search within the listed PNG
corpus, not proof that the original ROM lacks Porygon art: transformed,
partial, palette-dependent, compressed, or unextracted graphics could be
missed. It also does not establish an executable reader, ordinal mapping,
runtime selection, or global use/non-use. The earlier contact-sheet receipt
`RESULT.json` (review artifact) (SHA-256
`e9af114a5e76bb2d738f734b2007665719c27b5b2b290abf4dd244bc071b1d40`) is
stale against the current asset manifest and was preserved, not used as the
current census.

### Current direct-symbol consumer matrix (2026-10-24)

A grouped scan of 349 maintained Japanese ASM/INC sources (including root constant/include files and `ram/`, excluding `engine/mail/sample_data.asm` before reading and excluding language overlays) checked the 26 Bank 53 name symbols and every labeled asset whose start falls inside the 25 candidate windows. It found zero external references to the name symbols and zero external references to the 104 candidate-window asset labels across the eight Bank 41–47 owner files. The 124 asset rows in those windows remain present in the manifest; this result means their editable source labels are not directly named by another maintained source file. It does not exclude raw byte pointers, computed/indexed addresses, generic descriptors in RAM/SRAM, copied data, or code/data readers with no symbol reference.

This aligns with the separately decoded ordinary browser frame selector: its declared styles select Bank 47 resources, while the bounded 0–127 selector projection has no fields pointing to the 25 candidate windows or Bank 53. Together, these checks establish no direct-symbol name-to-window chain in the maintained sources and no candidate-window selection through the modeled browser frame descriptor table. They do not prove global non-use or identify the 25 visual pairings. Receipt `RESULT.json` (review artifact) SHA-256 `59fab2120f5a733536db513a826a25faf0002cc96262bd19a6616499cf91135f`; reproduction script `audit.py` SHA-256 `012819077f38ca219899b3a5f091fde72aa61c90eaaeed4d8c9ed00a9d5fbff0`. The receipt pins ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, `gfx/assets.tsv` SHA-256 `ab4e9d903187fc038213d17ae98923d7b99ec2be4949492ac0d4b2780a4991b5`, and source-manifest SHA-256 `c7f07027ac4fb5581e59140f38acd90c1188e383f6ecc32f2be4c607fd2af6e6`.

### Retained scenario reads of the name and frame extents (2026-10-24)

A single interval-intersection pass over all 72 retained `traces/detail/*/dataaccess.tsv` reports checked 83,242 recorded `rom_read` ranges against the 25 physical candidate extents: four `$D50` windows in each bank 41–46, plus `47:68F0–7640`. It also checked the Bank 53 names and strings at `53:4000–4171`. The pass found zero overlapping reads in either domain. Source review of the exact mGBA revision used by the tracer establishes that these ranges include HDMA source reads: `_GBMemoryHDMAService` calls the hooked `cpu->memory.load8` at `src/gb/memory.c`, while `hookLoad8` in `tools/trace/mgba_trace.c` records ROM-window reads. The same review establishes that OAM DMA reads bypass this hook through a direct `GBLoad8` call. The retained `hwregs.tsv` census has 52 reports with OAM-DMA records; all 1,561,837 writes are from `HRAM:FF82` with source page `$C0`, so this observed OAM path reads WRAM, not the ROM candidate extents. The result therefore closes the retained-corpus CPU-and-HDMA read census and the separately observed OAM-DMA source-page census for these exact physical extents. It does not establish that scenarios cover all natural inputs, prove global non-use or unreachable code, or resolve the names' intended pairing. The interval result is reproducible from `audit.py` (review artifact) (SHA-256 `3cb06b29aaf8348aa4097b95771b93d906b19faa7503dd50ae4c95d30bbdbe95`); its 72-file input manifest is `INPUTS.json` (SHA-256 `9787af1327fac8c517482e2c9c3b8bfe7e42628670df60e29d41dcd0f1b5bed7`), and `RESULT.json` has SHA-256 `89ccc2f5dda9abea625bfb9153c29db8d26592c0e5ebc75912108a55e8e4fc6c6`. The source-level DMA distinction and exact source revision are documented in [dynamic tracing](dynamic_tracing.md#7-limitations-and-things-that-can-mislead) and preserved under `jp-dma-source-census-20261024` (review artifact).

### Forced frame-selector replay omitted from the 72-scenario read corpus (2026-10-25)

The retained 72 `traces/detail/*/dataaccess.tsv` reports are the natural-scenario set; `forced_screens` is separately marked forced and was excluded from their union. To cover that distinct path, the existing recorded input `traces/inputs/forced_screens.txt` was replayed directly against the protected Japanese ROM with its retained `mail_inbox` SRAM/config parent. This run includes the harness-forced `4E:4000` frame-style chooser (`A=$03`) at frames 3494–4062, along with the other explicitly forced routines in that input. The replay executed 12,816 frames and recorded 1,113 ROM data-read ranges. None intersects the 25 candidate frame extents or `53:4000–4171`. Its OAM-DMA register log records 12,648 transfers, all sourced from page `$C0` (WRAM). The frame-selector screenshot at frame 3794 shows the blank green-bordered screen; later screenshots are blank after the forced routine returns. These observations bound this exact forced replay only: they do not establish natural entry, global non-use, or all name-to-frame links.

The run used ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, recorded input SHA-256 `ecf87b941cc76dc3518726ff93d43b0dce76411006530a8432afc213a70b5620`, tracer SHA-256 `bcfc16de9e07a8acb81b52e4f843ab0cf2beba6e26a1a134e25a3e6f714dc280`, tracer-source SHA-256 `23d57ccc25ba134332ba3c40f1e2bce3e2282b3b059a8eb14c3737eae0560fda`, and mGBA library SHA-256 `b44dfd7edb816fefa892c10dc2563d5d4bbe871d68702a8dcc3dde2532959719` (mGBA source revision `22506cf00823746fa15a9e2416717612d89cf37d`). The reproducible interval/OAM audit is `audit.py` (review artifact) (SHA-256 `8e0be0c4c60eb22187ffacb3247ed3367d7730a7773a5747637deb66f5c6d7d9`); the complete private outputs and screenshots are retained in that directory. `RESULT.json` SHA-256 is `e9cf1df5a9bb56bf0702d95e4853cf964b92f1940acfb915aae38469c41025f9`.

### Whole-ROM Bank 53 far-pointer-shaped byte scan (2026-10-24)

A new scan of every byte offset in the protected 2 MiB Japanese ROM checked both adjacent three-byte forms that could encode an address and physical bank: little-endian address then bank, and bank then little-endian address. It found 30 raw shapes pointing into `53:4000–4170`. Each was reconciled against the linked section, nearest symbol, and byte context. The matches are explained by adjacent 16-bit words in `Mail_HeaderStringTable` and `Html_TagPtrs`, graphic/font/text payload bytes, or ordinary instructions (including near-CALL operands and `LD D,E / LD E,B / LD B,C` sequences); none is an identified far-pointer record or consumer of the Bank 53 name block. A separate whole-ROM byte-pattern check found zero occurrences of `LD BC/DE/HL,imm16` adjacent to `LD A,$53`, the reverse ordering, or the inline `CALL FarCall; addr16; bank=$53` form when the target address lies in `53:4000–4170`.

This narrows the literal adjacent-field and immediate-code forms only. It does not cover separated/computed values, runtime RAM/SRAM descriptors, copied bytes, alternate instruction sequences, or mapper state. The scan therefore provides no global no-reader proof and does not resolve any Pokémon-name/frame association; those remain **HYPOTHESIS**. Reproduce with `audit.py` (review artifact) (SHA-256 `f1e62b976a0763590a81238117d98418f0fbe70e432e3e5ce535a9eacec9757f`). Its receipt `RESULT.json` (review artifact) (SHA-256 `aaf018476ded19571f0d2439367f9f926655e9da8b30803f7b29df401a0bb8e4`) pins the original ROM, linked map, and SYM; the 30 classified rows are in `HITS.json` (SHA-256 `5ae4ed045b65e775a189646d70f48754b607283b5c263b89ddaa999072c9041c`).

The broader Japanese source review remains separate from this finite frame inventory: the current name census has no strict address-only `Function_`, `Data_`, or `Font_` placeholders and all 16 finite coverage families reconcile (latest census checkpoint `e65b07ba`), while five named operation-entry candidates still lack proven natural roots. Those entry/purpose uncertainties do not imply that an unnamed generic function remains in the maintained source.

### Reconciliation of retained trace reads and previous pointer audit (2026-10-25)

A fresh read-only pass over the 75 tracked `traces/**/dataaccess.tsv` reports
reconciles the 72 natural `traces/detail/` reports and all three
`traces/forced/detail/` reports. Across 86,789 merged ROM/SRAM intervals
(85,013 `rom_read`, 843 `sram_read`, 933 `sram_write`), none of the 85,013 ROM
data-read ranges intersects physical Bank 53 `$4000–$4170`. The natural subset
is the previously documented 83,242 reads; the three forced reports add 1,771
reads, including the already reviewed `forced_screens` and the additional
`forced_debug` (352 reads) and `forced_dead` (306 reads). The additional two
reports contribute 658 ROM-read ranges. This is a re-census of existing
reports, not a new emulator run. It closes the exact tracked read-report
domain only; it does not establish that the scenarios cover every natural
input, nor does it prove that the table is globally unread or that any image
is unused. The audit pins the ROM hash and
each trace-file hash in `INPUTS.json` (review artifact)
(SHA-256 `d59ca4e7e5f120b133d06ffb1e8ac15869ad19a9bde5da3eca4a95d1e1cfbf81`).
Reproduction: `audit.py` (SHA-256
`76fdc027877337cc7480bd39596945af966b790b7fd273c382cd2e22adc116d4`);
receipt `RESULT.json` (SHA-256
`e86c6ad7816de5e7cb588900fd842624833ef74af1f7bffe6984c116aa4fe469`).

The raw little-endian pointer-word scan is not repeated here: the existing
review already classified all 420 occurrences against the current linked
section map and source bytes. In particular, exact 16-bit addresses alone
must be interpreted with the selected physical bank. See the [420-hit owner
reconciliation](japanese_semantic_roots_and_destinations_20261025.md#reconciliation-of-all-420-raw-word-coincidences-2026-10-25).

This extended corpus check finds no Bank-53-name read in the exact tracked
reports, but supplies no executable name-to-frame edge. The visual/index
crosswalk remains **PROBABLE**, while executable ordinal selection and global
use/non-use remain unresolved. A new positive selector/reader trace or source
edge is still required to promote those claims.

## Reproduction and validation

The original receipt `RESULT.json` (review artifact) (SHA-256 `4679a38fbfb7d8d651d9b0d1f56d432f839ba559d9cace1c0065e7a8bcd8184a`) and `audit.py` (SHA-256 `2fbd8d7a38085495ef29d2702b45fecec8958fcb2ff7cd246f957a72306126f5`) are a **historical snapshot** pinned to source baseline `25501d4b` / HEAD `8dd8d59d`. They assert 137 assets / 93,264 bytes and must not be presented as reproducing the later six-asset delta or current counts.

The current read-only replay is `audit.py` (review artifact) (SHA-256 `a2869b6fd9c944e381a59e740ca342166a5c51f93a60840be274b9f5a797a94d`) and `RESULT_FINAL.json` (review artifact) (SHA-256 `fc85d3360d726f915e39f3742d669cbcf6af72b97f7757ea6b08203c8c139e81`), pinned to Japanese source HEAD `244cf2ae`. It verifies the 25-window coverage, contiguous asset/zero-fill emission, Bank 53 pointer/string block, all 143 current asset payloads against the original, and the 77 scoped PNG references/CRCs. Run it from the canonical checkout with the recorded review command; a repeat only accepts a byte-identical existing receipt.

Current gates were run against the same Japanese source HEAD: `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check` passes 335 source files, 12,221 labels, and 51 constants; `make palette-check` reports 162 loads, 116 arrays, two documented over-reads, and zero errors. `make png-check` passes 424 tile sheets, four raw-byte views, 37 font sheets, and 95 screen PNGs; `gfx_export.py check` accepts 994 assets; `png_rules.py mk-check` passes 993 rules. `make test` passes the generator, SM83 (1,786 instructions), CFG (48 tests), PNG, palette-read (24 tests), and retype-parts (6 tests) suites. It emits the existing non-fatal `ResourceWarning` for the `baserom.gbc` reader at `tools/test_cfg.py:398`.

No ROM, Japanese source, image, or translation file changed in this audit. The English overlay and Operator ZIP remain paused pending the Operator's explicit approval.
