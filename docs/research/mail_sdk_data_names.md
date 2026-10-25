# Mail SDK data alias retirement

This finite original-ROM pass retires20 old aliases already colocated with17
existing string names and3 pointer-table names in lib/mobile/mail.asm. No new name
or purpose is inferred from spelling alone. Bank0F:$4000-$4247 is independently
reconstructed from the maintained ASCII strings, one zero pad and local pointer
words, checked against every current label position and the original-ROM bytes.
The owner starts at0F:$4000 in layout.link; its maintained header states the
full extent$4000-$5DAE (7598 bytes). Each alias's own string extent
ends at its first NUL, or at its table end: grouped region headers can contain
additional strings with their own labels. No grouped header is mistaken for the
extent of its first alias. All20 inherited data headers remain PROBABLE.

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

Mail_SelectorTable at0F:4169 has13 local-ROM code pointers,26 bytes. Mail_Dispatch
(4247) reads wMail_Selector, doubles it in8 bits, reads a word and jumps throughHL.
Indices0..12 describe the physical table; no caller validation is supplied by the
dispatch itself. Critically, index0 targets Mail_SelectorNop at426C, a literal RET.
The dispatcher has already pushed saved SRAM AF, whereas normal Mail_Return at4260
pops that AF and restores the SRAM bank. The index0 RET therefore cannot be assumed
to satisfy the normal dispatch stack/return ABI. This is a documented static caveat,
not a code correction, new runtime reproduction or guarantee for any selector.
Retiring the table's redundant alias leaves all pointers and entry behavior intact.

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

## Bank, ABI and evidence limits

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

DATA records source operands and exact original-ROM pointer instruction matches,
table words and destinations, local-scope checks, the full prefix reconstruction,
and a finite maintained-source/comment/TSV/tool-literal search. No emulator, native
build, natural scenario or hardware result is supplied. Lexical names and old
confidence comments alone were not used as proof.

## Exact transformation and pending validation

Twenty alias declaration lines become blank lines; one current padding comment
uses MailStr_GameCodeAllowList instead of String_0F_4004. Every physical source line,
other comment/status and local scope remains unchanged, except the ptrtable
header at physical line133: its misleading "parallel" parenthetical is corrected
to distinguish keyword B indices from selector dispatch indices. Its PROBABLE
status and physical row remain held. No selected alias owns
locals or qualified symbols. Active consumers already use the retained names;
current operational TSVs and Python literals have no retired alias references.
Frozen config/analysis/xref history remains literal provenance. The separate
Label_0F_5C5B and all other code/data names remain KEEP in this pass. Asset paths,
resource bytes and all earlier proposal/scout packages remain intact.

The historical isolated prediction removes20 globals from the sealedQ3 map:
14921 to14901, with all remaining values and51 exported constants held. The
separate ROOT31 integration comprises HOME11, Audio9, Title4 and GFX7, predicting
14890 symbols. Rebasing this disjoint Mail20 follow-on against that exact map
predicts14870; ROOT must verify the linked result after ROOT31 is published.
The old isolated receipt remains historical; no follow-on native result is claimed.
Independent review, fallback-manifest integration, linked symbol checks and native
original-ROM comparisons remain pending. A static proposal is not byte-identity
validation or independent self-acceptance.

## Header-encoder stack contract (2026-10-25)

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

The maintained SMTP header producer has a narrower domain: for complete
valid SJIS units without literal ESC, at most 83 source bytes (64 address,
2 separator, 16 display name, closing parenthesis) expand to at most 251;
20 subject bytes expand to at most 62. A finite ASCII/JIS-mode length model
includes the closing escape. These fit capacities 256/128 and the one-byte
measured field lengths, excluding capacity truncation of a JIS run in this
domain. It does not prove every stored input has complete SJIS units, no
embedded ESC, or stable nonaliasing state. The body conversion is a different
route and is outside this header result. No candidate root or Bank53/frame
association is established. Reproduction and per-path states:
`check_header_contract.py` (review artifact) and
`HEADER_CONTRACT.json`. The broad `probe.py`/`RESULT.json` in that directory
are candidate generation only: balanced calls assumed, bounded stacks, no
register/memory/mapper tracking; their other rows are not confirmed defects.
