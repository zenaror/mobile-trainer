# Mail last-row probe and three bounded KEEP decisions

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
