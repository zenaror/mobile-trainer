# Mail last-row probe and three bounded KEEP decisions

The decisions below are the historical mail naming pass. The current26:5106 operation alias and its preserved neutral label are recorded in the current ledger correction appended below.

> Status: **reference (current)**. Four original candidates were derived independently and reviewed in full. One role alias is confirmed; three cases remain neutral, with unexecuted paths and a stack anomaly explicit.

## Decisions and physical definitions

|Label|Physical source / extent|Decision|
|---|---|---|
|Function_2D_4F03|engine/mail/body_editor.asm,2D:4F03-4F2F,44 bytes|CONFIRMED narrow role alias MailBody_ProbeLastRow; keep unexecuted tail PROBABLE|
|Function_2D_4E54|engine/mail/body_editor.asm,2D:4E54-4E8C,56 bytes|KEEP neutral; no proven entry and early-exit stack anomaly|
|Function_26_5106|engine/mail/mail_session_screen.asm,26:5106-5168,98 bytes|KEEP neutral; equation known, equality arm/field interpretation unresolved|
|Table_2B_6DB0|engine/mail/mail_viewer_sender.asm,2B:6DB0-6DC8,24 bytes|KEEP neutral; sole indexed consumer unentered; storage PROBABLE|

Definitions are four, instruction operand uses five: two calls to4F03, one call to4E54, one call to5106, one HL load of6DB0. No BANK operands, macro use or additional data references to these four names exist in the hand source. Original selected-bank encoded pattern census agrees exactly:2D:4745/59A6 call4F03,2D:4E49 call4E54,26:4737 call5106,2B:6D2A loads6DB0. audit.json records all nine definition/use sites and bank-qualified original bytes. Matching words in unrelated banks are not consumers.

## Last-row probe: bounded rename

The W1 body buffer is192 bytes, eight rows of12 two-byte cells; high bytes of cells carry the00 terminator or0D row break. The function always puts B=7 before MailBody_GetRowPtr and probes that row. GetRowPtr selects W1 explicitly, ignores low bytes while finding rows, scans each preceding row to newline or12 cells, and marks a requested row missing with D=FF when an earlier00 terminator is reached. For a present row it returns D=0, HL=row start, E=number of nonterminator cells capped at11. An empty existing row is distinct from a missing row.

4F03 returns A=1 for missing row7. Otherwise E!=11 returns0. E==11 calls MailBody_GetCharPtr with B=7,C=11 (the twelfth cell). If that helper returns D=FF (00 or0D encountered), inc D makes0 and the probe returns0. A valid twelfth cell has D=0, inc D makes1 and the probe returnsFF. BC is saved/restored on every path; DE,HL,AF are working results, not preserved arguments. W1 remains selected. GetRowPtr disables SRAM through rRAMG=0; the FF branch repeats that disable. No new name says buffer full, text valid, accept/reject, or a UI warning.

All28 instruction starts decode against the original44 bytes. Only the first nine instructions4F03..4F11 execute naturally,45 hits/10 scenarios each; they take the missing-row A=1 arm. The remaining19 instructions4F12..4F2E have zero natural execution and retain the existing PROBABLE block comment. The narrow role 'probe last row' is demonstrated by the executed B7/GetRowPtr sequence, not by assuming its unseen result cases ran.

Caller2D:4745 follows MailBody_SetupScreen,40 hits/10 scenarios; it immediately overwrites D and begins cursor-down work without inspecting A. Caller2D:59A6 follows setup/restoration,5 hits/2 scenarios, then pops BC and jumps to591B, whose first instruction xor a,a overwrites A. Neither uses the probe result as a predicate. Existing row helpers establish W1; no selected-bank assumption is inherited from the caller. The exact tuple behavior above is static for the unexecuted arms and is not promoted by this role alias.

## Unentered scanner: stack and sentinel contract refutation

4E54 has38 decoded instructions and zero natural execution. Its only call is4E49 inside unreferenced wrapper4E42. That wrapper selects W1 before the call, then would disable SRAM and restore BC after a normal return. The scanner itself does not select WRAM. It pushes BC, sets HL=D400, and uses original B as row index and C as column target. It skips preceding rows by0D or12 cells, then walks cells toward the requested column, stopping at0D or00. There are no row/column bounds checks; B/C increments also wrap atFF.

