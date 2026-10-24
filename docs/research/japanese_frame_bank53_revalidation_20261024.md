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
`.tmp/jp-bank53-pointer-pattern-census-20261024/audit.py` (SHA-256
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

A separate read-only decode enumerated all 128 masked selector indices. The 112 whose descriptor pointers lie in ROM yield 560 far fields; none names bank `$53`. Of the 85 out-of-range indices that still point to ROM, index 61 aliases descriptor `4E:65A0` and its bank-47 frame-1 resources. The other 16 indices point outside ROM into state-dependent regions: WRAM (`28,50,51,56,81,82,87`), VRAM (`41,54,70,72,103`), or SRAM (`62,73,76,79`). These are not established descriptors; their contents/accessibility are unknown and were not interpreted as frame records. FFD2 is also scratch for HTML images, URL lists, and blit masks, but no known executable path transports those uses into the preview input.

### Out-of-range selector fields versus candidate windows (2026-10-24)

A targeted decode checked the five far-pointer fields the frame loader would read for each out-of-range masked index `27..127`. The 85 indices whose selected descriptor address maps to ROM yield 425 readable fields; none points into any of the 24 candidate windows in physical banks `41..46`, and none points into the Bank 53 name block `53:4000–4170`. The other 16 indices select addresses outside ROM, so this pass does not interpret their state-dependent contents as descriptors. This closes only the candidate-window/name-block route through these out-of-range selector values when the selected descriptor bytes are in ROM. It does not show that an out-of-range style is or is not supplied naturally, and does not constrain another loader or computed reader.

Reproduction: `.tmp/jp-browser-oob-selector-frame-route-20261024/audit.py` (SHA-256 `d0de7c3650c309b1d5e8f68cbbdb64e1fea348dcb57b1526ca18405b7735c381`) and `RESULT.json` (SHA-256 `17c3233fad4d3d1783ecb4a090ab7bbaff8bd5d7e9770929d271762b8c2be1b6`). The script pins the original ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and hashes `engine/browser/frame_graphics.asm`; it maps CPU `$0000–$3FFF` to physical ROM0 and `$4000–$7FFF` to physical Bank `4E`.

The explicit producer graph therefore confirms no name-ordinal-to-frame chain and narrows ordinary natural paths, but it does **not** prove that the external preview input is unreachable, that RAM descriptors are globally unused, or that all 25 name-to-window links are absent. Keep all executable links **HYPOTHESIS** and all natural-selection/global-unused claims open until a producer or trace supplies the name ordinal and physical frame bank/address together.

## Remaining frame questions

Visual inspection identifies species-like artwork for 23 of the 25 names (PROBABLE visual identities); both Porygon entries remain unassigned. All 25 ordinal-to-window links remain HYPOTHESIS. Eight windows remain KEEP as editable compositions because their complete VRAM placement is not justified; their original bytes and backing assets exist. No frame is classified globally unused, and natural frame selection remains unknown. Do not assign the two geometric windows to Porygon/Porygon2 by elimination, synthesize unresolved VRAM keys, or treat a missing editable composition as a missing ROM asset.

### Current direct-symbol consumer matrix (2026-10-24)

A grouped scan of 349 maintained Japanese ASM/INC sources (including root constant/include files and `ram/`, excluding `engine/mail/sample_data.asm` before reading and excluding language overlays) checked the 26 Bank 53 name symbols and every labeled asset whose start falls inside the 25 candidate windows. It found zero external references to the name symbols and zero external references to the 104 candidate-window asset labels across the eight Bank 41–47 owner files. The 124 asset rows in those windows remain present in the manifest; this result means their editable source labels are not directly named by another maintained source file. It does not exclude raw byte pointers, computed/indexed addresses, generic descriptors in RAM/SRAM, copied data, or code/data readers with no symbol reference.

This aligns with the separately decoded ordinary browser frame selector: its declared styles select Bank 47 resources, while the bounded 0–127 selector projection has no fields pointing to the 25 candidate windows or Bank 53. Together, these checks establish no direct-symbol name-to-window chain in the maintained sources and no candidate-window selection through the modeled browser frame descriptor table. They do not prove global non-use or identify the 25 visual pairings. Receipt `.tmp/jp-frame-name-consumer-matrix-20261024/RESULT.json` SHA-256 `59fab2120f5a733536db513a826a25faf0002cc96262bd19a6616499cf91135f`; reproduction script `audit.py` SHA-256 `012819077f38ca219899b3a5f091fde72aa61c90eaaeed4d8c9ed00a9d5fbff0`. The receipt pins ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, `gfx/assets.tsv` SHA-256 `ab4e9d903187fc038213d17ae98923d7b99ec2be4949492ac0d4b2780a4991b5`, and source-manifest SHA-256 `c7f07027ac4fb5581e59140f38acd90c1188e383f6ecc32f2be4c607fd2af6e6`.

The broader Japanese source review remains separate from this finite frame inventory: the current name census has no strict address-only `Function_`, `Data_`, or `Font_` placeholders and all 16 finite coverage families reconcile (latest census checkpoint `e65b07ba`), while five named operation-entry candidates still lack proven natural roots. Those entry/purpose uncertainties do not imply that an unnamed generic function remains in the maintained source.

## Reproduction and validation

The original receipt `.tmp/jp-bank53-frame-reconcile-20261024/RESULT.json` (SHA-256 `4679a38fbfb7d8d651d9b0d1f56d432f839ba559d9cace1c0065e7a8bcd8184a`) and `audit.py` (SHA-256 `2fbd8d7a38085495ef29d2702b45fecec8958fcb2ff7cd246f957a72306126f5`) are a **historical snapshot** pinned to source baseline `25501d4b` / HEAD `8dd8d59d`. They assert 137 assets / 93,264 bytes and must not be presented as reproducing the later six-asset delta or current counts.

The current read-only replay is `.tmp/jp-bank53-current-window-reconcile-20261024/audit.py` (SHA-256 `a2869b6fd9c944e381a59e740ca342166a5c51f93a60840be274b9f5a797a94d`) and `.tmp/jp-bank53-current-window-reconcile-20261024/RESULT_FINAL.json` (SHA-256 `fc85d3360d726f915e39f3742d669cbcf6af72b97f7757ea6b08203c8c139e81`), pinned to Japanese source HEAD `244cf2ae`. It verifies the 25-window coverage, contiguous asset/zero-fill emission, Bank 53 pointer/string block, all 143 current asset payloads against the original, and the 77 scoped PNG references/CRCs. Run it from the canonical checkout with `python3 .tmp/jp-bank53-current-window-reconcile-20261024/audit.py`; a repeat only accepts a byte-identical existing receipt.

Current gates were run against the same Japanese source HEAD: `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check` passes 335 source files, 12,221 labels, and 51 constants; `make palette-check` reports 162 loads, 116 arrays, two documented over-reads, and zero errors. `make png-check` passes 424 tile sheets, four raw-byte views, 37 font sheets, and 95 screen PNGs; `gfx_export.py check` accepts 994 assets; `png_rules.py mk-check` passes 993 rules. `make test` passes the generator, SM83 (1,786 instructions), CFG (48 tests), PNG, palette-read (24 tests), and retype-parts (6 tests) suites. It emits the existing non-fatal `ResourceWarning` for the `baserom.gbc` reader at `tools/test_cfg.py:398`.

No ROM, Japanese source, image, or translation file changed in this audit. The English overlay and Operator ZIP remain paused pending the Operator's explicit approval.
