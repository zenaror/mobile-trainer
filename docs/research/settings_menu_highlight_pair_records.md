# Settings menu highlight pair records

## Bounded mechanics and inherited levels

The table remains words/PROBABLE; 4A:5770–5810 remains data/CONFIRMED and 4A:5810–5838 remains data/PROBABLE.

At68:5270,01 0A 02 loads BC=$020A: two rows of ten columns. At5283,3E 4A loads the source bank; the farcall starts at5285 (CD D1 06), with EA 08 00 inline at5288–528B. RET is at528B. The old header's $050A and call site5283 were wrong. The five little-endian words are5770,5798,57C0,57E8,5810, stride$28. They address bank4A data; the old ptrtable→bank68-code contradiction remains explicitly recorded in the table header.

| word | source record | tile numbers | attributes |
|---|---|---|---|
|68:528C|4A:5770–5798|5770–5784|5784–5798|
|68:528E|4A:5798–57C0|5798–57AC|57AC–57C0|
|68:5290|4A:57C0–57E8|57C0–57D4|57D4–57E8|
|68:5292|4A:57E8–5810|57E8–57FC|57FC–5810|
|68:5294|4A:5810–5838|5810–5824|5824–5838|

Each record has20 tile numbers followed by20 attributes. Every attribute is$0A (palette2 and VRAM bank1, no flip or priority). It is five2×10 tile/attribute pairs, not ten tile-only rows. The helper copies B*C bytes twice while advancing sourceHL; the second destination isDE+$400 and each row advances32 cells. Its entry selects sourceROM banking and WRAM7. DrawItems offsets the destination by cursor×64 from wScreenTileMap+$C5 when the flag is zero, or+$A5 otherwise.

The maintained menu paths delimit ordinary cursor indices to0–3 or0–4, but DrawItems itself has no clamp, and the initial SRAM cursor can be unchecked. These copies assume valid cursor/state, mapped source, nonaliasing stack, stable bank/IRQ conditions and ordinary helper returns. No arbitrary-index safety, restored WRAM state, universal termination, new visual execution or hardware behavior is inferred.

The first own raw/control/data proof closed before the foreign English ROI report was read. The full41 source-emitter proof closed after that confrontation; known English ROI context is disclosed. Only the matching original-JP windows00:08EA–091C and68:526D–5296 and the five-record geometry were corroborated. No English donor bytes,4B result-page change, four-ROM whole claim or foreign executable is adopted. Entry/purpose beyond the maintained labels stays HYPOTHESIS where unproved.
