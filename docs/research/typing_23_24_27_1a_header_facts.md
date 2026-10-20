# Fresh prepared header family on final bank26 DOC (aa61d89314329fccea3c4543b3fcfb23ec60444c)

The prior note prepared on 1004 is retained as history below. The fresh appendix defines this new private candidate.

## Historical preparation on 1004

# Bank 23, 24, 27 and 1A: factual header corrections (2026-10-08)

This prepared comment pass uses original1004 as a historical source snapshot. Adoption waits for the final bank26 publication, fresh OWN/rebase and independent review of all four owners. No emitting source, label, alias, operand, data literal or metadata locator changes.

At 23:6D61–6D8C, the 43 original bytes decode to 28 instructions. The ordinary loop selects WRAM7, starts HL=$D1E0 and B=$14, then stores A=$14 through $27 with one `ld [hli],a` per iteration. It writes 20 bytes through $D1F3, not $14 words. A literal RET precedes the span at 6D60. The neutral Function_23_6D61 stays HYPOTHESIS: a valid decode does not prove entry. This static reading assumes an uninterrupted normal context and a valid, nonaliasing stack; restoration uses the saved hWRAMBank shadow, without proving it matched the incoming hardware selector.

At 24:42E7–42F0, `82 AD 81 5B 82 AD 81 5B 00` is the NUL-terminated Shift-JIS text “くーくー”. The emitted `db` was already correct; the header's “ぐーぐー” is corrected. Its PROBABLE classification remains.

At 27:4EF5–4F0B, the 22 original bytes contain `ld a,$07; ldh [$FF4B],a`: 7 is written to rWX, not rOBP0/1 ($FF48/$FF49). The emitter already uses rWX. This window value is separate from the WRAM7 prologue at 4EC0. Function_27_4EC0 remains an unproven HYPOTHESIS entry, with its existing names/statuses preserved.

The explicit scouting extension at 1A:477E–47A4 contains six NUL-terminated strings in 38 bytes: “ＩＳＰ”, “ＰＤＣ”, “ＰＨＳ”, “Ｗｅｂ”, “ＷＷＷ”, “＠”. Their starts are 477E/4785/478C/4793/479A/47A1. The header's seven-string count, “ＩＤＳＰ” and “※” are corrected; all emitted strings and aliases were already correct. The header stays PROBABLE.

The existing 69 natural coverage files, 69 merged ROM data-access files, 50 available callgraphs and coverage union contain no matching rows in the three original target spans. Absence is not proof of impossibility. Merged data-access ranges do not establish instruction execution or temporal attribution. No forced scenario, emulator or hardware test was run. The 1A extension is supported by raw bytes, source and exact string boundaries; it does not promote execution or caller evidence.

The four source files retain their line counts and all noncomment rows, including blanks. All 348 tracked ASM/inc vectors, globals/local scopes and 289 metadata TSV bytes remain exact. Seven comment rows change in the order23→24→27→1A. The broader lexical scout is a finite candidate screen, not a claim that every other header is correct.


## Fresh private rebase on final bank26 documentation (aa61d89314329fccea3c4543b3fcfb23ec60444c)

The original preparation on 1004 above remains historical. A new direct OWN was sealed before the final bank26 DOC receipt. The 4,186 current tracked files yield 4,188 candidate source files with six existing modifications, two new notes and 4,180 unchanged outside files. All four source owners retain the exact bodies from 1004 before the same seven comment changes. Fresh document prefixes include the complete bank26 publication history. All 348 strict vectors retaining blanks and all 289 metadata files remain unchanged. No gate, current-parent compilation or publication result is claimed for this header pass; independent review of all four owners and a new ROOT protocol/approval remain required.


## WRAM7 ascending bytes and WRAM6 URL/title copies (2026-10-15)

`Wram7_Write14To27AtD1E0` and `Wram6_CopyGooUrlAndTitleToPageBuffers` are PROBABLE local-operation aliases for `Function_23_6D61` and `Function_24_42B0`, preserving those neutral definitions. Entry, natural caller and application purpose remain HYPOTHESIS. The first name deliberately avoids TileIds: no consumer is supplied to establish that meaning for its destination. The second uses independently documented bank6 URL/title fields, without claiming a default-page policy, a request to that URL or natural execution. Earlier no-alias/header preparations above remain historical.

The immutable original ROM has2097152 bytes and SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Both operations contain no CALL; source-bank mapping must remain stable throughout their own bodies and source reads. Original header C0/1B identifies the CGB-only/MBC5 target, not a new hardware test. CGB WRAM selection is via FF70/rSVBK and its software shadow FF8D/hWRAMBank; these are distinct from MBC ROM/SRAM-bank registers. Neither body changes the MBC ROM/SRAM selectors or VBK.

### 23:6D61 writes twenty bytes and restores by the saved shadow

