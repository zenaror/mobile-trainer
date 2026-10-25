# Fresh prepared header family on final bank26 DOC (aa61d89314329fccea3c4543b3fcfb23ec60444c)

### 23:6D61 writes twenty bytes and restores by the saved shadow

The epilogue stores28 into hScratchA, pops the saved shadow AF and writes its A to both hWRAMBank and rSVBK, reloads28 from scratch, then restores HL/DE/BC/AF and returns. Under normal stable nonaliasing execution all entry AF/BC/DE/HL are restored; no final flag value from the loop is promised because POP AF restores entry flags. FFF2 ends28, not its incoming value, and is used transiently for entry A. The locally known peak extra stack usage is ten saved bytes, plus the preexisting return word.

Only the software shadow was saved: the code never reads the incoming physical rSVBK. Physical prior-bank restoration follows only if the incoming hardware selector and shadow were coherent. The shadow is written before rSVBK on selection and restoration, so IRQ observers can see a transient mismatch. A stack in switchable WRAM must remain accessible under both mappings; arbitrary stacks, destination/scratch aliases, IRQ changes to the shadow/stack or bank changes during the loop invalidate the simple restoration contract. There is no DI/EI or synchronization here. A preceding RET6D60 prevents ordinary fall-through entry; a clean decode and the twenty writes do not establish purpose or caller.

### 24:42B0 copies exact strings into bank6 page fields

Physical[0902B0,0902D1) / CPU[24:42B0,42D1) contains33 bytes/18 instruction starts, maintained in `engine/browser/page_list.asm:343..362` (local-label rows348/356):

The body selects WRAM6 through shadow/rSVBK and leaves it selected. It copies through each NUL, first ROM24:42D1..42E7 (22 bytes: ASCII `http://www.goo.ne.jp/` plus00) to W6:D500..D515, then ROM24:42E7..42F0 (9 bytes: `82 AD 81 5B 82 AD 81 5B 00`) to W6:D3C0..D3C8. The second is the existing encoded title, not a new translation. No count/bounds check is emitted: finite termination and these lengths follow from the verified immutable NUL-terminated source strings under stable ROM24 mapping. No larger destination tail is cleared.

The PageBuffers wording is supported independently of the candidate label. `ram/banked.asm:206,208` defines bank6 D3C0 as the22-byte page-list title field and D500 as the256-byte current-page URL. `PageList_SaveCurrentPage`24:4F14 (`engine/browser/page_list.asm:1997` onward) explicitly selects WRAM6, tests the URL's first byte, and copies URL/title fields to selected SRAM list slots; the existing drawing/title-bar and page-list consumers are documented in those definitions. This establishes the field roles, not a caller or use of42B0. The two candidate writes fit those declared capacities, leaving234 URL bytes and13 title bytes after their terminators unchanged. Full-buffer initialization, default-page intent and live use are not inferred.

On ordinary return A=0,F=C0 (Z1/N1/H0/C0) from the final CP0; DE=D3C9,HL=42F0,BC unchanged. There is no CALL/PUSH/POP, so the only explicit stack use is RET consuming the entry return word. AF/DE/HL are not preserved. Both shadow and physical selector finish6; neither the incoming physical bank nor its shadow is restored. No hScratchA store or explicit DI/EI occurs.

Valid fixed ROM24, writable bank6 destination ranges, a return stack whose mapping remains valid after selecting6, nonaliasing buffers/stack/shadow and no relevant IRQ/mapper interference are preconditions. Software shadow6 is written before hardware selection, creating a transient mismatch window. An interrupt can invalidate source/destination mapping or termination; no atomic-copy or IRQ-safe mapper protocol is established. The lone RET42AF and data42D1 onward are distinct boundaries. The alias occupies the old one-line mechanical comment while preserving the neutral label, source line count and every emitter.

These are static operation descriptions, without new natural/forced/dynamic, visual or hardware evidence. Existing source/RAM confidence remains qualified, and reconstruction equivalence requires later documented build, symbol check and byte comparison; it is not established by these source/byte observations alone.