The normal tail4E85 calculates E from original requested C minus remaining C, reloads A=[HL], pops BC and returns. HL is the selected/clamped high-byte pointer. Early absent-row code4E6B..4E72 writes A=FF,E=FF,HL=FFFF and executes RET without POP BC. RET therefore loads PC from the saved BC argument word, leaving the actual caller return address underneath. It does not normally return the advertised FF/FF/FFFF sentinel tuple to its wrapper. Further,00 testing follows the per-row counter test, so a00 byte in the twelfth slot is skipped as a row boundary before the early-absence test. Preserve this exact ordering and anomaly; no repair, semantic getter alias, safe-return claim or confidence increase.

## Session arithmetic: equation is established, purpose remains open

5106 is physically in mail_session_screen.asm, not mail_session.asm. Its sole caller26:4737 in ReceiveMailsLoop runs49 times/7 natural scenarios. W1 is explicitly selected at entry and again before the second pair. Define little-endian ordinary words X03,X05,X0B,X0D at wMailSessionBlock offsets03,05,0B,0D. The routine computes

    (X05-X03) - (X0B-X0D) modulo65536.

Each xor FF/inc pair forms a two's-complement negation while computing; that does not imply the stored words use one's-complement representation. The first52 instructions, including the unequal tail, all run49/7. Unequal restores incoming HL/DE/BC and returns A0. Equality arm514D..5167 has20 instructions, zero natural executions: statically it copies X0B to X0D, replaces returned HL with X05, restores BC/DE, and returns A1. Both paths leave W1 selected. Caller DEC A/JP Z distinguishes A1 fromA0 and targets49FF on equality.

The caller stores its incoming loop HL into offset03; other setup/scan code stores and updates0B/0D and feeds these words to DrawMailCounts and result-count display. These are not established dereferenced pointers. The algebra and display consumers refute a blanket historical pointer-pair claim. Their exact filtering/count semantics and the purpose of the never-observed shortcut are not settled here. Do not call this receive completion, pointer synchronization, or progress equality merely from the containing routine's name. KEEP preserves the existing partial classifications and records the exact arithmetic contract.

## Twelve SRAM addresses: static bank proof without natural promotion

The original24 bytes decode to A124,A251,A37E,A4AB,A5D8,A705,A832,A95F,AA8C,ABB9,ACE6,AE13, exactlyA124+i*012D for i0..11. There is no sentinel word. Neighboring6DC8..6DD0 eight zero bytes are outside the table and retain their classification.

The sole source load2B:6D2A sits in unreferenced HYPOTHESIS6CF5. Before the reads it explicitly selects SRAM bank0 and enables SRAM with0A; W1 is selected for output. It forms C=B, B=0, SLA C, then adds BC to table HL, so the index is2*originalB modulo256 with carry discarded; there is no0..11 check. Valid record inputs0..11 are a static precondition, not naturally established bounds. It reads the pointed record at+ED for40 bytes into W1 D4C0 and at+C9 for10 bytes into W1 D514. ED+40=012D reaches exactly the record end. SRAM bank0/enabled remains the selected state during both copy loops; later editor farcalls occur after these reads. No field-purpose claim is required from historical names of destination buffers.

The table's24 bytes have zero natural data-read scenarios, and the load/consumer has zero natural instruction evidence. Existing forced_dead annotations are diagnostic only. Other equal physical record-address tables do not supply evidence for this unentered consumer or justify alias merging. KEEP leaves the table's PROBABLE storage header, values and physical neutral name intact.

## Later existing-alias reconciliation (2026-10-11)

The historical KEEP decision for `Function_26_5106` above predates the published narrow PROBABLE alias `MailSession_CompareWordDeltas`. Both labels remain at26:5106; the maintained CALL at26:4737 already uses the alias. This ledger correction records APPLIED_ALIAS and preserves the original one-site cohort count, old KEEP reasoning and legacy HYPOTHESIS decision-row status. The original arithmetic, unobserved equality arm and unresolved field meanings remain qualified. See `typing_26_compare_word_deltas_alias.md` and `naming2_neutral_code.md`; no new routine rename, execution or confidence promotion occurs here.

## Reply near-twin: unequal entry and nonlocal-return contracts

