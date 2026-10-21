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

The bank-2C address-book owner is now
`gfx/address_book/entry_and_confirm_candidate_bank2c.asm`, with the asset
directory of the same name. Its range is mixed: 2C:7740–7C80 contains the
candidate resources, while 2C:7C80–7FD0 contains tilemap and palettes read by
`AbookView_SetupScreen`. The engine owner is
`engine/address_book/confirm_screen_candidate.asm`. The 15
`AddrScreenUnused_*` names now use `AddrScreenCandidate_*`; three live labels
(`Data_AddrBookEntry_TilemapAttr`, `Palette_AddrBookEntry_Bg` and
`Palette_AddrBookEntry_Obj`) remain intact. All ten generic co-located aliases
were retired: their source/catalogue references were absent outside their
definitions except six `gfx/assets.tsv` label cells, which now point to the
existing semantic labels. Historical analysis and frozen configuration
references retain their original spellings as provenance (49 matching lines
in ten files). The candidate entry and its intended
confirmation role remain HYPOTHESIS; the renames assert no natural use or
global absence of callers. Preview PNG bytes and all ROM payload baselines
were preserved by the path migration. An independent bounded encoding check
confirmed the same 2,192 emitted bytes at 2C:7740–7FD0 after alias removal
(SHA-256 `483390eebbe4a0b3f6e565312a20e2df32461a077368b97b97d4594bbe21efc1`).

The bank-7F graphics owner is now `gfx/browser/page_list_candidate.asm` with
assets under `gfx/browser/page_list_candidate/`. The linked engine owner
`engine/unreferenced/page_list_prototype.asm`, all 74 `PageListProto_*` globals
and their consumers remain unchanged. Static source inventory found 102
symbolic reference lines from that engine owner to the graphics globals; this
does not establish natural entry or original purpose, which remain
HYPOTHESIS. The separate `page_list_prototype_objects` and bank-52
`page_list_prototype_messages` owners are unchanged. Historical/frozen locators
retain their earlier path, while current asset metadata and the image inventory
point to the candidate owner.

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
unrelated rows. Both the address-book and page-list gfx-owner path migrations
are now integrated with scoped README/inventory edits. No global unused/dead
claim follows from these finite scans.

The current source contains no literal `Function_BB_AAAA` definitions. A
controlled six-root lexical comparison at `41c92b60` finds 898
`Data_BB_AAAA::` definitions plus one in `zero_labels.asm` (899 total), with
`engine/mail/sample_data.asm` expressly excluded and not read. The common
restricted baseline at `5a1171cd` was 954 plus one; 56 removals/renames now
reconcile across Song03, Song07/keyboard naming, Song02 and the six bank2C
aliases. The older 959 count used another inclusion set and remains historical.
These lexical counts do not measure unidentified functions, unclassified
data, or completion. A fresh scan at this checkpoint finds no `Function_*`
labels in the maintained Japanese ASM roots or generated SYM; it does not
prove all code roles are understood. The old “current SYM retains 693” wording
has been qualified as a historical checkpoint in the status and translation
docs.

The fresh bank53 audit is recorded in
`pokemon_names_bank53_asset_audit_20261020.md`: all 25 name/frame associations
remain unproved, and eight KEEP windows still lack demonstrated complete
reaching VRAM state. The bounded asset/file scope has no missing reference or
orphan, and per-window missing U160 keys are tabulated. The data-consumer-group
census was rerun in a private snapshot excluding the protected mail sample.
The tool counted 522 neutral groups and 122 candidate sites, but rejected all
122 under its strict load-shape rules and emitted no manifest rows. This is
not a consumer map or proof of non-use; the follow-up remains open. Inputs,
hashes and the precise limitation are recorded in
`generic_data_name_audit_20261020.md`. Other unresolved roots and the final
definition-of-done review also remain open.

The extended path-safe lexical audit at this commit covers 336 maintained
ASM/INC files including RAM owners. It finds 898 `Data_BB_AAAA` definitions,
zero address-only `Function_`, `Font_`, `Label_` or `wRam_` labels, zero
function-like generic global prefixes, and no `gfx/bankNN` directories. These
results do not certify semantic function or data closure.

## Verification

At this checkpoint: `make` produced the original 2,097,152-byte ROM with
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
and `RESULT: IDENTICAL`; `make sym-check` passed with 13,502 labels;
`make palette-check` passed (162 loads, 116 arrays, two documented
over-reads); `make png-check` passed (408 tile sheets, four raw byte views,
37 font sheets and 95 screen PNGs); `python3 tools/png_rules.py mk-check`
passed (978 rules), and `git diff --check` was clean.

The detailed private review receipts and inventories remain under the
ignored `.tmp/` task directories until their dependent follow-up work and
retention review are complete.

## Consumer census correction (2026-10-21)

Manual review of every site emitted by the strict candidate detector found
114 incorrect bank associations and eight real static reader sites covering
six neutral groups. All eight fell outside the detector's accepted shapes;
516 of 522 groups remain undecided in this pass. A zero-row manifest is
therefore not evidence of no readers. The complete bank-aware chains,
classification and proposed bounded follow-up are in
`.tmp/agent-data-consumer-mismatch-20261021/REPORT.md` (SHA-256
`0235dfba74b8d468319e4e3725e471ddaeae9db02d3d78f9d82da2bf12196b8a`).

The same review confirmed a stale comment at `2B:641` for `String_2B_5807`:
it claims no direct reference, while current source has two symbolic operands
and the callee reads the string at `2B:5896`. The source comment is pending
correction. A separate independent review found the co-located
`Data_6A_72A0` alias has no active assembly operands and shares its address
with `SpriteFrameTable_6A_72A0`; it recommends retiring the generic alias
while preserving its physical line as blank and updating the current worklist
comment. The frozen region table and dated history remain unchanged. That
source edit is pending a safe validation route because the standard symbol
check traverses the protected mail sample. These reviews made no tracked
source changes and ran no builds.
