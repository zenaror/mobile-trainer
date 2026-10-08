# Prepared original bank 55 lookup evidence limits

This is a private comment-only proposal derived from historical original
`aa61d89314329fccea3c4543b3fcfb23ec60444c` (2026-10-08). Adoption parent is
unassigned (`future_parent = null`). It is queued after the original
23→24→27→1A family, the 2C→4F family and the browser return duo. Those
proposals and their separate verification stages are not changed here.

## Bounded static contract

`Function_55_6EEC` remains neutral and PROBABLE. With physical ROM bank 55
stable, ordinary uninterrupted flow and a valid, nonaliasing return stack,
its eight instructions occupy exactly eleven bytes:
`21 f7 6e 85 6f 3e 00 8c 67 7e c9` at 55:6EEC–6EF7 (exclusive).
They compute `HL = $6EF7 + unsigned entry A` and return `A = ROM55[HL]`.
BC and DE have no explicit writes. HL and A change; the routine makes one
indexed ROM read, no data or mapper write, and no local push/pop. Ordinary
RET consumes the caller's return address and advances SP by two.

The ADD establishes the low-byte carry, and the intervening LD instructions
preserve it. `ADC A,H` adds zero, $6E and that carry, producing $6E or $6F
with Z=N=H=C=0 for all 256 byte inputs. The final LD and RET preserve F=$00.
A returned zero therefore does not itself set Z. These are static facts
under the stated execution conditions, not a runtime or hardware result.

`Data_55_6EF7` remains neutral and its whole eleven-byte storage remains
PROBABLE. Bytes at 55:6EF7–6F02 are `00 00 00 00 00 00 01 01 01 01 01`:
indices 0–5 yield zero and 6–10 yield one. They match the bytes at 55:6EB5
but occupy distinct addresses; matching bytes do not establish a shared
purpose. There is no bounds check. Input 11 reads $21 at 55:6F02, the next
routine's opcode, and inputs 11–255 read neighbouring ROM through $6FF6.
The zero/one description is limited to the table's eleven indices. Neither
the universal entry domain nor the field/consumer purpose is demonstrated.

## Caller, bypass and explicit prose correction

The sole maintained symbolic CALL is at 55:5DF8 in the HYPOTHESIS block
55:5DF5–5E02. It loads `wKbdType`, calls the lookup, executes OR A and selects
55:5E5A for zero or 55:5F29 for nonzero. The preceding unconditional JP at
55:5DF2 targets 55:5E5A and bypasses this block; this proves that local
predecessor has no fall-through, not that every possible entry is unreachable.
The caller supplies no local range clamp.

The supplemental static report had said that the handler conditionally
calls `Kbd_SlideOut`. That wording is incorrect. Selection of entry 55:5F29
is conditional on the lookup result. Once entered, `CALL $6427` at 55:5F2A
(`cd 27 64`, `Kbd_SlideOut`) is unconditional. Ordinary static flow is XOR A,
CALL, load zero, store `wKbdMode`, load nine, RET. Return nine requires the
callee to return with a valid stack/context. Caller and handler entry remain
HYPOTHESIS; no live input action, return-nine policy or natural lookup leaf
is established. The original private report remains preserved with its
separate qualification, rather than being silently rewritten.

## Natural corpus and structural comparison

The sealed bounded original corpus contains 69 coverage files, 69 merged
ROM data-access files and 50 available callgraphs. The candidate's eight
starts, eleven table addresses, 5DF5 caller block and 5F29 handler have zero
matching observations in those inputs and in the coverage union. This is
absence within that corpus, not global nonexecution or unreachable code.

Observed siblings 55:6ED6 and 55:6F02 sit $16 bytes either side, sharing the
lookup instruction pattern apart from the base operand. Each has eight
observed starts, across 35 and 32 coverage scenarios respectively. Their
merged table-read unions cover 11/11 bytes at 6EE1 and 10/11 at 6F0D.
Instruction coverage, ROM reads and the available callgraphs remain separate
evidence classes. Periodicity supports the existing structural PROBABLE
classification; it does not establish execution or purpose of 6EEC.

## Proposed source scope and provenance

Only comment rows 88–93 of `engine/keyboard/type_helpers.asm` are replaced.
Its line count remains 359. The strict noncomment vector including blanks,
existing labels/aliases, all instructions, operands and emitted data remain exact.
No alias or status promotion is proposed. This note and its verification
companion are the only new repository paths; the two indexes receive appendices.

The original reference hash is
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The executor static evidence seal hashes to
`5d59bc0718b22ee2c70c95879f6a25241f8152c7682e14d39459d295ae5691c1`;
the qualified readback seal to
`05acb3d78192137815fcd384526a5684db9c22ecf381b3f93ebf013a022b1e2b`;
the independent static confrontation seal to
`292ce112674324d501d567be158501a1e4c0fadda2ae5afad7bc989861af8a17`.
Their full contents were read and their bound files checked by whole-file
size and SHA-256. No foreign helper was executed.

See [prepared verification](naming_keyboard_55_verify_lookup.md) for the
static checks and pending stages. No build, canonical37, replay, new runtime
capture, integration, commit, push or rebuilt-ROM comparison was performed
for this proposal; binary equivalence is not asserted.


## Current private rebase and validation after RET

The preceding text is the historical aa61 preparation record. This private implementation uses the guarded RET SOURCE4192 candidate (manifest 5e386693) as its private predecessor; it is not an adopted or published actual parent. Future actual parent, ROOT/independent adoption and integration remain NULL. Only six comment rows 88–93 of type_helpers.asm change; owner 359 lines and 310 noncomment rows including blanks remain exact. All 348 ASM/inc noncomment vectors/line positions, all 289 metadata TSVs and 4189 existing files outside scope5 are preserved, including the RET aliases and seven 2C4F comments. Source-only count is 4194 after the two new notes.

A single new private literal 37 pipeline completed 36 rc0 outcomes plus ordinal 27 rc2 with the exact 97-byte historical schema diagnostic. Ordinal 1 was the only top-level make build. Whole original ROM comparison is IDENTICAL; make/sym-check/palette-check succeeded. The entire 671-output envelope, SYM 15538 labels/51 constants and MAP are byte-identical to the guarded private RET outputs; no alias was added or removed. All 334 raw dependency files and 10912 rules remain equal, while 5623 current bindings now include the changed type_helpers source SHA. Parent BEFORE and current AFTER are explicit. This private run did not replay the closed RET37 or capture new natural evidence.

Physical bytes and static arithmetic are separately checked: the 11-byte lookup and 11-byte table remain exact, all 256 unsigned inputs compute 6EF7+A without bank change and with ADC-derived F00; index 11 reads opcode 21. Conditional handler selection and unconditional CALL 5F2A once entered remain distinct. Caller/handler purpose and entry remain HYPOTHESIS; neutral PROBABLE function/data are unchanged.

Actual integration, current owner/native/environment closure, fresh validation, canonical DOC suffix rebase and publication require separate ROOT stages. This private result supplies no such authority and claims no live keyboard input domain, forced execution or hardware result.
