# Japanese maintained-tree generic-name sweep (2026-10-23)

This document preserves both historical inventories and the current result; dated baselines below must not be read as the present source state. The ten generic data labels were replaced at source commit `519dc5c190337d8cce7f359f4d09e622b8c71083`; later source changes have not altered their dispositions. Reproduce the current census with `python3 tools/japanese_name_census.py`. Its output records Git HEAD and the number of modified tracked Japanese source/GFX paths, so a report can be matched to the snapshot actually scanned. Current totals: 349 non-protected tracked Japanese ASM/INC files (333 in the six maintained source roots plus RAM, constants and root support), zero strict address-only global definitions, zero `.loop`/`.skip`/`.done`/`.start` definitions, 2,356 retained `.lAAAA` labels, 786 numeric RAM equates, and 1,859 tracked GFX paths with zero `bankNN` components and zero strict address-only asset basenames. The script excludes `engine/mail/sample_data.asm` before reading it and does not inspect language overlays. These are lexical results, not semantic closure. English translation sources and the Operator ZIP remain paused and were not read.

### Linker-export cross-check at `be577515` (2026-10-23)

After rebuilding the Japanese ROM at `be577515e5e46ce115c24c6cd8d11866086084dd`, an independent token scan of the generated `build/mobile_trainer.sym` and `build/mobile_trainer.map` found zero strict address-shaped generic exports (the same family used by the source census, including `Function_BB_AAAA`, `Data_BB_AAAA`, and `Font_BB_AAAA`). `make sym-check` passed with 335 source files, 12,189 labels and 51 constants. This closes a possible gap between source definitions and linker exports for that exact lexical family; it does not assess descriptive aliases, unlabelled code, or semantic completeness. The build was `RESULT: IDENTICAL` to the Japanese reference, and `make palette-check` reported 162 loads, 116 arrays, two documented over-reads and zero errors. No assembly/source edit was made for this cross-check.

## Unified census and dispositions

### Broader typed-symbol candidate sweep at `856d341b` (2026-10-23)

To check for generic labels that do not match a bare `Type_BB_AAAA` spelling, a second pass scanned anchored global definitions in all 349 tracked Japanese ASM/INC files for the full `Function`/`Func`/`Sub`/`Routine`/`Unknown`/`Unk`/`Code`/`Font` type families, in addition to the data/resource families already covered above. It found no current function-like placeholders and no `Font_BB_AAAA` labels. The 27 `Font_GlyphRun_HHHH` labels are a deliberate role-plus-key form: each `HHHH` is the Shift-JIS start code stored in the glyph-run table, not a ROM address. At this revision, the 27 definitions, 27 table targets, and 27 `sjis_HHHH.1bpp` inputs have identical key sets; the inputs total 4,848 bytes and each run is a nonzero multiple of 16 bytes. They remain unchanged because both the role and lookup key are explicit and independently cross-referenced. The other font-prefixed definitions name rendering routines, tables, or the validity bitmap. This closes that broader typed-symbol candidate family for this revision; it does not establish complete semantic identification of every routine.

The scan also distinguishes uncertainty tokens from ordinary compound names: `Candidate` inside an established owner name such as `AddrScreenCandidate` is not by itself an uncertainty marker. Candidate flags require the token boundary and row-level evidence described in the ledgers; substring counts are not a defect count.

A complementary path-component scan covered all 2,197 tracked paths in the maintained `home/`, `engine/`, `data/`, `gfx/`, `audio/`, `lib/`, `ram/`, and `constants/` trees. It found no exact `bankNN` directory or `bankNN.asm`-style basename. Twelve source basenames contain a role/content descriptor followed by `_bankNN` (including `data/text/pokemon_names_bank53.asm`); ten of those have matching `gfx/<role>_bankNN/` resource directories. These 22 distinct components yield 215 tracked paths because each resource directory contains multiple assets. Their prefixes identify content/area (`pokemon_names`, `connect_dialog`, `registration_notice`, `type6_pages`, etc.); the bank suffix records physical ownership. No component in this set is named only `bankNN`. This path-name disposition does not prove the resource's selection, use, or semantic purpose.

**Historical baseline:** The following table records counts at `69b7f8c125faf56d4aee77fbed860b8bd4578ccd`. It is retained for provenance; use the current snapshot statement above and the batch-closure section below for present counts.

