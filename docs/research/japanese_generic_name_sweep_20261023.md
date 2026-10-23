# Japanese maintained-tree generic-name sweep (2026-10-23)

This document preserves historical inventories and the current result; dated baselines below are not the present source state. The ten generic data labels were replaced at source commit `519dc5c190337d8cce7f359f4d09e622b8c71083`; later source changes have not altered their dispositions. Reproduce the current census with `python3 tools/japanese_name_census.py`; use `--generic-list` to print all name/path candidates and numeric RAM equates without dumping retained local labels. The census checks both directions of the local-anchor ledger and reconciles each bank/address-suffix definition to a row-level disposition. Current totals: 349 non-protected tracked Japanese ASM/INC files (333 in the six maintained source roots plus RAM, constants and root support), zero strict address-only global definitions, 109 bank/address-suffixed global labels individually listed in [`japanese_bank_address_suffix_dispositions_20261023.tsv`](japanese_bank_address_suffix_dispositions_20261023.tsv), zero `.loop`/`.skip`/`.done`/`.start` definitions, 2,764 `.lAAAA` labels (411 RENAME and 2,353 KEEP across the ledger), 786 numeric RAM equates individually dispositioned in the row-level TSV, and 1,863 tracked GFX paths with zero exact `bankNN/` directories and zero strict address-only asset basenames. Across 2,194 tracked active source/resource paths, there are no exact `bankNN/` directory components; 30 ASM filenames and 28 owner-qualified GFX directories use `_bankNN` as source-bank provenance. The census excludes `engine/mail/sample_data.asm` before reading and does not scan language overlays. These are lexical and name-level dispositions, not proof of complete runtime semantics or natural reachability. The English translation remains paused and was not modified or tested in this pass.

### Consolidated `Candidate` token inventory at `f7421f5c` (2026-10-23)

The scanner now emits the full set of global definitions containing `Candidate` as its own inventory, including under `--generic-list`. At `f7421f5c`, it finds 255 labels across 349 Japanese ASM/INC files: 56 in `engine/`, one in `data/`, and 198 in `gfx/`. This is a lexical review queue, not a count of generic names: the token appears in owner names such as `AddrScreenCandidate_*`, explicit uncertainty labels for data/code, and the named `FrameDesignCandidate_*` asset family. Keep it separate from the strict address-only census and from the row-level 109-label bank/address suffix ledger. Existing evidence and confidence boundaries remain authoritative; do not rename by dropping `Candidate` unless the role or target is positively established. This addition closes the scanner visibility gap only; it does not claim a semantic disposition for all 255 labels.

### Bank-71 source-boundary correction after the consolidated census (2026-10-23)

The census inventory was complete for its lexical categories, but the former label `Settings_ReadData_UnknownContent_7271` remained unresolved because earlier evidence contained aggregate ROM-read intervals without an attributed consumer. A focused recheck of the existing evidence then reconciled all 1,281 bytes at `71:723F–7740` against `Notice_LoadHeaderGfx` and its 24-entry table at `65:4A81`. Descriptors `$16` and `$17` contain `40 72 71` and `C0 74 71`; the reader passes those sources to the HDMA helper with `C=$28`, `DE=$9301`, and bank `$71`. The helper selects VRAM bank 1 and transfers 40 blocks of 16 bytes. This fixes the true source intervals as `[71:7240,74C0)` and `[71:74C0,7740)`, each 640 bytes. Address `71:7271` is byte offset `$31` inside the first interval, not an asset boundary. The byte at `71:723F` is `$00`, outside both source intervals, and remains separately classified with no asserted role.

The two intervals are now separate exact 2bpp assets, named `Notice_HeaderGfxSourceDescriptor16_7240` and `Notice_HeaderGfxSourceDescriptor17_74C0`. The corresponding PNGs are produced by the repository exporter and round-trip exactly to their `.2bpp` inputs. Independent 2bpp rendering with the original map at `58:7B78` shows the Japanese header text `料金のご注意` in the first source and `初期登録再開` in the second; the interpretation of the visual arrangement is **PROBABLE**, while the descriptor bytes, transfer parameters, interval boundaries, and 2bpp encoding are **CONFIRMED** statically. Existing traces include matching reads in nine of 69 scenarios and execute the loader at `65:4A37`/`65:4A5B`; they do not provide per-read parameters or prove exclusive natural display. The old 50-byte candidate plus 1,231-byte unknown-data partition is superseded; ROM payload bytes are unchanged.

Re-running `python3 tools/japanese_name_census.py` at base `09cacfdf56ae6aaf792bd6483d61e7e80d167e85` with this source change reports 349 tracked Japanese ASM/INC files, zero strict address-only definitions, 110 bank/address-suffixed descriptive labels, zero short local placeholders, 786 numeric RAM equates, 32 RET-only bodies, 19 function-boundary clues, one remaining explicitly unresolved content label (`UnresolvedTiles_7F_7830`), no `bankNN/` path components, no address-only GFX asset basenames, and 2,764/2,764 local-anchor ledger matches. Thus this pass closes one evidence-limited content class; it does not claim that every routine or ROM behavior is semantically closed. Future passes should rerun the entire census and ledgers against one fixed checkout, then investigate only new candidates or changed evidence rather than repeating isolated token searches as separate backlogs.

