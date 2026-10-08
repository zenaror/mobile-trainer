# Verification record for the neutral 2D scan and stack comments

This record describes a private proposal against historical JP `aa61d89314329fccea3c4543b3fcfb23ec60444c`; it does not report an actual integration or build. The names remain `Function_2D_4E42` and `Function_2D_4E54`, with no alias or emitted-byte edit. Scan contracts are PROBABLE static; natural entry, purpose, valid input domain and early-RET intent remain HYPOTHESIS.

## Original evidence

| Payload | Bytes | SHA-256 |
| --- | ---: | --- |
| Original ROM | 2097152 | `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` |
| Historical original SYM | 478702 | `5c83bce54096e2cd16f204e6a81e837146ee87f1ea315e47d2c7c880803c1ec6` |
| Historical body_editor source | 62929 | `39dff311f1e219f59ceb8a001b4f35f7a96bc39a80e777a48fe74b72f0b56a6d` |
| `[2D:4E42,4E8C)` | 74 | `36f3b7d11ef1c2be1e5df127efb8260753cf8b968224733e490d24839b0eaa29` |
| Wrapper `[4E42,4E54)` | 18 | `7f8ce069690662ec39e211f3b1222401443fb2f839252c6bd1518b1cf33a8e7a` |
| Helper `[4E54,4E8C)` | 56 | `ae51694ab19d42ab5d4abf49558b3d99a92d0b6eb9d81870f3e5517e4cd9d783` |

The complete portable 74-byte witness, in original order, is:

```text
c53e01e08de070cd544ef5afea0000f1c1c9c52100d404052817160c2a23fe0d28f51528f2fe0020f33eff1eff21ffffc9590c0d280d7efe0d28082323fe0020f22b2b7b914f7e59c1c9
```

The independent decode has 49 starts (11 wrapper and 38 helper), no inline fields and no overlap. Important locations are `4E49 CALL4E54`, `4E54 PUSH BC`, `4E64 DEC D`, `4E65 JR Z4E59`, `4E67 CP0`, `4E72 RET`, `4E8A POP BC` and `4E8B RET`. This establishes NUL-test ordering after width exhaustion, and distinguishes the unbalanced early transfer from the common return. Saved BC becomes PC; SP becomes helper-entry SP and the caller return remains unconsumed. Intent is not inferred from the mechanical stack witness.

The own seal/report and later comparison provenance are given in [the facts note](typing_2d_4e42_4e54_stack_scan.md). Whole source/ROM/SYM and all 189 natural input hashes were sealed before the foreign read and remained unchanged afterward. Natural input-guard SHA-256 is `43e06dc7633acd238cea328bdf428a0fb9b0d9a8700fcb015fd0c1fb4caed7f2`. These inputs are historical and finite, not a current runtime claim.

## Finite natural result

| Input class | Files | Target rows | Context rows `[4E2D,4EC0)` |
| --- | ---: | ---: | ---: |
| Coverage | 69 | 0 | 418 |
| Dataaccess | 69 | 0 | 0 |
| Callgraph | 50 | 0 | 40 |
| Coverage union | 1 | 0 | 43 |

Context union entry `4E2D` has 40 hits/11 scenarios; its preceding `4E41 RET` likewise has 40/11. Next entry `4E8C` has 2186/10. Those observations do not prove scoped entry. No unrelated private sample or trace path is reproduced here. No forced runtime experiment was run.

## Nonemitting proposal checks

Exactly four existing comment lines after `Function_2D_4E42` are replaced. Their positions and the total ASM line count remain fixed. Every instruction, operand, label/alias, blank position and noncomment line stays byte-identical. The same complete nonemitting vectors are checked before and after, with comment-only lines represented as empty lines. The wrapper/helper boundaries remain original source addresses, not newly rebuilt symbol results.

The two existing documentation files retain their complete historical byte prefixes and gain only appended entries. Two research notes are new. The isolated historical source count is 4186 plus these two notes, yielding 4188; this arithmetic does not assert a future owner count or parent. Their documentation bases were previously derived from the sealed aa61 historical candidate by removing only its sealed unrelated append: RE base SHA-256 `5f8ec51d6f7ce4d4df1f6d1d86e499579f5acb382ee09a1be0c7564540d085df`, docs index base `21b8ca83c7509451a0a6ecb5568e295eee7d35ade4344e2cb995733e00e6ed99`.

No helper import, current-owner read, gate, actual build, Git operation, OMM mutation or HOME access was performed for this proposal. Future parent, owner materialization and gates are NULL; English translation is UNVALIDATED. Static nonemitting equality is not a rebuilt-ROM comparison. Any later actual integration requires an explicit fresh parent and the repository's build and symbol checks; no such result is claimed here.


