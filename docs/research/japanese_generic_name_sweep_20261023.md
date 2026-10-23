# Japanese maintained-tree generic-name sweep (2026-10-23)

This is the consolidated, current-tree reconciliation for the generic-name concerns raised by the Operator. It is a census of the maintained Japanese source roots, not a claim that every routine or data span is semantically understood. Its full root/support-file census was independently reconciled at `69b7f8c125faf56d4aee77fbed860b8bd4578ccd`; subsequent Japanese-only follow-ups include the token-only `.start` rename recorded below and the complete typed tile-resource disposition linked here. English translation sources and the Operator ZIP were not read.

## Unified census and dispositions

The previous passes did have broad coverage, but it was split between notes and did not put all naming families in one place. This section is the cross-category index; row-level decisions remain in the linked ledgers. Counts use tracked Japanese source files and exclude `languages/`, frozen analysis/configuration data, and the protected `engine/mail/sample_data.asm` payload. The source files are maintained by hand. The query families were anchored symbol definitions, path basenames, local definitions, RAM `EQU/SET/EQUS`, and explicitly qualified uncertainty markers; the counts below are flags/categories, not a claim that each lexical match is a defect.

| Family | Census at `69b7f8c` | Disposition / boundary |
|---|---:|---|
| Maintained ASM/INC scope | 349 files: 333 in six source roots, five RAM files, seven constants files, four root support sources | Complete tracked Japanese assembly/include set; protected sample-data source excluded from semantic review. |
| Global / local definitions | 6,650 global labels; 5,473 local labels; 1,931 `EQU`/`SET`/`EQUS` definitions | Lexical inventory totals from a repeatable scan across tracked ASM/INC sources; constants/equates are not presumed generic. |
| Address-only local labels | 2,774 `.lAAAA` definitions in 140 files (2,672 engine, 67 lib, 28 audio, seven home) | Reconciled against earlier mapping/owner reports; a fresh instruction-operand scan of all 333 maintained six-root ASM files finds 0 direct `CALL .lAAAA` operands and 560 direct `JP .lAAAA` sites. These are internal address anchors, not 2,774 function entries. Computed dispatch is outside that lexical query. The individual KEEP partition ledgers are preserved under ignored `.tmp/` evidence, outside the independent snapshot used in this pass; their semantic decisions were not all re-executed here. |
| Short branch placeholders | 500 `.loop`/`.skip`/`.done` at baseline; zero remain | All 500 have row-level dispositions in [`japanese_short_label_full_decision_ledger_20261023.tsv`](japanese_short_label_full_decision_ledger_20261023.tsv); independent review checked all 401 later proposals and references. |
| Strict generic global names | 10 `Data_BB_AAAA`; zero exact `Function`/`Func`/`Sub`/`Routine`/`Unknown`/`Unk`/`Code`/`Label`/`Font`/`Tiles`/`Tile`/`Tilemap`/`Attrmap`/`Palette`/`String`/`Table`/`SpriteFrame`/`SpriteScript` plus four-hex-address definitions | All ten Data names were individually reviewed and remain neutral (list below); no strict Function/Font generic is currently defined. |
| Broader address suffix flags | 127 globals with `_BB_AAAA` (10 neutral `Data`, 117 qualified names); 444 with `_AAAA` | Address provenance alone does not make a semantic symbol generic. Review strict name family and owner before treating as debt. |
| Numeric RAM equates | 786: 583 `wRam_`, 42 `hRam_`, 161 `sSram_` | Prior RAM ledgers and operand review were reconciled; keep neutral where evidence is insufficient. This is not 786 unresolved naming tasks. |
| Confidence-qualified markers | 261 combined: 243 `Candidate`, nine `Stub_Nop`, three `SpriteCounter_Stub`, and one each `Unknown`, `Unresolved`, `Placeholder`, `Generic`, `Unassigned`, `Maybe` | Explicitly qualified uncertainty is intentional evidence state, not a generic-name hit by itself; source owners/research notes document the known cohorts. |
| Globals ending in numeric ordinal | 2,412 | Broad lexical flag only; many are meaningful indexed resources, statuses, or protocol/table ordinals. Do not batch-rename without owner and consumer evidence. The `PokemonName00..24` symbols are table ordinals, not demonstrated frame identities. |
| Typed graphics-resource ordinals | 41 `*_Tiles0..6` definitions at the baseline across 11 owners; five `Tilemap_MailServerMgr_{Main,Footer,InfoB,InfoC,InfoD}` labels | The complete owner/consumer review renamed all 41 labels and matching asset pairs to statically proven VRAM/VBank destination names; the three reused spans explicitly name their multiple destinations. The five tilemaps already have descriptive owner/role names and remain unchanged. See the row-level follow-up. |
| GFX paths and basenames | 1,859 tracked GFX paths; 91 font source files; zero exact `gfx/bankNN` dirs; zero strict type+address or numeric-only asset basenames | Bank suffixes on descriptive consumer paths are provenance and not generic folders. A separately qualified candidate palette remains explicitly marked as a candidate. |
| Reviewed local short names | 117 unique names under 13 characters (204 definitions) among non-`.lAAAA` local labels | The exhaustive census found one vague exact `.start`; it was renamed to `.clear_config_mirror_and_start_mobile_init` in this follow-up. Other reviewed names describe operations, directions, registers, or loop roles. |

