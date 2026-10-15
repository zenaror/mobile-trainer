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

## Operation-alias ledger update (2026-10-15)

The operation alias `StoreDEAtHL_SelectWramBank7` at `00:0A2A` leaves **27 global neutral-only Function/Label address groups: 22 Function groups and five Label groups in 18 banks**, recounted from the accepted parent `adf120fb68d2f7fd572fb1fd9f46c007b60e1435` symbol table with that one alias added. The original neutral alias remains. The exact 17-start structural twin supports a PROBABLE operation name, without proving a caller, natural entry or sprite purpose; see the [bounded contract correction](typing_00_a2a_d34_contract_corrections.md#operation-alias-from-an-exact-structural-twin-2026-10-15). The historical 28-group checkpoints above remain historical. The strict instruction-reference cohort remains 15 names / 18 operands because this entry has no current neutral instruction operand.

This count covers only globally labelled address groups. It excludes unlabelled candidate fragments such as `68:5D30` and measures neither every unidentified function nor semantic completion; an apparent fragment is not automatically an independently callable function. No new trace, natural caller, asset association or hardware evidence is added.

## Counted-wait and task-state operation aliases (2026-10-15)

At original parent `b0e5fbf603ce5dfacc2f8c91ecb5c76b97da3d84`, two further PROBABLE operation aliases retain their neutral labels: `CallVBlankWait60Times` at `2E:4EB2` and `Mobile_InitTaskStateKind1` at `54:41C5`. Existing executed structural relatives support counted helper calls and the fixed task-state tuple, respectively; they do not demonstrate either candidate entry or a specific application purpose. See the [counted-wait evidence](typing_2e_wait_glyph_tail.md#operation-alias-for-the-counted-wait-calls-2026-10-15) and [task-state evidence](naming2_neutral_network.md#task-state-operation-alias-at-5441c5-2026-10-15).

Adding these two aliases to that parent's symbol groups leaves **25 global neutral-only Function/Label address groups: 20 Function groups and five Label groups in 17 banks**. Bank54 has no remaining group in this narrow census; bank2E still has its separate `4F9A` candidate. The earlier 27-group checkpoint above remains historical. Neither target has a current neutral instruction operand, so the separate strict instruction-reference cohort remains 15 names / 18 operands.

The count still excludes unlabelled fragments and does not establish that every original function has been identified. The new names describe local actions under the documented stack, mapping, callee-return and interrupt preconditions. The counted wait does not guarantee 60 frames; the numeric kind1 state does not identify a protocol. Entry/caller and intended purpose remain HYPOTHESIS, with no new natural execution, asset association or hardware evidence.


## Palette map LCD and LCDC-bit operation aliases (2026-10-15)

The PROBABLE local-operation aliases `Gfx_UploadPalettesAndBgMaps_EnableLCD` at27:4EC0, `LCDOn_ReturnBCZero` at27:4EEB and `ClearLcdcBit2` at29:5090 preserve their original neutral labels. The [palette/map and LCD evidence](typing_27_palette_map_tail.md#operational-aliases-from-executed-partial-twins-2026-10-15) separates exact executed40-byte/18-start and9-byte prefixes from the unproved complete candidate entries. The [LCDC-bit evidence](typing_29_leaf_lcdc_ly_limits.md#operation-alias-for-clearing-lcdc-bit-2-2026-10-15) separates executed six-byte relatives from the candidate's own RET. All three names describe operations, not screen intent or natural reachability.

The immediately preceding helpers source has25 global neutral-only Function/Label ROM address groups:20 Function groups and five Label groups in17 banks. Adding these three semantic aliases to those linked symbol groups leaves **22 global neutral-only Function/Label address groups:18 Function groups and four Label groups in16 banks**. Bank27 leaves this narrow census; bank29 retains29:511E. The historical28-,27- and25-group checkpoints remain dated history. The count is derived from the helpers linked SYM by grouping global ROM symbols at each bank/address, excluding local symbols and RAM domains, retaining only groups whose global names are all Function_BB_AAAA/Label_BB_AAAA, then adding these three aliases. It is an address-group naming census, not proof of all original functions, reachable entries or semantic completion.

The separate strict neutral instruction-reference cohort remains **15 names/18 operands**: no instruction operand changes. In particular, JP27:4EBD continues to use the retained Label_27_4EEB alias. A semantic alias at its target changes the global neutral-only group census while preserving that neutral operand. Unlabelled fragments, frame/name associations, KEEP resources and valid-entry requirements remain outside what this count establishes. The names add no natural execution, asset association or hardware result. The palette prefix's saved-shadow restoration is temporary;00:082C selects WRAM7 later. The LCD tail does no map/palette upload, and ClearLcdcBit2 establishes neither29:511E nor the whole742-byte library. All existing stack, mapper, IRQ, trampoline, frame and buffer prerequisites remain.


## Six operation aliases in keyboard SDK and audio (2026-10-15)

Six further PROBABLE local-operation aliases preserve their neutral definitions: `Kbd_Type6To10Flag` at55:6EEC, `Kbd_HideAndReturn9` at55:5F29, `ReadC0F8_Xor1` at73:6143, `MobileSDK_TryQueueSavedPacketWithXor80Ack` at75:7E89, `SoundDrv_CmdStoreTrackByte1E` at04:49B6 and `SoundDrv_ParamStoreTrackWord27` at04:49CD. The [numerical flag evidence](naming2_neutral_kbd.md#numerical-operation-alias-for-556eec-2026-10-15) establishes the result only for the documented type domain0..10, while the implementation remains an unchecked ROM lookup. The [hide-sequence evidence](naming2_neutral_kbd.md#operation-alias-for-the-hide-sequence-with-return-value-nine-2026-10-15) requires a balanced ordinary callee return before the mode-zero store and A9 return, without universal timing or completion. The [byte-read evidence](naming_73_6143_split_returns.md#operation-alias-for-reading-c0f8-xor1-2026-10-15) describes an arbitrary byte XOR1 without a store or general Boolean negation. Entry/caller, application purpose and unresolved field domains retain their documented HYPOTHESIS limits.

The [SDK saved-packet operation evidence](naming_75_7e89_return_boundaries.md#operation-alias-with-an-independently-supported-acknowledgement-field-2026-10-15) supports an attempted queue of saved arguments after writing C6BE from byte[P+2] XOR80. The receive-side C6BE comparison supports the acknowledgement wording, with FF/EE/9F special cases retained. The callee may return carry/error or fail to complete; the wrapper discards the callee carry on POP AF. After an ordinary balanced return, final A is saved old C6C1, Z=!savedbit0, N0/H1 and C=entry carry; only savedbit0one sets currentbit0 later. No successful queue/transmission, whole-AF or whole-byte restoration, universal register preservation or candidate entry is asserted. Full pointer-wrap, alias, IRQ, stack and packet-send limits remain in the note.

The [audio offset-store evidence](typing_neutral_remaining_headers.md#audio-operation-aliases-at-offsets-1e-and-27-2026-10-15) distinguishes the byte-store path through4973, supported by existing executed parameterized siblings and setter starts, from the word-store path through44EC, supported only statically. The first sets D019.bit2 and routes D01F to current-track offset1E before command continuation; the second selects offset27 for the masked active-record word setter. Neither local entry selects the required WRAM1. Natural entry/callers and musical purpose remain HYPOTHESIS, with stream/mapping/request/IRQ/stack limits and no universal final ABI or bounded continuation. Synthetic audio experiments are not natural evidence.

The immediately preceding gfx3 linked SYM has22 global neutral-only Function/Label ROM address groups:18 Function groups and four Label groups in16 banks. Adding these six aliases to that symbol grouping leaves **16 global neutral-only Function/Label address groups:15 Function groups and one Label group in12 banks**. Banks04,55,73 and75 leave this narrow census. Historical28-,27-,25- and22-group checkpoints remain dated history. The derivation groups global ROM symbols by bank/address, excludes local symbols and RAM domains, keeps groups whose global names are exclusively Function_BB_AAAA/Label_BB_AAAA and adds these six semantic aliases. This is a naming census of labelled address groups, not a count of all unidentified functions or semantic completion.

The separate strict neutral instruction-reference cohort remains **15 names/18 operands**, since no operand changes. Existing CALL55:5DF8 and JP55:5DFF still use the preserved Function_55_6EEC and Label_55_5F29 names. An address group can acquire a semantic alias while an instruction retains its neutral operand. The unlabelled73:6149 fragment gains no label and is not promoted to an independently callable function. Other unlabelled fragments, natural-entry requirements, frame/name associations and KEEP resources remain outside this count. These operation aliases add no new trace, rendering, asset association or hardware evidence.


## Conditional signed-load glyph SRAM selected-call and row-cell operations (2026-10-15)

Six further PROBABLE operation aliases preserve the original neutral labels and instruction locators: `LoadSignedC200E_WriteRomLowF0ThenEntryA` at00:0D34, `BlitOneGlyphIfCellsLeft_JumpToRet4F99` at2E:4F9A, `IfA1_MapSram1A9EDBit7To19Or1A_DisableRam` at4E:6172, `CallSelected7BB7_IfReturnsPollLyByFFA4Bit0` at29:511E, `SelectWram1_Call4E54_IfBalancedReturnWriteRamGate0` at2D:4E42, `ScanD400RowCell_OrRetToSavedBCOnEarlyNul` at2D:4E54. The [signed-load contract](typing_00_a2a_d34_contract_corrections.md#operation-alias-from-the-complete-static-contract-of-000d34-2026-10-15) describes a C2xx sign extension after PUSH and explicit F0/entry-A low-selector writes; it does not restore a sampled selector. The [one-glyph contract](typing_2e_wait_glyph_tail.md#one-current-glyph-with-an-explicit-jump-to-ret4f99-2026-10-15) draws once when the counter is nonzero and jumps to RET4F99, without inheriting the sibling loop. The [SRAM operation](typing_neutral_remaining_headers.md#conditional-sram-bit-mapping-operation-at-4e6172-2026-10-15) returns19/1A only for incoming A1, with final F80, RAM disabled and SRAM1 retained.

The [selected-call contract](typing_29_leaf_lcdc_ly_limits.md#selected-address-call-and-conditional-ly-polling-operation-2026-10-15) requires a balanced return from selected7BB7 before polling LY by one FFA4.bit0 sample. The original bank29 callee window is zero padding, not the Joypad_Update code in bank7D. Polling may not be reached or terminate. The [row-cell contract](typing_2d_4e42_4e54_stack_scan.md) separates balanced POPBC/RET from the early-NUL RET using saved BC as PC; the wrapper cleanup is conditional on the helper returning balanced. Neither a getter ABI nor safe arbitrary input/stack/mapping is asserted. Entry/caller, application purpose and transitive unknown callee effects remain HYPOTHESIS; existing evidence supports only the described operations under their documented preconditions.

The accepted ops6 linked SYM has16 global neutral-only Function/Label ROM address groups:15 Function and one Label in12 banks. Adding these six aliases leaves **10 global neutral-only Function/Label address groups:9 Function and one Label in7 banks**. Banks00,29,2D,2E and4E leave this narrow census. The derivation groups global ROM symbols by bank/address, excludes locals and RAM domains, retains groups containing only Function_BB_AAAA/Label_BB_AAAA names, then adds these six aliases. It excludes unlabelled fragments and is not a measure of all unidentified functions, natural reachability or semantic completion. Historical counters remain dated checkpoints.

The separate strict neutral instruction-reference cohort remains15 names/18 operands: no instruction operand changes. The neutral labels stay available, RAM-name confidence is unchanged, and no new runtime, natural entry, frame/name association, rendering or hardware evidence is supplied. KEEP assets, computed-caller questions and the requested final frames/names53/PNG/resource audit remain open. Reconstruction equivalence still requires the documented original-ROM build/comparison checks; static operation descriptions alone do not supply it.