`2B:6CF5..6DB0` is not ABI-equivalent to the named `Mailbox_ReplyToRecord` at `25:54A7..5569`. The former uses entry B directly, clears only 36 bytes at W1:D400 and starts `MailAddr_Edit` with A=0; the latter first forms B=B+C, clears 292 bytes through D523 and starts that editor with A=1. `MailAddr_Edit` preserves this selector until `2D:65F9`: A=1 takes the immediate keyboard call, while other values enter the cursor/input loop. The identical twelve-word SRAM0 record tables and the later address/title/body editor sequence therefore do not justify copying the sibling's entry contract or name.

The decisive stack difference is on the body-result path excluding A=0 and A=FF. At `2B:6D94..6D97` there are four POP AF instructions before RET6DA2; the bank25 sibling has three at `25:554E..5550` before RET555B. Let S be SP at entry and assume valid stack, balanced external returns and the ordinary in-function paths: the bank2B path returns through the word at S+8 with SP=S+10, while its cancellation RET6DAF uses the original word at S with SP=S+2. The bank25 success path instead uses S+6 and ends at S+8. This is a conditional nonlocal transfer, not a normal register-restoring return or a demonstrated bug/intent.

Positive existing evidence distinguishes the sibling from the candidate: the maintained `mail_inbox` callgraph records `25:4591 -> 25:54A7` at frame11575 and `ret_unmatched 25:555B -> 00:06FF` at frame15848; the coverage union records all three sibling POPs in that frame. Its caller `Mailbox_ReplyStart` has the direct CALL plus saved BC/DE words that the three-POP exit bypasses before rejoining the far-call common return. No corresponding entry or caller stack has been established for the additional word discarded by `2B:6CF5`. **CONFIRMED** are these original bytes and the cited finite sibling observations; the candidate's static stack mechanics are conditional, and its entry, unwind ABI and intended purpose remain **HYPOTHESIS**. No alias, confidence promotion, repair, new execution or equivalence claim follows.


## Operational descriptions of 2B:57CB and 64F1 (2026-10-15)

`Fill99E1Pattern46_Draw5807TwiceAndUpload` and `Show0206_CallDeleteRecordIf1_Else64A7` are PROBABLE local-operation aliases, preserving `Label_2B_57CB` and `Function_2B_64F1`. Their names describe literal writes/calls/branching, not an inferred screen purpose. Entry, natural caller and application purpose remain HYPOTHESIS; earlier naming decisions and forced-only classifications remain historical. No natural execution is supplied by these names.

### Literal pattern, two source-string draws and upload

The original[2B:57CB,5806) has59 bytes/35 CPU starts, maintained in `engine/mail/received_mail_grid.asm:602..637`:

```text
21e199f3f044fe9020fa3e4622222222232222232222232222232222fb
c5010002110804210758cd8b58010002115804210758cd8b58cd7759c1c9
```

It sets HL99E1, executes DI, polls LY until90 and writes46 at offsets0,1,2,3,5,6,8,9,11,12,14,15 from99E1. Four intervening cells are skipped. No VBK selection precedes those stores: they target the currently selected VRAM bank, so calling them BG tile-ID writes or asserting a visible cleanup is unsupported. The LY loop has no timeout; LCD/progress/VRAM-access conditions matter. It then issues EI rather than restoring incoming interrupt-enable state.

Calls57F2/57FE invoke2B:588B (`MailGrid_DrawTextLine12`) with BC0200, DE0408/0458 and HL5807. Original[5807,5814) is six8140 pairs followed by00, a fixed full-width-space character string; no personal sample data is involved. The renderer sets C2EE to12, reads source bytes under WRAM1, loads glyphs and blits into the canvas. Glyph availability, table/mapping integrity and valid coordinates/colors are prerequisites; coded spaces alone are not independent PPU/visual proof. It can remap glyph buffers in place and select WRAM2/3 through the canvas helpers.

Call5801 invokes2B:5977 (`MailGrid_UploadTextTiles`), which saves actual rSVBK in AF, selects WRAM2, writes VBK0, and supplies HLD000/DE9000/C27 to5994. That helper programs HDMA1..4, waits for LY8F then91 without timeout and writes27 toHDMA5 for0x280 bytes. It leaves VBK0 and restores hWRAMBank/rSVBK from the actual selector byte sampled on entry to5977, not from an entry57CB save. No original WRAM/VRAM/interrupt-state restoration ABI is promised.