### Consolidated independent review and census guard (2026-10-23)

The earlier searches surfaced new names in successive passes because they used narrower predicates for different families: strict address-only function/data names did not catch `Stub_Nop_*`, and the first marker pass did not include resource/text names such as `Placeholder`, `Generic`, or `Unassigned`. This is corrected as one current-tree review, rather than treating each pattern as a new work queue.

An independent read-only audit of the `5296c6f5` snapshot examined all 349 Japanese ASM/INC files: 6,661 global definitions, 5,473 local definitions, 1,934 `EQU`/`SET`/`EQUS` definitions, 51 macros, the tracked path manifest and the supplied ledgers. It found no `Function_`, `Func_`, `Sub_`, `Routine_`, `Unknown_`, `Unk_`, `Code_`, or `Label_` definitions; no type-plus-address-only name in either `_BB_AAAA` or `_AAAA` form; and no unreviewed marker in the scanner's explicit marker family. All 109 labels ending `_BB_AAAA` were checked individually. The detailed decisions are in [`japanese_bank_address_suffix_dispositions_20261023.tsv`](japanese_bank_address_suffix_dispositions_20261023.tsv): 101 descriptive operation/resource/structure names are retained with source or catalog evidence, and eight deliberately bounded names retain explicit candidate, byte-span, or unproven-entry limits. No additional rename was supported. The reviewer matched all 2,764 local-anchor rows and all 786 RAM rows in both directions; the local ledger contains 411 RENAME and 2,353 KEEP rows.

The census was strengthened to fail when a strict type/address-only global label, a reviewed short local placeholder, a bare `bankNN` path or address-only GFX basename appears; when a numeric `.lAAAA` definition lacks a ledger row; when any local ledger row is stale or duplicated; or when a bank/address-suffixed definition lacks a complete current path/line/label disposition. It accepts either RGBDS global-label delimiter and separately reports the broader 437 `_AAAA`/`_BB_AAAA` candidates, so meaningful address provenance is not mistaken for a defect. The scan remains lexical: zero generic patterns is not proof that every function entry, runtime path, or semantic role has been discovered. The 19 reconciled function-boundary comments point to named operations; they are not 19 proven, naturally reachable functions.

### First-pass disposition of the 109 current bank/address-suffixed labels

The historical 118-row review was made before eight context-qualified RET labels were renamed in the current Japanese pass. The live list now partitions all 109 remaining suffix-bearing definitions by owner: 28 in `engine/`, 79 in `gfx/`, one in `lib/mobile/main.asm`, and one in `zero_labels.asm`. The linked per-row ledger records each definition's path, line, bank/address, label, disposition, and evidence. An independent reviewer checked all 109 individually; no additional rename was supported. The list contains no exact type+bank+address-only definition; each name carries an operation, owner/resource, candidate, or structural-evidence qualifier beyond its address suffix.

| Owner group | Count | Evidence-based disposition |
|---|---:|---|
| `engine/` | 28 | The exact one-RET body formerly called `Stub_Nop_48_48BB` is now `ReturnImmediately` [CONFIRMED mechanical behavior] after review of its 13 far-call sites (10 natural, three forced debug); its wider historical hook purpose remains unknown. `ReturnOnly_68_5D2F` remains neutral because no caller or entry is established. The other 26 identify bounded operations, input handlers, HDMA helpers, strings/tables, or byte-match data; source comments distinguish CONFIRMED/PROBABLE/HYPOTHESIS and explicitly call out unproven entries. Eight earlier `Stub_Nop_*` renames remain in the structural RET-only ledger below. The 19 complete-operation/boundary clues were reconciled in this report. |
| `gfx/` with `gfx/assets.tsv` label | 55 of 79 | All 55 symbol names are represented in the asset catalog: 47 labels are CONFIRMED, seven PROBABLE, and one HYPOTHESIS. The catalog status applies to the documented resource/span, not automatically to visual purpose or natural use. |
| `gfx/` without `gfx/assets.tsv` label | 24 of 79 | Sixteen are structured sprite/object-table/frame/script data with typed macro layout. Six explicitly retain candidate status: `SpriteScriptCandidate`, `WramClearCandidate`, `CandidateMapData`, and three `MailServerMgr_Candidate*` spans. The remaining two are `ByteMatch_PageListProto_ObjTableFirstRow` and `ZeroByteSpan`, which state the observed relation/bytes without overclaiming use. Candidate/reachability limits remain HYPOTHESIS in their source notes and the sprite/data follow-ups. |
| `lib/mobile/main.asm` | 1 | `MaskedMatch_CrystalSDK_Local112D4C_75_6D62` names a CONFIRMED byte/instruction correspondence with the Crystal SDK source; whether this copied byte is a trainer entry or has a trainer-side role remains HYPOTHESIS. |
| `zero_labels.asm` | 1 | `FontReader_OutOfRunSource_48_69AB` records the PROBABLE relationship to the font reader's bounded source run; content identity/intent remains unknown. |

