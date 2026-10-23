# Japanese maintained-tree generic-name sweep (2026-10-23)

This is the consolidated, current-tree reconciliation for the generic-name concerns raised by the Operator. It is a census of the maintained Japanese source roots, not a claim that every routine or data span is semantically understood. The reviewed checkout was `main` at `7134919c8d93c1061b2e9c15f46b2500ae14295e`; English translation sources and the Operator ZIP were not read.

## Complete definition and path census

The scan used tracked `*.asm` files below `home/`, `engine/`, `data/`, `gfx/`, `audio/`, and `lib/` (334 total). It counted local `.lAAAA` definitions with bank/address comments and global labels with the exact bank/address suffix forms used by the project. One protected file, `engine/mail/sample_data.asm`, contributes 19 local labels and is excluded from the review tables and any sample-content discussion.

| Concern | Current result | Disposition |
|---|---:|---|
| Address-only `.lAAAA` definitions in the 333 non-protected files | 2,774 | Re-derived after 252 numeric-label renames. The previous baseline was 3,026; the 19 protected sample labels remain excluded. This count does not claim semantic understanding of all remaining labels. |
| Strict `Data_BB_AAAA` global definitions | 10 | Retained neutral after address, instruction-boundary, reference and ROM-byte review; each is listed below. |
| Strict address-form `Function`, `Func`, `Sub`, `Unknown`, `Code`, `Label`, `String`, `Font`, `Tiles`, `Tilemap`, `Attrmap`, `Palette`, and `Table` definitions | 0 | No current definitions in the maintained source roots. |
| Exact generic local placeholders `.loop`, `.skip`, `.done` | 500 | Found across 122 source files after current owner renames and added to the owner-review queue; this is a candidate count, not 500 proven defects. The complete ignored inventory is retained under `.tmp/japanese-generic-census-20261023/`. |
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

The historical full reconciliation began with 3,325 `.lAAAA` labels and reviewed them in three disjoint partitions (2,024 + 1,157 + 144). The prior complete-owner checkpoint left 3,026 labels at revision `7134919c`; 252 numeric labels have since been renamed, leaving 2,774 in the current tree, excluding the protected 19. The old mapping plus the new owner TSV must be read together for address history; neither is a standalone current-name inventory.

To prevent incremental discoveries from appearing as untracked surprises, each pass starts from the current definition census, selects complete owners, reconciles every label in each owner against the owner ledger, and records a disposition before editing. The integrated owner decisions and change ledger are in [`japanese_generic_name_followup_20261023.md`](japanese_generic_name_followup_20261023.md) and its TSV. Both the connection-dialog and POP3 files are now reconciled end-to-end; two independent reviewers agreed on the connection-dialog inventory. The combined Japanese build/symbol/palette verification is recorded below after validation. The exact local-placeholder census (`.loop`, `.skip`, `.done`) contains 500 candidates and remains an owner-review queue before any global completion claim.

## Validation boundary

At the reviewed revision, `make` built a 2,097,152-byte ROM identical to the protected original (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`), `make sym-check` passed (335 source files, 12,185 labels, 51 constants), and `make palette-check` passed (162 loads, 116 arrays, 2 documented over-reads, 0 errors). These gates validate the current build/source relationships; they do not prove semantic closure or runtime/hardware behavior.
