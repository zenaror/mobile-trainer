# Consolidated Japanese name and asset-path census follow-up (2026-10-23)

This follow-up corrects the coverage gap in earlier lexical-only scans. It is pinned to the pre-change source commit `28386b9dd7aa993e9990b5a386d8d2b25b64f09b`; the source changes in this checkpoint are limited to one local branch label and two graphics-owner path/name families. The paused English overlay and Operator ZIP were not read or changed.

## Scope and counts

A deterministic source census covered 333 maintained Japanese `.asm`/`.inc` files in `home/`, `engine/`, `data/`, `gfx/`, `audio/`, and `lib/`, excluding protected `engine/mail/sample_data.asm`. The ordered 333-path inventory digest is `c9b11f07c5cdc72db585e28fbf693ca614067705020c81d7a275c809df305bc9`. The scan selected tracked `.asm`/`.inc` files below those six roots, excluded `engine/mail/sample_data.asm` before reading, and distinguished global `::` definitions from owner-scoped dotted labels. It counted 6,649 global definitions and 5,473 local definitions (12,122 total). Of the locals, 3,872 use the exact address-only `.lAAAA` form across 162 files; all 3,872 have a same-owner control-flow reference. The other 1,601 are descriptive local names. Repeated local spellings across files are expected scope reuse, not collisions. This inventory is broader than the earlier `::`-only scan, which could not see dotted local labels.

The 3,872 `.lAAAA` labels are local control-flow anchors, not function definitions by themselves. Their existence does not prove that every target is a function, nor that every local name is semantically sufficient. An adversarial spot review found a directly supported semantic improvement: in `engine/browser/page_render.asm`, `Browser_DrawTitleBar` branches to `.l5225`, whose block sets `DE=wHtmlTitleBuf`, `BC=$0016`, calls `CopyBytes`, and rejoins the title-render path. The label is now `.copy_title_bytes_to_buffer`. This describes the observed operation without promoting it to a separate function or asserting natural reachability beyond the existing evidence. The remaining address locals stay on the explicit review backlog; the census is not a claim that every local branch could be improved safely in this pass.

## Global symbols and uncertainty terms