The first-pass review found no evidence-supported rename among the original 118 suffix-bearing labels. The structural RET-only re-scan and this follow-up now record nine call-site/mechanical-behavior renames, including `Stub_Nop_48_48BB` to `ReturnImmediately`; their changes are recorded below. The other labels identify an operation or owned resource, or deliberately preserve exact body, match, candidate, or unresolved status. This is a naming-level disposition, not proof that each operation is naturally reachable or every resource's product role is known. Evidence sources include the inline owner comments, `gfx/assets.tsv`, `docs/research/japanese_sprite_owner_audit_20261022.md`, `docs/research/japanese_sprite_data_followup_20261022.md`, `docs/research/original_closure_followup_20261021.md`, and the structural RET-only ledger below. The 786 numeric RAM equates have since been reviewed as one complete batch; see “Complete numeric RAM-equate batch” below. Names remain neutral where bank-dependent or reused meaning is not established.

### Reconciliation of the Operator's example symbols

### Complete numeric RAM-equate batch (2026-10-23)

The 786 neutral RAM equates emitted by `python3 tools/japanese_name_census.py --generic-list` were reviewed once by region, with independent read-only audits of SRAM, WRAM0/HRAM and banked WRAMX, then reconciled against source overlays and operand sites. This disposition replaces the earlier “separate open batch” wording. The inventories partition exactly: 161 SRAM + 144 WRAM0/HRAM + 481 banked WRAMX = 786.

| Region | Complete disposition | Source action |
|---|---|---|
| SRAM (161) | 88 have exact overlay aliases at the same base; 72 have no explicit operand and occur inside existing containers, where containment alone is not semantic evidence; one explicit AFFF operand is the final byte of `sNetWorkPage` while SRAM bank 3 is selected. | Changed the operand in `engine/mobile/pop3_retr.asm` from `[sSram_AFFF]` to `[sNetWorkPage + $0FFF]`. The global address equate stays neutral because the address is bank/context dependent. |
| WRAM0 + HRAM (144) | 104 already have scoped overlay aliases; 37 remain neutral after full-site review; three additional local alias candidates have producer/consumer evidence but overlap other scratch roles outside their exact function scope. | Added `wSmtp_SubjectTerminator` at C514 and `wMailDate_ZoneHoursBcd` / `wMailDate_ZoneMinutesBcd` at C591/C592 in `ram/overlays.asm`, all `[PROBABLE]` and explicitly scoped. Updated only the corresponding operands in SMTP and timezone handling. No global equate was promoted. |
| Banked WRAMX (481) | All global D000-DFFF equates remain neutral because meanings vary by selected bank/overlay. Only D525 currently has explicit operands; it is a duplicate index in one W1 record and overlaps unrelated scratch elsewhere. The other 480 have no explicit operands in this tracked Japanese source snapshot. Lack of a source operand is not proof of runtime non-use. | No renames. Preserve bank-qualified overlay aliases and address-only global anchors. |

The row-level decisions for all 786 symbols are preserved in [`japanese_ram_equate_dispositions_20261023.tsv`](japanese_ram_equate_dispositions_20261023.tsv). Regenerate and reconcile that exact ledger with `python3 tools/japanese_ram_equate_ledger.py --check`; compare its input inventory with `python3 tools/japanese_name_census.py --generic-list`. The ledger records each definition, current direct operand-reference count, scoped aliases, decision class, confidence, and concise rationale. The source edits change symbol references only; no ROM data or instructions were altered. The three local candidates are `[PROBABLE]`, not stronger claims, because their addresses have other overlay meanings.

