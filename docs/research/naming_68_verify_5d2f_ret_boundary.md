# Verification scope for 68:5D2F

This pass proposes a static comment correction and two research notes.
`Function_68_5D2F` remains neutral; entry and purpose remain HYPOTHESIS. No alias, operand, instruction, local label,
data, frozen analysis/config table or build rule is changed.

The original Japan ROM used for readonly byte confrontation had SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
and size 2097152. No ROM was executed or modified. All 54 displayed instructions
in `[68:5D2F,68:5D9C)` were individually encoded and matched to those 109 original
bytes without assembling a candidate, importing a repository helper or using
an emulator. The partition is one RET at 5D2F and the following 108-byte,
53-instruction candidate, with RET at 5D9B. ROM0 consumers 00:14EA and 00:1509
were checked as source and raw bytes in their own bank context.

The source proposal changes exactly the three existing comment rows 27–29 in
`engine/account/password_entry.asm`; all 542 physical rows, blank rows, labels,
address comments and byte-producing text remain in place. Existing
`REVERSE_ENGINEERING.md` and `docs/README.md` receive append-only entries.
The two new notes record the contradiction and evidence limits. There is no
claim that the candidate entry naturally executes.

The finite literal search covers the historical snapshot's 348 asm/inc files.
Frozen mapper/config/symbol/rename/RAM evidence was read as history, with its
contradictory code/data classifications retained. The search does not exclude
computed entries, bank-specific data pointers, arbitrary return addresses or
binary operands outside the searched source representation.

No build, test battery, replay, dynamic trace, forced dispatch, natural menu,
asset rendering, native capture, source publication, Git operation or hardware
experiment was run for this proposal. Raw source-instruction matching is not
a comparison of a rebuilt candidate ROM. Binary rebuild equivalence, deployed
source parent and final validation receipts remain future work.

Before adoption, ROOT must rebase append-only documentation and the three
comment replacements onto the then-accepted source after pending families,
preserving instruction/label/physical-row constraints. The actual source parent
is not assigned here. Independent review and required build/ROM comparison/gate
receipts belong to that future concrete source. Earlier batteries cannot be
reused as proof that this new pass has been executed or published.


## Current private implementation after RET, 55, 6C, 7C and 2D

The preceding aa61 proposal is historical. This private implementation uses guarded private 2D SOURCE4200 (manifest cc27fbd6); published parent, ROOT/independent adoption, actual integration and publication remain NULL. Scope5 replaces only comment rows27–29 of password_entry.asm, keeps all542 physical lines and noncomment vectors, appends RE/index suffixes once and adds these two notes, yielding SOURCE4202. All4197 old files outside scope,348 ASM/inc noncomment vectors and line counts,1248 TSVs including289 metadata files and prior RET/55/6C/7C/2D/2C4F changes remain exact. No aliases or emitted bytes changed.

Own raw108-byte/53-start sequence was sealed before reading proposal facts, with the earlier source header read explicitly disclosed. The first handwritten semantic fields had mistaken CALL targets142E/11D0 and DECD4D even though the decoder operands were14EA/1509 and11D4DE; preserved drafts are corrected by the own54 instruction emitters. The current source/raw confrontation confirms RET5D2F isolated from hypothetical entry5D30, candidate RET5D9B and no sequential edge to5D9C. CALL5D5F targets DecodeXorA5 at00:14EA with SRAM1:B07F→WRAM0:C28F; CALL5D68 targets CompareString at00:1509 with C28F against WRAM3:DED4. The decoder includes decodedNUL and has no count/extent check; compare has no count check. Readable/writable extent and terminating encoded/decoded NUL remain preconditions, not inferred from field-size annotations.

The displayed path enables RAMG0A, selects SRAMbank1 and WRAMbank3, then restores saved HRAM shadows in reverse order. Physical register restoration requires synchronized initial shadows, stable scratch/stack and completed helpers without interfering changes. Equal strings yield A0 before restoration; unequal strings set C2790 and C278=old&FB. FinalA on inequality is that updated mask and can also be0; this is not a Boolean result. The last POPAF restores the first savedF, equal to entryF under the displayed uninterrupted load/stack path; no universal ABI is asserted. Original first savedA is the prior RAM-enable shadow, while finalA comes from scratch. Source names and sibling comparisons are context, not proof of purpose. Entry/purpose/natural reachability remain HYPOTHESIS; bounded structure remains PROBABLE.

Own whole-ROM census found614 candidate address words and71 opcode-like prefixes in the bounded target range, with no bank68 encoded farcall candidate under the two accepted wrapper patterns. These bytes are not proven callers. Literal source search348 found no operand for neutral5D2F/5D30 and does not exclude computed/interior entry or binary tables. The historical coverage union of69 scenarios has no scoped instruction starts; it is not a fresh measurement or a complete69/69/50 corpus review. Missing19 callgraphs are not supplied and absence does not imply global unreachability. No new natural trace, sample field values, assets or credentials were used.

One new private literal37 pipeline completed36rc0 plus ordinal27rc2 with the exact97-byte historical diagnostic. Ordinal1 was the only top-level make build; make/compare/sym-check/palette-check succeeded and wholeROM is IDENTICAL to the original reference. All671 raw outputs, wholeSYM15538 labels/51constants and MAP equal the guarded private2D outputs. RawD334 and10912 rules remain identical;5623 current bindings rebind only password_entry.asm with parent BEFORE4200 separate from current AFTER4202. All147 frozen .py source hashes/sizes/timestamps were preserved; no source.pyc was copied. Native/tool membership remains historical data, without fresh capture or actual-owner proof. No closed pipeline was replayed or foreign helper executed.

This documentation-only appendix is added to the two new notes after37; code/outputs stay unchanged. ROOT will bind actual parent, independent adoption, actual gates, canonical DOC suffixes, fresh checks and publication separately. Private byte verification adds no runtime or hardware claim and supplies no actual integration authority.


## Original bank68 integration verified (2026-10-08)

Three comments separate the RET at68:5D2F from the108-byte/53-start comparison candidate. The candidate selects SRAM1 and WRAM3; unequal strings clear bit2 of C278, so A is not a general Boolean result. Hardware restoration depends on synchronized shadows and a stable stack/scratch context. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.


## Fresh published bank68 verification

Published MAIN470fb7716433eccf585896a1d0019b82ac380bbc was cloned from GitHub into a new private checkout. With the original reference supplied privately, make, compare, sym-check and palette-check each completed rc0 once. All4202 tracked source files equal their Git blobs and all671 outputs equal the accepted private68 pass. The checkout is clean; fresh source modes are0664. This does not add natural execution, visual or hardware evidence.