## Current private implementation after RET, 55, 6C and 7C

The preceding aa61 proposal is historical. This private implementation uses the guarded 7C SOURCE4198 candidate (manifest 37ed7e6f) as its private predecessor; the published parent, ROOT/independent adoption, actual integration and publication remain NULL. Scope5 replaces only comment rows 1004–1007 in body_editor.asm and appends the two index suffixes plus two new notes. Four comments were shortened within 100 columns. Owner 3119 lines, 2801 noncomment rows including blanks and 2617 significant rows stay exact. All 348 ASM/inc noncomment vectors and line counts, all 1248 TSVs including 289 metadata files, and the 4195 old files outside scope remain exact. All prior RET/55/6C/7C/2C4F source changes are preserved. Two notes give SOURCE4200.

Own original-ROM decoding was sealed before reading proposal facts: 74 bytes and 49 starts, comprising wrapper 18 bytes/11 starts and helper 56 bytes/38 starts, with no inline bytes. The seven internal branches and local CALL4E49→4E54 agree with the independent full decode. On early NUL, RET4E72 consumes the saved entry BC as PC, restores SP only to helper-entry SP and leaves the real caller return on the stack. For the wrapper call that return is 4E4C. A/E/HL=FF/FF/FFFF are pre-transfer register values, not a normal sentinel return; intent and occurrence are unproved. The ordinary path uses POPBC4E8A/RET4E8B and restores input BC, returning A at HL and traversed offset E. Local F comes from SUBC, not the returned byte; hypothetical far-return flags require separate wrapper qualification.

The first phase counts twelve two-byte cells per prior row, not twelve rows. Width exhaustion precedes NUL comparison, so a NUL in cell12 bypasses the early RET; cells1..11 can reach it. The selected-cell phase has no twelve-cell or buffer bound. Pure unsigned arithmetic confirms FF means 255 requested units, not zero; no infinite numeric-loop claim is made. With no markers, B=C=FF can hypothetically reach EDE6 beyond WRAMX. Wrapper E08D/E070 selects WRAM1, not SRAM1; direct helper entry uses the currently mapped bank. Only after ordinary helper return does the wrapper write RAMG0000=0 while preserving local AF. FFF5 is not written and can remain stale. Previous WRAM/SRAM gate/bank state is not restored. Entry, input domain, purpose and early-RET intent remain HYPOTHESIS; scan mechanics remain PROBABLE static. Historical canonical 189 data have no observed scoped entry; missing callgraphs, computed entry and actual occurrence of the early transfer remain unresolved.

One new private literal 37 pipeline completed 36 rc0 plus ordinal 27 rc2 with the exact 97-byte historical schema diagnostic. Ordinal 1 was the only top-level make build; make/compare/sym-check/palette-check succeeded and whole ROM is IDENTICAL to the original reference. All 671 raw outputs, SYM 15538 labels/51 constants and MAP equal the guarded private 7C outputs. No aliases changed. Raw D334 and 10912 rules remain identical; 5623 current bindings rebind only body_editor.asm with parent BEFORE SOURCE4198 separate from current AFTER SOURCE4200. All 147 frozen .py source byte hashes/sizes/timestamps were preserved; no source .pyc was copied. Native/tool membership remains historical data, with no fresh native/actual-owner capture. No closed pipeline was replayed or foreign helper run.

These private checks provide byte verification without adding natural runtime, visual, hardware or English evidence, changing the abnormal stack path, or authorizing actual integration. The two new notes receive this documentation-only appendix after the pipeline; code and outputs remain unchanged. ROOT will bind the future actual parent, canonical DOC suffixes, fresh checks and publication separately.


## Original bank2D integration verified (2026-10-08)

Four existing comments qualify the74-byte/49-start wrapper and helper at2D:4E42/4E54. Under the conventional stack interpretation, the early RET at4E72 consumes saved BC as PC rather than the real return address; it lacks the balancing POP BC. This behavior is preserved. The12-cell bound applies to the width before the NUL case; the selected scan phase has separate bounds and the FF counter represents255 units. WRAM1 selection and mapper disable on ordinary wrapper return do not establish a universal bank/ABI contract. Entry and purpose remain HYPOTHESIS. All emitted rows, neutral labels and metadata locators stay unchanged. Executor, independent reviewer and ROOT each completed one canonical37:36rc0 plus expected ordinal27 rc2/exact97-byte schema diagnostic. Actual make reports SHA-256 OK/RESULT: IDENTICAL; symbols/palettes pass and all671 outputs match the accepted private implementation. Fresh publication checks follow.
