# Japanese entry and frame follow-up (2026-10-23)

This Japanese-only checkpoint consolidates two bounded follow-ups at main
137c327e781eeb80bc3b7473eba42cb412a06f79. The English overlay and Operator ZIP
were not inspected or changed. Original ROM identity is 2,097,152 bytes,
SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570.

## Four candidate natural-entry roots

The four questions remain UNKNOWN: 2B:6CF5, 2D:4E42, 2D:4E54 and 29:511E.
This pass tested a new static hypothesis: a bank-switch/callee return might
resume at a matching CPU address with a different physical ROM bank, without
an immediate operand naming the target. It did not repeat the 69-scenario
coverage scan or the prior 104,200-instruction immediate/literal scan.

The byte-validated instruction index at
.tmp/agent-computed-entry-slices-20261021/instruction_index.json has SHA-256
d1c3adee39382da45d09136b8209fa4f10ef559b5c447add08c5fd83ae11891d. Counting
instructions whose physical next PC numerically equals each candidate yields
1, 10, 11 and 12 predecessors respectively (34 total). An independent review
confirmed all 34 indexed instruction slices match the immutable ROM. This is
a contiguity census, not 34 control-flow edges: the bank must also match, and
conditional/unconditional branches may leave the linear successor.

| Candidate | Numeric predecessors | Same-bank predecessor | Relevant disposition |
|---|---:|---|---|
| 2B:6CF5 | 1 | 2B:6CF4 RET | No fall-through or producer is established. The prior forced-only trace remains forced-only. |
| 2D:4E42 | 10 | 2D:4E41 RET | 24:4E3F is CALL PageList_ShowMessage; its ordinary return is 24:4E42, in bank 24. 4C:4E40 is a JR whose target is 4C:4E44, not 2D:4E42. |
| 2D:4E54 | 11 | 2D:4E53 RET | The known 2D:4E49 CALL to 4E54 is a separate direct edge; it returns only if its wrapper has an entry. No new external producer was found. |
| 29:511E | 12 | 29:511D RET | Static internal `CALL 29:50CE -> 29:511E` is confirmed (ROM offset `0x0A50CE`, bytes `CD 1E 51`); entry to `29:50CE` and the enclosing span is unproved. Separately, 68:5118 farcalls 4F:4000 and ordinarily returns to 68:511E, not 29:511E. |

The internal edge was already recorded in
[`original_closure_followup_20261021.md`](original_closure_followup_20261021.md)
and is consolidated here after rechecking the original ROM and maintained
source. At `29:50CE`, the bytes are `CD 1E 51`; the target at
`29:511E` saves BC/DE and calls `$7BB7`. The corresponding physical bank-29
bytes at `$7BB7-$7BC6` are all zero, so this does not establish a useful
callee or natural reachability. It only adds a known local caller to the
candidate's static call graph; the containing span's entry remains UNKNOWN.

Source check: engine/browser/page_list.asm has the 24:4E3F call and the
PageList_ShowMessage owner. It preserves AF/BC/DE/HL around the message path;
its renderer calls use the normal far-call helper. The 68:5118 farcall in
engine/account/settings_menu.asm passes BC=0028, DE=D800, HL=5180 and A=4A to
Palette_LoadToBuffer. That routine in engine/gfx/palette.asm saves A to
hFarBank, selects WRAM7 and invokes the ROM0 CopyBytes helper. FarCall_Common
in home/farcall.asm uses GetBank_H and BankSwitch_H to save and restore the
low ROM-bank shadow, then arranges the stacked return. It does not generically
save and restore the high ROM-bank register; the nested Palette_LoadToBuffer
path returns through its own far-call helper, while leaving WRAM7 selected.
Thus 68:511E is the ordinary nominal continuation under coherent stack,
mapper and shadow state, not a guarantee against a divergent high bank,
shadow, stack/trampoline state or external/IRQ interference. The separately
inspected same-offset instructions 24:511B and 4E:511C access the SRAM-bank
selector and WRAM flag respectively, not the ROM-bank selector.