BC is protected by the outer PUSH/POP. Under normal balanced helper returns, DE/HL after the upload are FF44/D000; A is the actual rSVBK byte sampled by5977. Upload's POP AF restores the F received from the second renderer; its ordinary count-zero exit is CP0/RET Z, giving FC0 under the shown valid twelve-cell path. This is conditional on the rendering/helper state and uninterrupted nonaliasing stack flow, not universal AF/DE/HL preservation. Stack aliases, IRQ/mapper interference, invalid glyph/color/canvas data or absent LY progress are outside that contract. The preceding source JP2B:56EF is static context, not a new natural caller. The lone RET5806 and data5807 onward are outside this returning entry.

### Dialog0206 and explicit result-dependent transfer

Original[2B:64F1,6548) is87 bytes/30 CPU starts, including seven separate farcall operand triplets (21 data bytes), maintained in `engine/mail/mail_viewer_sender.asm:58..92`:

```text
c53e07e08de0703ee0ea10daea20dacdd106560900110602d5d1
cdd106154072f53e68ea10daea20dacdd106560900f1c13dc2a764
cdd10633412d3e07e08de070cdd106560900cdd106b0727fcd6404
cdd10670434fc9
```

The body saves BC, selects WRAM7 and writes E0 to DA10/DA20, then farcalls Sprite_UpdateAll00:0956 at6500. It loads DE0206 and invokes Dialog_Show72:4015 at650B; a local PUSH DE/POP DE pair before that call is balanced and does not preserve DE across the dialog. After saving the dialog's AF, it writes68 to DA10/DA20 in the bank then mapped, without selecting WRAM7 again, and calls Sprite_UpdateAll at651A. POP AF recovers the dialog result/flags; POP BC recovers entry BC before DEC A.

The raw post-dialog DA10/DA20 stores must not be named a guaranteed sprite restoration. `naming2_verify_ramop7.md`, section4c, records an existing sibling that enters Dialog_Show with WRAM7 and returns WRAM1 through a Sound_FrameService/STAT window followed by shadow-based restoration. That historical evidence is not a new run or execution assigned to64F1; it refutes assuming that Dialog_Show always preserves the real/shadow WRAM selection. Sprite_UpdateAll explicitly selects WRAM7 internally and restores via the software shadow, so it does not retroactively change which bank received the preceding literal stores.

DEC A makes Z exactly when the original dialog result equals1, sets N1/H according to the decrement and retains carry recovered from the dialog. Original result other than1 tail-jumps to64A7, entering the sender-page loop; this is not an immediate ordinary return. Result1 farcalls MailRecord_Delete2D:4133 at6526 using recovered entry B, explicitly selects WRAM7, updates sprites at6532, calls Stat_DisableScrollSplit7F:72B0 at6538, waits through00:0464 at653E, fades through4F:4370 at6541 and returns at6547. No final AF/BC/DE/HL or mapper preservation is inferred across those helpers or the loop path.

MailRecord_Delete's explicit selected-SRAM0 copy/shift/last-record-clear operation requires a valid record B in0..11; the candidate adds no bounds check. Valid stack, coherent ROM2B/farcall trampoline and shadows, initialized sprite/dialog/mail state, safe SRAM/VRAM state, balanced callees and appropriate IRQ/frame progress are required. The alias names the conditional call and concrete branch target, not caller intent, a universal completed deletion or a generic dialog ABI.

## Record-field edit sequence with an explicit four-word transfer (2026-10-15)

`CopyRecordBFields_Edit_Pop4IfBodyNot0OrFF` is a PROBABLE operation alias for `Function_2B_6CF5`. It replaces the earlier neutral-name recommendation for the bounded operation only; entry, caller, nonlocal-unwind ABI and application purpose remain HYPOTHESIS. It is not an ABI-equivalent ReplyToRecord name. The original complete[6CF5,6DB0) has187 bytes/100 CPU starts with three farcall triplets separate (9 data bytes); the existing neutral definition and all instruction locations remain.

The operation selects WRAM1, SRAM0 and RAM-enable0A, clears0x24 bytes at W1:D400, and uses entry B directly (without B+C). It forms the table byte offset2*B modulo256, discarding SLA C carry, with no0..11 bounds check. Valid indices0..11 select twelve012D-stride record bases; arbitrary indices are not a safe API. It copies record+0xED for0x40 bytes (64 decimal) to W1:D4C0 and record+0xC9 for0x10 bytes (16 decimal) to W1:D514. It then selects W1, writes mode3 atD524 and entry B toD525/D526. SRAM0/enabled is the explicitly selected state during both copy loops; later editor effects are transitive and are not promised to preserve it.

