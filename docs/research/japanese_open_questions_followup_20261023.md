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
