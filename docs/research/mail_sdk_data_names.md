# Mail SDK data alias retirement

This finite original-ROM pass retires20 old aliases already colocated with17 existing string names and3 pointer-table names in lib/mobile/mail.asm.

Bank0F:$4000-$4247 is independently reconstructed from the maintained ASCII strings, one zero pad and local pointer words, checked against every current label position and the original-ROM bytes.

The owner starts at0F:$4000 in layout.link; its maintained header states the full extent$4000-$5DAE (7598 bytes).

## Positive readers and finite domains

Mail_HeaderStringTable at0F:4011 has17 little-endian local-ROM pointers,34 bytes.
Mail_EmitHeaderField (4F5D) indexes by2*work[3], loads the pointed string and calls
Mail_EmitString. Valid table indices are0..16; index17 is handled by a separate path
before lookup. There is no general guard against values above17; byte doubling
wraps. The table entries include retained From, Sender, To and Subject aliases,
plus the shared DashDash target at both indices14/15 and Dot at16. Those strings
are NUL-terminated ASCII fragments consumed by the emitter; this does not promise
RFC compliance, safe arbitrary compose records, or full protocol interoperability.

Mail_HeaderKeywordTable at0F:4183 has13 little-endian string pointers,26 bytes.
Mail_FindHeader_Scan (4416) indexes by2*B, dereferences its entry, and matches input
characters against the NUL-terminated uppercase keyword, folding ASCII a..z by
subtracting$20. The finite table domain is B=0..12, with no entry guard here. From,
ReplyTo, To, Subject, Date and ContentType are the retained string aliases selected
by these words. This table and Mail_SelectorTable both contain13 entries but serve
different index spaces; the inherited header's word "parallel" is not evidence of
entry-by-entry correspondence.

Mail_Dispatch (4247) reads wMail_Selector, doubles it in8 bits, reads a word and jumps throughHL.

The dispatcher has already pushed saved SRAM AF, whereas normal Mail_Return at4260 pops that AF and restores the SRAM bank.

MailStr_Boundary at4000 is the fixed "---" prefix passed at5000/5019 to
Mail_EmitStringAndSuffix, whose suffix branches depend on compose item kind.
MailStr_GameCodeAllowList at4004 is consumed by Mail_CheckGameMail at4395: compare
NUL-terminated candidate strings against the unfolded code value, skip to the next
candidate after mismatch, and stop on an additional zero. The string occupies12
bytes and is followed by the separate zero pad at4010; the pad remains separate.
The data identity does not prove that any external game code is accepted generally.

MailStr_KwName at421C is loaded before Mail_FindKeywordValue by ParseContentType
and FindPartName. The matcher folds ASCII input and returns a parameter location
and length; its scan count and SRAM page transitions retain existing preconditions.
MailStr_KwMultipart at4222 is loaded intoDE by Mail_ParseMultipartBoundary; its
matched NUL triggers a second fixed keyword at422C (BOUNDARY=), then extracts at
most$40 bytes until quote/CR. The existing literal$422C operand is preserved.
MailStr_EncodedWordPrefix at4236 is copied until NUL by Mail_EncodeHeaderWords at
5104. Its17-byte data extent includes the terminating NUL; the emitted prefix omits
that terminator. Content and readers support the existing names without proving
complete MIME/encoding conformance or arbitrary malformed-input safety.

All source pointers and table targets are local to ROMbank0F. Mail_DispatchFar in
home/mobile.asm selects0F using the16-bit ROM bank shadows and hardware registers,
calls Mail_Dispatch and restores the caller mapping. It writes selectorA toD002
and returns the resulting D002 value inA. It does not select WRAM5; the caller must
supply that existing work-buffer mapping, coherent mapper/shadows, valid SRAM/input
pages, usable stack and interrupt continuity. The library changes SRAM bank state;
normal Mail_Return restores the saved bank. Table-index counts describe storage
bounds, not a universal safe-entry or register/IME-preservation contract. String
termination, output capacity and page helpers remain existing runtime conditions;
not every reader is naturally called by the application.

## Header-encoder stack contract

Branch-aware local stack traversal exposed a conditional transfer at
`Mail_EncodeHeaderWords` (`0F:50B7`): `PUSH HL` at `50E0` saves the address
of the B/@ byte in `ESC $ B/@`. A NUL observed at the scan's leading-byte
test (`50E2–50E4`) before the closing `ESC ( B/J` goes
to `5137–5139` without popping HL, so RET consumes that text pointer and
leaves the caller return stacked. ASCII termination is balanced; a closed
JIS run reaches `POP HL` at `510F` before Base64 conversion. This records
the original behavior without repairing the ROM or claiming natural entry
into RAM. A small fail-closed interpreter of the original leaf bytes checks
ASCII, unclosed B/@, and closed-B cases with synthetic RAM/stack; it is not
a native emulator hardware observation.
