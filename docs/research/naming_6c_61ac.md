# Prepared original 6C:61AC counter and sprite contract

This comment-only proposal uses historical original
`aa61d89314329fccea3c4543b3fcfb23ec60444c`. The adoption parent is unassigned.
`Function_6C_61AC` remains neutral and PROBABLE; `wRam_C0D9`/`wRam_C0DA`
remain neutral. Live entry and field purpose remain HYPOTHESIS. No alias,
entry proof, field-purpose promotion or animation policy is proposed.

## Whole block and ordinary static operation

The half-open span [6C:61AC,6C:61CB) contains 31 bytes:
`21dac035c03623fad9c0ee01ead9c0167882571e802120dacdd106650a00c9`.
It consists of a 24-byte instruction prefix, six-byte far-call encoding and
one RET byte. The prefix has twelve instruction starts, the CALL adds one
and the final RET one, for fourteen starts. The three inline bytes occupy
[61C7,61CA), encoding target word $0A65 and bank $00; they are data, not
three instructions. The RET is at 61CA, outside that inline-data interval.
The existing farcall spelling and every emitter remain unchanged.

Under stable physical ROM bank $6C mapping, ordinary uninterrupted/non-reentrant
flow, a valid nonaliasing return stack and an initialized intact HRAM
trampoline, the routine decrements WRAM0[$C0DA] modulo 256. It returns when
the decremented byte is nonzero. Entry zero becomes $FF and returns early;
only entry one reaches expiry, which reloads $23 (35). This corrects the
earlier imprecise "wraps" wording: wrap to $FF is not expiry. No frame
cadence, timer unit or live calling frequency has been established.

Expiry reads $C0D9, XORs $01 and stores the result. This toggles bit 0 and
preserves its other bits. The incoming byte is not proven boolean. It then
sets D=($78+new $C0D9) modulo 256, E=$80 and HL=$DA20. D would be $78/$79
only under a separately demonstrated 0/1 domain; that domain is not shown
for this entry. These are operations, not established field meanings.

## Far-call and WRAM bank qualification

The CALL at 6C:61C4 is `cd d1 06` followed by inline `65 0a 00`, invoking
ROM0 `Sprite_SetPosition` at 00:0A65. Once ordinary expiry flow reaches this
site the call is unconditional. The helper selects physical WRAM7 and writes
D and E to $DA20–$DA21. It restores SVBK using its saved `hWRAMBank` software
shadow. Preservation of an arbitrary physical entry bank is not shown:
the physical bank is restored only when its entry selector and shadow agree.

The far-call uses HRAM scratch/trampoline state and the stack; its common
return path can rewrite ROM-low selection from the saved shadow. Correct
ROM mapping/shadow, trampoline and stack assumptions are therefore material.
The helper's local AF behavior is not a universal property of the complete
routine/far-call. No universal A/F return value, flags-preservation or
arbitrary-bank-restoration claim is made. The independent supplemental
register/flag model has extra explicit preconditions and is kept as a bounded
static derivation, not adopted into this header or asserted as runtime evidence.

## Entry, corpus and unresolved purpose

The predecessor at 6C:61A9 ends in JP $601B and does not fall through 61AC.
The maintained symbolic census locates this neutral definition but no symbolic
caller/table operand. The whole-reference ROM searches for little-endian
word 61AC, CALL 61AC, JP 61AC and the bank 6C inline far-call pattern find zero
literal matches. These finite pattern results do not exclude computed,
indirect or external entry and do not prove global unreachability.

The bounded original corpus comprises 69 coverage files, 69 merged ROM data-
access files, 50 available callgraphs and a separately checked coverage union.
The 31-byte candidate has zero matching coverage/data/callgraph/union rows.
The shared far-call and sprite helpers execute elsewhere; their observations
do not prove this caller's entry, its policy or the meaning of its two bytes.
No forced replay, new runtime, visual or hardware observation was made.

`wHelpScript_DeferredTextSfx` is a CONFIRMED overlay at the same RAM address
in another documented scope. That scope explicitly excludes 61AC. Its name,
initializer and semantics are not evidence of this routine's purpose or of
a boolean input domain. Counter/state operation descriptions therefore remain
separate from hypotheses about blinking, timing, animation or deferred sound.

