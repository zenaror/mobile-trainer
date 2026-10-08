# Neutral static contracts at 2D:4E42 and 2D:4E54

The labels `Function_2D_4E42` and `Function_2D_4E54` remain neutral. Their scan and local stack contracts are **PROBABLE static** interpretations of the original bytes. Runtime entry, valid input domain, purpose, and the intent of the early return remain **HYPOTHESIS**. This note proposes no repaired instruction, semantic alias or translation.

## Boundaries and entry evidence

The historical source baseline is `aa61d89314329fccea3c4543b3fcfb23ec60444c`. `engine/mail/body_editor.asm` has SHA-256 `39dff311f1e219f59ceb8a001b4f35f7a96bc39a80e777a48fe74b72f0b56a6d` before the four comment replacements. Original bytes, source labels and SYM agree on these boundaries:

| Original span | Bytes | Instruction starts |
| --- | ---: | ---: |
| `[2D:4E42,4E54)` | 18 | 11 |
| `[2D:4E54,4E8C)` | 56 | 38 |
| Combined `[2D:4E42,4E8C)` | 74 | 49 |

The preceding routine ends at `4E41 RET`; the wrapper ends at `4E53 RET`. The helper has `RET` at `4E72` and `4E8B`; `4E8C` starts the next labeled function. There are no inline fields, gaps or overlaps inside this bound. The decoded `2D:4E49 CALL 4E54` is a real local static reference, but does not establish natural execution of either entry.

The full-ROM bounded scan found 555 raw little-endian word candidates, 31 opcode-like absolute operands and zero recognized bank-2D inline far triples. Only two absolute candidates were in bank2D or ROM0: the real call at `4E49`, and bytes `DA 4F 4E` at `2D:60C2`. The latter belongs to `Tilemap_MailBody` graphics data, not proved code. Seven bank-2D relative candidates are decoded internal branches. Other banks' matching words are not bank-2D callers. These scans do not exhaust computed tables, RAM-created control or stack transfers, and cannot establish global unreachability.

## Scan and ordinary return

The helper saves original BC at `4E54 PUSH BC`, initializes HL to `wEditBodyBuf` (`$D400`), and uses B/C as zero-based row/cell requests under the static interpretation. INC followed by DEC means request `$FF` still traverses 255 units; wrap does not turn it into request zero.

Each prior row reads only the first byte of each two-byte cell (`LD A,[HLI]` then `INC HL`). `$0D` ends that row after consuming the cell. D begins at `$0C`; width exhaustion starts another row. **Twelve is the cell width of each prior row, not a limit of twelve rows.** The `$00` comparison follows `DEC D / JR Z`: NUL in cell12 takes the width branch and bypasses the early-return path. NUL in cells1..11 can take that path. The second byte has no LF or encoding check.

For the selected row, C controls advancement by two. `$0D` stops at its cell; `$00` advances and then backs up by two to its own cell. Requested-offset exhaustion selects the current address without prechecking its byte. This phase has no 12-cell bound. At `4E85..4E8B`, E becomes original C minus remaining C, A becomes `[HL]`, and `POP BC / RET` restores original BC and consumes the real caller return. Thus the **ordinary path** yields position HL, first byte A, offset E and preserved input BC. D has no uniform output/preservation contract.

The final F comes from `SUB C`, not from returned A: Z means offset zero, N=1, H is low-nibble subtraction borrow, and C=0 for this unsigned static scan. These are local contracts assuming normal execution with no intervening stack or bank-state alteration. No proved caller supplies an input register/flag contract.

`wEditBodyBuf` is a bank1 WRAM label at `$D400` with size `$C0`. The code enforces neither the resulting eight-row storage bound nor a selected-row width. A hypothetical all-width input B=C=`$FF` reaches `$D400 + 255*24 + 255*2 = $EDE6`, beyond WRAMX. This conditional calculation is not an executed observation or a valid-input-domain assertion.

## Early RET consumes saved BC

On the NUL path at `4E6B..4E72`, the code loads A=`$FF`, E=`$FF`, HL=`$FFFF`, then executes `RET` **without undoing `PUSH BC4E54`**. Let S be SP on helper entry, with its caller return at `[S,S+1]`. PUSH stores original C/B at `[S-2,S-1]`. Early `RET4E72` consumes that saved word: **PC=original entry BC, SP=S**, while the real caller return remains unconsumed at S. The target is saved input BC, not the live decremented BC.

For the wrapper's local call, the unconsumed return is `4E4C`, followed by the wrapper's own saved BC and caller return. The ordinary wrapper continuation is not reached by a balanced helper return on this path. A/E/HL=`FF/FF/FFFF` are values immediately before this transfer, not guaranteed sentinel results returned to the caller. CP0 leaves local F=`$C0` before the transfer.

The common path instead executes `4E8A POP BC; 4E8B RET`, so it restores the save and consumes the actual return. The early path's stack effect is a mechanical static fact under an ordinary CALL-entry stack. Whether it is an unintended bug, an intentional computed transfer, or an artifact of an unknown entry domain is **HYPOTHESIS**. No intentional recovery, runtime failure or repair is asserted.

## WRAM and RAM gate

The wrapper writes 1 to `hWRAMBank=$FF8D` and `rSVBK=$FF70`. After an ordinary helper return, it saves AF, writes zero to `rRAMG=$0000`, then restores that AF and input BC. It leaves WRAM1 selected and does not restore a prior WRAM bank. The RAM-gate write does not update `hSRAMEnable=$FFF5`; a previously enabled shadow can therefore remain stale. No ROM bank switch or SRAM enable/bank restoration is provided here.