Validation after all source changes: `make` passed SHA-256 verification and `RESULT: IDENTICAL` against the protected Japanese ROM (2,097,152 bytes; SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` passed (335 source files, 12,195 labels, 51 constants); `make palette-check` passed (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passed (408 tile sheets, four raw byte views, 37 font sheets, 95 screen PNGs); `python3 tools/japanese_ram_equate_ledger.py --check` reconciled 786/786 rows; the census reconciled 2,764/2,764 local-anchor rows; `git diff --check` passed. Three stale scope references discovered during the batch were corrected in `data/html/index.asm` and `ram/overlays.asm`. English sources, ZIP-derived material, and language overlays were untouched.

This is a closed lexical/evidence disposition for the 786 numeric equates, not a claim that all RAM contents or program behavior are understood. The next Japanese work is function/entry and resource closure from the current open-question follow-up; do not reopen the same 786 rows without new evidence or source changes.

### Structural RET-only re-scan and batch disposition (2026-10-23; HEAD `196f5ea7` plus this working change)

The earlier RET-only count was incomplete because the census selected labels by spelling (`Stub_Nop_*` and `ReturnOnly_*`) instead of examining source bodies. The scan now finds one-instruction `ret` bodies structurally across all tracked Japanese ASM/INC files, excludes the protected mail sample and `languages/`, and reconciles every match to a row-level ledger. Data directives before a `ret` disqualify a block, so a trailing RET byte after a table is not mislabeled as a function. `python3 tools/japanese_ret_only_ledger.py --check` reports the whole set; the ordinary name census imports the same scanner.

The complete current set is 32 rows: eight hardware RST vectors plus 24 owned source blocks. Nine `Stub_Nop_*` labels were renamed from verified call-site context and/or exact return mechanics: `PasswordChange_EntryReturnOnly`, `PageList_ActionMenuInputReturnOnly`, `PageList_ActionMenuPostInitReturnOnly`, `CommErr_DpadReturnOnly`, `MailSession_TimerDisplayReturnOnly`, `MailServerMgr_AfterBgMapUploadReturnOnly`, and the two `PageListProto_ActionMenu*ReturnOnly` names. The labels describe observed call sites and the exact RET body; they do not claim a wider original purpose. The retained row `ReturnOnly_68_5D2F` has no symbolic caller and unknown entry. `Mail_SelectorNop` remains because the selector-table owner and exact return behavior are explicit; no broader execution claim is made. All 32 row dispositions are in [`japanese_ret_only_dispositions_20261023.tsv`](japanese_ret_only_dispositions_20261023.tsv).

This re-scan corrects the earlier “ten RET-only labels” statement: that figure was a name-filter result, not a complete body census. Two apparent RET cases after `Table_MailBody_ApplyDakutenU_LoopPairs` and `Table_MailView_RecAddrs` are excluded because table data precedes the RET within the same source-label span. The Japanese edits are symbol-only. English source overlays and ZIP-derived translation work remain paused and untouched. For this exact tree, `make` returned `SHA-256 OK` and `RESULT: IDENTICAL`; `make sym-check`, `make palette-check`, `make png-check`, the 32-row RET ledger, the 786-row RAM ledger, the full name census, and `git diff --check` all passed.

The three examples previously called generic are absent as active definitions; their current address owners are explicitly identified: `75:4000` is `MobileSDK_CopyBytes` [CONFIRMED by the six-start copy loop, its caller mapping, and the `sdk_function_names` evidence row]; `68:6960` is `Config_DefaultImage2` [PROBABLE 192-byte default-config record, with field decoding still open]; and `48:4ADB` is `Font_GlyphRun_824F` [PROBABLE 10-glyph 8x16 1bpp run for Shift-JIS `$824F`, indexed through `Font_GlyphRunTable`]. Exact old spellings may remain in frozen `config/xrefs.tsv` and historical reports; they are not active symbol definitions. Source evidence: `lib/mobile/main.asm:7`, `data/account/default_config_images.asm:43`, and `data/fonts/font_8x16.asm:9`.

### Historical consolidated naming-census correction (2026-10-23; base `1831eb4e`)

At the `1831eb4e` snapshot, the user's review exposed a gap in that report: its `StubA`/`Maybe` filter did not include the spelling `Stub_Nop_BB_AAAA`. The lexical listing at that time reported ten RET-only labels. The later structural re-scan above supersedes that count and its dispositions for the eight context-qualified names; this historical section remains as provenance for the original review.

| Current label | Evidence for body / entry | Disposition |
|---|---|---|
| `Stub_Nop_68_4282` | Single `ret`; known caller (`PasswordChange_Run`). | Keep: exact no-op body; wider purpose unproved. |
| `Stub_Nop_24_53FC` | Single `ret`; only caller is a conditional call whose condition cannot be taken. | Keep; entry remains PROBABLE. |
| `Stub_Nop_24_53FD` | Single `ret`; called after `PageList_ActionMenuInit`. | Keep: exact no-op body. |
| `Stub_Nop_5C_5266` | Single `ret`; conditional caller in `CommErr_ShowScreen_Idle` executes. | Keep: exact no-op body. |
| `Stub_Nop_26_5343` | Single `ret`; called by `MailSession_UpdateTimerDisplay`. | Keep: exact no-op body; following code is bypassed. |
| `Stub_Nop_2E_4EB1` | Single `ret`; four calls from the tidy-screen path after background upload. | Keep: exact no-op body; broader timing intent unproved. |
| `Stub_Nop_48_48BB` | Historical decision: single `ret`; 13 far-call sites. | Superseded by the current follow-up below: renamed `ReturnImmediately` from the exact body; old hook purpose remains unproved. |
| `Stub_Nop_7F_61E6` | Single `ret`; prototype-page-list caller never executes in the corpus. | Keep; entry/reachability remains PROBABLE. |
| `Stub_Nop_7F_61E7` | Single `ret`; prototype-page-list caller never executes in the corpus. | Keep; entry/reachability remains PROBABLE. |
| `ReturnOnly_68_5D2F` | Single `ret`; no caller or natural entry established. | Keep; operation PROBABLE, purpose/reachability HYPOTHESIS. |

This list is exhaustive for current maintained definitions matching the exact RET-only naming family; it is not a claim that the wider role of every stub is identified.

The same current-tree pass rechecked all maintained source/resource paths, not only GFX assets. It found zero active definitions matching the strict generic families `Function_BB_AAAA`, `Data_BB_AAAA`, `Font_BB_AAAA`, and the equivalent typed prefixes. A broader suffix scan found 118 labels ending in `_<bank>_<address>`; each has additional text beyond the bare type/address form. This lexical fact does not certify each label's semantic quality. There are zero exact `bankNN/` directory components in active source/resource paths and zero address-only GFX asset basenames. The 29 `_bankNN.asm` source filenames and 27 owner-qualified bank-suffixed GFX directories retain descriptive owners and use the bank only as provenance. `Function_75_4000`, `Data_68_6960`, and `Font_48_4ADB` are absent from maintained Japanese definitions; their historical analysis/documentation occurrences are not active source symbols.

Historical snapshot: at the time of this earlier sweep, `Settings_ReadData_UnknownContent_7271` and `UnresolvedTiles_7F_7830` were explicit uncertainty labels. The latter was later replaced after the byte-identity review recorded below; do not treat this paragraph as current path/status.

Validation on the pre-correction source at `1831eb4e`: `make -j2 BUILD=/tmp/mt-generic-audit-build ROM=/tmp/mt-generic-audit.gbc` produced `SHA-256 OK` and `RESULT: IDENTICAL` against the Japanese ROM (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); matching overrides passed `make sym-check` (335 files, 12,195 labels, 51 constants) and `make palette-check` (162 loads, 116 arrays, 2 documented over-reads, 0 errors). The checkout's default `build/` was read-only under this execution sandbox, so generated outputs were placed in `/tmp`. After the tool edit, `python3 tools/japanese_name_census.py --generic-list` exited 0 and reconciled all 2,764 local-anchor ledger rows while listing the ten RET-only names, two unresolved labels, 19 boundary clues, active path counts, and the owner-qualified bank-tagged paths. These source-independent checks are not rerun after documentation-only edits.

### Linker-export cross-check at `be577515` (2026-10-23)

After rebuilding the Japanese ROM at `be577515e5e46ce115c24c6cd8d11866086084dd`, an independent token scan of the generated `build/mobile_trainer.sym` and `build/mobile_trainer.map` found zero strict address-shaped generic exports (the same family used by the source census, including `Function_BB_AAAA`, `Data_BB_AAAA`, and `Font_BB_AAAA`). `make sym-check` passed with 335 source files, 12,189 labels and 51 constants. This closes a possible gap between source definitions and linker exports for that exact lexical family; it does not assess descriptive aliases, unlabelled code, or semantic completeness. The build was `RESULT: IDENTICAL` to the Japanese reference, and `make palette-check` reported 162 loads, 116 arrays, two documented over-reads and zero errors. No assembly/source edit was made for this cross-check.

## Unified census and dispositions

### Consolidated function/name clue reconciliation (2026-10-23; base `28a44317`)

The earlier exact `Type_BB_AAAA` census could not see unlabelled complete operations, descriptive names with vague `StubA`/`Maybe` qualifiers, or comments that announce a complete function. I expanded `tools/japanese_name_census.py` to report those clues alongside the existing type/address, RAM, and GFX-path census. It now associates a comment immediately before a global label with that next label, lists each candidate with `--list`, and keeps Unknown/Unresolved data/resource labels in a separate bucket. This separates a reproducible candidate list from a claim that every candidate is a defect.

At this source pass, the full script scans 349 tracked Japanese ASM/INC files, excluding `engine/mail/sample_data.asm` before reading and excluding language overlays. Results: zero strict type/address global definitions, zero function-like labels with vague `StubA`/`Maybe` qualifiers, zero `gfx/bankNN` path components, and zero strict address-only GFX basenames. It reports two explicitly unresolved content labels—`Settings_ReadData_UnknownContent_7271` (a read-confirmed 1,231-byte span with unknown content) and `UnresolvedTiles_7F_7830` (720 bytes without a supported consumer). Those names expose the evidence gap; they are retained instead of guessing. `config/` and old research text are historical/frozen records and are not active source definitions.

The broad source-comment filter found 19 function/operation-boundary clues. Every one now points to a symbol-bearing, bounded operation or to an already labelled operation whose natural entry remains explicitly unproven. Four previously unlabelled complete operations received names from their static behavior:

| Bank/address range | Name | Supported operation | Remaining limit |
|---|---|---|---|
| `70:[4740,477F)` | `SaveCheck_GetStateBlockBit7` | Reads bit 7 of `sSaveCheckStateBlock + 5`, restores saved SRAM mapping state, and returns the bit as A=0/1. | Entry/caller unknown; SRAM shadow/register consistency remains a precondition. |
| `22:[50CF,50E6)` | `SramCheck_VerifyBank1_ClearOnMismatch` | Sums and compares the Bank1 page-list/address-book data; clears both regions on mismatch and restores AF/BC/DE/HL. | No caller/pointer; entry and reachability HYPOTHESIS. |
| `22:[50E6,50FC)` | `SramCheck_VerifyBank1_ReturnStatus` | Returns `$01` for a matching checksum and `$FF` for a mismatch; restores BC/DE/HL. | No caller/pointer; entry and reachability HYPOTHESIS. |
| `7F:[620C,6218)` | `TimerB_IsAtLeast30Minutes` | Reads `wTimerBMinutes`; returns `$00` below 30 and `$FF` at or above 30. | No caller/pointer; entry and reachability HYPOTHESIS. |

Three executed RET-only labels were renamed from `SpriteCounter_StubA/B/C` to `SpriteCounter_A/B/C_ReturnImmediately` at `23:58C4`, `23:5FA2`, and `23:6699`. The SDK label `MobileSDK_EnterStateMaybeCloseTcp` became `MobileSDK_StoreState_ConditionallyCloseTcp`, matching the observed conditional close and state store. All exact callers were updated. These names describe current code effects; none asserts why the code exists.

The new global boundaries also let the local-anchor ledger name three nearby operations (`70:4767`, `70:4769`, `22:50F6`) and update the owners/line numbers for six affected anchors. `python3 tools/japanese_name_census.py` now reports 2,764/2,764 local-anchor matches: 411 reviewed RENAME, 2,353 KEEP. Its `--list` output includes the 19 function-boundary comments and the separate unresolved-content labels for the next pass. The visible uncertainty is intentional: unknown content, callers, natural reachability, and broader purpose remain open where the evidence does not settle them. No English overlay or Operator ZIP was inspected.

Validation of this pass: `make` produced `RESULT: IDENTICAL` with the protected Japanese ROM hash `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passed with 335 source files, 12,195 labels, and 51 constants; `make palette-check` passed with 162 loads in 116 arrays, two documented over-reads, and zero errors. `python3 tools/japanese_name_census.py` reconciled all 2,764 local-anchor ledger rows. These checks establish reconstruction, symbol/anchor consistency, and palette-read consistency; they do not prove natural entry or use for the HYPOTHESIS operations.


### Broader typed-symbol candidate sweep at `856d341b` (2026-10-23)

To check for generic labels that do not match a bare `Type_BB_AAAA` spelling, a second pass scanned anchored global definitions in all 349 tracked Japanese ASM/INC files for the full `Function`/`Func`/`Sub`/`Routine`/`Unknown`/`Unk`/`Code`/`Font` type families, in addition to the data/resource families already covered above. It found no current function-like placeholders and no `Font_BB_AAAA` labels. The 27 `Font_GlyphRun_HHHH` labels are a deliberate role-plus-key form: each `HHHH` is the Shift-JIS start code stored in the glyph-run table, not a ROM address. At this revision, the 27 definitions, 27 table targets, and 27 `sjis_HHHH.1bpp` inputs have identical key sets; the inputs total 4,848 bytes and each run is a nonzero multiple of 16 bytes. They remain unchanged because both the role and lookup key are explicit and independently cross-referenced. The other font-prefixed definitions name rendering routines, tables, or the validity bitmap. This closes that broader typed-symbol candidate family for this revision; it does not establish complete semantic identification of every routine.

The scan also distinguishes uncertainty tokens from ordinary compound names: `Candidate` inside an established owner name such as `AddrScreenCandidate` is not by itself an uncertainty marker. Candidate flags require the token boundary and row-level evidence described in the ledgers; substring counts are not a defect count.

### Reconciliation of source comments marking complete small functions (2026-10-23)

To cover code that has no symbol for a generic-name census to find, an exact scan of maintained Japanese ASM/INC comments for `[HYPOTHESIS] complete small function` returned three candidates at this source snapshot. All three now have explicit dispositions; this is a finite comment-annotation cohort, not a claim that arbitrary unannotated bytes have been classified.

| Location | Current label / disposition | Evidence boundary |
|---|---|---|
| `lib/mobile/mail.asm`, `0F:4C59` | Added `Mail_AdvanceInputSramPage` | The nine bytes preserve BC around `Mail_NextSramPage` with BC pointing to `wMail_InputBank`. The helper advances D/E and increments/selects the pointed-to bank at D=`$BF`. Body effect is CONFIRMED; boundary PROBABLE; entry and reachability HYPOTHESIS because no caller/pointer is known. Independent read-only review verified the private byte/file hashes and accepted the operation name without promoting reachability. |
| `engine/unreferenced/page_list_prototype.asm`, `7F:61E8` | Added `PageListProto_SelectWramBank7AndClearTimerA` | The body selects WRAM bank 7, clears `wTimerAFrames`, `wTimerASeconds`, `wTimerAMinutes`, and `wTimerAExtra`, then returns. Body effect is CONFIRMED; ret-delimited boundary PROBABLE; entry and reachability HYPOTHESIS because no caller/pointer is known. |
| `engine/browser/status_sprites.asm`, `4E:6087` | Existing `ConnIcon_GetBrowserFramePos` retained | The body reads the descriptor word at offset `$19` using the same table lookup as the inline code in `ConnIcon_StartSprite`. The operation is PROBABLE; standalone entry/reachability remains HYPOTHESIS. The existing label is descriptive, not generic. |

No ROM bytes or operands changed. A full Japanese rebuild with `ROM=/tmp/mobile-trainer-function-audit-20261023/mobile_trainer.gbc` and `BUILD=/tmp/mobile-trainer-function-audit-20261023/build` reported `RESULT: IDENTICAL` and SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passed with 335 source files, 12,191 labels, and 51 constants; `make palette-check` passed 162 loads in 116 arrays with two documented over-reads and zero errors. These checks validate reconstruction and label addresses, not natural entry or execution of the two hypotheses.

### Complete `Mail_NextSramPage` caller-shape inventory

Following the new `0F:4C59` label, every `call Mail_NextSramPage` in `lib/mobile/mail.asm` was enumerated at the same source snapshot: 22 call sites total. Twenty-one are ret-delimited wrappers with `push bc; ld bc,<bank-variable>; call; pop bc; ret` shape (11 pass `wMail_InputBank`, 10 pass `wMail_OutputBank`); the 22nd is an inline loop continuation in `Mail_StripCommentsAndSpaces` (`pop bc; jr Mail_StripCommentsAndSpaces`), not a separate wrapper. The complete wrapper set is:

| Bank variable | Address and global label |
|---|---|
| Input | `4337 Mail_ScanHeaders_NextPage`; `44CC Mail_FindHeader_NextPage`; `469F Mail_MatchBoundary_NextPage`; `483E Mail_FindBoundary_NextPage`; `4A75 Mail_SkipHeaderBlock_NextPage`; `4ACA Mail_FindMessageEnd_NextPage`; `4B50 Mail_FindKeywordValue_NextPage`; `4C59 Mail_AdvanceInputSramPage`; `52B3 Mail_CopyItemToBuffer_NextPage`; `5C52 Mail_CopyBase64StripLineBreaks_NextPage`; `5D76 Mail_CopyFromSram_NextPage` |
| Output | `48BD Mail_PartRec_EmitHeaderBlock_NextPage`; `4948 Mail_PartRec_EmitLengthAndPart_NextPage`; `49C7 Mail_PartRec_EmitPart_NextPage`; `4A13 Mail_PartRec_EmitLength_NextPage`; `4EE4 Mail_EmitCrLf_NextPage`; `505D Mail_EmitString_NextPage`; `5174 Mail_EmitBufferToOutput_NextPage`; `5212 Mail_EmitGameCodeValue_NextPage`; `528A Mail_EmitStringAndSuffix_NextPage`; `5D8C Mail_CopyToSram_NextPage` |

This closes the helper-call-shape inventory for this owner, not the natural reachability of each wrapper. The inline call remains within its labeled loop and did not need a new function label.

### Anchored semantic type-prefix census

A further anchored scan of global definitions across the same 349 Japanese ASM/INC files checked complete `Type_...` families, not only the strict `Type_BB_AAAA` spellings. Counts below are candidate-generation buckets, not defects; a second filter checked for an otherwise bare `$AAAA`, `$BB_AAAA`, or uncertainty-only tail. No such exact generic-tail candidate was found. The function-like families `Function_`, `Func_`, `Sub_`, `Routine_`, `Unknown_`, `Unk_`, `Code_`, and `Label_` each have zero current definitions.

| Prefix | Definitions |
|---|---:|
| `Data_` | 131 |
| `Font_` | 42 |
| `Tilemap_` | 130 |
| `Attrmap_` | 15 |
| `Palette_` | 138 |
| `String_` | 294 |
| `Table_` | 170 |
| `SpriteFrame_` | 267 |
| `SpriteScript_` | 141 |
| `Stub_` | 9 |

The nine `Stub_Nop_BB_AAAA` names are a deliberate exception to bare-address matching, not unresolved function names: every body is one `$C9` (`ret`), and the names describe that no-state-change stub behavior. Six entries have CONFIRMED callers/execution and three remain PROBABLE due to unexecuted or unreferenced prototype context. The complete row-level rationale and independent review are in [`naming2_fn4.md`](naming2_fn4.md) and [`naming2_verify_fn4.md`](naming2_verify_fn4.md#3-stub-rows-1-9-is-stub_nop_bank_addr-honest). This result does not imply every arbitrary symbol name is semantically complete; it closes these anchored prefix forms and their exact address-only tail candidates for this snapshot.

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
At that earlier checkpoint, the remaining workstreams were listed as 2,356
neutral local anchors, 786 RAM equates, 2,412 numeric-ordinal flags, resource
names, and four UNKNOWN natural-entry roots. The current source has 2,353 KEEP
local anchors, and the 786-equate batch is now closed in the row-level ledger
above. Resource and natural-entry questions remain separate; the ordinal flag
count is a historical broad scan, not a current defect count.

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

Run `python3 tools/japanese_name_census.py` to reproduce the current lexical census across all 349 tracked Japanese ASM/INC files and GFX paths; add `--list` or `--generic-list` to print candidate inventories. It is read-only, reconciles all 2,764 local-anchor ledger rows in both directions by path/address/owner/final label, checks duplicates, and reconciles all 109 suffix rows by path/line/label. Current local result: 2,764/2,764 matches (411 RENAME, 2,353 KEEP); current suffix result: 109/109 matches. The census reports candidates; it does not establish semantic correctness by itself.

Before opening a new generic-name pass, compare candidates to this tracked-tree census and its decision ledgers. Re-run the lexical families across all 349 ASM/INC files and the path inventory only when source state or scope changes; do not restart a directory-sized or per-pattern queue. Strict address-only names, broad ordinal suffixes, confidence-qualified uncertainty words, and resource ordinals are separate classes and must not be conflated. A newly discovered candidate must include owner, bank/address where applicable, all consumers/references, evidence level, and disposition before edits. The ten structurally named but evidence-limited data/opcode spans, 2,353 individually retained local anchors, 2,412 broad ordinal flags, and Bank 53 name-to-frame/natural-use questions remain bounded. All 41 tile ordinals were replaced with destination names; the three reused source spans name both proven destinations, and five descriptive tilemap labels remain owner-qualified. The lexical, suffix-row, and local-anchor reviews are complete for their stated scope; semantic interpretation remains bounded by the evidence recorded in the ledgers.

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


### Whole-tree cross-family reconciliation (2026-10-23)

The earlier census correctly covered active symbol definitions, asset basenames,
resource directories, local anchors, and neutral RAM equates, but it did not
include address-only label spellings embedded in the maintained RAM evidence
comments. A cross-family text pass found 13 stale `Label_BB_AAAA` mentions
across `ram/banked.asm`, `ram/overlays.asm`, and `ram/wram.asm`, plus 14
legacy `Data_BB_AAAA` mentions (three for the POP3 descriptor, eleven in
historical region-boundary prose). All 27 were reconciled in one batch: stale code aliases now use current operation labels, the POP3 descriptor uses `Data_Pop3Retr_ParseBodyArgs`, and removed data-boundary names are rendered as explicit bank:address locations;
the keyboard reference is explicitly scoped to `Kbd_Run`'s local
`.handle_select` at `55:5E02`. No ROM bytes, symbol definitions, or reference
semantics changed. Frozen `config/` snapshots and dated research ledgers remain
historical evidence and are not edited to erase their original names.

The current Japanese source/resource scan also confirms zero exact `gfx/bankNN/`
directories and zero strict address-only asset basenames. The `_bankNN` suffix
in owner-named asset paths is source-bank provenance, not a generic directory
name. `candidate`, `prototype`, `unresolved`, and `unreferenced` paths are kept
only where the source's confidence/evidence says the purpose or entry remains
uncertain; they are qualified uncertainty labels rather than anonymous bank
containers. The `gfx/bank41..46` rows in `analysis/layout/README.md` describe
the superseded pre-tree layout plan, not current paths.


### 7F:7830 content identity update (2026-10-23)

A complete-byte comparison against the protected original ROM and both existing
MailAddr source assets established that `7F:7830–7B00` (720 bytes) is exactly
identical to the concatenation of `2D:7880–7940` (192 bytes) and
`2D:7940–7B50` (528 bytes). The formerly unresolved label/path are now
`Gfx_MailAddr_ObjHDMABytesCopy_7F_7830` and
`gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`; asset identity is CONFIRMED.
This says nothing about copy direction or whether the 7F copy is loaded. No
symbolic load was found in the maintained Japanese source and no read of the
physical interval was found in the reviewed trace corpus; computed/dynamic
access outside that reviewed evidence remains possible. The prior `Unresolved`
content label count is therefore retired; the remaining question is use of this
known byte duplicate. `Gfx_MailAddr_ObjHDMALoadTail` at `2D:7940` is also
CONFIRMED as the bounded tail of the 720-byte upload:
`MailAddr_SetupScreen` starts at `2D:7880` with 45 blocks of 16 bytes. Its
source comment and region header already had this status; the asset catalogue
was corrected from PROBABLE to CONFIRMED. No payload bytes changed.


### Current census after 7F path reconciliation (2026-10-23)

The latest staged-tree run of `python3 tools/japanese_name_census.py` reconciles 349 tracked Japanese ASM/INC inputs, 2,764 local-anchor rows, 786 numeric RAM equates and the reviewed address-suffix families. It reports zero strict address-only global definitions, zero active `Unknown`/`Unresolved` content labels, zero address-only GFX basenames, and zero generic bare `gfx/bankNN/` directory components. There are 28 *owner-qualified* resource directories with bank suffixes and 30 owner-qualified `*_bankNN.asm` source files; these are descriptive names, not generic `bankNN` placeholders. The 7F:7830 resource is now owned by `gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`; exact bytes match the 2D:7880–7B50 sequence, but its consumer/use remains unknown.


### Follow-up: broader Stub/Nop name census and RET-only correction (2026-10-23)

The earlier `StubA`/`Maybe` filter did not recognize the exact spelling `Stub_Nop_48_48BB`. A complete function-marker pass found this label and `Mail_SelectorNop`; the broader all-label pass also found `BrowserMenu_PlaceholderText`, `CommErr_Msg_GenericCommError`, and the former `SoundDrv_CmdUnassigned`. The source label is now `SoundDrv_CmdJumpToEnd`, describing its exact one-instruction `JP SoundDrv_CmdEnd` body; the interpretation that its table slots are unassigned remains PROBABLE. The three remaining marker names have explicit evidence-based dispositions in `tools/japanese_name_census.py`: literal placeholder text, a generic communication-error message, and the mail selector's exact RET leaf. The former `Stub_Nop_48_48BB` is now `ReturnImmediately` because its one-instruction body is exactly `ret`; 13 far-call sites exist, with ten natural and three forced-debug callers in the reviewed corpus. This names only the confirmed mechanical effect; the historical reason for the shared hook remains unknown. The census prints every marker disposition and fails if a new unreviewed marker label appears. Current suffix-bearing labels decrease from 110 to 109; label count and instruction bytes are unchanged.