It enters MailAddr_Edit2D:65B0 with A0 at6D6D; address FF cancels. Other address results enter MailTitle_Entry2C:4000 with A0 at6D7C; title FF reenters address with A1. MailBody_Edit2D:4722 is called at6D86; body FF reenters title with A1, body0 cancels, and other body results reach four POP AF instructions at6D94..6D97. Those loops/callees need not complete, and no live input policy is inferred.

Let S be SP at entry and assume valid nonaliasing memory, balanced external returns and normal internal paths. The four POPs consume wordsS,S+2,S+4,S+6; the following RET6DA2 uses the word atS+8 and ends with SP=S+10. Final F is the low flag byte of the fourth popped word, masked to its high nibble, not the body editor's status. Subsequent instructions force WRAM1 and read D526 into A and C; they do not change F. Cancellation RET6DAF uses the original word atS and ends atS+2, with A=FF,C=current D526 and F from the matching CP (C0 on the explicit address-FF/body-zero branches), under the same assumptions. No universal B/DE/HL preservation is claimed across the editor calls.

The record field D526 can be affected by transitive state/aliasing; claiming it always remains the incoming B would require the corresponding callee/state invariants. The known25:54A7 sibling has three POPs and an observed caller/unwind; it does not establish the additional word discarded here or a caller stack for this candidate. There is no claim that the unusual transfer is an intended bug or a repaired behavior. The full contract requires safe SRAM record/index/buffers, coherent WRAM1, mapper/shadows/trampoline, valid stack words throughS+8 and destination mapping, appropriate editor state, balanced returns and no interfering IRQ/alias effects.

These mail operation names add no new natural, forced, visual or hardware execution. Forced-only annotations remain diagnostic; no status is promoted from them. No reconstructed-ROM equivalence is established by static byte/source correspondence. The documented build, symbol check and original-ROM comparison remain necessary for later integration.


### Correction of the full-span count, forced-prefix coverage and body-call locator (2026-10-15)

The preceding V1 operation appendix incorrectly described the full187-byte[2B:6CF5,6DB0) body as68 CPU starts and placed its body-editor farcall at6D84. Independent review and a separate direct original-ROM instruction partition refute those two statements: the complete body has100 CPU instruction starts, with9 inline farcall-data bytes separate. The68-start count belongs only to[6CF5,6D6B), whose last instruction is the JR at6D69; the remaining[6D6B,6DB0) has32 starts. Raw6D84 is28E5 (JR Z6D6B); the body-editor farcall is6D86, `CD D1 06 22 47 2D`. The source instructions and branch behavior are unchanged; only the new descriptive appendix and one existing header comment are corrected.

The original source header's “forced_dead68/68starts” describes that prefix, not whole-body closure. In the existing `traces/forced/coverage_forced_dead.tsv`,68 prefix starts plus the farcall start6D6D give69 of the100 complete-body starts; the6D6D row is line4159 with one hit at frame5002. The four POPs6D94..6D97 and final RETs6DA2/6DAF are not observed by those rows. Forced evidence remains diagnostic and supplies no natural caller, completed nonlocal return or unwind ABI. The header retains its physical line1224 while explicitly qualifying69/100 and the missing terminal paths. Historical frozen metadata and older research snapshots remain historical rather than silently promoted to full coverage.

Copy units are also explicit here: LD B,40 encodes0x40=64 bytes after record offset0xED, and LD B,10 encodes0x10=16 bytes after offset0xC9. The V1 prose's unprefixed “40bytes”/“10bytes” was ambiguous and is corrected in the new operation appendix. Earlier historical text is preserved as written. No range, operand, callee, four-POP/S+8 contract or confidence conclusion is changed by these count/locator/unit corrections.


## Reply composition from a received record: proper domain role (2026-10-15)

`MailReply_ComposeFromRecord` is the current **PROBABLE** domain name at2B:6CF5,
replacing the active labels `CopyRecordBFields_Edit_Pop4IfBodyNot0OrFF` and
`Function_2B_6CF5`. The role means staging the recorded sender as recipient and
running the address/subject/body editors in reply mode. It does not identify a
natural caller or adopt a sibling's ABI. The earlier purpose-HYPOTHESIS decisions
above are superseded for this narrow domain role only; natural entry, intended
UI hook, valid caller domain and four-word unwind intent remain HYPOTHESIS.