At census baseline `69b7f8c`, 41 typed tile labels were found in 11 owners; the current resolution is recorded in the [tile-resource follow-up](japanese_gfx_tile_ordinal_followup_20261023.md): all 41 labels and their 41 `.2bpp`/PNG pairs now identify proven VRAM/VBank destinations, including explicit names for three source blocks reused across destinations. Five already descriptive MailServerMgr tilemap labels also remain unchanged. No visual role or translation state is inferred from an ordinal suffix.

The `.start` block belongs to `Registration_DeleteExecute_StateTable` at `68:7C6B`. Its table target clears the SRAM mirror, calls `MobileAPI` with index `$02`, then advances the state to 1. The shared dispatcher indexes API pointers by byte offset, so `$02` selects `MobileAPI_Init` (see `home/mobile.asm` and `lib/mobile/main.asm`). The new label describes these static operations only; confidence is `PROBABLE`, and it does not claim deletion completion or adapter synchronization. Exact definition and reference changed together, preserving bytes.

### Repeatable audit boundary

Before opening a new generic-name pass, compare its candidates to this full tracked-tree census and existing decision ledgers. Re-run the same definition families across all 349 files and the path inventory; do not restart from a single directory or only from `::` global labels. Strict address-only names, broad ordinal suffixes, confidence-qualified uncertainty words, and resource ordinals are separate classes and must not be conflated. A newly discovered candidate must include owner, bank/address where applicable, all consumers/references, evidence level, and disposition before edits. Current evidence-limited items remain the ten neutral data spans, residual `.lAAAA` labels lacking stronger semantics, the 2,412 broad ordinal flags not independently actionable as a group, and Bank 53 name-to-frame/natural-use questions. All 41 tile ordinals were replaced with destination names; the three reused source spans name both proven destinations, and five descriptive tilemap labels remain owner-qualified. The independent pass confirmed presence and reconciliation of the current renamed labels, but did not reperform the semantic review of every prior `.lAAAA` KEEP. See the row-level notes below; the scan is complete lexically, while semantic interpretation remains evidence-limited.

The lexical definitions behind the census are intentionally explicit. Apply them to symbol *definitions* after removing comments, then inspect all refs/consumers before classifying a hit:

```regex
generic_address_global = ^(?:Function|Func|Sub|Routine|Unknown|Unk|Code|Label|Font|Tiles?|Tilemap|Attrmap|Palette|String|Table|SpriteFrame|SpriteScript)_([0-9A-F]{2})_([0-9A-F]{4})$
neutral_data_global    = ^Data_([0-9A-F]{2})_([0-9A-F]{4})$
numeric_local_anchor   = ^\.l[0-9A-F]{4}$
neutral_ram_equate     = ^(?:wRam|hRam|sSram)_([0-9A-F]{4})$
short_local_review     = ^\.(?:loop|skip|done)$
typed_tile_ordinal     = _Tiles?_*[0-9]{1,3}$
```

Separate broad scans counted a global suffix `_[0-9A-F]{2}_[0-9A-F]{4}`, a suffix `_[0-9A-F]{4}`, decimal ordinals, explicitly qualified uncertainty words, and path basenames. These are candidate-generation patterns only: codepoint-shaped text suffixes, meaningful bank/address provenance, and indexed chunks remain valid when their owner/consumer semantics support them. `tools/render_screens.py` also contains an active name-specific asset filter; a symbol/path rename must audit that consumer and any generated manifests before application.

## Complete definition and path census

The scan used tracked `*.asm` files below `home/`, `engine/`, `data/`, `gfx/`, `audio/`, and `lib/` (334 total). It counted local `.lAAAA` definitions with bank/address comments and global labels with the exact bank/address suffix forms used by the project. One protected file, `engine/mail/sample_data.asm`, contributes 19 local labels and is excluded from the review tables and any sample-content discussion.

| Concern | Current result | Disposition |
|---|---:|---|
| Address-only `.lAAAA` definitions in the 333 non-protected files | 2,774 | Re-derived after 252 numeric-label renames. The previous baseline was 3,026; the 19 protected sample labels remain excluded. This count does not claim semantic understanding of all remaining labels. |
| Strict `Data_BB_AAAA` global definitions | 10 | Retained neutral after address, instruction-boundary, reference and ROM-byte review; each is listed below. |
| Strict address-form `Function`, `Func`, `Sub`, `Unknown`, `Code`, `Label`, `String`, `Font`, `Tiles`, `Tilemap`, `Attrmap`, `Palette`, and `Table` definitions | 0 | No current definitions in the maintained source roots. |
| Exact generic local placeholders `.loop`, `.skip`, `.done` | 0 current | The `883d10f` baseline had 500 across 122 files. The earlier 99-row pass and the complete 401-row, 119-file owner review now account for all 500. Every candidate was renamed to an operational local label; confidence is `PROBABLE` because the evidence is static. The full ledger records definition, owner, references, rationale and result. |
| Tracked paths under `gfx/` | 1,859 | No directory exactly named `bankNN`; no basename exactly matching a type prefix plus four-hex address (such as `tiles_XXXX` or `tilemap_XXXX`). |