To bound the MBC5 high-bank caveat, the current maintained source has eleven
aligned `ld [rROMB1],a` instructions: ten in ROM0 boot/API/interrupt/audio
save-and-restore paths and one at 29:5113, which writes zero in the candidate
library immediately before its RET. A full-ROM scan for the absolute-store
opcode shape `EA lo hi` with `hi=$30..$3F` found 20 byte-pattern matches; the
other nine are not instruction starts (two cross JR displacement bytes and
seven lie in graphics/font/constant data). This scan does not exclude
register-indirect writes. Across the 69 retained `mbc_writes_*.tsv` traces,
the high-bank register has ten distinct observed writer-PC/value rows and all
write value 00; the 29:5113 candidate writer was not observed. This supports
high bank zero in those recorded runs, but no candidate root itself was
observed, so it is not natural-entry evidence.

A separate bounded check looked for register-indirect writes through HL, BC
or DE. It revalidated all 104,200 instruction byte slices in the existing
index (SHA-256
`d1c3adee39382da45d09136b8209fa4f10ef559b5c447add08c5fd83ae11891d`) against
the original ROM with zero mismatches. The index covers 215,473 bytes in 50
of 128 physical banks. An independent raw-byte decoder and propagation pass
confirmed the indexed instruction set and counted 3,269 indirect `LD` stores,
including the ten `ld [hl], imm8` forms omitted by the first opcode filter.
Both the original pass and independent variants that split at control-flow
targets found zero known HL/BC/DE destinations in `$3000-$3FFF`. A separate
census of 309 indirect read-modify-write operations (`inc`, `dec`, `set`,
`res`, rotate/shift on `[hl]`) found 212 known destinations and none in that
range; the other 97 destinations were unknown. The propagation tracks
immediate 16-bit/byte pair loads and straight-line pair increments,
decrements and copies; it discards address knowledge at branches, calls,
returns and unmodeled writes. These results rule out only the tracked cases
in the indexed bytes; they do not exclude pointers assembled across
control-flow edges, loaded from memory/stack, computed at runtime, or writes
in code absent from the index, and do not prove the absence of all indirect
MBC5 writes. The static pass itself did not justify a new trace; the later
focused macro experiment below tests a concrete normal reply route.

These routes do not demonstrate natural entry into any candidate. Reaching a
different physical bank through these nominal continuations would require an
unmodeled state divergence such as a high-bank change, a mapper/shadow mismatch,
stack or trampoline corruption, or external/IRQ interference; no natural
producer of such state was found. This is not a proof of universal impossibility. A useful next runtime
artifact would need to record physical ROM bank, ROM-bank shadows, PC, SP and
stack words together with the natural caller/producer. The static-only review
did not identify such a producer; the later focused macro test below exercises
one concrete UI reply path but does not resolve a candidate root.

### Focused ASCII-sender reply trace (2026-10-23)

