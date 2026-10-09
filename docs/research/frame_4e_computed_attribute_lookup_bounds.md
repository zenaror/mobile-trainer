# Bounded computed attribute lookup at 4E:6543

## Scope and provenance

This private candidate is based on published `fe5238f6112cc71b7c97abb4c05c6591a4912f54`, whose ROOT source-only clone verifies 4,245 Git blobs. The closed emitted-output proof remains the original `8eab941` fresh build; the archival/doc-only successor did not perform a new build. This candidate adds one focused note, appends the research index and RE log, and substitutes one existing comment at physical line 485 of `engine/browser/frame_graphics.asm`. The owner remains 571 physical lines. It changes no instructions, data directives, labels, aliases or evidence levels. Integration, new private checks and publication are pending ROOT review.

The producer knew the maintained headers, previous frame-model research and the supplied locators before deriving the raw bytes. This is not a blind discovery claim. Own raw packet c074240f was closed before the new ROOT recipe was read; the subsequent V2 confrontation bbfd6cdf independently evaluates all 256 input attributes and records all 69 historical dataaccess guards. The old sealed packets remain unchanged.

## Static mechanical facts

The ROM interval 4E:[6543,654B) contains exactly eight bytes:

```
08 08 0D 0E 0F 08 08 08
```

It follows the RET at 4E:6542 and precedes the separate descriptor pointer table at 654B. At 4E:[6486,649D), the 23-byte loop loads an attribute, masks its low three bits, adds the 8-bit immediate $43, then forms the high address byte with $00 plus ADC $65. Thus DE becomes `$6543 + (old_attribute & $07)`. It reads `[DE]` and writes `(old_attribute & $E0) | table[old_attribute & $07]`. The mask bounds this local reader to the eight bytes. It is a computed reference; no literal 16-bit $6543 operand is required.

All 256 arithmetic cases give palette indices `0,0,5,6,7,0,0,0` for the eight old low-bit indices. The result sets attribute bit 3 (VRAM bank 1), clears bit 4, and preserves bits 5, 6 and 7. The preceding independent loop at 4E:[6477,6480) ORs $80 into each of $0400 map bytes. These are conditional static mechanics, not a rendered-image, palette-identity or PPU observation.

The mapping requires ROM bank 4E at the local read, valid WRAM7 screen buffers, ordinary farcall returns, valid stack and the surrounding helper/IRQ discipline. The bounded source and home-bank switching/farcall helpers support that prerequisite; arbitrary interior entry, disrupted returns or asynchronous bank changes are not proved safe. Purpose and entry qualifications are retained. Descriptor selection, other frame headers, PNG classifications and names are outside this correction.

## Correction and limits

The inherited comment mixed the physical eight-byte observation with an older ten-byte UNCLASSIFIED hint and the absence of code word/immediate references. The new comment records the computed reader and the physical extent while retaining HYPOTHESIS. A bounded absence of a literal 16-bit $6543 operand may still be true: the computed ADD $43 / ADC $65 reference does not refute that narrower statement. ROOT's earlier broad no-reference interpretation was withdrawn in recipe V2 before any source edit or gate. Historical mapper/config classification rows are preserved, not silently rewritten.

The own raw body [6291,6543) has 690 bytes: 615 CPU bytes at 346 starts and 75 bytes of separate farcall operands. This raw decoder is not a claim of whole-body source-emitter reencoding. Initial decoder failures on opcodes $1A and $12 were corrected before any facts or source output; truncated initial helper peeks were superseded by bounded complete helper reads. A later inspection guessed a nonexistent dataaccess locator and failed before writing; the actual paths are `traces/detail/<scenario>/dataaccess.tsv`. These negatives remain in the private provenance.

Within the guarded 69 historical natural coverage aggregates, no decoded start in that body is covered. Within the same 69 merged dataaccess aggregates, no ROM READ range intersects 4E:[6543,654B). These are finite corpus results; they do not establish universal absence, unreachable code, exhaustive direct/computed callers, per-call attribution or lack of future natural use. There is no new ROM execution, natural/forced capture, semantic alias, hardware proof, Pokemon-name association, frame/name bijection, or reachability proof for 47:68F0.

## Candidate preservation and pending validation

The four-path candidate has 4,246 source files. All 4,242 parent files outside the three existing edited paths retain whole bytes; all 348 ASM/INC significant lines and their physical positions are preserved. The 19 archived callgraphs, old 50 graphs, coverage/dataaccess, frozen metadata/config, assets and tools remain intact. The 671 artifacts from the closed `8eab941` fresh build are re-read and retain their guarded hashes; they are inherited evidence, not outputs built from this candidate. A new canonical private pipeline is not launched by this preparation. ROOT reviews the frozen payload and decides subsequent validation and integration.


## Current private computed lookup validation

One newly authorized private canonical 37-command pipeline completed: 36 return codes 0 and the expected ordinal 27 return code 2 with the exact 97-byte historical schema diagnostic. Make reports SHA-256 OK; compare reports RESULT: IDENTICAL. All 671 output files equal the original 8eab fresh parent in whole bytes, sizes and SHA-256, including ROM, SYM and MAP. The source-only archival successor fe5238f carried that closed output proof; it did not build a new ROM. Symbols retain 15,538 labels and 51 constants. D334 retains 10,912 raw rules and 5,623 bindings; current source/dependency hashes rebind only engine/browser/frame_graphics.asm, with explicit published SOURCE4245 BEFORE and tested SOURCE4246 AFTER phases. All 4,246 frozen source guards, two original references and the six resolved executable guards held before and after every command. This is an executable inventory, not a full native/library closure or new native capture. Whole logs and diagnostic/warning lines are preserved; success is not described as warning-free.

These three documentation result appends follow the completed terminal and output measurements; no command is replayed and all 671 outputs remain unchanged. The one existing ASM comment retains 571 LOC, every significant source position, labels and evidence levels. Literal 16-bit operand absence is not refuted by the computed 8-bit address construction. The corpus 69 result remains finite and the arithmetic cases remain static. Independent verification, ROOT adoption, actual integration and publication remain pending; no new natural/forced, PNG/name mapping, purpose or hardware proof is claimed.


## ROOT computed frame lookup integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,246 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed programmatic whole-byte log scans and exact diagnostic/hash checks, without claiming blind review or human full-log reading. ResourceWarning diagnostics remain preserved.

The independent reviewer preserved an initial ordinal1 protocol failure: its child return code was not persisted before an overly strict modification-time check rejected 18 byte-identical regenerated binaries. A corrected V2 runner persisted return codes before post-command guards and treated modification times as observations. The authorized V2 repeated ordinal1 to recover that unvalidated check; ordinals2–37 ran for the first time. Its completed profile is 36 zero codes plus ordinal27 code2/exact97. This is not a global no-replay or unique37 claim; source bytes, sizes, modes and link counts, two references and six executable guards held. The original incident remains part of the evidence.

Three documentation appendices follow the successful ROOT checks without replay. The sole ASM edit is the existing physical line485 comment in the 571-line owner; instructions, data, labels and levels are preserved. A computed ADD $43 / ADC $65 reader does not refute the narrower absence of a literal 16-bit $6543 operand. Arithmetic256 cases and natural69 zero observations remain finite static/corpus results; reader purpose, names/frame association, unobserved entry, natural rendering and hardware remain unproved. Publication and fresh reconstruction follow.