The examples `Function_75_4000`, `Font_48_4ADB`, and `Data_68_6960` have zero definitions or references in the 334 maintained ASM files at this revision. Their remaining occurrences are in historical/frozen analysis artifacts and do not name current source symbols. The strict definition scan is intentionally source-root scoped; old naming maps and analysis records remain useful provenance and were not rewritten.

## The ten remaining neutral data labels

The names below are not known functions or resources. Each span is outside the demonstrated adjacent control-flow/data extent; the current evidence does not support promoting it to a more specific name. See [`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md) for the full byte/reference audit, alternatives rejected, and evidence limits.

| Label | Source | Bounded reason to retain neutral |
|---|---|---|
| `Data_2F_4094` | `engine/address_book/list.asm:94` | `C3 00 40` resembles a jump, but the prior path already jumps elsewhere and no entry at this byte is demonstrated. |
| `Data_23_46CC` | `engine/mail_server/delete_menu.asm:664` | `C9` follows a jump; the named routine starts at the next byte. |
| `Data_24_4BCC` | `engine/browser/page_list.asm:1574` | `C9` follows the final terminated message; the next named action starts at the next byte. |
| `Data_72_6711` | `engine/browser/menus.asm:406` | `AF` follows a return; the next named routine starts at the next byte. |
| `Data_4E_5390` | `engine/browser/page_render.asm:315` | `C1` is outside the paths shown by adjacent branches; no entry is demonstrated. |
| `Data_7F_4C77` | `engine/text/canvas.asm:2121` | The known copy interval ends before this `C9`; no other consumer is known. |
| `Data_7F_51ED` | `engine/unreferenced/page_list_prototype.asm:667` | `C9` is outside the preceding jump path; the next named entry starts at the next byte. |
| `Data_1C_401C` | `engine/main/main_program.asm:36` | `C9` follows a jump and is not addressed by the nearby pointer table. |
| `Data_72_63D7` | `data/text/dialog_messages.asm:620` | `AF` follows a text terminator; the known menu entry starts at the next byte. |
| `Data_5F_6980` | `gfx/keyboard/panels_bank5f.asm:469` | The 48-byte span of `$06` is outside the demonstrated tile/map copies. |

These ten are the only exact, currently defined generic global names in this census. A lack of a static lexical reference is not proof of non-use, and opcode appearance is not proof of a routine entry; computed access, external entry or new trace evidence could change a future disposition.

## Local-label coverage and next pass

The historical full reconciliation began with 3,325 `.lAAAA` labels and reviewed them in three disjoint partitions (2,024 + 1,157 + 144). The prior complete-owner checkpoint left 3,026 labels at revision `7134919c`; 252 numeric labels have since been renamed, leaving 2,774 in the current tree, excluding the protected 19. Short-label work does not change that count. The historical mapping tables preserve the `.lAAAA` address-label review. The complete short-label inventory and final current names are now listed together in the 500-row full decision ledger.

This pass changed the workflow from successive partial queues to one complete baseline inventory and owner-level disposition. The base matrix [`japanese_short_label_candidate_inventory_20261023.tsv`](japanese_short_label_candidate_inventory_20261023.tsv) contains all 500 definitions and references at `883d10f`. The 99-row checkpoint ledger covers the first three owners; the 401-row review covers the remaining 119 files. The consolidated [`japanese_short_label_full_decision_ledger_20261023.tsv`](japanese_short_label_full_decision_ledger_20261023.tsv) joins all 500 with the final name, confidence and static rationale. An independent reviewer read all 401 remaining entries against their source snapshots and found four semantic overclaims and two scope refinements; all six were corrected in the ledger before application. A separate exact-token reconstruction check confirms the resulting 122 files equal the baseline with only the 500 listed local-symbol substitutions. This closes the exact `.loop`/`.skip`/`.done` category, not every naming or semantic question in the ROM.

## Validation boundary

After the 500-name batch, `make` built a 2,097,152-byte ROM byte-identical to the protected original (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `RESULT: IDENTICAL`). `make sym-check` passed (335 source files, 12,185 labels, 51 constants), and `make palette-check` passed (162 loads, 116 arrays, 2 documented over-reads, 0 errors). These checks establish byte identity and source/symbol/palette consistency, not natural execution, hardware behavior, or full semantic closure.