## Source scope and evidence provenance

Only existing comment rows 1000–1002 in `engine/help/help_script.asm` change;
the 1019-line count, neutral labels, RAM operands, farcall and all code/data
rows remain exact. The later far-call comment rows stay unchanged. Indexes
receive appendices and this note plus its verification companion are the only
new paths. This is a private preparation, not integration or adoption.

The original ROM reference SHA-256 is
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Executor evidence seal:
`750b10a99794e6b6ae7225d7bc484fddd7acd40d580a3709bce4eb584345b81d`.
Independent confrontation payload:
`a47e730ddd91cf29dbe17622939b0097da382283d0dcc53655c3994287728ad2`.
ROOT static full-six receipt: `240177e0804e84f048fb82cb902fe98c61db449f9b209c2d1a2c304e3251663e`.
The ROOT static full-six acceptance qualifies the independent A/F model as
non-universal and unsuitable for the source header. Full private evidence
files and bindings were checked by size/SHA; foreign producers were not run.

See [prepared verification](naming_6c_verify_61ac.md). Future parent and actual
37-command results remain null; no rebuilt-ROM equivalence is claimed here.


## Current private rebase and validation after RET and 55

The preceding text is the historical aa61 proposal and its corrected V2 note interval. This private implementation uses SOURCE4194 from the sealed private 55 candidate (manifest dcb0ccd8) as its private predecessor. The future published parent, independent/ROOT adoption, actual integration and publication remain NULL. Only full-comment rows 1000–1002 in help_script.asm change. Owner 1019 lines and 980 noncomment rows including blanks, all 348 ASM/inc noncomment vectors and line positions, metadata 289 and all 1248 TSVs remain exact. The 4191 old files outside scope5 preserve the RET aliases, the 55 header and all seven 2C4F comments. Two new notes give SOURCE4196.

Own original-ROM bytes confirm the counter address C0DA through 21 DA C0 and the unchanged operand wRam_C0DA. A prior ROOT message summarized CC0D; that transcription is contradicted by these bytes and is not adopted. Both historical proposal notes already use C0DA correctly. The 31 bytes partition into a 24-byte prefix, a three-byte CALL at 61C4, three inline target-data bytes [61C7,61CA), and RET at 61CA. Fourteen instruction starts exclude inline data. V1 used an ambiguous interval that V2 corrected; RET lies outside the inline interval. All 256 counter/state inputs confirm old 0 becoming FF and returning early, expiry only for old 1 with reload 35, bit 0 XOR 1 without a boolean domain, and D=(78hex+new C0D9) modulo 256. The helper selects WRAM7 and writes D/E to DA20/21; it restores SVBK from the software shadow. Coherent mapping/shadow, initialized HRAM trampoline, valid nonaliasing stack and uninterrupted, non-reentrant flow remain material preconditions. No universal A/F or arbitrary physical-bank restoration claim is made. Entry and purpose remain HYPOTHESIS and structure PROBABLE.

A single new private literal 37 pipeline completed 36 rc0 outcomes plus ordinal 27 rc2 with the exact 97-byte historical schema diagnostic. Ordinal 1 was the only top-level make build. Whole original ROM comparison is IDENTICAL; make, sym-check and palette-check succeeded. All 671 raw outputs, SYM 15538 labels/51 constants and MAP are byte-identical to the guarded private 55 outputs. No alias was added or removed. All 334 raw D files and 10912 rules remain identical; 5623 current bindings rebind the changed help_script SHA. Parent BEFORE SOURCE4194 remains explicit and separate from current AFTER SOURCE4196. The completed RET37 and 5537 runs were not replayed. This run adds no natural entry evidence or hardware observation.

The 147 frozen .py source byte hashes, sizes and timestamps were preserved after candidate creation; zero source .pyc files were copied. Native/tool membership from the accepted historical method is data only; no new native or actual-owner capture was performed. Actual integration, fresh closure, independent/ROOT validation, clean publication and canonical DOC suffix rebasing remain separate future ROOT stages.
