# Bank 53, Pokémon frame and PNG revalidation (2026-10-24)

This finite Japanese-only recheck was first recorded at documentation HEAD `8dd8d59d0246b2c5c7f2f042cca7c26c33b9ac96` against maintained-source baseline `25501d4b80a8370ab2b7482dd8388f99ca4df417`. The original `Mobile Trainer (Japan).gbc` is 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The counts below describe that original finite-audit snapshot; the current six-asset delta is reconciled explicitly below.

## Bank 53 name block

A read-only decode of the original bank at physical bank `53` confirms the range `53:4000-4171` contains 25 little-endian pointers and 25 NUL-terminated Japanese strings: 50 pointer bytes plus 319 string bytes, 369 bytes total. All pointers are strictly increasing and target the string interval `53:4032-4171`. The remainder of bank 53 through `53:8000` is zero. The rebuilt `mobile_trainer.gbc` has the same whole-ROM SHA-256 as the protected original.

These facts confirm the complete encoded name table and its byte placement. They do not establish a reader, natural selection, or association between any name ordinal and a frame image.

## Bank 41–47 assets and PNGs

At the original audit snapshot, `gfx/assets.tsv` had 137 rows across eight owner directories for physical banks `41–47`, totaling 93,264 bytes: 49 tile assets, 28 palettes, 28 tilemaps, 28 attribute maps, and four raw-byte views. Every file in that snapshot reconstructed the corresponding original-ROM slice. The audit interprets the catalog bank column as hexadecimal and uses file offset `bank * 0x4000 + address - 0x4000`; palette text is decoded with the project's `tools.gfx_export.palette_bytes` implementation.

At the original audit snapshot, the eight owner directories contained 71 PNGs: 53 source PNGs from the asset catalog and 18 screen compositions from `gfx/screens.tsv`. Their union matched the files present in scope, with zero missing or orphan PNGs. This is a bounded inventory; it does not claim every ROM graphic has been discovered or naturally displayed.

At that audit snapshot, `make png-check` accepted 418 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs; `python3 tools/gfx_export.py check` accepted 988 assets; `python3 tools/png_rules.py mk-check` accepted 987 rules. Those are historical snapshot counts; the current aggregate gates are recorded in `REVERSE_ENGINEERING.md`.

### Current Bank 41–47 delta (2026-10-24)

A row-level comparison of `gfx/assets.tsv` at the original baseline `25501d4b` and current source revision `b9a591ce` found exactly six added rows in physical Bank 42, with no removed or modified rows in the audited Bank 41–47 scope. Each row is a separate 16-byte `PROBABLE` tile candidate at `42:48A2`, `42:5E50`, `42:6132`, `42:6340`, `42:7092`, or `42:7190`. The six corresponding PNGs exist; together the source adds 96 bytes and six editable tile PNGs.

The current bounded totals are therefore 143 catalogued assets / 93,360 bytes (55 tile assets, 28 palettes, 28 tilemaps, 28 attribute maps, and four raw-byte views) and 77 PNG files across the same eight owner directories (59 asset-source PNGs plus 18 screen compositions). A direct manifest-to-files comparison found all 77 referenced PNGs present and zero orphan PNGs. The inherited byte/PNG checks for the original 137-row snapshot remain valid because none of those rows changed; current aggregate `png-check`, GFX catalog, and PNG-rule gate counts are stated in `REVERSE_ENGINEERING.md`. These six fragments complete candidate tile boundaries only; natural loading, consumption, and semantic ownership remain unconfirmed.

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

The explicit producer graph therefore confirms no name-ordinal-to-frame chain and narrows ordinary natural paths, but it does **not** prove that the external preview input is unreachable, that RAM descriptors are globally unused, or that all 25 name-to-window links are absent. Keep all executable links **HYPOTHESIS** and all natural-selection/global-unused claims open until a producer or trace supplies the name ordinal and physical frame bank/address together.

## Remaining frame questions

Visual inspection identifies species-like artwork for 23 of the 25 names (PROBABLE visual identities); both Porygon entries remain unassigned. All 25 ordinal-to-window links remain HYPOTHESIS. Eight windows remain KEEP as editable compositions because their complete VRAM placement is not justified; their original bytes and backing assets exist. No frame is classified globally unused, and natural frame selection remains unknown. Do not assign the two geometric windows to Porygon/Porygon2 by elimination, synthesize unresolved VRAM keys, or treat a missing editable composition as a missing ROM asset.

The broader Japanese source review remains separate from this finite frame inventory: the current name census has no strict address-only `Function_`, `Data_`, or `Font_` placeholders and all 15 finite coverage families reconcile, while five named operation-entry candidates still lack proven natural roots. Those entry/purpose uncertainties do not imply that an unnamed generic function remains in the maintained source.

## Reproduction and validation

The focused source-to-ROM and PNG inventory receipt is `.tmp/jp-bank53-frame-reconcile-20261024/RESULT.json` (SHA-256 `4679a38fbfb7d8d651d9b0d1f56d432f839ba559d9cace1c0065e7a8bcd8184a`); its read-only script is `.tmp/jp-bank53-frame-reconcile-20261024/audit.py` (SHA-256 `2fbd8d7a38085495ef29d2702b45fecec8958fcb2ff7cd246f957a72306126f5`). Run from the canonical checkout with `python3 .tmp/jp-bank53-frame-reconcile-20261024/audit.py`.

On this same HEAD, `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check` passes with 335 source files, 12,214 labels, and 51 constants; `make palette-check` reports 162 loads, 116 arrays, two documented over-reads, and zero errors; the Japanese name census passes all 15 families with zero open rows; the graphics catalog and PNG-rule checks pass. `make test` passes the generator, SM83, CFG (48 tests), PNG, palette-read (24 tests), and retype-parts (6 tests) suites. It emits the existing non-fatal `ResourceWarning` for the `baserom.gbc` reader at `tools/test_cfg.py:398`.

No ROM, Japanese source, image, or translation file changed in this audit. The English overlay and Operator ZIP remain paused pending the Operator's explicit approval.
