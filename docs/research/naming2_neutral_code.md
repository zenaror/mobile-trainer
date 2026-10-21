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

### Current structured-data row follow-up

The separate `Data_6A_72A0` structured-data row is now `APPLIED`: its
redundant generic export has been removed, while the existing
`SpriteFrameTable_6A_72A0` label names the same two-word table. The worklist
retains the original `Data_6A_72A0` key for provenance and its legacy
`HYPOTHESIS` decision-row confidence; neither means the generic symbol is
still defined. The ledger now contains 48 APPLIED, 14 KEEP, two APPLIED_ALIAS,
one PARTIAL_ALIAS and zero PENDING rows. The strict instruction cohort remains
15 names / 18 operands, and the 28 global Function/Label groups are unchanged.

At the original 2026-10-11 checkpoint, `Data_6A_72A0` was a separate pending structured-data entry with zero instruction operands; that state is superseded by the current row follow-up above. `Data_73_5E60` remains outside this initial65-row cohort. The15 bounded comment edits in five owners concern six spans of258 bytes/109 CPU starts, not15 neutral groups removed or completed. Earlier checkpoint and verifier counts remain dated history; the current corrections replace their use as present-day counters without rewriting those results. The 2026-10-11 ledger pass itself made no ASM, symbol, ROM byte, confidence, natural-trace, asset or name/frame-association changes.

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


## Remaining labelled local operations and fragment boundaries (2026-10-15)

Ten further PROBABLE local-operation aliases preserve the original neutral labels and instruction locators:

|Address|Operation alias|
|---|---|
|23:6D61|`Wram7_Write14To27AtD1E0`|
|24:42B0|`Wram6_CopyGooUrlAndTitleToPageBuffers`|
|2B:57CB|`Fill99E1Pattern46_Draw5807TwiceAndUpload`|
|2B:64F1|`Show0206_CallDeleteRecordIf1_Else64A7`|
|2B:687C|`Sprite_SetSlots1And2Y68XByC_InitSlot2`|
|2B:6CF5|`CopyRecordBFields_Edit_Pop4IfBodyNot0OrFF`|
|68:5D2F|`ReturnOnly_68_5D2F`|
|6C:61AC|`DecC0DA_OnZeroReload23ToggleC0D9AndSetDA20`|
|70:46A6|`TrySetA9EEFromRandom16_ByA9EDFlags`|
|7C:7D8D|`InitStep70_EntryAThen1Then2_Jump7D82`|