Direct helper entry does not select WRAM1; reads at D400 use the mapped bank. ROMX execution requires bank2D. No far caller was established. A hypothetical ordinary FarCall cleanup can overwrite local F through its bank-switch trampoline; local flags are not a proved far-caller contract. Early RET does not prove normal FarCall cleanup is reached.

## Finite natural evidence and provenance

The sealed historical canonical set has 189 inputs: 69 coverage, 69 dataaccess, 50 callgraphs and one coverage union. It contains zero target instruction-start coverage rows, overlapping bank2D dataaccess rows or from/to callgraph rows in `[4E42,4E8C)`. Nearby executed routines do not establish these entries. Finite absence proves neither global unreachability nor any input domain, intended behavior or occurrence of the early RET.

The independent original-byte/source/natural analysis was sealed before opening the authorized foreign census. Its own seal SHA-256 is `c3b45fed8d51056b2ff09ab3e0cb0ce0da93101e933683f3c07fe918ce682168`; report SHA-256 is `01c64e5f10b7ed80aa4c30b30e4274f5de315e66764ce86560d717fc48b93573`. The subsequent confrontation seal is `3f516394aca2c6617dfeda03153c1f84312552da2b90fe9975fa0fd7e5306daf`, with report `8d95c6207a66f0f83daf8d383f00fd6409bc720417c62695fd048ed59fb14398`. Full foreign JSON SHA-256 `74bb05797e99facb3e35dc5a3163306453302b52c7646d9967dcf44f95b63b3c` was compared only at priority5; raw bytes, source and bounded natural results agree. ROOT receipt `90db93d1fb6e22e5cfeabd67e09fbff4112ed72401170fefe33a2cb2204656ba` records foreign-before-RAW chronology and makes no independent-before-foreign claim.

The sealed own report's earlier heading “stack defect” is restricted by its confrontation addendum to failure of an ordinary-return stack contract; it is not proof of original intent or an observed bug. The public description above uses the explicit stack effect.

Future parent, owner materialization and gates remain NULL. This is a private historical comment/document proposal, with no actual source build, translation or ROM-equivalence claim. See [the verification note](typing_2d_verify_4e42_4e54_stack_scan.md).


## Current private implementation after RET, 55, 6C and 7C

The preceding aa61 proposal is historical. This private implementation uses the guarded 7C SOURCE4198 candidate (manifest 37ed7e6f) as its private predecessor; the published parent, ROOT/independent adoption, actual integration and publication remain NULL. Scope5 replaces only comment rows 1004–1007 in body_editor.asm and appends the two index suffixes plus two new notes. Four comments were shortened within 100 columns. Owner 3119 lines, 2801 noncomment rows including blanks and 2617 significant rows stay exact. All 348 ASM/inc noncomment vectors and line counts, all 1248 TSVs including 289 metadata files, and the 4195 old files outside scope remain exact. All prior RET/55/6C/7C/2C4F source changes are preserved. Two notes give SOURCE4200.

Own original-ROM decoding was sealed before reading proposal facts: 74 bytes and 49 starts, comprising wrapper 18 bytes/11 starts and helper 56 bytes/38 starts, with no inline bytes. The seven internal branches and local CALL4E49→4E54 agree with the independent full decode. On early NUL, RET4E72 consumes the saved entry BC as PC, restores SP only to helper-entry SP and leaves the real caller return on the stack. For the wrapper call that return is 4E4C. A/E/HL=FF/FF/FFFF are pre-transfer register values, not a normal sentinel return; intent and occurrence are unproved. The ordinary path uses POPBC4E8A/RET4E8B and restores input BC, returning A at HL and traversed offset E. Local F comes from SUBC, not the returned byte; hypothetical far-return flags require separate wrapper qualification.

The first phase counts twelve two-byte cells per prior row, not twelve rows. Width exhaustion precedes NUL comparison, so a NUL in cell12 bypasses the early RET; cells1..11 can reach it. The selected-cell phase has no twelve-cell or buffer bound. Pure unsigned arithmetic confirms FF means 255 requested units, not zero; no infinite numeric-loop claim is made. With no markers, B=C=FF can hypothetically reach EDE6 beyond WRAMX. Wrapper E08D/E070 selects WRAM1, not SRAM1; direct helper entry uses the currently mapped bank. Only after ordinary helper return does the wrapper write RAMG0000=0 while preserving local AF. FFF5 is not written and can remain stale. Previous WRAM/SRAM gate/bank state is not restored. Entry, input domain, purpose and early-RET intent remain HYPOTHESIS; scan mechanics remain PROBABLE static. Historical canonical 189 data have no observed scoped entry; missing callgraphs, computed entry and actual occurrence of the early transfer remain unresolved.

One new private literal 37 pipeline completed 36 rc0 plus ordinal 27 rc2 with the exact 97-byte historical schema diagnostic. Ordinal 1 was the only top-level make build; make/compare/sym-check/palette-check succeeded and whole ROM is IDENTICAL to the original reference. All 671 raw outputs, SYM 15538 labels/51 constants and MAP equal the guarded private 7C outputs. No aliases changed. Raw D334 and 10912 rules remain identical; 5623 current bindings rebind only body_editor.asm with parent BEFORE SOURCE4198 separate from current AFTER SOURCE4200. All 147 frozen .py source byte hashes/sizes/timestamps were preserved; no source .pyc was copied. Native/tool membership remains historical data, with no fresh native/actual-owner capture. No closed pipeline was replayed or foreign helper run.

These private checks provide byte verification without adding natural runtime, visual, hardware or English evidence, changing the abnormal stack path, or authorizing actual integration. The two new notes receive this documentation-only appendix after the pipeline; code and outputs remain unchanged. ROOT will bind the future actual parent, canonical DOC suffixes, fresh checks and publication separately.