The positive evidence is independent of name similarity. Original2B:6D5D stores3
at WRAM1:D524. Body-editor2D:4786/59E7 and address-editor66D3 distinguish mode1
(new mail),2(revise) and other values including3(reply-discard dialog020F).
`Dialog_Open`72:402A indexes list2 from502F->5063; its0F word at5081 points to
72:5B40. The original69-byte record has header860201 and CP932 lines
`　かきかけのへんじは　きえて　　` / `　しまいます。よろしいですか？　`
(the unfinished reply will disappear; confirm?). SHA256:
`9203f52b1b3bfc1ff4fad6759491bf9a78c7f29d96b43c43a60f78560b8ac78d`.
This establishes a reply-domain discriminator, not a claim that3 is the only byte
selecting that fallback or that this candidate displayed it. The extra mode tests
at47D8/5A41 rejoin the same47E5/5A4E exit and add no distinct reply operation.

The record fields have positive producers and consumers. POP3 receive54:4DB5
forms record+C9h as the display-name destination DE;4DBD forms record+EDh as
address destination HL;4DC1 calls Mail_SplitFromHeader4FD2. The splitter parses
angle brackets/parentheses with16/64-byte copy bounds; its display-name field
can also contain an unstructured-address fallback, not a validated human name.
The candidate copies64bytes from+EDh toWRAM1:D4C0 and16bytes from+C9h toD514.
The copies end at record+12Dh/+D9h and copy any existing padding/terminator;
they neither trim nor validate encoding/NUL termination of a malformed record.
MailDraft_SaveToSram2D:403C stages those into SRAM0:A000/A114. SMTP54:4601/4630
uses them as recipient address/display name; header field3 points through
0F:4017 to404E, literal `To: `. The copied received sender therefore becomes
the outgoing recipient. No direct SMTP execution, Reply-To-header policy or
network result is attributed to this candidate.

Entry B is the direct record index; valid0..11 selects A124+i*012Dh from the
twelve-word table6DB0. Doubled-C indexing is modulo256 with no bounds check.
The candidate clears only24h=36bytes atD400..D423; it neither performs the used
25:54A7 sibling's124h=292-byte staging wipe nor copies received body+9/subject+D9.
Its prefix leaves the rest of the body and the subject buffer untouched. A0
address entry goes to the ordinary cursor/input path; the sibling usesA1 for
immediate keyboard entry. Both later use titleA0 initially, titleA1 after bodyFF,
and the same body editor. A0 is not a clear-buffer promise: both address/title
editors preserve the selector to their explicit1 tests at2D:65F9/2C:4031.
The name does not imply a fresh subject, quoting, Re: prefix, full erase or send.
The source comment on the `$D400` immediate now records only this measured
36-byte WRAM1 wipe; its full role remains unproved.

The original four-POP transfer stays explicit. With S=entry SP, balanced callees,
valid nonaliasing stack and coherent mapper/state, body result other than0/FF
discards wordsS..S+6 and RET6DA2 consumesS+8, ending atS+10. F comes from the
fourth popped word; the tail selectsWRAM1 and loads currentD526 intoA/C. Cancel
RET6DAF instead usesS and ends atS+2 withA=FF,C=currentD526. D526 is set from
entry B at6D65, but transitive editor/overlay behavior is not a universal promise
to preserve it. The used sibling's three POPs and observed return do not explain
the extra word here. The possible nested-viewer frame remains hypothetical.

The complete original[6CF5,6DB0) is187bytes/100CPU starts plus9 inline far-pointer
bytes, SHA256`e6c91d7430f7d9297da49ec0027b3c366100382b87692f72efd7e61490da534d`.
All instruction/data rows stay physically fixed. The two replaced global-label
rows keep the proper name then its domain-proof comment; the eight local labels
are rescoped from Function_2B_6CF5 to MailReply_ComposeFromRecord. There are no
active operand or qualified-local references to either retired global spelling
in the maintained original ASM/inc tree. Old address/name mappings above retain
provenance without generic active function aliases.

This derivation used pinned original bytes and selected positive existing field
consumers; it did not replay the69-scenario negatives, scan callers again, force
entry, build or execute a runtime test. Existing sibling/producer/dialog coverage
belongs only to those consumers. This private role proposal establishes no
natural candidate entry, new hardware/visual evidence or reconstructed-ROM
equivalence; independent review and the later canonical adoption gates remain
separate requirements.
