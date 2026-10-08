# Bank 29 candidate library: header evidence limits (2026-10-07)

## Scope and confidence

This pass corrects 15 comment lines in `engine/gfx/unreferenced_palette_library.asm`, the 742-byte span `29:5090–5376` (end exclusive). All entries remain **HYPOTHESIS**. Its existing 18 global labels and aliases are retained. “Candidate library image” describes an interpretation; it does not establish live code, a caller, a copied image, or a relocated image.

The proposal is explicitly based on published original `7fb572c0c58a996d508d3b4bd5f91219a90bf13f`, after source bank 29 templates `28c26377039742d48ad0c9a5b0afab85857e0220` and its documentation follow-up. The older prepared library overlay on `0bb401b59b54e14b8d31b8109125ae4cfd6b461e` is historical. A new direct OWN captured all 4,180 tracked files and Git blobs, current filesystem modes, raw Git/ref bindings, ROM/SYM, layout, 343 ASM / 348 ASM-inc sources, 289 analysis/gfx TSVs and the existing 188 natural files before the updated independent analytical packet was opened. Prior analysis and brief OMM state were known context, not substitutes for this capture.

## Raw facts and the former absence claim

The original ROM SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The span SHA-256 is `92fabb0487abb43cc457e93e73fd823bc6b5707f8d87ec3d310ddaf26575b33e`. A consecutive SM83 length walk, conditional on treating these bytes as instructions, yields 460 starts. It has 81 immediate CALL/JP/JR transfers: 79 target starts inside the span; two leave it, `CALL $044B` at `29:50C7` and `CALL $7BB7` at `29:5120`. `$044B` is in ROM0. Therefore “self-contained” overstates the literal control-transfer structure.

Scanning overlapping little-endian pairs outside the span finds 4,001 raw matches to those start addresses. Preceding CALL/JP opcode bytes produce 189 raw opcode-plus-target patterns, none in physical bank 29. These counts contradict the former literal claim that no outside word/CALL/JP match exists. They do not classify the bytes as instructions, pointers or callers, and do not establish the selected ROMX bank. No non-overlapping outside match was found for any of the 719 consecutive 24-byte windows. This is a bounded raw-window result, not proof of unique semantics or exhaustive absence of another implementation. No external noncomment reference to the 18 global names was found in the current 348 tracked ASM/inc files; indirect access remains unresolved.

## Fetch, memory and loop contracts

Physical `29:7BB7–8000` contains zero bytes. That observation applies to the literal physical bank, while the bank-selection writes at `29:510F` (`$2000/$3000`) can change later ROMX fetches. Entry, selected bank, copying and relocation are unestablished. The padding does not prove that every leaf is unable to execute in place, and a conditional decode does not establish a valid execution path through a bank switch.

The PRNG-like sequence at `29:50DA` reads `$0C0E/$0C0F` in ROM0 (reference bytes `CD 18`) and writes those cartridge-address locations. They are ROM/mapper space, not WRAM seed storage. Arithmetic resemblance does not establish a live PRNG or an intended mapper operation.

`29:520D` explicitly writes real SVBK=1 (`3E 01 E0 70`) before its banked buffer use. Standalone entries at `29:523F`, `529F`, `52ED` and `5335` have no local bank selection. Their `$DBD0` buffer interpretation requires an incoming bank contract that the existing evidence does not supply.

At `29:526D`, the BG loop loads B=$40 and writes zeros. The OBJ loop starts B=$00, reads `[DE]`, and uses DEC/JR NZ; under the intact conditional instruction interpretation, the counter wraps through 256 iterations. This is not a symmetric 64-byte zero clear. The incoming DE, selected WRAM bank and intended behavior remain unknown.

## Existing natural evidence and preserved history

All 69 natural coverage files have zero starts in this span; all 69 data-access files have zero ROM-read interval overlap; all 50 callgraphs have zero source or destination transfer in the span. The recomputed coverage union equals the current stored union: 78,005 distinct bank/address pairs, including 77,991 ROM pairs and 14 WRAM/HRAM pairs. These are results for the existing JP corpus. Merged data-access rows cannot establish a temporal reader. They do not prove universal absence of execution, reads, callers or use.

The source's historical forced-dead count, 187/460 starts, is retained as inherited history. The whole tracked-file inventory read, copied and hashed 43 forced artifacts (1,244,288 bytes) as opaque file bodies. No forced trace rows were analyzed or rerun for this proposal; they supply no new natural or full-path evidence. The body from line 22 onward, including legacy inline metadata and narrowly corpus-scoped notes, is preserved byte for byte. No body interpretation, global-name promotion, whole-bank closure, new emulator run, visual behavior, hardware result or English parity result is asserted.

## Static preservation and pending validation

The owner retains 559 lines, 517 nonblank/noncomment lines, all 18 global labels/aliases, and its exact comment-excluded vector including blank lines. The same vectors are unchanged across all 348 ASM/inc sources. All 289 TSV bodies, 649 active anchors selected by the current remapper defaults, and 1,947 raw historical source-locator occurrences are preserved; historical locators are not assertions of current active validity. Existing bank 28 and template29 publication notes remain intact.

This candidate has not been assembled or adopted. Required build, symbol, independent byte comparison and reviewed static checks remain pending, as recorded in [the verification note](typing_29_verify_palette_library_header.md). Prior published template or bank28 builds are not evidence for this new candidate.
