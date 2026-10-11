# Neutral labels referenced by instructions: bounded naming pass (ROM unchanged)

> Status: **reference (current)**. Eighteen new semantic names and three uses of existing aliases were independently reviewed. The original ROM bytes remain the gate.

## Scope and corrected census

At base `23c3e8f`, a reproducible strict source census finds **64 neutral names in 176 instruction operands**, replacing the stale historical claim of 40 names referenced by code. One additional name/reference belongs to `sprite_object_entry`, which emits words and is counted separately. This is not the complete data-pointer census: the independent scan also finds 159 neutral names in 238 `dw`, `db` or sprite-entry references.

The scan reads hand-maintained `.asm` files, excludes `.git`, `build` and frozen `config`, ignores label definitions/directives/comments, matches whole `Kind_BB_AAAA` tokens, and classifies the leading opcode or known macro. Both researchers reproduced the instruction census; all 177 instruction/cohort-macro encoded operands and target label bank/address pairs were checked against the immutable original ROM. Selected-bank and consumer proofs for the applied proposals and per-site alias substitutions were reviewed independently; unresolved consumer proofs remain in the worklist. The historical 739/199/40 census had a different scope and is preserved as history, not a current counting rule.

`analysis/naming2/neutral_code_worklist.tsv` records the initial 65-name cohort, its original instruction counts, applied/partial/keep/pending decisions and remaining evidence gaps. Its status column records the naming research decision; it does not downgrade existing source classifications. The worklist is not a list of all unreferenced data labels.

## Applied names

| Existing neutral name | Semantic name | Evidence level |
|---|---|---|
| String_2A_4A6F | String_SaveSenderAddr_CaptionPart2 | CONFIRMED |
| String_2A_4A78 | String_SaveSenderAddr_CaptionPart3 | CONFIRMED |
| String_2A_4A81 | String_SaveSenderAddr_CaptionPart4 | CONFIRMED |
| String_2A_4A8A | String_SaveSenderAddr_CaptionPart5 | CONFIRMED |
| Data_3F_4000 | Table_HtmlStore_KeywordPointers | CONFIRMED |
| Data_51_740C | ImageBlit_AllBitsMask | PROBABLE |
| String_56_4047 | String_ConnectDialog_PasswordEntryPrompt | CONFIRMED |
| String_56_406A | String_ConnectDialog_SavePasswordConfirm | CONFIRMED |
| String_56_40BF | String_ConnectDialog_PasswordSavedNotice | CONFIRMED |
| String_56_410A | String_ConnectDialog_StoredPasswordNotice | CONFIRMED |
| String_56_4159 | String_ConnectDialog_CancelPasswordStorageConfirm | CONFIRMED |
| Data_55_65D7 | Table_Kbd_InputModeReturnCodes | CONFIRMED |
| String_22_483C | String_MailSrvDelHidden_DeleteAllWarningPart2 | CONFIRMED |
| String_22_485D | String_MailSrvDelHidden_DeleteAllWarningPart3 | CONFIRMED |
| String_22_487E | String_MailSrvDelHidden_DeleteAllWarningPart4 | CONFIRMED |
| String_23_472B | String_MailSrvDel_DeleteAllWarningPart2 | CONFIRMED |
| String_23_474C | String_MailSrvDel_DeleteAllWarningPart3 | CONFIRMED |
| String_23_476D | String_MailSrvDel_DeleteAllWarningPart4 | CONFIRMED |

All 18 old names remain as aliases. The manifest changes 37 instruction operands: 17 new names are CONFIRMED and `ImageBlit_AllBitsMask` is PROBABLE because neither of its two mask readers ran naturally. An all-ones byte ANDed with a live mask supplies the static role, not new execution evidence.

The four caption names use `Part2` through `Part5`, describing separate NUL-terminated fragments and renderer invocations without claiming physical line placement. All five caption pointer/bank/call sequences have 19 hits in six existing natural scenarios; the original Shift-JIS encoding and five nine-byte fragments were checked privately. Only the exact 45-byte region `2A:4A66..4A93` is raised from PROBABLE to CONFIRMED.

Two other exact regions have naturally executed readers: the six-byte HTML-store pointer list `3F:4000..4006`, and three keyboard return codes at `55:65D7..65DA`. The keyboard index is not bounds-checked here; the name describes the intended mode-code lookup, not safe behavior for a corrupted restored index. `wKbdInputMode` remains PROBABLE. The two 132-byte delete-all warning regions at `22:481B..489F` and `23:470A..478E` also have all four fragment consumers demonstrated and are locally raised to CONFIRMED. Neighbouring regions are untouched. ConnectDialog names were checked against every branch and complete fixed UI text, without publishing personal sample content.

## Existing aliases used per consumer

Three operands use existing PROBABLE aliases, without defining new labels or promoting their status. At `67:4795/4798`, the pointer and bank operands for the choice-menu BG palette use `Palette_SettingsPhone_ChoiceMenu_Bg`. Its 40-byte adjacency-derived block and documented 64-byte read/24-byte over-read remain unchanged. At `75:63C6`, `MobilePacket_WaitForTelephoneCall` replaces the identical neutral template pointer; this path has no natural reader, so the existing PROBABLE role remains.