The previous passes did have broad coverage, but it was split between notes and did not put all naming families in one place. This section is the cross-category index; row-level decisions remain in the linked ledgers. Counts use tracked Japanese source files and exclude `languages/`, frozen analysis/configuration data, and the protected `engine/mail/sample_data.asm` payload. The source files are maintained by hand. The query families were anchored symbol definitions, path basenames, local definitions, RAM `EQU/SET/EQUS`, and explicitly qualified uncertainty markers; the counts below are flags/categories, not a claim that each lexical match is a defect.

| Family | Census at `69b7f8c` | Disposition / boundary |
|---|---:|---|
| Maintained ASM/INC scope | 349 files: 333 in six source roots, five RAM files, seven constants files, four root support sources | Complete tracked Japanese assembly/include set; protected sample-data source excluded from semantic review. |
| Global / local definitions | 6,650 global labels; 5,473 local labels; 1,931 `EQU`/`SET`/`EQUS` definitions | Lexical inventory totals from a repeatable scan across tracked ASM/INC sources; constants/equates are not presumed generic. |
| Address-only local labels | 2,764 `.lAAAA` definitions in 140 files at the review baseline after the Bank 29 palette rename (2,662 engine, 67 lib, 28 audio, seven home) | Every baseline anchor now has a row-level disposition: 408 were renamed after static review and independent review of all proposals (400 accepted, eight revised); 2,356 remain neutral with individual reasons. All are local control-flow anchors, not function entries. See the full [local-anchor disposition ledger](japanese_local_anchor_dispositions_20261023.tsv). |
| Short branch placeholders | 500 `.loop`/`.skip`/`.done` at baseline; zero remain | All 500 have row-level dispositions in [`japanese_short_label_full_decision_ledger_20261023.tsv`](japanese_short_label_full_decision_ledger_20261023.tsv); independent review checked all 401 later proposals and references. |
| Strict generic global names | 10 `Data_BB_AAAA` at the historical baseline; zero exact `Function`/`Func`/`Sub`/`Routine`/`Unknown`/`Unk`/`Code`/`Label`/`Font`/`Tiles`/`Tile`/`Tilemap`/`Attrmap`/`Palette`/`String`/`Table`/`SpriteFrame`/`SpriteScript` plus four-hex-address definitions | All ten were reviewed at that baseline and later received confidence-qualified structural names in the batch below; the current strict count is zero. |
| Broader address suffix flags | 127 globals with `_BB_AAAA` (10 neutral `Data`, 117 qualified names); 444 with `_AAAA` | Address provenance alone does not make a semantic symbol generic. Review strict name family and owner before treating as debt. |
| Numeric RAM equates | 786: 583 `wRam_`, 42 `hRam_`, 161 `sSram_` | Prior RAM ledgers and operand review were reconciled; keep neutral where evidence is insufficient. This is not 786 unresolved naming tasks. |
| Confidence-qualified markers | 261 combined: 243 `Candidate`, nine `Stub_Nop`, three `SpriteCounter_Stub`, and one each `Unknown`, `Unresolved`, `Placeholder`, `Generic`, `Unassigned`, `Maybe` | Explicitly qualified uncertainty is intentional evidence state, not a generic-name hit by itself; source owners/research notes document the known cohorts. |
| Globals ending in numeric ordinal | 2,412 | Broad lexical flag only; many are meaningful indexed resources, statuses, or protocol/table ordinals. Do not batch-rename without owner and consumer evidence. The `PokemonName00..24` symbols are table ordinals, not demonstrated frame identities. |
| Typed graphics-resource ordinals | 41 `*_Tiles0..6` definitions at the baseline across 11 owners; five `Tilemap_MailServerMgr_{Main,Footer,InfoB,InfoC,InfoD}` labels | The complete owner/consumer review renamed all 41 labels and matching asset pairs to statically proven VRAM/VBank destination names; the three reused spans explicitly name their multiple destinations. The five tilemaps already have descriptive owner/role names and remain unchanged. See the row-level follow-up. |
| GFX paths and basenames | 1,859 tracked GFX paths; 91 font source files; zero exact `gfx/bankNN` dirs; zero strict type+address or numeric-only asset basenames | Bank suffixes on descriptive consumer paths are provenance and not generic folders. A separately qualified candidate palette remains explicitly marked as a candidate. |
| Reviewed local short names | 117 unique names under 13 characters (204 definitions) among non-`.lAAAA` local labels | The exhaustive census found one vague exact `.start`; it was renamed to `.clear_config_mirror_and_start_mobile_init` in this follow-up. Other reviewed names describe operations, directions, registers, or loop roles. |