The [mail operations](naming2_neutral_mail.md#operational-descriptions-of-2b57cb-and-64f1-2026-10-15) distinguish current-VBK pattern stores, two fixed-string draws and an upload from a result-dependent dialog/delete/loop transfer. The post-dialog DA10/DA20 stores use the then-selected WRAM bank; they are not a guaranteed sprite restoration. The [sprite operation](typing_2b_687c_residual_localcase_bounds.md#local-sprite-position-and-initialization-operation-alias-2026-10-15) includes the complete default suffix and only the documented slot/helper effects. The mail field-edit path discards four stack words only on its nonzero/non-FF body-result path; no caller or fourth-word unwind ABI is established. Its corrected complete partition is187 bytes/100 CPU starts, with68 prefix starts and69 existing forced observations; body farcall6D86 and copy counts0x40(64)/0x10(16) are explicit. Forced observations remain diagnostic, with no terminal POP/RET or natural-entry proof.

The [WRAM operations](typing_23_24_27_1a_header_facts.md#wram7-ascending-bytes-and-wram6-urltitle-copies-2026-10-15) separate twenty ascending byte stores with shadow-based restoration and scratch28 from constant URL/title copies that leave WRAM6 selected. The copied22/9-byte strings include their NUL terminators; the page-field roles have consumer support without a caller of this entry. The literal ascending-byte name does not infer tile IDs.

The [return-only entry](naming_68_5d2f_ret_boundary.md#return-only-operation-alias-and-separate-comparison-fragment-2026-10-15) covers only C9 at68:5D2F; the following108-byte decode/compare fragment remains separate and unlabelled. The [counter operation](naming_6c_61ac.md#countertogglewrite-operation-alias-2026-10-15) expires only from old1, reloads23 and toggles bit0 of an otherwise unproved byte domain. The [random-range operation](naming_70_46a6_sram_boundaries.md#conditional-random-range-write-alias-and-separate-bit-reader-fragment-2026-10-15) names the tested fields and conditional store, without a game purpose or uniformity claim; the following63-byte bit-reader remains unlabelled. The [init/step sequence](typing_7c_7d8d_choreography.md#entry-a12-init-step-sequence-operation-alias-2026-10-15) starts with incoming A, then1 and2, can fail to terminate and jumps7D82 without a localRET. Its prefix/trailer remain separate, with no new function labels. Stack, mapper/shadow, IRQ, helper-return and buffer preconditions remain part of every applicable contract. Entry/caller/application purpose remains HYPOTHESIS.

The accepted conditions6 linked SYM has10 global neutral-only Function/Label ROM address groups:9 Function and one Label in7 banks. Adding these ten operation aliases leaves **zero global neutral-only Function/Label ROM address groups** under this exact naming census. The derivation groups global ROM symbols by bank/address, excludes local symbols and RAM domains, and keeps only groups whose global names are exclusively Function_BB_AAAA/Label_BB_AAAA before adding these names. The original neutral labels remain. A zero count states that these globally labelled groups now have descriptive aliases; it does not establish every code entry, natural reachability, arbitrary-state ABI, function purpose or whole-ROM semantic completion. It is not a claim that every unlabelled fragment is a function or that all disassembly work is finished. Historical counts remain dated checkpoints.

The separate strict neutral instruction-reference cohort remains15 names/18 operands because no instruction operand changes. Its data/consumer gaps and the separate structured-data entry remain explicit. Reconciliation of the original labelled/unlabelled interval inventory and residual entry boundaries remains necessary before closing function identification. The requested frame/name53/PNG/resource audit also remains open, including KEEP8 and25 unassociated names. English remains suspended until original identification and those checks are complete. These aliases add no new natural, synthetic, visual or hardware execution; static operation descriptions alone do not establish original-ROM reconstruction equivalence.


## Finite original function and fragment reconciliation (2026-10-15)

The zero labelled-group census above was followed by an independent inventory of334 maintained ASM owners. Of47 adjacent hypothesis headers,45 already describe the local mechanism and two retain external-stack/continuation limits (2B:6CF5 and2D:4E42/4E54). Broad generic words in descriptive stub/data names are not an unidentified-function count. The72 annotated unlabelled cores now have conditional contracts in [naming2_verify_fn4](naming2_verify_fn4.md#contratos-condicionais-dos72-blocos-anotados-sem-global--2026-10-15):987 bytes/497 CPU starts/42 inline bytes, not72 new functions. Mapper-dependent fetch, abnormal POP/RET frames and callee progress remain conditions, not guessed ABIs.

The positive source defects are corrected without changing instruction operands or adding aliases: bank7C font10 bytes represented as data;54:4CAD consumed ellipsis classified as text;24:4BCC stale byte count; and comments distinguishing sequential bypass, matching POPs, relative-branch variants and eight profile calls. The separate32-header check covered122 original bytes and retains31 unknown storage spans rather than promoting legal decodes to functions. There is no demonstrated live function with an undescribed local mechanism in these enumerated cohorts. Their entry/caller/purpose and storage ambiguities remain HYPOTHESIS; this finite reconciliation is not a universal proof over all computed targets or arbitrary memory states. The requested complete frames/name53/PNG/resource audit is still open, with KEEP8 and25 names unassociated. English remains suspended.


## Additional shortlist mechanisms and next original audit (2026-10-15)

The finite shortlist also included55:[6F46,6F95) and2C:[6100,614D), outside the72 annotated cores. Their [contracts](classify_g2.md#two-conditional-unlabelled-mechanisms-and-obj-palette-ports-2026-10-15) account for156 bytes/98 CPU starts: old counter1 selects the long OBJ palette update (old0 wraps toFF), while the six-record wrapper has a77-byte sibling differing only in the E28/E30 immediate. The two palette comments now name OCPD correctly; instructions already used OCPS/OCPD and are untouched. No alias, function boundary, caller or display result was added. This closes the positive local-mechanism reconciliation items found in the labelled/unlabelled inventory; frame/mapping/progress and entry/purpose conditions remain explicit. The next work is the requested original frame/name53/PNG/resource audit, including KEEP8,25 unassociated names and the31 raw storage ambiguities, rather than another generic caller-negative replay. English remains suspended.