Physical[08ED61,08ED8C) / CPU[23:6D61,6D8C) contains43 bytes/28 instruction starts, maintained in `engine/mail_server/delete_messages.asm:12..40` (local-label row26):

```text
f5c5d5e5e0f2f08df5f0f23e07e08de07021e0d13e140614
223c0520fbe0f2f1e08de070f0f2e1d1c1f1c9
```

It pushes AF/BC/DE/HL, stores incoming A in FFF2/hScratchA, reads FF8D/hWRAMBank and pushes that AF. It reloads the saved scratch A before overwriting A with7 and selecting WRAM7 in both shadow/rSVBK. It sets HL=D1E0 and A=B=14 (hexadecimal). The loop6D79 writes one byte through HL++, increments A and decrements B until B=0. Exactly20 stores write values14..27 to W7:D1E0..D1F3 inclusive; no words or graphics interpretation is inferred. Internal final A is28 and HL=D1F4 before restoration.

The epilogue stores28 into hScratchA, pops the saved shadow AF and writes its A to both hWRAMBank and rSVBK, reloads28 from scratch, then restores HL/DE/BC/AF and returns. Under normal stable nonaliasing execution all entry AF/BC/DE/HL are restored; no final flag value from the loop is promised because POP AF restores entry flags. FFF2 ends28, not its incoming value, and is used transiently for entry A. The locally known peak extra stack usage is ten saved bytes, plus the preexisting return word.

Only the software shadow was saved: the code never reads the incoming physical rSVBK. Physical prior-bank restoration follows only if the incoming hardware selector and shadow were coherent. The shadow is written before rSVBK on selection and restoration, so IRQ observers can see a transient mismatch. A stack in switchable WRAM must remain accessible under both mappings; arbitrary stacks, destination/scratch aliases, IRQ changes to the shadow/stack or bank changes during the loop invalidate the simple restoration contract. There is no DI/EI or synchronization here. A preceding RET6D60 prevents ordinary fall-through entry; a clean decode and the twenty writes do not establish purpose or caller.

### 24:42B0 copies exact strings into bank6 page fields

Physical[0902B0,0902D1) / CPU[24:42B0,42D1) contains33 bytes/18 instruction starts, maintained in `engine/browser/page_list.asm:343..362` (local-label rows348/356):

```text
3e06e08de0701100d521d1422a1213fe0020f9
11c0d321e7422a1213fe0020f9c9
```

The body selects WRAM6 through shadow/rSVBK and leaves it selected. It copies through each NUL, first ROM24:42D1..42E7 (22 bytes: ASCII `http://www.goo.ne.jp/` plus00) to W6:D500..D515, then ROM24:42E7..42F0 (9 bytes: `82 AD 81 5B 82 AD 81 5B 00`) to W6:D3C0..D3C8. The second is the existing encoded title, not a new translation. No count/bounds check is emitted: finite termination and these lengths follow from the verified immutable NUL-terminated source strings under stable ROM24 mapping. No larger destination tail is cleared.

The PageBuffers wording is supported independently of the candidate label. `ram/banked.asm:206,208` defines bank6 D3C0 as the22-byte page-list title field and D500 as the256-byte current-page URL. `PageList_SaveCurrentPage`24:4F14 (`engine/browser/page_list.asm:1997` onward) explicitly selects WRAM6, tests the URL's first byte, and copies URL/title fields to selected SRAM list slots; the existing drawing/title-bar and page-list consumers are documented in those definitions. This establishes the field roles, not a caller or use of42B0. The two candidate writes fit those declared capacities, leaving234 URL bytes and13 title bytes after their terminators unchanged. Full-buffer initialization, default-page intent and live use are not inferred.

On ordinary return A=0,F=C0 (Z1/N1/H0/C0) from the final CP0; DE=D3C9,HL=42F0,BC unchanged. There is no CALL/PUSH/POP, so the only explicit stack use is RET consuming the entry return word. AF/DE/HL are not preserved. Both shadow and physical selector finish6; neither the incoming physical bank nor its shadow is restored. No hScratchA store or explicit DI/EI occurs.

Valid fixed ROM24, writable bank6 destination ranges, a return stack whose mapping remains valid after selecting6, nonaliasing buffers/stack/shadow and no relevant IRQ/mapper interference are preconditions. Software shadow6 is written before hardware selection, creating a transient mismatch window. An interrupt can invalidate source/destination mapping or termination; no atomic-copy or IRQ-safe mapper protocol is established. The lone RET42AF and data42D1 onward are distinct boundaries. The alias occupies the old one-line mechanical comment while preserving the neutral label, source line count and every emitter.

These are static operation descriptions, without new natural/forced/dynamic, visual or hardware evidence. Existing source/RAM confidence remains qualified, and reconstruction equivalence requires later documented build, symbol check and byte comparison; it is not established by these source/byte observations alone.
