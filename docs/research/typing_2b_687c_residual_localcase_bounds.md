# Residual local cases at 2B:687C

This pass corrects seven inherited comments without changing names, evidence levels, emitted lines or physical line counts. Its published parent is `7986b2b7d825e0f87bb790cd16b8c5182f3db93b` (4,224 maintained files), after the settings-highlight pass. The owner is `engine/mail/mail_viewer_sender.asm`.

## Bounded mechanical evidence

Own original-ROM reencoding covers `[687C,691A)`: 158 bytes, 60 CPU instruction starts and four separate three-byte farcall operands (146 CPU bytes plus 12 inline bytes). The preceding `[6863,687C)` is twelve words (24 bytes) followed by RET687B, not an immediately preceding JR NZ into687C. The next entry, `MailView_DrawDateTime` at691A, is outside this returning family.

The internal JR NZ sites6880,68A8 and68D0 target68A6,68CE and68F6. With ordinary external-call returns and valid stack, mapping, sprite-slot and IRQ prerequisites, root C=0/1/2/other3..255 reaches RET68A5/68CD/68F5/6919 respectively. The physical case ranges are42/40/40/36 bytes. Direct local entry omits root PUSH BC and LD A,C; this is not an arbitrary-entry ABI. Entry and purpose remain HYPOTHESIS.

DE6810/6830/6850/6870 passed to00:0A65 supplies D/E coordinates, not a source-ROM pointer. DA10/DA20 are guarded literal DEF EQU sprite slots. The animation arguments DE78D0/7910/78E0/78F0, A=2B and B=81 reach00:0A82 through the separated inline farcall operands. These are bounded mechanical arguments; they do not establish a semantic purpose or new natural execution.

## Finite caller qualification and classification history

An exact-token scan of all343 maintained ASM and5 INC files, with comments removed, finds only the definition of `Function_2B_687C`. This inventory establishes no named caller; it does not exclude raw, literal, computed, indirect or interior entry, uncaptured execution, or callers outside that inventory. The lone RET687B's entry and purpose are unproved. Its comment must not reuse the global687C query as a branch inventory.

The three local comments now use the complete687C–691A boundary instead of the inherited687C–6909 prefix, and replace universal caller/pointer absence with the finite source qualification. Existing complete-family158-byte notes, the historical141-byte prefix and frozen metadata6909–69AD are retained. The mechanical boundary does not promote the historical classification or reinterpret its ownership. HYPOTHESIS, PROBABLE and CONFIRMED wording counts are unchanged in the owner.

## Provenance and preserved contradictions

Own raw, branches, source emitters and finite named references closed before ROOT recipeV3 was read. Previous full-family and header context was known; this was not a blind review. ROOT proposalV1 wrongly connected the global687C query to incoming branches ofRET687B; V2 corrects that wording. V1/V2 covered336 files; V3 and the own query cover348. Those proposals remain historical data. The initial own encoder expected WRAM aliases in exportedSYM and stopped with KeyError before creating evidence or changing source; guarded literal DEF EQU resolution fixed the query and reencoded the same bytes.

Private source proposals and ROOT recovered callgraph cache data remain separate. The historical published corpus here has69 coverage files,69 dataaccess files and50 natural callgraphs; absence of edges in that finite set is not unreachable. No recovered graph is added by this scope, and no missing graph or absence statement is promoted into caller completeness.

## Verification state

The preparation proves all noncomment lines and their physical positions in all348 maintained files unchanged, all metadata/tools/config/assets and historical notes unchanged, and whole-source equality outside the four-file scope. This is a static preservation result. No new build, canonical37, native/capture operation or source publication has run for this pass. The published parent's fresh build receipt is provenance for the parent only. A new private37 requires ROOT review of this frozen scope; independent review, ROOT adoption, actual integration and publication remain pending. Future results may be appended only after their own terminal closure, without replaying completed commands.


## Current private local-case validation

One newly authorized private canonical 37-command pipeline completed: 36 return codes 0 and the expected ordinal 27 return code 2 with the exact 97-byte historical schema diagnostic. Make reports SHA-256 OK; compare reports RESULT: IDENTICAL. All 671 output files match the published 7986 fresh parent in whole bytes, sizes and SHA-256, including the original ROM, SYM and MAP. The symbol table retains 15,538 labels and 51 constants. D334 retains 10,912 raw rules and 5,623 bindings; current source/dependency hashes rebind only engine/mail/mail_viewer_sender.asm, with explicit published SOURCE4224 BEFORE and tested SOURCE4225 AFTER phases. All 4,225 frozen source guards, two original references and the six resolved executable guards held before and after every command. This is an executable inventory, not a full native/library closure or new native capture. Whole logs and diagnostic/warning lines are preserved; success is not described as warning-free.

These three documentation result appends follow the completed terminal and output measurements; no command is replayed and all 671 outputs remain unchanged. The seven ASM comment changes retain all emitted lines, physical positions, labels and evidence levels. Independent verification, ROOT adoption, actual integration and publication remain pending. No new natural-menu, graph capture, purpose proof or hardware evidence is claimed.


## ROOT local2B original integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,225 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed a programmatic whole-byte scan of all logs and exact diagnostic/hash checks; this is not a blind or human full-log-read claim. ResourceWarning diagnostics are retained in the receipts, not described as warning-free results.

This three-document result appendix was added after the successful checks; only documentation changes and the successful pipeline is not replayed. The single source owner retains all emitted lines, labels, levels and physical line counts. The complete family ends at691A; entry and purpose remain HYPOTHESIS, and no new natural-menu, visual or hardware evidence is claimed. Publication and fresh reconstruction are subsequent stages.
