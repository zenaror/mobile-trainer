# Consolidated Japanese name and asset-path census follow-up

The two sources `Notice_HeaderGfxSourceDescriptor14_6590` and `Notice_HeaderGfxSourceDescriptor15_6810` are now dispositioned as descriptive owner-qualified assets; their 4B addresses and table indices are supported by `notice_header_gfx_sources_4b_6590_6810.md`, while natural selection remains unproved.

## Post-census batch completion

All ten spans keep their original `db` directives and byte ranges: eight are one byte, `2F:4094` is three bytes, and the keyboard `$06` run at `5F:6980` is 48 bytes.

`make` remains byte-identical; `sym-check`, `palette-check` and the current `data_consumers.py --stats` pass after the batch.

## Global symbols and uncertainty terms

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

`SoundDrv_CmdUnassigned` names a dispatch-table command that reaches the command-end path.

## Graphics owner/path census

| Previous owner/path | New owner/path |
| --- | --- |
| `gfx/help/help_screens_a.asm`, `gfx/help/help_screens_a/` (35 files) | `gfx/help/help_menu_bank6a.asm`, `gfx/help/help_menu_bank6a/` |
| `gfx/help/help_screens_b.asm`, `gfx/help/help_screens_b/` (12 files) | `gfx/help/help_script_bank6a.asm`, `gfx/help/help_script_bank6a/` |

Updated current path consumers include `layout.link`, `gfx/assets.tsv`, `gfx/png_rules.tsv`, `gfx/screens.tsv`, `gfx/png.mk`, `gfx/README.md`, the GFX path map, sprite format reference, and current screen/help path inventories.

The broader `gfx/mail/connect_screen_bank29` name remains because that owner includes an unresolved candidate palette; a narrower name would overstate the evidence.

The ten `Data_BB_AAAA` names remain explicitly unresolved pending positive evidence.