The two HDMA operands at `67:475D/4760` keep `Data_4D_5510`: their 768-byte source window contains 40 BG-palette bytes, eight OBJ-palette bytes and a 720-byte tilemap/attribute pair. A global palette rename would misdescribe this mixed read. The three exact consumer substitutions are recorded separately in `neutral_code_alias_sites.tsv`.

## Remaining work and limits

At checkpoint `d64fe05`, this pass leaves **45 names / 136 operands**. The subsequent [shared graphics source pass](naming2_neutral_gfx.md) leaves 42 / 100. Thirty-five instruction groups need further semantic/boundary analysis, nine stay neutral under explicit unexecuted/unknown limitations, and one mixed-consumer name is only partly replaced by its existing alias. The structured-data macro entry remains outside the instruction count. In particular, HDMA copies do not prove tile content, clipped sprite entries need their complete selected chain, and dead or mixed-phase routines are not promoted by sibling execution.

No ROM bytes, new natural traces, forced replay, screenshots, PPU capture, hardware tests or translation were added. Runtime counts come from the existing 69-scenario union. Explicit-reference audits do not prove the absence of every computed pointer in the ROM.

Active metadata repair follows the same original instructions, including 21 stale manual locators found before this pass. The manual writer now reports 156/0 for ramop9 and 300/0 for ramop10 (already written/skipped), instead of 150/6 and 285/15. Historical label5 pkgC/pkgB locators are preserved as snapshots; their 27 stale source references are a separate historical-documentation limitation, without changing the proved bank/address or semantic role.

## Current ledger correction after the FFA7 checkpoint (2026-10-11)

The maintained348 ASM/inc files and the fixed published symbol table at `0d713c71e02e7a7d8ac575608379bc126432e058` identify **28 global neutral-only Function/Label address groups**:23 Function groups and five Label groups in18 banks. A group is a linked ROM bank/address whose global names are exclusively `Function_BB_AAAA` or `Label_BB_AAAA`; local symbols and ROM/RAM address domains are excluded as appropriate. This is separate from the instruction-reference cohort. The older counter27 was incorrect: `MailSession_CompareWordDeltas` already coexisted with `Function_26_5106` at archived `8eab941`, so its alias cannot be subtracted from the archived28 a second time. These28 groups remain unresolved; their count proves neither unreachable code nor semantic completion.

The current strict instruction census is **15 neutral names /18 instruction operands**, comprising14 KEEP names and one PARTIAL_ALIAS. `Function_26_5106` has zero current neutral instruction operands: the maintained CALL at26:4737 uses the existing PROBABLE `MailSession_CompareWordDeltas` alias. The initial65-row worklist retains its original instruction-site counts and cohort membership. Only this stale row is reconciled to APPLIED_ALIAS, retaining its historical KEEP reasoning and legacy HYPOTHESIS decision-row status. The complete ledger now has47 APPLIED,14 KEEP,two APPLIED_ALIAS,one PARTIAL_ALIAS and one PENDING. These are ledger dispositions, not whole-ROM confidence counts.

`Data_6A_72A0` remains the separate pending structured-data macro entry with zero instruction operands. `Data_73_5E60` is outside this initial65-row cohort. The15 bounded comment edits in five owners concern six spans of258 bytes/109 CPU starts, not15 neutral groups removed or completed. Earlier checkpoint and verifier counts remain dated history; the current correction above replaces their use as present-day counters without rewriting those results. No ASM, symbol, ROM byte, confidence level, natural trace, asset or name/frame association is changed by this ledger pass.

### Verified current neutral ledger reconciliation (2026-10-11)

The five-file ledger pass corrects the current counters and records the already-published PROBABLE MailSession_CompareWordDeltas alias as APPLIED_ALIAS, retaining the initial site count, historical KEEP reasoning and legacy HYPOTHESIS row status. The initial65-row ledger has47 APPLIED,14 KEEP,two APPLIED_ALIAS,one PARTIAL_ALIAS and one PENDING; the separate current instruction cohort is15 names/18 operands. The28 global neutral-only groups remain23 Function plus five Label groups in18 banks. Private and ROOT canonical37 each complete36 zero returns and the expected ordinal27 return2/exact97-byte diagnostic, with444 ResourceWarnings. All671 build outputs equal published0d713c7, including everyOBJ/D/SYM/MAP and the original ROM; make reports SHA-256 OK and RESULT: IDENTICAL, with passing symbol and palette checks. No ASM, alias, confidence, new runtime observation, asset or name/frame association changes. The pending6A structured macro and separate73 unit remain subsequent work.

English cumulative ledger/6A parity qualification: the archived neutral-census, natural READ cohorts and canonical37/671/444-warning results above are Japanese-ROM evidence from MAIN457244b and MAINef41bff. English3a31 keeps its translated assets and complete prior history. Own current English DATA resolves the four owner words against the English2985-byte section; this does not assert equality of that graphics section to Japanese bytes, natural English invocation, rendering, hardware or a name/frame association. The prospective English build has not run; only ownerOBJ/SYM/MAP are expected to change, with672 other outputs and ROM824/BFCD held, to be measured under separate authorization.