A later macro-driven, unforced mGBA run exercised the UI reply path for the
ASCII sender in received mail 2. It used the immutable original ROM
(2,097,152 bytes; SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`),
the unchanged tracked `tools/trace/run_trace.py` and `mgba_trace.c` (SHA-256
`51bac8391d39f36363fd2b3fc7090b780077590ef0b67a1a343bbd31bdea9a41` and
`23d57ccc25ba134332ba3c40f1e2bce3e2282b3b059a8eb14c3737eae0560fda`), and
the existing `mail_receive` fake-adapter fixture as its parent. Command in the
private snapshot: `python3 tools/trace/run_trace.py --from-macro --only
mail_reply_ascii`. The run completed 11,060 frames and 57,326,853
instructions, with 16,661 ROM instruction starts across 26 banks and no harness
`force` directive.

The trace executes `Mailbox_ReplyToRecord` at `25:54A7` once, through the
callgraph edge `25:4591 -> 25:54A7`. It does not execute
`MailReply_ComposeFromRecord` at `2B:6CF5`; the preceding `2B:6CF4` RET is
executed 16 times. This is positive evidence for the exercised reply route and
negative coverage only for this scenario. It does not establish that
`2B:6CF5` is unreachable or identify every possible caller. The trace also
executes `2D:511E` four times; that is a different physical ROM bank and is not
evidence for `29:511E`. No candidate natural-entry status changes: all four
roots remain UNKNOWN.

The retained local evidence is `.tmp/jp-ascii-draft-pass-20261023/`.
`.tmp/jp-ascii-draft-pass-20261023/traces/inputs/mail_reply_ascii.macro` has SHA-256
`6d8d175da48896680a3a5f0719ed135f97d01f7c8cb88e21e73e0c234bd4670d`; the
coverage file hash is
`6878e4f2857341f8cd4dc622c1c1dd2eb9bef0f86963f48c6d83a4dd5039a8ce`, and
the callgraph file hash is
`f54deb854a57b3f8f9ef94c8c228cc0b97363ef207f5f7720fa7e5be89892a8c`. The
tracer and libmgba binaries are pinned there by SHA-256
`95823d1793706b7c1ee6fe512cef99bfd024df87d77035ddb689de0dc1e0083a` and
`b44dfd7edb816fefa892c10dc2563d5d4bbe871d68702a8dcc3dde2532959719`.
This is emulator evidence with scripted input and a synthetic adapter, not a
physical-device observation. It does not cover the ASCII draft-name renderer;
that branch was not entered by this macro.

## Bank 53 names and frame artwork

The 25 name strings and the 25 candidate physical windows remain separate
structures. A visual comparison of the existing previews, editable views and
relevant tile sheets found recognizable species-like artwork for 23 names.
The visible identity is PROBABLE; the association from a Bank 53 table entry
to a window, selector, or natural execution remains HYPOTHESIS for every row.
The two Porygon entries remain unassigned; the two geometric windows are not
assigned to them by elimination or by the matching 25:25 count.

An independent 2026-10-23 recheck re-emitted the 369-byte name table and all
137 Bank 41-47 art assets byte-for-byte from the original ROM. Its private
copy matches the current checkout across 3,290 files except for four files
changed in this checkpoint: the two updated research notes, the Bank 29
explanatory comment, and the census tool.
The visual pass proposed different possible windows for several species than
the candidate cues below (for example, it suggested `43:4D50` for Pikachu and
`47:68F0` for Pichu, while this matrix has the reverse). Neither set of visual
proposals is a name-table association: no inspected selector points to the
Bank 53 table or the 25 windows. Keep all 25 ordinal links HYPOTHESIS; this
disagreement does not justify choosing either mapping. The two geometric
Bank 41 sheets still show only interface panels/borders, with no recognizable
Porygon or Porygon2 figure. No missing asset was found in the inspected scope.

| Name index / Japanese label | Candidate window | Image evidence | Visual cue |
|---|---|---|---|
| 00 ポリゴン | unresolved | none | No distinguishable Porygon artwork identified. |
| 01 ピカチュウ | 47:68F0 | gfx/browser/frames_2_3/browser_frame_candidate_72f0.screen.png | Yellow head, long dark-tipped ears and red cheek. |
| 02 トゲピー | 46:4000 | gfx/previews/screens/BrowserFrameCandidate_46_0.png | Pointed egg-shaped body and head. |
| 03 ニャース | 46:4D50 | gfx/previews/screens/BrowserFrameCandidate_46_1.png | Cat face, forehead coin and whiskers. |
| 04 ルギア | 46:5AA0 | gfx/previews/screens/BrowserFrameCandidate_46_2.png | Pale elongated head and large side appendages. |
| 05 プリン | 46:67F0 | gfx/previews/screens/BrowserFrameCandidate_46_3.png; tile sheet and conditional U160 view | Round face, large eyes, ears and curled forelock. |
| 06 ワニノコ | 45:4000 | gfx/previews/screens/BrowserFrameCandidate_45_0.png | Small blue crocodile with open toothed mouth. |
| 07 エンテイ | 45:4D50 | gfx/previews/screens/BrowserFrameCandidate_45_1.png; tile sheet and conditional U160 view | Large beast with red/yellow crown-mask and pale mane. |
| 08 ハッサム | 45:5AA0 | gfx/previews/screens/BrowserFrameCandidate_45_2.png | Red angular creature with a large round-marked pincer. |
| 09 コダック | 45:67F0 | gfx/previews/screens/BrowserFrameCandidate_45_3.png | Duck-like head with wide bill and large eyes. |
| 10 ブラッキー | 44:4000 | gfx/previews/screens/BrowserFrameCandidate_44_0.png | Dark creature with yellow rings and red eye. |
| 11 マリル | 44:4D50 | gfx/previews/screens/BrowserFrameCandidate_44_1.png; tile sheet and conditional U160 view | Blue heads, round ears and pale belly. |
| 12 バンギラス | 44:5AA0 | gfx/previews/screens/BrowserFrameCandidate_44_2.png | Green spiny creature with dark belly. |
| 13 ハクリュー | 44:67F0 | gfx/previews/screens/BrowserFrameCandidate_44_3.png | Blue serpentine heads with a small horn and pale appendages. |
| 14 ウソッキー | 43:4000 | gfx/previews/screens/BrowserFrameCandidate_43_0.png | Brown tree-shaped figures with round green arms. |
| 15 ピチュー | 43:4D50 | gfx/previews/screens/BrowserFrameCandidate_43_1.png; tile sheet and conditional U160 view | Small yellow rodents with dark-tipped ears and cheek spots. |
| 16 レディバ | 43:5AA0 | gfx/previews/screens/BrowserFrameCandidate_43_2.png | Red insect with large eyes, antennae and spots. |
| 17 キレイハナ | 43:67F0 | gfx/previews/screens/BrowserFrameCandidate_43_3.png; tile sheet and conditional U160 view | Small figure with paired flowers on its head. |
| 18 ミュウツー | 42:4000 | gfx/previews/screens/BrowserFrameCandidate_42_0.png | Pale humanoid with pointed head and curved arm. |
| 19 ホウオウ | 42:4D50 | gfx/previews/screens/BrowserFrameCandidate_42_1.png | Red bird head, yellow crest and long beak. |
| 20 ソーナンス | 42:5AA0 | gfx/previews/screens/BrowserFrameCandidate_42_2.png; tile sheet and conditional U160 view | Blue elongated figures with compressed face and raised arms. |
| 21 ディグダ | 42:67F0 | gfx/previews/screens/BrowserFrameCandidate_42_3.png | Rounded brown heads with red oval noses emerging from ground. |
| 22 フシギバナ | 41:4000 | gfx/previews/screens/BrowserFrameCandidate_41_0.png | Broad green head, foliage and large flower. |
| 23 エーフィ | 41:4D50 | gfx/previews/screens/BrowserFrameCandidate_41_1.png | Lilac feline with long ears and forehead gem. |
| 24 ポリゴン２ | unresolved | none | No distinguishable Porygon2 artwork identified. |

The inspected inventory has 137 assets across eight directories and 71 PNGs:
53 source PNGs and 18 screen compositions. The broader finite report covers
the 24 legacy candidate previews, five descriptor previews and the editable
47:68F0 composition; it found no missing referenced files or orphan assets in
that scope. Current make png-check also passes all 408 tile sheets, four raw
byte views, 37 font sheets and 95 screen PNGs.

Eight editable compositions remain KEEP, not missing ROM data or proven
unused windows: 41:5AA0, 41:67F0, 42:5AA0, 43:4D50, 43:67F0, 44:4D50,
45:4D50 and 46:67F0. Their source bytes, component backing and legacy
previews exist, but the conditional U160 model has unprovided VRAM keys
(42:5AA0 also contains 38 cells crossing backing fragments). The two
geometric 41 windows have no direct visual evidence for either Porygon entry.
Do not synthesize missing tile keys, infer a complete species/window
bijection, claim natural selection, or call any window globally unused from
this visual pass.

## Validation and limits

At source revision 137c327e, make returned SHA-256 OK and RESULT: IDENTICAL
for the 2 MiB Japanese ROM. make sym-check passed (335 source files, 12,189
labels, 51 constants); make palette-check passed (162 loads, 116 arrays,
two documented overreads, zero errors); make png-check passed (408/4/37/95).
This follow-up changes documentation only. No ROM or ASM bytes, repository
image files, language files, runtime traces or hardware evidence were changed
or created. Two temporary contact sheets were generated under
`/tmp/mobile-trainer-frame-audit/` for visual inspection and are not project
assets.

## Consolidated candidate-root audit at `60204c03e8637ee62577a90d68c58affea11761c` (2026-10-23)

Three independent, read-only reviews on private copies revisited all four
previously named candidate roots against the immutable 2 MiB Japanese ROM
(SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
The reviews did not inspect language overlays or the Operator ZIP, change
source, or repeat the already-complete lexical name census. Their scopes were
the full `2B:6CF5` body, both adjacent `2D:4E42/4E54` bodies and all exact
little-endian target words, and the `29:511E` body plus its caller context.

| Candidate | Current operation name | New bounded result | Status |
|---|---|---|---|
| `2B:6CF5` | `MailReply_ComposeFromRecord` | `[6CF5,6DB0)` is 187 bytes/100 instructions plus nine inline far-call parameter bytes. The ROM has zero `F5 6C` pairs; Bank 2B has no JR target into the span; all 69 natural coverage/callgraph files in the predecessor corpus had no entry there. A follow-up against the subsequently added 70th scenario found no exact `2B:6CF5` instruction start or `call/rst/jphl` edge. The only observed execution remains the explicitly forced harness entry, which stops before the final POP/RET sequence. | Local operations and boundaries remain documented; natural producer and standalone-entry status UNKNOWN. |
| `2D:4E42` | `MailBody_LocateCell` | `[4E42,4E54)` is an 18-byte wrapper. `2D:4E41` is RET. No external producer was found. | Mechanical wrapper behavior CONFIRMED; operation role PROBABLE; natural entry UNKNOWN. |
| `2D:4E54` | `MailBody_LocateCellInMappedWram` | `[4E54,4E8C)` is a 56-byte helper. The sole bank-correct static incoming edge is `2D:4E49 CALL 4E54`; its wrapper's own natural entry is unproved. The complete ROM scan reconciles 18 raw target-word matches (one CALL operand, two other-bank animation pointers, four font/tilemap data occurrences, eleven far-call field crossings), not 18 code edges. | Mechanical scan behavior CONFIRMED; operation role PROBABLE; natural entry UNKNOWN. The early `RET` at `4E72` still consumes saved BC under a conventional CALL stack; intent is HYPOTHESIS. |
| `29:511E` | `CallSelected7BB7_IfReturnsPollLyByFFA4Bit0` | `[511E,5145)` is 39 bytes. The only bank-correct static incoming edge is `29:50CE CALL 511E`; the containing wrapper's entry is also unknown. No external caller or pointer was found by the bounded source/ROM scans. | Local mechanics CONFIRMED; natural root UNKNOWN. |

### Follow-up against the subsequently added natural mail-reply trace

The scenario committed in `4e1473bdbeb9d21a518035d2cc971ef5d86b11f0` was checked against all six open physical-bank/address pairs, using `traces/coverage_zz_jp_inbox_explore_replay.tsv` (SHA-256 `7d8dd8c98d7f61391946e44c04fd7d10e1172bfb832c84c348b1c2d100dec0a4`) and its `callgraph.tsv` (SHA-256 `77f4eb9eac1f45a2d763dd74db7929aa8f52cd7f1ab97984c96641543f477057`). There are zero instruction starts at any exact candidate pair and zero `call`, `rst`, or `jphl` edges to those pairs. The same CPU addresses do occur in other physical banks; those rows do not identify the candidate bank:

| Candidate | Same CPU address recorded in other banks in this scenario |
|---|---|
| `2B:6CF5` | none |
| `2D:4E42` | `54` (1 start) |
| `2D:4E54` | `25` (8), `54` (4), `57` (2) |
| `29:511E` | `25` (8), `26` (5), `54` (14), `57` (4) |
| `70:4740` | `0F` (2), `25` (6), `48` (2), `72` (3), `7F` (7,800) |
| `55:5DF5` | `75` (7) |

This is a static re-read of one committed synthetic mGBA scenario, not a new run. It contributes no positive caller/entry evidence and does not change any UNKNOWN/HYPOTHESIS status. The reproducible check and its result are retained in `.tmp/jp-candidate-latest-trace-20261023/`; `RESULT.json` SHA-256 is `d4ab70c1d04d307631b70e4bf2150997bb5f001f9649695250c4a22f577c63b3`.

### Exact little-endian target-word reconciliation for `2D:4E42/4E54`

The full-ROM scan found four occurrences of bytes `42 4E` and fourteen of
`54 4E`. These are raw words, not bank-qualified code edges. The complete
location list classifies them as follows:

| Physical bank:address | Word | Classification |
|---|---|---|
| `5F:4D12` | `42 4E` | Pointer to other-bank `Kbd_Anim6Script` at `5F:4E42`. |
| `77:6008`, `78:4CFB`, `7B:4C85` | `42 4E` | Font data in the named JIS 12x12 row sources. |
| `2D:4E4A` | `54 4E` | Operand of the sole bank-correct `CALL 4E54` at `2D:4E49`. |
| `2F:7AFB` | `54 4E` | Bytes within `Tilemap_AbookAddr`. |
| `4C:4F9F`, `4E:5335`, `4E:53BD`, `4E:53FB`, `4E:5456`, `4E:551E`, `4E:55F4`, `74:4211`, `74:421D`, `74:425E`, `74:426A` | `54 4E` | High-address/bank-byte crossings inside far-call payloads to bank `4E`, not references to bank `2D`. |
| `5F:4D1E` | `54 4E` | Pointer to other-bank `Kbd_Anim9Script` at `5F:4E54`. |

Reconciliation: one CALL operand, two other-bank animation pointers, four
font/tilemap data occurrences, and eleven far-call field crossings = eighteen
raw words. No `42 4E 2D` or `54 4E 2D` triple, absolute CALL/JP to `4E42`, or
same-bank relative branch into either candidate was found. `2D:4E54` has one
static CALL edge, but the caller `2D:4E42` has no established natural entry.
This closes the bounded literal-word scan only; computed pointers, stack
transfers, or unreviewed execution scenarios are not disproved.

These audits do not justify renaming the four operation spans again: their
current names describe bounded static effects, while natural reachability and
broader purpose remain separately unproved. They do close the repeated
literal-target and immediate-successor checks for this snapshot. The prior
69-scenario coverage result is unchanged and is not a proof of global
unreachability. Reopen these roots only with new positive evidence (for
example, a natural caller/producer or a trace recording physical ROM bank,
PC, SP, and stack words), rather than rerunning the same raw-byte searches.

One tracked comment in `traces/inputs/forced_dead.macro` calls the 2B body an
“unreachable twin” of the Bank 25 reply routine. The audits do not establish
unreachability, and the two bodies are not shown to have the same ABI. Treat
that fixture comment as an unverified historical description, not as current
evidence; the retained macro and trace files were left byte-for-byte intact.

The results above are static analysis plus previously retained forced or
scripted trace evidence. They do not establish natural execution, universal
unreachability, or a hardware observation. No source bytes or asset files
changed in this consolidation.

### Bank 70:4740 against the retained 70-scenario corpus at `abb8e757`

The earlier `naming_70_46a6_sram_boundaries.md` note said that it had not
inspected natural coverage for the separate `70:4740` operation. A focused
recheck of the current tracked corpus supersedes that sentence for this
operation only: all 70 `traces/coverage_*.tsv` files and all 70 paired
`traces/detail/*/callgraph.tsv` files were checked. The retained
`coverage_validation.txt` reports 78,122 unique instruction starts from 70
scenarios and has an empty ERROR section.

There are zero instruction-start rows in physical bank 70 over the complete
`[4740,477F)` operation span, and zero callgraph destinations of any recorded
kind into that span. This includes ordinary `call`, `rst`, `jphl`, IRQ and
recorded return destinations. The address `477F` is the next operation and
was excluded. Reproduce the bounded queries by parsing coverage columns 1–2
as physical bank and PC, and callgraph columns 4–5 as destination bank and
address, retaining bank `70` and addresses from `4740` inclusive to `477F`
exclusive. Coverage-file-list SHA-256 is
`9e2efa12f4e95ed048a6a93b8fea90e2bc68f3a0a55830c8064e45d4ce3b9d91`; the
callgraph-file-list SHA-256 is
`5531e17069d7ce12ad7b8e797a88df26267d8a84571301e009d66973522e0387`.

This is a bounded negative result for the retained synthetic trace corpus; it
does not prove global unreachability or identify the A9ED field's purpose.
`SaveCheck_GetStateBlockBit7` remains a PROBABLE local operation with
HYPOTHESIS entry and role. No code bytes or confidence classification changed.

## Additional code/data spans checked against the retained natural corpus at `1c9224e8`

The current 70-scenario natural corpus was also checked against three separately tracked spans that are outside the five operation entry/role rows above: `26:5344–537C` (`MailSession_WriteVram1TileAndWram7ScreenRows`), `28:4BA6–4BC2` (`WramClearCandidate_28_4BA6`), and the four-zero Bank 4B record tail `4B:76CC–76D0`. The check used all 70 paired `coverage_*.tsv`, `detail/*/callgraph.tsv`, and `detail/*/dataaccess.tsv` reports plus the merged union and validation report. The input manifest has 212 files and SHA-256 `9c784734fb895133f4ea822e6a2934c98c9318e751a414c88966de1c5e6dd1b3`; the union reports 78,122 unique executed instruction starts over 70 scenarios and the validation report has zero ERROR entries (4,046 expected warnings and 704 conditional-branch informational records).

| Span | Exact instruction starts in the 70 reports | `call`/`rst`/`jphl` edges to the span | Merged ROM-data-read ranges intersecting it |
|---|---:|---:|---:|
| `26:5344–537C` | 0 | 0 | 0 |
| `28:4BA6–4BC2` | 0 | 0 | 0 |
| `4B:76CC–76D0` | 0 | 0 | 0 |

The result and reproduction script are retained in `.tmp/jp-open-span-corpus-audit-20261023/` (`RESULT.json` SHA-256 `88cb8c64f759a483c733258a72620bb8ea6e40d1d5f21aee6469ec4cc54d39ac`; `audit.py` SHA-256 `72c424298927596db118728f98c5c9016403df642f541e278550f215d3f9943f`). This closes only the question of whether these exact starts, edges, or data-read intervals occur in that validated corpus. It does not prove global unreachability, dead code, unused data, or hardware behavior; the existing CONFIRMED/PROBABLE/HYPOTHESIS classifications remain unchanged.
