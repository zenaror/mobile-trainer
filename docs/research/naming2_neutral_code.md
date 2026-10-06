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
