# Original-ROM closure follow-up — 2026-10-21

This is a current-source checkpoint, not a claim that the Japanese ROM is
semantically complete. The original ROM remains byte-identical after the
changes below. English work remains paused pending explicit Operator
confirmation.

## Reviewed entry candidates

Independent review accepted the bounded static reports for 2B:6CF5,
6C:61AC, 29:5090–5376, 2D:4E42/4E54 and 55:5DF5/6EEC. These reviews verify
the cited local mechanics and the limits of each report; they do not prove a
natural entry, original intent, or universal absence of callers. The bank29
path/prefix recommendation is separate from its entry conclusion. Its
historical `50 graphs / 19 missing / 189 opcode patterns` counts were
reconciled against the current 69 coverage/dataaccess/callgraph files and the
expanded 323-pattern scan before the owner was renamed. The current source
header reflects the finite current corpus; neither count proves universal
non-use.

## Current naming changes

In `audio/music/music_07.asm`, 17 `Data_04_*` globals were removed where each
was an exact-address alias immediately under a retained `SoundSong07_*`
label. Independent review found no source/tool/metadata consumer, no affected
local scope, and confirmed all 776 audio directives remain unchanged. This
retires redundant labels only; it does not alter stream interpretation or
confidence.

`Data_55_6EF7` is now `Table_Kbd_Type6To10Flag_ByType`. The `Kbd_Type6To10Flag`
reader indexes eleven bytes for A=0..10 and returns 0 for 0..5 or 1 for 6..10.
The storage name is **PROBABLE** and describes that bounded table relation;
the routine does not check A, and values above 10 read beyond the table.
Natural traces read none of the eleven bytes. The entry and original purpose
of 55:5DF5 remain **HYPOTHESIS**. Historical naming notes retain the earlier
neutral-name decision as provenance; this paragraph records the current
superseding source state.

The bank29 owner formerly called
`engine/gfx/unreferenced_palette_library.asm` is now
`engine/gfx/palette_library_candidate.asm`; its eight operation names use the
`PalLibCandidate_*` prefix. The name change removes an unsupported global
non-use implication while preserving each bounded operation suffix. The
existing 36 calls and self-loop are internal to the owner; no external source
caller or root entry is established. Local-label qualification changed with
the global names, and the generated SYM check validates current addresses.
The candidate entry, selected bank and intended role remain HYPOTHESIS.

## Broader name audit and remaining limits

A maintained-source audit found 59 paths carrying `unused` or
`unreferenced`, including two graphics owners with explicit external source
consumers. It found 15 `AddrScreenUnused_*` globals and 24 hypothetical
`BrowserFrameCandidate_*` preview names. No directory named exactly `gfx/bankNN`
exists; eight `screens_bankNN` source files are content-qualified filenames
that retain bank provenance. The browser-frame renderer now names these as
candidates, points provenance to the six actual `gfx/frame_designs/` owners,
and limits its selection statement to the 27 descriptors for styles 0..26.
The 24 existing preview payloads and current table metrics are retained; no
whole-preview README regeneration was performed because it would change
unrelated rows. The address-book and page-list mixed-owner migrations remain
open. No global unused/dead claim follows from these finite scans.

The current source contains no literal `Function_BB_AAAA` definitions. A
separate census at the previous checkpoint counted 943 `Data_BB_AAAA`
definitions; after the 17 Song07 retirements and one structural rename, the
current count is 925. This lexical count is not a measure of unidentified
functions, unclassified data, or completion. The accepted entry reports also
leave the 523-group data census, bank53 name/frame associations, eight KEEP
windows, other unresolved roots and final definition-of-done review open.

## Verification

At this checkpoint: `make` produced the original 2,097,152-byte ROM with
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
and `RESULT: IDENTICAL`; `make sym-check` passed with 13,527 labels;
`make palette-check` passed (162 loads, 116 arrays, two documented
over-reads); `make png-check` passed (408 tile sheets, four raw byte views,
37 font sheets and 95 screen PNGs); `git diff --check` was clean.

The detailed private review receipts and inventories remain under the
ignored `.tmp/` task directories until their dependent follow-up work and
retention review are complete.
