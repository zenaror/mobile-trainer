# Mail last-row probe and three bounded KEEP decisions

## Decisions and physical definitions

|Label|Physical source / extent|Decision|
|---|---|---|
|Function_2D_4F03|engine/mail/body_editor.asm,2D:4F03-4F2F,44 bytes|CONFIRMED narrow role alias MailBody_ProbeLastRow; keep unexecuted tail PROBABLE|
|Function_2D_4E54|engine/mail/body_editor.asm,2D:4E54-4E8C,56 bytes|KEEP neutral; no proven entry and early-exit stack anomaly|
|Function_26_5106|engine/mail/mail_session_screen.asm,26:5106-5168,98 bytes|KEEP neutral; equation known, equality arm/field interpretation unresolved|
|Table_2B_6DB0|engine/mail/mail_viewer_sender.asm,2B:6DB0-6DC8,24 bytes|KEEP neutral; sole indexed consumer unentered; storage PROBABLE|

## Record-field edit sequence with an explicit four-word transfer

The record field D526 can be affected by transitive state/aliasing; claiming it always remains the incoming B would require the corresponding callee/state invariants. The known25:54A7 sibling has three POPs and an observed caller/unwind; it does not establish the additional word discarded here or a caller stack for this candidate. There is no claim that the unusual transfer is an intended bug or a repaired behavior. The full contract requires safe SRAM record/index/buffers, coherent WRAM1, mapper/shadows/trampoline, valid stack words throughS+8 and destination mapping, appropriate editor state, balanced returns and no interfering IRQ/alias effects.

The preceding V1 operation appendix incorrectly described the full187-byte[2B:6CF5,6DB0) body as68 CPU starts and placed its body-editor farcall at6D84.

## Reply composition from a received record: proper domain role

`MailReply_ComposeFromRecord` is the current **PROBABLE** domain name at2B:6CF5, replacing the active labels `CopyRecordBFields_Edit_Pop4IfBodyNot0OrFF` and `Function_2B_6CF5`.

`Dialog_Open`72:402A indexes list2 from502F->5063; its0F word at5081 points to 72:5B40.

POP3 receive54:4DB5 forms record+C9h as the display-name destination DE;4DBD forms record+EDh as address destination HL;4DC1 calls Mail_SplitFromHeader4FD2.

SMTP54:4601/4630 uses them as recipient address/display name; header field3 points through 0F:4017 to404E, literal `To: `.

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