At census baseline `69b7f8c`, 41 typed tile labels were found in 11 owners; the current resolution is recorded in the [tile-resource follow-up](japanese_gfx_tile_ordinal_followup_20261023.md): all 41 labels and their 41 `.2bpp`/PNG pairs now identify proven VRAM/VBank destinations, including explicit names for three source blocks reused across destinations. Five already descriptive MailServerMgr tilemap labels also remain unchanged. No visual role or translation state is inferred from an ordinal suffix.

The `.start` block belongs to `Registration_DeleteExecute_StateTable` at `68:7C6B`. Its table target clears the SRAM mirror, calls `MobileAPI` with index `$02`, then advances the state to 1. The shared dispatcher indexes API pointers by byte offset, so `$02` selects `MobileAPI_Init` (see `home/mobile.asm` and `lib/mobile/main.asm`). The new label describes these static operations only; confidence is `PROBABLE`, and it does not claim deletion completion or adapter synchronization. Exact definition and reference changed together, preserving bytes.

## Complete disposition of address-only local anchors (2026-10-23)

The review baseline was `d8ec5d35fdef41f539790c936918f774fc26a82f`. A single path/bank/address/owner inventory covered all 2,764 `.lAAAA` definitions in 140 maintained Japanese source files, divided into disjoint read-only partitions of 922, 921, and 921 rows. Each row was checked against its owner, surrounding instructions, and references. The independent cross-check confirmed all 408 rename proposals against the current source and every listed reference: 400 were accepted, eight were revised for precise behavior, and none were rejected. The revisions describe a column decrement followed by storing C as the goal column, URL termination at a fragment marker or NUL, and `pop bc` returning the saved input HL value. All 408 final names are `PROBABLE` static local-operation names; none is claimed to be a function entry, naturally executed, or externally reachable.

The remaining 2,356 anchors keep their address names with an individual reason in the ledger. Those KEEP decisions mean this pass did not find a unique, sufficiently narrow operation name; they do not claim that stronger names are impossible. The automated reconciliation checked all 2,764 keys against the global inventory, source hashes, reference locations, and local-label scopes. It found no missing/duplicate rows or final name collisions. The source edit changed only the 408 local definitions and their in-scope code references in 95 files; comments and string literals were preserved. The complete ledger records each decision, owner, bank/address, evidence, reference lines, reviewer result, and source hash.

After the batch, `make` rebuilt a 2,097,152-byte ROM identical to the original (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `RESULT: IDENTICAL`), `make sym-check` passed (335 sources, 12,189 labels, 51 constants), and `make palette-check` passed (162 loads, 116 arrays, two documented over-reads, zero errors). This validates source symbols, palette reads, and byte identity; it does not establish natural execution or full semantic closure.

## Batch closure of the ten address-only data spellings (2026-10-23)