The census found zero definitions whose root label is an exact generic function/data/resource family of the searched address forms (`Function`, `Func`, `Sub`, `Unknown`, `Unk`, `Code`, `Label`, `Font`, `Tiles`, `Tilemap`, `Attrmap`, `Palette`, `String`, `Table`, `SpriteFrame`, or `SpriteScript` followed by bank/address). It found ten exact `Data_BB_AAAA` labels. An independent reviewer compared each corresponding source slice with the original Japanese ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`) and found no positive evidence for a more specific semantic name. These remain neutral rather than receiving names based on opcode resemblance or nearby control flow:

| Label | Source | Disposition |
|---|---|---|
| `Data_72_63D7` | `data/text/dialog_messages.asm:620` | `$AF` follows a text terminator; known menu entry starts at `$63D8`. |
| `Data_2F_4094` | `engine/address_book/list.asm:94` | `$C3,$00,$40` decodes as a jump, but no entry at `$4094` is established. |
| `Data_72_6711` | `engine/browser/menus.asm:406` | `$AF` follows a return; named routine starts at `$6712`. |
| `Data_24_4BCC` | `engine/browser/page_list.asm:1574` | `$C9` follows the terminated text; next named action begins at `$4BCD`. |
| `Data_4E_5390` | `engine/browser/page_render.asm:315` | `$C1` is skipped by the adjacent proven branches; entry is unknown. |
| `Data_23_46CC` | `engine/mail_server/delete_menu.asm:664` | `$C9` follows a jump; next routine starts at `$46CD`. |
| `Data_1C_401C` | `engine/main/main_program.asm:36` | `$C9` follows a jump; no pointer or entry is shown. |
| `Data_7F_4C77` | `engine/text/canvas.asm:2121` | `$C9` lies immediately after the bounded copy source; no reader is established. |
| `Data_7F_51ED` | `engine/unreferenced/page_list_prototype.asm:667` | `$C9` follows an unconditional jump; next named entry starts at `$51EE`. |
| `Data_5F_6980` | `gfx/keyboard/panels_bank5f.asm:469` | 48 bytes of `$06`; known T5 copies exclude this span. |

The wider exact-token scan separated 243 `Candidate` labels, one `Unknown`, one `Unresolved`, and one `Unassigned`. `Candidate` is not itself evidence of a bad name: the 243 split into 91 `FrameDesignCandidate` resources and 152 other candidate-qualified labels. `UnknownContent` and `Unresolved` explicitly preserve limits. `SoundDrv_CmdUnassigned` names a dispatch-table command that reaches the command-end path. A broad substring scan also matched `Chunk` in working names; these were false positives, not unknown code. A case-insensitive flexible scan of global suffixes found 444 `_AAAA` and 127 `_BB_AAAA` endings (including the ten Data labels), all in descriptive context. The broad marker census contains 261 names: the 245 Candidate/Unknown/Unresolved cases plus nine `Stub_Nop`, three `SpriteCounter_Stub`, one `Placeholder`, one `Generic`, one `Unassigned`, and one `Maybe`. `MobileSDK_EnterStateMaybeCloseTcp` really closes TCP conditionally; the qualifier is supported by its behavior. The placeholder and generic communication-error names describe their contents; stub/no-op names describe bounded behavior. No blanket rename of these qualified labels is justified by the token alone. The ten Data addresses also have zero exact literal `$AAAA` operands in the 333 scanned files; this negative result does not cover computed or interior access.

## Graphics owner/path census

The full GFX path/owner review found no remaining directory whose only identity is `bankNN`, no strict type/address-only physical asset stems, and no owner names consisting of arbitrary numbered partitions. Two arbitrary help-screen owner names were real defects and were corrected after independent path review:

| Previous owner/path | New owner/path | Static ownership evidence |
|---|---|---|
| `gfx/help/help_screens_a.asm`, `gfx/help/help_screens_a/` (35 files) | `gfx/help/help_menu_bank6a.asm`, `gfx/help/help_menu_bank6a/` | Owner contains HelpMenu page backgrounds, normal/selected item maps, tiles and palettes; `HelpMenu_ShowPage` loads it. |
| `gfx/help/help_screens_b.asm`, `gfx/help/help_screens_b/` (12 files) | `gfx/help/help_script_bank6a.asm`, `gfx/help/help_script_bank6a/` | Owner contains HelpScript background, tiles, palettes and object data; `HelpScript_Run` loads it. |

Updated current path consumers include `layout.link`, `gfx/assets.tsv`, `gfx/png_rules.tsv`, `gfx/screens.tsv`, `gfx/png.mk`, `gfx/README.md`, the GFX path map, sprite format reference, and current screen/help path inventories. Historical analysis snapshots and dated records retain the old spelling where it records the then-current source. The broader `gfx/mail/connect_screen_bank29` name remains because that owner includes an unresolved candidate palette; a narrower name would overstate the evidence.

## Validation and limits

After the changes, the Japanese build reports `SHA-256 OK` and `RESULT: IDENTICAL` against the protected 2 MiB original. `make sym-check` reports 335 source files, 12,185 labels and 51 constants, all matching the linked symbol/map files. `make palette-check` reports 162 loads, 116 arrays, two documented over-reads and zero errors. `make png-check` checks 408 tile sheets, four raw views, 37 font sheets and 95 screen PNGs successfully. `git diff --check` passes.

This is now one reconciled lexical inventory plus evidence review, not a declaration that all 12,122 labels or all ROM behavior are semantically understood. The remaining work is to prioritize address-only local labels by control-flow value and review their owning routines in batches, as well as the four open natural-entry roots and Bank 53/frame usage. The ten `Data_BB_AAAA` names remain explicitly unresolved pending positive evidence. Do not resume the English overlay or ZIP work without the Operator's explicit approval; the owner-path changes may require a future compatibility update there.
