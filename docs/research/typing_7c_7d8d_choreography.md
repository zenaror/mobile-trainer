# Bank 7C:7D8D — static choreography and entry limits

Status: **PROBABLE static behavior; HYPOTHESIS entry and purpose**. This prepared original-ROM documentation records a private five-path proposal on historical original `aa61d89314329fccea3c4543b3fcfb23ec60444c`. Future parent/integration and validation gates are NULL. English is **UNVALIDATED**. No runtime experiment, hardware observation, semantic alias or byte change is proposed.

## Immutable bytes and exact scope

Original ROM SHA-256: `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, 2,097,152 bytes. ROMX file offset is `bank * $4000 + CPU address - $4000`. The neutral `Function_7C_7D8D` covers the decoded candidate `[7C:7D8D,7C:7DFC)`, file `[1F3D8D,1F3DFC)`: **111 bytes**, SHA-256 `b0a896184c0b314d47ee9b0854dee5601cd1af82f4a15f273eb6ceb3cfe7bb61`. Its partition is 39 CPU instruction starts, 84 instruction bytes and nine inline triples totaling 27 data bytes. These are directly checked byte facts; they do not prove a callable function or natural entry.

`7D8B: 3E 00` precedes the bound, and `7DFC: C3 57 7D` follows it. Neither is absorbed into the advertised 111-byte scope. The prior handler calls `67:626F` at `7D82`, then unconditionally jumps to `7D57` at `7D88`; its normal return cannot fall into `7D8B`. The last candidate instruction is `7DFA: 18 86`, a relative jump to **7D82**, followed eventually by the existing usage-fee handler's jump to the settings loop. There is no local RET or timeout in the bound. An independent entry at the prefix or trailing JP remains HYPOTHESIS.

## Calling and polling sequence

The initial far call at **7D8D passes incoming A unchanged** to `70:4000` (`CommScene_Init`). It does not establish A=0. The fixed first value 0 requires entry through the unproved `7D8B` prefix, or a separately proved caller supplying 0. The later initializations explicitly load 1 and 2. Init stores A at `$C27D`, clears `$C27C/$C27E/$C27F`, and subsequent state dispatch indexes an unchecked three-word kind table. Kinds 0/1/2 have supported tables; this is a static intended-domain inference, not an observed entry contract or range check.

Each phase calls `70:4023` (`CommScene_Step`) with A=0. Its returned A is compared with 2; equality skips directly to the next initialization or final jump. Otherwise `$FFA6` bit 0 is tested. A clear bit repeats Step(0); a set bit enters Step(1), repeating until returned A=0. Step(0)'s zero result is not tested as completion. Termination depends on callee/input behavior and is not proven. Timers inside callees do not make the 111-byte block a numeric counter.

| CALL site | Inline bytes | Target | Continuation |
|---|---|---|---|
| 7D8D | 00 40 70 | 70:4000, incoming A | 7D93 |
| 7D95 | 23 40 70 | 70:4023, A=0 | 7D9B |
| 7DA7 | 23 40 70 | 70:4023, A=1 | 7DAD |
| 7DB2 | 00 40 70 | 70:4000, A=1 | 7DB8 |
| 7DBA | 23 40 70 | 70:4023, A=0 | 7DC0 |
| 7DCC | 23 40 70 | 70:4023, A=1 | 7DD2 |
| 7DD7 | 00 40 70 | 70:4000, A=2 | 7DDD |
| 7DDF | 23 40 70 | 70:4023, A=0 | 7DE5 |
| 7DF1 | 23 40 70 | 70:4023, A=1 | 7DF7 |

The nine internal conditional branches are `7D9D→7DB0`, `7DA3→7D93`, `7DAE→7DA5`, `7DC2→7DD5`, `7DC8→7DB8`, `7DD3→7DCA`, `7DE7→7DFA`, `7DED→7DDD`, `7DF8→7DEF`. The final unconditional branch is `7DFA→7D82`.

## Registers, flags, banks and stack

The macro encodes `CALL 00:06D1; DW target; DB bank`. ROM0 FarCall consumes its return pointer to read the three data bytes, saves the adjusted continuation and region bank, calls the `$FFA8` trampoline, restores the bank, and jumps after the inline payload. It passes A/HL to the callee and returns the callee's A/HL values. That does not preserve unchanged caller A/HL. The wrapper itself leaves BC/DE alone, but Step's call tree supplies no general BC/DE/HL, WRAM/VRAM or interrupt-preservation guarantee. Incoming F is not tested in this block.

For these ROMX targets, coherent MBC5 bank-high 0, `$FF8A` bank shadow and initialized HRAM trampoline are preconditions. The inline bank is 70; normal continuation restores bank 7C. With normal synchronous execution and coherent saved state, `BankSwitch_H` clears C with OR A and tests bit 7 of H: callee H=$40 and restored caller H=$7D give **F=$A0 (Z1,N0,H1,C0)**. The wrapper does not preserve callee F. CP/OR/BIT in this block produce the flags its branches use. At the final jump, the result-2 shortcut carries A=2/F=$C0 from CP2; the Step(1) completion carries A=0/F=$80 from OR0. These are internal transfer states, not an external return signature.

Each ordinary far call is balanced: the adjusted return, saved region/bank and trampoline return are three two-byte stack items at callee entry relative to SP before CALL. Callee RET returns to `00:06FF`; wrapper cleanup restores the caller SP and continuation. The final JR does not create a return address. Eventual settings dispatch to `7D6F: RET` depends on the surrounding caller frame. Maximum full-call-tree stack depth is not derived.

## References and finite natural evidence

The six settings table words at `7D60..7D6B` are `7D6F,7D70,7D79,7D82,7DFF,7E08`; none enters the candidate or its adjacent fragments. `00:0545` indexes `2*A` and jumps via HL without a bounds check. Malformed indices are not demonstrated natural entry.

A whole-ROM raw census over target addresses `[7D8B,7DFF)` finds 542 word candidates, 50 opcode-like direct operands and zero `CD D1 06` / `CD 2E 07` inline references into bank 7C. Only one same-bank/ROM0 direct candidate exists: `7C:6A37 C2 90 7D`. The map and maintained font source put that address in the font INCBIN `[57CD,7B7C)`, so it is not a demonstrated instruction or caller. A relative-byte scan in navigation `[7B7C,7E11)` finds only the nine actual internal conditional branches into the bound. Source searches and exact bank/address triples do not establish a caller. Computed addressing, RAM control and return tricks are not exhaustively excluded.

All **189 existing natural inputs** were read and SHA-guarded: 69 coverage files, 69 dataaccess files, 50 callgraphs and `analysis/coverage_union.tsv`. There are zero instruction-start, overlapping ROM-data-read or from/to callgraph rows in `[7D8B,7DFF)`. Existing context is observed: union `7D82` has 35 hits/9 scenarios and `7D88` has 29 hits/8 scenarios. Elsewhere, union callee entries `70:4000` have 160 hits/18 scenarios and `70:4023` have 42,105/18; this does not prove entry to 7C:7D8D. Finite absence does not establish global unreachability, removed-feature identity or general unused code. No forced trace was mixed into this evidence.

## Provenance and decision

The independent proof was sealed before foreign review: complete report SHA-256 `f9ef0a90dcd24f3ff283c231cab70b9d5afb9af23e9dab6885bb6b3e22361979`. The separately prepared proof seal SHA-256 is `d4963d91d4324130e138195e21b2daa8777f326f625e39f631cdaf830ff919b5`; its full report SHA-256 is `878eb72c17d35dae0a47c82f7940623da42ccc2d1b4bc8a74e813877c3059035`. Authorized comparison read every sealed record, verified the private inputs, reproduced the complete raw census from the independently copied ROM, and found no material contradiction; comparison report SHA-256 `ed1a0f0792262927da5047828c7f8c2d0b2dc3e040c701c056038760b318b3a2`. The sources, ROM/SYM and all 189 natural guard hashes agree. These provenance identifiers supplement the portable byte/address facts above; they are not authority or future gate results.

Keep `Function_7C_7D8D` neutral. Choreography remains PROBABLE static, entry/purpose HYPOTHESIS. No alias, three-kind-from-0 claim, field-domain meaning, natural-entry claim, termination proof or confidence promotion is added. [Prepared representation checks](typing_7c_verify_7d8d_choreography.md) record the separate comment-only proposal and pending gates.


## Current private implementation after RET, 55 and 6C

The preceding historical aa61 proposal and its pending-stage language remain a separate record. This implementation uses the sealed private 6C SOURCE4196 (manifest def463fe) as its private predecessor. Future published parent, ROOT/independent adoption, actual integration and publication remain NULL. Exactly two comment rows 302–303 in navigation.asm were changed and shortened to 90 columns, preserving the same limited meaning and referring to the complete contract above. Owner 365 lines, 319 noncomment rows including blanks and 276 significant rows remain exact. All 348 ASM/inc noncomment vectors and line counts, all 1248 TSV bytes including 289 metadata files, and 4193 old files outside scope5 remain exact. RET aliases, 55 and 6C comments and the seven 2C4F comments are preserved. Two new notes give SOURCE4198.

Own original-ROM decoding confirms [7C:7D8D,7C:7DFC): 111 bytes = 84 CPU bytes + 27 inline-data bytes, with 39 instruction starts and nine farcalls. Each CALL has three inline data bytes; those bytes are not instruction starts. Final JR 7DFA targets 7D82; no RET or termination bound is present. Init receives incoming A at direct 7D8D entry; the first value 0 requires unproved entry through the 7D8B prefix. Later initializations explicitly supply 1 and 2. Step(0) checks result 2, otherwise FFA6 bit0; Step(1) loops until result 0. Nine conditional targets, all farcall targets/continuations, the six settings-table words and adjacent prefix/suffix bytes agree with the independent static record. Own whole-ROM census reproduces 542 word candidates, 50 opcode-like direct candidates and zero far references to the wider interval. The one same-bank candidate lies in font INCBIN and is not an established caller. Historical natural evidence is 69 coverage, 69 data-access, 50 available callgraphs and union; candidate rows remain zero within that finite corpus. Missing callgraphs and computed/indirect entry are not excluded. Confidence remains PROBABLE static and HYPOTHESIS entry/purpose. Coherent ROM mapping/shadow, initialized HRAM trampoline, valid stack and normal synchronous returns qualify the wrapper. Callee state/interrupt/bank preservation is not claimed globally.

A new private literal 37 pipeline ran once: 36 rc0 outcomes plus ordinal 27 rc2 with the exact 97-byte historical diagnostic. Ordinal 1 was the only top-level make build. Whole output ROM equals the original reference; make, compare, sym-check and palette-check succeeded. All 671 raw outputs, whole SYM with 15538 labels/51 constants and MAP equal the guarded private 6C output envelope. No alias changed. Raw D334 and 10912 rules remain identical; 5623 current bindings include the changed navigation SHA with parent BEFORE SOURCE4196 separate from current AFTER SOURCE4198. No prior private pipeline was replayed. The 147 frozen .py source hashes/sizes/timestamps were preserved; no source .pyc was copied. Native/tool closure is historical data only, with no new native capture.

These results add no natural entry, visual, hardware or English evidence and supply no integration authority. The two notes receive this documentation-only appendix after the pipeline; code and outputs stay unchanged. ROOT handles eventual source integration, canonical DOC suffix rebasing, fresh checks and publication.