The complete ten-row candidate set from the prior census was reviewed together
with an independent verifier and then applied as token-only renames. The exact
old/new mapping, per-span bytes, evidence limits and review disposition are in
[`generic_data_name_audit_20261020.md`](generic_data_name_audit_20261020.md#consolidated-generic-name-recheck-and-batch-disposition-2026-10-23).
The current Japanese source now has zero definitions matching the strict
address-only global placeholder families, including `Data_BB_AAAA`; the ten
formerly matching spans retain descriptive, confidence-qualified structural
names. This does not establish entry, execution, data purpose, natural use, or
semantic closure. Source bytes and `db` declarations are unchanged.

This closes the lexical placeholder list as of the post-batch source revision.
Future sweeps must first diff the whole maintained-source/path census against
this baseline and the linked ledgers. Re-open one of these ten only if new
positive evidence appears; do not rediscover them from the same address regex.
The wider 2,356 neutral local anchors, 786 RAM equates, 2,412 numeric-ordinal
flags, resource names and four UNKNOWN natural-entry roots remain distinct
bounded workstreams.

### Reconciliation of a stale review copy (2026-10-23)

An independent review returned the ten old `Data_BB_AAAA` spellings as rename
candidates. Hashes for all ten containing source files in its private copy
match the parent of `519dc5c` (`575cb1452177744625374df2dd29c2d08c0db4e1`),
before the already-recorded rename batch. In the current checkout, none of
the ten old definitions exists; all ten have their reviewed structural names.
No source rename was applied from that stale report. Future private-copy
reviews must report their base commit or source-manifest hash, and proposals
must be reconciled against the current checkout before they enter an open
worklist.

### Repeatable audit boundary

Run `python3 tools/japanese_name_census.py` to reproduce the current strict lexical census across all 349 tracked Japanese ASM/INC files and GFX paths; add `--list` to print all matches, including the retained local/RAM inventories. It is read-only, reconciles all 2,764 reviewed local-anchor rows against the current source by path/address/owner/final label, and does not classify names semantically. Current result: 2,764/2,764 matches (408 RENAME, 2,356 KEEP).

Before opening a new generic-name pass, compare its candidates to this full tracked-tree census and existing decision ledgers. Re-run the same lexical families across all 349 ASM/INC files and the path inventory only when source state or scope changes; do not restart a directory-sized or per-pattern queue. Strict address-only names, broad ordinal suffixes, confidence-qualified uncertainty words, and resource ordinals are separate classes and must not be conflated. A newly discovered candidate must include owner, bank/address where applicable, all consumers/references, evidence level, and disposition before edits. The ten structurally named but evidence-limited data/opcode spans, 2,356 individually retained local anchors, 2,412 broad ordinal flags, and Bank 53 name-to-frame/natural-use questions remain bounded. All 41 tile ordinals were replaced with destination names; the three reused source spans name both proven destinations, and five descriptive tilemap labels remain owner-qualified. The lexical and row-level local-anchor reviews are complete for their stated scope; semantic interpretation remains bounded by the evidence recorded in the ledgers.

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

## Historical detailed definition and path census (pre-batch)

**Historical snapshot only.** The following inventory and the ten-name table immediately after it describe the pre-batch tree, not current definitions. The ten names were renamed in the closure recorded above; consult the linked old-to-new ledger for their current spellings. Keep this record as provenance, but do not use its past-tense rows as an open queue.

The scan used tracked `*.asm` files below `home/`, `engine/`, `data/`, `gfx/`, `audio/`, and `lib/` (334 total). It counted local `.lAAAA` definitions with bank/address comments and global labels with the exact bank/address suffix forms used by the project. One protected file, `engine/mail/sample_data.asm`, contributes 19 local labels and is excluded from the review tables and any sample-content discussion.

| Concern | Historical result | Disposition at that snapshot |
|---|---:|---|
| Address-only `.lAAAA` definitions in the 333 non-protected files | 2,764 | Re-derived after 252 earlier numeric-label renames and the ten reviewed Bank 29 local renames. The previous checkpoint count was 2,774; the 19 protected sample labels remain excluded. This count does not claim semantic understanding of all remaining labels. |
| Strict `Data_BB_AAAA` global definitions | 10 | Retained neutral after address, instruction-boundary, reference and ROM-byte review; each is listed below. |
| Strict address-form `Function`, `Func`, `Sub`, `Unknown`, `Code`, `Label`, `String`, `Font`, `Tiles`, `Tilemap`, `Attrmap`, `Palette`, and `Table` definitions | 0 | No current definitions in the maintained source roots. |
| Exact generic local placeholders `.loop`, `.skip`, `.done` | 0 current | The `883d10f` baseline had 500 across 122 files. The earlier 99-row pass and the complete 401-row, 119-file owner review now account for all 500. Every candidate was renamed to an operational local label; confidence is `PROBABLE` because the evidence is static. The full ledger records definition, owner, references, rationale and result. |
| Tracked paths under `gfx/` | 1,859 | No directory exactly named `bankNN`; no basename exactly matching a type prefix plus four-hex address (such as `tiles_XXXX` or `tilemap_XXXX`). |

The examples `Function_75_4000`, `Font_48_4ADB`, and `Data_68_6960` have zero definitions or references in the 334 maintained ASM files at this revision. Their remaining occurrences are in historical/frozen analysis artifacts and do not name current source symbols. The strict definition scan is intentionally source-root scoped; old naming maps and analysis records remain useful provenance and were not rewritten.

## Ten address-only data labels at the pre-batch snapshot (historical)

At the historical snapshot, these names were not established functions or resources. Each span is outside the demonstrated adjacent control-flow/data extent; the current evidence does not support promoting it to a more specific name. See [`generic_data_name_followup_20261023.md`](generic_data_name_followup_20261023.md) for the full byte/reference audit, alternatives rejected, and evidence limits.

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

At that pre-batch snapshot, these ten were the exact generic global names. They are no longer current definitions. A lack of a static lexical reference is not proof of non-use, and opcode appearance is not proof of a routine entry; computed access, external entry or new trace evidence could change a future disposition.

### Historical natural-trace cross-check of the ten pre-batch data spans (2026-10-23)

The ten intervals above were cross-checked against the current 69-scenario natural corpus using `analysis/coverage_union.tsv` for executed instruction starts and every `traces/detail/*/dataaccess.tsv` for ROM data-read ranges. No candidate byte was an executed instruction start in its physical bank, and no natural `rom_read` interval overlapped a candidate span. The 48-byte bank-5F interval was checked as `[6980,69B0)`; the bank-2F opcode-shaped span is three bytes; the other eight spans are one byte each (59 bytes total). Forced traces were excluded. This adds no semantic name and does not prove universal non-use, computed access outside the corpus, or that any byte is safe to classify as code.

| Label | Natural instruction-start hits | Natural ROM-read overlaps |
|---|---:|---:|
| `Data_72_63D7` | 0 | 0 |
| `Data_2F_4094` | 0 | 0 |
| `Data_72_6711` | 0 | 0 |
| `Data_24_4BCC` | 0 | 0 |
| `Data_4E_5390` | 0 | 0 |
| `Data_23_46CC` | 0 | 0 |
| `Data_1C_401C` | 0 | 0 |
| `Data_7F_4C77` | 0 | 0 |
| `Data_7F_51ED` | 0 | 0 |
| `Data_5F_6980` | 0 | 0 |

## Local-label coverage and next pass

The historical full reconciliation began with 3,325 `.lAAAA` labels and reviewed them in three disjoint partitions (2,024 + 1,157 + 144). The prior complete-owner checkpoint left 3,026 labels at revision `7134919c`; 252 numeric labels had reduced that count to 2,774 before the Bank 29 pass. The ten palette labels were located by joining every current `.lAAAA` definition to the historical owner ledgers on source path and bank/address; all 2,774 addresses matched, with ten owner changes and no unmatched rows. After those ten were renamed, the 2,764 remaining anchors received the complete row-level review linked above. The complete short-label inventory and final current names remain in the 500-row full decision ledger.

### Owner-boundary reconciliation: Bank 29 palette candidate

The four explicit globals at `29:5159`, `517D`, `51B3`, and `51D7` changed the assembler owner assigned to ten local labels in `engine/gfx/palette_library_candidate.asm`. Earlier ledgers retained those labels under the broader `PalLibCandidate_EnableVBlankIrq` owner, so a label-plus-owner join failed even though the byte locations were already inventoried. A complete path-plus-bank/address join reconciled every current local anchor to the historical ledgers and isolated exactly these ten owner-boundary changes. All ten now have PROBABLE loop-role names accepted by an independent reviewer; the exact mapping is [`japanese_palette_candidate_local_label_mapping_20261023.tsv`](japanese_palette_candidate_local_label_mapping_20261023.tsv). This explains the newly surfaced candidates and prevents treating the same addresses as fresh discoveries on the next sweep. It does not promote the remaining address anchors to function entries or claim their prior KEEP rationales were re-proven.

This pass changed the workflow from successive partial queues to one complete baseline inventory and owner-level disposition. The base matrix [`japanese_short_label_candidate_inventory_20261023.tsv`](japanese_short_label_candidate_inventory_20261023.tsv) contains all 500 definitions and references at `883d10f`. The 99-row checkpoint ledger covers the first three owners; the 401-row review covers the remaining 119 files. The consolidated [`japanese_short_label_full_decision_ledger_20261023.tsv`](japanese_short_label_full_decision_ledger_20261023.tsv) joins all 500 with the final name, confidence and static rationale. An independent reviewer read all 401 remaining entries against their source snapshots and found four semantic overclaims and two scope refinements; all six were corrected in the ledger before application. A separate exact-token reconstruction check confirms the resulting 122 files equal the baseline with only the 500 listed local-symbol substitutions. This closes the exact `.loop`/`.skip`/`.done` category, not every naming or semantic question in the ROM.

## Validation boundary

The historical 500-name batch built a byte-identical 2,097,152-byte ROM and passed symbol/palette checks. The latest 408-name local-anchor batch is recorded above with its own checks and the same reference ROM hash. These gates establish byte identity and source/symbol/palette consistency, not natural execution, hardware behavior, or full semantic closure.

## Verification for this checkpoint (2026-10-23)

After the source-comment, census-tool and research-note updates,
`make ROM=/tmp/mobile-trainer-final-20261023 BUILD=/tmp/mobile-trainer-final-build-20261023`
rebuilt 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and
`RESULT: IDENTICAL`. With the same overrides, `make sym-check` passed for 335
source files, 12,189 labels and 51 constants; `make palette-check` passed
162 loads across 116 arrays with zero errors. The default `build/` directory
was read-only in this checkout, so temporary ROM/object outputs were placed
in `/tmp` and removed after recording these results. The repeatable census
reported zero strict generic globals, 2,356 ledger-matched `.lAAAA` anchors,
zero short placeholders, 786 numeric RAM equates and zero generic GFX paths.
