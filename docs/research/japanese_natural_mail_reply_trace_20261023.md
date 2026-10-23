# Japanese natural mail-reply trace (2026-10-23)

## Scope and provenance

This pass adds one ordinary-input scenario to the existing Japanese-ROM mGBA
trace set. It starts from the saved `tutorial_profile` state and uses the fake
Internet/mail fixtures (`jp`, `ascii`, `game`, `multipart`, `long`). The macro
contains no `force` or `ramset` directives. This is emulator evidence with the
fake adapter/network, not hardware evidence and not proof of real-network
behavior.

The scenario `zz_jp_inbox_explore_replay` uses one coverage-guided corpus segment
(`e240`). Its normal `run_trace.py` replay ran 22,229 frames and
113,863,298 instructions, with 24,335 unique instruction starts (24,321 ROM,
14 RAM). It added 117 ROM instruction starts to the previous 69-scenario
natural union. The merged 70-scenario union now contains 78,108 ROM starts in
48 banks and 14 RAM starts; validation reports zero errors, 4,046 warnings,
and 704 informational conditional-branch records.

The fuzzer's original two-segment result predicted six additional starts that
did not reproduce in the normal trace. That second segment was removed from
the persistent macro; its exploratory result remains in the task-local
`.tmp/jp-bank29-inbox-explore-20261023/` evidence. Therefore those six starts
are not claimed as natural coverage.

## Positive observations

- The ordinary mail path executed 74 previously unseen instruction starts in
  bank 25, interval `25:4594–4659`. The source's earlier split ledger counted
  84 starts as unobserved; ten starts in that interval remain unobserved by
  this replay. This confirms substantial execution in the reply continuation,
  not completion of the whole interval.
- The trace recorded two calls from `25:4591` to `25:54A7`
  (`Mailbox_ReplyToRecord`). The current natural union now covers 104 of the
  105 static instruction starts in `25:54A7–5569`; `25:5534` remains
  unobserved. The trace observed all seven starts in `25:555C–5569` once.
  It reports `ret_unmatched 25:5568 -> 25:4594` once; preserve that
  shadow-stack anomaly and do not infer a conventional return contract from
  it.
- All 36 instruction starts in `2D:6726–676F` executed in this natural-input
  scenario. The same trace executed the sole direct source branch to the
  fragment, `2D:66D3 jr nz, .l6726`, three times. Since the shadow callgraph
  does not record conditional-branch edges, that caller relation is PROBABLE,
  not a directly captured branch outcome. The operation's application
  purpose remains open.

## Static operation contract for the Bank 2D fragment

The source at `2D:66CD` selects `wMailComposeMode`. Mode 1 branches to the
unfinished-new-mail prompt; mode 2 branches to the revise-mail prompt. The
remaining branch block at `2D:6726` loads dialog ID `$020F` and calls
`Dialog_Show`. The cataloged text for `$020F` asks whether an unfinished reply
will be discarded, and the reply path writes mode 3 before entering
`MailAddr_Edit` (`engine/mail/mailbox_screen.asm`, reply setup). The block is
therefore named `.ShowReplyLeavePrompt` (**CONFIRMED** for this bounded static
operation contract). This does not prove every possible value other than 1 or
2 means reply, nor does it establish broader application purpose. A bounded
natural replay later confirmed the `2D:66D3 -> 2D:6726` conditional edge for
three observed events; details and limits follow.

## Replay follow-up: dialog call site observed (2026-10-23)

The same ordinary-input scenario was replayed from the `tutorial_profile`
save with screenshot events added at frames 21103 and 21104. The Japanese ROM,
the existing resolved input and parent state were hash-checked in
`.tmp/jp-reply-branch-capture-20261023/RESULT.json`; no `force` or `ramset`
directive was added. Replay `coverage` and `callgraph` outputs are byte-identical
to the committed scenario outputs (SHA-256 `7d8dd8c98d7f61391946e44c04fd7d10e1172bfb832c84c348b1c2d100dec0a4` and
`77f4eb9eac1f45a2d763dd74db7929aa8f52cd7f1ab97984c96641543f477057`). The
callgraph records `2D:6740 -> 00:06D1` three times, first at frame 21103;
`2D:6740` is the `farcall Dialog_Show` instruction inside the block, while
coverage records `2D:66D3` and `2D:6726` three times each, also first at frame
21103. The fall-through instruction at `2D:66D5` has no coverage row. Because
coverage records every instruction start, this confirms that the JR at
`2D:66D3` was taken in all three observed events. The dialog call site and the
conditional edge are therefore **CONFIRMED for this bounded natural replay**;
the callgraph alone does not encode that edge.

The screenshots at frames 21103 and 21104 have identical pixels (SHA-256
`04dbfcfa2c49338f0b47331ae8f8799a97f3d4c442ce86f19bbdb95728532e49`); both
show the address-entry view, with no modal prompt visible at those sample
points. The screenshots do not establish whether a player-visible prompt
persisted. Do not generalize this observed edge to other mode values or claim
that the prompt remained visible. The replay receipt retains the command,
ROM/input/fixture/tool hashes, output hashes and the two inspected images;
redundant replay outputs were removed after comparison.

The trace did not execute the distinct candidate fragment `26:5344–537C`.
No other open entry/purpose candidate in the Japanese closure worklist was
reached by this scenario. The natural frame/name mapping for Bank 53 is also
unchanged.

## Reproduction and files

The persistent scenario is in `traces/scenarios.tsv` and
`traces/inputs/zz_jp_inbox_explore_replay.macro`; the resolved input is
`traces/inputs/zz_jp_inbox_explore_replay.txt`. Per-scenario coverage and detail
are in `traces/coverage_zz_jp_inbox_explore_replay.tsv` and
`traces/detail/zz_jp_inbox_explore_replay/`. The merged union is
`analysis/coverage_union.tsv`, with validation in
`traces/coverage_validation.txt`. The ROM itself was not changed.

The coverage-guided exploration output and the standard replay are distinct
evidence products. Keep the second, non-reproduced segment's result as an
unresolved exploratory discrepancy; do not use it to promote labels or
claims.
