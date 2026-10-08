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
