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
  scenario. The trace did not identify an incoming call edge for that
  fragment, so its entry mechanism and purpose remain open.

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
